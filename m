Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C43C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 012676B00A2; Tue, 15 Sep 2026 22:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DF96B00A3; Tue, 15 Sep 2026 22:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23D86B00A4; Tue, 15 Sep 2026 22:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B27F16B00A2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:37:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2ED1C16057F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:37:57 +0000 (UTC)
X-FDA: 85218065394.20.6E8486D
Received: from mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id 354F040009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:37:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y9fTzTLh;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789526274;
	b=zwuILVxBvVf2F6KGH5CMq1nYC5FpWoGBTorCDTr5k8SBS8p+kQVwXVb11phhmIcvtJcwhi
	j8qJnbn8bJldwUkOEFmoChk63Cko3+kd7ceHTdgJ5C/m9j62Igqi98nFIc9vkP6dotEIOA
	TKSF07uXQ3y8KlXfPKUURtzaMylpRZU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y9fTzTLh;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789526274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGhvPY+WLYT9sw2kgekfLrhc2cuealpWSKiSXrbXvGM=;
	b=nyusyu2nPinybEkXdXlxuKfy79PZdv39nBpQwyW7kXG+zblC+cTV6SYNq0Mk3iR3rKg/po
	n3TWMqUJht3YJ4CKkY7KShf717U+1EqhplM+QvRB6I/yn5rM9lBl9Rw9j3HONAaxmDiOki
	vuVmWSwg4MxyR6ROke7EWLgZQWSWFt8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RqoHRKP5MPir8EDPZ+oY2qrhh/YX3EBSGht0Wmlx5f4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526273; v=1; x=1790131073;
 b=Y9fTzTLhvec9hD6ccIhf87gOxiPLA4GCPk59TBh/vFMFzjN9N30MRia/R1egeRa/3jL91h/c
 a3xu3cIsIjeLTLTH3j+L1phrjuCAOL9DNcvzkpgHd8QPV2PV6vTROIyCvBUO31X9zYz/dS5KmrM
 Sv/wwKsELmyO4Y0Dt13DUzr4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 0076e13c0c48a507;
	Wed, 16 Sep 2026 02:37:52 +0000
X-Mizu-Trace-ID: 0076e13c0c48a507
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 11/11] mm: memcontrol: constify the zswap and socket
 pressure helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-11-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:37:30 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1BA7E514-82AC-416F-A795-9D12152BDE87@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-11-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 354F040009
X-Stat-Signature: pyqxppx3kbzcniz3dm7yr6dyoi7t4int
X-Rspam-User: 
X-HE-Tag: 1789526274-103460
X-HE-Meta: U2FsdGVkX188fO7n6qO/rs4+JJG2BVwLUhG0S5XYFJWZuIihPpeg0fv6VLz1Md6DCnDzDSBmiFwFJ08ItBgqQnEXPgGAUx/AmeSnF1tsp4LGlb56723m3hA2fTL8BUySFIx6e/cOvBiR4MpiENMJIvbT/Z+Bqm3hbAmd/xbZlL/EoweyoE8xUpNUPzDd3oKl/UbOuMPin+e9axxBF8n37ythEDSWjgkLlnMuWOEQjXHveVcqvyBAYW61IugVnr7tyNI7M5aMoUl08ugWfmOrz2de2wbtZGznA7hvbifAnA7v8SJXbptp26sUhYKKmPzDPMKRr6fDAE2gkIRvKdKKbDyfDQyxuLQ8+mektiXaZ4u0WfOa0LQI5sBv8IahYiz1pyz/Nget/+WhjyjlIILnYQ1Q9n96b7HHaDSmG+eOwVgKdQ4zWExz7XhS9PZTqh4fAkjX2k4Ju8GrEpdKiadzGgf3NM6VaPARgHetm3cL36N051leMT3Wa/q5J8pg61e2tdmmP6cY9N5j1+IZ+oQbVLn334YrDckjXmF31n0ZxuMTWI8YWkpFUIIBJrD1PyPfOOzk9p7cZjtAwf3othD3vXKuomCqnFBX4L/Gr0RraVrvmNgDv9uxcOa9pT+xXqDUJN+c6BG5lhKKOYiMUnfUdRbfjsN4bgEhKDoHHo+Hs1i6yfAe2cEfG7Qj95E6IhcQNdfQBiJFvyDrJyP1KQsmLDm9FvNnv8IrSJad4areyRufn/rSyC+QfWTV0dtc2cJYxQ1cu272MOynpC2+ZBspL4HB9/ELEi9nrQ4KQUXIAXwBvpgUYDkEXAZdcitQv8ihRKI+PSw4j/xxmgZxeuH+nabDm4dN3xxiqOSSCNecW2kFHwSs02DBe3YhUsxcO4/OKzw0FU0WFQy2qEM7br4bSXhJtHfEvBpWCP9n0nb5+Mp1qkTdHCTVoZFMNW/4tm2GItQS7WvbA7VFuc8tlPN
 6/zpxl1L
 wXRN+VDoQ/K6nwt21tSUws5HnvXd2+Gvt3rBGYL7tNzLBQk+7joRRmsgJI56tvJgPi5Cku26cPwLVFwmwFFvmuq+/b+Btto9PbsbhxpG8mAaXFc6z02p4pmP7JT29tqntJfq2m5TQoZCFirog12z+2WNelWO0ma3RIoL7uqkl/vI9nGTBR+G8Cx6o/AeKoRxNW3d7obc3lOc9lky0OhCBDfbi8WX9wSsvnEU0AIYSp/IcLgZWyzDd2IK01pSrWJDf5Crr9OrHt6RTbcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback
> flags, and mem_cgroup_get_socket_pressure() only reads the socket
> pressure timestamp. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


