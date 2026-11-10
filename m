Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56419606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwon+Oqb
Received: by kanga.kvack.org (Postfix)
	id 76E826B05B2; Tue, 10 Nov 2026 12:14:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FA16B05B3; Tue, 10 Nov 2026 12:14:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635296B05B4; Tue, 10 Nov 2026 12:14:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD7A6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:14:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A12BB140175
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:14:43 +0000 (UTC)
X-FDA: 85419858846.17.1D52178
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0512220002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:14:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwon+Oqb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794330882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CWWwBUP75y7qeaBbwDnAx9ZaNZrhjbF8wSCiL7IKSU=;
	b=xBn61KG22mI+NIj8Lg9lT7HvG67gBHrE+ci71FNVKvJJeRkgWSognfv3EqLxYEKwqsYL5M
	7BbChTlSNRhzYRTiJd6KXVFM0pkwCkcvShBfBLDJqCg33OeLNTo5G+Be+gPZw0EVy59V8w
	CfGifE41VqBlKxilpuKvr60IKe2GpaA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwon+Oqb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794330882;
	b=CWB19m9hAk+q8gQhvs6RC/i1G0MH1djI599yVXllLtwOM53M9sbWzhDCybTAdiI3rw882Y
	Bn5iMrbNDziYtJGSq8RBue5w60s84a9qif+LMEte9NU/3gZqUH16tBitN9rASqO/1/NVaZ
	C6+GT/8UPVq1L1SqRbls9Z3hcXdSU5Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E62E63A42;
	Tue, 10 Nov 2026 17:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1424F1F008A3;
	Tue, 10 Nov 2026 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330881;
	bh=2CWWwBUP75y7qeaBbwDnAx9ZaNZrhjbF8wSCiL7IKSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwon+Oqb/6PP0H1Io0CQtrXfQ71uqFebwkSxchnbrREoZ2ERqfWIEXPqB3jOOPX/O
	 lTA+de6AB7YDR5Og30I+JjzHdVEyefUXxDm1FnwIhaX7LriRmYHswKuE9bPhrih1xY
	 REHOm+pSBrN1uEssH1HOvUCtHR1HeYFCmBlPPCubUtXhHqPGf4oXDexj5MFc+IY2vb
	 ojB6jkLMyOzEH89kXQnr8xHq28MHyKbi9nimZmfBOq1OvC5ZuJ4HkaLc4rLXbFxmDl
	 Z48pcdv73bOmHUCs54lCosSsdB0bKTRkwQKg/Y3Xum2UXQHZAW34ATP5IT3fIoGzk5
	 UJDbglDwIvcfg==
From: Sasha Levin <sashal@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] Kernel API specification framework for v7.4
Date: Tue, 10 Nov 2026 12:14:37 -0500
Message-ID: <20261110171437.2854704-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261025164719.1831477-1-sashal@kernel.org>
References: <20261025164719.1831477-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0512220002
X-Stat-Signature: wkj9swa7dpt9uy84g347r3hz6m8scgud
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794330881-914282
X-HE-Meta: U2FsdGVkX1+7ibuoEs5s7VXtyU7dsaPU0xoXH9uck+E4SNmQuJcbn9pmx6zNP8PrTFNedFReSmWYPyYSyn6u28yHKoUrrNXaoVmeTp6y63fS8Zr8aA9QwyiPQRwwZmIxm1rTn4X9JR5qcCzGXvtvRmY3MbDhTpba8YDutqLIjf1L7HD2W4LTEkjp8aa6Is8v9ZOxdIsyxAVsnWVF4JguuNeWMnMGDuXhDZeYVUzc9lu+A3Lsgb17bnBLGHDqTVR3kIwzf9PmULh37PcuMQ8Ggvoap3Cb8jSGn/aXIs8GfMiEjVrGQ6rf3sGMH8gsuqxpY7AuAkkVGr643NZEFR4GS97h4nYjE3/p1g6k+u07Vz6+Ovs+3Ad3EvpcQym4w9F7OEz1DlFRK15IOvoB1SNEj3rTXCQs1FwwssS1rfWstj6yFTlk1nIf2oTGC2knOquFuKwO7G2sfhAixJcqUgW+vZ9aDvQjQNCI6oxJU/m3ZmXAcGBHCPaLdklxZvgc/3z34WEqmL9SzZYavXdEXeWJrB1FjIBx2iV7Ah3pYKrbYIEcb9gWxfBO13lcUXEaoOBr+BmYeXSD5Q6gY6UfibhzzdmTa1b7XjT4zantAdBoepHwNRjCfGyEPbKz08+wCuHMi633Y4JFuxWRqbaEED6u2TmSDDu3zF+C2CPETA8QLfyMi6ZSxZ8uHzdCsS6onVo8vImH5MHlxVOt0aNyFuwv++NMEKsFfJfhN1yGIe/K2iOGZEtbcpGKH8g18Yn4AtKH4fe/EjG8wKA+IzXGoE5omYiIWQiqm7qg22ZZbAPYjzZaRkSX37ZBLeuYCw6KWafagpzs4OJAK+zVvSMcVFwebYr4lZq3+3fm10vY48qJW/albp6/VZl8CQYBBW0nz8/dmRH0Lja7vzzPlDdhl7SzSnNR4H1gh2GId4PfU8dwoaO+D90sSxAA2IZvZL40aTSfJ4ePpPufFjP+xjtRMzE
 /EV0o5m4
 qwQudJKD8zrOOc2I4X4x8Pan5yECsK3YIoAU5jJkYZyGgnMqAArsFbJdGJqQ+eo11okCVlwxxg140LC4407c/fLXjdR88hLT253/4TLLITF9mx7wALBYYq7c3yYAvqu4HVG2CodkUUI9iznONxLm65hkEjlvrGhZlYfz6k2WMwix/sur8aIlv4F1ZnMYUoRSNO7CFvL61lmVZHqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

Ping? It didn't make rc1 and I never heard back.

Are you still planning to pull it? If not, could you tell me what you
don't like about it? I'd much rather fix whatever it is (or rethink the
approach) than send you the same thing again next cycle.

It's still the same tag, nothing changed on my end...

-- 
Thanks,
Sasha

