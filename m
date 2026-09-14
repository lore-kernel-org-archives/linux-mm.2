Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561A6C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97CD36B0088; Sun, 13 Sep 2026 22:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D396B008C; Sun, 13 Sep 2026 22:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842F46B0092; Sun, 13 Sep 2026 22:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 541D66B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:59:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38CBCA6413
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:58:59 +0000 (UTC)
X-FDA: 85210860798.15.9CBC2FD
Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 04E1580002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:58:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=guKGNCR+;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.45 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789354737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6LDlhn5Lgt8+MtzJeFqyKgkKsCcUJigr/H7kjOAP1U=;
	b=ipUby24+c5KVle2PnAf6EAmxNCzbOfAV/eaBay0oNe9dykRthZjnbMWJgias3lLqR+zF5E
	lCN+F13nvOj2YtWaAM27EM8pVUuIKKhIb68gdoZrvKSVxSmwxsHGOo7hTu1ebDEPloqvQC
	h3CFWH7hzgHU220POilkURYhc4A6RBE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789354737;
	b=fAuzxx4qmr/agt6abxQrZpCB/tjdQEZe6JNob9qQyG1Vwi0e2yhPPzkZ984QB124ge9bz9
	g9dP3boFM1I4/S69Clb5oebLSLlr47bZ+/06Lx/OBX4zQbUPXyCTjpdJsukFQytV986KlV
	uHhf7AUROwhIoenJ21CSitNMPjWtPcg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=guKGNCR+;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.45 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=A7yAUSnBd7HoeH98LBMwrZlDpQbhvJ6foXDoX076yJI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789354735; v=1; x=1789959535;
 b=guKGNCR+9qot8zKtwaMYdeeCEc1Pnviyq3uQCGNnxwQ8BmeF0G8ITGLl8kMdkAjAauor8A2B
 kaWQWIA4PlmS9E5/dhKoDJ7pyihtjtMPM3jSzGi5vj7aDEdoaOqsxTSOkx0+IQHixfFXAwap++F
 oBf0AbOQzGhpd4/6QDSa1qWs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 01a63c164231c3d2;
	Mon, 14 Sep 2026 02:58:55 +0000
X-Mizu-Trace-ID: 01a63c164231c3d2
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v4 05/16] mm/hugetlb: use direct assignment instead of
 folio_change_private()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com>
Date: Mon, 14 Sep 2026 10:58:35 +0800
Cc: David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>
Content-Transfer-Encoding: 7bit
Message-Id: <68F8CEE5-2DAD-44D1-A1FF-A3BC985EF2A8@linux.dev>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: k18i4e3mn39cnxzey6537a993aop7kw5
X-Rspam-User: 
X-Rspamd-Queue-Id: 04E1580002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789354736-657650
X-HE-Meta: U2FsdGVkX1+tk/D56oJW787Vn19MNVDpxBx2lTp7ELRMdL5k1PYchAEHTYng6b35LVavIrZP2SkWar+HMqSv/yhUUJRpXbwSBYdOzYCpkTm6bdKp7iZGma/MrRHoG4R3UwFbewaJedYZHD09UWRFErRnjoH1FGCk7kC2wBRB/oQM0NAlMvgzLtQU3/yAoTlHL41dp2del3IvHw4PIdqmoT5IgQouZGsU7xMHz62wR03z3tH0X3sJViXMbRv4m4ygm1Xy9dZ0oxUjkRREoR0t4y1yMMlscVBQNxysFmxC97JALUermCrlHuthouh3SFgkZQfVKMq5OJ8cgaC8aTeerU9mzXubV+r26HwrLTXqV3RcNdevx/SBIpweQOX8UvLo0b3VhkYzab32fYz7eADZT6Fohj578Ejdi/69AXGgJ8D8EB1S4atk0zKspKngPuo46qKZUOxrsq6SoMPzd7oX2HlUamci5dMgzLZQ8o3RLM25dCt8rtkemytjSkN5SFbL/bcu5LBzpZ4ssSRk6LT4xnGMdbwBxEdFaHtI5Px6xwbvFsHR5lZTzuLaWVuSyxFFWPi5MK4r8waLF4wxcpc8dtTk1ObfoIoxu+P0ZNCcN7tdsAZ9sWcq+FMMYg+cfmdu1RgQwr2XiPhN7NgomCAO5obWC0WWwWl6sJJ5sNcyiaFv2ndITVOG/KzN4spljPxsJimKVYTGyit3QtiwZKkespe/F2HBOPsL7kz/G3BaJ4euOH8DuXgkwUMk7RskC6cJynPb1f8hVAgqTBCoh2rl9F0jrGROUr7gHcp65UWYzJ54wTMXfqqi2UP4XcqXCbFZ6MQAdzBHAFhIHhqyqfGvS5lc+Ri+4UbIpeQOnfp4ezNV+PbTML0lW/ZPu6OZCsN06KoRP1ujBPV8EXxY6MgaYPv0PafuL/VDa7hNRvykzZtcK2LCK+Ivg4PjKpGo+182BBplIQnvr0jQKd0yIke
 rfYwiqM7
 Zd93LQOOQ0d0bTix+MVqA375uaDJRKRGcu26mgx32Pwiu8CL9Ddb4WnYzP66dz5+0cu4L+UWXIZO4VyHJm9o9FqaCDMrN2Wlkxcx26WSAF4ZWpw3mo4H8Mey3GLpHoSETYT3ae5eybAHPB+FSeX7c3yT7yw5wTK5TezLgegGwXOwWs+7wcxlw1xhX0ZddnLhspaMMe1yK8/S8wUGwEzI5kpjezVZgj8IvWfNOvQuNanbCWY9f0lii4xuMr0sjKlXocspUlImbdVFc/jmwe9aLw0GHoRXHdLpKLXblW6cz2882gJT471ChtTHBQy+p9Yd75yszVbZOmtxMH6kSk6Fpw+Lu/3nPv1G/JAoBSh6oXBe3QqN8eXcr4jPLpHYq8NoFoCPA8IaezWNa0s6H0F+2LviVZJgXbMvnlotPRghD//OAUJUtmR9Jh9ca7ICQmlGFDoP22XSMwfXxLKnGc81BzRUfElxyiJPVxM0SaZRNyQcupCkmpL9QTpiiNbF8UIUrfbc3+vk2vMhQMUrH3+xCnAqzm5nk6V4IvjcRmkv90d/PYGk05yUzbL0bMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 14, 2026, at 10:24, Zi Yan <ziy@nvidia.com> wrote:
> 
> folio_change_private() should be used along with folio_attach_private() and
> folio_detach_private(), where adding and remove ->private content requires
> folio refcount change. add_hugetlb_folio() simply sets folio->private to
> NULL without refcount manipulation. Change it to direct assignment to avoid
> semantic confusion.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Muchun Song <muchun.song@linux.dev>
> To: Oscar Salvador <osalvador@suse.de>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks


