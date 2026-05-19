Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49CBECD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 11:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7056B0005; Tue, 19 May 2026 07:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A80D6B0088; Tue, 19 May 2026 07:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDAD6B008C; Tue, 19 May 2026 07:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9146B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:54:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DDE7A02EC
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:54:53 +0000 (UTC)
X-FDA: 84784012866.06.2C77EF0
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf19.hostedemail.com (Postfix) with ESMTP id E538F1A000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:54:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Q1JzYcRw;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779191692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRsE2vPKgX0eKECBE4DwNFiQcuKvIy6vdkZ9SvFMc0M=;
	b=Bgm13GN2oKV7lnm77CLch9x7lPlZlGmdk7v2ZANU6fy4VTkSnhnThlmKs5UrYHU/Pf+ks7
	IAVck4txIsYI+AoD22wBrJFbfXbjPq00E12ihIffpjO3XQDVbWiUa/foqg4DRthzRdXhMh
	xMAV1qP0OHcRj0eQIdKMjbJT/XoqPWE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Q1JzYcRw;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779191692; a=rsa-sha256;
	cv=none;
	b=7tGaJoeZgheE232fjOSTRZsP1CzesR3z4CYcxt88bjjNogzttsE6tfOCEMZVYFf1pVyUZ1
	JK7tcMailTdjOkuSwjKZoAlJvrRFY+KXRFLb3EpuPUFGDC0EqsSWfOhAEcklqhxpUyfYx3
	8ySiCEXfcWAjynhBDSATrkEqDYvbQIY=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 493A7D0805;
	Tue, 19 May 2026 11:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779191690;
	bh=zRsE2vPKgX0eKECBE4DwNFiQcuKvIy6vdkZ9SvFMc0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q1JzYcRwX2pTPEtrYf0z7m3PrTSq18eHaWrkis/FXOdB4twrWKYeT4CnSzHXUdawM
	 S3MbO93VNARrHdUYm5q7cIGGMbRFnzyNJCiHx606X6pk6qBvrg4zBygxdVrafDXzc/
	 mfp2U7xo5A3eHG/j8q1GVS41p96lDysWkZjkNgp0=
Date: Tue, 19 May 2026 11:54:49 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <agxPiQKt2pykEIA4@shell.ilvokhin.com>
References: <cover.1779116497.git.d@ilvokhin.com>
 <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
 <CANiq72mG-EpBWbW_hZYPgtV_R1vyUBsn0ytaz2X2Zw9fr0keOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mG-EpBWbW_hZYPgtV_R1vyUBsn0ytaz2X2Zw9fr0keOA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E538F1A000A
X-Stat-Signature: 854c4kmpuwc9n7w9wmk9q8j5yapgb3c3
X-HE-Tag: 1779191691-135198
X-HE-Meta: U2FsdGVkX19LS26W8cIK0w+B9qjLHM+riGG57/hRipjPYL9r2TRXr03HTYVxTLARWzHYB+6Sxt1gerG8W8LI48f4Y4fdF7vVyQfiaLvit2do+Npf0iWCsP6x3NOQB7CTt0CG7ZTnQKxcpAkbNUYGdTwsPDMSZMlWvHoDfnPkkFkoag1+31ShjsQCQwMDYv0BYfuBrfX4oFg1kkP9vmRn8pGYhUHHriwrKg4bL/jgod1vbOKkn49/Dq2BrYrLjp47ryEKRGMpIw8ScYtfoF3ZwsUMK/AQiBqp0YEzOSGquMy7xfMY3150x1T7y0xcf29BaFvzksNhAAULBKE7iaQanWgO9P6lRMyXb+n//CBQQJPJQCCMvMB9rUZHfjjaea23W3yZzul9k8Eh3IXSB6MwABGKGkeQWk5ryH52INKSwVgeOL27RAryc2Y1PdWBD1LB70uzJolBAzfSLg6ojgp8gpu904pORu9+q+IMrlIsw9o7OyBNDYQJ68YcQaZTigjfkdxPGxlSXGW9+2Lz9uOLHr2pqtFUfr4kwuWxz0LeaSrcEfFPWcrHORbBEUmVqmG8m/1UR8cChiUgyXudxrL1A+sbLWXPXWnrvGZxmNIHW7yjetP6YrnatBX4dDVNxiTdATvQiq6Kwff3y2RVZjAWmUDN/4UcK4xZ0VhaLWiMP+Wr0BFSze4zgII2tC0sujvMs6gSuTuAnopQcGIQIlyVwPJMBHtLqcDeSQ+Bx7IJJthOrOFXi2aJBmDhQJH2p7dwtdaC8052L43fdrFP3ieJZq9MWaTj1TG6/bEjdzKz/9O6cM0n1V8u8aTmxcWQdtzXrY7SLaI0hvkMoEMLfQ1SCJe29XjBy7oWjoH/o/RBT6ecPz2z8oyy9YRcyqRvD9cmWpHr68/BSbzxwXW6QzrEf5YXhYLeR+h/lG6HBSEsjrXzCNrj5KwAIXdcpKQjieE2ner1AcXBLWFWfEN0TR1
 rqANHJFq
 6HExnqj3Rn/41+GWBF3KSjA8EslQf2lscVfEG+X63npKEqloWwpxKoGV6RsHYfD5FbMPxtgIrecp95Mh3MZmkZshUzMb8EBvcd81CW7SuExLzGPwSBYxXDifmRZWH1Oz5hXsID5Mhs0yvSrOzbR7h44AifV0t8AzZbRpTH9t295XFjYS4PXDp0BJmX13FWSUNa56EvvBVjceDln78I3jOMBg76+yZdBKJ5VB4ZxNwqVAkaHNKLYO1ZuyNKZdr/VCvq7bVaxtG29bjU3cMf7UVyC2sS1RZK9ruVYvxaK5G3SrKaTpNer8saV1DtcibkZgFq4DicMJclenFAyJ7wUJdFf+6IcVDAR/pc9YGnffKIS0Ln7kEclL8IH8QQmHgZfdjEqkQVu/yCjhnS7V/HKdiXWBolhHZFzPBVusvydIAaKZGmaDs/ygCjUZe/rBomDx1GuRYaGimZQR0jJ4b4SRzWAlNuBxo6egqOz/AfKFe8HUhaIsA07sFBA6qLKvsEfrhJ3jxmODQHhPafAbs0RlCrmDUTUIII4Vs+EmUp8reaSShOzrtX9t2v4vjEodfZDwXdCk1owpNaWUzbeW2E6rxLjGVIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 08:19:35PM +0200, Miguel Ojeda wrote:
> On Mon, May 18, 2026 at 5:22 PM Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >
> > Add __nonnull() to unconditional guard constructors so the compiler
> > verifies at each call site that NULL is never passed:
> 
> > This provides automated, compiler-enforced verification that no
> > unconditional guard constructor receives NULL.
> 
> I wouldn't say "verify", since the compiler does a best-effort here
> with the information it has statically.
> 
> In other words, the attribute does not prevent NULL pointers to be passed.

Fair enough.

I'll re-word this paragraph as "Add __nonnull() to unconditional guard
constructors so the compiler warns when NULL is statically known to be
passed" and drop the "compiler-enforced verification" paragraph.

> 
> > + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-nonnull-function-attribute
> 
> Hmm... It appears GCC has changed the docs in commit 6e3c137f5dbb
> ("doc: Merge function, variable, type, and statement attribute
> sections [PR88472]"), dropping the per-kind attribute pages.
> 
> So the right link would need to be now:
> 
>   https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull
> 
> I will need to send a patch to fix the other links.

Fixed locally. Thanks!

> 
> > + * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
> 
> I think this link goes to `_Nonnull` -- the GNU one is instead:
> 
>   https://clang.llvm.org/docs/AttributeReference.html#id10
> 
> (I don't love the numeric IDs, though, since they break, so I think it
> is fine either way -- the `_Nonnull` is fairly close to the one we
> want and I hope that one doesn't break)

I don't quite like numeric IDs either. There is only one #id reference
in include/linux/compiler_attributes.h and link is already dead. I'll
keep current link since it gives at least some clue what to look for on
the page.

> 
> > + */
> > +#define __nonnull(x...)                        __attribute__((__nonnull__(x)))
> 
> This is indeed available for a long time, and we already use it
> elsewhere in the kernel tree (which would be nice to clean up
> separately).

> 
> If you don't mind, please place it before `__nonstring__` (the file is
> meant to be sorted by the actual attribute name -- there are a few
> instances where this is not the case anymore, which I will eventually
> clean up)

Thanks, fixed locally.

> 
> Thanks!
> 
> Cheers,
> Miguel

