Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBEA606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=epD/pGIB
Received: by kanga.kvack.org (Postfix)
	id 099D16B05C4; Thu, 12 Nov 2026 09:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070D26B05D6; Thu, 12 Nov 2026 09:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC87F6B05D7; Thu, 12 Nov 2026 09:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BED746B05C4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:47:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E41E140608
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:47:52 +0000 (UTC)
X-FDA: 85426746384.02.E4C996F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9AB421C000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:47:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="epD/pGIB";
	spf=pass (imf18.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794494870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZkO3ck5ylqqxi0UIrlQRRScttZ5TDTGZ/TrwmDCCvM=;
	b=SMxkKcDeFFokUDHeDuHyE/kKz+3TBEFe647pvguH21Fe5KH60HyZxHzF4XoaUGOdo1Gprn
	u1HAbwdTuSOikpKPpUhAxwXWFcZCgnkYZa8fbYZS/ieB+S8vowlrpO+eU/dsj49xyuttGr
	5l7q53k8cTQFgspKSuq0HPMBxfUoddk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794494870;
	b=4tkfICH59o6ot+iKthiG8ShSr/8IQJtVC3i3Do+pJkJJWSHPreRTeOSYXkyontlpW6+MW1
	+I1VkWJgjHDG7kH+sdAUf/KWtUlzp4eKxY8swsKR/OWeD0PyhtPmLqS+c62pYqPGrVv21s
	AGkHfCW2+EuFM4/3vbkTgigSf6Memm4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="epD/pGIB";
	spf=pass (imf18.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794494869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZkO3ck5ylqqxi0UIrlQRRScttZ5TDTGZ/TrwmDCCvM=;
	b=epD/pGIBUMPS8zjQ/M9OFPEoR70UQWV1Jl1vOdWBlhxmNGwSSK0KptMXZrYtIzz9nK+BO+
	gSCadsu9XoX71K9bLl2sE8PsMayLri5T8mW5xljmCsOTp7wPuPkQeVMzvNPwoekjxZeDj+
	jH5a5s1HSSxsxzAXjEyBXJLAmTIxzGM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-kFSgUri8N5WvCNhojxkQGg-1; Thu, 12 Nov 2026 09:47:47 -0500
X-MC-Unique: kFSgUri8N5WvCNhojxkQGg-1
X-Mimecast-MFC-AGG-ID: kFSgUri8N5WvCNhojxkQGg_1794494866
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3ad00533aa8so26271331fa.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:47:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794494866; x=1795099666;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zZkO3ck5ylqqxi0UIrlQRRScttZ5TDTGZ/TrwmDCCvM=;
        b=mmhAg7V/mFQurOB7YAaYPK9S9HJNrZmMhvhi473l6D4W7PibyOucj+ccek1bJ6MkLT
         NhzSe9KzcsCyjq/KDp0WdQpyjuj1WIplF6q/WSt5UYQ+jn5/d7u4Hrg0W7MLob39W2wr
         ham5z+3rcO0FcGH+G2oWz+qj+MJ4yZ25nqFX7dnJ0C6okae8iz5fTiEAsQ3zvop7zuGk
         fN88Txf1/3+M9y4kJYib02pNM4MOyV1gs66Ho87FBR/hAFIjaGJ21tH1urSEMZcdjTEs
         qs0ScnQXn5WewQaVZVvF8/P3KJ2jRmHtTwKDwVtI1WgBJ+P9Tpqs2boRWnSld8KJLWB9
         kAfQ==
X-Gm-Message-State: APuU4Z8iGlugDCmVzXeJhuqash0XyJD0PcrCtacrca0OO3m1CfiqWyeQ
	opQEoYQ68tEp8jDEHfjFvyierf7Mt+5nei2Ey6CecsLI3MuGct0rT07N19AkHUoSNpnSqvFSybm
	dimSUWD3S+KETEakW7cCvZlxiBBwjKLlX4rU8nwB/xFWY4R3SC8M=
X-Gm-Gg: AYBFou2trDJHCztsRsI72qs2+XAM5sp9hn3IAXi8kndztQMP7nNDTOKnnv2RxEF5UW+
	5BuLvcvAb/vK08qPGfFzozxq+qgqSodbcxpLBGpzt9nM85JrUQdY+xDBADI0DlQRUI5EaTDiwXw
	lN3offZrkWst3b+WJv3P3DLWw7OvIZVfhGXrlgKLoafIx4LRkIYJy24bbm/JoPKOyrFu29nzQQq
	SWjFyO4EmMMlvpwVGMQ2VzaBQyiPjTsTAfDF2FBLGwZ2u4qBnMHq9jqT+IBTvpsG0jnAMERR7KS
	5Fk9lPlqSdQGFHDNMoOoPNcbnWpEs/I3BzYzCm6Dq60Lk6bpg/hwgQsvAYu2iKNpW14TCHAqK0F
	RAy7fsZVbNRMSvEFxcx+1ThMECasXOrbg7in5aVPy9HArkS5CCzwZIxV2Ks+q8FkL9eEHHKSSUi
	pxVbP/
X-Received: by 2002:a05:6512:2524:b0:5c1:57ee:1887 with SMTP id 2adb3069b0e04-5c15d62c702mr2219394e87.13.1794494866135;
        Thu, 12 Nov 2026 06:47:46 -0800 (PST)
X-Received: by 2002:a05:6512:2524:b0:5c1:57ee:1887 with SMTP id 2adb3069b0e04-5c15d62c702mr2219357e87.13.1794494865616;
        Thu, 12 Nov 2026 06:47:45 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c157bab834sm1698450e87.45.2026.11.12.06.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 06:47:44 -0800 (PST)
Message-ID: <b3689045-d735-451b-8cda-a29d7e79fe63@redhat.com>
Date: Thu, 12 Nov 2026 16:47:43 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
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
In-Reply-To: <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JWhWCzZgA27pUKTTIaNjPTwSyB2B7BmHMmTZGuPOhVk_1794494866
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AB421C000C
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: sgd7bwdf5wtewdh96bohnk5gktqtphgg
X-Rspam-User: 
X-HE-Tag: 1794494869-759622
X-HE-Meta: U2FsdGVkX1/evcqm57JCE4BmoFLqt4SKT7GjQVDekz8mn4Yce/AIkN49h/ywpfkgHfHbJdZUWSOdxMI/CmVaW1t4b5AsVNnH4O532/yyReBJJxjA+SMoAruRyLWW7P6eDT3drK87nQrQ5SVXzv9g5kypveE0ZdrJe/1rtXcSmKPVJJxSpfOvzgs+eEr/uCN07AeF8Cib0aIdD497MfTZPgvFUIUj1WWnrsF3AGveJAyAkotnJizH3hYw3tY7O54kcLuZajWxidHD6VfOhd71ygQ7ls2FKVhAG4gYLH74c2zsz77JzyCoue41f4kpom+Q8cCZT1RegBGkRQQWnee4LJCf+sbpz/L33GJWOVFkVbWO6C+yBiUUUQCtY5excM9pCJ5jD3mpY+zqcxQVi3NWKTo/5OaWUqBxOykeBuXvbOGujIlXZ3sqBrsxvYNhSoKh6P8zaaRN/Hw5Lh+YxyUWJnfnJAR4+ZuZJxZeIC5zCWcL+V3sBRUx0QBktgEkVhzn9sl2hX6GDJ/H5mejMEj4xi0O486BaOrKWQoSaxSyHLyLMZCaw5PCjdabJNp+8TgoQ+FO/B7P9FG3varuNUO+N2eI5vBuND1zmSgN/1kY2mOugPlpf6ZzaUcwVJrGt0j9tbr3KzOiLEjOrwYhb7ud6unUHUJZLfV7xi60qcG+h6iq5OsmzxqEtC8wB96ojyMIo2PPxyG/F+seNDGmg0bSugRUKAbjvRJM8W3cUDwuwn1AaFbUHb/mMDehL/nrsDqpCeRtHCK67oMURYW9HgrjKxlZ79Qju4g4oIax6Gi6rYhre47FnGNU5wAi7D8hGh/N8Yz8//bWy5Jx3jphIx+JBILw43VAs56RR6USkx8O3RR5Wy7/tlTe1OAxWwnTDyP+O8656o3tFTf0BgP3Kxs/FZoXf034A+7hF2xs660Wr1wedcRCkF1A5LfalZxwYul1gYrUrA4E7dDFHU9oVmC
 Wu9xxYnC
 kuz47d4BHvA4AI3LWLFcQ7EpaSZY4NuBpWbU8gL0bA7IbxNGz7ApQkIcz32kO0ZnV+Gz9vwGlekAnQAI9JkvWUSzw+qvC0UqeTtKTe1GJFY9eB521Q41ThPVJZVgQQxYJpxXrb1342yXj73aJoK1JQH9CDxffxspClktiGIAychZ7Qz2NoCQjlpSpm+aHpzSBdgX1rpwyGr1aAf6EUPdnedEu9Ifcn/Hlizd8+1oN0nMBsi22nsjkDvdTahOYSY51OeII7Ov5rqI0EDVJUdpomI/0pPhGiaIbjClN6GutBTtscwPyeKbxO+tROnO/PL5IGiLvCbB6ZbK+R4q2bJPmsII0yRGRJUvrnPNDJb+/RGIbU+RH/YAdecW0/M40eV3Nv5OB74K3n/Q2keW7sFtgXPd2lH5u9jgVFMLa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/12/26 16:00, Mika Penttilä wrote:
> Hi Alexandru!
>
> On 11/12/26 13:56, Alexandru Elisei wrote:
>> Hi Mika,
>>
>> I want to help getting this series merged, and I've been familiarizing myself
>> with hmm and device migration, please bare with me if the questions I'm asking
>> are obvious or downright silly.
> Thanks for the interest and willing to help! I am preparing a v18 of the
> series and plan to post it early next week.
>
> I try to answer your questions, there are quite a bunch of them!
>
>> On Tue, Nov 03, 2026 at 08:16:17AM +0200, mpenttil@redhat.com wrote:
>>> From: Mika Penttilä <mpenttil@redhat.com>
>>>
>>> Currently, the way device page faulting and migration works
>>> is not optimal, if you want to do both fault handling and
>>> migration at once.
>>>
>>> Being able to migrate not present pages (or pages mapped with incorrect
>>> permissions, eg. COW) to the GPU requires doing either of the
>>> following sequences:
>>>
>>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>>> 2. migrate_vma_*() - migrate the pages
>>>
>>> Or:
>>>
>>> 1. migrate_vma_*() - migrate present pages
>>> 2. If non-present pages detected by migrate_vma_*():
>>>    a) call hmm_range_fault() to fault pages in
>>>    b) call migrate_vma_*() again to migrate now present pages
>> Regarding both sequences, I'm trying to get a better understanding of what
>> the issue is. I assume the caller wants to fault in system memory, and then
>> migrate it to the device. Is that correct?
> Yes that's the common thing to do.
>
>
>> In my analysis I'm also not going to refer to THPs, since that would make
>> things even more complicated than they are. I think we can come back to
>> THPs later if we think it would be useful.
>>
>> For the !pte_present() case:
>>
>> Sequence 1: hmm_range_fault() -> .. -> hmm_vma_handle_pte() handles
>> !pte_present() pages in two ways: faults in swap pages and device private
>> pages belonging to a different device, and waits on migration entries. Then
>> the migrate_vma_*() flow is used to migrate the range.
>>
>> Sequence 2: migrate_vma_setup() ignores !pte_present() page table entries
>> After this, the caller follows the same steps as in sequence 1 -
>> hmm_range_fault() faults in !pte_present() pages, and migrate_vma_*() is
>> called again to migrate the pages that were faulted in/waited on by
>> hmm_range_fault().
>>
>> Now, for the CoW case that you mentioned, I'm going to assume that the
>> caller wants write permissions otherwise nothing needs to be done:
>>
>> Sequence 1: hmm_range_fault() -> hmm_vma_handle_pte() records a fault
>> (hmm_pte_need_fault() returns HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT),
>> handle_mm_fault() -> .. -> do_wp_page() breaks CoW and maps an exclusive
>> folio with write permissions, then the migrate_vma_* flow will take care of
>>
>> Sequence 2, migrate_vma_setup() installs migration entries for the page,
>> then migrate_vma_finalize() replaces the migration entries with device
>> private entries.
>>
>> Looks to me that for CoW pages, all that's needed is migrate_vma_*(), and
>> the subsequent calls to hmm_range_fault() and migrate_vma_*() are not
>> necessary. Is that your conclusion too?
> For  a device fault: the driver want the data in device memory with the
> permissions the device asked for. Your !pte_present() analysis matches;
> note that pte_none() in anonymous vmas and the zero page don't need
> hmm_range_fault() at all, migrate_vma_*() populates them directly.
> That's why the common case is cheap with sequence 2, and only swap
> entries, other devices private pages and migration entries need the
> extra walks.
> For cow with write intent migrate_vma_*() alone is enough.

Is *not* enough meant to say


--Mika



