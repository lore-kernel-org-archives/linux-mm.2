Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F40FCCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 05:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1C78E00A8; Sat,  1 Nov 2025 01:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8298E0068; Sat,  1 Nov 2025 01:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6BD8E00A8; Sat,  1 Nov 2025 01:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A84698E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 01:01:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DEAF1406E8
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 05:01:14 +0000 (UTC)
X-FDA: 84060839268.17.0229E56
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6508C20008
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 05:01:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m8cBoJTe;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761973272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUfYsQtKHPf6wGb5urLnNs0QXXFwsJ1uqZTAIsOnWO8=;
	b=ECK+Ivs50RdlS89U5hmNuwWbme2n2zhOyKSRX+rHN6dQp7LO05ylBNXAs+Bx4vmE9xRvk1
	sHHjRU9TpbjA7q11JR98mflvJXONR+el22VZPCJfWJ3x5u0pznk7kztQakSvRDR9LBtstp
	8sB8RpS9nyFFhtgDmQFXTNlU5g83n78=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m8cBoJTe;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761973272; a=rsa-sha256;
	cv=none;
	b=D/jY7eLN2H7+C1t6dznpvIh64TCJ193dfCYQcv/5MqNUsenrlqlkKuqArz67RiinF9Ouve
	H8+Y5gjuVEX7NCgO8iX6eWaIitmy9NYT8e4H0iabz/mBKlwww9suBvbmReKFm73zITArrq
	67JgyWvEPtIeFjgwKQqGNtPpFxU+tDQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nUfYsQtKHPf6wGb5urLnNs0QXXFwsJ1uqZTAIsOnWO8=; b=m8cBoJTe+4lqxnFOY3CicYWrN9
	vVSfzrov1mXQcm/ejH+7snvW0fku6j+TSEDgJwiDbvk/BnnBQSZsiKKBCmg37krQiQeR+s0VwfA5K
	Hgb2urZ/RwlHXrFPYj+wGmHk0aTco+RQek0qer0J512Q9VkTZxrn56/xiC92KtH6U1NMvNNuLGc/8
	oUfXrHCVC2jjaTuwC47G3NDf7Tly13LH93JapnK3sbtB6XFfe0Gp0GQvvXHN+08/6IPxhXBB7b7+H
	FTjNGlQdcG5NuSfTy3cYcsYhNyZRXe+Ir078vlZrvPRsl1FGaknm4HGKCrGkIO0KaxG8AyLzTpgGE
	UQVLjJpA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vF3jL-00000001FAo-1qO9;
	Sat, 01 Nov 2025 05:00:47 +0000
Date: Sat, 1 Nov 2025 05:00:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <aQWT_6cXWAcjZYON@casper.infradead.org>
References: <20251027115636.82382-1-kirill@shutemov.name>
 <20251027115636.82382-2-kirill@shutemov.name>
 <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
 <hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
 <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
X-Rspamd-Queue-Id: 6508C20008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: m8r8gfkqk55nnwieyaasrtygw6yg7o7e
X-HE-Tag: 1761973271-736820
X-HE-Meta: U2FsdGVkX1+qXnPfsDwAG7exVy4mj4E7Ve7n49eCWL71xMqGzOAVBP98kV8ODISbz/bv1xf6RAuRGFcg52WKgsO1ulmXqlPGca04TK2lNr/VmtMzb+bG6q4Ndokou6s9kMCcdjMw1u9I5rzBCJ1Fh0vyPbO6eFZwiasGKzDNpqX4RCZnR75/bVD4EzgKDZh738kfV/tS0Ax7vYbpRU8OC5uLfHIQqThH/kuzSNRljZCx3kG2bYIM6mtFkPqq8FEr2/Wj4kc5ktkTG1R8JOTzLifu6ze4Kf3L00amBT6p6VPJvdWDY8ukFabiV3z9rupA58zdWnNP+XO4x4BYhHZ2/4XbkTDWlFs1H4nC07PRKbLq9bs/qgmor7RpByAFfQ+bJEjKVna/AIFCZub1NleOGIP789Z5T4r4rqNR3jnShEKPXvCmQpdKFvh/rwy6E4ktUaETnWq0FmmDn+FfOx+oF3i7Kk5DYpGhVkl07ufHCyuf0vgSls+8B8/Q8X9sylxHu0uRdaChLLe/qG44+fHQOZNWT+/JnSEiDFeX1gHtgX14gnsTuCVuC4yySOlDs6/Y7HhYmoFRu0C3FPXwYNWwxHRv9QUob36vfKRLeXduL6IVY+47A6kHz3V11KJuYmxEpDhpbsxXSHJManjqJNzmj5PF+pSmSDfv6tg5J/2Gqk0G3Zi32uc7nR0nUdudSVBOwa8fjJ+pzUyxF8J4dPP4fHO2qURMouQygBHM6e8dC51OmdNW2sg9Dc8dtWGaILTfzcO6QDBjcIA933g0Mje7qZQuh8OAVK/V3V+H6MXkjmWCOHxL0ww3v0889NsTXLkr7JIa5DOpx6js6AvkXWAh59oGyivYComHjJG4d7bPu0ykHqUefsxwGiaX4VVoCxBzspK5xtleMLqujs0uYIzWIX54WijZ434wDeute9xY40IVH7BWmorySesp/gdWzSOipBk0drO47GkQaZE1xUD
 TEWAt/dR
 w8SBCrkQkj2EZfCS2z7aolEvjgH8mgj92khmpyDPz21szIsiLzzHA29DRogtdaZflLj7xPApmX4rhSFRYqp+QhJmj6gMPZ5Hd45a7xScSt8MJN4EVAlif2Nl4BP4qfNMeRA0IUHQE01TWfbammNqVkXrki6mqmekITF3M/ISfI3Ou7CTtndIJuQTyarIS7HCmBE9hdShm5L3sPvy4M9f8+QxqbQ6IIE7JgSLjgy1F2HsBCz/yT53X1haFtQHsJehZhUHnjyUn8M6uolILhZDAaLIcPx0R/K7Ohc9/yBM2fGC2ek0X6lKJATe6YmYchBpGFB/7KXA4Y7mZZ38fIdQSjxfGaZ0YiFfz5lQM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 02:45:52AM -0700, Hugh Dickins wrote:
> But you're giving yourself too hard a time of backporting with your
> 5.10 Fixee 01c70267053d for 1/2: the only filesystem which set the
> flag then was tmpfs, which you're now excepting.  The flag got
> renamed later (in 5.16) and then in 5.17 at last there was another
> filesystem to set it.  So, this 1/2 would be
> 
> Fixes: 6795801366da ("xfs: Support large folios")

I haven't been able to keep up with this patchset -- sorry.

But this problem didn't exist until bs>PS support was added because we
would never add a folio to the page cache which extended beyond i_size
before.  We'd shrink the folio order allocated in do_page_cache_ra()
(actually, we still do, but page_cache_ra_unbounded() rounds it up
again).  So it doesn't fix that commit at all, but something far more
recent.

