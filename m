Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D03F606AF2A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=Wd7lhLdU
Received: by kanga.kvack.org (Postfix)
	id 6427E6B05B8; Thu, 19 Nov 2026 03:40:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F4C6B05CB; Thu, 19 Nov 2026 03:40:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416666B05CC; Thu, 19 Nov 2026 03:40:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEF116B05B8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:40:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AF964099B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:40:41 +0000 (UTC)
X-FDA: 85451222682.09.82B296D
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by imf21.hostedemail.com (Postfix) with ESMTP id 72D121C0002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:40:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=Wd7lhLdU;
	spf=pass (imf21.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795077638;
	b=ppim1Jsy+5PtV9JfpO2vSssPt8gqu+Mvax9rC1VSAPMy/CUyIO0HmD5BPMZrST3zrYaXfS
	e/oS4TR7FG23FXQVo70bfCjTGeSwMPKOhBh0/TsiU6P5feCNm5p5T0O5Rs/n/S6zDFYcia
	cRL0OQ4cJ+Svelj0OqeJwMIy8m1z1PU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795077638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xeb9CD9rO2tE9rfmH1/C/gNkKUtqkCGTaZwTcZpzUCs=;
	b=JfdAiVzTBcFAC7khOh0wWuY2SfO6iwpeIO9GQlcX+1h7BEdt8TTqGGe+Fu49vbUe3vKzLD
	219bdj2sTtD+9iRy9n0NlNi6j4tSoeUT3LrI3lPZl2RUwWyEo3lqqHA5RWHiwDbzC7XSBf
	OwLyfZq+VTe9iNX6LeAg8/7NFBxHdws=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=Wd7lhLdU;
	spf=pass (imf21.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Wd7lhLdU1sVDHkkhYxxPudbxV7+r2zeEXfb+Qb/MgjXkksQ9pi6YEoM/jpJi7gRDb7GbmT+ydezEL
	 3G6oUEgEhM9qXLr4AeHMfRhHdv4x5C00Lmy0T48vXcXOQ1CwI06LAk2sseON5zekYVh4a9lrOrhr8x
	 dc5FwACs8VDYil60=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66afeb601b2b-e8de1;
	Thu, 19 Nov 2026 16:40:33 +0800 (CST)
X-RM-TRANSID:2ee66afeb601b2b-e8de1
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee76afeb5ffb3e-f6799;
	Thu, 19 Nov 2026 16:40:32 +0800 (CST)
X-RM-TRANSID:2ee76afeb5ffb3e-f6799
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>,
	syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com, Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: [PATCH v2 2/2] iommufd: only hold references to files memfd_pin_folios() can pin
Date: Thu, 19 Nov 2026 16:35:31 +0800
Message-ID: <20261119163531.315791-1-xujiahao@cmss.chinamobile.com>
In-Reply-To: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com> <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 72D121C0002
X-Rspam-User:
X-Stat-Signature: yrtpi1nh7h3b6q7cg7cynj1kji5te8p8
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795077637-420883
X-HE-Meta: U2FsdGVkX19CKIiGcgq0zkFfdQqGRur7WOWtY9KlpysszeH0S3aneC5F6sccGz6SEYI+eNVfzJpYM39LIGuYADukK3RMfoi4O7GTWtMDLZEFcmFn4SgoBcdmJviIgx4s9Mi7YnHjc9sskOeqz0JeARmL/ECyVMInrVqzf74FxsL/6zFgGRGpYA84cOWxjBheZghgCablQOuN7IZ0LX0GwwqA1zratJ6MIgUGIVwDhB27Zmx/RyvYZW4ae5V6bCn8og8bQDg1zuClAD/XUrOK0CGHFuOUfDgwvkgaaC0FzTw0YChIeAul1xBK6xrNI2qgLumRLynwYowEQLl2vp7ENLBMzQM0gjBI9Ap/9Ml39Nh0nyIPYgQHJXTfsBlqHpiD74FUojDbY0zxdgP0+mDn+PoKnazflR/RRaTLMtMp8XHRbot1tM/viaQmyO8VqcG6KnaKFI/r8LAHRLrx/JTMFHahiR1AY61YIsVcS7B9pq0hqlapibab/nrM0tCwnEKpgQG6I47lkQCo55ZZxtCOkciuFKcozZf3uV1ebFCIPRahGwY0U6KY3QepRFzpy2gIUwo/XrPocaYAi9jOFOYWcXmDeQXOkhfMHdjScMUiBgORYE78qSeYGPII6qymJbazEuSGuogoHUVhdjOewmmDoeRGcXiZfIcGbS38pkTAqSn4KPQBv0UXfxqigbiwfwTl+AmfUrAYNMwdyd6p14g6AM3IX3j6djqKEeSkmWSDMQDQZ29HZ8JycL6GJMUR3xRFgaTs6GAgdbd0mvlq+geLfiS+uoxz25I1RH61a/yybobRCu/DERLIu3exs83VGl3sCxiEvH1vpeh+X0RxVMcAyMKsQAY3oS0jkJ5y4QMMhKiGkf02JKsjzuJpczZaZUPRC0vXt+aFZJJ+TvhTdQDZ3i/QMEuY1tDNqcz0yUJYfeTQEA6cE5+0CsIu4feAiaH0uqYDIHlI1ZwQTypO1xP
 mcArpFeF
 MxextQi7qztik1znwIYVQp8svrSMtQBYZ7p/qZfKvjHmcyBIiXaAaJpxaPHOinBMNuwpPo1LsQtDoBJOCHV8R6LEA1qln48WEIXpPE2zi9/w6BApLUVRhYW/EGpfKURNBWcl9VQgZ1iK8P01GdQPM5Jmk6zAi97H4pOzC28EhXOqlEshcEDxGMdtJr0cvfhNIctIApNV+PAjMbeAoaw7xjlkwEDShQajbedd1vnFrkl2UgxiEsDNA/AhuQnf/MlDHcs9rBNwHKC4OS5sfOL1Kdv8uJZcyKQSRH7YTBDzj72YKAM0PGKTgjMY+NBlUJ+0rKZzSOmdM97oOS67h9GlGgEnrlLF7jn0RMC5vnwABfrwA7j6yxb9LDBQpkjW6Cuxa8GQEOvqR/y0ZVfjX99SDckzJxvZw22VcTF0cU5p3FoGbqcuNbSodK6HfMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

iopt_map_file_pages() stores a reference to the file passed to
IOMMU_IOAS_MAP_FILE in the iopt_pages of the new mapping:

	iopt_map_file_pages()
	  iopt_alloc_file_pages()
	    pages->file = get_file(file)

iopt_release_pages() drops that reference only when the iopt_pages is
destroyed, which for a file mapping happens while the iommufd file is
being torn down.  Nothing restricts which file can be passed, so
userspace can map the iommufd file itself, or a vfio device fd bound to
the same iommufd, both of which own an iommufd_ctx reference.  The
reference graph then contains a cycle and the file, the iopt_pages, the
IOAS and the iommufd_ctx are all leaked; kmemleak reports it as
"memory leak in path_openat" with the holder taken through
iopt_map_file_pages().

Reverse the test instead of trying to enumerate the files that own an
iommufd_ctx: accept only the files that memfd_pin_folios() is able to
pin, which is exactly the set of files the mapping can be built from.
file_is_memfd_compatible() reports that set, so the same test can run
here before the reference is handed to iopt_pages.  dma-bufs are
unaffected: they are taken by the dma_buf_get() branch above and never
reach the file branch, and iopt_pages holds the dma_buf there, not a
struct file.

Fixes: f4986a72d6e4 ("iommufd: Add IOMMU_IOAS_MAP_FILE")
Reported-by: syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7666ed2c3d42196bf7e3
Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
---
v2:
 - Call an exported mm helper instead of shmem_file(): shmem_file()
   became an out-of-line function in mm/shmem.c that is not exported, so
   calling it from iommufd.ko failed at modpost with "symbol 'shmem_file'
   undefined!".  Reported by Jason Gunthorpe.
 - Use file_is_memfd_compatible(), renamed from
   memfd_pin_folios_supported() as suggested by David Hildenbrand.
v1: https://lore.kernel.org/all/20261119104417.459962-1-xujiahao@cmss.chinamobile.com/
---
 drivers/iommu/iommufd/io_pagetable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 5ac736cf5..c9aad275f 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -515,6 +515,18 @@ int iopt_map_file_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 		if (!file)
 			return -EBADF;
 
+		/*
+		 * iopt_pages keeps a reference to the file until the mapping is
+		 * destroyed, so only accept the files memfd_pin_folios() is able
+		 * to pin.  Any other fd, in particular one that itself owns an
+		 * iommufd_ctx (iommufd, vfio, ...), would put the file into a
+		 * reference cycle with this iommufd and never be released.
+		 */
+		if (!file_is_memfd_compatible(file)) {
+			fput(file);
+			return -EINVAL;
+		}
+
 		pages = iopt_alloc_file_pages(file, start_byte, start, length,
 					      iommu_prot & IOMMU_WRITE);
 		fput(file);
-- 
2.43.0



