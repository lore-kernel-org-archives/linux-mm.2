Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDEF9FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 07:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C5A6B008A; Mon,  4 May 2026 03:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED616B008C; Mon,  4 May 2026 03:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202E26B0092; Mon,  4 May 2026 03:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 130326B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:54:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9DA41C128B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:54:57 +0000 (UTC)
X-FDA: 84728976234.15.DE61BC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id EBAF2160009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:54:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FB9/5zfH";
	spf=pass (imf08.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777881296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVdwZJcvmvGE6+OLGdC0RaH+EknJn+u2y5+lXvp89cw=;
	b=hngzxHnzc4hGosiasgC9TZGebPoBbNGEw1tzIeIHj5H76WpN6O7bTCNXzU8ADXitzJ6n/p
	/CMuFDf02zW88CKyMOViq0gTD8+iUxMkbw4XblhO8ICsW28zWmzSJ3tTS1AasnT2TE/4P8
	7wAsCDiFDrHIbsiiEA4bXqk9VxMBpE4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FB9/5zfH";
	spf=pass (imf08.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777881296; a=rsa-sha256;
	cv=none;
	b=BVlP5MLmlhuBLZ9XRYTWKmsye3qTaMXJ4why6l/6vwMPa/AVI3yEJkR03PaY8nXCQK3gy7
	eqtgOWKmhQnNEw5bb0DpiPKHxsF8hoJHi9mkDqJ3EBGXIWnJp/uX1Z9/o2ZAqTwaPU+LOF
	hYaeZ/xaQCPBON4LRSCSpdLAH07wTko=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ED3E600C3;
	Mon,  4 May 2026 07:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD09CC2BCB8;
	Mon,  4 May 2026 07:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777881295;
	bh=CAXj9xyWc1aE1Yll4TCnkoDiCPvKt/BnzayChhJOaOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FB9/5zfH25uUjpjPPQ5zy01kmPmRxMrLyK4TkeIq+yMks5WTBAdv2mcc1ENE0vK1n
	 zawnJhdMMeUnS5GChe3IpImRPVlcKQygZtOAJq1t/e8fMcgGAjooOdwDLhswIvnxS/
	 s3VmIkgywraM64O/mGT7MBHWUeGHI/Bxi1kFYQbCC95q+ZXWCH5dR4/EsKPfuBRsWo
	 lMMrA0HQ8lJPy7kAV3iXDWWmox7tQ6y0PdV7t7jsy4W3B2ZohRIXI0HdR9mLwymqWV
	 Pz2NuP7atrMv4gMqs3mJXHD50JvtXzENrT1BFwsexkMDL/E5KScqbwhfudMkwkg0JY
	 umGAikf/4zy+w==
Message-ID: <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
Date: Mon, 4 May 2026 09:54:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
 hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
 Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
 p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, pankaj.raghav@linux.dev,
 p.raghav@samsung.com, Daniel Gomez <da.gomez@samsung.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uur5poduqaar31ztobb3tqorzaf39sgq
X-Rspamd-Queue-Id: EBAF2160009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777881295-143664
X-HE-Meta: U2FsdGVkX1+tQykPkuHU8wlSpLjrcuqULUx1YfahbaguSx0m6JzLn0LwLdrXQeADQUHfbdSa8xXmlJtxtt5n0hjSg5j5zZZTr1untkmVqser1J8CqXjc9SDVlRTDL5iO2rrRygJkkHY/pEGUtPUztViQd/PicDazzpu4i8Vb706e7unvC4dMPnI0z+JyLulbv8kVnEjo0765KoZhUoXARXTDh1oGa7YxLOKEjyjJC5lK5ldyoRCW1NBScHuH6bZRGYqN513yQRqH318sU5aiYeTzoT8yFFiQdeLByOtZAckV0X1ZeVsgByd/8PaxF2lVvOdNtiofwtLa7UhAN6rzsZ+R7JH7N5hGQsm/9xHbFNIJL47KlzXcXZ/POVg/7n8zz6abMoboSMeig3T6t76sYsn46w+jOytH2WV1H9iZYlLWz1DtyQ5IMC8lLpg/X3b8kpNDgVKUROgRnOK1R0qSdN3fnpcQ6DSwzr9pNs+S3XNcqXU8bvAItw45WJHesAg4vwCcnvxci6IpPNoBEEH5X30NA721Y5gdym3Gq0ECc2RFN8bpsXXRqGAbSKenGakJJNj1ZVpQDeulVxzmIFAdkD+lt9SHTHvSNVbmmoGdeV/JS49WbHHoRNskE61MBp4aLJERo/tFsFr+KsM1fGaU9++FLaFOviWD8iyq1m51JOW3NiRQxrsr4lag/iPEIcq/cIVRb5zCYhCqcsUCGRRf2zNEo4uGP3RzrhV00DARdAytdLBUv3eydiAH1Yc0ExLPi4ErxtBnwldNGQ4B6rOjrrvhbL3SrAiAcuMJ+62g2O+WT5LbYBTWDtQf2Ah29ZAkPd8zyiw252XUPk5Ani2IfjQJFnsFR3sdt0aGqysHAivpLqFR82UX8/g0ztulNkpR5IVR9tG4HWixTlvVgIhxcS7314A/uUMxOkWml6M9hA+78RqN03dIeL1uor8mfkcQDmxFR4I7AWSyjGIBO5Q
 5gMqaf3c
 2shlTInSNDc6e08z/vjaEnXkT25nzaHvUz20K0MnzcVCSED6SozhMoN2b37fuvYEHYrnuV0IXZrZhC2xxa44ijLWNYEw6A15Pm0592M+4sv8OOMs1Tq/PRup67m2sryoDhJ6jSKmI3kvZfnk5/h36dLzTKuqAZO+RDSrya28fSoW7GQDLxgy4w5eJy1DO6RQPre9clQke835Sp8zUIlcTSJY/EnDwlQL7inXyh/OAkARc6LFdWZlzX0gZb5RkCqP3hTIglMKWl2Te5yLVJZGQrvLfuOMWCHIeTHeLKqenJGJNfbK/S36FifrxjVI8+63I+8nBnCP9JJq73yNVpjZ3hzG6XvjNLziT3QrPXdC6QbM7Vhd2q40MObI4OelmHC9+DIbZ0RKWqNwILSGiYmioYyCeFkJZ2F2prURJOt1mxjWGV3fOHxmhNpUAXLz4QLYQnCdy+OjJPcm8je8c6qA0m13HmTIoDRGirG/IFwwibPQwU5vp2uvdng3aKNNeHj41zGkd0EN3D6fe5z0MJRmlzs1UDLKVP1LoC1votBukxPnIAYOfo+8k2jj3jbOC3/DD3GW5qGObxrVNnidQWZ2+EpyiPrDrvOuMPIrPRsrKWUvWuCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> Hi all,
> 
> This is the v2 RFC to add buffered writethrough support to iomap and
> xfs. The changes made are mostly to get the writethrough implementation
> more inline with how dio handles writes. 
> 
> 

I gave these series a run with kdevops and fstests using the following
profiles: xfs-crc-logdev, xfs-crc, xfs-reflink-logdev, xfs-reflink.

Note that I applied all patches on top of v7.1-rc1 and xfstest-dev
patches from Ojaswin have been rebased on latest master [1].

Link:
https://github.com/dagomez137/xfstests-dev/tree/iomap-buf-writethrough2 [1].

In general, some of the results here seem flaky. But let me know what
you think. I'll try to confirm the possible regressions with another
full run.


Summary per profile:

* xfs-crc-logdev: no regressions or fixes found
* xfs-crc:
  * generic/753 fixed. This test failed on 7.1.0-rc1 run but succeeded
on 7.1.0-rc1-00005-gc6a39600d3c3.
* xfs-reflink-logdev:
  * generic/415 failed on 7.1.0-rc1-00005-gc6a39600d3c3. I tried to
replicate the issue by just running generic/415 (not the entire test
suite), and I couldn't replicate it.
* xfs-reflink:
  * generic/457 failed on 7.1.0-rc1-00005-gc6a39600d3c3.
  * generic/561 failed on 7.1.0-rc1 but not on
7.1.0-rc1-00005-gc6a39600d3c3.


Here the full report list for each A/B profile test run:


http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc-logdev.html


http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-crc.html


http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink-logdev.html


http://htmlpreview.github.io/?https://github.com/dagomez137/kdevops-results-archive-wt/blob/main/workflows/fstests/results/r0001/fstests-report-7.1.0-rc1-vs-7.1.0-rc1-00005-gc6a39600d3c3-r0001-qsu-xfs-reflink.html


