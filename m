Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0232F10BA42C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 05:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271506B0093; Fri, 27 Mar 2026 01:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248BF6B0095; Fri, 27 Mar 2026 01:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC456B0096; Fri, 27 Mar 2026 01:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9126B0093
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:16:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FD0FC497A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:16:45 +0000 (UTC)
X-FDA: 84590683170.10.3189875
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C49980005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:16:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xPnO7Kie;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774588603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1lwKMlcB2NcA7Ib5MdK2KR743BoQPUy68xOjHbOxDE=;
	b=0vujZbxfVKOj2aToYEj99EfvJgyZ2B3pal157VZt6c0LcQ8ZQ+Rp8NqjNd8hZ/a5EZ8sTR
	f/IT5wcWVeBQ7KtQPdrkncGnEL+4PpDXOURNf7MofMeUTUXtQA5A4Ee9S0TMIp2UZcjDNn
	3XTfZwWM/upiMfYYooLzWleKcuEtX1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774588603; a=rsa-sha256;
	cv=none;
	b=hxfWvI9sEBuzxZcUj92qdbWOGbeqHcskT/zvRGuLoBIcwcWNagvOvvtrub0F/AUMB2EAPP
	w8XjXWyBLo0i80H02fkcb6IuqmqS/0PEb1Absvy1MHFnUNzX7WI9IjZnFVY9yA1tmoxfKX
	QjaDVaFYuiR5L+FuRuXZ4PbZ5Tq7/gk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xPnO7Kie;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5028B443AC;
	Fri, 27 Mar 2026 05:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C24C19423;
	Fri, 27 Mar 2026 05:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774588602;
	bh=Zdu/FK4kgGyGGZ7D+Pix6NEQZD9zo341q0ONdBS3rX4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xPnO7KiexFOeVewggXCW6XtJw/rIfMofxB50wOOdcjYPWdU2KgyWK+P6bUG1zqLgj
	 0eY9HNdQieoaKzC3mNk9Mh4r2UhzyMoBCkUTcrtY0p3q+oxsf+GhSlBkJG24TJVLgu
	 RrZbPmCJKLCTR5Ft0s0neBjh8/MRKvx3whQxNDGE=
Date: Thu, 26 Mar 2026 22:16:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: zenghongling <zenghongling@kylinos.cn>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 zhongling0719@126.com
Subject: Re: [PATCH] mm/percpu-internal.h: optimise pcpu_chunk_struct to
 save memory
Message-Id: <20260326221641.7a2edff04ebb51561c8818e4@linux-foundation.org>
In-Reply-To: <20260305073043.571691-1-zenghongling@kylinos.cn>
References: <20260305073043.571691-1-zenghongling@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 95haw3n4g6f1oow38zqg6dbma4qewthr
X-Rspamd-Queue-Id: 9C49980005
X-Rspam-User: 
X-HE-Tag: 1774588603-375326
X-HE-Meta: U2FsdGVkX1+vd5bqxuHN/BZIL1rgNxXhN62Tq9mODK6t7CF6f6sHtjepMvL766ehISby4sN6ZE+u/LDVpZ1puTlFHanweEHk4nbD0qbelIP6y8qUy44P4+5xv0WEHJru356iPnsd58kIYV4D3fpuApLU6y80KXXgwQd0i7dJX6J4zXbnGlN4ZZPuyf0Fk8S2maOp2n2h0/ifborUx1Srt9QvWWNb0bWfqers5/Kh5jEOEUzWKADRWfi4h3NTFb9at6wy/VtECxJnzXfzXuV7acea5EtktTSRx4sYMqXpZ/CkJGBqvyvAbofHem4zBn4ImE55Q8cNt9byXzU8c4DPRv41OkhjmiuxkZmzIC4BUSlWKmbfkoCcUG+DetHshAWLEEPED34cPJTvEz7r+WFhLfO9i4nhucngXMeruXNE5M2/ejIBH4C1jfYGASNn5QQKHUcBEBugHhqa419l68Hu/g9FNSpSIblEPTzgZMLhYjdCIzthOx4ovEwa2P6jQYab2q70wf7wAL5JrUOe5K91HxkzcTeKsHKMRlAekueT47wFdwDhQYybHdDguhVCeseEIdFSswhACqHA76dCMUasLa5E3TIAy4cUdWYWDs+/v2XtfQ4+nDNMDwqFfqIihMrqxCEJVkRMb5nTAdlqWxfDwnxURrzMtAQZTdHxDCAfUgn6xac7BRYMbf9hXsGcQjJcTtsbStM1y4HNrFYz/vVxEVnlKSb/jt8Wl8yUKi8jjmYd0vJX9f4ZTy6sAGOa/rpSx/gu3iS/+pUhHC/TAF2F00el+PXv4Vk4STkd7peLMrhC+z8CtyZYlEcNNa0uGoosKalbwqkxCcRs9kZh7EIN7tNtFZm7tg9ngDt2SIwcvUEV6K/TvjL81t1Zn1gXSt1qhN+SpNJCRVepZ9WPreZBO3OFtKVjcV5IAUo6EQecfNYyrrhr7bTYHNAolLQNG2mTDW3lIyLuBK4RzMINhpn
 k5Hr31qE
 kWMslVnh8HtjLLLvyCe5gxlPYv/9TrGfFnxxni4sDUIA3frAx5rynLh4v46P8kp2F19nEArF7YEGsrh3Mknwz+2+6brmP2TfZLl54ot3d9vvy+m8TpHYQgl8EueuxMUbNPShizKz5DtaHOujdwp0i9t5+RU0F20gUurIUQnS4WwjZW6h6bfNzVYq7Knms28o89dUcgyXAJK4KuqQnygiklm1A2TGr7/eSeqokktHRl+vZTCIE2+bYDkNZJ7ungmvWFp1+N/JzQTVdnmKet7D4GZy4scoMz6YT1DPu8NhKDZlWLc8cw/MYDz9NKzybpGVb8UfhQ0tl4ET5E4nquibRkTZQglInUjSLWNtM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  5 Mar 2026 15:30:43 +0800 zenghongling <zenghongling@kylinos.cn> wrote:

> Subject: [PATCH] mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory

There is no pcpu_chunk_struct,  I'll change this to "struct pcpu_chunk".

> Date: Thu,  5 Mar 2026 15:30:43 +0800
> Sender: owner-linux-mm@kvack.org
> X-Mailer: git-send-email 2.25.1
> 
> The pcpu_chunk_struct has a hole of 4 bytes and pushes the struct to three
> cachelines.  Relocating the three booleans upwards allows for the struct
> to only use two cachelines.

before:

(gdb) p sizeof(struct pcpu_chunk)
$2 = 256

after:

(gdb) p sizeof(struct pcpu_chunk)
$1 = 192

That's remarkable.  It was an allmodconfig build which tends to add
bloat, but the only source-level alteration was this patch.


Another consideration here is that moving members around can have a
performance impact - it can cause more (or less) cacheline
invalidations.  I worry that because someone has carefully commented
all the member offsets, this might have been a consideration.

Also I think your patch may have made those comments incorrect?


Dennis, Tejun, Christoph: I think we want this space saving.  Can
you please advise?

Thanks.

