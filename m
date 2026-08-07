Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71264C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA4B6B0088; Fri,  7 Aug 2026 05:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357F16B0093; Fri,  7 Aug 2026 05:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D506B0095; Fri,  7 Aug 2026 05:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 001A46B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:35:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C3571402A4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:35:38 +0000 (UTC)
X-FDA: 85073965956.18.1163824
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id B774740011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:35:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dQgXgpQr;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786095336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ikUEXbCxj3hayBZiXKMC/GcUDL0sztIe9+0w0hR5n7w=;
	b=2ooOZV1xxXkSaqT3x5UE04ETddmzKemwtsQgNLGdAkeSaO9L0gpYNARaidTjjeCGfXl/In
	dBpFHf3lPdaPhoS50X9LT7B8b3Q7d/+T5xIKy339Sy+wNSYcSMXfir2qErx7DXyLJa9bmH
	boGn1cpSEDCl18YojkeJln5pFBeY93M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786095336;
	b=bfEi3UF/jODm+KTqRb8EHI4OuFJkrsbjnNihCEvhkVKlpCmUxBoBqOemiAz2BQ3mjizJM7
	TtyVJA/QWBYVlzPAu1RZObrgi8qtGGQZaJDwzA6hYPRk75n/88tlE/ewUZZ0Bfk47TgpGq
	zLP50ofYlE2P3P12RY/cienuHemXdYc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dQgXgpQr;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38dcbade417so2614340a91.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 02:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786095335; x=1786700135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ikUEXbCxj3hayBZiXKMC/GcUDL0sztIe9+0w0hR5n7w=;
        b=dQgXgpQrZkRqGwGlZTviLeK+dECB0EvK+6futXNgI6s5ZS8KjsmaC9eQv6JG3KIbYT
         6EXvdoGgorWPyINluZiDM926B1YcdwYg5kYZcVCTDt6OFIJR6eYO7lHnjIvan01AgC4v
         3EOncgQWR97Mp2cE6LXXgjaar37haNQ/m+4If3RfcEvUqNPvD/Jp7aBpbVRJUqqyu1hw
         eVPHeRtotci1i+lOY7BMf8L7WFT/lR6YZyM+474oPHDTszpVQMxYb5MzjLldpNEN64bc
         5/Fz2G0WJjRf+5EjG3yzVLE038IXNDXJMqlDy0fDu9QrVtJAhhQ7Hb7U3h2mwSITy3tw
         NTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786095335; x=1786700135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ikUEXbCxj3hayBZiXKMC/GcUDL0sztIe9+0w0hR5n7w=;
        b=OAPgkqTDBr/+MoXi8u+hP7rR0hBtxsS4cQGlpZjoBdAhkEDBmrZVJLiYGAS6ZoOh/L
         U6rdHfzcshoSS+doElmuCyptb97FUdrd2X9cGK/SBJxbrfcVNe/Y+XBn5CEt+7oN147P
         wBAx3PCrBIwwEScn16gY1WQSNxSj5tKKENyNZg+S4PlGyOWyt8+ukCStFy924Zy6J+D4
         JXn8wpWXlTtokR+NjysoopWwHSZ8sSCRvRadZ8tc0xIEODkdoYfE9/N8nxS2z40OlQju
         MyoQbmLZSkPCqMo++kLW0PKgXfuIYEaSlhnz6De5iRQL8E7EaeBVpoFEyPjLXd/z+wXM
         Hlhw==
X-Forwarded-Encrypted: i=1; AHgh+RqLTR1by/zZ+UNI101bB97oqq4xMUziWv7QW0YMcG136w2U6YVqJvNub6r0C4q5Gs0A833zfvDipQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3g/a5YOskkDGXPRBpw3rlwKClr72WQOVk7133cO+jBnrhpr2M
	pSeOysah6Ci2ZbSiusYBbnq26B7rn1HRLytfGEcx2a1OPDkztjuoin2HQl0ACA==
X-Gm-Gg: AR+sD12t6Lvjm3SK1mWYC5ckSL+9y6d40h94nEJ7OBUtc0u14x8oZWVvY62/bB1qRub
	yRADxFBWFQl8AHPr85DD2FF4PnaC9J85v1tIpuD3p0FP3a6JSAz3r+uO9cUcp1qO8dKg5vV9Bsl
	PWxDxILr0lSYzhs2gYnfdE/j3tSkU/Z3oWeyeb6Bouli7Yo3sw7OS+nq7o5yspZSRpqFTbaB3/X
	nth7y9d7juj40G3davNE2sWHrMgNbAYn7QXM7ogire5lTRUaFkAklfsv2LpXutxqyZTPeG5Yy6c
	qPJ0R2EMqiob/CgAMjPivFbyHuon/Q8s3D8WTlxCh6g7VPuPT91JwN62nyS3y39CF7jURBn9SrN
	vefUgb8louWMPkTjJjbkF3AlElnN8sJv/2230VNCY9cUtmJ6W5awKX4CSA+VD5W8g2jOfv+rJrP
	p7UkUbKpqP+MdKwj56ngaqgmU7tgXKy3MRt2zCUuGxjAlMh+rWnVqMzDFx1wT9Qp0c
X-Received: by 2002:a17:90b:2590:b0:38f:2168:b9cb with SMTP id 98e67ed59e1d1-3903c572a05mr22075654a91.9.1786095335499;
        Fri, 07 Aug 2026 02:35:35 -0700 (PDT)
Received: from celestia ([2402:1980:935:f4a7:6f5c:e816:9aba:2090])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm1604269a91.2.2026.08.07.02.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 02:35:35 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH 0/2] mm/damon: fix nr_snapshots semantics and max_nr_snapshots check coverage
Date: Fri,  7 Aug 2026 17:35:24 +0800
Message-ID: <20260807093526.183009-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B774740011
X-Rspam-User: 
X-Stat-Signature: uxsca1cynpjp4y6ac8mqhognajoso3ks
X-HE-Tag: 1786095336-85465
X-HE-Meta: U2FsdGVkX1/pPvhdZUrHKSYHDnIoGZPYFfZeo67lYxCKzsy5XnRgJPpqSQx7Km3cUfGEP5ZqHacny3CE+K4NC/CLWaqSmOWLzRtLyQggCyHRyQWhCGTUoJ6UPNDQS+IZBy6/uxT12ZMVUdlR9YB2aAXxmDyCGKqP9Cq/Ao+XBzJEMNID4oGNNQFA0mNt6ljZbLt0LDzFCznTdrwW0aGzC8wvjLRjoMmxG6f0cKG9hasLYx86p98WOHynG81GTSNYBSkdnMOxbP3h3ZC5Y5DWV6yawhIHSohrIJ3TNPvbseVpLKbM/LEx472ae5SJ1pML0ugXz8lh3Nzb2lu3fI+pyjXWRsYDBwM/9uILEfW0naJ29FEoZApINi65t/WFNiijnwWAXBE7XAEywPeBKSR1KykTEjNPj8ek1i8j49NWkSzqEBuAzDoGlW3sAgFsGkolY0KBG0+Gqznbk3O2muDKks3+MMNMhcuSMbgTvf7mkU7Okcywnm/2v447itw8SBX8D99yKYyeVVhojY0ukhy9UyxYtALK3Bd2iTOrGBy9EtUXAVSpE1tBjPsLMwCQ5E1CjprhZ+pFCBomhauGnyH4ZKPUTEdmRYV6wTQPZFhMwY8WZ3zQJ1w2t1xR2XaHQ9YutUYcf26OaUd1dEU0Zys1mDOkziV89nffo/f3sIgZtQUhRBfkHhU4jaKg/CIW02CcpYXGz3GZT1VEuwOJArt6E8yo3+iJO/chinrFhlhLGbsZJmzHZIy0xqWdXg00GFrZ8epnMXj4dEQSlByPrYjlAGZXNCSzWFyBeDt2GTIdwXXOyQ7xFa9+LPwsB9nx3yl33J4O3ytzXdddR7NbIqefJu7l3tgfMpqR3uuxuHr+JLxIn3K3sxCdX8HJsRqTAg/GTQxQ8QI6IZe+Itbl+WeHr0u4cboYScFo9EG+gn0rvbxBd0jsH4IJxH9cmEK+cjJ8OUOsLMw3JWumIg23kE/
 NRrdrkBo
 t4IruBPHm75hbeRpxeRJEfPjMrRPD2enBW6QJpedV/h7KKdD9bMfT5vZLUqJBrcaIwmUQWVN3Dnj6hRzgOrpMuBU16MYIiUILG2EddHq7yTlFop7tFBG79+YRbS+eMndBsGQt+kKhbZ9ZFstTVPr8om0pV81UBl6obfg6yZ09Ww0LVU6hBIlq1FptMBIMhGBdR+Y4RZUq9y/pjtz4gLVksiwb6YXwl0uEmc6Hlf8La4gIbDdZVhEOTL+2adhJpjsK5e0mCWCtcnRA6jeTAXKrV5BAJzrw6AhTmLBReHMK/7PtwQaoPSIKMBHnSR8WjGzyikNrQH+pSD3QyGttaeWGArQ0pTo7LqbS/Z/56ElBXTZLOBsJaUTMN3oobn3xJ4xmzculbmow+PCACWFcp1H4gOfBouvAaWrI6VHfs2UsHzhb0dJ+BAgDBV6jpMcsQmIyQRypS07ZM6Vxg0b+8HZz9QbUglprGog193SZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both patches address the DAMOS nr_snapshots/max_nr_snapshots
deactivation mechanism.

- Patch 1: fixes the nr_snapshots counting semantics.
- Patch 2: unifies deactivation checks to prevent busy-loop.

Note: Patch 1 should be applied before Patch 2, as damos_is_deactivated()
relies on correct nr_snapshots counting.

Liew Rui Yan (2):
  mm/damon: fix nr_snapshots counting using tried_applied flag
  mm/damon: skip deactivated schemes in watermark checks and add
    fallback sleep

 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 42 ++++++++++++++++++++++++++----------------
 2 files changed, 28 insertions(+), 16 deletions(-)

-- 
2.55.0


