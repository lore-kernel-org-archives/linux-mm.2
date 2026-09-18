Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FCDC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E776B00A3; Fri, 18 Sep 2026 12:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2164C6B00A4; Fri, 18 Sep 2026 12:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1532C6B00A5; Fri, 18 Sep 2026 12:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE98E6B00A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:39:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34AF980775
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:39:49 +0000 (UTC)
X-FDA: 85227444498.14.9CFDF22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 83D51160007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:39:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1DzYxTh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1DzYxTh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749587;
	b=xRt92j/ZehmMBihVbzOy/hNSBe/haK73skIpBwDQsRn4x4GWS9pW6mhSG60YK8nk+47B4Z
	riQao9y2sC4b2RYZyVqNjYNmmda0whwbDOl2O2nNjPkOEx8oRnK/zs3sk5wkt60dC8m4aF
	FoKkxWbgqi8W58Whj7bsjGy6XxwqPC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44YWyMJ/oG0eAU0DmApWBZ/DLAfd4ODL3tuxQj9TMfY=;
	b=koDeqvpMLua2Jm1C7vjg2/6S9aDucqScw1RmycYv3JiNwdRO3sDnwM3kB2sm/XlC0yAzH9
	WvtKwIt8JoShX9kAmj9fnPCo6dDBXjWwTwntL8U3hST27uNuEfaswlOgxO5uMvphL7j/vD
	pzAUXdL8EmDerFRoAao65JaIOeQ43Gs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B42A744014;
	Fri, 18 Sep 2026 16:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E1D1F00898;
	Fri, 18 Sep 2026 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789749586;
	bh=44YWyMJ/oG0eAU0DmApWBZ/DLAfd4ODL3tuxQj9TMfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d1DzYxThowbi3RiBsdbmXS/O5AG4VGMWydaNARzyoMLaghy4SL/lIetjBxVuwgNq+
	 xU4ncHb3vCXSfvgqSa5AcqITAv7zdnY8i1LrBlimqroO2rT08t+fHQxfpf8GIMzURA
	 dpelOgxBGGz70DJ6iOlLXb+sV1PrtIN1hvfv26bsNMTdzeZVaNMPyvkha9egpLvvW/
	 XEeD70Jc03bqvJ2W9+uloNdAE947Bb0bRCfgotF0LyknGZR3FIAgqSFISszVPYDis1
	 +LC3MUwTyqT44vOBo1I89sSlCkbSuvXH+AjSw72aBOjcSCF9VmlyYegEOEw94t4qJK
	 BfvEA3Kt8lTyg==
Date: Fri, 18 Sep 2026 17:39:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Rakie Kim <rakie.kim@sk.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/3] MAINTAINERS: move memory tiering under MEMORY
 MANAGEMENT - NUMA PLACEMENT
Message-ID: <aq1pEgR0c20-gazD@gremlin>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
 <20260918-maintainers-mempolicy-v1-2-9a94cac6d135@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-maintainers-mempolicy-v1-2-9a94cac6d135@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 83D51160007
X-Stat-Signature: h1icka1pztcjhm8so4hgyz9s5tur33pa
X-Rspamd-Server: rspam01
X-HE-Tag: 1789749587-464301
X-HE-Meta: U2FsdGVkX1/CYGkf90Z4cxlGCwaFFtZ2/bCrco/izljzzznIbz7JFg87T2g3xKiSMz450krbFfLUKrXpYBZpEcadSV7kFW/6Ebel+OR3U/hgUQ7/4o8LGlLdbVTABL8THwfyda8IMu6W/uihhOKPHw6oVisCEe62GHsdXrJzlRhEZiLUzbAExHiv4avO7x9EuG5kOpNjHErnVZ0BJ8xUAH8/2CJj4Tr19B3cxl2nEnV0pWhzdmE4fIbF2AKEyVdekNGhwdoySNxrTGUJCq87mUEF6XrKwSBdkhYcp+Wy6tCKaEGtnLZnaK+U9nwiGguJHjl/tSoJY2+5JcQv4ge72BLyQYe+Y6FQYmjvUBsMw6TAZFhrfMxSA22Yt+4ZuxGqBV78Mgi8YbPH1lFCPkmJ5WEYJQIyPuQY5oVpAioy3pxCwFW6AvSYaVTeDQ0qVcQ66uxx7iGKLqO2gGgHm1sx44Ygndhl2oQchMaRs8sYGIcU3eu055cUob5gA2vbavZE55pznniHBbuYRhC5PXfMxQixUCwN5whSgz/Fatb6j2QiuUBQsfeKm+FPfwva31IeJNjK/8IiX5YmB0tf6el59HRncJ99TWGSOODhZnbrQIFMVnt9e0l2lon9AOBEckW8Pb3e/i+hbLbSE+d5G2V68bpG8irv27mC14SKb6e3QbTezfNNASo15GG6pY66e4sPV/muSYcco+/7dmnxdoxoDCHG6YYtOKRuHjXlU05ItLFczfYwIZDTJ14HHaY10ZxRhZUHVhJQEwWMNZx7fKUjNIvnS+GUr0MlkK1P5RDSLC5dBSZwSo0UeFghhiiPMoRJJHqUvIV5XyCEYx6kVKF1/lxepNP/GuRZDsiUkVWkRMpYK/5K/NU3rzSLoPcrc0mMmVBSQm7B39X4HiiGXKc+VWBefO+CfaOnAfFbUOVl5IIUuNox7ndOtflxvtvssyx4dy0h104frleZHJyV2s8
 Avz6kTU8
 /+miF3yPAuXtSF5Nf6TtvyVfALY+c0/xGyYceFqsVKQldqrQXYG9Fnnvqh5HkJ9ypzbOX1B5mvjf1+t+tW7mKlkxoNfJHnsaL7LqaDfFFLV55OG0Y05Txr9z5uWCspRMsbMzpbedCgUFsuyHtKCvOONMDU3hGggkRvuj04y4EwlD9TZVGz1xsRCm1pbLD/J4UoGTjDKRXvgeDHEf4St6ngxGZSdtm+s1AGY4bIx8mMh+km3WBfah6Wtf1zy6B4tHsyO3diZaYUJBqR0YPoMUuT68nhpzt4bHBnD8ncR3N2gtKc4JZZUyrGDujd22nXHv3ZUElRMtJv6NlY7o4Zs1m78dtEV31Gice9m7RKhJ5z/H9hf/R5BHPFs4vZaKrOIR3VfJ+gz16Xf/QZefCe8AlEiFNWtxhCDnCTaejYYRZ8LJoVHKbSejGO3LMtfXf7A+T6P3xWkEu4nxZzmruTdQ+bAzuvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 06:34:25PM +0200, David Hildenbrand (Arm) wrote:
> NUMA PLACEMENT is a better place for memory tiering.

So you are finding a better placement for the placement bit of mm? :P

>
> My best guess is that existing MISC reviewers are not that interested in
> memory tiering, so don't carry any over.

I think misc by its very definition is a place to stash stuff that doesn't
belong elsewhere so seems rasonable :P

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 77232db57b53d..344875eefd175 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17261,7 +17261,6 @@ W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	Documentation/ABI/testing/sysfs-kernel-mm
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
> -F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
>  F:	Documentation/admin-guide/mm/
>  F:	Documentation/mm/
> @@ -17269,7 +17268,6 @@ F:	drivers/char/mem.c
>  F:	include/linux/cma.h
>  F:	include/linux/dmapool.h
>  F:	include/linux/ioremap.h
> -F:	include/linux/memory-tiers.h
>  F:	include/linux/page_idle.h
>  F:	mm/backing-dev.c
>  F:	mm/cma.c
> @@ -17281,7 +17279,6 @@ F:	mm/early_ioremap.c
>  F:	mm/fadvise.c
>  F:	mm/ioremap.c
>  F:	mm/mapping_dirty_helpers.c
> -F:	mm/memory-tiers.c
>  F:	mm/page_idle.c
>  F:	mm/pgalloc-track.h
>  F:	mm/process_vm_access.c
> @@ -17310,10 +17307,13 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
> +F:	include/linux/memory-tiers.h
>  F:	include/linux/mempolicy.h
>  F:	include/uapi/linux/mempolicy.h
> +F:	mm/memory-tiers.c
>  F:	mm/mempolicy.c
>
>  MEMORY MANAGEMENT - OOM KILLER
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

