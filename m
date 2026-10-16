Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AA1CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5263F6B009F; Fri, 16 Oct 2026 08:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504CA6B00A0; Fri, 16 Oct 2026 08:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4148C6B00A2; Fri, 16 Oct 2026 08:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 174996B009F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:17:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95E3C14039A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:17:03 +0000 (UTC)
X-FDA: 85328388726.16.561DC0A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id E4BD01C0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:17:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=P+m4W8Pk;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792153021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxZBoPVq89DlzEuXI3J15DiLUSM8TLChgH6sUBQbat0=;
	b=Hn+IwAb/6nhH1onf0YrjzdIURxy5+CGTwGgA/FmaEcsi/DY1plCNPAuA9KE17ekmUUXl5E
	iba6QjvS9ZxKZtPMYebH+V6ukr3TYzRSOmSP+tBmhaej7Dnx+SgdKxM65yC3ocfUIRv1iz
	in+o4BJwS2/7dr5G9un2s0eD9ExP+sE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=P+m4W8Pk;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792153021;
	b=8Q25d9D+6Wiuex3VJtP61vr5yLdDmQBtabz+x0JX8wIXeXwRxdfmC8QeiPwawZ1Emn+Jgy
	S7iqQSCGdTE13VAEJfeTKEqr7iNQ7nqxurtYyDXs6CiGRFo6JfXYB5jXLbzbf9vbWSR6YV
	vkVhLZGJiu5zLSglwxjz4ECXp45UtxE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=WxZBoPVq89DlzEuXI3J15DiLUSM8TLChgH6sUBQbat0=; b=P+m4W8PkqhARrQ5Brokl80avXA
	84uyde890m+wCCwjwGq0R3LSAoSAAILFQbSR3NX93ZwLKJvzzR5O+0ywfy53kR6V/8uF9L3es4frX
	KCtukA6GfvdcxsV8f0+KnP6EEMd/utle+7sfi+IzenpFbh5P+5JtP0qMKfG73wmE+OXTxNSurAiBu
	zAfK9gqOLyMfe5Ns2kzDh0mfRWpZmKO9fdRux/pJ87OXpwLRAExovKSeRM34ggjVsayuqF+rQ1mAa
	YVUcLsU1z3kTyUuogpMYhgUwhTuAXYjQ/e/H+3qKUqqjoCus8kJFul5iZGh5GpGxF1XBmX/RImuEo
	LZG90Bzw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgrU-005xTu-0O;
	Fri, 16 Oct 2026 12:16:36 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Oct 2026 05:15:45 -0700
Subject: [PATCH v6 5/7] drivers/base/memory: count the poison a block
 already holds when creating it
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-hwpoison-kho-v6-5-f304255147da@debian.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
In-Reply-To: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=2711; i=leitao@debian.org;
 h=from:subject:message-id; bh=Bu/VoZNuiEdhEWGo00Kj5rCUiRZTVHSpLXvx6jo2EaU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV0/dx08nW5bcNGpUjsilj8UAtstZQu4E9fx
 64pXp49b1mJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bZjxEACogEk9bO3cK/jZkbLp0V62/KsgOz02SBwb5bR4Q1zqslmB7ZV+Ye0+X4h2hv93nOg1AZ+
 GmqOFkuuXv2Z64THfDAkVy+4hp+NDhgNZrABLVx9FRMvUj0VqbLzNMJPPuthfKFicEX7mdiGRBX
 WzMdSKrjz6HNxxlMKVnFejtUVrV14u0bbvUGzJGPzhE8FtHWZW5+P8K15Dg6VZWLH/mmwlKALd6
 vDO/r4z1t5hO/AZ9XKC3mXDDubJYi112HNKdbUrV3rlxayVV1q5a0Fk8CNDCXmzIr6sNqJCCI87
 Uv2CPeO0fOaXI9RjKqjxFaRfB8njgaHeUiBaSoKwY9HPressp8iADlgiW4emNdSWloY0F3sKYso
 UBcRwTDn3bXvJYQNLG8iQTnxL/I25Vx0DDHeOf7zDabsXmT1XtkEHwFuaHzIP099QPgUzc8zT9a
 bEkarLJr/TPOEk7KTkIZhwqoLz5B6XA2C83WSNyCa2qF1onO590TRvOuczMOXXDiWwwkBW9xbmW
 7u4Qd1qBdARcWAnFdd0rnu7Ie9Hk6kElo5fpK9/CbKFjjR8ckT+P8r8Zat0Y01fRFk7mRtIRVO/
 L6Znz9VCFGUYJsIt9ZFenxE82EDy5/csFeVMCmLV4T6WbDK/6HONT/h7flHstR45VHE19/R4FBv
 0smWVjFM1HCVK0Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4BD01C0006
X-Rspam-User: 
X-Stat-Signature: g5jm1mb9rtcpysqfu5y9j6ekfwjodjtr
X-HE-Tag: 1792153021-797950
X-HE-Meta: U2FsdGVkX1/9tP+vZo2zcod64ws9Jh6K4qOuZSuRFRJqZZ6/gwOUC728tCbiM2Mp9FhkLYQtUE6p8akxRSarGP6GwIlx/xNdyoJMtjvbeZTPiocDcK4MWwaGuwHBJ7Z007nqp4lvc/6riXhGBfrrS6wTxhuc62NlYAFdlvmWbVAt61zDT2bqur1p2soNB5CRfyotU6q31Vjkf1236h6kDaUr8JxkzTQ44bgOz0fffYiwTqK3JcPVslpPvg1wz5CDHYBUbr7ORsGGviF9LOTWKB1p2GmcigOjK7JogHeMk9HBRcl4unp17567qa432XESc3PrYQ4GEkKApxF7i4ADvdOgIxJwp3wbkZbLYCumUe2K+q8ui2pW0G6WlBLN7FTHw8LSBti4zUk5iBbVZ3VffGtWapXV3mwWXJRohigi8ZJ1DpeoouAuru2JmotGHiEBTPSu/PfqAXyZPx0PssVwxBDkCxwuBC+QlBnv8a6TK3Ecq5YREh1gLkDBkMFvTBO5Jd4QJPlS4ifUBVBUZ44uPDZcjb31TzAqx1Kw6AQm73TfjhSwpoMkkYTpjmeEEnU1cweioEesSvrLCENvR8iQ+ZMquSLYeNZujyeJgELKHPt4KWmMnMzh9jeZzQY6owx3+uFIeyjtOLFa6Q4Lj0fN23JnwLPz4AKIaVZn0vdBVfnMcN0zRRW0ehxkSLG6WxREKcg9llj92TSwXuHjXJXWMLBhIF81AaznKimGOimvqxpMKJITws+lZrJMi1oiKVTI4lMnQfpPKx2kevrT68mnr6uCRx3nzg4NmZ6zXfbb2DKv6ppQpFMHFjNbNj6DJgcpfHuGhhhmXkJ2I9g1uxmueuRuadYrvr1hoME0O5f9CZzrKgAejkkMK3nFSyqX6gaMGN2YtcHDOooN5lOtElbJUmcSfqZcAverB1WkiP4F9MFDoGGnL1RWLog1yFzcohVk5tWuGiD3YaSFJwfIYEv
 X6oONpMV
 MTV3xRv6KKxJ5HzAnCTbfCK5aI+wCHjbY4G/lqTx9h/VgL7MynInuENOk7E+GOsalZuub949RewhINyuviOadvDXA75C3NpsPvEye/U3hPYfEqPclLXxAqGc1ht9pSolGaefDm5bCoDY4fzUMDYbRXq7dum7nv8VgOIsU1ppkbXajbkYJDfHusTx4U+nEvWWP0ee3wODoPQRSxA/Jpaa/OhteNyEvTc3FltxrEfEtSirJ0rQdzEXd+FZSDd5mrgL7Uhs8WGS3EPljppaZN9qwE5hqYfqJ8DGTOix+DmFKHe1xpXC5yICb+8bjGOSQZugn/QVqEkai8vxiYN5A53bl32k0JLNgy4hG3bhfhVzQT6zJO7PXRP5YAI/kaMU7RJdEqLX4UdhyEnMv4w8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A frame flagged poisoned before memory_dev_init() runs cannot be counted
on its memory block. memblk_nr_poison_inc() divides by sections_per_block,
which memory_dev_init() sets, and the block does not exist yet. The block
is then created reading zero, however many of its frames are poisoned.

Until now nothing could poison a frame that early. It becomes possible
once a kernel flags the frames it inherits from the one that kexeced into
it, as it initializes its memmap.

memory_block_online() refuses a block that holds a poisoned frame, and a
counter stuck at zero lets one through.

Count what a block holds when it is created at boot. The walk sits behind
num_poisoned_pages, so a machine with no poison does not pay for it.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/base/memory.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5eead3346f1e32..77481f375c2206 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -220,11 +220,16 @@ int memory_notify(enum memory_block_state state, void *v)
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
 static unsigned long memblk_nr_poison(struct memory_block *mem);
+static void memblk_nr_poison_init(struct memory_block *mem);
 #else
 static inline unsigned long memblk_nr_poison(struct memory_block *mem)
 {
 	return 0;
 }
+
+static inline void memblk_nr_poison_init(struct memory_block *mem)
+{
+}
 #endif
 
 /*
@@ -807,6 +812,7 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
 	mem->state = state;
 	mem->nid = nid;
 	INIT_LIST_HEAD(&mem->group_next);
+	memblk_nr_poison_init(mem);
 
 #ifndef CONFIG_NUMA
 	if (state == MEM_ONLINE)
@@ -1251,4 +1257,28 @@ static unsigned long memblk_nr_poison(struct memory_block *mem)
 {
 	return atomic_long_read(&mem->nr_hwpoison);
 }
+
+/*
+ * Frames poisoned before the block existed were never counted on it. Count
+ * them now, or the first unpoison takes the counter below zero.
+ */
+static void memblk_nr_poison_init(struct memory_block *mem)
+{
+	unsigned long pfn = section_nr_to_pfn(mem->start_section_nr);
+	unsigned long end = pfn + PAGES_PER_SECTION * sections_per_block;
+	unsigned long nr = 0;
+
+	/* A hotplugged block is created before its pages are online. */
+	if (mem->state != MEM_ONLINE || !atomic_long_read(&num_poisoned_pages))
+		return;
+
+	for (; pfn < end; pfn++) {
+		struct page *page = pfn_to_online_page(pfn);
+
+		if (page && PageHWPoison(page))
+			nr++;
+	}
+
+	atomic_long_set(&mem->nr_hwpoison, nr);
+}
 #endif

-- 
2.53.0-Meta


