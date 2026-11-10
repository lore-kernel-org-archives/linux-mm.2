Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7B7606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cJB/+A42
Received: by kanga.kvack.org (Postfix)
	id DAAFB6B00EF; Tue, 10 Nov 2026 12:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82756B05B1; Tue, 10 Nov 2026 12:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF256B05B3; Tue, 10 Nov 2026 12:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB8EB6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:50:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57315A87F3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:50:38 +0000 (UTC)
X-FDA: 85419949356.07.F003F36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87C1C4000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:50:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cJB/+A42";
	spf=pass (imf01.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7tnA/F70Gd3y1QO8DNlp4+jtcIGX5LigggEd5naaV7A=;
	b=iC+cRRgYGELGyZw9dhROzmxco6ZFu2JDi+H08y1GEkuIs4CfKYFcUGyP6NQ1OMLijLLgRJ
	STyoB81YvHewFmd5neyq7OU4ZlZizs+MmP9otpIdSjlD7I4WNUNnZwuAkfznWZyQZrzKur
	s2jqid5jNLaZf+QYgJGjoParP1Ntzog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333036;
	b=4cGpJtRVoDQHySm6YzanuW6EFfK8XhAhYPq7jt4MjtCPkYLCYwhHU/ZxpoijVhVG5HRGoi
	lhEWJErdcHOAaicH1HW/HSDYpuhJO5D9kIt4Gagu4XeCDNkUOjGiQpvpe5gy5XFKUcajVS
	u+2jmrfRV2Ox4dPiePpzW94jI620Lu0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cJB/+A42";
	spf=pass (imf01.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F23FF63ABA;
	Tue, 10 Nov 2026 17:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E291F008A2;
	Tue, 10 Nov 2026 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794333035;
	bh=7tnA/F70Gd3y1QO8DNlp4+jtcIGX5LigggEd5naaV7A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=cJB/+A42tLFr6iXI2WGibIgYm6AO9fwl8Jw1bcvBtU88ZvsSHr+6Gf0U9cgwh/VbY
	 KC2XTTKtM2X1H4UfNKC0Y6ndkMB5qMRMKgmtHYRn7qo0CQe1C8BWKWuNUt6sJKNIG5
	 +4ZlRtqCcUK65GKPC8aMEIF7P70PMmUa0keQ3BLJmNhM2uI/MybTWmjbR0qF7RPJRs
	 MnS1scVmTiaA8YhbYQqSQPLdVr2Y4gOlg+zXH0qs+9kwFvJFqwdSXMbrC8ElkUyTIq
	 HiyVoQNFXe81yJJ+DVgO61TkxVx2qblMffzrvpa16bk66/oXWbV+RhkoirBrEJdNZ8
	 TjLCKeB3k+uKg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B1F239D608B;
	Tue, 10 Nov 2026 17:50:35 +0000 (UTC)
Subject: Re: [GIT PULL] page allocator hotfixes for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <717f8bde-96fc-42e8-8f69-a31a8a8d6f0f@kernel.org>
References: <717f8bde-96fc-42e8-8f69-a31a8a8d6f0f@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <717f8bde-96fc-42e8-8f69-a31a8a8d6f0f@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git tags/page_alloc-for-7.4-rc2
X-PR-Tracked-Commit-Id: 2122887b04f3f2d76daa80055c2c273926032fa0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 067c5c24cef23d913b67eaaf71ae67e7169a6620
Message-Id: <179433303435.4118775.10272509575092420155.pr-tracker-bot@kernel.org>
Date: Tue, 10 Nov 2026 17:50:34 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Josef Bacik <josef@toxicpanda.com>
X-Stat-Signature: gzp3m4uqa7dkn9qzni8q6xrohs1zj1pj
X-Rspamd-Queue-Id: 87C1C4000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794333036-201947
X-HE-Meta: U2FsdGVkX19837UbBl12njPw7m4w/3L1RKu0cgzcat5FZlLjRm75q9DW/JCwKHf3D+dVvhG+aUicfLF1GNhxa2dnDYpMmN6Yrb7AH3/VqPScjyxLxLCSyzSs7MdbcNiC7Bh/N+gAbESC6Otphr/Xqj4bUFltPXs1biC7KbK3CqlZmr2rDMCIrymDMJIZ+sY8WhivoLsfXz8UjcW5nx1rVI089VeQF7dGNZmyxGNm4Z52eZik2S/SnWBU8PYr5MGoHg6O6pRXc1z4U8WMwNyRThg0Q1Ik4LL+AXE9tbOQvwEShlseeBJvojT6tgj5tYmPOpkq95nhzceCuc21XzMEBVJNvUj5JLr1yQLSwxwxIvlegOsl/b4G7uKyU9nC+aNOvOZ3IpVeInkYQ+oUMmKiD629DxNj7qlh7ReZijznDBK8Z5rnHKPQZC/8WNWk0Ao2zsloLqwR77r9iWq9QbZgeF3Ew+SVyIendtatNKgsYl8bPmAabFo0S/3bmu6KpXS/U5fcKvzSOf24h2qWz9eIGlx8t1z00uedDPVLHNCQqXTZoVx/t8pUPTHL1o10Od6MBeUaHm8dLCOmU9FVWJqcBv+RRqAin/CsRnuQIvKx8Vnkbg17FtgxwF4KCmU+tVT3hA5OlAWYEyE+VTHo8Fzl1VMUjRhyCPtGlK9FZqnuRiiVFIpPFj4JBsOe0BDNFlNFVtnH4qObTM07vYsIMsABI+iLbF/ZoiEYOGnYcRQSyUCEKc/ohbSsjkpj5MBkvS6737/0o0JAp2TVz88OQP5btT8DQhVHIa5c1pkVH4Llv495etQ96Niz25xA9LytBOTdhadIycLSIFzdiEMfi0aCh45jgzxw/4e13WGUEuwlAvmReIYWBmgiGjQzrDdmv2ObjTVfpqzeMlUQZLT+hlhQLsTSkXYAL5Kx5k9cfHGi0o+eVDAt6wN2fmFEbN8YzABv5yyuwygI7CDXyMLqeDW
 x8xA6rot
 axcU5uIsoUmmCI2oo5GmLK367UMyruez3ywpTG5ngm6yk/ota1miInQyaNYU9Dx2GUNACJYtwqq5R99Cw+s8aW32kmU+YsvKzXdjwjC9vUTHOb82V9sDT6or5oijyzo6ceiFqSctZqeTUGFUfUStw7h82k403HmexstlAvtuvSzvVS548/UHDNnRWu4Lj1xoSWGXC0QYoMbN1TCVJyrvx5zrgp4t//wrK9Z3JXcbK08OYkycHNQgRqk7//NEyY/kl+ZrS5gFCr5qn7bOD/WDlAExbJKgcPCSBMtjNTuvD0InqgWgQZ56VXEVIQH2s29FfzYVq64MiJHTnVe9Z3RtVl3MYSyhy5NaZOutMKRbHfyeHn/Ms6V8NPiO5hK1liWv3KwrE3ksCESWP3PgCXpeJ5hW45Nepjdv1s5LIdamVuViLUjtiYva2qjrtnWCdy6+t+FuMgYK2HCeohZmXBU4DMk/M2JVAWC6yK8KV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Tue, 10 Nov 2026 09:46:04 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git tags/page_alloc-for-7.4-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/067c5c24cef23d913b67eaaf71ae67e7169a6620

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

