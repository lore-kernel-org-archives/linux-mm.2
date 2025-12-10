Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5575AD3B9A9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 07:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A1B6B0008; Wed, 10 Dec 2025 02:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D696B000C; Wed, 10 Dec 2025 02:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086BF6B000A; Wed, 10 Dec 2025 02:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E01D56B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 02:26:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68B561A03E0
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:26:48 +0000 (UTC)
X-FDA: 84202729296.24.0A6EF5E
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 992D34000A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:26:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765351606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=X0wnrS4g14u1idvrb/YvNZmXlMntsHB2O5f1SGdfJsI=;
	b=X1HQ2v49it1TnDh36lOE4DirzLADdSfS34QYwNQ/3NPT1fG76f9DaBbKYv59Ie6LUMeUC1
	pRFkEvPocGJirK9aHCTriKrZw6OYIOAvJkuQ5AT6Sa+j3truCjk+8MlE9jFaY1hXYUc7h6
	OuOaZ/lrKfV+kqDxvE5zVx3cOTup8cA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765351606; a=rsa-sha256;
	cv=none;
	b=TXErw01V0c69q2YmCG9VgpY5Q/B6To0M4+k30hQOF6gHi24E4+y/j4o1xCe+vs57WLmcE2
	dJZG39DG2WBQ40W9AYeDSPpiLHlhDO54i81Y7HXSpL5l64as9/pn6eTyFLo57cZ/ivSgpE
	Pm2Iw9tkRGV1dBTIzD0rTawKsaZf2R0=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dR6hw5283zYQtq7
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:26:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 71A401A0359
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:26:39 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgC33pujIDlpfef4BA--.9918S2;
	Wed, 10 Dec 2025 15:26:39 +0800 (CST)
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
Subject: [PATCH -next v2 0/2] memcg cleanups
Date: Wed, 10 Dec 2025 07:11:40 +0000
Message-Id: <20251210071142.2043478-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC33pujIDlpfef4BA--.9918S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtrW3Ary3ArW5GFWkJw1fWFg_yoWxuFg_Ca
	yIyFyYyr47WFyFkasFyrnaqFWjkF4Utr1Ut3Z5Xr45JFy7tr1DXr1DurW8ur1xZFs8J34r
	J34DXF4kCr1IkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Stat-Signature: 89hez4yjxieaknrxip561apsmy486xtz
X-Rspamd-Queue-Id: 992D34000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1765351604-897687
X-HE-Meta: U2FsdGVkX18uyFsGzMsc9ey2nYhvgftKzc4qBcSquPYMMFZdVrn2IQrrZaiT+NP9bKuTCckNwFfdKnaigXHkabYZIKj5zd0e9E+g3jusmisoqXguRlFIlcMFbsb9Jhoprf8iElNcR5bjlZzfYFXmbNRS8aEZVhy5FxgSgy2pL7YUC3JCqhW14GwIKhBmM+lnCzH4qtXskONzDSj+DwQ0EVnJriiBn2iyAWwhLUHXW84SE2pAiImRbygg1bP0vJuAtsSXfmicoFmiMz3yfpNqZ5mfnX1LY6oGBgES7DNzDBL1DntiZC57P5l/JR7Ztkkerbc6bqwZEbADSia+HsTYGFOH5DgXGaXj2Sjtx+DhhSKpxYkrsYxmjuWkuaeLD2t0Wpo4kATwpATEKoIevNR3Q1T69MsCBpgPrQH/0nrBOxREWFHz/e73Vi5wApQObK4BFhrlXhbGQfmz5DwzlzkzX2yB7FJiYEJRzDv+S2C2J1op70eYL8p26k23Q8rziuQx4PDQx0eULo6laO38EAmVVkss4YlzeN8pxwZl4/+Xcmd6IoIMjI7jeuqbvle6pdTMdwupb9/IapOIPxUlCB7hYWwl6lNypR6j4rcC1rH48mNuORihusBELVKXzPPImFeKtoXA7ry+acKw0OcA0NFdVlALt2rFSOCYA4nVjmufDrwxFpSoYqYw6eCAATm/iQ5BtnSCMQzkMNHxYGdLGdaWZxT3Sa3IB2+039hl6xuOsYi7UvOYFUFPYNx/OT2o13vxU788tYspg7VkLtbOqI7JKKP7oWC8DctQG7CuuW+xRIZrfIh3E8KveQc+nvS8m3mzmxOv8hswF1cLa+b6+JJxKDj31kbnUaW3aZaFml48tBacWk+jQX6Cvgj3626skweCnLkUi3vZ1zihkYJUMt/Er5aL/ZsiOsKuNmMN69TciKjAofh3uCnTM+25Or/BTJs/2zMeTlEZk6XsBrfb9fG
 nUZmlNXp
 LAC0I3J5yH2Ma/HlrrwahW9/f4rTIxZi3MpzhFMlx4Y7OwOa6b+IB/qoVebONnejcLZPOsnNEbOf1yXrZuDHrCmM7H/JCamrN5hM1
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

---
Change from v1:
1. Added CONFIG_MEMCG compilation guard to apply_proportional_protection()

Chen Ridong (2):
  memcg: move mem_cgroup_usage memcontrol-v1.c
  memcg: remove mem_cgroup_size()

 include/linux/memcontrol.h |  7 -------
 mm/memcontrol-v1.c         | 22 ++++++++++++++++++++++
 mm/memcontrol-v1.h         |  2 --
 mm/memcontrol.c            | 27 ---------------------------
 mm/vmscan.c                |  8 +++++---
 5 files changed, 27 insertions(+), 39 deletions(-)

-- 
2.34.1


