Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53C1F589AD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D00D6B0095; Thu, 23 Apr 2026 08:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7666B0096; Thu, 23 Apr 2026 08:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4476B0098; Thu, 23 Apr 2026 08:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E67A6B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:25:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CE65140151
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:29 +0000 (UTC)
X-FDA: 84689741178.04.D0F093E
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf01.hostedemail.com (Postfix) with ESMTP id C4DCB40016
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E64lGpsK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947128; a=rsa-sha256;
	cv=none;
	b=HsDGE4U0Wdj9BcXSCEM4qFWG14MB4ICCbBO/kDfs97oRyF944Xmj5Wzpgxc1oGVijiRJRL
	u06GlyYdPPI7By7wrpDovqkhC+xpLUMRZ0cM5vF9mso6TeZGrb82mIbtW30gNkB2V3L1eN
	T/kOH36p4r8u2pPaNOSPTPlLv6RpI5E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E64lGpsK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4LgpLetqEJMUYqZ9nmv9qSQLNKswZwmhvnZvNQKMWs=;
	b=Mm6+VekiEz6AFX+igaCvh5P8Jn4FidWLQRWBmJxeCoz6oGchHtz6Png1OZRYCRIb4oUERl
	8aRlKAnZaBKc+EkWw11tb5rgk4ztsUFPnh4XATkAuBjqNsyCOLOKtJCYWleuvLXy8/m/Vx
	TA216yhe1oD6vv7XmYkwpg0xw9NaRPM=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776947125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4LgpLetqEJMUYqZ9nmv9qSQLNKswZwmhvnZvNQKMWs=;
	b=E64lGpsKIAp0+7yqcT34z/MtVPASA0p+X46tbKSZ5VzzVuD4yhmTK/MLRJyOoG5xPYXO3/
	bu0/dIkxxRSxYj7Wq3EhzzP/r7oe+ItOHS3YgcKc6tBrnkucgv13Ys2XocFFJkuL64Ybzo
	6mbLW5WEfZNLIHF24XAxEOc/41LbejE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v5 v5 2/6] mm/memory_hotplug: Fix incorrect altmap passing
 in error path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <e0ed4524-36d5-41ff-8ded-ba036d6ff6e4@kernel.org>
Date: Thu, 23 Apr 2026 20:18:15 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A542CA17-C6BB-4D1C-BBAB-154FA5E35B36@linux.dev>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
 <20260423071911.1962859-3-songmuchun@bytedance.com>
 <e0ed4524-36d5-41ff-8ded-ba036d6ff6e4@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: hindz3i645jn8crh4rsshrpfsdf348z6
X-Rspam-User: 
X-Rspamd-Queue-Id: C4DCB40016
X-HE-Tag: 1776947127-683351
X-HE-Meta: U2FsdGVkX18eCODnc/3yvsWuFVhLLLyq98nT8TpdU/4E/ow+ltoUbDI6Z4fY/e2MqBZG3eidGcmrUavbU21fO59b748A6UP2ppLf5X/2GjvhUDxSjHKjy6AS0LZDCRva94h//n/1cTNzu3fLB0ZlzrRf9FSgVuy1yAQA4PJtgtXTmqIbltdRQWOmLOvt4aRNOK+2W8G3S+bVxWF7gJf0XYqWhq90zTC1vTJ9AcMGowFblDWY8ODR9lOZuPTyqR0MxAsSb3ptrIuS0Pw92LQ4dtWtyjbT75xmBmEh05Rja1Ih7vGP4o1G1b+aOwQ/bebzT6kb56i6Lcp6b3N0BP9fwebU53esuetwrStxXTGNtUYWZyoGDQSD4g+DiikCi4g80RJwY6HTk8P80qUVpjPzTW55cj6Un3P/UA3tSJMWZlQ0DCKs0TwG5kItNZFQ+KqiV5RphSWgKFQF4cFoUBNiH2Z5AGdiJ5l/Cjbm29GiJDddrbRExdMXytgtmbbLWTXowbUjLDQC46ClQaM0ku8AuEnrf/bTIE5PKiPleCltKplf1Q37r6XHv9MARcwJTH+ITR9Eqqleajn4q2VJZcVp5yT9ZBCYCNNXLXjrTrgKn9WOHL9FQgs7HTWhf8rDaVR3bQaVa07k64o2koXVTsp7/KDIlWeh5KVUBTUIFF0CedC7Hilzgwbk+xI+2U4+zOl60kW48gcvLryVvlgDEjc0jWPbRq+yJZ+8iJO6IEyw5yXoUIFJ/RUC01BC+zJ2GyN60FhKr08vcNnHpEKBSZsiubAXkyfJ3keIpN20pjtA83gn0cfmSUzPQ+tlAD9W/6cqQxBkIGpOFQzhEpSgnZPKTJ6sVpo7AJio+GoHWNnxC7G+v1OlQxZqBwqjWyTatVEIRjeY3LR8r/i+XEC0hvGtr6zk5sQIS0ykfXg7lFIhEbFKhUZzyxPlh3E8E4V/shKC0gBWxVidMObPD6ergSp
 2dP+snYe
 QltB1yhmmZ0KKctrSvnyE3v8rXP4IJkbPturpvwjH/K4ilVsOUblzHXAvhzf0uHQxuY1d2VMzuJQwUym4kUDw00ZkN7ZwvDxfMnhry8IB5E32+qw8yxlUnNTxZDEmD1N/lOxTueZgyJBoenxUl5wikBs237Xh8ph8XQEwtBoOcVcDwgvb0OhT+TlIhmvUd+LepBn180DhjvsZjtNDUmw0HFuV/Ha6T2gmcR4gqbHZvTd0stuwJvcoLrCNqcCDH+OQ2CwmFzc2ldySPyqRV8368qWcSKGSDsL6mpAmH4Y6xPlmaEyV4JS/U65Z9SwMU+4PlhFxJX7bLGaL8mA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 23, 2026, at 18:38, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/23/26 09:19, Muchun Song wrote:
>> In create_altmaps_and_memory_blocks(), when arch_add_memory() =
succeeds
>> with memmap_on_memory enabled, the vmemmap pages are allocated from
>> params.altmap. If create_memory_block_devices() subsequently fails, =
the
>> error path calls arch_remove_memory() with a NULL altmap instead of
>> params.altmap.
>>=20
>> This is a bug that could lead to memory corruption. Since altmap is
>> NULL, vmemmap_free() falls back to freeing the vmemmap pages into the
>> system buddy allocator via free_pages() instead of the altmap.
>> arch_remove_memory() then immediately destroys the physical linear
>> mapping for this memory. This injects unowned pages into the buddy
>> allocator, causing machine checks or memory corruption if the system
>> later attempts to allocate and use those freed pages.
>>=20
>> Fix this by passing params.altmap to arch_remove_memory() in the =
error
>> path.
>>=20
>> Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory =
requests across memblocks")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/memory_hotplug.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 2a943ec57c85..0bad2aed2bde 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1468,7 +1468,7 @@ static int create_altmaps_and_memory_blocks(int =
nid, struct memory_group *group,
>> 	ret =3D create_memory_block_devices(cur_start, memblock_size, =
nid,
>>  					params.altmap, group);
>> 	if (ret) {
>> - 		arch_remove_memory(cur_start, memblock_size, NULL);
>> + 		arch_remove_memory(cur_start, memblock_size, =
params.altmap);
>> 		kfree(params.altmap);
>> 		goto out;
>> 	}
>=20
> Yeah, that's nasty. We should CC stable.

Make sense.

>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>=20
>=20
>=20
> Should we extend the safety checks we already have on the other path?

Better to have.

>=20
>=20
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 2a943ec57c85..1c304468af08 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1402,6 +1402,12 @@ bool mhp_supports_memmap_on_memory(void)
> }
> EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>=20
> +static void altmap_free(struct vmemmap_altmap *altmap)
> +{
> +       WARN(altmap->alloc, "Altmap not fully unmapped");

Should we change it to WARN_ONCE?

> +       kfree(altmap);
> +}
> +
> static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
> {
>        unsigned long memblock_size =3D memory_block_size_bytes();
> @@ -1426,10 +1432,7 @@ static void =
remove_memory_blocks_and_altmaps(u64 start, u64 size)
>                remove_memory_block_devices(cur_start, memblock_size);
>=20
>                arch_remove_memory(cur_start, memblock_size, altmap);
> -
> -               /* Verify that all vmemmap pages have actually been =
freed. */
> -               WARN(altmap->alloc, "Altmap not fully unmapped");
> -               kfree(altmap);
> +               altmap_free(altmap);
>        }
> }
>=20
> @@ -1460,7 +1463,7 @@ static int create_altmaps_and_memory_blocks(int =
nid, struct memory_group *group,
>                /* call arch's memory hotadd */
>                ret =3D arch_add_memory(nid, cur_start, memblock_size, =
&params);
>                if (ret < 0) {
> -                       kfree(params.altmap);
> +                       altmap_free(params.altmap);
>                        goto out;
>                }
>=20
> @@ -1469,13 +1472,12 @@ static int =
create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>                                                  params.altmap, =
group);
>                if (ret) {
>                        arch_remove_memory(cur_start, memblock_size, =
NULL);
> -                       kfree(params.altmap);
> +                       altmap_free(params.altmap);
>                        goto out;
>                }
>        }
>=20
>        return 0;
> -out:
>        if (ret && cur_start !=3D start)
>                remove_memory_blocks_and_altmaps(start, cur_start - =
start);
>        return ret;
>=20
>=20
> Maybe the helper should even go into altmap code? Not sure.

I think the current changes look great as they are. While I believe this =
is valuable
as a standalone cleanup, what do you think?

Thanks,
Muchun.

>=20
>=20
> --=20
> Cheers,
>=20
> David


