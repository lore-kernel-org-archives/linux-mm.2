Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA026CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 17:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D348E000F; Thu, 16 Oct 2025 13:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DE78E0002; Thu, 16 Oct 2025 13:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EF58E000F; Thu, 16 Oct 2025 13:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D680E8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:26:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AA351A0359
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:26:29 +0000 (UTC)
X-FDA: 84004656498.18.E67A362
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id D3A9F10000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:26:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d+qzKFQJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ks+/ERJZ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d+qzKFQJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ks+/ERJZ";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760635587; a=rsa-sha256;
	cv=none;
	b=WUSxjd58ZF0/WEVdrlJyFCmkxbtKyJzzs4nArJ9Tdmve+FR36I1I0Ozvy1eLnDcWgN/sXf
	6Z8+EjzO71myiNSoCoS2UFUOjAfhXsAoajOUhyNYM+EcXubGf4fJ9R4jOLrCetklGo0PWv
	VYfIG2vK2+oK8MAbG6d3Tig0EoQ7eO0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d+qzKFQJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ks+/ERJZ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d+qzKFQJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ks+/ERJZ";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760635587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zXvoYWF7Bpk85Umq25D609w+AL6Bq8FAkD25cWfAdkA=;
	b=nOumZ4w0dagZB0K8KZhNTWpqBkCvigMmUBNGmBhFmZF9oXXopsEW4m759xMOhyCacMl2TK
	pji4kVq2xUlqR6nJhwBqrSPjCPK+xI64zaBTlUXWG9JCu/O8jE0dDRa9TSn3B8Uhp82KWU
	E1V5X3snMN3or0775Dp48ixuCeXPUOo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F48521EE9;
	Thu, 16 Oct 2025 17:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760635585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXvoYWF7Bpk85Umq25D609w+AL6Bq8FAkD25cWfAdkA=;
	b=d+qzKFQJQzjKGr9+HnfXiyk6tgpBI2j0Ky9AZ9+flmWAuoSe48MwQGhGhOW2HD3DBE2Hel
	8ix2+a7kEyfgGf64u8NHWFto4EwBGznIZk1r/aOqGb4jFH0hd3c0pF6qbjZFmFytcjRbd6
	rJaWvl57WyNCyGfM9o+h3Pm4JqT2eQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760635585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXvoYWF7Bpk85Umq25D609w+AL6Bq8FAkD25cWfAdkA=;
	b=ks+/ERJZssQdB4X2GJF0UoE8Regkg/naRJm5IK9lkJRuIkF1C3dXc0Q3R5LVm/lrswTEKA
	IuTh9/VaORSBK4Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760635585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXvoYWF7Bpk85Umq25D609w+AL6Bq8FAkD25cWfAdkA=;
	b=d+qzKFQJQzjKGr9+HnfXiyk6tgpBI2j0Ky9AZ9+flmWAuoSe48MwQGhGhOW2HD3DBE2Hel
	8ix2+a7kEyfgGf64u8NHWFto4EwBGznIZk1r/aOqGb4jFH0hd3c0pF6qbjZFmFytcjRbd6
	rJaWvl57WyNCyGfM9o+h3Pm4JqT2eQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760635585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXvoYWF7Bpk85Umq25D609w+AL6Bq8FAkD25cWfAdkA=;
	b=ks+/ERJZssQdB4X2GJF0UoE8Regkg/naRJm5IK9lkJRuIkF1C3dXc0Q3R5LVm/lrswTEKA
	IuTh9/VaORSBK4Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3183C1340C;
	Thu, 16 Oct 2025 17:26:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BYuUCsEq8WgoLwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 16 Oct 2025 17:26:25 +0000
Message-ID: <1ff90274-bc74-458a-8c73-7ac8d45e6198@suse.cz>
Date: Thu, 16 Oct 2025 19:26:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka:b4/sheaves-for-all] [slab] de840681a1:
 BUG:using_smp_processor_id()in_preemptible
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org
References: <202510161416.b7adda58-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202510161416.b7adda58-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D3A9F10000C
X-Stat-Signature: 6ch69177c4npjs57et6m4u3go96145p9
X-HE-Tag: 1760635586-77584
X-HE-Meta: U2FsdGVkX1/wEIosEvwfJ3/5bHb8xruXF3VAha7bnCBR5lScuzvKBDJeXA4zWqwTvugdfSg93N53yDYHzkBoM9YvLwFRQaiFhRhiSL2bNg+KqKlxYVVzCyxa8aMSwUsofNkaCT5Dk7nqng3Wq89/sr40nFVMro4MjqWBuxVusoAhk8cLUIg+JTJ+yhMMpbDbrSdPQLAvHyqQ9ipeMImjKoGjlxPY2PYVlyQqcmV51S6+wqhoV3K8s7mPr/Z8H0mzyaXQv6RDqINzu/Zz1RYmPfbKT42fwpBrwAq9sa5XbSt8k3tjL+dTrYpQnXBENIyzgvte/4v6VI/nxKpyZaRCgH4kG+Xoo1mJNDqCY2mzoQz/Fzp6RBBzNeImn57yDPD5AA+ZNSLNlPstyZ8ZDom/sFPGdoW0oH+CK961JgvUXTKJf3SPoA17eW55LZHIzMgqUWDugEGKJxBgmvz0D1v5TUh+mj3/eKERrXjB9IpRE2IgNqnUJpEjQYX5qbtGcVcCIsElXxyYHX6QbghTQp5fMIGkpUP4K3+h5R11gRWNzkbWW+ga/J3B6hxw8JjMNF6HuLWiPrPtc44A5RiV5r6zzLrJmL2/mrXQ9NZUELvBLM7dXEy4ImCaTbtp2LHVzEXL8vucEYKJKPPt+I6FfBvFWu4CCX7iR9DwqEUmKy4KbJCoQwaFWe0gVdcvskOT9pwi5p6AcD9CN5LqWblFI694UyGYE2epyNF1pbPeHkvLnCv54HdxkQftoF6wUATyJPvhM2dp+7fiX1O3FGCCrbD7PRBEymNnKMSKBXjyzT3xHG5j9DuB+fWIgLKDLtJTU4kWYaI0QxFZaswfb4UdbxEvBwd8VZtEIj/cV0yCg/mtPsIoh/+7g4ciKNlY923+CP1SLLlHVzJRNNex7xu9euCk0azyVyNtZdo6Y8avY8VZo4mRxwawqD/F5ZC1b1Ou4f5WFIc86aJcCig3RIBnwov
 Z7oVrfnR
 a0Q206/EsdaU0XZ3/3OFvTyu9AZUBJuqs3HlFj0wE2urCTPCe5iAM2AsWfwvywmOKyrR3Ove37M25EdAIpBVohV8v5sBGvd1fa0gcN5W7u5CdThn3I+KuoAQovFCujuM0pyNms6N5AaRMcp1DVFZtxKpr6B5BAS7NKCNSQwNaq552u4GSquMEvUa1iEZUjfAhLcvY1Q1TolvN2U8KG0K0JX5nWFwcwAcRMNADzae8eU6WPyzr5LjS10Cb1mJi6z1kulryp7AZzQYjCU6RgUQC9AKJm0PBPsXg9sB2IVfiYD+YCChyMJzIdbCdlyFeSeQP5LxlxJpR15rY3UxXnWZP3pLpkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/25 08:08, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG:using_smp_processor_id()in_preemptible" on:
> 
> commit: de840681a162e0a5a0862e7a0b495fb34deab7ef ("slab: remove cpu (partial) slabs usage from allocation paths")
> https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all
> 
> in testcase: boot
> 
> config: i386-randconfig-002-20251015
> compiler: gcc-14
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202510161416.b7adda58-lkp@intel.com
> 

Thanks, no more disabled preemption so use the raw version as we don't
need it to be stable. Will fold this in:
----8<----
diff --git a/mm/slub.c b/mm/slub.c
index 91e1db412018..cd4b0833fb4a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1032,7 +1032,7 @@ static void set_track_update(struct kmem_cache *s, void *object,
        p->handle = handle;
 #endif
        p->addr = addr;
-       p->cpu = smp_processor_id();
+       p->cpu = raw_smp_processor_id();
        p->pid = current->pid;
        p->when = jiffies;
 }
@@ -4481,16 +4481,8 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
        pc.orig_size = orig_size;
        freelist = get_partial(s, node, &pc);
        if (freelist) {
-               /*
-                * TODO: check if still applicable
-                *
-                * Due to disabled preemption we need to disallow
-                * blocking. The flags are further adjusted by
-                * gfp_nested_mask() in stack_depot itself.
-                */
                if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
-                       set_track(s, freelist, TRACK_ALLOC, addr,
-                                 gfpflags & ~(__GFP_DIRECT_RECLAIM));
+                       set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
 
                return freelist;
        }
@@ -4515,8 +4507,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
                goto new_objects;
 
        if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
-               set_track(s, freelist, TRACK_ALLOC, addr,
-                         gfpflags & ~(__GFP_DIRECT_RECLAIM));
+               set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
 
        return freelist;
 }
lines 1-41/41 (END)


