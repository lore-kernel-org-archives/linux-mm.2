Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A780CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5358E002F; Mon, 13 Oct 2025 07:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395FF8E0007; Mon, 13 Oct 2025 07:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235C98E002F; Mon, 13 Oct 2025 07:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B72A8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:12:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC10F160379
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:12:28 +0000 (UTC)
X-FDA: 83992827576.23.235A882
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3313620014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:12:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LO4QSF//";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760353946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XULdT3agFke/P/nH7DRRciMv9t5MyWZ3cE6tzq0NQJQ=;
	b=YaxjQW8YR4V4crr+qU6z89uGSEdpdBW9UTxZbBSoOULvbBc/HXSGBtAoFwPt1bmQ6/vE0s
	P/OlkubKHp9F3cMCQiLBfuli3YXQ71XPv0rV85MFHQPIGtrCUiDgbIsKs/FTo2hBZo0BZA
	0jrv5bKrltyqdhaXADbI6dXfaQNq9UA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LO4QSF//";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760353946; a=rsa-sha256;
	cv=none;
	b=tk7gWEAGtlCFgaPruetlHSTgJOef69TRnlCuTorN2Jkq1v54Fm7nxnjMCZqGiYGzLtKZZb
	kdxiGEVUSjXYgELk730rU+M7TQF8+oE5ggFJYP0qvxA3ZBdpvZr9g+doIPWB7NXZs6aP7p
	8F1jhDKL8VZkYdbWdqIeXcHjIRu2BVw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760353945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XULdT3agFke/P/nH7DRRciMv9t5MyWZ3cE6tzq0NQJQ=;
	b=LO4QSF//Rsqv5mYrUt1FilGeh5RPo9Jp5eY5lqO+gpHXuvxY4LddrAIuKTOmCHkDtwhHYR
	moLfVHBuq2/4u/rWm0NRnpsR+td2NSaQjUv5QSy3XfEckt1yxD2isLc5h+0eipZgSGPvGP
	RZm7JYpLjRNgn4Gw+7w6vCiNnzYxfc0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-TvdHIf7vOlWVWzxmanU-dg-1; Mon, 13 Oct 2025 07:12:24 -0400
X-MC-Unique: TvdHIf7vOlWVWzxmanU-dg-1
X-Mimecast-MFC-AGG-ID: TvdHIf7vOlWVWzxmanU-dg_1760353943
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso28712325e9.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760353943; x=1760958743;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XULdT3agFke/P/nH7DRRciMv9t5MyWZ3cE6tzq0NQJQ=;
        b=VFSb4K+hYKlcPMAwN5Lmdlyk6zVFgHl9ZF/RlPnx+1FEMcsJLe9BbCBmcF1X1RFw+d
         M6lEqvkcsjH/o91xlmDjS7mwS61GGkvrIZVbr6fMyBklGTDMjUzenc9gqKYH3HPHeAOj
         dt4RQDYGwBTakDq1bV9z5CR2LJ6shgp1PNmaiuoSlLpq/DkIkONb7jQOyV2QODvB4JIa
         kApKKDb2M64bkwSdgxjp80GJTmUSuigU31LMNLCdtdYCfnw0QWxrvinY/pY53F0pAUb1
         2wPy6oSz2EH2ALOWME6iT9E2x/HsjwEyxzaXj6TwXNIAWPHllnqtbgInb0WAUTr4vWOy
         iYNA==
X-Forwarded-Encrypted: i=1; AJvYcCWosSZLgv5JXo9VZPlLvcm4JyPmC/ujT/8iYuokLDQp0cozaJxVAcdLJ8fwdrxSg/TkOOlD0Yy9hg==@kvack.org
X-Gm-Message-State: AOJu0Yz8cjOCwIm8XXt8Y62G+ZOKlNqrIyvOb29oCjKzxDqkM391qH5m
	0fSbeNvN2GDKrw9y/mtG94lA9iBrhpVJMEaB4k5KO3ay3jBHiQbDzIEJV1c3KXqkPTzF2oYm/B8
	l2+N8QGDLjvVZ76R/M0jMt5c/GBQsD0JNc2eZ5frwty8EjVGIe/EV
X-Gm-Gg: ASbGncuu+8RsYSmXT6Ottd4yGDGPRIz6/MvxcF66qZxnhke3rCu0wyaDoNJwqncn6/B
	c4uVYqZR43BPBLEWQevtDZsBBVOqRSs6zSWvkvDaSf9dIZRnDXD/zzMQnOcgiLsCh4dRiPCsinS
	B6nwIDTytA1FrM9FPxMU0hPAqkgQULtN1x23pUSI4t8fSq8wj8XEF1Da/3U6bSJHl3xwWy9BV6S
	QDRcTtySIqUKAbFAfIU1pjknftyYqGWOIvqFHKOEu9LoNv9pd47KZAPhHg22E8UPor1Lh3oITij
	FEAP5ho6U1OTicw/FujFKCj2xCcRT5bkeFxpSfcUje8TSLGgI0dqYEIyM2p+r5CpA/IAWrm6z40
	hzcM=
X-Received: by 2002:a05:600c:a43:b0:46f:b32e:5094 with SMTP id 5b1f17b1804b1-46fb32e50fcmr126504155e9.32.1760353942870;
        Mon, 13 Oct 2025 04:12:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGhGqB33GtEsb9WhKM6fim1eU7Q+q1kqoOzaaByZHeQ7HI4L9DqqO/lwFIxHHImbaHfSHEAA==
X-Received: by 2002:a05:600c:a43:b0:46f:b32e:5094 with SMTP id 5b1f17b1804b1-46fb32e50fcmr126503845e9.32.1760353942439;
        Mon, 13 Oct 2025 04:12:22 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb55ac08dsm174127325e9.13.2025.10.13.04.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 04:12:22 -0700 (PDT)
Message-ID: <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
Date: Mon, 13 Oct 2025 13:12:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t8QUsKh0jLfuvLYOJIbcRUOQQPQX642xkdVABFFKJ5I_1760353943
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3313620014
X-Rspamd-Server: rspam03
X-Stat-Signature: 3bpfbwjupkznkm1tj6pnj8p4yxesif8u
X-HE-Tag: 1760353946-848422
X-HE-Meta: U2FsdGVkX19S8gDQhyRxYNBIsRSMa64Hg3xcc4Ku0T0xwYrY1zQj/xFL3plsUQ+r4cSR+PvLpSl1iRGk3TufYBviDhn6t4K5LSw3Mp5gzASEzJkPRUZ4pYOglIMWDWeYMdBeo2HiCaFdsMRlsensh00jZhEQ7FST/WeDrqHgEMUYfMqmxV9RkErAD2TKnmGzS82MVW+IIklX5U4QwZ/jFLV5Dl8ms4Z2K6rU1JEUL+pXHs/fXVJL05Sd7v2Hq5MA8j9ph7QOinpIAtdvqPJDzzKTmIqqGPFt+kplt/TQwuEfOiJYG1wpmB1nc5bontkkq94nOJ+STeTyT7PAtZjZNRXTgl6+EOpwSnykBwrIAE5O254zQnoRbGOKuU0pQJvF/0iRQAgHQeB+oCG970FA/Zxc9XOdZaeOuCFBUZMtB+cq/EzxADMpSkIS9yjwDF9GMrU8mhkK+rKbyj1T0+qWk8s87hHOhKRNOId2D/RtW2LXEN4OufptEUiKJ9jBYI+Bmr3UNyl6CgK1fvjLYvzpo19wg1S7O7fs2k1Fv6etv38IbnlgVc5UwFfzRjwqBJr3L2hzLzD7u5HunlFiF7twoxK8Wg32K3dNwVe23PlUYar1I7foEtBe6CM5SRBPYFWg09nKl9J00/HqwPt41ptTnG5qMSRAZ2BLD7hFteWZGEkJ+0qsT96esc/lb4GCUVKGwW8pV77bFaR3qdtoTQ0YjTjk1OmyBYWnlbdBPOn7KEyNpJ7FCjqePqguEfBzDprBxNJHGXSHmLd1+NfMDHIZ9ehbhNH+nJVLc1ZEIhJVCqSrme19tbB4joVgG8ByKjwyGjsYbBd8udeYs6M5djU0sjmdWl27vW7RWKI4jdRmF68hiCvAKiiRdVDl87/lUGGFaUbvixg+CFqlKgLYvgUpEGL+zwiVUDi41PxosFa5Bb2ssG1MHNJpu5+2guuBKt3OE2sZMqgEIz6m+GhUbyk
 faKHQTHi
 9n54UE1r4zLFYqmUN0k4utRYr4+qtOTH7U+U7f6M5UBDlhZvpgL5P4PXY5Ef5cf4bdFVLYgdBvR4dnDXkvx24VEzFin0cEsvNrH0r7E+fK5EKmhOvmcSassUATZsLTO9DK+Rd4Uy2rEfadtDXxI55YiiT7EyZtAh79iTuLQcdhgGR/ZWEgDuLMVKQ8iRmamaT5lJ6+rFnbmxEVcPOdgaXOiE2ipAMsCErceeGVylhCJ3yh/kiPskhPzo9pIxJPA+xmIJDc0WHrQov+nkUG0JliwwcEO2vrCEmnrgPjnhmUwa/c/6H/G1eYgbPWr2kvk02uEA+Ldz/Yv6200h7xCQSPaghPok/HWTPcxVal0QNmDwMoSctDRMAH/eO1rtJyTkWOJUzsjk0JdyPCUgJBdIPxOSrM55dMNz06rS4GIQDNqj8hWYc64VK8Mo/qHv4DYnt6Q/TX7PPbFOEkcvJD+s2un4Dfw559YPti03h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 13:04, Lorenzo Stoakes wrote:
> On Sat, Oct 11, 2025 at 05:30:52PM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Hello MM maintainers and drgn community,
>>
>> This RFC proposes to convert VM_* flags from #define macros to enum
>> vm_flags. The motivation comes from recent drgn development where we
>> encountered difficulties in implementing VM flag parsing due to the
>> current macro-based approach.
> 
> This isn't going to work sorry, it's not valid to have flag values as an enum

I don't follow, can you elaborate? IIRC, the compiler will use an 
integer type to back the enum that will fit all values.

> (they're distinct) and also - importantly - I'm going to be making significant
> changes to VMA flags soon (to allow us to have arbitrary number of VMA flags on
> _all_ architectures as recently done with my series doing something similar with
> mm flags).

I guess this patch should not really make a big difference regarding 
your upcoming plans?

I do hate the enum stuff to make these tools happy, though :)

-- 
Cheers

David / dhildenb


