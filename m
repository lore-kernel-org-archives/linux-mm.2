Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976D2C982CD
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF6C6B008C; Thu, 17 Sep 2026 02:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8CF6B0092; Thu, 17 Sep 2026 02:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390666B0093; Thu, 17 Sep 2026 02:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 168AF6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:56:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EEA91C1D91
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:56:14 +0000 (UTC)
X-FDA: 85222345068.28.5A03E6C
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBDC920006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:56:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=PqGbtwEU;
	spf=pass (imf13.hostedemail.com: domain of zhenghui.hao@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789628173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1Fc/4Xsm/exGsgjT4jGufeye/rOfxrIgfcyhzDzAv8=;
	b=zGGjKc2P3drhnGYpSSxpLhc1ExX7uSPyPRw88DliQdYM+syRmuUAaayHz4KpXCNrTaVmCQ
	/Qptxy5VBPqJr6CagFKebtq0Z5eFpuyKGhJsSR1/IbEbZtABeKuTHGsA4DeewYnzUJJbd0
	b6zvJmPEsC8r/Db+jKRQ9ghqGmJndv4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=PqGbtwEU;
	spf=pass (imf13.hostedemail.com: domain of zhenghui.hao@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789628173;
	b=DLr+2MeGmdfu1/pwkkOFczB2qQ3tA3dcMHj3ICTrN7lEiiUcOTs+3nc3ny/3rAHrWRD5/R
	M84fiCcIhcBa29+Pqs4tD5YKFYeircI2Ut0hfsHjyTB9gbDeUDhZdFLExmDsYUvMT6G6Ls
	llfnbWBAOp0DiUDr8FWaOR0+7nS5HVk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789628168; bh=j1Fc/4Xsm/exGsgjT4jGufeye/rOfxrIgfcyhzDzAv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqGbtwEUZZ1TIzE2q2KtgcGmeDRG7GF1XifWTaxo8RyPwWmc+DnDpFiV6gDL9cMTx
	 UYW0uBNIeahEDiuhlxqerECXl16CnLdnklbh/HdhlsroSq0FMxw+WT1sY3OOEpFwVO
	 pJE8kaTfaXHvwILlruPS7+s1hiC5Rr/QM/rnU7Hg=
Received: from XJSH01426.meizu.com ([210.13.72.171])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id E0103260; Thu, 17 Sep 2026 14:56:01 +0800
X-QQ-mid: xmsmtpt1789628165tsbw3z5sx
Message-ID: <tencent_7359E1D8A4256237AB06F816324B30F3A608@qq.com>
X-QQ-XMAILINFO: M+CCxu5Z1xuSmDX1Vf8Y3UUXjh2hdOApX30dVrTbenI56A0V2HKRBcztpEorbn
	 KdHXoWD/z15JTjp5JIHGshfa0dMRK7XW7NjfacimCl4tUqdlPIpNKElcKl2UK6wfI15JyZyf0z9b
	 IwqfunUwyQQ+FWUdJKo68WGVNS6t46KQtA6DlXBhMOMJBycEMb3Q6K/isHD52BQ+ivUkrlp4Rccr
	 7TzS1EKh6cbBdqa0Lae/Ks6pMXhOFKLfiQ6dxXWUq4sbqa5a4osdj+J7kTVUxTHdzLcO0Jhh5aOX
	 +bX1jX5PTiHC5Qkob+j+5G1t+p0yi0sGkJMEE47v+uAVyw2WhQVekrvUbXNfSSvDm8n8gupM4fpw
	 0bMI5GrRwRjXboBvbBXxzo/VIzJFbdsswsuzNdyjgM7Didz5gkxjXQoRwwS0fsXKesMefN46HwEL
	 L3L8T7SgAyyO28PSg/Y5CrC+elV4BSL/SI7ibbzdgf5w3fcA0NtcmxV6FeBwHS8lmdZ3FvP9AguO
	 pYloSwZ/pLE/piKcio2VvM0Ha3CdCYV9N+jaC3pHmGo5ozZJq8V4xZLopwtKpTSlHwKJVmxTFi21
	 JZJleZnl7GB44WWJ/pYUK/AVgoqVMn6LKaJn7zFw5MDAO7sEflggbReT2NlR4431QPsepAfnU4aT
	 Izx7A20BsOz6BNvhQRqtKSLsQ5T4OtLevnC1DuksIuTbMeKW49xlM8v7usk47y/57gF7M+Q3upL3
	 x3LABGuUuFN6M0mbfK7qIbDmsVnzc+xyYirZQoZinIvXRgvZRPbay/fSz9ksSvdNbUWsogSZJuLL
	 eWP5q2l6kH5uI/GAW+Yd6d19YbGPebW3zRdWec9fej+ZdZ8GC7K30KIPcotkyqH02Emi2SNTUrgD
	 wUnWQ+E1IC05z3sINOpQuQuRbbxIFmYqDFXaWZD2BqFo8nHQkyxB4yvmn9xaDB4BXuzdjeZ7q8yl
	 w/SYkkvgFhiK9p7HT8BJrxZx2LHP+6dhHMs26MZPHQok9rMMzDzr47LJcEZqSugEYJsHwM5usRI3
	 oHBLAZpCUGSVMx9aIHzUETM8/BWnyIZU0EZJN38G9FFF+jSkewInoaiUWmTYhg8LDS5nFbfgFkxw
	 j2kTw5xMXQ8MJHKNqHGgafIRSOBzs5QrNDQivtt12fw8sObpkJdqonr+FqKMSQAI51rkOJC2KWjt
	 oFnoA=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Zhenghui Hao <zhenghui.hao@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH 2/2] hugetlb: report cmdline parameters recorded too late
Date: Thu, 17 Sep 2026 14:55:57 +0800
X-OQ-MSGID: <20260917065600.564083-3-zhenghui.hao@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917065600.564083-1-zhenghui.hao@qq.com>
References: <20260917062837.558251-1-zhenghui.hao@qq.com>
 <20260917065600.564083-1-zhenghui.hao@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fu33jjewdegqfz54jc9o1e59mwpqizxq
X-Rspamd-Queue-Id: EBDC920006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789628171-226996
X-HE-Meta: U2FsdGVkX1/t2Rl/sUgU9cZIyUVBecOuMuTSbQQHiDB1wS+TUM8zEgBctncs4h35AWCe87CXW7DvSz0FvtbCnYIpMMTWrU0PqqfjaEqqVrrTm/Ue5MMeg5GGZlpJCy7Tc37otM4iDSAeo2Qzq9YhcVV61A+7EzdEcxHU4NVuV2CLgrg9CwK9JvF1xqZMhd8md6ASjZYpXXwszR1nYvUZqnoiHblj6PSPx/8ADhgzq1zFRV6Ba3ErCP7lWRhBicWDWlXxCBoDq4m21PsI9rdLWXN62t+jCjoLFdWgKSJXlAIZw65N98NcsbCSep7t1JGZGBF89JgM7y6yjcE1OIU97x/e0Pa8rA98t27FXpWMgFbrMVBDBcIHpc1TJzkA32pfR6OClbj8dSlGEusc4zG2j8dZnjfqXudPU6c+qhNE2ipaeh0AmRDOXaIMdsZnnG2D/g/Nm5UPw/GeYcUkJUQA7DRr1nZgXhdpAqiqkM18HJbOa7bKB5T2N3YgvKF6MQfdehYNdJVI+t6R8GX5qre1pmzjLC/pzsTsZ6lthI6Z16m8mv4saafgcHG7zTSRfhg4dPPYNOHIdsOsoRo9mwA5q3tshBhn6G+v6iqWz/K+BpxhU78a2bLSfI1dzpsNYQlwi9ofeKxe6lW69GN+91kocHVsY1RmEqYu3/FpTdZ+8i4MtZY/vv+u8wlJuDxZ1yITx1l8w0W/2uX6p6cSJoQ61PLavekZr/cdQzj7WIHq5b9l19ClmGoNvAK+Zl1b52bFbpeb/cPAh/LmcgSDUp8rjh+Qoe0lj8iiO5Xit14TLGAT01oXWIVP+u+b3sOiZ2N42I18tkDHtNf0Wj7JT1A6UpFuTx/rR0Qh5Lepv6xM2tTtbmHbz3JWiMRXkuYw/HPEZsUD/UPlF8pWDe3hKqUWPyQHfFyQecDUOVJe9Va/uZxqt1KAMOxS71ccUOYgkVNqVYa9W2dFOvaWHK3HcHE
 gxBthmbt
 NffQS/L8FHuZnm2coHH9FHyNxq0b62+xeRoofpjORkgd9IbNoT2HQG4/cIBoNNhiqp4K6DWvkqd5PPp6wP4qczWf22cLQDQcnLiPtUumEoDWQ/QTT8nFh/ig1wWVAmGaxXj43lxHZ3MaavlufrdBTMHJoOHHwYp7l8Yef3QYeBlXB1Xc9Je8fx3uI4VV0vAdk10uOBXMNbnADMMZ0VDA7n0xidopaVS/YSZ8FOLJnUy6T/XLgefrDg/eIdFE4KVNTG17Rb6R3Qb0zJD9iJje4iXUbrOwu4DiWC35o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb command line parameters are recorded by the early_param()
handlers registered through hugetlb_early_param() and consumed later by
hugetlb_parse_params(), which is called from hugetlb_bootmem_alloc().

Since commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
zones and memory map") that consumer runs from mm_core_init_early(),
which is called before the generic parse_early_param() in start_kernel().

On architectures that do not call parse_early_param() from setup_arch(),
such as parisc, the parameters are recorded only after they have been
consumed, so they are dropped without any diagnostics: do_early_param()
stays quiet because the handlers return 0, and obsolete_checksetup()
treats early parameters as already handled.

Warn in that case instead of dropping the parameter silently.
Returning non-zero from the wrapper would also work, but it makes
do_early_param() print "Malformed early option", which points at the
command line instead of at the ordering problem, so print an accurate
message and return 0.

The check cannot produce false positives: the wrappers are reachable
only from do_early_param(), and hugetlb_parse_params() is called exactly
once, so once hugetlb_cmdline_consumed is set, any further recording is
by construction too late to be honored.

Not tested on parisc hardware.

Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
---
 mm/hugetlb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f6f58bf3db6..bda8af614a70 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -91,12 +91,24 @@ static char hstate_cmdline_buf[COMMAND_LINE_SIZE] __initdata;
 static int hstate_cmdline_index __initdata;
 static struct hugetlb_cmdline hugetlb_params[HUGE_MAX_CMDLINE_ARGS] __initdata;
 static int hugetlb_param_index __initdata;
+/*
+ * Set once hugetlb_bootmem_alloc() has consumed the recorded parameters.
+ * A parameter recorded after that point can never be honored, so report it
+ * instead of dropping it silently.  This happens if an architecture calls
+ * parse_early_param() only after mm_core_init_early().
+ */
+static bool hugetlb_cmdline_consumed __initdata;
 static __init int hugetlb_add_param(char *s, int (*setup)(char *val));
 static __init void hugetlb_parse_params(void);
 
 #define hugetlb_early_param(str, func) \
 static __init int func##args(char *s) \
 { \
+	if (hugetlb_cmdline_consumed) { \
+		pr_warn("HugeTLB: %s=%s recorded too late to be honored, ignoring\n", \
+			str, s ?: ""); \
+		return 0; \
+	} \
 	return hugetlb_add_param(s, func); \
 } \
 early_param(str, func##args)
@@ -4491,6 +4503,8 @@ void __init hugetlb_bootmem_alloc(void)
 		INIT_LIST_HEAD(&huge_boot_pages[i]);
 
 	hugetlb_parse_params();
+	/* Anything recorded from here on can no longer be honored. */
+	hugetlb_cmdline_consumed = true;
 
 	for_each_hstate(h) {
 		h->next_nid_to_alloc = first_online_node;
-- 
2.53.0


