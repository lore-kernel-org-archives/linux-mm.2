Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E228606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dQ0Aj2Gp
Received: by kanga.kvack.org (Postfix)
	id 267DE6B05B0; Fri, 20 Nov 2026 01:17:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FB16B05B1; Fri, 20 Nov 2026 01:17:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156BD6B05B2; Fri, 20 Nov 2026 01:17:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1BC46B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:17:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B8B8120D4C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:17:57 +0000 (UTC)
X-FDA: 85454491794.06.F3EAB73
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9650740007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:17:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dQ0Aj2Gp;
	spf=pass (imf12.hostedemail.com: domain of 3Eeb_agsKCDwiYjcqfqglefemmejc.amkjglsv-kkitYai.mpe@flex--kaleshsingh.bounces.google.com designates 74.125.82.70 as permitted sender) smtp.mailfrom=3Eeb_agsKCDwiYjcqfqglefemmejc.amkjglsv-kkitYai.mpe@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795155475;
	b=s8P9W0j4FQ3YHjDSfpQKdXp+i+rfzUMJGEsahxc6WDaVNZnOv1QCOfmq9Rdw+bUmjQ+mfy
	x0Z0a+Wy5SkN2PZyVhN9vATtg+bZHMa/ZTQBwSrd9MO5dE7GaYg7mgnzueuxC/pvu6Rw7o
	r10BnODRhPUkMFlzScUeBsoM17r4M2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795155475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zGvI4qlnDuwkxAknmqETH4wyE0qutMq1KNHulBr9l7A=;
	b=U8Hj7TGumMnl8pi17PCIi5YGN7HqsVanyG5wUORa9C6EcY5B1urnvbvO6Xm/ZGveYTCHev
	z2SgVgbNe5b+eYQMIAUPWWrohJtC4ga5XsPPwV1hGxV3oqJkBDUvC/bU/1F+6ESJaazAUL
	nKehlaZAFseX3tKsPSJS/mVDvLlA+dA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dQ0Aj2Gp;
	spf=pass (imf12.hostedemail.com: domain of 3Eeb_agsKCDwiYjcqfqglefemmejc.amkjglsv-kkitYai.mpe@flex--kaleshsingh.bounces.google.com designates 74.125.82.70 as permitted sender) smtp.mailfrom=3Eeb_agsKCDwiYjcqfqglefemmejc.amkjglsv-kkitYai.mpe@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-139b62317d0so1576967c88.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795155474; x=1795760274; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zGvI4qlnDuwkxAknmqETH4wyE0qutMq1KNHulBr9l7A=;
        b=dQ0Aj2GpMO9mIhaQnZU0L1twEqWmJAivAofMoqUaHtg2ukOpQPJytXNZGOY25H0GJ1
         nBjDKPGMDMTNPU993ksXgC2L+bVeHgsrTTb34sjmIaAkcCdJUMv8MvDcY1xzUiNuRc4+
         AUwIDt8DIVw0ciJZM7S7wIOalbayu/kHQQ5pafaXb6kPAU7+3w/D65YyiuuxRsJst4AD
         XXknF0j+OqwMy/dMCaKbI+2/HBZ0ukH2veEEerpFrXOAsnyKqIF1UIqQTS/vpXw1mPD0
         r2jDJ5yT0B0XNoIHhx9iKFQ7seOxuvopHFHWmGryIF6n1L/5Flp2gD2S1Ccw/fNn9/Ce
         YPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795155474; x=1795760274;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zGvI4qlnDuwkxAknmqETH4wyE0qutMq1KNHulBr9l7A=;
        b=B5UIzrVHttigE0Vmebh8z1gSQrTlizcaRYfnGzHnnFTLtyewT30l7IQzHNK2ap3GtM
         K6eJ22x4tzF1B0XbOzDrO9oxQIUlPgIMvfdilLtmUJh1A/2ER8Ug4LI8RufCXFaHu8vn
         J5s/oN4p6tBzKAYqCSLPpHgr33cLpiVz+CcUCiWZFhQsyM9KrZo9T+OMypPmac+18yxe
         HXdyf2pssTrmW44JBp5P5sZ/mtW+E1aDZfq/iO6WoHRvuXVnNQ8QZhNY0ra44BGOiMQE
         8/r8sfP3jRCL3FHm1JWJejahXz5PR1aVW1kHWhZeQ+ciDOcZBOLeD+RU6F0kd5aAh58r
         Mhew==
X-Forwarded-Encrypted: i=1; AL+hErFSNVu5kEs3l+CJcQxRArNouArYX1fXS/eDEnvt/8yKtaZYaV+xu3gEIM5eAwr3jYR8uZOAF44ROA==@kvack.org
X-Gm-Message-State: APuU4Z/vOxxyW41pxhNQSHRy6jDEGjA/wd5mMo/LqWsRUzGxGzVzQbYK
	FsL2cDZaHd3QocSEIenguThdDFb1ZDerpNdhEs2/KXnz2mkv3P3Ic4jxU9IePHD1ijphA+1X5nx
	kGhulHRn6Gd/MRVbQnFvyd9vu4A==
X-Received: from dlbtu1.prod.google.com ([2002:a05:7022:3c01:b0:197:f679:f62d])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:7f0f:b0:165:aced:1fde with SMTP id a92af1059eb24-1b5566857c5mr1977449c88.0.1795155473610;
 Thu, 19 Nov 2026 22:17:53 -0800 (PST)
Date: Fri, 20 Nov 2026 06:17:49 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261120061750.2973004-1-kaleshsingh@google.com>
Subject: [PATCH] mm: swap: make swap_header badpages a flexible array
From: kaleshsingh@google.com
To: akpm@linux-foundation.org
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Kees Cook <kees@kernel.org>, stable@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: cf5d5p465xrr5sjywkrnr5axifw531k5
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9650740007
X-HE-Tag: 1795155475-650784
X-HE-Meta: U2FsdGVkX1/OUMuxG9LJDgJyU+Itc9P48379qHQRlHu2spbtwY2y3uGSLnnN7SXdeoEeHIoE2mhsJeeoHO6ncOOgNlA8UoAQs6DVXRywUPzg/Nx0joc668PwTJbTzm+vAvpq4IyAJg/KD6ggGsrVC810j1+KLIlFHUXjGlaUePI3YrpgEeHNS/1W6QQGg85Rn4ybbUiJ4pLAqBN9XnHxyke+5gAm/NZcCZarHGcLEFIsdJ/YNncF6Dqn6W20spaKsJ+CSQSavFzoyvTeN6XQ26wFJU3K9HtZNvlFHy+bNCH8VkR8UW77SR7kOgrtKEqXndVnxgGp5RUQvDC1NCyUlV4gsNHU0jX+jxk4Kr1HHvUDwH+bM9AYzvmZmzEPc58WCwKJjKVksQIUduZZu7hFVi9rTEAtBRvIcZDS2vIw5VEaeHUKizQIUYLH6PkstmFHEDbqZMpWFmrFV0upeP0Ox0Iq/KYr0HpkeCZSfb2SNhslDFXYpH9q79SZ+S1rzZKkY3Xke1c+Br4emMlfGOXJCEgK0wQN6qpRknLu4QepkNqzBiGKIJLpK9hFGvlwBzjdpZPUzddt1SLpmXAmocoIZnMoY75UWg8yYqnPtQAOlAhIW+PjDwj8zrQpVozpCkG5gmvd4ivL6thOMu13fss2v0oavqHM2N/x8wppwk4YvPq+0ljD22/Brd4iqGUsIcMWfS7TUvmvRt0ZSqySGq7BvFDFOv5M1SjZKyrqc8UzdJPVxcoF8bOiefHFX3NWBolTTxmtf+2l7pfLK21MQmeNvbdzH1Phnhu4cjpHQpCSCj9qC80DrCobFr43XTqFuq4BSX+2VUXfbJewOiCav/n5Ap3axxcGJ6wP1eyZMTV7fUZeB+uaiuPWoapCpdn2EwG4KTnM1NxdypBeZ5PpvACaTLKHJEys5v1zUVtMlpQgA7K72tzH/Vxb06elisGevw1IOiCQ4VI1t+Ffm2gOruS
 rewbD3rS
 PplZWLhoMKQAWx/h/oBrdSv00Tnd7I8u7YS47rsJ5XkPbqME+A/WZIHvz0i1jh9HzbgoIrjCeL+NaGv9qyALIVckmgRpgKMcbOotj0tw7BFW6llaFIsIbulpMOZ0RuSx1dwrP9yZQE/bophAsCo7UPDQbTMXBZ7HErDhPuYQFeo9DSy+G+ghyx8KUPgqbxaC7mCDXbNvM+zXFMKA2SdbdupCD/69G2q7Jf4K7fE2x8NQ7w1JQfMmXcPB6E5m39JGl3BTW7IKqgk+zwSH17qxgE+D5w4iOgkBU+8owv9d2gmesMycwrZLghKTeyRjdVsACjGpTUfnTqmxm8FDsUONSZC6/ik7SWB9wv3KMfnmh0buWdZlIJ6yVFQ9kOyRQyBjKyq43yHaKJYr60KwmR0TTEKaT+65uT0xf/wjY1y/+lp1MuSg1lGNvHbRlKnBN+U9+0hcsspj32zWXj7e1iTbj/t7REyT0I96FXaOyHm84ydDqx6S+Kgn48BOspx8nLw2SCJGtEUX2cDeDb1hNKRFremSRj0n76wJt36I5qYiyQSv/84trQtANFKrYHso1mB5xOfpvVy05+WdN/U0gsnDZ7obVuLWt9ZA6XGtPTWecq2xZTNB96tdWWhrexn43OHZjsB54XUX+tMufWfKmDJ4wsw8am5brA9qPIeugS7pM/7Jdjgg/RhXi7Q61+Qz82Cu7WR0E3klemOhE6eymRozV843CqdA8hicsGAgn3xQ8OCrWtcc8OPYF7U27tZTFdj91D3fDTVnFRwJcbS8WxOKCpT5HvJe/BvnSP8mFdbWXua96sqYk/rXQ7LOUJjoiMlPaYwDTSbMYe1SJ9bTg+hRkm9KDAzKI5T8frE3jwYCXp+5Os2ImukUIdtjSMDV7xfXVcWueEsLghF2iB9wHszZMjfKkXJ9jbM6hWGmp5IX0++LT9xo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kalesh Singh <kaleshsingh@google.com>

The swap header declares its list of bad pages as a one-element array,
even though the list can fill the rest of the header page. Since the
kernel is built with -fstrict-flex-arrays=3, the compiler takes that
size literally, so with UBSAN bounds checking, swapon() of a swap area
with two or more bad pages reports an out-of-bounds access:

  UBSAN: array-index-out-of-bounds in mm/swapfile.c:3674:26
  index 1 is out of range for type '__u32[1]' (aka 'unsigned int[1]')

Kernels that trap on UBSAN reports and panic on oops, such as Android
GKI kernels, crash instead.

Declare the list as a flexible array. The layout of the swap header
does not change.

Fixes: df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: stable@vger.kernel.org # 6.6.y, 6.12.y, 6.18.y
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 include/linux/swap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f686709d71f..a3a98dc474c3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -129,7 +129,7 @@ union swap_header {
 		unsigned char	sws_uuid[16];
 		unsigned char	sws_volume[16];
 		__u32		padding[117];
-		__u32		badpages[1];
+		__u32		badpages[];
 	} info;
 };
 

base-commit: 65e4fd942f72a9dba0e4e257290c4fa1aa756854
-- 
2.56.1.750.gf70dc682cf-goog


