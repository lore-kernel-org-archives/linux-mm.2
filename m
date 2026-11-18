Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A35606A339
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=U3TTIT9k
Received: by kanga.kvack.org (Postfix)
	id CC80A6B05B0; Wed, 18 Nov 2026 10:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA07D6B05B4; Wed, 18 Nov 2026 10:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5386B05B5; Wed, 18 Nov 2026 10:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2366B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:51:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27423C07A5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:51:25 +0000 (UTC)
X-FDA: 85448679330.22.C3B4CFC
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8798A0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:51:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=U3TTIT9k;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017082;
	b=U4vLogRdsM9/8jdG1dVLvb8YU8lIX7mkj+tmaj08aH2MxFEEnGac6zhb1Pmj9qgwMFtbnR
	MXJMJ6iVDll6D+37R7Jdxk6TYP4uu4LJoxj56+mEi9VDz3rCeuelGI6QnlwmHnsJsspvFv
	TdkW7YjbxKLA9uGMWT+PCOF2GYoK2Kw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=U3TTIT9k;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtu+dm+kZUdeiLu+ztbJ6g6Gzpa+7bPUZ/F65mvaYZ4=;
	b=tMLOTwsDbS9z2Z17F0fsZoQqnn/s2sofvKq2qo2J6oOpXkV3+LU7PD7XYZiXo73d+vyUoc
	HB+FHH/PtJWj7d8rT5GrEtznowb2WUS7AefOc8hiFl9WEWm5DXEVUj6ZNx+ZD1xR7pM9S5
	oQQ39Dqvl5QxlA989Y+3XBdLsNrTdDE=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-94961ed97bcso138585485a.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795017081; x=1795621881; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rtu+dm+kZUdeiLu+ztbJ6g6Gzpa+7bPUZ/F65mvaYZ4=;
        b=U3TTIT9k5KYvdzSMPcyxEx0QZRNkT1swdYJq5YY66i2nKZrQ74vq6X+E1BMat6Kt06
         zrojOtKHfXZWT1NxYTbK39Dt+KoHGE6qkmOeULfu8ElQ4RLYJWodtPaks22rS2eIsSiD
         DlX+ii9whNz38UrJTSmViePVanU7FTPn0aPp5jLoLTSWdrFVi9pFLpW9ssYa+d7Mgl8l
         N7MkN6+wvyujhMm/p2Js1dFKfFaPb48isD77lECv9tkxr7aGH4/WKZja1So4Ki+bThln
         QgTuGm2UhyWyGxL6V94fnJXvt8LMDDAIjGshzULBDxb2TMlCzikERiA9wHcLlF9HkxKe
         PO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795017081; x=1795621881;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rtu+dm+kZUdeiLu+ztbJ6g6Gzpa+7bPUZ/F65mvaYZ4=;
        b=pb2Opq3QT9nh/bVWC4pnFGF1C12R8lRNpCz/fIG19dNbZEMmzicXJj8TojKMbVmM9U
         UWz7Xozj+KB0CxUzzlCn58SQl0IIM48AinMc/Dc/X+oMKB0IMcIlt2Fb+kKNRKcEtlpt
         tYpeHrgY0xv+WIbKKi04n3KJbjOwZrEXKl7b+9vLx3Q+aPt6D1cVdx89E7Vq/dpWVAe1
         E1EUtLjpRlqpf8IXjbSeca3mlUxW2cuhImNgl7RzipQC8z/Fi8HwNW/btsaJ44Sq28RD
         bznKSmaRd1gg96TdIXbeRIpF8BlLCDEPsQjsNGgY0SSS4p7YCtoHgYxKPO4Umn10hAsX
         3ycg==
X-Forwarded-Encrypted: i=1; AL+hErGiwL3566wloqczVbNP/GKT8P9Yg+qU/Inmdb/zUM6yfeTx2EMRWuVv791jkjkkCRDmdBmS8yTWVw==@kvack.org
X-Gm-Message-State: APuU4Z8yVn7KOQFGil1Hlwz+14Yt2owE+wSUzQ2/Uj03ptQo9AL5yWrV
	g0ZiTh9J9Zrr4w4qiguV2GmXzPV6GHA7m/LTOj1Hmp/v2c9kfe6uBVKnFmWCGH1qAvE=
X-Gm-Gg: AYBFou3uza1DnUXRmseHNGKid0heCh7L9onZz9htLgJXsEORWw1osUkjx4l1bhrS3jf
	VfujlvBwzKWjeDp1G9mcP7KSiK05QLtxM82hbJrw1rMfJqVLigt0uZBgLvvmghsQJWLM4TAWun8
	iV5bZpqAlI9e0TddS5kc5RmKEsab9NXZKS92AnJ3KJNBfxnYEcDmcpg7000Q3vNtwRWpI8D7yfz
	E1M8WgDav26Wd63oHQZuIDvjUVwh5u572XMNi4pHLftPB6pJiNkoBeHNwxhyQb36fBV9HFj39pT
	0dupu/zH/bUCrW1aBHoZn/w9PldjtJXhSXKn3EAvKpdAsicE4KkKNBtLQ+bDB1YmoRtyM6Utii2
	0beJiN3cYSeg7MsoNWPEGeueg/e+fy8jGBU4wpSoEaTwYjbrMdex6LasmcOCyTJml5kbu3xhwwA
	NJW1VVmI5mWVfu6N3OB+T//p9ZliNQdKyQby6Xd9z3LutczFJJBofoPKqMUGfonub26THTx24ew
	RdIc2zQGIznM1A+baLIhosV/aO/jQCLOxLSE/U1dI86UKpY1lBCXOaw33Z0EcY0VROe+ryXCiZf
	DRcOg+WxbcEH4KLw28Nwglx6da/bnvJb80MSs5QkHrzhi9EH4Sgcpk9nXlKxKU4jAziymlR0VIz
	Y/iRML2E=
X-Received: by 2002:a05:620a:8086:b0:93f:2938:48ba with SMTP id af79cd13be357-949997ac21amr514417285a.55.1795017080864;
        Wed, 18 Nov 2026 07:51:20 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b454facsm210842185a.5.2026.11.18.07.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:51:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/22] mm: introduce the common-memory node state
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-serial@vger.kernel.org, linux-pm@vger.kernel.org, 
 damon@lists.linux.dev, linux-cxl@vger.kernel.org, akpm@linux-foundation.org, 
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
 skhan@linuxfoundation.org, rdunlap@infradead.org, 
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
 johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, 
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, 
 linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, 
 hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
 sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
 xu.xin@linux.dev, chengming.zhou@linux.dev, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <av2_8Z2sdM_9zUEL@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-4-gourry@gourry.net> <av2_8Z2sdM_9zUEL@MWDK4CY14F>
Date: Wed, 18 Nov 2026 10:51:19 -0500
Message-Id: <179501707902.1206716.2408532904937875068.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: D8798A0008
X-Stat-Signature: zr37r8j96s6q3w7y38uwfxatcdqoun18
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795017081-568131
X-HE-Meta: U2FsdGVkX18QaQTbUuRwTskyV+NNu2r3XxqFV5TzJlyQWK0fUljR89D9FYnIzQ4zUz6H25JVGKa2GucObtzwIG967aao11BjXxWmIpkCMCD1+Y2VAtM5R8f3p2RfVZ26vYmeHGtDcGJli36PCq9NDDe2MA7yyqdKUPPstBFar9vyc7ymmSmQU5MBxfs+/P2L88bzcmrsuxFBttM9ewcZdaATe1hsCCPEhUWh5R00lpFbcidyILhQzU0Po1Lb7qF05+NOg/DUwEBH/1VICFL8iKs+rgi6OSMHNbQPjv/rTTuZEzDaJ1MjmFf+GzwWS6keXadkJma1yB+kSwrbUmLq0CP+XoC9Lm+XlkDwc7PHj/lijvEyHMdnq/QkThSmqwqCcAGFs/QiFAcHHqMckuxJDdl605ZqEuEoRdTqoEXlc7tbzsXjYynwY0WWPV3XYihdvqCGPu0S2YLWKhTDTY7tXhS+seHjeGMxGTXmjVKOynYYEYFNkXMM31PzGI+965cgIF7M+UmUYm2ydP9kNJI1uVdfP/RIJ6zkhKjhRgztI3dlV2oq1LUyL5xGvMSCOTnTzcA7TsOOdm5x3hm7X2x0oIDtUwvF6UOr5OUy2MdqGqQIx5NGke1YCoIrh6vjKFzbP7vs6ZhtF+YSeAkl+0r9cwc5mX77ymQA0hFrQBxa3IYroAQgTjRT+Lz0HO1RFMotRL1wGvvKSmB6GTVQRPupxAVYZULAMeR5SyG4JEY1UgPX9U2tlcZpiGE8K6CymVqbtzaZCtzKL3h0IHFT9kgC5Q2h3AF6B/oRMdUQ28Q4kLXCRaLjO7qXDdjse6jUTPAC1MTYbjZR1NoBhDn2MNn7u6+MQ/upKOCe4Sk4d+PiMyJPub9Cg2el0kxG1aSeVn2CypHoz3zOWE0rllAZtla+0CY1PztfFqr74kcC02pr/qL7TbWBmgqMwr4/TQxIPwUEB9dfok55z/0m83YneAi
 vDrpSQcN
 /fqn/jjQ4K6rDDesMIvB40/7VcsveHlhq3g5PWlYoskTQTYOL83mXvhHrp907mZxUkKRmCyAplSBYXFMgtyYw7hUm6hqZ1Pe7SHeaSwZRJndNzAslubmIgzQgYjqXJtAiaBE5OvfgQBk9LnP4n+o8mos9NcRmBRJqxw0zFxjaC1SjLNEJdeYYfi8ht5kLaB2tmasVr4UDy9N6silMdm1TkJOX5FiL0VCwJ7L5va85wxF2tWiLEEUxpS3Pyiwr4GOq5U9OZYG2dSNSsB8SzpF4RUP2e1qASCLnPyu4UiUS5nmQWKRCTtGitOvhs6T8v2YpXnMqSiRXRgatECQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-18 23:24 +0800, Richard Cheng wrote:
> On Sat, Nov 14, 2026 at 02:09:40AM +0800, Gregory Price (Meta) wrote:
> > N_MEMORY is overloaded with two meanings:
> >   1) a node has memory.
> >   2) a node's memory is reachable via ordinary allocation or
> >      an arbitrary MM service may use that memory.
> > 
> > Allow N_MEMORY to mean #1, and introduce N_MEMORY_COMMON to mean #2.
> > 
> > N_MEMORY_COMMON nodes contain "common memory" capable of being managed
> > arbitrarily by the kernel MM based solely on zone membership. Following
> > commits convert relevant N_MEMORY users to N_MEMORY_COMMON.
> > 
> > Add folio_is_common_memory() and page_is_common_memory() for MM services
> > that walk folios. Following commits convert folio_is_zone_device() and
> > page_is_zone_device() callers accordingly.
> > 
> > Expose the state via `has_common_memory` so userspace can identify
> > the memory available to ordinary allocations and common MM services.
> > 
> > Add has_memory to the docs while we're here.
> > 
> > Every node with memory is common, so N_MEMORY_COMMON equals N_MEMORY
> > and there is no behavioral change.
> >
> 
> This sentense kind of blurred me, you state that N_MEMORY_COMMON is meant
> to isolate the concept of #2 from N_MEMORY, I expect something
> making clear distinction between common memory and private memory ?
> 

Sorry, basically as of this set:
  node_state[N_MEMORY] == node_state[N_MEMORY_COMMON]

Later, we'll introduce N_MEMORY_PRIVATE and the sets become disjoint.

I realize posting this series in isolation was a mistake now, and I am
going to post the entire v6 of private nodes with the reworks you
suggested instead.

-- 
~Gregory


