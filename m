Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99EB8CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE2F8E0002; Tue, 16 Sep 2025 08:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5ED18E0001; Tue, 16 Sep 2025 08:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974738E0002; Tue, 16 Sep 2025 08:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 859F28E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:07:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47D1E14016C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:07:37 +0000 (UTC)
X-FDA: 83894988954.19.9766BD4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 45933140007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:07:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="uRd6Y/mK"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758024455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GM7+wkMx+bII2CbdBQ/esqPJ/DUnTMg1OYFS2n5wbU=;
	b=vA+uMv8VdiFOZM/csmYuU7gb1tBW8pJiN+mAlOf4C4os1hrAug9bZQMis2cgRf7TDo4QxJ
	668GlzVHCTZRfaKdT5VVz7zOhfcfhbzlGNlion8FwwFJGtSwlZp7778+q2TbL8WCRx3MQh
	UscTPCXXXW2+aakh7gxe/fxy9wYj2L0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="uRd6Y/mK";
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758024455; a=rsa-sha256;
	cv=none;
	b=P49WI5BlOAwSXLNZE5+IZSfpDZzJCzP+xUZ6NIr5CELkRZVUjlSys1s5FiCud7ZESAbZGk
	AepLcB3YkAlGh81zw+TWYr2uq+rOxpVwcjfcXU1RYjhofzV0gkiq9hHtjGKBu2XFHMQBFm
	JT7sFp2F+GmC/kvIL/n6gXe1HhR1/Mw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1GM7+wkMx+bII2CbdBQ/esqPJ/DUnTMg1OYFS2n5wbU=; b=uRd6Y/mKIzR5xhWcpmTmtLLSBK
	plznkN5eTPnemH2BHnAxlpx+cBHnf4Zk9dcezBkU5VeWht8LPc6Pxke4iGWaTtO1QoOPXG5rq42h2
	FoG0QPRXu8aONj/akzbqnS2eeiHWIxDSfwIMFYGoB9VC4O7jzkcDd3em66niWe75IBXIYIWq1/Keu
	pEoLBiTA3r7pWwL18eCyMy9b/yF1+wpKFCYl9IdAWpKMli0KFu+9gcac6ICeol+sdyfBTvHzJsJxg
	mY9MFDL3Npw88FmEDIaFakjE2SUG2nl+LyWYcFSkhwkf7isCMM6cIz2MzbFBK36qT+3h3bWNVYatx
	bGhnqy2Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyUSr-00000003qKH-0jhR;
	Tue, 16 Sep 2025 12:07:17 +0000
Date: Tue, 16 Sep 2025 13:07:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: Amit Shah <amit@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>,
	Christoph Lameter <cl@linux.com>,
	Dave Hansen <dave.hansen@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kirill Shutemov <k.shutemov@gmail.com>,
	Mel Gorman <mel.gorman@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <mike.rapoport@gmail.com>,
	Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shivank Garg <shivankg@amd.com>,
	Sterling Alexander <stalexan@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, rdunlap@infradead.org,
	David Rientjes <rientjes@google.com>
Subject: Re: [Invitation] Linux MM Alignment Session on kmemdump on Wednesday
Message-ID: <aMlS9Kb6_x3fqsLG@casper.infradead.org>
References: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
 <aMhgoUvziLPNt_vI@casper.infradead.org>
 <cfac2d98-2214-4bd3-a4cb-9b319acb462f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfac2d98-2214-4bd3-a4cb-9b319acb462f@linaro.org>
X-Rspamd-Queue-Id: 45933140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gneqstp8ykbnng17erah86zyxpt4krnn
X-HE-Tag: 1758024454-949288
X-HE-Meta: U2FsdGVkX1/rLsdqy++k6IJdo0U988RKvtehOSMB4daEjVHhv63JZ/Wlq2f0hBS3bNh+8bDGSTmzYpKnTU4Pv62v8bSW+7fcDFEWj68Clf9YFJmCIqLkJ1lNR5eVFQ+/eWVsY06uriA8az9PmJjnfcRIOSrvpYFhzgizqRVv17LCH4syfGnQAVat75e7S8tnrvztr1rS9RK4ItaflEnGyXtii+n3GHB93CAXgRo7xkla7zx7ZHlwKKYZ02pdvNc4Jotm+qXJV/VlJpP6cj/KB+wBD2v3QaoFl5tkHlSt9zUmBVNjfpsxXf8hAyWTGXNXfXEv8MiDcewTUsq41Ru2XBGcEIQcW6pBJC+kw9BSGfbelOwdlw6dYpsov/yq1kQ/3wp068rIjm681RzTj+8OlV2VJoZoTeqsObosrbXATYvXlmIQ28wjIkkGXoUh2QzzVOZnFhe+v6mXmaKOEIuVDFFP9Lvx7jX383R52ESrpXcp9eNi7gw9iWihSY81DjK1MdGdN6VSkHmdrL1697hThwITAQ+mz5gd6ze3DvYPyU4JbmpLLaWr1dq64cfw4ggmBbJYrC90fVRb4D/Y4J4sAoVnJG+orRsJvFT+SdmDtT0gXwBBKyLgeEB05o46BpknuTfWGlRlohZn2eMQx9u8Olz+EA42bd+bzCSnfi17Fzq2gK6zrfPfQHrngU7zj8JHP9/w6aJb7tMP06pGMdOR2HVLBJaHA1icMO/M0Wl3kvkHgo7AWEmnnJEXzC1ScxmQ+C3urZzrNyZ0kZ5v4kOi2u+or9Q6pZT2xazsbV8C6fGX3jT4q+gVtrtBetDEDkncDmL9c8HER3GsEnjpkFsszhjTi7BAW0yNDHzmDguM9OVh7NuswVntBfI+RN/+rcubSXiZH9fI3zSaa7+WaHTXSjHlYWIoJoJYo5OfvoiP1ABkQiZzbfkMGYX4mrD8EsKWQs8NYl69IHXznNyc9ZT
 Tt8xJLH4
 PbFB8XPuNpGYZksFIRMQaw+zk0VyCwpM42uVUc8yo+f6Mtv+7OlGiiRNOKp7SLn/HjUfo0rSlqXFLJ1o3sbMTMMtrbCEVpQ3f5k/l4OTvbPjbHdeY3X6srDq2CGr4Sre8Q8toOaDdfNHvb77KYnIP1DA38g3fo1Gg+CB3cp4MBW/kOUj9/f/ByGolXa4KaCpC/lliB3fsgG8Sjt7h8MCaPtrqg8kt0xbPUjuXtUc5fcP3RrnxJrOVFk/za6uUfPOAJrgoFoQGDHHNraLP4a2+siEDVeeoYQpXXm0/3hFz/cllJCe14XfXBFWYCy4lbD4VrfNCnmOxmjbzWMrR2RuiUND9y8SjMQMZfehOFXL8qEepVJJQAIiICCwbeedtMci7Emut6cUAGaQZQopN26/462ffpfhuqxUpDAvMFlzwhptHrfdXtKCSEFBz2ttO6lqD8QuA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:49:35AM +0300, Eugen Hristev wrote:
> On 9/15/25 21:53, Matthew Wilcox wrote:
> > On Mon, Sep 15, 2025 at 08:58:35AM -0700, David Rientjes wrote:
> >> This week's topic will be kmemdump led by Eugen Hristev.  See the latest
> >> proposal at https://lwn.net/Articles/1031319/.
> > 
> > I don't understand what this has to do with mm, to be honest.
> > It looks like a debugging aid.
> 
> It was suggested to move it to mm/ :
> 
> https://lore.kernel.org/all/0fa9e4e7-1247-4c82-8c0b-fa65b7fbb56d@infradead.org/

I feel like you should be able to explain this rather better than
"somebody else told me to move it".  As of this moment, I still don't
know what kmemdump even is.

> > 
> > https://lore.kernel.org/lkml/20250422113156.575971-2-eugen.hristev@linaro.org/
> > 
> > is a great example of how to write a lot of documentation that doesn't
> > actually tell the reader what anything is.
> > 
> > 
> 
> Here is a link to the v3 where I changed it a little bit :
> 
> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
> 
> I am eager to improve the documentation to make more sense out of it, I
> am happy with suggestions.

Start by telling me what it is.

