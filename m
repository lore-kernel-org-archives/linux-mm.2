Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E42EE20AA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 14:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C914B6B00A0; Fri,  6 Feb 2026 09:43:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F676B00A1; Fri,  6 Feb 2026 09:43:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20E86B00A2; Fri,  6 Feb 2026 09:43:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9D96B00A0
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:43:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67A7D1401D7
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:43:23 +0000 (UTC)
X-FDA: 84414299886.29.3290F0C
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B3CB40006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:43:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="X tiBlua";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=oZzBaS7b;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770389001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bISqe2jKaP7KU/kCc6RBfI2gJ1MsWdykdn0nnq1JXjY=;
	b=CO39Co+stNI9jG4PNzeT7Qm2KpedlDizwY2hgB5ltWY4+u46OKIJVl+kfLEBVakQoOznUI
	AVhtqblIofYLW34Ul7DerlZ/e4v6Bl+JiaLnkw/1m1ZTZzSifo3G4x2yz+q5x2UdmIfXh1
	TbqL2eTuVH3wSLRQ0rHMMNH5n7A1UNQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="X tiBlua";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=oZzBaS7b;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770389001; a=rsa-sha256;
	cv=none;
	b=gplcZS56KCWabzcMt7xWYBMJJGUHB85t1G7qLsrNhObyikH+CIJ5lTBJeQBt9rTU1pDaBk
	zXPkvNeTSXFlRbOsM9IchuakJw2J2hSZsTNlIL1PQCR8mafW7xY5g+HEv/4NNtIw4cyP+g
	XSYzdC7+L/uuL7Lk9v7tCShz8UBsoqk=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.phl.internal (Postfix) with ESMTP id 6823B13807A9;
	Fri,  6 Feb 2026 09:43:20 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Fri, 06 Feb 2026 09:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1770389000; x=
	1770396200; bh=bISqe2jKaP7KU/kCc6RBfI2gJ1MsWdykdn0nnq1JXjY=; b=X
	tiBlua1qOJ9+VfxMxANao61ok4w8oV+yhjndZQeJrIoI7jLFUmtpJy72n5r9AFuc
	syrd/70MYg43gJwvQDdV2vwzKY6lHRKems9lAod4sPbIsKTYkRxTXfbsxlXXATuO
	CSm04KLxBIjEHTSMH3u7yTFS7KmtNQun9qBhXrKe7Ane4HiGvv/hRCDsVm1Jt+RR
	QzjzD6njf62j27kSAffrlPH5L+06RMLxN7E5KXyueC1Q+GxVvhfiKj0rolh+iwq9
	TwmgtRPPq0fYjYe2G3cdDeuTjbuVDKIrhWG/gvcS4KR18feTxZ9G0xme4BZoib8e
	VPsKgffMFuvZCZ6A9yVxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1770389000; x=1770396200; bh=bISqe2jKaP7KU/kCc6RBfI2gJ1MsWdykdn0
	nnq1JXjY=; b=oZzBaS7b2xOAudK+026QQZU1KNJUrj1T9AgoESSr1rZ6DnbpzHj
	vtGX2GtZr+dtd+mcQWnCEQ1XVqJJeVuJNT1Q+KJKkGzb3RAXby9SSkHWkbiV7EUh
	utSFcVXxKmWoDHyTvlGVhm799og8qG1jcIctlLpQFSejTQ2pL2r7ig2/ewzabnlQ
	+lStSi/SkaudFpYVBTYN3NIZdMG4x9lyb6Syxst59Wpq/KQRTiFza8PEmRubsg1w
	V7m3F/ub5p7yi4ldLfQuJJXGzd1sJX/rGje3g5vNOsPRWDC+Z6ojPzRj6spUoNxE
	1+fn/7u2JO6kthLhOLBxhpzSY++XpG4DUVg==
X-ME-Sender: <xms:Bv6FaS168pLUBnVOew4KMOcno3dBuLgsv-8v16QqiTR-64YS1dn9Fg>
    <xme:Bv6FaQPc8VYs5_WXb052nTgTSxfWH9pjC_UPYh-7srpSPzHWe-ZXSIDy7N4gSpyzD
    eWZ2GS7pRXgo59DdN6IafYuUMr9MrB-Bfnu7uha6c4JcQzbnw1y5tA>
X-ME-Received: <xmr:Bv6FaRQGF1AajFYr3mTMAYd0BFNd9pdsRpPsTr0qkYluel7d6hp12ezG8COUTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeekgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepghhlrgguhihshhgvvhdrihhlhi
    grudeshhdqphgrrhhtnhgvrhhsrdgtohhmpdhrtghpthhtohepghhorhgsuhhnohhvrdhi
    vhgrnheshhdqphgrrhhtnhgvrhhsrdgtohhmpdhrtghpthhtoheprghrthgvmhdrkhhuii
    hinheshhhurgifvghirdgtohhmpdhrtghpthhtohepshhtvghprghnohhvrdgrnhgrthho
    lhihsehhuhgrfigvihdrtghomhdprhgtphhtthhopegrlhgvgigrnhguvghrrdhgrhhusg
    hnihhkohhvsehhuhgrfigvihdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrd
    horhhgpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgt
    ohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:Bv6Faex-Rv6_rF5KeJth-0QAZXxJvR5CHBJGZpW-I6rprmNd1TUllg>
    <xmx:Bv6FaXdHTBdwnElAfv5z_dK9bacbzifxrjCS49X4NMxikUaKAjnXcQ>
    <xmx:Bv6FaY6lZhyICBlNbKZYjsHgAWVyieXdaaN9t5IAM3t4gJq8wUJyGQ>
    <xmx:Bv6FaUKvlc2_aSGCG4-ShlozphCy79up-w3iUMUaW8cZBbsUuzORNw>
    <xmx:CP6FaTMRSuu63dnxcyDgxivuOgK5w7Hw0BC6SyCm5SqDuwHBYJ4aP4hH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Feb 2026 09:43:15 -0500 (EST)
Date: Fri, 6 Feb 2026 14:43:10 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: gorbunov.ivan@h-partners.com, artem.kuzin@huawei.com, 
	stepanov.anatoly@huawei.com, alexander.grubnikov@huawei.com, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Will Deacon <will@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: make ref_unless functions unless_zero only
Message-ID: <aYX96BcEn0EPiUlH@thinkstation>
References: <20260206133328.426921-1-gladyshev.ilya1@h-partners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206133328.426921-1-gladyshev.ilya1@h-partners.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B3CB40006
X-Stat-Signature: 1671y67jmhwkbrmjs1ud4w7wb5um4hyg
X-Rspam-User: 
X-HE-Tag: 1770389001-678659
X-HE-Meta: U2FsdGVkX18j0NBjWMDCrr2BJIsLlHG2GBfOtVWOxXrGArG9Fo6hd3GRHA/TD3asjpXQ3TvOlJSuynvZ0ww2uSQMsgLutVtD979M5T++Od1UEiU3au3cJBhE0BfEOu9f4wocamB/daNK+yfjG4iZYBrDOwuS/Me6oK9bsSKWqHyEmtwA8AVBFl+g2n+S6u31k/ilZH5YWaJn5EyobAxx20ou3cL5vwZIEoMGH6dcqjBM1HfGOkWw089Xgsb2YyQJmr6WRND0vWeWykzW4Hb63pgf8zKhl2I+fC3gfvKo+vMwYm5HKj7iDfavpyWzW25Uyes+3WiIN2zt5MVwc7h4Wdd2/QFh+EWu8yw9pXUauxI58sCPp9Y/WsfgpLS9sz70NDgWhZNkRAACVmAQaA9cElQF4+wE8S6G7yR9dQGORwEJIKf+u/drjPHNi1bqW/0S3jcIXwol7fl4+vKf6YOqgt+UL3Qy5o2fCqi5nCF6hoYZ87RtChU2OUyCMENU5PqM+al9ndhGuPtc75bJUDZa+xX4Sn23X2ngeHgTi/axZDnYPW+dDtkkSyRkLYT0DlpKt0x66ix262ywGhR/WLaVYv8M7UkbY/uPkm1q7/3KBWMr8XP4WydY9aJXX7xhijysHmY0oYEBiqM2xuxI1dlEU6AObNCNJldV8guN3997BKhFIKoAfyy0mPu6nuN24gEeV+Vi15kNsAJLZSRqwBum1MsQxe7PG2Tceu/0La7rH5XIj1NHFi5dJ6iKzWWdfZZmwqt755PnCpFbVhnE/e4i5ItCQjhAL6VNKbX6U6UQ4WuK4bbtB7W+ywxMo9+vEo48CGnz4uJfVELD+QUYaoooDp0QZMvHBXn7Pn6DgVGGzQdyCSiobxBhQ5HpuTu7Vflcduuf7q6OqFgWsyrhHiOKaHl9Yel3zhwtLFuyRyoFFfn5HO0qJVOawb8Q94tEC2NZ3nZzcT5CmZidbpROLxy
 3YQz89XL
 lmHo58E2f0K2856rTDOMAji52yeVI5iOngcIxS21mqY1rEkuNQGC+/KarnIaFkejOVnLnpkOCyPhIriHJCAe+dYF9cZeBSQq40ZGYcACrc6YXmwdlbWeMExeuV9COOepcKw82wUkA5NtsDpCD33VG3N7Ugk4Hb6zjSHGV40m4dZNF4HGSayVDBmKZU+k8GqkUqqqEOTqPcd3rqCxYpyngKfIiqiW/+6wHG96G5AOMmLCcCkLA1Bsr7f29cPfPEDqBdioPxFHNVkvQnFQDICNqkn7v1UQBYDIJ2pyVahqH70EGq1DTCUQQtNyNIDFe+ein0quZZJbRQd+11uCS5hjSiw1MQVwDNMhkAVIWoFgSJVMQryR6lHwJH/NQv2JH40McaQi8zzpKDStChEev3e7GXych5dqpCQq6nBtBUqCxxxMZI+NOqRynU+ZqVBrq9wOIcWlAaEAx1myzwWz0iyrfEZrqZGQypQDMSZRvGWuOY6htirgWusxqDIAMCgyyJJgNI1Uy6jXJrweiJdga5Xo1c4lehTRwZCNS1xIgxv6Woew6BTgBZE0f1tjq/cx6jDRbJkMR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 01:33:02PM +0000, Gladyshev Ilya wrote:
> There are no users of (folio/page)_ref_add_unless(page, nr, u) with
> u != 0 [1] and all current users are "internal" for page refcounting API.
> This allows us to safely drop this parameter and reduce function
> semantics to the "unless zero" cases only, which will be optimized in
> the following patch.
> 
> If needed, these functions for the u!=0 cases can be trivially
> reintroduced later using the same atomic_add_unless operations as before.
> 
> [1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f
> ("mm: remove the extra ZONE_DEVICE struct page refcount"). There is no
> trace of discussion as to why this cleanup wasn't done earlier.
> 
> Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

