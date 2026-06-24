Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB625CDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 21:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888376B0093; Wed, 24 Jun 2026 17:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8384B6B0096; Wed, 24 Jun 2026 17:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7015B6B0098; Wed, 24 Jun 2026 17:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1FC6B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:15:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97D8F1A0493
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:15:00 +0000 (UTC)
X-FDA: 84916061160.19.95AD68A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 91449A0007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:14:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g78bl4l9;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782335698;
	b=2IAzyVapNwjc4dvXcVUFRvFUBMV37x/FvJTqPslRmRW7jrglkU/4ZCOJLNTM2HseaGawP1
	TAOiN2aF30MogE6htTWTfu9/xY2bw3omN6j3apyaUNl26yL7k17WDMwsY+otcY+5cEFGL0
	h1H0P3vYUflsJM6wQ0ZXfr347cwDWj8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782335698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCeZ8VqU84ruB94EwEJi8lpH01CxpMqlEj5VMxy+6kE=;
	b=5bnVoLRfoL7Lxqw8kr+DIH+Up3JhoezOPtCXL//MHgf2+vBxJEOZ+HLWHFOOh6c0s2uLV/
	Y/UUP0bBpYA4QiISp2puZ1NfwSfu8l/ro6K/6uDvNF2JXbeJB0GwwzH6rFP05oGCtaBcPG
	+wVK2TnpMQ6Hu250iWMwL1dGn/t0R4I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g78bl4l9;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3A774351E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E0C1F00A3A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782335697;
	bh=eCeZ8VqU84ruB94EwEJi8lpH01CxpMqlEj5VMxy+6kE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=g78bl4l94FFAYvnTYyk5UndiKA2HKHVuiWRjeSq0reQseTZMqOJJnDyaa52VAMXAH
	 f3amUaMLJ38cXmbKd/amTF4m6eYpGbA0L4iNLy2VKur8C7Kswm3mACGQfXwdgCqzKH
	 9AAugfS8Cn23hFR5St6jXC/BqSCAneviHyPplYdDtNMv8+gTuUfUq7HK/tJDXNirk0
	 5tu8fK8wwhw7Oju0PuoKs+LKcabyaGYFVP75eLA7ffuo+9eMvBwogjx64yyFsAE8yl
	 k9gHQW3KN0sfmYH6EmlwlrtWUq6y6yP+mOBwKSYpNQbPBRHoAyhAM2MhiRv5j73OYP
	 90NQqH5oyyAlg==
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51780bbc560so2960051cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:14:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/IASUg3O6eM/C3XEoeQ0btut6aYcLun2wgVjDM+Wg/GnzWF1pSRagt6Xky1Ew/v2stsYDwkrCz5g==@kvack.org
X-Gm-Message-State: AOJu0YzYDyxdaSS39QcTDjnupZp9tEz61SkvUXR+jECuwspHaI8BS10R
	4pTr/KNZkNk1rUHK4NzrBJLRwyZvkBUkTn7ITZ+pCbswQaZzDNGtRa/yBKEMwxG4jBdXDjU+c6r
	heWzlX1nfw7CIU1CSoW0TM6ACFlLrfi4=
X-Received: by 2002:ac8:5a48:0:b0:516:cd8d:c7fa with SMTP id
 d75a77b69052e-51a51be25demr128513661cf.39.1782335697092; Wed, 24 Jun 2026
 14:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org>
In-Reply-To: <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 05:14:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
X-Gm-Features: AVVi8CeWvGIPxeEZEtS2Z7zPM1_yMqbR3QHPGVgy4UGVB05PBeiFaRzILIH_fqE
Message-ID: <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev, 
	chrisl@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: grk6a11in95e49kpysedwnxutdxcyazm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91449A0007
X-HE-Tag: 1782335698-741852
X-HE-Meta: U2FsdGVkX1/+QtwkoIteC6X4c/shBGE/YOPJuNZLMnhanlQXo9x2+SjqBaPlx0CERCt7J5YYoTNTnMbbRE47lpg/INjQ9EkgciAR1M/cXo8EQ4blXffmU7uZ7JKQw/dCqXDxJOGeYhtFLQtyK0xvPsqu/N2ra+ojqUm7zJmJ8XYwaZk0H9jrNlA1PB7Adun++GjrwAt4PlARFDFGwOz7Q/QtKHWgGP2nJCCftyHF6d5BgZegjeQi6dz8DDVUcdoKNdxuZqh0h5q7sg65erSXdk+iOkVu/1T+4rXxUFfMRzF+IxcLR5R10kSJ/MHoUKSowi141HkxI5wNY+Gy47RRHE+SMITnGSnJp3+8QBNJnlarpDUPwKAO+OLIT3aAwzbZXTLeuRwJwhcnuhBenJP+QKiCtMwy2Qg4ZsdtGwe/R7s0cSO1WB4sXDxfHfOyocGL2dzJyvU+pWqp+/cBBOqabj+t71UOXfwV7A9aT+Z4z+dkijbaE45XktDIyR5fRtP2u+4PZUkF0HoHgXP+nt+kMZsoabK56hBtfkxM2HUM7hknDIh+cFPMwg0Z58bPy0CIMdaZYmcfvwywuVVzBsARHeqGYbS1RmRC6Uygy05noIoASuvFD8chy++w0b803Z5F36FNAVVOXR1bPnvvVnD13FobwAxz2RxYMpx/OqPJtOUXdrCMJDLG2cqFyfcVqOLnt/Q1UGo9cpf/3w1/DSi+lC0QnQUU5X5POrMbGf5Jr6DaR1PbHZZamQJqtIUwVYoO3GxXxIzwv7qpP7Un+DjNCwtPNbUttBIJz4dnZzBIF5gGWOR0JfFWgZMcCzVY732/1YfC055IyGDg8acXadik7Lx5Ye/sOyRuQsqYGpFSzd2IYc0n4CFXXhJ7BxRb/2CgYfEQPw5hFuKpSaeapti1aIzn/LyE4JIGJymIr2LAWuJTsh09AhFZlBeCp8tme5SuFcdHH92EMOVhVWZZQe2
 qyesbBj4
 1377j+Gql0hbXedYht42dd3sEJa48JzhOGpvI0gwSzCg1ujJGq2IczZTa0hXGCp8RnBVE6WKwwMTLB91aSFmoXpiBn6JiTElENMYZvNJ5DJAPJoOiDCtBxjNSdyITJrUZ4bdt+zNVOhEZvzC8ifDm/P90rgROZ8H9KsEd75cX8Acshw9cMiqunr1xYlQ0Z4dOeiWbDESJYSMVUGCa3OKaMucptbH/hMlaEdNErR/Fswfaqx3fomHyWgDshefkzU6QPWUHLxd1ipqTDelIuJDth1NPz3/BP3fp1puNXOzxfmq7+Dopu7vppS1wlcALS0SkGp8BOJtO38BCyHCKGURhrGJ6nKjKtOHpMWQfQeHwSfrmlh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 11:20=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> > Originally, we unconditionally called lru_add_drain() for write
> > swap-in page faults. This might drop the reference held by the per-CPU
> > LRU cache if the folio happened to reside there. However, there was no
> > guarantee that the folio was actually cached on the current CPU.
> >
> > Now that lru_add_drain() has been removed, we have lost one
> > opportunity to drop a reference held by the LRU cache. We could
> > instead incorporate that possibility into the condition evaluated by
> > should_try_to_free_swap().
> >
> > Suggested-by: Kairui Song <ryncsn@gmail.com>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/memory.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 2983a6baf474..14577c67c61a 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5087,8 +5087,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >        * Remove the swap entry and conditionally try to free up the swa=
pcache.
> >        * Do it after mapping, so raced page faults will likely see the =
folio
> >        * in swap cache and wait on the folio lock.
> > +      * Assume non-LRU folios may be queued in the LRU cache, which co=
ntributes
> > +      * an additional reference to the folio.
> >        */
> > -     if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags)=
)
> > +     if (should_try_to_free_swap(si, folio, vma, nr_pages +
> > +                     !folio_test_lru(folio), vmf->flags))
> >               folio_free_swap(folio);
> >
> >       folio_unlock(folio);
>
> Hm, in wp_can_reuse_anon_folio() we'll try dropping the swapcache ourselv=
es.
>
> So I wonder if we still need that handling ("If we want to map a page tha=
t's in
> the swapcache writable, we ...") at all?
>
>
> Ahh, I see the problem now:
>
> commit 4b34f1d82c6549837b2061096dea249e881a4495
> Author: Kairui Song <kasong@tencent.com>
> Date:   Sat Dec 20 03:43:35 2025 +0800
>
>     mm, swap: free the swap cache after folio is mapped
>
>     Currently, we remove the folio from the swap cache and free the swap =
cache
>     before mapping the PTE.  To reduce repeated faults due to parallel sw=
apins
>     of the same PTE, change it to remove the folio from the swap cache af=
ter
>     it is mapped.  So new faults from the swap PTE will be much more like=
ly to
>     see the folio in the swap cache and wait on it.
>
>     This does not eliminate all swapin races: an ongoing swapin fault may
>     still see an empty swap cache.  That's harmless, as the PTE is change=
d
>     before the swap cache is cleared, so it will just return and not trig=
ger
>     any repeated faults.  This does help to reduce the chance.
>
>
> That changed that behavior such that we *must* now always fallback to do_=
wp_page().
>
> What a mess (I didn't ack)

So it seems we need a patch before patch 4 to fix the missed
swapcache freeing on write faults, because the write bit has already
been cleared by the time the folio is mapped and reused?

diff --git a/mm/memory.c b/mm/memory.c
index 14577c67c61a..e8fc5a86f6ea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4752,6 +4752,7 @@ static void check_swap_exclusive(struct folio
*folio, swp_entry_t entry,
  */
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
+       enum fault_flag fault_flags =3D vmf->flags;
        struct vm_area_struct *vma =3D vmf->vma;
        struct folio *swapcache =3D NULL, *folio;
        struct page *page;
@@ -5091,7 +5092,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
         * an additional reference to the folio.
         */
        if (should_try_to_free_swap(si, folio, vma, nr_pages +
-                       !folio_test_lru(folio), vmf->flags))
+                       !folio_test_lru(folio), fault_flags))
                folio_free_swap(folio);

        folio_unlock(folio);


Best Regards
Barry

