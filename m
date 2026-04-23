Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E78FDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDBE6B0088; Thu, 23 Apr 2026 19:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FFE6B008A; Thu, 23 Apr 2026 19:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793936B008C; Thu, 23 Apr 2026 19:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 648D16B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:46:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B920C2255
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:46:17 +0000 (UTC)
X-FDA: 84691456794.02.0E02FF4
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7EB9518000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:46:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AMML6Q+v;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776987975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCkvae6g7ai7pPQ78mGryOJeSvrBW2xtP+VRuCL0vXo=;
	b=RdY5e3AYv3LgKWc6H4rZXyluA9GuFatgR7eDDPhuqi7RFzyNCSX2xASYEfORLmeUms2LRg
	K3Hy+k2bgAfiuNI0vGF7HEowujntOG1hBdzwRPY/MIt/NALjDNmpU1xuzVvDFNQLMJN8It
	zmR3/PdQ+/NcJYcScckPJS4k0d67uUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776987975; a=rsa-sha256;
	cv=none;
	b=FOa0hHkSHyiHOtEVndGeRT1BjVMP6e47SSjOXURmryqcSUoOwmSC7E0vqVxVbtdruzkDvp
	Phsf1gE86yICJiGiPLVBb/ljm0b921oTlN2j+yOt4zwYzmvBSNPdHElhbmMC+XYX+ugCR9
	/mr/yDWnkTGrDmRceTaNF1eMC+8+wL4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AMML6Q+v;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 23 Apr 2026 16:46:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776987971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tCkvae6g7ai7pPQ78mGryOJeSvrBW2xtP+VRuCL0vXo=;
	b=AMML6Q+v7d0G4tjIWrU1IVM5E5jAz1aUtmfSGSBpjfHhUdCdlkPV5tCAN1pAq2I+o0IPd3
	bXJuyJa9AAKi0GrCY1L32eNput9CWUwjLqJeg0vKjjSa7jQqGXgeiD7AdN2mZ9MrOg0gjM
	IXKuPgukR3Kwf29XrIoxJy3mrJTiARs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, mhocko@suse.com, willy@infradead.org, 
	hannes@cmpxchg.org, riel@surriel.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
Message-ID: <aequK2ZM3O_7NM1M@linux.dev>
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
 <CAGsJ_4ygEvptQy662tTiPm-k+E4cbfvUKGGg3w7NaaALO-F4ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ygEvptQy662tTiPm-k+E4cbfvUKGGg3w7NaaALO-F4ig@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tgosc5wsjybuyrns51bf44i9ef61ybuh
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EB9518000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1776987973-68495
X-HE-Meta: U2FsdGVkX19Y8844pNkdxCpODB3ZfKCuRCGEqtSE+CpRfsS+JBBvkvNigNfkqjk0h1tFu2pBrFo2o3etGwSGciI4Ca7tg5vlUSpIupePQjREDf+IgjCxdqNpsOIHsepDoiqtBEKHqarVlkivtxCNR+ZOL9VKh1d1rhZSchmTbPKyvpCMC0kW1UGiRoHTvOQeVS+zTagxeKmNED+JWDJct6LcS4fZKbsihO1atN4hU7HuVKzoVm5pGcng/HJ/TWZ/k2MPhk122w8LA20xRp10tL2AiRbzghu0CU7A3rMeldVjaQ0gogJ9NchWDd/ZvaDI9k6peAnwTxhxlcbUrkkSC1G1FpA8z5eJ+l2NwvRlW9ETm5JHW3rheaJpnoNJ8n+6KH8liTvo2CuuJMLaoTVThQsyujOUHyChqW7arRbl2/Sbim4LMuY2jQ/+Odsg3XZpjcmmpOm151R/VHHZIWeXE1XGpyoX0XpSOETQ1Ljdk8m+T8UIg+y3gMg+CgcNLXJUUnQbBydVzVH/bSCCRN7LbQlVu/uGHHWtn9ELqqPFHCF4uKYpiyjxEHP8hPj2aepQkEMlqhRKLKVsyQ9pdgVjbruErJbGtlhS2gD72y7OYOCt9o/DTdmsbno90E2xtCMht5wUZV0CGUs5egAhMk3g2Tu2D4HjQVD+pffHnuA/IE5xWk8mfl+EuBErbg7zgzJIr7uFs43Gvwugc5ZNuQkIkUlnbdMzKxKqV3Xu/CTsipFkTk9UlGvyhKJgfqehPLcpg1UJcVoHIXEDELCRXCmtpmjR8zurBsE0N+qb/obhfm4PEiQRfmF1n/SXJ3HWm6QfVzF2P3e+Kl1FzJoW0folfXja/QkB/1bSCms99dz+y+KDY9nqwz7ivOhKbasG4oROFrlf08OQWTND4O4ecxAgZ7BKu0bRbPlsAD3mmoLm9IcaiDtn0qm8pgDBmyhCwU3Zu8KH/p6n60NOxobRKc/
 EY47km9J
 YW5EhHZD2V21OR0eAf4DpJLYNlYq5vyvikm/srfRZWSKahfSRqk+9UlmixYO06YLjU+amqMwgzKHrxWS6yj3OcG1Se/DwysIQ5gKzycp4ChxWE2puYYytGlLyGCvwMxxMez0yoMd/u7GfRynLvApRq9bhMFWIcsBHego7Kl86ceMTUmxlEumQ63LGPmiIhpOoXhazAVKRzCOzWNgQNY8MqzPnZgWZGrmvE9RECUdmL2e1BK93+QO6vcs8EHPJr35WNnUCg+lbOYh8RpkQ1q/ZcnfHSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 07:22:30AM +0800, Barry Song wrote:
> On Fri, Apr 24, 2026 at 12:43 AM JP Kobryn (Meta) <jp.kobryn@linux.dev> wrote:
> >
> > Of all observable lruvec lock contention in our fleet, we find that ~24%
> > occurs when dead folios are present in lru_add batches at drain time. This
> > is wasteful in the sense that the folio is added to the LRU just to be
> > immediately removed via folios_put_refs(), incurring two unnecessary lock
> > acquisitions.
> >
> > Eliminate this overhead by preemptively cleaning up dead folios before they
> > make it into the LRU. Use folio_ref_freeze() to filter folios whose only
> > remaining refcount is the batch ref. When dead folios are found, move them
> > off the add batch and onto a temporary batch to be freed.
> >
> > During A/B testing on one of our prod instagram workloads (high-frequency
> > short-lived requests), the patch intercepted almost all dead folios before
> > they entered the LRU. Data collected using the mm_lru_insertion tracepoint
> > shows the effectiveness of the patch:
> >
> > Per-host LRU add averages at 95% CPU load
> > (60 hosts each side, 3 x 60s intervals)
> >
> >             dead folios/min  total folios/min   dead %
> > unpatched:        1,297,785        19,341,986  6.7097%
> > patched:                 14        19,039,996  0.0001%
> >
> > Within this workload, we save ~2.6M lock acquisitions per minute per host
> > as a result.
> >
> > System-wide memory stats improved on the patched side also at 95% CPU load:
> >  - direct reclaim scanning reduced 7%
> >  - allocation stalls reduced 5.2%
> >  - compaction stalls reduced 12.3%
> >  - page frees reduced 4.9%
> >
> > No regressions were observed in requests served per second or request tail
> > latency (p99). Both metrics showed directional improvement at higher CPU
> > utilization (comparing 85% to 95%).
> >
> > Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> 
> Hi JP,
> I’m seeing a large number of "BAD page" bugs.
> Not sure if it’s related, but reverting this patch
> seems to fix the issue.
> 
> [ 2869.365978] BUG: Bad page state in process uname  pfn:3a5417
> [ 2869.365981] page: refcount:0 mapcount:0 mapping:0000000000000000
> index:0x724884c20 pfn:0x3a5417
> [ 2869.365983] flags:
> 0x17ffffc0020908(uptodate|active|owner_2|swapbacked|node=0|zone=2|lastcpupid=0x1fffff)

Hi Barry, are you using MGLRU? It seems like MGLRU set active flag in
folio_add_lru().

JP, we need to clean active flag but let's check what else can be set before
folio_add_lru().

