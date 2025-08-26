Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2049DCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D396B020C; Tue, 26 Aug 2025 08:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63ED86B020E; Tue, 26 Aug 2025 08:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF326B020F; Tue, 26 Aug 2025 08:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36EC96B020C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:50:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEF311607C3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:50:17 +0000 (UTC)
X-FDA: 83818891674.15.0FB09FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C7EE40015
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:50:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xr0cEiuL;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/ZzIPnEPRb3Z7125pHBltKneF/N110zRMKr3civ4Hc=;
	b=w27nfizzgsj8SOwG28nMjlUtwnvs6ezpRnJIVoHDV9demaUnaAaCqt1YBNYMGRbNoMN/nt
	b1jKKThsrALJayMu2aPS4vnKmPnM7+7IY3tAwYruHDxs1nqltOsUW3DmiW8mgeHjab7J1O
	6PIADLhs78Tjkc7ceu0gKHnOiJVQjgU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xr0cEiuL;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212615; a=rsa-sha256;
	cv=none;
	b=n895bKUCvjy8weKUTS1ijTaXFoBF8N0fNiQeGeK7fwmmiTrHytp3ooRWoHP5FNnvWVZqM0
	FbFffmv+VhsUmM9m8nM4JjJDJy6s9f9DTIS/6jpVTJDNhqwbRKeyVeEVeAAqQjqW7u3YHF
	DkGwnvFjyKCIkGlTPv1axoDCGd6BLD4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756212614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k/ZzIPnEPRb3Z7125pHBltKneF/N110zRMKr3civ4Hc=;
	b=Xr0cEiuLeSEdg806y9ZqZVi6b5IRMevy99mA7GRhCPrbMjYShgJvsbmQfrFukY8abqiXTw
	fHwM7A69SJS74vibPUZCo2SHmiQpMvTvLfIzIne6sUnWx5qStQb8PJv6FxNAfJzaX9ZG2x
	Ro09POZznnXCIvbYQZnir3444WaWru8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-mIIy1V-TNvSvCW9m-zWyiQ-1; Tue, 26 Aug 2025 08:50:10 -0400
X-MC-Unique: mIIy1V-TNvSvCW9m-zWyiQ-1
X-Mimecast-MFC-AGG-ID: mIIy1V-TNvSvCW9m-zWyiQ_1756212608
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0098c0so38974155e9.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212607; x=1756817407;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/ZzIPnEPRb3Z7125pHBltKneF/N110zRMKr3civ4Hc=;
        b=r0tOx0QaW857l4+VuNCMl1FHvPFqgdq4au9QmZmdKA0cpUPB9lg0+klExf3N+FZN3S
         lFMvDpmr4GoQPOk6njss+M1MVhMrxsM5Z0TST6lBmmQpzQMTTadPMimKtXVvanSJx+xF
         wWpvDg4SUHfRBt3a+3o+NCgq32ZilSlelqeZvkT2RsWEGHVlNIv2LR4nEEc5dpQXY3RK
         FO6wnyT2s44kAyBhskdzLh9w0hdXs5cYQK2Dx4bJdmr1nzU091iXaMyciiRB+Hcn9Tcu
         2BrSRaMfdl1EJIHVwnw2+WuFuAJUZ/xpREb+yJJHj1fOqba6Z+rHXD2x3rUqLZTVqd/u
         Nslw==
X-Forwarded-Encrypted: i=1; AJvYcCVHJLlP3vsj2xQhWVrp5zJvCMHi0mAUm4Fs9/aFH2SY0GbIzXa7lCp9pVM5e4/uAYY7bP2ZRJ1YqQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9cwrHHFGGTcbfCJTGC2unRmtMi2iEF6BUnafnzrAsK5p07wPZ
	jpof0d+14yaIWLa9YmTbmcqBGcitPzOSnUR8lKJNFtypKlRaA6QxOnJtv0Up2g6NIU76E7EPGYK
	6YpxPAmOHEPNCYjccd7+pZXrchkE28T6yUMNXVi9GntWuvlunnEhO
X-Gm-Gg: ASbGncsL8sHx/MHto89As+ZZuLY2iAatlSUnyejj0ISoxqsdje8/MRDSIVLeGyLXiB7
	Qp7sFwNx8pg/51vrGpLLDYjbwUQnZnI98nmB9S0qeG6ThS93JILf3tGDDa1Aowq5OX6lkc5z1V/
	8VZ0Vve7uZJTM7V03Va+X2wiovZUF3XOIEl8KUcKc1bOwcqafJlTLQLNz1eK0aMlqG4Iac8TK7g
	mo3RzqSXA5nH6PHhSSik9VY0nGZ7APLMo+SD6nmx1Uy/ov/jDosOncFp9LOdv9alM8zbjU7S0n6
	MuaZXRnvIkVwd+f0PjDjCfhAIiXlHIdActjNdPlu98CJQMB5IHaBQcYNCKKS6+vx+tsOFfmmyA=
	=
X-Received: by 2002:a05:600c:3504:b0:45b:6269:d257 with SMTP id 5b1f17b1804b1-45b65ff07f2mr22263385e9.35.1756212606986;
        Tue, 26 Aug 2025 05:50:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH58UKIEYrNILfoSqM+RsqJQ5N2l7kBLNkixd+780kc26vWEcz0IC43yoAUM2EmQeRVxWaZjA==
X-Received: by 2002:a05:600c:3504:b0:45b:6269:d257 with SMTP id 5b1f17b1804b1-45b65ff07f2mr22262755e9.35.1756212606304;
        Tue, 26 Aug 2025 05:50:06 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c712178161sm16010436f8f.67.2025.08.26.05.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 05:50:05 -0700 (PDT)
Message-ID: <c62fe93f-e4f8-4048-81ff-3f01bd64671b@redhat.com>
Date: Tue, 26 Aug 2025 14:50:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] mm: convert core mm to mm_flags_*() accessors
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
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
In-Reply-To: <1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fWT4ABeMxvWjH23hwCnGrDayvakquJdXhKgLZZrnCW4_1756212608
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C7EE40015
X-Stat-Signature: 5b33k7fimwc1t1n38deptayf9e8eq8uy
X-Rspam-User: 
X-HE-Tag: 1756212615-298606
X-HE-Meta: U2FsdGVkX1/bLy91Zoe1/kmatLtWMDPXPYv0dnfkA3gXOznu4XKJHgUF2+Wc4txIlXFssctqQjAn+57jIP6QOcAqnnO2LUDW8xaVTzD3w3mMznqmlicu24pxtRZy1S8r6XSEc7F5hu9Icvy2v3c17JU3FfBGnN2yM8g+1Br/DrSNI2pYMhHoHZ/Ey2P7Qy/lDrlR0fYXti3CChtvaf8oSf40zPXUkhqwHKGY5+J2C7Kuy311i6xuQOFHjZXxoj+//DA6jtjha1ZSqu8Hk9S4pdjLXx4E8SL3T2Iw2sgjUqM+2qvd1QLmF+eE2WUq90zZhnoiX4wJ+f3734Mz9SW5V/mvDiOIx/Op17nFtF6a2OaomtHRVmNH1zko70s1N2G5LgKpdZjXkkJQCluBiPAqMDF6/rt62TotiwsrHaiqkFjNfObwDsE/qZA30nzM/5wJSbQjqDrkJiuPS0RQnoi6o9/GE5NhpkWh7bFYP2veiwRGDh44NLoPcy1L8ETpDqCkeAWtBWTnbcuK4+X4oWrwwWYb7+iMAXzzUuR+ghsfRWkJcrMJ/QbG8ly+N4Szz5mjFhAyQLYspjWWt+kszUHZ8Apnb2qa4vLj3RNWYQ5DVAVUTKJ4zlzNz//16ZDLb4omyxK11IEKWDClsl5EUGK2bLRWttxysHe/QuuAq0glVSwOxZlXqXjecJIBaW+wbt2NWWurHs5sGK6vBw0D35b0N0p+gk4kNlF6xHAOwkoWQzTv7U5n+2y/7xTCvbVsefLVW6mUsHweatLj8RwegicOe2f04/OZWonx7Z1oeZ5yV5A7/FZtD/lqxocpmsWUEAK1zeLHphi1We1Wfgoj4A2+CDIJKu3juMRlXFc1NdUdzCwkaY3HCX9nikySToJORt3x9xrU0mUww9Wf4ngwArlNLqAwXF+RJldnuK1csLEm77B2XdknlEsxdRJR6kWMUtSrlvNPmI7IzYD1PY84zW0
 OLV0b/ch
 ksnTacOpA8ZJvi/ZAsYtHEA4FHA0HNEZGj5C2rkOmz7jJfpeKr8CTplpPxzBL/jw+V6cF4GF8/FyWwxjprjwGWPIript5ZkHQaywpywOs8kFnVVEQ4qHdAp0fzps07j1MPFZ2OohKe0vaXvBhBkMvwxAeKcvSWBxf+ZB17a4jiCbTJwznxuYOf/Vgnd5b7wssF2ueAVh8/lx2kw2NIKanJuphcYbO/jpEYFis4JtAjj938+FwSpZN33b8M6nfEHjdorS8fmaHBEt+XuC4kyMgFNIf9SXMzHmUWSHwNaRhQqJTfq5QGmeTKukAzIVoPJjtm00UhoYWy82wOdIr1AU162P/XXqwXRz5JtdREH3hb9JOj41O/gAJZTCLGm/KYpcNAFGj4yPnEm/FhU1GdPw9lj6f2NcIeQT5VfvZslYhThrQnnqgctiBcAxmI5+VjT8hMEY7jXEb1sNfqeoIoEbW9D4O+KSYrf0BiKs2NaAN0X3YJ0AZ2cbt6ev5wXNMCb98Ix03INsOz5PjQvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 17:44, Lorenzo Stoakes wrote:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> This will result in the debug output being that of a bitmap output, which
> will result in a minor change here, but since this is for debug only, this
> should have no bearing.
> 
> Otherwise, no functional changes intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---


> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..17650f0b516e 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   /*
>    *  linux/mm/oom_kill.c
> - *
> + *

^ unrelated change

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


