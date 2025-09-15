Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B902ECAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8C88E000B; Mon, 15 Sep 2025 09:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0418E0001; Mon, 15 Sep 2025 09:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC388E000B; Mon, 15 Sep 2025 09:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8548E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E235F160175
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:47 +0000 (UTC)
X-FDA: 83891594934.08.10B30A7
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 060341C0006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HQFfW+mU;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
	b=ygL//MEQvYo+amLKDb/Tzs64777YLnQYKfskulPrDAX9l4E+iaHhy+jfzWE8sbGls5DPCx
	7buAl8VuYXxmGm4tN86hYTn29ieZ4BXvCnMvDn8k0F0hSeGQ/91LU4gyh/O+CkehjrY6dZ
	Of2DpVUVnhIZk8rIZyrDWeCuCaILNJA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HQFfW+mU;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943646; a=rsa-sha256;
	cv=none;
	b=4jznjhHmKydKMC3nrczH49y/D24QShNYLeZ0UeQTo6vr18xzPRdz+2C6/uB0SO74F0n39n
	45W5z4YpoLkd3epxdqqmdCh9p93B82o08LaijBlG30vYRBd2wT9n69iK/SKB86gZ3cf0as
	IbT3KB7e/QV9qOZ1WzJtI+JI9jvpzKE=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55f76454f69so4484270e87.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943644; x=1758548444; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
        b=HQFfW+mUevP7i8Y2QnHGgizBCR2QLzqQU0/hC5cMewcaxRM16nWxiRHVoYsZTddZbK
         hlkcru3jGKfat/GO7uv7LrNy/oCGL6Qx9uS8XNx3xfnajiN6uIfobqIVyhmzuOyjdiIJ
         vaEvHql99k/O3TDel7PwcO1luus7NnDnz6bQ7x+Y2VIkMOuNcfv8KNYmJjDk6l2nMnvH
         xQnyDiVX77kcdaHoZtgNBNuy1wMVoMHw7gZQit9gaseGpb7GrPzrxb5DRXfKaBfWy74O
         vNAQgbZtuoHd4oLHmBXfAa+SGDo/Ss3EK3TPPtUD75nOOZ1dIsTwYhd/ajTRXtWcUR10
         Zkcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943644; x=1758548444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
        b=qQFGElyy4S/J1G3s48twDdPwOm4lpcI8qRZd44Oz7CV4iEqwD3HVfh6MKW88SGc+8v
         TrSwUWtjnY7jlMPKmFtqETaj2f+qqln0vcBM9eBFlDjNNfDCNVUg5rgF663DjJe980qg
         7yx9yHmHN1+cjguQmPzZxw4UQ9VZFFbqy6cPB012YEGKhI4kwfawPLuhvFIHdHPCVdTA
         kINU+w0X9wAM3QrUUY/wMso//H41MKap8YeElzhwACtBQLVa3K6/3BqVJMH/YgsnjPEw
         iqHRLOWh1yOIJmSnZ4BSvx0ahdyp+Tg6QyVBwzmKxaZDBSadFv8vau4n4KIh9hSN3dw/
         ksxg==
X-Gm-Message-State: AOJu0YwcNsw3RujPKriCsfOcTH2VF+SAyC9CkN11V4hzOyX4cdX+YtNN
	kH6+5gNJ1ZbC2ShizNlcrVGKSWkclXAtTGB+jJr1eBWp+B3wQnQkJt4NsOujag==
X-Gm-Gg: ASbGncttmkeRxagProZfndQMvkJPIf42CI0XCyCJ9Ru6wd3RVGuNLGsnsB9KVvDci3h
	yEFEE61MWzsZFLbCk4Np/OfSXwHhZO2hLgvqK3wfxl6IaG9TFXgBULZMuPHrUr9uc1YgLePKZ1t
	497IS5ddhshO/HQF/9fxFPpzFIFDIXn2jXB0t8SngtcNb3BS0ZcotdYIV0w8nEXUSlzWkNcY1xk
	hgSAnvk1j12MoyB1I6iDBAomNOa6zyhLWKJaT1Tp/Z0Ne8pdCJawG870KB0U8+bI3lBZvlKvkPS
	9wmbbkldYSfP5tg8Pewp9D2I9ZAIkLI7mIKHtc0nFYXcG1N/GWjqysjoPKOTIO/ss94rr4Z0dlS
	zewRA6/Ejy+OvszUcAP9h3D7+0hg=
X-Google-Smtp-Source: AGHT+IGfCO5sUXBXkDHpAZfvRpmtA0Ce5XIe1FVG3pHRKDt98SzjVQvDcxRHyiA9Rb3v/QW8ww6Hyw==
X-Received: by 2002:a19:6b11:0:b0:560:8b56:5dc4 with SMTP id 2adb3069b0e04-5704aaa0468mr2666530e87.8.1757943644004;
        Mon, 15 Sep 2025 06:40:44 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:43 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v2 01/10] lib/test_vmalloc: add no_block_alloc_test case
Date: Mon, 15 Sep 2025 15:40:31 +0200
Message-ID: <20250915134041.151462-2-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 060341C0006
X-Stat-Signature: u6xxco38sdrfj4n6y6oxjk1izy6oh7z5
X-HE-Tag: 1757943645-768215
X-HE-Meta: U2FsdGVkX185epAmoCatVP2R4TV3XnBZ4GqwfTTDxYFvEJx99dsWFR8elvu0VrM/hXuVAHciISOgUbApWjUx9qs6r5o3TgUgdGEM1oHTMcKSdCJu69T3pLQS1vkpuVYTHeV1F+3u6CL2J4IC+zJFwn2ZAIOb0w17X2q45LvE6NqbY8MkZA3Cxj5z8w/RAHt/WCQzNAWvo3mwVY+/MeFMNGuDFXO/gFxvVajy4GpGCj5JUXD9d7Q8d1TgJrgvYqpgNiHh3TTbiEeBdd80oIyRV/d2qFtmpQS4CLcXmKQZl7fcYlLmZX2fAidn4yWiCwMZo4exN7l9R/jQTt3P+6/0g7L+aq9Hd6LFIfglVuEKqk1LFtm/wSiU1sFlRkm8+XrR6grSYw5SyeOUfEXJCw8WqgMUUOkfsnyKzxeAuY03udEK2kxJthG1ce34BY2/dYRyXP+jMnXRpalO4kN2MUm266rmEwaIhcnle/qV4hir558ZYtvZwqXRTAugK193xahLuRX2KVSMqWxK+AxhOPYvmKH4VLuqjWUw8PNL8dkIOOOCUL48AOl72hZ4L9Vkw5XgrK3HMH9fKJ6P9FSgfvPuKJ1bz5LNAzh//Duars3aREHcfxn/VkSrPFz9214fypxj0O+oC/dM7FCJeIQS2cJpXRFV1aMq1jwdguNqzpUJ7FFovD3IBa4s29KnzVmO76sxMk8dKyA+yYyV40GMIX/y0Ws+uoT6NrbqXGi9T/kTFvWypBAcAkLUKEMLU+SzjlrgN3+KJ2SrZlXG4XSrmk1OnhFZmfxCUGGdUXNMTTM197aIlWeHwPC7cGjnNQfJP64QP0qSZGjOpqMPYXvlneh87lnBaKkvMHM7ONwd++0T2SeubboAlHeuChPsCD7PBANsM7Ge+CI3lBkT57hDEhB38upFx6GhK6svtYXQ4i0lR6Gs9Q7OxKPbyKtLnrZD2XL86dxVkVUptjPOrMRVW1x
 y/1TcDe7
 +bRmdboYskVbdHeN8IBylXK5f8VEVIBZEgD6zWGuRT8+n9DRHlXX0vLlZpUa9VLsHutT3zoLy9IH0W1k693VFX8q+xqdSmftm5dQiRvU9N8PrGBbPlz0scq/SpxJgbTt0j+79czFEsn1j8+NT6qsF61hxopYozX0OLnjzA4sxOXoLRjkBpcmAzo3dFBEncwLu83CD2xyYhtzumFL1GcbGIpi9EZ7qrK8GK8b4tMDXhiBKJSs2dEa0kFC6LoCjZ2Zgons2Fjauj+YzTSGImtSHfU77cQqKaSJPWY+BzlK/H2mmX7mpp0BOaYxhaMePnwajKLFUQjnGk6c1Hn9YeQRKjQKnI4G+4Gs3usxsx2+y4IcK3Gt0WSzULVwFPQmAWX7DMiCwrzlPB8k6a+XSFwyh9SSGluugQlu6yQqcVQYlyim4G91xQijwsz7b+eGcBEgJVrssXV1/6/AC5gzxNzjQMdeUGvz7ZBHPUeb0CYLRJrr970tPeo82yUQElQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new test case "no_block_alloc_test" that verifies
non-blocking allocations using __vmalloc() with GFP_ATOMIC and
GFP_NOWAIT flags.

It is recommended to build kernel with CONFIG_DEBUG_ATOMIC_SLEEP
enabled to help catch "sleeping while atomic" issues. This test
ensures that memory allocation logic under atomic constraints
does not inadvertently sleep.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 lib/test_vmalloc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 2815658ccc37..aae5f4910aff 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -54,6 +54,7 @@ __param(int, run_test_mask, 7,
 		"\t\tid: 256,  name: kvfree_rcu_1_arg_vmalloc_test\n"
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
 		"\t\tid: 1024, name: vm_map_ram_test\n"
+		"\t\tid: 2048, name: no_block_alloc_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -283,6 +284,30 @@ static int fix_size_alloc_test(void)
 	return 0;
 }
 
+static int no_block_alloc_test(void)
+{
+	void *ptr;
+	int i;
+
+	for (i = 0; i < test_loop_count; i++) {
+		bool use_atomic = !!(get_random_u8() % 2);
+		gfp_t gfp = use_atomic ? GFP_ATOMIC : GFP_NOWAIT;
+		unsigned long size = (nr_pages > 0 ? nr_pages : 1) * PAGE_SIZE;
+
+		preempt_disable();
+		ptr = __vmalloc(size, gfp);
+		preempt_enable();
+
+		if (!ptr)
+			return -1;
+
+		*((__u8 *)ptr) = 0;
+		vfree(ptr);
+	}
+
+	return 0;
+}
+
 static int
 pcpu_alloc_test(void)
 {
@@ -411,6 +436,7 @@ static struct test_case_desc test_case_array[] = {
 	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test, },
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
 	{ "vm_map_ram_test", vm_map_ram_test, },
+	{ "no_block_alloc_test", no_block_alloc_test, true },
 	/* Add a new test case here. */
 };
 
-- 
2.47.3


