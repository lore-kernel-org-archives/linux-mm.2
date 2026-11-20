Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAE2606A680
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 21:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NiEEzUXV
Received: by kanga.kvack.org (Postfix)
	id 26EC86B00EF; Fri, 20 Nov 2026 16:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246DD6B05B0; Fri, 20 Nov 2026 16:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F956B05B1; Fri, 20 Nov 2026 16:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB9B76B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:07:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BCECA6EF2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:07:31 +0000 (UTC)
X-FDA: 85456733502.06.CB3F2D8
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 46729100003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:07:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NiEEzUXV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795208849;
	b=hu5HPQxg1BPC00m7GkPYz2jvU9U3nBrERI9lZ82q+cZGM1hr8E60w0JRthi+9XC+P4IJlf
	OSBQasd4dmpYZ55Lmv4ZJyvTyUzgIS8ZsewgGjJxUuKHqDvefCdtcSBUmBZnEyKIt5xKkb
	4inoHuEuvYzNCliKkXfkj1KkNZsd4h0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795208849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23FU4s0qSHIWACezHPWGWY27dHdjz6IS0tWZIdmWGk4=;
	b=0DPqZkV2p65yRaJDg9W3BdTx19rSo+6LdrWv9sJTnTQZTYU9DrKlMWG2HWO7D6+IlbuQJY
	QUTmqi76Rzpiily/a5nglhoLOtEnEhs4DnyR1VMYxZAKZWLq8tOYjno0WuOw1endTQsxbr
	w2Ulm+rkoDcn1zQTfY6PSFJE0QtscYU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NiEEzUXV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-54492d8a988so73431cf.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:07:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795208848; cv=none;
        d=google.com; s=arc-20260327;
        b=Aq1JrIQ6OhQP74F/VBYNzXkzfXq8sDlyv4MSzxbKVwVj4OoSBmHF4sA9xRM723daD3
         J8TcLOTkIMEC6o9W5IFrgRNX5TUXTDyetxzFC11gqRPe/xA/+A+eK3Gq9jDUNrx5Oy7k
         V3VekcU1tInbe3f1W3aupqGSVt3U+vKcwxLt72Dc+IgHe2VEueOt/MH8fik9DKfGw2TI
         BIFrGCJCETGAecfax6YUPc+yaDEVsApAGVKlxnaPmgmPHPF2cEQgwD3FNaZzLaEJCCiz
         IwdL3UZrLksShEx+rbBowSmDKgJKXXcbYt1JQwu3ZKuC5w4F0yyvWW7l21jQVPQ7l+jD
         cQew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=23FU4s0qSHIWACezHPWGWY27dHdjz6IS0tWZIdmWGk4=;
        fh=4ufb9acvgA8SSoiv7dBc0SGG6s3gFUHE06qzPgM0XwQ=;
        b=n8/rQnDN+rYOhfusgK3KaayTYJvsdUtUSGInoLvSoOQ08z8oABV2FAK96fbHQLaxkS
         JBbU+HpheL+mT5EArgkXm8rS8F7YIOQw1/JrSedd/nTeGTn9Ge3J7VwOxIl05lYW8kMC
         uIzualJaVGPoklZCYW7hyNzcDxI0sirlqtHjVOGVW4zFZcHFy0TuJGTGNhZPb+9nlXJT
         oGnkVeuUXtOrkzpcov1cfEXPqa4MvZjeRtEXDrCxUk+es0fWdxK8Oi8J7M1DuYB2qPng
         b2wuIuofwTiW9GQEqhq+RoxEsyM72OqVsft9GS/nHizRQnvgcZmJWNFO/2Vap71t2+Ec
         qQcQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795208848; x=1795813648; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=23FU4s0qSHIWACezHPWGWY27dHdjz6IS0tWZIdmWGk4=;
        b=NiEEzUXVBEetaR32pjwBifHpGQTaTqcQMF5t4biGeDh054r3GBe35W+9+nHmdet5n4
         xEZB4ZVt9F9bhLBCgSfxJa8JAg8nz/fj/hMUxr+coHfJ9dWeQ0+QVjd5B6Wzgp19mizu
         qEA4gqYYub/NIOdtZU9jhME6x2UIxIM6SIYAnAuvNqu/qwUwGej2QzO0nNj/ONrV0E28
         mfZDGudKERMXEXCu1OUW4TDyEDpqGe6KDygmgso6cIKADTe/jjCeH/WbP7Pc+TDBSIer
         2vEIiRiVLOaUnt+qst3pgcMo5fQf3mwPrvOBYm/Fp9XsOqHGWuTG8xMpzygI8feExcu9
         D57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795208848; x=1795813648;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=23FU4s0qSHIWACezHPWGWY27dHdjz6IS0tWZIdmWGk4=;
        b=BPl+WqDRIAkTOs21KJejEx7iQfGdDBcr8KeRcerzdWnEr24i8mrLb7zucZCZrsFTqt
         RMyahMs0XYJ7Jjob3k7fP/KmriBVPEHwtJfucxxBr1wGzMmxU/xeMcIe42xKAIARSKHz
         alRdKdCh7THtFCrcGwydMDoO6nkOYR6tqXTxoKzE6GZNILcRg/dUyQQf63yWT/iRib9n
         VtEg5dnUalNPcskzYm4zKjjt2hWjdSo5fTwwGNaLTeIch+N378UGc1zUwWR1E/Y/1/I/
         TNrjcKE0sMO/LJXNZeJntfwOG8FnfjtouEuDTXEz29JP75aZtbujlY+tWliHB+t6iMwq
         I1FA==
X-Forwarded-Encrypted: i=1; AL+hErEuqX6g5xkwV7p2UiWO4gnA3M7njHB4Yk53JahC0FEwGQ+RcwKC41vGHQsEH91FacVqW7QJzaTV0g==@kvack.org
X-Gm-Message-State: APuU4Z8Zo7hJODj2j1Vgh3+l7dR5InLP3PVfj6SdMxdsM/TKjFWji3Ol
	v5tz8IMYY5B8pSDyjY1XiEZzBAv3jxsdIfTfPwfqAvdDhwj8XqKUFT6M23FQ0GL/YRI+tllTL3E
	8AHoWds3q0vqZ/t+SUyTQMAAJZ2WbfH5bqpmViAWz
X-Gm-Gg: AYBFou1ZrEzWm3yQiViD4AujgAUPZ7J+gAzyDsq2AVlz29+sAXxcEfdNtwvwY4PsDCY
	J4p581kQwnwvN7dsEaWBKCzxWgDfpQBgdCh5NiXfMGZ1JhLOsuii+N4ewjmtGY/dAV67NWE83AV
	v8DvI1APcnuaNqgzDIDjf7khTfM5zBTMg1qh85Jposoke1cyJdyBI6dG8zduzJ+KYhfQ33GNOVR
	xTt61w+w2F25XH4xgqvI6Dmozj0ofyG5sf50L+UnWl4kuOCCIxvv7oTag8HL4sC5ZmQLilYeN68
	O9mJMkMkSJ6Ct86vZ/CovxXLOeccf3gmAsA9o9M/y6/2XFoeh5JcZFAGrXJtYL3u3e0vy7Jris5
	zD/+GOp9wT+yKPsyngqmLMnh3vUY3Hs2umVMwVsS7MBpuclYcuWYtSC/Mx/BtgaDaw+7cNTF/wU
	ITM4mJODELoBv0WSeGt2vZENLCsYHloUCG1nRNHmBqoiIeYg==
X-Received: by 2002:a05:622a:c15:b0:530:e335:4ef with SMTP id
 d75a77b69052e-55d88014944mr3653311cf.2.1795208847503; Fri, 20 Nov 2026
 13:07:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-2-hao.ge@linux.dev>
 <1020e36e-83bb-407b-8a6b-7669f04c26c3@arm.com>
In-Reply-To: <1020e36e-83bb-407b-8a6b-7669f04c26c3@arm.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 20 Nov 2026 21:07:15 +0000
X-Gm-Features: Aa3M54oHBR0Q2Es3gvoLgXXE93aLU88piHn6n8RQiRkJo_c2VMPM-YJNeTPQZo8
Message-ID: <CAJuCfpHtWJvs4F2L+QCMe9gMJ-qmcj4Q1G4hqVqFe6Z6gPoQ1Q@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm/vmalloc: skip cond_resched() in the vmap
 unmap paths when atomic
To: Dev Jain <dev.jain@arm.com>
Cc: Hao Ge <hao.ge@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 46729100003
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: acje6pknckp9ykumngtmm7ochr6111ej
X-HE-Tag: 1795208849-758329
X-HE-Meta: U2FsdGVkX18egBBcYf/TRXq5z/hnEAOXGxKcu3P6NqTqvQBnQbLqK+UdGov/zrCq2Yh9CBawavOrGUlYa6xifvVyhcKIft3bUaaywgvHeMu/30o1ibfbmXexeKBFbPLjaeWJ+K3pBq46WAhjzvw5r3sSoCyfMplFGsd2PdlCuhnCB07xgmT9wssY9oeJfFqEkWAJjiIU5RAOll4L1ZAJveTZL8qHWKQTmKBS/I0p0quqBYR0LgFUaUM4q0ZT/ewh/VdTVfM1BkBGKZKWep/7inO1uckrb4A4XMogES/ERzOIz/oilfF+kcZEq3AXJ3gtwNtJVhy9Y5jP3Bkn3Uvz1McIEVcyagDqbj1LteuiD0C3xQlP3TUo3oG6TESCUtlt8GieIbCvQ98HAtsvSHSXk3GVCV9PxMHUYWNLjucACHhk4+wk4itUhRQUxoci+jn+rSlJjEzlW2LhtLZ8xsVVAkvFd2VlioOAh4LD5EV1RtAxErY1446kxIk0l57ITY7yW3NmxFm1C/Fl+rOoS4eDsFVcY5QZUyEx49J5ZiDhZK0CDUHyI0iL05HaSJ7O4g24SFFSuOPwgU0uDbeaINdBWi9WxWuMegdw8ki2JuKe4CnTNDXQ5deJHcNCXhgtmBF7nYaPfWO5UxqIrEAUC8tIqUbtwdOKd0f7cxjllwhEteqdydBded2ir71ZT8IdSTlpgKZ54CCgEG7C9BJK5hxpNT1D8CumQcMJD5vhW0DLoamEkq/UuGZQYxq6O/1gSEMqy16pHyj/i6vDSI2ovLN9+Ve27HD4mKjUJHvwn2aF7WDsHjI790woMTbst53+qpuLzcEVuc7bYglFgtDAW42ZnKVAy+CBbcc87dLHqpB78Lv0jbbfxswvugxARoKalV5WPyKlZgp9ivm/gPreMoRD7X/bZaTGogxj+RU0YwzcbNMIMIwXTlKjPEeyF7MN1aLxpuhnDyuUeZuHIyS3tR9
 taQVVFtM
 +KAZ3Q+4ve0TgUZke+v1ptrXeRHqo+0B2IyPPMSfuw7j+FqVCdwj5HCZNFEIv6lIqQIoIUdganBZP/tC2j9tYSPx7H4lJm8DARyq7DfttbCf3NHV0QUZ67ddS+dxrjm/bPS8X7K1lbz0dQ86rm3A/UmcZsVkSGA9jLoNSK8OK6g2w0VCahcNy6SURWH24WH3skRK/8xQBnPLGYbncU9RSib9s5zy1GlkjXd5NgoX0oxH8ohnn4omB6TqiNjkTAWT5yoEJptssRVhl05goRQpb/cNV6D9Z28ZVcJ4LfGemTJfDF4yb6oH2E2Em6MVlXY5UFrPp7ECHxVl3GMQRf8zYcFryr/6TKFQaOQzBXA9EAnE4/KNixybYUB+n2MuQ9uPUNIo90d6FXzbnE2BgyMHz5WOULLuME4tZIGA697Yh6xkn5/ODrDNAoWOOTLaA+RoSOwLvOA+n4ttcr03d4HswqnNAOztbqt2XhzFeYvErUjY+LYTsFumsLP6Y3LTr/nQLyE/mIZAhHMVDZGIUOkvypycMtF5tGZ0Vp17Q/Ug0VO4dmuk1HJ6uI1HSlDtdS/SgZMXMYPaidfs0i/H8Hw9EjXum3/VMsmycvdPHV119EAeVxq8cPtHRn85Y7pWUgB7y7Q4QO1IDeIy50i+epxclzk5tRvF9L6ONqGu2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:02=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 16/11/26 12:43 pm, Hao Ge wrote:
> > The vmap failure paths can be reached with GFP_ATOMIC or GFP_NOWAIT
> > since commit b186a94227b7 ("kmsan: remove hard-coded GFP_KERNEL
> > flags") and commit 8da89ba18ed4 ("mm/vmalloc: handle non-blocking
> > GFP in __vmalloc_area_node()"), so an undo of a partially installed
>
> You mention this commit too, implying that vunmap_range_noflush() can
> be called in atomic context right now, but in this patch in
> vunmap_range_noflush() you pass 'true' unconditionally to
> __vunmap_range_noflush()?
>
> Can you give me the call chain existing in current kernel which makes
> this bug trigger? In case it does not exist but is only triggered when
> you add the rollback code later, then this patch is not fixing a bug.

Yeah, IIUC this is a prep patch for later changes and does not fix any
existing issues, therefore should not have any Fixes tags and should
not be CC'ed to stable.

Other than that LGTM.

>
>
> > mapping may have to run in atomic context, where the cond_resched()
> > in vunmap_pmd_range() cannot schedule.
> >
> > Give __vunmap_range_noflush() and kmsan_vunmap_range_noflush() a
> > can_resched argument and skip the cond_resched() when it is false.
> > The existing callers are on sleepable paths and pass true, so nothing
> > changes for them.
> >
> > Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pa=
ges_range_noflush()")
> > Cc: stable@vger.kernel.org
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  include/linux/kmsan.h |  8 ++++++--
> >  mm/kmsan/hooks.c      | 14 +++++++++-----
> >  mm/vmalloc.c          | 24 ++++++++++++++----------
> >  mm/vmalloc.h          |  3 ++-
> >  4 files changed, 31 insertions(+), 18 deletions(-)
> >
> > diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
> > index 7da9fd506b39..0016c032d1e7 100644
> > --- a/include/linux/kmsan.h
> > +++ b/include/linux/kmsan.h
> > @@ -150,11 +150,14 @@ int __must_check kmsan_vmap_pages_range_noflush(u=
nsigned long start,
> >   * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
> >   * @start: start of vunmapped range.
> >   * @end:   end of vunmapped range.
> > + * @can_resched: whether the unmap walk may call cond_resched(); pass
> > + * false from atomic context.
> >   *
> >   * KMSAN unmaps the contiguous metadata ranges created by
> >   * kmsan_map_kernel_range_noflush().
> >   */
> > -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end=
);
> > +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end=
,
> > +                             bool can_resched);
> >
> >  /**
> >   * kmsan_ioremap_page_range() - Notify KMSAN about a ioremap_page_rang=
e() call.
> > @@ -355,7 +358,8 @@ static inline int __must_check kmsan_vmap_pages_ran=
ge_noflush(
> >  }
> >
> >  static inline void kmsan_vunmap_range_noflush(unsigned long start,
> > -                                           unsigned long end)
> > +                                           unsigned long end,
> > +                                           bool can_resched)
> >  {
> >  }
> >
> > diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> > index a706666db097..69008b085658 100644
> > --- a/mm/kmsan/hooks.c
> > +++ b/mm/kmsan/hooks.c
> > @@ -136,10 +136,13 @@ static unsigned long vmalloc_origin(unsigned long=
 addr)
> >                                                KMSAN_META_ORIGIN);
> >  }
> >
> > -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end=
)
> > +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end=
,
> > +                             bool can_resched)
> >  {
> > -     __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end)=
);
> > -     __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end)=
);
> > +     __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end)=
,
> > +                            can_resched);
> > +     __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end)=
,
> > +                            can_resched);
> >       flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
> >       flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
> >  }
> > @@ -168,8 +171,9 @@ static void kmsan_iounmap_pages(unsigned long start=
, unsigned long end)
> >               if (origin)
> >                       __free_pages(origin, KMSAN_IOREMAP_META_ORDER);
> >       }
> > -     __vunmap_range_noflush(shadow_start, shadow_end);
> > -     __vunmap_range_noflush(origin_start, origin_end);
> > +     /* ioremap metadata mappings are always GFP_KERNEL, so resched is=
 safe. */
> > +     __vunmap_range_noflush(shadow_start, shadow_end, true);
> > +     __vunmap_range_noflush(origin_start, origin_end, true);
> >       flush_tlb_kernel_range(shadow_start, shadow_end);
> >       flush_tlb_kernel_range(origin_start, origin_end);
> >  }
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index ccaf158c5b7f..3c0d9e69b886 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -429,7 +429,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned l=
ong addr, unsigned long end,
> >  }
> >
> >  static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned =
long end,
> > -                          pgtbl_mod_mask *mask)
> > +                          pgtbl_mod_mask *mask, bool can_resched)
> >  {
> >       pmd_t *pmd;
> >       unsigned long next;
> > @@ -451,12 +451,14 @@ static void vunmap_pmd_range(pud_t *pud, unsigned=
 long addr, unsigned long end,
> >                       continue;
> >               vunmap_pte_range(pmd, addr, next, mask);
> >
> > -             cond_resched();
> > +             /* The undo path may run in atomic context. */
> > +             if (can_resched)
> > +                     cond_resched();
> >       } while (pmd++, addr =3D next, addr !=3D end);
> >  }
> >
> >  static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned =
long end,
> > -                          pgtbl_mod_mask *mask)
> > +                          pgtbl_mod_mask *mask, bool can_resched)
> >  {
> >       pud_t *pud;
> >       unsigned long next;
> > @@ -476,12 +478,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned=
 long addr, unsigned long end,
> >               }
> >               if (pud_none_or_clear_bad(pud))
> >                       continue;
> > -             vunmap_pmd_range(pud, addr, next, mask);
> > +             vunmap_pmd_range(pud, addr, next, mask, can_resched);
> >       } while (pud++, addr =3D next, addr !=3D end);
> >  }
> >
> >  static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned =
long end,
> > -                          pgtbl_mod_mask *mask)
> > +                          pgtbl_mod_mask *mask, bool can_resched)
> >  {
> >       p4d_t *p4d;
> >       unsigned long next;
> > @@ -496,7 +498,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned l=
ong addr, unsigned long end,
> >
> >               if (p4d_none_or_clear_bad(p4d))
> >                       continue;
> > -             vunmap_pud_range(p4d, addr, next, mask);
> > +             vunmap_pud_range(p4d, addr, next, mask, can_resched);
> >       } while (p4d++, addr =3D next, addr !=3D end);
> >  }
> >
> > @@ -512,7 +514,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned l=
ong addr, unsigned long end,
> >   *
> >   * This is an internal function only. Do not use outside mm/.
> >   */
> > -void __vunmap_range_noflush(unsigned long start, unsigned long end)
> > +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> > +                         bool can_resched)
> >  {
> >       unsigned long next;
> >       pgd_t *pgd;
> > @@ -527,7 +530,7 @@ void __vunmap_range_noflush(unsigned long start, un=
signed long end)
> >                       mask |=3D PGTBL_PGD_MODIFIED;
> >               if (pgd_none_or_clear_bad(pgd))
> >                       continue;
> > -             vunmap_p4d_range(pgd, addr, next, &mask);
> > +             vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
> >       } while (pgd++, addr =3D next, addr !=3D end);
> >
> >       if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> > @@ -536,8 +539,9 @@ void __vunmap_range_noflush(unsigned long start, un=
signed long end)
> >
> >  void vunmap_range_noflush(unsigned long start, unsigned long end)
> >  {
> > -     kmsan_vunmap_range_noflush(start, end);
> > -     __vunmap_range_noflush(start, end);
> > +     /* The unmap paths are sleepable, keep the resched point. */
> > +     kmsan_vunmap_range_noflush(start, end, true);
> > +     __vunmap_range_noflush(start, end, true);
> >  }
> >
> >  /**
> > diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> > index d8372a4f65c4..4ec114a75f04 100644
> > --- a/mm/vmalloc.h
> > +++ b/mm/vmalloc.h
> > @@ -44,6 +44,7 @@ int __must_check __vmap_pages_range_noflush(unsigned =
long addr,
> >
> >  void vunmap_range_noflush(unsigned long start, unsigned long end);
> >
> > -void __vunmap_range_noflush(unsigned long start, unsigned long end);
> > +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> > +                         bool can_resched);
> >
> >  #endif /* __MM_VMALLOC_H */
>

