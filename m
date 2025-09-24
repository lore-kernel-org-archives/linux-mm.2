Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93BD5CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF688E0008; Wed, 24 Sep 2025 14:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E8C8E0001; Wed, 24 Sep 2025 14:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93FF8E0008; Wed, 24 Sep 2025 14:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA80C8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:15:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8846C1A0104
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:15:58 +0000 (UTC)
X-FDA: 83924947596.01.B2DC1AF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2AF392000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:15:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d4NG1V3j;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758737756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5GCmu/y4XizTk8YGFlDNXswrxzNbODJ9T4sLwRMNCY=;
	b=ZHZ0FVwDaS3cnx1dWpF+rqptTsjFsMsWIbbUAHgJOgJQrFd3zu1QZvN5lucngBvRlV8UAZ
	v6CRiT8/Yr9uidu+d+/paw7+T8157YMT1hIzRumgYdglwVFGO0nBnPn27tLSni6gsBTqem
	9/4Jrs4DAdHcQgdRYa1ezqhcsZO4p7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758737756; a=rsa-sha256;
	cv=none;
	b=lyUokVm/vpc510ScJqhkWhE/tAwnGY0ovUAmRjpopHldarSXbvu8YtJqTwkuxWxQVHzlOd
	1pEVDqpuhHah67lahoRJQLHR2zOEIHjrOZsCsYBtamYJQvUe8whXYXlscOtwdUDDjfsWJx
	lv91xNhrCyW3xZzOkSqwukGWf3D14WE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d4NG1V3j;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758737755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D5GCmu/y4XizTk8YGFlDNXswrxzNbODJ9T4sLwRMNCY=;
	b=d4NG1V3jFD6LorDJGfK0jOblZsBq3aD8RBswyjbsIyZXxaV8UMp1SVd2juhQtvLpNlG613
	HE+YqmBdAgYtkUX6EBzTb1dSWPorr9gE065Lpb94Dw2BwcLU9ISs5ea+jMF5VeTOdHgDEq
	XifkBY7bIdwLfvJ3XI2AiuB6A70ZXv0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-SqidgB-uNK6PZZPmGFUnWg-1; Wed, 24 Sep 2025 14:15:54 -0400
X-MC-Unique: SqidgB-uNK6PZZPmGFUnWg-1
X-Mimecast-MFC-AGG-ID: SqidgB-uNK6PZZPmGFUnWg_1758737753
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ece14b9231so142735f8f.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:15:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758737753; x=1759342553;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5GCmu/y4XizTk8YGFlDNXswrxzNbODJ9T4sLwRMNCY=;
        b=kYxaZVEOYGnzf1mVf7n+S/ImLpyjrNT/EkTCLeEioOS3oMPimGeijrWWdr5/phFF8m
         tYSqyqJdA2jMON0B1Kma61hFmgWzXEfqBwvUEFwX6vEj3/iAbPPBmFHnYZW6mjye44Nm
         EqQEFB+KPsBtL2UI9nDz+kTvyYHMC5DtvGtkL+Zp4FX6edbauX7fpdwvxY0hu00yyAA/
         QQRBb6vLgBn5mQT8odBO18WGg+Pbhh5wq/vrQOEnN0ZTxtqVZeKG5Gg8GhItL5p+Gc1V
         ecXOLlDIaYlle+260xTxdAdaCHDcBi4nH1MEmljWo2+U+CEYTp8JlOqJSET9LDKOiJUd
         uFwA==
X-Gm-Message-State: AOJu0YzkGdgzbVeoG0dfvTkAKwqT082g7lT7LcMxjv2Al5K55waWBQtE
	gSvDBz77RPt/P01xjnGJQcGiDqoP1ksuHPLji/8Dqv3dn4bGKoUvp9fwY0AprbMLixYjEni4tja
	wsycezqhB8XWtFrusutbMIoVHrrS3qqJhIuj2m49wXfn7DMxoLFYJ
X-Gm-Gg: ASbGncvWtA1uujLWd78H6ui7k7T/FO0PfNPIP6zaC5tYIH54b7z3LcbUj9gqNtTxfd7
	Ef/bDWf1ehQ3H8KY+4rCo8qhsct67EfrMdxFisUmmqE93dIj7NoLEu+iq5Wtl+ccBdK8BhLuh+D
	+UzMAzpdVFPyIE1q8SIlts76iu1rdm4sDmi+Tssehyz98k+bRxlMafp4mAxalWUex5KQZOFAuAZ
	a7YZCmjtWz0B6+kLsk+rudYsuvUnevCTsJ/tDyKwTBltzuGGMlL3C7q8LEMLo4YUyQ3pjM/DiWi
	cfSQt9pgU59es73kg5s/KfIbNDwyWu3nNgeaRLHCmwhvO1WvRX7EN4zXY16n6Yge+nQOzGRh
X-Received: by 2002:a05:6000:2284:b0:3ec:b384:322b with SMTP id ffacd0b85a97d-40e4ff19bebmr824916f8f.46.1758737752858;
        Wed, 24 Sep 2025 11:15:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMZdDp+BFhDVtrTjfLVZ6x4IdbV8pP5igjFYnLDvyjxlGAktmd1iZfdHRlX9DtqxmZchD6BQ==
X-Received: by 2002:a05:6000:2284:b0:3ec:b384:322b with SMTP id ffacd0b85a97d-40e4ff19bebmr824888f8f.46.1758737752403;
        Wed, 24 Sep 2025 11:15:52 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a5c4.dip0.t-ipconnect.de. [87.161.165.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7460sm29256281f8f.31.2025.09.24.11.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 11:15:51 -0700 (PDT)
Message-ID: <ec4070bf-f1de-450f-8b8a-2f130226b9da@redhat.com>
Date: Wed, 24 Sep 2025 20:15:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: swap: check for stable address space before
 operating on the VMA
To: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, shikemeng@huaweicloud.com, kasong@tencent.com,
 nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
 zhangpeng.00@bytedance.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250924181138.1762750-1-charan.kalla@oss.qualcomm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924181138.1762750-1-charan.kalla@oss.qualcomm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: esHXK49lcd4tURY3PFMdHDwchuVBe8PSt-T1o3VKlv0_1758737753
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 56fi3fbokn4ypti7kg8q53b5yadwagmk
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AF392000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1758737756-731140
X-HE-Meta: U2FsdGVkX1/LuSpWJEak+Yzx2cV16faONyC+ry+LbBva6NiBx5xJPZzBtHK71d0sBa5C+KqekPkDXEpgq0dWP8rKW8Z09IXWy/781eVnkX9auGviGIY3rFWbE8brVrBa3uHWHJNiUXolfe1XrnXtAF6LukLTLYXYMEKeVqVnbeGGT77OtYRC1f3wY9Tv4MErAZIdml4b8gBhP8s++vhHN6js/3gYfitBgqZB3CnPez/2SrU8vopyziczCH5iy9qOa/qOTWRHH9RX6nk8RsP7jjp3NwHHZUHHWXS3MgJ2bzFmV1RK2Q66hilhqzPioV38kkMeOZofh4AMkvYt4beByBBzjQWbzXjUH1J+qlcXFI4VO17E25kW5rCROYqIu/I4G6132mp8pRXHNlOXclfHWBbz+haR62ucqCjbAlwyootJyJ9UtPhugAme/J9Hufmt9rwY66gNizfR/oTEZHOAzpfv2wnYQGoBKTOhVXkEmZa0kKT6d4DaovF1/7KeUnWVSdDEjl8H9TVF6iPJiaaF494NjPj1ncMrDAyVYoOnkIwFk2bncogiQt9pUy2p14ViuYi65cOQu22/r7rKVfcMub5xJZAOUI+/F5XS2d3LaYghgQREkMDAukLdwHA1gtLZ0EhsXKOmZ7toSz3QSf2XKfZtTJuSAsczAJducgKG7oQ/OVrQM8emUZBSZSWijKIPbWxWK7HesxgV4f12KpjG1z9thy43+P/klOYa/lhwJhMfY9dBEg3ck+TkyMNmYPDw8Ey51bBJoQ4A3f4/pfgHLO29QKb2TGr7DRKLllddTFCPixYFllNYBmTN5wAsyrOcCQWzz3EahEmvUko/+tuu1je5BkDj+BdbjbGfobNtEmT27viDqKv0LYtjMnODNaGEtWmMg0YtZRO+sK79H9geUUfsDSSkPdKTOTvJBM9yYhY6Tc7hayoEGA0WuGY9k2/net7u/fltWAyNygqwLs5
 FiPSPqn1
 VsCFoMvwAVrEe4CtJr8QKpDNCK8XieRD8pLNGl4uQynUyuIJJEXtBheo1SkCOkzGL5D9LT4sdH44NiRW8GHQPIBONKObCUQwk3alWfJlVsiGvOUA//8arBDxRA5cFBNleFsK2ggC4nsk+PK4D4+2o0Ohna8zhKC6pjsI/v09CI8+fLUreRAEeO4zjpNPTa4QISe3JaEok9wYkqh+ES8uCkVKgdaHR7u/6Dhh/Zg8v2NYcEP2K4jYr3M+lYCJuePoAI3JSWy+NhxGqkL/5lxALtcV66Vi7f5KxXaDE/X9njk1LODqBL6A82cMXzaDObDnEWul2yk1IJH8LH29ToIfV8uSYP0UmWSJLwDW1hFkoFPKgk+WtQhsL0fPwaoIA7zJ/JObsZo933R0w6tN5kjbJ3UWWKcoj2xGogrIy6e1CAUCOuIQaRuQgR81wXJ5UUMHDrQx6+KuTBvStMsbWmYu0/J1UVVcZaeqd5eSKX+/hVfeXQZxB1y3SFr8+ZiAxkyQfZ77OJS0Fkkg5DdUiAxEN6jVwOWdEF21RC6ucrIRXnp+U7rgprWGPc4nWyZvv+4JmkGHayW4zDlbv5c1vAC/QYB57m8ZYR9TiOTHT7xeVLgyhBpDCB5jy38/gHBfMANnaXuDk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 20:11, Charan Teja Kalla wrote:
> It is possible to hit a zero entry while traversing the vmas in
> unuse_mm() called from swapoff path and accessing it causes the
> OOPS:
> 
> Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000446--> Loading the memory from offset 0x40 on the
> XA_ZERO_ENTRY as address.
> Mem abort info:
>    ESR = 0x0000000096000005
>    EC = 0x25: DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>    FSC = 0x05: level 1 translation fault
> 
> The issue is manifested from the below race between the fork() on a
> process and swapoff:
> fork(dup_mmap())			swapoff(unuse_mm)
> ---------------                         -----------------
> 1) Identical mtree is built using
>     __mt_dup().
> 
> 2) copy_pte_range()-->
> 	copy_nonpresent_pte():
>         The dst mm is added into the
>      mmlist to be visible to the
>      swapoff operation.
> 
> 3) Fatal signal is sent to the parent
> process(which is the current during the
> fork) thus skip the duplication of the
> vmas and mark the vma range with
> XA_ZERO_ENTRY as a marker for this process
> that helps during exit_mmap().
> 
> 				     4) swapoff is tried on the
> 					'mm' added to the 'mmlist' as
> 					part of the 2.
> 
> 				     5) unuse_mm(), that iterates
> 					through the vma's of this 'mm'
> 					will hit the non-NULL zero entry
> 					and operating on this zero entry
> 					as a vma is resulting into the
> 					oops.
> 
> The proper fix would be around not exposing this partially-valid tree to
> others when droping the mmap lock, which is being solved with [1]. A
> simpler solution would be checking for MMF_UNSTABLE, as it is set if
> mm_struct is not fully initialized in dup_mmap().
> 
> Thanks to Liam/Lorenzo/David for all the suggestions in fixing this
> issue.
> 
> [1] https://lore.kernel.org/all/20250815191031.3769540-1-Liam.Howlett@oracle.com/
> 
> Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>

I assume we want to CC stable?

> ---
> 
> V1:
>     -- Checking for xa_zero_entry() instead of most cleaner way of
> checking for MMF_UNSTABLE
>     -- https://lore.kernel.org/linux-mm/20250808092156.1918973-1-quic_charante@quicinc.com/
> 
>   mm/swapfile.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 890b410d77b6..10760240a3a2 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2389,6 +2389,8 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
>   	VMA_ITERATOR(vmi, mm, 0);
>   
>   	mmap_read_lock(mm);
> +	if (check_stable_address_space(mm))
> +		goto unlock;
>   	for_each_vma(vmi, vma) {
>   		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
>   			ret = unuse_vma(vma, type);
> @@ -2398,6 +2400,7 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
>   
>   		cond_resched();
>   	}
> +unlock:
>   	mmap_read_unlock(mm);
>   	return ret;
>   }

Yeah, this should do until Liam's rework is in.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


