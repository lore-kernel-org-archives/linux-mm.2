Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B80FE5214
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9994C6B008A; Fri, 24 Apr 2026 08:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A0E6B008C; Fri, 24 Apr 2026 08:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85FD46B0093; Fri, 24 Apr 2026 08:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7142A6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:06:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD4B31B7B77
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:05:28 +0000 (UTC)
X-FDA: 84693319536.19.FA2D244
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5ED9C40002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:05:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iUnghvZg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777032327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVKgKKWCi2Rn5AKJtWYPnZCe1XVFLTDNthQX8SWA7ds=;
	b=P7in4s74QFLwcAap0ovb9zUuIIxBcGOxHYMFCcDZ/tMcAafokjH+b35U/q08AeG5ZtvtF5
	my3uI68rUvlQuG20WBoV65tsVj6DeweOEI7FjMHD7/MAPPwZhwVxaacmjCYQ3HNygQXwaB
	J+smrRPiimTlGKJbqYFVXzgrciZAB7A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iUnghvZg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777032327; a=rsa-sha256;
	cv=none;
	b=HG//KL98TTDcCXqnkdQ49AxN9Z2z07QqszZ/h/DQ011RECXm+AlCV7/+NkKvTjmcyMWeIc
	hJUfHQpZ/fUCu+kH/nJB1p06YiQM0vBLCW1yMIlzyt4UpcqTrnHGXOJHfE7jakn0D5pKYX
	LaFVEKo42Rm09GvC3utBYbVisMkbnZk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 746F31BA8;
	Fri, 24 Apr 2026 05:05:19 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 288FF3F641;
	Fri, 24 Apr 2026 05:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777032325; bh=ZX0Gk8ZXhQfYmfd0QPEkV0r5QjqKFEBtavYYnWGlGwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iUnghvZg4F5GF19O8nsZ8aWARvil/vxjb6twmWwcuKOzCZErwJNqshbtD2FCc+QBH
	 F2xOfl3YbiUWeKuqaL/AuAUOHURDX7RlxZMLMyhFQdW077RDxZ57WXfu/6sob5q7ka
	 vJ0UeX/aH+eDu0BIep0FzblGysOW/jjSJudv7b88=
Date: Fri, 24 Apr 2026 13:05:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/kmemleak: dedupe verbose scan output by
 allocation backtrace
Message-ID: <aetcgHhBXfPe6lr1@arm.com>
References: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
 <20260421-kmemleak_dedup-v1-1-65e31c6cdf0c@debian.org>
 <aeostKcaHzmVBFjb@arm.com>
 <aesymSWyh8NRIrDQ@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aesymSWyh8NRIrDQ@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5ED9C40002
X-Stat-Signature: u34r1jx1gsbkgzafidptdnxbqmseonhh
X-Rspam-User: 
X-HE-Tag: 1777032326-719151
X-HE-Meta: U2FsdGVkX1/4ZuPCfMHc7NOUO7OzsmozZ1acjuUiHBtoIKjyixBGzcOREA1gLIAP4YepHb1b68mWuXmgb53YsmYUY5exMQ5okGleIxL3TwHGenSmCdNK3TlR27F5w4n9uBcdPtGazMHkC9bU8PXpgyNWQI5DZiyEcjjgv36g1kvPfRaw74kbJNQBb+Qidp0lvirsyG9wxsFcRje+PvbWtX6zVHYxbGYLDNAyGs74hRKtOPBOLtPnUofyYUyveJauLvuuwhN8bwH7aIBhSccBPEjWa9z5v8I7pPlQBVUuVqYaHYr1fwqStM2IbsSKGyK5xvUtTRJTeFnUdgSaLM1Mps3H78ozjUsj3X/ZjgRcZQOd7/JRTdVC2S0LpsfeGYm71Y4dliGENyxTLxrQHjmr/wlGnBJOSpXlFXnLphCiR+yMu2IReaTdYTIKM7uDxUvmJZhTVN6YLgEeUAvgVKwtWrPqgnUmHTtAjhO61RTOfq9sfbqHv9biO9splMPYssKl0RTwXG309WC+5vppRTTsMccd/4cwsEk4NmRHtW4h0Ay+Igg8oJmo/LO/hBbU3orxFAcQ+OdvpO/NK8tUyODERvdRgLf9kuG55ZTZt1lsc0td6ibr5/A/Fxw4290YaSrynrmjjjibSfcc1mK1rzlfQexbc0dKXS3Nl9OnnEKnNmFFF/efAjCie9o/VQfhSzX4ZrZ4/8QuISFTXp4kWen+7AeyfmZUZ3eqbAxI7Sh4wzonfNcIVmK4PeCt53kXhq3clcQemUuu4C9P2kUQGxSurUW4jJ3Q+6LzLIiV2Mc5cF/xM2U7bWkDyZgWBx+2rtpR0b39FJsBfKbak5qPGrC1yoME/ee5fNV6nQaojUnB6oR9P53SvVLKv61XEwJKnt9vifh9KNoLsHta0jBOVsdA8NNM86EnrEaoMoGdgh01nv3Cu687YOUJ3DJ2Cc0l/TBHotKVpP2aZAXR0u0Cery
 q4v9rTbR
 I1o43ca4jWOGAGODBdjM6iPAOJl+0+SXdwrZ4DBqMUNxX+ojz6wLpuHeh7ujl7Z4nMs1wBrqHKGQkJi5buTc2BvXWzNONdKJQDKJ1s+Zmr65WqCKKIwKgUB5CV1UmE10EAfl46Nx6LrGCaCxC3UK/oiIh6XN21etn3GNY6mbwAFmzIDHoe2nsemX1TR3JyuLwOfstYA5zNa4sWyC768Su6ZBLEMGiDG4n94y8KOmzT5MKmA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 02:26:53AM -0700, Breno Leitao wrote:
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 2eff0d6b622b6..d521cc71ec1ee 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -92,6 +92,7 @@
>  #include <linux/nodemask.h>
>  #include <linux/mm.h>
>  #include <linux/workqueue.h>
> +#include <linux/xarray.h>
>  #include <linux/crc32.h>
>  
>  #include <asm/sections.h>
> @@ -153,6 +154,8 @@ struct kmemleak_object {
>  	/* checksum for detecting modified objects */
>  	u32 checksum;
>  	depot_stack_handle_t trace_handle;
> +	/* per-scan dedup count, valid only while in scan-local dedup xarray */
> +	unsigned int dup_count;

I would add this around the pid_t pid member since both are 32-bit,
better struct compaction. Here we'll get 32-bit padding.

>  	/* memory ranges to be scanned inside an object (empty for all) */
>  	struct hlist_head area_list;
>  	unsigned long jiffies;		/* creation timestamp */
> @@ -360,8 +363,9 @@ static const char *__object_type_str(struct kmemleak_object *object)
>   * Printing of the unreferenced objects information to the seq file. The
>   * print_unreferenced function must be called with the object->lock held.
>   */
> -static void print_unreferenced(struct seq_file *seq,
> -			       struct kmemleak_object *object)
> +static void __print_unreferenced(struct seq_file *seq,
> +				 struct kmemleak_object *object,
> +				 bool no_hex_dump)
>  {
>  	int i;
>  	unsigned long *entries;
> @@ -373,7 +377,8 @@ static void print_unreferenced(struct seq_file *seq,
>  			   object->pointer, object->size);
>  	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
>  			   object->comm, object->pid, object->jiffies);
> -	hex_dump_object(seq, object);
> +	if (!no_hex_dump)
> +		hex_dump_object(seq, object);

Nit: just use "hex_dump" and avoid double negation.

>  	warn_or_seq_printf(seq, "  backtrace (crc %x):\n", object->checksum);
>  
>  	for (i = 0; i < nr_entries; i++) {
> @@ -382,6 +387,12 @@ static void print_unreferenced(struct seq_file *seq,
>  	}
>  }
>  
> +static void print_unreferenced(struct seq_file *seq,
> +			       struct kmemleak_object *object)
> +{
> +	__print_unreferenced(seq, object, false);
> +}
> +
>  /*
>   * Print the kmemleak_object information. This function is used mainly for
>   * debugging special cases when kmemleak operations. It must be called with
> @@ -1684,6 +1695,103 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
>  	put_object(object);
>  }
>  
> +/*
> + * Print one leak inline, re-checking OBJECT_ALLOCATED under the lock so
> + * the hex dump does not touch user memory that was freed concurrently.
> + * Used by the dedup_record() fallback paths where we cannot dedup and defer
> + * printing through the xarray.
> + */
> +static void print_leak_locked(struct kmemleak_object *object, bool no_hex_dump)
> +{
> +	raw_spin_lock_irq(&object->lock);
> +	if (object->flags & OBJECT_ALLOCATED)
> +		__print_unreferenced(NULL, object, no_hex_dump);
> +	raw_spin_unlock_irq(&object->lock);

I don't think OBJECT_ALLOCATED should prevent the printing here. If it's
called from dedup_flush() and the first object that kept accumulating
the dup_count is freed, you'd not print anything. I would only use
OBJECT_ALLOCATED to decide whether to do the hex dump if requested.

-- 
Catalin

