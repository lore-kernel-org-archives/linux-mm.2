Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953FFCCD1B9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 18:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABBC8E0007; Tue, 21 Oct 2025 14:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C888E0002; Tue, 21 Oct 2025 14:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B738E0007; Tue, 21 Oct 2025 14:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C115C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:57:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5950311A9E3
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:57:32 +0000 (UTC)
X-FDA: 84023029944.15.A8F819A
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 61DAEC0011
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:57:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=foLdHmKi;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761073050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICHOJfBAiMA3GFWxx6OGyhDRRndASzHR7RV9fm6Nan4=;
	b=Iq/9HDPvEcTvi8ttpvKkpZCMPXMcAMe0UMNmuh7oR3mC5PjiXp8ZBjybIIohukWaOECnHv
	WBYgufI7pEpALEtqOUUOeMo8KN5dSxgv1KANE4Rr1Vq0b5pfgj7rHI12C6BKLzF1XzAANQ
	JniCSIHTJ3EW3s+DgkNPosvTfihumYo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=foLdHmKi;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761073050; a=rsa-sha256;
	cv=none;
	b=Gm5ACvwAZaxfRlhRWWvKCH6DBW5tdx6mEBIugOyG88ZWuTiNdc5bbjO3DF/sPNC1sk1t89
	CZprLsW7nBOBgJs4+6eLwNRDXWpGkpQOOFShNP5+kKx9Fc8f9VDj9iY3LA3MhNaTPFLc3R
	2PXCsJ1RgfxboprzywgtQTj91XzUuVY=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-87c0ea50881so123921016d6.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761073049; x=1761677849; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ICHOJfBAiMA3GFWxx6OGyhDRRndASzHR7RV9fm6Nan4=;
        b=foLdHmKiXEOEhAht1c97kZGRRD339A8OCkHNd+4TFu8tr9ib46nOehV27dStUFAdad
         +0EJ+YFB1FRNmCqcjWRqxskrWzjOcYyPHNTgRX+JN3PF3uwm3P6rwBmrMUMxM95V05Mh
         mDeA3DXd60ORynkxlZOrvmWUtULN4cRxfvI2T5/3Gf6UuQxH3AdT9e19/t0AI0zcLjC2
         R18qViNMa/1KkAapWC2MbhxIsWEpZVJ7CNDC9UkPzuUeqruilpSRpjqQdTQr7qGJWkZQ
         Qtp3Vq0A3vEJ1sMLK8XgizkKW3/BNWXBiVpYMpIDYeX3QPBm0CmvGRIZEihU4hAVVC82
         TgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761073049; x=1761677849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICHOJfBAiMA3GFWxx6OGyhDRRndASzHR7RV9fm6Nan4=;
        b=MEPwZpQh0shrsCVQcYZynd/f3f5DaSijcX3QdLS9Fjx7VKACAiPfYvQFylh/a2NuUJ
         XTn3MsKm8duThcH9XFqvIsLuPK3AWqWywFoyUzkwhypM875x0Bq0hBd4DuAYcOlNlgKE
         +IZdOiI4a4KIJ4Ia0QkrkQ1MoncloNJy77n42J3uk13SWezKxM0VQWmGGn/3bv2m5HhG
         S3BhuPrhyDx/9SDcNNhCR2t04/JbTxAdrfVs8BLgsXDDu2FHu5pnjG1aIc1yL2pPeqvw
         pyOks6TR2/G/T5teOt5noseTujG5nm5o6MFECesTxFNdULM/qv3VW2NIvRovJkpiPiMo
         xs2A==
X-Forwarded-Encrypted: i=1; AJvYcCWfmh6i62NnMqAQuy8UB4CXIVBBY7KFTCtAtewHvHYr+bLs9usXH0N33ZJ7/abzybgvQTr+rmkKcg==@kvack.org
X-Gm-Message-State: AOJu0Yzbw6h6+c3NkgHdM5DTrw54ngr8fR/gP1/+i9WVtoi3WaHT4L2c
	3KNtFTLwu5NlSAEFwnyT6ePlnmTOolvG200NRihGRPmcqskimIOVQujCh6PY4Tfpi8pmPmv3CPc
	q2cEZ
X-Gm-Gg: ASbGncsi/yOeJZv4kuRz+PLkR7R2zLcbOVvrXcVnwLhBRsXtr61k2LJSo2UI6FTAI4n
	FIKElaTX1eIzEitunSGxmy3K9p/Kf3UpNKbJwHQ2XygAdyni72la0cH2TkRhSM8GmImMeMkwz1i
	+Y0i1VNgdkGsR06xr2+YzWqL2RpHEeRsdH30fg4ygJvW4oEczkK4TR1FB0Q1gm3DNen8fPA51/t
	NiHPGPfHmFB+zDGti9lPu2rkCNdk9lW2o+rK+t5NHfnF9FQok4+x5mtqzD+irqh2r/nUQB2IIwG
	XD/IadTqY1zCEQZpKGSj0BIuej4rg5EwTT/aysIc6SJxtysZtL0TkYxJo64r6w+Y6TQiz3IZw6A
	5utnVT54WDh9rI4IMqem1VyNSKpWvzHo4O0kAVV7pzvjzikpaya0TBqBJPwv4hJAf+Lpd5Phy9L
	IiLKblY7Jn5pBowXiWqeCHa1raXhv09Nz9HSWlDSjgdXiFRPi1B88mfwmZQFc=
X-Google-Smtp-Source: AGHT+IFfs2dfEPPNJsfvZRFCqEjEBAjB/pFkbuIYcg+kdR54i+7DW1sSnKYu8l9TMPmKxu8MbgRFWA==
X-Received: by 2002:a05:6214:489:b0:87c:64e:e1a6 with SMTP id 6a1803df08f44-87c2056af1emr184471716d6.3.1761073049484;
        Tue, 21 Oct 2025 11:57:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d028aef65sm74522236d6.50.2025.10.21.11.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 11:57:29 -0700 (PDT)
Date: Tue, 21 Oct 2025 14:57:26 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aPfXloRQgplusnce@gourry-fedora-PF4VCD3F>
References: <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
 <20250925182308.00001be4@huawei.com>
 <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
 <aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
 <CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
 <aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
 <20251017153613.00004940@huawei.com>
 <aPJZtQS4wJ1fkJq-@gourry-fedora-PF4VCD3F>
 <20251020150526.000078b6@huawei.com>
 <aPfWePBq8d3v979f@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPfWePBq8d3v979f@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Queue-Id: 61DAEC0011
X-Rspamd-Server: rspam03
X-Stat-Signature: xodoau5xzs5aifu37oxecp68j84a7z5j
X-HE-Tag: 1761073050-188250
X-HE-Meta: U2FsdGVkX1+OUqDepzfHC6cjNhfcubXdWC7Kb1SvJkmRIi/5J66vf/qFugtcyCVeCiNlWMosQbkHG8GE7D//7FaGpdgEzBTTfoO8601z0NVmxTwFMR227xRpqqU6o1ZVkxJOL72ct1umo3ohppS1A2Hv9cLid7T7VPHlfC/eweERAjUNQuCeGrnHCLlnDtMlY2Wt6/38bsx7v2RhU1hKrarS5694WsjK7bdpf57/Et6nE6fn02J8aDLjqqJSPR8XHlbkFuB6mw5zCPPpAYierHQATnwO6khFA/ooFyL7aXXa1RbPyMGZRpy6wd7Cs4gv5xss5w8JycP2rxZlJPrAgNHWDpOnI/Js5EXW56SjLPtvJdmAHU5/v3QqgeGriNnElQSptOfcjH0+NdYpobD+YXxF5JpeqSdtfqMa764/wue8TLWgHC3HDn19dlhlRymhFMgElgHSRKIviHnSSQd3XOGQweWijkVp0yiQNbTZhjw45Ir0sYH+kAKHHMjhbp0jt8php4RA/xNZRhFhYVP0hN23qKlAPi410ZNGs6V1BRaimGyWeU6ZLWPUT4+ze8u3Tg7hx0T2f85FM1/DOQFQ3gVOhsvYItyVYZWbJyDhM1JtCmdEndUPalPNBocZqmEm/4+YTq+ds7ZNXdgWCZGPhY8bmfuD0o6ioKQvBT2L3mpLKOyIx5DjfNsSSxWpkbc+ef+ySjUgLL/Sp/4Ax+eiggvRhs8yTc+KVicSe6700BkZf19rVb6eIhkmp9ib/RIf/4neoSevFyfdS3VQ1cDgDi9W8DeL6OqvnDk3KyfwNeEl4i9ZtIsSBCgBc71gS7lZeWwj724k3plDX0LUisF/G0qvooBf2IgotEW/So3iRzyvflw97N5SjDPnG9LbdtjCX+eygKTY87QugfKg488hWZKA4VnAK2OxYTFgRSRueweM0J5s/9EwPToxda9QkSyQXvJCagxxVF8OtHC/Azu
 ggneSJ81
 tTDCINnj6GyJpmzFzUWO5MXTymchLPART7INtdc1oiQYNI8AIVp83uoTl95gI2GnoVaCNmJUpzpnSMFtHcytUqZl7Gynyq1zpvvuVlPr0fdfgEw9Wlvad327Cutw86BgzoVtVV9jpg8kh1JorBPBv+0+sl/8+02+6Jkvt7nbVlUvxE7IQeeIgOGuPmJlMi5cO+KtlL5zXejVaKEfRIao90KRv5YySW3aELrOAdE8Z5SWgHWoIKbd6t21pmmrwP0gkI7iFlmB3DoIHzauplUap3kvSQF0uoqXSnkMziO7T6dK+eouH5Xv5TDDB7dXAjCQHRTNVaj4wflPlgLcfcAvuciNIDPTQquTBVo3FgkYnQM4HDigit1ZExkAh3vhxUTV4NYtIrIKszNk4s61MIGbwh7R6BA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:52:40PM -0400, Gregory Price wrote:
> I would prefer the former, since this is already what's done for
> hostbridge interleave vs non-interleave setups, where the host may
> expose multiple CFMW for the same devices depending on how the OS.

bah, got distracted

"Depending on how the OS may choose to configure things at some unknown
point in the future"


~Gregory

