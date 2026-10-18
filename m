Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E65CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 08:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FD56B0088; Sun, 18 Oct 2026 04:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9926B008C; Sun, 18 Oct 2026 04:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C811F6B0092; Sun, 18 Oct 2026 04:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA066B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:27:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F5A81204D6
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:27:03 +0000 (UTC)
X-FDA: 85335066726.27.6ED7CB6
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5696240002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:27:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U9kuUF5x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 304LUagkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=304LUagkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792312021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkOWVJGDMEJpVMoa9QrtOzGeGfuXdeF8I51bc2Lb2JM=;
	b=WEgNBxzWfQYI2ooRk+/gqHsHyeNh7fh/rPD/z+jN0hX7mtSlhJca53H0hBXoaFudjjMN9z
	JqrtDrS14CVLiD58uSz2/e3tCpJ080Xe/z9GPlJJJBW1AaFht8ZuTZt4pJeOoMh/tj/Tvz
	Z9vb8wbXb9OqUrv3OK15X59HKsaAp5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792312021;
	b=Cq9d7CwKzhibi833UPEP4gQ46mNFeOLEsk/rfRZ/EY2hm8+F5YEiS93tnrMkq79MeosTAp
	Y/QvBhwZRPXfpi5s0Crf9z27b5RX+ots8wKke9VEJ90WDgmq5QNOSyv0+7jZanw+T6Yza/
	ur4VOj91jY5o9hnSvQAp8mRA5hWjtpE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U9kuUF5x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 304LUagkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=304LUagkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c40285df2a0so57420766b.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 01:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792312020; x=1792916820; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QkOWVJGDMEJpVMoa9QrtOzGeGfuXdeF8I51bc2Lb2JM=;
        b=U9kuUF5xILODDjegspRs8HwoPyK8Q4LTEQVe6KCNm0dLNm42DwOyJgPUfl9tPcOBgM
         Qy72i8Uri1A/iat26sVCvF5dsxv/F/Y61+gD19ckaLpGKBXFY0wdSbca4jta+aHnVEeb
         lTdTaqC1dEax7EbV6zyysGrmUxvwG3AzscTfGBw3lCW0+226FqM/+e9WcitUXEx0GGhU
         tje26sPuN2bPmF2NjuUcq5peKGFrbiRVmSWtaBYtC9aT8639lgNCUsZvV1kG85b0bo4R
         R5eLcFdr16Fq0BCAW7dSRDyja4vyuOqvQu6uk1qFbwK35sCGziHCjfb1kKGj8tjLVzcl
         dy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792312020; x=1792916820;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QkOWVJGDMEJpVMoa9QrtOzGeGfuXdeF8I51bc2Lb2JM=;
        b=u7TLY94dxgi4lKqLK0FpqIh+1NOkKa07UWECFjV4sKiTHJ0XkUhqRlLOEDzP/SbdKD
         Q44PO3XfSKex3TTsLqjl+ae6F5jcmvMb/sGBngmdddrkZ1aYjRbvG6cpurlM6/OgsG5U
         TTUOzTYCSCDfVXUQq6KqYoo9ry1MQ0ubpiIgCqhtit1RJ7jWzS6H9ujYXxu/o3qi3yVE
         F3d5MB5XbB+Tc5jYsJCBvsT2L8/96VeIrX6ROKieJjnm4VWmtgy2MJ8jRAjwODsfKfYT
         E3xCT9rkx7vCIJ43kSxSlTSniI6sVHtggUNXiU129ZPoXHKGHcSXHdvKD1NbPFrlgapx
         pGBg==
X-Forwarded-Encrypted: i=1; AKwUvBwep8LdP0R/DIUlnfryn0kOw8yOK67FDRzFhZvqn/8tfrVZsJ1jyrgm1BebKwdW9xz+B91udauzBg==@kvack.org
X-Gm-Message-State: AFq9FYKBdz5xTX3LtcfLB5UXkpizeQIYWka1B4arbQTXkN6/V5JV3ERH
	135nZji1TE7+8R60+dwKZZLRP4iBJ3q1Cyw8fJtXJaqTMJmPZ5EsNrSwd/v2pf+8tlDPhlv9OHW
	snCRDQcGGbL+2js4eBg==
X-Received: from ejzu11.prod.google.com ([2002:a17:906:c40b:b0:c42:1a41:d93])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7946:b0:c33:ca5e:8ddb with SMTP id a640c23a62f3a-c419eb33ac1mr311884866b.28.1792312019486;
 Sun, 18 Oct 2026 01:26:59 -0700 (PDT)
Date: Sun, 18 Oct 2026 08:26:58 +0000
In-Reply-To: <CABdmKX1fLKvC_TnO3g_DkPjcfoXiU2rM-Fa+ZjriYctVQPkFTQ@mail.gmail.com>
Mime-Version: 1.0
References: <20261016-binder-memcg-v1-0-d659b8ae088b@google.com>
 <20261016-binder-memcg-v1-2-d659b8ae088b@google.com> <CABdmKX1fLKvC_TnO3g_DkPjcfoXiU2rM-Fa+ZjriYctVQPkFTQ@mail.gmail.com>
Message-ID: <atSC0lHwc7N_6rVv@google.com>
Subject: Re: [PATCH 2/2] rust_binder: charge allocated pages to memcg
From: Alice Ryhl <aliceryhl@google.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	"Onur =?utf-8?B?w5Z6a2Fu?=" <work@onurozkan.dev>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5696240002
X-Stat-Signature: 8sfw3afdepn1t3jwj49fs66hsg1ik9so
X-Rspam-User: 
X-HE-Tag: 1792312021-14157
X-HE-Meta: U2FsdGVkX19Fcf073L27qhzB8w45iDGRv1w8XiwZWSNy8avTD4IEoiMscBgIf/dtCcQ6+Dun++tAWj1tn54eGXq8Q44ndQuT/4jbCFKxv9lfkmFY2s1bLd2Y7gtkKLMfuprbGEnnz8GOl7Lec+bcxaJ/IboMTqzXv3Qhlp5SISDl2sReaQQkwhzLITuSUQcYxRLvLANkPoBB5jIesbyAIhgJLBR4GI5ceN4TirO0BPSYEXjAEvnsNjlPlKbI2CMgAUdKtBbGqN1t8XR45TUVb+bXZNFZTesy54QrNG4tI3O77eiyV8J/YpBr6StONdoAw9g5smQzxVrry/qyn/NfWRpXAYN/g9ksU8TkddF3YsELSnyGPoSt1QvmsoIVr5K0jUpjBNzh6UcEE+lmwndWB9x9tzhciVZGscl+66Y6YVilVL+tAB57ZARGGsXpc9S3eAKQAF7joXjz6QtW9EbCNUUB6OdCoNAwMwiFh4X6+ZHzrNJf+hc3EuefunFdbZq9kRQ5SRSkviRJ4nRD2VLr6xEug2dnLJU+OgAv0zSId/KNkb1dxTVUsWhpcoPVIQDYg7q43o6MoGC34vv+Wc0YwB0Jw5JtB5uNA33IpO5KaXC/vNRIa5EQZKMtLGlVJBvuohBk/S+ZMnxXRi2V4uZy9PI1g9mmFemQF1MZzHR67joBb50s2HOuvQ3gv5cLGRDgpyvZ4v61tEKRmhsVp7HChzM0aKQ/OzQCfIATYcRil45p0wWtQbvA0v5tp9h2xWv+HX3EXS1H1f7pzPJiwhi4hEKmQYZJRxAbkCzwS8oohyak3w++WGYmc+J1dHC19ik4GW1JM4rzw+mMpehWpN02PHjKDDeuShpceJDIhACV3RJB9D2GNZ8mZGOcnLP5GmymC8fXxEJTzRSbbPzU+7Lxq1xLM2iZwUFV8pwgYGrNwHc1ixmSxjDibkaEwyOXWVj0bJxbsfOBBZQS+x3i3iZ
 6HaWyRZB
 Z8ghHCLXRAssXJpckGrKc7NI5sq0ZnV/OoifEEajtgDX/KCkexU+66mvbCxrI3hskw75Geh9T5bpaespq+iq2F46eGAmvWM/9QorTgVzwqk30W/G4hjoPzcpPjdoKwxGOaNdRPSzDFk3tx5HrmVajFkPXmL0Ff4pqCmG3sQ6sfpDxYnS1vQIi/vDr1NmULbcJ6gFucY0wmya1etiCrFI/k4ibK9Wep9aevQ0mMD10Wws50dHrEsfQYYHC+zrl5FoagB3mzn0UWilq4n6sHzkP2MLmOCPkff8XYOOS+brWJI8fuVaTSDIQgEUsImmH7FMSYxxDzKS/dgP9+Hps7bw66JVH8upMucP/xNtFIpFpwHHIQc4AtkJ86Tonyx6ZeFRJPoGRJfEhtUN3WSaq+HNGlwqIepvm0xoFWZSTrL4jCbbKNdhPKBDWG5osGmi9113cGY529fV6yn8aSGKMtd0Uz0t2YO7yEkP8OcBzJH5o2PXfgO86mE9X0iL5cmn2lrQ8PBqWL7kA/lSUybYC6DE98TnLvDUMd14S+bo9ui7tPMPve5cka/UiZ2GyWvS9hFBLwNgFCXK93f+T8kcRgH+pExVvdMb9r0h/nZ+oLyTLBGWlQQv6MMnpVh+FVmPwkYdTyMlyjXjwMQDk7JklYUcLWDrKAFU1e9jSvyEFHZsHOl2HCYpTrla6vJEqxMeT4LqXBlAcxuT1TNap5/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 11:41:55AM -0700, T.J. Mercier wrote:
> On Fri, Oct 16, 2026 at 6:30=E2=80=AFAM Alice Ryhl <aliceryhl@google.com>=
 wrote:
> >
> > Pages allocated for a binder VMA are currently not charged to any memor=
y
> > cgroup. Thus, use `Page::alloc_page_memcg()` to charge them to the
> > owning process's `mm_struct`.
> >
> > Suggested-by: T.J. Mercier <tjmercier@google.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> >  drivers/android/binder/page_range.rs | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/android/binder/page_range.rs b/drivers/android/bin=
der/page_range.rs
> > index 52ffbf3504e7..57da47243967 100644
> > --- a/drivers/android/binder/page_range.rs
> > +++ b/drivers/android/binder/page_range.rs
> > @@ -27,7 +27,7 @@
> >      ffi::{c_ulong, c_void},
> >      mm::{virt, Mm, MmWithUser},
> >      new_mutex, new_spinlock,
> > -    page::{Page, PAGE_SHIFT, PAGE_SIZE},
> > +    page::{MemcgAllocError, Page, PAGE_SHIFT, PAGE_SIZE},
> >      prelude::*,
> >      str::CStr,
> >      sync::{aref::ARef, Mutex, SpinLock},
> > @@ -399,7 +399,16 @@ pub(crate) fn use_range(&self, start: usize, end: =
usize) -> Result<()> {
> >      /// Assumes that `i` is in bounds.
> >      #[cold]
> >      unsafe fn use_page_slow(&self, i: usize) -> Result<()> {
> > -        let new_page =3D Page::alloc_page(GFP_KERNEL | __GFP_HIGHMEM |=
 __GFP_ZERO)?;
> > +        let new_page =3D Page::alloc_page_memcg(GFP_KERNEL | __GFP_HIG=
HMEM | __GFP_ZERO, &self.mm)
>=20
> Not related to this change, but I think it might be better to ditch
> GFP_KERNEL | __GFP_HIGHMEM and use GFP_HIGHUSER. We're already mapping
> this into userspace (and now charging the memcg for it).
>=20
> Is current the sender here? If memory.high is exceeded, current gets
> blamed for it in try_charge_memcg()'s done_restock section. So if it's
> the sender, that's not exactly what we want since the sender would be
> throttled for it. So I think this depends on
> https://lore.kernel.org/all/20261010210957.1350874-4-shakeel.butt@linux.d=
ev/.

Yes, current is the sender process here, allocating a page on behalf
of the recipient process (`self.mm`).

Because current is the sender, I don't think we want GFP_HIGHUSER: the
only difference between GFP_KERNEL | __GFP_HIGHMEM and GFP_HIGHUSER is
__GFP_HARDWALL, which enforces current's cpuset (current->mems_allowed)
in cpuset_current_node_allowed(). Enforcing a hardwall against the
sender's cpuset when allocating a page for the recipient doesn't seem
right.

And yes, it looks like we do indeed depend on Shakeel's patch.

Alice

