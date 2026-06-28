Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 109EEC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39046B00A3; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9366B00A4; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD80A6B00A5; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4C0E6B00A3
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D6DEC2139
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
X-FDA: 84930693498.09.96DC424
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8F2FF4000F
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8fNx9yh;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684087;
	b=dpNIt2n1t12iMVuzllYiK5LHyBbChnvERfOiRtq8bBciGDtTGHpaDP8zfTEISxryr0K68n
	KT6L4y1AXfH+0VRxTtdbrMsyaYgvB21XBafBMoPe3tNsApu6vI8Rvk1CGgwM+ymXuoI9dz
	p5YinGqSHnbIoKVXps8Wx4a3kqGqEVU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLnT+m7jG25ig3bUBCku5CL8OxagQ/I+mp73IyUAGbg=;
	b=jpAwo6cMOFb6HzSgBhG7WxPBBJw2/u7UiaNknMwjHclriLpQJSQJZ0XxrfsXWIpxP+CDiG
	l79H+tGsZhw7Q+esjyop+3IuVmUa/S6F5yxna5xJOIOBZ5hdJ1fXKsZyfbSEqYqHASgVgY
	+39gkfpu+zJlEndi3cfO5gu/hrQTe7I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8fNx9yh;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEF7341A8F;
	Sun, 28 Jun 2026 22:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F791F00ACA;
	Sun, 28 Jun 2026 22:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684086;
	bh=OLnT+m7jG25ig3bUBCku5CL8OxagQ/I+mp73IyUAGbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8fNx9yh4m8RKU4k+e7B4NxvXXng6Q4+c/r0GzRqXQOlDmd2tVJKsG/wnkV1tnYrX
	 Tj4EQ2QqE2MX8/iTZcKoaMwq7xVT+YEejajrWHdbqGchHdOoAOW1XXQxtY9x9cRydY
	 jGYtB/CmiCgkstBQUiV0o19rEacJPUqrZdEBk792caHhu+GlrYSNxkBmmDZfdlgXKq
	 7YFOhaMToUe07EZOXnyqlThz7fToCed3wSW0cvqxqJm7/5JUkFtwVlZEDaTePz0rir
	 SNitKVgXeJixCodp2JlRDEvpkAeEbdl1EDLO1LEKfwQhQhcIBznf6IxdQlOr673+Kw
	 JnobUstpcbTqg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/11] mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Sun, 28 Jun 2026 15:01:13 -0700
Message-ID: <20260628220121.97360-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bhstkehofkag3ubh1r1id7bautwx5xsj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F2FF4000F
X-HE-Tag: 1782684087-480826
X-HE-Meta: U2FsdGVkX1+Pw1Sjd4YWfgQLBJNfzqvpM02uQoxaqO2+UASqodg3l26zGDfy2L0dpE/zrrhxmpiY6uFMx6Pp/4MNs4lx3BxBGG6447p2EbUW7b1Ywm2S3ed6sFLptmsbbpRkYg2Q9ffg8+nYXEv4n42BEHUDd6ASVOI2aBCcLLRYKz5N2JdIUGC+TOsJI41rTQKoWeShE58fdBffFFql5tIFAn1seN8e+r22FrLBJ2RAe8JdJMGhoHqWK0riSuvWDlgD6JpA9aBeC8BVScy4DxxAJZLHNQFretIH0DJEuusUrldtf/nh1WwI+W8zWxTNIgQIbOTcu/o6mF7Hb6bjIMnU+0NQF7TiZp7waQ4eK2VTzcfuagpnKoalk/F994rRUlSDaA+U5hCPzMigEkrv+vbiTaNcEt3XrxF/jyHskWupw9jaiXKMP2/CPTA99EeTAl9G8UQ3di29D6P5JyS5VwO2DENZat7eRpINTAzmyB+x2H6WQQdU5HV0QX5XCwF6+RdINh/wROggibw6Gv3nX27mVUpF/oCv9/4WuGtJwWEZB5OmPWJ4FOgq0reHH/hLXZRQdbSigyXcuKZ7MAHwvn8HBUQUV8nvEWajSskFX6XARsFuUhgBeIY4oYfvtC7CYukm0QOECGbpM8sFFvIfSsD4anx+Noq7frgCUU+8IgLXUVLDZWAD2Cg/ebw6Q9iQSBJgMqkMkOPAHohqXJyCQ6r4mj2UxxB8qXMPI2DI8RP+g20ng/9Kn/YDrtdY+7QKuKtwMTK3PlMTvUSjEC5jcYDvKtyjjzhUKyot8ET+Uy0gg63Sm7UPuWlKBZSAMh6I3TCwkaO/m68NJUXzWmV9HAiwPG3oBYuDHnxnOlPjdkQRlyFhrhTi3bCqZPmdZ4fL62/LFsPlQeBSQCf0F48nn2lCIfMGz9ZgwMF6r81EnvCPXYO++lI6bKde993yaEKlK/UzIdFL1XFyGOJFr3+
 ftZgjSv6
 ox4kaAviJyJzfGbRNvuB/7d4lh5GqH9YS1J7p4+ApF0JaLos7K+Ya1Dltj3pBepqZNMIGft8xIwLPjL3j9BaW8fzd87QHLJQrmXag7EaNGg3SnRHAyPOirmtTieySc0eEhxdNSzBbNgMaWhzJS+xIaCjggSECufXoyBNkyLY8wN4Jq1tlJpi8iGYIfkum7A0N8BL+apMVpctBEwzx0teTAUpm+abESZ8WUdUooiZsoooTWiKrOSqywRQV5CTWR/lwV9oUgg5RbrQYDvBfhtgrmHAhgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme region directories by adding kobject_del()
calls.

This issue was discovered [1] by Sashiko, though its analysis was
partially incorrect.

[1] https://lore.kernel.org/20260517205828.6204-1-sj@kernel.org

Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index db496d2e493a4..9eb28fe77b5b0 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -332,6 +332,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		damos_sysfs_region_rm_dirs(r);
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
-- 
2.47.3

