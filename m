Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8A7606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=yGQZF349
Received: by kanga.kvack.org (Postfix)
	id 473856B05B2; Thu, 19 Nov 2026 01:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424056B05B3; Thu, 19 Nov 2026 01:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC2F6B05B4; Thu, 19 Nov 2026 01:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 030E26B05B2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:40:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79C8F40941
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:40:58 +0000 (UTC)
X-FDA: 85450920996.05.ED3815E
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0BDEC40003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:40:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yGQZF349;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795070456;
	b=kM3GumnvhcHQ9CFX9MtUqWmsOQM4pkkAmaNr3qtaT/WyaKK2737vz/CNE7/6yszGvbnRMZ
	aTJ0TMmTq8nDF5vSQyn+jPgYq0K1btGJM2MI0RGkPElDndGNDPfVHQrOGBK5fx/MTqwvcu
	aHcdid3RLf0GiEPKFtiYaU7qlZPSGvU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795070456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBrOpa0p5MptB6uHOaEIkmXAYrmJEDtJeyYvGc8riU4=;
	b=tqZRxEH1gbLWdJufeOStKEo9NQ9QYSupFIoBOuC6vRd3/aS2de2Yh0qd/b9lyk2WkUOzZO
	TZ3hQ+9G1aFoe+/NvTC0oEYdDlaOa2e4Pv7La9LeaWhqbLCy4cy/PhUlKbWJ9PO23vtUGI
	05KKJc5oXApEkrKj3vTwFXcF7iX98wg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yGQZF349;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZBrOpa0p5MptB6uHOaEIkmXAYrmJEDtJeyYvGc8riU4=;
	b=yGQZF349ZQXwBSPXlGf/WDF5+TlDh6d2wuzdwzQlxlApoAeHsKjRuDayoBaTk8peUsZkmQnMp
	5AFAT4yWZhGmElIROUe/+ixnOiv8dXmTBLlpwy/eBIdoKcni4sC5ODVclf6z0tnk2RNFjuGWtIj
	QBZex74E6uiRbySLE+qMRBM=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jVTNc5cWMz12LCr;
	Thu, 19 Nov 2026 14:40:00 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B47B40561;
	Thu, 19 Nov 2026 14:40:52 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 14:40:51 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<akpm@linux-foundation.org>
CC: <graf@amazon.com>, <leitao@debian.org>, <corbet@lwn.net>,
	<rdunlap@infradead.org>, <linux-mm@kvack.org>, <kexec@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH v2 2/2] docs: kho: drop kho/in/sub_fdts description
Date: Thu, 19 Nov 2026 14:38:00 +0800
Message-ID: <20261119063800.698863-3-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119063800.698863-1-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
 <20261119063800.698863-1-longwei27@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Stat-Signature: i3xetf5ee6swzjgguysba6zhn6b6go1b
X-Rspam-User:
X-Rspamd-Queue-Id: 0BDEC40003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795070455-477601
X-HE-Meta: U2FsdGVkX1+9eUUVlpKWkOqK9pZAN9Usfjm1LlZJZ2lZ49rOkhRCvnvIXF2yucxhBvmA6BGIAZpzNhWHlWfMozhFlzlVTe4CBd0bUkeb1dW+T7G+jZealCXq6CR6tiJ+/nv3TJhbgJOiypEFG36VEJWcO9XSgrH2Ao4cMDG8kv+e3Re8D2BkIYKqqaTcdGVCq9q62py8Y0EbRS+GIyAfnb1kV9hRGQCkza6FccgYglzT/NjeCB8emKAcaXuDi9yItMMCkqqWbrxO+EBljFznXUjHaFWelCcicMV38SuRG2Y1oIAG56On0xWKbz+rcaAtsx8aBDrMbIL5DDY9pDlaf1Ymdqhm8f+ImmJN4aKl5B47attZzXb6cASaKj5DUtnBiHIwI2bv4DJKlsQnKW13nygyLLwmxfCpoE2f7cA92R+Moy9f+KioqZNTs2QjW6nxDCaQxGPc8/opLN/o8au3CW9PV8TpJ7QoFIx8IUx5L3uoVyVUPvx1bgVBnAprYZ8e4UT6WqkSr1tSSlL0S+J+D6Ys71VX25nzo1dEBNzOCeFwK9bbGf9OggAjU12GnOGeXfB98cQ+B9SY+scZw+6ssHvcS+AY5QjxFZA7XsNQ0n7HhDAxOPTLa1V3Ir4bd8hKv3J5mTARZb62wmerL8MRfdWSVkojd+xTuJWWjOImzy3N4xKZ/PxvVCl2zzQl5rM3N2DAOQeJ/yHRO0JvI9tWz6Hx5rzmGv71t2rfyrm/U5WJjBRpecS2eWMeJ2/YyFC9ZhQuQ5BETaypTMh7PrztsxRhZKN2MWeWFUobjcr6eB5zR7f0PZMSpiLfD9UIlHyAt4nYYnUatuqXBospw4tJfBkrwh4LHsivbjwjaLsv1snyHCy1C4MrGbon09Y87tqBaY0tLL8DQaXMsw4CXMjF0nkyhaiqm1A+uQSeBIdXqMD/eES2Bth0L8S4G/NlVmSa/hOoPYx0l7rS2hcwnTd
 mAQGdvB8
 jCD5inMOt9onoaGYTCB5FeG4hOzH/2Jrixpt2v6inMrehbMPyBOAs/fq3tcOJLeVJv+T4OojYKrHbmGN7VFBt2NMsQbr1QarprM6BsebtGRrEN5AL6UAGkqcJ3pJHthAGG8LUXeB8EuQ0ldTIkecMTASWlYi1RojkaySy7Pw6r9mfgtRWgaSQiFteR7BOtDOZHyxFQmDOieaqgm6sTPToRoIR5oijWK6hMDd/vUF6ZKUM20a7DQ1VQgNjZFgbX10ECA7BDkx0HaidAIMfT55LI3+4thEeMrTV1UnZG5wb+KWGv/QP01Ky0NXs6flzZslD7V/N8Izh35y6PMJ3ztWI3Net/bbXVTtGQqdHJcuBSv0J+MOzbN44N3cQfq/21w4F7XnoDn/Y7WHsM3DO5T2fHkWQeLsHDuug8+V90EDMawsYhm6mIr0fd9sMJoCGZlYSKCNlrMf8c0E3p8uscNfcBzW8agwCnnpqiqR57UvB151AnpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The incoming sub-blob debugfs directory is gone, so remove its description
from the KHO admin guide.

Signed-off-by: Long Wei <longwei27@huawei.com>
---
 Documentation/admin-guide/mm/kho.rst | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 902d171a780a..4281da6be5fa 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -117,7 +117,3 @@ stabilized.
     kernel's state is in this file in the format of flattened
     device tree. This file may disappear when all consumers of
     it finished to interpret their metadata.
-
-``/sys/kernel/debug/kho/in/sub_fdts/``
-    Similar to ``kho/out/sub_fdts/``, but contains sub blobs
-    of KHO producers passed from the old kernel.
-- 
2.43.0


