Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DA0606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z3tEceNN
Received: by kanga.kvack.org (Postfix)
	id 28CD36B05E5; Fri, 20 Nov 2026 03:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264666B05E7; Fri, 20 Nov 2026 03:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B4B6B05E8; Fri, 20 Nov 2026 03:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3A906B05E5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:37:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8336AA0E25
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:37:17 +0000 (UTC)
X-FDA: 85454842914.22.A24FDDD
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id C325BC0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:37:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z3tEceNN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795163835;
	b=rI9/FJq3x0Xces3D24qWojia/Uv+oK4gocqfmQQdhtMkQr9lxifZBfQDULPLNTMnV0o12a
	fICz66pceXizqgqePCrHnS5PTsyTZUXipT2vGyke6ZGMzzUw5deFKv+aVmWRI8jIqfyA2I
	b79eR2Er4+inu8QECXNnyL9ai4HJK/A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795163835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZCyEGFLuMrF8ud7Iy/GAi36dvb9TvTE7pQNBco9ToNs=;
	b=RRDl3GLEWZnziT13d//F7HYW1ojnb1Ft1kTmH9QZitAZ8p1vluXxLZk9heERHtnJxRBNav
	nulj18M5S6EGB1JrA/TTrngCgNxKSlVoesMmpubTGsqt0cBkNKbHCdQVvaBOiR4dqtC3SB
	7JE7mHRt+lZS5ZisgD9su+Zt8EndGHI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z3tEceNN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cdb9f760337so997773a12.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795163834; x=1795768634; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZCyEGFLuMrF8ud7Iy/GAi36dvb9TvTE7pQNBco9ToNs=;
        b=z3tEceNNxIjqtdHkyMgnqkZ/YD9vI4hKVuRPKQHqq1HUHMJPrvicLoIgYsmkDnhA9a
         JM1EgmhkbBGm1efO2h0tIiK2NZLgjeLsGr7pkTte9DbG8NRQ0exx1LLvsbneXA3uyjJL
         DC/OsKIdXIpwzG9ZjMTQgOc0AqpFy1DsF+ebISjffF4vWQpcT9SHIYcA5rmOC/Oy7Z63
         zGM9bfOoDI3lFne6nk+3QhrrqSXrf6bXRmNl7gm5HPhLZ8tTwff7oVlMkI+PbRnREUue
         CbHAjWwSkYeG6aOxZ2xLRgq55eUSGBuK1l1xJ89SFoygVqFmKstwSwqu9XfxJ7ZUhkgd
         X/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795163834; x=1795768634;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZCyEGFLuMrF8ud7Iy/GAi36dvb9TvTE7pQNBco9ToNs=;
        b=oOVLHmtye1axNQq/sUC1Bzb2H9NarYCWRv697QBsTDTfRM12nfiroZdKW4/bGJxIR1
         aMBwv2JDEsfwsTmdkc49Tz4z0w3qq6fhZHFpZbCFri6wW1qm8GVKhcNrbtQ/lSLRp5nx
         vylssyYFHwyOiMbny/eEtCClxQG8j/jfsjuwRZMNPL3v/SPwStaSQ4IizIQeqcRZ8YMQ
         QYZkLvOrT6GvYRFz3EcYRrtSAwonA31/Lvi/BlVSxyxIvs3d5e34oGaD1HzsKh4CrsmX
         kz8Gifiv9v7cDnXAdw4v3gxh5KI2baofe0Jdg6Dj1xOeKwwL2yTfghXPOMfu2A5KK0ib
         j2Dg==
X-Forwarded-Encrypted: i=1; AL+hErF85jtyH/QAA1sypEKR8BsK3w232jBFoMnBRHsS0OkiW9+NhbW8j+zDw1y7YnVd5nlTawqIyKqGyw==@kvack.org
X-Gm-Message-State: APuU4Z+dsvISL+A82peKrm4UT/ug+syH1pFYy73BybNzs7edOOF0br1w
	ZxpwBQ3MmAvuj59Jd8E7TcvorH/Qqnz/cNzwWTWJrWxX1FMLLq63uBqv
X-Gm-Gg: AZFdTZckjWq/yCDY5s/Oe/tkW831OuNcirW79L/xBo5kTLjvY1oNfOEMZda4h6cANCy
	KfGesyfR8sjOIysjcKODcgfbuKrcCdq5Cj4qqmgD9xMS9PR+1y/ndw7A0vf8E3k2tJtqgdyH0KD
	++f2JosLk/ZTuL2Ky5CkccRzRCUwc4PzVtlyvqMioBioCC0gyKiekZJTT5ta5KjsyQY2xZVRHkc
	vUVvx33KH+o7huDq2O1U992mFwZxVr1CSBMF38Bu3Anfp/BMb6Net32L6zrUUJYX1Kj4/QPbJbm
	UB5391v3s8DXsUJ4b3ivDX6phF9IZhcr2UfBNYraHUaEI4Asqmr//QWP7rQqWjIOYtolEObPHhx
	6b8rXPFYciq6R2XhaYwoQsSV1dLRf6wPklirsbVuBoB9Ot9CEF2LNsWioo4UoBynAKmR3vLsweS
	/ffnQIwSjejS3GGeT5PI6789ILQEpl7xJpBY8Nrzx/5vEifviFSSMX7s8fDPSQo5yQw8IA1jaPy
	NvNUuc4AHcskkGeD5nfTZLuR6TrNWQaXEVVdOtVgQL5pyTkNdbOCs8FNql+7Ie6Gjd+6xD217mb
	/F2nfFAXbYoM14RPCQqcUohRap00pygLhEuHgkY2HQo4dw==
X-Received: by 2002:a17:90b:2f8c:b0:3ac:9ed8:f301 with SMTP id 98e67ed59e1d1-3b41c93fac6mr1453272a91.30.1795163834405;
        Fri, 20 Nov 2026 00:37:14 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0b52dsm3590057a91.5.2026.11.20.00.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 00:37:13 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: vbabka@kernel.org,
	harry@kernel.org
Cc: urezki@gmail.com,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters
Date: Fri, 20 Nov 2026 16:37:06 +0800
Message-ID: <20261120083707.296481-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: C325BC0003
X-Stat-Signature: 1gwmxj3qopxhai3nkeripffmacf9xxq6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795163835-462533
X-HE-Meta: U2FsdGVkX1+rYKZjoaiAkyAn6jtXnmt9bk1v3fM4U2z38nuY3hskLpFi6CbQWYoar74pXMRKc3fp+s6hOvo6VKXk40NgoKOjmbmhuFsVid+RVU2NChkXpfhXiu4/0nfoQPrsF3XDKm/0V3xgl/PP79OZ1R245kGFo+03qIC9sesKUVYPIzSWD69/gsLcz8BLn0jQOnBWq6pa+BMbK/9IAzBZFVnim/dmB8E7cL0wc/9OJp4zV5DvROX9aGwRqbKs/UpE1eyxWJfxgLQ54E+5C73Xfr2W5myJo94lWdYfTaapZ33Y/QT2jgj7PshBn5iuZ3sHlMmjO91/t8eLJsZbiW2on/Z1Tw0/Aq8SabUvC//NRDtTnC1X4egJhLUXFYJuWKdOKn7n/FidXx/k3Hx8RcIrB/w48p1CFejD7fQHPtWVB32ZQNOBU4udARrrbdRzaxt/by7uwOQGAFmKTBTYABIT/NlpUfMlr7wS5bxUVyk0TLfTPBR6ZL0s2J0EklXpky9DGEL6UQEAsLc/K9lIegg54VjaJzAD3J21Bv3MD3H6RuO62n/zdWIKyoxred6CpKqn5QSSqK+XJFsfr5v1YX4Yf9E07adfhpKp8or/JBZMhDAXZ1nBuyvu66ien+XJGYftMtIjmvFGjUO4fykEfZ+Qd6R9imuS4v35zLdRVguIOwJzbzoZr0Vj7ozZ7jFL8Quk8sycEJW+lRvjhfpk5vd/xks3C1vN8f5UM2vmbuWgfXI5xpIc54cgDrlZvKrUg6fguRkBV9GXEpCh1aFMbCOeGs6OCVMxraFwTMgqi2iMHa5qETLZTbCI7rbZEOH5L9piolUZqkANmBEFv5TukQ+ESpiTvtlgS+abcSAR4Dk2/2a/xKehEVGvpxXE3oIFd90vwSZNRs1nkjBY87JHBcOWyBwyKXrxKRfZyGXshQzT9D7RfQfDFB49Fd0aBSDqoifLj75zAp+yjJkxvdB
 UVQZyxnv
 1278Zm1KQS4hxRBx4Fx/9VKmIpeF1RhULmtvUxXieATsH89T78Sk53NfgxZNQBGDOeqE/R8NCcMUb1L0+ItBtdxTCgQa5Q03hgX8Yu4rKuEixzVPXaeuNB3OqL6v37oyOU5qrlwW6s7DQb7OLt95BETcyorx1h7mYPC9Csa/z/p8iAQRgeLQiNsqiPJoL81eT/dJ3FGlLeDy1PIIHoePEbl6mlFIg8RgpMhwrbuE80UrwLRduBMXha2GHf60aoYEJasGdcGdgWzWWZ/127cjAjRPnJHwBGCleAaoM405zQ3k+hlAyLMwtgjdPDQhsbsjOWrRf2P5SOR10UGDIY4+syGoyA0/HZr6hncH7QlAC/Wbhf2ps16ChfYIwU/bvzdyqYrp2nZCGcV3hUeEvbksmyQiWyN7WgLPQLhHNFS1rimLw0nXXSxPNMxzd+mFIZEHGUZlq3yuIQuJ017PNDeYU+pFLJEbUEPtB0bjEhK7ahHM2mDrP37ssXnF65LDbp3HYj/1LcJDnV7CdtbApVbNh9O6xddkAtaPvQK9nXD7scuEOP4JmNXlM3dQc+IIoJHawlVtErbn5qXZOnRFZ2bffBkXIZhfHY4ToUAeoql+VOoqYvgsLZ7GpRB8TLUl5eyEiTEeON5lSZjviVTwBfQ9NxD2+jbilDh78acdxR83iSXDDDr7bwS8JlOdCi7lAFDSw+69AP0MtwoikVlk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

The move of kvfree_rcu() to mm/slab_common.c dropped the "rcutree."
MODULE_PARAM_PREFIX, so rcu_min_cached_objs and
rcu_delay_page_cache_fill_msec became slab_common.* and the documented
rcutree.* names are silently ignored.  Restore the prefix; the
slab_common.* names, never documented, stop working.

Fixes: bbe658d65802 ("mm/slab: Move kvfree_rcu() into SLAB")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
---
v2: as in slab/for-next-fixes.

 mm/slab_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 01c64ef661e7..41dea01a8c1f 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1367,6 +1367,10 @@ void __init kvfree_rcu_init(void)
 
 #else /* CONFIG_KVFREE_RCU_BATCHED */
 
+/* Keep the prefix inherited from RCU */
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "rcutree."
+
 /*
  * This rcu parameter is runtime-read-only. It reflects
  * a minimum allowed number of objects which can be cached

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0


