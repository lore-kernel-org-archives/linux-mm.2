Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E30DC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B01D6B0095; Tue, 11 Aug 2026 13:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287C56B00A9; Tue, 11 Aug 2026 13:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A216B00AB; Tue, 11 Aug 2026 13:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAB746B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:02:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69C3214013A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:02:50 +0000 (UTC)
X-FDA: 85089608100.08.8B8E660
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D910A0014
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:02:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pzN+IxN6;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786467768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkZaIE/vnqQhC836hZPxdvhdVxGgfRhensvVVjTTADc=;
	b=EqTEPtS3V0vCSJnbb7S1KhqLuFmGIQrlNs55Vc3YRjVCEy/uIpdQME59q0GuJ0lYsonPls
	tSKNfsmivV8ah6rl4El/vgV3SxdrGhu/7z9F4wBag/JBUh7ezPwgS2UVlppTn4y+TEpOXh
	0Ka21KINZoPMJAx8a7tU2fJUvo73FZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pzN+IxN6;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786467768;
	b=J+K2unvTce5XVJ3ixw4n1GJ7x/SFPq3AZ0F9QGfq8CiXeKgdf0KtrxXakbRiDrHL+csao9
	AKgmcCmEgKbpy+TZ/2EWZh8JkG4XDljZbpbPaXQ/0iZ9xWdQwGfkbiOaTCPn0Z87azINsh
	4SWd99dIpHnBPwEQDMpMeUOTREyl4+8=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-ca97d139d8dso2024507a12.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786467767; x=1787072567; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NkZaIE/vnqQhC836hZPxdvhdVxGgfRhensvVVjTTADc=;
        b=pzN+IxN6h/lvmUPKV0EpCFWSQnx+n14K5v9LtYFeCn812KS0WZ1Gro2c0Vhl8SrcXP
         Jv+rJMuWd+RJC5yoBQj+BuqgEoacfu9V5b5A7biaBtD2K+TGJRnBDAuB/WOLHl5P2OoD
         rXk8GIa7UZd+3xUIZSnpRXi8o3swOdLb3ir7Zmo5OzXgNAd20RmScPQkgNUlLGuf8j7X
         sxgqrlABbL+jF7/ejc8Y07ENesZgUpCsR31yk97Yu8qcfuNZm3WA24Hu/ZJru5r284Ue
         txaKfcgkRgJZc4y1n010CmdHpboJffvL40sjE68O4xEgCnvz1380OYLPzuRb38cVZhIG
         AvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786467767; x=1787072567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NkZaIE/vnqQhC836hZPxdvhdVxGgfRhensvVVjTTADc=;
        b=IV+G4gj/pxwbkcGZ0dXj/kOormtsrYqBr6YGf0PtgeXRHmo2ofHtju73kfHEHXm/YQ
         zp5glLXxP+TXZxqjtOZS99/wJDomLMzk/qrtRd3LxpdGJbAPBXE5976YaHTywgPIcZKJ
         CrloewM1aRu4i2x2iUffsnbyJNQfBniXdQUg9j/yUqKgaB7IiX7RXMmM6Z8Y2M7AH4AH
         V74Er9wWdKWDpc6NdMbdO+FEAYCbFKZ79tu7zHJFlM9vJ/RSN5c22l1Pt8i/HCYsZ/8C
         1ykrH8WEpM6OAtipzunqbi9N2bTXqB9scEFIaUG2jRWCpVtVyqSA1Hgnz+5Z8YGT5vMH
         swQA==
X-Forwarded-Encrypted: i=1; AHgh+RrSq97sKdSMRbMHHKEp0lP4Cq5mNsfZsh6GIe9uslkpggQkUZ6XJs5aBBm80UV013N29Ehm4tHLOg==@kvack.org
X-Gm-Message-State: AOJu0YzbijanDM4x/x6IyA646E62GBiTxpW0KGC8Z+khDAItRiXzVFzI
	Tt0CSKoGYHegXR/VaJNcA5CezXTTBKoROXCyTLoLWzEHZdOP1FDVMJAv
X-Gm-Gg: AR+sD10ddCuHsRjuTq6oKgzjujEjB6Az/aU9YxDRFtq7zXdxwM4vsupghM/tem24ENj
	vp5uYcNYtwAL50cautwL+Cc9nwhQIzN/ipdKVZ3XEsRRC05Bd2ndOkri82YEJErnbbvCxH5vHSS
	vEl32cQvzrJ/GviJfJX+1hv+4CR9T7ml0sAd9iESLKxE/bJOUikR7xKNKmzcLB9kxdBCHp6mitB
	fXTKzzMesrenho9nkrCNUnwiVKSm89tEuZedUjYIm/O682QzFoiJIEmW966G+MWQ4wpSqrv1rBX
	3W7+GArP2nkJV/IEHt8j/wXoTISQkfyllxMAr5pzmRaWRVI70pvNQNK2YdEzzpiddgxnD771VJJ
	dQVGHDprzYumgPNJgNXYd4t0/f5/6pt2Bc/kfB0tq7eu9CgVLDQfAyoyhYJWAEcGy3t9fxPWpHk
	5gpfKVKNf+L+OTZgIM09urTMoXAGaOjMyK1B8z/h9Fp9JHfRvR/C/KOJeZcvZfgwQ=
X-Received: by 2002:a05:6a21:6014:b0:3c3:8d4c:6679 with SMTP id adf61e73a8af0-3cc2baf91c1mr7030040637.20.1786467767243;
        Tue, 11 Aug 2026 10:02:47 -0700 (PDT)
Received: from celestia ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14124451180sm1073882c88.1.2026.08.11.10.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 10:02:46 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	liam@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Wed, 12 Aug 2026 01:02:52 +0800
Message-ID: <20260811170252.32705-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811135654.4901-1-sj@kernel.org>
References: <20260811135654.4901-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D910A0014
X-Stat-Signature: k8tiememnzzjyutbyhbgzwqdoobzbuz4
X-Rspam-User: 
X-HE-Tag: 1786467768-287125
X-HE-Meta: U2FsdGVkX1+kdmYMMlO/MCxwqai/CDFFVxsw9QqU3of7U9z8o16VJNH+ScNWNyVyBWOZgMwbM2X1ESykar6yAizll67qhe5WKlppuHm/JXrGlDYSr/8jmGpDka8FJXumJ5ioLiWy+UjzYJ+9xIJUTA0HFf+lKf/vYooCazCcCe2uprjmHkjzj11Kd5HGG+OnP9u8zTZrGR0WZfmhw3++Q5CczJFqDq4SFvxI3tXo3IoIFyjZ8akh5UYdbB9m5hurce5E6QWeGgcUHUmPI/O2+yjyexmxRcjftrkYVYcupuvGuAoaa2SXx5pfYOx3qlJvi8jfHLoal8/BVPlpl4i5AkFbGXdWU3w5OjKrGk8eLUr/bdoCslMyFnL0jyvLt2zDEx8iVvFXyPnUwRK80EFIUETGDPxJqeGobwK8Q23/tcbMUlSulw3XCuAZavYZYmVKgLVCTUs6fJimkqLQtL7Vekz8P/y5tLrxfJQSbjtavgTsL5IDjwfHyEYSGX2tf/OPynH/bM8sIpXjV0ch/zCOBejamFGLTvyx6sJ0hYfYqYzOuX/b2Fw9jTr345RYKiZkyYJaL75yFayxMzZdHhlNpwn7nYjK2qGLz+1dDlrHw5nqGOiAyojbU9KDt3B75fKtBxpRmmSdVWPqU/An/Fau5tOUvTZLtbz/z5IaytP70HeQ3OQoLhh0lBlOxXScnCELKuBtkPhCQWvtean6w6+l3AMIHANj47qv6DFRkfag1dkmWo1dmFFwaWa17Wu556hZSTl4XAT07dSzCHy/6NlclyKJI1lm87l20Uea5TNYpOIoZroVD3f1GbsTzJTcgPu+ZsqOOi2uR20gj0QzRJDrFc5weYEJ5LNf+0tr7oh/NJUE7Qa1ElIqiqUvXKfOBfBKhIf/iJT2U/+NM3jA58fsUIu6jCouUpzujToJCsI5D5J0oUBaCF2N1hAwe7s2DCa2qUZPHh4iCHlImrHejOl
 BrCr3zHO
 +2RQdP5mULs7vGqOh+akg4JuFCqF6jlXJS2gYiTD3e2jKmdfnDaUM3C2piE314yDumeLXLPUI7dD1LFMar4SxEpuNr5sj2OW0rRhPVIn3jg3qbL7sfO6v8DJN19lgsT4WQBpKOxQn/7xL9KFSId9fsr8Awqs5MWThCAS1bvelJKz1QaEW9GtRSioVpeiTU4ppjjgqdGjulWxhpM8GU8+aZqlI2PvuvBr2QhO6TqP1LgVdIHpD5WCKRyUu4Ae/MrSNGSsv/in3lYOu1g26GoItLhiHFFnPE8y+IJk6VoG5QdtjAkYcfCcWTDyiOvcdxnMKXL8QfoupPz2oqlfwKtviof5roX5a6P93dretsZOyQ7stJfn1874XD4EJ4tNySv0vy9ZpxfY9TVz9xQqGmODgAlHQGpsPap1aiwK7r6YysmiLceN5uFAaEF+FlqATLcbcoeFE8JkgVoW4y0sVSXcLFc79CNQDAj5Cz2Ycw0Y8ImiFAosMD91rxS229tbmTcJpaL4ihPK4jotXFItKFjAtm2AgD9YCSHK21fAEhrPV63KZ4c0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,


On Tue, 11 Aug 2026 06:56:53 -0700 SJ Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> 
> 'hkml patch check' [1] says you forgot Cc-ing below people who are recommended
> by get_maintainer.pl.  Please Cc all recipients who
> get_maitnainer.pl is recommending, from the next time.  'hkml patch format' [2]
> could also help you doing so.
> 

Thank you for reminding me! I will CC all email addresses output by
get_maitnainer.pl from the next time.

> [...]
>
> On Tue, 11 Aug 2026 18:18:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Add an explanation of nr_snapshots to avoid misunderstandings.
> 
> Thank you for this patch series, Liew.
> 
> > 
> > Liew Rui Yan (3):
> >   docs/mm/damon/design: accurate semantics of nr_snapshots
> >   docs/mm/damon/design: difference between watermarks and nr_snapshots
> >   docs/mm/damon/design: fix typo of max_nr_snapshots
> 
> I requested changes to patches 1 and 2 via replies.

I will make changes in the next revision:

patch-1: "tried to be __completely applied__" -> "__completely tried__
to be applied".

patch-2: use two spaces between sentences.

> 
> [1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#checking-patches
> [2] https://github.com/sjp38/hackermail/blob/master/USAGE.md#formatting-patches


Best regards,
Rui Yan

