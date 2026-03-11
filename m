Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DFAB1125826
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED936B009B; Wed, 11 Mar 2026 16:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8336B009E; Wed, 11 Mar 2026 16:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC43D6B00A6; Wed, 11 Mar 2026 16:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD73C6B009B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:22:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59EC9C1B65
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:22:41 +0000 (UTC)
X-FDA: 84534905322.08.BF6318F
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7353340014
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:22:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IuIkhskR;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773260559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDadkc9uehD2Q82HtUQ1xvN3p0rzr8EBQuFGGMiWazg=;
	b=Lp29xwa8SwjWyhSWaAXtjvLFAWuob7Qi9VhU5Ay2+FpWIb1wn8cu8YHyvbOqdhRUq9HII5
	81DX+D8iyzuscLHgMcYqseeYKv3x/FALFmDAtaxMQoSmI2mHcSmb4cEXiCIHa33IU8OphK
	Vjp3oEOjXAHPbCfyU7Z7vPxQbjUOFlk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IuIkhskR;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773260559; a=rsa-sha256;
	cv=none;
	b=2Wef61lvXjAS4ZqS/HcahPDIRtn0o7aR0f97wyF5zvM6QlhC5vc8aT9GL0Ohi4mMXvyxXH
	Io3IMTaIq9r+q/qT8yLMWuK/cYOGbmQggMtbiC5VGr+HSEX6IVRGUuL3R2ajcgU0jIJArg
	GHB6LczKokl4P8c/ebW3yrBY+RtOx6Y=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-466ec4c6852so204801b6e.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773260558; x=1773865358; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDadkc9uehD2Q82HtUQ1xvN3p0rzr8EBQuFGGMiWazg=;
        b=IuIkhskRqlXEK9+C87li+1PuT4QKo0kibtBIPh33uK0X5rg/F8R2eB89yTNFsk07ED
         9K7FbQOvYqwSWpJdQ+4wuUSsIP7fkJfqSgPvn6czwEe2XD5jXEzTNlEXWV0GU4SXABaA
         kXWqwCs2CXDGz6kFLU1pUnOqXEro9K7O9p3bKBq9rZ6eCxiePFwjpsvvjNoKVDxZxT7a
         kdIeZFlSrlB0IsaHg9c3YW2B/jwHib8avy3+HX5QA1OpCDrV+5F69BBQyCPoLFOuyCEb
         KiCrnYcgU2I/vZD2wPwdSF0jTr1ugb/JP7O9CH+UG7KEykztk2VU2VmGeQLLH2SvHOIL
         1Kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773260558; x=1773865358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lDadkc9uehD2Q82HtUQ1xvN3p0rzr8EBQuFGGMiWazg=;
        b=s1LDpKB5sWrwHj3jtbYIB1nCdXut9dvbrv3OS1n9NGSbEPmsd7jZF1WqsdI92iZcZR
         P3hFKwFscVOQRwOw/0kb1wSQ9d9LCkF1gN/E4sgbE+BNm1LnP24Pxg9xq7ex7zOrR1TZ
         0qJSX2AjegfdMqZ7tVWK8wAQgtMzbDgL5v1X7vdHhgqJlKCgMwmu1kGCdoC/RDiyd/EQ
         ZCCXV7U25k0VeuwrQIcZ9Y1El9oARguR3tEeyPv4UfyR+taGWlFnVJ5Dg0m1jKecO6lj
         hx2/POY72Z3GFtRD3Ev6oI8RMoDxiGHiDJBVEkvO04L1Z/+VMyuW6bu/nRre/iCQx67T
         vwIw==
X-Forwarded-Encrypted: i=1; AJvYcCW/aGBi9+65y+OX6xSYMGeG/1z++AgjHiNs74s3cX7qCNGpqf+eOEskTj6q2q8L8voXggvDsLH7sw==@kvack.org
X-Gm-Message-State: AOJu0YxJSHZl0fXtbgPJPUF23aebct/PL5Jg5Gr0o+DK2vv+ZxHFThp1
	7f11OneBc8plKr0pI9Drhq0Ctca+pd0JnM5+B/ctlTZQD4wixyOHeX/J
X-Gm-Gg: ATEYQzyZ6aFVW50cK0qGYFBSJbS4pDpeBNTHlPbYFlaWFs9DkqKdkaqDWjoD5xJTU83
	lB9G7iJDrUDjKX86tSZwAwUoCHXk05taLKp0z+CWNyNc2EaWtAtI/9cp53QiSjTDfvw2gg1TlkY
	nJ7TKdQNN6Jk8iU8ggoU2CvfJ8ynW2ynIkizcemRjemfnZugo0265PGgzFfpvK96HuwtQIq7Ytr
	tpKjkHtoyEskC7NhuYbzdaHRF1z4TeOiTD5igqf/Vvzx+1jWQuVmSKbWIVeq1m60RZ0x3ykGKvl
	nN+5g591YBc5NbWr4C50v6X6G8fovYI6Xp8XiGr64mHgE4FNvbrW+TO0fGk/9BPh7zQ1crs6Bxx
	n9gvhfmEUbmQjjadJbHtrWLlP1Aml3EXTX5V5+2KS86CKMMa04+6Uqb34Wf8dsE1QxdAipfQMyU
	yNc6abZ/dOXdfBbb6aPt0mSQ==
X-Received: by 2002:a05:6808:4f54:b0:45c:881c:e0c0 with SMTP id 5614622812f47-4673359c4a7mr2171831b6e.47.1773260558347;
        Wed, 11 Mar 2026 13:22:38 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e268f37sm2889525fac.6.2026.03.11.13.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 13:22:37 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 04/11] mm/zsmalloc: Introduce objcgs pointer in struct zspage
Date: Wed, 11 Mar 2026 13:22:28 -0700
Message-ID: <20260311202230.294520-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CAKEwX=Ns9zGhSSYOfVunb2dR-i-0krFP4SKQfro2FztLkbH6-g@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7353340014
X-Stat-Signature: knfwdpfjitdhepd6ix7mehzdkye5h5t8
X-Rspam-User: 
X-HE-Tag: 1773260559-632416
X-HE-Meta: U2FsdGVkX18JEqLsfgdynf5iLSYyn6k+LiEDrAI/rvmtJH5VG23FBtl7I5xmDp8/HWiQG0WgsuakQjHzDulhCBEHySadQ0BmyJ9vCI/OFAkChcpdqLNqtgU3FXoRSQAr8gaoNKHfqbPLctB4xM9yfCKvkQk00TJcaBBrA4O1yd+7jukkz7+77+t3glOyjLMQYmpf4n6onsmHIz37Ut7DwdC+26JTQlh47B3HBffNqPU3c+rnZUHht67SdElpyMsRzQxPKjcU5fYUz8pi07mVydXN10zeP3B3StjyUa/FQ9EhoiKPn/XdErCUZW/IiKPhVwR5W+SteXXaukiPH2b9muYvt1/mGSfZ9GddQ+s0r186kEZWw39I0DizIWd60eJqhiJFXG/3rQ4eIQluNGHUmX08+Quf9TyZ2IXc1IwJCM8MWnbvbsKSOFtYWcXC48Dd5Js5Y1042pzF8wYbGd49YdTcGwUOF2sHOt+2ON+Ew2CwzjxQpLF3Iozq1ZtfeaoI1yisEO+2UcOCuG3wQ0en376cLM8BH0nHp2aL8MB+X9UT+59/qMaaN2DY3zNSwda8iUsXRctfQhj8hWjpZ/PvJkcLbmVt0aronN5gMQv1mPhyq08u3iliYAzZR75IyZC2o8fi0lT/13K+MIu97Tx74VPj1kJBnKRxMOZJZ0v8FPj5GP8EWEOYNeSMVSoGM4nMhPwAe8eAipevRMfoSOzCTmz75Ox1wj0JyLdG4kKBr/OqDN/6VdekLqhU6tslzLZWHwqOwtuMnD5it+k8p0wHgET3W7/4BaHzO/uUTM3BYZjyjqAlZ0QwtGo3tW1VZvYkkzWeBQHUTwzVmJTd6z5ki/6uyDTel58tfxoFQTe3ZhjTWLveqLtX/XIhReFUetrxO6/twajuKx5Ewj/ikdNjrj4FtVet6DOr06SAiQMXUcLEGB133V/hMTRViuuobR3e+8VZEvwQ8Cd8WYsK9CU
 lAlSRjQl
 2MSZVRz74wigrlneMfXjW70552ipokx0skeJCj/PO7CFYhpRVV5XghM9DuyCXFpo9LV/FIJhFD6Mva50M1y8S0wf0nFdmKoo7KFXXnW2QPIb4wedM2AyNOH2NECq80G0aBU5b+Jpmx65J/9YiyzngVx4omZIHhlkcpsUjHryKJjYXLThZ3YT0zcsF+lcNNx3oAT5aU7/7fADzkMAZmtz7XxTX9W7bSWKIpdoTnuwE43ds4UHmj9fcEaQuave5l+BHzm1bydU/yNlt9N6L82+aWbYLqkmcbuclKQAzdAKJU87mAEII4QwDHneOtdUFv/gLGlH6UY3DMb16CulT7gZ5+dc3ZyB9nPq1u5QgnmDygE3olfmWgkOkveQxSpiUIrR9yAZciLWCletH3ESDBfABOSLOCs3FLjvQrUibhlSHUAL6RgQ6sbWB/IchGJtxW/62Q1XpQDq8df6sQU2ZeZqRs/bdDz7k2jY3OfzffGYq9a46ZZTN0/JwuqmAmNh/eEi8jSltuuIBXnCU3aqi23ciTw9+wlNxzqsDRrqTcIjgE6soRPX2mCXBhLGfN8vB4gz5HO/gUfH0XZAR01zjoYiubJaEdyfI3A3ThWkTCD3fwj/hTxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 13:17:22 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> On Wed, Mar 11, 2026 at 12:52 PM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > Introduce an array of struct obj_cgroup pointers to zspage to keep track
> > of compressed objects' memcg ownership, if the zs_pool has been made to
> > be memcg-aware at creation time.
> >
> > Move the error path for alloc_zspage to a jump label to simplify the
> > growing error handling path for a failed zpdesc allocation.
> >
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/zsmalloc.c | 34 ++++++++++++++++++++++++++--------
> >  1 file changed, 26 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 3f0f42b78314..dcf99516227c 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -39,6 +39,7 @@
> >  #include <linux/zsmalloc.h>
> >  #include <linux/fs.h>
> >  #include <linux/workqueue.h>
> > +#include <linux/memcontrol.h>
> >  #include "zpdesc.h"
> >
> >  #define ZSPAGE_MAGIC   0x58
> > @@ -273,6 +274,7 @@ struct zspage {
> >         struct zpdesc *first_zpdesc;
> >         struct list_head list; /* fullness list */
> >         struct zs_pool *pool;
> > +       struct obj_cgroup **objcgs;
> >         struct zspage_lock zsl;
> >  };
> >
> > @@ -825,6 +827,8 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
> >                 zpdesc = next;
> >         } while (zpdesc != NULL);
> >
> > +       if (pool->memcg_aware)
> > +               kfree(zspage->objcgs);
> >         cache_free_zspage(zspage);
> >
> >         class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
> > @@ -946,6 +950,16 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
> >         if (!IS_ENABLED(CONFIG_COMPACTION))
> >                 gfp &= ~__GFP_MOVABLE;
> >
> > +       if (pool->memcg_aware) {
> > +               zspage->objcgs = kcalloc(class->objs_per_zspage,
> > +                                        sizeof(struct obj_cgroup *),
> > +                                        gfp & ~__GFP_HIGHMEM);
> 
> I remembered asking this, so my apologies if I missed/forgot your
> response - but would vmalloc work here? i.e kvcalloc to fallback to
> vmalloc etc.?

Hello Nhat : -)

Thank you for reviewing, and for your acks on the other parts!

You're right, I missed changing that on my end after v1. No reason
vmalloc shouldn't work here, let me make that change in v3.

Thanks, I hope you have a great day!
Joshua

