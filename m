Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C443FD6406C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 02:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16FBB6B008C; Tue, 16 Dec 2025 21:48:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131446B0092; Tue, 16 Dec 2025 21:48:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0413C6B0093; Tue, 16 Dec 2025 21:48:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E77376B008C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:48:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9411BC0485
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:48:52 +0000 (UTC)
X-FDA: 84227430504.05.5D3FE8A
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 800CB40002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:48:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nT6Mmaww;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765939730; a=rsa-sha256;
	cv=none;
	b=46N73tGPTx7sFgFOPIjI0gtE3ZyfpJnhrSkvlEBdvzITmmP60/26k5wj5cFkiW2AkvXOul
	eN2UiEk15dnU3XjwEX3KZHb0PI5V/nM7h8Sa1GY6TrL7SCg+U1Adg3pzkSFXtvbE6E39Wg
	up9BiLV73t09Vk+aYwMeIAkIF8peXLM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nT6Mmaww;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765939730;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggnpTKjc7CoueWSBfB7b7LA8VoJO3XLRhf05Pp+Akus=;
	b=3vQGIVK2J8FRNpEJStxC2KcHUmqCoPehWGprsfmxVHMAZIBd1kCqRd7EUhp77GUYJMkDlC
	RppMwEEGMDGs0tMjX9k9m6LiCkRyJgvyKNJsuvMXE2UJF1OWBNkIQDye0A/vmiIgP5Pn5L
	tDTcPYCfsxuuQ75JFXZ65CqpTUxKKXQ=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b79ea617f55so461035066b.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765939729; x=1766544529; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggnpTKjc7CoueWSBfB7b7LA8VoJO3XLRhf05Pp+Akus=;
        b=nT6Mmaww/Mo21V7NntEagS60vIBPANRsDFSvGEYCG7X/4bs6i4V46eilqYai1XiJKG
         kKbm4juiRm4bWWU5quQKhkmO68THFSuUZ/AZpHpYMDN/82LSOMgB+v2Z4z7quUul7JCH
         5GCwtBiwvaB9DmHztDoT8S86VmUDDGvCNn5sd9UqPUnvicFJ1MhxuXCXYssTf/V1a4bg
         WX+wam+jxYiW/RxZ+ohWkIRemKhSbukiagJRDBiZ13eS5tZ+9FM8PX2F/UumavVuTixo
         AfSmqGsueprplkfYMAybphi6X7D5JeXKzBZXs1BDxSDuCgYbV6eKiKbPIempRG0yRVAF
         s3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765939729; x=1766544529;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ggnpTKjc7CoueWSBfB7b7LA8VoJO3XLRhf05Pp+Akus=;
        b=Z74Yk3iFX66Xa2XXorTugrl3+/3uKARp57LItoRZB5/ZTHZJAJdd3g4na6ticaY0xh
         EwKLFLWMHT5PxvReZubVFG7gQOm4wFY40rDHWvzOEdiUFNUOeyIKP0kik03mSWI7cd10
         Wc0qR+582VdZh6pkGHh8GulkCiMwF6NfMz90Ng8QZYx5OLEWeoRkkomaaIGu7UyvYQCh
         jUM1NDZSZCoQj2YjaRfH2y4H7PiDfao5M0t8epuTBTFikh6cuqQwd3kS6f80+1f68Y/g
         xvEft+V3M8J5utEsBZd6tHe4eJ1xuNhVSjrEP1x0zZ19MTn4OcW+wB665fD1ZKCsWD17
         TNlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK/ifkjgMYo+bIPOs8MCf0yvoqCd3YDSbMnEXCNGA0vlD/MvFCtiqdo77TVbzBu5GOa/7plLZCIA==@kvack.org
X-Gm-Message-State: AOJu0Yxy+PpzDC56OBVi0wLp043Aj7441khcULF3EyIpSYMM1nkAVjEn
	mNWdu8lo+eTMPczIitelPknqEdGRTvGBv3YE5BwQ+3/8Q4OCUU7QfrUj
X-Gm-Gg: AY/fxX4qFxNGq7a9tgh/fSJMW9aeEmrMFTZTXBfDKJxS0th8qI+/vHULnF+INefofcu
	sXCUrs4PPE6E7HiwRfyDZ5NXgjtDVpsbanjCyClVZESIoZSL+/odMmP0sO3XNwh8NIYPm13mp9w
	253Ueu9RDQK69GADe+X9N43JQmvm2U3pUFfO9Fec11qT0A10cfGOsqGVzmSPEUWHDtetXho6dFH
	1cp2Y6x3W5CJvZTHE9zqaleHfqA5MoeqlpbObKdXUGEdFbNvwWXc/u5AeYUq2DilJixrSx9sK7G
	k+G2qHOE6g1K20oVevGk05ufwz5kKsZzsKrLEYugyq6ryD4kuCGbjdEC7ZX0mXn8AYFhtZjOcmN
	75kD5qiIueTyhS4O0QTOpZxUpFdtMNQqKLb7zPECYydaYAywoWULhcCb7IWFkJRJJwYmG6bQjsE
	qYZ3oR0BTtlA==
X-Google-Smtp-Source: AGHT+IEGzrL4ei4CYURCoMiWH15xVOBFZFp8TlRYA+TPMXKI5GJcECNuu0kOntwSve234QDDTf/kzQ==
X-Received: by 2002:a17:907:e895:b0:b72:5fac:d05a with SMTP id a640c23a62f3a-b7d23a96f0amr1628477866b.37.1765939728848;
        Tue, 16 Dec 2025 18:48:48 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa57190dsm1884704666b.49.2025.12.16.18.48.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Dec 2025 18:48:48 -0800 (PST)
Date: Wed, 17 Dec 2025 02:48:48 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/khugepaged: make khugepaged_collapse_control
 static
Message-ID: <20251217024848.uolcvqwywhpwdibp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-8-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216111139.95438-8-shivankg@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 800CB40002
X-Stat-Signature: 4q7znpd4obp4drjqd8pi31t63985cnon
X-HE-Tag: 1765939730-578206
X-HE-Meta: U2FsdGVkX19xQ0j6A3Wxqi5LIvV7HbA7QgpOOnbDxwfUvsXE1hRdeQ8z2wJvdnILd0iKPmWhEUc03X+Fbul336ijEcAFKkNsJmVNXqjsw0rtW+F2sppMK34Z/uyldw6qq9HbOeaCKtMuDGt55qpzRWQprtHpjKc3p/pjKOSKfJyhzVGY976hglcH1wmQXisa5+Su4YePPxwZuvMz7tgrpTn/a8Dd4rcqrz/wTIQ1Njh1pGRmhzEfPNXj50hDH1JQKujG6ccdt3jVNsgHRcwrPnF+gCaf1KDPJY5ekpe/EZefA4rIsuGQxKL2qPBj1sV7mA81fIjAWR4Vku6Z7j2LydTX8v4/2YQaPflO9ElsOvahUQQI+ASzAlthYLylxqk5SlMKWCmEO2ld2IGx4vDHOu5oKU0h/dt9Q3HK5pdFR6iqI7ce6cGKFBBlWnAqzFI6MLN5yeeiA+Kj0ToXEp2tkcpPN/AQGXWbm0RMrm/qcVbLPUALa/a6QNIqOrNRQKKM7npaM9k7ESLCwmCQFWMyFC1NxJ+J8PuuETrOJxDE+Yq7wkaNjwv1X7EKut1EwnvYRSQjJX+GR1BtxJz6kVXx/aUnawva85UJmMW+4nNp1BVEJgorw9Dx68CjTme1Q942wtVhBvuWMP7QJEGQS3sVOtFbn7LN4uOYLc4uA75q/XMTA+DnwT98El7fQrE87SHrutnZViAD5xYl7ovHAScadyJD/YfGGLqCCElC5KTepGS7NqItSkr3/FI98VYb9SlQ4e/YNgZvinJsauZBrNOXBPDBGYbVIojXOGytCFsbcLtGPo50HkThiqFQHQibo7Bns+9SpzvK8m0aYCdK/rEQC8CagNTRzfJRdtJnTWjlVx4mXV0Gq3UVW9zg0/W6EZCYZeRCINFVKj3TEvQWjhn6r+KHo0O1VbOoPYfH6vpF0KoYtAH9a17IHhkuapr/w+yYCw7nQ4OmxmvRx4O5GtX
 8Zvt2WgE
 2I7F7ZeAeHb1m2tbT7mCRG52vA1LM3YGKO6qNy3skMkXfEctHeUeI5afJhubnKOdAuKFLWOt9HNQycpR5YyWTdmCSswfoC5S2g1KvRx0tOyGsRlP89RaGIjDGNRQrxSJRqh/Axoq2d378U5vLwcfJfy2aLSBC5t7ak/c7LW5V3XkW9zvc2Kgiq4bMiYcdWXHOcRNR818SRZYoTBGj7VS6RNqcjgCtMfSfREuhljs1OQEEKBNxrHUsSQkEkDmtvMSsJNFXVCXoMD215ypPQj+PDfw1EdTsxTJvJf3tcsOWzL6rKKKrl3fltLJqhF4V97Nqdl5OpvGR/3dOuoC2nosLZYNsce3+tzeV91+gkeezUHuK0Q1A8pO660nBnSIlUNO4VS5ZC7en4yCDUqcLlAamjvhfa6cdsUHZeVYaK1kpggYRoGQWBHiCUMRIe6OMOC+iG5M8zNGsLH7TYnV4bwt3nQICUSnNyq7UPiaUwuaMdGo6G1Sqg2157mDmjSTNXBJq4vs1aVB3pthZXoYinQP1qkmJgvKty2czZ99PWWGPl4v3SXfZaV2H2cwKE30phRBEDte2dM/rQYtrfUXqlsM3pTZmbKEw7nsvJ4fSM+eNf+7Xbi4zv5REdtHEWGrRV4kewS+L/NQ8xSYOE6poZ/owhXKW7z8HTq1SdRrpIF5yao/d/kwcv20/sHDloTq9HZEyie+oXPoQM5ieSoolqu2yKZUbFjrtZ9b6l4Sg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 11:11:42AM +0000, Shivank Garg wrote:
>The global variable 'khugepaged_collapse_control' is not used outside of
>mm/khugepaged.c. Make it static to limit its scope.
>
>Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>---
> mm/khugepaged.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 65b1b778378a..d130357a2d88 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -829,7 +829,7 @@ static void khugepaged_alloc_sleep(void)
> 	remove_wait_queue(&khugepaged_wait, &wait);
> }
> 
>-struct collapse_control khugepaged_collapse_control = {
>+static struct collapse_control khugepaged_collapse_control = {
> 	.is_khugepaged = true,
> };
> 
>-- 
>2.43.0
>

-- 
Wei Yang
Help you, Help me

