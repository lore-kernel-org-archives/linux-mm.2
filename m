Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215A7606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XNlhvh4v
Received: by kanga.kvack.org (Postfix)
	id 4161A6B00EF; Wed, 11 Nov 2026 08:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6FE6B05B0; Wed, 11 Nov 2026 08:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B70D6B05B1; Wed, 11 Nov 2026 08:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F06D16B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:02:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 792D5802D1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:02:06 +0000 (UTC)
X-FDA: 85422851052.21.0673F17
Received: from mail-dl2-f7.google.com (mail-dl2-f7.google.com [74.125.229.135])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9DE0240019
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:02:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XNlhvh4v;
	spf=pass (imf11.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.135 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794402124;
	b=ExDNmUGFBhufNSsoU4QZNv+MAdisebrrNkKGAUyY1+JddY1l8uuU5bBnztlE+Gtp3JbsCt
	ig84zIjEJuF9ZtSL7eCyjx5BQhv6dzeoiAQp529GmreOAfWDw1fcgfBGU7sQza7udNaPZb
	uzZZd9lbRMEH3vOMO0GGbHeZwRO6hlM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XNlhvh4v;
	spf=pass (imf11.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.135 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794402124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w2/+xHZKQ2U7spoWRX9s3/PlBR0bd8B1wNdFaiAbagI=;
	b=UGs12lIP9SC8091yQlN+DFRkd6PmTQUilmO6/1+V5spCRY44ecZ0eyjkVOI4+6xI8li9Ij
	btXJvRt/ONAAh4NratBIaII/W/OxlXOyEIxe0fssK9BbTbnmIg09EE4okteWc8EG4aThku
	MMkoIB8wTyyFTAfbGcz/dNIxSDEJUFE=
Received: by mail-dl2-f7.google.com with SMTP id a92af1059eb24-13985f8229aso2850808c88.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794402123; x=1795006923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w2/+xHZKQ2U7spoWRX9s3/PlBR0bd8B1wNdFaiAbagI=;
        b=XNlhvh4vbirUaN03tNU5t4p7J5wKv7RJLOsVUTNHOFbFCY0u6E96y7XmSOomoOfFaf
         eFYQlVc25MDfbGLYetldkyKrSd8mn7L+/IecM5+y/1yP9cwkVurg01UNtbYuz0eYEaj7
         S/E1NorUOpBqETthYZhYv021nx0C13U6fQzxzsytdmZF8KGCkcjUyceUohIY6ofmzBKu
         mujT0NOWCasuBBQwqWDILPg4gYj/YskL4ewpxVR3HnIsn3FYy3I4bljRgewXa7xhw2AL
         ehuHq9NUg6jM9mvacQaEOS8lJ8hO9O7vIGU97f81S3BeJjnvy+PhkyVAOpeke1EFrRPv
         4vMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794402123; x=1795006923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w2/+xHZKQ2U7spoWRX9s3/PlBR0bd8B1wNdFaiAbagI=;
        b=OU5HRWNax9WYtb2F1FEDEuVcYyegdk14RzShiY7CJ65oPKS47rcKuEkGatEWgYkPhN
         8DL36MocR+7inHez52DrYmDA6FuJLqHnUIlTFHrg+5T8EkllXhns4lfr5H+MyrfQJNnN
         yXtoFWSJb8o4QRmVo0Qi07IBIVpA+VYKxE8IDYDl909rKY6TjbJkMOYbYfRr4d61c+kn
         D9tRA7QbF6F+3iszFYVmKQ5OxY9T4TjgvxYdjRgrNO2x71PySkgvt8OV8OVAK4VyAmmo
         D19wI9S2GPBP7Isg8ekT+n4+e4HyVhCDbFH2+4tDUlE2R+d7cfaUc2ROctg2UX6NK4+K
         JkLA==
X-Forwarded-Encrypted: i=1; AL+hErGBiWMRe+Bou9nOfW4WvZWBiSlw6ojr56irSlqeTZxMLLNizooyCv1h98EhssSQfDXW96MuCcETsQ==@kvack.org
X-Gm-Message-State: APuU4Z/Kmr6IKdgxHRdH00fq4Uqhr0y2HBeBAKTE503V8MLaDK2ajjO+
	pLxQ/ngVrhhjU4KCai5PdfkxuA2NjJwvMSHeM28ygu9Cn11fL7KC51hI
X-Gm-Gg: AYBFou0bzLE1dK4jcUmBh/5nMW8Ik0WrvN+9lewkvvxtDdcmJYsb24Moih8XKcIRGr8
	j5a9pXpLY/4mX/DmGR1VU4uDU+KSorjWJsnK8M5Z4YVKABgUZnVmBU87Ke9OafkvCmUWwbKFZuH
	sHrc82uCowRVpYv1WPcfTLok/BHTDlPa/6wOBpX9o0ZFT5JIKI1pXVnqPxz+wY8B/ouKpcwOPwp
	borRz7l7ahiejOSDiREvuDgvmGpTRrgUZQePktLZkHbEueswfxekBR+L6O+WkZvLcfbH50nuGCk
	R7IBYFGiba6ockccyLbc57qbrWrAEtTxQ8sniUqj0skVbxIwqcvhi9gmfWmprijW+Spl0KY0Tft
	qQnZQW3QjPLZ1C1xYJC5PlnBGBZUAkkpfWcJn5rXXqXNUl3tk0Qa07rSzkVF1Nu2v1L+br+lN+5
	8w+sFJar1R9VnTKHzWcy9PgC5PnOTLH51w5MmQZ8QqhQVakwalOcLJRbB47/cZ0P+i/qw5OabIq
	dQ7qvhnk4BvPydz7LD2jizmKa+YMvjhCsxXGPAqWwPqLD+PyvkSuRiGoCEgyHv6T3DXoVdDV3hW
	ksJJzmDuPlcPoMOIxN/poRp0YWs8cL2cT/lPGJXzDuNUccJGWFPSxAyyJEJ5ekBnPofJCDPd7Vj
	HnZtVaJNwKPGj22n2PGxXp+trs1yMTGCEiXWXGg==
X-Received: by 2002:a05:701b:450b:20b0:1b3:ba92:145a with SMTP id a92af1059eb24-1b3c0303655mr2388509c88.19.1794402122900;
        Wed, 11 Nov 2026 05:02:02 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b11150sm21696634c88.5.2026.11.11.05.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 05:02:02 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: muchun.song@linux.dev
Cc: osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jm5905938@gmail.com,
	dennylin0707@gmail.com
Subject: [PATCH v2] hugetlbfs: report inode limits without a memory subpool
Date: Wed, 11 Nov 2026 13:01:45 +0000
Message-ID: <20261111130145.96534-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9DE0240019
X-Stat-Signature: yubq5cosfn471dfmohabdcmi9bgtz73h
X-Rspam-User: 
X-HE-Tag: 1794402124-353953
X-HE-Meta: U2FsdGVkX19+/w2PUJxCnaJVNMu2GNqeB5yKig9jybYQFbNeXhrqQcZNdk4Az357Kj8bBzoUbIZvmx5Sa2P6jS22/Kv24T92JI5l1sGI6aRKEPozOHRPR0jXqLcbL2Wiqy55cU5Xps33v/QUH51GHKfYBP7wkHCn6kPFrtEmxIOSJDhKt6XDNxqQWI62pEA2Le65YeiqEH1abbd5nOKvcV2FfEDRNqI+QRQ32lvSD++Very4+Lyoi9kWYCx7yDhR6wIJfWA9hu01M6IjumjmT9zPHUQ5zheYl3M2d/Y/cZVFKRyzpBezyQdF2NEdYSufe+ID7YIMhjYVMBN2eB7htZwLpPWRW4rBJAUyRzZdU4NhGwKPCa7tYTmuvT4Clou8u1C9yDSPUxhZvFh2nnnTol4sj2liZNyZXlJ+bpTLtvd3auQswrA5J8CreRPLO2rsEbJAcoX9IXEP/5d137EETUDN/BOT1rxykbCdiao/UUsJr1+CNdiW7uMGo0pzeIjaOEjP/oNAg1TTtZ4i4gEi4n6yPWKXyU5Qksf2qjwWzQnPbMI46Hl0176Ck12m8mJZS5QdvQCZSIik+eKjIBEpCTrH66VfwcHPdQfOxMi6grubN6a6Ji9eb5oTwCFKTfej7j/YqQ7Uc+Aucz9j8nBac2OW/wHu1INxudXvCda3b/DF2pgDRQEf3JCZCbgHHdWSlX2M9F9qyDFLpSMO8CNd2Jdm4Zt4UmKxHomnLWdJg1/1UhOpKmWX1Nd26JnnI+7qiBgXa6tZ98GeJHfAmTIs5PaSfKt4e5f1nOIBONxEQpG+8QfchcDkTmY6VvjEXGBSTUxfVUmFwyIk3CuyssdpG+ZEVqq2/msQF+CRK8Vgv1cfS6dT4Scc72QRp5YOJJWlN9njeJVkNntjbxFqAL9FbYrfPPzc3tEyMN1PufuwiM+pv1kqOP4vwYOtANv+Xcb4PqV4m7n3atmIApIEQge
 WAC7xxbB
 TIloravioovjJuKkX8J+jdjVKKPNLDRxItOU3qTDNZ1LBVlYRqJWi1P8Ttuq7USnWBhjUljqm8cP5L4jc9awodAAGCHPFUEzIvPgQAeSs+2uimjv64C6TksJrIe99Pi7w/VvKV8R0EFKnLJV12IbHiFZBE4/ukeN9fyS46Y8RFiVZTxdYx3nENuyG7Pnn4LyWGS6+bjNtF10dtg2OjRwXNjSRawSWhZTHrAbUfRhxnKX1dxSt4RzDdOaLg10xw3Qk3GvfKPsC1+PsbW5JHgf47BeSMLvQtINmQxIkJL8k2Ye61CiSsbbQ4qJ84cYoLENac8gDJe1iBEKkW1QcIucAHABNbm77x4xqtojny9NqlBz6PU/22+g56Ez34KqZPSzVu6qsNBKBoXbSucYtotspuCu4sLUlumEcNAi6qMnCJj9PGpVufjXsrP0OSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A hugetlbfs mount can limit inodes with nr_inodes independently of size
or min_size. hugetlbfs_statfs() only fills f_files and f_ffree when a
memory subpool exists, so an inode-only limit is enforced but its inode
counts are reported as zero.

For example, a fresh mount with nr_inodes=4 reports zero total and free
inodes instead of 4 and 3. This hides the inode limit from tools such
as df -i, even when creating another file fails with ENOSPC.

Report the inode counters when an inode limit is configured,
independently of the memory subpool. Preserve the existing zero and -1
results for unlimited inode counts.

Fixes: 74a8a65c5261 ("[PATCH] Fix hugetlbfs_statfs() reporting of block limits")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>
---
Changes in v2:
- Add Aveline Noir's Reviewed-by and Tested-by.

v1: https://lore.kernel.org/r/20261101122653.53982-1-dennylin0707@gmail.com

 fs/hugetlbfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 01c4d6f44ebe..e94ee8e17004 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1113,6 +1113,8 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 				- sbinfo->spool->used_hpages;
 			buf->f_bavail = buf->f_bfree = free_pages;
 			spin_unlock_irq(&sbinfo->spool->lock);
+		}
+		if (sbinfo->spool || sbinfo->max_inodes >= 0) {
 			buf->f_files = sbinfo->max_inodes;
 			buf->f_ffree = sbinfo->free_inodes;
 		}
-- 
2.43.0


