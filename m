Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E18CD4F35
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6C66B008C; Tue, 12 May 2026 04:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840586B0092; Tue, 12 May 2026 04:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7086C6B0093; Tue, 12 May 2026 04:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4DA6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:54:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20B428BA93
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:54:40 +0000 (UTC)
X-FDA: 84758157120.14.274E1FD
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31A8CC0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:54:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fdHwfWh1;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnnB4MCAuiV5Ft2hC4r6fD8mVIbdueTlJ30zSvEnzRQ=;
	b=fNsjERidSZkHeX0RlBYBExrxCG/a2lTCT77hIJX4CuKNBAuKvwuxkmc1Ql3JZgwKhEE0iZ
	8f1Y8vmhTcO6IIAml3XnCH8ncUbg7NeAjUHQF939hVHZCsUCo0jqc0IeRzCQq2DgwPtWZi
	VsnCpkHT+B8AOIYL5XHJ1zr1fwOuQVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576078; a=rsa-sha256;
	cv=none;
	b=lfpKYqT03Hq7tb90lm3wlQE+gnp8pAdeCl9XYuUo+6xL1j8a5XfYsPiZyzoSNEomfh+hd+
	0yTDbKsUtqKi4tqdNQNuYmEj5ScVlMvAmVwmcap3d74qY23bi5GmE/GkhdYNQwbjXCqUq2
	v/nYLL1Mkx66O2aTVX0OiR9u22IjxeQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fdHwfWh1;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43eb05b1875so3079424f8f.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 01:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778576076; x=1779180876; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rnnB4MCAuiV5Ft2hC4r6fD8mVIbdueTlJ30zSvEnzRQ=;
        b=fdHwfWh1quR0CXctSF42GN+uhCvtaMcNa9nVuKRkbzDBGuss+JjrcnUaTmkjmqQK1B
         syoVGhX4eif5jUrtX2s3Eao9Haoq0zCvyJgwJsIxV40yr44cqNaZxB1obRGcJ+l3Qibf
         vOlOTGCbv5ELho3o/2t3Uq01q0Lg25lqXHQyXzidQMHJFlvkm4BeUibs+QSKzx38hT7U
         8oCT9qVGQXhtDBbKZl2tLrVmV5EooBsGhiFQ+R8mnQpxw/VkJqqRv1hWxX21tmwOi4I1
         yX8/PtbVup4rMR8jnkpVierWDIhXZzgZzXZikSU1GJY0/3CdJDQdGbHeIxz7ef9UO7DZ
         LV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778576076; x=1779180876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnnB4MCAuiV5Ft2hC4r6fD8mVIbdueTlJ30zSvEnzRQ=;
        b=epgS18R+LeZvpxZX2jA1f/vGwjetC/Etf9U40LR3RFq68RX90RrXOhxREyGOzEWe/B
         DwKt4xkxMFFrfsBfyR2QQG4pb1u00+Bukcz6m607w05ovd9HdZceMQyaV1W2DfOnzXu6
         kIVHapiT5GY4FwAIrMuU7do7jqEDnMLjvwdkBwtY8LHEptawBaq3QGniNiMerxJOekf2
         ba9rCpPd+0u+2Bh9Quq5Vzj8z5qy4lH6yhYtehOh3R73FQkcfhLSDk2EEGYkXRKx6H4d
         XZdrv5r2ujAtg4Zmp6SHlX14EWl0o2LFFic9BPLExng36SIRyGlCeLjAkrxkk0HS9g/y
         4F1Q==
X-Forwarded-Encrypted: i=1; AFNElJ/O792z2E7aWOgn3VfTbiu13O/ZefZTza0lsWmBwMVBJEQCS3GdKD3q05L03XIukqDEs57DUTxN0Q==@kvack.org
X-Gm-Message-State: AOJu0YxlGpF203y00P0IpE8reDK7g4YdU/SytigH1VpAapz99sFOHe1j
	mT//EOovagnWErzLaaRiohZdQyFLYXdyq3YQO2D3HVyEVeCprdcH4c6uRTJu1zGrxec=
X-Gm-Gg: Acq92OHVKqUzrAR6ae9tIzmaMKXEa4fDs1e1OZdI76fmhxy3TsVAWAktOl+b9ATcWaU
	FoQfZ/w+gqlrvFIUK8+4XQaOHYy4fCpNEbF88OeXHTyK5668017nsya76ePE8FCMAnfhexBozOl
	iPKf+H5TLRuA2boOvRSOs+zKUwbwmxTvmqRXRZGQEW1uK7EPH6G4EVHWgRMVbOZ7UP6yTpilyek
	VGFeeWuzKcy95u+PSrIMWhUnhHtgN9Yi7cMrRvJC5Cbq7LYbF6UtFMn8enHzG1Y58aI6MLEmz4A
	OOaWLAvsZJosZxNk/8p3va5OEgVeu9pezt4Ib8ONJU2rL2VAXgAQA2W1cgB8Lfgyp352ijLOUHQ
	JZNrR4awNKYoDCSVw8zVQPeLWiJrww6ora0v2oCgouGuQA2S/U20jBruBh7PfBJjBviFMPUp6oB
	BA6tn9z9ddjlh71GGWX2uJ0en2qcnHbL8=
X-Received: by 2002:a05:600c:4ec7:b0:48e:51f8:eb37 with SMTP id 5b1f17b1804b1-48e706d8ad9mr214102465e9.25.1778576076410;
        Tue, 12 May 2026 01:54:36 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8e5d3107sm23709625e9.1.2026.05.12.01.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 01:54:35 -0700 (PDT)
Date: Tue, 12 May 2026 10:54:34 +0200
From: Michal Hocko <mhocko@suse.com>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
Message-ID: <agLqyuQ8fyHBd0b1@tiehlicka>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <agHKWCw3CFO0CZ_E@tiehlicka>
 <d19c927c-4af7-4c2d-8c62-82b8fc841089@easystack.cn>
 <agHRhlfIYbaqHHMK@tiehlicka>
 <4a06f50f-fb7a-4b5a-a9d7-664407f83472@easystack.cn>
 <agLWHkhlkBotiLYM@tiehlicka>
 <d5bd3927-3f80-4ed7-a8d2-0b7d58139286@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5bd3927-3f80-4ed7-a8d2-0b7d58139286@easystack.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 31A8CC0002
X-Stat-Signature: souxhbefqg98anbdbjjifdp8p3ah8kw3
X-Rspam-User: 
X-HE-Tag: 1778576077-204219
X-HE-Meta: U2FsdGVkX1+ji7uOm3Zgn2LGvPtpVJe2fZXGnUHQzyIKJeMWG44Hvlw+RodYPmlxdfkK1A389+mTNPQI6mU7GxhRkwbEcmbcxp5ide43sElBvdpBSDiX16YBoCbME6CXSNx9MptMc4RI+dy6riA3FCTBHDoMvUGiij8fFjcXzTXDjwDwVE7BlMoHf0uWaP1jFrubtRz+Fbyrew2qJEbI65x2m6/XkP+B9mP0aIQyYKYgTbYmleWyvli1/2jhmjKv0Z9BysWFQojUhhRt1yq4cE/NS7+XV6vXIqWj0hOJfWwG2slXL8cgcdBCG6xx3lrohqiILEFw/1EmEeWTRVP3XnD+SmVShpBFdH5+QxY13JyEvR9dY17MqrCRTIxT5FT9xHqoPxozaLkwvuQ/UI9uXdJ59oBdkwShxGFx7+ZvWp4pIYEFwgbnIkHo21uX3sbgIFFIVKRoA6RnTKq8+BEq+rqLuUakCoSdIHIHiacuBoCxLBb4xUFprN4AXxpPbmfdJS4M+UAkyFZjp1uyYXDbVpT6M+zZYBruwWXwX+S6emW9z6CJlRDspW/A6wWO4s+43vHJZ4RwzFyhv9DqR8HIYK1ZySzdIGIBItuWHlClerpWkgT4Z6D0obRz2YH/Rpr6nMSV+33JOn4khIgIaageU+5lgOmEEIwx+f7zTqjqLqRATJAW/nMIfeJIzXKn9gt9MNAMD27PozN6Nm1xBBG/7dtBoPioaO3DNHhZvSlxOaOtqTQsU9zjK9wE9egG+rhcpR9BY+a8D/Z4nFF7rcYz0fvPOjmuaJkEuspyW7rQ3c2MOJvpalrOCxNUtuC6bTwI6GaLexhNekQfUcKeIMMcAPi9HcRhsWrcLNnDvlZkOpQFF9n+uVebIxFJczq4Hv/QwoHaFpLd1IDhOPt7ZP3n86bv7eNpzzjmpk7XiHMWf9hwJ7lDXQzHVNsTjQYpgDV7URi9J9PYWJF743Unizi
 XSO0d4DG
 BMBR5vviBZGaJLqJA0M0TbVm6ygHPtK4fSzWS/N73Q8Fc7o4zi717+pRK6Vk1yEF5bHLnfVKRSh0Xewc4zvpmnEB8R4Icq85rg22W4HroGEAnEa05F91c8/02XqI3Z+kEl5BwVT+noKBQTNnGIf0YTaVDuAn9tOqoZFo5OYz2aWrGahFTZDBodHVaAiPxHPIfos/bO0hmfOjxRIjOmSVCI6HbGzhJORmH8US/Qwv65qG6wxt/w7T9rI0Z/sHZZ20XN7E482JM37cEbZSGlz+T2WleTNAWQPyRbf5cGt+dr01QDQ/wu+mCvfPQhYH1uRvfCWCFhiJkH3aL4AC9xysNEh8IrNRxFoYcD/J7a/pnrREQ7m3clgNkjDryizcKL88BJD3/AfVK6DkopojhCYT+O//YRTM3p/y5L4r30x2OL2KEE1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 12-05-26 16:16:36, zhen.ni wrote:
> ## Implementation Plan
> 
> 1. Add per-fd filtering to page_owner file
>    - Add .open/.release/.write callbacks
>    - Each file descriptor has its own filter state
>    - Write filter commands: "nid=0", "mode=stack_handle"
> 
> 2. Provide user-space tool
>    - Simple CLI: ./page_owner_tool --nid=0
>    - Handle fd management internally
> 
> ## User Experience
> 
> Direct access (default: no filter):
>   cat /sys/kernel/debug/page_owner
> 
> With filtering:
>   ./page_owner_tool --nid=0
>   ./page_owner_tool --nid=0,2-3
>   ./page_owner_tool --nid=0 --mode=stack_handle
> 
> ## Benefits
> 
> - Completely eliminates race condition
> - Per-fd isolation for concurrent access
> - Correct design for multi-consumer scenarios
> 
> Does this approach look good to you?
> 
> Please let me know if you have any suggestions or concerns.

Yes, this is what I had in mind.
Thanks for looking into that.

-- 
Michal Hocko
SUSE Labs

