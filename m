Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7386B606A6BB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 21:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cRwFHWIY
Received: by kanga.kvack.org (Postfix)
	id 41E8D6B00EF; Fri, 20 Nov 2026 16:49:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF766B05B0; Fri, 20 Nov 2026 16:49:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF536B05B1; Fri, 20 Nov 2026 16:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 033766B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:49:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68463120194
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:49:48 +0000 (UTC)
X-FDA: 85456840056.13.85D279A
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 64D4140004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:49:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cRwFHWIY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795211386;
	b=U/xL3fcKGoqjltqdAILzuZMmCdkquMLrRXLaYIpeWqkLi9ukT99GugncZ64jfWTz7bMHXe
	jdBM7d6DKsz9nBdjTfxovlTCpIRl5en9bCNgXoN9KZO3h9zpHapMbnF2uA36n+7qiiChJz
	NL5MUwNM8bw1L3O+vLMKtpmPOqsT6Ho=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795211386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5uDN/vzQdjrsq85f8uIb4z/yYhd7+ao5rN+lXxRb7E=;
	b=Og136gkQyz5bVxh/gbbTlJk4Hnqz5vL3gh309UTfQL+Eq5fGLDXxbUlbC5xEEdxv9MaAAF
	appisJ/By86PH02z0kgm2EDHBZtab2J5fXNgzEwBpn93SAcP9p41nFfAg+D0R0XIbNwXzK
	v7vO8HYSf0t7ppyPhgB5K66u9ZKoIRM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cRwFHWIY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6ba2a448540so3370a12.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:49:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795211385; cv=none;
        d=google.com; s=arc-20260327;
        b=cXipfqsR9qpK9TZ9BIiD4IpNxaKiyxZrGPoOOEblmefCnmAgUqcu/obXIsLIJWFB1u
         nBPUMA7tJLGYavUwKiP5FfCTb1r2jnmT7vRZp8SC3NtcZabZhkAN+jtpNnaKky9t7egX
         O96PIadhg24TL/WQzbAWhsOhQTtjXdjsmGM2bb04R17NNrqfEceQfF+hj4re6wzuajYS
         G094MCUCYJI8AVnTLXerBvvYsRlLciuhjqTKtazY083NUZGF5SGE0zBGLNTezdVZ7TTE
         yb0LdsLWGMFRYCNr2t4haLHCKDSZ7dLw8lfV5BtXz2mfzpjFYWkoEN+HCsC/e19Ws1wM
         LdUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E5uDN/vzQdjrsq85f8uIb4z/yYhd7+ao5rN+lXxRb7E=;
        fh=kcrxNWFCsh224DZWsZknIZ8HNcZiXL5LGZ/U4ZF2M+E=;
        b=MO9GuOYgW0ftuejHE4Ll4frlLbL0V480J+Rax0SG2/Xjw7sQNXkKi9UJvAKtUDX4gi
         creIKTo/IXEVjGDyjDUB2/7cmPxnlXIb+apdpOlktB/+qCvm9h+fOynTvM1VeMDx2F5j
         V3fe1PcEXJ68aY/U+Al/zU50h1/bRGhqVo4gE0bJgmRwDi0nD86CMoJausYevlywNiTF
         EegwjFnVPd2dVawv492HBEErBnp6z3ZZY+yvlEGAZu1tZvl5CVaT+Fo1Pb8r809fn3EI
         Lq6fdySQVQF12yqlnpdwyvQiD9JP7Lm0WnOtAZBhiHOheLfhL7ctsw8BUlD6P64MotkB
         8fGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795211385; x=1795816185; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E5uDN/vzQdjrsq85f8uIb4z/yYhd7+ao5rN+lXxRb7E=;
        b=cRwFHWIYtk8j0v4HuunkLhw/jCRb7YzKW0e9dxAmyWmVYSBQJPA7dZc6a1BVcqzqSO
         JNY2hDejWSnzxUhe/cVHzcZ39NIaiPu021Gv57p6H2TD4jCNVXSCWPbKb7AB5luG/IMX
         //dtwe0JJf7P/ms2bNXTwhxYOldKPa7/KF4ri01cEdRNNXCfPWaxl3taGmxgzsaSb/33
         lh4qINgm9zP1JAASHjo9FKXAKEUi0tZJ/R7sTdXqKQ2cvItpuJC7KU1bwNHoC867Jfs/
         wuCCit7ypZinLuFOLbB/cSRJ4CkiUEIB/wJGQ/wDvY14sUpU9eCN4ThVa+Cv0/I0LhN7
         sn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795211385; x=1795816185;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E5uDN/vzQdjrsq85f8uIb4z/yYhd7+ao5rN+lXxRb7E=;
        b=YE3aqehKhXGmgKAbZ7xiDNLIbTRQzDztovEXWujB297RzjrgiMGtratHvJ3AIFWdKt
         dEt4YYkRZSUe/pmiF1p2wt0mda489WnJOUzuFbd82xZ/Y91ixGe1fmXBKzN9EnLE2Et0
         JYwBBqvBXVLVTW0zptHZaGguh0RHT7r09vg9DoVoHWV0aRTmJKu5wLYQnYRDCwkPGSrW
         BQnlKXD1GhJTjKbB1RGeep8/24MLFHsTffsZiwboNLw5Z+AZweVfwRXl3+3wc5Yw+wlf
         QQoHg6gUs6FDmFkei/swmD8wmvd/oUyqlpcniEDUw1dEwz3W3sniJY8pGxJySAs+q/4p
         Q7OQ==
X-Forwarded-Encrypted: i=1; AL+hErFV9rQmO4F79M39/VdaxxlM8LV69YTtHjAZ8K/DX2VkfZzLxIj4+sL64+qKniFzqqTe+BVonOBvrA==@kvack.org
X-Gm-Message-State: APuU4Z8zVkTt0i1eNx6VYpVaMNuZ9J7iFiR2aySNyN8Uml3Yu0mNlFGc
	D8313R12GDFMKZ60soIHOO9VULsjfsveiiLOGAgjKNDlluIOrkouT8OONfFOWgl4YXXHTeRIaXc
	Th72deFyY5/GkvC624dSOzWPLTwndR9FYZtYEux+d
X-Gm-Gg: AZFdTZcw1OzmNfrRACzIY1/CGGXj1V2V/4bWQFecRJ5XSpNZemjap+oorVrbqE4F714
	Tj7Trk7qQR0DomatKCPvbUxJPN1/j9SMzGDXhuFtGs0gGBpT2z5GRi3buk3RyyBROF3dwkbuL9A
	3/H6fEp0WC4ZJwJOUaVmEDuZ13YfZHSJwFBRvl24ZPDIhRsuAf1sXye4V8QjlsnSTlQj6qcYwHx
	8HEg0ofc+Vw2evitbIvGhVPBCTe7GY16Y0uFSDhzid4k484u7YOpfywVoI0gpVKB2XIAZK+4RRj
	WjGxfmt2Vh08LEvwupuTNl5vAFr/37NAiNeaKeYggkTxTzAXZE4KQWTBM6iI8dMiZCW5e5HB0DZ
	Ag4AaV46HLqBFLewNmoEoWMBrPozDA67NGdH86sOdewf5jaLO4sY5GpfnEPvJkYfO/yITLkNcTz
	zRObqllg2qbwgJZsWeESOezme2Ga8OzxKifgk++uKlT7JgPA==
X-Received: by 2002:a05:6402:1ed6:b0:6b1:c6fc:aba0 with SMTP id
 4fb4d7f45d1cf-6ba6edb6b8dmr7974a12.7.1795211384379; Fri, 20 Nov 2026 13:49:44
 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-3-hao.ge@linux.dev>
 <CAJuCfpHOZS6mp_no3wKmU3-S4HKspnbriUw8Mwtxf3nmw0-pfw@mail.gmail.com>
In-Reply-To: <CAJuCfpHOZS6mp_no3wKmU3-S4HKspnbriUw8Mwtxf3nmw0-pfw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 20 Nov 2026 21:49:31 +0000
X-Gm-Features: Aa3M54qncu_g5WX6d_gqnAW-RhgHGus495VL2_o1wphopDeOUeDevYVBGMQXiF4
Message-ID: <CAJuCfpFv=sCeib+SDWJNW6oqbNnhT+m3YjnfKh8jNkquzuYORg@mail.gmail.com>
Subject: Re: [PATCH v5 02/11] mm/kmsan: undo the shadow mapping when the
 origin mapping fails
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 64D4140004
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: xfw5qrmzbcy4p8p3ikd8eaukabmjoy5e
X-Rspam-User:
X-HE-Tag: 1795211386-140959
X-HE-Meta: U2FsdGVkX19lEiyZHwBhA1plZ+X0e8lybBDGUgRj+JZgDSnbg4CYb3uMnekBxMXOhllkqgJYAuTWTQSFOUUd4eQqvN6JkTW9C5Vjdar05S/YMe701ZYIG/01EqsxSrB2nVlx6DjQYTjYZvq9LzB01D1Z2qyKgJtwLGf+H056oirnrp418he9gaVxDdrH5XO/SzXmcT2j3dDlQGsbaDEUNH1hKrdQkd6VyeBOKGN+5+pCBlS4ljoyIe5h2U92dLl+TAtMXD2uWB36hZVQ2wxhh75sSKp1qu/HbTtsO88fZflDQV3LMOZ1Hgi8+mSSwHtv1VNu5dam+OUNAFWOH+MOwisordnfAHJiMFbzfQfiKR6sZGdYZjXIDqq7iJwcqt7wpKwWLSo+y4sJCkVAEUYtspavRV/rFQWncuzB4Tyoz0m0+eodPKWxONpvPY/rfRu25X79BD4KBmKeFnMmvdXGIQEa+9t7O1HudQ0XhZHN/D6CRB2weFWFWdbo3mFGfYk/vMJ6G0aZFVoR59GjSj+Dl5BfQk8ijINpOsJtpM8jOWfb44EyQd1yEFRrc4IN732tuBNnqIOAg0VoTFy+e2KzSqx1oCrLV2puo4AcgQ1QB75Z2xJZt99p74mqPHvb+1afGS+lFx0v964FX9RljHbEL3aziFfdm81PfN7rZnjAtEtp7sbGPVE6kPBrIVWP6sB0SGGpCudDcxjUp1Y5jn/siVDxgfyuMAT5vU5ES9l+/DMSK/vt8IiCo4Vw+5qjy8tUQEUvxBhmAPxvz+xTb3WVQqstym5Re8jvLrjz/Rr6lhGyyrxSWMb0FK+hNdhCndvY+9AdNfN09Keq8mKVJZvGf1dXxE7QozMiaj9u5jPfg50IdLG+8NFAuUI0WimlGch4SPZ8TiO+Znpz6Ghs/V8W15UVZZqhfCPLIwrXdtVB0wpLd5QRNOayhQtzsWeHGZXXFugq/SCefYxM+rpc0qC
 RwYudea1
 Gq+CKQpuRYqZl3yzeh1Ie4A09H2c2DsycT58mjGUF+iY+kV8bDfW7I9LqTfuofbNH/XMSwDFZ4nHsEh/K19ty+GurD8pEYoxeE8Z7q34gV6ott/OOy9yjAdBogXrt35OpmT1gVil/tFD5BoenOjx37HfefboR3FsnjKgttcmQE2uBYWJqspgizrtoqwjxTGI5ESKe3TZZla3WutXggt3OOx1dVRxR11w6hflkKnJSZ7XC6deKlf+hp+rsxtX8xE5JUm/emcFrE3XYUU8zYCwnMUOe1vb+PIl/v4xxzx0fFapWaC7HO+RZty/DgD7NZ6DFPrrlmDQdfrbtN335/BrTUw+okJS3UwkegG4nwWc8oqVjvcDLcO3nLHKmapxzR4Zat7HAF4e7shrEdQwPBA2NBu1n3ekGgfBtlzDRaHOMFeNM85R8hKodv51VKaLn0EtIwCXs3FhA98mxYTmYC8EbjTv/vjOkaCoIDDcMFs8HRvJo5K04Ebbzeoii7x+dBM2gCgInSiiGDCZqi6K5ulZzx29oIwX07pYzuLCxYL6ddU4oEXh+hgfxjLKzZl0sc5ejvjKHRxyenV0D8GFaPuDgK3kZn58n6eImgimgSRDgvSgrLWEMtPkfDlDvSzQ+n7Pf8XYGklONxI19j8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 9:14=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Nov 16, 2026 at 7:13=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
> > the origin pages. If the second mapping fails, the first one is left
> > mapped, and the callers do not roll it back. The next vmap of the
> > same metadata range hits the stale PTEs again and fails with a
> > WARN_ON() and -EBUSY in vmap_pages_pte_range().
> >
> > Undo the shadow mapping on that error path, the same way
> > kmsan_ioremap_page_range() cleans up after a partial failure.
> > __vunmap_range_noflush() only clears the PTEs; nothing has touched
> > the shadow mapping, so no TLB flush is needed.

After a second thought, kmsan_ioremap_page_range() does not skip TLB
flushing. __vunmap_range_noflush() comment at
https://elixir.bootlin.com/linux/v7.4-rc1/source/mm/vmalloc.c#L497
says:

The caller is responsible for calling flush_cache_vmap() before
calling this function, and flush_tlb_kernel_range after it has
returned successfully ...". There are no mentions of guarantees that
mapped PTEs require explicit access to be cached. Please double-check
if this is safe.

> >
> > Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pa=
ges_range_noflush()")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> > ---
> >  mm/kmsan/shadow.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> > index 0c88d89bf0d6..212449db34a1 100644
> > --- a/mm/kmsan/shadow.c
> > +++ b/mm/kmsan/shadow.c
> > @@ -258,6 +258,11 @@ int kmsan_vmap_pages_range_noflush(unsigned long s=
tart, unsigned long end,
> >                                             o_pages, page_shift);
> >         kmsan_leave_runtime();
> >         if (mapped) {
> > +               /* Undo the shadow mapping set up above. */
> > +               kmsan_enter_runtime();
> > +               __vunmap_range_noflush(shadow_start, shadow_end,
> > +                                      gfpflags_allow_blocking(gfp_mask=
));
> > +               kmsan_leave_runtime();
> >                 err =3D mapped;
> >                 goto ret;
> >         }
> > --
> > 2.25.1
> >

