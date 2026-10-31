Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB12606A320
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 05:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MF+ghSkY
Received: by kanga.kvack.org (Postfix)
	id 63FAE6B05B2; Sat, 31 Oct 2026 01:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA246B05B3; Sat, 31 Oct 2026 01:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8666B05B4; Sat, 31 Oct 2026 01:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2D56B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:55:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A7A94093C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:55:14 +0000 (UTC)
X-FDA: 85381858548.22.CA738E3
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD62780003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:55:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MF+ghSkY;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793426112;
	b=6NdMpcdAMZsPVmNuv1bFHWlUnBUKsMtde0UeDItC1zZ7k3LS74qCVPlo/7/jXG8v2wGh6M
	xGMwly5aWcT3OBRScT7O8uqcfSCP1X62GT/NehW29vY323IJmW94cVAI78H7zom6H+5b88
	eY5ZBWbrzbFCvKrNg8HC15iTe5uFEDY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MF+ghSkY;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793426112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mK4CIiWiVxpLggdWj3AZATJbmi8Y5VPf+YWX8QjFhvA=;
	b=pJoQdOXdq5giQ90Ofwpul53vp6mFzMA3ShKaOVQYGiVdkR/jeZQFN2Qqs9m7jWCD/3H08s
	grAvtOwzkFa7hbSGAsgmYPTPDiHe3JhmTbncdM1b/xGjWiqBOn2voo1l5QpMsfz30cq2ui
	V6fhwiRZctYtVa/LHwtE80wDpGYCpkg=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c4c9abc1824so215390666b.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:55:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793426111; cv=none;
        d=google.com; s=arc-20260327;
        b=n4uzWeh01I5WOKKIFpfDNEuw4+0ymIDbZBCCQDzF5knyg1JvUKOHMimeZwnuZ2KQGy
         Jp1ENAYNZSCjTWeSyqm048lYBrXPp1ochv3xlh7yvhvJKnkbpoKG2hvoKpHcX3PjUHi0
         aKslboh85xuSIZOekKpfCJ8OP8p876lhcp8tM9CwIJuEa+Llj0tsOnfhTeRa99LtdGrq
         EXeKQ6rnZRBmq4D91zufK8ckBoWYnAfwJ8E6b9GPbDkMfVHsLRp/RmgbI/nD9ENOLZIZ
         xfebXfabCD8PuUNq0OyOOOiS/4CrvjJbQ4vVZ8cqmPmg217m2uNjAsNZyov/IwWnt2Bc
         CdhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mK4CIiWiVxpLggdWj3AZATJbmi8Y5VPf+YWX8QjFhvA=;
        fh=NtppXAKTdLWv0GEUtFbPwbjf5ry1bEZyrVImNYTWX6g=;
        b=rmp8RQDPXgqKNguB6/ZVwvgCYnCVHGbpJBgj+mtLYot0vHO/V77IJFhmfIfojuQt1p
         dOvirLNYY5pu8HNwQHVJdCQBo8F5/mQ63AaOYqL/7uIITbb6MkSjEIr3sBd/XVgApSO3
         aU+tH0bCZntyJCzrXfhbVhhcAMW5a8VO83ToZ3YxN/2vwgZ8O4lxpTHe3jfbhhguC5OH
         wk1h1+sTVw+h+SXq3EBcgL5nvINCcPObPngp5v5yAQpc17q2kEHTO9Qpg7YJr2hkC4x1
         xVe67z2ot//1kN9od7W51Jmd6dOgVkNsDheBIytTSal6OwpDsWk47tBTklwjR8ZV6iM9
         +ekw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793426111; x=1794030911; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mK4CIiWiVxpLggdWj3AZATJbmi8Y5VPf+YWX8QjFhvA=;
        b=MF+ghSkYZ9JZGGqM06f1DnUH3jaRyqqW8J38Q7bhnZKnXac0wtUyPZ1ycyR2eIQRtZ
         DRkZOFasi0c2xfwwyEMtDxuZezhQTB+fgIH5l//u3R4T0x8GFsY66sHwTFjq05k3epBV
         s6iHJSXlC2ZwXTzH7W1hxktiavqmTbaUDbPxQrPbXCgmbKM4l+WzN+bcvfBOfdsQfYVS
         fpqkkpXqte6tzyvYcGLcE8BgnFSFaoJZdWyrP5CkvJNJ91aweRVH6r76cln+wPVb7ZYn
         yPhZMc3s7iY74fNAyWeENv8hGMQD8WkRElnW2KZzQdFA4cVykToHFx7uF1iLPEQPcpPP
         j1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793426111; x=1794030911;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mK4CIiWiVxpLggdWj3AZATJbmi8Y5VPf+YWX8QjFhvA=;
        b=uSY/1ABiLQu6xQKs6zH314paigL3ug1Yhb263gWL18JrxNfeM+GnUa/Dp0jpJupCQh
         9W8BoFjIYL0zYI/0DhgiF2UfV8Ue0fboGNd8L89kiLKUa7mo/3sXmI5B4GdvNxVfSDw8
         eaG0CRuPF69/LMpTn0jjpzCkdgr53QhInTVYRhS18UhlRWIO6zXahqFeDVUA/qIU7eER
         /hjyoz0AnjcJO3f7Df7BHJHajiFPrQC1U6dLauaJS+75pbtcvXIV8+FIV28KN8ck611z
         +hkRhAod+zr898ZLuXeWDO//FfqVcRQkZWOWRTw78KfL6w7uXOdqZjwYdPK+n4Wx3CWM
         NZbQ==
X-Forwarded-Encrypted: i=1; AKwUvBxv7vdzxodwabk8/MInw24yYHqB3hPtfol7BKfR/dpLcyZagwS00ctrPf5Wp/jh69/NkuXYHYrHPQ==@kvack.org
X-Gm-Message-State: AFq9FYIY1Hi+3KtM9FyZJhDkEzX9E/UMIbbLbfwm5SmkRu1sDIhOAvKx
	JCWQU4MjoaOZqBD2paJ1ZtuIQrUBfYw31lvXGDjjEMikYgrCI5m0+5q7F2NihFFDJglQNaF4iSd
	YOv63FvnTczfLdyE2yAIbXyf/EygR9wOlZMxRXfPJPQ==
X-Gm-Gg: AYBFou0cu6KId/xYMYSFRxODyA2vFC20/HJvE1GHP4MD+XNt23ncUpD95VjpE5Q8jeH
	7ghZBTiPepib72qbLWXjgOtGuE8+2GR9mncHPI2LPIWKAou27Q/YWXVmSvNWgDhA8tJ7cUK/cgM
	3Sa1ribeZORf/AOo4G3BkafWcYWpHcGBorXwKc0Tr6m8hWd6LTa4npkqqB5dJ5sQFKOilrVm/51
	tTc2GhYzID6IpufN8glRVOfQb/bK0/6nakQcY7w3kQUxuNKXl0yjzfaF3T8rAZYC/t1zacjBwXo
	SYXY+Hn9XgGKXnJgtp/dl+ROhPhDQN+tyXBLP72amDp5zLR1JmtSNxmyypWHBBD8dCDwQKziszd
	c6XT/B1PKCqP0kCoL3SvtE7ZR29AAMsthFg63tuBNYrl6CG0h0OCL5Dwp7l6+0EKdCTGJfA==
X-Received: by 2002:a17:906:2846:b0:c4c:bff4:200c with SMTP id
 a640c23a62f3a-c4cbff42ce4mr14178866b.32.1793426111172; Fri, 30 Oct 2026
 22:55:11 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu> <20261030155419.b10056c8fb37bc784b0d2778@linux-foundation.org>
In-Reply-To: <20261030155419.b10056c8fb37bc784b0d2778@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 31 Oct 2026 13:54:34 +0800
X-Gm-Features: AclHuK_Tt59KRB7QsGGZXIHAqauNkBZQGJskNrhNJaJ3MGaw4y8I0GPZZ0wnfjU
Message-ID: <CAMgjq7AUvsHVKkHmLzL-KKf+MBed6e4TeVP7jcGMLM22xO+=5g@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in unuse_pte()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mani Tofigh <mt4022@columbia.edu>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: AD62780003
X-Stat-Signature: zm5jxy7wxf7b6wnm7z5x6u8ecfbgfyhw
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793426112-864546
X-HE-Meta: U2FsdGVkX18ujomr2HhHnm702BjWYfctd8kLbT7fJjXoqF/uLafy2LXbogi0CYhCKl/8tozSjIJ/cDNYb9DGIWIF1549oHyO1f4//Drha2EaD960gq5J8+0M4Cjy16qZP1hJvsGipC52D1U26fHtTvozfMbhIeCbpp2gUEMSDVHZVwnc6pYrgMBwR773f6J8YTwoz2UadVmOgg8NHgx04TUb+cM1sStMyN5oL9+HzCDwlBygqmP3EB9pJ4iLnGmtFZtP2kXa/cwj5/VmoRWrooRZrAhq5DSqGQpz2J+Xg4Bv4mEwqiKhXghc0SgPrgEzBh+IuYeWnda58Y8+IU8lXvHuUa41kzRdFYCgt/W1rVM1O4tWTSlRUIBQAcQqZYwHBESwvAyz5/nGI/Gv9YxxYXcg7/bEqN9lqiie0wtZLcly9A3g5KQC4Acdo5Rl2lY5TziWL8ldzsBRplRgEKxTfbuW5RiFCSyFhX70oaxVk/s6Guh6P7tQPj10Ga0OWCHVU98E3NClneGLS6jx1djBdqV81jVwFfvujYVW69cGZJnYNBHLugSzoXQGKreeZHwEvFOMBwOm9pon54HqcCy+y1JkmnrUHQLUVwZQ4YO0BOXoPh5vD/0AZNkW6j0lHBbeBuZVVJO70qHTnF8TXCMUhob9T4xC462SLL85kYSB3m2GAjEQxCFLCCfasryyTuJrl3BlKW55SNjzXU79t6PkTOsDJ+cqzqeuwaYiMGYlgdKpzBsydTQMk0T3eDuz0xr3qA8zpZb+MnWQa84X09E6/nvgv9cGYIft2hlTf9vCb0WpnoF7GlrnEDXJi1BXpfevHOGFXIL37bt4WXe4Ewm4pMwJnDtoX7d0OlOXKkNIZHR8HOUugXtHg4s4jFQgTpTCSsK26iO+CNSLIcWVKylwdbNw8TsRJtx3Rjoq4J+Ow4a25fVEaXh5XdNbw0vmOQ/u3upaayJk0IUpgd0bhuS
 jQKXf4Y5
 sQVM8y7rWHWHnzXNBEqDqPQrrFtDcy7Gzgb9Gy6YA8q+qotOD0FGXxAlE6tspnQ3HYTPOXpsPDGDg1dAQ1Ygwim1/JeCuSan/6yYt9YM1BuaicwfCb/AcjMiWPebG+f0WTTJCmNNoodlE7fvqu2pMscXlooYT1M9uDljHcWz1W3xqHscFMEFHIKkax8ge5A135HUIv7DMxYejO6aXNRVbwjaZrVDj2AUjJNY/5lwhppjNuvVCgsFQD9g8nxMDDvZzqIuZvDomsIgWvoMZObpL6doRtwIhn42aiPsjzufXgBoO8NmuiTpyEAP5GRPIrUD5P1rQDNZHcyomZ5tRIMAU9Ey2XrtfB8Nh+vw3qgUfy0VuGc72yX0eAAWnRw60yCZLtvP1Qx0YXl8lpMLQgnlvMaMzD9HMHAfNGeaBdOYeH4QmKPyjDeoD5DBhKONZK9u8aTEDEJXOeMo8roz6GRgG80tG8Dr4GwvOuyVqUwQUZXj+1ueH242CgmqhuAS1guzUB3hEJHxx5NJZN9dqpR35s/ZUfcT+j7qTKOGr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 6:54=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 30 Oct 2026 15:11:56 -0400 Mani Tofigh <mt4022@columbia.edu> wrot=
e:
>
> > Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> > for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range int=
o
> > one large folio in the swap cache.  The folio only becomes anon once
> > do_swap_page() maps all of it, so if the faulting PTE changes in the
> > meantime the folio stays in the swap cache while not being mapped or
> > anon:
> >
> >   Task A (fault)                       Task B
> >   do_swap_page()
> >     /* swaps in large folio F */
> >                                        madvise(MADV_DONTNEED)
> >                                          /* zaps the faulting PTE */
> >     /* PTE changed (F not mapped) */
> >
> > swapoff then maps it, which marks all of its pages as mapped and
> > exclusive, and the next fault on one of the other PTEs crashes in
> > do_swap_page():
> >
> >   [    6.424485] kernel BUG at mm/memory.c:5195!
> >
> > ...
> >
> > do_swap_page() already drops such a folio from the swap cache when it
> > can't map all of it.  Do the same in unuse_pte() so that swapoff swaps
> > the entries in again.  With the fix, nothing is reported.
> >
> > This bug was identified and confirmed with the help of a deterministic
> > hypervisor currently under development.  The C reproducer below however
> > hits it within a second.
> >
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -2518,6 +2518,18 @@ static int unuse_pte(struct vm_area_struct *vma,=
 pmd_t *pmd,
> >       if (!folio_matches_swap_entry(folio, entry))
> >               return 0;
> >
> > +     /*
> > +      * A large folio that is not anon yet was swapped in by a page fa=
ult
> > +      * that did not map it (yet). It can only be mapped as a whole, b=
y
> > +      * do_swap_page(). Drop it from the swap cache and swap in small
> > +      * folios instead.
> > +      */
> > +     if (unlikely(folio_test_large(folio) && !folio_test_anon(folio)))=
 {
> > +             if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> > +                     swap_cache_del_folio(folio);
> > +             return 0;
> > +     }
>
> Let's not WARN here.  If it hits and someone reports it, what do we
> tell them?  "uh, that's working as designed, no action needed".

I think we better keep it, a dirty folio in the swap cache must not be
dropped directly or it can lose data: the copy on the swap device is stale,
so a later swapin of a shared entry reads that stale copy back. If it
triggers it means somewhere forgot to write back a dirty folio properly.

We may generalize this check into the swap cache helper though,
something like:

WARN_ON_ONCE(folio_swapped(folio) && folio_test_dirty(folio));

There are some special users so it's kept out side.

> Also, won't this change cause try_to_unuse() to keep spinning away until
> someone kills it?  Might be better to return -EBUSY and fail the
> swapoff?

It seems fine? The folio is removed from the swap cache, so the next pass
will go on. But you're right about the dirty and WARN case, it spins, so
maybe:

   if (unlikely(folio_test_large(folio) && !folio_test_anon(folio))) {
      if (WARN_ON_ONCE(folio_test_dirty(folio)))
         return -EBUSY;
      swap_cache_del_folio(folio);
      return 0;
   }

We won't run into this unless there are some other bugs I think.

