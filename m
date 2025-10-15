Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF7FDCCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 01:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408A88E0105; Tue, 14 Oct 2025 21:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E03C8E0005; Tue, 14 Oct 2025 21:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C868E0105; Tue, 14 Oct 2025 21:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 231828E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:03:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBE8811B28C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:03:17 +0000 (UTC)
X-FDA: 83998550034.11.6814C66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id ED2A440012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:03:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b6hAzcK9;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760490196; a=rsa-sha256;
	cv=none;
	b=m4yY7KNe/sjw4RxpOM8Zb4Riad666AK4/xbM8Y0LOz5b2BhMnwjbZjt5dP2woQkE0kRs0U
	yFk5CzZTaqfPVIC5RJ7iwTncPMuZoS7xvxK+U2Qe8ApF1gNwMiwZ8qMt4/LPptp1oz08gL
	TYOMUggFvaMfQcruo48r0HVaB+Jvha0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b6hAzcK9;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760490196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jd8JoSwYJ3bPuRm6iTGouCOCT+zSKviknwUe1ePUhdI=;
	b=D40+Ddo/8LcYqJLnRd4wqdBlHZWdOAbZSkjvH3QHtglSmM6uchBkucMwHuPgJG8znTeiV9
	vkLo6kHPJHIpgzz/ylRfN95rjwNL5CNzG/JDnBF8D5BXgpc/RjUrWDTaHzQiCgst/GUg5P
	Lpq4nUPnBLu5cHikhpTjRU2n/zRzQ9o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3F1D60251;
	Wed, 15 Oct 2025 01:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5719AC4CEE7;
	Wed, 15 Oct 2025 01:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760490194;
	bh=RREgf6Gg7wwMbGdc/AWZnTykON32Sl+5JqxT1WhtNd8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=b6hAzcK9a6ZsHa0Mk3iI21Eqpc+IV+6ztwUn4mhqw/zL741FObJn7o/U9JxPSucFA
	 SEs+LS9B625yiZiRfHBLry2rSnVIcwt334tzjVqkWVwgBsNZDdhpSWaH5YoM+Re3XR
	 MVE+EarzW3FoEwNNGRRa6truUMvxx/+8yivIASe4=
Date: Tue, 14 Oct 2025 18:03:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
 trondmy@kernel.org, anna@kernel.org, willy@infradead.org,
 mcgrof@kernel.org, clm@meta.com, david@fromorbit.com, amir73il@gmail.com,
 axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org,
 dave@stgolabs.net, wangyufei@vivo.com,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
 gost.dev@samsung.com, anuj20.g@samsung.com, vishak.g@samsung.com,
 joshi.k@samsung.com
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Message-Id: <20251014180312.6917d7bd5681d4c8ca356691@linux-foundation.org>
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
	<20251014120845.2361-1-kundan.kumar@samsung.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: irsi8xbxy9dcnpb5996ox8otuwksrq6c
X-Rspamd-Queue-Id: ED2A440012
X-Rspamd-Server: rspam09
X-HE-Tag: 1760490195-440433
X-HE-Meta: U2FsdGVkX1/ph/cV95F111AipvQ9rrM2ail5bhyM0J24j0cIlDferBPU5zjt8548i5k0vd41X2524JZauopVAwtZERzwLXdsVpnkA8O9xX3UsJcvcGDJ5YA0Yij8pZ8eGoIBL4f9nE+GekHOMeNCJeX4B5XxaxJvZxnKh5ID38+7C5k2xWNc95kuJGSKZ28s8xADHPkFRKTqa9UicEseXmHoBYV1c7RJZg639fUVfnZtR8XJVJZkWYAZLa5drUPX9ZTA0TSrEbP4/qtCznMDpPNob7/tgnWLeGAI3IbUlQQX22O6u1oFQ0IRUfTGhERl8AFR7oaxvKXF/uC26rJSLt6Vb7q6gKAqMWxKeZ9HBOgvkkwLto+cfk4YFMYgBIu7D9lKHnJ0qoL1jWKu4MH22Y5i/wCOLLl5Krm23W88iuhNMwjcDXJq5WOucYSr79zl3fLJYUAezC2+035VnPHXCOlXJ7ixjnGbZ2UcMRcfLASqxBGvO+Dj5ojKoIyt+M+Q+9rU1QTlIAgdDNuuR9GvxrYRzr/erT7Bi4F+Rj73znAMHM6dBNFZjPNOZmj1KgEfwSGwAxn8HinCftPHO8MTvoMR6guYiDWqMPZ7urAR1LzGzlVNQAs0wb5NLb+9BiRS3rdSVPTExyRPgFFB9dR96TUF2b3kNEaluApbqPQLISmpm6G+BHSrKO78Q1bexd4jH8WZqguyoujiEQOCHYB4yu5yswzHDEXL8MOdrHublnqgYCOFq4t66dVIg6HHLfvXHEWLO5SKGruwz8CrBIBBGFyw/FhQ8XIfw2I6Ic5bVduovIj0LmevpOKHfFZb1WjFsfkPqVrolryESysj2E8vi91P0zMaX1ba999Iv/n4ZPIVoKfND3eUPZ+DjbESUdjZthMLQnUbOP1lbQ+Qf8+aLOszaBzNGPwVw/zKS1vgspuvcGe2ugS2z+/cHrxb5I+SGEwMxEck9AUuE0Ex0Ej
 FnaqeLiO
 zQbrN74IizKsb69ZomJAsyRiOOcUKhOXPOlgZxhlb2V1kLNGGiEzjLQN5/yO4G3I6h6Yll6YK/p/exZ4q8PHpaYWOkhF+PNwCyVkakdzM622ZDtd/JV8KSzVYj0phx2lmmzqS5XF3t7+XqeMQ/cE2ZMAWSC6D9S02qod1ghbH375r5kT34GRar4pSWQV6k/jt8nCrir4I3Dh6oK93VizvVm+sblhGoWrxYVTOFtmsGIUcV38/RAF2Rr2VEkD35QjqEklWfCR1AqxRI1RBcKo+Jo/VTN7VcMzSUf9pb+fJMAzQV/XPHOR6tS8mysvLRyYIdlryUSaKh6J0VG6T4VtrxQ68Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 17:38:29 +0530 Kundan Kumar <kundan.kumar@samsung.com> wrote:

> Currently, pagecache writeback is performed by a single thread. Inodes
> are added to a dirty list, and delayed writeback is triggered. The single
> writeback thread then iterates through the dirty inode list, and executes
> the writeback.
> 
> This series parallelizes the writeback by allowing multiple writeback
> contexts per backing device (bdi). These writeback contexts are executed
> as separate, independent threads, improving overall parallelism. Inodes
> are distributed to these threads and are flushed in parallel.
> 
> ...
>
> IOPS and throughput
> ===================
> With the affinity to allocation group we see significant improvement in
> XFS when we write to multiple files in different directories(AGs).
> 
> Performance gains:
>   A) Workload 12 files each of 1G in 12 directories(AGs) - numjobs = 12
>     - NVMe device BM1743 SSD
>         Base XFS                : 243 MiB/s
>         Parallel Writeback XFS  : 759 MiB/s  (+212%)
> 
>     - NVMe device PM9A3 SSD
>         Base XFS                : 368 MiB/s
>         Parallel Writeback XFS  : 1634 MiB/s  (+344%)
> 
>   B) Workload 6 files each of 20G in 6 directories(AGs)  - numjobs = 6
>     - NVMe device BM1743 SSD
>         Base XFS                : 305 MiB/s
>         Parallel Writeback XFS  : 706 MiB/s  (+131%)
> 
>     - NVMe device PM9A3 SSD
>         Base XFS                : 315 MiB/s
>         Parallel Writeback XFS  : 990 MiB/s  (+214%)
> 
> Filesystem fragmentation
> ========================
> We also see that there is no increase in filesystem fragmentation
> Number of extents per file:
>   A) Workload 6 files each 1G in single directory(AG)   - numjobs = 1
>         Base XFS                : 17
>         Parallel Writeback XFS  : 17
> 
>   B) Workload 12 files each of 1G to 12 directories(AGs)- numjobs = 12
>         Base XFS                : 166593
>         Parallel Writeback XFS  : 161554
> 
>   C) Workload 6 files each of 20G to 6 directories(AGs) - numjobs = 6
>         Base XFS                : 3173716
>         Parallel Writeback XFS  : 3364984

Nice results.  Is testing planned for other filesystems?

