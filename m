Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D79E9A038
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD486B0089; Tue, 17 Feb 2026 15:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B266B008C; Tue, 17 Feb 2026 15:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718EB6B0092; Tue, 17 Feb 2026 15:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF416B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:03:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2132C13A6FE
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:03:41 +0000 (UTC)
X-FDA: 84455023842.19.BF0B750
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3D426C0003
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:03:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SrKf0EAa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771358619; a=rsa-sha256;
	cv=pass;
	b=Avy73zzq2ZM8GGFv813cUsxMFT19lQa7bHgTkazJUZ75+jNRvN75kroEV5C2y3ANVTO5wG
	B5cn/1wcELg2MxqHRV+9Npq0H6z/w+ic14vX8wE5aJBj2AMHvFpHF86SvkIIgIbt91m+tv
	nMeBfQYkpnPAEPvYsLAbvHUkAtsdGrg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SrKf0EAa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IGzT1pKK0tMKZWS/9RzMNxACO8Kd0m/tndhws/hoUQ=;
	b=7LIYpl+KkpEH/E+Rp+bPpFzm9d4xzEIAS8ugwMGAoEmXGLsnF0aZ8SqJsS3utxYN+/Wsp5
	rk90rS7IStL7Ufr0TcrXsGiHMRhh/5LEbHhMehva0WbDvUCvMx1KONnpYwtZELlzYO1Orn
	GEHtg2sxTcOh/P8hCdnYDjS2nUZE6Ow=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4837634de51so15879365e9.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:03:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771358617; cv=none;
        d=google.com; s=arc-20240605;
        b=HZbEos8dmm1eeRXk8znws107uyVv4pclvfUXvekp0dJUFKgppS1PL+cNVEzI1DuUhc
         Wdn1i0590Dqj6oYXnM24W873LYCVRwP6dc1lgBIBmXdJtF8L5l7XBbmEmcOziBOeVv8t
         4CCR+VddCwegxoTdlbIMFUVtE7PZBVAqa8XRPQmWzedjf5/u4JAgjJQaIMzls+mVg1wc
         DwAX0qljOemMnVGMoOZuupXei2LKxninCYjtkvps5LGrce94lYS2Pxiz6EMguCLFXBtg
         5r1fGGthMev4Et32wrSa+A3lFZmb9Watc1ULio3lbIE/f6joX42YbO0m3j6x3akRU4KD
         JBGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8IGzT1pKK0tMKZWS/9RzMNxACO8Kd0m/tndhws/hoUQ=;
        fh=nbaAnUOjvGeJJOYpcHtGc3409l2e1o2Yu17KnwYtmaM=;
        b=HoIx6QdesrJOxvPJSXbqbnoKhuzqpXON+URHxCfoGeJ/dtYNBchEIbIKR2TeQOcPcN
         1nquJzTLNkBRCNzqKIlmY2ul8DBPK6UEXcCMCQaPBwQQWc78fFhRqshQElF9D/Lw84CF
         vIJP4AX7sfXRxHzPwIzipvhlSjniSDoPq8xrbxU+VlFB0MEnj8Gu0Zlvz/Opz/NXAJcO
         KjTcUsqKUyV+YE3qpNkq0BFTqL49sdlpxG30hwu6MoNZgHPjprqqzBjDtHQXB/y0mGuD
         N50tMms/vf8q5sarE8wqZ0KxG5SxGw6oWgcgrwLS3XWoxWXn+n7Ps1m629YyNEuRWQlE
         aMqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771358617; x=1771963417; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IGzT1pKK0tMKZWS/9RzMNxACO8Kd0m/tndhws/hoUQ=;
        b=SrKf0EAacjkUy5GYFIz9HfbziVgVvQuaC6tUOQTlVEQs481a97sETJWl3R0esdnso4
         yQjanf6o+Cb8mhKtRxK5fCVA+5NsvTpJqHCrwLmdv6qStin2WSIpnLso1wz13fai1aVM
         unKmQ46aYDSdfUh2i4q48wenMzulH7Tb70eRB92r/N3QHm3dO7jYspaNDTNgrMUEiKCN
         alGqfyd6UeoDrorqJfs7hTlGyjIh0TQVTww6swqoKM9S9OsAR03V3tZUg5zeNgE5wVbA
         3gF0ttO5SzlkP45eWNKomM/g8qCpUyD8qQOgb3YAAUnpROzI7FVofAv3Y7G+L3KfzLic
         pcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771358617; x=1771963417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8IGzT1pKK0tMKZWS/9RzMNxACO8Kd0m/tndhws/hoUQ=;
        b=Ogs5inI0dEQ62hwfAIP9iVj4lmqUsYdmQFAiYkg4HhL5rZRvZxovyoDiRM4zp+H0QA
         uPi7F5JZACLspAlKcBleGcSi4Y/+s68NBqkZyzkfeg++NANFQs52trtYqwkV6tJrwe3D
         toocWNSP9hiEOEyekQv7H3iAsMjGSxifR0WgYO8JApF9W/ejidezc4yc7HqZcejyxxDE
         AR+sOI6jhygsUd6l/xm65G3IjJtttktsJnapsCLxGCRLjt/19hXY0naxXBoKd+Y4zoCo
         Oq1SCKiituP3tGBbxgjZ65eE/Il1nTc1W8TvlJBn4MRGDUAwvcAtWflBDEqy3E6j5FK9
         PjCw==
X-Forwarded-Encrypted: i=1; AJvYcCXpNpyigahfZKcHIJ9XqSwyvfZob03uZpGgvUXWuGNvfISZB+XIF11JVJmseIZNSu4GQBP3vzspUA==@kvack.org
X-Gm-Message-State: AOJu0YyflyYuvjhrELUeWf40zdByMKpD0u8mlJuWMD5kguYsJTL4yCqU
	A7memsxPJr6JOBzCJuzhGRpL61sAcC5lgClQhwD0eEduOhYDRTqwuoRN9+nYLAfiTW48T2LXFYH
	ZFVJOKugP7Aui8ezRYKC8p2zlTzx7cegCmvfnMW/k
X-Gm-Gg: AZuq6aKOTdanQIJv4ygiI07JdabmKc9qfz9vMbmdeHIYRdr2s2mYYM3Qpbs6j9xBEcH
	AkbazrpyYhzvFgPPqqY+MjQzi2Zh4eIAZLDJ4FHm/UcQy1uapl+0gZqwLFHYPI9qW6qNKL7VKuI
	vhKE2ewfLwjWL0Ufi64JG/gcSZy8eT2qfDLCQ1AhzDy/wXecZCyx5njDxvh6NXUtGm5SjQYffLI
	FCGen8wpNbqAIKgPBVCrF/yGds1OHLLirFG3515FMi8Svy7nWeXL9JzQLKy8JJJBjrz93e4FwNJ
	UIoZn/eYNStPrIZjVAAJ7xpYPOkO/mYfMAZcdw==
X-Received: by 2002:a05:600c:4fcf:b0:483:6f82:9723 with SMTP id
 5b1f17b1804b1-48371043085mr263576225e9.4.1771358617090; Tue, 17 Feb 2026
 12:03:37 -0800 (PST)
MIME-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
 <20260217-binder-vma-check-v1-2-1a2b37f7b762@google.com> <CAG48ez2O=_Hd7EjjLSAh36xtOMyX5MZ47xodWkU3FyEar63TnQ@mail.gmail.com>
In-Reply-To: <CAG48ez2O=_Hd7EjjLSAh36xtOMyX5MZ47xodWkU3FyEar63TnQ@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 17 Feb 2026 21:03:25 +0100
X-Gm-Features: AaiRm53OywEZ-9snmQAwJUPw_yVph9JnQVbkwj0vQh6FVln0Kgy98BO_f8V9K3Q
Message-ID: <CAH5fLgiM3+2URibfBNQr5X80bKvZnwA_tBjHpE-d_FHye7w1ug@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust_binder: avoid reading the written value in
 offsets array
To: Jann Horn <jannh@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3D426C0003
X-Stat-Signature: mocxkyeg4uh4fs614z5zeem16eoakasb
X-HE-Tag: 1771358618-209409
X-HE-Meta: U2FsdGVkX1/Y8of7Lb0DDwKOraO++wzNSUQdCmxmfvT/W2BM239uys0Nfya/CD73vGT/dKetx8F7BWdfm1UoMsdw8D5Tv9Ps9hWsolr4ejsDunFIYJnwcQf5rTrTDwxsnv2S3kh+UapvM/s2m8D6D+DhA1b8O77AC0vSCQYAgPjZLrF32luFfi70x8KULPg9nKyi0fk9GNvCag7s6Cw8/Bi8ULrzF0viI0VIoEAQErHDs+emxNbXcwJa09HVHu6ch1zvxDDX9o8/tGQJ5SLPHUBERMBthAKZMBmp1/B4t8VYVx3GowkfyjJ4FcfOK4+w7Hf03Klx/YZHPdHC5YDLE3GfpCNrrzBToJ9CN7X9OpIrJH1I+On8jtQ3nxZSCLKY/t+cJoKkkKoCIua6Cg0QoBMO3zI4YAH9wy9jZnleaD2gjEb+8Py0oRoZlsdUD7Y1l4lIk5odup6zaLwgU9oUyD8dy+jOi3efvH4LHms6IvEuPy77DagbVxLklCYjmxfh94TyX2/72YBMvFucNhfkuit5ymVCOTYLV0nCzg58/BMUd+lK3jmNX1VnJMNtwr2zxXapN/pOpVB66EfChE7rX9HtgNZc/0T/wdFFXF7i3MKBucxt2XKig5gK9NR4kz9GnT/m9kIYfGc8fw9HdDzMan9/fqRspv/z2wzsVV1NIz1j7jx8gC/jf/na2Ff8sA+6xo2Lpd4wf1xx+CuI9zsXvX5v93sVOr5qRYcyaOvSFnDrAM83RLJ1NnG/8PMnhhYZtcgqRpIsH7D/fQ4V4PWUv32ntH5lz9E11/7YsyaIV8qRriwLAsKmKybDWYFbgdDYxftHnWyYVSD2t+ToBAYhl/CWQir6CyWKVMOoUEfkkIPAJLhOnMxJVodv4UoebltrI2rFysjIVOacHUCKs0N0b/n51D5pyxKRnYyHCzUN05vuntR5SzjFH10RFM85i+cWhiLHmSUdMQRmMEv6RNP
 heTzC1rO
 F/51mca96R1gYlZLZQ9Za9yuaes459XJlXrLY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 5:35=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On Tue, Feb 17, 2026 at 3:22=E2=80=AFPM Alice Ryhl <aliceryhl@google.com>=
 wrote:
> > When sending a transaction, its offsets array is first copied into the
> > target proc's vma, and then the values are read back from there. This i=
s
> > normally fine because the vma is a read-only mapping, so the target
> > process cannot change the value under us.
> >
> > However, if the target process somehow gains the ability to write to it=
s
> > own vma, it could change the offset before it's read back, causing the
> > kernel to misinterpret what the sender meant. If the sender happens to
> > send a payload with a specific shape, this could in the worst case lead
> > to the receiver being able to privilege escalate into the sender.
> >
> > The intent is that gaining the ability to change the read-only vma of
> > your own process should not be exploitable, so remove this TOCTOU read
> > even though it's unexploitable without another Binder bug.
>
> With this, the only remaining read from the ShrinkablePageRange is in
> AllocationView::cleanup_object(), correct? If I understand correctly,
> that is fine because it can only drop references on handles (which
> userspace could equivalently do via BC_RELEASE/BC_DECREFS) and on
> binders (which would probably also have its influence limited to the
> process)?

Yeah, that's the idea.

Alice

