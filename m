Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A931A606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M9D9cqel
Received: by kanga.kvack.org (Postfix)
	id A543B6B05B0; Thu,  5 Nov 2026 21:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03D76B05B3; Thu,  5 Nov 2026 21:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2776B05B6; Thu,  5 Nov 2026 21:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 661246B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:53:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E41F21A0BED
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:53:51 +0000 (UTC)
X-FDA: 85403174262.24.9FDC516
Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id E4DFBC0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:53:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M9D9cqel;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.44 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/0b0eFgGy6/51XErR0gRmBAyxz+HU1vOEdRkX/jYa4=;
	b=4opUtT+FKIC2+rbu/LNoLi2jFHH19Ks/G3a92B7ZpFv86YNncDAUmLWksHMIb0HU+cUDpQ
	xU45tNFr8QpFTM0xx3N0ByglSKhcnNU2X8gOt9i5fQN67SCcKXR6ygAXIcJHqS2Fi2I5kJ
	s2RhzA6Sv640JuMIiUhTYVs1/GjXdyo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M9D9cqel;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.44 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933630;
	b=LPRUAy9t9knpqESqWZc2g+nP26glncQoDHFH5JndS8P4NXmdzRL5BIIYTyUl/IynUHO967
	NqwKvfXG+xfJWy9yUqmQyyc0yyc12uocqSxthhWW30xOS0Lx1lTGJRn8Hx7K8Dk6aDcsT5
	L8no+9tAIj5N6N3zZL/TzAP1mBpq6HE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=p/0b0eFgGy6/51XErR0gRmBAyxz+HU1vOEdRkX/jYa4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793933628; v=1; x=1794538428;
 b=M9D9cqelqkYY1RFavnCPTWKYqchdbFaEOL/NPoxfxpdqWxDnWVBcD80nohsqwasPMXtUS0V8
 4cMUG+IQm5nUilGuUux+Uh8CUg/YuwC0IAI9PTv0wC4puA6XnGTTSSXghUB61WjQMSVj/iqfvqA
 A/9cBch4N/fOzgxDDXZ+ipR4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ea04818497cd00a3;
	Fri, 06 Nov 2026 02:53:48 +0000
X-Mizu-Trace-ID: ea04818497cd00a3
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	zokeefe@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
Date: Fri,  6 Nov 2026 10:53:42 +0800
Message-ID: <20261106025342.18229-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E4DFBC0003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jbu6aztbxdtucwd56ihhopzhdgof4hps
X-HE-Tag: 1793933629-894849
X-HE-Meta: U2FsdGVkX18HEG8SK9w2JdKYPSC/hjy3SqwTNeOTydc/OhRyhGgymniMQRNxYyQ55ulwmxluq0FVyAmL9hv55SDdoj4EPeJnoGmluneOkmgmtYWiEfHHMsfGw73uP9E5HupfGRfuJO4mV5PJtZ3ZFGGROKCj4DIUEXIVMYzSMF7R4pC6P0EfetWmc8k8SuLWmRhqL+PLLbzsZ1nrjVhqHhRvE8aemL8tW2AqIviQQkhrTX4M74nUipbpkktIi1VSFiZo/w+NzAHutPyN5t6083ivODj71kSMOE+AZfMyinX37F6ZUR3dCWvhEUjQbDcEI8cAt82lFnQ6CbWpwpuYF+zDby9ct09fifpjVE0r5pMFJPwWgG3UM3aAd4vkXH0z5tqO9NIAdJuTyYdbdiGML8i4aQvwDpM3y65xKTISaM9cyjrg0fFCAxV3QDj0s3Bp8FkkIprVNYo2Pu+cCktFkKGoMsN0Fc15SCWp/Clu6H0Q2L38v5FnXWAx+656li+rOxiUQIoz9UivTHJDM3cPgC8UIS42vNJ6nodeyRT+oLwr1rMlDxW/Q50XNUwERTG31GgNuSy+KBGgb1A/3aw1UwADtOV12HQOWv2CwjsEgkzTEdPXfDqEP3dbv73bu4atqL+px9CQEI2hheT5zpCZepZry86+LP+Uz7rv0+uXxRf/s2Vo7ytW/CHkIT8yhSQOc9+GqX9Z88PWMd3senIMlyTeDC0YhgT1IflZv7Ztay7lp28mGPtUFkeK3DVngSH1vdVDrnYJAzalp9ui50Paq5eeufYmawG8t0029RkGD2Nqf5pG0+DmIGaPIQCEG+jY2XHLWiHVibWa3Klh+JuTwJDElanPn3ZXgY8cvKpIAEQ8VBot2uXbeNfDxN9UcoicbPIrv868DoPiTkkiLKP+5kkP+UZzCd3hEbPMWagZ7R6Syy5HYgpfZm1XVj1pk2wxuq5c2keeIrVf4fiSQBA
 AnoGUVAR
 rx68R6HJY2I9bnJ2VEN2X1YStUTFZgJyRlT4YcIdrEPqR8cD0i4x16RNwar/2nzcNnKrZU0IGFGHiDl1yDOjkRD0mmGfJxBWEg956G9gNXY7esaPNe6Xqj28U+LqCrPMcPfUqhZXes/3B3hmgLUIjEKvdsuC/C3WDuqJ47cocTSVH2uS1p4gEGtU2rgeJLJie8LHZbFXFqfPXGlfTZxSclvVTPpWAFzduskOygcQJZjBmjIAH7LBZpJT7lm6Es6zw4A7jZxHgC04iD37hWZh7yYdNO/CbaUzbAQHXEUUj1+KBzPzPqrthjAB/qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 07:16:44PM +0100, David Hildenbrand (Arm) wrote:
>madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
>uptodate. For example, shmem fallocate() can put such folios into the
>page cache.
>
>collapse_file() already refuses to proceed with folios that are not
>uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
>such folios, leaving handling to the page faults.
>
>Note that collapse_file() effectively clears shmem folios through
>shmem_get_folio(); let's keep this fix simple and simply let the page
>fault path deal with that.
>
>Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>Reported-by: Chris Mason <mason@kernel.org>
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice work1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

