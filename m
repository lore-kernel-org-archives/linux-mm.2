Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29ECBCD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692286B0088; Mon, 25 May 2026 04:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6694A6B008C; Mon, 25 May 2026 04:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E9D6B0093; Mon, 25 May 2026 04:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44B806B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:36:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F0E691910
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:35:59 +0000 (UTC)
X-FDA: 84805284438.25.D363B85
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D6094000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:35:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=leKuPM0+;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UivoV2Xy2DgFMm27nFQnaSGkNMDvBuLTx3f39WHCO5Q=;
	b=n6jIBIxpwjXXPw3Dl7ad6IjR0wmmG4ivCy8Mlpy6Yoyhsc1VXaqQ2cZgvb08XL3cfnEqaw
	nAiSL8xE+MrYW3T/rszB8qVxNBlHEQgyW5a64lIJLwd7Uw9+4YNJvwtejIt/lMy3WxoMoG
	X4xx07akuLQSr4ppaCaUat9yZqtpuGw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=leKuPM0+;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698157; a=rsa-sha256;
	cv=none;
	b=PgGEfScj6FknIjx7hCHaPFi2tDvp6NNYOC4hKkbATZqOhjgGVAQBTLg0nHTfQARJWDUiAY
	MKBQsHt0q7Un4gCNkgWdrn/C1LcKmcLgLsYR/9dq107p1oaG6j7iwivCkUjpZ3aYEx7cpr
	xYkI25x1C9/DknOfPo+M/eqt+lPcYs4=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-68914995e35so2136148a12.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 01:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779698156; x=1780302956; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UivoV2Xy2DgFMm27nFQnaSGkNMDvBuLTx3f39WHCO5Q=;
        b=leKuPM0+UI9pcBc/Rg2Gb3k9rRehkbOKPAJH9zE1EmlyCgDjjuqVmUdm+dPG/ecSnp
         hRkqA3DmVWMMO5QnDzvLJUcLYKSZ+Qe/FlubZw/ZbWeRMqtH7l4kzN5U50lkK5TR0gIb
         goBDJgYzW+DBm32SV6uFoOLvU6nhKvcwo0vUCSdtO6LB8+zC3rIb8LDSCaE5KEjDIIq+
         A+/RhNuCnX6J4d4yeDAm5nyNrQwrKEsVEyCIbw2aPEXa99Nro5S1gwC0yzZVbZ1oq4Ec
         dJpw0imFgPbv7RFsQf7Cg090tGZpDtgz4kj7CLB88jIu+xhdIxSgFn2ascitLPN6anD1
         Aj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698156; x=1780302956;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UivoV2Xy2DgFMm27nFQnaSGkNMDvBuLTx3f39WHCO5Q=;
        b=IELLHUvEbU4lOfMh/FvVztA/CahbcYRJjsoIfPLbFMETv6UREtotXHp5hFPGADiX4A
         b/9Fkrj9MJ5hwIu+qbaXPRWHe9NKLaG5M2saS0kaV6S3y7Htg3tu9tfAlJMbEtHm3fCU
         E67/rkd2GXdir6o46jHenvwr1QlAQIxYR7SAlLSXf3da86HcKeDxHogT969C0r741KCH
         EA3HClkf3yPgp5rbMFJX8+6vFW8r4ehO6mfPGYKZPx/lLqtdCwJAsNb3q98ixYnqQfpr
         CQf/VctuDivmY9HgyA/OSVaTx1zwXLfCWMJuAn2cu/IF4GbW+HdGVKEYkDrDlkx/lnyl
         DcQA==
X-Forwarded-Encrypted: i=1; AFNElJ+6q7apoxID+7HK0aG1LSTeGeN5u7QWyJr1cnAQHK8TDHRspQTBPVODjOh7fNLmXube/+Fqz+GdHA==@kvack.org
X-Gm-Message-State: AOJu0Yxla/qfeX+LgDUXfNChIoTuDuNaSvpLUmamBw4KDRakwxLob4oV
	rsvZ61GMfmMpnijAU+nLbL7hC+CO6VZaANn3vE7hkiLN3qyt00afwR2A
X-Gm-Gg: Acq92OFJDBGaKT7ZVtv4J4r+kg92djS+9THfygg7xFFw7sFVsIOhH8Pva0MSF/FPcpf
	MS5hwZwKdaZBbqQUQuks3aLVwm7ZHWG/wgJLKpWOX30KWev9Ei8w6xd0Tn8X8iBO8yjNUPdvZrP
	4jhQqTSczC2lXxddOuSD54/GRA9EJE7ArOQTCXJyd69ONDUanLeid999QRFapyGvpNwB/dLY7CP
	Eo5M+cMhar5xKKZFnNXgzn1xFvxcWG5zNNjplpwnYdNBegFo9IQeDS7TG1i4MIlPqYop1T5KBqP
	OGTHYMh4LJ9ADYIj1QqpneXcJbzsjMoVJq1pUAeVMpapUIZoMckP2cMltWOCL9CG4Bd2S1rDIhJ
	1wpeDQMGD01ZGS+qNCxQesFK5dnpIgt8VOnlN9Is2rqvdUJQYXrXuzGgElOZ0XyFshHSwX0dD7Y
	clhxPzddCZ2hRkzV48fBllkbLq3wkYJQrZ
X-Received: by 2002:a05:6402:3584:b0:683:dd5c:191d with SMTP id 4fb4d7f45d1cf-6889cc5b394mr6546716a12.24.1779698155689;
        Mon, 25 May 2026 01:35:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-688b9f503e1sm3910176a12.7.2026.05.25.01.35.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2026 01:35:55 -0700 (PDT)
Date: Mon, 25 May 2026 08:35:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Liu, Yuan1" <yuan1.liu@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>,
	"Li, Tianyou" <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	"Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Message-ID: <20260525083554.6x6l5y46icekegzg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260520093457.3719960-2-yuan1.liu@intel.com>
 <20260521033303.7jg66h4sxwi4l3cm@master>
 <MW4PR11MB6936A4383B3EC638A4B24ED1A30F2@MW4PR11MB6936.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB6936A4383B3EC638A4B24ED1A30F2@MW4PR11MB6936.namprd11.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D6094000E
X-Rspam-User: 
X-Stat-Signature: mboioyu8gpa86y5zpzaukfhy7w95tfps
X-HE-Tag: 1779698157-185236
X-HE-Meta: U2FsdGVkX1+uMSAn/j8e57AJPEWb59ITNhD62DCr4SGQWvOxMs+OrvLfwDpX3RVUE2DAJVkEMnZ9ZMcVNLx9Uk6gy+2peDKjQbFy2j9F7qrju0JMyQrxLAr4b5LTr4pzfu5pmU/aRj86YY+QkRsleAwgKrlqQW/t/zUSUHbIeJ7+la92vzY6swfRKEUidINdSJgarLx8dPsAAlM1txAm9ZcaQcKOprRr3gw2Jv7UEkPkkmn5v6SbH74KmiH48dpPz2h2SNv0j82bdV020ykHhjzGGzV4WofT2n4Q84hDvAYVCfpl+mZZdchgqtc7bfY1fmB+skrFmmXMTivGiDZUrP/Riz7b9oCYzwzF9FVMiyot6pd9ntkp1MUaauKbCi5y33KnlKzbQLYSwwuy27ZV83JnZ0UsH0QdPsmKxubYa4W48taj8foCqXMknW+LKzz7yLpXmjf4/oel+bOuCy+GujDXT2iMufZ3T2b57X7WZEqRkO3WZ7t+ddtXAuCDtbQSfJu2rOuheo1AkPddPWkn7vaemnHdQDfGsq2RU/uwkdplERQCKs0dSCu0ReVeEzq03ZYk8RLtFj6kiKiFknnlyhXAHV9Jph8z0J4dL4lnoTqkAN/xqld+ReMylPITB6ubw/JjSo199/PApemBmiBEWaYgTCc1DG4e1wRu9Ldsy1aTEEQczhaldrtlZDNLj15Va108nt1HPJ8yN18QneK8lCLWunOcF3ONbEuijU3F02iWXcgdsy5Ua5vYy9oUXncP9+JgJM19zP/4oaBGPJcA2lz+EM2tWtBKfs+O7yjg4CMdXqpu5TEUcPfvAxuNaSiSt8AtrAN+Q5yqsZwHYfi156/EHqu/Xnrxzrupj7NSvocnvrQUz6CH4NB2BAzQwewXV5F7fL68Pwy9/Izw9gUcanrvgNat3RB+NSegCcc2dySckpxsTA6FqksFhziDULmTx9clso/JComcnc6PS4g
 ZOpMzeF1
 CtGaGrkxv68Qm/8pg5+daPhpFfKfRr6giImqhkszlDImLaUp0K5/2BaeqitsGxPQdm1G8F2lsJ2MK4CT6Y3nyjHUUjHqbntzlhpYLJVu/XUHZqduF+MQFZOmXNsYxA+PIlRFxNq0MNgiiXVaeeiDcViO6tAFRL4o/3jC9QbMT9xNG9FPKKzsL+qVopx9tJH7N4Lt2sJJ22dO/Fq61fbyWObNt2uWlo1r2mAwpuQ3WoP3OKk0Hc1P0+x/bDtgdDguOgY1PJk9XofbkPnSVY2O0lGPzXxL492l6aiaLSpecjymqjNhkQgGlDIcYvk3Qh8QZwBKsbLllxzr3nI57t7uktxgW08XHh++EoHYUDMYXsTjCrbcX4FzNGkD02wjtYOuU/vtqvQQvSrIFtmK8yMvlHTXT2xcccozILRYx3TyvwvQDeW6LfM/MusAk2fdF6eHwdWtP/D6zFSH7dOmSoFVig1Xh7qsBO/7sPInS5aM7lue7PMhnPcpc+IXgWf50jyS/VnXeUNDFNEBoO0vPetIMipxSlLPEDuMsdQBkEgDN6UmnCSm+mWXXGZgnZSzIo5uEksU+zb82V/H0fJy/iUZ8tjVWxkZUXjHohKXVM7H1ovrSxG0M52hlBvuXioXO8ZY9emAhBIXdkmAedsefrExymtLtZdO0QAxzX2JejEYT2nOnVGgNHuMAw+JipJYq3HvZ7vfUgrdKvKA3vBc/9e0OhmquwS2hJ+1m+mNt1Xu5xe5zfZurGsqX4sqHX5xSHXDrWLRHc/MBKLLegmvFxA91PLohYd3QzIYmKKkV9TMlxZ4nROLvc1SAw9JU9DJPJd2vXngb/179c/LFB0QYsjl4g6jXz2U07bEhEk83
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 07:43:38AM +0000, Liu, Yuan1 wrote:
>> Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking to
>> the outer loop
>> 
>> On Wed, May 20, 2026 at 05:34:53AM -0400, Yuan Liu wrote:
>> >Move the overlap memmap initialization check from memmap_init_range()
>> >to memmap_init(), and replace the per-PFN check with a memblock-based
>> >check.
>> 
>> The description is a little simple.
>> 
>> Even I know the purpose, I feel confused at the first glance.
>
>Thanks for the review. 
>I will try to rephrase it and provide a clearer description in the next version.
> 
>> >
>> >Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> >Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> >---
>> > mm/mm_init.c | 29 +++++------------------------
>> > 1 file changed, 5 insertions(+), 24 deletions(-)
>> >
>> >diff --git a/mm/mm_init.c b/mm/mm_init.c
>> >index f9f8e1af921c..24e103a402b0 100644
>> >--- a/mm/mm_init.c
>> >+++ b/mm/mm_init.c
>> >@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long pfn,
>> int nid)
>> > 	__init_deferred_page(pfn, nid);
>> > }
>> >
>> >-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped
>> init */
>> >-static bool __meminit
>> >-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>> >-{
>> >-	static struct memblock_region *r __meminitdata;
>> >-
>> >-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
>> >-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
>> >-			for_each_mem_region(r) {
>> >-				if (*pfn < memblock_region_memory_end_pfn(r))
>> >-					break;
>> >-			}
>> >-		}
>> >-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
>> >-		    memblock_is_mirror(r)) {
>> >-			*pfn = memblock_region_memory_end_pfn(r);
>> >-			return true;
>> >-		}
>> >-	}
>> >-	return false;
>> >-}
>> >-
>> > /*
>> >  * Only struct pages that correspond to ranges defined by
>> memblock.memory
>> >  * are zeroed and initialized by going through __init_single_page()
>> during
>> >@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long size,
>> int nid, unsigned long zone
>> > 		 * function.  They do not exist on hotplugged memory.
>> > 		 */
>> > 		if (context == MEMINIT_EARLY) {
>> >-			if (overlap_memmap_init(zone, &pfn))
>> >-				continue;
>> > 			if (defer_init(nid, pfn, zone_end_pfn)) {
>> > 				deferred_struct_pages = true;
>> > 				break;
>> >@@ -956,6 +932,7 @@ static void __init memmap_init(void)
>> > 	int i, j, zone_id = 0, nid;
>> >
>> > 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
>> {
>> >+		struct memblock_region *r = &memblock.memory.regions[i];
>> > 		struct pglist_data *node = NODE_DATA(nid);
>> >
>> > 		for (j = 0; j < MAX_NR_ZONES; j++) {
>> >@@ -964,6 +941,10 @@ static void __init memmap_init(void)
>> > 			if (!populated_zone(zone))
>> > 				continue;
>> >
>> >+			if (mirrored_kernelcore && j == ZONE_MOVABLE &&
>> >+			    memblock_is_mirror(r))
>> >+				continue;
>> >+
>> 
>> So you have figured out the memory layout of mirror memory?
>> 
>> Would you mind elaborate?
>
>I have a Xeon server, collected mirror memory layout information as below by using follow changes:
>
>int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
> {
>-       if (!mirrored_kernelcore)
>+       int ret;
>+       phys_addr_t end = base + size - 1;
>+
>+       pr_info("memblock_mark_mirror: base=%pa, size=%pa, mirrored_kernelcore=%d\n",
>+               &base, &size, mirrored_kernelcore);
>+
>+       if (!mirrored_kernelcore) {
>+               pr_info("memblock_mark_mirror: mirrored_kernelcore not enabled, skipping\n");
>                return 0;
>+       }
>
>        system_has_some_mirror = true;
>
>-       return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_MIRROR);
>+       ret = memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_MIRROR);
>+       pr_info("memblock_mark_mirror: marked [%pa-%pa] as MIRROR, ret=%d\n",
>+               &base, &end, ret);
>+       return ret;
> }
>
>Here is the detailed layout information:
>

Thanks for the detailed output.

After some investigation, I got two things to discuss here:

  * current mirror memory would disable memmap defer init
  * confirm the mirror memory layout and may simplify handling

Before discussion, let me mark the key point in the output below.

>Case 1: efibootmgr -m t -M 0
>Enable mirror memory below 4GB, and no mirror memory above 4G
>
>=== zoneinfo summary ===
>node   zone       start_pfn    end_pfn      start_addr         end_addr    
>------ ---------- ------------ ------------ ------------------ -------------
>0      DMA        0x1          0xfff        0x1000             0xffffff
>0      DMA32      0x1000       0xfffff      0x1000000          0xffffffff
>0      Normal     0x100000     0x7fbffff    0x100000000        0x7fbfffffff
>0      Movable    0x140000     0x7fbffff    0x140000000        0x7fbfffffff

(1) Normal and Movable zone end with the same address, so overlapped.

>1      Normal     0x7fc0000    0xff7ffff    0x7fc0000000       0xff7fffffff
>1      Movable    0x8000000    0xff7ffff    0x8000000000       0xff7fffffff

The same as (1).

>
>node  start                end                  size              flags      mirror   pfn_range
>----  -------------------- -------------------- ------------ --------------- -------- ------------------ 
>0     0x0000000000001000   0x000000000009dfff   0x000000000009d000 0x2        yes      0x1-0x9e
>0     0x000000000009f000   0x000000000009ffff   0x0000000000001000 0x2        yes      0x9f-0xa0
>0     0x0000000000100000   0x0000000066416fff   0x0000000066317000 0x2        yes      0x100-0x66417
>0     0x00000000777ff000   0x00000000777fffff   0x0000000000001000 0x2        yes      0x777ff-0x77800
>0     0x0000000100000000   0x000000013fffffff   0x0000000040000000 0x2        yes      0x100000-0x140000

(2) You mentioned no mirror memory above 4G. If my understanding is correct, 4G's
address is 0x100000000. So why this range is marked mirror? Is there some
limitation for this?

>0     0x0000000140000000   0x0000007fbfffffff   0x0000007e80000000 0x0        no       0x140000-0x7fc0000
>1     0x0000007fc0000000   0x0000007fffffffff   0x0000000040000000 0x2        yes      0x7fc0000-0x8000000
>1     0x0000008000000000   0x000000ff7fffffff   0x0000007f80000000 0x0        no       0x8000000-0xff80000
>
>Case 2: efibootmgr -m t -M 25
>Enable mirror memory below 4GB, and put 25% percentage memory to mirror above 4GB
>
>=== zoneinfo summary ===
>node   zone       start_pfn    end_pfn      start_addr         end_addr
>------ ---------- ------------ ------------ ------------------ -----------
>0      DMA        0x1          0xfff        0x1000             0xffffff
>0      DMA32      0x1000       0xfffff      0x1000000          0xffffffff
>0      Normal     0x100000     0x603ffff    0x100000000        0x603fffffff
>0      Movable    0x20c0000    0x603ffff    0x20c0000000       0x603fffffff

The same as (1).

>1      Normal     0x6040000    0xc03ffff    0x6040000000       0xc03fffffff
>1      Movable    0x8040000    0xc03ffff    0x8040000000       0xc03fffffff

The same as (1).

>
>node  start                end                  size              flags      mirror   pfn_range
>----  -------------------- -------------------- ------------ ---------- -------- ------------------
>0     0x0000000000001000   0x000000000009dfff   0x000000000009d000 0x2        yes      0x1-0x9e
>0     0x000000000009f000   0x000000000009ffff   0x0000000000001000 0x2        yes      0x9f-0xa0
>0     0x0000000000100000   0x0000000066416fff   0x0000000066317000 0x2        yes      0x100-0x66417
>0     0x00000000777ff000   0x00000000777fffff   0x0000000000001000 0x2        yes      0x777ff-0x77800
>0     0x0000000100000000   0x00000020bfffffff   0x0000001fc0000000 0x2        yes      0x100000-0x20c0000
>0     0x00000020c0000000   0x000000603fffffff   0x0000003f80000000 0x0        no       0x20c0000-0x6040000
>1     0x0000006040000000   0x000000803fffffff   0x0000002000000000 0x2        yes      0x6040000-0x8040000
>1     0x0000008040000000   0x000000c03fffffff   0x0000004000000000 0x0        no       0x8040000-0xc040000
>
>Case 3: efibootmgr -m f -M 25
>Disable mirror memory below 4GB, and put 25% percentage memory to mirror above 4GB
>
>=== zoneinfo summary ===
>node   zone       start_pfn    end_pfn      start_addr         end_addr
>------ ---------- ------------ ------------ ------------------ ------------
>0      DMA        0x1          0xfff        0x1000             0xffffff
>0      DMA32      0x1000       0xfffff      0x1000000          0xffffffff
>0      Normal     0x100000     0x60bffff    0x100000000        0x60bfffffff
>0      Movable    0x20c0000    0x60bffff    0x20c0000000       0x60bfffffff
>1      Normal     0x60c0000    0xc0bffff    0x60c0000000       0xc0bfffffff
>1      Movable    0x80c0000    0xc0bffff    0x80c0000000       0xc0bfffffff
>
>node  start                end                  size              flags      mirror   pfn_range
>----  -------------------- -------------------- ------------ ---------- -------- ------------------
>0     0x0000000000001000   0x000000000009dfff   0x000000000009d000 0x0        no       0x1-0x9e
>0     0x000000000009f000   0x000000000009ffff   0x0000000000001000 0x0        no       0x9f-0xa0
>0     0x0000000000100000   0x0000000066416fff   0x0000000066317000 0x0        no       0x100-0x66417
>0     0x00000000777ff000   0x00000000777fffff   0x0000000000001000 0x0        no       0x777ff-0x77800
>0     0x0000000100000000   0x00000020bfffffff   0x0000001fc0000000 0x2        yes      0x100000-0x20c0000
>0     0x00000020c0000000   0x00000060bfffffff   0x0000004000000000 0x0        no       0x20c0000-0x60c0000
>1     0x00000060c0000000   0x00000080bfffffff   0x0000002000000000 0x2        yes      0x60c0000-0x80c0000
>1     0x00000080c0000000   0x000000c0bfffffff   0x0000004000000000 0x0        no       0x80c0000-0xc0c0000

#1 mirror memory would disable memmap defer init

  I hacked my kernel to behave like Case 2 here, and found defer_init is
  skipped.
  
  The reason is from (1): both Normal and Movable zone ends at the same address

  But what happened is tricky:

    * calculate_node_totalpages() count more space to node_spanned_pages
    * defer_init() would skip low zone by check end_pfn with pgdat_end_pfn(),
      which is far away from real value

  The node_spanned_pages in calculate_node_totalpages() is easy to fix:

  diff --git a/mm/mm_init.c b/mm/mm_init.c
  index db5568cf36e1..8f353d8dde3b 100644
  --- a/mm/mm_init.c
  +++ b/mm/mm_init.c
  @@ -1334,7 +1334,7 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
   						unsigned long node_start_pfn,
   						unsigned long node_end_pfn)
   {
  -	unsigned long realtotalpages = 0, totalpages = 0;
  +	unsigned long realtotalpages = 0;
   	enum zone_type i;
   
   	for (i = 0; i < MAX_NR_ZONES; i++) {
  @@ -1364,11 +1364,10 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
   		zone->present_early_pages = real_size;
   #endif
   
  -		totalpages += spanned;
   		realtotalpages += real_size;
   	}
   
  -	pgdat->node_spanned_pages = totalpages;
  +	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
   	pgdat->node_present_pages = realtotalpages;
   	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
   }

  But after this, defer_init() is over working. It starts defer from
  ZONE_NORMAL, which is not the last zone.

  To fix this, let's see below.

#2 confirm mirror memory layout and may simplify handling

  In [1], I listed three possible cases for mirror memory layout. According to
  the test from Yuan and the output here, case C seems not possible.

  [1]: https://lkml.org/2026/4/24/90

  But case A is not shown from the output. I expect the Case 1 here would
  behave like case A, but as I mentioned at (2), I don't know why memory above
  4G is still mirror memory when it says "no mirror memory above 4G". 

  At lest, we could conclude:

     ZONE_MOVABLE would only sits in ZONE_NORMAL without interleave

  With this knowledge, we may simplify current handling:

     Remove the possible overlapping between ZONE_NORMAL and ZONE_MOVABLE

  As ZONE_MOVABLE only sits in ZONE_NORMAL without interleave, we see actually
  these two zones are not overlapped. But we see (1) above, because we don't
  adjust ZONE_NORMAL if mirrored_kernelcore.

  So we can simply do this and these two zones are not overlapped.

  diff --git a/mm/mm_init.c b/mm/mm_init.c
  index 8f353d8dde3b..16cc42c3ad12 100644
  --- a/mm/mm_init.c
  +++ b/mm/mm_init.c
  @@ -1170,8 +1170,7 @@ static void __init adjust_zone_range_for_zone_movable(int nid,
   				arch_zone_highest_possible_pfn[movable_zone]);
   
   		/* Adjust for ZONE_MOVABLE starting within this range */
  -		} else if (!mirrored_kernelcore &&
  -			*zone_start_pfn < zone_movable_pfn[nid] &&
  +		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
   			*zone_end_pfn > zone_movable_pfn[nid]) {
   			*zone_end_pfn = zone_movable_pfn[nid];

  And after this, the problem left above for memmap defer_init is solved. Only
  last zone would do defer_init.

  And after this, other special handling for mirror memory could be removed,
  including absent page calculation and the overlap_memmap_init() in this patch.

  Two of the below change I have done boot test. And it looks good.

  Remove absent pages calculation:

  diff --git a/mm/mm_init.c b/mm/mm_init.c
  index 16cc42c3ad12..a154053a37db 100644
  --- a/mm/mm_init.c
  +++ b/mm/mm_init.c
  @@ -1219,40 +1219,11 @@ static unsigned long __init zone_absent_pages_in_node(int nid,
   					unsigned long zone_start_pfn,
   					unsigned long zone_end_pfn)
   {
  -	unsigned long nr_absent;
  -
   	/* zone is empty, we don't have any absent pages */
   	if (zone_start_pfn == zone_end_pfn)
   		return 0;
   
  -	nr_absent = __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
  -
  -	/*
  -	 * ZONE_MOVABLE handling.
  -	 * Treat pages to be ZONE_MOVABLE in ZONE_NORMAL as absent pages
  -	 * and vice versa.
  -	 */
  -	if (mirrored_kernelcore && zone_movable_pfn[nid]) {
  -		unsigned long start_pfn, end_pfn;
  -		struct memblock_region *r;
  -
  -		for_each_mem_region(r) {
  -			start_pfn = clamp(memblock_region_memory_base_pfn(r),
  -					  zone_start_pfn, zone_end_pfn);
  -			end_pfn = clamp(memblock_region_memory_end_pfn(r),
  -					zone_start_pfn, zone_end_pfn);
  -
  -			if (zone_type == ZONE_MOVABLE &&
  -			    memblock_is_mirror(r))
  -				nr_absent += end_pfn - start_pfn;
  -
  -			if (zone_type == ZONE_NORMAL &&
  -			    !memblock_is_mirror(r))
  -				nr_absent += end_pfn - start_pfn;
  -		}
  -	}
  -
  -	return nr_absent;
  +	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
   }

  And remove overlap_memmap_init() directly:

  diff --git a/mm/mm_init.c b/mm/mm_init.c
  index a154053a37db..01c6920fefa1 100644
  --- a/mm/mm_init.c
  +++ b/mm/mm_init.c
  @@ -905,8 +905,8 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
   		 * function.  They do not exist on hotplugged memory.
   		 */
   		if (context == MEMINIT_EARLY) {
  -			if (overlap_memmap_init(zone, &pfn))
  -				continue;
   			if (defer_init(nid, pfn, zone_end_pfn)) {
   				deferred_struct_pages = true;
   				break;

  So if we only have memory layout for mirror memory as Yuan shows, we may
  simplify the code to some extend.

  Hope I don't misunderstand the case. Looking for some insights from others.

-- 
Wei Yang
Help you, Help me

