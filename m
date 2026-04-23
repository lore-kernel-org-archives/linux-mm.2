Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BE7F589A4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8186B008A; Thu, 23 Apr 2026 08:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882206B0096; Thu, 23 Apr 2026 08:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770A46B0098; Thu, 23 Apr 2026 08:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 633B96B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:34:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31DFA1C0078
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:34:18 +0000 (UTC)
X-FDA: 84689763396.23.6FDD804
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C3A740011
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:34:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l9X21ct7;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947656; a=rsa-sha256;
	cv=none;
	b=gcYBQDCjQP/fw/FzGfAaZV2N0vGh4YahvWyZfBSBm5rOwDKfHVYYGmJji2D712PVkIgE4D
	lxlrKid3Ma6AUMRj4P1KJ7SNMBcygGEX60IDFgyTqyuj/67+gC+fGRTog4q/a+XVCgILM1
	vGwCz3UO8FxlGoVdihRR8OhQSRwPphg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l9X21ct7;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lw49zwURroj4cNnSa8wLXSWhI5yryxe8VvIKls8yX7s=;
	b=4KurnvjWyEQaVth2NCrYLycrO7FLpPJHnCAPfYZufpZPBBvT+XJcaYGWMzG/IfqoboHe3I
	bnP4QwV+rbHxxPaQMSrX/AZEdfTgYvi3qk0y22d4nuGyVDju4ZHQM/HCPXHuLOSD6G5a9M
	2mywedfQc5ZTSkD68OH0Bbv3xnM81nI=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776947654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lw49zwURroj4cNnSa8wLXSWhI5yryxe8VvIKls8yX7s=;
	b=l9X21ct7waizi915h79BbuDuGau1Z93SKDUm3rxRMbrJGUAaqEMlOwYvImdQpDAywOkq1b
	7DS686VPF0wKsgRwF0xtHtANLNQFUVR9ubGe9ZJSbHxez84vmZtSE+OmDO2IWJNQqbhnYY
	DFRh+2d9ph8oyKsM7CW1J63XOari2lw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v5 v5 2/6] mm/memory_hotplug: Fix incorrect altmap passing
 in error path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <25aac60c-8510-4d92-85f3-368cfe9d83ef@kernel.org>
Date: Thu, 23 Apr 2026 20:31:04 +0800
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
Message-Id: <139193CD-6D52-4114-82D1-3093B3F3C9E1@linux.dev>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
 <20260423071911.1962859-3-songmuchun@bytedance.com>
 <e0ed4524-36d5-41ff-8ded-ba036d6ff6e4@kernel.org>
 <A542CA17-C6BB-4D1C-BBAB-154FA5E35B36@linux.dev>
 <25aac60c-8510-4d92-85f3-368cfe9d83ef@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5C3A740011
X-Stat-Signature: z6zkw8aqe58t6qaidqorwjb6fe7y6ugs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776947656-321147
X-HE-Meta: U2FsdGVkX19MgcMEYWro+ehhBJ2n05ZqLowvzRpfdgN2PbtoM0NTmwJEj5iAKeEfekgJuTvtBSHUXHiEwzFS+GYotfBAZjbGKw8w+hX59YkFe5b3AbHL2c6VRQjh4VJ6Hw72AtBtGqKOWbZfK3g2Z3g5+rhmsWeCti8tefNt7JbWHqj0IhtJKoWsn5yKkTMIP5KCow6K4MiPRXQ+qGzz8YxuseNTdbh4NudCusqUxvUJhqq9gcSxmC86sr4JTmEMOwAUiAB35j5TiUIH69bw4B4SUf1Y2Pb2bsnZN/th1a8ERMePJl68KNqrKkFJQB+0uj+IF60Uwrn753PFIkHsTDH3BMNQerikbDZHmivsToT+JNuaYrG0ZsPR9BmuiBgPPb/doCld2/SbRfWEpWgIWxJ0ThQpOholAkZ+Wy3ePsiQXpYzKY+Xb49AIcAfftPSQwNgFzEbuepEYIyx9TTf5vGHuG0gtrjKtNY7s2VPoK4hr/C4BvdxCvRsH17bo6f2+6bkmaDxm0qrLhgksboGWNYTpaz7AuJIXQNzZy2GrUd8w3ZSE4P+kMRYX80+p/044wHjVZuJwie23gZFX2nkAhQC0jZeqeVQeNDKPrS01dHoj0cRwIouA60WgLxxzb1SSLOim7Ede/jrXatQEQJpIH5UFjBYN9yQn4Np6WcVJd7dsrCPv4K2Uv03FhTl0GNPJ1r+c59bXtP/zhCA/3EpndvIh26GCfkIrKX+sTm7VQ+qZm1GhAVaQO2VxcYOzWGZrVVLy45ZG6majZ45DUeci/CTYZru+IFwAPb0VNgZVIbYArQoi5iouoHh+CwL130UmR9WYOBubCjvvLlzeaDaQG367NPRiD6bVcEXR3Sbof9OnJ/nuknShBYmfUAH7MHP8Qr+yd46kn7hcu4aVayKbQjxFsxfAg8+N7eHmM7Zids/dFoqvfxSps/JQo6NgAaEcfyT4f0QWFYdSEGkZUu
 GteHtKCA
 Q+MJ4YXc2GqyofCLY2OHVwgJ0XnvtfyYQ6CADwnkmgBrw7mbUeea4dgOt34SVTcBcuxIns3kI7tHY/d/M3DBcCb8kAZX1ZlemttWG2GmV7JHNMc7TxeM8pdvVRII8X4xm8gED6zmTtd2xysoiq1jRa/1eNuvFnrSBjJMGJqw+Tqb0bUMHp2596czjywDmTfRVk1ya0zYntbJ8xAz+4hABdb52kfIaZxODsZWrZjOBfkAEMnfo1S6H1HGVjj8BJhCCynlYcIxp3TJ/T59o5FXReQbvhJqotc9GOflIaQe3m4K/YuMaSeSZnBZd27wg1THCWCQUsSRGB/ejM6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 23, 2026, at 20:28, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/23/26 14:18, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 23, 2026, at 18:38, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>>>=20
>>> On 4/23/26 09:19, Muchun Song wrote:
>>>> In create_altmaps_and_memory_blocks(), when arch_add_memory() =
succeeds
>>>> with memmap_on_memory enabled, the vmemmap pages are allocated from
>>>> params.altmap. If create_memory_block_devices() subsequently fails, =
the
>>>> error path calls arch_remove_memory() with a NULL altmap instead of
>>>> params.altmap.
>>>>=20
>>>> This is a bug that could lead to memory corruption. Since altmap is
>>>> NULL, vmemmap_free() falls back to freeing the vmemmap pages into =
the
>>>> system buddy allocator via free_pages() instead of the altmap.
>>>> arch_remove_memory() then immediately destroys the physical linear
>>>> mapping for this memory. This injects unowned pages into the buddy
>>>> allocator, causing machine checks or memory corruption if the =
system
>>>> later attempts to allocate and use those freed pages.
>>>>=20
>>>> Fix this by passing params.altmap to arch_remove_memory() in the =
error
>>>> path.
>>>>=20
>>>> Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory =
requests across memblocks")
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> ---
>>>> mm/memory_hotplug.c | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>> index 2a943ec57c85..0bad2aed2bde 100644
>>>> --- a/mm/memory_hotplug.c
>>>> +++ b/mm/memory_hotplug.c
>>>> @@ -1468,7 +1468,7 @@ static int =
create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>>>> ret =3D create_memory_block_devices(cur_start, memblock_size, nid,
>>>> params.altmap, group);
>>>> if (ret) {
>>>> -  arch_remove_memory(cur_start, memblock_size, NULL);
>>>> +  arch_remove_memory(cur_start, memblock_size, params.altmap);
>>>> kfree(params.altmap);
>>>> goto out;
>>>> }
>>>=20
>>> Yeah, that's nasty. We should CC stable.
>>=20
>> Make sense.
>>=20
>>>=20
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>=20
>> Thanks.
>>=20
>>>=20
>>>=20
>>>=20
>>> Should we extend the safety checks we already have on the other =
path?
>>=20
>> Better to have.
>>=20
>>>=20
>>>=20
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 2a943ec57c85..1c304468af08 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -1402,6 +1402,12 @@ bool mhp_supports_memmap_on_memory(void)
>>> }
>>> EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>>>=20
>>> +static void altmap_free(struct vmemmap_altmap *altmap)
>>> +{
>>> +       WARN(altmap->alloc, "Altmap not fully unmapped");
>>=20
>> Should we change it to WARN_ONCE?
>=20
> Was debating with myself, and yes, I think so.
>=20
>>=20
>>> +       kfree(altmap);
>>> +}
>>> +
>>> static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
>>> {
>>>       unsigned long memblock_size =3D memory_block_size_bytes();
>>> @@ -1426,10 +1432,7 @@ static void =
remove_memory_blocks_and_altmaps(u64 start, u64 size)
>>>               remove_memory_block_devices(cur_start, memblock_size);
>>>=20
>>>               arch_remove_memory(cur_start, memblock_size, altmap);
>>> -
>>> -               /* Verify that all vmemmap pages have actually been =
freed. */
>>> -               WARN(altmap->alloc, "Altmap not fully unmapped");
>>> -               kfree(altmap);
>>> +               altmap_free(altmap);
>>>       }
>>> }
>>>=20
>>> @@ -1460,7 +1463,7 @@ static int =
create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>>>               /* call arch's memory hotadd */
>>>               ret =3D arch_add_memory(nid, cur_start, memblock_size, =
&params);
>>>               if (ret < 0) {
>>> -                       kfree(params.altmap);
>>> +                       altmap_free(params.altmap);
>>>                       goto out;
>>>               }
>>>=20
>>> @@ -1469,13 +1472,12 @@ static int =
create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>>>                                                 params.altmap, =
group);
>>>               if (ret) {
>>>                       arch_remove_memory(cur_start, memblock_size, =
NULL);
>>> -                       kfree(params.altmap);
>>> +                       altmap_free(params.altmap);
>>>                       goto out;
>>>               }
>>>       }
>>>=20
>>>       return 0;
>>> -out:
>>>       if (ret && cur_start !=3D start)
>>>               remove_memory_blocks_and_altmaps(start, cur_start - =
start);
>>>       return ret;
>>>=20
>>>=20
>>> Maybe the helper should even go into altmap code? Not sure.
>>=20
>> I think the current changes look great as they are. While I believe =
this is valuable
>> as a standalone cleanup, what do you think?
> Makes sense. Could you do me the favor and follow up with that, on top =
of the fixes?

No problem.

>=20
> --=20
> Cheers,
>=20
> David



