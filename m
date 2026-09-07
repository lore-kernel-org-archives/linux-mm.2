Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21912C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9E66B00A6; Mon,  7 Sep 2026 07:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391916B00AA; Mon,  7 Sep 2026 07:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FF86B00AB; Mon,  7 Sep 2026 07:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 035616B00A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:00:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77823120114
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:00:07 +0000 (UTC)
X-FDA: 85186671654.29.1B6B955
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id AA9FB180002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:00:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OS1bd8l5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmRAQp7CT9ZcGnXRbWq2cl8HArUYmjma0K0TpVSARi0=;
	b=KvklQxUg5JmPUSAmyU+25TdoFO6ABH0NzXUiEaVG2YuYjD+NPO1wry3tQEYjwMoQld4jx6
	WrtebnvLWV8QZwwh9nb6bBblCwbp26nzADHyr3vjjJTa22LY2zs3M8CMzJ7fqoalSb6HIg
	YsYBxHuulNcQ05zzs2Om3vQ3YStllv4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778805;
	b=adr/x6bm7SybLRXdpZuYlV0JEi7q2GeGFbQ9ad/ycLD0e0LGS92dyCd21Ie+PrVEbviel7
	avh1+PfaPyiwjOmF+462UfQI9NunoulITAaSHylQWC3XsCUVLGhzyE+u8I527YBbY6jZ5b
	pFRiD32RGgqGnMpE1l2249Mc+Tqd3XY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OS1bd8l5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE333601F9;
	Mon,  7 Sep 2026 11:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF241F00A3A;
	Mon,  7 Sep 2026 10:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788778804;
	bh=ZmRAQp7CT9ZcGnXRbWq2cl8HArUYmjma0K0TpVSARi0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OS1bd8l53HBFTLeWpn+DLUZW6acFae8EN0TYc4g1vuJkfPuU9kXzmAUwy2G73YgMu
	 9IHR/D9kde7ZJvyI1/j+ddlfwpHOagprqjMcbn4V6AAmIrEXVKq8UvBDn7qYUVILek
	 k/e6wBruu3DFLtXzN6AUY099s9O8sTOtqYhZjwG7TOU0d5UxZeYxCCOIlqlDop5lMC
	 dmMA3yskAPtf8fg3NkoT2yvuEpHRlfW7Ex7wUaKR3pPcwFRI6USMASdXv78Mxj106o
	 VjPROn9VYDQQC35JrwOlEi2ke9YQJlGFiD0p1RcmJSwgRpjS35fbAz09gMTykpyXTr
	 714lZ1wOpZxdw==
Message-ID: <0e4edfd3-0c82-42e0-ad09-19ff8b8d1511@kernel.org>
Date: Mon, 7 Sep 2026 12:59:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v4 1/7] mm: Add copy_remote_mm_str()
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>, bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, kpsingh@kernel.org,
 matt@bobrowski.net, song@kernel.org, utilityemal77@gmail.com,
 sun.jian.kdev@gmail.com, "Lorenzo Stoakes (Arm)" <ljs@kernel.org>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
 <20260904145340.40212-2-tasos.papagiannnis@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260904145340.40212-2-tasos.papagiannnis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA9FB180002
X-Stat-Signature: sxhgbbnwggugrj5gb7ehuhu141it384k
X-Rspam-User: 
X-HE-Tag: 1788778805-185247
X-HE-Meta: U2FsdGVkX1/hAohbp4ardeRxE6f3d8oI/6E44zI07RnEW677XzceEIq7mXL519vSVw6vLM2DBwkc7YjLxKULYeVuXythZJZeI42k+hmbet9SkPe6sfmtBocUzgV3HYOwzxrVmy1p7pJZqdGpboHZl+6aFdgfJ1+KRz5r7I7DBpK/WXfiMpVVV4F7XATj6MZWVTWKOuTsee8PyVWO+bXgcZhJ7YN/s18AI/eMIJTmCoRRDrTgcOyjk614wFRDMtqd94n+Srodv6Mi0pLZZPc42VzrkGsqkxyZfLb3o43ZirIBeoqKMcV68uz2l7P1ZNpaNbQb9S1GBTRRCQd+u9WAbU8PUML9IzZMy7fDbjFaSjtS7BaghIRY4+wgDkuGDnKlJi3WBX0NkjXHj6Ujt/ukf21PoKgF/ki00avcZHVwE5PSkvMmarWLuKQiwH77b9lLOzRpwhAzONJ2kyKAY+8WLR6HU7+oHGCQs1SmoZIwyZdKNvxPvNpS2zKxhndo3ZCq2FtURNjSsdrxbeQOTVAGpvycuiMGQzN8LRaFBRRrpots0970ixSM6admEziPMiTUSTlxHhQG4yx7tlZ4tDyayAQR529NPmJ9cy1b0MXmHgHVrT6wkTDH8OUeFDWc++pUKwXyVYAopSMnP5IEAokvhKaSFBl1v67WoqpkbPzaUixrqBCQKYyg39fz2x9U/2tY5eTkVtJSqVSjj8cSJmrJwy6gMPO/9BA1j0gPr2IQQ3tLwqpdRO9lbjbCE5rLSlycXwRnT8rRW1csuXYu299Wb7Id0redRW+UddK0LBEiidk+Qf2xYldirbG/pMmaMuAOBEQuEKa810tRUb7Gb3FSWdQqulXOxOn2R0lj7yL6ItHLxFKjTJPASZkORplbMPlRAL7N4Afd9q0+Zjpl08a43nWW2NUbnxGjOVvQwVFt1VTNNpLAZhDpXW/cSnwJOi3cKhuB9qFfBjheJG27ehl
 V+TMDUfP
 nCoMTRfCLOAsuEiaua1Kj0h+PEgLEvhcA3piPwMI5OGzvKOnnL65y6MLRVMxjQlzEl1KRJbBEWNYPs8YCrBO1LjKdDxFedxE0vGYP14y1PhaXXiNIlMrTPFvP1t9GtGDYAffHGRlKP+zJSUzB4ice1XF1YLWzYa+Fgr0RAokVg94vs23KU702clV1bKJTATrhTvqbArtJvZuj1MlUSl5paJeUdlUEPj2CDsKAnYpBPX/7bKgsUiC68iZskvL2TxVi1vYlI4OUTYFLiHdDWPSuMFpPXeQkNvKBiLxwlorzqQdN3ktbpTWfu2ozd05BXO72bcFY4+xriwyGGovRX1v99JSy4ttZduRBwEmmxEnIYk8Rz1DrmER9oYWast7qQPKCTzw/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/mm/nommu.c b/mm/nommu.c
> index ed3934bc2de4..94e3709e95fd 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1716,13 +1716,16 @@ EXPORT_SYMBOL_GPL(access_process_vm);
>   * Copy a string from another process's address space as given in mm.
>   * If there is any error return -EFAULT.
>   */
> -static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
> +static int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
>  				void *buf, int len)
>  {
>  	unsigned long addr_end;
>  	struct vm_area_struct *vma;
>  	int ret = -EFAULT;
>  
> +	if (unlikely(len == 0))
> +		return 0;

We have this check in copy_remote_vm_str(). Why are we performing the check now
twice?

It should either go only into __copy_remote_mm_str(), or if there a reason to
have it before get_task_mm(), it should go into copy_remote_mm_str(). Same
applies to the memory.c case.

> +
>  	*(char *)buf = '\0';
>  
>  	if (mmap_read_lock_killable(mm))
> @@ -1752,6 +1755,27 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  	return ret;
>  }
>  
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:         the remote address space
> + * @addr:       start address to read from
> + * @buf:        destination buffer
> + * @len:        number of bytes to copy
> + * @gup_flags:  flags modifying lookup behaviour (unused)
> + *
> + * The caller must hold a reference on @mm.
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destination),
> + * not including the trailing NUL. If @len is zero, return 0 without accessing
> + * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
> + * -EFAULT.
> + */
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +		       void *buf, int len, unsigned int gup_flags)
> +{
> +	return __copy_remote_mm_str(mm, addr, buf, len);
> +}
What's more annoying is that both implementations of copy_remote_vm_str() are
identical, and both implementations of copy_remote_mm_str() are nearly identical
(just dropping the gup_flags for nommu). I'd like to avoid duplicating code for
nommu.

If we could export __copy_remote_vm_str(mm, addr, buf, len, gup_flags) for both
cases, we could instead provide a single implementation for copy_remote_vm_str()
and copy_remote_mm_str() e.g., in mm.h? (I'd prefer somewhere else, but we don't
seem to have a good git for memory.c + nommu.c shared stuff)

Now, that's also not completely nice, as I don't want us to EXPORT
__copy_remote_vm_str() ... given that these functions are "#ifdef
CONFIG_BPF_SYSCALL" could we EXPORT_SYMBOL_FOR_MODULES?

Just a thought. CCing Lorenzo.

-- 
Cheers,

David

