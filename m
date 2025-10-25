Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 563F8CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DDFB8E0138; Fri, 24 Oct 2025 23:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5608E0135; Fri, 24 Oct 2025 23:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3068E0138; Fri, 24 Oct 2025 23:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5222E8E0135
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FF2EC1079
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:23 +0000 (UTC)
X-FDA: 84035208726.08.C25E149
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 01F2340006
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0HSw+rDAPPwv4VsPgJ1oXPDB37PTBwtwxMHz4AmXF4g=;
	b=UYBheLGMbbR2k/taLTzRgnu4oOdDc+llVaMfLKfXU0GzKTLI0OHuwxymVP0OHOcfco5giO
	mHVg6GjDWV3UTq38t+Z7SEvBowNrsM5JPORBCqMNCyuWihirp7sVU0v8pP5Vbt5WyjIXyn
	Gr1HWWGpxlUAXjCqyFF+JpTY9cev6DE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363021; a=rsa-sha256;
	cv=none;
	b=EfxKyQjVsYg6FDof92F4c3mFyGKAi10Ov5pYFCQOM2Q564H5QMZUuPjNjXGZcMPsriOy0X
	b+NTruaiLULIRqdwIu/Icql8PCheKyaATzTBk5b3LRfAHmSWkcn2I7Dl6XxPfuL5WFh7RT
	LVc4OAwD+Qlc9QcMqPcBRLkq5uS5DgA=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcK5hhhzYQtnm
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 718E21A17F0
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S18;
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
Subject: [PATCH 14/25] ext4: prepare buddy cache inode for BS > PS with large folios
Date: Sat, 25 Oct 2025 11:22:10 +0800
Message-Id: <20251025032221.2905818-15-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S18
X-Coremail-Antispam: 1UD129KBjvJXoWrKr1rZw13WF1rZF4DGFyrXrb_yoW8JF17pa
	17GF18Gr18W3y5Can7G3W8Ja4xGa1xWay7JrZ29w1jvasrXFyFkFsrtr129Fy8AFWxAayf
	XF4Uuw43ur43GaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I7AAFsH
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01F2340006
X-Stat-Signature: 3qzsn5mdydgosqix81huiunnxec69gpt
X-Rspam-User: 
X-HE-Tag: 1761363020-914458
X-HE-Meta: U2FsdGVkX1+UzWO1MNRRKfHP/cJiyhhXPBcJVnqGS53aMVELNYmxlD1lKqLuCLFVo6DlIUN967/9hklS3lXVt5C9/1cJD7s0N7nINerV6kmwDVfAgEWuer9B3Ikml59SAhgivlOSWAGZE53su2GCZqv/sU4Ht/Kv7Z8OCPQvlUUDS+F9FEKPYzD3MYl6XMQyl1U+OpkI8omikAST+5S3vf6g8R2vFe47J8m8M8lOTM5JUBDJ0jnwWLQREhmP0yPU2F0j/Bb3axjcPQxku6vkrCjVVE5UxZ7rX6/LCoYM6tIe76Ct+cvW48b6odHCnIttiGHCbN1qj8ZwbQrMLA3UlBZJ6pc1ijU5+jqpx4ut5GK9sJQ8rYTIatNTug4EmccjDZhqY+lhH+elT36L5Kbt5QWIMpq5OXUG+SLWrLJ9M0drO9M6V4MXu0psVgu9pE9RGtZTlQ4l9gZOSihO2fB7TIcOO2/hxORMu/RecFy9q6rH/lsaQ/oR2MlR4kmwmcZaZlyC7j/xbLuJp2vEz7Ya2K7GzzpTrPEm+qNdf7xPkjX34NsAsHdUulvOb4YnWhPO4cq4KtCLK2lKhM3nOzTvhPOAJHiF6iogaxiB7j03nflOr4PPNePN8NDb/aLafJ3WZ9hfLBlyextd/B+WTQHY/qYcbcUk+f/oTZotr1KP8VvIsYdRjMbrHNQHeb+XRFMARe2WauhJKylHh9XqGQrsRyiG5yHD2WwACLL5uV/WFDYDF5baqmEzhjDeRrQA3BN67V0F+DzCT+cNQnYZSM/KCVk6Mr5XxnO3MkCTBCH06ViN0FVPkCGViQjFNlFn8uwnV0a2tBU4ZNy8DZVj2Hz2IDxesq6mTgexFDTiicsR9w5FRm+BJDOchXw5VtomV+I8cEJFvk7zrQ8B9kAyvxvjyDKRj7VUUVzs4fpRjDksdyZqUL9PBeoch1Nc/i9A98kHO5x3NGErWWTdDaMK3bw
 uvNWv2Xk
 gQ+cY0lGggqOklZOjSApjTfFug6g6gLM27jjgQzCEy3gA0UJ2J2xmEePzK6+Q20jY5mriKjGjJEworFZneDo/RGmm1npL9acXXid1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

We use EXT4_BAD_INO for the buddy cache inode number. This inode is not
accessed via __ext4_new_inode() or __ext4_iget(), meaning
ext4_set_inode_mapping_order() is not called to set its folio order range.

However, future block size greater than page size support requires this
inode to support large folios, and the buddy cache code already handles
BS > PS. Therefore, ext4_set_inode_mapping_order() is now explicitly
called for this specific inode to set its folio order range.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/mballoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 31f4c7d65eb4..155c43ff2bc2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3493,6 +3493,8 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	 * this will avoid confusion if it ever shows up during debugging. */
 	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
+	ext4_set_inode_mapping_order(sbi->s_buddy_cache);
+
 	for (i = 0; i < ngroups; i++) {
 		cond_resched();
 		desc = ext4_get_group_desc(sb, i, NULL);
-- 
2.46.1


