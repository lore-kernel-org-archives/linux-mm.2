Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D88FFC72DF
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 00:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1EA6B0088; Tue, 24 Mar 2026 20:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7787C6B0089; Tue, 24 Mar 2026 20:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6683F6B008A; Tue, 24 Mar 2026 20:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE3A6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:47:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C81A1597A9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:47:00 +0000 (UTC)
X-FDA: 84582745800.12.2F17007
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1A6A1120004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:46:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cjHkyubo;
	spf=pass (imf29.hostedemail.com: domain of ethantidmore06@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=ethantidmore06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cjHkyubo;
	spf=pass (imf29.hostedemail.com: domain of ethantidmore06@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=ethantidmore06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774399619; a=rsa-sha256;
	cv=none;
	b=xmVQ2XQco70fcyjGT6n03Z0QGbNJg1fyfAb3N7yDtPoXy4n4H7pDWgvFAlNx5yVgHc/qNz
	zcRo0lqWa5ycnN6R28WDyeIP7kpQ0dNQq1DBBzXDQzPpCZI8V5G4ipU5RyK85G21ZKCvlm
	Zp1oI4A7z3mhVDhwRl7V+3pQ3MZs/NQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774399619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=br4xfo6DPIK3E3Vzz9aRMoe4hQrbDoT6TlpRHwA4dDc=;
	b=ZAUDUHrEUzrmFPJfnTKXVG/aAP5hge42EALPD+fla5y4B7DeMWB9a4vnmXL8+eD6HKbxEz
	7+BvlbZ4XTc2QI5bOiorDckCKieU5BrJmGMH3BAsZctRs2N96PhYEMq8ZOlRmUfWU7sSux
	p6gFNvpmaOWdYOSCFG5Dvzm3M5RlN40=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7982c3b7da9so19354307b3.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774399618; x=1775004418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=br4xfo6DPIK3E3Vzz9aRMoe4hQrbDoT6TlpRHwA4dDc=;
        b=cjHkyuboiRUYZx0W6m2HfJRmRbGUgU/kZVbIMlf0+zQSgBW7vza+CFmWQHtWM5IKF6
         05Ciw/XQARTLVZAC8MZNrz9Ph7YG/ZOHlkiDcHTXdLbJgV2e2rGtoVrAg2tu3Q2Q/q9K
         1drbn6MGt9tY0NAvVb2OPojmP+7KRp67spl01tNJEg3ahLZPIqNeK2n4Ki58ufuiLH7g
         Ts1nG5qDn0/tVH5bwJ922w0PvnwBj2SmG+V8Wa2BIUPYZ0LayWDA9zbANOUpx7DrS8wh
         llHeEne8QbGU7X6cXyfEslD3Cdj+AXqmY6K8kl6mvDLylkLtn/K6pNfQqySLPRFzFMPJ
         bFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774399618; x=1775004418;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=br4xfo6DPIK3E3Vzz9aRMoe4hQrbDoT6TlpRHwA4dDc=;
        b=I0NfFITY3VNgBYEHy/5z0U6AwuiZd9i9otJ7tV7GsvEMzXu/1m6dqzrjzrOVcltnYb
         uzm8TCuQnHO4cpxW4Fyclx7ZntXzUYgY0r8m9yII29qNMT6lsGzqkS2DvogW3IXmSjue
         R0DA8E1BhMLWNW6iEW7vMsxW2DBSNmqCTicb+sFjqEo6PzVJB7rGiCbmXIvH27aaUsZr
         KqPoEBr2QzOAzHN3GaYaVLTsH1cJsIS+TXhiWoT7gPrpymb3UrjawN0O7FKyn+9osXs1
         s+Ce8G4M+entrF1P6P9Md8DUNm0FBGlVeUCPn83oidZMCrjDAGMT/5Jhi21L4qb5+MSQ
         p0Dg==
X-Forwarded-Encrypted: i=1; AJvYcCWKJ60OVcTpl/EZHogKNPvpzx+WEunFG1YLZ8fbKvoqPi98YJ95bKZtsdQaCMSFqg0Nm6Fkz8JdvQ==@kvack.org
X-Gm-Message-State: AOJu0YxIl1Ygy3GjLDL0TSPuZXNcIzputuO1g9v0fdIh6YVReg+6/R8S
	uPi3KuKpH8OBS+kIs5OBvCiec++fvzqpUNkwqkVZn5J6Cl/Fto+Z5vq/
X-Gm-Gg: ATEYQzw7Pl/wrJEG3pnXpoXPZrdGrBbb9lHmPgK75nw3Z6ik8tAGfxzB8mCv2GIu54H
	Mk90xFt17FX2WiG8zREzUPwVut3D2h16MBzA1FVWGF8V+QYoUqIuoOkw0dRb4oENlTabuIBK8qI
	45glylYGT60CRra8Rt5RkNvqsaNsakGfCLwhey3iKbmcTkLelI1iTmspaPoHy89Lc7QVrhvh3QA
	QQecd+2NxjGUrGVqtiYEIHrKk4yddkMKgskMLnX9ZC6on/IueSOWJJ5sygnRpVCrFnOSM0537nk
	T72YAqMMiLK9wcbqlsoGrrwsa+wRthzEzRspj7Cw8UZBuy0YaLgbpzCElDpNy6iEpRoUyy72Jxf
	hUjNKtcsctvD3/0w322tNlwmNmjoT3vPSUjI6nyN8t5cdpMzeuUZKSySLY9CY64EAUry6wBQ/LK
	dMAkWWmE/0xrd2CkT8Yu1CScMYzTiSnF661sBYY+G3xNQNHo0DrgvSfd+48+jP9oqcXhlW0Pvy9
	4nXgAEHiPBS0DWqD8LP7Dug
X-Received: by 2002:a05:690c:c50d:b0:79a:d32f:e4e5 with SMTP id 00721157ae682-79ad32fede6mr3965657b3.45.1774399618019;
        Tue, 24 Mar 2026 17:46:58 -0700 (PDT)
Received: from tux ([2601:7c0:c37e:2360::17e2])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a903a33acsm81997887b3.3.2026.03.24.17.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 17:46:57 -0700 (PDT)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: Mina Almasry <almasrymina@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH] hugetlb: Fix possible deadlock
Date: Tue, 24 Mar 2026 19:46:53 -0500
Message-ID: <20260325004653.150734-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A6A1120004
X-Stat-Signature: 9k9rfgi1resbg4prtan4brghy4yueaxy
X-Rspam-User: 
X-HE-Tag: 1774399618-960078
X-HE-Meta: U2FsdGVkX187Ho9LtWU37JVWqXfRwNtk3fqAUnzuILD224EBIAnXi3t8ykxUZ97BCkWsRZbMdXXwJTGNl6/Nf7envV8Rp+0356kInIe0hC6QtI5Dw3cofVGT2tSuZbYQTctIKa+Wy4jmqtE4+iC5YPSuem/L2eWsW46cm/lIVM17yHHFiBgA2soyy981J7U3YTRzRlqYn3G83HKVf14xa12tG1LEDe+OdwrpsSMAbpQLbuBxEbSMVXRfZ6xEupjhBUTtpBmQySSzhfLc74vnEkoZjTcX1zEGpe5+9G8dI8ltHkG+VZunI5YPfcU4yfAcEJrCPlyPbrb31zkUrFO8hK++tb6veFcTU+oOqeqO8D/NDx5Iii4FTwALgX5qHUCpYcfSdqDJDIakOJnmavvmSCZasyxouT9pwguKfOpZiHc004zOlIB/6agcCg4AZnrHUMDI1fp38dtSN3U8nZlgyF2YrygklA/vMOqmtMeHMy9e4s8u2kpiV8Jsn0JLotgbZZFD1MS+bN7BN0ZnJ5jUginh0Mgn+S+Swm02UEc5QfG1zdgrvI0nlwhvcixqHJm6pCWeH7HhU+1cNUfBFhicPqDhA/dLN4Q2QRIfhhM43EV7Vl+w7Wgsl7MvhVpoBaRDhfwRurCSoxD/FbEaAO0XcGNDJNnmUtUlpAd5sExgsSqqeXXp0oL1ZhAQAufFkNSsRaAvvuujfepaMQrGWhic4GjfCfmM7K4NBZ3Cyce2w6VVGFNiRibnqkkd/eJLb3UvBvf3h0+UqM+FQqyTb4M98OLZkg/gYVHNYyOS2GjRdU6Ji6yGOiXPnjNKEBWTNVwpt/p5LPLMlsR3EROmV9EAUMxEISxMLaZp0NKHhFoEptGNPe0AF+beQ2r01pvKs7HRJZ7uR7koaJTFO2atcka1rRVJbqJD6ELXxXjvvx5SVueAn0l0GyuaViC4h04Hmhhhj9Ayl/3Tv8UoS+HNXS3
 2vdGjjcv
 axo6SLKT3uAIQ7qK7VOc7OW3OIuXbKrUo8rHZoTEOaAeZSv6A6kTlXqRcJmxBH00sHtiTMV/+S5TugkR7FEbpW8xTzbSQWA+NWu9nZ9HKdegmOakuN5NZcmrNVP0KK9ouAdMr4R96K04a5t5zpRmT0KCMp8C6j+EMHa4dxSuqwRuCHqVO8fUpfNjn11zrCyH98g1O7BCmGqwRp67Eok8RQSce8DDOoiNBO5jDNifjlRaTP0xVqIsiYvuzv9LCvkP+LxdF230qiB1T8kyFut5d7o7uCj6VhF0yC0ABm0kwwWx94C8A+zmrzS81VV9QdBWw8Ar6l+s5CCPfB7HdPOtT8zjDs3OOO18mKRNVmgil5RL/j4URtOpUcBnVFy9YVLTUt5806tEPhNXLxJxyZdtANZB/1dOYI+Y0vWQG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In allocate_file_region_entries() error path the function region_chg()
returns but does not release the lock 'resv->lock'.

Release lock 'resv->lock' before returning.

Fixes: 0db9d74ed8845 ("hugetlb: disable region_add file_region coalescing")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 mm/hugetlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d6ea11113f1d..230fd8c63588 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -807,8 +807,10 @@ static long region_chg(struct resv_map *resv, long f, long t,
 	if (*out_regions_needed == 0)
 		*out_regions_needed = 1;
 
-	if (allocate_file_region_entries(resv, *out_regions_needed))
+	if (allocate_file_region_entries(resv, *out_regions_needed)) {
+		spin_unlock(&resv->lock);
 		return -ENOMEM;
+	}
 
 	resv->adds_in_progress += *out_regions_needed;
 
-- 
2.53.0


