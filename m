Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62596F33A77
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 15:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC096B0005; Thu,  5 Mar 2026 10:02:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F6D6B0089; Thu,  5 Mar 2026 10:02:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B856B008C; Thu,  5 Mar 2026 10:02:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 646706B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:02:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F88B1BDE1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:02:12 +0000 (UTC)
X-FDA: 84512324904.15.FB23738
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 67BAB4000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:02:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=osfIcpMz;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772722930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JM5JonFNOVdHlApqMCLoaabF/YcXP7LkS6bAcjhuBZU=;
	b=1ohNaXjLZZJKeUBTVbLsIb7DjAq8smrjP2m/KLv4hXbr+jwd+Xz8SdAecdCdNNae3al9Yg
	Iciwqjolux/vGOMHwx0WJEeeR2GloyCr9qJ/wfLCn+J0j0GXFTA6QfJJ+NTyDW5ndGriOC
	xEBPkTImMZENjGVwybshBgPFCWSgvD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772722930; a=rsa-sha256;
	cv=none;
	b=VTWzKwq+r49mQ51yMN9Ak+egY3sw6U1Bi2pF2LHrIBjBqYv3RZidXzaiD3L5RnACRs4GJK
	QMa/NAaC40gzYzjXsZdAl2yv7rJx7hLDXGv3V7nYLJpsDqG2wDcJBzQBmI5HHufpHv/fOv
	K6E/c1cJo8bQcwQpchcFQpub9vtpPhY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=osfIcpMz;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A97943C52;
	Thu,  5 Mar 2026 15:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6767AC2BCAF;
	Thu,  5 Mar 2026 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772722929;
	bh=wRgZmhQjr00u6xNwov7+QTN0n9PgF8LRxMXoCLehj2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=osfIcpMz9xkEHd1thmcRC7ID5peuXO60NX3dAfXWNx8XuxafCP3huQAqeo0Z50NTL
	 7WHXGEd9l4SBIO3qFyZSZs51cQDgZ/txEREq+UVMtkAIWHPQdU6rlIkMwasA+X4H1R
	 0vgTKrOo0sYCn09iGpla9DwhdJK5l6HmDrrqVHFOs3zTPxZNOSLtG7KttSGuKKL7C5
	 CGHdJwOurKzj6Z9/m8NtjplDD54vC/3JtqBAJaS9/CVLprX6BFPrW616tHCOxrmc4G
	 1fXwqivYf5kdVG+FCyXb3KTvQbaG5LkGZXWNmjd7ibSYSDapxeuO3BMr8v1Fwg+Yeu
	 JQAA3sGPUYrCQ==
Date: Thu, 5 Mar 2026 15:01:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/6] tools/testing/vma: add test for vma_flags_test(),
 vma_desc_test()
Message-ID: <f6f396d2-1ba2-426f-b756-d8cc5985cc7c@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <376a39eb9e134d2c8ab10e32720dd292970b080a.1772704455.git.ljs@kernel.org>
 <f11ec383-d688-4512-a9ea-700cc2d42f3a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f11ec383-d688-4512-a9ea-700cc2d42f3a@kernel.org>
X-Stat-Signature: 6pco5up6xnu4gco1z6487cuptkfmodf6
X-Rspam-User: 
X-Rspamd-Queue-Id: 67BAB4000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1772722930-77374
X-HE-Meta: U2FsdGVkX1860xaOKVWRiq3eH4DBKDjpLLi8FrazidQnXynK6mWe2nYpLoBbQ2VT5Rh05XwTZulHkKG2A8tIkhCz0Vel1FTcK8qPDQOeO1num6RNeiWDf/eO1Jo2mqUwLkPDJ80prUwR+FaolV8dX+0XsgioiBN0afjwCLePaFszPyb4N3vdO/q9w176AEsHp6Oz3z3F+jXy8vGMgxZQsJ7MKtzv1buSJmTYnU4SMvOhXV7KarZq4IVfHtU/mfDfczinmDF2w75VOJTRkBRxhX4a/RGSKEwLVOxS/Paq5pqMmlzUzAhhdySf7oMnFQGJ2krb9iDVAPD0+z81lmVOvAeTubnCastmxLaICfsBOgrioIOxuKLEPNIZmjSR1xreyMVopCaao+X+xoQyrDfhm8eYkkl9m7VsX4OyJB4m6URE904/c4f08bVpiSPBRf596N0/aC53NGNoxXw/+l8mjkEZusO1LVdy5rnzs2VJIV976T1rN1GwJKKctq4cxozZJ+5SXNPnz/RAIgNtWe6glnKjO3YQkkKJjsQ5NNFh9zSHXVJ3DhJe1fyZ6MH08t26kR5+6dCzX9KYG7owUEWfSBjbjHjYIs1ZCEqzK8sK+1rb36Mi0uCxGokwDctH5/HMPsE3GysNXaESIiSFA8rLSa80SqmPqdRLZbk1KPF5qzduutz4Bul56PjbOcM0CQbn+2pvnL54gkObosVBD/gHSk7nyqf5Cq6EXmp4a1wHQqCOBngXQWHBsWBTKfHdq1h9C9LwAJGNEq6nC2yrY3syiZ7i2+dSHIgcPf266bmQ7AcrCM/8z3uuKBuVCzV9l5mmqsC/gP6XDpBKMZIJlrln+hSe51TT3dyqLiy28Jywipo6lAXwodbJP/e+bKnNK/xwlpXRlbiT193ajzD+9MsMZ/6JqWqK19GbLb4ZUuACTeHglj08P9QUag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 02:52:20PM +0100, David Hildenbrand (Arm) wrote:
> On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> > Now we have helpers which test singular VMA flags - vma_flags_test() and
> > vma_desc_test() - add a test to explicitly assert that these behave as
> > expected.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  tools/testing/vma/tests/vma.c | 36 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >
> > diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
> > index f031e6dfb474..1aa94dd7e74a 100644
> > --- a/tools/testing/vma/tests/vma.c
> > +++ b/tools/testing/vma/tests/vma.c
> > @@ -159,6 +159,41 @@ static bool test_vma_flags_word(void)
> >  	return true;
> >  }
> >
> > +/* Ensure that vma_flags_test() and friends works correctly. */
> > +static bool test_vma_flags_test(void)
> > +{
> > +	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
> > +					       VMA_EXEC_BIT, 64, 65);
>
> When already using numbers, I was wondering whether you'd want to stick
> to numbers only here.

Numbers are for flags > 64 bits, we currently don't define any, it's to make
sure everything works at higher bitmap sizes, the tests currently set the bitmap
size to 128 bits.

>
> > +	struct vm_area_desc desc;
>
>
> struct vm_area_desc desc = {
> 	.vma_flags = flags,
> };
>
> ?

Ack can do, fix-patch for Andrew below :)

Cheers, Lorenzo

----8<----
From 5cc64e6c1884aaf995ce6398e36d5844c246352d Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Thu, 5 Mar 2026 14:59:58 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 1aa94dd7e74a..f6edd44f4e9e 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -164,9 +164,9 @@ static bool test_vma_flags_test(void)
 {
 	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
 					      VMA_EXEC_BIT, 64, 65);
-	struct vm_area_desc desc;
-
-	desc.vma_flags = flags;
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};

 #define do_test(_flag)					\
 	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
--
2.53.0

