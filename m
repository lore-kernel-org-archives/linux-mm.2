Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F34C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5366B00A8; Wed,  1 Jul 2026 07:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6CB6B00AC; Wed,  1 Jul 2026 07:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FC66B00AD; Wed,  1 Jul 2026 07:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4776B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:57:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96EF940355
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:57:49 +0000 (UTC)
X-FDA: 84940058658.14.CF114FE
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id B7B4020004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:57:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kW1NtbWe;
	spf=pass (imf03.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782907067;
	b=NTdtnrV2fNxN/+rVV0jOKhzjDJIS+sWpEn5kpwrRAd7faXTdQX/guDuo8s/ltj6C4VTxii
	z18ZsExMJ3vEke19gKfWuAmluvNrmrTSEd/NdBwrCo112FPMTFkQb73eUZWE8jyIRcI8x7
	AVPai9bAWz042jh3wR1NM/jLmdMXzsI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782907067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqKxpCifHTwVLxyMY/FMijSWYZ0kJMALXZou2Lu6auM=;
	b=M8qAzVHEtkRusyLeWqkUECTSK+JiyFf1d5Gn/x/DF/w+Vxm8kM+BuV7ZTt6qUAlZ6D/E11
	/Pn05Y8r+K5xs+r0FZGOF/rHXq0r2B1OkNFhcnDxqpTEa4/ctzICge0CR/kTO9J/81gVaI
	bqDI3vgd5e9gnNvSCoxV0sYQ3XW0asA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kW1NtbWe;
	spf=pass (imf03.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4955cd5da3dso220894b6e.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782907065; cv=none;
        d=google.com; s=arc-20260327;
        b=jT+mLhMSgh9fCZBo2dIqy/xq6caP4Ik5caV9hPzfzF77li5Id+XDIQCsqql1xwejsb
         wkpHgycaqkhURwEK6SyarBPwG773YCOJqv38fs3lM39SfI0wc0Tqx7AiMDyuPv2GSN3y
         gqOnaHeMliSq0YU1tB0SbK5bYAnW8fOBhEVcudN9seEqFzBc3tojsvBYTMpYHrczPadJ
         xt5Cc5CPSiYcv/8L0PaXKnlJTibgB7NHntheQZDiRx0DzwrmEIXpkjG0r/UDCs4gTug2
         Bk7UCo1uDSLJohphj5qJDaqJja5rTKQgYy8O6WoCo5s3PLJM6zHZJXbhp+OUeFeugKeG
         Yr2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lqKxpCifHTwVLxyMY/FMijSWYZ0kJMALXZou2Lu6auM=;
        fh=qr7RIvn1C46DEZeOgxxhyULwGBD1/Ad2qocG856SPAE=;
        b=NEdtj7Is2q3rPbQRMJpjSDIBOf7ciDIJNJ1kVkLaCDe1UOkF5IHw2H6Ezajyh/Wme9
         cH5QrnLBKRRSldn73vLm8pMhOTUmIkpYfzt4ho9XUurC0+cK64ZcXeeAJXUJBZcyiJ0n
         MqozS4U7LcxHA8knep4EYoWZgXTngCqYtZjRCkfQtI93FLlaJrTn9zxWmPGyB6hWmdQ0
         TrANdz8giQGhkMdLlmnE/AYE7ywkg7GO2SmPSsUfnQ0sRocVvwphxGgvMYShEHXOFOuh
         i34Nh9CvdL1fJ5E9AfHYDSoJb3CbpPv4d+FGgVLdCuZM07C+s6aDuNSQNYfinVl403eu
         BXKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782907065; x=1783511865; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqKxpCifHTwVLxyMY/FMijSWYZ0kJMALXZou2Lu6auM=;
        b=kW1NtbWedjNt4kzJ3rT5MqUfNuDGvSYVta+/QV5ZEB0AjHO9byl4VK2AcFPMIOZswm
         Qwosjeql8Hxc53YJdMuo9PckBm9E+rRtbCUEr8y72AdfC5913EOPS6PHfUdHxvOemHmI
         /8VcGWuwS0ijGOR2c8dg4cyC2aaABp+NkKKvDZXEWdt7v+5fU3475DkTCCvl/54fXkAp
         rBbYIWUtm+0H30waqBNfD61Wg+oXpDVs6nZc5VWYHVm4CFi1ASOvuX4/Jzy6rMEpypf6
         1+OX7OghfQHbqYdlQXGiFOjLhXDLQ0ndx4bNAUKAqe4u1hfNEfRW7HXaatvo3E4eycOQ
         FJ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782907065; x=1783511865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lqKxpCifHTwVLxyMY/FMijSWYZ0kJMALXZou2Lu6auM=;
        b=iHkAoXitv3w0RDaN/o6020wEX+hndNtEDveey/PgW8lRQWSAVQgH8ITpnYz2JuPj0g
         6W2Q/6hNSZKCNt+rBe8vhGTdrmYlACvahpbPDLZLMWVVGQX+HL8vSF+wy8VNOPRTlosB
         P+34h5WrnbipoNJGystNn1sIHY/Z+Iw6yMjuy2YhKNfUZXuX/fuR4P7tCTUAcd2leTUw
         BYRaM7UJ1GnCogGFEFRKMUrrk5G76loJifFknauURge/KaplOMUXueiirCzATeJ9jcXj
         IFYQGOzFeQ4mHJ9uoJfynMtnmOFAcGbHn5+/Q46zT03P3KSWGMYyKzLJ7kdQ+DKGU4C1
         rY6Q==
X-Forwarded-Encrypted: i=1; AFNElJ94hw/BMUL26yBf7393y4Pz4dgk/clJb2C6xXPivh9wKoLUE5F0OlIKw05vvTPc1RxFw/w9SVK2zQ==@kvack.org
X-Gm-Message-State: AOJu0YwEDLzM6kiroCZFa26OzvFDQ1DckUzdrFXNmOUUF7ZubruD/YFQ
	ecr7wYVGXBMcYzmMY753EwEqWI2VNNPyVSPyh/Gt/BWzUTGvv40UEDe6SAbjAyqi4245UfN5Z1R
	beZcisl8xiw0cS6hYWlD3cdZg0r7AYgVLGy78b0lekQ==
X-Gm-Gg: AfdE7clU4NAW7sURrrkNEe66gaei5NLVeF7UY4bfOAPRAJx+DuVf8iOsNXIiZGab5XC
	SJm5Klatb/jt9KQBBbMoEqGVwcHbHQXgVysV4IluH5oQ1bgIqs7Lc6y5D5JhB6SilRvZtEhEVTP
	4rmB4ZjnZzXLBEaFRX2JvfZR0mRhw1xyRiFbH+Am8UXQunsugmLA0drXF4oucGL8Z5ivNDS1ZWD
	RubStCqRGJXz5Furlew6FOqQbAHQYONa1NvY6CZ3ECIJgiRpoEIaT7cx7x83p+fhqbfdqgFrkA=
X-Received: by 2002:a05:6808:1389:b0:492:5bf0:d29f with SMTP id
 5614622812f47-4960f0d2101mr838181b6e.37.1782907065542; Wed, 01 Jul 2026
 04:57:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1782877663.git.cuiyunhui@bytedance.com> <7988df83f6341ea045ebd7294af2e8907dbd5ee7.1782877663.git.cuiyunhui@bytedance.com>
 <ea525a80-1e6f-4304-a371-3ec17d91ee96@app.fastmail.com>
In-Reply-To: <ea525a80-1e6f-4304-a371-3ec17d91ee96@app.fastmail.com>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Wed, 1 Jul 2026 19:57:33 +0800
X-Gm-Features: AVVi8Ce8Hvhgv036NZvyTtBZ5NMmFq-2bEMlGWh7WwSjecXpQvRJF8LZ_SFRCM4
Message-ID: <CAEEQ3wnDACZ08kk6ycpgXezgyS5zxi+P_vF_yBScK2sxU+UKaw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v5 1/3] riscv: io: avoid null-pointer
 arithmetic in PIO helpers
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	=?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, pulehui@huawei.com, 
	puranjay@kernel.org, Thomas Huth <thuth@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Ben Dooks <ben.dooks@codethink.co.uk>, 
	=?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Zong Li <zong.li@sifive.com>, 
	"Conor.Dooley" <conor.dooley@microchip.com>, Thomas Gleixner <tglx@kernel.org>, 
	Deepak Gupta <debug@rivosinc.com>, seanwascoding@gmail.com, 
	Andy Chiu <andybnac@gmail.com>, menglong8.dong@gmail.com, cyrilbur@tenstorrent.com, 
	Vivian Wang <wangruikang@iscas.ac.cn>, Atish Patra <atishp@rivosinc.com>, 
	Anup Patel <apatel@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, qingfang.deng@siflower.com.cn, 
	Linux-Arch <linux-arch@vger.kernel.org>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: be8onn35ufp5xpo8sery3gh618ofoiys
X-Rspam-User: 
X-Rspamd-Queue-Id: B7B4020004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782907066-691894
X-HE-Meta: U2FsdGVkX18kHeXM78yt8sQxhjH2V65zLMMHEFfGmCynqwbI7z5k+/UBDZAkubNh8b6qlOKUha4iYmUzgY2ufV05G8LrueUngncEl7vWZNniF2jBFA1M+TwytfhFTNKqP1FPNaFD+2OdnHSz3Esy2/o237kefnTdY/0gyTPoj9fWkU5tSFl+INSt3j/gpPL9A7Egt3OnoAoaV0OLPQkWxHsdp15EKgn3ssURuKeLOySW63nOCgDmj9+xpVoaWP/tn/YeI0SqUASzWl/xq9iJV1twJO+ayu1maJUsXIeImJMRj3PScvSx9bN4uaBRNWgc5ED6GJUo8oWfWEYPyOfuuzX5e33nMqq38mFhyseR5f8dpDO3j8aY1A7r2YAxOkffDcz0+QjjSjXu55FRdKWwEtVE+ESnv4m4u2P0Cx1zhxGUXYsJjO3XWa/8oudsucAls61MtR9G4Q0czM9FMf0ievdyG7q6jCYwge7H3fbaiP8AVI7ccKDseCMlCbauP7vqysrUlY2nEYPuzSE89vo+vwny2TRF2PDUNPE3y8L6m0aqIuQC/MmZXWGgH1EXcuYJgKjdgOJDF8MZcLL6td2sbgpE5/aiW3Z1TGcj2/Jn9jKYatv6lerLCPrCx26KQnGlsYcK6K/dtqJLI0qrPndnA9e5bB8z7ATCG0HACkHVrnrtaYLTfUetRkL0jYROD5AteiBpVCJOe3iVTg9PE7/P9dZRrh6fg1YPH3N3Q20tvdLHo72N01gvLZ1tg0p/yOlnYuTcqYUfxSBLcjV6qihemw6A7GHoKJMfbuJw1pDMX9AaYcwCaUcXqwhv9s4eNXhMIrG/6J9SECQ+cXTNklEnmE+ZtcicBT4ZoexXn9AdEGR4zaFeFfFAyN01MZhFOgVQ0TJWy8Hm2an4Syya9sztKDs2HcERc+dFYvEn2jatTpxL0szq80fcoD1HEoeXuprf5Px9wF9BKA7hdo0vJ5O
 mT/D+z/J
 A2fqatKOYuuatWSFy8T1DGc4CGanT6YicS4dn65o81hhsdfU+1JxJcO4HPbtLy9AhL/MO8gpnMIYTMjdWyg43aheQsHkdzWElu6QjwgQGJZplABB/cN+Sjger9+sRQID9CwKHSq4a12lyn+ZFSHVT7bWPXArlmb1eO07YZ/olgoHIELDaWEJQXXCbImr3o8Id5eXIwwMfT/40Sgtv9pFIgz5JbK9Y4dG6pCuvmPi0Wn61aWMEs+tmaccOy76EdfraHW9EW9x8ypmBjEc7KePzrMvOzZWZwe1uYurFrL2pGhXvoD2fhqbsQFHEroBL8ygLViociiYPCgAsgQZrcAkW8SknShkYKQEIm2dG+2jqWOXTv6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

On Wed, Jul 1, 2026 at 2:25=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Jul 1, 2026, at 06:20, Yunhui Cui wrote:
> > @@ -56,6 +56,8 @@
> >  #define __io_pbw()   RISCV_FENCE(iow, o)
> >  #define __io_paw()   RISCV_FENCE(o, io)
> >
> > +#define PCI_IO_ADDR(addr)    ((void __iomem *)((unsigned long)PCI_IOBA=
SE
> > + (addr)))
>
> This does not seem to have any purpose, is this just left over
> from the previous version?
>
> >
> > +#ifdef CONFIG_HAS_IOPORT
> >  __io_reads_ins(ins,  u8, b, __io_pbr(), __io_par(addr))
> >  __io_reads_ins(ins, u16, w, __io_pbr(), __io_par(addr))
> >  __io_reads_ins(ins, u32, l, __io_pbr(), __io_par(addr))
> > -#define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, =
count)
> > -#define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, =
count)
> > -#define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, =
count)
> > +#define insb(addr, buffer, count) __insb(PCI_IO_ADDR(addr), buffer, co=
unt)
> > +#define insw(addr, buffer, count) __insw(PCI_IO_ADDR(addr), buffer, co=
unt)
> > +#define insl(addr, buffer, count) __insl(PCI_IO_ADDR(addr), buffer, co=
unt)
> > +#endif
>
> As far as I can tell, just adding the #ifdef here should be sufficient.

Okay.

>
>       Arnd

Thanks,
Yunhui

