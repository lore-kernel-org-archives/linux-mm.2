Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D81C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C85D6B009E; Tue,  5 Aug 2025 08:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F9E6B009F; Tue,  5 Aug 2025 08:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5CF6B00A0; Tue,  5 Aug 2025 08:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0D06B009E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:17:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEFCB587C4
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:17:06 +0000 (UTC)
X-FDA: 83742603252.23.158E655
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6AD4D40006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:17:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TU5YsPbY;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754396224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnpdZY3v1kEaD9q23EVotFIxNBvlTwoCxf5DTi1K58o=;
	b=s/MHWxceUj1Ws4CsTgLdRJbqUs/ThMqdMBQgXPwbQpj+tgtuNQjbPFjMMRUSEvDuPawaXD
	csyraXPu4XT89zqMhf8FyQ8DFje3FCLfIpMXC55VPFEFeyKxpndWC80VNMZvyIk9kOX/9E
	reUUiWTvxamMSiRrl558c0g0/t9tKYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754396224; a=rsa-sha256;
	cv=none;
	b=NltuRF8BjC5UXJ5S8IgVooHZFPaUmitCobizgXxY3KAkm7VI+ABUPL21hC7uOalYhCJ84T
	8AQYRpcTV6ZH/CltTRr8MHiBahGFqEHLwIz3xX1rQypy+sWF30zQILdGp9uKxSiOB8swye
	cXm4x8ajyc1zTETs/5Tvf+RroBut+dw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TU5YsPbY;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754396223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hnpdZY3v1kEaD9q23EVotFIxNBvlTwoCxf5DTi1K58o=;
	b=TU5YsPbYgLbMy8CqN/zcqzPQ7KqD9nj1a2MNzDZsyQ8ePPwqWPcMaziWoKQzJC0H+t9hhF
	jGEUPUSxGHynocEsmjNBpH5AcLLSWmxKy5Fe3p3a72uOQzXQQtuG7g4tbAaC2UhGHRb7lf
	ioZf29AzrkRALvGN4e+gah/1MTncJbM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-SI30UzNsP-S-Gbr_Dgg3TQ-1; Tue, 05 Aug 2025 08:17:02 -0400
X-MC-Unique: SI30UzNsP-S-Gbr_Dgg3TQ-1
X-Mimecast-MFC-AGG-ID: SI30UzNsP-S-Gbr_Dgg3TQ_1754396221
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-458a31421a3so20527275e9.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754396221; x=1755001021;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hnpdZY3v1kEaD9q23EVotFIxNBvlTwoCxf5DTi1K58o=;
        b=OKI1mGJcX/cyS97axQamymeP8pozyAIAICWzlAUGLGhnQFbeyNv2EeIQ7oqdwZWZ8a
         oSaZW+USpwdSVUsfk6Iv7JrrHFHr5XMDUiJWIMrXCQl1oS7B6ZS0P1hCvFiRRK0ENG7O
         SfbHHCNtw+vY4DseAyIRVsK3E33lupK9UZTw3QYJl/ICGNKNiOAmGkileebxZIC1Ua7M
         u1AxVKGJ5mFpJbOv8F1wqIHl8yac4S9x4j8Mauy/imNdVwg8/JwpRgFNVTPupOe0cGqj
         c9o83kSu02p57UNZAdcmLo81eRrVfdCw+t2zGynpc3r+df86X50votR1skP389JlAE9P
         h1jA==
X-Forwarded-Encrypted: i=1; AJvYcCXK0l9WFvJvvun8I8LoRVYikbk8kbblK/U7vyI8HeAmAgAVoPLgAtsEpb3SkQVW1tAadg+zYCTcaQ==@kvack.org
X-Gm-Message-State: AOJu0YxZ1ZIKQqIQdXrK7SdrkCBww5mGWgs7GQBpmQx2HE9bq74DUFfC
	B6z/x+s3eUSfK3ZNLUgE6VIfFJVFxvYIv4IFgzGuR40jAvga0MCfkAYncfnrLE4+5oxnK3MwYJW
	+a7E4kEFDEpl3VEAri3oG30Ir5+pwnX9wyq+me+17hlcsqFPbRSk+
X-Gm-Gg: ASbGncuQCoSrmPo7VevZ4hhOKiTleXbdT97W+FZiGa8eoeHhU8ksqpuN4iDBzqiBxVp
	LQkp3VxFgHADvFRC3wPQnDXqiP8yKJAtQGnmhR/C4S/FJFGjFgEI1Coeu48CoexpNMrtwctWSWD
	Ag76sFUaKiL0Bz96AItlviaimJb2+fbFOHa1MrgKQgB+wNlEFL9oldoKW6ASHd5GwwygOeL/pTS
	DVvTwojRdXrs8GHkADOpTVEXbMQwg70VHuOkQCdtRAY9yFGIL6DWnxQxaP9WHgghhEPWRhSXP9A
	H6Q/BSxVsuPzeoClnHRpuFC3Qzcz7pYKvzgTYYHEBfC3glB485yRXd9dd3Dv10MADl2cgednW3V
	DvcYcJYDGqO7H7Urh+O3vqe6w+Ub+wC2uWqDZJVzu2ERCvrB7sAteMFhGpMpH0DYMdsY=
X-Received: by 2002:a05:600c:a4b:b0:456:1e5a:8879 with SMTP id 5b1f17b1804b1-458b69ddcc4mr99531925e9.9.1754396221134;
        Tue, 05 Aug 2025 05:17:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrqOQ8A8qIGLA2mvtZF2b3QEhwpenSBEb9wQuyaM/Fmf5K8F5vu/aZnLwJYmcbo9s9KE3dZQ==
X-Received: by 2002:a05:600c:a4b:b0:456:1e5a:8879 with SMTP id 5b1f17b1804b1-458b69ddcc4mr99531735e9.9.1754396220689;
        Tue, 05 Aug 2025 05:17:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e587e471sm1481245e9.26.2025.08.05.05.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:17:00 -0700 (PDT)
Message-ID: <7cb06105-f2d3-40e9-94ae-3d497b9d8730@redhat.com>
Date: Tue, 5 Aug 2025 14:16:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] selftests: prctl: introduce tests for disabling
 THPs completely
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com,
 Donet Tom <donettom@linux.ibm.com>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-6-usamaarif642@gmail.com>
 <eec7e868-a61f-41ed-a8ef-7ff80548089f@redhat.com>
 <2c795230-5885-4a1a-a0f9-c8352b9e7738@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <2c795230-5885-4a1a-a0f9-c8352b9e7738@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: US4DLNwo_y5hqQ5lCwOqEqzEcmjtL_1EvyjlEpzJD1Y_1754396221
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6AD4D40006
X-Stat-Signature: q3mqr9szxk78oj4esdeodi5gwcijbhmq
X-Rspam-User: 
X-HE-Tag: 1754396224-842815
X-HE-Meta: U2FsdGVkX18ajF/Xw8C/LiLytZei/dwZDticZ4DzdesvCukjLPFPeSdM0Znf5TInglPB3UyqtzpUQoqWByRk7up0ecRvBbMfY9AcNSv/wp8YM1Zd+r5c3IZRuInM9nYTWuuCzXnoROkdESSSu8OBK9pBE+epdCm3q4SeCYdnDxRLLfcC7zQ/pkDv3LwCTk4VXSdN2DTCDeFYRo3sqz6fet9ZZd+miFl4G6tXEH+56xt0kV9JDAkiBxFT781+JrUzIZdLNtIB52nlKBviU+4YDQO4y4rO3V6igkgabyP9Yr0madN1siQBp+bxSmD5lTQzuJ7Rmr3nFlxXxWwXWh+MC4GXXJg2+pBstCuVBERDfAL95EbazaSP145J5gaPsOAck8oJtw6Q3upk9jqsBW5s2HlME6IkU2Whh2asApk2bMDhRMNZaz6VGgHw77F9wQjyUZ7SQeJtvs+tdgK6CkjS8HSrenY1wFt7Ifu51SB5RUrN3Gk9kQE3ateYMDStJ6s1iiojubm8GBJbl6DgmpDr90fVJmlSjH0FAfMhzFmte7tjTBynU5cmO5EYsbDEnR2jtUy6xWIscs16XpTVrkwPsD3SiAKizNQoeOsn0Kb2+nOkWhiI3WpuVBWqmaKso7W9R1o8aGFe1c+Pn/IifA2gGyNu4oRujPy0ozHT+gGoOUIMCPRVNkWt7YySTWfVCse2mr27L4ToJjIHxa/FkSfGbSVDWtjheQhGquji0x8o34ZlmuuZv4XZJJEnMfb1x0t3chGsbKuQc79eBPrKA3ROgun0MZ4kkEiL/oI4qJX72pkimaxLiUMlhQnybQzXTMsqG8SdN39ZA9rFwLqa+9kLyGELE7d3wexs7gUbs7NGZ1VOzB/U8ZMzXKAjGD1DyzX3r+z1rwWbLKO5G7Lgs5k7grBcXijWkyKUUFFsH83XDhkCaU0Fq8nBrbyN0GQK7ENmI17CWSdL5QYG/Pkan2M
 h3bosLDo
 SllXKHCznjAR18TiLfsrZMHrbTbieuhbaAljRaqo7ZHrYKuJNcstYZSoTQ8UCpSn13zNyBWmiPvAz4WS1qMw8rvenWzNrfUNZAzmMfUS+/TVuJNAxYgg1vJp7RuXwXSBvP+Ga2s6qPHs3oBycssy2Fb7uz0FFZuOoKdrVSNmWFRvlQLdFYVONURSrkyLk0bvXHg7Uht62vVnnEeuJ/bQnFHNJ0mAHxyiu8tnMvYLYW0JNCzhkPxHZVEzgzmZHza3IC3g1UMtj3C5LniTrJMH8jfeiGjmhKAJS7n1Cu3TnTXriZnhrxfkH8Ok2oTCz1SJYVlMf/x1mLIRUXQIwwIFhI1UdCI6Z2FIza1BfPByz9LndZs4e31VetmQyF4PkVQvg02fDEczzzfnRBaw/0bVLEk6LhsrjIZjh0zzRTc30AbA/e1hxVvnKQ2xwgNDMn1de6X7ejZBGbcsK3NxQmOQQQ530PQ5nvoSkg9ocWOnT+n/ioEQqGkzq8JEF5gG3C9itNDgEOEKGRjpO1Ix0ULAySy9k7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Nothing else jumped at me
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
>>
> 
> Thanks!
> 
> I will wait a few days and see if it has made it into mm-new and rebase and send the next revision.

Will only happen next week, after the merge windows is closed. @Donet, 
are you planning on re-submitting you series?

-- 
Cheers,

David / dhildenb


