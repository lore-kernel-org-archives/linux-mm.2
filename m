Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D53D41C02
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9D66B0005; Thu, 11 Dec 2025 03:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A556B000D; Thu, 11 Dec 2025 03:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270C76B000E; Thu, 11 Dec 2025 03:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1F46B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:13:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD2EF60512
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:13:22 +0000 (UTC)
X-FDA: 84206475444.22.6803504
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B6B38000E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:13:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jjXXGdK1;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765440801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLn0iw17P9OFh9gdKJAm0SUtjHBkJ1vLAEufp25TC1g=;
	b=NwTOBHnlA89E8i0C5XR0cbbzxKPjvXbFOBEJ8CDcgLUrx5VSltAZyPU+P6WWE4CmGsbcn3
	t9NFs/LmiiyIWmWXlSLHCvE7RdswQblcHWtPnmOBVnUDnQSFiAG8P1/8qrhXC5YISbc3U/
	JFawQoPwzmIt6zRk2vD3Om40K7Rmo7U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jjXXGdK1;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765440801; a=rsa-sha256;
	cv=none;
	b=dBkvKzdGkoIWG0H+HHvAy1UuoDqyz1uhjQK4BgifckqEAbWDWJwXcfoy5fd/nP5B6jMrqu
	HcAq7K+/RwQu5Enceo3ul6BNF9xCJdOq4Y1oNL58fttrVJ3qCw0WVVIvSQZrCCpNzf+hLV
	I6B2m79rVISwOdIhC1+6gBnlYtv6psk=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-640d4f2f13dso706243d50.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765440800; x=1766045600; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CLn0iw17P9OFh9gdKJAm0SUtjHBkJ1vLAEufp25TC1g=;
        b=jjXXGdK1br2Li0OFvy11wXQpn7EyNL8H3ARn01BLfgEqwhdRnCStxKpv0OPGy5MEK3
         Oc3Pl335CJxGRMZL2xIeIIJ0rxjUWR9cj+KgQHmAkR8dRI6u8PmCClXLVwmS8bTqGmWW
         0UO7mJuiAjekAdACLv9VY3kds5qWPXO4jKJ2AZTcm0kB+6cfhUdx/XGgsgR/ZUqC1CQ+
         umB1Mp5LI/MnZFuzR9GpXYsoULpgwRrd57Af6hhH13U9lrilW9DSOQZFkmDAT2bDQNwU
         AL8WzcuWQVib3HOGrLzRfAuER3103e/X5BkUL84AMhdEGuG2FCM4c+8+fLUIK1HEG3OY
         pIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765440800; x=1766045600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLn0iw17P9OFh9gdKJAm0SUtjHBkJ1vLAEufp25TC1g=;
        b=gSSv9g4pIIONY75+CvrQYwbuZgIdDZjN/U/C/zPzzlrxcqlf2QJZ+euAksVDKIu8Oo
         Qmryv/SQ8rePSVDAnxGSuCYzq8jClfw3t3w2LLvjKaOrXWFzezZ7GrSwgBuvxJII0Emk
         WM/8hQMIf8doy0T5Ls0e1EGsxSiNIdWp+VC/lMj5gNnV36wy2r8UfxDY81TrTuCOgNWL
         2CzRrQP0sGUm9Cw4LWDjhRb6nX6whq65eP2qCWwWrFifJ8qk8ZDJGzKWnYBoKCQtNYSh
         VFYUuYzaXMlatKdfaIpXvCO9fS3UXOyvBO/sbx57rN6t4iqJhe3xXFV3sr06blxAOgyf
         ZaOw==
X-Forwarded-Encrypted: i=1; AJvYcCULdJsB+V71gumRKQmoYVWgNyql47kHk34U5+eewMLGsWTgVAvtqyIrtgZ/1WMEpxMo9scGpVmNAw==@kvack.org
X-Gm-Message-State: AOJu0YzGf75aNAroBQWew71QOezBFSskba7fw3/yRQEMnwpSTg76q4ak
	5ktzECY0mpJKhdrF2tvWwsdXcvJBQFRz2ZxF1fAPLpqQE5Ki8BER2oRSLC/pQytPRcqoFd8pNUI
	BSz/sXrkdPoTy/PRuz/KJzDhEthlvttg=
X-Gm-Gg: AY/fxX5V4oOpDPyoe/agKOU+3OgolggBl2zLUZMXTKfW/BYD70rRRxX+VTVVOGyY09C
	jTHPIske65CQKRCz+sNDDazQ1+fid1KXf7qYtDVD6jX+PIDJQPxBlmAjjUp3BKdLU2sBcy8214i
	SbNeYJGH+Ngtx3IxeNlYsPQnjwIcr3gYUX45ddyIvZ4cybtvn0WWRy4d5d/AXapmVeHbYk3WUT1
	txbceOAilwLa7s375vV3V6f1MI5PFfQYB1Zffa7/BDRFUnQ37ml9i2On9XTjZCdTGxgb559
X-Google-Smtp-Source: AGHT+IH7g+xosGzrVH4LSyMQe6QK6+GGm4lxB3NTXCs6NxPvpAP7+S/GztIodY2SbXRYMLbEGLmionhWVQVmT7iUV70=
X-Received: by 2002:a05:690c:4c10:b0:78c:57e6:6e60 with SMTP id
 00721157ae682-78c95a97b0cmr40362417b3.9.1765440800082; Thu, 11 Dec 2025
 00:13:20 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC7epLcuK-58kaROWMof9dq3ZCm2WV218KGv7kcDMf7q-Q@mail.gmail.com>
 <20251211075446.75355-1-sj@kernel.org>
In-Reply-To: <20251211075446.75355-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 11 Dec 2025 17:13:09 +0900
X-Gm-Features: AQt7F2rdWXEOoWpuHS2_yNXMlB4_wOzvOZ_YEs72z7WPudcsREt6WXoUBNFbR1E
Message-ID: <CAHOvCC6ixeLQeTJANkAvQhRviLyr7=xNBs-_jeKEo+qF6E3qAg@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3uic65f6dzrtkiy6cbe73j4obwz1xh6u
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B6B38000E
X-HE-Tag: 1765440800-33923
X-HE-Meta: U2FsdGVkX18j0pz8MA4lV2dioBYB7Awuh/tcq+0W+YoeJ1vLl+oZxYp73i2Jlu3LaeO41+mL4XA7CeHM9rncfxAJ01wws2pOMywH/HYE32S0R+4RMe9qBqGmstBoQ+487LxSIBuMrE5Efz5zS6dmHOzWH7SIcPQDDURhqQS6Wh893hZSWURWQ8kIP1435mP2C8NlO2kCd+dI42TEDBuZjqbMPCzwHJ1W/bAQ5gMz56rFPtIKoFrfWa41/LcLGuY5rMh01P5tNpP6gEtIENzc4GU38VEhN/PQ1WUctaFUnqm7LPIXjRWJzVJrX58IEL+wQraQLGleR5Vs8/gP1Pob2E6PkbY01Ijr3DYIMNQ4lSCQST+OvStbwABj+PsLx82f6xwLxMMSSyLuSZjhlDbqjQU0/CiZf8MruG1nMZ/qJacDBAeyBJrEkOYXFue9UyH8zj5hIPctU+eCyiGJuKNASWz6DuLYfWlCaW7pqoSHOp7OjLb9X1d+fU6tg7DN2V4bk2VSq6C370No+WVddwzENym5S4uEINMDqJ78xtqtPQGxkcYpE5qV6edI/y3JziDfDSCVAyBsxW9btQhL9kn7BMxYB3T6NK4z2cLqaXXT6/DqCKvrNGUymRMVcA7elKh3gFHNlY3gu5OMajnqs4bUvQSuOQbwv1OXWivusoGqZiwj0H+xZwrNSOo6vbHdKoc1GFu5Dns7tLCaaHm2vMaXbugSujZ3Ao3sTlZNblpER8sQORpu7fnStpFrZHa0n1zd6B1zCiJnXjOQB9xgr5LN17dFO+EvoS28kFG+N1PPcxxNhCk5P2P+aVVDZHpo3obJZJ28VAzuWVl+rVx8MSaNWD9EnHRiId0JoiJiRognSCFnd9fOM97Y02pOGb+er1mbvUH42pLi4qLvDx4UZKdNo1I2f8yiujdxgwSAgxuobRgl1EOOedcVMimsAiYUW1MAYzwgt9ued7u2So7MZWm
 G8WgJDOH
 s1fT+ngCmefypN4bOnJ7XQzoOpo2MGcNwJOlo+q9Q4PkqfRs+7N/wpKTMwpU4AG33+zXVXREs4lSb3rIsgu/5kycHAoLFALuzoVptOGsBjy6FIiphwvJJ+oYoMxnWXP0vCT3qvs0EMwbSedK8Qp2wrBiBkF9s8g0i/zkirZVghGyraZ7IXVYRVJlxdtnm0Z60ZPReUQdS0pY3DfGR/Pae++N6J0CsAggtQsrMsVe0kkjQfelZa9Y3RqXupnNgOLegDkb5ftuyER4hVREbkvS/GrdOasN596TyJv5rWCjHEk5f9y2tXEd60g/T9nZqOOKpwbw/iCBaNF7ahrDEMndyRRjTyW8LrDdg/aZuEiPyOToxB+98/ssUIoDl11MzYToysYhDYRReSWppoOPx/Z6pWl31OcfUlK4bLYj/C0e1odCl8fzs5oO/fcZoyiAN4C5STenW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.043768, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 at 16:54, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 11 Dec 2025 16:38:46 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Thu, 11 Dec 2025 at 15:04, SeongJae Park <sj@kernel.org> wrote:
> [...]
> > > Sounds good.  Would you mind sending a patch for that?
> >
> > Would you like me to send you the patch with only the comments corrected?
>
> I was just asking your preferrence, and seems you have no strong one.  I will
> do that on my own unless you mind.

I have been argued the following so far:
"I proposed unifying them into kmalloc()/kfree() methods and
removing the dealloc_on_cancel."
I apologize for not being able to respond promptly and smoothly
this week due to a busy my external lecture schedule.

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

