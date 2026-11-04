Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB665606D83E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Zo2yRF+j
Received: by kanga.kvack.org (Postfix)
	id 60E6B6B05B3; Wed,  4 Nov 2026 13:57:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597B06B05B4; Wed,  4 Nov 2026 13:57:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD676B05B5; Wed,  4 Nov 2026 13:57:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 164176B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:57:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96B51C0827
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:57:11 +0000 (UTC)
X-FDA: 85398344262.20.481443B
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id D860420006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:57:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Zo2yRF+j;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793818629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KIi3oyLyMDdsznEK7o9dw+bnJIKiQjdBXnibwTcAOc=;
	b=umemUbMgQ3uRCbPMtjuOYn4zqwoKFg1HQjnDGFJB0KDD3j0DQWHisb9UZ3YeNmZjbXU1lM
	h1rDAS4fG5FxtKKOB1nVTBN3cMfLLbRlNG09sDAg0Zba3BEYQqFGVyAJI5hjEzSnwiD+Nf
	EXNNwEphSQzTXJHQjxYb6lCnbVD4f3c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Zo2yRF+j;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793818629;
	b=NkiwH2xaulOkDWS9kPzMZAsCE4E7JyiYpH9JA3fLsbKLMdugRlz/5sVvtVbE50x2JvPinI
	ug0PbIvGbP2MHWSXkn9TdvwutQl96yWQqv45985z6ixc5QOb+s2YMlScgPgs0txLzFK/gu
	ma3GivTtBU7XYJ4sAVLbD8qUGVScwfo=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-9906c85122cso357022241.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793818629; x=1794423429; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9KIi3oyLyMDdsznEK7o9dw+bnJIKiQjdBXnibwTcAOc=;
        b=Zo2yRF+jjQr/uxqv3PxKXT1FfT1mmVK1bln2yg1x/FBciYy9VWK9VcnZttGGl/Whv1
         XNLr9+oUFGQuxnKNZh3SNraz6/e885z/z1zBaj93+K740QhvwSA+2n/qzBFI32C1wm3y
         gYLzJNU8yod3fkaiSVZAG+0fXW7BmgcYsepx3s2Tax4cS02lv8u5rRE4zDESysr9XP4V
         6xISPebjQVvPyfBB7MgeiOaMhIPqLl0kAyIuSiJMlnlf1+HnyMyZyiMNG+fCEiIrEUpv
         V40PmtwIQ9bkLvjZkKVGvekMvRudAYiVplHZBlPcsdo3LIk5k6cXqCi+q9+/stIP6MCP
         BtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818629; x=1794423429;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9KIi3oyLyMDdsznEK7o9dw+bnJIKiQjdBXnibwTcAOc=;
        b=KxpN6fYrRh5LULW9eF82dbsXb91dGO7sAZHQWrSKdmkKR4dG5OtxSxUzlxfxgxOGra
         2HK2956qW2b3Boxl0Fj5ABlLyTBUb7kIN5Q1+H3v1dGQ7862i0RWaAPufGIoHEOV5GxI
         wuUXOPLV4+b3v45sIxp0q5SqouDDh2ysuB9nb3tV3fcUR8ZHjS+045r2kTiU8fMAfJ0q
         yPlSHKDqZQFvMCkTWMoQoCB0ywfRDBr5m4ofAI5Wp9ZB3NMlFAsaQV5p2K4JfBi8DHnB
         sG/0NhMMVMLQGbUC/Lj18Makv7XYVfLkZDbkYwdH3BDFqSDQVpCjDHCRZbxJZgG3ye3N
         y1lQ==
X-Forwarded-Encrypted: i=1; AKwUvBxepMa6LS9E5pJTPTty/LH86gJuuqFtcoN03sGERASA0OrUhv1V2UcqjoANqfnYgQvLAEod8W4R7w==@kvack.org
X-Gm-Message-State: APuU4Z/RfwiWARTwmG9b+9digMdS5mA11jvALcMOXHBf2p9gWis/+n5V
	SNEx9+ZrcAeFOHjVrAyl85OIl+z4A0XhxTm/BEHMSrsXRO+Y+2w0yVyiDKMJkeSXgidME1JwtJa
	SvQc0
X-Gm-Gg: AYBFou1h6R1HA/a9tOToPkj10kD3hTHfsDLrbsin4Ib4IT5WAepe/EPzpV7XaDNMZkn
	bDCZvpJRwQUz4v129+7II1+kH8f/QVlvifvAB3wi5lEn1i3RKe5NffxVCzwAydIHBYRQ4WWjeO1
	O6NY30Lp8A5PhlQMxkF3jmm5k2+nkjeMVRjCeR95Vzwuy/tzEAWdIn0evInPrbxgByB8TQq4TzV
	ObLaO6RTof7wIqLkLGhEAXqByrtsI8Ixdn7PBWQZ/riZAth28guXZ0QuFdfwJKsjRdeFzGIH5XX
	tC7RJ/eiMHuXYXx5UZp5+WZ2tgti5rtt78w8pugXciGgbbyxLFBMq63bQZJwUZ7n4iA76ZkLBWC
	T8uSZJMtO8pWoiPq1mX5uPGVNm1SphB1gRetxAGXLXOrA6KkywqO2nltrxu7m4wxtNJjf0PxElZ
	544j7Sx1W8Y0bPEQfyDvZOE+NG7GiR2Yn5mA0lvXYCnUPvLIaXorfCsDBwoObetGqIXfNaKGo42
	eLqWkb5ZZo9eTNP2MrwUnR1v5zqAHwCvtkVzvwyu9EvyzzzakUf3b+Xix/geSeTgLO8nnhQGQle
	2X22mSyYcSAf57QGB5/SM9m0/OdcgtMP17mCaghzr0O6Yni4O8ebzZxXEApdgT6CtNtWvdE2+UL
	lYyGQkJRkuztl+yq/XTQi7w/CtGZvqL3sERPFV29SxWJp
X-Received: by 2002:a05:6102:50a5:b0:7c8:4efe:5243 with SMTP id ada2fe7eead31-7d072c0ccc7mr6799566137.14.1793818628571;
        Wed, 04 Nov 2026 10:57:08 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-999f3006224sm736210241.9.2026.11.04.10.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:57:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/3] kho: skip zero-sized lowmem and global bootmem
 areas
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org>
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org>
Date: Wed, 04 Nov 2026 13:57:03 -0500
Message-Id: <179381862329.2089669.1920221634983746197.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=659;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=tKyyhUM8sc5ijUZp4wf8V84jsKcj0GIXLoP8Jnk85qM=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq64AC4+9Eu03z8RndZYwobpMiNfkTgoWl1nhsO
 iersuVtwoCJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCauuAAgAKCRC7dyhM23N6
 3n+cD/9jpTwQSZe5gdGUGgfWk1XEfJgiRBBToUCD7hLIUPN0f/0cdUwMSaewgWjnIEdWwmUI3cX
 AQ2dyOIItN7AdmFr/dPD833nnnX/GdMvITYVd0Xp9A+ElDgvYS2cRlizoNWpRZVgIW49L/KZ22x
 Fvxr8Vctlg82aQ1rWm4Bpc14mlvduoD8+N8LVGG4wFoun/qTG4YvaV0LWvtGBLHZmFYLecwnDGJ
 IZJ/Uz5AS7D/VdLvWF4RF+7eJl4JMt6gTQEbdeVfcZWZCX+p6vOkkyX24Iy110qrrdvVFaufjpr
 XseoEn/cLnxiIg5Yzgun4qT+CpoEn/W8JjvwznOw06geQzUafuFQP8yHbMSdgWfOiB6HkfPfoCP
 QIALgM4Q8u7r3PcQpJd1VnQTXuWMPCV8vEzj9tiw1TJvhkujDlbDoe1JCPlwBAQJibSRhqvfqec
 l1dQMbzMd2oC0wRKBz0NKMkxxZdbYTt1tKClUM1hLhwEyqqi1yzARs6jOnIr1X7Ey5qOPYZ5ouj
 KFoj7dpUPeJgE6Gk7vA7t4+VOXxl0yO09J+ST0GTgEGrSmaHibGONMY4E3yWtcEgJTz7a+koxFn
 J8DSpcUQhLmuEq640zd8Nre2wC3ZFqAsZH556R6i1tFo/QoV0ka++Vany7L1zJajvRx9pUeiLPm
 cZDHnRFI9/6kMmg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D860420006
X-Stat-Signature: prr5oo7k581r9e8wof7c5x5ih434s3zj
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793818630-949629
X-HE-Meta: U2FsdGVkX19NmTW/imjMVl6RajPEijx/I54WLxGYDWeqBzpn26Lps/IIeJ9v6jyXXfpQpljCMKUV8UWIiNNYUtual9sIUvjiEZCrLpztMMirvrAMR1TazHnMOaxwit2DTg7/+PyR+VsfVw8YjcedEeYaEx/oy5DG+AD+Rk6cGDkBpgZmZEAFfeodIsXjzEUTzZIwUmCr8FHSEmuWN3KXhLKRyfFgVfb+SOll7aaD4bw4Fc0hFQJ2+3fI5RtUgdRvSqUModavpjyyDPXMN4tTx3sSJUU1uAGCRBybd86Sb+TQMMaCskgV8l47+jEdZKPJbIO5igEBtgSbnDZ0XaK0qxeV2tOmPbSLKnlcfoT5fFqZHR+UWJDI0X6U/e9MuE3XV5P0NTLeZsCtMKl10sM7zfVYdlXJgLBur7e5zqwM+SIevxIxM4GiqNFHn3mD5YQZNuIFEhqVBAGWfC3eg9gXkwlO0chaAUN9cTRrad5f0PPSRt94j2zTcS+BSNhojBU5iYF2GPJLdfmrlnyfGKsb/a+LEZDhjYlSanz2TPK+SoNdXzJHaAnOB5WpHnaD5H3fUlgII8pytgOe9AkwDGarlw1/3WOLdYiuAauuP2061nRKbEpC68JK12pv8idKygmYoc2Hoi9XrR4p5JBtlkrgUA0Luqjy1jhQKvYTfNgu6ZkKMcZBtr7FQTlEMjQr/wqsANXzhjiozkciQc0r2zQ0jc+ZTFhQjj2BPFA9ZirQU2LG9+xCExOBy+0Fh7gh6vDINqSrGot9aNBI0QTirRdAugewJH0/obxmBiUHzcxpacbu4YA2NMezW88cygqOv/2viYFLGF0nkhbdJfoA8bzLmt0D1RD16G4Yj709jl4kWQl8lmydhiWHJW1Ycv0X/2AaBeNHDRyNwwCHv3wD1ZBLnAw+hvSltM/9A4Mfzbwx2AXsMY+hwpxt37VMmMFBwepXzEAoYUk/WAogBKSPU2p
 1pC8AMrq
 LstP3bqwyU4CY/eIrt05CU4W7sMT7tVKzGz/ehzlW6kO9vPmAPXyioxVRclBZyHl2WAsS++MqFaEGL+izS0nNYKmiQpLU99suODjZxqwyX73wHmBrmrKD6uyM3/OOyTPubGw+Lh3NM/4c4PLbVK6G4qzPVE97+gFkr4D2NeIVJCRk7iHVu/tZlB4qJTBTc+igEIO6cfQ4oL8BboiBHSycTpRYyzzD8k1YtAfinIjD9g5xP+otraoXlBYkU3LZ1bKnizQgH2/cWZZzu0F6M0kJaOXM+iQRLfA4GTGAiHX9VE6RxHczhexo+IV+L9hywMcZqOtEK4funJ8QKW5Mo/4XlLSr0GQ7pllijitaZd1N1dy0SGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 18:50:10 +0200, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
> The lowmem and the global bootmem areas can have zero size, for example
> when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
> either of those areas is explicitly set to zero with kho_bootmem=.
> 
> For a zero-sized allocation memblock returns an address without reserving
> anything, and that empty area is recorded in kho_bootmem. If there is no
> memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
> fails and KHO gets disabled.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


