Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5A7E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 07:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1206B0088; Mon, 22 Dec 2025 02:25:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E839D6B0089; Mon, 22 Dec 2025 02:25:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7DD16B008A; Mon, 22 Dec 2025 02:25:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD4EF6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:25:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CDC014053A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:25:03 +0000 (UTC)
X-FDA: 84246270486.02.D32A3B5
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1CA8C180009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:24:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of xiujianfeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=xiujianfeng@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766388301; a=rsa-sha256;
	cv=none;
	b=5WmppVqJZhBWPwFT9OjsEZGagB9FuX83l9/5lezt18rLghY+FKR1bLAhst0MqJv3cMhpIT
	jfF8++AqHg7HGhPNM97ypolWogJz2Mki5AVeKe4onEH4dGJA5en+LR6bmcRqfIW/pXxfUe
	BBoawNhJ4rkdlludTHpcS6fP7qOJ6KE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of xiujianfeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=xiujianfeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766388301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=RF1hpiBR4PGZiUEANb3TTkM+5btqs8x8KSIX7bhax7M=;
	b=srCpmf6LKIXJprsvOZCEVqH0fssOByu4nEiavYakxzeW3HpEXAChn47nNW15rbGIany6QI
	iQCvDP0wXc0YMjPPtJIImfgjTjVSXDHyrK/asl0xsgq0IYn+OE3t04U9HuPtvMGRistmeQ
	dVMQ1KLMhmixctVYSBJZlf1DOKR8r2I=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dZV5K3PnrzKHMP3
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:24:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id DD4304056C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:24:53 +0800 (CST)
Received: from huaweicloud.com (unknown [7.192.34.199])
	by APP3 (Coremail) with SMTP id _Ch0CgB3xBJF8khpgVQpBA--.51780S2;
	Mon, 22 Dec 2025 15:24:53 +0800 (CST)
From: Xiu Jianfeng <xiujianfeng@huaweicloud.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -next] mm/hugetlb_cgroup: fix -Wformat-truncation warning
Date: Mon, 22 Dec 2025 07:23:59 +0000
Message-ID: <20251222072359.3626182-1-xiujianfeng@huaweicloud.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3xBJF8khpgVQpBA--.51780S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JFW5uFyxJF4rGw17tw1DWrg_yoWkuFbE9F
	1Uta40vr4rX3W2ywn0yrn8tayqkw1rJr95C3yfC3srJF9xKa409wn7Wr1a9F4fGF4jgFy7
	u3ya9w48trnFqjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1lc2xSY4AK6IIF
	6r4xMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUctC7UUUUU
X-CM-SenderInfo: x0lxyxpdqiv03j6k3tpzhluzxrxghudrp/
X-Rspamd-Queue-Id: 1CA8C180009
X-Rspamd-Server: rspam03
X-Stat-Signature: hz9dpcox71qbt95ueoim7muy46zqk8ix
X-Rspam-User: 
X-HE-Tag: 1766388298-185085
X-HE-Meta: U2FsdGVkX18qQlIGuFryTueEZd2BZazDnRpFY3ZP1J52fsXD6evTUFvMOTXz2ebd7IirbiSlY3OxAGiPEyDNTqQwYeKMJywwLbBHnqSxNTjSCl+DmKgx9Na1bzmH4qIlSCoM+G8HMl+62sjmzs/xT7fCpxlX1FQn7rTZ3fBPo3xCREPW/VjBSO7lW85whZZVWmQ/cKuIQJFIYgfdRFQ2N47phnsj4JbB4GEbj3B5CCdzf2MZ8EvYIfDDZiWK0pdeXREI1d5xbOg3M3Dbabeb+EYSs9y960tFlRhOOhxDKWyR4mlhDN7uOP7jB05colsTI0VHnx5DwxXl4hivoKV0GfLnXk7L+6R5EzwgWksEcBh2ZwI2luog+Vz5PsA1SNWcPd8oRX/sAQSauz5z7NFSNYkrRqimf4rckZ4vujZRwKMwUaKLzf15tz/fVWUOPS52iYA5OVZ1sR2396KGR+J4RGTctT4SKO7LJk8UDnTTkSRASavKV/HLa9CraWBySaq9D1jnGnCyg9ATq/p3n7PuFtfH2gX1zS8J2K1G0hZjHNtvt9N1gZSHYoQh3wgQni/qiQDa/6EizxF4vnVxNz/fS38LvzEE7g3pOmmDTHF1Ag+3X6/eYkuz993Ut6randDg3nky28TIScklV/LbqGl+dcz5YocNI0h2rLruD9nBWpepuTGOTQycuCDLCW3dZn/pQ4yj7AoaH645nVh5nxVp3co+q0+qqqc0vTOTYj8KidA4Eye/MUZwLujA6Rm1TUVOJrSwrOf/k0MAm+Ob+VsNQsN/lfj0ld/9I57ucx6kj5ne+OMR+o4H5lgSj3VRpudrE9SYy0Va4Pl5boK08NCq8lYXhAjZZrlCpBlyzfGdi2CR32Quhlpz9D3Nl5ZUy14EcTgopNbar70PmObZX43nsn9P0tzKJXHfbfm5KTHM+ZAnd6JMubxTXL27CHBGTCBb0OUlJ513LkIABUJVoK9
 T7XijA8Q
 iIkvwB/JkYAbXXRpnmM3Vz8fa1VMddlW9FT3I4Rx51Pd3+9Ks9C3c1BA3jhNHWowVO50dnM0rpY9pD984zWoaeawcPatThdktEfHDpstgdmbgREyi1Lxi/owtKccxU0FRmz9MON1n+8uSUMSN3ETTHgM2A7KoLNO5Vb9Su8FYl2vVvWOFrZqAaxvo3Lty4eFU24RbGwdETnRFTjCOkqpJJ6BdAYKZepE7+Dwo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xiu Jianfeng <xiujianfeng@huawei.com>

A false-positive compile warnings with -Wformat-trucation was introduced
by commit 47179fe03588 ("mm/hugetlb_cgroup: prepare cftypes based
on template") on arch s390. Suppress it by replacing snprintf() with
scnprintf().

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512212332.9lFRbgdS-lkp@intel.com/
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 mm/hugetlb_cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 58e895f3899a..7144d7d555eb 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -822,7 +822,7 @@ hugetlb_cgroup_cfttypes_init(struct hstate *h, struct cftype *cft,
 	for (i = 0; i < tmpl_size; cft++, tmpl++, i++) {
 		*cft = *tmpl;
 		/* rebuild the name */
-		snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
+		scnprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
 		/* rebuild the private */
 		cft->private = MEMFILE_PRIVATE(idx, tmpl->private);
 		/* rebuild the file_offset */
-- 
2.43.0


