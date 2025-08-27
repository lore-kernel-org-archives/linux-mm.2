Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C9E3CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5378E001C; Wed, 27 Aug 2025 18:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C138E0001; Wed, 27 Aug 2025 18:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891738E001C; Wed, 27 Aug 2025 18:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78EB68E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:12:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43CC21408C2
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:12:14 +0000 (UTC)
X-FDA: 83823936588.06.2125AA0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8BFE61A0013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:12:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L78pCoY8;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=BjZP1wJyWe86sdN0trNfFfpbJ2O+Iw9S9Vvr0GbX0D1Zl/+79VonkkfPSlYp5wgoCwaKj8
	dpMBZdHVJa5F8xVLEp8kHuv+WLPjw96ZMYaONHu2rH8CAWAs0cuVp//voHYdsZQrR8SmTK
	JPvxVvM21/kb3FyKAD1bv/d7kBmCiU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332732; a=rsa-sha256;
	cv=none;
	b=Q9tB92E5azVxaDzIG4ChL76j/5JwpJ380MGWmtrJWCzox9gFQPrr6Ovh3KvO6ViazTXBz6
	XqTmi66wGbJVaR1692LR+ipdab0dRbpm8mMgQDpBysyeMC4t2hi5Ge8WomwPfRWmDcTv+R
	o620UEqcDF42vlFwhYp0E0JTGaIObR0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L78pCoY8;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=L78pCoY8ZUgsFykr0lvovKDmtBbtepDizJ/smeQgByiT7vGb5efwxXQKAYN70zFiHhNbr2
	yl8L4f4Laa9WCCoi+5sZjh3Tgo1o9na9sm8JusYNndnolTRjS2bApeWf8a/WtMZaqnP4ix
	K6qnN71l6pc6+fWOR/yhVURkjEOQtSQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-ShHxITs4Pxeui_5CEKaCgA-1; Wed,
 27 Aug 2025 18:12:10 -0400
X-MC-Unique: ShHxITs4Pxeui_5CEKaCgA-1
X-Mimecast-MFC-AGG-ID: ShHxITs4Pxeui_5CEKaCgA_1756332725
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CFA218004D4;
	Wed, 27 Aug 2025 22:12:05 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D11F30001A5;
	Wed, 27 Aug 2025 22:11:48 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 35/36] block: update comment of "struct bio_vec" regarding nth_page()
Date: Thu, 28 Aug 2025 00:01:39 +0200
Message-ID: <20250827220141.262669-36-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BFE61A0013
X-Stat-Signature: c6arnij38m6rprngsitbaaokyubgw45h
X-HE-Tag: 1756332732-557267
X-HE-Meta: U2FsdGVkX1/l3h8OAWMhC2PePqaJMwJM/5v5fAQfwutBRoBgCKjJRYAlbxojQnAXsSun+xYkKuwX6p543Mkm23iQvYiDIKTgaVqtuCNnJVgMw0zpGkl3utX5h0gUtUT2LgxvWIqdXAwX4ul2RGJFnKx37m6DEyh/tUSfmHPFJh0uJvOWApObLtf9BErndBnt/SL4OpgeR8k2qyYzNvxG1PgrM7kVgOidywu3+aiYsmpj11FgVt8iZ2bainUE+NnuknW/EUZQULTbf5aX+biqk2xXE19Bdlogyrd8aVyzWCDiyYz0Db+C3GH1X2L3om/0P77w7CLWHMAhOGQ4HXzAnG7HbFXbt2EMjVHZ17M2FuVCdGW4tawND4Q4Liu3uzTYOenvAkVW07f75vHntpwC/wABJOiIZiSrXWv77rpn4IkFJCOSkh58NF9iTFDSulgbYzPEBB4iwD6G+ExGA9qCKN6LBCqqh1VAis9U9sGPRmsm7DtPnol6GNSKe8yr1BG6UH0dcqQMtjeAs2Fpdruk3o9FMOfgb7uR2pjSbzhAwRbjD+nRR2ZrdbpQLkZOydr5bk9aXadeYSNgeJUYbnP3zRzor8yk0+pkB8cUjTpaShoX2XMeosbKr5fxWtmZ/NpwVifGwT0CO0lhxi0hI4XFyITZaF8syXCB/PdNqp1DpLnjmCwtcFcv/NaMrZKZPjpGpVgwkXDywwhC2LubdyJam0tJYnn/QdEhdcH6jkdx0mdxut688VCFS2cgrWo18jHV3VMXKUWi9FZkbOVaAbjMDZnbDgIi0VSjzAj8zsipgJp1OiRRBg50Mg04QcvBrCCeF9iQdSdk1Lu4jlbalWVs2acc9W6V7Mjt+q3ZBHLQFBqZJn8ytIETS7uM3tCIffZjnHEnL22HqSxj5UWcMmyo0bWQaQcQHzNddULFsbHHhd/eQmne/tqX4f+kZqD75kgvW1kO6Jm3WWn1woaTOnu
 dbu7FN3z
 T0q1w+IR+PiQXhg6R6EA/OXh5HOdxsX8NnOFCjPfDOlQtEmKJ7/MvetOYixwB9mCrSeC6rtMzhRbYUWu8BvN7GrGm1hqLbbihauPe9WLp4AlB/bgIP5AMZHpDZnqYVMCAwz/zuYdjqqrhsZuoYv6FPhdhPbdBXElcrIZWo4MSIa6nzx/DEeQGMu4WXMIqBSL1Q/dJM0xo//fghAZaRE4gL0yXdjwv8SSBzyL2JdH2PK2A62y0jdsDmVtbdvD2+VpylLrEWSxNtj/KZ0Elal0UnbmFYtaBDWHGCW8Ypv/rfMIw0thxEhMGBIC0AUgsqYW98+QfSM+1GJAne+HdIftPhpHcHuBPYlahr9oFU0d+f/YYdAnqeL8SBNa30iaTCtP/J95BouOmSXTqvlK9F/kJ+l9fFDINsIdLdkwH5h0fcbvCPIcdPVxouweUL56aTCpqyno2i/akBu82j+fVF0E46ruIlzIrgCkAcB+txjKvojJqBVjrOTjgJnZajg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since commit 858c708d9efb ("block: move the bi_size update out of
__bio_try_merge_page"), page_is_mergeable() no longer exists, and the
logic in bvec_try_merge_page() is now a simple page pointer
comparison.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/bvec.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0a80e1f9aa201..3fc0efa0825b1 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -22,11 +22,8 @@ struct page;
  * @bv_len:    Number of bytes in the address range.
  * @bv_offset: Start of the address range relative to the start of @bv_page.
  *
- * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
- *
- *   nth_page(@bv_page, n) == @bv_page + n
- *
- * This holds because page_is_mergeable() checks the above property.
+ * All pages within a bio_vec starting from @bv_page are contiguous and
+ * can simply be iterated (see bvec_advance()).
  */
 struct bio_vec {
 	struct page	*bv_page;
-- 
2.50.1


