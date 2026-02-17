Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E80AE9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3AFE6B00A8; Tue, 17 Feb 2026 15:15:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11786B00A9; Tue, 17 Feb 2026 15:15:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14106B00AA; Tue, 17 Feb 2026 15:15:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9BF26B00A8
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:15:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70D5E1A034E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:15:18 +0000 (UTC)
X-FDA: 84455053116.07.75AC68E
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E4EBC000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:15:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IUWStll4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771359316; a=rsa-sha256;
	cv=pass;
	b=Qu7o4FvtvoYMC2mz0zG11cwACeltwaudmzLiHlqlZtWSFG/ckr0pajxhtX4hDyi95rytip
	RRP/5tNm+CaTr+r6dRIk/npkpKlAMIm3B3GNzfLlrgVqdFzmm1SmNrTxZtX3fwBvbRgfi4
	zGUoXl8Dv+JNMR46n/nBjYVaL+fKuYY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IUWStll4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771359316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zMl2Yu1W1bveqwK3ZOC1P/exlFIcqbtGooOQsCvJX8=;
	b=L5tLVNePNG+SgF628lQTV5lcd8f0II/n/yJ25kj1HCgjwOzjtowoL60Qdtw47OfDcTvWMw
	FONnJfRr/zU5/go8MpCrc8awtNx6F8fjiP3RUmr86TDYilu9Nh5yoZmpd6cICFs26/GMdj
	6MP30kIKEAILhdjkMu7ddQ1oZHPEirg=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43638a3330dso3604409f8f.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:15:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771359315; cv=none;
        d=google.com; s=arc-20240605;
        b=DGUojTQofMnQQ5LUUhXvl5g9TYlz8zWz+gUri+wU9/IkVqnO+9rOfGqfjyBxGBZbUX
         AJVHs8R6f8PDA9aR1WFey/Lhh0T3Pki8y9gdmQtzUIL8acpUJo3PEZrNt/YxHZHnrL+H
         2HUP9HQp4UIQDaAmjMGcjnyKY7mcPeWnUj2D4TDoP1mwZ4UAfn9qQtpiUFsYrggdHI5/
         abNrG5k9H/GzPz1TAyOFQLDDPfRrP5PiJ7lHvZgFaMVrcJR8qsV6D5yrbBWVulCOV3Ik
         iMq1xNHpWIOGunjeMJv/yVLJJ0tAvIZROkVxIz6uB8ygN6y7OlVaQIlDlZ4d/Skm2gFM
         Ul8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9zMl2Yu1W1bveqwK3ZOC1P/exlFIcqbtGooOQsCvJX8=;
        fh=YJ1qpAFvAD06HtyT3CdWYi9PqbA4iIb+zus/M3maFmE=;
        b=Y7a+HbP3TIfzdTmanI79ucvDRktMwHBwBr6Ky3ebGhzBmyIAisYfGLjQcWx6hXyAn3
         GVc0bKh3v+DIE2n7j1K5J3P4odCuJ4huIFq6qBwdacp2852lhkbma+MKI9TYJOB7K3wL
         971GOVgVKfsIPs3M3PJGVpXK2X3g6gG38H3pf79ZreZR3i76aZBkxAPXEHoGCurU/niD
         sC6FRiE8A2xJ0t5tXM5L11tpRaw1AaWabmLwmSatss481eTheNURNQpduW6jcyCPxpNe
         NduoZoC5HBndlg1zpLuvH/nDF3li5xNYgoiu1MGGAgrada38qGOjZRJwnA+H9tEB9zaq
         bs+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771359315; x=1771964115; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zMl2Yu1W1bveqwK3ZOC1P/exlFIcqbtGooOQsCvJX8=;
        b=IUWStll46w59gp9zB3qAmNpPzleFp8CG9DfVnjkdhZ0APwWbjE3vrVLmhSOA8EkLCk
         w8aLgetSmjI9IUpUGsXN2cRnYeeNWkm5uIwMScBA70UtcRNCiAYZ7/FnYE0mVRfiwzSF
         ylpFwzM69oEE/ZG9GKSUdNekGqJC0Oksx0YEQtO/3Bfd6pdh6Sv9zMD39b9+gi2zy1Tb
         9/y9Qx+22uufcrFwwnDmZvBza4oK6ku/VLNSObeWs6KNSkcHkuimWbRQ1lUUWMIlzBNt
         r3bLhUijXr8cXhbzYFgPSwkAlcnC9SptDowONQhax5CtJ7Mwatbk5eTADjxIrsioSdYy
         XwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771359315; x=1771964115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9zMl2Yu1W1bveqwK3ZOC1P/exlFIcqbtGooOQsCvJX8=;
        b=nY/eCBLBcZiIoxONaDUqDN/YPI+lZaSnptSs1n1I+Zc6c2WhCA+wQMdtr5r7/3OVJ6
         GYpXEkl81H1cIXhI7w2ZuQlepcYnnepjNqitHDfFjQZSKzFs8KVQ1gYcs3PRMLziQehQ
         E1hG0uNzKebsnlwIK+TRV3vLVlXXUGwobNJeGz4Z5FevA6kjdwFX/z4RjsFSYeeMiwon
         JAAq7QidISzqzVQl8IV8ufbrZ4seWdTq1SKV4hgduTLwgiDsd31xZmGFkbKlPcJzW/Yl
         z6HzwyecU02s/oqkAbHzQgLrtK+a2y5q4x8LPN4teISwNC4iEK7548T+f4te4NrN1Zku
         F/mg==
X-Forwarded-Encrypted: i=1; AJvYcCVeZWNSI70qFQNv3QGOYlzyrmoZzYksQcdbr+jzhLAQdZmoWFT9F7etS9oXLfnfdaWv78WXhKodLg==@kvack.org
X-Gm-Message-State: AOJu0YzbqXSMHpo/ylY7yO9Seq1vN/QYpd9TBwrG+SdAQIKAoFGG0Sdc
	fc2MZzv2Sh4ITr58uI9ZRlhz0Y+ES1v3qI9A1oZRHWHrEOz0zanr2J1q84A88NcjZHrb4j6lyf9
	uewtlOMwYYqTaslDr8XpoWRULRwMqo3tgccPkQs0j
X-Gm-Gg: AZuq6aJ5bDhD868aBxXeJd8+bIlssC47I8xao+DKfWO9Gfr44YJR/Vf1augs8VNr3Fh
	mENZvkh+fBgEZ/35UgCf7ZW03O/qGfBz/0SUnR43ilH9MTLD1xNkflLOn7rLISmXmvYQ5162gYJ
	LEVtvbVlGkNEGrGSWD5jCbassEd3Dxsc2x6R+NZEooRWLpnJ2P/UTW6VNeI3aaCZ7Xx9YHtAPfj
	RBzKa0tN00PMOHtMSIEZEduCZ8ysHrKpvD8l6D02eH783X5n3rDm1fr0qr4svKdgZeTjz36FyTv
	hWncarW9+Upi+FhdgICN0F40luaODk4L/lXDtA==
X-Received: by 2002:a05:6000:2906:b0:435:9d3f:92eb with SMTP id
 ffacd0b85a97d-4379db31ac3mr21538377f8f.1.1771359314340; Tue, 17 Feb 2026
 12:15:14 -0800 (PST)
MIME-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
 <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com> <CAG48ez2mUQ-D3jpPbvdZzcOz16LMXRnzcudOZsfdoftBF5yvPA@mail.gmail.com>
In-Reply-To: <CAG48ez2mUQ-D3jpPbvdZzcOz16LMXRnzcudOZsfdoftBF5yvPA@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 17 Feb 2026 21:15:01 +0100
X-Gm-Features: AaiRm52lAtTK24I1jWSIFWbocsxLAqep13HDwqT0r-mfbjL1WzrnLQsvrZePKok
Message-ID: <CAH5fLghCCAvOi+xRtPnD4ToQmyignjkn-PJ6xG6Y1DAUHgBKVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust_binder: check ownership before using vma
To: Jann Horn <jannh@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5E4EBC000C
X-Stat-Signature: 4zkwdfj9gbpi98pon1sqnhx6jhnpwwok
X-HE-Tag: 1771359316-616023
X-HE-Meta: U2FsdGVkX1+/qdus2KugUPfp3el9HntQDR0RhLr8mqv2m4OJegtbZ0I7M3dGNJElX6A8vgfS/QmJqve/PVOTYL/ZvZyFU17lMuUgPY3h1BkKyyjtePTjw31jRz48rMR/p1zorTeQWtECAho3A7hzbyNMQ4OJj5jgDP9A3brP3Z2JSMefteNDqh5tUaUu62h+r9dviv1XV5RyJw4vBWSG9QGWOnPP87MIzbwFMLO1vmjw19yWhZyLGIk9u2w4oiAzcUY6i+4mnR9WjZFSZ8s3YTKYE/3QqUEdmfVCA7I7WyF7XYWItY9UM+mn83gTqbR5sQw2ybmEpL28A+7KRdckqGQS/wtr/k3lcwzYzRlE6sdKutDO2kJbn3ZoeovUM0lBgthjdX52ISIMyGWYz9ZJ+xtJnYu2zTACMaT2hH8O48wljLN3yXfL8bM42lLJTpIQ8WCPfv0Z6lVv91ga9NjX53umYteADq/wcBbGLjy8pqTiIWBmPM1JRrmaiPR85NhgAkSzpiUVAoLUszhObjMaXqSy8xSbbQpf8EB12NwPFkmhiZ/W9bGYs1yVscXqPuW57z2g7JId9a31CMTl/Eib7Z4dr7rJrEof//jNy03n12cl1Y8JiFTRfEmc9NKTYltdqT/jzW8ql1taqxxbmyuK2fP2NigB3ztftERElSEXPasazm/iZYwmCd3prJUqSHpOKg/BxiBTptv48vE7wPtTxOyVbu3tl6ugsUrQRB23rNO6M8PzbpWH7EBghfvxzP9/dh/SqzHzlL+yCc4crARcc1sITahs18pcD5Egffe2fOLbsPel7ImyOTab1AJo56C2646VFcD0QxDp015UpgKKE0pp4P1/jniqbp22ZyQW1cvygmK2PvhzDzPx1IRgFUzxt0eBDSfSFBYu4de58X6XrffYEUbSFoIuKJjh2hKMBwaiv3PFmJe1t8UM9H84sauBGoz32HW73Nw+IPAKRnH
 WGtyE+iz
 XeCc8wFmzWVn7uiLFAxoDFrEYbDJhRpVQlmcVgVE0VIWFHfFGvDfV3AHkb1dqwH+CLPZnlAbX0zRxPG7PRaVc3XU8YdbUxERNmSUV30ODs1CEFvbp3MkBHt+c0YVDeBn92HvEPp7XBv401CkLKlHiz4yZ74Mc62wFBYHGcQ3s4TVBv6XUMRPnR7HWjWnU3CNZX4XfaI6UeeAItJxZFqIWOW2mzdzYBuOI6UJIo9UtM+HWmksquMpwTQMGWyGuPlMZ9tQIyridXY5RY/Ap1d79jAWccCj6xDpR5v4BrOB1uahzDN9EWOr1FQFfgEESplwPFHb/GbPPUyu/heI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 5:55=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On Tue, Feb 17, 2026 at 3:22=E2=80=AFPM Alice Ryhl <aliceryhl@google.com>=
 wrote:
> > When installing missing pages (or zapping them), Rust Binder will look
> > up the vma in the mm by address, and then call vm_insert_page (or
> > zap_page_range_single). However, if the vma is closed and replaced with
> > a different vma at the same address, this can lead to Rust Binder
> > installing pages into the wrong vma.
> >
> > By installing the page into a writable vma, it becomes possible to writ=
e
> > to your own binder pages, which are normally read-only. Although you're
> > not supposed to be able to write to those pages, the intent behind the
> > design of Rust Binder is that even if you get that ability, it should n=
ot
> > lead to anything bad. Unfortunately, due to another bug, that is not th=
e
> > case.
> >
> > To fix this, I will store a pointer in vm_private_data and check that
> > the vma returned by vma_lookup() has the right vm_ops and
> > vm_private_data before trying to use the vma. This should ensure that
> > Rust Binder will refuse to interact with any other VMA. I will follow u=
p
> > this patch with more vma abstractions to avoid this unsafe access to
> > vm_ops and vm_private_data, but for now I'd like to start with the
> > simplest possible fix.
>
> This sounds good to me.
> (Userspace could still trick Rust Binder into accessing the VMA at the
> wrong offset, but nothing will go wrong in that case.)

Vma is tricky stuff.

I think if I add the vm_ops->close callback this one isn't possible anymore=
?

> > C Binder performs the same check in a slightly different way: it
> > provides a vm_ops->close that sets a boolean to true, then checks that
> > boolean after calling vma_lookup(), but I think this is more fragile
> > than the solution in this patch. (We probably still want to do both, bu=
t
> > I'll add the vm_ops->close callback with the follow-up vma API changes.=
)
> >
> > Cc: stable@vger.kernel.org
> > Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> > Reported-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>
> Reviewed-by: Jann Horn <jannh@google.com>
>
> > ---
> >  drivers/android/binder/page_range.rs | 78 +++++++++++++++++++++++++++-=
--------
> >  1 file changed, 58 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/android/binder/page_range.rs b/drivers/android/bin=
der/page_range.rs
> > index fdd97112ef5c8b2341e498dc3567b659f05e3fd7..90bab18961443c6e59699cb=
7345e41e0db80f0dd 100644
> > --- a/drivers/android/binder/page_range.rs
> > +++ b/drivers/android/binder/page_range.rs
> > @@ -142,6 +142,27 @@ pub(crate) struct ShrinkablePageRange {
> >      _pin: PhantomPinned,
> >  }
> >
> > +// We do not define any ops. For now, used only to check identity of v=
mas.
> > +static BINDER_VM_OPS: bindings::vm_operations_struct =3D pin_init::zer=
oed();
> > +
> > +// To ensure that we do not accidentally install pages into or zap pag=
es from the wrong vma, we
> > +// check its vm_ops and private data before using it.
> > +fn check_vma(vma: &virt::VmaRef, owner: *const ShrinkablePageRange) ->=
 Option<&virt::VmaMixedMap> {
> > +    // SAFETY: Just reading the vm_ops pointer of any active vma is sa=
fe.
> > +    let vm_ops =3D unsafe { (*vma.as_ptr()).vm_ops };
> > +    if !ptr::eq(vm_ops, &BINDER_VM_OPS) {
> > +        return None;
> > +    }
> > +
> > +    // SAFETY: Reading the vm_private_data pointer of a binder-owned v=
ma is safe.
> > +    let vm_private_data =3D unsafe { (*vma.as_ptr()).vm_private_data }=
;
> > +    if !ptr::eq(vm_private_data, owner.cast()) {
> > +        return None;
> > +    }
>
> (And the ShrinkablePageRange is only dropped when the Process is
> dropped, which only happens once the file's ->release handler is
> invoked, which means the ShrinkablePageRange outlives any VMA
> associated with it, so there can't be any false positives due to
> pointer reuse here.)

Yeah.

Alice

