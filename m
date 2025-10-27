Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147ECCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5898B8008D; Mon, 27 Oct 2025 15:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561908000A; Mon, 27 Oct 2025 15:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA178008D; Mon, 27 Oct 2025 15:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4718000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:41:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCFED1DFF0C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:41:11 +0000 (UTC)
X-FDA: 84044912742.26.62A44EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 75AB410000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:41:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ObbzPktV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761594069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQQG1U8D9NRn8/WCZbwr1i1w57XgvAobXv1AZVxyG1w=;
	b=Kkj10tE9n534NhcsHVPN6K0iU0VL9xUr/pr/knYHzOlLZ4NQ0FReeJWSLulIxZ0B+AyYYq
	jd8jSyThSpzCzMlJ1KOjPY7FDFqUugCIGFfbbXdMGywS7APUqVD+AO54VEhBozZGKwO8gO
	q/lvWIikh5bNAyCRQcAP5tB8qCWk1GU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761594069; a=rsa-sha256;
	cv=none;
	b=wvE9S1ox22OnsOhsqG+Okt/ibUYIPC7OiChrhyifw9D9Q0EQ9m/xZn6tvqDYfUQIa6CIkq
	ug7bYmUBk1MEnUYTJPlE+1vYdkdnXQ9Oai8jPgQr8D2s3qWh31NzH4ItWQm8A0jcTYX5j6
	pW7g4DlgIh6qISYWREscVCcafy6iaJE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ObbzPktV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761594068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sQQG1U8D9NRn8/WCZbwr1i1w57XgvAobXv1AZVxyG1w=;
	b=ObbzPktVhSpWktFEoP4HdEL8VbYQ/oZ0cNCdQo79YXp2HgogbrENSIwgCytFd8kI5VYoic
	HEr105HoV3wmlEx4oIv/a4lxS+/iiTXQNSMortinPDiKYvGOB3V8M0gMLOCbGJrAwKWwv1
	dYkXmHJzVnz3Vo6LjAEW1Q5jd9M7X9o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-uIMxEJmLNFmYowyhjanN_w-1; Mon, 27 Oct 2025 15:41:07 -0400
X-MC-Unique: uIMxEJmLNFmYowyhjanN_w-1
X-Mimecast-MFC-AGG-ID: uIMxEJmLNFmYowyhjanN_w_1761594066
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-428566218c6so2313977f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761594066; x=1762198866;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sQQG1U8D9NRn8/WCZbwr1i1w57XgvAobXv1AZVxyG1w=;
        b=W0Be/BSoOsfg49vZD7hFX++KKaNuHBtMgFu4yAp9fY5tN0rsVnL9+8duNn27rLODHy
         mqK5txXbK3lzRTYc8yrFz9MbyKgZBI2ndi1sd5NuRQpIun7t3aSpGI6F8QUbmRPuqT21
         krXzlLvOnuoFrJURdBqiMFp7vbEV6dX47hFVRuoERqIjcgKgQ6HVg8pJNbYTQtMJpCeJ
         cGo+GkN44gi0g7YTo5Hh+/UiZ6QyVpaFdw6srKsY67Yi8FFxdJS5tbm03rjWUbTkSvBw
         VpWypZ3oLPqDyeHEwmQtEshFTb9fM/3ZitcbI8OirLOFGuEn4b5MpPckJo9msYOshXGv
         NZBQ==
X-Gm-Message-State: AOJu0YyAYleFzrDVvN1dLmVfiB0A1Ia9odTzVjTkPsVyklsdkxDlRFF8
	S608Exw6Sa3n7loY+nu6QpvDGIIgOUZ51EsDsvVe24Qz1s/JfiCkCZ4wm4xlrn9mrX/fgRuAW8d
	EjKzhCki7+htTae4RNz+YvQfxTA3MBpIgyUcS2aAQGP09T0QO8M0e
X-Gm-Gg: ASbGnctqyerhM7mNXIxg6wmwnHCyezFqxV0GTUiWQRJyZyzCCNpUHAmLUWfnDXOOZ1E
	PaU7JzneW4+L1hECTBndhfrkhpIF6tC+GRUOtxatH2EWfpwXImZ6/jYvLRaolfsnBXB0B4VR3xi
	0yVYTh9pnlff3jRT2aAzQ186NKkTLFkToBcI7bNlFZGvUBM3qUDFG7X4Ddq6MGS7rTiaMQfd6aQ
	ti6LrbvUENnHKCFyEHTGZhFR4TAoT5wGD/qRINpgJipcFTEP+1tLN/iz4UDLX6g9eJGvrtij+Cx
	pZroZvf2rMijN0Le1KFhNcMMSF4nU7mnyU/x+lGA30DuDrxwrjAb+XNIRKvnQt2EEZZtlE8P+Oe
	lbP40cSCmv0Bidwakq1AsQNYOCVvKBVjFDtaK3H3/BCecMJVfgViwSwOzAB7r8xxVrA1KFRGcFb
	KiDx36nShTwNkZZQc6FtfMW7+3vv4=
X-Received: by 2002:a05:6000:1789:b0:428:1dca:ffdc with SMTP id ffacd0b85a97d-429a7e82d3emr835400f8f.47.1761594066250;
        Mon, 27 Oct 2025 12:41:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVV7ZikNBr8078iLXAz6FTXXQLRURl8SrPF+kjxb0I+lt95sxQQlqW53H9ifqttFJc1n2uNg==
X-Received: by 2002:a05:6000:1789:b0:428:1dca:ffdc with SMTP id ffacd0b85a97d-429a7e82d3emr835372f8f.47.1761594065760;
        Mon, 27 Oct 2025 12:41:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952db9d1sm15723309f8f.35.2025.10.27.12.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 12:41:05 -0700 (PDT)
Message-ID: <13945f06-f862-4f80-904a-f2a4ccff3e4b@redhat.com>
Date: Mon, 27 Oct 2025 20:41:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] mm/mremap: Use can_pte_batch_count() instead of
 folio_pte_batch() for pte batch
To: Zhang Qilong <zhangqilong3@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jannh@google.com,
 pfalcato@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20251027140315.907864-1-zhangqilong3@huawei.com>
 <20251027140315.907864-4-zhangqilong3@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251027140315.907864-4-zhangqilong3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UaxirqylAwzdj1k6_Yb8x5aC2NDE7e9-aZtJGjt5ZfE_1761594066
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: m94mjzdtzrrozidcszufju78sssg9ktw
X-Rspam-User: 
X-Rspamd-Queue-Id: 75AB410000F
X-HE-Tag: 1761594069-374674
X-HE-Meta: U2FsdGVkX198XG55kxAutLLJlcSpSC8baBmMvUEgMnFzADY3usqPvOJmby1dt31swZ99H4L98FifQYg4B8NgwxMKomYKSheqAGkUiaDdhsp1XfAAJQTh1aXz9VnHEnezKZtxHL6Rz3jtC+O3lZBxE9yVAphYnErLx49dUHhfalJcO8eNK2DucC7SYIeeXWMTH+q0kdHj9NVEljba+ZmH6MP6NtNke10sn6qkaDYWGD50gL+2ZpNJ8ZjKlmswLjsCksVuEdo4f+zcpm5/y5uxWyZjYlntYJrPY57ny15BIIoiPDnXL0f//lKMmzhZ9ifFFskaGASvCJFG58JrC/MsF/n7Far9Twww5SNPIyHuqy2vzqAq4N6ovq/xhutE/EU6kI58bHiUpP3CiWrHyXgtYtQI7N8PuIfLeFpKIv/A9jB9voGRvG9o4n8zxjvqeWmxTNd+PwW8yQOzCat/26jpOREzSBNLIoqgRDUWpUJbWoXer6JNCYy4r3LVttpFEEYMwsvDcotZqgXC0Cv/gvpuUI2T7t6eVQX5RmsDDsbp8b7Y1jCfY/KTbNA2kKrZUr303AQZklAPuH8J7hAKQ1INenxyMKW5gDK8251U4BPe8Uff7rM5XBexDhRriZwC3jlyo6JgOHkCBF6/M5siQgA7f2ZX7CdpEzOSIDtMRwLBHENcNhJsspDi1KcOMWXqt2uGN8y53gEwkhDDThlNQ2Xmez0KVzDlwuDi/suhkXcdfqi3UwmvsLu1chTOb+fhRs2DapRlQio3Cdnx7Z+PuElVBCL5ZGMVjgnyK4OXuwa7Go/j+u+Fs9NO2wx/VjrPzpqo351Mgrjzp1Y61nVnGZ+Lii0MDiUZv1296euYbBh2j8L74M2l2qoIr6xB9YicOSntRBLWJTbyzRMQ66KF+ND6b1ZsPufHj1aEnHjGjHey1cTs8corzhTHYBiIB/td1IEMN3UR8V6S++RXgriHVm8
 iyv87+s7
 Lzgt6XELqWdD+uO9OWVXgK790zrVgHqkuHH7UWQMIAWXIx5hixGwTtQmyG7jVQaw2Ti1/HBbPbn+BYjAAoYHlaJNNrAcGq8dz9cvch/VmM4MyV3RJomgJ9l2XLHTvHObNmSs8jHLWFBZ6O9vLUD5Z6x1sAu9Ne9jyNu0Lw0P/RuCMF+hPg9Oef5Eu9AjhFbxe47MmoIwl+V7ZDFA+4cdW0hA9D98fdkqzLPNT9kiUdt4SdbKg0kXMJWcAp9dGYz8onY/2rt9gJVkrMGgKLY9QUrnUepetdPYU1vcl8LBM0AMN8+eqcZoOtWSa1MN32dC7oZnJOI3eTzXD80LP8Ysui/oBD7OJWc+ByjDBOdVJuXxrQ6kDFl7nCuJxpoBB95ldGPr2aJV1fGh48g3gXQEpnDxsti4wF0NoV9BY9flJ11j7ZQbsmPi7+15GczL88beobgV2bywRvcnbdCrCSeGk/lMPrR2bJfBnge4VqBSi4Ymhgo671B9Z+Bv8ymvbQIfbGv8PcqiXp6QWzTdvLTB5Ll4St/x6NH3euN56cVhnB0yTqHKWj7KneU/Isex9q7jtJPdQ2amxqOTt4jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 15:03, Zhang Qilong wrote:
> In current mremap_folio_pte_batch(), 1) pte_batch_hint() always
> return one pte in non-ARM64 machine, it is not efficient. 2) Next,
> it need to acquire a folio to call the folio_pte_batch().
> 
> Due to new added can_pte_batch_count(), we just call it instead of
> folio_pte_batch(). And then rename mremap_folio_pte_batch() to
> mremap_pte_batch().
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>   mm/mremap.c | 16 +++-------------
>   1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index bd7314898ec5..d11f93f1622f 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -169,27 +169,17 @@ static pte_t move_soft_dirty_pte(pte_t pte)
>   		pte = pte_swp_mksoft_dirty(pte);
>   #endif
>   	return pte;
>   }
>   
> -static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
> +static int mremap_pte_batch(struct vm_area_struct *vma, unsigned long addr,
>   		pte_t *ptep, pte_t pte, int max_nr)
>   {
> -	struct folio *folio;
> -
>   	if (max_nr == 1)
>   		return 1;
>   
> -	/* Avoid expensive folio lookup if we stand no chance of benefit. */
> -	if (pte_batch_hint(ptep, pte) == 1)
> -		return 1;
> -
> -	folio = vm_normal_folio(vma, addr, pte);
> -	if (!folio || !folio_test_large(folio))
> -		return 1;
> -
> -	return folio_pte_batch(folio, ptep, pte, max_nr);
> +	return can_pte_batch_count(vma, ptep, &pte, max_nr, 0);
>   }
>   
>   static int move_ptes(struct pagetable_move_control *pmc,
>   		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
>   {
> @@ -278,11 +268,11 @@ static int move_ptes(struct pagetable_move_control *pmc,
>   		 * make sure the physical page stays valid until
>   		 * the TLB entry for the old mapping has been
>   		 * flushed.
>   		 */
>   		if (pte_present(old_pte)) {
> -			nr_ptes = mremap_folio_pte_batch(vma, old_addr, old_ptep,
> +			nr_ptes = mremap_pte_batch(vma, old_addr, old_ptep,
>   							 old_pte, max_nr_ptes);
>   			force_flush = true;
>   		}
>   		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);

get_and_clear_ptes() documents: "Clear present PTEs that map consecutive 
pages of the same folio, collecting dirty/accessed bits."

And as can_pte_batch_count() will merge access/dirty bits, you would 
silently set ptes dirty/accessed that belong to other folios, which 
sounds very wrong.

Staring at the code, I wonder if there is also a problem with the write 
bit, have to dig into that.

-- 
Cheers

David / dhildenb


