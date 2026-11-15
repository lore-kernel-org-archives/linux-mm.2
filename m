Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E3A60A3833
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UEahCePr
Received: by kanga.kvack.org (Postfix)
	id D40096B05B6; Sun, 15 Nov 2026 15:29:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17236B05B8; Sun, 15 Nov 2026 15:29:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2DE96B05B9; Sun, 15 Nov 2026 15:29:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAA36B05B6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2502A1A081F
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
X-FDA: 85438492650.21.E800DA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9726B20006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEahCePr;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvBIDhzkcMdHdrHP3Rxf/89i78BrWd7FuX3cNOeI1e0=;
	b=LcAeUYAveqs8vmwv8iALD5+e1xG/zsshuW0+rbeDr1jAXkgU9D1Wse8lWUIucAZ7PbRaPu
	OtDncpfkQycmZqyBB/wHY/iLQ4zov6bQbRJNxEPdhaGPSvISb+2izg0rykrAcshBlOq/Ul
	IVO4teuOwSTx0wlR7RnZTOT55wR9fHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774543;
	b=7qFGm3HMuL4aDAIrqPCh0HqwbdUOLWdIwgG6ZG5xaPepTrKsUKrA8meMyTeg5PVPJUU9T2
	e39FE5QA48Ep2wICvWFv+lg+8AFtOsNDucWD/YN8HLDZib355d77MNUPOKr7kgARsFFlTP
	6yIrsmFMp7h5Yar/0HtJhYge6mDhLQc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEahCePr;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F7C560DB3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDE81F000C6;
	Sun, 15 Nov 2026 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774542;
	bh=PvBIDhzkcMdHdrHP3Rxf/89i78BrWd7FuX3cNOeI1e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEahCePrCCo4xXZZJ8VFEBktekX07qPapwC/uYnCW0CQoV5uBe3BgS4a23TORVouO
	 p+ZkZcAsZLLHrScI/NUDMdFo/z6Vb23ONxkXnqpPQKe4V20IRmo5aVMycJkT1b3xiL
	 A64Yw6O2vL6df//t67r/rPqFx4fjEiq9ns75a5HPkZ746YiRkDNpToAjBDfu9Hy4Uq
	 CVMT6qb0HpQu8Rhi9Jx+Xxi31ruml2mXTGsEBCDLld4V/993WPhMY+AONLbI7zZB39
	 Wyv5ZI/lgI5XvC44cwoXB50bLAegwbiGomywZvPgqRoz2JnvFDA0UnJI8nefhybcTB
	 xBEfv4IxiUX9A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/27] mm/damon/api: introduce struct damon_report
Date: Sun, 15 Nov 2026 12:28:19 -0800
Message-ID: <20261115202849.99134-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kp7bdjqu4ci8xojdifts7frbm13ejyff
X-Rspamd-Queue-Id: 9726B20006
X-Rspam-User: 
X-HE-Tag: 1794774543-154901
X-HE-Meta: U2FsdGVkX1/+Errtbd2/c/9mAlEb9S8SoVFeJUry/iosWx7Iby3yKi65b4YU1S7wBpfe/+AyA3zN5ry0AkBHkehim3Bey3/G1dt0R/f1yHuECY6/wmGG4rKvNB7nGzZ154z2CQIZzlfSkQEEVUVRvmonnKK2i1Dq4+wc257ikCK+BWyhDmWWN3mGbWbHcZSL5aJRH68C2wfeNQDYourPJ8+3BMhmuovoAYorNqaO/A2/TEVXa/nw85nxEwiU0QtjtNQKw1aoogZ1tpb3b34fDesOymStVqzgZXKGykYIDWL4xJZsX9BrU3MELr1g0oDCU41bYRIa0VZGa/vgBKUnbYtSLVvW26wQR8TXwoAShAz+GsN618GFADA+4V7smtRygdki6KKGJBbMOBYeRfjgZL6AWDGv9Z6heQESTZIF4FsCpr1rigxp337Am0KXQU9m8WBMjHYnnYLFmAtRi7ravYj7RWGS24liS+Sh5cjTQ+/KFtx4qBB1a58pcexL0gcoY0yE+WoAsnKYKozA3L2itVkM9u9tps85Uppfa1IbnEykxP1XsSMm8Tu8ufkQu/6HI3VBIvdp0xA8h6ACLSAzc+7M/gAsFI7vWElBYTXXcN0BIqLpO04s9zp86qlllTAFjKIKnpOY4msAH70YJmsg9528Gei2+szlZu07nsUlDco1jr2m8jbkMAAoqdlow3xJujQ+CWq2uvBwbozOXKJN02qt0vZ4Wd4wk1Ccgm5rTOoiFc5sZ5MjpAN07yf3rduF9hoB1EBTuZYOFodCCTOHADJ3u9BLf2oiYqpmT+uNjPSiGUJ/AGp9OmbbudvFTBVSEevQAUOmfMShBf6IOoBBgMn56OUx5RI6mGmpkIfqpbCTvNSqkrDcygcUq+sjRzKRRfLEUakKKuyRXQokHDwNfhcKWykWKnzPtS30odFtcSpQVEkLki9n2cJGoHoqIp4bt97AG32Gsxcd837nUYs
 bGO3+yOZ
 FTUFKvLKVm37Ka0UY19P9FD8UZm20yqlA5c88qFXlMxHPfYEAFzpfx6Tpf8SXxtC1YKiuyD/tLR1BZhjlkpIOE9ZBF6qJPwwaUnYQYeP7jehjuN06YNupkYXxAaDm8pwvyWVeC+PLDbm9M3ZOoLe4bQVi4QoWHQpL1KOzrJ/eW4WBL0lSNcsfoytOPoJQ2x/kywPcrTVnpgwxplYFOghG0dmCgVTs2IvRcuONIq0uITKAOViOK0BaiOpXfqouDr1pwz56KYEYfERBKH90KvqAlfbmztLmnw/4ERPy/S1dzblkyyvuvZS7gJ0MEQq324Sg/awZSQiO7oVP/OdvjPjHK4xXoFuAGb1Lz6K/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Define a struct for data attribute report.  The struct provides public
fields for the type and the memory address range.  The type field
represents the type of the report itself.  The address range is for the
memory of the reporting data.  Data attribute producers can format their
report using those fields.

It also has a private field representing when the report is submitted.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 06bd92981af21..5c32ddebf4625 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -751,6 +751,29 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * enum damon_report_type - Type of &struct damon_report.
+ */
+enum damon_report_type {
+	NR_DAMON_REPORT_TYPES,
+};
+
+/**
+ * struct damon_report - Data attribute report information.
+ *
+ * @type:	Type of the report.
+ * @addr_range:	The address range of the memory to report for.
+ *
+ * Note that the @start_addr and @end_adr represents an end-open range.
+ */
+struct damon_report {
+	enum damon_report_type type;
+	struct damon_addr_range addr_range;
+/* private: */
+	/* when this report is generated */
+	unsigned long jiffies;
+};
+
 /**
  * enum damon_prep_action - DAMON probing preparation action.
  *
-- 
2.47.3

