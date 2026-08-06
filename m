Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B031C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723526B0098; Thu,  6 Aug 2026 13:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB0F6B0099; Thu,  6 Aug 2026 13:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611F86B009B; Thu,  6 Aug 2026 13:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF006B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:05:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB7B84017C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:05:07 +0000 (UTC)
X-FDA: 85071469854.15.ACB6185
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id F0FA02000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:05:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O87nq0yS;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.216.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786035906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCUoY6bnepNP4266+8oc2addLFvwX3SEU5YCqHIwv2I=;
	b=Y2iXDli8+88d4iY2+w/J/d6y3pLae64iILsQmIHliEpMftzhwShHSg6PIdpb+TBm4sUJuu
	jGx4jwx+G6z1zz4+gFy0uyGA1eFI1bfPejxPv3ce4WLRkx36VB4mKNhzg9fsSTGQB5L3tU
	hmoL7dKN9UVxsdw9Lfz4H2RY9xdY0oM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786035906;
	b=a7sj3hxSMQ31JaNWqQstcim4LVTlfIibFRNLYKqMR1sRKxTdBwUWWCXEktg1OOk1Pebn82
	cZZIIjobpI85SSt8Ekndxi9mebLo4roZmEDWkMpw1hLqYosej3Lh+IRs2TOqpQpe+EYk4F
	J4VxjxdAUmPD1mP7AMtV4D9R5maCLV4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O87nq0yS;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.216.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38f0f132f56so916367a91.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 10:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786035905; x=1786640705; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QCUoY6bnepNP4266+8oc2addLFvwX3SEU5YCqHIwv2I=;
        b=O87nq0ySzk80iPaZJk1l2Xpn+99QRD3dpsUI1DWNaijmKIfX7rheBIXcXJkb6H4Rcy
         HzKgIBbZYNuXh9SkMg/GRR+2HE8yqwJrTLtRCILqbUMqBSQfU3o/Kpcj9S+UBwv46FIw
         wox2gNAZvtzcA9ybLLLfoDWGhtpdsqCwD/3PVNJIUxqpqpiTVdJNkrj86r8jSGvfW4lf
         c3lLcIiqTge7+ehK38W4Fg6bh5jVQgWcUEqZR06I+DTJJdGQSmXeV8Dgk92rAhzDNpLe
         eEFE+X6/Bshp7Rcb+CdDRpHkGKEeFYSdj3KSnxIcjATVklHDOQBI5O8eelQrENuTuKHi
         vxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035905; x=1786640705;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QCUoY6bnepNP4266+8oc2addLFvwX3SEU5YCqHIwv2I=;
        b=RvOpUhVRZzbEh9AbKxY/2S6niq9+qCsVBKmCOwoppk3QsDEGV2GoJPwTi7GYXDU63I
         asOanTIFBwh4OTXjDyyhiykXkCOB4Pif4Or1o9YwrK4Xs9jjEPLIvofDlUR9JrDj3s+t
         KZNzvmK+wU/Y2Oie4PyKBfL8RpxHhnDU4dxKIYK+U0QPUVZLjJuntPhOzt3aJEz8/KwT
         kN5eu9QlZF30vaMsXlL8ttYnOpJyBf6Re/LcSLiUHSYbm1FEXeeDQdFEfd9rYtI6y2Na
         Ez401zO2b6DPQINuQfXV6+KTdCmApdPAccIsu4TaT3DNT+WwrUUXpNCES/kkwbJoHhBQ
         2syg==
X-Gm-Message-State: AOJu0YwazUMVlFB1SDw2dKSxZxXiMz49l7zQfi8Obnj03kNz08chWI85
	4aFF727muuCt8Fyy1Yi6lKqexlBMukgVP/ATzebnQ6+DbrpYrOfYD0HsAQFWGPT6Nhs=
X-Gm-Gg: AR+sD11N4PwBkAh8Oj7im4v2Rvqxj3eag6E/T6QfHlDkEzFc78Q2U3Zz2geQLXK15Tt
	QYSQCl0tCLCCj54z6g5LNzj+Na9HBl5TNkI1YxulBXem8UWOLxbImUMQvVeXGQCF8btTxRv1Y+j
	gn1Y0vOeb8LxCgQxB1lq8k17+Sn7A/OFWPS1S77xIs/ion8ysgS1MYtDlJ4xlB0OCOLkmVWsaHG
	hJtd09whIxVk1dIY0rYy9H3I4b26t8jj4UmlmsZZ4WN8/bIF7kgC0KW73sV0kDqpLQ2SMBLu+7w
	paQulkDWkYMLiv90ZA2ODH7J9HIFTwPXMprcE7HntS7T9PYHn3Ihz/rFWHlkPHG2MyKCwsFsKcA
	zRYFZ/Bin9XYFEAcLzFQ4Rycbh3YZKp3ZGHAz9wr3AULxwSROiRuCDlvVeV25UlnBI2QgEAI/be
	y/4LmzTmuzGt/Y3e36/hTmxxzuuZmX+v5HBTF+ANPzhIVvZFDa4D3fzBgWcVQZ0c37
X-Received: by 2002:a17:90b:224c:b0:38d:eaed:4adb with SMTP id 98e67ed59e1d1-39083b4ef8amr4108525a91.20.1786035904633;
        Thu, 06 Aug 2026 10:05:04 -0700 (PDT)
Received: from fedora ([2607:fb91:201f:cebc:3a68:390a:144e:1b87])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca50acddsm27805225c88.3.2026.08.06.10.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:05:04 -0700 (PDT)
Date: Thu, 6 Aug 2026 12:05:00 -0500
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, damon@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org,
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in
 damon_get_folio()
Message-ID: <anS-vK1MaC8sWoMK@fedora>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-2-gourry@gourry.net>
 <anSOKjTerc97fCGx@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anSOKjTerc97fCGx@lucifer>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0FA02000A
X-Rspam-User: 
X-Stat-Signature: nthsmconpg5a7cnizzu95qidr6g6buer
X-HE-Tag: 1786035905-188206
X-HE-Meta: U2FsdGVkX1+3g1amOHm0XN0t1DdYaDDa7G346UvyB8eStP88HVTYB1rfIorM2gH6gAVQNuesHuFvIU8w64pE8D96MdTGZMqYPGCQhDIwuf00D7m35SdTg47n2WSQq9iepgdicaY+ud5yPrUvcsK2rIZN+UIORjBPsc9jxr6QbkjFBXOGgOP1WUN9F8Qs2/LHBFmMl964XqEPou52fb8PG4U89o2TadYhepu70JbzZqM4PuRI0sAg7Hnx5zxBJ//RLp5BosWGHM5tZNScCiWI7e0DjlUQN6Q0jrorY3koGX4zVYJb6JB0VnGU6Ac3L0HRHO+jeKTI+Ga8iwMKB9QL/D+TKnyWjESMBe0UgDj1V3LBtAx6YcmqcL6tKtxm0Vjsn0WqKtALj2pmTtxDR4u8tmNPKvMQQGl2mbVoYbQTPPQQZZY65GoBndJ3eE/gQoaUCTjGCD/boj8bHMRz4s5FI4Db/TWm2EodcHTQxD64JVp+lycvB2dc5uigQ6ewgJjMgz7zdz6uACVJKi+iMMmSqCca4v11t+dhIM3qoT3RU0A7AG7/IWpKFAoho7r4rswi6UwlPpIK7hkb4Jduyhr555z89Fi/skfWVT4wCZmjfJiw1NCPzBwJhQhq2kZnkGLy8kUz69x5b0fKc9eEGz32X9bYmLAA3j/xnRqFP5D7AT0QMHEDSlPEgG1c58T0PtL7udkn1IOWFHUNVpMPumvI5rgMPVqdMRcgVDwz9CMUfMocqXuwImvytZDAlWQn69ubFR+VL7dabBrLwsWnzisM15/sY572+iHI4gYtfB6yyPudRDOqsixoieRdJVe26FtUwHXyjJwVbTMGbfUmu1NoVf50E3gsRMSuPBoCSwVhtmlmjlu1fNusujrMqgGVu/BbXVBtrUgNRAqBMsyzsVJwS4TS64BY+l0efKQXswLDdWYpIYJIf6aeVjAuveG1dpKRGRSVFZuL0AizDI92jUQ
 vrYyQ4qv
 3vdNfdRX9QgNmD8NDvoa7INO4R2ktbg8um/Vx+/wLeCNm5tHW8KM6X0c7f2QYn2vudsB0i4JAjAt0O4mNymkkpsqmzzj6oDUIj17DWjq3Lqkec4c03G4Vd1EcOEjXqsUuSnQJ9AT59E017UX0vJjJOOewIJ23beOcBm9koLjzim6oWSmdL02OfUSKYDsJx3HgyO9YmfNtPu7waVzA4hrg5yrD8MjoG5UUG/vONJ9j9pnfor50IFE68qlLDzes7CLRwgawAKzEA/I6MPpnsGXXmQwD+QUc1CGoy29ERCsm7sK4Ds07yBQjmbaifay3OlorjHubv6dw7RmTq2Fzq6U6ANJd4UR3SVfs2y7uY7NsUug+2/aClVsB/vkCgD+FnweGX1zxn6PpDQaxqnV0I+pDjklS0CcDI7/G+nzBE2jeg0uE3MzFKOb4mpLR1oz4GiVxLii0gApjcmllvmot9jjKSzZ1dolA13HZxZ9ykWuMDPhdhUNFNFzuZPqxuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 02:37:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Jul 28, 2026 at 03:47:11PM -0400, Gregory Price wrote:
> > All DAMON physical- and virtual-address operations obtain their folios
> > through damon_get_folio(). That helper already excludes ZONE_DEVICE
> > memory implicitly via pfn_to_online_page() and folio_test_lru(), but
> > this is inconsistent with other callers in mm/ which test explicitly.
> >
> > Add an explicit folio_is_zone_device() rejection in damon_get_folio()
> > so the guarantee lives in one place and covers every caller uniformly,
> > consistent with other mm walkers that reject zone device folios.
> >
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> Thanks, nice to make it explicit!
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

SJ Asked me to drop it, so I most likely will, but yeah - this exact
patch is a good example of how many footguns zone device gives us.

~Gregory

