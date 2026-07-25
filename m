Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF36C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 03:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2096B0088; Fri, 24 Jul 2026 23:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853156B008A; Fri, 24 Jul 2026 23:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769526B008C; Fri, 24 Jul 2026 23:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 454856B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:06:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA57D16023D
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:06:14 +0000 (UTC)
X-FDA: 85025810268.09.F1BCCE1
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id CD022140002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:06:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hPezswbX;
	spf=pass (imf26.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784948772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIiMlCPc8Mt7Alei7lSmaxgcI/fmuRXko3LEZs3caok=;
	b=weEP+y2uAAUgp/qaPKgDIv4XzBsj1ntuItRn9A6yqP+dlqmu+F2mdAaeyQ9QQZJ7fGUsJ0
	rQ1Wzlsrlg8oa/FoEy+PErnE/v6+muvO2ofi9D4Yp3mGr18C76KnuqOB3ccrq3luoaN0L8
	bsHCc9e+beMTElEmkjCm8MlKnSVn5QY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784948772;
	b=vGTB0zQn9OUPhwVv5/kqVd7bB1+0OcERByFWKOxtOz3CDTYjVaJrraSjJ61AS4YdOS4ZH3
	zIe2BRe5ZoeaYt0c+LQ4eNv+eURV79D0Bze0X8tE8HiQeEkekcjsZnQ3lI1C7R2arDNV5A
	+Lgt92ekWzBbSeBpz+0CmOTGrpTOb/I=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hPezswbX;
	spf=pass (imf26.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10e86e52so65171cf.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784948772; cv=none;
        d=google.com; s=arc-20260327;
        b=Iyha6PpWJJPuKNbFTS5uoMefcWdVjGd0bwt4odcIVMOIetEAnCcmqzOuuDvagdbJgk
         KUzKRlD8/GOqxoTRVRf2jjZYHTf1Hj1R2g76d4krDN/gerfqwoJAQc7DyWqheQFUU7fa
         0T7Dt9FV9ylwboEsgfZ/yx/lHICRSKkZyPK9DlYptQ5zfGl1YlhBNTWbpQB3hVayg29C
         JLA6E1yw5wmZsYS1kB+ts9r0DEyp0NtJn6a6W7GBJNB4f1IQdIWOEEbu4xeSgD3V+Uby
         WNrG0Y18GQfh2MOf7Vnh0DMC5f2OeoBMIpyQKXmRd8Kt8RRm6e/kwmgPgzXdU9V+HfRX
         XbWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XIiMlCPc8Mt7Alei7lSmaxgcI/fmuRXko3LEZs3caok=;
        fh=CsKebz/FiJtYXIa5aG+ZW88TBy7qLdNp6qpjYwl1n7c=;
        b=pVBoN+kDw3fF4mKyBR6UW4PcxgZf+mFB83gS9kk51EwtzWXucKz73c0x4O8MrDyIs7
         xEI/fcPZZA5TbIbRYH0mwOwAp2u3ANUnlaUhQWe/50NbK9kPXy3vVQ2wZSZJLV/InTP2
         BW6ZYFan5mje9/fBGNTi2M+g6HWCUVlKg82bpmNOzSqbvpP4aDTthlC8drzZY05r9m6w
         grsq4PS/rr5YyFjvL3LyvKbtvnOtb2NJnMPtyfK1TQp+I3iCLJvFjsYrESuhCmYcevpP
         AM9QQtXbEazEYYbgqrA+9pODwoiBKENPbFvh5Nogd/tZ2X9Tk17ldDHVuxYlesqZkge/
         2dxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784948772; x=1785553572; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XIiMlCPc8Mt7Alei7lSmaxgcI/fmuRXko3LEZs3caok=;
        b=hPezswbXJftyJUk0MTgLJgYpCE18nLSGe8UsGsblHingDXSwHOQ2kEVfazOfVF+ffs
         yqqVgGYxx/HozlGbrJfM06JBdgLY+CoDcb3Csrcla1V4I4OnqWdSuTGitoZp2erCpCc7
         YVeD/isQU7i8hRLzRVPKOBKIoi+75LwZsOeBagzOACycnEr5l/cLsx2fHKrKAlpnLgMH
         Mi3rZvz6/FXszmwbPbGlbfOJU5NWi4Q4fVGZpHiBzT3ZySSFSqr50DV1AabSRRwM2jrv
         ajOCMseGzTZk82NolYilPSghUTKWcbK1mjKhGjedM2ztI0FizG8iSKy6Qn39bglNV+TG
         H+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784948772; x=1785553572;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XIiMlCPc8Mt7Alei7lSmaxgcI/fmuRXko3LEZs3caok=;
        b=E/RxN1HP9PcGh2ggJH0rC8jkYP60UnBx+OHOgADOpN6grbd0gqEAx+fSD2qquYqtDg
         fDGdRwISJvG5XfXPMTPeKGzdhDus+A5OsFLd5icpw9W1vYT0zx3QYWY8C0aWWrkjHTgk
         wD4GiZC4T9stCx5JZaTH1TyobuamKYT6c06XnwWKq0x1xLRH8dFoEh1n5seZ64stg5g8
         6zbs2gr6pwaexeneEhXMH50w+qQLsoqvnBPTtpNuUvjKLUvwdPDwzCDpUu8Hz5GSIwny
         j850+VU8Fm8/j/t1X5vNKr42a3bT7SJsLbsyxbeQmnXcqbP1BP1yP6KjIqG66rE12/xH
         bRag==
X-Forwarded-Encrypted: i=1; AHgh+RrIVOaap17APlnvkVUFtESXaItQYSfIPMvqPW4XZ0JyHhx2WTWdQQVql96s7d6GNRDF6xxnEvoxcA==@kvack.org
X-Gm-Message-State: AOJu0YxDVLMMx5eVz5zxfabbzBCdzabUBkpcXP+YV11Q+wCiRHLZE6Ye
	D84cqeLJovN4WAGHxN8L8cEH72PvbDCyk69BURUcd491P/sREoZDxFFFKkE50/MtsmUpjgN4BLX
	FI6IYIRxxsJ0CLAe0vLLzIECUDgT8QUl0I9Yte1l4
X-Gm-Gg: AR+sD11LCMdK7g49+F/ol5FFBItFEgGTapKxhG+Fje+feyhwLjS6w34Jgp5wi4ChrN6
	+F+K/oe057UFadrAlIQuic380WCXkV1jCh4WnZ0LQV54NOGb90tCKI7k/vkGhZPr3ATDzcCQ1Fx
	lajSYDpiYyrUl3FsfrO+7MDtCYgE9MJui4ufpKOoeFndzHpLr3zyc0sv5DMZEr9yIzIY0tBT+E7
	EBppt8bPLFQD2DkujUpO6DlJc18+wf0N3lUjmUYSaQbkGhe/QZYUyE9qj8Oj44kmphk6+kNr9HI
	luug5UfJc+XzVmrcmZ8=
X-Received: by 2002:a05:622a:684b:10b0:50f:af60:3496 with SMTP id
 d75a77b69052e-529a755e7cfmr5926321cf.1.1784948771491; Fri, 24 Jul 2026
 20:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <20260705180714.3708947-4-jiaqiyan@google.com>
In-Reply-To: <20260705180714.3708947-4-jiaqiyan@google.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 24 Jul 2026 20:05:57 -0700
X-Gm-Features: AUfX_mygfMIShG1yt5lqpmJZUvrUXftJG9DC9IwiUwtsRAM6fxepq_9WQEtZdSI
Message-ID: <CACw3F52vONdu0jY4YcSLzAQ-esbUWQ5DcrpdJtex_NtKUjqu2A@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] mm/memory-failure: set has_hwpoisoned flags on
 dissolved HugeTLB folio
To: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD022140002
X-Stat-Signature: 1mak8ufzz64m7gc4gfpdbe46dejzhy9q
X-Rspam-User: 
X-HE-Tag: 1784948772-383963
X-HE-Meta: U2FsdGVkX19PlQZzKAspWuIM4uaDgTs35ysDHgSufEykGAEH0RATLOrVm1U+DC5lNezBp3w7uK0nOqbotf7qUm6FtNCrOX2/y8MPfclCAlfGtCpx6nBhM6fGTfYA99JLD6bzl9tH23Lqlu08ylPLKibD+iMKffX82dLnny7QSlolb6LmNtCCuh988AtGu6BwCC0o/AF1XcIXxb+hh4OLuXy5eQxpMV9UbpyGv7U2m1yYfVC1AAXslk3YJQOEAY496KxKeVPJ7yiXOu20w6J1dTJo33BwYhqpHwO42MJ13E9MI81NWnskxJwSW9gqBliydFll2+aP8BoQk4tFN3fHCnz8fATcUufwH0rhAMoOD16O5VKmSefrOJlnFn8gPxsNBEqp7cWNs2wzOybhjKnimmSY9vRwAlwusROP2OvO4ygS58aOOzrHUvvasCu5fT0Xq1NuRhFdUgqRisQAMCNjPC6TN9v/R40QM1EsufCAaEoBtz19V833o99I5Cp6SdixzT6P+lTNlyXg0P1NDJiGGJdbF+NQvwu3K2RoOVuICkszFhnceRzht2uu7y/FJwREq6BJtIoJqM7XuUGJU/MwPR8Wv+jTe/5Cl/zcFy62l9o8mh4Lh444tEUNEMGiZ/s91Ao73rcpHQm92WvGzYeoG9kvLcfF5Z1UhoqHZBpAUUMP/oIBuQySvREsoVgtXXei9DgYsbvKTa/SmnPPncAEpl7wA2jxEL3cW2WnQEA/t4+sQiMZWqRIw4Uyjl7GpqPEMbvoqmiUSsndKhTk9UMlnlFLrukn4ey6Voa3qlXy4b2CN/PfxcQS35pVThkasHP7yQGvemrNiYr0INFY64pjKOTFLuhJzkke8AhrXq9M+UlMbHCquE/kLtw5xqps3qHTZOt+MSySS45dRNqtrlc1T0B3ijcfsyUuR7VPbzM+u1HnCXWIqhjPF71HkIW/rdvAO3TMhGpdnkaTnT5MPTZ
 7ZmZVLnp
 17cFYprRc7WsIt8KLsHTGi7fE9fqa2Q1f3VJCkpKqw94C83sUy10zYJInA0p8kZAJTFb2oXwU+VZ6r6ja14K2VJYaRW2OutuMd3MHanR9MufmKAw706DZMWRiT28xrMYC86B9W63Vo2BHVm2EW2TCkBNMJuoeYk0DktoA8feBj42ZV6TnRmQ+AyoNjVHgilrrJ7tWbS+bfriHsHP8As1y4CclvvGQO+pv1R9ta3VBVVNv4YSdTHDkDVFo2rpWnN97/KH3YYnwQgVb71H7s1wEMVxqMcQVq0b2UZAqY8MK16CODffj2IEzAliuggpIxfRoqtHZbztchCwZFaSQ4iVw98WpiAsAlXr+L8E7P9mpWEbCeicJIY1l5RwC2aGOKxO8x204O4zOZT3ns1F5HaJcWoyyOumH0XMq6fpITvP4jEzFyC7o0VPpZA8nERrjkDwbF43wCvWAeVZLlJSXFHDsqR0EPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 5, 2026 at 11:07=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> When a free HWPoison HugeTLB folio is dissolved, it becomes
> non-HugeTLB and is released to buddy allocator as a high-order
> folio.
>
> Set has_hwpoisoned flags on the high-order folio so that buddy
> allocator can tell that it contains certain HWPoison page(s),
> and can handle it specially with free_has_hwpoisoned().
>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  include/linux/page-flags.h | 2 +-
>  mm/memory-failure.c        | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7a863572adce..3cd524e04a30 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -879,7 +879,7 @@ FOLIO_FLAG_FALSE(partially_mapped)
>
>  #define PG_head_mask ((1UL << PG_head))
>
> -#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAG=
E)
> +#if defined(CONFIG_MEMORY_FAILURE) && (defined(CONFIG_TRANSPARENT_HUGEPA=
GE) || defined(CONFIG_HUGETLB_PAGE))
>  /*
>   * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned i=
n the
>   * compound page.
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 4916ab145325..3d15b4c1b694 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2008,6 +2008,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *fol=
io)
>         if (folio_test_hugetlb_vmemmap_optimized(folio))
>                 return;
>         folio_clear_hwpoison(folio);
> +       folio_set_has_hwpoisoned(folio);

From Sashiko [1]:

> Does setting this flag and relying on free_has_hwpoisoned() to skip the
> poisoned subpages introduce a permanent memory leak if unpoison_memory() =
is
> later called?

> Since the subpages are isolated without using take_page_off_buddy(), they
> are left with a refcount of 0 and without the MAGIC_HWPOISON
> (PageHWPoisonTakenOff) tag.

> If an administrator later runs unpoison_memory() on these pages,
> __get_unpoison_page() checks PageHWPoisonTakenOff() (which is false) and
> evaluates get_page_unless_zero() (which returns 0 because refcount is 0).
> unpoison_memory() observes ghp =3D=3D 0:
> unpoison_memory() {
>    ...
>    ghp =3D get_hwpoison_page(p, MF_UNPOISON);
>    if (!ghp) {
>    ...
>    ret =3D folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
>    } else if (ghp < 0) {
>    ...
> }

> Will this cause unpoison_memory() to clear the poison flag and return suc=
cess
> without ever calling put_page_back_buddy(), permanently leaking the memor=
y?

I believe so, the software-poisoned page will leak.

To prevent that, free_has_hwpoisoned() can just do
SetPageHWPoisonTakenOff() for each page it found HWPoison. That should
be enough in my test, and no need to do take_page_off_buddy().
me_huge_page() will page_ref_inc(). Later during unpoison, ghp will
become -EHWPOISON and page's refcount will be 1 when it is invoked
with put_page_back_buddy().

[1] https://sashiko.dev/#/patchset/20260705180714.3708947-1-jiaqiyan@google=
.com

>         folio_free_raw_hwp(folio, true);
>  }
>
> --
> 2.55.0.rc0.799.gd6f94ed593-goog
>

