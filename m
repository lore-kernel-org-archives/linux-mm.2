Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1980C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63806B008A; Thu,  6 Aug 2026 03:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C142A6B0092; Thu,  6 Aug 2026 03:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05146B0093; Thu,  6 Aug 2026 03:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD1B6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:52:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04F471606C6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:52:53 +0000 (UTC)
X-FDA: 85070078268.10.D97C4AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5449440003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:52:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcxfFCSV;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786002772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsbNIsfooWaTOUVhREzAJgoVbAqyOXtlhAVMb9RLOUk=;
	b=E8u7YEoh0HXA1iFwrs5PDMpQXq2z1zSSp3h6JNL7Dz3BVXn9OD18QEzcltrlthhQubSSSW
	/Tn44bISWbAD2K+BBWFL9s8fAGEGeJrPs97ZxPrdgF8kBWvjvYHpEC5qN5hXgJsG3A5rIW
	DdpZDaWauogesOdwjzpLvglzBkN93L4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcxfFCSV;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786002772;
	b=MK02KVeZIVMAHM6gX9uBzer7uFPTCJDEqtx/CnkC4MfdENdkaJ9HxvqtypjO/dd+YWMab8
	logqnAjnqZHphgD3UH7SPH1T/wSqNOMFnuk6tD+br9zVe7xe/VXKgvQ+ZJjoXy5g/40vKm
	Xx+9wMVHd88mp9N3j4ITY15/rBnQLVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6F6E60A64;
	Thu,  6 Aug 2026 07:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27FF1F000E9;
	Thu,  6 Aug 2026 07:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786002771;
	bh=qsbNIsfooWaTOUVhREzAJgoVbAqyOXtlhAVMb9RLOUk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dcxfFCSVmNmsaZIK66SjPGuU0jQCy91uGIHJfHDsOZrpnVKOexrLpIqQGWVRDV7Ec
	 HmAN0rUoFzjKV4Pnp7bJvIweM4Qh6ubF4wX+Rd/95ORmZ2CUPFQd6RXXFhpfDnawJq
	 OiGTfCtdyR/uSrP30CUnYlZMZ+Vq9XuNFAy+CuFD4mRZ1V+jNx6uodXVL/D4IjecO+
	 H5wmguGkEKr1ShByFyRnKuiS/Qe5fkl5ZB/B5lHg5ebVtt23Ai6nRNxZb6jCja1X+i
	 MNPIazKHRmXPRMu2Cp3l8DOCBOMgFuZz3NdKLB0kxMnlNYVQg/UU348tIFutqpXFlO
	 u4fPQ+07Lu8Ew==
Message-ID: <4c02c96c-d831-4107-a0b7-8019236be393@kernel.org>
Date: Thu, 6 Aug 2026 09:52:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich
 <dakr@kernel.org>, David Hildenbrand <david@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Will Deacon <will@kernel.org>,
 driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5449440003
X-Stat-Signature: 3fkmg3r6ey41ae9ehqpzkinhbzkfe89e
X-HE-Tag: 1786002772-414248
X-HE-Meta: U2FsdGVkX19U9QsNsAA8/olYFTP02Wzr+Eg0SkYX498Vg+lLX/ceDpCI0k8v5SX4YFwkEJDgQ82hIQF9XWoyCgsS60bWrPSLkIsdnxWDJX7NBdj9MIhiHm1PDuF0TaNVe3nC+D77LwwkYk+/WKWJVgZEflmfFGEfR5xr/ZRr8bQi/Qh4VzfREliU5+7yOmf0/jF/OVk7m0x0V5cAcuk6FSXhWYidZTpw1t4KnPNqkh7nimIl9epU0haPx5tYd5eIdKQF1vQAkapqR4Z/QoU+Mz/qwtxCs9va4UtTuUrIDQ1aLd+c0yI6VMtzieT1pKZcdc4KlDjDI5w47k+69j8RJnc4gQ8+AWzCaKo4lHOfk5RgCLW4v60sxZh4rmLX2QRV3YOMfEDGaaCGlj6VSp9/sw4nB1xogSCYNR3l7LJ+v2xhAJ8uK+8zNViSbuma/B7H6hktx9R50xAU0wTTtWdsoSgdISpd7aNBvYyFXwxXYJ80ZD0qeqvPNbgdZVeeUKnQp+Bsx6EaQqCAEwMGOqzlxvQy39U5t3pVxKEksjCfp+W3rcDsXqQxVrsv23KEp8bmTZuLnfaD5Vy91Im2989wW0wAybqBzeNm6qU0eOPqCHUmGf0gLGEcLTf1s3wpss6h91/ROknHpppeQ+sX81ti5/9gfnl4VKMdO5E0tQmwJx2Qu+6m5vug+GXFuYaAq4hNbDOGczHxB89V/szrYEXj3KeiNlq8UfmDSGVDIiJXdsLx0Avd275OL3O8QNwiEy8uD51uTM0NtASFfT7Jj6N3itzJigbuaSLCNuQFgzGaTDZDLFRPn82e3UZ0PkEgsvey4/61OfYPsbgllI26UPL8k9ZzsK/wiH47VXL+GE0nz3Nb2ABixKavWTHnOQ6576N0eBqgvWO0LDGXfgxhdQl+e2/vI4K7uVCW3iTi1caWulqkwbwEJPBQLDwXVB0QgTpx/gDN0ib7MlY/RrFRprB
 gHNh2uvq
 tHFxdgeBeAPFq5vNdDqQSSTRshNzXKdSkfFp476njEshttyE0SAY+RADRc8EuIp0mUxgs+rAAsngD6+Nn+NJ1eBHUJ13JtinihxDvaRwNpzLyYTB/FS4cQBZ6siBxpEI1F7DDEMXKIu8lzdIKAHCZR0OfQLMUWQJI/11s19B/zKEzQ4AauUnUXmw7u1AeZd4QZ8M+kUxtzpuLgY2R9BVPZyp8mDQ5oc08oMHQ+lAV5Vikgt+8QVijftfV+OQtudTBJ1f2IW7eV6cduWetS9dV94ynm+9JSAx+QrmI14N1H56l2e6MC1VBlkKa5TvtsmW5Ydykoq9+a1EIUQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 08:58, Mike Rapoport (Microsoft) wrote:
> arch_numa.c implements boot time discovery and initialization of NUMA
> topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
> and riscv).
> 
> Since this is step in the initialization of the memory management
> subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
> numa_memblks.c and numa_emulation.c.
> 
> Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
> MANAGEMENT INITIALIZATION" in MAINTAINERS.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


