Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE824606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QYNoTnXj
Received: by kanga.kvack.org (Postfix)
	id AACDA6B00EF; Sat, 14 Nov 2026 14:08:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A857E6B05B0; Sat, 14 Nov 2026 14:08:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DBB6B05B4; Sat, 14 Nov 2026 14:08:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 665E56B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:08:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4397A802F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:08:15 +0000 (UTC)
X-FDA: 85434660150.22.6A39A05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5128B80004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:08:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QYNoTnXj;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794683294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrpYg7S3w1u/s304fksd+9WkuwgFpjkNMJMjxnYOktE=;
	b=TmCNtsbUP0PUgUlhTytedYBlZDfkmHGSjwDgoOeodbhXVoTZ/JmEpQEi/czQgwlpSsjp3y
	MqWrXsokCZuttRqmhIha0kHvisYCI53p3LMuLliN9hnMtdI06Uz4GJ+UX4+4CU/de6u4G5
	jXKdNA1AjnCHSB96HxrNzvTB0RWsPn0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794683294;
	b=4e+/4tD+jflovAx1/sX6EF/9zUMKX4B08pWaH8J6qc0gkR5K6hTEr3ktRjbQDkwp+Vt2ss
	RZuoWItxfyDXPIChG0s9eykUg1DXaMbguPNVyCagWZSdzo2CBccV2Zj/p+rrxB5/xxrC9L
	oreLcMtiqB2kT/PyLbijAgmdEY2KhoQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QYNoTnXj;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFB1E60DE6;
	Sat, 14 Nov 2026 19:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2531F000C4;
	Sat, 14 Nov 2026 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794683292;
	bh=jrpYg7S3w1u/s304fksd+9WkuwgFpjkNMJMjxnYOktE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QYNoTnXjjZhBPnpa8pOfyk2yFfApF74bnIOvALp/oKYkwpyK77UolVRCAS9PWBwUT
	 vTBNeJc2BT3hD65bSUXiJIzuZRodbsdX1fnL8/SMLFCYNn/+H570eO0UW2ZwVw9sWk
	 GMxUycxR4kFYE/1x4BsPOWM6QfVcHWY7lAkRzLGYC2spj4KtaAwckhv3IaoPq1c+i0
	 7WJXBqF1BvvLoxaDFl2abs10ZuIiJ39Ub7KZHMiai60iJ0e/m7v+0PTgqGv8kiifml
	 yLA7l8Fl3UguxEqgTAbhHe6k1GakSXqMGY5FQ9ZyVqlS8LVqbDnHwiqz6bl9cWiY9E
	 wqQgRo+ur+kWQ==
Date: Sat, 14 Nov 2026 19:08:02 +0000
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
	dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 5/5] mm: check permissions and bounds for vm_ops->access
Message-ID: <aviwYZhpXFczMwRR@gremlin>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
 <20261112-access_shite-v1-5-988a5c470db2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261112-access_shite-v1-5-988a5c470db2@kernel.org>
X-Stat-Signature: ykxdeggrrqciwujdbyjfe3em4si49ama
X-Rspamd-Queue-Id: 5128B80004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794683294-780973
X-HE-Meta: U2FsdGVkX19kEDMEIlzn1M9N0ivYN+NW5sr9qekDSmxOdPPeIV4zKg3lhW7nYLD8YJlvLkPc0uXPLOzcKM4NhKrVk5W9ETI9/SN631nyivwe1mp87AOFVs2JT2t27N8ZHPHSSDyksdotwT/8oak56QshmRP+1RoxdbuaQHpSr9910dIXIiwKT+LmwwPj5psc9iW2iNRPtATngTSphnsfk8jX27D0xiZVXJSu6qN0avKrA77fCkVnijhn1WGChLjzM425l4/ctP+3qBmhSe3G01wQkNhQO8E081hxuHdw+sgzdMz+kqDgwKs12SFFNh8RbEot1x1xdMBGva4F8OjGH9T0bZPF+SWAppyrMVM84M99Mh2e9LGmtS4e+ZLCrOzl9sXP7gdLduDLS/Ww6/M9F314hHOu44UyCvnwl4tW609DwGCa+8vWU1nxc0lhM4rWshPE28MQwHFVrKYbVIYxahZJYG5//Rf4dItFK/o08CMbjhfxvT6neyxhNW0jJS3PSe3kA9HB1w9VzrNYNdnGGEszQlfCUcjGIPeAwkeG5PpCqhKOfZDrXiqmhtLpuUqVXM2In9x5K2qz2GXFavLU9lVOWlqjSuB2mgMLpBmKQ9odaRQcZZ8p1Ki/pCz6Y0DF+gFZIp1Mr25E4rUJd4e+DELdTQHKgyFk0xWXSmNnSKvOAEOvkUFRUXLMGG6TC82dfGgbvfh2pDyt1kghXpIh3SjZDuS9T3IMpmEDSUJlrO7Ufz0QCXVxPB3E9wIo3z+BSL3eMRLdf6lVqeIMemVQq6UaLKhS1Jo/zd0cWY07nMklC6eoTlzcPu5ztoIiLEOdBivCIljKDlnW8vZ3Qu19yKut7qL28SzNM+rEw2rgtzlD1qLVRUEHZpkEbqeoZHJWJEgDoHoDM2EevXkgt+AUEuUgb4TOhT73/fHqzs0YTUWJ2aemfg/jGfMmePdeurMiAFxuH9TFKR1Vwo9EHX4
 JAPxKD2l
 yrfkVGWKhDgJUdlCKw8sY1xjTMfSYMsltK6xc0zaDdGDmE+uimASR5S6rlHbOsGEmwzj68cgzbp+20uD2DYhUbhlBTYKCkLtwE4KDcFGGtczRPRUnIUHlwWAvXlYNAigwWFJCmyGxrNREiDXlU1Z69Gun4bMhZFJdRizmZmIBa8cCK+Ty1gffKRmvj5Q2MPYsyK1AtcejDYatra+GP5xvCDcSgfAw15JcLnPomFehNBOzlC35ntdoyldA9taMaEQeQ2euZ3773B0k1l65XJelFOKl98GxqbOYiEwb+RfcrlIRnQCNEM2N2aqy75fBK2fD1wqBZFxRgbb+6vNNUSLttHl8lkWpO6npP0vtM2Z/D4BJdFmw7M6bZEFcXizM7mgXOAzSHT0GdXGX0pAJl1rnGDJZ6OeLRQZ7RKClyPkYdqRJCyhYW8DW96nyXWM5Nj5+6edUk6xvcwJBjjlCu6khqfmR2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:09:01PM +0100, David Hildenbrand (Arm) wrote:
> GUP rejects VM_IO and VM_PFNMAP mappings early. __access_remote_vm() then
> falls back to vm_ops->access without checking VMA permissions and without
> limiting the request to the VMA size.
>
> Consequently, /proc/<pid>/mem can bypass protections even without
> FOLL_FORCE, or cross into another mapping without checking its
> permissions.
>
> Check VMA permissions before calling ->access and limit each request to
> the current VMA. Implement similar access permission checks as GUP,
> however:
>  (1) Reject writes to CoW mappings because the callbacks access backing
>      memory directly and cannot handle CoW.
>  (2) Allow forced writes to non-CoW mappings with VM_MAYWRITE.
>
> This intentionally breaks forced writes through legacy amdgpu PROT_NONE,
> MAP_PRIVATE debugger mappings. The workaround in commit fa5239f2af98
> ("drm/amdgpu: workaround failed COW checks for Thunk VMAs") cleared
> VM_MAYWRITE to avoid CoW, but debugger writes still succeeded by
> exploiting the missing access-permission checks fixed here. Reads remain
> supported. Userspace must use MAP_SHARED instead; ROCm 5.5.0, released
> in May 2023, already does so.
>
> Link: https://github.com/ROCm/ROCT-Thunk-Interface/commit/fea44fab6e84eda52fcf6b419b35600c18f4c022
> Fixes: 272ddc8b3735 ("proc: don't use FOLL_FORCE for reading cmdline and environment")
> Cc: stable@vger.kernel.org
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, yikes at this in general :)

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index d4370c1b331c9..9872f289c1e49 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7362,6 +7362,7 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
>  static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  			      void *buf, int len, unsigned int gup_flags)
>  {
> +	const bool force = gup_flags & FOLL_FORCE;
>  	void *old_buf = buf;
>  	int write = gup_flags & FOLL_WRITE;
>
> @@ -7401,15 +7402,35 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  			if (gup_flags & FOLL_ANON)
>  				break;
>
> +			if (write) {
> +				if (!vma_test(vma, VMA_MAYWRITE_BIT))
> +					break;
> +				if (!vma_test(vma, VMA_WRITE_BIT) && !force)
> +					break;
> +				/*
> +				 * In contrast to GUP, we historically allowed
> +				 * FOLL_FORCE write access to non-CoW mappings.
> +				 * However, we must always reject CoW mappings
> +				 * as we cannot CoW here.
> +				 */
> +				if (vma_is_cow_mapping(vma))
> +					break;
> +			} else if (!vma_test(vma, VMA_READ_BIT)) {
> +				if (!force || !vma_test(vma, VMA_MAYREAD_BIT))
> +					break;
> +			}
> +
>  			/*
>  			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
>  			 * we can access using slightly different code.
>  			 */
>  			bytes = 0;
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
> -			if (vma->vm_ops && vma->vm_ops->access)
> +			if (vma->vm_ops && vma->vm_ops->access) {
> +				bytes = min_t(unsigned long, len, vma->vm_end - addr);
>  				bytes = vma->vm_ops->access(vma, addr, buf,
> -							    len, write);
> +							    bytes, write);
> +			}
>  #endif
>  			if (bytes <= 0)
>  				break;
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

