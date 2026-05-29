Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF48CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104646B00C2; Fri, 29 May 2026 12:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F116B00C6; Fri, 29 May 2026 12:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97756B00C8; Fri, 29 May 2026 12:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC3926B00C2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:57:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B8841A0213
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:08 +0000 (UTC)
X-FDA: 84821062536.30.B2695E4
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com [209.85.210.66])
	by imf18.hostedemail.com (Postfix) with ESMTP id B18771C0008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jz7A9WIg;
	spf=pass (imf18.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOfd8pSjBXyzWHpK5lKV8S/iJy+QOz+9xXLc+9tqa5o=;
	b=bvpWr9OU/zdEFJZbecOPKuRzbg6TTN8vwrnH9xnXMI4M7Kwz0+eR+LK/5ybhPuxjO8SPZv
	BUPqIiTKX+cqLMjmZUX3u8AWayx8CibPgDs9ZZSVcyrZwo5sNzXwohL0sAi+HOUG/MkSwo
	OwSZL46Vesi0o2rgg2TdLcMNtB5i2mg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jz7A9WIg;
	spf=pass (imf18.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073826; a=rsa-sha256;
	cv=none;
	b=qjA6fStkp3b7Tb92PVl0Rk0YjcMmDS6tdQBic2rqLGvLVa9bPC4eLcoFZK5kSyeLTsHi7h
	7gdCAHFdnuq34/RNF8xDHmBVIoULhh6kT5okj6DLQ3OSJxDH7amClnWVeOjA/wa7OqaGJH
	HeIXkkpKrMS0DRjd9kyFEo9pzAr+DD0=
Received: by mail-ot1-f66.google.com with SMTP id 46e09a7af769-7e615b4c2a7so2020146a34.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 09:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780073826; x=1780678626; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aOfd8pSjBXyzWHpK5lKV8S/iJy+QOz+9xXLc+9tqa5o=;
        b=jz7A9WIgzkDTpOeJ4gPJTkGhsDdZTqy6jP5GnBs+5XxEiJOYS7+2Co4tUYMcu+nU/s
         1xIGWDLgkKE7ay2cByOQvT8djEN1cHZqza0XYRLDFzSajTUCxcSj0nKut8YHeKMPD4bS
         DOiTfen1gaWATLfxN/eLWBOeaGck0mh0r5RScueZKkszJzK5z36HKF9ezvwnkN2ZBl+8
         27UTQB991ySjchSw4dCSiqs0i3Qzh7Kgk/r6awu2cuwEo44yC+hxGE3Mxl6uP9Htqqo/
         40Ir1A7T5Oz5fw62FHQ+TgP7kx/BzAitFMnFZOXxCoMoJ5xGeWIouc1ew5h2sfGgITXq
         NzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780073826; x=1780678626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aOfd8pSjBXyzWHpK5lKV8S/iJy+QOz+9xXLc+9tqa5o=;
        b=drUQodvrhYny2uqL6iGDxnZukQJ+cXJkuaVpMsYtSXdC6jkU2Xkf39TPShHY7BK9t5
         sxQGsuQBEEQUajZXfPDiMF3J9yeNpwC8KFp6wyVOXjAQxL73xgv8iIp4thIQm4diiGJA
         598W/wW6GXiUhC2No44CjBdqzSw9Hm60K8rxp35p4ryLDtT/WrZU3zw9ynUesk0V0quc
         hubHUfF3djaqG2S1NbxVlZGlxNwgN76JZ45wuSKjlv1ewdbC0I69kFYyM5FKw32DWh6Q
         ag2RwJfpBubT0p9a/dx8OWsKr5Vhnlo5K3T/hSF5+MvqAWtKK1zuo6rytob7Da70TjCn
         41VA==
X-Forwarded-Encrypted: i=1; AFNElJ+QzWaCL//D6s7MQBoOMSZC7ed8NuFeThuZKSxMjUubd8OwfNH6KTKaUmEvfZBqRh8jZdWqlwQixg==@kvack.org
X-Gm-Message-State: AOJu0Yx4i3QJtLQbdTl6DgjYN2kbIhPA1X0qHCb68IBz9pXWgkSumaPf
	zt2alSiOAepQwmY4xS6pkBaDr1v7SwxxRPEd18LkPZbXh+Rtv42PGANunX05ufvQFg==
X-Gm-Gg: Acq92OHtIf+nyhPsEysx3Rw5Q+YeIHyiVNW6VhwMJ0fJsdo3Sd2DACFqrZ4yv5w3wNF
	pStACjKO4kpX36B9J9Dno4DjnrLO4lm855vBO1mXULanVBmzRn3m16vhEDjyteb0UySZSfRoK3R
	H2M2F2/4TIsy/i9pkbJ+sYU0FqyFBxN9oH46GM0oSBnkmr8QsP/gs2MfcnMl8QS9zVg/kaKcbuT
	Qa1egIbeEQKCQVUkmuLqqHK5ib5UYPQovzNQ3uXNsgcEwvruKgt4eNZqu2fXEuF6z++p4Z26fZu
	DvnXl54W/3C3Hj3oTpEnPLny1GElaBHs+8xXUwJtwUPlDd8Qb3bant2BlWsM8b+136i9RYIM/N4
	7exZEwcsXGFGG4j4IdFLN+J10Ne8pUlcypKmuvdS0NXvV+f/T2mUt7vKlzttb7a6TJLX6q2Kv1y
	N+QBSU46/SsxilxNYMZQ6z6aHIxkFiCZEI2gMBChJqx8mJNUteoCFEnjjntVjLTfxSs1y9DZ2wV
	kl1rAJClBk19TAkfEW7Ybk=
X-Received: by 2002:a05:6830:83a1:b0:7e5:f831:508f with SMTP id 46e09a7af769-7e6a1dc5519mr438211a34.15.1780073825697;
        Fri, 29 May 2026 09:57:05 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695d176dasm1812846a34.16.2026.05.29.09.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:57:04 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 3/6] mm/damon/sysfs: install perf_events on apply
Date: Fri, 29 May 2026 09:56:37 -0700
Message-ID: <20260529165640.820-4-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260529165640.820-1-ravis.opensrc@gmail.com>
References: <20260529165640.820-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9hmfywpsbwojw3ird3fhik81gw83e6km
X-Rspam-User: 
X-Rspamd-Queue-Id: B18771C0008
X-HE-Tag: 1780073826-128124
X-HE-Meta: U2FsdGVkX1/u5B/HzExX0HIsiPKRIN5MmoZe4awRNHaMQH8o9vWEprkGykn34VS02a/UO10GVRx0ldVqdGF2P+rrnPNTb1pjISo46GJJ6NidcVRxG7la7Ivp80pXvx9n1d7KfPaIA5jxmm3BvwPVihdXuD4ha9BRc5t4sPy73dywoLne2begv/tWZfOMB+HW4M6OaGUtyBU2tiGiB4fICy+e/U0evJEnEZdzdsWFBc+H7IsJuef6KMEDTICTYdYTFrrdzFYel3sn9KHlxHauDczVaaPDPn4YrFDBwLBNbyGUaDSwQUI+ywQ7iVCZbp1jHZA7iaRdnv347uKZtY/9rOYrtK7AkVsMn/A8bmwKakzEUctcverVYrLNOtlh6pPwHi3D2bUu9CFa9Y+VSqKeoYkEQnVwXIq3mFYcFEjJsmA+dBVc4QZyqGEV13j2vt7sAjNz77F7cJLF3AZ0OYdhg1BbPcOg312jj9/eZ5DqGlHfqfzk6/eNp3KYR1CoFKGk31B1SPfz3C/8G81YKQiH9CMEmB8niQXid0xy95nx7Dyg3aj+78OfoUTEVQR9VWKcQO8RsoqtzfS4y1j/4pV+VhckUAp1nGns9Qv+334R3wwTpOAP8GI5gOo2PSFZqUzlQ+SMc6DN9dqjxqTpFh6p9dkKxNiOqIIhfUSDT3HCZp4oACXJDI2lI5Zp9XyGSOtEjr5l+Ip5V6XPJOiPEnZks4EXmsOZmqpZtPuFVy2zH7MYUj9dJEqsC/AUeAwbYGQPtefxn2CUCIC7NiLryB+whQvVNX8btWmJFssI0vo8Yx2mnXN07Xg71ynwLL+ydcI8umI6Utx4CeiUaJ0x58iRVB/pC1kzqMJqwjfgujlyk8xi5U2h4QUEiAKLlc21jr5sbLnnrGY9E9jYOp9rmAPkJde+VatsG6CLuRNYIYG94GyIK7DZG0FngGeC6kGH3KEaNn58bOr98hHRzrsmIET
 NT6l3Gkl
 vicplInzyS2ISd8hXu06ci3Flyx2ELs1eRdajDysROLxW7NYFfG9UozHaJMk4WfC1Jva8IJK2zLDYneeJTi4NXnds6hevRg5Unu9xRslnB7ICgTDQhYi8dID/8o5NLB/+aBF8HfPemyB6fzmGQDRP0MM01rwN9PIj5NUu4RS+qG75mqNXbkkkzvRlzWW4nlW6xtK2/QtstzVMAZHEbNV8SM1qGiVvwOEpeK28xCfm+1TKfD6WrGJUYyErBnxd2dmiZ3kApUJL/jJP1mRA+bqezxXWmg1kzgb1bmyAqxF14bzdBDInK+5uRCinrpHlFzcCYu8j/weH6YNMUirq5KsyEtuem1ks4aZGRWzCLgmF2/b4MVmZtWbzOyLro3ZJvwZp54IqTz0JA8QxmYj7klafiOjPEhQDf4xWFDJKzDB83waHH3PQJh8CJKSMArHqLILi85OV3YaM4kGwsZj2juxZpjfGzpQqf6iy9MC1qPnCKen9ghlqk/gZ4JoKc/7h+5a1gdiYnc/ueLcLoteYHN2ZYrDWCLtUm4X0zx4DaWFDiqWWPxdg5efK2yfpYFCdWRcRtgVzRdgqkPrzXcvnzpvIGRZ0YbCoUDX3RHlUMJ1zh+xPbvjucR3LXndiQ1Ktj+HXOnaTIbHrMVd6foHRjZMc3DJfQv8h6rypQqQ9mM4VrWAzw4ZzEif5IZ3PNwMIsFJ3DNALWgj6CBib9bhaytnha78G2CgPTv86YyYrjxCxyhm335ifD7aCfSrt3ZYbdYC77whCHAvYVhOG3WCTmYIlCYXekCa58QiuPo8svU3YIlz+V/5Gd3G2Vsq+gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call damon_sysfs_add_perf_events() from damon_sysfs_apply_inputs() so
events configured under sample/perf_events/ get attached to the
damon_ctx when the kdamond starts.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 9f71871a249d8..bc4a931fe3f0a 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2092,6 +2092,9 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		return err;
 	err = damon_sysfs_set_sample_control(&ctx->sample_control,
 			sys_ctx->attrs->sample);
+	if (err)
+		return err;
+	err = damon_sysfs_add_perf_events(ctx, sys_ctx->attrs->sample);
 	if (err)
 		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
-- 
2.43.0


