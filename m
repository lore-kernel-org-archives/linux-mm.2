Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633DFC43602
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EAA6B00BB; Sat, 27 Jun 2026 03:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4473F6B00BC; Sat, 27 Jun 2026 03:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335446B00BD; Sat, 27 Jun 2026 03:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06EF96B00BB
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:31:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73E8D140677
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:31:15 +0000 (UTC)
X-FDA: 84924871710.08.03AEB0C
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id AFA3418000A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:31:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PHazSPnf;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545473;
	b=jJCvkk2dsQiNeFWKDROzPL/E+Eq8Frc7YeUDTMeI7T6eWSZsqDsbY5UmuLgQctefiV9k6N
	P5pjTpT0CSEuDQqzmWSzjdmYQdiBcSRXXFHG3Sn3n3yDbJmWef8Ivtl9jZt5gLAxSCXxxk
	FCAfFRAopgBZmBr6LK97LFsqWloDQKc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1WE84pD+Jyu5g3XDhg98oT1h9UPEuFUTiMELgYk7rrE=;
	b=VCNC3BK6q7AzDVovqHgYsq3gSlqL2BpYe4OrnGfPW+NSEeIe0pRVaVf2LDFCO0+suj2t6x
	N5q5xOag2udnRCGeh/aHDUHoPA3HYRdz87bQFfz4XBvBun7gyVtB5TlP+H/KBZrvQYIzgy
	fo+iCbQY0DnfOz9Gnqwfb5VYR3c3c14=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PHazSPnf;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-91562bf6c12so215982185a.2
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782545473; x=1783150273; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1WE84pD+Jyu5g3XDhg98oT1h9UPEuFUTiMELgYk7rrE=;
        b=PHazSPnfGK4RBRJXZmKFMYfGgAbf37fTlJuSxaPg6k16FPVGaz3asIhVUMO4G5d6LT
         ja5a8SrW/g18rvy7Z9vMB4Gfve3c6GC3bn4R1lXW8/rBcnDODqh8sw2AjZvaXztvQoNI
         pli8IiBTiWtIIxZH3juzXLP1iu8NS4RocYstSFkbqM/aqFhMpo3VtxizSNvKQrfSKoPy
         3/2YdILZIdPXmkQhysZQtTtW4tFWDN8MaxBCL+tx58G7cloZd5sgvr8ITWTLEUy636fI
         oU6FeXo2FkGfltisx9PpDTFHeJ99bbFB4ZLNly8HrWCE4C3oB8l/faLlsrrYfjKgq3Lm
         aO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782545473; x=1783150273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WE84pD+Jyu5g3XDhg98oT1h9UPEuFUTiMELgYk7rrE=;
        b=VGncvzMZjh14np9jgZIXkjpzVr+MTdO3LrMAm2Q/Tueix6G5Zm+gjtYrsJq7pBin/p
         tgG3tC07dCj3Sr5mK+K401LULCoBo+lwbaPTAFnR2oqEeOFX6pmzbPZ6pnCkfktAkfpY
         TdIDzVRWfOKmno+lkfkFmYj3cZdpGa9ByADJfdqkkZ4KuVPclBgpbH4gUUB3E/dwKAdH
         SrUb0OUBMvPjqXa3w7JApoHK/ND6nEZFPjQ4pRaWDN9A+XHTk4ZsAr23NixGF7lxSveY
         3IPX/IydZWjz4NfnCmjKmW9TqTeiAUWGm0PcBfLLq0d27WSICqF9oh2OIY3Wr0vZI1j0
         S5wA==
X-Gm-Message-State: AOJu0YxOOP52TSz/AP5UkgiwIIcbgULVdghTo5z0yjT++BOuCyDvxFnR
	UV4tlPF7mcleTUxzefPbAhMbjZy7BqtM/q/H7dKdPUD/qK4fAY9O18hfw22fWYzfnorrM9Gk2sl
	VkGo/
X-Gm-Gg: AfdE7cmK+1QWx7Yxrm0PAzzCbzmD/JN6ZxGW4W2eyrKQpWfsBPt8Xb3QzOkqJW5O6dy
	7hO0xHdZ/BD3G2lg5tTuihPhuERZpHOSC5AmzWJkNxZfhb+DShNLF+q/Q1guiWfyYTnHITxX8DD
	hc6jbbizjujL5Ba2PQrLl56wDu0smE8NH9r7Sk7CF2XQpUQVZgUnMco5vcmOIcX/ZbglJ1ePm7d
	s6fF+rU+TAv757WW0NixsPLtO0AnZipeBewTDmCJh6tOzqfIj4pth9yea/aocdu+CRx9EibfxC+
	LZny/GqOGHMatSB1O54Dm9ZVMaG9U+RPYhmXwxd1ppwRNV2t8WSn8N3uZzxzzeiiKbHnsKctE/P
	TTcscW00w380tCwZX1gX97VQhfez02dHBA3w4brT44/56KSYrHjzV5WWBiyfxEYJLlFL1Tlf260
	fg2pPEXDkkwRLNZqwefC2JTKgMUxOyIVItsUivS+VRGR3Hv0RElNWSqHg7HM8QB1NTtUGmNt6wL
	A==
X-Received: by 2002:a05:620a:2911:b0:915:f360:e97b with SMTP id af79cd13be357-9293a6b0834mr1579336085a.6.1782545472672;
        Sat, 27 Jun 2026 00:31:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92b2affb45bsm296627885a.12.2026.06.27.00.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 00:31:12 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	stable@vger.kernel.org
Subject: [PATCH] mm/vmstat: flush per-cpu node stats when a node goes offline
Date: Sat, 27 Jun 2026 03:31:07 -0400
Message-ID: <20260627073107.523499-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dzc9nzisedhqdwygmr57jym47t74anxr
X-Rspamd-Queue-Id: AFA3418000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782545473-990120
X-HE-Meta: U2FsdGVkX1+9TJSWDwwPtrPeeL1KHFvUlUQHIXX+RYqkAEcoDess0jULD+gTZqNQWhorndB5J3wOGCX1oygH+ajwbaGzWWtnITcBqa7VILeC3L/9jnqEcr+xF8AvH55sqD4kA2aEGW7WirW4hwjzOtFPWHg+naVIOyCX03ZAEU9m0tHKNtHMjoQykAloLbVeGAzSZ6r/6d6mwPYGMDWOdstmJYonTbDfaRvSLBTq8pGlNnqf+vucEG8Qp5rNZ/tftT5Zwnt/UubM7PN0clKUMJ1tZETKHxAgS0LX8nyaKLuA1pF8txjoG3LUXXIGIxonhehaYQgOt0YTTYY80Kxhio58ZMa6bbBIYq8eXp7NwD/TS6ZP4O3OBaLaGzCu1mFRHnKAHHogZgZNdE4Xsk1pE/K+WiC2dasxtZ76L+LdssfoejIE06Dn2GDJwl17fDLrRJNT4Y0mFk6Ne9pEcOWUG99na5y8WHSOE1AheYv38W1iP4xOAjk0d5sJCYjGCLLY81586l3iMjPKvMK8d7gdCwgRDsgBZgG9/wP6IWpZ9dVlqV4T7GnectR51fjNpTdMT+U5J3h5LhBPniDXxo8cguy8qPthNXdggb7KZx4jnokkpe6ODOyoM7Top3XaxDEe41ZrVhZX7r5XvwQvCMiv1RCZxc5JHUzWiFHCfsRcq9fe1yeWBJUhknRDZI9bYSl8p+fPg71EpTtZdSw41UTSazpsoIs2B4Z4zdOMkE+YfnZxoKTDHNOPP5XLydoMzFZItata5TFBxonsydDqJ8jjrQVZIzYTTTTeRwkDPAqK5fdROIQcrSJ38LKX/k7VoIhSJEhX4MGp9NV04Hbib9UG+obDjoks8zluMbrFq6V0bKIeTg6pj0xn9Gxg1+S5xj7qbk/fnmkJqP34FMJAkKBeOPlC5ezu7FNatKJ4Hu/a6430dixl7kFimsZopuchYvywA2A2uRqdHOtJyPXF6yK
 kDzuUa/P
 hdvJoKvIoYet9RD+lcak1pXgxGC+8aWIgLdmrnn3Vyoh4Qjz0FQJiYjWZWv8PJXvWvoDYA9SKU7VBK/xIPUSlntY6hz3PxIYbUj5+gwua54tRCBlK0opYq4lohVl6udGQ8LSnZKanHq3qbiOyZJee+cfbAtpIimVrAY07+0kMjqwDgGnuYQTRw2wPDdnrnO6z102m9eVYDKmMQEjQyE9kw1T39eWIaSgOo91kYmZIufa+teK+SHDj0pTtrh9TyDI2Gclbb/YUzNlNabNsuGIApEv0K914VJBis8rVRTzwNnKvRneyrCEJQYvjWui7+RpOHtTcK4IL/OtggVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A per-node vmstat counter is pgdat->vm_stat[] plus per-cpu deltas.
A balanced counter can sit split as global=+N / per-cpu=-N.

The folds reconciling the split only walk online nodes, so when
try_offline_node() marks a node offline - per-cpu deltas are stranded.

A subsequent online zeroes the per-cpu area but not pgdat->vm_stat[],
orphaning the +N permanently. All NR_VM_NODE_STAT_ITEMS are affected.

Flush the deltas before the node leaves the online set.  A remote
fold races the periodic per-cpu fold, so do it as per-cpu work.

Discovered when a node/compact call hung for a nearly empty node, as
the math to determine throttling broke. Reproduced by repeated memory
hotplug/unplug cycles on a node under pressure. NR_ISOLATED_ANON
ratchets up and never returns to zero.

Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/vmstat.h |  2 ++
 mm/memory_hotplug.c    |  5 ++++-
 mm/vmstat.c            | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..ea1017427811 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -293,6 +293,7 @@ extern void __dec_node_state(struct pglist_data *, enum node_stat_item);
 
 void quiet_vmstat(void);
 void cpu_vm_stats_fold(int cpu);
+void sync_vm_stats(void);
 void refresh_zone_stat_thresholds(void);
 
 void drain_zonestat(struct zone *zone, struct per_cpu_zonestat *);
@@ -397,6 +398,7 @@ static inline void __dec_node_page_state(struct page *page,
 
 static inline void refresh_zone_stat_thresholds(void) { }
 static inline void cpu_vm_stats_fold(int cpu) { }
+static inline void sync_vm_stats(void) { }
 static inline void quiet_vmstat(void) { }
 static inline void vmstat_flush_workqueue(void) { }
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7d60a7dd1e7b..10f676566f56 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2338,8 +2338,11 @@ void try_offline_node(int nid)
 
 	/*
 	 * all memory/cpu of this node are removed, we can offline this
-	 * node now.
+	 * node now.  Fold any pending per-cpu vmstat diffs into the global
+	 * counters first: once the node leaves the online set the periodic
+	 * fold skips it, orphaning the residual on a later online.
 	 */
+	sync_vm_stats();
 	node_set_offline(nid);
 	unregister_node(nid);
 }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..ad77343212d3 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -941,6 +941,16 @@ void cpu_vm_stats_fold(int cpu)
 	fold_diff(global_zone_diff, global_node_diff);
 }
 
+static void vmstat_fold_work(struct work_struct *w)
+{
+	refresh_cpu_vm_stats(false);
+}
+
+void sync_vm_stats(void)
+{
+	schedule_on_each_cpu(vmstat_fold_work);
+}
+
 /*
  * this is only called if !populated_zone(zone), which implies no other users of
  * pset->vm_stat_diff[] exist.
-- 
2.53.0-Meta


