Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F290FC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1610E6B009B; Mon, 17 Aug 2026 05:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111F16B00A1; Mon, 17 Aug 2026 05:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000E96B00A9; Mon, 17 Aug 2026 05:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4FF86B009B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:19:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56211A239C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:19:26 +0000 (UTC)
X-FDA: 85110213132.14.E7D1A37
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 74AEF8000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:19:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p4nNWux7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of joyetamdk@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=joyetamdk@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786958364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yf9pO4yEuDqcWQqMIIMbqu+zN00W3aXNegGKdZT8+as=;
	b=iM1kVTYeW74jKWRwXqxorKPyFNMh74aC2Glix6tI6kzITl2sdeB12Wslmx0ABFeRVit/XV
	ZTG4AP1XUsDwLBBreVlKH7jo4i68f53nY6owL3H5oOy2NqAnYJPLOuBPKSdR2vimZCabrm
	8+LW1fsfZ+WqO6LUYkGgBa5pZakq0Xw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p4nNWux7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of joyetamdk@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=joyetamdk@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786958364;
	b=7bCA1PG84zz3uGVr518BjXuFHzHNRhsla/wS/A7oLqfEBWrB/Hq9ej+AvktFAFYOyOyW9q
	Lm2tJe8112pozbPiRO6bbOe/ZCt01KRYBsdYN0uPXI2lyhQfqZ8HSQ21IOf06WEGBqSK0x
	WSh06g2Xl+oIERnNQLdh2ZhnlkdNVE0=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so16111755e9.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786958363; cv=none;
        d=google.com; s=arc-20260327;
        b=KI0OyHYFUsH7H8YONR2Bna3zGihZ00qvhVMq0s8s3gGBu5Oc08TvRSvOC6TfOk3Y45
         jsuQXRsOZlzWQRmSKRNrw6ezDzTaI/zg+W4NbxyloPX2MD5GU209rR2frDRAuX/fr4G4
         O1ZoWoMiPumuNmezvxjWCjuo7qhiYAh/xSZ//wPou4g3WAihxzhaCMdue0oEhJzbptaG
         RqqduGcCdsIjhISVcGWBEiedQtCS5D8XMuRUf4ztxYqAWshNMRd/+39SoAR6ti3nrhlQ
         SvypYQj8eK/sBPS451tEk0n+4jPew6YLdIC9eCA9Kwusz989fRTkmoNEdQO08TtbHbbE
         tBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Yf9pO4yEuDqcWQqMIIMbqu+zN00W3aXNegGKdZT8+as=;
        fh=uEgYrsGhbRRdHknnJmVXtYX2BGNsquX4APtOa22mnoY=;
        b=SFZZwGLwDeyPJHPU2rgzCLRW9nd+Theu+ofJsPpwT9iPZwS0+KrTmtnNAI1WgwN45r
         jjIxAQrzhMq7meHdyruaKN2OUvo7LUx6e3Tl8I+eIIfiOL/SdkpZjKB+/DfIwucu9DtK
         YXANXlU/jROBucPM4m+oGzPMy7eYieV1OVVsR4V2zi5tkX5qv3qBROGxb9gHl8B2Yb3I
         eGbpp1SwsOQa1y9VmB1x62Uxi3NPHGsYApZObo8OcQ7Y0ht8LDX9hlGa9kQt0tKubdWu
         IB0c/+CST9QETGRmESKop1VcZwla50tFqqsYpRaG5E2lzatSAoxwGg/JuuzB/vhv58kQ
         5DGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786958363; x=1787563163; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yf9pO4yEuDqcWQqMIIMbqu+zN00W3aXNegGKdZT8+as=;
        b=p4nNWux79Zc8HZTyAzm83cMukzIn/29V38dtI+XSWTxvMFRXqchrjuSDPm4bWmYSpb
         +N1+OnvGoWZSOtvtaDXhNVHrkYINIyWksNxqFClaG3YW6PWxI+2jfidEVNgHtPFyOMlt
         BPu0d/+dl4YdwZWeH5pOr994IQktCQ+Ya+ek7woofGGaOvRNMjvjCesIFSqJ/2oVri6j
         3ZXotlKTiq1yiIjd+/vgoXgNIZkEhv/AptWI7KCDanTn5aPn8QnGlRzBFPLkH3AFLsdj
         WrSte2SWZ5Ikrg53z2QQZdg3ea1VZpciVnUDmng2wPu5ECRWUdAQnFdZ4S8/pBaq6krA
         v6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786958363; x=1787563163;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Yf9pO4yEuDqcWQqMIIMbqu+zN00W3aXNegGKdZT8+as=;
        b=hPdM37gGkGGuHdpJmef4P9rvBEkT5PhXm6sXCXn7meXMl4thyJr/QnBxE76K0c91Bh
         ULqmZLJZC6U0gGYpPybkV+y8d4ojWv58oetR0PLxfxALiOgmpL/hRcsLAnHB6y5HmUbf
         bLvH3EXBoETLo8D37YJaBAuBPakLaLaYNrdgkLtKEsu7kuBYP90JjBvTmymwIyhl1AUV
         +fDG4LHT7h7fvqRoZGAyLIvihmt9OFmkXDOIXlfaOFjk3qZEachXaNPaFTQ8/Pq62ehN
         r8Hm2aLroZSunR1Q0jsWJnchQCVXZbcBKiGcXBHPlM4t+TIKbA2jCDSFqOUym+Z1aCEY
         b9vA==
X-Forwarded-Encrypted: i=1; AHgh+Rp5QUGaSYEepEoEwEPllAxAKvMkcESncmp6ElUqB+5WXb+u/7XKfVcAtQRjjiD25ii0x8qxioPMng==@kvack.org
X-Gm-Message-State: AOJu0Yw42jN44GHmoncAvNs57mMylvEZz7YV4FUR2bCRRL6kRY1Nickh
	mzxFjMyxAl8hKbXglbJDwAlZD/ZTLvY/yC+FHGjkPA2yw2z3BFsxX76q90IzPO3l3ZIxAKyJr2l
	BNvPblOQh68OZmCGuDL0ZVkFJcLcB3Q0=
X-Gm-Gg: AR+sD11NW1/3D7PXwWQA+2nmRiItFSB9CtWD0mdo0GPqo3/wZ+BDSyGnm2gmx6B+8aP
	ZKtsRvnqKRymR45m8H5Bf7hp8NSPWwl9dQq/0L+2w21tKwmLGxyikW4pSS9qQsrH1S16VBIptqP
	EKWYl+y5w2OqWxwIHwwUY1FbL7Df9AtDDx4WCiL5LYhGULby2wSD3j+ERMqlre43seBBoz6LIRi
	DXX2hBx4pzbtS8WWZQiJYV4C0MX11EZVlfNI063hcJLCrq13TqMwJvZ/HlTQrmRcct3egfwriIq
	Jy6uaAal1f6vQK0exDBhsXuxl2AFFnw4GflZHvfysQEY
X-Received: by 2002:a05:600c:8509:b0:496:c9cd:e7ab with SMTP id
 5b1f17b1804b1-499879337acmr413066865e9.5.1786958362837; Mon, 17 Aug 2026
 02:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <b1a53c0f-98ab-4f40-b295-a7839a5a3a8a@p183>
In-Reply-To: <b1a53c0f-98ab-4f40-b295-a7839a5a3a8a@p183>
From: Joyeta Modak <joyetamdk@gmail.com>
Date: Mon, 17 Aug 2026 14:48:46 +0530
X-Gm-Features: AcwNN1VR5BV14SRx1z4i67zHMWFZ_8aYWyQKb32rn2axL-Te45VeHCa8MUz6H9M
Message-ID: <CAN3JnUAYOFO3A4rar+w0C9A5wG2VYtEOfq54SysBpSzzkcp3Kg@mail.gmail.com>
Subject: Re: [PATCH] selftests/exec: add missing SPDX-License-Identifier tag
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: kees@kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 74AEF8000A
X-Stat-Signature: u1a5umo6d9g5mup817s7fizwniz81ine
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786958364-413751
X-HE-Meta: U2FsdGVkX19twbr6hSndkuLrfjdT0x7rsZ0sYI9gv/bDH3lCC7KjWsNyoOKID3m9af/7iij0efwGn0Phwgl1csraSqu3tQCqfAagbPpiXLPCo4AtMFRbBalvr4CObU+rdSsZ6oh3cnE+LXSyUFYFGGRAnpHv71hcSMQI5uXbNZ7NBCgEBo8YBu7PHs7pgRSEgAahEIhiCH3kbevCyxBwvDjBhrSYaVQxsN8sFUEWbnjOejx+STp0Bl9/7rNz0/ApMqxODibYKFmTsiD0ttZIRhZhaA30j+j6wAk2bYbNQcCQrKKgaJoA8dpMDHdDhVMbgk/SecO4TNWbioEz7aK8ZZGFFh+sANhPceRxR/Pba2WU5qr/pDllF0mBj82JEyPXKAfLGrTnlNRDiAdu+TmVr4DmrxPwDr7MDgvb+oo62yb/SsMs8+6kDn0XswCJaXVoLCeCsLT+c0xf1TwkwY9sTwt74kZj8yFYA41zsEPobp2LcQvFq6l6UJcNO2jAuGdX+uCKcNOhgXhhBSAov7HtpQNBSwT2K1e1L5Q47W51Pcb1rvvF9Q5itdK9EDbR2tgD2psaBo5OUDAGWLEj2uZrTs8KGzZ2B7GhCdOeF19ENdJPxPNn9aaOc8OhN9V2VaHwGDOnX5dtMedbtRBRsEalENJc+4YKDoZE34mCyRSobGYyCMIx7SSLjz8Y7WHCdZavhET0zxTjHgm/GS8+3WiyCmpRecniDj6lcu3trI5+KfindvXvKABgfjZaKDuwMyKtQoirxnVQ4QZcxgurbtIfyULs405wXUr5XZNYWiTBQkg+HD2X2UXeR7tMWl3Nt9p3f+t37lL9Bq7YpGqZRU27rzJJcGxf98YNjhIvzvnnuIoBgQxrY8JsRgiqU/0JZulFRHMaQiEX9Qi7j69rqpSEw31sJzzRjNyehvZojpuARCwAqu/PVg3kk4m2DDLgAOvfy+RsywLAFlaOdoFi87V
 GopyxWmd
 1q8NvGNAqdDH6F0hMlxBf0DoPu8dYqsMgcxOnxu8FBBFUcwpBChIs3UhnxrWu1pb7zynJZ9Sn2LZCZgXMuareRv+wCLN1LBaL2DbYbOBNXw/9cszXgf/aEbxPy67hAnCa+6xPGlaru8fow/eyP8lwYU2tNlHMtnS3SwIlyIO9I9r+t/Zo+o8cQU7+AvpUX2PFr6kg/9CjROQbJwJw5ELb7Mg/0m9Rdv+BafU4FYdIT5OQ4LQgKwoWdxUglLPQRaKNZlCIa6PnbpG3JhsjtzAfiwNPw2LkGf0LgE1U7yIY9a7E15b5WRr2QBjGiG7vKK4wAxH9Hv8UP5efWMjTNPxowxFmTjXeORq4WiEa57RtDh507dPa4Ypq1JP3OEQAE4SK+nAaXdt08NG3eGvV84HT0dYkR+BWCMibm86bNJR4KqnPIERGHqqA34X1EhaJjnFC8mMrPqOsHY02CHcnRbZdmmOHpN6NH7tw/ZoU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The license is OpenBSD, not ISC.
> https://cvsweb.openbsd.org/checkout/src/share/misc/license.template,v

Thank you for the correction and the link.
I compared the license text in recursion-depth.c with
/linux/LICENSES/preferred, the BSD-2-Clause or BSD-3-Clause which use
"Redistribution and use in source and binary" while this file uses
"Permission to use, copy"
I wanted to confirm which SPDX identifier is correct for this OpenBSD
license, before sending a v2 as I do not see separate OpenBSD entry
under LICENSES/ directory.

I also noticed the same text in various other files under
tools/testing/selftests, should I address those in the same patch
series?

Thanks again.

