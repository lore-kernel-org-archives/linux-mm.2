Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C7A8CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 04:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0AE8E0002; Mon,  1 Sep 2025 00:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5781E8E0001; Mon,  1 Sep 2025 00:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4F18E0002; Mon,  1 Sep 2025 00:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39CC58E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 00:30:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1A4C5A34C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:30:39 +0000 (UTC)
X-FDA: 83839405398.14.7B45106
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B9D44000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:30:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=gDC00FCW;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756701037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDQIe0i3X76egFX6529AeV7wfu/j7t3pxfvYUfSQIbM=;
	b=q1sjX4hEruVzO50Mx/BXGC79EFPkhwp8hdYW4IBIH+WG2I4AnNCmNV2Dof/+E7fmCm/qt0
	NkZfkvQIw3EsnsScxQteAFXVeLWlT+K882sFAkKst/mZ392LmoiGD0U2fQI23CYXAEXWJ6
	0v+5xKfLPDOlQF1ejseeol/pDEqC/wM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756701037; a=rsa-sha256;
	cv=none;
	b=Nbpvux7Gh5WPlNuFPterChy/Pg9ant9bt5RwIHJIFXECM0UI+ee0rpGtk0U1qPSlAQSz8h
	5mWJs9AvBQruZdRLMuhKxOhk0sTN44cOqI+P5JGEau/xS1E40DEm3bFO8+x4qCac206BgJ
	DVhjxOfUr+mu9Jd1ySSDq1EvgIe2CLI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=gDC00FCW;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b0225483ca0so244690166b.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 21:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756701036; x=1757305836; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LDQIe0i3X76egFX6529AeV7wfu/j7t3pxfvYUfSQIbM=;
        b=gDC00FCW3OF54BpMkWlP9PCfgTlUTL94UbLP26G4Vo+3GzhI/IKaAo988qCQW7s7kg
         DeBae1xUK6WpABIazlodPG4aneUgD54JYPTIzOh9QlyeTBogThwG2Ab4DfzWT00Hp7Qe
         O/w5j8XMelFH2HtAsbeXe+QiyyX2tqGOovw+YVttVt8uDoUHvV3OGzHjXyD9obkmcRWQ
         b+q/iC+K0EfliEE4wU3Fs6RpIrFlHMqgfWmnpUZHdl7qLdpFigGaetVEczfSQEVij3Ck
         rkuCYdldvA5qHoE+eoEXZ+MlHPUrd++L2oN0KGiumjwqqIPIS/a6zq6wpma88k7v4Tdz
         v1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756701036; x=1757305836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LDQIe0i3X76egFX6529AeV7wfu/j7t3pxfvYUfSQIbM=;
        b=dQbTNbF5hl47uDbBcyLAHFTvgNasRwJyg+EJh/4XH2Jr54CQXFZbkNLtrMbv24K6s5
         wlfI9XSrdkXcWhngXQLF+mm99Qm37+y1e79mkCmPfXi+AuVGNaxIaYFf9uCMYpWHRL3P
         KaZPYFiO/k6HfH+/w1N72eAZohITOZr7gy3uozkvonzQrQuAt3U91srjUcib7TtgNlYh
         iC3XEQHpLHf7XQ3i31uKz1jn0f90qIxEkqtRtjBHw2ALRukICJtBzu10uLO2+E5BPwQ3
         5NAXvoeGjDEtEZzmp4dU/LU82CyTiHepyp4dDqAVTXaclD6eYRhIW3PO1NL1ql6XG55w
         dQCw==
X-Forwarded-Encrypted: i=1; AJvYcCUZaQS+AFYDQQpaFq2QAX6neXVpEw/PGYgGNTTUyT4ZG2DE8+wEbTVdcsywAaQNevY9/HhHMQFLCw==@kvack.org
X-Gm-Message-State: AOJu0YzXvc+L98TIhprm2PTlQcSX9SSIuk3ihk3LaImqIDSQd2rIWBrG
	RpioWojynTyhSgYU05lq+4/VhNhxkUIn8pKTsJaOV6V1MkuCcqbYeEdh8KR6NGyJhUB6qFzWaQZ
	ScVZuzUlhqu8boNn5RGDgSFzYrca4LTeykDTvm/RHJA==
X-Gm-Gg: ASbGncvtkmpdT39YvhON/9ql5Rlf6ul1otZIUuVtLyiQApHkQSgFGYOc0KQr/JqkFmU
	F4OXTpAC1MKiqi8MWHGUJj7OooFKiD3Bi/SLgsD4h7qX+hx03wVYvnYSF+82EvfJRhXobnIc4gg
	AHRXz2umii6eQwstr9tpQIWnpJHTsV/wZdlI7jD77++r36OAZM1FgfqzLCPNT7brseQTdYl8GJ0
	jWiqoemC8tHldoi7kVX3WBPrOp+pSsT/3EfSM90VoKcSg==
X-Google-Smtp-Source: AGHT+IGfZ9IK7/pUtfeHc6DgLv6HZzhwz9kNk2kkDLAQy9Iwa65qh4E0Ue47kA3UHq9LU15ooN9UNEALddPaiQniOhA=
X-Received: by 2002:a17:907:3f10:b0:af6:2f1d:a73f with SMTP id
 a640c23a62f3a-b01d976e782mr648284266b.53.1756701035779; Sun, 31 Aug 2025
 21:30:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-9-max.kellermann@ionos.com> <202509010724.bSPPSD1X-lkp@intel.com>
In-Reply-To: <202509010724.bSPPSD1X-lkp@intel.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 06:30:24 +0200
X-Gm-Features: Ac12FXx1zNxU809yDaeQgGpOMM6Li-1LYjsJkwZ1JPL5dRiRDC0y6VWcjO3jTXw
Message-ID: <CAKPOu+_7w9kd7aOp2J2YtYMDbrV1pfrdUT-CnPmHfexGb7RScg@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] arch, mm/util: add const to arch_pick_mmap_layout()
 parameter
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B9D44000A
X-Stat-Signature: 6knbgso4winhtgo4rwqzbbush5jxnkpz
X-Rspam-User: 
X-HE-Tag: 1756701037-61557
X-HE-Meta: U2FsdGVkX18jGT6+/uIQzBgsL5KxlxiS5gKr2Fh9u1HHhiNm0RtddqHQONeGOaB3o0AXbLVY4lTuTzJa+Uh9KQO7QFPF4SDRRkiYEIaCM7b8EyZcIFGqbhhefROunbhOXaFUm9hCs0Ar5irFhjn3TnFGiAzsv8DSSA7gbpKDzAQOfHtJvFf6pWd6Zzkxhwe8tLKQ51mANmqyomS4HnYU8Y2IH6mDKR5A58PE+cQmJ09tkOjzRZ6aVENzuAEtub7ktkxLlyKpKr2++e9UsufYJueOxk9Pz4QNYucUTbVIZwt72JvglLpo04WDeFO8AVukFbFYWGWz4kBQguFvJqLBYA1GTmNfrcAc5Ffs/V9jnA/i7tvMSj6gXE4KvgmB+2smTJfKXPP0cHIaStwI7D1D582K9JKXwj9QxVBlYjB3Bv6v7DUmoIjmohDcOHbXkXVhwlocJv5+3dsFc5+1gFWF66TOkearnnjc0pyeLfsSSzGTAZ4sVNwwpaPwdjmoSnK3dhEkxdGDaMW1jJkhdys/00IosW3Z6StHocExJS4pqxHQbk1b0Cz+l8idJwKQNFCj7edLDelvGnboqc6+t+gP/K/+4p+VgvOMVkFPCMe3mde0u2pRlmgY5u7RZTg25SrWkDgLJloJFAEcNM1kV2+XvZ00JopXiC9MrEiDai3zK2lkHUrteMCGQdKoIKiptvMLkg0ffRSNMS8LCN/li/ktsx5N6qaXp59xKnywYpMCOZuhydXaHAtBBw/dflIoBiQbH5Did8KxHfRmVojTGY827gl5nIO8ueYWXCfpaDYAj7wfw617PvpUpOzdO8U3NhcpwoC9EAdNJJh1i1LlxOW1CoCVLWhVpiXTJICitMeH1xW/bIdFOHh6c131BANnUqbYPRxNOYtRb8r1vR2/FensNvdd/rHd2Kb7ohb1m1Xk4m09gUg3eSEurTNQYT/hxj9SUVr9kk7RteBCLL6vVdx
 8mrkQTRU
 h7zHmsKIjL6XseN53W1OlbfMZ0ZMQ8E+Njt6dTj7oAnMBiRCjl7nT+KpQS6Fnhe42SujFkwEGVTl9f7gv63ihSm/WPPr0q3CjQl0WQYUB4WvwTvrYashhwjdMhnhtI7YfdLc2RHuZX708FyNA9YXkgOEGZYgGsgscdFX74d0v2UsZO911M6ub6fv4lpzOyCKcZ+tc/FicMBPQSsKIDbI1Rf+pkMtA1ZyymR2rzUJovkWAwlMSVPJpKDK4LUgSu/ALJ3Lr9nr6OJL0qcjMoUPAtih1PCD1iWRXTkzNCx0erL9hXrDA5qn0jVmcU/4ehVVngGC/gzZ8cFMiJdJEZ9/OX2i9GT5tePQDnApr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 1:44=E2=80=AFAM kernel test robot <lkp@intel.com> wr=
ote:
> All errors (new ones prefixed by >>):
>
> >> arch/sparc/kernel/sys_sparc_64.c:1:1: error: unknown type name 'ickj'
>        1 | ickj// SPDX-License-Identifier: GPL-2.0
>          | ^

Oops how did that slip in here...

