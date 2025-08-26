Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A088CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CE76B0192; Tue, 26 Aug 2025 09:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CCEF8E00A8; Tue, 26 Aug 2025 09:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBA16B0194; Tue, 26 Aug 2025 09:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6546B0192
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:19:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBDB38491D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:19:54 +0000 (UTC)
X-FDA: 83818966308.14.E275052
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7B58D40019
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:19:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EkCY3AZl;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756214392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPowumH6CIgAEb32W0OiP+IgD461ps67S25u5+aVKZo=;
	b=a+v4s1kPiIyfi0hukD8kjkMivtRyVaKg2db/a9m+qXRTet5uwSW90UMfM38BqG0xnzyg6c
	guz20dOnR1dkkkFgTczLS3IzI/W9HWPwsR/MC4odOlar25od/kvXrPjkPF0wsiy1FnGHiC
	sRBzx91k3aqDyHg7kZULpBMLW5kGNMo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EkCY3AZl;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756214392; a=rsa-sha256;
	cv=none;
	b=azIsP1NdOFcaISL9JTfIbXC3piXbsRo2tJsA4D7WYTX3qwcZwYX2rYdPj8pJPvetIHpqDC
	N2Gya6T1NEhTfTj7XF8esVoGpVB9rNGpmR/mgtaVGp0S9zMwHZPYUWNGRCSlDWT+ueR51D
	X67PCvltCeK5NyF/P+ciBl+L4i4Auqc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756214391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aPowumH6CIgAEb32W0OiP+IgD461ps67S25u5+aVKZo=;
	b=EkCY3AZlJWPAkg2AA18QWnmrph1SPd5H4CFvrBOhES4wrJy/SVTbxMj0Gr1cYWWlYF3Sb2
	bn/kN/1HlL2LyLivXfygIbbcbcioqkteN6FM4016K2qfDjTqoQj2+tr9gN1Iur8xC+dRUL
	UIcoFfxrqZ0aDGUREwR++VRVaKA6dGY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-ysihjOvpOXep3UQuUvNKyA-1; Tue, 26 Aug 2025 09:19:50 -0400
X-MC-Unique: ysihjOvpOXep3UQuUvNKyA-1
X-Mimecast-MFC-AGG-ID: ysihjOvpOXep3UQuUvNKyA_1756214389
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c8bc2914a9so1173962f8f.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756214389; x=1756819189;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aPowumH6CIgAEb32W0OiP+IgD461ps67S25u5+aVKZo=;
        b=m9c9xbSMD5MLAO0SYlqHiRPprtGMW/W70E74O9c93MzG7EuvPCdkss8To6eIuvTgls
         p3KdNs+LviX1F7TaCWiZTXZZ0urwz+JyrwTrjh/qYD92S3EblfYDNTjpc+iAu1XumoPn
         5xsbDirghI3LXyNHFgEALt/BVYYgSmTZDxQevK8RvW7pA1+ajFvW/fmJ9y718tEtj8Rf
         dxqDqU9cxfsuCaNma904B17ygKyS2dO2e9LRMud1KZRwdMDyF6byh+lmwJYtajjEqQci
         GZ2mubo19WGL2PxbX4koUMKnZKdVBB77cbflvfVpkZdCkXv3ViIPZGuXO6JTEf9Fril5
         qesQ==
X-Forwarded-Encrypted: i=1; AJvYcCXI+LZJK/fxwmtn6obp7uo8rvHsnlw5RyK4ZLFmyhct1NdOzP4/URwl1Bh9bD2pS4qNU8yvN2zwgw==@kvack.org
X-Gm-Message-State: AOJu0Yw85rc8AWMPWja71n4//y8JWkSzKxLrfYPMqMCxdnjecztsI/Sk
	5GrpOXNcikbDFPhVeN9e/YfeVPOF23adv/xJSzpIi8anp1fpQS2ihDN6Kp+XXyko9kFDSliJsG7
	Ag5CTUZcb+kBSuUkvSN+cg0l9OHS6JMRejRv8FfqIrG00V2kGaC9Z
X-Gm-Gg: ASbGncu7gduWnsqMQY4CItCmHY+/8kN7d9GZ9BVmDiriD19Xu1EwBG/YhKydVzB9Fvn
	9/nWwXwW91iEMO4Qh2piCLGXw21RTJ0QBk1TCS2drK4ToBATvI2Adub3p9or52kL4igcojuU0yd
	o/OWW4v28tWFvK9kDGbn2XIMIwsz5n600gMR0nb7nJrqVcOgMn09FujjjXSrBMpmLSsAZT+8wP3
	dkJlwmXLIGUN8jR/KfQOmmr1LZtbrg/jNe5Dpq6PwkXcpoz9DsPnFWimB5ZKQMqVm4igjJnRLS8
	DPGoVEA1pgiColh51kznwoQrEiQEDvXuhZ8hERJgHdKFw/AUPTrGK22+MQmGuDUEA4sxtWU0Bw=
	=
X-Received: by 2002:adf:fa4d:0:b0:3cb:cc6f:730e with SMTP id ffacd0b85a97d-3cbcc6f78d6mr1064934f8f.38.1756214389339;
        Tue, 26 Aug 2025 06:19:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFx5h/zeyxS5P6pZqmfC84eQEOjAOEyZe2tYdaN0UkX+GJOpZnY2NgSKE9TejxvTElAs6YgVQ==
X-Received: by 2002:adf:fa4d:0:b0:3cb:cc6f:730e with SMTP id ffacd0b85a97d-3cbcc6f78d6mr1064910f8f.38.1756214388861;
        Tue, 26 Aug 2025 06:19:48 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b574e607bsm148692805e9.0.2025.08.26.06.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:19:48 -0700 (PDT)
Message-ID: <59fef25c-6559-4fb3-8810-c2a7dd36b95a@redhat.com>
Date: Tue, 26 Aug 2025 15:19:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/ksm: Reset KSM counters in mm_struct during fork
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Wei Yang <richard.weiyang@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XGHyk2rhqGus6hA5qVeyDPUkDnSzpgGeaJjuk11XCcM_1756214389
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: awz49ajbijzbtgzrueyfnkxa91pfnb8w
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B58D40019
X-Rspamd-Server: rspam01
X-HE-Tag: 1756214392-752032
X-HE-Meta: U2FsdGVkX1/FusHh6hEvlRi9fb2zZxnsKI/GRRfpAgYeOhURcAooqKN6xA1XkfrscaU5JyKBP98bWXi/leXEmPiznbFpznrVxbwb2zojUAesHpQVCWHYwzQKY41c2TeC6fIHcLTR41FCSgnbf0nhQsPINKMedEHhVkZFO2qLXwWCm84z0hYr3c3UaW5DlDTrjK6gkuZEYO0EnSCd4HchWEGeI0inPZWdj5I/4iFUqxk3lFQOwqAzbea5ZW92vtu3B7iH1psFkl57Ena0uniC4pMvOIP3Jd1n2Ow/fh3M1XT9Kgaw8xEI/0Z0DhuKbv0zcL+kpqjW+8K3GFilktofybKPL4f1ZbqDlqGH3wABB9VV7q35hZTso8E5kCaYhQbaFGxltYwo9pvG6IczJL/QQ2npIzi2JxmMI5gB+k6KpV2x/rij3tXoot+250oVVag3kEVmHiBtvDjdJdg5mQWHeo366UeIR2/ZoEg+NziXYUSxHuKWyJF2pF9ZabEWTXSGflr+BByDg7XGaroTght/+r9U0zcAmPGCwIt+qjGybm+nSkgm/UCeUCcMpxwgCm5KAqiDY1srG5N4L8dWGpHsZYmsWYghYYTAx+hWzzu9qyxX9PkWsps0SQk5yqtJztMc860Savm9L3OWteadNXJWvGgf+WaRU1sfAmjSqq3EtA+3XNKgmR0tImZq63LrnJ8Vh2cXyAHn5esl1Ex9P+uTfv5o/QORZZw3R0Jtc2GgwupQhSvYokGw5xYXm9tSLg6HjoLRZbQSQkkS1nkt/Wi06DOUz7+L0eGsPB3PfoWzQxFKE8P62yjLY0Zs4dwnsgPhPpm1kEDKLqpRsJwmIS6l1pSBTvdYKez8pe0vfsWL8UB/fED4sCzMsqx+2nPmXvv8DuLI8EYeoYV0s0uuB7ANkmzTCwXe9aSo8Q562xlOKAHt6HnyO/Ovz6rOuE1g6q76mEAvg0itYuInhkw1x7R
 +vH0F1uA
 6qJphwsdRCQeK4SIA83JafV0PizCmJVBYi6+VTXfju05Jk8oqYRyVGTWbgo9e1vdkJBEh6bDqjCPoNe2wAP1NhpSDmCsQbVEhlDmBzwC18cOgyl1ulk2LubAVF9vSGhNgEgxrzXJ0Q1lKl9U6LpJ3t9H+nrKRG/i5LAC+utlu2JewMlH6cZzyvfbQg07Fpdw63btBwMpkf7d5ZUlkmdlzOiYYNwQZcuq7E12wdhmX7M8dSqanlNAM9CqcmJF8UwnKGV4KfOg/7vfKTuDhY20rnbXB7At/KF/r7HHGCIbDFwE1OYOjsVZfyKb8dsPRl3LrweI14wbk06HaTROHhajwRcmXJ0TyaQtyhYN6a4o9ce54gIj3iDQcGp2RW88JyE6dWSoRefvK2bi4IfGQu72w4cZQWhvel2vw3ZUnbo6eBiyEVN+MT697y/1eZoOVpZldcs/jkcQSTPzo/bvryYjeoiyIYMl8d9WZ3DtKiINsgn9V8+hyF/jxHitypHAJ7hXvevP/5cNSuYTUOAvYmV2L2rXmAZuTHedydi9wSgemz5X5hSSEWK2QHDSFGdHzpbtBYkjGd5NBlR6xowRdk30B2BM795yLxWJyDuby
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 14:49, Donet Tom wrote:
> Currently, the KSM-related counters in `mm_struct` such as
> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages` are
> inherited by the child process during fork. This results in
> incorrect accounting, since the child has not performed any
> KSM page merging.

So, the situation is that our child process maps these pages, but it 
does not have any stable rmap items corresponding to these pages.

rmap_walk_ksm() spells that case out.

Can you clarify that in the description here, and how both stats 
correspond to rmap items?

What is the effective result of this misacounting? I assume only a 
higher number than expected.

> 
> To fix this, reset these counters to 0 in the newly created
> `mm_struct` during fork. This ensures that KSM statistics
> remain accurate and only reflect the activity of each process.
> 

Fixes? CC stable?

> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>   include/linux/ksm.h | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index 22e67ca7cba3..61b8892c632b 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -56,8 +56,12 @@ static inline long mm_ksm_zero_pages(struct mm_struct *mm)
>   static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>   {
>   	/* Adding mm to ksm is best effort on fork. */
> -	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm))
> +	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
> +		mm->ksm_merging_pages = 0;
> +		mm->ksm_rmap_items = 0;
> +		atomic_long_set(&mm->ksm_zero_pages, 0);
>   		__ksm_enter(mm);
> +	}
>   }
>   
>   static inline int ksm_execve(struct mm_struct *mm)


-- 
Cheers

David / dhildenb


