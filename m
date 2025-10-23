Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401C9CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 19:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD868E0009; Thu, 23 Oct 2025 15:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A55B8E0003; Thu, 23 Oct 2025 15:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894578E0009; Thu, 23 Oct 2025 15:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77B2E8E0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:38:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4300F1A0C48
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:38:19 +0000 (UTC)
X-FDA: 84030390318.16.2A1FFE0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF95340003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:38:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QkjyFc65;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761248297; a=rsa-sha256;
	cv=none;
	b=OHYfY9mK+tvRajbrFQMy0SeNTzdczuX/D7EVuANswGa9darPkKIRutGelgww2wXHom+GDv
	tEdQFnZkUVritVBTkG5QAoisQH0GwwQYLCyPFU1KHekNBt0JDUrQn7y48+dc9x6rz3M60u
	/LYIuoFNGG+4bJl6iW6KBn7jMVm83po=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QkjyFc65;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761248297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQ7IyiPkbQDl/6FlpFFPP3SSIBn2cmNYnYEr3eJHlB0=;
	b=7qofaPF+50f/KkpdrtKlpUrv1JG0xWS8bnhR2DP0wH9SZl2DMDed11qdX0liaCDdM5VLt3
	x7T6nXWYiVg5Gxb3HxNJa3ygTR9YeNL1aVXqJTiTYUQdG8xwxen79FXtR0C08RNH01VqNv
	wYfnrLWRHg5XfFSFcdz2HdCc9yUvorM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761248296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VQ7IyiPkbQDl/6FlpFFPP3SSIBn2cmNYnYEr3eJHlB0=;
	b=QkjyFc65kpdNxryx1WPWWOCWXMaD8niycaI+HCyTEaWYS+WBVJK3umLwMSadZUCfgMs9io
	crQIyv+ql1Q/DuslTukWBpiW5wAGnrp8sRgPgXtQ55o6DsXZrP1ND1M1GawZj+EduKunDT
	wyGaaejFx1UlazlvjbKSOmYxDXdYuB0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-2lZVgonsNYG1uVumv0BQmw-1; Thu, 23 Oct 2025 15:38:14 -0400
X-MC-Unique: 2lZVgonsNYG1uVumv0BQmw-1
X-Mimecast-MFC-AGG-ID: 2lZVgonsNYG1uVumv0BQmw_1761248293
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47111dc7c35so9582875e9.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761248293; x=1761853093;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VQ7IyiPkbQDl/6FlpFFPP3SSIBn2cmNYnYEr3eJHlB0=;
        b=GWGfnTeU0wmhUruqPDGJMiCeO2EK6m3ndURN4/UuurzsHSDTW6cW6BbM/SN8ZGZ1WJ
         zRP+pola6S0poS+EJuJ73h84bhP6UWcUPThnr5YaovwXQF1T10Jdgx/0vCq9+UW3HZTx
         tCUaVf+fnaEtR0l7jKAOeHJmmiy2vE04fp5YB1y8HWfNfAg69vNezgs/TN2Jyi/EMvTP
         MFF1jyXbbgCWVs9bnY+TX5y3qLIGsEfZZj0wL1cy+n9xsIaee3XHBEG48Xh40w6etfrp
         we8xj+A2ZM5LV3RyCacebXt1agJU1IyZVemjOAERJcbIJKXJUc5x+3sYNkDltkJ0k8G6
         Rf1g==
X-Gm-Message-State: AOJu0YyLvrfkA8H/AxPv7SqKzZ8FLFMT0vitKMlfyFJ7JB+k5rvEn+iF
	Zcz6g8/lVuuRHvmBkkSXbNhIW9PPkq82QZ0x0bYJ0Yje/iy2JBwtxc/Q425qfZIGFTpWS5Ut82Q
	FMgqxvw7kb6yBiQ7ff0f9gfZpz8qiRJiqm64JYC/6XgM1atTyXfyx
X-Gm-Gg: ASbGnctFRAq+5ZLlpKBnbovM+8b7mUUropCgWlN9k51P/myTbKP6C2yqbryxWEnUvBZ
	P8sOzg/i/a/qMLZPZWKOgYkyzvoGoTzfcapUgXWCxnrR/BPwA05bzOrQAdrfbYG7mkY6lIK24jW
	JZNeDVbjqlgbXAzTdPQYJu5e08ZDLdDhMUxtjWRut6Rn01CqfKSx3zBeSvfuJW+M4f6vPHixQM7
	hSC2nM98fGBCfE/FCxA68Q69lyBC5GLWZgZ8btCUSN8qABDsq9OJ+WJNcqeXD0KnlrBsJHhnOPV
	GmjqfdJ+I5YP2H7yoTe4T8lYh72qj0H5f4cwUrPuqj5mXC/dblIvBXR8U1UIwkVhWOn3/hxvR21
	7k/h6romSaJyKhJYLhvxuEyUZSroyAmFmCRwQHIJGvuA29GnTVTmci5qCiganY1+aL9t2dMWuIa
	fOmrJJb3hJQDPuu3f3X1HzeqpoM5A=
X-Received: by 2002:a05:600c:3145:b0:45d:e6b6:55fe with SMTP id 5b1f17b1804b1-4711791e7a4mr225365345e9.34.1761248293291;
        Thu, 23 Oct 2025 12:38:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFK4kvb9VXDfRke79DTEDXEtAKVHmaVqzR/ZxHwP2FSjJo/KXXf7lv5KID4JKHr2iZrwUPcWA==
X-Received: by 2002:a05:600c:3145:b0:45d:e6b6:55fe with SMTP id 5b1f17b1804b1-4711791e7a4mr225365155e9.34.1761248292920;
        Thu, 23 Oct 2025 12:38:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898eb549sm5405252f8f.41.2025.10.23.12.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 12:38:12 -0700 (PDT)
Message-ID: <dd3011ec-23cc-4431-95a3-a0c2965e7062@redhat.com>
Date: Thu, 23 Oct 2025 21:38:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/13] mm: introduce CONFIG_ARCH_LAZY_MMU
To: Kevin Brodsky <kevin.brodsky@arm.com>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-6-kevin.brodsky@arm.com>
 <aPNjd2dg3YN-TZKH@kernel.org> <3836a43f-809e-419d-a85d-74606d9daa0f@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <3836a43f-809e-419d-a85d-74606d9daa0f@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v-HLICtvR6IoH1tVe9uZBRW-PyKcjUpskUXazwtUJCU_1761248293
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BF95340003
X-Stat-Signature: 1ig644pz3rz3sbi6364jwx6xksktbpjh
X-HE-Tag: 1761248296-731232
X-HE-Meta: U2FsdGVkX19ZzoZRGsraoNBu9iCkbLf1k4AY8fXPh6CD+iMa2QNpFIITShNiGXTdZEQ4ovjdstSy7glzYcFIeL2MqeCNDTzB6jEGxwTWbymLsA/wSClVlPQq88MysUxe02Nxjgm4VypT0ziHVZkHqy5lbAkcphUEmxzKLJ2AAe3wJiFl/Y3RM5/jqyrk54MTxeQLIONAum4mpTViUSc0jJkStGFu0zfZzkwPB9mSYlluI6mlxAG6wGkTTIlBqsCJraPFLMMbIDRVcaY3FHG+RoCHkFb+9lw8MafLzNE7o8iRgtu2ozzea8txATbPydXgL7IWPP/xjO7LtG7A+DSocn0jINTH8wJJJyP8XBcN0w2YO32SLKWMHHRjIQ43T3h0saB+0uzOEdl5Is5EgcPTVuwATjGJRfRzYj5rZp0vdHTKTIfE3Odf4ObdBj+eQ5ywWc5mK7KfpzgXIPmcVkrG3+VfBTH2elmkOcfGm9cbQ8YcZtikXIMitLZWKZdIgfTwF9Qxf4uNRjj5fyYvmEL/TOeaHO4tO6PoJDf91DGyrAnTjlX6CAInImamdWiQVsgh7Jv/jl/LGk+2kODPDbZ48oPR8Oi/vST5tzpy/BeoFj2ug2wV5hrmQhFcZi2fn2jRviQSlLE30/TqDp5CpC6fkwb8+djI+KgR5bntz9nf/5zYn3oJIMiAj9vT2FK12+m4dhx0ifmS3AZ2TK7mUAr8cOxfEAqzZ7t/mcS6hIxlwI97j5t+Aa5bpj837qm1wgFEXz5qJTewp8A3gTnE6FWj4BeOuQoK3JOemGuENFZPGtiTyk0+/DvMjxLZZyh8d7VebT/ypZ07VIEeogxESiiA4Uo7pjIn0e5T5POkednKsLPM7qOmsGH2Y7+bhGOd3faBQ3m5VJ89BsWdQyeoDuIWbSlj5jopqXAvUwDTJ0LrAxxXIUEqlMVwCmT9Xb2sjvy3WG+2WFTXYVaxv3wGz1H
 4u5ln2LS
 T4p95E6SIkbEFQ+RoSHCDI09sFsU99aSoPb4Id8BHPAQsfcfl2Rx76N3lMEriBTjUAOUpbOLWFaRxtOZmYxa11Ab73fnzvYLfHXSo0RmyBzeer1o8kFlfuS+Zn/HuE5g/H3XY2vchDeRiKtBsVM+08qz/K7rfZPD+sF/eE1Os8OUEO79YgNSElSZl2k+fhZWsmPJVKOLsBJS519fK1d8gSH3FQV1k5bR+SHqrkCl7KEUcWZpUPVDcBts/0vqHqnjPkf53h+a60woVtbTq1XMGguxoPvyPz3Bs8ryhauKWOZCgNsFNvgC3SSmfj/d7SxTetqFdzf2CHLG3KjGXkBWGkCa/8G5PyGWq55D306O7yJYYhYYChCuoUDs9uDCuyMxojPN3hjFgf3uGuGXXuqJZRqY+YTcOOMBMnC6JrEmr+NAwgGMQW7p7WKPSWncjvp5IdVvuYsZSG9cxF0Vj3P2yh3PrxIgmxIUE0J08PTCD4m1UwnWgGi95Gc8ddM+1pFg5I4fQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 12:37, Kevin Brodsky wrote:
> On 18/10/2025 11:52, Mike Rapoport wrote:
>>> @@ -231,7 +231,7 @@ static inline int pmd_dirty(pmd_t pmd)
>>>    * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
>>>    * and the mode cannot be used in interrupt context.
>>>    */
>>> -#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>>> +#ifndef CONFIG_ARCH_LAZY_MMU
>>>   static inline void arch_enter_lazy_mmu_mode(void) {}
>>>   static inline void arch_leave_lazy_mmu_mode(void) {}
>>>   static inline void arch_flush_lazy_mmu_mode(void) {}
>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>> index 0e26f4fc8717..2fdcb42ca1a1 100644
>>> --- a/mm/Kconfig
>>> +++ b/mm/Kconfig
>>> @@ -1372,6 +1372,9 @@ config PT_RECLAIM
>>>   config FIND_NORMAL_PAGE
>>>   	def_bool n
>>>   
>>> +config ARCH_LAZY_MMU
>>> +	bool
>>> +
>> I think a better name would be ARCH_HAS_LAZY_MMU and the config option fits
>> better to arch/Kconfig.
> 
> Sounds fine by me - I'm inclined to make it slightly longer still,
> ARCH_HAS_LAZY_MMU_MODE, to avoid making "LAZY_MMU" sound like some HW
> feature.

LGTM.

-- 
Cheers

David / dhildenb


