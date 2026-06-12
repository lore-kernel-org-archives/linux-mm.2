Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03FACD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AA26B008C; Fri, 12 Jun 2026 11:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBCE6B0092; Fri, 12 Jun 2026 11:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9FF6B0093; Fri, 12 Jun 2026 11:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8336B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:41:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D32C2140189
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:41:18 +0000 (UTC)
X-FDA: 84871674636.29.7DE9D22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1871A4000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:41:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ed2AGfRb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781278877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ja63WZ46rzJ67VfjbHNx4bPZEFzgcU5OVzx2QaMxKAo=;
	b=g7+x+Y7TbAvxTLWXrYe5pCJH6M0EPt13HvCAKqSBmWlYYKHWNwTiE82Ma9hWoHFmJkYf6z
	r26JKKAW/6H49okxdp+I4N7t7hTBX+6JWkBIHuTqqlQ5TdsOuK461nW6CxjY48RN0x4/DK
	sxnVMyRKd6JwbuHEQYi86CC/NA8A+KI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ed2AGfRb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781278877;
	b=mti6VERS86FVbLDDHRY7gVnGKpxEZMzoAP6OwKgSCw6r+xb+th3lL3/MTo28nweoTFFZsu
	ILQ43P3FjAKcf9GdPl5HQZkwsPxQ9ANaMiyd1bv6/3yIOWHoW5lyZab0g5dQ/Ewd1/REDt
	GM+ZY9MAm4DDpMxfztyoRS1siGUg0Dc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69C6C6008A;
	Fri, 12 Jun 2026 15:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9A11F000E9;
	Fri, 12 Jun 2026 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781278876;
	bh=Ja63WZ46rzJ67VfjbHNx4bPZEFzgcU5OVzx2QaMxKAo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ed2AGfRby4X4kInzQ78MD/8c54OnWZDqulxwLeAlsEFvtUwq5htPe+d9+nanp71eg
	 AUfM+2++iuzjs4iHMi3lcfg1c4ZEteQOUUC33m6X28zClZLokLo0TX5lZHhQuqtWqH
	 BYG6wF6YBxJorQtLg49geldHGxJ079q5MW9kY+szGITSxWstZfWhjK16IpSPhsNitL
	 6zfoYgsgOYHh7ytOkXv72GFdVcskiwzubsfqSTaIJkdZBBSu/gxaIzbg77nc+lsPPQ
	 JC6jiTCwQNB0k5j2ccHfXboYBs2lx250MwE5A98//hlLJmkMou7z8/iPl6WZxb15EA
	 tZGVgC0U20dnw==
Message-ID: <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org>
Date: Fri, 12 Jun 2026 17:41:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, Alice Ryhl <aliceryhl@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com>
 <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8645ihpx6iz5q8ho5sri9k9m4jtemx6n
X-Rspamd-Queue-Id: 1871A4000F
X-HE-Tag: 1781278876-826928
X-HE-Meta: U2FsdGVkX18bX4EOP9h+sAeB8qnJybP8Jw6oY6bzLEQF/aGgFl92xqdIM/E/D6vq5Rvfmxa7AiRZ8FgjxHUEjRtTB2ndTkTsWJpwtubk9CWXC46P/2IuBXucrzZtMf4DHz5D6zLWaJPhXMJENTh5SG4A3JY0DLrEosDL/QQAnsePcKnHa/EQApTxAIazTT1xhIlOGCLhZu1Y/8MIFJ7nXrx/cHTlEnyeZlkQvj2MqyvqhpuUOxiqJiL1G7Z1PMOAfdlDLOrc2zjX+XiOgZ2HK0eYqRa/IWt//KE7bAr/d2nR1qIeGwyvwxycy3XA0Kykdq3AUcyd0vNwsr5XbVmfqmUjzeUHqjRXiFQ0ShSCdP6MoXpt4Mnl2koQzwsgKLpOHCcgqvmM5ErDoKGq9aSnsn5QNMETaQwoDsc6jIxa4p8kCKwgTaF1Ev5BBdIY7/kkXB01pOHHVJSVqz5wXFPfXp1sIbxsteOo/tdV5Esyc2+yy47oqNmburTPb/tZ+0NnKZpiCFfrgBBI5HrOWLG5Pe2etAliKraI1AyT2YyILa8t1KjUIuuEG0NjkpD2DexJlVaBUUSr8b6KqoSBdZ4nkYzgdrUI0NlPq0mxSlNTMKBB3w8T20lf0Df8j79t8NIyCACwVHInAYEuUwDiMfA1Cj+RGWbeqXUr+JgWlecx4IBRqJVtkKt23hI0NqAJ+R4YKzNxmAc7RqQsLaH9DIw4TCp5Wq+ON2eFrx9J7KhU4JQIfJoG/nPo7t0WuYGvp06rsB6HdG1GAWW7CtOHOkVoLOLjFlqjMub3cw/VlOBUp4kOWLOa65VOdqUGk3+jPUUsuIYEhvXe6E/zyyD1d5kgyOJcH0H9l2/GJw00DdHMbL7s6ZD9E12goxIXAnQUUqILzvSpCqANksAL4hS5DWUJvGveIYnIJ/QPkTOet5dA9oSq4vKZ8xt/eeSLhRqF1j6qzGYe3mR65FqE7VL1gro
 2LA1T6MZ
 AEtywWXVIUboBCo4Eh+8+WgwuFHcU1k1ieHCLuOlzFvIE93mBW+Qly/5i5K6ePLuzUno2Nbh0xhfZBZbX1/nWWL5shhEA+ytOrL/0wpFyf3hYa3a0IG9l48mocG0g65Qak+KC14BryFDG0eptKZHYngkKxKTNnJrY6rzs2fb6P2bVoSmX0ILBGzh5LtODKNoenk+cx6RKMrMlnou9lsumdVtvPcgCh6OlkjvIb12SctchDMMu1wcZIbecPYjK+qTaM/25tpRcxAev9uhFfT7mFb4y/+xwfjr22UHGLDFZABAe5XxmP+XAI4OV7bqAd2pqAihiy+4O3KfITqi05Yeql7z+Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 21:59, Suren Baghdasaryan wrote:
> On Thu, Jun 11, 2026 at 12:53 AM Alice Ryhl <aliceryhl@google.com> wrote:
>>
>> >  b/drivers/android/binder_alloc.c |   26 +++++++++-----------------
>> >  1 file changed, 9 insertions(+), 17 deletions(-)
>> >
>> > diff -puN drivers/android/binder_alloc.c~binder-try-vma-lock drivers/android/binder_alloc.c
>> > --- a/drivers/android/binder_alloc.c~binder-try-vma-lock      2026-06-10 15:57:55.274412018 -0700
>> > +++ b/drivers/android/binder_alloc.c  2026-06-10 15:57:55.277412124 -0700
>> > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
>> >       struct vm_area_struct *vma;
>> >       struct page *page_to_free;
>> >       unsigned long page_addr;
>> > -     int mm_locked = 0;
>> >       size_t index;
>> >
>> >       if (!mmget_not_zero(mm))
>> > @@ -1151,15 +1150,12 @@ enum lru_status binder_alloc_free_page(s
>> >       index = mdata->page_index;
>> >       page_addr = alloc->vm_start + index * PAGE_SIZE;
>> >
>> > -     /* attempt per-vma lock first */
>> > +     /*
>> > +      * Attempt per-vma lock. This is essentially a
>> > +      * "trylock". It can fail even if the VMA exists
>> > +      * for 'page_addr'.
>> > +      */
>> >       vma = lock_vma_under_rcu(mm, page_addr);
>> > -     if (!vma) {
>> > -             /* fall back to mmap_lock */
>> > -             if (!mmap_read_trylock(mm))
>> > -                     goto err_mmap_read_lock_failed;
>> > -             mm_locked = 1;
>> > -             vma = vma_lookup(mm, page_addr);
>> > -     }
>> >
>> >       if (!mutex_trylock(&alloc->mutex))
>> >               goto err_get_alloc_mutex_failed;
>> > @@ -1188,13 +1184,11 @@ enum lru_status binder_alloc_free_page(s
>> >               zap_vma_range(vma, page_addr, PAGE_SIZE);
>> >
>> >               trace_binder_unmap_user_end(alloc, index);
>> > +
>> > +             vma_end_read(vma);
>> >       }
>> >
>> >       mutex_unlock(&alloc->mutex);
>> > -     if (mm_locked)
>> > -             mmap_read_unlock(mm);
>> > -     else
>> > -             vma_end_read(vma);
>> >       mmput_async(mm);
>> >       binder_free_page(page_to_free);
>> >
>> > @@ -1203,11 +1197,9 @@ enum lru_status binder_alloc_free_page(s
>> >  err_invalid_vma:
>> >       mutex_unlock(&alloc->mutex);
>> >  err_get_alloc_mutex_failed:
>> > -     if (mm_locked)
>> > -             mmap_read_unlock(mm);
>> > -     else
>> > +     if (vma)
>> >               vma_end_read(vma);
>> > -err_mmap_read_lock_failed:
>> > +err_vma_lock_failed:

This label is unused btw, which is related to Alice's point.

>> >       mmput_async(mm);
>>
>> If the vma lookup fails because the mmap write lock is held, but the vma
>> actually exists (has not been unmapped), then this code might "successfully"
>> remove the page without invoking zap_vma_range(). This means that the
>> page does not actually get freed and will just hang around forever until
>> the process owning the vma exits or Binder needs this page and maps a
>> new page on top of the page.
> 
> Yeah, I think if lock_vma_under_rcu() returns NULL you just need to
> jump to err_mmap_read_lock_failed, like we currently do if
> mmap_read_trylock() fails.

I don't think that will be enough as well, as the current code AFAICS does
something meaninfgul when mmap_read_trylock() suceeds but vma_lookup returns
NULL because there's no vma at that address. Now we would just assume the
trylock failed even if the reason was that vma lookup found nothing for the
address. The problem is that lock_vma_under_rcu() can't distinguish those
two outcomes, so we would need something that does?

