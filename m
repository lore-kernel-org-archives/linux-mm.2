Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5435CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855188E0132; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5DC8E0130; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93358E012D; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B99B68E012B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F35B49C31
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.15.2F3CACF
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0BD09120002
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=yGQdIxfXnB1nw8hsCLpjU+zLmcFI0fb3npgdDpjSXRmde6SUEjlkGVKpfvG92WlE3TpMYv
	hk5kLhp4/D1BVH5+3J5MEjrLWIfaI2NX5fCxfy1khRUtbEKUDoMLl4VkIFULA6P+32aw8o
	QIwpfBkcFsh3TPLGV/9BpUztkmawO1Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VC17tD1OuvOzfPJRAHPjuB/3aij3szZzSClbCCRf86o=;
	b=F6xmX7diEGXhxuWyd2LpskqhGO2BFa69E+CIplifHBjEsNUF14dHT8YjrjcqMOvjpgvgfK
	x0f80K+SHlpyYw57gpffbdhhmyBE7E4oElwBrmIDhH2owK/dP8n1n6PVZXJugrax6sIONj
	ht3WfXtIwnSwFu59QD/X2vEaBguBGyI=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcT0LPQzKHMQ0
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id B90CC1A1224
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S22;
	Sat, 25 Oct 2025 11:30:04 +0800 (CST)
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
Subject: [PATCH 18/25] ext4: support large block size in mpage_map_and_submit_buffers()
Date: Sat, 25 Oct 2025 11:22:14 +0800
Message-Id: <20251025032221.2905818-19-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S22
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw48Wr18Ww47WF43Ar1DWrg_yoW8XF1fpF
	W5W3ykGFsY9r4I9F4IqF1DZrn7Ka92gF45ZFWSva4aqFy5Kr10grn5t3W8Za95JFyxXrW0
	vF1SkryxW3WxCrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJHwAAso
X-Stat-Signature: 3b6pdafw635baxgeadrf9udo68kcrkbt
X-Rspamd-Queue-Id: 0BD09120002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761363013-799960
X-HE-Meta: U2FsdGVkX18kKyDs8KHSdQVRCDSrvFpPNp7c7CVT27e+GI9uWFk4Puc8MTDP/ksitjzaALJ3nw5RE55ZruawT9+aNZbhcXuIHgUxZU2poB49LWnF4OMY+JIzrxp4+NuvrPmc8zG7KXeCdpViSPS3RzyG0RVYIGGCUwHLCcDdIHdhBK5hnoHJa5y1+p1mmgnbXoQosuilEu7hsFteZnk26H2xY4uXk9adGWFUGvxAvChhvfvptjnY7Ozx/1XV47YGW1hSdnKINGMqj0srRFBrPrkNjSX1dj6a9ma+RIisKvJxg8ORfsubx7Vj5B0xKjLrQbzRJFRfsC7q9gKL71PmZOzcYM/P80HilBpeD0igOf0LCuTG7IppSVSBAwhJeqE6TeyRW9lgmeG6yXKrp+VasqSmGTcGzkEfkJllCuBpYF1G19rAmnQTMLvw6fe2IFEVHEXszxiFRkecqMPImCNToYW7KCqhGSXxFagXawrem7O1Xe8Rr4EPYircy9IBHlUVMPtGc2VIYbQnZ37lM5GJWgXQXWyw29GQL3ZSwD/FbdyeoNTXERIq5y6yHOX4peL4GxQwhwWabe/nuutkaOTWTebfROkjIiQUzW/Kql/5R13NpK9zd7K0+34E4yRLJlDKu4ExuTDLgCfqoZobmiELZ6/0L4l7woBiSTYjb3WYPZ43mP2/h5mSUFwboAJqq7mZUNyw7imtfvCUnsLPxEWL1qiGhMFSp7g8++Gy+W2s+EYqfXiIkq+5E1tSXt7iNu7v1xmofOppua+aVU+JcEtFsvM1DDQTRAkzyLXx7kcAJNIlMq9sQZCOyUN5YRyxeRUkaZXk5/dOc3T4vttgWkKEy7TaoVrNKqL70X9Ng9+jUAa3qaamxuqSaznl58jgd1B4UeBgLPyBjvs8A5Fta0FVKvJrPlr1PTu69+JDSoCSIbHwt1BRGD6sNjHrASI4+baWwoi/8+ANDqk67emEqPv
 WHmRxlTg
 qhAT1baPCHH4RcX0oDfSt2tf42yFeSKsffvVLPba6d/8YfHkrUBRofmW6jSgKUllX6q2xaSdiCpRsYj/yMHWxTFHngYvFTU21WNFvz1+NQTrij4I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Use the EXT4_P_TO_LBLK/EXT4_LBLK_TO_P macros to complete the conversion
between folio indexes and blocks to avoid negative left/right shifts after
supporting blocksize greater than PAGE_SIZE.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d97ce88d6e0a..cbf04b473ae7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2289,15 +2289,14 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 	struct folio_batch fbatch;
 	unsigned nr, i;
 	struct inode *inode = mpd->inode;
-	int bpp_bits = PAGE_SHIFT - inode->i_blkbits;
 	pgoff_t start, end;
 	ext4_lblk_t lblk;
 	ext4_fsblk_t pblock;
 	int err;
 	bool map_bh = false;
 
-	start = mpd->map.m_lblk >> bpp_bits;
-	end = (mpd->map.m_lblk + mpd->map.m_len - 1) >> bpp_bits;
+	start = EXT4_LBLK_TO_P(inode, mpd->map.m_lblk);
+	end = EXT4_LBLK_TO_P(inode, mpd->map.m_lblk + mpd->map.m_len - 1);
 	pblock = mpd->map.m_pblk;
 
 	folio_batch_init(&fbatch);
@@ -2308,7 +2307,7 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 		for (i = 0; i < nr; i++) {
 			struct folio *folio = fbatch.folios[i];
 
-			lblk = folio->index << bpp_bits;
+			lblk = EXT4_P_TO_LBLK(inode, folio->index);
 			err = mpage_process_folio(mpd, folio, &lblk, &pblock,
 						 &map_bh);
 			/*
-- 
2.46.1


