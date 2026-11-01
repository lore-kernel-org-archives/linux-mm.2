Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85206606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqNC3NC1
Received: by kanga.kvack.org (Postfix)
	id 931BB6B05B4; Sun,  1 Nov 2026 12:21:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2D16B05B7; Sun,  1 Nov 2026 12:21:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820906B05BD; Sun,  1 Nov 2026 12:21:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF5C6B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:21:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3EB1160936
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:21:42 +0000 (UTC)
X-FDA: 85387217244.11.01C0DA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4242940008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:21:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YqNC3NC1;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553701;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPRODuptNXZdkhl8l76yddILf9I1UG9LWBNv7LQOJiw=;
	b=sA1rQBUImXs+kFcNbgmkkSQ9Y3sGU4p+LzL0C7nbvhbViwDaOFCPW0mp8GqS+eAwZdQsp+
	7kcQIdxtDgYn52NWJ1d5UsR9FT2aZe2Ilr+E/sQuyKvRs63YaaUJcSzkDzaKrZJqQ1lq7y
	GLZMGjJV3XcmDxk40ykvf4NDdKDfU0E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553701;
	b=x2pcvbB80YEbA7eRl/6KjbKZ0OdRTiqZ2zNf4o1C7kMykbk5IjcbGeGnYS1LrxYwbj0lAa
	q9LltJjP85P+Kj6J/91Z6Y2oAzhywUS/zh9q+qnQw1Gtss/afM80SDmXt3ldUdRjZV0900
	fKjPQ1ZDAfSUOyK5g+5eHJ1NhgQZYi8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YqNC3NC1;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E4F24060C;
	Sun,  1 Nov 2026 17:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F53B1F000C1;
	Sun,  1 Nov 2026 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553700;
	bh=JPRODuptNXZdkhl8l76yddILf9I1UG9LWBNv7LQOJiw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YqNC3NC1Slcf+zh8YkkZd/uNePiYEwCworQXME2nbDCX7OBbTK9iOcjAhilllCwD5
	 s9zefvdtNGzLbliOtAFp3pLnoBu/usJ2sQAm5wGu+ppvAekmOnhmEs3Iob/tkQZdwM
	 c37GCRXB7ecvmOIR+Ge2qIGO2B3cwH1ictAg0/G4TWjCAeZRbyu0zZ9ttuxUDXtr3q
	 9MnTiAwUy+/d/12v867/N4015Zh0BmezkeN8kYCbETilBqeM+H5bDakj17OVLs2JiJ
	 o0QqSz73m6vT/g0JB+XbB9ae3f8WplHlrLJpqeh/mkWGH46nO3TNeMWsH09kSuPnle
	 a4RFXSV55hMwA==
Message-ID: <sashiko-outbox-192523@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 3/6] mm/damon/vaddr: implement sz_filter_passed
 for migrate_{hot,cold} action
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261101171630.81477-4-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
 <20261101171630.81477-4-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 17:21:39 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4242940008
X-Stat-Signature: whsap4qqwt3gy7e4hj9fxy7cpbdy7o8a
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793553701-529629
X-HE-Meta: U2FsdGVkX1+Th52BxmSCHcBLVtG8EczqimY6AuRywjnUO3zvFZv1O//U1h2CBrj5fLFl7t+ieYNMXj4JJ8z9STgPxCKRI53whs6HhEeYHwo4vBDsuUjJn5YPBhcFaHeAelMA3RZxyHX6zNfPtoJGocX7eWNFUZSTNjVBE32lntJ9LozeDA+6VHip25x9+kcW2q61d+EMwQhKN2uzYmwO6DOKTQLqTGST2u/uxqMQp47X7KdRI9gdHzxvDH9A2xjfLWeuxcCsPXY6TwAoh9MTrc/VLIJ+RdO0cALabRuUaPSPF0+AJw7XmZLoJ+gkDvOkNg4otgT+6kUCUgNw4Jc7DDxwqd/hqThkX6Sgbd6anGpfnRTVURtkTodVNsn9PgPbhn4ZMZ2eMbN/JxMW56pa8PuhheaFrTBFPPJM52BtH4qG+lSRg4qcPxm0gL3HluPS8Jj/8tO/Ph6AQNipR3Bv+ltJfBMyfp2by9whp71GAG4EV0VR1tu7aOQXb786weRu+LzF7z1nahlvURrUGQRRVJA5bdgOWqLF1NIdhYMxXzGJYrGksMM+hjB6sUBvEBzVkiIgIwqPVCEMn2SVb2N5A9ZjByKlJB8jfEpkvz27QMbaCbwWYunotZZ6MKZx2Yg9lNDLmWL8b6KO8KfL9G1Z9rzd2ZYyHUceTBGlBaTkJ6Ba190cLSfF18gNMPmmfeAIMzlaShvh6H9qBJGdJoxbmMhZqZgQ2CbfamqGIDNKFPsHtph6AIcunw+3b45lvUhCgRwsMOC042pBlMPimiZz6hmqnvPrX3MAKZb5d4rAxdXHi3Eh9yOE+g1AyMomKB2y4cBiPzvYvj6nAuvYPQeO6naeVieICLHKtHB7w8plxmGCLHvQ7Kd24R6kI1NZYvUXAah/ygO9PxvH6ml4m1/aXCeNdQ3RyrFNyNs2pB2+cHaHGv6VdnyLxQRbzfjvWzLzD9ceQB+ZoLTfdbeBeLX
 ZpfabXo/
 RWuU4oQiwZJ7W7NpII5PzOvppETzRevoBEDETxpvLJkEO+Jns/Z36TA8tC2/MUynHAR7MiOIcqq+2YeucPzkvwE48YWg06Me6BZfPYoTvMnzCXgtJ8JdcMhsQXWtUL/9+9RPFBPbTVwvhcaN0eaEc/p2SYsPhaTl/MPBxjKUdBV2exjksHKJuMyYkYXNgJYYIK5+sp74e1QjOXpD2sNUzwyzYqObfgdPLOJIPdGtOMs+O43ORpFz3dPD7cY9h12Au3xE0zDFeK0sURkhxmf584DE/qrwTiZFKvioXB1DQ0qDSXmww84baX7cOyq8h/ZzNd7xY4poOHGNCMiZghBh7qEglX0n2To7sd2oM60mSRl8Ocvf5aVd4CuBVrUQwLKaLYwXmpTaH+Szy383sQ7ZaPTlH0BbcIDZvSf3xZ+ii6zjaLrPgC8l/gVSKT+UC9orKepNmkIKeug9UYdd3Q6RIpD+jma9L6OeyvzRB531PAaub7wJD+XGAUPjKjptKh2npIjps4949cG2DDl8KW3Fw3Z9ykN6jB9/u670DOFiP2MFmqrxL68Yzv/hl4C2xgQ4w+9mczTxxdRyQ0n7gb0DfLxh3waZpIUPzuXDrAS1NwNEoqy3grQD6cQ8iD53XORTKyHzb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] mm/damon/vaddr: undeclared dests in damos_va_migrate_pmd_entry()
--

commit 7670e03c4d866e7e831b34d6066cefe5b658b73a
Author: SJ Park <sj@kernel.org>

mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action

This commit adds sz_filter_passed accounting to the DAMON_VADDR
migrate_hot and migrate_cold actions by passing the counter through
damos_va_migrate_private and accumulating the size of folios that pass
ops filters in damos_va_migrate_pmd_entry().

> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index b1d7bcf7305bb..6fd0e07b60705 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
[ ... ]
> @@ -846,7 +847,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, uns=
igned long addr,
>  	struct damos_va_migrate_private *priv =3D walk->private;
>  	struct list_head *migration_lists =3D priv->migration_lists;
>  	struct damos *s =3D priv->scheme;
> -	struct damos_migrate_dests *dests =3D &s->migrate_dests;
> +	unsigned long *sz_filter_passed =3D priv->sz_filter_passed;
>  	struct folio *folio;
>  	spinlock_t *ptl;
>  	pte_t *start_pte, *pte, ptent;
> @@ -865,6 +866,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, uns=
igned long addr,
>  		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
>  			goto huge_out;
>  		s->last_applied =3D folio;
> +		*sz_filter_passed +=3D folio_size(folio);
>  		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
>  				migration_lists);

[Severity: Low]
Was the declaration of dests in damos_va_migrate_pmd_entry() removed by
accident when adding sz_filter_passed?

Both the transparent hugepage path above and the PTE loop below in
damos_va_migrate_pmd_entry() still pass dests to
damos_va_migrate_dests_add(), which causes mm/damon/vaddr.c to fail to
compile with an undeclared identifier error when CONFIG_DAMON_VADDR is
enabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101171630.8147=
7-1-sj@kernel.org?part=3D3

