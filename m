Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B5D7E9905D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CFB66B0005; Fri, 10 Apr 2026 05:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780206B0089; Fri, 10 Apr 2026 05:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F6C6B008A; Fri, 10 Apr 2026 05:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 540D46B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:10:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3834C1C83
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:10:49 +0000 (UTC)
X-FDA: 84642076218.27.BF2110B
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1540120010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:10:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IuJKJYxn;
	spf=pass (imf29.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775812247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naitCC6swSoBy1VNvSZ66ZypJ+ORfAmYMB1nrf5YPCM=;
	b=FRSIY2RyWX8PkO8peCa9SBghYRdcOyNsFWVlxAcucWQ5BAh2lXyE70eqRF/zxvXMZXfOhn
	aWiIPywjt5kUxFyz63YgEGpcI2u7eZu7TxKmI4xAURB/LeqUqqIgD0NU3zHrV6cLBMeL34
	LYhlwWAuZiVtda7YgEifmt+npD56zdY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IuJKJYxn;
	spf=pass (imf29.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775812247; a=rsa-sha256;
	cv=pass;
	b=4hqF2AByUbZ3Y0RuOJAC+Cb0aXwxDlWqb2fop/kWc6hYL3o3fu1ZjPKlTsY6oQD8bJhiKX
	mzLC4iQJkwWKjaRfDg4zDsIaDN8PrPdUQfDYvC1IGzxCAcMsNGk2lymNXabpMuIKkDKy+a
	UY9oeh46UnAQmOrxO9vbcOro/o0iYbw=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-128e4d0cc48so9136865c88.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:10:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775812246; cv=none;
        d=google.com; s=arc-20240605;
        b=CL03JkGngXoYZg5JBtUfuL5+EtPv/agU5jxQ0uLGFhls79LkQ0HpeRceg0f81Gomnz
         GP8Jh6bgnhnc7a+ZprVhdTtR1CByQPei0/V380F6JI5cCL4Gjc7BHkwNVBXiY/31u8ue
         WjyI5Z65fEaYjIuMISRvURtD/+9mLZwtd9U5uMFdiXCbCvORW8WaQjzNJ5yqdZzq4UwS
         bDcG1S4vM9AvcXMSx64YJ5mO59ZeAbCZoFBJyICbIUcbfWST8eKckQgYNCK1OqhjU6aq
         KQDnkalNFqCegXHEGjDUMF1i5DwEBXC2gUAY+RbycwlapPelduoqCsy05e4y4CGiQ/pq
         +nqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=naitCC6swSoBy1VNvSZ66ZypJ+ORfAmYMB1nrf5YPCM=;
        fh=jiqFufJQGYx6w2x3aWCZKfjrj2/7cCRfEZX5ik1rQ6g=;
        b=QA4auJmQqkbvWPUJOE5yFO6cw3XCXlcXWzz/c+120Vbn/9/vlwrQ1zKlxxu1YqsgXS
         y5r2x5dt3HnfD25Kjqv+UZa9C6G6R7GK8Pt57ogtTj0m0t9wmxDc5dQ/GpSV5k7uI013
         mtQDNEKOjgQn4K7/n/QRly8pb9Mwg9gBLFxz7etH8euvaYQD7m1OzfuMtOa9GudziXlC
         O6nhjrupX8EFCgDXssFMVTbSpcFg/6KNKK+UkMaBFhaZ+HgMz8V307PklyHxmyuxivHn
         Hm71eWMj1+i2sfpvEead4J64GCMQBuGI/wy04zHPkN98RFrU9zjXAZzdQE1Q3L1HeRfN
         GYVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775812246; x=1776417046; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=naitCC6swSoBy1VNvSZ66ZypJ+ORfAmYMB1nrf5YPCM=;
        b=IuJKJYxnn33cLQnmgDurGOywt9i/riIt2AOlYKCC7Vbel/MnBYw+Fd3SIEVE45xsJa
         X4l7ZPwY89R5QJFlhxqx7hiVz3Z/nE9m+ApvlMhu2ouYMUSO3/QYQGcc4m6Yk+YEt7e5
         GP6ZG6bS2vDDEc7UEnEmSQ2l0F45+oUoO+sS0IMWE3E7YVZmJ9eAfNbsMuQYY1fcJfa3
         NDMOopcw6JUR1fTzzKYi44QjBkdEadM2AIg6pyFXazHrc/0pVkUaRZ4YXo5SDIFgQJ6n
         ZbcUhEA3ZtlNp/cRtpkyXSm69IwBsHrmRY51A4hoIkPIFcFqxrZBJI2t2Too8xV1qk8u
         kvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775812246; x=1776417046;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=naitCC6swSoBy1VNvSZ66ZypJ+ORfAmYMB1nrf5YPCM=;
        b=I4eg6uHw1vQyqyUJ+7oeQnxxl0pGAfsCrRq6sItfTcJLyOImJnz9ip8aERV6I7xJyl
         1M+n9qgPUptNVKHCnMqqcAcgOAOaiYrQoqw7rK8oE6RVapt1Srh4LOlG9UjUH5y4wAjE
         t/l9lDmnWzZsK69rGYoAHNHq6mPIHcu4BZnwssT+k0dyPJAJuIP5A2zl+LSFmoj8LVv4
         XtyIu/kqqwSWHszOHJZOK+EPRq0GGnEuHuinwLKKNTS5VVeIwJ2YwMYqzgjM1vjt0anT
         kwFwlRhxaLs3DOL4LjGzZOUEm3oXeBLgiIAwMZlf2QcquSvKbOTQaUqAxEGdTtQC2Ays
         d5Bw==
X-Forwarded-Encrypted: i=1; AJvYcCXqSgwl/ch/zwabt4oVxetlNWty7NcwHLcUr2RkzAbKUsxPXre2k1o8pjBCVyYXkoKLXe0WUaRDUg==@kvack.org
X-Gm-Message-State: AOJu0YxvfyGzYnQ8nDDVvxMN055ISLffBbXkOahgbyu0aIxBpLMIpPMn
	xRP9uTw0A6y+0KBIunghNN3VAOlgqvGkccu6oKAwo6AoRDH71xpC7GGrMM83ESBMMncIv2V99TB
	R6fnRLe5FRajn3iTgQnGe3sZTTUVJB7brRAPhMtny
X-Gm-Gg: AeBDietF3Fn+fVZ8lwXXNp6pTgo1HDGHFtYrDY0TsooHjToG6wIvNFBPFXMT8UFHPTh
	p750ZdAOKyl4aPlPOCMhaO85YdI51nOSIKSSEg+J2rsIuiPs+fmcps1XXde2L5WEd7keXBv20EC
	qwAZrnEqDh0o7CvzBOPzsElbbNHLo1/8RqrgworleyKFFyPVqDeoWYjxWtymtSYZ+NvL6YOn+OB
	J5ObqvEWPcze750tM9zqpkmSBMw+2mDLetLK94tNcABnMAFXGfY5pByPsSgW+uh5O4mZV9x9BEy
	bn79IUeFF07qttiwXjLTRLxA3xtszW5kmYMja4R/jdlZXtzu
X-Received: by 2002:a05:7022:250d:b0:11b:b3a1:714a with SMTP id
 a92af1059eb24-12c34e8f8a4mr1549057c88.12.1775812245709; Fri, 10 Apr 2026
 02:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260331111240.153913-1-elver@google.com> <ac9d5O5XehnXRc5A@hyeyoo>
 <d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@kernel.org> <adM2XVZf1DekahlY@hyeyoo>
 <CANpmjNMeaWWuDMAj_n38U9XRqgZQz30ca82Vy10Bg=NoDfZ5ng@mail.gmail.com>
 <adT-gkVmVDDXR1h_@hyeyoo> <CANpmjNO1aNm3mKphDGWasK_NUfVY8q4K9GCjyREZFqrOu9WLcw@mail.gmail.com>
 <adhcKZGytWdaLxJu@hyeyoo>
In-Reply-To: <adhcKZGytWdaLxJu@hyeyoo>
From: Marco Elver <elver@google.com>
Date: Fri, 10 Apr 2026 11:10:07 +0200
X-Gm-Features: AQROBzC2BBHkcPy4ngHl5oxQazFqhMF2xdQ6OJLOxqq2BaVLmQUNSpLtUA2DJOM
Message-ID: <CANpmjNODn64zxhs8eQM5t_y6GUCbvBK+feAAM6GVDX3-Z8aTGg@mail.gmail.com>
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>, 
	Florent Revest <revest@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>, 
	Matteo Rizzo <matteorizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1540120010
X-Stat-Signature: 3kaieebkxojawx7r7kb49dkso5sgkju8
X-Rspam-User: 
X-HE-Tag: 1775812247-996610
X-HE-Meta: U2FsdGVkX19iBiePOCUmZpX6Dn7AR1k16r3qC71kaBK8nqiuCsjc6U6lczYhpk230t/bA5vA0DSKJtTzNn+RJS852FCExlYJE+4NSC+klqusZ6LSEYVH5VU/qZIJzf9DBaoduI3i9J1IXMUda+Df1ZMp3t2r0j2myFqFV6ODtg45MffbIyP+AkJzJq0CcCUkLYfyYF1TAOlqxNVMkVNvQ/AJqNLhO8OyvQNIC4GhyG1fW6RkSNfTGUFmrroE+r3IhkpFVfW3JvZIvpwSELFhKnjXHQodRzbxNMT/odKbu5Y3py5rGSICECd0CM2klUiScxdJo3eczdQz1KPPqQ+pBuTaWB5TUhX8gsf3Cg830n9CipUYr1C3aKxdlOp/jPYfvD+6OuST/d6c+hSa3zQ+yMDxEGpY3QwV5AAiAbbPudBYPifvCisgYzDPaKkaHIHRA/CMpR7TeCLNqpK9n6uHRSVPU2fmpMrVpbtblUuydtl+bhVgJQpZtd2fjEfxlWBDeTtVqlqIBEaIPwHrZy2a7QauJ7Dhn612l88d8vvv6+k1Q3UNe8VBdIqM/FOg8r5HjbQK4meefjAJrPZZMkFqEXpEumAxnMCvvdMvc6hC8RBbQ2cgvAYYsBb7nP+X3e/IGdlgLRR/Zyjq7axDDzAEFOMfvqg/99HIcH2oqx+vUYz4l1mSK7wfC0AFfsG1HUDXyZiRfIWzZWF9GZygJFFRT3ooBNaTxeQNBky/BSTb7mQzK8DUfqjKLkb+9sHfqXLoaawV75DfhLn51CB8yQ3ak7529biZibxFhx7gq/epNLmmjUJNyGImrRgrWNPrIL8y31QNbMORxOC0aEKhhtx4iOUF4xMv3B4T2DfMN4rdNQ/KvtxECUj3SZBgW5G9sfP/j47nh8ktr1q4FteyCfHkmvaIQF/A3yCMdABL2tczLA1lPYJNPHk0AClPvo5QdvBwimsEAkz9+QdEdBSJVr3
 jJvE8jdm
 mIpdBuc4964hpvthvDUOt/t1QgM6reNz3f2pkT9Capv3QFXQqH98WXKrJDKO5WS+HzK6A0OWl4zebMlNSzIlDLXFundedMn2x/dZUfkBuP18PMVYcVfCQpNk6CH62iNP10QMfaUqNgne2hanaTAUmvwNXBWBj9FwU7akKxQ1iZEN2dXyLRHncREoPaVM7FmG41X4fWRCAnj1gnI6RL/RzSFSG1y4EUen3UnnWhqiCXXc2Fpx84L25HQO3U05ojWJkXEiYewBDz34rb6DbYWTa6ijTQvUZELA1b/rQkLByNiOQku2la6/bBHcxGgMsrdknh7U/Pi3Y3q3KJZpQ/ZSni4Odvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 at 04:10, Harry Yoo (Oracle) <harry@kernel.org> wrote:
[...]
> > Which is sad, because that means we need the macro workaround.
> >
> > Do you want to be credited with Co-authored-by
>
> I'd appreciate that. (I guess you meant Co-developed-by)

Thanks (and yes).

> > - in which case I need your Signed-off-by.
>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>
> > > Not sure if it's safe to do that for exported functions though (since
> > > modules can be built w/ a different compiler).
> >
> > Kernel modules built with a different config (implicit if different
> > compiler) are not supported, and never have been. If it works, it's
> > just luck (I know people do this, but it's just a disaster waiting to
> > happen).
>
> And if GCC folks somehow fix this at some point, even kernel modules
> built with a different version of GCC might not be supported?

Yes, and different compiler version also implies different compiler
(so even GCC A.B != GCC X.Y), because newer compiler versions may
activate different codegen options (some of which we auto-enable if
available).

