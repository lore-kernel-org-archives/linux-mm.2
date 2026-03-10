Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E36FD4F31
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931026B0088; Tue, 10 Mar 2026 16:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF196B0089; Tue, 10 Mar 2026 16:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0496B008A; Tue, 10 Mar 2026 16:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4446B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:07:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE80B8B4A1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:07:08 +0000 (UTC)
X-FDA: 84531237336.17.C37487C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0872F40012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:07:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIzKNsdr;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=IquqcpszwFXSZ3O5rszI5894wzGuttHOsc2WKtFIiHc=;
	b=31DpoxN1CaRN3Gn5JRPUMbuxCYbjHKAjQwHHgazqVeFz7RTDayREoCCr8PajYr3Uq0ZL4l
	sdZ7gdTwtdthpHQ1VCjCAJXs+FzC7v2l6ygck9iTuhu+rskjz+KGcYE3mDQ2WtsoWEjVuC
	0vinGEjy2iNrEIRJRnDK+tWitNFfxU4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIzKNsdr;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173227; a=rsa-sha256;
	cv=none;
	b=EVOGy+EoGSwHDtpCBc9cmC6RKYQxp8Rp58D3VDmc2dM5bw1rW29ObgDg8MJP/vaOoFa8r3
	QlyBTjkOzu6pvGK+gdHTo2MtKPIEs8vSB7CjdWoEFC7mAim+8La/ZTbBroprdjc498YNP/
	V6w+y4Z0dFnNiDyhUzXYk9Bx8WnYwi8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04FCC429C2;
	Tue, 10 Mar 2026 20:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C31C19425;
	Tue, 10 Mar 2026 20:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773173225;
	bh=gxIHa4pN/d2HT3i1lYIseeRgtgv+dktAfHv5WDkX2jo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eIzKNsdrWNDc8vCGQ7LE/TQ4/RYRD5wV3OhQcbR31AlQUD/cnerfadZQH8yFnWFCj
	 /wmzKyaCLpk+rUI2BRdUr5WfbrVGAGOPn5UPPxKCUfSAcL7h3vdxHXg4qh0s68yr9b
	 7QkNlJDDj+zjAz1qiQi2yF9Su9CQRAsi+8bgE6SDhlCjW2Dl8YS3hxtYSGAtfeNn5T
	 5FECkx4qUeqLiEnuLOG+9J3ArSuPXFO/dMyv+aFBh6EDQqinFGFmcjjbGrpQfwszEG
	 sDMPWe1l4c2sMXy3k/Y/wZNqU0wmL/D5H7frziiFzIkOFT4oTQzWvcfj0U9npCCw8M
	 YVZqAg4Hf6tPw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA2973808200;
	Tue, 10 Mar 2026 20:07:03 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260309163846.f59b3518cba71b9587576e7f@linux-foundation.org>
References: <20260309163846.f59b3518cba71b9587576e7f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260309163846.f59b3518cba71b9587576e7f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-09-16-36
X-PR-Tracked-Commit-Id: b12bbe35c7c1e431f2fa01fe9291daa52fb7ab43
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b4f0dd314b39ea154f62f3bd3115ed0470f9f71e
Message-Id: <177317322237.2899380.1182380861308467097.pr-tracker-bot@kernel.org>
Date: Tue, 10 Mar 2026 20:07:02 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 0872F40012
X-Stat-Signature: hmys118i3gfgmj5jxgi8338ci6ckqkir
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773173226-16328
X-HE-Meta: U2FsdGVkX1/nbqSklf6csk5awrD6NC9UbwYdhr5RF8mGXKMeNinwWNdr1/hgLtopCt7G2LDjlD31L2VNv/ow9mnpQ2V/WmGUAYgJ2aj+nUTfCrjapE0QwvgWVDi6GrCSrGA9lt6NDkKJ7uzxq9WdQ3H2wmEHeAauOxCCi4pKhUmafpRP7FxfC/1HwE8w8MTU4wdHVDE5HKRZ40uuXHE4hUbK7KVkav76XpeDW7w64KVeG33bQ9idDeiSO3vnd27BNbFObQSaJJKpuSuXSYJeodIfiajhbDRRg3Bfnm8QZqMTkQJh869b7AHkDsx6LSs8Fdvjk68HN0TEsEPpMLJRDeeT/DTJXUmFutaHu2HRQY7x+v2Kr1q8wYhwSk+1hKCqNdlCEPPtCSDihbNO1OAsHqOr0f0A6sJ/mqN+ldqNMFTXXbysTCGhs9LBr5EMZQ1kWVlvSSpDBtzYSXrklut9xKJurIAnB8orrsgzz6ZRAiDnbHHf9NOw3adYEoFhM198++kxxsnkCETtoIl+LlFW680bAHoQciVwL43ckuHlsjrgp/ahlLl1nB1jQqZyR1vsOGkgDNTxS6UvZQQxp+Y0g3YAAtMquHZEwj/TauUKXanJvjQJcGwxj3+XZdKEij4lv2I5oPTjJaAoVZjbQStdBFSuG8DLI4545e7ZEzUrkW2T+IZtV90wz0pKsw1QhEwSurn1qJzyHFB2dHaeco7YyYBVaiuIjOFQxTIFjyFr2hWxoDfeHfL2q6s2FSgz7W00fy++ck20ATrrElPfI3ER/6CDFaPN02/xqyV+iNTrC8nx4nYa9IOE/FsbnzvS/KYFk8oF8JU8Mil7FfrspHDzxYH5EHJU1U8feHiHqP95usQ7l4DyLOb+ASyZC3TT4n4brnZq7tSooDVPJC7MnGyq8yVB9IOHNnaUfLLOwnfrtpfIrZo7Zh4U9uQRyjOzigxbmuoo6plhikFQVoLhldY
 vc5Znami
 VwwEJH9N4mINlAIAyrgyWu/+LVrUuYJbFvsHZkWkJ+ks8vWcIv9kPHBgHldxxgHP+vBS4jbGLJv9rLd+jzCDH+BcvOFB/wKAgB16afJvTueXGBOZNinNvIOx1qZYpYDMIgHtRQ8F/BtQ1eCEGDdbimNdgOJ8GndczZzJD7nn+f6/Ew4g2olSwmQcAWWWCtoEzWywoh8kKBUS75C+up+TRq54fvvEjDwwyGcQUnA3vxrDSkeKyR7ESiSX/fw54eUu5p0AtmTcYfUst1dxSn1ytU/rUyO/xMcM5AfYogNE/zasT7jeNRsD+xuhbSxQVMtR48rmkw1LM0dGdQehbNn0cOeWCehRTIanE2ok3m19skedqwlfTAQC61ZvC/jv3+USCJK8ol6r4wY6kVxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 9 Mar 2026 16:38:46 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-09-16-36

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b4f0dd314b39ea154f62f3bd3115ed0470f9f71e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

