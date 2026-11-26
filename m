Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10AFD606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=P20P0qzw
Received: by kanga.kvack.org (Postfix)
	id 20AC46B05B1; Thu, 26 Nov 2026 10:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB2D6B05B2; Thu, 26 Nov 2026 10:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AAEF6B05B3; Thu, 26 Nov 2026 10:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF59B6B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:02:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 692904026C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:02:00 +0000 (UTC)
X-FDA: 85477585200.10.5258215
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf27.hostedemail.com (Postfix) with ESMTP id C4DF44001F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:01:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=P20P0qzw;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of "prvs=9790d755d3=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9790d755d3=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1795705318;
	b=VZDFYQG4sDO78+sNvigwgjIvxTIpyWEoSKrKDRbrO2pyh63hBoEL6itpvhksHtFGaLhY8I
	Z2D7CglFN3SKEPmXNXZ/LDAdqTgq6fsY8qgqjayl9bmwxdR8NILMtzrydxPeTMqmFf51Ed
	T4Qvehv77SEOJBS0CFsLRCy8+SF/htw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795705318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksHsU0kbsqVUkEZNVmcgFe4AO3w0i+7EkE+yHh4jTrM=;
	b=5OoOunNor+DI0viXTQ/X8ch0S82A6taNqur2Xg4KG8sIvt39sp3p8Ybd3X+bLv8iyQUVYR
	ckSBfqRM+cQ9zOTb48lVAHdoxehecjFV6RjOh/1AQ5ZKYkA5XSKR6/VznwJYX118mokk2f
	+aFYgfgWe0Q2poARvCe3HEtRqQgRE08=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=P20P0qzw;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of "prvs=9790d755d3=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9790d755d3=alexghiti@meta.com"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AQEUcaO3866359
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:01:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=ksHsU0kbsqVUkEZNVmcgFe4AO3w0i+7EkE+yH
	h4jTrM=; b=P20P0qzwdql3dJs55tVw/zSzER0pnEDse7ct7RVGedvqKP1wlaPFt
	2s73M5Y2IlukoczLKpiPu0XiW/qLarOOrkPmrP2TCHeRa0jx8As94si2fvP+lKkd
	2eNagtp00Z/AB6j7OnOoAuwuiMms5RE8iA5/uTUwzM8rGADXF60qRBA6Eb54t27L
	tyFd5dsxxp4AOKwfcv0BIv95oxDoozVeBFGbjIkFis2h1Bdnp1E1AxqoV2iEMzRg
	aH1G1eL+IPsXzC1At1XQHo/CnQZtoYWBvB6+Mi49vKJQP1n32Kxrv/W4W6xXBSJd
	NZtyf4UXDuiDA28Cd08oevAIA1bTncLQA==
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by m0001303.ppops.net (PPS) with ESMTPS id 4j5f3gncnx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:01:56 -0800 (PST)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a5d57a8d51so726124a12.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:01:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795705315; cv=none;
        d=google.com; s=arc-20260327;
        b=lJCMZjYWBVTeoSgwVM1acLuap1DeoTSLxnQD9SLrnzwqxd2796vKnW4LGsUMXvqyW+
         xUZEyKddCL9oakTb9CQzQ8xbKHS5zpd57b1qfoqv+yWAhtInScskhx0Cwj+HZhgFF+s8
         xbPYAKpBe767hmuBlaqPmPFmXPzPAXD5bnLnsj1r7LLCt25wisGxFgSA/OPq8Q8vxu5e
         ZabCgi3xTB2bVHovj8T0A0IbDFqqFI06OO37YbSCFg56fHrylOd4H6dULeLuRexUd8bk
         p/F7eFQP7HfDTs9hH4XyAAKM6/uMIPndoHZ2MQDC1ukMXcg8U3ezTwxDDVO0NdWW0JAU
         h+LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=BqPHn9TvziiIAHrsauOPgw6b2tlMG6ggA0GmAWeOUhA=;
        fh=Lm1oxw+p7VHrsl8N/VLnsf4nTbvIZz81L0dW5ekWQB4=;
        b=hspQ5sZClRNpPVCkm9eClEAFZncxHUlo4ctAXVEP3GD0CvObBV9+Kmf4pXVhH8MEkw
         88zg7LECbeegJcebVZKd9v2b9XvOG+IeYBcaC2ss8mZM+5GtoXSkfG/EJgKDwPsvHU92
         Te0wZRxcXUrGAaKSvFNe2zbWmrh6rpZvMdngDVkc3a2Lt7OIBhtCofgpALPKBlHY7ZI2
         xEGXm3LrAVaN+v0z+gdZSbagfICRbhFKs94sp5ML+cVpPtOBRhpB9zaukZXkTB7hpCsi
         JSwf3m+SR0O24Oh1BzRRNLHivzntF6p/BEdCW9o7vGrlJE/Fn7MaqpHoD0f0fGLzhc27
         o7CQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705315; x=1796310115;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BqPHn9TvziiIAHrsauOPgw6b2tlMG6ggA0GmAWeOUhA=;
        b=wjoRMllEnvhh9jAUixF8yvJVbLUyAU8rRN21xuuU/ALAywwZzeakQK+Z8uj0rsifNr
         DHr+95oI1c5/lWb8XM+2ZGkxMOo/luysNlnk98rLu7zSGXnR2Qy2aLFFfVGP4Rfppq71
         YEJ/42MTrxeAWxTFIAXVOotIcTQI3eZ7vEE2xB5hHQ1JHUhLnh222g7aE/pmBgD8j1Ty
         0LzHwsPLdGdaKMCriZGmkoRUgLySCkE6Vhw6fjJRkdYXc0wOUdFbl82gtARHzUnGU5Aa
         EUfUvrAYIvz21x/SWKgNISVsMfigyUIXY4oUSq24tdqzj2pFweeS4WzZT5r/zNdKyUrJ
         2eSg==
X-Forwarded-Encrypted: i=1; AL+hErHpBOPkY4sxmAsVG3ocBlOWNxLw24QaSQOWMDMgn1orhesvfmgGJOA8uxzkvdEj9DobCYFN9TJ/fQ==@kvack.org
X-Gm-Message-State: APuU4Z/aPun5FLMXPMRgFeb6uhwmhzRo7Ki+QyF6+RY2e5Gez1jXMzW3
	geC9htErZgyEUa7KuDtmxreUykbXXvsv74ug7G8EaAewNTzTmTjSFC1689Tv2IPPMW4nAmPRf9d
	+tK1IGXQX7Y9pMaNNj2I0xlok9oK4ZLiWiXM3RSlc5y0zYqmlTL4CmrvTugBWVfqYQDZ39zKxA8
	wWEaWERKAuCY78rKPRr+PfShkBHQ==
X-Gm-Gg: AZFdTZfmBvIlwWKH4+70FCy73Xbvk5yWhW4gF0wwUWzm5NIkZclC6qBhlAEpMyiQdzq
	6+kN/FqsewJOMxDSkITbySF4ux0whJLKgT5ESJzcUFPjCL0GlM2Tu1lAZfwa6xRVbgSRsdgoSz1
	w+qhbIkM13BzDH7RyywZ5Yqcezimhw74Ur5OPYaUKozvICrLXXjtqG/3XbviVUt3lamN0eSiFIM
	hrhbO5PRmUvAX0iXg==
X-Received: by 2002:a05:6402:210e:b0:6b8:6e5d:31c8 with SMTP id 4fb4d7f45d1cf-6ba37d34b4emr16199789a12.16.1795705314593;
        Thu, 26 Nov 2026 07:01:54 -0800 (PST)
X-Received: by 2002:a05:6402:210e:b0:6b8:6e5d:31c8 with SMTP id
 4fb4d7f45d1cf-6ba37d34b4emr16199723a12.16.1795705313703; Thu, 26 Nov 2026
 07:01:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261126094318.244973-1-alex@ghiti.fr> <98fecdf0-6409-4499-90e4-63996f33db90@kernel.org>
In-Reply-To: <98fecdf0-6409-4499-90e4-63996f33db90@kernel.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Thu, 26 Nov 2026 16:01:42 +0100
X-Gm-Features: Aa3M54rDcsYyFryAPjZjAPtJPfhPSO-4qzJEQsClg3xH9Aj6JUbbS_UM0fHTqdo
Message-ID: <CAEmasaXWwWeuQnMbA+g8OyvNwe721Dro+1h+5pfTpzLuV6dx3g@mail.gmail.com>
Subject: Re: [PATCH] mm: free the swap slot of a dirty swapin folio
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
        Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Baoquan He <baoquan.he@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Youngjun Park <youngjun.park@lge.com>,
        "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: ajI5tn2-Y-wu1dlOcdPjNm4lKX4r5N7G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDA1OCBTYWx0ZWRfX/3PPc0NZZtNG
 v7mrs2HO3XEKSSHupzkpb9bX+9q8KYI4iNAfBJGrvOqbS5vLvY3UWzd18rSsaKPJ1MUE79rGQD8
 89GmLSc6YdFtuxBYreLWiGhqxhOO8EU4tYXVkxBsEB62ZpyM6eNMl6ZNun5vwFIuBNWcU6XgLky
 BH9qUfxpTihBD3ffFTyQqAim4AocYdaP/6l8ry1o7pcvS8mZvEgN5V4zj31RZ8Rs+i5E+k40y0q
 V0nysMeD7TprDCI96YHxke1zf4JwEyS4WOCvmYj8useCOQmpy9uW/pAQSEow+WGl9PACPyMcGLw
 x82hBHoQ9UTAvWg68LsC8E8en0i1sqoXDEj1xA6sgQtPXwrmwvF6CSty9NBfA7FXU+YLVWRhB66
 v9AT3IDprdmTiah8SrT1BIMouMO4HFuvFYaJwqnx1DyHrpTD8vrnuWwpqcaW/tksetmEuDKxZ6t
 8oekqSmnnElBExDQdIg==
X-Proofpoint-GUID: ajI5tn2-Y-wu1dlOcdPjNm4lKX4r5N7G
X-Authority-Analysis: v=2.4 cv=VZNir1p9 c=1 sm=1 tr=0 ts=6b0849e4 cx=c_pps
 a=9KvDgq78n9V61H3VJbnhTw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=oIRQa5m1TaVr89WThhUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDA1OCBTYWx0ZWRfXyNhW2KZZZdQK
 S1amRdw+QPpPrkkQxIL2eTbgluOQlUtcFoIX6pfVDYYQC40oMV8WaD4k6svvZsCwfr1qq3AKDQV
 OasB2MeOrjJWzhIAvdWat0saoIJDN8A=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_03,2026-11-26_02,2025-10-01_01
X-Stat-Signature: sibfj8dta7cn4zrq3x73zzu7s4qpn9s9
X-Rspamd-Queue-Id: C4DF44001F
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795705317-619581
X-HE-Meta: U2FsdGVkX1/wm4fxViTM1TmnHyLtNia8o3c7B0SomfoRHF0E44rgdNOm/j8dUkkwVgpby3lpFUiQKg26kjTrZxOeF9Z1G495WTCRv2sL3T7e3mxecpv2wp+FmqgDkinvqyxpmzYYRtyRaE+DL4xddO5HtTBpIUoiDpvu4fr9raufXPYcQuB9wY7n9wDQ8bDeGO5QlxFCkLcSoNeWzDEU8goZeyGKvvA5Hk8bVeaK5W+lmsgeDGewiU4BLNF/Mafsy9nM6EKUYfDylbOvwAnDnUNLtQdZoQYxGyCFoAQq32y/ezyBvE8cPe1oNIrJSCIMl42amYfVxiQuwHRBodsV7MiqZLJVrNOAfXUPhL4ct+ZWqy/PqBC+wbJWxW6FWNTpira2TV3Q6N20C3QuDRuwKLoifGWsNJIuSqsFs/U0pNRjb5FOQN21lfZWV4iJB0YSEXc4JJ6a7eoN/XHzYor84JortKTVtmW05CvSLIK5OKC9Ld6YFIV1h36S+g+9tekjTNBnZh5GTWZjxNIrLmJc9Cz3oDzd67VmamCSFhMcwO5OUwyViBzuvZdn3RtFBg4H3dyFcFtydjoTjYStJvWzXPfgtj1r2UfFxZ9iCICTnK8cMBdMj9w5oqzK/YwL0GJ7f5VsYcPkczudEKGEfX+dJtnCzdkPck+P8H4i3w6zZOPC5OHmQoqQLf7CnFVLnjWnwhEN5ChHj2heGR+aeF8IVQ/jT3QR5EBgTPkxD0+3S4BBHR8Y/aiVDPJHTg3Mil6V6y5jriyUTl/XvmoyyvQY7WthMPDsH/QZO/qL5+78VO22IU+VSv0ionoACchj6cOQDTtQ03Q7Yz1Njxm0SaagFbiytksTSW8/h0YeSYZAv2OlsxfkaLbqhed1tAupnvcuMDYzY7bSc3I1/vAnUPfHUeDbpXiyG7hHcaS5h0lpUbPx3QOVkbMCCmVzmP3saxCxQqS1O4RQ40Lf5WfZ464
 6XPY9YsS
 QYPgW3ZweOrnm/ruuFh/BS6XfFUSHPDohFw9RaleuIoLSC4Zo2Y9HWm14/JCRdxrfsaSVUaO4JVI8l1S/uHo9aSzEy9h5dgsD2c1uy21zIyVNHlvhhQ9hh2Bk375s94g+/DOuNVvnpi8JOz1rDqMQZJ/NLfz0mD4gdiKTpZq65eSqK9OiWNDq57twaGBgJJ3VCFc3kQh0OPmB4YhyxSJvynR8hM1Wq/u6d+SLh2nn2Y+u014ksgmJJMSNqqPOIHe/ziiqdvzIYL0sKtohnxHV2zMOE0mnTOYdnkKPtRo6IagZsxaDWBLUaNiaCy+9X5tcNSUqqpxkMaC0d3hykxXKTVrz7B4QCiJJiV2klt4/Shs2SzT2mWINUt+kAKEj02TTn8Ug2qTpAl0WnR738lQaplgyMVZ3SaL2SwaZxim3O/sUkyZFyyKeoFJVZW5QaH/hR25nPUHtD5J6VSOyyOirKEWUObgEXpiPzWEgeIFfTVPjyhMRqFov4wywN/y0RPk1q9vxP6QRyk+oPKoY/06wf2CfB18ug0h1mjmmZQ2F9A563lywy7iKLMmQGs4dIqvNAtVGJsy8zvqyiy8I2DmvMG+Hco9nb4MPByoA668GWTe0JaHtnkv6k4VZfPRAiWirjjReOAz+D6IQttrWL5MBUSiMXjksSGtJSJUxCwVHlklVE4/BtteSVz2lWryL9bWAmg9Mxw8CoKep7DIa8K2hxdEGL3GCPQr03GTxBkrahoJdj8pPgj9X0IKw5U42ZyWyzUIDy0JuYpQg3GVtuQuyQVHDGr4aA8sN+gynuQsDGEd7R3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Thu, Nov 26, 2026 at 1:54=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >
> On 11/26/26 10:42, Alexandre Ghiti wrote:
> > do_swap_page() frees the swap cache of an exclusive folio on a write
> > fault only. A folio loaded from zswap is dirty: zswap drops its copy on
> > load, so the slot no longer holds the data and only reserves swap space
> > until the folio is reclaimed again or its owner exits.
> >
> > Such folios add up, and they are expensive to free at exit: on a large
> > production workload, the exit time doubled when zswap was enabled. A
> > third of the increase comes from the folios left in the swap cache,
> > each costing about 3x a resident page to tear down; the rest comes from
> > freeing the zswap entries.
> >
> > So free the swap cache of an exclusive dirty folio as well, so that the
> > slot is released at swapin, as is already done on an exclusive write
> > fault. The folio is dirty, so it would get written out again anyway:
> > the only cost is a new slot allocation on its next reclaim, which write
> > faults already pay.
> >
> > On the production workload, this patch removed that third: the exit time
> > decreased by about 15%. On a simple microbenchmark, 4 GiB of anonymous
> > memory in a memcg pushed to swap, read back, then SIGKILLed in a QEMU
> > guest (mean +- stddev of 9 runs):
> >
> >                      base            patched
> >   exit time    989 +- 24 ms       502 +- 28 ms   (-49%)
> >
> > The cost is paid by folios that keep cycling between zswap and memory:
> > each reclaim allocates a new slot and adds the folio to the swap cache
> > again. On a kernel build in a 600 MiB memcg (-j4, defconfig), this is
> > not measurable (mean +- stddev of 5 runs on bare metal):
> >
> >                        base            patched
> >   time (s)        592.4 +- 1.1      592.4 +- 0.9    (+0.0%)
> >   sys (s)         256.6 +- 1.5      257.5 +- 1.4    (+0.3%)
> >
> > In the worst case, random reads over 4 GiB of anonymous memory in a
> > 3 GiB memcg, so that half the reads are zswap read faults and the task
> > spends all its time in the kernel, throughput drops by 1.1-1.4%
> > (mean +- stddev of 5 runs on bare metal):
> >
> >                        base            patched
> >   reads/s, 1 thread   37310 +- 182     36889 +- 77     (-1.1%)
> >   reads/s, 8 threads 291937 +- 802    287954 +- 373    (-1.4%)
> >
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >
> > Notes:
> >     Previous discussion:
> >     https://lore.kernel.org/all/CAGsJ_4xBtKGqXFP4zvp+Qn+tb4X7aCvXn+wqDq=
ot_cXR92DjhQ@mail.gmail.com/
> >
> >  mm/memory.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index d477a4f986bc..dac0f0a24bc7 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4711,10 +4711,13 @@ static inline bool should_try_to_free_swap(stru=
ct swap_info_struct *si,
> >               return true;
> >
> >       /*
> > -      * Free the swapcache only if we are the exclusive user and
> > -      * this is a write fault.
> > +      * Free the swapcache only if we are the exclusive user and this =
is a
> > +      * write fault, or the folio is dirty: its copy in the swap slot =
is
> > +      * stale then (zswap loads are exclusive and dirty the folio), so=
 the
> > +      * slot only holds swap space.
> >        */
> > -     return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
> > +     return exclusive && ((fault_flags & FAULT_FLAG_WRITE) ||
> > +                          folio_test_dirty(folio));
>
> Why not more readable as
>
> if (!exclusive)
>         return false;
> return (fault_flags & FAULT_FLAG_WRITE) || folio_test_dirty(folio);

Agree, I'll change that for v2.

>
> But ... isn't this zswap specific? Why do we have zswap specific stuff in=
 this
> common code?
>
> The comment already gives away that something is not quite right here.

I am mostly interested in the zswap benefits, but nothing is zswap
specific here: do_swap_page() can also find a dirty folio in the swap
cache when reclaim bailed out before writeout, or when the swap write
failed. In all those cases, the copy in the slot is stale, so the slot
only reserves swap space. zswap is simply the common case, since
zswap_load() dirties the folio.

What do you think?

Thanks,

Alex


>
> --
> Cheers,
>
> David
>

