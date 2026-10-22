Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6FD60A3834
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 20:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tHMVweDH
Received: by kanga.kvack.org (Postfix)
	id 5D8C06B0281; Thu, 22 Oct 2026 16:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589676B0296; Thu, 22 Oct 2026 16:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477D56B02A5; Thu, 22 Oct 2026 16:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECF86B0281
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:15:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FF85A6638
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:15:46 +0000 (UTC)
X-FDA: 85351367892.07.B913964
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE2654000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:15:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tHMVweDH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792700144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C21jdElIWwsssKLBUPwYkC+7CgwOgr8UZ/ugVKG2QZM=;
	b=dRrrBBp/iFkT2Tb2Va1IkK6sguXYjSpGZPZWDa55/OmZzl0h46vJISwzETIhKms55GITI+
	mk21l0n3Js116d4H5Dk6auubhiRD6M+DYd3zIgCKsMmZrnyuUFjMymcXHw4onDCnerWF7p
	GOmCu9JnITvPGeSrDNP6i3Q3at7J6o4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tHMVweDH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792700144;
	b=eJ0HQbrcS2/nF212/TNF30Xb1eh2LJKU7mqgYfDn9VQOfXkmVu+x18FGPkB4B1M0nEQxqM
	xAgRNAz41Nzm44Zg0AsUfNx4wODO3LhhZRxtsJK2J0ewwZvAiw+i0dJYaXh3Wf0OpZOCjI
	q07ZSgM/3ax6V2rAVfKHYXtZtqPBCYA=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5366ae57896so1125161cf.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792700144; x=1793304944; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C21jdElIWwsssKLBUPwYkC+7CgwOgr8UZ/ugVKG2QZM=;
        b=tHMVweDHvPKtb6y+Lfo/gSF4EeFBIe9183EjeRvHqG0exDgozZDFG5/8OqAJ1XwNEU
         2+a9jvTrvqfKEyc1isWvGbU+WH3Udg9qXUGzlQHhK6JdkiSXP6FKdmlfFMYlwlnzuCtM
         MTYDxjEdTFhdzK88izxpJm1C1sg8dH+3tQOuzcDOtCss/7RuGO4Jx+tuqKrSjZk/qvuA
         Er6oNIgVHoN3wYmLq4AcZUs8f8ak6nkoLQcR1gii28FnBdKWOk5j5slaAwWwvqe7RksX
         /yprOJo9HkSgaHjeelCi9pwk0YtJogFnffEYlduAmQrN8s0eYOg3NFOkyGYCkN8vq3vr
         7akw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792700144; x=1793304944;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C21jdElIWwsssKLBUPwYkC+7CgwOgr8UZ/ugVKG2QZM=;
        b=0d6aAeDmBDXZeVwrytHD9i0aJcXuEqw3dEd4EFCEDMDOPsJhzHJPfbw8Se4okmLjDM
         5EyuCZbLH7FRP8x6Xc6Mk22KqSqAFN584240GAGjTGmW+ftB+ZbIwFhg5Wp8IGuSEFsH
         RmKXUCxTLVRvEJbHwUG5iYsmiQO8YXZGcOt9qKJCnOnBGtXGHLvfT1OhkEzwkmXKyYAi
         nv67gRJy7TC+AvCZHbVkvGc7eF+QG9vr8zFIobMt311CDag2OpDxp+Fc2eNsyAPCDTcD
         aNZwb0kmwS4nRsH70+VNlZRGIOBo8HOEWZ+yT56A0b9tBK77l6Kng2317mn+qbmUnA1I
         TX/g==
X-Forwarded-Encrypted: i=1; AKwUvByONQz3tlaMnL3Cioo+4DlvTkRZ1HMH0lbEwe0CcfVHFaPvdLPlbbIgQvaQsUnb1awYSu7Ph3hvDQ==@kvack.org
X-Gm-Message-State: AFq9FYLtl0bGvDyA7eCp84vs26cy8aX4Lf2bqb4GFPg22RnAg7BbwdhS
	CzoBnyJi/tbfRSW1zrCr+iL6jUuQECHI9i6mOiyIDRpJ9wITatQXJANetOZtX6+eHhwoZQ==
X-Gm-Gg: AYBFou2RylD5MaErMqfAlgIRnNVg/K5i/sOYGY5di+EnsZrpA5Dnr6JvdkK06XtB/1o
	3ot29j1huwQQ9mE3aDQk6luMQNxNjYF0ffn6LOc9Vg8uJGK32121B0ffZ4Sqsuajmf55/ZMn42v
	iitcpVg73+awXASZPICdio2ILyp8Nbb1eJi+Iztx/j3bAviAe/pjNWEsnbjvPjxAmC0yt8mruDI
	7HErD/LzA53wrhnSTHlC6fq7SIx0vVazogtgT7XrR+0lhPJMs3Au66m/oHjVH8hFmzqLie0NqYo
	JB4O7bGcAQx7PmdK4C6gKwCpq+GTOBhqXn7enh5MVNhA5Sw1NDzIygUJZVwC1UMj9OC34oZhOaJ
	6bIwjQuBZgk7WS1o4OSRMPdcpAZfFoAcPVtxT3U7Uf6oix9MzQqsXvL0jDqkDsto+YSbxxhzfoq
	vjY3o+qlkEHFC4kUo1BmtJQEwzZ0EaqgxQxEfWFBJFA+F9BDk/+Q4mLRTJy9WWpBQ63K3gD/H57
	yXkIwWL5LoWhA5w4O+/mdenhikmC/+vLThigmgC/F5b0tkNxRI85IYVsEUQxcYk
X-Received: by 2002:a05:7301:650b:b0:360:c266:cdd8 with SMTP id 5a478bee46e88-369d982e719mr358462eec.24.1792699801138;
        Thu, 22 Oct 2026 13:10:01 -0700 (PDT)
Received: from localhost ([2409:4062:2d82:947a:d2bd:526:9310:d9af])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9e180f6sm160737eec.28.2026.10.22.13.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 13:10:00 -0700 (PDT)
Date: Fri, 23 Oct 2026 01:39:56 +0530
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Richard Cheng <icheng@nvidia.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>, Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>, Harry Yoo <harry@kernel.org>
Subject: Re: [RFC PATCH 4/5] mm/page_alloc: Keep pre-online poison out of the
 buddy allocator
Message-ID: <atptlI4Pstd70N9u@acer-nitro-anv15-41>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-5-shaikhkamal2012@gmail.com>
 <atB-cL8x5CSMOHEP@MWDK4CY14F>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atB-cL8x5CSMOHEP@MWDK4CY14F>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE2654000C
X-Stat-Signature: bzk3tx1m7omnh33aoscxgx5amuihfi1j
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792700144-31044
X-HE-Meta: U2FsdGVkX1/oc1aQNrO2syx6VXCyMVcDAhvAyB5648D2Sa8Y4l1ZqMEegZKS5F96N28v5ZBjOE4CPvb6aT65H7wPX0VLCg2v+doGdY7vE34NXvO+tj0W03hBatozbLwFa2lh+RNQdcGt6CG3OT9ucKEBbdYswldYNQkA7JdsEDXHzAbqLiI00rH2AwT3afcWB3x+Dhbz9YupVdYdOmTTm2WRIAkmiwncYs/PoZ9N8SxESznQ5CAauUiB2Plf2v3MRYkbhQ8TWTgKzg3A1R8UVNJK3FEFac0XWcJLJof1Eow4mHWLW69oPqv6EM82HuPElM9cKYav5hpDJnziPixRx1wuCeYnR2jYUUoQuMti1Ghncv0uvnjyz68Q9IiO7RZ8Oztc/xgPC8KFuXzXkyJTVD9gGnhme0OKUjuGf7o7vV6GZWkhh/N/aAaIElbemRa/ue2vExrqTzaqMaHGBchay08tZER8qadOSMoOYun+It/1CULapVO1TG6zhXN+s6pEu7OcLux8Ub5/yDyOFYkqNdp7q3VcPWFNfWxD7WoS81XgwxP0QzILXTRyHIIzO5Llu9IU7nwXb1H0V0mfo4U9hxAKZBRh31CX4M7v/JPIEDY1soBkwhIusAMGTD9a9n06Efgj0fXJIeQsvH1QeCsvju3PujfRuJzbs2mLCVsUxDv4T1+hw0drzwcG85DqGK5gHII6WdpK5cZ2ZFmgGPI4y6WYzYxieR4EFSiFfo57jyDJsc7PoSGP0kSGAHJx6H6kM3w3KbeYysTH4zqBeGdBmV3t9ratp1+Vi9r+X0gdrzLkRN8yN9lJOAZ92Ef63hvfCVCjgIDM4nmOjORIdekAep2ocyfxMr/c5zWEwbGl0VA67Y7ibeQueDobORP+EvbCQtWGFRghyl5Js4dXrKwnoYSLHUGUh1hHr1hcQ1PuYdMAa/cLd0K1MOtg6O5EcGvvolIvox+uHBk58+FIB6K
 9DrVmCAq
 ElcUnzoXZpGiFnqRZVTyS6292b73tu59x8NBIapnae3gTx8qos2dRO7YImX4/sh79R90WZC/SsltwiCR+IJCH3rl5tbNOaM2IlcfUHE93KOY7T0TZPPVrvuFd6qYD744DcnpFFvniSJWVP6ig66mA24OLZ4hm/Y+e9XOj7VOebUqEsdSGkLyq89bb2ddLDawJAkk1KFMWWRrKVbnSPeth5rym+VBB9b8DuCmGnjJX/igALl3ZxNkt7wtdeVZiqGCRzX40iC/g3MdK36LprKROiYC13eixKgWzN/y8HyQu26LZFnPajsASjDCU4iGibIVcJ0wduObsmfHx2KVJPU7Gejb7QmjIeOT5EMhxWfChbfZLYBScy0c71DIHKV/A32CtIe6CxzxKegtpHFiAEYbmnpSjpJuyNFj34gVa+5y+8/LVYcMXIU8qamyPGjirpDyyVf6BSAQDh81Dxc88nageSy/6Za8fbdpiv2Tce1nfB2/1pqiUB6lYWL9uJqV9rwqwSeor1Xx0SKt0RwQwwZIU03Jr62k2eDT+odPLYVVfdRkSUEAKaxTpB3AisynTJeHTqHyFMy7Cnlzm0guCYbmE4RgnuDUrUk+b25TUgqUoiUkQ3kA1w1cyDrWiv65dXPSeBLud
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 15, 2026 at 03:27:54PM +0800, Richard Cheng wrote:
> On Sat, Oct 10, 2026 at 09:50:12PM +0800, Shaikh Kamaluddin wrote:
> > The inherited-poison path checks initialized blocks before releasing
> > them to the buddy allocator. CXL device poison discovered before
> > hot-added memory is onlined is recorded separately in the pre-online
> > poison registry.
> > 
> > Extend __free_pages_core() to send a block to free_poisoned_block() when
> > it intersects either poison source. In free_poisoned_block(), withhold a
> > page when its PFN is registered as pre-online poison or its physical
> > address is present in the inherited-poison table.
> > 
> > Pages identified by either source continue through
> > hwpoison_boot_page(), while clean pages are released through
> > accept_and_free_block().
> > 
> > Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> > ---
> >  mm/page_alloc.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index cca67a2702a4..57843df01b2a 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -33,6 +33,7 @@
> >  #include <linux/cpuset.h>
> >  #include <linux/folio_batch.h>
> >  #include <linux/memory_hotplug.h>
> > +#include <linux/memory-failure.h>
> >  #include <linux/nodemask.h>
> >  #include <linux/vmstat.h>
> >  #include <linux/fault-inject.h>
> > @@ -1601,12 +1602,14 @@ static void __meminit free_poisoned_block(struct page *page, unsigned int order,
> >  					  enum meminit_context context)
> >  {
> >  	unsigned long i, nr_pages = 1UL << order;
> > +	unsigned long pfn = page_to_pfn(page);
> >  
> >  	for (i = 0; i < nr_pages; i++) {
> >  		struct page *p = page + i;
> >  		phys_addr_t phys = page_to_phys(p);
> >  
> > -		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
> > +		if (range_contains_poisoned_memory(phys, PAGE_SIZE) ||
> > +		    preonline_hwpoison_contains(pfn + i)) {
> >  			hwpoison_boot_page(p, context);
> >  			continue;
> >  		}
> > @@ -1652,7 +1655,8 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
> >  
> >  	/* First: a block parked by __free_unaccepted() never returns here. */
> >  	if (range_contains_poisoned_memory(page_to_phys(page),
> > -					   PAGE_SIZE << order)) {
> > +					   PAGE_SIZE << order) ||
> > +	    preonline_hwpoison_intersects(page_to_pfn(page), nr_pages)) {
> >  		free_poisoned_block(page, order, context);
> >  		return;
> >  	}
> > -- 
> > 2.43.0
> >
> 
> Hi Shaikh,
> 
> I think the idea of discovering device poison first is good, but the boundary
> should be more strictly designed.
>

Thanks for the review, Richard.

> Now if I don't get it wrong, if we turn on memory_hotplug.memmap_on_memory,
> we can have part of CXL memory to do the bookkeeping for itself, without
> using the existing RAM.
> 
> What if that bookkeeping part is poisoned ? the check ignores this situation
> right ?

Yes, you are right. With memmap_on_memory, each 128 MiB block's struct
pages are placed in its first 2 MiB (0x200 pages) by vmemmap_populate()
when the memory is added, and memory_block_online() then onlines only
start_pfn + 0x200 onwards. Those vmemmap pages never reach
__free_pages_core(), so the registry is never consulted for them.

I reproduced it in QEMU 9.1 (TCG) on next-20260908 + [1] v5 + this RFC,
with two Internal poison records in the first block: DPA 0x100000
(PFN 0x190100, inside the vmemmap area 0x190000-0x1901ff) and DPA
0x400000 (PFN 0x190400, outside it). Both are registered, but only
0x190400 is withheld.

Steps:

1. Config: CONFIG_SPARSEMEM_VMEMMAP=y, CONFIG_MHP_MEMMAP_ON_MEMORY=y.

2. Boot with memmap_on_memory, without auto-online:

   vng --disable-kvm --run ./arch/x86/boot/bzImage \
     --disable-microvm --memory 4G --cpus 4 \
     --append "memory_hotplug.memmap_on_memory=1" \
     --qemu-opts="-machine q35,cxl=on \
       -object memory-backend-ram,id=vmem0,share=on,size=512M \
       -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.1 \
       -device cxl-rp,port=0,bus=cxl.1,id=rp0,chassis=0,slot=2 \
       -device cxl-type3,bus=rp0,volatile-memdev=vmem0,id=cxl-vmem0 \
       -M cxl-fmw.0.targets.0=cxl.1,cxl-fmw.0.size=4G \
       -qmp unix:/tmp/qmp.sock,server=on,wait=off"

   # cat /sys/module/memory_hotplug/parameters/memmap_on_memory
   Y

3. Inject Internal poison over QMP (host):

   { "execute": "cxl-inject-poison",
     "arguments": { "path": "/machine/peripheral/cxl-vmem0",
                    "start": 1048576, "length": 64 } }
   { "execute": "cxl-inject-poison",
     "arguments": { "path": "/machine/peripheral/cxl-vmem0",
                    "start": 4194304, "length": 64 } }

4. Create the region with kmem not yet bound, then enable
   memmap_on_memory on the dax device:

   # grep MemTotal /proc/meminfo
   MemTotal:        3999996 kB
   # echo 0 > /sys/bus/dax/drivers_autoprobe
   # cxl create-region -m -t ram -d decoder0.0 -w 1 mem0
   cxl_region region0: withholding 2 frame(s) reported poisoned by the device
   # echo 1 > /sys/bus/dax/devices/dax0.0/memmap_on_memory

5. Add and online the memory:

   # daxctl reconfigure-device --mode=system-ram dax0.0
   # lsmem
   0x0000000190000000-0x00000001afffffff  512M online  yes 50-53

6. Result:

   # grep -E 'MemTotal|HardwareCorrupted' /proc/meminfo
   MemTotal:        4516092 kB
   HardwareCorrupted:     4 kB
   # tools/mm/page-types -a 0x190000+0x20000 -b hwpoison -l
   offset  len  flags
   190400  1    ___________________X_______________________

MemTotal grows by 504 MiB rather than 512 MiB (4 blocks x 2 MiB of
memmap), so memmap_on_memory was in effect. Only 0x190400 is
hwpoisoned; 0x190100 holds struct pages.

> 
> What about draw a clear line between normal RAM and hot-add CXL memory, have
> the latter gone through the thorough check and do the rest you want ?
> 
> Best regards,
> Richard Cheng.
> 
> 
> 
> 
> 
> 
> 
> 
> 
>  

