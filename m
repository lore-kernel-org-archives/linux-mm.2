Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B71C55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 01:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042B96B007B; Tue,  4 Aug 2026 21:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35866B0088; Tue,  4 Aug 2026 21:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BDB6B008A; Tue,  4 Aug 2026 21:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C14F86B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:27:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C82DC031F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:27:09 +0000 (UTC)
X-FDA: 85065477378.19.582AEE8
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 575CCA0003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:27:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Uvjq6qw6;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785893227;
	b=12GnV3lcFutUOI054M9CpkvJb7yr4OhdU0dAQvZdKbc96BzJhFzNqnzqyJL2/NA1UWQ8b4
	+jaB8nNDnxfQUZgrF8r0n3hD9C0niWAYTtdn4cHN6hmo1+2UPjC3ISneEG3coArbxKSBVK
	KSb0+f4g1Q1aSSopQRsviKiQdlLImiA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Uvjq6qw6;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785893227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O76Hnad2Cd+KWQKpYD03zNwViOHkyXSFb5u0Ut/nPY0=;
	b=qyiX2gxnunzaF4ns3Yd3dj/hsnaWIpNPt+CqbtcJRgJX7rcOhPekc2N4lRdnnzwXla7cVl
	s4+o6YqzFabBqUwOS8gxg0v723IqbuttCZsbrQPbVCkSkyWB3xEFqvEPDuF9nsOWSa5VYh
	X9Y8bHREz8BkTtFIyJA96cuv4CLSd0s=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso501573a91.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 18:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785893226; x=1786498026; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O76Hnad2Cd+KWQKpYD03zNwViOHkyXSFb5u0Ut/nPY0=;
        b=Uvjq6qw6ijjglw4HrvYRZjLAT2uinREZdI1KIApMltnqDU6MUfaUGbCikgL70p/CXm
         qgDw9/BLmDMzIOkI88g2MKhFvGskbnzJu+MEArD5pMg1P1AucYS33AfNcS76wBcmB0RI
         AtMZK++I4Aiemf/rPKF3U8CooKbDJAUYVrf8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785893226; x=1786498026;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O76Hnad2Cd+KWQKpYD03zNwViOHkyXSFb5u0Ut/nPY0=;
        b=iMtKFfhT9W34e7DQPids7YKT0r2jbRcwF9P38DP2hMYgQa8doUYV6teRJfwhfNwlKm
         di+/Jy3YJUtP5lNYybSGgswyyAqwPewE8smybEaX1dAPJGeedks/WA5rYdr1JH2L1un/
         HvI0i8gfk0N2/aaNuKn2DY6KOEulWiaxGyyg0zhaluVmQpp7b/CZdZW2SMkNcsO4DFkf
         Esk4tJQICCCnVYExAb3xPs9IiHgRAXtOnpvq58LJeSJehM0Mvfk4eSTjZtEF92+UYr4U
         KSnawAdfmbXLjYoLDOmgD42IHIcH3QJ7LS4WbRiYKPbbqDqsNVCnOMtVoBGs3rm+/RZv
         XP6w==
X-Forwarded-Encrypted: i=1; AHgh+RqxFIQFyCa5wYIiLE+DnbUGFC+XBmjs6Dnd6nP9xe5IqlL98L56uOIOD7cckCFFoHiP6XJ+fThvhw==@kvack.org
X-Gm-Message-State: AOJu0YwBS0rBIZIJfbgFjqqBGYgij22ji11EHJTnRPH+WxHk760ZpoXk
	UpjAVf2A/ISjsQOEW6bVApwfck5sx3/L0D+///DKU37kbwi1mBmedQH5kcfBTqMulg==
X-Gm-Gg: AR+sD107HxaPLd7MZcW0Nyv1bJVccY9BF+1C6mDZMYNgEvv2M36+ODjeQRsKKSFiMNo
	bPHbn0+UdPjZJVDZOnya9x3F/h1O7HW1++I+NONfa87Raom9wOL1E9Ro1je0iBRaL/gGw6uHKIM
	eOB0Nc02kysMhVM9oAZB9t8lTmIieBgNeRGA5q6U1v4LtlCVUEaNoOoFnULc0FZZ64zVDatTwLn
	xjB5JxwvscPQpLFwJ/FEsaAscrkl99MSw7poJRgHa12Ld+N5BQHoouiKNnuZYi2cJtv7wdend81
	rhTE4jlHqsTmx9670G8D2PVSUkXaf4o9BafCPKPTquoF7FoNrKHITpSGYK4pTNoZlUkkt8oObLy
	VJ458+mv4C5ihObs6gxJNap2n9BF7MohqNLYr7YmN/Wwg6WUIKgFrIiBFEhjwvXA/dyfVweZQE1
	/4cYy15ftH/UkU7AvCD6RaqMYoRNRL2XZmyd/aDu0UO20E6bkN6CkSZtm7tFjuGzsjBmioKH1P0
	6znsBr00TI9pf449FgVnaesgswY
X-Received: by 2002:a17:90b:4ad1:b0:38e:101f:c867 with SMTP id 98e67ed59e1d1-3903c5ca8cdmr3066804a91.18.1785893226043;
        Tue, 04 Aug 2026 18:27:06 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:32eb:b46b:e9eb:65c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3903f5e21c7sm460514a91.3.2026.08.04.18.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 18:27:05 -0700 (PDT)
Date: Wed, 5 Aug 2026 10:27:01 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bigeasy@linutronix.de, hdanton@sina.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, yosry.ahmed@linux.dev, 
	surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <anKQ_qZ1-Q6FchZ9@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805005545.66112-1-baohua@kernel.org>
X-Rspamd-Queue-Id: 575CCA0003
X-Stat-Signature: 7rj6a7c87to4seh57zsy7r1n554idxs5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785893227-683262
X-HE-Meta: U2FsdGVkX19LsPcpMnrkxGzWvdf7OZx1Xa6LcUGFCDFC3m+FdYL9OVGsCew8EkoMmzFf/6XtJef8tsjXfSjX2sUNlcWAisy81uJ+gzruS2c82iSi1ta8n7Zd+zjmG3k6LREv+4Q2nSCUpzLfbfArw57+8m/35YZUwf0S8XM1UYkoS8X/uI1ZhtrAnGwcavkP61DtIe3a8YQobUUYbceILLVJrBMp1EiPud3/Y2o7mDEPtjh8tH4Jg9BuZd5Ni0Kbimm8H7gVz+xBsZGascS0OeSafO7+o8LACBayFOf6D9L8NZqHXNGWB/BP7SxKHlnJXaygfJvBER9fwhb5TrP4l3xrLtdv2jhpWAWc6AatWd6au1H5cRDqiulKI1FA+dAtO+mMm1P49SwyW90ztP5zSFYYWCfFc9a6Pnz7rvvKBsVYHlOn6L4Hmox83qQ9M7B0nL0r4Do0AMAuqNB+4N+ERc7NgBPzolZD5gNCNeZOipMppYZ2goqlv2+DeReJ5TYEPVzpleit1lq/Zcam7SiJxMkaSkCShKgKMwlvbEW3SUOSeNEwhRD7afh0GVLWgL6YSBdPsLT9mUyx5cfgL1IVYNhyyhPQqfYn2kCGe+GB/CaSp5j6flEQUky8BUsH/WYfZOtg/HJ4m+9oNlopcMvMYJdh83Y/RMSO5M6iyX194+2Vct1Iix1+3zKvQmCm/OG7c8PdXxJ3TLqyKfY93TVHyppPPKT/gV+VN3EqTQPyEm//ASYCY0NetVqHrsZcQAdVorfEjcJ8pvxph2S0ow59ONaPLFPF8wjTK/2txVw/2FgvgQfQxoSF3h7OTDXTqnYC39ijm+IFpthNkePra9C0OYZINxevD7nhZsGgeLzSg9EnPh3dS5Nnqe08JMZYnxvRBU2qIIcS92MBQ24mwpSUXw9RT/+Wcw7a3wWdrRMtt6FvuYGbLdECffM740tSn6/jaoi5TU6K1cdC6WjirEu
 sBj2OsSW
 9w3hNuq+NCymzPHqdAfr7BwM+SUKoiwMq0p6Vd8NToHm7ooWu/SbdXcpBObyGVamiSwpTI+cGO/VEisGe+g9bLwGTL3HEP1usoHAO0SQ2T/Ry1EBkxprpDNK1QX0RTkk2KbBJVc2fmQ9WvP7w3Z8viELz8L0DgUSNDQm+dqf4Va/T3SYZl5R8tQKJtz1hG1KVUd4uIWY3yW6jj9rdr5/GMSPpRtHGX61nt5NlBoaji4kSND6dK68HzHIHsFjF0cEHs4MwTtTwDPyGj808QkcxgigfIw5qy49ayhgUJDbESyOh5Ve1lppHtCkfl6gVumXK0FWBqT5fMNYLzxMIHq6qmld49C7MTzQoEQzMEF+ciV5scKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/05 08:55), Barry Song (Xiaomi) wrote:
> Since commit 2efa9e9eb4db ("zram: permit preemption with active
> compression stream"), a major Android regression has been reported.
> 
> The reason is that compression/decompression is now sleepable and
> preemptible. This means a stream may be migrated to another CPU or
> be preempted while holding the stream mutex. As a result, high
> priority UI threads may get stuck waiting for the mutex during swap-in.
[..]
> We add an async flag (currently false for almost all backends) to
> indicate whether a backend is asynchronous. For synchronous
> backends, we use preempt_disable() in the !PREEMPT_RT case. A

I wonder what does that report say.  Is that what I think it is
(we discussed something RT related privately recently)?

