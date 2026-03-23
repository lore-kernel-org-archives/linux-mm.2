Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A174F46122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE4C6B0088; Mon, 23 Mar 2026 10:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5766B0089; Mon, 23 Mar 2026 10:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7026E6B008C; Mon, 23 Mar 2026 10:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 60F566B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:01:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14380140BEC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:01:16 +0000 (UTC)
X-FDA: 84577489752.17.1476A62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2B0144000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:01:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArxEKSWf;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774274474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCfeqMkO5gV9yhDx2TO4AxxaEWN8IVul+lQeRtLwbjY=;
	b=r+GfMgk36UuNaKNZpldbj6FYz2bAkfgtNgp++PSWKEQEoEC1/oM0+UQnbwQE89WyP6HHfY
	TyIxOfHc+WAQhcryQYm+ntv6k/sqGsw7buBnYEz+T7mBkS54Og55/hqhZSswJFI8iD0XpJ
	y9jpJEsVClJwXWp9tjXluJZNTfCsqXw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArxEKSWf;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774274474; a=rsa-sha256;
	cv=none;
	b=gSoGOdvCAzf+7AVmiOwjqfoRL/bUHlWsmIT/XG6XzkoJFFmA8nwYR7+N4o/zFTLJgfUheB
	OtpSqhQxKuW/QYEBUQQ+jsPZNwXrTbCsxplvY0CLoONjniG3is6GQ0ubCPRSCWiA8Y3qPN
	6m5UbqBgM+iTBMh+ytkyDl0/OKTb+Zs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8943660103;
	Mon, 23 Mar 2026 14:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2427CC4CEF7;
	Mon, 23 Mar 2026 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774274473;
	bh=9BwAZorS39eyV/Clw1DXueMD4DVME5MT6dI5zrJaohE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArxEKSWfW0WLc+VbkYVX01vNzz8v12FbchqeuYr1vnlsn1zOJnD/ZJMSAaWEMz05v
	 +WlJqoJKeiyKbDdoX/ZCXR5dg34bqj2Chbp81L+e3jp2czB8mU/S09dvvujzNTKlru
	 PTASkdq4ZtVJezJPPKjredm/MavWfkXFUQswvqvX7RmwptzffWMqkl7VRfra0xrem8
	 udqYEWYMKYFj6sDVSalofeDKgpGXxaoG1t+bAkDIqHbi00vLMRtt9OK2o0qzhLiZaM
	 5JV/T1FJZI2st1gB0rMDQSY4SEkcA0xq9pkx9wLjk3f8p5P7lLcwgDlcz2v9rKb5Ir
	 6svipfbqGUx9g==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: optimize kdamond_ap ply_schemes() by inverting scheme and region loops
Date: Mon, 23 Mar 2026 07:01:04 -0700
Message-ID: <20260323140106.79746-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <FEBF344D-3A99-4360-A286-705260B68704@objecting.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aza9osd41rghcdt5barigjma7qkdratj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B0144000D
X-HE-Tag: 1774274474-145610
X-HE-Meta: U2FsdGVkX1/tJfxaChQjapybecbqwM2xdW+CvS29hRPZgEtIRzA/mHcfdraxkpFDp27PTNdaalxUppCINBh5kNaM9E0QTrugp11ZZnfNjZKyuz0yM46eGFDpHvuJ+ncy6SwFtUBWjafmHA12emgi9qRKYLYrJp5JuODqt9jSzDxV4PnpugQHjin8hNgOkHKELdMArI9+AiX5qSCAvb3T3wXeyplxiUW074BAWeZPk+4zsfC+5xeO0HjiYs+kq68Ro0znKwfQyk4nHPo+Jk3KqnVyAIKT0A8rcZy9kdw7rbxT9IznAt7fak9iwe6mMeaRBCjzzmiCIOA1aXkye19B2uLkNzXH6Q7ZyyFUnX2vYva9Eit64ZB+S5IagNxiyycE0UDjiy21gyrJ3i4og84kfVFLex95ViJujoSmrfOl2Dd+9LvsIQ92pLJe5D20Av67/5j/btilRoZOEos09vXSAW0bANmilEfXuBpdq8D4n7ND28GEpj2Gedp3cgFJik/PeSoFDs7mNBAESmPEuMqhMRsVHTgqWiu1MrlgFhSDgHoCRpBWPq3JF8S8k9IDH+B/XB6MDkR4jBzm9ZDNiTKO+O2CiCjBJZK18KfHyEOsomaTHyN21P469Bbl4B0HjEzopUR89Qh12GdtXgpu90mDoD9zoxWTsRQBiGrO2H42GJxO7rXFZwJA5/CKq8jtZjf4F0YScZIMBaP5Xy2sxD+PJNW+BRLGefPTUvI4blLGGpkfk4C2aLp9KC6T1bQEXGC06Il+ICxUo9q65v47JAGytF/AI85iWmIjID2lUa8MqUI1FkuDZ51+bIvWcH3WWsGF9r2AV2q1jq+/nx2FEGJvG1v+xVReeC9w8Yy2IjN1brRYVobXk+XKV7UumR8F4AHoLw2FUqQlVFopGX2/sp7+5f3i7IWg9SiFwuk2lo57eMoswA2h4+GSdqil79eQ/eeKf1ziW2AWRT25J+orpQ6
 wKhG7xLa
 QXhttqnti/Rq1sMTQ4/YUFr2Vjc8MLG7qiY9qqIsYWWXxfXOpNU/dp7Z3+7I3dVayF6pEXfQ1iX4WQ9p073igCfTkTytZXdWwuKPZZur3Rvz8A37xKBIvDXy05Qx9uGQ+mP32sjomMANtx3AtaYm7zYPzkOws5CqyvHF/ZY0aVTsmYh2HYKwvPLC2pNz7hb8zTPh4/tTaBTmJyQKb+qfCGQ1eRRklH8o0kRV4a08kMj5GrLMHprDUl8tvQJOBvSKFq7/avxBaMlHyPlfRT/ddwBa/BaVF6xzKe5HqyrvUfWy02j1d3Ee+Q9sHEqy377wcSg/P8a4O9ewc7tTDz54Z9VsfFEhlc+e0l+Wp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 22:39:11 +0000 Josh Law <objecting@objecting.org> wrote:
[...]
> Hi SeongJae,
> ​I understand your concerns regarding the behavioral changes and the adaptive regions mechanism. If the loop inversion is too intrusive for the current DAMOS semantics, I agree it's better not to force it.
> 
> ​Your suggestion to optimize the first loop by pre-filtering active schemes into a temporary list/array is interesting. It would achieve the O(Targets * Regions) skip for inactive schemes without changing the application order for active ones.
> 
> ​I'll take a look at whether that can be implemented simply enough to justify the overhead of managing the temporary list. If it looks too complex, I'll move on to other areas as you suggested.

Sounds good!

> ​Thanks for the detailed feedback and the guidance on DAMON's scaling philosophy.

No worries, I'm glad to help.


Thanks,
SJ

[...]

