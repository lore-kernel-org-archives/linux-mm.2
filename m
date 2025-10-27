Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C835CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 15:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28B780062; Mon, 27 Oct 2025 11:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9198000A; Mon, 27 Oct 2025 11:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA10C80062; Mon, 27 Oct 2025 11:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A838C8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:43:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 579A056B75
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:43:36 +0000 (UTC)
X-FDA: 84044314032.09.7D0AF15
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9BBF2A000E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:43:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bRAjo/LY";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761579813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c89p4IzYtY7pzZo+jzHGxHZt7mqwdmnQ49p8S32D88I=;
	b=UY4Z15vQM9nS/RgixvVCja4Gt4pbgMJ/LNbBAZKh8zVF2WP9kd66IV+pVp9sWT98sy4w7D
	eTp4rSz3p5CSCvdI8rDdoY1WD7MxYqA+60N6fbAS42gHz54n9H/g69cj/JZgnCt6MNq6q+
	IM1AQgbZZRVWXsRsmj/bairo2UFlEhg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bRAjo/LY";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761579813; a=rsa-sha256;
	cv=none;
	b=zlImKrFH5HZGlCCuC1JpNSn+puZv3/kEHKLy3kmRO57XDokgHK7GDWPKgNoIeP6VrSKBNC
	W1WgHx5h5PrMEzp8iv6nwQq+HVuE/YKMsZjhDLLmwFjf/3mkloYd5/6akB/yNjF+dLTB1k
	72OHJQ8BICxQwUyX54ln4JnTGfrht+k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761579813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c89p4IzYtY7pzZo+jzHGxHZt7mqwdmnQ49p8S32D88I=;
	b=bRAjo/LYn2s2SWXrTimtWWztHuynnO7WWdjL/laL4UtzoCeHuiI76SPkEzmmzWj86XUeT2
	XCTZWuUU/072zQ5+IpDm/15yVGx84Svh9ACoXZ+qBO68meP/Rm8iV63Ljqqj7EiA8dv3cT
	7F93W2RcOxss/7+h73wKKWYHL9rhl00=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-HijpAiYVOBu1wcZDBrSmjg-1; Mon, 27 Oct 2025 11:43:29 -0400
X-MC-Unique: HijpAiYVOBu1wcZDBrSmjg-1
X-Mimecast-MFC-AGG-ID: HijpAiYVOBu1wcZDBrSmjg_1761579808
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4278c82dce6so2855122f8f.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761579808; x=1762184608;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c89p4IzYtY7pzZo+jzHGxHZt7mqwdmnQ49p8S32D88I=;
        b=HF71jLtYuVZ7aakQjR/SvtbjLSrXOv3tbgffUSAoWRhblMlwT//3Y1wM5dRpUUWc6X
         M/4J7NMsT6PiJZ8rzy0YeFrda3t6ZJNYkuJIuezIaaTjGAIegspXE409liNiDN4fhFgL
         /fqlp0dgV4NvrJiatT4UMG/iNmjIETLr/qo+8/gG+ogrs+iz++9Ddt4u8NXETlAZ6vac
         ZFedn5Xyv1G6ra8AxlPwGZnOXfA4XAaLKyoPmdPkXxqJIzIaHbkBdavDjyBmoX5MvexV
         cfWz/oexVHnQEt7/1q72YWmfQuJQ1DveEY5CI0oL3AQWwdr479ECq8kFSA0xuhOqMYLw
         nJIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTKkhHlCcI8Th4ujlnSflYppdKu/sV7pwECm1FO/9fM4M+kOCuB/QAogQF721DxjwPUj0RK9hGtQ==@kvack.org
X-Gm-Message-State: AOJu0YzxEz9iKHAOVeMBGGRM+bL/RBCQXa2DzwM+OHgK+RaB31lkrWL+
	WdL/Brztbsv7uJwOBaNGwB1Dt4r18kq9YDcrYOwtXjrDTSb4XcgPE81xQLrLvoyNqr7VGW9oxC+
	fgdSx+yIlzDevAPUoXEgH5J6n2IMKuAIDoLKiavyFisDs1lkz53Ew
X-Gm-Gg: ASbGncvzSbroQC0z/tOAh6SkXG0T2/zigJ6Esq53Dp3xrePeOQTDMIUpu7AOo4oZjdO
	WnLH2UUIC5rWY6RqwbgfdW+fFGfVrV1laGwPYftJtiqGyLM/kraPDylm4nh6u1gUWO4qFD27X8g
	Zx8M//KBgopgHSXdoOpYyHFA5TG87iXxX1ADCw5lV66iZGKp4Xy4JoNremyPmw74R+PLPpXwOEP
	tJ0/YRyFNYRQ3RRAP2wd4VlazQRxf1Esp1OrF1Qp4KHaErhVm3AMZTrJZ6uB+mjyuHsm/wXAKmS
	HCGjbpmXqBpRMXGOn3kbB2ih5S3CVYOrhWulozpSlao9B0LpILpe619bXJxVFnSu9GogknXtktQ
	SgcuBj0fHuiFW+q8LHJ62DWihA21PaPchHG9WhzV+aCLPNby298DC4UQ8F8EBXIm9WWFCLYRraE
	Jkktv547aAoXGwsBp/D4UoLbl7070=
X-Received: by 2002:a05:6000:1886:b0:428:3e62:3204 with SMTP id ffacd0b85a97d-429a7e76a7bmr138978f8f.36.1761579808269;
        Mon, 27 Oct 2025 08:43:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQAxqRr/rHiIk8Be8Oqj92G4ty8Zz+XoADT70JNYzG+ZSCLbG8+dIoqG8BUmFlIVgFfrJuzQ==
X-Received: by 2002:a05:6000:1886:b0:428:3e62:3204 with SMTP id ffacd0b85a97d-429a7e76a7bmr138955f8f.36.1761579807836;
        Mon, 27 Oct 2025 08:43:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d5985sm14768245f8f.25.2025.10.27.08.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 08:43:27 -0700 (PDT)
Message-ID: <2de17512-3df3-4ee4-9912-8a8f7ca5b648@redhat.com>
Date: Mon, 27 Oct 2025 16:43:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 Wei Yang <richard.weiyang@gmail.com>
References: <20251024192849.2765667-1-gourry@gourry.net>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251024192849.2765667-1-gourry@gourry.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UxgAcuHBsXoexADe95gzgopdvkRc2S__6LZrunTPooM_1761579808
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mzqw5i5noe6jxc7st3uprefib8nydaxj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9BBF2A000E
X-HE-Tag: 1761579813-796062
X-HE-Meta: U2FsdGVkX1+5scGaGA5VYoa+GyRYJQOGxix26AkG0DFfB1HJHY9fj7zlo0VsrOPy/bXgrRF1pnVz43mlx5YjkgCQF5z8ONFDA3bhrXstNCBGmfb6zDNxbzj7mHycoGUcPVWKCHhX3P7ZlQF/L+1AOZMS1FEfMEJYeG0Cx9r0YwBtCn+Bj5bPTdBMfvjeR6t7obOcrQfo0MWMPkHW91LV3uCaw54/I0K4D49OpI+cfB84QSGpR1m0QD/zCH+01sP1BA+3XwfOI6N2N7R+sNcUVa6obk2jr6L+ywuy/IKmKfqL4JwOuTzo4+gSuPlv/Xz1Lvke+DtSd+fVaoh6eNdYJDu+XSGrDL4Unh7NJiPIpcVLvFlvkNc3AGkvPXZEYcNppeTp4DvdhmW467cgHKigURh73c1gWuP3prybIhrJyXjBTvgAdpP5uGEvMpEfO+M/Gv9VMG+H6FD6qpKEgnDhGIF4hyv/jU/WKeQXs+tTKSZ+RRCDx5xt4kV2ty72iiXrXi9FyaaYlAQljHTmRqVhIhUTGkb39kQKcd/l6B0TxaNZwha0nMVYs9d+Bh/vVIbAtZgMJ9aRX0nsln+2Q20vkAtyTgqdO0aJWToClhjBMMjoigmdgj3ODsfnEQ7P9I+e+vBGGlwSuYt0BpJcwyhcFZTIGaUSO61270ooiHUQo0BFTo5VHB0B5Ly6tXHrVO4zPmo/rsQSbNoPUaQVo9J9AO2GWk9VoSfeGWuSJ2p9h9/sL4YbUgmL8xvDSiG86aiScAoMAieJ/PHaC6GIK8YNedpPc9tjFrbW9gBobvyUAumS/mJEDWS8ko1NKJaFKWkbf9LvYd8gTXjuHS6fcWKxBD8H0PTyfGexx723gp2zBwvGowNJaYKpNcrzMxsBwvysUacpgG6ncuM60g7WTZcOi0VprHm3cPNuzI4vkWNoC9XgiMVONSYQI3TA+zBU3oeAAaEhUIS5U1dtMeq1noj
 OYpPIGX1
 oTOw+SqWbgisNdE2HCSfPeWFP/Ihvs3pceqM51g8l2ktIRlXpEdL039Fnn3WPEKhaikehuuS+11pKWrD1DKFe4LCHwSziAHkYAqCoXTm87n6ZJVoMCvEdHJ72OvhN+lcXdedrkOKBQFQPnT4rwSIfZKjfkAN/pwYwFl9DvpeNwc1TRGLZuZhKoJUkua2HaCEdprOOXhFkozfmPj55GNarbrx9KCGo/aweaH+mxmFYGMGSZrCoIr3xqne1GcW1JutXIomE3Nn5vphqv/rtZguzGMQDCrurk/fiEESfK1fpFpovo9/zAezLbC11JpEJPMP6WrMXNlD/gzruITM6poYS/P3r45miASnxRc8TFRhVevUj9dKdtGbW0bpS1LOpDPfmjwRfWpK/IUy9eq7kaErIUcbUn0TrxxjkGvdU/3QOylIeX97zOArhvKFJ0zMUcXEohAXt39ZyFV5MT/lBOxtG87m+prmz8VTHm6pq0LP+T1lCT7IoZS/rwxK/FXvu6Mkx9oa+t+rXRRsyiWs4g4Tu+DxZOJmhPIU1D5zg5PI2jrRiERf46c7HP3QZ8vmbDBGtENzEeh/2mXmugaauDTXucRXBzdEdrJHGzUPXZ+a8bDsm8XPY5scq5MPx+u6P3fdbbDowqAeDb0emXJ4/PERU5AMwrCyZ5JSlY6RI2oEyT20Bk7c3EWuy65oa5eiOcHrYdKVyNal/+ZsGnTItRqVKfSRe/sxkpEaRTVj0fqc/LSh5WuFdh+Q23331evG21XoI0BfP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 21:28, Gregory Price wrote:
> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the target contiguous
> allocation request as valid targets for allocation.
> 
> isolate_migrate_pages_block() already expects requests with hugepages
> to originate from alloc_contig, and hugetlb code also does a migratable
> check when isolating in folio_isolate_hugetlb().
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Nit: trailing "." in subject

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


