Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C35D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 13:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF506B0005; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5F36B0007; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9133F6B000C; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7D86B0007
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFE6F8A43A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 13:17:59 +0000 (UTC)
X-FDA: 84199985478.19.698AEAA
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id C28AE180013
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 13:17:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765286278; a=rsa-sha256;
	cv=none;
	b=2b0PlrE8HgPqy9rseZ+YKcFDoCHdmjCxA6MWebv1PBQgbWEdiLHSOKTyRnfGXWw+MGGR6y
	4WyYNreHU07PdG0EUM+92n5YfdTiuF7LFJ9XTXCjonhfd8WjQznimI0ZywbVQ6CJ+vpcCD
	vEup7Aio+PFBJzkSzmfLX3ejAB4O+9k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765286278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Td2zOItBG3E870mW9jbUC8EdxRb6Slzjn9vMsFihsa8=;
	b=ufexxD5wpHwcl2oShzf6JH3nQNI2NbgsSFlkm3owxAyWU6A3Qp4GQqYFqR+J1QjYOxuWyB
	CyUZsYmeZMluDKsvDjc3ZOdg7ldpEyHl4yqGqSoVaFnucESQWQEOEEDEi+ijWsqVvtQYpr
	5tZYzUCwcbnwRmtqUiID8rt/u9cbAnA=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dQfWj459rzKHLwK
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:16:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 24E371A06DD
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:17:48 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP1 (Coremail) with SMTP id cCh0CgAnYn5wIThpE+mPBA--.4181S2;
	Tue, 09 Dec 2025 21:17:47 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next 0/2] memcg cleanups
Date: Tue,  9 Dec 2025 13:02:49 +0000
Message-Id: <20251209130251.1988615-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAnYn5wIThpE+mPBA--.4181S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYm7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7
	M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14
	v26r4a6rW5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2Iq
	xVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42
	IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
	CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: C28AE180013
X-Stat-Signature: 7h9e8rkf98bb1ixwsnn7tmskgnsze4xd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765286273-282725
X-HE-Meta: U2FsdGVkX1/cWedx1a0okW+NRrb6n7xhrv0vdypixLE6mRkU2ILz1DYAxF+SfyngUw8NMqmdTCbsaapp4ryspN1d+uRxuQKbfMc/ne43+qxzRqARHgosvl9cvKImOR/l4bFcLKUw0OvZRVLplADk14IncrdxNkQ4rVtLkRz/3v4m3xypq5hmFYg0FBHDNb6Zkj0I18+ws4eiSrb9rkTcIbUrJpGfnsNhRuB6rcVYYBMFhCRq4sJTMjlvaabSYV0RYCsObdUkQQgrcwRBlDOZawi9Xj7N3utSgqksjnq3eNWsieVeyU/jmFkt7xt+djZv6z8VHhjWSYo32RAGGZ1PeNRz4KEr4ZZdUthuflMbl28fTsEV54UGRXpzhDovMW5U+DXb8eyjOkUsVZrbanzFxYBJF/ird6ZpvOLD4RBPENxO23eoAbkGBdCYO2DD6doFAJYiQvQ5Tl490fz4Vzhcn3hMqQIR1CFUu67c48XIwZuabRZwbfIam9fqBXVFzokbNQ534XFPDzMmGQbx1GJl8QgbhOXSGBY0BwCveNvDIhTDPDQoelOtEBR74AnFJSzzzQwUbrKz8p/aLqxJLUwwURY7Z+71sZjYzu1UEVyJFWyu/MLN34sp6DUeCuIPsE1ZC4iw1GqafmOoiLedTUvU0yy1KtuQoRFTqpT74/YgJGzQB3cRlqOthiYgsrdiuvx9iktDOGY/FXTZpWx6qUHKQ0+nnIRNQxY7Y4W0Z62b6JRUakTxo4dENop3La84pL6eqvAIvJ/TReYruBEa2i9gbkizUaaWNCgRH3u4KQVRNEMlTQVxc70akyD9qbyGL8VbGsYf7xaTDoVSllCKDHu7cKhBY2ENwFlqcikwLt1Hq99NTrhE14YQ83ljvSBWOVTYOMjHX4xfUD7NhHgXwVzZHorUG0cnE5L+GBdK5Co23/SRE56beCpGGU0dZksm+4K2+FiKOCSOmBOP7J2DIWC
 uyqHppwv
 2RK0MKwoyuYhz1KmforyIlBqJ1A1iYumbOK5NivAJoSeTyPZd1SFtGis6asFIM5kVpYt+M8ZlIQR/RbTeb5kvytuWstlUBU3WIGAJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

This series cleans up two helpers in memcg:

1/2 moves mem_cgroup_usage() to memcontrol-v1.c
2/2 removes mem_cgroup_size()

Both are code moves/removals with no behavior change.

Chen Ridong (2):
  memcg: move mem_cgroup_usage memcontrol-v1.c
  memcg: remove mem_cgroup_size()

 include/linux/memcontrol.h |  7 -------
 mm/memcontrol-v1.c         | 22 ++++++++++++++++++++++
 mm/memcontrol-v1.h         |  2 --
 mm/memcontrol.c            | 27 ---------------------------
 mm/vmscan.c                |  6 +++---
 5 files changed, 25 insertions(+), 39 deletions(-)

-- 
2.34.1


