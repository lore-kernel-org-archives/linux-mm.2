Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4345DC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DAA26B0095; Tue, 15 Sep 2026 08:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B086B0096; Tue, 15 Sep 2026 08:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A4B6B0098; Tue, 15 Sep 2026 08:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18FC76B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:54:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABFB6A4DDC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:54:13 +0000 (UTC)
X-FDA: 85215989586.26.C9C46CC
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00597100006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:54:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QY0GrUg+;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txqh/4dMVNkv3jAnEFkWYzpJcEFlwoVpdz1x6TA4rUQ=;
	b=lNOqRx6lVSumPIU8FbpDZlXqtu34mn+RU41oXpiZoSfBkENDAji+YFfZeCiXslUQXuxWFh
	ebr/G9aiEZrTvaeAEDZlCG5fS4kEaNty02912xnR1EX5xR1asXn6JdYcRoXkc2LH6NovfP
	HUL87CEAydednYl9lCpR4do5KSVCdtY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QY0GrUg+;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476852;
	b=41cJxSl9pKW3yq4sFEZltB5eyFHoFPOVI3pW2rCuto/CxBVU0hVOqlr2H7zhxRuyMe3d3y
	eO3/7/7t6goNhqCQgfntgSkZXz5S6nqrlGa8xAyh6z5XpvtqYvEmMGF10im0PffIWUcwX7
	mUvPPpTgAvV+bv9K7kP/KxpZlhENkdM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=txqh/4dMVNkv3jAnEFkWYzpJcEFlwoVpdz1x6TA4rUQ=; b=QY0GrUg+hg2FpxWgJ8xxZXb26i
	a40KcG1CY1FLiZgOkpyJzp7DOw1gx1xQpWXRtn5i+i0aRmh548I+laXxHuxipkTKTvSiRNGRa5cCa
	15eEcGqTe1tBJvKRukwl9HWsRnOCulnpK4y+qO0fhIOzcDFrlMZl+0CfRcEvuSOcPBgro4LJ8Yp5T
	+W95tZNqEZYj0PJvLqiJ78uIB6UGaw0dgkHbkpn2unqZVyAM2xLbbEbzam7ULQANjEZAiAHBDlgK7
	ZG96j8aQrDleLqQAt/XRd2xXSUxwLy+Qib1h43v3kLn4zpG6CtscsiWn1xAmBwv68+/Wm51M3Kvks
	hdLJbdeA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sfl-004P5U-0I;
	Tue, 15 Sep 2026 12:54:05 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:35 -0700
Subject: [PATCH v5 1/9] mm/page_alloc: factor out the accept-and-free tail
 of __free_pages_core()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-1-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=2075; i=leitao@debian.org;
 h=from:subject:message-id; bh=QndDTWh5bGLYFpgTzNsBMcjtlSoq6B2ZnR6/EP1pCQo=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/e/q5/cYr405F2RzQcKhfWFrisnYG55iAgq
 UvT/67s8SiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bceTEACgTXdW1ZYLhwiIgzpNy3/tIJlO0t6mQw1xMfw4l9nQV4a9dvbY/XfEh5CoXZ1SxwevYyr
 jYhT3krAmc4hkLt0U0WC3K64jg+VIQ1OpVudj7jjOnaFTFoQCk+Wco/JApTvPg0TXGejrmXZnAA
 7bmbJKaGYUBr0k+GH132hy4tzAGPNsbMghbh0+ZOx+CUZOLCAJ1OW+tW8seGCZ1H1iOZb33i/cN
 yfqd5+3JA5PFya4Rq4iDZ+h+fhXelxujWlvkWhenA1TReHsfprrwXMK5NAlwxaOUqqy2mhKpzfd
 WWyC+BjxTCT1RAF47MCnkAAi3/QAS8UDySy7+N26+WFvGImkuhmkRHw+Fb+yqxmn9erNjh6i2Da
 pkX0o7jatRDIeeA0Tc6nEDsHerPH/Ao+Ph2vjQVWkC42Hy0Criep/Mi5EcLHD16RcBqgbyGCVHZ
 Zmh4ahHaN07+XvCyatxhM9P3MiIQK+etSZDTegputerYeHbzVpCcMCTOkBz2i3R7GmpRoq/7IGf
 u3uZYqGtBbqF5p5463cbsewXIL75U79WBO5rTMPMvegvHF85MkpAbTtQK5N/RZckds3O02TLBIY
 ttKp3I2XptzsAjyHnmWewT1GB5fAUo2ahpu2ryFEAHzvDUf6GoZMUUMxTP39H4en8Sr4iglVSmT
 l5jNgyb+RfmoLoQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00597100006
X-Stat-Signature: t8ybmnroermidpcn8x5fbgbxxb4o66u3
X-Rspam-User: 
X-HE-Tag: 1789476851-249332
X-HE-Meta: U2FsdGVkX19ic/X25/f6E6fYeehxd2lnqAQVqHqReBU0sGGfpb5/mf6Vj8QA2vBB9ne0t8oQ/gxmfgWCV9x1CgndtpDXcdDqsQoAircNO7ONh0+MahNnuNjP5zHdIPhqBBrm1rvaXXcreE24g2PAGp+B9I4EEKahchheYWZysNQkIvCK8n5jom33GG26MXdfkSIUQp++w7uwa5ssddzYIYg8Y4nZLMD7+95vW3IygjQsAaNvViAgPpMDafjTx+3wmwN1S0tSSAR54d92bjC4tMsAThowGk9cv7uRn/XUf6Tn9wzn/PE59q/2/PAlv+WWbOl2A5+ADt100675IrC2Yj3nfuND2sNGvwJdn7AhhfjIL2S64+nj6P8VYR6JYku6Wjt697MW+ZgIZoVUMkYaDtQKEOxijt3BaH76sdJ6sivJ+bCEguIqHQtSkjRDZ+8oDcw0ik/qsqzoNqniut7WOOy0iv1FYzuqt/wGfyKFsduSssu6QFG0w1inpspKk8jrhUgcPewHnW7k9n40UBXer9ebemE1hHt6U9eoMW14o9NnZ0BN9krAal2S6aypotNdF44EQMCoSBL6qjoHBdVOAopDAC/bkFo0zJNlxNJcWtJjNs+c9PBoqwd22NMRBL/HaDwFQbf1P9Z5D8Hl87CBnMGyU15/TWltJhkGp4I0OeBVh0wziKAetqC00X5AhbQZt2pOAsEznIkz5tMRPpc0nr0vIATt2JIYJpMSdN4jRVsWQmSJzk5KVN6umwFza91pTieK8vPoMaGl8sGebz1nhVHjvydt8gMYpZ802+S6yTTmq2T3PqHNTqA/JQwIZMfMpYrK1AC74j6B7Em+Zvc05iT9YbEcNNk2Hmo1Scq7QOMvQEKmCeIO/hMdlJ9KhLNoBH/iKGPJncP77saAOLQ/6vXctjDUXv5fInyxIi8oQrFCNyQg0qe3WogjaQzo+m8JS6taTfrV39c8naTPcyD
 HwVgKYo+
 +Ucz5B/tvRjKE9dS9m39wz7TFZrLZ62a/EMYSHwMmSYYU9N8y6jINbNO3LKlrif4vkT5fZfh5xkDidntvOxhKT5twYMI7cRqEKaYTA2sHkzm6uCqpSNSqQobfNQZZqZheqlX0WKC6oGhiHxbuyDpNHLREzHvjhaFu9MnOAA0kT3olZUJlK01MBrvxOCiGkFLZ6e3NGt87bD6CqiKn3S0Ziu3u4TTVaXkQxZK3rNzexopa0HwdsO9IgBjZMXBioJocDxAen+HhrH6F3sbplolJ5vd9GiHcp0vtdH2b8YbOim+/4Sz56q8bPJblaEefMRh0/SK6PjCpD6vLsWj5ICOavmEH9w600YQylwAg+vRd05mDrQAUkWtMkdvKDRbhmQgJNE+JTs8nU4YZHs2/XXLrkbWwzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__free_pages_core() ends by accepting the block if it is still
unaccepted and then handing it to the allocator. The poisoned-memory
replay later in this series needs that same tail for the parts of a
block it does not withhold.

Move it into accept_and_free_block(). This will be used later, when
we need to accept and free a subset of a order-block that is
not-poisioned.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/page_alloc.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 404896b53003ef..b07b5f4751cb95 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1579,6 +1579,24 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 		free_one_page(zone, page, pfn, order, fpi_flags);
 }
 
+/* Accept the block if it needs it, then hand it to the allocator. */
+static void __meminit accept_and_free_block(struct page *page,
+					    unsigned int order)
+{
+	if (page_contains_unaccepted(page, order)) {
+		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
+			return;
+
+		accept_memory(page_to_phys(page), PAGE_SIZE << order);
+	}
+
+	/*
+	 * Bypass PCP and place fresh pages right to the tail, primarily
+	 * relevant for memory onlining.
+	 */
+	__free_pages_ok(page, order, FPI_TO_TAIL);
+}
+
 void __meminit __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context)
 {
@@ -1613,18 +1631,7 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
-	if (page_contains_unaccepted(page, order)) {
-		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
-			return;
-
-		accept_memory(page_to_phys(page), PAGE_SIZE << order);
-	}
-
-	/*
-	 * Bypass PCP and place fresh pages right to the tail, primarily
-	 * relevant for memory onlining.
-	 */
-	__free_pages_ok(page, order, FPI_TO_TAIL);
+	accept_and_free_block(page, order);
 }
 
 /*

-- 
2.53.0-Meta


