Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB545CCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7358E012B; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851518E0131; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF868E0132; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6D6F8E0130
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78DF889657
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.13.3365BF5
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 555A814000F
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c70JpvMvcba0g5Qv+dsKDUNs01w0w5rViWSleJDgWgE=;
	b=ct+HI8KriXgoABoRCF2UBKhssr73l5p5GX7xvwlfqWNXsRcj8WwNqAk85V/2Trfn8HoGYj
	9AMYGTt48i8Hl+CgzNG5Cd2wVgojVzpb2nB9Yj81BYf8vnJ/44/4OuoHmSIaun6/A1zh1d
	ZeJk7iYKqnteh9Zpz50A43vtdiKLO90=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=jGVLM+brYnmFOWPhtdV0ugpAaWrbarvoTw9krhOXtHIhVR9M/23imesZr7jz0yqMuc1xav
	+T6aiqNRL1O17jrW5VbXk9j/LkoRdWljD/P1ppYO+WTuZHfpjkzSqdWNYwFlCFLFCsT0JH
	7QNvL5XoemSX96CvhNTRoCNPmRRNVxo=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcK3kQDzYQtn5
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 2D3951A116C
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S14;
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
Subject: [PATCH 10/25] ext4: add EXT4_LBLK_TO_P and EXT4_P_TO_LBLK for block/page conversion
Date: Sat, 25 Oct 2025 11:22:06 +0800
Message-Id: <20251025032221.2905818-11-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S14
X-Coremail-Antispam: 1UD129KBjvJXoWrur1DWFW7uF1rXryUWFW5Awb_yoW8JF1fpr
	sxXFyrGr1Fvry8ur1IgFW0vryfGan3GayUX3y2yrsI9Fyxtr1Sgrs0gr95ZFyUK3yUJFWj
	vFW5Kry3Gr13G3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJHQABsr
X-Rspam-User: 
X-Rspamd-Queue-Id: 555A814000F
X-Rspamd-Server: rspam03
X-Stat-Signature: jkhm6rp6rt17x1o9gdekaf5zprhah94z
X-HE-Tag: 1761363013-263932
X-HE-Meta: U2FsdGVkX19h487hxPDuGr1nPSSK7blQtlnzSalEpAVNkf5BKTiMUtY0n2aBCCyZoSS3KR33UmgR94wpWoNKWgp+hMq7FPEYEKjRdPAZrbE/qxrKFlLLhFqVj5nlJ+ly7ZPo99/jW2VZrohAyVqQH1kfE4BBgdWM1MESFVQcJ6eV7+ASMYwkK5gvBCXVc965PxFErQ17QK0Z4DcVadwWtjn+6JZz4p7C29PkqovkyDCCofVvevgySGuB4HqOlydLrXLiQ/uNU1IkYBj0zecQCmUjqXhf3PWatFBJDhQPvrlBlJEKuH/xr0TUQ8s535Ar6bONN1/YMeMt5/L5v6xfj9efnNSsij1MVyu6kKuSQcQTzgChdDi6aYg6KwngiFWN2CWcehQZ/wwFkY0HMrCez/0qRqLGySvkn3nOszWSck2SReeRVodLmAY4Lp8N8ygpmZlP6vHjhM0BRh4EG4mQEOU1v8MJtKsDfIHSDJ5enpig4iRi/4u+wKs15bUvtv+RYP5vVKvgTFVKprlY5pHe7a/4tm08dhgSUA1imOWSQcTKWgnRhVsGqS9hw01/zU+2IavzBO3so1z2sd8xOacLzLn4fi86bopGUOzpUPFfzyh63c21sqzzjGcnMarVla5eibBkMme/+7bC7h5YRY8PCHkCX+JPV4wD54YY5GM+lAq1G0IjQIfzQe0XytYTsQN2gdz312Oyj8y2pauKWgyfZesNzmr+7uv6wcMZG416msx3+AzCsyyWxPOWzDgiM1KmO4+XEoadEW4jbpP7JihgoKQtbfA3C8TrlRA6kmef1o6Ls8FPxqPQAWKFVVyNzsFa9FsaV46Qfq1usOMqGk715Hpyp3zbM71nFgIcmVBAiA31tNBQAAx9X5q50r2G5iU1AgNQphTBbjqhdZNnA+sMNAP7M3BTrkXI4XdfZPOBcN0gPd/ktJvEipDaHm3ZvraXZMnWermVDzJPzOtP5+k
 ImA5rlgp
 HUKukMUcAVKv09BJdCs13fCHIvu4y39CGI8sgR9e87++8heqNloTCmg0tbdCWhhs5CLc9w1C92j/g51xco38cPwaGvRNQXh/1/XWfLmb91zhivW9hkVjKyR0gxyktnfevkauYSQxxJb2ctw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

As BS > PS support is coming, all block number to page index (and
vice-versa) conversions must now go via bytes. Added EXT4_LBLK_TO_P()
and EXT4_P_TO_LBLK() macros to simplify these conversions and handle
both BS <= PS and BS > PS scenarios cleanly.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9b236f620b3a..8223ed29b343 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -369,6 +369,12 @@ struct ext4_io_submit {
 	(round_up((offset), i_blocksize(inode)) >> (inode)->i_blkbits)
 #define EXT4_LBLK_TO_B(inode, lblk) ((loff_t)(lblk) << (inode)->i_blkbits)
 
+/* Translate a block number to a page index */
+#define EXT4_LBLK_TO_P(inode, lblk)	(EXT4_LBLK_TO_B((inode), (lblk)) >> \
+					 PAGE_SHIFT)
+/* Translate a page index to a block number */
+#define EXT4_P_TO_LBLK(inode, pnum)	(((loff_t)(pnum) << PAGE_SHIFT) >> \
+					 (inode)->i_blkbits)
 /* Translate a block number to a cluster number */
 #define EXT4_B2C(sbi, blk)	((blk) >> (sbi)->s_cluster_bits)
 /* Translate a cluster number to a block number */
-- 
2.46.1


