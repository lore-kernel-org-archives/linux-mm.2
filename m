Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12596C61DC7
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676746B00EC; Wed, 26 Aug 2026 05:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627046B00ED; Wed, 26 Aug 2026 05:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C616B00EE; Wed, 26 Aug 2026 05:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE4B6B00EC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2B2A802CB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:30 +0000 (UTC)
X-FDA: 85142887620.12.BDF1692
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7437280007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="i/qQKHNz";
	spf=pass (imf30.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y759v80hfcLGexoE6U+P0qCW895e0rqrtykfndhs3p4=;
	b=Nr7Ib8F12KMIsagFW92Qy6MMQgODEFf7pWJgDRtz7vnpWuXep0oifByb0UuTPo9j2Hy/RB
	1SqIFsoKjw5Tu5M86E/I9yKDXyGq3oSt/LD0vGoKhl19INFPWz9UD9E5Y6jCamKfFOhvDk
	XN9p4Vv/PvpsjqCuqYBa+tCg+icHGB0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="i/qQKHNz";
	spf=pass (imf30.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736328;
	b=cKN2vhvFYKti/j7M5FMI6Dgz0vV8PpUSkpimZwBt8iAlKIl6FN0BF8H6n2dbZn758fQEe5
	zp4INRkLjLjXfD5YYXyYXE2d5Z15xH7a+i7/ev3PhIq4ztyvBMaksjPcGLZm1+NOBuGB8D
	8dRJCvsu/iFB2Tn/784oRY6+Knp5e3U=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=y759v80hfcLGexoE6U+P0qCW895e0rqrtykfndhs3p4=;
	b=i/qQKHNz8OxKmJLSE6ETOW3Vyzml5TlfhhQAVfoBCgLl3ppxbzz6ZfYvrUMLwW7wzTAHquxJ5
	7xkkPqtSSJUuN3dgmG4MYGSJZEltvqtaf1bLmuJ2Nfz2lINRwFVWYySZIoIptnPTMwZvuSdXvB9
	ZX7arRtCRna8ymHdQexhtqQ=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrJ0mhvzLlXB;
	Wed, 26 Aug 2026 17:14:40 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id B445D4058A;
	Wed, 26 Aug 2026 17:25:25 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:23 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<thuth@redhat.com>, <gshan@redhat.com>, <jic23@kernel.org>,
	<james.morse@arm.com>, <ardb@kernel.org>, <leitao@debian.org>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 07/17] crash_dump: Fix potential double-free of keys_header
Date: Wed, 26 Aug 2026 17:25:31 +0800
Message-ID: <20260826092541.3905933-8-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: xfezq13i9sjixf9qrpe4ybgzuqyipi8t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7437280007
X-Rspam-User: 
X-HE-Tag: 1787736328-394495
X-HE-Meta: U2FsdGVkX19vdRIgEb/PLoV1ltzcK8q6n1/sZIGs0X+QTkTKBT9LE5urk13O259qFPYLMLIpjuYaljjfIBGT6z8E5w6G8vesp7oxJf6yyA8Kq2f3M4XnN+Xpa9b41rbVji2kF4/K/FUuLbpeuv6XQoZCWkCM5Y4FzPSxdw+dRQXXn/oh7NAfa5AneFnOJsLDLVVCea/6CCF+uDf9y8lKNPgXZHjJ4DdI6ufJgiumb2vXiA6r1yoNfvWZcah9jhgtlRfvfrse8AfZhgeA9c4okiMPEMCGkBuHpH/K77dvhHo45Y4e/QDIlPaqY0cHdSbgPwezu+XS936GAmXFTHbKITJX/DJOyEcSgSehc1OUg5MKWv5Dyy5l5bNs09kmeaSuah1l1JXnEbPzSatvAqlRgfm+9vpxUqzMkhPRuEHgwkR5MN3m+EFA5RjPHhbGwwaaYxBECQf0roDLNQVTtfAMvVXG3/+rrIxXiA0Lbe8l31Hy8Rc/iGqG9s7/ml5o0sjCoAILz1IAKHeRqgMqC0l8KyYCGuiMgaGCez4v9zLbIGc5X+7BCeeHeVIpsufWiQlRXEXRhz4y8DewygriGAZYVPjQ+wl+MQ9U0ALk4FbaX4ZICm7RBkajppEzLDfrTgHIs0T4AAlZEFkQL9nvpGg2gfL6s1/2KjhxvTLi59+CkMpa4dYEc0eR/2vS3Iy2vQBN8K5iqxEFqM+Ufwr8j2SGZigPyRmoaTE5/myc/iIu1XukGGQSQFeDcijM2j3JIZpVO/nlH5bz2g8k7tZlL5j1QqN96mGM+1QCxayFAchrA3Mk4aG7nEEnhO5QSF9KWlb61YaICvAZtW8AUthv4U1laQaQykNKuUO5ysHlizpfZvqNgsVk6ClQY6YWBd772VE8rn5l6ovdKxxGQyDYLw4hKiLdC4Isa8k5bllNcxd0obYtJqJjRV/iUofbRhMLfyrdQ1CzH3iIB5p2RGuAqQ8
 Dp1P0lgq
 U8EKFvlW8Ew6/8n4/kEv8vPuO0QBGp2mV86bJOGpk0tWfb2hwjF5QXPjNFnHNBK8I/ssW4QzFePN/axfOZ9/0DQ8947QAdn+8fQ/3nyJKzSuxyOdIIOJbCwqLQ6sgpwTe2sHGaj1/vmqRDmtAYLnOnTUU1QSIY+YBtDfasCvSVtzaCt5Jn3Z7ocWwKlR3fGjVcvHczEJaiyb7JhvPJwIoqno1tGDrzOnkECMzH+BlJnvy4sWIV6KdYvcQpkvl5a5KRkDiazeYdb9MWYUoDx7kS+dpvVBupOVL85H5kglOFCGb5COLd7XTVuPpDT2lb4icIr+VqGJbGNa6AqDkDIbc57N3d+wJTYq8RTz/v9orlkork2bNopswMBUfmE7lkI+1ZeNFC2MUtiOLuzzoqo4s15ErxGKSKvy8V3ijCCHhEPrk9CJcS/d4uvDhsVhccGkfsxho80p4NOZyhZufNkuAhO9zxXImXtrw+iNZRhve8z1xAAnGhZrJCGo0sNogD2Sr+li9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`keys_header` was freed in `build_keys_header()` without being reset
to NULL, and the error path in `crash_load_dm_crypt_keys()` freed it
unconditionally even when reused, leading to double-free or
use-after-free.

Add `free_keys_header()` to centralize freeing and NULL-setting.
Use it in `build_keys_header()` and only free in the error path when
the header was newly built (`!is_dm_key_reused`).

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: stable@vger.kernel.org
Fixes: e3a84be1ec2f ("arm64,ppc64le/kdump: pass dm-crypt keys to kdump kernel")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 kernel/crash_dump_dm_crypt.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/crash_dump_dm_crypt.c b/kernel/crash_dump_dm_crypt.c
index c685497cd470..ed0960ff0987 100644
--- a/kernel/crash_dump_dm_crypt.c
+++ b/kernel/crash_dump_dm_crypt.c
@@ -363,15 +363,21 @@ static struct configfs_subsystem config_keys_subsys = {
 	},
 };
 
+static void free_keys_header(void)
+{
+	if (keys_header) {
+		kvfree(keys_header);
+		keys_header = NULL;
+	}
+}
+
 static int build_keys_header(void)
 {
 	struct config_item *item = NULL;
 	struct config_key *key;
 	int i, r;
 
-	if (keys_header != NULL)
-		kvfree(keys_header);
-
+	free_keys_header();
 	keys_header = kzalloc(get_keys_header_size(key_count), GFP_KERNEL);
 	if (!keys_header)
 		return -ENOMEM;
@@ -441,7 +447,8 @@ int crash_load_dm_crypt_keys(struct kimage *image)
 	r = kexec_add_buffer(&kbuf);
 	if (r) {
 		pr_err("Failed to call kexec_add_buffer, ret=%d\n", r);
-		kvfree((void *)kbuf.buffer);
+		if (!is_dm_key_reused)
+			free_keys_header();
 		return r;
 	}
 	image->dm_crypt_keys_addr = kbuf.mem;
-- 
2.34.1


