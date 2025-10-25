Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBFACCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6407C8E0131; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4340D8E0137; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C978F8E012F; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CADA8E0134
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD54949C35
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.30.4D8A705
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 64385120006
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363015; a=rsa-sha256;
	cv=none;
	b=MB+ukAHbAgrNqdUQWrLgsGgwt6eDJ77BGi4XjdO2IeVXkFJboeh933SS6FS4I6b9j+bqiS
	CvzhH+v1rLAxI8zPGDyPJeczVBvDcrXISKRkj0YyYzcKkeYpSxqaPNm5snUktBkc0uKukJ
	wwfThz9o6oWP9lz5/CPWIe8QmGTgHrA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hBRC/bNAYV9cnXWrivm23JU2ndyvBFo9SyfUM0Pp6Cs=;
	b=3P4UeTJXIA8G07RHkve2Mlek64k4YO8C11cE1sZJh036hIqQ/SDukiaqVe/AUiHZ1yvWiz
	zNPZUss8D4I0JpIVWTgQxU51poQGN63RUvFQiIbwlGgdUpYbgpYMYgC2471ztEn5mNgyQ0
	qhA0H/mjCNqSHX+UC1UzhD84CfHYcv0=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcL3JYNzYQtqG
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 1E75C1A0E84
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S27;
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
Subject: [PATCH 23/25] jbd2: prevent WARN_ON in __alloc_pages_slowpath() when BS > PS
Date: Sat, 25 Oct 2025 11:22:19 +0800
Message-Id: <20251025032221.2905818-24-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S27
X-Coremail-Antispam: 1UD129KBjvJXoWxJrykCF4fGr47trW3AryDtrb_yoW8Ar45pF
	WfK3WSkFWrZry7ta13A3Z0va43Wws5Ga18GF97Z345Zw45Ar90kr1ftFy5JF1jyFW8Wayr
	CFsavw4fGrnIvaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	x2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJIwABsV
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64385120006
X-Stat-Signature: pcm8ya9ehrx6oy44ce7z8eda3tmg8qt8
X-HE-Tag: 1761363013-888987
X-HE-Meta: U2FsdGVkX19oUjcBmUk93ozAYbp8Ug0LT/Q23/9rT7nbaffIXyEMRqjIUSxrwobC/iJRMW0OEpXB9Wx5UYSmj8+FemIsM/kHMGzZOTOg+GNp4LIexKnQYEk3FgiQViDuyGHwVgDlF2QOdNKLXTv/ZOpqOQj5vSDkk11n5hM+4SOL7sXjngWDoBiEnIOktm3y0DWE3dKWiZPaK33toUcUeboaLXX82wtIX5QbgWcYxRkOIdUxJvFrBaHFHBvOBgjuet7+LewMpylN35r4OpkJ6kGv0cfhVR5gfjgFM8AuPy0MfLO7v/8JQdWb1BBo9BOsRqqwF4x6yEeiET2vWVq90sn+9WzD5ee5q6VgFyU8hyOm62rW3opSrT0jKBmZJQvMipo7jYw4U7oateQTsoHvom5Qs/093lZ/eMTZKM1qavXzszts/w2bu0KXHmMae65/N4nBEnK3lLAKNXize3WnhfX+9Ol+H9vSYrIHkYLvi65dIaJo6tS7DXupnryjHZeBDb1zYoJ6JHMnduEE+2t7qwvVt9DDoPnL8m5xz+kLUbmULQ/RDnuNbQvSonQu8xVfBJHHKps7ylYrJBXxpjRf7Qw9ICq3tkDhbmePzxNL4vVR0VXkb3aBNbPil/MF7w20U4wq93ugq58epLG0a9E/f5i+ZKpcbB1/2r+xv+OlpUEZws98I7hEtR9yNd7QtYgktBAwbqD0JG6x+Vdaf4dJvryJIpnN+YUWmLoc2qsTOve4zHzIjRVexM6Md4Uu9Emqeq5IpBvOAfoOTsymLyCQJe48YYs38/4Qb+LSlVgZS45u2iXEveT6Kbdh26keVeqoQLlmjJDqHMqnbX9DOC4XcpyZaIrbYQBkuCIB1ErQIDzhE1YD4MZIF7y0mvdJVSrZ64CNvdWHJccJy073P0b90wcIK30CKjZDz0M7KOFWjtUzXGEbRsl5JtSToKGKzSmZR8qzjY2Mib/gtgdWzzI
 icNQV4Zy
 GYPos/4X7dFt+yxP2ZmcydRUrIjiQwg3y015+zo9S2nT3Wf4JBeHVEDYPuXgKEa5gvwi90a3/Ya0wMNCkQ2g7N7pzp9FmBVNZIEPBQ+CAlWPPZV/jxD7WUL7kZLPtnsMTEC/UNRTQRwc+9Pw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

In __alloc_pages_slowpath(), allocating page units larger than order-1
with __GFP_NOFAIL may trigger an unexpected WARN_ON. To prevent this,
handle the case explicitly in jbd2_alloc(), ensuring that the warning
does not occur after enabling BS > PS support.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/jbd2/journal.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index d480b94117cd..9185f9e2b201 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2761,14 +2761,36 @@ static struct kmem_cache *get_slab(size_t size)
 void *jbd2_alloc(size_t size, gfp_t flags)
 {
 	void *ptr;
+	int order;
 
 	BUG_ON(size & (size-1)); /* Must be a power of 2 */
 
-	if (size < PAGE_SIZE)
+	if (size < PAGE_SIZE) {
 		ptr = kmem_cache_alloc(get_slab(size), flags);
-	else
-		ptr = (void *)__get_free_pages(flags, get_order(size));
+		goto out;
+	}
+
+	/*
+	 * Allocating page units greater than order-1 with __GFP_NOFAIL in
+	 * __alloc_pages_slowpath() can trigger an unexpected WARN_ON.
+	 * Handle this case separately to suppress the warning.
+	 */
+	order = get_order(size);
+	if (order <= 1) {
+		ptr = (void *)__get_free_pages(flags, order);
+		goto out;
+	}
 
+	while (1) {
+		ptr = (void *)__get_free_pages(flags & ~__GFP_NOFAIL, order);
+		if (ptr)
+			break;
+		if (!(flags & __GFP_NOFAIL))
+			break;
+		memalloc_retry_wait(flags);
+	}
+
+out:
 	/* Check alignment; SLUB has gotten this wrong in the past,
 	 * and this can lead to user data corruption! */
 	BUG_ON(((unsigned long) ptr) & (size-1));
-- 
2.46.1


