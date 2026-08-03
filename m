Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF71AC55174
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 02:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D291D6B0092; Sun,  2 Aug 2026 22:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD98E6B0093; Sun,  2 Aug 2026 22:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2D86B0095; Sun,  2 Aug 2026 22:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 924B96B0092
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:11:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7909405DB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:11:39 +0000 (UTC)
X-FDA: 85058331918.02.21F21FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DD74440004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:11:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/h3eM78";
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785723098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVWtx48ZEGjKyIAYEU5Bv10cYMlPf9YBanNbhypqrsk=;
	b=ROFOrC7a+DU2XHtU2m5SCDcib/djhYHuxIjH4qOWNrjkUtV794hh1fFbXwQ+qdHyUXaaBd
	VEspybCnqL+uuEOhJE+KrMDZ/HivGbSTHN4JlTr3ipne3NwcaHEl0gMZJ/HZFw9ppptpcd
	APKVwC2ggYUGt5xJth6TzINLt+vhzNM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/h3eM78";
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785723098;
	b=sna1cdFo4d7AzlXqGWBittPMvwo3ZvmmIc+G2Cf3sU77Zx3FyoO9pp/08ovJEzAkYyPaBA
	ui9tmPpV2wkei2CO/e8rvqG8uQ8VYav8fIkURam4z22GeyYHzmGJyKaZ5hDVK1dS+0TpqN
	GPsKmF1qzQEBMikE5d1O58UzQlm3cW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A95E543C99
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876721F00A3E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785723096;
	bh=mVWtx48ZEGjKyIAYEU5Bv10cYMlPf9YBanNbhypqrsk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=k/h3eM78C7JHR2nlZcbFpPfmYOAVfCETMifYT9eDNmVAps/QzFnRQDyKCvZF+XVXi
	 ooF0t3LNDpxi7L0QW+0ibsSNOhz04RWMCe7QKIFKqMq54douQ31BIukAJM6Gc0C8ow
	 hl3FP+uWXavZHIIBcMxhSYVVHHNiW3LZahWyksNTYEEmF4OBrmeOy04R26mh2WMLpu
	 Bj3jWGDTmZ1lh6wCSnLzagi1h9VQY559eAOI08yqu4mA0wpSIASck7DpP/uGrP5wVH
	 FP5WLa9ADVBmovdkkNwNWN9Bx00FygsDoRokz9Xj9nA0X9HOo6e0r9AkTMLZBlKWpl
	 87lnZa8hbFBlg==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e54f8c051so136949185a.3
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 19:11:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq/7je5PSwPRSZGm029Y0bNt976RJgynacFoLsQxMBijJVwisyVHGoGCqt0lUitHG3lHmfzh3pj0w==@kvack.org
X-Gm-Message-State: AOJu0YxZmAlTXqvEh2I+BzGC/O/NMTwGYJVDSDvZbH5IojkLYzn/Xqoq
	9ePMLbXmM2eEEa3vFC06pT3W3j+2NfsnrKUl7SAs+s2U5mZsWYrLShFLtchsCcJD/JqrE6I6b7N
	NQO9mnjjWJ8EDFCwd3+9o4YdRwJNxkdQ=
X-Received: by 2002:a05:620a:640c:b0:92e:f101:5dd6 with SMTP id
 af79cd13be357-934a07561abmr1689941085a.6.1785723095889; Sun, 02 Aug 2026
 19:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com>
In-Reply-To: <20260802215459.2769283-1-surenb@google.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 3 Aug 2026 10:11:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wXGf90BMoJp3_z8G4fMTAgED88RXvbp6C4Gf+iy_2nvg@mail.gmail.com>
X-Gm-Features: AUfX_mwIvcG96g06HvvXzFCI6z0cYnWGHyN0Cv1pFy9INXjHgI-8m_UrS99NoUg
Message-ID: <CAGsJ_4wXGf90BMoJp3_z8G4fMTAgED88RXvbp6C4Gf+iy_2nvg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] mm: Unconditional per-VMA locks and cleanups
To: Suren Baghdasaryan <surenb@google.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD74440004
X-Stat-Signature: tp1jo1krare3gnj5f81bsubrrf7h4pxb
X-HE-Tag: 1785723097-992983
X-HE-Meta: U2FsdGVkX1+x8lEWSTQ3IYKWTvxid4E9UvjEz3Qka9y8OqAL4/H5jgOyKomkgEJSld67VrPbuzaSMQ6HTk6p4mNPsmi6uLrWzZjdPzlyJt4M/G9UQF+bS/cI946+/NWsetMAVVI1MOOsMIyrtQh5szy1gLHjJoGElJEf5DrgYiGq5O6AKqeKik2N6dOIO6MzjGPc5t3VmX35S5vI4fP89hJnEj473TqbnQdFlxDlP3c+RZ7FMInlnQgiBZv3dSm7eEdHhsJ4HB6Ta5X3fDMyEBLz/aXjij5ijQKFK1Yl+D0fmQdDzljusYgSKrUNQTR//mEB64gFPErSX3TTdxt97KHig6umnMbwI11sWCLvAMsccscqMBZQSGCWdoHayEy9R/vWKpvH/t5PpzkHQeOzRcUM9UtBeM5mZg1stemjgrJ7y/vlvdgvJJ9/a37a7pjb8eWW6KlIvn0Iyw35ni+rVwLKF3PsQEVnuKNSBks5shA5cd2ng2s84XD2dMNBStbg/Q0c8NV2F6EIQfT0Xia3BewQQRt5W5QaCljO1oa5wV6jhXcOHd9rAuW+trCCWzt7gWDheMmAXkvAP7QPmloLDrsHJA0v9f3DLPO9OIbW8tADTJURL0ucAvAhb11gVh5QQL6ZROpIOLI46PMiwEttHXPxm2kOrLjFN1r44J14aFFMrJ4ZMuF+kLd27WTa3aaAeKHSEKLjp8MPlMC6xI4lf+BekM8C8VhsjYeNojOGMp95NZ37OUlZdEv/rw7xDLNdQymDAL0Y0Qf2lPlCTMbBhSPOwUgKeZYkn1TvIIZlIjOpkabQETJo/BP5bTUanZpVlt66CJxB5m2nJnmlWflRyDWGDDMmkqHbTQh3wrHYunB2USWpwmeJ+PFFk1BYm/h6X4dW+On0mt1pSAXiRx0/bkYNiSovO5VmJdWnua4z057oCPA2kLheHjjAbi95HJA0fUqNWP1RCHxm/dS0XYt
 mUctB8JI
 73ov7WoNyssYWT0g1ejFaW4zenWJFudvxRqfHwqTRRftWGOZdN12mO4m7QwlQYWgTlxZjDfTtYuQziY0yPqopshcaBD7gHTF6Z8wwu71fMmTh3usJCyDuUxqwRFGIB8M/2etlghComaBZckUgAToSjGWuR/G9GJx8HmgaIg+pZReiI2txL92jesYZR/UF75ZJyrMT6eRh2sUXmB/V/bX3LUCpr5nHQJ3XgaNaH6t66LiLf+tc2I96yv8SlXqo1bQHAe2i1BT+tgWI2gbYB0khMCEa7PRYCEGVriLD8O1TxL4UpUGVqlb6x4PUFVLu1XR/bqqX4R2geQf93ilB+izN41a4P2MbO/imsZvDtKEgS3JWxqto12qddz+MMGxJ6YdW4+qb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 5:58=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> v2 version of this patchset [1] was written by Dave Hansen and per his
> request, I'm taking over this series.
>
> tl;dr: Make per-VMA locks available in all configs. Simplify some
> of the per-VMA lock users now that they can rely on them being
> always available.
>
> Binder and networking folks: Your code is the target of the cleanups.
> I'm cc'ing you now on v2 because there's emerging consensus on the mm
> side that the approach here is sane. I'm not quite sure how this pile
> would get merged, but ack/review tags would be appreciated if this
> looks good to you.
>
> Longer version:
>
> When working on some x86 shadow stack code, it was a real pain to
> avoid causing recursive locking problems with mmap_lock. One way
> to avoid those was to avoid mmap_lock and use per-VMA locks instead.
> They are great, but they are not available in all configs which
> makes them unusable in generic code, or if you want to completely
> avoid mmap_lock.
>
> Make per-VMA locks available in all configs. Right now, they are
> only available on select architectures when SMP and MMU are enabled.
> But all of the primitives that per-VMA locks are built on (RCU, maple
> trees, refcounts) work just fine without SMP or MMU.
>
> The only real downside is that making VMAs a wee bit bigger on !MMU
> and !SMP builds.
>
> The upside is much cleaner code, lower complexity and less #ifdeffery.
>
> Clean up a binder VMA locking site now that it can rely on per-VMA
> locks.
>
> Building on top of universally-available per-VMA locks, introduce a
> new helper. Since the new API does not require callers to have a
> fallback to mmap_lock, it's much easier to use. Callers can
> potentially replace this very common kernel idiom:
>
>         mmap_read_lock(mm);
>         vma =3D vma_lookup()
>         // fiddle with vma
>         mmap_read_unlock(mm);
>
> with:
>
>         vma =3D vma_start_read_unlocked(mm, address);
>         // fiddle with vma
>         vma_end_read(vma);
>
> Which avoids mmap_lock entirely in the fast path.
>
> Use that new API for another binder site and one in the TCP code.

Nice, Suren and Dave.

I wonder if we could use the same approach in the page fault
path. Instead of falling back to mmap_lock when
lock_vma_under_rcu() fails the first time, could we wait for the
writer to finish and then retry acquiring the VMA lock?
For example:

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 85e23388f9bb..684f38cc4e74 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -677,7 +677,7 @@ static int __kprobes do_page_fault(unsigned long
far, unsigned long esr,
        if (!(mm_flags & FAULT_FLAG_USER))
                goto lock_mmap;

-       vma =3D lock_vma_under_rcu(mm, addr);
+       vma =3D vma_start_read_unlocked(mm, addr);
        if (!vma)
                goto lock_mmap;

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..a3a4c4741e30 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1331,7 +1331,7 @@ void do_user_addr_fault(struct pt_regs *regs,
        if (!(flags & FAULT_FLAG_USER))
                goto lock_mmap;

-       vma =3D lock_vma_under_rcu(mm, address);
+       vma =3D vma_start_read_unlocked(mm, address);
        if (!vma)
                goto lock_mmap;

Best Regards
Barry

