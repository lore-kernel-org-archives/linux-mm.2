Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FA8EA4FC0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7526B0088; Mon, 23 Feb 2026 08:46:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F396B0089; Mon, 23 Feb 2026 08:46:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB7B6B008A; Mon, 23 Feb 2026 08:46:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA34D6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:46:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79D8D13850E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:46:25 +0000 (UTC)
X-FDA: 84475845930.20.F25F3DC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 35E0B40014
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:46:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cszANuHk;
	spf=none (imf07.hostedemail.com: domain of BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771854383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJ4KtBZ4k7mPQNvSdOKma/KrL8oFM/9ZCZpnL0vUUmQ=;
	b=QQRIS0JTEwjmAfsmhTkWChCgwUXuFw3sAKgDTRj7Voel0wl1k0V7ms4MaU6Zop+iF3dly1
	CZolzNJ1/G4yCSRUVS/wj9MuD8EAh32hom+cKboksxpIPy7uSZlUrOXCM4rkdo/fMB2rD7
	mtzeIUtSZo8kpn0Yqv9+XFXJIB8AUFE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cszANuHk;
	spf=none (imf07.hostedemail.com: domain of BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771854383; a=rsa-sha256;
	cv=none;
	b=upUvY2g39nv0O2IBnun2hgvbGv6W2uMmLRagdB2oXUHwbc0OXHid4ihUYruB0XW61gxhhl
	0Qvf1czGo1N9Iu3jbUaIwRRbI78W4AtDC8bzL43Wmpd5kJc1dzD9Q8djuSQgG33ZLj5QAX
	1EfXXaC3WCq6UvQHDBQKc0PFm0seJSk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JJ4KtBZ4k7mPQNvSdOKma/KrL8oFM/9ZCZpnL0vUUmQ=; b=cszANuHklU70b08hJly+nRjFHg
	WEQcf911XV0uvJ2N74cAit4X9NPl4xV/giOETJPgb0YHIS521/q+bYzLZEUzd6pXStd06OMni3Eu5
	mdT5LXABrkMHMDrT2Ju6QHSPhM6Ej1zfaMmrR+ZCGYYsKMgB3p0yVh1HY6u6aL8J6m1BuS9pUgrjA
	81cuqWcc4U43+rrQruzTuAbrV9QaHXpKpD4f/2gAXhfdWy+OCrDVjEsMtAwibGd00Gsz4PnbtLBkn
	KXNs6D6p62k6+uYouKOuuxvOV3ttPQzzsK/RwvUZJi+Ia19k8oBEa9AQFTF9aY1xZ5hgD4P62KR3R
	0xozqhkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuWGG-00000000PAF-25JZ;
	Mon, 23 Feb 2026 13:46:08 +0000
Date: Mon, 23 Feb 2026 05:46:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jason Xing <kernelxing@tencent.com>,
	Yushan Zhou <katrinzhou@tencent.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Eric Sandeen <sandeen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
Message-ID: <aZxaIEFZr2NvO2eQ@infradead.org>
References: <20260223032641.1859381-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223032641.1859381-1-ziy@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 35E0B40014
X-Stat-Signature: a13zinmgrzbp46fy41hb6yoiq7rus4qu
X-HE-Tag: 1771854383-154316
X-HE-Meta: U2FsdGVkX1/gkuCGfOWfFb3OK+cVDy59vHodPLq9GREv75XzK+Z1JaN73Bfyzbw465i15JktQacHHF8QI8ILj7jynanEPjaupUxz9AmryJ9tE+/7km3rJQWdwRWSBU97FHlvJYJt9esrOJeRwHlxY8h1U1OrLucs+1/fwPH9VPy1QuQ2iXyP2NB0fl2kduASmaFPjPt9rdmvU54pwwRH6i7B0+tetFiqkJIQpRS3VUmcfOkTuWOgOS8s/LfFbPbS1Pmd6rvqpICo5DbkNWw91RxOMfoG9D6t4Xk3YaeZCNeDOUt9u55w3dOpnVotSZKNl6bE465pQnK7E7dKm0MXpgNK3tjsgL6B8HijYkLNeYkrOHV8nO3bjPtSvnzLtoRSUkj208VakxOfGJ/JJ4AZ+Gby3HZpGokjRfE812HRYFEzjh0kpw+fjAORM2kTW1tG3rV3Gb+8p5oB95x/cnNV3Od7yhlzKGVHNuHrurolF1JTtR7rQ9HCC0d6lv+yD8mEBceJDkN93xwrHKVKbkF0wvvnmYfQFFaiUu0Fwj647+6ikScryToHw6SX2wM0GWiJbhz0xMwpX17owBgTjltHkF0MvxuJQDSSF3M0iarnSvZMXKloi5u1GNtwGjNcRjXG6oQ8KqUwDhclEZ8QF8iCcTeWww4IDbcjusB5IEGEtC42GqWSdVtxsj/QRhOCjcaqHvH4bbyqQ0JKVl77A5qdsWRhzQnBvOp/t132Q+eJQAOeWHuDEcA0PeaodKz4kQeVaqfvpTdzciF8/EQaJ2GTg99WOrmJ+T7z5NzhIjiHuZkjW9n28G0AZov1iEFRXYa9to4sqQnuTqpWgk1HMhu+Fqzp4HXYZker2NSy2ISUbXa3E+g7OzcZ28tDI6oatrkF274C16gElh5Uf7X8iSOBxGF3TGpTjoU1+MBGKZFwspoxqk0qid7t5znSQ0hD5YKxJJ7V9zPj4FQWjyTTuXB
 9IY5/F8t
 vGt/z5j1DaK8yNMPXlvWFRzJQXDXm+A/C5tluy9bi1Sk9APFHhOOhwFgd37UOHueS6GnxgfYWk8zpxw1qkPFr6SqkJHRZ2lxUOrkYwlSgnD25KFGih7LvZqtOLASb18Zvr8F+wD44t+QYdG3BbRP1n+Nrvg4OB2qYiPoqEteiW0tbpFEAdgUf1mo70HIP+rIBf7dRsFXhwNZw70hU3Mq/FRuCEjJravlwfrdyeEKgwpBKuYhmzbbm0Bo+PlS38rLQ0EmreW1AXZxvDYytatX+ls86cyQx1vQchYLuG55s/qVtcTkF8HkCdRcgqzQNjdu3+felDbG8sGSUleDp//wg5oIebAw4apIEiI5GmlgloGwZNmQzOmLGkqmMsDKjFPg+CrvynZvvQVFd+sW+QGPXh3lRyzj/36ZQLBV711PkUQe6o/kUWo2qLJNqvaHkFgAna41BqwSFZ8Qqau8pffta0vNDIu7zxnpCtqTgc2aE5BLhZZ7nouYZc4N2kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 10:26:30PM -0500, Zi Yan wrote:
> Hi all,
> 
> Based on a recent discussion with David Hildenbrand on page->private
> is not zero when a page is freed[1], this patchset is trying to fix all
> users do not zero ->private when freeing a page and add checks to make
> sure all freed pages have ->private set to zero. For compound pages,
> both head page and tail pages need to have ->private set to zero.

Requiring the user to clear a field before freeing is just a way to
awkward interface.  Don't do that.


