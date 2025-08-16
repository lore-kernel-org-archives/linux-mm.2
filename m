Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420FCCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB64900256; Sat, 16 Aug 2025 02:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BCB8E000B; Sat, 16 Aug 2025 02:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A87900256; Sat, 16 Aug 2025 02:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9619F8E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:29:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6212AB8FA2
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:29:47 +0000 (UTC)
X-FDA: 83781644814.14.6AD1760
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 47E8940008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:29:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PVHDgdWq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755325785; a=rsa-sha256;
	cv=none;
	b=JCryia8rcnvACKQDjJ5DeTG7l+XsVPzLkbTwps9yPXogQeKJhj+9AM2R8kEAj7lY+005kW
	aNp+j/YnAZc2DPZCYIT0cdO1iMB76PxInJ46jhEoQ3RxFjtLteFHeNsjPOWPcVbL3gdnQ2
	aySuoj/FsRPpk6d+jtIpuvA3mMi671U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PVHDgdWq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755325785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoA6fOTFrfdqKU1348k7QENmJ9d26UvCg8a8Yb5qig0=;
	b=bOtfoZRZD6XyT77F1jaKK9zZ1twzQkb1z9w8Rj01Ymn0Ilue/cuTKvgjUseAodmvVBaVf2
	A1757mk1+nWCwSthD7/rh9+3NaNEPHNHtCMwyiQ/2t3iO4Pyyhe4x2ydg9/lQj5BgY5otI
	ytM/7++tfdBTfuW2dSixFKln8vNqGFo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755325784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DoA6fOTFrfdqKU1348k7QENmJ9d26UvCg8a8Yb5qig0=;
	b=PVHDgdWqb8p8R6X4kf9lF/33t4rzvFJaG7DaNsy8x74337oeOGudAUkDEAP8Y94CbYdux1
	N6oeRsb0xxzaf9ap5QfSfFwef6IXkY3XZ7Z0ARH/9rWYiQeQMt9XKHKXowhI4e6jPJ/LLl
	FmSnqldU3aFcO0s3fmnDx7jzIjXyuTw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-_c5mW9nnNlmfhuR_RrnC4A-1; Sat, 16 Aug 2025 02:29:43 -0400
X-MC-Unique: _c5mW9nnNlmfhuR_RrnC4A-1
X-Mimecast-MFC-AGG-ID: _c5mW9nnNlmfhuR_RrnC4A_1755325782
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9edf34ad0so1655494f8f.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755325782; x=1755930582;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DoA6fOTFrfdqKU1348k7QENmJ9d26UvCg8a8Yb5qig0=;
        b=dbCJR/wno7F8tq8TQjTW5KDSCphiI45jCFNiEVhlezQO15jBg0M2igOWUj2kjBJ5Bt
         j17nBxuDe6S8t3ichKPZVkc99+nu5az9pMoR1xhW11hnVGZY5MDgxgXMLlNcQuLqoKtx
         V+q6QjZ7YCGePyDv1PAw80xz04TgdQsE67LYDiG+iss8PoAADH8Ym3NRFckkeXLwVEeV
         cw2gTJm+F6gCxgRyFyVFL6Oxcg++puM6FOB4fStxcLEzG7eCbasEQ2H1Ty0CH3agpu0P
         jt1UTYQMo+iMYMXWHvIAdEsiDlNN1I6qdaUSdKLlT7Albv9lVlJyP/SKnoxbm1csOW/Y
         kkRA==
X-Gm-Message-State: AOJu0YyZM/OyThUm221dO4J5R+ATAbOfTQao17joZoiGHnw0o6A2nzHX
	yTRu5Mg9Hyp0r7sEQwBiRjHK9j8Z5lsccHofYmJOdDTmPuloeIUmEPANER9L2CI6lD5/BOD6/3j
	xwZYfHJJbJ47XZ5qE8wCM2p+EEub8kmSm7fipgI68mFWoGPaomR29
X-Gm-Gg: ASbGnct0+ICG2i+OnJQ3UVLW2sCYB1WA9ZDiN7jvsiOPjjJQYSAuwI9Ovb3ybAab4Ou
	QAeTIKAtj8LkJl9Qp6ywbqXNTTeBcxAVpOYFKpD+YtNNr7wwFBnPPsqWGtMO8xk0KnWAGNil3dW
	ALH4ehx9S4GOSoWS+jwGAxVBnc0K0L7tL8cCCeWfZ1Ho+9sgtqwaI/lP73+frr9y4pTF1w1HlRm
	jwhzAhT/YmtoylbSnBoUkz8ZtXp1g/6fqEfdeRfK11ZaT16fIOlZCGLFJk7rHSU0EHAnUEGsG9n
	lNQQR0vjlK8h/Y0w+lAPi5nnKL4qe2BcIRFgsSlpZpTlucUTR9VYUG4gkUG2ItW8QjwdIbmc9hz
	CVGAbhTToyCOcK1IRATA2mJUVC0V9K5eu/QliNT4x+m/ArYVFx8UXCZvxmguhjspYfN0=
X-Received: by 2002:a05:6000:2c11:b0:3b7:9d83:5104 with SMTP id ffacd0b85a97d-3bb69c717eemr3876069f8f.51.1755325781898;
        Fri, 15 Aug 2025 23:29:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKJ186/sz1lSR/RJ2HYX24FML9Gt9C5jORadiNAW1ArmUFhniIT/GF8vIzvHlJ38rB1gVVvw==
X-Received: by 2002:a05:6000:2c11:b0:3b7:9d83:5104 with SMTP id ffacd0b85a97d-3bb69c717eemr3876054f8f.51.1755325781515;
        Fri, 15 Aug 2025 23:29:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64d33340sm4596023f8f.21.2025.08.15.23.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:29:40 -0700 (PDT)
Message-ID: <601ff999-6a3d-4010-b316-6b4b294b5417@redhat.com>
Date: Sat, 16 Aug 2025 08:29:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, harry.yoo@oracle.com
Cc: linux-mm@kvack.org
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-2-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815084943.23063-2-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gIS2DlteOxm1v-zcQ_968Fb7uG94wnQHzLEkg9vMJes_1755325782
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 47E8940008
X-Stat-Signature: dkumqhbmmi19ej9z8os6n4gtzsgqdo1o
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755325785-372770
X-HE-Meta: U2FsdGVkX19i5xn5C5LmVxvXGKh2M5Qa+b75LT9USnUqcLH9yofqDKr9Z2Z1YUU2fB/OO5kMIrdWYXLuzg0tpHKltWbovIN/I6nMbWSPmhM9GfxjeTJSN+axEP3mymAib3iF9kjocYVvYpafDI6rgk6c99YgVzaKGQZL8ew0oV1WmaCQtYWy4qtVjipji1JVwxEIziJfadoJc0+GCJWCmEMj9JpYpaZAE8L76LKyFYkcmE74qtwb1cwCwLsWG9p0DoWijhjzxWaLefDIyFz4LGAYSIQLPBvku7bcSmQJjhoD20aaGLYgLKLn8KWlBK9j+oK1b2VwfRrRBEtqg20BlZKXI8A+TqXbOJM31+C5gw0ROIUtG2sQ5BWw27vlfQkv9Cvj8lN8qiALrx79RjzlnhCW9qJfBR/uRYphRyKX+zpIaKfgD6xKIzDiupP62PRl616NI05Uc6tXLnJw+NN0uWfB3t+S4qhL1S2e5FAXIFMvNWNWkMPxBvWb/P+yhxIo4kIxLAAuj74rX3QmFwWJkLji73b9xHMGKtg/NberWYe2hlwxIjuxE5Tdl0TtnXZO5MH+QkHHqjZVkYhsfmtONyIl1aiZX8CRR6QKO7BjJpl4srkYmKaTDlZObKQ7Pup6OJXYPMBeuykt6Ci6FFK3V77vTn3Cbbk2DgvxJZjtgDxGmtqljvCbVJBIGaIeWpV2RxDUGmBE4dx4uM1GpBBatCfbKMhQls4fc0uFRUs4R+DS/HO3EyOxHzdRhc2zSKzYDGPUiQzzVZ6TzOyEHJQDwBBynEq8jIWbRUAWN/I1TZE2/0xpKzX/phcelKx719usIYLADDUbHb9k2Vq/7ThpV0nVb7L8twVty+4yWQ/W3Gjqp8F4gPCyE/FprnyJing3qKzRuUesRdYbDaSlBtQuRLjl0Nu1hW3qj4cATevw4d01bgLnlL0anJWceL/RAZ60XeIoZfCTNgtu+pKeXb6
 yCfR4oz9
 3Eu/mehHuhXiq6f2L7Ezm2TBJSnrP+UnpCB6p3nTYDz7f7OsAAplhZ+7uqbfwiZaJY8DUZ2oUBKigCu38aFEF4/cer2bZke1kvuAu1zmAObAlv9LqxH2w7SKckJhjOHoE5S+9sfohtI7iJqRm4YNDiaxYBxQ0pwdonxjy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 10:49, Wei Yang wrote:
> At this point, we are sure (nr < ENTIRELY_MAPPED). This means the upper
> bits are already cleared.
> 
> Not necessary to mask off it.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> ---
>   mm/rmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c5988dbd1e7..a927437a56c2 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1749,7 +1749,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>   				nr_pages = folio_large_nr_pages(folio);
>   				if (level == PGTABLE_LEVEL_PMD)
>   					nr_pmdmapped = nr_pages;
> -				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
> +				nr = nr_pages - nr;
>   				/* Raced ahead of another remove and an add? */
>   				if (unlikely(nr < 0))
>   					nr = 0;

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


