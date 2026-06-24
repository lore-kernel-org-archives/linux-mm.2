Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BB5CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CDE6B0099; Wed, 24 Jun 2026 10:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE41C6B00AF; Wed, 24 Jun 2026 10:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBF66B00B0; Wed, 24 Jun 2026 10:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACAD6B0099
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:24:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83B711403B8
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:24:39 +0000 (UTC)
X-FDA: 84915027078.14.F4DFB38
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 93C5D1A000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:24:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hqaAM2oz;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782311077;
	b=fkdRTQ/5WmD4yRSyCZ0UySihsJzffqIkUEbMEQ4IlejknxbKaELXvhXIrGJ0RU5XYmkFZm
	YeZUxG5Ck4ZdfH+ZJsGiOA1RhMWqZ9TAw0a7451Fummdp22GLhorlkdjnCrsD3Gto3OWma
	cr6vCLf06x4TEwlDypazAovJ7734RCw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bC7GeOhZGz0je76Vr4XAaqeVuPBssFAF57vnDxsL79M=;
	b=IFBLGYJJhE1YNsQyfIlJNfTq7bXJxBHJdPKmpde4ylGUr+dodEysZoa99usCENFucVtI8G
	tK3SUxlGsDujGpAowWMGWpLquQHMFpSYQQHQB9Jq/ZZzB5893wbyAyZ6z9NCpi6d3taCXq
	fOhh9+kPqTSRoVkJEguRK5bZ9YjyFuc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hqaAM2oz;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-37c867bd3e0so718277a91.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782311076; x=1782915876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bC7GeOhZGz0je76Vr4XAaqeVuPBssFAF57vnDxsL79M=;
        b=hqaAM2ozEbBdVOcaHO9do266Dl3WHFa9jYNB8ILMRqLThHjODhUkRSd3WDJ7e4V247
         2QtQhTUAx9Dq3PMa95WJc5vP0O4l6hwXHfuOeJgDjuxfPGloA7x1S98hlDXXkH/nXJX5
         E9S6mfAM9MMG3OdbJtc/tez/YN6jHnAKK7t30K3pM30Wy64g05TPiFYgijC2yglQSJ8J
         gsqcK+n0zRA/Vqk5UpXjPWjthkN3EFbfPhtdqP32dX7ctImTfIpZblfq/ZAudqjIs+Gm
         IGfY8AayiEQpoX6s7VhjkG+ozNtUESG+T1aIdPmSOmcZFiJjU0Zioq5+6n8cg7mfPW71
         Sq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782311076; x=1782915876;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bC7GeOhZGz0je76Vr4XAaqeVuPBssFAF57vnDxsL79M=;
        b=fX6FNJZN7bF3YD4i+bSNbvLr3p9+ZhJuqI2bW9kb5b5qWUIjOFz1LFSmEtfPPf3Wiy
         1ZurcDaPLIfa4FyoaRHBAqj1Qblu4AUuHW2+zePKYboVLMozF5+nAZKf929PXhjbEt6Z
         75mk8A0cWXjE5ZNG2mhXLdtEcOxrRtgHbLjWCTI9EqMAI3FT77eE0A3hv07MVZixKqb3
         dQ7d0ivJeY55xr4mawN9rntb9oLzO3L4iHC2fbcuq5PI4/4GD3HRtADvsw/Zki+N8rdo
         svGd/EKyneMGkj6luXK4gigiu0WplKbq+FzAKI8+hGxqMPX3v532a/ccd/0I7kac9xNn
         qv5A==
X-Forwarded-Encrypted: i=1; AHgh+Rqqmholemt7V38ERFGEnNy2Ry9m/aN1G2Mw31ITlAbk4b8lNNxqQR3VK5sYUpANBbaGEvP/DfMNkA==@kvack.org
X-Gm-Message-State: AOJu0YzRFp/fvnrDpHdIOZBMPYorXZDcTZAxY+6asLfzyglAMUnTE9xx
	XnGQyxy5yDxkDD9rxObCbEqOTGIp6LaUWikvD+BpsHsOENACNQz5olDq
X-Gm-Gg: AfdE7clNO1V670wnZPcIkQhJA30BNJ0digq5B6APf2gSmOtle0/VdNbVcnfmsfx85ii
	fu+NSpJ2wPMJGRwZafxA9LQJnyDw9km0bxrTEe/dhaEiqZraR5Quqns6hyGj4ZDu4+/tssOx+Sx
	N4S+bGd1QTvXWl/lX1kiGY0xtTUkaFa/aVR/AZfK8ORQ71ikGnCL9plnFUg3wCbvtH6JICJIjn+
	1gNafGEdzfsv/iXyP0MdYZ/J4jzpOCTlXmNdTJy5AdMRyayfyXQRf1bAnh6oMnH9aV0J1EZHjFk
	z7aytdiLORxHnDlYZcWtBP+Rbin82P9wcXkcv6LKpJISWewfG0QSSnqZCPPJ8NUQDRobwPodqDG
	PKRHQ8walMRQUgW2uPVbtuUMqXGSJCCc7If/OERUD7PCLCCefx+CaUDOwWWHDybi3/hUVc0FBU4
	fn4dXB/OVenvULVq0=
X-Received: by 2002:a17:903:1d0:b0:2bf:3309:ecce with SMTP id d9443c01a7336-2c7e15804acmr39177245ad.28.1782311076310;
        Wed, 24 Jun 2026 07:24:36 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7439f86aesm135035155ad.49.2026.06.24.07.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:24:35 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>, willy@infradead.org
Cc: dipiets@amazon.it, abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.com, David Hildenbrand (Arm) <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <20260624080639.17100-1-dipiets@amazon.it>
Date: Wed, 24 Jun 2026 17:51:18 +0530
Message-ID: <o6h0w2m9.ritesh.list@gmail.com>
References: <20260527162412.19922-1-dipiets@amazon.it> <20260624080639.17100-1-dipiets@amazon.it>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 93C5D1A000D
X-Stat-Signature: jtjfmiggeja9rx94ixhcg7jo4ydg9z6a
X-HE-Tag: 1782311077-290715
X-HE-Meta: U2FsdGVkX1/i4yU1GpDih3qzdGGPYsFnpBQK2B2rXb6+ASCRW2oc0BhMLfdaSlopK1RwDML32fGvmTFie8A8JrOCfsirkwzE2eNAX7N+pxDIF/yDhS2W3yLNJgNg5khW8L56biGosRCQyquzGELi45DEHm8bRblSs2KbT1eZVWAwWii5+6jMtVDRm8AccwsRlRRhrH6PUZsYyBDIB1zT9SY+P6bjLjMLznuveyQumoosr78Cu9D/J94AttawzSPHncq5LXZ0OWUw7ReBOrn9hajavj6a46DOmVn0Td7PtpTQLVGCWcPGflinRyGCDmyk+FTBmn+x47B7stO3Q8df/2jpP+jeG7ah+6zq/KuLrAfBWiK15re1cCii/S+M/K+kXcCwSTMuervCZxNjj3g1zoVoED0vzIFHQcaPikUPOGl8BEnJ6tKcT3zu4BJI4sVHiqWtkjvPoyIInOczhy0z1R+93MbN5G1dBcJ5cFmPLjtZtcIdxjBX+13ciH/Rw2kYqh3txLD6/Zka/tTJuHXHF89AAK2dkIXWdv3tiyx3V2Ouqpx46Zb/GlxJik4185vYamMVw2glh+58A7RlxH+d/PnbU8huElZvc0CzLPCGdbyZHjzIkJzYZAPBtflewqOKXGkV1fG+GC73WWlAOKqHQNwv+qlDBOUFCq6K1+jy4HYIx+97qRtU8V4ONtxCaHl5m+9Vtjr6QAbg6sVQaxV9fNJbNj6fxbN7h8rzxU/8cJBAfx1wDH8rIPTG2qsjg9SI7qIJgifybeg1eBqKjNlnCy7De2JOeKn1PlSfMAa7fhK2BuOSgupw7ezlIbR4b2Itw6DzhnF/f3JBCYObs/nhK5bdfQhoYcveQXUPYX+SrZz3MCrtb/6/7fdmF1dbk57byPqeEpg+QwB1FLYKUpmLzr6nrM2zcCTTJYlNsOIcfXeSVZuTizrl8o7vhxYbqe0nd9r9wrbyLsET/FG1ZkV
 ZBwYc80q
 MMX2RhorLfaog81rzhcAgut+s1RhmFPLpxH2dN1p3oiNZmgCXntPqMQyn1oywxczy4drK7goKQ4V+ndumk7wBi5hs+Q2ef01LwJ8L3ymZkDTJH9PgIudu5saqyOKpykWk+fYhlf55v6UnkH1ZiYaZNAj9RZo/lrgXAimfaTpHXQYBK2ISB6uvMqjB+Na4BOo9gx5GawsuZE+NhPqfZGAgpa+9swcHNIhPS5QVpuLPLbWkWbBZwAXXQhr8vXcTVNiBV1YslY+Wy6f/OE6bGkg0ooAXtySgT27QgfQwFUBiQOFRsDMWU5oCTqewp0CAeJLahH4UUBBtDMx44l4VADhbuNYqv1bSZRbHwiKnZkwhyU9uTNM0XJ5VV47eOwrNFYqG/SRzLVTAjUgkngXZq6WW7Hn50k/oU3aN9Uuvzd5tipKciQTvSyDsxjIicszLolm8Jpgj5XVUanJ2nP5aoHoQppMgv0uSGu/i8Mi/MsOGIRqvT4idx3UOIZ9UmZ8CvzX79NnNchGQw3XxHD5JccJ5AxYfg8G3pzUCYjHzLvbI0tLir+D3RQ3Mhd1PhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Salvatore Dipietro <dipiets@amazon.it> writes:

> Hi Ritesh, Matthew,
>
> I wanted to kindly follow up on my summary from May 27th regarding the best path 
> forward for this patch.
>

Hi Salvatore,

Sorry about the delay. I did bring this topic up in one of our internal
ext4 community calls. And to share some context, MM community thinks we
need a better long term fix for this problem rather than patching call
sites and/or playing tricks like - 

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..f2343c26dd63 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order > min_order)
-				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
+			if (order > min_order) {
+				alloc_gfp |= __GFP_NOWARN;
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
+				else
+					alloc_gfp |= __GFP_NORETRY;
+			}

Unfortunately most of the folks might be missing free cycles
to work on this problem right now :( - Hence the delay in addressing
this..


However - I would like to bring this problem to other MM community
members as well who might have an interest in this space. Can we look
into the proposed solutions from Salvatore and suggest the next steps
please? 

Maybe if someone can share what is MM community looking  for here - I
guess that will be a good start. Looking into the table I think
Salvatore had also shared a diff for kicking kcompactd in the background
[2].

[2]: https://lore.kernel.org/all/20260506123326.17293-1-dipiets@amazon.it/

(Sorry I still have few other things on my plate before I start look
into this more actively. But let's hear from others, who have better
knowledge than me on this.)

> To recap, we benchmarked all proposed variations and shared the results:
>
> | Patch                          | Change Location        | Avg TPS    | % vs Baseline |
> |--------------------------------|------------------------|------------|:-------------:|
> | Baseline (no patch)            | —                      | 101,979.75 |       —       |
> | v1 (original, iomap caller)    | fs/iomap/buffered-io.c | 141,194.20 |    +38.45%    |
> | Ritesh's suggestion            | mm/filemap.c           | 139,200.61 |    +36.50%    |
> | Matthew's suggestion           | mm/filemap.c           | 143,863.82 |    +41.07%    |
> | kcompactd background           | mm/page_alloc.c        | 134,278.47 |    +31.67%    |
>


-ritesh


