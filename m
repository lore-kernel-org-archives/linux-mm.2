Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279D0109B489
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6476F6B0096; Tue, 31 Mar 2026 11:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8476B0098; Tue, 31 Mar 2026 11:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D586B0099; Tue, 31 Mar 2026 11:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2EA6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:13:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C559C577E2
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:13:34 +0000 (UTC)
X-FDA: 84606702348.07.4EC34D1
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id E32E91C0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:13:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=onZjPNBL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774970012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftSpwco99w6JKZqWu12nQUgnLtfWtJC0vDyWjGnwlNs=;
	b=vSdSjlAO8qlmiZJWHVESMZarfdq2Qe8rWQZNTue+L2Leb7YDvwK36QV55JppMPf+89SKIx
	HLBdz75Ubek8o38yHZR69aS2oz8IuHNYEsKRdIJiKVKFzmCpxdUGnyC5+xJETKJcmIs4Q3
	NWZfk4rsGbv0dIpBOdAwHRWmBRKf4Ig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774970013; a=rsa-sha256;
	cv=none;
	b=Xp8K4eBbC+YnmMSt/tdyg7SnKc5OFkOKsVzVlBFXT4PoJayHaKE+Z3IGU37yBj7Jvrz/ip
	M4EMv1oq1G1lGLgw8qDk0YCawDsPsJ1wPVVL5LZZaN9gySP9MnyBISWXQKHJ0G8TXws0Vb
	XV53TZ1lSu9V4jER9qLGAzFiYFl++28=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=onZjPNBL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-824c9da9928so3689256b3a.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774970012; x=1775574812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ftSpwco99w6JKZqWu12nQUgnLtfWtJC0vDyWjGnwlNs=;
        b=onZjPNBLBhIzKVs5OWKBNncREK4B3ILibuAKYw5F2LbqOzIYgzHKFSGxz17u+HB5AJ
         u5o+ewzjzy0gSA6Ak3REW5H4O1Iqmxi+C3AORSaIR+qYm59N8hX6AhKaYA38tad2Qd8C
         o7xL028Iyc16wsuqbmocva5kPGJNPHTTvck2xQqrM34oxZErnq4z7jin0s9+yur7jGsT
         q072n+ya3cRP1gXrUV0jxgWzN19oIAfy+QTr4utI5QxnVhVA2FylIMQPkAjnMBZ4gxKx
         pOo4ShzAY7YXeVPEQacKQrzUXA8O/SnaDvmM/0CC7TSNWDACqKYd1v9o2v3YZEW9rChW
         Ufyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774970012; x=1775574812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ftSpwco99w6JKZqWu12nQUgnLtfWtJC0vDyWjGnwlNs=;
        b=g2CYJTGxrli4ii30jTYzhRRQdDkMfguHe6Fr/MNvH4Z3/7t53Y5rrWVvGKd0YzHRT1
         KusvLhfxrtNT6uhZrSo1hykbo/ViOeHQ2qcB0KayYRaJl63ct0PKm9eTmBcrtaP2biyL
         meZxJSBs5hsHe8U/1dqL7PuFvr3Phc3ixKzMfeiuu/WNjAKYQNypwne5BgSRA0eYBHgA
         nHz1OZtbehsRImA2t2evKXuMnkSBlqKTHzhi8oDT73J/D8spw20b3tO+0fVEIIPeNWm6
         xUJ/L5ozTjx1bbQTynv+OAjR7wEvgDxEDXN97FuwyYfL6SNFfrcqhDTe1sjn9Zm825Zz
         EP4w==
X-Forwarded-Encrypted: i=1; AJvYcCVUDxAFsLwtpmm9ErkVDSMReIHVdn3FGHLAYAmC9DO6oJ7Mr9WHTNr/rkXF7sPbyJh7YCeNoyT1Mg==@kvack.org
X-Gm-Message-State: AOJu0YxFk5Bj+fhuhzsQHDy6KEHfdM7D4ivO9FRCqHfh2VYYNmCxe9Tg
	vpgqoxzpP5guwa3791/Q7RJTTialpY6Bse1SkWsQdSotD0ImVLQ2Rr8+
X-Gm-Gg: ATEYQzwHAf4SlFoLBP7UB3+UTjKDzn67wg7dw3iv6ueX68WVypHJdqBhR4wy8NLCo7P
	9AfkCxykNvO6VKcMKCqYrZfyZ/fTB9MXiP4/sdLDkD0LYUtcTDO5XYs+FpI+F4bchc4Xe9u1mme
	r/cc0VBaBQDYS7EY59Q7zKrtIiCMvZibw04xvD2mxmjYegHL+jFS1vGNBikfO6ZsrS1T6046UPr
	hJ38Ai3r7weV0d02ZgGFvrHclnHmuTW0Mxn0/b9xFqG4cfnL4gK17aoWLV2AyP8iDCJQCLj4Ag1
	aLkThD0cyz3oaKT184LR382AVTsCJRudVp0CIAZ0DHubTumJuW+lLvqxXJRbW5JsbGVlBaZeEWU
	c3yUeWTk2nslExuoDaIA8VB6J7INdOsC/mSH68ozc6flemBhBT6t51rJpKBbZOUkKuQbcIGnxEo
	cdLafforWisSDOf/+ngxiR+gwkbFNMn786tFPtzIXSERRk0UNa3ic=
X-Received: by 2002:a05:6a00:1912:b0:7fb:f87d:a0aa with SMTP id d2e1a72fcca58-82c960a60demr15637739b3a.52.1774970011465;
        Tue, 31 Mar 2026 08:13:31 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cc025659dsm6054481b3a.51.2026.03.31.08.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 08:13:30 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon: validate min_region_size to be power of 2
Date: Tue, 31 Mar 2026 23:13:30 +0800
Message-ID: <20260331151330.6972-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331150009.5014-1-aethernet65535@gmail.com>
References: <20260331150009.5014-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E32E91C0002
X-Stat-Signature: ub8fywud8n3z96bgft56dhi7raba15gn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774970012-278631
X-HE-Meta: U2FsdGVkX1+NeJPt4D2VvriF5UszAVjCOKVdde/GENQ46p8fnabv+juerYcMIeUDLNaAjCg8BgwC6fQoHkCUprQ4in/orWhQ9/MvXMaMviW96cyRH5OcbbCzph0G6dXgxx6Hy/uMhQlOlWKNUENUshFv6sfwU8Swn0qQRFwFb6qylqlgwTZMcpsaEfZ6qr3qMLcBRqOrR7gDNNZGO/vTvsVvkUOLv1xMEEtodh2On95xBkTEGRCNqt/OeDvX59vMh189+3bK01YXvPUXEL2zqyr1wHg0mCBFTTloWjmlmjVw0zi1c/rV6Hp7FwVFOpqvA1abmI21yeIuDCZFV0PYnwfCemLgQyrpVleeXh7TJU1zukUlwzpHzqYEXZp9kN6+/nGMn7DLBZ05NvPtbJqM+mD1mJHr9BiUfS7xmzdmLojejhRIt67tiCsSl6oWZ0bkE7mcz47VM/qYCiytxEooovTWMYFznDKU1djdjCzPeK8fjd7/AO1S/eS0ixKLTkYZwbU65PpzxDKc33LMZ48ZQhSvPc0QzNTYcOzWdq5A3grfDzyqGFsNyevcGQRk6I87ieCosp7Azdlawz3ZSOqv5DlxtzBluI/mna8Q0kbnmnw42rNOUxM8qYtiVQ7vvyWdqGoItBNq+Z/EYZ3KqTp4Ak4LXD5Dy/jCOXv0hydiafzbEkEY5d0m3cGg0f/mOJeMKdHRAI2X/pDWLHbF7sIztqqkY3v5dDynnGzVmY/RNlK9s89MH9DT/UrTXlES52bSYQ4kEVBFmYLOou0+mo3nmHtpIILEq7A070fK2l/yiJ7URjABa3iJ8BSdRVx9LdR6wQI7Xv01j2vSqN4VGtLG+Jv99qERY5KmwlO9n7YVdJmSC0elNh6A0iiDxseplAY5OkJlPIB8OnZTkx6P2HhFKKEHCXjsgI9Qh5oh3rk5U2Gg584Y9Mq+3qLEQ2glqdtzGMNAfmrsMeQYwNEOy5+
 GRyFOHGt
 o/V0QtDeikb4DDNTrSxjE0GQod75qtiaeVDp00Tt9EGxEl5/4FZ09pRTSzGMKOp9fsKFs4tcHG4cXlj/b8bKRhCbU4BXpH4gheIkvWHoaU7gJJBlqZSG5wYynYtFfiSphq3/l4JVAynbjR4iOTP5F3PWgvMLeNFQfLyG6O1OCGuvj3qIwtItsbWjywitl6LKI88A3v/8E55mbTV9oRLsfTHpdBmNszJXQ/NjkyiI0i5y2VMV0WihPMeZZNKV7A8dFdKnQHe8cLC0KZQP6vJ3fUe7GZWVJXfARg1qZ0UqaMQ6hpOB8oRbc8PaKE3A7DUjR1jlhuDRkoqmgu1dj9s57ex99/ZiRfTth9D0VnErItkJuZOuKDOaaHP/821jrDJF+2l29hiVsh4DJWG3voJmmS7xGKx1K6XraQZPBVOuhicQ7UyXdD9CxTEvf7OFS950h02bKlbrDZz0veopE2Cux6go2WQ8BCF7N3R+K3pnkDFkhnANGr639ohRxBiqBOwD/efw+53T0lwd5AQHJep7OnON35SrDGwHBo8cTy62+vY3U0vA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > [...]
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d72976..205592194efd 100644
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c
> > @@ -294,6 +294,9 @@ static int damon_lru_sort_apply_parameters(void)
> >  	param_ctx->addr_unit = addr_unit;
> >  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
> >  
> > +	if (!is_power_of_2(param_ctx->min_region_sz))
> > +		return -EINVAL;
> > +
> 
> Does this code leak the allocated param_ctx?
> 
> Looking earlier in damon_lru_sort_apply_parameters(), param_ctx is allocated
> via damon_modules_new_paddr_ctx_target(). The existing error paths below
> this check use a goto out; to ensure damon_destroy_ctx(param_ctx) is called.
> 
> By returning directly here, does it skip freeing param_ctx?
> 

You are absolutely right. I missed the cleanup path here.

I should have used 'err = -EINVAL; goto out;' to ensure 'param_ctx' is
properly freed, similar to the existing error handling below.

> >  	if (!damon_lru_sort_mon_attrs.sample_interval) {
> >  		err = -EINVAL;
> >  		goto out;
> 
> [ ... ]
> 
> > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > index 86da14778658..6e29d92670c4 100644
> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> > @@ -204,6 +204,9 @@ static int damon_reclaim_apply_parameters(void)
> >  	param_ctx->addr_unit = addr_unit;
> >  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
> >  
> > +	if (!is_power_of_2(param_ctx->min_region_sz))
> > +		return -EINVAL;
> > +
> 
> Can this result in a similar leak in the reclaim path?
> 
> Like the previous file, param_ctx is allocated earlier in this function
> and there is an out label that handles cleaning up the context. Could this
> be changed to set err = -EINVAL; and goto out; instead of returning directly?

I will fix this in the next version. Thank you for the catch!

> 
> >  	if (!damon_reclaim_mon_attrs.aggr_interval) {
> >  		err = -EINVAL;
> >  		goto out;
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260331073231.30060-1-aethernet65535@gmail.com
> #
> # hkml [1] generated a draft of this mail.  It can be regenerated
> # using below command:
> #
> #     hkml patch sashiko_dev --for_forwarding \
> #             20260331073231.30060-1-aethernet65535@gmail.com
> #
> # [1] https://github.com/sjp38/hackermail

Best regards,
Rui Yan

