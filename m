Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94DFC61DD3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 02:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725806B0088; Fri, 28 Aug 2026 22:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D64A6B008A; Fri, 28 Aug 2026 22:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC146B008C; Fri, 28 Aug 2026 22:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8E26B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:32:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F9F1120616
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:32:57 +0000 (UTC)
X-FDA: 85152734394.21.EAA0759
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf01.hostedemail.com (Postfix) with ESMTP id 85FA640002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:32:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e9qHmgdf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787970776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=25I0k11lg1U7F/BrG1zyu3Isz9IEV77VAnOY4pukh3o=;
	b=u96GHjp8dYu2/o+J4fZVkf1455lPSpErKWDfSz0b7e110QhDIXjrrWWjdO/Nc08SeN6o/6
	r4FEhCgTme0n7kso9r30eNzoSFrxCGFRl/7NQa5iDJAUT04vviFrbvR63nvzM5CYxJ/ND5
	Pfj35EYRtuZiTYnAb2NlVC4ve2itglo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e9qHmgdf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787970776;
	b=lMKeF9sEVyxg88544K1N7nm+e/IPS7y4vi9bPsUaAGAN9XNQmQcUdRQi1Gnmr3qjNSqvP5
	q6FRFS/HAZYe/ULZmzxilNhjBmMehQvD+cUmlxf8xgWrmoT3zh3dWiORVFmWA6qJK+CEdD
	0lVZ4knKBcOtdoMM+vfW0UlyUHWY+IU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=H1xtjBEAg3BPif39hck2d213NLc0Z1FDsX7jcBX47e4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787970774; v=1; x=1788575574;
 b=e9qHmgdffEAllsCyb3XwlS1rkgZlJ+NInPSUhsjHQBBpLcbnM72Sqa9kufFDnea4Tv1p6xZD
 sDGOTlrdvt8vXOZHdHr0d9g1mFa6Q7Gd47tBmMEe6Iw3EBGaff36Iq5/7Mo9+LfWUS1VcWeqLKQ
 8QEvlD0bKue2ELQbhlMl9y0g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dddd84c8fda15912;
	Sat, 29 Aug 2026 02:32:53 +0000
X-Mizu-Trace-ID: dddd84c8fda15912
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	stable@vger.kernel.org
Subject: [PATCH] memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
Date: Fri, 28 Aug 2026 19:32:51 -0700
Message-ID: <20260829023251.474083-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hg56xa714n11jq7o6enhx467oc9rugw8
X-Rspamd-Queue-Id: 85FA640002
X-HE-Tag: 1787970775-756178
X-HE-Meta: U2FsdGVkX18FCGBhwZFcTA+ISxnfqkz+tda2ZFs0mtBhzzJZzMQNHtTWjmcf3pxRzRUhhAQfb+Khjrq7hwQdCS+qz+CewFYJDQAO0mzG//s5G5+vle64P+b5aF2gZd3F9j+Vo5hwvlR2bKSDHa6hisKvzKYnU9yEc/UlxYFLN4w2q4aH7aC/k3X2i3NVVRRVlFFlueT6ZnAtX+VWiGaWlfndFaxUUa3syUM39KNkxF1Sxke0YZ+mI8ZotVxNJ4q/G4YCnQ8dyKiPdPJ8V0YN63O16M19rVlzvfDfIYKU8FPMNQtqrFrTVnj+uRyegp2ebBeDDiRin8ndjxAyzb2aXCP7mU5qNTJHl0LG2kX9ROTP3A6T92p+D9PLKDS6Qoq+Lxws+Hh9i7V0ttU0LLWQfJHSk2lY3JkizZ3tvUZ0o6r/dUfJ9NFkpo7zqniTXdg06c12CWEamlnJPJK3pjbNnS3hSbMqFJwLGCKya8cEqyI9FABiWeehNefgT5nlcNp0+bijvyHiwbnkBJDIoYTGnrxnhh+ExBcSn/r0N1JVKfaXpWlt1U56KX63f6tzQGzGAIHVwZ9QmyJxbDptOHjB63TneQCyI5VSdm0+sYxvUrzhpTi55WA0XVCE+JbY5q4RuMe6g3cJa6gPT5uPOupMeQfG6pxUb5svNbG17e35DYuXGBySmWR4Omv3W+jx4DD3d7C1mkW1JqoKvb4LJ2ZtLLzB0Ac178Q9bgLA4foIaTPyMweRe1koJiCZt7r5ijhmlfITXuar6o9ad+oOGqQmEUo6I92XKFVSFmbAQfTLvItnTreecljhfssaeIFOAUq233mJgqnifDemGgFYcCvG8igC5O97zyGpTW62GnXpqm+KdlS748vKgIyfGURnPFqwVYIAea6bLljZVBaAWKup1I5qKAtQYgoGDWnWo2rB34LHpLF+uuECmddXacswv40+dF0bSUOjIWny2gJRqWo
 bglJQudZ
 WO+GMYmsDj3S+QuCD4C1Km7okVZq5D/qjla/sfPWBQQ/E/7wowucpcb6pvZe0qFgUQX5JNafMt+mjf1Xr79p7R+mdlHP2ksruchnFDi67dJ7mCDIJ/XzDysTNF9QRmKMN7jBBn/pstQjSvYMXBOav0p3PeaJyQkHHrmL/5zCWeahRJNFlQ1fm151ULGdIktqPUIgfcniSprA9XkBkfzjApnnwl0knOAnwnWJiYl0wYCcBUsCyBB4tLzCeJ/anwDaPVx2xkMNJuMohOas0O6uVdLGAXdMYmlUn6plME7prx9SwN8onqPLommxXGHC0P3XXdzRg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
try_charge_memcg(), which does not short circuit the root memcg.  That
memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg the
objcg was created for and is never updated, while memcg_reparent_objcgs()
does redirect objcg->memcg to the parent on rmdir.  An objcg of a dying
child of root therefore passes every obj_cgroup_is_root() filter but
resolves to the root memcg.

Folios keep the objcg they were charged with, so this is easy to reach
through zswap: allocate anon memory in a cgroup, move the task out,
remove the cgroup, then write to the root cgroup's memory.reclaim.  The
reclaimed folios are charged through the reparented objcg and end up in
refill_stock() with the root memcg:

  WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
   refill_stock+0x644/0x940
   try_charge_memcg+0x12d6/0x1570
   __obj_cgroup_charge+0x35/0xf0
   obj_cgroup_charge+0x1de/0x210
   obj_cgroup_charge_zswap+0x83/0x270
   zswap_store+0x1620/0x2000
   swap_writeout+0x94c/0x14c0
   shrink_folio_list+0x3388/0x52b0
   [...]
   try_to_free_mem_cgroup_pages+0x30d/0x830
   user_proactive_reclaim+0x504/0x840
   memory_reclaim+0x1f/0x30

Beyond the warning, the charge is asymmetric: obj_cgroup_uncharge_pages()
skips refill_stock() for the root memcg, so the root's page counter grows
and is never uncharged.  It is not user visible, since memory.current is
not exposed on the root, but it is a leak.

Use try_charge(), which returns early for the root memcg, restoring the
symmetry with obj_cgroup_uncharge_pages().

The above sequence was scripted into a standalone reproducer (zswap on,
swap on a virtio disk, 512MB of anon memory faulted in inside a child of
the root cgroup, the task then migrated to the root cgroup, the child
removed, followed by "echo 600M swappiness=max > memory.reclaim" on the
root) and run in a CONFIG_DEBUG_VM=y VM.  It reproduces the splat on the
first zswap store of a reparented folio, with the same call chain as the
report.  With this patch applied the splat is gone while the zswap store
count over the run is unchanged, so the same path is still exercised.
cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
failures.

Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---

Note: I kept it simple for easy backports. I will followup with more cleanups
where I will remove try_charge().

 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a18ee4509ab..1709ac96bbde 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3157,7 +3157,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 
-- 
2.53.0-Meta


