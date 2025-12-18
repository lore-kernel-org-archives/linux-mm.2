Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8430FD6E2CC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 18:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79DA06B0088; Thu, 18 Dec 2025 13:26:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74ABF6B0089; Thu, 18 Dec 2025 13:26:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623256B008A; Thu, 18 Dec 2025 13:26:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50C196B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:26:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E78A5C0357
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:26:12 +0000 (UTC)
X-FDA: 84233421384.21.0DC528E
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id D535D18000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:26:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E3DGnsgs;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766082371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GC3r3DONuA6YiYHbbshOdJ1QdT9pjrS4H1t+Tf2/8Dc=;
	b=y8PuKi8zb0fYokCNIHh1EdpkVgsWkNDMRVqadImhXbtf4ZlY3d13dHWuUMWZBa3Skiw+X1
	F5ycxBhByHaCRhMTOcxHH32QvCeZDDEbbfh9f4vnKV4q2F3VzrffL15Eh4pZu52F0Syulj
	lw1MONMb9QP8EEJgWd6ymf62ylOmHUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766082371; a=rsa-sha256;
	cv=none;
	b=mIY2jlZY/KnkYvEo7uuOzp9zwTc16aV0b/EOgsO23g3o5s8DI2vraCAsdIrftIX7/kIdRU
	xyF++HIhUMr0kimKTYBjZzx6WitJkSEQBwZmploqvjUxAQ0WrbcFAmzhZWN23aKNJBVumi
	CALU0LmBrA7amhWAtHyHcuaev41kwtU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E3DGnsgs;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so1599813a12.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766082369; x=1766687169; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GC3r3DONuA6YiYHbbshOdJ1QdT9pjrS4H1t+Tf2/8Dc=;
        b=E3DGnsgs6DKkhJYSpEOzBl4WgG0WwtoU6EhL9CeVDY4HjfshZpKYGQsegeNHujsPWq
         jAXf9gAmj7bjEpmlKNXw6uCWttbN4sDl08SIgSz5qeQEsg0/DGh7YLxZzFJEHBdkM4oj
         GO4X1ohTrMN+C6tXpwaC9DMAB0tDxz3s9Ph0MhMKrUGoHf+eiA5RnjDGuWqA0ccaZkJK
         wKrEcHZBGsSmjKjqqZaHPzof8CEcZztHcOU2n3lESQcEE1h0GF2kr6WGhWeFVnwjOZid
         GxEN8v1i/E7xfBj436ii2iiGeGkzmd3msQy8AH5jLv++qqQOnr06vZg5yWsnqUtPa272
         6/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766082369; x=1766687169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GC3r3DONuA6YiYHbbshOdJ1QdT9pjrS4H1t+Tf2/8Dc=;
        b=lilZJ4DLWbFh0DazDVSKEKHPdZgspxKTZntm6K9IM0Ue4fsX7MXYpmU+xvwCkbvdej
         ejHoqMEyYMuIXI1DSjezQXB14bR3NVRNzmLdRO4ByPx0ubIzsygV/Z+mBh84TPhUB33V
         Fu3TsxHcv6ApUuLYeWeMveTaT7/unPXZcVQrDC/UjOHel0JGbDyWvzC7yVa43fFtyHZD
         zR1x8mYsiBZcuiPvwP+GevrGcy3pNj5r60WMMUSfwew6+KSOx2KnmMCXk8oR0i2/6CgI
         J/g+7ZkedSN8GaP5MgneFIh8VxuTLBVmtl3xo6iDS1C0EWyMAsmzhNqHeonS7zASYmRY
         PAXA==
X-Forwarded-Encrypted: i=1; AJvYcCWAuM5jLa4a4t9Hqjujuu09J2dB+iISer/4wc3pPTaPc0lydChsXpDFDjUGwDY4AV4Cq3C15mSZjw==@kvack.org
X-Gm-Message-State: AOJu0YwTv69JOwVFKrAF04XAE/Z0c2kF0E8/Z8YfOkgYoRokoXwqBEjK
	QMxO5PLTwdYywfmp/vdikYv4njT7iP4JLLIW/PyAeoongLQezz5Nd9Hvm4XqqBjfWmMWikJWwpo
	IR5rqhU+OiYb8CygmvTAJTF6z0du3fX1N9iE3GSH3Lw==
X-Gm-Gg: AY/fxX7dlFhPeNmE1x3c6cUGj81Ikzkx+105CCkmbxfI3KR/6xMbDLifjpvgl4uBrxr
	c+oLiqWBwL8USBFCRAtR+eittCUewhTuPrmfcgS49PYcGA0DXQ+pS9tDnxMSD8iMFn2kHvsMSR0
	RQClx3PD12Ty+MpT7hyLZdQk04EonpxfEfF/dxV6QyJf/t5L6US5HtMPCkap1dzVjArz/GXZyUk
	CgYTkyxsIZPLtJRJvOpO7zP7nqx1zqmOJ0CAPj0ipKH2jI01mGFYrqO62l2HnJ5858rlflNefH6
	80MylXkh/FUfWHiHT5UOnIDd
X-Google-Smtp-Source: AGHT+IFh20zE9m6KKsAOG3M+Pqif8xuWAkUFhwAc91SRRrHGiKgAdsW/CjK47Vzc8ueDX+KUR1WPj1KgEP2GVUpEGTU=
X-Received: by 2002:a17:907:96a7:b0:b7a:1bde:a01c with SMTP id
 a640c23a62f3a-b8037218276mr24148166b.64.1766082368907; Thu, 18 Dec 2025
 10:26:08 -0800 (PST)
MIME-Version: 1.0
References: <20251206230222.853493-1-pratyush@kernel.org> <20251206230222.853493-5-pratyush@kernel.org>
In-Reply-To: <20251206230222.853493-5-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 18 Dec 2025 13:25:32 -0500
X-Gm-Features: AQt7F2qAhKKkrVYXVy4sUEw468IovytUHMMiamVn3JrQ0uPWSbbBGhs6jJM9oIk
Message-ID: <CA+CK2bAV1y_LySjyj-wcn1cdSuVBdC+r+zQL7AQTY64nk3OxuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 04/10] liveupdate: flb: allow getting FLB data in
 early boot
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3az7mi1dqdnyab98snmf8czm1335knkw
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D535D18000E
X-Rspam-User: 
X-HE-Tag: 1766082370-148749
X-HE-Meta: U2FsdGVkX1/YdXtesmu6zk4RC2XqkXfka7VCESUkxLGPJ0To4VQ1CDEw5RxZlBHTA4deXL3RJQ7dK1Bwe6qYkfcaLCfqqyyJ39yIA4aXOtBCqR8Y/gg9f5N2dMMhJNNlGoHpsH9BWvhIvJ7TaU83++Iw5qaQ6THU6CBhr7W5UEBfpKL8DCQyAWBkrWEwXN04i0Z6fZMUgfPoYAp0M50THwPtMqNVunxRC2wgk+HJyNvCzGGADjM3KmU6t3z2srgUcpiOT2COAHejB5DwYeHh7Ehk2Dm5a8R6TxXX+gzZvqOUu92JDYR21MSO67IuocD5cRkrneFlMvF7WDvpNadaFLimRZ0Tl+6c+Jsdv21h8VwjC5JjeIJ9Xm7NsiZaNTjubJcJNEyvZv01m8zzNGraNMVUfbHTLQNjv2VEfYeYko71N/rZ3mxrLuW5mnHNPiRCK9vmKuYwDb8eCU+Zo1PWZNG5wjGvaMPCydjMwJAI2fSZPIDFbl8PI2L6+Zdm7++uT0Djqk8zYS9SV2LX19Exeaj2u45Or45Gxj7X4ePfBG6eQFEpYELaHZ/7CMjSQOc//9bddT0uNqvIc42owzlvGp4oVmNUQEK9a/IxPc1snbl6a/LFKmZXK2BLo7DqhA+4u4a8/NaZtHBCCd4eedK0ReCNOk/ZD183yWtd8aUL+k3dsXFAQVBFJ8hG+wYLZlxe6iY3KEjisEppcEHVmkI2s/S2xYpWTLXNDoe0NA6OJcbSYLyxjgXTksziaP83hthVDYAAOnYJZmK0L7K98OjnZ3lWXFPUh1v11UUX0SIthQPAMXcY10MaJeS0cpfK+vKjpUJy6qBRdZ36CEL4280BqFGH5Mhl3nZpQdhMXbaMJqxXbLvNsZ3ovIAnkHIySsmcv6jJ4Q35NNN0KlPeypMnTYh2jBDhe4mwh+4vDdmzkPyALk13x9RXdF+8SX0ArVlm2MKWQ4gOyrtrF6EIy4M
 XKwvQXCA
 PMbk6NHVe4IrvYPLBMCV1SuMrPMelHIWP4zPHstYMIqt4EzDFe4qwNjJVxfoknaVQhFOqEHqeFpPOceEQYMiRB25h4Apy8eDJx+Ej89/F6jRrQcVjUZXkXM+/8MCBLF+xuoaFsgbdD9FeCOzEPRW2Vy17CbaFYONC8n469iY7g7odWsdxdqssClcVRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> To support hugepage preservation using LUO, the hugetlb subsystem needs
> to get liveupdate data when it allocates the hugepages to find out how
> many pages are coming from live update. This data is preserved via LUO
> FLB.
>
> Since gigantic hugepage allocations happen before LUO (and much of the
> rest of the system) is initialized, the usual
> liveupdate_flb_get_incoming() can not work.
>
> Add a read-only variant that fetches the FLB data but does not trigger
> its retrieve or do any locking or reference counting. It is the caller's
> responsibility to make sure there are no side effects of using this data
> to the proper retrieve call that would happen later.
>
> Refactor the logic to find the right FLB in the serialized data in a
> helper that can be used from both luo_flb_retrieve_one() (called from
> luo_flb_get_incoming()), and from luo_flb_get_incoming_early().
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  include/linux/liveupdate.h  |  6 ++++
>  kernel/liveupdate/luo_flb.c | 69 +++++++++++++++++++++++++++++--------
>  2 files changed, 60 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 78e8c529e4e7..39b429d2c62c 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -232,6 +232,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_=
handler *fh,
>
>  int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)=
;
>  int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp)=
;
> +int liveupdate_flb_incoming_early(struct liveupdate_flb *flb, u64 *datap=
);

Hi Pratyush,

[Follow-up from LPC discussion]

This patch is not needed, you can use liveupdate_flb_get_incoming()
directly in early boot. The main concern is that we take mutex in that
function, but that I think is safe. The might_sleep() has the proper
handling to be called early in boot, it has "system_state =3D=3D
SYSTEM_BOOTING" check to silence warning during boot.

Pasha

