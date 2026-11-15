Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC784606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lDSbhOFx
Received: by kanga.kvack.org (Postfix)
	id E377B6B05B5; Sun, 15 Nov 2026 11:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E8B6B05B6; Sun, 15 Nov 2026 11:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BDA6B05B7; Sun, 15 Nov 2026 11:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE5236B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:47:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A7494064D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:29 +0000 (UTC)
X-FDA: 85437934218.23.13E1BA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 98E4A4000D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDSbhOFx;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794761247;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FrLVoM7vN526uw1Koxxu8SSpzIuq865rGgmcrGfqrw=;
	b=aTp7spK+9OgG8olhKRNiDbdTcCZgWWjdboT+YVmE1bB/tGASJZWwy+BIbrqxrvC0QmuY/H
	m7kHpOK0ajLjHF3ECL1tS7MZHfUUenSfDOfmWB0UEc8W9GdgnMZezfriyQFwNBcZL6YAf9
	opXhF0JTpROHIsUEtrUC5UNqhWAbDQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794761247;
	b=zZd/9QOJYWolGwWucz3+u+OJCfrWJhzXRcwywXb+2+FPTmU2EGTmvsfaKmQP0kREekqCvB
	WosWqNF6/YkrZ4FHuEOIozyZrMte9k5a5+lObHLnMKlYjcNA0tFPzOruTo26CtqWgI9Gjz
	cqDiw1tm6ilXShSv9YQ3vl5RRkGvkBE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDSbhOFx;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 389EE61B26;
	Sun, 15 Nov 2026 16:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ACF1F000C6;
	Sun, 15 Nov 2026 16:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794761246;
	bh=3FrLVoM7vN526uw1Koxxu8SSpzIuq865rGgmcrGfqrw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lDSbhOFxl82sgk+mdSQioiirsfJqFMZeyfr9WGz78KTBghujPDKcKUNyI9g/y6LOR
	 jJGbU1ArO9yZ8Jf6mbtXKOqc3GSryzbakPC8n8SKgUOD//eDBZw76IGd8qcZ98dXRG
	 WBSSCoUQUPSCzKVIjM6rUxfm4suvXLpKVsW2XKk/E4yTl/wjVPW5Xv3cWN0VEzWXS6
	 YbBT90DMQurAsGg49sVcfbmriiQTmHyWcn/KlZLq2izY6+xC6r8J7ukJgIZOZ+xZAs
	 LmUHg7TFqqNgj+iZC9gSRPdm1FsbGmMu3oyE53fFx9Vq8mICzX+BPkclFyt6B6LrHo
	 Nbw4oAKrdHCjQ==
Message-ID: <sashiko-outbox-215658@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/util: fix off-by-one when checking folio index in
 snapshot_page()
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, akpm@linux-foundation.org, david@kernel.org
Cc: linux-mm@kvack.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
In-Reply-To: <20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn>
References: <20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 16:47:26 +0000
X-Stat-Signature: i79s3dyu5waeje94ihpc5zohu7dj54aj
X-Rspamd-Queue-Id: 98E4A4000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794761247-848099
X-HE-Meta: U2FsdGVkX18bhJ2NO0ceDo3yzWeLGAeP+FomMuAxGF+Stu6qzU1ktMOjvDJUhfgWH1eQqHiM6SZvtlq6hb6xSwK17TZ0s8mRdl2dz7BVIthN1QFHdBASO0K3vzUeeeBMte8uDjAd6DgOWdJ2hbbcVkHHDsXW0FFR9o5oiphX6Il4H7uK2aPJ7nKT54aVDMkv07YijjMO742Qmf00W3RPsTI+bHUmodeIEbTi1Y6JAbXUTQ4wVIyo4hjV7/0C7QWaqBr1s5OkxgJaOsEcPphTECuJJZb4PgR9CDfb441wF7l2ggvUJjtAUu8hm/UVigA+kwl/wKfx2bNuSw+QFO6qPLst7R7lyDth0C58aWZx5l7IdZt26nxmfKegOQl2D6ti26PVwOWYSqAjSkoV+9sHgwl3b3TcICPDCuR/dBaBPN039stteObYdpEhuVq9LIbnFZJB0QiLE5g9UNIJidTfNAJwpjwvF7kBPOgdx7XpikrvcEAuOLyrRcmUtZRh5VADdZWOd493AcuBtX0s4byIgsZxSLTwZ+cR9Zm8CayXNyxtV5//NOzXr8WCxTyReL+R95GNDJdAoxI6i6Ey/QaqM6uv5tGMxRN3ytpxlMNgPipOUVrj8NV4LA+4/tOw1Fo7viTtHIjHm6S2HLqcFFkKf60gtAERIqzSQsszfN9hlnDkN9en8C0CdjUPVxXXIj9izTYvcY7nJtWhj6qELBiortRORlHa9VhVyGVPkZmpBaWkKaKpx68HzaRViVk3YL6DrUebxPTdHs6o9kxPEj7Mi4vNPrX6DPl3yAJSix6v3lamVfLH9zR7EOOGUpFNXOefudnYoNKbCiyPokxLQf5oVtlUug4n/RVfIOMmPXg8yIWIoGkkuaIfIy5NQGNGw8g1lTGDORsBkd/52L7/y/+rp+N12B6zV6Mq6XV5mOcbqxDuD2rIsatwlqUTXFMz2r751IBxC9xqTdWjsAUxzWn
 AtMKa4Zh
 s4QhjbK4F4tyL/KYEOHsrURT7FNgnfefoSUiiW4+0ZrfRT+W5bOPVkPrxz7He72dFPGWUs3ARzZ+lyhiPXVfxWAwG+PuG7ediuAf12yxEFhzul29ynevJklgr0VVahFsH01mTgsL7siw7OiuNMUmMPmjIBl7o/W2Ip8iiZDxHvd6lx1rqPuPCg4DVHs0OAVluMvPYBMGR7/ye726uyYhPyt8zm3aBr2CXgzFA3ZNzMdv7FKm/E+siByrctGm3/eECCUqWhrUdI7pvS1ChBQLrbMbM8EgnkDH14d/nycok7bpSPOFnuCaVqRwwW79yqiGWr5Pxarj2CwUHZpxEjbSnzJpK3HYNIELmX9rMXVNbrZOM6nAgxk0hNdQLgW42i4Z6YwkQXqZx2emiLLQJEmZ1xDOI1VgwRcuShDhk3J0k+zqxJnIxicWELMoFVYsNUcE6GYLkIdD2Eqf7QADwgx95KKLLjM3DAu0CB5QC/x6lhHdYn+luxQ5inUgg5ZbBhWwCpTZFKFXDqb81/u0FSX2Bsz31m/4jBwRKcq9IRnU1lqRIdawZgdFXQw+E6melRglcHg4Xp8O71eMACZ5peBStwAzx++tVW1olDJfv3so4lcjmbLvkeWx3K/aSEmdOk5kKmwjm+NxjmpLqOKLCDnxRPe268qzg0dCUENWA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/util: head page with zero _nr_pages hits tail fallback in
  snapshot_page()
--

commit c1bbaeb218bb3e6717e9e858cb2ae698eb9ee371
Author: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/util: fix off-by-one when checking folio index in snapshot_page()

This commit changes the folio index bounds check in snapshot_page() from
> to >=3D so that snapshots whose page index equals the copied folio's
page count are retried or treated as unfaithful.

> diff --git a/mm/util.c b/mm/util.c
> index a5140b3b70f33..6e6a8f8640a75 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1462,7 +1462,7 @@ void snapshot_page(struct page_snapshot *ps, const =
struct page *page)
>  		set_ps_flags(ps, foliop, page);
>  	}
> =20
> -	if (ps->idx > nr_pages) {
> +	if (ps->idx >=3D nr_pages) {
>  		if (loops-- > 0)
>  			goto again;
>  		clear_compound_head(&ps->page_snapshot);

[Severity: Medium]
Can this cause a compound head page with folio->_nr_pages =3D=3D 0 to enter
the tail-page fallback block?

When snapshot_page() inspects a compound head page (ps->idx =3D=3D 0) while
folio->_nr_pages is 0 under NR_PAGES_IN_LARGE_FOLIO, nr_pages is 0 and
ps->idx >=3D nr_pages now evaluates to true.  This happens deterministically
when __free_pages_prepare() reports a bad compound page, because it zeroes
folio->_nr_pages before calling free_page_is_bad() -> bad_page() ->
dump_page() and before clearing PG_head:

mm/page_alloc.c:__free_pages_prepare() {
    ...
		if (compound) {
			page[1].flags.f &=3D ~PAGE_FLAGS_SECOND;
#ifdef NR_PAGES_IN_LARGE_FOLIO
			folio->_nr_pages =3D 0;
#endif
		}
    ...
	if (is_check_pages_enabled()) {
		if (free_page_is_bad(page))
			bad++;
    ...
}

After the retries expire, the fallback calls
clear_compound_head(&ps->page_snapshot), which overwrites the compound_info
union word (lru.next or pp_magic on a head page) with 0, copies only
sizeof(struct page) into ps->folio_snapshot while leaving PG_head set, and
clears ps->flags.  In __dump_page(), this triggers a bogus "page does not
match folio" warning on a head page and zeroes the lru.next word in the hex
dump.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115004657890Pz=
8ERDf5nCtE-B6M7KFzu@zte.com.cn?part=3D1

