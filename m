Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D10CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DAFE8E000B; Thu,  2 Oct 2025 18:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3238E0002; Thu,  2 Oct 2025 18:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A3E8E000B; Thu,  2 Oct 2025 18:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E001C8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:50:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82E31140680
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:50:17 +0000 (UTC)
X-FDA: 83954669274.29.161E34D
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 956BD40008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:50:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UtFidvK1;
	spf=pass (imf27.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759445415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxtPQe1b0MgbxjGfVgNQaGXQeWz7VgG8PZ8uWv1F070=;
	b=G7LkX+rCJrl46391LrrbXxL2PYTcvlrZ4K73biWpmP+oqpOpZ7cxrjZssDkVslepVEdjRu
	LerZBcoOiS7wd3JSPlB943y7oMrnVqLaNAVORaVuwtRoBCArGabgsNFTpvMFUWXSNy0Cdo
	OLk3sDYAK7e9iH+LlP/Yi1C8fpuz708=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759445415; a=rsa-sha256;
	cv=none;
	b=uVcfHIc4XFjG8Zn9GmLo5YCLLUEUG0aem0CGVm7hiThaa5SgmoibMSiOkLWOCohE3+gZCP
	Jqv91CY5ZMMI6kGusVLh1tfPJFjDt5ckzS2o/quuQXJBfDQuRoVcAnImRnTYZzq1mr9AH+
	z3M1I9fmPRtUwR1QnLugws9W73b5gY4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UtFidvK1;
	spf=pass (imf27.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e3cdc1a6aso11051945e9.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759445414; x=1760050214; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jxtPQe1b0MgbxjGfVgNQaGXQeWz7VgG8PZ8uWv1F070=;
        b=UtFidvK12JwZiS8net8Kqi2KbYLPuRiDv9UkHHBTGXpya8izAPFynbD/bH4zEvcSw9
         zLz1+ktpe/+nWmuy6qdsGPLmLlZ8ltBJV1YiJMvLqaatCtAH9U/kmhSwag6trmvcFR8t
         jQaJtTgqtKFW51kl/Mlc7cZMblf03pT8Y1ZHyMk1LUl214W5f7A7CZPKNBtQ33+nt6Pd
         FddqiugfJ1SltDJFNdmtsQHkEp8It6fHzuUUkXmR0aaKRBjJylOZzsmzoGZvo6UsyFFr
         S/yAE/RMsdD0PZUOtVGFz8ntE60Q+fVhAOf5DYjPLOVbwiuvM6nbAazw7v90in0GT6LA
         MvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759445414; x=1760050214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jxtPQe1b0MgbxjGfVgNQaGXQeWz7VgG8PZ8uWv1F070=;
        b=wkg1ZwvL3opoeMSofU8/vWGv79jDZgAeluunSRC6RMMHUrCD+/RT5WRzNPlX3pGxJj
         EW2LfDJEn2qWfe8ghPTtW1yvy4JtQp57NGxAZxaB7/pSh8DxoAlIbmi7MXGROcxI4sF3
         hCaMWBJMRyhKvKx4UAtyIW5i5w/imq5y4MXlp4MOHQiLccaUZD6KHjiR4qdKvhL+C/ST
         8F7L8g1MLIMzc9f0OCgxTj5Ry3/bl5JnDpdQl3Oxka6AZqlUphnRWNvmxccpnoYyjR/J
         zm2Ws4qu4ckUHR6Vob08CYd+yhn2QdtBYI1KuNnzaCmzJHgBjjL5AOIpwMkUtdUEFCUm
         MfEA==
X-Forwarded-Encrypted: i=1; AJvYcCWByqMto9i5QsXc3UuHbWXgMC0vEMO/Y55c9lC8lOJrDp15wesdcghGuJyF+x/3f+BWPoATpmkNPw==@kvack.org
X-Gm-Message-State: AOJu0Yw5vDbtF+es4BVKOU4udTHjxheLwEj9kiT1b+i1YShrwep7sgGP
	ZH6MZ86DOki37DmUNLU57UnaHP49Xlj+r2Fwz56ynoD9UCW8pwxZDDdhFP5xEWeKKnZUYiu1SRs
	S7X1Kx38xviG/C145/A8COrC1DaX9aUBm1ru0tPR2
X-Gm-Gg: ASbGnctGIFiF4i5s1rH+Nrrl65NMlxooCaKtCjGvzJg+I3dKDbFIkIhpjvdbluG1SOQ
	+uBaw+XCqb4IqlxtFdh7tH3qa7BGDtPpFVLfceOtJ698fdMJJpsbikfIOWzONoc9NvSas0VqV/t
	yBE+TvDsYjSdD+IUoWkKQeDtmLdwSAa31BuFhtiecHdiY96yWgPRRzTf1t3nqUiH8uxPlcWhMiP
	UvMcJt/8QEikNC0+IxtLL4vdbAX1VjvbuePy4SbQcCB9jCHlQ==
X-Google-Smtp-Source: AGHT+IEBz6Cy6eB61n4T9EDKMcjbX1FzickEfiY4Bp05xtOY6F9ZP0v6HQaE003SmqjEHrULNb4Tsv5CwqwTNxWL3o4=
X-Received: by 2002:a05:600c:34c7:b0:46e:5302:7751 with SMTP id
 5b1f17b1804b1-46e70c9bf2amr7897855e9.9.1759445413960; Thu, 02 Oct 2025
 15:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <202510030449.VfSaAjvd-lkp@intel.com> <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
 <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
 <CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com> <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
In-Reply-To: <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 3 Oct 2025 00:50:01 +0200
X-Gm-Features: AS18NWD-PBkNKF8kB6hVqVgtujt3IbYom_QTRnw_XVpZ4QPMK6DidM0i44zAG74
Message-ID: <CAH5fLghjjKG6h+T2TFmtz3jPvRxL-u1szLVs8aEs5S+0bCUcLQ@mail.gmail.com>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, kernel test robot <lkp@intel.com>, 
	Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hb9i1pph1iwqaq7r6sgxbwp9hxqa6mwj
X-Rspamd-Queue-Id: 956BD40008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759445415-105147
X-HE-Meta: U2FsdGVkX1+ek9IeiYzr6F86vcbclwua6/glQ16n82wLhV9hY1sbrvAhYx5vFX2HjcimpBsOivjeuHQv3+hePwRmzRjmYWCCd30+r2z0SfP48XVzTHsEhEb2E+vkDt8sMw1zT4PkbaPSvEGAFFfU0IwgrFdkKqom4ui6O9LbvwKCsfZMahfYpD6E1nKrr38G9ckNmFFH4ZReqZ7tMC4y4pSKV+EyJPuuWIhaXr0NOtevUSVswv8wKMmmaTvfDCgnWJed+Ncrw4fSA09zQtNz4KaG9EOIhpUpYxYtstdmONht+lclVQQ9SxvMNbODTbak7tJu+zCDcjgUu6ewNVnAJMH4zKNpqyia1T9vwTci2zFIUu24KqfM6N3Y19E4q1XjdXCg3onteYH0PkVfuH1kQO4BMCwFJIqmbeLrKjktCzM+fFo4eklPf8MeSmiuV2jDhogtKE8KDz740NpAfYF6eN7zcalluBFsrJR9ddwhbyvCrc5fnSD1A6qDA4XvwOhvy7zaXMftqEv4cto+ODxQv+5gC/910Qmt6fOm6e88/LMOcka6FYClcrLQKnicVgDtHcA83ZxVaDW44aYJ2kY+RfSqITfrx5oRBY2BfApssTIDoD7TXCYBPc3SFqfLTkAJGCJM+ENCK8e7SVJUTDmLFwiYktlsq0cmkmhFQbUhbdkvKuRWHXsxITrotVQFWkQVQDjnU2VzZcXJEzwzo4ut/Ludm0dsbSdxq2nTx154RylVLgl3sqXd3q4mpTaV03gNfpxzhCRQk/Z1ydyVsFffWO8f8YQE3IHCkGSkjvTzeuU6Vh+zV7NpY26Tp8rOaOT+2RIm5ic9EIzMFvTdTbV4xoNqzqvvbzILXXhGgqk6iUThOs8OEalotczVELZ8WHp4OegVjf/IKhHs7k+Ph8/shScwqqWf8AGeK0l50tkPQuE3yLY/KZjAJKE8H2joxYrfIJMh+VpGweTqiVVhK89
 2HZJluHD
 OKWa6HGTRxgDRUzTXFGnOlp09SVTNH1kyvCM/jqfDXtHh4B9ikKEWN7rTqPpx0/DQRKhTPjjj1oWner3+EsIGClowKZswi3DcaDEU+pQ5E//cF7ydDy+7SvOJ+JWXuctT4Kg/x4TGH+SKYmkV8VdBNpNSVAUOd9BShF0Pi3bDBFFnCa7icoK1nUJsxF3dNFnMWtDPgFEdGp+ySmXFvXWHrbKvhhcH7Lqqrt630GdYrW8HOryquaUlvy9QXzOBwbi3kYM/ZnPpdaPw8G02SEQ3H0kiXmUOZYc5foSX0L1UbwQtxJySQWpa1i6/iFS0Zis56hWoY45WhjlxxcM/ZbrgqgA7rfwE7O6IBF+YEtpG/rW+ka6n6zjQrZMNWOBnVNS40WBYIUKnjAccONlVfPu2uQpdM/fVHdNJGrnTofePevMSIAUJaUa1KD9iOAl/7xnRNNdPFEskuzUcFXwJbbtdc53iu3JjeY/IjKLHwK3OLTG6cJBph+6grnsUddSqPKB3b/Um1b0ZFGYZrDqB/icHf1vSJ3dW7rgBS4Ij
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 12:43=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 3 Oct 2025 00:39:16 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gma=
il.com> wrote:
>
> > On Fri, Oct 3, 2025 at 12:27=E2=80=AFAM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > >
> > > Sorry, this is rather annoying.  Rust is breaking the build for a ver=
y
> > > simple patch.  Many developers aren't rust-enabled and probably aren'=
t
> > > even able to test a fix - my attempt to get a rust build setup workin=
g
> > > didn't end happily.
> > >
> > > Jakub's patch fixes a kernel crash and needs to be merged into mainli=
ne
> > > and -stable reasonably soon.  But that is now blocked until someone w=
ho
> > > knows how to fix this error and how to test it gets down and does tho=
se
> > > things.
> > >
> > > Jakub's patch is present in current linux-next.  Can someone please
> > > send us a fix?
> >
> > I am not sure I follow -- the diff I gave you should work.
>
> It would be nice if someone were to test it!
>
> > If you have a branch you want me to test and/or give you a formal
> > patch on top of that or similar, I can do that.
>
> Thanks.  As mentioned, today's linux-next is where the problem is being
> observed.
>
> I'm queueing the below as a fixup against Jakub's original.  This should
> appear in tomorrow's linux-next.  Or the day after - it's a timezone
> thing.
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
> Date: Thu Oct  2 03:37:47 PM PDT 2025
>
> Rust bindgen wasn't able to handle the BIT() macro.  Add a helper (from
> Miguel) to fix this.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-lkp@i=
ntel.com/
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jakub Acs <acsjakub@amazon.de>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  rust/bindings/bindings_helper.h |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/rust/bindings/bindings_helper.h~mm-ksm-fix-flag-dropping-behavior-i=
n-ksm_madvise-fix
> +++ a/rust/bindings/bindings_helper.h
> @@ -99,3 +99,4 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRE
>
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
> +const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE =3D VM_MERGEABLE;

Tested-by: Alice Ryhl <aliceryhl@google.com>

