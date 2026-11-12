Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4503606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzMZ1Oh9
Received: by kanga.kvack.org (Postfix)
	id 481E96B05BD; Thu, 12 Nov 2026 06:08:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD556B05BE; Thu, 12 Nov 2026 06:08:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236F26B05BF; Thu, 12 Nov 2026 06:08:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F35326B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:08:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CB3D80518
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:08:54 +0000 (UTC)
X-FDA: 85426194588.25.B392D17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DBBE1160004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:08:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NzMZ1Oh9;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794481733;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8LeQJ3H9vwXd92l8n5mDTq6/jwXyFVP+xBw8qc6N4w=;
	b=1sNvZG6xyZpgy+D89dQCDSFx9uZzaI2YZyLMoa8ot0fzryesLViaf7PNMVaDnTf//7OpeI
	bnCePyTG7CcUGf7vIVBYbJ2Utr7SvYLv4dXamNYGY3D3LyW2jLksjfaIUTVeM7IiotsKrv
	DHbJVRnJcVIUGzbIY24rWf3IkUcmUas=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794481733;
	b=YO+HqYPkM0Mo3AIJKzSVuYLQrKE/2OjByOsMM0/86rPgaJKx8GjFN4iVH2SaJGgpcwxcsJ
	cO+jsvlXgNeHCA8nry5MPAgQZgn5qZiLBPAOhxepHO/v82LSmF375lqfOCCSkOQzTX+S9K
	ymX2G5efkdbPwBnmkSDNBbgk1A3vA0M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NzMZ1Oh9;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7443B639FD;
	Thu, 12 Nov 2026 11:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFAE1F00A05;
	Thu, 12 Nov 2026 11:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794481732;
	bh=r8LeQJ3H9vwXd92l8n5mDTq6/jwXyFVP+xBw8qc6N4w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NzMZ1Oh9HxHZ6qAk5EfPB8RIuILKq+u/heoaTo1HB53tH9+5pAKywe7KbvOxoq+zA
	 XATFxvjljrWRPI7iflpDvHXoKr30fBFmSTI/XNfdHoHHBI70Yl5971B6lXqcOjBPPG
	 iavS4XP4C9ZWMdrlksAJ6tvnCezzRTD0/4Ty3BOZM5/lQekHC75pQrP4Km93UEIyK0
	 IoPO2Yp4kzZkeJIjSK9qStqxhk+wW7s9m2pgkDzXwaaTkQ9WkbEpsd+YkIXUXCgBW0
	 3PsdCBnlJJ8x3WMAd1B2QG43Rlw/jWyA0Y9rY3LigHytx6iUKLSjfoOBvfehna4gln
	 VIwlv6tgvLALw==
Message-ID: <sashiko-outbox-210997@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/8] optee: Add support for lendable-dma-pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>, catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, linux-mm@kvack.org, op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org
In-Reply-To: <20261111110738.872947-9-vdonnefort@google.com>
References: <20261111110738.872947-1-vdonnefort@google.com>
 <20261111110738.872947-9-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 11:08:50 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: exa4xesjh3cey3ai86zsmqrjmfm4m6sm
X-Rspamd-Queue-Id: DBBE1160004
X-Rspam-User: 
X-HE-Tag: 1794481732-722988
X-HE-Meta: U2FsdGVkX186kAdzPukyviPySbyo47sE1m8dOrgtSku4OhDpmiDxGmHm7x7w8QqMOpiTjFAtUS1r0Gp3OJE4u2rrwi0C9oqi1Id3b2wUng2y7jiWjaFypP/JENx39kzmln45AjpuRlM0lqK3Pq4iz3I86wApFfL2JtQ7A+Vf9PtaOAqUegwpQbXZucOPhRYzAyCFvqoE/Id7Sl9sHU34qEPkohq+IKBNoZYPIuq4CPvHuv/ILO7kNci6+Ul6yFFcdoeMD5xll/0WbH6MyXYVyOKh3NeUbZZKiNcfDouvGHHxHbj+BGLJXFQi7kcsdSOCJRwAepTysJqhqKgzXqGku9RjuBmIlNBIDLmYHBdD5QVanCIRp/aPgEVXXTyq8k5Vn2r2sQOqD/bYsOXf+HEwW+m9M0YGvFSKoGDcpmGmLJNZuConUVnw7tbTZ6tsQayMIdexmwyj8o1tgr8al/vILlaFrItBWQj5h+ECfyMa7QYcIgMTXzBJ65/Tiw3sE4iwHGXnyGCmQOLY4Fe18UbncbYYKOMNMNrWbYckuKz4D0P13PrKvgmUGKO9ZWqyFTBAdbhk9j1iKLqpzL+YG32FOhOpFTuftkM8qZHNNB2PyWeN88m5aY68wFc2paNIHMMdaIGSkBrXHFd0W+2VEpRsS3VdD7i8zkSMC26IsOU73JLauz6p+M3NH8JBt8qFtZ3EY2SAvGzriLDzljYPTt4tVOtLWjJGQmgWe77UaO9uP7j5bhGnsXFXm68kbNPXNrPv1qar7T+c+0NFMHy2U4XfGIt1MXCI4kzJm+GJQZXFCcnTw3soTP3kgnXMapSWWGRentlkvekA1N6zM2uRX9qGbT361YKb/c+Qbnp1nFBaynCKb2ubVuyWCLnaU9sgqGZ3lTehF4pGGQiILplhLuEtI3/xkiVwuJQxAvJmw2LHWEyPog48rQ+iGuNsJIhcHt2VnQAp9pXwBRBKx8g1ROA
 +DuLjcf2
 65NBEp5meE5iX6F5lHvNU2NEiqIU36Y1MJ7kkBgiiRgPuIdTUnKJV1Cw5xmSy8FDuWqRtBSIPvEvLYs0mweO/QxSXK4MaKZwhegJ3aI3qNHYNyN4f9gpL5R6Ysr/oxlHnXIxOx1hPUGli0+71wIcK2weue54VfhqLTjv1mpBcdFajHEYmZk2Fle0ZstquTkcupj0JviTI3bcJ8cMmE7kx4Hvaw8Yn8Zsu9amxgcLZGjTRmxUt5aEAn3nczxSugc6qKjpCXfk9KNnfPteCjdae6ZCDaxedryCdLDvQXR5YKkqPWBcBMeZw4MAz4BjJrYsR84Gkv5GQKeljXLEuPYccC3usR1j+8D9NTzm9P2hhVO3BKpoyuuf6LEZNk3enwEGNyus0PlVt0cot7NSEWrsNk4qXpnMYWuoHQJQKA/jvNqa2leIoguvibCPBZgK7mOeYlilBMshd4sFsrmHwDIIdhwsx/W7DZ7NSg5YOgZPDzNZdRwKsqEd4UG+rGlcrsr4K6Gpb3ydWWzs1wghcma8hOprVzE6k+5IxtS1lMA80UGZSI9NKjWcnKrufe/st2Lj5/AzDgsbpYqyM8BFGk5d+/ZZTPVsAT4fqP3iE/V1VL1bEVNyZawb2E6tbeouJzIYXJNaVyrbWJRrDzC730zZDTmDWJVkv9+RAgqXV9WhavKp6yfRUVqATU3JVA6Z7J0bCtFvO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] optee: restore_direct_map_dyn_protmem() called when
  reclaim_protmem() fails
--

commit 1a801ca7487b0859c4bfdf62e4f1116b16a1b7fe
Author: Vincent Donnefort <vdonnefort@google.com>

optee: Add support for lendable-dma-pool

This commit uses dma_zap_direct_map() and dma_restore_direct_map() to
unmap dynamically allocated protected memory from the kernel linear map
before lending it to the secure world and restore it upon reclaim.

> diff --git a/drivers/tee/optee/protmem.c b/drivers/tee/optee/protmem.c
> index be3abf6e8aa6d..10e8f1540e5e8 100644
> --- a/drivers/tee/optee/protmem.c
> +++ b/drivers/tee/optee/protmem.c

[ ... ]

> @@ -76,6 +103,8 @@ static int init_dyn_protmem(struct optee_protmem_dyn_p=
ool *rp)
>  	rp->gen_pool =3D NULL;
>  err_reclaim:
>  	rp->optee->ops->reclaim_protmem(rp->optee, rp->protmem);
> +err_restore_direct_map:
> +	restore_direct_map_dyn_protmem(rp);
>  err_put_shm:
>  	tee_shm_put(rp->protmem);
>  err_null_protmem:
> @@ -112,6 +141,7 @@ static void release_dyn_protmem(struct optee_protmem_=
dyn_pool *rp)
>  	rp->gen_pool =3D NULL;
> =20
>  	rp->optee->ops->reclaim_protmem(rp->optee, rp->protmem);
> +	restore_direct_map_dyn_protmem(rp);
>  	rp->protmem->flags &=3D ~TEE_SHM_DYNAMIC;
> =20
>  	WARN(refcount_read(&rp->protmem->refcount) !=3D 1, "Unexpected refcount=
");

[Severity: High]
Can restore_direct_map_dyn_protmem() run while rp->protmem is still lent
to the secure world if reclaim_protmem() fails?

reclaim_protmem() can fail, for example if optee_get_msg_arg() returns
-ENOMEM in optee_smc_reclaim_protmem() or if the secure world has not
relinquished the memory handle in optee_ffa_reclaim_protmem().  Both
init_dyn_protmem() and release_dyn_protmem() ignore that return value and
unconditionally call restore_direct_map_dyn_protmem(rp).

On arm64, arch_dma_restore_direct_map() remaps the pages as cacheable in
the linear map and runs dcache_inval_poc() across the range, which
re-exposes the still-lent pages to CPU speculative reads and triggers a
synchronous external abort or SError on the cache maintenance before
tee_shm_put() returns the pages to the allocator.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111110738.8729=
47-1-vdonnefort@google.com?part=3D8

