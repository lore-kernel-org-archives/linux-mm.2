Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68ED8C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7516B0096; Wed,  9 Sep 2026 14:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D9F6B0098; Wed,  9 Sep 2026 14:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694306B0099; Wed,  9 Sep 2026 14:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8646B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:29:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D58681C1DD2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:29:44 +0000 (UTC)
X-FDA: 85195062288.01.3DF1F58
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 028D180004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:29:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p1w5ztYc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788978583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EYvnoKTXNW2Ak9107qs0mK9Mwah+zy+/JNGH680rE8=;
	b=ZPtAMnhU8fNYPiy8psUmat76xsm3AmyClht4Ugz3gn0H5bEnvindVKeB/is/dhtqHEY5Wt
	N9HAoFrQ+x9HGIXM3tdjKYHKobc0OPjnX5mBc03NZSggdaWHAChCAjDyJ1PZTZ9/lu/1Z8
	5aWgHDGYg6f/JsDwtAhtisuXg5am2Wo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p1w5ztYc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788978583;
	b=FGj6kYMFvVoyCnELpbfU4OxHfmY1Z/DUAGa8pbtxnctXI56urnZVLhhNXkxnJL5UGCrbDq
	X9worrpS9XaO6gN+ixTdsmSiA38zEALisaTxrLw36y8+PLoEZakwBNaFWIHK7hhbpTV9sI
	ugvIjl10bTb2N4LAn4zUhZUIarmYb5U=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4957eefd361so48914205e9.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:29:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788978581; cv=none;
        d=google.com; s=arc-20260327;
        b=QAcsZJBHlOMy2/bs7oEzv/uxZS8krXG1nam/ZjMN357HmxTsxEGRli+GFXezGzWz4H
         kyWuPRwaPaz+AOpZvjya46yypjMqRhVvpZssdZCfFZRReYKskwekrgilOAO6aJQZXM61
         cSAxnecaf047shd49xcDHI6ZfXwhatCVkUIJZBuYt0kAc5TFlz9CmCMM5iRO0HzI53zl
         5cREl5PFdTNB1e9KI1vtcfl3xLUY+KYK7wkhGzkP3XYHAigVsE+LNRO6krvx/3Xs1siI
         zFKUcsMiw20m4fkFE52KL1AR8C1NoMFI4F63sGzlShxHSL36kbwD7voWVM7Dn48rOFmB
         6+QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1EYvnoKTXNW2Ak9107qs0mK9Mwah+zy+/JNGH680rE8=;
        fh=ADQYGoFp7OVoUemyxaMhUTdLFFV8+JAYf7HQVZkXFDQ=;
        b=jayR4zgEW/ZrlEZgHA76BzwhXF1Kfj8MAPjPyEitGEWs6kKfclAPQErMA00+t/5Byv
         b4ee7bNzFlHaYLccVqkiBpgnmxdjuqqbW9ycfJlkXGAR0Le7mBOqDKf6o/8LsvrJcPSB
         K5z5jOsfZgICwcGjeqQECbEmVlQbNxBMJl7usPRtexhKn2075czIGnZtoSgPdRnc7H+U
         uOj55iKIg6mw7KFzqoc++6K4pRzMEWFh1PNDak/kilzBBtqxYc9o4Ijbmi6eInKv8ldb
         H38OGCGuEQwHFb2VtQG7tkknPrGRhi34f0WF/sXZ6VJDt3HBCK/ukrdPgQ9FiNIKxRwH
         CMhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788978581; x=1789583381; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1EYvnoKTXNW2Ak9107qs0mK9Mwah+zy+/JNGH680rE8=;
        b=p1w5ztYcABn5Do4Fv494bP7fHjw9e0y9OHLCxhF74ImhXR/49MXEHj+H5RtrOtoJSy
         rdWMyemSpOVx2XHytV5l7V1lcBgvAywhbJWWRblvL7NpACvZdyzeLsn6uWleUvKAmAYj
         GuBdLhHhcT7ttwg9yuzxCXXENoJsH2VHmCDePtX3qDnyCdEY9HOt8X89ehPP36PEIWdj
         D6Ych1DG9zRWHh5NDWEGD+V22/EUqlE858ileeUKdZG+n2H7C48SrKSlq7UvJdA3YRj7
         oCQjjHGS7db9bl1eqQU+S+XDQxWWp132Ql0jt7ikf8dg5xsJzJkegK0wV6R35qid6AHa
         TQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978581; x=1789583381;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1EYvnoKTXNW2Ak9107qs0mK9Mwah+zy+/JNGH680rE8=;
        b=M2q3aiCtxCp+Lq9lhrsqtYoY+6Ohf7RD3+/FnuTorfdWpEqQ1b1X/uBkbaKv1sLxdN
         qxXyZbcQVvmeefEApUokX0GMuQQXvi3g7lYy73iXllIfjrSrlOIbtO4UlovvNnJ4IqXf
         nVQEXlpDcQarbvthaWUI+WF1vwsEsjWNegcSoXHdniFaT7pludqSwolBAe7Y8sAFcrgC
         AVxTJseUSW2zq7LsnIdpHC1U8LBugNely53Dt7xTgkhSGwdOIvzVDpEtZbUqlGZ/neuH
         wUsKFpblXWJlSf5dOqtlWuuFTRi0UJXWzsI1uS7OCPjY2JZktfCueOuU3aHqsxyMTVbR
         gU3g==
X-Gm-Message-State: AFuF++kHAg6bm17ZYPPblOS/P73F4qyDroX9SChHoZWJrMIOzmdl5NmM
	1WFvCa1GCjqZW120Ab34DIJKdCrWBZuCC+nwpOXxexURGnjiozI76ROuRgTIAFR6nkIKuQZBYfj
	P7+frbqFzaYvMY/OdqTAQOEmeibi0dus=
X-Gm-Gg: AYBFou0Bfn0WofjoU8lHThyXPcnz2PiUguF9nyCZjYo8vG5TX7XPQtW4gG1W+/iuJnN
	xXvlxhFxg4VFS+ayidfpn7L0gB8jIA6LalnwtTPi5tOyPUr7/KT+juO14VW6ZfyR4IXwT4psZri
	4Z48Y9vFDg8iJZU/TCCYGymZE4pvGGGSlBu5HfwBR70zFm9w9tf9VprRvEToBzaN5Jc8FpXnlGX
	eEMqUipjiZy4hu8Vvtd2o7JlTZ01GBAPgLbcme7GRc7ZDPNDHYbAe34J3+ohPIXFf7A8Ih9iZA6
	0e19kwfACPtVZ24FJsQeAZFDKCDmYZ330rwP0NGxO+/ErP48oov9hJvt6mRwqXpDvs4T3N31wNH
	ftQHVPb4mjbVWclBhP0RaS9Yv/MQuNp/0sTfkeQ==
X-Received: by 2002:a05:600c:698c:b0:49c:fc6e:a3df with SMTP id
 5b1f17b1804b1-49cfc6ea7camr362786445e9.30.1788978581207; Wed, 09 Sep 2026
 11:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
In-Reply-To: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 9 Sep 2026 11:29:28 -0700
X-Gm-Features: AcwNN1UIVH_MQZA8U5aal0eSLqYQFca_vZkAxhuM9xhibUtiO7HkDUg0iOU3ikY
Message-ID: <CAJnrk1b8fWpp-yBRxFaBbFzA8852N53SB6j3Zi9Qnp+JBFuNbA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com, 
	djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, 
	yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6a5bwk9jnni7bnxakktz88bp6ibrncxo
X-Rspamd-Queue-Id: 028D180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1788978582-259623
X-HE-Meta: U2FsdGVkX1+0X6YTLcTtNRHYfZT+CQAwpsqq0iG8hDI+UTowHkBvUlADx28Iuu/zJmh8PDPxaCGdrbpDrZD6SSxzt3W2Dk6pXvIrCiQsBhknFGPF3AXs0dgz/6XkuReTP+cIGrhcrjklW02FCFJCFuPI+Sxd2e5OXb5cpGf6vYNHsNdWGwWh3YejznkIWsYind6yY4h9IBo5WuVgejRaGIJkZ93BBzXam7K31Vdaiwvq8IHm0rjYytuhFC+EfvmnWZQXjojfH1ORMveA21P+BT38ViqHzJi5A2rWAMqK86ptoSAj2jJv8WytO/4D2X3lDDtfkrnIi8RLgCiN2QzeDoMbN2hkR62s01/pGOPsjTZVc124m9QJc365sIyOrJO9OfdP2Kxien+YzsPCMqU/03n//T1am5jKPV4cMGfYdC9QVeWWBVGB9WDNeifBcKl5M5BKVX2T6SDLqtwp1xqDT+gdJBD50ITOZYeMqMTyZwXA8T/AP2h/X3d/p+U2a0UErpqaWf8Wvade3giniv/4q5TYC0M6FcvDGgtjtJXO6MKRlHKoIivYTc8ymi9VM+ezgRiyr9Rvd7CgKAU0fTmCi+HlbOO7eRLIWJasSsYAFaHy8DiI05kRXswMLAPr30u2LXlAguo2+rsgU56tdobY2tdGv2ZNkCSCNdDWxv8rQTrVt0F5o65bZE5QpZVymCISmY7CawYMu8fFS90B29yuieNsyqcHn4w9SOV1rwcXYYMTp7G/uixq1ZEAxoGw6wvCg7lG+WylSZlYOUV0F7PP3MxtQTyafWy8qHzRsWdJd+0h0YGu4eRgeTsrbP2oVfjHbjQrEpg1QlCa4kILOmLAlDbN3dsd5TCH9zMetesiUuu9VOKeOF0h9T+swbO+WbzOG150evXXSJUcLRxEcuzdrrQmuZgjty+c/P39jJAlsdJyBrn+ak12P6p5aU2LZqG59L8hP0vudx6kgXnhbIu
 34+aqPT4
 veisR8g3Ubjr3/bstUmSRN3BOpi+gygwGl2uWidtUm1I8Yy50yhpKyNR4qCHlfqU60VzQ6h+bguzri1FdUNCJaBzq665zuxvNCIHrR1j/ydtnWNUORCTmbZpJPwuQV7nQBOwc5owsDPApfxCG2XXPVZOs7Kj1ucWX4fAsbmnTKlGRl/aSogJvt9OSzsa4KU/FDlDorsmPpdBI0gYqNDSeXqp5NOXmnm3o5yW623nF3eYd45nOCXjAZ9MF+bOusFhK8hq3ZOVRzTBrvf14k1caVviJKLQaLDJ3J+DNiic+42ckIJDuEdfIQCL2Ol4xnqHpj0GLwVsNs+V12QcTUfge7I3MfA1ebOko1/C3egWrGiOlp9bzon5KBxSJWR9Lb+84PoKUUxpVgzR588C4FSKEqeBNG2xwwvyNY0R+JNbOrbgUMq6v8zB6aQVQ0MLZbk9IWOVduB8DC1sF6vfKx3jsyb3Ya2R0gLQCM3gRReX5ZbviKQg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 11:31=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
>
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
>
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
>
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio =3D=3D true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 =3D p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end =3D 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
>
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.
>
> In addition, even when both splits succeed, data can still be lost when
> the mapping's minimum folio order (min_order) is non-zero. folio_split()
> stops at min_order instead of order 0, so the sub-folio containing a
> split point stays aligned to 1 << min_order rather than to a page. The
> original success path left start at the page-aligned head of the range
> and set end to the exact page index of the end edge, neither of which is
> a folio boundary in general. Either one could land inside the large
> folio at its edge, and the truncate loop would drop that straddling
> folio together with its valid out-of-range tail.
>
> For example, a 64K (order-4) folio with min_order =3D 2 punched from
> offset 0 to 36K:
>
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()        # same_folio =3D=3D true
>       1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
>       folio2 =3D p8-p15 # straddles: p8 in range, p9-p15 tail valid
>       2nd split of folio2 -> [p8-p11, p12-p15]   # success
>       end =3D p9                           # BUG: p9 inside [p8-p11]
>     loop truncates ... p8-p11           # p9-p11's valid tail is lost
>
> Rework the contract so the caller is told the page range to discard:
>
>   - Return true only when a split occurred, false otherwise. This
>     clarifies the existing confusing return value semantics.
>
>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>     range fully covered by [lstart, lend] after any split (or none),
>     i.e. the pages wholly within the range and safe to discard. They are
>     aligned up (pstart) and down (pend) to the mapping's minimum folio
>     order so they always fall on a folio boundary.
>
>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>     clashing with the new outputs and to separate byte offsets from
>     folio indices.
>
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
> &pstart for the folio at the start edge and &pend for the folio at the
> end edge, so the truncate loop drops exactly the fully covered pages and
> never touches a straddling folio that still holds valid out-of-range
> data.
>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
> v1->v2:
>  - Export pstart as a new parameter so that the generic and shmem
>    truncate paths don't need to recompute the start value from the
>    return value. (Brian)
>  - When min_order is nonzero, align [pstart, pend] to the inner
>    boundaries of the folio to ensure they do not point into the middle
>    of a large folio, which could otherwise cause valid data within the
>    folio to be incorrectly cleared. (Joanne)
>
> v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@hu=
aweicloud.com/
>
>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>  3 files changed, 67 insertions(+), 38 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 68db5abd0a4c..6e6ad3187378 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -627,8 +627,8 @@ unsigned find_lock_entries(struct address_space *mapp=
ing, pgoff_t *start,
>  unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
>                 pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices=
);
>  int truncate_inode_folio(struct address_space *mapping, struct folio *fo=
lio);
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
> -               loff_t end);
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +               loff_t lend, pgoff_t *pstart, pgoff_t *pend);
>  long mapping_evict_folio(struct address_space *mapping, struct folio *fo=
lio);
>  unsigned long mapping_try_invalidate(struct address_space *mapping,
>                 pgoff_t start, pgoff_t end, unsigned long *nr_failed);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 89a1495e55f7..4efbbbba5da5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1175,11 +1175,8 @@ static void shmem_undo_range(struct inode *inode, =
loff_t lstart, uoff_t lend,
>         if (folio) {
>                 same_folio =3D lend < folio_next_pos(folio);
>                 folio_mark_dirty(folio);
> -               if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> -                       start =3D folio_next_index(folio);
> -                       if (same_folio)
> -                               end =3D folio->index;
> -               }
> +               truncate_inode_partial_folio(folio, lstart, lend, &start,
> +                                            same_folio ? &end : NULL);
>                 folio_unlock(folio);
>                 folio_put(folio);
>                 folio =3D NULL;
> @@ -1189,8 +1186,7 @@ static void shmem_undo_range(struct inode *inode, l=
off_t lstart, uoff_t lend,
>                 folio =3D shmem_get_partial_folio(inode, lend >> PAGE_SHI=
FT);
>         if (folio) {
>                 folio_mark_dirty(folio);
> -               if (!truncate_inode_partial_folio(folio, lstart, lend))
> -                       end =3D folio->index;
> +               truncate_inode_partial_folio(folio, lstart, lend, NULL, &=
end);
>                 folio_unlock(folio);
>                 folio_put(folio);
>         }
> @@ -1258,7 +1254,8 @@ static void shmem_undo_range(struct inode *inode, l=
off_t lstart, uoff_t lend,
>
>                                 if (!folio_test_large(folio)) {
>                                         truncate_inode_folio(mapping, fol=
io);
> -                               } else if (truncate_inode_partial_folio(f=
olio, lstart, lend)) {
> +                               } else if (truncate_inode_partial_folio(f=
olio,
> +                                                       lstart, lend, NUL=
L, NULL)) {
>                                         /*
>                                          * If we split a page, reset the =
loop so
>                                          * that we pick up the new sub pa=
ges.
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..d88a1b159084 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -206,35 +206,41 @@ static int folio_split_or_unmap(struct folio *folio=
, struct page *split_at,
>  /*
>   * Handle partial folios.  The folio may be entirely within the
>   * range if a split has raced with us.  If not, we zero the part of the
> - * folio that's within the [start, end] range, and then split the folio =
if
> + * folio that's within the [lstart, lend] range, and then split the foli=
o if
>   * it's large.  split_page_range() will discard pages which now lie beyo=
nd
>   * i_size, and we rely on the caller to discard pages which lie within a
>   * newly created hole.
>   *
> - * Returns false if splitting failed so the caller can avoid
> - * discarding the entire folio which is stubbornly unsplit.
> + * When @pstart and/or @pend are non-NULL they receive the indexes of th=
e
> + * page range fully covered by [lstart, lend] after any split (or none),
> + * i.e. the range of pages that are wholly within [lstart, lend] and so =
safe
> + * to discard.

I think with themin_order > 0 case, pages wholly within [lstart, lend]
can still be excluded, so maybe worth editing this to reflect that.

Thanks,
Joanne

> + *
> + * Return %true if the folio was split, %false otherwise.
>   */
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, lof=
f_t end)
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +                                 loff_t lend, pgoff_t *pstart, pgoff_t *=
pend)
>  {
>         loff_t pos =3D folio_pos(folio);
>         size_t size =3D folio_size(folio);

