Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3672ED6AAFE
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 19:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4B06B0005; Thu,  2 Apr 2026 15:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595C86B0089; Thu,  2 Apr 2026 15:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DA76B008A; Thu,  2 Apr 2026 15:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF836B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:33:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B67D11B8B6F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:33:05 +0000 (UTC)
X-FDA: 84614613930.23.059886B
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 33326140012
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:33:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pBQ67VJ4;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775158383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WmaGc9Te9yz0Zibs0J92PxP2axqg3Ucqwb44WM0s3g=;
	b=tnXA1WxKUqxmaeT88PA5xijuPPu6dHkZaQkkX0BXl6CrTTjxd17GkOpYbxNCNiU7zNhlcR
	k8z9rmZisZ+Su10KxDk31iKC5EXZEzjlRJspOUJUe5jvXLOJCvNYIIo7BAE3TB+L+sRmuh
	4Aop1DPECqfRfM1upnV7zxKhCU+8LtI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pBQ67VJ4;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775158383; a=rsa-sha256;
	cv=none;
	b=r9xkmEwWvPDpzkk1ADaAxGW8QcqhiR+7EPrLNARTiXUmZbWu3h8C3uzxQm6V9aLapAr8Zd
	B1uMkUrZIah8uOZU4KMU5iJzo3BDGHyV5SaOilSMXgJuj8t6xj2jdLYuA5l3+GXD3qNUDW
	eOA5TfGIUKQ9O5GIkkhfZJKNhDEXKcI=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632JSl3M408330
	for <linux-mm@kvack.org>; Thu, 2 Apr 2026 15:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=1Wma
	Gc9Te9yz0Zibs0J92PxP2axqg3Ucqwb44WM0s3g=; b=pBQ67VJ46+SO5CMoxNw4
	10vf2BWyi8pCFVjd3/INcGVNa2Rx4KtH2rep92OIs2n1Z89uB2lTfNviu+kbwbPd
	DjAPZzTjPlQJxf6aaLj8+55swS1/gYcctqfhFYgYzhKlR/0crQjLSGCN03sDQss9
	4tZHP4P+wILE7QdbAjcgpe5P/Ff4my0GTEA5qtpp8D85WKZQFROup1Kp2l2MpjiS
	9Yj3nNMZauc2U5s34Um9d9jiL/3yeihYWBvWrqrsZRhGbHQbSjGDG8Q5TIp8ZYZM
	cU3Bx2XRUUejxzakioCYxP6G9EC5W5f3QZfaBWft5Fh55KmbHTKoFuO3cCmIUNz2
	vA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d96kcsx4g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 02 Apr 2026 15:33:01 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8d3bea3aa34so117575585a.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 12:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775158381; x=1775763181;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1WmaGc9Te9yz0Zibs0J92PxP2axqg3Ucqwb44WM0s3g=;
        b=g5uCYG87Cs+Q42ZbTy4+ZrvslC1MFrslI73FEZGdduUpPexvAOa9bS9f8uQWxX+TJy
         AD7gic6xi900IkZTrWnL6et50O5fpd46mIjMfQj8AHlAAjgzf1dIEUYFVf6b+BJjN2wp
         df7yrXHA9WAZRVkOp36oDpM4Eik9TN6Zdlxjyzpwwjk+anRsd3gmfx6QZkj/tyfDTNX7
         Tvj847me/23apGZ3s02FlyetGC2pzx2UBdzLZnsxlG9oeaB/l5WTQbRg2SfJ3ZHkrbrE
         Rytlpuq1p0ab5sC+ctgchCDraZRIhvwJYFoKw51Rs3YNm7ESmdGgPD8N2MwKS6C3G0r6
         8vJg==
X-Forwarded-Encrypted: i=1; AJvYcCWEyTyKF/rD/G8tHX/DlNlloD5xYvtbHUbBT/JnIK+DQm63F+SZGC3TRlHCwHwvkqDrYxZhPakhtw==@kvack.org
X-Gm-Message-State: AOJu0YwBCKg9RsP9HIr/OlDA8nmZsX7SWDbcBBNKv7DbdH5emHhefVB5
	pkfhmi+P6E3gJNkrkJktmpCIf0NzyUUxuw5wDeC7edheO6lFXTUH2klMhEmpyhXth8ocPffjxhM
	7Aog9428G5AlejK4Tr0/PpMgTwe7W+wYoWzjBjKNrrHeSOdNN
X-Gm-Gg: ATEYQzxPp5vOBMv2XkrUxY60TAy1HRHFKCjaBCyvAz7GfqqHPkExDnUsqGfbL+3Yt45
	p2hjqrXsNoHsxwzUCXAnEiUgMhI1TPkt2F14Sy4EGabZg/lOrojDJoHBoDxejJW8kEYD6lSOMVY
	HGA+BXSOE7qG/D2drQYgnojgijLsYWWjqv2y6sl24Lf630mAfuSQuJ1u16xn+Z5TTokE/5qQBff
	lMvxoLAfT6o7FBVfkOJumfwuPVUeOEh7XCEj/Ndj2r1wzPx55HO2tQmx2IwGjBTOC4ZM5H6Fiuu
	RvOEOs6MG3qzyywX7Pc7YkiNcrA265HYwJ+huGIFtmSAbjVz3Y91Poo+BaWTPwBddsCTQaXhxK8
	H35DZ4UADkLlnAxEH+zEO3ClU9o41KTAhy1WQ0mg=
X-Received: by 2002:a05:620a:298b:b0:8cd:9599:b7cb with SMTP id af79cd13be357-8d41c6ac558mr84740285a.25.1775158380997;
        Thu, 02 Apr 2026 12:33:00 -0700 (PDT)
X-Received: by 2002:a05:620a:298b:b0:8cd:9599:b7cb with SMTP id af79cd13be357-8d41c6ac558mr84732685a.25.1775158380358;
        Thu, 02 Apr 2026 12:33:00 -0700 (PDT)
Received: from [10.206.121.101] ([129.236.224.148])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a80680dcsm283333085a.26.2026.04.02.12.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2026 12:32:59 -0700 (PDT)
Message-ID: <6a171abc-ebd2-4ddf-8c36-34c66ca42043@columbia.edu>
Date: Thu, 2 Apr 2026 15:32:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/15] userfaultfd: introduce vm_uffd_ops
To: Mike Rapoport <rppt@kernel.org>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrei Vagin <avagin@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Harry Yoo
 <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
        James Houghton <jthoughton@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Oscar Salvador <osalvador@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260402041156.1377214-1-rppt@kernel.org>
 <20260402041156.1377214-8-rppt@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260402041156.1377214-8-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: cml9qAjYYpqxPTxVJIh2eFRuBUJOHPpr
X-Authority-Analysis: v=2.4 cv=bMMb4f+Z c=1 sm=1 tr=0 ts=69cec46d cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=k+Kg2sH3hDje3YXt6xVjPQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=-OANyN2A5GHSoQQpHzcA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: cml9qAjYYpqxPTxVJIh2eFRuBUJOHPpr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDE3NSBTYWx0ZWRfX+XuqwWOOLwZ9
 13ZmON8+K388uVHD/k1t9SQ+eVPAQ4b2FS5vQosMBVCzAJ8dOP7V3H1PXpDNOPLFU7KzcNf99P+
 iipttJyCZGsK+luYOepiAnxW74raPQGNJ+hOytwaz+zT/oCQERhxGJTBOPL5Qc9QAjQYOxcTHNt
 qUcg74YBPku6ZCXbU2Hnt2DhGOFBxqYjZwECPylHZg3YHmbKMfoGWRsMJBJBr5gaYjNf8JnX49Q
 YMazuxVHczxGhZVMA5tSuNLpSw0B06iIyvfV47gjUpn18GRnui81iGKRWEoDUj+HlO2+DawfqHY
 dXWkkIL96O7JpyPIdpqiCtP5Rxcgx2aj/B8r7s/KSvxX1mFWBe1rhMxVRxkNxgpPV5+j0XyF1F+
 Zzfn69QMgcNK6YJ/j/gz11WwSOvsJCnZmGMzMbpL5zwxIqIKfduJnaFBVkMCQBFK/h9GylvP7ld
 woletlGAyb7xIDQR0LQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11747
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=10
 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=10 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604020175
X-Rspamd-Queue-Id: 33326140012
X-Stat-Signature: g41ajiihcpcchydod1qaygn1npmuej36
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775158383-790181
X-HE-Meta: U2FsdGVkX1+OdtLt2JTAiCxgKHVvJoRdEt9+HShNDaB1LUy3jLRofkZB42P32AHP0mVNDb1NxsruWa+Cz94OARY7yiHGdVfF/IVP3xjMAe/eRvm7/o9wHiJyycf9WM57/LZHrMonwNOfwVaGOOnqf7Kbi7Obm8a3QZ1zyHbMDyX5XK+dvkd3s850r6etGEAZFvHzMHF6l8tAAXucUhiZp9PhkB9QuJKXHaO/XDx0c1zZLMlJrM7BFryWmng1Fpvi89e76gZWT51FwfOrbWhFPNtmbHpuPHQoAq5BQ7O66dFwCgU2XqjZxRWUVbLnojGvvonvR0DEHWOZhOhbCKKzymANjGf89pN8bgSR2ca0X9Jw2Fmi1k2OUY1aG9T3a78uuouJNJVnZfTvAuFxiw3R9x3UTYUMCuR6/vPaw2BO+lBZPcS/YbJJZMyq+Uc9WIzmuKgd5X/Ug9kefPamcIfLUOd3myr4BtU4DIN0YEw8ELmevRBEO5Fs7vSwdzoMV1TyalnnFa3jsRSWG8NAnZlsQkQgEd2QeCU1y+LWKjx9oChzZwT/pXgpi1CnhCxWN2MzwLheZwn0alEbT5l1nB+1BMUWvHqTQVDrXKqlGcjiYORviblJ0kAw0rQ3420uZZWwczG9aw3jIZd6KlT/S5etISPjIrB0tPYauoqxkW3LRrf3Jct5VmZtRxVQROsU+qTTrYR8xydHQCySZyFOfPXppDuZ4DG49SoMgThJaQnpQ3lsiaoGSKm94R+TmsjVkKO+H+HLQ+O7ZGMB7B1DiYSLqIzKMkSfVLvLQju7Ccasgn+8vTbXhrVF5YQqozUqxo7j5JiUVSc7/V3NocM2n8isAB/MZtj6G9w5zT0DR8ewm8oj4BEEIemnLWuuXteIC+CL5Iaq+1oLlX8x61RDZaShAKYiRL10kT4hVdbMYGPkktApFI63ohonEvwagqoS8Ac6/OCigueMY3qiGXogIKv
 H9fdhSW1
 H5i8QLbBBlACWl+1Obleovl0Ha615s7BLm4qDlmKlZes5AHlTRKhvkV+wUnZ9wi6ncGLYH+lZVVLqng9WOGAZcacoLilBwE7AKr8MjFkvyuZaC+B0rxXVasyIdiV8PUKgO/irNdp+SkZ1LTSfkjkeigke1ItiuKQZTNAIL4jf8xeR/L3BrnR7yE7/YCbT1kn5gLwSQ8Wxw35OxgPZO05vhwmAD3lxpSOR/YUREn5r4Q2Z054BIRfHSLl8M3ianXzMaAaQf9Gw/HtqYzjWJazfwK/tVvXH03sLGVly1OJBTC9FGQtUM49I6At1kqAqvwNxCw5g+KOfmYv5ZtLerfEIDCOIuznOoH/cg2V7gD2jxJdjreWxkr+ZZ1ypWfvZ9r5FNqZmiEE8MNGZkYtla6It92TuI5HWU2pYTB9HN5APzO+vlY0/9rnsLgq1kaLYKfSjly+Ec5U34/ZJETc3c8DD9GaNbLgey0fPNqZFT1iKqgoMWP1Nk3PFaSMox2qsXKYd2C2qUbjuVHVsbUgW8LNDmI9Ui+/OExydTbiuTlD1o8BbtFGyHw9/o6mv4lVmFfsa1W+/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On 4/2/26 12:11 AM, Mike Rapoport wrote:
> @@ -2021,34 +2040,33 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  		       bool wp_async)
>  {
> -	vm_flags &= __VM_UFFD_FLAGS;
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>  
> -	if (vma->vm_flags & VM_DROPPABLE)
> -		return false;
> -
> -	if ((vm_flags & VM_UFFD_MINOR) &&
> -	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
> -		return false;
> +	vm_flags &= __VM_UFFD_FLAGS;
>  
>  	/*
> -	 * If wp async enabled, and WP is the only mode enabled, allow any
> +	 * If WP is the only mode enabled and context is wp async, allow any
>  	 * memory type.
>  	 */
>  	if (wp_async && (vm_flags == VM_UFFD_WP))
>  		return true;
>  
> +	/* For any other mode reject VMAs that don't implement vm_uffd_ops */
> +	if (!ops)
> +		return false;
> +
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		return false;
> +

Doesn't moving the VM_DROPPABLE check after the wp_async early return make
the issue David raised in [1] possible again (i.e. moving swapbacked pages
into a droppable region using UFFDIO_MOVE)? With this change, VM_DROPPABLE
pages can now be registered with uffd under wp_async, which allows
UFFDIO_MOVE.

I think the VM_DROPPABLE check should go right before the wp_async check.
And it would probably benefit from a comment...

[1] https://lore.kernel.org/linux-mm/5a875a3a-2243-4eab-856f-bc53ccfec3ea@redhat.com/

Thanks,
Tal

  


