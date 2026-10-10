Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95636CA9EC1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 16:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BF46B008C; Sat, 10 Oct 2026 12:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3056B0092; Sat, 10 Oct 2026 12:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA876B0095; Sat, 10 Oct 2026 12:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23C446B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 12:21:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0402EA05B8
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:14 +0000 (UTC)
X-FDA: 85307231310.30.60594B8
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 440911C0005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L7QCkBlb;
	spf=pass (imf21.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791649273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HD3NcIDPdwUreYfDUge++wJHXhKnRmGfEpR/CtJof+E=;
	b=lves4Uz1fcuMavDJKxq67YAmAg1zvTN86MaHwNSXfY3gPZdhFJsthYh+VHo5T0sUueKez4
	hrppoOiKyV+JpnmrrCP/8BfhZat7g10jnMiLLqo9BvX2rE0J/Hju/Y6Riatw3A5ddab493
	JX0oLu2wJTRB/HKCznBqZS6fh/GjOgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791649273;
	b=XvP7WULZQILviDaIrQkW6JC6wnCepE5ycj801DNFWFB3jV/kjKfN7YqpDm+IClnlhR0giY
	vTA93/PLBoJNPIuzJXNXPZvHvYbl6qeQqcR1780TRbTzOP69H8YIjUHF3Wb7Fx/K9mo8Qj
	BapB3EHmGNKjdO5/NGFHnG5j5b6B7N4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L7QCkBlb;
	spf=pass (imf21.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-16ad92569b5so611905c88.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791649272; x=1792254072; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HD3NcIDPdwUreYfDUge++wJHXhKnRmGfEpR/CtJof+E=;
        b=L7QCkBlb9cCsO+k1w+DLildJ7ituaG7Hz7xxA465/IQ/2rOArYI2R/3AI1YzKcI/mN
         BVN40DHUkU0S2ac6E8gQ7FQlKprMtVattX5WUbeMx2VOMXPKDlD+xyLxQjKfZtKGHZiQ
         FgUjL3N9hfDP/eNR6MKtIkMiCTmBXADuzA0+q/qHUA+KkelWBjZhiOY57soOXGmP9JKM
         53+DwSJ1UttT+J1EG16J5PFQ1haM+wOCJQebx6YDinFZVtIzoiZPBaUCxFHKiTRNQLIp
         x629xvJVwJ71LqSWQI/EaxLop1hRi5G/ZbmrWN8BGZgMezYB+K5qUJkgCVqa5TGYUJD/
         +08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791649272; x=1792254072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HD3NcIDPdwUreYfDUge++wJHXhKnRmGfEpR/CtJof+E=;
        b=UcBXG8U2Id6hl1EnclGOGVmBtQDtRO8BnYsk0Ue/vAj6m4rQsv/9CqzyNL0A9cio7O
         Lfm4dtofAF7wVfnQRTUYrXGOnHU0nVtr1C3L/axhDRzt3qgdGt4J+oMrLg2Vyo9ydbUm
         dvmJ1D0Z3d+WmI2js6PN7k4Z8esKKBGsrAygBHWLZwFr+/iMA/YECn11nacIEKZdN+TQ
         AAgt1fF9cuX+sLGgg94pNWtYQsdxyDmumkjBy5EuJy+43BTnxSmaoM38LOulnJlAQdPY
         ZBGYL23G3ZbxyOpnEyLfrjdoQS1EQvY/eBnXswtEYHBlRHA6vBp7we37nvMJG6H+03qr
         gPEg==
X-Forwarded-Encrypted: i=1; AKwUvBwAjzMJU5hAAs42JeXAmSDAlh2E4VOb35nfZQ9t1f/qXVtz0lPsrwsFlXt+mnp+cEdkIrlXz4bq0g==@kvack.org
X-Gm-Message-State: AFq9FYJXuvwYDyx1kw5A36wsjg5kKpBQV6xHtTRq+EoxRrZRKVMxszuS
	R3qBSIslWDEwXd2trd2Y/61CanlOy7VXglHq/Sdd+nJmK5IG5Yjnnf4F
X-Gm-Gg: AYBFou1JZ1yj2lrUtKfsB4YQ/DEVEUlLt7UVvm3PemJ0WbyDZBgsmosBSwCopr45z/J
	eBdP8GmGkhHGHkVo7fDb2GJpgt8tqMVWGSfNqjTeHyf3xSfDQ5NyqAhumsERhTok9MjoIr6Zrq2
	5PgzvOpn6wPkapR3Px7b/tw9li/s5I01+EaaYb5E5Z9mP8oH2wBcxFpKFPgnCDz4eh3kqw7Ly3W
	/BNPBzrsJ5fs5YmnpGzzlN535Xl2nfvpYLGhPbkUgKU3g+BKkxJFvmIXkSvdVtrTkB84HvWpA8B
	+g+YSAQmNPIuwDIU4SO+DxKOnfnWXNK9NCOTUCUPZUNjVewM960OWUZf+tY+orSGOOE7vj9vk3Y
	MIhT8NorTCDSfPDXheWn1ZYN52Nz/vmDFcDWAac3516lmVqG7N2Dyhk4nbprPBQcfPuk2jqH3H7
	GjpEd87yE5oeAD2Hi5zwKvbcFNpMZFiDBwwEzPoWWX5jyKq6KIRBqRU28c0ZcyeivPYYNZoWuaV
	NER3sh5o1s4oaCDT/v9XpXjkyHq
X-Received: by 2002:a05:7022:7f04:b0:13d:974:a2c6 with SMTP id a92af1059eb24-16a5ad07499mr5876271c88.7.1791649271910;
        Sat, 10 Oct 2026 09:21:11 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([115.96.176.39])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a3f6186fsm15778622c88.14.2026.10.10.09.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:21:11 -0700 (PDT)
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>
Cc: Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Richard Cheng <icheng@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Subject: [RFC PATCH 1/5] cxl/mbox: Add Get Poison List snapshot support
Date: Sat, 10 Oct 2026 21:50:09 +0530
Message-ID: <20261010162017.62506-2-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 440911C0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3ubtgrfcb1e4m9jiz7oyeror9m3t6qif
X-HE-Tag: 1791649273-62153
X-HE-Meta: U2FsdGVkX19nPdTHoOUqDB0MPntujF4N+JNMpQ4LTXAHMGrulmNX8eriqZmZl8c0x0+xt1e3Bppu1/f1MDQb6QrsRyBWs0v7safsqDCBAr9dlu3N5FwnNEMwPOOtPYtyolJLG3+VHJ7jFw8aqgBRjFDwnoa9aOtdPoEIL3bn8IOvXJ2B5G/S5JGkvyYjKf0+UtWkxN8zbJsnrM44NvBm78uy0E6iXmblx1QoqAK+mor6zdHRrWfhTz37K2PjVkA1FYJPcrdtGPy/oAF3QX0iJVv4Jmf/4lxUxVf4+cfjvKAOMdT+0ev6doi9HJUCm0cQ+RsTWOGunQCzww/oeQfPWKMzjPB4UH+CdHqOhCM2NDUWu53d4zMoFVM2eONtLNGxINWiFERXpgPXZCkOxazobD3qDDh0JY82epUqtUbRiqvPeYf9GB3nW9lmsyA7D7NxNe6SwhSPxT3Oe19/MH2b6zZfSqXR+KG6h5ZXENnnGMFJYjFoYuxFHE1p2X70JMMmCSOjHCV2F0TbYqGJKBrx8HcJhU6nKn7EtC/mo/Qxw1p2Wu4JSuf1233yoZvhCfoM5WDEmDSHwSnOnMs4D+fJvZwiTpRbfZojgCDlzVjLFuxR8szgC42I//SLtYVXbbmXaRpZzBYc4hTCsrwBkqybop8swM8QxX9RwXPIR8OWKFuPOm17bZFB8+2FOW6PX8PKOOY7jUVhyZy9z/tPzZHBv33cXFcc6moccVzQQRlZqCgJEaTNZDwnZ3cEF0qfShUWIskfc1NTCCwHq6dzRvjIh/G1O5uQz6mHchYf/dCp4H0bq6z1Qo6jqNu+zfNkfNBzcGGRBrNga7Px7AXsslTtzcRTYxAogfDRXEsOccTgECmXkRUMbj7q1cU8sX/nP2TllzobP2J4OxkOOVLAy1PiQlJfcJbB4787UV+lxbZwjZXTGWvQlPnZ1iv9K0e5eA3oY2q6rc1uxqy0OHMDF/m
 AVm0NYBt
 StGxYfqAHMZ8Iw+k9t9cCnr6bxCmASKqu4CNpP7cGe5iBjDb9iSknipIQH8e3Y4mfRVj3ACczoA+4whHeYDtDYlC6IDsB16+SZAXEopige2oW523W3AVscvmZx7JgYLqCI8A6tJYnftnWpRD5rSXC2iwaxVVNNYKqe2pavplwCXqyn60yONiU1vLChv2wEHZ7UcW7HciF2r4VBBPs4PmSs22HsncHm4TtqtS1ZoTuHsxYaXNxmsQCHQpGEoavS+KIPeZeNoZZ2bqL1NuVT7dWU+A8bnH1/+UXPNKb1bjslpQbRfQvpAaD3m/wSZ/dDlJ3iRNQKGIYyveRJr0mv6Zk6gHQyfkf3POWYWzMZuJcSqQqlPANA7y6fR45sNh0N3uGMDdi6jsZObGY1OF8fkWP6lv305oiOwxI4bX4tmmoZoMaKT8Mou2YhMq5N/fnUzemg6j/cQWnONm7vhAW8tHW6jNP1ARUxLzpRSsolrpRppw2wAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cxl_mem_get_poison() uses a device-owned output buffer for each Get
Poison List response. It traces the records before issuing the next
command, which overwrites that buffer when the device sets the More
Media Error Records flag. A caller therefore cannot inspect the complete
set of collected records after the function returns.

Add a caller-owned snapshot and copy each validated mailbox response
into it. Preserve device overflow and scan-in-progress status, and
indicate when the host stops collection before retrieving all available
records.

Keep cxl_mem_get_poison() as the existing trace-only wrapper so its
current callers, including trigger_poison_list, retain their behavior.

Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
---
 drivers/cxl/core/mbox.c | 137 ++++++++++++++++++++++++++++++++++++++--
 drivers/cxl/cxlmem.h    |  25 ++++++++
 2 files changed, 156 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 55828a836c01..2752b46ffee2 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1376,14 +1376,91 @@ int cxl_set_timestamp(struct cxl_memdev_state *mds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_set_timestamp, "CXL");
 
-int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
-		       struct cxl_region *cxlr)
+int cxl_poison_snapshot_init(struct cxl_memdev *cxlmd,
+			     struct cxl_poison_snapshot *snapshot)
+{
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
+	u32 capacity = mds->poison.max_errors;
+
+	if (!snapshot)
+		return -EINVAL;
+	memset(snapshot, 0, sizeof(*snapshot));
+
+	if (!test_bit(CXL_POISON_ENABLED_LIST, mds->poison.enabled_cmds))
+		return -EOPNOTSUPP;
+
+	if (!capacity)
+		return -EPROTO;
+
+	snapshot->records = kvmalloc_array(mds->poison.max_errors,
+					   sizeof(*snapshot->records),
+					   GFP_KERNEL);
+	if (!snapshot->records)
+		return -ENOMEM;
+
+	snapshot->capacity = capacity;
+
+	return 0;
+}
+
+void cxl_poison_snapshot_destroy(struct cxl_poison_snapshot *snapshot)
+{
+	if (!snapshot)
+		return;
+
+	kvfree(snapshot->records);
+	memset(snapshot, 0, sizeof(*snapshot));
+}
+
+static int cxl_poison_snapshot_append(struct cxl_poison_snapshot *snapshot,
+				      struct cxl_poison_record *records,
+				      u32 count)
+{
+	u32 available;
+
+	/*
+	 * Existing cxl_mem_get_poison() callers request tracing only and
+	 * pass no snapshot.
+	 */
+
+	if (!snapshot)
+		return 0;
+
+	if (!snapshot->records)
+		return -EINVAL;
+
+	if (snapshot->nr_records > snapshot->capacity)
+		return -EOVERFLOW;
+
+	if (!count)
+		return 0;
+
+	if (!records)
+		return -EINVAL;
+
+	available = snapshot->capacity - snapshot->nr_records;
+	if (count > available) {
+		snapshot->truncated = true;
+		return -ENOSPC;
+	}
+
+	memcpy(&snapshot->records[snapshot->nr_records], records,
+	       count * sizeof(*records));
+	snapshot->nr_records += count;
+
+	return 0;
+}
+
+static int cxl_mem_get_poison_common(struct cxl_memdev *cxlmd, u64 offset,
+				     u64 len, struct cxl_region *cxlr,
+				     struct cxl_poison_snapshot *snapshot)
 {
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
 	struct cxl_mailbox *cxl_mbox = &cxlmd->cxlds->cxl_mbox;
 	struct cxl_mbox_poison_out *po;
 	struct cxl_mbox_poison_in pi;
-	int nr_records = 0;
+	u32 nr_records = 0;
+	u32 count;
 	int rc;
 
 	ACQUIRE(mutex_intr, lock)(&mds->poison.mutex);
@@ -1408,29 +1485,77 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
 		if (rc)
 			break;
 
-		if (!le16_to_cpu(po->count)) {
+		count = le16_to_cpu(po->count);
+		if (!count) {
 			dev_dbg(&cxlmd->dev, "Poison empty payload!\n");
+
+			if (po->flags & CXL_POISON_FLAG_MORE) {
+				if (snapshot)
+					snapshot->truncated = true;
+				rc = -EPROTO;
+			}
+
+			break;
+		}
+
+		if (struct_size(po, record, count) > mbox_cmd.size_out) {
+			dev_err(&cxlmd->dev,
+				"invalid poison record count: %u\n", count);
+			rc = -EPROTO;
 			break;
 		}
 
-		for (int i = 0; i < le16_to_cpu(po->count); i++)
+		for (u32 i = 0; i < count; i++)
 			trace_cxl_poison(cxlmd, cxlr, &po->record[i],
 					 po->flags, po->overflow_ts,
 					 CXL_POISON_TRACE_LIST);
 
+		if (snapshot && (po->flags & CXL_POISON_FLAG_OVERFLOW)) {
+			snapshot->device_flags |= CXL_POISON_FLAG_OVERFLOW;
+			snapshot->overflow_ts = le64_to_cpu(po->overflow_ts);
+		}
+
+		if (snapshot && (po->flags & CXL_POISON_FLAG_SCANNING))
+			snapshot->device_flags |= CXL_POISON_FLAG_SCANNING;
+
+		rc = cxl_poison_snapshot_append(snapshot, po->record, count);
+		if (rc)
+			break;
+
 		/* Protect against an uncleared _FLAG_MORE */
-		nr_records = nr_records + le16_to_cpu(po->count);
+		nr_records += count;
 		if (nr_records >= mds->poison.max_errors) {
 			dev_dbg(&cxlmd->dev, "Max Error Records reached: %d\n",
 				nr_records);
+			if (snapshot && (po->flags & CXL_POISON_FLAG_MORE))
+				snapshot->truncated = true;
+
 			break;
 		}
 	} while (po->flags & CXL_POISON_FLAG_MORE);
 
 	return rc;
 }
+
+int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
+		       struct cxl_region *cxlr)
+{
+	return cxl_mem_get_poison_common(cxlmd, offset, len, cxlr, NULL);
+}
 EXPORT_SYMBOL_NS_GPL(cxl_mem_get_poison, "CXL");
 
+int cxl_mem_get_poison_snapshot(struct cxl_memdev *cxlmd, u64 offset, u64 len,
+				struct cxl_region *cxlr,
+				struct cxl_poison_snapshot *snapshot)
+{
+	if (!snapshot || !snapshot->records || !snapshot->capacity)
+		return -EINVAL;
+
+	if (snapshot->nr_records > snapshot->capacity)
+		return -EOVERFLOW;
+
+	return cxl_mem_get_poison_common(cxlmd, offset, len, cxlr, snapshot);
+}
 static void free_poison_buf(void *buf)
 {
 	kvfree(buf);
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index c401e3a1af06..1d6f8d958bd2 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -812,6 +812,31 @@ int cxl_set_timestamp(struct cxl_memdev_state *mds);
 int cxl_poison_state_init(struct cxl_memdev_state *mds);
 int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
 		       struct cxl_region *cxlr);
+
+/**
+ * struct cxl_poison_snapshot - Aggregate Get Poison List result
+ * @records: Copied Media Error Records from all mailbox responses
+ * @nr_records: Number of valid records stored in @records
+ * @capacity: Maximum number of records that @records can hold
+ * @overflow_ts: Timestamp associated with a reported device overflow
+ * @device_flags: Persistent device status observed during collection
+ * @truncated: Host stopped before collecting all available records
+ */
+struct cxl_poison_snapshot {
+	struct cxl_poison_record *records;
+	u32 nr_records;
+	u32 capacity;
+	u64 overflow_ts;
+	u8 device_flags;
+	bool truncated;
+};
+
+int cxl_poison_snapshot_init(struct cxl_memdev *cxlmd,
+			     struct cxl_poison_snapshot *snapshot);
+void cxl_poison_snapshot_destroy(struct cxl_poison_snapshot *snapshot);
+int cxl_mem_get_poison_snapshot(struct cxl_memdev *cxlmd, u64 offset, u64 len,
+				struct cxl_region *cxlr,
+				struct cxl_poison_snapshot *snapshot);
 int cxl_trigger_poison_list(struct cxl_memdev *cxlmd);
 int cxl_inject_poison(struct cxl_memdev *cxlmd, u64 dpa);
 int cxl_clear_poison(struct cxl_memdev *cxlmd, u64 dpa);
-- 
2.43.0


