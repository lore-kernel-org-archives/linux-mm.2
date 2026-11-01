Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE01606A334
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XvAYE3bq
Received: by kanga.kvack.org (Postfix)
	id 7537A6B00EF; Sun,  1 Nov 2026 12:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704056B05B1; Sun,  1 Nov 2026 12:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643A76B05B2; Sun,  1 Nov 2026 12:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5BA6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:37:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4DDC140899
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:37:39 +0000 (UTC)
X-FDA: 85387257438.05.0C56EF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1886E20009
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:37:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XvAYE3bq;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793554658;
	b=HL9of3uVmg8rxj3F5rEkl73ons21lIZVCXiRx5ms86zQTcdbpJJs9PKcOUNWsaBMRo7tys
	+Fk0FqNeLvZtRoZBOekv2JiwrNEekaWNnBR1N2Q0F/W/avbfHqUJfBVXrGOqaFkFQP6OLT
	Lf+CsTDQ65d2N01PEjYzs7zfi7/YYaY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XvAYE3bq;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793554658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMaecMqOlVRGUh+8OqrsInbsoiLpkH+gXXcFWIMg3iQ=;
	b=Ti1trr7MXEN37b69JfRM+U6lnltscozvaoe1V+uNje9eAcP/DV25ShsrQGQa1EZotJtxIA
	HCIiCj2EArKTUMeovNv4pOh6jEkurxJ0epJqal9JOclEvhOt3vwceaYEbtltqdbabVAlUN
	cDU1G+X3Q4Cy8BrPtY5MvcHN7Em4t/o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94ED7600E2;
	Sun,  1 Nov 2026 17:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275091F000C1;
	Sun,  1 Nov 2026 17:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793554657;
	bh=qMaecMqOlVRGUh+8OqrsInbsoiLpkH+gXXcFWIMg3iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvAYE3bqY8JCXvb3i2Y5oUe+IYKSKxDpN8J5kkzFBAqNLzZsgBoqTNfEYU6AabKq2
	 bG6g1xqikhvh1v7eMMyORcUWMIk3YoRljaTRVvwURIWWifghbYuAk3hoYNyGqH3H6x
	 wp9FYmPJX0UnF30eZg3GIIKQdPBGWnqn0/gvd2wZhDPEWexHQr7YFwL/AM3lavClkl
	 G6irBLpOJxEOelBT3nx6ifdvzAo4iHqBJK/BflbJu1UpmjwNVUmqBI64FNZhSt7uhQ
	 0r6hoY08nmhezf9QpgmtlDyD+keOc6HcoTZYINpvyScH4qboNt6Ay53B1tpFVR8j+4
	 njjc6CJ0CJRiw==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 3/6] mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
Date: Sun,  1 Nov 2026 09:37:28 -0800
Message-ID: <20261101173730.82717-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-192523@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1886E20009
X-Stat-Signature: a4defypy5tt8tg9zqwdddqga3hgt6p8n
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793554658-260368
X-HE-Meta: U2FsdGVkX1+4Orp7kxT+dt9sF/oM0ZGoejysDT88wgfV8zfk2Lu3MxzVDDW30kcqJ5BpHJ+EfIwQqZ6pn8rLZIvbRUwjzIGcExs0fETPKN2DhGflHMGnFEiIYngjBhGZlLYJUyyQd6oueidqQB4JKDm2PUu3jeN+IR/VBbSnqqkMfIPmVC3dNVJM4yk7Md+86o6r2jYulYWL3+RQWcQC+EF4c34QTV8llwO83NrJoJy95/6BCF4KbaLBNphaeYObMhp49d5EwBpTZkz8xbp0SsVADq6O+Q8e3jx6ofBpjuFnBdilt8tOGmrinUznfSGiYq+8fCx+DIzzjFIs+bkfv8h6nqfv2EmPB221S/KXcx6us09Wn1j43MpvikRSCUvK4Ss64LF0dzD8R5W2jqkIxhYhieavasbIp9vIxqJZoGJu315Ml7VyuyQd2G8fnxbvdnHjhN3EZz0hnKg2cwW7hwa2YJB9Y4Eht6icoug3WrLJlbzsJjbBvdJcvKQn8Dvf23LWgeekqHQpSXFAvFIp7Xu6IqInAy2lUzdyBbOY2VwjSFPgR0cIMka7Z0pNGzl7fFlyjA9Z4T54c1iV2iOzA9ywxeGNHBTsFOV7QZCp9OuzzZMavkVWDuWshiXI0XxAXblqT9TfSTlyDyfiEZUhTvHxu2+ARqeCv2ggLajn1i7pbmZkqHZtGjW6LbDn6n16+FLS3jCROX09U+Fo6DfEInlfQ8bY3tSOOY9OmCRgfdgojQpGHBHqszsefebE8Kqy5yaeFW9BgAsiFInMV2t6/uspgvCTeZZzAnSQxVQSyuxpXrJeTxdUs/6zV4Q7Fn+MnIZIHt+9wUtp4SNXbX4wOYERzD9f0WfRhskONg9lh7GSp7FgKPPl92fTPalhve35Q3n83lctEns10dVan+glylHYwuzYYSPTGYg3H8b6mjTypbk2jRvNpjSO0t5EDBMc5yzHdsmwpOaYiR1kyS3
 hQkvQoOH
 fVjKtEjRXAgDSOMbpHGYLM2JLyXo2KuYZadi5feTZaFBYCV9xxaVCduR0klQyw+CLUyO4RyBmde63a9ZVAziWTjIVgBl92PccD/VQpaabzQMOmJqthP4VmH90pM0v+nXSXd8pZ/7iOJovsff2RbplcgfbY4cJQJjWuhui+vqmed/l8ekKRtwMwgsnZhFJUHwKWU12gkNxX/kdp4sPyst7uMwkpQuIh2UVePRB05v8jOr4jvOmyNOUZM8S3/nKaXIS3mTPGlbNcXVJAJ+8Qfoh1MFvXyu7bmorzNjfRrrnLgVI9QVwpXdgzJfeyNyCq/INi3V0HZMWyiqzVjUzeqipmA675Zuz68xj8kpLzuXRG3gJZQxklOFEToadDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 01 Nov 2026 17:21:39 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] mm/damon/vaddr: undeclared dests in damos_va_migrate_pmd_entry()
> --
> 
> commit 7670e03c4d866e7e831b34d6066cefe5b658b73a
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
> 
> This commit adds sz_filter_passed accounting to the DAMON_VADDR
> migrate_hot and migrate_cold actions by passing the counter through
> damos_va_migrate_private and accumulating the size of folios that pass
> ops filters in damos_va_migrate_pmd_entry().
> 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index b1d7bcf7305bb..6fd0e07b60705 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> [ ... ]
> > @@ -846,7 +847,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  	struct damos_va_migrate_private *priv = walk->private;
> >  	struct list_head *migration_lists = priv->migration_lists;
> >  	struct damos *s = priv->scheme;
> > -	struct damos_migrate_dests *dests = &s->migrate_dests;
> > +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> >  	struct folio *folio;
> >  	spinlock_t *ptl;
> >  	pte_t *start_pte, *pte, ptent;
> > @@ -865,6 +866,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
> >  			goto huge_out;
> >  		s->last_applied = folio;
> > +		*sz_filter_passed += folio_size(folio);
> >  		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
> >  				migration_lists);
> 
> [Severity: Low]
> Was the declaration of dests in damos_va_migrate_pmd_entry() removed by
> accident when adding sz_filter_passed?
> 
> Both the transparent hugepage path above and the PTE loop below in
> damos_va_migrate_pmd_entry() still pass dests to
> damos_va_migrate_dests_add(), which causes mm/damon/vaddr.c to fail to
> compile with an undeclared identifier error when CONFIG_DAMON_VADDR is
> enabled.

Yes, it is a mistake I made while formatting this patch.  I will fix it in the
next spin.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261101171630.81477-1-sj@kernel.org?part=3
> 


Thanks,
SJ

