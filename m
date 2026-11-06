Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BA3606D802
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O1KHYVFy
Received: by kanga.kvack.org (Postfix)
	id 44A416B05B3; Fri,  6 Nov 2026 05:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB4A6B05B4; Fri,  6 Nov 2026 05:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9EC6B05BA; Fri,  6 Nov 2026 05:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14B9C6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:52:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB4161C4795
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:52:45 +0000 (UTC)
X-FDA: 85404381090.25.B32528F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 35EC580004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:52:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1KHYVFy;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793962364;
	b=swcptSNRI0DzlOd9M0t38DLm5r6nyh7t+qKekeOOVNsp95+PJi9XBjzDbQpnEeLsC7ZluF
	36Yhm/C6tJLF6WKhkiN5M7U8EcPcLhcfUA9OloddI/t4C4f80I2lVPBqIZYHcOpkPFdQ1R
	190/AdXNBU+uEUvNVZiqIWnw0uqyv/U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1KHYVFy;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793962364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IipRvfPIMKelf4OlAzS0rfpJdyGEHggDGJZF0EnJ3IA=;
	b=PF9HCDcY/oyWfj8CVFQMighhSBTmNgXsQBWKknHx4ADFxP+vBMjGRUmFc2oDrqv7PYEt1T
	XO31ZEAo84Jl+lzv1wAFEn+WNh1/8331yDXBb2zGY4HAt5D2V6veDxCwA2+BrJH3Wm2iPw
	/BoAYtBinGBH7jIngJ/fo6LvgZM1UwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18BBF40303;
	Fri,  6 Nov 2026 10:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6151F0089F;
	Fri,  6 Nov 2026 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793962363;
	bh=IipRvfPIMKelf4OlAzS0rfpJdyGEHggDGJZF0EnJ3IA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O1KHYVFygZZchPdjIwJte/lvHxpw2lNPlReMb4MMCSMUsNgNbaCXBSI9Yxkg6dHie
	 LNURJoc7p6V9oLGlFhJpjUNCR3k25Oj8Th22ywgA72JFQJ6m9rARKrxIKNgZ4r+owm
	 f5KdKMUFVUSAxv6ChwixgB2HD8i1YGJv+x+VyeCfXIFi+7iInPzfgnqj56VGACpfCH
	 FelX1NyVxb6H/spDXbm2vzujlj4ffQakN8rW9Wm9QSHmirLzsVskLmji1AXSNIePv0
	 GVuGb1hq8lvPhCUoUpqZi/yXzOfHyHilXX836cltlW4vQ1lqueQNTXXCIwj3LjTZWe
	 zIoDeDIqU/KFQ==
Date: Fri, 6 Nov 2026 10:52:37 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <au2xMK2bKlpYsE_Y@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <a6333eb2-d51f-4947-bde6-f61ef52efb69@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6333eb2-d51f-4947-bde6-f61ef52efb69@linux.alibaba.com>
X-Stat-Signature: c6c87shc9u9xtbigb836ycyocmf91ith
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35EC580004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793962364-430236
X-HE-Meta: U2FsdGVkX1/l1M1cbOWXRqQKoZ5AS2uL6hbv84lLWS/Sm0e+9JxrOzlRLTZ8nAj15dQYnnOGM4Op7wu4IDMcqQfrg+WIpok/u/2hmwhiOizpO9edqKqC2on+BU7lAimOIpMA78FkoFAkfHiomNWHdXqb7hHH+DGeHbpgQ4JKtlwthffDEWe4giNmkGjDGmNlcgGxV0DcR7ynMHGzCEZj4Ff4nI//gPrUAw0w07XUTh4jmEJmErjoHK7IvtIDhcsWtAfvQrlZCoFXt1NewijcKAGbaqQzqp53jBX8As0xjqff5J+BBhXm/tuf6MAxMQAeoio7/QtZmbkp0PCiR8iObNXuEs0O7Cx9NkpHBqc/+XB00DcjO7SkfohuZIdr9WaXtk7e0dSEbArppa+zsgGV0sw1kP2L47Pd69YclxcHD1ZqmHf9VH6S0Ckc40z3IJ0GCt6r8qDKVsXNbyb77hl93+il0jYREf9ItcPPEKUB22evxOUm0yC5rt/d7YjILliCzpGObAx2TxgH4Avn33G1Pn5ix28/7irQI/A+RIXWDdlF667uxbt0hle19/0+OPjYyVuz/xhRNXCO4EZ+lT9M5gvFNbxIIv4Oo/02oG8plkY7GukoKSDMH0S3ZkDh2uCPnd6JFU6mK48KRrgKld3fLYRZsWRyqfbBqTfYY2gwt5ArfVHk8Ef1TQWvXtAp8Ece4LDlkC19GS3CF4sAU4zIJ2rnpBGVDhnOZ3oBXbA2EVoC9Joube5s6xNvP3eMDX0rZAHPNQGQlBmLcssdOj+D6cHfJQH7X6grn1ZZ1HkkrHScaUOQ9zoWjwll13zPLhrBybtY0Owhzb4BW+B0WPnUcZSobUNzPFexmjnLyy1J54t+1lXUPL5bE6VIiU/VLGHcZhgXE8kHl8NgTdKoaCVsXvQlE5eVw9KXkBSez9THXbkM8Z7qBRK22t0eBLzNE7n0Z8oLO1ILC2uyG2rdiJ7
 MJkU5ROg
 1RVHWkN43LnCjl2eMaeonCXcJdfcdQo+yC5hneDmIcbGxwlnYCTs54muTGMTBOoO8XonY7hFEGEX6sfhwt/jenYelfx+mhLEKzfXHeR6kBiC0L6by9m29OVVt8L9z5Umtg0k2JCYjrl0eToI+dT1Q3BJs+NLLJcbpAp/rWe5lutnY21GD2h3/2iuzkCLzkI+MEwTub9mxjI6Dr6kIG2fL1KiDRuATAzJ3Ilyg9t3So/s+BYIIuvwpN+Gr7goaijmL1eUB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 05:38:27PM +0800, Baolin Wang wrote:
> >   		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
> > -			/* Unable to collapse, skip to the next candidate. */
> > -			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> > +			const unsigned long next =
> > +				ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> > +
> >   			cc->progress++;
> > +			/* Check for overflow. */
> > +			if (unlikely(next < vma->vm_end)) {
> > +				vma = NULL;
> > +				break;
> > +			}
> > +			/* Unable to collapse, skip to the next candidate. */
> > +			mm_slot->address = next;
> >   			continue;
> >   		}
>
> IMO, these changes seem to belong in patch 2?

You're right, will move them there on next respin, thanks!

--
Cheers, Lorenzo

