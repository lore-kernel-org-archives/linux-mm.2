Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F0EC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56186B0088; Wed, 23 Sep 2026 03:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07076B008A; Wed, 23 Sep 2026 03:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCEBE6B0092; Wed, 23 Sep 2026 03:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A667D6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:44:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44B461C33FE
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:44:53 +0000 (UTC)
X-FDA: 85244240466.09.5AAB615
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5F7451C0007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:44:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XpkRIhER;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790149491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYrLhfZTuLWO9786X74rj8Oc2nWE4LCd9wsqz+3EZTE=;
	b=difnmGJHkAxCkT7PlxCEWacFkN9SRvbTM/xS1hHBKByBOd8piaHo8Bu05VUepmak6FQMNR
	yr5B72cND/dfISDolkwnCZ0vmKGAeMEsuIaDfu/pxRa/QoQyvWF/HoF7yT7+E95HbomzdC
	ErWB7663WYlotDyCFtZrt9uhdUCkadA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XpkRIhER;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790149491;
	b=TkMsggzpD8Q3ZPf1GY1sOMdBRaqtBGAfsHDKVHpYvmzJB2+AUGqM5Cy2hXk7UJFhTxzNlZ
	3w72DDR33I7vGIK/b6qqbpM4M8nmN0ZLMBruFQvwljkRyQOWhcGxyMM7Ut2hTwFzEWSBJF
	lf9LfPJ0MMWeh2w3u3h9zYnjK+I4PK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9457543ED0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C741F0089D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790149490;
	bh=NYrLhfZTuLWO9786X74rj8Oc2nWE4LCd9wsqz+3EZTE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XpkRIhERG5CHFtcKDo0+j+mrpOsQ5yfCxODXBVvkHiTrWmVDnzG3N+KWJIak3vsOA
	 YA88ByUfUJovQXCLTrb8+cdfVg8nOxprF/lMcYKz7YCSfkOyesbhpDv8G7nWIyo5Gy
	 Go+WlNr81vlTZoxWABvrIvNFB8Y1gjfhamsvQoYaOv84fcqK/c2M1v4Ed/PgwIQTwT
	 YakGmc9iKYpP9EOMcRjYOop9Isez541rkojict/k7QBYL4dZReyYiLefH2koBeeKkB
	 g4QHlY90xLOGLgLyVXAv+9CzUuwD82OPAqV7gcu+FROdUt8z6gBQYnOqn4A4CjXUzr
	 qCwAQX+H3T+zA==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab201ebso627077d50.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:44:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzZfoYYdUXuHy9HXpwau0W+VMxmghJQa/4kOksN8dif3gZd8VRXUGN+Wp8bMfzWGfV+I5mJSjYarA==@kvack.org
X-Gm-Message-State: AFuF++l+6Sx28wAxp/sDEmUugO6xfmd7TbVpYuuBrko/JTrBzYWUsOOx
	GrgEFpzpqZBAq/ckIUzWNv+VCuVJowRjjU2HqYHwvtO0FHajoYuM636pnqqS2COL9XGGzNbOQSV
	OhHuxKZHQDYkLyEdYhxWI8Ee9fcx9ZbXlwetQRp+5wg==
X-Received: by 2002:a05:690e:450d:20b0:672:99e1:11f4 with SMTP id
 956f58d0204a3-672d59729dcmr476582d50.145.1790149489550; Wed, 23 Sep 2026
 00:44:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com> <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
In-Reply-To: <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:44:37 -1000
X-Gmail-Original-Message-ID: <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
X-Gm-Features: AcwNN1WZdLmRO50k_DT1C2XXWd6awldXtQl_BApHlgNKLP6uIu8v4FQYJXq3Og4
Message-ID: <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 73wh3na5ygw5bkf731ymyiu49u41sbpd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F7451C0007
X-HE-Tag: 1790149491-800383
X-HE-Meta: U2FsdGVkX1+D1WyMph5fviFxqrjUMrj4rHJTu8T4MSfjIYNYTbiXd1PlaBMfQoq47jHtH81zgthivAJLRa24mRJVx1H4WWsp/m9IGWaB3DjyqqJ+bT5B5v8/bZvYqFVSEs/e4gkmmYkDXtMlwDlb0w+5snKB5VJsxM068rqZ87aPcCjigDwES7+IxH69mB57rnBlf99er76BUkyZGo2rSat6DpvZXAv1wOrCQ6gighs8kAmDIogDxlGa8lp+dOkBYZGATciKUKFvD4Y7FJ8grv5DkgwKopRR7QRZw2Opsj1Bqepajz8nEKCk+OZWYx9kq64QhHHWnbKcvQKuYK+fNdqecYhCNAg+7uaWGm0Goku6aRA55Y8tT2jz/+qP/MqT6DDzJ62546wdfEOEEAXqM3qsWUHcx5ujrvTz/egG0Nj75e3VMBYu6QZdRNI2gsx1qRtqiPvY3Xx9UElqf17aV/ntGt50I7iYFqL+sgJ8hzB0BDfGI9MzlGqvArE3m0WeKgtPzPRW2V0ouBSUhXhbVAKUN2UgndZa4KqqW0u9epPURqtj7qM9iBRAKf/SvG/Q8qiQPR7WXB98hZXSkTDJCoJUgLtGxX3ga7MBXPovQMVwJ65zMKS2HLqn33Qq0mPqeL07UF+iwR7XumYkOHocP/k3SryFtAq1PTxOnY44t5Q/vSQSjlcWWcyzJW96BaLjwOcRcshysabUl/Iv0FYktyosP4wHzuisOnBmgJw/eRyShGyr+KU6yk9BkexDQWuRKPHn+YU6AU9Yxpzz3A7qBDljcYmWC7Nx8FVsWxfenE2+k8msnXmeUWV9hX7tx94AVqF6zDnkXVWBcLJ1Rk7IS5dK/8J8HF8xrhnAqv+WhnyBf5HHQ4Ackd/z1ZNBHdgMR0Hy8bI5lV8MFDliZQAwWG3k9YprTAjmk1viYNzRL6eWB8H0jwyIxS6ouoOoQqoCxIfwwd5HVivEQ9ZZEod
 GJp2x2D/
 aT58L9KwGgGdPRN+XAzXssBJMLeRUtNkIKjYpWQ9OMJiGglnDjVc20TMiSnPh52iVh1nXb1pXllCyM8qM2eMyTikcsHkc7mug/dcx3ifATiEDWNOASChCYU2QPY2xUduBjKV+LBB2HWM+PE3WE/grbN26ZE7S9QD5XUmPbIyhQ1oeDDsrtMm6Xc3xSG81OF4aovZ0EKkQArbFC71pXa/OvxrBxoxf1tFXLBhYxSicohyPMYLRkYdqLC0uSS82waYW+UbHQhvzSMkNO38kMdJIeF1zteSEaztyil/p2oGeMbitASmNaOB0tKLEqtHgGEeX6J8FEMsPnQS1E21pB5ZOsDiiF88kQQWFiAvf+ri7RKsc8+zZ6oJjVeerI+Y7T8K89fcRjfqVq9t1+viZJK6fedp/i9L4ctnXvOPsFUrwR96VXHu9Spn9UcAPYNNE/IcyfPLs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 7:54=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Sun, Sep 20, 2026 at 5:13=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > That is not what I have in mind. The example I have in mind is that
> > zswap is charged to swap counters. Changing that behavior will break
> > our current deployment and that of many other. Kairui give some
> > example as well. That behavior should not change.
>
> We already have a knob to select vswap. Users can turn it off
> initially, and/or update their software to handle the transition
> based on this knob.
>
> Otherwise, you'd never be able to introduce any behavior into the
> kernel. Hugetlb accounting/charging is a new behavior, and there were
> softwares written before that assumed hugetlb usage is not charged. If
> it's not a good argument to block the implementation of hugetlb
> accounting then, it's not a good argument now.

My original intent is that 200% of RAM for zswap is too much.

It seems you are talking about a different topic: the vswap charging issue.
There is a golden rule that we should follow: don't break existing
users. At least with the same persistence, this rule should apply
universally.
In the swap tiers discussion, the UAPI was such a big deal that we
couldn't implement new UAPI. On the other hand here we argue for
liberally changing user-space visible behavior.

BTW, I already shared that changing swap counter charging will break
our and others' existing deployments.

Chris

