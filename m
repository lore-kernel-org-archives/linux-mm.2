Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588C9CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 09:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5258E0023; Tue, 19 Aug 2025 05:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD3F8E0002; Tue, 19 Aug 2025 05:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9F78E0023; Tue, 19 Aug 2025 05:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBD8E8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:10:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B1FD118386
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:10:14 +0000 (UTC)
X-FDA: 83792935548.23.0FC52DF
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 78B3E100005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:10:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AdRC4prs;
	spf=pass (imf14.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755594612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9/jnxBS7I1AR5e/02apEhjBpEazFeyENxAvH1Nm6yo=;
	b=BYjRmrzySy+eDgw5CG6jskkrThBholHES+FBjFPMOH1lkBApXVNGRTOhM+C/xY3CJVeLNg
	FmC31GNS2ZIfhp9k17AkXS1QESsHR+cAneXV8gpngbsnX3XjeDHorVh5hB4eKttsYUefnh
	caSI+gqmlJswOvO7vTAcgZ8L6ip/5pA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755594612; a=rsa-sha256;
	cv=none;
	b=XiBlSirmvaF6m0OotR4Jt3J7DdOC1R6QeeoJuo9x1s81SThOrMI0jFh7Si+o1BTwvs5ZXL
	9LMslEjYVOvR/QClSb3nTU8d5DAL2lhrN0Ie38tV4ozpqKCwOFnIcHtW+PLXiBTmf91mGS
	BAyaxB3mo1pY6dmKtfHFirP6F5hPLZE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AdRC4prs;
	spf=pass (imf14.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso4592970f8f.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755594611; x=1756199411; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9/jnxBS7I1AR5e/02apEhjBpEazFeyENxAvH1Nm6yo=;
        b=AdRC4prsiUrNG2nvHHPzlSrVl3485Znm6lX/ecDwXMZFnHfD2ur6Ikh66BwFuMGHOB
         cCAP1KCXu6pbVoXIkrtRo5nB056iFEwTZbIjl8SdetCDqk2c8aE0rTxLfUA9PUIEgyLd
         7uH9ub+FBeQgGozexbv3B/aasR3zz82B0bqIZt4i1BG84lc937OhTN8nHtfgtmFUU2IG
         /sIZuedNjNSM1nerUrBsRPn5lpZ6OLlllv9W7LlXbKDIEtbuxChX5tG1JwFdGRatYEfG
         f62MyHqs4FnXYeWBtTVktNtbfwtPey/Zei0WkWvFHDMbxIjqtStOKMd+oI+MHz41m8FW
         jGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755594611; x=1756199411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9/jnxBS7I1AR5e/02apEhjBpEazFeyENxAvH1Nm6yo=;
        b=TXks5v1EZIzWER9Oot55q96Oo777CE4/Cxz7n6f7joNFmGmFERLITRbJ6Mmch4qLf9
         imEc/UMsa6CRq9Kjv3cCwTk2ih/Nm9fgVjfoqDJ9MI8WMU+mZn462ReXWm+y0nHOTI+J
         /Fg0k99grBJA0uQyu+BgsHSWpgBmZMTrFME+CHiUpCBVjQPRJLYG6DcQIrvaJ8s7XuQA
         19PWa7HqHIxqS/72VC9OPY8bwPZFVB9FRC+MPGjuOY4RKIpcSoJpI/bvlTFBmLcpSGST
         iEaza97iDth97u1E+LXragQqe8O/cqF3GxVnPizG6gUnzEY8ey5xjHn3zDH9cGdbOI2R
         0PjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6wcn4lDpVKYcrShnsfANs00cMw0NILMLrN7nepzEXecu8DwlIn9I1KLRg1birPxDcQQ0xFw/pZA==@kvack.org
X-Gm-Message-State: AOJu0YyUeFjCvqdB6zDPx8MbqmpP/OwAoZeQpVPDTbF7FAJdHPPOJmWK
	KSvgKJf8dYDzwnx0kdX2NrH+4frY6+6UN0P4BuoyMLLcAmz9YyZAkDA9vTVjeXMOXcT5S5HBYx+
	DirDPgWJWNRA8xJV9S+m9WND3akjR4GEsfiHMD5gT
X-Gm-Gg: ASbGncvtZxfF/dava+mzHOB6drO6+Iv8Q/dt4a1w6j+XQF6RhK7w7VKIeboH3AIRMfb
	Yls0m8jtBz8WOyUDtWpKbuphIrudOUAshvs7bF44erchMxgRqb0IKDNTlsZRdEE0kv7z9xQyZI1
	MmysQtSOFBUV6QjektMDwykYCcP9H65UmyjZm8zxN/Vc7BfBtADEHwbHNhV1/cLu2iKoHDfcDjN
	YTBTq+u7BaUa3ILmJlUemJWqGycRYddCKQ5q7m6OM1O7XRpPntli90=
X-Google-Smtp-Source: AGHT+IHVUVNrk5qRTajk434+TVEPOUXm04X7Uh+fxd2pvvGn/JXpX/RvG9pR2tzt3ATebxLW997HovRzB564pm6TmpA=
X-Received: by 2002:a05:6000:1ac5:b0:3b8:fe01:cc29 with SMTP id
 ffacd0b85a97d-3c0ec476b13mr1451794f8f.45.1755594610630; Tue, 19 Aug 2025
 02:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com> <20250726164527.6133cff6.gary@garyguo.net>
In-Reply-To: <20250726164527.6133cff6.gary@garyguo.net>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 19 Aug 2025 11:09:58 +0200
X-Gm-Features: Ac12FXzIjOR60cK89wW_NrK29HmSiiv16L1E4oN_6vVa5petNytsfqPo9w5zs2E
Message-ID: <CAH5fLgg=_rfx9mBn6GbF9S0+thO5kGZOvOFT77XKJiGG1iozfg@mail.gmail.com>
Subject: Re: [PATCH 1/3] rust: maple_tree: add MapleTree
To: Gary Guo <gary@garyguo.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 78B3E100005
X-Stat-Signature: ry9rno7iiyapd9gno7kio6uxce1457wa
X-Rspam-User: 
X-HE-Tag: 1755594612-761111
X-HE-Meta: U2FsdGVkX19a2zBAevY3C7aSdChDiYBqacepBiWRV3zk+iznaHU+/zJA1L4y48CzqoDkswrpc30eTegyntRLKRhEqrF4gKzn1Pk4Y08Pz1UFk8xjInG7ywvxvuO0e/4wCDPuZzgCS2AYgcsZr3SvDFNKloH4Dbd87v5zzUvAx73wm4N1NvPphTPw1U8kXSPUcT0ZL2/TzHMv5r0WdwBRR4tL6l8QZXRNSc5a//LxWDJxUrPRHnH3KszbS5dPNANP9fgtx4hWt8g42qWpIix6D+7Mom6xAPe4JDPCl8h5SuLHaRBm8XU/gb82D2z2ioh47DqjAmtqmSwffE5zqaXbKCn+NlakgmvhpCAesHdAsiJQFWMcH6F3Wz+gfwNQ8CdGyB6UU+g8ya+W8zLyPUSafPH8yUnqSwuL0mLpXdBBIv36IU1I/ty6tEzXtndTIoUTXx5iBUsyTnkmoVXdQPVKkzLdYZXsTJVIDuOnTSVfh4qGNAa+AG8L8JvGRhssCbhkans23eYTXz+ZDp7WchmqhlyypykN1lqoan9WaXQE0xxhFsa1GzDXie4d/h796doV+aErj1y7uaPkgrnylDltkk03Kv0sMFbBDHiprrQ1wqKSaiMc5Zc3ArfN5n3pf+nx/A2zYy5RhfrUgQRPZg4sWLrSCDPD1fv29XtDGyRt8qG5CsZX2KyU9ZLV/b2rQZOSw3uJP4UnV35+w7M4LRr6wFTwGv7pTvSi3i45BStU1sHzfXP3eCkBDeYLB7i+G5V3eLHp7rs27l4lN36WWHfCTnLneMctVzP02KcSQ1E9Z9KeYhc377K9tU4Kn+9cHK/xU4wHRykZAMQMr8SglvR11r7w8p/9m89XN8v9h5Lz4KVgW1qDs9NTWjiAVzI911k3pb/ojmaf0RI1lN4w7Xo55J4efBri8WzvgQ2Z/a1voogQ4BFmVfgkZTe65g+FSznhepn2DircPZT/HPyU/kl
 YcdINIXk
 timtVW+wdWgi+1KrNe6RPh6IX7uDxVTXsklizsdi5KRaPiAYDtKMYU91U76F6mM/1zLS1G/rSpWovkbwJo7OJI1rbtFwjGTzVVO8KBq+g2oWo16mD2Swre2LWkl0+BNdZEEWQpJUpC2Wzn73Ry2EY4AmK6VwT1Iv4QbzgHFBPcD8Vhg/qW3fJa2NqppXr6IN21grJu9sxXc6LXGLIMcM763qIzL8iJytnZibt6ldtCeTc2uM2LbO699pQsY4e34ziK2nsGNtbJaXB5yGuREvZ1wR2eDFa8DWpnTPVrPyfEOxrh76YAenYIKzsb32hlmcmqoZpRvijbhvyZmzonVifHrEGIvUBVQy098Mtgfaj9nJSpWBXn5LMkPFm4cqkHdGoV7MPTE440gV+DggJWde2H/ce6ya1jprCFgNj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 5:45=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> On Sat, 26 Jul 2025 13:23:22 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
>
> > The maple tree will be used in the Tyr driver to allocate and keep trac=
k
> > of GPU allocations created internally (i.e. not by userspace). It will
> > likely also be used in the Nova driver eventually.
> >
> > This adds the simplest methods for additional and removal that do not
> > require any special care with respect to concurrency.
> >
> > This implementation is based on the RFC by Andrew but with significant
> > changes to simplify the implementation.
> >
> > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>
> Overall looks good to me, some nits and thoughts about the error type
> below.
>
> Best,
> GAry
>
> > +/// Error type for failure to insert a new value.
> > +pub struct InsertError<T> {
> > +    /// The value that could not be inserted.
> > +    pub value: T,
> > +    /// The reason for the failure to insert.
> > +    pub cause: InsertErrorKind,
> > +}
>
> Hmm, we've already have quite a few errors that look like this, e.g.
> `StoreError`. I wonder if we should just have a generic
>
>     struct ErrroWithData<T, E> {
>        pub value: T,
>        pub cause: E,
>     }

I don't think we have any existing errors that look like this?

> > +
> > +/// The reason for the failure to insert.
> > +#[derive(PartialEq, Eq, Copy, Clone)]
> > +pub enum InsertErrorKind {
> > +    /// There is already a value in the requested range.
> > +    Occupied,
> > +    /// Failure to allocate memory.
> > +    Nomem,
>
> Given that we already have an error type for allocation failure, how
> about
>
>     AllocError(crate::alloc::AllocError)
>
> ? I know we're getting ENOMEM from C, but this would match what the
> error type would be if it were from pure Rust code.

I don't think it makes a big difference, but ok.

Alice

