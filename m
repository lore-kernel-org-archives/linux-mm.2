Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670B6606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=negMaryd
Received: by kanga.kvack.org (Postfix)
	id 69CE76B0859; Tue, 27 Oct 2026 13:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E096B085B; Tue, 27 Oct 2026 13:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CED6B085C; Tue, 27 Oct 2026 13:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 337296B0859
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:18:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCD321C44C5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:18:08 +0000 (UTC)
X-FDA: 85369064256.17.8F38E5D
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1316A80004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:18:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=negMaryd;
	spf=pass (imf02.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793121487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DSKe54xygzfIMrfbOu4GT1R3mhAh4FYjH40dbhhZJR4=;
	b=Y0Ec72TZEPIcWWXXUzIZkse4EUsmzGhEHOT3EZ7ZLe52VUoC7fpxuRjKnR9S2D7eRcSBZ5
	t+rJp90mD9BajJcVltJ4lZbCY8US0s/e0tl5f1+57EWhko2+89kK2nCa18eSamIdpctK4F
	CEHiqNjCpnTX4VoQ6aHaIPLA7ShGRZQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=negMaryd;
	spf=pass (imf02.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793121487;
	b=icv4yzfaH3IW0jlS3+2VSXhYBz6ZUR5rYAr8nCJtBigpY00TNX+OPWCaTgz0OtzSzWnBw+
	TUi/OOHtffQMBMaouLdvZ21Poj6bbW7KSQs0WqSaYFJJtgSBSNd4RF7M/VJgwGMa7cGaRv
	Ly0W0ysjaAinTLEbZck55Sb6frncM20=
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-36888ae05e7so16689eec.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793121486; x=1793726286; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DSKe54xygzfIMrfbOu4GT1R3mhAh4FYjH40dbhhZJR4=;
        b=negMaryd3MZ263o6NIRGZYeMr43bK/77Z/mjnoytrQVjN1xWcP100ZkGrzoszuCa0a
         ezzNmFXoaG2aLygzvg0SpFYbLlqWXc0Dvehnk/0mgWcDCfRcgwS+o2qcdTY4atbQzcka
         ZIxjYJS8/tftDVq0brh9z5vJchq3kJaBBCpaCNhirbzbay0saTBieLYLVO/BFFJsOs+z
         oNcV48WmfGuLEt+YRWDkXiX1lNIuMCaF8NC7+64DkAu54ovxev0CCGTAQEqVq9Ik2J2K
         b6rPzP0yoUx0BOXy+l5IqAKY8xCERm7qO0wjt9cmmXtNU1uYarmmg2/0+c/aatXo56l5
         ClEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793121486; x=1793726286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DSKe54xygzfIMrfbOu4GT1R3mhAh4FYjH40dbhhZJR4=;
        b=Pz7y8UV+iHd1R58abRL+xanSliZVCZFQNX4pHHkIZp68QqNTqksxGVaM5u3GivH4xR
         PL4T621b5avlK0Ml9mMM4Jl8z+MQEnF1ADKDQqVh90/VuJnFW/0njU0zhzPPHTRDPAiW
         QBbP5VTgKbPUJARlw/QNvrOZiRXrQIVytlk5BL1MgIiOugb/dKlVC9748qsZ54zkntd+
         hKlr5bD4vuB2N8sUgeIUZzRCFCyHguPBWNEUiL5oxHC4MfWTBnyQk0D16CduPuFCuOAr
         JFekJoP3w0lgu7/Xl3/jLAe74EhTZXqgLMN88+h5e9R+fsOpIDe09yGUgFia+UiEapuU
         k3yw==
X-Forwarded-Encrypted: i=1; AKwUvByJaEhxhncX18zJfo79n57IQw0CxN5x+TA8rSurrS1wGbCG5EUvQWgrA6biKXJQj3+54Lk3CaGGAg==@kvack.org
X-Gm-Message-State: AFq9FYLNmAt3gRhzl/OpJB1BIRjup94RDHMmSShue+u0/J2gpPjYgoFW
	XyenZqsuvDDIIplP++Icj6vpo0LhKuZc9/V+DqssHsdQVNBLqfsWLxQJ
X-Gm-Gg: AYBFou1VPDlbYlBTiltgsLmBkwjIXjSN8QK97hSZwXR5refHdiMfgqzAJy3jiWBm98P
	/N+AXR6+cpoVroAZJwd66ddqZ6Sx12c1n9b0DYzD3iZOUsBeRDbpIN4KwLymp3gh1g6Vu+QfKrK
	eeuDW4OVPGxROALdX+1ypdrgWs7PeU0wkwqvBwCkgE6ngG/xeImyNtBCJZv8nVViUEktvAHwOZO
	LENrasLhgZblmZttXJ4EbrC78SGLa8EzAYQm9blDkDp8/ZpohADoyhWTKrDvYT/KlU+a4QecuPA
	Ef30X0lZUYc5s3qluMLpDosbLFQVdEWScO3KZIkRp5k2H9xUf0SHJGhIVFIcXXErpQtGR3Zws6r
	B1TxFzLnqNe7wmjc9z1ywaKInKl0CfhzO2Y15ogl3JSDOvC/2pVDXaTYuWg3cbZEMVmDqrD5tsY
	w+CeJPQytukX4bjq+QJH9KJ+tmNompUdDaWhgl2SlXCge0EiFCk0yIvCWo10RbimxnqBrLTrJY0
	bspB6S+VoCoUTXUx8Tqfu7OBkD7hs4unNsbqM0g6zE6sHFR8al0GEKN8MZlTDRGVbplRAmaEYbF
	D6AKSAY=
X-Received: by 2002:a05:7301:5401:b0:36a:1c46:2766 with SMTP id 5a478bee46e88-36a1ff47835mr206467eec.3.1793121485643;
        Tue, 27 Oct 2026 10:18:05 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369f4164886sm29167152eec.7.2026.10.27.10.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 10:18:05 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] shmem: skip empty unmap ranges when punching holes
Date: Tue, 27 Oct 2026 17:17:53 +0000
Message-ID: <20261027171753.1485-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1316A80004
X-Stat-Signature: ukritn6kh8xhzrnjnjhfqbjugan7feh3
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793121486-683922
X-HE-Meta: U2FsdGVkX1+yG5xKchtRC4MpgNquzS6B0r8XIDMWWRgLQ0QSnhH75JsGIMyQUyxwr1etpxaOSXRX4jNXF2LM0/S77JYLRlF5L8qswfGS4MGBPiEv9nvdXS2zQc1uAg3eI6ODZ9CbVWvNpcmd36uO4OGMcr6hmsl+eDrwXOPvFVjO3sB0HtzSn27xHVVawaxyp3t8P/twYmNLpkkVp6u/tNHOKnxk7RjcTtPghzFH+L4FSaSa9KboPMoraduNWsO/jG8F8l+x/6wMvR0X5lLCfmDrgtGPzcSY4EcZz/jAE3r3ZVKU4gmqaJ0XHQ5QOuT4fADpujW98LTcMZZNH/WN6bfrKvV2okawf6sbAbH3tsiBVL/plTvASB+EjVf6u588LuNjQNgPmtAY09JBcwYUvCKf9Cmv7nZAaTJapE9X4qg3Hqen8L/4DuAcwYSLerj04eKMwqr3D5o1zt7vPO+woWIgXoQwDbx2RWbHv84uAjrmtvP/P6l6knkxUnihd6xONVCSTO/DYywxbIZCoMC4upoIyZDlrAlvV85VlmuMUCrqd9gBpgnybHlBDJi4vkVXRHryLooLAkxzfqpQlN6KJRQv+Rue8erJRiBl9+c/Kmlwa3YBXCLWr6244iGGj6E4tUKhOJ4W+LVYOV8c0YKmTKmbdJVQIUsYlC8IvJVRgxNHOMfMgqI9uAdl7DnFrfYj08w3SclUw9pUvZ4DtGTrRaImmZ3fGcrAkp2zdHgSGVmAmkXIkzWrWaQcPjCHtjfhT/hItyeKKtLaGRB6+scxsujtZXEII4SGr1UKWwik9hONcyrc0h5QuAwHBEyaqHSioZiNY9lUZcd75YKwWJBGN0MzrIeiNmIpG9l9pgtn2P4jLNkvPY7hZ6AwE5dyGTe+29225IOBEQVcCfcZ7XBODIRZGhSyYDxXlY8wldJVLLWaut0IMvOyGmqCIZV1XDfcNmmheJPb3K/it71EgoA
 RfDZZ3vV
 YzPWkBkZ0a0o9ZTC+IeRauaOH9AwVyXxwuAVfd2OXvD5pF7gBJ5y5oy8ICfCnQqWiIXS8JuPVKsVf70rBtZ3O03l/VaMGHGYXXMA/MS9c4UKgVsHpEUQx3hMpifaLZ7BR1HpWPDhry0UTqG4XFA8JCJbHbBsg9TqnZc1A5z9bu3NgZmXqRam2VPA1yT3aFUXHgDcBhGv7GquSB0UWRGATZre9yHOQDdTMjA8tfXqotUlpBne+dW5+wiappRwe3ZtcZNQBmBMh029AaXsUuKu7sMDSIq2xSNs+PjJofkD2FyjB5gSh7uouQuXgIuWh2L5VpQDljSp3I3IjDoZ/fnebNFVuXs2cioaysLntI/MARuwl0NgObUR1t/DLBIC1LJD3oiG9ulQhYIjA1tVHyJyn359hfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a hole ends within the first page, shmem_fallocate() calculates
unmap_end as -1. Casting it to u64 makes the range check succeed even
though the hole contains no complete pages.

For example, punching one byte at offset zero calls unmap_mapping_range()
with a zero length, which means unmap to the end of the file. The file
contents are preserved outside the hole, but unrelated mappings are
removed and must fault back in. This can be reproduced with fallocate -p
-o 0 -l 1 on a mapped tmpfs file.

Compare the exclusive rounded end against the rounded start to skip
empty ranges. Keep the unsigned comparison so rounding the start near
the maximum file offset continues to be handled correctly.

Fixes: 83e4fa9c16e4 ("tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d97fc32e7c94..08d5336c27a0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3864,7 +3864,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		WRITE_ONCE(inode->i_private, &shmem_falloc);
 		spin_unlock(&inode->i_lock);
 
-		if ((u64)unmap_end > (u64)unmap_start)
+		if ((u64)(unmap_end + 1) > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
-- 
2.43.0


