Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76CBC88E67
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF86D6B0093; Mon, 14 Sep 2026 03:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0876B0095; Mon, 14 Sep 2026 03:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8806B0096; Mon, 14 Sep 2026 03:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6786B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:48:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008ECA6899
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:28 +0000 (UTC)
X-FDA: 85211590296.03.B26AFB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 64EE580004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nLdtUM3z;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789372107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KClFb1VkJGLkCtI9WH4c0jXlSTsGRG9fGPGrsgOGFto=;
	b=LmSN63dO4MvDTWWTDBJwav9kV8jt6EWidMMVnwsj84KLtEq2gChJCLfD2G78KWqj2U4/ha
	FtpvF0iLXCPEAiAThRXAUSQluRxg9kPNo2bv5o64WBQ9S3jvAtUxYuxoT0//mUNtReGRPN
	PK6KGIrerEwTavZYvaLybh+PZ0qF1Us=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nLdtUM3z;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789372107;
	b=jvUMin6e2qShvLDhT4Q8D2KtPSlW+8jP1CUxK5Of/hUeAvCoJRt4SX0Me49MAnmiLbDIo3
	/SicknAwj72njYMM3bTx/MuSQzSZEqwaxqflLNbtqsmUob34xIh5d0V8AIfDktSW87ly7r
	HuMK51S57TyceD31MKF+MCH/pi12/Rg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51B1B435E3;
	Mon, 14 Sep 2026 07:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9971F000FF;
	Mon, 14 Sep 2026 07:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789372106;
	bh=KClFb1VkJGLkCtI9WH4c0jXlSTsGRG9fGPGrsgOGFto=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=nLdtUM3zSn5yjHCXAQDEJt8zxWnibA6ikmvc29vVbrh8Ln3dybfNcrz11rsuUPiEH
	 5KCUQOuV4EQE90HKBkr0a/v+1VvUJVsxbcvjzjVApP+WrhsacfI9YY0VRuBkLu+Kkd
	 YgXkpu7rtKeyGbBpMQNP3XsuLaw0F4vuiQDXNJ3EwNQGpZveLv6/xNAJ/IOU19I/sb
	 2qFdKNiExZ6B71Cb1V/gYrS7EqO5zgaBEJVicA5k/tU5oGlQwEcpu0XBDijLiv9kai
	 mSqrIdhSOo41skGmUtaFAPfB32scbc46USqILXRyS8XI2lgF+Rpg/5cvUro+uG/+rf
	 0ps/oyP1ttzlw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 02/11] mm/sparse-vmemmap: factor out shared vmemmap
 tail page allocation
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260911050228.58884-3-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
 <20260911050228.58884-3-songmuchun@bytedance.com>
Date: Mon, 14 Sep 2026 10:48:14 +0300
Message-Id: <178937209456.4188640.108482640666201896.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 64EE580004
X-Stat-Signature: jrms6mkdgsan5pcsdy6o1d1a7n36f3gp
X-Rspam-User: 
X-HE-Tag: 1789372107-422976
X-HE-Meta: U2FsdGVkX19ctPD57VFASk/Iw/nclDiqZEo3/xqEkWqLWGt191GC9mEFr4jLF53LRhcpaXYhw7/dSKk2i5+zjZED24Hb3Pm3wfQZHotSbfHeGaBiBkJDGkJ+ATZtsbLlxfhBMKNUMnZjTi1LGDs0I0jsLCVGmnjbPBh/F3/J/7r7Kh3NP5pcjqAQkHyI0pQq79I56yaAi+PQQTi8C7hLwIfIuk9TyfWu5ZYQUYFZ0XDK/AGw9U5i32Kicm1DBjP5AOcvcu7gWpMSjOBEvyYBDevW1fZwIsT6gP6K1X5hrBfUwsucNiTTW7zCqQmeN2ZwbZKnNA9spM3aXdZCiwMTO4kBij1URKjD0Xbmhyl2Alw/IlOWPfYiZLKKe2b/NyGwKXosmyj/fRXerWIXrQF1ukFfg0ESpd59icOlvHcc2e80fLbYnbAkoz0lVUQ51LCKzULbLyV2zyvUVxzKB9TNYm8EB65zB0kXO9X/p6WO+c3P+/Y3dh6HS34CUwx/JIxEoauI7oIyGqSgFHBZ6WPyeX//Rzwk1irpMobGSdIHFUSlfLdGxhFNAnH/BeH6Vn2Bdjd//uPWVujHHAheRk75VDRjbuqReooysms+ScN8UZ04MLnfcqN5o8wh4B75LvePq/UAvSQXSnOTPDhi1pLYxuDNqnTncLwOxcpvN2lgM9bS2oHKAWSAJYQmvv4OZYjPnO/cFJTde/j9Psj6/p7h7esJdUnyeguyfBbsnH3ICbZdrNsStjOoiM+AjXNUCgcHGSfieqxrcBUmr2XUxZMfuEa4UcM8vA0ZNnnahQ6z/7Z/unIIhMAmPEM86AxOw2tABV5GI4Xgk/SppsqS8z4QiW1BLGwPad07PyfjKVjAy8i95KV6DLUsOaO8bHRvZlfP9GTJvg4gjOKsLwDIsnsS23482z0GcM7X0lJYmF20UH84MEdSlUE25w1boIkcYxRZlYlEADYs298B9e1UQfX
 nh9FmLJz
 EoVmCyeEyVqsLTNFHTxM6qWfvav/VXdqxQeRBPZUHJ8Fm/7OPLB8F2szfqjc3D0g8+BJ6yJDJUH9fcIc7Vn2lIifYaUH3E1GlVFtWh53GnRugUJZm9JhBna6XL6prXYPqlggeUIK1JZNn55vq6oasIQf2waasfneRcBWKFFbGpU4kK1cs1oNLBB1orx2ZQKivTtJ7gxWf7z7gnWbYUVLjGek7uN+2imLsD6oSAtGVeDlp82ANGxpoW3z8ySLFLced0zlZRY6Pvq5peWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 13:02:19 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> HugeTLB and sparse-vmemmap each have their own helper to allocate the
> shared vmemmap tail page used by vmemmap optimization.
> 
> Factor that logic into a common vmemmap_shared_tail_page() helper. It
> allocates the page through vmemmap_alloc_block(), and uses cmpxchg()
> to install the per-zone shared page.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


