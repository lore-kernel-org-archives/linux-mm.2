Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91720E67A63
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 04:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38E96B0005; Mon,  2 Mar 2026 23:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6D96B0088; Mon,  2 Mar 2026 23:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5C16B0089; Mon,  2 Mar 2026 23:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4CA6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:15:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D3691405D8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:15:21 +0000 (UTC)
X-FDA: 84503437242.19.314AC73
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 657B520005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:15:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rEhXhkOU;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772511319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsnfbDJxYriXM7PARNus8j9mg2vbEJtRaMr8poW6b3o=;
	b=l5oCsfSZBmnRXJTuD5NxG5024jj+o+8/KdlUbnOH4fhSBi7xWcm3F/1WyPjtRWyJSADYAp
	5A7uAThRvyl1LCdRioejYmVqhNjutVPit0wxrrHSNbbd6d22Rv3Jlg9XT3JlqYoHJmnRqn
	bE7pg/6tcRH2CxDZYnQcSHeB4xFhxo4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rEhXhkOU;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772511319; a=rsa-sha256;
	cv=none;
	b=CtAQPSwO572nkgQ0muQL3xXPxpoLp9+Lq5vD8zyRJibXSGgpOsEqZYZBblGlKiua5NXXfg
	wSYCtUqjkNkRUH8J3SXx/vw8M3xtGm6I1VX65vrwf8Tp7n3u/UMy4d/DWgQSNCtp4ifcUb
	+C+llAEM3q0jQkNwtLvQyqZ4K+jgCJU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=AsnfbDJxYriXM7PARNus8j9mg2vbEJtRaMr8poW6b3o=; b=rEhXhkOUg11488tgZY0lTrsHDx
	jmSxZ0Ct+YWsK7P7AcGjuP5ShwHVdwUp+39IDEu2C2l2sFP6qQMbq0Ia5efpMushHDnuNszdZ1cgN
	HAnljARuhIaf4QcBsLjZ6W1ulI1ppUq0ALWrCEDt4n1LVDeQ11fvmM6W2z+NaOjDNS/haHjwdYlwd
	lNmdbSf99SoI0wFVNSGsvOpRKZZecK22vuyJ0j9MSR1GyYNulfG+qmE7fOKpQqW1uphySY64igU2Z
	jIX5Ntd1OWOqgB25UM7iNGZgetJa1h0/xCYGJJAGyDrow/Uq25rgnjHvMZ79QU5ZPvekVrJsvlVpL
	NWD6slfA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxHA8-0000000ApKH-2wEA;
	Tue, 03 Mar 2026 04:15:12 +0000
Date: Tue, 3 Mar 2026 04:15:12 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "liying3@sungrowpower.com" <liying3@sungrowpower.com>
Cc: akpm <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	victor7q <victor7q@163.com>, David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [BUG] mm/mempolicy: possible double-unlock in migrate_to_node()
 on 6.6
Message-ID: <aaZgUNxAyKC2IwuG@casper.infradead.org>
References: <2026030310525141773825@sungrowpower.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026030310525141773825@sungrowpower.com>
X-Rspamd-Queue-Id: 657B520005
X-Stat-Signature: 4rmk1ohcddye749ewmhkhbdq98mwdmye
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772511318-77921
X-HE-Meta: U2FsdGVkX198P4iQaJLm1P3yWwsORU7T5qhF/E5syHAh4SYNBpGMwnwXkKo3ceazqYx/hwxUPhf+7oRXiPDGCPoj9Dyoc4+2WYb7c+7QthkYEqu4qm84pQER82iz5jrXhOGrbDyMaHg3O+wLZaQ5hkaI8bIn7FTwslcIEPPh2p/VGHv2f5Jk/5C+5oaiqtldgjCl4zBk6Ryr5oDM/OvXtLbdwiM25MwUl5r1L69rxI5rvf8Nni8MrCQSY4RhzfiXlBrGynKhVjz1oEhrXtZ4aAbggt7n9LBuF+7jExAmvT4ZpF13cgH+pgxBvyVyLd4kMk9fdgUE/i9hqjwGN5bwrKcDZBCOa4RqBwgbbJDUGqRUP7WsyPc+uoEppHi6xz4KUNRTrUl5Uc8tOuNqPCxLz5h89AoWvw9IoyjakOopWGjbcEyxJCpPFhKUtvtJoEmHJCvC2mVhv46k5gHgIeYNyrY+8YQhL+PI2+utTGYORCnUN0VUYA02mCCMUf7gdlWzh0WaXbQgvCBU0WewEr/wEMukZo5L0fRm/18oLL40YcG/hvo8BOrG84jeJoSAwuKhlQeAdrLDbfEO8etpBkN+UP6zh1MPdad2ibdYlV9rcMBTkc7mDRK5lAnjb+PFe5NVqNvWqfW+3rPHCjnIvZ/Fo6N+1gBwebaKOHFGcGOaCwMaZgsv+sBHFTqftSEUgo2y4vnU4sZCwdNPo6mClQyY1VkrDX+869ql/fmv2UQf8a2QzBc3vQ13+rY+SPp82OWiWhoa972cqEvPGyTWNSpCegUfTWEW+DRJolQngwzElCUEwKJDp6GaQLAoy6oLa6VtUUTU/VR+iYEBeW7CCC6i36T+x90ZkL7/2sE+C6UJtGdmqDFVR8LOS3sF5xNFFNhSrsQWqRWZDz5iBm0+ILAkvQQouqXar0RGwf4ySPvr/bIusFksO5KFci5azH5+IedzSXorvvEmINSPxrEsmmF
 Iq2yT7WW
 prbDloplb6OU+j3LFsAaVJUei8duMDuTry5E5Wr1YpiWvZe2AXd6QxiSvIezObnIQRsjo9BCjdRX0WXbWrL2IihOniYWPUFKVQETfLto3H0+lxbBWl/CKgbjh+cjpOd96KtjzIaWApJejLHMwPcGk9ua2F0s8XCYByjhc6X2XsVy8ly2QWFqoxHKZboER8WNBm+L6A4ZYfVb7Rb4BqsYjaP9d6ezZk7EBLAjlrMCM3ZGh207RxnegXbGJH/4AaXDtL+s+BI8Vw+RLs4+/iJ82VAEovHTwaY/0f0wGjxw4HbZ2fEv9sDRXPZZKn1oOyy9+a3e9j9KPTHax7AfaGo7mKfD1xK/KURqyKxeXiUxUp1vi50FpzS/0i5rLa5XSPMx6TEg7wSf6zQiwy6HmzFkitLQBFRVxSpj1cPdtbGBun4/M7G0FOx94UONgiU++jBcxuvnc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:52:51AM +0800, liying3@sungrowpower.com wrote:
> Hi Andrew,
> 
> I found that a fix is required for this submission in branch 6.6.
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=a13b2b9b0b0b04612c7d81e3b3dfb485c5f7abc3 

Agreed, although your email should more properly have been directed to
David and possibly Greg.  Are you going to submit a patch to fix this,
or do you prefer that somebody else does it?

> Regarding the difference between branches 6.6 and 6.12, in branch 6.6, mmap_read_lock() and mmap_read_unlock() are called outside the migrate_to_node() function. 
> Therefore, mmap_read_unlock(mm) should not be invoked inside migrate_to_node(); otherwise, it would result in a double unlock of the mm.
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 54f1b78d1b2c0f..94c74c594d102a 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1071,6 +1071,10 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
> VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
> vma = find_vma(mm, 0);
> + if (unlikely(!vma)) {
> + mmap_read_unlock(mm); // this line should be deleted
> + return 0;
> + }
> /*
> * This does not migrate the range, but isolates all pages that
> 
> 
> 
> Best Regards,
> Li Ying , Light Storage Group.  Senior Embedded Software Engineer
> Tel: -； Fax: -
> Mobile: +86-15651963981
> liying3@sungrowpower.com 
> www.sungrowpower.com
> SUNGROW POWER SUPPLY Co., Ltd. 
> Add: No.1699 Xiyou Rd., New & High Technology Industrial Development Zone, Hefei, P. R. China., 230088

