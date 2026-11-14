Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D80606A886
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XMkwiY6D
Received: by kanga.kvack.org (Postfix)
	id 5E2786B05BA; Sat, 14 Nov 2026 13:59:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593236B05BB; Sat, 14 Nov 2026 13:59:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0586B05BC; Sat, 14 Nov 2026 13:59:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA3C6B05BA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:59:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B365B8044A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:59:58 +0000 (UTC)
X-FDA: 85434639276.10.24F191B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E83F1C0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:59:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XMkwiY6D;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794682797;
	b=mz/R8GMFanzYeCaV4o6Ubywnrk23wVmpXtX12iC/RKUHNHfFLgNyi1KV3e8ka9Qpf08j1O
	FKYtbdWtO8NynSgHmCfbacLMecBKRVMCM/nwoqx75DxPg//hm69pd7ut2a9Hc4uOAaDQ3b
	n0IzY26YW+ZutN728WIv3uaAjfiOLPc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XMkwiY6D;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794682797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaNFykkpcP0cS9Qocp3fy2eSJ2KoYeW3YHSZ5vyz1zs=;
	b=2WYj1/90SGTkh+rDDokAOcR97Hd9lEGVg6G+Lh0/giHMVGlW79/pmZu7rb3K9Gctra/WmW
	Vro21JSJQzyq29XCckBruCzlFruqavzvD4tripEaa76RUkzSCXMzEef5XqdbB2DkzlYyb7
	/IR7kuGbJa4YGL9U0ixtp5BKOPV5Dy4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39F2943B15;
	Sat, 14 Nov 2026 18:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D9E1F000C5;
	Sat, 14 Nov 2026 18:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794682796;
	bh=aaNFykkpcP0cS9Qocp3fy2eSJ2KoYeW3YHSZ5vyz1zs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XMkwiY6DpCIGsfriwGOqAWiPbK24F3D6OKfV/wHCov4+5BCJ1Wsj6VNzuk3cUkr4X
	 zqFlsrkAIPyHinsg2xIoVAroHyZRHs/937xwsCZMYzDt0j3vdA/aNN6AL4a7Ar1UIm
	 xWDZmQtLLMAX/3EzhkLpQva8U9TmOwg1uj+/DyTBWHgO4u2uypjXye5kITKh10eT4Q
	 mXWVM0MJ0Gqja2R0B3NAtgAPW5LNXakn+kjO8cjKvWyMGjP2b69i85RrE6V0+H6sD4
	 Vh4tyCRczjK0QAiDfPX9j729otk3VF/cGRqHlIYeL36JIC/Ihszo0adHvWQDm09JGM
	 rwfddaTkgm1Sw==
Date: Sat, 14 Nov 2026 18:59:46 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Chris Wilson <chris@chris-wilson.co.uk>, Matthew Auld <matthew.auld@intel.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Rik van Riel <riel@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH 4/5] powerpc/spufs: consider vm_pgoff in
 spufs_mem_mmap_access()
Message-ID: <avivjtM2rxpUAXDB@gremlin>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
 <20261112-access_shite-v1-4-988a5c470db2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-access_shite-v1-4-988a5c470db2@kernel.org>
X-Stat-Signature: 84pk5z5ywp7h4n9zazo1wg5otjd6hefm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E83F1C0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794682796-973674
X-HE-Meta: U2FsdGVkX1+uWJcXzwuzecklVNYTYl3zgltrDDcJaTHRSCIvk/Ok+ebmo6HJl/llfXFg84g31Sk3K559JeLCZcdCVYUtTnmkHo3dMa+rx/jfiKTO1bBh6eTqaZ0zlR9vbYfT3oHEmmIzZd/mLfwqoy8x3xgVkCi3u6UmMEIHb46v5+l8ZaBTCtzIYp3rLt31c7aWXf6meFsjVqibalVcCpAKgoBsZw/OT5Q+zSUHfSZhkuaaGPIPLdRMoT1XR0qjW49dNBGOsXMno0FcThCNjCxW0dB39cFNqbEnc2kHope+1hPIhLEL9fEfKg/FQ1ASW5r/ZRyrnrZDJkyPllBn3PlPx+uEsnKxnqU0tSsEcmAVFcKueOOi8mBnXCtMsYdDUNoRFcxA1yoHSwPQcWKz7SzXZgSfg6ZX3fE7R+VnoKTZn+ldfK7iYArvg4/dS/ar/djXfngAR+7wCHbcnBS35q4+kHgnTnhD14pSlSSIXPIlXxonil8prm1YmVZJabVR2+Mvl1khydpVupXNPQrcuaBd3oVS4ONWtMIYUCsnGzXGkq24LLBHPCo85Ix0vjRsMjKS8OMTDw804l51msGxEcU8r+DUd7OOr5R6SFXZcPyDplR3jo0hyqK/RA0Q9zp/FkdX5DsvkW260DFVXVXPHlOYK9cAjfoyypzTN6T1blhSMH2soTjxswcs3jKfK+eQZKHPSAhJ2cdSu6AXAgT1dhbmTOycwhS9ONhfA/Qmiw7bBiU/feTRj9d3IhwcA+hGTvWTgvmJOguH0+Ke+s98gDfgkwS23cEdcMow2QIIXJkgDJhAamnSAwQQHI5JazLEkYX/D49M3FutfiyWeWpVdWbKUf9uuOVTr4E4HP0UdGSI/awDoGkG1AobbhrOAX+Rl871cJbpIk+2LySLbcB6gZkCvFjoEPzqRn8u4m2dFsaOB/Fe+89jpVWtkkHLO0C99bPoZMQCnFuLXDVbgej
 QCW8b7kL
 PUxgmUGeWv5QkM054D0MOyFRNJFwP8goDk9EzkkuDePJVmCPmp5+EWhrpQ/tEZt6twe8AFqFjQblH+9cQCk37khnN7KE22ptvuLfMUo5bfmw8OBUr26TWdd0jrvHiYhJwbOSejlczYnv8P1dyKxBXCYZATjmePd0JIZ0y5PUBxepm42Vff4yL+xkh8SpFZN5dEryUPPHGQuQN3ZdD4kP00hWdzITnjJDVQhLezI6ZbBvnNiTOsXVSkGTgYqTHwMXQbUnoEnXG3LHBp1lxwJ5b6o8cooXt2jbmeshHjpIC9gUAvUgFXSvobG1Mc9BlKX1d5aMPDjF+MZIdsc34gga/up6FVe4PJfnmuA/P3MLiXPSDbume+VinmP4SIN16ADTXrLb9Bv0qNUOcQ1itbPan1daofw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:09:00PM +0100, David Hildenbrand (Arm) wrote:
> spufs_mem_mmap_access() calculates the local store offset relative to the
> start of the VMA and ignores vm_pgoff. After VMA splits, debugger reads and
> writes access the wrong part of the local store. Mappings created with a
> nonzero file offset have the same problem.
>
> Properly take the vm_pgoff into account, just like spufs_mem_mmap_fault()
> already does.
>
> Fixes: a352894d0705 ("spufs: use new vm_ops->access to allow local state access from gdb")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Seems sensible for similar reasoning for previous patch so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/powerpc/platforms/cell/spufs/file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
> index 98c47bafaf678..0a46d6f7178ab 100644
> --- a/arch/powerpc/platforms/cell/spufs/file.c
> +++ b/arch/powerpc/platforms/cell/spufs/file.c
> @@ -248,7 +248,8 @@ static int spufs_mem_mmap_access(struct vm_area_struct *vma,
>  				void *buf, int len, int write)
>  {
>  	struct spu_context *ctx = vma->vm_file->private_data;
> -	unsigned long offset = address - vma->vm_start;
> +	unsigned long offset = address - vma->vm_start +
> +			       (vma->vm_pgoff << PAGE_SHIFT);
>  	char *local_store;
>
>  	if (write && !(vma->vm_flags & VM_WRITE))
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

