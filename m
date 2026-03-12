Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F2BFED2E9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 14:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2986A6B0088; Thu, 12 Mar 2026 10:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245F96B0089; Thu, 12 Mar 2026 10:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128086B008A; Thu, 12 Mar 2026 10:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01A286B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:51:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EE90160282
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:51:13 +0000 (UTC)
X-FDA: 84537698826.02.3BE03F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8DD9FC0008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:51:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B5dUpUTJ;
	spf=pass (imf28.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773327071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lE1rb2S8uojZcRiMtzZiFU8yO1ZMQjlNk6yVeVq/BwU=;
	b=6bg9uaxYr9eR6GfiUwTCoxBGSTiIMUNLSubRQkq1C1uB0OQe97vkYWuosOBvSVU3bGbTqA
	rjLkf0KOBiQJHCgQBp4HzpAFqaH+fwdMWTbscNq2yR0lKkYqim8yq31hL756WWT8tB0I4R
	7Je1bofBC/bafNuZr0VvFjLkrVwNEDo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B5dUpUTJ;
	spf=pass (imf28.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773327071; a=rsa-sha256;
	cv=none;
	b=yC8HRCWN/aM6pli64eb3uvVnWGsKJZKLVznTe5GLDC8xbN9O/1FTXuM/BdGd2FmddiKSyt
	m56wYBavfZGCnZUR+ULTl7f6BiotnxEiH81kkjn2DEQATbPKkvM5vWKwcOaxIcqaD7ggAA
	IzDSPv7iQiXnbhTDLls+UJ3y/Zs2k5w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773327070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lE1rb2S8uojZcRiMtzZiFU8yO1ZMQjlNk6yVeVq/BwU=;
	b=B5dUpUTJNmzvA1AgYolYGYe9s13Tx5OMmUKTVaXvBeKrKz+r5t5XfvdlOd313vGFXpTipB
	W49zLlMkkN0Z68a/WJ9AiX3baimzmtrBJ12OwF3niRV+/a5UbaSgjGFur1j9ZdXqLBN6MV
	2HnG5mmzi6cQzE+ZW0TjKWBhyaabQjA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-vTJ5wrXXNF2xbUlIumCVbA-1; Thu,
 12 Mar 2026 10:51:09 -0400
X-MC-Unique: vTJ5wrXXNF2xbUlIumCVbA-1
X-Mimecast-MFC-AGG-ID: vTJ5wrXXNF2xbUlIumCVbA_1773327063
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54CD8195609E;
	Thu, 12 Mar 2026 14:50:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.147])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4849A1800759;
	Thu, 12 Mar 2026 14:50:45 +0000 (UTC)
Date: Thu, 12 Mar 2026 22:50:32 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <abLSuHU3eJrel6KI@fedora>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <fbssy5y6kpyjlefacmabuojiustr3nocj7timpgejpchkj3lw7@qfss5ffmwdxa>
 <abKp7-HzFT6llbYT@fedora>
 <iypdqo2s5oobenjrmoqqplgshsz65bwegih7kxhgd547fcofm7@yb6xqors6snx>
MIME-Version: 1.0
In-Reply-To: <iypdqo2s5oobenjrmoqqplgshsz65bwegih7kxhgd547fcofm7@yb6xqors6snx>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: dYSVDxGnNFLpYzGy8k-yYjltgOu4HJni96cun0mKorQ_1773327063
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: jyq96szfo489nwbzsuxgjbqzi1fd9pwe
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DD9FC0008
X-HE-Tag: 1773327071-472631
X-HE-Meta: U2FsdGVkX19GGNL/jyjzY5yk1O7us+kBgESTiSuEh9xWice6G6TSPk6R0J+794tXGnnyRoDLDGRKbIaNdmoduvhMBP6HxeFrako/xSCcbp2VxyNCKQt5dtD/0HEb93EEtGyxdwqliIP5ppxW1YTsd4M8TFeKq5xGwS0O68xzSSDmUQVl0+COIduRiM9fpPdGeTkG6px+jgR6Nn2ruebyKzubujw5WVBLhDmSStxvM2hGJFQLyoh9h3Jeb5/eGLjfAhCctzNCnkcoCgKTZONvJ7sluSd0v18YFUmIQ/72DcqmxyxkI22BMxnHAOSmX6iUGnQW4FV+eAwxVFabtJ70MUcgkr7wia2qBNvH++q9ELjOKoz5apC7TCV3a399jmMT2XS5P0PqEolPNXIEhuIhhRFgLP0xmeSkH+ANcx2+HnyYKBCrV1Q1sNgLU0VyJk14g944ytfloSdz2YTzGKNGRopm5qMaLKdlVTJDNmXGGbpA4bscR2fa9/Buom8G7drtvYTl3PVadZFJg07+MOvGZC4E8MjgvE/8RJCh/jl3WIAoG2UnCsS7wothCbDV112DBwdKfVRiy1mXi43DICJ07OiIsqVfyw92IsUcwndBXvfuiBFNuMim4TXsAPWj/4E8Ly6voD8RJgMb3cZq03MJZu2eE1OYWhSm426lQIw8J6T6k5QHhQTpxduWDPoUR//KwAaL10poHnV70B7/W0XZpyQI/nMH6jQ5EVjYGno2/Z1VUAXwRUGyqe9nW20f8YN2Zivh7J/+W3fdZRT3NspsjLP+7pkyNmS8BYcyCPDb1iCG4AfLEws6GGWOf+4VFfqP3EutD4ASod5l1QoXQUNDiTPirFMNf7W7Gdp/bP1McyqszlLewPuvyyW4d6yk1Yr3siCQijLkUef0B/Ip2DVbvvD+rRjndsID6ycKpSChU5IgMGS+W+0rUL3a+tFS8JnMjDQwQnPJRrdAh4W/IZp
 mJRHl82n
 4kAvw9ErrneVHIzEKgoPAZ8PPFbELvF9OFV0gU/nsI7qbs40xDqGh5vWJyWfuPN/o3Yw24uzL0eDY3wYjukW49s/o0pnkU5snBCxUuxIevVfuD9IFQTqKTAZ/wfyI+a8GPzNMknZ7/CmRycVw5QTPBoJwLO7+GOoAXKR8MV0c8YdXrHBA+icVZX28+ja1u/AOebYiCG6u17EZKMWPdVCfqQ6z8iQS4dvxLRi4LHC5I5G5HeOApI19IKUTqQuHzLahcHZpIlPFl/G4m2t5rgdB0t13YOOUGc9LNghvrO8jBknYrHNUGDJ9a8KDs0UU9HCAJOuGnGWeTzp4sMu91pXLBC1rPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 08:13:18PM +0800, Hao Li wrote:
> On Thu, Mar 12, 2026 at 07:56:31PM +0800, Ming Lei wrote:
> > On Thu, Mar 12, 2026 at 07:26:28PM +0800, Hao Li wrote:
> > > On Tue, Feb 24, 2026 at 10:52:28AM +0800, Ming Lei wrote:
> > > > Hello Vlastimil and MM guys,
> > > > 
> > > > The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> > > > 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> > > > performance regression for workloads with persistent cross-CPU
> > > > alloc/free patterns. ublk null target benchmark IOPS drops
> > > > significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> > > > drop).
> > > > 
> > > > Bisecting within the sheaves series is blocked by a kernel panic at
> > > > 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> > > > paths"), so the exact first bad commit could not be identified.
> > > > 
> > > > Reproducer
> > > > ==========
> > > > 
> > > > Hardware: NUMA machine with >= 32 CPUs
> > > > Kernel:   v7.0-rc (with slab/for-7.0/sheaves merged)
> > > > 
> > > >     # build kublk selftest
> > > >     make -C tools/testing/selftests/ublk/
> > > > 
> > > >     # create ublk null target device with 16 queues
> > > >     tools/testing/selftests/ublk/kublk add -t null -q 16
> > > > 
> > > >     # run fio/t/io_uring benchmark: 16 jobs, 20 seconds, non-polled
> > > >     taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> > > > 
> > > >     # cleanup
> > > >     tools/testing/selftests/ublk/kublk del -n 0
> > > > 
> > > > Good: v6.19 (and 41f1a08645ab, the mainline parent of the slab merge)
> > > > Bad:  815c8e35511d (Merge branch 'slab/for-7.0/sheaves' into slab/for-next)
> > > > 
> > > 
> > > Hi Ming,
> > > 
> > > I also have a similar machine, but my test results show that the IOPS is below
> > > 1M, only around 900K. That seems quite strange to me.
> > > 
> > > My test commands are:
> > > 
> > > ```bash
> > > tools/testing/selftests/ublk/kublk add -t null -q 16
> > > taskset -c 24-47 /home/haolee/fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> > > ```
> > 
> > The command line looks similar with mine, just in my tests:
> > 
> > taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> > 
> > so the test is run cpu 0~31, which covers all 8 numa node.
> 
> Oh, yes, this is a difference.
> 
> > 
> > Also what is the single job perf result on your setting?
> > 
> > /home/haolee/fio/t/io_uring -p0 -n 1 -r 20 /dev/ublkb0
> 
> If I use this command without taskset, the IOPS is still 900K...

So single job(-n 1) can reach 900K, which is not bad.

But if 16 jobs still can reach 1M, which looks not good.

In my machine, single job can reach 2.7M, 16jobs(taskset -c 0-31) can get 13M
on v7.0-rc3.


> 
> > 
> > > 
> > > Below are my machine numa info. Could there be something configured incorrectly
> > > on my side?
> > > 
> > > available: 8 nodes (0-7)
> > > node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
> > > node 0 size: 193175 MB
> > > node 0 free: 164227 MB
> > > node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
> > > node 1 size: 0 MB
> > > node 1 free: 0 MB
> > > node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
> > > node 2 size: 0 MB
> > > node 2 free: 0 MB
> > > node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
> > > node 3 size: 0 MB
> > > node 3 free: 0 MB
> > > node 4 cpus: 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119
> > > node 4 size: 193434 MB
> > > node 4 free: 189559 MB
> > > node 5 cpus: 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143
> > > node 5 size: 0 MB
> > > node 5 free: 0 MB
> > > node 6 cpus: 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167
> > > node 6 size: 0 MB
> > > node 6 free: 0 MB
> > > node 7 cpus: 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191
> > > node 7 size: 0 MB
> > > node 7 free: 0 MB
> > > node distances:
> > > node   0   1   2   3   4   5   6   7
> > >   0:  10  12  12  12  32  32  32  32
> > >   1:  12  10  12  12  32  32  32  32
> > >   2:  12  12  10  12  32  32  32  32
> > >   3:  12  12  12  10  32  32  32  32
> > >   4:  32  32  32  32  10  12  12  12
> > >   5:  32  32  32  32  12  10  12  12
> > >   6:  32  32  32  32  12  12  10  12
> > >   7:  32  32  32  32  12  12  12  10
> > 
> > The nuam topo is different with mine, please see:
> > 
> > https://lore.kernel.org/all/aZ7p9uF8H8u6RxrK@fedora/
> 
> Yes, our NUMA topology does have some differences, but I feel there may be some
> other factors affecting my test results as well.
> 
> Even when I run with "-p0 -n 16 -r 20 /dev/ublkb0" without using taskset to pin
> the CPU affinity, the best performance I can get is only around 10M.

What is the data when you run same test on v6.19?
 
Thanks,
Ming


