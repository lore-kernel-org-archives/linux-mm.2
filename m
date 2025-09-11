Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84993CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF8A8E000C; Thu, 11 Sep 2025 05:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F918E0001; Thu, 11 Sep 2025 05:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57598E000C; Thu, 11 Sep 2025 05:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC55F8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:22:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B2FB16030A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:22:41 +0000 (UTC)
X-FDA: 83876429322.06.E2FDF86
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2112B1C0007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:22:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EIR1aPlq;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757582559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlIY77OqGXzNcygBXjtu96M6CtVN4R5XfEMEcIT0Idg=;
	b=iwkBn2t+bnxqIrG1OVYGjQYkXcehOGXjiHcOcDyzuCBYwu7E1pWf6P66EWPhMM+reIPUDm
	gwvlRiHYICsQ4aLWVqownJcGBnnGiw9zpLplxkBb4JCILGGGZflbg1HdvcuHgQDQzN8dfY
	j5A39lHH3QK40epVZ8VG+Q7EfoHplE8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757582559; a=rsa-sha256;
	cv=none;
	b=pc0vpqzSQdfybhQ7JrkehqwtHVf8rujXVqnHj/MIhN4QA/w5ntWq9Cq0PnVb0xTpw7i4ep
	1MS0FEHApaU1BYdEvKxfc0/sM7IJAsNhYSNzAAhvjBja1MAQ2rsYo9Czl/tXmgIn9Xe/t0
	l3Vh76BvEb2D0sIp3bPWj6i1RswUxSc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EIR1aPlq;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757582558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XlIY77OqGXzNcygBXjtu96M6CtVN4R5XfEMEcIT0Idg=;
	b=EIR1aPlqGHPNbWHLgBS5mIhh+fhdAraOj1Lvhsp+7SLDji5N4LOJ6TABkV4qRR/ntoHPfR
	34M8S5XdJ2GcNnRMHLLLgSwLyFGLN6LRV2NToH1OPXjXBfKTpnR9AK+C+p8soXYA8iJXMh
	/TGjzRQvMU/mlTWy8/poyNgr7jPEGCc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-2SBB9LnWN1uzbpKVgAcY3g-1; Thu, 11 Sep 2025 05:22:37 -0400
X-MC-Unique: 2SBB9LnWN1uzbpKVgAcY3g-1
X-Mimecast-MFC-AGG-ID: 2SBB9LnWN1uzbpKVgAcY3g_1757582556
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso2901215e9.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757582556; x=1758187356;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XlIY77OqGXzNcygBXjtu96M6CtVN4R5XfEMEcIT0Idg=;
        b=jQcuNx4Bj8wOpLqVYEZodUCC8N912H6JsKpDAVFAFUtsGNH66HdJs5hz29hD+uPIPb
         Bor2BCd5FfY/ZbFEs2gsYEvSmbruTA61Nu7H5SFc+EprPbuLgs1LKqTTvTcrnczjmsYv
         m7TDNkVIyK4JMUt0UaM3CY7CpOmnfc8DGFgtMqFXcXnyf2FZ+VlDyR6d28cgBBIsq6aF
         8Cijmb03F91aC0r3KNJzkkaP6DRK8/g4URCcTJmO50O3RzPrwjSPzGvgRHv7n+RJGsJv
         hTfE49B+/Glx44iJZXQ+9qurOaiM4ywEwKD34NMCF/LtUaaMt6l1q+mVOEFg6c2t2aJu
         rH1A==
X-Forwarded-Encrypted: i=1; AJvYcCUhNJEzYmx8oRdjWPQkZCGjFxX/JvVvv50ynazLIlum+xV4Ch6J/LqNg+WC8Fd9NpA9bMVBEPL7YA==@kvack.org
X-Gm-Message-State: AOJu0Ywm0AXjBf3dbDO+KgOL/1QueV2Cqoel1y2VEjFZItAOB+tBMXvO
	q785QBype4VKYDJhpvyLmWu87tUwDAYVTYgc+BbafFBij61tD5FiANQZTv9JoEAoh5P/QxTdzbV
	rDB4haQHZ+ChkONpMAIxtOm/vFCIhgutjwFzlCSr5CpVu3h3pYhn7
X-Gm-Gg: ASbGnct4A9TAT9f+Qw/iFk/o9uSsxhXkMhi8VRGm7DNxTPPE6ZomjbItwQ4iuOX03Lz
	EsYuv0g9T+fOF8D7xYdZgmWHa5KFmZUk4snN7YFX9iqofNt1R3x2+Mk5tJ16YWZgSVeA7tKiyRP
	WNZMGeZ8WmTjw+b2lQtTzBmO1PxrehILx4SYaOKA7ayrjAiPuLkTRlImA71nx2on2FPdIhseA+q
	KzFXj7v/WK/xXZjSk7TIrNL7l6uF9UqQk8Y2RD52bKLEIFWF96aH3wreTScHzvB8L8CppMMvSEg
	TGg6yYOaBtBGuNUAFUjBKwPLmrHKQ3BDGufPZHUzWecxWeVQLF9PIQNS/l2lWAJJ3vLKfc9cEU7
	/x7rlR52E4YH5kzKX5NIkHSdnDAWwo/WARTRTV7bkU2l4oTu4zf2ytH4I2efxCGci5To=
X-Received: by 2002:a05:600c:45c9:b0:45b:97d9:4127 with SMTP id 5b1f17b1804b1-45ddde88188mr158168235e9.1.1757582555882;
        Thu, 11 Sep 2025 02:22:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWbNRfXbRs0WpzaUFArlf/GGodKR5SPmBVwxNVpsnCRj1ui246HIUyFHPhNTL9+yDtBq71HQ==
X-Received: by 2002:a05:600c:45c9:b0:45b:97d9:4127 with SMTP id 5b1f17b1804b1-45ddde88188mr158167895e9.1.1757582555471;
        Thu, 11 Sep 2025 02:22:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e016b5c5dsm19695035e9.14.2025.09.11.02.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 02:22:34 -0700 (PDT)
Message-ID: <59283f53-e249-411f-993b-1ed50f899c42@redhat.com>
Date: Thu, 11 Sep 2025 11:22:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/9] mm/vma: Add limits to unmap_region() for vmas
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
 chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-4-Liam.Howlett@oracle.com>
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
In-Reply-To: <20250909190945.1030905-4-Liam.Howlett@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J8_2vsp_xMdPBfeAGJKOBW_LR1VHLwCdzA_IDHmcQXc_1757582556
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2112B1C0007
X-Stat-Signature: nprc4zxtnw8udo5oygbyjppoztn3tra4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757582558-154574
X-HE-Meta: U2FsdGVkX1+JiYm6626fcPxiofvUDcFdHlG0roZrFn+/YCSbm6RfVunZSiO15RJT2weZFtId1uPLExPMSqx92ZZqho08VyyOUo9aqdOFgZlqQjLhBehO5+HmgQpertkNiJvzkB1TH3+3jP4AHzusi7/CD2aIW0L6lXWwY1ld51AgUtZC6zQVNzxzHaAKjru5O7U17+hA2zGsEWyK9wNm75GfhoSS4fsvGp1QpqhzSYmZNJB4LzQCgetIG9ELqDULc5BWF8GMYSfkcOhmRvLQIssHctHPmucv5mYrFtEhBHQqs/bVLQ71MzDc3P9yDryT0YKXTnyCgAVa1yOhVAOY9qpRgiAGZaTon22z54+jHypAHEVrlsoqwGvowTHYaILfaUJxQ4sEZW9uY1lUNMRJvQIkIQc7XeJYtlxbG7yusdASpql3WDAYuGQ8d6heE6JnlZWRgqbEeKnd3umMOf5xfEvSx4Gb8yRgMJz16pMn5NK5dlJu0GeHYxfwJAkwJHDRWppF/CcPSEmgH+haP0Sk0He4Zqnwl8Fd0OwXwQkKJ69OeiwMj+DVJm/PKewGwbnhZPVXnLjKlgDo6BFwBWXEH9FwkP5DvPGETsWh7d5mSRO/Ld1Ll1cvmU8QT9ZuTVFgEG/R5gPp5WyFF70jFzm+y2rGga1PYEEDX0Yo5xTvEkwiKjTZz7fxdufMfIUC1iQ/qUZj3FlMsqmWIups+x2HMoJi+pU6P6FR/2LsFSju3G5Qe7bJFxXHLX5gCHC0rR0XvfYfgCNCprIBjNeIHRokrKZGnC6h25Q7lS6dM1Sh48/ZKZklHukUvrCXUxmXyKbI6QMNzd5wc/gbZ6MAaltNRshudiJjldMkgtlTFE5qPDq0Vuy43CnsCAK50b+tW6g41uNWauuL3s+0HbGBaaJxrDTgJ3kFWmLYhpKwdZZQPdt9U92H42SV3wzW5vdgh8yrTNWo1e47Aqxs+eHlnKd
 YjGPRPbJ
 djayYB2JsQrkkVWzMZ+3STR4NbRWf85SknW4lhsfDOcJJzMJKfwgD0T2FjNwCM1FoWvHE6c4AGdRL3XZZ0Vb+RnWg+sAqbiU8RSlIe9RVQZRsElQiSjgeE8moSC8DDPWsz1LH7bX7e7WaUXU+sjZhIulgJAKFgGwuF9oV/ynwV2wqjVWadCGfM1GSJk83onEmgExRDPyXk1l8/7bsm8ueDoCaYiJFculNWFUrUkCZTyguYtMMzslA/7MHqkjGIJIPkNAfKEfX4VWesPx359X4IwW5DMNBkN0t7eAT6xHSX71LFpOWw1C/iEVsNLIpC6tKEvm1Pmm2fmAoCrXcB+tIJnSPnInFllGs7QOZESvhl7iGwBAjdM1u1NTo9fcDIdAQUoTB6yoF3FRsa699B0cNBVVmwuGn5yeACCiJOVk5euX5+bEZecp352j9C6yy+XQKZr2Jbmlkm+OgBv6ISuK9YeBPomcyNsYvPA8BqIa0mw1SaF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 21:09, Liam R. Howlett wrote:
> Add a limit to the vma search instead of using the start and end of the
> one passed in.
> 
> No functional changes intended.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>   mm/vma.c | 6 ++++--
>   mm/vma.h | 1 +
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index abe0da33c8446..a648e0555c873 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -474,6 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
>    * Called with the mm semaphore held.
>    */
>   void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> +		unsigned long vma_min, unsigned long vma_max,

Why not call it "start" and "end" ? :)

In any case

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


