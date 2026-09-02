Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA2CC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0B96B00D1; Wed,  2 Sep 2026 09:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202A66B00E3; Wed,  2 Sep 2026 09:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F22C6B00E4; Wed,  2 Sep 2026 09:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8F826B00D1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:37:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 979F640219
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:37:25 +0000 (UTC)
X-FDA: 85168924050.01.8B47840
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6191414000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:37:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XacPRPfM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A6cqz0jd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v057JiWg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2bwc/O8I";
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788356243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=Bbe3ypsHaJMTxsWzFGozVSPnJTsN/nGdouG9RcGUeX2bw/fkcJ7eYM6K/Z4hFsaTi3GVxz
	7FnI5087P5r+N8xF3mFAGt3Y3CZquTNO5zbSsr4ib3Nw+mTvqMJhVvYuruGKwk13G1bp2+
	UqNOtw4AdQZARlzW1tjglwfd2OhhSIY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XacPRPfM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A6cqz0jd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v057JiWg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2bwc/O8I";
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788356243;
	b=VhX6N5uT2QnfaWVf4c2tML20i8krTsmFFcHp2cpOQrEaMSorg0AMxj28M5+zSIM/iHS7WX
	1Vy/MdvsZpoophLbLZq4c3dn8JWgKSyxO70Yp5jmZ4n6Ck2jZ+UK2/nAVU+HP/hTWoEgxC
	JFfFGMRT3/XSk3l7Sw9/IIqaagE+zSE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C85951F8B3;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=XacPRPfMISNdW/DwDnP65BRYx5Xmq8RZlTIr9plSAyO1+Fw5VjC2ZP+JlrMREGTwHMz28c
	st8M5CpKnVYzMM02ZzrREcRsFwf/KecyzjXJgCRti9T3syl2CJ/ANrLPmPXkFTVQ9jyR2E
	8Ofa1bNvUTM/4VPQhH/AsmZbpDIYW2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=A6cqz0jd23QVqkF9IRkukb0PDhutZoFLJk1k5sVj5sVTQL+8F6rK1XBYcd6LlkU6Sp6vnI
	F+aCkqUT4njCS4AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=v057JiWgfFpRq8HZnNifUh1M4NDEJLwaWcCzjf0qS4psBCkmKtZC7OsAtB46+J38ivinFH
	ZyKGSXPboY24JwRj9z4A4HEZdIp4026i5xsW7EbkZ4r4pxLyd5uPVY1h0EiLosJW7C/3JL
	GHI+l07WDQZbyvN4guah9k3VECLP39s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=2bwc/O8IBFmZ4QW8mtJuMqT8HuVx1X+vEPtftsyNSk8z6dLJxLfLvfsrnv8yXXMRLfM8U5
	DLDrySE/XPFZqGCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7736913869;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LlYZHYkmmGrGYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 13:37:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C1D50A13B8; Wed, 02 Sep 2026 15:37:08 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] shmem: Refuse to enable tmpfs format for another filesystem
Date: Wed,  2 Sep 2026 15:37:00 +0200
Message-ID: <20260902133702.1313635-4-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260902132458.23590-1-jack@suse.cz>
References: <20260902132458.23590-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1014; i=jack@suse.cz; h=from:subject; bh=lhNs9a+Xa+x9bTBoSWZLJQRDRMwvKbNZuBDt48fbKGQ=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLJmqNVH3jSX0W7v3R+obHRb8JL4w47A9Cpl5U3pd9NrY vi+NDl2MhqzMDByMMiKKbKsjryofW2eUdfWUA0ZmEGsTCBTGLg4BWAiLfM5GLbvu3ZuosXp3GgP y49Z82I3xB7Rt1q1/E+U+s0enRmTU7eXxP7S6A9zso3/Os25wFZydpSD1bWjbAwBW924VKdPDK9 65lSVHNxT9ymjOtKg3ti77YKua7Hu/h7GvcabijlfcrUYZt0MlDrYs+fzi3eqnza5qTUUfWY4sf Df0sVMc68UsHOILXaRTlya3fr6k3TXgxPWcubbfqlEt1822PHx3ror8TFW3icPLNnmd3/bYsU1B tfeXNmx93F1XfcFjtVtzoay56UqYkxOV72rtw9aof76BvNZZTemBOYdkavk8vMV39ilvHAUfZdu W5eT9ebnMq7UWcFLTnW21d2rXKT3+lmydcQVhtfMeVHRAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oz8ioowm1ncn99tauebz6gj7cz19b4mh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6191414000D
X-Rspam-User: 
X-HE-Tag: 1788356243-496331
X-HE-Meta: U2FsdGVkX1+BAYq34DKuUxrZ8/ywkwdeJk5u3mV0qiGSrSRzZLb+TwZ6kUyxEZ9kLXvmn8SSj/JHUQbjr9VcUYTRYwBrPUv+wMqWcggguFlIaE2DmT3xSyZc+8e2z4HaPlsFEMIpdBImIPAG94e5IfzhoMcn+cTYAQfMZHAqHI3J7vDNCjX2Vk4UU0hH9scJBYcXfmfQo9h719RhMuPMAbTo6IrxVnRKiYirIIkmaWO3/4K/wmmmlameIywpiqR5fxs/RAlgTV6+PW+OZIEKCwXEAaRI63EwFHDu+4gImxL6hWK9J73dkxxKdlDGbwvClJo7/mk4ZuiPbPG491Cna0gddUOon7bmiJ44wcwFR/r75QdZtd+UZJ3c3iXT0dpOqtKXLAkoHjTuOMIApb4/gn+Ta9aNhN1APw1FZsTPCE6rAWewVIONxLJHquiKLt5PEieyjmFhRrCYrkaO5NxOB1S6bv4vcgUMArFUMtrsKF4x+XumEqnuiCLQUpV80B5cPH/fhltaraIPr2h0GaGReDt0r4VdK5YnCE6w9CQYrTOVhE0BcBMs68nONOyCds2dPEtsea6aujPVH+FaShgSmFXrYizMp6HONN5c6I2K91f2Y539xHElSxLUMRhMkEQI7uT6APG5HbI43f09ZINTGymprmauKtE8KSmduI1F3yqB9ceEQWf7FGufHbZoYLQEMOFwrXBQRrXQ6YRmXCrhRLE64gjIZx+eVkdYaFTNfGiZjDEP5uf6kowDO5TwzU6fl9rrOVV8aN0ENu5fy+f2CUsXSdbg1zfhe84nag2a5n6tMVxCwXzCNUzyHKZJeHZwlipiUKpPcs6qhoUqCiiayi9443H4oZwM56Fa8U33GX43iMgnlab8SnLws0jL0HoyZyBFAJJJF/6shxq7ogfS67Ddbpxz/dbVywNt0rFTnA+c9T27iua1FPiBxHzsjk0OlyZlARNI8ImTQUERkH6
 z7TaUWbe
 6+QMCbntTO5izKZEJBCnxdux++sZsZgrc4uG3uFKs95AkfzGgN6K3bLnUfGpZeJK2KcA/J8f94g1AfAL3PMiwHGCZS6ao21NJTvuka3ti9SIoEFvnJAQ/Qg6h2j5Swrg/ukVXaBwy82Lp8UHhPdyD+K9WbgmzbPSFD7PC3Aoi9k+5NPnWUPE79nAG376eyd4MOkUlFa7BAlcCTZ9iCS2GPaU2ncy4RsCjy+51leofWOTRKKBsvNrqf3faiLL1pa3cErYD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
requesting to enable quota using tmpfs quota format. With suitable
passed arguments this can actually succeed in enabling tmpfs quota
format on top of ext4 filesystem which leads to crashes later in
dquot_acquire().  As tmpfs quota format is intended for tmpfs
filesystems only, verify we are indeed enabling quotas there.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/shmem_quota.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
index d0b92d6da50f..6e0b43cbded3 100644
--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -54,6 +54,10 @@ struct quota_id {
 
 static int shmem_check_quota_file(struct super_block *sb, int type)
 {
+	/* Verify enabling happens on tmpfs superblock */
+	if (strcmp(sb->s_type->name, "tmpfs"))
+		return 0;
+
 	/* There is no real quota file, nothing to do */
 	return 1;
 }
-- 
2.51.0


