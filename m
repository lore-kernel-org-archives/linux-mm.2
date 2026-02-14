Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7939FEF5851
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 20:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411B76B0005; Sat, 14 Feb 2026 15:54:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C00A6B0088; Sat, 14 Feb 2026 15:54:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBB36B008A; Sat, 14 Feb 2026 15:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9716B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 15:54:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 527EA5BB34
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 20:54:25 +0000 (UTC)
X-FDA: 84444265290.18.CBCED85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FA28140007
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 20:54:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=or6xifzg;
	spf=pass (imf23.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771102463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Nzu96FOFztTNQbjAIDlyKsQx3OEXhEiVsL4QSgyBQIM=;
	b=Nq6fIDAywqcNlxXMHvafYjUZcgBbKPSzrm/+5I91GJSk7Lsfs8nvKpx4cbsRRri/KTykJP
	YTFYXJy0hZvdG0cKeZF98t6SG4zMYikEpNgqLk/e1HgEmqVtJ0og6Nxi/w+ZBqYS2iKM63
	iRff4VEN8mkyFqgihkx8k4r0SUNHaTg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=or6xifzg;
	spf=pass (imf23.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771102463; a=rsa-sha256;
	cv=none;
	b=jdFPepRRBUtSApqXijB46inS0V0hle3ieFP9LbxvRWcCB+b0syxdDMy0FfzQLYbOCAeRY6
	Q2TLV9dT1KG7WkqyJ89eQqeneMTj350hfIuQJZA4sh3Pn2VXn7++4gRvgUBnvkrMyB6+D7
	09CAgI9wCBXaCnuZBX64BZfeF9BGkvg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D16C56011F;
	Sat, 14 Feb 2026 20:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B33C16AAE;
	Sat, 14 Feb 2026 20:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771102462;
	bh=RoCLiuS+JVGRFRrYPiAlm+L6vnivwJ1WF3MHR3xTjpQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=or6xifzgFqicDncZCjcZpqEgHgPa0ZtCCxwM/cBgC1Wu3Lz0qyZWnDM+HLZ/gs3a8
	 mOHEvSg56DjC2z/jn4DKmiv+TlpOwudn7+fuqrWPu8rJCVbVQLgvFMyTrN4f/VKqi9
	 WVSrfmLWZXmc2wlICyV7RNEAeyAtJq+WRGRbJSmxyVc3A1ogtd+N13Dh7PFoEq45q2
	 KImm1viBqp/73OL0R59n1GEYYEjgqSYPi867FydC3RgD3bt8jhmDuedHE00PAECYbM
	 g1JV9UvaEwVl44RonZjmAUW0TDO9bU5/CxtjW0YETlc4fcyP0ktRLvogQ2FXtovMI5
	 YORzaTZ5b4MUw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B1F3393091E;
	Sat, 14 Feb 2026 20:54:17 +0000 (UTC)
Subject: Re: [GIT PULL] memblock updates for v7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aZAjczlDqWkg2fpt@kernel.org>
References: <aZAjczlDqWkg2fpt@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <aZAjczlDqWkg2fpt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.0-rc1
X-PR-Tracked-Commit-Id: f56ccc32468ee7885d3a9175e7d2cb608d301521
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 787fe1d43a21d688afac740f92485e9373d19f01
Message-Id: <177110245574.2897141.12177000300175718851.pr-tracker-bot@kernel.org>
Date: Sat, 14 Feb 2026 20:54:15 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Kevin Lourenco <klourencodev@gmail.com>, Mike Rapoport <rppt@kernel.org>, Shengming Hu <hu.shengming@zte.com.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FA28140007
X-Rspamd-Server: rspam07
X-Stat-Signature: ffse1gd65q6dqg6zk5118gu1mgusfegp
X-HE-Tag: 1771102463-103428
X-HE-Meta: U2FsdGVkX1+H5dPrgbP2PpVp3HO5dzESDEhjrc+BhkW+JrepGhfjBdSACiQS8BpGgFbuFL64K75z1YwctV3xvaJWHA/j0FNaY81tUKFKHHRIhDNUiNQw/2x6s50ipbHCKQUAYFeiWeezrk41nNCwzWfK4IQc51to2gK9n6tEw3HxTob4P1Pyj+j5FuAE/GTJSbbx9HUiJYP9ITWGbbX/yB0nKbFQytqc9LbS7siNwC+X38hQyiG0pV6M5h+1bTpqry3+3GCmgxX/uD1YcWNpse8hAxi6NZhe0TNXqB7ey3XK5pT98KD+Hbo5i226TLUL6lEN/a+YmAoSnED8EuPpEaDIK2JxVB/1i/0NbJ04YS2xHc9Z1/S9X5h/b4mMtT3dAzWYZOmuvDoqvRiydj9W7kP3wcImLu2oo29wG44EfpsqxSG29DCwcJRTvFHEw0FIoGSdfOkusfCUrY+pcyRbNc47GFw/8lLv8RlTXEPLH7jf84p4cvkdGPsD0h3mRVRq/9xNMxr/naW3h3E7V1mLCoMLCYBUoUL/L0afeqiatq6OQeWA0nQykcHymThjoVqbvAuw+nrxoPQtOEeHnUQCL2Sx53PYP1sshVR+O+kklbWJZeKDWjHMhkB1gFxdVz+51ADtbKFWEbVkZPTXvD++2MAO2CuTj0T7AF8qUWDynBxBOomA39qEJx4NOk4lzi86YRl9zFbHAzVBVIEK48SjkXio9m9HVYhQUjYMWUSHbip1ZHqgys7NfwTRYJV7rhY44BrSHe6XxFwXTD2MTYnv4lL2oSm3zY539joU5a7xKDq2Dy9q3CjbRNz4ZUxVyi8lrUEcT7vDXRDDN9Csf9KfHRPsg2TQKU0rf3z02Akqdffzq6hOieDgg1pLY1e/e2Iht4jLvkY8fT67Jm2C96SZ1grRvQmMGHQ5bR4/6w5d5YcYEhgbW3mEB5xkIYICqoBZMf4P6VWDgwRPBVUuIAn
 9k3GqdeU
 beQpKydBQ1vBCVet1YUmePqjui8yJXubfdTnKMfnNobmBcCc52BzhHy8NVGh1F0RtyE+luk5ybEXHFZdmH8iqaCyEhKbxhR3MvMVEfNn6/q+U8LSNHuamAjzra9qDFcsmI8YVrGFpvbEvY2u96OzbHerXUNcsVfJ86jJDV0o+rIDLVhRgDXSQu9HOko+mjhWB07e6nCLOlbijB4zBSDFnooyoBR4P9mWuBItoF0fG6LKhfU4Zepmrwi/m+YGLaQFkVx4chSV/Tkeuhy8ZmiIYcBABEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 14 Feb 2026 09:25:39 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.0-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/787fe1d43a21d688afac740f92485e9373d19f01

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

