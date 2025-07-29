Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C61C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 17:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77926B0088; Tue, 29 Jul 2025 13:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28B16B008A; Tue, 29 Jul 2025 13:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EC36B008C; Tue, 29 Jul 2025 13:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A44A16B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:46:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20EEE130E96
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:46:46 +0000 (UTC)
X-FDA: 83718032412.30.0F0205E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7CE9310000E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:46:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OlY7dXwC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753811204; a=rsa-sha256;
	cv=none;
	b=Fg89A92MHUPWkvZ/lKy9NlVNzwEswhJwfQ9mVwIVrYLqZCJTbfPz1cnjmzj5pT0QweNkYY
	m5Kwa2mn54aL2n+mmXxqrbUAlFvpGwElWYiIvs7tgOR5IcAUbJbX80/0WrsT/UXgQq8mjJ
	Vn1aM+nClKO9Gg7Z0F+YsWcnpnPKvb4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OlY7dXwC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753811204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrXBt4FgmqDuyPxXwTJmt5I6fl7XddSrQNuk+0192AU=;
	b=RxuUq2sbz69rXKGKnpd+hj0985EESFhgcQM/HpZmpGUkdmNOGedE5Rw+S1ZX0btuqtddTB
	d2Km+Mg6shde6YW07++JbZhyi4zmIGbSXEsC5Wvn7GjA7h7xDbKMZq2pL9snHmLjZ2tknb
	9vl3gdQrNxgI7gsQgMsf+7QT+P2kVT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C119F60206;
	Tue, 29 Jul 2025 17:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446F7C4CEF4;
	Tue, 29 Jul 2025 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753811203;
	bh=axw56qNK2M0b9TkvZbH1wszkzgL5tAgxNV9SaY843S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlY7dXwCI86fpg+qoNSTeO6Z/W+YBwY1+Ujfh2mG014Qp6YO0B4PSgJ3+Enpz/4pP
	 bfYBXJ/2AZG1Gl2tAhtewL8evwnyfKaX1Y6P9Iczjp/WVj8v+V6Vir3cZ6Mgr77QMY
	 0pN9uoT0Zz8E/jbjgcDOSbGCG49f0Lf+U/Y9JKoFzjeBwh7s+nFtqr4l0iOE0Q/snY
	 FeSrCS3UOKf+vSlok4vS855A7SSP6RLN5L4Vo+gEKLMCDVcykpmTPkAV3ZexHdeKwS
	 pBoj9WvOXGCo0KxEPKVuM8xDzquvO8tAQ4Ezcuu4argY0mFnMIgvkSkIQfnQWC+lFB
	 IsAJWURV0Vslg==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Yueyang Pan <pyyjason@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/damon: Add damos_stat support for vaddr
Date: Tue, 29 Jul 2025 10:46:40 -0700
Message-Id: <20250729174640.55762-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <0cb3d5a5-683b-4dba-90a8-b45ab83eec53@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y1h1t6xmwju3s31wtyhtwsr1tdp4bcsd
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CE9310000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1753811204-277622
X-HE-Meta: U2FsdGVkX1/NTQv+b20UkoIifqyyQmFUp2+Jt2tF740bHPJ7/mY4MIhrfO5Gro5VDZc0hiuhfJBsX073PUWAvvJ6dA4BU28StGs5stKuIzLOFKfLLMXRwnf5i7NzBIBAn8eJxPdotY4CJR5EH9eguyAADPnm7C/hGZ8hu/gXRZUq/qGVOGFVsHDFua8/ExqXVTCY38aTJhiXLEQPzoqls3fCpDLWgEGb/5KtPK/mx/j7DgOImzryqP2OSOwGlq07qXyd2rlDCaPEYef0mzoXZxS7qAjbYL4J5jVwVVEH2AaXnYhpkrWz1CIV1sOH7DFL8loDsc7jPGfyjKX0/P3f2P4tvAxLBba7GTWQ8PGpgGBztooFcmT8vCHgE4CpbU1J8pIbiLQ5uUg1GYSxUj4v7sxWVeb6RcRmuFpoKeAKomcCx9u3HyHs92Jk9m9Q2pIxzj/ADx889d0duhSX2Tz3RfLq0cEiB7bgmQaK94iskECOFfqUOFyjb5VUzCSErtxaKprGQakeBVaK++NBqFwjeqqs6ecOQVFTByp6JD+TppVXqXPW2X5RKaNlox76Iaft5c/uxtlv7kGIcNvbj7tdto5L0h92WqdeNgK5WklvEQeF02ugVbIr5bFchOrP+f4kUnCwyg/waCbyRFZ660LSdL/hfsA+ljmo8sRdmuaGuXlnfHBb7JrcavQA0ExfcWCPDIJfYYbR6DVFmLnAz5cX47HKMuyObgQ2u578qORxfM8CbZF/s+//TUED9iNcy+s+EEucN8LWCEMHWUi3a+YZX4yMZ6DoEVw8gkg3vMtpSzwIjn71waPEoXayxpnp1EtcNZRjBlAosP52lNWibi+1aaQubl3WdwiA8uC+ciJKWk0/jdWQOt6ja48zMhXcZqFvJqfwyL+1tbq/UQoI3xpkcyLv5btPdpd4Fl0FBA8Mu+UlPr6H7z2zrhrMBw1ZXgUONgcOxRmYjdzyds1Egyw
 affO3XXt
 AapWcXI2TPFeSzAfZoO9mrMlpODRcNcQJ1SOflQaBiPLTYffCQumqejvbiwQI+msZ2NRc0mn6jPuHDw0PzZKEKKHhpwxZcM5N+SZ0YsfYk7Q5v4Rcbsq/B51d8+HVUMAEXsRZb+JFJgqGoOOHqZ1s0RJtcme0Kyv1QZiX2pC/gm2EBgbZVCNF3goxaq4Np7ZAkoF6GyX6oaKOOyjC4pSHr7jTQcirMQu+gLjvMUemk//8NGM1btwIFDXRVMmX0aS4SNPbDEu5YwzSLk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pan and David, thank you for this patch and comments!

On Tue, 29 Jul 2025 16:11:32 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 29.07.25 15:53, Yueyang Pan wrote:
> > From: PanJason <pyyjason@gmail.com>
> > 
> > This patch adds support for damos_stat in virtual address space.
> > It leverages the walk_page_range to walk the page table and gets
> > the folio from page table. The last folio scanned is stored in
> > damos->last_applied to prevent double counting.
> > ---
> >   mm/damon/vaddr.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 112 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index 87e825349bdf..3e319b51cfd4 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -890,6 +890,117 @@ static unsigned long damos_va_migrate(struct damon_target *target,
> >   	return applied * PAGE_SIZE;
> >   }
> >   
> > +struct damos_va_stat_private {
> > +	struct damos *scheme;
> > +	unsigned long *sz_filter_passed;
> > +};
> > +
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
> > +		unsigned long next, struct mm_walk *walk)
> > +{
> > +	struct damos_va_stat_private *priv = walk->private;
> > +	struct damos *s = priv->scheme;
> > +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> > +	struct folio *folio;
> > +	spinlock_t *ptl;
> > +	pmd_t pmde;
> > +
> > +	ptl = pmd_lock(walk->mm, pmd);
> > +	pmde = pmdp_get(pmd);
> > +
> > +	if (!pmd_present(pmde) || !pmd_trans_huge(pmde))
> > +		goto unlock;
> > +
> > +	/* Tell page walk code to not split the PMD */
> > +	walk->action = ACTION_CONTINUE;
> > +
> > +	folio = damon_get_folio(pmd_pfn(pmde));
> > +	if (!folio)
> > +		goto unlock;
> > +
> > +	if (damon_invalid_damos_folio(folio, s))
> > +		goto update_last_applied;
> > +
> > +	if (!damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd)){
> > +		*sz_filter_passed += folio_size(folio);
> 
> See my comment below regarding vm_normal_page and folio references.
> 
> But this split into two handlers is fairly odd. Usually we only have a 
> pmd_entry callback (see madvise_cold_or_pageout_pte_range as an 
> example), and handle !CONFIG_TRANSPARENT_HUGEPAGE in there.
> 
> Then, there is also no need to mess with ACTION_CONTINUE

I don't really mind this, but I agree keeping the consisteency would be good.
Pan, could you please unify the handlers into one?

> 
> > +	}
> > +
> > +	folio_put(folio);
> > +update_last_applied:
> > +	s->last_applied = folio;
> > +unlock:
> > +	spin_unlock(ptl);
> > +	return 0;
> > +}
> > +#else
> > +#define damon_va_stat_pmd_entry NULL
> > +#endif
> > +
> > +static int damos_va_stat_pte_entry(pte_t *pte, unsigned long addr,
> > +		unsigned long next, struct mm_walk *walk)
> > +{
> > +	struct damos_va_stat_private *priv = walk->private;
> > +	struct damos *s = priv->scheme;
> > +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> > +	struct folio *folio;
> > +	pte_t ptent;
> > +
> > +	ptent = ptep_get(pte);
> > +	if (pte_none(ptent) || !pte_present(ptent))
> > +		return 0;
> > +
> > +	folio = damon_get_folio(pte_pfn(ptent));
> > +	if (!folio)
> > +		return 0;
> 
> We have vm_normal_folio() and friends for a reason -- so you don't have 
> to do pte_pfn() manually.
> 
> ... and now I am confused. We are holding the PTL, so why would you have 
> to grab+put a folio reference here *at all*.

We don't have to.  I think Pan does so because other similar existing code in
this file is also doing so.  I was doing so because I wanted to use the handy
damon_get_folio() and those are not making real problems.

But, yes, unnecessary things are unnecessary things.  Pan, could you please use
vm_normal_folio() instead of damon_get_folio() and remove the related
folio_put() call?

I will also work on cleanup of existing unnecessary folio reference
manipulations, regardless of this patch series.


Thanks,
SJ

[...]

