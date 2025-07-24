Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B946C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73DF8E0080; Thu, 24 Jul 2025 09:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A3A8E007C; Thu, 24 Jul 2025 09:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3A148E0080; Thu, 24 Jul 2025 09:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2A3D8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 673AB803CA
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:45 +0000 (UTC)
X-FDA: 83699308770.04.DA06395
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6EE3B80004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ATW0wBXl;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365403; a=rsa-sha256;
	cv=none;
	b=SQuEhEwWzEOZFIPcFnRDAoLbggCk+BrYNerWj31UNFHnk2fPdkS+FZZASkvzLvDyrGJsip
	YkpTt+aZTe5BSr1a8C31cbTAWaZr3gwYBC04x6kQiefESeXpWGmEAs2gESPa45nJ4CJ/R5
	A1Ql2V3wyyvgAUVVoeP5ZnSh0Tk5kxo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ATW0wBXl;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dx+zx3hCg8Qz6JMSxLg+rjsObdnsN3uv3uvSypyoc0Q=;
	b=zyBMl5aWR0S/BxZoQImrfoSzd8s1tQVvlQtAX/bTTEN/AOaCNLr++F2V4JJCRKTYg5Eouv
	nJnY0QYX70/+Zfr/fk9yEiMDFsMMbyPRe04UjHICLLZlGuwusTjhxHRDwxArMgy0MN9Q5N
	MzBo/XuSOZ58s1irA/EM6rOFTmMEED4=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-451d6ade159so6665095e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365402; x=1753970202; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dx+zx3hCg8Qz6JMSxLg+rjsObdnsN3uv3uvSypyoc0Q=;
        b=ATW0wBXlkmTO44Lus1xAuNDkZuflIW4i5OkjWNwVL0Yh+Izokhx8TYdMJZLvpBgIgW
         SH6jfO+Kgvf7zLcP8F0u5hxHxIW5lbOgjRuk2HIYu7ImAepA9T/sVVtnt4lFZPjM3L5j
         oHypSftFhTwOZZYy+XD+aApul8ym+J7ISi8Q3czsHYoLXjQti0eTtcgiVikwKmKH0JUP
         GDMl5ZqSQymddXrAxqhgVHtAsEkSTHOaInvAnqbNSOMKm/YZn82MfFDd6FdQdPBbZ0Ak
         PnGq1mU+yADLfcUy1tO0/rSi5EeU3R6DQXSQP089od4ewoNLV4i2EMwP7Ve6iZpBxNpK
         wsJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365402; x=1753970202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dx+zx3hCg8Qz6JMSxLg+rjsObdnsN3uv3uvSypyoc0Q=;
        b=cZQ5IjTcQYtSI2Qo+H2bwkmXpziCiB0R7jPeXS9ZUgnVLby3vJDnq75QOcvlULNQq2
         rb4Pv6WQxS9U+LKn3d7Lhj5LrHWxP9BmWyutF2fJgWGxgvpS6lYLuoCz3p1VoT/la7rr
         EfYSUPGGb68UTh2kVYQ1UR2t7VEVhrrBB6kb1N+e9t35zjUCi3ZJi8uaCz/C0aePgKyO
         XdPWrrr4R06ndTGwp9TNc8qOvKSlQcl4HbOFlaKGdpVL7S2bFbdCF3h8SF746mtXhT6d
         fO8jEkfaQfKehwiYnzBIpuRr9wqXbVp4CLUfNhbA3+13XaVDGR4pL8Fg7g+24U1sM3G/
         avzw==
X-Forwarded-Encrypted: i=1; AJvYcCX9Lcm2lNk77gJzsoKzyAL6mju7zA5ksO8P9gCT+OJXltf+nIZ0mAdJdCaMBWFPyuOgJgWhoKU4Sg==@kvack.org
X-Gm-Message-State: AOJu0YwOBhve7i6AOjiZ/iJLGMSxXw/7oY4WyzHCedihwcpSOiMiElmY
	EVBe7N7oIbItEyQ3Amv5RAFGDDdmbOtUXBsLbylyj25GtjMlgXIGGR0x01EHpRlnDxw=
X-Gm-Gg: ASbGnctp/t6jvvaDNZ3o9keIqHpuf9mmlY5TDbAL82NwO3K0VBnmzkfZVmyWzvlECzT
	7cGhtCoF1oLntEmzGHiYXiukS5DSkOj1bn24WCIWpe3aMafhOowa9pv2poy2ZR+i5kur99ibCGu
	UGEuljYCmNTDdGNxCZJCTJLnj94xgoGCpAgCsVxlSqj5dUvmQUmwBk3A69Q7BxkbuJ65Ve0/9sO
	g7BiE8JGPepTXq9/128IL77rZNewIOFOQLYcWIQTwNbXMK4Gjvp14tLZLPqg+PBkNCk2sisevKj
	jAD8ENWFfAbx3aQcNjLUCxv8kMBRPsxqVZZnYLKb7Bn7whSs1IowVHIQZ2YAATiYRjN20pgQbbB
	fmj2M5wJqbP1Eq/QHq7L2NgVfx0qrz6BCBeUczpmh1bA/MnE5nIxnGqera1WEUT1m1JKxkIlJpO
	NLSfIT1c7kFd1W
X-Google-Smtp-Source: AGHT+IGliARSjFjzMbqI3XaGwe/LefU8e+9kx8i0i+1k/+nyeMB8SAYvSTjLiytSObV6pAe7PVl9aw==
X-Received: by 2002:a05:600c:3583:b0:456:161c:3d77 with SMTP id 5b1f17b1804b1-45868cff2b8mr75404365e9.16.1753365402037;
        Thu, 24 Jul 2025 06:56:42 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:41 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:05 +0300
Message-ID: <20250724135512.518487-23-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EE3B80004
X-Stat-Signature: 3o719zpsm8tw8e73d91zbwasdnhh4kpx
X-Rspam-User: 
X-HE-Tag: 1753365403-200132
X-HE-Meta: U2FsdGVkX1/uCbrJAawuDRQs6Zw5upFNB5xLqG06avwdU8MuKug9RKG/itL0RsnBbn3SNS7xinqmLTF6K2buahRgw+MizOMfQ/umrFGOF2RnxNAMSxfoVIkKsShodpRXviELi7vEqKtwfQGR6wRlLSepSt49s+wTQusqH7tZ+YUkf8iOySUDE9nA1amqATkcli+ejpkMTFjGDsKfQGxovQ0eWGNYM0ohhXtignQuEd3VpQp52Dg/Gdk7zzRL7u0POpBpQExCA5YRcK0IjMRVlI9gKF4/XkwWZukwG5K0xZdN3QFFtwvsNIZ3s0Jw4v+LBEDpSsKMOIZZPsOx2g/dRR3/Zuupy59pXEd9zs6u70YZFtAajpQ6o2CGukUP0NySE9ztxqzg5Mxvh+s9HlvzztPMDgyeqBOFHGn0XVM/hZ85PS5Wh1Po1DeteIVBgXJR1ZZs9GUnbl/qxX6+u1ZBEj1Q8IPBM2TEmyRRjC+JXEwSVxe/61MlY6O7il0VC5g5IoQEOCvB18buRbJMFi2h3b+nIh6/TkE5tP07uMEK940hGLNxmapGreeQsNZewob+71AXtccVlQedYxsllw0iIFfLnbVycsc+UnmAsGp21wExhpEwIgktz1X8K3OnU3CYxumF6YATm+97U/1VVhK6v5Ai78EPfzmtSl5OFW0ro6WdRE1g8JeoYo+K3FylVg7HvlABb725rzshJ4rmwzux/20YXCfAY079z+a83ETS9Ya67x/dQ800nm0/moWcyCoJ3/iaxGTu0pkpgJMANNSkr96/FIQtxcYFeul2qxUKdJPKdFJ4iNGAK8UGU3a0lWB19YZbVwvVbrIuu9NfiqppaJPzEVddIjzGcq27BbblosB+iJ+Z2Uf6CryVnEvrBj54gAeBUZzXXLCKMq5UUnExPwXXZ+DRfuLRe50pEu3OmD1HSzLaTu+VFIaQoF9HyBKSAQRYJC1daxSJK9eIR/G
 GpaRArtM
 jeS2xDsdEjX4rRVT4h+3qvUkem8MtIml1J/AECu4YvsQHLiLEyP0GfJ1z4lGF5P1YAW69pnIN+qBA9Gl/8G2OD02OY6DkeOOySrTdY3tD5OvGdZzwf12Y1NQFyv9x/jwWPKiFU9s40zMM+8zynZ7YHbsXHAQL5D6gI0kCM2IHUvZRwnjisriAgE9Ecfm98qq7fUhePE5PETtuEWHtKzH34iUHRkcBI4az2OGMgzwTPd/FwsICmwraEqyXofQTHD00slEz3Ir2aLAMDD9qfZsh+Qa1tpP8j4ct48/nsAwjIMXwetRib0B27fR669D56g2IrOMDDcmf4+TwdGNq+t8P+D05Rew3QYM3AgQkbfwb5FU7fAw0wOfNgAsEHVdwOeKP1RDS7feEGMPVo5EQtuO8xuv7bA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - node_data

Information on these variables is stored into dedicated kmemdump section.

Register dynamic information into kmemdump:
 - dynamic node data for each node

This information is being allocated for each node, as physical address,
so call kmemdump_phys_alloc_size that will allocate an unique kmemdump
uid, and register the virtual address.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/numa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/numa.c b/mm/numa.c
index 7d5e06fe5bd4..88cada571171 100644
--- a/mm/numa.c
+++ b/mm/numa.c
@@ -4,9 +4,11 @@
 #include <linux/printk.h>
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
+#include <linux/kmemdump.h>
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
+KMEMDUMP_VAR_CORE(node_data, MAX_NUMNODES * sizeof(struct pglist_data));
 
 /* Allocate NODE_DATA for a node on the local memory */
 void __init alloc_node_data(int nid)
@@ -16,7 +18,8 @@ void __init alloc_node_data(int nid)
 	int tnid;
 
 	/* Allocate node data.  Try node-local memory and then any node. */
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
+	nd_pa = kmemdump_phys_alloc_size(nd_size, memblock_phys_alloc_try_nid,
+					 nd_size, SMP_CACHE_BYTES, nid);
 	if (!nd_pa)
 		panic("Cannot allocate %zu bytes for node %d data\n",
 		      nd_size, nid);
-- 
2.43.0


