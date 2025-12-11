Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4073DD3E783
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 00:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196586B0006; Wed, 10 Dec 2025 19:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DCE6B0007; Wed, 10 Dec 2025 19:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB426B0008; Wed, 10 Dec 2025 19:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF48B6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:13:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66C69C0795
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:13:04 +0000 (UTC)
X-FDA: 84205265088.01.B1B2FC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8FD42A0008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:13:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4qD67Kr;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765411982; a=rsa-sha256;
	cv=none;
	b=aVgPdx6/ocA8SIohcFn2Auw1WtSSp6Wdiy6iW87igp+EabjgwHgRjsmUBP5ROgOXMZsYUF
	wds0ACA0reHXBtzZnykC1VWb5XwNyJIHFTuT59VGSfPrssTUTlEFKoG899O6HHcPpVWTH+
	aC/WhMR+2h/dcVjv4qbMAYwd7RItKIY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4qD67Kr;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765411982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=uyMmmM+XCJQwhTNU0fDFp7zD4jL4ZYETObqxMsMa2N0=;
	b=l7oZmlOlcbHmf+hvwxRQWBm8KZSklNDepZvLYHbHrjOzrmSEewmNkZqvpw8S+WMd/8kdK5
	nSPypBLqBQXMwcbeds6UK/SZmoNOrprKDSYUNKptC8zW/HqhTkQZDooDZAhlanqf2qsRKz
	jpJNBeTsKJJt8o1V9+PK7rSJCx1cI60=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BC2F6011E;
	Thu, 11 Dec 2025 00:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D5AC4CEF1;
	Thu, 11 Dec 2025 00:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765411981;
	bh=UTBZ5ex2javwuo/mohc3RjsrKjDklKPy1H0shmopMGc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=I4qD67KrJQyZdIm7JrbN4sFYzP6ZKNycsOIoqJL1V/ruVNh1KxvlRtH54w87dz4Wc
	 xari77M61TrjAn7x5DP0t5+oJ6+z4lVBD2f/RQi8/Nb+asvjCG3AoiE8qtzjcXeytL
	 7BOCjMGtDTLIjjJ3OqjdljvWdgiPTUSI/mSVr07xpzCAlbVibVGc8UJqFKYMQcn2fK
	 oztuENgMpT9sdeyxKi6LKh2YX1FN9Z3WKZv0CzLaU8Yn+h148WmWceqqbpFzy2R6WR
	 aKIWRsuXyvtGLtYg7DnYW+/va1rKxvsATh4+3u1HgPoQNF2qluXZIrblBcDDOCVZeI
	 CgQaR/gmQjWew==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B5F6D3809A23;
	Thu, 11 Dec 2025 00:09:56 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <80e63358-3016-4208-bfc5-242f201d4f94@suse.cz>
References: <80e63358-3016-4208-bfc5-242f201d4f94@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <80e63358-3016-4208-bfc5-242f201d4f94@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc1
X-PR-Tracked-Commit-Id: 0f35040de59371ad542b915d7b91176c9910dadc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1de741159bbb187c8018c4c779acde4ea0188478
Message-Id: <176541179526.775831.1009281730738365617.pr-tracker-bot@kernel.org>
Date: Thu, 11 Dec 2025 00:09:55 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Rspamd-Queue-Id: 8FD42A0008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: senx3za4hi63rwxjrrn8tx8hog7pjhzi
X-HE-Tag: 1765411982-564413
X-HE-Meta: U2FsdGVkX1/fEd36qRoTQaKZWfpwRdF066DEW16P++/PEDxGgB2NjOR0Ij8m6hDanht9eTEHy6YkCC7lcl/xbL+5GCN5VbA43tMKeDDHhJkGb4UTvJH0rlXeWF8t/IcmUk9Bm6C8far712HAaIcozCU2UXFy+EhN8p+ksDI732CNV1TR4s8HzNRs5W5T5XdxbTJWIR5i3OtlU8OcAedzkFjsCnFn191kmtekJoRT3qJdvJ9MtblDvUUx1cawc7bnZwEd/0CGNQoz+ZUzMd0kPt9PM97llalMjtwa7bpGiDz0g7WxHxmsw/hp9EmTTQL90o/2+RybIfk2F43pc1we8wPN7st45wwVDLAunnLeDaI+Az+WcZq1vUIPjWIIMiPFFJGLMXKaAWYxXQrtyqACRHQLAqBeODTF1awEOJNjpN2U7fCBsJX56NshW4MaZxUy2tObO+3CcyoBejgRyKaPC3QPlpdpiDsMa0q9nzevkKe/Dh1FiA+FJeNlMv6PUZXr0d4RO1q/6cYfGrnut61hNZ+KQ6V40oXTx2eQUUrW2r2rsVVqRnFpSi1iPaGcd84RDIczF2hOs+AqgQ2dvrirt+F35e/uPTW26WoAFxOEIlYvanA/bJE84Ih3VbU9y2rtabnDLHp2FzPK00fz+uRhcku6NQfpUA123XeOhp022+Yb1SbwnzhMNEWTamCun+PT1uamaa4DYe/AOfA4+DQkOU330lOuinw8MG8PTQcjTFED88wTW+wE5OC79T8KLDy/MJfXxUJG2F2hSazs+m2LPfMmVjScoOw0KQuAnfmDSIhKm1U0c2eLsaXtTKJhKXZ6BqtnLDtr+DXEH0T/36Fmr9NNJ74u+3imlJ1i3ZzlbrMZWcJoxAbAkUeUWlnYjalDlNHrZz6qBV90VtWzqgjeUAw4Mqaens7JZPLYvDRFepbwS/5scyLduLWP4YnhGwQOMmjWEOsEFbdy82T8w4a
 Q1BWq71e
 OGD2umDw3wCFvG1jbndRbaT6dkZZxHnbmkJPRi4CGQpnFwK044GFQJ/I0Ss3AYhzgm9+tGeBz9L2/DtLwXfrHpBqe29XRfQn5Fzk3aUPEI6suj1ekEgJe289P3dlB0rWGoPOp2MPY+Le0WvbZVll3zznm89SxFNWVbjh8YoDa0MgccRq9VGb1UmHcM9TXqcs0UUqI7T5FyjRSIUOiqqaMzff6Rf3ERYyEfBqkuDhNaWx8Zelru2m1yZIBejUxfJm8tTadXJu7OigwLL3aVNcjvyqmvi9mYES8wUgeVeHG4UTyYoO+mei0nFfZPQpeIfflf0G4Y8f+jgLVFSkmwn7N4YDXai1shGvs8IHW7K9y2GvkYJaWreqKxJtE88/+9d+mcSjoyQTCUbYBM3yIjcCLe8sj5s35jKXiIjYdH38m6WiNty6vtdSRa2gm2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 10 Dec 2025 11:11:08 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1de741159bbb187c8018c4c779acde4ea0188478

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

