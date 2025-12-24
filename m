Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6415FE7544F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C2F6B0088; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FFF6B0095; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D33C6B008A; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2009D6B0089
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C455F13AFE2
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:34:07 +0000 (UTC)
X-FDA: 84255062934.19.8BF66DA
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37B00C000A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:34:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=mwV8vjej;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766597646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mq4W7sDg/Agh00nn/sSC9HgKzw4XSoLV+yJE0vShXuM=;
	b=gAHhGfBAOqhkFJNs96E3MZdaAYiIT1LlfyNPr1urjwrne81RBlk6LbqVIjpkf/QIbDjA1e
	LM40jgHvJ11WRyXCjFrTshmz/xjbOfl9U446JBGX5ERzWlgxk7VBnh8T45hUXvCDkdynEz
	G2hecbfeLv1taa1zZM7fGMBLcs7FHfQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=mwV8vjej;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766597646; a=rsa-sha256;
	cv=none;
	b=bS03KbZwUpV/RhYvjcg4LJ6Bfl1HRSdFkIZnbQyvuQAirNcg0wi4vS9E3nOvVzkse7UkBP
	yDAZqdOQHBHwFvcmT73z+il9bo+6LElr20fHBkXyi1JgR57jYIz8ehCDnf0UIeJUja2Lvr
	OrjuKwdiNcwF/G8TeA+8F75xvQJ+pSI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766597645;
	bh=Mq4W7sDg/Agh00nn/sSC9HgKzw4XSoLV+yJE0vShXuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwV8vjejIZtBnu/BJjgSoh3W8IJpP5EO2IJSE+RFcgANHPCeB+IvJzRN24gfE2q/n
	 G+qD4TBldsguubC1CzBWgXCZk9cHb6JJGcRY0+A68Qolw2M5dEs2l38UfCj2pM6HFG
	 zfNMYKNSyAO0TChR5iBq28RBTxRKjHoXd2P0MfRXFoUsisfj5/1OkkG+ZYy2SnC+my
	 Q3y321qFZXstB2beDmbgavxfWHzwRRAUR8ARIBm37KXRnsVj0a/kUoQ9sD8N6/7ODe
	 oeJ8PR6D2iPQjP+61hbSwEncWMcef/vyaEQ4YYzfsF7E1LmAPdHZDFUMvSs4268PC9
	 3lTVo5ib/oSyw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dbzWd36bLzfHp;
	Wed, 24 Dec 2025 12:34:05 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1 1/3] mm: Add missing static initializer for init_mm::mm_cid.lock
Date: Wed, 24 Dec 2025 12:33:56 -0500
Message-Id: <20251224173358.647691-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
References: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: b9oqap5j9cf4erzi6rxrxu7gx6uytwu1
X-Rspam-User: 
X-Rspamd-Queue-Id: 37B00C000A
X-HE-Tag: 1766597646-158218
X-HE-Meta: U2FsdGVkX19Y1fHnO8dFZdkzEnXB57wNwjYWyogo3qxYXApz5h4ybXtTehKnnCiLopSKGhz9kf7v3sr2S4LC0evb26ghHSMtGu/7zD7W9MhtaEtLxNfe4CECzqQqNPswdBz9TFeu+9G/gbPGud2w0S3sSW25FVRipyHcc9oCwD+0a9f6lYCjhMg0cMAut3h9PiaLNRxnDg2bLWaNXmPerH9uJ0MBvBODk4MM1tLLCVWS+Nfz8fsJXQou9sJ7VbbqqJxbu88fUCRi+lyJHzpM6qZMKMge/arDFCVJ/3AwfknOuOP0OqcJkTTajqLlwP41TmjOL18d8w4CLdHaD2TOxKyPd9rr266h8OvSpBBiRpLKTbFPGEWR6DUseFEZ2ObPJFn+X8iZIgYHA4/D5invf8N4I0DuXE4VRTUYKrtwHj4vNIKaY7gflIr79D9HeflRtTtImlwMiwow3/vxc7KumVq/xmvnhcC/w45zHX8reckcLkv2G4J15W0X8LBAZnNuwLAVw4vNxo0HkWJl8u5p2HkZbCHMgpGGKjMP4O1Wij8jCJ9izx9K30QSpxZvwwtwUWFPMmMIYSN1IeEUdbk/miPHF9x9hbipNtReTmvziUlYaw8JSK/EMBzN209qmZqmgBRpra6iQkcr6zmpwt4M8mjzoTjanfbdW47CvKEEMX+YheJUAul7gLVZS9Yl6PVLf/G87VuSkHUc9dauXah+MtxVPbO4698TQsSPu/fgoVFFCVvgCagJtqzHBM6JOSNd7oNGAjBuBge3NkplzbAzWXXbnydhlklb/tvPeX+HLteb9Ng23fZwQ7qQkV4twWlcySWo9m+NCKzsx/5aouU+Xj4InRjfMkr8X3Zxe7uZGYow6LthAlXmvBC1U9/w3t1zMzrUgECDWXH1c+m0fMgQda8skVu2h+B1jHd+K2bTKm+kfAKyvL/IeV7sCrJkDrmA7WN5/kJrCN7CuOtAmyw
 KvGKWG2u
 XapdA1g9LbsgbpqXvzzVrDxb0vq84f3yTMN6XYkvWI6gj/mIXeFvdPBh5IsTM0YSee0YgsI7r88pNUQki3TAzKLLT9fX4VcCakBra9N1RU13ODdFp4HZPVuQeQtD0OMKOwOm7yEcIxmVaXajJBqN/iCaFqH/5Qp7ZWjASb0bHdhPbKMAe+sXgTP3uqk5thel6dxQJPKBJb0Wsk0R1hDwf5OgHu3rSsiTXtUldcpaAm523puDh2XQBtoKVx+Yg0yYpUxpPqFVSQF5cBIYEsj6MU+OJVfOSKi0Ut1E89JuCHVI/sCPrkzlFkwIwv9Cf001VhtxKSoKLgrrAy94CSyBpOIbVjNnzYFouOUXTQfOraMZrNqRuX5mjCaWAYFrjeBhDMhzAo4nfvaM+FoYoeu2UThDUx4ik2zsJ6JRau3qCMxz1TXhXYbt2/GV9TpqOD0yGBrT0LutqQjbx5SgiNve0j1k68Yb7wGwJ5lEeBTv5/q92+uxQvIPF+HAsHwlRelflmoy0FmlYyrhiYtrobtSFHBTzAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize the mm_cid.lock struct member of init_mm.

Fixes: 8cea569ca785 ("sched/mmcid: Use proper data structures")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/init-mm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/init-mm.c b/mm/init-mm.c
index 4600e7605cab..a514f8ce47e3 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -44,6 +44,9 @@ struct mm_struct init_mm = {
 	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
 #endif
 	.user_ns	= &init_user_ns,
+#ifdef CONFIG_SCHED_MM_CID
+	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
+#endif
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
 };
-- 
2.39.5


