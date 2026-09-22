Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5563C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 07:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6595F6B00A1; Tue, 22 Sep 2026 03:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6311E6B00A2; Tue, 22 Sep 2026 03:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5461D6B00A4; Tue, 22 Sep 2026 03:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 296DE6B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:00:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E057840387
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:00:24 +0000 (UTC)
X-FDA: 85240499568.11.C49BF56
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1DEEE1C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:00:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cn1d6rou;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cn1d6rou;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790060423;
	b=KMfhUurtlowythx72Y+FQBeMnmGecHyQwhWpPSydBQI8unTRG8/29zEMsQTdLhNZTwWj28
	Atw+UMQs3vYlJtNMhRaNckfeThXWLobWsz4PiA2AhS+/WfneVi+62F1b1X0Hwg5Wy2Qyzw
	T8jbEuTHMufmSGPgkTgB+wclfjLXEr8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790060423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUSvcxwAjOagxExG+YCtqbw/zqf76SxzRMOsR07aEho=;
	b=2m0K9/7m9C96p2M5ycCrNeKN3rdqUBd6T+oL0RGhZombni/Q4hLq42XyAYZ1FSPlgHUmmu
	PoZA0qbzViY1CgY2yky/dFOvbWr33TlYWXE25TvYCLA4mgKPde23inFw/jquRJnssC2+OA
	cW/28yk7jHZtP87oA2mD+u/QSosU9zM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 314B51476;
	Tue, 22 Sep 2026 00:00:18 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8C963F632;
	Tue, 22 Sep 2026 00:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790060421; bh=6Kp8giQhkkbgExJsxASyiXv/PoBHskz4VQuIIjYhF+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cn1d6rou9SdrLcLfFzTuxUb6pl1re6Vl/j9CK3MrVwxozTBiOaC3aP6OhuUrGUmam
	 skiCDbeXynMb9eADcw0zp5cJdtit++8JeQSxlhwXyWgUPdHy5LA847YK/6wjhqaOPY
	 HQ6cRNZ7G3NjJfAbADxcb2WyGxrIKlc5sanNVSuY=
Date: Tue, 22 Sep 2026 08:00:16 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <arIngE4f82b4Jj_v@e129823.arm.com>
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
 <20260921-fix_split-v7-2-d25ec991159f@arm.com>
 <36465f31-59e2-43a5-8cd8-f8bb1844da3c@kernel.org>
 <arF74QGjx6oCIBnR@e129823.arm.com>
 <f3cd3778-7423-4241-8dd5-05eb63886e65@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3cd3778-7423-4241-8dd5-05eb63886e65@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DEEE1C0002
X-Stat-Signature: 56ndntcbd6ytysfmi3o9q14oa9c11fzb
X-Rspamd-Server: rspam01
X-HE-Tag: 1790060422-62764
X-HE-Meta: U2FsdGVkX19m/AAzJ4n/OxN305caG3MYzKcJhWDku2vCnSTQRqWud/+IupCBiQEUwDLxAPmOWhhxSOkfDYQTi/rA7TyMNjvqB5QXRyf0X8HD7rw3LFEnkCPBvXRFX0huRqBrJ+9BKFFz8tx42BsK827dJNfu9gmEeI+hJpeWB9rHcx+jKkh7sQYkPHKZ9hn7uP3ypLa+6kYL2fwF7G4feGc4Bhf7Zpene9Q39fZ/FCsSb+zGodzgPqLcnpKmNTp9VleaBXUzsGj5/UbpiXyMKCBcme4KVtUsS/tekxsa5zlsN1zi2gcCj2CLYf6Wna9FtLUawr9yQPMmkox6Mw/xAWUnCdiwyT1W318Eptj82kf1uolTHvg50LpaWHhtzYk61KZjzl+yihASDtnt9yrNm4GCtS8ydS84NRcEB37+XqB7E4u8wFMELCiyzX0weQ/ru5xkhX8SjKZJFioLWacaDP+R/fovECgI06Crz3+8K7sRfSviDNtubY6xJOO2ihVwx0l0vW5Kc7vzBCAHOY7RfyxBH9jjf6iM6id6InTXCvEUoAS8JLNWPivwmr8SOabrRq0HbCkUYNho/jdYCC7uBbiHb+Uzli9f9KRoUe9UherBi3vf13ydNwUzv7UMFyjQK1VikocIiLDDsg9qM7UIWpQfb4Fn2DL6GSWxpmRHJbgIIAw3XbpoITMl7LWNDa60ERuCkbcwrTvFRk/M1FiMVcPZxwSyhr1CYlyCG10C5Dx8JYSxjhc2wgiWl696Uph37fUngkZGKRmLbtvzA3RHbQvN0HyFKB6R4mvF2ppcRgscjbWDWaCTaYWZdh0YOacqKjLEz21oEeOEQ0+haTXMKz0plqqps5Ey/85nMK/rDAlTMTNjpQykYMcgMvbF7rackWjKWTVE/PcrkugEasibG4ahRae6sSKq1c0hv5d+JfjdCTdm/MIo272HMLqcUj9Nxah7wez+0v/YsxtjRW4
 dhZz1kuA
 w8XcgKUocoDRRMbdfxjRHvUJls0+YzN5psEcupFm8jSyLPW5MY8kVS/0+hY4KLi9AjB3yKdWwCZdYngMxpqqHQXQ87VEIzxQE/aBotDoZxZL1o880mOY2TSzH1li0ZSrOLHCwX9ROPjyzRTc1vVvGJX6W2fYYMkla5U0rbrKkzbLco7t+GUp0uveNNIJ5xbs/8yu7EU6E/d6lArhlfSkaQDiPuFOzZDNRuu7PDMTM/uUjFlVno+NEDlSfR+oEJHjCjiXCHsbhwtWcYFWE6N90xCAbfMKalM+LQnMo6gXK0libwi3jmm/ykJdcseyiWs7/2faYT9UWtT+V2p8Zc/52tnkFiAIhlKRJA+tl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 11:05:15PM +0200, David Hildenbrand (Arm) wrote:
> On 9/21/26 20:48, Yeoreum Yun wrote:
> > Hi,
> > 
> >> On 9/21/26 12:40, Yeoreum Yun wrote:
> >>> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> >>> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> >>> made by memalign().
> >>>
> >>> The underlying VMA may start at a different address from the aligned
> >>> address returned by memalign(). Furthermore, a subsequent
> >>> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> >>> already set.
> >>>
> >>> This causes split_huge_page_test to fail because the check_huge_xxx()
> >>> helpers incorrectly require the address returned by memalign() to
> >>> match the VMA start address reported in /proc/self/smaps.
> >>>
> >>> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> >>> /proc/kpageflags to detect huge-page mappings and large folios:
> >>>
> >>>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
> >>>      using check_large_folios(), since only the mapping type matters.
> >>>      This identifies PMD-mapped huge pages.
> >>>   2. Otherwise, use check_large_folios() to detect large folios. This
> >>>      covers mTHP cases.
> >>>   3. Check the folio flags according to the type of huge page.
> >>>
> >>> Since shmem pages are also file-backed, simply check whether the page
> >>> is file-backed.
> >>>
> >>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> Suggested-by: Zi Yan <ziy@nvidia.com>
> >>
> >> Do we need a Fixes: tag?
> > 
> > Since this change is required for the chaning of behavior of glibc,
> > I don't think we don't need to add Fixes tag in here?
> > 
> Our test made wrong assumptions on the underlying behavior of the user space
> allocator (no VMA merging would happen). So I'd argue that we should add a
> Fixes: for the test.

Okay. while I do
  - add intermediate patch before this as you suggeeted.
  - on the intermediate patch, add fix tag.
  - based the patch, rebase this patch to add anon/file check for
    other check_large_folios() type.

Thanks.

> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely,
Yeoreum Yun

