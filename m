Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4415CCD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 09:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A446B008C; Mon, 15 Jun 2026 05:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1B06B0092; Mon, 15 Jun 2026 05:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707A26B0093; Mon, 15 Jun 2026 05:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6000A6B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:52:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 071F91C2F43
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:52:30 +0000 (UTC)
X-FDA: 84881682060.23.EBD8B75
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 06705C0006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:52:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NsCjXYX3;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781517148;
	b=qByRYR4mRCflLkPLU1iLv80EPnvyWWrLG/HodpyibqZbgnvx4Fqz97bun9fLuT+7NqCfOZ
	qH1jdOB7Bn5PODL9YvSP2qMncGYjdsZsqIkft1DoWG5kcVGm7PrBMc1/hism4HaDPIYc/w
	vZ+GQFzpCwzHO9WYT+R7Ub4En8D5oLg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NsCjXYX3;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781517148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kj0Gn7Jr1tSJCs+Q3oh8GCThTx5Sz26eyH6pCBt9/Lc=;
	b=HD74sxxU1HpYyagdB87ikkm2irV6b1tiQCjRqBIyf8Tlal0ZMpxiQ88ZNb7iuANY7qiSKp
	wwltIf1qR6rIurdXl5iyyL0cWeq9+ICNdSv98+BMlSXFxgJfdR5ywRKQOLyoBW0t5b/sIh
	LNCG4i+2OvMmpimkIxUhi+23bmg8L6A=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39676d82b7fso28149281fa.0
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781517146; x=1782121946; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kj0Gn7Jr1tSJCs+Q3oh8GCThTx5Sz26eyH6pCBt9/Lc=;
        b=NsCjXYX35rBRJ2cTXqrOBuB2MZOkHYSqIt0mmCKHXESIWxVvofKuH5yUuZxp7B31Ka
         zyYfSerTW8E77u5Rpw0ZOX/6XSS4ZYBWmU/B5/sBZuxfeD9CJJUjYMrU8cbJ1Vrl9V3w
         suF1CNrptqRkNn2Tppp1yEDksZHTKGDDkM715ixQx2N+6xvsbJ4JtxzK0IEQHRijKRd7
         jzCnFAr5Olga8tXD6AAMnxsMRfl7JLUj16RnMdRNyrAD0+wJhKwjKDZbkba/6K27V/3d
         Lk1y/kZjJSE4MHDyqK1AIprw7rphlZvri0dE+1YqY+xibEh4J63f+7Rgf0mVINoBvXqe
         l1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781517146; x=1782121946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kj0Gn7Jr1tSJCs+Q3oh8GCThTx5Sz26eyH6pCBt9/Lc=;
        b=oESvNjX8c3A/7bI2N66Q0G4fDV15DY3kDgrQXt/Qw41YPDDtpqBiJaOUgprNAIVb1j
         zbTcqj2V5BffL7CWskf+M0A8zn1xIW4qc+ZiUMEHGlwDZaKxpTQxln/pL3yOYtMuyBk+
         Iuki3zO95kZ9h8erIctD+y4fOR67DosYlpr2ChMlLgjN7ozR7h0kNgDl0IMG/+lUu1/q
         i4NwFYJ0221Y23hfFPywrmYQaUSh6LVLBHwR5U1G236T3fDohgqIF0yt/bFgwhvLwvrz
         m+PKjPNra07aheV390r4vFzA88sKilb0bwyRK3OwWFDrZxYecacXe88629YlS2WMLtqH
         r+DA==
X-Forwarded-Encrypted: i=1; AFNElJ9hEZr4a2RbbBbQnDLGzaTquF/1Lrx+76BodJGCMDH9rgYRPgmrZfFaR+pzmJF8ta2w2KKlY2Ojkw==@kvack.org
X-Gm-Message-State: AOJu0Yzi1aVtV5qHvsq5DMFvnVCBNXRSlKchgGR+AB4ILme1d8msNqaU
	4QRPzypmXU8Wsy8PpvU9i7bm2M674/15Nu4UgZ8NqSzpCIxvJHLAffpK
X-Gm-Gg: Acq92OHXq/qPSEj25ZA1YFQH+HTTvAHBGr2Y+U/3VqYA+q1a0tHIplqFy1OAOfHHxn3
	dnklroe2xjJx6EpEyenT/W9VMOGebCI0G72OFTEnHG0/fcrmENpy0QhOX5s7i9cMlgNj+d90DPA
	/8lLftHqw10tWzMusA6PKSUifL9i/six4HZz/KOFd23TgzIF6qZEPmLSNu4zM2/EEiBOxudlMzw
	d8rob1l/5IrrnUee3tObVkI9dw6g38DOS5OwObNj0mnjXrYVnD9Hvu0MUTQ5UfunCoWoq9FtTEH
	g4l+/dLMlsGYihfciLm14uuxfpjuyOzhI0LJneJwhcvJEUMCow0OJWDZ7HnCE/+fsbX48yMS2gD
	Dv2e5o6nY1VPygTnBWdarEzegpvtGwwq5pU0JmZJWmcpvWQC5y9mwkoER2t4NkM+6fQCS1FfBwM
	moaNwQimupWJoIC0grE7eai0eJr8+sLM0IT4D8NsnlG+zo/OvO
X-Received: by 2002:a05:6512:800f:10b0:5aa:8562:2a7c with SMTP id 2adb3069b0e04-5ad2db6fcd1mr2639291e87.31.1781517145832;
        Mon, 15 Jun 2026 02:52:25 -0700 (PDT)
Received: from pc636 (host-90-233-213-1.mobileonline.telia.com. [90.233.213.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad2e161fc7sm2679862e87.12.2026.06.15.02.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 02:52:25 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 15 Jun 2026 11:52:22 +0200
To: Matthew Wilcox <willy@infradead.org>
Cc: Pranjal Arya <pranjal.arya@oss.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mostafa Saleh <smostafa@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Shuah Khan <shuah@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Brendan Jackman <jackmanb@google.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Wyes Karny <wkarny@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Message-ID: <ai_LVreyRWx-RDEd@pc636>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
 <ai3kkIpaR0aT_6q5@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai3kkIpaR0aT_6q5@casper.infradead.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06705C0006
X-Rspam-User: 
X-Stat-Signature: twumgkiomspcxtwtpfzx6knj67dj4mt1
X-HE-Tag: 1781517147-367642
X-HE-Meta: U2FsdGVkX19ffGyVrvnuSwBr59CAMTesFIUeNb4pCNaoi4/uvy7VE5uLOCKVmMLWUgezy6tNkPZzLVl0oiKga+IpMDq31llj4TOMUKH0m21CrfZ6YQ+Dh1VcGvYhNymziOUXwBZEqaaDUfg4fEHeTDlqgFwetNrmLUoKkf0wgabyF6QQpTuwNBjn6Y9IaYk8NUYrb54tSsnodNDUql0R6GaDuj6tIuuzByOrl1qAoQZ2Wpmx6Gn+XI/ASczRYnpUfZp5XrZmKQO0/h6+Pp0P12v4ZCfoxKWrZhbupRGDYgA/gkKyj/xCtH9Xk5q3GfW15WuGrNIKjj+nOJsIV1MfEZg+seGAMqQ4FppQcyXim33oaoyJZ41BDYZiL2dsqdpDmfWq/hciC/TITH1GGXLMYEa6Uw+MSCNjReIATOKriEp1D9p4ZRxffDlsjUChvELmDYodANDIvpztTtvtygbvq6UZxG9k71U51GgiPxNyaSDJooH1dHsE0L8/cxODPATysCQP9AXz/dLcpc+IIFylyrp60Dt7wHd7ke6EWa5gm5DRttUB6kW/1kZ30l9Uym8gkMvCURpJSgb3XxMVuYEXa/4ubzvyRtmXzjM04xZBGcDXD/thUDS+mnhulR4nuewo6BoIgjbxonSKOxf2NQgr9BHqpNPvRw8DO0haPyPBYQdV2ZqHBOu1L72rlJGmsL6MsGxrjXGTlfP6tFYs7w1H6wiyx3gjv5ialpJrjhm4ZpSWhGtc1rtkD9CER6/r+/Buo6huK5v+WzBfNwIuslEsbYWSED+xpNVFFCLcFv+cIfY+zF+Uib+9UgmRybVwHeJaMy223dfPTm5yEmzpJWfYqTXzk//P36mkK37cpR4gUkhNjsqTXhz7F+K84FIK8Uov/GGoT9ihkxVkblYSAFQ3pqXH7YfLUr3QQOZnEsYqQdjVqq4NW19SMsqSZd0Md/O2cnya9mpqfsnpGnktkN1
 trcLeOpr
 MdWYZ6yGyF+zfDjSOXxZ7HDDroeTmWTTi1AvRmJbZTJ6Oi5ycvZb8h/IYBYBswX9kRPMGnHva4VDZAXxDdeZBgX1LGTDIk8j+327T0x8jjh8syunZBVXY1VRxUzuvYgj8gAxY0SU+mcuyn/TAw0BIdWrMzhVQaWiY+kOVkskZZ1x14WX9InmEujWmrJHhsix/4gRulI8oesnxJyvRz6xMjFKEEOjcsEoAh0E31ODcEP62/sCklY4aJ2IgcyIkqZRcfjtTQOKP3iP9B5QgluCkN5Pt51FjYLVUOzt7mBLMTIfR6/S8T50GQ1TZKHv1N+dztWmqfG+79zFEW+3LgtaE3X5nhQrrCMI45PVRuMizyVivNusoESDeemSPzj3Ka83GLjCZsa+/DoCU3U0DA482Hh2FV7pevGutrO1/2B58AxJ2r+2YBcAn/8W9peLp0ZZYS29sWmMurpksWfvxzTt/jTT3lrHsTnRMfQpMNXTeVILWSl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 12:15:28AM +0100, Matthew Wilcox wrote:
> On Sat, Jun 13, 2026 at 10:49:42PM +0530, Pranjal Arya wrote:
> > vmalloc's free/busy/lazy area tracking is one of the last remaining
> > augmented-rb_tree consumers in the core mm allocators. The rest of
> > mm/ has been gradually consolidating range-keyed indexing around
> > maple_tree (notably the per-process VMA tree in mm/mmap.c), and
> > the underlying reason is a structural mismatch between rb_tree and
> > range tracking:
> 
> First, and most importantly, I love this.  The maple tree is undoubtedly
> the right data structure to use for this purpose.
> 
> What I don't understand is why you maintain a separate "free" tree.
> It should not be necessary any more, but maybe you tried removing it
> already and found a performance problem?
>
We maintain it in order to split several entities. That prevents
interfering between allocated data and vmap-free-space manager.
So in that case one context can easily access allocated data, for
example vread iterator, etc., whereas another can do an allocation.

So by splitting parts i minimize lock-contention.

--
Uladzislau Rezki

