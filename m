Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F079BCA0EE8
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859318E01E0; Fri, 15 Aug 2025 04:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831DF8E0002; Fri, 15 Aug 2025 04:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB648E01E0; Fri, 15 Aug 2025 04:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB278E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:50:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B73B1408AE
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:50:01 +0000 (UTC)
X-FDA: 83778369402.14.8C542FE
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 41CFF20006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:49:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W14Lil8Y;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755247799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=/NSTMH5SPq269hvY03ywFdZHtaC08nGguiJ+T8Zemn8=;
	b=ekq6YaGa3E/rET8B8+TTF6JtPrgH0Q75RLW4iahNea6GnUBmlucSiRkE9XB9i4AqlRQr5K
	KhU1bQ5hnGuFAYPjDiowO2JGFfPE4PN3t7/h6yfiw60zFO6kXUUYZkLWASTFHExcmg2ERN
	UkygYpXACv5Q+OMBntBeCNmAn36CBSE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755247799; a=rsa-sha256;
	cv=none;
	b=vUurDRbT3yzzvEZZeTlzDTOdlFZJg1w5MB+tOaoWD7nWlWRqRju5zAPVZyUpcAiR8Bdb3Z
	Vz7YgQ0dw7Le3+xaRCQgQpXkray82iP89xuh0fRS5NUQQifdsuA4gW1ZxxMI67RCTFEn+U
	G5xcEX4yf33tmFz8bZbVvaMP6VFV91Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W14Lil8Y;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb7a16441so261145366b.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755247798; x=1755852598; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/NSTMH5SPq269hvY03ywFdZHtaC08nGguiJ+T8Zemn8=;
        b=W14Lil8YDBJ6i9He8U5NX4fW/uc8bfyb+HNvuEazVe1opep5Ud08HKQjo3kOaEgWVu
         EIZkoB/Jke2pCvL4ST2HM18Kie00Pd2mk4Cctz5dVCPbl3ltUxcurRqDJgjiKTIdUMBk
         dfHphlIBe4hpFVpLwJiypjCUaeqChU0X7a06asMY1M/0h4X9vWXuSCSzyfoDQLcROjkr
         gfi7HToC7PIClVAsp2Jj5nvAIkYjdhlegWu0ph1bNvs72GkCvLhGxRLXPXk5HMrqJ6BP
         a2m3vBZrJmJ54dOhTXEMbCa51v3TAml/RYnxX0lGZZzFOCXxcWtIRQ2r3OKqh6Sl0uby
         /xlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755247798; x=1755852598;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/NSTMH5SPq269hvY03ywFdZHtaC08nGguiJ+T8Zemn8=;
        b=K8Z0Z+dbRAkitvMwitR9d4XxjnrEOUSbaNedQahWGcouC7G2+nwNiiqMJzt75WDWUN
         ePktRBoMfV2chl5AItTtR1J1nbgFqWuPOJkpl/WWaqqFdJijKkfvcj8HLSKAA8Yyfpol
         LA/k/ZiE1X5VTYTxptvUjuAGwyN7pe78EmRDVfCm+sOhAtKgN5Uy0s9I1kbJx4UADk5z
         /LcF6qLesA3p+aeZ2kgG/dz2bDHjqWuWcDrJFdMfojxKppfr5HGV4O66l95IDG58ct65
         wTGpFy9GZVKaJgaZ81DIA1ImvXmY/KHx1W7+myDHnqjw7ysC1wB0EMtrSKk9rpEvF7Bt
         DHQA==
X-Gm-Message-State: AOJu0YzV0ruSgY3wYCRXnLXAvGRv/s1W33eZXyxaDxDQZNeNt4afI4o6
	O8p8nl0xs6Xk7kNxqJOXTPlvnjQyBna9d5h3znp+7kLHbK2c0lMeiOg4
X-Gm-Gg: ASbGnctAvmXsTNTT+B+ynoCeUKbohJL04MDFlhvGqF2ErA51lpHRYg0e7ThQMqmnISa
	ocJymCxt+DPwCtqVWI0XQUzYc59VfU7P6WlNO26dylrHg4Rxss0ETpdTvX0Dw6VYbGbqGTrrKpI
	1vHSE3yxmc/r0Vn6d1V+wQdxxTsTLm4eSHKyA9v7Ei6b+FkNG0+AkCu0oGJKbSDk4863ZeaUdLP
	5361iHb94fAF+BgjJY91UIlExgW8koHJtPn+DwRBHEA+yvX0VQlw3X3EIhOopE+6h9sLvMEkIkF
	S6ROJBHtUgq0gTVQEhFubgGV8SrVMO12WUzBh4JNTvQbD1jT9Ip0Jd1H2g2TQ36KlwFFpGzB1Ye
	oapodL50xFzaXps3Ko9HWdg==
X-Google-Smtp-Source: AGHT+IHwIp3dosIh8+LFXcp/L7xG0nB/PSDrjw5Oj7ANW17dzJQPL8VY/Wr5uRkc1IG/wcDjGqt3fQ==
X-Received: by 2002:a17:906:c141:b0:af9:a2a9:b5f8 with SMTP id a640c23a62f3a-afcdc250b59mr111797866b.18.1755247797495;
        Fri, 15 Aug 2025 01:49:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce78d2esm95036266b.52.2025.08.15.01.49.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Aug 2025 01:49:57 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 2/3] mm/rmap: could be partially_mapped only after no entire map
Date: Fri, 15 Aug 2025 08:49:42 +0000
Message-Id: <20250815084943.23063-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250815084943.23063-1-richard.weiyang@gmail.com>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41CFF20006
X-Stat-Signature: z43nkxjzpfyqjxcqzx3489moanj31bng
X-Rspam-User: 
X-HE-Tag: 1755247798-372745
X-HE-Meta: U2FsdGVkX1/sotesJR72wtUjql/s5M0zN5En/oV9RV4znBfqWT25AFz8f6ZKoYdVUonnibQplxJxZxpmTQD7W3dzfugRHfBWSbHK4QsU4L+bfvf84CvNSPA0HorEQly2CznEvLekimL+RD6H0qdn5LWp20TkH6m1QZ/c83zrGP7TquBm8NV21hKEWGqw3r7ZOl5ysAhODNZDo5XyY348neZ13i1gXjlkbeiephQy1/VXXaSfdny78v0DEyK2MN84geByVgl99imKlIZ/ST5ngq30Q5gqcmDQtv+lPFW3c30NtXcU2NBECvrF0KmOdX7SDTVNxzdZOXRYACMEmamg2cl9ljhRt0k699Lqmdb+fw8yyp09piV8uW7jx4G4tZ30LgcOIHTyVLQz5/mSs7ajxObQj/W7rZ/2g+qio2/35nD+cxmxP+E2qOEFjAgAuIoJH/pyM8jQQA0u1VEUGv0JRtuNKw5DmFPG8HRlzm4routysmxjnVVQhyTk/gpLiXncvkyTG5PCb907eFjitgo8QZMbmYAYpZc9nPplLNcX5qlOW+kaezS8pU9tujTf6n+SqJzMdxgre8RmMX8N+Pp58Vvf6pJYIQxjQ+bHu/fVd8ywVfJ9MqpeopaLlBFbbWx7H/mnX4K8SOB3zlDXwEZfAX9CPianhbG9lWupA9/LsLr689YWq8QObVEvT6XspcR7FKhLNkLgH7lv8TYh2VcJG+XsD/TBgiHMU6NGbAzbGuZRq6fykjcD0J9moMYnRck2Zkazh/WJ7E2paMCx5jq6sb5R+FFSpI9cU+kVwbVne/71HogdDEhrhCrImOe0zrMoBn+MrBheJO8opBLY8eb2AqjJZPtnKFD9+m59Xf27CGMm8s2lJHYbueYYl336lywDIdz7xxZlmk9L7OaLk6KsmcUc25R6CEpIrLq/RllboOqNNjXGdSosqLd6LQYsbScD9uVva09EUlJY0RwCFDV
 mAypZZ8J
 ojo3UBu4pyClgNwkIyuFvQZ7nYh+XUaf9JETcviszFy0IjNN9GYln0YDdp1QJAY6rmwFHUX+YsB421PhSXvxQ6sEVLBbyY4iXJrBQMMleZKamHz5muQBHrvtkJ0ikabaRVGe11WGmDAI/+m6gE4/gukcj+lVt7Nk7yE/iAGYeF8aT6MKbHvXZqmo9RG6GCl3n4aL3dT06L8mzqxqzo63MuuDklTIkbuQKL+O+hsHRJdf8ZGh6E4vIJvRoVDAR7bCw4uqhZ43eUL+UydVhtTHq8N+qrbXsKf11Dm3yMh1XLk2/pl1ezmFi1kpqWKXfZ4NpyEM+MhdpcE8hmADHchqqjVV2sz+OccQOEU+cUdw/6mSGBIWAoRwEnU4a8jGYac/CpOApVLWm9dOuPCs2qAwmnZiqburI/PKnIlO+HtXcTTqWl3cpZ2K4co4XAvWQ66RvXqLZSyo/yqzMtzfhz37Y3wJ2uaJl/7Zj/jGwhuenXZ2ep4SGDs9RDwdymREyo6iMV0lnKtM5OextcK2grRB7nOv5FajQ9ib61r7LPrD5yec5tW0AE2qv1UsLEgsxMdKgOh6RCHg3mxMRq+IO6e/YzLL2YgHmbaOw6zJnGIEany49qfijnp06XXcoxuuOSQtY34E2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If it is not the last entire map, we are sure the folio is not partially
mapped.

Move the check when there is no entire map.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
---
 mm/rmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a927437a56c2..645d924bfc7d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1757,9 +1757,9 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 				/* An add of ENTIRELY_MAPPED raced ahead */
 				nr = 0;
 			}
-		}
 
-		partially_mapped = nr && nr < nr_pmdmapped;
+			partially_mapped = nr && nr < nr_pmdmapped;
+		}
 		break;
 	default:
 		BUILD_BUG();
-- 
2.34.1


