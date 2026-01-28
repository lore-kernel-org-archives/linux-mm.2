Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25094D46BFA
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 21:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1986B0005; Wed, 28 Jan 2026 16:08:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F126B0089; Wed, 28 Jan 2026 16:08:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38AD76B008A; Wed, 28 Jan 2026 16:08:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 296246B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:08:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1DA31A07E6
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:08:03 +0000 (UTC)
X-FDA: 84382610046.07.2728F47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2DD5C100005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:08:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TNjeh53b;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769634482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7x1v7MunDSig0PHX8nCeJqJ3VHrc/WfXSMRRgTvq/Y=;
	b=cGW/NbF5PpoNngtTid0ymplEbLFeW8mAAE7QhSCoNimspPLCDXzY5v1bNcJhwQlpsWnDkj
	APlV81C1DZBhJI8Z7zwrapMo8U7NuOhBkEUdvtNu4qLXRJ5KVOWQF0lOhGv1OhSb8YiFiv
	kwD/xRLmCB0PWAXmKkqepNrMEiCIJbk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TNjeh53b;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769634482; a=rsa-sha256;
	cv=none;
	b=iW5F9BmV52M5oiFAY8+5z0Eq4h8mhJgVrSKzMwCzeuMcChWj90odvuRb5WVvrU+Oq86uZ3
	4NszbvsIW6m+oykjygpLtngqHbWuhoXi6zpE0JSGqlwpE/ruEvFPggTjJXgsyuDDRLdpG0
	V0VXcM3hQBcYZgEOTjdgNgl76M24vrE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 690A96000A;
	Wed, 28 Jan 2026 21:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA88C4CEF1;
	Wed, 28 Jan 2026 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769634481;
	bh=tGJoCzuYyP9DDfnQaITfmSMCYnBd32iYXSX0TH7/yjE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TNjeh53b2GQ58MmlzIVlL1YmyRy9LNtW3kOgxsrEY1o9/jA1zEFOTtac2nyEPic86
	 eB8+DQ2r2RLcT65sfScJ9mMsW3lAu7qVaPUgI3tbOE2DV9aeBW134Kr7/bELPqha8w
	 ybLKc5nZjXl6e2n7rPaWZdZvUHZtT5x2FrGsr+Fk=
Date: Wed, 28 Jan 2026 13:08:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
 <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
 <bp@alien8.de>, <dave.hansen@linux.intel.com>, <kas@kernel.org>,
 <ardb@kernel.org>, <david@kernel.org>, <osalvador@suse.de>,
 <thomas.lendacky@amd.com>, <michael.roth@amd.com>
Subject: Re: [PATCH v3 2/2] x86/sev: Add support to unaccept memory after
 hot-remove
Message-Id: <20260128130800.40adb423627ff6d8ffce7ccd@linux-foundation.org>
In-Reply-To: <20260128204105.508855-3-prsampat@amd.com>
References: <20260128204105.508855-1-prsampat@amd.com>
	<20260128204105.508855-3-prsampat@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gp8gy7enttobxrtbzz4z11yafqfpdsod
X-Rspamd-Queue-Id: 2DD5C100005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769634482-999991
X-HE-Meta: U2FsdGVkX1+Q+xb3pWLgYKdNKkUlySidCihbqZVYfLpMVwv77CFFhKcl9D7kkLz3HhYrURGay4uVZ0d0LXToZWq6Y5pdTTMNjeZh0kzNS+ENIHc4pxGhLvOOZ/whWmgTn/oB9M5zplka0cfBkF8mn6OffHyIw6Dr6eklro3zUo5pSOaY9FTe16vLe48DvRzrsA3au9JNI3WP59rth+n6FdzKLrgBkq6u5hLwJ0696A+aCQ1ywhSJ6cm5C6zjpIIrmmRYQMAY7r2j74Ctbgk/j1hlHFliIHTLyNjt5QfoitsMDgbRl6ZckUHjZ9Fosj8bPa20rnx4kjjQdJzRsfyoUMVqo63nK2PfReuKGzDndhbNuIW9/8BuQ7O/LQ4T6sLEddLMChu3FwbN6T9+nqRE4lYrLOyaUjgQbH6lluzCNqkbF8OhjO1Cc81XuqntAU0HYxs3l+fUMKWyi1gP0vRYwN8WBjhSV/CuKHX54dv7RCzJfzjgkHDaEa3KpVku8fipXqX0VtLQHMQbOW+khSzg5Ss85prh9XyXFmZbmB+KClQJqiukuF5w2SnvvoWSWKn/imj2GX1N5TctVxSmaG/6DOZjoVqYWC8ww/5/KuHDPePQ0cXcW7pQ74FBvpxmNoJ5Ddu4YXZgphRvRWg1+50GhtawihCq/nADK5r7rwZPAJ13IVACwi/RM8v87OvatFpKElyn9nRzTEf/Qvjxemm/wsk6U3cQjH22LBJ1EBkFNawPW+fMexy3KY2a6YWh7diELfvr8W0ZJdHbfnoRlEYekSOiHDLUkXS6RAoYIbT/ZVemz4MnZOmTIWZ3yEC55dIaEjwNBCq8KPEqcaLtdGpjiCtEuXBhte1403kzRnlb3GcT1/UwgPzlmlSN3jZXyWFe609rt/MXNIoC0U3c/nvGcF6qlZSPvv0xv3SVbhvmBbHLSh/gh2P3N7Eyg5edO1SlP5UPJEW7HwzGpbLT/UW
 3QKeTDXI
 YHBaYNrNwfWBC0GkTv/GByQIOouzgmDBC9MCdLjbs0wr1yJ9W3W5MBLjJ+Joy1f6T66irVfJt4OmqrTSMI/zplb+q8GBFhwPARU6s0tZj8q40mlEP5ThwixI3MLLEjqiDt0Nv7KSO3SGFFUgiloNptIYoRMnBAviRy8QisClA09J5qUOY4CAX6ZWEGwG3TTwfUTa+/u93U3c86uEyqvGcclKT3rnV7UeQcA7MzqclQjZoCWeRc5oVoFVQEqm/9IF+kLTZHJwxk19UN9/YwHd96Enc+r/6XcnjJdDc3Dwgbc1SpnC/j8Yts+nNqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 28 Jan 2026 14:41:05 -0600 "Pratik R. Sampat" <prsampat@amd.com> wrote:

> Transition memory to the shared state during a hot-remove operation so
> that it can be re-used by the hypervisor. This also applies when memory
> is intended to be hotplugged back in later, as those pages will need to
> be re-accepted after crossing the trust boundary.
> 
> ...
>
> @@ -623,6 +624,7 @@ static inline int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
>  	return -ENOTTY;
>  }
>  static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
> +static inline void snp_unaccept_memory(phys_addr_t start, phys_addr_t end) { }
>  static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>  static inline u64 sev_get_status(void) { return 0; }
>  static inline void sev_show_status(void) { }
> diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
> index f5937e9866ac..8715be843e65 100644
> --- a/arch/x86/include/asm/unaccepted_memory.h
> +++ b/arch/x86/include/asm/unaccepted_memory.h
> @@ -18,6 +18,15 @@ static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
>  	}
>  }
>  
> +static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
> +{
> +	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
> +		snp_unaccept_memory(start, end);
> +	} else {
> +		panic("Cannot unaccept memory: unknown platform\n");

Seems severe.  Dropping a WARN() and continuing would be preferred.

What exactly happened here?  Am I correct in thinking that the check in
snp_unaccept_memory() makes this a cant-happen?

> --- a/drivers/firmware/efi/unaccepted_memory.c
> +++ b/drivers/firmware/efi/unaccepted_memory.c
> @@ -157,6 +157,52 @@ void accept_memory(phys_addr_t start, unsigned long size)
>  	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
>  }
>  
> +void unaccept_memory(phys_addr_t start, unsigned long size)
> +{
> +	unsigned long range_start, range_end, bitrange_end;
> +	struct efi_unaccepted_memory *unaccepted;
> +	phys_addr_t end = start + size;
> +	u64 unit_size, phys_base;
> +	unsigned long flags;
> +
> +	unaccepted = efi_get_unaccepted_table();
> +	if (!unaccepted)
> +		return;
> +
> +	phys_base = unaccepted->phys_base;
> +	unit_size = unaccepted->unit_size;
> +
> +	if (start < unaccepted->phys_base)
> +		start = unaccepted->phys_base;

max()?

> +	if (end < unaccepted->phys_base)
> +		return;
> +
> +	start -= phys_base;
> +	end -= phys_base;
> +
> +	/* Make sure not to overrun the bitmap */
> +	if (end > unaccepted->size * unit_size * BITS_PER_BYTE)
> +		end = unaccepted->size * unit_size * BITS_PER_BYTE;

min()?

If you like min() and max().  Sometimes I find them annoying - need to mentally
expand them to figure out what's going on.

> +	range_start = start / unit_size;
> +	bitrange_end = DIV_ROUND_UP(end, unit_size);
> +
> +	/* Only unaccept memory that was previously accepted in the range */
> +	spin_lock_irqsave(&unaccepted_memory_lock, flags);
> +	for_each_clear_bitrange_from(range_start, range_end, unaccepted->bitmap,
> +				     bitrange_end) {
> +		unsigned long phys_start, phys_end;
> +		unsigned long len = range_end - range_start;
> +
> +		phys_start = range_start * unit_size + phys_base;
> +		phys_end = range_end * unit_size + phys_base;
> +
> +		arch_unaccept_memory(phys_start, phys_end);
> +		bitmap_set(unaccepted->bitmap, range_start, len);
> +	}
> +	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
> +}


