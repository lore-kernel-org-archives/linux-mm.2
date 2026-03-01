Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D4DFD006D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E048D6B0089; Sun,  1 Mar 2026 12:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2596B0093; Sun,  1 Mar 2026 12:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE316B0095; Sun,  1 Mar 2026 12:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BAF256B0089
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:20:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 698F51B88DF
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:20:47 +0000 (UTC)
X-FDA: 84498158934.05.B7A0007
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F018140004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:20:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hGCldO+H;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=ak@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772385644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvAIZdhDU05bzhvS0yUK26gBgeDI/6YsEKJNf+GOzcI=;
	b=4NjxqKUKRG9pS7/smpYali9HV9yl+G4q1xegCAux3sSiFtUNvaxWecUfv19BJjKtIXpoWp
	XNzxldNfRKsjR//YE3WfD+4cFnP/G8tSM/vT9tpC8EgLYIQUWKZW5ngPsT7oyecX3Soqku
	d8Z3m7/AEx78beAXCAofIP6kYu5+AfI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hGCldO+H;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=ak@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772385644; a=rsa-sha256;
	cv=none;
	b=ANUOXTb5SzV0jgdaKMaDl8hkXxn9eDoH7hEQEyeGEMGutSzKuiOOWe/E4unfbMPzOl0dVT
	7TDe55FQ6lS7tqGbV0SYik2EI0sl9ZyVqRlki4dzjisCYawX3t+O9UaX4/h46wBpqaGm9S
	B9XnpDwHKLVh4EhzSCYVFNOPBjElFdw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772385643; x=1803921643;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HsonetsrJq2UggU5a16zvuZ6J6004u7tBlJ7u6srMGQ=;
  b=hGCldO+Hfq2DMFyWdGNFfFgK/pfzsROiVF2agsYOkXfSOpV2iVIFYZMn
   3OHeWWok9maNoFTp9RWiIQ7bMXsLXxgue9lMztnNSVlIaNXwzVbnIpBkN
   Ac0Z5swATMdzQ0tksfMDo9TfofWD8uJHB0uRkfubIEEMNp6/5LCUGi0Jz
   3G9ULW82Lf/HM6+CLg/xHpmlYzi04PBL6rfmzacCZ1DVVCwNSTk53Dfn5
   vg3elfHU4Z0LGiY2GzRp0eU79tK6GoeYO3haIR+e7SAyEA2DFrimEfx+o
   iI+ppHcuQMmlgfUvawrpX88sk7vqlrpiH4mn26Z7dUjzAxunb482U0X05
   Q==;
X-CSE-ConnectionGUID: LnbrytoRQweMlVCFQXLG9A==
X-CSE-MsgGUID: DGgBQ0F+TBuS0f9xYVG/tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11716"; a="72606019"
X-IronPort-AV: E=Sophos;i="6.21,318,1763452800"; 
   d="scan'208";a="72606019"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2026 09:20:41 -0800
X-CSE-ConnectionGUID: vqQEgz4/Thib1+dBCJO4Ng==
X-CSE-MsgGUID: l/DHTZHkTFOTGJcWYbMiZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,318,1763452800"; 
   d="scan'208";a="240419135"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2026 09:20:41 -0800
Date: Sun, 1 Mar 2026 09:20:37 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <aaR1W6evB8iylaxK@tassilo>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <20260226120818.408966-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226120818.408966-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5F018140004
X-Stat-Signature: 3nhn4te8bk5idki1m5fsdz8y38chsiw9
X-Rspam-User: 
X-HE-Tag: 1772385642-434473
X-HE-Meta: U2FsdGVkX1/26k/nDCFNWpb8P2ztWoWqRoYdzgJ+nsqC+Ou64IaYigwjy28SvcL0pTPEQt72LaEei51Wq+p+8CgA/by+3CYtKY7003VhnG2HiWHq1qBl5bDoj9MLN4F3CQF02bfvf7UxcinE8F367rg/7LszwOJsDXKHpcMzN9YT28zcIantbrgfQziSAquQMPHQtBwdCVfSJb2HlMzu8PDgmn19LahplKupmrTevC86bav4f4CZnfs9wN4VHXaZQu2RaZW7ohKMK0qHONBhTB2+wuLGPLavZPDm5aKv2jSBsZhKAUi27hPuwayd095QCIm3VDBgeugGl7VeTdC8Z1rev8diERbWiDKLFBOVp+g6Fl03ClvXz6KPrVLxCmwb/n0H3pSAf2RiVYDlqebaCUrq1RA0aS8i6o/MU/2PhIkkCPNq/C8aTSF2FCygAAcVD6s21HVpjdy4Q7pJmFLE+bHf5wUUq4JdpTzc1iCB0JYbffcNL44yuJLhntCXOS9i9IK9ZhU5W7F0EDDrMg2qs2xlhV20Omuuo47FR7m9p8WG81kPJ1/Un31JugbQdQ2Xu3e2RMbyuAn93VKH+lc9Smcgf7fGwhywiYYO8TCZj1/HvJIQe0cMz1XxIDTY959ZG1EpRsvlMZHnx0gjdmrjET58fcOY1qg253nsr4uDyiF4VEWPdSgap3N6FlzXjqXwwvSsVhi2Mt78IioIvPoMTUJ/Y93rDJGUTs51YVp4vOu+HUKpH9kIE19FemF9SRtBsXfiTCs99Npi0GwU8UAttC14kQdvnpUZNC8sqgc0lsWotM+Kdb0oO3ugmrUcAJRsmaQ5axpybpyIUVtaUE6uHNC5eQmFY87XhxKb6U9+DaSjqrOf+8mltrqOZxSmjU9mlqJJGfpN2FwfIwFv+rvdL/qamsStah0FupZKPzqpM7twfsWvZ8SjQC0ch9HPXy4bozEniy3X0HpxcYgz9xi
 DIj1gd24
 h7f0wyNZC4hq5VlWNQ87m0H++r/cfFDihaJt3290G44XcUYmqBd8ZNa2akwDDbFDeTfJjzZmK1eDDQMyWd2D3kDgfgVW1H0U1bGlMflARLfoY5Fh446oHnwbBz6meDjCu9C+lW2bDzBg5ZjgtwCQylIW6J6Dsf+BQWF/68CA4NNElYUVW33eSTuJ6byKLuCQrlHYQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> When a VMA has no resident pages (e.g., freshly mmap'd but not yet
> faulted), compound_orders will be zero and the for_each_set_bit loop
> will not execute at all. This means no MMUPageSize line is emitted
> for that VMA.
> 
> Previously, vma_mmu_pagesize() was called unconditionally and always
> produced the MMUPageSize field. Userspace tools that parse smaps and
> expect MMUPageSize to always be present would break on VMAs with no
> resident pages. Should we always add it?

Yes that's a good point. Should fall back to the base page size
then. Will just make the simple logic a bit more complex again.

-Andi

