Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 752B2FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01826B008C; Fri, 24 Apr 2026 14:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD92D6B0092; Fri, 24 Apr 2026 14:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF04B6B0093; Fri, 24 Apr 2026 14:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD8186B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:33:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C8E61A0269
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:33:20 +0000 (UTC)
X-FDA: 84694296960.08.4047471
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6B71C20013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:33:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mrD6+2KR;
	spf=pass (imf03.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=qHe4A8AKhRP/OJlGNqsidgvyJmXl0IBly6UDhGbW3/0=;
	b=37ppyITKnCqvK6bf8lYJTompKuU43NO5gSaEKL+nnZX8kzuw+3YEp/cG0YvPBF5doSbP+e
	Br30v83Tp2V1CKTuRZ8mQ7lSYOoapPRZ3aH5EuTfpwDNLyDGkZSjD+O8ViyJWRGEEToEZI
	jA2WvT59AKIWN3Fz0YrpOQR4T/zwEgA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mrD6+2KR;
	spf=pass (imf03.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055598; a=rsa-sha256;
	cv=none;
	b=w7FZX+sCk+XL3xsBkBZg2+uDIHEqywGdpNHDSsibJa1MG2axTgqIcwuvslbUEFMxGkgTXs
	tI4uBMrS6PmCx/G9ooBazF0CFn6sUhFdGDj8ne3vu4gq1TSUp5AQ0m7B0VqFD/4Im8K7jz
	1SwbjU3V7Els6DvJm4d2Kf5deypQwxo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7ADCA42DC4;
	Fri, 24 Apr 2026 18:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589BBC2BCB0;
	Fri, 24 Apr 2026 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777055597;
	bh=MehmIB/qy4cV3IizsqHxhrg05rTmG7J8wBgGedaM40w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mrD6+2KRoXcwReQrMHHeGJC4tGvpI9kpNgTxJRACcx4d752nb8dAW2qL+17yMgPdz
	 79pmgSfDKA2LNxlVAXuMejebf3PPVWyIJNE+FYbdD0NRw+4wf7Y1g7x+0PjWX5xmH7
	 k6RmjQX98N/HguOGbieidYOleIIEA8bTVlEBUVlsvt5N3fd893mTORHaaFj7e3IdwA
	 eZDTc5zpf6KKj8jIbWYMerO+gV1wPaBj0vYFwrYdPrFIul1Y3egBTV5xSq0s+JczKt
	 S9i8/Hm+NyE5KYOYc+V4RAKh10Y0Sw1GGX2B8XaQkCaV/jWGCkIkU4ww4swIzPNh3O
	 7GmQrvTpJ8TAw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D4A38119C3;
	Fri, 24 Apr 2026 18:32:39 +0000 (UTC)
Subject: Re: [GIT PULL] slab hotfix for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <2123729b-578c-4f47-a33d-d1706dfd2712@kernel.org>
References: <2123729b-578c-4f47-a33d-d1706dfd2712@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <2123729b-578c-4f47-a33d-d1706dfd2712@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc3
X-PR-Tracked-Commit-Id: 082a6d03a2d685a83a332666b500ad3966349588
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 82138f0183b40e76affa427bb59c57f079d41ec1
Message-Id: <177705555771.1656274.11151362651629306555.pr-tracker-bot@kernel.org>
Date: Fri, 24 Apr 2026 18:32:37 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
X-Stat-Signature: bu8n6w7cgu4dqs4i64cjd5wprdo6dnot
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B71C20013
X-Rspam-User: 
X-HE-Tag: 1777055598-443234
X-HE-Meta: U2FsdGVkX18WB4EInBz4pbilmwlAsIP3qwHaw9lnnGINknCFSv4wWolXp5w8DVp6Qfrb9QbQOhaxpDqP1mhiJvsbUs+sWNDApfSQxSLYX544gJ5BLLur+qKag1kP6uT9mXY6gBqm0NxYAXb4LpnlOe7vaxWtB2z5Owj1f/PTmietUiFz2/CCavKRw0nBgJ0K5wH/wtJjtDt2Px8Wm6NEN44BSnz5BKYOsjwyq0fziUhjd7zYIrwO9JNDvYp/mkEKW4x3KiMiYqM43Y4xL9BeWQJgeddFLOvmnk1o16Pw2h0+GC/BGOxJxdQ7/VMzDHWzhPvMn5AWouTblOrBBwG0Uaky9MQ5ZgkkUol5Lku3G9RYUhRdaPHJpStvHLDAjBidf7X4OU71alYPNgGxRH+P5O7esWZ4QxFaXRYggkflOyA7Tb0ptY2ya+raOlQn2nJV5T6G1myOiH2EAKDgPlnzPqMnqFD4B5xGZgdiTogzdOTsH+DUWBRu9c/zW4xJJKS5nuaid9TnmR1ifvAFH3+fjsdjIo2EKLBm2SkfVqG6AN5XWUFAYzXV+K2wqAhE9NKuOCbHwoG8M1Y3Ac0uqX0AogBgM9A+Je6/C9py4zzovGFjpA2TYZ/oHnCDNR5KS8bAaLUhwAk5GEeAvH07jt321phbPqPMDmkW+sSUEJn5RSvicFofGbaR9zJzGFPVFfrbBxH1FJIQNyrruK2uRIE1wqiuy0yHy1k29WDelKJdeINJKY8ORrYIGZISmyciKnlivlUGEsgJ99GRxwMhjh4T2qmKWsdfx+jq9ALcyCbkmgo9MO9VhilyCLY4KVMYMeTWVf+/VQ4x16fMoYHmesdlhbJFohFb1ltMBCkzNDqJFjxZ1SlN+ednlrDMsrKV/GiOSQqbtQnRVTvpfdQjADIFo+WRG4guf6aIvxrxsvlNfuqKxb3utkFGP/M65H3iIxZBmRG4s3aqqVHCdvQUM4e
 KopmtHEY
 9Uk0ievhJPc563Ycw3QimP7z74QC+7Msc96bdM3NTeWwHaoh7ijKqqnPIbCCBfqyTUgk+/RFMvyqKgOtknU8yRGHtqpe2zJckObwSuQpBNjNcHUBev7ms2HpsjQl4fBol70EXm38f4V3bMF/ANQCkdDusv+r2qmkqNombfpAEmYrc7kJnA5o9l42SwwGa3vWnYCqC+HyQvI0xWO19Mmof9cLOA4IIbMuf38STse7i05BXiIsTRDemm8PJJdgGDyeSyENZSNScf6hGKP07BgpveDUiHXBJCFEnjdlOtH05iCTeUHu7UJHUBZJEdxlTDGEFJcYwFJOOxDqAnldEXkzfoMmDPfEQjHlZwsja6uHDPyoHwlPBrK/mQ8jjDWVEOe/riRUvWmunDUZHBXHeQdRAoLe2yBw4ASciEW0EG+qmzihErfqY5+qN+PjPsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 24 Apr 2026 12:05:02 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/82138f0183b40e76affa427bb59c57f079d41ec1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

