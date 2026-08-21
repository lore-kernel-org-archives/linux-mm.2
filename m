Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865CDC5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 02:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CB96B00A2; Thu, 20 Aug 2026 22:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38B86B00A3; Thu, 20 Aug 2026 22:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFF86B00A4; Thu, 20 Aug 2026 22:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6996B00A2
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:09:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03675C0308
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:09:43 +0000 (UTC)
X-FDA: 85123645488.02.D63A187
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40602A0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:09:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FmAOsEU3;
	spf=pass (imf25.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787278182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8d+3ZiWX9W7x0mQXXLnt0fLH62yQs7wA35yLJTsRaS0=;
	b=3l0i9YmzRTUr1YH+p6cXrfYZI7HG2CrJF2tobjLaEh1dehXtWF7qcBQf4+gIO35lr8yfjp
	J6+Az8JzBGXb0Dt6EmZnLWzw98e4nUsLS91AjoBIa2UkgU1fJGJzt4W2ncsZTQmH2TFiHv
	O3/h5eQnUHI9y7Awo+ofZrvuKu+K6nA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787278182;
	b=MSUP+RO0S+t150p8r2dT2/JbkfXIzqspE0XjqmOx7GYlxXjhzHnGW6AO9x5nRzweMGOe/2
	SsDlu1OYPxQ7plOe69iz8ipsWw/QABn5q7FVMJDJlsVtvdYe/lQjiyq3M4qRdfiu07sbmK
	NlVe3y15dFvZeNPOWlQdFv4mWNH2IPU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FmAOsEU3;
	spf=pass (imf25.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d5cad1a6baso4924995ad.3
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787278181; x=1787882981; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8d+3ZiWX9W7x0mQXXLnt0fLH62yQs7wA35yLJTsRaS0=;
        b=FmAOsEU309opm9U60NyyWsBLqydK7ki/PUTcDjaZbc9TuLxdLwRCo710V4YKN42cC/
         BtOyvFXsWJDsSUIJQ+PN9oImH5PaFfwTZZCkjBBXYvkV3C0OsC12cOj9yU3UKXoYuDF3
         LfOt0O4zDJ8mUxJiFmAvBqdgTnr8zp6Kfw5JM5FadWOz7lBlbWeLaWo7X8MPk3ISTsAD
         1Yfk/KvUAq/YjoSHm2P5VP8a9U891gXzfPYAU64JYMITB6yn9b/0woFQpMPaGyrzi9RP
         vo3+3KPVs0IgImtE1QE/EqI6UX/kuuF8SLHBJA3IaRetstbEqMIESXU5RQGhe5qVEfXt
         +CQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787278181; x=1787882981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8d+3ZiWX9W7x0mQXXLnt0fLH62yQs7wA35yLJTsRaS0=;
        b=NkVKCcNrZRdWVrRyclvl8QqHrEGAb5VV7dmV8UAPRv7gKAGYj7+1dSuWzXdTW2k0oD
         By8AfJq1ab7FZA8+VIh5lGpvI9S9l9QHdx9F+UicJt0KMOLl4lTmt+5rzj2vjykbCH8x
         Gi3pPJn8yaCQLhNhguqD1W5S7nX/fXji6zejAOmdwvClMsaKrpdQTjrIVEqeRzN/eMpa
         U1xrjZtNT+k8+y+dGadIr/Rz0qxV5gBVgl3FihWys9juVq9IT34ry6W4RHsSJWqCnAjR
         +LglgS9xH6A+PDXgbq3xw/oAkG65PAKX72mzx2CwCSutvvwBcDxUvFXO9dTJ9xHxnB1y
         eRwA==
X-Gm-Message-State: AFuF++mWDJ+ruQ/mNQeKsNxlZLC/pakLsCW84vM6n1x6jEAypCVRg9Na
	rZue9Gtgu3hICXDexgkYHg7J1J1CE8fHp97N1ABMnB28GKOBjilA9jiW
X-Gm-Gg: AR+sD10BfcqddKtrTur8LeQR/jYSaRBAMCT4y47B0SKPeTRuRIOYPKmha5yV8wgCh5C
	x9W5AK9RREiNSHPkIEg0LP8pGzeYmLyqU0ltMkfNz5wDcuaSsncUVJN2TWyJM3b2xtKzHVeuhM6
	w84C7qfQZLbvQBNRMzoHA4WxYQNHyEhnjWk1kvTUm22fEVGNbLRtjvAL3cwg12gkunwQ51a2d/2
	0heFL3Mmb6essby6zpizbVYIanw0yNdOvb0nYO0OedkI8hrfeBjdtGYTFCK1nopZ1xyChyGHthQ
	dljyRdOUAS1XI4DYzZHWEsPFtFUKu67BCbr60qMXC2ysnLeyRw5R60vgPXHY9iVC6hml11TZmPn
	Ru8kLs78prt7sFQshWDzsncnYWIZ6jiLDjm8kgFMm47n5L5unJl+ln1AhAvaY21dBWjNdCF9DIb
	S6W+WzdzFSzbfZNuU/hxYipkQCmgEJOoKvonv69kZdhV2KaONUA0MA3vp0VY+1+Gc5lJViKk1IX
	YF6WJaFEieGooMU
X-Received: by 2002:a17:902:f78f:b0:2c9:9a2e:dab0 with SMTP id d9443c01a7336-2d64ad92e17mr58832045ad.3.1787278181129;
        Thu, 20 Aug 2026 19:09:41 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3cced8sm12851045ad.75.2026.08.20.19.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 19:09:40 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH v2 RESEND 3/3] mm: memblock: synchronize debugfs reads with memory hotplug
Date: Fri, 21 Aug 2026 10:09:10 +0800
Message-Id: <20260821020910.3428585-4-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
References: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bodm9yf5gd4qw9n8wmuc4xotd39i34rc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40602A0004
X-HE-Tag: 1787278182-355131
X-HE-Meta: U2FsdGVkX1/5IjzvSQ3gyg/FnZAJ4iT2MAyKM70wbrwVGKfIgo7klAMcFHOkixpzGN+mQWirR+8ZJFtcgFbpqohTtdeQUj9pJrp4EGkgZsHhi4xQ3BIKDWWr1XIEf//vV17HcAn/jvqsS6xXttwG2pUSQ12lFoSyGQAQ2AMHPZkTc26p5LLFN/cLcI7Zc4NxhpgtPnUrdikP+S/eu52eosOw9paTWmGpa44iiA/b0lgqtO/gh9uB2bz2yMA5vJV+jgR9kwUV/yUAYrvpgUVw5WRBQ7HcF7e82OnBxzNN7EE1MYMyy4XUXwTDAm8mfzowgCALThzZ9FEMeXwUDCk6PdismtbAwOkCXRHmIdZXJWSfAgB+bQJQyZfZdzszvnm/nBE74qqDuqLcossT88ahnniL6wKw8D7/BnRErTcZOeUtWIjt7wJOJDqT5h7Ta99BOe9TT5mLgIIHgK0FxpltHq23iIZA92WjRw6nOO8riIuby+IrVCm7MJ6GUpgFXaTRh22xT+rJ83XFJFiNyvpfI/S6MXGho49/N0afINGTyeL+GfAJIlk0lgEeUp+neLFvII6XYJxc+FKpMhGvsJBmRRQYHvdH8Uowt0wYxr9c/nlRTTVS7tx7CGRBB3+z6TOYfJDeRrVij8Xr6Vdre5oZVAoq1RUBtBFMb23HlvF3lo4Az97JXlUPgoBK1eRzPegLptyy2ANQSk+9JZpxJiTE1Fj258S9Z17TbLquSvw8TQNgWXP2Ek92fXAH1oepAswhtUY8FwiuF5eykDHkQlG7+IWY+dpCKAoDUzrwYcAGw3nY58pNs1GdibKdOG66ClwnVd6Ll7sjHPID4CB7BzFX1Fq7gOmWP1Gqp2MhJS4SIi57YvoAt2HA5FsLX3trMSG8/mTMVODaEfX4aAhQnjpr4hli7FYxrW57K2rGlV820lCbfrm3heFg39oh4Jn1O2JM462/nX1aCyZ/nXbjE2s
 CYAyEIeG
 I733ppIxo78L7Bvpm7U5uWdsBo6jRbrpkuZdSCFaKYrQ0rNAQePghNvxtKcDaTsrUIm9I8el8ZmmNL2dQioDbgHgausBm+H26SedYugBl5xmDHJWhDHSgWwthdoqPcMdC4GCO/J8W9ovBWlrtprvWoJ4JAKVcKqKYsuE7PhmQO1zzUI4IyQSkelj/ZmJywCDOshEanh1qZ93zp5A19ZW4kPGEZMM9nlLT4wJRnJM6B7i4w9OYfOI4E0VO3eWVyW57BppV79+WkFtlbXUVbF2qgEUMaUb/g20z2D8orTHbRbjRXpo42qqu4eIqPPyQ4Qxq/P7QEAQMpcpMHdAgnf1r0F+lwrszAzOBWrDfPlG0GzsfLhzRRmY5Na8GirFxrNHB+QDw5vWrQbIRHBS/5OZZM+OpaTzOLVYmGtUp9JwHbU2ETywLZlCnpaJM8lim3cp6UkkKRn+eNxdAe5S6Eh4H/jh1Dd5A6bKvr9mFwAXJz33m4vNOm+dLmDwzPOF5Ht2xC5M3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

memblock_debug_show() walks a memblock region array without
synchronization. With CONFIG_ARCH_KEEP_MEMBLOCK, memory hotplug can
concurrently add a region. If the array has to grow,
memblock_double_array() replaces type->regions and frees the old
allocation while the debugfs reader may still be using it.

Hold mem_hotplug_lock in read mode while producing the debugfs output.
Memory hotplug updates already hold the write side of this lock, so the
region array remains stable throughout the walk. The helpers are no-ops
when CONFIG_MEMORY_HOTPLUG is disabled.

Fixes: f9126ab9241f ("memory-hotplug: fix wrong edge when hot add a new node")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 mm/memblock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 36a8d2a9378d..f1ddbcce47ac 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -14,6 +14,7 @@
 #include <linux/pfn.h>
 #include <linux/debugfs.h>
 #include <linux/kmemleak.h>
+#include <linux/memory_hotplug.h>
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
@@ -2899,6 +2900,7 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 	phys_addr_t end;
 	bool first;
 
+	get_online_mems();
 	for (i = 0; i < type->cnt; i++) {
 		reg = &type->regions[i];
 		end = reg->base + reg->size - 1;
@@ -2927,6 +2929,7 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 			seq_puts(m, "NONE\n");
 		}
 	}
+	put_online_mems();
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(memblock_debug);
-- 
2.25.1


