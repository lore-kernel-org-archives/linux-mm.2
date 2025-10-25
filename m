Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB735CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80AF8E0121; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B100B8E0129; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8541D8E0121; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B80E28E011F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A11C13C5FC
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.26.5DE5714
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id AD24F8000E
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWsGokmqjcqQvT8fkJn7IgoSOkYs3SDML8cDQLbAgh8=;
	b=cEhduXkweWw0mCBlpmt8WALzxYR8I2R9YbF5qGRT8we8FdI6BBDK4zJgLuyT+M3mb9vhAc
	we/TjsjQlzB2/jBPoVF6XTyKtHNd5YTjmdisP7NYyKu54pr1ej8LSeXHQ5katWK2f7D/lE
	T/Mq+/ALxIte379GmZ9gQ9y5S8EttPI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=iD9JzSjmL+Xz3CK2nxxtclJr6zVtYNz9cpZ/f3fdWcgXCytEEji+SujGVjExcOD9f8ubca
	AQgEB6nzFOk5wTzVLXSXoSW8WPqWWg/zly4lNOqQWZiYI3NK4z6jAgph7UecrMSNGAZWlT
	lNzH16UR8K4YsQ0BtWDPe8GB5ZnCrGk=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcJ70sHzYQtll
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 9F0D21A17DD
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S7;
	Sat, 25 Oct 2025 11:30:03 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	kernel@pankajraghav.com,
	mcgrof@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	libaokun1@huawei.com,
	libaokun@huaweicloud.com
Subject: [PATCH 03/25] ext4: remove PAGE_SIZE checks for rec_len conversion
Date: Sat, 25 Oct 2025 11:21:59 +0800
Message-Id: <20251025032221.2905818-4-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S7
X-Coremail-Antispam: 1UD129KBjvJXoW7AFW3CFW8GFW5JFy8urykXwb_yoW8Ar1rpF
	43GryUGrWYvF1Uua9rXF45Ga4Skw13Kw1UJ39xW3yfWFy7Wr4fXr9aqFyFqFW0qrZ2vFWU
	ZFs8JFWftr1rCaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQ014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
	v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
	67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUo6wZDUUUU
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I6QABsG
X-Rspamd-Queue-Id: AD24F8000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 71yo8rq6rhj64fueqpznf9d5u9u36ejz
X-HE-Tag: 1761363008-306571
X-HE-Meta: U2FsdGVkX19vGU45zg7YORFHw4kJt5VkT2zY+Jn1OCZYpJWeAGyvmTRDE9QJFjKKCIfnvQYQEPwpEu62KkK4ZM/6cToh8gAemP/uOJJoFihP+0KSvx9N56OGJpRUeEAHAYMdqQI8r/9RcI/48MEzGXnOd/qEqg3jefiiimjmVKgc8WP2/zkWCaruUFOtfo1TQ2aZqJO1FAZO9osqo07CgXRdB0ii42mbsUgMXWbSKxkNyue/lFyAMocDyDvIFrZWPiiKtZ78r0Qk2kRjQZNmG5Yyf8zcVWZqxumxAUgNxVCf7IIqejrWGV3CLQChjXiDIiFy7tMQLRM1UAG1+sf5D2tlwMglOBHWeSO+WTi9hI++pngA3XAV5xjbhWXSCqIYhXmTrqdjhfiM2ib7asg8sx+dzTxuGCL0pOIO1fyuJF95sMLOnWCpAZNrWu8KrMfZL12q6WsYqAIpga4kvZHfSyCtbfMJVEzERXl33yzFdZHpZdtBLVeNMWt0J2B8zBnqqUzgSM9Bm3rtplmAFA1hfLaUltOj3wpGlJ8k07lRQDcv6F/Pz76opGEhFJvFa9DFuVPEy2LRlbe2mmvB29sPaSY/dEO8wRihXZFr4r1LYPQkL2rCYHxalONcYp3Ilh2wYQm3lMc/liVEv2ZPB0EWiaM/XCJ8NmOUtnZckSa3wzxHMLNDTT12uV4XH32QE6dBVqtcoRkLLeBAndQK6TMXhS6F6jMvr91ca05MzEHQ2WG4mQnvkkB7mDuNE9XNOvvVq2U+QmyKZXK+DcsORRSc22ZvR1jRz3nPErZ4IIyiGgpCDZyatA+teLrcdr/e4X0/p4q5xd5r3GVyTgewIBlwBiIStsIIf0ctIijOI57wN246/ZJbAyjr8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Previously, ext4_rec_len_(to|from)_disk only performed complex rec_len
conversions when PAGE_SIZE >= 65536 to reduce complexity.

However, we are soon to support file system block sizes greater than
page size, which makes these conditional checks unnecessary. Thus, these
checks are now removed.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 24c414605b08..93c2bf4d125a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2464,28 +2464,19 @@ static inline unsigned int ext4_dir_rec_len(__u8 name_len,
 	return (rec_len & ~EXT4_DIR_ROUND);
 }
 
-/*
- * If we ever get support for fs block sizes > page_size, we'll need
- * to remove the #if statements in the next two functions...
- */
 static inline unsigned int
 ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
 {
 	unsigned len = le16_to_cpu(dlen);
 
-#if (PAGE_SIZE >= 65536)
 	if (len == EXT4_MAX_REC_LEN || len == 0)
 		return blocksize;
 	return (len & 65532) | ((len & 3) << 16);
-#else
-	return len;
-#endif
 }
 
 static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 {
 	BUG_ON((len > blocksize) || (blocksize > (1 << 18)) || (len & 3));
-#if (PAGE_SIZE >= 65536)
 	if (len < 65536)
 		return cpu_to_le16(len);
 	if (len == blocksize) {
@@ -2495,9 +2486,6 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 			return cpu_to_le16(0);
 	}
 	return cpu_to_le16((len & 65532) | ((len >> 16) & 3));
-#else
-	return cpu_to_le16(len);
-#endif
 }
 
 /*
-- 
2.46.1


