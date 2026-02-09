Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F91BE81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F055A6B009F; Mon,  9 Feb 2026 10:01:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3996B00A0; Mon,  9 Feb 2026 10:01:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94E06B00A1; Mon,  9 Feb 2026 10:01:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C955B6B009F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:01:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE98EB6CFE
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:01:18 +0000 (UTC)
X-FDA: 84425231436.09.AF87792
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id CB6C440016
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:01:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VIc6oMEj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770649276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0coPOWMVgZc+g3IdWjGX+Lv0Cpur4Lg+tHaBcUOJXbg=;
	b=7gfX5MYttMRZEmWz8wYx3z+FSKKx0gQeGbbm0eeN1ahSpa/ef+p3AtUr35rlHaiXQduZdC
	0YdU3GT6S7jzyjYZfM0cxTKTkliQtSDkOjgAxZLH0ASAfyg6YokrlonhQBPBb9Agd8qpUV
	vJC98I8Caa6fQVsKh9jVtQwRKd2FuGM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770649276; a=rsa-sha256;
	cv=pass;
	b=LwiYAlJ461ZpzZbf3pWNQ4T3TGBdR/sPd1a4AU6lAb1aq33GkhBCNU92jf+jULssUSBs8t
	xQ7UY5VK+6t2jPkxktgwJ1fK8qkovgNzR2JO4VvUFxPEyEn1nn1gPJNQzGURczHqhr34fW
	HJ7Bv3VgLYaknpbI8FwaCC/Kd+kIBXg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VIc6oMEj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5664848545fso1718369e0c.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 07:01:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770649276; cv=none;
        d=google.com; s=arc-20240605;
        b=TRG5u4pjlCCYY9mn6VHTs7koG05bdnJs4QYSZD9S1OVFXW0Kw+9dgYChd+B7U0KAaL
         HaqiIkH0nI3VXSnJIsDjXSfeT/2i7uxK7PHqD0KRLFYfONDjnFG2CnP4rNM86bUD8csc
         J+YCMSMfmFhwWXOnx5MkObF39ryI6ymOcgLDV462yJWTkwB8rykEU3rquBNSIT4FPePh
         kN+gmSdlImZv6IKFiB5cXVQNIrT++KQSLEArYVMDgWqRJ/gmVUP1SI588tyPsdy4iC4l
         IJjGe/yjSRHv429dcXKGaKV0954Xd2V7pecPBEX/fqveadGVeZMm2OYj9IcjnNh9YfhK
         nY0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0coPOWMVgZc+g3IdWjGX+Lv0Cpur4Lg+tHaBcUOJXbg=;
        fh=VC1sq2BfrJG31tlswTIh/U8pM3bfMlU3lreK9qRqjbI=;
        b=ldGfJciPe8+sjuHIAoCjiEPVRs152+/rq4Embv5PP2CRqMNUQhA43KV1jOP7mTvqkK
         E4I4nFlBl1N8qU55MJgONKJE8TxcxT6TS9+nWj7hDqHkRICktpli2el/vRbDwtm3pBBw
         O0i9y/a1+UuA7Opa6ftLPztxooUOfx8DAL+wu4yzXQ4+XxBcHwokTtLozrwzcNaNZx6k
         EgpXHdonz+ereE4ixQCOE9rIIyaAs03ijJY9mEI3vD+9ttWtQtrzw2voRgQuoE6+PAyS
         tqlCo70lm0qenQfkBYP3siGyBcaUwhPdDZizr0VjdmVFPI+nWsA7y1HhRIP5D3oWS5q5
         LfOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770649276; x=1771254076; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0coPOWMVgZc+g3IdWjGX+Lv0Cpur4Lg+tHaBcUOJXbg=;
        b=VIc6oMEjw/MuNF/j8aYJWEqFNP7+xHsPlI4hOdaFO1X5mnjcAEdJgrfXNvIJGZTH6T
         vLbHn7u72luQ28B4szRBw5iDm3t9DhUdAQxiJMIHDg2Oz3XgbjezKHrbGCzubM9Vni2F
         A0cbcdcted1v6CXx0o4MeFdnsfui1EcVpD3nB6ladJHgi7t3DXCUK0XxXqcFzFTbfGov
         nqR1Yd5EcZpxqrOA1/uCWFKBBesUlWsO8oywLJkAiB+L2GQ4kyfq/XWLvtoVMWLLlLge
         OTeyEDrTm9GR/oGaI564piPkhvPnxnLFibpJWgWwdhmRi9dbkbjIiTq8kvh9U16kWYSC
         a5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770649276; x=1771254076;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0coPOWMVgZc+g3IdWjGX+Lv0Cpur4Lg+tHaBcUOJXbg=;
        b=BLHfOHYqNrnmbrOky04Sdk84zrtk+HmhMEtOO5n+y+Wh2PuVLfFcTap4lJz55xy//C
         AZsAgiNkFF/AnoL/zh6uEodP9DDwO0RhAtkRJSVFT6Zu8I1qyDG9LH4wFhkavLon0Eo3
         di5j00o3Bix7SR5TwJqMAdKa7istWT9Iw51cZyU8yVBghVNViUxvxR1jYmOC8qPva5fL
         mvOau8LY0uZ/CNeoxAzU6eD+xEPJRwEn1V6YkFFkhVJL6IBu/1cMcvLb9Njs6kNeW03j
         Cf4KAd8pg9B1p/MO+cYaAiHt1r/1wxaGDtPPc2NtyWmxARbopZLb0abXCrNSOWM4sbiu
         VS5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX1M+UkAiJeIG1LbgR/ke9GETVMLrYddXL3QX7Y7AqMJ/5nupfYS+GPd75pZDo4Mp7fVfVjVdYF+w==@kvack.org
X-Gm-Message-State: AOJu0YwbRVgYP8V0lnOJo1Qy7b95d3ydJ0gsC28VFA4mnmgG8sOV04HM
	0gAzsWXWpDisJSUepxKwCI+GZXxHcE7kmLZXygnSWa4LO3IGr590ho23QnP5/XB5p+v7nDROxPA
	ujFnniDjg7YcQKKaeD/MOcrbyUyla3ZQ=
X-Gm-Gg: AZuq6aIg4Cd19Up9tw+cTjMLr6pJZFKKyjJyymUN/algLFqlOG2Pq5f+rIeav55mV4v
	gTX2fvkyEmGNo0nw6lNV81Fbpme+CubG4Lao2WyRmkNepEsC10cHl+1j4c9qFC3yIG15UThjcQo
	AlWznRqCXdc9EGMUDc6aHSU/bW7n594KGoDXfPjcgBPaVWoGkNcm5l4BNVoq/aaQNSXEEkWB9F7
	amEvfh5YL6SahpilJKI9tcv3IaRZ/nmDBXucsguMdK9DfCTXn7sZjMlUXnP6UGHsqGLz73C
X-Received: by 2002:a05:6122:45a7:b0:54a:1e96:e958 with SMTP id
 71dfb90a1353d-56705b85df5mr3065524e0c.0.1770649273870; Mon, 09 Feb 2026
 07:01:13 -0800 (PST)
MIME-Version: 1.0
References: <20260209081323.68339-1-chmh0624@gmail.com> <87wm0m9dn1.fsf@trenco.lwn.net>
In-Reply-To: <87wm0m9dn1.fsf@trenco.lwn.net>
From: =?UTF-8?B?5by16ZaU5Yub?= <chmh0624@gmail.com>
Date: Mon, 9 Feb 2026 23:01:02 +0800
X-Gm-Features: AZwV_QiAlyGXhtQx_eidFLWQrBv-LDoYSO8WgjYuBHCFjqgaMv8Qac5XaiF2-wU
Message-ID: <CABzB-hZpQOR5uxjUKGf2DcfcNXSwpaBf3mmKdmCU0T5=uDVz1g@mail.gmail.com>
Subject: Re: [PATCH] Docs/mm: fix typos and grammar in page_tables.rst
To: Jonathan Corbet <corbet@lwn.net>
Cc: akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000fdae40064a65689e"
X-Rspamd-Queue-Id: CB6C440016
X-Stat-Signature: sqgd5yc645obrk7enamz8xbgkj8ktmy4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770649276-7415
X-HE-Meta: U2FsdGVkX19JfNcwOEJFagQATQLRwnrVTqWXZ9UpJnIOZRP1VWTb94gNcHVV2BAkzCdKJENDrIGxxxRbRUScjKtRZ+vA5qOFJ7fCK/RFAOObu4df0ZQnzdDvSK3V3/PpdkT4RePv9mBqmb/xyj7/t8TaIoEdXCQamrxJPscfGBsjfBDaz+6GneL3WfMFiBhewQB0Ot6OMDB+62xJQAUBMYCJPgWnp7kxN19fA+uW3h2atjOTyUeWEsfmOTijdTykdzaTe/ffTQJJyHI7rHPYgXT8eZL6GH+Crg1dmCaadTE63KTWS/vDvFIK1HKpFZpoJxALZBCrUQ5U+aybbv+08Lzda3aQUh1Msd2gFznrd7CCMF7rgKEb/waWVTFGT+kCQ86xCUpdMwxEMynh9M4tnjOvLf/BdRaEP734CPWVtHCLmWD6YZlkmZMt8UtvMIQqbiSPFiysIVNyrx0l4JtSnx7kl+0hV7Y3pAmjSADnLSxdV3F/cQ1fxG4+eEFcrFteayCNXIqvqsvBo1WCsSyd3aNmsV0NCWSVyjmz8lPqym6Ne0F/xH94vtd5dHMON5PF0x6A8ZF9jI0Uec7N4Xhdbt9eLjJvjxGfMwFKmc+mcVd/A0MxrduaNA+HWwVuW8KNn6j/oXHHBOJvmCtLj0Barty/Y86TbvSjjX142aHDMD7PTfQmauGWA66Yk4o5Y1KHPn1ysIEpJSOENPtZO214sySj8M3CNHy9OG/amAJlWhJrmenPkB+zRGG8qEOhFOGH6SxvUywfLYVPi1JXRXlMkXAbg1QTCCMo7c2/A2NujDGB2hMLM21uEfdvkp5SvfNCj5PR4MdkFZS5kzkX72gHOidIbPWFRU8rih9sSQWstsOM8mO9Hln8mY1vjrqJ7uBQEtCEAvtBgzImc4+JSj+ZjfBkeWZpAiiwN21sSiqV3C2FH8DsJ8Lbb4JuaFyV7HIUd6jKCI6an8WkDZcwOx0
 ptzbyLbI
 uyLd772N8sy5JquWbmtUZIt55GCq5mJYFG/k5py5p55t//meIzkBCNp5CkFBN5addzra9YuTT3p8PsUYcLlEenzRjnJaNTZygQnyzXfjETQUF5NO0k0yNwECMPfjnwj1rwiXTzdtuAQlrN1CmQETIg4m6g1Q4aoV90/iiMmt6wtRUJr3b5SsEpFIouT8qIFSAh1clcgIhhA0H7aXuWJ5a/8k0/gIUbH0+cud4J2DBGxsxvc+D5Q4F+mjdvBlsUIC34kpAn1U97knctp+0XqdC66F6fQl/Zda6CnU6w5MDlqHM+P1xSKkMsdYzbx8XzEE3uV4m6GPm/vR8L07z8Sc/weS/DW2DA7p/moVKAMSdOiFOO1xeE+yhBdiSVq7L5BFbSy4VC3n9A/E+wYZ+q4bPsOeP3QryRXz7bIl9YoxIP6uihUilJIB8E/T+RBz/g3oVgfgo0Kyra2JZnnRGYJhYHMratASpJJcxFG+1BMYaDhMKzWYn8bN10q1CJFL0jgV7wg/2duyIsTQk3NtrBiXzdVyGSGSdCv0OoimUTKArAQX4r8ccL8/wyaYN1r14vpjd4s/A4fRhIqkHh4LPbLIP27f3rF8LsGjMvZY7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001706, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000fdae40064a65689e
Content-Type: text/plain; charset="UTF-8"

Thanks for the feedback, Jon! You're right, there's only one Linus. I have
just sent out a v2 with "Torvalds's" corrected.

--000000000000fdae40064a65689e
Content-Type: text/html; charset="UTF-8"

<div dir="ltr">Thanks for the feedback, Jon! You&#39;re right, there&#39;s only one Linus. I have just sent out a v2 with &quot;Torvalds&#39;s&quot; corrected.</div>

--000000000000fdae40064a65689e--

