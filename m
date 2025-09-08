Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9E9CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795FA8E0001; Mon,  8 Sep 2025 16:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746786B0010; Mon,  8 Sep 2025 16:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E338E0001; Mon,  8 Sep 2025 16:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4866B000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:28:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C899856FA
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:28:38 +0000 (UTC)
X-FDA: 83867221116.18.27D6ED6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id BEAA840005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:28:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QV5qeeFb;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757363315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bxb19G3442DgWyJiqqUjcRLQKcfJrjyTTRUmwA5uVFs=;
	b=R34kGvYgRHx1m1GMhjH3OJLpP+bfJXxUO1Co5wNCFpvpm/k7rzsVjLj33EQStKhGONyRyL
	mH1LRW/Vkjq+mBxwIbNZpwnnCb18hZ6sACyAoy2W9ZK5tDAGD743fE1gqHBYdzL5JWduSy
	oaUl1xjdPMPSYqsCygTVaFw4bkmNkXA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QV5qeeFb;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757363315; a=rsa-sha256;
	cv=none;
	b=U3AsgyMos01edWkHydEtQCiaeZkOAMnDel20jNIX7IY3tv3ue0VULEr4sN7afmhDQw/ZLg
	BfYRV6vIjGytzvCLGGVi0DaNSULT+clO/XXix+P6tGF/tr37cT5X+ZSrEPhCgvbQZNFzdO
	pAGmHc9Vbikt1/n8DpeYJ6CGZ3P/cU8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757363315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Bxb19G3442DgWyJiqqUjcRLQKcfJrjyTTRUmwA5uVFs=;
	b=QV5qeeFbItD0syAGwVMk08sffHwjdsE8/0Aa8qzoClkysUruHONUL3uvRRQwg9NcrggeAK
	r49PZPhzCjBDJzQZuGASRVGHCTsDzAJ8NeZ0jwBT2r8UR4+/Z/c+iy5ZjxyXbhd+QshwfU
	u7OrfQF2Y0w2vdrtUMA2HDV+10lBOxU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-imoIStZ1MbqxAMpn3HGydg-1; Mon, 08 Sep 2025 16:28:33 -0400
X-MC-Unique: imoIStZ1MbqxAMpn3HGydg-1
X-Mimecast-MFC-AGG-ID: imoIStZ1MbqxAMpn3HGydg_1757363313
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45de07b831dso12285355e9.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 13:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757363312; x=1757968112;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bxb19G3442DgWyJiqqUjcRLQKcfJrjyTTRUmwA5uVFs=;
        b=R3kcY6eq1xg2MHO8uzmLtJ9IYvrMe+UvdtqUfsEf9HDd/m732m9LQguTWYYNc2gg2O
         WXBdEDFiTPjFTitZZiwNJtcZYJm5Lb7btI7gtVJ/9hr1OMNBXRaUHH5K7c1v2yAma9tl
         /y+PnoIc/Zsj3gw7o4/0fF33Ha35A0O2hOc7wYwT1ulLU4tvGdsZuZMfAbTRpCGXuGyU
         tlePydpRXaZTdDl3hxl3mq+oWn/Q91PfOtM69cyC7IDUVRkEfSBhaioqOKK1nJzsTl4w
         8M8g4r8ScLOHqMljZEhNDn71uYmZPWXWkoFPcjOECqTBNPv6EKUyvS0d9AQ/vQlQlaJx
         BpyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcFfJec+qA4U8448rRL/LjiTbTcz9cUUuh8W1qTSEkzfrb4X9zotWK442czo9svQc/zwpcopWCuA==@kvack.org
X-Gm-Message-State: AOJu0YzY+5jIPEBsHkZDupeEXRmDDZsSW9A8fQkblpfz0wqtq58V9YG5
	A9IXTaaH96PpyY0HLzT/r52EGan3L+v/QegZ6HOibqp73unIfObC4hNZRbhq75i6n3eUut5pPXG
	JJ/xD03QgDi2e+dTPsKI5B3AMURZM9Ova4Ntz75YTRU835irH/+3w
X-Gm-Gg: ASbGncuXnlO+Rs1qKKWTdlDT3DhSfq5vWonoOnlUfUAbtLePR6FOY69T/vwBxXZlKo0
	QmuEU5hzmZlhdVsDAIy/0hxeV6ZTTdbQsD6rI4czXYZO+COu2Fw3vcl+7Zt7WW/geWvJL15W+9X
	pR4ueU5X59AFtGF46jZ3bULjXMrjA/O/HZD8SkO20F++WztQWF3S7xj5gL4/9gQQeMfa6BRRuy4
	ltyvB/9sI+I6bjEuRSHyx1wxwtFJni1dRATK0s9LfKNMepZnOIVSo/Nfy0YlO2yCDSeEP5E0Xmf
	mam+zLX0KZWcL7A66/a59d0fIP+RtHPkWYw0GWA4ezbvL9SpNBIH2C85wZ+mDAf3lZmB+hY=
X-Received: by 2002:a05:600c:c4ac:b0:45b:8a6f:c6de with SMTP id 5b1f17b1804b1-45ddded4e96mr73982185e9.29.1757363312559;
        Mon, 08 Sep 2025 13:28:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJXsjpdhZEn7w8fFB+LV9zG6ThVcnhw68syW4sBBZ2cyLQUhMVhLuFxV2Kr3/2gkuGtxeFNQ==
X-Received: by 2002:a05:600c:c4ac:b0:45b:8a6f:c6de with SMTP id 5b1f17b1804b1-45ddded4e96mr73981545e9.29.1757363312024;
        Mon, 08 Sep 2025 13:28:32 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ae98.dip0.t-ipconnect.de. [87.161.174.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45cb61377a7sm252991295e9.13.2025.09.08.13.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 13:28:31 -0700 (PDT)
Message-ID: <fbbd4b7d-1614-4d6f-9f7c-2821f35404ae@redhat.com>
Date: Mon, 8 Sep 2025 22:28:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 22/22] mm/mshare: charge fault handling allocations to
 the mshare owner
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
 bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
 dave.hansen@linux.intel.com, dietmar.eggemann@arm.com,
 ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org,
 jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org,
 liam.howlett@oracle.com, linyongting@bytedance.com,
 lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
 maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, osalvador@suse.de,
 pcc@google.com, peterz@infradead.org, pfalcato@suse.de, rostedt@goodmis.org,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz,
 vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com,
 willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <20250820010415.699353-23-anthony.yznaga@oracle.com>
 <a0238ff1-3ca2-4f0b-8452-26584b531724@redhat.com>
 <3752d094-e754-4453-b404-75d92de3e364@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3752d094-e754-4453-b404-75d92de3e364@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q1-uOcvuV4JpzjCwBY_oWDTIVxaStlW-qkq-TVPzEjI_1757363313
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BEAA840005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: h931jage54qmq3rr5duitch7rroctbr1
X-HE-Tag: 1757363315-940890
X-HE-Meta: U2FsdGVkX182RN5lkFZdxC5gJ5xkR6Nh4637LptHWjEdCQu8LpjxmHHMVrw7IQ6Rzo1B8BQniIjS/YTL75KuktpOt6cAFUlh6PMpygr2kWnvkRNSvbtzXSZlEKWpM35BCGbERIKS0pFuB3JyjE7XAnPLyrerHYJPMq/t71uZ3Vl/0se4xMT8ocyzySckphgxGxKQgkCAgZyGvKnvEBcpzo4PXLHCAXqDFgHiIKAMDsbtufd8MUAEuj7na3+Dke9EMnTuCXAUBTQqyMYbHJ+sm7X0XnL0BgNPGYEWXzU0DbroJZgHRPqmiDONiqScpkDNDYO6mCyJXI9dusxRSP1Y1cuQ86bb3o07xN2rcjlgpE0OZ1ERD6+Gg7/73BJSGPvYfkbgHjVkWZMZRgIDiQaZfLj0y7m/UoLROctSVXJ3BJWiMM0EmNDRSrDF/lMqHOYEkcGSMuCjsMv0V2geH6ViKkr1LoKbsAUZXpfKb9KLYX8TMTf542zZqzS5gg5LY5plXajYVZtRCulRQ313FKNWdtrNHgNDjApHp9sgvcK49U28oShrOCpMLgc1r8uXrHG+kv/eeS/ty4op/5QUq3lGvVvJEjVsI5dFneCSuoQ8uDt/fxm1onJHROJ01vS9llsrIFHhP/MeKbXVTcan0zecAKh/0vQpcPFzrjFAclIwHcl9sDityAkxa8G/JnxGXQxwN/NE/L4xvR5r1uplLnBWyuqs35+HZJVP+nDgJ0sfNjzfS5OJSQXe1VYu2VSTgOXsIVH3AO3ppElNIykRGYh9Tltw6oWUhVYEbHhGANtIX5kg4GcDRuP4TD/mHZ/kmgp1HeH98X5xilGuI4uwxQIFHnIOfdHC7//Zn4/GJHRrNTL5MWr4XxKQpkKyrBBS1HdmCDxH45oYtbqfWh+t9j/w5c6r/dC++u0jbZIxbRg20hkDqdwFraH/bx9gDzvVOcACbuaOlHiMfNmYmqqZF9p
 vjqy2/py
 gf8MfK8p1L3/jHuLfW2VSnCEWSdwzS1HSpSvt8+0RSowEB0JLk9wy5ZZWiIr7pOzXY0Ol6GS0GhlNx+QLqCYCFp1zyc/zptP3foSj9cWTq/UjHjavUHD9PFn0iswTbhO2UYembH4jKhShc4IReCJDpaiEIGqVmTYJ7eKDF9L2QMe8ytZ8HM3Mv/7zPD21/ddM0JV/Dv9X17PJsKXPb2pwShLz/9ne2P07XBAQraEnV8m3hStrFzzTLH3ypbybk+oDpnonM0u0xfCPQWEwMSVjFrvUAuLxKreHWqsphN3/bsa61SkTd5d5ww8Z7b8BOOCPdNmbqfPgutGRt3+aNL6PjRfdS/oBGAn410jwAX9hyxLrVgx9/c9WH0SBDIG4kR9DNg4Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 21:21, Anthony Yznaga wrote:
> 
> 
> On 9/8/25 11:50 AM, David Hildenbrand wrote:
>> On 20.08.25 03:04, Anthony Yznaga wrote:
>>> When handling a fault in an mshare range, redirect charges for page
>>> tables and other allocations to the mshare owner rather than the
>>> current task.
>>>
>>
>> That looks rather weird. I would have thought there would be an easy way
>> to query the mshare owner for a given mshare mapping, and if the current
>> MM corresponds to that owner you know that you are running in the owner
>> context.
>>
>> Of course, we could have a helper like is_mshare_owner(mapping, current)
>> or sth like that.
>>
> 
> I'm not quite following you. Charges for newly faulted pages will be
> automatically directed to the mshare owner because the mshare mm will
> have its mm_owner field pointing to the owner. On the other hand,
> allocations for page table pages are handled differently.
> GFP_PGTABLE_USER causes the accounting to go through
> __memcg_kmem_charge_page() which will charge them to the memcg for the
> current task unless unless current->active_memcg is set to point to
> another memcg.

As a note, I think at some point we discussed re-routing page faults to 
the owner, so the owner can take care of all of that naturally. Is that 
what's happening here?


So, are we running into that code that we have current be another MM 
than vma->vm_mm?

Reminds me of: FOLL_REMOTE->FAULT_FLAG_REMOTE. But I guess, we don't 
take care of different accounting in that case.

Anyhow, what I meant is that you could just check whether you have a 
mshare VMA, and if so check if current is different to the mshare MM 
owner. So I don't immediately see why MMF_MSHARE is required.

-- 
Cheers

David / dhildenb


