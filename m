Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189ACCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734C78E0024; Wed,  8 Oct 2025 10:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5558E0002; Wed,  8 Oct 2025 10:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5862E8E0024; Wed,  8 Oct 2025 10:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43AC98E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:46:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E887111A837
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:46:00 +0000 (UTC)
X-FDA: 83975221680.01.34F9D5B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8C27F1C0013
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:45:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UjcAW4kl;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759934758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+A07q66/cccwhnwsIzXx5gDCck+yVYhuHbHsvPlTLs=;
	b=UxN7Kx0vq+49z+0MWp+6PRQkLqlCaq6FPg0XB0Agco0EEzX8yaTMfOd2EmL5kpMWUw+O3z
	BYIYIxF0Y52Xc7nSAih6hW0rDtrkD6lbOjPFjx/dDtUi8XkcaLmWB3rfsQMdcaEgxRfDUE
	nRfazNlkmjqrcMVlQpShSCPtEM6aKo8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759934758; a=rsa-sha256;
	cv=none;
	b=6CXEW9jGHv8iEnkxXyezxRtRGZrJkmhRTIwPEZ4wxjZIrwkdmZzlAuQ/lfCbiArqr/D2bx
	Yr7UC8jvZJgdrNcIBDeZJw0Z06rcK9k9yP4CwycHgGhb6bYZvUGP1vakIvn6k2h9SQYcIF
	nhGqc70QZ7Fuhacm4bLMOjRprMGuXZ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UjcAW4kl;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759934758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G+A07q66/cccwhnwsIzXx5gDCck+yVYhuHbHsvPlTLs=;
	b=UjcAW4klKAzGgWPYrWfHZsEiUgZMSMBB/dH5T5Vfm2C+2po6IXY3V1pOoF2lv6YW3R0fLS
	qFVbNMpIMYpse2x2oH3edIM2zB/hDuczDz9sDRNVvr0lt05EKIpAHtYoy68deNdnLINbTX
	2OrEmLel6S0WI3cFrcXnbuT8BwcxYSU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-uzfL3HBSOzKP-GYKOrFUjA-1; Wed, 08 Oct 2025 10:45:56 -0400
X-MC-Unique: uzfL3HBSOzKP-GYKOrFUjA-1
X-Mimecast-MFC-AGG-ID: uzfL3HBSOzKP-GYKOrFUjA_1759934755
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ef9218daf5so898f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 07:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759934755; x=1760539555;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+A07q66/cccwhnwsIzXx5gDCck+yVYhuHbHsvPlTLs=;
        b=V4NfoCDL/LtpgKvFedNCpzzidPyWRg4lpWHHSOHx8/8q2fSbdtlZZ869lhVVy51CiD
         xuElau3o/5gvuFGvw1j9KIhPm5Nb2s0EEys76AmxRuIX1M7M9XYbwRy+teR+HbuQqB0v
         S4Zb9fjNScxSQNzTQ7seDCCfjc/kSie/DQ38CidauHVpg46iQayE5nQAo6/OLBM5kR0/
         hNhCnV3s2hCy/UoVgL7yftBC/Qe4L8bVf440o7P1Mgv+2GQizITE2fWb1tblpzWIDN7J
         3PbMtE9Lf98ZttDAi5VkdgZT10YG6HYxYdcg1vXeJ0WSE12IbgQTaOuVuASRRGZ7xYET
         ro3Q==
X-Gm-Message-State: AOJu0Yxd4ep3QIrlmm1UVvuM0A9B27poQMKMtKmVOYnpfKWVuH5VuEzA
	ljbpwRndZ1oijb1FmWFu7MSl2Wm0q0XKp7by0rNAdmVz/aChBLjPmNn17k+6rV0nA4ctlvFK/1P
	xPEFin545bImZQE0bUFSEV2gw6xfsjOMaifJcNNA2mfeZqKN10ZYq
X-Gm-Gg: ASbGncvZNB98bENEi6z2mX+s7Ojcl5k2AjB4vSJKi6/col8HjDoLsQlGrcEI8Cawyq9
	/5ZM45G/7e+3NB6/OfXDCX8vDehFsQjdPGvLbrYqk4/iLlWeWBUN8IwsdY4P04ZJCFRRgUPnLcX
	cmI6rGOx6OLR5vIzgzzgLasTBEegpaFfnrAtzJNz0aR66nZOohoJmzcr5Kivm1qRMy1VCDuNbIP
	dclKRw6GIu8fqIL/lfIpnGjJ9gl7T6c8sVrLfcVZlE5s8v4xNx494Ruo0mrIIRShlqsR3+ibY+t
	SAw6SHTU3mJkjceOwT4Jt8S1H1bzL/uIy5w1nRBgv6zB4byzIU7uBm0rvPEg0GEFs+raqS/sEuY
	bP03WlL8z
X-Received: by 2002:a05:6000:26c2:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-4266e7d917bmr2386641f8f.39.1759934755396;
        Wed, 08 Oct 2025 07:45:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFu8Y57ZrlL5P/DLN6/6Hv7vj7x5P0Q57RIgZN7F2Dlkw36yAEQe10dYxkoiyJJH6PB9qAirw==
X-Received: by 2002:a05:6000:26c2:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-4266e7d917bmr2386625f8f.39.1759934755034;
        Wed, 08 Oct 2025 07:45:55 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9c07a83sm45348105e9.6.2025.10.08.07.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 07:45:54 -0700 (PDT)
Message-ID: <c20a69b5-e8d5-4d9e-9716-1fc413704df6@redhat.com>
Date: Wed, 8 Oct 2025 16:45:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 2/2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org, usamaarif642@gmail.com, willy@infradead.org
References: <20251008095453.18772-1-richard.weiyang@gmail.com>
 <20251008095453.18772-3-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251008095453.18772-3-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IrnoNTRk3DU0_Ztpd09mHRdRDQEwO5J_eluubd0VkHw_1759934755
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 9g1cn9scx31ertqr6jb1pscgpqcz994a
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C27F1C0013
X-HE-Tag: 1759934758-869715
X-HE-Meta: U2FsdGVkX18DOVxoIfDtEhPk+YkhuhdwGKGfQMgHG0Avp1lBQhYqJ589HwgT5U5KqKcfUsVDsObBUO8smWvfb7d+9k/J/guAEJ4gkbPfu68nLEnqg+XXKPrH7lgEaN8Kf9yUOszhz9t/Hw0E/H5HQnD6WCfaghb9KTn1bPsl3CDnFqLsv5kAKWkxcXG1bRnhjPoPpvrxtVCKUJ1DTzu65PKMoX+YPiVPgQost0CobxHvSvcqIt9wn0cT02Yml6c0VGlNOPge+LFu4l+UbINCL4bojz9rX1JNSb++s3NrO3SDR8Ti7JO1jXP4M8axF4v64/CmbwKgb8kmNyiB3j5n6pAQz0muR34oFfEClj1w58E5LKRyJPUVRnUkvEku+AC9awVRmzExS2TBxwMNgYpb99ERdThPpfvTaUMKTZoBHsFTtBSkQ8qpa8n6dbqFiSIZ4Z2YUxTiDBKLBw2/3+gmQvs1RPFYxuQOYydZa86BAHRG8Zu/VJZ9jJb4CV/Epj5tT6jiq/kkoWfYRDUm3AOdQysUpX8V8Q+wnEz6lMtjCzmksU1V430FBKGN5dGajqYW83DrEtXZtVG0/ghFw1GI36d2fH+ztJPUdyF0+Ji/8cQL5cF8IVE0ZcXed1Yse1Hd5IzepQN9iogxmxdPk3lRAUI8IqEUviG6WlIzAcupTvZIVOPC+bdoK5ze69V/Tr6jWg4IL220BU2HdrQcVXc8R9RmVXtKY/8UhZO7xYSG8lbeGq7eucDsAzSWeOoAl6JLW5QdwQxMEURERLGIdWceBQV7YbMfjfFOX+GMPrGpq6vlq0uJ51Z4yt0hQKhxdkS/0rPGkgYFMonLWbQwFhP/Rp24Hc491Bn9y/CKDsvD7LLhjEiJrPoIQsvAfeoIGOXJt7L+Pow1GjLdWDhN8Iqo90PcmQ7/5AexeSxoXVAZuy/Al4TP1wYVaF/Zpj6GNenk+bKnrFdDeDtbyZy0y+S
 gtB/K4uR
 TBIdb2Al7UAcftRNd4GOhoXEvzFR8H86aqo9qAvZwGsGdYL/gOtYPAZJg6LQHHr/dW1upRS9Yp+PFUPz+Q4gxAlGQbOgBzzX47WsqRSmYjmrRUi3VsWkwPcSBIZugPqbIlnIDRMsOF/kLa/H7OIXkQAIZscCejyq4GrYjJf+bOsJ3zRfXrdsibO4bQS2KmdiG8uzgYJPyAHDxF1bHabN4aWZA3mPtiRraLNKZVz8lSosswIwPlIvOfzFscshOUToEUrq1BSpJOWfjTYTIkUa5zoKRd9UluSq1vnkQtt0D3XQEmhRmggDvEPLhDav2nuYLyt6hFqCINcIWUO3yQvsMcRYrmxoVojp8Nj8piBChy+AGEhy+HbH59hZx0IKf4NPYdozP14nRwD4e6pcf8AZZ+ind79zLx+ALw2cOBKqMAWKcnBnaRProw6Ln1Nyqb7SWFFj5gJUF768nfsLi1cJtEHKUfhAdG3wPrGiUhJ0ijWHgUxNeKlIb28Ze2pkbsnd3yeqQQ+2VVBIvV6nSS0Ixl5huJF69jj4g4PlTTtvxNKBCqq1I3OPZcVJuekjkWSwVucppu22TfktaIVHar6p3Pg+WUCfgi9dsP6itUAPbTDrbhZIbcQOTJsfWxwMtEQJX3CCcUt8X5Oj2842JoQlYPdgruc6eTircDABflXGLQ4JTyIH6oLFPwai1YszRhI/2HmFgJnm3q1ATwYgW7ltu0FnLwaTbmnvU7bO8vz0oB41KCphY8YAIkOpmC/2qEv4YOV2sATWwdv2BBww=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 11:54, Wei Yang wrote:
> Currently we install pmd folio with map_anon_folio_pmd() in
> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
> collapse_huge_page(), it is done with identical code except statistics
> adjustment.
> 
> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
> in page fault or not respectively.
> 
> No functional change is intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> 
> ---
> v3:
>    * add static inline and put bracket into separate lines
>    * rebase on latest mm-new
> v2:
>    * split map_anon_folio_pmd_[no]pf() suggested by Matthew
> ---
>   include/linux/huge_mm.h |  7 +++++++
>   mm/huge_memory.c        | 14 ++++++++++----
>   mm/khugepaged.c         |  9 +--------
>   3 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index bb48cb50c0ec..588e3522a1d0 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -542,6 +542,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>   			   pmd_t *pmd, bool freeze);
>   bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>   			   pmd_t *pmdp, struct folio *folio);
> +void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr);
>   
>   #else /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> @@ -633,6 +635,11 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>   	return false;
>   }
>   
> +static inline void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr)
> +{
> +}
> +

Thinking again, maybe you don't even need this stub? Any calling code 
should be guarded by CONFIG_TRANSPARENT_HUGEPAGE.

-- 
Cheers

David / dhildenb


