Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675FAC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 08:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D166B0095; Tue,  5 Aug 2025 04:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E6C6B0096; Tue,  5 Aug 2025 04:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44336B0098; Tue,  5 Aug 2025 04:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5DA66B0095
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:17:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D951C0110
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:17:14 +0000 (UTC)
X-FDA: 83741998788.07.C6A696C
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7F6FC0002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:17:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=inTawZM3;
	spf=pass (imf22.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754381832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hdi0osdCtNEGUqWnHGcG2RCagqkAaiO8Ttk2Pz8O1BE=;
	b=E0KvAPla5r5vRveFMRp8pFyf3MSxibwlcbH3W8GjxQF3OHzXRaRZ+eaGBsFYMkXoSMii9N
	zIWC5/xO3GwMNbF/HW8Bi4Ket8L3Xau+jRpsw0Wak3N+/7YErJ1qP2H5GJ9jJJ6PfGCVRw
	dBSatdfiePfSZ24/WonpbDH5GE5G4cU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=inTawZM3;
	spf=pass (imf22.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754381832; a=rsa-sha256;
	cv=none;
	b=VdQMStWUjAzxLtV1nodwgQBFcpuPcAk4Ku1cl05auDiHitYErH4r943gss8DGi18Sjc4Dl
	+1oD5/nwKi5iWONDhKDpIFAqJcBOyuhlb7hHOrxdHD73ChBEQ/75VYuufdiZVRGY0JFeTJ
	Ywo8gZSz8G1b7XwVX5BbQesQMf6pfNU=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76bd050184bso6000740b3a.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 01:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754381830; x=1754986630; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hdi0osdCtNEGUqWnHGcG2RCagqkAaiO8Ttk2Pz8O1BE=;
        b=inTawZM32reEkczaRpDFaAFhwVQLtR+FTo3b5Cgd9xu0IQgxjdn3dVxdCq7rzB+PSH
         CLUy8qq5tpin2RTiAUOXC9IfEqCE5kjGUCEokD6/o4zghyJY2a5j9VukTZLOdFHlLCva
         1d9NlfYBM/HxgUOy0jzjdqs0llRP9hjCx3RHJTDHdpah1V6bGp9Pnal91UMgzZyyfLBx
         cAuOi06MDJp6KVjaeNx0fYBl70wXsPOA1SlcGOig5z1x0O2pXy0B1qgKJuJaUhmkZTFZ
         P4l2KVi+Vvz7yyL4lzqZ8ZtCpLDl/sYbOD1KZQSn6l9ax/vHCi/1SJNM5A6zfgQJMj0/
         jEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754381830; x=1754986630;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hdi0osdCtNEGUqWnHGcG2RCagqkAaiO8Ttk2Pz8O1BE=;
        b=nrr9mgn1EMrW7cD+m9NAcs2GDhRtezAo9DLBfUbF/BvCgg6MLU77dMkbHiMJgymZFE
         J5aAkwoXbijKKOgIK04n8LW+nC6K/16EU2T97d+Fsb6mv5Rgl15sCx1XUHNYVIv9cp1x
         uHEIi3GUNlNjrFt0Kf8/KACfBb/XcnZd9wGX5pXdNuJWmnMYZMARmHjBseAjHKxrCEUC
         ibQiTwiWGwF/Fyu0liSFtz2cH9YdYxtcOjaSF+UA3IorjDwRXSTQ/bjRIDt/0gDEgXVI
         14+AfyBY148QBJxLjjSzIYyiNEBaeuzrsu20StTkNy7VSgFOLvkt3/nkPStEBYwcTVkK
         7wsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRcsPh+t1Cvj5c7fdCjqih2/3Md/Lrl6nqXceboqkNc34yppEHy4QjWIIMCheM5H2sJxzDg9mNcg==@kvack.org
X-Gm-Message-State: AOJu0Yy5qsmtc452iYb6YwgzzFjE3uKmshJjEvXqTrWJFhmmR+G4PpdL
	cXyupQtmFzb+Y1V0UEq9XNDsiqkRgIqnLRDThI9oZAH3YZ4WQClvweQ4Icai6AC/Dkw=
X-Gm-Gg: ASbGncvCyEQOaDrhVT5qU/rKXRmK0KpUWtwYDhZm4byNnZ7lvqyRostDphmGRab3AF+
	HaED4cbK/KKVo4SEeQIz+M4sWwkW9JiavKtJZQUM84ErhDeAzMtOsBnMsMqh/Ub93TUE0jRQQem
	FmQ4eU+SETHs0pfwW3h5X3JKpGYwVHgT39VAbKNuvnV4YhLNenFdKu0zeiRBZ96dfHHwb9tTtwE
	l0zAAVvnbYzTQUw5dX+BjkdGVOjdQG2AJpqGCGbSN/balpMObYFYTvLMLg+fQhXWIJJaoSk0+mV
	GLiE6PLoZ63P/cEHOw+vblO+tq9d1dpeDmUb9sP9MILztUa24W/06B6Yu8kQvU0lmKqsRACvoLr
	mMzJ6mRD1ZHOSJrq+/uCZRtEiUjp2YMLPbWZqo7l+iHMT
X-Google-Smtp-Source: AGHT+IHsJlClq5gm1xJnhjE3i6PmqXx7/BoTu7ITvgZDbc0/yB37WbKPsQyMszk+sBc66H6FkzV6mA==
X-Received: by 2002:a05:6a00:2e98:b0:76c:1c69:111c with SMTP id d2e1a72fcca58-76c1c691425mr2054194b3a.9.1754381830515;
        Tue, 05 Aug 2025 01:17:10 -0700 (PDT)
Received: from [10.4.54.91] ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce93da5sm12202646b3a.50.2025.08.05.01.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 01:17:09 -0700 (PDT)
Message-ID: <b594a315-8458-439c-b535-fc7f052a3fae@bytedance.com>
Date: Tue, 5 Aug 2025 16:17:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 Lance Yang <ioworker0@gmail.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>
References: <20250805035447.7958-1-21cnbao@gmail.com>
 <35417160-86bf-4580-8ae9-5cadd4f6401d@bytedance.com>
 <d73213ba-5ca0-451c-b82b-f590d10da6d7@linux.alibaba.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <d73213ba-5ca0-451c-b82b-f590d10da6d7@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7zd7wof6c6gwf5z1tq14ckpkxoo6r3iw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C7F6FC0002
X-Rspam-User: 
X-HE-Tag: 1754381831-631726
X-HE-Meta: U2FsdGVkX1/M+GX6oGznxXjd9ay05QxyCPtMgSBeFcW+n2nvKa0VDc+euH0du2uva29GMr17Gbo8QXewxIx0w9eWYw7GXf230f34v6qIgbIFL/wT/8hfBFADF2DdhOd2/UHvp8qyULM0LPhhQUgSMJJSR4407bNN7fOfaBKhaCLvbjd1PcVyCajdNa+lWIxG0GEiOFERPEqqBht9gCuBpaCBSUUAv+mN20ZU3qmmUXUn8OpGrcq7if/q4m3Ua3qi+ja+iX4UrKKfPNTbVcSjK+QFSKWnP+YV7Z+BKDvxfnVoKS1TIlfuC/Ns8/Kg+c8MtDfF7CYXN1wFEpzKTHVuJDpAeije2dIJrBZD+sIkNrwd3RIf5zrTpvnYSeJiENk4jlp9mMhvVKdvcRhDLnfhniyDZkI/2sBpGvJvn7pfAUJ8JUnCXPapg98xfFCeP/2QDyEeXLK9lIC8DWTsuZ3a/IpL+jELk41dJMYP+aZ0+f2AVux3YNWVMFBs8KFvYL4h3vo9o+bYi2cEj/IcgnE+cD0wxH0IdUOTCUjUgy5VOrCwcR1VYQB711S4P2z6IzSNsUpGSBL+z04vdMqI+1WtKjWv4dZpt90D6dUAoPafBYv/B2cy69CpzUF2pfLdhULjqhjfNAebFMl4URDG8z8xB+S1hiTzILW2GMChb0JdZhydZvYJZ6aepEfOKysK/WDvoFPtDbHk3q3nmUrtmBkWBoAn9OXOvjE7hEyNg+ZlGvSgg0hkVIDs3AScWgRCNMDI3IhbpaSLWboXfaS0SXQwSgyMxkQo37OwPP+j1V9NzFY4SXInT4SbjJw0xZRYlHeQMjtGkp4ZA69x2fIrLHP7B82QKiOqqu9YkZStPVKRd+shlln5Ya2tzyb5yqIBduHyayoP3lsFtEUktVFqPkjesiUaONio+cCE9YMZwX71Q/AdX8xSQceZ1kINDm8PvWegUX3sUdFoaRtpOvXaO2s
 UJHu5Had
 rAjVW9U4KSjmf/4V/EpHHHfymtX0L3F/0Adw9GVW74ORbXA+inZ5PMZkYi9YwsP/qL+wT7HrMNV70mCNFucyeLRxSeK8oR17rEqPH0eDdluQTo6UpjFj6S8A7j/L+Gl4l7crXEIiCYSzxq5+175VCGpmKyzCGV3XD4qJUD1FjVsJDw1zxCnNyzVF7SBTiF85ZBbhqGJTbAdHi72viJQh00SGkR2VURz5YlVG/x3s/CX25ZhR37gm24Po6kuHhuBGZwIUgvnEdNr61X6rPF2VHvF0zNz0IpR7I1oTbfNVwm7/PhDA4zV+qLynBgBncZWLe7gffI/soLY2UHvgd16M3U34ve/M20NOYFLvkrqAutx4X5KrET/DbPYSF1w8fCYDUxaeRISloVSJVDO630r8GY8WQMYb4uMOEy9x/kWVJlXUtMfan2vabxi8nSaPS8mzAy0lD3N4tJsOqk+AsYLN41/gIQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

On 8/5/25 3:53 PM, Baolin Wang wrote:
> 
> 
> On 2025/8/5 14:42, Qi Zheng wrote:
>> Hi Barry,
>>
>> On 8/5/25 11:54 AM, Barry Song wrote:
>>> From: Barry Song <v-songbaohua@oppo.com>
>>>
>>> The check_pmd_still_valid() call during collapse is currently only
>>> protected by the mmap_lock in write mode, which was sufficient when
>>> pt_reclaim always ran under mmap_lock in read mode. However, since
>>> madvise_dontneed can now execute under a per-VMA lock, this assumption
>>> is no longer valid. As a result, a race condition can occur between
>>> collapse and PT_RECLAIM, potentially leading to a kernel panic.
>>
>> There is indeed a race condition here. And after applying this patch, I
>> can no longer reproduce the problem locally (I was able to reproduce it
>> stably locally last night).
>>
>> But I still can't figure out how this race condtion causes the
>> following panic:
>>
>> exit_mmap
>> --> mmap_read_lock()
>>      unmap_vmas()
>>      --> pte_offset_map_lock
>>          --> rcu_read_lock()
>>              check if the pmd entry is a PTE page
>>              ptl = pte_lockptr(mm, &pmdval)  <-- ptl is NULL
>>              spin_lock(ptl)                  <-- PANIC!!
>>
>> If this PTE page is freed by pt_reclaim (via RCU), then the ptl can 
>> not be NULL.
>>
>> The collapse holds mmap write lock, so it is impossible to be concurrent
>> with exit_mmap().
>>
>> Confusing. :(
> 
> IIUC, the issue is not caused by the concurrency between exit_mmap and 
> collapse, but rather by the concurrency between pt_reclaim and collapse.
> 
> Before this patch, khugepaged might incorrectly restore a PTE pagetable 
> that had already been freed.
> 
> pt_reclaim has cleared the pmd entry and freed the PTE page table. 
> However, due to the race condition, check_pmd_still_valid() still passes 
> and continues to attempt the collapse:
> 
> _pmd = pmdp_collapse_flush(vma, address, pmd); ---> returns a none pmd 
> entry (the original pmd entry has been cleared)
> 
> pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl); ---> returns 
> pte == NULL
> 
> Then khugepaged will restore the old PTE pagetable with an invalid pmd 
> entry:
> 
> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> 
> So when the process exits and trys to free the mapping of the process, 
> traversing the invalid pmd table will lead to a crash.

CPU0                         CPU1
====                         ====

collapse
--> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
     mmap_write_unlock
                              exit_mmap
                              --> hold mmap lock
                                  __pte_offset_map_lock
                                  --> pte = __pte_offset_map(pmd, addr, 
&pmdval);
                                      if (unlikely(!pte))
                                          return pte;   <-- will return

IIUC, in this case, if we get an invalid pmd entry, we will retrun
directly instead of causing a crash?

> 
> Barry, please correct me if I have misunderstood something.
> 



