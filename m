Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC087F3ED5B
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 17:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE64C6B0089; Sat, 11 Apr 2026 13:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97336B008A; Sat, 11 Apr 2026 13:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACB06B0092; Sat, 11 Apr 2026 13:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C88156B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 13:56:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 323A614088F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:56:04 +0000 (UTC)
X-FDA: 84647028648.26.43EFABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D795A0002
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:56:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HMYYvYRa;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775930162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KbA8iiSIxFBs42GjMohDMeNH/SQ5CO8YRPjtb9+lg0=;
	b=F5tpbT5io5rEbNC3rlTPJ+8iNVBcv8svB+F3vAgnPUTAhiPD8N3Exx/Qq/NjyiODPzKppy
	N0dnx6q59F36vt1afnKtEJx8IO3zjlNVDLKo4xXrGj0UnBagteb7KK2JqqHHh/vLDmQffw
	HufxWTqBQcLyd1+LXwejBVA5MTN+5hE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HMYYvYRa;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775930162; a=rsa-sha256;
	cv=none;
	b=o8uSLRtBNkeyCqVYh4rsl3JaFk4rtNmFk8WGxbQVp/IHn38jA5j+ExNMmZuEVSGblW0PC6
	fo/GexfM1/yKUhGifJeXLlpfPQ7wWErFZKsOdZ/Osbarj4X8pCyG0vb1GlX0EuUErDLby/
	xO7I9hJCSF0W8ME77Sdj26IMIOv3Dlo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D28F6015B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D43C4CEF7;
	Sat, 11 Apr 2026 17:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775930161;
	bh=Ob5MmNNfLMwvmEBeU1tkxBH6cg05is6h9z9uqPS/UOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMYYvYRaX0oan2/dq1WNCKiOt9pZLbjFf5PmP3Z1DJkXUmGF13NBIBqaOSRFwUJhD
	 lWVsXRRmOukNNZ58qJ43Nd4F2YBbxRuqPVhA/vuWOBdXGB2vIqvhbP2VicWjiTnz6S
	 6nq3aA/UDV9FQt0eAFXS5ZKzcF7PuNUc6kEDlRwvVLWHfS0BMSA3i+ZNT+3Dk8crZA
	 Lks7+mar8gHkE4Thy8YzLgiHbBdw2nLUWNDRph9T5Op0bKGtz7ItJYMNicl5AQ5Ley
	 6NC6Up66L0uiOlf3W+IV4yY7tAchl1sKKtKIMkz6Pu9C53sEMJAHUonoYJehUIflyA
	 BV/uCUHSFs8Tg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5.1 01/11] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Sat, 11 Apr 2026 10:55:53 -0700
Message-ID: <20260411175554.79572-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yrnhwwzaigy1zi5cxunknozphcp9xas9
X-Rspamd-Queue-Id: 9D795A0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1775930162-245087
X-HE-Meta: U2FsdGVkX1/ZTFu/iv/IdFhTdipzo4DCh8xTbz3Iwxr1La8bZp6TeTQmdxY94spkh5btwtm6IwQ5WyuYXkH6vz8AT9Tfdj1sEHR8zfsjog/kzf8R5iAg3xrxaAO3h+oGktsDpst7UD6IqCBS/QRCZHkAgPSKsjBU8v44M3foYom2WbAfjLnIf9FYt30pmnOwtc+RCdOUGZ1N7/2igup7peM5xG2k4ohAvzod1rOdmRL45XfVKyarcUsBT4U6IpVYNoYAXkQe98EfjOflTvxmDHt4BV6dh3PULETW41D3yqOa8jDtxicqsaenvZ3FgahSMQI6FXk6p5jSLbGzHuhAay6+nALriBGL8LI49n71KqT06ezE4wZh5cGA8jHGWrDnLBrDD8hD3lrSiPqzr6YJ/zHZZfiST9ANyF2EcJYUijt40mNn59aqF37f8b1OzOZCHwZzH1v4s2QKndMn4c+om5wLopA28EiOnixiyvULzZ66I8dGXnLZw6lGKeTlmappBKYxoNfiqwXoCMrrnS1kiH6naPyB6oi0iiS2bLWtPn2dzWH5w3tAeDhX+JOENzn0ViXYqf3rY1AmAQNvJtt5oMZrcBm2Lm2QB2KxYkqyXYiCi5qytcdM4kA/B0xT00zEzBnHkIKKTe/yOAHDjpGAv6Vv3JXmhDVuKTVfiaAwoHQ9TG56YGWDrKSdsHj5JNZ0JP7pY1DKWOuFsa2HHIST+95kiau+RxUp0qqPhF61yDFnN/peuigYGl8e3XJkkgD13oqvrfYb+yAEa5EwpeZ65iDkyD5R/61t087RNm9c2zviWRUax/Osfk+V43jj+NQ2eG142dYdHIYtw6r84NUiPa91pgaQMs5GTZhG+SGS3htP9NHoz+oyBdYLxUrKVtJxjV1etT0sHhqvTZxzrzFxRkJtKZZZ5I7LUKNHD3K+7Rz8VDh0TlBYmljVSbR7nUDEvma/upE505snOP3dzLd
 S0yFGPvC
 kbs4Sw4vWl4NtchXLJuEpoZVyvZokLskmGH8X8csOHvD6nAfTqfcEDIavdPY7kse4p2tDoVfvbentQImp7Y93zd+qsSkmnFJFyuM1UmKEbmTAySz9/OPk/3t+qkElhC14sIe+Eb9v/brWxtmuHbjQeBL4oiKGUylp+CDde0XwOnohpTys2hm8c+vbpAwCoayC65lRMvTndu1crjCzLWJbKSxMuprSQA9GrLLDovbEWCEgL2L8azx9jZAjxVJ+E2T1MAsNzBG/yIeDBGHuKS9OQoNxPfBU7fJtITmN3pcBrLl6EbyLtNrGAa9QYcWDSXyrkiQAHWnkxlLHS9r/rD1Q4HAVcnPEbVKhEmhlrJSKj32+pHmQpjGB4nYIjkgfOsOmPDo6prhi87Pv/5AwMYPx9qvy4L5bkfoGMoB87umu7cuGUDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: no blocker of this patch from sashiko review.

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260411164908.77189-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 2f0a2c02b528b6c75ac3074d06b729bc93bd8589
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: handle <min_region_sz remaining quota as empty
> 
> This commit updates DAMON quota handling to treat a remaining quota of
> less than min_region_sz as effectively fully charged. This ensures that
> charge_target_from and charge_addr_from of the quota are updated properly,
> avoiding applying DAMOS actions too frequently to specific memory areas.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 12544c60531d3..8dbc365bb8e97 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -2127,8 +2140,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
> >  			continue;
> >  
> >  		/* Check the quota */
> > -		if (damos_quota_is_set(quota) &&
> > -				quota->charged_sz >= quota->esz)
> > +		if (damos_quota_is_full(quota, c->min_region_sz))
> >  			continue;
> 
> With this change, damon_do_apply_schemes() ensures that we only proceed
> to call damos_apply_scheme() when the remaining quota is at least
> c->min_region_sz.
> 
> Does this make the if (!sz) check inside damos_apply_scheme() unreachable?
> 
> mm/damon/core.c:damos_apply_scheme() {
> 	...
> 	if (c->ops.apply_scheme) {
> 		if (damos_quota_is_set(quota) &&
> 				quota->charged_sz + sz > quota->esz) {
> 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
> 					c->min_region_sz);
> 			if (!sz)
> 				goto update_stat;
> 	...
> }
> 
> Since the remaining quota (quota->esz - quota->charged_sz) is guaranteed to
> be >= c->min_region_sz when reaching this point, ALIGN_DOWN will always
> result in sz >= c->min_region_sz.
> 
> Could this check and the goto be removed to clean up the dead code?

Same question was asked on the previous version of this patch.  My answer is
also same.  This makes sense but better to be done as a separate cleanup work.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260411164908.77189-2-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260411164908.77189-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

