Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C8DCFC500
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0F56B009B; Fri, 21 Nov 2025 13:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1976B009E; Fri, 21 Nov 2025 13:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871F66B00A0; Fri, 21 Nov 2025 13:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCE26B009B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A8071A06A6
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:47 +0000 (UTC)
X-FDA: 84135518334.08.AD02DBD
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8F5EDC000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=nH76roIl;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751345; a=rsa-sha256;
	cv=none;
	b=b3hfndfDmghKkIP9nEhs//WHgsOFgGUKNsIQwOw/G8jCPp9rbSI0QuamLS4Ej5ph+wcjjb
	AFBFOJXsQz9iDzypYsk3sG1ps0vbBDXXhsy0y98H3eMoWCNCaaIzxaCx/FV1HlLLhM+LbB
	GDtLYZSkfRpmzlFWDD5Yqalr8LSOGJU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=nH76roIl;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zO4x19k55VdNyjCXU0v5aeF8BxFoVMCPY3uuyYoVlXM=;
	b=47lW2OoJ9ZOO38s7pZKl0wXYzlWoT9A3OVmAJo0in8U+e/eF9BkFS9Npdja5u+MmRvUBde
	XgAksHXItpQWFc9eF0bNtQwwY/4GWzBY7/hI0J8Wtka4zSO4368Md/QseNk4Z6KKY5vzoZ
	RzNW9k0DhnqN8wKzxk2pLgtNtquFdBE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zO4x19k55VdNyjCXU0v5aeF8BxFoVMCPY3uuyYoVlXM=; b=nH76roIl0112QJWoy/rkGn3t87
	EyFym6veATc3+d+Igg0TZTizEsouClhXPB2EyopQhBpAAqz7LwzcCiTEPleamTMdqxZ6mGoiatW6+
	k7bF6Fm2q6udc5ch5aO9f2jrgPbatrR10bIV3Hvo9Xpc+pcAcXO43YjdYDYIGn20gRmRMLcwyicd7
	oZxd1UmQsE/qPepAOJC7MIRLqaZIS4ptelmM7Dwf44BTBqGkxqg+WOMpLn1ZwGsPZQu3uFxG3qLdA
	p0NU7UCRHskoD7BSjnP4awN70aUY8lQEBZlHihf6FK7990sik6jch/OUi1X6KpGomsgKwGQ/JIVYo
	0yHP3o6Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-1Es7;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC v5 1/8] x86/mm: Introduce Remote Action Request MSRs
Date: Fri, 21 Nov 2025 13:54:22 -0500
Message-ID: <20251121185530.21876-2-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121185530.21876-1-riel@surriel.com>
References: <20251121185530.21876-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F5EDC000F
X-Stat-Signature: iekp1qgxn8eubi8pdzsdgkwzgoe1e8jf
X-Rspam-User: 
X-HE-Tag: 1763751345-38727
X-HE-Meta: U2FsdGVkX19Xv25wniE+4e1qeH3GPAAQBpm6R0SCJlLjXFJdrtLqVuyRocaDL/SUiqYW7nv3zNuVodU2z2aK0SX5J6kUBtanzaWlIGnD8WbGMy1fyKBluyGMaW+xn9+Soiugb42SnnzQ6TUCzuQOz0GCsemw0zVbdimBgKHf80uf0l326lby4nciKybm/4Qceb3ZQxjcbBUL9VAhsvPOfcK1FYbK6qjUlZb7uxUIN8kHER5l/ygNGwsV8YX9ZD4oLztgrsbqWwKCkubXlg+fOBDvxWxMDOWKCQLpKr6MvawrsbP2/0q5LsJUJhkiQ4TgH9YmxdDHZvNOVQKlxkRQ6RxPw5YW1RGJPw39N4BmKhXTFPk6aXqFJgKgMy8eLldMao6s//AEPN5udOKcnzzfZdJvuAK5u2pOnDc3dE0uIarjU9VA37zJeWjUkkw6Ulio4HWw3R/5MyQhZVu8FSh5COfuoD153tzWwLkMXGJ2Eh/DJXbXMd1Z/nH1MG2xnXiMsoMuikXjWqV1mUDlYEqyq0NEI2Wg52nEV5AWud2Dn+OoDgtILQdg2xGRZLUYoTVYXkjizfbJ67ic9Rtne8/JwC41tXs9ACP4i+GM/AakXYzk6mGAvTu8I473cM1rbJGHtVVT28pq4RTPgU3mA3n31VKmF3m2IzUL/ZcSceUkuGuUM7/3T+OTepW2RsAnKHRxLx7DfA8OaY2RW7Q9KovfkvpbzYYrlA6ntjuS4bj8Ka0rQ7ZVN1k+r4xezhxLW+CW0LkJ33phspG+ryE+sYfjOiuDzKCSy/EZMkc2bFSG8hBZ6kAAJk/MFSktQ4wz2FJE0nZyRht110XdIIqQ0T/i+KLrRa/87qgmJSbVGksg2ifWwLADdY5jyvXu81dR7VeuoUshkV6u9tgzP/yo0asJIT6nRx/VPqexZS+/CI3KuW8Qx5nNCU+J9UykuZQxSReMN+D04NmY/j+VUmA0kTS
 Mc37xAML
 dwLyXPejk+HOrAawd2Q3/Wah6w0S8r4gSyWeohghtfBxzNLkSEEDfPQw7ifA0vnXQihrtu6sD5AeXUNliScmACG9gEChiqTku0l9AJ+5LaAYEELOMBGe96SLTU6VoNUY7BPwrKjAxztinbT+OedMinrjwNkZD26CbIMYGSap/jPXsbdRKKLLYyjBQSVk60IYGKTJY/bDcVFlHugB7NSsJ9CpUMLpBNGm+YuYk5gMKorLx9oL3RvIxL+ruoX9e8n1vB7SXZf+JIqysiVuMirt+oUjzvVNLlRX7BDMKQk9DBbmpjiA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu-cheng Yu <yu-cheng.yu@intel.com>

Remote Action Request (RAR) is a model-specific feature to speed
up inter-processor operations by moving parts of those operations
from software to hardware.

The current RAR implementation handles TLB flushes and MSR writes.

This patch introduces RAR MSRs.  RAR is introduced in later patches.

There are five RAR MSRs:

  MSR_CORE_CAPABILITIES
  MSR_IA32_RAR_CTRL
  MSR_IA32_RAR_ACT_VEC
  MSR_IA32_RAR_PAYLOAD_BASE
  MSR_IA32_RAR_INFO

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/msr-index.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3d0a0950d20a..69d9e96e8324 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -110,6 +110,8 @@
 
 /* Abbreviated from Intel SDM name IA32_CORE_CAPABILITIES */
 #define MSR_IA32_CORE_CAPS			  0x000000cf
+#define MSR_IA32_CORE_CAPS_RAR_BIT		  1
+#define MSR_IA32_CORE_CAPS_RAR			  BIT(MSR_IA32_CORE_CAPS_RAR_BIT)
 #define MSR_IA32_CORE_CAPS_INTEGRITY_CAPS_BIT	  2
 #define MSR_IA32_CORE_CAPS_INTEGRITY_CAPS	  BIT(MSR_IA32_CORE_CAPS_INTEGRITY_CAPS_BIT)
 #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT  5
@@ -122,6 +124,17 @@
 #define SNB_C3_AUTO_UNDEMOTE		(1UL << 27)
 #define SNB_C1_AUTO_UNDEMOTE		(1UL << 28)
 
+/*
+ * Remote Action Requests (RAR) MSRs
+ */
+#define MSR_IA32_RAR_CTRL		0x000000ed
+#define MSR_IA32_RAR_ACT_VEC		0x000000ee
+#define MSR_IA32_RAR_PAYLOAD_BASE	0x000000ef
+#define MSR_IA32_RAR_INFO		0x000000f0
+
+#define RAR_CTRL_ENABLE			BIT(31)
+#define RAR_CTRL_IGNORE_IF		BIT(30)
+
 #define MSR_MTRRcap			0x000000fe
 
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
-- 
2.51.1


