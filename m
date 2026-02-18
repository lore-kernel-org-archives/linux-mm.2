Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E80E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41026B0088; Wed, 18 Feb 2026 04:16:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EE56B0089; Wed, 18 Feb 2026 04:16:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDCF6B008A; Wed, 18 Feb 2026 04:16:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB5F46B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:16:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 729BD1B4A02
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:16:30 +0000 (UTC)
X-FDA: 84457021740.01.7CD862C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id EABA540008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:16:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnD4a6jJ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771406189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+Q7nUDhISkMwUqI/aWb4Grvmbo5b2lQaCpFvc2FC0Y=;
	b=s3Xskwc3DIhb/bwupIjyRMeYxakQzQ/1fkiePTs7aZqhYwnqYg15igVRfz2ux/pJ/bU5Ip
	l9Esn/zY+pdEjnswUvfSu5vkW5iTGCP7/PFGlt4ozBuizT5LgsauyvgJHsx1csEq9Ad/hx
	UghNFKzBStZbo/So7Es/26zs6iD2mJ4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnD4a6jJ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771406189; a=rsa-sha256;
	cv=none;
	b=FnLtwvVvgMY6jFLHvQk077d14qtxwpTGxbLAhOJJrxwiXP9mk3CR0AIF7nB/k8PvIxja01
	EaySi7Ja//XWX/y3hdehI2KTbjUCc06fz5ynfDa81QK89yfe/HddPmVBB9zUMumsy/ea8U
	i3ou02hnCEuBX74NPkTgv4nAIb1KpXk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BB9D60018;
	Wed, 18 Feb 2026 09:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C929C19421;
	Wed, 18 Feb 2026 09:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771406188;
	bh=39DroJTogKBY87voxk5lhToETPVp1UL6sXM7Ll8wgOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnD4a6jJiHJ/GFgP+OakmEhSUPXYwdRgVi0fVi/819FwyCRH5zTgohtIrEzhDDWPf
	 TrDFMaDtvgCCalnTjml4kJuLPxLer/bn9RCgReeHe3PgaqFGXIoZoweut9EjOEsnsu
	 l+7jgwuA+BffW235pm1t1pinms6MNJoP3dZbjVIcyh0oCEhqIPyst7LlDeuMTYxk5X
	 AAHeN9VzjGtgorWIN2zqwTleuaL0oCOsam0tta/lDjsKEoBLb9Crsz2ta+yri+X3Mt
	 zB8rk7/pqSZTBq1uYIoe5FwjW5AhOYCCHwjCGh/Vhmweb5q55jBbKIkU14yLGuqgjV
	 onn2H/qNuq/1w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 6.1.y 0/4] mm/hugetlb: fixes for PMD table sharing (incl. using mmu_gather)
Date: Wed, 18 Feb 2026 10:16:03 +0100
Message-ID: <20260218091608.25726-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026012605-uncorrupt-yanking-4155@gregkh>
References: <2026012605-uncorrupt-yanking-4155@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uk6adho556kop19rtwkq45bpaghnjfjw
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: EABA540008
X-HE-Tag: 1771406188-352926
X-HE-Meta: U2FsdGVkX19G9F8EIxQtiJUqt05F7gf1UJJ41iAUfuP164bnUKByEFo/06qnYXCJttS8Ky0iWqLuv/6T/3M+UJlO/4yJHjSeVL8YBEBRnElWSwl2TBg3KRqrara+MbGZFpvMzOOYkLs+2VZzU67X7WUVfmBr5tVPMu2PYKW3pGGhHUm1VXizDzeyFG/X6WA+m4j5yZJZReJk8a8puxt9Xb18gHAO5Uoq66UOXmbqaBlZgWuX4WgCdezSxh31gqK3wJ3YnktGZ2nFYALqXvguCweqXkskb5Pvc4CypNL411wjTvxzP6ezxyamn7LCI/Focj/p1SJ1qj01ZjBqzYm5OCxMPE+QzJnvNN+RcSBoXLTJAjXNmvOPmtiKKp0MrqCp7rd7wGgaNDzUCf6mudJcDJ+xz+IujfUvLHOJkV+JTJ/oP/aHSuKtK7wmNVpccV/kpvLyy31gD0m4Ins/9Lk5KSiP9c3GodaaBFmp9aagBQzuXaQWth5yW2EAhp8THaeAJRxuAaqyix0ytBYhzdR8hOVPicREL6Jd4HVgI7FX5Ji3vRDloR5cuwg6YHjT6vLuZMrawX4NPp2Y1JfRnLMkudiDZQxJa7opRT0AOCq/smVDWADoxb+FjxrlFSJz+IRWZ12SzSX3TCr17PgM7ttp3G+Egr3gVXp6hLQxwR1Dm+cTamgYohpTcnVIR7m+5Dtksf/rvh9SYuTrhswH4fKeW0RKs8YyROaARfoJ2qfxAHpojGg+jgUq+5bE7rRnNP4OM0JTIl1VWabz0zofYTzvsZtJ08T88hwQd76uz2yQ4dTwXZNMT7Kg7CgswrRJLs2HhJJ0G3oBtnOubA97BbGOwWUSWd+v4gAgM4mUfxf1JGMDxxMnxH4lw9ILAG24JJVvpp2nSxdqmIxsm95nqul6kGgKMSNyWmfZOc2wAm7E1VHdIp49UtcAU71iA/2u99JsnQCppyvfZL6/1UhBx2L
 proaP//t
 l+ZNXytKp5FZENbkbCCoH1nJQRVmorIIELcuO280EzkC4bA7aKXjMqbomEUrw/dZhiu8a0aU98SWNduJvsNEaxvx4JpyrLjCzEgOr0GUzsUKQM+Fcnw1i0zLQy+PWJjvKEv6cRSk76KizQ/0I3PNPXRA2aOUQPZgk4KPZOE4OBDDYK4QTv7GqSBvVgo6EOE+83Gx+Osb/yCTEL6MW5ws7utyxtKYj+tbRR9j0eEV4ylOk/Ci85h8DSSKwtUpMjfP92d/lV1uBCjXSz1PAMLy11F7dlmLO4BAvnIDd9uFieMY/fD21TSiy6iMe1L055KDS16Ee2myyP5n07YSx1+D++COJ+yoKzrzHMUUnELi7hRh4N4QH3y1l7WSW5iRj3l50rzBcUvDyS0ePe2ANV/chqE1uS7MPxRalxFcChhanJd2H+A97L/cHlYv4d2dGXne6rO/ZcQpF5/F6XdpOK3I+RQmqCEpv30djmEIz7vNhSH+2Kig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Backport of [1] for 6.1. Backport notes are in the individual patches.

The patch "mm/rmap: fix two comments related to huge_pmd_unshare()"
was already backported.

While backporting I realized that Jane's fix was not backported yet.

Tested on x86-64 with the original reproducer.

[1] https://lore.kernel.org/linux-mm/20251223214037.580860-1-david@kernel.org/

Cc: Jane Chu <jane.chu@oracle.com>,
Cc: Harry Yoo <harry.yoo@oracle.com>,
Cc: Oscar Salvador <osalvador@suse.de>,
Cc: David Hildenbrand <david@redhat.com>,
Cc: Jann Horn <jannh@google.com>,
Cc: Liu Shixin <liushixin2@huawei.com>,
Cc: Muchun Song <muchun.song@linux.dev>,
Cc: Andrew Morton <akpm@linux-foundation.org>,
Cc: Rik van Riel <riel@surriel.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liu Shixin <liushixin2@huawei.com>

David Hildenbrand (Red Hat) (3):
  mm/hugetlb: fix hugetlb_pmd_shared()
  mm/hugetlb: fix two comments related to huge_pmd_unshare()
  mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
    using mmu_gather

Jane Chu (1):
  mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count

 include/asm-generic/tlb.h |  77 +++++++++++++++++++-
 include/linux/hugetlb.h   |  17 +++--
 include/linux/mm_types.h  |   1 +
 mm/hugetlb.c              | 143 ++++++++++++++++++++------------------
 mm/mmu_gather.c           |  33 +++++++++
 mm/rmap.c                 |  25 ++++---
 6 files changed, 212 insertions(+), 84 deletions(-)

-- 
2.43.0


