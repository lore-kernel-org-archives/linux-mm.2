Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FA1C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088C36B0092; Wed, 15 Jul 2026 10:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061046B00A5; Wed, 15 Jul 2026 10:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B2C6B00A7; Wed, 15 Jul 2026 10:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C037D6B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:16:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D8181601CA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:32 +0000 (UTC)
X-FDA: 84991211424.27.EEEF0CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 841FF1A0004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRTh16mR;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784124990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+bwpuTRptvyCO3bOxQYXi/J+49Jig0wU9FV1VYgk1U=;
	b=dWAMrBwY3QPwaSqsRQs9WD45bioaf+uz3O3dDz0HPuGkgul9diEnb+6fhVxuuCF64lI4pg
	UD+9yIMZuQWj905e6Azu37hdORBkdCrNbTYzk+fWXz8Lhg91PbaYCf48BZZvr2kTsKvXh5
	oSwHzbBfLeHQpIllf68BrTxTZ1t+xbA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRTh16mR;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784124990;
	b=Fc3ArVv7nGMUBJu/zCYkFn1+VaDRuumuxLGbq+gWqVu9TbAqnu+/rKC7oQ+rcKihawn3J8
	tgUQwklSyASpILCU0z9mQKmx0nx9JNWiaFJVV2HYUUgM9L9kkcQHNS8/9kOs2czEatrCHU
	7c26NlqkuQJiWvuJ4AKdwdKPVX1Vzro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B002D42A18;
	Wed, 15 Jul 2026 14:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179E91F000E9;
	Wed, 15 Jul 2026 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784124989;
	bh=t+bwpuTRptvyCO3bOxQYXi/J+49Jig0wU9FV1VYgk1U=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=LRTh16mRsy/c1BfJrXztagTLiF6iwreCzUL+HMeDfNjLTGE+v0MTqoHM8/94eqABY
	 N+4rtgZL0EhbYK5cAWGP8gj1ZAFr8ysQnUg3LJ1PmoX2SySSt09D3L2ijTv/4nXxuR
	 4LDqQrY4WGX8Sm/idsfK4IcTNLzYVepREK/kdWMk38B1xyBvHKg+MdYQDRQF14bs45
	 jul3NIZI0mB8QJhljbpCxZSix9msf8uYy+MmNt65ImY7LaGLv/N9lIzfEszPHiiEtr
	 Acq2DWAV0AppoRiInvJeAEKS8BHpzof/0gBMpYFlWjlydAXfZwQxHBKZTGLZ8EgTm/
	 CUv8LK3VaELxw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH mm-hotfixes v3 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
In-Reply-To: <aldhVdwj9oMRN1Lk@thinkstation>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
 <20260714-series-vmap-race-fix-v3-1-b812eccfa0f9@kernel.org>
 <aldhVdwj9oMRN1Lk@thinkstation>
Date: Wed, 15 Jul 2026 15:16:08 +0100
Message-Id: <178412496800.59347.11482869717348078349.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1974; i=ljs@kernel.org;
 h=from:subject:message-id; bh=pGwB/bTHOs2/inH07hoVPtuuEgBzmNSQea1pphRCakw=;
 b=kA0DAAoWz53NioHifxQByyZiAGpXlimhljcAvWKWFrIOS3sEzEn8GxUJs2S9+ijUshZ0yWDKX
 oh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmpXlikACgkQz53NioHifxSp3QD/TBV5
 Z46e/1R1KuwDd9I5f4zeXSY2PL7Lfd/HyDWWJhEA/2/77m0B36Vzye1+PL6ojrs5HOdPpWBBkzu
 ZANDfPtQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: dnm69o83kjpiqbgy4ift4uw7o79fnrkp
X-Rspamd-Queue-Id: 841FF1A0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784124990-55993
X-HE-Meta: U2FsdGVkX1/+3VywJwTRnyC6fJ3ushN5eAXTT/eqg647XT1bmd3o8NLwuByCTvB6DgetqdNFaE589Dyx1BITfhhrW0vxZs3oTIMEHn5Gsfg5m88O1SbXfBtk+FTc1w0hpk8Ro5X3zy4AKgkdySHjud/DOtxEcuoFLK7/lvU2Ecz3LEVxWJHmQ9/L00JJX4Zur/9HE5T3DSv4WiER0xzj0tH0TARgjxTeiI+P7FFNQeGff6NykGmo55/Jqq3J0NlpIHwJZfnicASESlEdhk47S5wJazN53so50tE5Xu8xJnWSmMgTMdg+Fl+ZetVp/g7b6ZQFybBA2KbDQwRIZe+YjY3TuMMv2GupuJKUwf7p/1wq/Xw7o58H+wzkDwjt+RMpZRLnyBCFnr+sRxMcM5m5lPMfb/uUlAcvLKukFwxxBzVQH1nBwDsUBCNRIBVwNd8IKO2hxiY7nGwq9F1VFLHcoyraL60qGH4sFa359bzxsekveELd2f+SGOCzILMaM0bspYLljTMafWBzZz6O+voJi8n3pBDozLWnq4aFTGqMre8nnG6QgMmmOgQYcNG9LK6Zr0o60ZdzMLDJooaKTzUJUAEU9dL4avXy4xnamiQFOytshniClyRVoa1clAixc5gu5yjsgP2mwuUPZ4BjWhh39jZ0DbD4ndogoetzU+ScfjfwDykYlb4D7Pc6MCBPRgJaq2QFggFTxmqW0MZxpDATK6PgKW/Nx+L5cboVcIb4+2IqwapdMQVKaSGU6G5HZDqZNzUHMXKcFxWT11TBI1nLd0u606RlxDLEGih4ge7Lkdzq3yO3bSa6Z/LytYlIhYUSQQyIqV04NxsGuTgbpAB8JNiJGmG+SkIU6KsfqJJ69HlHeX9rt047cgN0TTuaAw5pPGTOz811GY+MRwwvQX6TxTTa0/iBLFyjccW7JWE7ks9sYcPaCsz+KP+01RICAH6UZbC3IhmIu4v3ZNWCrxY
 14nDfH/6
 Sd/9cglGQTM0ZYUhVn5l/PhKbPoBIs33zoUhL3nYjRlowlp9O7Ak5GfjXTTSkEHuiwumjb6YIp7U95apf0JoEziEW+xbK88+/F5xIGNV9FO4VWoEKVcSAFZQaf0O4eURmjgI4FwL+JjIGC9Bq0OMHRKLFWelT6bXcNI+eMhBoZJyLaPVW3YApIbo6UXTg15JKIOWYugE5BktAJ34Rutzf2g/Ne2EM5KWpJwkgr1B66620V+jnx1BZ/wEfd6ueWOkkd9Tmabi8B3kmI5c+RqBGLGoQGObEyu/uL7fuVRBtKzbcYDJl6uRAUw91stiQhRklUcRv46hHylD750TXHWNRicb2TnKngKolbWsAjcmL9yAXXj50CS1UYJ6Ma+TLiky/wxcQKzUxjtkHUPZk4zaJfwiL+ROyOhBCmTA3xz2ifRq7iRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-15 11:34 +0100, Kiryl Shutsemau wrote:
> On Tue, Jul 14, 2026 at 06:24:23PM +0100, Lorenzo Stoakes wrote:
> > Currently there is a nasty race between ptdump and vmap when attempting to
> > map a huge P4D, PMD or PUD entry:
>
> Nit: that's a strange order of levels :P

Ha, seems I couldn't decide on ordering so went with something random :P

Let's try 'P4D, PUD or PMD' instead :))

>
> > Fix this by holding the mmap read lock in vmap_try_huge_*() when freeing
> > page tables.
>
> How about adding here something like:
>
>   The read lock is sufficient: ptdump is the only walker that must be
>   excluded and it holds the mmap write lock. Other holders of the read
>   lock may run concurrently, but each exclusively owns the range it
>   operates on and cannot reach the page tables freed here.

You mean maybe I put the commit message on _too_ much of a diet? :)

Yeah sure, sounds good.

>
> > +	/*
> > +	 * Kernel page table walkers either walk ranges they own exclusively or
> > +	 * hold the mmap write lock on init_mm (ptdump being the motivating
> > +	 * case).
> > +	 *
> > +	 * Therefore, acquire the mmap read lock to prevent use-after-free when
> > +	 * freeing page tables.
> > +	 */
>
> Same for the comment, maybe:
>
>       /*
>        * Acquire the mmap read lock to exclude ptdump, which walks
>        * kernel page tables it does not own under the mmap write lock.
+	 *
>        * Concurrent read lock holders are safe: each exclusively owns
>        * the range it operates on and cannot reach this page table.
>        */

Yeah that's better agreed.

Let's replace it, but I think (being super nitty) with an extra blank line as
above.

>
> With that:
>
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

Thanks!

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov
>

Andrew - could you fix the commit message and the comment as above? Can respin
if needed.

Thanks, Lorenzo


