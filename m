Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC46C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F516B008A; Thu,  3 Sep 2026 02:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F9C6B0092; Thu,  3 Sep 2026 02:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6ECE6B008C; Thu,  3 Sep 2026 02:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85C496B00C2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:36:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B091A4390
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:36:20 +0000 (UTC)
X-FDA: 85171491720.07.831EAE0
Received: from mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7190AC0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:36:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BDPYwWUG;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788417378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AOQl8uMLb7yaSSuMA/y+PSrYIOL2fdOT9lQ+lxwGTs=;
	b=axInRGGtoFcO45+xgRMh4ByWOFReVBPLvW2jpsInQKzmRkZcDI6b3WBtNU13GJDW3z2p95
	kdzJgBb6+R4T5UGWopQsnhc9IJxQdkFH0MkvJ2Ppo5WWwo5apGmN0hVwZOjx+0vLjNRkbh
	6eVzjUsnGMeeGzTmsbNDQ78uDY8uDrs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788417378;
	b=uQpOwio2mdBjAxnSm4+uRGh2+1poxPek2i1FNtGCcFoTLklun9+1pifnSpoinvr4Vzpr5d
	/D0sPOvRpB8bNYbSZLL7K2ISOXzKOoAKYuuRb5qYAN14mfkVJ8fT7QDDZC9KgjbqAPHCFf
	r0Bwb08EoTDaYxlDgtl1BZK6KE9Y+tI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BDPYwWUG;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/7zVF87+vSIaxGdnTGi6zl+USr7Ew+xcjHfJdu2PHXQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788417371; v=1; x=1789022171;
 b=BDPYwWUG2Z6bRep3T0VLBuuKDahOxIhearwYCB9Uw1og7GYuVlylNKYFuk9DYYcpN79wzQxv
 Jzj5HFC8/TpHPwL4N387Usg237Go+wsjMcy9922gksnD2685r3sFTvRolNcm0p8lyA42w1yhfCR
 2I4StrsLfzGRP/Q1GsSuYBDA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8473698cd31aeb55;
	Thu, 03 Sep 2026 06:36:11 +0000
X-Mizu-Trace-ID: 8473698cd31aeb55
X-Migadu-Flow: FLOW_OUT
Message-ID: <3775da0f-4068-4fc4-97a7-135eb975ec65@linux.dev>
Date: Thu, 3 Sep 2026 14:36:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] mm/sparse-vmemmap: prepare DAX vmemmap population
 for section orders
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
 <20260831075342.57563-5-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260831075342.57563-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: szyf44kwpxrticiq481a434eq5qpjdzd
X-Rspamd-Queue-Id: 7190AC0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788417376-662519
X-HE-Meta: U2FsdGVkX184fRWEC5/QFNms9n2TIKFDWBJlykXrMKeS2nJqEOeMwTFLDud2EI8R+ipdcfX9G5mzpg+w3hSP2Wd4st7cG/nqt4t6DXiWKqREPfaO5NZyqEavIIKmLEkjbBaxZVw5Hcjh7swNlb1Sz5awM4FsJkueIgnkK24wjTp3QaOWAGfGJX/8iA9KhNBsh1LuZFRi7Yysfp1snl1xdemYUctZzhlDKy1ijm5ww6uEV0SJbmoMSMigK1Y0P29DHHcP5HTokJ220NiK82WoT21hHYb4Zne33+6ppZ7I5r535yZX9qF22M9O2DuhLrbRkUmUiwqKqji/OdmSQ9VCq/ENVeS07Shx2IBTvdh3Npee+EKAWu+Gl4JNKIA/T64Uw5byzXvumuNlvrNefPgynlWaT0txYwTGFbTz61FxibhymjtVpBCT+nPuLxLI6geiPjtGdCwDdPLDC3Z8C/Ly19E9+b3cEcCFieZOMj2LFR1cyKoPdzBKxlNOKCbEPOVRetxqLQ9OIWTXtnw3avpadelqZfbwPstVJszupT/t+g/u6OA9J5/q0y/aRtsMM/mhEvVjFrgxSvCFZtP8s9VvY90/Un2PH7L2ODsn+a7fVNEXLzecGHzBkgn7Q6xbhIkAdgq+x3VTTkgvvR9R3w0ofj+fd51iwl6pTwMcaLOTDCD2B7Tea3ieV/oWmLSMNx6sjnnCiyYaTGvaTeFIWNZjGOclDvKCxLsHufNeWtCp0g7RrzqlcMmWrIe77sghAo/7bwgK3LAkfLOow33fkfyW4xaDHR55q5E39swnOjBTVdJI+y1obR4h1wy+YHlGM0l07zGb/d6x8bRqGRXLCyocDd8wHH4K7MviLwt7AZsZC6M5dDVi8kxkLdenLuZnpUluB4sFSnukLoNlpjajsEjqKOqNF1Ur8GviucSVcW2qD0ogIW5zE2HZ5Go9hJ62//tE9N/Sb3Leki7KB1FA0bS
 SORL14Iq
 MSXTrl9lnUo+7nbVUACHTsvkDoSFwctPqwn46dLGx6r4gAu8OunURvneAtUoM/wij5StIZYL00CqLUSESQFEkzbJror0jv2ePJ7eMNB+gKGJQ4TcjDf5xYl/bStH2UrvNdnaxkGJylx4qUoRfEmrieYe9GvzRTWGe1v40Y85LASq1fGnCiJX0Wy/jc4EOITIqvV6IQTa+KJpuJQC2k14qchTVnOvYyL0PuL8ZoHv/RsMgnhHvNmAah55Hd36VW2DO38EuM4F6fxH/F1GMYIY4zW0Sh27eZ5cGODDqiMqZG9gvYsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 3:53 PM, Muchun Song wrote:
> Device DAX still uses vmemmap_populate_compound_pages() to populate its
> compound-page vmemmap mappings. That helper allocates the head and first
> tail vmemmap pages explicitly, then reuses the first tail page for the
> remaining tail page mappings.
> 
> Device DAX is being moved to the section-based vmemmap optimization
> infrastructure, but it cannot switch to the generic section-based
> population path yet. Once a later patch records the DAX compound-page
> geometry in the section order, DAX head and first-tail PFNs can look
> optimizable to the generic helpers as well.
> 
> Add a DAX-specific population flag for this transition. It keeps DAX
> head/first-tail allocations on the normal vmemmap allocation path, while
> preserving the existing page reference for reused DAX tail mappings.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/sparse-vmemmap.c | 27 +++++++++++++++------------
>   1 file changed, 15 insertions(+), 12 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


