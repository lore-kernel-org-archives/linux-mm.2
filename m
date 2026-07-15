Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B294EC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B595C6B0099; Wed, 15 Jul 2026 10:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30D26B009D; Wed, 15 Jul 2026 10:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A203D6B00A1; Wed, 15 Jul 2026 10:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 706566B0099
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:14:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E784140123
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:34:42 +0000 (UTC)
X-FDA: 84990652404.27.30D357D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83566C0006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:34:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ari7ydGK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784111680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/u+P2N6zRIR8FUBVRNxWHd1rg794l4gpgYxauKphMTA=;
	b=ZQww2DDqAZJuy5B3WktqLnNmbecUV1W/e+dL5QkPfBABZcoaMhcvz85wWL1GRaLGdXQZnK
	Weq3YS5U6T7rO7zxmToyJEmouIxXT1eCTrEcYZ9oghxtrZDAmhgl7CC/pp8BhOCgLEmdG3
	uyOy8Lnb8uonAFzmXYJMrYO7ABKD17k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ari7ydGK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784111680;
	b=gVfy+Jn3qaenKteFMthB/bbR63Qguv7ndf3ucOqVgZ+kK1utepJcelU5SLs1odX/lRW17a
	fHg25eULiv4D0EGOrVczLMetVC4YLswKo33tBD4S13//LyPI6BVGvY6nVjjxJqpyNyPgDZ
	VAzsGLXI2s8zanzZzDySXBAnsjnLqCY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B604842B7F;
	Wed, 15 Jul 2026 10:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BC41F00A3A;
	Wed, 15 Jul 2026 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784111679;
	bh=/u+P2N6zRIR8FUBVRNxWHd1rg794l4gpgYxauKphMTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ari7ydGKpfnwTgzb36nY7kVdlGE6vrYVN/Ti/SAeTHYi1fxDuCYpPGllrZtl2Y1Yg
	 jfK/Fp4iUqc9sKtVxtnvzkBxVk3aqa6rw+8COlt9lKU+uuvG4d0NboqpKhc5Upwvpl
	 Xy4thbUJY3MHpWDEUJg989mLl2Lt7244u3sPbyPWDkJqvjywzYjYwaIR2iEt4tRuE0
	 9Vmf6B9x/XqE0aIanJtr4fnXJDCdN/ZwxKgmSbqao6ayO87cudr1ytx40vZQt+q7pZ
	 l4zfRngP3OjVyd2ydUlpVcN4FKWy4md6cYl5KNquOqlNsLJdIdF06Rh8ho/yYCSjwV
	 xmir6DvcTpteQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id E790AF40066;
	Wed, 15 Jul 2026 06:34:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 15 Jul 2026 06:34:37 -0400
X-ME-Sender: <xms:PWJXagXvnJIrLEGLn2TcaaNLm5k5GJ8CvbH_2X_DyPi17SHywh8FOQ>
    <xme:PWJXam7Zjsa24wXb_097Eqc4nDWs9VG_U2mHOWe2TBMZxU6SqNHp8T9L-4iqGhjY2
    L3VfekuLMx0tRuKTMlNTGbvCtyzLvWSUvGQZZfd-5qzsI5J_r_2lZI>
X-ME-Received: <xmr:PWJXajKPPuRgSNa8OXZIF2oNs_s7HbLU7HuhIUTJafbIBsmifZodbVEVhP0KxA>
X-ME-Proxy-Cause: dmFkZTF8BlW1JbhLHKAA5CCFXFcYGHtkBS3RzYLv20V59nT+I7FpSJ/Ok8ON8iUs6XHz7u
    +G87ehG5oQ0BL42Uj6L+tKW2gixAEPGzywC8/ROEYb+ORNvX3EuvZfc4z0v6davUQgGBef
    nv/jIaoJLpLf5mwPdwSqDDaztaF20dpNkeWVjyaLioO6Khtwor59qcar6llBTGJ0VX6d2c
    tGKzEbkgZrClapzBkAposaU5h3W0k2guVll2eZTtqt9qaU21+vCnXUQav3DkFMNxeWh9bQ
    h4IL8dIXlwpLvyKEvBdV6VCPSf/irpl/uHVoZNcHQDaubztS+Fhd7BZy1pQgRDVMWGg7sR
    ZDqvbDgPX0jEBV46NyMkqHWWmPL5pjyXSZEXm3SVkv84XhOwrRJngtPmkgeQfnRrX0zbxL
    m+HLvlKHwLRImojhngp+JRlI3tXihZtgQAXc0OVB+Ajo92Ha/bn3x4AacB7U3kysFaCJEo
    vvwpqdRcl6EdjaYO8P2aHisOrxXpA3Ib41YGPgA5jXlWDserU+pes/cLGpgn0eUwz+Htrq
    t3i9BWqYrc0iE+3sVUL/69zQpmtnjVcTk+uwY292UIxT0wMlVh1eF2LjA0tPQVC8DXmbPE
    lfMNuqwlQIZB1re+HJkD/FcF5sWDhPZqa1TekZUorvAwxFBEHAKrvN/7zaCA
X-ME-Proxy: <xmx:PWJXaphQ8cqKFJDXfA-hPYB343__wdvaK33Twj9yuIwO205snQ8KrA>
    <xmx:PWJXatIb0xs4XANPVgpl2zaqWQrLAgvU27hhIaXg4kaSN4G2ZLPagA>
    <xmx:PWJXauGW9z-3YwEfJh7p1mFiZHiq2jHUyLWtCrk4rfkPofg3pYXjkA>
    <xmx:PWJXat12aX1XWeTqpZLHbDzwHd8Blu1u4qvLLzlgv9Hhb7rJJ8QzkQ>
    <xmx:PWJXau2fJ6rHSw7XXpJLCXVLbBHBULFi4tfSDhi-2wPRTAjc7yJTgf7Y>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Jul 2026 06:34:36 -0400 (EDT)
Date: Wed, 15 Jul 2026 11:34:35 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, 	Uladzislau Rezki <urezki@gmail.com>,
 Toshi Kani <toshi.kani@hpe.com>,
 	Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 	Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, 	Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 	"H. Peter Anvin" <hpa@zytor.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, 	David Carlier <devnexen@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 	bpf@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v3 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
Message-ID: <aldhVdwj9oMRN1Lk@thinkstation>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
 <20260714-series-vmap-race-fix-v3-1-b812eccfa0f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714-series-vmap-race-fix-v3-1-b812eccfa0f9@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 83566C0006
X-Stat-Signature: ph7b1qa5czk5mbcow9ax3sce4yrrwu68
X-HE-Tag: 1784111680-211958
X-HE-Meta: U2FsdGVkX1/ti93OClCwcaXD/1vqGpqPlWgoY+Nz9I7OgAL4F8K04I2SLpVDmzgB6qFWFeKSgHK+TzXLj8O+pQeGS1v833NQh25/wiznDSmBr5mTxfOTjlcBM6hfkY+vorGRbZSO0rzdmrhONADj43SzGljtzMcQePPCzWU+2v0vF+G1vIoEM8lnDwqsKv63N2LgbUmf8soM9BHMDypBnJmSrcc9KSzAhu1Jlk+A1VZgsSEiX2H659fNEeWzGednJR/rc79dO90EfC9ZKbkAfiMEONNbq7pTqpm8/Eaz8MySNs5CoeIbrn6IDY0pD8BvZeI4NPqNKcogpJTEUS2D9qFIDMUnxd43k5CJYXyiX3vTJse+6fvo5BN0If9mNnlpgc68Lway7GDmdrmhZiL2LVveEOQD+Ok1QsVvaDsF79UgjbUHaOjz+TJlyA+NsgC11BRGskjlfHOyNZu2vYfr54cTERy8IH55/Nh5/VgyZLwrmgBGMc9qzeUSPiTW+FFhUsjOnGLU8EEpA+uGQvYDw6kD0twSufr/ifHBEKe8X3mriyO+WcPCPOw/BZKQBvXAjUeEMGPj+7Y/5CmFanURv29sHsRznEtF42BWiXK5aOjbbbsaW+owoxRAwqkGWEHKN2lJrC3+y+ck39vSd/aIyKR9G5fzXs36wRz+CKj2d6g+ZYAstcZw/VdlpZ4P9NScFAuny0Le8eXyETy2jkrnTeysopZamY0YuAOQLDDsCyXmwtPogr7Bi3j3/2ZPynBBeiYuBzhs7Q0Iu7ApcPuWCMRS+0DUKnsltIHC/H5aEQ/X7E92YHfMHVSgsG1iPKsji9iRTO4QTdyWPiexl4cpzSkiWYZ5P3bSxV6Au7bFwqunvP3lE7LMTkWoG28tw0Km7ldg9kvn29gG34Gjxdq0OHEp4wnJ9N+5zBRAUFQ6Pr05oHHKhA126ZYNxKDgaSRs/9RjGEichd0Fi3nf9R1
 Fd1suFY7
 ze9cXUXFbfhkNEKwDaLHJIKQL7kyefIut9rYe6mk2incYIMf8UvjF1u1Ia3INaDlzZT/4/p4O/B1lvVi1z95m2Selbh6TclrJ73sWWLwW5FAT6ddqONDVOuWC+Q7r6xlpX5dRoDQx/HXNzix6zkP6eS/PMd52CCLkR/xzzXyxIJYgakbytNjtQbYyrxPrkwGWl1tSXA8m+ES8vIJHe65LH+MXURXx/rGqZasJ7p4ZWtOKLmmZQbEtOGOCGS3ZPlqnZ991ZCEFzjPEtcXRMCQQDvWUMcaU8vXJzFwgpPvk+gwp9IgYGbTdX3nEWIDifV2uCjz72UPmuH5r0FUC83yCN3Q949SL7N5Tfjj+rDVGFAxCFIKcZxGBbAsvB+4XKJL1JpqBwdoI17Xp+V376z+N1lAyofIEsQ5bm1nIUwxsdHLxwI1Byx4akuia/OOhndAfHTb7eptOJNq3Bu9bSB7QpvpVH5DY6wtqdB8H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 06:24:23PM +0100, Lorenzo Stoakes wrote:
> Currently there is a nasty race between ptdump and vmap when attempting to
> map a huge P4D, PMD or PUD entry:

Nit: that's a strange order of levels :P

> Fix this by holding the mmap read lock in vmap_try_huge_*() when freeing
> page tables.

How about adding here something like:

  The read lock is sufficient: ptdump is the only walker that must be
  excluded and it holds the mmap write lock. Other holders of the read
  lock may run concurrently, but each exclusively owns the range it
  operates on and cannot reach the page tables freed here.

> +	/*
> +	 * Kernel page table walkers either walk ranges they own exclusively or
> +	 * hold the mmap write lock on init_mm (ptdump being the motivating
> +	 * case).
> +	 *
> +	 * Therefore, acquire the mmap read lock to prevent use-after-free when
> +	 * freeing page tables.
> +	 */

Same for the comment, maybe:

      /*
       * Acquire the mmap read lock to exclude ptdump, which walks
       * kernel page tables it does not own under the mmap write lock.
       * Concurrent read lock holders are safe: each exclusively owns
       * the range it operates on and cannot reach this page table.
       */

With that:

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

