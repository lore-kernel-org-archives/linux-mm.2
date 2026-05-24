Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9644CD5BB8
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 03:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAADD6B0092; Sat, 23 May 2026 23:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B716B0095; Sat, 23 May 2026 23:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D986C6B0096; Sat, 23 May 2026 23:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C50BD6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 23:11:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 533BF1A09E7
	for <linux-mm@kvack.org>; Sun, 24 May 2026 03:11:39 +0000 (UTC)
X-FDA: 84800838318.21.1063C79
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf12.hostedemail.com (Postfix) with ESMTP id D030E40006
	for <linux-mm@kvack.org>; Sun, 24 May 2026 03:11:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=a6ly8jQw;
	spf=pass (imf12.hostedemail.com: domain of wsw9603@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=wsw9603@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779592297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DyqmddIWKaGSpB/GUFD1AdFn79TKghn9LsBISCzCwis=;
	b=t3RL4aRz9XYiWuRjVMwnCH2q6zulJa3ACqs/HCr3SZNWfEEu4o+Tgu2anVX0PhkfgWYSBG
	nkhckMQODxCwdIMbSV01st4k4PQj2d+rBdFCbFMXSc8f+QSRLIIZX5TTmtcnKHzHJnalon
	/2r0JIDbqV1Dv5hWU9VtImQlfaM+9M4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=a6ly8jQw;
	spf=pass (imf12.hostedemail.com: domain of wsw9603@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=wsw9603@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779592297; a=rsa-sha256;
	cv=none;
	b=yGjLtG/IsVsjG3e4ODxEYiWrVrFxxD3Zgh6DnW2Km9NwGbn5wJQN4JvqIbGiQyl5bZsaXO
	8rOM5/Fg+zTIsxA8G4h7hpnkUu0E10NDIluhNtIk3NWQ/oAGD7855iBl1H26Y8wt78KC7K
	4t1BW6LiuEtOzeZ/s1FcyPuL5IjLP5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Dy
	qmddIWKaGSpB/GUFD1AdFn79TKghn9LsBISCzCwis=; b=a6ly8jQwlmRAA2/YZo
	DdovHeYb7XrNMeVgkzaXGuDApKguyhQSZafVFPnZk4U33ucx4zK2+oGcHa9knPtt
	bOrduw5DATfcVGw7xOOIW3UD7bE6HsSyZGex4jjZ0OqzlsoIBlMD88qI4cU50GWr
	oFJ5l0MadEO2qlpbPc1IzE89Q=
Received: from wang-MACHR-WX9.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wCHPxc9bBJqGzx0DA--.36645S2;
	Sun, 24 May 2026 11:10:54 +0800 (CST)
From: Wang Wensheng <wsw9603@163.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: wsw9603@163.com
Subject: [PATCH v2] kasan/test: only do kmalloc_double_kzfree for generic mode
Date: Sun, 24 May 2026 11:10:53 +0800
Message-ID: <20260524031053.381776-1-wsw9603@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHPxc9bBJqGzx0DA--.36645S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AryrXr1rCrWUGr1DArW8WFg_yoW8GFyfpr
	95t34rJFnYyr1Sqr1UAF4v93yrAan7G3W0gasavws09Fy5Gw1Syrn2krWDZrWkZr4xZF4I
	v3Wqyr13Ww1DAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi_-B_UUUUU=
X-Originating-IP: [223.93.186.229]
X-CM-SenderInfo: pzvzmliqt6il2tof0z/xtbC3gBKUmoSbEBzgQAA3g
X-Rspamd-Queue-Id: D030E40006
X-Stat-Signature: dxxcco7muafforo9smkemkchciy8yssa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779592296-643901
X-HE-Meta: U2FsdGVkX18LoF1kkbeg61AgeHssGFQpFVGThArSFaXM2ehS8Nzt48nrGzzI5STNsttw8x8QVuLiUB6LjhDrq2lEFhqQDTP6n3YixgyqHQN6Dv/PCrsai/R13OCvhjkpOLLOcEIT3lre1WVh64eUBem2GInKP0biJ16BoM8d7nnmaJ+PuAIBDtEwE2Ax0w9KZYTrHqWGgyIqXNhEvMCuWN/A9KupLffN4a5Qs82K8CkMCzmpZsjWKOkj3Nt6mbjL1wXO5sEh5t4pS2fbrna7a8DmUYDlhVlBKxuetu8Ti3j1F3jTmXeT+2S0sXrWkz94mHrCWwMb5Wl6uGOMyaTTuixmTGIwjdZDi4yXZbqoyeED5EEOV9V252LdNGvJcCuN/1pKTJ3svL5LF0Xq0DR1VKiZbmWuzzVuB42mCcnX0Al/XsPC/S8kcFXbIgOwiXu+A7KuW4K0D3Ek/e5jCbyzEZAJXZ0JbhzYb8FP9tshXOrZmRVo3RvOcqMD7w/sT3nrqkVMEgyPf5KgCvugw37rsjR+OCabnJHpuHq9YcLpE27BL7XQTbn09IPpHkgon/9S5BFprKEAA/dKUVm/5rfvd8cO3UTLtxCnf0DVdPJf/TS/9ii2aIr9bUbZLgzWdyDxyVl5npB7mREAbWDxg0CiBBt2NwpQH9S8AMPEkHKNomXpuTMLNPsRtGC5CjS4i1713gKCVliH5pw7ZcKI7u2w+SKLbFha9APoZs6TAOfRUWQfMoZKVIg++KpU8dD5aF25IOzwGPmmHrZ978dW6apy0o/axOFMVJT2fj4D4YC6FO9SuydboaQQSjGj5cbDVxesTSyzdD81I/UqEtOsIu7Ln71Uj8dH8Y3NBYFUoFdr08yrdxqMNBYumAC8/zvPYCRPvGu42OXJOus7VRzbb9PHdzfFpgT/ADSHL2Ra9mlfdpOdhhf/9WMwqzeHkizHQMRr/bcbYpqYA6Uk8RFB0SA
 lY/JTSXR
 QNi1Tjxy7kL5I3geN9Gj+lC6yhFhm7w26lsb8KFAcwc/21pWWys852c7lIkNHBw7nLsgeT19pJNNDD+M5QEAvNsNqkc8vVPxtH+nZFu/+NNkg6F6Lunol8y6eUeJxxPd9VhSq3yhwefF0d8msnQ70paCyD9jqK7AeuJW8dQcqt8OlnEjSPgr+qBZ+7XC8LN9GkPq9mubEZB7kwdt1BNL/jqh/agDe+/1cJ0owlTQngVRPNphxMC3t8s2xAWfye6TRLcyg5WoWIGKSFU3f7ckVy5+k3dqA3IeUaxuhZQur4QYcFDqYJ6jY54AsziW/Ryrfmpu8DZVMl9J0U+5i2QV7n+VZmNLOyfGhdhHTUwsRHV55rx6n+pC0+Ghv1iObu9R+vjsWK68Pa5PSU2mz5j4al8Cs4XdAM3dAgKWMqJ1bAwQNBCydSwo03kg06kOEgxuJtiZmlGPZ5aeqWY5G2+0Kv4Ti/wQ7b4z6Xcj5wgSOO3CNvh6SDWeXpW8Z0/0q62kCGCUsLntrGpXg+kTDEwg/X2xmiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmalloc_double_kzfree() would corrupt kernel memory when the just
freed memory were allocated by another thread before the second
call to kfree_sensitive() and the new allocation tag happened to
match the old one.

This could not happen in GENERIC mode as it uses quarantine.

Signed-off-by: Wang Wensheng <wsw9603@163.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
---
v1->v2:
Update comment suggested by Andrey Konovalov.
--
 mm/kasan/kasan_test_c.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 32d06cbf6a31..3f4ed29178b3 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -874,6 +874,16 @@ static void kmalloc_double_kzfree(struct kunit *test)
 	char *ptr;
 	size_t size = 16;
 
+	/*
+	 * With the tag-based KASAN modes, if the memory happens to be
+	 * reallocated between the two frees and the new allocation tag happens
+	 * to match the old one, the second free will cause a memory corruption.
+	 * Resolving https://bugzilla.kernel.org/show_bug.cgi?id=212177 would
+	 * help to deal with this. With Generic KASAN, it's effectively
+	 * impossible for the memory to get reallocated due to the quarantine.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-- 
2.43.0


