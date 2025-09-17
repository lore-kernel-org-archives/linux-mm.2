Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D28FCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A525F8E000B; Wed, 17 Sep 2025 08:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03018E0001; Wed, 17 Sep 2025 08:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918B68E000B; Wed, 17 Sep 2025 08:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC5C8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:00:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3090140533
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:00:48 +0000 (UTC)
X-FDA: 83898600576.24.F9657A0
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 09762C0013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:00:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="IdgKmb/s";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of glider@google.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758110447; a=rsa-sha256;
	cv=none;
	b=1Px3yk4CpGmT5g6ESmunCSuEDMlxH9pRUW3Mukc9pjg79wBkYJ3L4PioiV6hsIoEkmqrTG
	k5TnL1gBnbLydjkTL9dUSwvq5r3tL2Mnsealtwo4EvNMGb4GUWBEFsKCDQcdzH/v9b4Diy
	vQ+ZPYbSMjiJsP+L3zlAdOqCgk7MXC8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="IdgKmb/s";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of glider@google.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758110447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UACzCyCSXTVYBvNeF7X28zPTXpB3Pxq8jPBy4L814NU=;
	b=gMcOPrnoTVcsE7JlNCuOgLFRyB1ZPiKDkAufP8mvOgO/hOjPdPDtpZKEnmvm3ZjCno2kiu
	sd9DWFEdQezsJ4W/4lFKH7SF4rNSW5TJqA71JkUq7vf+oSvofx0IZDAr5O0j5z1Ga9273W
	sdsap1ynXCVYEnitiTq2el2ucxfJRHM=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-82a334e379eso217721985a.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758110446; x=1758715246; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UACzCyCSXTVYBvNeF7X28zPTXpB3Pxq8jPBy4L814NU=;
        b=IdgKmb/sPbJ24ogbw8yWBxM1OCJYPH9YItm/AQWmuJydhxr6lfe0X6/KRAyjpMgrQb
         LM5GYGqJs+TUQE/6UgmE0WLuLAojL1bjiD/bFfwOhh7kruLOM2N2NKEKK5X1YxC6v4dB
         bA3xn5LFNytRLE7SQgOx82cptS1+2jJjjLaQhiVVrmrYkCJu8U7qLt+rwxwBwSpkw2bU
         S9qVDTFk6YaW9nhHP70Rr4DMzGiestGmt2Gf22wa6q5HiTrbhO6CcEHR5z3E9Nvxmkdk
         87iIOKXGPcGJHidCFDcSrAlKQ33bXOR2inf+cVuVxcIsQEoSHOYwSprmzHjOoUazwN3e
         yfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758110446; x=1758715246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UACzCyCSXTVYBvNeF7X28zPTXpB3Pxq8jPBy4L814NU=;
        b=DKhykdJ3hU80QWC7ZcOIT8jK8ZlixSDKOTccumhWQ2JElCwrxl1qQWr3Z6VBwUrpzk
         elg2WtQ3FHnbS0KHdf5bkC6t+xg9o6eK13Rl1ymCNsEU1G/slEcV3snVZ09B+rgUZEaL
         T54u4HggJnK/wXtJ+u8+xyTLCCzcF7jruP5Ne8JFmsiAI9M7EMWULR4fOC8n9wrwPXW3
         hdl8xr8aNQ0bqAXacjO/uF6HDc0MjApxaPhvynNbTaoCAMwxjpsg5TIic5EuR9ecJKrY
         Cy2Qldqn3ZYUeGVY9dwne5THmVrGTT8+2pHcls+DYe3T4mjrzLf4u0Ey/w9g6lqlwuFs
         EUWg==
X-Forwarded-Encrypted: i=1; AJvYcCUthlY2R/UEZ+u6mE7EDXiJpTJ4XRpOXNvHJ/gCnPEWrcHjdwGPBwWzWy+l9cGmX75GcIyEl00aFg==@kvack.org
X-Gm-Message-State: AOJu0YwnuW+0dHY7kLgMK/TLJAqAo2Mq/bCPdth6NBhaa9kbRFXHBu8h
	bKrCLWyHg91pyG0NWMqSeYLvBf3zR6L5V/xnD3th6YAUS7qbAzPlMgJou/1oT8vElFQ8iaTitfm
	GjbRMRxnFgwr3h5GTlklGbBZpA1Ns+nJGOwf1vJC9xk9LhPor+88sqcIX
X-Gm-Gg: ASbGncsZOtxpQ0jAEAJGwHU+Eb0baSmOc+hRJhkEQrKNNTgYo83TrVoMUGzRpv2nBHr
	QOHX+CaeuTVcSkwsL/u9CIgceNImZ/bbikocWqTBRycp65gqpCd2zP/sreowqMDyeQf2HJyqxb4
	azJwpr4uOJZzAM9beOAIbeZiTy1leMwFWAspCIrhV0CitE/LnnQw7O+iHcZ8UVzQOuggkad0H3F
	DP1oCkyQdTfpYUQknLAmP5kuS4vSXU4QnDhf1VqBhV1Sxh4VPhtMg==
X-Google-Smtp-Source: AGHT+IFi2qx+SqoMmKRMqMGkU7Xf72LnqVBf+klCMXxy9Vl3NbBq/DUX1CkJz5/9rL9yxSkwTjws/YNZrMMfibuG3tE=
X-Received: by 2002:a05:620a:471f:b0:811:5849:656e with SMTP id
 af79cd13be357-8310a641767mr177796285a.35.1758110444753; Wed, 17 Sep 2025
 05:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <4b2d7d0175b30177733bbbd42bf979d77eb73c29.1758090947.git.leon@kernel.org>
 <20250917112242.GZ1086830@nvidia.com>
In-Reply-To: <20250917112242.GZ1086830@nvidia.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 17 Sep 2025 14:00:06 +0200
X-Gm-Features: AS18NWBOKXsu7wnGTnT6zHPRB3malyIoD_14jKNdkoZmt_gqP0U2UlyOiEpbgCA
Message-ID: <CAG_fn=WWw87a47aqXFBK1YpHAFStzpoU01CJTf=Eut2FgVTkMg@mail.gmail.com>
Subject: Re: [PATCH] kmsan: fix missed kmsan_handle_dma() signature conversion
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kasan-dev@googlegroups.com, kernel test robot <lkp@intel.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 09762C0013
X-Stat-Signature: gisu65dwgc1w3or9pjj59yjezxzh6saj
X-Rspam-User: 
X-HE-Tag: 1758110446-59688
X-HE-Meta: U2FsdGVkX19qzu65+GcHUtkDUoQHgabRIaQSrCBL9laBmNRrPP2lcFc4ZaxfZxgUCMFYt8Umx78iSq4ZKhabT5H6OX8F1dd2r5yF+wyxB9ahGNxaxxBAraCT4PKVbYdFB4PGuFzyIDwtqAz+E6pEp9VCy+J8lBQRmgLVQpzkLQWguLRF4/fuFfRy0ZG8hRiJkVdkIJ2HJDhmsat1VK0ZIq1mpxvmH5zED90EnKNHfhadGZ//R9aqen75P+o3PffP+wwJGTE8tmFDnZ8KhWUG0QiyQJQOTXTPDu5pMxRhD16suwZonRjup2e0STnKaoOo/kjqWlejOk7s5drN/oogC5mBSGYjCtgksHfYdoGDnFhcuCkdUNFeK0sjBdYc4iO43KkZeJeDPvLgrVaVmjao2iBmprP4QvRImdTIKng2BKTEH1UjpkAjV2XyklJLZ5PwJgHKVSYNR0ZFqBIOvUztnU5vmVMULfnF3CKoevvLNA5oSOZm5zgMODb2kIcQ4Dz/zA/mzAuMR8llW8DsMXC6zeqvGITQyvZnqR7tCMGDaCPu2zl2QyfE18U9llz9815MFABAl4uKB45UfKOCmSo6gJ2dN3i0OZsrxz/vsNdlk3wDdEzUr3DSfAp+pOR8K7DScttB8BamQxJ+fw+2xIOTCZxwPPGc7SgLBTIzhH7zBeCRFuS5CWmdDMquZ6n0hchvfSKH9OwoJzeYBV4NCnKWVdbEpVeAE6mucK6azzgo0niv/Cik5PpC1SYjV+HYgEi4rQ3oJFYV4i9e3g4niVUNZD88zMTSW0MLFn7sl/86/af0TQH3ia3GIBnbNc8vzvjlCQmmnQjTSYPKlFm3bQmiwPxnVV7OXoje40fnO9NeRix3QbISO8RIUbfrAidmgQzZYo0A3I5wva4Kcf/ACsjJKqCn5HPA1C97uoLP+stTZ7yDV3AoTAU/6srlkksOAflVZ5L1dL1LRIfTBVJsgNd
 R11QumHT
 vul2rdHShAsXGlwi7svxiM9Anfz82Am8T3vd9J+tgVM6y15YnJtzdJcTAtA01HePWCgJC2NRcfyCoYxNcJ9bjJDF24NrOAn5yevpLFc1oSCurPZUbfiWNrp6j1eHh/Sesupv1QeeY810WoWpxlrw3c/aRPgbm7F+az2+MmghCTH2SlNBk4ZguDiCSBf2eclwx17wmeOR0oFLK3/G6gr+ParA6P/CuCtOXpGqx7M+IhgK50jays0npFGHM2DgP3W7whbDYUdgx0AUI8wttk8kteYwYvoxKExADvaFAxl1PrKdhUoBhF9bVreMRpxtt8tgi4v75BM4L3/Dg1+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 1:22=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Sep 17, 2025 at 09:37:36AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > kmsan_handle_dma_sg() has call to kmsan_handle_dma() function which was
> > missed during conversion to physical addresses. Update that caller too
> > and fix the following compilation error:
> >
> > mm/kmsan/hooks.c:372:6: error: too many arguments to function call, exp=
ected 3, have 4
> >   371 |                 kmsan_handle_dma(sg_page(item), item->offset, i=
tem->length,
> >       |                 ~~~~~~~~~~~~~~~~
> >   372 |                                  dir);
> >       |                                  ^~~
> > mm/kmsan/hooks.c:362:19: note: 'kmsan_handle_dma' declared here
> >   362 | EXPORT_SYMBOL_GPL(kmsan_handle_dma);
> >
> > Fixes: 6eb1e769b2c1 ("kmsan: convert kmsan_handle_dma to use physical a=
ddresses")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202509170638.AMGNCMEE-lkp=
@intel.com/
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  mm/kmsan/hooks.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

