Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65CECCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845E36B0098; Wed, 20 May 2026 05:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F68D6B009B; Wed, 20 May 2026 05:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6156B009D; Wed, 20 May 2026 05:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C81D6B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:44:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1932040213
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:44:30 +0000 (UTC)
X-FDA: 84787313100.28.30DC82F
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28641A0003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:44:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARcpmG5T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779270268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRg4MCwFnvrNqRvlPfGDLk8MzpC0OLCTk14CpKVfvfo=;
	b=CIjSQbGzOKkUGIujPhU9ZRp6DjnsEo8nf8GWI9aVvmX9g1AciahlI8dsP/gDmYwSB5VnZk
	r/jwVvsNUL8bOrxHIf/6xQs5zKDQ2Eqrm3KaZCc9ay/tGTh0TN9fr2587d/3hi2QLYxGFT
	FWgI5v0fNhZXm0cLWk2pE/NF7mJr7zM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779270268; a=rsa-sha256;
	cv=none;
	b=IHmj3JhBSne3LbmUhTI+XO8m9CtONIFYUccCoIwXPap0xAKcliQfMQmUQnHnMnEm05WKa6
	Q57BMPC2egW8SVc+Il3iFKEZOKlHe3e4obLv8D0bE6uPPPS4HCK7j5o2lW9GdCPjHc8T3E
	cMaqJ9aVHTrPQfFGXkh3hxzfs0CYQL8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARcpmG5T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a8c94cefcdso4086061e87.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 02:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779270266; x=1779875066; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SRg4MCwFnvrNqRvlPfGDLk8MzpC0OLCTk14CpKVfvfo=;
        b=ARcpmG5TSLcnZAT0IQ+rr7SdYyeClXXP0ZOY8yb+iJIHJFqDGJz2FYywr0S2J7vLMP
         rqcoCF+jlK3cSU0H1v4YCWqdeJexvJtvRUk+CL4hGWJrIfJgYDUP+dvnZf6pXILwyztR
         HWNH5R42bFPxjjJOD+SZFXlrBEzIzrnkRZ1gVN7utQqPSvYNlkKyzQoF/A3jeKmCl2BD
         4W2VOOKXo4NKyH5mqqP5mCdRKxvRGdZ5HdIwv8prjZwUQcXI9ynO65rMPN/4K8Ds/3NH
         ariynHQe3uiuoR+AR0OaeyCeeYOMX/DG6/Cs00yGdJByl3ZCipIUXsRBOGYyAkmyc/Vy
         2sfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779270266; x=1779875066;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SRg4MCwFnvrNqRvlPfGDLk8MzpC0OLCTk14CpKVfvfo=;
        b=oDPvxvssZnmpCjUNp4siwguCtvrVYqfBFk1DgD9BfHw/Y5mAHozkNYMwL0K/6hi/AF
         SoG3n2YdoGukBcZuKp1ZeI9aQfBl1vitmgJ8Dwe25n+Q9TV7rg8yOhwON+xaVMk8AeDj
         Xau+iJrPrRKZtO9Nnsq77rvoP3rsqC9JFOMBimIbzXgxcXbBE9/TtPgOgn/v9N2lAkTE
         3WUmAyV1OJlLlJLNnvQjbT7JmwGWq/cyECEBriqTf32PLFwR2Tf4PiM5qqtoo+4la6mm
         FKinCtqlWIhCFVqiT2KLvcUHm+cw3l5sEn34RxWx+y1Fc1tRlg1GmkRQH+apUAwZkeh6
         qL9g==
X-Gm-Message-State: AOJu0YxPscR75IqngWCZYFEH/dzjVD2+2n5jpVIa3LuIPyN3G0MPyFCj
	map8yDIiKw0ULthrbxG919tc2bWVMsqEVKmoOjNDJ5/gjoLLVgnekwhD
X-Gm-Gg: Acq92OH2BdmzmhG9s3iSe7PTrBfmz3PlV+dreXUUgIayglJR6uNXP5dGeZRhu8ABW6U
	v8hs6VV/7iwIZp0fdILnbHXzQ1bUriL8+XMqpZgwOo7WO6D7+PDujyuNYiGuUk7aVc7ipb7GtAC
	AXOdrKAgyjaH79CPk6C3Ye0fVpasgBGcky2bhMDeEoQacK7wbBufY1jdDGbCSXpIUzzrLSLQ+r1
	xJg33itG7r/jyMYzSoJEC1RPEoVUaqt1ype0O+1UvYuaQHpG9LKhXiiNXCWJJJ382Pr0MO3KPF9
	0xlUbNgj2o3qoXSMrxoJVSCpKIpRwF8T/J5dp5wR4JMtMQr2lpicxukFizkxA9qhIBnnoRQq361
	7iErGm6w7/Rx6wuTcl0285JkqIfnNI6cUSVUKO1kJmWoaX55tr4GZd1y8w06dxKgmB9JnC72fPf
	g=
X-Received: by 2002:a05:6512:318f:b0:5a8:8de0:4576 with SMTP id 2adb3069b0e04-5aa0e764a87mr7000628e87.25.1779270266285;
        Wed, 20 May 2026 02:44:26 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a90f11a619sm4807804e87.27.2026.05.20.02.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 02:44:25 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 20 May 2026 11:44:24 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org, Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v2 7/7] mm/vmalloc: Stop scanning for compound pages
 after encountering small pages in vmap
Message-ID: <ag2CeHWDLLglCF7t@milan>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260514094108.2016201-8-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260514094108.2016201-8-jiangwen6@xiaomi.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 28641A0003
X-Stat-Signature: g4sdrshm34e1zep3uckjgzr9tewtt9ec
X-Rspam-User: 
X-HE-Tag: 1779270267-622851
X-HE-Meta: U2FsdGVkX19AbNsPd1BarXm8UvaqjEt/YkpNtBlBTGWGdGpSezqGoUIPmiqXwWOuUKY41YjeMZHP8XtSaZFhsx98vFk3sbAeiQCJOu1Sfur6enR0QoZrb0NeqcPk/2d6cpwfuZ9t90NdBjIR85mGuGQT2RVUd4qNkGuLwJNDQUZFmjs9NbP0w6c1w5OBU5LQrsnJ7gd9AWT2rw5751s9hj6Iwct0ZXhl1kPumzu4Vf6ts7/SHc6OuAQmyJ/2S5Z3nrYA8rOU+bP5wq9C110wSB5YL1S6NUKXP9iuGd+QhTFRZ4HtveMBBdyXZhyH3x3hWarYBzTn5cHiemEveCm6xbNNBw/ivQQWV0EG4wGB6EBEMB4x2lGkf2wrg8PPUkQtqo179+Tf8CrDjBuLDuFEPnve/DgSOa4zAMepgj8tqk30dGZk6oAj0tOK64LMQihTdh5JDyAfY1JwCX19zzWV7IcpF9REvqOkkv2ghPF8Xqi0im4qK64fry8lL4UREwrCCvJbNw/0fojSHtJqOs7+MDx49wTIM6WekGsKjCL/DmnlVASfnSmCvDhlNb5ZMoEe3m3RsGM4qDQi2mjPhdxSSe36a2RFXxRLmeKsvnx149w8LjpkqDw15E6jVp2QSqjNF9TdJHzJvPU2a05a2o0Cl6SBhyMubvGkbK4/rljcgrtc9PSBqsmBmp0GS7J/z7AzItfAWizcdC1cTZ6+HAqX9HlSGr77s3+2oK7rkHwijg5aC8jVHz/rjnTMSW9iaYRJVaBlxGwf5gP5SxeenDIxydEp7JW5UdNP8ZmrvUQbRZGPq0suqJTcxMhCnEHRIvUxCx8CmQtIX26dJB5FHavUwUNoqQQ3MlKFvY4y04jeiMjIQCNQ+z0P1PZ724liOOMcEc9nn4rIkDa3h+nSyZyboHvsh2yNCsoS7AaEOmxbKXRoMwGE27qblPQ4fvYLlWztDvDk8WaEY65KdCVgCaY
 k2vW0lC+
 sMRO83ACLSxcHwdoXMEsdtdZFP7sWASOCxISjE4qk44nv/8CJPWcz2WFNBs2sNWbI4WCLqRedp+s3feFi+JbzBuDdN95pKf71MktpvuEsxYHxgyl0BrKKZKZ4QQ83f0EU82XFZN1/qyQiwTqJB7Up31oru9GUQz3NfCqrBi+d2Kevx4jSOdDJvOIg82FIB3mfUce5i8EztG0dFf5TAK0waik38Qe9vAgUuyJhT3znnQo0ez8HAiO7iWKFjvdzG0ELci4k7hi6SlZvjKZXfbcpcJi1tRD+WjNDf691Ha2CJNONTcKITQKa0/xgxGY0slA1q2zpEzIUVZsmdJBng4UrQFFSD4Izzp/gIr+1uH/K/DFfnUPLKUaIDa5zeMU83guIvgANJrB9ZrGvxjx2p9VHId6WLOpMj1VnlVG2TyGEmdaEjCNSVfi9K41LvWzlwkxy0JoAlEpgClq8nVxCeCpa6HbHUjf0C9y0X3t1W9X+p5dREO8LTBkt+7FMfsSu015AUJUj39gnWt5PIKq8qg5QcsGhbzu8IqSvbvPWHkNn4fIVj5sjSz0Si7mPPIhCByvQ1dEIZ2RaXl26dLnOpRoJA3clO3RnPwD7KV4K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 05:41:08PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Users typically allocate memory in descending orders, e.g.
> 8 → 4 → 0. Once an order-0 page is encountered, subsequent
> pages are likely to also be order-0, so we stop scanning
> for compound pages at that point.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index b3389c8f1..60579bfbf 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3576,6 +3576,12 @@ static int __vmap_huge(unsigned long addr, unsigned long end,
>  			map_addr = addr;
>  			idx = i;
>  		}
> +		/*
> +		 * Once small pages are encountered, the remaining pages
> +		 * are likely small as well
> +		 */
> +		if (shift == PAGE_SHIFT)
> +			break;
>  
>  		addr += 1UL << shift;
>  		i += 1U << (shift - PAGE_SHIFT);
> -- 
> 2.34.1
> 
Can we squash this patch with
"mm/vmalloc: map contiguous pages in batches for vmap() if possible"?

--
Uladzislau Rezki

