Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CB18E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 06:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548BD6B0088; Mon, 29 Dec 2025 01:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F63A6B0089; Mon, 29 Dec 2025 01:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6016B008A; Mon, 29 Dec 2025 01:56:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAB96B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:56:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71056BDA32
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:56:47 +0000 (UTC)
X-FDA: 84271600854.12.0EE54DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E60D11A0008
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:56:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cUntOqUx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766991405; a=rsa-sha256;
	cv=none;
	b=1COwDtwLZPrJl+eLacRmGohr2GEp83EdrxZqVb1EytXzp6AfdaAqn9qpQqO3IRXdds+TKF
	TXywVX4b1mXFhY4M0CXdDkV7Ff9rdO/jA3R8zeVRXQFEOZNd/G3mxZ606mGRmtCn5CMXN8
	NtLQrdMklv+BiqMTlfBN0mOaCwk3ios=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cUntOqUx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766991405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUQhxxwcd6BVMFmEMYGpfB0bAUQY48KpU7wfuCLlszc=;
	b=q5xb8o9SmCUwa1lMo+T1cnork6bNDRv0QM89RCdcbGhWayBPp7fIPQH0eVUYaKNR3+QZQb
	Ci6imCIVwUksEHMYRAMuXPxJKjfBiuy0+eAqt4IpXHsjNMts6O77B8RohLBu+33l9oc/TW
	HOV9ASbC7/FmQSiMWG3ldxI8ojcM+ns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B8226000A;
	Mon, 29 Dec 2025 06:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BF0C4CEF7;
	Mon, 29 Dec 2025 06:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766991404;
	bh=2L8Mk5WlWQlOwro+lzGpqFESnl7Z8ZzqFs5ya2vJbDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cUntOqUx88jhIghah0BtHV123Tman5cFwnDzVOOMvAYksaJNRnWq3CjmRgean4N04
	 iqBLRzsOdMTU3ApunWnlX+Bxep76Drrj3bbErnOEUHKj70mMeVRFGcbNvY3xbUz2aR
	 WAj1+AQac4O+dn36O7LVQJUH2awM38yGe/04UBJ3WJbWcANLHTDv1LS+mLBD8qIIq5
	 /IsjB1NXRI9IJzDgLplHWc7WmtEBGwCqwThO1YR7/smhHyy8w0NEidVyVyHCbhTFKB
	 ot1wOsmC7rNnr2/wlnCU8Nn7gUTB/bs0BUNZCqANofZZ2Jp49o7HJ6H/nXcX0sXTiN
	 DODwXttylU7BQ==
Date: Mon, 29 Dec 2025 08:56:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
	pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net,
	david@redhat.com, mhocko@suse.com, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 18/26] mm/memblock: Add MEMBLOCK_INSPECT flag
Message-ID: <aVImIneFgOngYdSn@kernel.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-19-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-19-eugen.hristev@linaro.org>
X-Rspamd-Queue-Id: E60D11A0008
X-Stat-Signature: wfwkj6m5f8nz7opseygnbb5q9u87aj5r
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766991405-581532
X-HE-Meta: U2FsdGVkX1/5koZ4oHozMXewW1j2YnSPz6GMne8BrmFt4XeeOCEXvyGq17emzcbuOoPDthO5doU3UVPTUMmumNl1uUKyxgCxTLEttEO21KSZh/8i/pKkGqNZSvkknBtSVeDJPUtrY+pEBzaogmvkpmHO2bq2WZOwDoyZHjPL4JEfbhoJwxkYrEHRmqVuDhRE5/GySuF2TnuB7HeqsyvN1GUghkRdvqc+rf2bPzgxd61ilwOGPvsWqOADoUeOK8es7JOJl9cMnrBXzLYXUgKIX4KLfYjmEmaD25iME/5Gpt3TX1UVESCdzbQnJDk0kzZRc7CFATMw48vxaEoZXwpCs6+yolTFd2Pi3aIkp68LOH9WwweNpRB0/dzTGnRimnjOJflvgyPHXi1qs9adZt3nW9JQbFRzNdtQN+uJ2mLSmyGQno6SAegBSMuQ2Zg21pyiN2gI6uArn6sRTuQjzD5PnMBzBMZBpbeVKJzab79hD4H7UqJIqC803UxCfL1nzwEjlGW5ZIeoIFUe5NuCyGZWb22Sn27pRxNnIhnmFQln5tw5CEZxla9ORfLbQxCS0JU2NxuECqkif4H/PVWrEGmckxgOK3jVJCusw95F4ZuaYu/BAuQJX3cG3h/kcyknsIgBVZ/Xok9UIPKztQYvwTVqyr/ijGLhBOVTBxZVUyuJMn15crLXR04qpz3Ad0Kkks+HiUePYB7iQG19Gs2aZoUzu8ixsGb0qGYcWEp7zRANYIBKrxpiGYS+B6anGSt6zbXwQIZULFhZtjmsWzeGLoEDIbrTXLi+QWnz7euaVO4jzaw/6/O+u5NcZtKW5BIlac4mO4anVzG8fTJCbEyKyOITylheQyPesu9aXq1p5k2/ntBIYREES1HyH67/0qMK+LFvfJAVl+5+lBldidx2D6n/adHNG4C8JM8Oxucgfjza8oL/GGJvLhHDATyT9gbhBJ7vNtPUQ1dT4U+J5cudRpT
 a7jeuMa0
 IhryvTzzmD62nuDEC7+nrFEUJwzm2Umr+lr4Kc0wyj/FDI4evSvqO7J1DciqB9r4w58o7iB2zhReWFGJM+WIYF9G05WC/X/24lARMQtcoSxgWgMADaZAk9Rr1OPgeBKByMGj6goc2zQ4GlrZphl+HGuo6a2HkVs0zG5DlI4vSr1FFiOLAPjtIoE/v3k6540uGSBc1+aJynKLqIvftGDjYF+StJiC1YxJe4+1Tlhc+JLAxVHyM6hYdoa5T10qhfGCTpWoF76D9ukB1WrHr23537tv4JIte2cuBFz6c7hULjMYOOo2PzBjpRezGgaeS3a+whkvECDVW0/bnGsQrNLUKLxzcSuLQEek/cXLiWwYmwH1lqZKpaHKX0RdapGKDTWdM5yknT5Po94rWsy4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eugen,

On Wed, Nov 19, 2025 at 05:44:19PM +0200, Eugen Hristev wrote:
> This memblock flag indicates that a specific block is registered
> into an inspection table.
> The block can be marked for inspection using memblock_mark_inspect()
> and cleared with memblock_clear_inspect()

Can you explain why memblock should treat memory registered for inspection
differently?

> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>  include/linux/memblock.h |  7 +++++++
>  mm/memblock.c            | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 221118b5a16e..c3e55a4475cf 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -51,6 +51,10 @@ extern unsigned long long max_possible_pfn;
>   * memory reservations yet, so we get scratch memory from the previous
>   * kernel that we know is good to use. It is the only memory that
>   * allocations may happen from in this phase.
> + * @MEMBLOCK_INSPECT: memory region is annotated in kernel memory inspection
> + * table. This means a dedicated entry will be created for this region which
> + * will contain the memory's address and size. This allows kernel inspectors
> + * to retrieve the memory.
>   */
>  enum memblock_flags {
>  	MEMBLOCK_NONE		= 0x0,	/* No special request */
> @@ -61,6 +65,7 @@ enum memblock_flags {
>  	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
>  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
>  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
> +	MEMBLOCK_INSPECT	= 0x80,	/* memory selected for kernel inspection */
>  };
>  
>  /**
> @@ -149,6 +154,8 @@ unsigned long memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
>  bool memblock_overlaps_region(struct memblock_type *type,
>  			      phys_addr_t base, phys_addr_t size);
>  bool memblock_validate_numa_coverage(unsigned long threshold_bytes);
> +int memblock_mark_inspect(phys_addr_t base, phys_addr_t size);
> +int memblock_clear_inspect(phys_addr_t base, phys_addr_t size);
>  int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
>  int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
>  int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
> diff --git a/mm/memblock.c b/mm/memblock.c
> index e23e16618e9b..a5df5ab286e5 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -17,6 +17,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
> +#include <linux/meminspect.h>
>  
>  #ifdef CONFIG_KEXEC_HANDOVER
>  #include <linux/libfdt.h>
> @@ -1016,6 +1017,40 @@ static int __init_memblock memblock_setclr_flag(struct memblock_type *type,
>  	return 0;
>  }
>  
> +/**
> + * memblock_mark_inspect - Mark inspectable memory with flag MEMBLOCK_INSPECT.
> + * @base: the base phys addr of the region
> + * @size: the size of the region
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +int __init_memblock memblock_mark_inspect(phys_addr_t base, phys_addr_t size)
> +{
> +	int ret;
> +
> +	ret = memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_INSPECT);
> +	if (ret)
> +		return ret;
> +
> +	meminspect_lock_register_pa(base, size);
> +
> +	return 0;
> +}
> +
> +/**
> + * memblock_clear_inspect - Clear flag MEMBLOCK_INSPECT for a specified region.
> + * @base: the base phys addr of the region
> + * @size: the size of the region
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +int __init_memblock memblock_clear_inspect(phys_addr_t base, phys_addr_t size)
> +{
> +	meminspect_lock_unregister_pa(base, size);
> +
> +	return memblock_setclr_flag(&memblock.memory, base, size, 0, MEMBLOCK_INSPECT);
> +}
> +
>  /**
>   * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
>   * @base: the base phys addr of the region
> @@ -2704,6 +2739,7 @@ static const char * const flagname[] = {
>  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
>  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
> +	[ilog2(MEMBLOCK_INSPECT)] = "INSPECT",
>  };
>  
>  static int memblock_debug_show(struct seq_file *m, void *private)
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

