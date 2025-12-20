Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B61EE668AC
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 00:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C2E6B0088; Fri, 19 Dec 2025 19:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002F56B0089; Fri, 19 Dec 2025 19:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51056B008A; Fri, 19 Dec 2025 19:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D01756B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:58:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D681C0457
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:58:42 +0000 (UTC)
X-FDA: 84238039284.09.C1F6A30
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id 25D7740004
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:58:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bVJ4Wr3M;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766192320; a=rsa-sha256;
	cv=none;
	b=zozPVyryI8l3y5+SJO2pCT+HgYcFcgtQPKWqMUFYsoHICKSajbmVNY7eCQ6QNEzBFV1S2r
	Nf0mGE0hIUBCbZV/ZxhkX7XbOVDoGc/Xiek+cmq47QUSR3ocMPptgYX/H1foAA2JncLpsQ
	kh6CQHbjixymSvv0jELwObsC450K5Lo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bVJ4Wr3M;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766192320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmHwGQf18ijS41p6mfFhQcrUixQzLRzSixBXG5dU4lU=;
	b=HgU+A4OtlbNZYAdyqjVGGgckjCIsrGrAd3s6ST8nADPFmpwLMQachiCIRa+3odbXZqBC7H
	ZlKA1LYF7loLo7ZdUZtthwieRyg0yOFInOW1in53O26AmFa+StZHc12G6AAB/Mo/XtmLAV
	zKSbBi6CeWDHVYXgF24tITZP3YaQ8C0=
Date: Fri, 19 Dec 2025 16:58:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766192317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BmHwGQf18ijS41p6mfFhQcrUixQzLRzSixBXG5dU4lU=;
	b=bVJ4Wr3MVaABvgDeKaqo7NNNZVp+khl0wXKX4pY8nlxEGr6vGK/1LEusvywoYSKQy0ehl0
	R46y804hOIrqjM+O8KupKBQg9jeFPxKUBeV81S2u6cN4mEtP9sW88I+TQN3VoWW6K1aemG
	obUOK/Xybecz3aHbDAH7h5y7qvaxW5M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 14/28] mm: mglru: prevent memory cgroup release in
 mglru
Message-ID: <id7sx5zsl6a7v7aoy2p4r6puxkvtlib6jlqv3rnt7pegbucbhx@5plupkfwo6en>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <ab60b720d6aef1069038bc4c52d371fb57eaa6e8.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMsQPjBtYtVWjwf@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUMsQPjBtYtVWjwf@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 25D7740004
X-Rspamd-Server: rspam04
X-Stat-Signature: xeztaig378gqcoggwue4jbds5irwu139
X-HE-Tag: 1766192319-695179
X-HE-Meta: U2FsdGVkX1/NLTnWGKFdP6pP2GVFX2d+s1oEWV5pthJbvRCsLClJqnb+TO0NyCci+PVikK4wS2XHWV010sfDLPct68znFUa3zvcJBqsk6njJIyADqLVNsxFFGfJvkj60f4VaHFB1ANYfWZNjjJF/CmvkN3ooNPQZI3gAIKMX0clY2KmhY8jAwsQ0z66kTxuy3DjyZamUDVCc6zotJTlmiesBv/oxJ75ihuO0/o71qy443u43En1o1ncuZZghwgZRokrllrkFqh9f+mnkX0ezWXOG8cuwZjxu1h0FwG4YqbJidyyezNqUE/LtRaYeKiz1WOIrOw3lRqNxMKeadD0yqQ84B6rKnXt7f/AYwhSQiRuOn/JgHTMwKeIfIoKCzZ4hFSqJHIslXT8Xvu+4BOKKCD+Rmo12RoER+aeJlJn1mPXyFShrbrgkCeAO8+q9+EqfyjdB8VBexzkBzi4dYSKSNE1F9A/7JSXFFIAaeUvWSOM36gYrlinjN0mm3ya0xzVLpp5mg/+HkAvUda7kjnm2kz1lli8L2ikCzYfuDobKikP0mm3nuvU8NFSUMTHaW4DOe0JPNDNSnWyv2eJa36llTTJwiR3y5bTSREq3X0zGjnLiyDPGfAV7g6iM/bH+keYE8CjzgWUYNX5KJhdnHqSmkcOdtXggshD5XS3/XmMMFvHMGEufnQkB23nRxxWYZxoVKH3L3woniNp5zvmEPkUjhSXy7MxDqcts9CbJ2Zq1tQAppkbZ6ckXzPTM8LmF4pJU2Ixxe40RNuk3ARbDia/0ZIyZT96M4Pm88XMvjH/3FNRTlwizUtLicP953UUdkcYNeyLHaNEFDYgGKRQLg5ffKrf0GI01L5EjK1hsl0MX0RCEbdwUM3FEjNfh4ch3IRYe8diSxUtz3GVsDNa6eGea8Butm+E5mA0S2TsHIL4GnrnuZ1HbXTexCgLpdqVSBIM5gUuKYvPxSSw8jU3uNub
 1I2cgdzA
 LKMgGsF6SQAm5T1hFgab04yzkMqEoYPdubmBptxQd2QKh+nRNQFOZ4qr5ngYjrBQZnbRO53PIgEUzn8niqSBbe1WQSTQKmmUoYeJvgkV4ShS4RVq9JKc6TKj1ZSssURqpmQkycqmg1+oshf+RjijyxskrTQD7j9ScS1EpVLx/K9YNHsqOIbsuQFSZ18GOjzQIFCbmhRyKqnfqUAA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 05:18:40PM -0500, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:38PM +0800, Qi Zheng wrote:
> > @@ -4242,6 +4244,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
> >  		}
> >  	}
> >  
> > +	rcu_read_lock();
> > +	memcg = folio_memcg(folio);
> > +	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> > +	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
> > +	gen = lru_gen_from_seq(max_seq);
> > +	mm_state = get_mm_state(lruvec);
> > +
> >  	arch_enter_lazy_mmu_mode();
> >  
> >  	pte -= (addr - start) / PAGE_SIZE;
> > @@ -4282,6 +4291,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
> >  	if (mm_state && suitable_to_scan(i, young))
> >  		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
> >  
> > +	rcu_read_unlock();
> > +
> >  	return true;
> 
> This seems a bit long to be holding the rcu lock. Maybe do a get and a
> put instead?

This function is called under ptl lock, so at least for non-RT kernels,
the preemption is disabled across the function. Anyways no strong
opinion either way.

