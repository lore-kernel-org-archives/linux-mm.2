Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11AD8D116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBD96B002C; Fri, 28 Nov 2025 12:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6444F6B0093; Fri, 28 Nov 2025 12:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5556B0095; Fri, 28 Nov 2025 12:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33BE16B0093
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:51:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0F5013B864
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:51:12 +0000 (UTC)
X-FDA: 84160757184.05.EC6599F
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7FF9100017
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:51:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=aDAFTnPc;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764352270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onvIyaErE1aWYQFo6OqnWugBaON3BpZ7ThoIRVAF+KQ=;
	b=lOPoOWYSZ2XM0armb7LzAkvjbgBn/JHksUAH5wq2yZdY9kGf96HGDKsobgTKXOz4k6/Huw
	jS3+8UyufHetGVRDEG+epi/RvZmuocOPyOacqXk4Oj7JBn8iLzD230hE0ElPe3IrhhQBx+
	OgQoH62rACNEGaZ6zPg7ho3oVKkBL4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764352271; a=rsa-sha256;
	cv=none;
	b=z50BHHylZjc1tGt2xP0Zd8opAd52MZVhYLdms/rhFbiC1iYhFkfwNpWpv6RZAvKVno+tdb
	h+3KBYTasfOzmI3ZacwFWJgx1HhVqkjtctwYGaOKoGeV8gjA6ga+utWMB6j/3xjlqlPIxK
	WmahES1jCUrQSCKMDGLw00mGQhiZNo8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=aDAFTnPc;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b1b8264c86so189975685a.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764352270; x=1764957070; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=onvIyaErE1aWYQFo6OqnWugBaON3BpZ7ThoIRVAF+KQ=;
        b=aDAFTnPczchEu0IxcDnkrh5jr7a0sDJZOZNnGOMhgVGPA8N5118ULqpHf+yX1EviHX
         fsvJIaDUySYKaCbQ8tJCMEIdSdtxcnylyQv4lR7wRxjfvEUX3aZRmtD3Bf/JTjg12DfL
         d7BnZ29bASrQReTi5+x4OGwjkPsM5d17to1WtdzCd6TsP5lpaQ6AzDGgQRMaPqk/7HEk
         b+rrmsn5Nki6JKlRr6m12T3ks0VCgM4x0yy5fQh9VeuKpL8DhA5wkhWZTmEOTdmNbPNO
         N7yAmFW2Iu8cMGPTkEtCEb7Ei6P8d9nNMU0Fa3O8HRSoSnKnowqr7iiBNjYT69xn9oEb
         +IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764352270; x=1764957070;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onvIyaErE1aWYQFo6OqnWugBaON3BpZ7ThoIRVAF+KQ=;
        b=d593mfhwyyNCF/dRi8tsJvkGSKGsOrilO3nGTaVqrzkb3Sm/stppN+gq0EqCbKrBhd
         gHqtaD5PNUkQ4cN6M11htp19AnKluldssRv9BI0aawp08W9nCOZLxllwTv5Oj8eU6mw7
         uLEDrllPra4tF5szW1CYBwG0y+dgXVBEP310VrAaQgV+59OfRCvoXNV5zuI1jUINHOVN
         Ug/9JnV8Sj8MpQdLcZu40ZWie7fug30ztEmSz4uFhC/Rda8QscYu1o4vWL7mboF61ifi
         jP3fDarcqgv5+48vTeFUgkfNb3Cl27enG3lkSh7ExqU0D1xbkMzPAwsVPXOXQyrp8OxG
         Vahw==
X-Gm-Message-State: AOJu0Yz4mo2lSd+AQtcfuTdNwT56y2GgxXJuT8Yjeylo8jP7XQxL+kTN
	U5UYEwlGHLEs5PAxyWw8wmFG/lvqpUJuhbeG0SeIQf0w6id884Ab7LvoJipXdfZ4fks=
X-Gm-Gg: ASbGncuTkDQPHjioJni/QMO4kZztM281ewym93TuC1seqKrFb+U1RSGuHvfFXEJfguo
	pdUs/WER2HHbsiIpQVkgh5wETV3kRpeRZfB6o8mYfZbdMGKmrnb42TNPh0fdeJ7VGx6LoULfWK5
	90cff0ABwLlYaQgLtOWpmBN/QOd2NDHYigqsma0zK8hbRn6rM1wvxkwP9dMOyVQqs7N4dyYGluh
	U5mtT62hz03oaRC6peV5/+JnRIgeTnr1gTh2+tLrV2ozW5JB9a0JFeSBuxTyfEC5mkblCRsQ1L0
	lCoUZMv2av4a9R7Rh/EYgCbRwDfWo4+w1azxrrKdFPjaBf6AH/+fLEp8OV14xGYMOC573DGgt0S
	Ifq/EVNTpLIMfSM/BuXLC7k25DQXVa27X/xRQFHwrRL9OqndyjBkcXEHRzlnTD3k4++jeHzO/Up
	ihMLyYBuzi7UCnWLxxSgvck4bMnsy55Y8azCKh921e5/SjgBN3jICEpjH9
X-Google-Smtp-Source: AGHT+IHclx5WylmmMrcpXz3ZKtKlEIx7+f5j0jNJSK6KrFbXt341r2JXB7z5MW1Se7zpnvrWbmNCuw==
X-Received: by 2002:a05:620a:45ab:b0:8b2:ef70:64f5 with SMTP id af79cd13be357-8b33d269cc2mr3759648085a.48.1764352269876;
        Fri, 28 Nov 2025 09:51:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1b7d99sm342498985a.28.2025.11.28.09.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:51:09 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vP2ce-00000003Vf9-1jsT;
	Fri, 28 Nov 2025 13:51:08 -0400
Date: Fri, 28 Nov 2025 13:51:08 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, david@redhat.com, ziy@nvidia.com,
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, lyude@redhat.com,
	dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
	rcampbell@nvidia.com, mpenttil@redhat.com, willy@infradead.org
Subject: Re: [RFC PATCH 6/6] mm: Remove device private pages from the
 physical address space
Message-ID: <20251128175108.GG812105@ziepe.ca>
References: <20251128044146.80050-1-jniethe@nvidia.com>
 <20251128044146.80050-7-jniethe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128044146.80050-7-jniethe@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7FF9100017
X-Stat-Signature: tmtmcgddmgbdtgznn3d1rjqopti8i7q3
X-Rspam-User: 
X-HE-Tag: 1764352270-105133
X-HE-Meta: U2FsdGVkX19jTAzYcMBm1pWfBv/aSYA8/yDhaXJdb6SD9F2KJQKcI9UVcdn3Qt+VO9kJxrlMfzA6DYAe1BnbFc+IRWCpG85kbyYfuP8cAGMzKW2uO1Xq012+vZWH17/De6Dg1xoyI7AIrVQ3WD10VSCfcxs/QurORqLR6GczIMOLs7Z2wHfw0oqaqouE6T33ca6lgVJBy/Wf/1oTgtnFuV9Sx8ZVZ2JB7OW+5Ay20LKAVG3s8xgRM3PWGPy6y/I8aCVb00nvF+CdUU1sJMaBxti++TUs3A/tT6CEIbMrkPpVeJ2rEbZQBcP7BRq/HHoYHIv0txxGnhEU0Q7tJup39cm9qOdGdqa+PP7jbZHVaBGcEKUgO73TMAMUErVmL7SwfPXJk8e7AVVpDRiCvNDL0To8YXZipTa/Rsby+QZHXa1DTDQaofX9ItUphwXynkaZH37c4SS4catnTn1UcjglpFuJFiTuMQvfpRofcXzo2yBJA8tRQrcZTcIRp4pUATCVOT8Gdlh5x+Ct6OuTYzvklRGFwv7fGX3QL7uUrG8ncv3Ep3Opynd6ovD5VjT1yv64eUOtXlsPvXpK9KuXwWFu+CLEZ0bu0gSIe2yXX3FyDwPDi/8DcxLpSJPCe0a1Ozc/wKzx8Hyr4BT5YUJvxL1Ygd+KKMxQIv2D7BPEZN89POaZYavlOOgKjwIdgBeaq2SdEH7keUR66S018P3oqGJ1pU8tGkGU09lE17zBsI3iyZNYqk/tlsIaqFyMm+9q05tpRvEjs663mu+DE+7Or8l73U7DOWwKqAmOnViOxyp/dFOxdByTz42WIC7ROAShQKOJyyWCR1JV+lTlQLSDdLvHGHZ5u85q5MNB2x1mT5vH7NCQ6xxgy3OOi/TTH55KwGxyJHNZiSd00UJuWsSCbqxsn2w0iIIQCwY5YnnEPsgVTUV3yxbyQOY8N85h5BBL0HxRtFjrCLZ4uv9lkfR/B7O
 Yn1d8eCP
 21zoEp4pcMRs+ZHenZ7ne/tL8xmEO5nQuK+uHaTnuSm0Boc4oO/6y3ifZOHLsUCFYCOGomAgJBlRMBvH+AkHXsEg74PiV6Kb2BVGRPyYd5AY/r5DdgtuE79Jm9FeRbEbrxugfhCoCyhqNKQIKIckTMdXdcaeDZ+1Dguv0R12MGLBsq6QeEeWxM71+c/32iP4a0E65IYjj+2OrdDzGvFgFD19z204r5neC7kQ3PweQkHe5oXMQYn81uh0hyRr6emzAEhibV472ogOFF+4zXkp3Mz2HnvPpwdA20vGS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 03:41:46PM +1100, Jordan Niethe wrote:
> Introduce helpers:
> 
>   - device_private_page_to_offset()
>   - device_private_folio_to_offset()
> 
> to take a given device private page / folio and return its offset within
> the device private address space (this is essentially a PFN within the
> device private address space).

It would be nice if we rarely/never needed to see number space outside
the pte itself or the internal helpers..

Like, I don't think there should be stuff like this:

>  					entry = make_writable_migration_device_private_entry(
> -								page_to_pfn(page));
> +								device_private_page_to_offset(page));

make_writable_migration_device_private_entry() should accept the
struct page as the handle?

If it really is needed I think it should have its own dedicated type
and not be intermixed with normal pfns..

Jason

