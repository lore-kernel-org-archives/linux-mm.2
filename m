Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD84DCA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 04:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3216B00A4; Sun, 24 Aug 2025 00:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854926B00A5; Sun, 24 Aug 2025 00:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A1B6B00A6; Sun, 24 Aug 2025 00:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 656976B00A4
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 00:18:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D68AF160803
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 04:18:27 +0000 (UTC)
X-FDA: 83810344254.08.FD1EE8F
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id E76D11C0007
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 04:18:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SDsRtCZ2;
	spf=pass (imf20.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756009106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDkfim7mr7a4yUojop8vd0ATFOSgpSTb8reNVp1wDps=;
	b=trgTdgkdEeFlruulb3fnRxvKuZIy/zlQ50LSL4WZBs3EOvJlZBkVThnClKaH1aIDj+1d5G
	lP0Pu3RPn4SzqhL7G1fWa7dZ+uTM/yZRsRQIjelHBsCXHWJLeMXFdSHJer24pmNc4Vann5
	ZBjOlmh0ubdXR8nBCwC2GpDbbjDuWlU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SDsRtCZ2;
	spf=pass (imf20.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756009106; a=rsa-sha256;
	cv=none;
	b=QAnXMXXZ5M2OJ6+x7fGrDJg0G/B4tucwLm2o/mM72GQOyo508RAsxV9VdtdQ8mu1P5E7Ml
	4YHccAsN2k50SRux+sJnJKLxm68QkpkyAjGXbJJ0v5iMLUy7JNH1obv7thhnRqhLiBwB1m
	TM2KsvhvAF1rViAaWQHg9PL8/5Swh0k=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-618076f9545so4881a12.1
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 21:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756009104; x=1756613904; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZDkfim7mr7a4yUojop8vd0ATFOSgpSTb8reNVp1wDps=;
        b=SDsRtCZ24h8A4vHDiMzap2VSh0BlLzuKkYKZW0Ph2gTs87c8RjTvFEq9Ot3WY0uJzy
         Oj1pSfGh611Qz13ZtwMwlalEheTa8KxlkwU5hu7vqIMeXmz6j9QZ5fZd0qTWQwmhgQ2E
         tfso3Mlebi73gm9YQ50gFbtnbF+pC+m1k96Uu5DYxKRFkESr5QSDs9jK6a6FBtNxkKKM
         rnggJzqRJqK+B8Io1Ki1RdB60/qwt7LgR4gvl7Hw7MoSJGTl+DSkaqrIQAPIfZ9uCjMW
         hyzDddYDa9HLkaq0B57a2twMXvxhYbU+iJWxGDSiQFIXrUhusZ9nWc4iTB/r5cdmP/p6
         aKVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756009104; x=1756613904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZDkfim7mr7a4yUojop8vd0ATFOSgpSTb8reNVp1wDps=;
        b=VnNOlct4AqicoH2k7f74wctkoAJ/xO2DwHsCLdRlGOLUjuWw9y0+Ag5b/mrnsSJif+
         4F10k38Vi7R3fn/tj3Nj3e/vGDKLe/unC+VaDGN3kY17bCjmImcL3rgTVbIM09HL7caH
         6SZ05XKCyODZZ2qnV4OsC8J58C4bQ0SgDO2FDNaxS8rhPxGdjPntz6f8oePHEhK095Ce
         9V+/tI5zxxwRyL26ioFc5YqmJT7ltQfi/X0wxtsoTgGvkhRX9UoWC0GPJ3qoNh1hjulH
         VofZnsIWOFe5mCJMVYIjKuSwkTsqbjbv6YepTvMkn4Da9j9XCBUdd1Ice+FvlA+6O4xR
         EUxA==
X-Forwarded-Encrypted: i=1; AJvYcCV6aqoPUnHctjlAOY+ZQqAN9WK6mjj1Gyryk+Guqt33uAjJqhOz1wGA4vBRsGPO8e4LfxH71Q0tUg==@kvack.org
X-Gm-Message-State: AOJu0Ywwr2H47b2PRgQArrh619F8nCm++B3qMzI1WjI/0YnPq+O89RCV
	qmpiKGdFQFDCfzXlAqzBk6XFOrFgph5I7FJ4ZgwZty134OrBsZGjPP9L814TVs7zySJXs01K1Ex
	SuzcW6Ac5B5KXpcugWbvNesjVNkIdrSRrqIt3dJXo
X-Gm-Gg: ASbGncuSRak7IGiLAaeuEmD3CKQUccRCK/3hIQP5RQwRqbm5oxeE4mOJ54hdIElSo8L
	RD+u7zZcbC/XXToJsSF/KMVvTLv/dNfYhcAJmq3M8ruHOL9euPMRpIQPJSOjMIMnP8gx7PYlO+S
	ydgCVl2NiRz38efejmtGY1VcZAOL8DEd1CHU0dapRKObL2OxlQJpgOPVEQIIdaHwb7fuj4F6Bqq
	mE2VkK/YXnzY5+LKKqE6cY2i5CPljMofAwoViWj1PBsAL0=
X-Google-Smtp-Source: AGHT+IHIKQ3cw094VGjPpaAth752X722oMGWvEZSKC7NcrOHJ/wxzYPnBBhd8NLKWJ383A4CKTort8ybeKLqsLz34bQ=
X-Received: by 2002:a50:8d53:0:b0:618:8198:de66 with SMTP id
 4fb4d7f45d1cf-61c352aac29mr69238a12.2.1756009104038; Sat, 23 Aug 2025
 21:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
In-Reply-To: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Sat, 23 Aug 2025 21:18:11 -0700
X-Gm-Features: Ac12FXwhGKxi7sszb9FQfuKpWK6TDNlDZe7vik_4urMen1Es4eNpzZtoyOAFRuI
Message-ID: <CA+EESO7j4dY3KjBWybTG6uQmXJ8kyhBrid3rTk5XAP7poZOhYQ@mail.gmail.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Barry Song <21cnbao@gmail.com>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E76D11C0007
X-Stat-Signature: 89n5ywdr3bicwuj8d8rog491ncf18k7h
X-Rspam-User: 
X-HE-Tag: 1756009105-945601
X-HE-Meta: U2FsdGVkX19RMFV7IsgooyGiLv+meGpZPnrSrtedK7JZh+29juleEFkWl24RKdVe9qeSnoTfla5B7e2qOy+dPZZFRUzesFMOKt0HV16xVeVgWGT1O4qMDmQV+qYD3crIV/gyXC8ny6C3DPojcwk3yPP0T4pq5uju70Tf2q6fAP8JQAYFsswEnV9zHYKe9fSZm8INP5uqXHjAISnYU8xDknxYVCpem/XxNRDQug/TK/2Sy9uvqERzDYIeKgaPEoYtcHbJWDshBWG/njamGTqBBkQ/i4eQbx+v5/uI4pfHYgmwGZjHtsto0AesdPMPHkcl/RL+dwHevMxDuwPkfN7OGIL8DEzRXhrGD8dWZDs/s/FIbOqMK+ZVpBro5mfAekyd9QuAQL1oDmHVdrkvt7Sqg6Laq8EZ9V0tUBDXGgAJSuIU7PUfOjtBs8019PQUGfxZwES+cWqAILe27SHIu5J0OpMZRpL3Zua92keZy3S8vsi2/YUMrAy4oexGkdckKPGaOOOsWnhy5IC3KFTVDAgK/nMuBQUrnmlSWwRzU8mpKkFWf9mbG1x/lEZcgy5AXvcnmGO+3WZx5uK8iniUSb3ILc73mOPn7NLjzwgv9/IxZmnC/6ulFNt9hSXG2j/DpfpWkvpJK/241/YC3ctoTscsmfXQKJdK4bsm3XmIhXYsTQWHiy1P5sDsFKmh3yY38lZp97b+G6CKmYWSbLvlFg5uJZy2jOBkV+bZfVL4vtYxw7e7ckVz+fJ8BgnM4Brb/Xveq3w4yQZIxr0/xH7D16Ax3+jnMMLJnwsz5Qd4eus2qbbKVwiee99T+BqdBl2IVI9wDsV3yRYmEvCIet81lN5j4q6gk+F746iiBfCdhWCtx0w3i9sfz54j0AhuXPKn1JfZSbrPGrL7f7/EvgbLQcf4OLNsC1Kmlu+5M2mLPSOfKBroeZGUaA4v3mzlIRRLuq2/dVroI3dqcU9QBocwNtf
 BbB9cx/Y
 P/CM2gNCgNHpsljEy3pjTVLKxUda8MvWUPyde2nacDOl0LW2HFshoY4c4sgVb67DZGmkP5iBPQjjK663GycUd/Bko/WPjHtgTY1PeTgc6u/vi0U4FGa+9Bo/aoVSVWstZyiBlyOn3AbXkY1TKdAxN2TAPrLHMgDFvjOHQJJIMMkQeACtDqJGCi2pXLL6fFYDB8La0EoBtqvjxNZ/pvjLcEIe6dhPSEEyQbzK9R1HVbBrPiul+eFgD+gpIs4oGvc37lbvl8eGN0wyDuXBCmeF/hCNgIsiHi9z8owAdskssHkmqdaz6gBsEqson5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 10:29=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
>
> Hi all,
>
> Currently, some callers of rmap_walk() conditionally avoid try-locking
> non-ksm anon folios. This necessitates serialization through anon_vma
> write-lock elsewhere when folio->mapping and/or folio->index (fields
> involved in rmap_walk()) are to be updated. This hurts scalability due
> to coarse granularity of the lock. For instance, when multiple threads
> invoke userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distinct p=
ages
> from the same src VMA, they all contend for the corresponding
> anon_vma=E2=80=99s lock. Field traces for arm64 android devices reveal ov=
er
> 30ms of uninterruptible sleep in the main UI thread, leading to janky
> user interactions.
>
> Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
> folio_referenced() is the most critical (others are
> page_idle_clear_pte_refs(), damon_folio_young(), and
> damon_folio_mkold()). The relevant code in folio_referenced() is:
>
> if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
>         we_locked =3D folio_trylock(folio);
>         if (!we_locked)
>                 return 1;
> }
>
> It=E2=80=99s unclear why locking anon_vma exclusively (when updating
> folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> with folio locked. It=E2=80=99s in the reclaim path, so should not be a
> critical path that necessitates some special treatment, unless I=E2=80=99=
m
> missing something.
>
> Therefore, I propose simplifying the locking mechanism by ensuring the
> folio is locked before calling rmap_walk(). This helps avoid locking
> anon_vma when updating folio->mapping, which, for instance, will help
> eliminate the uninterruptible sleep observed in the field traces
> mentioned earlier. Furthermore, it enables us to simplify the code in
> folio_lock_anon_vma_read() by removing the re-check to ensure that the
> field hasn=E2=80=99t changed under us.
Hi Harry,

Your comment [1] in the other thread was quite useful and also needed
to be responded to. So bringing it here for continuing discussion.

It seems from your comment that you misunderstood my proposal. I am
not suggesting replacing anon_vma lock with folio lock during rmap
walk. Clearly, it is essential for all the reasons that you
enumerated. My proposal is to lock anon folios during rmap_walk(),
like file and KSM folios.

This helps in improving scalability (and also simplifying code in
folio_lock_anon_vma_read()) as then we can serialize on folio lock
instead of anon_vma lock when moving the folio to a different root
anon_vma in folio_move_anon_rmap() [2].

[1] https://lore.kernel.org/all/aKhIL3OguViS9myH@hyeyoo/
[2] https://lore.kernel.org/all/e5d41fbe-a91b-9491-7b93-733f67e75a54@redhat=
.com/
>
> Thanks,
> Lokesh

