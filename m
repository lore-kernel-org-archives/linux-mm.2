Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9645EC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB4A6B08B3; Sun, 16 Aug 2026 18:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944B76B08B9; Sun, 16 Aug 2026 18:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80B716B08B3; Sun, 16 Aug 2026 18:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4016B08B5
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:48:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2AFEA0627
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:59 +0000 (UTC)
X-FDA: 85108621878.24.0ED995A
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf22.hostedemail.com (Postfix) with ESMTP id E3F84C0009
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="0 KrLNBO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=fwlDkpgk;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920477;
	b=vmqFgY1BaNM9SbPGbaIQRQn1CK6rF9HyOAF96aOxBvP3na48U4nT0rnB9Qi5yGX14TKO5c
	NQVAdc/0ZGV/xUaakfRwhwm2ORmgQIIpnAksZHiElRCcCHLuHcDxGu5cFFmtMOfaaoqLdC
	OzDG1qMDEv1G48Yvz/RTDD32QRKElig=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="0 KrLNBO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=fwlDkpgk;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pI4lY+AJfKOOjXvPiR0jbn4HyML/QwSMTUaiVyOT0As=;
	b=kcCpI2VmlukG7tslMvFMsXdqts2jg0udZpQTCNMJHXCtoiDPYiaMhoH1t5sEfqGTWcHJKs
	mwMRpvB3eYiZ0ZSsDTP5d+Lf8G5fAWKlqwcJQjMwzn0W21QAd/UanbidgMsNfQWCd80rEg
	wvClYo2lnLLUqmiRNIOAX59XpZv78lk=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 692D5EC0074;
	Sun, 16 Aug 2026 18:47:57 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Sun, 16 Aug 2026 18:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920477; x=
	1787006877; bh=pI4lY+AJfKOOjXvPiR0jbn4HyML/QwSMTUaiVyOT0As=; b=0
	KrLNBOpYOPbnXg5hm7ina1g0ZHCTyNqP/VTFRHVM6sdgshZ2wVN2j3ej2iBzttnh
	NAFDGpntTkBz66SHNLaWbBOblPFQCR+VRnv2V9DPWGeCv5mV9baYtrFc1BbgMSev
	HrZSAsUrzTpuDBvQAfhsbtKU1sVtWv77Hpc3bl/55w+FTA5CBFcsQZwa8qNvjS9y
	UA/9nHSkwNijJDlcDkAjGQMwh4ZuG/UIgy1abfmtDFrbBaRzBdjvSB1iLO7s0ccE
	iL85a+IykYR7qjP+C2ouXneVPivWKeNXjgoL4dE3WJb4TboXzECfi7IQzvjvYPiC
	87hASIGf73zI5ZtJaTqEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920477; x=1787006877; bh=p
	I4lY+AJfKOOjXvPiR0jbn4HyML/QwSMTUaiVyOT0As=; b=fwlDkpgkeMZAR/C/C
	ZHIYGibmR+6BagltMa4AF34xr2PMsy5NRw+2XrmedxKjk3KU+BKe3dGZZ2a/c44F
	Ten7qAoPkTuUp9RW43eRSwxioiaEELXeJ/LPc9gwYawfdl/BJZbACsP9JDuEf6oB
	Wtvdge7jFJW7ZBqHTQM0Wyvvq9Ee8bkKb0DQr1cQy6ymOJ6H7+CX+twmnrLXi5Lp
	nfIWtZ9yeTCawpc4qzNfqq3/aRLrxfoOYUnpz7yK2pHtLUYiLCBuyHR/po/ALpbW
	yS20oqx9rvGQqNSCztj9W2NjE/igqtmYUoTwny+hAuIYNNMGe7F8zve174pc0AVm
	HCUnw==
X-ME-Sender: <xms:HT6CaqfyvV1vIi4cPst5XmFoYwVTFj12MYVAmADUns_pNyquOFwaBw>
    <xme:HT6Cat49Y_M7YC1mCQsfunNnGQ_3gaTp4CsJP6PQXp1aHFXIf2gMcJn6-6YONiTB4
    Np8Q-v1GtiR0G8XnNFhyKFgRDXgWfaU_RzL0AgNZ7ncPrZ8WQezqMo>
X-ME-Received: <xmr:HT6Caq0M4FYaQoZVQAo61i8KRQTbqjCb1K7aVDDpQjno9AKOcBYWBXEoCYA>
X-ME-Proxy-Cause: dmFkZTFX8QZ1Abcp//ElmtP0wYUsUMnb+KjPA544aOlJXhXcQAudkXa81C9Rj4L11ediC/
    SYpDnD1LvcyFEAv2YFQNL3ReIx6t28G7cFOXvsWQqNdQRv24cIelnnbcWrHqur16sY2q+b
    PHK84xbhjrx0R6ZFbdj3lDcQr+wbYteZ9PHsSvZgjQoovnxRkTlpJXxI+K+aK0DY9MqaWr
    nM0jSjvJAOtmNeFdTIuI9VxKMOFqeJI9DUUNBafqnTlsaU2K5w1xy/oDJpRmozGKRfcEpJ
    T4FDpTcqBKNo58tTW6I4nVl91YkYNyFfziYdH6IV5aj62MGBqsSUtSYZnaDODTOndFzTg4
    3gj7NdlC8U/37zfIU9cOpYnuRdXqkl9pVUWc3zwBpKJzvj+ZfRQlz7GS0Ejlp3UR3S3OSR
    Yd0A+lV4lpsWSXukhEFEBp0eGov5qfF8JzT+PPjVG2KIhEnHHbHIxwPmWbz8OxyU++EsAh
    RsLI86qe1gASncpfU8bRy6B8cY8saqXrUVybVt5nqWgtzw4IJAa+6Td5Hbmb1QRUXlJbJx
    GkafdYrgnhVsK1vDbEOoEqpzGn0iwNtltfuGQDQQEbiiDEAB8frR5GXA+RVgD6DnVcpjQT
    3C3sZmLkZkqv6ZVIOyP1kW5sYHRBNe9OT/zSKApbEQuHaXzBQYMRjgclBtCA
X-ME-Proxy: <xmx:HT6CagDyRQ4RhvEfGzHyB3EK742G3n4Cf0ippH7ddVrL0Cz8rHjG5Q>
    <xmx:HT6CarFe_F_su38oOgOf65C28ts1cZwxARcLL1t57AJm7cbUPCxvrA>
    <xmx:HT6Caqr7rAE7UR6Fz2MUQmypgCjJtDE4nkuSV6Tazj-PPVmoh0t5fQ>
    <xmx:HT6Car1ATaoqGe7PghNyWRYplbjHgWERwim0QIUKm5Fxhc16Eglevw>
    <xmx:HT6CavShMTfNJOFUXfFUaZCLyVx8e9_g9EfRz-XzhNxAflfK4Nd0UpGZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:56 -0400 (EDT)
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
Subject: [RFC PATCH 54/57] selftests/mm: cover collapse beside a MADV_FREE'd page
Date: Sun, 16 Aug 2026 23:46:06 +0100
Message-ID: <20260816224609.308019-55-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3F84C0009
X-Stat-Signature: p5gnuw1htxu1mfyuhcknsxmc58hbchb7
X-HE-Tag: 1786920477-771766
X-HE-Meta: U2FsdGVkX1+YfKfwdSppf3hAVMkUlOWWlvAsx+vad0313gQ5etoQkjwRRW8y+Kuxk5Z/odKJpVmfazyUlOGsTuVimjUerMWW6s7z/EYhKTyIx2jo/p6Zd5KV6qZrHuGclgJWQ7Zo0UfJaEFOnOu/f7udbOAkU3IcbfvyjlTAZpPGLMug36qH5yKf0MKRCI/0sr8IL1QtrmgNo22gyem3ne3DdjNRjN2QLBV8woowLAYN/wq9hmoyFSgfye95z2vTZaPn6ke3T9Q0RCSQif5J6j+cgAOBzvi972Ca179GNyqKiARXf/2n7Qyis/84/4PXBvGQQzxYioy8+rCsCjyJ8YKgY5eo3jO/M2LXFpTes/+RQ16eGHmoePIqwN9EdS8bABo9z3at2b+yq8krH1vm0DnwfhoKHDxaSWtaVnI7iz6kYB9OMaJADc6ml4qtnNh4WEj3Mlm3g/DnsS0ZCT2X3VwqMR2IRFB3e4csgKLi8OUbnkEgqS/HxQvHXqx2XNwvZLFVU4o3faLTdw48+ai+AbcNZVQxl10fQLpQRYU7UTm1RWVYWcf2HjxYkCst949m/3FPltRVIqhxWtWSZ7OC8K5RvwUqiqwFjdydVlNRZ0lm9NZn2WH1DNc5EdylAlaqgUqTW0g3wJL0M66HByzkpyRkMXV3J4tIEH41szUNPonIN/BYsq9L4pfeRVbD9GQVr2weATQE4nl7nMaFqGvs4PPmi1V6qxbL+eI7Py3RFbw11+eY7qLGlbTPAOF0lsO0olXN8PJRKBplUOwTPYPlEGNd6us02DvlkHo418ZfA5T4zgtVozsKgXThYi/DIBVemNVm1cik6p303aD18+FQkZLI026NTBqPnkYiMM2OfDWL4S4hbI0/MDh6gy5h3MBQoONOpCe1LWy78+CeGcO+9uneaFJav4+SHzi268j5We78dgaE1rxtR2sGqQhQjkAUOIDh4Bbeukbhc2ic7Pd
 l3AX9vXI
 Mij4YCl2yzgtu8DdotuBuQ5qbWb+I3ASd+4bQ4suTdZlrUCEoCBdszwnajQeaAvlPLp3/D00Oijc29aHoBDWcKX5J9dWp5eBzF8vbPkFlpq0SzVG5z2S7zcBlq8axJUOizXG+b6hczLWd5SFk95PLYgrcWwwlLp7aF6nocib2kZCQPVT+deG9T6fWphx4cEc7wY8slM6w0xvCo7dclK6NI5acW2nHnOrro/GemgjZe0MsrxXS7pLj9dPREFTqDyyJyg1OzVdC4owbdz7AV4WvJ3m8vdoKOoArpz1EU2+D7QPd9itAiQmuCgIUr5hVLW4LTAEkaxnfDYCCAoNqny61KART1vdgbejR/7/UaARBzqbZvzCApxOEri29azrayQe+Vh+QQXHsGEi431SzuZzoax1RJNoL856ntghsLB3qeot+2Mvosl1zZf2hR5NVLwrZle/G4F/O6XJp/D8VzimbE1AK/M3EBsCklJQb97HufVOV9zYRR77wAjqu+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A clean lazyfree page must not be collapsed.  Copying it into a folio that
is not lazyfree would quietly take back memory the process offered to the
kernel, and reclaim would no longer be free to drop it.  khugepaged
refuses the window that holds one.

What it should not do is give up on the rest of the table.  One page a
process no longer needs is a poor reason to leave a whole PMD's worth of
memory without large folios.  Yet refusing per table is what khugepaged
did: any single disqualified PTE ended the scan.

So collapse a table with one MADV_FREE'd page in it, and expect three
things: the windows beside it collapsed, the window holding it not, and
the page itself still backed by an order-0 folio.

That last one matters because selection descends orders on a refusal, so
checking the target order alone would not notice a smaller window
swallowing it.

The freed page's contents are not checked -- reclaim is entitled to have
dropped them -- but everything else must still read back.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 44 +++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 208300ecb344..58cb7364652e 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1685,6 +1685,49 @@ static void collapse_order_sub_pmd_holes(struct collapse_context *c,
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * One MADV_FREE'd page must not stop the windows beside it from collapsing.
+ * khugepaged still refuses the window holding it: collapsing would copy the
+ * page into a folio that is not lazyfree, quietly making memory the process
+ * offered up undroppable again.
+ */
+static void collapse_order_lazyfree_window(struct collapse_context *c,
+					   struct mem_ops *ops)
+{
+	size_t window = mthp_window_size();
+	void *p;
+
+	mthp_push_target_order();
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, hpage_pmd_size);
+	if (!window_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	/* Clean and lazyfree: do not touch this page again. */
+	if (madvise(p, page_size, MADV_FREE))
+		ksft_exit_fail_perror("MADV_FREE");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse the windows beside a MADV_FREE'd page...");
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
+	/* Everything but the freed page, whose contents may be gone. */
+	validate_memory(p, page_size, hpage_pmd_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
@@ -1976,6 +2019,7 @@ int main(int argc, char **argv)
 		TEST(collapse_order_sub_pmd_range, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_sub_pmd_holes, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_mlocked, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_lazyfree_window, mthp_khugepaged_context, anon_ops);
 	}
 
 	TEST(collapse_full, madvise_context, anon_ops);
-- 
2.54.0


