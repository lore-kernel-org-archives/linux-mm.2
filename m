Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D05C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AB98E0089; Thu, 24 Jul 2025 10:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3F08E007C; Thu, 24 Jul 2025 10:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795418E0089; Thu, 24 Jul 2025 10:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64D578E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:29:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3447158E69
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:29:59 +0000 (UTC)
X-FDA: 83699392518.07.D6C34B3
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4B35520016
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:29:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ywFB9DLR;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753367397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FlhcpDPJ/zf5PjQewozCSVSh7GoDUgf457I2X0B4PcQ=;
	b=MuCMDJPhxyWn1WpMVpoEnean68RFHsXVYc3oYuy8o1vzKNnOCrwGcigUidczQMyJ7RnHJL
	9UKcpmhkUoPvWsKGan/FT+Uw2NbDkHFkxpRt0lmqg09tGzJKLmfCei75dx3432Ea6lDauA
	+r4XnHbZ/Qh9R4cLinOx9J7lD3rvSPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753367397; a=rsa-sha256;
	cv=none;
	b=1a2s1vW19mcAW39Uuel5EE20G3JIxQrTi4aH6GXzPXPXxgNe9m+eu3sskCdcVXgaXhEd9Y
	u3e2E7w7z7khIxHLWaDXCil24+qJ9lBaW3W2xmLWzl9CO6vKfK+W+mDxxhhRv+P8y94kSZ
	toIAfuISm6rG0wpOGeoHvWpL9WGMtso=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ywFB9DLR;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so9060a12.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753367396; x=1753972196; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FlhcpDPJ/zf5PjQewozCSVSh7GoDUgf457I2X0B4PcQ=;
        b=ywFB9DLRQRqlUbRrS9+Rz5ocAMT8XU6F4X1ylg2S8dxJeGDgKUk5Xss1FLPi63KEa8
         63u6gtfihKjvCRh+gGvP+AnVsMkWc9S1BInyRehh+0U98YHWar4okpAen+yHwX2m5Ef0
         SzinW1k4rox6Jh1A8ZZKr/eFNyIbNjPhu7Eok4ZHsZgzxjagv6zTTletw9t9GgSdTp9u
         l7lYTg9uhIYl9zD+2u0THHnVulFGFAg0XCxtK8w/ZX0udreeHmynAnMtkNyN0oMBBUC1
         NKw+PZNEVNwvmo4eGprJU3NiAYP6crw0+oMNAzsfj089WCbl+vbIQP7IT4GEKs1rGANj
         oB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753367396; x=1753972196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FlhcpDPJ/zf5PjQewozCSVSh7GoDUgf457I2X0B4PcQ=;
        b=ee3bTZadLT9kktsYHpyGCzgINcPyDhynnbcZEn/GDmq4XiLeU2bJIHeXg98sOs+5qV
         DlhHVKWP5mDLzW55yb5fdPUJ0MQS7z92PuMgc6jTWI9pju31CTC1XFaxKuoHCWIoY1p8
         abKtKjSIHNFkTvqx788JCLEHNWK3q4NYTLiInqI2taf7SYjTypFan48AlTm+ze5XN6uh
         t5R6ErH8MSw7bwbR9/2+/QWHCI4jlmKPXv7kWEO/9lQ5hFxlOzRq0nK3ZmObdokj2OwQ
         8S4yZIuKmZYqTrDwuirrkZQopQycVSi+19/xrihrIERSg8wDOpBP4FvRio3jZjJQM7fa
         b1rA==
X-Forwarded-Encrypted: i=1; AJvYcCVptpomvJH8WbpEAa4YwnwX377wYW1i+3+uTjAPkzCVnUUy/+y/cdsb396mtVoFSZ+gzcNjpoC3Cg==@kvack.org
X-Gm-Message-State: AOJu0YxKC0RZc7LKKjV/KW7yb+SoLmv2E1H6iva+olWPAcQqnSrLTjKg
	ucVNmvacBrAc3tDAAVE/zpODmIaj3pB8T4Q7BdlLbksEebk81u/bV7MiP11Mc/mcK9/9FN0IpW7
	XaYkuYeAI5vm3xRnPW84SJM3DBcgfCk3FSXwa5mEh
X-Gm-Gg: ASbGncsWso2hlE1xn5G+Rx8zAQmS54aqa5az+kPrzgL3osW+qVs0eGIlV542Ddkbvqq
	X6f7SQWe5oCsiU4lBeYSFbnw68yVQJ5tpntyTOoavrgRWUBvtOKZLVK9rwdlOCHTXO2bPPCRNsC
	MjA0qXc6xNsOJru38q0VwGwtAm40TRnj28DtxAX0dhAvd6o8HVfRF2yQBqYJAJwizqYMpDSHlYa
	Lg579o+xqjaCMN7RrjRF/sIFL0TQ926iIn55l6uOlQrKpaS
X-Google-Smtp-Source: AGHT+IFnzfnkL7IMifLfz57vgfmQBM0IvNePvt8oCAV9PXZXiY5Zcoi2sHhp40dEdBN6gXkrNPjSmbr628hsdVXAWto=
X-Received: by 2002:a05:6402:20ca:b0:60e:3d45:c65a with SMTP id
 4fb4d7f45d1cf-614cce46f4emr80233a12.5.1753367395396; Thu, 24 Jul 2025
 07:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
 <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com>
 <702ab3bb-db4c-49cb-bb77-4e864cae610e@suse.cz> <dbc20783-0ff5-4902-bd73-e9282bfd87ba@lucifer.local>
In-Reply-To: <dbc20783-0ff5-4902-bd73-e9282bfd87ba@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 24 Jul 2025 07:29:42 -0700
X-Gm-Features: Ac12FXwkwryuiZ7qVX6VVH1hTJoQ17odUJToEjarcBlX6QEUdlzMhlFWhWvKrTQ
Message-ID: <CAJuCfpEVrpHACx2G2=Gq7YadxkA-DnFpFmbUij=Xr1=w7yrLbg@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B35520016
X-Stat-Signature: ca7qbbmcssewb8kqofaeji5wrcpgub6z
X-Rspam-User: 
X-HE-Tag: 1753367397-440493
X-HE-Meta: U2FsdGVkX197/jBSIlHf1AagJf7BLOWUwcmVCyhwrLDWfFXItzyNq3WUxY64p29Ie2ljqTd0JH/2aowYQcHQOhEXq9Vp+zfdYgq3wFo7xXhYUUenc76bs+dLfDq2RlORQO7YXrrj2mkw53YNM2Q6jaK/eFufhmo76dh0I9S+1WEZbiz0aORmIj91H1/gwau8Ty+5MwM430dPQ2CHnZB8pOXTVv6EJ72naFpKeeUKR2wh0QgY/uEDxtp0M6kFtPhfp5QGp8vXL1X6lOGgVIHm6hX16DlmTf8f71dU//Ly5SUjvhyJwwaBPPZf08UEbTfWPFFfxsk/vscZrjLbbhZNwJnZA3dJ0jwCRr66GnthzPsDA1emKaOqQ+mba/tXcq1jJHyik9trPwKSFszIkL+JXBJKW5FhKBcbKRAV6U+1jULphnHA2f4c9eWvoh43h8SvgUKkEImvHEFluIWZE5tu27m80TOfm+JxIA3uPhLqWa5uCZe34ZwCv/3LAuJzBDQWkHfxnd0KBhzXQnEn01jhGbYQR1wpTwRC/monnFmpx9Chi+Dad31J/QoV6hnpCj3zox4F9ePdxv0QRok0VO04mdK0H/6RpVORUh8t4Xr+Beuex1aTLcpem5js5+LKbuNKksfWLfTngkupqqs2ubGSATEqKxvi/VUb1BDda+J3eWlWs7DcxJv/jUTWeY/b+j/NNVvVy2g8ZIoiH6rnnLQcNjaQzEBIFJfSsMfte+TbB75mVxN5TKg5IcF1RvDX6I+8VaFqg77ehXm873igRCQvUH7nJ05M1p7u4Zaow5Bspdss83XF+lGEAnPbp9wDcyu2U7156ALVl6DEQBk8RVqK/FGE2sy++GInt6GkUbNTlvrDxV/htGgpZ5cfo0l5c3K2N5kZe069fS6KmCtBvo4aCXAV/eKJ1KHcZpKqzZLAMgB7TkzA1x5b+ZUGvsAo2Hkmnehsno/xiIGgfG/bG+n
 0my/Xms/
 ie44RjnRkFDv7PxmXoVfHYR/IhY7+SP1/rnInZyNPkbNA5htPN5rX6CjQ9FQUph4o7ZNFu9WZnglK/4Rh6sKSu0aq57HR4G68U6BpDp22PHndWwp3v2PuFRc9VGA59k8TsYV5B2DgGT617uwaYAX26n6iEZYxT+PBj2LDlsKvYgwb75SYWV7KB3A7Nnr3IhSF+H34SK92G1HNu5nTjRNuO0V12OgrMQsg7emYBA0kia9EgVFFw6U3hbgx7KuMQ+bSEvG8mDXMMiLUF8s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 3:53=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Jul 24, 2025 at 10:38:06AM +0200, Vlastimil Babka wrote:
> > On 7/24/25 04:30, Suren Baghdasaryan wrote:
> > > So, I think vma_refcount_put() can mmgrab(vma->mm) before calling
> > > __refcount_dec_and_test(), to stabilize that mm and then mmdrop()
> > > after it calls rcuwait_wake_up(). What do you think about this
> > > approach, folks?
> >
> > Yeah except it would be wasteful to do for all vma_refcount_put(). Shou=
ld be
> > enough to have this version (as Jann suggested) for inval_end_read: par=
t of
> > lock_vma_under_rcu.

Yes, definitely.

> > I think we need it also for the vma_refcount_put() done
> > in vma_start_read() when we fail the seqcount check? I think in that ca=
se
> > the same thing can be happening too, just with different race windows?

Yes.

> >
> > Also as Jann suggested, maybe it's not great (or even safe) to perform
> > __mmdrop() under rcu? And maybe some vma_start_read() users are even mo=
re
> > restricted? Maybe then we'd need to make __mmdrop_delayed() not RT-only=
, and
> > use that.
>
> Agreed that doing this under RCU seems unwise.
>
> I know PTL relies on this as well as zap PTE page table reclaim, likely t=
hese
> wouldn't interact with an mm going away (you'd hope!) but it seems unwise=
 to
> play around with assumptions here.

__mmdrop_delayed() is a viable option but I would hate adding
mm->delayed_drop for !CONFIG_PREEMPT_RT just for this one case.
Alternatively, we don't need to be in the rcu read section when we
call vma_end_read() inside lock_vma_under_rcu(). We refcounted the
vma, so it's locked and stable, no need for RCU at that point. We can
move rcu_read_unlock() before vma_end_read(). However that's not the
case with the vma_refcount_put() inside vma_start_read(). We could
change vma_start_read() semantics so that it drops rcu_read_lock
before it returns. That way we could do vma_refcount_put() after
rcu_read_unlock() in both places.  The retry case in
lock_vma_under_rcu() would have to reacquire rcu_read_lock() but that
retry is not the usual path, so should not affect overall locking
performance. What do you think about this alternative?

