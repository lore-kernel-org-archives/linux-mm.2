Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1925BC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348E96B0092; Tue,  1 Sep 2026 19:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3209B6B0095; Tue,  1 Sep 2026 19:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237936B0096; Tue,  1 Sep 2026 19:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 022C66B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:53:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8465640553
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:53:35 +0000 (UTC)
X-FDA: 85166847990.05.C6B32A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B67D1120009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:53:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmYYgg+H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788306813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i7vD/a41ONmfi39O5D4lxwhtO96kafP4uadj166A64=;
	b=4FsNp4HuHwvTzEQxYXCYJgG6fxslLdaZzeHJQQjMfMFtB29pAI0mnUw2RCxrGGlq+s+PW+
	6i2X5btmkEnGGAAoO66sbj6TJ+RTiw/uvOj2Ec3uGvi9Whdfpvg4uSQ7hk6snSeBvimDnp
	b4Boo2Cl2RhfujxR0OaV1BPy5lIuwZ8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmYYgg+H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788306813;
	b=N6JWPYfxPXySQKru5MJAXa/ILDwusPDZcPYWbV53iN3XwnVInBhxEPV1T2pZKBW5k0aeSr
	E0cBs+kDrG4kUjhEteoBxuj/sPyWPJ+sdZyy9yNH09mg3x7cVLHAF+SzE8X3OnKjQkGhiN
	CPfsEO0CxiqYi4ubpvHAmVnpi7aUk5Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A079600D9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019F51F00A3A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788306813;
	bh=5i7vD/a41ONmfi39O5D4lxwhtO96kafP4uadj166A64=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RmYYgg+HR691cDZtwkrx+YrR9vQObhUrquCIRaEYy33HX1AANpnsLhDz/HwUxkPTa
	 TEcV4ztyM71VpVUTfSnxAwJP+ZIDWge/MzDzfXNacC20MdNCk6q46dEbqO3liWvZLE
	 mb6iYW3hAZQJpfYgzKwfmSa+AJqyJT9Hi1hn29RD0uwUBkVJGk+kHf3YZ+ejjXuZKB
	 4U4KvWYndxra/Pl4bpFc8l2c7wvzikOuQOOlJB6tqn1iIDP3fZ0XK2ZnC72BSB2X3I
	 dC7Qhbnx6V4Z5dfOeSRt1l4kJnX+BKFCiIKoyrfxPu9GnX67XOoR0d8I03BaZrPmdt
	 pl2jTHHdR065A==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92ed19f4d60so45214185a.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 16:53:32 -0700 (PDT)
X-Gm-Message-State: AFuF++mkaHSGNwmXUQaFUPObOmLDDSVle/mlO6qpfLlrFDJhsOHlJ4l8
	O7rHT5kxAHJOzYG3znn18RZ52biOYHiBINzWy6gq09imYA5EUPhRe2iaMe8zw7tU2I7nIHkb0aH
	Uc2j4QaM2CEt/0NogZu40u/YlUTQ+L54=
X-Received: by 2002:a05:620a:4706:b0:939:5d22:d1f0 with SMTP id
 af79cd13be357-9395d22d30cmr415757785a.2.1788306807453; Tue, 01 Sep 2026
 16:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn> <20260901063755.1519710-4-hebaoquan@kylinos.cn>
In-Reply-To: <20260901063755.1519710-4-hebaoquan@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Wed, 2 Sep 2026 07:53:15 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zFoYNuuVsTR=T4Qtxc5iVBPCK8rgiKa75VqNWqqcO=3g@mail.gmail.com>
X-Gm-Features: AcwNN1XtnEq0yidYElvmZgI-ZA_zAwEf8gcBMwVoGR_9R92qipcL6I197I_mMDc
Message-ID: <CAGsJ_4zFoYNuuVsTR=T4Qtxc5iVBPCK8rgiKa75VqNWqqcO=3g@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: r9m9qc938cipysdsbwizwob3sohcabrn
X-Rspamd-Queue-Id: B67D1120009
X-HE-Tag: 1788306813-871093
X-HE-Meta: U2FsdGVkX19iy5ScEpc/Q5jYNArxFbO+nF35/g4P1wCogxsEqbMduIKeIpk+tVwRtY+kl+FN63kKhFY8g8b7ru7H2V2LdTa81BUP0dVvVNyJictQXSHWq/q+RxjCPymAxW31t9SE3iwRxh+41xPNI0Ypadb1F657678wkLmXexQn3zFIVqijnm6IaVlViw6Mkxm8oB1if8elIFb/ysl0ZMwa73lsVlimRfyh+qBI8qi1yNZA6ROqegZTQQpaJGnVByecxpG6y2LIRZAmDZpjChgx2k9vZrZFYlN2cNOrbPD4hM/pnTQrZr9O9ERt1/XiyFWOgmGz79ErIxSDbPy7Y8LhSOlZeX+FPH4xdMFvasFtwrvGFd2eVavTtI5NiQGxfRzN0Z2R+SlZhA2JxcDgDr/vGZypsPyvGBqB95U7mHjGOncAbUCrDLeT/soH5hv4atMa3QzOd/gC4kMJf4SD8CsCH0/Jqbu+Q2/egDd6OHprbVRURqRqWITpl1xynWi61IPZr1TficM5l3dHz2xWbtmM11mPEBDE1pFIRDoznvJEqp0LHs6yKnYboMSr+45IkguBdDa8MMuqCD+aauaS31Q+jxA+cksCVZh6wUoLve0IlnTwylITTgneXDy5PoFVmnbkXBNaf614XC4ZKKGk0MsOa6oEh7FX8qHi1+KxeHF3xM75JY1MJi/Y6wwEyi5i2lzP6Ga5nGTltEgZJK0upHdHy3ToorOufgaD2KXW7SvSjWQsTc8AnWiZ1H5Zg3nhCnJIXL9bmXVi5XalMn/dZfzc4CtD3JaftqpuK8QB+LFvXC18SKr2sDy1yljIqWc4WKUL9UQtj85T+De5L7JVSoymtgcDNvhJZcRD80zEtbs9A+SaFAG295EKs/HrZ8m4K8lxPcQWRbuxZEffP/KpMLGJXPqzbt7rnVi1BFBxTut+mGhva9qJ/5ld9Cq6WassheIJNev/u9rJsVutcWy
 Wpn0JPmc
 Y8xA7m9oX3vdEjoX+oFdJTDW4aMePIoDKgfZvb5ndouNiiZUFAg39ljvsPeuAP8qEBr9OtVFKyYyqSVC8hEsGCAjRMJAuGW3GinBiRdrEjNB9+ewNzqpHimKMZYji4A26TzDzJ6pmLG41c7FnfnNsiEZR3RCE3kuMbwpMnWvvB44g3yZST2BOgIxusDtwjW9ch7EeYfZxRXZpXaTzpOJVSKu6bJ34T6Atk677u37klMDOVrBKS7JqanWmyimpHtSZsi/ogZ2gnwyf6/GxTniWl009xsd2qzCyafPi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 2:38=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
>
> The aging walks into every PUD and runs the PMD-level Bloom filter
> on each PMD. Add a coarser PUD-level filter (pud_filters) one level
> up:
>  - walk_pmd_range() now reports whether it found any young leaf entries,
>  - walk_pud_range() records that in the PUD filter, and
>  - on subsequent generations, skips the whole 1GB subtree when the filter
>    says it had none last generation.
>
> The double-buffered filter flips with each new iteration, so newly hot or
> migrated-in pages are re-checked promptly rather than suppressed
> indefinitely. force_scan walks bypass the PUD test, so manual aging and
> newly added mm's always rescan and re-populate the filter.
>
> To keep hot regions marked, also report the covering PUD from the rmap
> feedback path (lru_gen_look_around()), so regions whose hotness is only
> observed by eviction will be re-scanned.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 47 insertions(+), 5 deletions(-)
[...]
> @@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mapped_wa=
lk *pvmw, unsigned int nr)
>         lazy_mmu_mode_disable();
>
>         /* feedback from rmap walkers to page table walkers */
> -       if (mm_state && suitable_to_scan(i, young))
> +       if (mm_state && suitable_to_scan(i, young)) {
> +               /* the PUD entry covering the young PTEs scanned above */
> +               pud_t *pud_p =3D pud_offset(p4d_offset(pgd_offset(vma->vm=
_mm, pvmw->address),
> +                                                    pvmw->address), pvmw=
->address);
> +
>                 update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
> +               update_pud_bloom_filter(mm_state, max_seq, pud_p);
> +       }


Hi Baoquan,

I am really not against this idea, and I believe it can benefit
NUMA cases.

That said, I might be being overly cautious, but I'm a bit concerned
that this re-walk of the page tables could slightly hurt machines that
don't benefit from the PUD filter at all. For example, Android devices
typically have relatively small amounts of memory, so a PUD covers a
really large range of their address space, which is unlikely to be
useful on an 8 GB Android device. Also, `lru_gen_look_around()` is a
really hot path. On Android, we've observed that it can consume a
significant amount of CPU.

Is there any possibility of implementing this in a low-cost way?

Best Regards
Barry

