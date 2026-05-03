Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2983CCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 15:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4876B008C; Sun,  3 May 2026 11:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875206B0092; Sun,  3 May 2026 11:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D086B0093; Sun,  3 May 2026 11:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63EB06B008C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 11:02:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBB04A0920
	for <linux-mm@kvack.org>; Sun,  3 May 2026 15:02:45 +0000 (UTC)
X-FDA: 84726425490.03.0AD31F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4DE562000D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 15:02:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KjWgS8Yi;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777820564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njDB6FKTepqFQYMn2weI+wCvH+g5DXp35bM/2x9+GAg=;
	b=xw11x8EQEFbj34X4lB0OPGudr7fRGgv2ITLzgQsHsucs0SN/mEWH3xROkk8DUkHKW8a1ib
	mWwRrDkcjepYgL1t01ckpyoO1/X2Cj1kZ3PtlYLNY23b7JDt3jnvnVWLW6iCjEx4fwA6gn
	bp5+53Q+Wsf5G86KzpvIckxzJJRVMZQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777820564; a=rsa-sha256;
	cv=none;
	b=Yt2kdKel5X5WL1AiiTdkRi60ul9LyyJyvr2gQ5fLjPZc4Xnh05Oon0RpVgRMoFyyj0V9cs
	F9w+QOKRailZhPkeWwok+cz+f4JZv8Rvoxjg6qQgbJ2cSIoDtbSiINzDsgdxWPa5rpU9MH
	ejX4yB01Bb7xid+YdmPJmMur2rrEeC4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KjWgS8Yi;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 99A5D60120;
	Sun,  3 May 2026 15:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589CAC2BCB4;
	Sun,  3 May 2026 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777820563;
	bh=LElIeDOTpHsqNMcDsaQLxB7JqdocbC+VJFujQHOSic0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KjWgS8Yi09HktsXwEj0X32oeSUm6hFNnKPxjKolb+3/FOZDdFTNBDTcPbjJLfYKD/
	 jincMbatuAl7HplWQuRJXke29Q+vKGYqaHeYwrOL2RwLPY4owoDj/SuEXK/hVpgUEx
	 pC/N0XL1ZfEIecHsuSgjre8i5C6HfqAIeXWaklVQ=
Date: Sun, 3 May 2026 08:02:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v4 0/9] mm: thp: always enable mTHP support
Message-Id: <20260503080236.4ea7f3fec0e5788d50113599@linux-foundation.org>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4DE562000D
X-Stat-Signature: h74i5gjz6e5gy339518cxe4tf9t19mtz
X-Rspam-User: 
X-HE-Tag: 1777820564-213156
X-HE-Meta: U2FsdGVkX1/oRI8kGs/G85aeeBOw3d3CoEek7VGT1D8xpepKQtNaPrt6mOTkvu4cPzUqhsUDbRDDtMOLv8MpGf51GlVzAjj5lAO9kRRyAruKyz16FKkbTzfATfGjLa/Hhko5qn9XgDlejMWdPAyGB4FXpJgNb+ZHVvdRZNKF39XF+3L7b4o9CFxRMsuLLOK99mjMWdJm8JqNLCi658I3uYW4Aja4JcD1eCdTOXW1UGYCoeCT/ZhtM7Qtfkg0UJRJ1eMMDvM981aqLc5niGiUAW2+26FUIKdqbDhCkOIEydoku/H7drp762H7fe0pySPL86ibzwodZcrDq51SMopaYW4GzUyX5FevqZ9SzLFQkUk+XVHop/m2SPwSvehMRjlV20Up+HcOiUYAM+4aMUxTznNxkrsrpauCulGSo6o3PpDNj/d3u14fH5ss+lRsPwb3gwoCCeOu2cfl3ri13pTI7bW31vfaWPsR1uu5BJDwH2kSqF57erCmCnW6Jn98B5u4MfGzqVZYLzQTdUDARsMz5HrtHoEW0rgwTfiv1fHf3VM4wBJZU8YZwPG6yo5uHe266+qjoTuhVz7IDHnL0dbACxmG9bjBk2gtFbIRnYZjQ4BQPw+jcrYwFjZfOS/YfVynqXr7YHiOUyNfmnSN5khpkiQ2iEzK7zd1kiHAmw0FCLrYEHfRYOF98yIe6CFp8DGKsL79eRr3YiNgyUisLAc2x+kDGJVFz0aoZtM0ZfD/b36HyeWXXkbSUUHZU4E2+lAy1TMrQ6mtF0NuGem29wIR00NOlhGRz67/DeYypumljdVYgSW0iAsy8Bw+ESr7PVY8u/EovPiOnn8cefpxgVyQm3YfAVRjPyNBvlshY2PmDG/YNYmsHMU+487h1IaNT7sdOFmWiGoks82y8cc5L6leT+eWNVqNObyVGOfo/zcn9eYyJematDEX/TGL/I2gERPC1YGnbVdf7FnnG+SmGlk
 VoqUxj1p
 XVUDw09rIXobL4XEE6XGgaxlWhozp1ippQIZeKb+y5n4b62AQ5VE8yrOpzJepxn+5c0F0AZkdDvVPqUklw/5YWlrWM5H0s27KyTMoYgz3XxgjouRixV2Ypj4xwrDfkUMdwBfs6UcoKICs6NsvqBFHOj3JKD1K99oS1GxHOrjay/Ly5Ln3hv29Lt23wuHoJ+FDwgICSMvMEyrVQiwv//4SRCFszaBXrUcQic5fiJdQClnlmYQG+GcJjW9NklwKeDPQFYbdL5ycGSoQwaiEX99UghStMIJ+TsgJpjG19i6RO/zVCu0hjlyl2CRWtjXQDLgkN9oaa5YXlTRzkA/frtgsJ5Xgn/9LDutnmlTF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 May 2026 15:18:42 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:

> Today, if an architecture implements has_transparent_hugepage() and the CPU
> lacks support for PMD-sized pages, the THP code disables all THP, including
> mTHP. In addition, the kernel lacks a well defined API to check for
> PMD-sized page support. It currently relies on has_transparent_hugepage()
> and thp_disabled_by_hw(), but they are not well defined and are tied to
> THP support.
> 
> This series addresses both issues by introducing a new well defined API
> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
> new helper, we ensure that mTHP remains enabled even when the
> architecture or CPU doesn't support PMD-sized pages.
> 
> Thanks to David Hildenbrand for suggesting this improvement and for
> providing guidance (all bugs and misconceptions are mine).
> 
> This applies to Linus tree 08d0d3466664 ("Merge tag 'net-7.1-rc2'
> of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> 
> NOTE: I used Claude Code Opus 4.6 to *review* the series before
> posting. It did find one issue where a pgtable_has_pmd_leaves()
> check was missing when assining huge_shmem_orders_inherit in
> shmem_init().

Thanks.

Sashiko found a few other things to ask about:
	https://sashiko.dev/#/patchset/cover.1777663129.git.luizcap@redhat.com



