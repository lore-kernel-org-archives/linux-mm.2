Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F548606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=JhTU+G7I
Received: by kanga.kvack.org (Postfix)
	id 97F4F6B05B5; Wed, 11 Nov 2026 18:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956EE6B05B6; Wed, 11 Nov 2026 18:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846556B05B8; Wed, 11 Nov 2026 18:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D35E6B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:00:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF09C120310
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:00:26 +0000 (UTC)
X-FDA: 85424358852.13.A253F32
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5FFCD180009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:00:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=JhTU+G7I;
	spf=pass (imf24.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5bcno4UXP7N2txNavRMGh0sD6iLfaBBk7CthX8bdlU=;
	b=ajdPlueTj4SFuc+yNBMS9DT63ZX1o0ou/Nj7uynHgC9RwkI1HXFjpj7GVHuLTQ8ZFxC73e
	cnWU/ufxTkpJpJTouVK5G0e7cP9oRVfrEYbjfnCTSPUyzsHGNoIyMy8PJnTp3hDwCeO9lv
	YODYpxspiYXXZCn/wrNSaDEFlvcV++s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438024;
	b=mOFUA80DyY2HypJcMFymWZwTGZLDDvCbkPm60fAaNEnbrjIXdOYoQPL+I+wG063vwM9+qp
	EVbwhO8Mg7d8GG3RM0deqs50vZNgX5wX6EWQpMfZUPspLn2FEZtMO6O2bdUVzwmg9gxcT6
	YV5RczQvR5xufKOkBwJEvkQHPlSfnBw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=JhTU+G7I;
	spf=pass (imf24.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438024; x=1825974024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l5bcno4UXP7N2txNavRMGh0sD6iLfaBBk7CthX8bdlU=;
  b=JhTU+G7ID74LeR/kj77CshhnNvZ9Fny6Hm9sO4B36SFQmZlZZ+s4brg3
   vkOMfRQcxhSZdiCgwHQOYPt2t1Zn2DAjqcT7+3lTYm+NxUdYps5Y0/6go
   KHrV5pN5lftmWJ7JJjL2j4vqhefxOkQNMZAFG1fdW27Ehn1h8sHItMjdK
   7H9g/1TLSDebZI6wH5r3gYpK0lPt9txmYW5Cq3IkRHuRqBu3w7Pk3e+Ah
   R0vffCWWrzSWDgNFNJ7nVJc8tn83nGQUPuWjofOs5BlX7JfGTxXkgNMy/
   16ZlBCj7ZCXDPm1K465nqc42hW6sql3xOm8txRaVE9wdWgyZvEVT0Pbls
   Q==;
X-CSE-ConnectionGUID: bQJCdL0lTrSHcC+Vs8ubIA==
X-CSE-MsgGUID: rcJECCCSTmuuDApB103yLw==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33757073"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:00:23 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:2153]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 1ab7d5a6-029a-4b3d-8053-f474fd6a8a95; Wed, 11 Nov 2026 23:00:22 +0000 (UTC)
X-Farcaster-Flow-ID: 1ab7d5a6-029a-4b3d-8053-f474fd6a8a95
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:00:22 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:00:19 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 16/40] nitro_enclaves: Turn the command reply into a per-command union
Date: Wed, 11 Nov 2026 22:59:20 +0000
Message-ID: <3512d2f3fb3ecb4a9795f50b2f61f371c3ac6458.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: e9949ozxcx9rgmhmwyedb89csd1pg18a
X-Rspamd-Queue-Id: 5FFCD180009
X-Rspam-User: 
X-HE-Tag: 1794438024-712991
X-HE-Meta: U2FsdGVkX1+UUeasYuGQPYwC/X5hfEcgDysLmVu4fYaCvDL+lHXb0MZxoj4JnTJPvnICywtmz5cC3K8DbqhxUsjbBV3WcGOmH8Teu6zfnBaTvVr/j7y0Xf1A5BxvDtCcBpTL9eoRymkQXK4tXTPTjqoVA6CKNlQIjKXB1Ray93RkwHuE05oW2kS+RPpEfxwFr3dbWtUnLZyeuCuiOnUxtqPUjgIYYKcl0FIQvvQyMVYuqgsLjOPi6haFTQYna8cqU+tv6EcjttG4XUkqan6/8W6f/aIiNznNlSEQEq0/9H6d8iuwA0UcIcx/qTZezPGbigbg/junv99Kdo9YJEw7hSALWWSiPugPqfVh8GpVTxGZTV1F+bSs2d10cpbbuRne+tlxtZNikrUlD1xRUmCAz3/BALNT6jWXicQjk/qtIJLPCGMQqCC+sKjU8SVMC+BCNUo+yALJPnQ6PjI/pmMzMTQH9uh9VtC589m1hnEx/VWob2cXwZuzHhVXFSPZLmy+FegKSUWw84IUMzjSKG8s7GKgXQVGUtj363de2cA3FZJF9I8od8AEgX4jVkpy6/Ltv8iTliEVFkJJEF0JgbH7Ie8euPfu2gzd8M1QbkCYQOpor9OtafTXpBQ2WUJLuRN3kFg4H/zjW6T6uXg4lc61vBb+pXJWPo2dPEEM+1zRGFgQwk4MDKZI5l22Y7IJVTSaPhZZlB8YCVgvlWmjiEBS+qHm6Tqkere0GrX0kuNbQUIiBsjF6zRxJQKZJUo8gqEoFcWBdnJxIGYxjfwYdil6uTqktxCZe85brxDOT4a3sg0H5QJbqkTKw6dE6kn/9QJoDl/W4m+YIK2gbhl7lqaI3tE5Qiv7AgTERfAyNY2yns4WPw1TYZToQF03FzOI69cDCpzu4rwR0jpAXt4+OyPW35FBPankh2TIG1l0pg7eFvTjcssdND9nb7oi9Jp6+Tn98qH/TUSXwptMcruiksG
 RD/i2n6x
 ZzoAqjkahr4pabNTDo8w5A5gP7tpA0JKoGIjx25gcZQBkHJhEr86CMK2K3JofKl2/RqkvkmMccvjletxKA62/w6TAt6PJi+OVhFMWNWkwRwetOqfpEmN6ylS8tAACGL55fObx6MV3iMz4gJ1Zy/Poweaec2UIss1LEP2NefLuLbDoF84+dkFr6c1Bphk2YY9BCIyE2luyaSgrcbUIxQKZhJ75UwWtq9Qe8d1vBJxrE/UcPZ5DvPtrubwY0Iu7HUeQLKlcfpQx9KMnTc9bhkT4tNKzTanjKLTndbMtJq1E+r9CLEKcMBap1BqczO2nl7/QAzv0qvmMNWSCiDmnit69HjXktxX1GAHjO5bqhxr7680UuZ1XlAtWzsN0hBEqIM3IP4+WascVBeFndo+bLTipGebWiJ+OUtqjZw3maFvnu+i1asPp7r8ggdia4U22oI0WwpKtGVJOCIL8JaMZiYZpFwvoI8YzKMej31fC4f9yTmF7nS9QCRv4/a7sJw+CufybH24epP/D8kFJfg9Klfmcfd2p2bzrHA73HvdHuKtYEGELf+93pTVkFLNvKPFrNScsosHi/PhwUVcRcfIgrdX+9mC74JaPUFtnE9U1wovGYt5Ssvt7Uaufq+RXKOzLzmzE/70Ro2DYWlErYx7wlsW542sSoam6BtfBzmWIONznE0427yywgbCVoKSULilxferzYZrpPTmd6FWclrw5biJusy3KoksW+UaHwkIckBJ3v84tu73QFUVjlYvsWvWwgpHeOv8NnG9WPp4zly0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation to support Nitro Sandboxes, whose commands carry
unrelated payloads in their replies, convert struct ne_pci_dev_cmd_reply
into a per-command union. A command with fields of its own in the reply
gets an arm holding them, and a caller reads the reply through the arm
for the command it issued.

The device writes every reply into the same 72 byte window of the PCI
BAR and picks the offset of each field itself, so we place an arm's
fields at the offsets the flat struct gave them and name the holes where
another command owns the bytes. static_assert() on every offset and on
the total size pins each arm to the layout the device uses.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c |  6 +-
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  4 +-
 drivers/virt/nitro_enclaves/ne_pci_dev.h  | 86 +++++++++++++++++------
 3 files changed, 71 insertions(+), 25 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 610d98264e5a1..77b15eda8d120 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1749,7 +1749,7 @@ static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
 
 	ne_enclave->state = NE_STATE_RUNNING;
 
-	enclave_start_info->enclave_cid = cmd_reply.enclave_cid;
+	enclave_start_info->enclave_cid = cmd_reply.start.enclave_cid;
 
 	return 0;
 }
@@ -2621,11 +2621,11 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 	init_waitqueue_head(&ne_enclave->eventq);
 	ne_enclave->has_event = false;
 	mutex_init(&ne_enclave->enclave_info_mutex);
-	ne_enclave->max_mem_regions = cmd_reply.mem_regions;
+	ne_enclave->max_mem_regions = cmd_reply.alloc.mem_regions;
 	INIT_LIST_HEAD(&ne_enclave->contig_regions_list);
 	INIT_LIST_HEAD(&ne_enclave->mem_regions_list);
 	ne_enclave->mm = current->mm;
-	ne_enclave->slot_uid = cmd_reply.slot_uid;
+	ne_enclave->slot_uid = cmd_reply.alloc.slot_uid;
 	ne_enclave->state = NE_STATE_INIT;
 
 	list_add(&ne_enclave->enclave_list_entry, &ne_pci_dev->enclaves_list);
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index a07dbc6d8a9b7..8ed2349dea878 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -404,8 +404,8 @@ static void ne_event_work_handler(struct work_struct *work)
 		}
 
 		/* Notify enclave process that the enclave state changed. */
-		if (ne_enclave->state != cmd_reply.state) {
-			ne_enclave->state = cmd_reply.state;
+		if (ne_enclave->state != cmd_reply.info.state) {
+			ne_enclave->state = cmd_reply.info.state;
 
 			ne_enclave->has_event = true;
 
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 4f670c53dd3c0..835413fca8040 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -286,32 +286,78 @@ struct slot_add_info_page_req {
 
 /**
  * struct ne_pci_dev_cmd_reply - NE PCI device command reply.
- * @rc :		Return code of the logic that processed the request.
- * @padding0:		Padding for the overall data structure.
- * @slot_uid:		Valid for all commands except SLOT_COUNT.
- * @enclave_cid:	Valid for ENCLAVE_START command.
- * @slot_count :	Valid for SLOT_COUNT command.
- * @mem_regions:	Valid for SLOT_ALLOC and SLOT_INFO commands.
- * @mem_size:		Valid for SLOT_INFO command.
- * @nr_vcpus:		Valid for SLOT_INFO command.
- * @flags:		Valid for SLOT_INFO command.
- * @state:		Valid for SLOT_INFO command.
- * @padding1:		Padding for the overall data structure.
+ *
+ * The device writes the reply of every command into the same 72-byte
+ * window. A command whose reply carries fields of its own has an arm of
+ * the union below holding them, at the offsets the device writes them
+ * to, and a caller reads through the arm for the command it issued.
+ *
+ * @rc :			Return code of the logic that processed the
+ *				request.
+ * @padding0:			Padding for the overall data structure.
+ * @start:			Fields ENCLAVE_START fills.
+ * @start.slot_uid:		ENCLAVE_START. Slot of the started enclave.
+ * @start.enclave_cid:		ENCLAVE_START. Context ID of the enclave
+ *				vsock device.
+ * @alloc:			Fields SLOT_ALLOC fills.
+ * @alloc.slot_uid:		SLOT_ALLOC. Slot unique id of the new slot.
+ * @alloc.reserved8:		SLOT_ALLOC. Bytes owned by other commands.
+ * @alloc.mem_regions:		SLOT_ALLOC. Maximum number of memory
+ *				regions the slot accepts.
+ * @info:			Fields SLOT_INFO fills.
+ * @info.slot_uid:		SLOT_INFO. Slot the reply describes.
+ * @info.enclave_cid:		SLOT_INFO. Context ID of the enclave vsock
+ *				device.
+ * @info.reserved24:		SLOT_INFO. Bytes owned by other commands.
+ * @info.mem_regions:		SLOT_INFO. Maximum number of memory regions
+ *				the slot accepts.
+ * @info.mem_size:		SLOT_INFO. Memory size added to the slot.
+ * @info.nr_vcpus:		SLOT_INFO. Number of vCPUs added to the slot.
+ * @info.flags:			SLOT_INFO. Slot flags.
+ * @info.state:			SLOT_INFO. Slot state.
+ * @info.padding1:		SLOT_INFO. Padding for the overall data
+ *				structure.
  */
 struct ne_pci_dev_cmd_reply {
 	s32	rc;
 	u8	padding0[4];
-	u64	slot_uid;
-	u64	enclave_cid;
-	u64	slot_count;
-	u64	mem_regions;
-	u64	mem_size;
-	u64	nr_vcpus;
-	u64	flags;
-	u16	state;
-	u8	padding1[6];
+	union {
+		struct {
+			u64	slot_uid;
+			u64	enclave_cid;
+		} start;
+		struct {
+			u64	slot_uid;
+			u64	reserved8[2];
+			u64	mem_regions;
+		} alloc;
+		struct {
+			u64	slot_uid;
+			u64	enclave_cid;
+			u64	reserved24;
+			u64	mem_regions;
+			u64	mem_size;
+			u64	nr_vcpus;
+			u64	flags;
+			u16	state;
+			u8	padding1[6];
+		} info;
+	};
 };
 
+static_assert(sizeof(struct ne_pci_dev_cmd_reply) == 72);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, start.slot_uid) == 8);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, start.enclave_cid) == 16);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, alloc.slot_uid) == 8);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, alloc.mem_regions) == 32);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.slot_uid) == 8);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.enclave_cid) == 16);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.mem_regions) == 32);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.mem_size) == 40);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.nr_vcpus) == 48);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.flags) == 56);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.state) == 64);
+
 /**
  * struct ne_pci_dev - Nitro Enclaves (NE) PCI device.
  * @cmd_reply_avail:		Variable set if a reply has been sent by the
-- 
2.47.1


