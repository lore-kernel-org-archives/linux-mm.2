Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA085606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KmKFLwam
Received: by kanga.kvack.org (Postfix)
	id 8EFB86B05B7; Thu, 12 Nov 2026 02:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6FE6B05B8; Thu, 12 Nov 2026 02:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5D96B05B9; Thu, 12 Nov 2026 02:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3506B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:21:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18564A0514
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:21:53 +0000 (UTC)
X-FDA: 85425622506.27.39250FF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 969C480007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:21:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KmKFLwam;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794468111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1b6A2kvQgpqKkzxc5p2W/1olpXK4SEEz0O9LviTyyRY=;
	b=ZBSKKbcfnVRgwKBfWgxu3XMJ98brh5yPwzzTBamqpgPiHKuePF2sf94J/o4m31nnXJ9fVx
	kmiAhhvB3+WdDdPO4sZ3QiP2/3RhpJKUkXF0tmy+eulNoyc6KI0lnm146RKgTxXhcBEqyn
	657wpPVIAdWhQ5EIORmREgGs+JtDQG0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KmKFLwam;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794468111;
	b=ZKgc3gdfIN8Zs/6kvI/+e3SVJJNQmc0lad5TUkTw6FHmpgdRmfECyvz/WBIZq1xTS500MZ
	kuvbeQ/npDSk8IXKd+OOSTc2xa6O7pRTUq2pJ2Vvu0zFaK7+ExrtNZYZ63109bnqpMTVs5
	42qI/vcv3UNXDT6v8WOL93jjiGscark=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794468110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1b6A2kvQgpqKkzxc5p2W/1olpXK4SEEz0O9LviTyyRY=;
	b=KmKFLwamsFcabz30kspuI1sgxCuBodO+FdRuTn2P5ordb4h9H+T1cdZbD5SKhywzoub53J
	cS6Ee3jbQQNYwk1WsmbiIO7ug+Ekhq4pXecYs5egyZWgnmdqH112BoRfzvdjCZM2Ns8hHF
	b9RSxrDJoT+7Gh+4EzKfuHbHZqS2a+A=
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com
 [74.125.82.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-LOpo-fdmMFuEvkSl-vdoxw-1; Thu, 12 Nov 2026 02:21:48 -0500
X-MC-Unique: LOpo-fdmMFuEvkSl-vdoxw-1
X-Mimecast-MFC-AGG-ID: LOpo-fdmMFuEvkSl-vdoxw_1794468108
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-139b62317d0so256864c88.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:21:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794468107; x=1795072907;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1b6A2kvQgpqKkzxc5p2W/1olpXK4SEEz0O9LviTyyRY=;
        b=Uk8tuZrL0Mzv13MhRKljAp1q0rCYeIAOuST56qBPYnm+mJkhK7+LgJEead6MBGknRS
         KSyZqbcJJzSYcEvkLH17wgOU8EQy9p9sGXDVuku1a71kE3mnjGaUFn9LYQTsrt07pkyq
         Ls+fl1YnSB0oNtYwz05zTxPpwSyupKsQW8lzVCbuZ+RT7RGFmUph2RyrX1icG/0vCv3C
         RnYYttMjn4FArMtYsM+g6Gts9eYO+/hkOh8xosDSKT+L6Mwf7SCa9MB8kHRnyGaGwghs
         GUPQE7dv07WHbEECrcTu4oTAwaWGQTpM5TOk+Y8W/jYX8A7zpNvdZvUeHTftD3x6z1jn
         rTWw==
X-Forwarded-Encrypted: i=1; AL+hErF6jm4NN4hx23dbE5fRvGkvXTI/FGSADeaGZUDaquUfFEdpp1DIAza2oLMIrngBDqcXXneaHarF6Q==@kvack.org
X-Gm-Message-State: APuU4Z9Kz63oaafknA2O5oBPXJPfwnMW0mkQQOkfroU8AG4Kcp+gFule
	wj7Z6OhLWppQz0NkYFNy+a4vhezEb1HdCb4qfu7Jh7XifGEG8a/g88UaQ8DxaR8GeJP64VM2UZe
	G+X+BdErnNn3+78CwruuADuRCIEQFyIqITu/BoZpRMnihcd4l21pQ
X-Gm-Gg: AYBFou0kxXziS6XCbELunGpc3DIf2LYtOo4Ak///WNg/u29XyYyfpeu90Cwc80HOe4g
	u3IgD4aAycSyP/1BgK2RS8adAYIN9HIjdLR6TP2nCOetmQRbPJ8yILAzrFfkNB0Cbnl91RLOv1R
	/DevNdO5tFQIAnB+FLqX85XrxZXPXFjy76RCT1NM6WwH5nwtae9QnXXz3MMI51UV7D4VoAzRa76
	nTg9m/9XWDYeTEiE2P6+otBKnNUwhDszRqe3te0RGHWE5NBVHtA7zVLYfQnFMpxyWBDCIqZDBXC
	V0tQEwHc64xWQu/qOEXTwNhF24fxT9OG9N9sMUbg0SazpP9oIMb4caHMaHlmLc+Nk6PW86Rf/Qx
	1eFT94fEvqJq0/pqIDMIJQKFH+W3EjaW0srtBkLlX51gW5/Gi4UXN/uQjVRv2mDqUB0CQR84=
X-Received: by 2002:a05:7022:170a:b0:1b3:b3de:9232 with SMTP id a92af1059eb24-1b3c02f06bdmr4131953c88.9.1794468107325;
        Wed, 11 Nov 2026 23:21:47 -0800 (PST)
X-Received: by 2002:a05:7022:170a:b0:1b3:b3de:9232 with SMTP id a92af1059eb24-1b3c02f06bdmr4131931c88.9.1794468106682;
        Wed, 11 Nov 2026 23:21:46 -0800 (PST)
Received: from [192.168.1.102] ([117.207.221.165])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2eeffsm22991575c88.9.2026.11.11.23.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 23:21:46 -0800 (PST)
Message-ID: <6c57f062-345d-4bb4-9af9-213ef2912d76@redhat.com>
Date: Thu, 12 Nov 2026 12:51:38 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] kho: fix bootmem sizing
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9kzxAYivaI4sVEkLkm4AnE6hOVgyDq10GVR_0TvphpE_1794468108
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 969C480007
X-Stat-Signature: 57dcdpcahew4ywqmpz1pzpcrstkf43nf
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794468110-155786
X-HE-Meta: U2FsdGVkX19oNqJgoTR5eyF+VxB2ktusbE4/QEQDFEyuczV7Kx4JXWQ9VbSoAoeD8KjvOWwVjEwBQ/s2r5WTJ7A7ums0e0ia8id5bLPm2wwf3AB1Jl68S11HNnIbZfgmMx4xrdcwXPGYxGmPJmuD8ZPH3R8a32BhJtD+cPmk+w+a/ECt04CjGnkgdkYoL7BcaKy4pM1OYURyHEr57//Pnzzu178H/Cw0kSf8wo7+AiI1EF+msulaGzcjuwnTpflJ8YcHc+WxNHupR4d/fZBS4+sPK8lxHFWHr0f4suT25diJ4p74NDWakJqUo8b8qgrMACmxWghT5eCUY3wWMhDmuE4S7eGPYyMckKMyD8oai1KeMlpQHxWXN3LF3sASeYoYPDoGCIjXRvDT89Mkao4viwAuSMsMKDZzUeTdfhPSN45aGhs4yqnekMT8ypblp18EmlGeohLZanp+zCQvdb9RZ3HvWqaqr9xKlLv0+o+tE7vd8SzaRwNXjDv4mdOmQTEYDFnd/Vc1TSTGKaF+sz6bYEGLgfPPzsY8VHYkgTVCzYiSSforcmOg6fS5ZQzeqAUYdymCYLnd592GkIsOS8DzeLYsTaFbgzlTSPGdDZMnKTp/NDdacQdcD2+dN2nxOf5P3GrtOTmQZGayXHM0Ie3EZ2+WMUA/drz5sbhbzfcM9lmhVL3nP6T+kgfmXcOrwNDRdfZ75Vbz4xtvafkVWfvQNFh41F3JPk46QG3BA/5vcpy+KFSpQURVNY2O7/xaz6Tm6mqo6vUPbymdlhn6FAxxszSeMnh5up9GLjoMKtCrrIq0WRu9CIUiokBQo9xoSEgkeOUjKgS3vcDhYAIfQNydOYqxIviLX8/8cfCWwEetF3dSxg1iVPbpTpL/8JC7QX2BkDQZBH0GybcIt0koY3zDB4X2Ka3Xe/C1y8zWb87U4oUzxBzP9aQi4A27U7zUJXzULtcWrMpLqG4PD3sPxqk
 KWgRcU2u
 DqCi8+Cg6JXT7AGDdOl0izAw+WvblI3WmjpKLd0OTlfmYCeC2DM/02nDC/lYykHIcmluqZTnNIX4oa/1msVo0LkL1HvWLyka+tjtZhxFZ4qLFTgtsjGowo0R2dmgDwQNUxQUzpg1a7ynX/nq2BjS8zIBdZarnIaOy0atAV7bbCrkagJyS6XntVkkpJ5IJiAYLkTzaWP10LF6HwDNpFzMJgzRcGeOm4QFokUWfEt0iZupgH3b5Nl0KvW/KSLozAqQiCpdV3HZPTwTIogkSNmwosp3EyduORzQShoiBWwpc63SMxJ2NyA2JGUykf+578rCvMBnaFtknvGj8n7f3sNK/GpILMnROxMe06X1eFT4/dLS5D5IIawN9zOYUSvBkILdGljFZjNhIlwkv/VPJyRP3ht4O2t0Fzdx8qG9k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

On 04/11/26 10:20 pm, Mike Rapoport (Microsoft) wrote:
> Bootmem areas are sized from overlapping views of the memory reserved in
> memblock:
> 
> * the global area is sized from all reserved memory, including memory
>   allocated on specific nodes, so on NUMA systems everything allocated
>   on a node is accounted in both the global area and the area of that
>   node.
> * per-node sizes are calculated after the lowmem and the global areas
>   are reserved. With CONFIG_NUMA=n all memblock regions belong to node 0,
>   so the lowmem and the global areas are accounted in the size of node 0
>   area and scaled once again.
> 
> As a result, bootmem is about twice bigger than it should be on NUMA
> systems and about four times bigger with CONFIG_NUMA=n. On small systems
> reservation of the bootmem may fail and then KHO gets disabled.
> 
> Make the areas cover separate parts of the reserved memory: the lowmem
> area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node areas
> cover allocations above it on each node and the global area covers
> allocations that are not bound to any node. Calculate all sizes before
> reserving any of the areas.
> 
> With CONFIG_NUMA=n the global area becomes empty and it is not reserved.
> 
> If ARCH_LOW_ADDRESS_LIMIT covers all memory, as may happen on arm64, any
> area can serve lowmem allocations, so don't reserve the lowmem area.
The documentation still describes the old layout says __there is always
a boot memory region per node plus one for node-less allocations__,
which stops being true as soon as the global or the lowmem area is
empty, and the lowmem area is not mentioned at all. So please update the
documentation as well.

Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>

> 
> Bootmem sizes in MiB in x86 QEMU VMs, before -> after:
> 
>                      CONFIG_NUMA=y     CONFIG_NUMA=n
>   1G,  1 node         176 ->   92       320 ->   80
>   4G,  1 node         508 ->  332      1264 ->  316
>   16G, 2 nodes       1268 ->  704      2944 ->  736
>   32G, 4 nodes       2296 -> 1224      5196 -> 1300
>   64G, 4 nodes       4344 -> 2248      9664 -> 2420
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Kexin Liu <liukexin@kylinos.cn>
> Reported-by: George Guo <guodongtai@kylinos.cn>
> Closes: https://lore.kernel.org/all/20260904025101.9959-1-dongtai.guo@linux.dev
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/all/20260922131217.698809-1-sourabhjain@linux.ibm.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 93 ++++++++++++++++++++++----------------
>  1 file changed, 54 insertions(+), 39 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 5b1797d1289c8..c4b697a612f67 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -685,6 +685,7 @@ static unsigned int bootmem_scale __initdata = 200;
>  static phys_addr_t bootmem_size_global __initdata;
>  static phys_addr_t bootmem_size_pernode __initdata;
>  static phys_addr_t bootmem_size_lowmem __initdata;
> +static phys_addr_t bootmem_size_node[MAX_NUMNODES] __initdata;
>  
>  static int __init kho_parse_bootmem_size(char *p)
>  {
> @@ -754,29 +755,58 @@ static int __init kho_parse_bootmem_size(char *p)
>  }
>  early_param("kho_bootmem", kho_parse_bootmem_size);
>  
> +static phys_addr_t __init reserved_mem_size(phys_addr_t limit, int nid)
> +{
> +	return memblock_reserved_kern_size(limit, nid) -
> +	       memblock_reserved_hugetlb_size(limit, nid);
> +}
> +
> +static phys_addr_t __init bootmem_scale_size(phys_addr_t size)
> +{
> +	return size * bootmem_scale / 100;
> +}
> +
> +/*
> + * The lowmem area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node
> + * areas cover allocations above it on each node and the global area covers
> + * allocations that are not bound to any node.
> + *
> + * The reserved memory on a node and the total reserved memory include
> + * lowmem, so it is subtracted from both.
> + *
> + * If ARCH_LOW_ADDRESS_LIMIT covers all memory, any area can serve lowmem
> + * allocations and there is no lowmem area.
> + *
> + * All sizes must be calculated before any area is reserved, otherwise the
> + * areas reserved first will be accounted in the sizes of the others.
> + */
>  static void __init bootmem_size_update(void)
>  {
> -	/*
> -	 * If fixed sizes are not provided via command line, calculate them now.
> -	 * Remove HugeTLB allocations from it because they never get allocated
> -	 * from bootmem.
> -	 */
> +	int nid;
> +
>  	if (bootmem_scale) {
> -		phys_addr_t size;
> -
> -		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
> -						   NUMA_NO_NODE);
> -		size -= memblock_reserved_hugetlb_size(ARCH_LOW_ADDRESS_LIMIT,
> -						       NUMA_NO_NODE);
> -		size = size * bootmem_scale / 100;
> -		bootmem_size_lowmem = size;
> -
> -		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						   NUMA_NO_NODE);
> -		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						       NUMA_NO_NODE);
> -		size = size * bootmem_scale / 100 - bootmem_size_lowmem;
> -		bootmem_size_global = size;
> +		phys_addr_t low_limit = ARCH_LOW_ADDRESS_LIMIT;
> +		phys_addr_t lowmem, global, size;
> +
> +		if (low_limit >= memblock_end_of_DRAM() - 1)
> +			low_limit = 0;
> +
> +		lowmem = reserved_mem_size(low_limit, NUMA_NO_NODE);
> +		global = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE);
> +		global -= lowmem;
> +
> +		for_each_node_state(nid, N_MEMORY) {
> +			size = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, nid) -
> +			       reserved_mem_size(low_limit, nid);
> +			bootmem_size_node[nid] = bootmem_scale_size(size);
> +			global -= size;
> +		}
> +
> +		bootmem_size_lowmem = bootmem_scale_size(lowmem);
> +		bootmem_size_global = bootmem_scale_size(global);
> +	} else {
> +		for_each_node_state(nid, N_MEMORY)
> +			bootmem_size_node[nid] = bootmem_size_pernode;
>  	}
>  
>  	/*
> @@ -785,24 +815,9 @@ static void __init bootmem_size_update(void)
>  	 */
>  	bootmem_size_lowmem = round_up(bootmem_size_lowmem, BOOTMEM_ALIGNMENT_BYTES);
>  	bootmem_size_global = round_up(bootmem_size_global, BOOTMEM_ALIGNMENT_BYTES);
> -}
> -
> -static phys_addr_t __init bootmem_size_node(int nid)
> -{
> -	phys_addr_t size;
> -
> -	if (bootmem_scale) {
> -		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						   nid);
> -		/* Do not count HugeTLB pages. */
> -		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						       nid);
> -		size = size * bootmem_scale / 100;
> -	} else {
> -		size = bootmem_size_pernode;
> -	}
> -
> -	return round_up(size, BOOTMEM_ALIGNMENT_BYTES);
> +	for_each_node_state(nid, N_MEMORY)
> +		bootmem_size_node[nid] = round_up(bootmem_size_node[nid],
> +						  BOOTMEM_ALIGNMENT_BYTES);
>  }
>  
>  bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> @@ -899,7 +914,7 @@ static void __init kho_reserve_bootmem(void)
>  	 * memoryless nodes, as we can not allocate bootmem areas there.
>  	 */
>  	for_each_node_state(nid, N_MEMORY) {
> -		if (kho_reserve_bootmem_area(bootmem_size_node(nid),
> +		if (kho_reserve_bootmem_area(bootmem_size_node[nid],
>  					     MEMBLOCK_ALLOC_ACCESSIBLE, nid)) {
>  			pr_err("Failed to reserve nid %d bootmem\n", nid);
>  			goto err_free_bootmem_areas;
> 

-- 
Regards,
Mukesh Pilaniya


