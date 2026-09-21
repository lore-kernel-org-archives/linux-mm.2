Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCCDFC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED406B00DF; Mon, 21 Sep 2026 02:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DF96B00E1; Mon, 21 Sep 2026 02:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBA56B00E2; Mon, 21 Sep 2026 02:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA4B6B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:57:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F077C1C2E40
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:56:59 +0000 (UTC)
X-FDA: 85236862158.23.EC6A285
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id 289EF180007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:56:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789973818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=LbWTqIjZkfOm23dkF4p4jFrk4QREeYyMKgsyElPwUL1OfE75TCIHXhdrafowf6PhxJ5EGN
	FJC4b7MGNZVMCGI1JrXZwhpeW3R+NBv4TcA3KuRxLI9eiEWEaXubdRSPMioR79pdkT+mwn
	j/TRztOq73TkZJl4zD4qwDsMBrbDa98=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789973818;
	b=h35vLJaQ5l9uB4ATGfwIOv817yn4soYAyENxSRs2Z+V56bCp2E0oXgJb7FzUwErrVThC64
	mfUYH+VegMVwApLNjP7WCJBz9he5vVGfwaKj3pL0BOTF5gJCRkqOx0cP02844UYutZ+3kI
	H9TmvsUWV9joeobQlwKS54rVb7PsjFQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id CB10D6732A; Mon, 21 Sep 2026 08:56:51 +0200 (CEST)
Date: Mon, 21 Sep 2026 08:56:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH v4 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-ID: <20260921065651.GA13875@lst.de>
References: <20260920092351.2434283-1-yukuai@kernel.org> <20260920092351.2434283-3-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920092351.2434283-3-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 289EF180007
X-Stat-Signature: jx9uyomj9n93it3149ce4kpmkn4zj6bj
X-Rspam-User: 
X-HE-Tag: 1789973817-687801
X-HE-Meta: U2FsdGVkX1/wWUl4Uy6x4zqM+yOz6cjj8qZdF3LquvwidvViYyZbTghT9OA+1qOA27K2fbAFVPvh1Wup/PLXi749Qj3ZH+0Q/QJh93daKbpSl8Chrix7x383K8B0vmBbJOHDJEV8lGuS7arZ1cob+wRxAYnJghqWmQ7EMxNj4mOB9FrtrDIAQNFfrA2rQqJ7x8enS+FA1jMvhiHejd4RlNZRTy648SAKBO3IFFHGpN4NSNIF6HLY0RaHJrfnEnF0426kVwcUZR/+PJPDJDqblgYoKvUHlxnVStOYc5gZiHsp2swmMmQ/C0PGgSufbMX4bj+syI6Pd3jQVUVLCJQqkSkknaAvW+58s048/BhP0VjbeCMzuXjHJaZ+oIYHqAOR0sGJ9IeNLIyoUpXfvVmeQjK4wnWNN47ibHmV2p/W2ui9pbqHSPe9JrlAKoJL7n4EUtrv0gNG39liSt/YQm0kHyAeQRo1nC+DpIMFZLI/Y53A2M8qhA1kzm/U3EgGxXiTZvt8To5JV0/de6BIuIs2gAQ4igRjoUOJHj0f8qtvIJ4NnCEzHFdXqmGeSjLjaslYWtkG2DAKRSTQroP95uLolsDjMTcem2vlMofoWAntq4tyijEAjIsZI00wIu8dtHq3nBljugNMHnT+72Ky5Mm+Ztry74xE/B3luvE0FxT3cGdhbZ2YK1bMcIkYLi2VMVp6ptrH/nPNYFZgzXmX0tvz33+4piLN78gOiWBVv0Yw3peUJRwZLIdKG+rtWNKLVbq1mToTef7MLaM+qwfXtQSkIt42DwWeVD0pZF6RcDL+czcTMKuyjv7qHzlvtDLTZvnfCTK2XAXr5gQizUTcLlu1YCNifX68LPYJPvw0yfI7WUnWaR56p+5ExFI4cn59fSyX3Mh/OQmtKkdHK3DcsSi6URsckZbUCo+sGK3gD4yx9fff8zJGo2peIQ8+R0wLQj/JB76ji8ZtnDCMBFPCzhU
 ss1t1+sO
 7YXYx9dga+QJQg8gyMIJSroI78SHHf7XS2oJE0+g+1Uvy77+hlLpKv6Xg4UV00bGItv6L/wShtNTiR8OyXPu3D/m1xHbMvJfCWHGzBTSrIZ5rRMm35z31RBHKvbLk+CSawgOKTd5Hw+7WOeeUQQzNhCFjd4E0Pd35ruH7SlTY/a+akWH0xVRthFrs33gjrkVyiHBi4ZXsnwH7KGpSDmXPY5E9gv+9AuMjuqjOa8H7BR+mZrujFLmOODVyw9iJuh246AcJ9PCV76istRz9Vn6swEa+ZwaYROofw3ZnYj+NCAyHTtaLkdm4ZnKtoeZlsOSKnXGpE8rF0Hxt0fo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


