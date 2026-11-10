Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43E1606A928
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sVl7ceVC
Received: by kanga.kvack.org (Postfix)
	id 0B7A36B05B1; Tue, 10 Nov 2026 04:52:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068F06B05B2; Tue, 10 Nov 2026 04:52:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99176B05B3; Tue, 10 Nov 2026 04:52:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF4966B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:52:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FA861402AA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:52:18 +0000 (UTC)
X-FDA: 85418743956.03.3574EC2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8D1271C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:52:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sVl7ceVC;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794304336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9OCRDpdhl9ezI4Dt9xCnAykvRO5aYgqDXJoDxDcO4A=;
	b=iKreA6h8c4kRY3I7shpWV4zwCJvLOhcb3imRXDasjYGqC/Lz9VsZBTEudVH7uWPtbGZv9A
	DLF41rA/ngaAFgxwJ68qeYbIWkGqb8I6kkONmYE2oo1vOqtVHNvdta6vk+3H0ywJYDxTtJ
	6h7T4J8fwklWV21ReefwqAtPJnT0DIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794304336;
	b=a6OISrXo56pUaBx2yP2KcF//rjc3EULPIjH+28Pzl3oDU2RFZafPI5cXervyEFRZ+HNA0+
	Nlpcbf3/DPglTNQ1J58CRkUH6J/rXAwrCYqJKYvR3gQbn7Wx4SnZJ7PGmidXLg+J3B16UU
	EiJ/yCgK2y15Ieqs0rlyTLvF4J/f9hI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sVl7ceVC;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C0CC1516;
	Tue, 10 Nov 2026 01:52:12 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 577563F632;
	Tue, 10 Nov 2026 01:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794304335; bh=r95rZWFyLLy/Is7W2LahOTY7fMts9HzjUauH3N9Wg8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sVl7ceVCZogJeR0J7IZ4ZnzgP5rcwz3zd6BL4kbZu50h5Ym1pxPDhVQmR2mFBMe6C
	 ahyWZW0agDPSvwbYF7k+BW41V+0cup+pDowAWQL5eFe6qV9c+96Geza9g3UHl+B4Rz
	 NdfK0nn2v+u/BZxPf4MFn6aQ/Qgf372Z1LuYZXBw=
Date: Tue, 10 Nov 2026 09:52:10 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Rik van Riel <riel@surriel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v3 2/6] mm: gup: clarify a reason to check pte/pmd in
 gup_fast_pte_range()
Message-ID: <avLpSsyssYgT_EuC@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-2-2aaef02df0e1@arm.com>
 <a6d539cbab73091647fc2308b69fdab3069b0fe5.camel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a6d539cbab73091647fc2308b69fdab3069b0fe5.camel@surriel.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: wkjoq8dq16sghkxs6mi64878afabzpcw
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8D1271C0006
X-Rspam-User: 
X-HE-Tag: 1794304336-291820
X-HE-Meta: U2FsdGVkX1+nlT31QhaXqKAcElh5EowuogCRnV3PJCxIdBzJyFAX7H0mk3CqP7YtMkt6zat4/g7llrOnaJqga8b2YJbNZ1qv3aTINPTwziNdzlgLsGoIYA/HCMWzJF0XYDbM2N+5sZRPzogrqwY7jKBHpuPwrAaIXDZkV2tkVkeoeDKXv6JNwT51J/aQ+laO9C9KaHuJi0H4VefEBsdfJLdW2W7G29BQwx15WxiWho60ufh6N5LFESA9TJmewyAbY3DXIYH3s/lBdBZ2kY1bBby5s1PQs79HZL/ZjkWnolpK7vDPGsZMr3t88ipjLLUzdCueRcasXBPEBL/6Rb/MVX10GH/LTsKbeGrPgeq2yviKGbQYBn3O/vJRb8yIBoo7YcEJBTdUWTO1Q2NA73dNrwmZDSLcEmwewcj2vr5Bov70yvIya5YgFrmEMoyMIVJZ75IQ7TGiF/LypBUySQzbVeO4vJIq0b7qej2N2RkVJX/FI4VFObzupRPNqPhS466EgPUMOlMGaktPHe2M502xMDECVUonXGUcu9QQfRQ/ig008qk+kZN1k/7smG4XndY8EPUZbm2ulTaRpv+bxIfQAl0snB3ZBOSR4iQpMR1yl07+Wckzw/3nBPEl+sh+yBAAQmHorViZEmfVDT9gQ8NGnjGQaY9qOQtNHDLA6Rh/3BcoUyij4moVs5IurvMDCFu/u/i+6YLC0H580GwkjwEghE9H0t+abAgUc6WtXIaYuuzzDwomTG9iTMPqiYYwywzHdj9XQy+KHmDpj8mBMgLrV1ZL7tTORl6lrD7UYQVTLBvuM2xegYkNsZIsI770tpgg1G6U9VHZGGrbq/o1Ab59zvunrIPS5EUgu34TH7qvPlc+IZ+LXYAeA5Nl5XADowig8wIZaYJlA8BXIqeP/JGRGZjn1V1AvH6neZxAaqnQdj2MW1YuRAl5TslcsJPBrGwTqL7PQwgw+CdoiITkLSB
 u25qGej4
 sq5yQwaQS8DmlgnKhI/rbo47ja4XuFh4JNNY+EldSVkC6IVHb2cJjJiMuj7f3D8UMOOAcFpw8nQhlI4nm8rk1c3XFHOOb9HxaYAjTN3w1ftsL9pC5ou1CaVC0S7hjCDghVGBCP3fhsxxx1G+EtBxoLLJDhMRxH7WFXpCYFLc9x/AbOoO7F4vRcLtaP7X+TGLdTQKGcopA27q1qDncLWRQb8YKJ8BmRmmXORM8Zw1QTBZiaRdCtSCzDBoHENdbUQ1KkZ7Y7rBL2yB/LsboemLaVDSG4EnV3SQiTlcgFcAjnyATJfsfJuDrRy9HjKIFh4ZilGTVAvppXL3CIg5K6assbVJremtLSFo1qLbWu2PZvlP7AjiOL+Xv7MgpxWVfwcE1wbT8SIGi5hVchg+4Nc//+B9vdYj3GmKDNZuXeh3SrePk9y4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 10:50:32PM -0500, Rik van Riel wrote:
> On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> > Clarify a reason to check pte/pmd in gup_fast_pte_range().
> > 
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  mm/gup.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 7d43ce717b246..7f9348c633d58 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2881,6 +2881,14 @@ static unsigned long gup_fast_pte_range(pmd_t
> > pmd, pmd_t *pmdp,
> >  		if (!folio)
> >  			goto pte_unmap;
> >  
> > +		/*
> > +		 * Recheck the PTE after grabbing the folio to
> > detect concurrent
> > +		 * unmapping or protection changes such as by KSM.
> > +		 *
> > +		 * Also, recheck the PMD: THP collpase can detach
> > the PTE table
> 
> collapse

Okay.

> 
> > +		 * while its entries remain unchaged. Checking the
> > PTE alone
> 
> unchanged

Acked.

> 
> > +		 * would not dtect that we are walking a detached
> > page table.
> 
> detect

Sorry for typos..


> 
> Other than that, Reviewed-by: Rik van Riel <riel@surriel.com>

Thanks ;)


> 
> > +		 */
> >  		if (unlikely(pmd_val(pmd) !=
> > pmd_val(pmdp_get_lockless(pmdp))) ||
> >  		    unlikely(pte_val(pte) !=
> > pte_val(ptep_get_lockless(ptep)))) {
> >  			gup_put_folio(folio, 1, flags);
> 
> -- 
> All Rights Reversed.

-- 
Sincerely,
Yeoreum Yun

