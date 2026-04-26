Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3101CFF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2096B0005; Sun, 26 Apr 2026 08:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8828C6B008A; Sun, 26 Apr 2026 08:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797E06B008C; Sun, 26 Apr 2026 08:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF806B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:35:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03BE71B7CE4
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:34:59 +0000 (UTC)
X-FDA: 84700651560.09.9C99955
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66BF440009
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:34:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fcxiKN5r;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777206898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKbTS9iRsQYvXb8uofILDdWjS5pBKx09kXH/B9KI7IY=;
	b=kLZ2Y2QmLLMgrT5/hLvEy4NNeEoNhjNwBqmrBK/Yo1ZnK3YiJVac2NgF/qAdmgUtCPaYWY
	FlVzQKvvZ3ZP7PrOVeIXTCRIS3OC6qWDVE3xaulxy9HhOQwMX08/x5wdcGoFH4JttuX55f
	oBuT2hBpvdld7239NfmjathlaV1me6A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fcxiKN5r;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777206898; a=rsa-sha256;
	cv=none;
	b=elxh0UMAQpu1w+g0KWO9xwIszpiF7+IcOzs0Bn7KFiDA2uyq4dArV+2nrHgT6wpfg3Fl/x
	CxOfavLE/Xe0uTdVDqoDgLsJ2+VQ6XaGmpgsVOP7tFKiLc5D1LYE5wIipVLZPgwErtAne/
	/GDVtTPnLby2YdD3F2yCa6IbhHTBiCM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D90660120;
	Sun, 26 Apr 2026 12:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA71C2BCAF;
	Sun, 26 Apr 2026 12:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777206897;
	bh=BaSaKLFcdJ+SYi5Kybvkce1qiCJ+Moij9HYFUQ8DY2M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fcxiKN5rSz+bLNRnfPlWCVNiwZdMQHiXq8jp8dmXPVZ5kTaH+NOl8+71ePWUnWN0e
	 NhdjG8fmfRLFCbhVLPF3TELHbG/hLx18MhzGBq8F46N2vsuUCITTWM2BtUNoU67RoD
	 /6H+5HN+eQBtHXsXcG41Yhd5rrZtFQ4pe8eZPsCs=
Date: Sun, 26 Apr 2026 05:34:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Mike
 Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ritesh Harjani
 <ritesh.list@gmail.com>, Christoph Hellwig <hch@infradead.org>, Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Chuck Lever <chuck.lever@oracle.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] testing: add nfsd-io-bench NFS server benchmark
 suite
Message-Id: <20260426053455.4c06140446976964e6fbb8ab@linux-foundation.org>
In-Reply-To: <20260426-dontcache-v3-3-79eb37da9547@kernel.org>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
	<20260426-dontcache-v3-3-79eb37da9547@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 66BF440009
X-Stat-Signature: 7ubf5ekhyahhqrx7fn5nw6iuh14mw7d1
X-HE-Tag: 1777206898-393914
X-HE-Meta: U2FsdGVkX1/JpFo1FmWqXWBJXT/ZqEJJCVY3QR0baDD1XKTMAlidw0wpCDHWw/j80ukOXcyjl7SAiBvwS86MooEOfMJj18gl7CqTZOkqXPBFs4dCLt6B+VsJ/hgBUDhp29Jy7v2dtMFQ3LU9gxDan+Dqr9P3A533UdVIAPXoGZPnEcS3bvbc9J5/uCD5NI8RrQQm++Kuh/JqXjNDT4jD6GsvMnkysc7xq5Tfl05ScSfXZAQqTkiW7qZL/GXuNT1N+XRTK2TGdRD7ETsQ0kaWNc2eLlKcyoEguqTA7j/ZBQtITaHB35or3AOQ7dw8iZd2AArm9hQEffC4yqwEZXPlExN/+c9K5dXS+SrF6KnlY7c/PA9v8WONdQWF932KZ/MEyEp9I8aPPS8LtkKZo0rvwFNPJZ36b2u/2zMYLdesEsXyWnh6W9rhLEz7LWAgrddxB3JNOBH0UGefndn8t3lk0plBvH/kKHQll4H9Jc13wcE9dvDc+quU/6xDO04LpNlAP+zgCOG6oRXVIIUcovx3ywJGWTt9ciKGi3yURKzmMe+CDZ939t5V1+pztxOavO0S2D/RP37xOjaNmD//ykAAgkvafYrGJVSgaYSxAoP+kFjuCn+TzGMUVMMkEugf/Vw09u+6RHkpXEOf9mnx97ZFtBJycSZ0v8qjBSQ0qBy6ILIatVjAtOmNrUNPXCjbGgA+tHzGDUqz91ZCZwiTVQKhnv6ymqEg7obdb8QTcJ2LgbXk9KxpBba++WHdB1w/tuST7zyep5cqu0ZompqgbqOI8w8zsKGqOyW/bFI1dJ0DWQRmGz3o8vy3ULHJvk7qjotUUhrH/CJOxp/kDMN2+gwdwWKd7zS4sNXS6KCENLzZ9a4txBzX8kBgnm+PGKeRFoW/HRsUfY6B/sfxnNIUWnc6tVdhWLznCmU+ueOGxR/emfEKzDqD6Q2OpkYy2UvyXJTl5xT97zM1aDlmF0msZ8E
 UFyrbQRl
 UhHXETwtvf4xq/Ea8Uy1cJ3O36Fd5QtUVlO1Aw0MaLc1oj4ek6hORfnRRq7bD73fumP9VXWJMk1MZSydyDVSjnqoZwjGNIz1g9/TXA46p4nzxPN0Q/AMcnOnuBoKbZERYvLSEgkSoLMDwz1wllA5IqlwYaFn7epun4x7Y/NFyGkLP3wIGHZ+1RaUbIfamAsZJjp87mp3f0jnEXC7C4Q3awIaacguag54sIGZKRKlqquGqd0hUyONjS2giyp/ZqGjoioY5zKKMpOXIGbQ3KXLTKOA2HUUFdhJPljaxIOBVbH7449R1m8POeYGQfnGfqikn+Gr326ZRmSJkDOZzDIbqV8bDyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 07:56:09 -0400 Jeff Layton <jlayton@kernel.org> wrote:

> Add a benchmark suite for testing NFSD I/O mode performance using fio
> with the libnfs backend against an NFS server on localhost.  Tests
> buffered, dontcache, and direct I/O modes via NFSD debugfs controls.
> 
> Includes:
>  - fio job files for sequential/random read/write, multi-writer,
>    noisy-neighbor, and latency-sensitive reader workloads
>  - run-benchmarks.sh: orchestrates test matrix with mode switching
>  - parse-results.sh: extracts metrics from fio JSON output
>  - setup-server.sh: configures NFS export for testing
> 
> Assisted-by: Claude:claude-opus-4-6

OK, question.

>  10 files changed, 1024 insertions(+)

Seems that this code was largely machine-generated.  So I assume that
you're in possession of the scripts/prompts/whatever which were used to
generate this code.

(Can you please briefly describe the process which you used here?)

So how are we to maintain this?  Will other developers have to go in
and hack this machine-generated output by hand?  Or would it be better
to provide (in-tree) other developers with the means to regenerate this code,
presumably using Claude?

IOW, this feels a bit like shipping the .s file without giving us the .c
file!

