Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F17C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 15:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800836B008C; Sun, 23 Aug 2026 11:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC276B0092; Sun, 23 Aug 2026 11:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE766B0095; Sun, 23 Aug 2026 11:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 466B16B008C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:28:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3CFC1C131D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:28:01 +0000 (UTC)
X-FDA: 85132914762.27.9B01A59
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC5891A0003
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:27:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WPoPbcBX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787498879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+0yROr5ZDR6qKYkdM8vuVO0QXC0R++IQtJDPG6CeWI=;
	b=sqSOstBESkeX5LlnOdeRj2zp2xRHgj5Zy4dDhZTdZV17v0DOMJXQekcdg2sg9EZzc6XX4r
	wL9eXi5L/MJsD0hHjo90Pd/hNDrcls6qWFv70+0vIRd9G26u6+tsKyVOsPB0htDmtHiCbn
	yjgxdLMufQgfcRtFW13CYT+aHIZVzU8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WPoPbcBX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787498879;
	b=vpTMOtUSF7d05kT6YjvkVR4s6fhAVEXL9v1ohjKdY/g6L0FZMDhzBlmcEIWMXh9XYR8MLA
	B0+r8vOgKhf6cHX+s7Q8l7xWtRyThQ1TSIYFb6ikI9KBTMzYW/v9ssVQAqGRuz6yyeqPA3
	HMwe2p0SIT1NYOG54V5lTI0lHwK7ObM=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6688acd1a51so4274125d50.3
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787498879; cv=none;
        d=google.com; s=arc-20260327;
        b=iy0XmWIHW+Rpc8phhsMvcdBd4JwZ77TcbbpPijDvLYHj/Y2sKc5MqIsJalRo9dPXxJ
         yjGC/F9ztM4PI5QxrT7F2lD6IAonv2Wq7XTCvyXpBamaziwLkZhpkQWDWmoT3PO/bqqS
         26nkqLkpStmBUctkmKlaYFk9sgPI4tVDz8meTTh3FHJUWqVDCTgYXyg9tH8W13LPzwi3
         7RoJ5hn/kPs5Xk2/MYlJKLkNJgR94DP4nZI9uyafd3eeoQnOIGvSbq1OvTAiCdBfNoTe
         cBwioL4o72sHc7GeF+1TxEUVMIFHze6QCc+SKqmMshKJWkv2Ao/9ooJnaLBq7Ccsr8EJ
         AbTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8+0yROr5ZDR6qKYkdM8vuVO0QXC0R++IQtJDPG6CeWI=;
        fh=Ks3UY7ZjK7kGS1RJXuAWxivZVkYhRaQ6ULtv7AcaCJs=;
        b=rkxAvQ0FEUHe/SOTMm8Qa2seX7R+V0+l74lstRmibHz0nrlPLv9XD/OhPLokyuuTUx
         LnrOpF9gT9lKD2ds426Z+A+Gh+0R9UeuSIRkatpdRcAqJ1zTRnFnItuPE9jnabGUKlue
         HIezGnUErIwgjAHPObR8gR8hh36VLQTNODiu97Hol7cXogTgOshvZWLHZoDCFf69+bCG
         jSCpy6rzWvSsDNuzq1BxbsgIxtP27e4Iiv+kz/T48GobfwI6hbMzX+1PqfpDfvudSFrx
         BDDd0lBIAwKoGsjJ6Y4t7ZdW/sT91ptyARiR60pJ+sagKmCs/ZDKBmGPmlkU8l1FgOYY
         9q0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787498879; x=1788103679; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8+0yROr5ZDR6qKYkdM8vuVO0QXC0R++IQtJDPG6CeWI=;
        b=WPoPbcBXfRmkYcjFRSmXpn8l0QgllDkf+yXna52oPG9QwCAdPYqDQicz0LwYFPzgkj
         gDLU1CxsTCoc0UyoEodfAP0QvbAFVfZdJmtMbT8QtelLTWyOGKLo03hfQPruhz8u5Pyz
         oee2GiqgrJq/MuPlYo8zKcyFvxHkKZt3jXzQBzF5+2+4SYETy0BJAtxNrPN+LTAxCPip
         l8gtqyC2WBkoYqt8AnRZmxmVTFVdzzOQ5VV2SAoTiTRm9I3orsnX6i0H6SWYn8LkpX3k
         4McacGjNwvRNrLWhESADLxsSGUqmc92UoIsWLZDElXVnsYgMhdfvL42l1Laf3OOICM9h
         UYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787498879; x=1788103679;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8+0yROr5ZDR6qKYkdM8vuVO0QXC0R++IQtJDPG6CeWI=;
        b=KmJaw8S2xUMsz2cG7AsmOrZG6pCNzbTighvXySlaD24bv5SkDCTL1TGGDc+wvxXPA7
         riXWuZ+fogU/RaIb3sfYA8fEzY64dMZ3+8XCLuZO3OZ0izgbWIF4S4raUhIAYbMoiEfA
         ECxS9q0UCpp60avE4mLvY075WlXWGKvIvXfH/Mmq0nsxsynKm0sFoZKTKSXkJPSADlAP
         /hRAmPDeUOnETNa19IRLMuEYH4Lj0oWUJKLKV7HkmDkge8U6Oq2MXaTGVRa78d/7IH4T
         p4eEeCqXbYHvy49PdeCMVvuHizTKVrKaIABYjnjayps86DNRMkjBZQ9MQvxcK2T6aNhu
         eafg==
X-Forwarded-Encrypted: i=1; AHgh+Rq4kP02lvEaJ2MYXvzXIIJSsyQ5BynKdqFC7N94rDB15ypHdKtPoHAOJuO10CPeQszEGFNFHKxlCg==@kvack.org
X-Gm-Message-State: AFuF++n3ccyXWEajToKJ2VHzuE8GjHUC231wE2+paRuznYGU9H4d1quW
	W3qlwHmGuFdIsR0mDpIxfLdAJuimWo5++WDSHNFNYdwY7KgNcFoZbVZTkpo3rqXavvAKfjSSWdW
	Nxt+aosFNd5B27AIP79dVWAB9bAVQ7q8v+w==
X-Gm-Gg: AR+sD13O19eEX5q89Hcm0Q/o28ZQ3+8k8F4hzayqq3q5zmBC+pKWO1S9GcbtU60xZxJ
	qHAQcBhvYqyQ7H46oVMMHsk4nbvDByQy3r8dXTuTYdHcES21Wop9CLSN4m+JSSvmLPplaJb8PAT
	Z3eV/DQxxAfb48g9OT5AfajnXJpWryFRX/axkzZ6jUSO/VwCmK3Y/0296IxoGseA/AjP8IOGE05
	Xbrzh1i4tRHoMnpWQ0x0sWrnXEjyfhYLfUwDYKZnKRfgJFX9aH9bPZPgVACWIUS35KwDuikELqC
	AGfSk1w9k5Z1L0oKFhDcZ543DLR87AeI5dCF4UoVaw==
X-Received: by 2002:a05:690e:2067:b0:668:8dfd:8c81 with SMTP id
 956f58d0204a3-66ce49d5560mr5820254d50.7.1787498878778; Sun, 23 Aug 2026
 08:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260814133744.2746782-1-ekffu200098@gmail.com> <178749489754.3572398.2045978564409288262.b4-review@b4>
In-Reply-To: <178749489754.3572398.2045978564409288262.b4-review@b4>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 24 Aug 2026 00:27:47 +0900
X-Gm-Features: AcwNN1UrlCoiJ9GDeUB1meX53Sh7YCZZv4PXMe-ZQHVVb-Rt3DIAxaVqA5T7r28
Message-ID: <CABFDxME9Zooh7zAjgdui7r2mNa1V0+14YDKs2AN0BCub30GzUQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] mm/mm_init: simplify zone_spanned_pages_in_node()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 53j9szcwynweqxwsgs3exe7gpcx9r5wc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC5891A0003
X-HE-Tag: 1787498879-976488
X-HE-Meta: U2FsdGVkX1+MplW9+oMMWNfQ804nPb6bFEqEXq7teGKFlhZQpIBg5Fyd2qv3aqJsAmfFUTFH1T7x9TVY6IFdwIoSejbASmATakcTuYFKiCIJT8FircqegTlqpqt7WbvBh3KWDKAVkllWeianFAfuQ3BmmemFYCLIrT0AdgRiJ1uaWdxPNLB2hPv/HyWT+kqYf5Ep0xTKFaZoXxkPEkrGeAgZKFm1T1ZUqHj0Mt5nhxB9kQdVOmtxEL2aiPMtS4GbFzqdPrUqfzIPEZTeQpNzTf7KX/VB74TvHzhI84GjYiNRgsHHG9IGaRxqFY2fMf2zEKSTLrL5XTaLm2HcBNTaWzI8b3XD12deIjUIH2CB5308zaC2sAgmIRlFs/l0drdx8vd4kzz2lxTifnXcAkXnNWDIN1Rysx4kJMqceNqrSrkyZqJEbNYYe7bGdltyXEeb/GmSVXlcHF0QFO45/+fnrvafhlsuMaUFHCZwLK8B1DGLqAP0cCXLNUmbuE36/ikPrxzU6Buh4cxfG/cW4R5Jitt+VFrouJk1gIIfGtDlX4gGiFxKn+jUANRk/fgXea7Azvkl+CF+9s2NLmXOV9LIvFv/LnTfZuRUgXiPir+cfHAlLu1FlkVPWSS2U0RlzrGSQOQxaypUDPFjF/8t56MzZJHISCqGnLU0GOzIlyupVM8aQS3BJqznFTaZHLPaqb0fDsils1Okjf+oNb7EtsJRLyU6U54MlTHJmPtxUmwBcX0BUy01k795DFsE/ni0mbAmpKu4z3axTLs78uA703QY0iJ76kpqVAljn34RjrhSn5l/rNrpjn8+uMUdKubQ447XC8S7L07sbUXxCQlcA8XeRqLutg8Pwj4c0r81g7cpsGTLk7JZckBEgOHmkoGGUlVCrmDEOhyRHaLwHVXAZbQMhzPB+eggtBEK7iZvfeSfHnGltsbnlcFvdJFYvB+OzelRK8k+LFUgENwf1SVN14M
 UNSdQcCO
 j75z9ZQGlmvU5qOBp+aCAAO9wrGE8W+VD9uEfN6xPsaMSX6XLjRTHXy9a8zmvQn129e0yxn8vc8dhg9E0MQhQ9NicxTCF98Bz3LBRKepx9S4xrJqoixwNclE4mlqw+91lvBJI0q6nboHa/0BEdqOYGVadhV2bcWyjnf0oaecvRcxlYT/TtRnO8Z37E2+o0MeixMVbk09T+9qA6uc3cHxovniVNc3J/86yujvKSn/rDba9hbbdF86/NoYfGwphgWQRYUxr/SAFokO0B3CTh6NEKNX8EJRgxmbft93xEYKYCsEWRakZvEcYnHVOPzqZ8OVrf7KjyzADeMVK2U88n0w237mhwex4doa+KjzwKiBi/zcCJ7nMe1beFwch4d5/dZ1LLbtFLghJ4jgVpoxIEfzpOZBDvzIfl7PMYj/trv1xLA+riqf92XE5QFh1amIqp/hGZrXhM3fIvKHszA0lvvl9VEbrmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Sun, Aug 23, 2026 at 11:21=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> Hi,
>
> > Hello,
> >
> > This series simplifies zone_spanned_pages_in_node(), which adjusts
> > *zone_start_pfn and *zone_end_pfn before and after calling
> > adjust_zone_range_for_zone_movable(). The helper adjusts the same two
> > values, which makes the code harder to follow.
>
> I'm not convinced that the result is easier to follow.
>
> Indeed the same start and end variables are updated before and after
> adjust_zone_range_for_zone_movable(), but it's clear that movable zone
> adjustments require this.
>
> Having the same adjustments inline forces the reader to track the exact
> range comparison with and without zone movable and I don't see it as a
> win.

Thanks for the careful review.

Fair point. Inlining the helper is needed to remove the updates that
have no effect, but it might make the boundary less clear. I'll drop
the series.

> --
> Sincerely yours,
> Mike.
>

Best Regards

Sang-Heon Jeon

