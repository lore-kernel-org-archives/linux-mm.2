Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8542FC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4516B08B8; Sun, 16 Aug 2026 18:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598856B08B9; Sun, 16 Aug 2026 18:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0A66B08BB; Sun, 16 Aug 2026 18:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01AF56B08B9
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:48:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F259140630
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:48:01 +0000 (UTC)
X-FDA: 85108621962.12.0ACB07E
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf07.hostedemail.com (Postfix) with ESMTP id 98AC140003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R xwFjfk";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=CUyI9ies;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGSfdznQJ8iv193S46pZAZAzBKSWT9DlgvTIxMoYJH0=;
	b=Fd+Ll7xCRyW2+gAVmOWSoMtl2HmHbfTUyvuGI6xfsjqCs6985TG8bBqBEB8xDlJOPkS3YH
	dBGDvhr9YpT2cLsN9J6vwQtw6M3Jl0IPrK4I2KUM656nwwagJE1frupwXoK3t2J9hsTadI
	oeWjyV/J0dnFquCeXy8DD8TkhQH4bPY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920479;
	b=dyI+wZGCEZ1F/SLpOHF6DKXdLvUzOd4IWLcOhC5GI+MJmNlkx2tN2P1QgnoGCATts/Qski
	M3T4YWP6oJtim7tVclhUxsXsA3aPwBskIcc6kS7+7qHWJk4YAFawD1ouxoVT2tLDsvZRp3
	7jOQbXCG/JWhUhEdGl7laXT089Gnj4g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R xwFjfk";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=CUyI9ies;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3095014000EB;
	Sun, 16 Aug 2026 18:47:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920479; x=
	1787006879; bh=VGSfdznQJ8iv193S46pZAZAzBKSWT9DlgvTIxMoYJH0=; b=R
	xwFjfkgyL4cFAowgG/eRTs7SRD2Hk/lfU+igVpiLcbevYOnK6QpUDMSD6n5iu6ZM
	zuA72uBY8qQt/aXDlQ5itWOvuicsiloRedf0VOGIk3mJfxalsDJ5N8gxwM/ydKuf
	GJPr3I5IaQojSIhxRjuFn/gDLC7N2Uj+YOzi4andpPBZkkyOHPN+JjXkMht7voog
	Xtmqwbd0D1tE6wgjTL+814XNv8cbtKxMgYB5ldwonHdOm7fhBTjpHYg+dUGtjWVN
	Dpgmhp28+G0lQ77eWwELqxLVOTBMpQAjlBJN7Vumg6XzcLNq199lQHyyHgBf0coh
	MSwwf3GWO64nJwVo3gqTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920479; x=1787006879; bh=V
	GSfdznQJ8iv193S46pZAZAzBKSWT9DlgvTIxMoYJH0=; b=CUyI9iesxRmQIJgIH
	ZchdKM3r/qX6ZQsnBbNAiee8xozAyBRfIHAyuaTwQADy1uOTpELJY0d0rJMGghuX
	Vg51RrWYlOewtag1HzkpI3hh962E6G7J7MecOytWOTZ9xsjrNtn6/C6De10EqmPB
	nXxEBZbWim70I4NSgDzqOk6TpCQhbY+sNOBzThSPqwQMmZwKXlIf1kr1ytHQ1nRy
	dJwRzDh/Ac+R0Nlw3jSdrkL/Tcc/JtMQtFFa6oAF6I83AgRXGyggSzzpIyak3MFY
	rw85QW7kfxP9MViQVHIJ5loVxX8lWLFItJo5F7LI0YNFHQMfjoFRB6IKD+cyka8S
	Iu8lQ==
X-ME-Sender: <xms:Hz6CasFo-9P7dVRvaQvgTto6GI1llvl1ED6GQ3i9GAM3uTYdq2cHiQ>
    <xme:Hz6Caqo1iNwUp-MN_DKAN1RpHWm2fD6Yq1aurTTuBp0f91ZY3JbseyTTq4yw9HKXC
    h23u4x3NTk2s5FmhTQ-x0NOBZdCiEy2Wemi8hE7x5jG4zyVF6cbCrc>
X-ME-Received: <xmr:Hz6CaiONu4crVo_zSH_pH23CMlclG_l-VGDYRCqbuuRa6FSttVL6JqWq78Q>
X-ME-Proxy-Cause: dmFkZTFmVpV/hJjZHr0In5rst86Yjj8UzaETlwDLpAB00i6iblejFCjXgd4Yu6W0V/gth1
    QQk5g5peqevhLXv5oAa6A4wgFqksr02imAlY52J4/X33aBN3Akp7RIr6ZCjxvFrfIU4xSQ
    9AheWiTkiHfncTH5fU2zdbKh7twfazXu6MLOYizqj9hOx9PWjvQu87w255iL0QOT3f2Y/i
    HNIQn9sEDNwBaHw57xp44AudhIMQHXhs3AVBoLAek/6nuxTCRhfFb4YEz1RsUSKGdN99wZ
    k2GQ9I2a7t9qkq8S1OweCHxSw7aYXSWFm/gAj0eB9X5rOMd4bXVGhGMj8yPothnhUJpprg
    zkISQdrFK3cnz1l1Kx1HDHsdctZnnvA7Eni2VQr/C/DD3oP+T4LhVxqhuDiLc9MniGzZA5
    2ZAzxrFzhLFV4yStAzNOLiigtaOra4QSZduguqacbRIjtObYgtDf9UQKf+XKXOblOYjTIB
    su8VPGWXVs5MMz/wTe4Agk4jqScxC/DUeqhsEmIhr25STr6PTaupy6pZdh9Rvf8PdX5Pe+
    HQT6QCpQ8lQRKf5ktiR2ZePBoSzbiWb+LUWCLc9KU3LXrUaSQ+BlRQJhjxqDGBC4Og9JNj
    iTLwf+gO+G6lrH03ovxQ7tQImYZ2cdLwvb56qO61EPdPO8ovPG4mjErqmGkQ
X-ME-Proxy: <xmx:Hz6CaqpseZ-UYLbdetEbB6SAabMVr6no6-8PgDr_m6HCaNVvU5vYZQ>
    <xmx:Hz6CaolBbZZw052DtY7rhUl0lAmtgQNNyzrypr-Gq0o-fG_Oz2zWzw>
    <xmx:Hz6Caqwbs30KQcaUV5fFGyUHuCRL9vDeud20nHY99OxTDY4Y1EPmUQ>
    <xmx:Hz6Cau2kd3e5zW6m4nD5qpeDX-qSQx6VPGlKl-p0_GDDaD7j3WBElg>
    <xmx:Hz6CakYP3uRh1nTLzeeichKwS48BOFyL3fCRb2nK8IZJo2vaYjjCGKAk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:58 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 55/57] selftests/mm: cover collapse beside a pinned page
Date: Sun, 16 Aug 2026 23:46:07 +0100
Message-ID: <20260816224609.308019-56-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kuemnoeugexe6mq6z6pq1j4eabhpya8a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 98AC140003
X-HE-Tag: 1786920479-728794
X-HE-Meta: U2FsdGVkX1+8gAufmEJrI7RpsY6AjWbbbp6bP8AXPczyHZflrm8kDpvubIyg0+p4yaQQv/ML5OZXwRK4Z4rhdLe8eByt9f64lfLCybBkSWvDlMa1zkZKmHQCmVJonfo87ULcGajSNU8W7bTBbK6DgbAXqLLzKNhi8wXnK+ysXruxH2GzBkcBS+D745UAhOt9visfkj8Q0SX7vVqza8sTeNs42o5mPRWkSLkFLHuTX8Y0Wt8miogM4BGAbji/XUmjURE18fWSA78YYZjQxzLA4qzRaBRw7IYKbLES4EEQ7r+RVzw0XKtQ4oTKj8s4weO5iMF+/7EQYaX/ALP24MtQtho0xDc59NFlLm8C8gPHY/tVcAZKXR8yNQuZudpI1htbw2iD/BUIG1kAa+h5IYXKRquDMibRDX4UhB0cd3hyDCPwlNJh+bV1sd1U7GEzw9CXEzIpTsW/o5r/+33QZvwoWPgRPEq2R5ZoAjKIf+zJWKeX/St9cUYkOW/3s88W7NNAapL4BbxAaETf7C9m425OUq6wSiTptfpa4DFZwNbxY9c8XSxUp942EQ9P6V4rb0wyuPVmT7dfcyTHgDds4Os4H5LQymlrVWeWAHgS2AyS+dsxeoyHwSuC1jUMKmLwpsKPaBZDcvs1iy7Xkz6jClEF9+dzwVnO4jU4IDrW3hPqkVp/9PAqzKoZuMLuUSMN1cAassW0Ry5pfvXOovhUK1a8HfyOLIMvJ1PZMrCTLFAF9HFIqiDVgyAlRM0qlYM+QZSR/a67shZbhhHlg/NYNMQtqsJarCCa4Ov1D9F0fd85TiEY+6Vk1w9xZVMhjGoxI8+E2wdpp0QqutR7VwDEyzALUYdL4o9magS0dXBV3wS7fq6A0bJp5inpaESSA6W2fPC9Pnx5isj1/wwReJL0sCHhFAADuYocuDog0eiat2JLNqfzAhlneZKz2gk67V90coj55KfYeHniIdlrnieKUsY
 ivVFBqZ6
 PSgDQ4/DpvA6QfJ9TGCwiFXqCfULNZtb9k9Rp/9LKJnXOreLWY7dZas98YhcOS/U2kQG9mLakKUSllVC3CdJR80dmxzOshDsz/D4ZqYFD5E0Eguc6B4BlDL8tfc0jOXJ3sgtUQYQFp+NSVXfHo0B5oErfRWFESKVO1YHKEd3MTrx9PPQ5JcnM0pMDaT4dZyyDJLVB6dXo19Aj0Z3fVuQpHu5Xdj7Pl6WGVS2aXsr3YR/nYvZ5kHx9TECL+rkGdATNu1bjtcFBw0U5X++h9GYioRYu77wDZyoeDTzcTAPMWIlKBaLogG+hitPx/n+vLnOnVBSHnBc6QWJdnVHqIIelfdh43MkoxFUFOVSvuvgD33aybr274fKqrLFv+lR3BFrSZQZbaKidmFqtqTBQQDjv9DvhB+D7qgvyudnmXFocrPK0c2Gl4fgV9KZDbrXTyXADSmDCpz28m43193s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A GUP pin holds a reference nobody else can account for, so a pinned page
cannot be collapsed.  The freeze needs the folio's reference count to
match what its mappings and cache membership explain, and a pin makes it
not.

The window holding one has to be refused.  The windows beside it should
not be, as with a lazyfree page.

Pin one page for the duration of a khugepaged pass through gup_test, which
makes the refusal deterministic instead of a race.  Check the same three
things the lazyfree case does: the rest of the table collapsed, that
window not, and the pinned page still backed by an order-0 folio, since
selection descends orders on a refusal.

Skipped without CONFIG_GUP_TEST or the privilege to use it.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 64 +++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 58cb7364652e..bd684cd25fed 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -21,7 +21,9 @@
 
 #include "linux/magic.h"
 
+#include <sys/ioctl.h>
 #include "vm_util.h"
+#include "../../../../mm/gup_test.h"
 #include "hugepage_settings.h"
 
 #define BASE_ADDR ((void *)(1UL << 30))
@@ -1728,6 +1730,67 @@ static void collapse_order_lazyfree_window(struct collapse_context *c,
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * A GUP pin on one page holds a reference the collapse cannot account for, so
+ * khugepaged must leave the window holding it alone -- and collapse the rest.
+ * The pin is held across the whole khugepaged pass, which is what makes the
+ * refusal deterministic rather than a race.
+ */
+static void collapse_order_pinned_window(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	struct pin_longterm_test pin = {};
+	size_t window = mthp_window_size();
+	void *p;
+	int fd;
+
+	fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	if (fd < 0) {
+		ksft_test_result_skip("%s: gup_test needs CONFIG_GUP_TEST and root\n",
+				      __func__);
+		return;
+	}
+
+	mthp_push_target_order();
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, hpage_pmd_size);
+	if (!window_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	pin.addr = (__u64)(unsigned long)p;
+	pin.size = page_size;
+	pin.flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE;
+	if (ioctl(fd, PIN_LONGTERM_TEST_START, &pin)) {
+		ops->cleanup_area(p, hpage_pmd_size);
+		close(fd);
+		thp_pop_settings();
+		ksft_test_result_skip("%s: cannot pin\n", __func__);
+		return;
+	}
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse the windows beside a pinned page...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (window_collapsed(p + window, hpage_pmd_size - window) &&
+		 window_not_collapsed(p, window) &&
+		 /* Left alone at every order, not just the target one */
+		 is_range_backed_by_folio_orders(p, page_size, 0,
+						 pagemap_fd, kpageflags_fd))
+		success("OK");
+	else
+		fail("Fail");
+
+	ioctl(fd, PIN_LONGTERM_TEST_STOP);
+	close(fd);
+
+	validate_memory(p, 0, hpage_pmd_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
@@ -2020,6 +2083,7 @@ int main(int argc, char **argv)
 		TEST(collapse_order_sub_pmd_holes, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_mlocked, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_lazyfree_window, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_pinned_window, mthp_khugepaged_context, anon_ops);
 	}
 
 	TEST(collapse_full, madvise_context, anon_ops);
-- 
2.54.0


