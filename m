Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E690606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GjnZ+Jyl
Received: by kanga.kvack.org (Postfix)
	id 3E60D6B05B1; Thu, 26 Nov 2026 08:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3970E6B05B3; Thu, 26 Nov 2026 08:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC0F6B05B4; Thu, 26 Nov 2026 08:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD57C6B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:02:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57B85A044D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:02:12 +0000 (UTC)
X-FDA: 85477283304.24.AAAB9F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94775C000E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:02:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjnZ+Jyl;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795698130;
	b=zyvl2Xw1HykyHClZJow97p85Yw91DvF87PsK58wMkOsPyvep2U/JDuFgx6fgSf6ganlbNs
	pl1i6QZwbtjDSdKNnPULahA+uldo35RW9DU0CwGKX6FsgNsfRNerPlnSBZYpBt+YDp8GWT
	RiYFGx7XJYpwx0IJeg9tT9RF7U0rwMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795698130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JNZtgNBPSxn7bvj4efWeLJ9UQDdmYpN2fvka3yysKZk=;
	b=N4pbui/sKBG4sW/asnsrH1hUlqa7tMOLkFgF2/WMY6hGT8NLPSowQe+DSYPBV48TBjmRgO
	dFux+T8or7R7OMfm77HrIYDMfEoAKP+SnKHfp6mY6wGDuHJQZH3MgloTAXarU5sCwflvBE
	OArRrk4rTecy+VMD4DM1iGXas6P3Qog=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjnZ+Jyl;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6BFD414F3;
	Thu, 26 Nov 2026 13:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02E81F000C0;
	Thu, 26 Nov 2026 13:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795698129;
	bh=JNZtgNBPSxn7bvj4efWeLJ9UQDdmYpN2fvka3yysKZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GjnZ+Jyl/pFPw28aJ1N62SXh98WagAz6GlzjVpESIPTdRhJomCTQIoNHgrN2co06S
	 pZhNokVEkj0S7Zb1qf/xYTAnPAY/vnU8tdFYlCk2Km5tbv5V9CJVS64Ek7Mb2etD3w
	 MwN76Y3jCjwbecfl2LklxHFoQA532q5CJT9nO8EAWvS+TmWBAdCUq02X0jsPKHfHzp
	 svYa/Dc6GOA//f0HfOgffGb3qeTXa/cOjx6QIPq522ifrqd7/iH1iAHbEbrnW4ODUb
	 n+ZR9VtGehQqArlc2Dxf9VN5EmkKv3ywj4I/koKnGEqhuOgi5mAEBuKeJ9vL14J2fs
	 XY0UPEDs67TPA==
Date: Thu, 26 Nov 2026 15:02:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: me@amir.fyi
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <edumazet@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] mm/mm_init: don't shrink large system hash tables below
 low_limit
Message-ID: <awgtymEawotNXV8f@kernel.org>
References: <20261123-mm-hash-low-limit-v1-1-8a803aa8ac70@amir.fyi>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123-mm-hash-low-limit-v1-1-8a803aa8ac70@amir.fyi>
X-Rspam-User:
X-Rspamd-Queue-Id: 94775C000E
X-Stat-Signature: g7frkc5a95i65jktna766m5padw1q9a1
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795698130-954644
X-HE-Meta: U2FsdGVkX19sEVPqdlRJhbD5ClVdRNpTtzeimnZxEHihgvKTZ1A2nTMjro2S48g5hlaxeQUw9NKFJQIqZuqxmP3xoUBJgxbAQSLvYcVAWI7lDuAHB308tdYK01tLZsJWHcq5h/7sAhyQmWNsxVZcZ7qVG+CGsPfW69SDMso8C1iCsZL2w8V2915Bab7QRnMHVJdGX39LHW6D4woDEL1xSgaI4AyK4lsjPDbGPpmaSs3Dyu0ZM9Xujfbqw8GZLSQApZAR5rcPiJ/FRUDtGaw6gAu7nEZSecBWXhXHqYAxO9kQcWXSlztPJr5CxzBsOdEvp+h+hTNr7FeN3cU/DwbCJWedrPQT1sCbGzJyfb+LrEfbOb0QNLSbyjuDJBi1sDyJPBh3qAnnC4poQCeaZAKRanQY+/Wl9hJnMc4cOJdD1/etDPv6EQLfxccosnhmj9pP0TwoxnJXBio33RFZ873n5OtaSPdKstwKU1No1ujy50HRxrXEEY8zNnKPJdhJe3al3Y9LmgwfLdJ4QyuntQhkFRKmtsBYlxMt0toa4vqpPLdhEkWMjVFuKKMFvfRIGhIpW3xjeL7RZTiR3S88Abm7JBf8qKxT5bXfhm0EtneTRRM+2LxGiB8E4soDU8B9TNLmtp7VQXNbkw8pbH+8n7nadjzcO9ewYcxzohwhh3w3JL6oQbRQchIXi82vf+FYO20fK8XVrqkmbPjhyzk7lLltBYdDBPERFu9miEHFsPY1+wc0CGo9FvmdPJhJvZhkVencsdgDFNvH2dURjkbm+GycoWjbpqiF42gNA3q3duSr72HxKszKxarJGyEYqB5v8zD0EgBNULsgiAtraWQz3s6VYZnRnfJAetTQC7Jjw6jv47rQeg6WfhaFFEdTQtUJPWgdwH8aiYYk1nudv2Ie2WoOmqQQDg6zyD2mUJ33Z0VhHESo8qM8MTH3Mc4jKuRqR73LOP6fbSbVrF702dv7bcz
 p33EOAod
 SIPjAmIfaH2LMPTcH0WE6WR8mGnEMryjimiuie2DVXuNsMHU/Oc1xJtefmHe8wfQyprZfgUJkXr3hfd/sxxqY3LpJ4SLpau0Lg23A0sTyOsoIyUinZ2iY8ydFxrGPRSDOktIuxL0ymfav3oXwHrgQX67byoqvHMQPlbdCajGtyTbBi5XcLqru+sSz5SY46iGhG0xhlxO37k5rjZIQCllQ6JaC9jzOY0niShhSrHEbJpyUZKNIBqf95xHd7nx4IJOsqUTUVYNf5Cu4Zgil19hKh6nUOMUiyoxecB8R5tUU8H7Z2mZBEblWjnHH5uFSnMXceYG5ZZVt6iPwHIS5ARcY5Isi1uOjkw+ptvgnL+K5n0KIL4CVWdfJRBXHaw67jt14xyo5ES8DeHQdXiugkVMNtcwzdQ2t0IxAIJglgIvmUO4E0uKlPimJiK0UpG3UyUttwkDEe5H0xEMstgw+cmuU8QNASvrwAEYZkWNAnDgbIJ9Y/bmAp+nU3H6O9389kZLuTyFkXE8v3CrvyIq6/+81REdz9ipvy6ksfztpOe6EVz6c7Ls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(added Christian)

On Mon, Nov 23, 2026 at 08:15:49PM +0000, Amir Hosseini via B4 Relay wrote:
> From: Amir Hosseini <me@amir.fyi>
> 
> When an allocation fails, alloc_large_system_hash() halves the table and
> retries until it is down to a single page.  It does not stop at
> low_limit, although commit 31fe62b95866 ("mm: add a low limit to
> alloc_large_system_hash") added low_limit precisely so that callers need
> not check the size they get back.
> 
> The TCP source port perturbation table depends on that.  It passes
> low_limit == high_limit == INET_TABLE_PERTURB_SIZE and neither
> _hash_shift nor _hash_mask, so it cannot learn the real size, and
> __inet_hash_connect() fills and indexes INET_TABLE_PERTURB_SIZE entries.
> On a single node system hashdist is off and the table needs one order-6
> GFP_ATOMIC allocation.  If that fails, e.g. because most memory was
> reserved for HugeTLB at boot, the situation commit e67b72b90b7e ("tcp:
> use alloc_large_system_hash() to allocate table_perturb") was meant to
> handle, the table is silently halved and the first connect() writes up
> to 240 KiB of random bytes past its end, typically into the TCP
> established hash table:

This is hard to read :/
 
>   Table-perturb hash table entries: 32768 (order: 5, 131072 bytes, linear)
>   ...
>   Oops: general protection fault, probably for non-canonical address 0xe480dbf6b420b3d9: 0000 [#1] SMP KASAN
>   RIP: 0010:__inet_lookup_established+0x168/0x5d0
>   Call Trace:
>    <IRQ>
>    tcp_v4_rcv
>    ip_protocol_deliver_rcu
>    ip_local_deliver
> 
> Stop halving at low_limit.  If the linear allocation still fails, retry
> the same size with vmalloc_huge(), which this function already uses for
> tables that are too large for the page allocator or when hashdist is
> set, and which does not need physically contiguous memory.  If that
> fails too, panic as before.

So, AFAIU the gist is here is that page allocator fails, let's fallback to
vmalloc_huge().

The large hashes are normally allocated at boot time when memory is not yet
fragmented, so it's very unlikely that page allocator would fail.

But there is another question: do we really need physically contiguous
memory for the hashes we get from alloc_large_system_hash()?

AFAIU, we can just drop the alloc_pages_exact() case and keep memblock for
HASH_EARLY and vmalloc_huge() for the rest.

Eric, Christian, what do you think?
 
> Reproduced on v7.4-rc4 in an x86_64 QEMU guest (virtme-ng, 1 node,
> KASAN) by failing just that allocation with CONFIG_FAIL_PAGE_ALLOC and
> fail_page_alloc=1,100,<space>,1, where <space> was measured with the
> kmem:mm_page_alloc tracepoint so that the one injected failure hits the
> Table-perturb allocation.  Without this patch the table is halved and
> the kernel crashes as above on the first connect(); with it the table
> keeps 65536 entries (vmalloc) and the system works normally.
> 
> The reproducer and fix were developed with the help of Claude Code.
> 
> Fixes: 31fe62b95866 ("mm: add a low limit to alloc_large_system_hash")
> Cc: stable@vger.kernel.org
> Signed-off-by: Amir Hosseini <me@amir.fyi>
> ---
>  mm/mm_init.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index d99af80ec752..418068bad006 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2359,6 +2359,7 @@ void __init page_alloc_init_late(void)
>   * - it is assumed that the hash table must contain an exact power-of-2
>   *   quantity of entries
>   * - limit is the number of hash buckets, not the total allocation size
> + * - the table has at least low_limit entries, callers may rely on that
>   */
>  void *__init alloc_large_system_hash(const char *tablename,
>  				     unsigned long bucketsize,
> @@ -2371,7 +2372,7 @@ void *__init alloc_large_system_hash(const char *tablename,
>  				     unsigned long high_limit)
>  {
>  	unsigned long long max = high_limit;
> -	unsigned long log2qty, size;
> +	unsigned long log2qty, min_log2qty, size;
>  	void *table;
>  	gfp_t gfp_flags;
>  	bool virt;
> @@ -2420,6 +2421,7 @@ void *__init alloc_large_system_hash(const char *tablename,
>  		numentries = max;
>  
>  	log2qty = ilog2(numentries);
> +	min_log2qty = max(order_base_2(low_limit), 1);
>  
>  	gfp_flags = (flags & HASH_ZERO) ? GFP_ATOMIC | __GFP_ZERO : GFP_ATOMIC;
>  	do {
> @@ -2445,7 +2447,19 @@ void *__init alloc_large_system_hash(const char *tablename,
>  			table = alloc_pages_exact(size, gfp_flags);
>  			kmemleak_alloc(table, size, 1, gfp_flags);
>  		}
> -	} while (!table && size > PAGE_SIZE && --log2qty);
> +	} while (!table && size > PAGE_SIZE && log2qty > min_log2qty &&
> +		 --log2qty);
> +
> +	/*
> +	 * Shrinking below low_limit would break callers that size other data
> +	 * from it, so fall back to vmalloc, which needs no contiguous memory.
> +	 */
> +	if (!table && !virt && !(flags & HASH_EARLY)) {
> +		table = vmalloc_huge(size, gfp_flags);
> +		virt = true;
> +		if (table)
> +			huge = is_vm_area_hugepages(table);
> +	}
>  
>  	if (!table)
>  		panic("Failed to allocate %s hash table\n", tablename);
> 
> ---
> base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
> change-id: 20261123-mm-hash-low-limit-37a3a47c7cd1
> 
> Best regards,
> --  
> Amir Hosseini <me@amir.fyi>
> 
> 

-- 
Sincerely yours,
Mike.

