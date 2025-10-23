Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6248FCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB848E0015; Wed, 22 Oct 2025 21:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA34B8E0003; Wed, 22 Oct 2025 21:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8CA8E0015; Wed, 22 Oct 2025 21:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4EE8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:32:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 435F448F5F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:32:54 +0000 (UTC)
X-FDA: 84027655068.04.1682B35
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 61E1C20008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:32:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SKPxaRi4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761183172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j86jwHtPD86pmpaBp5nseJBGX8AehGcyI4u33V1+rbQ=;
	b=HmwM0LNHKPUD5g151D4jIk6uTCTa5Z66cVku08jnHmTVM2S9KlJTujDPS8HyFo9j3sbe7s
	YAKNn+aILbhSaxbYrDPAC9kCPurJ7/EULWiK3Gitl3rZaatPE+FVbAB0VQjPq05+KBIF/X
	9wbNOm+SVWJF3gBaYvGA1+mEnEOyT/g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761183172; a=rsa-sha256;
	cv=none;
	b=lsjL9aCHBxqHPQ0NUF9Kh0EtIG8370TlQOat777YpYkQrh6jU99MhSL1HtJw7VnnraBSFT
	AGIyAdvc8A0B/5l8Pv+ZkQ5HXrCtjwwdUwQ7qVxszjHv09UcYmLYex4T9wFbpRkYTsMnF5
	H/CKBPgYSDJGdopvFRYdTtxp2o2eIxs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SKPxaRi4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-782e93932ffso241889b3a.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761183171; x=1761787971; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j86jwHtPD86pmpaBp5nseJBGX8AehGcyI4u33V1+rbQ=;
        b=SKPxaRi43RizFUA1wkXZNgepfOhEn6p/rW+Wp2dWZ5tpRi7aEwYEcYd3HRIXJK1Xqv
         OB0w5lqDuO2rDih54IAgR6zQZanCBwpHIDM8Xv5XgHhBQw8pkNR5eVcbuNrNMOEvrxQB
         TrGQcWG/esoTL0C10rmb2+bByQOPyl87CoBpDiip8uMuuwaFH4YZRdsXqN/clRTvpbBL
         246D9S6o657d32fjDa3FUuVTWSMZCW1y+Vj6UMoHiAR0+4csZEMwrPIrYT8Ge5eMu0+T
         lww1vfsL7oG7ELJNSP28tFwFqzhMIpcfGYLboEbN6PeLRiiKrWdRc75iOmD7XE/9zWZi
         2oOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761183171; x=1761787971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j86jwHtPD86pmpaBp5nseJBGX8AehGcyI4u33V1+rbQ=;
        b=a+XkoO3Y/S2KGu9B3e211H6rz/x9HK8Up+yAbnSa38spz12O0v8O5gHRMlTXIgnKjH
         Sm35YNLBitjuP1ayAiKyyRXyQUEQ/6KyD8ArlWvFIqYTwJCgv3IhIvR2LMnVrAbWwdmy
         JGCCmrEgn2bVyh1Fv5/3FdwQ2zg59xyrK7S/vsyNWsAiV24lEP3mAYc772kRm4McVTJq
         wbDeu0o+2dKP/VX7LwqPmPnlFVoMJOef03NjfmZzZry4LJrR3NZQQBF5JH+wl077OICG
         7x1Qyq6EoZWghwmvsnC7yXy4IT6vQasX8rnT9b0COUsOrw34yXvLgLAQOllBNoaWYrNp
         2zpg==
X-Forwarded-Encrypted: i=1; AJvYcCVN15Aa8N4OJe8doUGfmdYb8TtNCbJobIrbgCGyHNUUrQfeysyFXU3a5x7hP59is/4z6yRcb45DVw==@kvack.org
X-Gm-Message-State: AOJu0Yzuevu/D69UulktBhPl4/mOfScTS+1rpnEI67Mjkcko2pbpZog+
	5IdHCI5bFqrw3XVCx5Bmb4IzUloVl+St49krKX7opt4BOsznB9P+ENc5
X-Gm-Gg: ASbGncsikUclSvj4YB0kRdu8LXOUXph/6eI/O8zwtRyN4kzJMirM6i3rQf3eK5cfm1m
	v0YxwyqIbMQjKJFr2gNsckFE4cKN5I+/uUwjR2qq2TCxnkhS4kPECLgFixXDXwBjDTzGV8qjtQR
	bYjbLihtJ81a8aDJ99A3ulk/RPFhIdaSkKLsOeuzMle9o2KpUF5exGDjyy6mzvQufA5Ee9yEMXe
	eo9js34OR5ArWkqUf0dNa1c5RHQctIozTs2YonDerpYNyeT1AGhH69Oq1xh1SCC8EuApvrbCT2n
	huxnBHUP15hAmCxGGXk/+vn0uQBQjleG9a2K9KlQ340hiPKNRNWNbBHe+GRuja7xJU4lk3qIZyM
	9suI9JLyV7cSRujogJkiPIn9wLvGFg1viGTRruUJnbDiJ9fjoBR5iOLbPzOhZIIdRzulSex0FoA
	1DoQdJIwb+tViWczO/avMvKynwnfKbbVMcABhqHDw=
X-Google-Smtp-Source: AGHT+IFtkuqL3vdT+8fOnBnbZS7nzMrmBPoZYj9xImrZortW980zhCGEK9IviI3syufSwNYAtSokCA==
X-Received: by 2002:a17:903:2c10:b0:278:daab:7940 with SMTP id d9443c01a7336-290c9d31115mr259693205ad.17.1761183171264;
        Wed, 22 Oct 2025 18:32:51 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:1af1:e76d:71f3:4e0f:3054:cd47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946de1739bsm4988055ad.51.2025.10.22.18.32.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Oct 2025 18:32:50 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation during folio splitting
Date: Thu, 23 Oct 2025 09:32:36 +0800
Message-ID: <20251023013236.16142-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251021212142.25766-5-richard.weiyang@gmail.com>
References: <20251021212142.25766-5-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: zf7kt9choyf5um14d4yhw98sffcz3qmj
X-Rspam-User: 
X-Rspamd-Queue-Id: 61E1C20008
X-HE-Tag: 1761183172-995065
X-HE-Meta: U2FsdGVkX18Z00ApUjSyAawqyQSAFH1DndFnldIrkmOwzHu/20sDxixyCduE5YGtKAe3sH3quX0yUWMZLqCnsSz7p8tQZjD/ch0cPeDrn0ugSX+biL8c4ov2fcUYA7lfkbSlBfoZhMYb4HW+LWzcO6wot9aI47fmSYz9hnWEwTxL18QGa90Z04bKO4KkZ3PEGkLlVh8Uq8yF08uO8LqWxHC+8lswVSEREQ992wvnsuBxL4ngqFPV1CINVCOvG89VMZ9BDxn6LWPjLBQV3DUtULVlSmsIvs3m1eHmT1kVPfgQTVtgEvebU3U3FZI6Sxw5SDTOh5eOadAhzCcbRNP8YOqrnerpk3n+3OdajeXOmKQqyASUFkCy6KLfJ+OW6hPw+TozH9jo41ZNCTsJrD5oKfmd1f4MHZBuexxowbYtyehysxMt9BYsSAD4mvnefun94wgNxiMlJK1usXDeJvfzHiIDc63QvILI0k073XB9QLZRWCgJv+tabfJcTGc8PYFot3oZSHGYja5axPQqmptnKLb0XPdDlQRsgQOsIaBFxnGvY7Xr/bxWSoJvYLIugFrz2y/vBzbpBOkD4O9HjX5OFSjmaQurpA4leKiVB1mkw7r19G5/kI0fTpjwiUR6FsZYDuMuTX4fWA9eNFvKN4iYvQyaZGBoosX3D4IRDJulZf5EN10GNg6hrg8puveg1UvPYDPD5B11ZTxDzV0ZtHt/dIdZUSBI+wsqnFeTNkybIvfsODE+d4uKxCKJCTOY9Dc6vcvYEsMgGNBlYoJjnnTa0AVIT0wJ9UaGrBm+7i+6BNGOrEhMX5IhI/cX/4gONYmSLGW6iiO+cD5s18/BziEGBV1o8BVZIxdKFcLSemJTXQszcSmCAkhkOf2IVbNZdziDF4/Xga5upxXUhZ+md7vCEV3vn4PWgHXNcxdL5G43vyj0vuND/8vn7rLt731s4ZHiS22TYINN2wZ6prRafk1
 3WtNgMaD
 elfog32KRwK3pT6yfWXDuvtkL33ojfa1NhtHHuBZKGF4qozQZmAiyY+5CAVBgzR9QbP2jRRK6x8uWld+U2lf/+b9+MLsywhAGcsualp6B5S8CInkbYg5XkCxDFGwh2V/e9Pc0i7+vC0SGDzr+2iUWGoURuOYeIjQf/fyuv5q4TakNZusNuQgCsoLGF5mcFml6EWLffIcNCKj/8l9AwmZKryfFzfb0bgwD/WnSbylTPT1y23wLpHm7+LKSRuYGzc1mFYig5YPlbBhXkDInYL9NdaVo/fA7wLar8/5LQ1qgAZfrvVpOMEID2/R3Zm4MZ8DNuIg1N4tr8mAoi6RAvDfDGB+C0y36WsGYbGSnxm7q/lHcddtGqKp32Ma8pZ5XVon2b00/CROvk5kiqkvtqesveYiAKxnHak9aGJ++J9zyqVDIUpq1r0BasR0U9EmjWziJ8PpXWut4VriQBFILXgyBmWtbX0QoR4PwukPA57ANjCIkzUPL/mc3pcvtt71K8wllOmkn/Yl6T4sRlxU/SCA2z1EBxpboa8Gy1QUENHqtemvOi7uNflRBvykUp8uCXNf/cbBRWrUzyWuvaxALx5ddkxn89A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Folio splitting requires both the folio's original order (@old_order)
> and the new target order (@split_order).

> In the current implementation, @old_order is repeatedly retrieved using
> folio_order().

> However, for every iteration after the first, the folio being split is
> the result of the previous split, meaning its order is already known to
> be equal to the previous iteration's @split_order.

> This commit optimizes the logic:

>  * Instead of calling folio_order(), we now set @old_order directly to
>    the value of @split_order from the previous iteration.

> This change avoids unnecessary function calls and simplifies the loop
> setup.

> Also it removes a check for non-existent case, since for uniform
> splitting we only do split when @split_order == @new_order.

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
---

LGTM.

Reviewed-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

