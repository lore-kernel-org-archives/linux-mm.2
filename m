Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 882A4C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43446B00D1; Wed, 21 Jan 2026 12:39:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10706B00D2; Wed, 21 Jan 2026 12:39:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A135C6B00D4; Wed, 21 Jan 2026 12:39:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9846B00D1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:39:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBE2FC2FB7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:39:15 +0000 (UTC)
X-FDA: 84356682270.08.1596EBA
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 02F7E2001D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:39:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LUlBPxKj;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769017154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZPB/nAuSxHMF8z7YKq4XwyLCyx1N2zE8w1NIox3Cbs=;
	b=CYAFxWU8pCMvxvyBKRyxmPn2PivQeqVDggAvVzFXZ20LQS4mYrhkrPFWndILUAIHROiLP/
	zej95tT7GL7ppuKq9dv9tHmmtDXYW/XDOdrHwo0bXd0krVkjJKzUmriEAK5Ui0t+5r2+yF
	YtcoC74iUn8WYkMUlghIOm0grNXTCtE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LUlBPxKj;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769017154; a=rsa-sha256;
	cv=pass;
	b=4pOqQ9KsmeGtRqRNL5zzbVzPyPsrhRCqM8nteu74Mh5Yk3x7AgRjV5fY5dj2+jb0Nz4bKX
	TDSAracfHkHIAszqR/AnUd2tQfG/EjcSrq4hGrM4FWsxTk7L2PnEjYGQ8Z90j9e85ggtzH
	xfiXCe/n/DJz1IOkRVUAwlXZAosf5vc=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5014acad6f2so144431cf.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:39:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769017153; cv=none;
        d=google.com; s=arc-20240605;
        b=hmHOz1qeluhKUkcqzL/OeCE50gZhIVAx1iScyvS/vMvefKrXpHoSSK4QYlelXJY0ni
         GF6fCZNw4NyoCwfyqAucVaW37C4F+2QyRrNxze9+OjH8siEtDZONVS7GWVS9JNvDbcFN
         jMcolhDo82qgV6KHiDOWFgTfxrT3zbVdzm24+Sk63YKcgek1kLnH3pn+kUs5ibs5rtfl
         wnq/LF3WK9ZmpwVsoDW7F8YCds+xxQ+5xn66Q93SJczvpEldxJzhY6JfXmVxMVbf6YIH
         SSnyKqzEI504Lj5iDczFeSlMDgj50rii1UiUGt7xZSPlHNMOGuKACAovxfVQzFilQyof
         OeqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WZPB/nAuSxHMF8z7YKq4XwyLCyx1N2zE8w1NIox3Cbs=;
        fh=CU+LnSAxtZyC2vXGUWg5TntFeVnmekxmAmmUswAZ9hg=;
        b=TEz+gfSYA4l4z/tggRG14HigtkvKOb73XVza99D1VZCfcNUoLYTDRb73UluQUEgJ7k
         kVdL/CsFJjRR/n8FZ4KnzzTRjmqPNIKR7fL/AiswHv997uO1bxzuxhbfOeLW7tja04aZ
         Sa1l80xZe54JhdKOtOK+q6fjZwtDBFuclTivSLb0hYsRErHq1fMsyFYk47kRUQ1Orp2+
         SlVc7ygbX6a6M3dLIcS6xSFyfflhWCHqZ04dG80eugIzgEJSAQKfo0fGMhTIUIqcWwIr
         iYi3eUw91VPyb4Qum2aBxnb7pZSUFtr8paFxM4gJxJGIC0yN20ghFpu7635bP55np6xL
         QY2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769017153; x=1769621953; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZPB/nAuSxHMF8z7YKq4XwyLCyx1N2zE8w1NIox3Cbs=;
        b=LUlBPxKjQ/x8kzcByTkyjaeJD+fhFE5ge3MD5BaQLI3JbiOHNwsi690BC2r9XZ+XOY
         NVU9pvBgbrTvwBOf80CYmVMnTFwp8LtdQ9IXh8SNMkcOpAbwdM/CT3fpe1VdjIbCu2/j
         Gdb8UdC8qh/fIHW4o9o0BZxyna0OICnFVa2HsvC4D2Enm4p7QVs8/taIu9qZ1E0ESdVO
         5K7YUwTpEceBZq+YuldGqmdIePCsQfH4RFdctFrwj+KQb6kE6yxZgC+GNcfAat6GpQaj
         /fepx2fyZbihMXeA3ijuwvKHUbOLAP//X0lrtRY1m+JdqkesSWnhZQGer4P/YR1naD+c
         lL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769017153; x=1769621953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WZPB/nAuSxHMF8z7YKq4XwyLCyx1N2zE8w1NIox3Cbs=;
        b=NdSjjXWfue7hm/i7vuoMLStNKLqMXc1kQeY6YbcUK4cshK5exUEm0jHFILzN7wIkjM
         vQ9ss5CHElk5RpEjmOzMRlFJ0/J529tyG3rQ6I7gn+TXAkItXuwdE6B3qd4m9rKHxa8P
         uuUP5QAHb9tRn6vj7REje8tvp/W1mhBpHbgrSReaDU/r++WgaKjFz2RxbIe3JMsBE32Z
         Atd+g9v7SaSoCSzkcP5WoSpVmOwAh3WRGO1Sd7PClZXkvKRMx6/5+o65rBb8h1igtk6z
         jJueKglX+i6trKL+LNK9ZEJMQy5Pljb1NdWQq97Iaj0HVGJjElHB4vPVgtgbT2Yjwvcp
         d1mA==
X-Forwarded-Encrypted: i=1; AJvYcCV97QB1KNtml6EsbWui36v1pBH8kUC8LojYBukV7kNcCkctAuAjKh19lOLq69sw86SKKi23z9JYrg==@kvack.org
X-Gm-Message-State: AOJu0YzVxvbBZNbTmrmKRcxrXmPyjlMfanjlCXhBZaMFEXSkdFFKZXfL
	zgWe3relfHxlTxY0NXpfbPJ1y9ZiGNbNRM3u68H+yGEqnmr4F7fcwkxeZsBBhD0D1tRxOInhIyH
	2y6ZC2he3hrQcKtHyfZemCeaJAiyySwpsX3llgjZL
X-Gm-Gg: AZuq6aIKBNVlDooNjMJxRiYrZbpW/pIPykX3V03zMf5cxeDKG+rM9tWYAMjM6tuDiCp
	ZXKZW3Ahk4nIUXCLciP/OjQCwi7MeJvBO/xHbnoVksZ1fwlA9xw0VdJF4Bj0ORSvSB/GLG/kio1
	7t5WwD44X+iVHox2RfrfAGjfhO4uRbAIS9eSB0dXa6gZx7RNqwCD/Iljb7XNy28uP0JuGkLpHTa
	u/4Ad07krOMrorL9XQW2cvUKJ2+46epl6gzqvW5NX0aJm+M5vrZS8CWUZlbBUReSqVT0aYucY0+
	bYtY6Rvdvmun3GAj5Ia1qhk=
X-Received: by 2002:ac8:5994:0:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-502e0c6494emr14807601cf.12.1769017152599; Wed, 21 Jan 2026
 09:39:12 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-14-5595cb000772@suse.cz> <2tvnelafuozzzfyvmxvflqmx2sepgy7ottnw4n2trkh33rrk6b@oewlapq3smvg>
In-Reply-To: <2tvnelafuozzzfyvmxvflqmx2sepgy7ottnw4n2trkh33rrk6b@oewlapq3smvg>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 17:39:00 +0000
X-Gm-Features: AZwV_Qi3Y2iex4LEenR-glhvYF5fdvLAgmEL3JsgkohqCrj2SiE002EgBpgOZDM
Message-ID: <CAJuCfpHGSxK99sSDmnh+xqJOaqLX6vVoH4oyPUS7J6J74RU=9A@mail.gmail.com>
Subject: Re: [PATCH v3 14/21] slab: simplify kmalloc_nolock()
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 53ugu6j6o4xkeojthukm81tk1sprbirf
X-Rspam-User: 
X-Rspamd-Queue-Id: 02F7E2001D
X-HE-Tag: 1769017153-48306
X-HE-Meta: U2FsdGVkX193nnto+HGyvthgEhKpaPoNT8uzWULs4UKNgCxxJijjHNGppPw6zFfZ2W573lNAD7Osc7uuH458ces18bvK1M4PHeu/V5tvsWqbG5p6RI5iitA9qxe9cZd5a+kAaPWtPq0kF3urhDWhP0/Tzyj3f3CFINSZHDowPDb5AbZ2NfPfbtLSkPrJLCQtJGnPBqWNH1CFzr1bvDx4+G7MmB4dmbAJW5TsOFlNBvnwbcvIC4jSYzjIBaMsqfkgJ4e9PS/Ko9gTNWI+zopG8CexIc+JRLpqKmOGL2Y94mOiChql1bELMQabbnWw4UjR7ocvX9TrTs3MILdIWgSnq34THYdDYPW7x6Bavk5tMu42qpgNzxqfPIz1x0AblxSo7XBVPJCd1jeCF35e0/Z4huodAmO/Re27zesaSNm68scDCi/5bWxXLuwqxrKJO0Xi4J4w+lffDwEabNwAV3b5x+XcHFfNOhZ1jqMg5b7jMU9bQWC36iq7YFN1UYg6+/bHMtQptbComI0ew87BS7KJSNcHX6YRRjFcaQuE+QiYpl/nD/iMCWRozJRkxabd3vr8pgoQlO15hCOQcCyD/6gHA7dDeJE2hrvax8X7B778V1EfJufwqS2ivWnRt/iAuJkBa5qINhJsecbJE3pFVyvFrP0hTuQzVO0yOomsGvTv0wmxyfu6Wu1Bp9yNdOgwo+BP/fpp+SortgY5gickOqU/MF0eN9bU0EDLN/26F5xeMlPgNkDttYmOL7+QGjYLyvO6etG5j8ZPboNb19M5qGx9QNN0xtcsYC7pZnj0GymlQhm9B5OHKZwulDVAWl//b5l1Ms6iJWZZy1c7qaVzBonVLBfPqAvndFAZn7DFBaJXwRO052RRlE4SqWZp6CfKV5+YV4Hs8RPcpt8xVbcTGUmTYbrpPTaEng71k4i3VX7Rkj6JJ2/pK6dumcdGLZu0kwjLsEJcRwfRxTVxC7zM/Yt
 BtxroUFi
 mtYW1cnNebHQhjYFwMGqkrt+17NfTeM6Gzl1gZ+0beyFWiR3DZGz/eBZ4So1jIfHLVcWnXtZzXkIL8qxGzaCB8v+HX730Qw2PF259HttcqDdJvfZlZcSNoeWMKmspGsxnAIzE/HCakjIlvkoODmnItJcLVxzd9gDMXzjqJ/U7DiFbURWSJ5Idn++EAfZDI/LvzpbXcOv1NnhCF566+yK3T5FmewFg47Vo8d3USG8Tiin4YARm+7HrkfMJGe6R6bt8QdaJwU+Y/o2TlyoMHZzlp9fNOuGaI6rzyD7CGk69sbliwp5QF4C2EKTSFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 12:07=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
>
> On Fri, Jan 16, 2026 at 03:40:34PM +0100, Vlastimil Babka wrote:
> > The kmalloc_nolock() implementation has several complications and
> > restrictions due to SLUB's cpu slab locking, lockless fastpath and
> > PREEMPT_RT differences. With cpu slab usage removed, we can simplify
> > things:
> >
> > - relax the PREEMPT_RT context checks as they were before commit
> >   a4ae75d1b6a2 ("slab: fix kmalloc_nolock() context check for
> >   PREEMPT_RT") and also reference the explanation comment in the page
> >   allocator
> >
> > - the local_lock_cpu_slab() macros became unused, remove them
> >
> > - we no longer need to set up lockdep classes on PREEMPT_RT
> >
> > - we no longer need to annotate ___slab_alloc as NOKPROBE_SYMBOL
> >   since there's no lockless cpu freelist manipulation anymore
> >
> > - __slab_alloc_node() can be called from kmalloc_nolock_noprof()
> >   unconditionally. It can also no longer return EBUSY. But trylock
> >   failures can still happen so retry with the larger bucket if the
> >   allocation fails for any reason.
> >
> > Note that we still need __CMPXCHG_DOUBLE, because while it was removed
> > we don't use cmpxchg16b on cpu freelist anymore, we still use it on
> > slab freelist, and the alternative is slab_lock() which can be
> > interrupted by a nmi. Clarify the comment to mention it specifically.
> >
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  mm/slab.h |   1 -
> >  mm/slub.c | 144 +++++++++++++-----------------------------------------=
--------
> >  2 files changed, 29 insertions(+), 116 deletions(-)
> >
>
> Looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao

