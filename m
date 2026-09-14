Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E6FC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 18:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F58B6B0088; Mon, 14 Sep 2026 14:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6B56B008C; Mon, 14 Sep 2026 14:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796D56B0092; Mon, 14 Sep 2026 14:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0E56B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:08:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D0C5C140232
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:08:30 +0000 (UTC)
X-FDA: 85213152780.10.6FD89AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id F407340012
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:08:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jBx8NKYU;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789409309;
	b=1NH5WL4864Zuevcl0JhHOV073fF9XhIq0x91nkZSYB9NUOs7Haf6zRPWY6GEW7TxrqHIM9
	VKxUiTC+MTYVItLCzl2+Cw8G0rFwpmJ2hQlySd6dbRFWJADrlTBAMv4Pr5oyFejsywmUg6
	IKp36eISCcbqF9P6IDOv5ABAyhuahm8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jBx8NKYU;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789409309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=u0KpxEbtIpaA6vBLj8yJU9DCMNoi+xqSXe2yvAGk5N4=;
	b=nhaHal3cTL325VCtbYhksqsSB1isTk0luZxY+WtIr6piQuSzbaZr7UpasrdJ5w+BRFQiut
	agWACEeQRF9OjDoEpM24rA1+G+18jqxwWBU9qQlASWPQVmEG/QoBnzVI/m30qBo8tA5Rdz
	FkB4/vKEpj7DrM8196UR+tnH9LpYyRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2388243E5B;
	Mon, 14 Sep 2026 18:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077461F00899;
	Mon, 14 Sep 2026 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789409308;
	bh=u0KpxEbtIpaA6vBLj8yJU9DCMNoi+xqSXe2yvAGk5N4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=jBx8NKYURkY0EaFCs2uTFvcm1aEQ3xK0sBdWkzbFNIKDm2gXbGqodA+21bum6V3RU
	 fnVCraGH0MPICvMeeGOizbaCvRQBa18CrFINy5ARS9V67Yo68EDRg/XOMLxAGoXlbD
	 9QxZJiyaCZReKxKD4oAGIdOdovfcq5X/t/VUt/LRvfQQTcQbl9lMet4TC3z5HeTlrw
	 nx9aP1ImDI6If/DSjfsYPWZuK2rNGva5SAQIg0tijJ/LA80USVnV8ftBID0cVkCqmq
	 JM52hgV7yVgp/MzR7V8PH2FyLi8JPdEH7C9oxBCrP2l0dHDaIbkx1nQbWZInvr90YC
	 TbG0wsje4mmng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56AF43924FD1;
	Mon, 14 Sep 2026 18:07:24 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.3-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260913215242.66cdff48a7849112984deefc@linux-foundation.org>
References: <20260913215242.66cdff48a7849112984deefc@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260913215242.66cdff48a7849112984deefc@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-13-21-50
X-PR-Tracked-Commit-Id: 7891fbb9512f127826e1d5dbf380ee212bd15eb0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 164f652b6ef9209437ca016beedfcab626ff4f02
Message-Id: <178940924295.1155813.13705216181057255376.pr-tracker-bot@kernel.org>
Date: Mon, 14 Sep 2026 18:07:22 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F407340012
X-Rspam-User: 
X-Stat-Signature: odi1mofjzqjeqpt6gw1sbby7r3z7x3ik
X-HE-Tag: 1789409308-431035
X-HE-Meta: U2FsdGVkX1/5PfvpvV0RtaN4mT+G+80+NtZRePWLAErtnPrrVyvL6RZt3xjxH/iN3W5r7hXpwtzZqtjTbjziBouNcsiOQKyM4ZIjJsdTde8dUZRWQ+rNoBAjkbf6skt4kIOHLgKwfLyuC/PnDp6ENSAsnFH604Ou3+3E8rpjSO2WTcHlHrmaaMp8LkkV7p4RntcRk/yLfBewoJ00zTgvfl2+a/r6XMBK5jQF8+EvKcz21nf3jjWWeCsLepM1nkQ5WEjgbb+Mlam5+9UmAFCCr+1DalausS6FtUrZtoBqH98tZP7noFFFv6/Pl+vRe+whN8Swl7S79s6YVRgwihb2veqiBW/JCZ2vZnASNSdkhStQaAzW+FUYNtosMlFoJZieiqoC2OX0/cBRECIgd5f/Xzk1vzLKy0ns4PHgGgoETx31IYVmRSA+oUcHPfiUZ8wy2t+kUY6l2Oo8aAiAvNd2VbWfIqAxFfW2kgFlkPi2gouhk2O2fS3nzaZyi9pNC6mNeOX58633lXxneTzIPHrIe+WY4TYeyVq6IO7d6BId4atHpWBbdUvTxuZ5Na2fNX9rof4abCqV0L03O5OPwE7btvb5ERTyvJY+v7TGhnzZtlbsvJwf//Ig4WUgtj21hMk85tX3lFOD7zUQb3KmxM3t5RVb/kxkfWcChqK6tcAip9QTCFLIawVblL1xYcBleQEr0HBpkFPLXwDnn66+n1NSOolTYXOQZslqd8SKtVO2gGjhvlU35FE7l9+grRVB0WKRRB3mPsNf/U9v6t4DiA10IbRj4nZCXzPEiCprW9QWqt6FrUb7ae9ow9/HKIgG5REDfseNO0ZJL6vYjxDFTjxYhYpry6nievSdHZ+I6ZFvuNMqm4taNQDPqjSvG4nuUN9GyelKG9NUzQViLHGn1HYJHofDHhXqNAWqO6qZCPQNv6BCXkiHmXGDBV3h36iz3wRaJfe2U2FlHxTs+aR1qvL
 k7mlkOAJ
 6pdNDa1P//BVFV1KlSVDanvlmrRO6W2vfD9bpijEhxdeSuQ3KjtAfSWB4+tv6FRwN2WEmTl2mqOAwlnkt4pZkgAtkHyU7dRcJ8jY2rEYWic/SjCWA8oCDH6v5nAntvuuqwR8OTJSAvrCi+rhsw5t/0FKv2qmOxY/LCYxd557JRjbLdhQlNNwFBd/uIhBPYJ47llkyMJuzfkpg1MybMIU9ncXSb9+CcBEOJ9aKAJgkrdX8BiQtMKyFD+C2kL5R57syuZKCeo/GkeDqsx/Eo1EaFgUhV/HhJcqAf7UiwOwXpPRUwwY6V68kTFfQQ9i/ZLFznCoY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 13 Sep 2026 21:52:42 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-13-21-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/164f652b6ef9209437ca016beedfcab626ff4f02

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

