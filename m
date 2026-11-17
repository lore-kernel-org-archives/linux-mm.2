Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBEC606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=JNxW4gAU
Received: by kanga.kvack.org (Postfix)
	id 91B306B05B5; Tue, 17 Nov 2026 05:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC566B05B8; Tue, 17 Nov 2026 05:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBB86B05BA; Tue, 17 Nov 2026 05:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF486B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:19:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED036A7E17
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:19:19 +0000 (UTC)
X-FDA: 85444213638.17.0F18729
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 45946160002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:19:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JNxW4gAU;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910758;
	b=YL9ZcPwvxTuy78pZd+gBySy5cU1UOgEWiiLI6gKEHtO0OJmfzaBXYcRD8mIwV7K7CBIY9L
	AelgsVx+EDHstlogYcs8Cgt6hVXPD6xnM8L9iUiWQSdUyLUC+KZQ9cQO7FIhqgH4D3/khz
	Bi/vgJhDk/AmnIZhTOTnmw5kGKVzQ9g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JNxW4gAU;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6tYUDeaUmXci4DtaZ3KGPX6vHUKyaaYpdht15nvdlEk=;
	b=gksUjrsbrg6wyUZdpENsS0v869ootc735/nfPXUqAmR2Y4DtbwyHsASY37aiJfa2R3cqGK
	DPz5COtsPzwaWjz+bmg8aI3Pn8M4Wty++3Xc5hh7XvV2jGCw/o+y0SEYUDmdtIEjMP0VJf
	8AebL97JG/sA+PV1/cQpTvSKUQTYnw8=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9495f083657so431962785a.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794910757; x=1795515557; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6tYUDeaUmXci4DtaZ3KGPX6vHUKyaaYpdht15nvdlEk=;
        b=JNxW4gAUwsm5bO/KEm3SDVsaM51f8J38bcXzbSGijv3r7R9qyxTis9upkj7tIdSEwS
         Z+mdmgEVCpZakAeXhTWoEZJxpz9e9l/r56mw14M4b7R/qqLb992FJcZ7ccbQARJvmT0e
         8Mnj3Ra/LVd52A4saIUEhfDLkXf06KwQcewg2orKZGcANET4ArXQXBZYa71d0JDVSIOB
         5QmALhiNdQHYhZFgwXfn3eGSVtM83EAQmEtvUrrcUZ+z6ZVHXeU1iqzFSmtWlyHSC/UT
         xmXkSTZFHeSqRzuFD0VIixDTP4HefS+oxjMlVgddcsct8uYDI6HtEYp0JL0I15cGZlGM
         oTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794910757; x=1795515557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6tYUDeaUmXci4DtaZ3KGPX6vHUKyaaYpdht15nvdlEk=;
        b=pLCrDgkc1Cxi0EaBivvaqdU/BbKX3IoQBQ2c8X1MEbsnrOgSZKERB07LRsV7I/B0/L
         sOb0BR+g7QAKnLbnSzQpEW4WK1c089sQR6o+jNyrl01yw8Nj/XjnJS0dX45BH7golkXs
         e3P96iWAm89IzGN20fsLFQI6+o4SXJUgST8LndBRjAWDSZu0/NEeCKXgq0vKaL2dJbbD
         zoswq6xBYc+H8LRwe1TiwmmgVZ+LIBBVUxPAUt4L4eLciuu1wfjH7vrxiZyBAMUdF1KD
         E4FwC3s7RPaLojmRbQ+uGc2GO+3+pc0LIlbio6LxuBrwKLDBf35c31T0k45Kcin43Hv+
         O4Gg==
X-Gm-Message-State: APuU4Z/+kKRzCJ626c8xny8f4+qbKhQxm7z8ywKNO1y5UFe8gTv3M8cC
	PtboZIfGT/eXpw6e6zpDK+QAktqUPkCl0Lx72qSWyrEUwaGfR+HFhwCjduaT3fI11MX0ZgHQC3L
	aBVko
X-Gm-Gg: AYBFou0l8QTRHoQC13G4T30AH/5sdCXkQfHoyGrnGnaVp+WFhdqdkX1k8eJPfF39CQn
	w8el/HeUrHVb3CAbT4Dt8yM8VG/U/xUEl8lNsOpfoDfzU0uELM4ScOUlI34fPxulspKgwVzTZ6w
	tKAF9rBLXo7E+HP0EBjIW+MCuukkQhn2rpthSI49m8hapH3Ydw0L/j7LgU5Fxa2znjBtlmQy6Rj
	7pQ0+TfcU/bTUkjobLLJ5mJyUl+5RFZmTrj7rLX2bOOPL48xFcg/eNlOa2rGU97MIgpIBVJk9TM
	W+8vce2hjwST03iIZt5Bb8aacxxmN+RBJHkeeMmCONCDN7Y0yhZENp/CjVyIkRvyK0GxD0iiRnq
	78dI+bKISDwgqyLU6lv5gXzJYVFukuz1fl1gVG1Mi+0yAUGPF22OxwjtBJYnQbJ8RVZkIoK+wdz
	j4yx8tHm1cFMXx5MNLeiAZ9CZN6N1md3AZTFYWr/VbKuusrFtPe2/sKugPf7VjRxxpGYnJZDURY
	viBDTHJRMlmIV52fg69UIaFp94vbA5muTRI2LKtzJEdxhLP0sVlSjGjrYpHfIlGWjnyIFcrBTPT
	xvlS32ygm1PoUirxdiHXiuRw3w4Y+75jl76+l2rEcgvyatxInlDoHNtPieNhe1aDOwlLwZHFxXl
	bVdSgf8+2I4xNhWU=
X-Received: by 2002:a05:620a:4048:b0:93f:dea:3b7e with SMTP id af79cd13be357-9494baf6928mr2132633385a.24.1794910757471;
        Tue, 17 Nov 2026 02:19:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9496bfb7fa0sm719926685a.34.2026.11.17.02.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:19:17 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	arnd@arndb.de,
	larips <larips950@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/mempolicy: limit compat bitmap reads to the source nodemask
Date: Tue, 17 Nov 2026 05:19:10 -0500
Message-ID: <20261117101910.1820066-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 45946160002
X-Stat-Signature: 49w7orbxrsxzdpqni7adpfzg6ubw5di6
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794910758-613347
X-HE-Meta: U2FsdGVkX19i0MFk04bYTjob8FignJL1FSuUCQWQzV+sNRYzNdxyCr0ZGYUYJbZfA3jWGV+7LRQiNWopWxQh86tCf9AJ1pdrWjKdaNHVsftuWDVWy5OFWQcdClsIUiLQ37ZhSD5b/5F/VmLhmga6G2kwSXtcnckSSM9mdSRB09SbeYY0Iy1c2/R5aJebthSJGy9BLsTH+v5M34RX5kDQJnPfNIVBsTzl0GzXlIpOZZRLsuX4tBwNYFvXqyTbFAHm89itEvwRS95XcT3M4OG51AXeGtBuxuhjnV29lmR50pirJPFwN7g/iSE/qdmP6dcTplLl+5g86fCcgubt6bc1MOBa1bWIxaMT0CtZkmVxcQYxMBXL5pLypsJZsh3SNY3ovB2+Td6z5FWaztwEoCJfEazxiBFq0hhwfSpSu6IUXPbfBQSkq5nIYMl4Xy0g0JpBRASsewYrO+JPMv2Ax7FwKxca11XiO+q64vkuzQmJyJDPvUoxADqy0u8GfhHasTmTtr5ymLEFmQCeiSjni6BvYKx2A4ZS5y8vPQD0AEW692VjFwYCl4GMRtturfuMCNOKy3QbO3x55r8rc2WygGaaUFIRlPRyaOhbkoPg8dNZINHIWTqlbI9mOLmPkvlcqAFtiL9ySyGNOAbCeptzwI1ML8LXtCxQgXBi8Vkuv3+qEEJPZfntGwHQVFvrXxeSHCgjBlbcYIsIZirlWjq0xelE7AHw7giIs52dNjI7d+FZVFf2DkkMUYbCe8BY0NW46NAqzlfk/Edx7r/k5yeUf9Gm/hRNaidnE53VQVFncEkIMQyOZSL3vGal4Z4yk0iZnsAgMxX58NQvvvlD6ekTIrIN8nmaMfyZyiKnupY6VA52Xoo4F40istbgHp5l6AFtlaLNYqPyeg+gVDQhuyMNjQ87XcJU8sZl52LUVkWw3skov+v0hohC3ZRmo1YyDER36kTKwxx7z7xSAm345vV9wb4
 rWNIlKx5
 6YpKKsL0VIjHd4khEXonb92kDp/+m1r5UD19Tzzti2ARKmVxPIyrNxdel2A6EQZnTAAmeXxGshMVce1MvCmutdXk874sVyjr/OBb8kiZr6caIPECnS35hgwWbZHs29e5ToG9xEYUJbIXVud75bj4earZuig4pfzl/d15sGoyT4phLvDk35/lxU9yDQZnQFwUOMDbNSQPDr8eks9CMm140ZlfZdMrzkSP/oNKcpKAxkGjxKWzKP/kE78umICxZmx1Dy/er5NtECOuwNTsk1DKMxGuuTX+JsC4OOS+RNYcc4fzMmWwAKNRo7kLKX1psTNSxoa7ZHjIYvxggpu7jabazANAJpZD0fEEPe3Yeqe831sXzfJeY9zC5tvKy6nqcvipadhiFPWtS0+k67FHpNRU1uBilBi6M3uYDI2plHSLqh2Ip0Oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A 32-bit get_mempolicy() call can read past the kernel's stack nodemask.
With 64 possible nodes and maxnode=65, copy_nodes_to_user() computes an
eight-byte copy, but compat_put_bitmap() reads two native words.

A kernel built with CONFIG_NODES_SHIFT=6 reports:

    BUG: KASAN: stack-out-of-bounds in compat_put_bitmap+0x113/0x120
    Read of size 8 at addr ff110000099afeb0 by task mpol32/246
    Call Trace:
     compat_put_bitmap+0x113/0x120
     copy_nodes_to_user+0x137/0x200
     __ia32_sys_get_mempolicy+0x1a6/0x280

Bound the compat bitmap read by MAX_NUMNODES.

Clamping every call to nr_node_ids would remove the extra userspace
word when the kernel nodemask is large enough to contain it, but this
keep that existing compat behavior while preventing reads beyond the
source allocation.

Reported-by: larips <larips950@gmail.com>
Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 79053ece02cd4..d9177c5504879 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1715,7 +1715,8 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 
 	if (compat)
 		return compat_put_bitmap((compat_ulong_t __user *)mask,
-					 nodes_addr(*nodes), maxnode);
+					 nodes_addr(*nodes),
+					 min(maxnode, MAX_NUMNODES));
 
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
-- 
2.53.1-Meta


