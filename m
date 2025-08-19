Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF50FCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 16:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914EE6B0095; Tue, 19 Aug 2025 12:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC646B0098; Tue, 19 Aug 2025 12:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829586B0099; Tue, 19 Aug 2025 12:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1876B0095
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:54:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 146AE82258
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:54:29 +0000 (UTC)
X-FDA: 83794105458.17.BFE0B37
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5B89A4000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:54:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755622467; a=rsa-sha256;
	cv=none;
	b=xs9ORzBbCU24KBoule1t+OX1kcKO42SkC0MMzziKtxDALIiPWSms9fCB9Bw6I/2FTSXB0o
	9YcGLSGztKTefk7vceA1qrxzq7KtGBlD+8hpiGcwysbndzy2gx0LiaCSMFUfBeIAxN4+Y2
	E4g0S+31JqXb9uwyXc9gGVYheHpGy28=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755622467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XXQj/HccKCGNHywgKK4+dHg6ukp8mpGdH3uFFgSC6ss=;
	b=vORZ1ixJupVSU+u6xSQ5XCGp7bYECLzvde69X9mfYr+lgfcH7TCLR+L1/RhEKfdvsqdt2I
	0zwT9MBBuOmH2a4TfbLrdfrJZ4zA7i31RbizAE9INOoMvDJZ+r0gCRSAKbGJDvqN/Bv7Wx
	ua7J4OzycMzx/LiDYuhIv6jN6FCyN2k=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c5wZy4t9jz6L5BV;
	Wed, 20 Aug 2025 00:51:22 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 3FAA61402F2;
	Wed, 20 Aug 2025 00:54:23 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 19 Aug
 2025 18:54:21 +0200
Date: Tue, 19 Aug 2025 17:54:20 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <shiju.jose@huawei.com>
CC: <rafael@kernel.org>, <bp@alien8.de>, <akpm@linux-foundation.org>,
	<rppt@kernel.org>, <dferguson@amperecomputing.com>,
	<linux-edac@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, <tony.luck@intel.com>,
	<lenb@kernel.org>, <leo.duran@amd.com>, <Yazen.Ghannam@amd.com>,
	<mchehab@kernel.org>, <linuxarm@huawei.com>, <rientjes@google.com>,
	<jiaqiyan@google.com>, <Jon.Grimm@amd.com>, <dave.hansen@linux.intel.com>,
	<naoya.horiguchi@nec.com>, <james.morse@arm.com>, <jthoughton@google.com>,
	<somasundaram.a@hpe.com>, <erdemaktas@google.com>, <pgonda@google.com>,
	<duenwen@google.com>, <gthelen@google.com>, <wschwartz@amperecomputing.com>,
	<wbs@os.amperecomputing.com>, <nifan.cxl@gmail.com>, <tanxiaofei@huawei.com>,
	<prime.zeng@hisilicon.com>, <roberto.sassu@huawei.com>,
	<kangkang.shen@futurewei.com>, <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v11 1/3] mm: Add support to retrieve physical address
 range of memory from the node ID
Message-ID: <20250819175420.00007ce6@huawei.com>
In-Reply-To: <20250812142616.2330-2-shiju.jose@huawei.com>
References: <20250812142616.2330-1-shiju.jose@huawei.com>
	<20250812142616.2330-2-shiju.jose@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.66]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Queue-Id: 5B89A4000F
X-Stat-Signature: jb3j64d3rrtbukckqu7cqzxu5dzgbeop
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755622466-201205
X-HE-Meta: U2FsdGVkX19r2O1i0fu6ZbrHcnG3bmAtsDsTQCuhnzZTDqe/fArUjAgy/a8pkYZAXx2DDeeIFqylen5oTdvbauyuxO/gwyeb8vm+VI5uj8iDVJhBzkKuHLpzuKqeGXYY9T1U0eKTjxFzo5oOkzMTs+gR469BatV7XNlIdtW8LcjGipPuusgWHtNwnplguha7uKLZFhdsnXdG/8wrQTHCtFfEOKCTg+goDEGFQEmA3EbqNZ72/cbuHzYQL5juiB7t9hiZfuMnBhmQGYce0R5+EQ4MosxcVhfGaZM7ira575eALutyD4I0oHuBybLFT0x6MR2pmyuPO59uyyHjjynCNJJLGPkAO1Iex/r/qpX82Pi1va4H6GrIQjCx0btTAYYvbX/XIWfknhaAW/SOzke8QOYTx+RuESzWK7XIDmoXqND8laAYTipGN12pVXyowHdKGwjO6TGS1smwS4FlgWtUnAhrzlYQn2enD+V5WgxVV6j2hp+CoR3FQhkXq85VEhG6r7GtOSXBmBvcg6xjYuqZyYnSr9ZMijLCf/BWkOzzmi1FOjvAwhGN804L4EJB+ZCn2aAUMnTTZNFc9C17mBipVm7BDLBg0NIjlA7KevMVpAtO3JY57XQsa3Ye1Qqh1RJwcZ80qAqsEU0VJQWAY+fmiZh4s5fmC3sRcvLUNUJL8nK+1TsKzhrc/Hfz9G1wlg56rzOZZZpC5/md5j/SCDt67rEDRc4dQu2QdxL1Zrl4gxpszqmoNIpIxZfnw0ZnOZyAGTsMP22lbuZRDSm08S1qsX8InJlfPgMWtXqmvWkTphFJnv156W6dWHekUGOLktul6FgxTols9WieNRv/YUfGvf0MUAEDtgX8ejiNUkjy1pw+VgZBqj7sFzDxdFMVB1+TrG+WrAmEHKNsWMcZ8kB/aADIsWVdlYMo6OxniU4Ve3BKNGjaVAhA81y67H13dgoHce+ljxuM7CnNgUmo+m+
 JYm00e9D
 E547oOpivABJAC1orxt9+DDpxUIPWiIUX2bWX2eFySq7+HcsSRf8G5Wo3F/n5j8iLeNwpgSJDxxPlMXV/n0mCYAf5m5rY/6EyQ5QpnP4zb5fjTzRt0t31z3UbBO1EA8+J6nrK75HIoXXkoWB9uY4R2kC4XkxHhVqQTNOEMBNoN1rXVmDzm4JZ4nfqjBr0APXKkLcCja07u93Ox7SiBCfePC/lBLRhuat+3/cIHVKnt1+Nno1XPG3HRQtBn4JPtRWo8lwil5n/5gbHVD8aNQKtJBoZSzMm40qIJ8uQXmC3d0T51h8nWCUbKyOdnM7nm4Qgy2WpbJBAMaU9fkblz3j54pnm3yhEEhNHqVzMZ9Um4voANJ3Ogf6NZEctZ9pogYpJQN7C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 15:26:13 +0100
<shiju.jose@huawei.com> wrote:

> From: Shiju Jose <shiju.jose@huawei.com>
> 
> In the numa_memblks, a lookup facility is required to retrieve the
> physical address range of memory in a NUMA node. ACPI RAS2 memory
> features are among the use cases.
> 
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Shiju Jose <shiju.jose@huawei.com>

Looks fine to me.  Mike, what do you think?

One passing comment inline.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  include/linux/numa.h         |  9 +++++++++
>  include/linux/numa_memblks.h |  2 ++
>  mm/numa.c                    | 10 ++++++++++
>  mm/numa_memblks.c            | 37 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 58 insertions(+)
> 
> diff --git a/include/linux/numa.h b/include/linux/numa.h
> index e6baaf6051bc..1d1aabebd26b 100644
> --- a/include/linux/numa.h
> +++ b/include/linux/numa.h
> @@ -41,6 +41,10 @@ int memory_add_physaddr_to_nid(u64 start);
>  int phys_to_target_node(u64 start);
>  #endif
>  
> +#ifndef nid_get_mem_physaddr_range
> +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end);
> +#endif
> +
>  int numa_fill_memblks(u64 start, u64 end);
>  
>  #else /* !CONFIG_NUMA */
> @@ -63,6 +67,11 @@ static inline int phys_to_target_node(u64 start)
>  	return 0;
>  }
>  
> +static inline int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> +{
> +	return 0;
> +}
> +
>  static inline void alloc_offline_node_data(int nid) {}
>  #endif
>  
> diff --git a/include/linux/numa_memblks.h b/include/linux/numa_memblks.h
> index 991076cba7c5..7b32d96d0134 100644
> --- a/include/linux/numa_memblks.h
> +++ b/include/linux/numa_memblks.h
> @@ -55,6 +55,8 @@ extern int phys_to_target_node(u64 start);
>  #define phys_to_target_node phys_to_target_node
>  extern int memory_add_physaddr_to_nid(u64 start);
>  #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
> +extern int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end);
> +#define nid_get_mem_physaddr_range nid_get_mem_physaddr_range
>  #endif /* CONFIG_NUMA_KEEP_MEMINFO */
>  
>  #endif /* CONFIG_NUMA_MEMBLKS */
> diff --git a/mm/numa.c b/mm/numa.c
> index 7d5e06fe5bd4..5335af1fefee 100644
> --- a/mm/numa.c
> +++ b/mm/numa.c
> @@ -59,3 +59,13 @@ int phys_to_target_node(u64 start)
>  }
>  EXPORT_SYMBOL_GPL(phys_to_target_node);
>  #endif
> +
> +#ifndef nid_get_mem_physaddr_range
> +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> +{
> +	pr_info_once("Unknown target phys addr range for node=%d\n", nid);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nid_get_mem_physaddr_range);
> +#endif
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 541a99c4071a..e1e56b7a3499 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -590,4 +590,41 @@ int memory_add_physaddr_to_nid(u64 start)
>  }
>  EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
>  
> +/**
> + * nid_get_mem_physaddr_range - Get the physical address range
> + *				of the memblk in the NUMA node.
> + * @nid: NUMA node ID of the memblk
> + * @start: Start address of the memblk
> + * @end: End address of the memblk
> + *
> + * Find the lowest contiguous physical memory address range of the memblk
> + * in the NUMA node with the given nid and return the start and end
> + * addresses.
> + *
> + * RETURNS:
> + * 0 on success, -errno on failure.
> + */
> +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> +{
> +	struct numa_meminfo *mi = &numa_meminfo;
> +	int i;
> +
> +	if (!numa_valid_node(nid))
> +		return -EINVAL;
> +
> +	for (i = 0; i < mi->nr_blks; i++) {
> +		if (mi->blk[i].nid == nid) {
> +			*start = mi->blk[i].start;
> +			/*
> +			 * Assumption: mi->blk[i].end is the last address
> +			 * in the range + 1.

This was my fault for asking on internal review if this was documented
anywhere. It's kind of implicitly obvious when reading numa_memblk.c
because there are a bunch of end - 1 prints.
So can probably drop this comment.

> +			 */
> +			*end = mi->blk[i].end;
> +			return 0;
> +		}
> +	}
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(nid_get_mem_physaddr_range);
>  #endif /* CONFIG_NUMA_KEEP_MEMINFO */


