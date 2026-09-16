Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE84CC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23C16B009D; Wed, 16 Sep 2026 04:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4506B009E; Wed, 16 Sep 2026 04:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3716B009F; Wed, 16 Sep 2026 04:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77C9C6B009D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:31:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B5B816061D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:31:08 +0000 (UTC)
X-FDA: 85218955416.12.2C7D0F4
Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D65C140008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:31:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FLL9t0V8;
	spf=pass (imf07.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547466;
	b=gK6Urf0d2vwWf2F/8bXL3CEwt+urm2httkrS3SVg/kLcFqxY7Uuk34efXtRYomycJfMgbC
	HJIMopwZ3BEqz/ppj01UNssPee+CDKI+n48fT9WWb3L7OexAdP25I2HW/PrriahpnWsZyd
	jevLHp7g7b3e6JaFr15ZCV6sqJE98Ts=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FLL9t0V8;
	spf=pass (imf07.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d67xZwUjmGmwHedme+rBc+D/S90fLDud+3iF4HoATtY=;
	b=rh3i6n/EoitCrCN7tdhzmVX5/YBJIUNStaczhmW+HKe0nJoxn4lEDSPi4Ghe+QPxurkgsC
	jCJTi2CdS03XMcrJBPSf8+qO+7OwPeuza84ohBmQkvt6GSXmBI82ukplEyQ1HB/5xFYcov
	oh0um1T6etcjQdWVrilYhnnD41LpIhQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TGHbP7pqQI5SZE03hOgeWCxnxJhy597Gk2gKdEshORI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789547464; v=1; x=1790152264;
 b=FLL9t0V8sESq5QkZCfhYUAvjsk0orvo7Dx4yuMIaV11t7PJeP6qkrKXjpppb9uxynOvf7Y/M
 8scrZzryPa5wd0SBeen8S/lj0dapH+kFVu3+hjFvZqpXPyoX1whi9FU0lFjYpU/lWzveuj4O4Zm
 AHDnNLBZbw7P7B2LaTLf6hpE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 61064642e84ac2ae;
	Wed, 16 Sep 2026 08:31:04 +0000
X-Mizu-Trace-ID: 61064642e84ac2ae
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Wed, 16 Sep 2026 16:30:27 +0800
Subject: [PATCH 1/2] mm/hugetlb_cgroup: move per-node usage on cross node
 migration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-for-hugetlb-charge-v1-1-70fb708b2e4a@kylinos.cn>
References: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
In-Reply-To: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Colin Ian King <colin.i.king@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>, 
 hongfu.li@linux.dev, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789547446; l=2653;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=0fLYrT8vMJXLYpA77bYjhh3zAbeCPV8jdpEg+IugFQ0=;
 b=qOh2IG9HEF2gASoSGToGcyD3+c0zMiicyqR7OKOWIpyKxdEfST0DPjrYYV7UBR48lNXzsTAtQ
 zlSi3DCh2gbAP74e0x+Qh+QQJ5X9ZFR6OOOJvp6iCwGthyu1hxlkapL
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D65C140008
X-Stat-Signature: nh3b35ebcabq4mnwuche9raxi9gdctpy
X-Rspam-User: 
X-HE-Tag: 1789547465-553892
X-HE-Meta: U2FsdGVkX1+9aUjrs6b6ufH4NcVJvom67Id2EJvxOLJdw0x8XjgGd7wCbCupCgvL5ZUKBsPr9csmjgyFXBEPFzQRFj79HKUlpcgww2cOYeQRhF7e0Va/w/jB8rMW1xDrjtwfLe5i2AHU6897gKyeQbZ1GaRiZX2R5FQvwB9NKhDWiTO+7qG8h79+ti6ZOv+ECNmYq/E2ybKByTxTmCoxG9Y6iHzeYTSGzGiCKJFCZ6gkCAtr+WQEty1lsAuxDAU3Ezl2+AAn9EHRvMlY5bXg69VvIyUfp7EDDNWPd/X+97L++7JqbxD/GYIio9JgsHPcbvqXOwVPlIPRk8CbLETvai7o7VUk9kSiIqv6NjyC2v3A5b2RRCS9+RSJi21qYufXTAzghmLnxNN/MevVSWDGcYlwvhIdQF9zU2SG7+hxBwrt3KSlCatdCH7d/Rue62XqFXkE6mvU4IBr7PeNA5a45VlFe/fIXXx62ntyMEez4kp2HTlv0T/f7+syLVhMbOCiqmi0LLdFzaINnEonETMZqJ67KKGUVoYAUffdWwCI0HwGP1cAVBAlIuAsptie+f1/clqzy6sEfaZpJmX0guf31psqS0LRpq67ngOPXdjhcfFKK9MprGmDRCsN0ZFiGnggKsZRaiHRhxQXTQOnUsTDYcrhRBcV7Nk6PTuMuUGt+4VOtuKt5m6TOtVnji1t3H4ndvgmc/Hpmkbecd/lXFxm0sPeKSttXEWwR3ezO0toR+feDe2at9x9jU/PTHiLE8SZIxDyJXY66x1zfWqadLg/S0yWB4VPVQXnS3AtY30aNdOUekpXVSM1NRPeQ27PnEm3xN3+5JUrrmY5wHZmE7mjKWyoT+vqrMfdID2hcj5sjxQVSNl2IVeUMh0a6Itap115MmadVSm53cALx+3s0zHNWIBd6RxgqcfQx6DNn4Vf29aflS5koJblfkW968Y8yS+pR3Yg0yJrz6p3WbJq5Pv
 VlLPSwHV
 jJi1HA9OmRJiDM8j70l53DdXzCDbe1tfnf33kTaaEN+XXmgDnIxK/uZyBy13ZqqN9LuZOo25eym6ZetV937GC6ZtM1SAGhGBJrBjrUIFAohb2RgicTYhXy+uSFN7METlyhEsaxQb1fJjCsjnYo1sA6hsuAl2t/ZqNYhFh/7YTxT36mqcyMBRGMaKSNV4mC6c+DrjtRgmzw4Jyvqq4O7zjjW+HwAnNlaUc/PgjEuDfAFqCAayAa4JJph/BOpKye+KbfUpJUbjAq/chIN2Fetp/fJF9ngZOHivz7o44K5AYuzPDkbsdAsDox95yYBLjhf/YLpRuMGlLVyXCg7/FC5TawPPJO8awKAjyAjwAdxvf2sstBVuBwGQZP3oe13TLFCzuCY9m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

hugetlb.<size>.numa_stat uses folio_nid() to account usage in
__hugetlb_cgroup_commit_charge() and __hugetlb_cgroup_uncharge_folio().
hugetlb_cgroup_migrate() only moves hugetlb_cgroup pointers, leaving
per-node usage behind on the source node during cross-node migration.

When the migrated folio gets uncharged, we subtract usage from the
destination node counter. This creates stale usage on the source node
and unsigned long counter underflow on the destination node.
The hugetlb.<size>.numa_stat interface exposes these incorrect per-node
usage values to userspace.

Add a hugetlb_cgroup_move_usage() helper which moves the usage from the
old node to the new node, and call it from hugetlb_cgroup_migrate().

Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/hugetlb_cgroup.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index ecb6e0b7819a..1040406e7e1d 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -179,6 +179,34 @@ static void hugetlb_cgroup_css_free(struct cgroup_subsys_state *css)
 	hugetlb_cgroup_free(hugetlb_cgroup_from_css(css));
 }
 
+static void hugetlb_cgroup_move_usage(struct hugetlb_cgroup *from,
+				      struct hugetlb_cgroup *to,
+				      struct folio *from_folio,
+				      struct folio *to_folio)
+{
+	int idx = hstate_index(folio_hstate(from_folio));
+	unsigned long nr_pages = folio_nr_pages(from_folio);
+	int from_nid = folio_nid(from_folio);
+	int to_nid = folio_nid(to_folio);
+	unsigned long usage;
+
+	lockdep_assert_held(&hugetlb_lock);
+
+	if (!from || !to)
+		return;
+
+	if (from == to && from_nid == to_nid)
+		return;
+
+	usage = READ_ONCE(from->nodeinfo[from_nid]->usage[idx]);
+	if (WARN_ON_ONCE(usage < nr_pages))
+		return;
+	WRITE_ONCE(from->nodeinfo[from_nid]->usage[idx], usage - nr_pages);
+
+	usage = READ_ONCE(to->nodeinfo[to_nid]->usage[idx]);
+	WRITE_ONCE(to->nodeinfo[to_nid]->usage[idx], usage + nr_pages);
+}
+
 /*
  * Should be called with hugetlb_lock held.
  * Since we are holding hugetlb_lock, pages cannot get moved from
@@ -906,6 +934,9 @@ void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(new_folio, h_cg);
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
+
+	hugetlb_cgroup_move_usage(h_cg, h_cg, old_folio, new_folio);
+
 	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 }

-- 
2.54.0


