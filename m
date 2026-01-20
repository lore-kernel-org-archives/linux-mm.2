Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC501CA5FA8
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100836B0455; Tue, 20 Jan 2026 11:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE2A6B0456; Tue, 20 Jan 2026 11:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1CBF6B0457; Tue, 20 Jan 2026 11:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E150F6B0455
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:26:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3DE259D81
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:26:57 +0000 (UTC)
X-FDA: 84352871274.06.1792E7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 076141C0002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:26:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u/Jbtm1U";
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768926416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/J1YAop1V/r8c2DlUWbLz43fckCY4iAx9abYxpe3Yo=;
	b=F/cFjujZ3SYYZ8mD36kaNUHvHAtSK9ODiDPhizmIG3lBYpLVRGMohMjMTm4dTHKOSFZeY0
	/1VfkBLYPCTtfrCW1dU4CZ3w/Szq9Bmp/3vQsujyeAYYyovmCsE7AnnhoG4wW06QSijHT6
	x6TNiSrtJK/dpKOvW5ynJuRRni1Yg3k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u/Jbtm1U";
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768926416; a=rsa-sha256;
	cv=none;
	b=A0B1hkHabmgjHV/wQ19mnVdduoL5s3zQ0oXDd7IvltlAz619+yHLs8H55fwsYTDh9OjZyr
	KTgMaknUwRz9wdL5pZsLuYsecbDFs0dbYm2p7hSL9r6Htv+AWNG9P5eF2DKtR5Cz6Dkaze
	Rps7GA6sNTwBgRta85l9v3CA0BWFJ8M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7388060010;
	Tue, 20 Jan 2026 16:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5254CC16AAE;
	Tue, 20 Jan 2026 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768926415;
	bh=4ywi/Ge6byP7fAvuQcqc1ZOy3qOB/jgJwjF/tX2C4Vs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=u/Jbtm1Uy7tW11ltZw+UNuQwuvnWlKzzSwmmZlJVZv6+RiqUfcPPqXDDuQNuAsvQa
	 CBF3rwzUzEOnYqQI99rTEJF/0p4B+UHohQ4OG8Fcv67bLjRByLmqjTIcj+5nasml8/
	 Fq8mdc02ZJ69FoXRZuLUgllceE+DLZts0A+7+7FslqKnXo8GDBQvrX6vlh/yRn3avF
	 qzc1f/vB033q95iTw/v9m0JzrKBJnKB+bSvcm4CPZSuLfHlp8bMj8mcfaYy+2sWtRz
	 z9jKx5XCC9uJmPnfArcbKqFqbODWK0TNEPHBUindT+YeOOcjB/KQicQU08LHn+tVOz
	 n51upe5GYDzQA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 5/6] kho: Relocate vmalloc preservation structure to KHO
 ABI header
In-Reply-To: <20260105165839.285270-6-rppt@kernel.org> (Mike Rapoport's
	message of "Mon, 5 Jan 2026 18:58:38 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
	<20260105165839.285270-6-rppt@kernel.org>
Date: Tue, 20 Jan 2026 16:26:51 +0000
Message-ID: <2vxzy0lscks4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 076141C0002
X-Stat-Signature: ttpamb4himywjjq5z14qqknbpaqeijda
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768926415-961815
X-HE-Meta: U2FsdGVkX19WBF7y+nq3I7jwxLmJcmEgzEK94qiVw43XOVTn7GUAEEplhxXV+uSZn7jm1GbT130574rFbOCesrTRMEROszv2VLNperfozIcInWICO8ZVaJgungsHINcm0SAPg55/635AcjPWlry4C2ohKmHyjiGDF/LyEc7tHBqPp0gBN/Kux/VJSQ4/HX6xSaowNLyR+en/yNvkx0q5AGFQke4FjBlhinuPzh4QYvYTCqQt0YcifgwJ0/fnv5X5UJ9h67yrRRzfpISlH81XChso6QdAasWBWtNlaTHbar3gvwpSeL/QeHd1/IHg/eN0wKTq9U/nPRq4oR5XNxXu339X9bRhBYJGMxqiLs46ZL+2KUzS4SddBrDlwvHIOUgJ37kh17O9zumUGjxvSUj5US6jxwjgRLYy4XSI7k6uYFDX+fPj3HKGjiMk3A2Wl3rgRqiIMQWu3PM4KPf+q3XZjpXj0gk4Ouv80qrZnLUWmWutiEk/OFf0eTtMiSby6VqAk8+puuCRXvl0xIp+FqUsCcT0TsM3Nn+P5jXol56CqsX1Mc/5mNI924gt6tzlZFlZFnvulpYjn6EQPKLNbR5giu7ozTICs46Qutz5xYP7mPCc+tq3s+0OPbw87iLC+d5xmDb7woWGdEcOTc1+s3iNv73dsU/3B+b61d+d+VIHciaaRZ1YaovVEpIi7gzGNws1Lnm1rDMeeGMMXWBXEeMzHoxxFfFRz2lmA/1B3PyBt0tA1P+UNAq8nvPI3k1dCsSjGNLf8eXwxkzFtmUYag3Ermo8G1XhKL6ViSeXAocU5uL3EsyuRZE3V6cPXaTUrhH5tTFt2kQX4Dz2x1oTH3YkjnM/Fw9V25yB8txuoFLPrcoHqJHnCcWX5xLCY3tJl+o3AuZzfvpIjQ0rb5WHFahUvI4dUdFIaXkF4DPm9pKdWJum8HuHy9D7Pb6LoY9xxykvWl7MX6QXe5rOTyai2bq
 ztWlAu7d
 MkzDvXoZ8ce0MOtnXSdtXVxAeOMZ4YH8GlkRaAqe2oV1xUDJaEL7yyMEYLFSUJJS6poHucsoGMukrEbti0gd72wNNKGP7z7WKCFi93bs2E6TWUO6KvyJkVJ2caA1fVFDN0lff1uLxERkqdAWsQiXMJVcTy47BD5ZTxuPaGulIIefNxQEqrcBEJYheuceZdJaTA1Cvd5SCr+QCyiIN8J5TnpGzmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05 2026, Mike Rapoport wrote:

> From: Jason Miu <jasonmiu@google.com>
>
> The `struct kho_vmalloc` defines the in-memory layout for preserving
> vmalloc regions across kexec. This layout is a contract between kernels
> and part of the KHO ABI.
>
> To reflect this relationship, the related structs and helper macros are
> relocated to the ABI header, `include/linux/kho/abi/kexec_handover.h`.
> This move places the structure's definition under the protection of the
> KHO_FDT_COMPATIBLE version string.
>
> The structure and its components are now also documented within the
> ABI header to describe the contract and prevent ABI breaks.
>
> Signed-off-by: Jason Miu <jasonmiu@google.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
[...]
> +/* Helper macro to define a union for a serializable pointer. */
> +#define DECLARE_KHOSER_PTR(name, type)	\
> +	union {                        \
> +		u64 phys;              \
> +		type ptr;              \
> +	} name
> +
> +/* Stores the physical address of a serializable pointer. */
> +#define KHOSER_STORE_PTR(dest, val)               \
> +	({                                        \
> +		typeof(val) v = val;              \
> +		typecheck(typeof((dest).ptr), v); \
> +		(dest).phys = virt_to_phys(v);    \
> +	})
> +
> +/* Loads the stored physical address back to a pointer. */
> +#define KHOSER_LOAD_PTR(src)						\
> +	({                                                                   \
> +		typeof(src) s = src;                                         \
> +		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
> +	})

Nit: not a fan of exposing code internals to the ABI header. But without
this the definition of kho_vmalloc_hdr won't make any sense to someone
reading the doc without looking at the code. Dunno if we can do anything
better though...

> +
> +/*
> + * This header is embedded at the beginning of each `kho_vmalloc_chunk`
> + * and contains a pointer to the next chunk in the linked list,
> + * stored as a physical address for handover.
> + */
> +struct kho_vmalloc_hdr {
> +	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
> +};
> +
> +#define KHO_VMALLOC_SIZE				\
> +	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
> +	 sizeof(u64))
> +
> +/*
> + * Each chunk is a single page and is part of a linked list that describes
> + * a preserved vmalloc area. It contains the header with the link to the next
> + * chunk and an array of physical addresses of the pages that make up the
> + * preserved vmalloc area.

Perhaps also mention that the array is 0-terminated?

Looks good otherwise.

[...]

-- 
Regards,
Pratyush Yadav

