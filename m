Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 139E0F43848
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB336B0095; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4B6D6B0096; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61336B0099; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B09F56B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EF981B7EBF
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:34 +0000 (UTC)
X-FDA: 84661371228.19.CC7C6CD
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id A51B2C0002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776271652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HKT0S8uXtNISHrTUxLi056PCG1DaaP6l+RnI1w3ReX4=;
	b=jmEGyeOlyH0mJherh+NXPShyY9DTPUcJpvsnH9QtjQI2sE4c4jUUleMjWl/HT5Oeh986eI
	Qz2P88K3KRfE1vOiYZg+IsGz3vP6QFER+hf5YNZujOukgmtag60aYSmHB2HSjpOnY8Omgg
	PcM/G/NZN7PWxZE0AN3sZSuDyhyUUrI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776271652; a=rsa-sha256;
	cv=none;
	b=LUKPyI4uR2jP57Emh3MPDoWhQaq8sEkSk/fKDQTC8JD/Z6hB+q0vuzNspZYoH0M/KHuhTh
	i92SHRv7/pmymr9Mxyc3orf2n86vTrWCNKFSMzU1/yKaDiLRqqEOIJS0TdK/UCtt0Tgiva
	mhhsyDzDOcK61iCPbHLwPgQP6AMYwLE=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwn9M3DGbzJ46Dy;
	Thu, 16 Apr 2026 00:46:47 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D198D40569;
	Thu, 16 Apr 2026 00:47:30 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 19:47:30 +0300
From: Fedorov Nikita <fedorov.nikita@h-partners.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Ajay
 Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>, Arnd
 Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng
	<boqun@kernel.org>, Waiman Long <longman@redhat.com>, Darren Hart
	<dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple
	<apopple@nvidia.com>, Anatoly Stepanov <stepanov.anatoly@huawei.com>
CC: Nikita Fedorov <fedorov.nikita@h-partners.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <kang.sun@huawei.com>, <chenjieping3@huawei.com>
Subject: [RFC PATCH v3 6/7] lockref: use hq-spinlock
Date: Thu, 16 Apr 2026 00:44:58 +0800
Message-ID: <20260415164459.2904963-7-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
References: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A51B2C0002
X-Stat-Signature: foax5ceqwupg61d4gi9seeszrmbzotc3
X-Rspam-User: 
X-HE-Tag: 1776271652-230768
X-HE-Meta: U2FsdGVkX1/oILJYkAZ0MWPzagudoVaSMg29WTiEcmBwz7JG/QnMwySQzP8Fl+fX63RtEAhJ6cT/NA3A4y5ABzhXRIzpfLRElFMsFwZcDr9kjSXMwBedHlRmBgK8AsoHw7PMlBllua8s0LjMXndyVSyK4Us16T14Rfsfvncu2ghi9+s3XAtsa4G+ECwQ1Le0wQwYgaNm8WIcunWoMONP6BrbhT7MlMgX7TsP/CJaofcwiBNI8+rgIENMuaDSbbdfVLa9CAnrIUIZsNMM1Vz4e+ZlYPf178xPq3WZcBZWRP3j4KjBtpuDdpkBljQMuTQv/QBH/ykHnKnWFFWZ6pTkv/cUUIbyBM0seQBx2F0uNUQukygrqmsfPb+VnRd7f3ThL/mlTnbfFl2D2YFFF2xf+NJIKaccZ3qIjVdDl7P1K4MoSJaYn6Gzp8+TRhFAcKlWJ0jDj6G2jmTIHBPjy9tb3ZgvU8kHpQEbQiMtK/2Ul1/4ZZTlFOeYm36OEoZldOLdlpI0taQj+5TlJ9F6WAbdT/Ih2Q+hakm4qqwK2Ob7oVxb85bbg5RfLtTSHuO/qrzRa306Elkk4YxizOvV8iKFdJAnK++zGfKBh94CcF6vrYWrMIStnRheuUNR1WWCc8XhKQUWblM9tCpKXdhxmUHgPGBwsQU3FwyH7Nn6C3adeaxIgUZspJKKrMXl5bK51FwqNXGMTclpOzXGR0vqfba/KtH/tso6kXRLAvQ6SgTXqCZNBJKZgf7VoibTK+eKpeb1HolfR78H0vjOd/Rr6d1MGAC+6R+ZFiU7arY2vgbrXl7SQUq0FatnLGwKYFwo1uz+/fJENMVoJtgrb8cb1QOrx7gLhOln4gpAm9fZXrv9ahSGCswT82KfCB4bdQB17CCzg1BaX+gBJRpN0OhTgrVOByxUNydNBqGhvZzVapfIWj2pBezmNdTwGkJ6mw5dBN00Qh64qTCvl1JJCcTs59G
 MpBrV6RE
 hgAqDUpLkFjIGXRbV/2wDk5S9qYFC/1tChI2eDslVEGMlsoLtcfykvqKb8hULFnStHULLJqzEN3AhdtuN0P9h1H4HxO8v3onQY7PPeBMeLLF/y7ZwqvHkuwSNp7CvX/P9rKktgSG4YZUz/XV584IUKxC8eTkqTHZPNPHxgUL7WR/TrbGqQ3aYZFpLbvuZJM+2sepGv2ZpUT9b7HLNI2Z7qRKdhQzWE2/y9I79moJGtEtXAHyXz+N02wn2qz6VOgVqho41ygQwQvu4Rueg/U/oGVMaRrbIt0+ZYtd9xR/Uq0+uLvVi3ZJB7p3XU6Mv6UfRFKEsxp6W2gDoGKpEkItjwsU0QoQz0DB7ArACMxcF6uZTV7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Example of hq-spinlock enabled for dentry->lockref spinlock
(used in nginx testing scenario)

In the evaluated nginx single-file workload on Kunpeng 920, throughput
gains reached 68-78% at 64-96 workers.

Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Signed-off-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Co-developed-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
Signed-off-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
---
 include/linux/lockref.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/lockref.h b/include/linux/lockref.h
index 6ded24cdb4..19a1c3823c 100644
--- a/include/linux/lockref.h
+++ b/include/linux/lockref.h
@@ -42,7 +42,7 @@ struct lockref {
  */
 static inline void lockref_init(struct lockref *lockref)
 {
-	spin_lock_init(&lockref->lock);
+	spin_lock_init_hq(&lockref->lock);
 	lockref->count = 1;
 }
 
-- 
2.34.1


