Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D01606A339
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=J+NsQIxO
Received: by kanga.kvack.org (Postfix)
	id B21256B05B6; Thu,  5 Nov 2026 00:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9246B05B9; Thu,  5 Nov 2026 00:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C16A6B05C3; Thu,  5 Nov 2026 00:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 711FB6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:01:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A1511A0960
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:03 +0000 (UTC)
X-FDA: 85399866006.01.5A4EF6F
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 45E19C0007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=J+NsQIxO;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QR7+RzYUX4/ytxM/0jS+GRtrp88N8Eh0P5U9HMcYULs=;
	b=iXLH+tIJ/E0/aim9q7CBLDV5D/fXEcM+UO3H6wi2nrFnDubcy1X4xpIsao+6Pvo4YLjeSv
	GHVWf3lJWpVk/g4qvBLFVCp754u5PWxBg2H62Bw77X/kKCn5k2gqg7PfnSmD5BhoAJxJSY
	X4B3475I8AKge8g5zR5iI1lz50/TR+c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=J+NsQIxO;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854861;
	b=v8hMkLgPM0q4jmlRBXTOSSoVlK9G95qs7daJRolJz7l2xhR5H9LtS3kZgu5+57w/daOHjc
	QzqUptqykZs/wdC3IFbzIkYRu8/QcM2d7XUUmvTHpnSQf14AxprvBqs0l7ONUMKTLYlp1T
	FTSTzrXUox4cL3SGYMFJpPj6yIE5Rcs=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5ebf39def3aso509124e0c.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793854860; x=1794459660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QR7+RzYUX4/ytxM/0jS+GRtrp88N8Eh0P5U9HMcYULs=;
        b=J+NsQIxO8n96cEe/O1oPBuvAyZO+HG6SVLRm92hy+L6y3U421uEm0pYU6WeiAv0lHh
         FcdanvdTvtaUs/Qo99mtIPfjc5Ov2DP77nHeTzS7vZ7sC+fgbCa4FHt3CY0LU+qECYGi
         h2wI/3E76wWKbYUJ9BxlzqSleEevTRyjII6bvXoR9yEEi6ZTi9TAGqFS78ECcf7S6LTm
         8ZCxhfg1iUj+6g7N3AKNh1umkn6G3Q6zQPi2jdcbsAtgIvFpY6Mc46jCZBlmuuuEr6gV
         zgae2tih0SEfHnyjqkLElePS1ZnWcSJy2rIyzg8t+POKhtjRYXjVRtJGnh9GSOuRg6RG
         hNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854860; x=1794459660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QR7+RzYUX4/ytxM/0jS+GRtrp88N8Eh0P5U9HMcYULs=;
        b=UsUJsQD1OsbXOV4zk17ZTvSBwPJW5sq92OwDWTf6k75A9CP+i6G/vL/nSb+9vxy1JO
         86sFOZnC6YIAC2b+PJvTDTb0dGYpng1Go5cCqSslQR6qCgO7uQLCm+D/Myxnm1CmPVKi
         T3odpXh9uzOePRABKs3FH8Dnp3armAbutDWkbkGg4aeNlx7SJAuAArrJrjaC+oKlSEvO
         drxv4yL3N60QaSy1UCbZVeD3BshiTSNsoPd+8/fvzfeSFoZhxuc+JccliYfWia149I0y
         ofLFKbln/jWZICKEj4ag30viLsHbdrKGXp39aEnCjm0bheMbBmMvuwJGC/wGZeRK6/CU
         4PoA==
X-Forwarded-Encrypted: i=1; AKwUvBy4YkuQzdI6Hk5bZIZFnB8Qu/hxXJDdcvFdSYzzfHhx7UDUQ+BgOkCv2aO2nG9n9ZYace+wGT61oQ==@kvack.org
X-Gm-Message-State: APuU4Z8hmpXLtZffDxVHLCE5YADFgRnreIme5mu+jPhmi9FSEMn/XOuJ
	dAfqoMtFYoP3Yz9K9ePopbmGOScqKYjdHKcYQ5GyXcnIDo06c1gl+M68jxPp5qz4usBAa585PIw
	TLgBs
X-Gm-Gg: AYBFou1tdaMQhrwj0YyB6GvSIwShyi9og//Zuto0uud/riWoxs8ZAzehJrxq40mVB48
	Rt8rtj3UsTeL7fHyyIqVLvXvHGlV5YsAhF3STYEeJQZM3+sx4IetN0trwQiDSsVi3iti0ijrncx
	2Att3Gn3tZh2WyC7mmxtazSeaqVaVkLKQLAJfB+ysj6/Kwac3rJIn5SWONDqmhBqXz/R6BACRPc
	jgQKVxwFLT44nteSPQ3R6pUSOq8UJ9lMz7aceLB5aETgGwhSQ3TGrNJ8gEEgD1aISN2lSPPbBAj
	yII4e2XqStdi6DXYscpiE+c5qwTqP4SD46zocQqM1iMH7uvBaweQmBKATQhm+nH3Ef3URCLM/nj
	i/ijV5/Jp+MdCLMGnxTRRD6XwZP+jLtiZLCIISrPiSEz1eyL+mpR1HF5fWLISEQAWxZB3QJ4pdQ
	wJQEqVzu6G/fBISEIAeYXBsjN3yi6b3WmQiDShnvuOKRSGwlNuK+do9rDpObKQ7byjuFYeOZLYU
	QUX5eP+mOtjXJeIeaIjXCIgX4TAIy+d8N2OVIzJccMN3NglJKVM2h3hOSIfIwMga2ct2L2vSSX2
	ns3SlK/326h+cIuV4FHs/2ShkslgTvcegRt2i2nndUdbGHYCC5BCoGYlGGMpLY5S4IUN2fNLrD9
	KMcobMslC2GkI+ST1cnp3yJLA1/fWF+MLBzi2fV/1yj5FFbw+qg==
X-Received: by 2002:a05:6122:512:b0:5da:9b81:1aa4 with SMTP id 71dfb90a1353d-5ec6870c946mr7158777e0c.5.1793854860291;
        Wed, 04 Nov 2026 21:01:00 -0800 (PST)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d9d62bsm3305282e0c.8.2026.11.04.21.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:00:59 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v5 2/6] kho: support incremental entry publication in kho_block
Date: Thu,  5 Nov 2026 00:00:48 -0500
Message-ID: <20261105050053.3063001-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m387xhaa84cdo43eb7bi55qp13u4oggk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 45E19C0007
X-HE-Tag: 1793854861-305785
X-HE-Meta: U2FsdGVkX190YXmA0plOpgLnwyUfuLxS3p+y5RNUfyjIkywjvh64h7nohua4gjIE7naHig9GZ+oSaeg+cYPmoByBTRjsVtsZVqVJqnYJkdKJ77MKMc6cah9uOQLPsTfXeQvQEP71tq+sgKB8+wXGJr6d6q9xudXQWGUTn8BIPBB91bQlpcqPFwtR1s9hbBiqCUyQGyJO+IJYyeAgHUh17xTqI2m86jCknU1q57han7haAuu6ERodTcS2zja5oZhlRR+GMVA7FUnHs7G2S2hfD3j6447WYV01NEocotaW0sOksoV9UgLgP2fJ45LAgkPxQgc2SYp7ot/K7Agjy6SiM0gFkFih+t3fGe/JqpLmOhtTc1+WgxzuL2zYivjVltg8FG1bC/ZlAU6qvg8KBD7gq3BOfRhOEW6e4zEKn6umSEheEHjAyOMBx+PV9dSe3H8l21f0q0gf6dDIQRnHeG6T960SVN7ZkQ+72OGs3Gme4ZwXFZYbhbTX8KN2LG4fOHXDc++BjUh2oONMzULczCW+pByAP8SHqhAPiKtcUq6SrGdgR01iVaReCox6uFhlFFSm7D5ifapQ1b6u3xHhpgSwdU1x8eer8ykcZk3pZvZgn8GRre7uVZKrjqAFnjDFMq1wyUSWZSgY+eiW0iwM5gVXH3TRDnQgJkPXAiZwNR+7N4buEyyZ5EdslNpXx+8B8mzpixHrWK9L3jvfu3EZIIM/oIwyQtHW/EwMljnCxu0Z8vprse2ZjabQTTxubNkgNWFeteDkkqDxlZsatZHheKKwN2aw627heR89s0BlHPtV4dK/cLwsKLxY4XYWOCjE0o9dY11Z5sqcj3lEYpKtmXFRPkVpz/8j4SGtfxXE1fsAtdB/Pep3Tg8rdPJmaFDhOZGcgH8XnVxI07pUTl5H6bos4PcxCDIgDTS898IfkvhOQHLIMR5DPSErM434VPfVdbCTteiJnVRI6QNF9PAL2Zn
 dYqfi+tk
 zWmW0ElmLvKufPTBN9CxWm9HoVlOIULTpHypEdJkkjSBX25ZJpXIekMDLEnfO936jC6Z519ThdaAa6MoYS79JX5cQ3HEchgKAJRVFsfgQc9Jrzo2v9R156Av+mZch9I3HHGBSR8BQo5V1wSsv83XCT8cV8zwCXAVdg45BpQtocWLScV5y5pEa4/k16ZpHeYgT9dauVG5ktVNp76imZd63NFQYOWkGsrtGEsfJM1I/YSy5fPD0jkc8mj7zkJi9u9zySjM1Daq6/IGX2aLeuxPYPjPutPBCcPXpWAiMlt8v0kw+gE7KtS+eyky0NLzbFBszItPJdM3GJvETwO6elxrBBBrQSj6eoUQFSdgq4xAPXgrvKPhNNtbF8woVgTbpvMDtQucR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

To allow LUO sessions to be frozen and committed into the outgoing KHO
subtree from userspace ahead of reboot, kho_block needs to support
publishing entries one by one into a live serialized block chain while
new blocks may still be preallocated or shrunk for uncommitted sessions.

Currently, kho_block assumes outgoing block sets are populated in a
single batch during reboot() before the chain is exposed: preallocated
blocks are linked onto the chain immediately even while empty
(ser->count == 0), and reserving a slot increments ser->count before the
entry is populated.

Address this by keeping preallocated outgoing blocks unlinked in
kho_block_add(), linking blocks lazily only as entries are written. Add
kho_block_set_it_append() to copy each entry into its slot before
publishing the updated ser->count and next-block link via
smp_store_release(), paired with smp_load_acquire() in
kho_block_set_it_read_entry().

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho_block.h     |  1 +
 kernel/liveupdate/kho_block.c | 86 +++++++++++++++++++++++++++++++----
 2 files changed, 77 insertions(+), 10 deletions(-)

diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
index 93a7cc2be5f5..a9e696ef3e08 100644
--- a/include/linux/kho_block.h
+++ b/include/linux/kho_block.h
@@ -100,6 +100,7 @@ static inline bool kho_block_set_is_empty(struct kho_block_set *bs)
 
 void kho_block_set_it_init(struct kho_block_set_it *it, struct kho_block_set *bs);
 void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it);
+void *kho_block_set_it_append(struct kho_block_set_it *it, const void *src);
 void *kho_block_set_it_read_entry(struct kho_block_set_it *it);
 void *kho_block_set_it_prev(struct kho_block_set_it *it);
 
diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..2813c6fd593c 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -16,6 +16,12 @@
  * array of serialized entries. Multiple blocks are linked together via a
  * physical pointer in the header, forming a linked list that can be easily
  * traversed in both the current and the next kernel.
+ *
+ * Outgoing blocks preallocated via kho_block_set_grow() remain unlinked until
+ * entries are written into them. Callers publishing entries incrementally into
+ * a live KHO subtree can use kho_block_set_it_append(), which populates each
+ * entry before exposing the updated block count or next-block link via
+ * release-store ordering.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -93,9 +99,7 @@ static int kho_block_add(struct kho_block_set *bs,
 	list_add_tail(&block->list, &bs->blocks);
 	bs->nblocks++;
 
-	if (last)
-		last->ser->next = virt_to_phys(ser);
-	else
+	if (!last)
 		bs->head_pa = virt_to_phys(ser);
 
 	return 0;
@@ -129,14 +133,15 @@ static void kho_block_set_shrink_one(struct kho_block_set *bs)
 	last = list_last_entry(&bs->blocks, struct kho_block, list);
 	list_del(&last->list);
 	bs->nblocks--;
-	kho_block_free_ser(bs, last->ser);
-	kfree(last);
 
 	new_last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
 	if (new_last)
-		new_last->ser->next = 0;
+		WRITE_ONCE(new_last->ser->next, 0);
 	else
 		bs->head_pa = 0;
+
+	kho_block_free_ser(bs, last->ser);
+	kfree(last);
 }
 
 /**
@@ -144,9 +149,9 @@ static void kho_block_set_shrink_one(struct kho_block_set *bs)
  * @bs:    The block set.
  * @count: The target number of valid entries to accommodate.
  *
- * Dynamically preallocates and links preserved memory blocks if the target
- * entry count exceeds the current total capacity of the set, ensuring they
- * are available during serialization/deserialization.
+ * Dynamically preallocates preserved memory blocks if the target entry count
+ * exceeds the current total capacity of the set, ensuring they are available
+ * during serialization/deserialization.
  *
  * Context: Caller must hold a lock protecting the block set.
  * Return: 0 on success, or a negative errno on failure.
@@ -318,6 +323,7 @@ void kho_block_set_clear(struct kho_block_set *bs)
 	struct kho_block *block;
 
 	list_for_each_entry(block, &bs->blocks, list) {
+		block->ser->next = 0;
 		block->ser->count = 0;
 		memset(block->ser + 1, 0, KHO_BLOCK_SIZE - sizeof(*block->ser));
 	}
@@ -348,6 +354,7 @@ void kho_block_set_it_init(struct kho_block_set_it *it, struct kho_block_set *bs
  */
 void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
 {
+	struct kho_block *prev = NULL;
 	void *entry;
 
 	if (!it->block)
@@ -356,15 +363,73 @@ void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
 	if (it->i == it->bs->count_per_block) {
 		if (list_is_last(&it->block->list, &it->bs->blocks))
 			return NULL;
+		prev = it->block;
 		it->block = list_next_entry(it->block, list);
 		it->i = 0;
 	}
 
+	if (!it->i)
+		it->block->ser->next = 0;
+
 	entry = kho_block_entry(it, it->i++);
 	it->block->ser->count = it->i;
+	if (prev)
+		prev->ser->next = virt_to_phys(it->block->ser);
+
 	return entry;
 }
 
+/**
+ * kho_block_set_it_append - Write and publish an entry at the next slot.
+ * @it:  The block iterator.
+ * @src: Entry data of size @it->bs->entry_size to copy into the slot.
+ *
+ * Copies @src into the next available slot before updating the block's entry
+ * count or linking a newly occupied block to the previous block, so concurrent
+ * readers never observe an uninitialized slot or an empty block.
+ *
+ * Return: A pointer to the written entry slot, or NULL if the block set's
+ * capacity is fully exhausted.
+ */
+void *kho_block_set_it_append(struct kho_block_set_it *it, const void *src)
+{
+	struct kho_block *prev = NULL;
+	void *dst;
+
+	if (!it->block)
+		return NULL;
+
+	if (it->i == it->bs->count_per_block) {
+		if (list_is_last(&it->block->list, &it->bs->blocks))
+			return NULL;
+		prev = it->block;
+		it->block = list_next_entry(it->block, list);
+		it->i = 0;
+	}
+
+	if (!it->i)
+		WRITE_ONCE(it->block->ser->next, 0);
+
+	dst = kho_block_entry(it, it->i++);
+	memcpy(dst, src, it->bs->entry_size);
+
+	/*
+	 * Ensure the serialized entry is visible before exposing the
+	 * incremented count to concurrent readers.
+	 */
+	smp_store_release(&it->block->ser->count, it->i);
+	if (prev) {
+		/*
+		 * Ensure the new block's first entry and header are visible
+		 * before linking prev->ser->next for concurrent readers.
+		 */
+		smp_store_release(&prev->ser->next,
+				  virt_to_phys(it->block->ser));
+	}
+
+	return dst;
+}
+
 /**
  * kho_block_set_it_read_entry - Read the next serialized entry from the block set.
  * @it: The block iterator.
@@ -380,7 +445,8 @@ void *kho_block_set_it_read_entry(struct kho_block_set_it *it)
 	if (!it->block)
 		return NULL;
 
-	if (it->i == it->block->ser->count) {
+	/* Pairs with smp_store_release() in kho_block_set_it_append(). */
+	while (it->i >= smp_load_acquire(&it->block->ser->count)) {
 		if (list_is_last(&it->block->list, &it->bs->blocks))
 			return NULL;
 		it->block = list_next_entry(it->block, list);
-- 
2.56.0.398.g882cbad275-goog


