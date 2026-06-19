Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D93FCD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8A16B0088; Fri, 19 Jun 2026 10:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67FD6B008A; Fri, 19 Jun 2026 10:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D579A6B008C; Fri, 19 Jun 2026 10:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFD766B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:19:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1ACEE1A0451
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:19:56 +0000 (UTC)
X-FDA: 84896871192.17.C70A07E
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2244040005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:19:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GNnAzjZl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781878794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzKLB2yDy1ZnJbE3hX8pVfOK3M01mkyJpe17sqruEoc=;
	b=MH1MHGMhMJudSKU/alBcJ8LWLs03nVYC7haq83VBRmbaTYWk4iDlKSoguolEPrN3nJHzHT
	i5aUt5G8QVeMwoLSEzZ+wriMtvms5ZTELf+JJMgO7oOTx6v/rqWSDHVR2kb6BQ6p2M8bi/
	RiR97DKGM6y9yWbsg8NM9A4Kzr/60gE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781878794;
	b=aMq6ftES/FHCQBvl+pUh//vcqVBaE1+lX9qAE8JIizBfhbENUFrTPKPOmqCoJuYHn+QOKU
	/+fH4jOxvlDjocVVj4Bh0PAZ8EuFcBQS+x7BCTQfYTnNLjejM7XCFEwyN8YFjB8Vg546pu
	ID6HGXF9dk5NHqjAZ7UXknEgfGjpDPA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GNnAzjZl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51765331535so208111cf.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:19:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781878793; cv=none;
        d=google.com; s=arc-20260327;
        b=KQgt0F2BDS1z8XeBR4oAcUmoX0gcu1MBlghUaqKZmZskWsxd1Tdl1cQD6/7wJHQcg8
         DnhApSudmbmSt8UFiOUrSBR51V9TUDIU7JG728ny1vQ/5APbq4l/GhKe5w9frQJ0SlLd
         /7n2HAvCVtSJnTgH4pi9ssiNt1zG7AKX+uCnrKITEBzixH/l5j1EwKes3h77NwswpgxN
         yEpR/i1yvHFnsuaepVyY4viWevhSeCEwwGKQVqjmX5ToEtWjwWAeCkv9pCS6t6tSt6uZ
         odEsi2400Bcao1jsF0WfPdf0qZKidSAMIUbwOJArr3T40QAGdmIyAZHGcK6Hej0nfrKU
         Xk7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CzKLB2yDy1ZnJbE3hX8pVfOK3M01mkyJpe17sqruEoc=;
        fh=HgV1j87mzQ1++X3R8AzGRaTg/ZRRsoxmw/HhNqZiacw=;
        b=cTDiEBPtMhIZSE0awQBYKZOhlTveMPQUN6Tj09RwctqHs8Es54Kk1HMt6nr8Ym3ETd
         0Rg5Rm6AtqydNIA6rKfwvNY8cim4VSQ8bLu0+61DXuES7374GuhqXrmdIGDLYGlEZK8F
         uI/218agRb3J+UoAxCLGzjPpHdjCTJ8QJJTzOgfJxCadZi2pyaF9VQkWYrQXo1U+5a8V
         CN2ll6xWuwAQXJK5x7glFBTtWyv7fwS3G8op3bKt4W3+sN5ZzMB9NIfV0EC8lJ14KiMC
         AdEN2y6S/OqW5KZclBuBIAoJpfBm4OKvHzRtwem77Hy/iJWWytHzpzbJYHqEZnrAonZ8
         9MTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781878793; x=1782483593; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CzKLB2yDy1ZnJbE3hX8pVfOK3M01mkyJpe17sqruEoc=;
        b=GNnAzjZlnjkkUzGzzs0FddJBNkqnYzQ0DUjW8MYl+wNMwEQtklSvn3s+DyiemENY2R
         a+KvIjaFMAyCy10NxATHD7HOHjqf+eKN73/svRDX3htikkA5RDJZbWTTsD/FhA/MKfPk
         5G9+OloPCWdAqJtu3zYcuYvr087fn8JDGo9W42Lp4aFDaJlKjz8icCNNOwlY3J8B4F8f
         Jzt4CW0L/WdCCVCBvKP5KqquAypblSMe2YbJ4hkL3/hciFUHQOJ4LycVdhxrphCLCJZe
         GmIU3bg1GNKvpGrzxr4ITEvC4aq70U/nrp80WDJiJXsGGSxKQSutaYzf5rtm6weCF0s4
         +2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781878793; x=1782483593;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CzKLB2yDy1ZnJbE3hX8pVfOK3M01mkyJpe17sqruEoc=;
        b=pEfDBYcX5Jkn10Y92SyAFKq6s9K00FuI5BT/rrUSTiaIS4i5d3XsXQJ1YqqvztHepc
         FFcuZ1hq7CYUA49Td3XBkMC6n/LwQo04Emni71TSd5XabsD6g8Eh/O3wJRYdiyqDyXts
         JC5Tl/3mjDrvHkzpphPFfYFxhNhiKLgf2SO4R7bA3fYgB2GE9u56isaqLI6vhCO+8o4Q
         DF96h4zrBvaq82sEC7KMCfYsXBJeK2S3+Sl3eq9hHxuUkyqGdyLcmUd85mvDt53AklQ8
         igGg1Bd+WUAQE60tXZ9po6N4m0ZcAP+qnVunDAKpLuzWo9sa8WL0IbOeis71vnZSCLtd
         rXKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8FpaQzO7XlPXSXVUbUSJDt9T0ybYhkcCF8nR1yuYdjIvJb4klqMJh0XZta0jLH+1NEvhSvhiv1pg==@kvack.org
X-Gm-Message-State: AOJu0YxGXYK37j/bULKuPpx/AonE0HMW1XEtqNPMuV/62uufhDXJKGWn
	vHxQZazC2CK3QRwhVR7zC/S5seg6mvrXM7N7tilYEIJ1wpDrWPXbTe3VfuA3MUVJwPHlcqdpBM8
	H6sIv5SqjcHegpEGMqiRMc9h/sM78Rty8hIsb+J/o
X-Gm-Gg: AfdE7ckdeLjzM6evmtsC7HlLu/FB1IVQ/JTcPCdN6ws94WU/BwRFlj/P4hl3vWiFjus
	SKbPDgx+fh9sI6YKeO1w8KSvR7NNz6n04KGho7ltKEYSYdCLUUo7NK+MW9joLUYENGN55E6xGQX
	VLgqRCGwTnrr3i45SdTAKigCY8bsgMm/EnbBrE3Q4kSy4BeSwFYU/mbL953KibgiiZcUwU95jwV
	kz4PpLGqZON3Z4eIst2NPQlsYANzu5v4jNWki64rjPduk1maOnL935JpEqkRNVmg5Rd7SK58zO1
	sJv+nA==
X-Received: by 2002:a05:622a:8893:b0:517:99ea:ab7e with SMTP id
 d75a77b69052e-519e4a70452mr9247461cf.24.1781878792472; Fri, 19 Jun 2026
 07:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260616190300.1509639-1-riel@surriel.com> <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
 <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org> <CAJuCfpEqz9t-x8abYD6idtHmi9t8p4YfDmnbkJ-ix4i=RMS4wg@mail.gmail.com>
 <603e002e-77f4-492e-9ad4-75572e18fc0b@kernel.org> <ajU3q1e6mpWsJ6Xa@lucifer> <c56f8fe6-9e06-4a65-9470-1fcd12189ed1@kernel.org>
In-Reply-To: <c56f8fe6-9e06-4a65-9470-1fcd12189ed1@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 19 Jun 2026 07:19:41 -0700
X-Gm-Features: AVVi8Cd0JPBRwi6RXJL9bgNk4YAzCXHI47ApdyOIS5EEG_tW6SgRf1YbPLveFNs
Message-ID: <CAJuCfpGifYo0iafNrMf4piG8eSb2FSjgVoPr4P-3YDabiwe_UA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2244040005
X-Stat-Signature: 438du8pt4zntgfiq55p1kg3zpqw5naba
X-HE-Tag: 1781878793-60255
X-HE-Meta: U2FsdGVkX1+RXnhExVlwQ31O80WzWsdwNBQOZBlm4jo8z9gAnK0QHLTQBT+zeHjDS9SDfw5zFuI9GCJwJSLOKj1iUNxnwilNu6t+WbyqP9wa6t2tbaSKSbNtwQgqOMh6n7m+waIjHCJbuNMU4buqTX8rcbsxK6IpTSmbDx+rMLjapNrxTuAfOGTrKg/Jqt0Ka14Re1p2B43Dt7uUgahDO1r2dijgWHd+k8JEut4t7IDLsVb6Wt1Pr8LR8ULWF67cgEx6pmsF4QbStpDfPTPe+647Zq7iCxSPdFZVMLab06gWXo2HPQGcZ7tp+HOUjllfFaZQmXqECO1qb5uHogHB22jMJ3tUks9gCYTgpR1ZcnEXwHGJ8YeBakLc4aIgZv9TomIR632iXTgw1MG12Amslyxpw7akVuBmg1ctIz3cUXee/xuSlm45YzkL7uwjVMr7wsNilEq6pakIzLfqOW8B1Knc5NhnREJM+I7scmfl3BD6t46txwmOR3jpMq+h10n6B9vwDbHc5AjQVRaXWyi+f3MQBVuAM7IMoHdCJk5SlBrWDu5If6xtniXo4bbxqcnY69G1fJCGFdXhWUje4W2fnz3W2VfDEd29l3ZAZaZKg80+/SVZ733oVz6S/I+nywwRJLzhlxgAJieQue5nEcCMp7p8y8O6zXFQdjxaDDLenVTmMYVJv1jdIyjgJpAMaV3Ch7zIubtst6gVTYUGNL8uHl4q6BWhSuCxF57bmczZgtS3ECejevojw5l/BqB+4tzluZ6xaaGpPyAOTDh8lpWILDgVMXlhuPMZ0utzB7755/lIQYscojnNjVldVZxXhO659WH4cbvu4gKcxEj4+82K/4l1t3H+ckM5CpLbSm0G/GsEx9OZ2lgBB6v+PGKbMVRUdX0iCp/l+nGjXnF+r42inA1pflbH0Rh+qMg4kurAOTIUMDXdH/S78ALfu1ep3VvSPk+RehDX6jxpKQ3wr1W
 qVwtf5aR
 Yl6jrBbdMg8OZw+/q55O/oDy50Id3eP4KmBwxQ7ypk685dik+IJYDwEzPM+ZjgeCqfPEqqVj0NPj84WTNGjYWRh1XI4LL0fhFk3TUjZVLygvV48a+ryA7zagCGqbsVBsCXCRjf9KZ4YHt9S0UDZA60W9+S0KaQtq/I8CRbDlbbXRAGpwOFtGV/F1WsLNWUxQY1xR+yfYBVfvA7cHzv4XoCstLkQwd7BbLnu+YhHW3SoL7CUHFH4DcMR4hy7+KegRQzn3NsUUwxQh8eM+hvF8v3PH0OxLoRO0M9bc8uiC0ZHw9OlClC8XwPyQp2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 6:05=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >> All GUP does is walk page tables and call fault handlers. userfaultfd =
is nasty,
> >> but existing page faults must also deal with that having to fallback t=
o the MM
> >> lock, so it sounds like a solvable problem with some churn?
> >
> > Well I think a critical problem here, as pointed out by Suren, is that =
holding a
> > VMA lock means that the VMAs around you can change and in ways that are=
 quite
> > problematic.
> >
> > E.g. The moment you drop the VMA lock that VMA might get freed and then=
 merged
> > with something else, and the next VMA you consume is the same one you j=
ust
> > partially walked, for instance.
> >
> > Now perhaps you could reason your way around this, but I'm pretty sure =
there are
> > cases where you might actually miss VMAs due to races (Suren knows best=
).
> >
> > And also without an mmap lock people can unmap and map new VMAs in the =
range as
> > you go through which might cause weirdness as well.
> >
> > Really, unless you are dealing with a single VMA in the range, I suspec=
t GUP
> > needs to stabilise that whole range.
>
> Well, depends, really. It's not like a all GUP operation that target many=
 pages
> runs exclusively under the mmap lock that would prevent any VMA changes.
>
> With userfaultfd, for example, we drop the lock in between, to lookup the=
 VMA
> again later. There are various paths where __get_user_pages_locked() is
> instructed to grab the mmap lock itself, to even temporarily drop it if t=
he mmap
> lock was dropped.
>
> gup_fast_fallback() grabs some pages to then take the mmap lock. And cont=
inue
> from the next address.
>
>
> So it really depends on the use case. I would actually be surprised if th=
ere a
> lot of use cases that strictly must block concurrent mremap operations et=
c.
>
> The important part is that you process each virtual page address requeste=
d
> exactly once. If the VMA was merged in the meantime, you continue from th=
at
> address in the previously-processed VMA.
>
>
> Some use cases might indeed want to stabilize the whole range. But I woul=
dn't
> expect them to opt-in to using per-VMA locks.
>
> Just like with any other page table walker, we cannot just convert all in=
 one
> shot to use per-VMA locks.
>
> >
> > If we could find a way to have GUP fast-path the single VMA case sensib=
ly, then
> > that's probably workable?
>
> Right, that's what I said: start with a single-VMA interface that support=
s
> getting called with the per-vma lock or the mmap lock.
>
> If we have to fallback to the mmap lock (userfaultd? indicated back by th=
e
> caller), handle it in the caller of that interface for now.
>
> >
> > And I agree special-casing only one place but not others sucks.
>
> Yeah, we're not doing that unless inevitable.
>
> >
> > Perhaps we could find a way to get this improvement without it being qu=
ite so
> > 'tacked on' but without needing significant rework of GUP, but in eithe=
r case I
> > broadly agree we need to improve the codebase as part of the changes.
>
> We shouldn't fear extending GUP in a reasonable way that makes everyone o=
ut
> there profit ion the long run :)

I do not disagree with the general premise of making existing
mechanisms work better rather than implementing parallel ones. I'm
just pointing out my findings so far when I moved in that direction
and I'm happy Rik posted an alternative simple way around large
refactoring and started this discussion. We should definitely try
reworking GUP to cause less contention. I just don't have enough time
ATM to drive that, but would be happy to help with the VMA-locking
parts.

>
> --
> Cheers,
>
> David

