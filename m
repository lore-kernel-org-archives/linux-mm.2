Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC987CCD187
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFB18E0007; Sun, 12 Oct 2025 22:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80CB8E0002; Sun, 12 Oct 2025 22:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD4B8E0007; Sun, 12 Oct 2025 22:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AAB0C8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:19:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2079885E3C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:19:00 +0000 (UTC)
X-FDA: 83991483240.20.F10AE76
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1923240005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:18:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MAbYBAIQ;
	spf=pass (imf17.hostedemail.com: domain of jiapeng.chong@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=jiapeng.chong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760321938; a=rsa-sha256;
	cv=none;
	b=gX4Hp1akBDiVP0hgQSuYNUGYVDNMn++Mg7vaLgaE/C+xZDWjKXXFM9HZRGLThWloh007Uy
	pNmunkKz+eflBHuwqypaatoPY+8F9G++dxoAkBUg3O7PPaekTXaKWMnd0iA/q8Z4k2MziU
	9EA8rw3BNaY0HvEzFr1EFokdAU2KFVI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MAbYBAIQ;
	spf=pass (imf17.hostedemail.com: domain of jiapeng.chong@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=jiapeng.chong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760321938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zoAUUn3bBmorrWCF+Kq+jcKJMJh3OyLAIbSpHP6CdMA=;
	b=ZvojdnY/a51i8VnIQqLB3sL2r3OuUEax6z79EU3bA+Zy3Jev0b1bMA7TWSYWXqoZ/jqarL
	rwINUsGjTgeGFOsicqpA0T4eg14aQpVlsPbJyW5spOG0RY1sx8DedId/I9zM6jKFBZ7Hg0
	38q1TW8UIbohDqLR8Nlw24vk2jfWrFo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760321934; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zoAUUn3bBmorrWCF+Kq+jcKJMJh3OyLAIbSpHP6CdMA=;
	b=MAbYBAIQ7ONdZ1GThoNAKQKilUH7tONGrOHC/iaRxuXih9/M1ulgp/qBmMaiUTo91XaTAPwdYSpM08GaAIKkq/LvQqYRX1mlIxmFwFvHTFKDcQK67HfPNcwKdJkwiG+J5h8NetHxAkR0Hb9QRH5Vo3+sUdh/J08M0Bv35d8t4C0=
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0WpzmIqu_1760321916 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Oct 2025 10:18:52 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: graf@amazon.com
Cc: rppt@kernel.org,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] liveupdate: kho: remove unneeded semicolon
Date: Mon, 13 Oct 2025 10:18:36 +0800
Message-ID: <20251013021836.944898-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: iipkyrrnntxa43r8771qrf53cx9uz3nz
X-Rspamd-Queue-Id: 1923240005
X-Rspamd-Server: rspam09
X-HE-Tag: 1760321936-718096
X-HE-Meta: U2FsdGVkX19kZRtcGVaFk74KaQj5Resh6LChbL9ExMKNdHd3AeA4DFCDi9mwykRebXIDSVNctoCQNGskrid6qWdXRHs6ITax8In3EU2CV6zOxvlET4s/d7McHPxzF2+HzTys6ZhxTbp28K7sepWlZpBo5hthGldaPUm+ReQ9SKvXUGQGFGReXfJnm3bqMMec6bjsYiDxeiemB/SbBBcJppfqQKqqU/bNK9dU/F/Z44zSe7casThGmpmj8c1RQLNTXAfIoBp5yVW99Jlv0Criupm7ZtGTvLrD80i3rJPOAS2ikZbt7+bDox7FYemeUMpmPOJt94xmPFSJnl2iFM1CS+MoAZfCC4v5tug6CK0Oz1Q2yMJOpHdvQ5PmjvFCjjcH2Br5dJi+BmdY2hz/7u5FL9rh2h/GeX32LbCUTtN7iVF65rtfDeM83vr+1Qqf+r8SGvQGSJutXYQMdcQ1+vpcm1tbz/FbJCIQXuhXIgu4krPk1tTVLRCQsUooWLFFhUMs5mS5zMTuLZuMmhbcn6p9pXwdBABptH5IzgYmuPgK1bLuFtE/S2uTUafsQS9piSDiCiOT8A1fsOZismsn9AUxndX4k0ngLa9uPrQoG9ozq0+rkDdfCv21DCzAOujW2aCSxaiKKSbpolmjejpFhKjHRkuPgFCj4JDMW4JbL873vEftmy259Sd0iT7afsf9DC9qmY7kuiPidYQy/n280jQsyC2jlKx6QXWktL9P1CqVmEy0DcZ20pFQnLselIcRrjJy3+yoItAvRZKXPsRoH+5EmCeBSiYEdAMTBXjGJPKfBioxrX19rwi9Fme7+sfh2F1Sd6VVXsbuJVcJSiDe6d9uT1cY8ENHQ+VCUglxebQfwK1n7S+DLvZAWq5LvL6ImEOKryRFjhLdKCSfo/D9tATJmzKMbJ4IikrUp9Lultw26d7F+pDQOaNjGz/iiZG8+6MZgO2gGtaVkygu6xpVMap
 vUOjGcs1
 ae/Km/y5qtq1WZPHclZYaOFoKNd7VAH+2H/EQe2lkknicRW8ozOgDj96vgU3PBa1FSj2SJ/fbEqqbxxyZMpHohogCLe4pT2PPxugl2OZ84uQssprrHLMdsd1v0JyhnrO5xRg9B23InMX6FfvIxUeYTRcwV2+J6vf2HGnUhUdHeUrANilKzSQGUkbALwnwLokilMjJtdroQgkbv+AVoz2rg1KQPfPNDYN9/pBFl5UXzZLoIjqp222AtXJAZ3RvYHlx61091+NjHjmJIN6EanamM8uw6Umlfscgk++Lh5JLaWhAojM5ysTmwUeGsPstgNXFQtbx4o2cK7iv4e2iQ4uFOnRoIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No functional modification involved.

./kernel/liveupdate/kexec_handover.c:1155:2-3: Unneeded semicolon.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=26158
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 5da21f1510cc..c87d00c40c82 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1152,7 +1152,7 @@ static int __kho_finalize(void)
 		err |= fdt_begin_node(root, fdt->name);
 		err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
 		err |= fdt_end_node(root);
-	};
+	}
 	mutex_unlock(&kho_out.fdts_lock);
 
 	err |= fdt_end_node(root);
-- 
2.43.5


