Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C74CCCF9F6
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9870D8E004C; Wed, 29 Oct 2025 06:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937908E0045; Wed, 29 Oct 2025 06:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF008E004C; Wed, 29 Oct 2025 06:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFD08E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:00:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 129FA49E1C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:00:24 +0000 (UTC)
X-FDA: 84050706768.16.D3BE417
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F0451A000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:00:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bl6nJXM+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEtH/DOi8ufPul8rQIFdoeVO4A7KFJe7+IrA/7Qq9Tk=;
	b=NNdNvX/pVFCSOs44pRulZPVCPNl/2gKQJNPk6NQPdAMCW/4020xhW01lVnEvRIGmiCpwHt
	mfxb6Ev9DSiIhiLdqvmgzRr6dJqlOZcMFJyfGTHe5AqM4LkheLeh0VjKn/VnM40vU0ieDL
	UOrF5k6klKjJSRKVkNJS7YLdobW9Wn0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bl6nJXM+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732021; a=rsa-sha256;
	cv=none;
	b=QPg8LiQg5ENz5OulISt6ztxq10rawiqqe7d3WcC0xN2GHIL3wsVxEWEpwu36XO/TNybStp
	kCdfwZqyln5C8AoofIUn3Epw3m26mcf5hO2mUtzPkynihrm7Ujmtc9F2LGx+LA5C95KfUk
	KSp6Y1RwTOGQnXlPD7YnrgGqijL7dIs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761732020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hEtH/DOi8ufPul8rQIFdoeVO4A7KFJe7+IrA/7Qq9Tk=;
	b=Bl6nJXM+2Bt0zK3cy5OzjYqWxx9/97RvTYbUdHAaFxcYXoV4o6Ln5LpX6TjaNBiYhM7nhs
	ZVfWPsAi1Xpc91lkNLD6aqsyCA1mDYGZ3oEpOXcann4daFp9LX3vTj4Glj0Sk9y+CwpbQx
	CYXuHDaA5RJFdsGhVOGSZbVwlP1EaUI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-hOv2DilUOTyDrO1Pc3Wv7A-1; Wed, 29 Oct 2025 06:00:18 -0400
X-MC-Unique: hOv2DilUOTyDrO1Pc3Wv7A-1
X-Mimecast-MFC-AGG-ID: hOv2DilUOTyDrO1Pc3Wv7A_1761732017
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so83484225e9.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:00:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761732017; x=1762336817;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hEtH/DOi8ufPul8rQIFdoeVO4A7KFJe7+IrA/7Qq9Tk=;
        b=eOTj2be75T+7wmKLe1YOcybrGzdAybilgnomKYSKo8reaG6+rWSwhoAWcLLHGWCzrr
         f4YtJjtCoMk21Lh5IKIjudTVobW+rUsmbzMqDrSX1REDTKyBb/rKFZoM2/myHFeztutG
         oEc1PefICBCP4bZU6EcvK7MetsAlZHncSO79AcHE1n6fDLsOHNgjUhJyLB4ZrEUKZ17J
         rVmTwAXSCPTeeMgQEcHVvVvFhE4W53c19f8Mz7Q9q0lis+TnpsRISD7Agrm3SgCNMKEE
         sj8Ubdo8VWYCY7U6Zo3Lau0OSe0V2P+s6+h9KbkNCNDC+dAOYz8O7DPkIRUvDCZm+azP
         xMtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZzTpg2yeiOBZMP4jXHJUjiSsThV4E3G4AYWVNU7kYRpWYWWb+NBY3T33YbXkw7ome7ForDPum+Q==@kvack.org
X-Gm-Message-State: AOJu0YyckgmXHHu33b69rS0DWuJxL/wgsNh2SLTBvR/n5ToBtPlE4BvG
	PIcDTM5NA9umHbpqCAZwL008Z/AV29i2v+CfLdt/pCmMrLVxttzI+RcLpIe6uSMTuW3I5RLS4L+
	PRBKz4wrDPHPV22lXQw7MkG4FoVYgWVkD2uWLrt02olFJdZP/f002
X-Gm-Gg: ASbGncuFyhLoVjhHcN/NEa3zok8nNi6rrEbgV5uVk0zsDRbRRGKwjbBGjp+Jbqb1ixz
	MJuy20eR/16GOucy7VTKj+pNW63UCrv0uzHjBbE9MXci02onJfcLOwR+6nAR8JGO9VvrsNMS1Eh
	wUsP0S+9JRRL2Rh0VMndjtA65LK94fvvFGTCX+TVLD8djWskQAyZQ5togxsMDVkgcI9jLaiR90F
	9FGtA/SowYMK6Lnab2Ei0Hg5N968biy05CN7xDqXFQkK5zciQuq4jlEc9FymYubUL07BgFwPnTp
	m6FnDsBfzwZooYUWdl2J+41DZ+b67EJ0zQCG2DJLNDrjKZMs4aQ5JJh6WWNz70+Z3+zqlQksSkA
	9aoSySKtbvRby7bOCzXkk7w==
X-Received: by 2002:a05:600d:4398:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-4771e85156emr12759395e9.23.1761732016767;
        Wed, 29 Oct 2025 03:00:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnA3IRpFHhYsZzK6qc9l0qizFN8SkkYYfFwlHAG+3t4PNESgPO0z5ya7ZscSCTji9s1WIskA==
X-Received: by 2002:a05:600d:4398:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-4771e85156emr12758875e9.23.1761732016284;
        Wed, 29 Oct 2025 03:00:16 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771902fa8dsm39879465e9.8.2025.10.29.03.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 03:00:15 -0700 (PDT)
Message-ID: <db143076-afa0-4129-b5b0-eab85ec54aac@redhat.com>
Date: Wed, 29 Oct 2025 11:00:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] KVM: s390: Fix missing present bit for gmap puds
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, akpm@linux-foundation.org
Cc: balbirs@nvidia.com, borntraeger@de.ibm.com, Liam.Howlett@oracle.com,
 airlied@gmail.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, dakr@kernel.org,
 dev.jain@arm.com, dri-devel@lists.freedesktop.org,
 francois.dugast@intel.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
 mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de, rakie.kim@sk.com,
 rcampbell@nvidia.com, ryan.roberts@arm.com, simona@ffwll.ch,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-next@vger.kernel.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com
References: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
 <20251028130150.57379-1-imbrenda@linux.ibm.com>
 <20251028130150.57379-2-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251028130150.57379-2-imbrenda@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ePYaNTTs1E1xlilIIIHU7qNtnc1B7ZrA5kNr38GCa6o_1761732017
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F0451A000A
X-Rspamd-Server: rspam03
X-Stat-Signature: zfm88zuiwmx9h7r5ynr1f3occndg8cua
X-HE-Tag: 1761732021-519218
X-HE-Meta: U2FsdGVkX19zec7RUGvuYAQ2wRqj+d4/G+eSbuIL1FurpKDkm29NZcuQLQ2MitTNJJM93ayRLOLKnJtYKJ8gjYsX3QlMb8cHmJUHTGIyNECK43d/zIJ61LRw+pqnCjXnMKJogMwJ20qceiCX81dvVqs/BCuchN/sjzR/kuPV4uKFRRtWSbwOEo1tezCYerWoXjoWxrlrdwkKUKg+mTloecRK3uHTO7GDqWBMYDCWw/Ydbp6la/6VscAXESzIQ5Wgm+74sm08QnOkgaM92LW90b/ubgbJzNbrhOFrqvO752zKihUhwr2wjRUlh8KypvJCiJqiYgU1ZnSugWnFEw90OETThiHM6ubZMHmrYycHlDWtXE9OGUnCF+JC+liPhQcLuNVz5u8CdFIHHF4yeCihckfQ5R/4FHtny1Z9ka3sbEfH3pkzkYSBxEg1stdv9RM7Vl41z3EslhtqNGinIwwNamx1ZkB3ni2CHw5PwUVH6T0WjMbH4ojUueIJ6SY0ViQPB8dvYawb026Xzzg+XaJPXqDgEV7Ks0i2ZJd2D/Be+YwrAHnNKV9EDmBsHS+Vo5nMhzVGy+l1Zu2IBo8/mnYHPNQZhQmwnwSLdvwKtHAkDzs7DhjO3TzYOlUpf3zIbB4LINnS8TiyNkm+HdZJROiZYUILRnIjyxkzkkynsPzNgHw0eWjFGppNzY748sAFWu/ReDWiEfHBGMQdP7VDVLETbUfRLY5TE2wvh2x2LGbpyrXQ7rN3zIjK/JLNigAINX9EbBRl322+YlLNPPw5I5MtM3KJCYuQS32hABaW258vlIv9w4TDVh7ObnnD7P+b6fvJrKjCmhp6AuPjJLQZrXzaAAnM7XfSyCTnwmLjYn5kRRlZKOeU2x+VO7AEnLpweRh4PRI4+py0pWw7pD/oyqXZl00famz/Q8dmEfu+EYGTkHHItyjhRESxwnbXFOencwtgEmmgPaFWn9VPhBgYdSO
 7OmkUzAw
 z5T/hFh34fq0ZxTnT1V4HToZjtL3/Lx/N5sL+/JGrDeFvQf7HW6Zb+eBBI282gZLlPb5mjqX8MA8ZI2Eqs/i5MXQUUGZNOcyqb5j2LE7bmFfnFx0ESGHeOyuDz++ndcqk1WxQlYKUpzivIPmNHRVhu7PkTauo/o11lvFXelDRsku8xzZKHhmJNSQA8KrGRGl/rIOyp0ymIcARH/to9pDQb2VUHq1YAAEY/am3i2emxyJS8ELdJjc1oTlL6/mKs3voyjhXZb3jZeFnQTThfcWJBYxEtehlyAOP0WF39LoXSYh/Fwam1bjf5u1L8evezCQNbG2s+iHbXN66YRogRNOy4SjzQRH+LfWjmKbU7uJ/RDa6dCefWytvuCvD8Dx9DWvK/4tltZwrVhf1gI1MS+0ZGNMfM7cLieBGzF7nPztKHZgrkaVkwTXS/X/2gAzFTogZ0XW/CS3kmlG5sHk3a4ZhPtzx1LdGHb1nHxAqIeUiaGGN79RqJAIJj5Jc9oD6NMTJxcGVVNxFqFWx7oiCnN54et3I/ESMytwEqcSmMns9X3xc4PIYfwDjhUpfArZ73PcvEL/C6WcNasCHJE1LGgvd6fRQ+g2/X40KsguvMObcaQmGdOo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 14:01, Claudio Imbrenda wrote:
> For hugetlbs, gmap puds have the present bit set. For normal puds
> (which point to ptes), the bit is not set. This is in contrast to the
> normal userspace puds, which always have the bit set for present pmds.
> 
> This causes issues when ___pte_offset_map() is modified to only check
> for the present bit.
> 
> The solution to the problem is simply to always set the present bit for
> present gmap pmds.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Link: https://lore.kernel.org/lkml/20251017144924.10034-1-borntraeger@linux.ibm.com/
> Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   arch/s390/mm/gmap.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 8ff6bba107e8..22c448b32340 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -599,8 +599,9 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
>   					| _SEGMENT_ENTRY_GMAP_UC
>   					| _SEGMENT_ENTRY;
>   			} else
> -				*table = pmd_val(*pmd) &
> -					_SEGMENT_ENTRY_HARDWARE_BITS;

I'd add a comment here like

/* Make sure that pmd_present() will work on these entries. */

> +				*table = (pmd_val(*pmd) &
> +					_SEGMENT_ENTRY_HARDWARE_BITS)
> +					| _SEGMENT_ENTRY;
>   		}
>   	} else if (*table & _SEGMENT_ENTRY_PROTECT &&
>   		   !(pmd_val(*pmd) & _SEGMENT_ENTRY_PROTECT)) {

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


