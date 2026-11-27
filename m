Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37867606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C1I0T/nS
Received: by kanga.kvack.org (Postfix)
	id E57B96B05D3; Fri, 27 Nov 2026 04:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F656B05D4; Fri, 27 Nov 2026 04:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F396B05D5; Fri, 27 Nov 2026 04:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD6616B05D3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:09:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06498C023C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:09:28 +0000 (UTC)
X-FDA: 85480325616.24.598E57A
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf25.hostedemail.com (Postfix) with ESMTP id 36932A000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:09:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="C1I0T/nS";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770566;
	b=6GCC+kqq/8oZdRrlEklW5QuE5gMVVVXcC7jQ+bCfEwyOMNEXJFFRIeogxrrl5gc5pSqEc5
	wz83zvxGK7QrGH7zoKrptpFfTad1323juJf4zXGVCm1EH1TUEDriMtPZK9EdGYsXPiO4TN
	DGUS3/TnTde/82XP50wCcGEgup/FEXk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
	b=t/nZ83dUuBA0GeKFeFoZLEylYjWlJ3SEGr3obeBJXVNB8jKJzHNAGSPgGZfg8bmBJ80JQQ
	CyujwQxOsx0Ms+lrfxuIOkViwJJyHkSlVGEnK01Ie87Uo8nRelbH7fBWMTFsG2oXrLYQOd
	f0YjEsYCtpIeaaHXjOdjXFh2YAvMAjk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="C1I0T/nS";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f11.google.com with SMTP id d9443c01a7336-2ea993271f2so32713605ad.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770565; x=1796375365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
        b=C1I0T/nSQC9KX/LU3kVZDN8FkSfW6kJmBDdG+9a/ygr/pmdAT9a/uOVh4N9/G7DqMt
         4UdiI/DwTRxOG+2K2mQGHx+66MD9Vt0AkOneyGU/fVfVR4JJMqx4IoD67Day+0cPPlxw
         LSxpsTk8n6s7/yWOjc35deHNEGUthVKEkfKlndFgJL+2dEa0dTVplP3uKUIjC3Z+ICI4
         88NEfEJZsbshSIA6Hw5Ca7xKIoRXjlnEQc29YSm145Xm1L+2La8zCjSJZql+5XT6vtqe
         ExbZxezQDrig7lvX5aJebP0kfU+1hCUxDkvtyWBBqIm6+twBGoj7aHKVY2fnjQUwC5+Z
         kkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770565; x=1796375365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
        b=w66YVxhLtpkipUrT81284otXwQmYGHdfxRDbk2bnX9LS75Gt8z1XOd146VT7memJVk
         k5FuJ4gskaxhwzQg6h6ihImVt8wbyk/6FOPsOWLlJgpXuFwcPquGtsZWPNedsXCLWi+Z
         rF7HMDgnXNQ+efZp3Xj5L0jgML547Ow7YXc5mmIwpafHi5FZY7QMZr8BczKkKbWjCp4F
         vNPYWpPSewKj6wzna5gQ4Bjju0nBTt0IzGAQcjD1U1DHJ9w/6nrpQnSs2xJKi+mHGa1z
         wZIl0obBv7+L/hoSiDy0c4zSHGL+ql8uc8gQMONwe3EAOFylUs+Lb3TchU2EwNe5r+JO
         1Zvg==
X-Forwarded-Encrypted: i=1; AL+hErGrbkDW8+z0muWTD9xYgzhI0yjKxpVZLZJ/vSh/6D920M5FhsTUcz+PqzFOCpNNEMOEW+DyMPdT3A==@kvack.org
X-Gm-Message-State: APuU4Z9twx5o2ZWYfciPX7BhpYapLh3AqWZwHHoYdDZj+rSIsHFX5dk3
	uN5EdxSp9Lnm08LbrQhYc2H/ILMcijAJ4GnJ/2WcYZbzfGct4+GNzbve
X-Gm-Gg: AZFdTZe53cXI7XZQY112v27CxLVjtDErp7Oou9bAH3QbWH+w9QbkP69TeRbaoeFOfFE
	BuOMiWF8C4GrH9baZ2iJzeJOQTURYHloJnmfnKLPBn9imxqEppXmrQCsXpfY165Ag2mobiDtaoe
	VSGeezf7W02eZnfz2oEC99BaAiFah1mUn8d+iLTPpK+7ToAJY7d/WF4uUCwU8c2N+ej8x/mNc84
	zVVpzR4AMvFUV6+giy4kGpzDiz6SsIfxswBnQX7z0vNhkVKHxGRHynAZmxfGCPHp+NqsbeUyU0d
	I8uLwDy5mongsYpOmoEe7LiCOmJ1Ou5s3wunMKMZs3pA6b48ZtlLLI21rzj8CGhorhvx+6wbMJf
	eyG/Tng8N9+6NtnmFIJ35FqkTZrZZz8r9iQPc5ZLKYmUvve7WDO2ppx0TdB58hxHIQN7IX+0Fgt
	r+Nb6pCGhQxDcmeAgZ9gSyObXs8sZ7P8b8qw24bSFY5w/IFsjpw10k0RJCdqd7f+Wbk1jqAl+Ng
	C/t2G7y1yipLazdDBBQR8KMmoPGb+kzXpYrtMpuQQMogvhJEQwmrOil3W97iqC5MH5ylTyvof91
	qEj/Ju9QQCM9J4bhcoc7eLaoPoW0ZhPGuDArYETtqQ==
X-Received: by 2002:a05:6a21:3a41:b0:3e2:30c1:fdf6 with SMTP id adf61e73a8af0-4014e5562aamr21306213637.89.1795770564971;
        Fri, 27 Nov 2026 01:09:24 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:09:24 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v10 8/8] crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF header
Date: Fri, 27 Nov 2026 17:07:23 +0800
Message-ID: <20261127090723.741253-9-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127090723.741253-1-chenwandun1@gmail.com>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36932A000C
X-Stat-Signature: tw9upgh5mm9nsnt9e8eqoc5p34phe45m
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795770566-917228
X-HE-Meta: U2FsdGVkX1/Xt3lJSompQXOe0rnH7jHmFYPyiv2kYP7Zxn5o84DoFfj7Wrtjk0SjxS6il+T2aOQJO5pAWqyCoijZUY1S8WhdvcFaDh0wLNKdib0T45oVVDPnHMwKsvoDMq94g/tQGAbSBsJW9/N4+4z4hRXey3bCvJFEmYWOUXWqsESEo8ALQL8FRshCSPgV5uDUn3REaXtmvgbDA8Vqi1CDjDdMP0oKqANB54gd7lA4iOLQhJvk7N1EBLgSWvw1QTMHzTk1E6MqmcDm4p4Sa4Ck8xGcUTEHE7S1aHbEpkzm+iUXURlx0AVtIFOiOVn0KxP27YDZL0fa7qy5r+I1A4sELy5dDVGF/EVlJFkqCyCOi74PYrUnAcPGB8OHGtHSoGCwiuU/t/QV2PhiEssq69+ohETwfOnbambuNNV9hcLK2+13+b97hlACxGJs+dakqfHKzIXfMzS0kusJb5S/cgxAPT7HuU9H3Cf3sz98RkXWkLsaTWZjDhB004xVfSmMGT0AwMKTkzWBeT+D0QseJYmTDmn4clhdWf43wX0BduH8pd8mGy8ji2WzDKaSdllCHxZIdWgJ9B/OLUdhA/XwPNzL12LySU0cxgKMs+jSkf9znXnCNnlFb8ATvVTVnlUae7o52EfUb2LY/4QaqZTfM48poOp+5TKCITHUh1l2evtnuEnja7PRjB6PpJQGN0il8ol37VFFZBlhLZWeHHfTeDcdQ1BknsqC7Lx4b6Y1oBA5D1nGb5dkUAZNLpkkcENzFkKUopozgpaiAOBYFGbHQ0xwuT+6clFg2YnB0buPbFFXBcV4HM/sYq59nHhma7w3yCIwWT/5aso9F7VvHV+NUVwKnbArGCC49TQTYM2tOJ8ZIhqCFAXlfPIsVO8jfQMO2YSA6l/yq9w3SEPGL4MWHeBVJU4cV1FAbwGzvsoytIILimvC4+1dmOhcBlEf96W68gqPxUkSYo5UHfAxwVV
 2xGOsVR+
 DHrcAMUnTzjgpTzFeTV/K4C5XBZm2nmyr94jBpIaBqMlkNufNUxcNhb+wtOgm3GjX5mcRT/LZ5oCBohASLg7+1unQkllXSLhX+ToQ8VJO9gO1stGEJBVURM9BOKKXfbvSOyaYoA9W6my+KzT7o6pyfVDN8kdMM/Pv99HTmHNBdl9uc9CIFoBthR4jyZz0n0scwvacz+V/mAccFDr/WgcwhF0J0ZcUEcDTVoZ1eNGK8x9n2SvIkQnklFTreFHdCnxorR6SzRjvooJ5COwzijrljICwW2DuGUy+L72qMTAh78Wp3Ina1aUcgqoOLDwBizLlcT20nT0XuXsMq24mPH+9fRUYqOsHNd/tlx6syUV9dq7j9jMIC/TUKUDZqx+fywo6VCc+ce5gA/tmqYYlIJ3tOAioh2axO+5puBgX+vglEChwFeeHIPTiW82Msov1cgnONybe5OcTxOhtD+JG+8P+GhUKe9A/s+6yRCAij1DEPTDhqdqU08NUyhm4F5dOW8pvoVzaQShi9gBMd04mIZGbmHu8uTP78aFHGbYhOZBQrzDdljaVpgfRH4Ee6PQktK+RR6vckT0TI9BDTHlTu1JXEmy8vedKLU+u5cmlqjsmCrg22cbYmfWDoDh7cXg4V4KaoclQ5J8/f/4jdN2I80rQjyKP22uYRed5LRG+chGU9iGBVZ1K8OtMOzlPf5xiO6dEvSACydTRWmwaclbpl2J306tAQdUH3Nso+892leo8XuyHw+slHQBqcHsbEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Reserve regions (for GPU, DSP, ...) carry no data useful for crash
analysis. Exclude MEMBLOCK_NODUMP regions from the vmcore ELF header to
reduce vmcore size and capture time. crash_should_skip_region() now also
returns true for MEMBLOCK_NODUMP.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index e161c8b65e00..0e2ddc933b22 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -283,10 +283,10 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 }
 
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
-/* Exclude NOMAP regions from the vmcore. */
+/* Exclude NOMAP and NODUMP regions from the vmcore. */
 static bool crash_should_skip_region(struct memblock_region *reg)
 {
-	return memblock_is_nomap(reg);
+	return memblock_is_nomap(reg) || memblock_is_nodump(reg);
 }
 
 unsigned int __weak arch_get_system_nr_ranges(void)
-- 
2.43.0


