Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83368EB491C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E8E6B0005; Thu, 12 Feb 2026 07:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BED6B008A; Thu, 12 Feb 2026 07:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37C46B008C; Thu, 12 Feb 2026 07:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C01836B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:47:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 358641A012D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:47:17 +0000 (UTC)
X-FDA: 84435780114.23.1A243DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 72E47180004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:47:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dfDbqyH9;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pt1XnH66Sa55/b3qs2K9wIweFwjrMnxiLDPWhMJ8v6o=;
	b=qP527TGczhWtNaaZKBWqvdEGCOVD/i+P9b+PXVRME9JiE4cmBXruvF6xzPgHqTa2Gs6qJg
	Wx8qQ60CGxsoKcVbQhkD7PhfFB83aIda+Lt/NzevvQyCDJqNjArnOfEmtd+0uJd4wJkmvA
	EUy5OTKRWACCLDcnJL21ynOhNvDoKYs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dfDbqyH9;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900435; a=rsa-sha256;
	cv=none;
	b=ZyYXkV21ayx/bxt6WTuL9daRvluktgMo0VtlV78hbjT1a7IGHecclj0xxcwNI7mrX8ugNG
	iwuMTCtZzwfLvbCQe9n8DzokRf90t2zgu5p9SSG2PPsyWVkdl043pcd85GOdp/ItaPAAlH
	RajRFp9Pf8K6ZXKUqIYhdUZRDeyIgos=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A025443B7;
	Thu, 12 Feb 2026 12:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44B7C16AAE;
	Thu, 12 Feb 2026 12:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770900434;
	bh=pt1XnH66Sa55/b3qs2K9wIweFwjrMnxiLDPWhMJ8v6o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dfDbqyH9m4z8P6PXY9Oelm114CRHUZ05O/TLtl7ODeJCsZaJJQjTFcD4I2gBcu6ZW
	 z6vp/SEdWWGj2NbmOweqZNx53yTtFd1kP56PCARdiPKSM0fQ0Whrx9LEgkG6ES16UW
	 q5zkAr6UsyHNSB8eaxZdUnkvlDK434bG2kWhEXQ2v676WhyZ3LOFRNVT60KF868JD0
	 BGa9aMuRz6ffyf3aCWp/9sS9pwMxLncIplKdQx6Nv2JJBw3eMUltrbzW6g91sG7+9Q
	 6fMv4JEXz6CLnpwyfrvrWIakzwc9Ee/RXm2Jrq+CRsZ3IOVsKzmZYJZm4zhKFevhUn
	 bkSd0xXp1HgrA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Tamir Duberstein
 <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew
 Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, Daniel
 Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
In-Reply-To: <CANiq72=n2=96dvcLXF05Ta4+h7CyUTQNn2b64U4j=VB0xO-0GQ@mail.gmail.com>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
 <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org> <87v7g2tesf.fsf@kernel.org>
 <WXzdKn94ED_qqocwnFPMLL4sIamZUFw57nW-NMKpdYCWhxdCutPl_wcMwF_aTpQvsmt-9NUQZMy7OokH-lQ_2w==@protonmail.internalid>
 <CANiq72=n2=96dvcLXF05Ta4+h7CyUTQNn2b64U4j=VB0xO-0GQ@mail.gmail.com>
Date: Thu, 12 Feb 2026 13:47:04 +0100
Message-ID: <87pl6at9h3.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 72E47180004
X-Stat-Signature: chuph8s163xi64ibdku6mqhrbg6q5zmd
X-Rspam-User: 
X-HE-Tag: 1770900435-280546
X-HE-Meta: U2FsdGVkX196zdEm91Bka5zfX6v5wd0RB64qysFizh1bOLF2mckgkzc2BLN+BEs7FB+7TI83Gt32gubiAOIJ7jplLrihvx1W5e+g/HYVm7nf1+G9a4ov/eRE0M0SoabKDu0TIdLjrnLG5sBbRP8N6ilOx6Ft3FDsa2p9+YQ6aMhllOcKiEPhFO8HPws6gAS5Gkcnb1+4iRKJLjp4N7YDAOmIvOtQh86dKV5ifo7IhwMvhVjbUmJO/+q3jmOzIydAZjzv7k0Ce+0RheWSDDgPgfHZfqEUrKx6NlHSVVaQJWA+UW9L+0gcl5ADQmlLJBI8PvFWuxw5lmXW8otX9LEp7UPiY+aMYj48+XxnH5l7kay08rFxFhDmJPXFIDjRkvzZNZ798Pc9PJ+2/AERoDd0259D5I+GVsQ9wA1/Qme89a9p79/FfI0zs/00yUt3PJ7kAz34JVGtDx1vUkvYI4cfyGG8CamG4LC7apfBew5lvX4u1Alkb+1mfklste0MsBSnkqLIgmCDZxa0lFuZ4QWU+2Zjy0l3qjDo/CDL5ph9vPvfWnQBa85tWFA3Sqp/Np/UonFQRXvWubb7U9Nmu7oxBs5FdkwhkllVnCyrMw+sSpir+Cr1zwnOA9bEJaQFOHUlBuyJdwuMEt60sn71mGHfQIFGNsjLUAnhwBXpiYK3Tyo09PR2mU33qV2XA7zua5AStuR2IMZ3vt6xOrHW0IKk+5SKJX9y0F/9OeAltoiJauG61xmezM3gv5Ae3iqIfmLiXAbdv80LOyrnOYn2nkgIeJ/gVIvCt1CvmGHhijeRwAAUSCdOeUSdrX7BvLaH2U/LYn2rxlkPvl9zZcjel8YuJQYltuEyyZzj2J4AJic+aSBfE9yDkn5DBoB783dn/kovtXQQqwkSxwWX/hGZ6Yi1rnfcUyzFWKi6hpQqcPVdmWmGTkkA4VJ0A00IIKQbBZAf/RYPttwjYG7+zfo7znj
 WQ9k7n36
 1p5kEY0HzQx27xMeZQWI+Qo4wGLCttFHWy2GcHVBEv4JzQd/sa6Z6d/hnlR0wTbl8Zrp7IbJaTU76NyjWRBxVvK0U5/nZN4JZoWg2+zeLpGvb5DXBD+PfWWVrFaHb8FN2Z41XkCXHfMdI3FhN6A3KDS0muwT8pGWYqS4hS383Azkt0KVybA7m1whMiDjLOZSlKjBkiZjyu8q1gQnOx35d8BVWdiXLC5lvRwmws1S/K0/6mZ5dZI5AeN9MSwwATESGZsk3ASxQMzLPL0awKkXpmL6sC0YngOEWKilf9ieD1WhpGzgN27zyl1v1UQl1iGZDkW7LjggYCfIl7uaZuMiR9gmcd1lmZwpaO02g3cCEtgSXdUJcIuXt7eb77sAxEn4jfHa6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com> writes:

> On Thu, Feb 12, 2026 at 11:52=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
>>
>> Apparently this kind of code used to be OK [1] but the Rust devs decided
>
> I don't think it used to be OK -- I think that issue was talking about
> code that required non-lexical lifetimes, which was an unstable
> feature back then, and the behavior changed while they worked on it.

Right. The devil is in the details. My point is that the analysis to
support this was deemed to be too computationally expensive to roll out,
but the intention is to achieve a similar analysis at some point in the
future, via Polonius.

Best regards,
Andreas Hindborg



