Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C063CE7AA8
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 10:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1C08E0007; Fri, 14 Nov 2025 05:40:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B90D8E0002; Fri, 14 Nov 2025 05:40:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5DB8E0007; Fri, 14 Nov 2025 05:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5928E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:40:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 986D813A994
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:40:53 +0000 (UTC)
X-FDA: 84108869586.16.AED5F78
Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id 097E140009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:40:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=iJEAeLjh;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763116850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e3qA8tOoAeoWIDGPeQT0umXZVt3+AbbRL3OHzsWicUc=;
	b=Q8ELvCVRtxN66bKnM/NKjqotj7SgEOqIQUwaeegnEJOuLphjh7C0WMqYRD6a7DOF/xiIYc
	evgaPBule66MYj2nBNn9D38Wm/UjoMbPSkQSgpVEKLS3PWEs2f4aIafKfGCbGY8KEUNVHJ
	r5XIrrFdggqgvm0Zq4MHFe+vaye6tpk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=iJEAeLjh;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763116850; a=rsa-sha256;
	cv=none;
	b=1RPS9Di0ErOevGWv0UKhAO8JsdqXxkzixMzGT9SmwGelTlLKaIqOCqEqGHy7ybQNvbmZip
	eo43JDzlejMP7G6GIZL7Trt1DY7K5XZ3G17FTGK1BZSkJzpDoxtlz5WzSlBNmy2gkqy8up
	TbXwpErPhX7Uu7QnvMUkCoRV4GekK8I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1763116846; bh=e3qA8tOoAeoWIDGPeQT0umXZVt3+AbbRL3OHzsWicUc=;
	h=From:To:Cc:Subject:Date;
	b=iJEAeLjh8Uj/XlBiGE+vegcadyjDUTtDbOlmb5s3P2gUva+itO6ad0MwT7jBNFu6H
	 KoLIIdck8nPaXhUkhahGh86ZJbSpL8z6RBJY07PS5CvytYWOPBk85AQQ9P0QBnRC7f
	 QqgHnZVhgYJu96EHijvr7KXTPtjzityAyyqtRja8=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id A2B98296; Fri, 14 Nov 2025 18:40:43 +0800
X-QQ-mid: xmsmtpt1763116843t84na8r37
Message-ID: <tencent_ED235B379E160A5C2BCF688ADDF3921EC808@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4AgMgoRmqPjUxGtzBJG3g0Kyyc2+px6B5cZVB9QClxOIYZkpOPEnb
	 YwpIDGtC1l8v+vzbrhN46OL+VN8GkMR3mm3JkOWyaMUo4s9XejBIR5NVEy4mYb/FzWT4r6A3CDBl
	 EmcuZDIwThiHiuWgzXK4MNQIXSmBT+7tNWNmvAaqhA5dTrYoKIA7+6K3iRFt/uOBsmdtOiNYvbJY
	 nKGUvoiN+/LoXT++N9ZB6kftflJBCUEIEcSBQNoNH2rnGBoW0z2aYTx4xXhTuRf7DVBjesFE3buk
	 X5keZy9EkS5IiSYJOHcr3z43KNS/SY/s8uyqfjSweyPCLDUAO1RszoILHyvS/kaSGlfhgh6jefQS
	 +O0S4/3uIRM1R+cOa8Ar6f+mFktLvJxAYUfy75U5OPqgsaPGWwvVrbv6hNPB+R5gGuOB8rVtQrcx
	 iljTEnBOWgnXmli4tkz+g9y3CxPDmsQRd/YOVK5OZfccTHK/05omCjkh8z7kQiJsjmxL3eXne7TK
	 2LhXwvDkmlm15dsJtFsQ+5LXtN/VdwsLd3l41mzofVU2X4AcLhcpzWcqW4td1LfVpSdaYIXXEkze
	 xlDEIaziyPOI47agF+CftbquzAj8cXrYbbPw/DtQnzIfNbHoA3EIQdSxKZO2JxUnTntCkaZS7ui3
	 skLLoVYnnQbTBYvD0ZYNcEvYrp60+5VCmi7hiYSAQfQHfOHKGwdeQZY5Lm4G9DdLrwKHAQ9Cn0I3
	 dX1jNpW5++tl4tw7M9T94wBuaTuzSA+I+sF6vsqJMKyh6mHxABiBthRTqLUtMMDrG/c7n4YEhrIV
	 ePCuEX/pbqOITlIpzTDtGnAf4VyAW4NuqunQqEEFu5arl+bY1o6HngHpjzY2JnqekXboQv4c6BVQ
	 VOIQnmD9WpPOzlkLhNEfhKChNrk5zNnVVaxPXOVDTitQdjTU4QF9B5HGljP1k/kPi7Y0aJdL39eJ
	 OD57Rw6DjK7gDeg+AfW0TjMd769jAkgg6nPE3uuIWT/fTbqttKqbPTxs8QgB8w0wcQKAdfpVv+Yw
	 7uhYgQzG+rMFhTSAi06KaMtFcG98wWxfvsRNvfh3dbQ6EbJqyDZ/5o/NyG3FNjdFmXhEOWAA==
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: fujunjie <fujunjie1@qq.com>
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	fujunjie <fujunjie1@qq.com>
Subject: [PATCH] mm/page_alloc: optimize lowmem_reserve max lookup using monotonicity
Date: Fri, 14 Nov 2025 10:40:32 +0000
X-OQ-MSGID: <20251114104032.2740513-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 097E140009
X-Stat-Signature: dmjmj6dm6ru5ge4e8hb4zt5z896naq1e
X-Rspam-User: 
X-HE-Tag: 1763116849-801502
X-HE-Meta: U2FsdGVkX19KWrnyahck97McNJl+6uWMQ+unpLn1fhRGBiTfl8zzhD+fLT6v/3PxxMNDhmDZQr/G0Dlurmu9v2Bxtv7OvxV+USttEZEI84DSlrFkwEL8Bq0ig6LXbDC0wxcXufNc0oF8+LwmElDWpS+nHPZcHigHrO6JBLWHm2lpU2oj6dl0qZBJII8ZkRgfE8cNQna4hc+9r75HRKnosGeDHTjQjrz8ho4NC9/BNIHTIBJxG7xanGoTobcld2Vf+yXncN8QCB8rUHo1MxYgSFdt26dBb8LhyUiIjrXr2S7uaaFdJL/IqwjpKu9UkjHO3Q03fb+xQpYHyzRnK10sWrysHJKhauclkAREyH6NrX2Rp1M4jqwgw9Y+IMDynOcMtNaqiSOJgk4snckmxgfDx9j9UZ60WIK5jTdb+c6/pJT2nyB2lJlAEV9nXSbX/cqzo6YdO6ZrV+2T8BdhZxs7FGqlOpMK0W/DRYmoP20Q7aHZzbS3/uqouT+NQOcvvER9Q67hn/Ns1avis2tdTpqklihLmNfRKCgcHTePpBU3MD4uO1GPzSyte/L8acUxvM98XW4/qdy3QG6vzBF8wse/ukyMGBZbslM/SPGrLvSmXOsVKfRBKqcJV37aIziyk76Zg9CLSW2w9ZKRwcRas3qo4rkxFo143t8Px8Fx6stZoX/DDFhu2BFzp00u1MDfSprZy+qn0Gd9KfatkyU9rvy0Go7InoZDcBqYJWQgTMTT5JC7V5ewHSHmst2vKrG0cMkPsRZzhTzHSIvawp5kNfPmqQq2RDsSC6DomGN6wFAGeIay/5gd3xa/Yxzun4A9p9ej4ND0YaAefrI8QQDzK8w3pFhN0DyBnf2Iae4Lw7MYscqx1JG4kCbjNJ74Mk4Q71bs/WdUMEL0S1oYz6PEkzcN9d0ymxqSZfQu6EacuJmoXHrCTUWlOhmTNNa5YgFfMwgQmWb+SklgtN6nJjOCr0N
 hI35oMjE
 k6OG90CGZY4AJvvTy9gYgtv8/4r1hQXdtASWuEjYcUP3OC6w+BLDvi14a524d4IEUyJRA4ICpJLgFqk/NvlgJcBUIqStbrjkgo4SP6CCnM/tdZcI4jTe0Dsw5T4mJvlz9pD9DHboifPyd4u1oMbRalUZN4oetz4RIfsUQhi2C0jz+YdUozwLL136rTy5rhwCbuqFtLqCWpdcTzCASyAlOqa7I2eM3cq5CcNBXcjzROEhtOUT2nwNqcXwvuM5ohG5yvIQFNG/RndTjz+cY+nJYYSKFJiWx8CkVLEiH9duhcpz9Z9O+GQ7qChns0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

calculate_totalreserve_pages() currently finds the maximum
lowmem_reserve[j] for a zone by scanning the full range
[j = zone_idx .. MAX_NR_ZONES). However,
setup_per_zone_lowmem_reserve() constructs lowmem_reserve[]
monotonically increasing in j for a fixed zone (and never populates
lowmem_reserve[zone_idx] itself). This means the maximum valid reserve
entry always resides at the highest j > zone_idx that has a non-zero value.

Rewrite the loop to walk backwards from MAX_NR_ZONES - 1 down to
zone_idx + 1, stopping at the first non-zero lowmem_reserve[j]. This
avoids a full-range scan and makes the intent clearer. Behavior remains
unchanged.

Although this code is not on a hot path, the revised form is clearer
and avoids an unnecessary full scan.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23d..414c5ba978418 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6285,10 +6285,22 @@ static void calculate_totalreserve_pages(void)
 			long max = 0;
 			unsigned long managed_pages = zone_managed_pages(zone);
 
-			/* Find valid and maximum lowmem_reserve in the zone */
-			for (j = i; j < MAX_NR_ZONES; j++)
-				max = max(max, zone->lowmem_reserve[j]);
+			/*
+			 * Find valid and maximum lowmem_reserve in the zone.
+			 *
+			 * setup_per_zone_lowmem_reserve() builds
+			 * lowmem_reserve[j] monotonically increasing in j
+			 * for a fixed zone, so the maximum lives at the
+			 * highest index that has a non-zero value.  Walk
+			 * backwards and stop at the first hit.
+			 */
+			for (j = MAX_NR_ZONES - 1; j > i; j--) {
+				if (!zone->lowmem_reserve[j])
+					continue;
 
+				max = zone->lowmem_reserve[j];
+				break;
+			}
 			/* we treat the high watermark as reserved pages. */
 			max += high_wmark_pages(zone);
 
-- 
2.34.1


