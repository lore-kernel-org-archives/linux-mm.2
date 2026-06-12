Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB80CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE846B0005; Fri, 12 Jun 2026 12:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F8F6B0088; Fri, 12 Jun 2026 12:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E336B008C; Fri, 12 Jun 2026 12:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25A4C6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:01:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA650163B99
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:01:52 +0000 (UTC)
X-FDA: 84871726464.21.2C1BB6C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id B3BEE10001A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:01:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uX3C2R4G;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781280110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a50kyoLhVQeW3U2Ze+HGxZgYK7Tu12TilefkepaSEmg=;
	b=6e7MqFSdkpjLjtlMO7sUElU8GNkpB7/AIitepbvQ8F97lUoTuJyWVkqZzBVjgWfboUIr5v
	RzHgoGUMazf/PQk5IWxlGYK532ZRkAGOqUZ27YUMC/f7GUg1+y9WBgbGGeLtq8dFkQmi56
	jM1bcuCXl/jLyxElxtDj2v1JwnSRd/U=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uX3C2R4G;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781280110;
	b=q6HHnawMKut3rFO3qCI1NJlAw4IBeRGQ+Fo00gFsnfd7xevXfnMfIfmGpUoRs9uh+x2Emo
	quigVwA78oNanSOOH1PZQWmH7jidnZaw1KFoujYf5AXDftG8hjPph2Xhg7SKfDnl8R1t4H
	WtyRc4QyelXIulZJzF8SRUBjtjnIifc=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5177d1ff061so531331cf.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:01:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781280110; cv=none;
        d=google.com; s=arc-20240605;
        b=dSxnbiZBTA/LoJCM7MTm+97mxPsaP5W600Nlv8kyprB836TXuutlWD9uJvOGrZwDJ8
         GHsbt6vPCFq4RtXL2G43V/7AGN9cJk3itYDwvQD/JzIgViPJpALRgLd1Skr8INLra8HM
         hmpDVxoP/DO6wgq8APn5e0LqrDggHs6VS7fhgV7ni+HE4mGh754laWT0NV1EN3A7eklN
         dr01+H/9G28ucOuknA5xk3PAPD/4M3n9ffDMiVBzAE23uG7B+P+W7+oXHeQJdoEp7ij8
         mNwiBkG3xGS3ZVVNwRgr08VRo/Zao8/csjwex5f+QcYZnGeh9bvPdOq4KXs+qvpZzf5R
         BOXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a50kyoLhVQeW3U2Ze+HGxZgYK7Tu12TilefkepaSEmg=;
        fh=vh67tS0jUVfkcLh6rKa4P+os1oYaYfvwI0lm6dDZC3U=;
        b=ha5aSWkQsiFhlfjVXVA/hSqXoNriSWPE9bRYu9zmzRaHJYkIewO052CuUG2lRPW8zp
         BmEegER6Ktf41gvYonul0Iclyoj4s0vmdRfSlH8/fPTkqnL49tW8+fTWjA9oABs+TqBp
         LbuS1LYtMZeYZSJMz1LlEgtOLMJhZ3hlY0iQayYyktsuj+PzIRcjXpCpeBnJkSopYT2U
         MK2vWXLpl8zxosN8k2Xd56+FdpzUvNPHvDxNE8Bl3KJ0H3oUs7/UOTpfq0FmcFi5+GuJ
         VdO0RFtrVVBxWHXSmO2zePPYt14kQTnYctoXNQT+NcLPsB/ym3d9xoYGhC/oiTRNNt2P
         e9lg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781280110; x=1781884910; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a50kyoLhVQeW3U2Ze+HGxZgYK7Tu12TilefkepaSEmg=;
        b=uX3C2R4G7HaqUSYbfjxjLRyYfzwpfSa0JNROGFuKogwE7XrGaXk867GEspsgv/mZ9h
         sihqGUvzn/vtl0gVj98QnDtqvUIrx83pCz10Txfi5/gP73ZxbS7n6KIjSkXKT9KYM2EW
         CJXR6Lniqpniw/SSDARqpO98rS+8gyZAh88hcGhFUfipx0scyDoGnqhbFg88c4VGfx2W
         HzdIHdWYrhqVUaNI6b93B3HuMXY5RFRlrQSasxG0yr0srgMC2XQN7yFxBSq6YHbR/IVk
         4qHSpaYcxj0IO4+f7uTUy7ajxr8+1AwA683oSEOvBwhbb+Q72Rk8fTcqvTUUa5Ktyzem
         L54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781280110; x=1781884910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a50kyoLhVQeW3U2Ze+HGxZgYK7Tu12TilefkepaSEmg=;
        b=lq+6g2bC/S4ogR09udVHTSkTiitNKfZUMMD0RadYlk/QinpodFjNSZSvoHX4U21hXw
         7b5axaqpkwM+wca94AaqrgxmlrrxHcYKA/wK/nwwvvWsVUKOw0+0/JximkDNKq80JWLA
         CzfJb8CDWhtV2cl8Xqdqcb9+vC2QXldQR4bgTYjG3iI97/0spEXG+KEN0vwHBKLUs0Xy
         dJBy4k/mIA3bEAhdPaUdTyIW4SW2xT4EWjvzSlbx9bmdhT/SvRpDwPpb0GYC5MvUcHs3
         tVU8n+N1j8MXTmATLZaEIwusDfeUvNYBdHs1qh9Z7FJ6VgvIBCgY/o9XJ5inx+gw3ePF
         nflQ==
X-Forwarded-Encrypted: i=1; AFNElJ86czaLBkoUiVIXaWufm/5lGALXWSTf/0h37t2qsqJfGEH/sYeIVmE8fk67NS4w7tbluA20g0v0Vg==@kvack.org
X-Gm-Message-State: AOJu0YxUBKCk/qRE6R+Q2q1dJTw+lBLa/kcpCeFig7LieRkeXClPMndb
	F1yCtE1yl37J+yzK/bXeTQbBaREOzniu0oRUvNyjpjqMhlifF8O7dc3R3NUExk3v0/PPKYvM4DV
	CVDj4BVeRU8YK/O2yQP0zAwTKoMD8X2zNOsE7a1Gt
X-Gm-Gg: Acq92OH/W+gI9qo45e5tPRdzmykMWbNOx1p3oQBcxX4Y7qO/QyV1nQf1NrA3F6dKefd
	hrGoV7EdnhuIhM1zgCkPtmCyyQG56nGoR76HUhMfWZ8ehEaTLDH7ndceO1nAs/JZLs+TVmN5sg6
	4WDCdiFBfVs0BFhJCK4/AbLvujopsDzgbI2TCd4itVIX3nKMUyKfGGnyKDeSnHZ9aZKTnpZkC0g
	dLB+KFxYPrI0WwGRAr9fBH59QQkkA+j+XXsTFj/jB88Gq1NWuME9ZXZUZHHgp5FKkwaKAGlE5nk
	9r0UmQPcL6zGfozj
X-Received: by 2002:a05:622a:a11:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-517fc520f0bmr7637231cf.5.1781280108465; Fri, 12 Jun 2026
 09:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com> <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com> <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org>
In-Reply-To: <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Jun 2026 09:01:36 -0700
X-Gm-Features: AVVi8CctRaDJfF5OxV4HwolIWbvnZfBdGqLW9dLOQNg_q1FSz8KvD_IKdVV3A1Q
Message-ID: <CAJuCfpEMF6QMGd=H1+Z_tFzJ8SSvUXZL62r1iijZoEseoAr9_Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B3BEE10001A
X-Rspam-User: 
X-Stat-Signature: 5xb6geojg4wkh74okw11q7w9ppx7kqah
X-Rspamd-Server: rspam09
X-HE-Tag: 1781280110-164580
X-HE-Meta: U2FsdGVkX1/janueBLp7LUKyoUpxvL/TZ7ezUJLg0gHzshAy0H4X38mXCgW/8bTUUhEJKYknYXHqxcH0E64xvo52VIDFLYqW5SEwRpFr9qXTdh4V0swMFrERjAeZXQ8ZMZ9fjVLPRssJdpbVApUpTTlSRKfilbsvaq9bPeyPxnSRbjqMro3BVVMbir0oJnvwpRutJCVW79oDtN6t8xeMjUyc5zyyebbpVIi1MUnmW/3sqDJzv3VghYDAgXMtVmmameqLpzG1saR3qWceKK3FlySUBBw2cVxpuX7WZCPX6nZvXUfBOwnkVzCcYle6dTEDr4FR6ooPG0OeDiqtO4yRkzJn4UEEj8ag09tWIQK1JRIqrJNqTu31/+FAIRZ5dlVyArreM6GHe+vP8TbWb7PjuiBKBKb1VDG4MmHu/AxNDw3EqCO+HXcIzvyoL9Wabyn+4R6JXIcZIO/q7POxtRvI1wlR4SrIleKrVK0Z4kZx7qz7S/dMWS/HshEHVosL42TnjFYEtnJSFC3ymCNaOIlVzTYf7gEW3lKGNrriWghb1dB4JANpTCCP1agqeRku+xRT+ubCNDWF1QJFCDcBnu5wWzpjSW847yFoLWUZWBHPV6Xj9s/WfvD0u4u0U4eZxAqdrAKkbQQs5eaMZx6a15aQCpFaa+V+o9LadtGl+fCd17VQXc8ehodVX72mdMnzjyaxNsAQMmB6NKTH0T/LJdMzfCzpy90hbi2LdIldSsggeS1TjU5iAgmOXHJARL33kiYZtbDWNhgyDS6sEgnk3ZNDpXcpuDkFb/7NHOhc9H1y9fMv2eSPht5HntMraqxrLXLOzV5a+adSWokc0E/Il3xu0jfeQkHaatDK5CuyuXW2qhSPwNhdo3xM9FDxf18OAO2BYQVEha+GMK/dJXjnTVX9SsF8Abx5ws1ALHjZWVx1MTQqowq1EfKjOLdWplSYZD69KomlAJfBMooHTuAMg+0
 yH3o6NoA
 T7eB4NmMXFNgxwOyJ9+M0bQek8f2f7VzNYg8vZgWs1HezraliZ+BzrRkMaLJHhMjf+HyIdgoyRVrRVoruZllA4/zWVOkFOkhG2C73B3qnr+7wRSBfrLfNj0PdRjvw7HV+fmc2uKx8zBoa9fCrj6KJ2hfLrGJjrCxO9ALukwMUV/HM1Pwk5nFB2RsRSNgnK6A68KBLb9e0AS9YSQsCLzFJHOg4hTg7Mvduw3z2yM++VKHJkyTOHeptWj6TWY8VeFE2aaYI9EOX7f8EDr0PtgmpmL9w6xoniu4gSL2/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 8:41=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/11/26 21:59, Suren Baghdasaryan wrote:
> > On Thu, Jun 11, 2026 at 12:53=E2=80=AFAM Alice Ryhl <aliceryhl@google.c=
om> wrote:
> >>
> >> >  b/drivers/android/binder_alloc.c |   26 +++++++++-----------------
> >> >  1 file changed, 9 insertions(+), 17 deletions(-)
> >> >
> >> > diff -puN drivers/android/binder_alloc.c~binder-try-vma-lock drivers=
/android/binder_alloc.c
> >> > --- a/drivers/android/binder_alloc.c~binder-try-vma-lock      2026-0=
6-10 15:57:55.274412018 -0700
> >> > +++ b/drivers/android/binder_alloc.c  2026-06-10 15:57:55.277412124 =
-0700
> >> > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
> >> >       struct vm_area_struct *vma;
> >> >       struct page *page_to_free;
> >> >       unsigned long page_addr;
> >> > -     int mm_locked =3D 0;
> >> >       size_t index;
> >> >
> >> >       if (!mmget_not_zero(mm))
> >> > @@ -1151,15 +1150,12 @@ enum lru_status binder_alloc_free_page(s
> >> >       index =3D mdata->page_index;
> >> >       page_addr =3D alloc->vm_start + index * PAGE_SIZE;
> >> >
> >> > -     /* attempt per-vma lock first */
> >> > +     /*
> >> > +      * Attempt per-vma lock. This is essentially a
> >> > +      * "trylock". It can fail even if the VMA exists
> >> > +      * for 'page_addr'.
> >> > +      */
> >> >       vma =3D lock_vma_under_rcu(mm, page_addr);
> >> > -     if (!vma) {
> >> > -             /* fall back to mmap_lock */
> >> > -             if (!mmap_read_trylock(mm))
> >> > -                     goto err_mmap_read_lock_failed;
> >> > -             mm_locked =3D 1;
> >> > -             vma =3D vma_lookup(mm, page_addr);
> >> > -     }
> >> >
> >> >       if (!mutex_trylock(&alloc->mutex))
> >> >               goto err_get_alloc_mutex_failed;
> >> > @@ -1188,13 +1184,11 @@ enum lru_status binder_alloc_free_page(s
> >> >               zap_vma_range(vma, page_addr, PAGE_SIZE);
> >> >
> >> >               trace_binder_unmap_user_end(alloc, index);
> >> > +
> >> > +             vma_end_read(vma);
> >> >       }
> >> >
> >> >       mutex_unlock(&alloc->mutex);
> >> > -     if (mm_locked)
> >> > -             mmap_read_unlock(mm);
> >> > -     else
> >> > -             vma_end_read(vma);
> >> >       mmput_async(mm);
> >> >       binder_free_page(page_to_free);
> >> >
> >> > @@ -1203,11 +1197,9 @@ enum lru_status binder_alloc_free_page(s
> >> >  err_invalid_vma:
> >> >       mutex_unlock(&alloc->mutex);
> >> >  err_get_alloc_mutex_failed:
> >> > -     if (mm_locked)
> >> > -             mmap_read_unlock(mm);
> >> > -     else
> >> > +     if (vma)
> >> >               vma_end_read(vma);
> >> > -err_mmap_read_lock_failed:
> >> > +err_vma_lock_failed:
>
> This label is unused btw, which is related to Alice's point.
>
> >> >       mmput_async(mm);
> >>
> >> If the vma lookup fails because the mmap write lock is held, but the v=
ma
> >> actually exists (has not been unmapped), then this code might "success=
fully"
> >> remove the page without invoking zap_vma_range(). This means that the
> >> page does not actually get freed and will just hang around forever unt=
il
> >> the process owning the vma exits or Binder needs this page and maps a
> >> new page on top of the page.
> >
> > Yeah, I think if lock_vma_under_rcu() returns NULL you just need to
> > jump to err_mmap_read_lock_failed, like we currently do if
> > mmap_read_trylock() fails.
>
> I don't think that will be enough as well, as the current code AFAICS doe=
s
> something meaninfgul when mmap_read_trylock() suceeds but vma_lookup retu=
rns
> NULL because there's no vma at that address. Now we would just assume the
> trylock failed even if the reason was that vma lookup found nothing for t=
he
> address. The problem is that lock_vma_under_rcu() can't distinguish those
> two outcomes, so we would need something that does?

Ah, you are right. I misread the condition in that code.
Changing lock_vma_under_rcu() to distinguish between lock failure and
no-VMA case would require some refactoring. vma_start_read() should
return -ESRCH if VMA was not found and then we handle that in
lock_vma_under_rcu(). That part is not hard because vma_start_read()
has only 2 users but then we have to propagate that error code to
lock_vma_under_rcu() users and there are many of them. Though
converting these users is straght forward. Instead of checking if
(vma) they would have to check if (IS_ERR_OR_NULL(vma)).

