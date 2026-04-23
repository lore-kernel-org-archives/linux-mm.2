Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875F4F589AD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0496B009E; Thu, 23 Apr 2026 08:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A82D6B009F; Thu, 23 Apr 2026 08:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6706B00A0; Thu, 23 Apr 2026 08:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8F06B009E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:25:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE1B21A0135
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:57 +0000 (UTC)
X-FDA: 84689742354.17.41FBD43
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 159C412000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NaHOKZTR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947156; a=rsa-sha256;
	cv=none;
	b=TqKjvnBxouIsTji9FmWhL0A1eQFh1F+TfnrwKJxeVUQNKxcqimGkx1Zb1lglgrJKEfl5Gs
	bixaP1qYwk6/iIxkQio5m7M/k9aTwRaoJIN650rd/VeHkaP79c0OdTH+2NL0d2RH3qOTnu
	nXxEymKx9B4jLxsLzt0TaFn1jK5We3c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NaHOKZTR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFuI3kxxNCrl1GLPiiErWVXfpDdcEtSe+fyhzmE9jac=;
	b=CEHzKYLVRh7BOqRFPM9y7mOnFL6WAFDTvSpDIfOjj0pfFEhpAjLfWCAV/VgHlupxf2YTEv
	qveJBCi2gcnsvqe2V+HSeI9q1rOcwMM+ob5u2Clb2HINI7NHlJvgRx4zRe2BEZk4saYmBI
	lACnXPmL7sL00oXCnWuLymVCfA+rM7o=
Date: Thu, 23 Apr 2026 14:25:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776947154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NFuI3kxxNCrl1GLPiiErWVXfpDdcEtSe+fyhzmE9jac=;
	b=NaHOKZTRP52mY7pu+ogzf0zI5S8qT/ynND5WU9sondO+ZOha12kDjwmi0r/Xha3XZOm7AK
	05XTRztpA3R0TyfxhFOf375iEPmqlyQtS8Sq2Qtbi/kiW0DpwX3kiQgfo1APdOlUQSrScN
	dPiC1+Mib7ECPkAL7sev5w6QBHsL6hU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: 6qcootcowcf5zcppb6ubynoigr5dwnca
X-Rspam-User: 
X-Rspamd-Queue-Id: 159C412000B
X-HE-Tag: 1776947155-861373
X-HE-Meta: U2FsdGVkX1/EcihSKfn15nGpW4kN2dDEk2KpM3aShpg1l6X0cpf98EGnbG3Npgsc+lcmYggQ9q1HSJwQp1CiQ751X66fhEbDTeNYWd1yAaVaq+wOy2dL4/bfM1Js5K6/45mHTaP0m5IsvqDWvBfdR6O/3Ckoq6c1lRmv5arVl28Rd1i5X8EpUD7g+o2P7+M6qZUjPEhguVuKuojSqPe1sNvvTpO6tAn5su+QjNeKje9xqDRUKKyE6Z+3/pXuCG80FTbMtg9xQMsQ39uMAtH2oQ9U94HlPS5fOt/WydkJ00El+o9Kq2ShRpsK0US9SFwOW8aB/yW6DYqUMFBzvOjMhGb7+DuHm5rJBuJ+/9kpAYx3fhzApSVN4E763xBdDl6k5zFsU9MGtcG48HVlCvVB4ILJcwDsQLhHyVA8oABIHWRSfC9pWmRuCEexiSaom3pvLmtVy+arYjHwE9mWTzQGx49bf1gQXZwCSdeDPQZncnUt05Qc8EexdVi4ipuo0pfEpQaOHWcb9BP0Rh6esA+FHmrjLi5MV3ykUhD/2Zfaq9VRpWrdn/y77oGSm3Ak4DD1vfbgwbySbPAsebZ4SIedcxT5bfj5rjOIHimoHAuQ0fsk0W0/Sbgi8K9HGKHELfPDT0LBGxR0x9T1dIU4uSMycteiYFT8QoOj/U14soldsI+bYY9zyNr2lScdyJniLLMXMd1Tn1/faCMtGOZwDv8ZhMrUH7lvMzMIL5S8ocDntZXFs7iRdeOE+HbnpuELSVjWrKew9F2Ft1RLO3dShSDBEhaBvt2hIrs0B/HyvL3BLaQTM4nA9Qyqn61pQgVY5Mpkr8fH8DNUCu5VNqmTUaJd2Yu6ER/zDDDjhsa+rFlcR/pRhHWVdlp6ap4OdvkpDU+Fbp0Mjod0l7NXfi1AJ5bN98P0YGIXK5p/xQlKUxpyTKZn/5YrTueVAqbSWTxTPht3IPLYoE24H01bJwEZVOL
 kLEQ3wCL
 rv6NkF6N1m1CDjWJonjvx4fH77RWkgt9iAgcmjzU8i6S1b2StXuddFXZmHHtPE6MC/6OVLufQDgAzGQyd/EjSHqj4He1G18Y4aNG0RxVYHI5DQaW1NnPoeVdiPBVhmn5uTZjAK6sDtxKGW/54xLzq7F28U5eLxJi/7RlTg61CEO9bovbZkx7hFHMYZ6KdGLzolBo97Cp5Yzq+A1sqOdAM8xU27EwwZN00Lkox9t3jk1t9VwPhwWpEIUtexzJCU8JWmUwfCVMYsciFKFoJ6eX+vxNfpZP+F+SPyW7I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> 
> * Testing Notes (UPDATED) *
> 
> - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
>   xfstests and these patches survive fsx with integrity verification as
>   well as fsstress parallel stressing.
> - -g quick with blocks size == page size and blocksize < pagesize shows
>   no new regressions.

I am hitting a very strange error in generic/127. I deconstructed it in
to two commands that can reproduce the issue:

```
$ dd if=/dev/zero of=/media/test/fsx_lite_nommap bs=262144 count=1

$ /root/home/xfstests/ltp/fsx -l 262144 -o 65536 -S 191110531 -N 100000 -L -R -W /media/test/fsx_lite_nommap
mapped writes DISABLED
Seed set to 191110531
main: filesystem does not support exchange range, disabling!
main: atomic writes need O_DIRECT (-Z), disabling!
short read: 0x0 bytes instead of 0x6c7f
LOG DUMP (1 total operations):
1(  1 mod 256): READ     0x39381 thru 0x3ffff   (0x6c7f bytes)
Log of operations saved to "/media/test/fsx_lite_nommap.fsxops"; replay with --replay-ops
fsx: save_buffer: .fsxgood file too short... will save 0x0 bytes instead of 0x40000
: Operation not supported
Correct content saved for comparison
(maybe hexdump "/media/test/fsx_lite_nommap" vs "/media/test/fsx_lite_nommap.fsxgood")
```

This is on a bs == ps (4k block size) xfs filesystem.
```
$ xfs_info /media/test/
meta-data=/dev/nvme1n1           isize=512    agcount=4, agsize=2097152 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=8388608, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

The same test passes if I pass `-G` to fsx parameters(disabling writethrough).

The error is coming when we do a read operation which feels very
strange. Could you run this in your setup and see if you can reproduce
them? I still do not know where the issue is coming from or it is
because of my test setup.

--
Pankaj

