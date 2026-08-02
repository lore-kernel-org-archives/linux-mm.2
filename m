Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E251EC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DD96B0099; Sun,  2 Aug 2026 15:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F216B009B; Sun,  2 Aug 2026 15:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6366B009D; Sun,  2 Aug 2026 15:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 295FD6B0099
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 991DE14054F
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:15 +0000 (UTC)
X-FDA: 85057378350.19.E966A5C
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf15.hostedemail.com (Postfix) with ESMTP id BC585A0006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="C 6nAz0H";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mq6bfxHo;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700393;
	b=OJUYXmU3K+/fL623fGhRHg9XWeznc/ql5L9Pir5p1VAGbvtu6f0ys+jJqJhOVNnRgofP7v
	LoC6/keDHbTeaIdT59ub+3UDICk6oyn3yI7nq9ppKBlX/Lw+0UKr7jw/qNVW7NpQMhqo0k
	T4AC5AYBS9VLm/BkzCIA9zTrf5pTX4E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="C 6nAz0H";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mq6bfxHo;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GalfQyREKxG2C3FQIdFi+JAjsDFcuy0z1FP7FGhoa0=;
	b=tRT31TIGH5H1wZdyFjKJAJSVdsRWTqKDyHSS0YW+V4EOpX3RzB3DGfwbW62SU7M+el+1cl
	zoVww/OCfXFFjeIjzHtl90EeLnmsO+6TgIaDHjZdrsF83Rix/ASQOQjxBZDerVAZvoLLsC
	L8f21LX9clxB6izCeZML7v821c02FsI=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 472C9EC009A;
	Sun,  2 Aug 2026 15:53:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sun, 02 Aug 2026 15:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1785700393; x=
	1785786793; bh=/GalfQyREKxG2C3FQIdFi+JAjsDFcuy0z1FP7FGhoa0=; b=C
	6nAz0Hegkhoqy/l4n6NMVUHb5XKpoUhF6jsII7z8lVkOIi8Fm8fRPmgN815q05qd
	/D7nbBInNNMae6GhET1Od88zeMBG/C+XsVssIt3zrq/UKMEaAW8Plna4lgHpoA8R
	/z5EbgL7AEVkc130Hks85wMKj1a0nkZtBa9Rkp/d4aMuEFBcMpsd4QLWUTGGZ9ZM
	XIjxPCCvklNfoUHGLtHFVZDZmviMNBpAYvYVLq8JaAb9hIZrFBOq8hYCWTKTsatn
	wu8IcegD5quLBx6zPhIV/elCEeQWDY1L1EtUS/yYKjzy4JI1HJgO4l2PKeisssoV
	XpksLbajYSFKc/7oce7Nw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1785700393; x=1785786793; bh=/
	GalfQyREKxG2C3FQIdFi+JAjsDFcuy0z1FP7FGhoa0=; b=mq6bfxHonPq8Benoc
	6tRjC91Qwl+i8dM2qyAL31SGbN9L3XxePb8tbua+ueWOf2UH460LXW5nYqgVp1zg
	DAuz24V4VRKKujqoQk8Iq6oL+gqXKSvJTfd2zqPnBKDAXLUwKDCD3iv4FQxBh5Wb
	ZUz5S2aCuefi1VkI3jXXxMeuSvv9WzYkSojirnQyJkMhr/2IQI3Y/B1dU0htROpO
	vT9Uh27K+OnD3S1FCZG3gbWI4cfdVaYq5ShWTHvPOMpCQfZ3ukNyMB3usbeAEexE
	kAdhJPFog0TsZeRgikS22iXkaXuTZHvGMqCcv9pcha7mtqfWPDmt3gJX5Yj/OBsZ
	sybcg==
X-ME-Sender: <xms:KaBvaqS30jjklCgWg6CVTIYrA62shSxzseXhj5nQFkUURoOwiEwhiQ>
    <xme:KaBvaqQwobAprdIO7Ph3yavdhOE7Ep9ietD-I8cmMUgpVUIgbh7qC5i-Dbu49J_GN
    WDluF-hogELudzETQ0C6TLrxM6O4ZNZbPbruAKNIEG0Tc0Q3wQ7OGs>
X-ME-Received: <xmr:KaBvakyrqlv6JBQcj4S45MDmuE0XFsOIm_40RquTR8oiuKbwhO44L9mAuNY>
X-ME-Proxy-Cause: dmFkZTGeN1xI4bt1iclSzDFip0Bk/XaIhvbS/8i3JSTXfor37WXDF+RcNWPPd9pfiJK8Zw
    2BrRRh4rnHFGERiD1jpqkpu4TBSJEj+dkjcrMZ9PB457VyyAOaPr9tioF0eAgQ73LLdMGf
    ZnUc9d7R5xpl56ih9w8zQdF1AdPa5yFqJeaq79y1FNmaYwVg1fW3ZavvRb02VDPCTYSs5n
    EKi2mK0TcmJbPEDbjm1vybeof8AWtEC76nwVjuGNoLmfYq44vTWlCkOqLjX+gcHHM4Q7iT
    SPI3JBSpkIfgjo/e1nwt56byN8xWT3gnCcQMRcCsWQ2AE9kBILBwP01Qmf1NZFO2elKCXI
    XkLOto1aBOC0cyJ0aBcRedijAUCRu75ag49n4uds8B5vtLBgS8ErmJEmXjo7fYAYYWI7JS
    cu5tkEvFEJ2qbFcGnDKS6Lfnlp24okWHwGDHmIFrcJC3eAC0jJSvsTj1cJklnskvScRcrH
    qkaYHCr9eu/VM244yipyyQCQWmD8wcY+Qev1RTM2TJ0RYIocSEvBgjdN9BfMrMoNi0UKgc
    57FC67cUXuny0o2J+9N6RkBtbtoLuv0BiPrIduS2c6ZfeaMaMAbmEMgvSelijkkEWQ86RA
    f0cFQ15eugH72v4Gm9qiXX2WIKLaYmb3RSpi75yCd8wTPoMezrbBSqcTOQDQ
X-ME-Proxy: <xmx:KaBvaov-DUuCnv8AXxrALMZMKyCcx7VtDEbgPoAL0k_DGSgBBdbxAA>
    <xmx:KaBvaryGiI4giROC5_Sl-AyVQtoRItwlZqJOQIOOS5c8CexEBwdEAw>
    <xmx:KaBvagedtqxFWzYUXYapkyfxOpvIrw5caaRZVJrXRyAqA3i3WKtBlQ>
    <xmx:KaBvap2eAGc_kvopij-uepQhgyz2UMynPM2pi9SD_paY-OYaE-W8jQ>
    <xmx:KaBvaoOONH7FR7YmN-ziScF9kJf_xGOd5iLSdm8cHG0gJfpVfsslXZe8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:12 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 07/16] selftests/mm: cover a shared-source collapse write race
Date: Sun,  2 Aug 2026 20:52:39 +0100
Message-ID: <20260802195254.1937477-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BC585A0006
X-Stat-Signature: 6xsf84weiksc9u17brtd8a97g79oyq1h
X-Rspam-User: 
X-HE-Tag: 1785700393-526850
X-HE-Meta: U2FsdGVkX19qOIhh0uw+TGlxUpc2AXVvsV6Fkpjm1G6eiL28wzbRE7BxctOkRnT9MYQh94BdFfZ1Y5nEyuy8gNnIAvck8VaLAA4ogboeZ6g4c/vAhsOk5NmkqPq8C+v1S12jzlIVdG2Dg39N1O7obumGDakAJApOKAp//xwHgKPglOcfEOlDtEiFqn50eB4toFxKlyn+UfyxPWrzxPHPA/XRIhdr1UNRhMi8Liq5Ce0hBiKXvodHU+N5tF/DHquxbQpkztpHuCO96DO8iJJ9BQjoUULBFEYq1UByDsvEWon3JzxgCrsJrMDJY5p2/HCyzNcS1gjMLLTfGrdb5cDrR4QSlUE0Phyc2FMCI2jleOHqN+AtTjrxY2A50MpFz1N8dsrGj96SsWS6PbATgT4te68vxDf3piQ+VqquOJanxesqo8d7eyBcv2PXZeUbJnJSeFEgZoFTHrrtWo0nVyf9KCNMApRLfMVQ1Syr9sT3Y1jT/qZXyzV5oInNRr6pxnesEAHTfHSGiP96bxZF+r8+iTCjYwnfgN0DfnkS6KSJdUSAzhWyWMR0Rpd+npqrIP/1gykIvXsHvPoce/LZkEAiFEqjvqlB2fZqkYZygqF1qcVZ/6calxocRaAhgZhjkgvqBRYHyUyAo/3yVr9oaqzZ9/ie6P6afOivyq95/DFa07+q1I1bpi1w86GMJBWS/jNAwUeaqgtzkaP498BPWyhyxTggHbwnPOqMTSpX6MG2P8SHvDFnt7ehbs4zGs/HZwK8NP9cZgWNWnmdtqNMP76nO+iI/9oJbQyMZtbdwFUSpOW82+IRM0F+XaGh56QNcWGlAb2ZCfDEMkG0oV94IYy6wR1g/eXo3Nc7X+bAQ+quzM4FPQSxHVsXImUhIC1jfwKrlbF/JJu2SwR5pZhcUpof17skzaqZlcdJ7UAk/8QYJEItv2mBbkO7+GGLEfbGHShBvbGhAz2FhdyRbIh0B4+
 GXY/9TVK
 +0TqH0FbDMnJio8sZOLFuxh0WHyVuAIskMMYPXMu8M4NhQvf1c9oeKWfnPzALR9cGoL/tRFXXtzgzHgNxPWqEyiG45fazjA8Y2zEGOXzZpRMsfXIzFa7tXEPIQkDwcfGtHd1PdkNKDTaSpzNth0Z9EkBzCJ2Rj9YRi21wQ7vZ2K8YGHKEPTYo+4ELEaxWuGpytgTwKQra+h/Le+ln54S69a9DwdK0O6IvibwpYUEGJ2aBJMSALx/8XJ1f2oIJqbB/9KhzwiN6x0ylxITEuPcKonWQ+hy3KIlMpGcH87OuP3p5OpulwxrCb09gnD/3g8h69W6bj4pBAWanx9F66vnSsQdEsz7OoW5VffW3JCjdkIrzrliez4jJJgeS/AtGgsTnQ7MMOEBNRHZmU0mOHdc3Rz2dVAyQuY9JGRL88kLO7ImMqlwzkIlHKn6K8W78onctyaJT+WK2MNhKf7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_fork already checks that a fork-shared range collapses in the
process that asks while a co-sharer keeps its own page, but with the
co-sharer quiescent. Add a case that keeps a co-sharer writing to the
shared range throughout the collapse: CoW must keep the two sides'
content independent -- the collapsing child sees the pre-fork content,
the writing parent sees only its own writes. This exercises the
requirement that CoW keeps a shared source isolated from the collapsing
side throughout the collapse, even under an actively writing co-sharer.

Passes on the unmodified kernel, pinning down the CoW-isolation contract
that khugepaged collapse already provides.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 58 +++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 65fafab06410..81001e15765c 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1047,6 +1047,61 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * Content stays isolated while a co-sharer writes concurrently. A shared
+ * source is copied live (not frozen), relying on it being CoW - immutable
+ * for the duration of the copy; a co-sharer's write goes to a CoW copy. The
+ * collapsing child must see the pre-fork content, the writing parent only
+ * its own writes.
+ */
+static void collapse_fork_cow_race(struct collapse_context *c, struct mem_ops *ops)
+{
+	const unsigned long shared = 64 * page_size;
+	const int stride = page_size / sizeof(int);
+	int wstatus, i, n = shared / page_size;
+	int *ip;
+	void *p;
+
+	p = ops->setup_area(1);
+	ip = p;
+	ops->fault(p, 0, shared);		/* shared prefix, pre-fork pattern */
+
+	ksft_print_msg("Fork, collapse in the child while the parent rewrites...");
+	if (!fork()) {
+		ops->fault(p, shared, hpage_pmd_size);	/* private remainder */
+		c->collapse("Collapse a range shared with a writing co-sharer",
+			    p, 1, ops, true);
+		for (i = 0; i < n; i++)
+			if (ip[i * stride] != i + 0xdead0000) {
+				fail("Fail: child content");
+				ops->cleanup_area(p, hpage_pmd_size);
+				_exit(exit_status);
+			}
+		success("OK");
+		ops->cleanup_area(p, hpage_pmd_size);
+		_exit(exit_status);
+	}
+
+	/* Hammer the parent's own writes over the shared prefix. */
+	for (int it = 0; it < 200000; it++)
+		for (i = 0; i < n; i++)
+			ip[i * stride] = i + 0xbeef0000;
+
+	wait(&wstatus);
+	exit_status = WEXITSTATUS(wstatus);
+
+	ksft_print_msg("Check the parent sees only its own writes...");
+	for (i = 0; i < n; i++)
+		if (ip[i * stride] != i + 0xbeef0000)
+			break;
+	if (i == n)
+		success("OK");
+	else
+		fail("Fail: parent content");
+	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void madvise_collapse_existing_thps(struct collapse_context *c,
 					   struct mem_ops *ops)
 {
@@ -1595,6 +1650,9 @@ int main(int argc, char **argv)
 	TEST(collapse_max_ptes_shared, khugepaged_context, anon_ops);
 	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
 
+	TEST(collapse_fork_cow_race, khugepaged_context, anon_ops);
+	TEST(collapse_fork_cow_race, madvise_context, anon_ops);
+
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_write_file_read_ops);
-- 
2.54.0


