Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5BA606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBJZ7wYj
Received: by kanga.kvack.org (Postfix)
	id 82A076B05BB; Wed, 11 Nov 2026 04:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAAA6B05BC; Wed, 11 Nov 2026 04:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2166B05BD; Wed, 11 Nov 2026 04:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2876B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:28:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF53DC025C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:28:02 +0000 (UTC)
X-FDA: 85422311604.01.7A1096C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 141D6180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:28:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KBJZ7wYj;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0aZ1tfcJ/Ty94l1h2AbQVLEmxVEaAa3uZWU0teerOA=;
	b=b4MejP4rTePv3v7LWNebW5GF0zbY+vPPEwkVCJwYbU4QP5zraX4cYab8Oaz99I7y04/kSL
	IZLEpVvYU30/T1wlUUdsLyVfIgY/Fkuy17offTZuPIPHItfVz8uNVirOntWbGYNuUyusCw
	4PQpnuvdSH8xuy8CqdOVRLaptarVrR8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KBJZ7wYj;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389281;
	b=hCdxYB+E2ZtxpnSGxMIKts6wtEuQitevZ1NZpFSYcUk8I3p9UwOQZtd+AiHIUE6WqQSZMp
	HTAoDgQPuF5m3AGLruCMc36Fwbw6H+EgK876Gvyx0gsuv4N3WTZjC/WHBAovr/AZkIVd/O
	qAsRyZ4ArM91EcGfFeb23e4hA2eRiHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 010CC608FB;
	Wed, 11 Nov 2026 09:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B651F00A05;
	Wed, 11 Nov 2026 09:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389279;
	bh=x0aZ1tfcJ/Ty94l1h2AbQVLEmxVEaAa3uZWU0teerOA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KBJZ7wYjVPMNH+Z7oJGDoD7RqrAGyc3bECakaiFSlQh1xu8oCgqgtPOKmMlZTT5+h
	 8By55TlsCZH3BNdAPQpN7XK0JjKVI7cLo5GYkIksD66pjs6GxBuuJpUuFPz3vDl1B+
	 r2GXQdDt4ENrss06oHsKoLXE+vNYxF8UaTfp599sn07LdWp5RLYUj9Pph5QCk4h0GZ
	 L5lJI97UcWbJTJ3X5d8kJpZi/ExiuLX7RHV8fGRmrW5ZnDemZanemqmKhhZEI5ECnp
	 KCE0XTdCMFGLuogtSmLl6EOTRQZXHA46nXhNxB2/+fm4imvVqjfyoLD1IeR4y50Q37
	 9w3CwuOhjuHIA==
Message-ID: <1c57ff65-ac25-44d4-8416-c92623f65066@kernel.org>
Date: Wed, 11 Nov 2026 10:27:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
 <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tncy6psnk63j34ge4asbir13xwoiouj7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 141D6180004
X-HE-Tag: 1794389280-233893
X-HE-Meta: U2FsdGVkX18VokRGzX+6Ztp/GBBH3ZVyjSbb1w65B2MDB7r6CTOGV0FJSrztt1EK015ClgHjUJIaYqz9u8Vafji0tCTGR6pIHrtSXFyxVH/y6GEbPHS8N6QeztjKGWkkZKNZJCpoctZmskz6WtpCrGN04BxwS1LqCqajOJ4rWxbfYyN/Kjn1n8mpz5q3Jxu3V0KS3QfOC9pakDacBRMdFHuZS6L4raCqA+vH9OXhZ34YnhXZUYgCRjG8lGk9z9CmKxdqDDjyRdVA7M0cpIL29P37ezStO0/PfOya50gcaE5Rm3OO+HeAN1ZcKV3tCpBg8vSJz95wWB2qyy6xUjHvi5BUo1NpGK43nYbSxmr9ZjvqmNMK0gt/+RwKkqVjWyMUnIN4appu9X7zUubhKyCgyyve1ltK7+bBK0P6gHhZf4UE3HLRJZaX2aIFv9WrcIwox/NsJ4OcgGk6JfsFTE1lnSRyyzqVaruBnVISnkJe1H+JunSxjva6Ld0JuWzj6Cj/JoMma8I/A2AmQ9Hi4IObBpx+memGbBo0Dpsjkx+iMZ8MV1JUP9fJib0WvRGeCypulUlgqBDtXVmHiFqCH81R8W4ux946loEOLzzabRQe0DTlmtAD/YZ09vy7vB/2/sPHa6pA0gH4jp3J9nkDSJntYJaq178rfM7FQc6SbvE8Cst9TeTgRbl8APvJJZnNo7cHIB0dYSbDNFO6OvNHP38llBYeubk7Zftd7j2zL3P1YkvTcPqgN1XdgAN7/eqVG2tz9u8lwycka5EK3QWScegmaVwAHBeCI3J2ndp0eVi6qzoPhN2xiJ81VGkvtMEAwh+Slb0MaPcY2AbeqCVz3R+LkX8eVpO1VsHEk9CRVXiAes7avnYceCdYyXDZ5Dkp6pgrsuUkZQSN6FdcITjEhHGzeOEffcmGjb4twc6T0jcnrAiTlgU5qs6kfhrNk9JiC5mrymU3SkFb1o7DJJ2vjW1
 N6wRc09j
 QNvJZFd8uYUwbiuxk1oLIB00nQdew3VGHXRzxOq9AJ5hJROc99JgpYGOF5iky3L7DqZdiCYpvn0qPXhetzzsv4hW3XqhNo2o1mt2IdnHGXrXwMWBeInJTsnLpagIQ/SfhTF3YqZ2yDCQAPkomVPJ9rie/YitPAgj0Ve2lkS507nxvaTFIA4ao2GmLl/tkRVcAyuQgK7A6NOWW9YBNwb9IvJob+F1s8Bf2bURvs2w2PcIrz2iQLXB41ozLUtxqwWaPIckSENMZ7XxA1i/usDK2ZuZBRufc/N9SrzOQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 18:19, Lorenzo Stoakes (ARM) wrote:
> khugepaged walks an mm's VMAs under the mmap read lock in
> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> them if encountered.
> 
> It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
> when these are encountered, however only checking this budget once an
> eligible PMD-spanning VMA is encountered.
> 
> It can therefore hold the mmap read lock for a long time if there are a
> large number of ineligible VMAs present in an mm, over which time no mmap
> write locks (and thus no VMA write locks) can be acquired.
> 
> Address this by checking whether the mmap lock is contended after 1-10
> ms (depending on CONFIG_HZ), i.e. the granularity of jiffies. This is a
> long time for a lock to be held, so is a reasonable compromise for
> determining when best to do this.
> 
> Skipping an ineligible VMA costs ~100 ns on tested hardware (x86 server),
> so a batch of 1024 bounds the lock hold to ~100 us without expensive
> high-grained timer checks.
> 
> This scales for large numbers of VMAs, and tests with ~1M ineligible VMAs
> reduced the maximum mmap read lock hold time from ~93ms to ~110us.
> 
> This was also observed to reduce mmap_lock stalls in concurrent threads of
> a similar duration. Note that a reader re-acquiring the lock can currently
> steal it from a writer that is queued but not yet running, so the full
> benefit to writers depends on the linked rwsem change.
> 
> Local measurements indicated no change for ordinary use cases, so this is
> all upside.
> 
> This work came out of investigations into mmap stalls when getting latency
> numbers for an unrelated patch series.
> 
> Link: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/khugepaged.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7d1414a9b2a5..59bbef61f104 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -66,6 +66,13 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>  
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>  
> +/*
> + * The number of VMAs to walk before checking for, and relieving, mmap lock
> + * contention. This bounds the maximum mmap read lock to an estimated ~100 -
> + * 300us depending on hardware.
> + */
> +#define KHUGEPAGED_MAX_VMA_SCAN_BATCH 1024
> +
>  /**
>   * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
>   * @slot: hash lookup from mm to mm_slot
> @@ -2910,6 +2917,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
>  	unsigned int progress_prev = cc->progress;
> +	unsigned int nr_vmas_batch = 0;
>  
>  	lockdep_assert_held(&khugepaged_mm_lock);
>  	*result = SCAN_FAIL;
> @@ -2942,6 +2950,18 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  	for_each_vma(vmi, vma) {
>  		unsigned long hstart, hend;
>  
> +		/* Relieve mmap lock contention after walking a batch of VMAs. */
> +		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH) {
> +			nr_vmas_batch = 0;


We could simplify by just doing

	if (++nr_vmas_processed % KHUGEPAGED_MAX_VMA_SCAN_BATCH == 0)

I guess. saves one LOC ;)

> +			if (mmap_lock_is_contended(mm)) {
> +				mmap_read_unlock(mm);
> +				cond_resched();
> +				mmap_read_lock(mm);
> +				vma_iter_set(&vmi, mm_slot->address);
> +				continue;
> +			}
> +		}
> +
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

