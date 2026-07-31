Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD5C4C55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E076B008C; Fri, 31 Jul 2026 17:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8F16B0092; Fri, 31 Jul 2026 17:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20ECC6B0093; Fri, 31 Jul 2026 17:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBB2D6B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:53:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6631E16018E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:24 +0000 (UTC)
X-FDA: 85050423528.20.0208613
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf15.hostedemail.com (Postfix) with ESMTP id B6B9EA000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="V2Djism/";
	spf=pass (imf15.hostedemail.com: domain of 3URltagoKCJI7A2w9Az0772AA270.yA8749GJ-886Hwy6.AD2@flex--loganodell.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3URltagoKCJI7A2w9Az0772AA270.yA8749GJ-886Hwy6.AD2@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785534802;
	b=qCfBYNTCyOnVu8x/JelSaCHdIbQh3H8zOPnprY5AOksPm0ggfkSZ47+7usY6dSCj+7L7E4
	aseQm098QsJOONhS0hYQNBaAiS/CJpo4H9KYJLWJR6GNQJXzpUwoxgSvDmfacejC7Kg0KB
	NQU/14paIhom8dDHMgzK0wvg41Cesw0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="V2Djism/";
	spf=pass (imf15.hostedemail.com: domain of 3URltagoKCJI7A2w9Az0772AA270.yA8749GJ-886Hwy6.AD2@flex--loganodell.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3URltagoKCJI7A2w9Az0772AA270.yA8749GJ-886Hwy6.AD2@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785534802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXN1kpPZzQWxyZLtIWIq6X9QJe/5QaMTFSKsE0QskIU=;
	b=S3BnqDuqMQ/q2+jSu3SsS8iSSXA7/wjQ0bdkaHX/BpIpRBnj+BBGXoN163WOs9Sijwja6n
	hK5ONXrlZzndYYt74FYJ961i05A+pkAVWmg0QT5WTZoJh2m+zODBntOtcTsipOr+yNxLW/
	BnL/kZ140Ls+tzhmu/RwvN9LTHmcsM0=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso1524176a91.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534801; x=1786139601; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IXN1kpPZzQWxyZLtIWIq6X9QJe/5QaMTFSKsE0QskIU=;
        b=V2Djism/WfGx4WOl0vD3ORKmCD/vaFIUSCEINqjmHz6ljBxexEynMt18r87hHo5c+2
         KYgArHVaAqbJDYhVjAuuLsdTXqCWigW+biflEtqrciTzJ0MCX+x16+C5xz/G85HNfR9Z
         vnlgUe5c1rTiG6J0Y2h+cQUpWru+yMpIJBFvwtfLXEvJhTVC/lXCaj/PvEEQtplUZ501
         BvHCbFSR62aulNqBKumCP8Dhj1Pk5dA2U4D5jKr1UR2M/qnm011JGTsa5ChPAiWsFlZ/
         vNJablxCDm1UU/QDd0qwiQxb4nPWpOkjhivCKqJASBvlys38Ss9364C8SX0/30EydpYE
         KIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534801; x=1786139601;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IXN1kpPZzQWxyZLtIWIq6X9QJe/5QaMTFSKsE0QskIU=;
        b=jR5gXuZLXbTITPtCKhogiVVkchLHaPK54+MOabQqqRHsqBa7jcjLtFtelHnNqwzY/K
         3cD+FpSBjFH5kB/CQRrjQrlFZjj3J/+NWiM5Ffl99WQrPYEmyoPLV2xSx+0Ch21xBZH5
         VEkJCidbpxYSbsfcAXHA7Iw+z9RVW1TRM3W7l78sWrPl43dKpT/llF0s59tQZfYUFbYC
         T4zwDdathO+R3InK2ppW4tSDZvxw1n8xJRGNSzCvD/VqD2SNw1haiqisjEr6CD9sELxH
         i9KMbuBUnOCpgTPDZqv8JSZsGvElsXugyfPTMLQTFbNs0T8BfbZnCc6PykYZR4bXRCHr
         UBjQ==
X-Forwarded-Encrypted: i=1; AHgh+RqKavsbh2yz/uWs+Fsa7lzimoZINETr+6rLvei+anzBWRbeHHYqtxWyceGDbKWRYKbDtrDtxVXZew==@kvack.org
X-Gm-Message-State: AOJu0YwwRYmlRHd+VUJhtWBZ+hIVeIsD45qrXQsITzn2LFXWlmO0QtPY
	+XEVkzY9HhORsfcWZe/7bsnCcEg2tAmN8KsYi4vU1BeYEYnph1WsbTiMxYcvxSiYpRnPrxghq6i
	A4ka3S9iTnFm1Cxqg1CNeig==
X-Received: from dybkz17.prod.google.com ([2002:a05:7301:1a11:b0:313:b255:3ca2])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3393:b0:3b1:a9ce:507e with SMTP id adf61e73a8af0-3c92a60a0f1mr1289190637.32.1785534801433;
 Fri, 31 Jul 2026 14:53:21 -0700 (PDT)
Date: Fri, 31 Jul 2026 14:52:21 -0700
In-Reply-To: <20260731215224.831696-1-loganodell@google.com>
Mime-Version: 1.0
References: <20260731215224.831696-1-loganodell@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731215224.831696-2-loganodell@google.com>
Subject: [RFC PATCH 1/4] kho: Move subtree blob logic to separate function
From: Logan Odell <loganodell@google.com>
To: graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com
Cc: pratyush@kernel.org, akpm@linux-foundation.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7zaj8ngz4jmh7qfan89firipq76b4fip
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B6B9EA000A
X-Rspam-User: 
X-HE-Tag: 1785534802-528154
X-HE-Meta: U2FsdGVkX19IG5UUwojMz05FP0Abnq3Ug5JDPvnB1Ob95dHoCd/Nxp4jqYbY+sIUtNxYd6llqB7qaVUo6lYoDiajmxjqlgbU+wgQqU2d+Fy7reNQI36wOejwEFuv1fn0S4sh091VG7Gfz4H1VqXgoFCE25m5FJBVnoJgzJo4ostgHG0X0vxZUjmPAwZORXQfZw+C5T9CSVDSlnMauNJNsOI9gAw/OSq2pIh/4sBoGnkBULFjJNfDavXg2qmnDniAnuI6PfbDsZMUyU6rWz6+HWuMGgixfgxb7JwwldYiYHifRIdmsHTQ7pqLNOAApENim1JBqPd1DGdrbTGyDqz+3bXS9umRVR0x7fsdMGeB/5GhOvmOBAS0WskUHa7taFcCND8gAM6QIQ/G1OCgSUUL3fmqGBi6Bwk5c7fsAcOMGbTj45jnjiVh8dsWujVtFyTgPuaW8kATZsnTmKR+7fpOdswzHEw31cYpIGzjsycuc//upnXeOQOe6xGSXLe2LQ+YAK0xRfrJnGhzVSlg598vcJ2ymAGsUtJJ/RIA34iWdxjJyUUf3bt+Dbb/YwrOh2zOsvv7aqVVgmMZyBYuJ4ZnOOeWvud0lbXOfVYndJL22cE0Nd1+fLgU9IneGma29vO93Cyk8yIaq7Psjyk8Wd4RNcXUcnt4Pr8MvQw6YS6TeenyCnj2XfChzpQd91qDhKIB3WOuf4EjMfOaeZpMj42w0yhUatB0dtazJhTXwyQZ22sKeaGpKIahOLmz3beeNMpXahG9TpT0p2oZ8XpbPFhfDhihQfsXNDeZqljXnIjMGF9CcnODDqhUsWmK3T9NH9mSCN92u5NXvo+iKDGCbZBP9MrbY7Y4fkh5WBIRP5d8Gnc7WfmWz9SBdIk3rd4JAKpSOajVLY//tIhUqH6sr/yBU4bMoXGhVaLHZPh72fE/LxTRsOJWTheAnQr7OZfcAed/0GKPypn7FV8XTgzOCsc
 M7Dxlel8
 1bSg7PpZMWB2v/M9NUNpFIwJ7bYENPvI5ZA/UN5D90xyisomOlEktLFQav/3X94jtnDnjtG68cafASw1ZU5Hq3hdGOQ0mBCUZr6+9cj5zTXeTAACBVYyvF6rGPx583NlyLNaVo7H2Gp0R3/Hkjv4pYVl+y1F0OAVjUbIJbc07ipheioCrpz4yJofWlqW9DZ148SkXjW8DH3mHwrgLbWhQr3waD5c3MrVFsZJl3HZ7VTTcKB6vr/FG+ceWY5uSq2uLyj97j/tE1yQfdL803GQg50VhcrrMOOfCyft+4PnESvUMCfwXMxLo5vaqIRy+hGJvGyYuedlMbJ1TgMAP2qVvU2hyc679DzgyEkUOJUO2jykFcae6HTi55l0ZQ5QdJYS4cRHGgC7Nt0tVm130Hq1zv7GWzta661I8Um6A6hComJIkO1qqLKPJ4c+Jo1Lj100itEHGJHL+133n/Mu6tXJIiijciV1Ss0avayMdb6sbvuAr7OW6Kf+5BCz3I9IGP/tXzVXAeO+KbBy7epI4YVEPmgMFhvKA8tbzhgNeFN3sP9Ls1kdStWBDkLp0bqlGzeisnylOIJchW0JwZUGDYR9CYzyb3CFyvpBwtmZYxjt7yzuaWX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the logic to set the blob data in a subtree node into a separate
function to allow for re-use. No functional change.

Signed-off-by: Logan Odell <loganodell@google.com>
---
 kernel/liveupdate/kexec_handover.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cc68a3692905..29a05cec2625 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -722,6 +722,21 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
+static int kho_add_subtree_node(const char *name, void *root_fdt, void *fdt, int off)
+{
+	int err;
+	phys_addr_t phys = virt_to_phys(fdt);
+
+	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
+			  &phys, sizeof(phys));
+	if (err)
+		return err;
+
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
+
+	return 0;
+}
+
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
  * @name: name of the sub tree.
@@ -739,7 +754,6 @@ static void __init kho_reserve_scratch(void)
  */
 int kho_add_subtree(const char *name, void *fdt)
 {
-	phys_addr_t phys = virt_to_phys(fdt);
 	void *root_fdt = kho_out.fdt;
 	int err = -ENOMEM;
 	int off, fdt_err;
@@ -757,12 +771,7 @@ int kho_add_subtree(const char *name, void *fdt)
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
-			  &phys, sizeof(phys));
-	if (err < 0)
-		goto out_pack;
-
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
+	err = kho_add_subtree_node(name, root_fdt, fdt, off);
 
 out_pack:
 	fdt_pack(root_fdt);
-- 
2.55.0.508.g3f0d502094-goog


