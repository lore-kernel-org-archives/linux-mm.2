Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A65D2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54126B031C; Mon, 19 Jan 2026 18:02:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14516B031E; Mon, 19 Jan 2026 18:02:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9548F6B031F; Mon, 19 Jan 2026 18:02:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 825286B031C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:02:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F9F6139983
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:54 +0000 (UTC)
X-FDA: 84350240268.21.AA699E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 477004000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HvOvpttf;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rm7tnLSr2BiP2RY9L0NausdLTDHloCsMvtehZeF/Cwo=;
	b=jC2JNDcouz0DT0RDBaTPWbMGkXjgWGoS0CllsamQYjFe7+nDIocOGwzEH1aABEbxiphsZ2
	lpREfd1AFQtoJ69PKeNwwBjGNwX2viPtExzVqxzkwTuRO69IcQhKbOwIb9bLOaPfCS8Fhy
	ASt3UNiqvvL34GKHkozNmt/2NacCmoo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HvOvpttf;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863772; a=rsa-sha256;
	cv=none;
	b=6zBxMB+63UZYQmgYwoi+QZXXbVgp48owxBg0R4YF0tIBxfLM/Fn1W4ELmbPHmvH1DS4dYw
	9DIfvicmqEzMq7pcFXRW1JjavBlBMYIv4jOujZ59MfGC3Qpk7OLFE5pETUHmI0ouF8Si9W
	ye0Hki0zQshO3nX5X2C7LQZ1Wrbv+BM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FB254075C;
	Mon, 19 Jan 2026 23:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84FCC116C6;
	Mon, 19 Jan 2026 23:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863771;
	bh=L0GQNAdOR/JPbtfKkp93QvUS5ciLoWv5t16Us2SfM7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvOvpttf1kAvLfqKLjmfytunK2LOvgBgWZQy98vpmZf7M69HJPyEbpN59hjBYAgAN
	 5IC6xIovQKda6++cNe2jxPvRgCcQJ+i8VziIHmD+7tQWhJ500BB/Szo1tx1O6Niu0y
	 Qi5Ch2QWUIG2rXheRPalPAahZeIRoYRBP8prE05DO0S7M7eTw7FTcTH84epyfKTlhG
	 dAy/nCWJ9Xevj+prD5Id4gP3Bda+nuYUvOyk7JlBtw/QY79TkePDV3UN9A2wMPFxQy
	 XKgu9yINJPlolyHER1O5vx7qk05ZEiAOV+fLo5L70CTssW7IxUYcfiSq9tAC06TS5H
	 00IZRTVLUlvPA==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 10/24] mm/balloon_compaction: make balloon_mops static
Date: Tue, 20 Jan 2026 00:01:18 +0100
Message-ID: <20260119230133.3551867-11-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p3jz3k7asbo6pix5trec73hh6xtcef6u
X-Rspamd-Queue-Id: 477004000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768863772-322147
X-HE-Meta: U2FsdGVkX19zkDjA9G+k1H/Qjw9XwrZEG2YhMW9IpKiSRTU5Y17A+VxAKsjZ8l63bnDdjrJYELWDSKEJMqMMVS4+zikN6cdrbNPxIsPMfG/WJZrEMSC03jbI/OBnM7iF3hoP20oK4ONgOd647/hnytWbh65HB5FDnKsqFToij598sG3kW6QUdn132Lw2ggkQCdFyb35/aDC1iOWpOHtd4g9G2F3yi215R9I0ouJYIVHHUQvbtRl7RZIQY4hS65M+C+bzvUHWxBrnnWQG4GFJ07fHeEYJ5eJCiulJTrcaKBD766FjiqKq977ZBKYhYADv7UCweX0yUk4S7nA4/nKuYioSJ4OzAOEQzLRTxEEwXZkxjGZdWVJaJ7tbg8X+e+RIbaY883ms6gd1OP3PBzgogNrH1vqQAOlB4oMhOfhcal99Uy/3HaOQoElY/mOmNGyIEbxEglZKY5qELUXcSs82L87xlyON12jRhW6TTPBqV7wB9WyzVLWfsBvKCHcfHuNulotdfW0JlC4eIvFjizSOrgnCHRu6wdcgA9udm9I8jeMNlO8/eBQenQpDrU2F98jCrk1zCpArLouU4715uA9Jwf+a2oST7oRnQBu2Znd5uphLS0h3kNto5HUHZBMxakSHoKscayLVSshyrSPvudRk4o6f23sj1wJIeG33sYBZAnJECIoYF7qlDGTRiDeMPbaV4Ex9GHRB5eVyECzqOKIjdgNzg8Ml9WOf/BAVzo5ZTJCZoXCNx2dDiGYEgXgHnI7NmFhJFMXSg6OZBmMkVBI6a78Y3fwCk9CJVYctZQcsd13PH6MY8KH0ovZuat3jAemZxjXQgBJrnfzUko0Bnv9AgXBeoP9mrnAiQqwN3WgyK8xssPlX1Rp00jV28evCqTOO0HA9AIyCINQBTv3KSvBOi4R65Xa5Ff2KcZS0KA7b0qa86si8fVcy022FvkkjsGe65BzJOgUgWa9S1OGraIB
 Oj9O0EwN
 kXHgc5C9vwKYZL571DDjO1n0fPuesatE/ni47UvHFogn5TMVQXM9SvrYw0E5NoOktKJBQgv7DXHWfXswcuqu+/a9pgOWyPU4CWq8UV0EZ1UIADSePevbuaKSVbPVMg/IZ53LHh6MHLk2gOMw5/xma5ht8FSOsi9Hzv7lfw48ueC/vdkL+ZXty+NE+SCFyvB7OhP3xy+eE2K9idm30I+heWg4QRUC5WCsR1wFIYUj8JgqW/uaZLseucMkSmt/VcATHrRM3Fe1pQ20aIn+82l5XbRVj2Y5iCrYTJ08nfKYzLLLBCmso/XVhahuYpebfdNxkkUOc1DQ52HZ2zaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no need to expose this anymore, so let's just make it static.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 1 -
 mm/balloon_compaction.c            | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index ad594af6ed100..7db66c2c86cdc 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -78,7 +78,6 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 }
 
 #ifdef CONFIG_BALLOON_COMPACTION
-extern const struct movable_operations balloon_mops;
 /*
  * balloon_page_device - get the b_dev_info descriptor for the balloon device
  *			 that enqueues the given page.
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 75763c73dbd52..cf4d931763920 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -288,7 +288,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	return 0;
 }
 
-const struct movable_operations balloon_mops = {
+static const struct movable_operations balloon_mops = {
 	.migrate_page = balloon_page_migrate,
 	.isolate_page = balloon_page_isolate,
 	.putback_page = balloon_page_putback,
-- 
2.52.0


