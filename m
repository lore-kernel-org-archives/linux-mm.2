Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACD7CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970F46B00BE; Mon,  6 Jul 2026 13:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920496B00BF; Mon,  6 Jul 2026 13:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5CB6B00C0; Mon,  6 Jul 2026 13:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 500666B00BE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:19:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8EEEC04D7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:19:36 +0000 (UTC)
X-FDA: 84959013552.19.EDC16E9
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3B941120005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:19:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=bpaFdjdu;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783358375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DM6ZBlt0zfO3Oxu5g1xHzady00ujWkiGTPHBW0POuGI=;
	b=p7drwVKFwY6vW4hCkif+4Qb2ib09h0apaz0uox38t0VLoTT/lc988PnllrpwHzdmvKMksR
	/2cwmpcywDPQp4bUocuz2CRbWK2Xp1niK+vRMXKaTLb8mYCPZe0Y+PsP4wp+6uBv+0ECze
	uQ9CmpPl7zQI+AY+QLkj/TMukVE7cf4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=bpaFdjdu;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783358375;
	b=bbYP0IczqMl2W9Kqg3HvPuobs+ChSaKXLyh0ZIZNJcuyXXhz/G8+iIa1IhWNwSX5I8qgRc
	ewcMYRW1Xm61jKpcxknViEN8VP5LP+LLGqTtRgFiKjnUfOIVagKyGW+mHFjCY4q+WJRSk1
	jlS9huqmAsJb5ejafs/drxD8JKT9TIQ=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 218C640E00C0;
	Mon,  6 Jul 2026 17:19:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id XZjjGk29IVBx; Mon,  6 Jul 2026 17:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1783358361; bh=DM6ZBlt0zfO3Oxu5g1xHzady00ujWkiGTPHBW0POuGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bpaFdjdu7MeLFpwxJSUxbUN2zFVzHvpjeEX3yENf0gapDgpb38KuOEddMkkTXgf70
	 cAj1hYFfp60+FBEfB5QeUs5VzgHkUzDJsrRW8joss+DYyzGCkn+b4FMhTOj2Y0Mr1T
	 r89df/BS4pK6QPE0w+EpspS1EbTTvetdE7yZIsU//NDMqTNPjeUFrmXvy/E6LDXKVc
	 1/9GgGFZ8wx5g2OjcepRtDSMLK7tucXC+moW5Z8+PpRGMO0r4gO04rmtUi6ZhTC9/P
	 cQ9HrtVv7dGJt1aKdQRVkLPcu3e++nk5LZELNGuse4WvsCtIjtzGPt9btDmBUEeUA/
	 A0wTRpBQYIRKviTCwHHkK53tjSPK0cR6ZdSk29JBmET8hQhUtOe1Cfzf2s8Gsq6XrH
	 mJXQpN44UKQAF1SfZxdiQrV1IFLXBzgqM6AiM1s2X0iFBM1JRw9Eqj5qr3cgIoWo1J
	 kJJMK9UNBs7jGIiqEY5KGNINByS0yHLhZ7d7bTMy0MJbWDcCyzKrQOfVnTta9A+kCv
	 316Zx1nxDKYFZhcDEqCR2xq2UVwSr8ae8A2lecRPap07vDNDKU1cE2LBaEqMDBAwrg
	 axWuu6/TE2eI7hoDEKQuOlIByonIR+JnhhcvGra6UrfiODroSgRg6g0IVQISQ2qptm
	 xyobEQ+SWKLbhNsbJqxa0V4o=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 826F640E00DC;
	Mon,  6 Jul 2026 17:19:05 +0000 (UTC)
Date: Mon, 6 Jul 2026 10:19:02 -0700
From: Borislav Petkov <bp@alien8.de>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org,
	linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
	rppt@kernel.org, tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 7/8] x86/string: extend memcpy_flushcache() fixed-size
 fastpaths
Message-ID: <20260706171902.GCakvjhl5U89iJdaNP@fat_crate.local>
References: <20260703195619.GGakgT44P7lpcoMVlY@fat_crate.local>
 <20260706074346.23928-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260706074346.23928-1-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 3B941120005
X-Stat-Signature: jc13t3em1kgfwi1bunj5utrq1y1hbizq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783358374-799814
X-HE-Meta: U2FsdGVkX1/HXR5owQbLJoy5X985mq3vfX0Z+im3zfuUERevyxRC2bQtDFTrti0BWmQ/dWjUUX2XWiKVlBx3bW3l92+uiey0FxgaREkvvuZwpMRTJYZRRZobc+QT1inSsC7kJ5Ray8gsModYMHkm4HxsBx9MtWwVRvw6XJAGIHf0zh7x3a93jELpEpPhypQ/fl/qTIaVlRx69+M/t721KzZMDQbDj2dN6dXfvbJuI1uOxMTRYdLfZVO2tspRPDiDlapy5t20mLZLXbFJUUtLLT+z1wZyQU37Aw0KIzj5eV8t8damm1sWQD5D7iXmDAnaEtCFJoU4Y/XDlQ0LaK6Ew470koW5acWuAhMQbzvoJ/ViM64KCRh7UC5bZ1/1XXGpv6bvN2YMOnRt330DDrq+vjXfe+lpspF9ZQGaexJMHEWtJBoluOk689bKL8QJpmaJ7M4Fr3GfcdF0nIrFfioawV5Wd/xfpSeYOZDDgb2U/vleUq3ZGbeR+DfUMYsRKIheNdSMULIoQtk9QbJhEDnES4jLL98kkrDtke1/Heff5m1KufPpTjfns7/QWf+45EN8bo+ygavA0J1611F1WnPBWy20mcGjueTygxuW37yMTVX1voTkaD1uqckFkDj+8PEf0lq0bCqyYdPMkPiz2j7L8O5DbUeKH8s+ttYps0dRu12cijR6e7OHLWlru50lWESDrzanMdArCSu6oS58eG/h8AWcR2J+jWJAfpLjesgOSbzXAOqSjfnnLmE9gEsvOh7pxs2abzyzo1rk7e/3SLjsIhbFkYpStPWwPesbCeqllLVApe+nPsv+4W4PEZSxA2VdcOH3HCOe6Rg6BbEBk8PCSEJsMXQp0WZ+Cdsaww3eNMmshuM9PBh3fZhD+MpJYE5yTAGWKQRn1Kuzau2Piggrjt4VGfUbUWyEkXOREX5EstVAGlHbIo46cwZWiQ6LFiqJE6N76hWiR/SEHBS1oWV
 s2CZGbrX
 63vaQCSX4CsUAqbyafStx4KO9UIo+wJC0gIepCKT+31Js3K0rXH5SatGtH1G5FxKvOya7SmmeCXNstMs/ZOSs+3Th0Y98g9+Gv2dCnX7Bw6WCqehZiZ4bJVSgGHDmMFEQrzySc3UizAhXUF6UxuqTNj2ZA7uGjze++9ErTD+nMJsSiiRF3fRcF36a3gGtVNSSgt3PAYKAX19UCKKQtAzW4xNYAzg3tpQaYSV0H67DknJ/Ic+6A94l4LaIDh2PzxAI6mWjMSOvebFouRor+55zgPcyV0PDaHYd9LlltGBF9zmsdxCCKxx65jl41o6Pujo6oj3Ab9kiIXgFUO2tKpLRinoj4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 03:43:46PM +0800, Li Zhe wrote:
> The extra IS_ALIGNED() check is meant as a conservative performance
> choice, not because MOVNTI itself would be invalid on a misaligned
> destination.

Dude, you can't just wait for me to pull every unobvious decision in the code
out of you - you need to write it down in your commit messages! I'm not a mind
reader, you know.

> As the Intel optimization reference manual notes, higher-throughput
> data movement usually comes with alignment considerations, and can
> be more efficient when the destination is naturally aligned.

This can't get any more vague.

> So for these larger fixed-size cases, I kept the inline path limited
> to the aligned case. For misaligned destinations, falling back to
> __memcpy_flushcache() is expected to be the better choice, since it
> already handles the unaligned head first and only then enters its
> MOVNTI loops.
> 
> I will make that rationale explicit in the code comment and commit
> message in v6.

No, you need to show whether the alignment brigns anything and then add it or
remove it. We don't do things based on hearsay in the kernel - only on hard
performance numbers.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

