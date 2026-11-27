Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6750606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PeGrTfdG
Received: by kanga.kvack.org (Postfix)
	id A49476B05B3; Fri, 27 Nov 2026 17:40:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAB16B05B4; Fri, 27 Nov 2026 17:40:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90F806B05B8; Fri, 27 Nov 2026 17:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 695EF6B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:40:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBE63A0556
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:40:05 +0000 (UTC)
X-FDA: 85482368370.23.60AD36E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F5DB40002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:40:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PeGrTfdG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795819204;
	b=gVgQwRLh/yY6Dg0j0rNS56+XpFU2T68aG/QGUw7oi7j3IBMwLGWy2Xhb1k31RlyaOQAc+v
	04UV2viTtXU+MA13/xJa8cft9q/BcKvS/n2YPWjESupdHMVJTwEUVUGeio8xreszC+jkN8
	j3wXiixOTgIqIbZtCE4rc2cmcRr3eHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795819204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqVl7s3nCL3EDQZMn8pCExNUlPAOriUN8Wm6x4Ff9ew=;
	b=KWOlLV7+LT0B7Wjsrl3OjEbozno3AaNVySXWKABM2sggh7XzDm+XSjxd4oyuM5Yl4uK4dY
	ASnpUGabTUSlngUYZvjXqqZn0ezkAbThbHOowKQRDEL4ojPn+TUWdzVeSiNrd/+tQiLMpC
	8+qNWyg2Aut5XvpDBDgFFr7zmiora5Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PeGrTfdG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95C3640058;
	Fri, 27 Nov 2026 22:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6511F00897;
	Fri, 27 Nov 2026 22:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795819202;
	bh=TqVl7s3nCL3EDQZMn8pCExNUlPAOriUN8Wm6x4Ff9ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PeGrTfdGw9ydlbpYBaZXm5Z/VqhuWvVZ/+ORT2L8ah+7bHk0KhTMV2Dq8vueRarlZ
	 BvwtW+h7rML7WAVPlcxjc6hNEmbDSCcglK2wMyKNtENm2Y2WH8a9sUXXyiqWl9e0Jv
	 SmUUSH81nE14kP1dVUKINzHpnesu3npKgU+ENrelZlvzZaEEoqJYJjlls/ok7PqaFm
	 hdG7d7Zq2SAMCo8RZ6L4OQwL3l+flxYGWEhw1bj/He0i0sDgqAIW+cECGMKDrGj1Q3
	 L9lRxwaiStycJ9j68BjxxcKGBP9/A3Z5b18TZD0876Ywr0Gb867xLzXL2ShwarAMSr
	 WykBvmW8S2OGA==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 2/7] mm/damon/vaddr: use damos->last_applied for migrate action
Date: Fri, 27 Nov 2026 14:39:54 -0800
Message-ID: <20261127223955.106119-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-238332@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F5DB40002
X-Stat-Signature: qehpxikn9yby5neo1zx5afq16rf5ot6x
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795819204-904089
X-HE-Meta: U2FsdGVkX1+ZePpI6SAjN/lPeO0Qj3iL7aPj0kwEAePMI0cxczE02k0UrqD+ESp0du+ipp8EMKeT0O7jXACHdK3KhMRYXAQZbZiqiDMu/JOZhNpYw6nHW0dJ9bn36xFqCSLtM1GmfVPe8pnGRN36Y5WWOBouwwxw8zNm5xmgcJHJV/qaS7V8l2vN5ySITtWs59fGZHSljhmd2AglD7aOO2m8NAe+sWFlASmKGkw/f6/NfBO87MKp+7GU8Do3oKNYoHu639cMnqUSmb9IazQ3eM3oqefq1JkmgAdcpSmYYG7FA/saCoYdXm0KP5k6RWhVI3umU20Sbjd7HmPk3mdhUIPGCKwfDEdLOlgA9Y+3uf6mPyNka/xQqla2SQ45VpwL7fNPBp7gu39wmAd+8hOBquvsY12RM37ETjvUl5/Y/W8Flg64+l3EKwLe7fsVBoVtRvK3e4/c/VNM8OjC3iBFrYssEiJeXVKIZwOvxfoE/PMYJa5bC7zpZ9S71gwNYIDWqQRJudKPFoErspthmmbQnDqXoa4SL9WAeMpo6GcA5jJFOa9aolwu1EvIxeZZJaynSVMSxyB4MgtJPjsvOwoPkDOGoQL6IlUq4qE3Vsc5NP3euajmK7uqQcMacg0v9FKCyHLySV6TEzFEzRxva/2IxDRGTJH1AkOMxvdKKJbWBV7oIJvQIlWtilfgOZWUvK7L6JJ6AXpTIGgV3JMwur+SbyRLmO6OoBM29tVlQ10SkuRlasYKS/Kz0jBwcz3qXfJdtwfPtn6UDt7qWYqReYbF9r9LpF1NjOge+drUBmV/r1BtdiiqLdSEoGM1jWgH4yVfGMARb4ozXIEapHMRQmfI0CexG2dsdYwGhJcGKOhBuNUnWXzVSBYvphSLas0GvJEuiwk1DVvAd5MBdi9HjZHV2JANION1nbQE6kD/BB7smakP+Mbo1RhnX7hJZh2mys1rxLbd6COClsJq33XEwvk
 3a7FFwGO
 CIp7dnCABngnIY6Tvj+kKZfXjgbwIP9+GchqKUHiGqPSFIEkFYlp8Y6SV0QQ91/AzeLX1+TyIELDpYkgUbA3V7E5UB5UYC7Y3L08l/jJS/Er5FBps3nGntE8HSTb2DBbW6xWSevE0QrWs2+Wqe0nPK3JrYNXEmxBSAM+4HNIxq8weGQPHMnzr7bKdL6eyadPY+j6H0oGZ9p0bn+3TisryIeFlE201T/i/CvdTLarJYfDbU0BwcB7AXrsntAt+qZJGz8mNsRfSA+D4Yzys6TrOxoSWv7odpcRu8S4ic9+LNDf3daTrbgRP0GpNueI2PqQwbAnX/GExeIn+syQQPpu6GV2w5JQCQVuYZSCBrGPIzgsYUEf/jo9EqVAqvc7kYKOfniA0x+wyGs8LjDLcY2IzktQ5tbQywEaNK/Q2oFcmRpRtrcDT7EDOGBEbU1aGydlvhGU5nR0TUONSwUC9lLjd36ivnhwk8loYPKY/Kc10+AKLHZ5igl2lQ4Ngnj91qekJhzxE9kNuTtYQyzEC9iDasotfkcGqEXev5MRS5rzu19oDoOrrV9FPy2dJVCGrzzPhOwGhlCjz5RKKoQcKS+qxVtYSows6r0PmTmVb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 22:33:33 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/damon/vaddr: NULL folio dereference in
>   damos_va_migrate_pmd_entry()
> --
> 
> commit 28e5ee87b052dd198d574f424c2cf49c18aacf24
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/vaddr: use damos->last_applied for migrate action
> 
> This commit updates damos_va_migrate_pmd_entry() to track and skip the last
> applied folio via damos->last_applied using damos_va_invalid_folio().
> 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index ca7ce9bd96e7d..c8f93a19c840e 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> 
> [ ... ]
> 
> > @@ -881,10 +888,11 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  		if (pte_none(ptent) || !pte_present(ptent))
> >  			continue;
> >  		folio = vm_normal_folio(walk->vma, addr, ptent);
> > -		if (!folio)
> > -			continue;
> >  		page_idx = folio_page_idx(folio, pte_page(ptent));
> >  		nr = folio_nr_pages(folio) - page_idx;
> > +		if (damos_va_invalid_folio(folio, s))
> > +			continue;
> 
> [Severity: High]
> Can this dereference a NULL folio when vm_normal_folio() returns NULL, such
> as for the shared zero page or a special PFN mapping?  Removing the !folio
> check before folio_page_idx() and folio_nr_pages() passes NULL into
> folio_nr_pages() -> folio_test_large() before damos_va_invalid_folio() is
> reached.

Good catch.  I will restore the !folio check.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261127222719.105510-1-sj@kernel.org?part=2
> 


Thanks,
SJ

