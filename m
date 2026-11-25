Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CC7606A685
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MIZx4SnM
Received: by kanga.kvack.org (Postfix)
	id 966CB6B0A56; Wed, 25 Nov 2026 10:42:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93DC36B0A58; Wed, 25 Nov 2026 10:42:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF596B0A59; Wed, 25 Nov 2026 10:42:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5AD6B0A56
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:42:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDDC2A0F6E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:42:54 +0000 (UTC)
X-FDA: 85474059468.01.718F0F0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67D07A0002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:42:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MIZx4SnM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795621372;
	b=eUSZwbbPQybZsjCoQ+Hyg2BkYL02gibY2SbckddUlwhoekL3TMUHjrEn2ORFFPAGCD1P/3
	mYaDoOLJcF5AKVp3MZxAE3IAeohtwPNFskIpY/iILFq0QChX8LmgHjDLA37pDE9cKcsqUr
	VPFOQRmxMXzT/U/CCWUmjpwuHIRzXQU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795621372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiHQ9P2Rh4c49bXhsBaKtyKYgRGqkouT9MBhcz1H/ms=;
	b=A/Upvnj5LbU0yngJnjEWBnV5Ud45fMAisAVB+NamYp5eC9J33WjovNutQofrrYPIlmg2ew
	BvBqQI44ckLmXlUIG3CxmRWe4TCbzoVJGNLblcBtRxC2U72Wt5w9nccqLuTDW1CCTHbYz3
	XnZSBkD8YaK42t8heYCPzIAp4Wd8SAg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MIZx4SnM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795621371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hiHQ9P2Rh4c49bXhsBaKtyKYgRGqkouT9MBhcz1H/ms=;
	b=MIZx4SnM3AVAlSB/aE9VfIbY3mBbgq/fv9/VpUOOmxtPvhsvyIpUgcXa6WNup9P3W9dHpT
	t6YR53I26BnmRt7nvlMIP1GgEHoDV9cio7X9xrlNWPkwdlV3D5qHCsDl1GGQ3CmWUJdCbh
	qb/GEXlkNQUmUXzQ6jMo2hKpUCbRK8s=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-KHnFgPvUNeibMO1cL0p45Q-1; Wed, 25 Nov 2026 15:42:49 +0000
X-MC-Unique: KHnFgPvUNeibMO1cL0p45Q-1
X-Mimecast-MFC-AGG-ID: KHnFgPvUNeibMO1cL0p45Q_1795621368
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3ae4b12aa45so24011541fa.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:42:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621368; x=1796226168;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hiHQ9P2Rh4c49bXhsBaKtyKYgRGqkouT9MBhcz1H/ms=;
        b=jG/oFjdLQiBiieT00Yh8hUNciubxRbENAXSWXvzcLLMDQAhxd1+Z7/vwWK9mbwDItq
         T9j8Dlpy3DO88Azq60lAIBo0tG4j/zTyeiqUq8KKPwD7iYPBgNEXmqrH0IrYowDzEENl
         bVyI7ZTR4ouLcEaTSWBc9JVCW1Hp/p6cPG5SWWpdDp8XC7yjQhJbFg9OAXGuLQ/IWAUh
         bJwcwjbLKtpgLacKJAxOaPxmJRwOeH3eo26o6fytgCOpjKgy5QQabIbu5rNvfSyazy/C
         QhPqoYCtG9U5AXPEJ8FmLixX7w5N8dGBMk+ahjxR2dYR9zwUpIzp6AruUYuf9T9xpRLf
         Rnwg==
X-Gm-Message-State: APuU4Z8bRLgzB5Lq4DTp7/djdIW6fPgT4OUb24Wmu3MHaPVAqYIg6wMI
	QN/PGJprlhkDwIxj42OYCN35pTdEOCAOpCuOJWItQsh5YG7cjX7AZp0FXHeU7s8OWNMQZ+ah0Dl
	fO0XLZAQ0ad0xdt3Bk3EycndlT+WoHFFtzlqfM9fx6XQ++1Zxk9w=
X-Gm-Gg: AZFdTZdT2+vHw8priNXJM1LPB/S4RnUPgczk9fa3CiuKAKVvf8aFqvU+Lob1Ym2cJTi
	yd/DwaSHFAx2zVlvlkj04tQVbu3FLvPzkQMKrZechBx7TnWdw6+pf0B6f8fNOzn4j2FdoZ+cr3z
	RBk/HRwKgwJVUDrGm51qXgjfd7rkH5iJjlHx2dmjM/QdPK2dm9k+UHqOTrunAFwaJ+6E7z8iZNj
	/QI3cWbuoCXiiCGxhvpkrDywQ9wWPIpa1kcech36LTTnD8XX33Je4zyIHpmCorIrBU6MU7NXMxq
	YykZ0WectFU9eh8nuAeeHFlh4ydlxNVQ4+NKjA8dFH0/Yq4hVSgjDBpc1JAzWwXqBv3gUWPrFhz
	oW+f4em3Mla+1hHSitnurZ21uR/OymnVHgqnvbU4Lnphi9PbMiYRFKoCmG6T1nbfqFML4tVFunE
	sQY/Hw
X-Received: by 2002:a05:6512:2308:b0:5bf:dc0f:5f07 with SMTP id 2adb3069b0e04-5c1bc7bd116mr5455136e87.20.1795621367768;
        Wed, 25 Nov 2026 07:42:47 -0800 (PST)
X-Received: by 2002:a05:6512:2308:b0:5bf:dc0f:5f07 with SMTP id 2adb3069b0e04-5c1bc7bd116mr5455101e87.20.1795621367006;
        Wed, 25 Nov 2026 07:42:47 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd04451csm4614701e87.59.2026.11.25.07.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 07:42:46 -0800 (PST)
Message-ID: <e2da7591-a56f-4d58-afb7-d83267d946ac@redhat.com>
Date: Wed, 25 Nov 2026 17:42:45 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor> <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
 <avtBqGb4R2y9QJM8@raptor> <574af521-6b8e-41c6-bf68-1d14b78c4645@redhat.com>
 <awbyKnmLcqdwWBKw@raptor>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <awbyKnmLcqdwWBKw@raptor>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MXEqBEKGQ59AiZC9aAT6rki2BUQTr59e0i_KL_Q9zEQ_1795621368
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67D07A0002
X-Stat-Signature: zmbqbpsehhxhzdji8369y9z18dj4kd8d
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795621372-751371
X-HE-Meta: U2FsdGVkX19tjiNVQEk2OsluZ4Ev8eU1C55C3i/5coSLSefZWuO4cy+36NWUOHXXMP6+2zIbnigyFaOyFz0f6xlgPGmLAuCmateJ4MKRcw8rR8e0IhIEm0FQSESNxHRbslnNddh/doEmu4DoM/QeMsBA44C2B0TvahqllT/b9WjVIdQVSBaF7s/Y8cV/+NZr5dtjYjHolW1u97+qPmxDNR/o6kT/J3bcW+7XwEtigLuaRL5fsHFMr3Mvb5TmcqVPwbtB1Thg0ikkz38QH5Z36CQWeR3uG+s0ChiuTJq4h4In92l3KVLdc0Po+zYaRBHsv4SPK60I12sVr0lC70Ilk8b0+sz9ttKmkC0ssBabk6m6Faj77eOohJrG+blhJZYtPVh7PIcUe8FuVH3grTvBgpSPq6rg1m4s+O9P68IY+F4eygXjj0dfJWZGlmfRMyckl3OCRxg5Bisqc53U4J5jrJwDYgnEzV4uXqe16dBnjTO3BOoURFhzO7T3fvoi44s6xLF5yx5aVwgxLOTVmWyjvtNZxX8TUbzyogoBSeSdUpctk9lISg+ks0VStbQmxaLkE/AQhLZtw1RDE4LQfM4GQX4OzG1z9nMmyVUdtnYzSwKx5zecJa8EWrRxSg/8TK8Y8FKH21r1B4YRvgKLgKHfM4pJrhzy7SfOkRUASTJ0kdhPciisZE4KppGucCozfy3dxOFrFvgS7sfIWEUMdc6ZezgiQYjDQXCknNJnFBuXvKsleExDtvq33ScGJoSyGaRP2CxaBZn06DCaffKSPjvmXG3blYenZQFNXZ54XGcobx9CA91a7e2FDti4QwghRImzLrYIGGOOQiVOYhnwoiEylZ5E3iu29qJiqPfc/KttDrxTO8Bqfd4i9xwoWK4RQSnwxudK0yxJpF06a6Rq3qfi8g0VlGOzHBOn3x92nlbuPzZlPcFEb8rJ7CNhj/tbTEoC0TXiA9Dmy8N4fGLpU5F
 1uSn5+jv
 sbvZl4gx1ULO7gI6JfOJjb/TVyxEX5rvrpEX3/5gCfoAXxZ+QoGFtfuH8hy6cGGl1SPQPyIWikikUP+fbwJUuM3lX/qc54dyOXUXHH6cRsfEFcTXVo4IE5UGCkheFMbLu87udFrdZ4e8LqjZFi9KeYjbneDwwk05AVmZn7JXo1WgaXFEg5BtcdjU8poa9AbMpU9JySBNl5Pjl2tN/S+lfkJPqL+6nKyZNZAchrnl8hGdFl0CYRc+ZvHXKbTsJXaL3ZUgYx+cnx0LWsuyCw2mWY2kWatlbfCScYEQvK2sPM6QE0apna0dhk9z4GxDP3pZ2hFBV+mi47RLAytDYg5+NEzdq89sr5kSV2DUjq+e0RKf0Si6xkRtTpr+XEacjJax5zZcNOoKU3RH7a7ZF6RzZMQ3UYfD+c0StWcRcd0CW8zIC84KxaxYcF9rm5AloGy4EYGFHBtjyVMmoceTQOEVGbvNibsd4m5nncnHey9GSgr6/OuWpJdliD2w1WiY0UcTJIn+6/DcZKSzwPYc3FwOgNMOPukg1mcp5OTRHOyEtu5gmVTSnLOpzs2MC39htKzToz2ThQA52ty+FHo/21RxWHV+ruuVrnkliB/+UkC6JB/ERavlQZU+spg69ZGSylNPHUSRW5NfmE/2lK3uW/Mby+ss24v23yVQpN79PgrJ+Z+0+YMW//2BMArgndpm3W7eqYoqL/dSOPQCEFqG3XNSWFIn0uaOQwf36K1uD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi!

On 11/25/26 16:35, Alexandru Elisei wrote:
> Hi Mika,
> 
> On Mon, Nov 16, 2026 at 09:12:38PM +0200, Mika Penttilä wrote:
>> Hi,
>>
>> On 11/16/26 19:47, Alexandru Elisei wrote:
>>> Hi Mika,
>>>
>>> On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttilä wrote:
>>>> Hi Alexandru!
>>>>
>>>> On 11/12/26 13:56, Alexandru Elisei wrote:
>>>>> Hi Mika,
>>>>>
>>>>> I want to help getting this series merged, and I've been familiarizing myself
>>>>> with hmm and device migration, please bare with me if the questions I'm asking
>>>>> are obvious or downright silly.
>>>> Thanks for the interest and willing to help! I am preparing a v18 of the
>>>> series and plan to post it early next week.
>>>>
>>>> I try to answer your questions, there are quite a bunch of them!
>>>>
>>>>> On Tue, Nov 03, 2026 at 08:16:17AM +0200, mpenttil@redhat.com wrote:
>>>>>> From: Mika Penttilä <mpenttil@redhat.com>
>>>>>>
>>>>>> Currently, the way device page faulting and migration works
>>>>>> is not optimal, if you want to do both fault handling and
>>>>>> migration at once.
>>>>>>
>>>>>> Being able to migrate not present pages (or pages mapped with incorrect
>>>>>> permissions, eg. COW) to the GPU requires doing either of the
>>>>>> following sequences:
>>>>>>
>>>>>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>>>>>> 2. migrate_vma_*() - migrate the pages
>>>>>>
>>>>>> Or:
>>>>>>
>>>>>> 1. migrate_vma_*() - migrate present pages
>>>>>> 2. If non-present pages detected by migrate_vma_*():
>>>>>>    a) call hmm_range_fault() to fault pages in
>>>>>>    b) call migrate_vma_*() again to migrate now present pages
>>>>> Regarding both sequences, I'm trying to get a better understanding of what
>>>>> the issue is. I assume the caller wants to fault in system memory, and then
>>>>> migrate it to the device. Is that correct?
>>>> Yes that's the common thing to do.
>>> Gotcha, thanks.
>>>
>>>>
>>>>> In my analysis I'm also not going to refer to THPs, since that would make
>>>>> things even more complicated than they are. I think we can come back to
>>>>> THPs later if we think it would be useful.
>>>>>
>>>>> For the !pte_present() case:
>>>>>
>>>>> Sequence 1: hmm_range_fault() -> .. -> hmm_vma_handle_pte() handles
>>>>> !pte_present() pages in two ways: faults in swap pages and device private
>>>>> pages belonging to a different device, and waits on migration entries. Then
>>>>> the migrate_vma_*() flow is used to migrate the range.
>>>>>
>>>>> Sequence 2: migrate_vma_setup() ignores !pte_present() page table entries
>>>>> After this, the caller follows the same steps as in sequence 1 -
>>>>> hmm_range_fault() faults in !pte_present() pages, and migrate_vma_*() is
>>>>> called again to migrate the pages that were faulted in/waited on by
>>>>> hmm_range_fault().
>>>>>
>>>>> Now, for the CoW case that you mentioned, I'm going to assume that the
>>>>> caller wants write permissions otherwise nothing needs to be done:
>>>>>
>>>>> Sequence 1: hmm_range_fault() -> hmm_vma_handle_pte() records a fault
>>>>> (hmm_pte_need_fault() returns HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT),
>>>>> handle_mm_fault() -> .. -> do_wp_page() breaks CoW and maps an exclusive
>>>>> folio with write permissions, then the migrate_vma_* flow will take care of
>>>>>
>>>>> Sequence 2, migrate_vma_setup() installs migration entries for the page,
>>>>> then migrate_vma_finalize() replaces the migration entries with device
>>>>> private entries.
>>>>>
>>>>> Looks to me that for CoW pages, all that's needed is migrate_vma_*(), and
>>>>> the subsequent calls to hmm_range_fault() and migrate_vma_*() are not
>>>>> necessary. Is that your conclusion too?
>>>> For  a device fault: the driver want the data in device memory with the
>>>> permissions the device asked for. Your !pte_present() analysis matches;
>>>> note that pte_none() in anonymous vmas and the zero page don't need
>>>> hmm_range_fault() at all, migrate_vma_*() populates them directly.
>>>> That's why the common case is cheap with sequence 2, and only swap
>>>> entries, other devices private pages and migration entries need the
>>>> extra walks.
>>> Yes.
>>>
>>>> For cow with write intent migrate_vma_*() alone is enough.
>>>> migrate_vma_setup() doesnt break cow: it collects the shared page
>>>> through its read-only pte, so there's no MIGRATE_PFN_WRITE, and
>>>> try_to_migrate() unmaps all its mappings, so finalize installs a
>>>> read-only device private entry. 
>>>>
>>>> The device still cant write; a write then has to go through
>>>> migrate_to_ram() and break cow in system memory, and migrate again. To
>>>> get an exclusive writable copy on the device, cow has to be broken
>>>> before collectin, i.e. hmm_range_fault() with HMM_PFN_REQ_WRITE first,
>>>> then migrate: two walks.
>>> Makes sense, something did seem fishy with my analysis of the CoW case.
>>>
>>>> With this series that's one walk,
>>>> HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE | HMM_PFN_REQ_MIGRATE (or
>>>> MIGRATE_VMA_WRITE for migrate_vma_setup() users), and only the
>>>> now-exclusive page is migrated.
>>>>
>>>>>> The problem with the first sequence is that you always have to do two
>>>>>> page walks even when most of the time the pages are present or zero page
>>>>>> mappings so the common case takes a performance hit.
>>>>> This is the first mention of the zero page. Is the caller specifying
>>>>> HMM_PFN_REQ_WRITE? That makes a difference, because it triggers fault
>>>>> handling for the zero page, and that's an extra walk. Can you give more
>>>>> details here?
>>>> Good question on the zero page. With a read request it need no fault:
>>>> migrate_vma_*() populates it like pte_none(), and the HMM walk collects
>>>> it the same way. With HMM_PFN_REQ_WRITE it's write-faulted first, in
>>>> sequence 1 and with this series alike; the difference is that the series
>>>> faults and collects in the same walk.
>>>>
>>>>
>>>>> Let's count page table walks when a page is mapped with a valid entry, and
>>>>> with the required permissions. Let's say N is the number of mappings for
>>>>> the page (equivalent to the number of VMAs that map the page):
>>>>>
>>>>> hmm_range_fault() -> .. -> hmm_vma_handle_pte() does one page table walk,
>>>>> migrate_vma_setup() does N page tables walks, to replace all valid mappings
>>>>> of the page with migration entries, migrate_vma_finalize() does N page
>>>>> table walks, to replace the migration entries with device entries.
>>>>>
>>>>> In total 1 + 2*N walks. Best case scenario, N == 1 (PageAnonExclusive()),
>>>>> that's three walks.
>>>>>
>>>>> Do you have any data regarding how often the best case scenario happens?
>>>>> That's what you seem to be referring to in your comment.
>>>>>
>>>>> Now let's count the number of walks for a !pte_present() page mapped in P
>>>>> VMAs, where P != N: one from hmm_range_fault(), if the entry is not a
>>>>> migration entry, another walk in the fault handler, then 2*P walks from the
>>>>> migrate_vma_*() flow.
>>>>>
>>>>> If it's a migration entry, it requires 1 + 2*P walks, PLUS waiting on
>>>>> migration to complete, which cannot be skipped.
>>>>>
>>>>> If it's a swap entry, it requires 2 + 2*P walks, PLUS waiting on swap.
>>>>>
>>>>> If it's a device private entry belonging to a different device, it requires
>>>>> 2 + 2*P walks, plus waiting on the device to sync the memory with the
>>>>> device in migrate_to_ram().
>>>>>
>>>>> To summarize:
>>>>>
>>>>> pte_present()	1 + 2*N walks
>>>>> migration entry	1 + 2*P walks + waiting on migration
>>>>> swap entry	2 + 2*P walks + waiting on swap
>>>>> device private	2 + 2*P walks + waiting on device->memory sync
>>>> On counting: the 2N (or 2P) rmap walks that replace the mappings with
>>>> migration entries and then device entries are inherent to migrating the
>>>> page and are the same in all variants. What differs is the number of
>>>> page table walks over the range: sequence 1 allways does two
>>>> (hmm_range_fault(), then migrate_vma_setup()), sequence 2 one if
>>>> everything is present and three otherwise, and the HMM walk one, with
>>>> faults handled in place and the walk resuming from the faulting
>>>> address.  The saving is per range walk, so it scales with the range.
>>> I think we might need to define what you mean by 'saving'. Normally, I
>>> would assume that you mean that 'the total time of migration is decreased',
>>> but the fact that the benchmark that you offered doesn't show this makes me
>>> wonder.
>>>
>>> The more !pte_present() pages are in the range, the smaller the amortized
>>> cost of a walk per page in the range. For example, using sequence one, for
>>> 512 !pte_present() pages, the current code does an extra 1/512 page table
>>> walks per page (for sequence two, an extra 1/512 * 2 walks). At the same
>>> time, for each page it needs to do a fault, or swap in, or wait on
>>> migration, or break CoW, or put migration+device entries in each VMA that
>>> maps the page.
>>>
>>> I think the worst case scenario is the device wanting to fault in one page
>>> from system memory. Is that what usually happens?
>>
>> Well that's what the nouveau does currently, but as I write in the
>> commit log, a better policy would be nice... Otoh, that works as a good
>> stress test on the code when pages migrate back and forth on demand.
>>
>>
>>>
>>>> I don't have data on how often the best case happens. The motivation
>>>> came from earlier prototyping of migrate on fault on the current
>>>> interfaces, where the extra walks showed up in perf traces. For the
>>>> typical SVM case of private anonymous memory without fork the pages are
>>>> exclusive (N == 1) or not yet populated, but I haven't measured a
>>>> distribution.
>>> Got it, that's what I wanted to know, the typical case is exclusive memory.
>>>
>>>>>> The second sequence is better for the common case, but far worse if
>>>>>> pages aren't present because now you have to walk the page tables three
>>>>>> times (once to find the page is not present, once so hmm_range_fault()
>>>>>> can find a non-present page to fault in and once again to setup the
>>>>>> migration). It is also tricky to code correctly. One page table walk
>>>>> Valid entry, the page is mapped in N VMAs: migrate_vma_*() does 2*N walks,
>>>>> best case scenario (PageAnonExclusive) two walks.
>>>>>
>>>>> !pte_present, the page is mapped in P VMAs:
>>>>>
>>>>> migrate_vma_setup() -> migrate_vma_collect() will always do one page table
>>>>> walk, regardless of what it finds, valid or invalid entries.
>>>>> migrate_vma_collect() ignores !pte_present() entries, and they will not
>>>>> trigger new walks in the next steps in the migrate_vma_* flow. Worst case
>>>>> is that all the pages are !pte_present(), that's one walk to find them all
>>>>> which I would say it translates to zero extra walks for an individual page.
>>>>>
>>>>> For hmm_range_fault(), it's the same situation as above: 1 + 2*P or 2 + 2*P
>>>>> walks.
>>>>>
>>>>> To summarize:
>>>>>
>>>>> pte_present()	2*N walks
>>>>> migration_entry	1 + 2*P walks + waiting on migration
>>>>> swap entry	2 + 2*P walks + waiting on migration
>>>>> device private	2 + 2*P walks + waiting on device memory->memory sync
>>>>>
>>>>> I agree with you, this second sequence is better for the common case.
>>>>>
>>>>> I think it would interesting to know:
>>>>>
>>>>> 1. Is there a relationship between N and P, and if there is, what is it?
>>>>> Are they equal, on average? I doubt it. Is a !pte_present() page likely to
>>>>> be mapped in more VMAs than a pte_present() page, or fewer?
>>>>>
>>>>> 2. What is the likelyhood of P being equal to 1 (PageAnonExclusive)? That
>>>>> would be interesting to know because the larger P is, the contribution of
>>>>> that extra walk (or two walks) to the total time becomes less and less
>>>>> significant.
>>>>>
>>>>> 3. How does the time to do the walk compare to the time spent waiting on
>>>>> migration, or waiting on swap, or waiting on device to memory sync? How
>>>>> often each of them happen? I have a hunch that these will tend to dominate
>>>>> the total time.
>>>> Yes, when a page needs swap-in, a migration wait or a device sync, that
>>>> wait dominates..
>>>> The walk saving matters on the common device fault path, with small
>>>> ranges (one page per fault in the nouveau patch) and present or
>>>> unpopulated pages: one walk instead of two, and without sequence 2's
>>>> three when part of the range isn't present. But the main point is one
>>>> call that faults and collects consistently, instead of two with a window
>>>> in between where the range can change.
>>> This is introducing another variable into the mix. It's not just the number
>>> of page table walks, it's also the fact that in between walks the mapping
>>> might have changed. I think this is why it's good to have a representative
>>> benchmarks :)
>> ack
>>>> I don't have data on N and P. For private anonymous memory without fork
>>>> or KSM both are normally 1, but I haven't measured it.
>>>>>> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>>>>>>
>>>>>> We should be able to walk the page table once, faulting
>>>>>> pages in as required and replacing them with migration entries if
>>>>>> requested.
>>>>>>
>>>>>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>>>>>> which tells to prepare for migration also during fault handling.
>>>>>> For the migrate_vma_setup() call paths, new flags, MIGRATE_VMA_FAULT,
>>>>>> and MIGRATE_VMA_WRITE are added to tell to add fault handling to migrate.
>>>>>>
>>>>>> An extra benefit of migrating with hmm_range_fault() path
>>>>>> is the migrate_vma.vma gets populated, so no need to
>>>>>> retrieve that separataly.
>>>>>>
>>>>>> This series avoids the problems in current collecting implementation,
>>>>>> where racing MADV_DONTNEED could make the collecting arrays overflow.
>>>>> Can you provide more details here? How does it happen?
>>>> migrate_vma_collect_pmd() drops the pte lock to split a large folio and
>>>> restarts with [start, addr) already appended to src[]/dst[]. If a racing
>>>> MADV_DONTNEED zaps the range and frees the pte table meanwhile, the re
>>>> start takes the hole path from start and append [start, addr) again,
>>>> writing past the arrays. "mm/migrate_device: don't collect a range
>>>> twice" in Lorenzo's batch fixes that instance; this series collects into
>>>> the address-indexed hmm_pfns and fills src[] only lastly, so re-walking
>>>> cant overrun. Also, the correct pages are collected with the re-walk
>>>> with this series(rollback takes care of the old ones).
>>> That can be accomplished with the upstream code too, this series isn't
>>> required (just off the top of my head, keep a local counter for the total
>>> number of pages collected by migrate_vma_collect_pmd(), use it as an offset
>>> into migrate->src and migrate->dst, and reset the counter on the 'again'
>>> label).
>>
>> It's not that simple.. you have to rollback (unlock + unref) the so far
>> collected pages. And to collect then the right pages from the start you
>> have to rewalk and collect those again (and possibly a PMD as huge). Of
>> course something like that can be done to current code, but address
>> based indexing is more robust, and you end up with something like the
>> HMM based collector :)
> 
> Okay.
> 
>>
>>
>>>
>>>> There are couple other defects the series fixed along the way.
>>> Hmm... the size of this series might put off some people who are interested
>>> only in the fixes. Have you considered splitting them into standalone
>>> patches/series?
>>
>> I might, but they don't apply directly to current collector.
> 
> Okay, so the fixes require your patches and they cannot be adapted to the
> upstream code, have I understood correctly?

Sure can be adapted with some effort. I haven't yet gone into the details though.

> 
>>
>>
>>>
>>>>>> This is achieved mainly by having a rollback mechanism and
>>>>>> populating the collecting array as the last step.
>>>>>>
>>>>>> Tested in X86-64 VM with HMM test device, passing the selftests.
>>>>> Have you tested that this series doesn't regress other architectures?
>>>> Only tested on x86-64 (VM with test_hmm, and nouveau on a GP102). The
>>>> code is arch-independent, but it isn't tested elsewhere.
>>> Sorry, I'm a bit confused - what do you mean by it isn't tested elsewhere?
>>> x86-64 specific code is the only user for the arch-independent code?
>>
>> I haven't personally tested on other arches the selftest (though I don't
>> see why there would be problems to do so).
> 
> Okay, but you might be surprised. The selftests I can run myself an arm64
> machine.

Yes good to check!

> 
>>
>>
>>>
>>>>
>>>>>> The main goal of this patchset is to provide a new feature,
>>>>>> migrate efficiently on fault, and not directly improve performance
>>>>>> of current migrate_vma_setup() (which is now routed thru
>>>>> I'm a bit confused by what 'on fault' means in this context? Userspace
>>>>> accesses a device entry, access that causes a fault, or using
>>>>> hmm_range_fault()? I assume the latter, but it pays to make sure.
>>>>>
>>>>> Also, can you define efficiently? Usually that's related in some way to
>>>>> performance, but immediately you say that the series doesn't aim to improve
>>>>> performance.
>>>> "On fault" means a device fault: the driver services a GPU fault with
>>>> hmm_range_fault(HMM_PFN_REQ_FAULT | HMM_PFN_REQ_MIGRATE) and migrates
>>> Got it, thanks.
>>>
>>>> the page while handling it. "Efficiently" was the wrong word: I meant
>>>> faulting and collecting in a single walk, instead of two or three calls
>>>> with a window in between. I'll reword the cover letter.
>>> Ok, gotcha.
>>>
>>>>>> hmm_range_fault()) callers. That said, the migrate throughput tests
>>>>>> from the selftests show that there is at least no regression for
>>>>>> current migrate_vma_setup() callers.
>>>>> If the premise of the series is to reduce the number of page table walks in
>>>>> the !pte_present() case, then I think benchmarks that show a performance
>>>>> improvement would make a compelling case for this approach.
>>>>>
>>>>> Some thoughts, if I may:
>>>>>
>>>>> - Perhaps the existing test is not the right test to highlight the
>>>>>   performance gains?
>>>>>
>>>>> - Perhaps there are other parts of the migration process that dominate the
>>>>>   walks? If so, maybe we should be focusing our attention on those?
>>>>>
>>>>> - Perhaps the series adds overhead that reduces or cancels the gains from
>>>>>   reducing the number of walks?
>>>> I don't have a benchmark showing a gain: nouveau had no migrate on fault
>>>> to compare against, and the selfftest throughput tests use
>>>> migrate_vma_setup() on present pages, so they can only show there's no
>>>> regression, including from the extra work in the HMM walk. Also, any
>>>> help with new tests is greatly welcome :). My primary focus atm is
>>>> getting the final corner case details sorted out in the core and
>>>> addressing sashiko; with v18  i hope being there. 
>>> This is how I see this series, please correct me if I got something wrong.
>>> The aim is to reduce the total number of page table walks over the range by
>>> one or two (depending on the sequence of functions used) when
>>> !pte_present(), or when pte_present(), but without write permissions.
>>>
>>> From our discussion so far it seems to me that the total migration time in
>>> the above cases depends on a number of things:
>>>
>>> - In how many other VMAs these pages are mapped, as each mapping needs to
>>>   be replaced with migration entries, and then with device special entries.
>>> - How long it takes to swap in the page, if the page is mapped using a swap
>>>   entry.
>>> - How long it takes to complete a concurrent migration, if the page is
>>>   mapped using a migration entry.
>>> - How long it takes to migrate a device entry back to system memory, if the
>>>   page belongs to a different device.
>>> - If the page is CoW, how long it takes to break CoW.
>>> - What happens in between walks.
>>>
>>> The code touches 2,600+ lines of code, with almost 1,300 lines added.  It
>>> removes those extra page table walks, of course, but it also offers plenty
>>> of scope to add new inefficiencies (or bugs), and if that's the case, we
>>> don't gain anything other than complexity. 
>>
>> The saving isn't only for !pte_present() or read-only ptes. Migrating on
>> device fault today takes two separate steps: hmm_range_fault() to fault
>> the range in, then migrate_vma_setup() to collect it. That's two walks
>> even when every page is already present and writeable, and the range can
> 
> If all the pages are present and with the required permissions, why isn't
> migrate_vma_*() enough?

It is enough in that case, but the driver handling the device fault doesn't know that in advance.
A fault handler has to cover the general case, so it does hmm_range_fault() first and 
migrate_vma_setup() after it, which is two walks even when nothing needed faulting. 
Checking first whether everything is present is itself a walk.

> 
>> change in between, which is your "what happens in between walks". The
>> driver then has to detect that and retry, error prone and nasty task...
> 
> Yeah, that 'what happens in between' looks very unpredictable.
> 
>> With HMM_PFN_REQ_MIGRATE, faulting and collecting happen in one walk, so
>> there's no window to recheck. I think migrate-on-fault fills an
>> important gap in the Linux SVM toolbox by integrating page fault
>> handling and memory migration into a unified operation.
>>
>> The costs you list (other mappings, swap-in, waitting for a concurrent
>> migration, migrating another device's page back, breaking cow) are
>> inherent to migrating those pages. They're the same with or without this
>> series. 
> 
> Indeed, and my point was that those costs dominate the cost of the two
> walks. And because of that, it is entirely possible that removing the
> two walks does not reduce the time to do migration in any meaningful way.

It could be far more than two walks, and incomplete with races. Look all the
trouble Xe driver sees doing migrate on fault, which is consequences of
the missing MM primitive.

Sure you can find a case where HMM_PFN_REQ_MIGRATE doesn't make much difference.
There are cases where it does. It unifies the walks, you choose if want a faulting
behavior or not. The new code covering both behaviors will also be AI checked
from the start.

> 
>>
>> On size: in mm/ and include/ it's +1378/-602. Most of the removval is
>> the old migrate_vma_collect*() walker, since migrate_vma_setup() now
>> collects through the same hmm_range_fault() walk. Existing
>> migrate_vma_setup() users get that path without driver changes. The rest
>> is nouveau as a user (+561, including two independent dmem fixes split
>> out as separate patches), test_hmm and the selftest (+283), and
>> documentation (+121). These are my current numbers.
> 
> Of course.
> 
>>
>>> I think having a benchmark
>>> representative of a real workload, or a real workload, that shows a
>>> decrease in the total migration time will be great to demonstrate that we
>>> are on the right track :)
>>
>> Absolutely - cool if you could work on that side perhaps :) ?
> 
> Sorry, but I don't think I'm the right person to do that. I'm don't know
> what a representative workload would be,

That's okay :)

 and I'm not entirely convinced
> that these changes actually make things faster.

I believe it's the right approach to do migrate on fault. I have brought up
other aspects above also that speak for the series.

> 
> Thanks,
> Alex
> 

--Mika



