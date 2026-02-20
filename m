Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B45C56204
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 14:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49FB26B0088; Fri, 20 Feb 2026 09:51:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D746B0089; Fri, 20 Feb 2026 09:51:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F956B008A; Fri, 20 Feb 2026 09:51:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8156B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:51:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 916205723E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:51:58 +0000 (UTC)
X-FDA: 84465124716.16.FD38900
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92B9F180003
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:51:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SatMDUXk;
	spf=pass (imf06.hostedemail.com: domain of glider@google.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771599116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRC9wX3iNFw/rKwvWg64N9r6jXdqwQPIuFwNZXF8S+k=;
	b=I3KnvjgHt8s1EnuqSq0LMTfbStwWlxn+cWaOVtF4z/e0NLd9pNzD8lKZ4KAUeLwUMwrRcD
	FJx5P5EAJ/gYlOe79VqahAduGb4za2BCDzgAFOCdLMOwkIxClu9alvffZnlIlctu7KYw8B
	EsKNGjn55N7mV9SIOiK8e1YbcuojamU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771599116; a=rsa-sha256;
	cv=pass;
	b=u0VkG280WenmvDuAiLH3bs8evU7AHect8pKFzJcOP7XPSHt3k/Nv8Ao59/shHhsym5hRMh
	kC+A1Ap1PTehkGJiNvc4gycJdR1uUQsHe4I+A/hf6l07UJC33RDVZZWO348N0o3cAYM9tJ
	SUgVUYyFNViO/gyyuyAOjP3+oZ0KlqU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SatMDUXk;
	spf=pass (imf06.hostedemail.com: domain of glider@google.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c6f21c2d81so203635685a.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:51:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771599116; cv=none;
        d=google.com; s=arc-20240605;
        b=Ns+wM9Nrd+Y9BFgHceDBi0UlCf9hWS0cD6XHnjLuiy7/iZez7wBcxZLZ4uX7DDxnu9
         +HLiBxZmtJladA4UT2tJ8c69oeblUxrYBFXyjxDh5yJnKWSGXRaMMVgnMcoCBIfdBby6
         Ad0em5uxdp4gGTG29xrlhZEf7bxfGPY2QZv2766hdixY1/MMX7mCGUp320EVSX/1VG0n
         IllwrQwXp4rGssi+NzBxT72gbj03wklkr/TYqpIyEX9Rho4U5TKa0wzIeNlWidH8FBRs
         vVB307GjxRy6QfpXsTjQptpGxUT4nlpbHKLalsmEnxm1Z+zz+EptOLfC6l9XJiqI/ED7
         o9Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CRC9wX3iNFw/rKwvWg64N9r6jXdqwQPIuFwNZXF8S+k=;
        fh=Da5cQ/6ga6YbePnGk2f6KyDau7RFc6Ge78hfYbIR2z8=;
        b=R2w502uQ+qY7PNgRH720SohKQeyUIYqaOYZkerfzP8ZjUs4FfQ/kZV6kRd3xPZ3cUE
         wU+68LAh60/R1ReH7r/X0dkmDjVgK4A+32zbP99wU9m8MALnsNQ406Qq3H2sLutrzZfs
         t7OG0U5gsymdmD0Qsc6s8PygYwO9jt5g5YLuAKqs5fbEd1/L7kucfn9t0ZEU6aj1m0TN
         sLZKalXWOzkiz7FqkoRDvnRD54CQiy/r7a27APUPYco1MfuxmN52Hx5a6G0UYCNYp8yJ
         aLY2f+s8Szoicz6NxoOKGza2+UjrGkmeETChqZhrPBxfoWSzozoWklww8fYQYNAYoreh
         wAww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771599116; x=1772203916; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CRC9wX3iNFw/rKwvWg64N9r6jXdqwQPIuFwNZXF8S+k=;
        b=SatMDUXkyheLC3wtPXA7kemmaVJp3OXMlPS/tq5FKW0RNUK2wc+KjTaqyftkA2xvsb
         yFjMeBcmha4diWvguGAvZ0NovkzvTyeK4FKZEIDrKz3Ylq0irTpU1xs/Mofp3B0wRNNm
         /2qoUbysg5FCp/gahCa1RWyyLzNyUasENRPfLOAOiYmTQWRr5giT5/cVFFoFnRQM0xGg
         ub9QU8BDtI66OaVihdo7IzZNJuzPPnvZ9u6PeefkkQLIV7Fk88X5G8vbaX/2KzDnlaB9
         H/NlC0e7DufcCNronLNg8dD9Ec0CJ3Lg/bM/onL6paVDiDuK5x/i3fDu8Jb9m2uLmLlw
         eemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771599116; x=1772203916;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRC9wX3iNFw/rKwvWg64N9r6jXdqwQPIuFwNZXF8S+k=;
        b=QyPhpWDO50/iPUQPd8Uu3iQXaYcQk4srVEWTUFnZxCp7hZ0QM6p8+TKnn4Bib4oVd/
         cZ8yZXnkNEpJFUPQBCxfjXqf3WxMuta1DBXk7Tp4fExijd3Qsizlvv2j8BEO/4G3xTxe
         xD3vJCsSyNdBLaT9C6QBvb19DhvALmyib3eG0yGu7QraBwwNII8FnC/GnHsjqj0rcBgt
         WxAxxv3v+r0KTqmceXjT4HJN6qMzTp1UVX2BEuSZ2jbQC6/zo4l47Txas8Dd0Ow4md+O
         uHsNIqJHAUeIX90Ci+fkVr+8h4GMFMi3fZW/p8aFUSOfEvAMY61fcViTxB0V4Qt4i1Tq
         A9mA==
X-Forwarded-Encrypted: i=1; AJvYcCXDK6C3EzRusgz1GH6RB1TQSAnC0q9+5gYOtIqPEAadL4Vl/EYLSZR/oRCB/e6YRBRuGUOGCYYPbw==@kvack.org
X-Gm-Message-State: AOJu0YzZdeWJ5Kkn0YG12O1v/BpJrd12nFgTAnuuuHZu1sOgKvGT/+ol
	Z8Wa2R8MxrsVaDxfoKeN8fQZvKWZM8r5GCmyoOTWiYPKI1vzj7MytbmrLI0/+3qiYTP48BSvDYx
	saNi2t4svnJCVSVmR+t0WWUic98f2ZNO4+RkPAlo3
X-Gm-Gg: AZuq6aKrd1Rcj8x0X5KMw6Uell+M/2UZHJn+HTRE/VEsV+GBWJarj5hb4CVOMDvfiiM
	adE4IauySuA176frWM3CwwJx9s1+psjBjMXnMpYl7cpNqXZMshK9jyzU5+f9tT61pdpqRToSRua
	QVHy1CCvY54ApPprJXquHmyXngFrgWMn6VC+ez6ifL9X3U0dhnA+eymbq8gHzDUln0DUurE84A2
	new2qkAPwNoAp2pftth/UEN6FRPRltKrRKhKlPEqA/UZywvPHiqtVgq29kiusTysNDZOIVqkzzc
	Chu6teAmEfizG7HfOVy2ZCmD0anGLiXVpgoSVrFNe3QrM8FY
X-Received: by 2002:a05:620a:2995:b0:8c6:ab8b:29e3 with SMTP id
 af79cd13be357-8cb740a50afmr1032496685a.44.1771599115069; Fri, 20 Feb 2026
 06:51:55 -0800 (PST)
MIME-Version: 1.0
References: <20260213095410.1862978-1-glider@google.com> <CANpmjNPJV-aQKnQ7Mtr6e8_12UR3C2S3abJx_ePFWmS1WV_UVg@mail.gmail.com>
 <DGJT8E07A37R.2GC7KEDWEI7R@tugraz.at>
In-Reply-To: <DGJT8E07A37R.2GC7KEDWEI7R@tugraz.at>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 20 Feb 2026 15:51:17 +0100
X-Gm-Features: AaiRm521oqZ4C18Oc-qFEQM1txdUhdvqiUI1K2F1OhtYJjScl8iiQRwoFqDDN0A
Message-ID: <CAG_fn=X=Jvm1bPo=B1f4oo9eSAsHN0QBcu34oi7cMC+Q6--ZAA@mail.gmail.com>
Subject: Re: [PATCH v1] mm/kfence: disable KFENCE upon KASAN HW tags enablement
To: Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>
Cc: Marco Elver <elver@google.com>, akpm@linux-foundation.org, mark.rutland@arm.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	pimyn@google.com, Andrey Konovalov <andreyknvl@gmail.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Greg KH <gregkh@linuxfoundation.org>, Kees Cook <kees@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 92B9F180003
X-Stat-Signature: 4ukwes67zy4zcs5sxwweb6qgqgskhian
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771599116-962557
X-HE-Meta: U2FsdGVkX18K8T698AH39oXedYzTZkhVV1lRHfCLdOIeaNHMw8vMUxQRFZbgMXdrDijSsyooNXAhorar8AzKJpaIZ8hC/yEa0xv7WnCV9I1KG2LkGmSM7/IUpgyN9EVr9AA0NwTgCdikP7crQWFvbI/ybUJEmCCYfsabzz9YrXtCivzgd73HqibH0sSbXbQwwxvQVz49XZ5ymsVG94EK9jqE4cyHweVSPYgRk2D/CF19lDl24sgbrnc8Kz0BhDYi3VOAXHVmIntyZmi+igt0dZJtdjhtuKaGuM4bLBTgQkSA3YYbWA/NYnq9pPxgno4WPmpvJOEATCV/eok2R8a6RnxlqatqCNia47Ob3nw6xH+z0/njpxB7AlLBhqxTjLVslcv0wuCUCFlB2hKfN3FVeZSbkTjAeQNcLXLAOX0Q/SapsV8dCOqyaDqzTyO2p+R1yJCWb/1uGvZKH5qDeesi2uyEQX0u9wJPyV6V2usea2I1W68E/aI/SOjBEDTvRR2ie/m7FGADHcGMugkzx472evO3EqCeFID+zCIIroMLE7ybgfrGOsPr7GsIe4srEXKySLreSeffd8lRCTjs+LgjmP2x14iU9kcoamVF0lOz2G0BBAS/tKJW5n09VF5Afwq4a/wAh9oAc7cL2IFE4kjTHxzo8MLkVlodTRntHtyJTTDdPBSpAb3vMcmNg0OERjSEAxoGZ7EHBJId/0rHGDkBD+3NxEzWd4tpVWoebjgqxRpHUTn7coibS7KJ7wjl3YL9q+gYrU62XjZ2r8fxYz1Qbv4x81YU06Kz3x13HyQu5LXcav1Koqz2N0K+Hk/WQrQI4QT9145jBwYVgI8zEGXwm4Bc8pnCSVnlekeP3sjRpzt8niWR93FSJYMlSTIv/bJuPGIgAihDsr/EVrPK2QRIqVjPx3QzxRKdIJ5AuNwuTjh1P/SuUYKT8NCuQydRLqTshk0cJVbs/yQC7+B+D8z
 1/X5ghKB
 v5JOC4v0q7DZvFlaMcvuOMI9AMGb/81LOFGGF5TPkU0BEjXehGy5J0RFan40s7/nvpQLy7yVzscsgdlVwZknUkanfoT6YJ7mYqw6XFWdE4vQKiIdE7Zi02DsV4gk/GErDWnB2cM1iWV6Hy1RPl3LVdql00V+DCkJYKMu0UDMA6pTmR9RHeG5imHIrKs648dlsj89zLBZpJ7/CZodSeg0gbmjKLLP6Hl8pTR7Sb5Y7MkigJzubQXoAoqHKe94lA3qu1mDaRKl7GulYlIRfoKiXIoBZV2VHS/YnxAN4sK141xxApR+MSZyTVqPeo2jqhseNISdGBnq3qvyQ5EcFpKYqANHlKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> But this requires adding __GFP_SKIP_KASAN as allowed in
> __alloc_contig_verify_gfp_mask I think. Unsure if there is a cleaner way
> of doing it, or if changing __alloc_contig_verify_gfp_mask could break
> something else unexpectedly.
>
> I would be happy to try to submit a patch for it :)
Sorry, I was working on a patch when I saw this email.

Let me send it.

