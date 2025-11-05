Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21059CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 19:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B9E8E0006; Wed,  5 Nov 2025 14:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633518E0002; Wed,  5 Nov 2025 14:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5703F8E0006; Wed,  5 Nov 2025 14:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47A888E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:06:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E732F1A047B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:06:58 +0000 (UTC)
X-FDA: 84077485716.13.1D53FC7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 919E84000D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:06:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IBWlsteG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762369617; a=rsa-sha256;
	cv=none;
	b=Jy2pSGskEUxAxNcCCTIhYG0awOzJGJ0fzOV29EcGw9XB82lTXf32MdZsYL7blUzEiEKpFg
	bScKK1vh1sHDUUd5OFjo3GthUGIj6K0OupIrFZJQjT1oW6tMyJlfC1cM9N9XSXstq+dy1a
	Hkjdo/eF494By+XDLiqnBtQK1rVmnJ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IBWlsteG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762369617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNlLN91IPUmzKBqToljugUBHU3xTh3YeZQvGikTGxf8=;
	b=u6QnhaojQ+fELNcQYL4A/pA0ScK7lAT64vZt3Me3V+ZjETaT59f1R6hpiYj44LqMMOb7qn
	Ewr0RqogVZvEfEW+ZD2+YyfSiG/9a50qmxTIzDRqM8q+KGGH1MQcORhGB0Lwf0zMazO2Di
	jWPGOJzwR3OTUSkTrivwKE+xKJfBJ54=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uNlLN91IPUmzKBqToljugUBHU3xTh3YeZQvGikTGxf8=; b=IBWlsteGV5BqKNpBp269P8rt+Z
	0VKCpMHLJcEcVC5ca9y4mzUMBegTviTXPimmvvPBDSDtP77WZVHbwThO2KmT1T+XeAvGKLAHF0PRS
	80OeZej4TWRoq+EBL9TfPVoHaT5QOWeDqbMqMYIPbHtgQcNFN/L4z1JJbVyFD/pSjiTrFgovznnIc
	XkeQQXR5rl4/W2+7Z7UKzeQs8t3TjbaEvjtqAn49fXOGK2vvpbhXLkByLlSORalsuHmw82rYhXDs8
	Uheq42GmULctQ5UcWDeMNW3yFM55Ral+on9Ve62bU57pkBQ0EU+4PaIXi/iqPUMHvyrIi9YQne70n
	F2cEH7Kw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGipf-0000000EnwZ-1iQX;
	Wed, 05 Nov 2025 19:06:11 +0000
Date: Wed, 5 Nov 2025 19:06:11 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
Message-ID: <aQugI-F_Jig41FR9@casper.infradead.org>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 919E84000D
X-Stat-Signature: 83w6ynxin5mgey65ubbaacjc75bcdetm
X-HE-Tag: 1762369616-893764
X-HE-Meta: U2FsdGVkX19nSiG7ntu55zoCY5LXkk1WVT3jFJUEHYpdxqe9fIkvurPasLoEQXfEzR5lMVY5k/6bGO+9yYKHUu3I5Xfdc/tTAQ/ROhkf0ezHjbYAj046zmti+oemEFb8sWtz4Q5uXuPEE3k8NMgFO2VATBYz7trECLvhRdi1fxEUhOso4Ze88TwBZ8MeMhuSaisSFxp5LDf98tk443OhLbGoE+hFSOgDQt23HOv6JLfDof6BClyx3C1CdDhdRTx300gZq/ib260IEGptHeZSsFGHT3SVkw9w0hNU2Po27x1bfefTCZf2TUEPokfS6cGA9e2eRFQTFCOcwuQxIxPDPah4OJxJDHT5K0BR+mIzcXhuXeZXdVAu0YxpTBxy4NOTBztqFqLmc1upGiczQBOR6CPrkw/olRK7PgTdKgfpsNxnORgmZqvltCLFdgx9uFdkvm/KQvzSiDAjYvi6CNu5O12uxwazi9x60/c6FK5HUkQVRE5jicjBP013DOWzYk83CYPXpZSLeQxEsEj5jbz6yfQPep2/cnHM+QU6Fb5VRj02CzDTUp0+lf3u05xeK3kDL7aGjpKqSl+zy09zUqFO8ZhuIQUQnInn/F07xga1wPQ8zUCDbYXFprDf7Q0HnDJGqfC6dz9aDbkfwn5KJLA3FFOdxlcbMFnm7U7u+djfHXYKGUXeBULZPdpLwlYTgcWpkmMf50jlaqEdCzmEP43+dz8FG9QVcJkUqKh4oWL+u+csxM1Iu6PBSwv7iDGYYkRhV5+Ycv3ve+8vtmcStm90u4fi5IxmYX18/TjnyPQb8qhBPC7VAGJP/fmotimXYBM9bU9g0eK2NVy+HEJ0NKLxT7qPN2tDvfRyX9li4ge+LLicVxXppqrsbC3TqO7lN0qdTypQ5OCLZkh2A7Juwj++hHz54wPGzQmrbQN+TzqfCpYTC58YdOouIzX1txIMBD3xrSUF1zdKOL9WskIVGK0
 621zOcK2
 6hBLFXUV0Zz2h/gGd+RIrN4JBMlCh7Bvji4o/Hp5/X3nkDZhOTQ36mQpQKx2YOp4MsfX78SJdTnXgDoxAEK44ccPIFirsvN+HQZ63dpSFwJaohZs89WvYmRjN1serS+NLpudkqVBwsTcy3q0jGM4mwI8iQo5GvGJsGr3mP89MTNyDDgWULv8Onaan9WRBW6dOD7dYmCuWHhn6FzhcRFv2kjU40Phpb/YNwcflksCfa1h1X+OGZgo87Wfth8kF6X3h13O5KkJU3QjZiFzu+nc+7jvG+2dUeg2wesMscuSwp6dSmawkrmR4sG9/Q0x3jR9EUMou
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
> The kernel maintains leaf page table entries which contain either:
> 
> - Nothing ('none' entries)
> - Present entries (that is stuff the hardware can navigate without fault)
> - Everything else that will cause a fault which the kernel handles

The problem is that we're already using 'pmd leaf entries' to mean "this
is a pointer to a PMD entry rather than a table of PTEs".  So I think
we need a new name.  A boring name would be 'swent' (software entry).
An acronym would be SWE.  In the XArray I distinguish between pointer
entries and value entries -- would calling them value entries work here?
Or we could call them something entirely different.  Say 'twig'.  Or
'cask'.


