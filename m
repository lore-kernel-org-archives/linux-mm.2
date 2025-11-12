Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D25CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 12:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5771A8E001B; Wed, 12 Nov 2025 07:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527BD8E0003; Wed, 12 Nov 2025 07:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465418E001B; Wed, 12 Nov 2025 07:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 377238E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:02:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD48212D58B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:02:09 +0000 (UTC)
X-FDA: 84101816778.13.0EDC3DB
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6EDA140011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:02:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WX+n0b0X;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762948928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eH+LicKzZZKQtDjwYrqOgwxCOyN5rsbgFwrU7hAVtFg=;
	b=DOSpS/PMk+Ju36qVHdLrO9o6Jm2t8pLAMe/U9NQBvy0iy0e18DawuMxymod869PpVpT2WJ
	8ElZ/psCbUXpRGYicMUE7t9jEGC4kzRWlPBwJ7TEXU6AYBxMvifmkwpRjWbcYAPA0QsNtV
	V0cQ6mDCRSsZrOk/10bhasv8+79j4us=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762948928; a=rsa-sha256;
	cv=none;
	b=OVusoJ8pUUh1s9vDsVIv8u+ixDg+Yedy1psFM+NFvPK9/I/dE/Dyov6DNECKH3Wg0YUl1K
	d01Ep07iVK5PW4WwqHEkRc2Y3qakdYsW5xDSfQqbPEjAu5uouIWMBa76N70e10wT1sVxFF
	roYvJrsccN5u3Gty0u9dTY4pzlSTTfo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WX+n0b0X;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5957d759726so174431e87.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762948926; x=1763553726; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eH+LicKzZZKQtDjwYrqOgwxCOyN5rsbgFwrU7hAVtFg=;
        b=WX+n0b0XD7mfKx1l6fdYNOGeuyoLB43cJ1ECYEIY7A4LKVZPHuuMpWDqyLsNf8sssE
         qHqFgVptRUbTwZzqtTM01FlK0qRPcXKLdFcHlC27c+W6KOUiah7CJ4lgwv1Xs9ryVG8s
         FCXn4ELTvunl0Leu0rOytxvW+2ZC2tikabum82JjmFWKgF+ibToabXQPLAKmoPaxH4M4
         4yaeo4WjmQQZkQDEFk192oFg3ND4veHYuBxQtFfewUcPOiqWv/lz2LZ7GkI9wkHh/s/W
         I8me2l/Qx+MUms2uQzC8iDM8EYxi8lbsjHDgFt0gcVwIBXbJi7+q+YqazI/LvdB+d0ph
         IpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762948926; x=1763553726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eH+LicKzZZKQtDjwYrqOgwxCOyN5rsbgFwrU7hAVtFg=;
        b=TVNDsc78bR15YdHtv4jHD3P3z0y7eeNwvpaksk9yl96B7AcPJoq3KF5p+AAacWjhpe
         6imd9Xqz5Ca6+bG8HYTj7Z7T2N7jgf2KGDfszwB/HHRBFWbm4olvcbN3INX+FjB1J9c3
         kkN7Te/9iGnD+vjrKG4SV4NL0+sXfhgOVYyC/i7GdBc48TrW4R8qKhg1aKLPuHyTVPID
         WDcd5STHpeQOeAKsPMPar1aMxp1TzJVeLVWMHt04KMFUMp2swCU9PpR/jTwblbrnVPJX
         NxAJnFpUFhkyzreIHvDzrkxSRHpFWx8K28qqKI+k5m66MVY1z3R4IsCLo7hzunEowyyB
         qN0w==
X-Forwarded-Encrypted: i=1; AJvYcCWfAYsI1fRDwInJ9SBilLgxb3et1gVatND6fvO3ZAw6S3Hyw2QDo+VDzOaebXCH8fM26s1ZKL03NQ==@kvack.org
X-Gm-Message-State: AOJu0YzKLVlbE8IQQ4RGZHH0EUPEi5d1Gr9vlIrDsBRz896K2ednzNb2
	u1D9idKwvupL7x7xRUCPOlwR5GlgYJjSNfUqaqrfDQMjfx1CXSXf+G+Q
X-Gm-Gg: ASbGnctTMW7BGLFu9ko5/ujPMRTA3qDlcSFgeU2YC4CcjDCYoFFSTetzTExwYGiOY4T
	o2Uzw8CFoIw39EYFmSqZeTEIW/OukK+azvs93XOaFwb904xBns2ufHC6WPL4AjrYeBDA4/ZzSlF
	FnD4VDOpBldD53d7ot4aFe3kH5zWyRb65z4Lt78AgmI3M2Q/VlNRREIUtwqBXkVRW4sW10hRAfn
	MNI8aDdOj6S7v0SgpWBFdC56zLifl1pHRRYoajpDFctZoOz6AHMQvLOy05qb36PzyWTj8gSHul6
	9wjTuMrWC5zI5orvk45rzD3oa8BZvEBkDsJJeuFihb7GSPqSBFDJWieLLrWJtMAADXFEpwrdMPZ
	1One7WTxGTxGCCMVwPywQfJAVm+daGZG3Gq4+PWlXhf4=
X-Google-Smtp-Source: AGHT+IGeLcgI5bn0B3LCjEKOV3352o8Vh1fI0N1HmS2Z+2cWfmHBHleSetqNFG1K+QPTgI04aqR5aw==
X-Received: by 2002:a05:6512:23a2:b0:591:c898:e82b with SMTP id 2adb3069b0e04-59576dee887mr955091e87.8.1762948925597;
        Wed, 12 Nov 2025 04:02:05 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5957d7db7a5sm129387e87.20.2025.11.12.04.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:02:04 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 12 Nov 2025 13:02:03 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	syzbot ci <syzbot+ci9989da8336cb2bc7@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, hch@lst.de, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, vishal.moola@gmail.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRR3O7l2Ewx-VRoE@milan>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
 <69123b72.a70a0220.22f260.0105.GAE@google.com>
 <aROasppMPmek9Afh@milan>
 <aRQyMck_MeVvvCdX@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRQyMck_MeVvvCdX@infradead.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6EDA140011
X-Stat-Signature: 1fpwzkge7mmsihhcgjbk8aj3wwgy7drs
X-Rspam-User: 
X-HE-Tag: 1762948927-113459
X-HE-Meta: U2FsdGVkX18wOpHTrEDrBVmKlmm/NBj3toO/ejaeoSyVyLWmuHgyDlN+Y6pfqWfr+oh489SiyDeUl6VO2id5tMz53Rzc1dU5nfEKRjNoAGM6kqvZswAECYh4W0YWlbiLNsPag4gbsEhTCTsU9DO/hOxJI7E6oYoh9O69T9IISObvI1I5N8I6jE7JcentUcvcssm4m36asGfHFg9ZRH9gkJBzTLkvXz7ILf/OwpydKHMxzucPGbAA/DlQdO77oPUAYcmGKUaHlmzEXC/8/KNGa7xHDo2Jj6hiDsgvDzi+hNCOUjKOmNzAJpR7hAAP0sTQzgOAY8uBFX6nDlyiVMVKwXRNXjRInuNZ4NqxEKleR0AGmdjljP8NZiqPn+Tmhi6wf4e7ttHiKYnQv3ML2R7DllUe920qHNdfrJNa93pncQXsqbAkGXnrIGwW7Az4qvXbMsDKWX080LhkYrSgUBIQgGVV/ya4syS2IqZIdFDXTFYtHB+IEq6NFZh4Uzf5XH7VO3Bwfk3Eh8Q8CTVMnHqwoBwWByw0lO4pqYyZk8xlPCc00m1FxxadhSPEC5W7UqrTSX3ctVk0kjrXYtr6P9zDok480U+Te2iNNKxTR9Gk5MM3Ctlib8FvJXW8sfjFiJ+D45Z+lq5+TG17EfqWfB4OlTHV6d7HwPbE8LeitMy3ZBKlqQxn2U1+o55DwJ/UEHExnYgaT8neVNKdOxSbLz1pdsoe7yzRCtjZxH1W4c985V419U587ELtwo4fraQuNZAsDgIsEQk6LsZwvgPI8eWFKy4sJ60VaLH1vXpb41vPdsO0hwF7ewUv38L1y/8u7mmLvIiknjMTJ0qFImJzmVcqiBAylgYIEKhnokItnOzUrRwBUw6y+XlS4meDj2hCEhHAVdbm2uoC2o1lIId83O/9UWhL2nGzJSqtjgxZXrK9C/n/d2nwMNmGAB8X9IuZ5CrUiCBIUqtAQf1OcVBMWgf
 rljjOvyC
 y4c/dBvibry7TMpvq2GkpaHV34Fsvl03qzcmK2lSvA9qZqYLxJTtVtS6GBkxRc5oq8ZLtEbDFLCElTQ2tIiBD1LMUdX5/BPynmSlbBvOZfI/21q8V6bQrdqbAJyoU7R70uEJzE2Z7cm6WGqPr3BHY4FL2RonjFyMupMEREBo4C6HO1zRNjwMqWoDJbvYGNqASI8EwDTfqKOAWUdZwJi6h5/d9SuvJwfLudbkJMGnscrYPoma4UNkpbJOXdINV5rMJFNSWvlVOkdeDmlrcgor5vDw4WUn0LfhBqXENOrPCMMdUGxhrSm1TKcTBj0dFoH3GXCvCS/uln2/gT54rztMOJ4ABHJPAwjw7/VCMxI7U4x/rwFQ9N6E+OhMO3U1t3HhiKcMqVIuWCL9k6m2xspAcTgovDbNH4GnC7Sm8MzimJFSSZdKE7ctmP5nD6nuZQQTvPrjOUReLkn7tKBE/Pq6dDcM+T6yw0SMgqN/3za7/TDtrSRFMpAiCMg6AspJiOZrrG4e/lehDquufn7xLgyjXYYBJhLJSduO6VvZWG9T0COt1DNz4usogrtApE8xMQef/Asz5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 11:07:29PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 11, 2025 at 09:21:06PM +0100, Uladzislau Rezki wrote:
> > > Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> > >
> > It looks like we need to add __GFP_HARDWALL to the white-list-mask.
> 
> __GFP_HARDWALL is part of GFP_USER.  Doing GFP_USER vmalloc sounds like
> a bit of an odd idea to me, but there are a few users mostly in bpf
> and drm code (why do these always show up for odd API usage patterns?).
> 
> So I guess yes, we'll need to allow it for now, but I'd like to start
> a discussion if it really makes much sense.
> 
<snip>
	/* plain bpf_prog allocation */
	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt), GFP_USER);
	if (!prog) {
<snip>

I assume that was the place that triggered the splat.

Vishal, will you send the patch adding GFP_USER to address the splat?

--
Uladzislau Rezki

