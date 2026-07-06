Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2D7C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5262F6B00D2; Mon,  6 Jul 2026 07:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6696B00D5; Mon,  6 Jul 2026 07:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8636B00D7; Mon,  6 Jul 2026 07:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 083416B00D2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:53:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 684451C7CE5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:53:43 +0000 (UTC)
X-FDA: 84958192326.14.9A6E41F
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6DCA4120002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:53:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=C5ggkEwQ;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H75gp8WVKuHVfCLEZVTtpIHpv638HXTLtw28T7Z0uiw=;
	b=O0cSrCAkrlXoW+8fIDUcKAG3CiuV21gi4F+ULYk6xHOcL9LDg5bksU0LJHWgXRei6zv0A3
	qXk1v0OsDnu6EFTiW+tIt8Ds09VtiY3LAT+RJ7fZoX6J8VRPW+XO++ges77feh/ZcJxL1p
	uXNt95DV3Rda08CaoA1WY+xuIS6oUdo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=C5ggkEwQ;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338821;
	b=icL9d5zwM9cUBenzS3ZupnmHcVpmkf4+wrTUQmisOZSNZdj3Y/M8uY9gqmY31u+NWWM0C7
	sjsM/xcw9JqfkJJX6mbXzefg8N/l5sE43Foa+gZd5OTQVfM3X0DE2Rx4lujC+GxYPgPxCX
	mT+j03lPDXMwsjfh6oTXb+wfpBKaVWo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783338817; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=H75gp8WVKuHVfCLEZVTtpIHpv638HXTLtw28T7Z0uiw=;
 b=C5ggkEwQLrUkTJ8W8Q8mUoo8pOWeVGFWMd9vma1eQcw78rYf+xULBso5o5K36BeE1LwACc
 JNqxpmawSbMnR7rpDnpaFiwcXj9E0OhQBVnCR9B/kyrw9q6l2IUIC5+j2ebe5AbQl2o3Qq
 wLLjPegiffJ+hE2OtzbC1x1E6ZGffEBXc9aF7O3QXNijmdkMXmXwvRaHeE9XWjOaejlKNb
 LBDmAFXuEqgkasO3SatMlRYFZXkk06ITyMj5exBUe8C2QnWnWHDxtynWlgVEsmWCT/K3cw
 8wEoU/gy+csXJF8L5wNIAYlD+Mx4utf5OsCvFPrke/9c3J9rr2/+SnZocoMs8A==
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v5 6/8] string: introduce memcpy_nt() helpers
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260706115313.50524-1-lizhe.67@bytedance.com>
In-Reply-To: <c02d8cd6-a3e8-470f-a7ea-a2f2f666b10c@kernel.org>
X-Lms-Return-Path: <lba+26a4b973f+bac885+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
References: <c02d8cd6-a3e8-470f-a7ea-a2f2f666b10c@kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Mon,  6 Jul 2026 19:53:13 +0800
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DCA4120002
X-Stat-Signature: b5jznpspzhop7upzmsgd6q7f8r5ezunz
X-HE-Tag: 1783338821-618549
X-HE-Meta: U2FsdGVkX19Db1LM92HTAArBqBYZuKh3kR8NJ6wxsZozWaFSh8BytUg7JdTu9F4oCS4SJbfY51MjyeSHdiJIlgVoIAsKo+CcMaszm9WMWcqq/J5m4DHSSO9hBMZJZeQLbCZZwqezP7L5YGJp9zYmFCfdGte8wru4SWGouVZwnFuK/hnN1qrTxcTDSU81+Mo4dti38LN42ZKrFFTKLuIBK7/0t72YtC5lV4xlRZdSlwTRYgmK/A/fIVBHatZs8k9xfFAOxobHWrArXQrqX5YOFuyggD5/pATEkDh9fbwH5CrGaq77aanNw8fBA4Tw1g73rSqJCtT8cgSMtFshDXo+1bNCA3ZCMDHjStlBdDt0dz1N6VAnjXCM+MYjF8kNjS0ssM6lmrFsoxYkow7yOCi562dgXczE+SScUu4X9EEUc5em2EhmW7iTiQw1LILevtxfsC7P3MfUhL3dtfuPSP68Qe4JXUgSEFoJ7qOBMrpLr5KYE7A6ghOU1JxlVNSPUyrkzeViOc7I111W7ERKLW6BXNOFEPwYB1dZ3AsQbFI6LDkWkalPWH1YautaExqkWPpejepfsNOoQbq8zaP13ehi0Mp+IADtiWGXv4YklVHi+TY5IXrstcDDreRaoOqn9hpDimjaFSFT4uz7RdftUfYeuAMemNdjrjZdci0he9bCLc+p0JBTh27tNj0xhIUseXQvY2rssMDOqR+98lwhPEx10AUgLJnogCQ4iKSA3UqpL5Ako666RRGYyLbEsyuJmqP2Ywk9fH3XS9SSiRs2Qg9+Q9us0/aNGgXiFEzfdsc4BL6HGon2P20T4a5FyOrc8r72HAXIWF3J1etPEgk0SoOxS9rjhMfmlqoLzCMQ21SQjBcpQDxMrSZKQRgWwbEUzuIL1sM1fxepiejBUlDi2tMHbtadSnxgMnuvobfqOnKDtLc8Hp+DNKtCNMACOTuUzdM5Hx93jIYURWjKH+kSQ52
 af2OhEYs
 ejACB8zKUilc4OwLBORms71qirTsOONMUUoFeZGbqpjME+c3y97djT2nv4Pe0cYxYtx5PJ494c4U5RxJVEO6k+w8Y81f0zIwO67Es4VlOo6MV4xnRqY2+25L64VvWCU+8vNyULC+AHJJxX3hEQd9XXs68v4OSZw9wGucNw0nkxCu386vYqLjwFuHEggBlYjlPhpdbk+3OF28fU3nBtOGIKucQEtnKSgufRpTI084HnI1UasFSgm4HsxWnqrb1JfXcYsS06f68BSU8jUgC/sF5FRBp9rjVYOqM6eDBhZDdxcNQznPGg2z7mnnFt08kJitvnhekZlBEieA5rjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 11:18:48AM +0200, david@kernel.org wrote:

> > +
> > +#define __HAVE_ARCH_MEMCPY_NT 1
> > +/*
> > + * Reuse the existing x86 flushcache backend as the nt copy primitive.
> > + * Callers pair it with memcpy_nt_drain() when later stores must be
> > + * ordered after the copy.
> > + */
> > +static __always_inline void memcpy_nt(void *dst, const void *src, size_t cnt)
> > +{
> > +	memcpy_flushcache(dst, src, cnt);
> > +}
> 
> In particular if you end up with a single function (that jsut requires a write
> memory barrier afterwards), please make this
> 
> #define memcpy_nt memcpy_nt
> 
> instead.

Thanks for the review.

Just to make sure I understood this correctly: do you mean that, rather
than using a separate __HAVE_ARCH_MEMCPY_NT feature macro, you would
prefer the usual self-macro override pattern, with

    #define memcpy_nt memcpy_nt

in arch/x86/include/asm/string_64.h and the generic fallback kept under
#ifndef memcpy_nt in include/linux/string.h?

If so, I can rework it that way in v6. I would likely use the same
pattern for memcpy_nt_drain() as well, unless you would prefer
otherwise.

Thanks,
Zhe

