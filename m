Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0ED105A58D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB776B0095; Thu, 12 Mar 2026 08:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168FF6B0096; Thu, 12 Mar 2026 08:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0757F6B0098; Thu, 12 Mar 2026 08:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6B6A6B0095
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:13:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A87D1401EE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:13:44 +0000 (UTC)
X-FDA: 84537301968.12.B946B1A
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id A02A9180002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:13:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rIKdLdcF;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773317623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEo+AU5jak9Tki+9cRYeuDI/fkIxZPTyffIn30O4KQo=;
	b=YGNeP7HgXDc+gtb9lw5FSt78sJ9X3KeVtV3fTcftdr3PHg3/jLr7AWf4zOH/VR7cMFGUn6
	AOIOoqG6WL6JRD0xeVgORz8yI23mJ2QduGCo+xvWTP3jRGlJQbIcCFniZXmf3X3h4FHl1S
	XFoJvwbxnhI46VhGvIH7njTncu6tWJs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773317623; a=rsa-sha256;
	cv=none;
	b=BSssC5kz8QJFS91HWydf1PmtMbvxcQQBnlzRT3uQ69QSr2MXvIa846jSp4ZdjF8ctmNZKw
	eR0fyuAXczs3dXZLdBCYTOqqdW5k1GVeaPGvLb87viItGm0DEDRkdWe7bfw2N7ZXE/QBge
	duVq6rA9vc4ks+t2aljjiszhTxTv5Lw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rIKdLdcF;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 12 Mar 2026 20:13:18 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773317619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jEo+AU5jak9Tki+9cRYeuDI/fkIxZPTyffIn30O4KQo=;
	b=rIKdLdcFCw7xuYn7MgGpUGaSmWH0HYCuC6qQbE9EHLb3k3Afdm8jYOLHP5q8+bbi9hs0cj
	/DzlykMtdvkZ9RBCEjqkkPUjWf0kbd3vHLWH2STpSVbjtpn+q2FwxxmaKPftg1VXb2k/1V
	A/TnktqOu5hpsFLnk1WY7/XkKXGwSvg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Ming Lei <ming.lei@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <iypdqo2s5oobenjrmoqqplgshsz65bwegih7kxhgd547fcofm7@yb6xqors6snx>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <fbssy5y6kpyjlefacmabuojiustr3nocj7timpgejpchkj3lw7@qfss5ffmwdxa>
 <abKp7-HzFT6llbYT@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abKp7-HzFT6llbYT@fedora>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A02A9180002
X-Stat-Signature: iqrhkqds1awx1pfefk6ixskccex9hnwc
X-Rspam-User: 
X-HE-Tag: 1773317622-494799
X-HE-Meta: U2FsdGVkX181ya1K3nxl5MKiDDPy6oEwh5zT8JuCVReLOytqGOs5jh2+QlO2A9ApXTkSL9QdMfFoU16T2wDCtMr5EwHKjyQTDQexjkfdLRmKKK/VwfS4raRTt6fiSvBvYDsSK+Q0adqx8HFaAgjXqTwb9t3HO+HXbk0AyIG2NhtEPelYBsdc5KXVGKnYMNC10gTDFfHJ8C6ojRH3Zn49Xu8AZp1+QXZ6c6ZgrJulh9MDiJroiAO1TjQT8x3TAHu0htQYU9H2XRN0tlCceyaMNuFyzlGgk6rIOtjLcM51qJ8BI1O9fcMIijL+trfEUw0fY2zMshYlC9f+khAVfPspIPvq7Vu/vwIZkZl1KPeNMhUFMV3Zczw4PbwF1Tvzc1NXBwkIDLS8ZHe77zHLXs/5XhvKfH8dphhJZik2iA/pUa8XtH7Go4cUke+zcw6xZCvucJafDWtSHkijrwhj+yyea3Anr9cLUU3KVnL7z1DjbtIbsbuIRm+hibeGLum3oCP4i9znFuYC4FZKeYSh9YBZQrMC5DgyuuG4ZkksDRQRHuMKMvN0DzrN+klPzS6/MdUs/u0rjniqqFkiWcFGl1nyUTf6W0JrBNWxMzzbSr0hsgqNzuhWimHALsnk3b0MBOIRlulRo0aYjPz9p80rPYFS8KQcs49RBZr0byB5m5/w1hzX8ccWeS869lP91xkWtWhCh6/dTV4u+Cn/G6FFdfSK7L5VHUxD+9xoEJeoB2TP7j+oDnIALxNOC2Y6ZY6ULzN+YtyZDdu2MZBi5J1XqTg8QA6BCW1e46YmoJfk9jtptZ+ELWs8rxPzeQR+fgJEkBEOEO4FP0gqA10V0VpiqRPUSRDIzLtJvZlgrWFOH1IfXQLVsjxCEbFYnWgZWUAq5/jhEulgyivBUZO+ByXZqW1tZQUFo7wEreyDn5gyBtfxwr16QMCWaw3B0B9AVRzwMtEEiOgZ+WF2vhKNYU5ecKk
 Bf/8AxgZ
 W9qnABkTQW2OdROvYz+S8sZ3Dd6vDOY18j3HY/qnttBgQ7UED/3831zCZW2KhDLQBE4oUYmK/bakxl8Z5rP52K/7CN97efzf+2Sjox8igvfrZrhU0kevkA4oU+FooRCyCrWyIa6OJja3BzwCEKJpit2ug3ToFGnZ1jyVh3EYVQndr3j2OSdiz9VlbOB436oGt9+SopzgT0iAfmQdf96L5Ds//lsyPiP1zZV1V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 07:56:31PM +0800, Ming Lei wrote:
> On Thu, Mar 12, 2026 at 07:26:28PM +0800, Hao Li wrote:
> > On Tue, Feb 24, 2026 at 10:52:28AM +0800, Ming Lei wrote:
> > > Hello Vlastimil and MM guys,
> > > 
> > > The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> > > 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> > > performance regression for workloads with persistent cross-CPU
> > > alloc/free patterns. ublk null target benchmark IOPS drops
> > > significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> > > drop).
> > > 
> > > Bisecting within the sheaves series is blocked by a kernel panic at
> > > 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> > > paths"), so the exact first bad commit could not be identified.
> > > 
> > > Reproducer
> > > ==========
> > > 
> > > Hardware: NUMA machine with >= 32 CPUs
> > > Kernel:   v7.0-rc (with slab/for-7.0/sheaves merged)
> > > 
> > >     # build kublk selftest
> > >     make -C tools/testing/selftests/ublk/
> > > 
> > >     # create ublk null target device with 16 queues
> > >     tools/testing/selftests/ublk/kublk add -t null -q 16
> > > 
> > >     # run fio/t/io_uring benchmark: 16 jobs, 20 seconds, non-polled
> > >     taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> > > 
> > >     # cleanup
> > >     tools/testing/selftests/ublk/kublk del -n 0
> > > 
> > > Good: v6.19 (and 41f1a08645ab, the mainline parent of the slab merge)
> > > Bad:  815c8e35511d (Merge branch 'slab/for-7.0/sheaves' into slab/for-next)
> > > 
> > 
> > Hi Ming,
> > 
> > I also have a similar machine, but my test results show that the IOPS is below
> > 1M, only around 900K. That seems quite strange to me.
> > 
> > My test commands are:
> > 
> > ```bash
> > tools/testing/selftests/ublk/kublk add -t null -q 16
> > taskset -c 24-47 /home/haolee/fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> > ```
> 
> The command line looks similar with mine, just in my tests:
> 
> taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> 
> so the test is run cpu 0~31, which covers all 8 numa node.

Oh, yes, this is a difference.

> 
> Also what is the single job perf result on your setting?
> 
> /home/haolee/fio/t/io_uring -p0 -n 1 -r 20 /dev/ublkb0

If I use this command without taskset, the IOPS is still 900K...

> 
> > 
> > Below are my machine numa info. Could there be something configured incorrectly
> > on my side?
> > 
> > available: 8 nodes (0-7)
> > node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
> > node 0 size: 193175 MB
> > node 0 free: 164227 MB
> > node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
> > node 1 size: 0 MB
> > node 1 free: 0 MB
> > node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
> > node 2 size: 0 MB
> > node 2 free: 0 MB
> > node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
> > node 3 size: 0 MB
> > node 3 free: 0 MB
> > node 4 cpus: 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119
> > node 4 size: 193434 MB
> > node 4 free: 189559 MB
> > node 5 cpus: 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143
> > node 5 size: 0 MB
> > node 5 free: 0 MB
> > node 6 cpus: 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167
> > node 6 size: 0 MB
> > node 6 free: 0 MB
> > node 7 cpus: 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191
> > node 7 size: 0 MB
> > node 7 free: 0 MB
> > node distances:
> > node   0   1   2   3   4   5   6   7
> >   0:  10  12  12  12  32  32  32  32
> >   1:  12  10  12  12  32  32  32  32
> >   2:  12  12  10  12  32  32  32  32
> >   3:  12  12  12  10  32  32  32  32
> >   4:  32  32  32  32  10  12  12  12
> >   5:  32  32  32  32  12  10  12  12
> >   6:  32  32  32  32  12  12  10  12
> >   7:  32  32  32  32  12  12  12  10
> 
> The nuam topo is different with mine, please see:
> 
> https://lore.kernel.org/all/aZ7p9uF8H8u6RxrK@fedora/

Yes, our NUMA topology does have some differences, but I feel there may be some
other factors affecting my test results as well.

Even when I run with "-p0 -n 16 -r 20 /dev/ublkb0" without using taskset to pin
the CPU affinity, the best performance I can get is only around 10M.

My cpu is also AMD Zen 4

-- 
Thanks,
Hao

