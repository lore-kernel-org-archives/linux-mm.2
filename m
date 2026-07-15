Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806F9C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606E46B0093; Wed, 15 Jul 2026 12:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF6C6B0095; Wed, 15 Jul 2026 12:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5D26B0096; Wed, 15 Jul 2026 12:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A73F6B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:39:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 902D0C0224
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:39:15 +0000 (UTC)
X-FDA: 84991571070.18.4B652BB
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id B401880007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:39:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eYZSdmWT;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784133553;
	b=g0KhPoxe5unzB37Bl5BZAdpeJ1k7BlgStbQpDoMDGl1a0YOPCAS6rfwEP4LuiTjbyz5df9
	0+xorYWaTnOhYglYm1/phJa29s5OnkasPvryafYCiiKthycPDILyIIVV+svf74MpVOQ6YJ
	aLsyRcd2tK6+89qU2YWwms6QJXLRls4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eYZSdmWT;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784133553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfbPeKYAmqSLM3UIvnqSVfgnAiaMMQcURGzzlVXKKr0=;
	b=443JMJ4WHHSNBfR0C728QpIHTg5+He1XVPFvFAgtxAXgQGVSv2QRk8iyyf/99nG85ydMFr
	RCKsBx0QSrpPTwuhzCREfZkYkwGiLuKDCM8dvzpuHsUgIqOWnCU0j0BjCkSgShHGs5Bppv
	FjEhzjxq7+cj7DOAkz4ztN/LL1F+NJE=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8423f236418so1969376b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784133552; cv=none;
        d=google.com; s=arc-20260327;
        b=DF6YEcsDOxPME/8k6SjPbUFZRzyAI1zLAFJ7rNu1QJJZTFjHBlmcNlBVVs+kvE27Dy
         z13Mu79Sa0sEpSw+K11uTyictw8y2HjTuArUJ3EokhwoA3tD6VSRpJ6KC/b3ldIZ+r7i
         W1D+OZeE3TYnwIWQOtBuFy0TMM+m1UMW0uxtj5Dmatvl6n9f93nxihgjbTVl6CWzB9fi
         avlwHucx2tZHKw5UHfGCInH68MxYdlDwsfMloqeXblBy+hSDRW1QsfOsxg70Bc5O+bK1
         6PXZUBYxQ1fvfLwhVDOaKfeJ7+++lzJ7aZdWGD+lkBQLVC72d/NZwCCNWf80TpqJP4hV
         0+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NfbPeKYAmqSLM3UIvnqSVfgnAiaMMQcURGzzlVXKKr0=;
        fh=WtDIpbk/Cvu3WygGOyAVw7yjotC0gdPbdzxBpkx80rc=;
        b=qICI3wF5QLhmWBakExOmKlbiOm6SKAGESHB1BMFL5ZL0iXG8jGOgLio+KTUkNDFLIk
         3OpFcZGD7skgLPmmbVFeu3H9fNdbOzcfMOJG+hatrsKS9bO2IqbgcL2I6KMwcB0zRbIl
         yJ1/UCQcB6mnkk0HVIbjQk33oJa+2ZMEgyufuzB9Yh8wkRb9N5WgtdIJmFVcfTxHVa93
         YpMSrOakAQR0L1ZvUPP075uU0G5vKxRUUTWQnFOSKt8cm7+PsUoy84ht4klhz56P3rpa
         39o0019KK8Tqs+G7ZvHNwz/hPqLqR9t7Xi5f97aHMUlkU19WQWChJHTK+rnKt3/W1Xw9
         wg2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784133552; x=1784738352; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NfbPeKYAmqSLM3UIvnqSVfgnAiaMMQcURGzzlVXKKr0=;
        b=eYZSdmWTww/p1Z2Rnw2rqpuhhaP2H2+ovg7gxc0vr6WoR+FYS4UNzWGr3YNQ7rDUjQ
         u7Fn20pJZTIwO2/mu3mDeTUKTbeTJaHtuXln2bwSsxTqH8rSwtNj09ulu2RMB3GrjMoH
         rbsk2mkUhq5OK+NrOebk7mHbQEsiQY90s7heDXPKBisYw50QLnqn6c+MzC2Zm9Gx6sbA
         E+gFwAxazxWYCYqa6bWO4W5mZYuA43M4JecWvnbWEoNSj5n7k+Cs53a1E3kTeJ0+CiDY
         wkKyp3/7iyCBPigES2L8DF9n62hs+wRIrnQM9bXFaRtTbu9qKXQz4m6U0MBFzPpCjzuU
         Bd7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784133552; x=1784738352;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NfbPeKYAmqSLM3UIvnqSVfgnAiaMMQcURGzzlVXKKr0=;
        b=TktDsRRvBNPelPV8jG4Up6JSRTNUOWoMO/R6OA2mC3OVd/cfrfh8NLenfp9Pw4E8cR
         XDQ5W+prIQdHpmdkbrg6+otuLwnnl9FMzYW5KSMcYc7OtH/W+rpjGzMk4L2UP6c/PGPn
         VBDr19qcgmodoK48o9wPXs5tECwZlw6fVhsdSHoJdT0WkA8LKyURvaMmliVGjkUF9MU2
         zwo9/n4rnkN9fkfQllZfbrLPRUGEx8zwvnFqdv/UAfujUEggW/C/qX8i9JHea30030cO
         pYd47ESG0jvdrQ1fMjcPcO+J8BzygWPOI3FcktMQiaIh84q925BT6+gafqG924qwPhBD
         /+1Q==
X-Gm-Message-State: AOJu0YyOYT2XbFNsLPXQQYV7RjraOVrQRDd1RnemiEntq5qd83uGgMwY
	fe+oBtRkPzuYQSaIjGiVNAjJE5lI7fGbnZbEsTZsJhGGteZjETH8k9kO/xQVC+gMob0Al1a0d1O
	8mp/M/ZtoItRXzEvY8/UJhsIXahRmWHQ=
X-Gm-Gg: AfdE7cldQmP6/iVxzoZ0r4ldCusL9h9Q/uaSIWHV+xPg27Rtd11zr3/SLrLyzycexOj
	tb5sUB9Z6633Yh5D8a8GIfVF76LwU9iI+NQc/Qhxa8EWoelzTe8TGG49ODH01/BQdIQXprcHBEm
	gf4rUo7Mn+76Xg7pVqI9ad32RstJTYT2Bft0gzMazdIEVwTjaz/QcpVGQIFZJD6odhSs/FZyAFX
	6uplh9Xg8+b1fakjmpzaITZemgLF9hQGoXBye1fffgjMuMRHI9xs0vYvjjR0vqGUD3LdOSNHK+h
	Zc1GGYWCqsJgvke6aUO2sz8CUKcjtw==
X-Received: by 2002:a05:6a00:14ce:b0:847:7f7a:dd18 with SMTP id
 d2e1a72fcca58-848895db925mr17089883b3a.3.1784133552453; Wed, 15 Jul 2026
 09:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
 <20260714-swap-pcp-priq-v1-9-de9b164ed419@tencent.com> <77d6da3d-10af-49a1-a356-72aa8b462e85@gmail.com>
In-Reply-To: <77d6da3d-10af-49a1-a356-72aa8b462e85@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 16 Jul 2026 00:38:31 +0800
X-Gm-Features: AUfX_mxST2YGU16fRIenEFs2J8gf4QhxF6WBV_5xFoYyMW2BHeQJ6cQZZFJxX2o
Message-ID: <CAMgjq7A7hdrMip=2A32J7GUuBzgcYuJb=HRYu2oJ6Roi1v14Ug@mail.gmail.com>
Subject: Re: [PATCH RFC 09/13] mm/swap: add priority queue for swap device allocation
To: Jihan LIN <linjh22s@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B401880007
X-Rspam-User: 
X-Stat-Signature: 3pb4cqr3o8ejqoo3c7bcxzmstfxkkdkm
X-Rspamd-Server: rspam03
X-HE-Tag: 1784133553-175137
X-HE-Meta: U2FsdGVkX1/wJ71eU7BSM3/9EK7yCvEi8rGMbrgfpoIxJ6FFuOVXDv5YsT2wocWhaw4PLdmI0WY7FmDx6pJwnTaRgczOS0zPehZdAU+EDCV/iuVbx0U7g2slNz11/U4h2STEFgQzZ+nAiDQdgaKkTrquEnBfkGjgTkiFYnTb1akcPgdlyIUOYtmHfU/ag+xI4ioj/A4z3kKeh1G7xsfUP8sI4Kync640davnAMNSFlwF0T4EwMIU1AcjYX4d20mxur/AREPE7+lAW/JpZwGNZqNkJ0LxfmXHiy5lKl0gHNQ3uDnclW+w0YLFMYHF07SjiBVYqirxPCpGUI3jzVCvgfjC0qaC69IYq7aB2oM/ffY4Mv+tKFEJ5wT7j7ddOoii33QofuANMwvDfAXvwcg5aBkEnSW2ggdCe8fOHLSp7DK1OsFShLowAbj04ixhoEV8gRVSOVYhIUVMA1fE6gNKd02MSWZ1db9HCnECUQSN+dS/cybwUM6s1jGDJ4F+BtI+yLA/qLtPd+jcuC9sP8c8ivzbtFMtOfN+Lwkf133Qx+VfqkicMwxZPlxYa1c6Co0EkYBUJZh2GT53OQhXZrKetRy7CtQAojG8L23zw0I3RW5aOHMf3ebjbrZegqtCVX+Bvw+yGYUjZqBnxWiYJURIrxfG3pxJbsTWFcWvhVqSvXpuNPsGm1t7Dnx653NVZjN7EaHujhhfXrD4aHodVIfL8h8JIO3YBOYX5VhB2OS4/hG2hVlheX2nWjBawjJ5Vqt7mnm2roLyZvQgpyj2lsr452BWvGj/5Qi/t9WuFyEXXZ4De9oXeRiRwgVNaGpiM6ZIhu1x7v9swFw1xsdJA5GfCnRoN0iGm89vmZabMdqhn69rltc1Bup5+rC/tq9S29arwmIOd1yoXydf7vkoJp2L/InOgCwRtu9KmhzyH6PKK89CTO89OMPJdfffCX0It3NDv8b4PFlh/r1Cbs2kHTA
 44Zt42rt
 ryCLYFxCyRWd0wRZf89SoPsqyrAUJTiH7wchac2LYX+O4Gs/a6kAzAuEUwiYjG6V8cjgGgTeU6yFGt05PsbrywlTrKR0NkLyCZascSJTJNh/3r7nqGLLTEBWZUXzzaHBMOclNptj7rXADlIBXDSKj+D2K/VvQ14hch3Z4OFZnDXq7z+Vhlfh330oyRFibTYHokepQ0oL0Rx/Vu1tEzjNBp5PdnSQ2ZxLhms37cXluZOv97bi3EFuO3MkORUk+tFiUTOK/E1YuhWYohp1e5/5vW7DCTGDvxO6TuGB4oTg8a9X1iTp93rxyTPw2fs8oCHbnpYV0qFLDjff9pcPY4vbkcuNNTWs9oN3XhwiPCARYEodI8U6ynEvJOvU2fl6QnrtLrw94IR1GvU4yXfII7PdZG3jdM6ijB6WmkxaCl2MsXCfOAKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 11:58=E2=80=AFPM Jihan LIN <linjh22s@gmail.com> wro=
te:
>
> Hi Kairui,
>
> Thanks for this series! I noticed a few issues in this patch:

Thanks for the review!

> >+static struct swap_info_struct *swap_queue_get_device(long nr_alloc, in=
t nr_iter)
> >+{
> >+      bool rotate =3D false;
> >+      struct swap_info_struct *si;
> >+      struct swap_ring_iterator *ri;
> >+      struct swap_prio_ring *ring;
> >+      unsigned int queue_idx;
> >+
> >+      if (!swap_queue_len)
> >+              return ERR_PTR(-ENOENT);
> >+
> >+      queue_idx =3D 0;
> >+      while (nr_iter >=3D swap_queue[queue_idx]->size) {
> >+              nr_iter -=3D swap_queue[queue_idx]->size;
> >+              if (++queue_idx >=3D swap_queue_len)
> >+                      return ERR_PTR(-ENOENT);
> >+      }
> >+
> >+      ring =3D swap_queue[queue_idx];
> >+      local_lock(&swap_queue_readers->lock);
> >+      ri =3D this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
> >+      /* Rotate while iterating the ring, just not on the first try */
> >+      if (nr_iter)
> >+              rotate =3D true;
> >+      else if (ri->rr_counter < nr_alloc)
> >+              rotate =3D true;
> >+      else if (ri->offset >=3D ring->size)
> >+              rotate =3D true;
> >+      if (rotate) {
> >+              ri->offset++;
> >+              ri->offset %=3D ring->size;
> >+              ri->rr_counter =3D SWAP_ROUND_ROBIN_QUOTA;
> >+      }
> >+      ri->rr_counter -=3D nr_alloc;
>
> ri->rr_counter is left at 0 so the first allocation on each CPU hits
> ri->rr_counter < nr_alloc and rotates, shifting offset away from
> intended cpu % ring->size start. Initializing rr_counter to
> SWAP_ROUND_ROBIN_QUOTA would avoid this, or is this initial rotation
> perhaps intentional?

Yeah, that's true, it hardly matters as we will do million of
allocation and rotates a lot randomly, so the first allocation is
really trivial. But initlalize it as SWAP_ROUND_ROBIN_QUOTA definately
make it more consistent. Agree on that.

> [...]
>
> > @@ -1245,12 +1580,12 @@ static void add_to_avail_list(struct swap_info_=
struct *si)
> >       unsigned long pages;
> >
> >       spin_lock(&swap_avail_lock);
> >+      spin_lock(&swap_queue_update_lock);
> >
> >       /*
> >-       * Add the device to the avail list if SWP_WRITEOK is set and
> >-       * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
> >-       * SWP_WRITEOK first, so the device won't be re-added after
> >-       * swapoff starts unless swap_device_enable resurrects it.
> >+       * Mark the device as avail if SWP_WRITEOK is set. Swapoff clears
> >+       * SWP_WRITEOK first, so check that first so the device won't be
> >+       * re-added after swapoff started.
> >        */
> >       if (!(si->flags & SWP_WRITEOK))
> >               goto skip;
> >@@ -1261,9 +1596,10 @@ static void add_to_avail_list(struct swap_info_st=
ruct *si)
> >       val =3D atomic_long_fetch_and_relaxed(~SWAP_USAGE_OFFLIST_BIT, &s=
i->inuse_pages);
> >
> >       /*
> >-       * When device is full and device is on the plist, only one updat=
er will
> >-       * see (inuse_pages =3D=3D si->pages) and will call del_from_avai=
l_list. If
> >-       * that updater happen to be here, just skip adding.
> >+       * When device is full and marked as available, one reader will s=
ee
> >+       * (inuse_pages =3D=3D si->pages) and should mark it as unavailab=
le and
> >+       * set SWAP_USAGE_OFFLIST_BIT. If that updater happens to be here=
, just
> >+       * skip the rest.
> >        */
> >       pages =3D si->pages;
> >       if (val =3D=3D pages) {
> >@@ -1273,10 +1609,10 @@ static void add_to_avail_list(struct swap_info_s=
truct *si)
> >                       goto skip;
> >       }
> >
> >+      swap_queue_unmask(si);
> >       plist_add(&si->avail_list, &swap_avail_head);
> >-
> > skip:
> >-      spin_unlock(&swap_avail_lock);
> >+      spin_unlock(&swap_queue_update_lock);
> > }
> swap_avail_lock is acquired but never released when add_to_avail_list()
> returns.

Ah, that really a silly error of mine, in the following commit
swap_avail_lock is completely removed, so I didn't notice that during
review or test. Need to fix this intermeidate commit. Thanks!

>
> [...]
>
> >@@ -3700,6 +4035,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
> >
> >       /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap de=
vice */
> >       percpu_ref_resurrect(&si->users);
> >+      percpu_down_write(&swapon_rwsem);
> >+      error =3D swap_queue_add(si);
> >+      percpu_up_write(&swapon_rwsem);
> >+      if (error)
> >+              goto free_swap_zswap;
> >+
> >       swap_device_enable(si);
> The swapfile is inserted into the ring unmasked before SWP_WRITEOK was se=
t in
> swap_device_enable(). Allocators can pick it and get -EBUSY from
> get_swap_device_info(). How about adding masked and then letting
> swap_device_enable() unmask the new swapfile?

Yeah, that's a good idea. I considered it but thought it wasn't
necessary for the RFC, so I skipped that part. We can definitely do
that, it will also help for some other synchronization issues that are
still present.

Thanks again!

