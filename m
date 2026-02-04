Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E664E8B397
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 03:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746CB6B008A; Tue,  3 Feb 2026 22:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706D86B0092; Tue,  3 Feb 2026 22:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D566B0093; Tue,  3 Feb 2026 22:40:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE816B008A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 22:40:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEB658C273
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:40:42 +0000 (UTC)
X-FDA: 84405372324.26.98E21B6
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 11AC1100003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:40:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mf6mgsFe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ahacigu.linux@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770176441; a=rsa-sha256;
	cv=none;
	b=m8DSwpqYKjKoIhBJp9OA85E6FGnmzEMT2po0k2Id0O7ieKh7zd+ThB1EfA71fOPseGtt97
	a6F+WifGXfz1MgbtA03ZsHZF1sg5rZth6dXJGaZPJRJuoP7lTm08A57t3/gW59KR3EI7dz
	9qZAO3pYhki4bIkk1FnicaOEoISI0O4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mf6mgsFe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ahacigu.linux@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770176441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEcxDmerSlAkO2lHGdc9P75qVPG7oUcA0CfXwCyljTY=;
	b=PC5iJzM1KdpBRDKoqcClwE2k+aPomncAiiDNvvwyymmAy4n2iPPwdKQTx3nUE/+Irsipiv
	yZgUnpX0jsLwqg4Gn9+5X1my8KuG/9g3rva+gh8nPFDRDwV42Nw3tHSxAOT5mTKK8YHFbl
	YDJGqz4h4fQH9O3afPI+gRhjadotDxI=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-124a1b4dd40so1448490c88.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 19:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770176440; x=1770781240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEcxDmerSlAkO2lHGdc9P75qVPG7oUcA0CfXwCyljTY=;
        b=Mf6mgsFeNNZpenP+Ogoy9oJfxC21cVzoYDDoCG1oCvhwpwr1ric/vwuD4RE2u3ABd3
         Nlmomh5lYkJhwoC7hhASFsyKKeDLSWLD3QZOc2YBh+Vp9PrRkXoJfG2wHRr2ibzgpbEy
         yO6aRayZ1C975UJQTJk5oOqFE9/DLNdHvAKtQC8S+j32CMT9zi/0glJOxYoa8tIyrv3G
         Amr5j8mzLx/XLpNMbqSu8sm+ESafAVdPQyeNdVMXJFhec4Y+/pwoz6Q1kJrd8Z33Wq9D
         RNX3Ws9XHT2LElJXV54voDHKm0SmDQddpC8mvWI86bm413niTyReIObjfeJXHGmjss0W
         nL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770176440; x=1770781240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PEcxDmerSlAkO2lHGdc9P75qVPG7oUcA0CfXwCyljTY=;
        b=w6ry8ilZC8TG/1FcxDcY0SMYiyPJd+FzxdWnrvEOYyk7kiOU/lj2+qp0+Fl8Ppujj+
         uNebUpllrr1We5nd5E3jiDAVB3y/6BY9oEZeyOJN0L1VyC1dlSGXjWnXegwC+J42jccn
         IwdnSAd9xzBAw3C8RSp6/gkY7DRexFo0IQ6tV8uHjDzin9d9+R2Ul1yk0MsuBPLwkWpY
         PoFqUxZhiTbnCqdhBBDbWqdhI9DdLVT8+UVnKlkReztro26O0Bp7FrHORHIrKO1bW8Yg
         3MAU95vtFKgSp7r7Qm73kM+Zo0DPkbdBV2F+jmyY55eHk6aRDHvfqBSJ+lKAn+fbCWa9
         ESQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe0J/7LZuqkh3THSBald5GCC87UjUq2KE3q51RyUpLLHugRVTNru7aRoiJqFX84Iv6td+NY3Z7Kw==@kvack.org
X-Gm-Message-State: AOJu0YzIWvnqE2dANIfZAQn9JBSHoeTvQwbyvOSc5F+M7qn9I0zbCfP+
	hNkvJGcObM+YcLMIk5yBg+LgNp+ZIRa2oCvUnxlNVjbjJ5t2hsqee1GX
X-Gm-Gg: AZuq6aJk5yv3H5Z1YmfL+3EPsCuB/0pS4FkdZym/UlwiOuPOMx0XuCp9tRdX0QncxLW
	CeWOhQJ1NmJjLRzCdsnijMbMRJFFQrUKtotItqq4td3FNKfypsSCQRlNhrF1iL+eqHQc33sP68E
	MHYx1oyPaShpxhKgafoMsHWGTHfNwXDftNbmhe3RCAcKiDWQq/M+jnYF1BUhYuD5/N4v03OhfI/
	MkBMHnsxr0geAiv2XPAynKDuMec9olXOAFkbkc4AEeG3yP9d7SdSKo6D53GBVI5IrFC2ho9prvP
	mH5AYPbg5t/SY7w1MTJ5PV1RHiC6pJhiuFPNwlTd40b4VV4N4uas5sI0A1MgQCiPQdAbGr6EWyn
	qiTVPTI9zhZPMzr0nlLZ9FQoyWBddXbbKro3438JvrgAdG9vtLqXqVDgw4KfFq6SexvlQjwO326
	LY69cIeR3vZZ6ubeA8yfEXq63Cg10a
X-Received: by 2002:a05:7022:2506:b0:119:e56b:9590 with SMTP id a92af1059eb24-126f478d974mr985146c88.21.1770176439684;
        Tue, 03 Feb 2026 19:40:39 -0800 (PST)
Received: from host.td.teradata.com ([2600:1700:7c:96e0:8ef0:7f51:3a57:a1da])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f5030df4sm1042892c88.9.2026.02.03.19.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 19:40:39 -0800 (PST)
From: Altan Hacigumus <ahacigu.linux@gmail.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com
Cc: ahacigu.linux@gmail.com,
	zhengqi.arch@bytedance.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
Date: Tue,  3 Feb 2026 19:35:53 -0800
Message-ID: <20260204033553.50039-1-ahacigu.linux@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203073757.135088-1-ahacigu.linux@gmail.com>
References: <20260203073757.135088-1-ahacigu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 11AC1100003
X-Stat-Signature: 64dgmhbcy4c63gu5raem3sahjgpbgdb6
X-HE-Tag: 1770176440-184064
X-HE-Meta: U2FsdGVkX1+gcQ3fLNxcyelNCVoztiysomPzz7b+uKURGYNJEnNCHO0ibLYhASYsi99NCYgkrXAUj2GzCEAqsQhDRSbsEqto7zuZUM/j3mu6jdQscwK5YxVNTKIEIkoEEKEFwHb1dg6tMTpZ5/LKbSLDBzPJ3DnXM/CWpLrtvRn9E47FI/pAuDQTqFW7fpPy5Th+tFAi+HDIBkNh/5Q7yzGaQ9mrVq7j+eZ3ecorDO59CuJx960Swv3s8XKxUe9E4oiyg9MP4VgVpQ2gLnpI3NOWBdezFqMnjSEvtxvo4+rUM5uw8f7k7+VXsHaeRJFUiXr9lN9wHvt8JgBR4Vvyc9gk3tQy8fZTjrdbe5WhcW6sJDGDT99gt9H11H8wZTuIpzL7Pqt1s8ysTEY3wQOJg1Ya0aZ1axMHx8pnIBahymgrqo4917ioEH4uNegfgxLpea3jFnqUc96fMAwXI+LfJCzeJn0LOzK7Uc2UGMkUBWtp6pCcK3iP9NSs39IU03aOs7M/5Yy0c7ljy02N6NSnWkUQdX9OwJ+MdTnW5HBpckXXXekhmX+VwppWKH9Gu624yNRVHaNo8BOQi4gy+52NyFdy7A+gbgD98wUbosIxgLAQlLrEZCWzh0vTYYro907mAFelUXEEmJpMHJ4Gep+3zErNAG6PoSCnAG6GUUkWgRmGiHiL5OlqZNn9If+kjfQk6VPjy95NTsUY5fUUDLXDM3eO8oggHYfvsQJ2X8AlfVCI3K1ZNR1knmiuZg8P0tE1KSzQfhyItaZ6JwFYAf696snQ6F/O+9m5rBJ9cj60W6ZtLf7dVhE0jhQwvXiXagaitvBzcSN/vKeWHLwtZX8NjlJXrKjiG/y9AEBFxibaVQ2CxUV+wvp+aNCGVIKsoK6mXhEmmBpp/AVG7oHCo827BKjDr89m197kiAXx+2Y49bH3n9FZdBjiHpKTlarZrZe6VJTWpRx4hiazxcDVsYS
 vI3xZR1N
 BVL/GK8m7x223OXsjd5duQiFLaH80OHNrIgYANxXUSDrDRJ4Ug2nf/K/7t0+L2uhthXFX88ps5iMymKVXJqjijn24N1ee41l+aGgEumjJBawCPSHW5n74gPcVMBeU+3vL1srsLDYy2YsggRHggpNMGYcSbYtiid0wxDMEs69loIPeG0KEL5GTdv7jNac/wpz5VnnPuyHWLZT1uWgmebyPleC7GxVvPTB1OHDjhGfkF5qRtlbO/6YktmKCtoXaL42gqDxcHYH/s7D0QuIFoBISSPND43bYx8wW34epuGJnZhGC6HhbjB/q5yy73aAcmHMCu8hE1PEKWeoCpHnoui16CUnypzQgU8fjWr6Dd8gfrMIJInFk6sycUS20qTrGwEhBS1VmxC2e/3yPJS94sSH1Urd+Ha8epk9oSCvgSDPnCnQD+M9Us7qIK5TUCkMUlof6jZJmQYRLYJTs5k6Gc5rwtFImr1kHOaSZ606w58lg+yd5lYT6iHpZ0proZDLS23BfpP398zXxdT/OgXt0gfApokjccuDcakJBKl7H8kcPF78Dn1Yk1lBGwypkIhNC6RFIj7mE3FMiOdFQZ1akoBQuHv9tDzJD8+WFNV+5TWOG1Aa9Nzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kmem is disabled for memcg, slab-backed shrinkers are skipped.
However, shrink_slab_memcg() doesn't drop the reference acquired via
shrinker_try_get() before continuing.

Add the missing shrinker_put().

Also, since memcg_kmem_online() and shrinker flags cannot change
dynamically, remove the shrinker from the bitmap to avoid unnecessary
future scans.

Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
Suggested-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Link: https://lore.kernel.org/r/20260203073757.135088-1-ahacigu.linux@gmail.com
Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
---
Changes in v2:
- Use clear_bit() to remove shrinker from bitmap instead of just skipping
---
 mm/shrinker.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4a93fd433689..68dc7b4242f2 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -544,8 +544,11 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 
 			/* Call non-slab shrinkers even though kmem is disabled */
 			if (!memcg_kmem_online() &&
-			    !(shrinker->flags & SHRINKER_NONSLAB))
+			    !(shrinker->flags & SHRINKER_NONSLAB)) {
+				clear_bit(offset, unit->map);
+				shrinker_put(shrinker);
 				continue;
+			}
 
 			ret = do_shrink_slab(&sc, shrinker, priority);
 			if (ret == SHRINK_EMPTY) {
-- 
2.43.0


