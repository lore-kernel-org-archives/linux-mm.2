Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A8FC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964676B0088; Fri, 25 Jul 2025 11:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9145C6B0089; Fri, 25 Jul 2025 11:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803946B008A; Fri, 25 Jul 2025 11:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7D36B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:06:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12769133F07
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:06:01 +0000 (UTC)
X-FDA: 83703112122.11.B4E04B8
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id EE06218001C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:05:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wxdaiu9S;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753455959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rErd0vkhsR1XmIOg+rYxKzdEiWml1C8S15zNEY6SQtA=;
	b=bMTLaLEF3noIW6JOuRWmzYgvbR/QfpFAgVyNFB/qIqM3lJuHy9KRrdKorx8ksS4uZ88BAe
	rwJiLu2j7kK1sFtwknNZNB0YaRRPKBednt6DoKFA1EW53NtImM1vZ79ikbM2YrzTSCRzmL
	UUB8cBf+z27MGsWIclU+eM4Qzebun6M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wxdaiu9S;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753455959; a=rsa-sha256;
	cv=none;
	b=mVT9fjfN5WvRDBPfgxJoBEzTZGjGRtYPuOvoOScsiG/XdK4cqYOnh3VmGNWtAwFWPxHNpc
	zU+F4w+vhV2VSiJpCXKMUIyLvURuGQMiPu9Hc9gUFySWpyNdXAGke0lj07qSQkmm98PMH0
	35ihvLwnq0TSryBpykjIfwN09viNSDo=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so9130a12.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753455957; x=1754060757; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rErd0vkhsR1XmIOg+rYxKzdEiWml1C8S15zNEY6SQtA=;
        b=Wxdaiu9SxneJQWBHUhfg5wyn7u9+fTxgf1mITKJIcToEWS21lD+WFakagwEFoMthz8
         uhcFUJdnmK61oCvxiGl1ABqq//Cx9Rn1H1s8LuM+lnjJI76RIbntUIQ5QSCfsMd6blKd
         HSpTbBoRElFGtnP3COJJpDXGS1XrFCE3gHoVXYTkPP0pyqEl6sXK/2QpprTNvCI3dnOw
         6M4k28nFaysPJuYHplouFaIkkEsdGaCjrOwOzgTDGjojBt6A6Jex4lqGz/b5QCLRhpVK
         Z7p/D5gfHoweoEpqZQDdmXBlMyuyBHmm3KeBin1ReWZVJD/Qm1boljjQbd/GPgqTO5RF
         9srQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753455957; x=1754060757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rErd0vkhsR1XmIOg+rYxKzdEiWml1C8S15zNEY6SQtA=;
        b=S1HMNd0uxx7Sep8hjERBSK/iGcq5fxPWjnsR9qAL3b/dGmPKM0RAUSUtupOZuosHu/
         l9Z/6jo5zcYoeASAaGRCbIu1edKIP6S9jbUfveKDBnFI6XJkuz0DmP3kB+V0pQvJvjC5
         KKLFoRAICSN4JNWYuFWIjga6o4mhaQ1Q1Mog4n6hCeY9Ur+PJmEIc3g8MKjGwViy0QY5
         O+mbYY/pDSS4SP6I/JSq/GRP6v4AJB4joMyrI1WhH8QOoDEhF/QANYVosCRcF4jAyBsd
         6M5OvaCWja/BSYCZzMnp7OeZSRV0AG4e6AOhX7y5jpSGHM7yjZa7I7a3v3m+mxgjX9Lu
         dy8g==
X-Forwarded-Encrypted: i=1; AJvYcCVl9l47YCsd1A1Y8mnrh/rGga7+98IDlD0KhHyXP1yqJ5b36lEqYC4bT1UmDULo0sUgv0AmXq5M7A==@kvack.org
X-Gm-Message-State: AOJu0YyiHE1j0fUisG2+Ej6CWd19wP/1ZxKUnaiFNNcCk3l0c5Zo1mO+
	YXQ60tMeP41YaUft0x8J7NxQ2sDgcMlkA0Q+33hnlSBldUmznyn/4GMM+OM1YOwRaasO9byWWRA
	l91gyx5h1iAZWLOM0iDPBnbJi2CZTheWP6DXYbvUn
X-Gm-Gg: ASbGncvC+cnnLUH6lCU7LP3fhY4oM65n0r9HG0ZrMrAnJ4BAPBeHa3aJxd0kcZl/b2q
	v+ZhZJWFvB4BUtYgsYNLUyJLNMpHBH6QjAFDdyTBmrKvuMvVU8ND0MVaZOihrWn0BmSLS+KePeg
	LCLmPAVeJAAJRh9MD+rC3Cyn7OoND4zGd11udyVWEwhFHb3gUFnjtu+NXZpgCGD/iif0LkdLssv
	Xg4NvAoNMTliWr3h1syop0lbUqUgXFowgk=
X-Google-Smtp-Source: AGHT+IHKmTAh6R9iL1rXmus18ijLt7akzUMY8n4NFgDtt7glpVAkbORlhirtQCmpctVgDPefYq2BoJRKLakx8bv1O3Y=
X-Received: by 2002:a05:6402:26d1:b0:601:f23b:a377 with SMTP id
 4fb4d7f45d1cf-614e7ae014dmr107087a12.6.1753455956695; Fri, 25 Jul 2025
 08:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com> <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local>
In-Reply-To: <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 17:05:19 +0200
X-Gm-Features: Ac12FXyGb4LwzMsyTvXuiEhGWpmeWzqjrsFRFJQKk37LuQHffOa-CjtL8QZoktM
Message-ID: <CAG48ez0fG1vG_MHnX_GXJG7qZc9XwMxhTqyu9YJpCeKEUuuZBQ@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tw9hccnpg7cpb8k6dygj6ahddg9mopad
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EE06218001C
X-Rspam-User: 
X-HE-Tag: 1753455958-78618
X-HE-Meta: U2FsdGVkX1/79ZLEK5/OyzKrpusSYLZ6qiNoxs0H8C/lB/giuH+30TLQrkU80YDw8Clhx0vBHyynxHwyu0cNNbdM+58hviLcuS2uQyvIhvDK1bOw+2Svm+g1iI9QvXANNiAihzNRpn5fdUBvkT5FNNGyDGZArXYZz8SB1uPqZNbpelvrroe7VoVG6wgCIIiLwWLnu/3agtTfta+kPYdm804/+lPIs6W/jN32P2v0F/6zEWUbMqZ3GFInRc3DHipNCJj9H+GNbBont9sUq+yFPFXT+MXMF0Or1vvGdW1W1mKrVWP2rKws5lu1w28SHQ0moWXFEKgHihU86shPVsOSfpZXtuG35wyh/wCxYLS96Q5/ciVO329ndN6X7lB8Ucyf0MUWcAl5O2NnQwGeJvrbBtus6IrcjnW3lWniLd01izZ+WYbWBGCDbgjS4fVFKr7Dmnjpnhw+qdqk9u0nuQQW+HvbfFrFpD3lUaCWcc5l9yo0hlYsm+78l/QuXQFetIW+JBB4z+hVc+ottDbeV05KDBF/0QKf1W4mroWU3Wg6RkDLkTaIsMTvPvErsxzHJHnH3ah7uU9IAezByKFooZgsc9V5p2b9le+fweSsQx2D0Qg4xUyX7tAeaKfaMtbdVkH3rQwFftpqvU7zEcPBoH3hhGd/gQmdZrYTA3l5/nLPKJc/9EZzJq+B0G5HDS/V3GX5pO+154rANadMkSPKIMQjxKCd4dAR6NGFzoKjgwugzY2Ss8qpjF5fVdpulvp9NOo1b8iwep2fnP2t1Ha6ZTTfwOgcruUKegF6cMiMLOo1x8rRzEY3JWj9Rx9cAtxAGPCSeAYhK/bzGUz1zNGv7f9RQ4vR5Wy/e9wEqKr7jK+fO/pB1pXQr7lSP+4feHN/G66Iva4+uA2JgJEsuHB1XKAqh0SV7RB2uCmmixw9knGYk4pg4/okY2XXb88+q5Z+g3EvnzbdFGKFLCC2UqP7Lei
 tNO6iurv
 4B5KbCE3WJLT9sPmnz+CN7v8dnl0YBIh9QdNcdQdSrWuTZBrV5q7WBiPZkfvUZq8fDlDr9hgUuTpqQnSLvy8IRsgXTxNyocsXCZeTwN++jv6DyI6j1hxLOi5JJZtgCLlvKWc48qIcwqYaxb4EXKI/S9cWOnYDYEEOdO1EjtSZLmSk2DwZyt2C+9XV8d3fFu92c69LZJqRGNqTkCiwakj9IciNO2FCJ9RhstNPeG5IuBeUf1V1NMA7ZtcrIne3tferL3deIdHvq4mWulTxx2t4bvZYR36FEnFlT6SHimcoevq/gCQmCcLN4zXgNI+YzYclflbKM/lGzGb6vx6uafVCnG1Dq2x3pKE3UsQT0xozszw92Ab6sPiOE7LQhH47yYzrfOcx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 1:32=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Jul 24, 2025 at 09:13:50PM +0200, Jann Horn wrote:
> > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
>
> Will try to take a look when I get a chance.
>
> > walks that seems to indicate that there can be pages with elevated mapc=
ount
> > whose anon_vma has already been freed, but I think we never figured out
> > what the cause is; and syzkaller only hit these UAFs when memory pressu=
re
> > randomly caused reclaim to rmap-walk the affected pages, so it of cours=
e
> > didn't manage to create a reproducer.
>
> Fun.
>
> Please hook me in (I mean you're going to anyway right :P) on this stuff,
> as I'm looking to rework the anon_vma stuff so am naturally interested in
> any and all rmap anon stuff.
>
> For my sins ;)
>
> Maybe I"ll dig into these syzkallers.

For what it's worth, the point of this change is that hopefully we
won't have to dig more into them manually, because hopefully a few
days after this patch hits linux-next, syzkaller will present us with
a beautiful reproducer that shows exactly what went wrong... or maybe
it won't, I'm being very optimistic here.

