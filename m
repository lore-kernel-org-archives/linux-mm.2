Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A167CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836378E0081; Mon,  1 Sep 2025 11:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C02A8E0024; Mon,  1 Sep 2025 11:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660878E0081; Mon,  1 Sep 2025 11:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 501F38E0024
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A3E616089C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:09:51 +0000 (UTC)
X-FDA: 83841016182.03.217C3A6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50743A0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:09:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vbj5Orhh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739389; a=rsa-sha256;
	cv=none;
	b=U4+cQZXEluXua082VErnatlskWoYsiWHhrzIQm0goG5Bp5CM3c0mRi7AfCDiwkafj9ju6l
	6QUl+7Lz7o7ne3bgWccEmXctd4y6ulZRTQoK3sq86+ht/iat/MFYuf3UqKmqYDfPQM3xmy
	h1cNNMbqQZ6lAuyE6IZ5YCnDPMGMnAE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vbj5Orhh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofhABKsmQsD0ka1l5H0E8RzWEQACOMy7wboU2BWZCLc=;
	b=JBtKNkRNl+YaqwSTfss2ziTB9uOH97fHhYRzvwcKIysrV/tjIegBuJNp4mW/0yMRVMeNSu
	1yhOY9a9F9ImDACCWwg4FxDkniADGA/GWP6mmei/FdThYbZgxblo2Pb6kECicpVdf4KIZr
	MsqxlVYsHWYteAT8+R8vGdiRTBsUkG4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ofhABKsmQsD0ka1l5H0E8RzWEQACOMy7wboU2BWZCLc=;
	b=Vbj5Orhhm2qWQgCDAYdeG7/MHxHg8K8iGKnlxXM+E6qajdiXEbOF77qQkZLrw5xt+7ABot
	v87rTqzrUvave7ntb+ss9SpAMuhveeEFIizP3S4GznhBKemMEKY4ADDPuWYyPHSCSGOLCI
	4fRcDMqpn560rCNWOnJlmqkA60CfviQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-rpW4Z1WtP2m8xTNCro4Y-g-1; Mon,
 01 Sep 2025 11:09:41 -0400
X-MC-Unique: rpW4Z1WtP2m8xTNCro4Y-g-1
X-Mimecast-MFC-AGG-ID: rpW4Z1WtP2m8xTNCro4Y-g_1756739367
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B75951800378;
	Mon,  1 Sep 2025 15:09:27 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79F631800447;
	Mon,  1 Sep 2025 15:09:13 +0000 (UTC)
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
Subject: [PATCH v2 19/37] mm/gup: remove record_subpages()
Date: Mon,  1 Sep 2025 17:03:40 +0200
Message-ID: <20250901150359.867252-20-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 50743A0008
X-Stat-Signature: n6z49enfntoztpoqwj6jjdixd6hqysjx
X-HE-Tag: 1756739389-587982
X-HE-Meta: U2FsdGVkX184Ty7yECMKP7WoateYBtxUIi4xawCOJBXW3tD1vNGVX3afP00ngN7eLhuDeS/RUFPvTq/BtZg+AGj2KvNlPjsE2qr5+mZWLbMMan8UppPXOBlIA2EWjqPzWHbGd21g6wFR0h7y0RdJxBLgVYxt9LQ9B3s4nYCcZ0Z5+NpKWfSNeA3M74/06j/S0hRzXBX1e036jlVAokYNPQcumXIYxSTk46qa6ABNJucos0LY1RKY26h36Loijqv3Fk+pHjpumbBvTuDDeR6XlD5VgK7aSXf0pGd+HMMlNFFkqXoIWwEcggnTigiCdi+sKTA9gecI29IqhvhDOYrwp/UwFS1WS+/MWNmrK309VrcvB4asG47aqm1aTXZCekup+iNftFvG4krkX6RczBhvvezIAa2XU6ATf6aaRWtlSqcNRAfbShqiISb7RfquBAhVsIq7Ki6pVl9yZDmPZQww26v39WPXRvlOR1PTsFXf9LGox0yC4ZEPep2oBhlBZ4Q2fTfoVVbyyo7BL3G8IYohlF9xIHo+hAF0ErMPlXSeSs3OmYMU30HZBQW9odyy1ZvyGKNN7zUTsYfrlvgbnXxq/NA+/mcNgyiN4dvYjiI3oYcoTv5N/5lNHM8Eo+2dtNNNj5n8b7RBH+BE6tP0NB2OfXk1YDO8yAneHjnSbe1GKs0hH43b5cJ/aVQ9qi14NPMSgRj8I9UNH7tHPBYBwC5cpPBAX0a6XhezZZfRJ0XZp92yGEUDF4sg2WzkbzioDh3samhAGnsurJ7b+ShfGttWYVEG12pyNGXeSin8fTTezt3hanIWNFTI1IUxNvTsx7zPmzuOUQ7qjk+HIAbzHzbXhTO/Jq0MKp2YIKoaOHGQhoxS1TpNZzFbPOcTzWXEZYsH1aXoQtbZQR7zzZ4g/66zT7w/F7EnRPMSk4VPrTH/npD6Zkryg9DaqERxRAryOWM5Hvh7ziU69045BLBfPa9
 T5r8uqq6
 70UUpofM4UHLh4TjfJMHuApLeerRTyPzc/D9wS5B342q/+YTE++vTps5Mt0yIweNt3fM04VKIOTucfhr1X0B7rX31e/+PSKfHDD8MfsuLSCmk0ED8Ixatuz8JO0wZ97QyAK5Hpj8EhDikSrUnO3/DbaDxyEe1aw68SxlPMd8wv5VUE3pUHqde1WZS7qf4+ZucJ1CAoSF7vUQHWtt+Poh6qD5Lk1DvInJPdSO9Wew+MerUtZJHvHcVGA4zKMfATLt1HaSlk4hhbGpEKvWICsmk0AeGqGYKNGR8z8p7YEowikuQsxEjDy7Fi7kIkj6kBE+J/+r/lDtY+PNj9tQLxr0pqgnMTvA7crdUum5Yizk35o48BRxUW/bCKkkIsqvGceeHRuvu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can just cleanup the code by calculating the #refs earlier,
so we can just inline what remains of record_subpages().

Calculate the number of references/pages ahead of times, and record them
only once all our tests passed.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c10cd969c1a3b..f0f4d1a68e094 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
 #ifdef CONFIG_MMU
 
 #ifdef CONFIG_HAVE_GUP_FAST
-static int record_subpages(struct page *page, unsigned long sz,
-			   unsigned long addr, unsigned long end,
-			   struct page **pages)
-{
-	int nr;
-
-	page += (addr & (sz - 1)) >> PAGE_SHIFT;
-	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = page++;
-
-	return nr;
-}
-
 /**
  * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
  * @page:  pointer to page to be grabbed
@@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	if (pmd_special(orig))
 		return 0;
 
-	page = pmd_page(orig);
-	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, refs, flags);
 	if (!folio)
@@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	}
 
 	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
 	folio_set_referenced(folio);
 	return 1;
 }
@@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 	if (pud_special(orig))
 		return 0;
 
-	page = pud_page(orig);
-	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, refs, flags);
 	if (!folio)
@@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 	}
 
 	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
 	folio_set_referenced(folio);
 	return 1;
 }
-- 
2.50.1


