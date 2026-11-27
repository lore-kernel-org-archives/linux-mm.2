Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E77606A326
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BOkri58r
Received: by kanga.kvack.org (Postfix)
	id 587CD6B05B0; Fri, 27 Nov 2026 10:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511EA6B05B1; Fri, 27 Nov 2026 10:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8046B05B2; Fri, 27 Nov 2026 10:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD2C6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:23:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66163160413
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:16:58 +0000 (UTC)
X-FDA: 85481251716.11.B13C206
Received: from mail-oi2-f7.google.com (mail-oi2-f7.google.com [74.125.231.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id 534E110000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:16:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BOkri58r;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.199 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795792616;
	b=QIpSU8eetNONXOHNZ5CqAmv9uHpUJyrljw4cY87NHgxt2BleXbB224iTDEjKQZJSPlSwBg
	ZAOuDCNU3TZJS02icBTwcTP76OJVSz4SnR/rFYeNw8IEeuWEn82K0PeHlqOKd+xth6xm/z
	FbbBNM9jJTrfPKx7XlwsbP5EpdgQJeU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795792616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKJEOGB2qR3n5O+NBfOIRCus171qeQh6oDMROmsXEAo=;
	b=5c+fHF62tjJRS5CHF2lq/F0t5ulp4xsB78ujXzJYLyV140ieWuMm6TXeg8fdDPLtvjYcD5
	zBqXnvVRB/5GxGsan9DgCN0+c3ic+wGgwpD1whbI6e+qQlDf5FJqoX3dMQZFY1SobanOnS
	6U8XQJpobXqFPgxHm47rKm+bMaB3byw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BOkri58r;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.199 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-oi2-f7.google.com with SMTP id 5614622812f47-4b39374fab5so2905363b6e.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:16:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795792615; cv=none;
        d=google.com; s=arc-20260327;
        b=qJE/t3NYO0oW8yDbadh94RGlFEDHY8HAIh5kWEHSlLrsevlIP0KjRgcsCuzNpCZZI4
         z2FYRWs/iSIxcQgnFU9vdGkCwbMeKWqHrA/SP/gqvUctIypG0kFrEEkS/OE6p4OpcqUE
         R4eJAIRqNOH8rbC2moJba9IfGBt2wo1L3Hczuc43dlI3IKHYtmARCn2ZvunIXabS1ZnL
         nEYwaBKB8pfPIwAhdPb4rM4MeU6cxcFluRIkWDlu7BKbWWIDajmUZDYH0xBCLgJXqAPZ
         nY54wJjTvszhpeCDggNG4D3uI9ascE1R2KgmQ7/D0F7XzDOytc/jKtP2zKAYFjXqJxW+
         7iuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WKJEOGB2qR3n5O+NBfOIRCus171qeQh6oDMROmsXEAo=;
        fh=MxiSB0LHfhva4NCKKcqiGTVdt55+L7OcmB3pDkjLMm0=;
        b=Hj7f2b3t5mqpbcLOSg/EJqLG4lpN1T6roV4YvvOTqxjrfp+XfmdpW6SZmiGoCYUu+o
         Tr7KOQUX/1TDUivI0TP+XeJOttoon5R5NaR0cE37jKdm27PXWg6moXL2v/0OrVgnpXT1
         u/7uMTh9mPG+KqX5TGsMu3ojAG5IcQfuR0lvjQbOk0gEulMSZoz5UvjdId5VoOqJ9kGO
         p5Rnwz474qyEOAgsKbniNmWXlRagkNVU1H8cP/ixfnpX+KdDLdRfiApQullLIzrQF76y
         2+Nkt8+NOtWo46kzDiZG7T5olFoDe/8QkVQ5zrq9DPdwHhsgoDK4ip9+2shUV0aChtea
         jZ6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795792615; x=1796397415; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WKJEOGB2qR3n5O+NBfOIRCus171qeQh6oDMROmsXEAo=;
        b=BOkri58rodBuPeVy3KZV2QHm90xcgqORXdBE7Mz5uXebWiYYdRnUliEsLtKhl9qbQf
         VUr4Lpvkqbstuz2qMzg7ehSW5UvkUujhlWEfyCsksJ34zusPzjI4fxSwMybzIJdgGgSQ
         z6OFhWxVETKuYhQ6/x71fFAyCGUBLvxku7IbgDX9ixmvTY5IqLb/VDt+v7eeHjEoi7GF
         ReaS4wCqPaL5xkLrIaa35BcgOxD2V8H4FZa9w6cEQee1+n1OEWB8zotG5elR86bngycR
         msSVPWrRAsC1DDQOa+Sh35gi/n1ZbIzD6/ZwzOtBg0/uBzZOPM2Uezl/VrJ/2tuu3rZx
         Kn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795792615; x=1796397415;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WKJEOGB2qR3n5O+NBfOIRCus171qeQh6oDMROmsXEAo=;
        b=FMHw4/ELWTGHyDuGwxt5qXegxicr0Cc/tmNakJrqvSx2zMaAFh5HaSUVMF2W3oFxFr
         U0R90pFbPKddQWc+JxZpllrZZCezir8uKMkIKqAOFVy1LuJr3GBrnacCJ057rcKVaY/w
         lvlgvRvh5kvcC9SxoYGm5Im9EyaxTQeRrvnomoIfmb0vu0zRr7bXqN4YpOvH5mDc8JId
         IWHhMZdqbiRgukbP/tvQHb/t6KcYrgcmtzX6ktcyZmno17N+d2vybkbBykRDG5pkLffM
         Bb6kbcrCof2JfzZz1zcQ+rnx7kNkm6cpWS6GsSkD3pKkzuvDg9D+zxWQEkA9rcmkR+mC
         7AsQ==
X-Forwarded-Encrypted: i=1; AL+hErFd8MWASQRIDbPjbQYwMrT9BSkjgZSDAT9jQUDs62bUjq6siqev7ybhJRyQkh70sA16GAaX68a3jg==@kvack.org
X-Gm-Message-State: APuU4Z+B5baP7wfL+xvMIHsLEEt9SH210ea+M87FoMjaihT7B0i0V82a
	0CVFbqoPtjuOYZtONHkydILQEQX77thexvmartPvea3P8c2pGO+CgyGiD6i8IAB8uOKuCG8PsGI
	oaASJX7gfNtv2NFUGN8x3Aw3BrvE1tH4=
X-Gm-Gg: AZFdTZf1GoCZ2SjKR0DjwvRWbWgyhSQ4n0F1nLIyrrA3MMRYZEkBbyC/mmpS0Ng5SvR
	HFA0p7FY4rAGzoljnU1tK0eRhxG09/Dp0/KAhw+TlUYJ1lqqAF8bc0+F1lFj2to+AcTSVApbXFy
	NKnJH4RBCtTwhuiIXRbijK8w9e6inCgC4xfSFb2D0ATITlphwN97UmwJHZHdxx+ProPg6AwVyJp
	/aGRnVmGR5Bi5lYjGuHbEzaFHRoWzkSR3dWwHFVpC3yEzse/5XWGP0+nY1iiQeZO6r6E0Aoy3pB
	wfSUPmRMn2sLPr7RiOeDPWf2Y1Xd1FGp1LOAOoba/Kz4DajfiZANZt/LVHnLffE4Xa5q6HTLbIl
	/LY8NME32ui1FOGDlwR/+6KbdWxQ2MIHKgON5CtG5FBPpkftVBnW9ZpfCZ/44hxyFO8FcnF9YIQ
	gV+kqquX7Zr1KsdCVH2Z+NxLaMToM=
X-Received: by 2002:a05:6808:308d:b0:4f5:6fff:3ac4 with SMTP id
 5614622812f47-57a0ba54a49mr27736031b6e.41.1795792615012; Fri, 27 Nov 2026
 07:16:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261126-hugetlb-subpool-pending-v1-1-e1831a48f19c@gmail.com> <c2e176c0-1ca9-4624-9a25-7ae0d66710f9@gmail.com>
In-Reply-To: <c2e176c0-1ca9-4624-9a25-7ae0d66710f9@gmail.com>
From: Aveline Noir <jm5905938@gmail.com>
Date: Sat, 28 Nov 2026 02:16:43 +1100
X-Gm-Features: Aa3M54omQG6k1tjvW6S2RRc1ZM35XvhNPARpZN7xHrwVNj9S21LCHp9wsG3O-qc
Message-ID: <CANOyQmHNmsc8ZWZ4cKH6rNgYN9Et1BpKFrpZs3amtAC8VOw21w@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: track pending subpool requests separately
 from used_hpages
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
	Karl Mehltretter <kmehltretter@gmail.com>, Ackerley Tng <ackerleytng@google.com>, 
	Zhao Li <enderaoelyther@gmail.com>, Jinmeng Zhou <zhoujinmeng@bytedance.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 534E110000C
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 4qjt3n663skxzu4fc5zommtg6ugi4mkt
X-HE-Tag: 1795792616-802364
X-HE-Meta: U2FsdGVkX1+drccQe1KhHqinR2rCgRLzx4eFbdQelz2hnUYi/NEX49j/4ZwqsTJBCgYuKLpydsYXMV4sL7qZ74SUV0p7L55SD8rT6P47i1XkW6gcapvhQUtYvXvym9kJKpyQZ8rFjlMQizlVOQAuWMEdnCG3wvA3LZOqs/3RcCcxg688qfSKe1xD3rRdNzwbVrGdj9r7uvdeQyQOzFO71+veYfmkcQ4cSZu7eNRKiL2ty5H0gPJxakLMDDuJZz9zreKN7Uxd0ZBsvEXXFmxd3WrmutFqAxKIsbYvsTJ8BSJdhJQn0+fbZewL2L07O0fNY+wFcgtiuqRtv+QrrEd55T/EmctnkoYAcimcmUUzMAClS9YccEBuwdncHfZpnkNIyak86AI4/u/stxyiErHzNzK6np+JF8um6OsSIdTtyJlQOsUOL1gZMr5WiKw2fFT69RP8n37aPyDRwO1M8VwZYfg6HVzULf3fMxPrwPO0IGdRySPSTOqLiDulyQ8/ouSCSBZUXrt0ZCRz6fgt90FU7S0aKqqeTIalVa4RCNVg7YqmRROEQSt+dAWdIJePQsH30Yc27lcvHIe0w6BY1cFsoNHFq/YHrp5DxhTssbhEaZ9GytbULnRzc4BVlFLv87jU71vz+C5LxHRQPkOAHmNeCWOrXys0hktlbbvuF5/vEXeWXrOS9nMTc9LgUZHf5ETr7v/nVJO64JZrIbqAPWZaxLDz5CxXhymZjXP5JOUxbvPOHZvWSz8B+5Lgm5PNloBLBGzCDG+bSDGYcTSv1vg7dvsERn4vpoWkAYpTd9NJv8kGRbQ+evOEq2b90hGBvdlfFkYKEYv6hnr80BCYwa12d+Y7Yk+/AE7g1SBhTZEeU4xHK98LhJNp0LD/Tba0OEDaA0f422X21mcVb6QHlZhKUSt58WsZSpdiHlsGCqbU6CS5UEa+0D4OkLSnn6hWJa45aWYf5fmcr5BawX/9nCg
 O437f/DB
 Dpc9j80msvuaLLz454ux0mW5ZkAVbHPmEoKDjYoVuqF813UZKLihHPvh6TpD3fMkWp/rcB/NoV+nj3Qr6eFs8PjaDDsPqxlB3wx/1neaRA6pP4cPTmI8ZWKAL/dXfj7HiAcxTNvW7SuZAvMQxN0QxazdzXzz2wC/tndedDCZbZOYIgZlLIZgywgQVKepz0l0FpWGwjElfwZbqYeb5XBSYHQ+IaO9fzQNArvftJf0d8Tb+7AdqueKEzZavCOZTZSKDNB8+6VfHE61RnWsY9SR2anhsO34Xz3XQO68Nh7O2DqRnMzxWK00ZSpOVBPevZYPVJ+A4WPenF3LvooUDgnkXfYCOu27aCgWF5WO2ZNmMDnV+PODYXYc8+dCN7L9dnVYvf4VTZQp4ektvNeyH3rj1AgdEavlpHKkWsYP+EvbZsJAt9ot8JckStWRLaw+ii4uerORJp/u6HF6LBeaYufLAksH9/3mNGDag27mdVaFuI3tXW0Vse/6YGTde5jzQ5TqequfsIzhlDMIayexfXni4jd6uuw4/skp7mbQCpXZdnIU6Uf0nVmzwH+pVxf+eh8NBLsbwE5XvJFKg+NIdyEjB6+ggIPVuhEjdoVLOMCUIQOCnZPnx55xa+q0FJpRNPE84oEZkOCjCvouhgQb6uackqJTzkzDsVzSypt+a6cdvtabpfbwjqF3WScemghmgE3k01Cq71vlBK7BbwpA57mI69bTtNdl4iBHMgHNOXJSF4vv8FEuF15oKuAqB8EY6SuneViPfoZBOpSIeyXC3fkAnvo+KQ8CLKpfCwStv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jose,

On Fri, Nov 27, 2026 at 8:52=E2=80=AFPM Jose A. Perez de Azpillaga
<azpijr@gmail.com> wrote:

>
> is it possible to do this with less churn?
>
That make sense. I'll try it later.
Thanks,
Aveline

