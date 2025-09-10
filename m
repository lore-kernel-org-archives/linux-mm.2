Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1648CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C3D8E0035; Wed, 10 Sep 2025 12:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB1A8E0002; Wed, 10 Sep 2025 12:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001568E0035; Wed, 10 Sep 2025 12:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E106D8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:13:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BD09160117
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:13:59 +0000 (UTC)
X-FDA: 83873836998.28.3D27F51
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id C250940002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:13:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HujXKv1h;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdiDWwxajDafGytCRj5Idko5t6hGYc52LVL1KdhcrAU=;
	b=7vte/6JcDm/wRQod6OPKoBcyyjuYTIfh6tTdTfd4sACGAnKWjZdas/6CyUhma18jr1mw/m
	WUcG4WkQMUExLJahOnf46NdoPih7FPwpeheVHBaSc57rJXLMKiXZrbMk5d+id0IxbWZ890
	oVbTsAqMNLyn85rqux3n0cjN2JfMoVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520837; a=rsa-sha256;
	cv=none;
	b=q796nrY/UFDUtPl8mP1TNR7RUTGKUkrQShD1iLGKK25P1Hh+nb9sRTVXJqzqXCEOfo0Qyv
	Fhkz2PkVVjOJFlO3pke5hwU9+HtA582nu9Vl/7EnYgI5NHUJFq9xL1o2O25Oq7ZCAutCcK
	c3E4Egkea9t0BcKojDT80ZE47cZuTKU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HujXKv1h;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4c3d8bd21eso4570338a12.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520835; x=1758125635; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdiDWwxajDafGytCRj5Idko5t6hGYc52LVL1KdhcrAU=;
        b=HujXKv1h4R6W/gZy0uTknG+tOukCqOES8BS1stlh8vIK0J0wxIzmHPdsM0lFWsNv4X
         5LyY46Qw2Z5Xs+YexBaM+THNm3F/efrdtTMu+01osAqUSexbmJyeOFySSGU4tMHfeeTe
         +YcZllkWuAESlFBOQsnlEh2BR6JAB7Hreu6QcmJ1/6KI/Fxnespsw1UqLQbQTCILNHUB
         x+J0HUKnenJDYS9cYjpokPeTjrYZCUgTnPzo0nVESzP3cszlMY/k3yqNp/YVqySVzEWr
         3XuCcImqYfo+VXjSHoRVe9fHDJcEhCecVPK/EepyaBcIoKyLcVcizQ5/XVHUV2zRWGRK
         pCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520835; x=1758125635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QdiDWwxajDafGytCRj5Idko5t6hGYc52LVL1KdhcrAU=;
        b=n+7V6fCXua+c4S2ltBoVm9u1NJe5FJ1bEglip7T6h8h+XwZgHqPMWzrqndBA11OXR7
         vAJlcJN7WQfxPgG96MzSFcDS3DhtmATXkGW4zasfbh0+DcpSRX8/WdYPskUesIJfxnCk
         p1OjwvaQ884qSIjxbpJqiaccW9neuZfjd5YCp2YrHLkYrYX0MyuyCNL61qDazlU57f+u
         j3npH8REABN1EvHSNtSFKSiF+9i67UOPvenlyuuF3gz+mEcs1qEzIKMi1cGDBi23R3wO
         bO4RZhepKVEZd5Wx4nUmCy2oCA1ehHnsaKaSL4znW8wKg8F4w60Bx1o3SFZdP3LdUJ1d
         5KFQ==
X-Gm-Message-State: AOJu0YyoWcw7VUjNSmwyyRnPouXRIbkkNumhGSARaxRE08wNXlOtJc0O
	LBAP+jJjUbCFn+C1ib039hneuoVtRoHGFrCPoHammtK/HrELaBkW2P8uFJ2vIsPbbtEhHIPA6k+
	FXxm5u/aHvmlDtyXQ8UJVwK0b/ZuBlCmbBhAKGD4=
X-Gm-Gg: ASbGncsNiw2l6PMNndAMamEpDeB1wqh7kOP5RDlNU2N2XHTepHtWmSVx6pm7oBATa5L
	aT44vgE/gurFrPuaRBeSRAhfUMHm0TTRYEAomWWBaK1TUsFQ49xEaop2WPUPRYA1Bdp22rEZ85r
	UuZOtEz8kpJo2tItxgMUhWjiQTGw8l+B4p2JCFBUSMJ1aHEXux3BX3yD3Ia49w/1TBYRA7AJPmJ
	KvN6347tF0=
X-Google-Smtp-Source: AGHT+IGTt7x1vLOYMI6PYO93ndUSxRjal+0P7YHM1pddCpCgfatgREvad06nsjSla4ZkyN4Ux4D+siw/yg6LeyGPZ1o=
X-Received: by 2002:a17:90b:3950:b0:32b:cb15:5fdc with SMTP id
 98e67ed59e1d1-32d43f82724mr19760720a91.30.1757520835029; Wed, 10 Sep 2025
 09:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-2-ryncsn@gmail.com>
In-Reply-To: <20250910160833.3464-2-ryncsn@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 11 Sep 2025 00:13:15 +0800
X-Gm-Features: Ac12FXw7L2tf9IDZt7MK2f3EMzzx492hVTOs8W7PnEPHCh4J_mvxiTWsay0SzGY
Message-ID: <CAMgjq7Db_DbZosWrUUAGfObDYA2e34zB=RtUpRZc2u4RJBiSxg@mail.gmail.com>
Subject: Re: [PATCH v3 01/15] docs/mm: add document for swap table
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: emo6g4rei1np6z71zzb6tegj3bd48efa
X-Rspam-User: 
X-Rspamd-Queue-Id: C250940002
X-Rspamd-Server: rspam10
X-HE-Tag: 1757520837-731660
X-HE-Meta: U2FsdGVkX19xAITvhDtZs/JnLUgFJvXtEgyRnL6qXPr/0TDZ0F61FL2LGSOtFMF6iVyJ0svI//xoBP1ZhiezPyJVwWVZdcQFb2P3NYDIM3A/S9ZqmfrTPPP+Y8NrYtC3wCs/WyR9LOcUbKlNybFCrdg3qlIze7toGJn5O1hpvjqs8aNWKTPr945dXnmrv//ybmFmfGB+UR01+UiNsuQwCQe2aHY8TlRSLafYbHd0Ab1xuB6xlS+camhsLs36Tpf6SXlaZ0fdCD5OErbUJPvlBO+4eKjMAwGnbxaVtrRx8AIaHhWe+V7dkTvXmNM2C1nE+ib5c5oO0s8lgnz3DHPH/vUmeuq8hDLSWZD5WpAT2vgS3NW+vbCrwgPIsbbG381OW1G0t47jrE1UHuFUkqOB0ZxRr67RzuK2MSQlQWyAmLjhBzCrxrDUmJZBz3iZUoO3es0mXbjJlh69bgK57rjVnpZc8ASPdBfN5jByh2eqlJ4tfoy4INmP1iY/pabCK0/Vd8e4wMLKW3AfVX75DD2/qQw6MaIqIVSKLLO/dX6ILhePnBcvHrEV42ChqTb/krbpCepA2kJhZ32PemVkVIyIeMqXXluBP0+7jtctMCidduh4oY3zFHg1AMIyfhU+bTeAvX2z7lvZ+DXUiDALv5qalvRFtoowzqRTSrw8F9q9KY/dmJ54Gel08LtJZlar+y2ckjwDYpp34JqQwK/cp8XzMsdxjyc7yZH52Ez9qtxm1FiAUegf84k/ZntkFqVy8+q1iWQoWxQnnu5LZ4z1zLC78L3IXCdz3kq+w2M5bMUM7v0XmzLLisi3klTqTKzcinjHF+Xp6Gfa33k2Xz3sqdXEgBHGql32g/GwfkLIVOIDbrjO8vPSMYtjnse91uedeb1fMrn+ykmEBHGyFj6Q540rqyQHPIztKULlD2UlQDgx/GcCSQ5NayGbX/sIXrUYr6rhXuQGNmepgpkGsVyG8Oo
 L6Hsxma+
 e2iYOTUaVxAAxKmLpXBMEMSSgJh3wAoUqBS6X9VW2iehNUQCpRRy5VTXm85u4J93IDO3fUAuBa5RAg9QSmgxRTijxzajI3xzhiLnYg7qiPPkx0NQvhcQyFyI4n0Z9zQMaEdE9BA+dAAyhJJCG3+TQCQni26T8JPD5carSbcapVZZea33zAHhlTvE9BkOjRyJSvxFTVgsJA0Be+eGgc+ftSQvPI00Iqwjfqj4xydeAQj/Pl0xFldjXGtx8WaMemlqXkR09+OWVs4fbDrzTvk9PAF/l0hMchNLeiNqidCnS7+kN/4Vpnk7B2xx+fH2Y+B4iGZS8yV6wNO5ISOTIqK9KHCLHsk3bX48+7VKbqd//Z5pehWsbnnRAIBiGdGVEACmorf6ZpiQb54ehpk4hqPCVf3+1/WuwRe82CLrzhteQuzVy5xUqPB7gEe5ZkSZ8EI78UJ17j+KIKKKmX7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 12:08=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> From: Chris Li <chrisl@kernel.org>

So sorry about this. I did fix my git config and verified that, but
sent the email on another machine that still having a broken config :/

Hi Andrew, can you help fix the Author to be Chris here?

BTW I saw the current version in mm-new, the author is already Chris,
which is correct.

