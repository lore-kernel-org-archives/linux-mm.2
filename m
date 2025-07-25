Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB62C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324F26B0089; Fri, 25 Jul 2025 13:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5736B008A; Fri, 25 Jul 2025 13:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5566B008C; Fri, 25 Jul 2025 13:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07B926B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:12:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 746B5BBC41
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:12:30 +0000 (UTC)
X-FDA: 83703430860.17.29E7894
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7B7A72000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:12:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="XEhh/5tu";
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753463548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LR/1fr+927w5gHz+7V9YvJuD7wXmf2oW8T6mJhnxcas=;
	b=3XUhfmLUVMf18kRkAFcEz86icWjo78RLhgeTqHJrF92ORHqSmFcudnlpQ0kkKdAEolaHMj
	EcwZNZC7AX7G3GMvJiyTjTXrFLgUNsdFTjQLfWc+Qymvoi4xYY7zHgRM23kC1QO1NipW56
	icjsKX+ighG8cj4g55WTZK90mQrdZMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753463548; a=rsa-sha256;
	cv=none;
	b=3s7bUjA1bWpEpGj5fBEkFo/4n0LHb5zdcGQbQIRyq2EgGUItYzO5g5eqqa0MkxwJ2LirLG
	MeSI6rEtXwQoUbFFSyTVcUDc8OeeAnU0IHHLRMPbfvbhzzLq6n74T540gZvLM2lMHT0AdX
	KPuiL69Dx/8l/844zqtkq9oZT5U8Go4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="XEhh/5tu";
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4561b43de62so4725e9.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753463547; x=1754068347; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LR/1fr+927w5gHz+7V9YvJuD7wXmf2oW8T6mJhnxcas=;
        b=XEhh/5tuDTo1M/QiC9KblFnsZageBCeOSoFlZUOKBwa7Mm77ShvWlI9hcBtZODJRDS
         4RcbiiuQnNaIuxPQ8r9r5n2XnlpJu31PSkFg118y+8MNCafUY0oz9FDPtwb8aANg2AoZ
         DIccG5XA7uaX+RiCCqKy+rrKQpUcxr1bkXZhO+wrvurSctTM5+Tgv1YYzNdHCVKVpXyK
         464PZnLACQzuxW3iDE/rd5yZ3u+p2WYe6XvlJ8A5AzJIBdQ66wJjgNFUkRjBgkQcrblc
         1/QjzCg4egDyGPNLLzzO3Xx2D2DAc05ouq8i4kSxP+Q/7AoxothZG/m8ZLmuuPMoEsal
         FtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753463547; x=1754068347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LR/1fr+927w5gHz+7V9YvJuD7wXmf2oW8T6mJhnxcas=;
        b=CPx/wW6vOPesi5Iz8BFJyKpz86v3fGa1STnD/DSorFyczoTE4oH/q9Tgkki0nrhfEg
         kPCZ1aZkxIV5TjZ4QkLGcdnaLGG9soUuAL1qSlJPNxdnoE5N+e3muIewZp33e6X1Uijn
         3OSz2Hx8F6dccKHOmzjjkoz717tqvxVMq9uJoCufNS4LL1ie/45Wc3K6DmVz6ue9Tckg
         mh4NioguSReefhQ7V7cg0B1/QAG9tOZnCVM3TzfyF1J9lN3iQpjH7uknOVPIfswFMA5A
         hWFeTltGuUKZ47JasKdy3sYC+N2OgGt/Td6gKObP3uO/r1VFAd03AoOGdU2NdZnck4gy
         d6fA==
X-Forwarded-Encrypted: i=1; AJvYcCWmtA6S7ID+MLDsiqE9oWjb/Ovz8vvLn7cTtBCZNjIfE4WDtMKLQoTecuTPOcGpo5YesTRaW8qfZg==@kvack.org
X-Gm-Message-State: AOJu0Yx3hpOM/RUEowHuSXaq/itD1Zr+zTzk55k/M0i2pZyoF3gN4UAL
	znIra+5uwpHapc67/i1ueeamfloIwcSsbucoBuZ/7Uozzw9yCxGGEClD0iL69Y3pj/Wv2/UZKb6
	HfPFsFQFOf/4bpsWkvKkXf2BA2pVQiBCkjvMPnp4f
X-Gm-Gg: ASbGnctsd8zAttyPVRZGKHE84KiSJCAr4EG+P720k2w1fHcHCzXRpwmMXvS/SGhJkmt
	3FFEztSytWluP+e8UnspmgD3wZDsYlYiJp3mZrkMnbKCQBrfGvRBk+Rdf6uQbFyftYkvCqu3eQs
	xUeSJMSZP4eoUnL9SDPu8URyfwbeDgqyMFFMnYowZZutmdW/+g0nrBVQAR2ykFPM+udzgfLHmIG
	D7gp6e38enEiX53orJqWQoDaASsydBzxhg0rHnz9428+Q==
X-Google-Smtp-Source: AGHT+IFhxhJzavWiG8TnAC5bSyEUCITgigk6eSOkbePzjanT6OdYE8Du+O+akeu9UoPZ+9VboPkoI9eK3HhR7G1bjjE=
X-Received: by 2002:a05:600c:1c86:b0:453:65f4:f4c8 with SMTP id
 5b1f17b1804b1-45874e2b93cmr1367085e9.3.1753463546532; Fri, 25 Jul 2025
 10:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752232673.git.lorenzo.stoakes@oracle.com> <8f41e72b0543953d277e96d5e67a52f287cdbac3.1752232673.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <8f41e72b0543953d277e96d5e67a52f287cdbac3.1752232673.git.lorenzo.stoakes@oracle.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 19:11:49 +0200
X-Gm-Features: Ac12FXz5v7hwHYZVZo-PcQftTdDT8-58CkHFg3QHIWJWk_i7JJUmY1B0j5KtsNs
Message-ID: <CAG48ez0KjHHAWsJo76GuuYYaFCH=3n7axN2ryxy7-Vabp5JA-Q@mail.gmail.com>
Subject: Re: [PATCH v3 09/10] mm/mremap: permit mremap() move of multiple VMAs
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7B7A72000E
X-Stat-Signature: iwescg8jdyen4ttw1ot377qjmpyd89jx
X-Rspam-User: 
X-HE-Tag: 1753463548-446302
X-HE-Meta: U2FsdGVkX192EQTGv50D+Qt4JETm6fUPtUbAHXa+iuvOAEh71MclUG2dGUqY/km1tLB7xdROl/KO/QbVN+Ea+yWUxsfwCOfrhDgCTe11AU/xK1j8ToLOKseSiPO7pR5cu4l8VSTe+9qE4oZrtk5uYSlkpepbMZP/USb9toYtK1it4ifJ5vyjjoi/MaWw4n3SIF0rQ4+Y9zDqJ0cWHUQqdy0m4+agLJWaDcD6OraI0fzBNKj7tT9j7f9KUd6YO2I6lWP2Fm04hlXtU6ceKDLmFxO4V/xYuiaUiFkuDmsasK0iTrBo2qig63TiCmptpBWXQzlOfsF0rAgCRZLpdSNPt85Ql+gODWEHDN3CpsgodayMPbJI6jxITn1SyvrHEm88vDx0hLtftue/2iVIxWjkzkP6dIrNF/c6XniXQW6pP8GxlFcQFCnAmdp6vDcv1VQj4z7X9LOYhnP1vY3C6ipOaqu8w90j+hQn2T7TeYbGx14G6fg4nQ4BD/VoGC3amMwJ12uWQQ6MZhIIjfw7FIxIx2/AGJJ4Q7a/V8DIeZvPU5zZaAuGE0izD9boK4GUC5a2jbT4TOja5GG0upI7NPwyIm0VvbgSerQZysTU0XYP6hfDDtZuaDfLpY9DJwe8ScB7iBet7RUH4FqtuUBXFozAYSO4UiLJpDgU71G8783corUCiduyAfzEMsQ0wVuxta84CG2gjdGMgdWkSsPx0btnk6OGTEJK2oi155ZQiDKp8tkLdACMP/1EvnZGge49YVPj1HR/M3i15XWfjum8r4m6UwwMAp5v693Q/NX23RIpwtEks72I1qZtcHERuhzQZTDJkqhueO8vpIMe9i6PrS2lELyg55A6ArwWVTUWBYGPJ1Vec62Q3rFE+oy/SxsXaoNVCljO094R2C5+p+jA0AKQUJsDv+aVMyxvYIoyEDcpsD87ZOIp/cYzH1vaOEPOuOJEv+pxVb2pL5Q2P6jAexb
 dShom+eY
 sI092O6P9x+U1pds3ch0qN7h6IWUGrSSM62N0tB2d+J9nzF56zEx4JEsNqpN+OKfYogxNTgaBRCFz0MdkvZzLYvgCArppdKmcn7t7Aj1sGhgFn/DvtcxTqQm8BaBkqVO22ERGMYrrnfZE6dqJlvHbQltzxcxNDj+KVERmyq30EjYXqEKy2Sh4S/sREA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 11, 2025 at 1:38=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> Note that any failures encountered will result in a partial move. Since a=
n
> mremap() can fail at any time, this might result in only some of the VMAs
> being moved.
>
> Note that failures are very rare and typically require an out of a memory
> condition or a mapping limit condition to be hit, assuming the VMAs being
> moved are valid.

Hrm. So if userspace tries to move a series of VMAs with mremap(), and
the operation fails, and userspace assumes the old syscall semantics,
userspace could assume that its memory is still at the old address,
when that's actually not true; and if userspace tries to access it
there, userspace UAF happens?

If we were explicitly killing the userspace process on this error
path, that'd be fine; but since we're just returning an error, we're
kind of making userspace believe that the move hasn't happened? (You
might notice that I'm generally in favor of killing userspace
processes when userspace does sufficiently weird things.)

I guess it's not going to happen particularly often since mremap()
with MREMAP_FIXED is a weirdly specific operation in the first place;
normal users of mremap() (like libc's realloc()) wouldn't have a
reason to use it...

