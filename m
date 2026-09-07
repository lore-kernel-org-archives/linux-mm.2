Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A8F7C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4A16B0098; Mon,  7 Sep 2026 09:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87EC56B0099; Mon,  7 Sep 2026 09:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FA26B009B; Mon,  7 Sep 2026 09:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBED6B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:31:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E04751C07E4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:31:32 +0000 (UTC)
X-FDA: 85187053224.09.6A807A2
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id F3CCAA0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:31:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GCQ2DLHv;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788787891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeIqMgyiOqWe7HQD7SmKTKpkW52D9bvAC89kO8GNV9I=;
	b=8iVkGHFmNhU86EsAJjoNpbeaP89Q5Y6q0Jo359yIpg0rUYkxK90v7bjzd5e2TF0XwODfUM
	N7FeSRSz8gi+W7ucP4VLOtW7Wrf5Kz1t18R9sWo+8+6BrdRejdzMH5692vDq5854dH8ZOv
	Bk+20MVEMimqrOcJ3ZY6GRK5bz5ZrE4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GCQ2DLHv;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788787891;
	b=S8VnG/bFv4KJOyhmZBPJpgmXthbEMizueLwse5e56S2wDjruz4BwXtH3bALgtXxq5n4aTJ
	ru+LioUcdp/C4xl5+FCnkQ2UN6UjGQSMHq78Tu7paiqeRbXgCUUxQhr/F1EokOCSaBsFnD
	+KZOqfLYuoeCerh9l5Y1vR5YXqBpI7g=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-484362f5c4aso4499169f8f.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 06:31:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788787889; cv=none;
        d=google.com; s=arc-20260327;
        b=caJ5BAmHbQLaMLLm94BemcNeXivF1mVKIclDSGrK5GOhgrGhhUXZjtmghnH3N1FDK9
         j+bMfkQNNaQYszfXJ3bvfeNDcyA43F0hHWHohNuewmorS+B0Mp4ZHbXI0OPv6y43zbRJ
         VQG5YdPNhRlBF/JpHLHBqxW55rwVy0SmDyy+/XjOG3X49HV+6ctDIWWGgK6OjpMKHVs6
         UqY8Qzx09vEBTnWEO5rd2iF3A9YPZ/qZ3LRtlYcxH/tmyFMl/9kz7+gdCFXN9RQ0DLm3
         acSXcP43ZTBqfMYuhtt/z12ZTo/j59DH+h7grpgnKAvmncVSbmMNLvNW3C5TEsWbwOkN
         yRWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MeIqMgyiOqWe7HQD7SmKTKpkW52D9bvAC89kO8GNV9I=;
        fh=meXUpinnehq3YhWN0yQIgIDVyIP71FkbdIKJsneDAT0=;
        b=RYjov2RUxL/imkVW7AuJrL7rg1Y/97D8ZjkqGBFokVEVajlfiH1HXzpYC+G4IHJU22
         Xre1toBVF8iJu7RcvLJz1wt4zBsFQSsB6/yIKzIeFbpOQ5+Q7JmP6i3ZCT06UFI+Kcpv
         S5HKqZAoxpBk/1+lMuA2cR53r77vpQcn/B7kMGjfW2EKGHuGCkbfCsXyv2txRVrZuUfP
         92nVmpcCR3XSbo9U+57Y5+sRteMlhs8Fk2N6SxA+OgWmV4KlfUnfM/GcjYY1UXrSxMKq
         CvqT5JBJAS2Xu0aK9CIsmfrmHxqVAkzhqRiMNS71DnOwt+f//Cvu8RWQeQiUdFC/sZlg
         t8rQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788787889; x=1789392689; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MeIqMgyiOqWe7HQD7SmKTKpkW52D9bvAC89kO8GNV9I=;
        b=GCQ2DLHv3RqZZ/rr37lPEaDX463n9tx9afjqO0j1p3TA5EGYwNGH8s+fKzziLWxd0Y
         RZOeWX6r9GxFtYkERny8VxLOr6Fd0N5kunmWD7SkGPoe80K/620hv+kTD1SUx9W/kH5Q
         Fsx9cEZ28nWUZJqSaTqIyAudiiUWThAEGUqeLR05o3xEG7LbUVkDRZcYZX1VTPthhlVe
         xtoBkF0LBN2G+tHs/LAYUcMmhcfN1iA+VDD+r2cTAWw5ODkN3e0o53jC9h5GSti7tKdi
         ySxcU6/L9aSFkyhnUtzf9dbwDVskf79aAXReM7egcQxwiYDXzkHJjEkznFGBjpZtgTL4
         MXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788787889; x=1789392689;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MeIqMgyiOqWe7HQD7SmKTKpkW52D9bvAC89kO8GNV9I=;
        b=n04FXc3YDrVodORvYCo17b+cAOG+Ir23KiVJNn2rhjhEUO44AgDuGBFtDx/cWG0+eq
         UOttYjQ8xoFDDpfOOgSCJ3PyQ7TfTeDbjP/TJiuiatccl/h7cuAlTl4bLIS5TEUI4pqz
         WnbK1ul/pDa15+cyPmW9nnzS+aqVbBQVHP4/9spqQEc/FD8V+NUX40zeo/TrRKE7K0FZ
         UDTSrF6l/VSFkl/5VZt+GY3FGcHXRl6qxBfWNF2TbJ2iStouhGxeFGu4MfuQ+r8ptTqT
         s25G27/j+MSRCa7ktb9r5BGnDWEGPLYSfs2Rw4/+ov/bSLFQv3bBYUYST8M6G59u7S/9
         bxqA==
X-Forwarded-Encrypted: i=1; AKwUvBzXOJaBPTirNaBA9//UQFXsKUt316c+LdtmuXxBxhtuQqKSZQ0UwXFiY/g+BYuZkD+Cmig0NqLjoA==@kvack.org
X-Gm-Message-State: AFuF++kEvKBSeITao0f2L7sUwS9vM6V9BXAo73mw2YKHh/md5YLspr/U
	SelBX0Nay1LUs2/70D4qcstVQgQ6CL4qj7/3sHlfCyly+AFI4Cm+TY6gDpsoRuIyAsI2BlV3JSp
	Lt/QJZ52eP3DXJIrrbPnlcOujGeS2TN2PGh4YxkzR
X-Gm-Gg: AYBFou0LSSjSRxI2nCQPbGS4xeeE0HmZW2AwNk+LwwdDHAmiWn9Wp7cE5+2ARajAKPW
	V6SSSO/iQYLQDoSjghL0SWFPekXyEWIttdjaPqGIJ2FbeKFguhTW2OpNU6OGlh171LH3UTzIj3g
	au5OvbMYskedofaNM05VpXrXRU3nx4IENfimE9q7AJSCfz+vBjd9HhvmqpF09sVbTVbQ1A8FfSB
	8qqwB5uIl/RN4/oPVGL2XOoLnxArR0r76RSwYncQmXz95/3WoN/aS0zxOh8HH4/B13Xf0ZW2E7x
	0rrF1zTNCH9pEwsqXuRizIT6BDRdtlo2kdlv1D/wkOPK5EaBcOjd3B9Yas2Or8eLk5IdiPhLbFn
	931oKhN5BV+6CvA8NHyxs8dbo2YJPGczA7fsKv1vkBQ==
X-Received: by 2002:a05:6000:26d3:b0:485:8393:2176 with SMTP id
 ffacd0b85a97d-485870902eamr40614985f8f.21.1788787888668; Mon, 07 Sep 2026
 06:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org> <ao2WubjLtDuHvRzx@google.com>
 <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net> <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
 <8733vlxmm8.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <8733vlxmm8.fsf@t14s.mail-host-address-is-not-set>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 7 Sep 2026 15:31:16 +0200
X-Gm-Features: AcwNN1Umd_wQEAUZHPYxidNRM70dkjd7WtcOMgQxK1KjbblodnsY1lRpQ3kHiGM
Message-ID: <CAH5fLgjEfZO9DwcUxaKCWd_hFUrXU+cxiwmRg1UnM2pKD6gPvg@mail.gmail.com>
Subject: Re: [PATCH v20 4/8] rust: page: convert to `Ownable`'
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Ira Weiny <iweiny@kernel.org>, Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, 
	Asahi Lina <lina+kernel@asahilina.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F3CCAA0003
X-Stat-Signature: 6tii477wmhpctchn7rhcxis64egg88dz
X-Rspam-User: 
X-HE-Tag: 1788787890-583359
X-HE-Meta: U2FsdGVkX1/3EHhwOvBcX7pNvHO4OUuJcC4YkH5iugO8rg/gcoTSz5KsPursRWIFPiz65PoWHSgM+WzHwiNJBsCnFwLBQ6so71EJZ65BJYBVevQ/zUy9978/UtV9gFpfkep3DVjKxc/fbUERk9K0s3ulEQuBS7b8KNWVu8X8u0xodY0zCdlk5jQxLXEvCEF6d1JilnlwJkrrrfNk55axAmbyVo3isbPVy4ntdVkvInH39qa6GZx75thX0Yuvh+LzqVc7mHOuu43r/X380KkE9wV8sXuqUJYCL/fR+jYa+SFigxNT8mR/RQXqqlFKI7x6MVGqx77LOYN5VJ6XXsnBUjs6hY4I0uSo9Vp8UjyjXLjnhrafm3MFDLjUSXrKur1X//XDV0FAPfOQLPowolvBO/qN0k1tcU7OuOufo9Vvpd48pt00j/KyCIfX2jcz8O0fMtSwXH8Qw8zeFpw4qlL/w6ru5QmesRjSN/JeVnK0oNS4xkMG1DES59/gOvfyGZLj1NMcm03eXU3PC9P3bj3H1RJzXFith0XdcVd9sLspZj2T1c11gUo9IoPA2BR0HfuhpN3/z/Asx9K+NGyV5ksoVYj1fUXULKxURDoCTjvR06I/w+SP9VnENLs+wkTSjr65PTdLK+yFlpWaezWHEehig8E+kNt0ZQkUM/27eKV6Kv1zBFb4auU9pec6EknuM56N51CavVP74aaPcAkIhJ3eFjr3Ts+CZBhfECm3iqLzpmEgxZck7jGa1fM/xvw4eSxOaYxxYXo2Tcm5OF1++xwPG3xHDy2YcN6VyQwDe2fyHenkS7GN295ugiuAQRZIvjNr6b6ROGogsoDVgLgy7zPi4co7BdeiO31nctVN28ID3mKu2KyDJFaRF9RWqMcaxNSCv63eCU+6SCpQl38vgwspyAwt4sATspXpevqjE4Bv5oGKxrqWhTg0ffdxrHTyeefLHYxpDuK00WzBPqdsWas
 +wsZks4A
 QxsoYz9nVRI8pdnHY+OsSLzo8eWeSIbyJ4j62lUixnIiq8om0I5Akrn859IDCDvsnju3pzCxZs+tX39TT37DUcVQ5Z0elFgDZxkhkOlmVjF4DY0xGqJwLb/iY9YjY9Y0Hps6rorHvD3Is+FpKFVi4aWRdz87M6S5MBs0PhG+7rLykU4ZV/maS/WPBp0J9lsfiRj3XAek6cWY36iD4o5OFk31b8HebMtwxbSNeY87QeU660ZkyHR9FScvsZSTmken4+NmEjP8kglwmfNG46n/A0CrU62H81kKYoQo7PgvMr4QGOeojMmBej5A3QvEghBOuTCPlu/tXG/opfv0Xzmjj+a84hokP2g9iAEC0XN01fgCOA2UIY4C45xgfg9Giexr9cBAp1AA6Pl5irlX4HpeFsrzmqnatFQoH/dk3ntwSVuQiwSVMoiAqoT85XFg7mhYfpkNL3S4Iq1IRaKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 2:38=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel.=
org> wrote:
>
> Alice Ryhl <aliceryhl@google.com> writes:
>
> > On Sun, Sep 6, 2026 at 3:02=E2=80=AFPM Gary Guo <gary@garyguo.net> wrot=
e:
> >>
> >> On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
> >> > On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wrote:
> >> >> +        // SAFETY: We just successfully allocated a page, so we no=
w have ownership of the newly
> >> >> +        // allocated page. We transfer that ownership to the new `=
Owned<Page>` object.
> >> >> +        // Since `Page` is transparent, we can cast the pointer di=
rectly.
> >> >> +        Ok(unsafe { Owned::from_raw(page.cast()) })
> >> >
> >> > This doesn't satisfy the safety requirements of Owned::from_raw()
> >> > because the page may be used with vm_insert_page(), which increments=
 its
> >> > refcount and causes it to be shared the vma system, and this occurs
> >> > before Page::release() is called.
> >>
> >> I suppose the existing vm_insert_page() abstraction we have is already
> >> problematic, because it uses `&Page`?
> >>
> >> Maybe we want to change the API to use `ARef<Page>` so it already has =
to be
> >> shared? Conceptually it takes a reference count from a `&Page`, which =
isn't
> >> possible because `Page` is not `AlwaysRefCounted`, so it needs a `&ARe=
f<Page>`
> >> to be able to do that op.
> >
> > Honestly, the problem is the safety requirements of Owned::from_raw().
> > Pages have a "special" main reference, and free_page() does more than
> > put_page(). It even does something when the refcount does not hit
> > zero.
> >
> > The correct behavior for Page is to allow the user to hold one
> > Owned<Page> whose drop calls free_page(), *plus* any number of
> > ARef<Page> references that invoke put_page() on drop. This way, the
> > owned page controls the special drop codepath.
>
> This does not mesh well with the model of `Owned` behaving like
> `UniqueArc` to `ARef` behaving like an `Arc`.

It's a different case, I agree.

> Please help me understand; with page having a main ref and an auxiliary
> refcount, if we model that with a single `Owned<Page>` and a number of
> `ARef<Page>`, what would happen in the case where the main ref (`Owned`)
> is dropped first? Is this legal?

Yes, it's legal.

> My intuition here would be to follow Garry's suggestion and have
> `vm_insert_page` take an `ARef<Page>`. Can you elaborate why this is not
> an option?

That would be the wrong ownership semantics. The C side increments the
refcount rather than take ownership of a passed-in refcount, so the
correct argument type is &Page.

Now, for the use-case in Binder I believe we could switch to
put_page(), as we don't need the extra stuff from free_page(), in
which case we only want ARef<Page> and do not require Owned support.
But as long as we are calling free_page(), it needs to not be
clonable.

Alice

