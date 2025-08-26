Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABAFCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A2D6B024D; Tue, 26 Aug 2025 08:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA976B024E; Tue, 26 Aug 2025 08:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692BC6B024F; Tue, 26 Aug 2025 08:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53DF26B024D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:52:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08298C07E1
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:52:49 +0000 (UTC)
X-FDA: 83818898058.17.25A2445
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83794C0002
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:52:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZhcCkZY4;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Vz1R7k8T1KQ49bbM/J3Kx97e9ioYWkA8ABG1durfCQ=;
	b=zrBNvM0GBciCrWeq+BY+OipcpJcendKXjlHIK8Qp7wKhtz7ZvDjtl+0vnx48RDBjsLFCNF
	IsiFGzAcH4dgV2Mf7Sd5es/XKiHvopYNPUDHJifJ+R6Xp4wFgK7stEQxxcupULae+WaQKB
	9+QlFKX40MF5T2f6vsVJBVdpfXWCjoA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212766; a=rsa-sha256;
	cv=none;
	b=k8SaLRVYPphXiIch5+kvYE+LYw/eH0tOn06J41DQtH/Wa8uZiENRhJsrrpYdRRd5iP1Okg
	VCNQlsoAZot2jT9DMgx9z55RCe2oLJ1ZRmIix0ocsPzRhpndysIM9mPNh/DBxRcjITmBdx
	cfQ+hsBw+K2n2QRw8dOYGSU/CQFJxCk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZhcCkZY4;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756212765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5Vz1R7k8T1KQ49bbM/J3Kx97e9ioYWkA8ABG1durfCQ=;
	b=ZhcCkZY4L5aiJc/UjUYaV1Y9rCmifqXZzRESi+ZHv5xVCR/pMPvWSRhffBSS69koXBHLWb
	b6jlQ07/kxhpVrkeCeEGMDz0anKNfIENmWJW3JTBe+5+Ig+vGkotkP1U9+pu498w/2KCiK
	KOtHDEfefybvNaqPZRh/KVk67t7etiU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-KItVOfPqOzOYM_6Lk4qXmQ-1; Tue, 26 Aug 2025 08:52:45 -0400
X-MC-Unique: KItVOfPqOzOYM_6Lk4qXmQ-1
X-Mimecast-MFC-AGG-ID: KItVOfPqOzOYM_6Lk4qXmQ_1756212764
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b51411839so27549485e9.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212764; x=1756817564;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Vz1R7k8T1KQ49bbM/J3Kx97e9ioYWkA8ABG1durfCQ=;
        b=pusLyPbrIxIzTriVA7AoWTv/BClTzi8jze7xSNUIZaWPq6JRPvYGVAHNxq5ZWyFqCk
         DY9NRrpeHkwy4loGL9kX+HHWRn264J+a0YnP6ApnOePevcb7moku7uifYAtyePiqEcLX
         zvfcHDKT3ZfRUJx1IpwVpxup75aUFl/7q/InDHDxlLRfZoGg3SSnd79sq9S94uHtEu0H
         jzu/dYyTgbz9b55Yzqt6RKbDtMVThFJKpVDNaMLCSlW+nPvg6nPDraOuUSnFeLndoiVl
         TF0EYg7RQE2BQPKogMJGFTnEsdnaGm84FmXdudd4tdeA7Sn+LF+W1GjB9qT7+vj85M1k
         mdcw==
X-Forwarded-Encrypted: i=1; AJvYcCV8HToyy7fMqWwH670OmHdkNph/WAMPVFk/Og5/Y/4VnjUXV/g6phM2kUasplTABF6qwaUm4V3euQ==@kvack.org
X-Gm-Message-State: AOJu0YxUzmcPpXhdJaMenAu5Uzy2qSWzyfPp71i+8W8fC7udCFCwxVi7
	94KULirHlRYlaQuLgJqxumJzvVEpKNTxAre+tvF4tE89DXH8aBFppmdTrYRDA1G7yX7uTeXhljy
	fkfwp1BaepGPx8CE5mn+z7NQQ2uFHfTfVSkJxthQ1iNf06AvThZ3V
X-Gm-Gg: ASbGnct24b4Xhc2+e8/RwDwHZ5l80BA+eLs7yWTfG5l3LJQ5JNKUuTBiXrdLNIzGm2c
	lIwJY1NVh8viukSeyryZonuc4eydlkqawyNNEpqiEUk+laRBOjPnpBsnG7BjGOmZNQ+e9DnOCa2
	J9ysOMD/LtfxEDb8W/W7JKrF/cg3iMlO8qLTKOHz+raCSEddPNcYfOnz0IoBPlMgYZD4APEfWbD
	5KxzZwdL7qqQ1EXTFXYUNqMlJScBzgOn0ZMq8XcP5O25i4gNGRSuna3N9Yf5PiBXM3ugc1WXody
	ahNbhoro4+RDDSFrksFCKHi5Gtq9iDIrE8brQkLdQ0Rf0KuEtsrQxfWWj9eutlQmqqX+AXC/1g=
	=
X-Received: by 2002:a05:600c:1d87:b0:45b:5ff4:2f8f with SMTP id 5b1f17b1804b1-45b5ff43124mr61465015e9.4.1756212763440;
        Tue, 26 Aug 2025 05:52:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+M/jeTazxf68z81jh4Va5KXU4ShyIE7qdnSUUsql0k7LYf1+dpn5sXS6z1aKLM87GqMxuBA==
X-Received: by 2002:a05:600c:1d87:b0:45b:5ff4:2f8f with SMTP id 5b1f17b1804b1-45b5ff43124mr61464415e9.4.1756212762973;
        Tue, 26 Aug 2025 05:52:42 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b575736f1sm149280645e9.13.2025.08.26.05.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 05:52:42 -0700 (PDT)
Message-ID: <bb769342-746c-4718-abd8-6f28d2220785@redhat.com>
Date: Tue, 26 Aug 2025 14:52:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] mm: update coredump logic to correctly use bitmap
 mm flags
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
 <2a5075f7e3c5b367d988178c79a3063d12ee53a9.1755012943.git.lorenzo.stoakes@oracle.com>
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
In-Reply-To: <2a5075f7e3c5b367d988178c79a3063d12ee53a9.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VeCJU7x7p9QEmYmNuCQClDr8wnySUzWFcXpb130hocg_1756212764
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 83794C0002
X-Stat-Signature: ddqftm1reaod3wbmy8yin1qsng7qphpp
X-HE-Tag: 1756212766-905545
X-HE-Meta: U2FsdGVkX18PknkswtzsEUUy3c2ZRnzfwaAWNMIMVfJ1snhn5rt9ygb54+7MMG3awj4DX5Hsj3CzEc3tSdtDWCGJ3M+gaU2faWq7W73TgeNJpG8gwFSAhfPyQkNdHMeqsh3Ab1njQ/fw5vQzjJZQ7T24oZyu7/TdGTY7VTKZ0av6djo1SuFFZgKu55NauzjpnIRBr8FkMcJUqD4vlaD5pixQWfiQ/QstkjeiWNXArMTX2jwVi7kaa2YiG2fazTT6yorl8z/p8eP/1fuX7R2KelQrcahqmoUANKbyl6XfMlmLVS9q9FY2A/UHj5n0ZhF72aLJjf5d7GuDCWNHiJSjzLDnoJamIZmn/K93wU6tLX0FDwatKcOK/KUWrcdmDsuZ7VbNMCxkQFtgj939H6PwmNO2UMJEhgR9Odh5DPY9UTGWO2/cudww3z4F8mIAwizmTCr3yQ01BLQYoveeOBY4GWZOPQnwHK7nJ3kZ/8rlLAMKbev0b0sjnMon8ZmULKbdmgQNUarTWILbpEI49crQNPURPHnbeomLLM/QK+R92QKOHjR1LlNWTYZujHvliVA/7t5S45IUNQySvYl7TiHiW8ADM4qgsj9cfkS+qqJOzjFWlHULJLirhrllD+IRRCz8Mnk/fGVkM1xQh7AyupugHMQSY4GF3DqQdgjMlfJoRSTozmUUX5bYNhRB9k3lwTb4fa2fpTLOr2SIXn7GMv+0Jgg16CG1TELAACz/tS9fTpEfukZr63zpsfjJyoBkzXLpHv8pZyxgzkYlN2qqtXGFD5Yxmg4UU3OJMaeBmD3yZsl2OjyXAo8WNfqGp+h6baLR40EUM5iUDqQ8izaYn5ZOxDfHN7Pdn3zH7g1JMMI0qhvTngLVHyb+TcAC+x6a8v75szjvSNXBd0DYh8DZ8ddiWwFHLPBim1qV8+7KD6ur67Pn89jzYTFVIjvIvRNKr3hknlysIW4CDL/BxMZK0Ly
 7LPS9IA/
 CH7GRnvWQTEC/XfC87iisSDcaV/9fV1Slk1KtEspPvEiW6VuiUPd0Im9j8HNnLc5rYlsmW3LTkEwBl4nbqR8iV5qduRjW1qy+DwPVTp21QRONGAq5nWXbKUhjeF1bOyoYRcbfoSg5VBOcAQFkJ3dj8CycbBuhRe2OaBNbWBXhaftj8wmtPPIlxECOT0kS1ApLPqVT1DslKY6bn77E6rJDwMCXTkwzTPKoxOXyQq2I6FORD/PR8X+XDvGsJ9+WlUz4i5J50gLLLJappD+mqf1663j4K0gyWEsD1TqwNguF3c6DUhXqE0NnoWntY/XWmJCi5Q8GN1LQ7m6+sPLiNmutOMCP50isBrNOigFTOAmRS8McySQ2ELzRzr9WRjc6Jso7FAPBRob1Aft8pIuPMEberUNoMKLZE+cUb3IHfRLosu3Ag2pe+48dX87mB1kLbICjnJ9LhEeU408p5qbRltsl2ekZpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 17:44, Lorenzo Stoakes wrote:
> The coredump logic is slightly different from other users in that it both
> stores mm flags and additionally sets and gets using masks.
> 
> Since the MMF_DUMPABLE_* flags must remain as they are for uABI reasons,
> and of course these are within the first 32-bits of the flags, it is
> reasonable to provide access to these in the same fashion so this logic can
> all still keep working as it has been.
> 
> Therefore, introduce coredump-specific helpers __mm_flags_get_dumpable()
> and __mm_flags_set_mask_dumpable() for this purpose, and update all core
> dump users of mm flags to use these.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Incl. fixup LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


