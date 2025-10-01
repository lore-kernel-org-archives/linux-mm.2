Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86310CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6145E8E0005; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4778E0003; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501988E0005; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0E48E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E32FA14021E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:53 +0000 (UTC)
X-FDA: 83950527906.16.F0D29C2
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 047C018000F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BnUD/EYo";
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
	b=FLxNbus90feWPhNI/fEhRikCS3pMqxxJxRxvNZeL3eF2UbVbOMAvQI37s1OqNfhjD9DY6h
	cfX5XHGCW3RNkC2gAudwgbyoMw+gNxfsndAIXLPmu1RjH8iGzqj4tnb7iSbnHTPeFCWaUb
	aZ6AzSr4xPMPQvvmDBxjumj0XLwDxjo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BnUD/EYo";
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346812; a=rsa-sha256;
	cv=none;
	b=zcRfWog7FpC1kp0pP9HN9fw86N0cE/hTCWVGi4+TIwOp2yeZzvIAEwAPFiZxYJzwD4iXCq
	/4qlVnEy9m5pbuhwaugmdBwpF4vypHQssCgOcNaOn7TBPeLZhq4mw7OQl5ydxLO0z0ar0E
	yjZki3daYuBjUu/eqIUzCskKrr+7MXQ=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-57f1b88354eso198271e87.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346810; x=1759951610; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
        b=BnUD/EYory4BYfd2Jo1Q4YKrVPD9SOZ7RQsKy1cx1LWNfetakkDgAnhAPZV4iS9ZmZ
         ehycQGUtZWiGS9oq27HBEIk/tuBlu4X/3jB4132vbmw+CVbUuUx/Ib7XawpEqLXrYtT4
         NzkZr70tDfdg5i7eoEDXrgglPVmyDCmUfDHybmcYZ+diRL6xPqG2fS+yr+NI13v4KihX
         iwbANOYQlSMyyLRew72+JO0bWi4Zau2gMcDBeWxfYRPQrfOYvuUYIoyW8Et4oYKGJi7y
         EySnCiGWzelkaE/RQk7G0qSYVmDC7eIsekoUR+JUYexIjUrazf0WoWHS+4yEeEfbt7E2
         IRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346810; x=1759951610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
        b=LbmkWZWliIY5IO6u2gjQfdrEs4bk+z+1hgeVW1B03k5GMFoAQZLXuq4STktsZI3WcE
         NWOlWzN+OxS+/69bfS73Gc4sO9Z5ujgU6dAuf6F3PyfB14IlEiMOwme0rqRk7k+hbz12
         0DAvtxWOVNpos76tzBVXxDwZhMPkLDpmYlWROpoorNy2ndqirIX7Rj/e6j02RWIGMc60
         WswNu60cLdus3kvdE3ecpr9XMMBOHqUvdfh98EgVBA0LZMb5ZDwDfFH9emhe13KxtAGh
         j+hj7Fs5O9tnfVb8j4jLfU3n5uHguTHzhWefxWHtUw/ieO6jwLVcnne4thR8lR/mnp7q
         vkHQ==
X-Gm-Message-State: AOJu0YxcPp6PNpElmjWO7Th8orIJYc6IEoYhZdcuqWTKfePaTZi3Pup1
	WKec+Ecrb7EYfq67OqW1tFHEVhSKaVp35EKsM9Zi8obsKgQNgCVKvZMqCEHLzaclabo=
X-Gm-Gg: ASbGnct5vk+Zroazo/ez0wotZ3L7tts0Xb6Zqnl74A3aYPkZRH5G82Ej3dmj1ClMyIp
	DvzH49cDNGjmIlb2IPNliCk4hp84huZhNCBdWyank4stFGGxcQHDzDN99gf2Bw/yXXoCwMsmiz/
	mWnPvVF6Em2p8zseKwFlfOg1vDv4OMHQWFeaUqSd4OgK8JpG1/pk3gGGXSp2kPmYouQBtU4vQFo
	PMn+w24vqXxpVkIoULupgV7uWtzB8bstlnRrratcW1CeLDQKvzV8IpVwjtuCTMFLFNTpWaWwzmo
	DBVYd3umoo2o1JpenWZM8EHdMnhIImyOXwg53GqVK2HJiGCcqm2ptAm3+r3IwIzAGnZhLUOibly
	b768vHonEaeLo1OuSGrWnG38tlJ9IlHqPkkRxwVOn
X-Google-Smtp-Source: AGHT+IEfEWBm8M6AzhkYd4fot4+nTsgt3Zq6rjXCLPpDwAaNb3Xiqdqgs47Zz3Hyyexv8rR1mHCSLw==
X-Received: by 2002:a05:6512:10c4:b0:577:285f:32bd with SMTP id 2adb3069b0e04-58af9f6739cmr1140787e87.26.1759346810036;
        Wed, 01 Oct 2025 12:26:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:49 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v3 01/10] lib/test_vmalloc: add no_block_alloc_test case
Date: Wed,  1 Oct 2025 21:26:37 +0200
Message-ID: <20251001192647.195204-2-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 047C018000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pt7cgu1gwdngmo595515as1fi5cmiqx8
X-HE-Tag: 1759346811-484305
X-HE-Meta: U2FsdGVkX1/OkXeGFtklBN8/pDWP96EgfqvQINr9my7NWT96YWarfqVSvQ/t5RsGR12Y7rXOH5YHjMbrbqVfXBpR7MVNbaOECA5RN7C/RVl0IReydLeJcJhsS5qGWXkxD4/GdvwX+ToruzzA65Sx7hoFMisy707RYhq/ZxSDO/aYPRJNf0mhU78Rum887ibIz0K4NhR6FwkGrDGFDo/q3cwQrAkFjG3tqNy6Wj787D4T9JH+3uaZ+j+Jz9XsrOp8FtT/WZ++mM9KW4I1wdBl0N5B3SMssifXEP1VYqvHPA2iOe7EJBexH6oFQ1+XEbgLfkAaiyk7PzIcukX5xImul+zRlIGIyHCg7aHJ7jwgjg5VQ1J49ejpUlSr5L3BE4MjFKN5+igN9YVePAVOC/GfOrUYlMsxTpZJ2WF1z18U9p/0LqjBLn5iZ0Jaj/MOIA8sqeDrPLvZHUa9RHGfwyK+D9/AY3f/shXbhq1qvr5hBpxx4cLRNGjF1O/bY8Ql9/B7mjO/8nDGEmkDqXC0Lz/KAup73Hrsl3FqjL6XY5ga0HrJjBt7Nl76IvO7x+5T+l1Hq8ieBlkOMrmG3ab93F63LEZE03g1W3yqNITHwQyt5gnZ+vG4eDAEdbr0gE6xavLjixaYRjvM5reVD88kAepXmOprpgENsChkY7LWRk++ePKb4EutCeq70bz9xaYqsLtcsM/2qZ0TKrumzx+dpSmsLbSpdM/G0VbVIg1hjU+9ta4B9xfchCcp+aebUEprNpwk+Zks3I1ilqjOgRenm5SrIStykXE6/pQJsc/jLj1TCOiWgmo536jyPVO8vyFGEO03kPhIcNxaegQeazI624ktSJgy469wxEhTtulEalAoJDmSVIDWT00TOj8N0Is2sz3U/DgOoYJ8MhwRhgmeGBHNmRdglMVSThJXlBmw1lSLJgGpPDj0PiCVIe+u9Px6we4gfBaXVV0/U8/2tMMcCVj
 v8u/xnOP
 ZHkwq689Gg2s2i/STWuY5eYTvVp9L2Q66iea0I63oNyk34nGq5nZ8TSD3xS9lrGLW543wcPpdtA4T9vpUa2k5PW2x/5KEiPaNf1IKy/yyjCXK77qscO9Qi2rdSoarnYG7bE/wzl/AmlO+DX5F/gtR9YO6/Omrny+CDabjwfWcw+NHGgx8mgy/09mS+hBMi6EzodK/8cKst5LD6iB1qiCLXGbJaDUE6XphE7xEoSBPcvF8SGZyNBovWz1hUcQSbC9uFtWyictKJP/oG2BeMwX+YaNfHGMbt/QDW8KJJIfLdhCUI2sGzsBUmFLx5tJvX8dlnFhmbc9yYaJ4/QyrzKlsj8flSpopZmnWHCAP565ToCMWs+Bky5vf29TGqmUTIt6gDzjen11JQt15SnnS9uM8wUZJcxEGomRNcNAXVOp4FrCdFfU6BCbwji5YTKiDPHOPWYtR+qbwXoJmfDlKwVVxNrik6WsmlTnPW4sN/xv9x2+kkvt84z0zMtZT8g==
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


