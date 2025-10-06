Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E90ECAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 08:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC53C8E0015; Mon,  6 Oct 2025 04:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D2B8E0002; Mon,  6 Oct 2025 04:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2B68E0015; Mon,  6 Oct 2025 04:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6208E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:20:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39D7987843
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:20:13 +0000 (UTC)
X-FDA: 83966991906.13.94E8EA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BB8FC000A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:20:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qkv6EwEi;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759738811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNWbwJVOYd0DTW7b9TuxnJLCSZ5L6JONscYQCHG9VH4=;
	b=UPAYZuaQWS/zv/RKK49iRr6K7nxHewh4oYmtD9icrh/koqxK39him/oBv0JORKSUQNUQCD
	/B6IgKdtRGl4bR6NXVMefyOYE2iEI0RT1bOjBL7Q7dTYv1bt8a5FxSUO3+vKaD0wfSmJtN
	TWyOPn3h9GLvjIMLbtJbK8csyJ/ZjTI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qkv6EwEi;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759738811; a=rsa-sha256;
	cv=none;
	b=ic0Fi89P8P5o1lMmnDcJfeOD+SSRBnUFj2hVxPES6CUshE/qFg6kOIVopzwm5TQSU5wYZq
	TkfEK0AAapznT4FGJZz04ve+SdnDQLAzNsmq2bT/uSOK5K5vqLXmfFK8vYPu3bGlCw0pWE
	yAYnmo7gDhO2tR81PYFPR4jWWfg6d6c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759738810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SNWbwJVOYd0DTW7b9TuxnJLCSZ5L6JONscYQCHG9VH4=;
	b=Qkv6EwEiKgBZJaxH2EIuewQhO80XraSdqckSTuA9wTWUclyX5gx08iZSvZj+s1a7uOebX/
	uJMnb5Nx4USK9MEdCHhW11zvjm3hcklr8Mdns1hwVr1HDt9YGUJzSv5bPh6ObQTeLmQwfv
	IgXxkA2C26TUwciUUNfluGRVxF8bS78=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-RNfUjL2jPFmucG_b79e1Yw-1; Mon, 06 Oct 2025 04:20:07 -0400
X-MC-Unique: RNfUjL2jPFmucG_b79e1Yw-1
X-Mimecast-MFC-AGG-ID: RNfUjL2jPFmucG_b79e1Yw_1759738806
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e44b9779eso16382775e9.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 01:20:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759738806; x=1760343606;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SNWbwJVOYd0DTW7b9TuxnJLCSZ5L6JONscYQCHG9VH4=;
        b=V1Mmi7pVkzDDiHJkkwkEiriFZRaCqYMPUHjBWnKgxpmTh5muZVk0iHsJ6+nzc3lpeR
         xC1VBXnT/UFecX12Kl11088ceAH+5ijWALhw3CIi0ZOHC731w8ZtmeMG2s/Nr3kCXTw/
         8N1MfVOhr/wR8PjhfdGPr4u7qELcQRDwulOmup+jcu/ikl9PMD5mqtMIphMRGuJanTLU
         YaaKOdjfVzoSuS4fjxCsy4d+0hz/rFVbdPMCQxT/Or4zo30+Yk8/UyjgLBN9PzLmJf1G
         wuEr9sQTedCgdSH51GGI7H7GxdqLHjXWx3hTdtVTyOXdHVweHw1WkVWbA6Z3bovR2E4H
         n6aw==
X-Gm-Message-State: AOJu0Yxo6ChKI46DSIKAJ4VUvgo8a2/L+ngZ47pNC2Immu1nZmnHQkXo
	w8aeove+2hg69DS8ta3aDAEcEDHo4LgcHw4HVeP6e9qk+8S41LGbLn3LU1mm78rsxiCa7tfZviO
	NZcg5MfyjPnzr2Xv1tFvj+dii1qhBxv636lXfiVnMpdSYnM6KaAcd
X-Gm-Gg: ASbGncs1Lbo2PHizMg+ZlfOrh5c6AEacO335WfdJ331WKI65pVucyP7AYi/+TC0sLQx
	lxZpjLWNJY+CxlAMb4V9rgSatZOZyvsUrDMQI5+IU5kqiPJmPj+l5O6y3jMfKeJaFm2rfCm/4XU
	lxwpczpuYNb6QdgkVyEKweE+4k5qvmbX48iaOY3+pvGHDPVQ8W/Bw2DbkVkaYANCD/4yMn4N18R
	d9vd/yAPGYI4FdXsXjR7TKR2iDnMXarlJJ5FL3UVleerBV96H4nzn5bGdhh1jRE6w2HU7fgQIP4
	Dc9S59cTwVgadkp453YdDiJx+e9ILpqRbipFim/SUD2w/oFjmzFH2DikGkBz80XHTTLpolYxNh7
	vuQMr4GT/
X-Received: by 2002:a05:600c:34cc:b0:46e:1f86:aeba with SMTP id 5b1f17b1804b1-46e7113f7a4mr99635775e9.17.1759738806048;
        Mon, 06 Oct 2025 01:20:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZGMW4G0SvfowBsrSVBanCS1k+6aA94DXgDYJc9v/1gFNyYsZQC5pbzAfDOzMb6sJmk9iJJA==
X-Received: by 2002:a05:600c:34cc:b0:46e:1f86:aeba with SMTP id 5b1f17b1804b1-46e7113f7a4mr99635405e9.17.1759738805597;
        Mon, 06 Oct 2025 01:20:05 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b86e1sm239387935e9.5.2025.10.06.01.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 01:20:05 -0700 (PDT)
Message-ID: <d398bcf6-30f2-44a8-9721-1c4c763951b6@redhat.com>
Date: Mon, 6 Oct 2025 10:20:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: Consistently use current->mm in
 mm_get_unmapped_area()
To: Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251003155306.2147572-1-ryan.roberts@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251003155306.2147572-1-ryan.roberts@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BeGvQbu2yXdDx_STBfFGAjn-zS8v27yi37Fj8dssLRM_1759738806
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1BB8FC000A
X-Stat-Signature: neqscfizrpmfpp9wsgah51zmd6c65xce
X-HE-Tag: 1759738810-2473
X-HE-Meta: U2FsdGVkX1/hcS3hSozg23FWrIrMrdcE6mt9x/Gx3O6eFvCOphgIGOhs51Qzu06a3XaHLQCtmpdEMRziHd0IrDMxYZiR7jKU99/a0vogxJsasqNlKRuNlqzcm16ZFZDoSN4Y/qqDF9iVs8nekP6z+KsAoYjcDzlUrmh57YQNQ0jhsyihK95yCzAtjJGglrdZMmLDk6Lu5nQiBF552ZLn+Q5K1CN1KO/qrzUR3+YrIQeyQ2ixF2/OM1FFyo19tjbjiqqRQ091kobBS3K9KLnyAY+QqpPI5bhPf4ZXOAD/FoP0j7f3ZDTFRNg1+lrqCmWyGUj6a9PtmGXr2rEOiHw8jMzTiACG4mH9e2oKg50jQWzAD8bK45ZOlg1dfP9+IN880FmnZKRDEXNgv28wjBrGjbWWw8ZGqKV24z3r7U22fVnQoGGC9WT990CB/gf5w7k2tlFB/uAZ0NqARvf+/O7+uDZIUqiytrDdVAIpXSfDWgXoAkbC64YIOo6M9dnPWViFXUnSVGtqqPbDVGaLHzEp/EQlykZMiS0dZO0Gtrb+TbfR/NmgoOBzxHjvclqFKl8ZZM1kZJ1j0K1dwwujOKfOkcO8h8W82slR0Lb5ZIoXLOKU5PQVAYKcg9iq1hmHjHo8Pwr+Cm1twYj6I13GPt7t2j5BwhsFEzXbkoB3Fu2dL/XhgiexvDhdXOIrtxQK4WETXK2/BTZ3uy/DT04PIEoiEE2Kd0XmChAmytY41ji5oSSebIcJWKSgFH+NXL4VJJVd+/d68IbSYeKDRDIUVfZTQrsH3FPTbzgRDDJYm2yzReAiWm6TXf/TJhDZh1k2vZSGqLGxbRR3wHoz0sTlIoWGQd5aY6x7K92q/fkHWwS8hic5BqcqL6+ylsdSMo4/X9cdB/0MjVa3BfmwT8X3itfZGLYTU2mv2dKwaOlMVwxqB2RW/s8aNObHrPK86j8pz0C3tS+Fp+3i7VrYuBaaeN8
 oWVNqYB1
 1vzjVrcJnsJ+PZoXBsde8YTxNx+NNgFqEWhudPwXkfqbUJi+SFq/EB1C0yPHv9gEBw5I9Ik23cbjlvZ6mFqXHjHJ4VWokv25NfVd5nZqN60hDHPEUSFLkh9mNxl0S7wCJMtKuAkU0fZEUrI5t2HJZb5ktiQdmK1nfWKBM38gD7rlvFhiRPA6iRIgRIx1wV/Mef02Hr+4qhMqeUuWKbdNyxLHHrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.10.25 17:53, Ryan Roberts wrote:
> mm_get_unmapped_area() is a wrapper around arch_get_unmapped_area() /
> arch_get_unmapped_area_topdown(), both of which search current->mm for
> some free space. Neither take an mm_struct - they implicitly operate on
> current->mm.
> 
> But the wrapper takes an mm_struct and uses it to decide whether to
> search bottom up or top down. All callers pass in current->mm for this,
> so everything is working consistently. But it feels like an accident
> waiting to happen; eventually someone will call that function with a
> different mm, expecting to find free space in it, but what gets returned
> is free space in the current mm.
> 
> So let's simplify by removing the parameter and have the wrapper use
> current->mm to decide which end to start at. Now everything is
> consistent and self-documenting.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

Yeah, that looks better to me.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


