Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D34CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 03:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D3F6B0007; Sun,  7 Dec 2025 22:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814D26B0008; Sun,  7 Dec 2025 22:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729DF6B000A; Sun,  7 Dec 2025 22:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62E716B0007
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 22:50:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3ECB13460C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:50:24 +0000 (UTC)
X-FDA: 84194926368.18.8046369
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2162F40009
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:50:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iiOhRbA1;
	spf=pass (imf01.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765165823; a=rsa-sha256;
	cv=none;
	b=369zEe6c0kNmbnnrWl/qErtsIOkn6vciE7Bvn9W41/7eSoJa0B6DiK3fDR6ZrXqcmKpDbi
	kWTWsX5q+vFgvVe3mefodMYON3jRDSRJ6OPqGrqrH6r9Bu33SU/wG+STrdhgbAZBIrsE2k
	ZDESIXydfHtk+Kjl1+3Dfn8dlhX9hr0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iiOhRbA1;
	spf=pass (imf01.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765165823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQt8uoJWMBYj/YlVtM/kz+RuiqvE92xrlYMKIfu5C3o=;
	b=Z92w9fdb/BHdk7o+h7657UYaWpR7euA59+pOx4Jegzq+EE6X5OAyzcvxVRrtdb7AzKeK1W
	Ln5UVt0l1RWFmT+Ej5uh0f4UG+dqJjXp4A86eWTgM5URDBnm7hEw/kYzImvy1BHUyP7tbk
	zdEv7gL0PUDtq0n/xlXV+nZTwS7cEe8=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-297dd95ffe4so35830445ad.3
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 19:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1765165822; x=1765770622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQt8uoJWMBYj/YlVtM/kz+RuiqvE92xrlYMKIfu5C3o=;
        b=iiOhRbA1f9jXIPttcskpagmbP+4dk56mAtWadOEeUASDwnpkrDfQwLVyUpua/wLy6V
         kVbiITLeGkWHRfz1Iz9CgWvDi6w/lo4s68V2FlQ9UnnjR4YxBnuSm4TYWQWhSw0TQ2Ec
         hQacEI6RAKx+gW4Qqs/a7BMrMxpOG+mGmWPHjNqIyuvigTrR3lCXMOTaCqKHpnraQLJF
         2Kna9LBj/YR34jfhmyD5R7JlWMc4/IpQupLUYIG8MODcq3YI/C0qboaWhiq7pIgFzuNz
         IEe8YqyeAnd+fbPL9W77RgKLEwtunc8ije9RfsYofMJJHKj+6CNE1ACWse9cXq8G1H3u
         ouFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765165822; x=1765770622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HQt8uoJWMBYj/YlVtM/kz+RuiqvE92xrlYMKIfu5C3o=;
        b=Ps5OdmnYA2+HpcB5j5pDddoJ8LozrPjshCnMrXJtFU47hZySp44JcYgYiQ8KY7VwZL
         jjHzz17eycH9rP2YLIbfp/KQX2MrAWoeADnVSm0dK+JYWUX2EhQ/pW4tQ5YCw0loOV55
         eXO0nVGK+bFY0xX4vK1smmmaLW0qUY/Ts3mlmFtgO/qCFDJJIUZrTUkpMwOEMgNZxaRo
         u6XknxsiUU4sn8rDkAlOQa/AzzeSRp1X+N4ToZeutrfuDdLbWzgj0oeudmX7H8WkT5mn
         yhLvHPyBdVGwqO+7jgmwUaB+cMzAYgzUnzWwzrPIi9MMwLaXSKsDWGtS285KbGryVrfO
         h4Zg==
X-Forwarded-Encrypted: i=1; AJvYcCU6P2F134Cd+59aiO+tXf8HgyEXSQNkmvCEMx1AI48xEPeEw4JTGPKYy/NqZOWSEq2X++a4hw7Z0w==@kvack.org
X-Gm-Message-State: AOJu0Yw49maF2MFU4r78TN2y2rGYJPO+mnO8q24CKxYF9Y0e2aCdpGZD
	AYe5nn9o9lUffMjNxcy0ArHM4K2piXkWVkyEZz/wb3JVbR6e2rg8FnkLOS9/uzGOkkk=
X-Gm-Gg: ASbGncuPZIIbKf0nscWQqyVezmlfgjOrO81LbBe7NW+AaWg/USRTZAjFR48URTPIgpz
	QkXANe7bdMP62hCgKhoFK7j/jn6s6Or5eLD7zmJFglDv9e+X7YqVXG03HiQ150ymW35idliVhyI
	sRvbCsenkxbXBIJKJ5p4OrNlR62GmNaSHO+tV52KpzZQctCHxeX9PPQAMDfSHGBt/hAxuv8v6Rc
	zpSE1h0xotMgvFdaLmFurVVPGpfIKpnegAgTdg2DgEzmBJISejw3cnXRjUpOG+4WB1P9OX6o8wX
	ot8yejn1blJ58dMufByCG28mqvOTbaXWtaflKrfUOywbvyDUDc+hlnxTiFuopTFVFmn3WBGPgCL
	f/LwAuGULTPf+VXaPSeEdE0AUz4nrrUPVhZyzM7R+EbzZdi02EStN/1us1HZKn+SdMEkY0pnxqU
	jmcXFJFCswcUMg03/t+2ZQJsqmlT8uQcv0R1zw0Rp0BfT2
X-Google-Smtp-Source: AGHT+IG6fRjq+lmQBsuqNIpVk2L76QYaDW/Ee1RxLF8vMbBYaZ5Umod8j+UA/guL3/HnA5D4KRUWHA==
X-Received: by 2002:a17:903:2cb:b0:296:3f23:b910 with SMTP id d9443c01a7336-29df579eb0cmr58912355ad.9.1765165821912;
        Sun, 07 Dec 2025 19:50:21 -0800 (PST)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeae6d96sm108871275ad.102.2025.12.07.19.50.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 Dec 2025 19:50:21 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	andii@kernel.org,
	andybnac@gmail.com,
	apatel@ventanamicro.com,
	ast@kernel.org,
	ben.dooks@codethink.co.uk,
	bjorn@kernel.org,
	bpf@vger.kernel.org,
	charlie@rivosinc.com,
	cl@gentwo.org,
	conor.dooley@microchip.com,
	cuiyunhui@bytedance.com,
	cyrilbur@tenstorrent.com,
	daniel@iogearbox.net,
	debug@rivosinc.com,
	dennis@kernel.org,
	eddyz87@gmail.com,
	haoluo@google.com,
	john.fastabend@gmail.com,
	jolsa@kernel.org,
	kpsingh@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux@rasmusvillemoes.dk,
	martin.lau@linux.dev,
	palmer@dabbelt.com,
	pjw@kernel.org,
	puranjay@kernel.org,
	pulehui@huawei.com,
	ruanjinjie@huawei.com,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	sdf@fomichev.me,
	song@kernel.org,
	tglx@linutronix.de,
	tj@kernel.org,
	thuth@redhat.com,
	yonghong.song@linux.dev,
	yury.norov@gmail.com,
	zong.li@sifive.com
Subject: [PATCH v2 1/3] riscv: remove irqflags.h inclusion in asm/bitops.h
Date: Mon,  8 Dec 2025 11:49:42 +0800
Message-Id: <20251208034944.73113-2-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20251208034944.73113-1-cuiyunhui@bytedance.com>
References: <20251208034944.73113-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2162F40009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 1dc15b5m8gtnsxbotisqgz3psqfrhags
X-HE-Tag: 1765165822-493617
X-HE-Meta: U2FsdGVkX1/YnjWus9F4LObiYWQtRmO4Vy/Be8j9Z8X8ajUs4KFR8T3IDKRWVDsOrwH8arMiBpyxqGZKjSjuzSPcm3U654E56qKN0B6euNcsdo/xuCf9/Fha2ibeF/Xh9eUXg5xJOzXcQmpyOdpLUVl6qeZQlYEEiKM5MoFAtmti6ph7Nw8mXKURu0jwWcgzklLrWEkfMAgeppy/fovDUpoGb43EG2skPClQ4Tp1hCk2Nw9c8d9MTwKnl2hM/wPG8d+nGQEo58otj3nneZ8PdD7XV0LM1M0h/LWLCol6MaotGAEjvAWL1fEJaB8KVRAmPuYXzu8JVgkJQbTe5CP9Ib8DWAh4r1hOUZ7vI7KTJ2uA/zoljKAkRwG4saZM1bK5uYoi3LlpTA40n631dzDhk3Wpe9o1N7Ebb1F7T3Cnjgf1KjHMzpqv0uca3rZvcPx0M8dpbswuhRfpC3amNjY8BVPdiq3JdGBfKywKucOXN/RdQvQMnOST4szsFGuMEhil447m/WNUkimdi2Msavt4yhUisiiBFFiSFjaafQxsxbaCRQxSAW7xp3DTug1aYauWMxadVpeYzz6USTEVsK6AEP3YG5RPdsMT1dsklX6r08IpjRUNwfgq3Z6ubF/0OnRjUScBkgULnPR33x9WfqfWL31WjLE/yDMy9StoiMxqrGhsVasVYqSSVS56nw/2OisW8ikaHkNFfwaVsxgukQ/dGE07sCm11tOlOinXJ2qPiQhyBw7aBCU8qiJ1YQFpCfSpqoBRqStmld9efN9SoOLJ++qCQJdlHEjMAaPEEPG42eUt5lXYCJ0UnEvAe7lfKZBOmXyAct51nXtvjE7ghfajXQGpttJW5l2QXrUz2SD2jkj9BiNK3FgrLbFX39hF6bKHmb40tg4NEqfS0BXEr1+SoagrsSeCHSJzo99miipahQgyBl5oKrkt7ls+/YRsetoIRtBT4G0LXlKQw5gdcuH
 3hiy0a5W
 WmJUI1zwpyH8ir383DyJNXrYsq5PQZvHbzIz/OjRRkg2PZMoFv8jtoG2ct+Yca0RkAXQm1jXdimP9i14msvarTqmSiODFy5eFDO+OC9LgSbKG3RhmmZpXjHN/Xh9HGHCEJHIHJvhNYJtKmolTu8ih6F2m0M4zr+l8BwPgTnRM4eREYudHhURL4H3SDiCMlW5Wjy7YeOs39kFisRqZto5CcPmVPAEoUFqL52/trLaxQRwMGtbBENpbairg4OyzqL4VXHE/fzCnsdacEeO/y6CQMnuBS/L7nmj2v1gblglnX5RsLke3tdtfX8PZb0v7t0peZrUN/f0KXjMwV10YLuCECr+mI251j9hjei/I4QYfLtHyKqmGalXmX4PtlrM6kvGK4RZy03qi70CMB8lXSEi/RkxD4JQ5t0rF7AXcjvJZtY5dXAh4ySDvaJ3w0GvT5EIMd7PM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The arch/riscv/include/asm/bitops.h does not functionally require
including /linux/irqflags.h. Additionally, adding
arch/riscv/include/asm/percpu.h causes a circular inclusion:
kernel/bounds.c
->include/linux/log2.h
->include/linux/bitops.h
->arch/riscv/include/asm/bitops.h
->include/linux/irqflags.h
->include/linux/find.h
->return val ? __ffs(val) : size;
->arch/riscv/include/asm/bitops.h

The compilation log is as follows:
CC      kernel/bounds.s
In file included from ./include/linux/bitmap.h:11,
               from ./include/linux/cpumask.h:12,
               from ./arch/riscv/include/asm/processor.h:55,
               from ./arch/riscv/include/asm/thread_info.h:42,
               from ./include/linux/thread_info.h:60,
               from ./include/asm-generic/preempt.h:5,
               from ./arch/riscv/include/generated/asm/preempt.h:1,
               from ./include/linux/preempt.h:79,
               from ./arch/riscv/include/asm/percpu.h:8,
               from ./include/linux/irqflags.h:19,
               from ./arch/riscv/include/asm/bitops.h:14,
               from ./include/linux/bitops.h:68,
               from ./include/linux/log2.h:12,
               from kernel/bounds.c:13:
./include/linux/find.h: In function 'find_next_bit':
./include/linux/find.h:66:30: error: implicit declaration of function '__ffs' [-Wimplicit-function-declaration]
   66 |                 return val ? __ffs(val) : size;
      |                              ^~~~~

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/bitops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/include/asm/bitops.h b/arch/riscv/include/asm/bitops.h
index 238092125c118..3c1a15be54d80 100644
--- a/arch/riscv/include/asm/bitops.h
+++ b/arch/riscv/include/asm/bitops.h
@@ -11,7 +11,6 @@
 #endif /* _LINUX_BITOPS_H */
 
 #include <linux/compiler.h>
-#include <linux/irqflags.h>
 #include <asm/barrier.h>
 #include <asm/bitsperlong.h>
 
-- 
2.39.5


