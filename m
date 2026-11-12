Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22AA9606A324
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EiRz0mJG
Received: by kanga.kvack.org (Postfix)
	id 117E46B05B2; Thu, 12 Nov 2026 01:32:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFFD6B05B9; Thu, 12 Nov 2026 01:32:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005A06B05BA; Thu, 12 Nov 2026 01:32:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D01B56B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:32:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 656A380427
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:32:18 +0000 (UTC)
X-FDA: 85425497556.19.CE51F1D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id DE3F6A0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:32:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EiRz0mJG;
	spf=pass (imf25.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794465136;
	b=dwRIf5D8rc/HSj0EJq9uMgHVO3B4U2IvYeG67++xV5f0DXu5WW2vEj3VPTRdyx2RGSmCD5
	Hp0IzSPSammy2XsbZm3klWW5xR5xsiC/1v/OomL+ebGw8PpZJfQUXUIBTo8XN5T6byTesx
	t4lfg22XbiAgiftnaOpcvMAFFCKPKfY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EiRz0mJG;
	spf=pass (imf25.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794465136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNjzCkgXtfexLjozyq2Y9l2D4DehQKcLgP4hhpEJaxk=;
	b=dJ5Allym14Fyx4OzBt10oEhV5HmuSuyAa8wJjIGzGdDJ63KXl1Y1ALQZMJbNNjMs6/8QDX
	M6x7s4wUgRAc35EQkLTvncZrbc1CX3/HUDuFnre0Wz8PhW7eu0C6L2mTVUmqqDry+OsyLG
	WfmITzNUBU7DwZln79axrMVYETHX7r8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794465135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lNjzCkgXtfexLjozyq2Y9l2D4DehQKcLgP4hhpEJaxk=;
	b=EiRz0mJGQCB3AlumGLarDCSSjb2e9Dg7ocBk+JVriOYSc4nhRmIwxTRCTOURxM1au2fyF4
	JM25U7uKtWRb0QwQ0Lc9ZUja/KA0/H3hSf9dMNaQsJkQ4DTrLzP+dm6ktyEWk12ySg23lG
	0FpmELz/sQIY7T8iO28PJm4FxhwOgBE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-QZL5_R7lNreYPp3eC82tDA-1; Thu, 12 Nov 2026 01:32:13 -0500
X-MC-Unique: QZL5_R7lNreYPp3eC82tDA-1
X-Mimecast-MFC-AGG-ID: QZL5_R7lNreYPp3eC82tDA_1794465133
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ac0ae43900so3651587a91.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:32:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794465132; x=1795069932;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lNjzCkgXtfexLjozyq2Y9l2D4DehQKcLgP4hhpEJaxk=;
        b=yCzUcI+WkJjl6cFwNdWrmOdkZbyO43XhjAb+luppQ7SMonqxehc71490KVWgOeXvjI
         Agi/zvyQjDLDvBvESUkNSJBckKvjrgPDwyskUq0Qs5vWrlU0G9YHto8FKngAurfmi2C1
         WfDNMrq3XSGvLJhZqwtGs3t8ewO7zp3isDBBpW2Fca1ZFq4EhtUaOZY+FUMviWBuoG7g
         KnkpD8saTCfMvzaJEzIpKF66T0ucHH1TASt+rR910a8eBChERNdSllRMAXlVSJVWTMwh
         yug93qYeYL6IjPf2f40xApnevDE75yxkc/Sx/G/y0s6wlVzhcEQmsTLwxjB0AH91l4Lt
         TkiA==
X-Forwarded-Encrypted: i=1; AL+hErEiV/FJSA8zKUx5mbx8323O04r2hn3N08MMnK4uz1Z8gMf56k31rkZubu2WLYmvSruBc6ihD9/GEg==@kvack.org
X-Gm-Message-State: APuU4Z/vyx5SpllGHkEkLs4QEXGqRh1KUIOjw+38/g0FDvV9pERAaCPE
	QNFNg6eshKatAZLaNzBbooR0L9QBzANExfxsNET4Ri3zwtZzBkSh4CaiZrOI9DjnyhcbAtMpyD/
	z9BS4vjXVe7G7OSHzcYNwzUHJEiziLi/SyZ90tuWGHFUfyTqhFcAD
X-Gm-Gg: AYBFou0BnYgai9poSUH8Ep1Y4OQbWkdtQwbaClqjiZWi03zLk5dBMq5aGxvxJv1XQRo
	lMXTqRRAVWy4C24we/AEirARNJnVTw+PnuFvqUB+IWbgIXo6v942JAB9H1kov3i8A805NZlbHXp
	eddD/Zor73m4uglz11gOxczgOABuccodIZWLAwMY8UHcSN5oumuXNY3iuP4s0thyP2OsupZqXU3
	d0J3uW0rGsWrQEzPXDGrJXPx1iMqP7kZqATMeZna8HuR98kll9lkcN2XWUihYzS1pBkjkeOU56f
	roKYv7l78PtV5ep7/9FIgD89ZQ7jr70fQTIVr0H/r5gFCaqiY9LLylqHctHhiIXiViT7Qe9X2KK
	IYUWonyPQXP6048a1aL3+ks7jxtdwwBn7k4V/oqIWl0FBFsR5LvSeKIRl5MX6/2ghKafjpQbgwO
	mFsDblF+GMOMEc7KQyOljtcGhpURMuaXBuAWk7ab3GnuBQVw==
X-Received: by 2002:a17:90b:37c3:b0:3ab:413:49bc with SMTP id 98e67ed59e1d1-3b182ee2462mr4497391a91.37.1794465132349;
        Wed, 11 Nov 2026 22:32:12 -0800 (PST)
X-Received: by 2002:a17:90b:37c3:b0:3ab:413:49bc with SMTP id 98e67ed59e1d1-3b182ee2462mr4497373a91.37.1794465131889;
        Wed, 11 Nov 2026 22:32:11 -0800 (PST)
Received: from ?IPV6:2001:4490:489d:4213:2481:b5a5:59e1:8f87? ([2001:4490:489d:4213:2481:b5a5:59e1:8f87])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197ce49d6sm3019469a91.4.2026.11.11.22.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 22:32:11 -0800 (PST)
Message-ID: <990cc079-70ab-4fcf-9974-679aaf07849e@redhat.com>
Date: Thu, 12 Nov 2026 12:02:05 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] kho: walk bootmem areas in address order
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o679xcybNHtvQ8ovj9xLUvDZysuhN8CYskvmXmt8bfs_1794465133
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xqoxq3zyiem4tmmtzjjoce6xnry9z6cg
X-Rspamd-Queue-Id: DE3F6A0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794465135-869177
X-HE-Meta: U2FsdGVkX1+Px86O+jeovB3nszdK15RylwyNDFzYOqVG5MQ3tBa407xb+3MTUHuNmRGPJuAMMXmHODJH6auwao4V1ttZTY7vX/l1Z8Do1WDzaT2PNLkPATxYdst5K8Q9ZU/D9PznQJrsPH4VVmqw1nTm+2nxx3NTvHfBqqwGTQ/ZMODTSX0wQv7209eJA4qSuf2sb97WVvohCZs/joDHrg1lUNh2OqeOlhpjJKR4fjfkrsznN+M2WUXtywKin9dZtt654Mb2EkRgEmmFu5BW3ejmAVIg97741/sWsHdDwvBKf78Ke22bu6JtLg7/tFylJHYKJeTw51e9xdwKC9jBC68pwqd6o9EmsRCtpach2lvgtmRvTBInGjFPRa02PzLKbAPvfdhaDiILiw5JMVktbFIn9S9ZStOUwiHpUQFrk3/K+4Mk+wkbJ16Xh68dIApVmGouSpYS+MyxSXfpknCGL+YMkP2pooD+2F512Jtvnc1y96GOl4JXMghSDkHBlS7aR4VUKRCxpyxx63hTUTJ2XJ2nTNJlkcFtomKpHuNWgLB72OL7XkcYaynUy5OksxPjvXkTN5qXfc0QzF/YZh8EcrO4s+ylJckqMlQyiN67/xhZAF2aDOefl2BIXGbe7MewjjyhD4yrU4bFzlei29VYw4p7mCLBruJOr7r7i653lhc2BsQlSc51N/6ag8ZxPoPnG0lryCbIJ78ifH/7Q5E2ze/okn2liJfEpctpuxfS3EhQgx3XxcITIebnCR6pS65jV8GkyyURd4iQ8zLXTeU5+AuyVXRkLGAt1NOXtn9FFO6Ql8sWAzEp5KQ6MqPYE4bHkMUYgMtKAjDObmlVDq5kUd9lYowgdU6eeN/1u8wx97pae/Jg0FiGRtxU6k/t0mvZ5cTYHvnJorULJfORu0PhOAEJQdV4vQSDYhvqALDt3mBDA+RBKHMtPi/oegx1pnIYSZBpplUOUYn9m+YZe8q
 mi+EHjWp
 4IsYM7HZ+H+FBZMsK+gax12oBs0xkAE6rxH1cadI5/JM8Uk4m6kC+Aq0HYuCWNyxenZTgsbrkOQZ+qeynnEmIZoY80r0FxtG+sME6p/MhfREHZdy3DMTJR/W4T0kmWBdd5QMa4PC5Uxs4TuQYltNHu0N2mGBZK7lneY05f2n9F2MSNFA5jH6tHKr/jUDRGqDa4YnkOSTapav3e9Xg9ZTqDoe0NQ3dZaNSikhKVYsIjuQyhPx0A1SHRsMki9fWGVLTOypeY55pyPZUL1g/a6u9f0KQ0Z71m4Z8IHz+U8oiKcHpuei6sJEHL9tkQ6HA7wwLpB0Q4M68qYSGyLjELzhts/80OKYD3Y+kOEBUQwxK5+J0ScTBn5m5ngQF0JIpOliqPqRIvCADz6Ag9EQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

On 04/11/26 10:20 pm, Mike Rapoport (Microsoft) wrote:
> kexec_add_buffer() users may depend on the order in which memory holes are
> searched. For instance, arm64 places the kernel bottom-up and then
> requires the DTB to be above the kernel.
> 
> kho_walk_bootmem() walks the bootmem areas in the order they were
> reserved, so if the kernel lands in a small area at the top of the memory
> there is no room left for the DTB and kexec fails. For example, on an
> arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
> reserved first at the top of the memory, the kernel image takes most of
> it and kexec fails with
> 
>   kexec_file(Image): Could not find any suitable kernel location!
> 
> Sort the bootmem areas by address and walk them in ascending order, or in
> descending order for top-down searches, like kexec_walk_resources() does.
> 
> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 57 ++++++++++++++++++++++++++++++--------
>  1 file changed, 46 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe31819..2ac5d94f33fd4 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -26,6 +26,7 @@
>  #include <linux/list.h>
>  #include <linux/memblock.h>
>  #include <linux/page-isolation.h>
> +#include <linux/sort.h>
>  #include <linux/unaligned.h>
>  #include <linux/vmalloc.h>
>  
> @@ -820,6 +821,14 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>  	return false;
>  }
>  
> +static int __init kho_bootmem_cmp(const void *_a, const void *_b)
> +{
> +	const struct kho_bootmem *a = _a;
> +	const struct kho_bootmem *b = _b;
> +
> +	return cmp_int(a->addr, b->addr);
> +}
> +
>  /**
>   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
>   *
> @@ -904,6 +913,9 @@ static void __init kho_reserve_bootmem(void)
>  	 */
>  	kho_bootmem_cnt = i;
>  
> +	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
> +	     kho_bootmem_cmp, NULL);
This only covers the case where this kernel allocated the areas itself.
On a KHO boot the array comes from the previous kernel. A kernel with
this series that is handed over from one without it therefore keeps
walking the areas in reservation order for every following
kexec_file_load, and the arm64 failure you describe comes back until the
next cold boot and vise versa because the ABI string is still
"kho-v4".

So, sorting once in kho_memory_init_early after kho_bootmem is
mapped would make the invariant independent of the producer.  When the
previous kernel does have the sort this is a no-op, but the consumer
cannot tell which kernel recorded the array, because the ABI string is
the same.

> +
>  	return;
>  
>  err_free_bootmem_areas:
> @@ -2081,20 +2093,40 @@ int kho_fill_kimage(struct kimage *image)
>  	return 0;
>  }
>  
> -static int kho_walk_bootmem(struct kexec_buf *kbuf,
> -			    int (*func)(struct resource *, void *))
> +static int kho_bootmem_walk_one(struct kexec_buf *kbuf,
> +				const struct kho_bootmem *area,
> +				int (*func)(struct resource *, void *))
> +{
> +	struct resource res = {
> +		.start = area->addr,
> +		.end = area->addr + area->size - 1,
> +	};
> +
> +	/* Try to fit the kbuf into our KHO bootmem region */
> +	return func(&res, kbuf);
> +}
> +
> +static int kho_bootmem_walk_top_down(struct kexec_buf *kbuf,
> +				     int (*func)(struct resource *, void *))
>  {
>  	int ret = 0;
> -	int i;
>  
> -	for (i = 0; i < kho_bootmem_cnt; i++) {
> -		struct resource res = {
> -			.start = kho_bootmem[i].addr,
> -			.end = kho_bootmem[i].addr + kho_bootmem[i].size - 1,
> -		};
> +	for (int i = kho_bootmem_cnt - 1; i >= 0; i--) {
kho_bootmem_cnt is unsigned, but the reverse loops in
kho_reserve_bootmem() and kho_bootmem_walk_top_down() start an int
counter at kho_bootmem_cnt - 1, which for a zero count is UINT_MAX
converted to int.  That conversion is implementation-defined; with the
current compilers it yields -1 and the loop body is skipped.

How about using this one.
	for (unsigned int i = kho_bootmem_cnt; i-- > 0;)

Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>

> +		ret = kho_bootmem_walk_one(kbuf, &kho_bootmem[i], func);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
>  
> -		/* Try to fit the kimage into our KHO bootmem region */
> -		ret = func(&res, kbuf);
> +static int kho_bootmem_walk_bottom_up(struct kexec_buf *kbuf,
> +				      int (*func)(struct resource *, void *))
> +{
> +	int ret = 0;
> +
> +	for (int i = 0; i < kho_bootmem_cnt; i++) {
> +		ret = kho_bootmem_walk_one(kbuf, &kho_bootmem[i], func);
>  		if (ret)
>  			break;
>  	}
> @@ -2110,7 +2142,10 @@ int kho_locate_mem_hole(struct kexec_buf *kbuf,
>  	if (!kho_enable || kbuf->image->type == KEXEC_TYPE_CRASH)
>  		return 1;
>  
> -	ret = kho_walk_bootmem(kbuf, func);
> +	if (kbuf->top_down)
> +		ret = kho_bootmem_walk_top_down(kbuf, func);
> +	else
> +		ret = kho_bootmem_walk_bottom_up(kbuf, func);
>  
>  	return ret == 1 ? 0 : -EADDRNOTAVAIL;
>  }
> 

-- 
Regards,
Mukesh Pilaniya


