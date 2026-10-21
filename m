Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A80606A321
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 07:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qvd/yrlh
Received: by kanga.kvack.org (Postfix)
	id 15D8C6B0655; Wed, 21 Oct 2026 03:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136EC6B0656; Wed, 21 Oct 2026 03:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024296B0657; Wed, 21 Oct 2026 03:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEF946B0655
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:42:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CD65C04AB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:42:01 +0000 (UTC)
X-FDA: 85345839642.21.E512F0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1FD95100003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:41:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qvd/yrlh";
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792568519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2W6HW6t4FD7GiH02r1fl3fKehEEk60q+ai1/oJoOqY=;
	b=sBdGA0s0WimgsunEEUW+Lycms+s9bOCG7Ils84oz0ypIezlvnNt65aYhJoED2dO0iZVm9e
	2V3HkC7z+epe7oIYfmxzz2gsRHEraR8vXlb/SaklwgkyT3RSuLxvsz9feKqm/MZMq8HaRn
	rkaAhWilIVKfyz8sN/OJCV/hjuIDh2E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792568519;
	b=GJOf7qKLqRWG07eyNDguIt3i6POU+bOWZfK/ZKK1vKEFmVlpmTnLjMh8YWxN/GW0vpFxlB
	DsfaJXJhKiLomJ/wTv327nv/MIhPFUxAYqWdYtiNBQ3MunRpDvCbEAGqlYW8jXAswg/Guj
	mpmPkNopYYW067FaSBba6UzetKbo/68=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qvd/yrlh";
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F141F436FD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99351F000CB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792568517;
	bh=Q2W6HW6t4FD7GiH02r1fl3fKehEEk60q+ai1/oJoOqY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Qvd/yrlh1PLhc1/2gXQqnk86EYYr9xscm0ZRiFB+pYPkP171xwBa5qs8KA0J4GdPF
	 EaysR9xgCRhsZ+CmxlNq/eJC7Mz/tCuBS/VXHQsJP/PHwTBLjH8Chb89QAboeRvmeK
	 64KfykPHw9QlqgQ1aFR7DlrRdjNLZIDBCtW0p5JIFEOaD3VtFljva5ulMn9X+6C6Cl
	 shw3sIEgkmw2c9qyHF8NKywGG5S9P/X11QBGVPWMNGacDVNzrlCIZLb4Bsa9o70akQ
	 ve9545LYU1TrY/LAyu97+QlshXiZFgvUphPwMYO7R/NrK5ysOWprNTvO86AvFUu//3
	 6K7AJBaQu9hNw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c43373ae89aso49405766b.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:41:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxyV73ZNyybaNkQ7NktzUSyUOdyywP/0vdvfsp46SoFUtxweBZPiVjufnI1J/WtddkaFJ2Ao0SIwA==@kvack.org
X-Gm-Message-State: AFq9FYJL5UgQHCzJX33mQt+qJmskYdU6y5JwqqRKq6l/rlMMAvA9SFfG
	08R3EaYe1dCWYm8UOKwPKlFRrrxToZLN3HXvMkpYvEWQz7BBekQ5Jez2BnPYp4FyiCz/LlQxSSp
	5sz/tCJUme4NJsE4qclIvldTs4ieQBWXspVFgOKt2Ng==
X-Received: by 2002:a17:906:dc93:b0:c46:645f:cedc with SMTP id
 a640c23a62f3a-c46799d0f16mr92139766b.46.1792568515652; Wed, 21 Oct 2026
 00:41:55 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
In-Reply-To: <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 21 Oct 2026 00:41:43 -0700
X-Gmail-Original-Message-ID: <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
X-Gm-Features: AclHuK86lyz-XbdDB6Y-j0ii2s8PEPiP-QfZRMCvGYvdiUTKkHpNlLS-aItO5FE
Message-ID: <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FD95100003
X-Stat-Signature: kchmckmsaaa1um5jxdo8xe8aa4uuuppm
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792568518-481969
X-HE-Meta: U2FsdGVkX19St3HxPk+W9TjKq4kQGDaV71tpHHhorO+LY19p+itYLu+wnroSbIddoEaiBtsTZOuDbhDYPC2HeYW5t76jxX9jRgcC7KhUufq3JAiRlIV2+jN0YtS5Sx5vlB6McUXFCoh2XT6L7pRN8DumbjBVfxsLt7n0s3YFwAxhMgPeiyhydM01kd85TZfTGjtBcOHqcS9c9ESuIhdO0bcyaxCYq1YGPkWJ102Vjbd2R7OlGijSETVqSfAFiD3f3LaL5Olm0QbhPYd7829+VR4oBq5nFS3IHlg7Szo6QGoFSh2bmwHdzC3F5bc02DrTbJnyG9PG5s6dNBargG1zQB5Va62WKjTe6ejZeBJNWodOPVNVlgAeuIRe5N1ZZvpzdCdhnQZloQCdd9CMTmUVoziABzBGpyXc/BZyaovplBesw9VHGbPuF2SxlB2RoO9eXvD4VFc4wa2RQODPkF2Vdj9/SKAmfBPx4Ytd3b4kTgZv+6HbpSrq3x4V57C6qVgPK1+M4/3rU0SfmgVcIMDlFE7kvdNCW97yI2hm+kPCgGqgK93yWkdkTcbiEPraCQxUGUTTDNiUHdC1gJH8ZwB0DOIz+ROVmlJRY5P6l00aZ26cjqkJdKQNUzi09MAPa0sqfjEEfW0pye1uwwk94eydzh5pAsivYVhuRq8w4fZUBuCDITzfRQOp7g/VfjALeANQxiMbXSJ/8vdz0niza/pOG7Zj78C0235Z2e5vyDwCAwlFhv8AkDIKXr9sAoUVFjwLiZtL7N/XHZXd8rTJ1UPsoYOp1V4R4YnqwK6ghw160Ut3MR174V5Y2noKeDXNJ/zbknyIZNgFaWKa1yyE/fYprXWE5g+750RCdad89BNUJAuwgYIbKOR4KtsdnaXD6+dNutAiypHlWw+U6an2URt6FDxH6ZIuU2Ci4CqphtbTpfrvULDLUhWRuhiD4fg7MO/UMMHC8cqPYZ2Pkpkr3ZP
 LlBkFihw
 bokozq4PNQhaj54iTtyds/lySfbcCuNpepJ008PDO7GJg7YqSCguVD21Ic/4AEQbYqQtc/FPO5I3xca9Le1MBXhZ/DATcBpw6s2qpfKv02w0MdRlqdxtWHgzcJcZR/UFE9HFHTKRQVoPqXZJd8nMF7kkrDxRTnL/CCa+j8ffQs/mkvnq2o8jTaQRTEXh30c4AP3Ii1mwYwJJlQP+xCtnyQVqNP+8DtEjswtoCNPeGIG6pFK1XOvzfLr3+TagheSYQXm2G6iA5WVY5u2o1Fy8lsdLZv1GIbHW3XrgX11fsJnydbN3xNO0HzqJPz4fm5Amp6dUAhPjwtNdUXfZN3Vu9MKHyzQZxtSIDrJaN55WQ/41mf9+I+yy/new76oy1b9OAoTP2h0Tb66AcVTWuQzkOrSsIZQ0Umr/TMSlRUeEq19VPDORPudJ6VCFcQekYz9Z1kWcG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/19/26 14:24, Nhat Pham wrote:
> >
> > I'm traveling this week, so it's a bit tricky. I cannot make Thursday m=
orning.
> >
> > On Thursday I'll be traveling back from Cambridge. But hang on.
> >
> > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30a=
m - 2am.
> >
> > I could just naturally join that day.
> >
> > So one day later would work for me.
>
> Would that be too rushed for you? :)
>
> For everyone's convenience, this would be the time slot:
>
> PDT: Thu Oct 22, 5:00 PM

Works for me :-)

> EDT: Thu Oct 22, 8:00 PM
> Europe: Fri Oct 23, 2:00 AM

Ouch, David. If you commit to that, I understand it is very
challenging. Thank you for taking one for the team.

> China: Fri Oct 23, 8:00 AM

Other swap developers: Kairui, Baoquan, YoungJun and Barry, when you
have time, please comment on whether you can make the meeting as well.

I want to clarify one thing: Swap is my hobby not my job. My opinion
represents my personal view as a maintainer, not my employer's. I
consider different users of swap to be my customers. I really wish
some of those impacted customers could join the meeting and speak up
for themselves as well.

Chris

