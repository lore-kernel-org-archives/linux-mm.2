Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8918AF3C986
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5B56B0088; Tue, 24 Feb 2026 09:52:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63AE6B0089; Tue, 24 Feb 2026 09:52:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AEB6B008A; Tue, 24 Feb 2026 09:52:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE756B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:52:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 346EB1B5320
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:52:49 +0000 (UTC)
X-FDA: 84479642058.15.F5ABDC3
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B7B120017
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:52:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X9V1M44q;
	spf=pass (imf03.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771944767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHcX/rh6tRUfCgGWx2lmhCiMrVAEeWUcSr7K4fvJPDI=;
	b=RSj+V/+F7BX7lMaBp2VoDxbIvr/mCHVQB6EoKMh34VEEGAVKPe7MTWvaz1VOK9GhrOZuwx
	MsprQIUvsXvOpy5NLJdVJkzonwm32ZA02kqZ6KN04JvwIx0jE1u1yIYTdj7L4g/uc7tULk
	8gXt5gfgE5tYTzu5B7Scea/eq2c4QvU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X9V1M44q;
	spf=pass (imf03.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771944767; a=rsa-sha256;
	cv=pass;
	b=s/vR+MFhzxjbIfr71kuGnfYQPVVAH+LZYRPO7tNzj9SvAo/KV0aGJfp8NcPtjLn/F6R+Mt
	+9NoFzHFxpe5stLi+9rfaWL+A9TAQI4o+l9q3xaJjxPJDv+vdajHWArCXoAQK8KY5/ijqM
	ViqZJ4ZEw6NkumFC1wJfgX7paPARyi0=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-385c23b88e8so46910551fa.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:52:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771944765; cv=none;
        d=google.com; s=arc-20240605;
        b=ENL7zk9g5cP9mPdWwo/FZJFTPWFTDImsfJNpcDrlsFiuS28EFHg0XF9ol6OoyQHA6z
         x3xEtGwuS3qp8JY2HSnXjjICclEzGlvVBcuRrrwHS2dbo6xzaUOV6nnkDTggIAwG1zad
         /EUwfKx1iF9Xt9VWbe0lDBW5fCaCcpar4Y0jiZLTlhYIgjcQTJOFGfskKzUTi63cY5Nk
         OLOc5u5MmVGDGCG0boR1vbk6reWXYjragcMUPrEyjhiOs70myHiAwG4FnUG2FMMSGYlS
         WfqRPIaeGgZTkz0B5cAJXRHscIN1z6C70PbSqyQ/y+qKhZMdGOpSoFLqrFCXUUWz9VI5
         Gwzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mHcX/rh6tRUfCgGWx2lmhCiMrVAEeWUcSr7K4fvJPDI=;
        fh=CDTQ3JnnJFbTLqf/Ud6b1cwR/OZvMB16CJU9xhL6Tfw=;
        b=Shipch1OOfiwzP2DhCd3MnGaRYBgNbHP+iJx8hwBeqAWd/NmJ2eX4k6Ox7by4ezuPt
         7b8FLC06DkCtDLjxlwBx5QJjJGCya6hOs6EXKSqOndbwrD7YYd/AndK/Qp+TXuQbN46f
         ZadRpwXbr7zlGr77T7QUZQdUy0VSlJ1MACuk5VAudC7M//tvxWtgzfMJHvEh3GcrXnp+
         wsbSLSVzCXYrydD++wS/89j9t/Bthd3m6or29l+HegkXyHXm2H5kSY3jRdQFXzd+npM4
         OaNMeGxqkSrr0bVayWxy85QiFXwtin1oKVvc750Ter05CZmtCFkbu4J15AO1ed7I4BZt
         3Xyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771944765; x=1772549565; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mHcX/rh6tRUfCgGWx2lmhCiMrVAEeWUcSr7K4fvJPDI=;
        b=X9V1M44q9CzEqjiZQEuQYmbanQcw+QUEzhn24ofvQlE3jOBee1lkEN36nqnlpWl+bJ
         DvWfA+EGcOUjzuxUzQMOF9K1o/FdHrayoOJp3VTUSWNJz2ijCK2u0WlNXsMLNnu7iipS
         FXeH1LGIGwaoWN1kuco1FTIPbR0pryDqBvMhCVJCwxlMx+g6lZESzXH6dgLynycmxnuU
         nm2Q4xO0szn69GpzjUGGcDUOgpm7UNDVogkYmsNT8qclRLi8ehGQmCarjcR6jw1GDZ3G
         d5ivmCd5lMoEwZlhSISBI5gKLXCqgJ9Pj0UZWqcxHnvhHOoW2PKIW08yPEI5Tlv8lmeG
         jKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771944765; x=1772549565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mHcX/rh6tRUfCgGWx2lmhCiMrVAEeWUcSr7K4fvJPDI=;
        b=XATAoJKXYcJ5SW6F92vJQduQ+mJgJ6IbNeL+cWUVZMVJylCP6BSl4VZJBe+bqP8QW6
         bS8Wh2B30dAlypasvr+yJ2+tCcP20xyIzIJDZhfshmlNfJMdGE+C2RdOYIfsjo654XXA
         dl7wU0I1F/tSkOLVxNzv+J7+3VNtye6Oern2x+eOjjVf2x0CsAMdR3Up3mAgPE7pYpb8
         SwOH/DHvUOi88xw7gVw78+iWw3nT4JNzMEqV8JgIxnbgWakK71Zj8fLg75i4KXI18HHK
         CFqQHu2RAPi2p57Qo7ZxRstQjbN9cYVfSVfaLxyvjzLbzA23q1tZsHIPJ9m2IgfDDE88
         9iSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlI0d1Sc94IaOHcfOsJNGsm82BX7o7hCWnJJ0+ay3oTnriyJeARrFovvRNhF+JXCZu7fHzefZzzA==@kvack.org
X-Gm-Message-State: AOJu0Yz+nUqTxwoUOSoSHg+EGy+bhDHYlELUOxdH0hcDweRUrdiOSpgQ
	Snkp31QVBiaAYVEbGVE4jwWJWbQJHkQxLKsxi2eRrl30o0dS1wmaW2knX+4ZJNUE/wteHHQUFbm
	sL5kv7ul37OuiCl7khLWFjS9dkXvPa6U=
X-Gm-Gg: ATEYQzz0J9ZDnEw1vFM2GIe1C6IigDsSfcipwIhryl6SFUPXP+IQV6rxHHO2JfeaMHq
	Jh5lBxZipDpqS2OD4dz0hmKQv7ZqLIa8BRpFEL0DC1TuJr2CkqfbGkiCEa9YhX+Dq7+QMqPXJF8
	RII0v+6iJUMMz/Mj1TZqeE92MKqZmUgOqMiib7UiEcPublLtAPYZX1L9qm7QKD49nTID5KLEzdB
	qortagME8KBpbbTfZtIPLIr/GWkIpTTHZirHq9+j4mM4yZoUUT7xbJZboqHEmVE1e89rCpURhLG
	fHvUmGOzej7Ao5h+OKpCw0JNI8IWt4PjFQ4DWC/p5+aAmeeBie5+zk5LmnSyAU8hd5Ea130MkFp
	WtsXjtz14IL8rmRBmtw==
X-Received: by 2002:a05:651c:31d2:b0:385:c7f0:2b1a with SMTP id
 38308e7fff4ca-389a5bfaf3cmr45288531fa.33.1771944764898; Tue, 24 Feb 2026
 06:52:44 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org> <CAJ-ks9=hWB2eFcEj1obfsoLvK15=YR9y=hifxVyeB=mJOz+gXQ@mail.gmail.com>
 <87ms0y1akt.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87ms0y1akt.fsf@t14s.mail-host-address-is-not-set>
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 24 Feb 2026 09:52:07 -0500
X-Gm-Features: AaiRm51E5g5hu-gNZ3KVzmobV8NCSlGexxFTi5VRWK0zHfaV6kQEmjkKY0e45lI
Message-ID: <CAJ-ks9mtwo6eAvmT6qbL+Mg_=A+-zdtiBw6BtsfO2eZ8HbkXWg@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] rust: xarray: add `XArrayState`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sswcsp3sma737tx7mk3uzzdnonxgm5a8
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B7B120017
X-Rspamd-Server: rspam01
X-HE-Tag: 1771944766-602086
X-HE-Meta: U2FsdGVkX1/kHuXlCKK80CsB7hx4BW3J62Jb36WMqCRwKMSaOEDPXnypTL+RMJZWVwB6eSiX4LrXPreYUZpbAzMm3tsb7pFhxyn0pQbAmITUD3QoGRcq+PBAmt/06NttPD1fyauL7q9jr8BqxbEc0l37kRI5Sb0sbbBHzQC7cer5IxePqzha8MPzjaepfN3y/04sLB4enNy98oyWoPCGfPbBJ/qaqV6bSS6VAmcFYYvyzBgqc8q4MXagizTNfn6FcbRcqRujbZOSEemitq1dCLcqe6SeE164Ojpf7hUqKou6+587vt53IMSIAmYhfH5PuyBWu57k6wVgeNjIp+N04P+BbSB1Hee/gTloOiMD9Bg8Gseu/9lmy0zl5NbsYslIvH3xco4zA9h+e92PeQsUDzfzxNCYbaOwBCMN8NLQ2BLE+IdurxlO0vqR2Tz5rWRzRDeRh4gkkStRWYo2RcA6f1/9/odvu3N83YU0dIGhFPd/+qr0MoK4t2R+TDoyFAadkoQCHfoywXzCXTRt7Kjtxm8UvEcgP/5Kzl2pvCDHBIOFeh85m6b6/z42CoAxqhI+Kfaqz/ZVbW8kEhSN05mxnVDLHzAQIFD5NPXwQSNf75WcKWoBBfXbMx7fOKMfQ1swkiuPbgWklkVWUjj9E8KQqyLg+6YvII/mcvrCZrDm8KQGp6hoNtEhs3TErw+bFVtmVuB7p3BjVY7HytxiweewluDtB8Es1KpAfbQx9DEEsPP6BtvzRapU9GCNKdldX3Mo8tNGz+hnr2V7sx1VzWt0lqmdMtXUG+zukHHxEtZzMRCvquyNOiyH6IWDXiP+pKDxaDPIzX0q2BQm+7HAAAivWXg2GkXqcFN97ndqSXDwXXGkvIy1NgbXolXR+RwW6j35jpTvipY4t14kSMoUjyDoLn3CG8C6cncGpFAv7vDJI+zlWXvuyEUWdFyimDWzGO7L7x7X6M8x5BNgTyWAguU
 cCATc6Gu
 X80hsCJ55lIDGRsEkDaD5vojfJ+OJ+ccaqAWdcx5MBIaCWDMWg5r3cXCVMGPHBJ0XVitBYMj5b/wM3Bq9P/uqd6Wicb5Qw/pEZ1D9zqZ6jelVMnOPuwMtoY9nb32hs5nrLHq85Z1gvOCcbqyr+Uks5nTpfw9cVUmmYooT3MVyREaR+gzRLn6fql36QpUw6pDhMUo+Jf35JcC43zQuVIuiiBHyk9d3O5XZmDiDndpfjIP9aQuPlbVerqQDx6amDdJEN74VkvcDjmJxOlp1CwZeb9jMZ34njrJ5vDNUxHBiqlw5j/qsNZnB5igjuthxOdHzq03xHv+PNT2Odi4qcDXACiQ6ylA6mxVAo22jtIr4IhurYC3jjj1waW69rnYAt0e+PmSof4ALbNYBE1WC0cW0WcypgYGlNULjp4OfkYEy8/Ke7aqA5zWapplicuZUzMwXvSGlBm0BUWhBkv0EpF5sUwgMw7UVSmMrLlj3lCYtzN9W35CnzVo1ZdRgCcgF2zpYVPVhqOEhjqIdyHQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 9:27=E2=80=AFAM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> Tamir Duberstein <tamird@gmail.com> writes:
>
> > On Mon, Feb 9, 2026 at 6:39=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
> >>
> >> Add `XArrayState` as internal state for XArray iteration and entry
> >> operations. This struct wraps the C `xa_state` structure and holds a
> >> reference to a `Guard` to ensure exclusive access to the XArray for th=
e
> >> lifetime of the state object.
> >>
> >> The `XAS_RESTART` constant is also exposed through the bindings helper
> >> to properly initialize the `xa_node` field.
> >>
> >> The struct and its constructor are marked with `#[expect(dead_code)]` =
as
> >> there are no users yet. We will remove this annotation in a later patc=
h.
> >>
> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> >> ---
> >>  rust/bindings/bindings_helper.h |  1 +
> >>  rust/kernel/xarray.rs           | 41 ++++++++++++++++++++++++++++++++=
++++++++-
> >>  2 files changed, 41 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_=
helper.h
> >> index a067038b4b422..58605c32e8102 100644
> >> --- a/rust/bindings/bindings_helper.h
> >> +++ b/rust/bindings/bindings_helper.h
> >> @@ -117,6 +117,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D X=
A_PRESENT;
> >>
> >>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
> >>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
> >> +const size_t RUST_CONST_HELPER_XAS_RESTART =3D (size_t)XAS_RESTART;
> >
> > Please add a comment to explain the cast.
>
> How is this:
>
> // `XAS_RESTART` is defined with type `struct xa_node *`. `bindgen`
> // cannot generate pointer typed constants, so we cast to `size_t`.

Can we include a citation or explain why bindgen can't generate
pointer typed constants?

>
>
> Best regards,
> Andreas Hindborg
>
>

