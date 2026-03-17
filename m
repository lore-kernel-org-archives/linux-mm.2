Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 940AFF3380C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBF86B0005; Tue, 17 Mar 2026 04:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4456B0088; Tue, 17 Mar 2026 04:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874556B0089; Tue, 17 Mar 2026 04:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7095B6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:02:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F36B13B2A2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:02:34 +0000 (UTC)
X-FDA: 84554813028.13.419F885
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1AA494000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:02:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="d/nNTqq1";
	spf=pass (imf27.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773734552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mj1pDxNsNLLXDG2kvG2mZkNhGrg65432VMCNzxXhtRs=;
	b=YpDBEYoh3nFJVJB1FNkYNnzY3yTKT0aingMizAIBkOem47GY3koCf2xnabYaqFBOny32ZG
	jTi8YinApebbz4R2Up1taw4Efs6QNI2Mbd+1xnEHJe8GiG72Srvag8Tzce+laL19JgL9qy
	0sXSaTzsD41le9csHOIGqNQY8TobUqQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773734552; a=rsa-sha256;
	cv=pass;
	b=aRODVZZimZEicQzpcUMp5oE3S/G0vc8weoZwbIw9LPt7sGhfgna216Ir+r9HK2h9KhOrwK
	e8WFRt5KGUwK45KKedf8IvWPRpBVcoKerROZFELHriXGp3ACroGOMtflzQXICTW1sCvmi2
	3IujZeuNsWAsAyU8N4poqEUNGy23RDg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="d/nNTqq1";
	spf=pass (imf27.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-127148c2112so218667c88.3
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773734551; cv=none;
        d=google.com; s=arc-20240605;
        b=UrG2YxlKVbuIN2Vm1airLLRvQIOMzoTVankiIRGPsFtdIhEoOLmkxIngdrtt32748q
         8IEMeiJk9P3aSSr6EVjJygiUsDGiyHoc6Lh4AlbfOD1/AL2fjPt4O+rifnvQcXshhJtb
         DA2vQmYlnZtZjYHXJ44M14xTFb6ds2h1SaBVhIepd9pRhVOJpCftXWi+rhl7/V5Uzkhn
         Zd4TiCqO5v8rS1SddZHlmJRpT7D+VI1Vh4kcG8bCReW3tCeM9fIc2arZpqR78wBvgf6B
         Yw7CMNxji19h04BcTVA/qZK3iWbATIqRHJRMG2E4Zq8BHhNjKuYbpeSfTISXaDRDgCgf
         TgBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mj1pDxNsNLLXDG2kvG2mZkNhGrg65432VMCNzxXhtRs=;
        fh=1twl/bZO6CD1qke6KyCAptmwq5ilWBWDENf7XjpNkRs=;
        b=kjH8nZzeD7jnJT28kXatMEguRAsdKcF1vG/ro/2nR/FfLw+ZpTohG/SJJQ6jFV7nVa
         aoBuRvUvNrU+rmfQ74j3Uj8TUMiIYkM2s6NK4Er/1VmCC6BhovpCNvBiAs/0ufHWKGVm
         816aic71Qw9/060GBRZJ6zX9aWOeIJIjvH2XQPSTY4R2JSkswzzfG9Hsqq491POibTnt
         Y6bUHPB5DsrJEFkR64mcQfZtWozA//eeCuJ8B13v2pZNpxtU6ZnjUeCATdECLKIQKH+x
         fubiQV7EZKgB9pqEIRp3CVVySWCKu572n0t+GgLef0tn1uW3/KSsMfhTZ/YSB6xefSWe
         vZEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773734551; x=1774339351; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mj1pDxNsNLLXDG2kvG2mZkNhGrg65432VMCNzxXhtRs=;
        b=d/nNTqq1dN2lX0aVa/lmTO0HsChLnh4Wt8SyBqqjXhbnnpdnt0Ip90Vld0foDJOz7Y
         Rhb/MG87KK1BlUJRTm10cJycpiRO3nocC0CfqBKuGcWZ64nYCkUttYzDhxWJMNajZ1IB
         SGmob3JxwkW+jKVSp5QUI+M68yHjBEK1ZmPrIv6/9cMGfqIfiYsWkanq7UQ03NDZzDCx
         ViEK4c0AXISjDBCTQWPe6x5Jl9Z+VGlmCvHdstsxKaLP6Ccu3vM3o/P+sm1henfuwbxx
         JJ6OCpVi1DIDW0/bfa4rm3urb0llEe+MG9D0Ou4Hxz4jBNUdl7KN3G2rq4u5hlTnEgQZ
         hNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773734551; x=1774339351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mj1pDxNsNLLXDG2kvG2mZkNhGrg65432VMCNzxXhtRs=;
        b=ZPIn+lyMJtVQuMrV8VAMvYmuYHh0do5FvZpYj89vQC3Md+idZl68wEFffj0gzHZRUx
         OdJ8JtE/OErjPWS2YXZGjf370rIUY3X3MIX9HLsRLdStwNCmvfQVVsHrFMF7BmpG3H6d
         R4YRyU69TCA3wzooCjhVU8S1pwuV5faUZDknycg4dMVTM+v0VlVQJ48rvreRmdqZM9Mm
         xUrGPCd2KTfELHNJjV/A4lIFEtJG8GzfCskrUedzy6erkImb7jZUYF86HNob2iY4D0eZ
         /biyytywGNcioFg4GKek5NGrGhNhGVTjPaYMS2cDq1KSElDFluHp2Vc0El2UE6cHaO2Q
         Wr2w==
X-Forwarded-Encrypted: i=1; AJvYcCVCTIEpIYSpfq4JIaqwHelXjp8i95xhxtHQY8mtQGo+Xv3Kv2+Xm0mjESmghst2L+RantdQLHXZuQ==@kvack.org
X-Gm-Message-State: AOJu0YyohXb+9a7zpdsTbM2yvDR2TBF4RLTPwWgB5EDO4BxwhvE3NlzX
	Oc/j0sjDj9Yriwjl4L3PdPjAnPcYD5crtSPiis6OAY8X0zFjKUz11yMa6xMW3xE7ahZ7mGFBJNm
	oVWFXEgouTzbxt17zCQSwD7NcWJZa7yI=
X-Gm-Gg: ATEYQzw/j4L9o1/WicAByrZm9YLl31oTM0wW4bC9HgBZx0/R4Y+83KNyqml1nTxfCq/
	OSUnScGWtu5kFwqP+V/7ZI9p3g/gnQh2eiV8W++FQ4dQLTOj8mz9FmSx47FCn3X911m4YLaRdoE
	TCZDvFrJbNLgqwQAJvxYWoBgGAm9rZogupgaY8TjmtxznXS3wuohmkiVVrOk6XwvSLltH8vEABW
	1cpFPtLoavUxXFV1ePgU9D7q/jfwzKxQM4ex6YAG93ETQ0GB/VfUGwDJLXvk3QWs56So0dV8hUZ
	//wUlK1S2u65AUDz91ec77GJRATfVHK937esumqzwV1M3gc19b1n7vKJZIgKgjulxYhv2jc5i/a
	RmG6GdYrouV+p6B4Vdhwc7ko=
X-Received: by 2002:a05:7300:e887:b0:2b9:ddef:2c13 with SMTP id
 5a478bee46e88-2bea5590bcemr3462168eec.5.1773734550615; Tue, 17 Mar 2026
 01:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-3-beb8547a03c9@google.com> <aasPsbMEsX6iGUl8@google.com>
 <20260314004012.GD534169@ax162> <abVE6VWCzZfyMEsu@google.com> <20260316213440.GB1329928@ax162>
In-Reply-To: <20260316213440.GB1329928@ax162>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 17 Mar 2026 09:02:18 +0100
X-Gm-Features: AaiRm50RfwFM9fMmqm7H6QEiWpid4KdXpZyBrHWN7l2K7PyOj7AradadNJ2iMyA
Message-ID: <CANiq72nEFH8onFqA-8qXxeT1izR+xJdHT3AWrAqAzjPsEMJrsw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] build: rust: provide an option to inline C helpers
 into Rust
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: day6thkum1in38bqfoa7nfabhqh1dfrz
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AA494000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773734551-487441
X-HE-Meta: U2FsdGVkX1/XXqL//24vDOnb2Jmvjdwe5hSfddq2nh3a/EKEX6woBRXPd8FknV0gBHtNU1J/UZYQHEANdwDMr5FRtdnUCBR8EZy5eNfgrCgtn/82US5lOFYfhqD/fjMY1CePAf5becjHWBHDT0KSe/je3TDWw6IPpFuUhZTntlNZWbGj288w9eDFQz0lKyTaL9c3x7qBCqdRBM67UV5pmGm3DMZCEhzFe1qRK8fr4QKFVBLTtTnmHMoZWhT+5JX3nt/KCvLGlV3SaFcYALwsefV2rrQYjCvgs50uVqoKqPqDC5HoXVSwwPvYhPZ+fPyMV93OyqrmP6N3LwqXMjFp5hbfRUBA3v+qCXSN988NSskwl6y9tg8NQpACJVOPy18KWHRl6bcFe4LsS373Ut3QURBOUCbKFTPCPYuQIv5Zi8UmZIG1YtGMohKTnOtKRwn54eixpghKSoRWgcUzUgLI3DLRHz3rEoJrfXcQ3IS5x7JK3gBsfdXBznTXXHGOotmU+3BNebAJaYHnYOveccsNCoV1w5jCtOBCH5H4LlxCw2lWDfZbj1pgdW1hFDsgOiAysr+sI9b7OtkIiTi+T8jPKaJ7oioi7iQf0zb2PEuIQEc8ucRq8c9o31EIjWYX2QWC2kdUGrvHT/hos80TCT74oPDHgXyiwo7lxx0IOOPAAHANb1tKQJW0hnti36g3SWO/9arwyM6bUyHBjnuK0HFcMOB9D8bw9sVyWAEI8l5hYYiWMtYDne0CZcmNaNcTkWpmpCevb0IzL3pruQeu39d5j4LYlrfFys5soE+nCTjbYBC34d/goIs9Lp/LjNIvc1uiNwj3QCPBoUzux4TCKBXD5B6SLZIJcdbS+YBJuA2UqDYXm3MViTA0PWXPVDm3nhV2Ps6fjjR0Tx4En4CzXMzKWgvzPoADyJxZ28+Dj+Ya4Uq/zKa12ryD8HpqNUkBKo9TxeSwT9nRJCzlyXrzS1h
 C8N5InbZ
 jPp2flnHqdIRXJEkpSq40qQ3Gzm5GVxuopEXLGztDELDU91nwWjXGCSDgiIMtw0SjgXPnYW8KRzZXZKDZrzlWIwgknPERdlXA8f1R2UCtZujyDcCpnD1FM4qtBpcGDcObRvwTHnNaVoK8l3+wAkHiaTiD2u6/9Eh8D+GUOs4OtEnPOotEkjuUVbIKqV3F/OVK/ZBCV/eFBy2wvlP7ZDssR57HSWqzn3p03voehtj1iO2X1WZlIksthT2JYXAPTRE1+hGBzoCMecT+T/BQouufj8JsStHgvv3ZbmH/QOJIYfoRYMD7BmlzcOkNnpzOdOXdCoh0cDBg+e+25JWz8zd1iz6gWsWwqRr7YMYPu7sSVmP3/uDODjf/Ojy6C6PvIJBozZXQxrQsKvXZWbiv6baZ+bsarNXFPaARmqnAgpl5RmacFagC3Sf8bQ88+CUNYzu3vDMgNKCUjEcGNZqowbrHKJmevYaX4K8YaFTg4/E05+vmz06UcWYH+o67uNNILsP6WMNRYfjzmW1VMksds3yrOFRtrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 10:34=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> Hmmm, yeah, I suppose so. Actually, adding those would allow you to drop
> the manual inclusion of -DMODULE in cmd_rust_helper because it will be
> included via modkern_cflags.

Yeah, a week ago I asked Alice about simplifying to `is-kernel-object`
as well (mostly because I used it elsewhere in our `Makefile` in the
past), but similarly I ended up thinking that if we are OK using
directly `part-of-*`, then it would be better anyway.

Cheers,
Miguel

