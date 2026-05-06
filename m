Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFEF1CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 06:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAAC86B0005; Wed,  6 May 2026 02:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82226B0088; Wed,  6 May 2026 02:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972046B008A; Wed,  6 May 2026 02:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 868986B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 02:10:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F8C01A075B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:10:53 +0000 (UTC)
X-FDA: 84735971586.30.DED6B01
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 56D76C0007
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:10:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kZCagUAj;
	spf=pass (imf22.hostedemail.com: domain of rosenp@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778047851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QUus7LGRjCM/XarecC6aAwQ9yAm7SOn4wv0XIoWo5U=;
	b=blRMdx128OG9TWDKcyZOyK2D+ecEuU1C6LD5OCH+OTrXSbDDI3HPKf5beU014kbUgpPZw7
	Cdgi+WzkUoZqB+vRCmVZza7rYrToV1yXGoGQRHCraI1dvZI7hWmsJnlBROjUUQMzTuEUex
	dhHnkDX/ip5qS6WZPrfeUFe2OO/ik5Q=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kZCagUAj;
	spf=pass (imf22.hostedemail.com: domain of rosenp@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778047851; a=rsa-sha256;
	cv=pass;
	b=cQog/5hPQExKcoPu9gfQSTsv0kkK/Zhwl2VB0jEzEzyc4T71sYc8ahPLi/2q6Mve30Ewmj
	vyAznQT6CWZxyNFmNCSkbksqKoxI2lzAaQreLHcuga4wnapWcPf4ar8dF803mKmoDzcxgQ
	TRbtTFbTeJ+a45Oy71qopjZouOF9cP4=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bb91b426e40so1028330266b.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 23:10:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778047850; cv=none;
        d=google.com; s=arc-20240605;
        b=M82JWaW/o8+QDUXVx5W3o13xh8S1MR0uEf4zWN6CnSH3Ycj/+shWOSrxlM5KHCtKzu
         yhG0sJtneMv0KUlDzrnIxQvFlQ9MPYEv9dAvBCBtRThAPZ3N23pJ3A2HSJhs8R+EvMcM
         tkb4HUtqedMZQn2g/Zlzi2uC8SVdiwuLEBr0Dbj+4CBiIWec2ieRqVWzKfqIrigAc4pu
         xpNWXKvenVt4p+5ZevgvsYZf0NwgA5MPKoLrNn5EbcfjOrMm31ynoCk0sea0fSICo/lF
         +AcrAgKV6TBhdWQZNDZRbYPh8jzQSGRYj3ahguaT91p9so4f0WJx8BGwoo+ep+X5WU+2
         +KUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+QUus7LGRjCM/XarecC6aAwQ9yAm7SOn4wv0XIoWo5U=;
        fh=PsMAddx/bJTSO/xW0yW66EV6tn5eodiRiBdraXDRF4o=;
        b=l0Y1kdoNU1KJXP0HQIcgmvofCY+GtnXU6YW1mXrmr+cf3VL3NdQMke2b9gTlLBkZb1
         s8+AyL2Uxr4FsUGBqlEghydVx+PZhmiDlUu1IqcDQiKtEv/nZR/BAC/MYllp7VuQm/Eh
         ImGA8U6U/cNu1TkhfMbJqvFykmnYJXF8jpVFLVF50CfOnPHbmteyWMopn1R+PqSVdTsa
         Jalq3xERVpS6UpcHGP+G37KLzw7eBgLniSzDU425MwV4fXCzj1IjMZmoPckUT3bJWeJ3
         egmHo5tzaUa9aoyfRB+nMCZO9WPvpO+b/lK3C2Q0oaa04Elp8Ut4+jxpoZl2b1lzb97/
         NyHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778047850; x=1778652650; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QUus7LGRjCM/XarecC6aAwQ9yAm7SOn4wv0XIoWo5U=;
        b=kZCagUAj8ZBniKdO83OdHL1OztoWGbmwWR77V2KOCaFtgTY6Erw7dJtHG7SBc9Oe2q
         qkdHo2spSwQC0ZZQG4P8zcWt7+LK43cJ9udOaeqJVUzv/3mqJc5HTKdpPQOhm3UYoVec
         XL3awnj5HcJHvVQ/WoH3GF9d/qv1p/torsagImSOzyw2aL6gW4BYEBZR5nzxJZkrIRBF
         34v5dzarbB89wWzEtw+n2GYCEosZPbf+uPftz096+LXG5Gk7EvMCYt7pvmdfFs/w92tQ
         rUldCjuGtRLEEHNTnQPiJWj1mAwEFrHREfKX1wUba1h7zQKBWhqAH8647F9Ezw77TUwq
         dlfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778047850; x=1778652650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+QUus7LGRjCM/XarecC6aAwQ9yAm7SOn4wv0XIoWo5U=;
        b=tXrqkO0prb4NACwo+ArkuI14EIL8J3TM808X3JL4K6BudfiEUmLjVmWsUfrHq25KoO
         aq+hqh2YA2v/VrEA4TBzak8VF5BoZxnAgtpzNikY65eWuxE6JYAsbGcfPA/pwhtO3FBh
         yaxtzkvVam0iRxaPUIwG+bWIAEkyo3SosizXQ8gSGZpfE+ps3VIhmmtL74GGlZNRthky
         ABPXNmMBeLXRos5xPwL+QAUxqEb6JNtVrVAv6Khob2XMdaOLtsKed+XyDwWwl1judZKz
         DLW/2qCF3v1GoYxeWsujfYUxmgwpah0g0A9idRWhaq6p3zUgQE5rJ2pOpIBObX3XoxKg
         W0vg==
X-Forwarded-Encrypted: i=1; AFNElJ8eDl9qZ6GXM8nECJ8rRMWu3uA3bv1J1wK/305weiNG25q8iBnA8/j/3xevE6Gm7cO1F7GV8C9Yfg==@kvack.org
X-Gm-Message-State: AOJu0Ywwxx/d87wlgxlG7SsSJNPWrB6g6daN5b9BpaJZ023iOLjH8hfO
	VLt/fEmgc03D0+mSuNQxYtJYBDZGuNe/8ZL+TKchbDKspc20NnR7FQE7XDVDZGcwcuQOZNUZAbS
	NrXvJQn+MvG65iluQSdGgLmt9BO46cLIYZOoq
X-Gm-Gg: AeBDietXfUE7JFKvnHRx4CfJ2Wifsp3CpSzN1kcrDewrtzVPIIqsg60Y76LT/3RnRr2
	FL0H+AuKFRGXQyk+p2PwyGcnpxLO92/rJuHEylMNOTgQhTq/tBpLZJ9w0Ev/XU3fBCF7I1r9Eev
	6trLFLHgnRRh95TW0xIXLHmA8iUNlqXaEwjLskvKJQKMZtXkXtNZcwxfXjJQfm80c8GaUBmtHZL
	K26w9VE44/IMOyy/QUeVgv7LwnmHbPKLXIoYY4F1W4g0GnmibRuQcMxkTeYnZaUYegHSFN3X6Bx
	2Ibf2cJJV75x1lrKjPj/+DtZY9H6Rzl0mAQ9enHXfIV36Vc3EwrLMOlm/XoiMrWos3BT79v99gq
	m31fscf/y61H7I/6EFPy1FJUrks9B1I8jybpPVatwc6Qvo0i5jEJdp9DRZ62LL++1nm2a
X-Received: by 2002:a05:6402:4348:b0:676:9caa:f070 with SMTP id
 4fb4d7f45d1cf-67d642b23f0mr727752a12.14.1778047363334; Tue, 05 May 2026
 23:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260505010112.645361-1-rosenp@gmail.com> <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
 <CAKxU2N92s06-L0+e=KZ7EbtU50tCpaCk2MYJD2xTFEHEsAhXUg@mail.gmail.com>
 <df3e889d-ac8c-4d11-a5fe-8ed2769953f0@app.fastmail.com> <CAKxU2N_moR8bs=NLUcW054a=oHB--4i+M5XKCBNF9LskYcjAhA@mail.gmail.com>
 <add152a5-09bb-4c6b-a17f-da3d817b93e9@app.fastmail.com> <20260506054828.GA8550@ax162>
In-Reply-To: <20260506054828.GA8550@ax162>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 5 May 2026 23:02:31 -0700
X-Gm-Features: AVHnY4J6qXkx9ZFAQP2rElkyhPxrLn6pKVicVojYfRDj2KCztMjhgywlOvMZeis
Message-ID: <CAKxU2N9YwM3JuXs90yL68kcDX-0BWvxvPFqzTuONLR8P-7qg0g@mail.gmail.com>
Subject: Re: [PATCH] mm: move phys_mem_access_prot_allowed to header
To: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-mm@kvack.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sc1w1jxp9gmgfj66t1hc4b4bj9chimch
X-Rspamd-Queue-Id: 56D76C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778047851-140295
X-HE-Meta: U2FsdGVkX1+x3HHHDvJ0/LMSTggw7VcSo+oCc99g2IkFGLkv8v9PPMYMJYypyOXAK6lnPv0ptU/QlhR0CKKruj/3X1Wl1gpYGoPyPDy5tyOrSvuFyuav0syFAQVZb0lhTgskXApWS1n2eEI4eBESRAabNEsl7At2+hrwPFGakm80QKrDvD2OAahUIYr0UmyY2dgogcxCKqaUmbvsMj1e+u69PfXudlkJwio6jC1Cz4y5RVSwtf9+dV6qS3N19MUsmZfwKxhIZIi0alClFSYzWoTxe5mSMcXWfJBZHRbkJo+8xFwo+ObWwGaGwwC99v6QrLgICUw7627IhwretlYvpAs4nla0vO4iNwytRyyliXGRJ5jee9GHBRP1MD1GbIC3XvwYEAfiw4whvtYbUeeEgnDKQPNaMSOxYsi/e9VuXt3VHUuB7DHwytf2tcoFqSJX4/EsQwalWiThfm++gbw53ogz742BBU7FFzp9P+x2QHQQXXEea4d+NOrCIeLXQ+veLmXgDaNaH+k70AE8ukzx57i7znM6vUgP6DJdEtbIoVK4CbU8AECklet4S+2KfX39Nolpu7uwxQG9YnYHCVEc5Q5rfrsCb8/WCKl7dLpxeyBSBxmv5qsXeDgJ0M43tMtoK5Me03MVGot2EpBVVp8erMElv6LDS/KcBnf5K42e/cQJ5lYZ1/YYiqIAxt0IfZa7/69bEbWxMtg7QTAbvY1WY25smzP1suO39+h+0zoSPEughbw3WeFywxFiW9eAcAJ26EddPHE58enn1ep1EAsj0NpBmtdDor3x/Z8j18SBk1dNE7Bm2Xv2sLn8KujxicSImGGI0TF9H+2aUJWxtQuaPb/05Hc3bDfpN0m5iXwNI6kZELrT6UkqXrBdp7b+hBXii+0910y0wf8zmKQgik9N/TREOjDwZHSIZLvqn7/F9bye3/cNPpbnzdsdJ8iFUMiUf5shDVycPNlIaLPHkT8
 iCOm6EH7
 kwce8m8ip7EdZNXG+sKW3rm4j4kdB3GJRyK1l5QjesO5LDV0qxEKZfXirRdtVGHuOdEdB7L8j19gyOfKggduidYJaVKOIrVGueqi0Ai0MWPj/77+S4pr95/VSHLvKY3z7DCJDiuUGfemqTGkSpdQhAX7FhcIBMNsJ2jNe+uWUVj721CeMA/DOqMlwTJplccRaiZat7XXeH91U6OG6/XtA3FmxsySjJbudpgm5j7EvsxwECku7wCbW/x22Hb7TbQNthMeu7VpbfvQHseNV0yrCmBCMQ3W2dAhERll5vtYaOkRUUmH7onH2ZUUL6ClqPNCBtjt1BAErfHjd0sK0uH3NzNmtdbqJN9vWjOax3BsO2IU9w9EBGPo9ayoRRvp4N/dWDlsR/GfLL1NAQXPbY9ZxeKwhYKS5geZuS8/V7OC//CxpRUMXRZ5h3pfXbrCvIZMFpoahzUC8/f7iMVcJEcTuk47NvPgE1rmKhfMgZsxZUQuK/DkRo4qdtsyCKUGUb9bNUNsDdQ9tUJsuXS+jmaVuoyMwyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026 at 10:48=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> On Tue, May 05, 2026 at 11:22:13AM +0200, Arnd Bergmann wrote:
> > On Tue, May 5, 2026, at 10:54, Rosen Penev wrote:
> > > On Tue, May 5, 2026 at 1:29=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> =
wrote:
> > >>
> > >> Does this happen with both ld.bfd and ld.lld? Which version of clang
> > >> and lld are you using?
> > > clang version 22.1.3
> > > Target: x86_64-pc-linux-gnu
> > > Thread model: posix
> > > InstalledDir: /usr/bin
> > >
> > > lld the same.
> >
> > Ok. I've tried to reproduce this with Nathan's llvm-22.1.3 build
> > from https://mirrors.edge.kernel.org/pub/tools/llvm/, but don't
> > see this problem on mips defconfig. Are you using a particular
> > configuration, or do you see this on every build?
>
> This is just the same old integrated assembler vs. recordmcount bug:
>
>   https://github.com/ClangBuiltLinux/linux/issues/981
>   https://github.com/ClangBuiltLinux/linux/issues/1830
>
> It requires CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=3Dy with ftrace, which
> MIPS allmodconfig enables. PowerPC worked around this in commit
> f8b2336f15f3 ("powerpc: Avoid dead code/data elimination when using
> recordmcount"). Maybe something along the same lines should be done for
> MIPS.
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -82,7 +82,7 @@ config MIPS
        select HAVE_IRQ_TIME_ACCOUNTING
        select HAVE_KPROBES
        select HAVE_KRETPROBES
-       select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
+       select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if HAVE_OBJTOOL_MCOUNT
        select HAVE_MOD_ARCH_SPECIFIC
        select HAVE_NMI
        select HAVE_PAGE_SIZE_4KB if !CPU_LOONGSON2EF && !CPU_LOONGSON64

fixes it. I see master has a different line for powerpc. I defer to
the experts on this.
>
> Cheers,
> Nathan

