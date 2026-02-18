Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2987BE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 23:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5296B0088; Wed, 18 Feb 2026 18:40:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD186B0089; Wed, 18 Feb 2026 18:40:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5116B008A; Wed, 18 Feb 2026 18:40:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C619C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:40:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F6EE8B3D8
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:40:38 +0000 (UTC)
X-FDA: 84459199356.25.F7B797E
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81BC6C000B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:40:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jn91rUha;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771458036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjxPiN30X7H58ROVHwhzf4/X04sTDdl8fl/0yuhsL/4=;
	b=v1yH/c9afZJBdg6ovK415876XQNyy+8vzXj+WIqhSQ2yb0M5aZ3Ul0PKgXEiJT05zZLfYa
	QjmGuW7H+Ry3Q12bHeWeQ5J8mB630p+i7Pw5YzBTt43yu+Kvtq4MQPoayq9mMbgdHTTstG
	YdidtmhvJC9fqI2M5wYCJDcS+feVtko=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jn91rUha;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771458036; a=rsa-sha256;
	cv=pass;
	b=hNA7P8VyIZ1XhshB85mUvmH+4csAh2nic2KpnzETODoyVsDZ82gu0txI22TPqYyu5O2SNA
	C/VBefCl/QClw/Rr/rY+OiuqiNuiGfJb1l33oRje2/56Kpp/wA/sIA/Rl9xZhGzCswlNTD
	BS/c1nZ0uaiG8xRBUogV7V/cOMuUcYo=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5033b64256dso200331cf.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:40:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771458035; cv=none;
        d=google.com; s=arc-20240605;
        b=hNXEUjU8v5spO8XNWDk4UttNprH7/2qs9Ui6v3lsL4NN5H7+WuDHPEi1yK+pXK8tDK
         KnFGlgns7zo8iQiw1etW71njzUMZ/zCspS7rxiHYz0r4qxBMKosmmDF7V3dSNpNQH7x3
         6q8bAyDT2Of3fnP1eA8cJAvcMI6Ae+QPl3jtDPvii+b7qc8NYQ7dKAEZyERL/RvUSQ8c
         SH9R3dMeIocsN3pI3cOUm9tHw9xHFRjwHQnO7NUjto5KM8Yz2GtTpgFZD+dTFCikQEqK
         XL/FLuRx+DpJlYUm0ROJNjzGehzhUWrCy/Sf6CkmOOKzfdXTHZVXqB7XMctXiyxRyJTK
         d9Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xjxPiN30X7H58ROVHwhzf4/X04sTDdl8fl/0yuhsL/4=;
        fh=McHcuTt6i9dZSL9nR0viKEm/VP8TbSvrpr8kNRLs5GM=;
        b=S7LRVI9QdEngVNObdtV2aN+mshgHPotxhc9fn/Xfa0d8+R4Wk+lR7iPS9G8rufeaKb
         D1EGm8baF2/0Dr4+LUUquEWc2yUENE0Afyxh97h1xX+dZMAtQVnAFL+L4q4UFqcHVm9E
         FlL2PV3cgrEc41alUi8epqfpA8rSHvElC+tGPMK8SPDzEhgMYTFndRZXyxK0tTC4M7NA
         VrWR+Vt3c4wo+ESB1/OfKv/fPvMWk8U1vdGqWSFqqNAS7TSNSe6iU6UNHgGUOhGTSmOx
         3B0KtghmDsxSeQc9i92PLJEX5QP/r+F8ehH6/eX/TIhz0e2z5WBUlg8TXR8TquJaqksP
         8HcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771458035; x=1772062835; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjxPiN30X7H58ROVHwhzf4/X04sTDdl8fl/0yuhsL/4=;
        b=jn91rUhazqAU7yghkQ5XFinnFJaSOgSohIjtKwAU0A5ZcKRUwAcJT8AjtiU7SicrvB
         Ibti2dJxBIr1tYrOHreWhkFQJBnLtKvQX0HWRMj3P1x5o+46dVjSFepjoD75QhP87QI2
         cTSMdtnMvdwcTCaz1enWBGDt90+4m1eIonVhDr85X140vUTa3QIggYrrIexyj406F9J7
         vBwr/PRK+WX1f7WxATRJ8AxPPrqLBpWoY/tWv+8PKNQJn5ix1R70mhL/fMaBp83nI90F
         Ya/TdA5zUkvmTuOovN8X5n89d+HQrThwQmhtBhvbkb0pjUVtwRLsM0s4zft//CUIo6hP
         sJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771458035; x=1772062835;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xjxPiN30X7H58ROVHwhzf4/X04sTDdl8fl/0yuhsL/4=;
        b=GxPvtuG6Koft+mIn9rgT8ZhwtUATI4EDRcQ9hE+tIk0K7lAKnR32idABgxGEGB5Ocw
         Tc2HkjEwjETNybfu97bxzMMg21Osuh86QW93pFuY5lm/SjPpPW7ipc+E73sW+bjq3/LL
         oCna29/+Lfke/mlMsuCN2+IWKnTqMG4Yz90oUm4sNUOjcukqQCPGjOq/tp9M3Y61+MkU
         9kvNxgJH42PtlJ9D5WglS78GrvH/DNfpJf/+ER6Ye0E2vwrWRZh9KL9VvlVTO6xruHp3
         qgbE3ZM/Ce4LHVE6Ich1WenBjVTB7C8IKxdy1XCtHx6eWesIzMfM615FxIE9X8bA+aeN
         /jRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMZtP4VCpiwEtQ9ob1CAHXrVJZ3r/4Pshqu8JWnxT55cU8gPTgALd+g/Kk4VK7QFEmRWpjk5/E6A==@kvack.org
X-Gm-Message-State: AOJu0Yy5vVeOiQe9Aa4pCkaHMDR45oPSeKrtHwNj+ug0uEIaqSfVIwKS
	EVYKFl5vBuaj4sbMVjgSModI8Szc3RZ/tH0gqM5lvlrlhr2dFBqe3K6NVaX6pCSSon/x/VWmtqm
	s/2M+8rZVp1rpGEdJcKdbg8Lz91JIeKaYhXkw1o2r
X-Gm-Gg: AZuq6aJsCAeQczMF8lX2NT4s0cN5g5AKWxutXV36xkdcgcQAu3Vp242RyUNDxmwrIb1
	UyEGhNGE1IpBOWBJsTu6HRb/G0qh5VAt2wvBScnp95qfPXvW+/7Nm1NtxsmMencYpFzCdni9xXu
	G5bpxc8mn3CvrajLMC5FORmX9mZ4K65VAKAJjJdL464m2d7NzeKV2vf8Z0Uzka6OtB5nrJfzLR0
	BWY+AvZ5HVUFfYItUVzq4qoWW+uu8hzFFmq15FABgIgDrBelfKruGj3fJc5hdAZq0f4y/WVnqOp
	HcnVJg==
X-Received: by 2002:a05:622a:1a8d:b0:506:1f23:e22c with SMTP id
 d75a77b69052e-506f1dbd1b1mr2143471cf.6.1771458034886; Wed, 18 Feb 2026
 15:40:34 -0800 (PST)
MIME-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com> <20260217163250.2326001-3-surenb@google.com>
 <dtdfrko7uqif6flc4mefnlar7wnmrbyswfu7bvb2ar24gkeejo@ypzhmyklbeh7>
 <CAJuCfpGViU4dDaLtPR8U0C+=FXO=1TuU-hT3fypNQO3LGOjbcA@mail.gmail.com> <lfnqadtmpkxjhsne3nto6bpourjv3nxw26y2a5kovump3beld7@c2pdvgxxj3ar>
In-Reply-To: <lfnqadtmpkxjhsne3nto6bpourjv3nxw26y2a5kovump3beld7@c2pdvgxxj3ar>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Feb 2026 15:40:23 -0800
X-Gm-Features: AaiRm53lCb3-A9mP4T-Ip4RZ_UT27OIlQVbKAc0RvblZzhy-3EiGT7cqg8sX1Wc
Message-ID: <CAJuCfpFr-MvDAo5wur0gGX-AMCd2kP=pBYOemwAP=G3UUVP4vQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81BC6C000B
X-Stat-Signature: pja8ca4istrk857zikd6aia6bw7rkk6n
X-Rspam-User: 
X-HE-Tag: 1771458036-558701
X-HE-Meta: U2FsdGVkX1++V0COVCnxF4vIIVhhYeKREqK/PWAS6I7WjLTh+PKp50kxNSKq2ASroDAQgpyEkzvv/cxcSbMIDwz2etZ81CMOZA/UBgsMB9pDWv5AVxrO4/SBVk4sW40w3896OTYoTYpVprlEjMqblF5Zp7RpguyPmG6yiWdxcG58y85NV18U8N0VOZ96w2r1PeVe4OK6vqmz1La50CR88uo8641w3OCa21QPboVJNoy8Tfx/7PSlug24c/vWdHujqOrWBBd7OjXrQVNt6wXb2+e08Jafo3OoDHqWeBxUajd95R2M1iMXCnkUiuRbclat9BRMwGvLZJghx3iV2im5O1Cw60N8dIYpDgWzWqxRaU2BN+f2MUFkZGB81JDipY8NgqJ+3V8MBF/NrFWj66rWQffuJweNyCklNJGxIVv6BtYwwvpqodjoPZEXGp8x2hSMiSjnU8LTNGmOl3uQQ7OOSqd3ETeKnxwPzxaFgnfhEHTgomr3eqvzxc90DHZu3oHjTIcXvS6Npm+KR0PwRkS3RH1i5Pgx8aLPfrW49PYfV8DEaJxOCxlm2hXJ2iS0uFlz1Px5S15Zhh5Q0hnQv8jFxghrgjdzSAeW2jNOjVV48Gco9r4mHmSaL8omrQSrvnvqvqphATBoB6VeeyaU0XKh7jfyX/D3QqlLYJzJDUrFhawHuEa7G2b8yz/7rFnzfsLSpNmYTO61bu0ENAi/tJbZEui4KpjqDfnEoSrQ8ydbNBKnenESNlBmNkZhLOIg0RG9GphfAPssejwlZbKxSj0YGKlk237+AH8ennwWQUwOFmsaWe77erV5fIAs/hxVW7hbspnNZCVRyJH8odxl7l2V1RoxbHqrwEcCl7X6etiDsjXC+8vrtZmPdiW+urit+K4XlAP7BT6J0idHn2j3DHRX2PLe1mybvZT5v7etEtdjoo0Gpg+wxWZkKvxnXlv86+II21pxJuz+Y6FMsXdib7l
 p+WoYHxn
 1mVJ6bjSw8y0Wq5efeTEl2LGER0+S0lNmHU3Q6A4AwBjuEKe46LKUBVhwBm4Xo5qs+k7fOxrjwN3ZStXw3gIs9Ff0+QT+szcZyaQGT0EEXwSVYpTVbyU4OTr48cfC7xibh5iJNy4wNnjegN2BIaE6IP4ICg/xqoAeRGqyv3rNlHVpOYoykKuKCbBXebtbm4rjaHROb47DHeTjpQrdNmooGlaRg7xx7quR0InfjN3mMS5s/6T4tml6zdZiFFIrKnKIdTgHNbQsG5duizKO45rI8GUTG2174awMj8ie79lJVy657MEnPpNeLYvPZP0NGuFf5itZEnhxeKppjUE8+iMZ1jKLQcgSb4YHO4JYMH5pXZZaixZcTfx26iQbx7OWBWCJ70hEG3dmgBGVb3fgI5ukAvl6HrGVXIGigMU3aavTydbGMLcgQ+lAOjCyZzVsyvRfPO0Psb4dhkeXM4Y+i32VhpxiqzIlKimSGgriwNxo0U9UxRAimg0jrB/JeuT4dOA2cy7VqrvoL9p7I8E/sj3drqe40g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 8:46=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260217 16:03]:
> > On Tue, Feb 17, 2026 at 11:19=E2=80=AFAM Liam R. Howlett
> > <Liam.Howlett@oracle.com> wrote:
> > >
> > > * Suren Baghdasaryan <surenb@google.com> [260217 11:33]:
> > > > Now that we have vma_start_write_killable() we can replace most of =
the
> > > > vma_start_write() calls with it, improving reaction time to the kil=
l
> > > > signal.
> > > >
> > > > There are several places which are left untouched by this patch:
> > > >
> > > > 1. free_pgtables() because function should free page tables even if=
 a
> > > > fatal signal is pending.
> > > >
> > > > 2. process_vma_walk_lock(), which requires changes in its callers a=
nd
> > > > will be handled in the next patch.
> > > >
> > > > 3. userfaultd code, where some paths calling vma_start_write() can
> > > > handle EINTR and some can't without a deeper code refactoring.
> > > >
> > > > 4. vm_flags_{set|mod|clear} require refactoring that involves movin=
g
> > > > vma_start_write() out of these functions and replacing it with
> > > > vma_assert_write_locked(), then callers of these functions should
> > > > lock the vma themselves using vma_start_write_killable() whenever
> > > > possible.
> > > >
> > > > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
> > > > ---
> > > >  arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
> > > >  include/linux/mempolicy.h          |  5 +-
> > > >  mm/khugepaged.c                    |  5 +-
> > > >  mm/madvise.c                       |  4 +-
> > > >  mm/memory.c                        |  2 +
> > > >  mm/mempolicy.c                     | 23 ++++++--
> > > >  mm/mlock.c                         | 20 +++++--
> > > >  mm/mprotect.c                      |  4 +-
> > > >  mm/mremap.c                        |  4 +-
> > > >  mm/vma.c                           | 93 +++++++++++++++++++++-----=
----
> > > >  mm/vma_exec.c                      |  6 +-
> > > >  11 files changed, 123 insertions(+), 48 deletions(-)
> > > >
>
> ...
>
> > >
> > >
> > > ...
> > >
> > > > @@ -3089,7 +3120,7 @@ int expand_upwards(struct vm_area_struct *vma=
, unsigned long address)
> > >
> > > Good luck testing this one.
> >
> > Yeah... Any suggestions for tests I should use?
>
> I think you have to either isolate it or boot parisc.
>
> To boot parisc, you can use the debian hppa image [1].  The file is a
> zip file which can be decompressed to a qcow2, initrd, and kernel.  You
> can boot with qemu-system-hppa (debian has this in qemu-system-misc
> package), there is a readme that has a boot line as well.
>
> Building can be done using the cross-compiler tools for hppa [2] and the
> make command with CROSS_COMPILE=3D<path>/bin/hppa64-linux-

Ah, I thought you were referring to the difficulty of finding specific
tests to verify this change but these instructions are helpful too.
Thanks!


>
> Cheers,
> Liam
>
> [1]. https://people.debian.org/~gio/dqib/
> [2]. https://cdn.kernel.org/pub/tools/crosstool/files/bin/x86_64/15.2.0/
>
>

