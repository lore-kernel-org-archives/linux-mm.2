Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61154C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547DC6B0093; Wed,  9 Sep 2026 12:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F94C6B0096; Wed,  9 Sep 2026 12:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C08E6B0098; Wed,  9 Sep 2026 12:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1444B6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:13:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 947BCA0299
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:13:21 +0000 (UTC)
X-FDA: 85194718602.28.F8A7E56
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf29.hostedemail.com (Postfix) with ESMTP id 99395120004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:13:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dnf1NR9m;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788970399;
	b=y9B+8YGp8OFHjYZc3nKC5X8EM5RLBF3ILtH+Ow216KQR7qDBE5xwqbVRk1FfH6vff4UgaE
	/xjewDu3YYr72Gs9Sy+TA0Z6Hjyb6bVPnB8qwp0JPkhb3I4m15GNdibR8/vhx+xf240VOW
	OwxjyjecbwJEMr5ZPHn8k7O0Dw3dDoE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dnf1NR9m;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwFK4mYyCKUvttrF+B6WpML2yr4ZZ0VuePy6xRS9Uvc=;
	b=TrXzHnWN1X7XlMlBgy4AsbANIRsAhgzFQ6LF5Pl2EQs/F5GUsG6ggFK1YJOXcMs+t5y/jU
	DurhMCz9aW0rgLsHo3A6BdvcTUHYOcroR9KnWnSPP67R8RKLTCxlyhGQG4OJlK58lArp1T
	XE/t7CgIHHS9NP5peVecd6HKEYIG7ig=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso306581cf.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 09:13:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788970399; cv=none;
        d=google.com; s=arc-20260327;
        b=CxvqFYHuDSsSZ6dSC56EaKB640OaTFhfI3g47znXhR864TfKcUrsN1vEQxylQ3r5Zx
         DczRoz/34AgwlSz+8mhENVwmJxHDsvLr3KnhR8ik9Nja2+FMD7ne2X53tRwnSwk+3F6v
         Qkump/QO4RLwSXm5cC+/o8o0RJo5Xj4KwSjo0LaiOfIP4v5XbZsWOXEJjheuyw0McSzD
         p8YW8G4q8J+ube2SfzGovNHJ0RDNuFJOcaTquDjruMWxPVwuzEMUfjSpJ4HiJ80QGFDc
         TeRl++ZFYtNcguom3HPG4fD4ma/76IBbOkYX10DbbQbta8S/rxwm4m+w5VlJTRiodeqQ
         Pb4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XwFK4mYyCKUvttrF+B6WpML2yr4ZZ0VuePy6xRS9Uvc=;
        fh=KupfGLUK/sDcw3NLFQZ8ziv5p69Tpy2JHwq0VZ365E0=;
        b=KIJYd40fWWdhuOAbxOfbrBtaekrzidiH77sGZqeXzLlKKCBQi1p4RvhFqUOSEmJcQS
         k/XXLjaUjyuFBqFWPxWFEzyIhUxHfx4j8qgvwWqxS+u3HyQwgriJ5j4p7CMC1mluGHPF
         sTJ8oesbzxzAmYhOP2wKyLJuwmUUCp8r2UjJrkvOy17rGATA8qdcnPO8k/lcMIYSP4iD
         ooPOm+1xOqqwzlcOjqs0LlsTbjq4g7wRRu1BqNgvIjWBzuJdUo0yal4YEW2bhIeKDr+2
         QFCmDlwVN5cZsBZ1M3crkuM64T9/n5Mxvl46rgAPtSEgnFYSMeERvQAX9a55FKb7OmML
         MYNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788970399; x=1789575199; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XwFK4mYyCKUvttrF+B6WpML2yr4ZZ0VuePy6xRS9Uvc=;
        b=dnf1NR9m5Deiplz757N1y2i0XxLHxDusvitu0PRy3Jcs/HzZC5u2zIgUGr7Px6/HDq
         0EhAM7/0b9aCMKARoK/ec44mik9gXkUzRO6MtMSUnxHJGnacWala9PaOv4Vh9UiyJR2l
         fyrGMdhApJh79x+obnXKVsasJHE7Au9+d1m3sQ0hqvlvrXFk0F7BhvXdkgynRol9Wnk8
         a9B+1rd3td29OkZ1V+0ERRzjMLIpPnD/U9mTVBeDElOqmg5SwyVy9TIHhk0/SrYVqtud
         TFO7DIZFS+PxBnAc6HKMR0WuIOeQ56DVKPWscXMb+xEhw1cg8eOfZdGqD6ux337+uY3v
         8Npg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788970399; x=1789575199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XwFK4mYyCKUvttrF+B6WpML2yr4ZZ0VuePy6xRS9Uvc=;
        b=VQpqaJvsSv96na4/cXtnrPfCHS9IJ7LWNIk4zs5/Fw9zLgKnX2x83CGPArVkjlKEHG
         E/DymLsJ+BcAy2VKm9lHnkhZqhqQx9zeMkumohIBHiBjvLkNsj4XWIWFGTtk92xgwOVO
         RRg6eXY+by54TQiOXAokpCZt85FeGIbenyJ3VtmC4ZeGHI4EqwYrrgLBPQoqPQrfStiQ
         jN1AxR7NRfFsfeyzYI+RUE+2EW5sw/d5Tq9gRrpAL8KLFnfo8LeiLHnoS651ACKcK+Wl
         hNKEQWHwfWtkaOQH5x9jk72Rnb+LmOGrezH8m/HlcLtK7Onqz/BZ9I5xtSQdA692uz0r
         zWoA==
X-Forwarded-Encrypted: i=1; AKwUvBwY9vjsNkwZYcpRNn1oTpIfkQ8GxZnoHu2RQe9xL9CRYs8VZcaoyuBu0cTYjDnl1L5DXSl4PUviJQ==@kvack.org
X-Gm-Message-State: AFuF++mqEg73m9u5/9mOuLI361DC69mZchSldJ8ZuRHr4mILhX4Czwro
	sqFTiT9Cctkg877gB3kr70ok7KCw51MeTNLnGjWxcOjhqpSUOZXoGxxtrGfdfRVtN5VxawW+x3U
	Oi4vpLCV1F4K9j4UPN9BpKgvCUVIw/qg6FcZws4dS
X-Gm-Gg: AYBFou3jTnQ5yK5wv0lI2yYxk5Gn0dGSD9csgrmAnYhv5O/IWeKlEyWjF2UoiZ1bXGM
	sDZ/uSfkjgYITdR8VJmlYqyozf95hXB4n/+IK2R6DuVbGcAeAzV6rA8gg/4Ui1zizfQrvEOcNMS
	7IHFfW5jwjAnUMj/uu06BuV46nW48Wv0ojlCKoEE/JrMjsMcF0D9wwlhPMsgD5RxzTHCCViJaEt
	4+BiavzbIFA6X9AfsTkN1/Dgtlzw/pWltQoul2EHfk/WYTYijUTzj+2D4TZXIwxFfUCaZJ/ToK/
	i7epRhdK/G/sNUm6Z7eqbg8CWyfO+kq8FIUQ1cwyqFIYetU2f3vzKZ0cPA==
X-Received: by 2002:a05:622a:1453:b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-530a5e02d7fmr16768441cf.3.1788970393225; Wed, 09 Sep 2026
 09:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-5-surenb@google.com> <20260909142527.1601051-1-usama.arif@linux.dev>
In-Reply-To: <20260909142527.1601051-1-usama.arif@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 9 Sep 2026 09:13:01 -0700
X-Gm-Features: AcwNN1UYQKF7D0D2WK-_ZwM2Lbn4QfF-4TdU4tR2zDAe1K2ZBIa-EoqKfU4N3fc
Message-ID: <CAJuCfpGOnSMPKMLVCO=JkcaahRvBU_1pNdK7AR5N3QKBARh4Ag@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, david@redhat.com, willy@infradead.org, jannh@google.com, 
	paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 99395120004
X-Stat-Signature: u635hseohsqkyepayo4arbzjqopzga9d
X-HE-Tag: 1788970399-705179
X-HE-Meta: U2FsdGVkX19K5g8cEm9SRegr6GXNjjMweZg4HaCE8CSQlVFMamOIRQaUO6cRdLj+pJC5lvahGdLmEm3Fp3MdlG2OyICMh5DcX2Jd7URL4IjPRkWVNFpLIcryMELYeZ3hWnoXv4D4IM2TGjIGCEQ5+HrZBbjVb7yM+gWEMVNtYrewDvPB/cDKTcOp+clszzA1WMqBOLzLy9Wae00RVhEoMXD+RBSJTf94ZXSfN9lgIcVzIiWhfhOnMBJXBhFcRO3yWe1QbU+Tm4loWYXRFrvqItJiI2ejrMMCEUcQbvsR8NxQi9k2xEZXSChTfHJ+S5TORqoZnpdLU700Ihd8ATKrdQmr7nfZfknyA0+epFA9E/NgRAL1fSWYhui+TifBHlwAOzGrV42nqOm06qA90FaB1LQph4cMZx7jRoMHKGEWHiLy4bKeiefLZ0HeJRjaZydAEHCYUJhb1bn4mmci4W4H/fLdahRA97HzVTl4j90SoIf5lca/7EzAJjf5xDSk825HdFJLX9wOV3w9CEtQ29l6NBltZSjQ+S/pn36sTnUMSRvTBxRxWm6wyO276dQCkzV35a0/TP2ceCaf23vUlLmgO8IeFgeLvPfK4PmOoKgSqwysFTPG7BKdpm/U4vQrtOz+gg5ChjbIwGEEve2H6hhCb5GM/luo3m94b4saoihs1lQS0iH9eQvyHTb8zBl70gM9UacO4S9AUDY1Pq+pP69CrDD+AekdXE6Xib7a9AUi3fRVw71Yj49z9SoLJKpQ/O6j5l8X3DPMhbhmIAUr0iQHgAE/C7i7FQ7XS6ozdp6ynEXOZWuEAdpij6op8j39phsN+zNe2q4/Lrn3XE0h8DSPeJ6qGrBA3gDdXvFNXIFk3l2Z+uBcdOJA9gVvxQPoUY5BF720LUQJpjlAlXLRrDQC4bHpb8CqTA37TEQtpA04qKCgdpjNMFT6UtHqDdjKFlIpBMnN7Rv0FwlfIXbiQYQ
 CikeMT/1
 n0Tf9qvWX8zVO5a+UyVmoqdr6R4lS9or2nAL8jEcpAydQSZZVAVn1tYnuHoI5hN8E1h54fPtH6HOZKkGBSZsM2QrU19+O7lPhDLIrksV1ijNXPWXjoDvuP5QaSQ4m9TV6SJxIYVynCueZ65AqqynB7mQK+PcQMm0e3pWIj2Ls/Ch8Y2iB2K54zUOr+c3ZNCMV0qhX9rsHSTQna0Vp0P4s8FThLhHCBPMqPcI8gEG3muDUr64S9S9A7bKqQAOJiZm8Vil0gJkMQ+X29zrVOEcz5w7+fhvIrQcHPLa+I/4ozbgI73POoHH1xlkEMmVkWWCE1yESd//n/Wj/e4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 7:25=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> On Sun,  6 Sep 2026 23:39:17 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > proc/pid/smaps_rollup can be read using the combination of RCU and
> > VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> > required to safely traverse the VMA tree and VMA lock stabilizes the
> > VMA being processed and the pagetable walk.
> > Note that we have to keep the logic to drop mmap_lock on contention
> > because even when using per-VMA locks we might have to fall back to
> > holding the mmap_lock.
> >
> > Running Paul's contention benchmark [1] shows considerable improvement
> > both in median and in the worst case latencies:
> >
> > Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
> > --busyduration 2 --procfile smaps_rollup
> >
> > Baseline:
> >    Median   Minimum   Maximum
> >     0.174     0.161     2.553
> >     0.174     0.164     2.663
> >     0.174     0.165     2.664
> >     0.174     0.166     2.679
> >     0.174     0.167     2.691
> >     0.174     0.168     2.704
> >     0.174     0.169     2.729
> >     0.174     0.172     2.741
> >     0.174     0.174     2.745
> >     0.174     0.174     2.755
> >     0.174     0.175     2.790
> >     0.174     0.177     2.809
> >     0.174     0.179     3.096
> >     0.174     0.183     3.144
> >     0.174     0.184     3.158
> >     0.174     0.185     3.175
> >     0.174     0.185     4.568
> >     0.174     0.198     4.821
> >     0.174     0.214     5.143
> >     0.174     0.251     5.220
> >
> > Patched:
> >    Median   Minimum   Maximum
> >     0.007     0.007     1.952
> >     0.007     0.007     1.955
> >     0.007     0.007     1.955
> >     0.007     0.007     1.955
> >     0.007     0.007     1.957
> >     0.007     0.007     1.969
> >     0.007     0.007     2.065
> >     0.007     0.007     2.075
> >     0.007     0.007     2.146
> >     0.007     0.007     2.195
> >     0.007     0.007     2.223
> >     0.007     0.007     2.259
> >     0.007     0.007     2.488
> >     0.007     0.007     2.562
> >     0.007     0.007     2.599
> >     0.007     0.007     2.697
> >     0.007     0.007     3.030
> >     0.007     0.007     3.075
> >     0.007     0.007     3.145
> >     0.007     0.007     3.225
> >
> > Remove now unused lock_ctx_mm() and move unlock_ctx_vma() next to
> > unlock_ctx_mm() as they are logically related.
> >
> > Remove a long comment about 4 cases that we handle when dropping the
> > mmap lock in the middle of VMA walk due to contention. The first 3
> > cases explained there are handled naturally and only case 4 needs to
> > be handled in a special way, which is done in smap_gather_stats() by
> > gathering stats from the portion of the VMA that has not yet been
> > processed.
> > For posterity, moving this comment here:
> >
> > After dropping the lock, there are four cases to
> > consider. See the following example for explanation.
> >
> >   +------+------+-----------+
> >   | VMA1 | VMA2 | VMA3      |
> >   +------+------+-----------+
> >   |      |      |           |
> >  4k     8k     16k         400k
> >
> > Suppose we drop the lock after reading VMA2 due to
> > contention, then we get:
> >
> >       last_vma_end =3D 16k
> >
> > 1) VMA2 is freed, but VMA3 exists:
> >
> >    vma_next(vmi) will return VMA3.
> >    In this case, just continue from VMA3.
> >
> > 2) VMA2 still exists:
> >
> >    vma_next(vmi) will return VMA3.
> >    In this case, just continue from VMA3.
> >
> > 3) No more VMAs can be found:
> >
> >    vma_next(vmi) will return NULL.
> >    No more things to do, just break.
> >
> > 4) (last_vma_end - 1) is the middle of a vma (VMA'):
> >
> >    vma_next(vmi) will return VMA' whose range
> >    contains last_vma_end.
> >    Iterate VMA' from last_vma_end.
> >
> > [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 153 ++++++++++++++++++---------------------------
> >  1 file changed, 60 insertions(+), 93 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 3351decd1172..641a155b0c61 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -130,28 +130,12 @@ static void release_task_mempolicy(struct proc_ma=
ps_private *priv)
> >  }
> >  #endif
> >
> > -static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     int ret =3D mmap_read_lock_killable(lock_ctx->mm);
> > -
> > -     if (!ret)
> > -             lock_ctx->mmap_locked =3D true;
> > -
> > -     return ret;
> > -}
> > -
> >  static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       mmap_read_unlock(lock_ctx->mm);
> >       lock_ctx->mmap_locked =3D false;
> >  }
> >
> > -static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     lock_ctx->locked_vma =3D NULL;
> > -     lock_ctx->mmap_locked =3D false;
> > -}
> > -
> >  static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       if (lock_ctx->locked_vma) {
> > @@ -160,6 +144,12 @@ static void unlock_ctx_vma(struct proc_maps_lockin=
g_ctx *lock_ctx)
> >       }
> >  }
> >
> > +static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> > +{
> > +     lock_ctx->locked_vma =3D NULL;
> > +     lock_ctx->mmap_locked =3D false;
> > +}
> > +
> >  static struct vm_area_struct *get_next_vma(struct proc_maps_private *p=
riv,
> >                                          loff_t last_pos)
> >  {
> > @@ -1376,12 +1366,14 @@ static int show_smap(struct seq_file *m, void *=
v)
> >  static int show_smaps_rollup(struct seq_file *m, void *v)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> > +     struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> > +     struct mm_struct *mm =3D lock_ctx->mm;
> >       struct mem_size_stats mss =3D {};
> > -     struct mm_struct *mm =3D priv->lock_ctx.mm;
> > +     unsigned long last_vma_end =3D 0;
> > +     unsigned long vma_start =3D 0;
> >       struct vm_area_struct *vma;
> > -     unsigned long vma_start =3D 0, last_vma_end =3D 0;
> > +     loff_t pos =3D 0;
> >       int ret =3D 0;
> > -     VMA_ITERATOR(vmi, mm, 0);
> >
> >       priv->task =3D get_proc_task(priv->inode);
> >       if (!priv->task)
> > @@ -1392,89 +1384,60 @@ static int show_smaps_rollup(struct seq_file *m=
, void *v)
> >               goto out_put_task;
> >       }
> >
> > -     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > -     if (ret)
> > -             goto out_put_mm;
> > -
> >       hold_task_mempolicy(priv);
> > -     vma =3D vma_next(&vmi);
> > +     rcu_read_lock();
> > +     reset_lock_ctx(lock_ctx);
> >
> > +     vma_iter_init(&priv->iter, mm, 0);
> > +     vma =3D proc_get_vma(m, &pos);
> >       if (unlikely(!vma))
> >               goto empty_set;
> >
> > -     vma_start =3D vma->vm_start;
> > -     do {
> > -             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > -             last_vma_end =3D vma->vm_end;
> > +     if (!IS_ERR(vma) && vma !=3D get_gate_vma(lock_ctx->mm))
> > +             vma_start =3D vma->vm_start;
> > +
> > +     while (vma) {
> > +             if (IS_ERR(vma)) {
> > +                     ret =3D PTR_ERR(vma);
> > +                     goto out_unlock;
> > +             }
> > +
> > +             if (vma =3D=3D get_gate_vma(lock_ctx->mm))
> > +                     break;
> >
> >               /*
> > -              * Release mmap_lock temporarily if someone wants to
> > -              * access it for write request.
> > +              * If after retaking the lock, already reported VMA grew =
or
> > +              * merged with the next one, smap_gather_stats() will gat=
her
> > +              * stats for the remaining portion by starting at last_vm=
a_end.
> >                */
> > -             if (mmap_lock_is_contended(mm)) {
> > -                     vma_iter_invalidate(&vmi);
> > -                     unlock_ctx_mm(&priv->lock_ctx);
> > -                     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > -                     if (ret) {
> > -                             release_task_mempolicy(priv);
> > -                             goto out_put_mm;
> > -                     }
> > +             smap_gather_stats(priv, vma, &mss, last_vma_end);
>
> Patch 3 made smap_gather_stats() reject starts below the VMA, while this
> function initializes last_vma_end to zero.
>
> The first ordinary VMA is therefore skipped. lock_next_vma() can also
> return a VMA beginning after the requested position, so the first VMA
> after every unmapped gap is skipped as well. This causes
> smaps_rollup to underreport RSS, PSS, swap, and the other accumulated
> values.
>
> I think you need:
>   unsigned long start =3D max(last_vma_end, vma->vm_start);
>   smap_gather_stats(priv, vma, &mss, start);

Oops, you are right. I didn't realize the first VMA would be silently
skipped. I'll fix it. Thanks!

>
>
>
> > +             last_vma_end =3D vma->vm_end;
> >
> > +             /*
> > +              * If the VMA lock is not taken, we hold the often conten=
ded
> > +              * mmap lock. This can happen if we had to fall back to t=
he
> > +              * mmap lock.
> > +              *
> > +              * To relieve pressure, check if it is indeed contended, =
then
> > +              * temporarily release it.
> > +              */
> > +             if (lock_ctx->mmap_locked &&
> > +                 mmap_lock_is_contended(lock_ctx->mm)) {
> > +                     unlock_ctx_mm(lock_ctx);
> >                       /*
> > -                      * After dropping the lock, there are four cases =
to
> > -                      * consider. See the following example for explan=
ation.
> > -                      *
> > -                      *   +------+------+-----------+
> > -                      *   | VMA1 | VMA2 | VMA3      |
> > -                      *   +------+------+-----------+
> > -                      *   |      |      |           |
> > -                      *  4k     8k     16k         400k
> > -                      *
> > -                      * Suppose we drop the lock after reading VMA2 du=
e to
> > -                      * contention, then we get:
> > -                      *
> > -                      *      last_vma_end =3D 16k
> > -                      *
> > -                      * 1) VMA2 is freed, but VMA3 exists:
> > -                      *
> > -                      *    vma_next(vmi) will return VMA3.
> > -                      *    In this case, just continue from VMA3.
> > -                      *
> > -                      * 2) VMA2 still exists:
> > -                      *
> > -                      *    vma_next(vmi) will return VMA3.
> > -                      *    In this case, just continue from VMA3.
> > -                      *
> > -                      * 3) No more VMAs can be found:
> > -                      *
> > -                      *    vma_next(vmi) will return NULL.
> > -                      *    No more things to do, just break.
> > -                      *
> > -                      * 4) (last_vma_end - 1) is the middle of a vma (=
VMA'):
> > -                      *
> > -                      *    vma_next(vmi) will return VMA' whose range
> > -                      *    contains last_vma_end.
> > -                      *    Iterate VMA' from last_vma_end.
> > +                      * Even though we previously fell back to mmap lo=
ck,
> > +                      * we try taking VMA lock for the next VMA, since=
 it
> > +                      * might not be under modification. In the worst =
case
> > +                      * we will fall back to mmap lock again.
> >                        */
> > -                     vma =3D vma_next(&vmi);
> > -                     /* Case 3 above */
> > -                     if (!vma)
> > -                             break;
> > -
> > -                     /* Case 1 and 2 above */
> > -                     if (vma->vm_start >=3D last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, vma->v=
m_start);
> > -                             last_vma_end =3D vma->vm_end;
> > -                             continue;
> > -                     }
> > -
> > -                     /* Case 4 above */
> > -                     if (vma->vm_end > last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, last_v=
ma_end);
> > -                             last_vma_end =3D vma->vm_end;
> > -                     }
> > +                     rcu_read_lock();
> > +                     reset_lock_ctx(lock_ctx);
> > +                     /* Resume from the last position. */
> > +                     pos =3D last_vma_end;
> > +                     vma_iter_init(&priv->iter, mm, pos);
> >               }
> > -     } for_each_vma(vmi, vma);
> > +             vma =3D proc_get_vma(m, &pos);
> > +     }
> >
> >  empty_set:
> >       show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
> > @@ -1483,10 +1446,14 @@ static int show_smaps_rollup(struct seq_file *m=
, void *v)
> >
> >       __show_smap(m, &mss, true);
> >
> > +out_unlock:
> > +     if (lock_ctx->mmap_locked) {
> > +             unlock_ctx_mm(lock_ctx);
> > +     } else {
> > +             unlock_ctx_vma(lock_ctx);
> > +             rcu_read_unlock();
> > +     }
> >       release_task_mempolicy(priv);
> > -     unlock_ctx_mm(&priv->lock_ctx);
> > -
> > -out_put_mm:
> >       mmput(mm);
> >  out_put_task:
> >       put_task_struct(priv->task);
> > --
> > 2.55.0.979.g7e5102b832-goog
> >
> >

