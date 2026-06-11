Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B632CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92EE06B0005; Thu, 11 Jun 2026 09:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF596B0088; Thu, 11 Jun 2026 09:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F51B6B008C; Thu, 11 Jun 2026 09:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3446B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:49:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 176A54069C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:49:42 +0000 (UTC)
X-FDA: 84867764604.14.E2E18D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5829F4000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:49:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IkKy257r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781185780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEvuJlQ7/byK5XxsbYYwUbRy15W0fhVCxzo1M/PBXMQ=;
	b=Lr2FxaaXZ7oXsvjNhI3PfTO/3gYJYrXBkefHWQ1uT4OGmoLFTtFkQBXrWiwMQsmmliy90x
	IKGxCFzXVBSUgY2XaPksWpCxh2hU/U3Ighy5mpkufWAoxDCPHYe7TxjFbFTL+PhOTC4ETe
	0dmUxtjuLhw2FnnViSwsa2bTJbPk7y8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IkKy257r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781185780;
	b=wuE11hI49lPxRorpTuGLqTlGcQ0QWoFtB/hFS/u9FnDlpx6WuWhuTM2qMJxDjFuRazwwYw
	HLG+ifrvP4GCt2R/CwOVpyU1OTGTBUblSihWyTuqR2vt3HByzK06UFmJxEhGHiiJl1PcpD
	5lkKZeXuLqbjwWidN85/VKPj+eOziVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22CC14330D;
	Thu, 11 Jun 2026 13:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C96F1F00899;
	Thu, 11 Jun 2026 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781185779;
	bh=TEvuJlQ7/byK5XxsbYYwUbRy15W0fhVCxzo1M/PBXMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IkKy257r9V3Y4dqrKhFosnHxl/O+VSLLwvZhs9NCu0ZnacHR2U0oyhquj+b8cv0Nb
	 pN963rM/ZsmLuBz25lQwn8W1cFTDW0tXfOgaHa7kzli1wOKRvnvNCTh96COOtxiXG0
	 3cHIpfTPwZCXaGVmAXBlmKSVqWZKNJ+FnGPA8/EUc7c9DTeY1SkK5Egf+aFYwJZPDS
	 Y2wsSrp1m/yOhR2z6j30HHuV4uSZ8zCMZj+zsUrE4l/i0LsP22XJYCJhreCnA3Myx9
	 jCs6fnM1yjp/CY0nf2hAOEmqV6H2FiVq6Xlj3SRfbUDZAvLQzvu4SwkSNqlp9mBl+N
	 TFFJU68m2/qxQ==
Date: Thu, 11 Jun 2026 15:49:31 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Peter Zijlstra <peterz@infradead.org>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: drop pte_clear_not_present_full()
Message-ID: <aiq86-eKAeDi-CQd@localhost.localdomain>
References: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
 <20260611-clear_not_present_full_ptes-v1-2-49865fc82629@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611-clear_not_present_full_ptes-v1-2-49865fc82629@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5829F4000F
X-Stat-Signature: je57xfjsrn1sy19p8o8z91s7iu73stbx
X-HE-Tag: 1781185780-544192
X-HE-Meta: U2FsdGVkX18qHQ/t+XqyET8J19rpvCpA2an3uWwMp1F6KEHFi0SF+hhmUckQnoaSp0zi9y4TMUZNlBb+qhLyRV9Z0Nh1eVU8TRaNmTZxIq57oLdSexKe8Xi4YxcdMQNDCkbkhoWA3uqgDXHPsW0ofSXCJzdd5NX/948I+h1Cgp2ofqdR3puKteG2+QhoxKUwlU6SDnBFhiK5ij5FrhlgYspCGrdhh8CPgta9RbiH1BzIdQ73SB9JnwlEEHzRW7cmcbHDRIvHrRJwY5i0UNkTHUEEselv82iRka7QK2RQbqDX3jLlfJqj7PGtYmEmxB5fy84cQTeIuJraGuCIAUknPsrmdeWNcjOrsGZ5bENA4T5lh+QSkGgs/5ahyeXTiv+FxgB+4BDsjCYJRTTrTaxQL6yLf52P+FLT9zWYRtiv5Dy9Ui3Ln1osYSbzExrybA3bYzO5slZ3t08B8womWKs7M1JfNpqRtH4tb/25QLPhkp1s8+463SyRrbKtA6s+lT+z2gaRp+UFZuaC1LNtMbI3IwLhLptfxRrTWAJthL1XSS75LACReWiBpL1Ovm4EuGCPEwLJu8t2k42exVWbI8AEEIY8lihqgUF/SuXmLYaAlyNf99E31O3OQrJAxfvXdyMd6JILBxWBu2QAPjFozfWQkQYv/Zw4vKlbS/LUvz4kgPbI/DVP5xAOoi7rVVfuIuLahuyQOtSWppcSn0nabv/rtSyCxxzRwRrCWEq5pOkSeuo8ekZCSRM5BIrMghXbTSm0ViQ5JlvhKpc+lGW6pk5Kx4HFAMvXQVz9Ofbg8Rm8iMavqjrmWmPCEei0jN6f6jpdqfEHBPEX/UHT1Dsf7amokihQJxbqi+d/Pg3Pic0bCoCuk+TFUQuPIMrW0tY+Kvgf2dptV2vUClBAM6sszSMzSe2fi+ofV+W9wAlUwefF7TrfSX2LoGq7k4Bs01Y7dV5nc0s5k6OKWIZBPKwYv3N
 1K+GvlUL
 p7pK37kIvkWIP1ibvy6CE1QaZqiqzKqg4PvjOieRm/huXitbH6HLZasNr19h0DMFlBjrBPHCwi+lUQSE3mT/BTvodeR3mGRsuruYhBwPysRwszaFlwVo0mgHNLqnBZGreSeVo3w91oBOr9HPfaMMUPM0MmKdPt43jGJ3P+fiGJMUarUh49lDbFLdqWRKy+f9XCjIQKEy0mGTH0QVjA7REYyV6e0D4wdS3Jo1fVnM6Vd+Ne30AMVTvqj1zL9fxuWjFjXfh5srtPnls6+CNem2CuQQfcvYEhMbV57kb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 01:50:48PM +0200, David Hildenbrand (Arm) wrote:
> In general, there is no good reason to do anything special when clearing
> non-present PTEs.
> 
> In theory, HW that does have to invalidate TLBs for non-present PTEs could
> benefit from a "full" parameter, but fortunately

That would be on arches like arm64 where it can cache non-present
entries, right?
Then, we could signal a global invalidation instead of doing per page.

> pte_clear_not_present_full() is not wired up anymore ... and there would
> have to be something very convincing for us to care about that to re-add
> it.
> 
> So, let's just use pte_clear() directly now.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

