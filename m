Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 530F310FCADC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F5E6B0005; Wed,  1 Apr 2026 17:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50676B0089; Wed,  1 Apr 2026 17:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65B66B008A; Wed,  1 Apr 2026 17:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98A556B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:10:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16B30139D85
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:10:57 +0000 (UTC)
X-FDA: 84611231754.08.353749B
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0313D4000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:10:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=bMTeFj70;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775077855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMu03LY0qCZzLGL1WuHCBvpS1SQA/t8qDMGzWzp1NCk=;
	b=G8iXCvPtjVPbALzN8Cymtfqi5WQBX6WBGebN177OSApbdgC6sfFw28MGjMXCJrmltlT4b4
	Y0JTJ8P4E9sYuQ+gErRS2pu0hFy2F2CecoGAydQDlqa3xE9VwulN/jpqxmKLa0R3/QxHNV
	XyC/1oIK04a2z5DBSU+mz5JfNtWaNZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775077855; a=rsa-sha256;
	cv=none;
	b=ceKUHxoi/UyaE6+K7IzQmHXsNaVrG0kvCEXz5Tu8P6MWt+uwBa9xIKZxSWZAlek3Y/RboL
	8FuqlO1sGv89/lK2Ma3m4w1tGA+jqxoszyidkr5iXs4ucTcvyRZa+dLPTImodfHRHtMR5r
	Wq7WCmE1WvrelcUArcJ6KCTi4M7LuX4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=bMTeFj70;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506a7bbe9d0so1436751cf.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 14:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775077854; x=1775682654; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TMu03LY0qCZzLGL1WuHCBvpS1SQA/t8qDMGzWzp1NCk=;
        b=bMTeFj708jSxwAN3IFGoElOcDLdI36XJia/YGdDHdY1Vah8WLYNg2ox9Z0la3ZgZtg
         guOIJhQS3NbGFpjmmGiJiYoLurJfz8A5Tpk+bXWQAnmegI7OzwBI8sVi6nHgducW9MsL
         G3qpM3fJM1AY1ekWKIGKHlySptWN2YSbwQOZfXgJGmP8NfVQRaGW3obj0rFP8pLPWvyP
         Qi3/SWRTK2+PyK29l4zarb03qyM7HthHdmv1BzKo9I2cP6UFVTtdl3HIJZtF2oVzmyEn
         yuzFA3D0NrvEAOn28wvqk7XHpxLQr1zluoUomJ/+Mjx3fGHtR+/n5qM3hjAyxOH6L4CR
         anoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775077854; x=1775682654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TMu03LY0qCZzLGL1WuHCBvpS1SQA/t8qDMGzWzp1NCk=;
        b=Xr9fNlz0Jpjal/8kE3u4YCKFxwcB5R6seNJlbeXbu6Zsqs3qpnpqImVyTfd+fWbUF1
         t6/mg1mScFWoEU/OKcYtxgqz8/PCI2rNslJ2iqF8Yv3FV7kkFMhHxGuUF6uBt4d8xNe/
         ed0cLSzFsYcLo/LOxYrg+JV37dpCZD537aDCychUgWzT/XZPh1wvqAgpKCJpNliprWCn
         OtVDpPhypbfcohuJj6lUx+ZTWm/CWhFrM/N9okCgu4FcE6PGsHgHwHof5HSBAuP8tSoy
         wWr3FSw+Ym4JjTYeb7+PG9Hb1tLfQAEE083JVnbok7biKQS/BJf3nw2K6t1O+VCY0F2M
         g+XA==
X-Gm-Message-State: AOJu0YwzBT5vf9rswghZtBM8QjQz88xKkJjuKwg9xt07+tNvXG/xfuYQ
	069dpdd7aMiNBKL8T7EMLWvWgnZT/g07dWWef1rHexIq/odaJEjS0t4JV8QfOiZjmZ0=
X-Gm-Gg: ATEYQzxZGeLUQXfnrYfaLL9rGoQm/uxJh4cdUeOVZKM4q1yZZAEENXIpv+rsiIjEdwZ
	6ueZWrbE+LaQOsf6asRauMweRGv35OekIi+M2dlT3jKUg9vf9zeRZmJAwtexMPS0LjneQe5kZue
	wCHPAQtdWwBCVP+KiliVvdniINZ9uGKek8Ft9p1J/VkvMojocTG4GQtNhVP8LwDSJ/ebh6QTlWp
	4wOhVi1mWKnfO71psk91HoPTXyXJ9oGnfXbDOTR7adbTF0YeJZs9Iy7uCXmrBHuuzxt9pfqfkdr
	XHdWRb0Bbw4FVDScRyxNUIMD3MxW7pZpvNoM/7iIs2dI8bE3hPhoheLBCib7VcD3FMT2e6MHJM1
	JY5cXWvoH+XlPNtJuY9ee8vrVAWUiy9kXmfThTFFwkySQzBqgVu0xQGnyDUnOkHAcgJQHLu1aNI
	OdoVqo6wh9oGLxIUU4CSU9yc1LTIL1aRy2
X-Received: by 2002:ac8:5781:0:b0:509:14f6:9841 with SMTP id d75a77b69052e-50d4bb2f25cmr17195691cf.31.1775077853897;
        Wed, 01 Apr 2026 14:10:53 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a593331651sm6771496d6.10.2026.04.01.14.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 14:10:53 -0700 (PDT)
Date: Wed, 1 Apr 2026 17:10:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, riel@surriel.com, kuba@kernel.org,
	edumazet@google.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmpressure: skip socket pressure for costly order
 reclaim
Message-ID: <ac2J3Jfh_Q57vHRH@cmpxchg.org>
References: <20260401203752.643259-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401203752.643259-1-jp.kobryn@linux.dev>
X-Rspamd-Queue-Id: 0313D4000B
X-Stat-Signature: f8h6ww7a1qo3escjfbx7x3qxe49qmzyd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775077854-131135
X-HE-Meta: U2FsdGVkX1/Tvh2DUq1dlo+Ryd4qbrPpXJBoJdkHF7Q1qc86izqT+Jmt9EfWTLh7pE9n8mDIx98TYIzR3a50/XaS+fu5Nw7iNbI1JJ7epLeU8Jm2Gvsv5ijZvGdvcbCPK4woOICs7UdzhzvovcgXGPlZlk+bZaGiXdzSplMifYfncFdn96GSVuUcksrJb2LXfnq2qmWQq5N4CWFwoqzqozgCP+dVMSBRdkWGYwCg57cOd7Z1r4FQuDc4U/8Go5xSDxnd3qOGmBgdmOOQa/uxmzn9plvdCrsdixIe//K7cGUv6/PZ+bFh0+RVesMi2kgO9JPi/KGumv4FAIakE1lheisJECuZPw9vFqRR5E1xaj7D8cCnMRz3zCjBDc0EtEDhuoevMyy8XJJIg6Y2wesyAPxoXlcQIeCmakTfw/xW9v997DXztyk2F7Yzt9qZEuXjHPOp3ZBQsN1ztCDYxwJgxn0PqC1yVgYR/bnO683HhRaNbdraggYRqO/S+OAUEmahTmHzNnO2oE9DSKFMtvfhe35oyWVc4U62Srazk+PuBBOMszeWfk001mMbvL2Je7JY0Ei7GQw353oKMIzFePHHTy8rtnV0HORVpsNZNjH96Uc7vp6Kk3nVA1aXQFZ13QBhMT3uj0YKUMuFNHhekFzkM6d5TkUQKMsN9CoIwkq9eFHkv5QbesQWgy5I2rek2ClVv75afaBgJJJNPqVNeW79f3CgJKSH/8PvABvuwv4UnavtLwBpAIR3fhMgxybjCsbNxAR0FI9iDqk5MSMZXU2xrvASB2NaRjNijpMninGMLo0iBqiZ43CtpehbOIumisOqMIjh1Zzg31ymTEoptrBOdNoLah9teRMByCDQDIbUlCWC6YxF4X5jgDbBM927rhO+B2YMfyePJ7ihtlkvTUEdmeyt0lZBnNrjOeuVifg5um6vqAfqmVETwUJFsOrp22EDRs1RleyfX0eJsbXAi0t
 t9205IIu
 UImkLM5flpvDMg+zSZ6W/IB3Tn35aNuwu/AzXCn47PqorpWy54gSaFlMNfFjDfRgc4tm5qEod6gnMPL2/QbSV+Mx2Kh4JyHeeXieXE3ecztdBsrZ2RFIYmjgbS+u4ImHqN8nL0j4nRnHbIFgSt/DWloifn6HBK6qbUVUrPdK8zqYPzcvXYF64NaLoDNDFrl+CYP0LRdIC3LSTsQ5n9TXfDjowA3mVC4CofKuBn9zy+24VmW1612sRTsHyeFcPuwrI9n58HARM9ZQojU67bDqSIJEqU/qShXeOBtiZlGht2vZv/YP/eXt/jqrqv2rNV9jFoNo5cGO1IcRhKy9FWPxpRlnOINW4VJquet12ttYN/Z+f6xEDUgA0jyTz9QUvqdpLOYYBRwbqyIt1iONvawfA462fqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 01:37:52PM -0700, JP Kobryn (Meta) wrote:
> @@ -307,7 +308,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
>  
>  		level = vmpressure_calc_level(scanned, reclaimed);
>  
> -		if (level > VMPRESSURE_LOW) {
> +		if (level > VMPRESSURE_LOW && order <= PAGE_ALLOC_COSTLY_ORDER) {

I think a comment would be in, ahem, order.

Once we go above COSTLY_ORDER, reclaim relies heavily on compaction to
make progress. Reclaim efficiency was never a great proxy for pressure
to begin with, but it's outright misleading with these high
orders. Don't throttle sockets because somebody is attempting
something crazy like an order-7 and predictably struggling.

