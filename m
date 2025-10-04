Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F4CCCAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 07:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489958E0009; Sat,  4 Oct 2025 03:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460AD8E0002; Sat,  4 Oct 2025 03:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D788E0009; Sat,  4 Oct 2025 03:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 289B38E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:53:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B39E011B1AE
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 07:53:38 +0000 (UTC)
X-FDA: 83959667316.28.4ADFE70
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id C8E3D40005
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 07:53:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flW9PA12;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759564417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDTyBoj3HBSA29dmJDmDIgHpDLm4JM2AxR+uo2SbpRk=;
	b=KbkLzmi1v+aKjeUT8CyPNhscWgrSz9y2WVTzFl6DeaGkjFQrSMuVxUsQXV+9crhuOl38SO
	RcrS+FT5BydJ57PCsI9uxYs30eyAcaTB/wwd0Km5SnGv+LBXIpAHASGAW4rzp+r5qK+gxG
	mXpkP+QaX9VUQi91Bzx8rv0BOYLom78=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flW9PA12;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759564417; a=rsa-sha256;
	cv=none;
	b=p100USAkxwRHq5XPeTAmELB32HVdhPTnzO7gHtkiGz/a5wAwvyZ0cuW1jB/mMeitePep7t
	mikdWV2vtlEyHF7QwZjyHGFEPv7yu4xrLQCOW56kBO0UvlN9cy+ovg3JPHzcOie/vvQPLj
	RWVcwOCDXJhxxmcc5jG0906UKqSokNI=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759564414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NDTyBoj3HBSA29dmJDmDIgHpDLm4JM2AxR+uo2SbpRk=;
	b=flW9PA122rsaj8FCZ9sSzQKvuXWZQVLiZauUjpuUCygfNzABUsAVa10ye93ZH0tw57+hpv
	xWNYfhmqMMGheekpHg879UxdbD7LGSKB38VU2q7a/6BdPLpX/gq3ktgN3m2nAp2UYeT+xW
	xQ1v2uIWXKVRUn6m+qOxo9l1GokicuE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v4 4/4] mm: thp: reparent the split queue during memcg
 offline
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
Date: Sat, 4 Oct 2025 15:52:46 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@redhat.com,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com,
 npache@redhat.com,
 ryan.roberts@arm.com,
 dev.jain@arm.com,
 baohua@kernel.org,
 lance.yang@linux.dev,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <F929DFAE-4A4F-41CE-8FFC-A62520FFD7CC@linux.dev>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8E3D40005
X-Stat-Signature: 1eezzcu73myggik8dasitfjoh68awt6s
X-HE-Tag: 1759564416-562891
X-HE-Meta: U2FsdGVkX1+bZxqGFwSyvFt3aEFfDEd/kNCjMbjoeXSB6x0Ibs+u2OTB3/4+E9weFtiMm/sLd+E0oaASKtPQXUz7Qkw3s1XrsEIn5BYgSbi+Le1SRktM1Cs5XTHydEV97I1JaA2ar1okwKL1gatFuAlc0fMFkNWA5Ev71zt84UlGPgL7MFb/WVKfkdYM0KOVviP1qREBNT6xA8LKGR12rg2VMuU7wrJAnJRNQ3sGMcn5rIuyJLCkh/L/cYKO8Q7Zo4bs8O+Rg4clPzoKVEAOfh7HAkuZUXFaPmXMSaWl2EMXBCvxHpRrtFqqnF5SDb8+6JSZrd2mQ4iH3V7o2Kvh1G23nXStuFztDyrf40Gb2NHl0kEAOI5zGBCPEVPUq8jDynFTMQmQa6HD4JVheTH7Y000FY1ZxSRw1WDlfAV/TOKR/OT1EGqIBKOsbWKaJhgO73jZtbwWgxidZytcFiD+N+fgE1WRL/h/8ZbT4AWOXwo7s2dBjUCqGWBz+gErHeRVAY3/nK64ZZqnxxb4Z0Tw/0xbsQjh1HjF14+p0qyivDq3ihaowQl2QnEggyQ2BSkMqDL4hftLyZZ43VJ99buwe0xtf21a3TvdhH3VeV3YbEF/I9foX1ODNTT32OdaQ+b6QAv0gv6djxiDebENpayLVrcJfkl1R3fkYAQqb4CMBSgpatqhfpCisYJNbsZUgQKcP7liGVP2EVUOZ6dr9WxBYKBdpA+RV+TX5JtJFovq8RMjHrVoxOt6h2oHjsFidNoxkMjDNh5IK6Myq8fCKoSIbXNb58XcgsF8ljdhKy6FlXHbdFlOXXjcR/SX63Vmh0/8owYP3XlUF4t5qSIDQTRMVWoAg3+4pcV/jrahgaX1VHXi+cEPlCLKJhDjojEVb0xkhV0YSuIm63Tqaqh1Fy549tLF7BrhUS2VNLPLK2y0QG8bF/HY4aLLL037ycMlASLjkef6mFeFjuoV/p4ANl/
 7MX+Hvmp
 Z0vejdewI9Thx8daqFgVpq2gb6jpM+A7SG8GJ6n5LoUsEgIjgGewNfPljT78do8TuFyAcNABAj86CxCpe9zNysSD3VZGRK520VHNczH8vCccblrPIwwnd0FYHiKiPeVUdDHV2z06BtaJRc8wyrDVeTiJEuXbq0tL4XbIpTPrDFB/pPYp42ZLsFdTpFZKjCroUtMivG2mfJwlzcYzvqi3rhU5OIl3aU1CvAUgvc1dsMP6vQ+VppQdyrwBdRNAVv/NXNUme8KnOBEZ6hqxvNZ37mHIY5WWa3Gx4s2tcxLumaoDIpsQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 4, 2025, at 00:53, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Similar to list_lru, the split queue is relatively independent and does
> not need to be reparented along with objcg and LRU folios (holding
> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
> to reparent the split queue separately when memcg is offine.
> 
> This is also a preparation for reparenting LRU folios.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


