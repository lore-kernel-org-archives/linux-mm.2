Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 435BAEB7EA5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA60F6B0088; Wed,  4 Mar 2026 05:17:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87A06B0089; Wed,  4 Mar 2026 05:17:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4ED6B008A; Wed,  4 Mar 2026 05:17:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 884546B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:17:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08544591EC
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:17:51 +0000 (UTC)
X-FDA: 84507979542.24.73AC2DB
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id E6C8420008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:17:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XAeL2xUH;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772619469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KoS4d1g/sHa9EtIML/M64KShORyKTnEsKbcSse0JEQ=;
	b=C27bo9UHpcSQ7EVJrzmw+GZrkve/OAxHDH5q/sLx28/rnSXn5/jw1HFGs6BWlm0dsA1Fhb
	VEpxHDlxLvF7s1cLXd8M0lWnJrjFbdEx6B/+o6UvxMtZLiFgS7pTGomQkbjqO8NHCQJVzr
	+Bx7je2QtEs58s3scHwaoGFbnpLL9aM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XAeL2xUH;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772619469; a=rsa-sha256;
	cv=none;
	b=x6ZFzIIqYfT1YgtMA/eT+GHCdMhhz5UCXmGrDAFNvz3s5TXF8keQrFwjipq6a1JLapCKP3
	OZKkrMA5KPaBm1seUhiICzGlfbpRD+35OW/oO9nH88QaucFdHNu3u6AqAjBe5SSPbl6Eim
	Bq8NmfEbbjkqaOn5zHKQqV2lK2MB/AY=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4836fc075d2so6494355e9.0
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 02:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772619467; x=1773224267; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5KoS4d1g/sHa9EtIML/M64KShORyKTnEsKbcSse0JEQ=;
        b=XAeL2xUHIFjQ3MnZRPusOscKt15j2uwJJkfS1Kn8F492Se4mzaHPSeI1YnY5gVHdHR
         YMq8RDgZdW0Z6/uk52o1AKRQZbz+vvKEllEBNi5uKRVaGTjnfZ3mdpzsxi2TXF9752hq
         vEluXloqAEQyGg/mhmFikUC6C02QKX5NTnxsY/ysByIL8n5IghY8Ks5ADtzXq+T1STbQ
         vVcIpSUF6+Yfyn3NAqbRBvZu5irGDKQJrncForuiUJ1qlKSVfj4UShO024kBNF+528Gt
         000PvxReWzdWUcBRLFbnznC3Utz6SNTwdeMm/Yv1RFHWZttZOw72bHVnCgCBB+bQ5xAg
         Zi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772619467; x=1773224267;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5KoS4d1g/sHa9EtIML/M64KShORyKTnEsKbcSse0JEQ=;
        b=lzbkG0Ndf3oAA9AEHbakaI2JasafqV6e7kJf01cZXdOpPlbbDBp0vkF1KEagChE5On
         KPbgM5udcszFJ4412ITAaarLlzJ++QwsciaP6y1dpllCIL111dT5iQjg08X3kKVQYmEY
         y2QyGVB9JD2orQXFSuZDSiwQwjP7mW7wC4V5fYcw8A6m1iYDe2tKojJamdwQprWDl4OU
         7o352HmyjXe535atEHIRXiRLYYIyUTM/6CjDigR9qVW+TFj1f75ahn4pg66OSMtcHVko
         TV1BjgfjKTOQBEYLmRJcq7m90BE1TA5dNQpq2NptkuKRIcxiz/PGohm6tD8MHLAaJ2B/
         SB7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXaRbZnKuuqtL7IutjSp3BJGPVCHDMl8h3iP1w0tihqu2Hk2mqM5JnxSakeRfrNvBC8kwzQ5EpgEg==@kvack.org
X-Gm-Message-State: AOJu0YxrQ5Zaw9FHZOSm0m/tOZWskdEB5Fnco7N0s/9xSzhpZln/HCC2
	8Q+0Jmyj5o0mS4kMzS9DJaPw+8jcnJ8Hz8/HObnPXv5PND+R3oQSHdklGIQKCQWdOLo=
X-Gm-Gg: ATEYQzxfU/S9vLaYyDys46L75xXG60kECzm82y3vE6qy2Tk/48Yjtp0XsQqSQXrGtV3
	PJ2h3z3u0yOA8WsVZx9Sckj9uXkoBhhmrwmkqNK5GC1XvTWgNBKuVZR2UF4kTLsVZwUsKqv5+GS
	hYaEvQI65bQEpCa3kmlEEWTWrotV50GUzJmjwSftdu8iwMSawWA7xjYw0skTsxOfZ11JBjdSmpF
	J0Mg18rDkA920/+b8nqkFiIzmhXeRLqCi5BtKKODNNK1AlavphCaOKIFRlnG6CTIfvmFVl9erCs
	uRRRt06c7VGBjle0IwUMU8pdmH3BkQsZ5JsH1VTSkWbsU48FvEYNp1WeG5ydOuxU50FoIFy6SvB
	4FCrHEseKyI/xO8mbnnTVTO4Ofo4EfnwScw4Ey/58c+UO9QG/o0rvqEEzxdRiVZJC5O+xHO9gJO
	ercbPTUCN+YQy8eGRzop/kIXWvy2xJHgUD07YmG60=
X-Received: by 2002:a05:600c:3489:b0:483:7631:befd with SMTP id 5b1f17b1804b1-48519896e6dmr14055045e9.7.1772619467328;
        Wed, 04 Mar 2026 02:17:47 -0800 (PST)
Received: from [192.168.43.36] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851880724esm79793035e9.9.2026.03.04.02.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 02:17:47 -0800 (PST)
Message-ID: <fe9dacdd-8b96-4375-8730-8fb9ed5fad60@suse.com>
Date: Wed, 4 Mar 2026 11:17:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: change stride type from unsigned short to
 unsigned int
To: Harry Yoo <harry.yoo@oracle.com>, vbabka@suse.cz,
 akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, cl@gentwo.org, hannes@cmpxchg.org,
 hao.li@linux.dev, linux-mm@kvack.org, mhocko@kernel.org,
 muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, venkat88@linux.ibm.com,
 pfalcato@suse.de
References: <20260303135722.2680521-1-harry.yoo@oracle.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260303135722.2680521-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6mex7ybkdob91arun7asnea3ozcrea4c
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E6C8420008
X-HE-Tag: 1772619468-979369
X-HE-Meta: U2FsdGVkX1+Rj3HmwvFOgjDmD5gSoV1ipQeqlcw7hRQ+T1JezWYkTaLYX5rcpN7KlNdz7hDjpt+TaHWz61lC+86zXJoZSheuqvPROn0ln0+7k1IgwnTnh5sNrAaH7p1P8G1GmpzucnUVF5MM34Qm2X5XK4PYJ5Tr7S3CmhKiJY8PT9g8vz5S238xR7dKtVIZ8HSqhunW3xk9lfyslJo/FCt8tMKO89vohMFA8sLBwOfMQFntTOlGjC76B0PgbpopyfdKrN3Xd0cw+RNrtFubfhKKZ+ubBW3t1cR+EJxAxiZcMrhqkRl2gFWNeFu41DSIqzYpDEcMfWmvsALphG8tu7ELVG7/Yk7QfoSzMNcRyoSN45aRevscKD/vOGfjt16KMIr1hF+1Iyj6TKK2GSFuAVVd4k43fyPcTsmD+LUG/h1iDse4WRh56rrQMb4tXZl6vrmsIIBw1wEEN7j3keK+6s/cqZsdE5kTmQ9K/xnNZ7nYZ+CIds0mYVLsTmfnoVuHZ4ekSh0OnOBgMmjq6jh1/tgh2pebcCF3/DeDMPpFc711C0noDk8+eTZ9Vac68vxOFH2jTuGtHiKmbZj0rh0pVAe8MIQUMjBIF61xKar1J7sX05VN6efNy6tjklWx1F7gBs72rZN73sR063kt0SRaRN8qqwiP7SYYHe/pBYRPMG/Jb4dK79mJK6kn7aeTwrDhTu5d0xK14NLqUm7VczYyTtZCiopGhpeeT3DeUPUfkvud3Uv8YVgXWk1Acm7SU4pZyQwKFWtWu8NWajcSUATxxVkcfCG8f5vXxR5I3YKjEWlEk7fsnqhuuHq8P+BOyOUV6TzGyxdNgFwI7F3FsTMWQCEvtqP9qxQHjWuriEisU+jdEIqxx6gKq/ZpEKkhC3jlIsJ9ikJxlRhvfH7QLPhbj1L0ktYGyUQdcXdYu/WO7kWw89yNNY5agIxPVVncKAfrpJ5NcBLnxfcrJrcblFX
 sN4p5LSz
 AvBtsO191RAoSWLE3wJ0c87E+K7rso32N5Zq3AmhqVEmvAmnyW12V1Xmt2tLEMCH0+1aEkJVFf/zgtpkpsnOtIMv9FW+ZfWPu7pwir/A5Xxwc8k80BQXgoZMHK9Yz4mJ8wVVyTLTf2RXgzA7rGKTrgNmpZwnjkX0lvBJ9+wnGki1iEOC2aQJblGdUEV9kCT5ZeG3LkkIxPuHJkMx8GaO1dj8S57TiIRCgJjuws+VnjrnEIVnCqfbrnP0Zlj1CO/KEbLkP4kD+/gySw9bVnUvtYq8ROi3BwYt2rm2P5sLRLgtUrkZsxWysg2qsftMuPKhwRiOySISA6CzHOooyfjjlNOJ55TKp9eCT+fj+HNeUQ1n0khCInRs8jIsetAs3CSM49QRryrI8nLFfhy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 2:57 PM, Harry Yoo wrote:
> Commit 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> defined the type of slab->stride as unsigned short, because the author
> initially planned to store stride within the lower 16 bits of the
> page_type field, but later stored it in unused bits in the counters
> field instead.
> 
> However, the idea of having only 2-byte stride turned out to be a
> serious mistake. On systems with 64k pages, order-1 pages are 128k,
> which is larger than USHRT_MAX. It triggers a debug warning because
> s->size is 128k while stride, truncated to 2 bytes, becomes zero:
> 
>   ------------[ cut here ]------------
>   Warning! stride (0) != s->size (131072)
>   WARNING: mm/slub.c:2231 at alloc_slab_obj_exts_early.constprop.0+0x524/0x534, CPU#6: systemd-sysctl/307
>   Modules linked in:
>   CPU: 6 UID: 0 PID: 307 Comm: systemd-sysctl Not tainted 7.0.0-rc1+ #6 PREEMPTLAZY
>   Hardware name: IBM,9009-22A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW950.E0 (VL950_179) hv:phyp pSeries
>   NIP:  c0000000008a9ac0 LR: c0000000008a9abc CTR: 0000000000000000
>   REGS: c0000000141f7390 TRAP: 0700   Not tainted  (7.0.0-rc1+)
>   MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28004400  XER: 00000005
>   CFAR: c000000000279318 IRQMASK: 0
>   GPR00: c0000000008a9abc c0000000141f7630 c00000000252a300 c00000001427b200
>   GPR04: 0000000000000004 0000000000000000 c000000000278fd0 0000000000000000
>   GPR08: fffffffffffe0000 0000000000000000 0000000000000000 0000000022004400
>   GPR12: c000000000f644b0 c000000017ff8f00 0000000000000000 0000000000000000
>   GPR16: 0000000000000000 c0000000141f7aa0 0000000000000000 c0000000141f7a88
>   GPR20: 0000000000000000 0000000000400cc0 ffffffffffffffff c00000001427b180
>   GPR24: 0000000000000004 00000000000c0cc0 c000000004e89a20 c00000005de90011
>   GPR28: 0000000000010010 c00000005df00000 c000000006017f80 c00c000000177a00
>   NIP [c0000000008a9ac0] alloc_slab_obj_exts_early.constprop.0+0x524/0x534
>   LR [c0000000008a9abc] alloc_slab_obj_exts_early.constprop.0+0x520/0x534
>   Call Trace:
>   [c0000000141f7630] [c0000000008a9abc] alloc_slab_obj_exts_early.constprop.0+0x520/0x534 (unreliable)
>   [c0000000141f76c0] [c0000000008aafbc] allocate_slab+0x154/0x94c
>   [c0000000141f7760] [c0000000008b41c0] refill_objects+0x124/0x16c
>   [c0000000141f77c0] [c0000000008b4be0] __pcs_replace_empty_main+0x2b0/0x444
>   [c0000000141f7810] [c0000000008b9600] __kvmalloc_node_noprof+0x840/0x914
>   [c0000000141f7900] [c000000000a3dd40] seq_read_iter+0x60c/0xb00
>   [c0000000141f7a10] [c000000000b36b24] proc_reg_read_iter+0x154/0x1fc
>   [c0000000141f7a50] [c0000000009cee7c] vfs_read+0x39c/0x4e4
>   [c0000000141f7b30] [c0000000009d0214] ksys_read+0x9c/0x180
>   [c0000000141f7b90] [c00000000003a8d0] system_call_exception+0x1e0/0x4b0
>   [c0000000141f7e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
> 
> This leads to slab_obj_ext() returning the first slabobj_ext or all
> objects and confuses the reference counting of object cgroups [1] and
> memory (un)charging for memory cgroups [2].
> 
> Fortunately, the counters field has 32 unused bits instead of 16
> on 64-bit CPUs, which is wide enough to hold any value of s->size.
> Change the type to unsigned int.
> 
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com [1]
> Closes: https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com [2]
> Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Added to slab/for-next-fixes, thanks!
Hopefully Venkat confirms the fix and we can close and try to forget
about the memory ordering can of worms again ;)

> ---
> 
> Hi Venkat, could you please test this on top of 7.0-rc2 (instead of
> 7.0-rc1) and see if the bugs [1] [2] are reproduced on your machine?
> 
> I reproduced a debug warning on a ppc machine and fixed it.
> The bugs are expected to be resolved by this fix.
> 
> p.s. After more debugging, I saw stride appeared as 0 even on the CPU
> that wrote it, which likely rules out a memory ordering issue...
> and I discovered this while decoding ppc assembly suspecting memory
> corruption or a compiler bug, which came down to:
>   
>     "Hmm... why is the size truncated to 2 bytes?... OH WAIT!"
> 
>  mm/slab.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index f6ef862b60ef..e9ab292acd22 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -59,7 +59,7 @@ struct freelist_counters {
>  					 * to save memory. In case ->stride field is not available,
>  					 * such optimizations are disabled.
>  					 */
> -					unsigned short stride;
> +					unsigned int stride;
>  #endif
>  				};
>  			};
> @@ -559,20 +559,20 @@ static inline void put_slab_obj_exts(unsigned long obj_exts)
>  }
>  
>  #ifdef CONFIG_64BIT
> -static inline void slab_set_stride(struct slab *slab, unsigned short stride)
> +static inline void slab_set_stride(struct slab *slab, unsigned int stride)
>  {
>  	slab->stride = stride;
>  }
> -static inline unsigned short slab_get_stride(struct slab *slab)
> +static inline unsigned int slab_get_stride(struct slab *slab)
>  {
>  	return slab->stride;
>  }
>  #else
> -static inline void slab_set_stride(struct slab *slab, unsigned short stride)
> +static inline void slab_set_stride(struct slab *slab, unsigned int stride)
>  {
>  	VM_WARN_ON_ONCE(stride != sizeof(struct slabobj_ext));
>  }
> -static inline unsigned short slab_get_stride(struct slab *slab)
> +static inline unsigned int slab_get_stride(struct slab *slab)
>  {
>  	return sizeof(struct slabobj_ext);
>  }


