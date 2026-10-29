Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5481B606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ECAqvZmi
Received: by kanga.kvack.org (Postfix)
	id 630C16B05B2; Wed, 28 Oct 2026 21:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6083B6B05B3; Wed, 28 Oct 2026 21:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544606B05B4; Wed, 28 Oct 2026 21:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA266B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:01:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A2904020B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:01:54 +0000 (UTC)
X-FDA: 85373861748.10.C649442
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF44FC000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:01:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ECAqvZmi;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793235713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeVai7414BFTHAGTwhgEP7/ooB/HFDOlmc07AL7nxgw=;
	b=kM46eo3n8btz7Bm6iygcBaD81g6GqFhIDGE7IzCRrjOwajVBIMSlCKD2l7qufefrDWRFLv
	9Qwo2G0Q7AwXKBaL1Vs/19F8OiONIMB21ZrC8ZvatcxcnqVZvMYq/5fF8tc37puxvoD3EV
	cXL1c7O9fFKeFbrwjNLtVIdSDiesS2o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ECAqvZmi;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793235713;
	b=8ZuZy2lCCRrJpitAQTQpG86B5uOURbe9tBA5cRj0mPnahPbpNAeklJgO6fG4FS7VQzAhia
	27ckko9h/WssVjNQjEDLBlEvfGnPbEzOMhXJb01UNfNbSvG2hs0IgoUfXCMP5Mpn5wfM2A
	mzdjDUtklK7Uk61rp8zd40sKUJbS6Vo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFBC2439BA;
	Thu, 29 Oct 2026 01:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7750C1F01825;
	Thu, 29 Oct 2026 01:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793235711;
	bh=IeVai7414BFTHAGTwhgEP7/ooB/HFDOlmc07AL7nxgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECAqvZmilqOVTKFJ8qolp8yvMQLx/QSdVSr93C28cvzl/0dxYZCXxgMclau8JKYvM
	 QPnICZw1BDjFIj9n/PPijc33msLgEgd8cMvd5hoYMqY5k60dsG+13SBCRlJX+3Ksxe
	 TBiETsgEiqA9Nk5h1NtWmnC4CAEA371uwU0wThCc9YKWOMmiAYnmm56+7NDzn4CEH0
	 X16wKmenU040CDzh5+aZ3Bb6K4I5l5T969lhWgmr+h+MZ9X/Vx76gXvDG1uboXFruD
	 t3Ml6V9rsfzmb5YJ/9spqNQ7nnxKFwh5gW0zK7o0yRadIOtu+uTHLEn7So14AulCkb
	 dlImzvrIAHX3w==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bijan Tabatabai <bijan311@gmail.com>,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH] mm/damon: skip folios already on the migration target node
Date: Wed, 28 Oct 2026 18:01:43 -0700
Message-ID: <20261029010144.169906-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179320218513.2.7432933245840036676.damon-same-node-skip@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF44FC000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5ffow6ff4k75wac74xqjnr5jkzhirirg
X-HE-Tag: 1793235712-438780
X-HE-Meta: U2FsdGVkX1/rTPr6jl66Ww+lLTP804uplTU3iT0XummIyg25RCQI0/k8zEONNgLd16NAHLodgKDE6gZ7OKrbbgF46+ATnk77X+/fOaPqCsdrCgZwRQV3maGTOJdRGpP6GQGd0aPXz3q8/CH085sxz6U5Te0MNLOVs6vJVFE08vvzADK7CKjIvaFkeH/EjlRkHFzkQPtM+6KvZZi5LBcz2O1MhI10NvXGrsE6lLzHqFowAuLKq19CviIQTjFFXz3txrhJN96Aa0589Oxn06cKkhWfgu6jbTOycgZ4Ddcdv/NsQYg6auC4PASBZqOY+QJR9YKQ9WoGt5xTdpjEikvPT7WdY5j2SyytZTH1+l4Xz5Jz4amQnayq78arpn1W1IFfIbD63PlxyTvVSpwdkjWwavF3c2ihOZ9t6wa3pl/1iJGhwnBA2Xe/C4CQv5lmpJNL/YpgesyNaVKyQEtDzM7hMImrj22+A/MjTIaV5Yc136yH1pmRg2jA+G1sFx6+nsrgTED/vzA3S+3Qhm6oMEZpA2ZYTLhIJdKtoQT7+UG1lCsuYK8I0Qs5r4D7dF/eG0GRQVGxux6mzVjBq0+grVuIBjLW8GvEqkGL/SJwQR6luTB2q+0glALLMUi0QbBhEYn3A9b8edklYTqa9N7c6fmOL6rr7A4VPt88iVQbk8WKPmbhPfzFODpI5De8J36I/Gj7KRNMpBODujnRw9Uxq1RdS+Vmg+65UTDh2hfX3dZ/o7Z2LABfW/PxyagL6pAAnfSv+W3DGoQL/lnCneDw96F2xR8hcqWZKw0xM52Y4W+81RHdplIXfSD9HqAWqMFHSgtxg/0uQvAICt/MXNtXsToEOxLiDBp+4rqZXdyIiNBI/7/mWuijXZIaD5kwX60aXw5WhwkkDzt4TnPsHc9fk8e0px3iSDs6zXQ8qOfo5YToevH+ZV5QSQFVE39e9P+n6adcvrPi4i5mQL/FT2gum5t
 k1VOc+Sm
 gc2RBAAc/pMExuw3RnKEG262s3cTik7DY2bia1TRTd81242I5yQixejDjXINuPCDol1CA3yjap3svlTu7aMJiZa+YKYf9o5eYC7QchG9fI1s9A+PU7Y9ZazZQ18dxfMVqhwx622ne+oTWdgO3Ph8JfNjDzIuhMxzaoPikVTVN3u5jQ/msmyYbEFWm994pe9FC7pwoTCa+9nOV1/Sn497s31G3UMMVRfK450Sk056mI3THpPgnYVHRBHYB4mhraIQ8/pZSBuZzTwvAGpENdEWHHhQFZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 00:05:46 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> While measuring DAMOS migration overhead, I found that the target_nid
> path isolates folios already on the target node, then puts them back on
> the LRU without migrating them.
> 
> Skip them before isolation in vaddr and paddr, as the vaddr explicit
> destinations path already does.

Nice catch!

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Other than below trivial nit,

Reviewed-by: SJ Park <sj@kernel.org>

> 
> ---
> DAMON KUnit and selftests all passed. In a synthetic same-node fvaddr
> test on a two-node x86-64 KVM guest (8 interleaved runs per kernel),
> guest-kernel cycles fell by about 29%
> with 4 KiB regions and 90% with 16 MiB regions. Median kdamond CPU
> time fell by about 76% with 16 MiB regions, with no clear change
> with 4 KiB regions.

Thank you for sharing the test result.  We don't want to add too much test
results in the commit message.  But the performance part above is informative
and concise, so I think it deserves to be in the commit message.

> ---
>  mm/damon/paddr.c |  2 ++
>  mm/damon/vaddr.c | 22 ++++++++++++----------
>  2 files changed, 14 insertions(+), 10 deletions(-)
[...]
> @@ -858,8 +860,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
>  			goto huge_out;
>  		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
>  			goto huge_out;
> -		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
> -				migration_lists);
> +		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
> +					   migration_lists);

Let's not align parameters on parentheses but just give two tabs indentation.

>  huge_out:
>  		spin_unlock(ptl);
>  		return 0;
> @@ -883,8 +885,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
>  			continue;
>  		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
>  			continue;
> -		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
> -				migration_lists);
> +		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
> +					   migration_lists);

Ditto.

Assuming you accept my humble suggestions above, I applied  this patch to
damon/next [1] tree, together with my above suggestions.  I will repost it for
mm.git inclusion within a week.  So, no action from your side is needed for
now.  Let me know if you think changes to the plan or discussions are needed.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

