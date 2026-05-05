Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A540FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 05:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E036B0096; Tue,  5 May 2026 01:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5981F6B0098; Tue,  5 May 2026 01:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411C76B0099; Tue,  5 May 2026 01:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDCC6B0096
	for <linux-mm@kvack.org>; Tue,  5 May 2026 01:18:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E63BF16038B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:18:13 +0000 (UTC)
X-FDA: 84732210066.24.E8016F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id C413540006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:18:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jWPmU14r;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777958291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLjY4/J5JL85E68r0ps9b0tREEnQO9bxlLysLhOu6aU=;
	b=6uufIlBnKCY7uCxnIinQcaqNHJy5KD92OssEpXJ/J8UkmYMmElxg8GfznHgj/Lr5YKWAwK
	Iz9/3QXRtZSa3VoF7tF9AJoI3yOb7+a/9v3UnIw2S3v+ZZ01EYe+Pf8nNIcT3Y4vkmP/M3
	oYCwsSLF1KnoSKpE/jhF6REjQn+9o3k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jWPmU14r;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777958291; a=rsa-sha256;
	cv=none;
	b=2FJvCuqZjFR2pNfw+eorATyC3LVXQU5+TuUcKvwiruJbyDTThMO+H3KIiiKWgntViWBLvF
	iWamCYpT1flO0LHm/Ezl2bicIPU3bndlPHxMywrgPogzq29KYiNssoafgArx8MbkV03MfH
	e/q/l/+4fQL76A6xZQ0Xyr5Lct9mJns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777958291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vLjY4/J5JL85E68r0ps9b0tREEnQO9bxlLysLhOu6aU=;
	b=jWPmU14r3cBcPkQjCddLn7JWTgK257OC7nH3U8WhWtmnMamZo9pa9xnXj9mLTUGystnGsD
	bkAWLUI/k3QvxQSd0IQfX26JkUrr0qZcpsicm5Jtf8Juh8azKNAKGFm2iTupHCFhr8OC6Y
	gftf6pIHD6oxbzZ3l9np738MNxUKQf0=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-j1GXq1_oNmG67VUYIRWnLQ-1; Tue, 05 May 2026 01:18:10 -0400
X-MC-Unique: j1GXq1_oNmG67VUYIRWnLQ-1
X-Mimecast-MFC-AGG-ID: j1GXq1_oNmG67VUYIRWnLQ_1777958288
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a86f53a2b7so1452363e87.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 22:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777958287; x=1778563087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vLjY4/J5JL85E68r0ps9b0tREEnQO9bxlLysLhOu6aU=;
        b=V4BZGkYmJZPTR7NHQSy0xie36FgiNX5AXNXvYZNJAYVdmZd8JALhWCHWFstIKaU9U2
         I+pzIJf/ugiV/tCbjcuXOu0iVXyUCffpQRNQBU5+wWLfGTkW/jyT/SC1I0WjtvFy/7Sv
         S14Jf5iD7XEiDeHK0x1d52Cz7ansVHTCI39DHilGlXxoDNgJi8V2TameiWyfG+mW/Szq
         qpEQqW+LE8/VH5oXQPZ3zaBRKc6zdDKhckUHzicMUhb5qUNpIupeFGkbmX00ver2+vNg
         qgjcWzNyDtKp8dGvhBvxYAYTsd7089jtfWpZIq/iKeX5It+mf+RmqoIyXteQwKk6ZRQi
         kH1w==
X-Gm-Message-State: AOJu0YxAr6V8yRp3sTIVoSOpShen8LcufprFm9GsrYoNJ4SfKS8uFYLe
	jXMrbFL6uDsAFpKLmKTj9w89yzGMeYwaztwAoYXux/lw0NJDVpxTquKnNRgdFHCu/exdtGE+e2x
	k/jVA0PyYdsvAfoNki2OuNzp0IZX1QvIcywUtIORLtUIqQcNeJsQVS3zkP8MtyjGDhfngEwbCZ3
	4vfO9rp/t+vpkz/ti8oo0Ovm+xp98ejKLiuDYVEg==
X-Gm-Gg: AeBDieupPPDHdrshN733Nj3gvF8hrH0QfaK5wrEr9WujF7phO6IZ0inleW6dlXh4SIt
	rxHPnbIRo8tNFxj/kMziRoKk2tkjlrVIIuz1vM05z36cDKD29hyjTPqGoS5YRiWbI8BBzKG2y/O
	DyHK9gUcj4ooMRNCcTp58rnLMxlZkVxPKTzbBdSeCGyW8UZ3DEfmLgv1m5F6+wxAxdPKrMNLHLG
	dS5zT8WSBwPVhwRa0vc8W1f05/yfGZZ71ddpn+7uj0pHS+GiKu2rBspHT+4vFzyAEe3LSq6rqj4
	67rbfzDqEdZdO1LjhHzn/zbmm+78v5wMDyng5ETPQJHJ9y/Yt4deoK3HTe7+qrWLuzzbU+b18Vm
	DaYS6xujtOvYPPpgtUuIyjQxjNSCoVhPheZlDR07J3ex6zOc=
X-Received: by 2002:a05:6512:3b24:b0:5a8:6d06:fe1e with SMTP id 2adb3069b0e04-5a86d06ff7bmr2884926e87.11.1777958287321;
        Mon, 04 May 2026 22:18:07 -0700 (PDT)
X-Received: by 2002:a05:6512:3b24:b0:5a8:6d06:fe1e with SMTP id 2adb3069b0e04-5a86d06ff7bmr2884898e87.11.1777958286760;
        Mon, 04 May 2026 22:18:06 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3936138935fsm37206141fa.41.2026.05.04.22.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 22:18:06 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v9 5/5] lib/test_hmm:: add a new testcase for the migrate on fault
Date: Tue,  5 May 2026 08:16:58 +0300
Message-ID: <20260505051658.2219537-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260505051658.2219537-1-mpenttil@redhat.com>
References: <20260505051658.2219537-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -oMixZVmK1-srdDgHvoI6XK0rojUuetqupNUozNAXa4_1777958288
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C413540006
X-Rspamd-Server: rspam06
X-Stat-Signature: 67xtzg45fxwbwzhaz9cdexem3phqdsgt
X-HE-Tag: 1777958291-876205
X-HE-Meta: U2FsdGVkX1/eRDV1lIqQxxvcAbn+28KbuDFsslx7CbPYV9RTvjKU8I5fkeXoxULoSaNyy2bfMBmWfdRE1O415C8Fg+lpBiLwoZd2uQGKDemlfe39VMbqtuYdkLhfCbaW8KLcuBc8hpUqI9nIFMfjo2eZPZk62Vc1Az5I+iD4/21FOCtoua7rAc3g1ezjCa7NrOXlPG9u/V3OAZwLYGB72fXxTWCLaZ1PfVlsIxp6VXY0jHubaZJPUafehqaxA2snPXmSUAmOG6ipdZg1fXYm3+yz+atUCoLOteczZ5fiDsjrmJe9DRPkJ2nS1jlcnzoImnakxAdWHzNc1lTMpbjo9NuUhJJEZktGTysG/DbevTwTHl7b8RpBHkXikxF/naU/6mZDjXC6HYQv4L+nLDZmSYQ9sxVnIMDtwrIwthnyUKS6LhVnTJdTmRsV3EXx/wUCfpPET00EQ1I83J4Va79d3csfyO9xB+Pex8yvCsrtIggWTR8eUcFWRBTROvVQYjLZb9ivb1aPl3VTQH7BaeBXonygwCRWZ3jwKhsnVqkY+1ovNPbm3mQN1bYWyXc4zHEAxJdutCvBttav2QQtv8Zg0jim4UciTG17/C2bXzd+5zZzlM9cZuzlHGJnjm1pmZaNRUiX4/fEK+VJzAdCC9FaMBDXy2UJikRZxkd0a+XII8e+ACD+cO2VcsRgUh8Wujf82OeQTyS6hUqFBQ8YW1tZLqLjVwfInkfL/KiYlAhqfLFn0fxqt5JVxFiH3k/VKXQTctH/K5TWw+uYYCltZyMQ+DRVU3LJrn3MI70WXa8Yyf1EAOabgh1mBM51C7NQqBBY6+aMmE06R/QnB+YqV9Y+2cu41lsUVwSALW0DYgOIdyEW15zN3J4LeyKije3WznBrCe4z5GXTiAKfFNr7nnuQMi1tcRMBxTPa2PW2HnD2MkeezvNq1UeH5aZGbx4re/fhHCDjtluIn14NMZv0WZ3
 80JkcaX8
 Uitq6kI/oqguHNjaLxjOnKQWthlWBpL4jNwlwJwizwdxl1LAKlzE04fr68dT/lyVRuKI9czg+Vn9TO6qG7XqWDNZrV/UBGS5M9vZYIvavF7spfyp+vFmNJj6SNGIKmNPxpQxcbXxXDuHYrMRGYMHolMxD3ym8hh2+nyl7MIVFzIjF2Y01vznjYP7ukKKdetB5dwCAO8/Kf4RkR2L8qNzPANfLj6Swh9ZqdoljVq3gUCIoQhgLA/G7Xy7qAA4JOQU4Qw9/4LwGA/94cYw9aIsNEA4BjH45mW0TTXjYrlPYYltuSMa/oYi3dVn3Jsf7KMAfMdaV/wByo6T8j9Pid8kXHp7jymwlvud8TU+aNxG2W3bHqSAfUuN5WPRIHbrDtxP8JoTP/BoQ4b53k23X8PvQGCsSUAucJ5mwkXLQw7ikTJTBP5sO87r2cDskTjZPESXxRW9x/mhhGYziHSm6YB0tLTVjzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Enhance the hmm test driver (lib/test_hmm) with migrate on fault case.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 lib/test_hmm.c                         | 99 ++++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    | 19 ++---
 tools/testing/selftests/mm/hmm-tests.c | 54 ++++++++++++++
 3 files changed, 163 insertions(+), 9 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 1a3e21325cf2..645a0ff49069 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -36,6 +36,7 @@
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
 #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
 #define DEVMEM_CHUNKS_RESERVE		16
+#define PFNS_ARRAY_SIZE			64
 
 /*
  * For device_private pages, dpage is just a dummy struct page
@@ -1258,6 +1259,100 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	return ret;
 }
 
+static int do_fault_and_migrate(struct dmirror *dmirror, struct hmm_range *range)
+{
+	struct migrate_vma *migrate = range->migrate;
+	int ret;
+
+	mmap_read_lock(dmirror->notifier.mm);
+
+	/* Fault-in pages for migration and update device page table */
+	ret = dmirror_range_fault(dmirror, range);
+
+	pr_debug("Migrating from sys mem to device mem\n");
+	migrate_hmm_range_setup(range);
+
+	dmirror_migrate_alloc_and_copy(migrate, dmirror);
+	migrate_vma_pages(migrate);
+	dmirror_migrate_finalize_and_map(migrate, dmirror);
+	migrate_vma_finalize(migrate);
+
+	mmap_read_unlock(dmirror->notifier.mm);
+	return ret;
+}
+
+static int dmirror_fault_and_migrate_to_device(struct dmirror *dmirror,
+					       struct hmm_dmirror_cmd *cmd)
+{
+	unsigned long start, size, end, next;
+	unsigned long src_pfns[PFNS_ARRAY_SIZE] = { 0 };
+	unsigned long dst_pfns[PFNS_ARRAY_SIZE] = { 0 };
+	struct migrate_vma migrate = { 0 };
+	struct hmm_range range = { 0 };
+	struct dmirror_bounce bounce;
+	int ret = 0;
+
+	/* Whole range */
+	start = cmd->addr;
+	size = cmd->npages << PAGE_SHIFT;
+	end = start + size;
+
+	if (!mmget_not_zero(dmirror->notifier.mm)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	migrate.pgmap_owner = dmirror->mdevice;
+	migrate.src = src_pfns;
+	migrate.dst = dst_pfns;
+	migrate.flags = MIGRATE_VMA_SELECT_SYSTEM;
+
+	range.migrate = &migrate;
+	range.hmm_pfns = src_pfns;
+	range.pfn_flags_mask = 0;
+	range.default_flags = HMM_PFN_REQ_FAULT | HMM_PFN_REQ_MIGRATE;
+	range.dev_private_owner = dmirror->mdevice;
+	range.notifier = &dmirror->notifier;
+
+	for (next = start; next < end; next = range.end) {
+		range.start = next;
+		range.end = min(end, next + (PFNS_ARRAY_SIZE << PAGE_SHIFT));
+
+		pr_debug("Fault and migrate range start:%#lx end:%#lx\n",
+			 range.start, range.end);
+
+		ret = do_fault_and_migrate(dmirror, &range);
+		if (ret)
+			goto out_mmput;
+	}
+
+	/*
+	 * Return the migrated data for verification.
+	 * Only for pages in device zone
+	 */
+	ret = dmirror_bounce_init(&bounce, start, size);
+	if (ret)
+		goto out_mmput;
+
+	mutex_lock(&dmirror->mutex);
+	ret = dmirror_do_read(dmirror, start, end, &bounce);
+	mutex_unlock(&dmirror->mutex);
+	if (ret == 0) {
+		ret = copy_to_user(u64_to_user_ptr(cmd->ptr), bounce.ptr, bounce.size);
+		if (ret)
+			ret = -EFAULT;
+	}
+
+	cmd->cpages = bounce.cpages;
+	dmirror_bounce_fini(&bounce);
+
+
+out_mmput:
+	mmput(dmirror->notifier.mm);
+out:
+	return ret;
+}
+
 static void dmirror_mkentry(struct dmirror *dmirror, struct hmm_range *range,
 			    unsigned char *perm, unsigned long entry)
 {
@@ -1524,6 +1619,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		ret = dmirror_migrate_to_device(dmirror, &cmd);
 		break;
 
+	case HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV:
+		ret = dmirror_fault_and_migrate_to_device(dmirror, &cmd);
+		break;
+
 	case HMM_DMIRROR_MIGRATE_TO_SYS:
 		ret = dmirror_migrate_to_system(dmirror, &cmd);
 		break;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index f94c6d457338..0b6e7a419e36 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -29,15 +29,16 @@ struct hmm_dmirror_cmd {
 };
 
 /* Expose the address space of the calling process through hmm device file */
-#define HMM_DMIRROR_READ		_IOWR('H', 0x00, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_WRITE		_IOWR('H', 0x01, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_MIGRATE_TO_DEV	_IOWR('H', 0x02, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_MIGRATE_TO_SYS	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x05, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_FLAGS		_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ			_IOWR('H', 0x00, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_WRITE			_IOWR('H', 0x01, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_DEV		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_SYS		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_SNAPSHOT			_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE			_IOWR('H', 0x06, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_RELEASE			_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_FLAGS			_IOWR('H', 0x09, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 788689497e92..6a6b1069fb5e 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -278,6 +278,13 @@ static int hmm_migrate_sys_to_dev(int fd,
 	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_DEV, buffer, npages);
 }
 
+static int hmm_migrate_on_fault_sys_to_dev(int fd,
+					   struct hmm_buffer *buffer,
+					   unsigned long npages)
+{
+	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV, buffer, npages);
+}
+
 static int hmm_migrate_dev_to_sys(int fd,
 				   struct hmm_buffer *buffer,
 				   unsigned long npages)
@@ -985,6 +992,53 @@ TEST_F(hmm, migrate)
 	hmm_buffer_free(buffer);
 }
 
+
+/*
+ * Fault and migrate anonymous memory to device private memory.
+ */
+TEST_F(hmm, migrate_on_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int ret;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Fault and migrate memory to device. */
+	ret = hmm_migrate_on_fault_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+}
+
 /*
  * Migrate anonymous memory to device private memory and fault some of it back
  * to system memory, then try migrating the resulting mix of system and device
-- 
2.50.0


