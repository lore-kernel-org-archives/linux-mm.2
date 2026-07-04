Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF02C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 04:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D5C6B00B5; Sat,  4 Jul 2026 00:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DD86B00B6; Sat,  4 Jul 2026 00:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FC66B00B7; Sat,  4 Jul 2026 00:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 287226B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:07:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AF19C2018
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 04:07:02 +0000 (UTC)
X-FDA: 84949758684.23.213589F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7CA5D40006
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 04:07:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vFxjSyhd;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783138021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO176FQV9ceY4FDmJoLUkoKYNJ33TI8Fa25LDwf4kHU=;
	b=C7RZB1Zzjr8I7wpWkkLhs8sMDPjm4SfoIrrDI6Od09hvHyIgeN0NIGuxu1Jqd+DnqA37TV
	gYc5Biy7LqTcDMotgao5+x8iA/+IEaHH5Wf1kADLlBSLZxQPG1Pg44LoyEx7fbP+sJlWRj
	8fjeIeRbYRaDRMSPYHTvZeOSMGZ0gIw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vFxjSyhd;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783138021;
	b=Tva2x5F25FL/ba6hcaZJQ+uKc365gAez2XiXinIBme6FVgW+CitRWbspBVrpWxbKRToLWI
	1OT1A8ZFX8CSlTcgttqEFhe5gF3ZqFts6vdmN+69XO03e++quU1uzYgc/c/ZrSazbKBN89
	Y3Fh8FhJzW3KSZruw0GJh8IfmpTo1wQ=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783138018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vO176FQV9ceY4FDmJoLUkoKYNJ33TI8Fa25LDwf4kHU=;
	b=vFxjSyhdIMNtyRLvcDEPPiG52orQi6gItBGyYbXVdZFm3Yhd6+bs95F3ieu768mVarYn9G
	pO4yW+N5PtvCG062sGJwYg+TM9fpzzgg/3jxEYaxAAefSIfMzuZyKmnR+qUEGhPq7B9VaH
	9Y7oNzPly4ykJ5kxKuUkc6RDUqSZKAs=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: Fix null pointer dereference of nodemask in
 hugetlb_cma_alloc_frozen_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CANruzcSaFozBpy3SVFz_uoNKYV=hJyhAxuO6F6fEPtbrrvnojw@mail.gmail.com>
Date: Sat, 4 Jul 2026 12:06:01 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 osalvador@suse.de,
 david@kernel.org,
 surenb@google.com,
 fvdl@google.com,
 gthelen@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9B0D2555-ED82-4D65-8A83-7F960EFCE601@linux.dev>
References: <20260702215713.627941-1-souravpanda@google.com>
 <20260702162415.142571f4d8c43aa4b95b9f7c@linux-foundation.org>
 <CANruzcR+uQPisER8KDFH3x4C-O22xvUwQEgv2=TQ=MHooO11Gw@mail.gmail.com>
 <CA20002F-CF0B-4E27-B5F8-EE1D17EDE6F4@linux.dev>
 <CANruzcSaFozBpy3SVFz_uoNKYV=hJyhAxuO6F6fEPtbrrvnojw@mail.gmail.com>
To: Sourav Panda <souravpanda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6jbpyih4n9orwn4ew3e44siy4doipi3g
X-Rspamd-Queue-Id: 7CA5D40006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783138020-616840
X-HE-Meta: U2FsdGVkX18dwqBtuZovA55wjiEnQme8zoCMhh76jbBRFeZkdFNkQYOjPmcerD1QLdzzcWr7d2gLi7DCgRLPos2b6n00sSuRUn419oJOSiMD98giWW9MrFwQMYsJpKnLMwtScvnZcY1sk4zlzNRYctbSEZ4+x0nXarUJqFPOeUR0MlyEcj4+fbLNH1xSLR7W/cJtnbRKAbA/aWg0fZy0HVv1tip5R85r1VHP5yhVtOZKalKLcwpghil77Ts8ia3s3RFYWgODIQst9XQkQ8Q0ZYN9PdLolWVA5SmNKE/5jl7kdmCwu9E+lI2CitXHnaDWzXH48u+iDv+LYc+gsFeKYVszrgb0BP6k35izPsi2ddm8/+HcrqoZSeGf5WJll/3roVCsW6tDTX+BbGcxzGbtg3o9sxwaTa1Ht/StNElWITgi6aK/6vw2c2tk1ZacYXNcfQbJrDyTnP8kY+swgHVeHr0KpUi6YIr9+RQQ6ImSCWkqijEiat+iPozJ1jhECmfcPUp7fcyZ2wEaqtl4AORTUUpooF3enJ2hIv/zVGwfvimDibxz7LHwCHxlPU1/c27VwKIzlR6Z3dZLXZiwIe9vNM/FmRktTPVS2uAMOWxriEepxYe3DXkzVkwS4Vn2ZbTgt32l3NhiH7OH1X5Yk4uH71f3WRXUFzp4RwMd2o7paAK82Ta85f+vuUYq0L3LjpbSHGygKuBBhckCgQq0CmjyU468RwzlxnG/DcEjNLYIwp9K/sZ8eoCLWX302qfCC2SJhvLn1hx+nuW9cjZbaW6NpkP4rgwR7TsosIJidcxQyij2Te5etyA6oBpkU8dMV74EVTzgsI3M+7Oax7VdxWGZb9p8EeLY62lJD7a6ep32mhcBBvohs9ZVEvUFA53/U8poW6Tbm7ohfm57I3yr6yo4PosBIImXRjaMV3jC4U2n3H46pB8JbpIawdxZGMQJNI+QLeskohON3CrfiPU3UEb
 vEZ/WCwe
 WMASDMdeeAXaSShsWzR68XoHMTpTFcHQLURCBlmNzjGRuUnaGf4t1EY5vcENrMX1bdVhdTf7m+JYu19dqy+dQtLzakWjw+zDN9oYcWdDihoWy3eJabpDZSbAQGrNsxTHhW1BM7byWAaumEXo171t8xwfvyvTrtjGtRVj2GxWpFXUafk1WHwHaIDtYJoI/J3aZpjWKW27a+lExNNBqiaNOiu1wfhO7A88ow/jRc1XCLI5Bv2R5gFMI9LVeoCbGfC94eGDWG9XYRZrSCAo0bbXY33YjuGhG1QbdxGcNcEj3FnF6XDPR4PSUdUfwTKAdYGJrqSD8cZ3HWKOwikKi3yMrxYWrBP0cKpd8B1qzUd7VNelrZxFOgZ+nWZzl+A2z7uxXff5fDbC/Xp5oUlqon0zaOvfkx6B2njxFnrUriLs95aEwgQRGv9ldGaOBVAFdycOkOwLf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 4, 2026, at 11:53, Sourav Panda <souravpanda@google.com> wrote:
>=20
> On Fri, Jul 3, 2026 at 8:05=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>=20
>>=20
>>> On Jul 4, 2026, at 04:04, Sourav Panda <souravpanda@google.com> =
wrote:
>>>=20
>>> On Thu, Jul 2, 2026 at 4:24=E2=80=AFPM Andrew Morton =
<akpm@linux-foundation.org> wrote:
>>>>=20
>>>> On Thu,  2 Jul 2026 21:57:13 +0000 Sourav Panda =
<souravpanda@google.com> wrote:
>>>>=20
>>>>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
>>>>> hugetlb_cma_alloc_frozen_folio() as a fallback to allocate from =
all
>>>>> nodes. In this case, hugetlb_cma_alloc_frozen_folio() blindly
>>>>> dereferences it in for_each_node_mask(), leading to a null pointer
>>>>> dereference.
>>>>>=20
>>>>=20
>>>> oh.
>>>>=20
>>>>> Fix this by checking if nodemask is NULL and defaulting to
>>>>> node_states[N_MEMORY] if it is.
>>>>>=20
>>>>> --- a/mm/hugetlb_cma.c
>>>>> +++ b/mm/hugetlb_cma.c
>>>>> @@ -34,6 +34,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
>>>>>     if (!hugetlb_cma_size)
>>>>>             return NULL;
>>>>>=20
>>>>> +     if (!nodemask)
>>>>> +             nodemask =3D &node_states[N_MEMORY];
>>>>> +
>>>>>     if (hugetlb_cma[nid])
>>>>>             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], =
order);
>>>>=20
>>>> It is possible to hit this with any known testcase?
>>>>=20
>>>> If not, why not.  I smell the smell of dead code somewhere?
>>>>=20
>>>=20
>>> Currently, there are no selftests in the tree that trigger this
>>> specific  MPOL_PREFERRED_MANY  fallback path, which is why it has =
gone
>>> unnoticed.
>>>=20
>>> The bug only triggers under a specific topology: Multiple NUMA nodes
>>> where gigantic hugepages are backed by CMA, but only on a subset of
>>> the nodes.
>>>=20
>>> 1. The Reproducer:
>>>   #include <stdio.h>
>>>   #include <stdlib.h>
>>>   #include <numaif.h>
>>>   #include <numa.h>
>>>   #include <sys/mman.h>
>>>   #include <unistd.h>
>>>   #include <string.h>
>>>=20
>>>   #define GIGANTIC_PAGE_SIZE (1UL << 30) // 1GB
>>>=20
>>>   int main(void) {
>>>       void *ptr;
>>>       unsigned long nodemask =3D 1; // Preferred Node 0
>>>       int ret;
>>>=20
>>>       /* Allocate 1GB gigantic hugepage area without reserving */
>>>       ptr =3D mmap(NULL, GIGANTIC_PAGE_SIZE, PROT_READ | PROT_WRITE,
>>>                  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
>>> MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>>>=20
>>>       if (ptr =3D=3D MAP_FAILED) {
>>>           perror("mmap failed");
>>>           return 1;
>>>       }
>>>=20
>>>       /* Set MPOL_PREFERRED_MANY policy (mode 5) restricted to node =
0 */
>>>       ret =3D mbind(ptr, GIGANTIC_PAGE_SIZE, 5 /* =
MPOL_PREFERRED_MANY */,
>>>                   &nodemask, sizeof(nodemask) * 8, 0);
>>>=20
>>>       if (ret < 0) {
>>>           perror("mbind");
>>>           return 1;
>>>       }
>>>=20
>>>       /* Trigger page fault */
>>>       memset(ptr, 0, GIGANTIC_PAGE_SIZE);
>>>=20
>>>       printf("PASS\n");
>>>       return 0;
>>>   }
>>>=20
>>> 2. Triggering the panic in QEMU:
>>>  CONFIG_CMA=3Dy
>>>  CONFIG_HUGETLB_CMA=3Dy
>>>=20
>>> Then, boot a VM with two NUMA nodes, restricting CMA to Node 1, and
>>> run the reproducer (+pdpe1gb  is required).
>>>=20
>>>   vng -v \
>>>       --cpus 2 \
>>>       --memory 8G \
>>>       --user=3Droot \
>>>       --qemu-opts=3D" \
>>>           -cpu max,+pdpe1gb \
>>>           -object memory-backend-ram,id=3Dmem0,size=3D4G \
>>>           -numa node,nodeid=3D0,memdev=3Dmem0 \
>>>           -object memory-backend-ram,id=3Dmem1,size=3D4G \
>>>           -numa node,nodeid=3D1,memdev=3Dmem1" \
>>>       --append "hugetlb_cma=3D1:1G hugetlb_cma_only=3D1
>>> default_hugepagesz=3D1G hugepagesz=3D1G hugepages=3D0"
>>>=20
>>> Inside the VM:
>>>   gcc reproducer.c -lnuma -o reproducer
>>>   echo 1 > /proc/sys/vm/nr_overcommit_hugepages
>>>   ./reproducer
>>>=20
>>> 3. Outcome:
>>>=20
>>>   [   33.586151] BUG: kernel NULL pointer dereference, address:
>>> 0000000000000000
>>>   [   33.586512] #PF: supervisor read access in kernel mode
>>>   [   33.586680] #PF: error_code(0x0000) - not-present page
>>>   [   33.586879] PGD 1023c7067 P4D 0
>>>   [   33.587668] Oops: Oops: 0000 [#1] SMP NOPTI
>>>   [   33.588265] CPU: 0 UID: 0 PID: 336 Comm: reproducer Not tainted
>>> 7.1.0-virtme #5 PREEMPT(lazy)
>>>   ...
>>>   [   33.588960] RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>>>   ...
>>>   [   33.592469] Call Trace:
>>>   [   33.592672]  <TASK>
>>>   [   33.592853]  only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>>>   [   33.593127]  alloc_surplus_hugetlb_folio+0x6d/0x100
>>>   [   33.593284]  alloc_hugetlb_folio+0x3c5/0x660
>>>   [   33.593430]  hugetlb_no_page+0x3d9/0x650
>>>   ...
>>>=20
>>>>=20
>>>> Sashiko said things:
>>>>       =
https://sashiko.dev/#/patchset/20260702215713.627941-1-souravpanda@google.=
com
>>>>=20
>>>=20
>>> Sashiko is right to highlight the following: By defaulting to
>>> node_states[N_MEMORY] instead of
>>> cpuset_current_mems_allowed, it appears the allocation loop could =
search
>>> all system nodes, breaking NUMA isolation for containers.
>>>=20
>>> I will apply &cpuset_current_mems_allowed  instead of
>>> &node_states[N_MEMORY] in v2.
>>=20
>> Hi Sourav,
>>=20
>> Thanks for your report. However, I suggest fixing it in =
alloc_fresh_hugetlb_folio(),
>> because we also need a right node_mask for =
alloc_contig_frozen_pages() case.
>>=20
>> Muchun,
>> Thanks.
>=20
> Hi Muchun,

Hi,

>=20
>    Thanks for the review. I completely agree with you :)
>=20
>    Here is the planned diff for v2:
>=20
>    diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>    index 571212b80835..ab5deba4f7a1 100644
>    --- a/mm/hugetlb.c
>    +++ b/mm/hugetlb.c
>    @@ -1865,6 +1865,9 @@ static struct folio
> *alloc_fresh_hugetlb_folio(struct hstate *h,
>     {
>         struct folio *folio;
>=20
>    +    if (!nmask)
>    +        nmask =3D &cpuset_current_mems_allowed;
>    +
>         folio =3D only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, =
nmask, NULL);
>         if (folio)
>             hugetlb_vmemmap_optimize_folio(h, folio);
>    diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>    index 39344d6c78d8..79dbd0baafa3 100644
>    --- a/mm/hugetlb_cma.c
>    +++ b/mm/hugetlb_cma.c
>    @@ -34,7 +34,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int
> order, gfp_t gfp_mask,
>         if (!hugetlb_cma_size)
>             return NULL;
>=20
>    -    if (hugetlb_cma[nid])
>    +    if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
>             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], =
order);

LGTM.

Please send a v2 version.

Thanks for your work.

>=20
>>=20
>>>=20
>>> The other issue Sashiko highlighted is also valid (but unrelated to
>>> this patch) and I can bundle a fix for it in v2.
>>>=20
>>> Essentially the preferred nid needs to be extended with a
>>> node_isset(nid, *nodemask) check.
>>>=20
>>>>=20
>>>> Ackerly's "mm: hugetlb: move mpol interpretation out of
>>>> alloc_buddy_hugetlb_folio_with_mpol()" made big changes to
>>>> alloc_buddy_hugetlb_folio_with_mpol():
>>>> =
https://lore.kernel.org/20260702-hugetlb-open-up-v4-2-d53cefcccf34@google.=
com.
>>>>=20
>>>> If this bug is real then it would be better to stage your fix ahead =
of
>>>> Ackerly's series.  Possibly with a cc:stable.  Then I can redo
>>>> Ackerly's patch on top and we'll need to check that this bug isn't
>>>> reintroduced.
>>>>=20
>>>=20
>>> Makes sense! Thanks for connecting the dots :)
>>=20
>>=20


