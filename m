Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D7C606A881
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QrNKwZwA
Received: by kanga.kvack.org (Postfix)
	id 014A76B05B6; Sat, 14 Nov 2026 13:58:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E306B05B7; Sat, 14 Nov 2026 13:58:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44B16B05B8; Sat, 14 Nov 2026 13:58:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6DFE6B05B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:58:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F13AC0460
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:33 +0000 (UTC)
X-FDA: 85434635706.04.7BF2BA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4897100007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QrNKwZwA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794682711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbMRE2X5e/AHLMS1eoGd56ly9fU3NIj/Z6Js5YflNNw=;
	b=2pzgxPVLX/T+CaT/ZV2/ZiQS20vGhYVs+hevROeVlz8DoDsmde7JJn4fWrWxRG930mqaL4
	cz/N1Y2PHV9ceeE+uRHanzZqvcM7XDsIuJmVMVpeQumFr76sNuyInQe2k3+3VRVQcoFByj
	icd2u+vVsBAfdJhgP82TAOP0cm16nmE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QrNKwZwA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794682711;
	b=nsGrXKs8I1oivTmjgVnIpR+D0lXaiEUk3sfDpzAcmQxppbz6kEgt0t97hFkfHW/UNx3wnH
	TVm5nFdbJ5FcrSm3sxhr3a9F/8uJ9wXJtVMADieatrA6UgXr3ut+uIUEBE6F4W1Eht+3Ur
	L86mUwGxZu2jK2lX0TbazQluYBRRGJk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E86760E15;
	Sat, 14 Nov 2026 18:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705CF1F000C4;
	Sat, 14 Nov 2026 18:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794682711;
	bh=fbMRE2X5e/AHLMS1eoGd56ly9fU3NIj/Z6Js5YflNNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QrNKwZwAQuneaTtIjhUo4EUrUSYJ0Tgqq+BeI6i3EclcZg5Aj0cKdFRA2jWkaRwVM
	 o89/ZYvAdf+R+m4hwUnNiti7YkwNBxWtmrgYa16vUWoUKDg2kwR8Pyn2ppXAWGc1rE
	 Odhrb3oyldEOoXHE8VirjW40E7ouLZcuaBg2Uvct+GTJGPFpgY/zNGoh4D1P7J8bcn
	 b2LWJ3PKD+DMr0cigxJqKKOi4hps0f2zLWEdtnX4RYGDbBO2mJSQHrkOmPTL9ujpE7
	 VFFpA6W+fv+gE1ajgBImOn3GCzZXx606MCvodl4cErNAR6jXS0Okksz/7gb8sBZdSa
	 6cOWGRzdkaSmg==
Date: Sat, 14 Nov 2026 18:58:21 +0000
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
Subject: Re: [PATCH 2/5] drm/i915: consider vm_pgoff in vm_access()
Message-ID: <avivB9Pw8I_oMbpk@gremlin>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
 <20261112-access_shite-v1-2-988a5c470db2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-access_shite-v1-2-988a5c470db2@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B4897100007
X-Stat-Signature: yoigc158y76mo5o5yqa6t5o9tyfa5mxb
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794682711-128695
X-HE-Meta: U2FsdGVkX1+3GsoaPM4uLUvemy+LB3qTn5vFp9EA29hwUD8Q5y0KIxMpOOSyKgLZ376Vc9cUZRuIyMvmTTKGQkPhGJ22S32WlkfYYQj6XYE0TF+MTZx4hNNwopTVO2E4GpnnXhHwtALzatJp64Yg5pnTpGsE7q1X0f7UNF7hXIQWp3KTqicAlgVR2023MfYL8U9AqKEcbOlL4ckfG3EkaoQXSHN/PqOLiObAwqcd2Cdd7VSCbQN9RFR160RMRuPgRA4lTw1lXKil0amPXUogUFvXy1zZoLVl0V4Jk2gLITuwtz8HMYPWthS7IfIQ11Xlx1p1c/MckWEMBQ27GEqKIbiv7PfPvVdTcR8SOKX9NmjPr0GQaEmrP4BR8JBiCQSIWvtFvNtTtzoWYnvp+eXCRI7P2t1C+MpazBqeUYouUxeTS9sATZekXAtmXbQ3yOlqC3YjWGx5SxT7Nd5Ft5bfPg+QRTSVKu3EjwEzQLhrxjBJB6wSpGen69awQSwlVVxvG/k5AL5e5XLHGE43rS8jp/Dnv5xAXUTWry8Y8t9Uekjg/VDnx+9+8xMg5QqJcUVcpD/DTaAZtEEbWjZGNKH0s5nmHVacvLUh1QhxRBKaLF/8nFg7FRoiT2LCZJTBddqkhGAuHqVKJSIXHOkvfm27YpcKo5IpfQraLEYbNu7wqalo6YjOjaWlzdZY0A0eGrBBdwCAnufoxebEa9ctAOHH6L4cuVRL5ftOY7KUEkP4vKmv5Nd2rRhFAg8/c8GtkALMe6zZ6kAV68mWZRbeqq+O04Bn5fk9zbIrNMz8ATmbLPozZUFqLndw22DNA/6BVr3y3yLzDYs7Z/J0JeRzw45h+rbOSQPWX87fer3xkINo0MdVWSfwFr5Jyi59OoJ9maS0GaYpbtplpMBsH5tmeng/a20ItWx9gxkBSdjmO19RiHlMf0fd7XOW1YQL53auyLT+DBIU3vIzlZFsmCSsuJZ
 qrOIVoVU
 cP3LVDNkTi/rwU9w+oLcgxC9rIIVqPrA//xNs5pZNOovunJl+kjc36/iC1sCLjLaQKmMhyaGZkjM/dKlY8j7PoU44ip7qCT0EahPBvmZrz/Ax5gpI9OJZL/9dAysHj13RhNvm7m3XplLK9XOkljUGXzkCPDFLbIlrh6xD7cP0SG7Mr0GRRVXD07D1dNDCxaYX4oEi0AG0KpYWwYt+JAKSwj+ehZbnyWsOI1mM43+YPkxViWBL0vfzbNiRnUzRd9oWXwpQrWkWW+OkIT98wjUFKv857SuzuMo9+aGvzbP8YTrJUo0QvPLfBFcU7NqSVQl00O1Ts1Ia5OlezGCHcPSuI/aP9aYofFJ15ak4UBn2j84Od7ylAq267vkiBAfNOTxy1OZ2sb1sGiX5+1epoXYbpVXL7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:08:58PM +0100, David Hildenbrand (Arm) wrote:
> vm_access() treats the start of every VMA as the beginning of the GEM
> object. After a VMA split, vm_pgoff identifies a later part of the
> object. Debugger reads and writes through ptrace or /proc/<pid>/mem then
> access the wrong bytes.
>
> Properly consider vm_pgoff just like the fault handlers already do.
>
> Fixes: 9f909e215fea ("drm/i915: Implement vm_ops->access for gdb access into mmaps")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

And since this is an mmap-an-fd driver thing there's no need to worry about anon
pgoff etc.

Looks sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  drivers/gpu/drm/i915/gem/i915_gem_mman.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> index 6b337684dbfe8..e3b24dc8e94f5 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> @@ -511,13 +511,15 @@ vm_access(struct vm_area_struct *area, unsigned long addr,
>  	struct i915_mmap_offset *mmo = area->vm_private_data;
>  	struct drm_i915_gem_object *obj = mmo->obj;
>  	struct i915_gem_ww_ctx ww;
> +	unsigned long obj_offset;
>  	void *vaddr;
>  	int err = 0;
>
>  	if (i915_gem_object_is_readonly(obj) && write)
>  		return -EACCES;
>
> -	addr -= area->vm_start;
> +	obj_offset = area->vm_pgoff - drm_vma_node_start(&mmo->vma_node);
> +	addr += (obj_offset << PAGE_SHIFT) - area->vm_start;
>  	if (range_overflows_t(u64, addr, len, obj->base.size))
>  		return -EINVAL;
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

