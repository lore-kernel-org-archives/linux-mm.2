Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6EBFC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 18:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03FC6B008A; Fri, 24 Jul 2026 14:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4336B008C; Fri, 24 Jul 2026 14:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E8C6B0092; Fri, 24 Jul 2026 14:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7E76B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:05:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E031A007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:05:01 +0000 (UTC)
X-FDA: 85024446402.04.FCC5FE8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE64E160004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:04:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PVgKgyGZ;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784916299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBK/aUXq2BzjcKKQY4Ho923DaPXp4qxTWkADm4EVxbQ=;
	b=kaNJ53KpYB8HLHlUACdYkd3IO+gD98YfPRzx7DiTK4Ua2WW3C535PTe1ILyd0vYJ0auGOo
	5s8WcHmsQI7bUKbI2q1k+n57kF9Z85P/JXOJZQXGXlI+8agHA8u9+gkHrqAwWaqKAGTaoX
	XHzuqgPifMaESts1lJRbmNjII3DvDrI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PVgKgyGZ;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784916299;
	b=m42vltfBBDph9PG0FeZ+sL4NMFu1ofFaA2+m0PyZLcdb7vUd3gn0hopdPt780HRo1ZrZ4M
	ldRaaLXQRKBpE+G2jzL8KASa9b9Hx5pjBe+2IL7zoJE/rK0wW9c306QQBXZoGp08foLxYT
	fcdkPJlzHo9XneD7jkdmDx3x10zR0S4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MBK/aUXq2BzjcKKQY4Ho923DaPXp4qxTWkADm4EVxbQ=; b=PVgKgyGZTx58jiWkMjbJ8OYrAX
	EZhBGzYit/hlONjBPpLfGVfKBkRmMPJT68RznWoopXvybLWGkdpFpPiOl5hr97hmgbV4/IZrJqMDi
	bvSOhh56AipUZL5vMVE6cAEsuH1m5AnhWgtUKghBJvfvU+YtyCi9T17/94YQJzUaJnHSzT3GPex2p
	9/JtOKbbPf07q1I52X1CEs0Ctxp/4AJdNlt64KqhaUJj3xhzG1ML0cczNiSmd/q1dyCfCuAz2OBvH
	FHZZf+xq1RDlm2WJLQxOwpSzIz4aT+mMsh0F+b7qoqtcwwHjZGla6/DqOjHAVF/rxDc9fmcvxXRfu
	3iG4ht3A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnKGT-000000043U5-0DxV;
	Fri, 24 Jul 2026 18:04:53 +0000
Date: Fri, 24 Jul 2026 19:04:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Michael Roth <michael.roth@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
Message-ID: <amOpRMpkyFGm0j9c@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-6-willy@infradead.org>
 <amNeKcDZ66VrQ5PL@casper.infradead.org>
 <amOByZH4oWzmO3Zj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amOByZH4oWzmO3Zj@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE64E160004
X-Stat-Signature: 555ssdx5n3xmbybo5tk7u94ua1yzzkwc
X-HE-Tag: 1784916298-941031
X-HE-Meta: U2FsdGVkX18YF3Ja8V7nQP0nFcI2EOsX/GqXQXbEE7vg82qVqSh6YHLnkg3/TM+1JRC6kw2jsUVIqHrsvhc98AKC3OpqoHeYDsCzlhXuBEnSkAdhNILyq0eVTVKBYYTFtDDHWe2AHOj22rlyCeBezccD+FWg6iQO1FIK/O9dg5R2Ee7FIoGKsW3Ur7wMhIebr25h8OKfVrdzydBwQXYm4pqRDTK52tduglrr6ay2O5VuQ5AJPnGUz8mGsJTONnDCkR61munPg7/CqnPPnX4/xPnPXUtdj0u421xt2F73RsOrFdOWE8FMPt93YrJL7w2P9khYWyvhrYRZ6v5OhEkMuOYfGxKCrzo+Hq6pQjV+YtaodI6piGK8E4A+TeWBz7Qn/eZNQvEuUdGcLAnK6dXPahnpccBJo2vMB02WL6iDKIFs/35EM9P4d7gWZtsnfNC8F08ZqPAr2e95RfYJACeOIPsiZ3q7+UI0pU38NZOqColgBbifvM+joZDPKvpA55OYZ8vZCprnGKHseZCbjyvjfG28sGxEdLzINvVO8+XsjMdM8s5pJeOimHAqWdsukr+DyIiaU7yxpWWzvNYUd6Y2MlF91Rr/uM1VYAFDTe7sxMPViY2nwSFwFQ1YgddoDjQGuY33w9EtNFspn55jnLyLiTq+LoBf0yJB/2z0QMVOOXVEOqfKJ6ct/41qZ4bue7vCszsg1hds2Hr7s930tfe1faVkSmtomgzEgtpTBpMRaU/0+0o7CiiIyYB+cMd1dGJ/SG/0vY/peyU1vlSipWNcVXq3qh0mULQYmjgJ9gGPfqKHUpWRPdR51mjTN5xj7H9UA+n8YZPL9XgMHlZ+ySxbomEDGOi3TD3GjeTRHJJYFkPQpBYu1aijd3P5ITfhsArnxh4Ppro3K0WSfRjkUPdEoy+2khT9+Tr75wxkvpXCS7B6qLcGQc9ikqElUBe/AKEm/JRBr2Vep3KbWpqBtNu
 K/IAUr+p
 2eLU/lXzZT67jYZR0FNzDtENJJhC2huhliLjQPim/Ou1BhdBxlCYfr0F28P7yc8b+ujXMsLHje1ksww/jAsdybKQV6BWvHFxKfyLpoC0vf7b1NYKjsiAKA6Mhcbtp9Nk5ljholanxXtN5lMZx/IsKD+k+3i+27ee1LXPvpZndjVX+xKMr2EJQGURNFDYzDR9TEbiZRyEEtM2B5eGXC0nF/WuikAGL7DL0+5Z+Zdncw8izhiFcn8qLUvt89QzuH5mMGf4MjI8P5YQxTS4LsCPjEjLkw4fh4kgK35l5F/IRNQYzsg45BiKAHAzDH5OEUeY4lyfR+xhcpfQmn+qNFsnvyKaCyYJsP0Imut0lXNWVYx4pgKrRllV4aRixkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 08:16:25AM -0700, Sean Christopherson wrote:
> Heh, you don't want to sign up for a week or two of onion peeling?

Oh, you have no idea!

Here's my onion so far ...

1. I want to simplify filemap_fault()
2. That requires changing all the architecture fault handlers
3. So let's push some of that down to the MM with a new wrapper around
   handle_mm_fault()
4. This would be easier if we could hoist the creation of struct
   vm_fault from __handle_mm_fault() to handle_mm_fault()
5. Which would be possible if Jane's series to fix hugetlb use of pgoff
   had landed
6. Oh, hang on, handling hwpoison on hugetlb is actually broken in a
   few different ways (some pointed out by Sashiko, some I noticed
   myself)

I honestly thought I was just going to rearrange Jane's patch series
a bit and resubmit it, but fixing the hugetlb hwpoison handling has
consumed me for the past couple of weeks.

