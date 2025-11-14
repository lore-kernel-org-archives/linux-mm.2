Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24375CE7B0D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 13:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE928E0007; Fri, 14 Nov 2025 08:45:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F278E0002; Fri, 14 Nov 2025 08:45:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC3D8E0007; Fri, 14 Nov 2025 08:45:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2C08E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:45:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CABC01403AA
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:45:48 +0000 (UTC)
X-FDA: 84109335576.10.6EF909F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id EF631140010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:45:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wFJYpw7A;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763127947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOsq8VsP5JBLvdVkh+hvD9nSF/y5uZSmbv6e11sSeRk=;
	b=Ef8w0wDru/JRm0lf6B8JPf5ZBvLgIdM91kwSpkjFi0Or9mbvxIL2PE/oxCcOKfcy2S3tpf
	u6TT28F2YCUPIbV3GX1/RuWPi9FjPcywyTCzLeGGmIZeSmka6qrKn4nSRbiFEYqw+0JcKI
	2frEUgL+mM+s5cG5gjN0B8sHBjoDKj0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wFJYpw7A;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763127947; a=rsa-sha256;
	cv=none;
	b=iehwZAdEeXI8NgGkuI3niDS9l4v9HQk1+Kw0INQFR3ZdM/Tl/c4rcIYwfyrc5x6WCRul8k
	KRiaN9LLKzB5cp7+KyGDaL5eNYLEvBiLD6vQWr4PV7e1tlVaIelx5/gThitg4uopOHe4CF
	4ATjO17SBfahnUpc2D64OIaFKwgimQw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TOsq8VsP5JBLvdVkh+hvD9nSF/y5uZSmbv6e11sSeRk=; b=wFJYpw7A1CHhV6mGIynGd09EIb
	dVyHYk2P+0UywKPD/e9anztoFcZMx2QN7oTpyUCQXgh0EqMJNxnZEft7e8Db8wBD70bVPd5XGF9oo
	2LAgg/Q0LIQY/0yuLQAA/9hrjZ/rzKlSU37Wh4lDY2AKBth8yIBkhHw0hOXOcAs9RTeeRsQGTGDRy
	+vP7eqDmnFYMqANHVWlt4Yn2K6EMQYzoVl2lEH5IECCRLWzhXKEVgT25pGtQuaUyKdxja8e4EzU2q
	PD23xUcyoaz/vDjXHznGVSJjLU0kY2MwJ1Wt0awj1rLG4DlOO6Z/iIgFdE72sJ9zyN+DXypRnd6AP
	/PQS4DPg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJu7V-00000009P7p-0OHS;
	Fri, 14 Nov 2025 13:45:45 +0000
Date: Fri, 14 Nov 2025 13:45:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/4] mm: Use frozen pages for page tables
Message-ID: <aRcyiK3paG1vXT7P@casper.infradead.org>
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-2-willy@infradead.org>
 <aRYiW91uAGH02UGL@fedora>
 <aRYuHl4zKwcwWN7t@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRYuHl4zKwcwWN7t@fedora>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF631140010
X-Stat-Signature: 5tjoybt9kzwqkb1oki1sg6wbfm8u5ij7
X-Rspam-User: 
X-HE-Tag: 1763127946-528091
X-HE-Meta: U2FsdGVkX18b3aPFKwMRua/3SKluIoCLe4AOvdonrgI6rdPS3jyuY/G7aqekzxy032A9drhEr1BWAsyFXx+HjwsFn/iA/+hCvlmoTT3TVXrM3XF/XAnWjMT5mi+T87hg8EB5ykXu/5mEo1vMk1rJckxnZDB4foQ6f90Nzf78LMeKLJ8sk9EMRs1nGhKBae1cysI0LL5Fcg5mqPNmbOSxxqIQPDDZdKHPpViMPP0ugajKmoqcsgT/xbZPzj62ZUprHleg/v6FOKv5aU65JJ/RBuHXCUnvzY5Xu6XV5NrvTceSNfbZ1aN5MGDh3ZVWBGEef21HrevdlNdmDz+MWpLn3P1JmzrnRv8KT8x2AQb/oO585zJ7SdITZRsW7Hk77bYaNWlTeDTzCrAzMsYuZLv61PUKpYp/n1HwWDJLAuK1X+tXrIy25J8tDTDnGUahspRqqdAB3mc/97TsM1cuKbfANpZ3XrYGv2UjlpZDDLCmzRRi2X2xGZgVaRA7GbFwILmQjAhXnlJL8rHgMyg0BXu5Fd+pn0V8Wmv2WWx4OJ4ni86DEIP1lIIq/40fYBCeAu82G3Sf+k9zAVH+4or5EhnIvw3/5o9e7F1c0mj7mFPOrPq1LsHb/lL6znb5x9xrvY/KSlouT2S/+4kaKaVu1PRVRkxVXVUny3kXssF7hhBWJMQ/rFuPeh73EyxPQ3phlMIiv3OGcQ2A6I7TsRzMjkdMuXYL1uqxiQLMa2shb212mG8nmuk3ATMSRnVeCzKuKcmLCLzqxlL0TI1habFCB2AzAC8Ax4CWTSCUcC3NwW4X1HkC67D9PpHIIJ/Acbkvwk9Zv+1Qp3ghAP7xk0Pb+afoggio8y74wH9Zd9hDTRO05RA4QdhD3jH95VYqoS+duCgyr5Sbi2T+BYbAo+1P8z5eZgc5Mms2lvPdU6RDkRN2I0SPGt7CF/50Tru+AbNoG8K0B4dFDpAYkELdq1xtvUw
 3WeBh4HC
 yvTnHVYzZniTkJr7j+dX73IvUxwHpwnNV0fsbqH1Xa9Kvh87IjYoBB2M73gN9tVibqICYvEmioTAs7PcY/myHy0E0HylDqpeziwOE6cnq792aeonCXrt0CRUV7jOen+NdgbBsriu+HkEFhxZ4DJ+YaOoSPcnx3NHkkhLfr8Mo3jT6m4FbYpjbu/PZS3wFTadJZ0S4YOPPmJGxpwTEvZiMdI0vnvgljyoBwc9sevLbRc1WxMA4v1ZhZnT4njACal0EGz9Pq9eopr+pkap4wh3IgNNRo+ccB1tc43lYL4uecKdm+ILyotMAywcps/KFuFqlYxcD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:14:38AM -0800, Vishal Moola (Oracle) wrote:
> On Thu, Nov 13, 2025 at 10:24:27AM -0800, Vishal Moola (Oracle) wrote:
> > On Thu, Nov 13, 2025 at 02:04:43PM +0000, Matthew Wilcox (Oracle) wrote:
> > > Page tables do not use the reference count.  That means we can avoid
> 
> While looking into the second patch, I came across this one instance in
> sparc32. Commit 1996d47a0db ("sparc32: mm: Only call ctor()/dtor()
> functions for first and last user") decided to start using the refcount
> for something.
> 
> I'm not certain this code should even be using ptdescs, but theres a
> page_ptdesc() call in there for now :(.
> 
> As far as I can tell, this is only a thing for sparc32. Cc-ing Will as
> the author of those commits.

I think you're right that this is a problem for the ptdesc project,
but not (I think) a problem for this patch.  Maybe for the wording.

This patch changes pagetable_alloc() / pagetable_free() to use frozen
pages.  But sparc32 doesn't use pagetable_alloc() (sparc64 does).
So this patch should not break sparc32, and it can continue to use the
page refcount like this.

Where we do run into problems with this series is in patch 2
where I move the mod_node_page_state() from pagetable_pte_ctor() to
pagetable_alloc_noprof().  Since sparc32 doesn't call pagetable_alloc(),
its page tables will not be accounted.

I think I have a solution, but it'll take at least some build testing.
Looks like sparc64-linux-gnu-gcc at least accepts a -m32 flag, so I'll
give it a go.

