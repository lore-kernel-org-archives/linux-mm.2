Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DFABFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA82D6B00B0; Mon, 27 Apr 2026 14:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FB96B00B6; Mon, 27 Apr 2026 14:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96936B00B7; Mon, 27 Apr 2026 14:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9865A6B00B0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:23:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 431F78ADDC
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:23:13 +0000 (UTC)
X-FDA: 84705157866.10.26CD149
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C809120009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:23:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lVE7jl6r;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=axelrasmussen@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777314191; a=rsa-sha256;
	cv=pass;
	b=TKNaeNVwjjM0u8wgnTfHJkj2z8Do1wm6SvVKvYvKXtpUqYEe81qwqt7pyfQBCzmZrKO/fx
	qsHPN2FWnoTwK+bahMAmXf48dbyeaAj0ibThekrKnSFZjy5fPiz2Q2Ar2Q9GXHUPhTKfak
	w8Rc0udht/T/Si6cHExQYfK6pJBMJ3M=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lVE7jl6r;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=axelrasmussen@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777314191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vnOG3GtQn2x/iRu7QND9APlhftBUG3M308IdNqyP3E=;
	b=QaW3NaADaJJ+SYYg03v5QEB3tvjJ6pKKq552htFcg9iaI9esCPfOdQOFV1x7LeXxGUh/sl
	FlH5ZzSifYWIuC5pLKeD3FB3GJFK2txBvXiJWDTcjPpMMcehUJ+aDIDSgsO6Y0yFeDPR5s
	67gi08dsWEownbtlUrGHLkB2VIwTskk=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso1056a12.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777314189; cv=none;
        d=google.com; s=arc-20240605;
        b=PCOAZffklchjxHMf4hstZraGyYCiAvaarVQm0kPomCeBs8foFsvWcaaUwb6RVMQt4n
         u2Rn0BQKR65cNt9ubj4iO2yk0e+ewA/KdVmfIWFH+mdRY1yCR3x5Q+fti4rvsG55gzzJ
         Hc2Cr5Z7OqWNcS/S7jVeLWKxzhItN5Il0zexCFBdkiIv7jnTPdi3Hz4iCweaEEdhHGKI
         UiluvhMTQ0rcpmYHZGXXZvxg/YX3ozRPmnREE28r44iI5DhcBgHH9Np5VXPs7vOSr+F/
         jlWVq8V8gfZyUuY1x4iX8lKx8Xlo/XnLwwMUJDXXx/sn1b4gyFYXJV+WImfbIEEj9xcl
         /EeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3vnOG3GtQn2x/iRu7QND9APlhftBUG3M308IdNqyP3E=;
        fh=qrnbPqJSo62b900xG3N0pzJ71gfpGGQrcMDNHq2gayU=;
        b=dfS7m2c3RC6tW6DCfp91fLaQCtN+dDby5dVncGu6dZBq207Y+LvbN7TP0blZE1D2Dv
         /16/enAz++i8hzXnZoyPdvOhkZ7wntrCaZebOV4mbTaWyGDtf2SgrfDdFUgTDwxYkruZ
         VpDe+79WoNFZN5/FnoKmRYOD6pkUcXtKkS/qcSvzpRZNfjaC4N7c8E2uKUxCG9+Xq+nF
         +TF96jzybFtt/M/9wv56HTMeNDUhs6NjHTtAT97njXD1tdNpU76T6SAurxBANYN4Srx7
         aHBHU8xwXIFl8HiLWvDNYgYRmhQ2XOCSZZ0bigt4A4doMuLq+iauvC0K+s2IG7rPDtPV
         l0Gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777314189; x=1777918989; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vnOG3GtQn2x/iRu7QND9APlhftBUG3M308IdNqyP3E=;
        b=lVE7jl6rF5jkvMQABaxTohxFk7GfBIoh/TD584ISyWRHKmMMij5NeCn9bLG+D8c3f/
         jgDtKg6AKuNCLCv9FOtP5qVD54zJwMhcxaK5Q6TzkIPHl5HeBLGkODv+xar9l6g4AWqz
         bibjYuyDnWWoeupPEKcHiwyPINdByyIDyKHMWdFrcVMjiM29Nl30xvc9JWJsxHGesw7j
         OpBq0cH3aJLX0C3zTSy/KWOSjsWmhHKbWiCNGEnv/9nFyBanGutZr43Mn4LsmE+a8MUG
         IdIaOzIbblKyMJfCogC5Hh6HOWmhxe2YXmklxKwxZtjkc9xCZV+62nZ/wfqLqzCGIkWU
         hJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314189; x=1777918989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3vnOG3GtQn2x/iRu7QND9APlhftBUG3M308IdNqyP3E=;
        b=g1lgzc/DpEm5wwP2ATryfX0MV3NzNjDrcMQFZmzM0/WPhL47MxsXJKBmrnX05HMCam
         Z/xrcL2FScOpkrl2vwQTzSMZS2lvslaKkvWr3rWb6EwInlp2duxHlc01uIod1ywiU6hl
         g0V6DgfbGWIfRNIpIvZ8QhLxf5Wt2wvQgBr7uZ5Jd5rx9FMrIfpMMfLRhEgb4IWiqPHa
         Av7CBa9Lzm4mqIwCv7sTuAyxL/I1uWFXvwUxTTSUW59fY+68JNjuggnZGtnxROkGIByw
         0GA6nJVG2WDGL7DntYfaNcr7l0JvBAPpDN/Oq5FIC1iHFIT/fIdA3HmcX2e+Bt/qbLkO
         7sPA==
X-Forwarded-Encrypted: i=1; AFNElJ+ZJ3k9XYDYHdjdqTlMuRyinrJKntDHkUuDSAB5RJXPIl9VttqCDhijGHiWpAXWP4MUNodJCL6uoQ==@kvack.org
X-Gm-Message-State: AOJu0Yztu87hi2HbG7NmbCcNVQrAhH2qfjSLM22BMi6fsMCG8LFyPUH8
	RRiu4YEHiufla2WhgZkIGTLzfFcomPpiIT/DIWoIvObQFfjzDCiGrTLbz8cHCBzEGBgge9wRF0r
	sWsuKRcQjLTSJedd0tYMBofqWMWWtPGGLMdYkGuSp
X-Gm-Gg: AeBDievwsy85mzt64vH4WW5vgrPPUcNpBhg+K9qrb33DyzDw3Ecy0ze6+ulrwNVh/Lm
	CihN8u1K4ewmqcOiCsBc2SKGqW14/KGgtl8EXZEDaQxulegoBCZ3/qDvnDveSregknqcudITae3
	Mip3sDj5mAig7F3oDp9thIVGa7v7cx6c3RIlnqi5YKvNRvSAq/zGOof2wpW4AKZx9lqeKXgd5KT
	tAr4AVge4k7T2ZnTPczghxCVJcvoijbIgdVVjnaWTxfw2vMmTen9Bhfy8tsAkTAIGm2ewQMWtBL
	rKlpyLI3acEwH/20q9ew+16mB+SQP0Q4j9DcyjJgwOcjXo59gyQzPzfNZswnI3ltOb1FBw==
X-Received: by 2002:aa7:ccc7:0:b0:672:117e:55d4 with SMTP id
 4fb4d7f45d1cf-679b6701ea3mr8613a12.0.1777314189007; Mon, 27 Apr 2026 11:23:09
 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org> <w5ekxean6g6eph4427frzclgzu5hrd7kqres3ronlqpvqtsusb@kfdagnk2xqif>
 <CAGsJ_4wo8Chd-B8oRwTEQsU+CQu_tvwmkx=PdNweTBTQLDsRUA@mail.gmail.com> <ae91A9US6ybEzqM2@pedro-suse>
In-Reply-To: <ae91A9US6ybEzqM2@pedro-suse>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Mon, 27 Apr 2026 11:22:32 -0700
X-Gm-Features: AVHnY4JFZIbck82FH2Gxd-klW9wfV9cBevrSHXzdSvVRHwoEmMnjlaFzOu_fIZ0
Message-ID: <CAJHvVcjH+BS306KKOsFcVKkbmkj0aKXtfpuFy+SVYKE4PQmVQw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: Pedro Falcato <pfalcato@suse.de>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	wangzicheng <wangzicheng@honor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, Matthew Wilcox <willy@infradead.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8f7swkk5kgfeqoqnuntg1kf1krny81pz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C809120009
X-Rspamd-Server: rspam07
X-HE-Tag: 1777314191-923583
X-HE-Meta: U2FsdGVkX199ERz3DmorKn1aEA3oIdfj8JOQC9dR+hLw9ys8Q3Q3Bq1VmGu00h1q4FdZ+Xc/iG+mHEA9lRTtihFydiO5qPq9aBQJAo3jUN/6g7S9tQFdtYFmoOb7MXjIrpI5mhK0MfXywtmX96kXbzswE4zbVsCbASkIjj6h46Scg7zqZaLFP3qyuXLd6oTXMq8o6yLluQ2329b5szZvlSR4YNZdT5vXHVKV4Qu1vP+GpBqTgIvOSly+iSMS8WcmkNwcFHpCUrBAu3iPOfjGQQsbNy5FB7XC7x6P0NwMY1jSgl/KBnzsYPPju2u+qwhxmk9HiSZgmlVd5I8XdR5Qxs6NMqWNQtT5BoG4aGvR3Ng50YQnRq2ThOhgGJ5EB34yNbqFrqXSJPEdik+9fVDc3BTVo3EjS8o44iQCFrGgyBCi2Sy4WKsb4mwOiwVWVG1sXCTEVxpOwA+L7MjjOJouhcFtHhL7imE4/7MPqOoFb2x5MVN9ETJQ/5E6LBqBuAfJRFnL+4En7B26d0kadwY5qkrxBRcIt19tt+E/hEuWZ0psByG0QMbhyRwpdVXPksdIVLEfyAM4oYjzJGHCnksYteiaE71M3Zp0kaulsrCE5qSKqWHwGyFy0gy77hspnlwIn6vCY68JCRiJVA8vSkITokilyfzPGMD5eiNvYmLfXwxTz8MEystINJuoYPl5Kk3/JEBk8YvYMWKMWPwuehCWmFtKLeVnrhC8vg1fTzuWmZnOaiZlNgRpygl9sixNMmP3x+K0lIANgGM50NNZn1RpRReN6FUz9uW4FlPGn2amCnQ4Y+X8txQTtCEQdNx/zDWfjUmwxF7puvFM8tr2/X19oNzxM0TDgIfeNGNZTzxPcWl2aPMhJVMuqFrZ4177UetgAJ/bz4X4haHGCN8UJEyl4exqDSxpS68QXoJaqTad9aD6/jbnxLlm94Bw4mq2lgtWQtRwt4Ds1dm6nV8cVra
 vLYCIdBj
 8RtuJ8zqQS0o9ixqKBQ/Lw3fmVbUmmxVr/uTjIl5l2XIjCbn0JDZSCn64PnF5S/pAEhZmp0VpZ+4OcPheLZU7QyJw1qd8k4mtaqqbIMqDvzcI0eQIvT6KzvqgSiqo7pVQHCBM6zXsK/9Gc+Vg0taTTqw6ri6fVWZuVZ8NKjotnNAw5s6e5IAMAIM3CPm04wQCBnjuUSUBCE24EI8agSzAN+HvBBIhdoDQSPvVp17pabeyj6047VCq6FwsKFXU9jG0uXlOyFIDGlrMi3PtoPVKbJzG5U41GQPnzk2UUfa1cppEyuWZhpsm2MaxZ9p5O3FBKSi0VksTa6GlQdcsI6Poq9x1e5QyZmgWMMxO1UNKJxkl8MnsJtr63KrQY8ciPKcY2sBLz27TgZTQZSocdb0srALX/2x9mxRyCOdCuS3Oqj01p/sd5kjKReSo+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For what it's worth, I agree with this change in principle.

In production we set fault_around_bytes to 4096. That setting is
surprisingly load-bearing (i.e. if I change it, even at a small
experimental scale, I expect workloads to notice and complain). So I
don't think I have an easy way to test this change under production
workloads.

Like Andrew said the workload in the commit message doesn't seem
unreasonable, and the benefit is large.

I guess the workload that would see a downside from this is one that
heavily uses readahead pages but also generates many "one-time-use"
pages instead of maintaining a "fixed" working set. Without activating
the readahead pages, does it lose some of the readahead benefit
because they are pushed out?

About the Sashiko comments, the tier bits being cleared doesn't seem
that problematic to me. However, the WORKINGSET_ACTIVATE counter issue
seems worth fixing.

On Mon, Apr 27, 2026 at 7:46=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Sun, Apr 26, 2026 at 12:35:46PM +0800, Barry Song wrote:
> > On Fri, Apr 24, 2026 at 11:19=E2=80=AFPM Pedro Falcato <pfalcato@suse.d=
e> wrote:
> > >
> > > On Sat, Apr 18, 2026 at 08:02:33PM +0800, Barry Song (Xiaomi) wrote:
> > > > MGLRU gives high priority to folios mapped in page tables.
> > > > As a result, folio_set_active() is invoked for all folios
> > > > read during page faults. In practice, however, readahead
> > > > can bring in many folios that are never accessed via page
> > > > tables.
> > > >
> > > > A previous attempt by Lei Liu proposed introducing a separate
> > > > LRU for readahead[1] to make readahead pages easier to reclaim,
> > > > but that approach is likely over-engineered.
> > >
> > > Why does this even need to be kept? I'm not sure it makes sense
> > > to even mark readahead folios as referenced.
> > >
> > > I'd suggest folios should only be marked referenced (or even active, =
whatever)
> > > when they're mapped. Anything else is a bit random and is hoping you =
are
> > > eventually going to map them in the future (which is not true for, fo=
r example,
> > > anything in an ELF file that may be readahead but not mapped, like de=
bug info,
> > > symbol tables, section headers, relocation tables, etc etc)
> >
> > The patch targets the mmap readahead path rather than the syscall
> > readahead path.
>
> Yes.
>
> >
> > With lru_gen_in_fault() in place, it=E2=80=99s roughly equivalent to
> > the mapped case, since readahead is typically 128 KB while
> > fault_around is 64 KB in PF.
>
> I'm not sure I understand. How is 128KB roughly equivalent to 64KB?
> That's almost a 2x difference!
>
> And readahead, as of now, will read beyond the VMA's limits (which will n=
ot
> be mapped).
>
> Really, it's extremely unclear why this adhoc heuristic is here. A folio =
isn't
> active just because you started readahead for it inside a page fault. It'=
s not
> even necessarily active just because it's mapped (although that is more
> understandable).
>
> And of course, because the whole ordeal is already extremely simple, it t=
urns
> out that in_lru_fault doesn't actually mean "we're inside a page fault" b=
ut
> "we're inside a page fault and this VMA/file don't have any sequential/ra=
ndom
> annotations".
>
> I would really like to understand why this is here (and this is true for =
the
> various odd heuristics mglru uses) if we ever want to have a chance to me=
rge
> the two LRUs together.

This heuristic was added in the original MGLRU implementation, which
is quite a large patch. If it was added later in response to some
specific issue/use case, we'd have more rationale written down. I
think it really just comes down to this line in the original commit
message: "A page is added to the youngest generation on faulting." - I
don't see evidence that a great deal of thought was put into the point
Barry is raising here.


>
> --
> Pedro

