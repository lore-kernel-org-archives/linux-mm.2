Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D306CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31661280005; Thu, 30 Oct 2025 11:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EDF1280003; Thu, 30 Oct 2025 11:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B60B280005; Thu, 30 Oct 2025 11:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06C1C280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:10:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF34A56A24
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:10:41 +0000 (UTC)
X-FDA: 84055117482.15.4D1998C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2EFB1180007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:10:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y3CAd9i6;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761837039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDCQK9hlLE+TETBGIIHqM4Q6IjU8KzujqNQtOJ112xA=;
	b=AiPEVHWLs5XPgH2Z6M6k1FRlkrS9wzml+L7h/n8Z1VSbFqI9qOE0syG9CDOYSAnem+iKB0
	YDsGwEfDemwigZr15JukxNJ+cJsY3GZeFa+gM6x2RGZ0kJZbZGVistEEx1K+JA8dO+dFJl
	kKudxDhQYDGmfHFIO2O8aqMHB1WGTOA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y3CAd9i6;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761837039; a=rsa-sha256;
	cv=none;
	b=3ad0Czpp2nJ7IMi4QayKuVkvCRNLpRBt95oEBoTDj5ZpOtr72GIlhhJJ7m7JMRrCr22ILy
	xb/9wehwgp9dZXTaEK7ybIO/reT4/YllrlW29PQtdGRDFIQ5XSqJ/3KE6OpeM8K8/ib4l2
	ozH2X79Gv5LhoHutlUNaRWjfNmOPbJs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761837038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pDCQK9hlLE+TETBGIIHqM4Q6IjU8KzujqNQtOJ112xA=;
	b=Y3CAd9i62NCHZZf4p+nrk2n3JrFmNxmuarSZpxR9VAeddiHfD1viws1ZvX0PaHHjoEKSwh
	LMjViDd1bDi48ZNtZtEaRcur59M1KWlUwJ80p+QUiaG1K0FG7eiZnNjqQWqX/81uk/BooW
	VbV26G7loZFXY6+F0EwOGwrA6/0pP5o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-uFpP0xpsPcq_VuM-6UGr9Q-1; Thu, 30 Oct 2025 11:10:37 -0400
X-MC-Unique: uFpP0xpsPcq_VuM-6UGr9Q-1
X-Mimecast-MFC-AGG-ID: uFpP0xpsPcq_VuM-6UGr9Q_1761837036
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-475dd9906e1so7184525e9.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761837036; x=1762441836;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pDCQK9hlLE+TETBGIIHqM4Q6IjU8KzujqNQtOJ112xA=;
        b=Y93USlNSzNI/hEFq+F9O/s+Xwid2BO61kroxLVCjZtEqN1WNdY8ZxwLprThVdOcCWZ
         R/UpcMlZ0pmkuFWttquLUsSziCcAKEIELnHVu6ArFBqdrXzjQV2ufKCTzzHBbrIORXAn
         mNMIm5Q1IiC3Z2QXVBec9anKRSvaBI/8Hki233mCnJwBUPcKOxbm4qJeKfgz1iNBF15w
         8MryBFk0g1U7egTUhKVXQHc/Gx1VjcXcX04NPCHap/AU2NpS74LD16R9i2gVRmCaF3gr
         5Wq7tkIn6LBz1D1B2PhmorHKa6pekgSKUciARZAe60mEOWpGK2j8R3XemRuxYCXw5rrr
         DYEg==
X-Forwarded-Encrypted: i=1; AJvYcCVHj7pn39PsPRsadM63pboMtYwAwEiPiHgzHsIE0lZpP7TT+qDi2IribE09UlAm0k5jbw19hseUwA==@kvack.org
X-Gm-Message-State: AOJu0YzSRTqz/lWMNU4kfrW98qpN5CltKVOEmc3j6RDtaChU6TCV/KGv
	M6b01iniSMHDVby87OOzwDWBkH5MZ9vaYfjsgvSfmfV9edkTBDgeR+Uz0ghylW6JdorZ7q6F9vy
	Ujgu3wSVnUnhtrnFTi6bDMIwgthtOXz4JhQZWcXhKkYWVowfYOQYW
X-Gm-Gg: ASbGncs+RMtmOCe52msyO5o0yLABMJdOpd1wHtvNU8sVwC/TC/9/1aytKQ524BTB2uh
	7X5gnEF6bJR2aGxX9ZWqecnTwtJiNmdW3oLUUtlXtqvop2OTuo9bMwDA4PMfns6yr77ehqNikbu
	dSl1K+ZA/8YcdFROM2/hF/U+DwFMOTRhJDPYXLMpxXOPln2dH55FRHOQP7XGaaQNw7a/8tPN2av
	kgnCrMKXbu2NXQ0HGyvbjzUvf52O0YTBXUTPy4fgoDOhvCiXrsxtTOsbAJdK4z3R0hTLvD7n2KB
	wgKCjANVdwKWaT6gSJOG2BVj0ZENycC4tKAX3He6c+q4KLU0X6r65SOpRn6bxgJwdh5z1tepXQE
	yVnQNvAAGzay42JOdgkHvZ52S1b/8Wr4B6MJ6xKL4wzBx7YokpNhMZ4Nzkdx0bfhJfnu7wZxqir
	a8KWb5O3glMcz9pxYYNy1BV2JjKsk=
X-Received: by 2002:a05:600c:6389:b0:477:da4:364c with SMTP id 5b1f17b1804b1-47730797bcamr672165e9.4.1761837035746;
        Thu, 30 Oct 2025 08:10:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4KUGeZbzNKm7MNGtt8D6Fso8lLniBFswbKsZjSsZ0KgGlb6Xh2MXwXuc5z8HUy7nMGWyBeQ==
X-Received: by 2002:a05:600c:6389:b0:477:da4:364c with SMTP id 5b1f17b1804b1-47730797bcamr671735e9.4.1761837035238;
        Thu, 30 Oct 2025 08:10:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429bb752b49sm1353322f8f.9.2025.10.30.08.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 08:10:34 -0700 (PDT)
Message-ID: <4f68e609-a40c-4844-ad40-9ed31c88adb4@redhat.com>
Date: Thu, 30 Oct 2025 16:10:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
To: Heiko Carstens <hca@linux.ibm.com>, Luiz Capitulino <luizcap@redhat.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, osalvador@suse.de,
 aneesh.kumar@kernel.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-s390@vger.kernel.org
References: <20251030145505.2764038-1-hca@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251030145505.2764038-1-hca@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: coOyJr5C4JP7WBkakWHw7I40LX43JaQRsu0qLliGJPY_1761837036
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g36odcxb8tei48bou191opzjymm6gn5s
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2EFB1180007
X-HE-Tag: 1761837039-177880
X-HE-Meta: U2FsdGVkX1/6EP3kLicUdpODEtnTp6xeCSxHPO3JaHFiU+dnm0DntB2GC/TXAkn62P1gELx6vinHu5gymmMJ3fi81iR+bnqK6vFza+muUpLanMcW/ZMQCnxdiP9JMKvrXAVaKZaMH16cLwLS2j2zPzUSmKJDZbf3ondBO/XSmDJg7jiSaGpyWIZd8cGKe1y5cPo1bbDE6eCRhZrr8IkgMzSOa3XG1XGVLMMYdlEffLXsj3epfbrtCW+2HFC/APOEwcsau6BpVZkzvpnr2I0I95v6ITrJZQ0ROBBrxu7M3nS1CPNR5TMS6Q7NnRIFE3BTRZIpZNmu3bGpEGt2mPqAOY8BY8sDkcKCwJdwvO5wBqhsHQd3UIUR4/aMWnl0RiuXflwKI4lMY3sGrrIlBbljLAvr0s+Cx8sisZENvDhP7OIcvFoXAgTpO+/GkteSMi8VCm6i9YsdndpAHTBOJkTm8EEax+8aS9acfhuac0/xPbXuZoRZVxI35UZ8c4iITM1z8fFeG7F582gFN7+lHwYM2TkC72C7K0fZods2fTd43X2AzKP4IwOJn8tsupC3T0AKvzg0hMhtUusIwa2vShB7Jf22sA8Vpy9dqC967QL0kzVJvn7s5O59bsDk2G/yPYgbmNvjq+rOREXX2nuNRUYMieCmXTZl/a0rlAoz2+oDRi5wg0y7Qmgx2+DyZRC3/rv+8sAIRUh94y616ZmlvKHvwA1YCIs6ILm442DDPNMq3TKxB4gpdGXk56FQhQ5YD3u+I4/Nou6IsKtQ3sRCcH1458ZGdYhpPgct5anTetHNVZ6zmz1r7rTcApnQxDN+HyoS0Gc38RCQwgQoQTYU8iYA6xN8bXvQOxqnlmBjl+9Od2/GWA3NY+Ob3q9gklmlVXQBRf6Fnxxg45SyK+P2nBZIGG517NnmCKcPfApdrtXNUT841Ygc501Veb1GIrLhNr+N+8PcUKYhWVruW9uFZpg
 xeeJU1WS
 xOhGp0CcoSUX8z1Y4LmTbFGzhmdE3crTAppxBLOIWdkIqI+RKn/8wwWv3GQDVvHqsTAxVXHN/2QLxtQrbAM89gADIL4gw4W14ihOuhWNm6a1wy9+RWTjNA4amTEy2A50ftNpzRNHVtcZULxK7scNjvfepPVW+ZAaQPlCH7W5X8cURtdYLC5RKWWj9Jra7smwPoeqJNkjaanKYm6I/YMg/dwYcfB3xmWWu5C1O2VErLMVXK3ptmT7YffT/9gBS2yIeN+J6inQYqYkpiDs2ceJVtLh042zpmdQIuMbEN7VJz5rvlavXiPG940rJp3dWO6dBz2nqxqlg9+VC2umrcLOtM+jpdinhdvcYUShHFbZaazY1lMxcJ4EwZo3L0+bcNH31CURFzWo9vDilPHkJgqimUJBUXXGxJTJtgMytyf8VyDNrTgZ1wCfSHDIX/SD/KmwtaLBiYlLuo3OH5i3Mf+IK1+Hb02ZjTqJwqNO2znB93FMsTsJ7/CYdVrz4D2RqIBkMS/ysylktPZjci3veVC4FPNO/YsR3qbuPqNV+exO9ngANTb1I5wIBZrOs0qwV3UcFwb/GmLUFRczR87Ku0d3gidRsOpJVe08m/8Bdo5KrSWy3B9E45iloAPEfz1InW3/cK+0Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.10.25 15:55, Heiko Carstens wrote:
> As reported by Luiz Capitulino enabling HVO on s390 leads to reproducible
> crashes. The problem is that kernel page tables are modified without
> flushing corresponding TLB entries.
> 
> Even if it looks like the empty flush_tlb_all() implementation on s390 is
> the problem, it is actually a different problem: on s390 it is not allowed
> to replace an active/valid page table entry with another valid page table
> entry without the detour over an invalid entry. A direct replacement may
> lead to random crashes and/or data corruption.
> 
> In order to invalidate an entry special instructions have to be used
> (e.g. ipte or idte). Alternatively there are also special instructions
> available which allow to replace a valid entry with a different valid
> entry (e.g. crdte or cspg).
> 
> Given that the HVO code currently does not provide the hooks to allow for
> an implementation which is compliant with the s390 architecture
> requirements, disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP again, which is
> basically a revert of the original patch which enabled it.
> 
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Closes: https://lore.kernel.org/all/20251028153930.37107-1-luizcap@redhat.com/
> Fixes: 00a34d5a99c0 ("s390: select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


