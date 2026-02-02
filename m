Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F94E7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C006B00B6; Mon,  2 Feb 2026 10:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED1A6B00BE; Mon,  2 Feb 2026 10:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19986B00BF; Mon,  2 Feb 2026 10:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D29456B00B6
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:28:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C3701401E1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:28:44 +0000 (UTC)
X-FDA: 84399898968.05.BD93CFA
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id A1D0F4000F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:28:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NTpusrfR;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770046122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMgppeQ/ytgeZRS2fFLze+otQrC7khA/towBWudc6RA=;
	b=aNLvTNvHCXKJuYXkt0kuhpusQ36P+2vdWMOb28nZps+Up1TL5AliKUUHCh3Tv30n0cZT+/
	5mxYnaGLSAIsrkTQ2NjuRlRWN/Y4prchHCy8RFQl/LIC6QJt7Lnx7+Z5yfOH87wxa+VdhI
	fSzMUO26gDEh1gSA1Eq5dzd4xyV/s0Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NTpusrfR;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770046122; a=rsa-sha256;
	cv=none;
	b=FoPJzT+aYYARFxLXFw6ycP2r36RcJIa5V8vMNTZXO37ioGvdDASarDurtsQwnCSdAFTC2K
	R4RXgUbaYx2Av2Q+E9NCrjRvdBxmZCEyqCpWn/UvRlM3NPKhrWThdzT+ekumh+YYA7zOgB
	X6A/R8/JHrLNqs1f6vPR7DbSlkcQJ9w=
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4042f55de3aso3268015fac.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 07:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770046121; x=1770650921; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMgppeQ/ytgeZRS2fFLze+otQrC7khA/towBWudc6RA=;
        b=NTpusrfRwWqzsWqqwyylIJmifj13xLSohr0+unslDuPXV1wwR8p0wfpD1Kvtqb52CI
         MvUXjQi3oRPBXfheIhTzosuOxBQigBDDsQ5KbBvLHvV3rZy0FxS2nfEVgucDonFEXjbd
         bx+k6dTW9r1DKUjFFAmogFxPzHuGXRc1JWns9leLLk2tUiOaS/Ni5M6FMnfwEAvRExDz
         bQKs+t7PKUUdXjB9WrkCWXQx69f+UEGd/MSwr6cXgQnzAebj04yIOaiEGrNmo3fBvi1J
         9lJJ32fQdht+r6+WkwRbELOQNFrQf8cIaQjoGdR1iZ2hdWhB9p5XSsKo5atbsdrZVJWB
         1hcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770046121; x=1770650921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oMgppeQ/ytgeZRS2fFLze+otQrC7khA/towBWudc6RA=;
        b=F+c/1LrHeQ+6DN01ug2hfY2lHgVGCGEXVdAh17WqkDHgspormQNIaXotVkZs9YKAFJ
         TUUn7wwRbGiPg/aGNC3b9MbwfQLf9vndapKfbEsKQ9j6EMHK2PlmUp9EZBMd8+ua2p4U
         5KmgHrgzaLYOdWuMWautst/x7suk7nVTfpCgmvTVRmoAwHxW/8N0fms28xsxaW+QA/jK
         lv9xB73zkArmFejOqivr5DJ/LNiEu2yqVSE8/6B2f51rcw8tQMnoOd7qNtbMakQoPNjO
         sEFLE7ddfAoKWnAW5zwKljgpc3yeQK0L2+DlI9fMU6FeU0CqfioS3mMouHF/8dRCvDjn
         /WCA==
X-Gm-Message-State: AOJu0Yz1bvw1UDqE4HUev4d8/wr1FSXcxvExk1TRuTFGRYaNRfCQ1ADz
	BW1gZb9qqDjEyb7Gq3GDJoMhwI4UFqCn1Dn6ggIKVjuxFfVLZi2Z8Hzk
X-Gm-Gg: AZuq6aJuYKn3faArVBhJiDRQq66DIAU/NkFImIl0ng1ul9z1SODkstvRpfIpZ2UJznJ
	nucONJ5nMz5xbOMc2noJd1HIdRmA7CMJs9ZQRbPAltivQf7wzJxzM8rwbaEdEKlj+Z0NAwqiV7m
	2MB24HLYM58OuIcDxUWiZYbGKdGIP4UGYAXR7bzAWHg9cafUjuB5WYcNJxNOqYa7WSh+L0aecRl
	E7W3FE3McEA5IZ7o9GAPL9e+9ViFuIHs3l2cVG8PnmCAov1nVXTYDTP4Md8pIMQ3gz2hfUO71Ri
	PUI64g2ma8uGEwdsvNmUotyeiUMhwIdm++yPANvSHC9neTPTzIGiGtrqL5JPk6DaZS7oGLls0yp
	+M7mroXa6zjEd1aDbw3o8ROVa1K6gEDHcSDpYM+R+b2DoH7PTFaN96acVpz2oQbvSZbjKcwvG5D
	Lv9KRnlXVI
X-Received: by 2002:a05:6870:b91:b0:404:38fb:5434 with SMTP id 586e51a60fabf-4097ffa4745mr7580405fac.29.1770046121405;
        Mon, 02 Feb 2026 07:28:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-409570f63b4sm11999451fac.3.2026.02.02.07.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 07:28:40 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ingyu Jang <ingyujang25@korea.ac.kr>
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Subject: Re: [Question] Dead code in copy_pud_range() for copy_huge_pud() error check?
Date: Mon,  2 Feb 2026 07:28:38 -0800
Message-ID: <20260202152839.221116-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260131172854.3370590-1-ingyujang25@korea.ac.kr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A1D0F4000F
X-Stat-Signature: 1p3wmr8hea3qpzew73m58up1tnmn1nnk
X-Rspam-User: 
X-HE-Tag: 1770046122-243704
X-HE-Meta: U2FsdGVkX1/szL8BTcewQHnZDDrAq40m/ifa7ytnJ+TIyF6DQIrkuticZq7A0ZiKO1wHwOKn0wfCeV65pBev1V44TcxxNSwXexkt9rxqvKrzYIp/m81rncL7YgQtVp+L1iAt/y7486gCE2//+eKfREOPEe0/YtIIADvNCShKyztmuj8tOX5vCTY+kVSRjMHfcnHlGsyxxAEJ3gSM/o79gTEJkuIVSaE/Ky5VGKJ4Ko7avq2qJSjdmUxZVoYTNQ1ExYxFdr5vTH6G5uUHyOY7KcRs60970xHTARt+io6lvHqYm/WD7nPLivfdNXG1BCqa7qu7DXig89rpc4BvV7LEarT3Ik/f6bxdkU4OrOeI+GPCihCqyS0F3+KUjTl3Z+uatlwM6R5KRjMEOsgziSNDbT3KHtP4eo82Ymt3wmyMVTgR4ASCysvblRk/1y0Qzfwk0/im1WyzZaIZkSQe44NTeSrikXS/7ogAegZnMk7RKBfOSoCFX3686T2xC7OOtEvYWiUa3qz1ZG36Ioyd6R9QfxjpSdZfO4OQO7KtnFjRxAGWOdqbh3uyFh3tAc1ZDqA2NRSotNtb9/bWplVp5Jqyo1qa1SpRcMcKAHvz+pxF1VzYQ0xTV+Y6mAMq8DP1i10U4/1ld48mLuu8aPBp6rpe9J45YyxMJQ3clvKAyEIzB6ppwYy2/JIKjPK9l9/x8EpHQo66UyLz2WLo8opFP66w18MXdYWZKFnufJEBkBWWeBZy83J60k/xFjFoFeHZJIMMWLpNi2Z+1guQVn71UWao84RPexE02aowZKJIk6O2z9rKoKe//oYtO6pZUWEKjJjUKQDZYfT60d1lNpFqNv4vzz+KllC7lInPuLB2PuIAxKv2PnodL/+M71lfEhUHY5KRWTXu0NQsYmip+KMjVJXbO+l8lcao04XTDUZMy0EO7ujh7Eh3BX4mdGol53Hyy11CYuW9ZIaGqUAc8cfv3ta
 /Wj8plJM
 O/AUaKneDF+mlXtqPjbij/Glfj/73gAT4vmTuqRdjKOYh39Y8IBpYI0i+wC3vt9kGcSWYLKS7m5FpKKsJbzo41s/puvRLhz73+qqe7Pr7PIKespz4LVW8cRGkucjtFlqjz2RnoJYRI4i8Y4h2i0vvztfG+3197n9aCun66bzl1tbhDBl21d8LFs+KbetWN62vdbpYY9IwzIhebdDUl6aAjiZBIkfu5c8tRmC8a4wPnijJNJz8b4QTm3V3Z4KMID1lv5own8iEtlR8Y6urlAWPzdJnD6fge+aaw6mDbJQXh9OCJ8gqs1q4Jp1HELFxq9G6+QT87y1QC9K6Z3Qux5QSJwzgMl3NoO76LTOPvUol3Y3Mc5t2jnfVfxmRaHLo57+aksgSwOW50BNT4giz4o7V6tw2fwDolIpLSOTAjogK6S6lSus5+JCA3nILbArUAEXUPmZChwH5Dh4AgrgNWtztDL+44zsXiwBdQ6SiJVFRNpop1NmE5L7PDXzd+WbgKX2frVpjRgMcG8Toznc9S9aoZ33GnTZQDu2IxL1Ojke+vJDUQEePH+ZCo4mMfGDSVSt6pVYlTPrW0UBFqBFot7ggSsu3DIuuTHoA4dNa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000004, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  1 Feb 2026 02:28:54 +0900 Ingyu Jang <ingyujang25@korea.ac.kr> wrote:

Hello Ingyu,

I hope you are doing well!

I'm by no means an expert in this area, but thought I would reply with
what I found in the commit log.

> Hi,
> 
> I noticed that in mm/memory.c, the function copy_pud_range() checks
> if copy_huge_pud() returns -ENOMEM (at line 1421):
> 
>     err = copy_huge_pud(dst_mm, src_mm,
>                         dst_pud, src_pud, addr, src_vma);
>     if (err == -ENOMEM)
>         return -ENOMEM;
> 
> However, looking at copy_huge_pud() in mm/huge_memory.c (line 1966),
> it only returns two values:
>   - 0 on success (line 1994)
>   - -EAGAIN when !pud_trans_huge(pud) (line 1978)
> 
> There is no code path that returns -ENOMEM, which means the check
> "if (err == -ENOMEM)" at line 1421 is unreachable dead code.
> 
> Is this intentional defensive coding for potential future changes,
> or could this unreachable error check be cleaned up?

It seems like commit a00cc7d9dd93 ("mm, x86: add support for PUD-sized
transparent hugepages") introduced both the if (err == -ENOMEM) check and
copy_huge_pud, back in 2017.

And at the time these were introduced, copy_huge_pud only had return
values for -EAGAIN and 0, as you pointed out. So it doesn't seem like
there's any bug or missed case, just an extra case.

My guess is that copy_pud_range tried to imitate copy_pmd_range and added
the -ENOMEM check. copy_huge_pmd can return -ENOMEM though, so it seems
like this is what was missed when copying the function over.

If you have other changes in this area, this might be a good candidate
for a small fix-up to be included in the series? : -) The whole if
block inside pud_trans_huge(...) can be simplified quite a bit:

	do {
		...

		if (pud_trans_huge(*src_pud)) {
			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
			if (!copy_huge_pud(dst_mm, src_mm, dst_pud, src_pud,
					   addr, src_vma))
				continue;
		}

		...
	}

Anyways... Hope this answers your question! Have a great day,
Joshua

