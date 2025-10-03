Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1BCCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 15:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E493A8E000B; Fri,  3 Oct 2025 11:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20428E000A; Fri,  3 Oct 2025 11:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CA38E000B; Fri,  3 Oct 2025 11:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3AD48E000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:52:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73589451C8
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:52:51 +0000 (UTC)
X-FDA: 83957246142.17.78B6D5A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8FED4120002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:52:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759506770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=gS9qsnm5YZQz1RByb/ObLGw8nffFB9U+VkyARFN/i/0=;
	b=OdrsZOC5wocBJcTtu95j4yO4mxZQFFNPZFMcJ9f10z2DGwg9b6W8tSim0+WfoDvaTY9zVS
	F8IWf8r2daW7lrCnOnmzfbtrtyLW68Z5sjU+KIKZQr90/ppDrfIRN4nbz9wAnH2eA7rZhY
	Zbhte45xeXhKnwoGZJ6BAammFxhz74A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759506770; a=rsa-sha256;
	cv=none;
	b=RDi9bm20jssUr17KwQ7uB2mXIQjkQTMRPQbX7XOnH9xrKYpzTNjx8BgbpuOPr3srQhmJe4
	jNRhKGVXdWnH8+YhLy2+G1kPSLThEQrX8FZwcpnMPoD7BUYMNRi1wKtnjuex6OS7FGFcVi
	yfEm0RtvboWWBbELBkzI3wv1UDzWXc4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8872F1655;
	Fri,  3 Oct 2025 08:52:40 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D5BC3F5A1;
	Fri,  3 Oct 2025 08:52:46 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
Date: Fri,  3 Oct 2025 16:52:36 +0100
Message-ID: <20251003155238.2147410-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zyhjnfctnd8fgtbdt14q718u5p79pe19
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FED4120002
X-Rspamd-Server: rspam04
X-HE-Tag: 1759506769-228131
X-HE-Meta: U2FsdGVkX19+8Q/u8I/vRXiO5qr9z/BPNFmX7bS3mqVw9SelOyH2OT+JPoB3KquFyF4a7AfXXi4q+CRlYDW+/sAqHFdHslTE83ErUt4oJ59qAR1e6fVSJOQJHhoAqI99FDf9DrmOG8vT4QbKciSeEO8T7JM6N9vxveale36tqZe8cD2WClyfjupJpvfCv6DLYf5EOUkTKmZv/oJbQ6SbJKN+UlmAX11y4RIzDix97B/cYlV77Ds7wYuHevXId4sicPhWrQ3jXkp2HryLJ3YxXGzAvFUHQeqQj/vscByO86frv8eRzuHGqfbnbWaQdtfE9PAwIAcCo7cyR3P1lH118iySIRlmPXBMsUc+0LGqvf0o9r48GERwsrmQlwjSbPaqa9hkWGYDq00t9/NRqO3LB1yP48zw38zt+yC9XnM6TntA6GO4qM1/zKY8JBYu05JqPDambuNoQwQuPFvSD+UXHYFos4Pofgs0GqPZi8qFIMq09MCaoIOBFW9z7/URfPeeLGuNpN1sSkuJ4nahHhXogWVWjKN9skkAcwsUDHNZcufD5ifF4e6MeWwY/tTn2BZY28NE7WZfhZ+E7tFt9tCSoBu0h9/aZ+vOmXbU4kuwx2qU+2yipLtWFkbzNaYHZJmDy5OijDGkLqTVl1W5hxgXGWGkrg4TkdwQjtkBGS6ym1hr8BygxBsWE1qACaacgISuQMvdFC++rmfAMn55DK+LU4nrany5BVx7Deropih/ZIuCTPqVBqfFGq06PE9hyKqhQmtFa2D6gCxCufvBKnRQFfrf5y+4J1TztNXr3EX2bDzrAehCitzbz2UM/7u+LzdolEZ9w8ne6jljowPyozkjEftnJWffvURxZ2k6qeRad9h12OeG7gDzZYqV4ym/QnSZb+zZXRn0+UmaGpo2g/3PNd4dJyM+kLVLsppJE+Kj28GwKbD6DRaALs937B2uUTRr4QidSRvnyPEREDrMakL
 5YezULOI
 AF9KJFIfM1FToaNeJdBmK1Z0gGGug2uxC9MvOPAvAeiFQb28kytyT1tgOyedMoxD6cBPGRnUP65eV546C7Xvs+HMkUMS/pJc/uK9hgIMUNQES/C1O3gtgv1mSBR2mZRAn8YPjNOJ9zNi+oN0fToQd/C06tmrTdGsiJ1X7KNS/mSMHDfIJj33NVi5K1hzwSDnrWdmmeIdKhKceutzy126WreT/xno5wJ7M0NaH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fsnotify_mmap_perm() requires a byte offset for the file about to be
mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
Previously the conversion was done incorrectly so let's fix it, being
careful not to overflow on 32-bit platforms.

Discovered during code review.

Cc: <stable@vger.kernel.org>
Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
Applies against today's mm-unstable (aa05a436eca8).

Thanks,
Ryan


 mm/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 6c1d64ed0221..8989d5767528 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -566,6 +566,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long pgoff)
 {
+	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
 	unsigned long populate;
@@ -573,7 +574,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,

 	ret = security_mmap_file(file, prot, flag);
 	if (!ret)
-		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
+		ret = fsnotify_mmap_perm(file, prot, off, len);
 	if (!ret) {
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
--
2.43.0


