Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60EBBC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B376B008A; Tue,  8 Sep 2026 05:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4B76B0093; Tue,  8 Sep 2026 05:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48CD76B0096; Tue,  8 Sep 2026 05:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13EEF6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:18:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 999491C220A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:18:57 +0000 (UTC)
X-FDA: 85190045514.02.AA57EA6
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2D36100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:18:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tpAOTTFF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788859135;
	b=FNp7qZTK1qeXbpbQbGdvRUWTY/DZfcIt/Qm9QiozUIM0ybZZB/3fsecadeR05ke+qGQ6Fm
	RL2XTUFHN8R6HS/XQvQkmUWrbm+gwotXLeSY/+YN/OCajQtMlMZADjRW14TDwjZ0EWcwfS
	KSSsDhbZvDF/YLqe74S8BNg828o5/pQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tpAOTTFF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VIgSHXB8I26MCbzgx5LIxLwOOEsEsffKtC5qMFw/5wM=;
	b=zG5R3iSf+6oQil4sttuZ3afyb1lL5hZt9txh0PykC5gGd7w9Gn03ac8AVs9mV4OHA4Zhvp
	iU7dgTze6ovxPZ4x0ABu+z/DX10Ij2cO1tDTyHStbubLdJ7moOrakIQPwhErHiG4Q/2k3a
	S2Gv19CEJOZjc/I1yFIR468JGYxH9T8=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4843e9c5960so4287942f8f.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 02:18:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788859134; cv=none;
        d=google.com; s=arc-20260327;
        b=p0bEzWqdqR5WBPaJyahWb56Sc49cfS6cvVhakq1NczyTawDX/qzp0YCsqfAzjIZbnQ
         77CKRDQcn13wWZf9iR3up11iPzagnMBOzOXHsJ9eFQQJxwcCGPCMmUj6WQNpTtuPI+Bt
         ZjunvDZ+DiXkaRZvONPzd6zOzIcVOM6gzmSyVV1fNmh6+rCP/gPhEJlkNNMtonXNxTXE
         jK5pMwW1Xh06UnBLPACJjwpxtbkeL9eh6ws5KGng7DInwJb/RwTYfyZLNlLU3Nyxj43I
         z5zPOsHzqph5Zgnb+tC5ACFFbr4m1d+GRxALcPVdby8UgBr1SqKg0q/b7MIeSvN+dpXm
         qsiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VIgSHXB8I26MCbzgx5LIxLwOOEsEsffKtC5qMFw/5wM=;
        fh=tdjd2Rvtupj5FH8Y+XE+6AELAWZ1am61KtaWY0DnnFk=;
        b=YATTfGmfRK1Rr3J27mTUUW/2DCFHrAl7DDTWhVl5Uzc4/LjYljTTz+6zwign5lTrnJ
         dUUljDLrsIxZXATNY+qNNnljQzZjQhETZrADWswX+ZjAtWQiWqATpp60ufvIyreRT5Q+
         D6tmf7dBT5CTjzHNzYrk5PVdIh8dl/eyt1PabzbdYkRROuh/X4dBgrQUqbn/FUQcqLa7
         ucNCrgDY5g1kFu+t696I78CJM14I8w2Rw31rgFve64ArK+NWSyhxxcyLQ1yzPQGvr4rI
         1HK8VJ0JaUJITgYCf2ZRH2tFop75E1wZ3hyHZewOp/XdUYO0k3qbOc9Tp2B4LEk0WaIm
         vTpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788859134; x=1789463934; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VIgSHXB8I26MCbzgx5LIxLwOOEsEsffKtC5qMFw/5wM=;
        b=tpAOTTFF+lgEqpxhFqZTdzxEHuMxIWOTm7GOiAPkNMTIntwE6MZKGalvUhngeMEWAo
         AW3tuYFYftRbiiv3ne3ssqhl0D0VnlnHNUSOZ5tlh3h5z6miqzlT0VJzVPTuberrrtZq
         YsrLH8Dsxh1bFuB/SOJ+tLyKhIPRvJlmIFlMYcFAyfVzVZuB+W5bOVtBc4qPWe230DTn
         7rWKCHsTRexICwJ1qKCh2Kvx/iFF/WnnQBI+pRcOW5WzrbBXKxujrq61zhVcHsG9fKQV
         BLiyzuOCkqC+pBQUBwj6xL8rQxakZ+UPtZ3QoymY/NLpPQtLnwV0VSgZTOOORywPUVhq
         wSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788859134; x=1789463934;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VIgSHXB8I26MCbzgx5LIxLwOOEsEsffKtC5qMFw/5wM=;
        b=FXRvOrm39YkL9o9/d3RjfGwCyUzFTrAw2RBS9frnrvqmlYBkX09zaKRYdBCkuRfz3J
         cYNEjSJN0KKDv5a2RkoWFVO0PtIn+MsgmTxXEzbFhCgQdU25mbkIvdJ1qTobRxASYFTQ
         opP7NtwYXUayoPGoaTQly0gXMVJFri/od3JfL5UY7WPPatHD3cwgLIwfWxym35kmTnQj
         OS4FYJKf0MIKuEPxQhkHJct5j3ZAv4j/H+T2uzUwHQ1fC3XNxjQIH4AbfK6BzXacZOC1
         m+TG808EABN4Exyju62noiiBoevxPZ79yGKgk/syP4WlBZ7Od1n0fMKmfLkTL7oIJN2E
         MVNg==
X-Forwarded-Encrypted: i=1; AKwUvBz8wX1k2TB0ovJXDPDBAyn/PJbAEBqlewHMQixEBysEhLrPGfQyeV8S7YsBfObb/ajGZ5Jla58bNw==@kvack.org
X-Gm-Message-State: AFuF++kG5TdPROJsKZBLUAVPT+tTuke5RMA1BldhbwJWHCrlPRo7h3F5
	CSunWXffU66973lmNn7v76tNuz7NnQnecetcZHR4IKy5z4kj1au72JzBAwl95siio3EzMb/Uczi
	YKbkDtQ9kFjahZ6nfOb02rgZNB/sZxEVLlPEjH5Et
X-Gm-Gg: AYBFou1W23aCchTHQJesT6WU1h5z6BzvGbSENdzLAa0EgBo5Ijlfx/v3hsYNE7SrLRC
	3mFjBq3VNJdfsVu7BnxLVugZrNe2Xo1POLiQ+ESIkbTw1VsDfVYYyMrVjWRq236k4Iazm41G4JW
	l50+03eoyX9ZiDLz+y1D63LR616Cs5MN5vg4uybmK+q9Y4V/BLS58BVWE4dKK4aCeZeClsIGPU6
	geo65YgrJoG0CY4fxZVYflYg+iq8ygoToTw3p6OpywVj2zevzbbiZZ0uM7MykPi6JFZp07KLutJ
	Lgj1apAVXN7/XFjS4tmKB1rsRKZvEKqcL6XsiGqOQq0Vh62yIFZzFOhUVzHPC9n1yhLvUDR868V
	z3uEqX0/sW05iVgZELm/20XvAjAk9hA==
X-Received: by 2002:a05:6000:2584:b0:485:8c16:5efa with SMTP id
 ffacd0b85a97d-4858c16617emr27731999f8f.52.1788859132844; Tue, 08 Sep 2026
 02:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org> <ao2WubjLtDuHvRzx@google.com>
 <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net> <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
 <8733vlxmm8.fsf@t14s.mail-host-address-is-not-set> <2dpwVpJS3VbfQ7CmE3HeY4IJSSMXTP_O9sSP3HHHUD7Z29RNEG4Hc0m8f94jKWjFlekcTXvIBA-QdGYrf8w1sw==@protonmail.internalid>
 <CAH5fLgjEfZO9DwcUxaKCWd_hFUrXU+cxiwmRg1UnM2pKD6gPvg@mail.gmail.com>
 <87zextw4c4.fsf@t14s.mail-host-address-is-not-set> <CAH5fLgjYmvp1Ph3dYXnTKkAvWgNpgCAPeq_7PZhRai6pCNmVmw@mail.gmail.com>
 <87qzj4w2nw.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87qzj4w2nw.fsf@t14s.mail-host-address-is-not-set>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 8 Sep 2026 11:18:40 +0200
X-Gm-Features: AcwNN1VPjOtQdlrm_QvCyA8uta8erft96HkhfUzl1dJDcrSqVwPtKidMELQvEqo
Message-ID: <CAH5fLgjrQDWSPX-81TNdnc=AU3Jge57vUJ_SHCn8=uUyGfRq=g@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: w9mf1yci4tf17a7qhy7i8izrxofky4m5
X-Rspamd-Queue-Id: B2D36100002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788859135-948352
X-HE-Meta: U2FsdGVkX1//NwsSOZuca5De/qFZ9b1LDT59cdD5db7X7rvsW1bMLkTjN4B3ZeZk6of5rbmAVag6H2VhjEZyAaTTxrErPwznW78Y+3YzSr3x//cFFUbmvCuhI1iQbNzTS4d2paCiEfFFDFruDSKzfD7ODBJ1DkG78mJFAtvWBzQfRdb8TmzxOTJfdJhgkScBWj2GEd+6L8dRKxyHQIsIt07AtiM+M+QZyxhv8cl3eH/WcTdJTTSfm+KqBnAtrrRUJLyJWXB0uoNpX/vSAQgRq+WX1h/RAoVw87ShrqVzhSPC0aaK5ThddXHDzFao+gjq0ZUvJSPuVeLlOc2oGZhIOv1W9nMeGgx9niZmOx6ANTf03FpEKKKLcsbM8A6qq7NTe6WNELYwQTKpnDtMEVTAH/pEm7h4y21J3GyBItKLYov9MNjE4NIcDOG6FZdqLPo5q0RiJBRWSGuO07suRElB+rFj++3Hu+RXl4TC9HmFsrfBQts3niWu13DbZlEFzY0dln6PIXbxxxUHRO8aDCyDQRUaY0SS3D0P+JQlnbeqfCxpkScNSv5M1meIGVmQQTjmH5MpjkhkeUOnVG2ikQYqDaaYtkEV+/KlHcHeYV7os64ctgYwKR4zD9dRLT4fa5H0kF1NpbSSoo+i8p903tzu7Te5/Mc2mzy5u2oJJ2MAYD0wSTPOpe02pJik+N+tk2MuVfh6hfg3LQIXrVZulITP5XZFSlmAEtusaYpCwSrL36TqOWDgXOJ6axkmRQFtY6wgU+bEYFDeax+t8D3PR4fb80SyV5ghe/6urRSjK0wpqUfO8fwR3s0r2qwECWb5f2STuYMLtOH+RBflZubxxMwl0u3h6c+jj+N9FpZe2/QyT11u6GpF7M/hq345mdUICS6n8v5JGxGWQnMWZiyOOQ0oQv5Bt5nyTwYMVZuN0zWlxUVHvqU5TC7MY4n7RBol8cuL0/zlnAmQjxvKLLWnDfS
 HOPmlwPU
 HOpdTTEbtvxmq9V5crTm7H5pkkEsIgZEhcJXynL+XfHGJGDgOT+97QqNFtopYgBA31GQtcGMjqAAEdcuCklTX/W3HpOCSTGsUZm6Bz9R/DkRgoLVqYTc0xuDHVL6OVhpbABo8uYHobxCMnEEAvlPHegVYKovfoQuBnX0Dj1vMFVZZubKwA9x+yCeKI7gGHkU435DLeeumcKYdHPcKZe521IV9vLzNkEid0SJ/kj5ALnUmuVEQhfBjLDf3QfcBTqwU/xGiPUz/LduX+xAi27WGQzJC70QBmW2Mo0rdflbyRaB69QzP8JLaQoXMkledhibZqYn7ivqDhS+4B5QPSkGs+o89DaKeAMJB96mykmdlnsvfxG8ai3tn3XH9nIhS2HeVdNf53P6T0nx/s2MCJ7bmFGYmv6mCxDvsIEXDtWnhPCezHLyrK3MntbVpV/5e7hT9iRqbZF9QV43QU+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 11:00=E2=80=AFAM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> Alice Ryhl <aliceryhl@google.com> writes:
>
> > On Mon, Sep 7, 2026 at 3:58=E2=80=AFPM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
> >>
> >> "Alice Ryhl" <aliceryhl@google.com> writes:
> >>
> >> > On Mon, Sep 7, 2026 at 2:38=E2=80=AFPM Andreas Hindborg <a.hindborg@=
kernel.org> wrote:
> >> >>
> >> >> Alice Ryhl <aliceryhl@google.com> writes:
> >> >>
> >> >> > On Sun, Sep 6, 2026 at 3:02=E2=80=AFPM Gary Guo <gary@garyguo.net=
> wrote:
> >> >> >>
> >> >> >> On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
> >> >> >> > On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wro=
te:
> >> >> >> >> +        // SAFETY: We just successfully allocated a page, so=
 we now have ownership of the newly
> >> >> >> >> +        // allocated page. We transfer that ownership to the=
 new `Owned<Page>` object.
> >> >> >> >> +        // Since `Page` is transparent, we can cast the poin=
ter directly.
> >> >> >> >> +        Ok(unsafe { Owned::from_raw(page.cast()) })
> >> >> >> >
> >> >> >> > This doesn't satisfy the safety requirements of Owned::from_ra=
w()
> >> >> >> > because the page may be used with vm_insert_page(), which incr=
ements its
> >> >> >> > refcount and causes it to be shared the vma system, and this o=
ccurs
> >> >> >> > before Page::release() is called.
> >> >> >>
> >> >> >> I suppose the existing vm_insert_page() abstraction we have is a=
lready
> >> >> >> problematic, because it uses `&Page`?
> >> >> >>
> >> >> >> Maybe we want to change the API to use `ARef<Page>` so it alread=
y has to be
> >> >> >> shared? Conceptually it takes a reference count from a `&Page`, =
which isn't
> >> >> >> possible because `Page` is not `AlwaysRefCounted`, so it needs a=
 `&ARef<Page>`
> >> >> >> to be able to do that op.
> >> >> >
> >> >> > Honestly, the problem is the safety requirements of Owned::from_r=
aw().
> >> >> > Pages have a "special" main reference, and free_page() does more =
than
> >> >> > put_page(). It even does something when the refcount does not hit
> >> >> > zero.
> >> >> >
> >> >> > The correct behavior for Page is to allow the user to hold one
> >> >> > Owned<Page> whose drop calls free_page(), *plus* any number of
> >> >> > ARef<Page> references that invoke put_page() on drop. This way, t=
he
> >> >> > owned page controls the special drop codepath.
> >> >>
> >> >> This does not mesh well with the model of `Owned` behaving like
> >> >> `UniqueArc` to `ARef` behaving like an `Arc`.
> >> >
> >> > It's a different case, I agree.
> >> >
> >> >> Please help me understand; with page having a main ref and an auxil=
iary
> >> >> refcount, if we model that with a single `Owned<Page>` and a number=
 of
> >> >> `ARef<Page>`, what would happen in the case where the main ref (`Ow=
ned`)
> >> >> is dropped first? Is this legal?
> >> >
> >> > Yes, it's legal.
> >> >
> >> >> My intuition here would be to follow Garry's suggestion and have
> >> >> `vm_insert_page` take an `ARef<Page>`. Can you elaborate why this i=
s not
> >> >> an option?
> >> >
> >> > That would be the wrong ownership semantics. The C side increments t=
he
> >> > refcount rather than take ownership of a passed-in refcount, so the
> >> > correct argument type is &Page.
> >>
> >> Or `&ARef<Page>`? Because with `Page` being `Ownable` it would not be
> >> OK to increment the refcount from just a `&Page`.
> >
> > That's just a limitation in your traits. There is no problem with
> > creating a refcount from just a &Page.
>
> Yes, I agree. The limitation is by design. My point is, `vm_insert_page`
> can work fine with the `&ARef<Page>` type. So if that would be OK with
> you, I would patch that as part of this patch.

IMO, Page should implement AlwaysRefcounted and this method should
take &Page. Anything else just adds limitations that are not needed.
But I'm ok not implementing Ownable for it.

> >> > Now, for the use-case in Binder I believe we could switch to
> >> > put_page(), as we don't need the extra stuff from free_page(), in
> >> > which case we only want ARef<Page> and do not require Owned support.
> >> > But as long as we are calling free_page(), it needs to not be
> >> > clonable.
> >>
> >> You are calling `__free_page` directly in binder? I could not find thi=
s
> >> with grep except in the C binder. Is this code you are calling into fr=
om
> >> Rust binder?
> >
> > Via the Drop of Page, not directly of course.
> >
> >> From `__free_pages()` kernel-doc (`mm/page_alloc.c`):
> >>
> >> > If the last reference to this page is speculative, it will be
> >> > released by put_page() which only frees the first page of a
> >> > non-compound allocation. [...] **If you want to use the page's
> >> > reference count to decide when to free the allocation, you should
> >> > allocate a compound page, and use put_page() instead of
> >> > __free_pages().**
> >>
> >> I guess this is what you are referring to? We could change `Page` to
> >> this style as well and all would be fine I think?
> >>
> >> At any rate, today I learned about Pfn walkers, compaction,
> >> memory-failure, etc. that take transient refcounts
> >> pages. With that in mind we need to reformulate the invariant of
> >> `Ownable` to exclude optimistic transient references.
> >
> > Yes we can switch Rust Binder to use put_page() and have Page not
> > implement Ownable at all. That would be okay, because Binder's pages
> > are not higher order.
>
> As far as I can tell, we can also switch `Owned<Page>` to allocate the
> page with `__GFP_COMP` and use `put_page` in drop.

I'm not entirely sure if __GFP_COMP is needed, since the page is order
zero to begin with, so I don't think it makes a difference.

> > But this case still does highlight that
> > Ownable<_> currently does not address the use-case where the
> > Ownable<T> is a special reference there can only be one of, rather
> > than a completely unique reference.
>
> This is not the use case `Ownable` aims to solve.

Maybe not, but then it doesn't apply to Page.

> > For instance, the GPUVM abstraction would be another case where
> > Ownable<_> could be used if we have this other model where Ownable<_>
> > and ARef<_> are legal at the same time. Currently GPUVM uses a special
> > UniqueRefGpuVm type to solve this problem.
>
> I am wondering if we can make case I intend to solve (Ownable is a
> unique reference) coexist with the "at most one of this ref can exist".
> The "at most one of this kind" sounds similar to the `ListArc` use case
> to me, which is a different problem.

I think they can co-exist. If AlwaysRefcounted is implemented, it is
the ListArc use-case. If Refcounted but not AlwaysRefcounted is
implemented, it is UniqueArc use-case.

Alice

