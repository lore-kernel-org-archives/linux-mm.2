Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E87606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+siPjM4
Received: by kanga.kvack.org (Postfix)
	id B875D6B05B8; Sat, 14 Nov 2026 13:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E6C6B05B9; Sat, 14 Nov 2026 13:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C506B05BA; Sat, 14 Nov 2026 13:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84B536B05B8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:59:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0132880439
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:59:10 +0000 (UTC)
X-FDA: 85434637302.09.0C529C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6934A1C0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:59:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g+siPjM4;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794682749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RzpuEYsnkvuLxM7zo3RdF3Gc3FUtoCDNsh2Uv68tmA=;
	b=YOU86tvUa2D0kax2T+KUmIio5lUOUoVtlbGmh9I/K+6EmnREaYt42vHgrj+D7O1JZhQBrs
	Pgrp3lKEfZJfrUm9WBprFieLB1rxui9+x1nNJJ631GAcVUYfb4Tq+Oj0R2pvJC4+QaUcQp
	TEYDUrfUSQu1Jcju1MMN80BTRU9lBeY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794682749;
	b=EIj6ywR2I2R1b9KnsROSTV9MR/Co+JvjSnMr76Knkf4pwtfZDOdiPYHw3ZjcCBsIYvYoDH
	1UdfbATdFiQHAJPUXlcVXFEJ/SFb8JAtPG147WUoNwzSc1zm0AR3lQNBlT4Ol/THNeH4jO
	aBgDAaC6NUYsLLK+C5TWOoudCTEMedY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g+siPjM4;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEC7660E15;
	Sat, 14 Nov 2026 18:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B311F000C4;
	Sat, 14 Nov 2026 18:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794682748;
	bh=9RzpuEYsnkvuLxM7zo3RdF3Gc3FUtoCDNsh2Uv68tmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g+siPjM4yAFSviPGPS/cwHbu8OZzs8PoMVBZNdEnXQLMBPyyPFkTXapgCKl/hjAae
	 dCJNWlK/TEWojBDTpL/ghuz087T3k/gyiU1eB4mNldla+3S52rlDtKLQugauMusEqP
	 6RRTxZxPcFw62PN+1KM6bBdAb6eh04dR903SHM9pa1o6uQw8B29gZKllO+p9VBvKP4
	 AykfttBIFa99OrjXCIgHJOPgJL1GKmxAXilXFDc6jR9GA0S/RI7teedpBYOyDfm618
	 MHfCc3/0hBDuNZP996VXFGHsvBIYJnGDN7X2XFBKb+zgXGpV+9xAoBHm8lRzgwoq1R
	 tW/dULWGdjNCw==
Date: Sat, 14 Nov 2026 18:58:59 +0000
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
	dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/5] drm/i915/selftests: request read access for mmap
 access tests
Message-ID: <avivbKZSctYksFqd@gremlin>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
 <20261112-access_shite-v1-3-988a5c470db2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-access_shite-v1-3-988a5c470db2@kernel.org>
X-Stat-Signature: k7wrx1mn7b4osqth9f6tdyr5qi37oc5q
X-Rspamd-Queue-Id: 6934A1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794682749-815218
X-HE-Meta: U2FsdGVkX1+wpMAmsjXnPqL8AAR8VVlcQWQ9lPDwW6IjUm0hBkTWgBUryOR0u+UDY9aSoNk9+x53KDYtzT8vkaw2pEOUE2fSRrKh+k7qNvosAbuAadnBPrf/bd02jO2KRxZNhoF8vlZ1TywYYLjBj31sER06w3yEcykcgL0236mQEa9zsUvr9cmwXo9AieOWgIvo02jpiiLu1xDf2LFxpzmwh0OHykxs9hXOgAkN/R0oILtoKwY+vXJQM+rpKPL1mEmEI6wN8YSa1RnocQBkhupl5fL9e98gXgkKcsOtrm1QQEc/+VEXIG6ZtmUYDdi5ADnofzB5I4ajp09AYiGPRoknU5brsbL/u5FWSbLOEDv2c9sjxiD1mCqiPCn1WNJffVC05W0hZwx34NjwH4QMwBXmuVlQZaL1f54HqkgGOAEjVrQxjIB3r58NJBDqCNu8noilOhbcZccZMLOGXG2nFeHCIBneQzISF66wih3lXU/mVOYuZlC1s90Ms2idwjFWqjUyK2syNHemBUq5lAQgxgfH93V/syNxjOrPTkmaclxdM+Ln1UQmFo7W0a5muQxqMwtixLUt9IuHtIS562NYcMP6YzHBvZewZNLE57h3vJ4R9nnQiH7IA5o4RGQVPNX/J5AT428+HpzRuECwqvRMURebCSGpjN0xRbPkOVW0JuU+6hC7RtMnO8Aswatg2a85GPzd+Hzw4v4FTW0r79AffZUi5Sst6R09XHD+HZvS9Kl5v0WI1nYdRQWjwCk7iQQYahM09syZgC7UNj4qvWOf0Jm98FPKlxUSBVfQknQFwuH2l7c7KCyYBCqsDcqgU00gaqBDipJjWFA+Bkf8mQFiBPeqPwRgPqEDAUZlEan6FuEIF5jB2f6WXjZ3O87odVaz2io9isGJDYPevm2D4NaprUlENmyT8mOU0lrfGHDGYEC6nvBdRrLC88TUmJZ3iW32rdiLDfUgeicigug5Fsj
 xbxQkAjb
 ctM+UnC4Zl4eXn4hM9b3wVOrYGNkDIM9HgzDn8KPamxIUyfGZl3oxfBQGB1vd6qBnu0pFxQDbJKIx/m2KFPaaZhfKRjMGbeEZXx6zEDNh8L7HE9AoWceu1+7mpRfOFV41V8DpK2HFYKFp4rVAuXxTvOIJRCf/FaIwCery8G2umXJZIvw763j2XlbNjXKtHDI6ii962FDU06frxs7PnblPSnDxVfjzHXcYlPp9ZTVIflH/BMoQszi2+4bzaph7j/WIFlpIpxCxvwfJbcU3ChAtIxYzcZV3Wv4Oe1fOHnjIf9L49BFRFS7kjc21mKOFaV5ZZo+d438ELwjrLG7COhtmL33BeS7kium9gYSx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:08:59PM +0100, David Hildenbrand (Arm) wrote:
> __igt_mmap_access() reads the buffer with access_process_vm() without
> FOLL_FORCE, but creates the mapping with only PROT_WRITE. Request
> PROT_READ as well so the test remains valid when we fix the ->access
> fallback to properly check VMA access permissions.
>
> Fixes: 9f909e215fea ("drm/i915: Implement vm_ops->access for gdb access into mmaps")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Seems sensible so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> index 303be698891fd..d9c828032a1aa 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> @@ -1460,7 +1460,8 @@ static int __igt_mmap_access(struct drm_i915_private *i915,
>  	if (err)
>  		return err;
>
> -	addr = igt_mmap_offset(i915, offset, obj->base.size, PROT_WRITE, MAP_SHARED);
> +	addr = igt_mmap_offset(i915, offset, obj->base.size,
> +			       PROT_READ | PROT_WRITE, MAP_SHARED);
>  	if (IS_ERR_VALUE(addr))
>  		return addr;
>  	ptr = (unsigned long __user *)addr;
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

