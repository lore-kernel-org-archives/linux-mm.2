Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB711C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6716B007B; Mon,  3 Aug 2026 13:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F346B0088; Mon,  3 Aug 2026 13:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736BF6B0093; Mon,  3 Aug 2026 13:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 377296B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:51:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA3F480799
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:51:39 +0000 (UTC)
X-FDA: 85060700718.09.E26E2CD
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id D0BA01A0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:51:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i68A3XXp;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785779497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gN9PGDfMfb8sN7B1AJaJ+0FbizOuTl6vkuEoW4uKhkM=;
	b=2ltmHbP2sxdGJu7w10LIBnfu0Q8eHJbHXEk6H9CxuVHSv+oDyh5zlkmxsjXm3FdeXgXUUP
	dYubXYjZwAsPbnImWHTYmqTTzBmrGjRqQN4pI0TfC2Zxr9KXg17MDn9fEE662J1kcmK0I3
	JvFySMPj0MryApHqsvHOJLFRqRThbDc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i68A3XXp;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785779497;
	b=TT8GvpsCj7/i++ODEl9w9AQsjwCSK0/NBxiTyjC7E3RrB2X2QUMthZoKt3YTsvSxIdeJz4
	5clYbJyisSO9VoZ9mTdsSfJ/Q5y+BHdp/d+U+k60jdrnb3FDQm+sFqY8tL7/4zfBjLX4xA
	75UCjRs/+youAPdn1099i+UBR3DF/Bw=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c01c79467so23911cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 10:51:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785779497; cv=none;
        d=google.com; s=arc-20260327;
        b=cw7xF9bI2CCFfT7qaoNh2utCpF5bYhttTk2vIIgGYCXxxL0Fr6rEqogr7flSmhneM2
         tAAfA4t2+f8iYxeyaz9a7UCn1hwwSA6ZpxwTGD0+n4N1tgZGfP34GQQ7j0AWEum6hfQ+
         dfEm060PwRHzceQRLgFpc/zBGJsuPrpnWCgvAtSmoDH2IrIxq1qIb5nE9D0EoqNUM3N/
         l7c2YuACUFGB3coMoh6y9GlEgLNt3EIMgbJjCVDjunk8bkNi6Zo2h5WKuXXyl3DqcaFw
         v0x8SjwpA8lXzvbX33TWj1pjE1R32E2eaSWldfNTF0UvIZHKlgSppwc26UT6dnROyTsU
         jA4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gN9PGDfMfb8sN7B1AJaJ+0FbizOuTl6vkuEoW4uKhkM=;
        fh=h39OEL6YakaLOap4nQrOCPstzlizGA4+/NkHaICVMGQ=;
        b=GaxD0AJ8gsCZt13PNVbBFl2S19vsA4rLqnGSJ9nU9J26FIc95Ygvrr2e8sciSr7XTA
         ce6Uoe38Z2Uabr3eIf1Gw3QGYOE0IDgJiRswjHAexIRhPMuUe3GN9Qd9ieInXQ1P+JaS
         qhhzlrkHPsdO4s/BLrTVPdlo8RxQ5CID/Em9ecVVfHHt68XkJLgBF8jBFvxH2tiqDHwL
         o1QFfPErI6C3w5GzAvhNcIRHjl/6LUxFtZKg+FJ3KjNlR8/86hxeewtThphMjJWF3sfs
         HgcacVSX8k62nByROB2RBYzR5uyE7rLzz3f4TdB23EiSik5toMyWaZbAV5z/V4cj3+FN
         pw9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785779497; x=1786384297; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gN9PGDfMfb8sN7B1AJaJ+0FbizOuTl6vkuEoW4uKhkM=;
        b=i68A3XXp0eQGwagEviUc1Sm3jMw3HFLBO/txVURmjgLAiqKMV/15mky+bNpdX8XPps
         xe+yXyNHFfawjBUHDYyHKlB3pRT+C+l04KfH0Zd5sNDUC8BTCnVd64NAyKSZNOZfiZhb
         hE1+wyuWvS+WnCa5/ViTvE2UAJmUZDRsMQZvgaQyB0eIa4kcZaOpdj9i6zQsYifsKAaT
         FkDgxD+MYwVlzTUasAC+YQxRiz/S6jJhDPdGsdeMGqC3TWeRHxMuPEpRoQP2jEVdhn4p
         ecRI5l1t37jKi4ki2LR8ZPoubA0mAaXxXrl3WydcrcE0hfX0MUZuZnmy93H14GSvrvlW
         YkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785779497; x=1786384297;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gN9PGDfMfb8sN7B1AJaJ+0FbizOuTl6vkuEoW4uKhkM=;
        b=hwEKNg/CeLEIiHHynT/0C9mPSud95mpFQq4hn80S/m5isIOCPCuuvmDK5oIGD+wO0g
         1if6rtqfpoafXNMIku/UIZVrSHdlOXGTrZtbX+uzF7HRQSGC6sLJGFEyx/OeOZSDTvNr
         MmBwfoYTjGhvFgxCTn9Z9hjrRdIK8SySvr0rlZ0Gj1HavTZsAw4NSbuGBsVH+JNhdEe2
         hlYsTPkyZb47GsnakectLLEkaSERk1wcbTQP3XEAw6vqrcCv5NvhYh1+Adf9csH+xImh
         a9+QOD589ZDGPZcPCSTbvQCF346KQHeS2wZt7O5ajDljBiDmNjq6CbjxsmfA5Hz1T+XW
         ACqg==
X-Forwarded-Encrypted: i=1; AHgh+RrB9UhFAAVPikitnO3TshQa3cVgRI+uO0/KVihF837mO1jr+Qv8k/31g544eKB9yPrnjmM0GHYG8Q==@kvack.org
X-Gm-Message-State: AOJu0YzGLQjdPkBxByflYv0FAOFgxRYpL5/WiDXIuFCbVSBd6Rl+vK05
	9RC2mct0jfljFwNTRR1dXoKbXkg6uZWCoXKvK09Qagm4hT7Il1POBNrv4cCN6FQTkwdW/QtgjTF
	VFa96zQb0ZQKvfB/uNEGYlgvmVBGrEfsviQr5/tAY
X-Gm-Gg: AR+sD13kRsfNVCDxTTuXoQKQyCXwLYwQoiWlEn27a2dT2TeyDiSrsQ84GQIPzij7Vx2
	ms8ParLYzinxMIvgkxpJqTSihUmrK8ZD5T9OrkvCrEkNg2qToFW3Iep32xW54Yd2iR9/BsebeqV
	ct2n9F5/lcjLZDeyvzftPSbF2opyMiyBwQThZGygA6rDQpRsQfZaAlizVe9a7BZ8AF5GdYiS8+H
	0WT9lkrmP6bxFtSUOX9CsCR0AE7sXWO5p48taS85JfWIN7PEI+GIqUsf2HDY/fBd5S4iXwp01kK
	kn37opOpRkvsd5FQFR0h189YVZf6L2dTUOUzaN+uTvGiNDVVOG8Vkw==
X-Received: by 2002:ac8:59d2:0:b0:52c:d3a1:358e with SMTP id
 d75a77b69052e-52cd501c9e2mr508011cf.18.1785779496122; Mon, 03 Aug 2026
 10:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <CAGsJ_4wXGf90BMoJp3_z8G4fMTAgED88RXvbp6C4Gf+iy_2nvg@mail.gmail.com>
In-Reply-To: <CAGsJ_4wXGf90BMoJp3_z8G4fMTAgED88RXvbp6C4Gf+iy_2nvg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 10:51:25 -0700
X-Gm-Features: AUfX_myBHnqbqUHzxMRv2lr_uMcuDR54YU5uhLBh_mtvAIUn3WoWtjNwKbef5Os
Message-ID: <CAJuCfpEF6SjKhRW33AuboAuUbQz5zv+QKr2eD=52Qd_POL18Kg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] mm: Unconditional per-VMA locks and cleanups
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0BA01A0007
X-Stat-Signature: zt7n1q7bjfaaqditz58yekywp54ssmhd
X-HE-Tag: 1785779497-360539
X-HE-Meta: U2FsdGVkX19OwLmFSiYPJU4FRPSmFjDC3PervUk7EPLp0ZwXzv5zRE7rKvnuJ84EsvNazp08kP+TA2LSilYVaiPegreivfiLHqELA90Vf58aznIKSWdZcWOoXuDvonQOL8pnMJaQIDyQPjeA6jmcdYBVdCZz/7T5AXuZP+kjZo053D/9jyebndEtdlkqW52wEr6f9G0qLluNDE6ePzdpTM2ByabdMlTQ6H4VpOtJyhVccJROIvxbMf+tvhmT/ONamOUopTgxVT2vC60CPLq9lFHOArIfOQ8ZMCVoy2P+fXnFg/JO8YaCl63ebFD5Jf4RuKcKfRG9ZuFE584hTtZ0Mn/XY1dsjLdzOaqmgGZ+EvENieVFMfhCIPvuLN2Pf1V42gBpuS0IwxG6RavlBCa2r63IHHtYPqNLH5E6Ax4+8j0bT4CCYrMP+QTQbS8lBi5JlKrVoPnT5nFY0VqZJdqe09SWC+ACcTC1tCYhYB+VFdyAAg9dWiFGVBLPcBJ0DrIK4hIdeNk0eV5HBLmksKKOKOwqkE42T2wwAmvTqgMhIEVhZh8KGeTfHg8A1l48xgW6CrByT539/2YIsslSljDM3GkZ1M0aQP8G78dyCGshqRswCzYQdkBsQk0UMQRHf/sylf41dlss2zljwjMNb9cjoEAmtF4NZJz8MpdNc7LpE3KnUl2w0FuDj6EnBh/i52cmmdUTNzcM+/V0CaA0e79N7bs1/HBL7MLntl+QvKKZcBp7PGAe6YF/cQcBFm4nMlngfhFSOnYGWp6UiU3bksUKzIi5Fund2LvdXLeR9s/kaV2V4VUCslS2Y4hvZxYDg6lG2U40qFg6pEvlk26mQdjH7w7f64lgX2aCvagzL4rcYGSGWndQUAcEe593le63LYofyqZuIs47dr6caV30imQYyX/J+PtlDCHuSZcoy2/+HuumjY6Ki5SpLqQE/mJ+up9xx5OrC2j5tz3uVzqI1hd
 K6ityE0E
 QaOsSc012CzLsnDW25CgI1eiDNaX0s6iv37D09A1LlQs4e1XzGNH9zRfg87kn8dRIiTxFqWAybH4Jpz5olMCQk0HDWDGKXYdL9hhAir+5igTIBBlYblGsRZCPdUv/oupim0d6sujZG0cUGrK+LVIeYT7O3XLI+WXFjWi4uki2nFYh+cP/sQ87b8HF+5I8lqOz63GMs4w6vrxNiHcQM4Ub1DTk4M7jLGFrMoo0TRt8q1MJzBQjTFNYTyu2t8EqMSeN4LfxH0cw/nZRGK5edJS6SEidooUjtQQMPx0UVFhRa2STW7wVdbcwYePJ5MydecZyoN2pwCEK9n50Rdd8fBoePukgTsC2AoDAexfvnv7K4st6EBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 2, 2026 at 7:11=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
>
> On Mon, Aug 3, 2026 at 5:58=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
> >
> > v2 version of this patchset [1] was written by Dave Hansen and per his
> > request, I'm taking over this series.
> >
> > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > of the per-VMA lock users now that they can rely on them being
> > always available.
> >
> > Binder and networking folks: Your code is the target of the cleanups.
> > I'm cc'ing you now on v2 because there's emerging consensus on the mm
> > side that the approach here is sane. I'm not quite sure how this pile
> > would get merged, but ack/review tags would be appreciated if this
> > looks good to you.
> >
> > Longer version:
> >
> > When working on some x86 shadow stack code, it was a real pain to
> > avoid causing recursive locking problems with mmap_lock. One way
> > to avoid those was to avoid mmap_lock and use per-VMA locks instead.
> > They are great, but they are not available in all configs which
> > makes them unusable in generic code, or if you want to completely
> > avoid mmap_lock.
> >
> > Make per-VMA locks available in all configs. Right now, they are
> > only available on select architectures when SMP and MMU are enabled.
> > But all of the primitives that per-VMA locks are built on (RCU, maple
> > trees, refcounts) work just fine without SMP or MMU.
> >
> > The only real downside is that making VMAs a wee bit bigger on !MMU
> > and !SMP builds.
> >
> > The upside is much cleaner code, lower complexity and less #ifdeffery.
> >
> > Clean up a binder VMA locking site now that it can rely on per-VMA
> > locks.
> >
> > Building on top of universally-available per-VMA locks, introduce a
> > new helper. Since the new API does not require callers to have a
> > fallback to mmap_lock, it's much easier to use. Callers can
> > potentially replace this very common kernel idiom:
> >
> >         mmap_read_lock(mm);
> >         vma =3D vma_lookup()
> >         // fiddle with vma
> >         mmap_read_unlock(mm);
> >
> > with:
> >
> >         vma =3D vma_start_read_unlocked(mm, address);
> >         // fiddle with vma
> >         vma_end_read(vma);
> >
> > Which avoids mmap_lock entirely in the fast path.
> >
> > Use that new API for another binder site and one in the TCP code.
>
> Nice, Suren and Dave.
>
> I wonder if we could use the same approach in the page fault
> path. Instead of falling back to mmap_lock when
> lock_vma_under_rcu() fails the first time, could we wait for the
> writer to finish and then retry acquiring the VMA lock?

Yeah, we might be able to do that. Matthew is working on moving common
page-fault handling code into a single arch-independent place. Your
suggested change would be simpler if done after Matthew's refactoring.

> For example:
>
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 85e23388f9bb..684f38cc4e74 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -677,7 +677,7 @@ static int __kprobes do_page_fault(unsigned long
> far, unsigned long esr,
>         if (!(mm_flags & FAULT_FLAG_USER))
>                 goto lock_mmap;
>
> -       vma =3D lock_vma_under_rcu(mm, addr);
> +       vma =3D vma_start_read_unlocked(mm, addr);
>         if (!vma)
>                 goto lock_mmap;
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 45b99c3b1442..a3a4c4741e30 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1331,7 +1331,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>         if (!(flags & FAULT_FLAG_USER))
>                 goto lock_mmap;
>
> -       vma =3D lock_vma_under_rcu(mm, address);
> +       vma =3D vma_start_read_unlocked(mm, address);
>         if (!vma)
>                 goto lock_mmap;
>
> Best Regards
> Barry

