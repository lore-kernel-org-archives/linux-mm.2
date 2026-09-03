Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01908C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D726B0092; Thu,  3 Sep 2026 06:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40956B0095; Thu,  3 Sep 2026 06:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DD46B0096; Thu,  3 Sep 2026 06:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B88FB6B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:03:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3991280471
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:03:22 +0000 (UTC)
X-FDA: 85172013444.18.E8F6ECF
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D1571C0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:03:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XM+d3mjz;
	spf=pass (imf21.hostedemail.com: domain of vdonnefort@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788429800;
	b=76ACQ79xeuL0PYnqpSziX4U9yAErmrBTgBCThyGSqBs54vwAkZFJMzqZS5zHCwgY9qv08Z
	2B/t8YZ+oT4E3JM52m2JXnFZkMK3icT0X6dHobbmXNAvEd7mSLc5k6qkoL1OA3mp/Zd5VP
	wBWW9QDGrXZCUdLq1m9UZ6q8lzkR1S0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XM+d3mjz;
	spf=pass (imf21.hostedemail.com: domain of vdonnefort@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788429800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTFqZaE5WeXzEFHRWSBbenebslM+9RuyFvHTxQmSgMQ=;
	b=xsVLHIdLOKn1TBFTfT/jhZvWJ5F9+zyZJdAQwWPp/7I3QuiY0me95trJsvZR8TeATyfU9c
	3oQHvzwl9FpRad2jIKlSLf1cdOVBQNjgOapXSx//dXVWMkpzYDE7GVAIrDJue1qfqFkv5T
	5rIn51oIvSUrWqWoaSjv96hsAdkqd5s=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a65e66555cso3157275a12.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 03:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788429799; x=1789034599; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NTFqZaE5WeXzEFHRWSBbenebslM+9RuyFvHTxQmSgMQ=;
        b=XM+d3mjzLAIb7YuYghEePu20SYu/md53ojGuhzdrnHJ6qfcUR/8HjyNtnWcmsAX38l
         hBzAa0z7FwuII5WpU2ZxNVaBJU3D1mlWNKUGkEZ2iZxjv4MO4cubbzVubK9NAyxIszxf
         WXJe9b5XS9PpHk/Lu285RB1RsSVth6v2uKlAn7gLLPW5WRvxEjRoju/MfvATBbQtkD6G
         EB0BhezaenUQ5yM9HxF+6XKqFK86QinJm69NsroCV/qwulAkwItvh+mxXuI/TwArSUKk
         20dt0sR4nLCtwbCRb2Xev4c5IZPRee4fGOGit1dePbKVG0R7LZv9SQ9ZjCGJ4D0W5mZb
         CvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788429799; x=1789034599;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NTFqZaE5WeXzEFHRWSBbenebslM+9RuyFvHTxQmSgMQ=;
        b=ZZfLLDFzh80OXIGUIMshPqmiORHi/wyHUMGHVC2pjKg7S94B0uSImMBHT3TvobG9Em
         HY2XVqD5TRxPoBwxJ58dWfTgGTPAwBcMfuL6rq5OytyGYW2Dadpt2U0+vRVSMDkRazSV
         HNclK5hoqzMTSVLmaynfA5PrjcYDBwlGPkslGOWFAheSRYLcCEDix/pnUtvoqR2+lbX2
         EZ9NjemYh+o/wq5ZLPdy1VwsuuU316Yc4Mjaf1t5Z5gsQP0lZJfJ1bhe+1T8r7pHHXKe
         guRzW6ySFjY+akT81r74Aw1fW2LKXx1O7Xu/TVeM4d/bjqxXJYC1tYd1tMrCPjI1JEkl
         aBQQ==
X-Forwarded-Encrypted: i=1; AKwUvBz0XmnUeotbYmGygpm3ja/AcPfWB2AfJACDsCse43jkMD/1HDNWTJR+kYHzEn1eddc0/wXZQHXPPg==@kvack.org
X-Gm-Message-State: AFuF++kENRRS8bflrafL2jvC7MD6ZiZmidxnjLACPo4AbJqtf/AnPYpp
	PBn7jtStEu4Q3wpOgbFyUDvyjo4gLj2c1DfhZ3bq+ZPalXPo2nBdYDq+yXgWCorpzg==
X-Gm-Gg: AYBFou3Q8IQMhx6ucuBtUJp86doDAavn9/Xs+ayJ2lFgHXnhfYUJRjomCTeZHy83n42
	DLN13S61mXWYLQRPQsxmdShUtwncKtrQEZobyupKP6MtyHuqHO4tr5FhbYpE09Qd6qAzlU4SKI9
	HeCb1imfxjVYOkGPIkg0nXuzdx5u9BPI5dvRFTxIWi/YZj5MnTfLvvBdlu2MG8SoZhdZXWNgfVh
	6wBiSdFQzOox0XDvMjg4kejaaYb0spE5NrhqVrGQXpAoIrDN3C5i3/oNRcaCaCbOQS+Q+0b9RoH
	Va5miEAKZAIjIAkXcNznzEGgdwkuqImRhp06qDX+mkraGd4LOFzM6jRZiBzKNQWix4qpSu9l4dV
	Cq8Le8DNI+eB5UCp+4epPhgW7gpYmRtMh2jJCey8ypIocXl1oAF14uUirhHClTCCoJA2mi3epo2
	lt23LtJxQTe42cp0DK1o6lgAiv1Qlu+V0BD2GpAx2K6f+/vLigPBKrNMZ4Z7oPwVfUpj7IzCpLQ
	0/y2ynwmO/c15rnnw==
X-Received: by 2002:a05:6402:1ed1:b0:6a5:f4f4:5c0e with SMTP id 4fb4d7f45d1cf-6a6829afd97mr6824116a12.14.1788429798174;
        Thu, 03 Sep 2026 03:03:18 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f8b47f7sm2104420a12.9.2026.09.03.03.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 03:03:16 -0700 (PDT)
Date: Thu, 3 Sep 2026 11:03:12 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Rob Herring <robh@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org,
	akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, mark.rutland@arm.com, sumit.garg@kernel.org,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 02/10] of: reserved_mem: Introduce "ll-map" property
Message-ID: <aplF4NaoFk73d-c5@google.com>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-3-vdonnefort@google.com>
 <20260902172436.GB1440252-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902172436.GB1440252-robh@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6D1571C0007
X-Stat-Signature: zxg1y7xdocj88swr5rkr9doimmw8g9ed
X-Rspam-User: 
X-HE-Tag: 1788429800-284614
X-HE-Meta: U2FsdGVkX1+opJsvJFyHvG9ZS5v9yKFl2e7HgMcbmjwhzg4pgn5at/m25bsvgukv0IYFQvFDFZZa1sHEucgxM93kufx0RIIS0rourrG9dwJks2CmJ5/WQsGvhSDGde1c4n8GlYtdLaXQW/HXOwPF078xBuBOljAy6Ozvu6R6U0+wToJX1GG6u+S7sft0ek4nko7sd2l8v+G+QS9jbGaPpO/ZOQshG6lwK1uostNhPDFg+r4OfajXM73W2hjzJrtJoFe3iHq+Xeh0QZA9bKPh04ELwdMVk1vb5IAECNERBJTDXureLS79lG0b7Z2gZRqJJsFnV2zef7jkKGpuN+AG2tmslItQgOiudEQUWY0AWMIlWyAxHp27OEyksSeXHZL7EeSACybu0IXn9WsH6xP9Adnw/mHvBu66Z5iwn3/0U/eq5cQliiZ1MV0dvJVZ0kgNCJIWuZ7BykhtmE5UtkHtprQHdjuHGKpVODbyenHDONUuoMNiSoRbluCTOqAlTeHaIYrMDh7mhOMih7sdZY0HYa0eCBoYGUGkT47ys0EDV+MqL7rKvgOWSHJduw9qesnS1PhhIXNJuySLwfXVgx9+q6rhSc63UXDvyAEg5aJNnTksPJSqSI6pRnwRIt38+L42EdABXGmy6SFZvFn6w4jkWRBYOS/5eCgxxlZo+wi+6hdTY06A09mb1ABjgBROFMpbEGu8Ld98xzFIzBlXW5c5NUBhHwO6xLLkF9Uk3X48jGJHmIUOnQHDJCYAXoIuj93zPVHibWV5eAapQriaHNbo3SKsEfNsTLaLmgJD/0/nxoOC01RnfxBxsvW+J5a2TEnk2J4ptVXZG5iKsng0g2zscffumljN46MJRy5BHPg8zEIflZDVhnSVsVsradekZDyPjBxDI392dZlXNheSzoJvofFcXVqXVsqz7hTvHxDV57nAaHdDo5M1xLoZGXtTvJ1QJbqEXWEFkaikEHyO3Kg
 gDRwNNeW
 kgAn3PKKN3cP/Sh0hrPaEyXDUa6t9Cg3fWRy4ZTq0Mg0mmp8WGnVQOxmlqNwA1MrtkpgRKVQUgik1FbhNkQDkKaGLtEM1wOxdjKu/OSAUy8nPzrJveAjUzN/T8IFb7PPxpieaoiw3jdY2u0bAz1UZUxR+Nih7+2zA7GKzF1qMeqt5IcB1JLj88SseDKnyax8b2riOS50A8E5heYzKCySP5JOlogoripraxouQeDcOzVLFNgXbw+4gbEaSNtEhzGIDzt8mFqTGXRUCV0aoWEXilSWR0X1MCvJlcD5pLSzzq66TgfJAhO8tyVIp3wAyVetBN+PI4jSSl99Y+KPOwgpf94xJDS3XkwbguDZIuEvyGbW7Y0cqNJKLrOI3NdZfyEKwpqTBaPDLPQ2f0i5DgBUnqDcCZk4p3lgzYnE8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 12:24:36PM -0500, Rob Herring wrote:
> On Wed, Sep 02, 2026 at 11:47:04AM +0100, Vincent Donnefort wrote:
> > Keeping last-level mappings is interesting on some architectures as it
> > allows mapping/unmapping pages from the kernel direct map without the
> > risk of splitting blocks which, under the break-before-make rule, may
> > trigger page-faults the kernel can't handle.
> > 
> > Add an "ll-map" property for reserved-memory regions. When set, it
> > splits the underlying memblock and sets the MEMBLOCK_LLMAP flag.
> 
> Where is this documented? Any DT property must have a schema.

Ack.

> 
> Though I'm not thrilled about more flag properties. Handling all the 
> combinations of properties has proven to be painful. Can this be implied 
> from the compatible string instead?
> 
> Rob

We need this before the kernel direct map has been created (paging_init()).

I would have moved that directly into the driver lend_pool.c, but then it is
probed too late (unflatten_device_tree()).

-- 
Vincent

