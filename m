Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A60CCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7AD8E000B; Thu, 16 Oct 2025 07:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798828E0003; Thu, 16 Oct 2025 07:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE638E000B; Thu, 16 Oct 2025 07:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2FF8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:53:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90F0EB8218
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:53:19 +0000 (UTC)
X-FDA: 84003816918.17.64BF787
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id BE41440005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:53:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cLA6mMC1;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760615597; a=rsa-sha256;
	cv=none;
	b=EbpxZmjtmIOpflbP1Zhhqn4LWPmC2FNkcIHAEkiAJqRpP0J9SmsHIslxlIdb1afUYteFOL
	Ci0PVnnNBgjE/3yD9z9MUqRFy65GgfeaaRgDGyJEaz9BiUw8kaEmDa7CpEEeJJOC0cETYN
	yyRkDodV/LHQEHTjq5sFEMBrT94qtdY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cLA6mMC1;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760615597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9/WZc6tWPP7q2IgMsfnC644i4MdiMeKhOgO7bjxkm8=;
	b=coDtj7DMbTO2CTZNR9SasJ0kkVN/aWRGWqXzUhhTIG+L+DldaL/LRnpFKM88TavCeXRPdr
	qbrMjJG47xTH91X8eI0898P3fxRF2BJwZDmdLsbzdiAq3N2yuXUK0/fdY2MtcVh1iwQg/4
	t9JvOYXlXGtfFewodTCV1RaoOZ4wAZM=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59070c9111eso721506e87.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760615596; x=1761220396; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H9/WZc6tWPP7q2IgMsfnC644i4MdiMeKhOgO7bjxkm8=;
        b=cLA6mMC1CXCj55hwBb0c911q4Cj/I5S0rUOgrQqXkmIHhI+IIErAXtgYO7st3GJRq/
         TYYoy/fgyiNMH9RiKYwV2soD1c1tw1pfHH7a8gmO0DUMClf6NbCK/jAd8Sn3ez0uWvVM
         d6d/hSC5dlqwk1i33vlAcAvLdC5NBdtp1HD+cxcdJqolJBJmg9SGup2fGMo1ueV//gnI
         vAVgebNitH2jw/LQjS0xP36JTm95jCT/jrikGfH8JZZWB6xCFf9kvBJxlMTEXOcXCyx+
         2QnfeCy81pnKDvZRjjBQh6WKf1LPbkv3ZUWubIfbWheBXZSgXdlyh7swFVahxKasvG7X
         EUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760615596; x=1761220396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9/WZc6tWPP7q2IgMsfnC644i4MdiMeKhOgO7bjxkm8=;
        b=OnGH8XIeeHkAxNxVqwo/0u+XrlqJR3olfWKcdOfrTPyqfnuh3qehNeDoVaSrjtnwRK
         o7uwcV58BCknPPF8FHlo/vQgyZ+UQGb7MvTNkar615dCTRId9pavX3TIYWq5vst4X5an
         sCLpvCmKpW3GbKIi0Rw6ZzWAXkW3K8U8TZ7ZFww6x3jdkHZ4Fb0xxpmr7NxQ4i6z6nQQ
         mgz2N1g3VwxYvfYzwEBnZhWoSKkAbiUmvN+5MYFFHjhaLMCPDQPk18RE8wer6z1AuasT
         mFfeC2wdtBHLZlenZ+rrZOPbjb3w89cSgHgboeEBW2MvDiUgqgOw71/Tn4pD0DAo5sYq
         9OXw==
X-Forwarded-Encrypted: i=1; AJvYcCU83+f591pNNoiPiC2RLNf1SXRn+8AVPcL0eXV9Z/emxIe9Am8ArGhxoFTuT7K7QXV05Ip1TMooWw==@kvack.org
X-Gm-Message-State: AOJu0YyDjtAF6tKtCqB5qAEzpQPDw9PHRACjdvqKTLmG8NgcK1V43Nb3
	uAONIdlxjadO2/EWIqtD5IGLInQ83LXoTpCd3iZct4Kbc/YWYg4MUOPU
X-Gm-Gg: ASbGnctPCROTeC9CbCesuc529xlhP3amkWSFlkCcOASh6KBXyStkrnSOJDLByi+ou/M
	d5QPFzi+rAee5di267QLjJrj8RTNJ2H6ftqgYuObe6qGTK3e/TRkxslTeLzOVQDcfSy3XfPGSwH
	j78q1tSEjGQqsfOnKuwSSG1lZKw5W3/nub97SOf22H+sooRXvrdHRn6iH3XzySCphCLhrL9LqqL
	e77z6AzhzsAyaM30e2H+IN8wCWgrA3Vtc6E2h6HomtVV8jPpJ7cG4Qm4DX3rXiDrHsVby1JOdIN
	xn1dAJGPeRjXEVqQfMOupCCRjPki6HuEnkryYrmzHoWfGRvZ+RHlt55N6lySKSPdn9FSQb2qqxI
	BJSMI/mo2ddjezlfEUkP4GkoYyeTxOz7XLko2IlJwRt0=
X-Google-Smtp-Source: AGHT+IF4BoxL8i+TQCVTGE+8R5s02XQLVhbg1to8ADSbMDVrwm5ieJsYsFq7vaP2gTbLxO7SMudzMA==
X-Received: by 2002:a05:6512:1511:20b0:591:c202:45db with SMTP id 2adb3069b0e04-591c20248e0mr2615876e87.39.1760615595507;
        Thu, 16 Oct 2025 04:53:15 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-590881e577asm7050809e87.11.2025.10.16.04.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 04:53:14 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 16 Oct 2025 13:53:13 +0200
To: Christoph Hellwig <hch@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aPDcqeHUj5xJEbV4@milan>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO9Z90vphRcyFv2n@milan>
 <aO97BjvNZNh0UV3u@fedora>
 <aO-Wxj7al7I-IadV@casper.infradead.org>
 <aO-k2hBimow9oYuR@milan>
 <aPCXdDPlBMdfFQgK@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPCXdDPlBMdfFQgK@infradead.org>
X-Rspam-User: 
X-Stat-Signature: gefopy8imqy8a5tpb4jefbwwseconu85
X-Rspamd-Queue-Id: BE41440005
X-Rspamd-Server: rspam09
X-HE-Tag: 1760615597-554416
X-HE-Meta: U2FsdGVkX18zrTRxyixvyjqsCickltfrdswnB9rmVO7pv19G3UOCs8danysAgn6Vl5dtYCdEgKVU2VqMimXD9+ohjmLVdXauVsSpaklg36ZChJW1kcpD8btkMljEPU872J3l6qzNxyrB5fytfSlIrYaXfMKoBjDpOl/O/EseyadeqxreYVUGZg5K1YyDtd6ncXPmBxQ1Xcryik2tSO1Y4+20aYKPBaCNA+binbnhZZy6bOP8iB84aqNK2FoOCdRzYf4vdd1FHDLQMFxmbK4m0ynqs6b4yNifHP36zNb5g4F+2alGMQje5hn+z4B1riVJJphqDZ6YpPFsDjEsB0JHjj0GwlfgC1Tg/EBcfjhNWmEWK83LM6LgSjnMHiNS5cBE/BJvJjm7O18rQei7qZR46J4r2YJoOxlF83Iq+W9IDioQW/JLbKrW0KLYQSiLE8nhUoxr0TBK/VAzrM+/Pywfxy4J8L5tR0DOt4fwMjqIL5911+izK12neGPPf1tCGu9KMjjoD+8fAs8AEEwKKRWWecJwpkcBhWWYo5S/dKNjSICbIMVtjbBYEUPfWUDBIo/MJCwgxqZySrmhwXsscC0/hivplWUYMMGQosEu1EeJ3vtfaP7/5y6ZEAHBmwf8VlQmRNoGu42upCyLJMbhfIzzTRspY+k3o3yPL7esvTaR1fJX4y5Gh24YpfDtLQ4rbXEQ/VTo85+J/J+l3LefhKKaT+rY1Ne3HajNJwNWuMYEtkCxoVH+oQHEv5uiyORBbeaIR5SVEr44BTl/9QUGMFNUvohsrmrrp5JRFJuljdSeHDNzopopEPYA5fe/Vs5D2iRINXmTu5vkTJJGmTK7+SAvzAI+gCZVUrFNeXYTFqIpe2SQ5lENqROMSKtUHCzVzueiEv8xctqOv1ImQcWCm8Qeb4yr1exfXBb8xIacdu9hopaq1CdO1hrWa4SZCUBqnLCPNK68RYmUqQmSKnm71Bm
 I+45mtfP
 1tM5/s36PNqctvtFmkwlbmMEEUnkKyBa2PJfIbp2/wQZQR0STQp1bH3t7EtjUKCendTHVTLmDf7Fbudy6Eo/AXJQuTq9mXdmCfW6RYeAjHqPSnIBd90eeMHjtWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 11:57:56PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 15, 2025 at 03:42:50PM +0200, Uladzislau Rezki wrote:
> > Agree. We do not want BUG_ON() in split_page(). I think it is better to
> > control this even though nobody invokes vmalloc() with __GFP_COMP.
> 
> Please explicitly warn and reject vmalloc calls with unsupported
> flag.  The fact that many flags get silently ignored or dropped or
> could lead to behavior in gfp_t based interfaces is a constant source
> of problems.
> 
Thank you for input.

--
Uladzislau Rezki

