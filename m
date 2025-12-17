Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F9AD6406C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 02:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915336B0005; Tue, 16 Dec 2025 21:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF416B0089; Tue, 16 Dec 2025 21:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC556B008A; Tue, 16 Dec 2025 21:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4496B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:37:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35629160897
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:37:08 +0000 (UTC)
X-FDA: 84227400936.06.3E1CE82
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7E9F5C0003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:37:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lzg5sj2A;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765939026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5aRivHaTbegQNkRt7bHX8ZRS4dbuKQr87Iksclf1c8=;
	b=HRY+bwG3zK7iLmDqFiPj+lDfDZQOQYJeNxk/i3sl57NgASts0dBpuiqgWEP5WskqeTPoJ6
	sTMywQd52FFhoNuvYAauEYaugsM7wBcnvfUleHXUaQOmVX/+m/QoDP6GN1DQ6TSh3HXF3l
	cBQu3Xo+tVzDwCVQfkV8y01bK4+3qss=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lzg5sj2A;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765939026; a=rsa-sha256;
	cv=none;
	b=hszqCoKvHgXViJQQZ+g0GRde4YiD0zAG3bQV3kr/JHONbs7dQBC/VUwSbWS1RSsOYD6ki8
	TmmaXjQbkipGgU3oHFDYmi2ev+CI5TZ6rzILpi9zVLjNTYCuLwxF32H8OTALgmn1ELYTog
	MILB4GhDmifkquvL3S0qGoy8z/AKCho=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765939024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y5aRivHaTbegQNkRt7bHX8ZRS4dbuKQr87Iksclf1c8=;
	b=lzg5sj2Af0uN5n5WEceRyn60EP0Y1NDyr7zCCa/DJy6H+UD5tVVHmYd20vrXxUPZj2Zvxf
	wdiPid6tfeyabO61YC4gaoHfpdpvckoAx4zMi8BysVSYTaif2sGJ2A0PR4kDtQJJ8Lg8s2
	GYDV7lpx5CoriRZmPpfY/JW93ODHF5k=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH] sysctl: Remove unused ctl_table forward declarations
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org>
Date: Wed, 17 Dec 2025 10:36:24 +0800
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 John Ogness <john.ogness@linutronix.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-hams@vger.kernel.org,
 netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8975859D-F82B-4829-9744-171B7EBEE749@linux.dev>
References: <20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org>
To: Joel Granados <joel.granados@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E9F5C0003
X-Stat-Signature: tc6kpwms76z5o5hieqkhni7c7e77xdxw
X-HE-Tag: 1765939026-236603
X-HE-Meta: U2FsdGVkX19lffRr0K0WOzdhp3W+SSbsHYmoMwsyu5UCkZW7xGbmqXvi5cDfVER0PZQNRprXn3n54bJTcvm3s+4UuImUK1z4ul2ujkYy1gWrHQlrYK8iM4KaP2ANEziyG39FXFNxqVtfgPeq76nRPGV5+7ZmGewMShoVd/u3M+pdJS9XrsV7Axwds7cvG5UdQ/UAf/PQcRX7Sy6ZFYFGvUjKfRYdSITkyYaTIdlXQdA7ty32a0HmptFZIHOPBv1NtD3W9tGRdNv8ak8QDbDk7KyCqJJwgFhKZ7k2NzVQVeL5mhmdPDX0dn2xxtYSUxBxOEBRD9uVgkpx43p+2Gm0YAckd+z3iFAFalX3Z1UGJTH7+vbm/RQXoj+l+x28kTFpqG9boCbNuNG7Q3wKqwSZpbTiauKOiHs+Q7FQkrDDsYcG2xgy5Htwf88SzNa2mpmM8t6F1kgcsxwaUdEzrG9VnkCZhVqIGIUqKv13uScYROq9flq3EnVVsiXOJlCHUs9FTN5UwGlCX8JTLiCz0rs3UpV4bu7W+TkItn5H8dSDC1EuE2Ne5DFDUsualfShaNCassit1TheoisapVCxYXVvV/g47gRllrLVpV7L9h8YBJVGH4K1QKccrJR6pxI0h8/ZF3cYD0iy35bw/ikftwrds5zMyKC/tmzCHL9fhp7Gw0kAAtIll+lcmkft3llQRF3gkLSJUF+f8bFPHSX+CaIWxYQ4M8gALdn6RyxULrUNR+uwb9wRX5D3X6MQ7+rYO/G/+yPeduf/gc/5DW9mTE3Lkjzx3alclbNUyv2Sd8d2HK1SL2jfIqd82FU6XJZfCpTIEgh1bvtAPSzS9BZBMXTyWcT4n42cX7tTIE15NQI4oerlU3wV0RKQOPMmPuqiRgTqMH+2qr3ix39z5Dc25a5Dirhkhgwnlx7q1crE6xWuxuRyzmgWI49Mw7QF8T+kviG7g2T6VL1A7T9UGHdtLXu
 7IGpMJ0A
 N4aS9NGEE/zFl/khlsiebQr8dbIwNW6odg7R58VXrnlUX36j55YGD0BhX9fzhOg2yEv+oQ1vGilynyXov96Wsd2FjCYLi9GexZi7qcAXZIhI0/ayMfQPf87gwHghFuibN/llTLy+LfMR/Okf2S56Y1r1oALZLNQltjmZkc06A86WPIryx0G43cwzLZwY7i2HOXxOXE1g17cKcMCfnC4ACYPaol/QjFJ3GFkpYYp/DavrUl/iHtHcOhYED1JtIQ9D9oW9ymn8Z4groHRr89DwB5E7IJlXGCmTbMbz0+mZR+5U/g8iipfKaGBMhLgtTBnwbSVHWCc0sht3f+9/j4UryW8wxOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 15, 2025, at 23:25, Joel Granados <joel.granados@kernel.org> wrote:
> 
> Remove superfluous forward declarations of ctl_table from header files
> where they are no longer needed. These declarations were left behind
> after sysctl code refactoring and cleanup.
> 
> Signed-off-by: Joel Granados <joel.granados@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

For HugeTLB.

Thanks.


