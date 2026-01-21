Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77DCDC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95736B00C2; Wed, 21 Jan 2026 13:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41EA6B00C6; Wed, 21 Jan 2026 13:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A3A6B00C8; Wed, 21 Jan 2026 13:21:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B82AD6B00C2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:21:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67FD91A0A27
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:21:42 +0000 (UTC)
X-FDA: 84356789244.05.B962C90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6256D14000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:21:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LdrLc5uF;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769019700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CFM9j46VWvS8trXzVf9ztcCeEX/pt45dnG52cUpjPgY=;
	b=ksYDAY6+SmtJJ6K1Hm0W9xUeQWVOR1NohzR9OjFKPD2d10vJtMsdL/oOM6jOPZmOcr7aql
	lrRAbS7eTl3nucCKVoCFpYnpMkPf2JDErGzzc59tICwLLjTqEwbBjvH5oU80NHUTvy606W
	UBLSNVP2ZP9esaXqHJT756pjbpIxRpU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LdrLc5uF;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769019700; a=rsa-sha256;
	cv=none;
	b=xCLMmfaM/rRL8bPHv8qIiqXYr5Ax5etlRPaB6iTJDVSNvC6aS0Fd+vRmpR0MG1etgGSUCO
	lLepMrUSBCcAhBh/KiUAI4ABq4gKNb/YXzINDmI/O2mkhLbluAj7sGBAqarZ7Qx0mviypC
	F7IiNBNYsU+nAZgKEQ2f7V237k5vO6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 364D44179F;
	Wed, 21 Jan 2026 18:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14823C4CEF1;
	Wed, 21 Jan 2026 18:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769019699;
	bh=FfnWzwG2eidEKFq+HXkTQhLVLiVKtUII1R7WidMJZ90=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LdrLc5uFNdEVEVtYCyYCtqMHAHhU9MjcnkaKAn8MkEdZ83vsY676lBxTUtXiTOKJw
	 eN44QRHBb9L6IOMnMKPZxmHTj1WUP+nYVyc5rTmW8SUvvLoS+zPpg+f+xVHwSOHIkM
	 xgGJf4B7sJsOLtezu3N7c1TYJTCdL3qXWkfagXBAUKeyYGhoMTKj37UwktChnP8/bU
	 UzRh9GTW8J2IzhD4KfJo3N9RaRtYCcf4Dt/Pm52lqy3o0jo3K6gV/lrCSBErn1tmF9
	 dX/uhY7NCxJtVqwiwCKEkxv7v6FPis2pRPbWKB91Ns7vD+rvVDcZd+dez2gMrojgJu
	 07Ek8IWuxVzag==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 4EBD73808200;
	Wed, 21 Jan 2026 18:21:37 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.19-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <76e95710-77b3-4095-b640-0a801dc055fd@suse.cz>
References: <76e95710-77b3-4095-b640-0a801dc055fd@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <76e95710-77b3-4095-b640-0a801dc055fd@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc7
X-PR-Tracked-Commit-Id: 99a3e3a1cfc93b8fe318c0a3a5cfb01f1d4ad53c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 119d1cbc6ee3c72620b1ab24dc3c89de31981d82
Message-Id: <176901969590.1402269.3589434953731920903.pr-tracker-bot@kernel.org>
Date: Wed, 21 Jan 2026 18:21:35 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6256D14000C
X-Stat-Signature: hqhsquu8qctxgtwa8hk8sdrurrbqc8y1
X-Rspam-User: 
X-HE-Tag: 1769019700-33217
X-HE-Meta: U2FsdGVkX1+ZNd7dODz1l3H5in4WNhaenQYRaUjfb0SXPEtq4F3u1kmYpFHg01zRmCt0eXLXwObPNFut1ZLwayShv+YhoESQONUpE8i757jDxzbGJmp6r9Dx8VRrwMVjIzSi8yY+pCndli1o3I2ZCZtE40oOfrN5KlH76HGvj8/CMjlqdfIUZS2vSAnqsrGWjWEDiGZ0pmloOVxyWndjHqXdgQWyW6l4n/RJgOtZVPniTPinSDH3PPL9fAGlUDOArAZnzzgzlGISC66iisNgnV4eWY6qdZ538daMJDnnVZSmJuskRgA3Md1wAmnvxQ/UhrnvtT5q5Sfm3H4RvPoWiABKYwIr40MMV+aTr6nG5KzCSXvqXes8gDSGkU8zv7ipSgaHMKWm9EU1ZFVRvLk6X4qwA2iBMMyAAnHwcJMwhcEuBFxAezi+MTkK+4QQCuBmFMGMSBSIDwCbnYqmr0KHqLvrasmp55jOh+DV7TV3m0IEssXkpmdEglgt+W9wrSjY+w5Dpwz81ukjJQToZq4OrlbW1yO1ZorLi1ZD/Earu1uj4Mv2ICfHFlirvr9Zl7n8lv0Vw/Znrfsx99PQAIQ2ZyIb//eLYwaSSomfNcIVqPHld6HzoQikYbfLfiKMt+VoFK2NrUlRP8GNt/KD8T+FmS9ZB0k5dcrGd5w1gZ9YdxFAy8YI2KF426tU5Z3JQh8ftOFmZtkAkP9uQp0MvShqqf62/SDFLq2O/cSTzpTAsUkFaC35dX3MrMaPLyrIkpwJZvBRys/T7KBU4z81szMiVRW5/pY2JLOx88CeS+5ZVd9xo101JfitmLic2zPJBZFUErlDZJa6qUfXdcuIYDH0ZN9QqxoDlOYJ1Nmxg5ES0BiEpmeQ6vDOg53xLrN5P2TmUmdVk+ZKyhwYj2TaHIvKkxKmyk6J7aQ6ynU86OF+QUMQt1TxCRqyGNf6DHdS6xYAZvZ8Tfrtn+TRhbJdenv
 2D9jAiNZ
 hR58ibZB8JC69XI2g6Mv4jgZw3GsezK3qewmQVYDz8FKUaiEQIl+jstxyDhO0f44hwcNYIZ1l4hsSDatO2Hm4N5g+2zgxXxdR4MbI7zRRfL/fV3G2nbEYpOf7cVOf6nX2QqHHa4AyAvflj8AjHfcnaYC0w8xs8+De1Uiw3/eh8Hi1KFdyb8eutwozpoOYPq+jDJ9xAklKXoTsQ/NEGXNx5fCHZ7olCip8GkB6tpJWQJsFlydpjJqD7uQzauAYljfANHIg72dmtwOuqNoH+2eH18RTPj2cJFyBfxVSXSc35DsCicZAW06OWbeAiHRlFXNNiCN1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 21 Jan 2026 11:38:15 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/119d1cbc6ee3c72620b1ab24dc3c89de31981d82

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

