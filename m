Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE644CAC5B1
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9668E001F; Tue, 23 Sep 2025 07:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47AAC8E0001; Tue, 23 Sep 2025 07:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3427B8E001F; Tue, 23 Sep 2025 07:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2558E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:07:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3E2814045E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:27 +0000 (UTC)
X-FDA: 83920238934.18.2F5BDF6
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC1AF4000A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n 08H3Hf";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="m0x/vk62";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625645; a=rsa-sha256;
	cv=none;
	b=eKrI/ncswNRZziVjX1xv65ehFi4zRNkvU1hmzjQQcT5G+GD8Nl0k22LPzA/R5wQryW1QOi
	esAqDToAqUpGPSERGM2DJAGcgkJGcZP7LgXw11MgjyBbvZcnONJt0hwyqjOZo3gfK9I7vL
	8kC7POd5UO1KyiLnfpf/ywfrg4N3920=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n 08H3Hf";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="m0x/vk62";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+30FsNxlli8PpC3TpepLFbX1IePGlSZR2KUwpff5IU=;
	b=tMtJqJejPTHCKuVV58/gDCFki+TQhlMRQtLXj6n0jqx6UPW+KMqtwiJR+j10Zt/xWcJB5e
	X9470bkoHQTN6vuLMIqN0LJXkVQM0bpoYa+4zIyjHOEY3gMZipjO6W3WDRhddK2JEP8To4
	yEZuXjVVuhyiQK9sOH+MO98T+WJeeyc=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 41FBE14000C0;
	Tue, 23 Sep 2025 07:07:25 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 23 Sep 2025 07:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625645; x=
	1758712045; bh=l+30FsNxlli8PpC3TpepLFbX1IePGlSZR2KUwpff5IU=; b=n
	08H3Hf5JxGLXF135U68VKyoIWFff/JQy9D0ZE/ZEhu7CPWR7n0aLuH0zQHbraFYC
	nbboBiz7yoPXe4ZJED9Qrjc//StA3KjySXkw1OWrz2QuL8h9T0PuEZc/m+yE8IN6
	r/t0Plzb56QewOKNfsXFPmTnl4uLXUjWEgXGb+BpP/Vqd2R9S5o/SiMV+wxf9h3F
	5lPGzkfd2CaSdaNdcYSdZeQIwt4iriXAcUv1Kaizd1iRb7TdUII5ZgI+/nBVTtm2
	VnO3iFTDylkOsbDcqkKaUcRV9qxqLkKssxM5ZtCfbOJ6TGT0RJ5NpvevUkWl9q3e
	qrduLtDqjogm48X6CMOig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625645; x=1758712045; bh=l
	+30FsNxlli8PpC3TpepLFbX1IePGlSZR2KUwpff5IU=; b=m0x/vk62Pnle6U75M
	ta4YLB6sTiAwci7bsRD/ozX8OCX/XwOrDvUBr1ezdC/8F5HpUkaiw2JapAdbII6k
	8s83X+kI9Xa9nbeqUv4kxskTh+Am2cN6XiYe/O0h6UxIYfAcUHXlzaQcmGj3ci0n
	7ASQ76H4xEm3imy2E/o7KSCqbqOhSOEEoCmQyt81xak5G0sJ9GlIAI4EEmDkJ30R
	Xq12nB/Xw6SILiKbnrxlxabfOXtGx2ktJ5UCOJz99F77/SL7JDNtz/f3iT7YLfsC
	uBaj2tj4ohy3cPgdNAO+ULuSKGXE1yVyS2Iyt8QYNRLmdDiKsj/94pmv/SvYKevo
	J/sRA==
X-ME-Sender: <xms:bH_SaFz4dlYPdRaPtw4tPaQnqDTB6dgW5f9FkkxZLp6jrKm-QRukCw>
    <xme:bH_SaBMm37n59yFZRgGB3ERAOdjKRDtW5hSjWE225CYLSDQb1eSgJ1XZ7iGFabu4V
    _IocKR37Jy2LHOnN2fc61R0JicdoKhcLiJ3nVaqiTKuyVvv8TdqjrQ>
X-ME-Received: <xmr:bH_SaFfknfb8BTkXX0ceQYSgcYipC5LOsUsjZM6vfsziPptdkbAqJcF5fu4Mkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:bH_SaN47OvHksZD_Kr7Pabf3FWsXGi2-DrF9g7034zctM2q6003W8Q>
    <xmx:bH_SaFKk_MieIapstRh_06R1tikVH2l-619-v1HG_pHJrPxGxNZ4Gw>
    <xmx:bH_SaJ4-9MPmlnAdk-c_mxqjRqV0eunF3KAxa7uiqVL4e6itHND_Dg>
    <xmx:bH_SaMa8h-cBPSf3J5R71SuOORCN6H-V0oeYxCJlFhf8oDVqAwxNDQ>
    <xmx:bX_SaI2RNAITEVL56sb0MWHotUOqzykoIwJCx43rop5hK6stwtjRuW-7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:07:24 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 4/6] mm/fault: Try to map the entire file folio in finish_fault()
Date: Tue, 23 Sep 2025 12:07:09 +0100
Message-ID: <20250923110711.690639-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110711.690639-1-kirill@shutemov.name>
References: <20250923110711.690639-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC1AF4000A
X-Stat-Signature: zc9m8pofbda6b611r5sqj6g4pq8xbyki
X-Rspam-User: 
X-HE-Tag: 1758625645-545666
X-HE-Meta: U2FsdGVkX1841i7pJsVFw00MG8DfeCyaxUD5laPOBA7hMNBuRwnnxa1dXOUSi6RI4BEaqDjGHZ5uFzYS1F7mNH67eUCppjC+CMsNyosoBL8XmENMCkYQ6qkQDfKNOBXplIVEzM8fjlWP4aj/iGeeZXUdN+a6oTTU2YF3xp3NbfOkFfzG1P0pyCu0uafSl5dvld2PIR4KwznfBqB07FTHoWD+sPPcilCKyQ9rx6XCD+8VyaVa24ACkcakY8ycR7df7Zsa0M196plc5rPscjcdu9aC5pEbU11wAKpbxvN7/VTYe8NQdikv5tjkUkzM1a9Zd1RHG3z10Cs2Wmd9Mn90xODaj7TsSDw2foOr7iVfBN8x85lS7Qp1nZ317kf/kbN7NCsMid69Iez1PqseB+rY0/CyLTyjj2azSmm7jTevIXvBRktL9yPr2smHSg3B6TU5UDqVtIbeHeaSPYWaGTrjkTze+YF9M0jJ/KzAqwHE6574hyq5lEZ6cqHFfVGhOT707TLsCEP/wuOrFR3jLNZ4d+aLZXrKt1fldb+Nt+Ka9x7ktdIkbrO6ugnu9/1kPW6kviZaocP7HSLVeeQRREK1TjKa7HGanICS6Sk/qCAQqN95BT/Vu+OMBBjTSaujvfwu3ZVFROK8oFbbnfs1T+zhGvJTmk4U3M8B3y9QkcryNvhit6QSZ/Fd0+SBIKECfOsbJ35FkdI91doE0brltr9Gz6vkxiwr7CUasRvGUsakBMdINF2D8VGlhkYMSbwFAyQanQOmVG6k8GO0wmPeStL6Fa55/0TwQbBcI8fMK/A2258YFwjww3+kb0GFD+FV1JYFewTsgeSDMWlq5Uy02ul43+nd4zvLlJcFxzRt7g4/61JZdpQxWrhjSwSIRMvrVfdnC+8Xdk5ALeUzSy2rR1M/0hm20uQ0VTkoFk3yawtdLo0n0z5ZwQtqHq8+iXVdbCMMvBsNE4mqYcn89P53+QT
 XYhjhfCr
 AaDI2Y51FlhMY5O1woR8syFONUB7/3GJzQ9VCI1uNhC3GSP9XBSZEE2FkupvIbpkukkl+IljbzmjG6+wSjAs0f9Jm9rCKY0CYuMZjDPbQVga2V9k6ZJnDaWVxhpXey4bj53FQPfkBf4RxK1wZamMq1JDXszMFAqV66D0bB98BoG9c2G6kVIH+IEzmc3JX+Yhy12NEnk39KHaCNgch1zdSkAFXi4FBntar8kjpVwFYGTWzL25x3YzvtQXTFasbhf6Wlzr9vQpzvXVmUDaHt/soBKuOQfMQo8AAZ2e9gAiIa2wqSuPLGpcBbTx4owJ8ne67V7BI6k7jWwTsGC4jTk5vkQz66eA5m12nWM7Sbx5c2VXXpcmpostyy6uGvUcSaMi1TO2g0T410w8QQS39FmqlW45W4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The finish_fault() function uses per-page fault for file folios. This
only occurs for file folios smaller than PMD_SIZE.

The comment suggests that this approach prevents RSS inflation.
However, it only prevents RSS accounting. The folio is still mapped to
the process, and the fact that it is mapped by a single PTE does not
affect memory pressure. Additionally, the kernel's ability to map
large folios as PMD if they are large enough does not support this
argument.

When possible, map large folios in one shot. This reduces the number of
minor page faults and allows for TLB coalescing.

Mapping large folios at once will allow the rmap code to mlock it on
add, as it will recognize that it is fully mapped and mlocking is safe.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/memory.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..812a7d9f6531 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5386,13 +5386,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 
 	nr_pages = folio_nr_pages(folio);
 
-	/*
-	 * Using per-page fault to maintain the uffd semantics, and same
-	 * approach also applies to non shmem/tmpfs faults to avoid
-	 * inflating the RSS of the process.
-	 */
-	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
-	    unlikely(needs_fallback)) {
+	/* Using per-page fault to maintain the uffd semantics */
+	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
-- 
2.50.1


