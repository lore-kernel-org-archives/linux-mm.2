Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DDED2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 09:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83616B009E; Sun, 11 Jan 2026 04:11:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A4F6B00A1; Sun, 11 Jan 2026 04:11:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66096B00A2; Sun, 11 Jan 2026 04:11:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4DE86B009E
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:11:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87EC11A0306
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:11:52 +0000 (UTC)
X-FDA: 84319115664.07.990897A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F3AC91A000A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:11:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XBx97/xK";
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768122711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29aQ501ejql1AKGWkAKWOMmDDfQPHcgIHX+O5IkPtmg=;
	b=0+KvMyl7Sv51+2MVW08tohJP/918bVSdOrAz7W8AbnD9bHb0xha7+3SQ6sj5pQvpJMLKH1
	T+9VDypniI9s6kxyRnKzjl6OYhn2OvILFjqBFit/tMFmm9FKVOzkQ9ykhx3ZN1y8Fczccg
	my56qD5BLx4n9yCMGxGVXEpVaY8xD74=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XBx97/xK";
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768122711; a=rsa-sha256;
	cv=none;
	b=yknuZzTfwmwDA/tP/YZswmRs1zHmvTfGxvlfRZiW1vJkGK8PqLdSydWo6gcXtWXw93pedL
	OUMjoy7ioqK0WHhmVG4rUF83bkClg5hOlEmz8BpEoQnVkU7OHxYvMQTQMU0e+wq9N1FkBu
	8VHiN8Su6F2Fp4vir5MsUGtEuRG3bps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 71DED60010;
	Sun, 11 Jan 2026 09:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD5DC4CEF7;
	Sun, 11 Jan 2026 09:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768122709;
	bh=uZsS9eMgw1qIS04QngwB711PIkKR14sDba+wAXFooJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XBx97/xKW55BHFhSVToAhSY74nwEwwCtS78dADYRniDyX4CCS+3en/HYGMkyrXmoV
	 /AuPJB3Y2UD40BzYuaBuU1jtdVgm9eTzkA5RElTPjcTOCpNVq5sSYYp6Dk99gditdt
	 3M6U8KdpHXpkSSryv8WSVPFLVJFtZPDmWbsJm+2MyeoVvwSUP5+yJHQyvE+DvBLKCR
	 hIUoLfNEZvCsRTUjPlIeBfo3bK/hQ0ujKZrqXZe+/+BLDgjSa23ix6CXF1Jw0Wl2gc
	 5alBnwzzdT2yyhiSc2/ET4a+K+T/6OUo2CHG7R++XQrj1+wOBneVJ8fdWC/d1VSHRz
	 62nNZ6eZ6EuzQ==
Date: Sun, 11 Jan 2026 11:11:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ranxiaokai627@163.com, graf@amazon.com, pasha.tatashin@soleen.com,
	pratyush@kernel.org, surenb@google.com, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH] kho: init alloc tags when restoring pages from reserved
 memory
Message-ID: <aWNpTnZKfjb6yLHp@kernel.org>
References: <20260109104251.157767-1-ranxiaokai627@163.com>
 <20260110162843.ecd8e731bdc281f4cd8e4764@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110162843.ecd8e731bdc281f4cd8e4764@linux-foundation.org>
X-Rspamd-Queue-Id: F3AC91A000A
X-Stat-Signature: tk7h346sydmcyuwkqfnoeekrphzas8h4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768122710-968057
X-HE-Meta: U2FsdGVkX18DgQaTWjPkTFJtT+8AkXnv1i2FfBASTtwRsi+xbOYaTETqfHr7OboIoT6pSg3VhKMTpS1xz540bFCfGc8gwKvEEymi7wHlBxyWbOEpw+66KIVo2lYtz8l0EYlVPWRnY7l9mmHW9cc1UNLN3cQ1h6CYE11OzbWDnAU6Lyk5qRiuqZLgg9nYiqTighLdbq+fTydxJQlZsFrbX8+qn7Z59gP98rd3OhRS00Lf0nsedLhk0wD+qzZ7CW2mS9i92bQFYv08VQLXNlmBwy5mD+GlXfGMYNXxyOjU40VUIK07j6U7c5H5KrUpRQHuZ1uJtpzyMg3hU/5LvNKtuhVVu1OQTR4TLeFBSLXYWWlGCLam9WilU4/XwAuXl4czs5DOOpJMc1nVzOhqrL5Kb29dv/QaA8D1J4bnTFjPfrTOS3QNXZ1N7i9PHzPtlepHMpQEoaFu/GTk8UeaUJNAeF/hbgBd5RW/i+LejvYSmWd2kEpHaEfZWw6SDj068Oc3VIBQCRAS2hIZWEC60/96tz11rlcdCJNG0PL/hrPcKF02nWms2EVjXs4JGuctaddPD2DV3TZfzbV2Mgn+/WHlSrUMNPYjgJN0HaxL9RPz7H1X6gYDu299XkJvN07QjUMJu+ZHdUQJ3KiS51OmLJgmW8Q66yMJPYXpijdRCYX/NJmIHfMGjIEWkgsVErliVsMek+VbfTUa6iNVzVYhRI7zMwvpfbiGnn5iQNyoe1yfC9siUpYrXQb5Gw7jQtxlB8xrIwvlsWCkGQ5VWcl165uSTo5asj3rzp2r4ekp3Ir0r+neGf1Je6Bmio8KFznZ1hf1nrW00URnJpW7b+V46vTrmMa+Lvyug7Ltk9+haQ0ZvZaa30B+fIj9Qw6AgbLEtseboo33ujxscHK/nMVyIIqq1dXxohqAbCYBjsBBmK2UqSertb3CZeooOO5hLHXKEPVA7huIGmZ3dffM2BZcsp8
 9q1V8b0H
 vumq7xsLOuFqZAEP/QhWMcHtjl0VbgHYX9DOKC0S9LDNQoDZh50XfPox1iJmqqo7rLepnDvBteMU20BuhhVGbLrsaBjd9cKLDV/MmV+H+oCX9m7uuTdS05PhPnYY6U446awk3cFoIFtk6fR9mVCq9lFmcK9ttWnJifY9W7XaVycqLEDdI2sJxO+1aAOdEWZB1Xb7/R82RVtED4/FnTg5PCTRvEqDjLihhyBevR5Hay8mrp/vEFGs7FUNEdo2WQfAVWBUcAHOnfoJQZwsEdLogTerpZ9WkesMR/QITGTIafFASWYo7+V7aVuNqd8Rok+lKWAW4XvYhLkBnECjP7eUF0DvAVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 04:28:43PM -0800, Andrew Morton wrote:
> On Fri,  9 Jan 2026 10:42:51 +0000 ranxiaokai627@163.com wrote:
> 
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > 
> > Memblock pages (including reserved memory) should have their allocation
> > tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> > released to the page allocator. When kho restores pages through
> > kho_restore_page(), missing this call causes mismatched
> > allocation/deallocation tracking and warning message:
> > alloc_tag was not set.
> > 
> > Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> > fix this.
> 
> Great, thanks.
> 
> It would be helpful to quote that warning message in the patch
> changelog, please.
> 
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
> >  	else
> >  		kho_init_pages(page, nr_pages);
> >  
> > +	clear_page_tag_ref(page);
> >  	adjust_managed_page_count(page, nr_pages);
> >  	return page;
> >  }
> 
> Warning splats are pretty bad and it's desirable to fix this in
> previous kernel versions.
> 
> To do that it's best for us to identify which kernel version(s) should
> be patched, via a Fixes: tag in the changelog.
> 
> From a quick look, it appears that Pratyush's 12b9a2c05d1b ("kho:
> initialize tail pages for higher order folios properly") is a suitable
> anchor, what do people think?

I think it should be even earlier:
fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
 
> Meanwhile I'll queue this up for some testing while awaiting maintainer
> feedback.

-- 
Sincerely yours,
Mike.

