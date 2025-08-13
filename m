Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF449C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 10:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910EC900059; Wed, 13 Aug 2025 06:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8EB900044; Wed, 13 Aug 2025 06:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825BB900059; Wed, 13 Aug 2025 06:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBED900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:43:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A94FB85F2
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:43:19 +0000 (UTC)
X-FDA: 83771397318.29.8130041
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 35BEF20007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:43:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YEncWQRi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755081797; a=rsa-sha256;
	cv=none;
	b=qofmmrioa0xpjJnsuHoHMzczxiyuWL8UmK7NXlmYtvyQ6zVijLtxJTbqIn/9l+kjMbtKBd
	K6U2hqyYOTw7FeM/JT0t4iq2z1tevYPxv26mjORSwuzFDEqn3A6uMeHcBaqsBmd9sENrDU
	Wr4DDkSor9r5xia7iYd5Ha/Z7rxZ/kE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YEncWQRi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755081797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4uE0XQX9BBRs7vnQBat+j8UAbJkeGIyj7RMIBvdIaE=;
	b=U/foVfjwOdvUTrBAjWaPF4GymiMCbLsFe1GECHcxeenIahTaiqXoeLid5wfFny8xmbrETz
	eQpRL5tMkDoQpaJHC6W6l7u/BbXk9JF9c6X0tmrtZYd3lsldHY8IS8TBO8uTJ9u9n+BBK9
	myRsvtuVTe+STnn4mYXfVWm2inV7Kh4=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b913b7dc01so946397f8f.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755081795; x=1755686595; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4uE0XQX9BBRs7vnQBat+j8UAbJkeGIyj7RMIBvdIaE=;
        b=YEncWQRiS+MjxPge0tjNVk85TAcwyA+lHHLKdEKeYzfzstFNVPookwhQvUKg7nI78s
         GCou9UdbFet/MNm7ym7S/JcH1s4M1WWitI0r9FP1auHBmGG/OqNyxtuBRCAbGZE5I1hg
         +Q7e+ZFcSdZ2oVUnEiW3ikgqA6PWOEzANRQeLTWqz0hAbplFCo0rtniSpMtnTSjFz/TC
         SN6cSHoXFu1uQWnMZ5swy/+8+2vUW92YRxvx09MUy9ubehstmQ8d5xdLD7lOOzm8BEA6
         i4IHXQF+paEKQQTVOQtXoMRkOKotdRy8Ay6edSfc3OzJdENGgv8hPZYXcdGCH9YZ/pA8
         Cnmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755081795; x=1755686595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4uE0XQX9BBRs7vnQBat+j8UAbJkeGIyj7RMIBvdIaE=;
        b=N3sKyaVXPViuCyRcDzGYYOXZa2esDC5WWfCrUCW8Zf15ffd7M56ChGAhVPVi3hdcyl
         47m3fpOQQAdm5t4uosyAWQL+dR88T/pwsfO40LBA1j7qiyzZL+RV9haWWNsjkHYN+W5h
         R0c0nwrX35i612tF2kPqv/RlluCetW5sXbGteSqayY0WWAs1JCjt1ItLtAkJGserwLqQ
         HTh+XXaGPJXv9cErISrL8ESC9s0g/SJGfaimwBrR5NVxgnzpfsUxJIyTLg2Z1S6CLFJb
         SeXmelqBoL6Qp043HdePeNVETnjNyyQFeC75rfX5YDIPHyjsvjxDmmr23GlgNZTIA7IO
         JtKg==
X-Forwarded-Encrypted: i=1; AJvYcCUZLZdC4jU7RwHyKMlxPxXyZSocacuKQm1879nDHLTdFpcQGc518X1YQ0xB7NQ+QbNZDBy4dMd6Jw==@kvack.org
X-Gm-Message-State: AOJu0YzdGoiWx94tZ8Zq78BKgZ7JVdhJk+Vpat2H7DaLztUMFxtYYibz
	CnDpflJnhcoCfjcrtGOjtNip9VIeqatuYYN8gVQJ1PI7ggL6aHopMbWdLT8B0teJbunyYdLuejQ
	9fUVcSrocmc7HvZPbbzhuX+NpL1xkHEIUkoQ9WFUf
X-Gm-Gg: ASbGnctDaGG0eJiNYi/WYet2+LPIgzNKCKub9JiS3yzH1M+V1AQV5RHn1fv7FqjVM/D
	hAljfnXBOymFvGRrM3VfWsztPbkvhZsh/L+f51IZ/b5XE7MdxQ9ei4ybIHPUI2/oZbiSXQ2URnj
	3VFBVIeeSepdkoANbKQtD9JluMde6MlRdp2LUQHiMnjAXBVXrtuA00CKegbDy9N6N9wmjJnJFUP
	lRCY3DMqlolMejufRvxN/pCjEqLNUU/3oELKQ==
X-Google-Smtp-Source: AGHT+IF/TV3ToK4rxIMHl5p7DjAnTq4l6H00VcPGxiaF+/Z4Vi/IkaVQ/YobLKuN2AYnUwN4jqZ8h195KcmiHubxYOo=
X-Received: by 2002:a05:6000:40ce:b0:3b7:8473:312c with SMTP id
 ffacd0b85a97d-3b917c6f512mr1752518f8f.0.1755081795255; Wed, 13 Aug 2025
 03:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
 <20250811-align-min-allocator-v2-1-3386cc94f4fc@google.com>
 <DC0N2SBVHIS7.2P91EJSTIT1FM@kernel.org> <aJxESG0l4-kyUHXg@google.com>
 <DC16OLU29VX3.16T0QDJF7Q18P@kernel.org> <CAH5fLgj0kjGBwZFHjErsa7MCV1fz4xTWwrZAcFzHHnkbvS=OMg@mail.gmail.com>
 <DC182DB9HNS9.21ZVBYT6DXHDE@kernel.org>
In-Reply-To: <DC182DB9HNS9.21ZVBYT6DXHDE@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 13 Aug 2025 12:43:02 +0200
X-Gm-Features: Ac12FXzxznSW7kYK-990_IfjHnKYHoLoTPqwohIab_6KCmVnUpHRy9Ptq6yMDuE
Message-ID: <CAH5fLgjYNy3R79nZzPOttk1fx81T+_Q+h8Ug40aVz44TNaCVgg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rust: alloc: specify the minimum alignment of each allocator
To: Danilo Krummrich <dakr@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Tamir Duberstein <tamird@gmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s7hhwou9odnto8kwzd8bm9c4omiggkqi
X-Rspam-User: 
X-Rspamd-Queue-Id: 35BEF20007
X-Rspamd-Server: rspam02
X-HE-Tag: 1755081796-314739
X-HE-Meta: U2FsdGVkX1+4J6C4UTbAbG9K3tzk43ByyOUUMyIQi/Loptz34PJQQXyU4lYJK2wufyWJFtnrrjEsolU6gnd3Cu4pfB4uy4UX0K5+UpAgttXE51ttRp79K5JI0i8u9RRQrEwD2UXyZzaEdWvikFsyrDdejYplXQXjmghPWt6YJpMx2l5Ob+26I4w6RZuIz1h5wHGVN0jn0HAEY273GwLeR2LF0b/hl2M/QxqRuusLLy1OkqaAg/D2Gw+YHBnDeiHEzCEzjUsIHYV6XFcBpsQMss1Ijib5jqGdLigX4xrA8dZ45EbbLwfgHDvbBwC9KNumEd0DfUxH4uDoC20hxXu50xOM1AqjU/GPkV10dJTCxSeWix/zhudprWdrPI+uJGwBxR+8BLeiq4D3Y9Ws/17/IutGRvoFvFww+b5AMwwL9+TNCokbCrn7U5V55ry86NRfwemJ4GBYXkrCN2brs8gm9dapip4XKiVddEOG9dbR8YyKSbYbbKlbOWFM7hJ9UmGqhBye5RNEkywSGYTjiUiATY/WfV7/7c6VpL/2hl2bnnhHUfwPQ45sygGLODQpZf1xsuCupcSNwyAOIWlJ7quYkYd/wPXXeqP5Tb9rCWfXLX99cKVHCPJ7DvJY+8kZiiS1tIHXmxEeJBP7V+vEGi0Qr565o9loA84JXkusBIz53XXBB9dPANfCj02TKyMdB2uPXzhb5U4k7H9wSIzyYcX7qS31NhO4isn1kHrXIpLNdCXwdR2ELOA2cM15cBskuD+3cuD0RFoiy3wk9IxV8XGykxOriJ1HybVDwaF8mUTjPS1MXW+/AfgcLCP2ItQ3V/PEI4a1jNFWkuzSlIkeavxR+PeIYOAaj/2tPbUXs3I9wDvZGIs1yzfg9r3rFyJyHqK2NKqDE6IJpplySC7a3rhwdbQ+7rviif6kmKlPLSoXpoerH2LNuzDuTEDfAxUlMAft0+QbFDpm3afyuzb6zNu
 RLq7wf14
 NISfSL5aIElyNakiNIZPctiyWRQ44uxKII+QwCJOceRjChUeizefFVeuSQUP6ittfXrdmcd+CW3qg7vbrMx7CL5gnpm4fdNYw1UfNbtjb/rnv4glzffxr+x3SaqCjVjBSNpvL6JgckYmvDaUXRAj6MF3Uwc8VcqTuJ7mQ6AYAkfAIeRRKODL28yB6JWWAoGcq04ZreQ4qn22sap8wWPPmeyYlKyLBnpzXm9DuS1JkhM7rvMbOYiMNiHkvFHGxOjBLOW8NDxNlH0O11xIsnxIrKlFf1633uXpmUrRb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 12:19=E2=80=AFPM Danilo Krummrich <dakr@kernel.org>=
 wrote:
>
> On Wed Aug 13, 2025 at 11:32 AM CEST, Alice Ryhl wrote:
> > On Wed, Aug 13, 2025 at 11:14=E2=80=AFAM Danilo Krummrich <dakr@kernel.=
org> wrote:
> >>
> >> On Wed Aug 13, 2025 at 9:52 AM CEST, Alice Ryhl wrote:
> >> > On Tue, Aug 12, 2025 at 07:52:35PM +0200, Danilo Krummrich wrote:
> >> >> On Mon Aug 11, 2025 at 2:31 PM CEST, Alice Ryhl wrote:
> >> >> > diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/a=
llocator.rs
> >> >> > index aa2dfa9dca4c309e5a9eafc7da6a8a9bd7b54b11..25fc9f9ae3b4e471a=
08d77130b374bd1397f7384 100644
> >> >> > --- a/rust/kernel/alloc/allocator.rs
> >> >> > +++ b/rust/kernel/alloc/allocator.rs
> >> >> > @@ -17,6 +17,8 @@
> >> >> >  use crate::bindings;
> >> >> >  use crate::pr_warn;
> >> >> >
> >> >> > +const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MI=
NALIGN as usize;
> >> >>
> >> >> I think this needs the following diff:
> >> >>
> >> >> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindin=
gs_helper.h
> >> >> index 84d60635e8a9..4ad9add117ea 100644
> >> >> --- a/rust/bindings/bindings_helper.h
> >> >> +++ b/rust/bindings/bindings_helper.h
> >> >> @@ -84,6 +84,7 @@
> >> >>
> >> >>  /* `bindgen` gets confused at certain things. */
> >> >>  const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN =3D ARCH_SLAB_MI=
NALIGN;
> >> >> +const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN =3D ARCH_KMAL=
LOC_MINALIGN;
> >> >
> >> > Hmm. Maybe that depends on the configuration? The constant was gener=
ated
> >> > for me. Either way, happy with the suggested change.
> >>
> >> That is a bit odd, I'd like to understand this before merging.
> >>
> >> All of the definitions in the kernel are defines that shouldn't be pic=
ked up by
> >> bindgen.
> >
> > It is possible for bindgen to pick up a #define in some cases. The
> > main case where bindgen fails is when the macro is defined in terms of
> > a function-like macro. This is why we see so many failures with _IO*
> > macros.
>
> I think I see it now, ARCH_KMALLOC_MINALIGN seems to be either a literal =
or
> __alignof__(unsigned long long), either directly or indirecty through
> ARCH_DMA_MINALIGN. bindgen doesn't like the __alignof__() extension.

That sounds right. So yeah, please go ahead and pick it up with the bindgen=
 fix.

> So, I assume you were on arm64? :)

I did in fact build for arm64, yes.

Alice

