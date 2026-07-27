Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822E9C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 21:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766BB6B008C; Mon, 27 Jul 2026 17:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EA96B0093; Mon, 27 Jul 2026 17:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67AE76B0095; Mon, 27 Jul 2026 17:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF776B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:50:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3F70C01E9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:50:41 +0000 (UTC)
X-FDA: 85035901482.03.225FF15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DED3A40006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:50:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJybgTFM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785189039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=IObLMwFXviAwE0MuJFpkaHWW+I+EiuAqKlIpXKq2l+c=;
	b=sSFWWTwADbs4hCJvdRfab1kYUvc+sJyBAR5HLcNZ+QqtsY/wUVXe+6K3+IbhKbmsp48ULm
	Hy7krSVAlWtah2PrZ1TqJajvxzITEjN89qZPiH+84690bK3xAMcpvlJc6oORbbP4jB2eTR
	ioFI9R0zbif6sQ8hK6HvW9tNu5lMnZM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJybgTFM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785189039;
	b=nXmetIDlo6VR0zIp/8w/Dhn73YL+7d/V/g64PykDjXowMZ1YuKIJxbwRlKqy804ondjh4f
	rwc9ul8pb6AIAFGP9Js8F+OqWlMcqdX3UzK2JYBxs5s4jBuojMeCYgagGsJIuGDZO6lt36
	Fw5ooBtcgqkqpucxU2Ruq9pbhsaVVHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3446940740;
	Mon, 27 Jul 2026 21:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CF41F00A3A;
	Mon, 27 Jul 2026 21:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785189039;
	bh=IObLMwFXviAwE0MuJFpkaHWW+I+EiuAqKlIpXKq2l+c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=iJybgTFMewLz/05qL5l/JVjQunItq7VvfwESk2oUos1duInYYuE5zCF9n4mYAz4sa
	 vq1CvrP8VW7wV0/3aD6c3PGZ8o5VVm2n/j8ZbLKtkPIEfQE+9TkVFqftYHSIX7Sj47
	 zRbAtMRSsMy8owbOq78oLqc0XJ7q3L3Jr4VB5E4stItwrFXNkR1z8URVX8yVgPVdBw
	 0SPEPkUS3c/9hUDizzBQ3hPnxGQgny9fRoBq10IS6VUGkjzmFODy/RRCrauaTggCyU
	 VGu4Hx/SBw2Y8uLeRgzuser8hiqZjUg3lLgmDpjcjHEgbGNzvnIaXjYX3mOcusNFHp
	 Oc7Y4SGzV7KVg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93CF3380CECD;
	Mon, 27 Jul 2026 21:50:05 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.2-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260727142015.3795e489e504bf62b793bb55@linux-foundation.org>
References: <20260727142015.3795e489e504bf62b793bb55@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260727142015.3795e489e504bf62b793bb55@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-27-14-18
X-PR-Tracked-Commit-Id: 40de8160ca7f67d14619ee0351ce5d68fc4a237a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 62cc90241548d5570ee68e01aaba6506964e9811
Message-Id: <178518900429.1430977.1445190236974738530.pr-tracker-bot@kernel.org>
Date: Mon, 27 Jul 2026 21:50:04 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DED3A40006
X-Rspam-User: 
X-Stat-Signature: 7qbi1w3pmopqna877ddaomw7f1jigiuw
X-HE-Tag: 1785189039-655858
X-HE-Meta: U2FsdGVkX1+Q0eizAEKwXAJTI6AzHwUiqi6VnfNZ2FmqbAHooXyDXXa8A3hM1oAkJxxgOCc5c7BMQYebNxjzGa+oDz/jsu8hOb8mYo/1j72wkGgQhAcxQ06QhUvQ+/5ALp0sK/hz7FBJyNG/0Wy19DNFpMOgI/4cYzjCEpYHzWXAP9yrZHXnAiy+4VQH00Keh69kla65YGqCZCS0uXAGSvVjuLCSJAcuM76n7pQWUGapz7Vm4AOs5LfAFjWUaIPOAYaQlQRiRVPqYwYq7xSoL+odVWsNpClMeJD+786HCY0LvYcC7vi/4G5RFD66dccBhHkYyqjJHNtODUn/8Qpjc+t0adtLADkOH6DIrCUtuPRE3Iu4AZqnqp8kPje5QD5GfX8rkNlT4np/QS+iJZj96bUUC5Fk4ogzInTPEBuBYKZ4TfpcV8sBwGvkODG7geERBaUkDrHxOM2oISX3wFFnfAFXicRwVLcg0Bpe4+N+PfC0Sb+zquMYFG5WwAZviSemUI2IrqIDayQLe2lXGKWVkd1bEnTt0+laIkttWvpei59D2jspMyLF2IZ/TpOoXxIDfP/ITYLkS+P/Wb786xE5K1W4ptEYJleKjUqiwYUrlg1z9vllIcUmTeYl6Wf2YJ3kTHufYopIxWh13E19sC/LyBP3Qn12yNFe2QfP6bX0X8NbZVr2FxrYc6KU461I9DmNWSpcegZbO/IWDTqzEnh09Z5NbcRy84mFgoGNDUMkFNosC0JF5OCa10sSy9scpMdTbb1iwWzFceA6nqrEDjr2WZbbXhtx4BxENzp4Dnu1jcAartRJ96/aMrJfIKnqrEQgf2bnZsMGwqoM8iTJj2Jql3992+UP2szqGIp7kfcj383/TajfLNmca6BN0oIAqcOjjLyuKp4HtGVUm/9X/flMylHxU8aW04epz1IVrNJ44efWp8f3kpmeH/+nJd1WXBaufMhWSrh5wNRQ4zz71Lx
 3V/bjFJd
 V+4FHf6IbEtoUIhR/3KhOn/36+rlouZPYKrnss95fcxR179Uw9cHJ7vQz+ZJPRU7G5WL3f6IWwDbf4fWOguDtwQIDodilmMngKsSRMo6ydO/ioTzE2dClPFKkqJ8VkJ2CHN8+nlYhluMn6guTsRSIUEi/r07p6lYKiQU5j+DgOMkVEvh1e/wq7A6TQ9ETOUutt2843+2VBeC+A80LDEGlg3pzwholJwysjbp3YD8/YExAfj9xUcoMXpIr5SUWbOIVVeSXr5c3OKiI1aXzZZbtfH4k+UfJidb5fNRgluh1COLiGrb4v8xMgLQuH6nhLOZiqnaxzk/VUo1BzfamHjRNV5oWvdulMmnBlpoQGjPcCinILGwNbabPD6353YqFMeyx3onM9tmt2EYQNzRs/lDAdOqTn6eQlY1rVKf+jBF35wVi36JjCAgymnZAAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 27 Jul 2026 14:20:15 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-27-14-18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/62cc90241548d5570ee68e01aaba6506964e9811

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

