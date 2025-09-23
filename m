Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04EB9CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13A38E0015; Tue, 23 Sep 2025 07:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2328E0001; Tue, 23 Sep 2025 07:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18018E0015; Tue, 23 Sep 2025 07:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86C068E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:03:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57CF214047D
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:25 +0000 (UTC)
X-FDA: 83920228770.30.04062D3
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5032D20016
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="f xIDwv6";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="I//iNIR+";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+30FsNxlli8PpC3TpepLFbX1IePGlSZR2KUwpff5IU=;
	b=j1ahSrz3W9ImD0bzSgx9DCMVuoP9IgPXWN6gBRafUJIVbY5ubnTTlz6UR3NEZdo6iAxG+Q
	6LfjUzRJclLMQikayjjuERG+axbFf5nwjp1Nky2Pgc5rYEyOq9Po6YVjzfee0KxQSFzPsE
	UfSXKzDAIyMoieYGTjalLb2ZXi+uaAU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625403; a=rsa-sha256;
	cv=none;
	b=jGa0BV89gUlCdsJdCoDKCajLQUEZS9JhO80xiyLLIWw2ISA6nItBHoKiCnPPuWk4enHH42
	Kw7slctBB39GoEdcb+ebPLcDiIBtFdg8wtfPMfcGKv7crapHWYhRw5+vcPENzGxU2Gy83y
	WOJ2k2h/FFyN2lP+a7awPdC8PMFSPFw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="f xIDwv6";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="I//iNIR+";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A4A551400065;
	Tue, 23 Sep 2025 07:03:22 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 23 Sep 2025 07:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625402; x=
	1758711802; bh=l+30FsNxlli8PpC3TpepLFbX1IePGlSZR2KUwpff5IU=; b=f
	xIDwv6Nw4l1i4iTtFMICkXa78Jm5zksgps7DQdUgDIPo5eTMQqU9njEZ9XF6Bg4m
	FM/TGuKU8UQdvip7vxG43or1wsjsA1SubWgf33EyJBU6CK8XAfDfsi8jjJvx0eeP
	joIojexJ0zE7/K/5ZHLuh+XNYA/yFxsG6X/r9ppf7OHdl2gAWRVPcngV4xgg+/RW
	D2ypxesd6iMcTTtihjMZy/mOIr8pCn2GKKM/2mlR7Q3FUr4KPNTODNqcR6gBhO6A
	XRoc1mbLXIHqFeOhHBcQu2QgA55sTIdgcPxqR4PdiCB208tKzfK34ofjXj3FXq46
	/AcOJ632kvY7wI40P1nMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625402; x=1758711802; bh=l
	+30FsNxlli8PpC3TpepLFbX1IePGlSZR2KUwpff5IU=; b=I//iNIR+jivZO6pAj
	7qpoyTpnVPMx0lJKVOtzBIMdyHPNoyaW/LnJxPgtCFlZfszbAnmybSLIyWkrWi5l
	L3w//lhrF7bf7mQ7yV9gM4cp7BQwzzjotYKrFRCMlPLBivtykk3V47f82kPv34+1
	iaYXjOb6rOxV+uZZo/bqBgwGq/7g7ZlcVc8W+vfDavEnPsdu4vutcA0v8Pw/cjys
	UtFmFHwRO/z9zhF0LjwIxY3oxmd/kQDvZmqm2pm6DuWahTEbmSfwvPXD5ELugbW0
	ddtgnSLFDuVkNiwpgrJZY48U2QNHrpLKc+JX/1WF8ETiLiqW0EQBQP1fAb8ofC/g
	EhaaQ==
X-ME-Sender: <xms:en7SaP0FTkp-jKXIe6kT-5MyVDr56eJOMoYeM-VpXTJ_8v4Fl_6KpQ>
    <xme:en7SaKCZGvE7wknVZD4vjgQDq1GZJr5KVJLxb_R4w93xEDhU-xbANBvrM9vdzncGb
    XA5uuGClSkdBVSML5uWZYAeiLthVbNxUeanVaSldNcQCUA6W_Kx6pI>
X-ME-Received: <xmr:en7SaGDFurBr04QEb1BbdEfwmyoOAJV8GJdHwT10WqUFSJfQSDL2G9COnL84fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:en7SaLMiAGSv_ZuZVagUgM8NjQf2LLTJTYtj6Tq8FCmC3JjTxv33fw>
    <xmx:en7SaANL__ZE6lXNAVhwCTTerOtRMvjEFkkDTwzK8pDdhvSRxoid4g>
    <xmx:en7SaPs9BObgs5sLKfzIhvDIOIlqWTy96RPzcrj_Xc6TkE9LqecB_Q>
    <xmx:en7SaF8FgdeDyjw32BsXuGDaK9BgRY11BOo8IZGosg7Z208qdgr3Bg>
    <xmx:en7SaF4okFz25XVvchBB88jptyraGH9IIwrQL4DBAzPdSNZ8ZlR1Aq8o>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:03:22 -0400 (EDT)
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
Subject: [PATCHv3 3/5] mm/fault: Try to map the entire file folio in finish_fault()
Date: Tue, 23 Sep 2025 12:03:08 +0100
Message-ID: <20250923110310.689126-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110310.689126-1-kirill@shutemov.name>
References: <20250923110310.689126-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bt6nqe43n3u57tg1t514sc76emhg8and
X-Rspamd-Queue-Id: 5032D20016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758625403-88572
X-HE-Meta: U2FsdGVkX1/dZpsJ2rrVhhzQk7DJ4by9sHnyd8+aFKeNYpVnrSmhvNxI8AOD75da83ZXn45Cd2I1xoKAhUuUm5EjN/Jc9sE1+/c2WlFiSm/jQM3MKECDycNOIYuGYxHfM/lPCON1lbTrv0TO386Q3vKnj97V7oADvtIP16hW3UfS9DjyicXRxZBru64G9IQ2W2trUnDwOAtzdTcP1p7OVog2tid2JiZSunKqCjUyEyuXwiiv1dOJUJBFMJl7tukc6pUNF7lYAcbkOVoajuCdoe9SUfLYTbO52g5xz4+Is8UOEbi4QZm+GYyK9Z2MFsD4T7yJt0on1Xq2eH3xpbmCRn/Wgu4z6Zce4+RQhRlFK1h76mKhe9tTYAj4jfLnx2r1cU4wHCiHlxdnY8xo2NoShHLTzGyipv6mDuD1T6cLlAWASP+abfjG6jxOXo9YM55COovP8L86YTYrUTanJX07azpfQvmlpgUPkXiXN+kyFV9giKUo0jG32sDpYxOh3UKznxqSoPO4/htKtoo+NBJSyQKTPzNQHa1hBuuoSHcAgR2XNRhcic43BvZmlxqfzyR0jo2XSbYFlmyGtfoiLEXg5AGy7SUJBlzwkBiOH28NwOp042q4WN1gqqCHjIalbvblaPmhOYK+1F+6r6//GG5D1ft0BgGsQiiC9L3H1sH8lg/oKw0Wvg8j6rUC/yEQWIwYD6HBEnJfWIGmfCE2RP0aShHcSV4/RpK9yuwLKKK/ixccbg2mx+1cH8knhLcBryxgH4yu7xOdvJl5mi4+RcNZyUYw18OvbcDoPUrz+k+vd06t/ILZhStON/KT6Bj5D9vwIA0rLQYYm6k22DXPNzhJL4Xyb00R+pV1U2/kOgy+9R6v/1Xqq74XAIr9IZ6tQd4VlglSNDaStRYmJ8vv0hvxd5weq5ounl94++PuaNquJeU30k7rK1QSt5rZfsj2eOq/yr2LU/fdiGg3eDgxuz4
 nBZ3YWVv
 PBqP9IdWH5aKyUkntW5KHA/34xZfafKk4Mfb+nBi4+JK6fzDfhujzSqUmlGSixLGW/SBqysbsMrRq1fq3kBr1RA2nf3L/KOvWtKIEoV335Oe/I1ajZgIot41fCgrqXIX3HLYpnWwC52nE5o8DJvi5B4pZbhLRmpyxltIiRDeMgwJoyZgClI8l9ADDTtpXAFcixrAiLnb7+ZwQBa3ld51HpEpR4oLCTQrb9tu1bfX80s1CCVLM8V5iGnsKHMcApNnfV00hkUiVt2iiC1wzE1BxSIqwRySEdtn6kvw3EOfPVvgxSK/j1yYNTlBTKBQO01o8lYPZ839UmsBGTGJzndjk0TPJNiER1fd4wUSvKNFI7O3eAIE9DlHWkNCHWCquAiwj49rNfTNa33v5XU4gZc0os0atTA==
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


