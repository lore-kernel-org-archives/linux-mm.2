Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FAB5D59F7A
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 09:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9136B0005; Sat, 13 Dec 2025 04:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9C36B0007; Sat, 13 Dec 2025 04:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BFE26B0008; Sat, 13 Dec 2025 04:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8676B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:11:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6C05C0600
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 09:11:13 +0000 (UTC)
X-FDA: 84213878826.18.8E9692D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A30C1C0010
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 09:11:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KaJ7NElI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765617072; a=rsa-sha256;
	cv=none;
	b=JI8zF/e5M6XVhBUh2S36gMEdwj4hwlWKpfSD+DdATNxVrkT+oOf7jENwVDBU/nVnwN9vck
	2mNl6smXIpSuTNI3MTfwU3OaFQWVGrJRVgmhh4QZI+sjGp58/MG0weYuZYpmmfERS8wLnG
	E697SrXdZAM3+r1U8KqeLbtyyhTV7zU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KaJ7NElI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765617072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=UudxdbRBoMaRRadrhwHgUUd4Ja9DzJjSAzRoPEXZUbA=;
	b=BoLMh2fwxffe241/ENQV3+MAu8vpoITj3nzcuLTeXemwLRoSCRewkbP1jf3+AIz9dRGPKx
	Ik+xnOxAdM6FsPkGrDwqah4Ja2Pt5/6V1ZTUkz2pkJuQoF17J7Ndmt6HmokfCEQT8BvOdK
	doRtPT9bvEgfoHZ2iIWEZKdaxskrE/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50A636019D;
	Sat, 13 Dec 2025 09:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F54C4CEF7;
	Sat, 13 Dec 2025 09:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765617071;
	bh=8kaMKdggW6PmADocHhcaePSRDkforroNc8Y7TLMr7NA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KaJ7NElIEjU9e14jICHyEsZK/BjSEGR+RMwpjFBagEH9ExqCYVKckcu7WkETVi++a
	 7JHE3uok5iIrFahxgD0QEn9He95KpT5YC6xPbADgTP7+qasIYbcyh5vcBqfxtMKO4d
	 avObKF3d2oWLKu+ZTa8sZXKciImOUrwGE7+FuFvgkusZFGBJ0ec7ImLW0m6ITlGU6Q
	 IgYLNCmQjqMujQOYeMqljM6DDzkVDyRSUT5bp3mnvj+s+EWULXqu+/T9qm1ZoScpAi
	 dpnoux4uPuR/sTxX7rpvPdW0aFMMbt1KNBHbQ46lsPrtsQt+OOLAseETxjJ9b2zmqD
	 V3mrI82cL36Bw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2A25380A956;
	Sat, 13 Dec 2025 09:08:04 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251211131127.defed99e5b82e49af605108a@linux-foundation.org>
References: <20251211131127.defed99e5b82e49af605108a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251211131127.defed99e5b82e49af605108a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-11-11-39
X-PR-Tracked-Commit-Id: dafdba0964bd10913fbaa5537201cbbe05df5b9c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2516a87153183e1797021879121ca25c95f1ea3a
Message-Id: <176561688356.2460530.11124774899123193311.pr-tracker-bot@kernel.org>
Date: Sat, 13 Dec 2025 09:08:03 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mm-commits@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 0A30C1C0010
X-Rspamd-Server: rspam03
X-Stat-Signature: 8ofrdegkqt6k3mfirus8wezd7ocf4itz
X-Rspam-User: 
X-HE-Tag: 1765617071-981540
X-HE-Meta: U2FsdGVkX1+6i4JV2aXrNKAH/deF86RLaXMZIf3Uda4Z5UKl/md2rWPnYV8YzsQh36h6nvc2YvjGixBLPbuNKe6Iici6yPdSJj82FLpa8LNON3orJSSKvbTVDJF+12uZ4R2EnhBeA4njMeC3ewBa6yPBsy/Kw9x0uztcobKsnRuHIgneu9QMj1hF5FO/g2FIESGktnu4nr80ifWB8uZuKbSlu/IRkgShw4xrI5kFhV5umQrlHGhUjOvjxl6rtW4f9W7Ut5/ZRBM7agZPe54M92J9IDT6Bi1oNnVY7gkdDSk8Q62RipUfvJA/OF10eHznNxxBjGo5Eex95eglNgTl93B4JuIAErm/q2zfHAwHoR2pn5ed9YGSeGmbyrMp5Y425sRdVvq5z9S7nDY52dod0PzTYZJrdzF7gYgO+Y72qZZSbB0HuIub3Y182pSkLuq5PIjZNvp4Nfv4AvQ3CnMr+hKsEFlLzi3beOHGlbMceOR/Cla9PtEj2maHgZ40hD42vWkhFxguhteGZilD0uSbY6Q14gp7Htf9JbPBAqrR49+RB5DJg9sVGlFr8eeEcKzMBwNT5uiiqdT4ggDDpxKWJ/WegSfngPPTLVBRDHay3Wld7KooZqZPMfOBDBQVvroePAtjZ0kxXE2dboCEViiEbaW8n9mU+JRiVxytvTBBSnHA0G8GFa3gVVSkpjwKN4Pvx2ZNI2Kh/CTsAC4LmMIqCvKrcP+nXv0b1e8XxQXEjBOHTaKYtDPoEPTniAb7MsRaW/ocWuS7n1y0WYe5Hwbz2fdAJbipSVtFDEOeKZxXHHOCn2aW2YtvMwKWA1JY5Idw26JQYxjHyroYoAINZLhK8SM9TGgow6t1Y0MRkS/vhXkrPWcf6vK8xppdBrLnKcg1PUHK220izqh69ThsWnCMGeGfTg0UFlcs/opTAmDpmEf2rAwixLIrZGyCCc5mjHHMmej4VqIhNHmslD9QfVg
 wY+Nv3cK
 P320MnGX1WkyEGSXXbbr26NZc4q3EsRfliLyEDGqdTRbenFsR5gqtwwCDq5pQLR+Hg93Z+dCCUDzxs39rx95xA1RwGVgo4z1WNTxVVoZfUDg3JQrBIZpzvRtDwPWIJ60nt9/R6ibOhWTO+sjx0YxbzEoqqHUnfdp4VLCGG0sreQVMaLzk0FgZ30iEGAngGKwv4x2MJ5kXvSrTH6i8UwRmKijp8ZgrpjKCBGlFLPBQBSkItyls0dexSkoGrwO6kk9ftHql40ppf467mc3wg59lnUQYRdQBkQ7ntf+yOwpB1uCvb60udDodIl62mh8wtsli1sQDIsl+aYd0O4htBUHna/bE0mk72sSIFPt2hVsPCp7g2QysJrvDvgo94pq6ys4e/v3a3OSqYupp2ik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 11 Dec 2025 13:11:27 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-11-11-39

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2516a87153183e1797021879121ca25c95f1ea3a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

