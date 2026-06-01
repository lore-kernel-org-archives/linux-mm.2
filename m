Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B29CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85676B0423; Mon,  1 Jun 2026 11:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5CC06B0425; Mon,  1 Jun 2026 11:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73726B0426; Mon,  1 Jun 2026 11:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94F376B0423
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:37:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 521C9C2437
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:37:14 +0000 (UTC)
X-FDA: 84831747588.08.8C6A99C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7CC0A1A000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:37:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VumEkE9A;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgYlZYJBLBUbPtUB4Zws6MmwdGLodHam9QjAHCsM33o=;
	b=bwgc413ILFvAhmko4AwtGUmUE3xQFolD0AaZsyL1yAaKoekMs2wV/NIihkvYs2Kw8HRKtu
	uU0s8Dcsrgu4HkLZ5lz0dfpWyHeWlCvjo54KJux+GwypaCXnVXVlcMupe4rBe9zHb8DTtY
	l0PmQHt8kR296q/CRKvhac4k9g0/G6c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VumEkE9A;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328232;
	b=KCzOONcxndk/nqd7X+H0Ek7wqJFhCMq5GgkI6b5G2f2XRbAxXRNxrCpWwpkrJOZByBwkl+
	Quif9rgqOcfUBfgiYU8mUKaO9s3Kj7zY8s6sRN++FIX5oy5NKKZl4FVZevfE4clwnyPsJ5
	Mk8OSlKRIza/iW42xQFwYp2O7xF09XU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B621544279;
	Mon,  1 Jun 2026 15:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EACA1F00898;
	Mon,  1 Jun 2026 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780328231;
	bh=MgYlZYJBLBUbPtUB4Zws6MmwdGLodHam9QjAHCsM33o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VumEkE9ASepmQtAvZ7iahQyZcQ3xyeLfNHNCkGxe7GnO/pUNRu3AJNMmK4Q2BC2CR
	 6ya87Ptm97Tv1nh12lDihrk4k8lMT931o4Hf/a6Q5UA/NxaKpSvDX+b5m4bk62YJAq
	 l5d/osRIl1lwdCRM2Rk57ugDfeVEjPG8KgTFnLGi2RmX0rMZ6bjBME+kupHkVWwSeH
	 4DMbbnT3ITmSInPd1noRZnkgNyBxki1pypN7eO5CLFskpnDGkFt1VHDjy/wk5Z/gBs
	 IHvZcuDdcJK/zrySBrPklEkunYnsxjMK+iM3grSPU9gHoZ1VbJ6KcNGxtV/4r9j0AP
	 rY1G7jmTAAyxQ==
Message-ID: <89920f87-3638-4182-aac8-23b06784be35@kernel.org>
Date: Mon, 1 Jun 2026 17:37:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next] bpf: Take mmap_lock in zap_pages()
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, tj@kernel.org, linux-mm@kvack.org
References: <20260528222014.38980-1-alexei.starovoitov@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260528222014.38980-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CC0A1A000B
X-Stat-Signature: g3odjhkjxys95xnygn5fnw8b3qake6md
X-Rspam-User: 
X-HE-Tag: 1780328232-554583
X-HE-Meta: U2FsdGVkX1/OIYy6jQmcRdMMqFQplxf7QmlZVoXJbPuhTlEHgGfRLePvAw4zhkaQ+xQ9+dAkVJkR847VGsqzub1punt3LGo+FoEy/Lu2wBcCQbW7hIk2+tdQ2GJIr1Xk87hcQMfaKF6YasPPCKoY9AAP2O8khTIRGxEgi0oKVpVggbDM1mWRgZ6iRzFbCFEupGvWLMooIiNoe4HfzmJWIvumL03dDB1/GKwyZuntLvl2YppMSXVXtiIf74qJBMXa5maSfqKtj1asc2x8PMjxpSaFM4CLppNiVGngI4PfBoc1D+QMS4gqGky0ohzvish4Tx9x+u4iAF9GWo2UKR8M1eOTIhXE/7WPM4fV7FEkWrUU4EUXc/kph8or6SumXbPhyLpMAzGvQeJKhDMUDPBDRo39d+YD7K/mhky0O3SXCQm5RS633mzZm9U06RNz6VIeyEUQDhi/BVL4U7vj7D+qgWF6V5GJjCOYL9oJNxlfP9tw5qiB8PXpgtwjiakkMlnmpTaRBfCVTIyGhymTAjQqgfGFOzh70LMrkk+OKtTrRLZ3vp22egUIL/UCuN2aKYWpymKyDgLDRz1WoXwgE5GJHnwBReuv5kMng1XsKLUhJq+UbLA7y494h/31N3H1WyosnH46/1GEP5gEO4sxsLjXR6PGBpygu6gwj7DLMJoY1u3Dc0dUXYoZ0Z9WSDsNcRYIIybPjlR0lUE9xIhhApmc8UDdAndsEMb9t3f8cI7VnPpEvJLZkQN/vZiEc8A2Nqh6N30cTI8ZzeNVSSzOgk0WPEZmaOo7rWs5wmjFIvdMUYzrdPgBgvn/MwWKlXx21MCzAYIICecxMQTLHAlkOAyZfz4UJT24/bhU1scVOQoTUef03twTp/0W8voqWZtGsVGHnLzHlZI3vcYKAeKDkFJ2RArAk2i626VWkoFsUTe62JufZ317FebTQPDEdoZX0YsyU4AqTt/9sfIyLrze4x1
 DBzcY4sb
 ltH5YoRC5oGhrdReZ+BFqnbCCFUujD8JunZ9t/mafSX29ZBXMOImTxA7w1gHEeeR0xHt5JYneBwEBHaWxVfgwHAdOYePu1O27xmZQ7VTkzkaP6ErPH6JL0uGSfj+6K5pVlfHuwGYiWXHMuTkLrPMLEmLRhQS80FwjPGsapAW/68C6KKGzhQXzXLdSa2n201c3yZaog35FMj9oh63HxQaPf3Lj3sAh/v7xSRi/yQzrJFMm9c6H+WCBYstbdDJeThw8Phl4k+1zhBoAJgCBquDhx6SgZIL7fVJNuGlVXe1ugmjllMn+/ZWfS3WPZIlxb/J7YYwg9hX50Jx/b8oHajoVzZXRcZ928WZpLI3dKuWqx+PtAADhSGW1t8vDPrULaY3PYVxg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
> -	guard(mutex)(&arena->lock);
> -	/* iterate link list under lock */
> -	list_for_each_entry(vml, &arena->vma_list, head)
> -		zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
> +	/*
> +	 * Taking mmap_read_lock() under arena->lock would deadlock against
> +	 * arena_vm_close(), which runs with mmap_write_lock held and then
> +	 * acquires arena->lock. Drop arena->lock for mmap_read_lock().
> +	 *
> +	 * Use per-call my_gen, recorded in vml->zap_gen, to remember which
> +	 * vmls this invocation has already processed across the lock drop.
> +	 * Hold zap_mutex around the whole walk so concurrent zap_pages()
> +	 * callers cannot overwrite each other's marks on shared vmls --
> +	 * otherwise call B's mark would make call A skip a vml that A has
> +	 * not yet zapped for A's uaddr range.
> +	 */
> +	mutex_lock(&arena->zap_mutex);
> +	mutex_lock(&arena->lock);
> +	my_gen = ++arena->zap_gen;

I was confused by that as well, good that we can get rid of it.

> +	for (;;) {
> +		mm = NULL;
> +		list_for_each_entry(vml, &arena->vma_list, head) {
> +			if (vml->zap_gen >= my_gen)
> +				continue;
> +			vml->zap_gen = my_gen;
> +			if (!mmget_not_zero(vml->vma->vm_mm))
> +				continue;

Given that we still have a VMA with a valid MM pointer, I'd assume an
unconditional mmget() should just be alright here.

Or am I missing something?

-- 
Cheers,

David

