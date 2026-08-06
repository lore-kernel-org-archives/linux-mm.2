Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A645C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4216B008A; Thu,  6 Aug 2026 04:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DA56B0093; Thu,  6 Aug 2026 04:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A88D6B009F; Thu,  6 Aug 2026 04:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9706B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:27:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79B79120623
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:27:46 +0000 (UTC)
X-FDA: 85070166132.19.8A5F258
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE564A0007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:27:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=nKiD0sVT;
	spf=pass (imf25.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+OtdBdwv6/MFc4NjNIl3j6uDNWCdxI8dJnJUIXFKfA=;
	b=8I6nhX7NeBCjDwYR5BJ1aZvzlczp1d2WjV01LR5qDDZGhgx14QXSlVpiOPxMLUF04/BNL/
	0q0OuG4HbCkNoG2Qk+15QVLvZTy5HiXyZLnIcn0TYGGVVs3cMPUAEU+zsayrWEGbzb3Pa9
	4cX9Kvq0LZ+r/Br8vwegzjtlBXwN0m0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786004864;
	b=3Vx6ZLbUGDVG2RyZjEPNVSu+Kprh+3OxD17XOLGgTl6dAkAJD9mFyFPqkbj7V6FthuXK8u
	BSo22Lt58QBEQKo8WAk/3rCy4MLqmltCWg1LYr66g0OchY4yXre+dqPLE2fQxfq7Gu2gkr
	LIMs5aZ22wcjFCm+2MXUggyJPIkcthM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=nKiD0sVT;
	spf=pass (imf25.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1786004860;
	bh=E+OtdBdwv6/MFc4NjNIl3j6uDNWCdxI8dJnJUIXFKfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKiD0sVTT+CECEZtTEkeIpZ/DhGjc0Tft++o/B7F0k1vajhoKVnAvceYbKwrxukNY
	 +RA7rPVNcZPugKxMenospauMOz5GtuFHWfoZ/k5jP57ykpTrg4OGn9CJzbzyPTt1hx
	 3TZyOqQoXxJbSg6mAc4214CUERuIY13Xt5OAaSz0=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 6E52AE75; Thu, 06 Aug 2026 16:27:37 +0800
X-QQ-mid: xmsmtpt1786004857ton0dzvq5
Message-ID: <tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com>
X-QQ-XMAILINFO: OFArnyxfXusvqWmUHm7xnqL8RhD5NT+vOE+qOy9jAdtH9TEY+dGOrEvZLJHXQm
	 Ko+m9ZDmJ6zK9g0F2c/TZ4/hdm+wUBH2/tFi41bbEoY36eu0U1fwFDFEH1RKGCsOMuZEX6/ETnm9
	 vLXl8l6QAJc0iuz0b2ZBiMsfp6vmDhHMH+O7yjt0dKoVaFwPnFFyrhVhUHkANcMOmFAAlIeE12/K
	 sxkePuCWyjxMXjqiiR0Hx1PJai37QB9I7tLSVLt/rds+rywS9WP+Uxk971ptmvyrE5dbUI8B/enh
	 2Bd3eM/VUJ8RDgoJTReBIRgvr4EjmVzIfwqrSVWNeLa+5bfYjpDnGhbltHtoVM7Zg2XV4vdRDpBS
	 LEZEfc80pCHSXAN6FpNvnd+Rv7D5RmKGflNVBpIhi3ORAR/8epDTvmU1128zQXlyDTBBxpPwIlMv
	 q4t+PEJHyxXEjXF6+t1cjTg9M4CFdYE8eS2NxszcRjL/KXaLZbKT1V1svzH1GjLZBP17LHzc38Ns
	 1lquQJS8EwH+S6p5AY8s0FXgusdP8BsqFINSEw1LR9DdEHV6sd4o++K4E3co+f9NAehG8DoPITI+
	 HoODs3JqG8qOcPIfule1Av8iiXZldLGiesZGxrYqQ/pw/L2yxK75tQPDCHL5L47XVRUMjMgmutiU
	 RSTtasM+1WbQpfDLsio4sjOCXgpMOBTi3SU7o0+y7ZojHpPdXORPOjvyRlhwZCs01RHHR0SHu152
	 f9uoFkSaDz+rohCbhxhBplnvkHEO5bysdZ+dxUU8++rTnUk1fCaeC9oRs9brJgqdTVR2U2aiNc5p
	 PWjTAnW2bZhx2w+2lgLwP3HlO8LJnHArX3GHsix1JReY5pHiOb1duCyXDYSY8Kk40OhNhWYV/0I5
	 11y64AUOnp2kQsDczyeR/WcrYCT/0xtGquaWcu1GlMIGllCsyZl2CHpP0TbSYLJdEkLN+YBmIEGo
	 gy8kwTMZvpHZ8dyg1ffgU5l7R2mgQQkr1HNSBeQ7SSzTfooWDZamRbxXtU+FPCsr8/vKAqSz8zSS
	 p/SHKRtN+EsB4yFHSHz3fQdKBCjDyvlnbNXMQZxU8aPBDr32uB
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
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
Subject: [PATCH v5] mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Thu,  6 Aug 2026 16:27:34 +0800
X-OQ-MSGID: <20260806082734.595622-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE564A0007
X-Stat-Signature: wse8x1fjouysjyoawykgt1yhinzkzfic
X-HE-Tag: 1786004863-840796
X-HE-Meta: U2FsdGVkX1+4bn6PNicZF5+eZ0njHwtUaA7DHK8ZHh0WlDA8+TtJfn/BcPWO2a/GT5G5ax5+VqFPnqDq+OqlmZUJJBPZCcYsCmmUI/YG/Z9VrxN7I4uulo5GlO6sSqWmw/EYOfICYl1m+LDVcGFKn2h9LZ9KDCS1XvkOKLxgReGhlAZZOcU4MfHRbRsZK/9PmaYC3Mvs1nJQLwDGGwSuM11F/dHRWY7dtXugTzS/m5Uzr5wh40usibsZ0KQdi4EsqTxLV471EjJZWmzaqdbPiIwBd+RAkXifJ0NCYZAureqQjcecr1I8WUdx93LfZ5Akt8iNMj9ClFtqEpcXb44v/IPf8ROqRKNm0ge3ja0JIi8mYno4oQkXg34IW2JOBcf2E+k19zgvJyO49Pf1JpOy4Jhy0ebZwRbsalshBk75085hmWZHzEsEc64QH5fVeCTJHOGjH3xGCsc/BenPbcs3URqQPgG2UuZsXYgpFsSmReO3kaxzmrkC0bGLIs9NtbClSfOot1g+Si33WXnC+hjFgT/9LXaQzf3uM7j+c8AhEst9S2Rv05rW242bQOz9akRLUlzXS6K+QRu+MSCo+SDBtwpCsAvAMbVGmSneG60qrvRPTW7BZwOO9lwp6o5ykQry/T0StaWTN/h+rBBsgeIHbr49ySgUcl/2Q3LO3GSqCEgT+HVoS6pL8aVufMrJJyJyfq8JkyRpCm5JDBljEfF+9PVPl4KC9ZHNZdd+x5Ccdq2QT1rleW2cozCES07m8NEBDF1/0D50iZUfFx1/Me7WqDWzFbPlZIfbbWVLi3foxELE374KJSfBZFsABGvJWe5h5f5urHYk5horRcaMQaKJ/wN5XO2oCFFIKgxupPS/v//eQYjKLHEeMzLvkTaHykfzpOO1647zaW8NCAp6LiIaBFehQ3tU34L6URWvo4Vr0LelbuJjKs7u42I6fbQl72aSdpQ1l+Ap1sCGTyoMGUY
 7QseaPuc
 t8EnR0DIr8z0xXH3E8ioR8raAWIEq2MQk3+CFBcA2xh3/drevn8AKMOBLn7QSBnUqQik+FxtorBQ3KALyY2ePmYO8fxPLiD+pBMQOPw/XOmejQ+0AIhEFM3OntV+l0Oago2u4EStza6FugE0X6qHnWpby6VFZ0pW+v/uLR+F4GVNfXzT4hFv697m1ILCxUZDwxBQ2jn0kkThcWZN1UtwXge/mJuyKy5tLsavh9zfa8aca+b2kFlhQfhveQ6z16uSGZBAE8GjxqGDU4jZ8waPzKTLL9JvAmBeHCzsPiLwgnU1Bs7oYCwiF8gYIvBBnmLzvZ2mbqPhBfmCjk3j7vwLazi+PAfw80M5zhQTpOI5vNHGF3Hg=
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
Changes in v5:
- Size temporary ratio[] with ARRAY_SIZE(sysctl_lowmem_reserve_ratio)
  (Andrew Morton)

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
index 0387d2afd535..51f35e44132a 100644
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
+	int ratio[ARRAY_SIZE(sysctl_lowmem_reserve_ratio)];
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


