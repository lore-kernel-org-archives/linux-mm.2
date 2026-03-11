Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03426FD88DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311876B0089; Tue, 10 Mar 2026 23:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB406B008A; Tue, 10 Mar 2026 23:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8956B008C; Tue, 10 Mar 2026 23:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBC8C6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:02:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63A6C59431
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:42 +0000 (UTC)
X-FDA: 84532284564.01.D133114
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9640710000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LM7CDlsL;
	spf=pass (imf14.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=vO8RhD7fGikYRNYtDoD/8DClVqthT19fczPJykhciJA=;
	b=78Rxv6D2ECNcuTmLk9Bw7fJrN9T/MAplYPqEfuGg+6jdutAhOS2EeINf6N8UhKlez0KvFC
	W+vvAqZb3TMNoAysEZJsP+uqFD3rmSyLZSfYrbc3Ymd8pQismNpXLC3vFDXX8sVMhbnX3D
	P0ruA3tD2UYPOjoNu36Ub9nvOKtqJsE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LM7CDlsL;
	spf=pass (imf14.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198160; a=rsa-sha256;
	cv=none;
	b=RxuOqx1vkENC02tUI+Lgxkm4VBi2UVwlFJzDIFK+CXhuaw/2pwShsfqg1PMd2KrfomZ+K3
	bZYj+zHmYKNaEDVAroQ9D75z0E5leOnsKaiaylzixTWAFMLp7QfCytRrmj1qpPn9vy1Uiv
	/ictg1KWpXj/QhDB/EeEG7wj6Z5joN8=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c73a12af63cso2602230a12.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773198159; x=1773802959; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vO8RhD7fGikYRNYtDoD/8DClVqthT19fczPJykhciJA=;
        b=LM7CDlsLN5+Ryr1tflBuX1oyWjjO1ZmQZmtSooY7Ku7HmgSF5vE26E33MN47fe3HXS
         EBtMu9FMfurj+BVbqBa28ASMXvsclUEu6BscsvwaMTVXvoMtDlHG0UlrYXOTgYZFK9r4
         7kaoUM6v7DLa4Bduvv7C8AxfZgVYT8JjMFPQeUaxlqJwEcnLRX+YIcMfbxRDTWu/uVbp
         j1pVrZM2qzPne1d4mK5bCMNHxa/U18iw/nZX0MZIt3qM4Ag5hN3NAOrWNA5/yyDfJdGv
         UsPXnOP0sj/gwEbD36+9CGXEFhf7jzKROnXtBdw3UC3daP+LEjbKvIQFEZxw3HQpmJ9V
         vXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773198159; x=1773802959;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vO8RhD7fGikYRNYtDoD/8DClVqthT19fczPJykhciJA=;
        b=Xqu497IU8K6EoPPALkrJTGKmOSDzBbi5SsJ9Jsvr/OE8nEH/LhneGl5DVBJ22VjJcr
         27Am1eBfzsioakeUpIQnZQRDNAkyh9vKLPWqKCf1Je0GPLjSFRkU6KRgz/j6ysILuE9P
         CPDbrQM3Bwb/KbM2v0MUaEfr8JZp4R7Idzdmv2jk3fZaToMeeqYaPeKKYqZos7DFjLNi
         wkZur5nLBNXMQfCTl28HJ4J/CMYKM0Vlt0ax1Gouw9uIhuXiaHeWL17VkflDFH75diBf
         Ej/XOtJuy4mxoHnP2viHOHp3ACHZYB6qj4Jt1Dgs6aPKS+4XNH/FrLwvtquCtKkYHV7B
         4hLw==
X-Forwarded-Encrypted: i=1; AJvYcCWXlUqstyhS6WGs3yQT7fKYoTaY6Zaed65nqjgjXqW580WLX76MDXQJ3fMhQhh21TnhNounC3DBUw==@kvack.org
X-Gm-Message-State: AOJu0YwHUw7HGw5qVTMAiOTNsbgiP9VRjr5iDYNuGONGDUIJZPMAWJfY
	sCYgoJgcqYU4ZnVytvthG653+zb/aUNcLqPdHcuqIEV35wEuG/6OwxIc
X-Gm-Gg: ATEYQzx+J1gqUIeQytJUsITwuL4lpLSonpO2hTrTWjvGY4HyHQfIgKcO4bFIHBUGz5+
	yVqrzfC0UVPhgl1dkzKf5Ec8imjRxdfcsMO/GNOaUEo0fuFxbW9fdEPkLtyQ1BSSdBERNBIRZWl
	4EaOGR0GYlBBVYalAI42jZdRM6or4AkisHANVLcKjOqUiW2v4CjFq3JL1HzGwV6Cnd+YEz9Pzrp
	6MqzSNjgkZvkKxLA06gss641fChSRrc5JkUZppDLcApSY95PQyCZSfiOc8gvE8dZ+DLBAaZwTWK
	hV5Kh1bK0/lW8eoHkw51CaQcqohZG4IAGTrUUmW8qsppqepMCir5qrmPk+Rl+052VKxdLrdWdb8
	yzzkLvkXxVqgvgaPwTt6oIHfmE9D+OfRGnvdVocbPq2HN1CzHlXM/rXIwLlQAD7TmSOaDIja4ju
	Tb/UITKfFzhyxn9m/bHoZ9jg==
X-Received: by 2002:a05:6a21:38a:b0:398:778f:6973 with SMTP id adf61e73a8af0-398c60e5857mr818593637.40.1773198159334;
        Tue, 10 Mar 2026 20:02:39 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73cdf2725csm548196a12.13.2026.03.10.20.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 20:02:38 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Pasha Tatashin <pasha.tatashin@soleen.com>, Andrew Morton <akpm@linux-foundation.org>, Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 1/4] mm/page_table_check: Pass mm_struct to pxx_user_accessible_page()
In-Reply-To: <ca77f3489453c2fe01b25e50e53b778929e0dfc5.1772812343.git.agordeev@linux.ibm.com>
Date: Wed, 11 Mar 2026 08:29:53 +0530
Message-ID: <zf4ft6ja.ritesh.list@gmail.com>
References: <cover.1772812343.git.agordeev@linux.ibm.com> <ca77f3489453c2fe01b25e50e53b778929e0dfc5.1772812343.git.agordeev@linux.ibm.com>
X-Rspamd-Queue-Id: 9640710000B
X-Rspamd-Server: rspam07
X-Stat-Signature: t7946kxm75w7utjpw3gzo1wiyd6fye9c
X-Rspam-User: 
X-HE-Tag: 1773198160-20539
X-HE-Meta: U2FsdGVkX18RyPaOIKufoNzQ7sW5Q6gRk/aE7PQeo+f7CFptoVHcR4OahSlkxdiEu0BIxmSVFw8OSO2HqppZxJhbi3aLL+Ys5uoDj3ZfIU/j6wGiyyBuOTHtpxdM9X8iiY1p0M6rbA88YRQ/WIMSeSbXUYJXqTLZ6Pgqy+ybldijVpWCHFX7OU78XWnoqG1iTtAIMXmPGxhxRfsVlsRwyxVW3WdyzxJDQ+9bzwUI4xv82O8exbhL8F1u8ZLtGOzIO21UZGtEJnFrz0rFs/O594popepZ7opRtA9u2DlA6RCGqfvU1J12zxba2CFSeJp5uz+L15wVTfXdoGq3W0VzKqizG7s1ikEHPagUoxB3J0Y3P85SrLmehLkExTWgNBIBhRRoffM/B+785IHR2RVh8G0EyCiUb3e/mqDaEcWPEEKBYuanjDSHWIFrkwAvUxn2N9SDhhf/LVgznoaQAVOUXBswblA9YfFPvEW8i6IjO4I12oFpRsRQ/lW2YEbNrPsfeZspFBa6G45qSevNq/1gtcyZlRgg7rd5ZR2YxzY9M6IDbbxICXQoKm05J6+ZPHlmqBLHvEGEPh1twSzJz3k2j6B5P3+vwYWXwmd/1l39WBdN0jZEXtBMzc6tMdqKiF6OeEIV5Ice5e6xYmtBE9Q325gsQCh6ODEYpOi9QmnBfA04Kz65TJkQGYud5+E3gLb0rXQD4XfXNoUMBsrg9hwHoCtE3Ci6XTZLRZ5GYI07EN7i5XQhdunzzKeD5MGHOpxUi/Vkxnpr46+50gYCVX/Tg9EzerVBPi6mmrf2z4unhh+qG9H9n0ud2+NWaCZ/XEGj/Ky+tSma4Epw08Dgl3jfYVs8EE71XX8G8I3yvrFhXeYgSaO0xZ41+MVwUOCXG2hbYOz1liGkxktb+X8hn0fcWMFT1awGCdNBflkibMijWNKaUDyMwaVa4lijTp6wlJXVfuuRD1t/lt/FEwmBQ1T
 0vuZjMal
 tKEfRxeYnTpK0pGGzPkwModp3fsY+KD87Y8KuDDE69+6kLH9GH8/KMA/cR9haEL6BXANMXmvgfSJ0SPa33ABhavkEH7KSW0YpUd52Wg9ZfEEQCgD3ADf6oSzRwpAlwLxztt4mV7vNnhzvBAOtJshPvsdLq+iTkNEiS9cYcdy8mqwN9CVVO6mM9p/jlDM9uYR1YVDG8nt680d3+H2FciRzrYsLewzU+Ni5X7EbyNFgn2lcHpgffxfFXq8Du6jWRT5arCXMuZ2b1TXjBFmU/2CiyKh9azT9BCu+1Dpio12wVkK0o0b1l6fBhjuTyG/+pXXAM9bE1h3EZ2iMD4MiDnu1iYnPp2Vra/0U5fJkrAOGe2rgHC7sFfqQV3hkUlQTDqwkgRRCQK3QG66wxDE24mQsG50LkN5w7YJbzxUd7b/rtkcacCjnnu+lC9kL8zb7aleJ3pjtcIl8OZgFA9XO9gYCtYS1aG3BkLHo0wGRnUz+X+xfPQnPmZF3hBex3iBc9+nWJsxjGOL8ALAaMfidIw5v21d5JWUHKaoi42QqosOb3bXJ3E24c/M4B4efjs3tBJWWV2/W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexander Gordeev <agordeev@linux.ibm.com> writes:

> From: Tobias Huschle <huschle@linux.ibm.com>
>
> Unlike other architectures, s390 does not have means to
> distinguish kernel vs user page table entries - neither
> an entry itself, nor the address could be used for that.
> It is only the mm_struct that indicates whether an entry
> in question is mapped to a user space. So pass mm_struct
> to pxx_user_accessible_page() callbacks.
>
> [agordeev@linux.ibm.com: rephrased commit message, removed braces]
>
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Tobias Huschle <huschle@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  arch/arm64/include/asm/pgtable.h             |  6 +++---
>  arch/powerpc/include/asm/book3s/32/pgtable.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
>  arch/powerpc/include/asm/nohash/pgtable.h    |  2 +-
>  arch/powerpc/include/asm/pgtable.h           |  4 ++--

straightforward change for adding mm struct param in the page table
check calls. Also verified building different powerpc configs using ci.

The changes looks good to me. Please feel free to add:

Reviewed-by Ritesh Harjani (IBM) <ritesh.list@gmail.com> #powerpc


