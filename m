Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFEDCA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B688E007E; Mon,  1 Sep 2025 11:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72E38E0079; Mon,  1 Sep 2025 11:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0428E007E; Mon,  1 Sep 2025 11:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9CEF8E0079
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:08:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65A4B13B2C4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:08:27 +0000 (UTC)
X-FDA: 83841012654.12.2197E31
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id A670A1A0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:08:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EpML7K4T;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739305; a=rsa-sha256;
	cv=none;
	b=OH7vsdOUVE+1kj5FYN7W6aGG+PfSUJUNClaZ8haIWafWSzxbqqpBIltRayxOjGtRUTU6cR
	VwSzidJWkBULro7T2kIdJ0qalw6Qp8sqKRG4HyXYeRvNsg411fMIlKtWkxlsrk297cK65O
	DdwXlm9ni0QSTRJP/SU+waYYDrXnfDk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EpML7K4T;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnikdlkxszJnxILYw/0FQIsaidg40vxq0JvbNkA4kBo=;
	b=CIAm/iYcEhpzmM7JeubLDYHLMoFpip2ncPO5M1EnaNZ/AVE99b2PVFt2S3JNh0m85kRXt+
	5Yn0+5iowmkv6DNcrQ08W0gbZ31bM2q/QTGod9Ez1/IA59eKIJeyW/QtOYosyXL8bdR4tY
	sa3cuUOjApImNpdbdQJ9XC+Wr6syCnI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnikdlkxszJnxILYw/0FQIsaidg40vxq0JvbNkA4kBo=;
	b=EpML7K4TOF/RmfLgFfpTRFY8U0O9ysWWdIyK/X9H8DZaUdw4MDtiKZIO9v2EP/e9C322UD
	xRIf6IazTT16kx7nREXegrXKuvA5ZOmCqubU6KS8D0vMwtpZH6ME7OesajwXP8veGc7Y7g
	PHGsaC0akxMUrY+XQYogx09Mon9DqVI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-OMQKCEc3PTWsL06WnC7hMA-1; Mon,
 01 Sep 2025 11:08:19 -0400
X-MC-Unique: OMQKCEc3PTWsL06WnC7hMA-1
X-Mimecast-MFC-AGG-ID: OMQKCEc3PTWsL06WnC7hMA_1756739294
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41CE81800446;
	Mon,  1 Sep 2025 15:08:14 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A308A18003FC;
	Mon,  1 Sep 2025 15:07:59 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v2 14/37] mm/mm/percpu-km: drop nth_page() usage within single allocation
Date: Mon,  1 Sep 2025 17:03:35 +0200
Message-ID: <20250901150359.867252-15-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A670A1A0002
X-Stat-Signature: bgcn1fregrerb9d4nwyi5hbyf5wfhuro
X-HE-Tag: 1756739305-576617
X-HE-Meta: U2FsdGVkX18MolaCy3nKnmE5/WLkZVWP2rXmGjqWa5hKk+sckQf+ySExXW34RQmk5acsTDg9EnSiB8ixvGxXHW48ynlLv62VrSexuED/+ONDW/eWHFqXn6oJrZ4HHiFSuWAYyXQSNxXCAfQpXRAkVWATcZmhlpIyq/lvIGXeLdjctV2+1e6sxydzA4jh2BE0cJ8esZQAbztRBlhS1gJ6E+byJjqvq0QErkG6Uot6Uav8M6NJZGyD3+W1iE2f/cvxf54mcuF8VB/MWWtwv7FKIpIM9VCs3A3MmSenX6fJZFKP2KOYoCixDq4FJY0bKumcwQBKR7I93cZ9c6ra+cRCMdK4XGwxtJkyiVucjhGZLinLZYih+uj6CYcHEudzOD4lqyOwdVacEcdsFiu/9IV5sP3svIeblddTwmgEWM7c8YeZxRmfWZ1h5v8rGQAPgDKmkIzxgvytQsMvGev/+uExa8dJPqJBrUGsfMlbHWXhtKEK+mVYk0t1uqiyGNCoKGhhx0E9lJVYIQAeX4PKxRP6cYohFos8EgasZdXHRiiHFcMxwm3QqNqjr0heZEe3Zj/2tbefiG+bmF1kR0m8ETaBduhZJAgn5cplfUVdbexi44Qtp8D2GAWkz88d2HmuX90adHwE72GSaPEQCk/76XxuiwbP5MLziAjl4a6GnPmPewGB9bKIiODE8QwMwtdzV3XfRfkUHaiewGR+38dYCz3XWdVm1TWRMT5EYFWkse0wNyyJcNz/sfYB5LMwbYhwuS/1e1BapdbtSzdbdvL1JbGKDBZ/HuyXjcfBdab8jyFfZjM4CqC8ddHDPSgzfWLpaSqEoe03l5NZjthCvB/nbwFfoXVWU4PzA3h+xN7Q1sYf/nULz/Jbc0bBOXkwlJ8HEzmbjlL5qVg11p2ivpsClo2hveBViOyaTzCOTvZ9VI3Sji9mP3Z+9zKjw3zYqjpt6N+2qY6bL6soZlrVUqsPuWb
 ZenPUNYu
 baMeBOlBmMaxJYmujNLRwWe+H1mgjR6OP+EmTDfq3D66SCbPUbNUxndIuE9uhrB+poITTsulsZEQDxeuglF7dRgXTCmZw+9thdJL6UoEecUoTmTufA13k2UzeoG866OGobw7O/152hAa/z5/SoE6McmgCr4OtS7O9BQmcI+aaOS+xMie46vtoxmdhkKCF7EtLugBuOwRIk39XSbE/nw5OnnBHPwm+IkpXaVUHQB/4MX5zn+mWYj9TvcbzTZabylcauWx0ZktYG/ChdK+tbXwFgUjNrNMuI+nr+jo2hQIm9pyUoavtrz9FpDR/EYSyBXFugfzkvNc7Ak8oF4qYYIZc/QIbt7PNNU0uZZbpxvBIVDRkkIHG0LrBGhaJer63fz+m9QELz1yeOAITCYZRqyfwHcOdBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're allocating a higher-order page from the buddy. For these pages
(that are guaranteed to not exceed a single memory section) there is no
need to use nth_page().

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/percpu-km.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index fe31aa19db81a..4efa74a495cb6 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	}
 
 	for (i = 0; i < nr_pages; i++)
-		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+		pcpu_set_page_chunk(pages + i, chunk);
 
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages);
-- 
2.50.1


