Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB39CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 19:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6998E0002; Thu, 11 Sep 2025 15:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7A48E0001; Thu, 11 Sep 2025 15:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD4A8E0002; Thu, 11 Sep 2025 15:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53FD38E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:31:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7459C056C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:31:17 +0000 (UTC)
X-FDA: 83877962994.27.B75FCEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38416A0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:31:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="exip/QW4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757619076; a=rsa-sha256;
	cv=none;
	b=gXXnSjB2nj8dTfb9FVWT1yp+9ooUJ3Nt43QyhTqQNBF7EnZBp0sY4lNiG5+hPR7rx9kjiO
	E07Zc1eGub6ij4iwemK6QiFXysBNVbGKoNFvoONgJCglcRORWMZSyYr7rdFd9T5XSpTJCY
	8vWiXOowoW1FrHRzEhXsmP6wlRLbffk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="exip/QW4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757619076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNAkVmfmmd2STgROqHu2/avwiWpu9bFBUdDAMjZAfnU=;
	b=dYgpN3wdB2MkWxItGxjhB1nmJhKWBCNlOYGK1GOSsm/GZwhJq+UqIqr028hFsh6QxvVATq
	NnqvyOnJQMcUtuqyWcyyBxpF7PSOIHquxU99V1tmWZuwnWPJ4SzUwiwdJ8AYQQARd5UMrq
	91FfFFGnSckXhSj+M2nJ7Y7salVd8/U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 41F1E601DC;
	Thu, 11 Sep 2025 19:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A6DC4CEF0;
	Thu, 11 Sep 2025 19:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757619074;
	bh=Qlsnxx5xoSOGiAxOfSS6gsBgNRLsgue6LjVool+d9vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=exip/QW4v+IgClXJq68192Q8g2BA14FnRL3v6oxVrQVhnFn7FMEV52G1a8EYl9v49
	 PE654ArlxFQn+0nlJBVUp139EeUiOS/ZEI8Ba/H6wgpazoZsGJqgr1yhNa+RyRGztX
	 +ZsA4LN2czoOdGXqNmvaHMbiTH8mvL2CzdMHVWqMy+RLbvijvCdOfP/wfWHVLPl84Z
	 ZHaJj7k5Iiya8QZII8YDnIXGt+XsMQKWmnlEX+4NZb/37R22F6HmFCl74XoCnvi/Kt
	 kj+LZtENT5LZrhO7SxwS7w8ji4b8y8BfwYm2gTmKN4rOLTM/7ZkeTykUO9QyCt16Er
	 vTolONRdHF5xw==
Date: Thu, 11 Sep 2025 12:29:53 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com,
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Message-ID: <20250911192953.GG1376@sol>
References: <20250829164500.324329-1-ebiggers@kernel.org>
 <20250910194921.GA3153735@google.com>
 <CAG_fn=W_7o6ANs94GwoYjyjvY5kSFYHB6DwfE+oXM7TP1eP5dw@mail.gmail.com>
 <20250911175145.GA1376@sol>
 <20250911190302.GF1376@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250911190302.GF1376@sol>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38416A0006
X-Stat-Signature: peqesygam3pi9ruuxbs7eegt5nki3hbg
X-Rspam-User: 
X-HE-Tag: 1757619076-282714
X-HE-Meta: U2FsdGVkX19lHmW3sGj6y7vgruY6+LQQpavDww9zJDcE6EkeH/cCaO401GeARiDpFvujogmiBD7S8og7RRPQoRDgNfO69wK2PsiEdRaMLEdEZP80t9K0SlqJ5m0KPChQklpJgTnX9lIzYMBNV89bHRW0jtXCN/si8TUQuToWf2KleWr3x/xtUq1LlJdti4Kji/L9OBenUxSujlmiB8yji/T6jKErpYkCuZMFO+uzxCOCVy+qxsoTKRdK5COh0+nw/eiM+fy1V+VEM6bmV8ocv1z6AQ1xa4YoyBQmveihjyNFomxy/mT94bwruNd4GUYo+UqD4w4NI5ZWwOjPxFdB71O3VLb6mHX2JQZZtci0PMrsUOOuNWQqflDIiGmZxG+ILDTku5udldPRTUIaKlkY4/gD9Ib4nS0T3jE9RS4vdpkeg/YVyLCHp1J79XnBx6zeOUJSBu/4K2dAbHFidc7M5UXX/44iQKNXZVe/Wi/fH9/zP0Gu9TWZ7xY8/9zPqYj6upDtxVlkhYW60joTt1RpgxL29FfR7g8xivNpZJ2W9EDMd5NnqA41EQfiX32B3cU8bIOlXq2mnHUhTp8tDJTIhCV1aQ1PG1T8TWQWFv3D4RQYIq+f3ss0EIDmV9svIj7O2WQhSIld6AckUBFgqtrvHbCvv4EoAoCXHYo30em/fZ10//a7xtovFiy6OCX/PdUf/IjVhOJ1kZUS2euXWKx8GVeIa9VwQQTX+LPgeIOW3lFtRlmXDvpqhTL3g+aU7EUdrcRdeHoKyeoAX6cTOTcTGVD8TS6MwDM1KkT2ik+DGl0qRlG/2ZQU0xZptN0tiuqPp/+Lu2c2cIht9mtdSdQxGmY8rzxJaR9URShxadgSTiEP37EtgpfSlvAYDK2SOMdFthfTr/aaSqybDZUcMLDgLl4DGoZESrp1v0IovAmz7nXkJvlhOGmX9zNNqpY5je2bbmeNVGobFsgkahWSGdj
 468qIBAC
 VPmPmDNJ2NNGhSPMtVw6FBWxX3EVkvKen2pNb7POak6B4u6+wrPV5646uPycmi7wGACDPH4K/km1TDqhGGw03JOFCCIknwOVutVBvNBwc17DIneIH2r3I01Et811SJMeP3PZfIsX485wvUB8BGZ7VsWnQVa7BU8Y1Xw9yRYEcZkhnl4MxaCbEzoNaNby48iC4AQTLqdxjYHKE7nCO3RS9R61HMjGI/vs8wFVRuNYNf47R8hgJ3F/zm0ppxZMLTx7rvk1oEFV4sEAiH0voJwt9M2OF3rqmx47MlYXfletI6e3LtnQVMUuPiri4YpNHPgWTaVpwCY6KUBSaPm83btS/oJv/NvOLg2g2MSWynZNL0Iv5lCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 12:03:02PM -0700, Eric Biggers wrote:
> On Thu, Sep 11, 2025 at 10:51:45AM -0700, Eric Biggers wrote:
> > On Thu, Sep 11, 2025 at 11:09:17AM +0200, Alexander Potapenko wrote:
> > > On Wed, Sep 10, 2025 at 9:49 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> > > > > Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> > > > > kmsan_internal_set_shadow_origin():
> > > > >
> > > > >     BUG: unable to handle page fault for address: ffffbc3840291000
> > > > >     #PF: supervisor read access in kernel mode
> > > > >     #PF: error_code(0x0000) - not-present page
> > > > >     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
> > > > >     Oops: 0000 [#1] SMP NOPTI
> > > > >     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
> > > > >     Tainted: [N]=TEST
> > > > >     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> > > > >     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
> > > > >     [...]
> > > > >     Call Trace:
> > > > >     <TASK>
> > > > >     __msan_memset+0xee/0x1a0
> > > > >     sha224_final+0x9e/0x350
> > > > >     test_hash_buffer_overruns+0x46f/0x5f0
> > > > >     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
> > > > >     ? __pfx_test_hash_buffer_overruns+0x10/0x10
> > > > >     kunit_try_run_case+0x198/0xa00
> > > >
> > > > Any thoughts on this patch from the KMSAN folks?  I'd love to add
> > > > CONFIG_KMSAN=y to my crypto subsystem testing, but unfortunately the
> > > > kernel crashes due to this bug :-(
> > > >
> > > > - Eric
> > > 
> > > Sorry, I was out in August and missed this email when digging through my inbox.
> > > 
> > > Curiously, I couldn't find any relevant crashes on the KMSAN syzbot
> > > instance, but the issue is legit.
> > > Thank you so much for fixing this!
> > > 
> > > Any chance you can add a test case for it to mm/kmsan/kmsan_test.c?
> > 
> > Unfortunately most of the KMSAN test cases already fail on upstream,
> > which makes it difficult to develop new ones:
> 
> The KMSAN test failures bisect to the following commit:
> 
>     commit f90b474a35744b5d43009e4fab232e74a3024cae
>     Author: Vlastimil Babka <vbabka@suse.cz>
>     Date:   Mon Mar 10 13:40:17 2025 +0100
> 
>         mm: Fix the flipped condition in gfpflags_allow_spinning()
> 
> I'm not sure why.  Apparently something related to lib/stackdepot.c.
> 
> Reverting that commit on top of upstream fixes the KMSAN tests.
> 

Rolling back all the BPF (?) related changes that were made to
lib/stackdepot.c in v6.15 fixes this too.  Looks like there was a
regression where stack traces stopped being saved in some cases.

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index de0b0025af2b9..99e374d35b61d 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -638,12 +638,11 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 	struct list_head *bucket;
 	struct stack_record *found = NULL;
 	depot_stack_handle_t handle = 0;
 	struct page *page = NULL;
 	void *prealloc = NULL;
-	bool allow_spin = gfpflags_allow_spinning(alloc_flags);
-	bool can_alloc = (depot_flags & STACK_DEPOT_FLAG_CAN_ALLOC) && allow_spin;
+	bool can_alloc = depot_flags & STACK_DEPOT_FLAG_CAN_ALLOC;
 	unsigned long flags;
 	u32 hash;
 
 	if (WARN_ON(depot_flags & ~STACK_DEPOT_FLAGS_MASK))
 		return 0;
@@ -678,11 +677,11 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 				   DEPOT_POOL_ORDER);
 		if (page)
 			prealloc = page_address(page);
 	}
 
-	if (in_nmi() || !allow_spin) {
+	if (in_nmi()) {
 		/* We can never allocate in NMI context. */
 		WARN_ON_ONCE(can_alloc);
 		/* Best effort; bail if we fail to take the lock. */
 		if (!raw_spin_trylock_irqsave(&pool_lock, flags))
 			goto exit;
@@ -719,14 +718,11 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 	printk_deferred_exit();
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
 exit:
 	if (prealloc) {
 		/* Stack depot didn't use this memory, free it. */
-		if (!allow_spin)
-			free_pages_nolock(virt_to_page(prealloc), DEPOT_POOL_ORDER);
-		else
-			free_pages((unsigned long)prealloc, DEPOT_POOL_ORDER);
+		free_pages((unsigned long)prealloc, DEPOT_POOL_ORDER);
 	}
 	if (found)
 		handle = found->handle.handle;
 	return handle;
 }

