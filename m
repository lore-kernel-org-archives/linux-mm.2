Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 247FCC982D5
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B106B00A1; Thu, 17 Sep 2026 09:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043CF6B00A2; Thu, 17 Sep 2026 09:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94B56B00A3; Thu, 17 Sep 2026 09:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9BC76B00A1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:30:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 505D11C2304
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:30:01 +0000 (UTC)
X-FDA: 85223337402.12.B63ADEE
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E9BC180004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:29:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b="XwhL/9GG";
	spf=pass (imf16.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.140 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651799;
	b=4yrX0xTEzpZ7ioa+bGgEniUzNju2OQOlScBql1mtxoB5FhFUoTznozhSjX44lIH59wDe3l
	NSBtfv1VTtm+k8o6IU7U2RMl8UJTou8n2wYFIQxs/LD+K3G39vK5qrSrJ59blExj7lRnMR
	8UM73/fKzEJs4ZvyS/6xV44W548E+eA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b="XwhL/9GG";
	spf=pass (imf16.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.140 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYqy4JvgQiRzCuvqvHp97HhL8V2ft2LLYeHwmXteui8=;
	b=wUlcTeI4rw4t55tulmcLbKAwr+MlSconj1aW8oYnAefX7J1Xc975nt0J5jYjyk5/ld5Cnd
	B0VMegaFSjC/61ohDvRGA49Nua3zu1geLBVupRGp7Mqaf9qXqS7al2fiNKgijivLyuyczr
	YtfC5fvJ1ph1PM7TzfoO377aSUDyz9I=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e66390995so4614015e9.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-systems.20251104.gappssmtp.com; s=20251104; t=1789651798; x=1790256598; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYqy4JvgQiRzCuvqvHp97HhL8V2ft2LLYeHwmXteui8=;
        b=XwhL/9GGExC1aagKX4mVIdV+Cq2BvHVIiGJR0g5jsluQeeQHkjJSqcvn7F/FAZ/pCP
         jWsTValLSKwM0qL6CagErd1vbGD2oBb6bkuv/b+dJyqOR/IWSqsCutxdX1U5ufvGzonr
         DJSchqnwYZJUVZZttfH16suCTg/rDjdvVphEd08tKJEr65YloIkxqSsYUoqQUSz/6E8R
         gs6GIwFrbUHIRfgO3N0IvSrrU3e9zfd9524huOmuB2vvuwWPDIRAlWFOgre1gEeAycxr
         7Tz1WPh2OyoDbx0iAdZ6YlmikbRRPx8yB+BYD9YasgYEpKWddZPDQAexts08nmn6p1QP
         EpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651798; x=1790256598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cYqy4JvgQiRzCuvqvHp97HhL8V2ft2LLYeHwmXteui8=;
        b=nZ7cjdEZ2Lhz76P+HSX640L3c8bl/OhWQuPA/qPxdCHPzt5uVaxKlCaCcXhAXCKjJT
         BWUGWgd0J0QjQMs3mKIchVl62vEG4AkkWFCtHgZEMkATl3p8X+DOE8QXbLkekD0C3GzX
         aEKqCTYXFrN9a6TR9c5hViQAJxhkMShbSwuad5LF7hBvKVms3+ctQ78HRCKPTchiDPIr
         M/tnASYzDrd59O4/TJ6amALcyGPTDsL9c22mUrIVLmdSgc5gso8Jc3Qjd+6iGkSOzaS9
         zJiM8FSj8exmGBJGBPYbx8cLJ8ZVifci6d4eb/+fn0n8wtRPUIC5rfU9gXWc02eL0t0U
         8gIA==
X-Forwarded-Encrypted: i=1; AKwUvBzZCwAzNpraLvaG1RbtU55EwPqFOvxSG25vJ8BjSsFdJM54Ji53uhco9/xXzGO0PMtu9H+Xfwef6A==@kvack.org
X-Gm-Message-State: AFuF++lmwxTQfMp7Z63NgMdzWaGSakzLwVQJlkwl4OzI72DOqeQ1vuUi
	K0iqYDoTC7gZeTsSySTmK1L7I+KzRIjYjVt+hZkjcNPuto3Rr7R757y9ZEW27gcTgw==
X-Gm-Gg: AYBFou3DoI4iQrvPdk8TzYiSkAj+vtHvwE7akA5drsF9PGVf/KfSinafj88upmwp3iI
	YmfHCezV2PcVJQEZJYKQ0hzwf9BMaesVh+17YucFmWEmvF63rtfPfLl7RUYJ7uCjW5PLOw2iuCq
	2laTxthyoo0rVKCk8RWco68/LbwAOIi1GKB/SnnT3YUJGHX9WMxTp/TwNpsovYSqeA0wWN0xWOn
	BMF61hQt/gOHJfrQbojNLojnatDjZVhq4XxmQWkhG341wGxreVcISIlSGGL7GK89TPdg0XLC4qo
	plCWbE1XYho2xmQGK9fRdjDs2tsAlbeWJepRKdAMEiqBbDArd1JO6/2jVgSW8LJAopQXHtdQb5R
	XbVPANi77pIehrfs7MFTv+tAH3wK/MxKfxKJPuPTs6qG0eKqaqlxmXJQBHYwVIDCzU4Qyn0wKfj
	M2LobUBI/CIGE1IV4Se8CdS2MVdAkqEqaMuyG2u6zzznRwvbUFjjpJbGcO06ufMx96i67Ao1TLK
	WbTbbnYqwtrId86N3WeuUwdqtE=
X-Received: by 2002:a05:600d:644f:20b0:49f:c199:e1e2 with SMTP id 5b1f17b1804b1-49fc199e215mr12253705e9.28.1789651798061;
        Thu, 17 Sep 2026 06:29:58 -0700 (PDT)
Received: from fighter ([216.128.28.240])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd2356d1sm97548275e9.6.2026.09.17.06.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:29:57 -0700 (PDT)
From: Sean Rhodes <sean@starlabs.systems>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Evan Green <evgreen@chromium.org>,
	Sean Rhodes <sean@starlabs.systems>,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>
Subject: [PATCH v3 RESEND 3/4] PM: hibernate: permit encrypted snapshot device under lockdown
Date: Thu, 17 Sep 2026 14:29:49 +0100
Message-ID: <f237b56e8444ea7b477dbcf4aa6dafd2ff0c1dc7.1789651778.git.sean@starlabs.systems>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789651778.git.sean@starlabs.systems>
References: <cover.1789651778.git.sean@starlabs.systems>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E9BC180004
X-Stat-Signature: fiuhems9uh86e4iyriesr67zynm1fhfd
X-Rspam-User: 
X-HE-Tag: 1789651799-623562
X-HE-Meta: U2FsdGVkX1/ta/WiVhLHy5rsks8aFqzXGlDnUSSBNuxTYX+8pEc4gA5MPaIS54JOOQrjG78NTTaFW8Uqq6T3zrNtQclltDmCgTKnLxFfitohLC78kK4NI7Nk+2rXsKb9kHX+GhjpxaaFNgu2p3NcSc1+WkgAasyyCKOrvr8PDUg6zTifJ/OpkSplV9e4ANk2PfFyNv6UzjQS+xiCH+vtNmVE5QFFhAEMDhhkrKomxXcl7le2RuOL1mUEGBjPZkCyKAkMChFFtojx4kB/yz3Y8r7FbiUXe6GfgK03iAkpfpmtdKqzaHwg0UGsmNFdMgcdfTGSg4svCVXWQL1jbog5PetjWXwHgq+c5IGPMIYvIkrFvOFek8ziEJQoC4Y3mlyOUWdt+lQ7dexPB1lgBA2c+wZI9i5tzQs/MrdYvFUk0niZRCD9ztAKJ3JrrPGx2OiJwEf0s4BlitbGQkDBQfVzQjWHUr/8v2AB04EouZqV89JWVTSvS48Ehv6w0L4m7ngmzafb8vdYxkug9iD6n1GsYEFo9dZ7YiBFx94kE0ntIoK/p6CjWFzcOA3WQc1SQbuKlIzjowqU7v6AYe75kUN/82eHCbCtgyguYkBjZv6ZM6MxxF5jX/67AFraqHEJP0ylDbOCmDpl6V1qOc596oJS3ZuJXtZXMRnuRmeBOt3QQsPBeYPXXw2gtVmmasfWs3cLRjeQNuw/VB3lgK1mii5S9fx6KndZ1J4ANE34sKwsF4FSljeI1xtR+HSSXV/I2DaZ51FpLMqYC5j5GvZcxKIpjW0TGiZATMQBZ36HjEHxnIofTYTVznl2EAiqc/J3ThuwWGDKAK05z/UGoq1NNqH0WAanPT7/MrHV8cBJLq9pPr+BRC+kGiZAyQKu/Ci1Owu8rptKyBrThDZfQ/Oy7NC9Ez8ICqF/a9nWneznnyBvJshIwEZfwzXU7jES+96k14HJSKcXGhOzWqlSzhPCq3g
 p3rLke2v
 eDWJIR60vokoEMePdlpXIty+UtTs7O9FFfjka2GhbpNSL/u4RMN7mqmTjJCNZZw5C6HV3nMTUc1XZP3a4LCUmnBXAe3TdAg38SFgSIDuYxa7tbzeaMb0rldC4dImtrjbFVB9oHX7KDcs6w3tLtdQzaJH2kXkrHF6lptYa00HuZUTBWXOMlKpU2Q2lIjMb0lrLLvdDmiyNkvpOdUcjpcTEnxU+u9a3gvF8NcGctFCWYc8XAZwzdhCgeDWTMuctJbgn++u/KTO3bhHEmBxrN05ruSWz7uAvQSQ0aM4iF9tovLl0uowPKpKAPxPksCbLyJ3Ez7SaCgbQLKPSm4yzn/t38iJCvdJWtun69Z/xOQ5Z5QaoU26cKb1c3sQaSr49QtRskDcEYucS+blkzq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lockdown disables hibernation because restoring attacker-controlled image
data can modify kernel memory. Permit opening the userspace snapshot
device under lockdown when encrypted hibernation support is built, but
require encryption to be enabled before image data can be read or written
and before restore or power-off ioctls can proceed.

Tested on StarFighter MTL with lockdown enabled: encrypted uswsusp
hibernate and restore used the snapshot device path.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
---
 kernel/power/hibernate.c | 8 ++++++++
 kernel/power/power.h     | 1 +
 kernel/power/user.c      | 2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a95cb447a13a..0b8626bdf81a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -114,6 +114,14 @@ bool hibernation_available(void)
 		!secretmem_active() && !cxl_mem_active();
 }
 
+bool hibernation_snapshot_dev_available(void)
+{
+	return nohibernate == 0 &&
+		(!security_locked_down(LOCKDOWN_HIBERNATION) ||
+		 IS_ENABLED(CONFIG_ENCRYPTED_HIBERNATION)) &&
+		!secretmem_active() && !cxl_mem_active();
+}
+
 /**
  * hibernation_set_ops - Set the global hibernate operations.
  * @ops: Hibernation operations to use in subsequent hibernation transitions.
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 815c84c1e0dd..351b5f68bde3 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -168,6 +168,7 @@ extern int snapshot_image_loaded(struct snapshot_handle *handle);
 
 extern bool hibernate_acquire(void);
 extern void hibernate_release(void);
+bool hibernation_snapshot_dev_available(void);
 
 extern sector_t alloc_swapdev_block(int swap);
 bool swsusp_swap_range_allocated(int swap, loff_t pos, size_t count);
diff --git a/kernel/power/user.c b/kernel/power/user.c
index de41f590c98d..b8d3342f1548 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -184,7 +184,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	unsigned int sleep_flags;
 	int error;
 
-	if (!hibernation_available())
+	if (!hibernation_snapshot_dev_available())
 		return -EPERM;
 
 	sleep_flags = lock_system_sleep();

