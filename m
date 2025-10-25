Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C22CCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287B08E0128; Fri, 24 Oct 2025 23:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0788E0126; Fri, 24 Oct 2025 23:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32CE8E0128; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 371518E0127
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53EC0141026
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.22.C59C04C
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id E01B8180002
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zo5mN3q3zgS1gBMPoolmggvUVrhMkXo0xpHgwlBbT3I=;
	b=47h/mjWRzAM5+hGDLXiaxPXAErE1AlhIp26QNrfEKPtEiKY+C5csihccGXIr6gd+qUeYbp
	bVSaUeutwx5ndrTRroQXGbH3meNGUYO9vPPqYc1fJyFtuXQqplwQdYtCTRpRupTqE+SZ2q
	lDodobVV8ObbIE3V3vCNPd27qbAMmqo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=8YZ4ZagRylVTmpY7Dp6wxI4msK/aDG2H28U6GMQN/4T/apHdIBXiYjI03uiFtQy6Ksw3LO
	S0fWbDfvaS0dBg1mbvjl5+q8tMuoqe2Cv/Vz6gvO1+7Ljan69EFMdP1Giu/HcVInHJKw4r
	DioswV2yeNffy+DimnA0QftXXE9hiFQ=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcS0kFszKHMNK
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C72421A0D8F
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S9;
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
Subject: [PATCH 05/25] ext4: enable DIOREAD_NOLOCK by default for BS > PS as well
Date: Sat, 25 Oct 2025 11:22:01 +0800
Message-Id: <20251025032221.2905818-6-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S9
X-Coremail-Antispam: 1UD129KBjvdXoW7XF18GFWrWw1UZw4DGw4rKrg_yoWfAwbEva
	yfJrWUGrs5tr1S93WruayUJFsYkw48ur18Gws5tr13XFn0qrWxX34qqr98uF15uF4FqrWf
	Ars5XF13GFy2gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbm8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJGwAAss
X-Stat-Signature: ntj5yhn84nh7ari5z6umag1ergq7wu1o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E01B8180002
X-HE-Tag: 1761363007-381306
X-HE-Meta: U2FsdGVkX1+L64nYPz5AI6F+R55EJdHkbbw5ApN0TM+KeKcYN8zNmF66Cwnu1cYMV1U3ujH2zJGf9yEmZ8ctmHn/PcUOHIXJZTUaZP7jpbXfOLaJXfvnaFexWb3AwjpjUOcc07G4G3XthmQd7Lvtr1LQBsxvvEowfsd5ifH8PTG6fP7+GCqnff1lRDpYy1bj+pfDKYPTL2AE3mkrbxb/2aikhK9D1Frabvy61Rw/CUUXAiZFhp6D/lJyTlLDAzbJQVhtKUk0nbWa/nPnIoCUbSjDV8uLL1bC12X2GdMtwCAaoeL9AWNns6Zn73Vh2flN7rV9IWwGjKHDW/ROmYEvDfc6EhqMZOBy5xDOQChFsyjvDtKMhA/DHrO/1eNSaSwYFZGuvJL7sTOlRygCRIeliFiKS1hl+m7N2uoMdR9Ve5MAz3YDMDvgFcc4qUtwmDuoVuslldJEj5VMPfxAIYVHwcYlxxDPfhhbRUoGy5KNRVLmAdaQ32G2AzD6Rf0/SnlYTFfOEIM5rtP6CmKuThqvKVB/15wL9fql/zl7rrI4YFXM0yDzPztbdscTGjOss9oGCFMQg3Yt+BofI/YFV/J0ntNJrKMeE1bVQ7vO5fIm/p4wfg3DxJwdgF1cwP+3puEa01O9fWPvkAcZgJITdezEFQF+seVsA7b2KQ0xZcKrejuOC81PL3dW0qD1V0SOZmAFDFfs8z5etcoSp+S6oyJvJso5gxLEurZYICRydjlE+Yh0E1PtzUYF9V5KDK+heX5SSTsNrOx8Zs3Or/lBPDPviQkGnnYlnbpBRvDXShbyDQu029292cOKYyoPEEdiSsqGtCgDDeHHoK0ZJSoeclbRY+zE9hpb1h4Z8tXgwobeZiZ1ivAQla4dT0ZzWIfj3YZCMOVhX9Wxyw/eZd44oel1zTAEBgGFPvYew41W5p1foBaxTDN9z7QQNLNvvhZltqAD9ZxjfyzJXpU5CQzuSuX
 ztBJk9V1
 VP5ysUH47U5CoNyBN9v13dNGFKIKR5hFHM+0q/WiYH4kZhmhSXLjAlzNvbyZAa2XnSB+glCqhqdSRhX6Ajyhut7CaUOcnLTXoYXC5BDaxl4AS8SXKYGPRE/cniQBSBN4rJK2E2vigBKs9V8ap3XAneJWgtFlh3huXhfwOmtpVX5KetJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

The dioread_nolock related processes already support large folio, so
dioread_nolock is enabled by default regardless of whether the blocksize
is less than, equal to, or greater than PAGE_SIZE.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 894529f9b0cc..aa5aee4d1b63 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4383,8 +4383,7 @@ static void ext4_set_def_opts(struct super_block *sb,
 	    ((def_mount_opts & EXT4_DEFM_NODELALLOC) == 0))
 		set_opt(sb, DELALLOC);
 
-	if (sb->s_blocksize <= PAGE_SIZE)
-		set_opt(sb, DIOREAD_NOLOCK);
+	set_opt(sb, DIOREAD_NOLOCK);
 }
 
 static int ext4_handle_clustersize(struct super_block *sb)
-- 
2.46.1


