Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C738CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC749900177; Thu, 14 Aug 2025 09:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50A4900172; Thu, 14 Aug 2025 09:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA33B900177; Thu, 14 Aug 2025 09:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9561A900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:59:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 631071A06C2
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:59:40 +0000 (UTC)
X-FDA: 83775520920.05.2087405
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 87BE28000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:59:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=fL8wSuEX;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755179978; a=rsa-sha256;
	cv=none;
	b=g4p/HuWfGvgCqma6HFmUaA2XNbiAgbyOam0L4SxMwvTpjLx9eEx7+fmgUUdHxGWI1lfWtZ
	xpQy9FNheBGxH2U8xHORwQ8/0cpd2fVvMjSInPaiIDlIHWTR8stWHBqG7KkaUIFGoRh3V4
	f9t01+YqqgrRCJz540ePjwoicyjgFbk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=fL8wSuEX;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbHoxH73V7s6W9eMph78SaxPK1+Tv1/NM1bGPx7Srdc=;
	b=WGPeLUOB3cFyQVGSAY36I6MER5cVW/p1abdhFDnCyCRYEwOtq/bP5f+PwV1RVzQDfaJZ6H
	acAotj1MYyOYOMtJdnt6zMW1b9OF81ysC0vGs36bZ/KrC6LbnKvA175BYix8wg92nKiyvl
	qzXTNazOAg+dCjKB/3R6GknoL6IF/SY=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7e864c4615aso208869585a.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755179977; x=1755784777; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zbHoxH73V7s6W9eMph78SaxPK1+Tv1/NM1bGPx7Srdc=;
        b=fL8wSuEXsKTBq9ZZ7uRuNaJFxaHs/Xngft6epULqFZbj82tWbhwxSIPoXHRvWQR1D/
         uqz0REfZYof/+c3KR5pbVsCERMjzew0W/nQvXcyfCXrJKtKn5f038n+FS0Q0EGf/hzBn
         X02/nZKnzpbEMWUeV8s4KxANd7UITPp2oWSYnR7gN/DX4X4wfgq7Sc8dBu4MsjsBZhKe
         vRX6U9MNqG3YMZY/qZQU68w2LO1o8YgMT3BVdurVZRghb+GkqoTuRqI5jCt5sqaT2k03
         YvetlkBYc6qgms53Q1IHeKpydShAvIrCUbbA0WdgAgQ6AcjJoHWE8vmo8RjYc7gUeubB
         p1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755179977; x=1755784777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbHoxH73V7s6W9eMph78SaxPK1+Tv1/NM1bGPx7Srdc=;
        b=ZJRY81injUbmP/RkPZnIior5KBr8oTtK5ahzqWMiSY3/QTGZVPvaVdLSq+VvBm8HN2
         UUBYKWPO/3FEB5YM7GJmPiyarPv506Z+5KbGaLWp/jDnnNpufz8jDC8M6Kkk3GbIPA2C
         GlKTQxjR9+v2mL+IP4wGOKaWZG10HP8obRQi6QGsT3H7AgYvb2YQg5nz8kO/eGchn4D3
         jXooHUZrX/Crq0M3XVVTxbJ9ztcqjMB5ohHCqq1NWHeLNvlEaE2S7ADQ3rKjfly5jk5l
         JkWnnTuHvjuq0kVQhLD76k2BwjcaFxZY0jr2sKkrIBrlNesqgtGXN6N7hsObK1/QiGar
         fFVA==
X-Forwarded-Encrypted: i=1; AJvYcCVp6KXEXUP0Oe601N1oWgPvgr6lbUnp/Wf0QSMviRUnv/AnqRinI4nuQaXAkGocfmQyBIGn8rzRrg==@kvack.org
X-Gm-Message-State: AOJu0YzT0vCMNGtzwSFYwcRiBf7oK65OYyEWRw42+U0skbKz203D7ghd
	kDSn/OIlWA6zWMz94rEzxzjQGj3FFkFBvsOGzDNGuBWd02GKx5LrpcksXdv3QSvZLI519wN7rzG
	VnwmY
X-Gm-Gg: ASbGncvVxAOS0Rr1msYo4Ct+bby8bx6fO8hvO7KSlTjCQs6qGJYKiR5rMKRDLmF9jEH
	HYnGKZ7hXQU9I2lYz5hIHkKJz8eF3lsZ8tBts3uhyCimek73AWTUuStg9FpMXwDgEOKZNOHsGsK
	X8bQuyF4TMwEry4gXH1T6kQ0T7U8ILbt6e8Rb53+T+/4PXGKHOTGOHKvWGQdkhsVN0U+DmGHyvU
	OpdV+VYnMXkUZDdtuca6Q49ORpE06LDFCqns+u11d9Z6E4cUGbJIke44NxUKjrYzvZdc5IuMsox
	dFSjqsilrGj5AZ2NV1TvJ3YJ7P/J3lFxfsfOyL8xMRJZT5l6Ht/EbRnk8fxPAiRfObq32ZmZF31
	EcjeFs6B6N+LfUg6Fq7BLlA==
X-Google-Smtp-Source: AGHT+IGgT0lxT+d+8p0uf2Z41Idd/2JXPEfNrQxu89hzCFLHD2rzpfmxmJQ2s6A4zRqiOiv+t/nSPA==
X-Received: by 2002:a05:620a:410e:b0:7e6:9bc2:6cb8 with SMTP id af79cd13be357-7e8716b2ac7mr381795385a.2.1755179977385;
        Thu, 14 Aug 2025 06:59:37 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-7e69716fa4asm1895103385a.58.2025.08.14.06.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 06:59:36 -0700 (PDT)
Date: Thu, 14 Aug 2025 09:59:35 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Remove redundant pcp->free_count
 initialization in per_cpu_pages_init()
Message-ID: <20250814135935.GE115258@cmpxchg.org>
References: <20250814071828.12036-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814071828.12036-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87BE28000B
X-Stat-Signature: 71hgnphfpmofb574ka16zyk3esn41i6p
X-Rspam-User: 
X-HE-Tag: 1755179978-713980
X-HE-Meta: U2FsdGVkX18u0MVe69Lo4p4DMXuvAaQ54iikxVccqFyzljCQ2sIIIOnWR1Abv3rgUCSdcnbxV5uHN77kaqQq/4B2nVI7BhADC532URQYqI7iSgT3zK6/TaztwnKTSn3SLk8hsIUcoGohgpyMIWC280oIkrDlicOIswdO1S39DnlGJPm+cJ0iuULmkGiyjTDhTN3z9GnR5Dofp24RnT/+Iwx2dmwg1oHF5eSmRGBvOVPBLLPgpWKLrbapyp2E+suJNw013ECBr/r8MsetfK6lqSw5vQxDdY9fqxr68m/tr8BuMyqIgKcjLGqCvF2+5SpI+5Lx94IZoq5Ym/SK1dxd5ue2lWcPU/sFjLnIRrY5GIHWFQhFz4zf3r9YSpeFWtRVYC1m/6WBcEgPZCUqLZbk3abAecJECI+6qvWlQc4iiFbRTZufeoZ71sLSzFDC2KyUd/wGdss4B4YMhixM6i9Se3D1KD71DpJrWKwVUbhtWptACJOWG14vnysLJjkNAua2JxKKVGvSWTpO2Ru3c3mW2C2ag5vdHDj2MQPm7KaNm663PLfusqz2+6q2sJUzohe+ZRygp1Wshplxd+rA1J7090iEJgCV+0SoxiY5g1fsSUm2VcIAVKqRaAjMoBbyj/RwtcEObo/CBNgUrOdV/2t+1u2MT71K/RYZ3HqETr8PChuQI4gxq72/oCq5XgWtYEF6NVQONvd48gCL0Irg/1IYT+L0emt5I9xIOXCpKpEL6+kQmPEpB/AIRVJSZPzs8kbE/HDLy0tL76QBXyLtzsSfUPTFP5uEtXchrMboRE916NwjEUoEFCKJhpGG+5J/UaAGvoYXNJ13CSa12MQyy/nwYLtsVLbptJenfxQWsViGQH6DWVsgnDYykkzGs6g/1qc35qBbcu1O2LPcJ/a9C+Fed4OZplkXC7M+b/SMmEYb2TuaeW5RAY2SYjWgj4Z4kd+v1oPg8/9JMSNjSWNMo1M
 L4ZaAJcw
 0oe8oiK2cE1EGQZ3YkPWHq/iddmOE/gKlicuux55vTLsKEAFsPcfEikGG/CcC3sp1LauziSxaVBllfPy6Zj8ZvC0+U/5fLnCo+y/m71eiKdAXsDs+0cf/dPB+2WU52OYHCcCQqIDQKAiLVLs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 03:18:28PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> In per_cpu_pages_init(), pcp->free_count is explicitly initialized to 0,
> but this is redundant because the entire struct is already zeroed by
> memset(pcp, 0, sizeof(*pcp)).
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

