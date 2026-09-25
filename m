Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F935C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CE26B0088; Fri, 25 Sep 2026 16:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE4F6B008A; Fri, 25 Sep 2026 16:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADB66B0093; Fri, 25 Sep 2026 16:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E14F56B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:26:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EA43A6E21
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:26:27 +0000 (UTC)
X-FDA: 85253417214.20.E95A4C6
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 345BEA0004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:26:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oiiV2OZ0;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTHOStho6nRPPrwayEo907rSZvPmwPMNwiUqVSkI8tY=;
	b=AhNSdKPxDPa0iS9VQikeb+8LEc+69vlQ7D/0LfJtpFULX+auVr+hElebrU24GfZAcnGbsi
	mqj6W7kXBZCX1WKh2RVKGOu9UtsCEPFRVG0qeLN5fkSZmzvBHKAB8s0RrFRyI1PQT2FDFu
	UST3AKolUROwXmNWtj5T2GqjvEwaSy8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oiiV2OZ0;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367985;
	b=NwsYPsLBQMIvzWo4afQc0bbvyxrZdE/GoktBETXnVOJ9rfNiPEMCNwrRb/PJykTCkroM4D
	eYPvMvQJXO8pdlmd6US02U2MxpCUtP8aFjesPBOLWP8BwIjwL5DwXzL554mlRa5n3eF707
	YCagmBueoPWfP6zCjSVfQu3mYfas+fs=
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8693af0d7c4so863197b3a.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790367984; x=1790972784; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UTHOStho6nRPPrwayEo907rSZvPmwPMNwiUqVSkI8tY=;
        b=oiiV2OZ0EsPEte3K54w3z8Ww2SwUf1f3n5/7rMZ+xrubN1KUKNWGFI15ozhyRaMgZI
         y8SvF7+N5vp/EjoaRmEWvL91NL2b7alhKSrDXPOz0vBNR44Aod5TXbbdm9XhM24ci2A2
         D365gHMYvuQ/h+kRucjk80vlR8uwhVYK0F9BAEWM0D7h145y2hAbx3slb6uTGa3wZiX9
         2oB429fxBqtmSMXsE2/ZlxjjEWGcipWUC7SXyFAoCwqASRRom/hQ4Pe7Tl1nvgV7X7SF
         jArUR3KrJaFPoAlh/9G7bSV23A0f/+g00ajYifdK6whV935LEu33Juo0uMh8BchyGUcF
         +5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790367984; x=1790972784;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UTHOStho6nRPPrwayEo907rSZvPmwPMNwiUqVSkI8tY=;
        b=0bKZ9F/zzYPOnbn9yVd+ZFeXul91xKOp+veuvlvPb5GJV2Kb4Q//dZOHTSW3u5NIl1
         YGN8tERs0U58g062C/WPUhOOy9uxcxFgkRoVa+EV5OcBaZniDK2YPFHTY12+8tdt8auA
         d7TwscGaL739HAnCwQhBKYTl+MBVcce1pn18YwCtjdVhYvZAQiqbDJF8eGvF80jk8Lq8
         bycbmZVGWnDKhSaeIE61MziV2HprBotRTolg2RBOVM2XhJZBWrsLRgvfE2j23weDzl8i
         6naNI/bDVoL9JoxgyuyBuw2UrrYLcFncZsPLrvoQJEtSorcFHkpQDcxe6K+k2KPhBt2s
         0wpQ==
X-Forwarded-Encrypted: i=1; AKwUvBx9RAPCRfniWLeoEkaCxmj7CPndHU2uE8gkwQwGmEvdlx3vB1IzpDL0o0vH7JucFn1/OvhrB8M9Hw==@kvack.org
X-Gm-Message-State: AFuF++kjkVKS6OiRjjYVQ+JO3mSCSvDBYdRcJrOGnFU0CaIftrFrgOxX
	mVV6DDg3H4n+2fkSupBI9n9aEYFqqCTv+iYxy/9fb05VtxtgwEmIVqyQ
X-Gm-Gg: AYBFou2InZmpSr/7KVheqKFs5zQG6ORojJ9Bot5UjBRmkl9FEtu4SVjxI+xe6RKL9os
	w77xAm5LsYmNisLADsE57pOv09iAwPSW7/aPhokR6oadrm12r+mlm8NLH+9mQAmTHypc/L00Tmh
	64MxX6J9bJmvQDfYbW4HXly22SUXh7aEd8fg/wUBu/hb3v8nHnplsWSzAj8XErnRmS1urnDJn3y
	u4/sAAhtaPVIwyydSAZT1rpYhoPVJ7HllkEG5/89/KxdQNwyJTJmPhsoU1yWb0AqnQtB+OD7Gcc
	zLayx56H8MOOh7jgtjSLJ6lHHrFzqmVn1bKVPe1fC4ErqqL+LtHHuAS0b7MQCZDIhjShQqwbV8D
	qtkA/zlRS6PK0aOl3ges22sbsQb1n5jEL929MfmZY36xKSSOIk26BeVyVz7AyOIxjQ6WOjN1k6i
	mBfD5kmWoCEAI4xfwOjUGCkazvTlUB8Dt1dPeQQbUPwD8MeCRlvcJsd7W6QOhEjhpo2vSN0qPV3
	ZE3gFoegmav969eQCbHaOzW4ztF+676AMFyX2g=
X-Received: by 2002:a05:6a21:8286:b0:3dd:a006:7b32 with SMTP id adf61e73a8af0-3de0e8943e1mr7946963637.49.1790367983822;
        Fri, 25 Sep 2026 13:26:23 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc790c80e62sm1265849a12.28.2026.09.25.13.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:26:23 -0700 (PDT)
Date: Sat, 26 Sep 2026 04:26:13 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbTTKE6nYWlNCLd@KASONG-MC4>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <CAKEwX=PXRB35bUL1=O4Bgx9A7aD4izZZ3dcEcCuMBBhBrMv7fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PXRB35bUL1=O4Bgx9A7aD4izZZ3dcEcCuMBBhBrMv7fg@mail.gmail.com>
X-Stat-Signature: 68qsqecc8ef9pt1n8an545gqq4qf1nn1
X-Rspamd-Queue-Id: 345BEA0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790367985-375306
X-HE-Meta: U2FsdGVkX1+IrirVAqfDNW/XYBLY53bNwOkiuR35Pn6/cn3MLWnu/nRoh40Iu99SqNNHg9xLceUhks9f2crsleulz6MV3VkuEvADq5NhRB4Utz7Xu75ftovo+sYjmoHhQraDELeTu3Sb/kfQ36BX6TR0LIyf/KpMmYjVFPOSLVROYKEpyEvm6FPDmHOdaW3WZ8Hi3f2PllOIIyp9Vn3i6iigmB668nIkGhMakDK6HTTjr98pNv7d6Yb/e58rwU8KU5QTsJlWzn9wuH9pCFaBb1bCrYgGUIQ2klfEVRl4KA9hZvXpdIcKoJhQfeWPoEav2qauUqDQJEQQZ2COcPu7vfLSj4euZy1Pa9wqa+0YXrt4DYg6wHnNtJeoq7BKNvD0Mu46ln/HYofzefxNY5lApMWmGbFdOi+1GSgb11z0+YeIeUwI+5GnnXRimGxAtNTG049PJ6Omga/kFqoHgjTv08kstLkQ0VJTFD/wCgJHbzOWai8x2US8pOxldZmGRc+G1ndjMYKJ69USDVB1SLNZbXHoPF+IK3opX7IwsEP447pjYlHX24fZnzGPu1f5ZYj1kXLmtdQJnPdwcPvNPt1CyZR69ve3dC7+FjA6P9ZwkUsKm8OOS5LPF0zhJgLC1CsnWYwdOYezd5RASdDW4ztx7HxO5yLZQy9kkGZ82iT4AXO8a7UBcYM847igrI8BKdCl3+7fkgETgNK1Pp2KlB6QVNAFnOSBKQpb5PSFM8c9RwEl8pOP1wVJJYG/cv+Vab+FKssbqXvX7IhvW+8QpTBcTfESfSQ7GC4Knp1no6LaGbMJstEOsbPdjwoePEZh3DkXtTdV5SZxkVszpggk8CfERMcPSh6722Xb5hIRurVBkfK+/nlvKV3n25jDbnpmV9MbttZPGKQs7idtjlQDaai0iO5eyghXUZe/u2jFGTGB/l2dgRdqUu/raLgStHlx6WXIetnlZoY/QIJAoQi94p6
 tOeptDGF
 h73i9NcQBCqyW+Y0ZjeiWS7DVaIys1LLzJBkmleKCeB3BLncEeqPyvvu5kDsnFnffLrRMVViYCd3KUayPOd7bs69UH+F1KfEOQnkYRA8mp6F8L0mouJO4bZbUP+jSZ/fmmhFgAX9CgYAPULLjagM/uuI0YTNVbWq8cUGnsyPFJnvO/OgyhEBvRgoyIfzXMgA4UwTYBeuoZ7S2nVEr56nj2g9DChlBK6xFo1i+9+HMLXnOSi4jjuLByNSW25WiJx9yzzuY6+fNO2PXp+bUG+H1Est4QHl13sqcTBP1G1EiKDg36MlhoeflYaN+3yCVrcWr9KSJRBkOl2qvQDHhAP5AMoItRhDIksTskk0FWDOFIDV2o2L7SRQo9od6e/FqXOF/Wa1jWpeLPFYM3MV+y6EXQTquNWoJ75tu5Rl6NPHySgsNUnE09VfajYS7ghuQDIf7dDy+42rjT4GQSlxCmO3Sjx3BWRHvjC7BjzseacFVBW/9y+qq8S1baqv2g15iKs3hw27QdVSOHBL0SqM5LDtp9CxKXVNmiC6l36oxKS8JkR5MzCOknCJPJuR+7rBTWezonsT3rPA849KwqOlSZLFDSC0RmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 09:54:25AM +0800, Nhat Pham wrote:
> On Fri, Sep 25, 2026 at 6:15 AM Kairui Song <ryncsn@gmail.com> wrote:
> >
> > On Tue, Sep 22, 2026 at 09:44:37PM +0100, Chris Li wrote:
> > > It seems you are talking about a different topic: the vswap charging issue.
> > > There is a golden rule that we should follow: don't break existing
> > > users. At least with the same persistence, this rule should apply
> > > universally.
> > > In the swap tiers discussion, the UAPI was such a big deal that we
> > > couldn't implement new UAPI. On the other hand here we argue for
> > > liberally changing user-space visible behavior.
> > >
> > > BTW, I already shared that changing swap counter charging will break
> > > our and others' existing deployments.
> >
> > Hi all
> 
> Hi Kairui,
> 
> Thank you for your thoughtful response! Lots of food for thought for me :)

Hi Nhat, thanks for the reply!

> >
> > Just for reference. Maybe a seperate counter, tiering, is a better idea
> > than changing the swap counter?
> 
> I think memory.swap.* is never meant to be used as the "offloaded
> footprint". It is incidentally correct, because of architectural
> limitations: zswap/swap cache/zero page usage leads to real
> consumption of real resources (physical swapfile).

It's not that "incidentally" I think? TGhe defination from the function
level seems pretty clear, folio_alloc_swap -> charge. A logical
limitation.

> 
> But I understand your concerns regarding the missing observability of
> the "logical" footprint (i.e the "offloaded size"), and how that would
> hamper legitimate use cases.
> 
> How about a vswap counter that tracks the vswap usage? That would
> provide the "logical" view. Userspace can then monitor and act based
> on it.
> 
> I think that should cover both of the situations that you (and
> Johannes in [1]) pointed out:
> 
> (1): With memory.current and this vswap counter, you can kill any
> workloads that violate the level of overcommitting that you set out.
> 
> (2): For us, we can use memory.swap.* counter to provide isolation to
> the physical swap space, which is a real, static resource that can be
> hogged.
> 
> There will unfortunately be changes in userspace programs/scripts that
> is required. It's unavoidable. We're adding a new behavior. It's the

Right, but usually I think adding new things are generically considered
better than breaking existing things, unless the existing things are
either just metric, or really broken. But memory.swap seems has a pretty
clean definition and implementation, and usage?

