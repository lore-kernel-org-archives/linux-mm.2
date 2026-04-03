Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA19D730A5
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 05:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287136B0089; Fri,  3 Apr 2026 01:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210D96B008A; Fri,  3 Apr 2026 01:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1267D6B008C; Fri,  3 Apr 2026 01:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3C1F6B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:29:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B080C1B8073
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:29:20 +0000 (UTC)
X-FDA: 84616116480.24.DECD477
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id CE328140005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:29:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bvP3DsBI;
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775194158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mI7v9qZF+UUx3+2SXpVgBfGXsaFsLAnRc4Dei9eFP8E=;
	b=xIWvMvW/Pdd54td5JPHST+JxL7W9n+x8YEU1o6F6YhI7wwj5BXf7XJ6Be1HSLVdrE9pG0z
	K0iWORl0cXJhGv4lnBhgjYkUCRxvWE6PxKWQlCX39K3f93VMkLIeF+UKFR1tjzBjXN7Gj1
	ggYqoLEf9LyB6MjDhHfgHYJaIhKD0mQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bvP3DsBI;
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775194158; a=rsa-sha256;
	cv=none;
	b=rAARYGU87O8rCdB1VvFABFIMfGjyV/217bOx7ZW8ySXBsu8H1KkyNZY1EzgUK6Hw1XSEg9
	JjCe0qAaR5q9YVP9FDEI+nAkI6+v7ysOLAI6rzcypHyjkalHB5MSZEvIffZVXBdXOIMj1p
	5NnoPORFHlkEz0LDqpVZxxnmUeCYhAA=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82ce49785a0so701362b3a.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 22:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775194158; x=1775798958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mI7v9qZF+UUx3+2SXpVgBfGXsaFsLAnRc4Dei9eFP8E=;
        b=bvP3DsBI6dtlHGQGCvq8btJwaFe6Vmtm5laNnknBQkJd+qqDw7DrRaqBMvEupucD5t
         ClK3jnAVPBz987aqtD2HD9ZCV5k1KoovPa//knwrmqVn34H05OPl+z1txQulZFlmYcGw
         v18vu2TzCMg3Lqk9Ir7XjlROMHFfI9q6r4z6PRPQ0z7ILkLTZ5gU7jqPeSBPQaUbJOvs
         7piLQmkcXXOkaiWVWpOwjHop0vF7wbW2Po9X6drX3Fi5nFbLNV71qpWt6uzC3kOPh9TZ
         sIKjGytW5vO2VoMPMLU2ekOzw0F7Zd0YunxlDrx7BEMF4wBkqUF8OE4gvYFN6dyjLD1P
         Jwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775194158; x=1775798958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mI7v9qZF+UUx3+2SXpVgBfGXsaFsLAnRc4Dei9eFP8E=;
        b=jAYg9tNCWDgUMB/+KeVazxc/pJFcFE2yYRJH7lg++va0qvX+TyoHQbr7QT30GLz6g/
         7SkJ5yo+/TiUop5XiVIbUaQlUKXXCPbWu3VEz3VjI/RxtQ73Na4xYmmjTr//RXcdEA43
         POkAuEIPdreAZCA0BpQzff69WOpX8/ikpEYo4iiRRlJAAENjkwYU+a9HMo/FNvGN0H/n
         UPTyLcFQIOFFAw6fpuGL9Vs7ynXBF/EWcQoXxKzOqzDkTgM8y3+4bsbTo+EyODhGUzs0
         8SpOja3wYntiuEFmDFz6ex4qwnezOEGpbBTkYtg8CXo3db8N7OP2amj8u1qJ5EDUqVzL
         UHOw==
X-Forwarded-Encrypted: i=1; AJvYcCWwRHCalib3KakszOvGsCIcbrC1JzTW5J1DISleJjTE/sJdNPvzW+fhEh90GVHJTTz3F5zQsZAMsQ==@kvack.org
X-Gm-Message-State: AOJu0YzBy56tvww+kjdakpSCOQTSyFBuIzjMm8lMWZ/E77CjozXYgHAE
	ZInVJ8ezjTMarsL7zoVK5RHEsuiXBoSB3weM8Dc+1gpsXLxuUopzG04DMbVotA==
X-Gm-Gg: AeBDies0Vk74EP1BxoRr7pACsWAOPyIZ0vZa7b0765Sz79nBVhBNi5iEvGI6yjfNAeg
	s3CCrkhadosnMkgkk6Qq92ax4dJlNbpKwdlD9AM5ma/FBsS0egFRiNeZq/MUXiFSpj6uxYmAHaJ
	MaKXOiXLKyX6M3f6U8BlhQ5SUGxFVXq2WoGoN8b18i5VuNYltUVlame2JQMN6odazeuPXyHKqND
	BTf7gmlU06Dsm1es/MBjuPCP6ExKkJOXTYNzZFvV7vKwcNIunf5W9CB6jGtAtmlvGt7KFyzeWWV
	L/wduf0ovSd1aSzqkrbYsqa8laLIWe8fY/L1jShq4PeyViiVFtF04ozgGxVRMDMChlp1/F5mGyx
	eVN9S3k5jWwbk4POkuyDcGlwdFWuH7+u4dqD71srshun/G+ClxH6keOPTE8Ee0zxIM5LqC81i9m
	MZuhtqxxj32TMuZiFRhwb9+AoOFcU=
X-Received: by 2002:a05:6a00:2d02:b0:82c:6cbe:7935 with SMTP id d2e1a72fcca58-82d0db53ea7mr1762098b3a.28.1775194157683;
        Thu, 02 Apr 2026 22:29:17 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82d11cd2ce2sm782120b3a.6.2026.04.02.22.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 22:29:17 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: yanquanmin1@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 13:23:49 +0800
Message-ID: <20260403052837.58063-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403052837.58063-1-aethernet65535@gmail.com>
References: <20260403052837.58063-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CE328140005
X-Stat-Signature: 3ehkgr8xk1zm3rtdeo5imrhm566fut7k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775194158-995977
X-HE-Meta: U2FsdGVkX1/uhd6Z4c1jrUhBPDWgR7iJvy25D0fX0E+qPT3wMagLq2OOV80P2kGfojfdBF7HU11GW6GGg0WgI/SO4HzA0FT87JA7RZVqOf0zlvdBUadLJ5VSqFcQIT9PHkFzS4GyNJLgaYP6xG1CkUH4qe+KgEa4oRkocIKVGymvg6LtNUuMrDybZV2lUB8Kwm2u+GJg0BflhKI/k42/0LQ/1RKf6uMqfei+fBbExGzTRqHt0yxPuICjrqJYCgsg1FfQo5oYzPJ8xhvzrQLLoRDwTM7AMy+OOm2J2YOJMl5dLa4Vda5S5y9wbp49UELGYKP77qi65ATjUfWXgH72ayXrjCDCkia3ITJ+ORjkyjQ5oPmXnoOhYf0x0Kqs/fzhWe94GrRsP7TQsn+UsRNYW7NCJi38NXpZiu55Lx8kf5x5w9W7oKdGIWa1s+eP1eOUGAOK8xxBh27dLpl3y7SnT90Y5iNoeMYhuUrICnEGnQtQ1/JJrCt+SnJ7ShNa0zgcki9nZ2CooKO5etW7RARBAsPcAM4FXulUr/MNQ0xclGISRiNS5stNwyJyBiYYm+Ve9mzKjqfU3ZExCjGGJBSNF35bolJE+TyOz98ZlsiPmRbCaybZXw1WbvIxeEdb03zxc2+Yd5lgWGkzhtVveXJ31xU0Vpv+vy8kkJFbQJLr5sX5bkYthIVKtpZ1UnidwJa3ZxJ2HoWjEDTc7/z00rwMGjSUbYuoZjZdhpw0dsp6uYXwcU9/xf3ahUtxZbUwNeMLGawbtv5j1lIEwwWhTfIf9yErsKt/+kO4rl42MjA6YvWTlOtb11hB61rW7t4PnoCW2cu/vLluj+izSPN/B6mpLaun3TL2S+3pB8QaefcnzaBTRf8tfD21BLtQ52nwTFFrDrMULcqZ1VdrObPSjkXJjIMuB0LePm0roXY1MNdPDkZcOyMUnf/FQIL77xRuznxcrse/0ZL8cW2qtlhc6As
 ndMQrkyC
 rg78sQo2mIvvNeeTgHgirvePerp2/MtZLioZwr452ulBIiEmAJY+Zup5NSDNHK/RdynRh+/bsFvE2oe/9QkzJgedyy72N3Oi/8Y2KP2/GW32Ysaxn3J+MFQHbabA3PkOlkCPj94dmZaEaERZOP0nATwdnaJ1bPIjZeEsPAfGekiIpfd3n3AWQ9fuvoR0R3GMwvQ4WWHxykYlUTHovJJcMbxhIfX27ocf5KCKZJHQe99Yh+b9muv2TqWUDgax2jE8k2k/ca603Um/a3uOYlyOrLkQaeLGS3Q3dsRCS2ktSpQWLyre2GcUekpdVqyGmtIJFUQLei7G1bMgnSfG0UFqVGnraO0SfLHg1zO3Hav6sfqct/xdn27TDw7g3XluIIttdDJJOkDME7HTNKA582FjvdG9NjsJTQuvaFI9v2EGHNkX2pA2HSbgJ1TMF0GKR6SYV+F8qM6D79nu7YlyD2R9c5e3O46Xz6Ntq0UpAUFWvQjNRYQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_commit_ctx() checks if 'min_region_sz' is a power-of-2.
However, if an invalid input is provided via the DAMON_LRU_SORT
interface, the validation failure occurs too late, causing kdamond to
terminate unexpectedly.

To reproduce:
1. Enable DAMON_LRU_SORT.
2. Set an invalid 'addr_unit' (e.g., addr_unit=3) so that
   'min_region_sz = DAMON_MIN_REGION_SZ / addr_unit' becomes
   non-power-of-2.
3. Commit parameters, and observe kdamond termination.

This patch adds an early check in damon_lru_sort_apply_parameters() to
validate 'min_region_sz' and return -EINVAL immediately if it is not
a power-of-2, preventing unexpected kdamond termination.

Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/lru_sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..3fd176ef9d9c 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0


