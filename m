Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F96EE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC1E6B0005; Fri,  6 Feb 2026 18:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59D26B0089; Fri,  6 Feb 2026 18:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65CF6B0092; Fri,  6 Feb 2026 18:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A43926B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:09:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F246E578F4
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:09:37 +0000 (UTC)
X-FDA: 84415575594.27.36E9A20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E2B71C0004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:09:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u7oBmgbD;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770419376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=C1/BRL1NBFUsKKYULycFn8SSeOmyLsp4vmb2e/K7dL4=;
	b=YDNgfSsutw66sSRDzYPy66DsiEBmB07W/3OLcWa30VYF36VjZFbr03BEKVj6BOS4jw4lEb
	9ge60f+Z0jDOrAyAHojiAAP1+XoUzi/1bSN6CJUPb327KpxxDskC4dmLehEQ7xXXy9BGr+
	asXP5ylWBzG44vkI2lJYx2OF4IWihQo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u7oBmgbD;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770419376; a=rsa-sha256;
	cv=none;
	b=uJjd/vgYzhrHQYj8lLT+06lL8StHS42lXFz12a3Eq58HkD+XlrmGKNJRk7qL+VY7jpAjCw
	OF9M26SutAmmTemwMh85oqk/+VfAHNnlS7CmWlzdV2LqyG2428hKjCuW6kdzt7BV+KHhpp
	qbjgocdYmYZeQEtx6RyB5saPzfgnW88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A67C60054;
	Fri,  6 Feb 2026 23:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306FCC116C6;
	Fri,  6 Feb 2026 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770419375;
	bh=4OeBmvtFeRbZ6Dfmm12Cqb1YDfbaZl+I7QOFZRnjzP4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=u7oBmgbDhw2h3InaLV/vrRcGN6oI7DTpLEIEgYqa5PoMoVuGIJcFISQy4PVumTXTs
	 96za0u4OheWETMx+1ET3BbcdjKDq/xiYP2NEVW5z7Ysks13ipbRofvmM5v7gMz4ADs
	 5fxBS/MmYfLSyIDHcnQtngOTsBsAXhvkTDaP8W2xaH4qWFJpLZvrWJY5EBO3+qYDUa
	 b52wdSfHJe5FBykjyc4rztnrIGKDWsBh4QNebBldTNHODc5qpAxNXd/Nwkq8lbK2a8
	 n5jQO6RDvPOa0l/MOCV1SP2n1NVnYarL7hApRS9t7MEN6sheR1n6hSH9ba9I2bwq84
	 Do7vkXGRKamMA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8584F3809A17;
	Fri,  6 Feb 2026 23:09:33 +0000 (UTC)
Subject: Re: [GIT PULL] more hotfixes against 6.19-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260206124341.c7dc8fc55e0f0f9ea68d3951@linux-foundation.org>
References: <20260206124341.c7dc8fc55e0f0f9ea68d3951@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260206124341.c7dc8fc55e0f0f9ea68d3951@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-06-12-37
X-PR-Tracked-Commit-Id: ae9fd76c111bb4a5293c2831a1ad373605251dd6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3dc58c9ce1c5802fec680cb8e95962f1430d5771
Message-Id: <177041937204.1109628.12627294139127684854.pr-tracker-bot@kernel.org>
Date: Fri, 06 Feb 2026 23:09:32 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E2B71C0004
X-Stat-Signature: acojhgnu7gz11qetn8u83kp1un6uap6w
X-Rspam-User: 
X-HE-Tag: 1770419376-421222
X-HE-Meta: U2FsdGVkX1+5xgAXWYhXrQn9j8AgGyaHVqaA/4oiLmNStJW8DeCtoZDpKYo9QCJgk/kRzJRkaDEHWPkaHJHtpi294iO2j/+oGxZqYRX6LS7wmbHe5cUennei3ANwOrGZEQp/fsacvckI4aY8edgsHN03+4v11brDYvCtEUjSfRi8X0ps76Ly8mvgt1Qcsefc0/bKSWr+Quz0Xl7PsQ/hFdfuc6YJDNbyGChFgoBJijwJ1LvYraEYVqMmaW8y0Df6J7tc8rZ2GcMx1XdWPyHXNyJWtTXnf8qVJDSEZTUec4oc13Nnk5D8+CmVVshEZXLzSgqcpJfMpHwZb8udcO4L9rWHRh8XB10gUHnXBqutqxbeZ2HwQAX9gn8MNTtHDK7LvorDYX5vzl6zlX8IL1gU+3KUUpPuidYrOeGDp8I3yPHh40QEaECr1poHu8Cw7IcuaHfs17XlaUHo1tC8lBAxT+DFvhbh4Ljq9MlFxt/ngnVgUmzNoPSiLhypuERb8bPfOPHYqbEi58cqXV5kYt0I8ZdxnSRPs+hqs9YLbmq7g7vyssHLUAKUfJzfbr4LG9Oknmex4zNtRC0Qm4rGHcR6n23gjOyyFWUs4NeSg6SGYI9yoqbmghWBTAj6WiJ+ONoE1lAFuXeGbDDZdM5+KRA8c59NvdGFLZ9M3hHQsgS3AEX3mCvpE6Y1kXuWVkeMZ2XBnWQJ52C/jW2mXa8A2gAvQnS1YCf6NmtvtZD5ePXX1nG6RjXkPNzJ2LVaQ+kkFO6At2SgGEi7damGZNnFYh7m8OSwAifxlv4Qcz13X53BctXAZywSfzuigLd+Y9ayazNbhI7CXbiNC0ChkUUtk4GJK9NaIcJ20gz1yyePo0q0rmCXGgJUU87Hi41WDNqRQyfbikJUFpsT/DdXb1mPIgJKZ9mCqTh2qKp9q9+bmRrBroo/6QEvrJaP7RMowsjNJAKY7MYn2at4GALnQkJeKRi
 UBS7SI3Z
 bJbFc5ttcj4frBIbOtyXwfPATyDeU7sEZyQ0DKoHu3LexM5UyOdACbcUSP20jdOug77iPe7uqH7OVZvDrL0B66+cG7y6GxGcjs8+NY2oH/0jhzxsqRLDV0zhy8GB7NjxTFmX7SEBdLUuWCw63snJial8X+Fm/c+VantzQytqO1ebw/XwU+zxy7cFFDE21yaF5u9AklPKeNIaq68QC7pxKOc9hRvTQyfuXRJWVLttcu0JjK9on/zEqHP/aDHREaMkq1UB7WtMmKSwHkHa7YD88cMNq6wZ8GdInmgB968gasesA66vioFYq4ce7rE2toaEyMEpZCvKM7RHGd4vQKMlu/vnzKeBpBNkeCcjKlp2Rz5YEBwayBFqUQhKWoIcr4bzjXZ5txEwKv3pFFnc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 6 Feb 2026 12:43:41 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-06-12-37

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3dc58c9ce1c5802fec680cb8e95962f1430d5771

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

