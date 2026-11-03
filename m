Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4E6606D80C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dkVafbPJ
Received: by kanga.kvack.org (Postfix)
	id A9C236B00EF; Tue,  3 Nov 2026 17:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CC66B05B1; Tue,  3 Nov 2026 17:05:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9625A6B05B2; Tue,  3 Nov 2026 17:05:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B266B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:05:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C76DD14052E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:05:34 +0000 (UTC)
X-FDA: 85395190188.08.E4F0237
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2931A0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:05:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dkVafbPJ;
	spf=pass (imf25.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793743532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNpO3k7KTdxpQD3zf1WdXzfgBBZWj3c4TeMM20zKnNg=;
	b=WU5u0nLZ02XBncPpJQGgejwpS1rFoseIxWKszk3+l53dDt0v1OqnYFx0i82iHZUJy+9Pey
	6GDWFVIsme7VaCDWslCK8boSTR1xiiPlR9jURM1nwOVLh/NmzfdKVqVi/nMDZtzTXfPNUX
	LRuPPSH64YCdiLDlXJChi8BFc/ISeCY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793743532;
	b=a7wJyXDN8lyvFMh6hKtiYpT4PFg9LpLFAvxlI/zMilfsFlS/tIupQeRXEucOAbTH9lRICz
	WZWrCuqz8fUj72vECnfGRTs3lej3Z85+HnxIuLFvSKeRDdxT2QnByaH1yTAJTn3gQYo+Fx
	q492FmiJ+5CGyyqQUhRgDOcjsrBvOqA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dkVafbPJ;
	spf=pass (imf25.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be3ea5a7adso5750e87.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 14:05:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793743531; cv=none;
        d=google.com; s=arc-20260327;
        b=EMLcSoYFu9Ua7Me2HVWzJO2iEXkiYOiHtlswgLmCVkFucavXv8FV1kSqM571a+LIt6
         g1R2olI90/AMuJqfXS3pDbE/h2GVwzDxHctGw4btXCBvAPzAnDeJMIaTnad1uwEUebju
         KYWc/YwgXXNpKptZ7B64XZr9CxTkhi5/Xbi1EDCPHm/kVQn4h0w0KLJsAvtL1JVIzusX
         PeX/NqCXN8LmjCExSKFYGtZUO/VuLPLliBPqz3OKXhwGvHTMN7tc6wDYsg10sVAtB14k
         pZju+AHzmNL80xQCkCbgsgttLMS+a26yB2LHkCShF2nDl42JfTTWV0EU78tKadPU0W+2
         4o1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SNpO3k7KTdxpQD3zf1WdXzfgBBZWj3c4TeMM20zKnNg=;
        fh=+pxuTXcnmUeDuXsRNzEfrjtTTRLg/5a+KZ5nyzZqKxU=;
        b=EzHMI81Zix3bfUE8bPgjBkyFrwA3g4AEgxxrlJDzwbdXGtd46k0H4V5IKYiarGEcKf
         U5S8ND8XMCvPX31lm8Pi6q0oOKxUcpjPzNFE6W1khXltaCi6zY3L+ovDlhS4IQ2u2BQT
         gOy2CZi5gMm78lTl20cp0U8cvZcqjkbszEysU0zHlixkx2xa5btqJv+1ic74nZJtn/CE
         Q097uwGqvCcYPSxu7X2AFw9kPRgl94WLNzXNcbPDHiVxEdBIwm3BeLQyImcXF1fzgq98
         XTsnluDiBF73DTuaONrf71+ghkXGjl/E/5cmwRBFpvYfF7D42QKYr9fcurQM/mXGl+dE
         GBHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793743531; x=1794348331; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SNpO3k7KTdxpQD3zf1WdXzfgBBZWj3c4TeMM20zKnNg=;
        b=dkVafbPJcbSfpS5xsj7hbFaYJAaWl5L9xgMQFR5HR6qmKZ/Jm9MdJYudEZjAUNySR5
         5UjPhCvxfM5QCTqdLfuvGi0llRTVSiZ7hXrE6b+62c/oGgBtPRxaRzMPojYD/scJJ7sJ
         tXiXs+mn40dJ7/tABG9NsvCRVk3GvWNLkayQDYDhFmJ0IiNH5gxIsXjKEXZYJn3xhlp2
         cxYQYgG6xHi+w0hanLcin1atu4WrgXpeIuvIAAN+qklj7sTGL76qNxGwz0pld+G7Yrko
         r3n/1mqP/474sPSpAIhwOv2A2WcVT8ESdjsyHr1wAuAkNAasvZqMynwVu8LSeeh0+wsr
         JFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793743531; x=1794348331;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SNpO3k7KTdxpQD3zf1WdXzfgBBZWj3c4TeMM20zKnNg=;
        b=pXtmK/itjrLneh17MBI1MjiAKGpgd0PzrQ+mCTYhPwxQmP/6RQVRdfHMSmGtJmhSe1
         zk6CA1zPIyGIL3QGB6HW4z9uHhH+a99pcQhzRsnMDb3xYKuwITEUI1LB9ZnLCCd+cpXY
         NaqdIuyK+DLnA8h7tbw+SF+ZL4rY4ymC2k/Lv/BwlwLeSAQnNr/LHkFc7QHhwr4/LvqH
         IcGyTlujcHyYin/zpcwMEKUtzrDquEoVQjHlmvTdMkft4Wnk7wSnof2F21XzomGl2xX0
         M/PqwD1BxTX2pceISPZ8ILyGqk7qRlJVNsjt/WH41lmqqoV/P/jEnM/jOKjobX6JTtYC
         XO1A==
X-Forwarded-Encrypted: i=1; AKwUvByiMUic9Cvaw7bnBnk4LYBsNMH0PmguCx7DgZkrIx+VIsn/s/cHDGTYc1f8amVn/cmMIUidO7pl3g==@kvack.org
X-Gm-Message-State: APuU4Z/Xy1PFDfqbtnHtVhV6PfDbsDYjKIRTBYZ8cMcICLyUw3yqAu5v
	5+hAhgsnFYChdOiejHqn4t2LAWnRf8rGuPA3NIsvn8dcjcBh80v8y1KF1cJ8WfM9BAodYY7CFKU
	lJHMP8SJvjy3O5kwvad1v//x0tO5J2S8=
X-Gm-Gg: AYBFou1s7t523XeDrMo5wgBhONHe0t2Q66NwjPXQHiJ/15U6yqdZEqj7f2INS8WHCG1
	2U+esGEdLmvT0MTj9v5Fy1bUrCEmok6UQKVMe0tTaRKQJPVDjr4UQ5Hwm9Pf61qBIMc6wW12anF
	JNrWbGKTaSm01ewEsirPpdHck6/pUxPGpwWjj+X94LnRcBEQaOPuI2sEhc4af0ZA69b0YKk22mk
	P/5bbaSZHU1B1tCyV4b57Jhd3kgpgZgVqaJx50FaLCDrlbZoYRJDEYTMY1P77rKMGpm251gUmiO
	S5epIjmDiQaOSfxGT4eFxhT0eIe7gTJ2KzvvsWuVW18CAfHCcW/dG+FFrlEIUHxPszN9jMUmXA9
	H5HvWpe/2EsFwY+TznEgIrsL9mx2laL//nnlr
X-Received: by 2002:a05:6512:131e:b0:5bf:cabe:23b6 with SMTP id
 2adb3069b0e04-5bfd9569866mr4812334e87.33.1793743530815; Tue, 03 Nov 2026
 14:05:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261013002140.28880-1-kanchanapsridhar2026@gmail.com> <20261103142600.279899-1-usama.arif@linux.dev>
In-Reply-To: <20261103142600.279899-1-usama.arif@linux.dev>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 3 Nov 2026 14:05:18 -0800
X-Gm-Features: AclHuK_KqFdN8VFfpR0ggkVmcMetMCn8gBaDmQi35Rpfngre-ekOfLRqKDMkPbc
Message-ID: <CACpmpodmeJB5FssJdfFxF+A2PkrC+=hnWGn=F_fTbbEtDfRF_A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and
 decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, yosry@kernel.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9qe1feoprcz8yaqae1mcbf4wawh5g1c1
X-Rspamd-Queue-Id: D2931A0006
X-Rspam-User: 
X-HE-Tag: 1793743532-328722
X-HE-Meta: U2FsdGVkX1/E/3Kt483Iii25R15mwNu4TsWS4pPR227ms52NYf1bG1TeA3aZr8nRQbB4nNGHZQJzXN5C9Ojt/N5Y0WtB7Ql3X6zgfbCg+ENhoByg9l6I31n6mtC1N2dlwu+R7BJUSqmOStJdNqFqsgmtRbb390LTp4PxOocfRjeBmfv1DMpp+rhMqPUnP/UBkkKAPjLkQ0Ndf/HRKil7UljIvP8xilb8S1Ce7CIaqbuI+mbO+m3gXmIbMtNIWdSCGSri2cZMlZzP/+Fa/4KhHUgZTfVUin/bP3fHcdlG1zGsXY/r8usWRr+xrgv8UTOT1jf9vu2yDIgv/b6oneWd3KBwPAK7I8moHg/M1X3obkFSjANDRXuXYPE67nBZLjvOO96KkDQMncYUhz3IDxsGbr/S4R9/7whR9IiXqoFCafUQKzuKxEbUB7qKlqh1FBgKAbP6Fzer3diqxD0yb0hbYBWkfU/2cju0rmX66ArqkJ2GAdzg6+oMV/mpJht+nA+fB8ioh/BiSD8T7+vgH85KFH7SJcWWRAKEneLDNAEJYExWZyAQ34OGbsD+d+jP7emy6B5FsTTqgdiY4M7bEQvs1Bk+muY2a+sMPtmPYNa7YeCc4UEBj7wKbRjwTB1IJhIlYh4rXzX4s4ECsM2tZHH/RPn/tm04Gt4/PDxZZK/4L/jkROvbPtFYM1OPjpfXTr7HvdBahxIkR5+nsjsLHWQyLzzDalh5WTFAdW8Za471vD2SkLZfpu9SY1z2nUd+YOXT7stiVdhAzY67ZO3M4ZFYlsNuJ40idSttwXYKMq6/3cZkSdszSdx83YUtEcW1+fRGx71NnnZ6be6KZGzK6FA/9aircBryYX+W8wNLuOT8bpOVKYGkEhQUX0d7X5jFddsc/WVJSK/JKXNJcbflfeU4XsfzHwzur1Lm3mbxfeGlByXKpigEvR1A81JLCX7aB9lf3zrqEL12bWREA0r44c7
 EyyVsRli
 Hea8JK9EItFasVYH8+QpqaPRKG7HCYS+KX1eWHf5RyBH0w2JQAhh9JfwO2VRDGywwlEmxEtGpa3tvzDHNXxyb7PUNuYjBt5vJCMLMCMg0+Thy5d9g/sFkw6QEzHC8MO9JU6pWCsLbm9NoTkAOMMiTBqmTVM4QzXeXf0x+et0zuzlD8bFqA7F/7KHpGd1RJyz9D+eEbGGmubJWLVHm3igRddwDimNbkaaYd2+6kJD5qXbhN20VnFguQbKG6Tkp6I5R8pX7qjPQpTIeuaqP+Ftr4hS6pTtXQrcxj+Kpo2K9L2dBcsN0cYyCGZw2m+szCUWitWHHDJr5hvDK44n6kpWcS7d3FHT3j7oDz1HEq/oNuZlaId0GQcDvjIAaiVA1j036Af7Mz67Vn9mNdwdlXlLKMcPDgc4CK4ka47S6M4emxnqe/tmlx/L9i8Odqc6It7QL+Sbn6UP7YhnXrht2T3gEw0i3XOPD2nqIROHx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 6:26=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> On Mon, 12 Oct 2026 17:21:40 -0700 "Kanchana P. Sridhar" <kanchanapsridha=
r2026@gmail.com> wrote:
>
> > On Fri, Oct 9, 2026 at 6:31=E2=80=AFPM Usama Arif <usama.arif@linux.dev=
> wrote:
> > >
> > > Stores and loads serialize on the same per-CPU acomp request and mute=
x.
> > > A low-priority store can be preempted as soon as the compressor drops
> > > its stream lock, while it still holds the mutex. A higher-priority lo=
ad
> > > on that CPU then waits until the store runs again, which can take a
> > > long time when other tasks are runnable.
> > >
> > > Give compression and decompression their own request, completion wait
> > > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > > decompression APIs from zsmalloc"), the per-CPU buffer is only used f=
or
> > > compression, so group it with the compression request. Independent
> > > requests can share the per-CPU transform; the codecs and drivers
> > > synchronize their shared state internally. Loads can still wait for
> > > each other on the decompression mutex, and stores still serialize on
> > > the compression mutex.
> > >
> > > acomp_request_free() ignores NULL requests, so drop the check in
> > > acomp_ctx_free().
> > >
> > > This follows the proposal from Sergey Senozhatsky for the same split
> > > for zram [1].
> > >
> > > [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@=
chromium.org/
> > >
> > > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >
> > I have a question with regards to this patch. Is the intent to allow a
> > decompress thread to run concurrently with a store thread for a given p=
rocess?
>
> The request is shared by tasks using the same CPU and zswap pool.
> These may be different processes or threads of the same process.
> Each operation still runs synchronously in its caller.
>
> The motivating case can happen entirely on one CPU:
> 1. Task A compresses page X and releases the codec's stream lock.
> 2. A is preempted while still holding the zswap request mutex.
> 3. Task B runs and faults in an already stored page Y.
>
> With the shared request, B blocks until A runs again and releases the
> mutex. Separate requests let B load Y while A's store is unfinished.
> The codec/driver still synchronizes its own shared state.
>
> > If so, I wonder if incurring context switch/PTE/TLB shootdowns performa=
nce
> > penalty is worth it?
>
> The switch to B already occurs with the existing code. This patch adds
> no worker threads, forced migration, PTE changes or TLB shootdowns.
> It avoids B's subsequent wait on A's request mutex. The 1-vCPU
> benchmark in the cover letter exercises this without CPU migration.
>
> >
> > With the proposed change, will zswap_store() continue to run on the "ol=
d" CPU
> > (i.e. the one to which the process got migrated), or is it a requiremen=
t that
> > the "old" process is in sleep state? If so, should we codify/document t=
his
> > requirement?
> >
>
> There is no requirement for A to sleep. A can remain runnable while
> preempted. Its zswap_store() invocation resumes in the same task, on
> whichever CPU the scheduler selects. If it migrates after selecting
> the context, it retains that pointer and the corresponding mutex,
> as the existing code does. The same task cannot execute on two CPUs
> at once.
>
> > On the new CPU, is the same process "runnable", and if so, how do we en=
sure that
> > the "higher priority" decompress is handled while the zswap_store() pri=
or to
> > preemption is still not done?
>
> Normal scheduler policy decides when B runs. Once it runs, the split
> removes its dependency on A releasing the shared request mutex.
> A load starting on another CPU already selects a different context
> today; migration is unnecessary for the benefit described here.
>
> Existing folio/swap-cache locking still orders accesses to the same
> page. The example above concerns two independent pages.

Thanks for explaining the motivation for this change, and the detailed
analysis! Is it possible that this could cause compression contexts to
be starved of compute resources under memory pressure, potentially
causing deadlocks with page-faults in the worst-case scenario? Since
compression is inherently slower than decompression, could this be
making it easier for swap page-faults to preempt compression. On a
related note, should direct reclaim (only) be allowed to use a
non-preemptible context via a spinlock?

>
> Thanks for the review!
> Usama
>
> >
> > Thanks,
> > Kanchana
> >

