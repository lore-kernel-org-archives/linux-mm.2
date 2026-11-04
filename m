Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6ABC606A338
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=W32vtbGR
Received: by kanga.kvack.org (Postfix)
	id 4D5626B05B4; Wed,  4 Nov 2026 13:57:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486286B05B5; Wed,  4 Nov 2026 13:57:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375786B05B6; Wed,  4 Nov 2026 13:57:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8356B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:57:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CCDEA852B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:57:12 +0000 (UTC)
X-FDA: 85398344304.18.D9651B5
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9E5C5A000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:57:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W32vtbGR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793818630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDac3SJ3sAacdSf0W+GWhjMPaQx0+h6n24uVhknSWmw=;
	b=XxAqAw8LN3IUVPqt6G63Qk1BR07t83/jngyrmZIrVWdZNRPMdVPXMD9Urst/Oq5Lu945Lq
	gJqECqMuBEBGe5790opn0PwjV00s+qid5GyUjH3cCcrcJCKp4ITTpKR2e2+3aVi+AQA4oW
	OqWSmZBvixku8dP7LaP18rIS77MwTVQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W32vtbGR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793818630;
	b=OdE2NUw2qkN9WekfCdCb8zSMaz0ylaBwCj1hkbApwyoq1cdLj1Pcc2P8g1bp7dp7g60vE5
	TuQc3RU1Vva6Cy/a0zcP1ud6jV5aC//VHjQjwmLRM73vLTgNL9ykoKdixVOtDwGTmN/wUb
	D0dA0LI99wXSFBswYBvhUnTpkiAWQpM=
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-9851592ada1so303687241.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793818630; x=1794423430; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iDac3SJ3sAacdSf0W+GWhjMPaQx0+h6n24uVhknSWmw=;
        b=W32vtbGRRBBM+M6R4Gl5kJeN6YAXc7jlC/jMEyr/vnUDXVgLUxCVXPczyEqyluMraA
         rLZRoSCxND6WEs374FK7Bap5XCzkcZ95YIMBJouJRApQ39mEurjDtcTHI1JZkklwSglP
         f9mthXsNpLjyL/u96QTIJtg2Vdvz8FuD4la+tMYPse6VvXP+IovWgQf1Xe3x9cZxkEW2
         GxBZAC5FUMg+skJIEd7ad3XcevywBqI7A4OesjraBjo/5JVRhgZqQhPZIEnUDrShW/8N
         3PNcaKZgtMg5vlhN47nXpjZlobS1MYg2QiybrCts+bziioJE9ZHOD55VKyXBQQ8LIc7h
         4rjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818630; x=1794423430;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iDac3SJ3sAacdSf0W+GWhjMPaQx0+h6n24uVhknSWmw=;
        b=jnh9ccPrqrNA1Cu974Eu+3D9Nm6ZQ9BefmLbFbxPqpt/NVR28QDVGnokRPX80NVC05
         XZO4MJr1N9WtfsxkGaD/Gw8Gabv4KigVaEcXme7lrm4qZTXtPMjIYu/jA1yT346+NjuH
         sjaB3ApAOH6BtEcxr28qeddVIf5PVdeBj4XMcU9ILaX0YdVlOMBl0EBAbsEdGygQrKdx
         /d/GmP8CIyG3VYNHNWfC+HAPXCkeoXWXZE1Hg20Ca5+kvLsZzL7guzUy41jSfJvCVKHL
         hppztPA+3Rm7mGXSUI7bthfE/wP9DWi78aDKixJoCEUSODvtZkadDdU9snXuV2CNdR4u
         VZwg==
X-Forwarded-Encrypted: i=1; AKwUvBwv/Bi9l9XYaiFz+cEsXFgWk5iupedXaBMgyb2UNzsHlJAv29uvjDAStkJRi4d7zAwkFywmFNlxlQ==@kvack.org
X-Gm-Message-State: APuU4Z97DAEoeLySTOp0eBAt8zG9dk2rGbchhAmbfnQnMOh4cZZNwBDq
	JZnXMQMgH0ASps0sshqqI2KWqzrTlszvEfyV9j+hUlC8Q+o91VkoQySxG0ltiyGWVI0=
X-Gm-Gg: AYBFou0c/E2q/fNJWUe+dVgtoVWR4YQxilBW0Inrbg/Kf7gNqfYghPl0VSqQ/QKpDFi
	hXPlv0vM2Zzr92BNNR79BJE5mnmwA2wsALfvd2jHA25poIZ3WQElgrLOsSEDHDOf8i7X2YHobNx
	Refkh2X6pp4I0vcJUNoayJErTtUoKb9Zv3iM/tCFsWftpj5GtnMHDrvQU4XV2llyvWk7ZBi0ULt
	hwuPhAj4uHXLmEhYatR6GbR9OAnyO4lqpiCR5x0Eiw5Z/LgXtx6WNqORv29oeiUzt6SpRoZ/Rva
	kf2Q9hLI/svFeXclHP1/KIj1gTYRa6jfTuH9GslVt2G5lYJDTLpnj+N+yzJ91bcyCqTe4hkEHio
	dSNDcmt3gTCubvqYzlDH/PvehoWyVN+P46Z55QH6lJSJHlLKsjld3GRKl8mOnvVHgqbh0d+Xw+6
	sdSmlZcfmAhYbY5dqTAypP+CBLFtTIwqkH97hBpqZ7pWC6dy7k4hdcWZlZx+6e/tY5UAmJxFhqi
	uyZGOJ0qGiriiDB4N7Kc3vaZuDmIVessS3f2Cz2tJmfEqucdGRyCPVOEfFwytBaDQMBapvRAqfQ
	UJeDd5h1i+oO9zXpNnHhYPN1UbH+jfN2/qc+xPAG9+DRK1X8yNuJdLKnBwrmes8s3x8RmIaxaRS
	hVpe8AHZFZ23EzcJgadW3R62gg4mczZTWfTexipIX/w7y
X-Received: by 2002:a05:6102:3f8b:b0:7b5:4700:3a6a with SMTP id ada2fe7eead31-7d07267f972mr6534578137.26.1793818629622;
        Wed, 04 Nov 2026 10:57:09 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-999f3006224sm736210241.9.2026.11.04.10.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:57:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 3/3] kho: fix bootmem sizing
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
Date: Wed, 04 Nov 2026 13:57:03 -0500
Message-Id: <179381862329.2089669.11972657670874869389.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6733;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=8NqiYICk6wvIGUqgp0gIb5QmvDxLmCEuClGbEqhbbDE=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq64ACI6dHufVqtKRAfASZU9NnRUoz33nR3D/hW
 5PGUMiqqByJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCauuAAgAKCRC7dyhM23N6
 3q47D/460EB5pARhfkcmCTGOpBx3BVr9a19rLtkQ6IrAevVjF5Usw/TPnwMpU8Ix3kYcbE2HpHO
 g/wizPi9m2UDvdGZX+7Z/UfLYhxq0nc8wtN95e8YGoDhxZUT6qrSX9Uy8bQE2roqYWqsSF1LJgr
 ZJDQBstGnNLSC8oc36m1rwMPmaewALX69WBBsjBiYxjfscHWjSaiLLhL7g1FMDNf9RxWf79NR7d
 daUDV1DoFeNVbe/o+AcvafKPuZfrbfxtikuln4wO6d/0xM+cOy7o31nTslA1XtaWA9DpqlpyifJ
 bV1NjvAMnKfmwiGFYPH1HBAd6BbWxOEhR4I2aJfD9DT9AhwSqrgZMN+H04cflhGprYEIg2Axsdi
 mWLd/R7OYvsdqeZOOKgL5SUHJ6fzeg1pfefjwn2KFervJjfpBqonfzHoR0+bNG5NPYqmNluH0D5
 wlKiEhcRbG33gj6aQuOrXZeYXyXnn6GMogLZgahuIydGI6HBaCWj2P40bbD7sEK8N+QcRCu7GQT
 6tyG+UwuSRYLuUHCe1BYooIhGvmF+tMXM1kQZpvDfZbaAccsD+sgjbXfA7MrvdyTBxcjNS/nl2y
 5SnK4Y4e909G3Z1kx2p6aqysRv3f0nT0ytC4EmB1JStQWhVaLQHJGiYuNbf2GDPCNn0A84Lvcpr
 zcKUMYSVpL4L+ug==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E5C5A000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: bqcr89h6cteonbxst1y1wpen4a5m3s6f
X-HE-Tag: 1793818630-581903
X-HE-Meta: U2FsdGVkX18/SWtTBwpGCnHshdjmYdPA2RoQExZ833YISV3uKzqm/Ja1O7ncIJbVlwf1oB/15XGATat0i+05CeXUpUrthmFZVhyDcRCJsms32JobfneBf4oZ9zSEkXdSSmIUaFmXtuKIO06i9GC35PrFuI22EsLZbZRhX8qXP5D041l2Rg3cbA1bhQe1yVDWtDCQLnDp0grKvEHYVpRvchX0msL940p+nXbhrjeGkkPERSgIJ+fj86LvKxmGUdU/6RjtrlI5N/vWWDzRiwxz1c7R06M8uIvvbn08hf/fT2wUPfxiS61WuiDbXEQT8gP2M3AxMBzi/w+coj51qjcUpChQ8PvXXS2BTGZogtWvPZjul3w8lprjAULrNc8o/nvx3GvCwSBb5aWAOCNlivTm6Algwemhs4zJimyl4nuhL2sP4Vt+y1sMsfJm1Zs8mU4zY0Pc/yuyJvl2aE1VWb1yabpfgfUN0Hf8kJi6q8bL5ixGqsv2i89ik6gsT2mPMQrXxVCxeiKhozWV4L6ip44oMTQB76wwy/FVSSrpHof0YzYzSfhpzBQdQVlCd++dK8m0fy1e+kkjA1FxtVBJE95ZiCdHQNnQHoywPRh43+CjBisN0plj9lzmiiKI++6RMhORMFsD3DRjr0f3GtLe3+FADxl5o6HMOup10hlhtXvvRBMnLjBuSkqdIEs105/+vLl0yLmwtWkGfZmEh+XFwNhsJajWQUvXGitia/3G553GGmZBK8vJe4Krren6BZUIUCXV4kAkdwny1RZ7ZHKq0usnQKeY8Wgvbqhur8US7wOTCdEOW9I0TuYiYHZkgApF4pmD+3HxuwFv+ziNq9uh/dwo/oGFPgUwt78nT8ZPFXwGhvHG8X+SjCQ/eJnpTHU6CcKvVV87+Fl7srUHKSAjKCr1kNxic4h/Bb7X5B9nhWXJCFpmU6CLm2M6uyzNk6X4k1t9DZ+rmSfyrevFOdtAXBh
 j5lRkDoM
 wEGTYIvAt78wjA/fQSIs/Q+UgHTB6F1Eosng/YiVttKIEw8ieCym7mHcoEYM32Wi8aQ4ZAKDltsbDRKAWjAWRkolMzx5J2oOJTHvIUgW61pCD1hPW6CS3MB6NiqT/DomIk2PDKY2qruRsS9WPSrOeGQnDGWYa2Nrk99EcpgRxtNCDSnG1dnqlhJybT6Hg0NtNK3aiW8xXckxu7ZqlxDHKSGTJ9PGFMTlrZnH28kwOkVoKliIk5RaZd5x7QCM/7Prun8BasSLfM1IT75mSV5sdtmRqhgwUZe104JRePFFoNUKQlxqmlw1k+PRFTSNAeyQM6e9fPzhuxhcroDqPuouGlgOy+kUZQWsBoFOUpx5PfXgV54/0wnqTKSEQb90jNUIBkGkV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 5b1797d1289c..c4b697a612f6 100644
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

Nit, but I prefer to avoid multi-line indented statements without 
braces. Just put a braces around the above.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


