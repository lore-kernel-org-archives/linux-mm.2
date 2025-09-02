Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE53CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121B28E000B; Tue,  2 Sep 2025 16:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9DF8E0001; Tue,  2 Sep 2025 16:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A348E000B; Tue,  2 Sep 2025 16:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE0958E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:20:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85B35140384
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:20:14 +0000 (UTC)
X-FDA: 83845427148.26.581D7C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id D1F542000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:20:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VVptB+eS;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756844411; a=rsa-sha256;
	cv=none;
	b=oSLXkqwvSATOXFASBWenk3JkWlIx8kJL1G3nAJqaDDkGfQ6E/zUE/cWM0p1sn/tTix/5y2
	xRZTYy4mhJjhYzcpg60DGL8o9gyjdlRB/HvUeGXmza4riYB1dPFQA08Vc5K2L7XBk64/6V
	YdRwn/mfDvTXrWygS3tR+r/JHRRiknM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VVptB+eS;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756844411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuyuxRm5ec6gcsPJM4+KShUVcowrlvBWYElAr0kZulc=;
	b=lTgl+VzvyDGUkwtdennqaYIwN1Go3a/nsBwg1OLKns5lwdSAUsUl8VTP4sz9SSIB46ZEsn
	07B3+lO4Xp8tJ54fwV5mybndQQrjfA7YXINT8EsyynzPlRsNqRp807fp9Fc4UJnLKzLUn9
	xG29phzFF1kSLoj3/5ssEcAcLoVpiHs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756844411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CuyuxRm5ec6gcsPJM4+KShUVcowrlvBWYElAr0kZulc=;
	b=VVptB+eSiKcH0FNZ/CxK3w4pKRF6UFSP0CNWjomq8ABNjY/XgMQ80OS4x/PKmhr4GH59yh
	Dkn6QNlNtu94kr6HRoqjcsKaau2X1ARTA1g2IWO2SV+if/iKd2iF6inHQluGb/7idvfPvd
	R1kWxeXFn+ysqadyrbvCXiKXWYd3o6w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-IE2hBFE8MBqegRLDJtCuJA-1; Tue, 02 Sep 2025 16:20:09 -0400
X-MC-Unique: IE2hBFE8MBqegRLDJtCuJA-1
X-Mimecast-MFC-AGG-ID: IE2hBFE8MBqegRLDJtCuJA_1756844408
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b9c1b74e1so5021755e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756844408; x=1757449208;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CuyuxRm5ec6gcsPJM4+KShUVcowrlvBWYElAr0kZulc=;
        b=Qn+dqqrwUeCXMhigkvykQ3+Tub9IVSzNJm4wp37pUDK0bMP512Sdt1K9Eqq6cjBKHk
         06NQ4xFeJxsnpDWvUdLh6fJv0qQg47b2/1P34x8x1RRkYDV0Lo5F22D6xnt7UychoFZo
         hHIiMGdLvF8WsE4sY/wtENLq8jdMjInK1CCx+neEYXFUBmSXTiU9qhqWh/+QVrMyvDFn
         2Mi4GPFsSjdftwC8OKrGQYJD6tMS2uCQ2ZBUqgMLXJiPr6aCvN4hND3k/8vwX9ayf1nS
         Rbigvtsee0/XtriDVBR6v+uz/5WbZ1pFlgDwaNGaBAW7YrHWbRLXUI4O/KmzyHCycqI0
         dIpA==
X-Forwarded-Encrypted: i=1; AJvYcCWCRj30GWYceiigyTgs/pXkEGsKINPeVPfviX1geYR8i31CsSZa01F2OX8VN/Spz0rFezW5RLqApQ==@kvack.org
X-Gm-Message-State: AOJu0Ywg+26lBF4fC8trEMEeznXIcqlpcO+wjjmPbRVmwMrNFihJ4vsA
	kGIIpU6YbyW+gaockh6ANd4t0dLYeIUPL34JZdCx3m03JJSP5b4q+7f1NY7iZPQ9yctNCd4ipRG
	a4O+mp+gcgO6QlwlY+Kvpmbbgk7HoQDkJk3XXc1truevy8Jty2eXt
X-Gm-Gg: ASbGncvjJ1gRnqZR7AD+YcyRBUrmeJGXeJ1jfj8Eisxcg14ito/58xrJmCawECBWYZ6
	zvoyXVXJjMrujKgicHLn5VcEugdBXXdnairTrW7oXLgJjEjZrTNu3gtzOP4uMWQIVwZGOM2NOo4
	WJVw9oBzcNCKLncoz6BA4dCWkaawxADNZp4P8A0rJ8SR0gZGioB99hXHlzlab2T0zLApmgyG7gF
	/Wh/H/d584sVm6TaxGNL6r1Gx78JO1pJki9zQLsKl/DzU6I9sT6o3/cmzFuvCANbT8Ormf/y7D8
	5cLdXSov3kHU8/eViZGvhZhfMpRAxT++Y9xr8wJHdNfL/38NzKg04F+oScFzq2rL4PAvX895eji
	037lwCp7cm1C0kJHU7x77EjO4GTX1z7t7s6g1JRLzLVYAiWMNVFyqI8cf7K0DOXFXtfE=
X-Received: by 2002:a05:600c:358c:b0:45b:9a3b:34aa with SMTP id 5b1f17b1804b1-45b9a3b36d5mr32941195e9.16.1756844408278;
        Tue, 02 Sep 2025 13:20:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMVtUOblrZpD/cN66xO+epD0JILTT1Y4c8ImtObJsq4l24+VO0esi7Oc90vomay1kmdbGuGQ==
X-Received: by 2002:a05:600c:358c:b0:45b:9a3b:34aa with SMTP id 5b1f17b1804b1-45b9a3b36d5mr32941015e9.16.1756844407862;
        Tue, 02 Sep 2025 13:20:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e50e30asm210722625e9.24.2025.09.02.13.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 13:20:07 -0700 (PDT)
Message-ID: <abacf7ba-f6af-40ac-b8b4-afe259546c16@redhat.com>
Date: Tue, 2 Sep 2025 22:20:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/15] highmem: define clear_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
 <20250902080816.3715913-13-ankur.a.arora@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902080816.3715913-13-ankur.a.arora@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y_uilyGgN-a-SbfvO-Uqnf6k1irJ2DL00YLNyijh--s_1756844408
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D1F542000C
X-Stat-Signature: cmdrpuk754uaon8pnwp46itrrc71chjc
X-Rspam-User: 
X-HE-Tag: 1756844411-988619
X-HE-Meta: U2FsdGVkX19nbf6+mNdRXSV7d+rTj719AK/0tuK9rlzRYpvyaw2hMKS3A+gwIUBZ0js6xa3T/5/6nMyrVs7lWfyUxm+i2eEr9Uipm+RklI0ZJ34y55UvevZW9VslUUS1aAJ4yfyw2N8pnMI4QKYBESitVO8BddcMy4WBkBIXImz9bAfXVDCAWXHRONQA7wqEqEAlHFxiiPAVkAK8BZPsQ0GlcJNM19Sz41F8LmPd0mUepcG4S2dgo1JwkaYOyK0LaMVN7gW++U8B6XJ7qP/Qq0Dop3kiZJj/DIcwJ6Mm4HbkoADjgQsygbpipYN3GVNv0Jbtxf41cPR27KZR9yFYVg3YmUuG9Cp6P3tlK9DiUlJAkHept3ro9gIJWici/VnC+WxcWdctGon6m/aRbxUgXarGQ/PzQdtBw+ObhKm3CjAmnGbPb50zbVthKQiwmqr6thA+fEwv7rlXUVpZ0q2OYHRzhcOuUBTCQ02FpIHld5bo1DQiU1frnI4KgL1KUTI3K/5k4C62fW1orujCsabpV8fRuXdYJiNLfrZgjfCjcK6X5PFxE4fG/QHRE/m997+2UCpGYumhbJBgwfRcV+pHTIiPlvNxN6OY978fayCb4TRPG5bR6slxoK6Fkyr4qc8o67IfEWqc3DKVGOfAHK04iqe4Yv/HxS3/VLjZGKOsP2HhcCl5kQ+qucP+TQZ7PqujQS5JNIETmZByKSfmOMjnon42qOs7+S4Os+tNxHsOCtwPylDDBNQgFK9GxhkNbL/8uWEVofDJcccllYkSttCBG1EA2/50nuyk25SVEo+OqWukSyUfZDQMNmPr9IgrJ+USIVRYIrobaKupMO0oTKOZUajG6g6JaLtSxSdHa267c5039GZyiXhORR/bezOdbBafmQw4e4eqvifzNQ9KzOZmgbwtiv0J2Nc/yQNdmsJGuR7GhzSFNUEseQJu7eC9aLITvo9sgXIcsxMBuw138jq
 aNOwU2I8
 EgqvJTU12Xj1VZPjvnWCpIFJo69G71oraf9cucX2LBzWFVood1Ca0eaGGabFSN6IpekjZe2Ou6MuBzfr00KmTbL81liS0BYLP+DHedJgj0aI5FY+60dKlhJV37MDiI/nCSqIkHYDVQDHalyJDAc9RHhn64Z68GaSR79rS05aS1QI8oZjILbZxsKMUwkAgnMuof01tQVi8vJKV/Xt+pCVyQqWqKdUfOxpzZG2Q87RSR/WrR9pdOmA0CO7GgTFewnGen0ST0x7+YA4lKVbIy2S3kxz0c/hvO3/roz41cjSSuI4wshxFbsUBVUKpbWhVHvGKk7Xa+eAOAqxs0fua02iw1T8bAZGKey3YdMbOTeE4ZuVut9Law1eZTG/yoIa+vCdac8H+4FZpu+JQidlhgyodfb7rUEECq1b5Mmt8Wmh3TZyi56Z1/SYxb0jlGFspxDaKQqXjz/hctZ/WC6DermvUtR8zn9JtDfOfiVRDpXudNVhDjXo0OHX6Hgg91UHVc+rJiGDa1WhSZmKBHuQ8k626r95G0LQWtEKQdT+qtfzk4pgNIG7kLvMiUxdP+g72lKI5/GJbVQkKCAy4w8pIIL0mRzQZj6FYTJ4P6atk9gsAqKz4x506Nnf6xBFK7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 10:08, Ankur Arora wrote:

subject is wrong.

Maybe call it

mm/highmem: introduce clear_user_highpages()

> Define clear_user_highpages() which clears sequentially using the
> single page variant.
> 
> With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
> primitive clear_user_pages().
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>   include/linux/highmem.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 6234f316468c..eeb0b7bc0a22 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -207,6 +207,18 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>   }
>   #endif
>   
> +#ifndef clear_user_highpages
> +static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
> +					unsigned int npages)
> +{
> +	if (!IS_ENABLED(CONFIG_HIGHMEM))
> +		clear_user_pages(page_address(page), vaddr, page, npages);
> +	else
> +		for (int i = 0; i < npages; i++)
> +			clear_user_highpage(page+i, vaddr + i * PAGE_SIZE);

Maybe

if (!IS_ENABLED(CONFIG_HIGHMEM)) {
	clear_user_pages(page_address(page), vaddr, page, npages);
	return;
}

...

And maybe then the do while() pattern I suggested for the other variants.


-- 
Cheers

David / dhildenb


