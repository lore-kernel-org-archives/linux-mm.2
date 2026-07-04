Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5587C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 03:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627BF6B00B5; Fri,  3 Jul 2026 23:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7E36B00B6; Fri,  3 Jul 2026 23:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE0B6B00B7; Fri,  3 Jul 2026 23:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4FC6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 23:05:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77BE7140386
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 03:05:30 +0000 (UTC)
X-FDA: 84949603620.17.71CEAE7
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id A5517160006
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 03:05:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FbHOeWEq;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783134328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKcx9xQPrg+AgCVphOn0ADnc7AjARRS3dqAcliOGEMA=;
	b=0uaVwNtxEv9K3vvLBfYnqzSgnTNLUQ6OSJ3ngmXzm4FFf5UCotJ/6taMHIBve5i8b0NZwA
	PH+SbfetPTcFbFYPNu0GLBQLBcLOjxoe57TduarH5qXmUAl0kh9R1CxPBEGxSN7mMQ+bpv
	Qa+ILkEM/ufCJtoMIVLy02QoYnWBNW8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FbHOeWEq;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783134328;
	b=HGO5N50724ysLNkUWCkyXy59kILqAUDnjSCOe8WV3WEbr3Mn+pKgsR7HvYrJpcyNk2LaFw
	8PifztLqo4F4kPsxUDfNpoFS8bBwWKvF7Q3rc5UYWkTeUoKz5KOYRcxQmGL9J1+hYlnzKO
	VQsd+4nnXN9TrxBpiIJJ+0vD688NufM=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783134325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IKcx9xQPrg+AgCVphOn0ADnc7AjARRS3dqAcliOGEMA=;
	b=FbHOeWEqrW2jMgNH+WdKjDSM/siPPCYAKfzyGSIRBqEO4neJCZxiJpKc3yU83PmXi+lGda
	NmVsJ1iDNQsu20cDUW4QwyErzMULKw7DYywQ+i3vki9ZkrqCcUz/BX4u67EyQg6e6Bc879
	bDYn0hWLzR/daQN2RdrPRVtCC9uUXVE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: Fix null pointer dereference of nodemask in
 hugetlb_cma_alloc_frozen_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CANruzcR+uQPisER8KDFH3x4C-O22xvUwQEgv2=TQ=MHooO11Gw@mail.gmail.com>
Date: Sat, 4 Jul 2026 11:04:38 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 osalvador@suse.de,
 david@kernel.org,
 surenb@google.com,
 fvdl@google.com,
 gthelen@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CA20002F-CF0B-4E27-B5F8-EE1D17EDE6F4@linux.dev>
References: <20260702215713.627941-1-souravpanda@google.com>
 <20260702162415.142571f4d8c43aa4b95b9f7c@linux-foundation.org>
 <CANruzcR+uQPisER8KDFH3x4C-O22xvUwQEgv2=TQ=MHooO11Gw@mail.gmail.com>
To: Sourav Panda <souravpanda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5517160006
X-Stat-Signature: 3j194uyxu38iuwebo5rta8oy3f3kh9up
X-HE-Tag: 1783134328-229328
X-HE-Meta: U2FsdGVkX19yF76KWpQp9N1/6EDhE8SNVTs/wuDZRgUkrYJ2LYaJTjLG0TtcUsd4HP8WoVVRhGf+cfHEjHa7gxHtn8uivSkn4VS5exhUDGXM4BTybpzvx/J/STfaht41prHfR+hd7oBAta4w0QS+WPOfeujEo2uIEkdXhBfxihFRW8fNFWN8NYIiOVSdMF6WaczFdl69ETNkqlIrkGEnyF+r/lyi6iJBxoITGT4IIitPZQkPNGc3rK0kRwOOYKK61S2PkEi5d3FkBK3LYcxJKimV3tJq6cgQ4j7P5MKISHvYJK8/o0/oL+b8WeCnUlvVdvNuK5Q97uGk/aYT/U2zn44a0HQkeMyH/GlXarx2hwpc1hy0Q8yxQZpGd3bbJp0jSabFQNyZCrKFsTO1CgkwEohPqGp2z0gyVowdN1ZEgzZGdRI3UaheoMfduauWLiNR/1IxuK+BO0bQD1eAKea2fkjVstl2X33KYf9R4noZ4+Wrs0s6/CtLrV5iXnq2IIkpXcze4QiVRlBGS+7QNtOpeMhCuPeYmA6PidRX57ahslGzCUu+7gew+fZqrg25fJBSnX5iii3seljaRIIElUy51FmX+Fwg1tKWFZ9EO/GshbPqYNQNesx+S4eeM4f0kspcsv4aGp4cDntEdlGDkOj3PwxgOwQo/g0MWwPFSD+sQaFq8OLwLUfE7K0S5tSaiV1XFNzAoEcyHEYbt4wvdFAUcbSSfcfF3UMRfycNuddjH+n6AwYlNj+0+EaU5hXIqAMAvcV55vCZxYzXY5CLJDF94tsqGFUfvY1uirtQRIMXgQr3p2x8ebOiekzdJ98HE4Y5rFVlKU6DhXqnvB/bKVvyFty5nRvzJ1tuPc7vVIdksxdCR3DsVxe0l0uycNO39RjcQLi3E3nVQLq2jeNxLw40cF3pZqQLT5hDiHphIwQpzDpCvx10gLqmQ2Gjm4/pvPZ2/GHUwY/Sdfo9vO6QPKk
 rX+xn0gS
 56HxHgJZGeIG0VHL+uPN255Tq3N6FedbDawygQRn1fsUEi3DYIE8zZrqKWhcUpTa2FveuG08TNIaV/aac9VkqgR2iUcSRHTF+s+B3Fc7zernNtkGTKKvJJ1o7o+z6vE1NP6UiIzbyQ+aKP8KF+o+jBgsiDcMAQvpUutTRp3YdM8lJJjcUdFAzB1w8sJMdCSVyd374Kwo1vL6xWeDb2EMaQg+HnVKRp9MvTYepOvtqk4hcvFhKdPI1kCv2e/VBJFA8gFGHcjU7E/qe3RgXzLR/J8WMGTyExXASeR51xKPt5E66bcjAke/WYfsxFYqMtzYOylH+1zIPQ1ZefET9bDAIU9gD2gpHFXOMC/3c4P7smQ1JLUk+cgXyaZYpMR2SSLdpNyGOckBqhD4AhMKc+ZqeBAap04hau2co236s6E+r+L6/VwmqFvYXs34uhKPj3HkVmj2B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 4, 2026, at 04:04, Sourav Panda <souravpanda@google.com> wrote:
>=20
> On Thu, Jul 2, 2026 at 4:24=E2=80=AFPM Andrew Morton =
<akpm@linux-foundation.org> wrote:
>>=20
>> On Thu,  2 Jul 2026 21:57:13 +0000 Sourav Panda =
<souravpanda@google.com> wrote:
>>=20
>>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
>>> hugetlb_cma_alloc_frozen_folio() as a fallback to allocate from all
>>> nodes. In this case, hugetlb_cma_alloc_frozen_folio() blindly
>>> dereferences it in for_each_node_mask(), leading to a null pointer
>>> dereference.
>>>=20
>>=20
>> oh.
>>=20
>>> Fix this by checking if nodemask is NULL and defaulting to
>>> node_states[N_MEMORY] if it is.
>>>=20
>>> --- a/mm/hugetlb_cma.c
>>> +++ b/mm/hugetlb_cma.c
>>> @@ -34,6 +34,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
>>>      if (!hugetlb_cma_size)
>>>              return NULL;
>>>=20
>>> +     if (!nodemask)
>>> +             nodemask =3D &node_states[N_MEMORY];
>>> +
>>>      if (hugetlb_cma[nid])
>>>              page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], =
order);
>>=20
>> It is possible to hit this with any known testcase?
>>=20
>> If not, why not.  I smell the smell of dead code somewhere?
>>=20
>=20
> Currently, there are no selftests in the tree that trigger this
> specific  MPOL_PREFERRED_MANY  fallback path, which is why it has gone
> unnoticed.
>=20
> The bug only triggers under a specific topology: Multiple NUMA nodes
> where gigantic hugepages are backed by CMA, but only on a subset of
> the nodes.
>=20
>  1. The Reproducer:
>    #include <stdio.h>
>    #include <stdlib.h>
>    #include <numaif.h>
>    #include <numa.h>
>    #include <sys/mman.h>
>    #include <unistd.h>
>    #include <string.h>
>=20
>    #define GIGANTIC_PAGE_SIZE (1UL << 30) // 1GB
>=20
>    int main(void) {
>        void *ptr;
>        unsigned long nodemask =3D 1; // Preferred Node 0
>        int ret;
>=20
>        /* Allocate 1GB gigantic hugepage area without reserving */
>        ptr =3D mmap(NULL, GIGANTIC_PAGE_SIZE, PROT_READ | PROT_WRITE,
>                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>=20
>        if (ptr =3D=3D MAP_FAILED) {
>            perror("mmap failed");
>            return 1;
>        }
>=20
>        /* Set MPOL_PREFERRED_MANY policy (mode 5) restricted to node 0 =
*/
>        ret =3D mbind(ptr, GIGANTIC_PAGE_SIZE, 5 /* MPOL_PREFERRED_MANY =
*/,
>                    &nodemask, sizeof(nodemask) * 8, 0);
>=20
>        if (ret < 0) {
>            perror("mbind");
>            return 1;
>        }
>=20
>        /* Trigger page fault */
>        memset(ptr, 0, GIGANTIC_PAGE_SIZE);
>=20
>        printf("PASS\n");
>        return 0;
>    }
>=20
>  2. Triggering the panic in QEMU:
>   CONFIG_CMA=3Dy
>   CONFIG_HUGETLB_CMA=3Dy
>=20
>  Then, boot a VM with two NUMA nodes, restricting CMA to Node 1, and
> run the reproducer (+pdpe1gb  is required).
>=20
>    vng -v \
>        --cpus 2 \
>        --memory 8G \
>        --user=3Droot \
>        --qemu-opts=3D" \
>            -cpu max,+pdpe1gb \
>            -object memory-backend-ram,id=3Dmem0,size=3D4G \
>            -numa node,nodeid=3D0,memdev=3Dmem0 \
>            -object memory-backend-ram,id=3Dmem1,size=3D4G \
>            -numa node,nodeid=3D1,memdev=3Dmem1" \
>        --append "hugetlb_cma=3D1:1G hugetlb_cma_only=3D1
> default_hugepagesz=3D1G hugepagesz=3D1G hugepages=3D0"
>=20
>  Inside the VM:
>    gcc reproducer.c -lnuma -o reproducer
>    echo 1 > /proc/sys/vm/nr_overcommit_hugepages
>    ./reproducer
>=20
>  3. Outcome:
>=20
>    [   33.586151] BUG: kernel NULL pointer dereference, address:
> 0000000000000000
>    [   33.586512] #PF: supervisor read access in kernel mode
>    [   33.586680] #PF: error_code(0x0000) - not-present page
>    [   33.586879] PGD 1023c7067 P4D 0
>    [   33.587668] Oops: Oops: 0000 [#1] SMP NOPTI
>    [   33.588265] CPU: 0 UID: 0 PID: 336 Comm: reproducer Not tainted
> 7.1.0-virtme #5 PREEMPT(lazy)
>    ...
>    [   33.588960] RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>    ...
>    [   33.592469] Call Trace:
>    [   33.592672]  <TASK>
>    [   33.592853]  only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>    [   33.593127]  alloc_surplus_hugetlb_folio+0x6d/0x100
>    [   33.593284]  alloc_hugetlb_folio+0x3c5/0x660
>    [   33.593430]  hugetlb_no_page+0x3d9/0x650
>    ...
>=20
>>=20
>> Sashiko said things:
>>        =
https://sashiko.dev/#/patchset/20260702215713.627941-1-souravpanda@google.=
com
>>=20
>=20
> Sashiko is right to highlight the following: By defaulting to
> node_states[N_MEMORY] instead of
> cpuset_current_mems_allowed, it appears the allocation loop could =
search
> all system nodes, breaking NUMA isolation for containers.
>=20
> I will apply &cpuset_current_mems_allowed  instead of
> &node_states[N_MEMORY] in v2.

Hi Sourav,

Thanks for your report. However, I suggest fixing it in =
alloc_fresh_hugetlb_folio(),
because we also need a right node_mask for alloc_contig_frozen_pages() =
case.

Muchun,
Thanks.

>=20
> The other issue Sashiko highlighted is also valid (but unrelated to
> this patch) and I can bundle a fix for it in v2.
>=20
> Essentially the preferred nid needs to be extended with a
> node_isset(nid, *nodemask) check.
>=20
>>=20
>> Ackerly's "mm: hugetlb: move mpol interpretation out of
>> alloc_buddy_hugetlb_folio_with_mpol()" made big changes to
>> alloc_buddy_hugetlb_folio_with_mpol():
>> =
https://lore.kernel.org/20260702-hugetlb-open-up-v4-2-d53cefcccf34@google.=
com.
>>=20
>> If this bug is real then it would be better to stage your fix ahead =
of
>> Ackerly's series.  Possibly with a cc:stable.  Then I can redo
>> Ackerly's patch on top and we'll need to check that this bug isn't
>> reintroduced.
>>=20
>=20
> Makes sense! Thanks for connecting the dots :)



