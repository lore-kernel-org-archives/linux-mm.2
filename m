Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D7EC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B09F6B0088; Fri, 18 Sep 2026 20:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161FA6B008A; Fri, 18 Sep 2026 20:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051176B0092; Fri, 18 Sep 2026 20:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA85F6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:48:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F14840163
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:48:43 +0000 (UTC)
X-FDA: 85228676526.29.2A076FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E79D40007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:48:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+pS3UQG;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789778921;
	b=n5nc9y51RbMEELugD1T3BovdQff8UH3PCgbmuwzYNa5fMdHUB3SbDG5f7m69A+Ag8LSzMz
	OPOL5wrQTlwnN9PSCHwP1Wdxfb3Uy1U0esss53kjfkm4QBRGAOpF5mQdfsYXbtB7dXXK7y
	8Q/qPwCHcTDHnCdCALJ/qscvk+5c60s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+pS3UQG;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789778921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbvHpq3rRQao+6B+WCd17X6MEA3IqdvdmjyHc+s+Fjk=;
	b=KIFP10S4guuMk8N2MZG0O9qCjq5hBuf8+9zR0fifmdCm9yA8Jje0EI7Qc8ie7TCLA/Cqiq
	YBErBmHnHAHtzDOYHHzi2ofMJE45qBD7OfRyMZQYkkNi8ltb99bGMRGD/FAj/psoxwF3ZF
	4pMVEc4elBjHqBD2zRXBpC/nEkhf4Fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE78143C4E;
	Sat, 19 Sep 2026 00:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2D31F000FF;
	Sat, 19 Sep 2026 00:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789778920;
	bh=ZbvHpq3rRQao+6B+WCd17X6MEA3IqdvdmjyHc+s+Fjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+pS3UQGRU0NBDuFFFnKco6mwe7nk92sCxn80IkjG0FpROgRtIiOvtUSUi/ryt6TV
	 6DRz6tz2R6/HerFUZCnbReYFR6vdpuC75qq12ImULwhtutj8AWHAk1HF4RNKYyA9hD
	 2ea+3q0xWg3swO6+mGxD384Bxx0dNEM/QiPrNdXU5/TGOuUYjEO0v9JGU5t66yQ57k
	 tD5QABx1O47yOULqmje4qs9lUpBoQ2INzfLxTekZNuTP8VeEAOPvB5TrueFUg2qNOn
	 1vN2vIDd5N+8DtM85uRib0QHtyyl/SeQF2lv5Rt2OSrEXo/BM2IbBc82F7u/aHE5Ho
	 bhaHpcyfgnbKw==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/3] MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
Date: Fri, 18 Sep 2026 17:48:32 -0700
Message-ID: <20260919004832.87058-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918-maintainers-mempolicy-v1-1-9a94cac6d135@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E79D40007
X-Rspam-User: 
X-Stat-Signature: 68ut9qaues764ecraeiryt88s1d3dij7
X-HE-Tag: 1789778921-511551
X-HE-Meta: U2FsdGVkX19INF1BZReJdkeMaAI8LNTOTeLfBmkVSjhxXxaIWSnfKj+RektxbXSfd6tTg56b2DoE+i+GTy4qPuAikwmempHV3YXYIcjeGnMsVWwYOcCzNdtNuekUSfVYlR+wuZVPJbCFeitnw6nGpVAHYxu8pNPQLpUixsQ/tACvzgDvyoISnw71ZLGLImbY/i5jC877iDSqzY3eNKOQAc/QddFTw41Y+cqaV87LbNP9FG5D6LqOViJqKY6PJm+UFFJzZpJ/rLo92HJrgXFf+zuOXZL7CzzVKqdsbYdc/iAitGiuzZE5SuC3IBJbjC2ukFwg913rFEHWiI9htLl/huNS31elDKwRADyDh0PkM8OAh415PwLLxKCgk5mcVyIbTNAJJ0U9peCBbIm9977/NRbaoHgFqcOPIwjAx1t2yddJSjkOtNpd7e71Mx+ki1Aszk/zOSYgjCnBquUxeXSKqy73KKXiHsfGSGHzX0waPkGdzCZTIWX7C1Gi5zzam9HFIUq/rzzWeD3qg1bo1jraIe9TbbSk+kAovIi/m/k0m7ofL3WXUhrALqEMgvkvIHlcT8tmpCeDsC1FGOs2+SNSrsKkjcnp0dTAdj9qDDo+N0JF3OS2Yi3mwLjCKEa/7KM14Ru+mCwAMV2lD4aho7SiowRxJ+IjvILNI+lyeLqjYQQP4MG32Pms//TZNvafbllG14tvwgXyQMd1mlU2xeBSr6efKXpu2cTu/k277sRYIZOz1z8h4roRLw1lFPtq7Mn6bHCd8bdEplc/9vUF24SYLYydu4UGWpa+/mOZHiQMpA5SyUPVecQ8H9mVUQ5QhS7LhnFph6NCWOP+h0wSWT3A5IH/y7S2AECONcrLHhmR+StKWpihemYyFNMuOOcP5PTsfXDeFIwS8K5nsZSftErjbBYqSdlSvApPQ4h5z7kSJgQCIHGfEpxS43aPbXmulKFhYOEz8b1rGcfLjRDlOu0
 F1wcbk3l
 wUIToahbWGGxxvU9amHdC1S4kSyFrsNerFVlDRxouuyYh2UEDylPlQsaam9l1CClXkK32kZ3bwasDv9onx37YLJbjd0G2KqRvf1ThKI+7BeJiUKgZ6EvnFSsVsclhLJXb6yZV71jopWB3ntI+30NCKrWrP89f68Vc1yIyVybR+jxRFT7umkdT7Pw0V1WzTKG/FJq7jE35Z145L+m247dhmnuWrrs7CymtP7yeNaAFqus5dsz+J2McMFNVZHlzuHHi3MeZna05/B5oSRqLVFAqWqGBeKS96r9ewsUBHRHAh3vGPwFvkY8DnprDAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 18:34:24 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Let's split it up into MIGRATION and NUMA PLACEMENT. The latter is a
> better fitting description for mempolicy.c.
> 
> Make a best guess about which pieces existing reviewers are interested
> in. Move the split sections to keep alphabetical order.

Makes sense to me.

> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

