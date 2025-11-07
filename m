Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A25E1CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97918E0011; Fri,  7 Nov 2025 11:06:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47C68E0002; Fri,  7 Nov 2025 11:06:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E538E0011; Fri,  7 Nov 2025 11:06:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE90A8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:06:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BE0D594CD
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:23 +0000 (UTC)
X-FDA: 84084288246.07.6F76638
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7132F4000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqpGROoV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762531581; a=rsa-sha256;
	cv=none;
	b=HzXrP9qosFRIK24ezeoES0u0Q1QJ9ip75q4d8ZINGWnWDJGNasKehKL/dD3B0qi1Fb8O5g
	RxesL1ds/yVCJTGDJ0Vn74iTVd17qud8GnKTWY1I4BIuVxM+O+n3/y+ppMQk2WNhfPGn3p
	uC08hPSlosGzqmivU+k8ufsbSCrsLHc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqpGROoV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762531581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=KSZ+1KtPgEZzrb0kbu4xuMg8oqoSo7FVQ9q0bhzqUbs=;
	b=lQYp/v6JQEuy15Dq0UGpM2hFAXRbvxm/gF655m2mGi+MmgwfxOlfX7g5BJPh7iVRilE05e
	P6idx0BNc34nH2r5d9OeklpSXP4dNerKl06vPrAii8wQu4Ly0vqSiXKO1oedibm66ZJk5A
	cUVww6qw6hw68fyfXo9wIEspEuX28vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7A796191C;
	Fri,  7 Nov 2025 16:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F80FC16AAE;
	Fri,  7 Nov 2025 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762531580;
	bh=iwD/lIpL8OI5hfUM+FYdmY/1KSRk0/qZ6JwCV0ieico=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UqpGROoVQwaezRxKKgR5nJKyKdtk+NWn2myynx05W7PIM5ncbNZ4t5E4wJjJADldr
	 8Jj3JsdahcJPAZiZyDuajZgn8sPxfEnOPDPuOt3KBYrK/QBXHzaIxlSYx9Jv/bnyj/
	 C415MXFsORPCUxF6YTnWvXg5Xrkdwa2fn3khce6k1ZLr/xIe5tKRa4ne0BJYe1isrS
	 6iyWUcaA7CwicaxR1+3Wh4HSfPJBurswY1v7O3d2q9QtTPQEZpVdJtNFJ8xkBV4L48
	 Evp/totEi5DT4/P+13pQOqkuQO35kXxe5Qi1O0d9bruB3zW5BXkPEEVuWGlYp6DJFs
	 zo/E80gFT7gXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C0C39EFFCF;
	Fri,  7 Nov 2025 16:05:54 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.18-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <2dfea88a-5ba1-4311-87d2-e1e66c2f885e@suse.cz>
References: <2dfea88a-5ba1-4311-87d2-e1e66c2f885e@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <2dfea88a-5ba1-4311-87d2-e1e66c2f885e@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc5
X-PR-Tracked-Commit-Id: c379b745e12a99f0a54bafaaf75fc710614511ce
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a80abfbb1013ffec7aa7e574b5ba9bcf02bd5462
Message-Id: <176253155283.1077315.9187782143764376643.pr-tracker-bot@kernel.org>
Date: Fri, 07 Nov 2025 16:05:52 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7132F4000F
X-Stat-Signature: 856177g5o67rb6xwa9x68tqp8uzkgeub
X-Rspam-User: 
X-HE-Tag: 1762531581-714195
X-HE-Meta: U2FsdGVkX1+pVAqNXc3jZeQGwAR/6bJHUnq9+nMlLCzmzhTyQoXc3amsIUxx28iVsdLa1pRJsvWdS1Nx1ubhTRd8011Bqm0Ls2f121Q1HGHtyE0YDL8Ffv7PKXhUgsZAJD2+eYYyQ/bqi1PKjnQKhHGEOg5c6hzKUqSZrbQX987hVBc83PKQcqVQxwzb7Lw9INi6A99ZDx9biJ/kL2XFPdl0Mk157OTX5lgUIQJX3LQB+StjsT52YdmXClqE6e4y4CuLj0Zd5fSFR/9oNneICb7amtJHR/5ix+KIvFFhPFklYqt3CaxNwGwzLv5V3essn/EWT9YR6sP+wn98kYtIMVLH9+GAy+zBY8CLGoCB1tMB4Rn4X1hqeUIm3kKU8HsMb3XF49keRlwv2/RCk3aZu8b9H0l6lzegTaLwRED1GmunvbMOaUHAEMX4H6QSiFeoitMgdoKKtg1fTUZ9fceHFbSClIFZDv13AFJelnF1ZFiERKUR1vxlQNvN9E1v3UcCFi/mvzFkPh0YRCGtKvXRZ/Lu60PziBl3LNZtLWnXZE0xhoC1nTrKDf3E5TeExZZ4+LhrHqMCFo81nVR5ciAB5ufce5/tHBCPcPFqza3m5W6huvXvVHp84cnc05lPJM0Akx9Q7/OhkrKnoU9LNVW3iI9jxkgDSAlUW2ItgvnCRcpzUbCz7NDh+NVbIid7bMDI/KbLLF2RHkHg9zeqckNmPqaMwV5atOGRxypZtvk4Dr/Y2wxXAmDfWOJTmnkeJt4VisznaY0KaFSYr5Y7R441Eng7bdzYeS6fyKu4rDrzzr7qJHm4ylDT25II+0U0eTVwgwqlLUoJ19T5Rt7JSrBC4EAssBqAaEFjVrq7RhDD0syaO8+OyZPO5Zmx8Qyw8S5lDeMCthXGnoFP55l3sFDfFwUvtsz4Kn0sj7AfXcUu/bhzwXOP9EZn0vZiepYHyXNg4qFJFEC0p2NY/etbvgb
 GriwiCnW
 MqQt5Ze1ZiiWhbsgD8WP0BvuHNHhPn8VjSiGVflwDW5TKu6gngrKQlxHn2xZHZIxrTzEz5X4O6SDjRF92kPzXDa3z/waa6Ng4Sc7FVCFCAHlMEYohCscjeOWwppRL4YFCat7fO9jJTvtbHJAxZ71Wf0XZIUvXLC9eikyayPAq47SQhQAvfyBsx72h8f+i3LQAmztxx6V6ImmOmNZ9cIhqgXFNsX0VP3EF/bxUKKFWLI8VPsmLSi28y6DZX4x4PfNHB9wJXhy4RkEvtTDzxQ6WWR58/w+/CEw+wwJmABvqGp3wKh+xx6sw/PbqzczFz0Qcy9edDM/AN3eMZyBFbALSA7XPb0FTFazF9rglw+EKNiFu7Eo3SJUzvYH9KYk+LAhZbAW7z3GTuvky2dvOupJ6oNgnhd+5I0JLHECRdopH6J/8zpQACkN/jORxLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 7 Nov 2025 09:53:31 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a80abfbb1013ffec7aa7e574b5ba9bcf02bd5462

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

