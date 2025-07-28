Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CCAC87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 11:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C206B008C; Mon, 28 Jul 2025 07:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CD36B0092; Mon, 28 Jul 2025 07:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB2B6B0093; Mon, 28 Jul 2025 07:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3EF6B008C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:19:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78842131C04
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:19:44 +0000 (UTC)
X-FDA: 83713428288.15.54E9AA9
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 835131A0006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:19:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=joIh0W3q;
	spf=pass (imf19.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753701582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbmSA0QipmAIbHbKw8GhXr6SE1pl+CI9qEcVQNYIoK4=;
	b=N4eDUZodEzAxHBH6rjtmwfBBLJT+i6iHXX7Ac+gh7eS7gwOFg+4U2N1kckzZldcg5owTOm
	vnDEJjQScYZ+eiHzg5P7Ba2mF68RoN5k7BDzM95UwnZgVTRxC39jZthA6FB8A3LW7n8X8e
	gbBr5ipd/JUQ/S5eGQOz4dTLE0kUYZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753701582; a=rsa-sha256;
	cv=none;
	b=vmMG1Vrvyl65puJL7h+LBbGBn39uRfy7H1R8ZPIAujiBtvB05QSyB8RsV080aES+G0Oo7b
	djNB3Lv3LVdin4SOGt53mbxFOQV9PkvNZPqHUR5IRIKUsoAsFjUbf22WfpAQgJawA/ct7l
	he147teJExSSZ9q7xTPmHOfQfR8oNfM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=joIh0W3q;
	spf=pass (imf19.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a4ef2c2ef3so3660871f8f.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753701581; x=1754306381; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbmSA0QipmAIbHbKw8GhXr6SE1pl+CI9qEcVQNYIoK4=;
        b=joIh0W3qiQ5ZW4puK3VY5bzHQLh4+ocwwdBIKbHh/YOITZNIdfj9bwCoK62FsSjYwu
         nNu94/hRTzWSl4liHMORdfaRiSLZhraCXBJKkN/csVFmACQFyfxVLD0apKELPXqwq7oI
         kufy2CySMPFtCeY4oIybrc6+jxASor/0RV95pyKW3mixbivUdKzZHDBLUHq08l/C2Mo2
         EW47drKxnCEHYHvSKkSTxheBLLYsq63gF08O5frW9SWfTtI9rTc6/WwtHDmljY8NRiJK
         iFbAlP5eDP51aOzXivqdr87vxem1+7OeqYH3ukyP3rlgLi1xWlNp1GgliQy4l4gHfX2k
         1oJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753701581; x=1754306381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gbmSA0QipmAIbHbKw8GhXr6SE1pl+CI9qEcVQNYIoK4=;
        b=ljk9lVhJQQhOmu01juc9XKKgxc7tGkPjsQQKaS9zOmk3btWxsaUkRLMhZ6Pb1N8TQ4
         zBBuRkXz8yQ+dg6mMhaamaIcyRUfhDzhPar2yNfuw/HHHFKfSQB1d9RDG+R7pv3knUZO
         qj7PCz6EHtcvp/LFFVAtwI2AldCy8e8QRzKHyZzLEfZGHrr/WGsd7eGn5IpGtO1DLjRA
         FehbFsTULM5oHyRH3hldSLiBJdh9FZduCCGmawINOK6Zu08P16ZSJMiPbM/uboHsuCCt
         7bY9BRsaTfYgmqROFKGtfvvF1es9UBKHA/sLE6wGaxIL+PxLfMzfIPendk31kpnIs+Dt
         Ljpw==
X-Forwarded-Encrypted: i=1; AJvYcCVdR5B21n67FSN6AoL52woUOVjFRO6DinmQZ8MdICXvKSeWI2YDT00coDL86wnlBctAD4kmH7NKNQ==@kvack.org
X-Gm-Message-State: AOJu0YzfGIDwAfhfEk+RYG4F/1o630qh2nMiOhDYaJczg0Di1QyA41QW
	BuNPDhn6mfDyGhQ44u6dJFa6Dd93yzGCSut8KHJ2r89OCBxl4NcvRemWVofUr0RFUznczhRk7qJ
	zYAi9xpQQtbm6QDeBvbhHIZrSKaBx/pRhfz/EJfpJ
X-Gm-Gg: ASbGnct+cvMbBuWt60ARX06dlecVLTJx1zcXAySuRVfIVZQ6ok8DCfiYNGqHfkrdG2I
	s0Rqo3rw+2hoFceAoOvLlhDiGqk/ESXT2ftIVul/y0dazvYIgKh37JgEMQ0I1qPSYuDhZ5Aqn20
	4nCmTOKJUE/LcLM3ud/DLMtsyAbandOTRK1Pq0Nt1k3N8oMVhotnVECX1h7Fsg3DvINS8po/s5l
	DGp9XG2wAAcHnyGYP4EVNowY51fldp+TSjX8g==
X-Google-Smtp-Source: AGHT+IH67iNxNSkrojY3fM95xQae5TfwbJj4xs2uDRg40WNQDB01MpvP3CEcQwXZKV/Ly+szDBAKEgcdFxAhv/DfOFQ=
X-Received: by 2002:a05:6000:290c:b0:3b7:8832:fde5 with SMTP id
 ffacd0b85a97d-3b78832fff5mr2866538f8f.13.1753701580696; Mon, 28 Jul 2025
 04:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com> <a4b93eb0-9742-4f24-86d9-486ce87fbed8@gmail.com>
In-Reply-To: <a4b93eb0-9742-4f24-86d9-486ce87fbed8@gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 28 Jul 2025 13:19:28 +0200
X-Gm-Features: Ac12FXytrZNUlSdOYgH1ca32A8QXnXdUtZWRs5mU3kT7ILNpSGtpDjWYR9OsYM0
Message-ID: <CAH5fLghK9RhbEXAW4fYS=61Dps34+jgv1UGAOMf7_LD0DVO6rA@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
To: Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 835131A0006
X-Stat-Signature: hn411f5yc34fxrq3u667tzyb51bxze79
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753701582-77582
X-HE-Meta: U2FsdGVkX1/hBjTYEXOIGtkySxu2NTNgDXKj0Ev+JI4VCjNeK2wD5YY1Oi2f4GIxnfsfi147f88eQZspHXwQchcvQjbfm1LhY8JH+CjlDWZLPVuX9CwZwozpVZUvntUyRO0nWpBVP4CvSitChvDZHLFjf5K29IhtU6LeoZCCZ2/63UkCj/sMqGsXd5eWyzZsFGbYuNY0PS39jh3vcOK13XJkJKZoNOrI1ojLh8pvzIUkOrV4nEFUBEh3FnvXV9a88mfUmx20sw6nnhyR5m7Qx7G6SgU+Ia8+/vlPnZgltSw8fggDGRYZHIER8F9Dvb9c4EoAPDDO9/w4OOhVrUxwN/uuMDw59cgPVF99HbJIMEQrqcp9lz3fiQYSbquZE74Ze/luAtywm/yh+PwKaBD+oXxNhUoIG/+3SslfzHH1aaJM3YEd5/Eg+eVrQSfB8TZrQA+vYbBz4yAdqs/fiANPhi0oTAY5yBMS2xdr1kEal4o3/PDtrqWRBxHZvZzxIh+Fq0XYARG2IXzKtN1lNs73Q0sGSOCidK8dvau6zxCQdJJUeeQYp135u7h8599+VsCivFg9spO4tUiY8/W7TxnRRnWN2e01/Zi+YeayPn+e07GlKjAt7Uou5DNbui8SwgChUkBw9ZonydQuQplxi4X+iJom5fibwrJTK8zhLI/twP//zO8k3gVYdfvBWnvnt2AViz+ZfLBUHvNueQdP8GXn74YdgbloQpKumf+YpFwU3ka5jn5Oz5Mi3EKOWYv39OAzYBdAyRSy0eOLGRQ/7UaUloqwPvHn9QFtOMSEsELbZlVxidMqdrTpZrISYb09tMegNJercIZP2yIdKkD9fPMXlk37L0Xli+p/b+dzbUkvcX4ibOpK/lu09RzNu2pb/fk2zvtwZ9aReaWEVrUDrmxi2PtvDX2cbiNoTKV6tzlijRE5RcQPgCAwp1euyEkxDQ0xOj/4b2W8tlnBAFMkaOK
 1zfAuODA
 5Nuq88QUE6cgznJoNdvMnwpIWbLcqwT8B6ROc6tdO4nBF7uUDs1R2U0LQqP745WWIdbwm1yaUn/3oqRMf83bPbVeGjpqOo87ZZEDew0ofvSu+V4/v/Hw+5qq7anBDnQHtfCn03Y+5CG3x1R+sYmA5yHnxDspMIOnYd4pVkj0cdOraXaR1/WIG8NmIBqhUddRCkBG3mUCDDKGx+vKAsdy/T0L2lLSy0FK2xaAZHzpTbU+taPmNDlvn3L1T3ci2DrXLYsCZQ6Zr+ZloqI9NGWW9axkYE8PKLGyewJrwoiCEGl34gb95Es++QABjGuyHhsUVDNklrg6sveJr9hV03LzIlt0+JE+2oTnjawT3t3bEEP9dUbs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 1:11=E2=80=AFPM Andrew Ballance
<andrewjballance@gmail.com> wrote:
>
> On 7/26/25 8:23 AM, Alice Ryhl wrote:
> > To load a value, one must be careful to hold the lock while accessing
> > it. To enable this, we add a lock() method so that you can perform
> > operations on the value before the spinlock is released.
> >
> > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>
> I have a couple of nits, but overall looks good to me.
>
> > ---
> >   rust/kernel/maple_tree.rs | 94 ++++++++++++++++++++++++++++++++++++++=
+++++++++
> >   1 file changed, 94 insertions(+)
> >
> > diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> > index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3d5752b=
4f5337fb6277182d1 100644
> > --- a/rust/kernel/maple_tree.rs
> > +++ b/rust/kernel/maple_tree.rs
> > @@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<T> {
> >           unsafe { T::try_from_foreign(ret) }
> >       }
> >
> > +    /// Lock the internal spinlock.
>
> probably should add #[must_use] here.
>
> > +    #[inline]
> > +    pub fn lock(&self) -> MapleLock<'_, T> {
> > +        // SAFETY: It's safe to lock the spinlock in a maple tree.
> > +        unsafe { bindings::spin_lock(self.ma_lock()) };
> > +
> > +        // INVARIANT: We just took the spinlock.
> > +        MapleLock(self)
> > +    }
> > +
> > +    #[inline]
> > +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> > +        // SAFETY: This pointer offset operation stays in-bounds.
> > +        let lock =3D unsafe { &raw mut (*self.tree.get()).__bindgen_an=
on_1.ma_lock };
> > +        lock.cast()
>
> This cast seems unneeded. lock should already be a *mut spinlock_t.

In some configurations, the type is BindgenUnionField<spinlock_t>.

Alice

