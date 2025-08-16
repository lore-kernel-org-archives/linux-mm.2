Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0025FCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CAEE8E0237; Sat, 16 Aug 2025 02:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1978E000B; Sat, 16 Aug 2025 02:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791568E0237; Sat, 16 Aug 2025 02:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63FA28E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:27:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D41CF14039A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:27:49 +0000 (UTC)
X-FDA: 83781639858.25.BE5FA8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7760CA0008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:27:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OVh3pBvL;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755325667; a=rsa-sha256;
	cv=none;
	b=z/1bGnEJSiZFvBfY61SLEHsoxGdAPjP84DvGbZOfVYlS53Ecm1xTdngpiWMNZu18bDVUTZ
	YpKv9tnI1zqQHdYdHOan10jahvnOXFdUrOpzFkjMh2jaOePZ1TruZF/83OOLtVB0YAUxkg
	j57fE0zXIevfi0e0tSO/lPEbLaLhE+c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OVh3pBvL;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755325667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUuoR3W6iZ2p6uoKb6adWtn5/8ajohyLB0yXCyvc0h8=;
	b=I14rg+j6NyJfHG83/vfPZmGG7qZEJARrhr89T5ujVeUvMQtnIGTIm2KdEtLhdkxAIcEXCm
	mrgsz9ULPNbfs//vfjyk8YYhrMaHFWwY9AFkrhtGKoqgrl+huAwbePP1Ky5Dah+yiYSSQ6
	q0W8nACOK05XSyq+r6dgbj+rqbqc0ns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755325666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fUuoR3W6iZ2p6uoKb6adWtn5/8ajohyLB0yXCyvc0h8=;
	b=OVh3pBvL3T/Sq1BL08wkmdNejPIwjo/n6bFs1Eg+8uRoIEd1fPWvSS7sO3LNvK7H/AHBRS
	r+7R9XxCd8bzGhR+kkzeHjBHTkR3Pba4759JREo/ckbVJSeKYhxn5UcOnkpnicpLRKakGb
	4Cuaaq/jTS0pm8iAwumBvcEY102vU6A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-HMOcaUbaMCiN8Cfhjb9enA-1; Sat, 16 Aug 2025 02:27:43 -0400
X-MC-Unique: HMOcaUbaMCiN8Cfhjb9enA-1
X-Mimecast-MFC-AGG-ID: HMOcaUbaMCiN8Cfhjb9enA_1755325662
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso11979935e9.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:27:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755325662; x=1755930462;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fUuoR3W6iZ2p6uoKb6adWtn5/8ajohyLB0yXCyvc0h8=;
        b=dtDLLoleVVKhdCGZ1IPjRqZLwZRRb7YPlJ30EfetOfA9l0PArJWBZPuBPIzX7s3Y3M
         Q7vheYzy7Q+fDAj2Z+a7zYIGE6LElWgrytWJ4y/5PrTa0sov9k2E7vTI4hYXM8p7NE/J
         r/g95zHUArCAFcdwLlH9XZ5I3mgthg7KwV740/eJ2ganJMJ9vx/msIJXsLGSq3PEkPp5
         tNhpz/U67hvoXUqnxtqHwioElXeQbI/aVgPNac3Wk8cRjs8gYD50U/q16Mfqfh4ltoTF
         6vFSd498OnEDHiX/Y91rApgsrg/z5nDri/vV9RjIo1GUD1e/hCWvhnOwzkoMtgG3EJJK
         HXaA==
X-Forwarded-Encrypted: i=1; AJvYcCXIyLNCNxmLEg+bsi60iEAnn7erTKwXidYLw/noOI6xo8QTo97l3BgUdprIa1HXzSdiOhiKkki27A==@kvack.org
X-Gm-Message-State: AOJu0YzrGlFBcmDK2LNbd4YSHOgPZyUwZdj2GJQJSS7vIDpctY8109ub
	8hZBC+jrlUpiHR+VPjQArCfIYTO21jydXUFnzrI6CylsvnJ6l1FErvtMpi79RL74htbz7HlYShw
	HY57iOdiVqM0CGBxS+W5xKwZhJnpyqhNAdOwn34yvwvOiQ2JzWHhw
X-Gm-Gg: ASbGncslp/bA+p7dxKh80r4ZcLT5keF4nPCtMNO279wfbZvtzGkztt8F/0g3W54ZLt/
	zBzUe0GXhSouQz4vRRsxf5GvJBEhqtgUPNIonxGG3Zz5yFkc5mLz62Ez+oSu3NbkPqLwkazE+5U
	IHIDBrF8KEbfKVW1YIeBArxrP38eacbarmh+tJXWlsqCb/yS/8pBkYN9xhNxVPEzXk2abbmWCWT
	M7lf1kype4fV2cgd+Yuc2jk92R7NUo8r3hJsI9AV3XsjlcbmaNS0RcyRkDsnNa+0HNIXlPcAC/5
	P5Y6AXgX3mSywKnw7fpuucJCnh1JVM1BCKZ8emSY8uSpL0rWd7alNTPPDAsy+HHpOun13xjfSYl
	rTWz6++2KJRdSAEjNTSkOq6eQxMO+1FAFB0MJTJ8T+Pr+s7d9QspSL4Z6lobBLVSWUXg=
X-Received: by 2002:a05:600c:c04b:10b0:459:e3f8:9308 with SMTP id 5b1f17b1804b1-45a21ab157fmr22208055e9.11.1755325661986;
        Fri, 15 Aug 2025 23:27:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaL5U3yulaxPkegpoMwZPMWC4xqYC1NkrnFhrR/g7GiOgEyUoKNgfM5RiObhMGQcjcxWIdJg==
X-Received: by 2002:a05:600c:c04b:10b0:459:e3f8:9308 with SMTP id 5b1f17b1804b1-45a21ab157fmr22207915e9.11.1755325661595;
        Fri, 15 Aug 2025 23:27:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2221136dsm44144735e9.5.2025.08.15.23.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:27:41 -0700 (PDT)
Message-ID: <ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
Date: Sat, 16 Aug 2025 08:27:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: print total and used pages in cma_alloc()
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250816042842.3959315-1-gxxa03070307@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9EutiAy-mDPpb4EkS4VM3zBJqAPaFm8pskVMNi7g1dw_1755325662
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7760CA0008
X-Stat-Signature: qkby8kmsdyg9wdgi5esmn9n7y8c36zen
X-Rspam-User: 
X-HE-Tag: 1755325667-608357
X-HE-Meta: U2FsdGVkX18BanelAkCaHiiJ+k7JpeFF4hN6APprqmbJX4NcFKbcyaL01BvSJH1GndX/6Iw6xpHbtR43U6sMOr9GzTjXYOB9WjYEAVxxhokgzlPDEG7UWKGM0NVPh0Da6JtlqR7wIN2bvw8/p3pQJ+gZtQ5Wd/5Li2bc8gQfU1Lp1jolwfobTrWRKBNBLKf0IEK98d2qP1SFwlhFMeRvs7NqE24b3N1yvCiyElvUhG1Sl3THCiPtCz2KHKYAiUBcRIILC8CMPK9uLuLWsJ7RA1hvru0vCBvKpNMMP0cK10ors4jgQ4HBFv1ytF62L3RLx9oZbYLBWxmwg1UhxSrNhLCt4bgj0GwftxYs2BPPHhpsuTZS7w/NsVo/yaiREefzXTkegwmxLjTJbtAoz4Nhr/Pzwnks2EX7HWrWGBY1Iq5aORnCPfEhe5A/LLNT87zkrXgXuQoEv03CTcPnzkrsIm32iTwX3mN0BJ7LvWR1UQC91nvQU1BA5Z0uLexVMmXFLW1C2LgjP6Lt9Mo4AFnzGosCtfOC61OLkB0i+KAAsO7SOafJf9edEhD55yJ/zZ118dMDmJlJoX0+ch4NmSypgjSneMQTtQMuv86x/GEzQt5pn0i1QF7yOn89UrHFapZlngElGwkuqqCKRpqGY2OJEOLLF8oTqVjNpabMULV9pwOTFovLL/JESjP71jsJF54OK5uye5GxT3ELGjZ2RkxGeYyz0YJPPYS/6zSLTEy0k+RDupg7G+86bEFjSPCa4K+pugSsPLCkngB0I2DJJt8uJ+O4QD5AN697E0oGJ1z1sVBRZHQKpbFCyOvpALHGbm9Grus94/LuNrsIrc7Fan7buqvirl94T6EjUTxPtcKTRR7EVDvhG5LjXgcrpm1utJGdP92RNMBSIbFY1i/j+WmVqbVJfyColX66y9yNkMC2rTK6f2FP5aEMF+clYPInCgQhoq+Fpybwxw7nZ4T3Pp2
 o/q0r7h5
 m046WdrQaLmMcJSGjlc/22QrH7UoihvAOMNLakgZHpfXDDCRaG9+5E8XZ7bx4+4ng50RT6g8OFWLqWxCwW8M3TXkzy4v7tx1NQtfAbcyRBK87ZzirNHw0xb/zSSKCCtK51QpSblnM2OENRPQl+2X0B5DfBiP6TTIBsH8ConuHtzcx0W8+ARNRJyuT4G/Ju7y/hB7hl1qcuIf+1zXSSXwNXpa/MQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 06:28, Xiang Gao wrote:
> From: gaoxiang17 <gaoxiang17@xiaomi.com>
> 
> This makes cma info more intuitive during debugging.
> 
> before:
> [   24.407814] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
> [   24.413397] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
> [   24.415886] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
> 
> after:
> [   24.069738] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 64, request pages: 1, align 0)
> [   24.075317] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 65, request pages: 1, align 0)
> [   24.078455] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 66, request pages: 1, align 0)
> 
> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
> ---
>   mm/cma.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 2ffa4befb99a..46cc98e7f587 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -776,6 +776,17 @@ static void cma_debug_show_areas(struct cma *cma)
>   	spin_unlock_irq(&cma->lock);
>   }
>   
> +static unsigned long cma_get_used_pages(struct cma *cma)
> +{
> +	unsigned long used;
> +
> +	spin_lock_irq(&cma->lock);
> +	used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
> +	spin_unlock_irq(&cma->lock);
> +
> +	return used << cma->order_per_bit;
> +}
> +
>   static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>   				unsigned long count, unsigned int align,
>   				struct page **pagep, gfp_t gfp)
> @@ -858,8 +869,8 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>   	if (!cma || !cma->count)
>   		return page;
>   
> -	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
> -		(void *)cma, cma->name, count, align);
> +	pr_debug("%s(cma %p, name: %s, total pages: %lu, used pages: %lu, request pages: %lu, align %d)\n",
> +		__func__, (void *)cma, cma->name, cma->count, cma_get_used_pages(cma), count, align);

		^ one space missing for proper indentation.

But doing another spinlock cycle just for debugging purposes? That does 
not feel right, sorry.

-- 
Cheers

David / dhildenb


