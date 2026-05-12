Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C25E8CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 03:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5126B008A; Mon, 11 May 2026 23:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C966B008C; Mon, 11 May 2026 23:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2923D6B0092; Mon, 11 May 2026 23:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7FF6B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 23:12:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABA9B402B6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:12:23 +0000 (UTC)
X-FDA: 84757294566.13.BCC46F7
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4CB3914000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:12:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Azi14Ppr;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778555542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4poRjePR6cFEz+knzlKugzzQz/9NFbmis/RU8TnLm8=;
	b=TQlBucjvveJ9ae16Tri/kcOAHSECPpMrtKHJvaAER5Y0XkwQR++83dTbvRHifKEqCdTdXl
	R+AYEeyodFCtWmv1+PsDYH+2lbOYWOUxzKpK31+ALdXTmFN2uW5eZjPQr3tnyEt5pvXi9l
	tJSVhEj/p8ZcUyK+iYFPP379GQjGKD0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Azi14Ppr;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778555542; a=rsa-sha256;
	cv=none;
	b=HmY+Fpp4Z0KLWi9irhvbyTMvKKSPa3ReKgvnEcqthuZ6Ohwmj63O3fqKrDT/nMU6Rn2tje
	EEZ/mCoI4+E2f2QP2tvPOjj2dEHow67lC/9qfm1vUdVRJ2xjOSWDuNRRQh4navbTb7EQtI
	SdcKbGunLaW+Ta54jtuPsgEHtLs+2tA=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778555537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4poRjePR6cFEz+knzlKugzzQz/9NFbmis/RU8TnLm8=;
	b=Azi14PprPniBe1V5WjMKA+afCZiQgf72uIBSnpUmv60pYeWqC3IjNVcI+F6g/cUtrfmtoK
	9eWQnG6XAjQL2a/frLRhyjpMZjyu55AeB1Kab2o/jQHGfyaMSajaAmtzR8NrIrBYLHxonL
	73at8Z7GhpsUWTub3wdFAO6VUW0iJj0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] drivers/base/memory: make memory block get/put explicit
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <3234B4D3-8202-4E79-B85B-8B6373BB76F6@linux.dev>
Date: Tue, 12 May 2026 11:11:15 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 linux-mm@kvack.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E9BB5FC5-0785-4162-8D1A-2A51C7250B34@linux.dev>
References: <2841f424-580c-48c6-bb26-de30e4397b7f@kernel.org>
 <3234B4D3-8202-4E79-B85B-8B6373BB76F6@linux.dev>
To: David Hildenbrand <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CB3914000E
X-Rspam-User: 
X-Stat-Signature: co43suwjdbm7y8brq5zpz9mdkc167tny
X-HE-Tag: 1778555540-942876
X-HE-Meta: U2FsdGVkX19+VQ4x5H6FmEx4vNP6m452Gn3MojR+2wFo1dxGSvtVe0utvps8eIhZnTerCGkwGc3CpEt2iRUGhVqfV1KjfHymk2jTQsKSFmmECzgjB6R2VjWxwhYTI1IkZjpeEhRBmNWmJ2Dx7veirBu0NwKFW7hb0aIqT73rQ+BPyrPlmu2Cbj8lk2O7//UtLWQeQaacKbcoM0vfdeOzWoFRmbJBaG4OG82Jb74nfLR9tgwfFdG5zQKdxkUIBOg7RX8YJcpllya3T+TluRfeZXpZH7hUvRPlr92Nub0LZDDgGUhws2anQUuoDl5zaiwwmHEQYDNCUQQXEJFx8UxG/oIR0031WoTpSGv9hUGbV47x8swrJ79k71VetNoCAqbbjz7GV0Kl2pzw+APg4fqQkHjzVKbhoCpff/XrgdXEhZpPwWJ17VUrenrKJ3uXK/A8ZRfsjBGgG0fzd5+LfoTXKm9W9Xs2/Ux2RTQb+lpTi8awMkT9p0hmu8hBzo0tA7sQLJTTVXCCs4nDlUdu/T5vnUHkg3W6o53cxZSXQ74JHAQjdCnrcsEtoKo9j5Ny4TWce0gbpuN/K1IaO2utbrlzKuV71yyQTEo6geUah398JDW3TSbHuqSfOLS4U4IZXxPvrPCRoKuc2IcCBOKlmtzdQy8J+XwBkgvQ7yFyiidnqj75MoLDJRLyZYV2N5ZOruufFy3m5IYB2YP7XhtNeS4JbJke7fW4rHweuw4SSqoCNfOZJXTKhMjxpJDY9CTosQ3B7m7tTsXBerYqnJHtYVCSAxTeOYujNPtyv/I5oa9ewikqKirNhW+8z/x3ZXZIOm26FzbbvgLX6viWKORbYzP/DaWUAhK7uuVspAQQjcIJFKF4OS/rU7Rk5MTyc5oVtHZQZSJFTHpGZyott2FVFMnbwAIHkBZuX//ZALmP93BssXMh41agiwpgepn1QwKKC3hlmItrCGF/LAVl5HoRfSj
 q9kxK88c
 r2gFYuE29N2pWZaN15k8LhrdJ9vIbDfduVckk1djH0kN0/1fC16FUkTNmCJrvME4DYsX2ejtJD57XWvXkAvAWYNlexpfNS0ltzcBNgB7PASPUDj3Et9xXemf+IkTOcpVWpeUG9jcY41OHjcZ35JmYcgOYB7rsyb0irhJdOaY5r2UBVadulVg7NbpoRgXsl6SlDCcVBMFaLEAgF4eL9H8kr6sSyvbui/ZTOE2W1cuE/nmGSNa2ICPE3rOh4jwvW3vNLVx9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 11, 2026, at 21:23, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On May 11, 2026, at 20:22, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>>=20
>> =EF=BB=BFOn 5/11/26 13:18, Muchun Song wrote:
>>> Rename the memory block lookup helper to make the acquired reference
>>> explicit, add memory_block_put() to wrap put_device(), and collapse =
the
>>> redundant section-number wrapper into a single block-id based lookup
>>> interface.
>>>=20
>>> This makes it clearer to callers that a successful lookup holds a
>>> reference that must be dropped, reducing the chance of forgetting =
the
>>> matching put and leaking the memory block device reference.
>>=20
>> Better mention some of the other changes here, like removing =
find_memory_block().
>=20
> Will do.
>=20
>>=20
>> [...]
>>=20
>>>   unlock_device_hotplug();
>>> diff --git a/include/linux/memory.h b/include/linux/memory.h
>>> index 5bb5599c6b2b..29edef1f975c 100644
>>> --- a/include/linux/memory.h
>>> +++ b/include/linux/memory.h
>>> @@ -158,7 +158,11 @@ int create_memory_block_devices(unsigned long =
start, unsigned long size,
>>> void remove_memory_block_devices(unsigned long start, unsigned long =
size);
>>> extern void memory_dev_init(void);
>>> extern int memory_notify(enum memory_block_state state, void *v);
>>> -extern struct memory_block *find_memory_block(unsigned long =
section_nr);
>>> +extern struct memory_block *memory_block_get(unsigned long =
block_id);
>>=20
>> While at it, please drop the "extern".
>=20
> OK.
>=20
>>=20
>>> +static inline void memory_block_put(struct memory_block *mem)
>>> +{
>>> +    put_device(&mem->dev);
>>> +}
>>> typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void =
*);
>>> extern int walk_memory_blocks(unsigned long start, unsigned long =
size,
>>>                 void *arg, walk_memory_blocks_func_t func);
>>> @@ -171,7 +175,6 @@ struct memory_group *memory_group_find_by_id(int =
mgid);
>>> typedef int (*walk_memory_groups_func_t)(struct memory_group *, void =
*);
>>> int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t =
func,
>>>                  struct memory_group *excluded, void *arg);
>>> -struct memory_block *find_memory_block_by_id(unsigned long =
block_id);
>>> #define hotplug_memory_notifier(fn, pri) ({        \
>>>   static __meminitdata struct notifier_block fn##_mem_nb =3D\
>>>       { .notifier_call =3D fn, .priority =3D pri };\
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 462d8dcd636d..890c6453e887 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -1417,14 +1417,13 @@ static void =
remove_memory_blocks_and_altmaps(u64 start, u64 size)
>>>       struct vmem_altmap *altmap =3D NULL;
>>>       struct memory_block *mem;
>>>=20
>>> -        mem =3D =
find_memory_block(pfn_to_section_nr(PFN_DOWN(cur_start)));
>>> +        mem =3D memory_block_get(phys_to_block_id(cur_start));
>>>       if (WARN_ON_ONCE(!mem))
>>>           continue;
>>>=20
>>>       altmap =3D mem->altmap;
>>>       mem->altmap =3D NULL;
>>> -        /* drop the ref. we got via find_memory_block() */
>>> -        put_device(&mem->dev);
>>> +        memory_block_put(mem);
>>=20
>> Would guards come in handy here?
>=20
> You mean to introduce something like:
>=20
> scoped_guard(memory_block, id) {
> }
>=20
> Right? If yes, I will give it a try.

Hi David,

Did I get that right?

5 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5b5d41089e81..eba48320fc30 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -997,7 +997,6 @@ int walk_memory_blocks(unsigned long start, unsigned =
long size,
 {
 	const unsigned long start_block_id =3D phys_to_block_id(start);
 	const unsigned long end_block_id =3D phys_to_block_id(start + =
size - 1);
-	struct memory_block *mem;
 	unsigned long block_id;
 	int ret =3D 0;

@@ -1005,12 +1004,11 @@ int walk_memory_blocks(unsigned long start, =
unsigned long size,
 		return 0;

 	for (block_id =3D start_block_id; block_id <=3D end_block_id; =
block_id++) {
-		mem =3D memory_block_get(block_id);
+		CLASS(memory_block_get, mem)(block_id);
 		if (!mem)
 			continue;

 		ret =3D func(mem, arg);
-		memory_block_put(mem);
 		if (ret)
 			break;
 	}
@@ -1218,23 +1216,19 @@ int walk_dynamic_memory_groups(int nid, =
walk_memory_groups_func_t func,
 void memblk_nr_poison_inc(unsigned long pfn)
 {
 	const unsigned long block_id =3D pfn_to_block_id(pfn);
-	struct memory_block *mem =3D memory_block_get(block_id);
+	CLASS(memory_block_get, mem)(block_id);

-	if (mem) {
+	if (mem)
 		atomic_long_inc(&mem->nr_hwpoison);
-		memory_block_put(mem);
-	}
 }

 void memblk_nr_poison_sub(unsigned long pfn, long i)
 {
 	const unsigned long block_id =3D pfn_to_block_id(pfn);
-	struct memory_block *mem =3D memory_block_get(block_id);
+	CLASS(memory_block_get, mem)(block_id);

-	if (mem) {
+	if (mem)
 		atomic_long_sub(i, &mem->nr_hwpoison);
-		memory_block_put(mem);
-	}
 }

 static unsigned long memblk_nr_poison(struct memory_block *mem)
diff --git a/drivers/base/node.c b/drivers/base/node.c
index b3333ca92090..32a5431cbb60 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -845,15 +845,12 @@ static void =
register_memory_blocks_under_nodes(void)
 			continue;

 		for (block_id =3D start_block_id; block_id <=3D =
end_block_id; block_id++) {
-			struct memory_block *mem;
-
-			mem =3D memory_block_get(block_id);
+			CLASS(memory_block_get, mem)(block_id);
 			if (!mem)
 				continue;

 			memory_block_add_nid_early(mem, nid);
 			do_register_memory_block_under_node(nid, mem);
-			memory_block_put(mem);
 		}

 	}
diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
index 6df1926d4c62..c9a1a7adcab6 100644
--- a/drivers/s390/char/sclp_mem.c
+++ b/drivers/s390/char/sclp_mem.c
@@ -237,13 +237,12 @@ static ssize_t sclp_config_mem_store(struct =
kobject *kobj, struct kobj_attribute
 	} else {
 		if (!sclp_mem->config)
 			goto out_unlock;
-		mem =3D memory_block_get(phys_to_block_id(addr));
-		if (mem->state !=3D MEM_OFFLINE) {
-			memory_block_put(mem);
-			rc =3D -EBUSY;
-			goto out_unlock;
+		scoped_class(memory_block_get, mem, =
phys_to_block_id(addr)) {
+			if (mem->state !=3D MEM_OFFLINE) {
+				rc =3D -EBUSY;
+				goto out_unlock;
+			}
 		}
-		memory_block_put(mem);
 		sclp_mem_change_state(addr, block_size, 0);
 		__remove_memory(addr, block_size);
 #ifdef CONFIG_KASAN
@@ -293,12 +292,12 @@ static ssize_t sclp_memmap_on_memory_store(struct =
kobject *kobj, struct kobj_att
 		return rc;
 	block_size =3D memory_block_size_bytes();
 	sclp_mem =3D container_of(kobj, struct sclp_mem, kobj);
-	mem =3D memory_block_get(phys_to_block_id(sclp_mem->id * =
block_size));
-	if (!mem) {
-		WRITE_ONCE(sclp_mem->memmap_on_memory, value);
-	} else {
-		memory_block_put(mem);
-		rc =3D -EBUSY;
+	scoped_class(memory_block_get, mem,
+		     phys_to_block_id(sclp_mem->id * block_size)) {
+		if (!mem)
+			WRITE_ONCE(sclp_mem->memmap_on_memory, value);
+		else
+			rc =3D -EBUSY;
 	}
 	unlock_device_hotplug();
 	return rc ? rc : count;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 463dc02f6cff..fb67041941a8 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -18,6 +18,7 @@

 #include <linux/node.h>
 #include <linux/compiler.h>
+#include <linux/cleanup.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>

@@ -163,6 +164,8 @@ static inline void memory_block_put(struct =
memory_block *mem)
 {
 	put_device(&mem->dev);
 }
+DEFINE_CLASS(memory_block_get, struct memory_block *, if (_T) =
memory_block_put(_T),
+	     memory_block_get(block_id), unsigned long block_id)
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void =
*);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t =
func);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 890c6453e887..3f89ffb286d6 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1415,15 +1415,13 @@ static void remove_memory_blocks_and_altmaps(u64 =
start, u64 size)
 	for (cur_start =3D start; cur_start < start + size;
 	     cur_start +=3D memblock_size) {
 		struct vmem_altmap *altmap =3D NULL;
-		struct memory_block *mem;
-
-		mem =3D memory_block_get(phys_to_block_id(cur_start));
-		if (WARN_ON_ONCE(!mem))
-			continue;
+		scoped_class(memory_block_get, mem, =
phys_to_block_id(cur_start)) {
+			if (WARN_ON_ONCE(!mem))
+				continue;

-		altmap =3D mem->altmap;
-		mem->altmap =3D NULL;
-		memory_block_put(mem);
+			altmap =3D mem->altmap;
+			mem->altmap =3D NULL;
+		}

 		remove_memory_block_devices(cur_start, memblock_size);

Thanks,
Muchun

>=20
>>=20
>> In general
>>=20
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>=20
> Thanks.
>=20
> Muchun
>=20
>>=20
>> --
>> Cheers,
>>=20
>> David


