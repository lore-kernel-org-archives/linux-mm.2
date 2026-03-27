Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF7810F2863
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 18:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B9B6B008C; Fri, 27 Mar 2026 14:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6741D6B0095; Fri, 27 Mar 2026 14:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589186B0096; Fri, 27 Mar 2026 14:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 467816B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:00:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2EA6616123E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:00:07 +0000 (UTC)
X-FDA: 84592606854.23.11993C7
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 406FA16000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:00:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FmZmoPzx;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774634405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psRPCm+63S6VKzTyhaTnVC2SxoOiTOnf8ReGI1/gkuw=;
	b=QazCj+O3qRdVWdPMlT/Yj2ylRdI5qn/qcpb0sDa9DjM0ensO/RMvSiszhZt9BVsuHu314P
	aoz5+HZkDTALAbaUJc0FMg9XFzVPcJrUewYNnDiXuLZzf1aa8gpuoQnqDRWP9LUcTBCpLx
	iyyhPyb9/VNXHnP40mzoBOBTU1HR3XQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774634405; a=rsa-sha256;
	cv=none;
	b=tctycof8YxVqZazaxLIiMGvXahQ5mtjwzOYXP8wHQDYCxW5CvnRpLlcruNaVud5Xt8x18F
	HVmJD7wYnn7gzwsxyNR61X0m10WkMsJ47IdUmmxrmDnneLgHSWCCSyctU7x6EBd9FJCpOW
	c3lNK033aTvrQmGOs3OgCoKbEpYGueI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FmZmoPzx;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82c70e4654eso1080949b3a.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774634404; x=1775239204; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=psRPCm+63S6VKzTyhaTnVC2SxoOiTOnf8ReGI1/gkuw=;
        b=FmZmoPzxqNxILAYFvCmlZRLCmz9OqazsvZZ++zMfvpPpKIY9ujHM32qm0XQUBNG6e1
         4jZwHNKM4O9pmNt7qkdlga5FLr3e8BWjD5ogBWx2AAYOWrKolu7yKy4G+3Pjp4BDEsLs
         XEjFZf5TjZVTyxCihqrLYpu0cthKzVxL3JJ6P4PPui6973lXjzztc1fynmq7ZvduVF6N
         YZT9uY+ncKpTePlegN/lIYFzEfNC31qUtV8XrZFNWn8Oceb7ZeyevNNJBPnLZD3XoQn+
         zZA54mINpvOVG7IGR+TeNZIe6PQq46oPM42ocR9CFSp/IS4IVnE+ZXFa6VU1TTimRZUh
         sPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774634404; x=1775239204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=psRPCm+63S6VKzTyhaTnVC2SxoOiTOnf8ReGI1/gkuw=;
        b=aDkrLhql4y5/nx0vHmHt4rEusXLjhpCiGfTfbKFx0vaomL/Bhr3m9xmnClWHNm6p3i
         KVKvWdxiK/3oJIJq9HInC9SBEej+w/ocpRjztPhnBeJt1Fje6wxEEmEL1h2nzWHeOQNb
         JrByHNNXAv2JYGuNpOmDMhi9yy183zzDUcP5bKd90SV8xkA8kbU7UwbRDyuzJr88GlzG
         mIl8g2WkmMNAw4Ql/JWam4ts5IRt40p1HWsW4srzSow1+eYRPR1k+TfQtcezotVu5XAB
         Nmdl3MMGD4Q+KENNJ4b7oWCQCBjXDXUucDbxX2xWruzn0NJ51590AA0jxtu814zyQSYm
         XdJw==
X-Forwarded-Encrypted: i=1; AJvYcCU6QLLfuuViFn0qdBV7GQhOKNtX2baekp/1iXapqPo9Crx3JAyhVkzddS5myXX8ny32Z2V8NSdBIQ==@kvack.org
X-Gm-Message-State: AOJu0YySrxTHXCyUssQDFHvziVwPnUDeFmfwPwvkpulKVHkObj7BQazX
	TUq8+y8N1OUcWhb3xrtDqyNdWb/pkAgnHiCk0LVgO80H3TG7ow4fsJ6x
X-Gm-Gg: ATEYQzw4hPwD3sGGpEsNb/KeXzdg4TwW5HKM1e0EMBzB1AaPtT5RBW2558y2z2kwaFP
	HxxjxNPXoBpAa5zKWNuz6nzv1Wz3S79xzCxRrEMzDU5/XbEHr817jrZuCKdm8HCzFW7H5v/h0jO
	qPuYn16BCkCakrcG/NepT4hqb5B11RtyN7WZhWHKDCrB8O6hVtFaBsi4xRr48e2I/ZXfU7MJxv3
	8Y21gAigr+jcEXpA9KBxqTymj/xeakOOioD0KjgplnbK5eeHTSAYRNdTu5MiWt8M3sI7zp8AIcg
	aNE+NlYfubI1k9bwtI9OuZJepyTJRqBspvEgGsxItbRLf2MhfrzKzh/zGh13WoHMpW8HJP+qOAC
	kl3FSzrbYW7h1JJe09Vp7QQPVi6fsLRQFIlnTVQLtgeEEDs0icze/4ATqAXW6kmMbLSbePneAhw
	UC/DAFCsTgrefQ4QMCpZVH/5oYsDlH6PVqNhTYLKBIQVMF5fXHfYK6Z4/z9hseaBkxYQYmwg==
X-Received: by 2002:a05:6a00:4095:b0:823:3079:7c7 with SMTP id d2e1a72fcca58-82c96001c0amr3363107b3a.29.1774634403774;
        Fri, 27 Mar 2026 11:00:03 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c964f9e9bsm2601447b3a.49.2026.03.27.11.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 11:00:03 -0700 (PDT)
Date: Sat, 28 Mar 2026 01:59:57 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	ljs@kernel.org, baohua@kernel.org, kasong@tencent.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for
 MGLRU
Message-ID: <acaz4GeAyanYbzj7@KASONG-MC4>
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
 <acazIi04wEGrKq14@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acazIi04wEGrKq14@cmpxchg.org>
X-Rspamd-Queue-Id: 406FA16000B
X-Stat-Signature: rwie6eqm5jwx1h3e8wza4gdrjoxe5ok7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774634404-479518
X-HE-Meta: U2FsdGVkX18NGGGBb11bq42KYwmQwEzeJkljNXQgrp8nzcYtd/xvwFCpdVy+6cSKbFXNgi38KhQfbxirtzKYhn3NXgWHRlSTZ8mr/NNr562SY5IjPcfwtFQNw9TJ6pcjGX+oR5+gK2pncevh6IqZ0wNrmadTfjmlQT5Hk/UEAPM6Uxm4pM9dGg8HH6F1xBfsCMbVYbWuhzoEQBy5/izxArMQbGp6IEd1O7wirBiE9gFabsGc3LfDru0u7UVREcxYYAFYMQmdz1+w687g6PIZAx1Z7yenwJDDKV/3Qco/Gh7NBg6PhJsNMS/XTKbzaq06VGGkns0KML4+mis9WwHu5eNjiLOK2SCLR2ZlSQPcERrrCmJ4xbOc1SLCmOeRuEZuUJll/qtlyLTiLz1daCX6ST09LbBrUCyq+GjFL646WP+v7m73oY3R0TKAujxfCA+dyKS+h/h4xOVnKfd86qJ0Nl8U4yvUJ6DtzcjUCUiHdDqqnYYjPNCwBUruKQi+Cf9RbeNNZiFBDz3pf+wVpMDS35n3zy/++IkoXLKblsmZU+sHpW8r1ZUkI4bd8uBKXDQ3B0/goh2whmG/MsI780mjDBtha9G/Nxd5X/4kyNZIKlFJKhV+oVpPUVN/s7W1aL52TmC3wBn7AXXabQ8KxX3hoDlMNMe2gP1Jm/GtLu+EJIW92VsyscKJQ36tlNmWR5QnFE2Wpb4lK1IQmP06TqmDQvC4qS+bc6oq8o8pS/2cq1/KrTuus9L1Hx3WHJ2jK/xp+99cTkjFsql5AV7Kc/oGdzB5KqtrrYjjYuWtWK821LkVaPlMnsZgUYPnu+EGsbmmaTwdnC0LgR331mOIiKp4CCA8PkEmf/gV/dmV3/8q55jIb6KEvGjgpbRxncpu4xxU0NlSDIXmBGX0MCSbVc4aDvW6/yST233p/K3anjawXQRoxh9m7jljK7UwUXPIEG3JeFn/fmWtQRTXNAIJC4B
 zfToABxR
 A4bHn/+ZjtbHftmBDdWP7LWZauqpcIRQpmY1ppaQfA6jo1tthtL8oZSPkXiZ6hqaXRV00aSOPp6FqrWkz+RrPHJcm9TlU4oQ4w69/EqLl/pLaJqdBFzX0LpBc395xvjG9G7opJERFGpWXysTEPqZknjeDOhLflxIQ1G/Z7qc5V51gv7ug163YDqP9229NkX4L65aEg5VqblNtbNTtPFFcTVmGhGtkNprZEsZdLf/qYQPlCdSvJpyY0InINroxbS7G4yNdq5Ztcs14+84KKeM9kGffY6LdDL8BYMCKNlaM7OHgnFh+BGW6sOuuhts2JKhHCiTS3/VdIw/Ozwp3dsEhwkFpO+CEzxNo+WSathpXwL3BvWrwijZJSzjYScHTmUxZilN/owlyghYXTn8xXr+mMALmREX2lVmZKNXzhVMbCTA4qq+LJDon15CnWithBWMFn+dRmgPBqTCjjE9LrhfhbP/PA00bKpMAlhj+tvpl/j8IjFp58boM1WMRNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 12:41:06PM +0800, Johannes Weiner wrote:
> On Fri, Mar 27, 2026 at 06:21:08PM +0800, Baolin Wang wrote:
> > The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
> > See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
> > on traditional hierarchies").
> > 
> > Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> > longer attempt to write back filesystem folios through reclaim.
> > 
> > On large memory systems, the flusher may not be able to write back quickly
> > enough. Consequently, MGLRU will encounter many folios that are already
> > under writeback. Since we cannot reclaim these dirty folios, the system
> > may run out of memory and trigger the OOM killer.
> > 
> > Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> > which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> > pages throttling on cgroup v1"), to avoid unnecessary OOM.
> 
> This fix for cgroup1 makes sense to me. For cgroup2, MGLRU shares the
> shrink_node() reclaim throttling.
> 

Ahem, I think that throttling is actually broken and so I'm fixing
that, I shared a patch yesterday for that as I saw Baolin is fixing V1:
https://lore.kernel.org/linux-mm/acPOn07xah2eh0WU@KASONG-MC4/

Still need about ~3 LOC change after the patch above since I also
need to clean up MGLRU's force reset of PG_reclaim, will post it
tomorrow as part of the V2 of MGLRU's dirty folio handling rework [1].
That series will improve the batch and dirty handling so fixing that
is much easier and cleaner by sharing same routine. Before that
series it could get very messy and cause over aggressive throttling.

Will post tomorrow as my stress test suite is still running
today, it seems all green so far but just in case.

I initially want to post that after that series but Ridong
suggested to just fix that too, and it actually helps to
deduplicate the code, the change is also small.

And right, MGLRU had some issues with dirty flush previously,
Jingxiang and I fixed it:
https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/

But premature OOM is still an problem, not only about dirty
or writeback, but also somehow related to how aging and
protection works. That new series also fixes quite a lot of these,
e.g. the OOM reproducer in cover letter.
https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/

Still not perfect but no worry as we will solve all of them
(hopefully very soon):
https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/

My local reproduce using dm_delay and dd can trigger OOM without
the fix I posted above, and no more problem after that.

I guess storage nowadays storage might just be too fast and it
rarely congest the whole memory so no one reported this yet. Of
course it is a real issue. We did see a few suspicious OOM,
rare but might be related.

