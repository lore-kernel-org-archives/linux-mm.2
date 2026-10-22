Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9E0606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UJnljwCn
Received: by kanga.kvack.org (Postfix)
	id 7143A6B08FB; Thu, 22 Oct 2026 06:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5036B08FC; Thu, 22 Oct 2026 06:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB916B08FD; Thu, 22 Oct 2026 06:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 399326B08FB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:16:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 222BC402A7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:16:07 +0000 (UTC)
X-FDA: 85349856774.17.9798F52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8BDA6100009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:16:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UJnljwCn;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792664165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZX0WWzRn0FNV1W6Q0Hw3GlD6+zISKnB9+CPVO6GlfIQ=;
	b=e/UpqA+TJzl+GyK+NY+sgMfci2yU3i2oGNKJ+F/SICjCcOVpCvC08lvKZ4tWkbOBi3/o5a
	BJ4rrPrS+v0Rkk1ZyJ3bQAgJrWkWC5O7L5UHMYoZdet7VE3ccOQ8z3Dt3r8AskCJKXdxg2
	N2br51dDB7LdV8UJFQcq7NHBphkLDKI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UJnljwCn;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792664165;
	b=O9jBHmq1wW0DodNrzc8J4F8NY/ik1nHyj+9t5jn/E+rVpHPLSQS9Ocq3iXBgthMGm2oss1
	TX+TG92vLqgLbmO/eZaNFbd+VBNf6OA8VkJiLyf8qHWU1YFZWIGm0FVRcLZ87uDYaaOCW6
	ce7ajArQbJFGke/PNJgQu9AfoDuVp2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D81C260210;
	Thu, 22 Oct 2026 10:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5AD1F000C1;
	Thu, 22 Oct 2026 10:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792664164;
	bh=ZX0WWzRn0FNV1W6Q0Hw3GlD6+zISKnB9+CPVO6GlfIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UJnljwCn1dmHZXuBKhqolIuDfrXyMXQm2UCwhsR9vEtBUxe0P0goHUgXYEFmtukBk
	 F+pLPn/zaqCgpesNjDFUqog5/LgZpltRlI9b5dkO4wRgr6wi7TyzelAugfcs5S8V7S
	 khUw8tbtBBPl+v34fJg2PVODcD94LH9sqH8VgHOchadW5pW9+91nEi912/iR9sL4Bp
	 m1d3x3gwqimqLdmzzTztApkeT7Fo2ecBSkw4HnSs5SdfJRH+d2K6MCKfY2O49kO7OB
	 fJCrAA3dHiywiaGZOajLDb6J/9r7/viFNk8SnitD6fsgqaA3/mttZ7IG4EL+zGNKQf
	 AWyYPz6bfKT9g==
Date: Thu, 22 Oct 2026 11:15:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	shaos <shawnq1@163.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: avoid broken uffd merge on mremap
Message-ID: <atniL5lYyE28HSTm@gremlin>
References: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
 <179266301162.763593.1501773594946042790.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179266301162.763593.1501773594946042790.b4-review@b4>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8BDA6100009
X-Stat-Signature: pm81iqhsea5pcjxruog3867xo77p13bz
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792664165-833947
X-HE-Meta: U2FsdGVkX19s3f83TGnjxaoWMuUS1K2GkWUzH1P/VgyUiapRlXQ/bo8mjylbpKCRX9HPDZCoL85MLc1O/caHaLIsPltvAMdH2KrRnw7pQgVOZPwRq+i8YgDd2wbGCd2Mni0ex6rO+a02jR1mwSuvH9DHxj9IA4h2eyq2baetLaRgxbtn+TW00ctxkaHLvB5docGtGoWdv61R1pWJ03ETDyYdU/aJ8EalrBcMT9EwGeqM8E2UaEkWmXm1woJTpY5DN53dufqTdn6GmT5+1mqQMiJyWBI1L6A9zpqr8WHaX7XahO8qWeb2+qf88FgTXYjX1/Q272kiXYQ5Be+lVL2y+kx+KcjDgfzZKtfVAf9nVpBgfsKl3UyFFAgaEfXjh2S/2hfO/9vuGq3p1f+2tGbITegZX3cZgmBK+xnRCdsVtNs39dp7c1EutG9d8km21D9xqRWDJv0CKfez2+1xLWprVCXqswAQkT5CqFu4GDrBIFEttzusE/VGYfFxGe/w7rGyrNOgALJ2WrXck7+DdEGjUQlBKcNSjoZkg/+LCTiZB3jlU7zhAy9Xx6Ev9PGI5XmJfjMk1Ziz8xFN/LND/hPJxOwat6CrlhkUUf/ECWAJxrNsGLOAMj6vNIboSZ/BS07gFuJGUjH2p+R1nSLNv7TLjTyswVNbENg88pP+5Z27TnfCXLrtdJk5QTcscsj48pfAj+jBepB1KerP+i8FFrj4Op8fGicFN+Q9QlLFIi+2WppEVZ1C4KvRlg5C713DL7jEM+oRTS+8ew+gjF213ggALzaCOMOeWlAIbklSmfcfql1KWCd2Nb/mL2P6e9S9roArO3lwET3F/B1MslbP6XiEK60lvlqgCNgitMPdoXNFNO8itJIm6IsSJExma1CQA9oirCpPHpHm0ZDLVNwrUv0fyadG/4ACQBPSaNEzIoofgDoMnCHRmMV71MqKQ4/bvAmClgBTAEblaOIxlzgJ/v6
 TdlDfIIc
 WYrec7ptLaZQmkIPODDyjIg15jlF6CHedTHy8g27d2LpP6NT5JejzDnnu5Mi59lpnYcp27cMAjg5GqvmEWE67SX3MwAHpB43SkzO76t4TtSIGMJF52QDhob/eBUl3W+jZDs/HSFEGf6dwBKtbtfDqtHZnCeChuEvbxdZ8mLSl0zEoTc6mn5G5GYYznbMJ16YkxTB1LsSabckcSZZnQcYhTDOsShEQ1BMBAIF5Jh4netNzNsP9lVL0w40NFjwxTpxI5DATnrznaHZRHrUDEZhZPjgZYB13dEsQHDXfqSovvdg8DqkCxOApvbcOQ3JSG6SmWQ8InfCuvRK2U7uogSizvexchorGKbtrNFjx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 05:56:51PM +0800, Xueyuan Chen wrote:

> > diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> > index be8f5161f92a..f786a585caf0 100644
> > --- a/tools/testing/vma/include/stubs.h
> > +++ b/tools/testing/vma/include/stubs.h

> > +static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
> > +{
> > +	return false;
> > +}
> > +
>
> Would it make sense to have the stub in tools/testing/vma/include/stubs.h
> return a configurable bool, e.g. uffd_without_event_remap, and add a test
> for the true case? The existing tests would continue to cover the false case.

No, stubs.h are for simple stubs.

Changes like that would be only be made if needed.

>
> Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Thanks!

--
Cheers, Lorenzo

