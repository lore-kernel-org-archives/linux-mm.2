Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A4CE92FD0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 20:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D486B0088; Mon, 29 Dec 2025 15:22:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14AD86B0089; Mon, 29 Dec 2025 15:22:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D196B008A; Mon, 29 Dec 2025 15:21:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E547F6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:21:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91259C2AC1
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:21:59 +0000 (UTC)
X-FDA: 84273629958.07.BD58133
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B0D8F140004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:21:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RFpTP3im;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767039717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Y1kBkoAn2TZKXGAec8Tw05sV6cOScE0KzciXI54Wvwo=;
	b=Km5lGG1r7/xCM+KalUXqqSlOu0o1tN+K1RgYLBm+Uv40XKW9aIPZeVa45S4DGIL0cum14L
	T34YrEW4PwKeCBGFKu0FJMD8dDmG+2l30vYyYnKJAv2gBUqYmLUDNc/YSEHH7ob2sKAaGf
	N3TU5DPa+wAc3Wp8+vubhXPG8BBTlXs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767039717; a=rsa-sha256;
	cv=none;
	b=eaksoz95tNJBaYbK92RS+ohnitGenojz5/Uv2M50wKUbITuqeG1RiiGifK+W9gb2BX023S
	lKxh97oBS57m4iOTDQIun5Vl49i59nA40ALHnaQstPnfyAw4x2DGN/EhpU4HKQLcMWF8gr
	k9qHNuKJi/mmcVq3qYoX4UU6OdvrCHc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RFpTP3im;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79544437B9;
	Mon, 29 Dec 2025 20:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB0C116D0;
	Mon, 29 Dec 2025 20:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767039716;
	bh=RUnC6j8rWQ36k5z/8jPrCJeEoxGbebLjrUnPKPwaUGk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=RFpTP3im3xuRT9HdtJJ5ETj3e7yNZPWQzdcXtRbXJpQfasV+pbqEvnUwmgpn/vIL6
	 z9s08eLPz1To6QudG64IBbBi7CXnLJ/tJoQf8Rb53P/e2Asuy8GsqCHkOis7zBhW/S
	 YjSMTOK37mTjjRGVoE7s33qSG2sC1HGPoOur7WZ3gJBsn5jQxVNtaC+bQa81PhoLBP
	 vd7ZgWbSazboHwcbsC0sC3v3QD3DNLYjpRgJx0fag3G4vORfa2TU5IjVtrdyAlRbyM
	 lYrTchkuZP5KkR+gHYZ+K7v5LCk/JQf/xEKuJ/03mc0MF/2oBH+Yygr/PnmGZRm72Z
	 RyrgwmXo5iRSQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1746F3808200;
	Mon, 29 Dec 2025 20:18:40 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.19-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251228215244.10e9ec389dcadcbcb336c98b@linux-foundation.org>
References: <20251228215244.10e9ec389dcadcbcb336c98b@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251228215244.10e9ec389dcadcbcb336c98b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-12-28-21-50
X-PR-Tracked-Commit-Id: d6b5a8d6f142ad0a8e45181f06e70b4746c4abc3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b34fd0feac6202602591dc15c58e25ffde41bd5
Message-Id: <176703951894.3046711.9527961125769121540.pr-tracker-bot@kernel.org>
Date: Mon, 29 Dec 2025 20:18:38 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: kbet9y4birnse4re34y84uxqtkh1qwbk
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0D8F140004
X-Rspam-User: 
X-HE-Tag: 1767039717-971335
X-HE-Meta: U2FsdGVkX1/zGitpbFfYxjjWh/vzV3yDCRUskJ9aJjySZ7qtxwlmKGp/C4fL1B+KheZ+2UsC4nYpiieHaJmMO3d98xTsFPSZj+OVqNsXBJggLcV6/jBoKfvz33gV0iPtie6cq2kOsr0yWgl6L44OPbCavV2Gr1MM3B3+nI03pOWUWU/kjyCHIRJyEdAjaCSdoqy8a/AtnLbEJadjcdk20tzAOSzzo4KECy58x3lRYunWiI/yRNryregvrN2+7EqLciLUO/Ec4Ok6y6irsU5/U5h3XOnSnwGuwNtTe+ARx6viYXLhvJa11HyhVLwX9HgK8WNLydB2H5k5orCyqWVKYogJbq+vDgjeq5vgmdqy9Flk0ah+RBPgAAI1FXHp6RWStPw5RG7BGg2AINOM+A9Ii3lC/+6X8b73T0bIbQjahzRjNlMp69zVFbm6Gb5BFJhomWVIfSpPffPK5gBzWrnVKu/NnBshdUFsrnMfPEf411ardpfgwrwWHFXZ7iYS0mMGyrs8MHtPcmWE6CMSs0SOyLADLLuiWi2OPdTEgpC1kXX2wwrnpVIOhRadP4TBegnGGaBlCHamxem9v7WBVgS52TXm35ooY2EwOOY5LPLuxWmF9DHiYFP4OcMFZz7fbeWZZNWx3eutB6U/O+PaHnHhI70/mfk4lqUciqD6pLv/d4VzRAkPqZ/YOdPxLQNF6tVwDkMKczw8UvvW4MBsgi/Cn8DNEia5+MD7CDleG7LjPP4Qr4XTKXVUNRTKzFl0d0Xm16l/p1yPyCt/65BE4ao7PWqOxqXcdwi5iPpIQX/IbUAFS0XMXv659ZKzWOFlwptWJDFqMavaX/7hkrpDsguXgfPO4aBDUqvjsRfsEVT3jVVwHVf0IRnpiXeBh0xxNcF7u3TazjaNK7vDUtAglC7Yg0bSgrbdepmYXrcgm+uaTQ3L1aWdu4bOug6fNPPIFquZTRun5n1J+6pd8gFNWvy
 1GbwdWvI
 QR7VB1+i/R/RHnqioCIUfTVKOLdOlhGQb1YRDETerfKDdgHRaXJ3/l2EqzQxxjerpmFoTzB/DUnHxDibPS8kppufN5fgItDXiwoI+QjsnJAyIVxJmIMLngq4V4WaF0AAsm1sUO3K0x0R3WiBoGHcGGwM8UyAMHA7X6Z//Cnlro2n3ZCfheMjKs7KBnWrA3tNm2WDilp9r85E8WL0L9DcV0TpVeHjZORUAugzCBit77f+jNVQLJfDrpDUdH0ZyeygHVt4aNyTzjmWvxhTsVhIaHERX/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 28 Dec 2025 21:52:44 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-12-28-21-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b34fd0feac6202602591dc15c58e25ffde41bd5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

