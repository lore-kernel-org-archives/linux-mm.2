Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951C1CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FFB48E0123; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480558E0121; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D518E0129; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA5AE8E0124
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4780E5E8B7
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.24.162715D
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id B00A91C0005
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=vuiN14u9/OprVO83qxcRluES8lQBCrL4Ktpnd/QMZRQhCVKgMQf6pAATDs9v/QwugE4Vms
	zc2PMll6okNlIsIgMzLpRJve6mSWw72kNy/lGCu3Yu9Fl97fa2Hc57enUYjQUy9YJX0ZxO
	Jkc3RX/j7chW/kCUvwx4exOCdjs+ivw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6VywKA5pOCN2HL99HPZHUfuE00ACEido1GVxDxaNedQ=;
	b=PeNIhT+8F7Q6umcPxtFsamyVu1C4cKQpjyfNLM9FzR68V427hEt+NZpOxezXFLiYdVqIOa
	PZEnH/bnUys8P60VFefMc62KBUJaVVXwIb9GMOXtHM8TxJ5WmK7TFRR96Eza3bZzXuAJCi
	zax3aGWq83brxVk5pyPF+BRQtfwXMQ0=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcR5mXxzKHMMf
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 7E6391A0C78
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S6;
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
Subject: [PATCH 02/25] ext4: remove page offset calculation in ext4_block_truncate_page()
Date: Sat, 25 Oct 2025 11:21:58 +0800
Message-Id: <20251025032221.2905818-3-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S6
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw1fJFy7WrWfAr1kJr48Xrb_yoW8Jw48pF
	y5K3ykur17uFyjga1IvFn5Xryak3ZrGFWUXFWYq345WryIqF1fKr97K3ZYqFW0qrWxXayv
	qFs0yrWxZa17A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
	v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
	67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2
	IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdManUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJGQABsv
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B00A91C0005
X-Stat-Signature: 7qy3re6yamxxqfx7xzti6dn6s7igjggq
X-HE-Tag: 1761363007-648367
X-HE-Meta: U2FsdGVkX1+SCyTZrnxwPiwfTpRyuU2aeRf+rn1b8zr7zhvExKhyPWc+JJ6rXsylW/xukTdSrGOjIX1wis6e/QRLlidSsMB8bVZiOSt9VISRclRk+CwZoMtufwjNkPYbHQrXEIyYMqddWaL+nEMTzPvGe1sY0HECXoX3r6xOm0oIND3DZjXQWqO1kwfjx5nmKqtrPnriSo9I+Dl1MvlA8D660nhdOTDBIwruq83Rdw0N9pFd6FCCaSCs4aEmpHrNTIbBgDQnKW+sCVXTsyOQStUNO1KP2ZQzql1i4it5h3xlegWKJ/jdBtMrW1xdiAfGIZ4Cce6FW3kkpuw7WchJiQRCJuQCi2/aJzpJs/O+XOXeVuUeqUpabisZoxzpZxyTUXsYR6yhvbdfYE3DkMm6Bste+USyjlrzwzQXp3umc44OkfCAQL7yq0LHJ6amAMn74Te0ZMVrNDzdkEfGxMUnX1abGJhRnhI8Ut+xggNwWQMaiXbgv3kp/rx1vZb7MMVvRKf25OeIIllo38nyQhitwGyXT79GBZB6iqhl2zdXcg4YnISCgft0KihAUAs0XZBbwjD0/RKBtmTViuFRC5McQnMccrKcNr/x8pp3YSOCZJRe6RKJS1Oddsxl20sLFz698VS8ej94TiizHJI4Cu6cUcQdGNEfrx18/bj8+rCboPCwkv5RFqjpWGT6rG5SFHDiMfJ79NOYz1l4Lb5kZ2ADiVikKLIE1udonTPSa+wqquJcL0GsrJ6fSy4c0tzognlyA8YV/hQg7iEMuVVaPzVsgJHRW/ydIKhvx+dq8rb/1cqRQ4cV3Lv1mVVfuL368Y+PUH4jXtOvPF0tRxW1uC2Ikw+MvnitTYVPmW6tRwzSmsGlIMPMASirI2AMVRp2pWDLrwI0Vz5jXLxliy90ZnFYHNbkc5XOLdraVCsYg4Xh3c/DXoYJUMOPbkunl7+Yr0FwmfqFztYbWyGPFhEulz4
 CwgX4SwY
 sprXfmmYJB5h2NNA7FsDl4X04Nh16lNZqLcGmKKKdtykIlyVvaZN/k4HunS7TJUys3iLiSDFcfhcj/lUL/IGRsKRgf1GeIG1xkNZsThhurAJNBlfH6WZNeypCHxtxoXeA3tyderryPRyYZZPRsEUcA+941DT/E52BAfG15OHBp4tekYvIF85ZWNrTJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

For bs <= ps scenarios, calculating the offset within the block is
sufficient. For bs > ps, an initial page offset calculation can lead to
incorrect behavior. Thus this redundant calculation has been removed.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0742039c53a7..4c04af7e51c9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4183,7 +4183,6 @@ static int ext4_block_zero_page_range(handle_t *handle,
 static int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from)
 {
-	unsigned offset = from & (PAGE_SIZE-1);
 	unsigned length;
 	unsigned blocksize;
 	struct inode *inode = mapping->host;
@@ -4192,8 +4191,8 @@ static int ext4_block_truncate_page(handle_t *handle,
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
 		return 0;
 
-	blocksize = inode->i_sb->s_blocksize;
-	length = blocksize - (offset & (blocksize - 1));
+	blocksize = i_blocksize(inode);
+	length = blocksize - (from & (blocksize - 1));
 
 	return ext4_block_zero_page_range(handle, mapping, from, length);
 }
-- 
2.46.1


