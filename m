Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7162BCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 18:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADDFB8E0006; Mon, 20 Oct 2025 14:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E7B8E0002; Mon, 20 Oct 2025 14:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9562C8E0006; Mon, 20 Oct 2025 14:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2EF8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:12:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EECF56AB7
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:12:17 +0000 (UTC)
X-FDA: 84019287114.01.C72040F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8D09D4000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:12:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RVZEt//F";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760983934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVgKjUel+rmr0NmRPve4lgE6ZPAS+6sKEkfcV7tneVA=;
	b=uRaohHOTvSIS+02BE2LYa14WeCyUdSlbZRFoe38HdyjgIZS3tob/vVnYTPOzMrqCUFog7i
	Mams783vDiIWe9wdPrFDookzATMuiPzp4WKpBlIIh3xQksAef79juqfcI9WCz9EBgw/Dht
	izjP64WMXtgd7GRzGz+I4FniUK7SprU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760983934; a=rsa-sha256;
	cv=none;
	b=axcIaA47m1atNx/lIJlIxUnSxwJk8JXxZ/8Ih+t9GpkvJinINEM1wal0dhx8u3gIUpmn8W
	gfIWorcWXs76/rBHzxhiwsYo+kQxUfGP3+IIvN4juVIaGx4A0pnj/e7Nlm4BDkwiO1E/79
	iKDdosLKH0vRbUnsWe/R/lB5rX/ECoo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RVZEt//F";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760983933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AVgKjUel+rmr0NmRPve4lgE6ZPAS+6sKEkfcV7tneVA=;
	b=RVZEt//FwJ6+ck5mwHC9jzZ1OJaYY/kUlksLr/uwbjipwbcryA/AeS2iEMbetm5n2dkauM
	Arq4IDQSm1PvuiErjR+wR2aSMI4GItXq2ujfbffzP4KaXPf1hB4VxhRdU9CURGvgu/5WzK
	tmBUalyM68QnDAlbwKAQOrTZpDdFirA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-kQ4SE8akNiK3pnrE0XjP5A-1; Mon, 20 Oct 2025 14:12:12 -0400
X-MC-Unique: kQ4SE8akNiK3pnrE0XjP5A-1
X-Mimecast-MFC-AGG-ID: kQ4SE8akNiK3pnrE0XjP5A_1760983930
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-426d3ee72f5so3537877f8f.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760983930; x=1761588730;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AVgKjUel+rmr0NmRPve4lgE6ZPAS+6sKEkfcV7tneVA=;
        b=gqKQkb1VasBzMNn9GRjGJ3gfaqgVDbOpIweTySIn81I850lXt+u5W6/xQSz0+No3UR
         IVh38INTpHjTic/Wk7Lsuli+LzoZ1nn5yU2KKJ/msEC6czQ6682Uq+2gI8eKidioOq+B
         pYA0Y25dvNlXBp8P5b0HVVd6yqiWHiLwcKTwVEOKkKXEumX3CCeUk/+myfRplwtFevfK
         6gPNEA3B/O+t7zvl//levTnTGi/31Ylu2G+xnrlHPGhZfh+RN3Ny6f8TaLaewv7Pu+Jd
         M34C9bOrkPV2f9oJzTxQu4vvkbyf9IJrb9b0gFCq4QgAAc+rk/J7LsrqnwSiHCrgfzUv
         yWJw==
X-Forwarded-Encrypted: i=1; AJvYcCVrfuvMdx6ItRo1Ds5MCTnAqIM7yccpbyunIBsOcNqRboYkK5oxApTfqxBGHNIVlyAFY/1QSyfC7w==@kvack.org
X-Gm-Message-State: AOJu0YwaEF5NsuGQqCwwKMQmquPn7mei7NJXM7G3/FMW70loh2KBlAH0
	VvbnhIHQpj6UGpPpjVLIHfSHUa1WDZF+QEzgFZlhdjQqx37KAsrkvGKY+RHwz/xQU6jvZimUvfq
	M4umYr4y6at0S5iN9vkH5JgqcebcbSJcaFN8xcVDZRmIyFVMOr1cJ
X-Gm-Gg: ASbGncuVD9zh1sc65c+YGgFih6Hr8j8fiePY3+FhfC5/NgxkHFvPXH9BJ24/nDn4XH8
	cVzdRPOzC1fnM+IX+ROJGgn6ocOa49Q0Ke8IWzOC0bGuXeVMqei6l6IoqVPkiVPBlE7c+xrxENp
	IWKR2LX63ToDW+ZJG/wF1dmpU4N6Npgg6hmWHROaxfM+VR0HrZ1QHr/UYy8fmTCu3Z8pdMrpHef
	YGp18hoBma0n+bOSZ2KMWdwpyi0dQ5RtGf6DLO4SckNPulXxsT9y/SC4irGKZraeX7s1O1w0RAW
	IBw8vT9uXYvMk/kcxzGR4ZLrHQHj9zSk+4fVaGJ18ly6AEZPLg8SNTtpFVW5V+N7KaTaM2RHbvI
	H3a0jbcIFVNP8d5AMtzjVRWv8L2C4kQeVd82HInP+I3bRtwEB4qljllpEHJ91ya3i7EmJcrQS9b
	6BnXOYnyByE4sBP5K1uUajxM87imM=
X-Received: by 2002:a5d:5f93:0:b0:427:7b7:a86d with SMTP id ffacd0b85a97d-42707b7aa0bmr9103581f8f.36.1760983930382;
        Mon, 20 Oct 2025 11:12:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEezL7AaIekGNqezBjICBE7lEIcoDBfCrMqAs2a22z/brgEXWKimsmX383Ot0a9rGN/hfL+g==
X-Received: by 2002:a5d:5f93:0:b0:427:7b7:a86d with SMTP id ffacd0b85a97d-42707b7aa0bmr9103551f8f.36.1760983929968;
        Mon, 20 Oct 2025 11:12:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3c34sm16290570f8f.17.2025.10.20.11.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 11:12:09 -0700 (PDT)
Message-ID: <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
Date: Mon, 20 Oct 2025 20:12:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BFxYQisuXfSz0yXnMihht3pGAC9e9PSZeEkjE6Y5fd4_1760983930
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: yz9qykcdqjkg4xajhc7kw6fm87gs85d6
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D09D4000E
X-HE-Tag: 1760983934-947464
X-HE-Meta: U2FsdGVkX1+8iPvLNTb+nvu9ZfubimFi9lgs0MqMfIh4i6KWD1xO87sL42UN8DUXapqtJJ4QolMzwndFawnIrYRJjF9B7nOgqhrPtcS9wNa1TI2RTcfNWjmVeZ13CwoTZQjoW43UiBQwd4mm265jzXbPG9pUsbtbJHOsC1DYJQVhqWvojbX1ebfO+eemMKyo5pNhl7I7sKiR7+JWO0/GXOPSKbn0yZ1dFstNIloxTKfDItr8As3t+lHxFXv38QFQfWudH2pZ7j3x7CRVI6vdF8FIxOjfQW6JSgiD6ue8uyLDsqIad/qoy1tTpA8bR6wJPdfykeBY8hlU8ODMdoPGexJvxjlFEMYVsqoFktIhvwErqymXEt4cuBJvPs2spKFmoAzbSQMLDkCbi2ev62Jmeyt0WKqHkZcwzOPXZqpvF6XfO1bwTVPvUktyQkUiLN4wlLpSd8qqCiUfDdj54+d2AC2Sdn8pXr9Re7reLe9EsoB8RD8U796VQQFwPHiFyEucu3G9bTzsRGkycTlQwPbh0TJx6cwWep5uwGfwO6pH/MbnneLIpS0crxTl8WLGgZ9PPAAa4z7e78vd70gyhr3KMBlpXcdh59JM0STu9ck/hLDLBrMtMuxled/M1zcQJv6sdDQV0A90XOrJh4/VVKoNxL99mmDt2jUgf9tpnTqpikWm/5xbgIlsjpOWtozLG0kynDlTPyl46P+P0vsgjzjrchjfrLUbG/boeNxJxc1fd1W+2cIjZUhyx3EMi7o5Ym3ymaVqTQtphSFxNXQiogpfMLnoosvb6ZfOjcTdWs10apFXv2+plLDuAHgY6NBaLgGEN7LjOA2Spt7glCSu+5V7zCuloejkwZAhE5OEX5Li1+o+azzY9AEyFOZJukUAGMssvOW9nQOsFqixLqdnuuQH1XPq8jmdLREbkv4tLs7pdliuDixjIIKHHzNgO5GCwT5BBpUMc7KOVTiMFVG0APs
 BszMp4Dr
 1LuxLUVUXMk7GRWDAzhFkc+zBq37MAfyTY0FBDXvbxRo5g1r9LHFaDl6LMpCflJzXbwFyDqccRNbBzKL0XXv/VDOIYMBNT9Ls33IXMk2K2yo/Zqk8vLWB1XmkkbEmyx9cdzxpWjShomm5dCGeK2SQ/RL8/7rjsk6lbje82hVpeGg8ERO+zMj1XWgQELmAQaz+1JuISHov2rPnIqceEb5ucP13FeF+NVqjUft72OY663hf87iT+rr3YibVShgr3BOFxu+PDEdN7hqrcmcz/1CdbPyeX2j4f4gylu3slgqbMbPCEYg5IEpt559RilpmYLaJQzLpl5l2oCdk3adfHErk2ZpdIq1oP9pc7bl4jwiHVTK7/N63BvbmNu+N1LtCTVO+V9rhIAQFWFdnMbFm4/i41HX5ZexKrNyFLRHep0Mtu6oRMYKAVpoIFTY9i8ddRntd/Nmo2pAcyaJj/3ivmOf3R1pVzRB4I+CUdK7N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 19:49, Lorenzo Stoakes wrote:
> On Mon, Oct 20, 2025 at 07:34:51PM +0200, David Hildenbrand wrote:
>> On 20.10.25 17:14, Kefeng Wang wrote:
>>>
>>>
>>> On 2025/10/20 21:10, Lorenzo Stoakes wrote:
>>>> On Mon, Oct 20, 2025 at 02:18:44PM +0800, Kefeng Wang wrote:
>>>>> The prot_numa_skip() naming is not good since it updates the folio
>>>>> access time except checking whether to skip prot NUMA, so rename it
>>>>> to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
>>>>
>>>> Hmm not sure 'folio_needs_prot_numa()' is any better in terms of indicating
>>>> that you're updating the access time to be honest.
>>>>
>>>> Also it seems to suggest that you're determining whether a mapping of the
>>>> folio should be made a NUMA hint by the folio alone rather than the reality
>>>> that the mapping is being considered for NUMA hinting and you're checking
>>>> to see if you actually have to do it.
>>
>> ... because the folio doesn't need prot_none protection for NUMA hitning? :)
> 
> folio_xxx() impliles to me that the folio independently has proeprty 'xxx'.
> 

I would agree if it would be a folio_has_* or folio_test_*.

To me the folio is really just the main entity we are querying 
information about. Not the VMA, not the target node, but the folio.

> So it's like saying 'here's a folio, does it NEED prot numa?' right?

I'd say: "here is a folio, does it need numa protection in this vma". So 
I still don't understand your point, unfortunately.

And keep disliking prot_numa_hint_needed() ;)

But again, I won't fight for it if you have strong opinions on it.

It would be better if we could have discussed that as part of v2 to 
avoid having Kefeng go back and forth. Maybe v3+v4 were sent out a bit 
too quickly

-- 
Cheers

David / dhildenb


