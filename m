Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 167D6EFCE57
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 01:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1235A6B0005; Wed,  4 Mar 2026 20:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1B46B0088; Wed,  4 Mar 2026 20:32:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F386B0089; Wed,  4 Mar 2026 20:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEE896B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:32:21 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6555DC2897
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:32:21 +0000 (UTC)
X-FDA: 84510284082.14.FD1A81E
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 642FF40006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:32:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qjicY03o;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772674339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2mG8exrUFH6rskHGTsRAo57iMTOJNkDkFHRY8FBRoA=;
	b=GZt0DuEePHB98iN3dXceUbYPVnmkQjB2tPrRbWHE3u8N1KvvXgwtwS9b8BDOnxUWjcoAJS
	jQmQElLHqxaexGrx8bOGy4dy/B0HisJbfJZ2QtZy+3CoSiRlllvYvAVl16zHsrraeK+bqu
	oyBDTQUci8CJW6aUJRfrRfakeIpdfkU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qjicY03o;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772674339; a=rsa-sha256;
	cv=none;
	b=2SUfgAqShRZWxRNCF17XKJPX3htaQp1ht+71o7rRxw5Bls5D+JTwPNHka3ELSoS09GjDVu
	9vXuKrE76byI7cK/bdb8SG0cDry8E0FoMDIQtspoGD1YOp+LsdOVKurvmmZH6kajQGrTlS
	FCbX+azCeED7z/7KehUojR5cMHN9oso=
Date: Thu, 5 Mar 2026 09:31:58 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772674334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k2mG8exrUFH6rskHGTsRAo57iMTOJNkDkFHRY8FBRoA=;
	b=qjicY03oeG8C7IpLHb/tkV/lxKamSOf/ik7NTrXRqimic1lLdqtbTWoSVWnVJBS5s0GXoY
	tjy81k9g03kfULTYQBgRVX1sPyhMajMmEVSgFKsthpgsKg0lsuRhhJe+RYXsjoPXTqVbXb
	3gz+jbMSHpJGbD4ZzsN++kpSErSKchc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	cl@gentwo.org, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, surenb@google.com, venkat88@linux.ibm.com, pfalcato@suse.de
Subject: Re: [PATCH] mm/slab: change stride type from unsigned short to
 unsigned int
Message-ID: <yf3ubjg4mummcct6z6djqnsfe45665d7ydwp7sxyd4komfuoiq@wlw5wclv7epn>
References: <20260303135722.2680521-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303135722.2680521-1-harry.yoo@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 642FF40006
X-Stat-Signature: n8czkgwiagzhq87iirnnz8pz7o34ih4a
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772674339-527536
X-HE-Meta: U2FsdGVkX18ZHpTnJEwojsZWUcGYsXfj6fnR+jDmZUTPN4IdIb/jWYb9JtlTnHCVKKMVOoc7jgDvGE2bPRfC394U1MH77xrtt6tv1PPMTjhw9tvyb72KHQZbGqzz12abGDTxx+8OTDzOyMNZZ783cjfddbEz3E+Xtgnhg5qX7qMceu4RDSVgY7xpQQeJuFcjG44Qwb/bwpdT8DblVQPcWchTzJkwp2CVHdOXYw3FObiS0QSt/778znDNp6q3EFOTraoiGE/eDSKzNqMfDN75VgYuoBYfdHHPH6urncTCCotFE8IeIHCDplCvMepLLClrO0R/Dg4MNvXYnng4AnYOgEHrkRbqmLfgImRLUAStv0pIXQYxJzkAv+LhJeWEdVM+oZ6dJQF3RH3Drk5R3ByHqnJ7qw7QbgYWB5UKR92PzMz+xU1iMYlFJsxVprArgltCfLW7g/7zVn+PVwd5NN37wOQbDgf82rjND/Devhs7DxcmbC3C0jBQ0CnLaX26xrjxh3d4aillGXrllxT2XVbmjRORt7fFzeXEjKufXlrcOn1Lsvs1iuiO6NBe7XxHEu7fC681z2qhJWKtLWTs9n3my9Befph5cwnPrRYg/e+N1w+CU7VXmnHp4rdNLKGxnJaBLRMAjvGtDm5PyMEycEz0tSSeGWMoqVhdarGhSxhpRd5kwr+XcG2hjjwawpxfcCs2DmrRL/iWQQYNl4aCdg5PDMNk9UqhMohXVkU1TWx+deOgtubG7MF5ZRe0mJWKJEEMFihA93zAG5P3stZKHiZNyqqeRhDZfo6gFsGNJzyeTia8K8dBeiMLN//aYvgI1TSvzrBFyMnKxbgDq8xZhMNVF+FvGJN2KEDi3dggOdfJ/NoK2QrURDYZ5kZy2c6ILFKyezSH4CwlcrySGGX+qwTEkJSIUw0trTr/TE2qLOvKpHC5xBZG1F+OHDXUgOSA+y90K84THwWlDTUC+9q48k0
 zCSaC3fO
 KHuWelGnRq/IxNmfMdRYKtZ1GwXcDh1kIeqxN/L7OFHnmKbsfeOO71AfvBUUOyKxwypOkNr6HD6QnNXFdMn2TTyuk4r/XCAxy4gdHrjkZWh7Q/n+D7BkhmLegW1y2YOwvfQzUo0zrh+0aLeZdRh+UbVSCQsBmLeGVXMjrn/eFF/UeeIAQFYjDzfyt4x8T+EzOroKQa99JmJRbaAfUg0gD5Z49vNz1lgoiACalTFqfCgIcx5GFARHgLzl6c8SGXYFAh9mrg90cWCzBfZFguxlD295wHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:57:22PM +0900, Harry Yoo wrote:
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

Wow, such a complex issue boiled down to something so straightforward.
This kind of corner case can be really hard to debug. Thanks!

Reviewed-by: Hao Li <hao.li@linux.dev>

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
> -- 
> 2.43.0
> 

