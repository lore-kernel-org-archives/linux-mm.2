Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59836E909D8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9497A6B0092; Tue, 17 Feb 2026 11:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921576B0096; Tue, 17 Feb 2026 11:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8089E6B0098; Tue, 17 Feb 2026 11:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A37B6B0092
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:35:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D0D01B42E4
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:35:49 +0000 (UTC)
X-FDA: 84454500018.25.CBDA8EA
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2552A40010
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:35:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kNQP/hWL";
	spf=pass (imf12.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771346147; a=rsa-sha256;
	cv=pass;
	b=4F+LDDvyjPnBx8x0QLvC3WZPopI2JecXQ3Z1N0lsj0jpzz3WXlSF2Y33yH+dbT/0dNyyi2
	TTC0ammphBhs1NDwxk725OL+PFZnsQNrVKL/mN026KXjIei5HQI8aJ3l/+mlrZoFsQMnB8
	dR2T7kHxyOJpvsvueH9TlNqNAzwdNgU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kNQP/hWL";
	spf=pass (imf12.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771346147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfoWbO1N2K5lxt2kPsEb/kyin+BYy7b1ZYySAlSqij8=;
	b=vHMom6zdNis7Ir6hMPNf4k3wgtd9WfWwzNKSACmT8VUeXRIDMnGS6dAHBDrSh5X6pTQ1EU
	8FZlYOqvXb2OXlaKo1fMteIg9AY7RRHoIDprIYo+Bi+djyLNNNSdj5n8OXqIGJNG7BDCat
	RclNSp0mzU6t94xdW12Xzg7H3oBUXrw=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65a38c42037so22688a12.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:35:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771346145; cv=none;
        d=google.com; s=arc-20240605;
        b=crwiyKNjiWHHW5ada0y1mmVvNmpXcrVl7MY/aCIJ+ms65JFa8Q3of6iC4zZChDFbBs
         k8Y/vgEtlPRhoT4vvDHbnN611BU3ydYM9UOpxdSNz8SJD3Lk8fQYL7ViIeUmH0lK2fwk
         nEkGApD92h7NAhNCgqVKuPr8pm5+o0SE9DRlzDdOuQ/VqiAcW3jjv6A3LRjchHI9x001
         868qxHtEGizn/H99APnqYtxiYKziQ+0nuEqbTpCQVa8+/gWaORxJZ5tRJR2i7yhizNEa
         hipdGj5xEdeWnQQJeLs1kMpVKvE6HJG9yTzxgTarM7KnVlG5skKrkx55tvL6IFBopKmB
         9UAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EfoWbO1N2K5lxt2kPsEb/kyin+BYy7b1ZYySAlSqij8=;
        fh=GPuG1wrZAPhvMXKDX5eAoj6ntyG5tTzhCxyW9ATvVc4=;
        b=L+5YGbtLmfzIs6FVDOVmc13NHw04PvxpNVrrVmFOpwmV23M1Muzhf/ElCZgWlc3lCz
         Qk56lzTBXq2vVixg0dn3FPnIIiw1YdGFhtEC/kVM4muz4OxV9lkN+bxHTXEdiyNSGC/6
         2APEUqkSfFZ38p85r2unnU2q4iU3QHoPIqTIYOOP8jMlxvqQC2l0wUlBqhd8OOR8B7Un
         5obhIMuzsJiyKm4MAMX4xxoewYcB+IaEoiLN6axlhSgfWIOnGdE6lj1SqxaW8iSAtH0C
         06IFHkSqQ39zxYX7hSKgEj46cALWwM/9UK72lKg6CDOmITRb8CS4Dm85d0iAS+NTHXjU
         nIgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771346145; x=1771950945; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfoWbO1N2K5lxt2kPsEb/kyin+BYy7b1ZYySAlSqij8=;
        b=kNQP/hWLSKh0GzeVf5O54ZlzLIfTzckjss8tJtgt2BQkr9I4dPWtyh0a2SWo+P6ZWN
         H69KaprCG3QaxFXBszmmBl5DXBfDI7v33yITGeySBUA+2ctqik7o+4tmLrjWR3WdISxA
         U9NlY/0RYRkGky0jLabdXKiuxNC2lwfJjGsGBKTL6/qKtaKjo68pA5t4C58fzKIMjh3M
         6PTisD4K5hfpfb1lbgOPnSRC4xTAvqciRc8E2Xr/bhfZat/Ls8+/Rjjb5yj6ZveUj1o1
         DCJ6BjeEWghsPiHgoSXXDtt5eiz77nJo0Nw7R4pCWZN7aRCls0gKcZcgcNaJR4CehUQP
         WV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771346145; x=1771950945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EfoWbO1N2K5lxt2kPsEb/kyin+BYy7b1ZYySAlSqij8=;
        b=Cymow7a+NmXclw2ry3mlO/SSC+8LX5HFxXY9gRwWiIy/Nungx0yQRam7mOtQrwLI9j
         jZEPh/9ENC80R1srzY7EaSoA5ahYW4NPjdM+gVxo9eDeJaWDQYImqshTTIEV099ADcRH
         FQ0m5Z8KHo6xbTsh8aY8nJGoc+BFkeRWLUnTB9gNQY3sHKGwam854u3zQz5zI7/b5ZZl
         gkdvjrUsV8L+moVbe8r7D1y7jJu3j6fSrpgVrrkMLXorLuRGSnMGNumMii9CVBFgbCJU
         hWlMLyl5Ylee92D2CnAdm/XSGVYw6qkJYoFbtkIkzgR+lfeMjqIRRK3oS0PnpxtgAME3
         4DzA==
X-Forwarded-Encrypted: i=1; AJvYcCVBJJ6LiP9zrZih+cW2jMH7hnTjZsHru/dvLrIOCkK6J9bqkvx710OU5aEpObXe1BJYDq+Kc+rfkA==@kvack.org
X-Gm-Message-State: AOJu0YzdF3Ajjgf/qktmnXSe+ZEC/SIqoyrnv+7ksXtfaXDbd3YTmKyi
	E1YMo1ocDdJBZxU+huFieXw0gzL00jo8hMlbkWxn1dIpXdM+dXf/E1CyQXCKYlPSGxHs3qYYKXs
	JpkQgkZrxok6ykWR5AwRDacwOIo6gDoLCTqwMCTF6
X-Gm-Gg: AZuq6aJpw1qdcYouj8+cozKABtkwIJlC7THFQUrEnl8Wo60e7IP3nJfQ9nyYaXAF5hG
	zPWbe0/GcPfws7U1h9j9C4+vt/UML9o9Q3K8JCRxXdtn9v+0vRfZiTyUcaBGwWFBlVBtzMmMgpA
	VhYXD1R2lqX+mZmrNZFcPJHtPnNMBHoU61D00lLV4/39fHWdyBgXifoS9JUsnNJBJMhMTYM6XXv
	DYK/eW9nfzar0H9c43a4QH3qmjTt1s5U2ZbbIa4PcZoA8HmeSuKR7oVSsQ1/Rhr12Ap6RvzbYVW
	IhwOJIQQ5wX0rNBwi5g+pSPnXgHKHpXQ3iwKibVxqQxBPmxF
X-Received: by 2002:aa7:d454:0:b0:658:eee:f21a with SMTP id
 4fb4d7f45d1cf-65c149a703dmr56554a12.10.1771346145107; Tue, 17 Feb 2026
 08:35:45 -0800 (PST)
MIME-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com> <20260217-binder-vma-check-v1-2-1a2b37f7b762@google.com>
In-Reply-To: <20260217-binder-vma-check-v1-2-1a2b37f7b762@google.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 17 Feb 2026 17:35:08 +0100
X-Gm-Features: AaiRm52oKTHP34zclQj7ezY1ha5t7IvLtrRKqEuUAhNd2ttiDd3hEDLvSQutZtc
Message-ID: <CAG48ez2O=_Hd7EjjLSAh36xtOMyX5MZ47xodWkU3FyEar63TnQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust_binder: avoid reading the written value in
 offsets array
To: Alice Ryhl <aliceryhl@google.com>
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
X-Rspamd-Queue-Id: 2552A40010
X-Stat-Signature: qyamzxoz83itpywtbtu6rhxj1dayaffe
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771346146-515857
X-HE-Meta: U2FsdGVkX1+PD72xSuM6lndJ8bsFCcfoJEtOT6EGb6A+vmP3EfUp2aMKP+o9SixuJOJEhbO1W0Ene8rm+OzsaHpyFX8r0Oxl7i8E5SsgGfnd7FVl9Eabc2MoIUx8s/g6rnfB7b3Io9m5o5hfQfjXRXi6S9gyTjn0f+fO95n7XrF2LNVv2YFwFAp81leOFT5x7Uvv0xk0ljc9kFK3tGBan1WrUSFwuH9hY0dI5FEdiFhxzl7iPrL5xf9EXF21vX9Ypm+iiP994FkYGUTb8Q1AtZ/hH3kmlAGs0hDw3qxWnmZtyY2LRzo29DWAohsgzVKodAnYUViLmW6ovbqeoZ2aQHfNAJHivI77SBBBOM8Pox76c3LUj4WPjqyTvUmcyaaZEpbfqByYp43bc/rzz5z6GRcrsPraPD8COX3TM2X+oln0ZEJBnwEAqKHlnu/5+gB2CKNXzQGRwfR5fTxJBPZ3HToGGfDvqulVp3kwDliE8NFiYEOvf7iDW6apAc5qQnke9IiCi1JgaiLd9Su3TB7Bq/hdyewEcsyJdMVCgfBJKAzGi970tZkDBkfYX6D3nKSLpQlWSyTIFyX3i4rIIYnP/PmysEzIvqujMp4a6J1+JFh79g3OKu9P6hYdRk0gm9/UHTsw6r6eMMvb0cLUYI9FBfMvaBmecAV9Xw2ps9p6c0G6lY+c4HkTo4I95GeO2sH2XD8foX5Xa18VD3tnGVY+d/KhbZuIAlRWpZV9PntpoO5sxOo+YuqrIN7/JRpkl2P+kBvWg2HuNnul3qTc7alchyZmZOa4n4H0E+GeiTseVGk+JbF+od41pn4IDPDEqA9ESUAOWbDZnnewf4DwHqwFmfQ90g+hvk20SXYBnFwjU0PsXYY2Rg2Chd4/AGhiP5YLPZml4bLSt6aifPEReVlxh4YKaU+bhZp1Wo6UzZDfwjRypMaSbFA6XSZCuGQ5vbhlCrGVXnw0UqAAglWLMpL
 Ie7cyPBx
 m6m5A3mhZ7TqxgOeEicYfUGMufXW3DAv697HLXvaVvZr62XtfA8EXihiMm7G6xHsNJ9/8hDRXkWi1HO7OId+dkeD2ANsxUhtk0ICs4Jn384zw241UusUc2s5AC6VXRvCj2DOFpiMZr5BhsADT8pWiuje/achNTktGWjpEN1sjshOA3vwWRFM/RdoVrr90RoVSo3UIVHXc5glo2r2cDJdu5Gf6KgHNkVilObHN0tiJppC7DGjHCcrfdfha3qDMeI2mlLgLe/fzBm6EAEZdrrsBr1rYGI4TNjixmXVziXUCja7eTtJB0nWg0e+bKxbrO1kYGlSGakMlsZGxhdY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 3:22=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
> When sending a transaction, its offsets array is first copied into the
> target proc's vma, and then the values are read back from there. This is
> normally fine because the vma is a read-only mapping, so the target
> process cannot change the value under us.
>
> However, if the target process somehow gains the ability to write to its
> own vma, it could change the offset before it's read back, causing the
> kernel to misinterpret what the sender meant. If the sender happens to
> send a payload with a specific shape, this could in the worst case lead
> to the receiver being able to privilege escalate into the sender.
>
> The intent is that gaining the ability to change the read-only vma of
> your own process should not be exploitable, so remove this TOCTOU read
> even though it's unexploitable without another Binder bug.

With this, the only remaining read from the ShrinkablePageRange is in
AllocationView::cleanup_object(), correct? If I understand correctly,
that is fine because it can only drop references on handles (which
userspace could equivalently do via BC_RELEASE/BC_DECREFS) and on
binders (which would probably also have its influence limited to the
process)?

> Cc: stable@vger.kernel.org
> Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Jann Horn <jannh@google.com>

