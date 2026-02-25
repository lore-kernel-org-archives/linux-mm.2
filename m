Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9561AFD45F4
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C426B0089; Wed, 25 Feb 2026 16:01:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A526B008A; Wed, 25 Feb 2026 16:01:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46256B008C; Wed, 25 Feb 2026 16:01:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ACB766B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:01:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4528A595B2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:01:22 +0000 (UTC)
X-FDA: 84484199604.08.135C4F6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id AC68340010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:01:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iufhk8Rr;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772053280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljBa12aKJZbgxi3pinlImLFV5DTWyizlkuBiwkvq884=;
	b=qrGJW6oCBzIiWqBRk5ZAAG/3ecjt1grUbjaSLd/rXz2m3f3uFMh/vO1umNj1AJE4UxviZW
	6QATY7GZ4nJZ03j5asRmjeHgNwbHZVyU75MXRjlVabAATXX1snNHaUEBUpcoNDOD8hFzrd
	hAS3q+Vh74lKIcKz0YxRZNE/HqiBgII=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iufhk8Rr;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772053280; a=rsa-sha256;
	cv=none;
	b=Gvu1iD4iSMkM0mx616uR/7DnmKfwsILAoNU4zjhvCgMJG9q2akXmtpi+9JFflTI9pxzJFY
	OKXzbIKDmYCYsgvScdj6DzH1bZOok3yRXfT/R/LIHTzGIZSwExYwaGQA5kqmaqjvJLA/Nl
	B+Q5tSj25ZI4e7shSEVmJAlnIsi3HQU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ljBa12aKJZbgxi3pinlImLFV5DTWyizlkuBiwkvq884=; b=iufhk8RraGjWl5ATUPxdQHz3P7
	bfpVX//Bc/64PlMyPfKEIybRPQoIaX9LvBnYup1AlK7F+8ZkGo1ytfp+scPv+mQNIDWMwRgX6/pIS
	y4QBWY5LMcNx2x6H7XZ1P7KoD/xpcoWZNbyhKB8fGq8pSVe+/p/zIDQsga2jed42FVi/bH5MOoqdi
	7ylooKTJOBCbe1PMlPVeItWo4eAjRyUAdJMWqR4y5B+e/OOLLmzuWSPhZ+JOG+9k5w/w/p3UwUCCE
	CuR6DybrVMPYEiVgs/2LZFO7XWx0qhbkO6lAlxSrM4IpYkpfXHoaVEELOCLXRZvUwWxx4oMpB5eMg
	2HEZD/jg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvM0U-00000001eGe-2y1H;
	Wed, 25 Feb 2026 21:01:18 +0000
Date: Wed, 25 Feb 2026 21:01:18 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 3/3] ptdesc: Account page tables to memcgs again
Message-ID: <aZ9jHvd-kpnQzMgC@casper.infradead.org>
References: <20260225162319.315281-1-willy@infradead.org>
 <20260225162319.315281-4-willy@infradead.org>
 <aZ8oT-n4a8VDY2AH@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ8oT-n4a8VDY2AH@linux.dev>
X-Stat-Signature: prxds1ewer1ah4jo4gnpypkd3tpcru1d
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: AC68340010
X-HE-Tag: 1772053280-784562
X-HE-Meta: U2FsdGVkX1+L1fGERV4OR6vzJoixJLBYLspySFwqQhxgw/gxJAXk4EtMKygUHKq0ehpzSeSQYHfNhfZ/gJ1T7/SyyPWJt5fC6Y4Gr4+/3YaDq8A5mhCN9ddTDf3JjiA5oLEonU9fNC0YLj81cK4OGS18tXRgaYS4wjHcUbv+PHCMv1h2u8aMS3AO70zgqZT7tMxjv4TTB1S1Uq0er+6zCSts0j6inSWPESg0VCRqgWpgXxC6NSGE8zO/oGDwTCYpDvurNinmI9Fsw74LHRj3Vpg+iJShg4pf1p4/CVtBOKEq90ue2HOLGhM7R+aZfPrwvyMLWiFFEsTDwVDqPD/9CJtxWtNBhQPKq+7pA77iOZZshSRHwfQFIR89brdAtz6itkDrpWTa6JbFO7AV/JD6rB2iz7zVU+8HuxC9eoEH4KFTiKNUlQej4aR+hoTGIR2w2LV66aRN1dK6ZGFKskOdZKmvWxexebvLJzsstG2+xnXsr/XbkNXQ4n6Fv/ckj0SPeWENV0b0d8C7uipD8fi27yZeuTuKbUZ88CxOBlB4g0i+4Sh5pbY13SE3rwwLCmOZGGDI/5CCgjw5RcwGB0Tj7wKP2tKd0OSAB7i9kIVDxoZEan3gldRp0WBDP6PbCXrdcfDJ5m4yIOp0l66XNobb5U2iIAFk4oJv7x8na/hflJXPw/aO+7GcI0NakkZQ4MKKd/tBiRj32+BEcDZbxHh/8OjWY5Y/0upxF3h23cU4N5eg73ugisLcGqkUElQyPiBjpZft19Gx85k7T3jdgLrBWYkLWR/Ob3ogYubyROTiLdUAi3cgJ3M0SRR4M+EtQ8SS1Tq+u+qgJYSkzeNkoJE+PKvGoyTy1tsdOnAFwfVN0TwgMXdCX9O0NzPnBrYYhIFXodT4QjO8ajvoQ5BWrL66TS+1dF8frqfvMEJpmoZVD07YoczOYj81n/nQTe9I3pVyuW5G5+7zTmaxPCBr+pj
 CxT7O4hW
 4Xh3W7KkzUXRmrjsnQFyVS+qU181DjnVsoXV8HikCd4r/n1fg/Rl3Xy6BIJw5BDJg55TCZI6i/wpMygxOgbZtYRmd865eS9Lh3hOJBZYbAT8sQQZzauR9E7+Guh7JKYHbZ2U/ofC4a4a5EP1VOEVuBG/nvkkGFRdoAVbZJ7o06UOCWwwucAY52NTrNVRLfq9aVOxWL5X6NmWC7EQcxIrTpHU+tzrObawsouCQO3JRAAS7curwLTMVrfq4PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:55:54AM -0800, Shakeel Butt wrote:
> >  #ifdef CONFIG_MEMCG
> > -	unsigned long pt_memcg_data;
> > +	struct mem_cgroup *pt_memcg;
> 
> This is kernel memory, so this would be struct obj_cgroup * instead of struct
> mem_cgroup pointer. We will need something similar to __folio_objcg(), maybe
> __ptdesc_objcg() and then call obj_cgroup_memcg() on it. Basically how
> folio_memcg() handles the kernel memory.

Why would we want to do that instead of just stashing a pointer to the
memcg in the ptdesc?  I feel very stupid about the differences between
all of these things and would dearly love to read some documentation to
learn.

