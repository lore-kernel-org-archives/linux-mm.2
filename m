Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56280CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D446B0005; Wed, 27 Aug 2025 16:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DF38E0001; Wed, 27 Aug 2025 16:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AE46B000C; Wed, 27 Aug 2025 16:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 843BD6B0005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:46:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 523B8BBB62
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:46:15 +0000 (UTC)
X-FDA: 83823719910.07.7580F27
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 192B48000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:46:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q7gKgNWb;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756327573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ahOSLWCblhlSzmsWpcFUTr95mpQcXUfJDJnFLqu19U=;
	b=gQHmLIH6NaBO0jfOSmEepow4z8iis/rY2UJevinxX80JmaCnNCAtVhWNmVW77JcYtFO8Rn
	omyr5v+gXsrA+5ScKM2b8N6ey4mPdQN0IeI2WuBZnHEGwzK1uV7Go4curSghso2pKQf18M
	naJnKVUMTSB9ROpqg6VjJ65WO3TBTso=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q7gKgNWb;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756327573; a=rsa-sha256;
	cv=none;
	b=VLF7UrOQgfVH9oqSIS5U1QoQI6e2+8n5ghkyXvfq2hZ4SIY63209vvGgnAvR/xEOB8pMVV
	SArkLdcH343E1GCg7ZhVud2PK9h5G9RLLPGqhPd+PUObv9FJ4rVC3+1uOTM8+7OTby+R6+
	NMR+YsIm8zYqTQbgSeDngTnfzfIC79U=
Date: Wed, 27 Aug 2025 13:45:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756327569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ahOSLWCblhlSzmsWpcFUTr95mpQcXUfJDJnFLqu19U=;
	b=q7gKgNWbJlbFvFV79gYnJ2M3yDQD0gyNhew1vwd+MLVhfZX8esNm3LIG286u0FBXpqbw0y
	/0c3V5wfyP8FU3qGtG965GdeaH+EBm5Dz82fjS+KAc8BeNkdOo4WOvI6jexeI3bBrrAbdI
	6+OmUuV8ctsW1XTWIZybC9ZFiPppTzM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, willy@infradead.org, 
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 mm-new 02/10] mm: thp: add a new kfunc
 bpf_mm_get_mem_cgroup()
Message-ID: <fxjgxvoq3z4utlwb7asmt6wfjfl5t2nvfnghhmwplhqerv22yg@3i4gdavsyirq>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
 <20250826071948.2618-3-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826071948.2618-3-laoar.shao@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 192B48000C
X-Stat-Signature: qj9x3ojass8a487carw4kixqcnd7oxbp
X-Rspam-User: 
X-HE-Tag: 1756327571-995003
X-HE-Meta: U2FsdGVkX18EdLBvjIneKJVgwkZFvSCq2uBGGMj3Q5d1Uq70vV7ag2zHEr/IaSNL0hEffgwsBG+zfeovraf0GdY8vyr8xAMANRLA2t1SdGnta8K0WWx7R3pb0WVoxMvtAyeFJXV/EudE6zw3f/uZ7ZL0k22oI1yUV6Zn4fZHWly3ItUehgfxfAkW4bfjyS07EsvK3fH5kTOqlgSrEg2B9nLU0FL82SuCKKwyol7kyZDr8Tv8SdjItIHpUClrwbJ1ZNEGx5IHlT29B1UM84ASqhHqwiGLXPofA8q6Pk4xJwbULalpNPauEuPiehtnV5wgFYYEZmU2/rw5twW9g0hTNcPmHppHYgbyM/ZTDaLZEGNHr348MHqXa+Eh2J1BBvH9jmgFVyiWlj1d7yRzti/DaP82cNW977jtwA6Omspwr8pSNqCluDihCz9HaB9OlSQDvqRuO2MlpF/iFy1+aeU9WLkMZsJlys74XbkH59h23k0O7utvP4kXdMVpH506zwiX7ORlm5T1P1RzRJ3s2uCZ5Oe9BnHFQAzvwhakcV2IDVCzx+anB2B0bx9EkN2MLSYEe4wYHqN09EpuYO+zVSAB4A7qgPsEpto7KdwKW0dk6Rh44hfcJa3DaDbA9/0sst8FPFepTX3vrutc1NFD3G/+P35DyItB9f+Lfyng3vjyGrO40ojUDfMD/Zdjltta8GJ//0EfrTj25Ht/TCW3ucbvfTFQY4XQrVtrT8TCovpFUSHI3c7kyXZ0ed54mPIsNskmdZT3TdsjdLJbCSIPn+QvwHBUlvfuXQe+4wzhoKf/pHDhFQh5/XawZUmDC2KU0411BxRMXbe/Rq6GnReF0VzmvU/S7r0YcsGSJUJCc9RmJmxr6iR6oY1NlsSLQOkPmgaAnOU1h9VzQw0pwaR/HZqgp009yc4D/X5XuXhvsYUqz8tX4ZcmTBWn2Ljm1NWtFh3FC22U/A9VnaYNObvTqzk
 g0SEMBQh
 tOCDXhnTy9A3sf6rek9F0NthuxY8fI/zEYgbAdQCqL17YBxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 03:19:40PM +0800, Yafang Shao wrote:
> We will utilize this new kfunc bpf_mm_get_mem_cgroup() to retrieve the
> associated mem_cgroup from the given @mm. The obtained mem_cgroup must
> be released by calling bpf_put_mem_cgroup() as a paired operation.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  mm/bpf_thp.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> index fbff3b1bb988..b757e8f425fd 100644
> --- a/mm/bpf_thp.c
> +++ b/mm/bpf_thp.c
> @@ -175,10 +175,59 @@ static struct bpf_struct_ops bpf_bpf_thp_ops = {
>  	.name = "bpf_thp_ops",
>  };
>  
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_mm_get_mem_cgroup - Get the memory cgroup associated with a mm_struct.
> + * @mm: The mm_struct to query
> + *
> + * The obtained mem_cgroup must be released by calling bpf_put_mem_cgroup().
> + *
> + * Return: The associated mem_cgroup on success, or NULL on failure. Note that
> + * this function depends on CONFIG_MEMCG being enabled - it will always return
> + * NULL if CONFIG_MEMCG is not configured.
> + */
> +__bpf_kfunc struct mem_cgroup *bpf_mm_get_mem_cgroup(struct mm_struct *mm)
> +{
> +	return get_mem_cgroup_from_mm(mm);
> +}
> +
> +/**
> + * bpf_put_mem_cgroup - Release a memory cgroup obtained from bpf_mm_get_mem_cgroup()
> + * @memcg: The memory cgroup to release
> + */
> +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> +{
> +#ifdef CONFIG_MEMCG
> +	if (!memcg)
> +		return;
> +	css_put(&memcg->css);
> +#endif

Just use mem_cgroup_put() here.

> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_thp_ids)
> +BTF_ID_FLAGS(func, bpf_mm_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
> +BTF_KFUNCS_END(bpf_thp_ids)
> +
> +static const struct btf_kfunc_id_set bpf_thp_set = {
> +	.owner = THIS_MODULE,
> +	.set = &bpf_thp_ids,
> +};
> +
>  static int __init bpf_thp_ops_init(void)
>  {
> -	int err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
> +	int err;
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &bpf_thp_set);
> +	if (err) {
> +		pr_err("bpf_thp: Failed to register kfunc sets (%d)\n", err);
> +		return err;
> +	}
>  
> +	err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
>  	if (err)
>  		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
>  	return err;
> -- 
> 2.47.3
> 

