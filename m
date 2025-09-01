Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B642CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35EC38E0084; Mon,  1 Sep 2025 11:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310698E0094; Mon,  1 Sep 2025 11:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC378E0084; Mon,  1 Sep 2025 11:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0419F8E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:14:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF31E13B2BD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:14:11 +0000 (UTC)
X-FDA: 83841027102.12.D515F09
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 058DB40009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:14:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YNb1THl2;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZB8VenTnhwuJsxCOtg12iGGVlRBSxMcM5zW2W1CE+LA=;
	b=eI8MEv2Oc9UlO/GVfp3pMl89qzcqo9jRZ72cW/EeWMbM19iO2YcnGAd8JZHNiRAJg1jgRk
	MdbmMCClOt9bKfoStAziQHZItDipZzSZI4P1wiBFkjhCvxbf5uA8qyAcvU3hGGlaAz+1tz
	UaIHYptU3r7mh3NAbJq3gjFw4++Ndf0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YNb1THl2;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739650; a=rsa-sha256;
	cv=none;
	b=z41A5PgVIWVXxGt7+kJcSEdQtW94NYZSnge6P6uRaNgx3gDFKl/cTfwzAu0ojuTR+5Js/U
	QoIM0A4nfUKcY19L/oxH0SB5Ww0tnc2zIHAXBhBFXFszJ8awGFONRpGphxG4TXJlgQ8yeF
	URFysejsYXU0x/FHqZ7U4Zz/wpxYf/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZB8VenTnhwuJsxCOtg12iGGVlRBSxMcM5zW2W1CE+LA=;
	b=YNb1THl2gOHNnA7n7ZWoCPJn+55mK+NAaMR3HqySYKTgRgZqSfQ3V6tJ060t/anhhF0FsF
	VlT71fff/iMEL7yH7kOxifbKoh/49jlPNed/pkV8aAq1nFpyQ8nm4CeQDNmSxEDGP6epmT
	lZFPdb+kQWQ+MEqcEccZVJvj9p9Dr7c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-CInaJEnEOsyAhyUHiabiVw-1; Mon,
 01 Sep 2025 11:14:05 -0400
X-MC-Unique: CInaJEnEOsyAhyUHiabiVw-1
X-Mimecast-MFC-AGG-ID: CInaJEnEOsyAhyUHiabiVw_1756739640
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DCC31800342;
	Mon,  1 Sep 2025 15:14:00 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C0BF81800447;
	Mon,  1 Sep 2025 15:13:45 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 36/37] block: update comment of "struct bio_vec" regarding nth_page()
Date: Mon,  1 Sep 2025 17:03:57 +0200
Message-ID: <20250901150359.867252-37-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 058DB40009
X-Rspam-User: 
X-Stat-Signature: 1ysakouahf31ndwqna5jqss4oobhzgk4
X-Rspamd-Server: rspam09
X-HE-Tag: 1756739649-353688
X-HE-Meta: U2FsdGVkX1+A8XFZZifKwRa3vZxPFenQGhSU06DDNKfTtDzknapdA+0ZE7BzpB1UcO3SjYEgtU5RKzFZl+ef3VkwqGsb8djfjCJsVb1PZhlAg4kKcxOqBrFEaqx19X31mpJ5iRjO4kzSlSsZ9G6lGN+ET6ye50DF+BObdoLma6w8gmI8iyvFxpOYTIGPsEDau2yF2VZJF4wnf/AcivIm6MV3eivDQVTQqoIbsTm3ugd/pAcOIFEAvRd+I00DgOtIlM+gmtpt2bDv45uB4WFwvWUup/1M7oxTleH7bEUTrnAABihf9PGZxTq80Mn2MBP8HOPEtX2tqNtyjoVt2ZgkjlcjcoPRXor4+UauWZJjUU5NR+2DldFkHt6yOgC0LnDml0e1C+GT/vH/Swl3sVtegvIpgirwlc4ePb9vIC7yb6XfivRBxRPqEwOby2YSZFi0fVE7F0irF2gRuFaNwGSUkF0iMiuDzXZSWZvwO5XYMvQogXkWnaYP2pPS2d7njIH8XMKYYFngEVBEPOrxKnF2kCEitGanSBM7gQeZhX2b3HXEe821mD03A4R2pvWLHxNYaBUExA5NH9OZDLVAki6kLMY/J/oSNlVZdVwQjnIBWHZnqW0HamXft5OFsZISFnpA2UrU4WCy8zxQDt2yNcBdxa9XV4q/S14AWMeNqfW8NhrzA5WmNI4o3gFEE+D8bXpvrG4XcySkpHXbuDYXn/LD/X5u4U1KoWl7rvPYxuIgCUfKSQ0vgcQoNjynxFYwJDd3bz5jXKXkOOh3ZrELkEEfSJY2Pp3ncYdnym4MG+PwgrF0d1qMC9NDk2fPlfWazbxMvEpybOOYlzpgPKxtwM6NkYU+buslbaq96Yb7KWPehmMYVScQ+JnaUsDVPOypbXGJMIDp9mrTtiA4LAPinoSu+Wb0HiRTo+ELKcP0NL2Ck/QkhOA6fiu3r1oS8quHSbGZlqga64VGW938fIsZ+BX
 XhEVvJEH
 iSYbbgvWgAoKyDi3tm4YiUpzlEsID/II/ouZNRIbbAc7S+h0+gm4zlPd/aT0oW9nqqOOrHLHNPJeqT6NZ3fkG3appvQH1sq6WCylV8vXd485k9f+jRMpccHRxc7yJd+HFRKTXjgqcsK4nlp/GhH2OwVQ87O8c/sJFo4z3W58dXHrXJIBWDbAB0d0rWQHuAqL17i62tj2WnyDkEPr4PY+F/6x2d2/yw/Ootzdvcz3s/6xWlZMpyyYC+ptgvD7db7fnzcOV73GPIZRDPjk6GGYfMrJsMmFl1jX8jdT6+/CEy3/qM92LowI63NiP6xTQQDeY3l2TSO8vwKzzuMLGenK7aV+qW2jcZfV2FMYYIONJxn8ykNtmgdFKREh5ZRJaGfmvZp1eruLThz1ieXe4KGaAZ+eUAA==
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

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


