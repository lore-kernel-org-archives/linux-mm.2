Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC93606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aPi52GD9
Received: by kanga.kvack.org (Postfix)
	id 60F496B05B2; Thu,  5 Nov 2026 12:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6B06B05B3; Thu,  5 Nov 2026 12:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD286B05B4; Thu,  5 Nov 2026 12:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 322216B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:30:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBED51A0AB5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:30:51 +0000 (UTC)
X-FDA: 85401755502.18.2309BEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 16D2E2000F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:30:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aPi52GD9;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793899850;
	b=08z+1FIL7cA/KuLUUjBPBXT6UPlCtaGyklZGrEG8adF3XuYUkuH1aj0flhNpsrUsV+1/St
	EnahNi3VXpuLXnxcBfzfgOMh6GZt91/COM4txilH7CXGOtuiu3N2r9Qc+Hvx3rSlZjSJxK
	mM9lamrdtcKZXFy2s0nNhZ72iJviB14=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aPi52GD9;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793899850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19B4q+don2ykfC+afUQfWB2iSWW/p5Mb1AKCVEYwGHw=;
	b=5ALSFknj5wcB63oYZF8G1cE8ZWRqY1M94hluTbph8dO9vIS8bi3XEcZ7E9upUXwBDj4pNR
	e3RNYQ/MWFys7uAocdMoUa2pSjJPKvqIb0Ca0MrGYu4tZsjq6/v2ZnzzbxGSM1n3TD6bjt
	ERE84mfuzI49ehGeRzF42AFucOtSGOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49810407BD;
	Thu,  5 Nov 2026 17:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E741F000C1;
	Thu,  5 Nov 2026 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899849;
	bh=19B4q+don2ykfC+afUQfWB2iSWW/p5Mb1AKCVEYwGHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aPi52GD9ZFKz882VYQcy/TqjEMpcGt06GVsERn6G6I7O0rPdLHHtOtfKUqFtAZY00
	 lcN+pOETIDUtqN5/Cs0BzgrefpC9jKLOr/RV2kSUhX4DHGysUALCchrKAmgcUk/0V3
	 ZjUfV0GkhcFKvEBhAu1FRDF2T+PnICkz1ZP6fY3daamGHsW/ga2HcxM1H5f+H3vN5q
	 2G0xrvuXSEDRFE+CDwvHzhu9qFXIqUl/+2g4Uf2m9DxZnFYebY3DqsVNe0sPG8DXmR
	 4BPl4FedNxPwSZmiidquMGJiGeAH/VRAJfxY/x2Ig5WXJMrT5SDCNMHGYj1JmZzCna
	 DwxzYY6yxD9VA==
Date: Thu, 5 Nov 2026 17:30:47 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] zsmalloc: embed struct zs_handle into zram and zswap
 entries
Message-ID: <auy8-5SW9sCfCCbc@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-6-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105044752.1997895-6-senozhatsky@chromium.org>
X-Stat-Signature: 6f9jpzjjaf334woaikuqkccbhzdxoi1x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 16D2E2000F
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793899849-320978
X-HE-Meta: U2FsdGVkX182prsha/p+tG83QnwpbTEFXNGdxACkApRqzsBfrbbhOX9PAQbNTOE8b0leF6hvvUl57LFrquts117MVHJbPwm+IYpE6duo4Ee7xtQFnSrjpucObhcxKYGNO/Jfq1OqDLVD/UVK+MI0s+IyZ0mgY9mX0nIwdsj9Is6cH+PDuYbVJ9e6XaApdFgPqYn1qDph/yuKkk+OPXE/ENd/99x6V3i100B0JKxw2p2Ic2GPMOakDkRhbPReLYcIqxIjKMUVhut+vRl4VyeTei9kpOWg7tHTCVwUslTgwbNUsqNbJ2y9aMsz9ztjoPbJwCVvhWaqrVyYm3xMYoZdDSwWQ7E9Pyh1sf+Zb3krcgB8WIquUsisOLQ4b8AhlyGCzbcZGJfwZxUokZv9HxI8XjXH1mEsPwHEF7siUhx+c45Kl6p9AJ86zLQF9IyHf/w9UFe86ARcih8pxvL/kyNs/Fq9RYQifnE8zoj56vEmdEJWHtH7FlbrfO+z6dtc8Q5Z5AORQwL4XGlyAsiuo6kvwZ7iktS+6yUnqmvlPqT4KMQBDOGtD56wwzmzJRHVVO++UnnKHdp2ONJmhERwyamgEmWKw5/9gtrjPd5gTL9BKRiY6JHPAKaosAtCxrLiALn6LgXnRRVHmdXpWez4NfNbdcEnnHu34WxaapMM4zElKNJTR5oOlTjT5LvV1iVGUD97B7hvdQFL76GB61A5RF1e9E2AVUhEDoRUPSxhO+vrzGB4o/SN07+K8F56BPUGO+on383f+pVFmUR8daKC6xwPYkuaIZZc5oj/G5VaBI+TeFUEBURhEfATbP5eQnqFY1WZPW+GK307BEGXDixe2+UMJWaW6nRnQJXCyPO3FOx5PD+wB4/VdIVGQYdfxFZP7b47jh9zxrwot1x63/Ks9tskQLDfYUaOpuVG6VQSZdmpiEW834MJV+P7Kh55aN1oJTkx4azQ2Bv4CW74LLsB+je
 orukeyMY
 sh6ztmgtksAKGcc3o/xsw03j3oon4aVgfsFvP43/NDVQtm0ePjjbcyHvJMRMmstUHyxJYQXpqakGQehHgTc47AKwKCyedaKD5kSmXIm/NUfWtBuKZENSPc6hIC7gK0C7pabo7pPfX/qPfT1KcPxRmjRCV57kwdSAMcoPj0w4ZIqr/CuFU7FtI+CowWCtMQX1JbXZzbgswP9L2fw1JZcCen4CswQXfEPDwJXh+1hjSmFqVXz9G3DRpDLFQoTRtzN7sp2DvR+dioPcL+j+xOjkDUlEdhzzRq9uSAQz0MTJzp794YbUfiYWqae2tcY4GQ8vBmm/aNwlNXiBiV3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> +#ifdef CONFIG_ZSMALLOC_REBIND_HANDLE
> +/**
> + * zs_rebind_handle() - Rebind an allocated object to a new handle.
> + * @pool: pool the object belongs to
> + * @dst: unallocated destination handle (must not be on the stack)
> + * @src: source handle that currently owns the object
> + *
> + * Rebinds the object from @src to @dst, updating the object header so
> + * compaction and page migration update @dst instead of @src, and resets
> + * @src.
> + */
> +void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
> +		      struct zs_handle *src)
> +{
> +	struct size_class *class;
> +	struct zspage *zspage;
> +	unsigned long obj;
> +
> +	if (WARN_ON_ONCE(object_is_on_stack(dst) ||
> +			 zs_handle_is_allocated(dst) ||
> +			 !zs_handle_is_allocated(src)))
> +		return;
> +
> +	obj_class_get_and_lock(pool, src, &obj, &zspage, &class);
> +
> +	if (likely(!ZsHugePage(zspage))) {
> +		struct zpdesc *zpdesc;
> +		struct link_free *link;
> +		unsigned int obj_idx;
> +		unsigned long off;
> +		void *vaddr;

I think this would be easier to read if you move the declarations to the
top of the function, so that the different logic in the branches is more
obvious.

> +
> +		obj_to_location(obj, &zpdesc, &obj_idx);
> +		off = offset_in_page(class->size * obj_idx);
> +		vaddr = kmap_local_zpdesc(zpdesc);
> +		link = (struct link_free *)(vaddr + off);
> +		link->handle = (unsigned long)dst | OBJ_ALLOCATED_TAG;
> +		kunmap_local(vaddr);
> +	} else {
> +		zspage->first_zpdesc->handle =
> +			(unsigned long)dst | OBJ_ALLOCATED_TAG;
> +	}
> +
> +	record_obj(dst, obj);
> +	record_obj(src, 0);
> +	spin_unlock(&class->lock);
> +}
> +EXPORT_SYMBOL_GPL(zs_rebind_handle);
> +#endif

