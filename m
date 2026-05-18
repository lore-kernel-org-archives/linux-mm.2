Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E67CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1D06B0088; Mon, 18 May 2026 14:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA62E6B008C; Mon, 18 May 2026 14:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBD36B0092; Mon, 18 May 2026 14:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8426B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:15:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3493240A8B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:15:50 +0000 (UTC)
X-FDA: 84781344060.13.2F11EC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 74D9740008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:15:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HHdUXecE;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779128148; a=rsa-sha256;
	cv=none;
	b=rDFZAnEsQs8wY6ws+eqOYeDwr84H3mUr4hzmXNgNFcACUssRivyhmJ5eWqIZDhaQ5Z2vKp
	jGlZ0NRieLkzwbV0rUYUQLUqf4GkQNyotPYg0gd5jd/Ke22EyD9zYjFD8g/bpzSwHZrxfB
	iT57rz7w1BHXobZ9qIp0sCubOeLhU20=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HHdUXecE;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmGbq/RIiMF1ju3NZmsmvdzHha3Ji4y7+wfeP+3PoFg=;
	b=nnSojDNBpteFaAeq7sGD9KlgrmJqVimSmpYaoWL8xablUwZhtYvJMZjAJ/Rz8BLSv1zAcL
	3jyRdpfXZv0AEJHNnSZzpICsECT7eW0YsH3RCxwUbXoPuvDykaQWWhqNxPH3C36iynbXcy
	hWwTlHsmM/hUyFDo2cDw4gODJs3Kzn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 64F23429D7;
	Mon, 18 May 2026 18:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9DBC2BCB7;
	Mon, 18 May 2026 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779128147;
	bh=ru4p7XQSqRvvGJrY0kKH+1TvzjzUr/MW6q3YX4REiMk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HHdUXecEEoIvxx+Pmc+9DuKO0vZwFqzLVCkEP2vHBoMzZk0YFoxQFpR1N4Yy8/Q6H
	 z8TCWSU9YuEqc7G85toV30dn2H3CiyKUVZtjDf3WFRdUZahWXiW/3gFJpSRemLPcDT
	 PBXm+I39YQjUd69a6NbP+a6qCP7kU9825GJQ0ky4=
Date: Mon, 18 May 2026 11:15:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/4] mm: misc cleanups from __GFP_UNMAPPED series
Message-Id: <20260518111546.3baebae99dc3f2a4fd65e605@linux-foundation.org>
In-Reply-To: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hmzbgxmo791kkkddtt75au4458c5yoba
X-Rspam-User: 
X-Rspamd-Queue-Id: 74D9740008
X-Rspamd-Server: rspam07
X-HE-Tag: 1779128148-732407
X-HE-Meta: U2FsdGVkX1+QjANgoZa/FpKyE8sXqeP5/9pyHrIhjHvTtm4buEmD9DpNM+9g+I+pME05yicKVN9Nmeuq92eDNB/zhOqvNklBAjRmXDdTlWFMDBFWrmqHn4u14x5sCYQEbZJV7MyHJjLJ8xNlLkWFN5lo6KraUWM0AKZgERS8B9PFdooVnjDWTELpiXNRIumLPz9383qxkRGBVh4QyGoviGp9WZ0m5TWLrousTejmObEIP4rr8DGwPvYyICmvDdTocPe3PTwe5sVcplNi37KOEnT3sLKqpZxP385mqrp+qMayb48NdgsyIllLUCCiG09t6WMc90puHdCcl/YjPWy0PiAsmC+7dZmyaPaP5jOiyT4WnpZUz+fqftOZmatt8FoYu5WYwul3M5DEfyueDifK3+zyA4JrvFWkX0oMbyNQwxdCdRlD4rOhLCrf0tXuxLybmB1QCu6sen3YjH6BDYBqICa3SBk4smPkt5Lcma9ag0EFcse888ChHqyuIWHSW6FGXHw+dfYjSogurL+jOtfPw8KDQjfg8mhnA7QB2YNwKkcaAc3C3U7dXJdbEttUZ6OB1wV9UHs+YWaoJuKx2uJL5cFJcVs05cwHely/49T6Bqqy5ZwmpAvBcJ612EY+Lo8LFrjyyJQM9lKQRIZxWQWZn/SXJuhCgyvLGk+omHvZ1J6SpDJ82FOpdkUyPyYLssIrd2hlOh8JEb6SGltnE+zOTgb6W+kvqFr/3O5Kvq3NcAHG/bXd/IOW/sPMpILDUtlE3Xq1hV55qyu87Aa3eY3E1VnfR7PlyFh5J6NFKgTxscXMJTNrWRrwjOt4Yg3CZSNkuhlZBL6cJnfqFcGbnESedJ6rXhDwKgaaDeTpUwL2rwAf18AAOYinnJnDoQAu3iSMxrpXeqQtRnHt9MJH4IO2HF/DtIdImyYVn4WPTYMTdjjNnC+gOeN3uAcVvtOT/xNBlC432G0cw3Sw8xv3OF+
 Za9cBBHd
 oA9vrvnBNecPXJNnmrKkue5JSNTtCq9hh9eBeU56ZNuvCw5RMCeAeWWUGcW1TrMpIdK28L0qw9kMVxarKMCScPjeBRVO/lXNSNBxAS7dqhfWyZ9BM99S0DR2u0nB7iWeAxKJ+ibGz7DdCXKaN7fJeOd2QD0SQFKLS+yn4JgD34l5e4B44c/rg0qzS8iZvXrYe59qZNmYS63+8rYly9njlk59OfhQBWmyUxvB0q7mCX+3Z6Zw/OcnBvF/2jIQjgSx03ZkkSpfZDDWh7OChkBnoBTCaLZoTRZQQnaWnIt1UHZIYYZp+3UK5zjhfmUX8KlSEBNXU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 12:35:12 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> In v2 of the __GFP_UNMAPPED series [0], we realised that some of the patches
> could potentially be merged as independent cleanups.
> 
> These are all independent of one another, if you think some are useful
> cleanups and others are pointless churn, it should be fine to just pick
> whatever subset you prefer.
> 
> No functional change intended.

Thanks, Brendan.  I added this to mm.git's mm-new branch for testing,
along with a note that [4/4] may be getting an update arising from
Vlastimil's feedback.


