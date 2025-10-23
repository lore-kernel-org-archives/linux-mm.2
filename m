Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3679CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 17:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08AC08E000C; Thu, 23 Oct 2025 13:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B908E0007; Thu, 23 Oct 2025 13:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D148E000C; Thu, 23 Oct 2025 13:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0F6B8E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:42:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A627BC0C1B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:42:47 +0000 (UTC)
X-FDA: 84030099174.11.5078206
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB8FB20004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:42:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U40Qeigd;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761241365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPAtMguVYUjm2bPXdyPdBBsK+GKvEKPYmuqUzpm+2v0=;
	b=zhJPEMXtqC68lRyWqSGmjDrnn0C4sSbdq0fircj3JMJZl5S6aLUVJsYN/xy4zu3ilRVZYZ
	GwL3FsH6S25NbLH5+sPiwvjmKKjR9Zc7A8zNAWlxkDOyPiDai+nx4ASxAj+V+OYz3FAdGH
	sZMjQrCDkhCtmq3r0HIltkwKFPlNx4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761241365; a=rsa-sha256;
	cv=none;
	b=IpAvnU/jyxDGfXuy82TgOxHvC4NBCsRVUsYJ7bSUs0FVMprSAzbdOODQtMC0kvYbl8KD1I
	jJaUF6M94rISq/xrhSwl3RbUi18D7U8GS+MfodKnL2oCOSJeB+AY5kKqYYc8SP/ywCOt+o
	440PYe0hK5wN/5vU60HCOPUSvjVEtkk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U40Qeigd;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b67ae7e76abso810674a12.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761241364; x=1761846164; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPAtMguVYUjm2bPXdyPdBBsK+GKvEKPYmuqUzpm+2v0=;
        b=U40QeigduP2j6nHVhVLyXeoFndEapOq/1T6TvCXk5Qn8I1Scg1EYMHK8ItaDcxTyO+
         R6LyT4T66vK+zh0o+1QoRyDCgAVAR0PGiOkFt9VlxLkmE3h5L0OP+VBVlq6ZXQYlksj2
         CLdPI78jlgdPJghwYo8zVAuFjtTKAzhBA2kIMvfQpBf+9TurNaivANvUuXlrreuP0pPi
         L65YPBkgILFWKMv85YXiUBtN7aTbu+oqPF3Qlz0X75Hb/XxFofCKMMQccA97QZL2NZWO
         ByYqAMmAITK20HYl2FlMtdBJ/0yU+Ua51NsIsxlPSb08UfBlmlokTWzLaaGzg6y3RC5j
         oUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761241364; x=1761846164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PPAtMguVYUjm2bPXdyPdBBsK+GKvEKPYmuqUzpm+2v0=;
        b=S3uLA18kzYKJ6kzG6eYhyLWS9wFfIEm1czT9yITgx0G2z1iLGMEk4rdKkBk35vJJuH
         vJkWO7SRoqPbs+shsYvFLFLR/5Z3UZC8hlmnaLXE7lTme0l5cDKhDcXxR1Kc1i20IEzi
         FNL8rxK/SIvLwA0JaamROhgNwZqdNIdoag1BEs0maiuxFwcve9It7vtGHJsZMKvXCD6z
         tdewtFLLaneeOuuTNaCkXj7xEq3rKOMmrmzKXGWpTpadFjbVVWbBYE45Cso7J0WOyRHi
         IkQi0hGM5IpWJYff6FMms/Orp9QqKcDJreEvZtMiIl5V99nWMid3XVzhDJJ0M2D4Cazk
         AJNQ==
X-Gm-Message-State: AOJu0Ywh9NwgU2F2C1DXp9g3ksk6y4xkLAu7bVL8Rpy6Bh/SZ+OMQw51
	7AkICKSWmdcPN4T80rXhe1hKjXryBsUdjuQFUPoXXlty5entPncIOYc9VLjPlr/9Cm5O+GRzQ6C
	oQ7JCqHLh0QTi5H3jxEwXe2DXQ6/364ucD57cxFM=
X-Gm-Gg: ASbGnct75moQhlcFAPUpwfN/WTc+czeDTPlypw8muU3Fw+R4GUGaol3Kru5Ybf4czzD
	J34wQgKqHEHu17pHTbas92qITHxCQozJJ+KWcnlQc0wrSBHuXSJUgFuFY4IVEWixYHQUPjo3D3M
	KaXvgzZmE0UQZhuPexX/hG6XlHj2ZvLrwna4XfzIdPAiFvPYH/8+iD9bTzOKB5yw3Zt+hXeV1yJ
	fuJXhghIGzE9aqoGlGzTD+kGcVpoU+UHQkLxPpcgGdJCRcQAq7hma6fatxg
X-Google-Smtp-Source: AGHT+IGLmB1ebZNebWwSLNxI6zWpEV/Sv/pPIWfLfVFPhnIS1gTRgxcF5G/Ed1LOT26G5vAVRNngplSfykW+Lus7CTI=
X-Received: by 2002:a17:903:94e:b0:27e:dc53:d222 with SMTP id
 d9443c01a7336-290cb278e97mr315093915ad.44.1761241364475; Thu, 23 Oct 2025
 10:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <20251023065913.36925-1-ryncsn@gmail.com> <774c443f-f12f-4d4f-93b1-8913734b62b2@redhat.com>
 <f0715f2c-ee27-4e13-84d0-5df156410527@redhat.com>
In-Reply-To: <f0715f2c-ee27-4e13-84d0-5df156410527@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Oct 2025 01:42:05 +0800
X-Gm-Features: AS18NWCKbpYNUbtlmhqYan2nj3cCPEw88Vfgq-76wvP0ZxptePnkT4EeZPn3IR4
Message-ID: <CAMgjq7Chg6e_xL4wxYJqMzmCRENawQ63KSABrZ9zVbR4ET=YFA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/shmem: fix THP allocation and fallback loop
To: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Hugh Dickins <hughd@google.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: jkudybzk7z3tuzyqpuzceypxzrobq4mb
X-Rspam-User: 
X-Rspamd-Queue-Id: CB8FB20004
X-HE-Tag: 1761241365-992885
X-HE-Meta: U2FsdGVkX19Ny91VwxboWwW7sXDfxXWYpVo2xLqHX2ugd11zP4iM+WGwgPMcUas/gV/lMnRkWEzjszKvEtP1T4vgaz+lQbxj49V5Q4++l4PUoYmNoyhzU/So311ATFtxcm+l6LAPOCjzUx7+Kj/5oibtV8/YiBh5zs7NGxIkiLjNh/RTb9HXtq/djmsf5uHrxZllESdC+UIK8RKKbGYHH8JPg0AcoUWfvkuGq7uuLqb/YrK/FK/m0yGpub97ZiChOc/8ql+EsV0riDU+0bSM7Nos9ILab932wX9/ysaeQrz1D0c1lCMkXK8rCgxP7gSEkay1Iu5EOvheGejEvIu0g+MTndEVPR1kJWXrs8FW/bnrd6QopMAprU4TWaYnaZYfMvBrSU4CtQ0b6pt2CdoEn4AwZzC2NgLLh64eCWtn2yAmTf7/0AXQ78GtEG/0AzooPYWqNQMjUpXyeNXdjtK0z9W5rJJFO49KJzXdhmSc0M/Zy1Hu+i3X71HNATlOEfX6s79+nKrKBGQSP1H+hyi6TviCJunkwWGTrndt43m6cO6NLNvl6K2V8UssRbytN/X8zFWzf7oXbYYRfzb7XaBaJtWqH1+6icmrohOq4emmlSiJKWF6xedoPmxtyO5zlTTCxztFEDYo9/Zrjl3jhtj+qVV9OKP47zqwH8nWItNAilhgOJ9cBWivkbLQc/nUtSVM3sbZqukHfUAIE/JlU3gip2uzB03wSp8ARN8znL8al3H7yfLulfLRf+BL+9cr4VjckhJ2BKcwQF/h1xBOPWeRlrlsMZc5Ap18pPTKqyInO/lpPPfYPi/zHkv6IEVAuVEXdJ5G4iA8eX6h3LD+5WqOJaTz0wvEhgQ1Onpucrj3DJZF3euY27JX3eDUSDr9EE3IZCxNFCAefxFERF6TlAQzkli6xYim8/MMGmA43CxspZVCC0Fmov5VyaKeah7U/qTGdlOjX5s4shinovYo4Y2
 IIzy6tHI
 gYD422sKzzjUEiRAqGpExHh7KTAZWBsYcOXn+TgzvMwewmdTCqWqiBJhtBjv4J9Dm4DajuAJfQSMuyOzlzHH4JadMljQjk5ceg+Kw9KOR+igO8BK0Zda3zD2TWdDIRc6Fl4pULxaM8UrVspX42C1H4amWF5XlUxO30WeAgERd59S8SQjZoIw92KMs+zog3TWjkuL/tWq7irv9C0O8l4rD6sSuCJX7PpFY1MG3iwi3XdheRRI2dn3OZQBnAMZDNr66cq+mNCELe8yhtfGegoqJNo8ZxRpZvRYhxgov15sBqUgx0rhUmxuMpVTSA+UkVoVOjRuXeeU+WjIWky0jX9/DHHrq+8vryDdWCsZLBCB+yG/weZGKHRAcWxd8wOVZE0CDWIX/c/a7El0ImpYszAkiZ+iP69YkF6PRJTyx1s5QVaHBFJkCuQOeikkodLx5vnPAaBdJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 12:14=E2=80=AFAM David Hildenbrand <david@redhat.co=
m> wrote:
>
> On 23.10.25 18:13, David Hildenbrand wrote:
> > On 23.10.25 08:59, Kairui Song wrote:
> >> From: Kairui Song <kasong@tencent.com>
> >>
> >> The order check and fallback loop is updating the index value on every
> >> loop, this will cause the index to be wrongly aligned by a larger valu=
e
> >> while the loop shrinks the order.
> >>
> >> This may result in inserting and returning a folio of the wrong index
> >> and cause data corruption with some userspace workloads [1].
> >>
> >> Cc: stable@vger.kernel.org
> >> Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n=
4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
> >> Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem=
")
> >> Signed-off-by: Kairui Song <kasong@tencent.com>
> >>
> >> ---
> >>
> >> Changes from V2:
> >> - Introduce a temporary variable to improve code,
> >>     no behavior change, generated code is identical.
> >> - Link to V2: https://lore.kernel.org/linux-mm/20251022105719.18321-1-=
ryncsn@gmail.com/
> >>
> >> Changes from V1:
> >> - Remove unnecessary cleanup and simplify the commit message.
> >> - Link to V1: https://lore.kernel.org/linux-mm/20251021190436.81682-1-=
ryncsn@gmail.com/
> >>
> >> ---
> >>    mm/shmem.c | 9 ++++++---
> >>    1 file changed, 6 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/shmem.c b/mm/shmem.c
> >> index b50ce7dbc84a..e1dc2d8e939c 100644
> >> --- a/mm/shmem.c
> >> +++ b/mm/shmem.c
> >> @@ -1882,6 +1882,7 @@ static struct folio *shmem_alloc_and_add_folio(s=
truct vm_fault *vmf,
> >>      struct shmem_inode_info *info =3D SHMEM_I(inode);
> >>      unsigned long suitable_orders =3D 0;
> >>      struct folio *folio =3D NULL;
> >> +    pgoff_t aligned_index;
> >>      long pages;
> >>      int error, order;
> >>
> >> @@ -1895,10 +1896,12 @@ static struct folio *shmem_alloc_and_add_folio=
(struct vm_fault *vmf,
> >>              order =3D highest_order(suitable_orders);
> >>              while (suitable_orders) {
> >>                      pages =3D 1UL << order;
> >> -                    index =3D round_down(index, pages);
> >> -                    folio =3D shmem_alloc_folio(gfp, order, info, ind=
ex);
> >> -                    if (folio)
> >> +                    aligned_index =3D round_down(index, pages);
> >> +                    folio =3D shmem_alloc_folio(gfp, order, info, ali=
gned_index);
> >> +                    if (folio) {
> >> +                            index =3D aligned_index;
> >>                              goto allocated;
> >> +                    }
> >
> > Was the found by code inspection or was there a report about this?
>
> Answering my own question, the "Link:" above should be
>
> Closes:
> https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgott=
edy0S6YYeUw@mail.gmail.com/
>

Thanks for the review. It's reported by and fixed by me, so I didn't
include an extra Report-By & Closes, I thought that's kind of
redundant. Do we need that? Maybe Andrew can help add it :) ?

