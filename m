Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D627C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DDA6B0088; Wed, 14 Oct 2026 15:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5BA6B008A; Wed, 14 Oct 2026 15:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E076B008C; Wed, 14 Oct 2026 15:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57CA86B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:46:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C200916070E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:46:58 +0000 (UTC)
X-FDA: 85322264916.12.06980F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 219DE160006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:46:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmQVoIwa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792007217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkzoqxTdzmAg593ZpIds3NlLUMIFMc0b1AE/YCVZDWw=;
	b=yYjgu4hlq7OXk23xJpzb7Zy4eHv3KvQKw2q+XRcu2Ak0qCYvdr6n0CF3enOuDVMMITNsuZ
	fINQb4wf4HEWZ9LDlN4gWiy1p1WTqcXpsvv44jwwg0CNTjWf+ylcv8EbN1awLc22dEfTxt
	7ZL/Q2TPED51tzU+P1603QqQRE9psKg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmQVoIwa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792007217;
	b=m5FWeI6Nat5AfWLbMtNArztE1k3oyUXLBwIu1tLO6e7n/PgOIpaicBadj6MTHMf7kGOyMH
	CNGOHYjWmkh5Np6FdDjqKNTbmpQej9E4EYzYpHhqL51xdXDbr4I/CUgdKj0bepuqh/AVaT
	s+1WyAFKT09orVQmPZqUaqsiXayQ2wI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45E1860098;
	Wed, 14 Oct 2026 19:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843F91F000C4;
	Wed, 14 Oct 2026 19:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792007216;
	bh=VkzoqxTdzmAg593ZpIds3NlLUMIFMc0b1AE/YCVZDWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RmQVoIwaX4F+m+QOTfBZ/BEap2Ci3CR8vUwT+k50W7Jgus1MTHRpWoDCeRk3szKas
	 uzosIYzkaiam6ix1S/hWjqoS0TxPoO4a78Ix3OO/QlCm1KxycxhrmJY+w49cFxMjwl
	 sk3k3ikgGrwEwt4FTM8SfDW2xPJnk3Dx29n1Nde0Q2+khRQ3bZthoThKsbDyY9fCQF
	 V3HBMdhNdz95Pk/NV2mftbwGl26FI4HxJ+7kXD1zqiIVSFJf7Yhh0vv+10/yJfQq8L
	 Ba+aRlqD7WHu3E5lC8suYwgKJ6fMw9JkM3+Njs0J4n1Tcuzpnv7F1mM/eacKy4v12z
	 hrI8yQ7+5y9kg==
Date: Wed, 14 Oct 2026 20:46:53 +0100
From: Harry Yoo <harry@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "Jose A . Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2] mm/slab: sample slab_state once in
 kmem_cache_destroy()
Message-ID: <as_MPz_gXzkuGqFq@thinkstation>
References: <20261014150844.8536-1-kaloz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014150844.8536-1-kaloz@kernel.org>
X-Stat-Signature: r71yhikw5di5m8p6ktgadef1pwy1pffp
X-Rspam-User: 
X-Rspamd-Queue-Id: 219DE160006
X-Rspamd-Server: rspam08
X-HE-Tag: 1792007216-932555
X-HE-Meta: U2FsdGVkX18+EUhkAzcgiEbWX+znQFHCCeOjdJQ7U2AYmz4WjcAH6OlTakX0Kfrm9gsDXZu7E0spcjEMKAefMab8LdSAApCQHNLWCbXPnU/QfmCa4uK8bc8La39V/1f9fs8nMy7mI3/ZRMSzqUil/gqYzyD5PpMY3bazqkVd+o0T9gnI1shrl7jJcBSnXdUY0WiO2JHcZYqYA6JHefR8d9isd2zVh9dd9rWy4A7WqhGTIIcfaXlH+FINAoWQWflIzc5V6J9++tb9Ao9gKYegXGjl2MyM75klh0hRISGxOFh1PoW5Nod/O3aLETx5I79V6QrccAh69P3xJzNo59zTFhyh31Ix2brucxshLiXvNuw3crenPq0diB7YDdGgsIgDCS4BNMoUpISeUkn12QQZSEyB7z80Z7vWv7ys0UwrKk4WY2ToQXLkNN/BKY8s8xq6TNqNneK8lUVIY1+gIOtqdtmQeILWXZLohOtwoO8UD+LLWyypOoVM8INR1ZCOGM3O8na+8gvtjWSNTtaTjx1corKcfOxzAJEJ3i4J3EwenahL75N9eYdoym3/OJWosIj3rslZPWVk0BzRtBkFZxbXsk85W+XP8ghIToczJo2KE+u0LBn7S1n7jDrSbyQopco59Vo8nih43Oj6gUfY+hM36+eMBfSjM2Ed7SEjpv6xcMZ9G/cMeX2/PSiIvSj13ufsQvzHVRN5L/YZr47pym08xt0U/fvPqurIuzA35iQ8iwNVOF+Ia7hjzYqTUbxtGiuMS4BbEz3oCk85WkEBzQev+yI0ltSP9/5b4x2y3b9eT1FdRrW6XvBuw0LhzrHZhT6leeBVUjkrIevsa+EZNmiXeFGxEOu/Wbsnw7wIdsNRzUE4tRkOp7S3y4ii7ZfXvHsoCx7hW5RzSx65p2LZChIR5SfAFqvmqm2/EUoNUil0HJNnwP5zY7j6D6S+ElrQR9YpdvbWaisHZVRhawuwIlS
 sJC1+agE
 J4Q1rf5qXztEdli+pZ3SrNO0X6RNCVywXA6YKpQ9lfnHztESiV/hQw5Skng7j4k4QGKRab2tTpN9hw/RFE8gwZLd2TIQd0IzEN2hXB12lIReWHAJ0mM0F6fCNAVzSv7jPmBIGpDE5ovjZdkExmwAp85rqworFFNDD8szY/gEy3xRK2UrvbBnoAH0gp+TqM65nSn+33U2ZgYriuFawuBCjpIDf3+u+ZXU2FEygae45eYfvdSaAfm9Me55Tj+X39n5QJ7SjjLt63qX9zqy/2ynWkfvQb/HgPznClcOX43JHuKgt/s5GCmHD2aARcIA9Ai4FB7COKwqv91Bzzz7wUt8Y5MuAow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:08:43PM +0200, Imre Kaloz wrote:
> kmem_cache_release() tests slab_state >= FULL after kmem_cache_destroy()
> has dropped slab_mutex and unlinked the cache, and for a
> SLAB_TYPESAFE_BY_RCU cache after rcu_barrier(). If slab_late_init() runs
> before that test it sets slab_state to FULL but skips the unlinked cache,
> which never got a sysfs entry, so sysfs_slab_release() calls kobject_put()
> on a kobject that was never initialized:
> 
>   WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
>   kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
>   refcount_t: underflow; use-after-free.
>   kobject_put+0x64/0x2c0
>   sysfs_slab_release+0xc/0x20
>   kmem_cache_destroy+0x104/0x1e0
>   bioset_exit+0x13c/0x1e0
>   disk_release+0x54/0x140
>   put_disk+0x18/0x40
>   floppy_async_init+0xbec/0xd10
> 
> The release-time test has run outside slab_mutex since at least v4.4 for
> SLAB_TYPESAFE_BY_RCU caches, and since v6.0 for the others. Since v6.12
> the unlink-time test in kmem_cache_destroy() is a separate read of its
> own, also after mutex_unlock(), so the two can disagree. Both tests ask
> whether the cache has a kobject, which cache creation skips while
> slab_state <= UP. UP is the state just below FULL, so a false sample
> cannot skip a kobject_put() that was owed.
> 
> Seen on sparc64 at boot, where the asynchronous floppy init tears down
> its bio slab while the late initcalls are running.
> 
> Sample slab_state once, under slab_mutex which slab_late_init() holds
> when it sets FULL, and use the result for both the unlink and the
> release.
> 
> Fixes: d50d82faa0c9 ("slub: fix failure when we delete and create a slab cache")
> Fixes: 4ec10268ed98 ("mm, slab: unlink slabinfo, sysfs and debugfs immediately")
> Cc: stable@vger.kernel.org
> Signed-off-by: Imre Kaloz <kaloz@kernel.org>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

I guess it's late to queue this to slab/for-next-fixes.
Let's queue this to slab/for-next for 7.4-rc1.

-- 
Cheers,
Harry / Hyeonggon

