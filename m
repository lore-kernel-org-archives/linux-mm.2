Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A65E8FDA5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 10:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A6B6B008C; Fri, 26 Dec 2025 05:07:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912366B0092; Fri, 26 Dec 2025 05:07:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811436B0093; Fri, 26 Dec 2025 05:07:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAC36B008C
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 05:07:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0879B138DD1
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:07:14 +0000 (UTC)
X-FDA: 84261194388.16.25BD7E7
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf06.hostedemail.com (Postfix) with ESMTP id B964C18000E
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:07:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ImJTDvuJ;
	spf=pass (imf06.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766743632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHCEbvNncUuRInD7vc2/gwTA6d8ybu6jRUaqdDQkZqk=;
	b=gXuYcL8HbnpqCy53z9k1r0CfcUwlx9eeqyG6EMM0m22fjIuem5DlvfRhJjznbZRF/eRsXu
	OCml6pXFWaFS9j2XIc/O/bc/++inGTSBIGHIineiOOX6s90ElY6cgemRDGmAm7KgkRMPyn
	kbpyhCrSSJn/vzvs20INwFVLkgk9zT4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ImJTDvuJ;
	spf=pass (imf06.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766743632; a=rsa-sha256;
	cv=none;
	b=R3Ssog+DlscFrmAIErGtvwEUnkErjw97yX8Ho4uFvzZNIGK4nvrGkODWr35uoe4UpXWPP7
	mh1JnV4k3hlLZYYgkNZ73os1qLNApQU4bbiwOf25ngVh/sOX9w+lRQ92kt3CazFd3gnr1I
	0FQzH3onlw4R2Ew5tRXQIh32zyehmFs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uHCEbvNncUuRInD7vc2/gwTA6d8ybu6jRUaqdDQkZqk=;
	b=ImJTDvuJi1+ZtX5SRSl+cYjB+gjMZvdy7CfO6TcarAyj6li0iYNm59timP5kR2LiErVcKYSKU
	3rixA21pODZizTNSIRyouLGsgHeqXYwUeHFK+PfzDq4orVgC0fuIHvKFa5vt0oUBJ2xsD6MgTXf
	RFEXlONDUVzIeOzu/ZIaknQ=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dd1RH4shKzmVXB;
	Fri, 26 Dec 2025 18:03:55 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 793D840563;
	Fri, 26 Dec 2025 18:07:04 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 26 Dec
 2025 18:07:03 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <corbet@lwn.net>
CC: <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<willy@infradead.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lianux.mm@gmail.com>,
	<zhangqilong3@huawei.com>
Subject: [PATCH next v2 2/2] mm/huge_memory: Use per-VMA hugepage flag hints for exec THP COW
Date: Fri, 26 Dec 2025 18:03:37 +0800
Message-ID: <20251226100337.4171191-3-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251226100337.4171191-1-zhangqilong3@huawei.com>
References: <20251226100337.4171191-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B964C18000E
X-Stat-Signature: wbsmqwp3utra6mtcx6zj5mjp9seuk3xb
X-HE-Tag: 1766743631-296598
X-HE-Meta: U2FsdGVkX1/JlMjq/aDzLpJIePYSpqA3DPBeuHzz5TuPgLy7FXbZnFCJlQj0uET1sfu4uuRjAtjxdkzWGBNvgVSXf66qEBVAnSmT2F2bP/hDEajUhNJJfw6hajLcQdmWoeaWmirS5xFkacJ5L24V9cxlVBFxibvobB1RLevJcimBMc3FA0hiB4ZyIHREF6Khjj0lJsb1vXenmfLsVoRTJpw64pveG5ocX45RMZJHYAnLv9biI6GSrXfFmi897+gmpwleAcvD/yMN3htLNpdMIC11V83O3VHfsMXnDj53q/Im2kqbA4GYBCQh7N5MIChAJ1DPhCb3NCFcNAVfifBL52xTYGsFVJGSDfzQOr+MaceO8zRrWie9nyXragNAT5SQA/Uk1ihPJ6INqnZvuivhbGWW8Upvqcl9tE9mAxdeJytcWBHdpySI6/A9fhz4Fo020joi3arGjtO6NqYoTb0PA8rt7foKx/611HpHyROJtlh8V05omIK7lov37OzraqhwJA1yQa1wcqMK67OQCBSlAuwtLWTNuEYhVnPHlxy4qQtn9lhSICI3MbkkPo5Tv3Gb/R+a6h52Dad10NnyEt5pEtcBo+N3WgoIZS84QadM92U7oUmcdq16ymXGIHI2QuTn1eS8/YaxXDxa4gYAeOSD612QtX+Eruw1+POKx9FCOLrHjc/wL4p3VJwpIzKyp6GNQIec0laTf7mv7OTGzZ5S7FJ1tZd4DattMMKJyzvnLP0xdhak1zHPCw71ttgoljZIapblWRa6293rQ0Ug/qTuFlpBxlo8AOuY9PlgTdbbCz2qjOy3q2AC4c2NABzPYLZooNgXmkbwnMQ4UWEAGTNxPLluloSpaf6hN9kZ/RKqz7L9fvdYKhHjMQ6GDn08QwxVAOuJhjRWT1rB0S10z31U5q6BWmtzzXTY4AcaXhbjO6nbVgU6t59z1AypuXgUCv8tcThbauA6gRX+SwDE6jx
 mfcDSII3
 4SqWAucwlgGKaXZqo8eW/SU1YEn1wbk2RhNuo+hM0qA+pIIxDDAVn12u72iaoelk7ls03uy/+vKybywWhoif9a7MX97oISA/oa/9vTiRpkxE3sUmNXy6199tyrC+7GHKflUwA1SxEEliL9A7F/vI0Gq8dLqJVhIPurdFyB8trE26Y+0IOo1i+UU1gu4vz4x/mlJXYVPli4VTtnJGYmrpviF+hIxmxSSRKpsS9BpAv2P9KiFcytfw1l6upFXkGxGmIpG3s5iEIAZZWOOxnyP9JNv33xgW7vy8nL6d0TkvytHYLnokgmXtZhK8Cp5OgwCRsaXYUv/hVgrlFv0fc/blktXrq1G5QOOyey7scoifrEsQwVmYiBAOjyp93j1QuJJ2Wfsu/3+dkD0LvVECXZi5bHoqns9Wu4vX+1fxDKc5oHYAc03M5QsgV4l0wvlB5RKzVdAjMhM4a26zASur+F09jEmNBig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using the per-VMA hugepage flag to avoid system wide default
behavior. If 'vma->vm_flags' indicates a preference for huge pages,
then the exec THP COW can be attempted.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
v2:
- Use 'vma->vm_flags' as hint for exec THP COW suggested by David

---
 mm/memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 691e3ca38cc6..eb2bb36e284c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6128,10 +6128,17 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 		}
 	}
 
 	if (is_exec_mapping(vm_flags) &&
 	    is_cow_mapping(vm_flags)) {
+		/*
+		 * Reuse the per-VMA flag, only if VM_HUGEPAGE is
+		 * set, do exec THP COW.
+		 */
+		if (!(vm_flags & VM_HUGEPAGE))
+			goto split;
+
 		ret = do_huge_pmd_exec_cow(vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	}
 
-- 
2.43.0


