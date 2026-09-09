Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3397AC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359EE6B00A9; Wed,  9 Sep 2026 09:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332166B00AA; Wed,  9 Sep 2026 09:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E7F6B00AB; Wed,  9 Sep 2026 09:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 040F56B00A9
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:35:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 538431601EF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:40 +0000 (UTC)
X-FDA: 85194321240.04.F902CD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9AD7714000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIGyAPDE;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960938;
	b=jQDDvCTqfW+M8OST2ccODhfI8b/imfcQOqk4NVybxm9pZ3QdRi1B8dXiopdRObXM9fo2ek
	iwVWFFYnb3ttQOv/4zSbMe9aOk/SzGo8eWm8egOdfR7WFnOugaSY2v1ZEJ9HLjkbPp6JcB
	YxVmrUbgtDUGwHb+qoDxq6BqYyO0y6g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIGyAPDE;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1aBakRnV2iGUhIOAlr/N+D/FmN54uy58dpZhC/x4NY=;
	b=3dnOQ21EOiT61WDE2uUu9g2CcPdJxkdXNO9Pepp4pa93VYaSITmmJ1GQxrXNWZfxdUqhCf
	tPb16xhPuh+Jhr/abEe4pNEhHb2ay7Ab7M3dAqe1E7I8VhSKbmg8C+6lfw8tMcUrRhY7bF
	c1lLLLOcQcFGPvrjiP1iJcQgzQedNyI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7DE9423CD;
	Wed,  9 Sep 2026 13:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50331F00A3F;
	Wed,  9 Sep 2026 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960937;
	bh=H1aBakRnV2iGUhIOAlr/N+D/FmN54uy58dpZhC/x4NY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VIGyAPDEKWd20kwvIUqot+xQIE1FKSVvgNyZ/BCaSBYBZ4/l7RmtwfUKsLtebNCZC
	 KUyOuqdC7+6aDRTaV1D3LxHQ9jcb8ulJWjSiHbeVDIaV9LTxKQtl2kvyiCOKuiOd0B
	 Rl5dwNfAArIAw6DLBbH8KfEbMCs1DGQKausO5zq8k/HjKGOfi9RcFBbS5TrbaolCAp
	 bgFnI7XplUYPs4LONuG6s/f7TGDl+N+VbjGs2+CKIMZSFpZ6igjtJ9E7jJs+bJJ+yy
	 PXooZ4itjy+6yrPhTiIiI8A9nIgqzsg18kC/pgJBbg/o6baV8bGpycq2hlzZs2JIsO
	 OMjP5QzdY7mLg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:33:04 +0200
Subject: [PATCH 11/12] fs/proc/page: clarify comment in get_max_dump_pfn()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-11-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=998; i=david@kernel.org;
 h=from:subject:message-id; bh=elFTRUDefqtCYtZsGvjwDH8AmlVM1CM5zJvcDj1v4k4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJphmno7ZtaEjffuh/wH302o/Tb+27Zvs1DvC0Q0q6
 ftjn2RrdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCR6NmMDMtvbK71sotI4+J/
 o3Jcb+/Hh59sA5ctevyKp9qXn6c0LZPhD6fr25qaNd2XSyMTtt5Kf7j1029HxWYPp81f1I45Zey
 8yQwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9AD7714000E
X-Stat-Signature: y9mcjikrnggw15n11jbpwbo43hi9xz9h
X-Rspam-User: 
X-HE-Tag: 1788960938-90680
X-HE-Meta: U2FsdGVkX19iZe+A4NT3+gIO3bXfDY+cDakRk0Z6+7dddP+q7g/ZJryX7uWD5F8qLMU7BZHwIG9kuiyizEu032q6I0JFSlDUswooWEQGjQOQ+pLIOOgaZGrha1HM+Tpx8C4OtvbYalvcvNkN2Arq8rbd9PZhAa0ViIsju7keP8D2HHnu0tdDBAiofoFVG4EcqdYzI8qvJbViOcf4QMcoH+LKIwHAFvkoRtEnnR9WuFJb+T9rZq/y7deb7l+MeSJl+wZ48I1xxeC0zLghRbGol5lvGRVD33WBJl3cBhetrIfS7sDYQnf8K6JS6fvzeMWC96wH2s4UEfodhvTMo6a7RrYYw02iBh8GhfbOwOiTOI5TXSQjolamdxuVYdulzxq//CDhaMr/AhkeLppD6DElcioKvXlrs0vsw/7vxbd8FZOjkLRVBdh8GzqYgfUink2UeJS2Lz7ILk5KTy+5lEX7QSk6E5P7FUuwWHm+RCD68gE+W5pIRa8lWazoIOZBE84yZuF0OxPeVpcUoT/j3gW2ix7AGeez9o6gLNnPRhnUNeh+cM5Mh3Spm4HZlatMguDUlAhye07qDRg/JCe55/DE8+R1YbZ+hTsRwJJqlhmedjSJxifgkRkFxBWS2UKuqA4VsBXxIzDSdXHGJ9L+6icUPcPKi7epXpmdcp4mkJdDSoXii4aas0ZCaFi/5lTAnaHcCS6MVIMA1iHNDVtA7TkV/KaeXpUAwnHUMhDtTve0hh05AIVxBvs7YfmTgMbw5THMdBOS0s17Q7APM3+TSXY7R9mT8R8hS8x6upeqi9BVhKS+/Usvpon1FyjJbCWQY7rEdeaLJ5rAqbifpcXSYQPMqbvWMJs1u5xgRGUndowSR9V2NQIZaVizsP7QvbErN+Cgzv91Xi+Rsna85FC9KgLJiSHv0Txt8b9wsZ7ltn117b34EWaXuPmUL2iD9RWLYY044Rh2O4+4Xv4oE95odV9
 dvM8LhMb
 cPiuZP7fEYxSPpaq/qIItqfDsuu84H8HWWfqttvj94S7u/t0LFSELUTFc2zrxilt00bNwqf9wj/yqJTinpW8mokbXaB9qyHFOZejTVfZf0+tz5KNypgt7cbyXAmy1qxE4FcyfoEcNLxgc/cm5k/CMmudlcjSNxSR6PnqxbIS119Tj7QDWgFjaGnkR5u6hGIK93flxMDvBzJTzKVr+PwtVubhW+Oa8P1/pnR8c8beJVSzWXJNmcMxaxLFgiyEtg0u9fOr5h7GOkajXEi3Qe+Uy6o/XBgCQBjTS+aNuQggWwfZN+HE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pfn_to_online_page() will only succeed on some PFNs within the same
section, not necessarily all. Let's make that clearer.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/page.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 260772b20bd99..6856ff3e3cf28 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -31,10 +31,9 @@ static inline unsigned long get_max_dump_pfn(void)
 {
 #ifdef CONFIG_SPARSEMEM
 	/*
-	 * The memmap of early sections is completely populated and marked
-	 * online even if max_pfn does not fall on a section boundary -
-	 * pfn_to_online_page() will succeed on all pages. Allow inspecting
-	 * these memmaps.
+	 * If max_pfn does not fall on a section boundary, pfn_to_online_page()
+	 * can succeed on PFNs beyond max_pfn within the same section. Allow
+	 * inspecting these memmaps.
 	 */
 	return round_up(max_pfn, PAGES_PER_SECTION);
 #else

-- 
2.43.0


