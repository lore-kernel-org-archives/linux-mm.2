Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20521CE8D57
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6547A8E0019; Fri, 14 Nov 2025 11:52:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604508E0005; Fri, 14 Nov 2025 11:52:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3928E0019; Fri, 14 Nov 2025 11:52:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C31C8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:52:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 030CA4D059
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:52:42 +0000 (UTC)
X-FDA: 84109806606.22.E18F6D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 74E7F1C0007
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:52:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dYUKLJgJ;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MarKiFtWWXiCJfop2Mp04w6dux4RRrqD8MZucum8wGM=;
	b=BXFhPErbgETPZXOKWDCEWEw6VG+pcU+SpOUazN19x9796Q9cR04kpddZmvdtRVMIZZi7WV
	wC0XwgVhWdQ297gXad+Du8CAGSSeYPuH4yf/+xpWEX0R+KY3CAsuVPwYvlRu9HFPy2gUBN
	lPpklYbZrJPZyTpRgn3ZFZxrTqerQcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139161; a=rsa-sha256;
	cv=none;
	b=gGaSPtQkBVAMKsJN3i6195CZSu6CgvcYLkFbBUprGUAY0GneybN4Bk7kFC/+VAUP5T6DjE
	Hi6zQuFuYNznnpp5npStaz7k8zO31bdycVL4VUAUvWcO1RT1av4A36J7Yn2HcFiqU3XGb8
	w0fLWEso+7dXrOaws8Lr0SDfzy4hFE8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dYUKLJgJ;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5A1360198;
	Fri, 14 Nov 2025 16:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32DBC116B1;
	Fri, 14 Nov 2025 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763139160;
	bh=ukDtEMQ3h+HhdTJApwHm9gtvXizGx7c4PKt+RTNGPfM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dYUKLJgJtebr3v2RLEJLGjWo41D48EJ74YaRNQVVcm9EIEADqqQMMJSdMPnkQyRAY
	 XkyMOmFO3ICqJO7e5Nva3u3qleGxnEKKidN2/N8S3rc1/Nh30kccNHXjEAVPZsadOg
	 dOiaDloor0qs0YW7KtSIGIMWfqCor3kC3qbk4otQ0YiPgFGwSZCynzXIoJUG4QHN/E
	 IH4UrA/zU3x42MbWyJqcj2PmtkLUek9tZM/TDt1nf1GFO6ZuOKoUV7X2U3r7+ihKBA
	 rPf51GRurGrGeTA6XskxG28Z/YZzJAQOnxxY5Dqu65vEFiDcfcKcHdWBmZsUeVhRK3
	 GxVPiDNBhTPRg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 04/13] kho: Verify deserialization status and fix FDT
 alignment access
In-Reply-To: <20251114155358.2884014-5-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:49 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-5-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 17:52:37 +0100
Message-ID: <mafs0tsyw7e0a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: wiqh8tgh8r9sb7ywyt9gmzd58769y331
X-Rspam-User: 
X-Rspamd-Queue-Id: 74E7F1C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1763139161-374255
X-HE-Meta: U2FsdGVkX197xgPoTjUCCgHpKlNRXTSHhEFyB24hj15R8Ef2rqt9nzEeGnNheO4O3kgAPQeuiQFO63I2BY8s6DuivgLQaKeTLTYWbmnyaeXQftnhchD3HcX7PvtomLdwE6ONINAJ5g38J/2p+Qz+6KiUXGnX1Wdw1gQHhM9BfE7eDH3xMEaxeKuQ3MymDgsRbzNmjJV+IpBnWcU2/6sGJfbyL3RqRS205ZjUFl2TE+3/qqqZcJVa6/KrPrnN4tzt+MhzNKyoBrhqb9lh/gfG68m5ImbEvBTkoTnNse61Zx4UmHm330yUIMe5ikd2o7G0cQiyaNtyr6BYV2r2cuV7PpCm1MCG4RT7w+1pq0TfhJSjSByFc4Z+tGYuaH1lnmeetOGtHW7mqjaNOuJ3sZqlVRyIXdPtsPi+3pD4WCDMLUrkG7lpiAqG3hmG85RTITVCy+NIglV0FOZm7p2KIqGj9vvsNdWTbqvrcNRuV9FBLgfUSlgD9X7CMc34046Grg1+ZF/4ElfSS4gemgF21HVjGpLAGzMi86pgAp9PxjiFtY4piLv8NSGCcE9IhtDzpWyVLs9dKkT+VRkQHoTXtaCUHpVQsySVMdjYsokJmzP2A5aPtAUdur9tD7THOg8/JSZYnCWOZ5LhwKHDpvg6o4ZhQx18lCUA0VlyfkPxaw9wJmwtonuULJ4ZZA3ZvCmMBoedHpP7A57W06BzR3ZY3dRMHEsKqXmLx+X3DcE7ICya6pcRSb/vBtvd6MLT4lj62BhMV6DEc7HGAq9BfAZicOIpyq16LY3s4k4v82NUh90qh1QNNW2bWM/F3ORbMs/3N8Ha1ruxonmgz/Li7cnmI5h8IALOncz69e18/pno7OLY35bEuSYUDgKCtdCLoARJbpy+ka6M2n21BqrCDYrN4hxaW7/cdiIbpRvuGlnU8QLWW2D1BH6gei8m6dARdMomRPghGSAnZ9w9JA5q7A/8wvO
 bfwWPruT
 TuTz1NnDxFZD6YYIcyQTGMfHzHSBNpXbVsFEC+WoC3/d1RysbJaj0rxlFcSr9E2JFrHTmWj6MkHkbXEKIDL4IhfsaCO4XA8DxV4BMbqhzTCH3M2DXK03IfLL+SAe7kLsW9NtVdzej9qLnpHER29oeqMzY60frnEP8lRqe0MOi3/zI4hRbwvCeGMv5gzVKaxIKslKAtzfgNt72Q4fMNPfJ529ZkkEuh82hZuTOol73UfPLMUpnGixIVd2ovQUlv3R3Cr4w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> During boot, kho_restore_folio() relies on the memory map having been
> successfully deserialized. If deserialization fails or no map is present,
> attempting to restore the FDT folio is unsafe.
>
> Update kho_mem_deserialize() to return a boolean indicating success. Use
> this return value in kho_memory_init() to disable KHO if deserialization
> fails. Also, the incoming FDT folio is never used, there is no reason to
> restore it.
>
> Additionally, use memcpy() to retrieve the memory map pointer from the FDT.
> FDT properties are not guaranteed to be naturally aligned, and accessing
> a 64-bit value via a pointer that is only 32-bit aligned can cause faults.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 32 ++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index a4b33ca79246..83aca3b4af15 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -450,20 +450,28 @@ static void __init deserialize_bitmap(unsigned int order,
>  	}
>  }
>  
> -static void __init kho_mem_deserialize(const void *fdt)
> +/* Return true if memory was deserizlied */
> +static bool __init kho_mem_deserialize(const void *fdt)
>  {
>  	struct khoser_mem_chunk *chunk;
> -	const phys_addr_t *mem;
> +	const void *mem_ptr;
> +	u64 mem;
>  	int len;
>  
> -	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
> -
> -	if (!mem || len != sizeof(*mem)) {
> +	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
> +	if (!mem_ptr || len != sizeof(u64)) {
>  		pr_err("failed to get preserved memory bitmaps\n");
> -		return;
> +		return false;
>  	}
> +	/* FDT guarantees 32-bit alignment, have to use memcpy */
> +	memcpy(&mem, mem_ptr, len);

Perhaps get_unaligned(mem) would have been simpler?

> +
> +	chunk = mem ? phys_to_virt(mem) : NULL;
> +
> +	/* No preserved physical pages were passed, no deserialization */
> +	if (!chunk)
> +		return false;

Should we disallow all kho_restore_{folio,pages}() calls too if this
fails? Ideally those should never happen since kho_retrieve_subtree()
will fail, so maybe as a debug aid?

>  
> -	chunk = *mem ? phys_to_virt(*mem) : NULL;
>  	while (chunk) {
>  		unsigned int i;
>  
> @@ -472,6 +480,8 @@ static void __init kho_mem_deserialize(const void *fdt)
>  					   &chunk->bitmaps[i]);
>  		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
>  	}
> +
> +	return true;
>  }
>  
>  /*
> @@ -1377,16 +1387,12 @@ static void __init kho_release_scratch(void)
>  
>  void __init kho_memory_init(void)
>  {
> -	struct folio *folio;
> -
>  	if (kho_in.scratch_phys) {
>  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
>  		kho_release_scratch();
>  
> -		kho_mem_deserialize(kho_get_fdt());
> -		folio = kho_restore_folio(kho_in.fdt_phys);
> -		if (!folio)
> -			pr_warn("failed to restore folio for KHO fdt\n");
> +		if (!kho_mem_deserialize(kho_get_fdt()))
> +			kho_in.fdt_phys = 0;

The folio restore does serve a purpose: it accounts for that folio in
the system's total memory. See the call to adjust_managed_page_count()
in kho_restore_page(). In practice, I don't think it makes much of a
difference, but I don't see why not.

>  	} else {
>  		kho_reserve_scratch();
>  	}

-- 
Regards,
Pratyush Yadav

