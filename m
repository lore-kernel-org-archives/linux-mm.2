Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD4C606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=rARFaJXq
Received: by kanga.kvack.org (Postfix)
	id 44FC56B00EF; Sat, 14 Nov 2026 02:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9036B05B0; Sat, 14 Nov 2026 02:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2C16B05B1; Sat, 14 Nov 2026 02:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 010556B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:50:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DE921C39BA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:50:14 +0000 (UTC)
X-FDA: 85432951548.15.F9D5798
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id AA5EB40004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:50:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rARFaJXq;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794642612;
	b=xDiTJ7K17dcfF3zu/m0M/pIa0PoufYNaScHc4BN6FoIXrDG/unxijul9fOgGpj5vICDQCT
	utru1a5+Gg/jBM7zCqQoL1+169Ja3rmDdCuKL2eEP5WbUrHdUXYs+YHWP3SUpz5TNztst1
	zpsGsJebI4nc7uu+jD5hswUGu/5ELPs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rARFaJXq;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794642612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGbHDC4e4qa3gSIc5H3tZOXqH9VLSX3BMg1aP/6Q428=;
	b=0A7QkCKoH5dlq81kxitBXp5T+eFGYbqsrKXKaPZM0Qh9mWHkP4e3MsYakurvW3AYWBGe8I
	WaY6ozP7bjjHLLiT3wik7U5DPwe7mi5E+Yc2naMcTETNw84DEQysl4oyQTZgCyLr1pA+h1
	iHne5TZaWCwRlpZ7xW18gC3ArAEDxVM=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-54f873cbe2aso27671691cf.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794642612; x=1795247412; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cGbHDC4e4qa3gSIc5H3tZOXqH9VLSX3BMg1aP/6Q428=;
        b=rARFaJXqpPqjtwZBn+At9eu296mXD+SBAxvb8keGYhc7UiIjY21x5tnkr9o9ZJrNhR
         pJC9GjwbdeAXgoIPRlrMtXa/mpemLqy5CbAYnxItgRAbyEfLj8Hv8L1UvG8pvXlW6IYJ
         Gi0crN0pj1PaTuDeVGwyxF9J61JJekTuUKtzqW/U/MDfW4T2vmy4d/cC1OiI37jOZaO9
         wNh6Hb+lG2GWLECcDrwU+58YTv3HW317YcZ67Ecqr+dhIKZnnyri7VDLUQ8ew3KtuRp3
         LVtXJHpc/CrgM7wRnuv09++KxWvIbGJKfJMpL71B18XY2s1ThMw0qpd+plokvsfIF1rS
         7p/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794642612; x=1795247412;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cGbHDC4e4qa3gSIc5H3tZOXqH9VLSX3BMg1aP/6Q428=;
        b=X49nwa0B9wSzyXYVixwMNjwTaj7lWmcudYmtGsupM4W4HXZ6FkdFBU7i93vWST8Edl
         LCJhbYhmb1RlsKxLr8VEb1jFJE4WrV4wY6YPzQ+rTtmDh3gn74kgp4kYbdrM0fnyPDQY
         rfgujRcll5Lip54l7em5yX6odO8ZgOOEayPzocc+YnGsDmpQ5N6BHENEfu60KhfGPGFj
         /GuNzsFG+e8mv1/b+YeE+OkKOMaP1Gl03felcNtyHV8rYwWO8Nrg1pTG+e3RR5d8DgTn
         9mQlRTLrZBhJY2GBbXFnfOWUGvUpbA3hmJf7ctxe5RUXNyF2NkTL5BrLAZWeRtf/AFZU
         E1PQ==
X-Forwarded-Encrypted: i=1; AL+hErE0f7ey6kQ8kV520bL8Pyl0QcEglHeBs9AAox4qOHnvsiVTKza/w58KlzjPGJswEqdZ6n9+dnvddw==@kvack.org
X-Gm-Message-State: APuU4Z9WMBnbyzUKmlXlf8P9RYJprkSQmx+nt8zOIeELZVK7aBB3JAqf
	xxCWlEcxgnwq25mgaJG+gE3IbCe6Y3ES7dxbAK/GCtVCsBLre9An9O3xnYTPaIMXgD8=
X-Gm-Gg: AYBFou1QfGPemOf+mtOcHi6na/dXYMUaIHpfmEJpiTmDtpP8LeSWiUBXUafQrnzxVX7
	w+ozDpYe1nfdsq/i/FQQo5CljYKcyqI/HtgWZ29W1JwWcvQCk00Ev/AH7gGt0JRBucH1mABMjeK
	cvIFnM83ILhDN9goYQhrx+7p17IIL1lC91QQTUCezZSG8zsismdaWV/cq+6dOSKpuBq//XnWfbA
	Yo03fCKr/pZddjcbMOLItDBjKxV0DDW1e/bWzXUDxRNju7uxKujA2Z17NE11YVrLIlCb/v2HG/H
	wPyopeEXxlZDLsoPqPrpHMTtQDgcnNCkuSBfvpWSqDd11kkt6+ptHjQZ27hX4XyH3/oMdx5zup8
	1RSahbUmevr0ODExdVwnJyg9PpWoJQllzQ63LjS/LuTlP4AVR8PZrG6a3MhT9tBqZMjLr+A0DHD
	oARacKgVmsADwf0xewKSZgRStx9onVGNrVaSSIdP1DomevC3iUwOjRkNrQg+SwmdcPuSdo8Kz22
	GMEAAycJhWRldcUuAi0D9i/+W3rVslRbTdEPq9OSPDEJLglWNItKB3apQGxG9icJzEJPRZWJI0D
	Ik3rL4Ex86WmcZK69YSLojnKNmJyYq0eYoJgonG9o5CNyzRAtkcXkRQX7KjCPHy0G8cDcYSPOWs
	RW82mnUM=
X-Received: by 2002:a05:622a:4890:b0:536:6378:c80d with SMTP id d75a77b69052e-55ac7d4f0e5mr76447071cf.32.1794642611571;
        Fri, 13 Nov 2026 23:50:11 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d445d1sm38109806d6.8.2026.11.13.23.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:50:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 20/22] PM: hibernate: size the image from common memory
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: sashiko-reviews@lists.linux.dev
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 kernel-team@meta.com, linux-serial@vger.kernel.org, damon@lists.linux.dev, 
 linux-cxl@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, 
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
 rdunlap@infradead.org, gregkh@linuxfoundation.org, rafael@kernel.org, 
 dakr@kernel.org, johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, 
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, 
 linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, 
 hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
 sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
 xu.xin@linux.dev, chengming.zhou@linux.dev, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <sashiko-outbox-214264@kernel.org>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-21-gourry@gourry.net>
 <sashiko-outbox-214264@kernel.org>
Date: Sat, 14 Nov 2026 02:50:09 -0500
Message-Id: <179464260972.482102.15351839494267219366.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 9gdiot7q4qat3cn5zufbr1h9unnbka6z
X-Rspamd-Queue-Id: AA5EB40004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794642612-12181
X-HE-Meta: U2FsdGVkX19qN8pQXGL7K8pf34HaSxPoINeICMPKp/jdqepfWGjC0BkKxkIRjfrDFVNykkTUDtrWEDLd6o8OnD2n6X5oIiGmjOzE2RuXPuzR8zQInspba/nJPeVOyxitnOnOfSiRYnzoYPSFFZ17U3nmKDNZfVWlEpBDbdzhWSQPqR5JHV0phIFiBmw/Me83hbV0AILva3Y3P/wRRsfGTnwwcu0u4ksrf0eTcCHZu6MeDmtHSLyx7RpA5fiAjCGAgFap9qPEPdiA6M71b4m2iec8xtSgpY0yVAsMG8/5oBUwQ/FZkVYRDUgdmEk7fK4waK3HDR5nwpSxE4p5b3gRbowIB5ChlULN6HIz612ThYRO9aRSa5BR+9P+YGWV7yRCA+8NCbyxrXtPz6yPIB3YrRbpVbVlYngSGZqlB6kTxyR5TVsjY06GhcbCE1aEXkFkOVuQ+WhMMPIWK+soIUUA+t260th25hzn/5x1RDLoH7sjT4sER4RPWqd9ZrBXJVaFDo4c8pExdWA0dpq6a4CXO8E9DULImBcIlf8YWOa9YXnxVKcncokOEaCQ0au5fN8Q1k1GuMxS0Q3Nzt2OFsQOcZ69qIVp8b/c1b9g7o3KVsygNc2ov0IwSE2wmIWv9YabEMWDlXS/7l+3f1YUm7KLNGEExUHf45fo0+X4gCglJJ8R/BX0Xx/I8Q0gmg2afvorh0SUumuWDkbyfCG3d9oHcv+OLbMTeYIpBNH6d0P/kvmqev2aSk7029lwIhOV33B551GER+wwVcyTSt77Vi4XDVLEhsHHi+zJ4T1mvQvtlQezqVTwS/MxYngCCAJxMK0N4i1eonPxKxOSr+sC1+gNZZwHZ1PEziUUYVYjFUO8F27uL/LyVAH13atMCwgw48Xpk8Oz0d6u4GDVU4XdGygd5ufIHmHbIjyRfcHcpkG96mp/hc9gULDksUnFXsAd7iqG+MxwlZ1s8ifElGyn8hX
 c3QJbGg5
 1MiYE7K4FVaZgUr4SSKcAcJ7523lvHK6WvhvpEz+ajxhM/oauHcRX8i1aDQUhlP6Bn7psSqXkBlpXW+jSK0KB+2gPUUxHShkOS2nI/zhtsXg9uA6HMyIZ/8dauUjrULifTb+qI+Do00iiUIht6Lw4BoGPZe7FYmNiQCP4l3HeMYwLwoZqGNk4UM3iU9nHxGD0YLfG0SSpYhg/A6y0Td6x8+jkJUUV0irgYtfDo6bc/u3mddCoEWimlhQAy1xAn1ciip5Tfe7QWi5X7PzXiKXhRcz0WSNYN8Ba+net+CIWscQAYz9zdUuXsaehCFWRWJ3Q/gKByTOdKiR7XTDqzge3vzbtaD5rXSKYUYVw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-14 07:34 +0000, sashiko-bot@kernel.org wrote:
> > @@ -2011,9 +2013,10 @@ static int enough_free_mem(unsigned int nr_pages, unsigned int nr_highmem)
> >  	struct zone *zone;
> >  	unsigned int free = alloc_normal;
> >  
> > -	for_each_populated_zone(zone)
> > +	for_each_populated_zone_state(zone, N_MEMORY_COMMON) {
> >  		if (!is_highmem(zone))
> >  			free += zone_page_state(zone, NR_FREE_PAGES);
> > +	}
> >  
> >  	nr_pages += count_pages_for_highmem(nr_highmem);
> >  	pr_debug("Normal pages needed: %u + %u, available pages: %u\n",
> 
> [Severity: Medium]
> Should count_free_highmem_pages() also iterate over N_MEMORY_COMMON zones?
> 
> On CONFIG_HIGHMEM systems, enough_free_mem() calls count_pages_for_highmem(),
> which calls count_free_highmem_pages():
> 
> kernel/power/snapshot.c:count_free_highmem_pages() {
> 	struct zone *zone;
> 	unsigned int cnt = 0;
> 
> 	for_each_populated_zone(zone)
> 		if (is_highmem(zone))
> 			cnt += zone_page_state(zone, NR_FREE_PAGES);
> 
> 	return cnt;
> }
> 
> Because count_free_highmem_pages() still sums all populated zones,
> enough_free_mem() continues to count free highmem pages on non-common nodes as
> available room for the image, undercounting the normal pages needed to back
> highmem copies.
> 
> In addition, alloc_highmem_pages() and prepare_highmem_image() use
> count_free_highmem_pages() to bound loops that call alloc_image_page() or
> alloc_page() with __GFP_HIGHMEM and pass the returned page directly to
> page_to_pfn() or swsusp_page_is_free() without a NULL check, which can
> dereference NULL when highmem on N_MEMORY_COMMON nodes is exhausted while
> non-common nodes still have free highmem pages.
> 

HIGHMEM can't exist on a private node.  Private nodes require NUMA which
require 64-bit.  As far as I know HIGHMEM is 32-bit only.

Trivial to update though, so for consistency i can add it. 

-- 

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1291,16 +1291,17 @@ static void mark_free_pages(struct zone *zone)
 /**
  * count_free_highmem_pages - Compute the total number of free highmem pages.
  *
- * The returned number is system-wide.
+ * Only common memory counts, since image pages come from common memory.
  */
 static unsigned int count_free_highmem_pages(void)
 {
        struct zone *zone;
        unsigned int cnt = 0;

-       for_each_populated_zone(zone)
+       for_each_populated_zone_state(zone, N_MEMORY_COMMON) {
                if (is_highmem(zone))
                        cnt += zone_page_state(zone, NR_FREE_PAGES);
+       }

        return cnt;
 }

