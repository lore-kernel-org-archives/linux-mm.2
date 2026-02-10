Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75081EB2700
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5D46B0005; Tue, 10 Feb 2026 16:23:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63776B0089; Tue, 10 Feb 2026 16:23:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45016B008A; Tue, 10 Feb 2026 16:23:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B30146B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:23:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75E94C233D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:23:15 +0000 (UTC)
X-FDA: 84429822750.21.1710ED2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 443B1180009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:23:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q0cDRD8m;
	spf=pass (imf06.hostedemail.com: domain of tamird@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770758593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RADxl9zn/8eWCUoY572xkaoD6D8QMUzJOyrn3h0VZsc=;
	b=BDMb8Tq+NN7X+Nc4qGGGcqJ/4WbEx0CpYVMssd5+/taJ2MwF7UoS6i2P7KbCwsC4uStQ0b
	RLdM+y+hSxMGQQUnrOBCyli8V58LodS8B9rsvedYLLKORYue/JLqZvXHPJWgiy9t1w80W0
	vv96i/t3dU5kTu5Au9lKRYsIYPDRu/w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q0cDRD8m;
	spf=pass (imf06.hostedemail.com: domain of tamird@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770758593; a=rsa-sha256;
	cv=none;
	b=pRrs4OlPyTfsfjJcp7TkEcCxBUihH1VdF2p/tqLDLJv8RO2JvhLukK65aW9e917i8YScDm
	phN96WsfS+5NoUAEq8vKiXBKyOqN6ZDp+Xu6/N+z8EwhurhLQCbsq7fPo5JsLb2O+JJVgp
	ctVQaGq1SjmXfPFfZtgI/AxY1NAhErw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE47844548
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FE4C2BCB1
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770758591;
	bh=4AT+RXGXSCyro2xakJSwLzTq0XsfHO41wcMZUtz2SOQ=;
	h=References:In-Reply-To:From:Date:Subject:To:From;
	b=q0cDRD8mtEGWivMSLFYqUgHyW9VQVCSGtBXgVyD0aW6HcIaXSxV9EGhF3Yhl3z7nS
	 +K8aT6MGliLiyKiRge3PyaMU5vLukQ7ED8BgrxaAupsAlgu2Nsp05FZMfg5Aa+Qf3g
	 8mvb1LRF0YUGmMnKExfL5QQ1X+erIzyIOvgkZenTyHzQvVkDO4PK+/SJHr91k5A8Ua
	 kVaWFLnuP+F+hvS62coIQI+ne1F6V4vfArdiFtpLKUa+C9n3vMf/3U+sVeFKXq+Ucx
	 dvt8IOYhgKXE7LOPcbfOBlJpS5lxGmIycV31LNIyIHaUNj80Km/Y+xaIIRPE+kTAs2
	 sCuPaYnIuB1ig==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-38319cbc8fbso38093631fa.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:23:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXu7xDFLtSWUcyp6y5GWlpIMSr2pnMcQ/I0tOFS1Z1k3V8gXBKxZcSkgjSm4TZink7freMXYaBsEQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8R8Q9lMD8WpF72PLJOQH3YMbgw8EhlOISXgrCHToaol6yug83
	z8je8uTA7iKIB3ccZ+iuLmwwY3XEOkMNzPC/w06mAtUKICR/EHu4AbWbmuN4qtCzPuZY/LhH2jb
	3CDyEwm5hbbwN3CuK97dGbh/ZoQjYS+M=
X-Received: by 2002:a2e:be8f:0:b0:383:26ac:4fd8 with SMTP id
 38308e7fff4ca-38702e9bf3dmr998591fa.0.1770758590169; Tue, 10 Feb 2026
 13:23:10 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org> <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
 <CAJ-ks9njGhT85pgUSahki989Y9vn3XOBNO5wxB8wE+KvbL00wA@mail.gmail.com> <6sd4numrxigibwynr2lfmtdj5uabggrx2l57igtjbnq4uwddrm@wipmwcmqbkjn>
In-Reply-To: <6sd4numrxigibwynr2lfmtdj5uabggrx2l57igtjbnq4uwddrm@wipmwcmqbkjn>
From: Tamir Duberstein <tamird@kernel.org>
Date: Tue, 10 Feb 2026 16:22:33 -0500
X-Gmail-Original-Message-ID: <CAJ-ks9knC3pKpiMaG6f3C1Kr6su9p26hM7YvVMzsVwYVHGtm2Q@mail.gmail.com>
X-Gm-Features: AZwV_QhdvZH0ulXOwC7qepwpvm2i9242YLhbIsO38rOa_1y-e9PY-uFALj98NOE
Message-ID: <CAJ-ks9knC3pKpiMaG6f3C1Kr6su9p26hM7YvVMzsVwYVHGtm2Q@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Tamir Duberstein <tamird@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 443B1180009
X-Stat-Signature: fgs1i96enb5dyb1s3itnubkp8ffd1st8
X-Rspam-User: 
X-HE-Tag: 1770758593-897524
X-HE-Meta: U2FsdGVkX19YV8EFywUquln/CPnj+OvfyFwiivyQ6hf7zzJgPchgZP9J4Odeh0/VxzRc5LscaecIgb+zm8NMHOKcDN53zFagllDhthdQW023pVpOyrmU2CX9aJcBGkndRFBUf5CPEiWFEagsXabcIqEuoQY9fTx0FXL7IMaIkuzOP0jCzr7j8wc4F4Bm52y3jkyLp493hIjCXyPARnT18zVctH6HmjZZ0we6+/ZLf40DVc+8S3n8UEOxSMfTHkV1aqMUppJhMvms+zJYE7dHao46qZVsfiRFcPp4jOZYalIKjeq0xInDLC/Hjhl4nEMkh5Uanqo77ryOBsA7nX+ux6T2FNXlgtKEYch5YfDv5pijNE+WW5XlBvV3LMzauoBk663JJ/wRl3NJRGAn7G2zpFbLCI/YgejKgc2IwCBtmyyWkt0fdDWn5X26UOfw2dDz0ZZ+lUraYCNILfWMm69zY41teiQ9aOzaOINYkTsznqh3k860Ta5nE7NXRtsc3tlVCTb8/2YaiJsL6niVmyfSJS9WNgFlXJvdvOS9vBfZxkPyIdB5qKOdrtd8ZWlnzZEOxYK5bkhwtNesILE91pV1OF9hBvsoCsbyjPlZ+RfGQ5qh/sU8/8/Xc52DWv+1NhFIh5dEDQSj/EihRaETN5+/cF8EZ3GGmJeGpU6ZUyMeb0es/WZREcg4NBd1LlI5/5EndQjqRDEs//+i+3HRgjBoPmsbuaJxW072ONA042TCzsHW4wF+aM10x2Vuoa/4q5O1ln5pTU9mF/MSfiPY6DwqxC5/u58W2H9lDNxBfre7KIdpYKrUV546Cp9xuovwPYo+Wl9kX7hgSZX9WfcUth9Ao7lKcfwZteb3xA0yDIekZh797760tI9G0e4JkI2l8VD2mj9SmEOTwUEvWvYxZQqR72uRJ+mmHK2p/TgMGGjry4KYOR9qcC/m3uBVIMqz9gHoMYuW+YEnkbJ851MpYnR
 W99v6IP+
 Hl0v9/t4tNex2Dl18ef72WH1KH2wGN8dzK6MeVuvYsERTLYLzf0N4hs58Yuwsohe31agwKhT9I9qDdSNup450bA0EuvDp8vbtZJlQz9B0BulacupmQ104yS5QWAZ3t3bR9JrYVR5sxdLIeDjburwQP86XvXROZWRD9L+2zU+TX56JDPy30lC2GQdafLPD7v9bP5qrfp1m2hqe4Y8YjiHKMKKMrWpK2DIlDfO36+uNkhbi3PvkipY0bmYQi8dqo1/l/GctVpLJWYY20VvchLg4YAGEcErhoI0kiYaEawLP0oadP3D+BVvwfmZfTJoIU0vAV4AajljvF6rqifWwLgrs8kLSe2baNk1TeeLcWv9I7XAXWUKvpqhvRpN3qL6T5odpJif2RrSPk7vfMdo5mMzxZbJEi6XK1wJ9g/Tw4+ter0jkioIdrPfIdxA1iQy7/ei1WJav
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 12:59=E2=80=AFPM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> * Tamir Duberstein <tamird@kernel.org> [260210 19:54]:
> > On Tue, Feb 10, 2026 at 10:16=E2=80=AFAM Liam R. Howlett
> > <Liam.Howlett@oracle.com> wrote:
> > >
> > > * Andreas Hindborg <a.hindborg@kernel.org> [260209 14:39]:
> > > > Replace the call to `xa_load` with `xas_load` in `Guard::load`. The
> > > > `xa_load` function takes the RCU lock internally, which we do not n=
eed,
> > > > since the `Guard` already holds an exclusive lock on the `XArray`. =
The
> > > > `xas_load` function operates on `xa_state` and assumes the required=
 locks
> > > > are already held.
> > > >
> > > > This change also removes the `#[expect(dead_code)]` annotation from
> > > > `XArrayState` and its constructor, as they are now in use.
> > >
> > > I don't understand the locking here.
> > >
> > > You are saying that, since you hold the xarray write lock, you won't =
be
> > > taking the rcu read lock, but then you change the api of load?  That
> > > seems wrong to me.
> >
> > This patch doesn't change the API of load. Andreas is saying that the
> > type system already requires the caller to hold the xarray spin lock
> > when load is called, meaning acquiring the RCU lock isn't necessary.
>
> What I mean is that the API can no longer be called when holding the RCU
> read lock.  You seem to imply this is already the case though.
>
> >
> > >
> > > Any readers of the api that calls load will now need to hold the rcu
> > > read lock externally.  If you're doing this, then you should indicate
> > > that is necessary in the function name, like the C side does.  Otherw=
ise
> > > you are limiting the users to the advanced API, aren't you?
> >
> > The existing API already requires users to hold the xarray lock.
> >
> > >
> > > Or are you saying that xarray can only be used if you hold the exclus=
ive
> > > lock, which is now a read and write lock?
> >
> > Yes - except for the word "now"; I'm not sure what you mean by it.
>
> I'm trying to understand the locking on the rust side.
>
> I think you answered it by telling me that all readers and writers use
> the spinlock.

Indeed. The current API doesn't expose load on the xarray at all; load
is only available on the "guard" type. An instance of "guard" can
exist only when the lock is held. The lock is unlocked when the guard
is dropped.

>
> Is this a temporary limitation?

Maybe? I don't think RfL has good abstractions for RCU yet. For
example, exposing load directly on the xarray using xa_load would
require a way to guarantee that the returned pointer's target isn't
being concurrently mutated (e.g. under the xarray lock). I'm not aware
of anyone asking for this, though.


>
> Thanks,
> Liam

