Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34AA8C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2DD6B009D; Tue, 11 Aug 2026 12:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A7A6B009E; Tue, 11 Aug 2026 12:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B006B009F; Tue, 11 Aug 2026 12:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D14B06B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:19:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44A9C12055C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:19:10 +0000 (UTC)
X-FDA: 85089498060.22.1340DCD
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 71859140017
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:19:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pEZmNtL/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of maxi.saparov@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=maxi.saparov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrrHTlApXY4U6JlaL8nMvnN7qO+xyOd6Xm+nS8KTJxI=;
	b=Ue1QyulbJI2TosXz7YMiexsg7oO5eRC0vziCzFZd207KMYrR0KkvyeUnF2YVPNpp9397Zz
	zgZ42sFNpvx9EieiXtEVXqaTeaEY1hTQKnczy2FaT7rI1zTUTs3NPTWDQqJfQrzp7gyBR2
	EyDrPWa2KXxgPrR2rqHr2oJ0oexagcA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pEZmNtL/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of maxi.saparov@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=maxi.saparov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465148;
	b=Hh9usd2zaz8Tco6d5WIMGsI2PGtNPrg/OqgSX20ZbOz0pNeCczDyplQDW1/e4XU6hpFIAg
	3syp7uNZBwvNBLDY6/rEslb2WBh1QjzRA/z9UJkwPg5kIlyDacFPaf2rzKM3xxr3hFeph/
	4BwOmT83GOpkc3T0QH7ZpobFXIHdaIU=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c0c45c580so941411cf.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786465147; x=1787069947; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xrrHTlApXY4U6JlaL8nMvnN7qO+xyOd6Xm+nS8KTJxI=;
        b=pEZmNtL/ZoFAvpIhlqULxohXMBnhVk9E1/tgGgDxd2YfMHaO+QFPGjTZX1b+sqJTc8
         RzftSzmjZscm4xwSV1Sce2pGh4N6d//qNEXu9pKeVV+zk5WRSqdR0Akl7Ghtd3EVvh2D
         2rUhR+Fk6CLoP2grGaiuhcQs3vKJsNBav6+oIGWjtLZEYd5WQAi0ECve7jjgWY0GaNRe
         Y66mF9atjDptQzEWSa3Q3+sDXCJ/+QGX4U2zt3SvHuRqYudhAOE1xcmaBr+bviWiMH/A
         C4vtCBEGuasksjzukrKClPpDm4pv7AuwkfEnfxsUFIt/h5t6PWPMsow/OncGcJ+ZXAC6
         B1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786465147; x=1787069947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xrrHTlApXY4U6JlaL8nMvnN7qO+xyOd6Xm+nS8KTJxI=;
        b=r/IHfSG7WqO5wyJHLAaCndKt1kF8R4rggfpzjrXvoI7CcFnFv7MlSQiUlsyiUE2uT7
         mp9uc/H3IOhYKRQLiH5ka4nuJXsGgstv/Bo6lhDEk2DuIBumBUr8XR5+RV/HBvjpaeKR
         54Q1cDit12JTk7ovHVcC5I9WxhwEWzEiHm4lcgee3Fh+NLhS5IvJCPfO2MbpmtcWZDMY
         NL6Es4MtiUDca8Kl1GpArdgWVqwy4zcfJwWCzDpVR92cB1Oe6S7V3+CSxTuVbvSu39rT
         JbFXrRQraHn+tmCiM7/3mmNYVYuPUMQefeurorflWl2cZlnKprQZDo74jKlCR/8v2MWf
         AZeQ==
X-Forwarded-Encrypted: i=1; AHgh+RqcXjqT6OYeG0/30e3TQ48x3zPR7SoVGSSHqJ+F1uj6PAdS+LliDVFmnYgaZJjqFL4MIRW+GGmyDQ==@kvack.org
X-Gm-Message-State: AOJu0YzYqopYaiFDclWAFkMmLx3JzN+VXYuNAiql20gWmAFX2WR+rJzt
	8PHiAhjMxHWYEgN3azeU2C3CQ/CXXj/1D6A/IIlIVSoynruAq8ESGBeX
X-Gm-Gg: AR+sD120gLMvuvZbdlLqL6YA+jXdyvraPrHZnSSBV7Cte1Pm4kLRy0+z2cfzytO3ulB
	VllpEvLcK3EzzwKES4NswxF2MP9kZ2fLuVJfKtrv2v/c0zUaUjM7B34WlpHCS+fsThwgJxo5oCM
	HLC71KF6wwpMw+UU7bNnuyh5vukFBb+COZv9grxNHAsU2vXAcWNIH9ZyuCXCLz4bvRtKiuOm/P4
	7EeLkXbxP0Gi+Fh9HZUXJT3IchXH3oNUwHJH8ELIarmGUzZ+ejxujKZvLczTPk2wRKUpf0tDAr1
	5CLxx1WqmKXpW/GuZXq60AZcBvFFw9pH63SAq9lH5nr/helT1YikCVwwqrvX/iIZs48Vc70UReJ
	EjOfWx0diCOGSqYf3ynOf9wneQPWfXy6nJ8XHuwh9I/lhhJgCilk/tKR1l2Af+4OPHsTUFE4jwX
	/CiQGvg4zvMVcT82OTtSnrWp2WE1570Rsr92brfFaMbuoEbB8oEn1DJPtqSQPFvaGcpl5JrgPs5
	/I4/rDIVl3U8fWCc1j07OuUZzUpY1Y2lai9h1fkYZ9Lw3q48br+
X-Received: by 2002:a05:622a:4185:b0:527:9603:8123 with SMTP id d75a77b69052e-52d600ad28emr17978671cf.2.1786465147363;
        Tue, 11 Aug 2026 09:19:07 -0700 (PDT)
Received: from CW-D0XG2Q16P7-L.mynetworksettings.com ([2600:4041:5d54:8900:9c8d:ddb9:b1a2:735f])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3bf12fsm2323716d6.38.2026.08.11.09.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 09:19:07 -0700 (PDT)
From: Maxi Saparov <maxi.saparov@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	sdimitropoulos@coreweave.com,
	Maxi Saparov <masaparov@coreweave.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] kho: do not reserve scratch memory in the kdump kernel
Date: Tue, 11 Aug 2026 12:18:57 -0400
Message-ID: <20260811161857.3096-1-maxi.saparov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803193938.8778-1-maxi.saparov@gmail.com>
References: <20260803193938.8778-1-maxi.saparov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ngh1fzx71dcoqw37zfwwjy3yehp5nngz
X-Rspamd-Queue-Id: 71859140017
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786465148-879103
X-HE-Meta: U2FsdGVkX1/oEHSC3qV3eTs4GDvcqbujlVzNqef+9msw+VJhdcmvYzjNAhOLrBbcYDPi8Cup52l7OYbCEqrdEGNlDNlRWCvxAvpvHMnzV9gyVNKQyN37RQrs3hIvEComfIJqSvqcAH61mdSZ4OgI9pmGMw86iskVjfseCbu3cQDPfBI/NWtMBLaQEQlpqtL4oKJb88h2x2dbVNUeGUHwPMHzTDP76r6qu8naLc+547/EOPe4t1Y3EAZswDIcUFaG+pVkRuSQjVZDNj7t0tLka4LE0GZAUJ4SyISQeEGOEoz79PNe27+cjNUo5KFPQTaB/J4Cm9tTrr0k6qZc0ffOQ4/Ij7Gl6FkKCqEIZZTzmyKBDzOZqYax1zvj/XEsDDXM188XoMK5EldkTIeN7dkXkuPhFbBXEx4WDPDi2GHfM6JXqDKp2ljlht96E3UuFWUUJGjk9YVA6wa3XbkZcGkdCz18FOs97AO67e8gllXIFf1nviBhdjdYg6LoPgstP5oya93vpmixtM4LzNQbzMdVGjgbN9KzVjxCZ9d3KHsF9q4y3T72qxqSrg95P9wHUgwhEyq1xmuf2DjQ5D+qMNDs4xjqE2NiMdT1DN4YsOUooY1MLU2kz2GCHi5F67u5KNNDaXaF44JH7KONRjPvDMyUuSbiUIn/cIxtL/glpkExBrysvEqgDgBlIC4GdSeYr9nJHEouTpLUpVC6Ab39TWS3iMn3TNccu2JroyOGhD6W27Eb7uany4KuZph+he2Jg0oj0xdsQ18uDcozYD37KyGOdmfoDvw9Pc3WL0JOIcgfUGmnrsqFCMi5qxOqH/La6FENJCkfLj/BkqWJkKpKXJJnT/99bHVvK2NwMRfIRpTbLAYNAwGESe97Y7uTAHzWalHYIzwxkrZLOXYuLE3u7JlMESFnOQJtgUt4iCDZ026DI6Mr4USlIWwYcj8AtS+QH7ZA3Nlbo5Lk2vA5gQPNv4s
 a7Z22Afv
 I3r/d0xqLcKIyvT82P+1oHC5YJZTsrp5c3vuPIGoJVaoJHGaBrcUdVfCuaGIrM4u2tNbkPA5utEqhhiQ5I1ZJ0xLmuwvXJcS2/AWMKRUsdwPDIRylpMWkEBGplMgLMqDlCJg3Maj8EpKc7lDXH/wXxeODYt5+NezVC8gWHFkipOEUa6O77Nl4qgLP5j197tzfQzLU0hrmCiRucb69bb5i/KEDySoOg7R1QTQ4ve5cKObf3X5vyZF7qPZhYhuW4Beva4GShbQMNwhg+oGafS2FC445tsdDk3Xm1S7cUbscEboB9XY+d6WAtHAgbIm3TBYQSEoqy8vK9o0CPFop8nkItAJcJox/SJj/UOxTDJGGiCDI4+TuIBPg8EUbTxvo3eZWYLUBu9xb+jqixaRANO2OL4vT5WkLvqiBL4668AOA2t2I4TkVi7B6dQSr93JYMJ7hsfGt3vTmbZiiuFGRHbepemKwR5Yx9t+7waY1bhhQwOGPDoluUqLABp/LrarEvAntJvKcCxGX91XosuC55rm+RT6eVDkfLYC9Nh+G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maxi Saparov <masaparov@coreweave.com>

If a kernel with CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y (or kho=on)
does not receive a handover FDT, it reserves KHO scratch memory in
kho_reserve_scratch().

The kdump kernel always takes this path. Since commit a6715d7ec472
("kho: skip KHO for crash kernel"), the kernel does not add KHO
metadata to the crash kimage. As a result, the kdump kernel never
receives a handover FDT and always reserves scratch memory.

The kdump kernel boots in the small crashkernel= memory reservation.
On our x86 hosts, the kernel and initramfs make approximately 176 MB
of early reservations. The scratch areas then use approximately
650 MB more of the crashkernel memory. When a large early allocation
fails, the kdump kernel panics:

  bio: can't create integrity buf pool

A kdump kernel has nothing to hand over: its only task is to dump the
memory of the old kernel and reboot. Fix is to disable KHO at the top of
kho_memory_init() so that the kdump kernel does not reserve scratch
memory.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Maxi Saparov <masaparov@coreweave.com>
---
v2: Move the kdump check to the top of kho_memory_init() as an early return.
v1: https://lore.kernel.org/all/20260803193938.8778-1-maxi.saparov@gmail.com/

 kernel/liveupdate/kexec_handover.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6fad9152387a..97729dec6359 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -12,6 +12,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/crash_dump.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kasan.h>
@@ -1631,6 +1632,12 @@ fs_initcall(kho_init);
 
 void __init kho_memory_init(void)
 {
+	if (is_kdump_kernel()) {
+		kho_enable = false;
+		pr_info("disabled in the kdump kernel\n");
+		return;
+	}
+
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 

base-commit: 3a0b8fa2eb36afc88b62a95f33f0c77c71fa5ded
-- 
2.55.0


