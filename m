Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C6B606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=cmTUOKTO
Received: by kanga.kvack.org (Postfix)
	id EE52E6B05B0; Thu,  5 Nov 2026 06:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96E86B05B1; Thu,  5 Nov 2026 06:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85796B05B2; Thu,  5 Nov 2026 06:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A32846B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:09:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41774409DD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:09:42 +0000 (UTC)
X-FDA: 85400795004.01.9A7D63C
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5A5F2A0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:09:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cmTUOKTO;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793876980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLxUrhb+i0y7kx7MWfP3g7AgEu7tvuVh8LKyS1nXFQo=;
	b=0NXY738VW6UBrqhFXDrSnQx2uOIPV+hDOQkhp3FkTsa+nMTMg/Tipq0vQJ2/ng6lkQs/1/
	O8qHPjEi9D17eeh6CBkgAuSjkOWwAX/Xk/o7mwl7Spff9qxb7OUuhdr1TbVOgrACsyMKJa
	BTGTGrPbCdXh3PmNBPOBLikEfGakJyA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793876980;
	b=CYblTqPrnfl/QcXmufHZx2a2sqpOIGd2nVrGPFfuR01Zq3DqkSGTBBS+zsSqw9bX5aBAQq
	9ioe17m/0Zg8BdGjHx/n3gAcF4Bs33jmw5ORPM7/MfjfZV2gkIkNprycS9VUYkbB++ulhL
	Bm3bbVOU4UKF1vU9Z9emghMaED3EyRU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cmTUOKTO;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1438d9363fbso459076c88.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 03:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793876979; x=1794481779; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NLxUrhb+i0y7kx7MWfP3g7AgEu7tvuVh8LKyS1nXFQo=;
        b=cmTUOKTOiEyvF/P/1Nt/iMZs6itgc3/aXvv2a0HddwmHtLnI2D6vp2tx3/yNWRv25W
         oX40t2ZJXGPRQXKZhFjMm5rw22JdeXZqMFcgke5QDEjmHo+WAiSk5xGKk70rqCiCd4Yc
         +BRBpK8JtMSMe2hY9lufUHn86Gn1ySf7GWCIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793876979; x=1794481779;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NLxUrhb+i0y7kx7MWfP3g7AgEu7tvuVh8LKyS1nXFQo=;
        b=UaJM04dTmB0AK2z6Fg8427r/0jxBPJc0EZIS5CdMg3HmaFPYl4u4qgnyZhB8ys1saT
         /Y5z6Dix+7+URZvBmhEAky6PTUdCzKIBVLrIennyK15pNFSQh5ClbySRAquS9QhOdCUu
         yKx0w0sC5UhObmpaaV+Lt9NB9aGm0vHMR/l6IXGXCYiwhct2QJqla0vtDc+n05odm9e4
         mhaVWIX9e8QX+Tb8DHSYOLXmaLaaOj3jK/S8r77E86lGFMGFFUQ2fYU00THxXqEHCZ+B
         IGZrbr5cJ89+4VP7Htodjx4ExmABkT9bERL2SXS9WgWTHfWsBp2ylXsbF4IPXJ9cK1HY
         MDww==
X-Forwarded-Encrypted: i=1; AKwUvByt65eCbINFFmA9FY2c8eDaQ+C9V0JzfrWIlygF+c0NcYTU9wxS98bEeV7ULvg90SWS1TuRGfQTwA==@kvack.org
X-Gm-Message-State: APuU4Z/2y6aer3jaer8QILl9ssr/lZoTm3r5xXE20iMWXAQb8fR9dtcd
	juyR6vOIKCI7XiPRl+c2pSL316A15cLilG+Fe4aBPUHMFKhGb0tx+v1HTct/iYEkEoc7ZyIKXu6
	605Q=
X-Gm-Gg: AYBFou0ZnlvRwhbJCa5LA7szmDVAUo1PgWroi+fS12rXmKFUVrpb/t1XuYxtZ1Z0ANN
	iQkFCKzSNBZzHQX9BSdcb7cyPcw8S2LDRukkRjG95wbXivyU5cTa21Wwu4MVfSVtAu/0Y2kpRz4
	ZfCYGO3KVCOhe9a5rb8noSDtrFfcl6FZLPsVuIgmwV//+/c3Qe83OW2IMNjqnfDgmhwCBPeENVE
	/IxqKdbj1wSeUYxEUUZ4igLBwzu0zXS8q+pdmGpOtzohnerR6N5oIAGu+xd0fkfAsNhREKLGcnN
	g/UGR92qE59kJVjFW1WyWF92RJLfg1ssCwidglDpiVLAFkSdYv3GNXbk/P+IrwGWbusRShaBFpz
	mcGo0pTlP8uppBUS1NtgRJkn511SdIse8b6Z73Jjgq7ZdVolhtzXeTeiwuqy95GdqS5H01aN/SV
	YubHPQIZeu3n1o3aRi/o4NY1f3TOwLQsZgdY8PoEUIROEfbUiEHfhtk2NfLs/dQU6MZzuD3zQp8
	0SFsvTHVOIhEQ7zG3EahJstymwBcckjZK33ylKCxa8LbjOmzbczkExtofDf8tIK8YeqsZcjyac3
	BabSL8mIe/lwneANKxE0Lt8ElR/sn+ZdH/1Zx9zmE49rcZe8GWFgT5tshlV100UlCjg=
X-Received: by 2002:a05:7022:5e08:b0:1b2:42db:8a5d with SMTP id a92af1059eb24-1b24f42dcf9mr2938410c88.3.1793876978922;
        Thu, 05 Nov 2026 03:09:38 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:8bc:6b25:484c:8975])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b8822fsm18931590c88.2.2026.11.05.03.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 03:09:38 -0800 (PST)
Date: Thu, 5 Nov 2026 20:09:34 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Jenhao Chen <jenhaochen@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, minchan@google.com, liumartin@google.com, 
	benwei@google.com
Subject: Re: [PATCH] mm/zsmalloc: inline obj_malloc() and obj_free()
Message-ID: <auxjJapQ4j8518aH@google.com>
References: <20261030121700.260975-1-jenhaochen@google.com>
 <auwR7gnuLsF0lpmG@google.com>
 <20261105103947.7521-1-jenhaochen@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105103947.7521-1-jenhaochen@google.com>
X-Stat-Signature: xzmhrxujpp6onhze63kmn6e1g5fbin31
X-Rspamd-Queue-Id: 5A5F2A0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793876980-144824
X-HE-Meta: U2FsdGVkX1+jtxb//gFfxnQ+na8r5f4IHpgmLMNzKJzv52+d1jOMLKec6BudIeJrpqBRlRehGSgKRQ5KMWSrehVB9SNA78K+IZaa3/zokO1gafY4uN39IP289z2NpXP8lZHVG0ZNQn56KE7q3YrYiHqQHruQwvovrWUcI+FvAQ4ymVAr4rxEuhl0cH9EVphTCDIh86TRgM25/li+8BNu5w0I3akpl/uRYATGgI2bYdwVmNbJfF+6LfH9PAUria2lEkYnOdkh8yUvb68R27sMjRdiIei3+tfzBp/B9+TD99OG6AY94wO4/DuThjpnRVvQSUUlhiGqDxbWa89byJ7S4R7LmeRgNODhjRnBFwgGI2Jw8WHm5xPs11BJYHecV8VqO28jL/qndXE7eeRbeGXfZbYMzRG50cEj79EWE8DvqFOJh+QhCUWOEnYFuMufDaPt5wkvkGsZjTn7GgOQYRPYxcf990n2lzvrdQA/vasnqD9JxVuZDniEQpNTwo2hPgUJZ1NZ3FCEtWHlSxM/Y3iTCP4f16JCC5yTcyLXOHv9T0Jem2H7Elbv3izm16CBn3HHH+uM2zdGkUGswVHHTKonG9zfAQwzzpNkQnq77YywGEMSUj24K8101pJV7MMjBRaQ8pnYKSk5EOTVbA2U3+evfuYjKyvcMLrr0iC0EVDeRjdDDefyQsgihrtGBePVbKak8SeUVE5Su240daf9f970Cgg+9W9M3x6yVmVNoQNvbbLPaQ+OFbUsiB61DpL1P/+bZRE7AUIvCg3aPEGjfW/2n9CU0+cl4Ux5DAW0kNfZtz0PzWtmyZOk79+GlwmQYS5MXt9MXqOpcoL/bz0M5S9z9XDtU+eXK7zdiEUQa+md7sVmysIFiPqErDneF0qGB/uDg6UDjeKrpoB0n90YMi6WmCcdBls+nNONs8jz5XMYPd2LHoAA+cUNOZMbo+AFUhimzC50c6zWBboir4LX7oA
 v4M2N9e2
 xm74zy2Xs3DdLWK9kuSZCg+ZT2ss2wFmUMT58TbYTVlB7wALJpiDE47L2S7Mqny89OKMZai6MTh/iBVsN3Lfh2gXMMkXZOqEbHxgsRFHdlHsyOZRFXUa7BiZX5bmqZ8+1znmWS7MNM4DpB+84WWXzPbPzbsnZxZR84t7XhkQ95AQIwQdQtUdP7QzXIrX7e4MsQU+V8Dfrxjg42DOBJKS0i+zvlTptO1RQ+Q7PegOlmxi/qbuPfeunRcRLXoQUmJ8TaNBgGotEk2s2aGZdz2x8d9PVzzEINtQRoN0LbEp9gp9JDbSpZMt3QHggr3bsU32tzzAoFHbxt7f8/KmUgYA8f9oZ999uDKg2HxIAXNMuc/iHXm17obukk0kDoWToi2zX8FgIeNp20M1R/FPwGDimHPj+9xL7BuDVeyYBusb/8Tgv0wRrxyhM90JvnObpt+hEuu53qTUEpvm/jWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 10:39), Jenhao Chen wrote:
> On (26/11/05 14:23), Sergey Senozhatsky wrote:
> > I suppose there is performance benefit?
> > 
> > I guess I don't mind in principle, one thing to note is that this conflicts
> > with [1].
> > 
> > [1] https://lore.kernel.org/linux-kernel/20261105044752.1997895-1-senozhatsky@chromium.org
> 
> Hi Sergey,

Hello,

> Yes -- in a steady-state microbenchmark of paired alloc+write and free
> operations across 8 compressed object size classes (384..3136 B):
> 
> 1. On current mm-new (zs_malloc + zs_obj_write + zs_free):
>    - Clang 22 -O2: -7.7 (arm64) / -11.8 (x86_64) retired instructions
>      per pair (-3.2% cycles on x86_64).
>    - Clang 22 -O2 + CONFIG_AUTOFDO_CLANG: -13.0 (arm64) / -17.5 (x86_64)
>      retired instructions per pair (-4.8% cycles on x86_64), while
>      shrinking zs_malloc() from 2,872 B to 1,828 B on arm64 (-36%) and
>      2,088 B to 1,474 B on x86_64 (-29%).
>    - GCC 15 -O2 (x86_64, without AutoFDO): GCC leaves both obj_malloc()
>      (306 B) and obj_free() (120 B) out-of-line while inlining the
>      single-caller slow path alloc_zspage() into zs_malloc(); the patch
>      saves -23.7 retired instructions per pair and shrinks zs_malloc()
>      from 1,738 B to 1,441 B (-17%).

Cool.

> 2. Rebased on top of [1] (zs_store + zs_free):
>    In [PATCH 6/7], the new static obj_write() helper has two call sites
>    in zs_store(), so both Clang 22 -O2 (360 B on arm64, 219 B on x86_64)
>    and GCC 15 -O2 (obj_write.isra.0, 229 B on x86_64) leave obj_write()
>    out-of-line as well. In the zs_store() fast path, obj_malloc() packs
>    (m_zpdesc, obj, zspage->class) via location_to_obj(), and the
>    out-of-line obj_write() immediately unpacks obj_to_location(),
>    recomputes offset_in_page(class->size * obj_idx), and re-checks
>    !ZsHugePage(zspage).
> 
>    If we also mark obj_write() __always_inline alongside obj_malloc()
>    and obj_free() (with noinline on alloc_zspage()), the compiler CSEs
>    those redundant operations across the fast path:
>    - arm64 (Clang 22): -31.3 (-O2, -4.0%) / -34.7 (-O2 + AUTOFDO, -4.5%)
>      retired instructions per zs_store() + zs_free() pair (vs. -8.4 for
>      obj_malloc() alone), shrinking zs_store() under AUTOFDO from
>      3,144 B to 2,448 B (-22%).
>    - x86_64 (Clang 22): -26.6 (-O2) / -31.8 (-O2 + AUTOFDO) retired
>      instructions per pair (~4.0-4.5% latency reduction).
>    - x86_64 (GCC 15 -O2): -37.1 retired instructions (-5.1%) and -5.3%
>      latency (-5.5% cycles) per pair, while keeping zs_store() slightly
>      smaller (1,997 B -> 1,943 B).

Great, I'd love to see that in v2 commit message.

> Would you prefer that I send v2 rebased on top of [1] (including
> __always_inline on obj_write()), or send v2 against current mm-new
> first?

If it doesn't trouble you too much, can we finalize [1] first so then
you can send your patch atop of it?  I can ping you when [1] is done.

