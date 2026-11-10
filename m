Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAD7606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=f3yaqF1B
Received: by kanga.kvack.org (Postfix)
	id 9C90C6B05B3; Tue, 10 Nov 2026 10:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980C46B05B5; Tue, 10 Nov 2026 10:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FAA6B05BC; Tue, 10 Nov 2026 10:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67B466B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:19:01 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 081F380953
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:19:01 +0000 (UTC)
X-FDA: 85419567282.01.8D249F4
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0DEB11C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:18:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=f3yaqF1B;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794323939;
	b=ZSLNzrFBgzMXRpF9fmvLzamsImZTXSNp62tZnkTOc3TLv/hUsXeF1KOODpesza58qJh+O9
	OvR6adXCO66udUNiKavbJui604HAWqbk2FwyFetVNCznjy+Vja7GZbvCMlI+fktiME5oHP
	SV5/rrwlJMM+BDdVeZ0ORjU1HgCZHhI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=f3yaqF1B;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8b5Lf6ftuHfcfsHEGu+mKO1MgoMJIgVznAg6v4ATrxI=;
	b=zt6pHQ8JXWr7dN3QjUJ/fMM4AnEG97r/NywU7iiu8oIHt0Oyic5ZRDc7f/pQr/Mp6cfwju
	rtEqWG+pCTMvWcvzrzI5Iyz+UhlqzH9ARmnyy5Fp1OdqQHIIlc5N+ICUvsmxgNG+g8RwW2
	Fc0puLQJftSc5voSGwC9gb7JrJ0hWwI=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b579ed8da6so10506a12.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:18:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794323937; cv=none;
        d=google.com; s=arc-20260327;
        b=fXmFDZJUsBgDaKpPvlz7OehqQ78DHrxAhjBM/IYBLRE0anZgBQVxjnemfibI7xqPJQ
         h9f2NFxAbPw4cwn/tJLIWPmW3LVbkvrCFEsOYLcIAqINKycSAilmcEkvCijypxriM4Yy
         +9nmsHLWN8XuWGUV8hhCixqQA3nZ++R7P4h41vIyJ43xMGqauk5v8Py0iO8HSXCCZfVH
         6g8xDTN+WbTPhVg/flw7bA2AZcwObrDvuVH1SBvo2XFXfn06CviGwUEnV+stok4ByKTX
         aDY77ZENecVLjobBozr/depmJ8augi5Qlb/bokJCeCK/xxH/tPJWWhH+L6B/okoDL0y4
         l0gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8b5Lf6ftuHfcfsHEGu+mKO1MgoMJIgVznAg6v4ATrxI=;
        fh=yj6GmveIL8OXk2sLCLo1cYfY68DuvdgWE5dK5lw3pho=;
        b=pXv6TW/4DyV5twlQrG3qp0PjHwIW/uxwfP88G+vhVyOFGi91bmgJCH0fg2SXxX3LEH
         p5gFNjW4bNwS4FYNCr8/xpn7sbD8GPw4CIh/QazfbBiuftrrsgAswOU4u0wyOKbcfCmK
         Vgomi4r6/44+wCSdl7JKW0HOMFEnw9+EuCz6Sk1YNqm7hzc6sPsALNLEj8mRj2ogBsYe
         t00IX2tWdt1LiJDv/mFGHrItBOXFDNM8aN8wbI0a2DVeGJoHuVPnzf/PWfp3MDgGj35p
         KVLBvjiAoRTls1uf+QQdylQuJsLl6/lGdlvlr3rfpbBZ8hdNv7QzW/BnLY0OegcvrSWW
         u9fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794323937; x=1794928737; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8b5Lf6ftuHfcfsHEGu+mKO1MgoMJIgVznAg6v4ATrxI=;
        b=f3yaqF1BUyFUVNcpXek+MFkhlHPrUpv4IEphEZEA0ip3qiUtbofx1YrlMClESDHZY7
         5S6vKxSFAO+Gb+1HxPwXrr2h+/vurKRp1+ry385R6wP7sN+Xr3mw2eVS7BqeL8T6Kzz+
         fIPFoCq6vIacMRlwhhRtGa35zUFDjqh8nXceJ7SI8lc+MoRWBwMmLDiBhtssdFkifIUk
         oNmd0j7ji6SIFPMIUfmOa8XHLm10FKEJt3omudz62+Kt3+F+q9ygrP62754Eqqf4R0fK
         d8tv100b7POyIufnjYPbZaXOVhe+5CBG93AWHRCQXfYPd7BMN6ZVdmREHPiFVF8ZmM4j
         LrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323937; x=1794928737;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8b5Lf6ftuHfcfsHEGu+mKO1MgoMJIgVznAg6v4ATrxI=;
        b=Ekev9zGqtx5qQzxvy0Uv2RVpVk64Tu23xU1J0+2ZkB6cIVzBMFnR8YWyO4FweE76Zf
         VzHfUyRnjGS+d60xu2U1Nlv868f2Xy285WefwUV11CPHi66Q9SjW2bCb9HJvubCej/7b
         TF1jFwUzzDHNeyv9OMQDwkXBPNr/46OqV1uIlLuojjMrOBEJjuSa7Y9i4BMcxO5BwGdA
         Yczuyw2oaTrWtAChntme3nw7u78aOPEDXcq7no+Q7uTmUnGU1JiOc90XeIeFRh40lN7M
         Xxo5cRytwK6Fx/etrTXIlrza1PHMGDNqmePponqk8b7oNEnVdjOC/skaRnMC5sdAWOd2
         5TUw==
X-Forwarded-Encrypted: i=1; AL+hErHrc5n4nhHxjyNrKbH3mCk3b0zcAiSuvlWhN1ir+BoOMXJxURDKA1Mw2UL2iatgXHgYH2jzE0gubQ==@kvack.org
X-Gm-Message-State: APuU4Z+taISdaYLZhR1/D8nck0EhIvR9171ZIDOL0wfR3HYLu+fVXfPQ
	Bo4w6bGtcUKb4eWWcu4V8RAIuzGU6IkiBxNTsst8DG6i9XQJWpGeJ/loctCTcAcnYCHtzsrHP4Y
	ORptxqJS6n7GRQBP3EEAG8fDVpoWn1rfkE2ezeeOK27HSygMIu6ntutVT
X-Gm-Gg: AYBFou1fHvr77Q8SkOKhTfgnB/05sgKuP72Ara5mo1MFnmMx+9JeKYji3tTT9R3q+dQ
	uHw47urA/KibbUxZX6RZyuHA6j7/TrP3Q1C5jrsY5J1nwKwLa1frxqzf952N4cM154c7JTGO0lk
	Is/QmU5YRd3lBSGyzmcy7JZf3FG5kpbkyz0p7DRzFItIpZNWKRRjO+8INJO5IFKpC8On3wYKtLM
	X0lX0rb+5p02CKkVSExh+/oGP8B3nkmP4PrS4z8WrZzpGphDZN4+8WH6PtNhT1YoGgghKayM+J4
	vKcvunXgpDPECQbgn/IOBTq1NSMKGT+XrVbeQZgETVaQcM/2kL9JXrWnMyHbNUBCG7yLbsDohHa
	yqSYaz3rC4Nnfp7I/DT2OFjasrpOva7SB1XJBJbSIURWVTgY2By0R7x8Z9DAKkJUS2m6ePAFhW6
	rgzATwrOmmBlucaRO1Wq/HX/YfbsQAPIzwiV4g823xpwZfTQeg
X-Received: by 2002:a05:6402:a2c8:20b0:6b1:a517:5bce with SMTP id
 4fb4d7f45d1cf-6b75a7c6522mr69526a12.16.1794323936977; Tue, 10 Nov 2026
 07:18:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
In-Reply-To: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 10 Nov 2026 07:18:43 -0800
X-Gm-Features: AclHuK8YW4Gf8WqWPGeqjXKM_89-mP3P5tHV5hwbUgMRRbIQM_0XkyFdQ0hmOzQ
Message-ID: <CAJuCfpH46gm3WknMGQdv7TYfnVRN2Xkw8v=J8RVPOBZRJrpEDA@mail.gmail.com>
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on CONFIG_DEBUG_VM
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Lance Yang <lance.yang@linux.dev>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Seunghyun An <san55@wisc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: swj5gs43iddd3y5hi4pps4ufzy3ahcwt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DEB11C0006
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794323938-132591
X-HE-Meta: U2FsdGVkX19fdvZDW/dmUNJNmdFlcEb9GDmILaXjXaZvwFFEMRMAAklVMdbQtsmMd04/O0N9c47s+sNc9nekoiozaSosMPgQQGKy3Biu4Ehr33AdbowSWjl8aZTgG8aFc/GLnI3ylXLmW8oDAZJ48w8E/JL3h7C9mTA0nzNU/WIo2k+Kd3ndp+LwPM5KnOAfeZdnIodgAMeYzpk2C6kqK0qeqMnD79qP8bES+enl/EjHeqY8Up64IrxUWgiDN1aPe/Z/IxtGJ9tuoKZAS9lI6JGYBQuNgxGV/jPHV07EydHKRfo404HqkXKMk90k7EbpoHCk7CpookVcudtpisvdI/84r/iw91evZdtnmm+O7OoWRqCBBFJ4/jcoMPUtS+eQKaV3g2FIVGVGMjEDahj+rERTlHB1L+lEvfJ0wPQPMas0DkytwPNUe49m02rDle6stPr7pkSMwmIUgc2y3SbmWbRjhfy9Wm4CkZ6hBIl/nmYaDT/2aAo6DfDT4wd8mCZ+3b3bYtj6IvH9X2e+d43xMjr7hek0h08pRUA88EVVdGKb91Stl1sTCdXk5wQoxA4txkH/R2S3wi8FBX+qnoiUiYhP8Q2CeKuss4DdJpgjmjixeENxYCnr0fOkSsGwYpzZgfKlscTB5AhWgy6WBah6lILspHotSTkGaLwSeM3sABUluzeNAAAPV9mgLecEP1WL5KjurJoqSbqaOoaZowjNVPUEnmfPHE6ca2YQgzZmbHdSRnjNnNmP5Mz0gpYrwtaJeC842bbRuPNJk6nbk0AY4rwtX+sOY8MO7yyCoBS4PyybJiOdE5lFu72L/+uE9OWXCWypbImdP3Ase+eCzPN+EhGcGHEszCOGpbOJU/PtBToIQrj2QmhnekxAloSG6UnCxKZ6hHwEPK2X5YJOmr0wWJ8+4XUTuhx5+aqdbA6L2sFRk6LIJ1s9wDVRcI2PQoO6G7uDLhdi9pYpbpHmL8v
 H6bC6X7C
 //drXJoIx7cCOEMoiP9/ayg4m9QockJumjtFSH7VGJ4XYSu9ZkDq+Jyzi+8tIop+q0+tx22i8Xd7bPmNk8UHdrAe8yVdFnu3CESImmveZOnjd1gNZn+bHkQ1qHst1Myn5zYmq86dpn22HCqO+udDberdKuw2EUCxItWIZMFJAAqnCqzMm7bnccuZkbTWV3Gk2dOl24sppy/A3OGL8+K6Wp4pi4REJL0SzLGAvtPWD3OkiohYaox2x/Pk0vkrcNjxG6wTNJKel4eL1S9EXRTnrKWYQJKWQwgN1Dvxg5H6DcRWtHtX6ucNfeyZn+eBXttCizUK8QizehXYX/B4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 7:10=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> I introduced commit 17fd82c3abe0 ("mm/vma: add and use
> vma_assert_stabilised()") with the intent of picking up programmatic bugs
> when debugging mm code, but kept the general practice of asserting even
> when CONFIG_DEBUG_VM is not set in line with existing code.
>
> However, it turns out doing so can cause performance regressions,
> especially when asserted in vma_has_anon_rmap() which is referenced in a
> number of hotpaths.
>
> Since the intent was always a debug-only assertion, explicitly check for
> CONFIG_DEBUG_VM and do not assert if it isn't set.
>
> Really all of the assert paths need to be predicated on this, but start
> with this one only, out of caution.
>
> Additionally, since a detached VMA is trivially stabilised (nothing to
> stabilise against), check for this case at the outset, and update
> vma_has_anon_rmap() to not explicitly need to check for this.
>
> This also, importantly, avoids reading any VMA fields if CONFIG_DEBUG_VM =
is
> not set.
>
> Target the commit which introduced vma_has_anon_rmap() for the fix, as th=
is
> is where the issue started manifesting in practice.
>
> Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence =
KCSAN")
> Reported-by: Seunghyun An <san55@wisc.edu>
> Closes: https://lore.kernel.org/linux-mm/20261110000002.1834454-1-san55@w=
isc.edu/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
> Note that vma_is_anon_rmap() was introduced in 7.4, so no need for a cc: =
stable,
> just needs to be sent to Linus as a hotfix. Thanks!
> ---
>  include/linux/mmap_lock.h | 19 ++++++++++++++-----
>  mm/vma.h                  |  3 +--
>  2 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9ccbbcbd7aca..9c3a9c6525c1 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -408,6 +408,11 @@ static inline void vma_assert_locked(const struct vm=
_area_struct *vma)
>         vma_assert_write_locked(vma);
>  }
>
> +static inline bool vma_is_attached(const struct vm_area_struct *vma)
> +{
> +       return refcount_read(&vma->vm_refcnt);
> +}
> +
>  /**
>   * vma_assert_stabilised() - assert that this VMA cannot be changed from
>   * underneath us either by having a VMA or mmap lock held.
> @@ -418,9 +423,18 @@ static inline void vma_assert_locked(const struct vm=
_area_struct *vma)
>   *
>   * With lockdep disabled we may sometimes race with other threads acquir=
ing the
>   * mmap read lock simultaneous with our VMA read lock.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.
>   */
>  static inline void vma_assert_stabilised(const struct vm_area_struct *vm=
a)
>  {
> +       if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +               return;
> +
> +       /* Detached VMAs are trivially stabilised. */
> +       if (!vma_is_attached(vma))
> +               return;
> +
>         /*
>          * If another thread owns an mmap lock, it may go away at any tim=
e, and
>          * thus is no guarantee of stability.
> @@ -454,11 +468,6 @@ static inline void vma_assert_stabilised(const struc=
t vm_area_struct *vma)
>         vma_assert_locked(vma);
>  }
>
> -static inline bool vma_is_attached(const struct vm_area_struct *vma)
> -{
> -       return refcount_read(&vma->vm_refcnt);
> -}
> -
>  /*
>   * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached()=
, these
>   * assertions should be made either under mmap_write_lock or when the ob=
ject
> diff --git a/mm/vma.h b/mm/vma.h
> index 3fc3b47a954b..05300badd70b 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -278,8 +278,7 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_=
merge_struct *vmg)
>   */
>  static inline bool vma_has_anon_rmap(const struct vm_area_struct *vma)
>  {
> -       if (vma_is_attached(vma))
> -               vma_assert_stabilised(vma);
> +       vma_assert_stabilised(vma);
>         /* KCSAN gets confused about the optimistic check. Silence it. */
>         return data_race(vma->anon_vma);
>  }
>
> ---
> base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
> change-id: 20261110-vma-fixup-debug-asserts-2d327fe27f8c
>
> Cheers,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

