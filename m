Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2476CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 22:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6A18E0219; Fri, 15 Aug 2025 18:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377418E020B; Fri, 15 Aug 2025 18:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2665E8E0219; Fri, 15 Aug 2025 18:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1660D8E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:44:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CA4C1A02E6
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:44:20 +0000 (UTC)
X-FDA: 83780471880.29.37802C7
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id A25FC40009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:44:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrwYwLNq;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755297858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tTA6yJIOtlWQkvlonH1750YACaxZzCjwRS/RL+sSwo=;
	b=W+ZMJGuzeKDRFnstzQCCkI8/CJqKt1OW1Y+iIv8gueAKHpiYwRz6wUNhkMwYhrX8lg8kt5
	P0UeI+8fu9y/j8d19thMvVjRBO34JMSX3QTqNJgjDc3s2oQJUUQrP50Gc9rbyRCdM2cseK
	kYz0TDJGXmjf+1uuP2CtboBnPcOt/Gw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755297858; a=rsa-sha256;
	cv=none;
	b=HNXucEADqs5aqlCOgl7VEgoxKgB//KIVBdu1dTH48OyDEDweRkwMxvIhT4JVhxAb+Dt/f3
	h1r6WJcxZnpl8zFrx6MlTCiPuU3DcHMvZxOjZjIS/eSoFPAvTstkjj68psA2MD8LMOKoT8
	jbDgcS+4Z4P3GgMFX/9ljZ9wPS1CAcQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrwYwLNq;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 83F535C6DE2
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331A3C4CEF0
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755297857;
	bh=9tTA6yJIOtlWQkvlonH1750YACaxZzCjwRS/RL+sSwo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nrwYwLNq6obtaOcAeQJETd31aF5qOwZ29gNOePVxAhtdUgXXiNzVhcmHc4mpS/g87
	 Rvu6hsVEB1lvaNE1dqFD03g2+A881LzqRMHamyutxCBfH37K24ZgFsH2CKx3IAG/DR
	 TB7Kee6zGgyFSM/vUywoPUT3VgvHjRXrpiBaV4dzj0Cba3GQYGEJ/ItUeDvjlxpr8U
	 h4qTpM2kTLbSIutNYQDN4EIlE7LqnHLFf5XUiUusx4rpfCYdR6nDWfdMPt4lspVyAg
	 BQDRv4Hv5wKQMaHfFZjpabmPKfFLGI+b1uOCnSELgvmSKj5X4QO4bXQFP9dfo5SfL3
	 EImgnizCEr6QA==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-459fbca0c95so27165e9.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:44:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXrHMgM6505klUt5XkDBaia5zoFa5OeQYNzJkVaRy6kEneIBsqzPxp0evklnodfIdbLSLvkn7xwsA==@kvack.org
X-Gm-Message-State: AOJu0YxYe2g3HqY5SRSDwhA6AjuhhBqqEgn9QcjCHvM4b/XxGh5mBC1s
	/ipjETnuEYBRPTY5X/b1Ci+iE+JiDD3F58UOk5mHrfSwrxN7iT5ayEN6YUgf0HPscVKuTpzoTzE
	KFycrkIPIIL6AIoCYnWo9KdJuuelwQ8Hzr3Ke1WjT
X-Google-Smtp-Source: AGHT+IH9vGzl3bcxwUyHPIGmATEV+pnZn2h8s34m7GIclnBfw/NfozgT5mRmpQ/m1SRogiZqfgbxVtuvvSH/aE4pCKQ=
X-Received: by 2002:a05:600c:1c9f:b0:458:92d5:3070 with SMTP id
 5b1f17b1804b1-45a26801babmr454725e9.6.1755297855930; Fri, 15 Aug 2025
 15:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250812170046.56468-1-sj@kernel.org> <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
 <uo6vtumoy4txklyqy4njitf5ex4eanudncicbbzknmuowopd7v@jm4ao4qapiza> <20250813204844.GC115258@cmpxchg.org>
In-Reply-To: <20250813204844.GC115258@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 Aug 2025 15:44:04 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNO1Ci5Y=yd4PtF9RnnNyeAa7t4e0vf3Za9g_KhLw3baw@mail.gmail.com>
X-Gm-Features: Ac12FXweB8Zkmz63VXGq4nmR_WdHvmURbsDA0P--X2Kb0f5RcNrdXJuFJF1TRNI
Message-ID: <CAF8kJuNO1Ci5Y=yd4PtF9RnnNyeAa7t4e0vf3Za9g_KhLw3baw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A25FC40009
X-Stat-Signature: tthfdkcshcfzoq1h7prg6tq5ekj14xnt
X-HE-Tag: 1755297858-380647
X-HE-Meta: U2FsdGVkX18iqZk25rUrRD2fPkmUAh8mOWgxyrc6Rpp8aGjlyoGzwgR7EPVwJJ3sVxLe0ry06I1vadsoL+XjNExBJdDGGfhj6fgfu2xk3EaewR72CDwnNXb1u2HDXkpYA5O2+BojrW875iivRldaW1aEHxdT2Fhik0tdMiTF2zmmRsN3IPTWVV/K8GqNzqOvQM0kz+UR706buUNcZ/8OL/1h8drIPFVp34NatTHVeVTlsxFAUiaNUT5a09Yu/1Kx3TL110dKFqUdLN0ZHkpidEBl+HDf/747cTtwJos0MMQoY0zwus1NyFajScqB+d6kLIa/HqK5+eIxgFAyj7oeaWJU/UIWiu/NT582We6le5+mqu5soTSgKnUrnTyPAwrn7YqMYrwRsGXvH2SGNw5kLfSUBttNd62ZIu5Wqy35avf2XAPmHWjZyyFo8KndbT6b4GI4Fyq/6XW5X54ISjebLfPG8Txi4yzh7fpNcuTzuZI9rAZzyFD03l/6eRaCtMRI/fYmhweZYYxdw7lCfJ0z/UE7I/+rjeXt/U/WVjs6c8QVXLCrd/tmUYTGFjmN+N/zHAoKm00B/8uwZMxecXlZuYFIOGQOIrwWlSDOijJNQUGXemJ7tkH7pxkq+MZzovafJ5SAP5ewuaxbxEnmZXxGZcuE3ss2nNB30qgJx5ucMSwpPkPsLtSziYD4sY9d/WJ0O5FC5VT3VjVQXFaY0jyWmkQ+jhBAnYt+s9gpYQPk7LEmPnOGz5zCggttUAxo6ydeD7FmVBb6w4rlwfQm31FeyicW/C5fQ2lq8bl+j4tVUdzzrcNS+RpR260puRPyqF3BZrYCFNWuOUvJxqnSKmS02VI9wc4ufAw9srU0kyJD+TQshGkfWAA5b7K9OLhUD277heIkY0oZWsKG+8msRvAddD4f1tKbaixV3iu8ozjdj4vCR8L+tzOzUPpTQP9gaZgRP8sIs4yfIxvHZQ4iemm
 XHWeGoB5
 LVyKOQXr7uo9Z+r9SZtL1pGEAnwtMMkYG+0lFWdtF+mM3yxmutcjmvN5ARq07FUAClBbmIen7Qx0SxLZ4Bvri1U2oD6rkHtSGrblwNUAc17Nh9PA18OQE5Y5hCjrzt1fGSdg9UiCeL8ujsYFvO/NskF+jYAkUVBG8fpXJwPUhVTQo2xqvIvi0RyH+udOTgjpS4vzHILg1cwxA2mzG0XjaMIE4mvIIP3oU8/qR7qNWxfeiLZQnTgBiKwQZrzigmivRs+7Ll7kqkQ2JF5SrqjzPdIEhhDl5sZlorPqQrI9RU2m4BoUqkllhXmbeyxyR+qicLHqZWUhLDNTKAViqstbjD19Mu56tD1m2mOfhs3qmssFoXT78CWbirw9GuPPJFPPxhqUJAy4iq4RksDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 1:48=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Wed, Aug 13, 2025 at 12:42:32PM -0700, Shakeel Butt wrote:
> > On Wed, Aug 13, 2025 at 10:07:18AM -0700, Chris Li wrote:
> > >
> > > If you store uncompressed data in the zpool, zpool has metadata
> > > overhead, e.g. allocating the entry->handle for uncompressed pages.
> > > If the page is not compressed, another idea is just skip the zpool,
> > > store it as a page in the zswap entry as page. We can make a union of
> > > entry->handle and entry->incompressble_page. If entry->length =3D=3D
> > > PAGE_SIZE, use entry->incompressable_page as a page.
> >
> > The main problem being solved here is to avoid the scenario where the
> > incompressible pages are being rotated in LRUs and zswapped multiple
> > times and wasting CPU on compressing incompressible pages. SJ's approac=
h
> > solves the issue but with some memory overhead (zswap entry). With your
> > suggestion and to solve the mentioned issue, we will need to change som=
e
> > core parts of reclaim (__remove_mapping()), LRU handling (swap cache
> > pages not in LRUs) and refault (putting such pages back in LRU and
> > should it handle read and write faults differently). So, the cons of
> > that approach is more complex code.
>
> What Chris is proposing would also fix that, even for configurations
> without writeback. So I'm not opposed to it.
>
> However, for deployments where writeback *is* enabled, this code is an
> improvement over the status quo. And it's not in conflict with a
> broader fix for !writeback setups, so it's not an either-or scenario.
>
> Specifically for the writeback case, the metadata overhead is not much
> of a concern: we can just write back more zswap tail to make up for
> it; the more important thing is that we can now do so in LRU order.
>
> The premise being that writing an additional cold page from zswap to
> disk to make room for a slightly inefficiently stored warm page is
> better than rejecting and sending the *warm* page to disk instead.
>
> So I agree with you Chris. But also think that's follow-up work for
> somebody who cares about the !writeback case.

Thank you and I agree with your assessment.

Chris

