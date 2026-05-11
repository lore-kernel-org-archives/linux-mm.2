Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1913CCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692F66B00BA; Mon, 11 May 2026 09:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643BB6B00BB; Mon, 11 May 2026 09:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532496B00BC; Mon, 11 May 2026 09:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7926B00BA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:24:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0D0016010A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:24:16 +0000 (UTC)
X-FDA: 84755207712.19.FD71ED6
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 676051C000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:24:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tR6uiK4v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778505855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5z8Lm7PbYzdvsHr44p/Kq/5LGVMLu1AFqGqWWK02nUg=;
	b=BXoQMNA7VxOHntW/lFpzIjfIIobyEIEQFKz56AnsYbspBSM5nZtWgT5RciFh6tDVHuhKqa
	cpfBs8FMr25BLgoGeOyoWxOmAdCXGwyiJgDlACLkHt55yuxdjjj439yVCiltU8oKepEhEy
	SI/rcZgy8qrlyidnKoJ+GQnyrqcScxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778505855; a=rsa-sha256;
	cv=none;
	b=IrHT4hkGTrooVBEd/GSl8QDiAi/YMsrhGO0fUFnMiL5KuImH7uw98MBHwu9AYBm1hX6Na5
	c+7p2GkDkTMqFyNmT4tbb+gtexLxh1TILFUBk/Jb7Q4ebbpRVYbgYCYkpN8f7vzgqWVoG1
	1vJatnVvR9vdDapu+Z7JRNkoqAi010U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tR6uiK4v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778505849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5z8Lm7PbYzdvsHr44p/Kq/5LGVMLu1AFqGqWWK02nUg=;
	b=tR6uiK4vEp5eioru6Ipra4Az/BhAvo1kWF1fPx6I9XeodPF8HIrBISmioNv7imWa3B6iiI
	/VEPQtEj82FsW6aw7jq/5BB4OkswlViDVjO+jJucIVX6gDAj4r/773nRMQen1GTVH5A6RO
	KhzO5EEzI5sjkIVCHpA+MgQlMRr49rQ=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] drivers/base/memory: make memory block get/put explicit
Date: Mon, 11 May 2026 21:23:18 +0800
Message-Id: <3234B4D3-8202-4E79-B85B-8B6373BB76F6@linux.dev>
References: <2841f424-580c-48c6-bb26-de30e4397b7f@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-mm@kvack.org,
 driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
In-Reply-To: <2841f424-580c-48c6-bb26-de30e4397b7f@kernel.org>
To: David Hildenbrand <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 676051C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: c19637qkc7srf7k9q6aok7iagjka3hot
X-HE-Tag: 1778505852-736638
X-HE-Meta: U2FsdGVkX1/jEcwOUT/DTup8NslorUYz8mwM6Fp39cMpOvMhm9cwugEd2mjfNTXN9Y23S1JPq61wRG2iryrqJphAXQrVnXy0H+ufgvhxgfyAbLXuPn/2d6uXFHig9KjtCZx8QlG4kfnDBUTVGtRqyzdyQawBvXr3K+ncCCOCk+LcM7Uj1d+k1ZxLiRQBi0pYfSYhcAhMaHhUfnDD5oQBSIZFqTXws7ewUseIi3vic2f404Am9ZvjDOnTOSefZT27274eSF4Xme4Wu2weYLv/3WsfBRSuWcBuFXcUI/XrAd6siPKIdRjBZdd6hFVWfNAXcLkyLeKCSgciDSSHDfUtow4U38gP8d1dXpfSxQzqMeDeaD5MTpjp/QH3T0pWV4j/nJwIdTUQUcI7G59Ti4lvnSj3buyujNwqKE/Lrw7avfXCOlmlItMCibtxjQpW9rDO337psJOKIY4GDL60Ec7LYxlwGROF99PGkR2dsgBsuyK3ayxsDlSZVEsPnh6AR2j9mJz6quaOzhx44/qJzAmH2Pr0OhMzlPETJjcMJNYM0NDWRaKrv+O7jrg7AHMcZe4T6QuyQda3wsvHuO5GBAuHFOj8TGgFk7VkUSEVekBbL1Y9otFrUkSaDkCbCQX7Juh6jZQ0C8cygiCa2H44mLariA3IYpAV0ISOLjlD7K6YiGnKXnIEI6A9GtdJ8DVx9aQkJk7d2eMaAcAWFQ3xnrwGxvLGQwBytCJAZ7AOuXPgQGdaBzohG0kJXisKtbaywcQzbXpEP54v4+dWb97xTOLtPQlsd/2N/re5Z/xJKI+VuBX0rfu8YWVGByJS2THjo2QSGqlaK4TtMhk96AAeYHQr+nrV9TBetB71P6JvU8SzMsy+POUOfbMSV7v114CmfxrNKY1ZkSlchwmBkh3Em7mQqIKMS+24L7rEk3jJvseNZwxhCF00AiV1f5TalKZG8s00hwsxr0Dij6HTfyzRL17
 c6TdSBmP
 +ZbcD9sK3Bfy3Ac3Q6XShmDZafterUYgot1esXZW+I38AaPFBLsEmtyjiGgxSsuyEZn2NIvWjJWg0WOPh8JZLZzbaItYGNXXMj8BswnDtdnBMKhO1y1Gez1l8eMVp8RXbKyN4S0hYS1+Ih9Dol/QARcgnjj8twFu2UnwoPGx3BEq8keBOYMxPsQhR7LUIPCVWnxmLhDQehmECG+h2D2mDWwM+iH9uJH0oTDzkIYvWBCukKjpVKrrz/Z34itg0STEEHjClJvesH8WbUzzl38AlUHOWsvzwqhD8UWm4Q/YMtbqah3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 11, 2026, at 20:22, David Hildenbrand (Arm) <david@kernel.org> wrot=
e:
>=20
> =EF=BB=BFOn 5/11/26 13:18, Muchun Song wrote:
>> Rename the memory block lookup helper to make the acquired reference
>> explicit, add memory_block_put() to wrap put_device(), and collapse the
>> redundant section-number wrapper into a single block-id based lookup
>> interface.
>>=20
>> This makes it clearer to callers that a successful lookup holds a
>> reference that must be dropped, reducing the chance of forgetting the
>> matching put and leaking the memory block device reference.
>=20
> Better mention some of the other changes here, like removing find_memory_b=
lock().

Will do.

>=20
> [...]
>=20
>>    unlock_device_hotplug();
>> diff --git a/include/linux/memory.h b/include/linux/memory.h
>> index 5bb5599c6b2b..29edef1f975c 100644
>> --- a/include/linux/memory.h
>> +++ b/include/linux/memory.h
>> @@ -158,7 +158,11 @@ int create_memory_block_devices(unsigned long start,=
 unsigned long size,
>> void remove_memory_block_devices(unsigned long start, unsigned long size)=
;
>> extern void memory_dev_init(void);
>> extern int memory_notify(enum memory_block_state state, void *v);
>> -extern struct memory_block *find_memory_block(unsigned long section_nr);=

>> +extern struct memory_block *memory_block_get(unsigned long block_id);
>=20
> While at it, please drop the "extern".

OK.

>=20
>> +static inline void memory_block_put(struct memory_block *mem)
>> +{
>> +    put_device(&mem->dev);
>> +}
>> typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
>> extern int walk_memory_blocks(unsigned long start, unsigned long size,
>>                  void *arg, walk_memory_blocks_func_t func);
>> @@ -171,7 +175,6 @@ struct memory_group *memory_group_find_by_id(int mgid=
);
>> typedef int (*walk_memory_groups_func_t)(struct memory_group *, void *);
>> int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
>>                   struct memory_group *excluded, void *arg);
>> -struct memory_block *find_memory_block_by_id(unsigned long block_id);
>> #define hotplug_memory_notifier(fn, pri) ({        \
>>    static __meminitdata struct notifier_block fn##_mem_nb =3D\
>>        { .notifier_call =3D fn, .priority =3D pri };\
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 462d8dcd636d..890c6453e887 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1417,14 +1417,13 @@ static void remove_memory_blocks_and_altmaps(u64 s=
tart, u64 size)
>>        struct vmem_altmap *altmap =3D NULL;
>>        struct memory_block *mem;
>>=20
>> -        mem =3D find_memory_block(pfn_to_section_nr(PFN_DOWN(cur_start))=
);
>> +        mem =3D memory_block_get(phys_to_block_id(cur_start));
>>        if (WARN_ON_ONCE(!mem))
>>            continue;
>>=20
>>        altmap =3D mem->altmap;
>>        mem->altmap =3D NULL;
>> -        /* drop the ref. we got via find_memory_block() */
>> -        put_device(&mem->dev);
>> +        memory_block_put(mem);
>=20
> Would guards come in handy here?

You mean to introduce something like:

scoped_guard(memory_block, id) {
}

Right? If yes, I will give it a try.

>=20
> In general
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

Muchun

>=20
> --
> Cheers,
>=20
> David

