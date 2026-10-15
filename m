Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0567CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 05:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D383C6B008A; Thu, 15 Oct 2026 01:44:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9696B008C; Thu, 15 Oct 2026 01:44:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFD86B0092; Thu, 15 Oct 2026 01:44:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9156B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:44:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 082101208B6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:44:12 +0000 (UTC)
X-FDA: 85323769944.26.DE4C7B9
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0CAFC0009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:44:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T2QrYAnN;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792043050;
	b=IYstGeODPNx0aVRXVA2t56UyMw0XTyacUe4twR/mZ7wZaz6Pib6iMDZal9bGz/dPstlwZ5
	yE6LNFnE1re+OvnC+5Y3qK3idVT/1Jl0emIabcQ5zbrq6O8scJXBkYQ1wRhPovYq/vQAwp
	ghZi4CZcqIZtJfMj94vgHVDQfKwLyT0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T2QrYAnN;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792043050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbEmWswM52UEIy0d2TLtnoas4yAuCmOkGogixl8GRJs=;
	b=yxt8aOBrAhoa08k4/O+QTJwhAKE7sCYf05Qs+TeIZhVkvF79csFLc1JJeakJ75BdYdaCcN
	k8tKoi2cUE5wfA5sElr80m35NSqt3kUFASW8V8Ux7WRh7oelJXcBxIXe6J3T7tOBuIYqS5
	rZBPHspHLVd0T9Wn4TrHbHFzb+9Wwwc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=v+4Oxbknnw5zvosEcJfstlpki+qDanDvF0iTNHtcWZk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792043047; v=1; x=1792647847;
 b=T2QrYAnN7r4pHFbnp0GoFy3gx0QOeDHO3lgBfNXTAIlGF0nIa6uQB6Uia2d6MrhF60Qkn0Xa
 B8nxRSPSNK5RnluNv64lmw670lJgtuZ08hHMrUgQ34JMUDRE0wFzNA83/7zZNn4JIfAUiTGp/1K
 zO+TQ9CLhaZoiYegpJLPDTFE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3d19a9c5ef5547b4;
	Thu, 15 Oct 2026 05:44:07 +0000
X-Mizu-Trace-ID: 3d19a9c5ef5547b4
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com
Subject: Re: [PATCH v5 9/9] mm/collapse: separate scanning a PTE table from collapsing it
Date: Thu, 15 Oct 2026 13:43:58 +0800
Message-ID: <20261015054358.65376-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-10-kas@kernel.org>
References: <20261014171145.3292736-10-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0CAFC0009
X-Rspam-User: 
X-Stat-Signature: b4upspq59633kysfhxffbgzhqddtjwui
X-HE-Tag: 1792043049-467589
X-HE-Meta: U2FsdGVkX1+GW+hzBQlFjK0V+Q5Iig9FlPqsmnfzwOkb0s7WtR9dG+19KpjMswYA0y7n5kpZq0w/m3n1WOSfbJWVzc2lM2rQLYGSkGJuj6Hvinw/dyY+U4yipyW1A0sQ/znWXocqM8bVPhC5aR0Xcdrwwio0fT2vAKmHXVPRzhqWGw6Hn7zDWnhR5Rp2EqQcuYjMcSvq35mjXLyeGuPpjYsGXWSiyWzlK2+MY2KNCVyGUaER8YhDh3jEcec9ueEeAxIPmsy/+9eQbPj/AWhSpREdicnEP77PfWuXP7dSodqHgdaaL95Ydr7MdU7VUQOr136W6QQXGENfK/DblBW3qPIV7XhMUhwhe9tZB5DpSBK73PQE/F0si1KR2K5XNyjPR1F+wSsYY0kMAzETjhJHbLDcD7EB7Gveinze4NbLO79a8eS4xU8+Kwnimv3N5df5s6WhEKYLt0GGGhLlDrk0NObEp2jWFbBxlCOGWuS/W0KDVmXQveSjlB7uuW78iTW9bGlUyPPyPnnw9xZe/39d0DsZl7DceidqiQ62sy+QlV+BS5yJrpt73vfIfl/2GGiT5fHils/aShlGsOG4WvnexgOU3y5Bf0iHlZKZEpenCVIS0f9QDH5xyG2/KS5oKBjhhrls8pp8wGrW02Yqz4cZToBkhljjcW0XN07RugdndQEbyTfMSwTcLMzNCy1v73Y0J9gr7771ZtjP+W2UgTaoglg+P/QL1rcLhQaPEwZxNtmhdHNOLLtYWM++r4oYrEAAU6M/78egqCd/RSO1i/Fb+QFKOXSbN+ltHeyU+RC7hwDE0y0EsQQbmxmvmxPDQ6iH8U1+ckctHOIbJWDoJp/+R0pi6xI5/6MY29xRnpNdH7wK/71tfQQGkwtv4+TNiBMD9quglyl6UM0FxylYsPQdlsvnBrV6t/8wUoM/grdsSWpKTIQOcnEa+z+dReDHYv8wsvEB1rdgbBG7w4MfRDE
 q11in1rC
 UrgMpPAhB3q3ZoT6W4DWoQh4OGGx1YMk4tPXDrQWIr5me6funqvHhiRW2VDVnLmvF6TY6jUUxMRD500eRIyq+Rx3pVZRsWJC4/yOaMYqN+SfrNsbQ8OM7b/IND//8TYepg7dwt3GD721Q+imijINUFK3yHvbgE9ROS7wigA5+nsyvdY3y2kHdsUIUjJtdtxZXLhqbPe9mmUo8T4R2kKRswopix5O5thUvtUteMJvoDPkernSwBvHKJ5BRLw/YoVp9wlVtkydMpk+1sljK8mEmxVCCmjU+NaH5qjUO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:42PM +0100, Kiryl Shutsemau (Meta) wrote:
>A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
>whether the range is worth collapsing.  The other allocates, isolates,
>copies and flushes, and wants the lock given up first.
>
>collapse_single_pmd() did both, so the boundary between them was somewhere
>in the middle of a function.
>
>Give each half its own function:
>
>  - collapse_scan_pmd() scans one table.  It picks the side:
>    collapse_scan_anon(), the anonymous scan that used to carry the
>    collapse_scan_pmd() name, or collapse_scan_file().
>
>  - collapse_pmd() does the collapse the scan asked for, and is handed
>    what the scan returned.  SCAN_SUCCEED means there is something to
>    collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache already
>    holds the PMD folio and only the PTE table is left to retract.
>    Anything else is why there is nothing to do.  It calls
>    collapse_anon(), formerly mthp_collapse(), or collapse_file().
>
>For now collapse_single_pmd() stays, as the two of them with the
>mmap_lock drop in between, so its callers see what they saw before.
>collapse_control_init() sets a control up before its first scan.
>
>What the scan found and the collapse needs travels in collapse_control.
>For an anonymous table that is the orders and the referenced and
>swapped-out counts.  collapse_anon() and collapse_huge_page() now read
>them from there instead of taking them as arguments.
>
>For a file it is the file itself and the offset in it.  A file collapse
>works on the page cache and never sees a VMA, so the scan takes the
>reference while it still has one and the collapse gives it back.
>
>The file scan moves under mmap_lock with the anonymous one, where before
>the lock was given up first.  The lock is now held over the page cache
>walk, an RCU walk over one table's worth of slots with no PTL, and taken
>fewer times.  collapse_scan_mm_slot() ends its walk whenever the lock was
>dropped, so a refused file table used to cost khugepaged an unlock, a
>trip back through khugepaged_do_scan(), a relock and a VMA lookup.  Now
>only a table that goes on to be collapsed does.
>
>Assisted-by: LLM
>Acked-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

