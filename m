Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A32EA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4F06B0092; Wed,  4 Feb 2026 13:54:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F806B0093; Wed,  4 Feb 2026 13:54:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91FC6B0096; Wed,  4 Feb 2026 13:54:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 947AC6B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:54:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4942013A3E8
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:54:40 +0000 (UTC)
X-FDA: 84407675520.14.F668FB1
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 76CED1C0011
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:54:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YqGSPis7;
	spf=pass (imf20.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770231278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2leZ9sjvEmG28RjxSR5+yxVjP64v9xbqal0RbR4La0E=;
	b=tvB1C0iZC8ZaXPBI3gD0QYuHxPuegS5QIzZ1zJSPXeZvWJa8C59SSJT4Z8o0qsDX8Vqdv6
	2MM09ELpEja6e62h3dGrz6BCYH2n80q7JRt2qkWMxf098u8GG9hH/IV+IKWgOXJgJCbCeR
	S8ugyYYGEYrsODrDwozvVq5z69LuvdU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YqGSPis7;
	spf=pass (imf20.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770231278; a=rsa-sha256;
	cv=none;
	b=5NEIF88IvsBz2PSIlXFteAPG8pb+w8GI5JbtaRvHc581UMRL8AeKKIh2z/8/UvgJxFTjmG
	qdYuvR8W3ezVW9l44UTyB69U2dd5v4HcMx2+e0JUvSTUgt5NqtOmVlN1wUzefiKVAl5h02
	mlMFFWHVPqeZlxRp0jD4be6+aj20HXg=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-81f47610542so97827b3a.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 10:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770231277; x=1770836077; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2leZ9sjvEmG28RjxSR5+yxVjP64v9xbqal0RbR4La0E=;
        b=YqGSPis7R5DXRk2WjnDwVjxAReeZQWiuSoeiH9C7QPqZIZnU3wqP5hJh9T6YPayq9M
         4CFaMqjdKA2zJytU5N5zUyI9f85XYT6VvNU9P6XSSTb/Cz6ohvlECCo8eULi5vhnVlcw
         K+Nfca/UTCyzj1laZEkXW6C6RfpF0T/3VUacbW+n1ZR4p3H16Vzz7JXZrK3XMjK6mo9x
         DnznYnqLGH1Kdc6zPaOTzwF4ARA/2ooqAopwvy8c67G0CtAT0/D/M6ypZtrOG19Eb1j+
         NSglYOhHavxcwrDip4GvwIPZ4/YEPDr4nnGiCBZLtWQ/DdyfvyM8OIf3zLjHE6ypYLj9
         NqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770231277; x=1770836077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2leZ9sjvEmG28RjxSR5+yxVjP64v9xbqal0RbR4La0E=;
        b=oRFDtmwEyG3IUcG4IoC6CFcagyB6RNuqmHqCZxrROmjTf20WKOUqSffOKW2F7DvRYE
         CiTB4mFF8e1K7OAjxmEgE2gwoaVxaHed76WU/feXWD0bgf2aodTdsIi5SjivM1dKxLkY
         aqO+IA4cfaVfc20TfHxQ0sjp2nSxhO/JColrWFL+7NIh319RfdKdnSOv5ucsHzJcc8XU
         ifwy/vu9wwo+ZpeyBNG6W+lD3V/vXfMKPioC13IRgj67K5MP7icGn/o6KiuknA7wYS6A
         3UHjBR9awkz6CbNWeF/K7lvn5115hYc1jFx2jYAKKB/xPkzUidHmuVTLtKBmGxPR6RRi
         vo5A==
X-Forwarded-Encrypted: i=1; AJvYcCWhr2VRSWqdFFg/O5BAUyIYD+/DtvbMpNKYOyUl5D9snEGrBwPPloxQevul5DnUefeC1HrUirn2/w==@kvack.org
X-Gm-Message-State: AOJu0YyHoFNdY8BZKlgXT6tdaxQjs7Y/zJVZsGqmNi3SqTrYLH/i95c+
	Tq6BvypYm0Cf/AEZZ4AdB9L8wTzGuBb4k1yxZ89ZiRBWAAJLM+2OWYLt
X-Gm-Gg: AZuq6aL5PIjog5IIBmAfXSj0uHCsY1mdyuWNaKcHuiZqxc9/5jJIisgWVseUbEheERU
	krSVbZrVtHi2TxA15Kq7bJMcvVEmkGQNpb4UNBOY2iRnJLPNKJZvfU4g6wUr2cd5bWyc18dm3Hp
	/fE2gxj6h5B6mjDCsKHA/38prDjVhsSOWu8AdceXh2w/0G7fB4D/+MoWFTMFa9EaL4sOMddcyIC
	hQC5Q5Eq2iujJW06mFzKKXZWgvCEFi+V+IiWxrQ3HlSHgSNWY1DUCAa93I1oJDZr8/zghabQysn
	At5vMuWLpmrxHo5kEysCDJPw7/PlSd0TA5JU3+sypXoZ3yqduiuePzsWwD8luDzZS/0E96unTHv
	e/9gyMRVLtiUv7MVYEw+ArVzIx8pkpxFAEYDwTddvybkI7h2vhE+vAKZ4Tu7z3B1erGnakBhkLp
	QJCQQSJcGtonawjl8An4ASt/2IQA==
X-Received: by 2002:a05:6a21:3994:b0:38e:5535:bb4e with SMTP id adf61e73a8af0-393724cbd73mr3419528637.76.1770231277211;
        Wed, 04 Feb 2026 10:54:37 -0800 (PST)
Received: from chandna.localdomain ([106.222.233.39])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c82f2c1fesm3128562a12.7.2026.02.04.10.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 10:54:36 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	david@kernel.org,
	sj@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH v5 2/2] mm/zswap: use %pe to print error pointers
Date: Thu,  5 Feb 2026 00:24:08 +0530
Message-ID: <581a26f22fb4c6ce04aeb7ee0d703fe64454ac7f.1770230135.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1770230135.git.chandna.sahil@gmail.com>
References: <cover.1770230135.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76CED1C0011
X-Stat-Signature: h9awiz4fgmp16txfkakozj8ypb5bce7m
X-Rspam-User: 
X-HE-Tag: 1770231278-781786
X-HE-Meta: U2FsdGVkX1/U9iRSvkgD4k81oIZevCnwg0qWIy9bc2H7uxnoOLd13h1BtL8WkcWb24sJaC8xkOIanWFzRhvu3dmCXNWemC4r0/CfJVERDnKcZPje9xAdcvqzmMTYCVxVPa/FAkrVlsg7hoMZVlT5VtxU/6H08QPsmA2vPyB1OCWXimRRbz8Hwdf36NUzj/0x3pnyh723nzyyCNbKf97MFqJSFXxDo2SJ754sMOXgNX+/L1oPex3AWuZaW+rLqgef1/5Hw9umzlKO/BlfMNxf5VBqDd7Nyf5+cpNYBzQbTA2/QPozTRvDjTdLiWZJQL64cd5XF7ikGdYUTXXPoGp4G7xMgj7tty+uhNla+xWtYc1bQb6fWIgHQtFaPljPKKfEjbOGQ80F2Xh8lg7SpM9RJXnBUHw6IQddqO+4iAARc2b3lt+TFUMbL+OT5/AD0ozt9QtV0XRFQDtBQT76iew5LGLJEpqQuo8sC8M5isfmqJm7W9d2fc1tQ7bGah5eps5R+kbsqzjGj4HyOVAO0TUmsCS76OcAkD8nkaz0qocVV9f/7YmUpV2EmHgGsDiaAKRliZMHdSVOZf7DRx7aBK752474uOqVzDsAE17w7pgZfp0dJbr1EJWguvd0ekjqnEwYqN22C1AvgO7uyRB/bV75t4naffVYH+zoe4x6t4xs15J8HnqP4m13Dme8/l5XtbbBGnzYSlwtH1Bxyyfn32Om7riCAjoZ/At06Qc1KOn6Qvj20ecLafW2Gqq53Yxd9Q2PtdS04Jo25j+ZG4MMmbXa9pDRqYst+WWRZ3r3X8gs263WK/Nv0hSw9aIieRm0WEjjdWOl5bJTJs1Mj0vGt9M1zzSzj2GeO6h5y8VhaY5m919drhzj5Yymxanni1/fOYpB82nujct/hhsMGW1UHeZM2lemHv9fuCUtOq+KIonqeUn76v/Oopwq/HHcXIjDyNXWRyga0dcmMQgmWUy1ffH
 tfqBKQm5
 +rYLH0w510ZpQu2uNeC6aTHm3OD/ME/FgVAITcfs6hiRfp+EPX9OaodAEb7gGzHDLbesx3SKrOBqwmJEXPRgQqiGcEqk5j7GTSzZgSvEz0WSwTUy1IRjn64X1y0+mXvO99DZcKi/LaaNKzIODYMICdoNQXh0lBjhQHBGwBATTjFU4zkdTD0IX+yyNsh5n26MaqvOfMKshgYo+sTP7ORjwDJdLVo0d29GSlMr56QbruDDR0HMnW5luG1AzmA6Zv6Vxwvh4AbWY0ENFisRL0cJ0OIKeP1WIZI6Z3mjjLWLS2ygpx1ZaCLIl4p5Er7+Gw+uDL5EtGR/4kXbYLZrSUc3ezf+WgKKsiuiNkJ06p1Cmzth7HA/XmoJOluU5pUHVP+e0AH5pvHr9A4FmZbpO30/+3vYUCCZ6UJqvXRry0JjCaVpq6GdEKRc5WOU2sOHT03PRDnINPCxwqkl84X8Wnb/C3NXvvD3IRHQmTaX1W6Rn8mXrJShalW7jUHwsMLd0lseYSMW8dYG8mJbipUr0vIMqnOPAe/PmMngHs0GCivtTzu8L3RvY5nZ+JPLoEeuI+ntOF/7hfVY+Kk0dnqkBlpOLQKo5l3TMYJr1k2gzVGiv0gI0DtaiH9sIXEG7z67JbjMcXUrL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
Changes since v2:
- Add Acked-by tag.
link to v2: https://lore.kernel.org/all/0c00ceedce6e0d9aed35cee5faf15fd9126a1f70.1763796152.git.chandna.sahil@gmail.com/
link to v3: https://lore.kernel.org/all/57b7205813aa87c8f5c8bf765e5a8d88daeba68f.1764177933.git.chandna.sahil@gmail.com/
link to v4: https://lore.kernel.org/all/6d729a60eb71baade3670e5bb609a068683af3eb.1764312627.git.chandna.sahil@gmail.com/
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3d2d59ac3f9c..af3f0fbb0558 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
-- 
2.50.1


