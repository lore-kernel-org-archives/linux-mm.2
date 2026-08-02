Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AD4C55175
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 14:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2866B007B; Sun,  2 Aug 2026 10:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093DA6B0088; Sun,  2 Aug 2026 10:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF106B008A; Sun,  2 Aug 2026 10:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4BFC6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 10:57:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 432D71604E6
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:57:18 +0000 (UTC)
X-FDA: 85056632556.19.F3712E1
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0ABF7C0009
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:57:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=INWiOBSc;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf22.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785682636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MqEBL3My6pzXchmMKapwn70BV5PXSqCNR2sBzFd4dU=;
	b=ADTuevkKmcNLDFtkt9orjd7ikOlcTns+C6vRv/e6x9IaO1IxJ4QU+MzeCoMyXPSELoCLIW
	8c/VMtIKwhkW1J9T/ZAQOjcLyOwNRQ1TEDatVIT6yto2uePd+lxmZqz1FckCHsr52YHCoT
	1rIl+3tUPkcA/TXBCJALXN09DivvNHI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=INWiOBSc;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf22.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785682636;
	b=OkWOovEAVr/s+c4kjh1cjBaE9qLfxR/ibXXX7z7SbpCFDWOKqjSE9ymZwmWjnvZ4iHBjhx
	zs01QhV25J5HM6j+DOPCVIK+27x67dDRaNLDziw1V65yXLCG5Wu8P1I/2j4k5JpBV9EAsC
	jdVntgZ733orsIMKm2Sf3YhLYxx5To0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1785682630;
	bh=+MqEBL3My6pzXchmMKapwn70BV5PXSqCNR2sBzFd4dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INWiOBSctHaPxAryZy6XwCY87+TYvJfTTUpJhttdVqresDCfoVYTtQWz1GBGxDxX2
	 VSo0vhG6NcPvKB8XOnPRg7E8pTS+p35JXrqHMktIoMmc7WsbiyB4n2x1efiveuix+r
	 XS/oQeBPMJ+/IAE7MPzP/K56fYDYD6bJBixNb0mc=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id E480182F; Sun, 02 Aug 2026 22:57:08 +0800
X-QQ-mid: xmsmtpt1785682628t0xgiphrl
Message-ID: <tencent_B9556590D4B65ACF74C06897689A6E39F206@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4Ag1wOFoiyyQzdTBXQBZ4sivjcfqzojsikiLzeK9s8IFIa+eBKFjh
	 td1yfGy/QuTThCWIE/PMAkLbxrvrNeD4RzLvC6jhzAViIWzBFJcuXNoPkhzECd1bmir9hiPHwxLq
	 VXgaMt+3YPbpv8xsqkVdIBTvtK7QLliQLbZ/CwCP1/TRfbagUCY9Jrm4sBN70+hWiU9kWnefZqNJ
	 F7K2Rrk9uTtUObOEVLYVVpaTtT+9wM+Q2/aMGZtlHyLV4mVoBnthVDVwUzrtwfjci+s6vrG4xY1D
	 gUE2c3Zb2n2HtqK+N/L1P6FWBB0FKOsy3Xxj8QM0BzVzvNBQBeNOUDO9LxKJnDz90KtTXRzIL1mw
	 CM3swJ2G6CIQGGWjuqrfG+3ABmC8Am5kr7jyWt5fvATX3WQtwhLl+uApaVjuA6ay8fSbI2B30yVP
	 GvzM6vaxMtGLvXZCwG9RgL/2pZ612qoPeOEiHwANKQdS9vQPoS+bv+Mr821zQROm0gy8daFurWwB
	 YNL5N88gPWnYAoOnZzoPoDRxMi762aBu86SrvEGrNPS/vAFbrci2XS3iZDVWL98vme4IaoCeGl5z
	 mHMUi7eYQXY7xI339q7FKE5kU1JdEv8f+VQZ6+le/Wyakv+wdtlodvWgePtFQhkYHvHqy+rTEdqG
	 v8zYHWyLwPADtO3YM3ozTLI8IWvWkOm39KIrwuUYW4H7LgE5piE/GQMtOKifsa8YrELg7Dfi9Yam
	 EHiT3l8cVZ4EOGFZUpdCHpBkoBsm6BrMmdTo9kl7q1mVWmwIooM1P+upayGFFpYpKd/Q5/azd6lw
	 yqLLgu74gT0FaezBMocYniunoOr0FnzMZAvx4nVp21/VUWZK1p3sSB5y+hMkuQjRo+XwxS/OWpgW
	 tJLlSauPtvUDvHgX4g+dZPO7eUIqfXC8yBU8MRAtkgvSVPB1qLFJwRU4o6gyVy6ugNSsAO8JAgYr
	 6yYA7Dnv8G0kG4Lu1LqoGh1y7SOqsHFDWJJPIsYnhlqWjv0aSHFLbTALt5Y9Ky+lq/szcPlHfLuB
	 V0kWEQ9///fQADixY7ENg7ZaFRw5QKRSG7rxj3wVUz78LindtXsfCdlTBqUGU=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	hannes@cmpxchg.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Sun,  2 Aug 2026 22:57:07 +0800
X-OQ-MSGID: <20260802145708.1727189-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0ABF7C0009
X-Rspam-User: 
X-Stat-Signature: aq18eds53nd99175ny8hew3utwoskwmy
X-HE-Tag: 1785682633-7699
X-HE-Meta: U2FsdGVkX1+Ik/0lTXhteuuXaxComZ9b0ZQRwXdv6hlaVUQsSh7RGGNk3m4Ol968rfmfXOWf+GksPPm0OovxU1BbjxwQjS8cTS455f9hMhr51JTQBPE7Ks7BWxwJjS1+hWwoIHJ9UY+x0aSUc19BagO+m6bKtG5gSRvNk6hF4Hqww06x2uI/C58bZgR+lCnExQXER5NixmF0XNxp8raTjSYp/c2b1nK79kl8S445Uf86Io9SLZEM9pLQX//8YePr/clj0Izo7Uri0GlDbNWNlju2ENTLp14MjqflFPLAYIzCZKdv7lVHgyyD0U0iSLpRR0D0Jrn4LBPSwCC8vhtIntVfTcyfdTnk9DKxJWmkWfnfZ4eh4u6QPNW3cp/YNE+0A6tz+9SXFRzN8haUQsG3gwiJo1EL467TdN4GId6IwJ1s3bqc8MTh58eB2aN9oHwwfKII/Aj4jf22leKbyrCL0/ojQq8aOzMyLnk/7WVgwwdkYKXFRhaRxmu8FDPpDJOV+SFZI87VF82vkptVCOPmickoc8xBSrZwbS2fvUMKJPbkaPxsF41nSE8ywTxN5Y+dzErwtAoRA6zF9JgOPM6AkpBgQkHr5wEbvoibv6uM82XJVtWxGbUY8+Pgg1cf3AGVpl4Z9kuO1kn7Uj0EWPJX5n+12ESL3aEQ7Dwt151MpzG+hg4KjnycEyXeUwkzURJoLWqW/gGYofYR58yd/a8vPx0V5KzlK5MlDKl/b3Cg5VHyRUFXfoLbor4Nct0+1Oo/o2oRNoLvLtv6cUK31E6mWqqSEO42wKnljONI4dU5F83EBUniUhILCYJPyuEm/sVG4v6xf0nmw98cdXAIjMU0Ez5QhZ9EUJXKzwmz/lhP8ZOY4TNGKPtRGVa8UalDxnCVglUGr3PcIFwU3RX0TToNXUl6YuXibYnCTJU2Tp0Ce/F4Sz8Q0uTo4eri2OXaCZQdNi3PvWI8c1vZ8tGMVDU
 9GRMgdPp
 BC8pQN7yhoJdpPSkHaiv+07hGYSaMiQDbI+3DGQ8c5I6Lr8zFW4PtvdA+prxt7WIcepQSVRaSKDNmRmWaY57jdLIMt2Gf+vFqZ8imtje6OBbmbr4pZKYWysX0KkvSWJKLLq/EjiCtD2WbuiUPpmEC3ZkSkkXN+xRly2LU9cxHs5jXgwcPRBfV3nA9lfbSq2GlEZlHSUzTaRM3Vp0HV2mLnCYcc26Mzc4cv6Y4MCHXx6LeCpFclCYKQPtrd6hUNk3DtaUQsI4qak23+IeS/Xy+Pyke1uIPHIqgyYZgrD4x/68gKWXcQvqItKJ99JDj5pIMDatevlNVAJo+FnxlfUFtI+K9J46bw8QKHhZW90juXtssgmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lowmem_reserve_ratio_sysctl_handler() ignores the return value of
proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
even for read operations.

Fix three issues:

1. Propagate errors from proc_dointvec_minmax() instead of always
   returning success.  For example, writing non-integer garbage to the
   sysctl now returns an error instead of silently succeeding with
   unchanged values.

2. Only call setup_per_zone_lowmem_reserve() when the sysctl is
   actually written, matching the write-only refresh pattern of
   min_free_kbytes and watermark_scale_factor handlers.

3. On write, parse into a temporary ratio[] array and only copy into
   sysctl_lowmem_reserve_ratio[] and refresh derived state after the
   full vector is validated.  This avoids leaving the ratio array
   partially updated while skipping setup when proc_dointvec_minmax()
   returns an error on a later element (suggested by Andrew Morton).

Drop the manual "< 1 -> 0" sanitization loop and set .extra1 =
SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax() enforces
the minimum on write; negative values now return -EINVAL instead of
being silently coerced to 0 (suggested by Vlastimil Babka).

Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/

Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
---
Changes in v4:
- Parse writes into a temporary ratio[] array; commit and setup only on
  full success (Andrew Morton)
- Update handler comment: proc_dointvec_minmax() and write-only setup

Changes in v3:
- Rewrite commit log to focus on the two tangible fixes as suggested by
  Johannes Weiner.

Changes in v2:
- Add .extra1 = SYSCTL_ZERO to ctl_table entry
- Remove manual sanitization loop; negative writes now return -EINVAL

v1: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/

mm/page_alloc.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0387d2afd..13fabb062 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6673,8 +6673,8 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
 
 /*
  * lowmem_reserve_ratio_sysctl_handler - just a wrapper around
- *	proc_dointvec() so that we can call setup_per_zone_lowmem_reserve()
- *	whenever sysctl_lowmem_reserve_ratio changes.
+ *	proc_dointvec_minmax() so that we can call
+ *	setup_per_zone_lowmem_reserve() when the sysctl is written.
  *
  * The reserve ratio obviously has absolutely no relation with the
  * minimum watermarks. The lowmem reserve ratio can only make sense
@@ -6683,16 +6683,23 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
 static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
-	int i;
+	struct ctl_table tmp = *table;
+	int ratio[MAX_NR_ZONES];
+	int rc;
 
-	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (!write)
+		return proc_dointvec_minmax(table, write, buffer, length, ppos);
 
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		if (sysctl_lowmem_reserve_ratio[i] < 1)
-			sysctl_lowmem_reserve_ratio[i] = 0;
-	}
+	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
+	tmp.data = ratio;
 
+	rc = proc_dointvec_minmax(&tmp, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
+	memcpy(sysctl_lowmem_reserve_ratio, ratio, sizeof(ratio));
 	setup_per_zone_lowmem_reserve();
+
 	return 0;
 }
 
@@ -6791,6 +6798,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
 		.mode		= 0644,
 		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
 	},
 #ifdef CONFIG_NUMA
 	{
-- 
2.43.0


