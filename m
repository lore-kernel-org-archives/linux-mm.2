Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04604CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B8F8E0006; Tue,  2 Sep 2025 08:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B648E0001; Tue,  2 Sep 2025 08:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9E08E0006; Tue,  2 Sep 2025 08:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A20C8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:33:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC0671D145A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:33:07 +0000 (UTC)
X-FDA: 83844250014.12.1EEFF13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E1A1E1C0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:33:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VoJVAyD4;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756816385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NlLtoQUyzt+LCFD4R/YFCAKe4Bek7vP8Kq+e8VE328=;
	b=pfn4ZVxPY132EYlGytM7RebiHL0NcbkdudRodl0EumhjSIu/AwQ57P0on4MFsAB+HbBIRS
	XRfFy1KOpjwUomzRMIKe13zEC3Do3lMgzdL7REePpfvGIRRdKIY3E0oXwlTzVnjguriDuv
	HTsNG4cln40jIcUxUD8jk7oRKPRAy9I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VoJVAyD4;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756816385; a=rsa-sha256;
	cv=none;
	b=2UruEzDouRZbdAoXSqpfqHnP7AbzQSxcl+yAZBS1wjp4Pex+lZbbdbV4tQhRw71UfpLm1J
	L36Sht2H9dbVk+6cOrX/5mCVsFRfyChX/lhT09It5M+I7m6Kuxa9lJJ0MQgTOeWznQRD3x
	jVlqqVLxBrqJ8qbBwr7RFMQMzg9R9SM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 427186020E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE2AC4CEFB
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756816385;
	bh=CA0UUA72UigpJyj1WkBvnnwxWytyjCGoELrQPL5uv00=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VoJVAyD4t9u3SwwyzLu8QVYRndeyB5drflEfsebmVMqGOVE1Wv8d7/3lBjTCEoFWn
	 itUOpaZugcOGS0jWXb2q9az2yi6f4rRQQwtDPyO5e8f/NRhXikOP9OyxIxzmH8FnyZ
	 NG7S43AB17FFyo6euWCFfdWhrypGAZnVN62j8BKNYLk0armBHsq0M7O1ESgvZ2W+F9
	 +M/4BpwOV86PzB0pBzG5rPA3YAVyHb6sSDozB3tOlEAt0VI//ifkCGds3e9WeoqzNu
	 z39mGn9AauxCtapJexLThXHk4RrO2urOCuwoKNdF/08WfKDLktrl21OiCeAu53YOrg
	 Voxo26Ze+Hc5w==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d6051aeafso45328027b3.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 05:33:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXzc6co90xh39szm4LL2b2SVr2gOMPDEd+Z68U7UqPIFxtRhqcWGvip+I8LmVFt+FWw05RiA6w6hA==@kvack.org
X-Gm-Message-State: AOJu0YxSw6w8ebeCcua86XXLQsAycvuNXZC85WRebk731Xj6nZzzl1nz
	ZNKXQQ6ZisuCDcjaUmV4ZkI8G60BDwZANpEHJDKAMR6qAkHXdwta4O4qIoD8r1O6tEl6BMhOL3k
	KGn9qKlTM1n/sjU6EgsFkw3DpguPKyAYsPjfxyG9dZw==
X-Google-Smtp-Source: AGHT+IFfYPr1k+1vxa1r96GXeWzehyJG4pmR2rrje/td5emhAfo5OQhJx8XV8yU9JqVgGrdT/u4cpNxwqOOd1C7ndJg=
X-Received: by 2002:a05:690c:6f81:b0:71c:bf3:afb0 with SMTP id
 00721157ae682-7227650c487mr98822267b3.40.1756816384211; Tue, 02 Sep 2025
 05:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <c4a729b8-be9e-4005-aab6-91723fcf0080@redhat.com>
In-Reply-To: <c4a729b8-be9e-4005-aab6-91723fcf0080@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 2 Sep 2025 05:32:53 -0700
X-Gmail-Original-Message-ID: <CACePvbVQGbyO=csbLG-0uP8gwY3JkS73nHCBb8Eq7xNwD=N=9A@mail.gmail.com>
X-Gm-Features: Ac12FXxpY-4M4Ku106VflhPcLiF6Pc14_5Y_oPbRVEBK8d5OsGab4H4c580H9cM
Message-ID: <CACePvbVQGbyO=csbLG-0uP8gwY3JkS73nHCBb8Eq7xNwD=N=9A@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 884c7wbb391rqsoyop4t6qqoa54zhxwh
X-Rspam-User: 
X-Rspamd-Queue-Id: E1A1E1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756816385-916184
X-HE-Meta: U2FsdGVkX1+YrVHLGExvZfQHndBTqXOfKQUXQRv42t0PFisWPyQqVLliIeADSzS9ThZqJ2nXs6Eed2NTGMk475O+i5SGpDseDJCKJmlH6EG4t7bnQAGjESj9bZGO6ZNWugSnnbcUIGe1fglvEMBkmzQjzji16h8UcdaRSNt+m1Viyfpr8AkZQAAE32qcQB7ofjbG4OQbXzspjMENqU2zVHt9Xl2DL4flpzF5egsnfrfQ+DI+8gfO4AVx29Xb4l1SLwOetbIDFxiPgAUb2KFbyMIMwXQXyfX0pzMkpWFmefRsKnLisygG872gwUZ9yzfhbvkyRoHFhiGI5514HIiGyub3e6TcV1CAZwedpF8N4M0Jwf7izYaQSRkzXOF/GtgcaUTJqgEhNlhet4ySGZel7sSuPrUnmj3vmDS1sR9xdxDlUgG20XaR6PiAuZKNiaIoIRrBlmRhRL8NiNp86Cbv0sMiXaVluf8oEr1OrStLJzRg59LjZeFpQABkoA3nOgDMEYXwy2bE1K4Ed9Xv4q+MjadXx4Cp34hTFBOztx5YUpMZVSpBAr1FVbOdod/kPkY2AuFtTn+pyGCchJT/0I8cpoHFg+3AvTxlWaxQzAvzdrw0sB/wHJ21pccEdLHTi44zyBvwZlHFenkvSZKt/rwwcuPgakHWv1nD0PwrHVpl+OS1PXoWNeBIBX9qAo7jTt8C7Ldx8I4xw3iUG9JHxhMq6WrVdma08tHlZozA00ozMySUJiu+2gjLxHukSNM5dlD1Nb6NdjFfdZxDQzQdY4Y5brplfgpejeOBGnghNtZfW2lZ3S1qBuaJ+bl6Z+Yrh2pG+tGcRB1eP8Y7yObzK2K+VxsMFUqyrVo2nnlX6IOoFxJE8IE4FZhYmgYwx/dCsxS5soKlTo/fwGETl57/4XQzUrQ9Ti628wDnWQthW5Hmf7YcGSXJE+t14rBtWpjmnhELX99FlGEhao5riB+RM/A
 GnEnsbzH
 Yl5aY5BM+m5h+psI5E0qJQSErd7FO0tNGiSWxp3B8h4tMFc75xcPDvbu+T35c22RJoz5E/l2D5DOZjRhBk0vSMKWABLKYeAcGDJjHaZ0jlMTOFvQA+cpqI6oqb8zr3giyl2eJuSO2NhmmOKLXEy1r2QSObI1PBsGWIOMF2uIxmh8ZLvhuPjguPo8FHyv8vLLxIh5r2igI0CruIh0c1tcOL1yxNot4bfUU8xA3IgpplN2uzcUpgNEuPKWGOZRZKgogseNb57Ufi4NykMJaEb2sTkmNz0QkCkMTkM3unVNKV4meQ9F/sM9TEBkqCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 3:07=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 99513b74b5d8..ff9eb761a103 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
> >       printk("Total swap =3D %lukB\n", K(total_swap_pages));
> >   }
> >
> > +/*
>
> While at it, proper kerneldoc?

Agree, add the kerneldoc while we are at it. Those are important API
to interact with the swap table.

BTW, I already submitted a design doc for swap table to Kairui, which
will show up as the first patch in the V2 series

Chris

