Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82819105A587
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20426B00A5; Thu, 12 Mar 2026 07:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3896B00A7; Thu, 12 Mar 2026 07:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D976B00A8; Thu, 12 Mar 2026 07:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF0766B00A5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:27:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83A691C0DD
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:41 +0000 (UTC)
X-FDA: 84537185922.27.EE3EA95
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25A0AC0009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BvxIIgj2;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPXJyGBg0VCD2dD6/oTF6b0wi6zPzX8RP3M5CwtcH6o=;
	b=NOVPV15LSrdEduCPSSISVUBxP/pd2YZqh3vdgEXAyXNb3dsrAxNQ26Rs4oY0cfzRbS/D6m
	LsQBPDe6V6hJ/bnpWpxDhMi1yVoGPYzU88DTQgwiHNnLoPcxJrFQSlBBa9WUrwQoYthh7k
	n7dHpKOOX4s4rVqfdynpDZj66hIsONM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BvxIIgj2;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314860; a=rsa-sha256;
	cv=none;
	b=psIFMBvyF2oWfns5dfQjOvfZJ5oV4ev5cFqelDHHB4RyCK9YFcV9+286n5kOIU0dE8VV3f
	SVTzSeVQrjC/xrEw+uIX/dnAdV8nALXCGxctzc9hgku5Z1bw111P/pRxBla4DMFPY6sdYq
	p1AzISxW1BocAR0kuxEjoHYlD0ebgRg=
Date: Thu, 12 Mar 2026 19:26:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773314855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DPXJyGBg0VCD2dD6/oTF6b0wi6zPzX8RP3M5CwtcH6o=;
	b=BvxIIgj2ecH+uS8Yt21D0T/FTb2aMEZTeNpq4psgOjBtMVRy4TtcGDCvGlQPr2slKw6bgd
	YTiowX1jStlVqYaConFXu+ZQLUytz7rO+5dRNeva1uRhRoZyyDuZmmwFj0Bl+YN9R5upfK
	I6ugQpDNy4U3gWWyjE4o4ufLodZwLzM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Ming Lei <ming.lei@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <fbssy5y6kpyjlefacmabuojiustr3nocj7timpgejpchkj3lw7@qfss5ffmwdxa>
References: <aZ0SbIqaIkwoW2mB@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ0SbIqaIkwoW2mB@fedora>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25A0AC0009
X-Stat-Signature: m8jns1wr1df4bebd4139twthxb1ftnkc
X-Rspam-User: 
X-HE-Tag: 1773314857-340448
X-HE-Meta: U2FsdGVkX18GI6YA1ibEQDUt2HhaPly2TxbLoroAJp3jk4J+Z7UKmYmy4ntvQPI/HY8fMg9cCKKnGOniCDp9+SY3IEDyyRmA4mdqd4yOTjxTLk2TJ+lhL7JA03ORl1FaOy6Xfq/utHZ0qFb3bR/ND5nv7RXLV05c5UBl3kNbCtWDC1nN1sEoPMVQMCRKF28skdZRFqxd7bvxFnJLCf6MkwgJj5bPp2h1ONRlwoCak2+ib2xbXjUyahFMcxjJRhK5tLmK02gh1/E06QtYRwu2DNrSQ877k/8zkdvtXHa07RRyZkL8We9Qtd5uagL8KNoF0xsdWLzuo8MRgRXvXCOESA8FvvCSNA5oY9VmG8iVKqzLtlFjbGADOVeOYgwC2GaL1KUMzpsuIpTdsluo4Ui/uHHB3IFqXvYxPJILBBxwLbZJL9lBWbeFLgLt5mT7qQMre9FvD9dZ9eitKvkY7EuV/XagNQGEkIukIIVDzD5o65cussNUcIQY/PkYmtaKfCN+wXojSQbZVey7ltAX6I/12n1cmzu/OSdTdA899hsUdXt+oKi9QgGmQtSa1Y2o8paCijwk4IjfA+X43EkMTUPfcfYKKGgn0sicNfjUiZLUwFz0yy2mosh1R/lhRAjbxHvjv9L+e6Yk/8VBlmR3POCvMUBQkzQhL+4nI+40m0m72KEpdwDPlmye1ktXdgPhiscbRJu/q2ZtYss6Easom0y7jSgCEhjXfVRNKuUud13ReSMeAWXG1wIAYcfh2tamLC4HUwj3uwraFv4P0QotdFG4Zpt4pGhaIRDZ7WwJ5A3t7Q2TZI33nN+RiJy+Y0C5rNFiTgZ+oaZKSB0I3AZdP/bXyD/CUjCdPh1aSE6AMNe46XRpv+MOSXVRt5kcIVcMwid8+WiyOewG2KCmlFxniZAfNkigSelAJXurNs7UqfOYMwWp2fYKu5nVw1e9WAt4EOwBIOpr1a8NWBLslNaMgae
 804XENlw
 AF485/BK/1s+y/kfcwg9vdQ3ZmhAYtekKtf62wSDv5Jqw4G563B6SUP2/61kiJgmpvsW4lqg79JzjSh104cnieJA0SJQHiVQcrYZMAV9nI71+Qeteu1Ba8uOi7pRrKdZvtk4MXh4J+e8jiveEouAO2ncZUvGmsPVkpQLrstWT9ggomKHFtQIbIb0YwR4Px38U/yxlCAzuakeSW68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:52:28AM +0800, Ming Lei wrote:
> Hello Vlastimil and MM guys,
> 
> The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> performance regression for workloads with persistent cross-CPU
> alloc/free patterns. ublk null target benchmark IOPS drops
> significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> drop).
> 
> Bisecting within the sheaves series is blocked by a kernel panic at
> 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> paths"), so the exact first bad commit could not be identified.
> 
> Reproducer
> ==========
> 
> Hardware: NUMA machine with >= 32 CPUs
> Kernel:   v7.0-rc (with slab/for-7.0/sheaves merged)
> 
>     # build kublk selftest
>     make -C tools/testing/selftests/ublk/
> 
>     # create ublk null target device with 16 queues
>     tools/testing/selftests/ublk/kublk add -t null -q 16
> 
>     # run fio/t/io_uring benchmark: 16 jobs, 20 seconds, non-polled
>     taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> 
>     # cleanup
>     tools/testing/selftests/ublk/kublk del -n 0
> 
> Good: v6.19 (and 41f1a08645ab, the mainline parent of the slab merge)
> Bad:  815c8e35511d (Merge branch 'slab/for-7.0/sheaves' into slab/for-next)
> 

Hi Ming,

I also have a similar machine, but my test results show that the IOPS is below
1M, only around 900K. That seems quite strange to me.

My test commands are:

```bash
tools/testing/selftests/ublk/kublk add -t null -q 16
taskset -c 24-47 /home/haolee/fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
```

Below are my machine numa info. Could there be something configured incorrectly
on my side?

available: 8 nodes (0-7)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
node 0 size: 193175 MB
node 0 free: 164227 MB
node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
node 1 size: 0 MB
node 1 free: 0 MB
node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
node 2 size: 0 MB
node 2 free: 0 MB
node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
node 3 size: 0 MB
node 3 free: 0 MB
node 4 cpus: 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119
node 4 size: 193434 MB
node 4 free: 189559 MB
node 5 cpus: 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143
node 5 size: 0 MB
node 5 free: 0 MB
node 6 cpus: 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167
node 6 size: 0 MB
node 6 free: 0 MB
node 7 cpus: 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191
node 7 size: 0 MB
node 7 free: 0 MB
node distances:
node   0   1   2   3   4   5   6   7
  0:  10  12  12  12  32  32  32  32
  1:  12  10  12  12  32  32  32  32
  2:  12  12  10  12  32  32  32  32
  3:  12  12  12  10  32  32  32  32
  4:  32  32  32  32  10  12  12  12
  5:  32  32  32  32  12  10  12  12
  6:  32  32  32  32  12  12  10  12
  7:  32  32  32  32  12  12  12  10


-- 
Thanks,
Hao

