Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440ACCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9C48E0220; Fri, 15 Aug 2025 19:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF57D8E020B; Fri, 15 Aug 2025 19:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96008E0220; Fri, 15 Aug 2025 19:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0988E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:39:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A1EA136BF7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:39:59 +0000 (UTC)
X-FDA: 83780612118.17.C6075C4
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A673C0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:39:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="a QISgYR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ToTlhkBk;
	spf=pass (imf28.hostedemail.com: domain of boris@bur.io designates 103.168.172.148 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755301197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NO/jJ6ZiW1tdMPtN/CCN4imJC1OmTM+b3Sd0mX3qBPI=;
	b=BWkYMMkMeMLN9MCDKk2LwEZf2DNhbTVGBjEH6arsJPf3fONFV5Ig/fefyF0twaz/w5zoSI
	ACX3tPN+OoE9i2Tp8ROJjz26nQgCKfpU53+XpY0XXBwitQqmafn3xOA8sDp6+jbQjpFHWa
	58Qe34m/QzrX1BBcJxbPX39QUT1nWLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755301197; a=rsa-sha256;
	cv=none;
	b=gC1p5HJdhSGlzULpmyG17SnAbIGahLKZP3gQ9mzv9cSzTbU49QWso25VKp+QiU9owm8Aj1
	zadqMAU9aGwc70UYqHDWumhTelfWlnc0GpI46aW9xrkvrGQQ/gnl1Aq7L02TZ9bVgtLO71
	mVFs+HAUiDeVx84JEhCo9qS2sQbO7I0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="a QISgYR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ToTlhkBk;
	spf=pass (imf28.hostedemail.com: domain of boris@bur.io designates 103.168.172.148 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id DAB19EC0108;
	Fri, 15 Aug 2025 19:39:56 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 15 Aug 2025 19:39:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755301196; x=
	1755387596; bh=NO/jJ6ZiW1tdMPtN/CCN4imJC1OmTM+b3Sd0mX3qBPI=; b=a
	QISgYRG0CG6MRoaLui2JOBi6iUXRe9PcD2s/c24purhDwSqhgHBnzQt4ygpI8PcZ
	x8tlWYDANzZ/5t3O+5HlLqyqcq4VC69/K0tC4CYU8QPOSlo6xmXLMwEcGL1uPgJr
	YcL9PlrGAg5icLVFz3NY+mEmcARWllqfkfXLMnU4HHURatHCD7RtugdDhrWOtyRs
	EDa2h1w5Otp+X6P+YiiQ7qJfDWlBVLN4x4Ph3gQ69fWyBA6Z6hi4dgVDFidXr+Hg
	ypYgAxAIhWvIbjKBuOEMOFnghgVTcVwq5EOOGTM/LTVKXoifYH5AKj/cx4THfNjp
	5Gy3UHi5zYDZxp1Yv7Xvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755301196; x=1755387596; bh=N
	O/jJ6ZiW1tdMPtN/CCN4imJC1OmTM+b3Sd0mX3qBPI=; b=ToTlhkBkmy/JsKMV3
	Ki0fZkBHCBkrTvXIWRaZiHyGnfrrNopCkOqLumUnfSfz7Vt1c5Js9huzEH48l6Hf
	3otz7xyujcL3nfqijs622B8U8VI/rV9DIdgkcKiYkB9twVPuBHUePOEWKwhB/qjV
	VW/8wKw/6GW6iLE4qPAKTid/roSPyG3y6jEIiY1yUwzD+59pwN289WLh4xg6avWy
	IXRhVJi0l0uzBVIPNTgoaUIs7kkq4WPJ5FRIjL1nVfnKNVVLjZflpfsj5jH72uV0
	SP16OkdtbT3jOP83G5qDu6KpJJd7XzyozUgbwzmFJCLsggR27djnvfRT2NvJ6bK2
	lr5vg==
X-ME-Sender: <xms:TMWfaOLQR28UXLEfZsB1F6AcvIvs5K8ahyXIrPVIZ0qu6ZCr_duX9Q>
    <xme:TMWfaJ_QS7s7fns5yxTqo2jsDvOJakvbYEM9jH7ZZsfAMp4u1lT9I04f1wo7VQbsp
    yVBFTSy_R_-IIB6yxQ>
X-ME-Received: <xmr:TMWfaHwNmGOdK_lx5TGQ-VOnF7nw5JqYLjtqli8KszWoSIVeNnEsVqUUOhmags7GpOSy0jDN6-7jnYxRIukXrWL-hgo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugeehfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepgedute
    ffveeileetueejheevveeugfdttddvgfeijefhjeetjeduffehkeelkeehnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheplhhinhhugidqfhhs
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlh
    dqthgvrghmsehfsgdrtghomhdprhgtphhtthhopehshhgrkhgvvghlrdgsuhhttheslhhi
    nhhugidruggvvhdprhgtphhtthhopeifqhhusehsuhhsvgdrtghomhdprhgtphhtthhope
    ifihhllhihsehinhhfrhgruggvrggurdhorhhg
X-ME-Proxy: <xmx:TMWfaG6BBW4eDY-wFu89FPYi0J4dlo10_lM9LvmmAj1salr0rmRJeg>
    <xmx:TMWfaO_qcQ7rUoPfDrNL02gu8Ha0SH0gxoXSsws5_qt1wADeyKHexw>
    <xmx:TMWfaLp_dOlHc2Yd8SdVImZ_Nyz6xtdCSkadK5PXS0CsrBoQSFfyQg>
    <xmx:TMWfaPqbvJGk3h9l9LJcr1IDO77ghiOfOsM2kCD2m4Vnlmayq-1LTw>
    <xmx:TMWfaE4wM1V1wfLsyKPSNJiRv4YQ1YQO72lSrH7gqzOYS8qezBjWH9Ps>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 Aug 2025 19:39:56 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org
Subject: [PATCH v2 2/3] mm: add vmstat for cgroup uncharged pages
Date: Fri, 15 Aug 2025 16:40:32 -0700
Message-ID: <a0b3856a4f86bcd684c715469c8a1cb2000bcbe2.1755300815.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755300815.git.boris@bur.io>
References: <cover.1755300815.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A673C0007
X-Stat-Signature: c1j3e6wqy3ga1g8ni35sqshn3h1jar4j
X-Rspam-User: 
X-HE-Tag: 1755301197-939206
X-HE-Meta: U2FsdGVkX1+kXsKWgX51UdPxRGdYDFoj/v9LAUEW6sGNqB0+FfdtLuJscOVRRA3yIEKzvBGVLshWgeHS1PEhlwaNdgspanzg6LGGg40w+xmOmzdOOphYUV7h2tjdIIsuHdvl8e6jFHUGmGO+AS57l5aK8v5ffMNFK66LA8l+Jj2AOuHGm1w+iZlc5tYZECJHcurEreyDfWS5c5y2LtkIVgV3TkGCO14GJHF3Mt2S4fZapWm8tvW0p0iVElDr6K9PuNhnsSyRG+cfxbQ69PzgxFZcb3YNN6dpg0NiqHa3LKX1vG8DhWOzG0Q8T0pL2RY0TI5+bG/zAI31fWeU9pfDWCUGUem/kGL+evo5zQKxG6Wwkbc9OY69iwBodazWOzWNXIdC4ovklzZ8exe6VaZmAeuCWpXcEHG+CA6myl5YXyhrW2gLfhWP2iT8UWZ7aTtol/m+34scC42H7Tgu2LbppDboKXPAdWSrSHUSnLj6oG4p9ss0xUJFMS/pQEAqMCXSzywGPGBUvUqMz9hfMZnsnvoju3gdd3ljpuzF46O5IllLI+/uNtnQiYiSXlzaK0ENlbI2f3Ct1MEgeIiieLxjgDrgLrKTstafha6Uh6eXNkEV+9tW3q5v+HJBjwpBhLAVK8DU291hTnE0u+yYrl/2SjtKheAH2CRz8oxXqGeMlpSkuaHpv41x6ndawsEhjTupZBfuVm5wCagl4TOSvYTnVMgIOiBZOgWl5Q0zkoplIQbLJVIf7TPYSM1VgxzWUfe41J5wKDJaEhS/uR5ncBNCUDi2W10V9Ygv6t5wuA2q3JEgOzWyCvWPiXZOyNly02n3SvaR6q+3dU1TKek4N6QIHSv65M+u6imct9WIQwlk5L5YGlqIQRdosNkXCK4iUwB0mBjgoEZLrVEt9HKKe1vIGXYF78pqluDceywiP78T/jlZb1H9f74wnv850IDdgAaPeJD6ZyFPMAGZgyE+xvB
 IlQH7P0G
 vxJs6AmJtYffuXU/Q/Q29mZn6nW4y+WzdTfiWPZvda+cedh0NDfofQ1MWCGI7A/S7cGDo2j0uGDaYZ8xGLliMDDRr1iNAlmz8ANAk417tn5AUmtjkcNqYeqkYTV9PsrEHg61CY+Aj4KqWiXV9JttDuF9WBpOid1SPZf0IJcHdD9P6f8hwIcH/q5OuVsIUqRcL1DOmsn/hU6T13+hqoifasrkxDqfcvfwbD8GW7l52/W/63EW+ybRfdlbmaPDY1ZrXb2/PITGLyW1Z+uM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Uncharged pages are tricky to track by their essential "uncharged"
nature. To maintain good accounting, introduce a vmstat counter tracking
all uncharged pages. Since this is only meaningful when cgroups are
configured, only expose the counter when CONFIG_MEMCG is set.

Confirmed that these work as expected at a high level by mounting a
btrfs using AS_UNCHARGED for metadata pages, and seeing the counter rise
with fs usage then go back to a minimal level after drop_caches and
finally down to 0 after unmounting the fs.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/mmzone.h |  3 +++
 mm/filemap.c           | 17 +++++++++++++++++
 mm/vmstat.c            |  3 +++
 3 files changed, 23 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0c5da9141983..f6d885c97e99 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -245,6 +245,9 @@ enum node_stat_item {
 	NR_HUGETLB,
 #endif
 	NR_BALLOON_PAGES,
+#ifdef CONFIG_MEMCG
+	NR_UNCHARGED_FILE_PAGES,
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 6046e7f27709..cd5af44a838c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -146,6 +146,19 @@ static void page_cache_delete(struct address_space *mapping,
 	mapping->nrpages -= nr;
 }
 
+#ifdef CONFIG_MEMCG
+static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
+{
+	long nr = folio_nr_pages(folio) * sign;
+
+	lruvec_stat_mod_folio(folio, NR_UNCHARGED_FILE_PAGES, nr);
+}
+#else
+static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
+{
+}
+#endif
+
 static void filemap_unaccount_folio(struct address_space *mapping,
 		struct folio *folio)
 {
@@ -190,6 +203,8 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
+	if (test_bit(AS_UNCHARGED, &folio->mapping->flags))
+		filemap_mod_uncharged_vmstat(folio, -1);
 
 	/*
 	 * At this point folio must be either written or cleaned by
@@ -987,6 +1002,8 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		if (!(gfp & __GFP_WRITE) && shadow)
 			workingset_refault(folio, shadow);
 		folio_add_lru(folio);
+		if (!charge_mem_cgroup)
+			filemap_mod_uncharged_vmstat(folio, 1);
 	}
 	return ret;
 }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 71cd1ceba191..c8c8b5831f2d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1289,6 +1289,9 @@ const char * const vmstat_text[] = {
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
+#ifdef CONFIG_MEMCG
+	[I(NR_UNCHARGED_FILE_PAGES)]		= "nr_uncharged_file_pages",
+#endif
 #undef I
 
 	/* system-wide enum vm_stat_item counters */
-- 
2.50.1


