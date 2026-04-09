Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E319DF364B8
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AA96B0089; Thu,  9 Apr 2026 16:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571BE6B008A; Thu,  9 Apr 2026 16:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487D06B008C; Thu,  9 Apr 2026 16:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38B6A6B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:19:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E39D2B6C9E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:19:49 +0000 (UTC)
X-FDA: 84640133298.25.E367543
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id BADCE1C000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:19:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bYxT9OXI;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of elver@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775765987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8yxp814R8LsOCbjv5Tx3ImzbZaJM5uPFtadcPgr4Gc=;
	b=r61Aet6fHXV2UjX6vGwEBXE9fN/pegkWukhodujWQPJst/JJxO6xG5Er9al40yw/TK1yJG
	RLLZQ9o3WaJRrsflLzwKopkEJ2/DffUEJCgeLTZ0AVOMqb1Xn+nWDzp2p0DMoqStrYfSNs
	y8KVpBbwemyhuBnmxndbbTDJTVOmhdw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775765987; a=rsa-sha256;
	cv=pass;
	b=rUPwDY2kI80+CSRDVtSqCKUzYx5b8CQpOMkbwfhs6Iy9vSb6GvknqS/pnogCPb0dsQgC8O
	30cM0UkjY10S8He9ZZAdDPajNiJayZS69QJ58BerAY9gFdXbpeF+GCw0qH893qtPMVnxRw
	ke/ojsczsxoSx/5clFY8NpGDlbc1Ym0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bYxT9OXI;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of elver@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1273349c56bso1791984c88.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 13:19:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775765986; cv=none;
        d=google.com; s=arc-20240605;
        b=STjltuR90hyLSEb6cOqiZtU+xOAEiBUVxV4pmtujFKlkN1zjYy4t3MkfFdj13w+0zv
         DzkdMTsXPTMe5VGZtQAavZqfn7yk3Z0Cq3gqWkW/XNDVawB4qfA2VZPtB7QprBLlNHTk
         90rculRRVPN8Ix1tcb7k5F+rXU1726qe6lBmw7CPhYpgizQK5sSi++gEiDbVCRm5MkKn
         6hHWcS9cPReae/aUeHj1xwZ6Udgy+LO7M6BWQEOajQQkQ/w0HNroX+Uw63EXv8lhCEvD
         FmJHQ3ewAX23Y7ja45NbXgqS34guSUREcDUdSLCUeYVAMnUfVamvLxwGOrfccFj3Qskv
         nP2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=G8yxp814R8LsOCbjv5Tx3ImzbZaJM5uPFtadcPgr4Gc=;
        fh=IWtx+Ct75gzjlc33GGftyQDjEgCLQSt5xq8kaOszwK0=;
        b=ajv/CRr8E/G12/xAAAVySmXORPKHuz3ldTxk5Kx3BrV7qaISpqQuYFWkkn9UXP3c5B
         kip+O8zMXzIhgxY63/shS1OrhF1LLHrGCNHIu4dC15ADu/K88ugXSzKWyzBBYfBLSzh+
         gpl8dZNy3U7JJT6QYVfw5OESYQK2KabMssAlnVdckJFh5S8kMLCFN02yLd0GP22GsR0I
         y1R7sh+QDVCkFPB3+Wtjn9D2T8lBSm/UuAaF3gUGHSh6ZBCqlU4C4ZhG3zdJB1k9gqSq
         nb1jGRtnsryNvrxpOeXy/JvA2qN956C2gAFSdiRg0nFOLgZfZlQYBT7mUJaGfiyh0meM
         KAfw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775765986; x=1776370786; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G8yxp814R8LsOCbjv5Tx3ImzbZaJM5uPFtadcPgr4Gc=;
        b=bYxT9OXI7ddgXTUQuMez8JH11fZ2yzkrkg1XdPa5r7gjUY5BnHKvpkD9iUXAMPoXpg
         0x+G2q8TdL/yIcG6AEemm8K0/GA7TjbFU5eQ8L3nHxIGvyxSDnRoJW4atRsKuUm2vq60
         fygt6jGsNLFCfZZn0xNIwodPbwmF1BYQ1xBqOB5I8lbz2xiC+7h0F9t08yzDwirBj33f
         MZBAkc//c8NyLtvK/+gxoNfNYPwat+u4tw3Cl1rk0R/SyktYcFmlQUU6ZflkR8+0KPfr
         Ea3mGJiTiKcaAx8H9RiXwvfYPOAkj/O27ydMUfljAUUGEQ2zcR809KLZI5WPQWlzkQgE
         8+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775765986; x=1776370786;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8yxp814R8LsOCbjv5Tx3ImzbZaJM5uPFtadcPgr4Gc=;
        b=aBwnAOXAYtVIExHi+AjCSA3iJFiTRG72Hlh5VwlqvyCvXfu4ZAq+QONDDI3JR8vLVA
         NqZKqKm4gQ+m/P/Lxz5tUwBQdarQl/a9lA43MD/dAK22Sib82yGVWpUFwXi7TKBqPSyR
         8cFKt+h+eOCThxNGochrOWFt/QP2Jrt36iYMwcO70PxbWTBEXDDqKtWFWrvq6zI3iun4
         WhnrD754f/Ur38L9icTybaAsc4cGQr7Yn0GnAFq51W3R0K6G4xw/wHghwVbj+tfgfUD+
         MbC/cG1xV85tmIxLGZ5kAT4tvEZ3pxPvkwTTUaLrMMoL7xEmiA77Qgi0qsBYFsN55VLK
         Tj6A==
X-Forwarded-Encrypted: i=1; AJvYcCVkT19UQR9jjvJ/Uo0GpxsKOtMcuuNPQsrTnAaV4qnLtjYaz3t6NjGXW2y8AcpTUL17OechFitLRg==@kvack.org
X-Gm-Message-State: AOJu0Yz9AUbuA5lif8MPjAyGh/ZIpaxZUSv8J8e5nfBYMb59V/Rtz3Be
	xFxgGqns24m8b4PXjv4KtvJCDd9atsdKJRnPL32sI1DBibTQP2fEyMjO87qjOWMyaQC+7sPDdFN
	EZjtcQt4f1mSasKtBAIeBelGwoqIqPLbuisYjUXps
X-Gm-Gg: AeBDievKrjGpzIvVweKyb1i51uj7RGIbAmvLLd7XCMP/mxf+SvO84r3xZkV4kkOsYe3
	FK6gVDErtOUpoDk2oceAQ/Dz88cHhivuBGi6I0TZocYfASBGVKiuRW8ZNCVSuNW2KbkKFg6Muox
	XVVw/Ub2BQteXmf/1hnZh9nU+UVNbd0cLdvx3kOaK72VaVxSKdj6xpXf9vFocb4OAaJMe41MDXR
	uIH65lDzjJBM0gg3t6pRe+Cjxf9Cq57SUHhWuN0G2vE3QjU1s6zyC2hfU/x0n0txLEedyon7MTQ
	ugvPfDx6gpiAhzpVANBx4BNxGG94jz9o3jgiKhvuVUnHBaGx
X-Received: by 2002:a05:7022:ff43:b0:128:d1c9:3633 with SMTP id
 a92af1059eb24-12c34ea93bamr326968c88.13.1775765985689; Thu, 09 Apr 2026
 13:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260331111240.153913-1-elver@google.com> <ac9d5O5XehnXRc5A@hyeyoo>
 <d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@kernel.org> <adM2XVZf1DekahlY@hyeyoo>
 <CANpmjNMeaWWuDMAj_n38U9XRqgZQz30ca82Vy10Bg=NoDfZ5ng@mail.gmail.com> <adT-gkVmVDDXR1h_@hyeyoo>
In-Reply-To: <adT-gkVmVDDXR1h_@hyeyoo>
From: Marco Elver <elver@google.com>
Date: Thu, 9 Apr 2026 22:19:09 +0200
X-Gm-Features: AQROBzARAi5e7VBJC9ZT2jVCPDAMFQKWBBwNXJCnP3Ii1ddqjsxmVTwsC-HQUUI
Message-ID: <CANpmjNO1aNm3mKphDGWasK_NUfVY8q4K9GCjyREZFqrOu9WLcw@mail.gmail.com>
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
X-Rspamd-Queue-Id: BADCE1C000E
X-Stat-Signature: wg7pdn5yzstih4i6rxmpx1ygnt7wiyki
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775765987-474898
X-HE-Meta: U2FsdGVkX1/XDuAf4JQtw3prbX/LYQvOptXg9RY/btDjQQThK8AGaTiEm0zo/BBlRARUauSAaskYcXe9LhPtVzlmrXkjcz6ZnNTCF+BSC19uS+caGmu93ftrxX4lUYblXAjg7Nd/PcnxAMY+hqylTbRD/vbMVOey1FzfSA5A8ah2sTJybtDMG93CkjuWrS/ZXkFzP/m5hegPLWN5RZFUof2UgEK70WU2EwWqXjxyKJsb4P64bpf+YHYGVET6OXzFw71kcgS+f8AnzKn/CWx000ftzotsVelyTn80YJIoFM6xzS/3TlpMpwx9LXHNHbV2IDkfH4aWCN7i5ZQGJlkUbWRseMROJHlBzqvb/KRTawq37MGwO/LPl9cMZrA1MPUxJbbfiii1v0l9QNwcjTCJ757f18jJYgQUmJfdFnupWshhF3BLk77ogCQ9PyN3uMo9787P/X2c5c02jMDpXzqWdhQB1Y5Os3OdtGjKFeCgubXFDOtWp5SSbUAQSbN6qFfdfijPEba4Yl8T5SrYXflEEVaAqz+OBghWbl2bhmjAAUB/GmnCrR4SgDKx+yx1YprYAS//gH0sf/j47q388+wfEzXylhcw5nztfDlRsXV5rtnESt5hjUBkscuSniE6VJyaZBG41yNPPz6h6hNh1zG3WK5Gb73PFGhlcajiBt5xQ6Xe94/GxcOLa48J8hmKebRB9ZOtm9ZtDOHITAcsiK5IcW+oXSSz/MfIc0niQMubXI0pnsPhNEkqYkyQ7hs/GHTCQ2kEF41PK3eobgJmjMLZC8LQ726nZL4nD6TRLlKJkAI55oYng/HwvCv/s9OsoDnOxWB4qt7wv0YsJehhwWTKdTCk/NCRD62EiKgNYLOQ0/La4f4SnwEyWvw59sYsJhti4UR1b42KlBhvxOAAbYjdTLZ29IhVHHhCDnxuHBUUepLQntw+Ip822TxkF5YCtPplmRtJKeHwijqJT71oc1z
 GiKbqw69
 PixHxs/bi3BI8DiI0UacJyQWX6Ull/FlEtgzBJ6MWAnTpNO97IXHFfovHxW0ZYj6Sy0BauIpLGHzHd5TwP6v6yDVwkuMjh8dGQd1WbVftLFxpbUnReSMUYjVp9MNQpkr5KoZJydJDw6El6vru66TBJ3tSyGD+OctRH7feO5bO6tbvkf1Sr3opJ9vqTKe4NFfoOdq7+/UKf2UfbERJ9NLAcOR5e3+Jjtuvlb/pjRiQQoL8lNPo6fn1RJAUdBj9/PnO3y/cdvolR+IfFAzqUMNcJLk/DyS5xV9xP2qurVtg3ypIs7qaIfF7M1h0a1dOGc2bmxreHjB63kjdAjUJtGxA2LiiZocFGJpxa6KMokmMkbrjS7+aiPLHdu24+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Apr 2026 at 14:54, 'Harry Yoo (Oracle)' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On Tue, Apr 07, 2026 at 01:17:14PM +0200, Marco Elver wrote:
> > On Mon, 6 Apr 2026 at 06:28, 'Harry Yoo (Oracle)' via kasan-dev
> > <kasan-dev@googlegroups.com> wrote:
> > > On Fri, Apr 03, 2026 at 08:29:22PM +0200, Vlastimil Babka (SUSE) wrote:
> > > > On 4/3/26 08:27, Harry Yoo (Oracle) wrote:
> > > > >> diff --git a/include/linux/slab.h b/include/linux/slab.h
> > > > >> index 15a60b501b95..c0bf00ee6025 100644
> > > > >> --- a/include/linux/slab.h
> > > > >> +++ b/include/linux/slab.h
> > > > >> @@ -864,10 +877,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
> > > > >>   * with the exception of kunit tests
> > > > >>   */
> > > > >>
> > > > >> -void *__kmalloc_noprof(size_t size, gfp_t flags)
> > > > >> +void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
> > > > >>                            __assume_kmalloc_alignment __alloc_size(1);
> > > > >>
> > > > >> -void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> > > > >> +void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
> > > > >>                            __assume_kmalloc_alignment __alloc_size(1);
> > > > >
> > > > > So the @token parameter is unused when CONFIG_PARTITION_KMALLOC_CACHES is
> > > > > disabled but still increases the kernel size by a few kilobytes...
> > > > > but yeah I'm not sure if we can get avoid it without hurting readability.
> > > > >
> > > > > Just saying. (does anybody care?)
> > > >
> > > > Well we did care enough with CONFIG_SLAB_BUCKETS to hide the unused param
> > > > using DECL_BUCKET_PARAMS(),
> > >
> > > Hmm yeah.
> > >
> > > I wasn't sure if we could do this without hurting readability,
> > > but perhaps we could...
> > >
> > > > so maybe extend that idea?
> > > > I think it's not just kernel size, but increased register pressure etc.
> >
> > I'll take a closer look at generated code.
>
> > In some cases the compiler ought to omit zero-sized arguments,
>
> Oh, didn't know that was a thing.

So I checked with Clang and GCC. Looks like Clang does omit the
zero-sized struct argument, i.e. generated code is identical to
before. Whereas GCC wastes a few bytes of stack space at callsites.

Which is sad, because that means we need the macro workaround.

Do you want to be credited with Co-authored-by - in which case I need
your Signed-off-by.

> Not sure if it's safe to do that for exported functions though (since
> modules can be built w/ a different compiler).

Kernel modules built with a different config (implicit if different
compiler) are not supported, and never have been. If it works, it's
just luck (I know people do this, but it's just a disaster waiting to
happen).

Thanks,
-- Marco

