Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E6EC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 04:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6747E6B0092; Fri,  7 Aug 2026 00:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624876B0093; Fri,  7 Aug 2026 00:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EBCE6B0095; Fri,  7 Aug 2026 00:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBA36B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:08:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59F9B402A6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:08:33 +0000 (UTC)
X-FDA: 85073141706.24.2DBFC06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 789B6100009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:08:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mI0oX2dx;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786075711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=e8s2N54zY/bbELSt5BbVGt6jOlG3by3mfpiE4yKygt0=;
	b=pWOa5rD42Joo2BDv1X8mN4/303DgQtNfoaH4dTx1jnwMtkmof36bHO7GadS9r8X2+jO9Lw
	97jthEXF3/34gPZTCtJ+J264VUzd9FeUZ2tCEg51CI16fYZc4GQOe8CYHbrgtmUIVkruLx
	UvRPxwv3xxfB64Q/yogvko6GbmvnHnY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mI0oX2dx;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786075711;
	b=jySrv+AyAgv59MvWJq5SXOfhzemyLuJbVHQmPmzBGe7pirj50QHBD+srtTgIEkYFh57lWU
	WGVINl2bvEvjvON1NEM3BjX3d+9mJ0HGAVXPiscGpu6GkV9W5rRv2U+QqiN6rE+lBwnQSQ
	jc/EysbumYhcg3MkgQDbdAXImiKSqm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7121411CA;
	Fri,  7 Aug 2026 04:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C381F000E9;
	Fri,  7 Aug 2026 04:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786075709;
	bh=e8s2N54zY/bbELSt5BbVGt6jOlG3by3mfpiE4yKygt0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=mI0oX2dxshiVeL+d0LriJyMtoIlMmlgAPuxmvYxxh3psR7/qMsBNBggn4/fX//JlI
	 Zfb+TIulVeM+6EageGtJ903OYd3r4UUoDrdf6VxsOOfBi2xlB5UI/FbsmEOZ/pEMCq
	 fRok3mLFclbK4JEC62tZX8O2eEmjVciNcvy9jDRI+0xDsRPRXaqO+66evD/2nRTtPW
	 VqYVAEVW6UALZbLZRPJb860z/cz14kwKsuGmX25kK+rJo7UU4zetr1nbIz+VvVGJFD
	 9UYFVwE+uG/YOUoyAHiWHFEl+3vvkRGiI8e4rNox8fCXtkFHV8wKA/QkoeZP6pV9eE
	 RH2JCIWSQUW7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BD5380A95E;
	Fri,  7 Aug 2026 04:07:49 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.2-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260806184655.1e970cdcb799e433d91cb8fa@linux-foundation.org>
References: <20260806184655.1e970cdcb799e433d91cb8fa@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260806184655.1e970cdcb799e433d91cb8fa@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-06-18-44
X-PR-Tracked-Commit-Id: 1ec0e6b6f7321feb769f50d2f094a0aa6c2eda63
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f9a2394a23482bfd330911e9c8295b71724feacd
Message-Id: <178607566852.1595133.5054272560908207098.pr-tracker-bot@kernel.org>
Date: Fri, 07 Aug 2026 04:07:48 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
X-Stat-Signature: 1hanjo6em3rgbwzta71rmembbuis6iuh
X-Rspamd-Queue-Id: 789B6100009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786075711-336202
X-HE-Meta: U2FsdGVkX1+snWrrJnDQPKUukIpI7NE85EOlXT36qRLYk2IoOkQIvaM62mxrT688Vke/TIZGbKXVzt4Jb9WbcQH7UgVwehEOGwRCjxH0uL+0+JMANRFbNztRFvLxZqBq0K0mrfuXUPqdJQWTdvyl8MMhqyg9tFy87KoyHtZ99XgnDh6x2dNtqT+IqLl8Vp65pBZ+BCnLkhU/u5ibZPi1zkruD6Ag30DZifD+4+o0B9UOB1csrQ5iblWxEGyVMu2piRWG+0rKvCkFGIM9kOLmbN88lVELDPH/jQClAD5+5wf8CcwLCJNZIyFYJchTjTdx92p5/Kd5gWyWSU4Z8Gfl1EAok+wSpHvYtFuvuddsdYj9VV+j3yIIELQ9mYkNdaLzRqXV1rBZ2HhgihlKWHXwikx2amA1srCCNdGAIwURC3Eu4ui31g9VJdGxABNjJtWk2r+f1qbLQlbaZD0sRjJUgGfZj8Az7fWzxe0yi88cW2vogaOBl3OF09dgJME74MplWjpYFjP2jYQigAqiqRCfWpM69sb73NSo2YLVeT5bwJiuZx6N8aOGOBpeM1xNJ9ko3Ao1DfqN00dculjeWkLWh86ArmujrpqBWr0aPF5aCD+R67LFCRk/Xw22pSBAcZTo8YEMjEhj1jjWHCCY3ZCP4k9Qq+saHFcmh3dWahsoMhQLHtC+SQwpJzG9ZZN4WLquvM3KWjiu3y9rkWrqiJI8ExokG2EIFcdTTqry4NDVDgiZRFGxnK7IQO8jKufYa6CQt20glK11EKIR94iqa2hmBaPrwcMcWR2Pd3CtSq4ldUvMRqLDd8Ljr12ccy3xq026qegLC1kv8fVy/le9fo99lnWSXzIVimXNyx0EXmwAB5gU9esJYNRuV+66laX/m3MkK33h2waBdTAVHVVJZoh2lzbRJS+qhWTOsCJZjR0+r05ldLzM9P/jIUY723BDPzZOc/57i4CJ7qonRgK1UJ6
 vQ0VtUDi
 VD6rm/1VhX7ENGh4usjsslkOCoEvMzhc9X4r/DrSWPVv/A7Lmx6JoSYre8AHL5B/Qa16/ZIjU3D8Gs1vg2Ja+yd+BiCXfBGAhm6BAruwaIG2dUhSa6DygIs8YFESnQaGw1lRg2hSnQCkI4srZ/hrQ6xUKk3HHvCkRWqc+LY0zSSQTRW/OicZfbyWJG7IWEafuuXrCUJBkIKsuixmPhe32A+QXk/lTdSJSZAOoOzrYxT/ajYoljZ5IPcMeOPLQN4mRvKUSsInxPEW/14lSEkUdewf3Pe5KpXyZO8QtDzZStkKLoFLP/HlZdpoD8SO3MU/c2v6i8WOFVsiQ5Y1LHLiXHGrZ6Pqxl5uAeJEqhg4W9PpzXWjkJ3Hd8Fb7VU3XYGNmqasCJBSuqQMGunGUtbzO5MXYyNhPIL7lj9wSjUl12kbzZoQEJjZh8aWOGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 6 Aug 2026 18:46:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-06-18-44

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f9a2394a23482bfd330911e9c8295b71724feacd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

