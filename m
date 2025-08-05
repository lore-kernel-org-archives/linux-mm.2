Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A164EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3359A6B0098; Tue,  5 Aug 2025 06:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D126B0099; Tue,  5 Aug 2025 06:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223166B009A; Tue,  5 Aug 2025 06:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 138916B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:26:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BAF9B114AD4
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:54 +0000 (UTC)
X-FDA: 83742325548.25.03A58D0
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id D3F2280009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UOgLTe78;
	spf=pass (imf30.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754389612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDMXNgbn2CAVAwPiNUASjz9nyl/F4Fuacri7IGY04Qc=;
	b=NdfsZt9hCN5QNB/YROOCPuQCq4qKbJCO9mx/cNfX0oXquANK5r7WNbNyY09MUGuANxEIOS
	gCT//hA3g3laTypPV1w5PFobTFx/vk5FNK8FX6XCF4BcO90f3hdL74iQlHQCMZ3l2Ohfgu
	8h7AqS58lySYCl5edMvQKgMSnzGUkBU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UOgLTe78;
	spf=pass (imf30.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754389612; a=rsa-sha256;
	cv=none;
	b=W5DmDsEHJtTVfaogWmhVofij9gM+R6sXwQcBX6JsKf5gKWqNhVSraTlm2yF67S6Kfoy5XP
	0MluXG/CB1/n6b0Rj+92OTlBL/jbwnb3ttGh/N68YstMoHvVRYybcrFumxutWfPbk1xNeV
	sy6MrdN3Vvd6Ba2XG2t2EEuFwIHL2+A=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23c8f179e1bso50032315ad.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754389610; x=1754994410; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDMXNgbn2CAVAwPiNUASjz9nyl/F4Fuacri7IGY04Qc=;
        b=UOgLTe78fikF6mixtIQ3E4Ynakhq8rCNeo29VUR/uParjMp8VzqhWEJKG8PkrsKD36
         mGAaKtY+wJBJq1rQwSx4ukwcIWOLjNIZSJtKb6PpoEY0zDkxCfZ0j1+G2Bbm9X/Dcye/
         JDQ/NTbI62cQ5IecUYtmNF7jhkfODdaOEwvQOYiP9BgOkIy+hqk2zJkgogvcE22uKlVr
         3AiArUQNrPEF63GdBnE8PCGkQMxVmqveHr82hrMq522OmcXLHCBHEghXx+NFhE4os0I+
         uaftQe5uY4Jf0qdHgFOoGCtzZ42DaTVXJ0bKNJHMXnxfWSFfuIL4k6FZgb76TPyIPc4g
         gv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754389610; x=1754994410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sDMXNgbn2CAVAwPiNUASjz9nyl/F4Fuacri7IGY04Qc=;
        b=S4uJVoedchlePm9VvAgPIq8NqHjRKhHDqo582xFG4L9a9aNEg6z/2qUhB4MdZY/aSl
         vt4apFBQjv2oEjsJ/tEmViYJO9eHkCHHWbq0cgXGo6mpGKYCpXb7sxlbu7RiiXnkX+KY
         cNPKTHPLwxI20WEO4PuDERt8xUjU5zdsu+pJ5b/y4M++Zcg3+/QnO4Armfo0dVhzkR57
         TkhvnHVbSta2cb6tENt40nbd7nc4xw0khuk52/x3xLaKft1u23I1UqW0ZSuq7jdKZd4+
         OwQWfQLE9DS3Qw7+nwsh4tS2gATjs4Xw176DnnDhAr0bHBYlLWm0DhG4btoMKWvxbmxs
         YbEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVHtxs/35Po9oMpcrcYe+VdvWpLNoQfbAiqHt3ueFItspDmn9wOg5saieuTqBxUlzJqfHau9AA/A==@kvack.org
X-Gm-Message-State: AOJu0YzStrtrSGxemhWlJnzgqSFI0PYWAdLs2o5rQe0lQWaplST311A0
	lVsPap2cJXex0CqKiNLJZrWBKFTJ10An1EOMEICPNqWWJLKB7CoYIpcr4Ikv0OOb4J8=
X-Gm-Gg: ASbGncvIiA8F9WJTT2XUSas77MMJvwb4lHD+Yp/budGTlIjwOADSKlYMa+Qpnocjlyo
	1j+SWUxc/1CcBM2dcOWoNy/apuLnucDiRBuq7kDn4AFikRD9yHouqQ/4IRHvEfs/HJoXND4O4wR
	0xMEHX4umZwh9xjFBNUBoXEXtHGkBdkIlpaxwKoSmkVYz3YaPgEBIF0kYkAePmuxFef/64MF8RO
	7LyzYVz83FRqoIXFAcBy5vu6fukLNssBWuM4iykcHSwjzzUeIGd75sy/hgwZORUF4mTFQ34gpYx
	s8owmPySDeyEb72Wr8JHbku709a08erD0I5YMqcC3BngPKh2jIiGKrYsRiDwHbAuIdd6Qhfjin0
	cbXHlMtK3SJ9zuEjZXA2XCCuLgROa2y0fHzhJfZTLBw3o
X-Google-Smtp-Source: AGHT+IETnZQFipLlvzA1gXFWt9A88wLEwXr/LrqzR0JMFbgEn9V8WGBPOWwHU3svG4LLBT1wi4QAYQ==
X-Received: by 2002:a17:902:e74d:b0:240:3d07:9ea4 with SMTP id d9443c01a7336-24246f2d5aemr148163345ad.7.1754389610564;
        Tue, 05 Aug 2025 03:26:50 -0700 (PDT)
Received: from [10.4.54.91] ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89a6ec2sm129225305ad.145.2025.08.05.03.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 03:26:50 -0700 (PDT)
Message-ID: <a12e9a51-0ee4-4a10-9ec4-d4c0d34ccff9@bytedance.com>
Date: Tue, 5 Aug 2025 18:26:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Barry Song <21cnbao@gmail.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>,
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
 <b594a315-8458-439c-b535-fc7f052a3fae@bytedance.com>
 <c6f9dacf-d520-4cc3-88ac-c5937916aa2c@linux.alibaba.com>
 <064cca31-442d-4847-b353-26dc5fd0603c@bytedance.com>
 <5ac2ec58-3908-4d0e-a29b-8b4d776410e3@redhat.com>
 <46f0b251-237c-421d-aec0-adff6c2e1bb4@linux.alibaba.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <46f0b251-237c-421d-aec0-adff6c2e1bb4@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D3F2280009
X-Rspamd-Server: rspam06
X-Stat-Signature: s3k6yy9xrnxsny4wgf5u38zq9dbmsrbh
X-HE-Tag: 1754389611-89415
X-HE-Meta: U2FsdGVkX18NdERy/oVmkuQMA8PgE8yCRBGyR2PumxWn7tXrC46iOe8P3HuZi+3Csbgt37nCWDcM9+/qXwJyZHE18enfy4laS6kfohjj1BcNVSaxq7eF1Cyh3cW1XGh9y25H4acEzAIemBvYXO1v50tstp3pHHiN4ZIi2HCmu0ZFw9yZRJAYFBaW7L0BnfBbtcy6w1BiXvDDNrKzDdrjh+imEeurT+PoIui2UGo3Um67EcM5nkTCVeU/uv6v1du7G8IX92DVCAug0gyObKR5eHYNyXRvlXr2N3E7nHq2nK4q761/D2vJR4+Mh+NMvu2oQQghaiyCv9LH7ZNys/iTq8A5rpZDRyvqtupc6SQnIZFYNt+ErhiUAglWohSg0W10sJwjma/fLVC4cAyvgMD5Dcq0G3H/6q3QJeuUndZpE0DVAQcS6FyJTGT8CepchwUoQ5HAlUFW2byb8Bpn2OAgLPuAEpYpyuWDRkGsN+4WzQIWZAx5BGLm6/0Ke6uaF7jCtHB8brB1k8ZSYkJHDsCRALZsJ7cRvUBKcJTywBix8xKAWeWk06C7R0FlqvHGe+up/8PFIvZBGv8od4jed//HNDOBZq1ZggcrlMY7KSxk+yIAPuxhtsUB5Y0D/azGBOJOCH8OBQGOuPrlpxeUMzezeOhDQdqxeDtb/My4FmT3zsN0js8lHVDtvXBg1P8JIhWPBohsSU1Mxc5dBEGrFekuAEx3GBNe0/smkeCDuL2EeG5LnKa7Tpr7yqGbsZosbSNM+405RhDP7EkwV+1IpseHxeEzm4ElZvZ6mrzWP++iH7Lg61pot1TG9KdDtNjq3HnjBmn2Z/cw128yxVyBk7bVtLvd6VmDpg5ufsjBXwbA1i5uu8kCGc4gVZtAOILEdIjbhQZI2pgIn/6kJMTlEGX78CiDNJEf6WvwRB6J79dQCC/yEQxkc/eskp1xm4t0Iv/oMD3GRVkgsUEBOolDcKy
 UPiTLND8
 DvaO5statwLvDdfCgrRVdoTIEYYnj0XpaYLmA+razP1qlJQhcJ5YzmYkH2kOvuOVXUX2UqRYl3oWojDvyoxeq0TyTd+vaOsnuHRzQw3VDwUwCIPqhe9zLKRbEe3Hv/fidEnXlm75zSp+Imn+KqMwU2HDskEDiqN/iSwuZ2n2tm6AP+hqWh58Nl4+D9lHAV5C72BBVB5AK+MmaLt6xokyxZildsX3XhWQzVryUpK/dEri/sjMxfI85n7N51ND+0/DwRwwAnyUpLDgV5rQTHhqWx0z2f+Bb9ItelyM32iHOT0NHW2xonWt+24eLt6XU59o/W5VHkjheatpIoAQxxpLdGKqFXz5+Nc+WMRPd6JJbo6NzT70DYeLVNJrhYvTpmSbUNvRE5MHNy5t2TPBwHUEZfllppIcjxHzeabvEpf5Sa8bUEMo4h36/3ptI+OQwyA60Viobru56LTBC9kY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/25 6:07 PM, Baolin Wang wrote:
> 
> 

[...]

> 
>>>
>>> What types of this 'valid page' could be? If __pte_offset_map() returns
>>> non-NULL, then it is a PTE page. Even if it is not the original one, it
>>> should not cause panic. Did I miss some key information? :(
> 
> Sorry for not being clear. Let me try again.
> 
> In the race condition described above, the '_pmd' value is NONE, meaning 
> that when restoring the pmd entry with ‘pmd_populate(mm, pmd, 
> pmd_pgtable(_pmd))’, the 'pmd_pgtable(_pmd)' can return a struct page 
> corresponding to pfn == 0 (cause the '_pmd' is NONE) to populate the pmd 
> entry. Clearly, this pfn == 0 page is not a pagetable page, meaning the 
> corresponding ptl lock of this page is not initialized.
> 
> Additionally, from the boot dmesg, I can see that the BIOS reports an 
> address range with pfn == 0, indicating that there is a struct page 
> initialized for pfn == 0 (possibly a reserved page):
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] 
> usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffdffff] 
> usable
> [    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007fffffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] 
> reserved
> 

Now I understand, thank you very much for your patient explanation!

And for this patch:

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>

Thanks!

> Of course, this is my theoretical analysis from the code perspective. If 
> there are other race conditions, I would be very surprised:)
> 
>> Wasn't the original issue all about a NULL-pointer de-reference while 
>> *locking*?
> 
> Yes.
> 
>> Note that in that kernel config [1] we have CONFIG_DEBUG_SPINLOCK=y, 
>> so likely we will have ALLOC_SPLIT_PTLOCKS set.
>>
>> [1] https://github.com/laifryiee/syzkaller_logs/blob/ 
>> main/250803_193026___pte_offset_map_lock/.config
>>


