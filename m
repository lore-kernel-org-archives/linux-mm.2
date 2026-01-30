Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EF6E6BF31
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 18:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60996B0088; Fri, 30 Jan 2026 13:00:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18406B0089; Fri, 30 Jan 2026 13:00:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44026B008A; Fri, 30 Jan 2026 13:00:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 945036B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:00:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40D1458773
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:00:17 +0000 (UTC)
X-FDA: 84389394474.27.07626C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8D205140019
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:00:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gB6I7Wum;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769796015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvuU/Dm0bJvMdq2F2JKHlnsyo9ptJS7yv2+nHf2Cd2E=;
	b=Nr4QydT1zcyly3XJzZmIyN8tZTCD1OZwWOyfb1n3RqyaYKE2WECFlCpNYNx9KqTv4HgmIW
	hFYTpfJI9+9mkw0PAcqQHAj88lnXYLlI+A0065PA8al6g8HTA1C+LM6pa2c5xPIAu7SH6l
	T8tU80T8DB5iEizCxqojKK4/CV+Y2Ss=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gB6I7Wum;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769796015; a=rsa-sha256;
	cv=none;
	b=BwgKJcXoFpKoFs3c16uyLRJihQEDG82WWerGY4klY53dSRiI92ucOsirRgrYPR2utJYV3a
	VzXjZnBOANSVjly39pLn5Zs/YxCnBl3y8h7Mkf2xtidu9Jv90rPBEAErH6jr2d6vZAMUEl
	R6qKZGrE1GBGtzgILAMQ36DBfV0auNE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA34C6001A;
	Fri, 30 Jan 2026 18:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30691C4CEF7;
	Fri, 30 Jan 2026 18:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769796014;
	bh=AFVyapZz7+rnLVcwl8jFcNdohlBEAdutFNruQ1aqrP4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gB6I7WumOiVus7/WSV+qgJ8RC4GHJIMv0c9/bfPssW0cj2v2O8c2Vr1yOFpxpaIfL
	 606t/2u3ouWNJ6bwa1u+fRQUs4MTsPyVqGrH/GnFVGUoyC9tpvjpwO2XIha24hfAd9
	 UozEq6LX5GI/tCl7U2fq5VpTpS4xqDqTcHxIavIk=
Date: Fri, 30 Jan 2026 10:00:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, linux-mm@kvack.org, stable@vger.kernel.org,
 dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-Id: <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
In-Reply-To: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q3t55sfi6hn8dneuqb3twzuagzdhp43k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D205140019
X-HE-Tag: 1769796015-147373
X-HE-Meta: U2FsdGVkX18Dc8OFvJMmifu+Vbib3DIHpyjJmnKR5hss3e0BnLC40U+WWpWSwQd/b8K8TMyMhnOAA9Phejp3HP35eXHoDZ/1YCu0jFPvvW9uh2JuqTHznac0w2hGhoMFXRdkD1DVQaMR0Jh0z8HbUNosQac97OcJjxDIoGozO728zqS8iZ1NyPq5/Uxpuld4AFW8vuryybJ8KqvmwaQi6D+Zwx7DMCrXoBuNkyp+8M/SURVR8CNk/ryYHNH1EjnABAWEDj9LN3huIioONROdlUGfXUo1BVRscOeLa9kej2LF9r5XH64OhpDaFN/DSC4Il0w/O74xBdEPd5KmNIAiiq3v8eG+mRN3db1l4e4zJIA3qLDL74pMGBfhlND+4S5Z1oDDkJ74UnAqnD3ulJcMJRFP5LfGVTwoJbKhtwlW+448jZ16jV6nsvlz9WxNQqc3+NkavHOcq+ZOjq5WVMUV8N0/D5GP3Ec1eQ4QRMHLZWMfE9dn76lM9WmGzy6hPSw9QXE1WP3EFtq8NFT+3UVaU6nN91mHOilZxMAGwqeHp4HuX7rrXUZAfvz1pXPMYRoZebwFQUNyZXHGZajxVzMjew/6g3q2DfjI+a9ZamdhQtlXy84+Jx0G9DE1O3zXBgXvTypYlUqOB4MsJ5CxH3f63cNbp1A8K0ODMOpWy/YCInjOFAfpRFRIqvowR3LIMuYM/VPnZqJm7SSOQHyNFgbQIauiciTwVAFJ6OvBTAOej3VLFgrB7gm+V+XitqpZAAc/SQmM3Rm7Gj6PUccrZNAb5XZ8PO1OP13wSa4RHvNjLY5OhWEeK2uHy+YhN4OfkFuptO2th0p9FcQsWiz0n8jMtxslDZeahpEcSuFRCuvsA7NyFlPGWBfA3Tk3hFx6nPdYTaOtG31ylLA541Sii0aWkP3UDEWhMae3tMJq4OUzTQ9wCk5e4cEB8mOTye+ChtV38AV1tG5M9OXkjFtEjpc
 7YgllRH9
 vwm1DscGzys5uHqLdgD42ICCiOKxcJrx/AP/1QzA53uy0xfYClMHuz/zGxVmGzGxaYN7I0HACXImhn9Y7ti45vkDqpwae1W+PSA3s6xex51v3d5LkEpVEWLs6cEp6Ue7dOOywxRL7CFaVlTCg/xDU7dOWzC1AII+NRjTG/9WdQ4lsxDzCZFrSVaN/ZENRp3HTDdJMUji9PYdue9T0DP8gzL7spEzSiD+wmMyBw4bsaPaeFYMI2ngSaLDeU6as6+nhOxBIEaqqIyNMmSP5ibqAXr44EUUVIbrSwz10bKoje6nMLIkvpulkoSeGGsXtAyW6ct4/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 15:45:29 +0100 Thomas Hellstr=F6m <thomas.hellstrom@lin=
ux.intel.com> wrote:

> If hmm_range_fault() fails a folio_trylock() in do_swap_page,
> trying to acquire the lock of a device-private folio for migration,
> to ram, the function will spin until it succeeds grabbing the lock.
>=20
> However, if the process holding the lock is depending on a work
> item to be completed, which is scheduled on the same CPU as the
> spinning hmm_range_fault(), that work item might be starved and
> we end up in a livelock / starvation situation which is never
> resolved.
>=20
> This can happen, for example if the process holding the
> device-private folio lock is stuck in
>    migrate_device_unmap()->lru_add_drain_all()
> The lru_add_drain_all() function requires a short work-item
> to be run on all online cpus to complete.

This is pretty bad behavior from lru_add_drain_all().

> A prerequisite for this to happen is:
> a) Both zone device and system memory folios are considered in
>    migrate_device_unmap(), so that there is a reason to call
>    lru_add_drain_all() for a system memory folio while a
>    folio lock is held on a zone device folio.
> b) The zone device folio has an initial mapcount > 1 which causes
>    at least one migration PTE entry insertion to be deferred to
>    try_to_migrate(), which can happen after the call to
>    lru_add_drain_all().
> c) No or voluntary only preemption.
>=20
> This all seems pretty unlikely to happen, but indeed is hit by
> the "xe_exec_system_allocator" igt test.
>=20
> Resolve this using a cond_resched() after each iteration in
> hmm_range_fault(). Future code improvements might consider moving
> the lru_add_drain_all() call in migrate_device_unmap() out of the
> folio locked region.
>=20
> Also, hmm_range_fault() can be a very long-running function
> so a cond_resched() at the end of each iteration can be
> motivated even in the absence of an -EBUSY.
>=20
> Fixes: d28c2c9a4877 ("mm/hmm: make full use of walk_page_range()")

Six years ago.

> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -674,6 +674,13 @@ int hmm_range_fault(struct hmm_range *range)
>  			return -EBUSY;
>  		ret =3D walk_page_range(mm, hmm_vma_walk.last, range->end,
>  				      &hmm_walk_ops, &hmm_vma_walk);
> +		/*
> +		 * Conditionally reschedule to let other work items get
> +		 * a chance to unlock device-private pages whose locks
> +		 * we're spinning on.
> +		 */
> +		cond_resched();
> +
>  		/*
>  		 * When -EBUSY is returned the loop restarts with
>  		 * hmm_vma_walk.last set to an address that has not been stored

If the process which is running hmm_range_fault() has
SCHED_FIFO/SHCED_RR then cond_resched() doesn't work.  An explicit
msleep() would be better?

