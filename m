Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1D410706CD
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 11:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0686B0088; Sat, 14 Mar 2026 07:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E366B0089; Sat, 14 Mar 2026 07:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A106B008A; Sat, 14 Mar 2026 07:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05F166B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:30:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FBEB8C831
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:30:28 +0000 (UTC)
X-FDA: 84544450536.14.6E91A82
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id C94FEC000C
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:30:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IwHOfaaT;
	spf=pass (imf28.hostedemail.com: domain of 30Ua1aQkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30Ua1aQkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773487826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5/Mv7r0O1xhJ0MOUYqm/aCKF2kenGBq/6wEKwTk7fY=;
	b=H3cvZoP+NmesGXsV71WGb1QRSGrbtrZvRk83YOdsNtUNJYJfhAceKgH5J3DlIprWPuo8oc
	1utNLeUGqU6KXow66ZiDwE1GKsKL5NDQIxeE9kOeGJcP0x6IPdJEQUv5hR6Ed0//6iR6NB
	XJBh/RMYmhCBs2qr0JzPGKXRzi0EcO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773487826; a=rsa-sha256;
	cv=none;
	b=4J8I41bnF7/m83GbItUF1JAzXP+CAv2BAP8LyQsiBeSNJSWSGhD5kl9deOScok/agMIs+i
	hUz/WPcWp25K1b/dKLhLdtBnXrDwQKOaDAjmnaRM1WoidxR4RyrOrB59fY8VfHrTlL75E3
	+u/6L9igL3n9KGkFyxcKrFT0ge1hvwE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IwHOfaaT;
	spf=pass (imf28.hostedemail.com: domain of 30Ua1aQkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30Ua1aQkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485355493aeso21609605e9.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 04:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773487825; x=1774092625; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i5/Mv7r0O1xhJ0MOUYqm/aCKF2kenGBq/6wEKwTk7fY=;
        b=IwHOfaaT02uPfeTZ+y9Jg9xVjoxEXIUQgsKhNAWJo9wNDk4ofCv5xYyXOq/Djy/n5t
         OqpV+SfTgOken3XBJtYVLx9+TjZzZIQgy4Vo/3go3fULbSSi1vaUdfCLKthzG8r3/UwS
         ySbX9NbFhmaIbFRfBxumNmR5QzzoF8DktsYCsskjI+DZgk3xzJr5p4L0WucsjTylRsEU
         3ogil1f1lvaCpLCh3tovCKH8bsM20j5oeKOBv4o08rmjKfEVQpI6oftYNu/qAvIOF6nV
         qw8p1w9E/3vHtsKKrlv+h/Yk1VvRA7G9OK1EygNUZCR5fruaYxMHDn26r2vmtNNSuSbK
         X4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773487825; x=1774092625;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i5/Mv7r0O1xhJ0MOUYqm/aCKF2kenGBq/6wEKwTk7fY=;
        b=Zh58mKef9lCfWesLgE8ANqpKuZ1utQfsSdZx5OwAWp7HJAOdMjlr6YD2kbrfn9ffYh
         dY0qAzJovSchKV5VuVlZKW8q/Auis2SEDEWAj+jTyTmuGDRTFrtoyOSdKaR74gmlnRYj
         z0tOueerAksWH+KxdkejrUoXUEI5+gPSy034KT8L04pbxjZvovx5sCEKeNnEuT+77lAw
         55cXpB9n3pTNXFwnH8ZATTOuVKg9K8alSzwx8lho/dZrusMS76vLBfvtPBfPxjLXANAB
         eDQgkAuqpkGE47ia3A2mCpKg1mQy2PDY5UAKBfD4fBI50HA6mTBv00wSx87+rZ+XKWh/
         uAyg==
X-Forwarded-Encrypted: i=1; AJvYcCUVXCOty1JZcopsoYQoASnS4sA/4/dfjDg/cYbnaoRPWZUd/aS0Cz9LwQgGDRGMxDomIbfr01OVag==@kvack.org
X-Gm-Message-State: AOJu0YwshJuFGaYkigUb/eyHs5ybHAvKQeAo2UeBNhOlUkNDVrvgi5be
	NM6Hrvyf4abyqO26DVsyR0CrrpCk8CBOECGikS61yt9MOQzCWJsBLyB4pmdTeZ5+1OBLSN3jatf
	B2zEl27IgBdPOtiFgjQ==
X-Received: from wmpj3.prod.google.com ([2002:a05:600c:4883:b0:483:509d:729b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b25:b0:485:3a03:ceca with SMTP id 5b1f17b1804b1-485567029b6mr109864745e9.23.1773487825162;
 Sat, 14 Mar 2026 04:30:25 -0700 (PDT)
Date: Sat, 14 Mar 2026 11:30:24 +0000
In-Reply-To: <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
Mime-Version: 1.0
References: <202603121235.tpnRxFKO-lkp@intel.com> <20260313213638.GA147391@ax162>
 <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
 <2026031422-catsup-rectal-f886@gregkh> <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
Message-ID: <abVG0JypVhDxx1Tt@google.com>
Subject: Re: [linux-next:master 5585/5731] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, kernel test robot <lkp@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Mark Brown <broonie@kernel.org>, rust-for-linux@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a38z6f444ebz7455praapkycyjxeazr5
X-Rspam-User: 
X-Rspamd-Queue-Id: C94FEC000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1773487826-144760
X-HE-Meta: U2FsdGVkX1+XY7uwqGD+VGkIr6yirXqqICQzos6BsKwClT2OOlqPZM/sQanBEQoBkZkUAwyW4niw3a3M2BV5Sdy2f4NzBAzn97rjwioTMU2ckBfGvmNmEagOfGt/DtE+CZZz82SbCe7FetrHyaMsPd3gqJCW3TN9rljSl3oTQqBHWfepDTesQEKNUZEuvC6KFVRMQ5jtE6SIaZC6nt+jio5N/67g2U9o0sAGQuJf/SeGHhhlhqw1a+4PvPYvQ79mIG0f0OVpRBQYJ9aXXLssvswrokQrwz0UlQB0XlOjqnnw7VNdUsDP2Fwm23vNp25O4V5pcwvqWwz0rLhAbXSEUaVGMPZFJYP802gRhn4LUGbe36cIA8D0LP1BCc64m28dthhG9YyEQUteRTwrdzzfzsGLn2L8JIFcID5Kq035XcUiFoVZUTSeIvFlilHCcL9VM7CjwD2mF7HBDbg98S7J2UFCt8krw3gWR0GFYr1kgoXblGfRoSxraCp1oZ7aEuT+yFfDkGRzFdHK7ULz64fRwM7afl24y2DMCdIzw8By8g4MwnsEzG37AZuw/Wj6iIYLSUVJjU5mbFSae7rrMWiem1ZCD9mQzqfRZhkIpIr+70WCkthRrSLg3O5s/0nA7tEZJLRfWcIteNzW3scap48ft3NZLqyxsamlEDR1AWtmy2GzYrA2hrpk4Q1ZGIMzOnrGJKAhoH2mBK9dc+j6HTXheiQbHx7jA4NZvABJqBkTh9RyWxC0wDSnRy9XgD6StFkNO9GnSTk6t/7LOyVQ8mYtYKG4c+gSrMVN+wx3vKm0JablrUL456g1Et+RvQrN7RNksy/qusu05NmiICzsCOnKNfCCQvvEW88OEAF41K7pc7rRBCJd4rySQCakCBdyOOmRmClBAWKCAoW+gmCl3Hed/9OfxnWfR+tloo+nFs9uikqDQevr/vgXCFzGQRByGZNHVZpHoaWFmcQafR8a9AM
 kkNp1eHH
 ajFzgK3d/jfSA+Z8X0CQ/kNr7QtkM4/ZBl6AcbMKa2aaF7xZfa5mzOaR3XyHqX+JRNy1+YHa9HzwHaSKykdhxDVkCy/HHcyFzXGsxFodMWENEAU+qU+QDesjUKHVxpg59CS63aXHU4GMMSn8HM/q3jf6IXAQBfNzIfpW2d/IJ1Q73WkLADrrtLKyGL9gHaTPp+Wgb28TSouzBR5/qD/G2Ya0p8vvuz2RdncYnLr2SUJ1uohcsiQSqD4PqXx+g3r/tbITs0YXQeqVATyj9j5YCXj6xrn4Jj4ORgbObZChvimNLl0Uz3oueWAgV2hdbC4HTOxG/N4NlmWnZmWym5jCnSnX0B83Dm5rrW/vapsTelLHl7zgETZoqouazL5iWMTtSCnLiOyDDwzY1Emh7pj7QSVCzDz1CI5MLP251rl29P147T45T9/ad2M+NbgeKpOX6G8XlQ6iUuax9TXVnQ1tcbiWhM4epeHHPslotl/MyQpxzsCJRLwyzGKYwhBqHFddeBhcNcOs9SoDfyZiNvkitsxgW93LPNihBTQfLXjlhDEgt7+U9SvsNIogDKU8PQGrIgkRf0kdXy74Cqb1iS1epa5nNcGrw5wBgk/Q+TuCK1RxJtgS8ekmyVyAoWgSJbiyUFCXjxPQrwq87C3lw/dXh+qXSL3662OosMPT4vm482ItVq5cjaJDJtxvEnHtqP7bwOCBZ/tH7B36ow9AvhfqeCE1AhHJ74zzUIyS89ya+j4WFwzM7UheGEhJRdQ5JNllhVGQajV1ESVGEEfzaMA3FU176VNqv6N1qJYMBe7bc7xguNNyDNU1Kb1F1sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 12:15:30PM +0100, Alice Ryhl wrote:
> On Sat, Mar 14, 2026 at 12:13=E2=80=AFPM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Mar 13, 2026 at 11:39:14PM +0100, Miguel Ojeda wrote:
> > > On Fri, Mar 13, 2026 at 10:36=E2=80=AFPM Nathan Chancellor <nathan@ke=
rnel.org> wrote:
> > > >
> > > > It looks like this is a conflict between Alice's "rust_binder: chec=
k ownership
> > > > before using vma" [1] (currently in char-misc-linus [2]) and Mike's
> > > > "userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-unstable =
[4]),
> > > > hence why it was bisected to the -next merge commit.
> > >
> > > Thanks Nathan, yeah, adding a raw pointer (not function pointer) to
> > > the struct makes the type `!Sync` in Rust.
> > >
> > > I assume this is best handled with a patch on top of char-misc-linus.
> > > Perhaps creating a wrapper to assert it is `Sync`, since the
> > > `BINDER_VM_OPS` contents are unused (so far).
> > >
> > > Cc'ing more folks related to the commit.
> >
> > char-misc-linus should get merged into Linus's tree "soon" and then we
> > can fix up the mm-unstable change for this.
>=20
> I'm working on the fix as we speak. It would be ideal if it went into
> char-misc-linus, because the commit that is wrong is mine, not the one
> in mm.

To clarify, to avoid breaking bisection, the commit needs to land
somewhere that is on top of commit 8ef2c15aeae0 ("rust_binder: check
ownership before using vma"), and before the mm commit. But I guess
there are several options for how to do that other than landing it
through char-misc-linus right now.

Alice

