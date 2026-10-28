Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6971C606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nEpzLNv3
Received: by kanga.kvack.org (Postfix)
	id 8FD1D6B05B8; Wed, 28 Oct 2026 10:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC786B05BC; Wed, 28 Oct 2026 10:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2806B05C3; Wed, 28 Oct 2026 10:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 596FB6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:16:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E18C580CAE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:16:58 +0000 (UTC)
X-FDA: 85372236516.22.9CB4ED0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1B2582000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:16:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nEpzLNv3;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793197017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emSS8rGhFSAVh+HSifwB6oqPZ30JVlQSlhM7wMUoNhg=;
	b=ZDLQoUrMQz87cUN+V5QcKx8Vypf2RwlYWrl1lJzLWAATr7SA0lHIWuMfFrlY7mRtJmq1el
	eBFVV/d7JWYCKAeaedE1NO14Vjc08y+dmfkFP1NohyiZilkke14ISlkFKNYSAJbV/v05dN
	RpCYA1dgaQirOxo0KIcprC/MYiHTo3o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nEpzLNv3;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793197017;
	b=073Ctafw6tEFrmovdq3+x0LYnb+8/lsom4t7ibVu4RYdgzepy0Yq3c44W8ZedRLeqzP9kw
	DZFO0wkwWfksf8NpSvKgDOK26cyOCQ8qKgWi2YRSmwyMQ+S6IB+qqrvyV/3HWE/TVo1T2L
	9oDVJlmjAh+84tx0i5kMeIbzYqqGbSo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4015600C8;
	Wed, 28 Oct 2026 14:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D581F01828;
	Wed, 28 Oct 2026 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793197016;
	bh=emSS8rGhFSAVh+HSifwB6oqPZ30JVlQSlhM7wMUoNhg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=nEpzLNv3PknOMyHQDCqjJNXNxk/Uc/Xh6hGOvqmAGnYRM75hq1XI6GjwGRVh3QDUU
	 WPyMbIJ96JuiX9TIfrkO7CHN68+xWENn8oz9SnBTMQTtDod7Jw+YJSqjqKB0z6ueQY
	 J+YjJc/Tp5PBrDEN9hIQo6SKn5oz3hKTGYGOCTydvTr5e4+QLq14Y2E28qKbTLrpO2
	 2DthOftJEg8ZxPlmZOeZrR6Bu+RaBacV3FP84D0QE51AGmBqfDN7DZMzEAwYRcikXa
	 cu5ouLFHOwwZcrz5yM3YVxIOLEklM3lPuD/O0NMM/rfTy5E/nfNz73pg2CuQsm7rv6
	 wHzuZ3koXF/xA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,  <ljs@kernel.org>,
  <liam@infradead.org>,  <vbabka@kernel.org>,  <rppt@kernel.org>,
  <surenb@google.com>,  <mhocko@suse.com>,  <baoquan.he@linux.dev>,
  <pasha.tatashin@soleen.com>,  <pratyush@kernel.org>,  <graf@amazon.com>,
  <linux-mm@kvack.org>,  <linux-kernel@vger.kernel.org>,
  <kexec@lists.infradead.org>
Subject: Re: [RFC PATCH 2/2] mm/cma: reject CMA areas that overlap the
 kernel image
In-Reply-To: <20261014145731.3431527-3-radhey.shyam.pandey@amd.com> (Radhey
	Shyam Pandey's message of "Wed, 14 Oct 2026 20:27:31 +0530")
References: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
	<20261014145731.3431527-3-radhey.shyam.pandey@amd.com>
Date: Wed, 28 Oct 2026 15:16:52 +0100
Message-ID: <2vxzcxstoqp7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B2582000D
X-Stat-Signature: p7gphoib1ebxaabekh6ypuxwefnuijxr
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793197017-599073
X-HE-Meta: U2FsdGVkX1/26DEn0QyVmykp98PsKl3BvRij/367e+Ku84rtQIOJlHbN0hMkr+XFRkR9m6Nyz8tDhrG5WnJtoZO3jA+DApoHk0GsdAvitZx1c9Nleu5fdmglJQRFnaXYFtCf81R0A7nC4/oF3eCr0pe1gc0Un+SmQU/zr4KU5uNUwGVHjpPic9OW3yUoMajp/JpbWyot0VrVNHAdboFbhiUrUq+o0hNLLdyxd1QBxHPKJbx9GfqY2jsA4/dV+ZAfVOhkmqKskoGw0JlR4rI7xwOL5Bd30XdklpjxalVXMiXsAOvmK42LGCvux6WySGjiTlxRnHsrJ7VdDFMQhncYaxoDPNAf/LJRWC7HklUq1V0HTlCMpB2aw9NvtVuX6CeaUVdGjxCbxelS+sxH3AjiVMeIzzP65V4QWO6fb7KBAtGwqwmQuUtPHPdcjh6o9rBSyQVv3vd1jF64qTWf6FpDTyRVRRf+edlzDCPI0CCVmgWgm0qAlxYCmCgK0eTa3EofS+/kJBANtew+0zc+FpJeAsUcpR/SUcqfLLb/oAkNondTvnfODb0iA2N9ijpI72jUSVMvgmA7BiQjVIXzgNg9I6zhsLg27c6EgqfpgPb1KCLUFpZ2Enm5T07BqOzXQDs18CP91p2R9NI/w/Zz/urDtQpW9v+DnHCxPHjVUsFaNC/9f40LxPS1Q1eTwcqMc07pbzc+gRf5dlJy519bY7BY0IYwk0nwQkzF2KkSOgYXxMw1bxNVw/SfiV42+75v1XgJEUKDwNxP5WiCtpXIYhBh0Hw1g/b0ljCDuwJM3NWx00lz9WOZvdXXTGorENp6O5TrtgVY7fW0Apt14ULapy7wZGVO2nH8r0xWcY/2+dK9K9Oqv3umOqgJZJhWb30TjCKlvvMIW+203SDvtUe5mQDch5+9m68Ea/U7qT7VtBWYkQhgFakGujizXHErmoLn+fAB0wJxvdg5iVoYhj3jP4e
 dmNAINEx
 8TwpVi2haYtK89sI1jA6+UCuSaq65KjlEoziG/wzF4zVQVEF1EAxvFfpQOwwNZtp1mICVRYqJWfb3HOWl0uvlQFq+bKeMQ7JhPDxqKr9Wtj+Um4Bt1P6vUxM9UExKdH1s/E++RXNJjkK2Ac/ZG/xbOboMKI0hlbXmGwLEX+mpb9uGTRTGbCa9GmlNB6RQufm8HX6riRqTOubGN5CYHqq4mKJZh69K5IpsdJib6kgu28hIQ6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 14 2026, Radhey Shyam Pandey wrote:

> cma_init_reserved_mem() takes a base address chosen by its caller and
> requires that the range already be reserved. That makes an overlap with
> the kernel image indistinguishable from the normal case by looking at
> memblock alone, yet such an area is fatal: cma_activate_area() hands it
> to init_cma_reserved_pageblock(), which unconditionally clears
> PageReserved on every page and frees them into MIGRATE_CMA, overriding
> the memblock_reserve() of [_text, _end) that the architecture installed.
> Those pages satisfy ordinary movable allocations from that point on, so
> userspace is handed live kernel text.
>
> The preceding patch closes the way this is reachable today, where a
> kexec'd kernel runs from inside the default CMA area and then declares
> the range it is executing from as a shared-dma-pool. On a VEK385 that
> reproduced within ~300ms of /sbin/init starting, as a copy-on-write
> fault writing to the read-only linear alias of .text:
>
>   Unable to handle kernel write to read-only memory at virtual address ffff00084030c000
>   Call trace:
>    copy_page+0x48/0xc4 (P)
>    copy_user_highpage+0x14/0x30
>    __handle_mm_fault+0x318/0x1340
>
> Dynamically placed areas cannot hit this: __cma_declare_contiguous_nid()
> either rejects a fixed base that is already reserved, or picks an address
> itself and so avoids the kernel image. Only a caller that passes a base
> chosen elsewhere can, so check for the overlap explicitly rather than
> leave the next such caller to corrupt the kernel silently.
>
> Note that failing here is not by itself sufficient for a device-tree
> pool. fdt_init_reserved_mem_node() responds to an error from a non-nomap
> region by calling memblock_phys_free() on the whole range, which drops
> the kernel image's own reservation along with it, so the pages are still
> released - as plain free memory rather than MIGRATE_CMA. Callers that
> keep their reservation on failure, such as powerpc's fadump_cma_init(),
> are fully protected. For the device-tree path this is a diagnostic and a
> second line of defence behind the preceding patch.

Why leave the dangerous code around? Why not update
fdt_init_reserved_mem_node() to expect -EBUSY and skip freeing on it?

Other than this,

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

