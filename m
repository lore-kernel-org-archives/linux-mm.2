Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DE8C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1379B6B00B2; Thu,  7 Aug 2025 13:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E84E6B00B7; Thu,  7 Aug 2025 13:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1F46B00BB; Thu,  7 Aug 2025 13:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D9F106B00B2
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:45:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8973D1374A0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:45:43 +0000 (UTC)
X-FDA: 83750688966.02.CC25BAF
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 97C2120003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:45:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="p/bcz5Zf";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754588741; a=rsa-sha256;
	cv=none;
	b=Z3+poCrpYo9jncucsky4X4v82++nLO7uHieT7ugm6UgDiBe8HB8NJeYgzlGRhDtY7ptu/b
	QufPupHFgPJLsjufYgtGB5MS19/vWrjMJsRhhUr9a42RtAaoiLVYdNEhfbt6GgFlSN9w5a
	zDNHgXiFq6gi+FJGtMIz9cdh/Y+aG44=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="p/bcz5Zf";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754588741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfvcv7HiZ+WmvEiPy97ympVI9kZ6wtR/RomqPMn3sQQ=;
	b=mZLktD5EN4MNoBi1hxwKuVRSoEiyxYst5E4MtXGDpuzpZzf7HFa73T1d7SSy1WXp7T224y
	gkgU8RO1YzVcD8Il5SeiSXUZkauI4cvIdqz5qShed6rh732qvEmCbzpScjJnSG4iN+4moa
	ydCWc1Tlr3KaJ/XbhD6dUUoZclZ9PMw=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61543b05b7cso1239a12.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 10:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754588740; x=1755193540; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfvcv7HiZ+WmvEiPy97ympVI9kZ6wtR/RomqPMn3sQQ=;
        b=p/bcz5ZfeD2zO+9/WvPXNZc0lcH/po32f8ayQeno47UFnSIijIJ4kk2zWkIrI47A0F
         oiPCoqUQNn/Y0PNQ5UfB2bo/AG+vlMvD0JtWnT3CyR4C99I8ibIrrKMQ9eKx9zC5r/30
         ykmVyB4igTNHOxGjb22R2nnnTXnOvaUdKPARVre0nZopCJnphFdo1lo5L416P66gGJrF
         GFsn0s/0PAGaevkgHhTItHUvUFhRBHSNe3U4/bKJ9E3pmRBEJCKJVh/YPeZDm+r8z+u5
         /AdLLRNfJ7XlzdSUGu+/ufMunWsZawIWM4D5FQ1wqE9lk1Jy4BCiHKdHd6TxQLhNaSSj
         jX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754588740; x=1755193540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mfvcv7HiZ+WmvEiPy97ympVI9kZ6wtR/RomqPMn3sQQ=;
        b=kJFU7tpYgM153id93709rVxmXz504UXOKLZ37ZcoEuPUl+doO2NTMLm+OY7yUDPceM
         wdoleymfmJkaaZld6aqkbECsalfGQyPKveekbO5JLA/ySMTnuPWab9G6X+P0YTbnWpHW
         Ka2QEjEcI0ASGv9aLj+Ve9E4iO8Na8CYjDv1Et02n/Mkoijh/sY+XXpIie57LkCTAIe6
         ya1GMQEE2VkvtJkgaHdj9WXcewF7KuvWIZK/aqL3vfbChi6x8+lsbPQWHhJUNddCAild
         T4mlJafCf7y0C6GgPc814N2dYbleZWy4OQt3Wp3DDMxI8GY18g37Gukyo0ye4hz2BR58
         xYVw==
X-Gm-Message-State: AOJu0Yx8ADnGC9es6a6oFOKTPiKujnztzeJNbwmyTQnu1h2UoeXyLbK1
	32ygA053SYPuYPuKBJyTHLp742YWd6x5AfaSpksRWHH/q9keQoSiuP0j3m7Hp6+xE6vFqmDrvhI
	wF8zzBpPlp+Xz/nIaF4dTgQQMGXlm2V46gtoz68nR
X-Gm-Gg: ASbGncv4BFLF5nt4vLoD/5ydRUwvdSQPWhzQTyvY4bUzCI2LIpJhgsdF2+LfvHpJ4zc
	NVJMcMyAOwme9v//EpKYmWVqpG6x6tHk7P97Q4xiBVrbc3TWVyhPIm13mE3xIhRu4C5yEGe9i9t
	VmPAUyexzpoZVOYcXmXUpE+wM3c2cSD+Kcp3gfeneHf5ctfobvCvxwcqvrfwWMu1oBCN4lTN0yc
	bSayiGi3FSSiEdf5dpTUazT8i0ryoPWBKE=
X-Google-Smtp-Source: AGHT+IGcEDpK8Ms228S31UJyQbAhkBpRIwdLjP1Clq9AvE21KoiH4tSwTjlg40PwpAD3vSeDQTwiPuojzRmAtQXU/js=
X-Received: by 2002:a05:6402:42ca:b0:612:ce4f:3c5 with SMTP id
 4fb4d7f45d1cf-617e0c31262mr1251a12.0.1754588739638; Thu, 07 Aug 2025 10:45:39
 -0700 (PDT)
MIME-Version: 1.0
References: <20250807152720.62032-1-ryncsn@gmail.com> <20250807152720.62032-4-ryncsn@gmail.com>
 <CAG48ez114_bmuca2UL-g0ZY76-VqhL-4rQtJM_k0N2NJXE4vdg@mail.gmail.com> <CAMgjq7BhfGC7jVHQ62wAJBfTKCDG2+VdgpjiZ7hjxXeC5fHg-w@mail.gmail.com>
In-Reply-To: <CAMgjq7BhfGC7jVHQ62wAJBfTKCDG2+VdgpjiZ7hjxXeC5fHg-w@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 7 Aug 2025 19:45:03 +0200
X-Gm-Features: Ac12FXwnxeugojc67eEPK0kCxtOuhwPnrmiHNsk9EMBjaGBmvR-4KLfAtDyKybA
Message-ID: <CAG48ez0O-Ro9-x1LZ8QdijMk57j1D2jWf3MR7F6AiDP7Wq1p_w@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm/mincore: avoid touching the PTL
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 97C2120003
X-Stat-Signature: ff6xrxyox5g6rktwfcbgpdx3jhphgwsz
X-Rspam-User: 
X-HE-Tag: 1754588741-909926
X-HE-Meta: U2FsdGVkX1/7bX9kK4z86Msa/qgZzb/KMWe0gOvc+dvst4FmDkf3ElCkj1o6ahkc/HKi8xeWI3+ievEiVgTRCyetjNgcAeO59/iJUDwl96qo5MvYI3v7Gi/C/bcOC/4L9ftlAevj3tsmaFFnNPz3NtMPbZhQ+ATONBxktymXW0uke79k7GZm1nVZJnKxEFytu6OLauDcamNbELo8rfGKM9KFT8jpd1biUlU97iht2ZDcC/9oXiH6yF0dY9irD4x/2lennJiN/bmJJ/f14LTsz1ZjZ071muCx5S0Gm565QtM9DUVrBUlYqzRiS/yxhMX3KzXNfvRJwNLhf1IW7gJ3RtImyg+LDipECUY3AsF68fKYumrN0tcgzuFEtNbgzgiw3p39KLrcZ9pa1QfuGYXpI7ra15TLMl2NztYD+UW+fP2FBMnmLkHZDfY3QuXphPaS/XnumA4g4wDe8goNuRMghXpLdkptefjO1XQB1HVvpMDoUdMM28QlJ08TFI84NnErYgv4vqSWMzFGeydye+VcpFU3oa0q5vkmA9aLS4vWJheqpkvpxBrIjruClavfkb+UQPw2b2if0JCC1ssAKFhfniNFfNE9ee2XMp8aMh1H0io8+VXFiiDWjBWHbM+5KMMCaAhkmZloVN5zO4Ll+Qyo1SXVQSBxNMNqlXvUTDzLjlRhHurQWZmWmmMrm3Sord+lnEnt73BZItDcHRCLkpxJDUJpcGg/smE+2v21PG6spzeskd31tjNT8dWXTsHEj/QWbn7bJe2G+zWXlMO98dRCmYjLh1+2qlIywM54+I2AWZfR6o0TxlA2tziU4WSqGwdwHExq5bT1sJng4OwbCHc5qo9XRR0rjZZg3lIdtqeSMRlVegwP9fN0oJFFi1HJtmFy9LYMSibRzbY2oE5kMcjXN+G0FwqL1IIEYUPg83BbRNkmB+8qZoVysC9U/PFj2L1pmn+OhFe6ubHbC355nDi
 UEiAezqe
 /2b68aTXUkth4LiA3LnLgBV1o+39n1IiFBg+pM04VHZH7kTKumC0wd5vr8eITla7PzynvTWtY0830izgkEldMSZr2HrLwCjbjkNrahnmcLjyp76m+mHEWHvqfA/B1YV8jyvHtU/Erfq1Q5UiUK05PLLuiXL4U1/kyiIBPLKpWH74mIQ6H0MBCRcZvQNDtimSck84Prmp9HEOxoBLIKJ+8II3O/vQVJXBZkGzsTziV7q/AmI0uFpKo1y7G/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 7:28=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
> On Fri, Aug 8, 2025 at 12:06=E2=80=AFAM Jann Horn <jannh@google.com> wrot=
e:
> >
> > On Thu, Aug 7, 2025 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> > > mincore only interested in the existence of a page, which is a
> > > changing state by nature, locking and making it stable is not needed.
> > > And now neither mincore_page or mincore_swap requires PTL, this PTL
> > > locking can be dropped.
> >
> > This means you can race such that you end up looking at an unrelated
> > page of another process, right?
>
> I was thinking If the PTE is gone, it will make mincore go check the
> page cache, but even if we hold the PTL here, the next mincore call
> (if called soon enough) could check the page cache using the same
> address. And it never checks any actual page if the PTE is not none.
>
> Perhaps you mean that it's now doing the page / swap cache lookup
> without holding PTL so if the PTE changed, then the lookup could be
> using an invalidated index, and may find an unrelated page.

Yes, that's what I meant.

> A changing PTE also means the mincore return value is changing, and if
> called earlier or later by a little bit, the result of that address
> could be opposite, and mincore only checks if the page existed,
> it's hard to say the returned value is a false positive / negative?
>
> Or could this introduce a new security issue?

I don't have specific security concerns here; but this is a change
that trades accuracy and simplicity for performance.

> > And your patch intentionally allows that to happen in order to make min=
core() faster?
>
> When doing a clean up (patch 1) I noticed and didn't understand why we
> need a PTL here. It will no longer block others and go faster as we
> remove one lock, I can drop this one if we are not comfortable with
> it.

If you had a specific performance concern here, I think we could
consider changing this, but in my view it would sort of be breaking
the locking rules (by using a swap index that is not guaranteed to be
kept alive) and would need an explanatory comment explaining the
tradeoff.

Since you only wrote the patch because you thought the lock was
unnecessary, I'd prefer it if you drop this patch.

