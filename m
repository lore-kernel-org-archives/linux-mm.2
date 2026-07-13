Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E9FC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83FC6B008C; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B7A6B0095; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADA86B0093; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8FD6B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:15:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13337120AB4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:15:45 +0000 (UTC)
X-FDA: 84982742250.03.B0C2BED
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf15.hostedemail.com (Postfix) with ESMTP id AC956A0008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:15:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783923343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AzrTwFBQUWpvWum0a0KVR/zAHyBFHAFaO/wPFiBOklk=;
	b=K7HBSov36o2FRY869FmpXR4BjonFSo5R/NvzQtak4kq6LoviJhWYo0iEP7b5tTtle7sETd
	SaMK5QbvD5GCDanHO2jXYXLlNzKjmKoJVy3dv1yZl2oL8wPhjrEk83Q+uyZqLmyTl1wsEa
	owjyQ8EZ3Vrbg+tpriEdvDvA4kXodFI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783923343;
	b=XS/pXV1j6fyQczB+b6stv1rAG4Ew4+478r8YzL2Hq8IIsoy9q5qPoKIdkN1njGk53YgMUM
	K+5TBzLQAgqXvak/Cf42Vxl/qnj6J3EAGjA5IWU9uTfFSF7N1TXPvhaZhE/AW8FQYngvxf
	EhDSSN1mGw62+ZKUnFrwurQc8zs6eyw=
Received: from [127.0.0.2] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAHF86CglRqddeRFw--.29971S4;
	Mon, 13 Jul 2026 14:15:31 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Date: Mon, 13 Jul 2026 14:15:21 +0800
Subject: [PATCH v6 2/2] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-mark-after-vmemmap-populate-v6-2-b945ceba29d4@iscas.ac.cn>
References: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
In-Reply-To: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
To: Alexandre Ghiti <alex@ghiti.fr>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-riscv@lists.infradead.org, Muchun Song <muchun.song@linux.dev>, 
 Vivian Wang <wangruikang@iscas.ac.cn>
X-Mailer: b4 0.15.2
X-CM-TRANSID:rQCowAAHF86CglRqddeRFw--.29971S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw15urWxZFW5AF4UJr18Krg_yoW8tFy3pF
	ZrCwn5trZ5WFyxW34UA3W2gr1Fg3sIga48G3WrA34UAwn8XFyUWr98Kay0kryUXFWrXayx
	Crs0kry5WFyDZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUb_HUDUUUUU==
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Stat-Signature: hhbgadkjr1up1f1q3jyrwfkmc69stbwr
X-Rspamd-Queue-Id: AC956A0008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783923341-247403
X-HE-Meta: U2FsdGVkX1/7oQ+eIxoQ7nl+Q+Pxeomb2PiZnTbxxDuP5AqHhhbGB7uzbMgzcCybYMnFdQU5kYUzcEMk5Sw88j1ayN6lGJqf6Bxvv3k8GXogDmiOJJl3/c+HtthR0ShZHQWY332ut2CNgal52geR07ljTc+CVkv9TFXFKIalTjeLIW1D/+mArBxzVMx6nfTPWXtT9OYN81DpXqQRtMemwDIWN1lFESsnj48WvXuS+LwqEFr+WSQXlOEtetF26rKcAi42SQsXAnZkhx8apQrwlDGcQRC3MPlZTigZsojL9eoVVFdZHTgc3mcvvhJOZIB+gOowEXnxp7SfaPhhnDsCM7+vTxUMCt0Dx3B8hMYmJJ6uvvwDLlACi+d8X8nrpPHKqyPzae5cY17qAuvbX2UzGZ7N4HKYgYcO1YmFdWqc7eExPDmRFxLgIHLqxU12075hm88nQISXvLhv0zeBq+oA1FEvvidB/kSFBn39Zit6GbL+ttAPEWIAuv/EHRhDHdlXQd5WZ5EgLUIFk6+AIi1pDA8LWlIb7lvfJ06noLX4kOxEahg/2Kx2WVG71QhFWZ9VF5R2bLEeu2CK2KQXc+hUhEfjDXmNnpiV927I0/3rKAp2wMPz9BWhWKqSvug6QFJhEQShIxdN2/nMZjiXFTHGr8Gz77oX91CDz8vTlDmSzBLYrlk/sl1CNLFbl2Szv4UyqOB7kjwqOOnfqwzkfkvg+/HSM3JoOb1kJcXSalQPomNk+qCjQNYoWZThaANsBhJnI/MpH7uHsVLLq4yyS9pBFH4ZeZ6DGx93rm6Q1KacGcYIToDKPEkVMkYSwh9zJzFUCoGoK6T1Bq7eLALWD3ycOca2UoW16skcMI7Ob2mlrUp6I95M/s5NJvb5x0J4v1r0Lf3Nm4hQFC4VaXHIcg7EsNTT/LGj5avPE2O7jfLK4T32M5uht5LVXKhpigi4LqpHZFiW4jmb1oNt+DcnA69
 nLtiCMiL
 vbEdnGnS2O9Uj/WQ3p9wh6+aXVfkUu60tGEyuaLV7B7XiuPKvwrnnGigECG5w6BA79q7VcnwfIm5H/miMbBXomZkxfcj/lVvZkWgnPXHn99oyNNUJ4+auSzs0yMTa1HdH5nDB+y1QWhJhFZWeqM9fT9o+XVvFNZx7EUAFBIXFJnZeVRcyLO46uTQfHC62haIhCTmuAab3kaNNAVoFxPzTRKUl8hjwy0oO8/hy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_activate() does not flush TLB after populating new vmemmap
pages. On most architectures, this is okay. However it is a problem on
RISC-V since there the TLB caching non-present entries is permitted,
which causes spurious faults on some hardwares.

This seems to be most easily reproduced with DEBUG_VM=y and
PAGE_POISONING=y, which causes these newly mapped struct pages to be
poisoned i.e. written to immediately after mapping.

Extend the RISC-V flush_cache_vmap() to also handle the vmemmap range,
and call it after hotplugging vmemmap, which gets the possible spurious
fault handled in the exception handler.

At least for now, the only other architecture with both
SPARSEMEM_VMEMMAP and flush_cache_vmap() is PowerPC, which has a similar
problem with newly valid PTEs. But there flush_cache_vmap() is just a
ptesync. So it should be safe to do this for generic code while having
minimal performance impact.

Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
---
 arch/riscv/include/asm/cacheflush.h | 3 ++-
 mm/sparse-vmemmap.c                 | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index 58e787fad029..c2b0a2928f06 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -56,7 +56,8 @@ static inline void mark_new_valid_map(void)
 #define flush_cache_vmap flush_cache_vmap
 static inline void flush_cache_vmap(unsigned long start, unsigned long end)
 {
-	if (is_vmalloc_or_module_addr((void *)start))
+	if (is_vmalloc_or_module_addr((void *)start) ||
+	    (start >= VMEMMAP_START && end <= VMEMMAP_END))
 		mark_new_valid_map();
 }
 #define flush_cache_vmap_early(start, end)	local_flush_tlb_kernel_range(start, end)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 99e2be39671b..ebd3ac997f64 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -564,6 +564,8 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 	if (r < 0)
 		return NULL;
 
+	flush_cache_vmap(start, end);
+
 	return pfn_to_page(pfn);
 }
 

-- 
2.54.0


