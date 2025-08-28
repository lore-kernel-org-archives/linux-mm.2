Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B2BCA0FF9
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790CF6B0026; Thu, 28 Aug 2025 04:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741046B00A3; Thu, 28 Aug 2025 04:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6300C6B00A4; Thu, 28 Aug 2025 04:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50FA56B0026
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:10:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03766BC969
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:10:30 +0000 (UTC)
X-FDA: 83825444262.18.1C0CFBA
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 07574140008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:10:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="nIM/xCq1";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756368629;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsYlmHfU3hwTMO0ZELDyq62SrO+5nMwqV4kPXeXXGBI=;
	b=e3ZP4FR+CY2MOb+BRKQW6dAd8A3LJNk/cVVJY1brNhTrzcvm9OiY9pks6B15DX9m/VmJIC
	8xCtxk797e9F6CGNPifWVACzrhDvlnzC6pQUWLjQpJ6ApaHXHpmV50CQDPVcOQVTaznDC6
	gf4U9U+h+Z/3XFO3/dRI7klWKn95iaM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="nIM/xCq1";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756368629; a=rsa-sha256;
	cv=none;
	b=T0rObaUF8Xbqd1JnlOZupsaDPkbB1mU64+uEduPkOdsF6Qv1s1v9tY6euoYfSdsmKiQp4h
	J5XqTW4MJMccjSg76LBj9aP7Lqmwpcd8TBQ4wpV2dcouGo3vlZQ8J1Gogmix5sJ6UWoh96
	79Yi/RQdbWYcf8IZWGF89nY2N6tWmH4=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61cdab7eee8so498147a12.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756368627; x=1756973427; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WsYlmHfU3hwTMO0ZELDyq62SrO+5nMwqV4kPXeXXGBI=;
        b=nIM/xCq1cVKcwi5uR2RZWDVjlxl2N6yw6WRLVSIR41X0oB0FaD6h3f3xnKt8KGQ5bZ
         P2EDRTmd4QJsbEzEt04CBluYfI2ND1R8lQvLMBZmlF3qd7czjNa+3pIjxpcODbCBqyKu
         o+aqU005QpyuUZt4riUH2ZnLN31hXsJKCNl3UyrWm50RTwaDdUPy4vyjyZ1mzVV5FYYQ
         kvIR9I18zTZTM8TweHW6M6iWYfNB+uQRLdTa32pCn6ARBUo9gCZ2Lf4oFntwFjzH/B6a
         wwCLPIMfui7mFr6TlFm0ElDr8WHhYGmRRCY7YAK4+rWqgrXafOzPEomuWGAoVsRkpyD4
         Uivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756368627; x=1756973427;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WsYlmHfU3hwTMO0ZELDyq62SrO+5nMwqV4kPXeXXGBI=;
        b=cHcZLF1lH+boQZeHSyZr7hRy42HRlOSV2wE0FNS3ZUtuSTvqvv9Acs+JinbAV76JwS
         o8Fg/QTDCzd/vt9rvU8rmOGf3kuDcOU/2XBvLC2WbY3rV3G6IDPb/1gKBY5yfQL1cu7H
         D8gQV7HP6USSGKccrtJLOWx7RpFMTUXVL39NW2Hd2bpZzb/B2+kJHxq7pyg7Fm5b1/Lm
         wwrpaj2w/eTnjgClrMD48fw1B7PhK5i35X811oVJzA9UHGoWxUAjojc/cwo+9E2JnLet
         qlaULd2TbYyjvaPosfSUS4t+7lnJgNHssnv3FhmmFS7whVKoxbUAtrWUeY25lWNtZr6x
         vM8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlCERJjPQzUjUj1ttJpzNWSO6y0m47o88cfbTYezwSOTNp/0TG5BRwzggAk8jsAI0TC3GElRm8mw==@kvack.org
X-Gm-Message-State: AOJu0Yyb6N4zGzLi+ZmrMCetMXtHPXVhzOURLCcrz3nDJm6Enb5evxR9
	HlkHZEA0yjDilFU68IppQ3MPt6dPb5YqXH50Q71NV/k2CIklIhbjlj6s
X-Gm-Gg: ASbGncvabXtjFAT1YqTP/LgPEpBxA/kwiptgzrIx9BCxigus+enNHLaygNSaQke2pJF
	2wLM4icRgTHFSbvW8IKoeYmyb/N7X2adFcEy9FEAMDuSAl5JS29smHwAp1AqomnnEEHO3w5ktG4
	LC2CuETPSecKcxrpOe+FpGYwKkqigiaQflDxYiCkocyUqhEfTzYKDnAR+nB4sILbQrT0NGcy8bl
	KV3lUu/MFoUCgqQcaB3L5z1FRHi+1Ls93f9h/9bt23cL4+M1fTt0nVDkzsFXni0bU+dPloVZJ+q
	8gvkEdLyWeitBnNJ0N8Y3HDqP9XJUUFEyvpqnEuhv1I0AxhvRQZDRH/67CxZYkevKZ6aDY1F8Lf
	RM1n1Dcw+GVgxGaz2d106W5Rmrx7hEu3XfkvkgzPpT52z4+U=
X-Google-Smtp-Source: AGHT+IGIthkWv6z5MdlsIhO9u//UvPeOJujLKVBOFVuuS4souaYefx3hzHkd5Tzm4EztK/4S7+XRVg==
X-Received: by 2002:a05:6402:270f:b0:61c:6968:d1a5 with SMTP id 4fb4d7f45d1cf-61c6968e6b3mr10645149a12.25.1756368627342;
        Thu, 28 Aug 2025 01:10:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c533e96dfsm9090558a12.18.2025.08.28.01.10.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 01:10:26 -0700 (PDT)
Date: Thu, 28 Aug 2025 08:10:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, mic@digikod.net,
	gnoack@google.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, ming.lei@redhat.com, skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] selftests: Replace relative includes with
 non-relative for kselftest.h and kselftest_harness.h
Message-ID: <20250828081026.yx6vgphtsf4pmr3y@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
 <20250827144733.82277-3-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827144733.82277-3-reddybalavignesh9979@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07574140008
X-Stat-Signature: nc167nsjmyxfd59s34quf99j5ext7doe
X-Rspam-User: 
X-HE-Tag: 1756368628-464855
X-HE-Meta: U2FsdGVkX18Qg/BkTJoVMUItePE8iX/pjQJaoozLVAVkfi3taY2Wj8e/QB5CMqk2kSuduZG1TO0HxdQc1QIzz51xC0aosqyJd4uK101leW5r1zC5ezFGqtFImuoqIdDljTE2vbOHDNtQDsNdMh+RKNG5jWPA7rpeSaypEkJgkezHeMFQmaby3mAV085Mw4aXGX4vVEoRvbiV9nxUorzF+xbeMupKNi+RISuvF69wX99em+phpoewAJJr+KzPwdcDcuzOc8b4hSU5Lqx6i59l3/oKqzZD0nu27dI+yJFOP8Fp4/v3ePTAs4hhE9VmPyfCgC5Yd8GBclf6vDfnaV3PK3FeDeRm8Hs0RXIiY7+m7dweSfvjuxK0f5cujOsachYAx59rfrCFZhKxVxAfR7b7Qm8ZWyWZQ7lHXbn7xeVi/Wec5i2e9Zwq39DNQtqngsIksy3+l0IUntCJyKmrSXgZ5AYrJ5YS7XwH4xJKp63sQY7Wa53GIhsucmuTSRsbzrS0OKHiYx2K3xglc0l/HCs0UkRHYxDEVDEN8L2rI2qkzHkqJXNym3msQtSWQZI1A0jSFR0KJbZiCNW7hlXfZ+pHs5hCPNq6BgugKfUVeYuaDeUoFKD5mWI3fQw6YozorwOckePvHwukzYrtNUw/RiJeYtbR+4VXg6S+AXs0XantZbUMaAHEQL3RhQzE3b+U2e84oakaAiI3N/3TsnJTDnuzeCjQz4sxHda5uY9a0339vH7ykxfIgkNfQ6oYOfrNHe2hWEPzFsfWWXf5Ybq/Po82zEvaW1iqwcslf3sG3GTCB5e3U1FcVmFD8ukm/JYkx685WRqCcoYtVOAY19P1QETQsfhb+pChZizad5aioOWq7BNU0wvDD/J2M5SbimdF7sSCfsW6PzcPhAUh+eBZAK2lI78GSBM83E1ot99oKXucyGddb5Y4HkldzTMd0kZ6ehzQhRhEVlFTLKG6gR539/6
 H1I8usy4
 VRYrxo6FXuHNgZ+MwhHwt4cz5YgTdb3qzc8JukJUJEMV5NWa7ED60YnpWLj3Eo0k3t9cXEnDoSATvyrC0Ndj2rr5120+mZVVVEZR7qI/YN9nyRg/4dRixMHK378Y/98v5G3KkDIT6QyzvDcIy8diJSfvQS66jrqrYE57/v1Jloz7kpNw5+nmVKtzch04Hok7Ft3YV+2wMMI+n2BXtL7TdmRjmdgHzyeNH1hvLKnDgbbn7YPZdOpVCRao89blZgRylisMFS+cATbaE2EVYlmIJR3tInXA6ukfQ/AzztN/ROOyiiNAQqqHCwZRTgg1LmWLx3KTCvzkXOTkHWcQLL8wH7dSPq26YVVV5j1hH106hdi3nM92E/pEkWAKKloKt8z6XB2maBQStOxRts2OH4TANFUC6mrvej6VSZMc9ezrquMlrgKaElk4VRy0AOkQ0yuaqxRRac9+xDr1ViIJ8nUxmpd2bZi5NsI3wo3aLugckZT+g+aizwlAXgm8mq46jafQzBagHKsN/TwcGmzEoQDkzZSRHB2xJ+/xE59qo3Q2+7FPR4a1kdIwkt82F+tVkwsRMep3FYhL8PlrEj2YH2Rx+M4PrnxJD2hOmZzb1CkDgobKsW7IqCTrbYR+PP6w0pog5VRsndONRSCUwe8mgc5+pQ2dQ/Tu8lUmizCMMhweagb6xniFuNqFKlR0q46gsiBidcT+xhVfe9EnbuBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 08:17:33PM +0530, Bala-Vignesh-Reddy wrote:
>Replaced relative path of kselftest.h and kselftest_harness.h
>to a non-relative path
>
>Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
>
[...]
>diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
>index d30625c18259..ccbb1958d467 100644
>--- a/tools/testing/selftests/mm/cow.c
>+++ b/tools/testing/selftests/mm/cow.c
>@@ -27,7 +27,7 @@
> #endif /* LOCAL_CONFIG_HAVE_LIBURING */
> 
> #include "../../../../mm/gup_test.h"
>-#include "../kselftest.h"
>+#include "kselftest.h"
> #include "vm_util.h"
> #include "thp_settings.h"
> 

Well there are too many changes and I failed to apply this one on current
mm-new. So I just manually change this with patch 1 applied.

This fails when I "cd tools/testing/selftests/mm/" and then make.

The Makefile in selftests/mm doesn't include ../Makefile so ../lib.mk doesn't
know the new CFLAGS when I do build in selftests/mm directory.

-- 
Wei Yang
Help you, Help me

