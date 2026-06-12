Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10935CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3661F6B0005; Fri, 12 Jun 2026 13:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317546B0088; Fri, 12 Jun 2026 13:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22CBF6B008C; Fri, 12 Jun 2026 13:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11B896B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:40:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9964B8C200
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:40:04 +0000 (UTC)
X-FDA: 84871973928.23.718C850
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id F1F7CC0015
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:40:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lh+dpC7i;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781286003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNJrx9oq1UL8pongmkdLsFBykQ7w2rMMq+Qfkkw31IU=;
	b=XV8xr47N8jWySChDZiof5WxwDnrdySBerB7yD2U2Tyw2lEW2EXksjltsLNdQ3Vrzr1RbUQ
	rvuUuWdApljIBT7887DDZae1Qut/b79Hd/Y9NKoyKgrqo9buZRdP/wa7AQqbAOCOLuKnEs
	H3FkKvYZ1LB5BEBnvAJauJliftNpG8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781286003;
	b=vLSmO5tFInRCwrj4l4LYYYJ1jBy5OJOpJokVu/pBxJdKvuBch3SxzX+fK4uKehKyxaDJFA
	SE8Fsur1GwQ3gl2m2uGgqiha6bi031VtOGdnWObRJjSweEJ0FeXMN2W4M8bTOgUQD0kNNu
	hg/MFeONtIc34paAa5t5Wh8MpyaZusk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lh+dpC7i;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iNJrx9oq1UL8pongmkdLsFBykQ7w2rMMq+Qfkkw31IU=; b=lh+dpC7iNTulzRVjZHkyI03ik0
	aEN9yFJp5HpJJWZTqXtUyud760QbaIcR4iMK/+cF1e+V7h67crNPRJDqStJCyytj3YnbLSPkELaMu
	umSdzjpL6ThF0iH+JTh6XckNPbUSbX6s34lAxTcqhdQ2w1KHLKzahieF1UHJ1UobnfHqfdnVM2VHI
	biO35+CfthIWceH6bO2tGx4cCdDLEmmEWp80xUwYooL6mqWWGfWzcsmXUHsSI0VOJwDpky5RkuUq2
	dYccoohxLfb7HrOqh/sZ62fFhr4nPy6yCqpwRFQrw6PERLR5DdP0RCcmdZNxw5oSB4LmQM1J8oE6S
	WlGNyBSg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wY5rI-0000000489n-1bAx;
	Fri, 12 Jun 2026 17:39:56 +0000
Date: Fri, 12 Jun 2026 18:39:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: pgtable: protect lockless kernel page table walks
 with RCU
Message-ID: <aixEbMI0kK9in7AF@casper.infradead.org>
References: <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
 <20260612172356.356894-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612172356.356894-1-devnexen@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1F7CC0015
X-Stat-Signature: 5mkmqds1xxtqe8xznjmzwdc7qgdnfaao
X-HE-Tag: 1781286001-616674
X-HE-Meta: U2FsdGVkX1+yTelCOm2f8CGNrUG/P01MLUklEOIDiirzqb46pFr2iZ1nkMvbtx7feD6cAFDHIt8POFAF4HZ+fZDvw2tppFwUp3PkDvh4YU6wQ7oNfVQIyVEQ8Dw8sP+qsJUDz8kMHuIb6+DLNh7WPwz2wX7WRV0ShgumP51aATwZa/tx2zSLw/giQXwZ64MXAV8WhN7Vw/hSlYcxqGLe71r3m8ASc/1YtJmwSSDJrhJEYUP0VxEVASX0YSygvSnPL85zuPL1WFVEAr+W6ZLO69d2M557XoZN6kb+QADdKJbyzinSuVeq84CGuSK/MQlEBGIxB3zTAWmY1gRc5MhcSLwGR56CQgZo7KishwZTlFSZ4J56OaYvN8hYCTe5MWLal2KfdpUz4DBc1zngwwFo7+/jyyxMw7vl2yWj7spIEp0KruyKThRqsnsIaAyG/+0p6Zr1d00JsISIk4452S15LYAaTd79qrSenr4gRi85iuJLbIjaIwavvZ5OPoyAwCbEfPF/GR5SCAkuJ7rnoWstdRayZoZAk0mMbanRZA5eRePZbOdOQ7etFr7OasaJgoDC5x7XXUVfQvR40ojRFBL9w9+tZvdcHfVbIzkCQWtCLVveipWuPLVo4qB9OX/jHSB8nc6lCTFaal1OpA63e5ynX/KZAbXTcr/HAVY+21eyVb5wp0RRCron4KKkNyCtktSMnu+H6dZ1EqtUp+9v6or/g67gfYqCGrnaCAQcOBu7/qH5ULa3l6Yc7V9tjcWjlXwJvA/tzbZpc4BMmgtsYGEKMhRLjZCZYloWmigGdepjlys/cYoz3Ljyy6vW+euG4foZ17ptm+5eEuyQu3LZ6LG1/OXBqOEhesVihnTHpTr+lvAz5IY0T3Ucf3ba29SDBn50BCj7yB/a0YcGXQW+2d6ZHQjYjW3GiD9MTbxUq23SVaG+kzOh3aNVUy5jhRE1fvl9lu0gje04ukwnqXABvMS
 /RmP2/Hb
 G8cQgq9NZfXAz/0IukXV4jdiy3j6qmngEg0dg52/Ocblbm4hOWo4WlhGO162QbewrKKJ9xYdu2axvmhOvwKXoRghmHfVu0LokngQ75vqgei9tEOmPxyj3vsSs5rzarJ3/pqZmm1xwcm5exHQF0ASAkJLVZ+s5pMrBkepu0w1K5jAoDnKYKHALPN5q0RUJwItKXXbaM1B89o1uZvaMsUXgIyQlDDVFJeCzql6pCkN1MlXucILIDZgHImgas8tJXIqpgRPSoVnHiatFST/GVAbfvxTJS2orA+Jg9ur/Eh2+fx/mvg7LR/JfZJNeKh/edyAsNFy/uhAAnswEZHtFWAFktMxqWIYQME4mgMpoOcPu4PwvldoSdF+qmalWJ27DWT6bFnSJZ5ZnRzqgPGcxSQeXp0VjIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 06:23:55PM +0100, David Carlier wrote:
> ptdump walks the kernel page tables locklessly through
> walk_kernel_page_table_range_lockless().  It only holds the init_mm
> mmap lock and the memory hotplug lock, and neither excludes
> vmalloc/ioremap teardown from freeing kernel PTE pages via
> pmd_free_pte_page() -> pagetable_free_kernel().  syzbot hit a
> use-after-free in ptdump_pte_entry() reading a PTE page that was freed
> underneath the walk.

Does it make sense to walk the iomap / vmap ranges in ptdump?  I can't
really tell if this is something that's useful, or something that nobody
thought to exclude.

