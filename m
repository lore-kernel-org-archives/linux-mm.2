Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BEBCDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 17:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39186B0088; Wed, 24 Jun 2026 13:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9D46B008A; Wed, 24 Jun 2026 13:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7AA6B008C; Wed, 24 Jun 2026 13:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5766B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:44:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A0E6167358
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:44:14 +0000 (UTC)
X-FDA: 84915530028.04.0A93822
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9508F20008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:44:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=INIowsus;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782323052;
	b=AfjZgClD/4kHvTB+QBkos/aHXVxsLizDo7IWz2hj/QAb0mhflj6cmDg3ZqqlCSVzka5t3U
	IXj9sdDdQnLjGoEO/MLShRPw/9CiW+dwKxKaqFbhdoJg70PP0AgkZ/JlhVNwi8QfOLxCSU
	jGAFhr4YZasynCPKMH1fA+BQc32siXE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782323052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weueNemF4YAIrNesLJk1H5sOijFILuFNW+H2Gcs57eE=;
	b=7HuY9UOjCQ3T9C6xwQ4OeA95V239UY/YaT5Xm82uHKdef+RlOiZEoUiGwvau/cq+VhxWqH
	z18Xu/jrEmdps+GfH1TuL00ymF9xFiI39b+MfQfCs651+V2i1wsMhA1MbBd6LN86+4eKk+
	pEW3AEOqbglivKW5fxmr6R1pIvUAhcg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=INIowsus;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490ac357c55so11670755e9.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:44:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782323051; cv=none;
        d=google.com; s=arc-20240605;
        b=dmbztNmWxfx/I4XsKYZRnP6C1d7fignq7f5RkmCLcVehrDOqwzAqoejdIXcYaFMkoB
         AQW+5ZVkScWmiM9ppaxcBIXzz5BYyU2dnb5J0FYHVGPEnwSUtxLpeplchUAxjYPcb5RR
         uU7/yQDnhuFo1yV/Zn1jeu/BR4Uv1/YqnifhA93tmi7JP/J5BxW0TNYtB9Ix+Vy7Rp3M
         RpqTPauLIJj1KnDHnn9KyP16MGKBx7OGPlG4JtvSIf/+Es5BKDmgSQJAP5GCW7yPcMyW
         SVS8kD7xPzHiZ+pz39qZbn/oAsY7fGWwGgPrhy9v+FdYGcbGhe1iZQcxCcQu5+Wl5PfA
         IR3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=weueNemF4YAIrNesLJk1H5sOijFILuFNW+H2Gcs57eE=;
        fh=A8wmeYiwzFygRbT3ba6XJUt48iiPStVB/lHzgzT0X8o=;
        b=YWTonSG23q3jcAzznCaxFpBD82p/jUxi6AaQ0ogYMlfQL9ezocGVISaLdqIKKfb041
         mj/dsjXEx+jafRSZcSD5L7NOyA++ef+XjRfNOGpZktSD8BoQbIIWqlFiKes7As2Ujor/
         NCgGwXIOfE3yyTYqjOWZBMoxbXNFwEVM1dB+RmV4wklHePWgITSHou64FhicD9bIJ9Hr
         NCLvPAaxxmlfYHGrEdkYVJvPlafN9PPwKP48mLN8RFTd/9VPaqxDRPxeZf2phyyLppQA
         5OzsjrpsTfyFMu32mbqrYFa++Yqq0mhP6DLMjokq41dVbk35t9YJVG+OloQRnziyGIUq
         RkVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782323051; x=1782927851; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weueNemF4YAIrNesLJk1H5sOijFILuFNW+H2Gcs57eE=;
        b=INIowsusrQopzsHejPMt6dZWY61VDxdIH6EcKGNuQ63Gl+Xt81aOshdDvuj1Db/sXh
         WB0e/cuGeRFlZ7Csob0aG64uVb5GBNM3xbpwUf4Nf70ADfdppD/2ekev7y6uAn0RLbax
         DdZ7OL0E7q/8XrdK2xfBEaapM7TrhOMXdTZRfWr8WXsCqlEb1cucnZaXOcDbwDeg9Q+l
         oXL4rOP8EEiw2gsQtkubsSvXG7/7LR9m7u8tDXe9AqXrz2PCWzH/HmCL3/ooONoOObHM
         17/ZJxWAOA3uAiU2bHWi71iNhM23W2v4IViKvdErM2ozBg2Y4gO12/04i4Tgoe1H2ioQ
         Frgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782323051; x=1782927851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=weueNemF4YAIrNesLJk1H5sOijFILuFNW+H2Gcs57eE=;
        b=R0fGW9J2hUPE2A8rArAbX4cD6LJlrBvHck/zZfRBJSg//Lg3yf3KewIpzm4wK0y94u
         U/owBBwPd6Q7H+dXv5kkp8ViSbTr+OxSmkSBE8A+n6YLJ+sIGP03zcuDyZ3bFql63UqT
         KKegY2dKwPagbr4CLeu6jy1KU7O9NtailWIYRXiUKxM5lB2UJuPc8QXaHzLID6BqlzCC
         ORQWVwMFJ+jYq8xIKSH8l/XRKDtLq16HJUZZ8E4szTCABNI62LDNkqNR94cVJEVmlviO
         AtRuHe6TSKV6bHgGu6tNHtrLsQr1w8WtGKkJb8v1Tl1imL2Pc35fHj66pPizNCF10Hh1
         yqpg==
X-Forwarded-Encrypted: i=1; AFNElJ+iZ/u7eXQ1OG9O+WX8kv2O28/pUQq1bcjdgozKLtBbAkFgqpS4ACQfiWFPDu/y9kSRW/jQrre1FA==@kvack.org
X-Gm-Message-State: AOJu0YyBndnnjmA7JjAfuVLKx9QLGtHvnMpVGZF6ST6QncBng9sYYAeR
	h8gxg0SojDL1OhjGWGNSNm/U4x960NN8HIcyfNk4cAeP4RjQfz9CLrm9Z0/uqfWo7CLzwzVkEZS
	iX4262SRs0juvLL8+YxYmpG8/jaYqej4=
X-Gm-Gg: AfdE7ckI/1HPNnzGeFZ15rQbJd9kpvz3dYmZVwI1xSz4/AMP9ldcA/fPn30MBdsK1QR
	blcLaUAysho6vi32MJ1+rJXgnS8rTcft5DAcqIcljxJXweXzuJfCCc5NwUw/lKo737N/P1AbM3Y
	60xGrhvBew/hPUf4yUZUs6nEs7wKpUdsx156oeLftYVqKq1iF4wQVRUu8hjC272M52/LiMBvlhn
	5zNQHwdJI2TLXUWoTQGif7q/vEP7F4oc6L89Rm3Cmwtciq8pmEHlwWNxfS6olHXfOpEXKH0ngIi
	1P3/JKflaOI36keNwt/ZfcY5dFv/e09DagC9jxo=
X-Received: by 2002:a05:600c:e548:20b0:492:465c:56f6 with SMTP id
 5b1f17b1804b1-492608473d4mr47255735e9.10.1782323050460; Wed, 24 Jun 2026
 10:44:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260624075700.751467-1-alex@ghiti.fr> <CAMgjq7CfMp_7bhDWirUmxM0pFzk6d9in9h6wuHsMoeUu-+TC_Q@mail.gmail.com>
In-Reply-To: <CAMgjq7CfMp_7bhDWirUmxM0pFzk6d9in9h6wuHsMoeUu-+TC_Q@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Jun 2026 10:43:58 -0700
X-Gm-Features: AVVi8CdX31A5OnfNfWVte0rNfT8hGWKh7AlIZOWxeGAf0A6rtIQoM9fo2-2bnUw
Message-ID: <CAKEwX=M4A4kAFS-Fb=toAK7e=mseVc191_2r7vTrMiJnyT9+wA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Kairui Song <ryncsn@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	yosry@kernel.org, chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, baohua@kernel.org, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9508F20008
X-Rspam-User: 
X-Stat-Signature: qnodxe47b1f7m6ch1gu8he1j6s49qknf
X-HE-Tag: 1782323052-169042
X-HE-Meta: U2FsdGVkX198CcMDFBRjidVP0HwsXJ9T78vA1NgrHbfu0mAgxwV/SiuyMhV1aSJgP6MhnqNmCdnglsCdVOvrb1+ET1lbJcZNTZtQ6RG6Tp7fpODFkFh8xZaW0AX1bnb6SOaahUgeE6LlkhnZqb+huMSkRFF6TohMVmt10aUa8qNkvjPrTPPbP6lkFcHzqh+xlfRoNwPVS5HtHmETiV3J68/fphf3xtW/uKFyrhr8sxqCbs25NaNHcul5IZMHVCJkJgcCbsD8oyQ+ObuEHe0JOg4/5esnu3VXzQPM37E6eWB3YF2SghQa5jRSy1PCtNSFie48kMgxG6ZhxJv7zuDzCcHXr6mosPDbiK8hCks4vvuw6YdPj8JcIcNimxMClW/XCjnDKJk8X9TtGzqn6WFM5BXszw1kHONmZKhiSlNUvWGweTh7W36X2zt3WZ22NZ/RVlHJqFoyEs7FeRjVheHsV+j4VLlHMeEiWjA3alp73p/cSFqCyRCSdi8fznoZ7bkURcBMiWeYn/8YgWjtNpBNJqkhU+LzWi2J7exMpPqtsLZmZnHK8Jap88GtxQCwEpbTAeUtv7KnqVoWt/JIvj7dbqX/ScVMdMhH5euHrdTJBrPGr3+zmUrWJRElbtYkjD54i26emDfw4QtQzcH35yj3fTF7ZjFZsu+eMriEIs62COkjVTfOc0zSaVp+7K7zwWp0sF/DKLNR4+3ZQOwN5C5cGSDs54MjwVScY4hvVsboIV8onsuJsj8LWScLsVc680exj2dxrjlxT7dt9iiY18jyr8sOc/HtmYNQADphv+mTkantPsVzvpXLZ2Eq8vG2SpaVAMOMy+zacfPjc9GkhN6oug80DQ1ykeDwNRXUiHnOAfLsvi3/kYIYIz2o3pk0jw+aiKRW0dfls8LPWlNTAPY6sbzzPcrQDDuCLnIlr1YLs/TFGIsE7OQC/Xrui4TRqXh25czvVWv7DM7Eak/AL9/
 mkpAiB+a
 EkrUSCT5k/UX1TG4wO1u/JGoyWXyQJZVkOLObebTVFukuEF2NyJdfg3OKdqMWlG6vCTcjBPDK2JY/4QRZZun8rXDr36Sxpowb+6sEcnXfcf7Vdnq1knb9rVjDdyaP6BeHwfFs8MMjzYeqRxQtis8GMmCOxtwJMHyGDTpfgxD1Y452SY+3a5/zb7jD1kP2aZnU+/yx1EIKulsCsFRuUU/s0hlG58FQ9Otf46eghxOfDdwmCN8y0/3mDL6685vqY9YBHH6pYUuGjObYPQylnfiEaDA3Pl9MEBOu8lSaB8BoVoC+muEptIKsQpDyZQEugTYNSHLYlQ4R4n12/fTk10Pb5B0WcM9xuoGjTSyPlU93uxV+yqzmdAZPtcoz+s/x+zd5Vmg4hLd8TZkvaE4jwvzGu6N0lNAa0jJ+rwHFVVf0wnz/Yet/F9IRLO7+uMQkNxZ+F2KtFJRZhnFqnq+SmzcLyazzztQ9yBSFrW9u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 3:31=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
>
> Better check zswap_never_enabled first to avoid a xa_load if not needed.

+1.

Maybe also xa_empty() when we're at it? :)

