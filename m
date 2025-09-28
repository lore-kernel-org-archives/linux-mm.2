Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5007DCAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 17:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9068E0006; Sun, 28 Sep 2025 13:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672A38E0001; Sun, 28 Sep 2025 13:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A1F8E0006; Sun, 28 Sep 2025 13:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C57B8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:31:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08D23B639D
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:31:31 +0000 (UTC)
X-FDA: 83939350782.28.7194B52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 28E65A000B
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:31:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dUQQBIxt;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759080689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Ko1IIRrsryBBeayTu11RIekEmjHDNNDGG087xh/EMtk=;
	b=XqMZNkIKpYyVntP4AakNF6FSxKv48TduNlKsyNib8C6A3/kmPP7TRq119KjwXHQBrs3/vN
	q4NVamjNwykEEZQOBhFXxe1jiVkXH5/SaoZBd7KZLzsbqL84vtLm2yhlaWOqevJYOG1C2e
	yPYEtwOnthpjH8OsVxtmNRmJiz5MYiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759080689; a=rsa-sha256;
	cv=none;
	b=WOpoW6ww00SKxAe/PS6xlNLTRaH3N8+RnxNDEJxdIZjjZPaZzkMZIpaU36XjmTbjqUrb04
	AOOCQpjYEy4YrMkHnzakYOLIG9MZ8a0VWIyii+NPjeEDf1v9to7UMVjew791lzWbC7CWv0
	z0c+RPy1p0n6EYbH+Xd/i6GuHlAyibg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dUQQBIxt;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D299645B18;
	Sun, 28 Sep 2025 17:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F3DC4CEF0;
	Sun, 28 Sep 2025 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759080687;
	bh=1VMnkyz6jgjmq+6gteWLQjg0c+OIVIN7buC+/GB0lg8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dUQQBIxtWiRaKWcA5KDrBwZQ4C5CkeXEtkNHmhrx/1fYvcnDZMSW4JIvdRFQ3McN0
	 ZTUqEZKYMkpXupTVpvu9h/l9IHx4GRvsrMkS+3ltJVM0uk2zSZtOUN8F/q1N/+XUCD
	 r4dIXoqE/f66JRwxSotMmQ8FNR7bpXW3O+zfaVCVqTx1fI19Dr+LgCLurY6h3/oqTX
	 iPkGLV2aj7rFNbeEk+fFiy1dvisoo9TDyz24dqvb68ferTL4z8zv1r2xoJHPs/DSof
	 nbD2ZfjY0VGxTZh56MZYjdCPCirxeQvsH8ggsTbiPaI+i/cxWuatVBMisN13Zlms7t
	 qSeal/zJlJF/g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CDD39D0C1A;
	Sun, 28 Sep 2025 17:31:23 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250927224612.fffdf688aa7be4206a4a3ff1@linux-foundation.org>
References: <20250927224612.fffdf688aa7be4206a4a3ff1@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250927224612.fffdf688aa7be4206a4a3ff1@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-27-22-35
X-PR-Tracked-Commit-Id: 7e89979f6695fb56e8739b7d19614256e637131d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 09d95bc8023569a56078950f2fc6f1a12a94ee08
Message-Id: <175908068168.569924.1441363109262301561.pr-tracker-bot@kernel.org>
Date: Sun, 28 Sep 2025 17:31:21 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28E65A000B
X-Stat-Signature: 9otjx6d13iedn8qjfwwopswq6ym8jhaq
X-Rspam-User: 
X-HE-Tag: 1759080688-629572
X-HE-Meta: U2FsdGVkX19cetLAKmVUSmGPypnK3oc/y891VmItpOJJ+MBCG9QWKwye+Shx713XsIXRO8rMRBlaRHnHnnh86Vy3smWcsdH7hl+SlznMNc7DU+8JM/vLE7zEViv0VJvwdKMzbgd7gkqMMWTw+5h9JD3PGEhEqNEt8J/CUllJ9Z86Pp+EAbG9Fc3UUHVqSNpUgmIz9tCvyOUxUJg+q/5k8jkzBrBqw5jXtatywYjBjbMWSeMdzx64cyqYl6dh7VbhQvkzyO9QmzQYGq5ZQyT/+sm6TqWk+fUr/RPwarmZLrdmE/m52nFzBS9Tpg0gWBIT6ZEayWDQbKD9AsToJo8/lvwwQC3dVvkEinbN8OhwH1FhcZ9V6oeJOIw+CzmckmbJnacF2TTB5gPLUASzt4iyARqg/8TRSD2YhOEJfsZw6gWp1HYgEFgzQfV2NJ8GzqKb6eXM9ir1scGdNRYkwBD7U24xClbQOfz3yH3JHeg/GD82hKJ6/2MY52nX16Eo2fC2AC4h5wLuGFBjCTsYaarEekQRSOkEGVOEXG44iF1tiX73uOHorxm0DuSWcLtJyAnnDsn37//HirhmT0rRIlrmG/IvE3ymWoc9YnHCF1Rgh83KxGhjfoxhlJRUw6+6a92S3lli7SwnJnRjeAonfBWSW6hIiBUz3P/YoGxAQndEhyART7lcWSvwYyphBJzTKV2b8a115E3PCCnhbU16eH1Q4fjpHXg+HwAsJOCptfIP+yB98KdQTe3h3K6zKyv/RNlSJs4Xxb02pSAHo+vFVqQ57PaZ2P+o6Lipy81JognMIKtp5+H9V/lJWSpbHDhYvKH/5Msg7D6UlzpMntHRonI18ApKSPJBxZwU5nhMzT2uzbQXqAEGDhdbA7mH73j8nnTRMGxNkzQgpCSIscLJkOFgntoxD+HtLRkpJsVh/f/q0BHT1/GYvfGvPtUqJrMRxd7Ki5EcbvQqAH8gs+06eqL
 mUnhnGjO
 /PRd+6rYUeC6RrNTKM+SfY6soOi1DiPS3tK73xnmCEdEJ+uvyYCyqPA+4FwfKnD4Mc3sK2BR3dr3Mm/dgg5MUnBPoNWa+5wocGqnQJ1SPZX0zMrEohY9BkyAvck9hNXWY1/7YlkLzwB9Wh6qV/O8PHZlZsU10PlTDp0w5zDqrw8P0JokmP8+Z4B3mUsBvTuUKYOPcHaH3voV9BMbpkUGyiL4eeWRpUNDMNB+IQ64aGjGX2B605hIPVYE/RqTuBDgiJMKTgONRsVE4b2PYVsqHB65PcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 27 Sep 2025 22:46:12 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-27-22-35

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/09d95bc8023569a56078950f2fc6f1a12a94ee08

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

