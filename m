Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A09BC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4876B009E; Mon,  7 Sep 2026 10:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC4C6B00A6; Mon,  7 Sep 2026 10:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC316B00A7; Mon,  7 Sep 2026 10:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74B046B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:07:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 012FC1A0198
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:07:07 +0000 (UTC)
X-FDA: 85187142936.16.858C1AB
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA0734000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:07:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a25AtnjT;
	spf=pass (imf11.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788790026;
	b=wRWCEXzDaBR1KXZchtGIDXcHm6+SF7teZbH0qGxxOk9KGLrUgDCzayX0L09mSPNC/GmRuc
	v5+VygWoWB9xBmdx0WDQWGsB4g8V3C19X15/8InnCHY6mYwaOSJId6PlDCktdOtRU1lJJb
	l97F9LuLv6UUSWuyY0y2Wv0RnViiLY4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a25AtnjT;
	spf=pass (imf11.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788790026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vg2AiEFa68ARzliVtiEYWMnugqjIY8Sb5bHhQpyrHpw=;
	b=ibxboD1lnpe01AXgzFc1zCxWPI0/UtNRe+pCwKd3STdq9YCLkMgdGnkWPPf8n7ZHryc1V0
	XWV6kTGaoofvJHjpj6pf34DgI3jUDOsXeN0iQyQMu6a/8AFegytBh1VRbofUnuVljQtciP
	PihxBLGqcPyYgAC9jdF+S13MLEmRSPE=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so43264555e9.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 07:07:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788790024; cv=none;
        d=google.com; s=arc-20260327;
        b=hI1tFy9NaZhHWJP9ApZejOOWmDHwNGDdHWR+vtq81UaNLLlo0z7tbLdB7H+t3nKVLY
         mcRQGKeJFCdBiEosqaT29w9TOHgWmCwKSX6/VGDq8JOY3k6cQlyqkuls44PRUa5h/APf
         2kBjuibprrgEMdwCEfDHbD0IC1tHyYr0ay62tXH3Ai9YVY31JPBMtikG7X3d2SnRFZ4A
         qsL5V7VR/DBKemRHxpJHVzmalcpZRDVy+Lebe2cEDm13qvK0M67ZO1KQ8wT7gN5Y6qsB
         I8BDmAxyvbUJqz04xIh7C1cUlWwjOerseXrrwEe/dMrt3HdWnDtsqtnMHoWQXN2kzasI
         WM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vg2AiEFa68ARzliVtiEYWMnugqjIY8Sb5bHhQpyrHpw=;
        fh=IVNjtcbh2+ym0wWnR74HMcgR9cZIFVF8ksQfUTcBtns=;
        b=kWu9XmE9wEdTVZYQtuV8pEdbZ3hCps7PLe9wxyjd5PjaP0LFyaEV8mibVdLpamfkn2
         SnhXVUBAJjFCI8eaWTTgucEYSp4zUbhORSAkler1yslfw8kS9PiSsSOkcUULZL4eK+EV
         CZh4CdbtXProbsA/oLg1u2/Dnpi7UhZ0T1rwgdbQGJ6SJ7iuEO4L9Pm0Xpl3CMlSManA
         7K66IIQiwkZUw147jvpB602FvnVlhhGqbY7X/bcIoMxYrXMm0E2D9pvies4bdYr2Ki8c
         1IAZ0/PP2R7ttcfzr7E2WqM0bIqVNA5Dnr+0uM3EnvHW1lYa33Oq/b4fner4pL9WASla
         xBDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788790024; x=1789394824; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vg2AiEFa68ARzliVtiEYWMnugqjIY8Sb5bHhQpyrHpw=;
        b=a25AtnjTDMNtH2CQZn+HT0f0Y7EvDBMtJ5hXHM8pMwkUFVyM4xkzieXp41KxqZCOQO
         EONB3k7HRtM/c9M52rlCFjy9rP/z1/zT0hl2Xl9txJh3CC+mdPPm/klEH7n4d9o2t+pk
         4r6ZodCTY/5dRNTRwhRu4AVHkmfHWP9ZZAI7sLTqpflH6uDWXh6COm0GR16nP6kUb+iK
         bv3dc/xqnf+Ayr97wJEN5ULoqsNE9us/1EzygMUhIQ5DWRtQuMdUOva3Pc6cdFRZ0dUx
         kdzg5r7f5PoAeJ2wzKPk7EBZ9EVcVhtNAOWmrwqz21RBbzojIZ8OA68eFGVGKlX2lFE+
         YAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788790024; x=1789394824;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vg2AiEFa68ARzliVtiEYWMnugqjIY8Sb5bHhQpyrHpw=;
        b=FnB11otq8INZmtr93JmiQ/gUWlHs92uKrHICuUwTBP9KU1b4svvbMdhmVIyImR+Cqo
         q3Wdr5oBnt3j8EsSkYgdUmX6u1XNTHt+Xc9O1zt85rXY/uYVaGIUQf4t3nya3UnUDMKe
         XZ2cJgcDxDk8tQVC1E5sQe1ZdAa8UmUNODb7pbrSO3vSdsJ+sxkk8GHXeIV54P9WsGIr
         zx/nqTtpOFLRj2GYFj3pDKHNUTuV3tOx4bxhuuRj1xBP51h795xid5cvr49nlkj5jTKF
         D3BuNz2Zpx+JTZSKW8DLGJfDmhcx7k0a2LNifERO05+DTMX6XdCQrzkmFKumQkZhgVfH
         uJYw==
X-Forwarded-Encrypted: i=1; AKwUvBwenyCwnNWcinh34zysnxpz1PGYwRgUcPEROKdm94yCsc3DkSyw5cpqzt0UsC9ziTm7XbqIn/fjCQ==@kvack.org
X-Gm-Message-State: AFuF++kyEHY52KtqPFRQqEKQCwjY5zossEw6I52AAE+jDK6MR+wt5TZS
	JhLpVUZ7Zc175JaEfPWZA3jEA5p7akeAUTQVzqwRHEEN2MnsdxlU4YcD3H5b1KH+q3j2hSUKKr6
	iw4PibAAGXKe5oWuivjbd4VO8rCEhytbjNP3QIlKL
X-Gm-Gg: AYBFou0pfiiwFnauBivka+VRzrtRF/muoiltk165hPC3g20tE94erfL3bNZUvJTbWUd
	hW/LdDJGHvfg9Ic+Nt4f4TK6BGGb2JxKLMaxipdsY+F5RhZXVF8DtHlRNj0IegNOafiMSj4RBHy
	lXmG+bkXcYFVedfQ1Rr5Eo7MXrwxDP5e1GdrU2O8jIxNDD3pmJP1mW/8yARKS5Dik7UwKDLIttD
	Cq1Oowt9z3TMhTeVMfyuY33cEfJitcvCJVkL9DvmtGKEMDgebYRG7FFmaQIgItIdkjjkQMsxUqZ
	2vH+fsp0x1/vFy4uv1Gu3IQXcjYasgTFUf7keRwDt+lFEFsal7tc/XxERjs/0+rvHVSjQNO/yFI
	u6UW7mcXkfh+j9USpUvSbkS1oSDsAmu4=
X-Received: by 2002:a05:600c:620e:b0:49c:fc6c:be19 with SMTP id
 5b1f17b1804b1-49cff2078b8mr196871015e9.31.1788790023400; Mon, 07 Sep 2026
 07:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org> <ao2WubjLtDuHvRzx@google.com>
 <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net> <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
 <8733vlxmm8.fsf@t14s.mail-host-address-is-not-set> <2dpwVpJS3VbfQ7CmE3HeY4IJSSMXTP_O9sSP3HHHUD7Z29RNEG4Hc0m8f94jKWjFlekcTXvIBA-QdGYrf8w1sw==@protonmail.internalid>
 <CAH5fLgjEfZO9DwcUxaKCWd_hFUrXU+cxiwmRg1UnM2pKD6gPvg@mail.gmail.com> <87zextw4c4.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87zextw4c4.fsf@t14s.mail-host-address-is-not-set>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 7 Sep 2026 16:06:50 +0200
X-Gm-Features: AcwNN1U77QgBa8sE7Mjd0WimH4SDjDY5r-Et6lPB5NUv3A9JgqpUTtiAXpyWSl8
Message-ID: <CAH5fLgjYmvp1Ph3dYXnTKkAvWgNpgCAPeq_7PZhRai6pCNmVmw@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EA0734000A
X-Stat-Signature: f3z1fcumjrhmrrdmexdj4d5a38db9fme
X-HE-Tag: 1788790025-449288
X-HE-Meta: U2FsdGVkX18Z8lxJ+Q83ojeN6W9nKJgfzjQ0T3HmVwoe8czk2kL7uKRAxUbHZ6+pXrkghI7dj3NkDVYcWxSc43Tsp59dL1xev5ba+6Ln0J3OKBhGyhf34CnT4nTEpLYhz2khtIw7wvoiBl/mzvz04A4FuqtkPN+K6WSWkpJchDrYkKtfQGNsNO3X8irEj2EzdeWu6dHg6NalJ7f+jS20i6KOg0tmcSwoBpBewJRP2mHbVmw2jm66Gjpp93q2ctlZaif/LnVPAecYMGR8e99eTGSfokt+kiTvgC2hY81zumZNXp5pYyyPwd1ZcrCNzOXfbBDIJcVWq9Pd59d89x45xhcCaY2CHUHdXL0ieMjU58A071hsiufhrWN7mVTZ57j4Wxl9iyDcmllOn6H73jmuN3fr9AaPxSqYga0FFzwwcwmbw635K7ayVECt4rcQ2OBMrS4SIXTvTNHKOOGOCn5aZ3T6rt0KrA/FdypI7beV8+xkHJ/gzpuA5kBKtfwes+pwz0AWG6IEv9WHd+pJorKqc8xv/aUV4DUWGGD3wSId700OY6v9b79K4Go77KrKmCAe2siRdccHq0xbjH63a/3WFbvQRFICqkGmjeXs2ih/duoO1QFjLNV18+FaKSu4c2cYkxXxJNuhkAxNnDBMbPtjdFRM827wnyZ8ZUEGHl9hllPivK98XsiGQKJJvrLk8uwbBgYvb7p/N3ZTZ3T8jP/oGzLT9otHDeSbG7BwUIZfZoaTZmxsdRz9rbKrwJl+ABMJHQ2EXp2+S6Ql9LjGtXFYuPqObyOhxzbrlC8BQPS87MNUBfaxfvnafW2iwVTvn07GR6BVC0PZHRvQQI9a93AWaeOYHzJXOzKpzWRDxJcZUfbMevXo2E9BRBfkS+/nYy7GWU+vxHe2ujavqZ6jqlKhZl1frRNJADGAA+U47T7pp5zpEClp7wjRx7K6vW0K6GtcVHbIKXR9snAjZ9IBtKh
 gcLofOsr
 EpiLhoDSNz7x7mwhmrnzVnYgI+XDq7c364oltoDHD5rSxLOLhFycoKzyi5ZnUQdkppPsd/qyBQw7axWb/go/wXrcSFKQHw0UiApDkzBOkb8L4BtsPQZ0TvhwcWqAXS3EcH67ILycjnxEOqrb4F4g1ESCoidn+7Af2OmKXI2E9pybt8p1f2+Cpybd1NRi1zcowhfxN9a+0v3X8WXsAac+hYVqHXJwRVN561FGuI9UC1+vpDKq1IGAvdSJV6hXY6U+JdBOhyEwMjXpX4KlTN380wRGeJ55TRrGIKqCFdWfIxOo3o2AYJyjOEmdFyYAQC2L/FJwJ33s3IYZi2YeF44FtrhFGRAOehfsHH8dNnSCUjRReB4SoVxUn9Vz/MGILoaR6sX01iUd8FV1v0giDqHodYIlPCUUpB8GZESpvOWQs9Fwn3SpS84WMKHoGyD9Ttdq+5oG5NOr0biIwvgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 3:58=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel.=
org> wrote:
>
> "Alice Ryhl" <aliceryhl@google.com> writes:
>
> > On Mon, Sep 7, 2026 at 2:38=E2=80=AFPM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
> >>
> >> Alice Ryhl <aliceryhl@google.com> writes:
> >>
> >> > On Sun, Sep 6, 2026 at 3:02=E2=80=AFPM Gary Guo <gary@garyguo.net> w=
rote:
> >> >>
> >> >> On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
> >> >> > On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wrote:
> >> >> >> +        // SAFETY: We just successfully allocated a page, so we=
 now have ownership of the newly
> >> >> >> +        // allocated page. We transfer that ownership to the ne=
w `Owned<Page>` object.
> >> >> >> +        // Since `Page` is transparent, we can cast the pointer=
 directly.
> >> >> >> +        Ok(unsafe { Owned::from_raw(page.cast()) })
> >> >> >
> >> >> > This doesn't satisfy the safety requirements of Owned::from_raw()
> >> >> > because the page may be used with vm_insert_page(), which increme=
nts its
> >> >> > refcount and causes it to be shared the vma system, and this occu=
rs
> >> >> > before Page::release() is called.
> >> >>
> >> >> I suppose the existing vm_insert_page() abstraction we have is alre=
ady
> >> >> problematic, because it uses `&Page`?
> >> >>
> >> >> Maybe we want to change the API to use `ARef<Page>` so it already h=
as to be
> >> >> shared? Conceptually it takes a reference count from a `&Page`, whi=
ch isn't
> >> >> possible because `Page` is not `AlwaysRefCounted`, so it needs a `&=
ARef<Page>`
> >> >> to be able to do that op.
> >> >
> >> > Honestly, the problem is the safety requirements of Owned::from_raw(=
).
> >> > Pages have a "special" main reference, and free_page() does more tha=
n
> >> > put_page(). It even does something when the refcount does not hit
> >> > zero.
> >> >
> >> > The correct behavior for Page is to allow the user to hold one
> >> > Owned<Page> whose drop calls free_page(), *plus* any number of
> >> > ARef<Page> references that invoke put_page() on drop. This way, the
> >> > owned page controls the special drop codepath.
> >>
> >> This does not mesh well with the model of `Owned` behaving like
> >> `UniqueArc` to `ARef` behaving like an `Arc`.
> >
> > It's a different case, I agree.
> >
> >> Please help me understand; with page having a main ref and an auxiliar=
y
> >> refcount, if we model that with a single `Owned<Page>` and a number of
> >> `ARef<Page>`, what would happen in the case where the main ref (`Owned=
`)
> >> is dropped first? Is this legal?
> >
> > Yes, it's legal.
> >
> >> My intuition here would be to follow Garry's suggestion and have
> >> `vm_insert_page` take an `ARef<Page>`. Can you elaborate why this is n=
ot
> >> an option?
> >
> > That would be the wrong ownership semantics. The C side increments the
> > refcount rather than take ownership of a passed-in refcount, so the
> > correct argument type is &Page.
>
> Or `&ARef<Page>`? Because with `Page` being `Ownable` it would not be
> OK to increment the refcount from just a `&Page`.

That's just a limitation in your traits. There is no problem with
creating a refcount from just a &Page.

> > Now, for the use-case in Binder I believe we could switch to
> > put_page(), as we don't need the extra stuff from free_page(), in
> > which case we only want ARef<Page> and do not require Owned support.
> > But as long as we are calling free_page(), it needs to not be
> > clonable.
>
> You are calling `__free_page` directly in binder? I could not find this
> with grep except in the C binder. Is this code you are calling into from
> Rust binder?

Via the Drop of Page, not directly of course.

> From `__free_pages()` kernel-doc (`mm/page_alloc.c`):
>
> > If the last reference to this page is speculative, it will be
> > released by put_page() which only frees the first page of a
> > non-compound allocation. [...] **If you want to use the page's
> > reference count to decide when to free the allocation, you should
> > allocate a compound page, and use put_page() instead of
> > __free_pages().**
>
> I guess this is what you are referring to? We could change `Page` to
> this style as well and all would be fine I think?
>
> At any rate, today I learned about Pfn walkers, compaction,
> memory-failure, etc. that take transient refcounts
> pages. With that in mind we need to reformulate the invariant of
> `Ownable` to exclude optimistic transient references.

Yes we can switch Rust Binder to use put_page() and have Page not
implement Ownable at all. That would be okay, because Binder's pages
are not higher order. But this case still does highlight that
Ownable<_> currently does not address the use-case where the
Ownable<T> is a special reference there can only be one of, rather
than a completely unique reference.

For instance, the GPUVM abstraction would be another case where
Ownable<_> could be used if we have this other model where Ownable<_>
and ARef<_> are legal at the same time. Currently GPUVM uses a special
UniqueRefGpuVm type to solve this problem.

Alice

