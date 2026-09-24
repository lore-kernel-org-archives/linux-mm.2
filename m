Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D27C982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0946B0088; Thu, 24 Sep 2026 01:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1976C6B008A; Thu, 24 Sep 2026 01:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADBF6B008C; Thu, 24 Sep 2026 01:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBB7A6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:10:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C5BE801DE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:10:19 +0000 (UTC)
X-FDA: 85247479758.25.391B5C3
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8EAAE4000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:10:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rX/Ejwzt";
	spf=pass (imf17.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Uje1jfPOPcmIbWgJBz3Sa+j8/FJrZMoBTZpzcUyL9A=;
	b=yI2tHBqLpyWw1cleE2zQZ0JiaK9QYrfSChBHNe2TP6+jncKHERzhI8T/PEu8yxJULNe73j
	/nTtUwpWBi9czxtZHuKnYTRZXGfnYCuuzz5NJIpopuBjGCrQQDX3nUShaJwd7ykmuI4qRE
	B9tA6leeO0s9FA2Psr2SW6QhbCP6OTk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rX/Ejwzt";
	spf=pass (imf17.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226617;
	b=4+NuJigTPRwqT1iVTEWai63ZOyviRtCw/sDaQhqfwgqKQjzqdOQJDK3me6heR3SFbwuryX
	b6c9+J13KdHF/DPPJycuCapDoDm0TdQr41p+WSDcRWd23H4Yvuk9kdDa7uS+C5fFInZK0O
	RedSBkaBGHOrnJ1nPbAT/t4QmDCcR5I=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843c2790ccso1051918f8f.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790226616; x=1790831416; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Uje1jfPOPcmIbWgJBz3Sa+j8/FJrZMoBTZpzcUyL9A=;
        b=rX/Ejwztl+KZip+OfQpqJiwVuod4+LqORSmtFDhWA5iQV3Z3M+so3nbUbutSudf2Qa
         bQsyi8+miclIm8ul/q51H6A2TfC+3WX/YkBlmO2Ll03H998IRnTxjQvKat5syp4SSUeS
         AxsjozR3rCu91kkFcJu+m1G8SR/xQO5kx5TJxj3B05S7H1OuLFiobO9Dg/8adxCpIUGg
         VcMrUg2ufBYGvR5PTJzMBnCKOR8L8DfsTLQ/MVQtca/U6yOADQc7ceWiFH6phRBKz5sf
         Xxd9tZhXdJvEXKRWvv88qDs5lWO7SphnJfSQ6PBLzmJUjRlAFUVpC49R5pdCb1aZJX82
         791A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790226616; x=1790831416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Uje1jfPOPcmIbWgJBz3Sa+j8/FJrZMoBTZpzcUyL9A=;
        b=smyi1R+Ho3L3esElFYc8lr4OKJMMUOYG1SkQLHYDQaU9VSHphOVDv37lBHZu8i5159
         MipjiJUpz5x09nnyXRzO52Tvi/CUxW0UsPKvjgp+IdoHa27W8VPJ2blFAMpSn0Zdyuvz
         IxOPWfZ/KcPQuoUusDfa28Y7Wy9I29wi7oir6B17yyytZUsc75jyNpj2+goINCT+Q+PT
         vDhFVkcolqMcgBQI4outnqgDlGqknv8DqmaQYI/wVmravLK/cnZGaDf6PDw8wNqs9Txm
         6TO+5UNefju59qqEnaSxv8i+CLiHSGbKkc1K5I8X3hgXFEQqdj2zLxtIM8BNI8MkJuVt
         e0RQ==
X-Forwarded-Encrypted: i=1; AKwUvBy0VYNtMxK5z/9b/VFI0qVe16XcUUKSgpISvffW5/g25qi+n46nu9LyxNmjHR3XncRe+D/rlQMnTg==@kvack.org
X-Gm-Message-State: AFuF++lwmc4yiBUYxbLssuhktqtHt2wO2SyjuYn5bMvZp9oDaS+SS2aZ
	H422RIvnNGQh9MUBhVIjkz93PYOrpddApg99crW4BnIOqFI9/bDN6pRX
X-Gm-Gg: AYBFou0GriSLeX9wO74I+lckZzl2t0jY/wsZpLvPk7MPH68ywAMQpl69F/e3a7M3zLT
	3PN65tmrjBIJEco5dyfFayZ2F+T7NMKp19fgL7pPDy3V/D0w7GXk9VinvQef0fGGEkWAGLhnBMT
	lfLNcnK94HCeMM6CQTqEW9e2z7Oyrfj5IvuYm1hI6oO613wXIgpciFU+kBPuJxTqazEbC3ECuhj
	hD6d1UvBZiz5fJHaCr0DSOT22RFG6OS/JTk+CXVvyrpW+oRWq0IDtjVPPZYG3a0d1Wx7g2WZJiV
	jPB0h0VJHmpkBBzHy96CVJUSteJV+fhKIaF3rVASRYXlcXiTaljbtPWBS13W3ZPHeLjMW9RG3q8
	xCXmqnQW9jjNMTZrVG6oIOpXCnnnw5Wr6ODLRx+MAsNBgIPirP/JnwKMzz/zF2yFzXWYwpsOKbE
	+5RIIooPuFzCVHL3nwo0l0kRb0Ypa7mfTA+ZpkRuf8ag0IPzzHXEqNfiKBSWkdw2E2inuBXhPjy
	eEir1kXrC2wtCZOdfPJR8SRATCUgIaqWvB7m2uiN/NQ/wLIZ06aUf9vUFES8oeK9tV6F0A=
X-Received: by 2002:a5d:5f52:0:b0:487:232c:a9fb with SMTP id ffacd0b85a97d-4887166daacmr2047188f8f.12.1790226615925;
        Wed, 23 Sep 2026 22:10:15 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886876c417sm10993394f8f.18.2026.09.23.22.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 22:10:15 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Toshi Kani <toshi.kani@hpe.com>,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm: Drop the page allocation from pud_free_pmd_page()
Date: Thu, 24 Sep 2026 10:10:11 +0500
Message-ID: <20260924051011.21237-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <e1f8a64a-e4b5-4c1b-b83d-50425a7621a4@intel.com>
References: <e1f8a64a-e4b5-4c1b-b83d-50425a7621a4@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8EAAE4000A
X-Stat-Signature: auc7g4whomiha76uttyfudayogxzghcu
X-HE-Tag: 1790226617-883002
X-HE-Meta: U2FsdGVkX1/hPBYabmCGVPPISgQEZKz5Tv6LpXj02Vhj8tEujBTqw+6Mw4hZh0eEQ4v9Qa/QeYso2TAXOho9CSSpFjNxCoASytM4qvdtiJ3clcbt9062rQLcI5TfK2P3K8/9W/JEf3Am4EYJ5ob2J+eueyqin3OY9jvc33CbAnkidjSUwvYN6y35ANxwVrB6iAd3qikHq4rHAIt/6mxQyDdQuWnF9Jh60x3FVetAUAi4BpXaWHr0fV0GWOHYMWE5/1OAkt8frDST2CXPvy0mQDgHVa+pTVO2eL6MmaW6KvAhCu2ZeZA8luKu0Wrhxm0OGKGzXkFmZK9uNqjPt04+AkWZ3K4VXPDumgExwkJmpjXchVCR7wz3FN+WEs3vXaX/2N9x14R03oSouxxp/xEizSn5Ku7lafLJu5MLnUreYDUsxps0+vY6mnxQ0ArY7bszmIYpeVCgbcm3c/ULk8sf3zS25BatZB9pc0OUypyh4BrDmz1gdn2ELzy4gP8lrYNNWuNYYn6zj3VSoWH8BpM3D70LqrR4VW9hTwZC5Ux0fUGdDboOqNpHFCH6Ay8P3oxbjSny161kXKAczMV3N2zzPcj34F1q5Lb7bW9utbAqomsgelj8MVB1jxB8+0rXostPBFKLy76Yz3aWG31jGcMSBrspFHDAXQey0doT/chgHV6MESNiZJ5Ml1APDdWONw2ZtgNFotTYaO/VQd968bZl1jpnL0QM7yAT5046Xeh96pX+6PQ9G8FHTNRclSstVT67XvG6TOM5iEJKXH4JxKR51vF2LmEzK/9B5a91UoD5lqpZd7BwFi0gPnj+AjKZbDyfrYoB+hREOXfYlkCm6OgtfrfHEWTn0157Tj64kMTFHsjH3YCNR1z/Buy1E4XcLiGC0fm53UpGG5Vv2Lgazhh5wIUZoNxNfsCO4+slRJdYu+xGajX6byVJz0syGCfk/BNTgLr/Nt/oOq7kramWZYr
 sNS/f+Dp
 Pe4CiCopPVbCrrLSwkH7wFxh5ag89HC8eHPSuXVIlBIKcYhAjePI0hmMz8i4V+0IUxKmLkfIwGEXEJnOoDK5tvif0Y4ml6SLsck1vE+z3/N69BaRGQ6iAlf9uvSQm3yiMwcc+JO1/dZxudV1urBZDSt/JtV3f6pKjVaNapfdNgiT8+6z1s7w2lMV+z36DPLMzUSlmqjrC0i3pDgd/gxOjNR0akGdQCHpR6JhePZRkf9Pxu8kLuynK1X7slm260+J4NEh4W8e6GWIJplQ21RTZB4nVDo/0LAbtUnkyA+5/Jb5kG6sOHttLUeKIwboFvvuOnYo3e/Z+3X2rd8vb4HrEdHHnbD2PFfEX7PE7tkEmyg3WivehPyrPoteW+7JxzvY390Y5g81koZ1GfUnRijmQQEdwx44dESKgJjyc3R0SyKCmlAHUjrJtWwig5sTGHJWBBEezXLLEB9jJibeyB1uNpQn58gMVIDV0AuQKb4KphKHa9DNELFbq74mBK2g7bymz6ZfwVrUr8Wwmqc0fIT6Tb4L2f6NP1+KfvmxbMIERwipyWUXBNe9rYTAk5+MhQoQYNK+2z14bZeIlJmPKUbCMEIwgBRB+WnElQqn/OKFlsYsXWzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 16:07, Dave Hansen wrote:
> There are a few things we need to figure out like having
> pmd_free_pte_page() return 'int' when it doesn't ever fail, the
> comments, and the reverse Christmas tree.

One data point for the return value: the x86-PAE pmd_free_pte_page()
does fail.  It returns pmd_none(*pmd), and vmap_try_huge_pmd() relies
on that to keep ioremap() from replacing an existing PTE table there
(the comment above it is about the sync'd PMD entries).  Huge PMD vmap
is enabled on PAE whenever the CPU has PSE.

pud_free_pmd_page() has no such case: the PUD level is 64-bit only on
x86, and with v2 applied the x86-64 version, like the arm64, riscv and
powerpc ones, always returns 1.

> I'll dig into it a bit tomorrow and see what I come up with.

Thanks.  This box reaches pud_free_pmd_page() on every boot I have
checked, so I can run whatever you come up with through the same
boot-time kprobe and reproducer check.

