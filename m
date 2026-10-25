Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BAB606A324
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qhcdnjSK
Received: by kanga.kvack.org (Postfix)
	id 0008C6B05B0; Sun, 25 Oct 2026 12:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF39B6B05B1; Sun, 25 Oct 2026 12:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09676B05B2; Sun, 25 Oct 2026 12:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5E9D6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:47:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01794A8149
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:47:01 +0000 (UTC)
X-FDA: 85361728284.24.DD5124B
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	by imf21.hostedemail.com (Postfix) with ESMTP id 500F21C0006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:47:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qhcdnjSK;
	spf=pass (imf21.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792946820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OfgFlzGjw1v4HVRSf59nbvbgqbjgCU9X1s1eTDVI2XE=;
	b=6MYqRIazKjSqSarqWuTq4rtaL5Cm4zoG39sPwVa7WTDkz8dwVYPI2PCOtO4nHe8JPSRREy
	jEBoca46+v9z0JADzFN7E0+Ay0goHkIE4DZOk7x95w+FXW4Tq5hDbBJBUGQxiNeyUo3YDf
	UvPXfyIeJNmwQD7kHPjPLPcsxvP4xCg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792946820;
	b=b2r2QwUhjABd/aqQAvf7TmgRzYP2o/zjnmdBHwxxIQLWVHoNfMjFDXaTkFwPAjraTpcGZf
	i5aA6W7MgFfOa/hzonvcJE0h17xcyGiZL+TjDSuVl6MwNZ7d2bEI8tq2gOLH1W2RoZJDuJ
	TzbJYU3X/uG4zr1Vb+UCQqyBu51nl5c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qhcdnjSK;
	spf=pass (imf21.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-35829219da8so4137686eec.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 09:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792946819; x=1793551619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OfgFlzGjw1v4HVRSf59nbvbgqbjgCU9X1s1eTDVI2XE=;
        b=qhcdnjSKxYwt7U/0cjm4//0GOc8hJrleMj4PY8wNs4vXsEXaIzfKkYW6BR5JtUUkx8
         ZmapWloKAQRt1L10QuL7MDrFasbSrtQLG9e/7DuG9Dwa8IEHvbXtznulA8FDzOyi4ShC
         fnK4rvn7yIvVjC1Lhom61PiR7WR3F93QhpHN1YHm1TiwuS13VbcKmCVWMlnhqWe1fK+W
         eXg2i1+4vN80arDz9ypOBJNHppSVbF/Nk+FsnPL46gVj2qFsz7fjJUnzHIPo0lmfA3d/
         GTkXeWDFJ7m82uMhWc0mI+Ukg9OX9bwzBOWpx8G68PtvecgEkIpW8TsPYwlC+ouBOWTA
         MoQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792946819; x=1793551619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OfgFlzGjw1v4HVRSf59nbvbgqbjgCU9X1s1eTDVI2XE=;
        b=K4pV+S36wpF+XZ0aLJsZpsANlY2jKVgIQvk4xulAHPVoxk/45wyJTK0GYQYwpCi4gK
         iEUrIR9Ia/00ck+EIH578pkdUckZmJOy9tKYV7HuEp3TTAyS8oqbWzVW9533hkklalsI
         7rYIHSyCl11hwx9Eco6NjSOapj/jP6i38FJ/LHL8qGmgEV8ECtYs0OsrxMxljXbmIqbL
         97luNlxNASit2DgtGQZmclxHH6jA4rg/5SCXHxABiziKVcXz1zRa3Cnfylt0xfuKYxiK
         jBujbhJ6LCxQE0TzvXT5EAxVEuLBgcwfK27LHSVz1TrCtQRKxREU19/TRe57cZhduY4o
         6dHg==
X-Forwarded-Encrypted: i=1; AKwUvBypdtCy90wfVLaU4YwquYjMcs9AOBCyO8NgFCNK4g7xGmn1vIvVONRtdVvFWqpB5S+DbJWTL44/LA==@kvack.org
X-Gm-Message-State: AFq9FYKxN7rTK9hKX0ASoMItKjq0BssSy1OB/+4UkqLhnrYPfyespSjP
	vO/pyG3/36URi1CoU73q9Db9SPizy6WGe2GWEm9e89umnMzr1vicq+HO
X-Gm-Gg: AYBFou2MvzYltJ9/5Tu8Fnw//7wnzxWh8McrwURNP4/1xIgOHQQ9RuvRCmLguySiUHj
	c3c3+zw9apHvovRB+rTa2a24eeJCXRjmGBCipADfTXrCQIFBNMd04S+NoE5iHkTuv8BJr6mJa94
	vAOe3MQe3A1L9/sA4u/lMro9kQEIivxr2dACdViYyAL0SdZK3kiUJoH9kQpk/dPoPA/T9810QmO
	NP4K6D7H7kiVFmgLyL2kSlE3X80GRDJIebvgc4Ap14o8b+7+SzSLOlIqHsLkKk7ESrbywH//K4k
	LA2avMiPncKF3+0nmt1JmWBa8buDR5qVAkNPYJv22P4NKVQmt4VeS5XRNNqQtahyvmA1d9C6n49
	9z+k3aihWH9D166BrNeQyOilTPMcsZ1Y7MDjjK91sbYh42fZ3tjw4qtTDDlb0YVvXZTVa+MOIxL
	Uz40Usl5m7GGILgtJiU7XXG8XNeQf/BnUc0pK8CCLlzLipHXOKJr3dZSrrPhqDSzv1EDkn6o5w6
	aEiGHzGsQAuxfSrXUHwSUAEz1izv0ZoVYkZYgTiXtZDOtaGOWcYmAFlerxwXzlmPIah6C/5KbNI
	5OXhLCI=
X-Received: by 2002:a05:7022:439f:b0:155:734:9cc9 with SMTP id a92af1059eb24-19935be7f99mr9441348c88.16.1792946818717;
        Sun, 25 Oct 2026 09:46:58 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a0d98660sm18320531c88.9.2026.10.25.09.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 09:46:58 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] shmem: do not extend i_size when no data was copied
Date: Sun, 25 Oct 2026 16:46:19 +0000
Message-ID: <20261025164619.89992-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 500F21C0006
X-Stat-Signature: b3xh3r1ey11u3pzdjrok5z58ab4atday
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792946820-818481
X-HE-Meta: U2FsdGVkX19BnXlrMMZom33hVPDvkjxe0CFiUmaPbTKDD51X5o9zpvTzHtWlNwlWnr65CONAQlzrFWBXOH9Zj2ddfI2mO54SnOjry0RpKKwQPPWlDx7sVGUX4y6E+/oBrbNESWp8MhLegkvPXVqZsVIASep0VH6tfK9SQ0ejmwKki5MHOK2yz/6ToQMoUX6uPY5P7+FXebcpbXugpUkwu4tIXbdquAujgvG1XMKiarZJIb1+EbTlCX9W5+aeI3SnKgELS8+0Ve43xZGX9qygz6D2pzp4ixMtHtJl5vUOBDZV/u9cGq00rA+Jb/d+unVRIVC4RlY8qsIu619DK+HunyuI+Ozs8shqd0aBOPF9acAvng6NklHmwIQAlhGS79IY3fqyLhNWh/upKWWZp+kRkOu7w02HmaNMU3/WKvo4Xlkh8Ied/MwlNnuMjgOc7+lrqdup4AC2e8TcseFMyQ46EaGzx00euAGjst/UvglDsW4dfkdKmt3VV0MoI7TZfed74UWHLJixCOBxeM/zlBRsCIJxkx/EQrlpRt235IlVP3/7vmvpZYxvcv22t9Z9cif/x3+7ZwPz9ZwUUTclmC7AzMYyrm4tkhJPCX/vZoBIvwiab5FpdvQ1gOtoOtp0VW6KcYm2GrHdXnqE+Un6AhvKhBpyP/fURkXYhhwQrnOmq4NcFaWe1NamOEsnF7LvBoXPfzV8I7VWConWQucvBBu6MVBoGURuTMswVQCELTVekrXNwgCAJEPW/n1qFLrlWV0mYW+f9x37Lk+/1hns94lnM9JZ5hXZH6PGT7DbWuhsLDDFuJzfE00lmBSL//v9xQHYTrmD2zEeJi02Si03/G6el/ScrVOtXXwcspmmxj392hyUwrZQXI21ef77v3bvB9HB+9M47uPX1Jp8G4Zks8Dh9as2aorKmbgzr/VIkCNSPsbF/KcL13tcZCtYDos6q9L9YET0nE5vE0WzPV/LlSV
 MyMWiMn9
 bDf/yY00MhkgE8sM56miv8k1yfV4MLfuawbYbvOdUbIz/6zYzgmTIWO+U8S4rTtOnQ2RLmIvNN9qd0sIbr8ho/XNfarbsvqJbeOtphWqPJXiaCz9Ueg8y8TzMnRuUVOHDoLTQzfkxUC+GL2/PKOX9Bwt2ZETZ7zZIqs26Ha7sW0QfEdpQg+iAwiZlEpniylcsehfI0gUk13JbnbY/c+uRgcDyFq0oR6tZymRSvv9kT99g7eK69haDZJrE+e8gEz5tASqbOzUswD3sDDrJv1wb0maoazVv/TDj5EnRklsI2Mlv22pumKio6xHrlxgbr9B6SRFZXyNT5Wy4BlRj2ecrvWNH5YV14Nz4V2yRBMq5Nl8u9OhhF/JIuBSLC8DLRojWsTT9Ra8ulbnQs9mBwJEBU8UxUm+jonO+YQO4GMbGvTS+UEp+AgZt31KURO6ePtYDlA5oE92EdU3xhchIRIG94GomD3Ni0tFoPn/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_write_end() advances i_size to pos + copied even when copied is
zero. A buffered write past EOF can therefore extend a tmpfs file
without writing any data.

Moving prefaulting to the slow write path makes this easy to reproduce:
a one-byte pwrite() at offset 4096 into an empty memfd, with an unreadable
source buffer, fails with EFAULT but leaves the file size at 4096.
generic_perform_write() calls ->write_end() with copied == 0 before
trying to fault in the source buffer.

Only extend i_size when data was copied. Leave the existing folio
handling unchanged so successful writes, retries and preallocated
pages retain their current behavior.

Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d97fc32e7c94..55287c370c73 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3487,7 +3487,7 @@ shmem_write_end(const struct kiocb *iocb, struct address_space *mapping,
 {
 	struct inode *inode = mapping->host;
 
-	if (pos + copied > inode->i_size)
+	if (copied && pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
 
 	if (!folio_test_uptodate(folio)) {
-- 
2.43.0


