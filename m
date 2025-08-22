Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C34DCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4929E6B0147; Fri, 22 Aug 2025 09:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A4C6B0148; Fri, 22 Aug 2025 09:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380276B0149; Fri, 22 Aug 2025 09:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24D3F6B0147
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:36:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF9E5116AE3
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:36:25 +0000 (UTC)
X-FDA: 83804492730.23.8C76692
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id E877A40016
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:36:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9d3VUI3;
	spf=pass (imf01.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755869784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=8SnajLjv04cbRoGM5SH9iBYabGQzZPGdv3vuGfCzBUI=;
	b=XAXFX9NSyei5kknUDB+QkZsUP9BFkkTSNOQJtuHDvCsYo2AIVVsp1R48e3twy4r8BBzp8H
	719VJBzQe6JzpcgXRLTiF0sNxcWXVjpXVM3jt90dQbaLSRwU0klBEPKqwHzONwdlv5UlCD
	Lt/iyXXMjJwqM9O6wC7Gy6sPpMrTj4Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9d3VUI3;
	spf=pass (imf01.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755869784; a=rsa-sha256;
	cv=none;
	b=Edj4QzJ0cOshxzwK/JOkYqrim/UdN31sYhb60lIkaYy5EIU/irV9HFrC+aHqgABwaoZh/F
	5ppc5vKlspQxeE0DLRWlCG9lQz8urCI/9d8cnfTagxUl8Kin/NQOM/GVZlLVczkkk/HzQu
	YDuAsyUYA+HKpUi43vJZw2ZYf4TCd8g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 52351A5808F;
	Fri, 22 Aug 2025 13:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA06C4CEED;
	Fri, 22 Aug 2025 13:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755869783;
	bh=95FgaTA08CZt7zqW4778eoQHgSzTh+tdD9TNspJq6Qg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=B9d3VUI3tQn2THUGhPdrjiM35nVXrHZZVfVCIIqm6KlgqsjILxdCkiNVSfXDYzBiE
	 GCREfjNYC9NAGIhZA2bc0aa/2O+BW74wwo7wODHUmon9bmo9CffCV4NnYO1elSbfYg
	 t1315LZZYTWLS9SNlyo2fs4g4SvSQcGNZqNe4Jn7CQnTErKII5W0jxGZBUaQNrbK9S
	 OhoCrR6faHK2UboXwFu+8+Pb2PkAsdYITRs++sQVEfl9C4/7c+83GuqXhM56RgHbV1
	 FjO8N/eCOMtqcXOtOZMRQM70slcJzBx3veHB/MOupUhm7/Y8P2OmmMMB5INmylMS7N
	 X6zdj8SnPL8+g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34024383BF6A;
	Fri, 22 Aug 2025 13:36:33 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250821182122.eb19072cafdbc6612e76ac8f@linux-foundation.org>
References: <20250821182122.eb19072cafdbc6612e76ac8f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250821182122.eb19072cafdbc6612e76ac8f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-21-18-17
X-PR-Tracked-Commit-Id: 772e5b4a5e8360743645b9a466842d16092c4f94
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6eba757ce90483b76da4e7eda962d8b8b8930f2c
Message-Id: <175586979170.1831455.3293661494826885715.pr-tracker-bot@kernel.org>
Date: Fri, 22 Aug 2025 13:36:31 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: E877A40016
X-Rspam-User: 
X-Stat-Signature: iikkh3irq41fo89mhwyizz5d44iuqcei
X-Rspamd-Server: rspam09
X-HE-Tag: 1755869783-976427
X-HE-Meta: U2FsdGVkX18MgKpBbkR/g76DvVbn/5zWqEbrIWZlvnAQSiTQTNqbQxFpQyiyDdzUFpfOz572pJyhLAiKSE53RGUVrBxWXjGlhXAO3EpK0Z8Bpt2BoHRU+us9F6Sqnf4K1v5wba6YYu0kfE6O9bzDIBcfACjs3KIrcVg8mpOaAKE3SEZFnrLaigeDokAi5nChLEMaWSg6oAd13qfdzMzYBJIy3tmuH0EEqdOom5fJnzHCopdmCOqMOh9pNnA3KBOjSFu0mZuqTK99DCBYtQoUjbqbZb7FhepMuTM+RBQeiu3j9fE0q9b0XKQJWoMloPHrkFybfVVEuItDWEtl8Co2EzTkvlZoTL19AdxS25AGL+O/mIkvOqNT4Yk2oqo1dz3Rzupugd/Cwl6JZvrUSqHKSGB4yfOW7/faOaQMtbWNjUEwTM3u+zmuTKMO/1Wih8XDaMgC8qHSiSvcHHT65ooO28/Meom/HYbf8ocwT7LUAS4gGDpTKbp3z/WM2JCHU8kcwopmsFkuVCtl4BcTz+FlQslFevgB/XVkiLJnWZBu8vXuyi9bdd0cfNGtoQYtN05wczQRDVfgf0jmGfNnka/WWOIVfLh/jsqLEMhEIhP/kRWPswTgZ4CDBrhS/KP2EkMs7uG/HJKDt7/xo0kkX4f19P8jOkDGojKGnCRgxYmvEOYjywuIH6fcDHY9wClyOghKhxMxxXAabTAeO791i0VfI7D6WBPrLIGH/mW4zm2ixw6pqP6zbZHPnRKhvjPKPfqG+/5efGtem4MvfoYqKQoOyru6gBojgHf2Rvy6GUwu06FDshEF/wNe5oHc3CexHFnFr/umaWsYauiCw9x57fBpAYvyLX/lYg95IMc6o0mgI5isz0RpfbPbNScqRTkVJQLge2vsbMVEIxmAw41H/xdLoPzNfNCY0ZNP+mdglmFrHrELo0RmUgmnmA4UB3lXnigCeTzrJ0eScV03SpK6wsL
 Uxgm2caQ
 sYzOOVqQZXuy+hrzHeZ2R8iwd+9ON4tv0+XuYv7WbuxOlvePKssY6uIeUdLmXPjAghGrdyP8imUDFOVljTMplXwZqrYOvGorzLHaKUMv8Jr23jTEARgbHyaFdvJxECOzjQKJeX0L08dMt0Ml3hGnAB7uZ3Hi+uMAlmHyLUCdK99KzqJ1tJg1ns10ctSwpSpUhiJl6ZdrTz8LM2uhFRgvMQhapjhGs97wuzruaE+OVXpoG+LKPyMYdnSjpv4b4oANVKTBK38NCBtluP5iYu9YI+RQcsWeSFbBPi05EQGGybibyeG7gYR3MUfafLsx+w7VOc4rYRoxg+uNFsqsKMoOGno1TODzLZMVeYzqOx+uK2CjsZUhsCBsjOn76e6nwdspcYf5pmTVSrETevvk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 21 Aug 2025 18:21:22 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-21-18-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6eba757ce90483b76da4e7eda962d8b8b8930f2c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

