Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4952CCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F608E002C; Mon, 13 Oct 2025 05:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17438E0007; Mon, 13 Oct 2025 05:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CCA8E002C; Mon, 13 Oct 2025 05:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7F18E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:56:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42BD91DFCB2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:56:50 +0000 (UTC)
X-FDA: 83992636980.14.3964327
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf23.hostedemail.com (Postfix) with ESMTP id 864D0140003
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:56:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760349408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Jgt1qsOx5yttmdnKF6IeTb4mORWO4/qWaKH5/7C1Opg=;
	b=cDxrCOFc7zcZNHrnPcCgKITSPQJsMZ1ZO9X7SV1t7UPLyHYQ71PWW0Gp8lx6E4dQ1vBvTd
	c4+blQrb6nsmgYVagq3PD+Ui5wqglf6dFfKO7BjX7Cvpo4v+aHdOaTw+HWzouNoezjM3di
	Pvh2kxZpo+eurwwN9a2XK/tGlUiSJ/k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760349408; a=rsa-sha256;
	cv=none;
	b=vt6H7bE4aUE1CWjCZYXEcD75SB9qMa8SHkPZ4GgdKIQqV8N1C0z9YSIfx/twU6GuU++nNi
	+Z3E1/cy0fv68e4kpEgNVViZ5yc3/37tuu8hhKKSj9KGafdu+dOfc/ldrPvt4TV/PKvM1Q
	A8asOXbIrZfkZ6agh7LXtZ1qAE9wZT4=
Received: from loongson.cn (unknown [223.64.68.198])
	by gateway (Coremail) with SMTP id _____8Axz7_bzOxob4sVAA--.44278S3;
	Mon, 13 Oct 2025 17:56:43 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.68.198])
	by front1 (Coremail) with SMTP id qMiowJDxcMLMzOxoloDdAA--.63721S2;
	Mon, 13 Oct 2025 17:56:42 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH] mm: Remove the BOUNCE config option
Date: Mon, 13 Oct 2025 17:56:20 +0800
Message-ID: <20251013095620.1111061-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxcMLMzOxoloDdAA--.63721S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj9xXoWrurW3XFy7uFy7WFyrZF1rKrX_yoWfGwb_Ga
	4v9F18G3W5ArW7C3ZI9rs5Aw4Dt3W8Wa4xK3W8tr4fX342q3Zagw17tFWrZF17Ca4DWrnx
	Z3y0vryjyryvyosvyTuYvTs0mTUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbzAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F4
	0EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_
	Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzZ2-UUUUU
X-Stat-Signature: oyzoiasyao4jkw99h86xck13k7ybsukd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 864D0140003
X-HE-Tag: 1760349407-80148
X-HE-Meta: U2FsdGVkX19Oe1SaC0Nwtyeb5KREAm7i05TN3L2/RRlNkpWpftEdD3ZHNp7Cpza7SsLFIAp9ayyDUHS3LDHywKkWRhxfAFdBVrLMC7aj7jJ7yGKXxfI6hj0TBFbQKjbi9PHKugA1zMtXWNKSJwwQkiwZ8HPCDnetPp+MiI5InEpBvs3EnCLrtjnPpPi5JOqSr4i/Ll3gafmvDT3Y8JD1qKBQnrOR56+z16Wo1QAb5L6H/k4A9AIrZnePiy870EasQKxYvMQAqar3xmu5QZtbKqIZMD2VwA1tEFWtoPn+yphdDLMCEYp/sLr6860S8wSeHOM05y1hP0+FE7uCGt59dvDOeCo9Jpcu2Fg200wrsJYDMwK8yaF53uzDLU/6Ink3v/3Ou5OiQEXpI721B7gu1C9Z9PZGi9uDVBtrUG0e9Orf+pmtaZXk4qhmMQZJw4QQMqTDOse2OQXF8/osYdM0md72VeCZ9yJI+0BHG/vbVPxBaTNXpItfI+K0Asw+lpsQ66ycNcv/1bhspIWz9FzR/slybjKh4GO9tz+gQs2AbenTuTcgjRigTYuH/o9xdskaYogTmrd5Y1cSf015dHbvbbWmcf/p6jQ8kluxB0cVuLnlYHnQjCnFgk+o99rjExE7FgcOSsPyX8rNYnr7hZ8jC4PygRSu/4dU+Wm47+UmqHVwbadc4mAMS+l+KSKLohtHPgbIpJ5TNlydsVaizaev5MCE+oNSxLNp3paX135oJFvhxC4c+ifiu8oRP2fXHQlTrYXONedM3eNbOHjoJ+vKAz02K3v1rx900lhirTddIn/B9cJPJ0mip+VhBWOl+ZPviiat6ifNNuxjsy1FbnmlxTBhsn5ctymnK+zNz0POopbCFlJGT4Vq8wBgTbeWbfi7YZc8Y7Lodw67/HfQBTuq09dt/GY3/o7R8IDXi6NVC3TowUcgUoX5OzM+cBPLwysRvkrDhi/bmIoxV7SlkJQ
 29g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit eeadd68e2a5f6bfe0bf10 ("block: remove bounce buffering support")
remove block/bounce.c but left the BOUNCE config option. Now this option
has no users, so remove it.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 mm/Kconfig | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 0e26f4fc8717..e47321051d76 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -695,15 +695,6 @@ config PCP_BATCH_SCALE_MAX
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT
 
-config BOUNCE
-	bool "Enable bounce buffers"
-	default y
-	depends on BLOCK && MMU && HIGHMEM
-	help
-	  Enable bounce buffers for devices that cannot access the full range of
-	  memory available to the CPU. Enabled by default when HIGHMEM is
-	  selected, but you may say n to override this.
-
 config MMU_NOTIFIER
 	bool
 	select INTERVAL_TREE
-- 
2.47.3


