Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66251606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FLCu6B1I
Received: by kanga.kvack.org (Postfix)
	id 137B76B05B7; Wed, 28 Oct 2026 05:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E7B6B05B9; Wed, 28 Oct 2026 05:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024286B05BA; Wed, 28 Oct 2026 05:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D647B6B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:49:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 589F5160C41
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:49:44 +0000 (UTC)
X-FDA: 85371563088.23.2CB29D7
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D39A40002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:49:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FLCu6B1I;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793180982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OncitmhmKPxQRhu8FlY/GIP5U4Gt08ht3PeyL8T2LDg=;
	b=YYI6gLwTOPvD782ht1TTlYEB2KugVp5UXVGMCXt0FFs4NYiOC0Vxks23bpCSJdWQVkrWfP
	jvy2r4tmlAZbmBno+EFPTiQIpOryP+iR5HAMLrvVPoWtQmhTB89E4NhJ9J1aEM2VoBuXwr
	A95uhVC9oHMwRvstwQvD8yLDsvQdwMs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FLCu6B1I;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793180982;
	b=zgyQkNpfXtFE357haHtxpVrGYGdS/4xeKfVc8SnFFVR2D9hoozu6St+1X6uHaT3IEowztt
	tnIGLP3eKoMmomThP/ARD5zWGhLExE7Jxdmvc+IgguHeLDyaW4qHsauERFWDM+HWRyFJ+i
	lE/yXEOBcEh6IhAncnvExGB9a82+6U0=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c43373ae89aso99468866b.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:49:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793180981; cv=none;
        d=google.com; s=arc-20260327;
        b=dnPu2Kodg3jIgm+D3JQboYen9ZwIALpByzmf7WWbKxhUhWpG/j3e9haeQWhB6eJi/n
         RWsluj7halxtzmrg5okcB6V4BJXXsr7zyDJui+k4WuK4hQKS/bfa9/wKIXqc9Ku3tumj
         ihSWztBO5NrfLjRKe7cvjaEIHduawWpI+brjgVTUezKLwlhOOl2sLRCMtl332l4odI2m
         l+4YkEISdqk3bE0p1LIX2lUTbSpb6NHvJEWTIq8dVG/FkCi8MlgkFyIywePqs0VMv11E
         YwjTOK5G7zN2l95Ig8xrj59QBWYBuNAAId3/jYYAy/Ovm/VIu+uQETgHUwGEKyP/Z83B
         gizA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OncitmhmKPxQRhu8FlY/GIP5U4Gt08ht3PeyL8T2LDg=;
        fh=ED52dNTCxTSvwmRDS9FsJAFwTzaBE0EeDGmdksH/3rM=;
        b=Kd2WtoRgOaNdRR48Ul2XXaTBGajiKznUjrbYNx2WKMHpniPIFlgNaSZ4D4Q0oD3gM/
         2WA3ao6F+d/gzoXsXMgVnrueuKzNYeQdY2W71uuNelNHbYu1YlHlB8c0uAX0PQCf6Ol+
         1IXA1Rb6BeOmp6ldVPENLsk0OGT0xOyqaVuIPBLoOpJ/IzANus3iXNZ3eo6E3W5JMgOh
         glnPDJ5niXgkvnPrRD/CSizjaFpiymMiD/0Mfmw1ynXbJIVDs+qlkABXff8tvvr8z2Pq
         YjInrAefxLfpV1yeg4e62H3oOHn9Q+Sg3xDHGo4aWPPm/kq7lt0CD5b9zba+pQYmmiGX
         pPbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793180981; x=1793785781; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OncitmhmKPxQRhu8FlY/GIP5U4Gt08ht3PeyL8T2LDg=;
        b=FLCu6B1Iu8emGhSaUrhAVFm3Hbv1pr3EoEyVtdyH73YvBfEmUFpkgIOAC/2+f2hlhd
         3yfeV4rKVc8wMSYL7dT/5zlih9Uzx7w/GZoyGEwllGPpLF1dmb7L/E/x0/FrBckPUp9k
         0PO24vm2gRbYSDgF8LklSzUoT1b1IxGC3RS6khGzFQFdxLc2MNmVDfdPNX/rpgFvI03B
         XLB9ikyvrUceyFDwVWlfNN3PXn+H3X79hLG/7Srsa+uQhLbgas7SXC+dToytNTOygnkh
         J0/siijyvUFXoEN3covXtE/gYMb8RO9uIZaSN/0OTceUCTRCfC4KH4EFyzP7b/Go169b
         eSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793180981; x=1793785781;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OncitmhmKPxQRhu8FlY/GIP5U4Gt08ht3PeyL8T2LDg=;
        b=mfgz+16Bn66Gz2kKUppEINNYDGquOSvcScBeh3lrote9JvGttKciT1HyPjNM4KvVoe
         ABgMgU3Tx97EyucxoRbgJGqBs9je5+JgWKxSZuHH4e74+KxrhN+hJ+yAkGybg0ccKJeC
         H5rIuemJHyGMbFsfWk2JxM8vLe0qya8ycMnjArvC7RsPXgUnDQhxIPthMToyeHjaj1i7
         A1dRigQBRnS1T6mZeaBus0Y9FspP96wKhN28F/gOn9NYWOFlAQ2nb+em8eVBLQFhLFKw
         D2LxZAuvIBWWaIwlp9EZilOLnOXPzc+NyGa3fTIUvGsApVWxQi5U/LdIKdhPQVXhSBBN
         v1DA==
X-Forwarded-Encrypted: i=1; AKwUvByyJ2PJfQsvqM2eDvb1BGJ7sO9Zhrmcl7OpiBjCcsHBgiCJN1Iteq3GOG1h2Uwit8GWoBkc/CbFxw==@kvack.org
X-Gm-Message-State: AFq9FYIHVKPtzNu5kDyhCMW/vAmwAo1LUcetgzplbMMtzEn20ASoteoY
	n4GVKRvSzc7tnJ60BB5a+zN6vj0DF++Ep40j8SWsTHi29DT2qbgy9uslDFZd2hETI+ZaoBI2y9F
	tyEzyV4FVqA1BaOQ7C8wcXRnz+9UQits=
X-Gm-Gg: AYBFou1+2AQi4b6u1wcTGWYn2wUPw8qYmJ7303mgZz37fRqbHUzQUvF9fMjjgmWGvwx
	c8lVzxskm4GcL9sO5TX7qjJ7tgFs4smLWmWRVcU53krxA5ePa+VDdSW08W6WUntT4+C6SaX/Oyd
	2SdJVm4zUwEzhCOA5M/RD4f4LG+8k0r2myaZi5GvxkRwbGPVK6O1n5G+JL/Ng5U4Jq/usF0ztWr
	UxgnGbDT9dME+kJrXZVaOp+vb13k747/JNKaJIWH0FopiUXTrWTVIngr1t5qK9o0rauSW6qatBg
	QTRHLQ3WHbZ+wI/dPJ+umwVQgRcOh4SfcwbYAXUanHmRPriXQKEUZ5+lE0AG/EFBppTwD/XGx9l
	goTW4bo6YUgts7AbDZ1AfQbB56kf0qEiv3O+6Rm3FiAj5ZTz3oH+ghvHw5WusHuRSs0j3oohAF5
	xMEtJP+gVtjfwyiRXNSL7fllsg3XVhj4oNZ3Z2LnSuF7qUJhP7tr6i2B2mBijl66R8mGJYGs2Gz
	yEwPuwvZZ6PderPL0SrnJuRzaQ=
X-Received: by 2002:a17:907:d48d:b0:c42:82ac:b6a9 with SMTP id
 a640c23a62f3a-c49bdf7de97mr167322666b.29.1793180980909; Wed, 28 Oct 2026
 02:49:40 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1793027261.git.d@ilvokhin.com> <ed2b0b67c306bb458ba389f16dc92904203a104b.1793027261.git.d@ilvokhin.com>
In-Reply-To: <ed2b0b67c306bb458ba389f16dc92904203a104b.1793027261.git.d@ilvokhin.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 28 Oct 2026 11:49:04 +0200
X-Gm-Features: AclHuK-kwXGKz5n7QFXQ4iO49tQbUX582-rj9xJLuSYR3NDY9XFvg2hsu7UGHjc
Message-ID: <CAHp75Ve71BfcWr++PfQPiOc=OURNn1-cdJey=M1xBVCb0HhHQw@mail.gmail.com>
Subject: Re: [PATCH 08/10] leds: pwm: Switch to __nonnull_args() macro
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
	linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D39A40002
X-Stat-Signature: dmfe3n1wwgdnoaga4p7ihawrrykf4gwe
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793180982-865786
X-HE-Meta: U2FsdGVkX1/ipOiIlq7QDhXuq3K8kfeys0uNHR1hv3C3Yzl9G2iqtNOp2an/jMsdDoaoTJsBET7o8P+p4sxus3xWel1GFtglTL6008Jw1ZaB4l5iMwpe3KZ7YQEHrzVj273tCDxyKVy9PTCoJtADR3UGl7/R63Ovu1Gm2Xk1VyGtudeOdH41yWR5tGcooZ+xWQVYQkYJa2eKuOH2KVEWuO4QxazizAswKIUuWCCzHRMx4JPhoFtt/AZynKPRnSfzDaawIEEechtl97Tow5DQebbPpsdkIYnNyG2lLCeb82V72HdV3afb8R/MSeCMwWd6owBc1XV26xide19jvBgiPKelB5jCxNmhGIsiushqB4dLV2JBlztWYjS3U5WoZyzrNkYS08uW4V7s9LzEthb53PvpOGaQZIZ+SS1BbJlLKA/l1SMeXAe5jjmEIDslscUw69SXwqu4PQ4S3atKL6wInMzBEJMYWtaQSbtxBk6EdwnXe44cZUfM0CzYzHcZ0T8F7knI+8WgHYrQ3ESwOoHZ8RIIBqxyq5MMeKHAzgGHTncCBUEJywxULZMfkh3NZFYpd2pOGvftRy3BbdlUmYaGECofnQFAlQSQHvPfpArYhAqObuTHzCfjfhIQe3oRZJMlfmc3FHmbW9nQe3J4fGIm0YxlsfPauIjQCdarJOkc5/uz8mbPqQ9Qw9UCVPY3SBBGJfC2PPejXw8EXf71WFF1RLC8la2mdwWYXqATHGvxZ3mCRo1FMrX/BSkMXCi60zDOJOVF7bF9Y7ePbBCbBp4EFvXb2c/4pKc8MiK87N3ZkHgHWbjFsf4OcOxw+D1Zxyy4Dsydb+9ok/TBpEb68WbbHCMf1e8zkBbd6Th06L6kFRUsP0taLYSUTfvM2wA5RzTFp2M2qFgnuo+nh8kXb6sGkHDGBNFh/1gn6hgWJMrLiJeCL6KgUEFPbyRCHHHjW6D0/s84L0eI4kLUsBSCRNM
 r2InJawC
 QC9jN9eYGYjVpD3YI2waMtBKf7pv2o2Pmux07e1dgsNVAxuACz9Ie8gxrHwZR0X2VBfkiIEZDFABSUqBxz4S5S91Vj2gP3hA4i9VxEplBeZwP2Un7Xr0ImpwefVbslWd9eAyqC+Q2BUXW7cpdaVei7V73/5eGvLGYrsWIfxEMbKOQHccUEEMa4BmeuFogN5wi5Q9Hdquvq3PLygCyxduECNfFdKo+if1SQnEMbCEB+iu9a92HVtzxjtVO86XPHan4iCGjhXlGnSXuc3RO0r87u1ovBYeWVKCC+zQ7sFjefFOeJn3nNsipAvIJVKyxcfdleDAbokC5bGz2sbw4r+vwqkPELenb6rvmdjsQyqvvAy0Z4sM//AyrxucuWrtSTpfM3JJSXvLYowHk45+zM4np5pnGaFklYtFGyBLiWJLAwz93eWp9JglGr7C5MBwQ0EtPxvYaTfHQR5rm1/LbVJlHZ7Xmnpwis2RpO4WjD3uZk5vnuUGPMr6/T/n4e4JThxRW57DMJEIiYgIOWzjBNV7t5AznoGLmWtVTyDVU5gC1XRWfZFVt4Il00/NZh12SpacKd6biqn+GbO8gOBKkN4URFa4yn9qTxuqoRZHJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:20=E2=80=AFAM Dmitry Ilvokhin <d@ilvokhin.com> w=
rote:
>
> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the macro __nonnull_args() to wrap raw compiler
> attribute.
>
> Replace __attribute__((nonnull)) with __nonnull_args() to standardize
> nonnull attribute usage across the tree and keep the attribute's quirks
> in one place rather than open-coded at every call site.

Reviewed-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko

