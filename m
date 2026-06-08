Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF1CCCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 02:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DB86B0088; Sun,  7 Jun 2026 22:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE55A6B008A; Sun,  7 Jun 2026 22:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB616B008C; Sun,  7 Jun 2026 22:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A439A6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 22:24:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 495051A08C6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:24:45 +0000 (UTC)
X-FDA: 84855152130.02.F32C568
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8E0154000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:24:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780885483;
	b=KQFIgKDp8nn8RTPPylPvq+5ylVmCDyYDlnnV71dyqN9NEEwks+NLYRgTy2xNZSdfY4OwOd
	kbultKGgHcaMUXt8b4SdibV06chLKVBHTYdguYgc6ibk7SsqHtIK1J1fAfM0MV1rAV+G2u
	sTOE8mJRenKbRXTdSfgE4qNPR/9wn+Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780885483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KMtsqRBjCOrQSULbhoPHLif+8pVKLFOQsh3ANJAM7Pw=;
	b=Www+Q1mWabbPQzmGmw/BwxbELcdYOHjAdZfkxzbxG7jtwWMB1xkbUWKn/eTBYjRIsh2dEW
	YEnt2jrDL/1H7MS/gUlVqCijWv3308GVcE3m6gQ8dlaokjk+qhrWc9OF8zBsWI9+ErxeY7
	W/VGurx0DSYiGc+IXOh57CZ7qx+BJQE=
Received: from [10.213.6.59] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABnTOPhJyZqff_8Ew--.21152S2;
	Mon, 08 Jun 2026 10:24:33 +0800 (CST)
Message-ID: <953d7a60-456d-4629-b133-afce62cc5b3e@iscas.ac.cn>
Date: Mon, 8 Jun 2026 10:24:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn>
 <da19ffcf-8042-4f96-9c2d-649468dc6a0a@kernel.org>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <da19ffcf-8042-4f96-9c2d-649468dc6a0a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:rQCowABnTOPhJyZqff_8Ew--.21152S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCryrGr45AFWxGFy8JF4ktFb_yoWrAFW8pF
	WUWFs5KF45Jrn3uws2vw17WF1rKwnYgr1xKw15G348ZrW3Ary8Wrn5KayYqry3XF4kua40
	v3WY9ry5Ca4DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F
	4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
	wI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUqdHjUUUUU
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspamd-Queue-Id: 8E0154000A
X-Stat-Signature: 6mpacpy844y55jo3fpekk4p9x348bboo
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780885481-813380
X-HE-Meta: U2FsdGVkX18zMIi45bBKoTIHxNN6yGxsKYSJIjBc8hUnvvyPfECbL7ij56DGLOMtHbA0d7LDUvs0f3doqgyQlSeXTCvK34jkL8BWHq3YXMIw88AlEglWglCnr49zuj8wkyNd4iT9573+hXA2TLQvVKlsyhrz0b8Q55YkBZrimDP6RhI+UF7BK1XdOxZkAyr1YqPSGSXihfVgTbHDaALu5SPhvOZeL/all1fCdgHO9MU1jFVhqJL9tYk2ny6udL4ijWMx2+UuM/qTatpfLiAWUpDzGHrCYIDU+dIV5X63oW/3d67t+p4Udsk+GkBTOEVMidYVVWElnnrLGX5K1sxMo8SlR1NDKJUqaFXaZBVjGvo/lwSmD2A4Q1AgpdCFD4z1zg/hnESJqYtI6drKis6P8OfPIqQd3XPfs8FB/miiQEr6pRmn8eoXZPzNUZAojoNmBuEazzWMBZR7yJOSJAHtVBDXWHjf4XFrv0lbtsP18rhY+fvpzb8oyPu1vK8uZfCF+jegF0WDStfrcQrY1WiC5JLtDQqVaVz/1v8obg34BA111OE08RRi8OfmE+qMNr/Yzs4ZjX1ruKSTVUDu+woq89lNtkM25Lpt8rJVMgMoT15qxSwinBeA8A8CqVlOVZIew0SWm4UZza4yohVGqHbdKKjTb1Cweq5A4OiOkJRTQe6aXhdLu6RSdvtnkg9CkNXVO1h70RD8z6f69cgNR17REbTT9LOMMH8TUuDtCpIT40E5mk3YtkWku7qMndA7NwG1HIWMLHJkd41uuMwZVmCUcq7vNrn7U+4It39j30k9CNoKWpP4Un9YbLXV/N1Zp1ShyB8PjYIoDURtVe2k86f72o8vDrb2bb2RZLebvRRf7BQatzIe+keqkp4Pn0iqR0DvgF+SvSMtelusBNU9owRqAA63aUJC+jiDIl2ghlh+uK8bmYpJfNQ7qmhUMWpkNqizg1XlwrJWEL7GSdaiBvQ
 3/Q9YhiK
 ua5fNMbgpihZvK0VuHir0xbff2wTFEe/W4bhNqJGgkpaYM4cgvfJwhM4jNCnVTwvLz2TTvM9mJl6ryFtR7npX733dqc+hFV8xF7LfKjpcGZH8lvCL7gPFQp4bSs0PPB47ZZvGIxO3slDnJhABA2h25TmzWvTVrhO2JK1IociTMGZRr7CMzzg+vPfkltyuBMAtcw4StnM0nvUFYnZwAdk49XJBirRtvDk0Vrkaz9vGmsvbHpx6VxPHagpjl2oG6km0epXc3jPkSLs0nYho7xiGJWARalJAqcy8jE0PWWIccj2DMYJ8DGINmsUf1Dh1icJqat3q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 17:16, David Hildenbrand (Arm) wrote:
> On 6/5/26 07:23, Vivian Wang wrote:
>> section_activate() does not flush TLB after populating new vmemmap
>> pages. On most architectures, this is okay. However it is a problem on
>> RISC-V since there the TLB caching non-present entries is permitted,
>> which causes spurious faults on some hardwares.
>>
>> This seems to be most easily reproduced with DEBUG_VM=y and
>> PAGE_POISONING=y, which causes these newly mapped struct pages to be
>> poisoned i.e. written to immediately after mapping.
>>
>> Add a hook vmemmap_populate_finalize() in __populate_section_memmap()
>> after population, to allow architectures to handle such situations as
>> needed. Then implement it on RISC-V to arrange for the existing
>> exception handler code to deal with these faults if they happen.
>>
>> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
>> ---
>> Depends on my earlier kfence fixes for mark_new_valid_map() [1].
>>
>> Found while testing AMD_HSA/ZONE_DEVICE on SpacemiT K3. Using
>> ZONE_DEVICE requires another fix [2].
>>
>> [1]: https://lore.kernel.org/linux-riscv/20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn
>> [2]: https://lore.kernel.org/linux-riscv/20260309-riscv-sparsemem-vmemmap-limits-v1-2-f40efe18e3cd@iscas.ac.cn
>> ---
>> Changes in v3:
>> - Merged back into one patch (Mike)
>> - (No code changes otherwise.)
>> - Link to v2: https://patch.msgid.link/20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn
>>
>> Changes in v2:
>> - Split patch in two, hook point and riscv hook 
>> - Explain hook necessity in patch 1 message (Mike)
>> - Make hook #define based (Mike)
>> - Call finalize hook only on populate success
>> - Link to v1: https://patch.msgid.link/20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn
>> ---
>>  arch/riscv/include/asm/pgtable.h | 4 ++++
>>  arch/riscv/mm/init.c             | 6 ++++++
>>  mm/sparse-vmemmap.c              | 8 ++++++++
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>> index a1a7c6520a09..aa0f50e3d534 100644
>> --- a/arch/riscv/include/asm/pgtable.h
>> +++ b/arch/riscv/include/asm/pgtable.h
>> @@ -1243,6 +1243,10 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>>  #define TASK_SIZE	FIXADDR_START
>>  #endif
>>  
>> +/* Needed on SPARSEMEM_VMEMMAP */
>> +#define vmemmap_populate_finalize vmemmap_populate_finalize
>> +void __meminit vmemmap_populate_finalize(void);
>> +
>>  #else /* CONFIG_MMU */
>>  
>>  #define PAGE_SHARED		__pgprot(0)
>> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
>> index 706f43523935..cf9ae4099f82 100644
>> --- a/arch/riscv/mm/init.c
>> +++ b/arch/riscv/mm/init.c
>> @@ -1360,6 +1360,12 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>>  	 */
>>  	return vmemmap_populate_hugepages(start, end, node, altmap);
>>  }
>> +
>> +void __meminit vmemmap_populate_finalize(void)
>> +{
>> +	/* Avoid faults on cached non-present TLB entries. */
>> +	mark_new_valid_map();
>> +}
>>  #endif
> How does mark_new_valid_map() handle concurrent access?
>
> There is some comment in there, but I am not sure if that actually implies that
> mark_new_valid_map() can be called concurrently from arbitrary context?

AFAICT, yes, it is intended to be used concurrently from arbitrary
context, and this is why I used them.

I had not originally written the code, so some riscv maintainer can
maybe chime in on this, but as I understand it the idea is that we only
ever set bits in the bitmap in mark_new_valid_map() while "allocating",
whereas the assembly code in handle_exception in
arch/riscv/kernel/entry.S only ever clears individual bits. So at least
the access to the bitmap itself should be fine.

This was added in commit 503638e0babf ("riscv: Stop emitting preventive
sfence.vma for new vmalloc mappings").

Do you think the mark_new_valid_map() function needs extra
synchronization like smp_wmb()?

Regards,
Vivian "dramforever" Wang


