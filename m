Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D93CCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 02:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09F08E0002; Thu,  2 Oct 2025 22:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1CC8E0001; Thu,  2 Oct 2025 22:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1EBC8E0002; Thu,  2 Oct 2025 22:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B065F8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:18:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43693BAB8F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:18:24 +0000 (UTC)
X-FDA: 83955193728.18.40F24AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7A4208000F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:18:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=giY6CZRT;
	spf=pass (imf30.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759457902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=4s2rKT3+k+2VKBep2nbHwfuR/lH2WODmrjwMCfPeIrw=;
	b=LpoKkAFInEnxEF9aZhJZ28DsHUR8/WPPGS9w0gTtq3OfhI8JGHDFo8NvQD7AMM0XyQ/LOJ
	eUm31tm4CeAiFU+upkedms93DFXaogQSap4gOcYzZ6iqNl/L0La7tTPzfNSiURWpkLhszW
	nQlazF9kq3V704vtx7Oed31M/UL5dgo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=giY6CZRT;
	spf=pass (imf30.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759457902; a=rsa-sha256;
	cv=none;
	b=ULEQwO3LEdKLl6GNNCx2VGI/eCetHw6rSwyqzerwlsTQhKBKLY7243xrxBYFCah9yWrjle
	MvEA7oUrjZzBcBN1po35V4AEaZbNzv+mQhgMlK5exDt+HPjhmU1U7JVeHuG8B6EQfYmKy/
	2bt2ilhIiNCkDF5zA0Ot1ybTg+fy6nE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9026F603DF;
	Fri,  3 Oct 2025 02:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401D2C4CEF4;
	Fri,  3 Oct 2025 02:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759457901;
	bh=We4JqlVa1LZyQEyJ0+q6nXrpRzVKI00SPf3D6FKCf3w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=giY6CZRTmwDC4/n3H+2mmttVTx+Cx3D5RAHlCjLdupBXYbYUhRriPCdbDdZzamyxR
	 3tfKmDFKZN0fJTbhAMmo6zH1CtjwxVVtrI5IRG5SWWCwXqEGI2lnlZkT46oZabsF5V
	 FD9aiwetPA6NYGaGoF8KCRfvwAuu1ti+BqFORqfrQx2+F2hKbB0X7Dp9PMM2bcqaXn
	 W/RQR2x6V2VpKp6SWBxKhHWBdyAqlsMhyODGi3VnoFwsa9AMPzqNjC0vbDGh/k0Loc
	 T/zjbt7sphZJWj8omJ+1+JA3MnhmM02K8YHWQ8NKJBNEIchCvYoc1yhIA+CypbwHZu
	 Xz5qs2hzYShEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33EBA39D0C1A;
	Fri,  3 Oct 2025 02:18:14 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251001190218.f33f695b869696c2df9e841d@linux-foundation.org>
References: <20251001190218.f33f695b869696c2df9e841d@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251001190218.f33f695b869696c2df9e841d@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-01-19-00
X-PR-Tracked-Commit-Id: 1367da7eb875d01102d2ed18654b24d261ff5393
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8804d970fab45726b3c7cd7f240b31122aa94219
Message-Id: <175945789274.3590395.15147942711150864658.pr-tracker-bot@kernel.org>
Date: Fri, 03 Oct 2025 02:18:12 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Stat-Signature: 19ywzy4c1t87r7uuekfnnzzi54pwnezo
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A4208000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1759457902-841785
X-HE-Meta: U2FsdGVkX19crfGltxuUxvEzQ46KIFfg0X1dMhAtOErQvFpfNTgYpd+hiN4ujqIYo6NUjeS8Vm0QoKduBJhX8UJIWtrzq5e9GL/XNhGBw8yA/Nv7jEhiZkAm8uVgDq4tgbZhHvzLuq6ivhJkdlB63/9Y7vq4A/MeqjLGm3+SuXJPaKiH3Q8u2t1Q4VAiERiog0AXwmiF/RKkT6xhyjgDuOkmqVH/MtgT30m63ljy/vdQV0/d0A82PCj+OCzm/qZPN05e49UfZREurEVbKk6Mc/OiI203E4+MUENX29r82mr6YeT3vz40n5I4YSq90pUvhw4mEloAVD2gRYPFTYL4nEr3EQ28JCemhbiJkKKiwXj8NDvpgTyZrkNtODd+HnPyD2kjD8eXIMtAxsgxB8CPFpTbtbc1I+qryRUfxW41IZNITcS/AMTR1Wj+flTCY/mZy0HLENuP37rCiyYLJdNusGf2iqTsbLVP2QVMYTsjhgQHKoYzJip3vF9yi7UtE6dsyQo3ORbIhGOJzztAmsqhAVkZBgyDF+rUpCOWASOosfkdZYHSW/+/2pMblqpOI5gjQ6CfcnPAOo/932NypQWKC4ZfuPoTpClln6iKcNZEIkOt+YzptWBZ3JyMrZoyqoS10ZVw27Xe9/0XBWATaqBPUxCQa3sexJ9H8AXxh8BP1xcx+kTLEWVn7LSsz9GsUZt9KPaTB552Zne/U2rVzIvBOTM3nXPWlBLoBKm4M7Yxz+hg9E0OrXcu3EwGCTltxv3X6EwRFs2HQKNdfpq1wjXnrXxj5QD1LY45AAzvGKXAvi01/5td9JOEaRxplWKJC4On1zDDp/hOv6fxdCIqlqTGvIKetJnRAGBna4f1VblB179C0/7cI7yLxNepVZjrUPwPV5iTCXaQ9ZFUysaD9AykN8gaNnuq5FCbPtZxOFCVMbuAG32ob+HIvbfEcZyoa+LrN6s9/bQ6QlSMmf9TwSJ
 PNteDo9m
 Ri/LSgqUiF6D5jGIGYDtNjdEsUoWt5NHQbtHOvwlFzj6YI9zt2uldfTvBlFQoy7A/XgQ/huHDWrC2rrkcQHJcKXBgDxGVaFiBNC/PIIxPzDRQNZlKxDtfFiV6qH0zJUoZ4uBCxoCex1tcE4pCU0xmYgp45gJbmvMrcXWnUlqeVjReZFOf8GfiueP616NXClarSG+6WX7gu0Ec/R9HulviR4b2hkVgfIpww+GnfdMWkT+wzzhr0E65x0gETOLfURDIdDoCqM3I58HWCxu8A+ZrAba0xveYcg5UVEhXIoVf1GLsady3prDO4SbE9kVSAoet5PzjVt4NUs8k82e8jUktBIo02g+x+ZraN9lOEg+Sn19II+5TbuPpVl52bzLX7i7w+z7m+q0FM9Lz5MI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 1 Oct 2025 19:02:18 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-01-19-00

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8804d970fab45726b3c7cd7f240b31122aa94219

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

