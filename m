Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8CBC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656F76B00CC; Thu,  7 Aug 2025 14:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E996B00CD; Thu,  7 Aug 2025 14:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DB26B00CE; Thu,  7 Aug 2025 14:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45E296B00CC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:31:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C678A13764A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:31:26 +0000 (UTC)
X-FDA: 83750804172.18.E522907
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6AD888000B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:31:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IVb3qu5k;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754591484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGmN9lP6LEPTy0/2PWA9RBpQSkFT5t9b0NPy5GoZR3g=;
	b=ogpUz+JBC1lxaCX1Rdinz245s1OuR1RvchdfrzMtfPq6zScTvikFQ+ECYBrhRb+Crxt1s+
	I+hV2wMlHaqETk/Pw5SFUQiH1P4aVsFCrTFg3NT3HdsXitm4NYB7t3uCE9D4OW8U4X07LN
	ERwY2aGWwBHuGkZCx1ociGE6Ddvf3q0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754591484; a=rsa-sha256;
	cv=none;
	b=gWImIs6bvXcDiPf7UhmUoDTE32BusoK2rC4ARXXSFAuj5z7n/rI+2L8Tj9LmyOz+qCK8PP
	eEL9X5I4pbkeiNv5JuBss6qhB66HKXiArodzLLQRvsqjPpVBDEQUXBMZ03NPFSsq6T3Aqm
	ySexpRcZr8f5ymwOOOD9VrQS7YhuarE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IVb3qu5k;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754591483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KGmN9lP6LEPTy0/2PWA9RBpQSkFT5t9b0NPy5GoZR3g=;
	b=IVb3qu5k2lDinMp7nR0sGeysGkdEE7u8hHnNvVPAkoBcQe4E24wYNvP1DOc/5z45v18qD3
	GE16g9cgcFp6diZXD1tm+Rv9yMsckzloorkchpiHOhRZJpHiucqxjR/kMvHjhIrVooXiV7
	GidlDmtLXQKwR1h8UfibjfWDXVYnqrc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-AXQUBW2iM-OGxcWkRuTtdQ-1; Thu, 07 Aug 2025 14:31:22 -0400
X-MC-Unique: AXQUBW2iM-OGxcWkRuTtdQ-1
X-Mimecast-MFC-AGG-ID: AXQUBW2iM-OGxcWkRuTtdQ_1754591481
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4538f375e86so10826085e9.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 11:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754591481; x=1755196281;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KGmN9lP6LEPTy0/2PWA9RBpQSkFT5t9b0NPy5GoZR3g=;
        b=uqrdB//7fImS2irQe6XwhTisLCojvQ5Qed518R0K9atPVaWYuPtNAM+OhhNjCR6dAg
         93WCWCCVN4msj2/W+A8QsXskEuflV5TV6WDKziy+wgn7Uj51VEwxcl7rHNrbGFaWIyG9
         0efMR3YI0O9KFYig3MMXebbAowsVEgffyhHPC6hr+9XO1c28MAezFhpTwlVc3kjRntKO
         HfAmr/5ZEQ6oV4fKqFjhWuaSheuqHW3akaKyEbs9PX/Z23VfgSrBCEIoIuLEgz3l3GEs
         tv4FeqvjVkaxVcVVjiH9HyuD4NJv7FpMwAIHhKia1AeqkzDAxv4E4hEMinJGgtbtKq6t
         cVYg==
X-Forwarded-Encrypted: i=1; AJvYcCVHHvemQJR++VjJpLcpNlPQNRfEQ9H4coSu6DRwZpfOjp7jHnauvoswQmFU28vYPcxqIaC5i7Dfmw==@kvack.org
X-Gm-Message-State: AOJu0YweDhfAJoCRim1o8WGmdGkUlNfe0tebKafEMu0RgIUUDA539E0i
	etP3ZAtqHphN7PQMzdIAye0tb0hFrN0QiQ9Ru13iycUsoxPywiRJG6u+m37t4lV/wpXn165c7+n
	WfpHNK/nMxHtbaiT5SeH2Mb9VY76LCiOLNg4/rCqZPjJY+85NLESL
X-Gm-Gg: ASbGnctVCUYenJfPn01nOJMuXofAmr+6lQtpkJ0TEh4YAWukunbrlRQZCoY7JzQBHlQ
	3mORF7UAPM/foUrjMM+U5e6+IGxWVD8p6bAAxbnS8/MGAUTmjCV3+sOr5mmncmntnb2hTrDQJNP
	eScjrGVAQEleHplcW2Uih7kgSQi1RJ86hIMJqLMY0ObaUPqMNBA9fBKSZaKJyPp1uZc59ekYbf4
	4Z6FSuFgjK/yUaAWvszRUZkTsrgHmkvBr51bJHFSx0y0uWTx0sC7RNhkzdmiYViE/Z06yJXeLjw
	mfnbG7o2ILT8esc+dEIs9r6TNUAkz/vB28jyXq2k+dCz96Jkh90FThYqVM+H07LS6wWDGIoWHA0
	QVK7mLFJVqDUkbFf+rqux4bkYgcUfC4Bh8v/W+CFdOZ8xD5NQE0gaz93gpJH13gj2szs=
X-Received: by 2002:a05:600c:5247:b0:455:f59e:fdaa with SMTP id 5b1f17b1804b1-459f43a4749mr5557135e9.21.1754591481302;
        Thu, 07 Aug 2025 11:31:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlVUVzU01otc201eEZRdR02nVj3vIy+zsvwd5ZkfIQZ4SwnsMVJ+JmZ0EIACIPaQFKidS96g==
X-Received: by 2002:a05:600c:5247:b0:455:f59e:fdaa with SMTP id 5b1f17b1804b1-459f43a4749mr5556795e9.21.1754591480838;
        Thu, 07 Aug 2025 11:31:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4533e6sm28362386f8f.35.2025.08.07.11.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 11:31:20 -0700 (PDT)
Message-ID: <d8e0f3b3-6ea7-492b-bb94-4f5d1ab28ef2@redhat.com>
Date: Thu, 7 Aug 2025 20:31:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 kernel test robot <oliver.sang@intel.com>, Dev Jain <dev.jain@arm.com>,
 oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
 Lance Yang <ioworker0@gmail.com>, Liam Howlett <liam.howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
 <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
 <e4f5faea-ccec-4cc7-83de-1a3c7013b81b@lucifer.local>
 <cbc2e23d-69ab-4820-9942-c7abf2066ff7@redhat.com>
 <CAG48ez1vM35DZ=kTSd4+ndgR6y33AodLLC2KbfbhGrkDaqdnNQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAG48ez1vM35DZ=kTSd4+ndgR6y33AodLLC2KbfbhGrkDaqdnNQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -1R1wOUL82gOmjwqc7QKq00XKZqruv_yeOFIFAzXAFY_1754591481
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6AD888000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: imr87ukrq7eqgfzhxzasj6i4rkc7pxh1
X-HE-Tag: 1754591484-861254
X-HE-Meta: U2FsdGVkX19WDECmrlWq0DJmcp3lTHlhy3OEVKkNbFhAkwdLgMJkUz2JpFgy2GOaDU3tlnta1vJmBMnsI+3m+af4qWWvRgJyMMIiAzUnqtJIAECKvkWlTRADnlIvNWgkdhAYWaeu9VVTYwfccRD+EACz6EFlul3Cp0nDzDa2FOvVfW/G33YoB6afxMJoAZop9cY+IXJ9RnKB/4RewFClFzVZZ05uXYgpETcuz+t3kQ67l1tT8noe9WzjehLidxkoFwjC+4HqvdCObsqlv7G0V8db/+qmgyEL9MRyh2l7BJ7fObNIaY/Ze3ZIIxx0Dl2PRQ6P43lA86IdHGzpiemgXHcSO14c2ZgIYhFm7kOuJ2ccShnCqw5y2qsDPbf/RFRAbVlAhc6MOTM+dQ5AJw4ROzFW9+Y75GFaQbKH+b+De12S4zhfsubd+P6y6MHJJUKOuRqhLXP4bW33cSLPHjYBWkIMnYDOSNZTO9NxrOGhSTbN3eKUTj3gxKnggVU+43HyQWdCEDS3rmnsP3Ex4r0ZjQntrpTuRGoqis9KhEcRZZrm842q20R410IPokLiPkn/5N+hL7SCsjVk0Fo1e66eIuxcax8g+QZGKzrZ4qzbIcAPpd1kTI72DYldiGIZjLdaboKMZcl0gEPH4RuiB869ds7lRgyqbTESAWE9QDD3bnhJRru0tF3yExxPGe7pP7tRSuOdstGD5feIf94veg9I1nY18MbHnNYr7GddZAj6nVC+DbaC8W7PwvP6DtD6mHXwYIg7bkToELhF9WU3GmJHGrSOTFTAtAXOCHNW/8f0iOU+1U8Mu6SDcEBUEA3SWYH1WpnoaAvW62/bIQPTPmu68cZP4l14MIt5kLyg0DubJ64PXgqXR41WJSWptJuhSJAwtWRB0hstUCNLJeTBK/MwW9GcAvNgkUB4uOak/Q9aMe/wn290AK3AtoUq5lY/PnCOFAMDOS8mBwujBszcI6G
 YrREvXmS
 RgFcBKlbaoleXKbHNozGTwRuVvs8MWAgsDoljAnaHNd6V8mKfai+OJ4z40Gz78bwt1APDZdN8TLLyqNbc2zjcSS0mV6Yt1YPR0W7T4Dp3WSJa1ggm5VOiHH7spbc+oOIuKiHcU9/j4aluZmXSZHsXi7S9vEs7Zv6vCwwNeALYV9WNWl0vYWvxidw6qefM4QrvXIMHMBLtZ92oYr20mhytJn2eDi6sKRH/Qo87X95gs3OkQymybAFeqrjdjAhEdWP1Da8YyFwSU/jDYgTiZdUbPCflFF7pYxVSj4w0DYXkMeN9kAuaPPiBUzAlGhySU+CqSYSVKqZnlvWyADzhmDQAXqScrnl/FXr6G5/+FXlf25FLHcWT4uU7cPRyUZ1w4hyHZze14nu76yZCcqICwUbehksTVqSX2drEJWdqjRvmv5WcAglxApBOH/LuCMZT/1T8jU6LScC1EOe0j6XASe+KY6Sgt2JlE+CN7cFSoPWNlKS/2fy997AFDP7SVCGXuOpvym5DP81kviRZSXCP1ZIoL4yaeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 20:07, Jann Horn wrote:
> On Thu, Aug 7, 2025 at 8:02 PM David Hildenbrand <david@redhat.com> wrote:
>> Sure, we could use pte_batch_hint(), but I'm curious if x86 would also
>> benefit with larger folios (e.g., 64K, 128K) with this patch.
> 
> Where would you expect such a benefit to come from? This function is
> more or less a memcpy(), except it has to read PTEs with xchg(), write
> them atomically, and set softdirty flags. For x86, what the associated
> folios look like and whether the PTEs are contiguous shouldn't matter.
> 

Good point, I was assuming TLB flushing as well, but that doesn't really 
apply here because we are already batching that.

-- 
Cheers,

David / dhildenb


