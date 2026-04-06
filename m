Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F09F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06B9B6B008C; Mon,  6 Apr 2026 10:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043576B0092; Mon,  6 Apr 2026 10:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC23B6B0093; Mon,  6 Apr 2026 10:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE5D46B008C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:17:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B396160478
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:17:54 +0000 (UTC)
X-FDA: 84628334868.14.293E318
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E683D18000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:17:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxpDm9aw;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1E6ES/MKtltQpY4W2DA0k1Y4vn+dvFiHuU06SLcu9iw=;
	b=MOSKfzzGfXLsZ+LLNAWD2Nw6akIX98IPyR0r7NEDPKw5er+CB69o9eaN6bw9dZO/WDwsYi
	4r2hL+qWYAYQMKoyfI8mabFNRO89pdJ7pVtnB28pUueO9359X+bTY5X6GBAMvXnyY1Y1RM
	sziwcl47XzHi6dorxyEEWPeRg+QRQjU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485072; a=rsa-sha256;
	cv=none;
	b=Zhmb9o5pOFV8u2+WYC5Uv/WSfFc6XuifNtTsgaE7XSvenksBgX+bkm7XYElCgUISklSvhx
	+jODwk7DKtW16p/FmsBuczdsXpGKjMKOvpN8ENdZxlE8D5v/Z/K9+PT5LR/KpqNyifljCN
	5AD3g+VTRzExBK+6FXxnr2kT/ZfADX4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxpDm9aw;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FD4A6012B;
	Mon,  6 Apr 2026 14:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BE0C2BC9E;
	Mon,  6 Apr 2026 14:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485072;
	bh=6vj0uSM6vP/d0qVg1g+ptcF5MLY8M8muWRFmIKUP/YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxpDm9awfQNQqzRyBPfzjxy/ha7bCdXAq0vOwun5VdxQJzBlzmpeoyaq0d8iPWC2v
	 A8FBYM17bB4CGMQqFL6THW1GvU5YntiIuJHQmOVUgBzRzHaJpVBjiPI9SUUE2SXSFx
	 R7VjOfYze7UhL4nWmRzv4dcgjks71aAB9U8GG7CgeVlL6mqyc+b6Sq0HKRrl5b78RB
	 3tSRWiZHksl3twyTwnhyWnj43PmGwE3BTrwsxOWke71W6DKDqISpb0POxkO+v9oehE
	 vB0J6VmxpP8v2/qPh8MIlrcRwLlL1vfsQSolQyjmJVBiShNZZ+O+r+rgZD2AOyFUQw
	 h1z1uYn4Y8ahA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/53] selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
Date: Mon,  6 Apr 2026 17:16:43 +0300
Message-ID: <20260406141735.2179309-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: u9oopayeo98eruda4333rqxkqtuq5db9
X-Rspamd-Queue-Id: E683D18000D
X-Rspam-User: 
X-HE-Tag: 1775485072-657038
X-HE-Meta: U2FsdGVkX1+0C/1xC5N3DcZnCoGOtEVqW31a5XZLjr/rzTMHHdTw/M428th6Nj8pSX9vLf5K7KPipnLojsZs1Bgd3GUUsvZIBktELxjKou8c86DlD0nMH7jNBx1KLUi9fFQC1yFuwDydm7AF4fnBQI77OXJ8AT8ZzyorvNmeyCcEy2vvgzRBrt6jmUQPXkYVLd04K0cTihhvsVrmr5vAP63hVhD9uoyhK+vOcumfVRozzVhp4ouWbh1l97mXYzyQuAjCUVETKPg52J6drZ+pRgGO+yjTwB6G98H+ImbFz16GFl0g2ZZxDLMqZO8fGoLvopPkDMIaE6daj/2SjX+mO4MzjxyzpVoIkD1sNdmhAmZWoqUPWYxdu8suGDr7u+5V5vmA1wQxmAkjQt69gvzr7zFWAxl5oMzb3KgGDWgaGTbQTyXLX/MOguUOWR20UavUwkRy39ChMGGUuDnjm266FjwNfVPFtpsO7GCV41mQkbOklbiBnxtwVfY7pxTOkt40jHni0kpq1gmkZ38F63VRa1yOIg9JQsz1FJ1uEQwLGk6aKZGpGsCSL3yybI4nVaTE6C/+6xq9f0SsNhEVmox1C7iDt9nc496xZOXYo2fmtlwh4SpHXC3b4blO9l1IfOngZ7Qb8jz4h+BT1OHqLeuQ70Tc2rpcICnUSus3unDr/cqmY7Bt1DuR8MI+umc+eUc5LkU3zorKk1T8Y99zdq95hl2JuPrrjeEpZLdRFK+tTYwuJE5ux+XlOPKMSpFLYnXJwoGy/AYcf3vn64kpCJwkE6Gg0ycElziqX8xgaAgZhBQKP4hCJFRyJVSmFxvkt+38QF8l1xWEXM36vCQgz+4RcUpAN936G8LygVzyCSf3HxcsW9MlFLKqaBm3NnSrCGX3iVn1ak/Q08y3VhTIJnuYsIXrmHwxMYKWuoUkkJssCP+nVBvHpcYEF7KKSfHtOsrkQE5eylmnl/krBgCJxB9
 y+TZr2vG
 L3PMcNAaBYPTk/6OXhjfCBm5M0ph3wY0YSZ9AagQRcWQChJqLR8T5gmVs3NVEIyCjXXuql/9vbPuwcOiRmVjBmu7i4LxZzJ4pqyL8y9Ox15RNBn/UiiCNA3H7afZ05/m1JT32PfMLPpJ2J3reqnWabg7EWi7ADgKsSR7MVBXkaTX/T4Wv6SXRq6utmSWqFU1A1G0jyVJB74IHvylvANUenJcqu5VcuLL31Zm6BpGBjvB4KDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Access of poisoned memory causes SIGBUS, which terminates the
hugetlb-read-hwpoison test prematurely.

Add a dummy SIGBUS handler to allow the test to continue regardless of
SIGBUS.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
index 46230462ad48..6bbf15f78061 100644
--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
+++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -10,6 +10,7 @@
 #include <sys/statfs.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <signal.h>
 
 #include "kselftest.h"
 
@@ -261,6 +262,11 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 	return -1;
 }
 
+static void sigbus_handler(int sig)
+{
+	printf(PREFIX "received SIGBUS\n");
+}
+
 int main(void)
 {
 	int fd;
@@ -273,6 +279,7 @@ int main(void)
 	};
 	size_t i;
 
+	signal(SIGBUS, sigbus_handler);
 	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
 		printf("Write/read chunk size=0x%lx\n",
 		       wr_chunk_sizes[i]);
-- 
2.53.0


