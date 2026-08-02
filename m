Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACCBAC55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757BE6B00A5; Sun,  2 Aug 2026 15:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F576B00A6; Sun,  2 Aug 2026 15:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F77C6B00A7; Sun,  2 Aug 2026 15:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31F996B00A5
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A433CC0567
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:33 +0000 (UTC)
X-FDA: 85057379106.30.C8C0539
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf01.hostedemail.com (Postfix) with ESMTP id C539C40005
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U aP/pzs";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=MKLkO1jE;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6K0rFA/42GWVg7pW/IyikAsYoBS9+Tp+qGJZ8yXnCxI=;
	b=QxyfgGcWGwQRYdTocaLaxEKSQ3R7bdZIki7ywMnKzsEpVIP1KOht86xTyQy7CFXGNHm7Cq
	GBZ9SESEfcRk8xBymcXa5S2x+JyjZU3p+euRUNsruDT5HOD5/fakJpy8t7l804zBKzexMp
	fTRtryUab7Fsw+QhaRSQ7pfCDOwDWWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700411;
	b=4TeN+/NOc4SiHrIiEdZCxAXzNb5SMzodYKXkuQhXF1+0soBjujLxaxRRNpDRaSP2TizOkk
	kl6IbVpLwhKcCvE54249kjpGvKmwIB3xoo+yRVNpIbKv/M7aqIqZf4U380Fw+ox624VzaX
	eltlxx6gaIg3IQnurxUiniNICwjC1Pk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U aP/pzs";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=MKLkO1jE;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 5CD99EC004C;
	Sun,  2 Aug 2026 15:53:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sun, 02 Aug 2026 15:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1785700411; x=
	1785786811; bh=6K0rFA/42GWVg7pW/IyikAsYoBS9+Tp+qGJZ8yXnCxI=; b=U
	aP/pzs6zz0h0LRGxpIBr0UfOSA3k4RPcZ+eWdASVlXPduLOEja+rMbkgH+a+Lol5
	h4p8XVS5DX81DzyulmjCS/yF/gnumDchdKasWwuT47Y180r62cnpA98HuavD4Zdo
	Vz5xJ++O66i4VW1XVPuwSK005NT4r72SbndJLZc/2HzWAhuZGlqmMzTBmpv940le
	GdEjVMTURcktf3paxYxdasDsft4oKb+rLuK/XpT4USitZozQTN+0UlaW76BTN94A
	H7HtRTwj5GylftKchYfi2tAPRPLkTlBwEjybmZWoPIITGd8/oyi4RmHOp6b8Uzor
	aYQMeC6zSETuDd4EliC6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1785700411; x=1785786811; bh=6
	K0rFA/42GWVg7pW/IyikAsYoBS9+Tp+qGJZ8yXnCxI=; b=MKLkO1jE/0Otbu/yq
	AHbx0+VXJ72xtZx1soDo9qTL7rAx5XMYwp4I3hN2qLVrYIWbV402IcJDodXO6qjL
	Lnlgl5RZ2BmhpnxwxK09hgUgvs5ew6Py2MN5Uk/KdcezdV46auopTVBZx3fmDhEI
	RUAcrAQvBZyBQjjiWEseXsgvYXFlgRvzwTUC9CgPba8+x8J6kyQY2z11wp0Gwyct
	MHbCDWS51F/+HYDwuY/160mejO67GvXUTS/NNKZwq4m543vc7zgwpA5RGiYKzFlh
	qyXRYF7gvxhp7ERmU9eD5Arp9whY6VHjCuQgMmBHqiNKcbKmhTqf/4iOn1gLzr3n
	8weIA==
X-ME-Sender: <xms:O6BvanKsh84b9JQ3I6n8WwMheCMf0PwtdYtDc734qcr-g3OeOn3Klg>
    <xme:O6BvalqAhlSYqML-xC-3ddTEPFTUCapFgNz_dQQcxGRpuPQAbr2jGHgqs5WL7qr7q
    reU4NcTkPPI9VfD9-sfR4zdHzBg9mZ34Nlf98oq3itrt-PPMXq5mnl4>
X-ME-Received: <xmr:O6Bvasofs3mi7HPjQy1rx7X9IeVROc__NFIXLGLuZorpMIGEU0JUmCXysqQ>
X-ME-Proxy-Cause: dmFkZTFcbv35QwNbwWPHQBcJdrWasH4YRFOBaNWig98oa0GgLD3LmQrthvyDgK5JnDhp96
    dBkNywOXlTP9Hby+cm0vRQHofuB4BhsdtVcBrMer/A2AOpegfr9Hr7RYzI6OqquxWhxeXC
    aB5bOw4cR5G6EDzO4v2r94SJnXRDYvi2NMwyCB/quID+suEuw0TjLUMYjjQ5pFm1F3OqpQ
    Ctej7rOharBpUeBz9hjZojzUlseCYYYMV+BulSa6+jD3O5m4ZOeULsSyQlLb9bciCyrhiP
    bT+z0cGYr8PFizBGTpPnPZCe+jZkx/DQlEsoaoSV2SjHlZpE6q2+n/t1AcZaLqu1qPGmmt
    J2A/ADzeAiJhREncqeCCozBMQV4vTj29Vg4C2eydWSSmaXBZYHSHzRhPGmFPpD43WFfAwZ
    VwO3prtQD7GXV9g5gi5N27oooKCPfcRAmxgWJ007AmrvaYUBHwSNdhNmfCQckaH+ClI1OJ
    LWjqa0LTLqe+LATNodWdp0RjOGRX+pPDo8Ajrtx3OVLFoKpEtGEYN2Q3kkTy8qjEvH/oWT
    U+TfvKX6dR1zXawrKnT+E6TJGIopcnWbyQhJTF83FDkAsugu5d9o2cDPuxokC61Bj+OJJR
    xMbu5MMFTRIXi/8Fp03WZ/pdmqUvQ0oEvj4PqNS5Cx5lPbKZ4cMwaR0aJpuw
X-ME-Proxy: <xmx:O6BvajHMeFU9YuWbrwYsubdZk8LFNHsi-TE-RsE_JPryAeGcF1WC4Q>
    <xmx:O6Bvamo6zXv_2RRQ_k5QTpKWtxRWSzcJ7dWZI0MruKshuGshiVZuuA>
    <xmx:O6Bvah1yzfRmuom7_BdmJ9P9ak4OSkFjvSdLSfZmyhsoKiEwHh3JZg>
    <xmx:O6BvavsccyD5jPT7x813ZDbnsaFiDcAOzd0r0hDZ8w10hKIygp0jJg>
    <xmx:O6BvamHD20uFDWsZLpkNj41JLFzw45tMuVKRdj7qK0hAHNbWms9QbgSg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:30 -0400 (EDT)
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
Subject: [PATCH 16/16] selftests/mm: skip khugepaged shmem cases without a PMD page cache folio
Date: Sun,  2 Aug 2026 20:52:48 +0100
Message-ID: <20260802195254.1937477-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ipeckmigy56e36paijj1nzsfaaej3zgj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C539C40005
X-HE-Tag: 1785700411-402668
X-HE-Meta: U2FsdGVkX19cfWnnTVn00azqAZJFrv+xQnk/dRBgDa/oelkLb5ACiwurdP2R2O7eu4YaiBuu8OkCx0XEqkOL09tjI+w1LAkN08mRVW59uDEnYWLjjzxNi0QmfWtQM35GIBmzNVmAL1EKanJeI2AjyPe0xzE60mSngCzfHHapLp5Y77o62Pps3bL4aJtWcACdfbPWzx0C8mDF1ylU/pbn773Mmi+2OxycL+CRgF2SDjtcdHtUUIZzV8wW1oS7ix3wUJoSF11HlRBz3nHrru+ZkCcNFx5ijkwU47Fhyvll7wj5oQjIocsXSv9dJVP9zy4w+33Y3FR2e4EbZlUY3TOvjwpVOOH8dg3+9PaYOELI6hH1FaGjrhxoABfaUeVxlbnnDSesPfIk1L7qUU988Mfssu6KkL22fODHKRVqVZvP3gRIm75VawPMEnId9xLC2rqVU8tYmj/ua6ZhoOeLJ2KTrEC805l5I/tpvjq8m/KLF1Sn4AHlDpTaGBEIzwQiAaxcOyLFj2i7o1LRuasfQ0idnUjRxLecaykBALlLAhn1kfHXjSZsDKSmuSxp84cr6nxpgHO2zLQx4JU3wng8qIgpeRioqYu4z9+HitgTLXAfcwog/okWg00UgoSs62X8L1Tun+TrvWR/Mx3uRFj1NlRFw/2AbyWwYcFoUihS6Ge3llwSm2s2+I4sy0vMpxv/M8FWSE0vt7x21cBg2GsgQzsu2/aaXBfyweXH1ZD9yvhgkUWIy4cNHcFUZM6/1X2W4N1fxWqaUA7HhyY4V0UAWmEWVrAoR9YQso0ZE21G1sYfT8LBY+Z1pZ/cMd3KLftcFBqUGVQVsXJjVfDa5ytdkI4HnyVCPj/fdGlrnWoAPdUm8Ij7O1hh4ZmPiAZZ+uW9WsDKZvFlWpR7rEXU7OtlmNqS4BY8qPMHEjxcVbAbpyWhQ8rOV8Y3ufXpANm3VmkVEwio8pHvs2tKDvhK5ynixEv
 BepqJDcc
 6g/6QZKRHoX2TJA01Jil03CyQtxF4CDPdSYtrOKJwC/zOukLj41annj+7B8jmTkStsVVr4B0OJLA1xuZFV8RbmFSMy3TyLByhBXNlDN1OumY852jW2dJeCdi88e9N4+tLtLtMZutT5CR+3buPNfH2uF/30xcC2EEuDI7KoR7eitYOKToF8LgyuH5tp3/OMXhk6/tp/hEgepGQ60fcXEJ5I6sd4Vlzde1UAgiNhOU1ebx6G9vC4cY2YJwWmSWmrFj43hTO9fLb0siUR9Uw0Om5nl9HtQ0Z4B0TX8GL+5Id3FFk5WBXkaylduq98VunWjqoR2BXsDWuTFTcF9Ot/3qRAEvghj4oQopunVawmo+g320DxYDRHqq6dIX+qdyrjlnNG8s9LZBtYDhyPXVoDwhkBoZXNo4gXP5Y3TeB5X74zshMqrtAYm1oR9l+ijqohuWBB3neoovAGSsDP5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The page cache caps folio order at MAX_PAGECACHE_ORDER, and
xas_split_alloc() puts that cap below the PMD order where a PMD is 512M --
arm64 with 64K base pages, as include/linux/pagemap.h says outright.
shmem_huge_global_enabled() then offers no PMD order at all, so
MADV_COLLAPSE of a shmem range answers -EINVAL and khugepaged passes over
it.

The shmem cases nonetheless ask for a PMD-sized shmem folio, so on such a
configuration four of them fail and the run bails out in the middle:

not ok 2 collapse_full not ok 4 collapse_single_pte_entry # Allocate huge
page...Bail out! madvise(MADV_COLLAPSE): Invalid argument (22)

That is the kernel declining something it deliberately does not support,
not a collapse defect.  Skip those cases where the PMD order is not a shmem
order, which thp_shmem_supported_orders() already reports -- it reads the
same per-size shmem_enabled controls the kernel only publishes for orders
the page cache can hold.  A tmpfs-backed file argument is skipped on the
same grounds, and a run left with nothing to collapse into skips outright.

Anonymous collapse is unaffected: its orders are not capped this way, and
the anonymous cases pass at a 512M PMD.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 9213ce1658d0..c5a3c3922581 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1584,6 +1584,27 @@ int main(int argc, char **argv)
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
+	/*
+	 * The page cache caps folio order at MAX_PAGECACHE_ORDER, which
+	 * xas_split_alloc() puts below the PMD order on arm64 with 64K pages.
+	 * A PMD-sized page cache folio is then impossible, so the kernel
+	 * refuses these collapses by design and there is nothing to test.
+	 */
+	if (!(thp_shmem_supported_orders() & (1UL << hpage_pmd_order))) {
+		if (shmem_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
+			shmem_ops = NULL;
+		}
+		if (finfo.type == VMA_SHMEM && read_only_file_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping tmpfs file\n");
+			read_only_file_ops = NULL;
+			read_write_file_read_ops = NULL;
+			read_write_file_write_ops = NULL;
+		}
+		if (!anon_ops && !shmem_ops && !read_only_file_ops)
+			ksft_exit_skip("Nothing left to collapse into\n");
+	}
+
 	if (anon_target_order &&
 	    !(thp_supported_orders() & (1UL << anon_target_order)))
 		ksft_exit_skip("Order %d is not a supported anon THP order\n",
-- 
2.54.0


