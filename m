Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E530CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE976B009B; Wed, 13 May 2026 14:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896586B009D; Wed, 13 May 2026 14:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABFE6B009E; Wed, 13 May 2026 14:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69B446B009B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:27:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B0891A020B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:27:01 +0000 (UTC)
X-FDA: 84763228242.16.C2A9994
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id C7D4E18000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:26:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FhMJJ1Xk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UWfRRZTE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FhMJJ1Xk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UWfRRZTE;
	spf=pass (imf06.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778696819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMY3vjl7HirudEIlBL9RQXThipPsv2YSmm9hm08krqM=;
	b=jmjF/gnGn4eMsmtUP05yOwmGxu5jgWJghSroLRtAgkGE9m0KDSDVytTyadcoxmAdUri0/b
	2HRHXfZOWJ/4d9HGIaZz161Gp1NjJTXH8HW8qqWUoy5S3TjD6I2EfX85U2kV39Dw5DnMXB
	+CeEn17FK69FpJLFitfoX/ihbPt9aLg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FhMJJ1Xk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UWfRRZTE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FhMJJ1Xk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UWfRRZTE;
	spf=pass (imf06.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778696819; a=rsa-sha256;
	cv=none;
	b=EhRTUvusc0JOpfoWpUilSPDEENkDpPMMl+xUKxetjGWnRcM8qhJQBeQhS5pLkeKClF2F3g
	ODYLjruV6qdLpeWk2pzUF8tIzfcBl1dAAsHI3yqQn69eYXS0/ZeTlIX8Wuxct8mhSN0Kqg
	jOxQdHa/HSJPSiwwuR4kZ2UAKyrjjsI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2A4E1685BE;
	Wed, 13 May 2026 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778696817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CMY3vjl7HirudEIlBL9RQXThipPsv2YSmm9hm08krqM=;
	b=FhMJJ1Xk2ZqhzR8+BOHNu26g3TctsKnhgOuylmu2zcMuQ9ewQgmJSWlsfYsCiplTR3qmed
	8HXR8BmdcN2BnUs04wQUFnkyXxeh27JKHAbSnHLYxMXAxJs/KT6r4t4eqlGtp/DeAf+1OB
	d610aUqO/vVb7CB2bXQFdREMX9YB43U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778696817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CMY3vjl7HirudEIlBL9RQXThipPsv2YSmm9hm08krqM=;
	b=UWfRRZTEAe5DK2MG9+vW7LYL4ie/9230tpzuWeR8U+Se0O0iSLkfpegh/KmTfRzPRONU27
	sCnPCB7pFBrJLHAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778696817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CMY3vjl7HirudEIlBL9RQXThipPsv2YSmm9hm08krqM=;
	b=FhMJJ1Xk2ZqhzR8+BOHNu26g3TctsKnhgOuylmu2zcMuQ9ewQgmJSWlsfYsCiplTR3qmed
	8HXR8BmdcN2BnUs04wQUFnkyXxeh27JKHAbSnHLYxMXAxJs/KT6r4t4eqlGtp/DeAf+1OB
	d610aUqO/vVb7CB2bXQFdREMX9YB43U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778696817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CMY3vjl7HirudEIlBL9RQXThipPsv2YSmm9hm08krqM=;
	b=UWfRRZTEAe5DK2MG9+vW7LYL4ie/9230tpzuWeR8U+Se0O0iSLkfpegh/KmTfRzPRONU27
	sCnPCB7pFBrJLHAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A108593A9;
	Wed, 13 May 2026 18:26:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WgTxD3DCBGqKCAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 13 May 2026 18:26:56 +0000
Date: Wed, 13 May 2026 20:26:54 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/69] mm: Generalize HVO for HugeTLB and device DAX
Message-ID: <agTCbglgY23ydrDx@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513104640.b0f02b844c57f92bc954878e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513104640.b0f02b844c57f92bc954878e@linux-foundation.org>
X-Stat-Signature: zf7obmwcb45581ykwtf6yyygynzy5mp7
X-Rspamd-Queue-Id: C7D4E18000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778696818-625922
X-HE-Meta: U2FsdGVkX18ES6vJsCB/hrM9Ed4pfA43aUxpNAMwErURVb20P0hczJNwkoIJ1hJXtd8LNhvh7h4+XgVRpwGwvIGoyUp9aMSJ4FjR2isd2Ris7n1obF5RmXcZSP2xBcfkX/XbsxSOsb84+BO06xfOUoQN1hJczsgMPehCfY5BkttFS7C3hkwKTnpTiMOzhxjhnOujbUdCl7PW+uYE5J8+4P7SPEAW+N/J/Pv+GM0eR/nyXZSLy0xtuS5DR1FfsbBDrvBTQrKPECY6C3YajSJd6mUb8QiiQDcf4qlpXp05UdZn4e1/ozqYlGSxgUfQOoe9WxVTu36YmcP8UBDXb4mFCX/chGrmLtGLVbg4Bs4nRP64ZmC0r+EyxYYSnadw+XiAlgABrhZo1norvkaohlVQNn1ByYgbf9QxNbfj67UXq8NO3ZWMxq/sFCNqbUkg7Kq9JBBQdEXEuT8HA5WFEV7B4XC0DNHOr+ne1oD3YmazcBC1luT72KXAOEZU7g4FU7ljBQIYsu9dFag/UF14VXD2IyxM1GzBVPXTxhVDILmOEtcN2nDcNUcqSspN5aUj4Nry+aemB0b4KhuqsmpZvhSRm+srj59zFT5VMelr+lNM2NIZh9iHRNp3TinpnbhJ+gx+rAKV9CaB1B5nBH2Z+jrkaH3GVjJzfDkHGEWVTXUWCFoPgox7gJH1XaMKrnlumU+MpCbRBl6Apr1s1XrHfbXXt7BMUnCngDRtsV7hN+9tSodtFTe3X8IZBn/bwzICSSzwEjthitHe/USKItxYlLz11F1hikCaFx1G+0RzEQ4j8w4fBSxtxUdf0uONeQJgQJGK9e+2cgMF7dbZRDEvGGuVbGyx4s47pUBiJQk1eLx5AU1SLTTKevillHXTUrEaLVWLsPSNY54cit1DihAU3CF50SgP0qB/XhFGHLBwdzzrATtVHr4CC8VVanRRtdSSc1YaDKSZe5k//l4hJdalDjO
 dgVohX7p
 YMJ+MeEpSfLbsimINPtCuM3VgmHIbT5EjjQV5cuU/JQEQE74QORWERVt/ybANF5g0s6AGfRmJj050w8qGXZU8nQEMCGFjGqh+Gvyw8K8wDSDGJnZzNZqY/QE0988Y88Nzm6tltI/JRRT35/HwGo55u5cOWSJeEtclO6N6GzIeErVd2FizRLuS6HQLcPbWNatSl3b1A21IN9tdoGar9Gy7oUq8LqN4Q9Tk6lkOGlxWPATAFc6jq156k3U2/Ij0+aN7hb3KkRC4kGhTFmu6dPUfeysKA60jvqugXwJy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:46:40AM -0700, Andrew Morton wrote:
> On Wed, 13 May 2026 21:04:28 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
> 
> > In this series, HVO is redefined as Hugepage Vmemmap Optimization: a
> > general vmemmap optimization model for large hugepage-backed mappings,
> > rather than a HugeTLB-only implementation detail.
> > 
> > The existing code grew around the original HugeTLB-specific HVO path,
> > while device DAX developed similar but separate vmemmap optimization
> > handling. As a result, the current implementation carries duplicated
> > logic, boot-time special cases, and subsystem-specific interfaces around
> > what is fundamentally the same sparse-vmemmap optimization.
> > 
> > This series generalizes that optimization into a common framework used
> > by both HugeTLB and device DAX.
> > 
> > The first few patches include some minor bug fixes found during AI-aided
> > review of the current code. These fixes are not the main goal of the
> > series, but the later refactoring and unification work depends on them,
> > so they are included here as preparatory changes.
> > 
> > The series then reworks the relevant early boot and sparse
> > initialization paths, introduces a generic section-based sparse-vmemmap
> > optimization infrastructure, switches HugeTLB and device DAX over to the
> > shared implementation, and removes the old special-case code.
> >
> > ...
> >
> >  46 files changed, 743 insertions(+), 1812 deletions(-)
> 
> Gulp.
> 
> I think the first 15ish patches (little fixes and cleanups and
> refactorings) are ready to go in immediately?

I plan to have a (partial ) look at this tomorrow/Friday, but splitting
this series in fixes-that-can-go-straight-away and the feature itself would make more
sense and help ease the review.
Head tends to spin a bit when the patchset grows beyond certain number of patches :-D.

Would that be possible Munchun?

 

-- 
Oscar Salvador
SUSE Labs

