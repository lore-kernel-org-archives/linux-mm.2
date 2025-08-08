Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38ECC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324FA6B009F; Fri,  8 Aug 2025 10:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE776B00A0; Fri,  8 Aug 2025 10:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D8C6B00A1; Fri,  8 Aug 2025 10:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 056C36B009F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:26:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D9271602CD
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:26:53 +0000 (UTC)
X-FDA: 83753816706.05.B2A2EBC
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 94C3F4000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:26:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=frkdJgC3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754663211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WDyJ4waytAxtZpeOUkPDIPxeUnmaidLETwAZBBpWqI=;
	b=fWn34wx21H3G3/psHNUj9wkHXMAH6f4igulZ41J9Dpb3w+b9Zz/wM6q8RRZFGQZa04bnFh
	ASvX+9DfRFdBKUbY/WpKSSsAtKqK8NF0Lsjd2wcJ00GI2oyd5OxOWrXWhwuRpV6nGyqGYh
	wMA0sfDiGwFFy8FeR8a2ZhniG6gCvwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754663211; a=rsa-sha256;
	cv=none;
	b=jadJ49xQmVccQggT8lek6oHM7vYEMf2OVNjnQCRfmLLdJveSfjl5YA90/gvQvbx2gBc+FI
	MNy397N7riOQ837duhMeVmu8WU4LIPqsX9HjyiFJ+CtOfMKHLDPE+GCVlVnZWSztk/BDhz
	Oi1Zksf/EfFUH29jZAi0844U8icGu84=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=frkdJgC3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71b6703ba32so21646387b3.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 07:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754663210; x=1755268010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5WDyJ4waytAxtZpeOUkPDIPxeUnmaidLETwAZBBpWqI=;
        b=frkdJgC3dDcm+CmBJzAEmPsFAN0pi7byVvjxkEV7qeHxgcOpMr4K/3yuACXNkUlF5r
         CeLXd/bHZwYo/KsGivN169Os59FWe0lZbA6qQkDGaPWAhr7/PzPUEac2YSHBL8HZ2GgZ
         zxCm8SvB4wrs7VBdr7UXXQ1VtCS+HPQ1EfIfC03Mg6o3SW+cbvuP18kXSHq68wKrEmaO
         BxOFOaJUrJR9jLVJyGlnb7DKg+s39j69aguDBD/ShzS948vvY7X+IujbYNklfwkm86fu
         P60jnTMD01uKrtppRyqny7kJvPARp48p7zFIVvdzv0mZADfxWic1p2cxfQJVi+vdLeBA
         dykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754663210; x=1755268010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5WDyJ4waytAxtZpeOUkPDIPxeUnmaidLETwAZBBpWqI=;
        b=PvdnOfKz2VO0nEJROUgfzXZK+Ind0iiiXKmh3nn+GgvEFHHRPtGdz0qWw8Qvd57Erk
         LvtNMOILJ/EZck1/OAmvLGtwJ4R4mO75C6ukUcFUfhvG1iDVwXw5swcZmGxz9s3Xh9u8
         KOl1ytGl5VfFACpzjVsvIYkkhMVaWKvNKbiBg/rqjO+es5o0tAp6Ctp8zV4TpawZlWSe
         3htPTJuMck9pggBHufa2UYlvP1x7hwK4KmFBqKXhpkTiT5JZSyeqHeDoY4Cj0/YzpGln
         XA9E5ZPVZRM6B/poQUdZlsfMIyZaKRUiO/nS84PkhgBk38pnl7+4GYnQcG9AkpY3/kkE
         eFGg==
X-Forwarded-Encrypted: i=1; AJvYcCU/SeKOjwEZDNKXoY2yfEOqf3GIhMVB0duY40L6BYE7Q9JmyNsMn1zV9vsklThLwXgZqhghtGe1rg==@kvack.org
X-Gm-Message-State: AOJu0YyZ2Vmt9rSXRlz0T+Mvtw1spYhFLmLDG152XfjoQUt6/S97JHC2
	XrjHONJBJqtyrVVPlmnhO9HfZOoX8QAkceO9Q+KAatOLcO7/WaucccGt
X-Gm-Gg: ASbGncuoWPmEgG2/DkEWxRViQGweTkaxSIIu7STEEvDCj6eV5sfMudN4CxBU/QeEa8K
	gdtOA7ulxQ+dbOoYumLcwabkfxK8QSzlFY936rnHuTcZJFEp0q9g4ee7yEpyw5bvcI9rQdbjv0I
	NuLKtmXT9/e6wfFXTKpGhfyUi3+Ek1RlsEe5ME73qQwpXLl+2gCQrZ23LX4T0lZ4sMEnQ6Zjvr/
	Sb1fi7T4UMy9VnckoWZv3Q4qrsyN38fL/CAIobFhCkxtMFhZy/KZ/ksHCkP9et8xuGdibW0b3K5
	Y61Zk9qRlWLaC7aZVKoE9MKIf2B8fLWWm9vNblaGfOb6m+O9Eujmh/W+z/M82Vf9WZJCYLZonFe
	QlYKED1XI2jwiDHR/Z59q3g==
X-Google-Smtp-Source: AGHT+IFqxRV9qk9+Bgt1zIqDMjDP3x3ye9NX+PiP0o9Tsc9GXQ5uZfQ45/JcvIFJMh/gkpSCcv9iew==
X-Received: by 2002:a05:690c:6213:b0:71b:7043:21af with SMTP id 00721157ae682-71bf0f9a20emr39182247b3.42.1754663210429;
        Fri, 08 Aug 2025 07:26:50 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5988f0sm52671287b3.52.2025.08.08.07.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 07:26:50 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: pratyush.brahma@oss.qualcomm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)
Date: Fri,  8 Aug 2025 07:26:47 -0700
Message-ID: <20250808142648.254205-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcomm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: miorbu56yuagfdkpyomnji4aq8k94148
X-Rspamd-Queue-Id: 94C3F4000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754663211-745128
X-HE-Meta: U2FsdGVkX1+dE71EPbQgQx1CxsqpjDr6v5yLj5X7/OQKdMH6PRXxEZnI13rAZFYspvj/svQu8uLAuCuJ2NU8Lfas1r6LqHj2dq0BOvvLdfKtCePDEWVG59og8NHs69cfuB2kIWFMra+1QKFTxKkc7NOzWeqqVqdmxhbtpKUoytHzcU/mXB/cg0S++hHzUiYXFf05NMmuqt+C7zQ9Cp9zMiqY9CTsw7OXhyJSVodUFcYyVshYBccHsCmfvgs+2eJReLRWvJS0BI+qD2tJJmWDjvWYiWQzwj70CQtUoA6QtKZb9otheyD1eUm1QmzgCrMAmnXjxtU+b++6AWqdPCW6yE+jX1edV4nTFmiih5ovtkwgOe0OY9CbJI+d5Hpa3tS3tyrZouo8FnQ20kmVhArI+Er8WakzsU58IaF2r9nT/5tfpH0gPkXXsPhdujWkM3zMXnFbPCXR+T9MqerkvjJgmmec1zD0XxStfouIAkcGLsOMqj6yDr/BeVaJCS1Of6SkW/e9HHtba9L5GC27TMLvq2I2wSuzYlpaqF8bg9JyaCk3csuj8pQMvljId+/JbI4qdsmOZYVV1NpXwc7X45pZvSLjQ+imj0SZF/nIXCSFKRIy9PoJATMsS+/DOWMe2wpV3BBSfxfZJsJ+7lx+nj+2Hpt3JstUL9+9PK6GQLDnW5vRkcz8Pz6x/aPd3HBECQcyYxBoqBEgm3M3/2/z4VE9N3f/9jgpy5F0lSYU7E36QPzCkBmA6i2VXink9ljvZSxlxJ/TcZ4+1BeyUAg2k9yNvjYvKe5k12ROc7V86CanhJCo9jzKkWIbEWPi3Kl4ECgoZrfoRFaKhlHyQWu7joZQ/hM8hpaaHpwRtDnMnHkj1+Z972kD1v5GW4W/glYgpZlX714BWyDwBDHqwcC8s42v3M2J1O/A/l6ZZLNGLA5NsAGP5IUnwPT6TvKDbFjXdUbQ80GL2fydrK7mkHa0Vsi
 tgzSRaAD
 S8s5F2HATNldleo7YTKYZckwON2beXT4477C0umr7I/db6MPpZ3cpl/k47+Ai4gcmuSP9XI9kL9qXqPggMoTNO11d0LiUGy2irrb8goN1zxTGa5dhjjUKeLWzv40MQ3RcdV046DjuQ8R55XLoeIjCxMSLDgun8avhab6m1hlbXWcn2Ktc8qZyezHIcNb+MMmb4Ed5BJxMW46u73iCzX0JI+xgYAnTYX14m0nlGrnrR1CdbCwdeaPk4Scg6+CKvA6ASogsjJFsoxXcMbm1orz6CRMr3nUxOl/LEXNkdPjFbTNWrtk7Mw7N/Lh/k2WJnP7WAEcYj1yYDf8EG6G8v4qPcaKfzN6iaUJIo9KrRD8S8TnsRulPCqUq3F36QQj5iRB4P9tmWRp5C0irZ96+X8XMX6Of4az1oiXVVU/c1xiEL9yhtJ/jfgg2HxB5o44h6eLCezZkGUXSXJCpqZEYLrTaYSnJ/Ee5m02ldp/9aNDDrFvV71eXzzmu+g98Er+eSgJJyOF3iotxWM8Lnk7zepB3gg8BxtMgV/sIZi6/4Ff8rHNUTJbgDmGitxceWi4FAHTODUbjeuSADv8MtGdHQl/wDyHvcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 08 Aug 2025 17:42:22 +0530 pratyush.brahma@oss.qualcomm.com wrote:

> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

Hi Pratyush,

Thank you for this patch!

> Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) to
> align with the consistent `pr_*` API usage within the file.

This change makes sense to me. Also, I think this patch gets rid of the last
caller of printk. Should we also remove the #include <linux/printk.h>?

With that change, please feel free to add my review tag. Have a great day!
Joshua

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> ---
>  mm/numa_memblks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 541a99c4071a67e5b0ef66f4136dee268a880003..de626525a87c3ed54d31695e86f18c980c084558 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -76,7 +76,7 @@ static int __init numa_alloc_distance(void)
>  		for (j = 0; j < cnt; j++)
>  			numa_distance[i * cnt + j] = i == j ?
>  				LOCAL_DISTANCE : REMOTE_DISTANCE;
> -	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
> +	pr_debug("NUMA: Initialized distance table, cnt=%d\n", cnt);
>  
>  	return 0;
>  }
> 
> ---
> base-commit: 479058002c32b77acac43e883b92174e22c4be2d
> change-id: 20250808-numa-dbg-62a8b2092c56
> 
> Best regards,
> -- 
> Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

Sent using hkml (https://github.com/sjp38/hackermail)

