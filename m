Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DE4CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F1A8E007F; Mon,  1 Sep 2025 11:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106488E0079; Mon,  1 Sep 2025 11:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F374D8E007F; Mon,  1 Sep 2025 11:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E62488E0079
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:08:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 863BEC08CD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:08:40 +0000 (UTC)
X-FDA: 83841013200.26.D77A6DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA2C24000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:08:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fgk1zUy+;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739318; a=rsa-sha256;
	cv=none;
	b=NUofk7XB+W5ReIHLNA1hHITkfRxwpt0Z5OA+2v4SPTTKXKdRoX3vtyGH0JpJwtYzfQ6V0Y
	xHJJ5eptpJKSfrMl+e1DObCKHDnCcQ+P2TB0Z0hjmXIG8a0vZ9XlVlwQrmSxx9atAmVBDY
	1mCM4zHzUxdmC6FJYts1BXN21+iGivk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fgk1zUy+;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7z1hEbmTMnNJugBbqE6gV6TDdcPzbGR+eC0MU5uXl8=;
	b=73B9anmaWvU0AJRHAq98zMOTcSN6MKcs5RK4o4OIqsUtn5LjQ43l5T7MRoxrMkCFRn9UDi
	on9TqIaG6LP6XIXGqD/2eNi0AwVqTS0SBL7wuN4mK4H0oFbUrUAB6EwcNu8WgX0CAqFgHA
	vYjAmVd1eQ54CUTpt8zKZCfmAZB40jc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q7z1hEbmTMnNJugBbqE6gV6TDdcPzbGR+eC0MU5uXl8=;
	b=Fgk1zUy+A0ROj3Wr2rTeSk6SO8N/qSQotp8bajEaSHkGJG56kPEKc8A/eecW6TPAUa01sg
	VqGheGClTp6EHdn26Is5tNrZ9uh2XYPGE1M8E2xKsDYgokQWlHduM4QnUAV/4mzHTb1K4I
	T1C1gn+9Qbs0VKnBL/gV+IRDRXoFARs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-YP3xofrJN8yNNz_Gl_acQw-1; Mon,
 01 Sep 2025 11:08:34 -0400
X-MC-Unique: YP3xofrJN8yNNz_Gl_acQw-1
X-Mimecast-MFC-AGG-ID: YP3xofrJN8yNNz_Gl_acQw_1756739309
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44870180028C;
	Mon,  1 Sep 2025 15:08:29 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B085118003FC;
	Mon,  1 Sep 2025 15:08:14 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
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
	x86@kernel.org
Subject: [PATCH v2 15/37] fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
Date: Mon,  1 Sep 2025 17:03:36 +0200
Message-ID: <20250901150359.867252-16-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA2C24000C
X-Stat-Signature: ceukozoyfx6xpimwsgxuwoy6k3g3xg4e
X-Rspam-User: 
X-HE-Tag: 1756739318-362583
X-HE-Meta: U2FsdGVkX18TAEBoRnwmtXQxkr4AIYWDNKaFTNmZJBY54fKH/DE99hRnex0A5SQWoiNY9edPUNXMA5IMgUPwFsbZykzKnRMHDzKNA/5PZouqPUJbhSjaQbVnbOozITmsh3ygXFzVc3n2hw1w1JXRgHRI3eF5EMk/GalskoS8GeFxKuqvEoayNFEfBacowG3GTPMvA7xSCI1NkVQZNPPiXLWIyMBJZSUvldlcLv+jyO18nkiVR/Xgs6D7FtCDBUyu8xs0NmSppIpVkV9fWiM0t+VZrDgLBJ6DyFtc6vxIzne2v98F9dZiTRmRLiZxU2OtsTf9BBDnTodphjZZyRxs7886AJParKaBxvjaJE2YY6DeKmKKwI3JHEnFvY0JIbnQAhdiyyLIIenCHB1We8XLbrHBY8HOv2egfVyJVac5g+i8aoyYffek/nLqKm74zWJO0wcDds+rMqzS7v+PgM5lkFJcD7GPYWPONr7LC5x3uu8gKZ+cai+hBRIDC6iM4SpjGMAK/9BfTjO+syt1pyqcW/QBpbVOhtdE2+z0OcCjbTjFgkrQF6xB2xTehwlb2Xm16P9FKre0SH8/gFJChvApWjxbdBbqGdLWcdk5WtuKzXEy+YzzUhTB2rDe/m2/0NPSkIywP+ntpRDuRPvpYgklkHm8HdI6An27aa9Yl3FbnhWHKJtZ+CpUrvABxIux6Z9GqUcNMFrSkZKCbzdgCaPnOBnl1455jMCv2SHhkfoMeM67ho47QgvsXwmB7ZEuLssiCz2mqrBdINOPWRaXv6bvCUbqPfKfZyYNQZjahbspRAxZkepvxvSKS3QWr1ptEjm1haiF/MS8xSkqg6rrtnrd3cVHzsEWHfdX4buEmzimAXDEQ2Wf9YUpWl9qusNxj2glVbFz1AwYoB/qycCedPkl/8XFFU5rahpE+nX8T7nOjCHZYWNW1eJqsReP8ZhIKFCYRe8W2+B2nmItlb9G45P
 sIQ3/O99
 CDWNJqORcjMraNzD8CGGQUdfi407CMzhRQVPISfz5HR/fdATUKFvxalbBKO0aNyfqAP4WO/bkAv69kF5p/bV0oiUZBBx8Ec5/JYYfkVIUvfXJ33NHa6h+ZZ6uH7pPz1Yy2Cn92AKnrU04LvYCraLxSIsz/80HLvjJA/eRDr1X4EsJQ12QksNkTWOx8jfKe3pdDgkZOTgniLX2JiM4ey+UkGBKD535SMcjTDbJBSwcctTkbiWHfXa/RL7ananRfnVUnfeR3bPX9OSYpOkv/DVBzDkjkmpe/fzqkT9bFF8vjBkNndywb4HqFamrikx6OFk0olEMGU4debj/tD4DwnEXQK4cN3ciZZgz8yPSjkefhyw2xVTb20h5+R085mPoDsQAqscn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nth_page() is not really required anymore, so let's remove it.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/hugetlbfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 34d496a2b7de6..c5a46d10afaa0 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -217,7 +217,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 			break;
 		offset += n;
 		if (offset == PAGE_SIZE) {
-			page = nth_page(page, 1);
+			page++;
 			offset = 0;
 		}
 	}
-- 
2.50.1


