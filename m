Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ACC8D3B9AB
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 01:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5196B0006; Wed, 10 Dec 2025 20:45:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239FA6B000D; Wed, 10 Dec 2025 20:45:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016FB6B0006; Wed, 10 Dec 2025 20:45:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BCD2C6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:45:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54EE3BB095
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:45:24 +0000 (UTC)
X-FDA: 84205497768.17.46C4078
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id E8BE6C0002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:45:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765417522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jvwn1M6xjlgvzq5mmbywUzHqdeWBIL71MReoMdVd09o=;
	b=jvLG0cwhpXpX476LskUYNaJPb6v32n1+sjfiwHKcjlmzdGw4FThVT6UTSTooZ4qVW/NJPv
	hyD2oaWuxVFlixy1s8xVkTKYRURY/c2L8foF3vG/cBju4xKr0M6bpCCkeG2QeB8zkqorq9
	vmYPYgjS44sHte5BHtD2DwgHp0oe6uo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765417522; a=rsa-sha256;
	cv=none;
	b=L8n1u4EMrQg3rIgu3PtwKnGP8Jmcg+huheO1BeAihKsg9TfjLsIlqpJifuWtW/IwQmeprL
	BPMqHpFWF+rxZpYkp6MqY8slvgGg9twI8CuYITTOfyTi2SgAAsl2F4bS1p0xJ8/EC7F2CC
	OQJg7VxmXXOMnms3LqXLVLG2W0/kAZg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dRb4X1mxVzYQtjv
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:45:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 4B4CD1A084D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:45:16 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgB3VlAgIjpp39lLBQ--.49534S2;
	Thu, 11 Dec 2025 09:45:16 +0800 (CST)
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
Subject: [PATCH -next v3 0/2] memcg cleanups
Date: Thu, 11 Dec 2025 01:30:17 +0000
Message-Id: <20251211013019.2080004-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB3VlAgIjpp39lLBQ--.49534S2
X-Coremail-Antispam: 1UD129KBjvdXoWrAw45Zr15tw43GF1UCw17KFg_yoWxWFX_Ca
	yIya45trW7WFyrCF9Fyr1fXFWjkF4Utr1jy3Z5Jr4UXFy7tw15XFnrurWUur1xZFs8Ja4U
	J34DJF48Wr1I9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRiSdgUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E8BE6C0002
X-Stat-Signature: 5mz353jm4tfu177inksbocjd8nby5mx8
X-Rspam-User: 
X-HE-Tag: 1765417520-938701
X-HE-Meta: U2FsdGVkX18F5hoOH57o1ThA6pZXYEaARMCMS97pmfmZblmR99WyaX++WGFY9pMhn1ZLdn2PqvWAsVnD5cqWKoTqbzpmwxu+9ZeJdv2W1arHuNWFUkbb3Pjlf/0a4J/BWQLRVcj2sBxDJyEn1iAhrX0Oc9QLI1uZAYTMUlHaYnHWdC28YSTwa4DE0Dg6hpO7Fx4KdocEO2/1LYBR/tLqwzwoOu5dSxckzkrkCvb9MOp0dHRnT5gygIwoKTFsclwFlH63gUf9hCOejnnezh41wDLE2oblkwUqxwYDhUYCLF56IJBWMnxXIr+EAeYclj9Fat42n6/kxnNVy7FoVsSK7drw8x1bNaBYdx3Xh6ut95+KMZNQoHOWXynpwH0qz+oqMvK1PAwG43Le1oFsHb4U25JLDAnusPT5Vt2BNgOJUrumuYHrssCluuht4lmlW0WYTXsJctomETFzNjLVA1edtTyCotLuQF3CmicIWVOHGcQ6c/QhIaPBepVPzhf33uViOEAuw4OQU0na5J11spZ+A9uZ6D4jyeIf6LtseAfkw6K8lmErNT+A4CKLpLAco0uE2hNUdRI3GujI6mKNVIZhwA8yoVAHh2XexVecCWQJlfqz4+Ndm3KOCG9fJfkw7s2L5i18uY2swfS6P8H7h4ShJlZkFYD7bvKxzNzK+yLIK64uVP1wzeCZSNxk9L/oISCZ0F6VKdsSTZ0bdFPTSzKXYiO+U+g67XaJcgOp/k04FJcpwL+8cRBdY5CWjtQ+TEDE9S7ZV9hX5H2lds1/xz7hQkLlRJ+Pze1a+kJHlhBO32OSwxSQ7dqZi1FGgnnFNKm3/IWeWnuUUothWOjlhDs74wjUAqg4Hxn88ODv0VMM+vUXy60YMOdH+0VQGo2bdEmXmj02GZ6Q+D+1izfjhe9y6brcq/V4Z2nkKE+H4vqjVYW/XKSQgLz6HWNh265Rv6zI2jnNwOf+Oqkfrh8On+Z
 WBc9qeOj
 LGwmNp8Qbzo81/dpdMuvWB+Oty5+W2kcUfzbALHm5qvT2xdlQA3LvDuwjMkVQ2JqsXefq0iWYQaAD9PBrVCwiU3N3rp6LvRfR/i/p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

1/2 moves mem_cgroup_usage() to memcontrol-v1.c
2/2 removes mem_cgroup_size()

Both are code moves/removals with no behavior change.

---

Change from v2:
1. get usage via mem_cgroup_protection and eliminate ifdef.

Chen Ridong (2):
  memcg: move mem_cgroup_usage memcontrol-v1.c
  memcg: remove mem_cgroup_size()

 include/linux/memcontrol.h | 18 +++++++-----------
 mm/memcontrol-v1.c         | 22 ++++++++++++++++++++++
 mm/memcontrol-v1.h         |  2 --
 mm/memcontrol.c            | 27 ---------------------------
 mm/vmscan.c                |  9 ++++-----
 5 files changed, 33 insertions(+), 45 deletions(-)

-- 
2.34.1


