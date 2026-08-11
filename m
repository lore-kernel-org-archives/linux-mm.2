Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080A9C5B574
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C887F6B008A; Tue, 11 Aug 2026 03:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C113D6B008C; Tue, 11 Aug 2026 03:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03AB6B0092; Tue, 11 Aug 2026 03:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 760F66B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:52:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 088CFA2589
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:52:35 +0000 (UTC)
X-FDA: 85088221470.24.AC3B8BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 48E804000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:52:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UILUQJdW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786434753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JE0w6dvQkJLnL/LgPQgbWagV72XL6N2t+jHMVla2xXA=;
	b=JY0UcKBk5kUGHb46hcOj6C4Fp+Jo7uLe+yItJFb9s+Krsr6I5wwmsndyFi/OUlyirLMi1x
	o5GZOqUPNhhEXQYNqnRwfMjaLxXf2mLo492ITzfStxvmGyL8HUt65wdeKzW0X5pAy3dQ3S
	3YhW+C2dlgEUH/lms1GZtBHWt1wF8q8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UILUQJdW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786434753;
	b=7z7afqSm6JJGQ/PL0wNjZrqu+6fO/wcX7KsstlsaZ/GfbnK3cHyRtsOTV1iQ1anb0XdHC3
	rV7WQqumqH/jpJxVKlppm766plvOozhTgKZU+FZO0CVeZBLKrAF0kULXS/PyY25lJQqC51
	YJiDo1lbuWrEGAXYOji46LR38+CLLRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B850243E05;
	Tue, 11 Aug 2026 07:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4541F000E9;
	Tue, 11 Aug 2026 07:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786434751;
	bh=JE0w6dvQkJLnL/LgPQgbWagV72XL6N2t+jHMVla2xXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UILUQJdW8stnLuLilsUZe6rgEnrCaxqkdS1MP4fsnqdLf8lM0TKMR6zcUYNRjvBR4
	 tXWOSDdvyUOFvBQ+hPNJFXUbJerRSzjvornZfSBCwsZy58E4uV6CwMz8Yx4D8vy9LT
	 ux2nyyR41v8LVOS9vPQ7zzx1UFJyVTjxU0hImaDw1eMcUgh/EsY2oFMJoYxvK6fylP
	 qbAz2fz3CAlvLhnEKi1/TmshRCMh469ttT+WddFTucnTTblq252RX2xHFcx7OiiBgN
	 sJo877+mW8ICZ9nFtqjClO3Lkgn3Gi0rgvsjew8p9RNG2gtH9dumKN9eJNpemVvo4B
	 jOIrliIk2KUig==
Date: Tue, 11 Aug 2026 08:52:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: yunhui cui <cuiyunhui@bytedance.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	00moses.alexander00@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [External] Re: [PATCH v2] mm/madvise: avoid skipping pages after
 splitting large folios
Message-ID: <anrSjfbBNvpcxCAC@lucifer>
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
 <anQyoZgi5Urnvvjw@lucifer>
 <919b804b-6f1d-417e-9c0c-d06f50d765d8@kernel.org>
 <anSar_i8UjniSbML@lucifer>
 <a6a9e0cc-e6cf-4f83-b6be-7d64058b8fa6@kernel.org>
 <anSqbW1w2bDDHpAx@lucifer>
 <CAEEQ3wmJoUF5TDQDfMU_dUHnY+gg7MYG=OmmdB3Ynpdu9gJ7-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEEQ3wmJoUF5TDQDfMU_dUHnY+gg7MYG=OmmdB3Ynpdu9gJ7-g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: qagrx33ob4ij6q98qrn916tzepay4g5c
X-Rspamd-Queue-Id: 48E804000D
X-HE-Tag: 1786434753-749244
X-HE-Meta: U2FsdGVkX1/UQ3/+Z50lmOuPA5iTSzLQ6YSUZpWiBlHJSomhx1l6XNaReW7TQkvmFjuBFt95aBGN9Aqrlae/ki/+OoDqBp2/4ZugFVHpToPy2Pwt3Ydo3tuHFksiRYJ4mibfRcWta0/A0LwVMp+Gx7k8ga1IdwGmEMdL1XL6bUVz9XPSU7i7mMwW9HRm6I/tPl2c9hWR/FSLFmZh/XmxG+ARhhxg/Ram5U/xZg61NlAmfiWH3XyOvsZmOsJAwreydhrfVnJfmLab7oXuxzcSyD6EbvkdSOytEKSbZS34OurmpZSYifAvP8M5c1kmPLO59FbW5RTlOHRFHMlfnEcvMEEwoBI8+/lkCyFiR4R3LN0yA5IVbPtVZEqDi0T9z139aYYQpMhEZQyA5C94tfo+4fa//pLdzkPOCJrmaUTUJyIAghS0ZLL0Kd0TTfFT7EkEHR3rsMWzBY9lwxCu2xSVZ6QsQviMrX+hZ42BY4KA4AJrderem3N4GDcBT75CTkgbw01Eq76SKs59nClTY8Xe8x1zQx6ynseOpdEZs8cnheCWxP+DC0o1xdAw7RMnDtVdUVhLSse/KKlOM6qDx4kYDOzJgBXjvJRc6EjjtJ+pz5i2wMk1Lja294mUcN+pPuygzw7Fz84NHkTGWWyM32u9Tbd8nGJxwOSPHd2j4mHAwm7dyUABQ8NmakIF868FkY0iNVk0tWisB8m0P6bEmQz/761aYUxG6JfwH99tflHNugHOJFiY8QsEM/9NJfRbsp/LANsmlvnjxCQvoZqS+OGflzPpt3og995TWDtw+/KEjB1av3pepsRezT+rXkl1ZCJ0UsS8gYlhpcmg1RgkPgA88/tJfPDO6KaYlTLQ6pCr2HHD84MAAmO5QQa0wrVsIp8nCTXgc5fUzPRuGtBaEAbR33ugS2spdaTw6xHtu15Ao0GtWROFEJ7vLdCfAyT5GjafPIn/TK8d1rSYN/vgU0L
 /0xTEgHV
 lduqwcojenJSl/ujl1hWo5SW2UtARB399GEb98fPRWBhXXfTfTrGUD7c3eqGJ5JZvZAf1Gwg8yPKvZRwXpiABnqa0p4Ecj7VJ749DgUOu8agXMlmKK6U70AuhY1yxbVrFg/SDTfwPxrgVYl8mE3+1UZzVj03qKpCbn83ezAiZNQB9rtxg7u4rKNf2uv3Qq9uJ6ubUtbSbdYDgafrsjSFwQC3WwaLaqJV0/hCZRhLDHm3Kwa2Fx18tkh1c/ndNF3xtJyP8FOHby0lXJAfsLrIjkFzJQQntNHpE5jeEo0tEoHdM2Y32ZV+76Whj4SYEogvz10lxnK1Iayk4hm31rw4d3WHFpCmirkJbRWJKGsMQXSF3RO9Xc5Bte4/XYYlS3y8P7WgWgmn1PcDMsL0f1lQS/Ga2FYrxr8RdL4tAp1Qm555mJks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:31:21AM +0800, yunhui cui wrote:
> Hi Andrew, David, Lorenzo,
>
> On Thu, Aug 6, 2026 at 11:40 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Thu, Aug 06, 2026 at 04:46:10PM +0200, David Hildenbrand (Arm) wrote:
> > > On 8/6/26 16:34, Lorenzo Stoakes (ARM) wrote:
> > > > On Thu, Aug 06, 2026 at 01:35:30PM +0200, David Hildenbrand (Arm) wrote:
> > > >>>
> > > >>> Let's at least split out the folio check into a helper to make things
> > > >>> clearer:
> > > >>>
> > > >>> static bool poison_splits_folio(const struct folio *folio)
> > > >>> {
> > > >>>   /* Hugetlb is, as always, a world unto itself. */
> > > >>>   if (folio_test_hugetlb(folio))
> > > >>>           return false;
> > > >>>   /* Soft-offline errors out, hwpoison traverse DAX intact. */
> > > >>>   if (folio_is_zone_device(folio))
> > > >>>           return false;
> > > >>>   return true;
> > > >>> }
> > > >>>
> > > >>> Then for your patch:
> > > >>>
> > > >>> -         size = PAGE_SIZE;
> > > >>> -         if (folio_test_hugetlb(folio) || folio_is_zone_device(folio))
> > > >>> -                 size = folio_size(folio);
> > > >>> +         size = poison_splits_folio(folio) ? PAGE_SIZE : folio_size(folio);
> > > >>>
> > > >>> I tried writing something that was neater and nicer but AI kept pointing
> > > >>> out how it was totally broken and I really really hate this code (not your
> > > >>> fault :).
> > > >>
> > > >> No, I don't think any such special casing on folios is the right way to handle it.
> > > >
> > > > I mean the issue here is the stride varies depending on whether the thing is
> > > > hugetlb or not (and some weird DAX thing), and the poisoning causes a split
> > > > otherwise so if you want to poison a range you have to account for that.
> > >
> > > We GUP'ed a single page and now try to be smart about which other pages we'd GUP
> > > next.
> > >
> > > That's just wrong, and hugetlb special-casing is just ugly.
> > >
> > > The problem here is that, if we GUP'ed a page and poisoned it, the GUP'ing the
> > > next page might fail and we'd return an error.
> > >
> > > But maybe that error can simply be handled? We have FOLL_HWPOISON.
> > >
> > > So maybe we can just use FOLL_HWPOISON and skip over the entries that already
> > > return -EHWPOISON?
> >
> > Yup this is ugly debug code so that works for me.
>
> Thank you for the review. Based on your feedback, I went back through the
> madvise, GUP, soft-offline, and memory-failure paths and outlined the
> changes I plan to make for the next revision.
>
> The issue is that using a page obtained for one address to infer how far
> the range walker can advance is the wrong abstraction.
>
> For an anonymous large folio, soft_offline_page() splits the folio to
> order-0 and handles only the supplied base-page PFN. Advancing by the
> pre-split folio size can therefore skip the remaining base pages while
> madvise() still returns success.
>
> Lorenzo also raised the semantics of a range that covers only part of a
> hugetlb page. Looking at a range that crosses a hugetlb boundary exposes
> another problem. For example, with two 2 MiB hugepages:
>
> hugepage A: [0, 2 MiB)
> hugepage B: [2 MiB, 4 MiB)
> requested range: [2 MiB - 4 KiB, 2 MiB + 4 KiB)
>
> The first GUP resolves the last base page in hugepage A. Adding the full
> 2 MiB hugepage size to that unaligned address produces the next address
> at 4 MiB - 4 KiB. That is already beyond the requested end at
> 2 MiB + 4 KiB, so the loop terminates without ever visiting hugepage B.
>
> For MADV_SOFT_OFFLINE:
>
> - ordinary pages and large folios advance by PAGE_SIZE because
>   soft_offline_page() handles the supplied base-page PFN after any split;
>
> - hugetlb advances to the end of the current hugepage because successful
>   soft-offline migrates the complete hugepage and leaves a healthy
>   replacement mapped. If the walker advanced by PAGE_SIZE, its next GUP
>   would resolve that healthy replacement and soft-offline the same virtual
>   hugepage again;
>
> - ZONE_DEVICE does not need a stride case because soft_offline_page()
>   rejects it.
>
> Advancing to the current hugepage boundary, rather than adding the hugepage
> size to the original unaligned address, lets the next iteration start
> exactly at hugepage B.
>
> For MADV_HWPOISON, I plan to follow David's suggestion and walk at
> PAGE_SIZE using:
>
> get_user_pages_unlocked(start, 1, &page,
> FOLL_GET | FOLL_HWPOISON)
>
> get_user_pages_unlocked() is the appropriate interface here because the
> current gup_fast_fallback() flag mask rejects FOLL_HWPOISON, while the
> memory-failure madvise path enters madvise_inject_error() without
> mmap_lock held. get_user_pages_unlocked() acquires and releases mmap_lock
> internally, handles fault retries, and propagates -EHWPOISON from the
> fault path. FOLL_GET makes the page-reference ownership consumed by
> MF_COUNT_INCREASED explicit.
>
> A successful GUP is followed by memory_failure(). If GUP returns
> -EHWPOISON, the address was already covered by an earlier larger-granularity
> injection, so the walker continues with the next base-page address. Other
> errors are returned. This avoids hugetlb, DAX, and folio-size inference in
> the MADV_HWPOISON caller.
>
> Device DAX is relevant only to MADV_HWPOISON because
> MADV_SOFT_OFFLINE rejects ZONE_DEVICE pages. Since the proposed
> MADV_HWPOISON walker advances by PAGE_SIZE and uses each GUP result as
> feedback rather than inferring the handled range from folio_size(), it
> should also avoid the same granularity problem for Device DAX. A
> successful GUP is passed to memory_failure(), while -EHWPOISON indicates
> that the address was already covered by an earlier injection. Advancing
> by PAGE_SIZE should therefore also work for Device DAX in principle. I do
> not currently have a suitable Device DAX setup, so this remains untested
> at runtime.
>
> Because MADV_SOFT_OFFLINE must advance past a hugetlb replacement while
> MADV_HWPOISON can use FOLL_HWPOISON feedback during a PAGE_SIZE walk, I
> plan to use separate walking models for the two operations.
>
> Before posting another revision, I plan to split the work into:
>
> 1. the MADV_SOFT_OFFLINE range-walk fix;
> 2. MADV_SOFT_OFFLINE large-folio and hugetlb selftests;
> 3. the PAGE_SIZE + FOLL_HWPOISON MADV_HWPOISON walker;
> 4. MADV_HWPOISON large-folio and hugetlb selftests.
>
> Does this separation of the SOFT_OFFLINE and HWPOISON walking models look
> reasonable?
>
> For stable, would you agree that I should omit the explicit stable Cc from
> the next revision?

Sigh. This reads like you've just got an LLM to write up a summary.

And prior to the slop era I _never_ saw a summary like this, ever. People would
_reply to the reviewers_ like we were human beings and not prompt-generators.

I've seen this enough times now from sloppers that I believe the intent here is
to workslop reviewers into checking the plan so that response can be fed back
into the LLM as a prompt to write the patch for them.

And I'm not sure I'm interested in seeing a v3 from you given that.

Please read:

https://docs.kernel.org/process/coding-assistants.html
https://docs.kernel.org/process/generated-content.html

And follow correct kernel process on this.

--
Cheers, Lorenzo

