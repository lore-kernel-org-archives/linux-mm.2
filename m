Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B2AC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 11:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D096B0088; Sun, 13 Sep 2026 07:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE8B6B008C; Sun, 13 Sep 2026 07:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADBE6B0092; Sun, 13 Sep 2026 07:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBCEB6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:04:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 538D916064C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 11:04:03 +0000 (UTC)
X-FDA: 85208454366.12.C2A4E7E
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 99E24180007
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 11:04:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ioJvSNvP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ioJvSNvP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789297441;
	b=6Vlnmin8yIaX/yAJFKShzRrCnnKBwOvraJRrMTIsMFmbc5TtOzbbzRw1BcPHT1GPYolijL
	fJysq8BmzmI4oZDI7G2APHj35tpzC8MryKj1NbYlToWcS54dWvIZ7wqp8TYFLWWyxfE8o9
	TV8dFy2ZLLmN+vIAzBd+sAOKFuHpG/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789297441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jyuRqgAnVGwyya8hRF/5ry5xM2Hr8OUc+TIWxjrQB+4=;
	b=Y5gtxj+VIts+92fn1UmqugZ/Ef761VVwxFNkJb6TP6Yjy2PKujjcwBQF37KGwBk//BX/lm
	Ki8etcmuA48x+gLxKmxW6sBenJhcXhtVHRbxKLc8t75XAzyAme1ijGy83lVT/TTnTJ1tOh
	GG8/g/FOKg3eddkXpXBIiCvmPF98L/Q=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so17863965ad.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789297440; x=1789902240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jyuRqgAnVGwyya8hRF/5ry5xM2Hr8OUc+TIWxjrQB+4=;
        b=ioJvSNvPZ95T6ozCWz2SWN5D9I1ACEGAd1wO1hl1ZM9bbKdwRPL053J3E098luegIC
         Num+Zr8mGxD3ZatT8RVVxDKHJqrB8vbv7KvDyVfZnLGIOZe7/77eCI++XCg85Xzrpxo9
         Iu0GTp+XTVU2IZ8gjX+scw4cXJLFqMrEVrgQQ+s2KQ317JmlrruniYf72wW6CvO70p54
         CZkmPxsHSIMq3R4bAHvTtbRs0eQExzV1w6LVRU9r+uIt+3BQ9yyO/+wPmFR55BSgfLIr
         LZURpckRfjYNB9v3PJbvE/BZ/TcTul/6iiUMJI6DKuiA85g6JR9B+NW1p+FTeCsSp/1w
         Lf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789297440; x=1789902240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jyuRqgAnVGwyya8hRF/5ry5xM2Hr8OUc+TIWxjrQB+4=;
        b=EPUDgpwIlzhOcIe6tTOOukoWpIAWzj03FouY1NSBwwKrLNwRj1quEhpeACrKG/UVre
         nSKD0O0ZfftOhXVqgCV0LD4eBuMFgbXmcq51LAOvBiNZ2B2MPIKUnqNGUppl+P0c2t3c
         3nNXSqiCVGQ3hU/lz+nKpuU85wkC5h/HXPZlwAPRQ1yJKnO58vmdx/Cd5isu/PP4nNx3
         c+NcUeZauL1VFk7rg5wnZZqcSZ4tGnVpREx+E1qeIW8QBo6lRzyC8D8W9Vd+/FnivURN
         i/Qb0D8tkxAn4qYzHzPSicIt+CfrD6PwcC4HlbI7ATy68kBbo7wqNZUZubZ3G0SS0hqL
         KfLg==
X-Forwarded-Encrypted: i=1; AKwUvBxDNBtAYUCF8vo+b/fFDiG9WsoyG59E2a2ouWvrUZ4wMADs+EPsbiIMnMfCAQj/3utpRHg0/+6dcg==@kvack.org
X-Gm-Message-State: AFuF++lfnIlsXcgFC7r7MHqji27svLhPx+g765c6ATWn2zYTNZ1xDv1X
	cj1BgAH5bneKe7z+N3kUSL4jW3p/KWNxqsa9u053vnYZgZB+7IwVYUms
X-Gm-Gg: AYBFou0/Xt/X1SDlB9U1tiuBCUOpMs25iOmgIP7T7Cyjcvn4PT0FL4/vIvrR+r//Fui
	JbT8hNXA7/D1kbLPwl+4StosNRY2owf0nBNnNNq+27ERpcD2R6qmqFjh0QpUqBftycnKj/jyfPM
	Q15FoUV4MU3kXXPTuz9A70OT++Y/OGJmSsziKbcIzZpMWj3tHMkSU1ykH0N8LtaIXHhbFEZHIu3
	jL4bdihXdCT8ynN/n4xMP27IqH9HeZ/+qC2zC6PbhqAd84TMv79khNG41nj+2/JqKDX2DfvP+Up
	iuMQkbgLz8rTSJH/1lfe8IfFK+KOSa4rC8Fg6jwHGuhT6lY2zM54udxG/DejZG0Imevttf/G9Fd
	KYc8Z+n3naHw1A5xaelcQBtU10dIRjMR5Ny7oiflfQWrckTVkv4tuKgmpJqpkWwWFD6RntqlW1L
	ImYugwxcEN8Fk11W86y1C3Bo6vZXbT53rjcWH5d1A12nL9s0BaiLzRPrj8Z3Dkg48ND8z3608Vm
	z8=
X-Received: by 2002:a17:902:e88f:b0:2d8:d4d2:d137 with SMTP id d9443c01a7336-2dd5f1b11d5mr21545765ad.19.1789297440322;
        Sun, 13 Sep 2026 04:04:00 -0700 (PDT)
Received: from celestia ([2402:1980:8858:8cc0:7bda:d54a:257:22ec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cff67aasm32885925ad.79.2026.09.13.04.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 04:03:59 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: 
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon/core: add short circuit for esz<min_region_sz in damos_adjust_quota()
Date: Sun, 13 Sep 2026 19:01:38 +0800
Message-ID: <20260913110407.32558-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 99E24180007
X-Stat-Signature: fuu6tro4r87hri1mejse57ycfg3ezrsu
X-Rspamd-Server: rspam01
X-HE-Tag: 1789297441-377275
X-HE-Meta: U2FsdGVkX19e8M6BkyzQk+ajo9lT5JvdbTneDJxwzcb/lLgT0Ox+yUxfpNpMVThx4xNfqkx3ung6tl2OgUTpV+QrR35myE8V/bRAJKcsJiC7LQSBDpmr6JMXiSsas1/lCjfMxNPzCyIgxgOyjF/T0Bi9SrJ3uNLi8PCezLIGtpMeEZv92Hba9WbJleltA2XeAXdB39OqXMz3eNxQYPdNi370LkoWwksmJPZajieH2BN0OB6usIPGz2H8xZPET9pU+8fRR4jmsvnGiTFhIRXs3MvKdNa0KWNkUTiZL9HH3kYgQIi/uWNpIWqfcqG+X+qBq4rIdkMEOG6nq/YhSUK4IDzXbh9aA4Caf4WlQOq1kT7hfe89bVVqij0yN6ZUSo5ea2oK7Azs8Dcb9FT/Oqh70hjc3kc8pVbDB13nRqhOSA4CrPPmQhSIIklwlCe06zKCTUBrXD9dEw0novgnLbMiE1ywew1aSpquoQFs5rfEVE06YQzYflqGJksHUXIAdpdPP8Iv8fE8ZhEVumpN94cCMfT4mrib25vDPFeXU+gNzKwe4fq1d5TeHpm5LMK0r9PGQI45wLXHxkD6A+gWigxRlZefq58gDuV24IIpSHNg8TqYHJg/fcmnI9BV996WTofO55cZZK6AsqfhsKaewpeg3jGrfnA+3PuA8Ibf2R4Ga0mwAGWnWKc8biGCKnPS1+hZD2tFPy7zApNQYuTEIO0w6xRK55IcTDqlf9TOxrdrXk62WN/eMIWoqn1X9LCYL0tCgzWPCxknTr2Oe/Iw4yws6ypq8bNNqm5hMViQZ2UhoFhh4CxYPLnb6+jMDHECFAhDyoPTI/FsvJFGXNscZWUd4UjHbzb5ypST2S1KyrW2D3+NUftP3C3oGDx90GtxWkbVx/eOs1cmsv3F7tkykzi/dH1kweHNFekaLAKOtsjhc0trVZALekC2v+ScMCfqYOO8RQW2wsutSOhzk5RCd7X
 Jv/iBJZ+
 c6ZjOdW3aN2ucbpk9MMcTHGZgKasZE5Ba2xFmn/G+Z6B+3EiBN2hJ8VdGDHaOt6JQpDWvkxatFML487PJQpgsIsRjV3TUaylOZTdaAQwqdbIYC023r5y1FYYjNhvkWkdW6d892RYpMVb++J3R+fbNl3TUujJB5jX9CmSZ3F4di/XyJEFeXbyNSFhFU8m9WU73BRtTXvUYvAI5MDPhwZYEw4TA+0ZN91mlZyKzH5i8pOgX+DMV+kKU0Ean0vitN00QRChm1N/llRroPWUGLNK5W9ulEIVa01OF0kO2PqHKIuGqORyTCZhGZU9knnAXibDujIFVu7p19QTAn4DsLcpvjmdw93j9yMTWp+YHZlRc58hnHAeIkIj0e+IwoFrxxNIdGiehdlC4tM/fjHQFDa5Wpmwp7a3a+ywaHbEIwpobNo5Ydz13DgDgSSlXVBR9f3s+WLgxD6vXLO+DsUgoTUrTqcpp/fBsBlSbyFHtD6fQtiZWiSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After damos_set_effective_quota(), the effective size quota may be lower
than min_region_sz (e.g., when the temporal quota goal is
[over-]achieved).

In this situation, damos_adjust_quota() will still calculates
quota->min_score.  However, this min_score will not be used in this
window, because in damon_do_apply_schemes(), damos_quota_is_full() will
always returns true, preventing the scheme from being applied to any
region.

Therefore, add a short circuit for 'esz < min_region_sz' schemes to
early return from damos_adjust_quota() before calculating min_score.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from RFC v1:
- RFC v1: https://lore.kernel.org/damon/20260912124406.96535-1-aethernet65535@gmail.com
- Make patch more complete by covering 'esz < min_region_sz' instead of
  covering "temporal quota goal is [over-]achieved" only.

---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ce8c6f99106e..15758525765e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3318,6 +3318,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	if (damos_quota_is_full(quota, c->min_region_sz))
+		return;
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.55.0


