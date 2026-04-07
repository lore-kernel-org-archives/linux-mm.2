Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08208FEEF4E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D4D6B0088; Tue,  7 Apr 2026 10:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE0A6B0089; Tue,  7 Apr 2026 10:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D726B008A; Tue,  7 Apr 2026 10:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4D786B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:12:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72011140834
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:12:59 +0000 (UTC)
X-FDA: 84631951278.20.F73C1B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0F3C3A001C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:12:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdGdYFEa;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775571178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAEy1QFg2lfEUwq/z8ka3yNfBEf3DnaTVSHu1b2JIqE=;
	b=OFvWfLWxVm63QbYpq4teeSpw/EI4RXSBp9Xkx7ds6OSyFyvzMJp9TG0U9k6AzkJVVXpiWu
	XbDuAJHd2PsUN/m7pNXDCYdIVyLp0PlAFzhcAVJ/qvO2q2QMF+k3Zc1ZV3ASLxWIs8iodR
	uXM6FyXkc2+5XFWn4bhPwyAuz4N0iuA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdGdYFEa;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775571178; a=rsa-sha256;
	cv=none;
	b=YZhpQ11TKCqHPVIP5yPJ4vbwpgn+DBnZClt0tYhL1b1eFASyLte8xi/WL/GTVZ7V6yOhvN
	FkhAykpJ9NA2CkgH06u5oWHPVpUfkVEHJ4ojoTIfTJ34M1l/wPSkaMGq4qpKwKf75AanL1
	FYQ8EJoK5EQqYcaUlO8ckwtAz7687Ko=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A630600AC
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E159CC116C6;
	Tue,  7 Apr 2026 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775571177;
	bh=MS0m8nMGspG08RoJrEU0oKcfTPJQs58xLWX4xYfRgMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdGdYFEa6gghQfdbhVjD7GqBJ9B+eFgrZ5chI8Mk8EA7pJyWesIGoPvGAwLOKrOpR
	 1Q51jMk7ilzE0PUsy/wU2WhjDHcvwyyJ7VXwYHUH9gOztcXwGz91fNdh/Ogr1El6Qh
	 sGW92pUd6uuP0HLM6hPt+HApVou5eu6pCrEHnZRXQ+B1M6stCAvxa7azVzx7shJSNm
	 J4czQZLZetFbMlpUlcK9lmZh3Jis7qVHVW3e9FnFBJf5IdaHab1hBk0sklmb63y2dr
	 Biau05eSnwXxtcXBFxpLstqY8Et4O64Ogs9vuYoSN4RA4MavCHIbLp7Fye/NDd91ZV
	 vqSqBOYpNr+GA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v3 01/10] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Tue,  7 Apr 2026 07:12:46 -0700
Message-ID: <20260407141247.86747-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F3C3A001C
X-Stat-Signature: 8ac6ztwjea7iy8t6tnz7zyx6s8nw4u5t
X-Rspamd-Server: rspam06
X-HE-Tag: 1775571177-974030
X-HE-Meta: U2FsdGVkX18V09lu7tpdByxIL9++pf7fMBjnzGERs+Jp+56GqtBRr4B6QgLwkgDLTZoe1gO3XcTw8swAuUBrs4gKR5EhZmHUAyTK0BAijSRybDClKn2wckYROKPWb86dBXG92WBuPV/LFprOA9k5tr9wJQ7qjm096toW/atpYBa1kDphMmvVGJolyFg1/EPZJA2fOfbVOq18t6HNZ/FffjXkyYp+LDVnu2uhjmT9bevgGYr94y56nKI8rRjjCVxjLvaNwWjsJNubaRkfcCGnRsyVR7nL10P8sC/Sv27VKdtKID9Pe49gmH9cL8rCbCtZbdo4cDQRH/ZQ7/wG7DsS22ZQfjoUUv+/A+bSF0hsm5Vz1rU4KW93pLyIBnEnlj08dtJTXBQTd3BkdJZxjEUdEsKDrxMZQGTyAKiIX3zy2XDVrAM7OXYoj6cLH3Nuwo9ZAeeRsnB9iDGf4OXvnxvxhVnPehFIi8+uSKJEC23XA8a720lIm0vRbyO3mvGpPoThQj0UCNU5fF3xkuUHcX9I9xzO0vCl4grVkwaxtaRuG5SNDDVmNC6OL6XOpWkPCHb3cOWaCKRh61eVbVh8LryD7mlxM1AirBO8WvaCN5051Fw+9IPzFw9hSAj41MND7qs5Mkw2w1HOUIYWOQnVeBrRh4vrdqW4XakkwpKRYQVZ3ljNaCoKpEc41ExigajgMh5mgexBQYHKL+11KXNYDZ18MZlqSTJh9cN2A34jK9Ntbz5Xg1JOPfjvH+ecXQt1EVqdrBWiYMDW2DlbFBms4bUL617KXIvcHnfQjEtHSUKNA+OvQd+lg4d6Xip1VNqiCOfEudSMmTOa5MWgzrfw1ED5RBRkTb9XxhTCLqgPGFfH+AInhtXgUhhkiw1dKV7xJWvZ2CqcNtg4yuxItBltj06qPZc65otQExsyNLQqgx2AzJ2cHaY3LMzgJkfvLe0f9+JwOTgzhvr5zorIb62+RNv
 4XoEspKw
 yelzZhpHLHFAWzQVQ1YdriLPz+QmRBKIbkoO+he/zqV4CJti3fYuxGQOXp9dLCJ4hRMm4N2y+6V9ZsS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko made a good suggestion.  I will address that in the next
revision.

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260407010536.83603-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 3657261e42ea1ce93233b322fabf0d2c5c335a35
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: handle <min_region_sz remaining quota as empty
> 
> This commit updates the DAMON quota checks to treat a remaining quota of less
> than min_region_sz as fully charged. It introduces a new helper function,
> damos_quota_is_full(), and replaces the existing explicit quota checks with it.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 3bc7a2bbfe7de..c29f70bcce894 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -2041,6 +2041,14 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
> >  	mutex_unlock(&ctx->walk_control_lock);
> >  }
> >  
> > +static bool damos_quota_is_full(struct damos_quota *quota,
> > +		unsigned long min_region_sz)
> > +{
> > +	if (!damos_quota_is_set(quota))
> > +		return false;
> > +	return quota->charged_sz + min_region_sz > quota->esz;
> 
> Can quota->charged_sz + min_region_sz overflow here?
> 
> Since both variables are unsigned long, if min_region_sz is configured to a
> very large value via sysfs, or on 32-bit systems where memory regions can
> naturally be a large fraction of ULONG_MAX, the sum could wrap around.
> 
> If it wraps around, it would evaluate to a value smaller than quota->esz.
> This would cause damos_quota_is_full() to incorrectly return false even when
> the quota is fully exhausted, bypassing the DAMON action quota limits.
> 
> Could this be written using subtraction to prevent overflow?
> 
> return quota->charged_sz >= quota->esz ||
>        quota->esz - quota->charged_sz < min_region_sz;

Good suggestion, I will do so in the next revision.

> 
> [ ... ]
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260407010536.83603-2-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260407010536.83603-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

