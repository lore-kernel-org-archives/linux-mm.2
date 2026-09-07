Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BCDC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA2D6B0098; Mon,  7 Sep 2026 10:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B236B009B; Mon,  7 Sep 2026 10:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9B16B009D; Mon,  7 Sep 2026 10:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7111C6B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:22:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0371B1C09CE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:22:14 +0000 (UTC)
X-FDA: 85187181030.26.7FCD202
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6AB88C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:22:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNBv21A2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788790933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eQ0JhHAR9Nb2YbgKhttHNHzVi/fsVIUMYsBPzyXZz0=;
	b=5v0n/YctMb1RyJ7bltZ2+R6ijLDfNgbwqBWe4xpxw0E8sc4vb0wc60LSRZU2OY7mrlHL9X
	3xqeqWPKT1+rF3QDa0YK4mAGl+3DQuW3zN0kcu4dSm5NDwT2JS4Smd/mvZT+gDknoLDTa8
	pJbx4tBz4KpsUhkMAT8pGKL2DhEhB3E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNBv21A2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788790933;
	b=e7MDFqSBled7vqgWtrEMRN2u9cxYQKDOM5HrL0LKuJNOA8O7KUGrzoKbvf0bABbUlVJnPC
	Y+42kXO43tQas/pEznJQoKNLLvbSRTwlxLoV/Nnytx6Oevt/kvdEiGEWjzr0uy7wRNaU8n
	aG55Oxc28Par9uKIGDvLHSh+ubuM5jA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E10F4601F9;
	Mon,  7 Sep 2026 14:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ADF1F00A3A;
	Mon,  7 Sep 2026 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788790932;
	bh=+eQ0JhHAR9Nb2YbgKhttHNHzVi/fsVIUMYsBPzyXZz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hNBv21A2/h9UcBAITs2+2sVkQ/kZGOOOpvVGtKQ3kv9x9FhcjhFByRFWCLH9Kkpvy
	 glqUEWt/Ryh7QRu6NUg6OyzmMcBCkdqL2SgyJwdMPdG9VhCvbD2w7uIa4o4izjzQou
	 cBKg3anJH7vAA/ppSpikYAmMYIRBAMw4Tc3QLfaLTkLPEjwpjuKTUHCVNShj3xY7eN
	 /5upgrGKvXrqIEBYeacsKeCeADRQnqWavABJI5Ht2fJ3cCPTf5Yzdp+iQaA1oTZI3X
	 BAZT+TJxtphEq7+f7drtP09YVP4rM6EpUKIDut9oVElOqNRwdYbiukZfW0ld9XsBnZ
	 ZqAjcBbMpOlxg==
Date: Mon, 7 Sep 2026 15:22:10 +0100
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: unify slub stat definitions to simplify metric
 additions
Message-ID: <ap7HQXiSl-fL6Pn-@nixos>
References: <20260814071848.46922-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814071848.46922-1-hao.li@linux.dev>
X-Stat-Signature: c49qcpf594pwbjuckipri9j73x34zu39
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6AB88C0002
X-Rspam-User: 
X-HE-Tag: 1788790933-389442
X-HE-Meta: U2FsdGVkX19wpisr2H/OcNN23nJeHi9kuCo6V2bN0tgHXXVDWUz1nh1bN314YclwUQ6U0MoylGULLaGen8oLLWhektbk9yPBMB3dhe6C/UAaEjkPiSq4CLsjM1kvKpflz2SHoRsR5CN6pC3mEXzUh8i5AW5s6A4LKuI3yMfdbhDz8hurqdftGl+Fdx6VBvvSsibKKWskU53ntkp6b+BOyRVVy/dlI9At5yTJvmLHwz4ie5gW5UkJ5gvBv1W4j/dtmv4zQpP4W/UBT1C/f4z1Pv3EM+8iKOk8HjqH2jz3tV4tz4J7cpS8/Qo9IVFD7dLITuWMfo4QEy6O8ZOLzsSxwxtpFW6ET+E+RL3Ok6lRunTkzwHMNHbj4a1qClx7jPNVy86ph8RqGOXqvJT5aHlnJEzxTAFENJRjkqmDMJQWtz2/IO0Iz9d6KQ7NmjoHCYHqoAne7WuNPD5/fJG0SspaaMSWsoQhNRUnEB9eHmgZKrMNutn3oxSflb0RWTrqX/GE6vaRBiNFvoTZN1qiEM1Bzax9jEyuY43JklNhaFXvSDWQQQkLFPMRXf2D2fe50P5s4Dja+16lRJwGmJbVYtGNnmUax+urpBj19Oy1KPUtc6fVrVlWJYO2tJ9DTcMEMAC5XoqEsdmOB1tnEJ1ymQJI4RfUDsiixtJc7HHCDIdeM/mQz8IeLjQ9YM9FHD03V9TMYk7kOhLJUWeGa+XPyU8p8dhajeOtwlR3wDagqTYsL55yB5yI+HVUuDAPx134AF5otZTLh1lfAa4BkSPu1Fb/1O8AvRNSFM6x3Q2Je2yxkBMJQch7pdqYUloSfExJFQ/ECB/ugoZcmSqaQ/6WwLOy70B0ud3wcR/NDvq2/AKI/EudwT0PndSM90k8P/MrYrVShjosvh1LuLAsZTrfM9sCN5ZFaCsAcScEyqodh7NFXWJ2reUEeADGP6rd5v20afN8LbzTT3al5I6R/Rz+n0R
 mXDhXqKP
 vwnKifjvEJTOoNm/Sv/j3SNM2sLNDurlOoLSm7xpyS6eLE3eM2ub5bkmwG1hvu3rk7UzifKov6/0ykTplGO/ImnfTOgcY3sexPAJ2znXx91NncN9alKBb3UrHfJ8auSHvNIUaPL5uJ8iqjM6QU9Xeqj9vOdHPs+VrXUzw6mT8F3EbCGesANqTBANYn9l0H6qhLhV8k4O01p6v6NT/LFd+VTBZ+tkibw8eIZNwRAXVOaGd9J91r931nAVHsOJdBm+zlT09naDkp0RCCoYPRCk7dV1anA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 03:17:02PM +0800, Hao Li wrote:
> Currently, adding a new slub stat requires modifying three separate
> locations: stat_item, STAT_ATTR, and slab_attrs. This is inconvenient,
> especially when temporarily adding metrics for debugging during
> development.
> 
> This patch borrows the approach from SCHED_FEAT by introducing an ITEM_EXP
> X-macro, which is then temporarily defined as different operations at the
> three locations (stat_item, STAT_ATTR, and slab_attrs) to perform distinct
> macro expansions.
> 
> Going forward, adding a new metric only requires adding a single line:
> ITEM_EXP(XXX, xxx)
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

