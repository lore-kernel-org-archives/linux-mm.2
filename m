Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B2FC55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42EA6B00A1; Fri, 31 Jul 2026 14:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19C36B00A2; Fri, 31 Jul 2026 14:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33166B00A3; Fri, 31 Jul 2026 14:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91A4B6B00A1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:38:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 337611404F0
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:38:48 +0000 (UTC)
X-FDA: 85049933136.08.FBBEA81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5A2264000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:38:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3ycdpD0;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785523126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=g/lzQIVjvbMB+cHgOtiDKK3SUl+Je2zRODZHXSrkEhU=;
	b=adxpRz1SijYrXE7tT2TL77sFQT9I9RgEMmhao/sm4we7nMpA/hJMoowSnyyYP980eNC8kx
	Z3bSc3mp0XShVPpw6F9/1lj2XmSc1kFDZwTmGjkLv5H0OYlahnaacuegISiBo/Iybm5TaY
	+LaPCqSvAIA2n6pIlRfF7H/6zSoaNTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785523126;
	b=R2Cllkh4lmUrD/n/ZXIMTra1VS4hjkMcNQxuYvlFjdAPPPJVxKowcePY+jOB49aPGb4h7B
	kJ27iOcwaxtAywGvbdMFe4NcySCJ0m0/OcDgMCH4Me6IVqVjPgNhmuHmQaz/N22sFNze/N
	yGJucbnsj5ugD+SiAJ+oXMQnlX423ps=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3ycdpD0;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C736F600C3;
	Fri, 31 Jul 2026 18:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2DD1F00ADB;
	Fri, 31 Jul 2026 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523125;
	bh=g/lzQIVjvbMB+cHgOtiDKK3SUl+Je2zRODZHXSrkEhU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=c3ycdpD09D1CZTYEArbJpJZ3n99kEarPJKYjrFu4XfUTIOIU8MEzOywG2Fo0HJBYs
	 +FlLriI0MzXMuWXlf02aAX4pXF97o7vkBMvsoHsIavye3Ans+L5oK+qkk9uiwMej44
	 z4koZkahCi448THHx/CaZqJLE0YLwEMur/k4FeSIujL1fF1PLZHk/6WKBto3McE15y
	 mtE5EoUX5bVEI1h5SsSfvhCWtO1AnBi0YAru6wk6IbYwGGOnSYgHeysnRHGcWzhxAg
	 9pP528LSzBJSfB28OfGWze49YiuIfyowjEX4Z0T+TwO0c6b2MqX/sp1DjT6OrDttB7
	 TFPr2IH4QDatA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A9839263B9;
	Fri, 31 Jul 2026 18:38:09 +0000 (UTC)
Subject: Re: [GIT PULL] additional hotfixes for 7.2-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260730193347.67069b3a7254649fb89c0956@linux-foundation.org>
References: <20260730193347.67069b3a7254649fb89c0956@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260730193347.67069b3a7254649fb89c0956@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-30-19-30
X-PR-Tracked-Commit-Id: 9f1d75a4ce04095afdb63d8e540092ff8151dacf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c7ed510824b1035a9bf7c3347a946f3ada81299
Message-Id: <178552308825.857209.4715981379357494186.pr-tracker-bot@kernel.org>
Date: Fri, 31 Jul 2026 18:38:08 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A2264000B
X-Stat-Signature: qrfijyzhx78qi38mj3qenamn4zdbahqw
X-HE-Tag: 1785523126-188219
X-HE-Meta: U2FsdGVkX19CbKdRV/l36ElaL0/z5pu31QIz873qzEq49UGNUiupJHH3hGK71JO7HjMCJVVkAyh+vvF6A0Rueq06Gzf5SR/Y0kVfUQ93gMjnxan4FuzhOdwC7LU30K7FXZy7h6GdoADkaJE7uALvuVzTShertkhk9aKIj4gBjjrANjcraDJnFPbWZzOFeXR7nqgG3/jaqU8F+HCp9pBIbQMZojcxDbfxlXRLro4RMt7aRlao9Mhz9FccCh4wyZz+GnAdQHoPudpvKTkLen/nEAwj8kEmSvM8x5LgcXL9HlAfnqv0U2DsVUVo7a4ieivdeCqjtuu1pKK/rkivHoHnJPe5kFhPh5ihpU1hD3wqdAlTOVn2n93dtBcwwkst/E7V6+020FAMVbfMz4YAlchBWsdAu9Bnajb/ajcg0GUzfHLv164OJv+ULUQISx2VRtHntwaXCfJEiNF2cNsKGffu3xx7kYUbI947GvtcQJMADA7Xt9aLb2RgRX58tZoVRiCPxc5yBRNFanm0Sp4ttWSIqOR8UrqDNpaecgn/zSTG8aUdCQxlPtC+1CLIPWJprceJpFBmAUIVJ7jarCHaOc1CdgeuN5iCdR1rVdgCYqV0jOIX+d6X+bmR1xYx8sqwn61icM7tn9yKWgG+ZKxfQeJiLUiYGLvglk8JnijbQTTPCUR22gk0yug5eBRvYHU8buwqA0UwTDxFma5ftXi5MmpiNUuf3v0ghWpiWl4TBX9y4Gxh5ksnigOWTcT9snLF07X89vpR343JL/f6La0rTtZAK0HiS+vhdRWeDSmqUksqAnOv07nnnrev4VvOA+fYHAN40xg8prN6QgIwa6HlI80IbkbKpHzp1U92kZelKHgX6WFYT7S5teIJ9vB30TNDFwciL3Xag4q8tJgt3pphftJ6y23CT/Pyvfz2CU7Al0OxS2x5x2N2GkTqso3OWVOGJ/53yw9RSLXUtAga3/Xj5fA
 YvHxDci4
 qSccJH5Vwd0+NGVC00nxXjKNkA6fQECP2tgiYLe1GtK9pkOEYTo200Fzft0YB8VSAhZLpZXtuZ2i5ZhSkRpS1/EJjdbM4aEWjfv1cR9F2XMeMB9ZCwdDLVWbAe/HOH3giioGmMPzTG4yjF24WUBKdU7BiNRBocS0ImvJ66AofUu2wgRGaR+e/0d+fXi8ADW+uPqGTEBfxiWDp8qrtNy2BFt86ZlME00qaxxcgM2OkD0U4lx5F5kFhLwLtfoesW87jRsuF9PFo0EZ0/EApibI+hclH2kXh8MUeU/UHPGBbU6JRHHID1olyVRU1id7cbN7w2RwgPN60rVy0nZsAoK6kpO+uR8UIGMQ/9k8uorvCLTsCJOqLzS2/X7zW1cODGWQVxYCqWSIEOuwIesnftfR6AH+DIq3KwAvPkvy4X/OslquYL2V3D4Hs3BR1Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 30 Jul 2026 19:33:47 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-30-19-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c7ed510824b1035a9bf7c3347a946f3ada81299

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

