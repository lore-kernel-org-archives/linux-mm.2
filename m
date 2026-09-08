Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F02FC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83A16B009F; Tue,  8 Sep 2026 08:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A581F6B00A0; Tue,  8 Sep 2026 08:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A066B00A1; Tue,  8 Sep 2026 08:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1A56B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF04BA4DCF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:22 +0000 (UTC)
X-FDA: 85190580804.07.FB516E8
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf14.hostedemail.com (Postfix) with ESMTP id 454E1100007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l 8YhART";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MmQfNFUF;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gl/sNwAk9MDF/uFMRp+A1/O8Ght2HDEnJQvn6SudLCk=;
	b=iy1q2nqk/crGNiZZK8gLuDXvkkCzvzcNbxoAs199Vb3BMxcgrzlonBBpDNOw8HYLCimJHI
	psOKslYckr0Q/Ok+XtGe8i25skN4tXme3vs4035xxiSulQLU5LCkbfvW8Y31r6eMdm2rnT
	Tn5vNDzGopTDBKvPvdyptibvFEubAAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871880;
	b=C76WGPP0mdXSytVl1zhpk95727OzlmhY6UdenOtrgcP1brhuZUWwyPLtk0NTBEptGJclc3
	oUYWNCEHGQFHtiyohpy3/gSbgQ5rSqE1jOKmENwtqKOxe+EfRrUbZyLBRBdqDMTPRuXRsQ
	rmap1sj1O1qMJJIvoXQfQaEJ2d2w05U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l 8YhART";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MmQfNFUF;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id CF38EEC013B;
	Tue,  8 Sep 2026 08:51:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Tue, 08 Sep 2026 08:51:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871879; x=
	1788958279; bh=Gl/sNwAk9MDF/uFMRp+A1/O8Ght2HDEnJQvn6SudLCk=; b=l
	8YhARTz/DRsSj+CrFAs1wJ/EXnlByExmElqF5uPaJHdOMAobrey2H0mACB6haNFU
	Xcq8HUlQUX6UZcrfJ1VtA9pv9u0upbIbCFAr4+T/mw1nZxchO/mIvu6IVGilpgsQ
	2qvcJ4BXvcJGH4i7RyrZbXeDqUVCrDBrDMMAedK97qDEYMA/ywP7e7imkL5NrT16
	0yvfz8hErw9lh9ZAfOcU0F9mmFBOKuzEI8lcoZztJO5XWqISXlJC0wOc1KnoZVYj
	WPu4rY8M9eZto7uU1dCkppOyu+5poxT/ZFo5sbwS1nWD16IvTSq7sN9TFJlRWUfl
	0nqkkX35wD2u6Dh6JK13g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871879; x=1788958279; bh=G
	l/sNwAk9MDF/uFMRp+A1/O8Ght2HDEnJQvn6SudLCk=; b=MmQfNFUFVG2JY22t8
	zHHX5aEyuUEqZYyracR+jrE5KqeB0O1/i4rwmNNH88JA4uzU7SbvBHalWRvpPoVb
	kmhgscquSUdD3EhSDuQ2utBMFoA+pqhcPmEQVD31AzDTWALWnBKoY8aIoWuIXl4W
	3NbpAw2c7DhvmlI7kIxkaAJdXE2O4ToT0etioHXmwvd9krxi8IYb+SN3y1UYGHxD
	ScbatNeOvRbXj0XgryP7b+8t3UK/AwRQTsHjnXoAZ34lm9LDrIuEd6JZ6KNg7LAG
	l5Xo93bU2npS/scy2XhysDS0w+YdhZKtEw4UAd1yC+CfW6afdlBDnDFBsICYPy8v
	xyT3A==
X-ME-Sender: <xms:xwSgalahzoe6lfgl-4cJL1ywb8M_oLYQtgR3JBahasrtiOJoxxXr4w>
    <xme:xwSgakyOejEzFRioPMLH6jQTrBve8_Klvuq3AcEfrMTtp-jIEXf3clnLbcgpbjfbq
    _ly7jxMxi23A-6Ukd138W7fBTpuiWOu4OF9HrBEzr1WIT-evfa7hgcu>
X-ME-Received: <xmr:xwSgaqI2220NSlWIqoRi5ZQSsAy3SjEYWX1f6s1B-X0ICSjtPVk-IGQJ_Lk>
X-ME-Proxy-Cause: dmFkZTFCT83ts3xpHDuUgDdlzQtELcoAknrXBpsFepmdcEBLccwduWOOVyAuau0VlYvm49
    objBvbnGefvuHsKXiB+MOl7qErn3M4/Q7Z72R+asBFni+WG6jRYqPjjJBv1F7ovmfnEZp3
    uEJcbLADGcdxsWcYxdWct2wwV9KQaoOTpGWM7Il7/oKOILrVOp7MvqHbWAXdA0mgRBniUZ
    2M+Su4Zoe9zFbzekNirjNltohahTSfzaLbYZTkGXD/hRQ+ajqkABo2HdEn2GJrc7g0w4Iu
    PhTUexE0AKZ4j2dsA7W9i19VnbZvZZgTTujH64lpg2nDW6KlKK63jDlRsrLETwVfJ8WCe2
    Ngz4DLrgyUxY05wMYj52j8IakMHZKjkcWHX6PYSVhe3AlZy4M1ACV5EBxH4kd0H1Kc9DiY
    g9mfroPvWHQrJqix2WbYkh+0yw3iGjq9SlphS1vxYbmdZEneTbyhqQei7aqhOWMyHLLFN8
    g+Puu43NWgy293fIhoqtx4EwnxenYlvaQCDmpdnFkZzd127+WZ5hnTIkuC0SWk6uwEYx7a
    FBkDe/N4MKWvuknNfVsRDKu5ZmgttCQMVyyugin78yj8cUpZ8YU80vnm0iDXsnJNB3Al5q
    Rw2Kn3tCM3rFQEhRtEi8tY31zTv8WWpjB8EBzKLVGQt5H6VCIXF+Hs+/E2RA
X-ME-Proxy: <xmx:xwSgarcAIoSCpjlcAlBMWEs2wD6H0XNZGU-0n5W71dvtfXLkhYaElA>
    <xmx:xwSgaishpHOJ3Wzrx5slR6QvCuJRqzrC05K09A85UWthm502SwuqOQ>
    <xmx:xwSgapEgYtQkBuIZedlTN1YyQpVUXDUYI_f5axKQnyMzTa_aqSdWxw>
    <xmx:xwSgasfNp_63oxU0PeMleyljsDXfKzHUpC6HXN1NdevUG8QTuIE9aA>
    <xmx:xwSgak7LwoTgAXby5oMmKSAOJH9wwTCV3dl4zjory5elr7rjPJsCOLmU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:18 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 04/19] selftests/mm: skip khugepaged page cache cases without a PMD folio
Date: Tue,  8 Sep 2026 13:50:50 +0100
Message-ID: <20260908125105.1510704-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 454E1100007
X-Stat-Signature: 7zujh6oypse4m8o746m6dbko54q5mrwr
X-Rspam-User: 
X-HE-Tag: 1788871880-538565
X-HE-Meta: U2FsdGVkX18oUQMQYRGkHVYuRKROOdj5MLBB4/YaRJ/voIbPCyy8vFshibrd+mCsmkCc9ReFgC+Pl9QsWAHlLn+ErsHRYzrWr/nhbn2rkxTz5l5be9vNpdpUbWgXdsEKsEVAlnbs8DPDjVr5wsl9BLyzTJP3ktrdzavl6wpYMNMLiDnEaS90b83x9hlTHPvEHu1JZUqUfWXDfob1YZfXNN8rPhDum/m6jObFM3AYjr5n5U2pLd/pcYJQt/TlLShoYNnna3i/tC7BBkuDp9w9lU8P1MB0l6AOupZJYJhSBNsKnfgB+HsxlJovGFc0ge3L1CMbiDdOrRm+dLocHqD5CiKuj/De5Xk2dtXIOCkUo6MzlnS8GJQYix7mj0RqHygg2Y1VcW8WadQwE+UrbXVCUCp0D49yPVGOKYt1H87MiBvhizsl9jmrNg19GLb/84C5Rp7JDDh39Fl5lmnpe9F4cjOKJV5U89kJI+G5s8/7FWKwQrLuILshpw2QgVKHfX9fnUZvpfcahflmJ/HiZjl63gAoq0L1nmdzGOtSdad8HR3N4Z+JZr3/0MEFBpHCvkkQweXKQN9uSq6HXceA+MCL9MAZ1yi1NKOkrW+jw1oCczqqu71IbZu1mH7YCB9jOV9sIro29i679oCptzI24pMKG5AQPHAbRUAi7sV1SXQRugBnPN3ZYuB7ZF1Vw1av+PK4dgQYbfYbHdWzKiJ5mFfHpunke2DLAt1gPfaN0HNetnC3PaIJG5MFpV0wPb/6LonLopQws1J7WEoIE43oBjwC42pWbaeHO4xCP04CSepBjdpX/CPCFvpbCTmDD6zpoMtNEYJ5fZt0td+GYQ5yBswXnPpWcT+l/coHoVG35cFAKCssuvfvqskeViaVt6BnEqlvAlalddRJuGBJA9ZkV2xaoXudAVbDymymmTsSZmBDFcR/7aup61fGr79W0R5tEtLCeU2/NubZdMpf8a8Eku0
 Epp3LmWH
 DhlCKBPWdHabaIQ/GxIs3VQhezWnXlq/EhzF+MObrD0AZKqMyHXHYG1lvyL2tqbNRFEM2g7WIxqI2zEdL/xDaHFzVbdrb3GAviIETVrhbB1trTH+dWcaYS7+BO43fThBPH1HUnhiDV3i3bM6oVwa2uMLH4scd3KQzJQbsu/TlF+SEBnSvgcmMGUSREzjkGVK1VTwJfZvEZUJ6w7VeXC+ogi2KiCe9zKLz5TIHZIAv2yH9Iq4HLKjdxJav7LyiRieWIq3uMLl81URiduLmHRHljKNVGgBtjw0w1n77BJy1Rn7+6dvR4qXzuH1427kgBe/WWWkVWhi+S9ITKZVK/K0NnbBJjQ90kJbZoCaFzJQvts1jGyy2RBN+3AN01avx63xpzNvIp4iK/d37M2u9wpD57qqriCXzwxMpch4rvN+52gHt7MpYcb/seL9205E4nQCqwRPC4+LFiYagyfkHUNECIMvGt5CbrXbt9Orka8+6TkDAVs+9IX4fQmTl+BWzk8teM26p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The page cache caps folio order at MAX_PAGECACHE_ORDER, which is below the
PMD order on arm64 with 64K pages, where a PMD is 512M.  A PMD-sized page
cache folio is impossible there, so the kernel refuses these collapses:
MADV_COLLAPSE answers -EINVAL and khugepaged passes over the range.  Four
shmem cases ask for a PMD-sized folio anyway, fail, and the run bails out
in the middle.

Skip the shmem and file mem types where the cap is below the PMD order.

The cap is not shmem-specific: it applies to every file folio.  Add
thp_file_supported_orders() to read the orders the page cache allows.

Anonymous collapse is unaffected: its orders are not capped this way.

Assisted-by: LLM
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.h  |  9 +++++++++
 tools/testing/selftests/mm/khugepaged.c       | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 726c73c43c05..a1d12e2ffd62 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -87,6 +87,15 @@ void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
 
+/*
+ * The per-order shmem_enabled attribute is created for the orders the page
+ * cache can hold, not just for shmem, so it answers for regular files too.
+ */
+static inline unsigned long thp_file_supported_orders(void)
+{
+	return thp_shmem_supported_orders();
+}
+
 bool thp_available(void);
 bool thp_is_enabled(void);
 
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 48e0040d53b4..73bf07c39145 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1353,6 +1353,25 @@ int main(int argc, char **argv)
 
 	setbuf(stdout, NULL);
 
+	/*
+	 * Without a PMD-order page cache folio the kernel refuses these
+	 * collapses, so there is nothing to test.
+	 */
+	if (!(thp_file_supported_orders() & (1UL << hpage_pmd_order))) {
+		if (shmem_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
+			shmem_ops = NULL;
+		}
+		if (read_only_file_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping file\n");
+			read_only_file_ops = NULL;
+			read_write_file_read_ops = NULL;
+			read_write_file_write_ops = NULL;
+		}
+		if (!anon_ops && !shmem_ops && !read_only_file_ops)
+			ksft_exit_skip("No mem_type left to run\n");
+	}
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
-- 
2.54.0


