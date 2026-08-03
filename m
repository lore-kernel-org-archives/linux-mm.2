Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 001B7C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094F26B00E2; Mon,  3 Aug 2026 09:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06CF56B00E3; Mon,  3 Aug 2026 09:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1456B00E4; Mon,  3 Aug 2026 09:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C93BC6B00E2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:40:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 601D740645
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:40:17 +0000 (UTC)
X-FDA: 85060067274.05.D1AA931
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 83AE180008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:40:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3N5uJgE;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh03OlNdDw+4kjPd92fOhjRCwcrHdHS1ETPhfGn0lso=;
	b=b7Yh8upaiLkmbANfbZcXFcuq124GTqnC5CFiRZLPvMR000qWP5KvuLc5Vx7Uu4ystMmJTc
	Jjz/yx8BG3BZgM1Q6zDhaa4XRnSEqwn/RHO32s2flvm8e1DLS0bIk164ygYKWK6gSgvP/U
	RWkL4P4n6ckMCY9nOsUcuGAKoPukh4s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3N5uJgE;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764415;
	b=W/xhacGykX8tfhGuHc5f68yDhk0RVnm9G9HB5TA97oGEcfelD8BtMB6Cg6YuiBGDDMkKyK
	FM8y1Azh5aeGq9XW7Yeoo7LIkRO1e1GlTSXO9ccr5Omd/5knD+weSywT2xynul8daYcscG
	suG6/fYRXfPuIsM/9C+iDF41V6L01o0=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15dd4b9132so531007866b.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 06:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785764414; x=1786369214; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dh03OlNdDw+4kjPd92fOhjRCwcrHdHS1ETPhfGn0lso=;
        b=E3N5uJgENOQPlfQfgA6uG6/rJ5S5SFCY23I2jlCg5OkMLbMr4f22sgp9y5Y4/4NKEs
         xoIkrpuwMs1ecU0Z06u5FgoX0kf7fsioMgGsf+Ky7RMpNJnyn/LAUW61h08SIVvvNecG
         +B6FZoN8iZ7yI90XaVZGgO1y6sH8PNS4k8igonORZk6SlwHQ6XM9zbRjTFIsj3gfMt9l
         AlnB7SuclzXaJBhbgObCniUVNCkdqpXcrAnrh4ZFiKTwLmG8dp4kfYUwqoDkP2BmnTd8
         FMzMo70GIl+qq2YKytLd6mWblHgXlHPgcCnHArPyVACRbFyk7grpBEq0wj2322AajCBF
         Ocsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785764414; x=1786369214;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dh03OlNdDw+4kjPd92fOhjRCwcrHdHS1ETPhfGn0lso=;
        b=ePk9GCsqIPg4Vipl5W4noa4HE9/dWxWQGFLH4O/86O6RPZETX4u7FqpDWG2NNL/Lox
         v1L09NiOTeO5D80LvbSJPuxN692EP4F0nDk11v+VkIxeSHOM9XiR8nIX3bTcL4yuhJb2
         M9KNSmjxYzC1gU8BkvMKMmCqdKg15UZe6HySJd48h8K55JFOrELW34CG2Ea4VgnZuYsQ
         6YHMAiCd4X5XdiinvrJ8iTBev4OslWfww/ZUtWhA1r4JUPUmGgdbhQGac0yd0h/tR9u3
         TXyUNkb4B3auyX8gprgtt8BGl1sqZd9gxgwNOa8iJfKxKCCnFgoWKHO/dTmfhpe9Poel
         Zw6Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp6lyh1yOznSaYRB9+1Z5xv74mWbk2xQkYGx56JT++PiSYep0idPgyrYldynia+ekMKfbZKmNSN5w==@kvack.org
X-Gm-Message-State: AOJu0Yw7n/inEZ2hSs6xBT9RRjTLZ5LX8itXUNGVUxgVnf1/h2ZvyYtI
	SDJ0cal6aB4VDELqH3VGV+T7LZ/6l/jecdI8K9d3YzrQTAlWUrOcNaPm
X-Gm-Gg: AR+sD12RIihNvWOGeiu9xQXktui3VTVcwMgnMkT7a0KTEAWWuEVNjrHbCPRU64p3y/c
	cem1bljxpQzzxnChR80Rg6bJGSnxg7meIfO65L8MpfuEcB8FJw0f+w5oreE1j2dCK0zF4ilTbQk
	u2+TQQZ1Y921Bme1TNS8gHfuWQD5aLeZ5dHJS7SdKG36SnaMj336M4nBeIhTv10xU74uuHSK70v
	SrOscSdVkfUwFhxy7rMxdocNL/ZpTlCfPjfeDn4lxH2echQEleVSP/j+WI01jY+0trDa22DWNVR
	r5rQdpxLWoXUkd7GPQIQQwhRRo873On/ufEkH8dGLOSr/MR7gDlyYAWHP9C3NoNKsEM3GzJD5CQ
	y7B12nMF88Xs3k2GJtrLrCgLkPq8mZWGsYOLEIaHBzWuoPDk53d00zFbWiaFICuhYia33LnkkCB
	51vd+KeVzygWi6O1vi1B+KX2Bcbg==
X-Received: by 2002:a17:907:8748:b0:c15:f65a:43a8 with SMTP id a640c23a62f3a-c1fe7ea61c9mr814160566b.12.1785764413722;
        Mon, 03 Aug 2026 06:40:13 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd4532e1esm542415966b.50.2026.08.03.06.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 06:40:12 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 3 Aug 2026 15:40:10 +0200
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: Do not warn on -ENOMEM from va_alloc()
Message-ID: <anCaOuePqh0IUX52@milan>
References: <20260802104627.63892-1-urezki@gmail.com>
 <pi25qtpcxjhykyc7xwjvvgnlnam2gyp6rxoxsxj5vzfscg5ysp@6wzaipk3t6bm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pi25qtpcxjhykyc7xwjvvgnlnam2gyp6rxoxsxj5vzfscg5ysp@6wzaipk3t6bm>
X-Rspam-User: 
X-Rspamd-Queue-Id: 83AE180008
X-Rspamd-Server: rspam01
X-Stat-Signature: dgqiy69knkainxugj3p73k8u9kqiwsso
X-HE-Tag: 1785764415-577249
X-HE-Meta: U2FsdGVkX19jEya/y78h5r64JAYwTHGpbupxG/5w8YR+G/bXFwD5uwqhdgItqKWTrh8Cv5GppZN0n88RD3tNd2KfYUpfcan+WTEv2PJAzmIi6QH+eTvzael6m9XtWnthlqMg+5mLt+yeSv0Lf5q4vvi5hYC6FMk/5UxQlplLQdG1vKj2iCRbgWgDi3KRwBemvSbIpZainTTaNW/04VLgci3u4HMwOZUCx5dtHHBsrbFhrkwbhaLgADx71rfOBsz/U2nVNsM28a7UlOPjzgFXnEovXxmBwyyQp5F+LdZ1kyyESnxJdpo6ExzMVyMozFbtIXCuf24+B/V/m0m+uTo/+iT/02VxZajDrfRfqx/ZZcuj6Qn68AkROZfiTAnsK0Ineuoo/HKUtykBKNmhBvCgGwGog1RClJ+HlnMQWbr2gfk415X7hIVapkCA7rWN56RkmrgdRWjnv/Da1LPM6Mxoj6SrQhXn6wFVirO/uN9XIdhWmXTSsGqnYIusLdwo1mbuPJT8bQ6ZNzkM0uVi/8F6kNfqdxmb5rL8nyI9FBJJXP0t/9wsEktMlkTHcsvug0y4xNHzyQyGPp1Q0xBE5SEKtn7Y//3Td8oQa4jH+Whx4KRK8bVhkBvwjlI+XNys6AYqVzvLd7sz7R+Cx/B5yhZDYV8dyOZ1RLa6rG7ZNeA+Dcm5LxhHBjzJUq7+1kylgJLMitoeJdowd4UUvayUWrG6/HdkeE9PTAVFSdFiwbOvxmrHhoffbIl4DHjBSSRhz38r96K2gghI3gPkUb6AC1GXQ62+hixQ2dE0Zae+fb920Fvys4wRSudUkmImQwO6WRH9rUJM2Sc6qqAL2Of0NC0b9dVwoHiPOgSCaVWKi8bGHgp40RGrGDl44bY8B2NRFyOZUOp8ooUHIlyGCPCCFuNa2FTATFmDrHvo6gvvgwpqaGdFKfQr/10m8f1l7xKsq2afIokPUCL31tWmPZySigL
 c00ceRH6
 vLN0atnrKzqnce/G9cPvZiEAii8zcrEzfsJ5c70H5ld8GSq9OaiQjHM08/s/6EV+uiB4oPyNsXaqlxdhdfnLVCF1xlQncJVCHeXcMvHdAYaVQc3a+nxG+vWgmx9KmdXUBU5HKNN2CXBHCqtGNvhRiVlrWRrJCgelKbBesCH6HbIhXKTGzUUyQxSJhIjXcRkZ7nbCA/ilgQPyNwhxhoi2VTU4JTPlNiFDrTeGU/P9aFbWui5U7rzK2JRouM1gQueB51gAGMbJdQiZIgeAjjgN3dGEwCQ38kkU790tbK/SL5SwZGHx0dQEttv2Vw1NMfHrjT8xQZ4WcAAmVLDbICThVST9JzCXu/wwsg/4BVQqPIImJY4xeq1NtV7hOE2XXi1mVO6bho4Ye1fyZv8GFyN/gVcTpsoPojweuCZ9fbJUiJR7bIC+IlGA6M9yTwiAwucluNZRQ8Gtgj/z+wW2O/f5Es2T8VAUlyk/oOp+3n/eWUSxtLYZcAUFnrCyXZhuz9ULWyxxpkxAbaClV20Pq/cK8PZoE3msMNX+UtW4iYtImAqhv2wrwNvIXep/SINM7Bu3lFsL2yRwCJHaGxkfKBI1Qhc0UgrW+i7HjmWjOzE/E4hvrK8da2Eg9LQZwphm03X+hrFOJOjNcnJBVFxtSgDCDF5oQHa8TMDwjfA4fChTzS9inc+gombLpgo8boorbPNjPJTsq21IP3AgYF0dij7VxHDPJXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 09:19:52AM +0530, Anshuman Khandual wrote:
> On Sun, Aug 02, 2026 at 12:46:27PM +0200, Uladzislau Rezki (Sony) wrote:
> > Since vmalloc() accepts non-blocking GFP flags, allocation
> > requests may fail when callers pass restrictive GFP masks.
> > 
> > va_clip() may return -ENOMEM when its GFP_NOWAIT fallback
> > allocation fails during NE_FIT_TYPE splitting. This is an
> > expected failure, so va_alloc() should return the error
> > without triggering a kernel splat.
> 
> Dropping WARN_ON_ONCE() just for -ENOMEM while preserving this
> warning for other returned errors does make sense.
> 
> > 
> > Reported-by: syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com
> 
> Very small nit.
> 
> If there is actual link for the problem report, probably it could
> be added as an Link: or Closes: here.
> 
I hope Andrew can help here. If not i will resend!

Thank you!

--
Uladzislau Rezki

