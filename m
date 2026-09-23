Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84447C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE886B0093; Wed, 23 Sep 2026 10:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F1F6B0096; Wed, 23 Sep 2026 10:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EF86B0098; Wed, 23 Sep 2026 10:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9A86B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:44:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0FC380839
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:44:22 +0000 (UTC)
X-FDA: 85245297564.18.9E31262
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C8801A000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:44:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tyqL4yQj;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790174661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ida2noRUeQ9O57M8GX64707eMt/ciX4GKxu6FkxXbAo=;
	b=mKpjgSdVRVbnH7ObqitChZTQbSJBCEp7d1Q1xdItOgc7HHxjLv4uzaqjnmQVna0DPf/MRZ
	QRo3kv7Yn4rK8X1G+8YKc/1ozhCK3p9dr+7C6tI2cXGcb1jVAJLVabzoIGtaPjJeaXcmHz
	utOC/9/Ee4ahwzHgPWvzRFe1pl6EEp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790174661;
	b=H+9CwJYCVWKdcv+ojbqsDAzUxsJl18UKO7oyUwdwRy9red91Bn1DI4V88RQOQO6oqwpQso
	oenNR60wzZTjGHMTlfHWd3OqHoFj9q2efheh7eMm90TRypQ7JwSJy8RH3TXzUh4aUjMdMn
	y1LwzGL87rb7DzvdjaBZ2HsbPZwM2UQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tyqL4yQj;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-52ff0eea420so7597821cf.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790174660; x=1790779460; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ida2noRUeQ9O57M8GX64707eMt/ciX4GKxu6FkxXbAo=;
        b=tyqL4yQjuiReOTWVc7IxoKs4X1s5t5pA0EI8EvK6Qr/GlkcrqvjlpxvwMlK7gUIJSe
         0S2R9OjRKUBhIJ/BT/vin1wlHpGnm5MhreWNq0ykxilU7HlzQyEEkE1qHteFOxDGWZeh
         HKU2YaYlCHTkw9cGMIBq3k/4dslR86ZvQAl0AJDqCE9k1A4War0HDOekrTHjXpepcONg
         M8cdvH2BmOYQXVcz2ff1FftlMxE7NL9U+MqgiZIxjWe4eI9CH8IlqER+W10Z12KWFh/k
         DMhW1WrbLzeQTecq4CUaP2bY/5TRUPT2ZLhz/HwUK+n/l2RSrhYVFdAQHREkJ44DGbnA
         siEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790174660; x=1790779460;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ida2noRUeQ9O57M8GX64707eMt/ciX4GKxu6FkxXbAo=;
        b=nqDx0m5y6dNc8fg61Fh7TXafuc0KRBET8SOdWpTjEy/eL/ADc2VDL3y+KpRTpdrYzE
         Ma9ANma3GOMew1qR9S4G5gmbxug18NNnC0aZIW/5KY1znplQ+F9fWliZcr8h1qcMhnNY
         A9ViliiBH0QMXGBTJvvgDOIba3OPIapz1dU7eh3YU0EnZb0CEr3p0ya8hpaGXXDw8VHM
         FcgvT9aiNnRfBJbHY0ezq/JPnVij/8f7P9lmMWIHzdBCNwGn4DNVkLxcmxti7oIJIo7g
         K0jJC7urHAbIHuleYcQqPxJdxyr7beu8Gxemr654HnA8EsdMtn0fTkYCoL3SJuajas28
         TI6Q==
X-Gm-Message-State: AFuF++mVsqcl8ztSrm+KTbeU8SjzWTJdRWpfj90H8K+79x+uwfNuyDEy
	OxWsOkO+O4gidI9fLQyTxoSygdtO8XfJvfWaEOXkzCiq3cr0wKGjlyz5mzf30BNB5dA=
X-Gm-Gg: AYBFou0x1abFfBT79DfzCH1vki77ZZq0aUkFj/KyWOQjQ3UTBGYtlpkutxr7446IQrT
	9vXj5zma67FfN6I+7UFhLdjzkKppHYJktmSqMpLbf91KxkUCvIbCn9F0TZ0wl4hgJ2KTIlQ21IC
	4PxGwJNlmVdpZGBWzQJ0Qpqf+zGex19W28gl25BU1Mx1WenBLI88DoRTh7w4Ll7KGVog/w9xibD
	2p8pYFJz5Ey6p/lmZL3re/0oZPXnjO1ipgxz3FPQYWgFnR8XDhHEwwQoQFjIu5MYesg2+wAUTEY
	vF1kX7gZCJ00701JPJSzaB72OK8/Zy6ObzLC9EM6ZJ/gaAx3UktsXZuds6DFiolftPguMEHSnmg
	pn5sQR+cXaydy4jeP11ccSVdfsE6VKQOSBBFVZfnpv7v/1NZo15PFiKxaSpVrBPdgzF61VmE3+d
	cf8BgXvij4629t7ePIjKYTZ1r39QFc0+rr0RjX0qqzr/WvC1U2FQLxoY/zRJv2Z2VuzP9bokhk7
	N70WWuZ74N2fvyWflQUweqdIzzNNNYXsjt1dcyAPMWOCpQtrRFyEYlG
X-Received: by 2002:a05:622a:86:b0:531:2eb:be76 with SMTP id d75a77b69052e-532db85279cmr96539711cf.22.1790174660094;
        Wed, 23 Sep 2026 07:44:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eaec185esm21362971cf.3.2026.09.23.07.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 07:44:19 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:44:17 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 01/10] selftests/mm: exercise MADV_COLD and MADV_PAGEOUT
Message-ID: <arPjwPwVxdvdR5S0@gourry-fedora-PF4VCD3F>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-2-gourry@gourry.net>
 <arPgwegm8XgbEUrO@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arPgwegm8XgbEUrO@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C8801A000A
X-Stat-Signature: r5fbhezdbstzq9yg1t7mew6ncrqurr65
X-HE-Tag: 1790174660-92418
X-HE-Meta: U2FsdGVkX19r7ZJPvYNoroIlmmU8wjXI34jFFi7mpy6QeBDa4AmFxU46jzFaVJHCjm4FFoEQ57UR/ieMxP7dzGuk5c1V8MIuZthvmgR8Xbe4WlzREOMA1IkNe9fy5mJCitd+RI0FTrBA64YJiLSfam2j6tVhj/uFi9tpsX9SNzoTguV3YdeWO0j2K8Ggl+Z41tLBcSoH2+lc//LnbYDOTD2pC4t7mTQJ1xOM6pST9CTQtEff4ols2Jv6lyCr30/BRGQjgxZnufo++JsD//8wo9HskzgBShnNWa2/zObfT4dLyMz7FApsBtojlJ6lbPrl61gqcnvJRhl1nIqNI3TY2MArX21zxUDvqTN25/50/osy9MPatfTPXd9j+v5Icesw6MxtkBe1a3BpD3BVvnVTOKVZgCsr6I946LJ6WM6X/AN3goap0Qfonos2iZDML7sa9y+PUERYc+5sAWH3STrsbLMdetA1pXpHLeJu4eryQH1ypcP5SK8EChbiLV1/q9qxWWKWls4pv9lnOTKyFU06mSocBwTggT1j9r3EKQZ4axoIJ8ulRMjONCCw+N0E5ipXrS7huuj6iQZyuZi+VOb1fhN+rOyq/NfJ47qBdY5gfwYn1dUz8m8rYpnSMfwO+I2Yl7m3O33kSFQqplt96nFI8pdplbNc2PlctzjLVnO2ilxtELmIOf5VpwouJg+xWFhkR3FqD+2eVj3BMwUCTTg4Fbq2q7s/l4/xbqGlDrwm7oGvElmL8fSNAqN7zqB8U3MGeLwVEQwmFjVEqd7Z9aKRwR8Tj9XvAtIviy6BimbQkf1i1ap9NaOx1K+8KWzJO1oDIshaIwCXvQr+El8vamaus3BJRIwnyo+qynfnj9YDvfR6VMiF7IMni2e/GxF1vj3s4fl/I6iQ+87t+kpyx++jKLGE2RTIV4ThTDszAthcCPMhlnM0tn/9I3OTtdkNKmcZt484PK0yYHVatFveV1/
 g6zNmUr6
 VpcnjjTIK85aSNFwIYWuBZegSUS61e1nl5EcMaEgo193zrX9AUbmrBCdTYD40Ehqv4YdQpv0xGz8IEcuEwZSDEl1A11f9MBPJVa5lfXM3NdlwSoqeAusYfscv5qYRVgDBLlABes55LwSi76AHiEoZKeXU3NUssHt1wOw+/VquK55xwuRWuZVqTBue9QaOA30yHFb/A2JhPSWnKRE5dIDiWC3R6p0QXygIX2tfln+TEJ6s9J7YzkQmCqvOk+PsrPpVQS3OlszC+1JdxwscCtNaSXaPlCSrfzbwjnJydNY+4XbaubNozdbN54bA828F2CmCe1rpTTkEeHyDfwlfBrYkKMXQoVYPlPA7VWdmC8XUtCvAyEQqCw1cA/ORU/qSpWDBazsJJwm765sLyfdErEonHT5L3/TgpDMaBb7fsdp7GMDlOdqt7Wwe894iOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:26:05PM +0100, Lorenzo Stoakes (ARM) wrote:
> 
> I think in general we want to avoid putting stress tests as part of the
> selftests in general? Or at least if they might take a long time to run or
> excessive memory usage, etc.
> 
> Though that might be benchmarks, as we have the THP stress tests so maybe it's
> OK?
> 
> >
> > Assisted-by: LLM
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> In any case I really do think this should be split out into smaller parts, this
> is a _gigantic_ change :)
>

Absolutely, but alas my poor email hosting throttles me if i send too
many emails - and sending a 38-part series where the important part is
the endpoint of the refactor moreso than the individual tests...
instant 24-hour timeout.

I'm working on a solution.  Need better hosting.

> Since you list a whole bunch of different test areas and you're exercising
> different things you should be able to split this out logically across those I
> think?

As mentioned, this was originally ~28 patches split out, but i think
ultimately only the contractual tests should be shipped.

Maybe there's an argument for keeping some of the implementation
details - they're fairly easy to find in the code below for individual
inspection.

Examples

contractual: These tests won't change behavior based on implementation
 - authorized file PAGEOUT evicts a clean file page;
 - unauthorized shared-file PAGEOUT leaves the page resident; and
 - private-file PAGEOUT reclaims a COW page but preserves a file page.

implementation detail: behavior can change without breaking a contract
 - full and partial MADV_COLD on a PTE-mapped THP

~Gregory

