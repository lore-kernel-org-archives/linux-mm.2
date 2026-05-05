Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1772ECD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 18:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB8C6B00A4; Tue,  5 May 2026 14:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7455D6B00A5; Tue,  5 May 2026 14:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60CF96B00A6; Tue,  5 May 2026 14:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1C26B00A4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:45:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1BD712067A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:45:14 +0000 (UTC)
X-FDA: 84734243748.21.870CF49
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 83356140019
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:45:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Id75JsiT;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778006712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLjY4/J5JL85E68r0ps9b0tREEnQO9bxlLysLhOu6aU=;
	b=W8aJrOFgl3IOiylGSN1fRZiXXQFmDQzxiHyinNBQEJPZguCT1z43efdZiRGvUIdtQVugDH
	3uJB5c0XetUU5NZhYliwz3ENZxAwt5YVB6yWq/2i1qQvZL2/zkPCmGeYW31OHuKiUFO7Cw
	BH5VUKTf14geYIl4rWtBH+qW/sjOnWc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Id75JsiT;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778006712; a=rsa-sha256;
	cv=none;
	b=F6aOZkkbi2fzHyzhB0ZMIfrj7J6Ww1l8QSg6Cgp1YmkazwXoUWNS4oON/zrOHH2M6kSMv2
	VQ2WFtD/gf/vDfnHbuUXN2dD51Jg/j7fi1+1RVfDZtZQK+Bhq39XuFI36vqhPzjAGhYQ30
	6Naz9alNWcxheBf7ikXdWUzJbiitD0g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778006711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vLjY4/J5JL85E68r0ps9b0tREEnQO9bxlLysLhOu6aU=;
	b=Id75JsiT3dkepdPY3ZZ4dDkaRatqSjVviqL2Evg3GSDgmcTglc7pOviUzYRluFctU6lm0y
	8ehfcWCMYiJDzkKJu/rCauOczZWHXbqcJReeCv0Ux9US+vqcPC8uzChaP0dXquHTt87Q/7
	34PhYXeluxzfYxiPkIzHuutpPSdu0so=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-semFoiNqOKSr57_m0CAJGA-1; Tue, 05 May 2026 14:45:05 -0400
X-MC-Unique: semFoiNqOKSr57_m0CAJGA-1
X-Mimecast-MFC-AGG-ID: semFoiNqOKSr57_m0CAJGA_1778006704
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a886a993feso125340e87.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 11:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778006703; x=1778611503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vLjY4/J5JL85E68r0ps9b0tREEnQO9bxlLysLhOu6aU=;
        b=C080RXWRYf7TvgjXG2EKGwDzXsVBOSf1d21UKme0Vo3xHhwFd5CpK6H0Wsc6z/QuhB
         XwgnjSlQGEYq/R58o+sR79nBd/rlxBDkOW8jagraR3FNas0xznscghU+TibwLbE2ZHKF
         7rqfPN3tS0yVvcdm8z6kCNpN4bFTu9QE8YlqzUcLkPoTuxCdZmDxwVZrJP3BPD5YOPjb
         Zffxuv7hGCnbeTOK387+obCLgCrt7J/Tfz46FrTxKob4YWmSOLMD90XmNQgx3llfEKVE
         w94SId9AtkfJW+lT966dBGDQJDocu/FqhmCTKT6/tGh2ebeyLY3k15Ybjv4ipPUPBTN2
         tN1w==
X-Gm-Message-State: AOJu0Yzwc//dd48SQcvnnDedh/gt5lah9P8C9w1iIJT/bcPxtmwWU8g/
	FjWfTGCS3ygzt7GcyVTzurbtpGVJW7JLABK7j0FzbtmuQ3JnliUdR+UK8tsh+VvjrlqPHrqjm79
	OLZF9hrgnvTcDrESDWz+J0CNss1vuCEIRiOyjzI2vCQxTiYssMy0UFJZVQjv4RKt9WiSjPR7meD
	pPlrJ7qp/27O+JLyNBVQvZI2L1VoXmxvly5cC0Cw==
X-Gm-Gg: AeBDieu1Swj7Kx/dRrgBJxDADFohyEgdHW4Jns8RMLzkVCICCdFse4c+2UlT7BwBWce
	jaoXZqa4iuIxrvpOd3qaB0xpCfUlkTvl2QLk/tcmH8iHsFieR4anF9yaQTimwkcQ5BmGDSazWTn
	gxcyakWF26/tvO/t18Axt2UygrjjWmCA4y+F9W2nfg/LuxPzoDMlUrLZaAQwQsscNgYaSpt7PuM
	tPwe4frhhiTJA0wrZbtp/8q0O4GxEZT6zfqJmxgZOZeDUkub/g1W0VLi64vK/c7ttC+G8WVDn10
	5bGrmUSgteB5yExJ45n7V6g94li/5l/D+63Q+CrinDv2PRdwmphif+3RIzWj9JdYpVqPDyCxxCh
	8Uja+jPutoI1lXVHW7SQRBS+Tzu5MIfIouo+xIF+u7OVW+6I=
X-Received: by 2002:a05:6512:70:b0:5a8:65c8:dd87 with SMTP id 2adb3069b0e04-5a865c8df80mr3535903e87.3.1778006702826;
        Tue, 05 May 2026 11:45:02 -0700 (PDT)
X-Received: by 2002:a05:6512:70:b0:5a8:65c8:dd87 with SMTP id 2adb3069b0e04-5a865c8df80mr3535878e87.3.1778006702209;
        Tue, 05 May 2026 11:45:02 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a86e65fdf6sm2504437e87.78.2026.05.05.11.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 11:45:01 -0700 (PDT)
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
Subject: [PATCH v10 5/5] lib/test_hmm:: add a new testcase for the migrate on fault
Date: Tue,  5 May 2026 21:44:21 +0300
Message-ID: <20260505184421.2324798-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260505184421.2324798-1-mpenttil@redhat.com>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YiUFuuj6E7PHG0anA1BbxPr2xOVRbzIWyMsbJx8GPu4_1778006704
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83356140019
X-Stat-Signature: qchz55s69u67gj781p8mz5hwwtj7c33w
X-HE-Tag: 1778006712-692067
X-HE-Meta: U2FsdGVkX19D8SOBd2kanvVAxBof4B1wkldogRCf0rae+E7iBEWEc4rA//9rFtgOElkCYXPYHS8HmZMOE5I7Giptrh4AHLT8zt21gse2uKKSgEZxfGKyKDgNEclyo6PHKHs+GySNfXVEzI7WwuD/wOzb2wl4dB0XUWpmwMbiDdSwy4HGUDshOCfp1WYT5Z7hQoEZiigDOjeEEMgvWOEpRjxaGm+IS89rzjeho0FG0OWzwDt971OofQ7f8V2ePmRb4OYvw0c5zb9mNpHUbHN6U/SaWKWqs9+v9zcpb2jdxlv1qkSjnDDScnvDKukZbjhJ0QOrowDbv1PsLa+pHizloIb/rE1sNLX0cKvrDntc80PPy4H97hr5ZSXyeMvE74//cbIA3eSBFft0fnFumxKIvfB3fP/RlNBudt2tI1bPmWZhwxgX12D0fjt/6mwA0cVGNTS38zxmBHDH/aAzhooyBxJaU3lW1zFArXNmogE9g3vULYzj0yBAfc373EkALO/F4NJrvqyTevGh5CCwMczYWqWwXPqtTaomQqlqiXOvPyy3+KyyddL0wy0fNTjDsRv2+fmZSsWQWJDIJsYkhzONqRx4F5xKZRGc/OcAppN2ITBa5IViv7wUfsAcmtaXdpImfvz80MMyoU+6v3EPFiL/LYz8hwRsWIYvqMu6WAE8IQP5KORFrHYRWydmXEDxsUMGrIZEraPK2i/DGE4k3XB8O3i++L11zbFmGRHkfi/Tmmhb0XFWsvCCsGj9e32zQa/kVG1ALubfb1v1FVrjCrCDUKF2r+ZFXbrrHXUAqZUNzQdp3nWwa1GytklGdJxq9NlTSVVwfhau7OGHVPxrpDMpZrYqFEJDm6n7g6cDfXHmIS2nS9zxUTOtUVPmrzVeJZafOkTxOw2IPm73+Kr0VRWkMi65FNedCuvQsZHcTETtCSDN8zbebssonq3pxxe2sdmfM9liVS9bOsAcF7GMdI+
 zBWCUUN/
 o+IL7YdoqjlAu4iJqoPzjM8O5feIVgaiN/mctNky9YdYrtEA4XJuSRuQW5CVCh3GJoKf+1DhpkBCtosrOzkvzSeFEl77JjGX7hNULSbTqz5yHeCZmHf12rZpueakhHg8+q2g+k1LCRWzuev5+Bjgt8gKCZtpz321tygylzfOgWHcdmEqrzvWMbRWXFS4QfJ9TdLE+RA6sN+JuRATc0GBPcDH6s0/AyN6nhczXQFPpzX8vtINpXw1Qyksj2Cv3VPuurAMkkGv88vF9TL2F0jr+KFT8Ue4JTq9pl9zZO3Mttm35laGTi7fk84uFNhZaoN3H0jqDG9fy6lquSP8ObNrUBLJYm7WSary1AxPcbbwJPnRtn9TsbtIuluXsRJ+1L7dtmaDMsWSRq6P2m66THD7NlAs9gQ0kkuspJRoZwEdcXwKFnPKojMkyhn2SUQzfh0soBNSVaXN837u0KuWWK91SJHbLkfZ7EmlkwT4SkiTPGpfp5m+v4axMoO3T9IyOh2/fcQ6lD5jc3O3VFGegZz3kz9x8N57H3jN32M3NSFQ74MhCQ0XyEwIg+N5to8ByQj3NUqV/xVA1Kq15T1Y7J2Cxlc9mOA==
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


