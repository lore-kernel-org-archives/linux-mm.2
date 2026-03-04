Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83FEFEF8FF1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C136B0089; Wed,  4 Mar 2026 10:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3C66B008A; Wed,  4 Mar 2026 10:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF9F6B0092; Wed,  4 Mar 2026 10:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81B4C6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:11:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AF861C7D8
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:11:25 +0000 (UTC)
X-FDA: 84508719330.01.8174FC2
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 46168C0003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:11:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TB3alOKW;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772637083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoKsT5JRqIpY8UANHFptI+GVlx4Jt8dOkJklplEKYw4=;
	b=KRRvT1Ye1gMDBEg9QnLk6TENMGtZvS933EbSZayjoWq1dE1T6lwAad4mbKGxz+9KpAsf9V
	7tcujrYjP53iTap3t/mYXG+l7vQT589JHvTDjFVnrX0RcpJHPKqV7wtauFdtAoNzW9YcC5
	FvAxf7EqANWGEid+dh2GRQtz7X3BCMg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772637083; a=rsa-sha256;
	cv=none;
	b=pfFyhqCZ5Xi6+fDQN+xhARh+lpQRu1LyJLOcjjP5cKvAtQmOw825efJtWU2DntY5+imO4f
	NG/eVquiIyYxT4QL3ttbtLyVfvEBxMXOJPLAcZWYn9+4RCuCDhKIk08RecrRxs18PdgzaO
	bCSikVw0uuu+n9ZvL4qj1dl2RVORTwc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TB3alOKW;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d1959ba05cso3510876a34.2
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 07:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772637082; x=1773241882; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoKsT5JRqIpY8UANHFptI+GVlx4Jt8dOkJklplEKYw4=;
        b=TB3alOKW+u8fX4hz7j5j0wxOl5HqTE7KDBIdZIKrGDGekJYBjbQ4YovWvEVw5UHgzy
         5FNAQGv6uByUS2uKvwqowc72XZVNWMy8nI1vQhjZIb049E4/uGdwzaFlIvqQ6c24bild
         VIZO+Ux3WxSzDKQ5s3+SQysaf1LUPzBRhNQKQMO9v7bt8yAY4d6GsXs6eStTxXCW/kvz
         IZ6uH6CsccxBPYGbS1lDxPhMC6x4sdBGIuf8YapY040abO7NNLHt8IowkKC/DMoJj8EM
         J4DybpRxQQrq1ph/xYpRjBrFYzg0tT0IJEnKcsdqg+AwxuOc4pWfakP7dfB82ibmr7hj
         vFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772637082; x=1773241882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QoKsT5JRqIpY8UANHFptI+GVlx4Jt8dOkJklplEKYw4=;
        b=i917MD5W9srgExZk01im6v1yxChUC8B44mCUqKRvDjXyCOYkZOMPvApobmTJfZomsq
         yyfrRTbs9i7RHzJW9sQUurtbuvhGBPPTw1ttwJhbb57ukR9NrsJ3Vk5bDxuaP3n9kjFh
         MS89QuzRGoRFw81Fu0GeJOypUYx+jAukIx7a+tpF/s0Qosh433UW56gUudTNLtkMA3jy
         i747P2dd5ZlVz/WxqDbieguOnRWVVd2+xud+CdoKLyFKDh1cva9D9ej7R2VmOIv5DfuA
         iu2eGDHVbeTb2Gc76splVBviY/C89SxchylVmXT+kYLQrJY4yBJG1cfzg+mSMY23WOl6
         +a4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVIHu8jgB2WewbqKVAvuPFJ8jHiMu96rW+muimBbTF3R6vTz4cHvSRLHbgQ9NixKKrLQWU5JCn2kA==@kvack.org
X-Gm-Message-State: AOJu0YxqRi245gYvslWMM3dO+4y7dE+lcqEB1HsDbalPS0/ZbIKU9Vuh
	Rb4Imyn9KtXyuhUkHquXYe9oGvKUQwxJSR1weR01rE52E3Y4oAqImDz/
X-Gm-Gg: ATEYQzzMWk461IwvlfHLtzWiOhgXXPHSXKqkGUE94Wxfb2rf0uezc/85T7vIFtNDCYf
	XzD9FLugmcTcjr1aSJLev9pE5LBnQiY03DCwDDWNTFgmCQeefiyjx6LaNF0s7du2JokCs/um8U/
	FWfBKc/KGLMGkhX943yI4CSQwRIRPyEFHy2ceRfHHrVHod+0wCjAbkgElVjd9Q8yLAIrSz1ZJAf
	TEMDHed5hzDlg/iXACDhGp1SWBA7O74mlMq3+iJaf8d8m2k2MgGT7uquUY6PoUTbMfolpXB+4Rt
	qYaDR81iAurj6HXv1XcJ2Qj5bMjjazeuZnl6XICmdguVZKb2WqxSJyfhFsCeDtHyXxT4MYFKCJb
	TnLCKQjFashar27NGnU+U2bXMGxL5B4syEZH9u9uGmV6JRjfRmtKFy0NP7PlS6StSGyndkpGwq7
	DNtjbJw76fs1UQdVyzM/45Kg==
X-Received: by 2002:a05:6830:388c:b0:7d1:90d6:1f5c with SMTP id 46e09a7af769-7d6c7f4bc25mr1088903a34.4.1772637082089;
        Wed, 04 Mar 2026 07:11:22 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866701cdsm15564292a34.29.2026.03.04.07.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 07:11:21 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
Date: Wed,  4 Mar 2026 07:11:19 -0800
Message-ID: <20260304151120.3512645-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAO9r8zOFS7zU-eGkErcjud=DW0t00_WqNqCzq_QDf061dOsYSQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rue71f9tukgto5x153bmob3637kzhuot
X-Rspam-User: 
X-Rspamd-Queue-Id: 46168C0003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772637083-203214
X-HE-Meta: U2FsdGVkX18BJHGWTdz7Nr2uiK2vhgYlbw625rjDw9oOXTZv4r10YgHMynml6+29lTiUElSNoU2+Io3iGazXzni1KDmCkDFea1v8FqhqqhJn51D4NkjpHiZ5/veSZvXAFGS6Lc21hxHzHoLw+OBp6Mg74h7fbM1ML13MhwQqEBWh0YeviFP4pC49IEuwW/CRt0+73FZRBezEH0GKkkYAN8Mqb8v+QVqs82g1wFAZh1OCE4S1J5SL265G9FgjRcDGL8gJ8/byWtrJ+I+LOXBrx/jNRma4B3II/o/7j5ppM/p/8tTmEVAWTNb4XNe+HCTtzthkJ3YOX1PIE0efYboZ1zPKyeEKHTqdZMIvCe/YakH+6XsdocrzddpLflVKhka2e5XF/XkBsUc5LsUj73I+3DeVmcxkDNcX85DULH78dKSsJTG7pKPLLY3YsUwSrK2/GgPgth2dHSZWZ5ASpzA4YYy14JaGpJ4YlRjhCGdEV3kKTtYE7OaZs2hK06kICPLls+5lZBXSAPqc/iOAx6M9cHzpCayvwpMfkO8dPjN7L/c5fIFORUIMQw2amUUWFYpnOWznGpD00x9TUGE4KIXLJkGl+vYZSSPolTqmIyR3Yo3koNbJb9r/KJYGoUiGZ3PZ5fj2FfIZXdzLMQPm4ATGAzPmdIX1XTWOIroUJPSj+RalH/pCAlSMMJpV/qFKueyaJgYJTSX9z2fQxdpiG1gaCUxAUCM7oxmbhjSb3E2M8dHuoomMiWxV6ozlYFTt2+eLadYy8vbSIXlQXKimisfUItEZp5WIOOpfzWaq3xcwnvQgpMiX1YjUi++q9n9iH5rPFQCVThu8JjMzGIT2pfLYZJroiVAnQ5PvBBYiYKPhTgr4pI1qhmJAzlxOFtIyl7WRv+P9WEWqOX7Cc7qt4XN+mPWZEztZU0Xe5cA3EgWRbEA9QOSq86c38DoeGIq1jGE0LWABuK9Vtn5bud3eEr4
 PABlvrZ7
 39et+lB5IvKFTxGx7FfrBOUgOkSpiBgBGSSes6VH1LsbGJ4KwZFDPCDE0L2VMRkB6WPg9U/RLSa+2ogQtCMkolOb+I70lDpfBXbmwxe2GfGzehfKn0IWHKm5Y0PpmmlK17TCpoTUp0QSwnIx68/UUlpRAXkWU4EqlnT9C8gqRmXyRkZAFX6M5KPgYQgtV1xstQsqn99fzX+B+mprFKY09vV7BHwcIgyhtlPX7V1ZrmQAzRLqJIkl1zY/FGj3xWTUW3IcSserkjLei9t77oS82AIydzmFIz1NFO5Znay4zkHHmlFXtfkPqhFNAL1UgpM0c+1ew5fa7xaXkSsUl26NahUCS1Eau/Ni07gHRGJI6ok5JQBNNc5ViqytmJQpt393HBjiJJMoS9qaJPdB2pQlc7qCV0BQnfgeWSx92HrOrP/aMcGSbXpJQva6T0Ms2qrAux0uq1ixYYzIX9WSFTi8njU3wcZiZPtgxpWRWukDPMXwEJ2cLHKlO74oaz523lsV+E94PbhaXaaJZx+OPuZFg5dxqBiob9jQx9wxA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Mar 2026 15:53:31 -0800 Yosry Ahmed <yosry@kernel.org> wrote:

> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 067215a6ddcc..88c7cd399261 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -963,6 +963,44 @@ static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
> >         return true;
> >  }
> >
> > +static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
> > +                           int size, unsigned long offset)
> > +{
> > +       struct mem_cgroup *memcg;
> > +
> > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +               return;
> > +
> > +       VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > +
> > +       /* PF_MEMALLOC context, charging must succeed */
> > +       if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> > +               VM_WARN_ON_ONCE(1);
> > +
> > +       rcu_read_lock();
> > +       memcg = obj_cgroup_memcg(objcg);
> > +       mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);

Hello Yosry, I hope you are doing well!
Thank you for your feedback : -)

> Zsmalloc should not be updating zswap stats (e.g. in case zram starts
> supporting memcg charging).  How about moving the stat updates to
> zswap?

Yeah... I think this was also a big point of concern for me. While reading
the code, I was really amazed by how clean the logical divide between
zsmalloc and zswap / zram were, and I wanted to preserve it as much as
possible.

There are a few problems, though. Probably the biggest is that migration
of zpdescs and compressed objects within them are invisible to zswap.
Of course, this is by design, but this leads to two problems.

zswap's ignorance of compressed objects' movements across physical nodes
makes it impossible to accurately charge and uncharge from the correct
memcg-lruvec.

Conversely, zsmalloc's ignorance of memcg association makes it impossible
to correctly restrict cpusets.mems during migration.

So the clean logical divide makes a lot of sense for separating the
high-level cgroup association, compression, etc. from the physical
location of the memory and migration / zpdesc compaction, but it would
appear that this comes at a cost of oversimplifying the logic and missing
out on accurate memory charging and a unified source of truth for the
counters.

The last thing I wanted to note was that I agree that zsmalloc doing
explicit zswap stat updates feels a bit awkward. The reason I chose to do
this right now is because when enlightening zsmalloc about the compressed
objs' objcgs, zswap is the only one that does this memory accounting.
So having an objcg is a bit of a proxy to understand that the consumer
is zswap (as opposed to zram). Of course, if zram starts to do memcg
accounting as well, we'll have to start doing some other checks to
see if the compresed object should be accounted as zram or zswap.

OK. That's all the defense I have for my design : -) Now for thinking
about other designs:

I also explored whether it makes sense to make zsmalloc call a hook into
zswap code during and after migrations. The problem is that there isn't
a good way to do the compressed object --> zswap entry lookup, and this
still doesn't solve the issue of zsmalloc migrating compressed objects
without checking whether that object can live on another node.

Maybe one possible approach is to turn the array of objcgs into an array
of backpointers from compressed objects to their corresponding zswap_entries?
One concern is that this does add 8 bytes of additional overhead per 
zswap entry, and I'm not sure that this is acceptable. I'll keep thinking
on whether there's a creative way to save some memory here, though...

Of course the other concern is what this will look like for zram users.
I guess it can be done similarly to what is done here, and only allocate
the array of pointers when called in from zswap.

Anyways, thank you for bringing this up. What do you think about the
options we have here? I hope that I've motivated why we want
per-memcg-lruvec accounting as well. Please let me know if there is anything
I can provide additional context for : -)

Have a great day!
Joshua

