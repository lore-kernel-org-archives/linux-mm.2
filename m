Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E19F606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 04:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ou5yWqPu
Received: by kanga.kvack.org (Postfix)
	id 5CAB76B00EF; Sun,  1 Nov 2026 23:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B996B05B1; Sun,  1 Nov 2026 23:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A966B05B2; Sun,  1 Nov 2026 23:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21CF66B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:46:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C893120BDF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:46:58 +0000 (UTC)
X-FDA: 85388944116.24.0C2F2A6
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf13.hostedemail.com (Postfix) with ESMTP id 58F1C20009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:46:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ou5yWqPu;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793594816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRumD9wLinzEvAPlvHgnbog+/WM1mG1VlBridWjM71Y=;
	b=LqS3/OouhfERBsu37Jb9r1JJdtJ23EylTcB87tm+b9HwF6IQwt441heK/I0t1BbMSilQfG
	rRlMah8okZHM35gxowP9vFHQc1NgpcksEUHCNjJCL59Bx2yq3eWjHfBH0sXRo3dAUxw24u
	ySBzFl1kZVypPmul6lQPct18ygB2/+c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ou5yWqPu;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793594816;
	b=BBEBMJELJl/X7Eb3iLW4jHAUIk74GP8/4vB0xn/xm4mvlOpEZZlLJo1iKswW2pv8JpwYRg
	d+1utiv8yiGjYvVLa51rIaNnE1SNMojNH+WASzFSdzUGZDYwYNdaC3yZn43I8Mck9ih3O0
	ueGClqDgt+fV8C6vGdm7jeEZ8wgf37I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pRumD9wLinzEvAPlvHgnbog+/WM1mG1VlBridWjM71Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793594814; v=1; x=1794199614;
 b=ou5yWqPuqDPK9MoS2gwOxtV0nJaHNjRepasuddqg99TIMooIrdJvtjgGZKpTZcF/gB3K4dzf
 F83dASp54zTsXmk8of1QtTgg8faFGLmsE3OBvH51el7fLTUHVJbVcULFotuBADSOIQMJ/xS1kDf
 fz+DlXYolSLhCfSHBhCNDdtk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eb600a511e081679;
	Mon, 02 Nov 2026 04:46:53 +0000
X-Mizu-Trace-ID: eb600a511e081679
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 14/47] mm/huge_memory: fix zapping migration entries for device-private THPs
Date: Mon,  2 Nov 2026 12:46:43 +0800
Message-ID: <20261102044643.33636-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-14-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-14-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58F1C20009
X-Stat-Signature: trrenrhrjhkp7nhmrserp8ff9ik6qr7y
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793594816-804400
X-HE-Meta: U2FsdGVkX1/iK940c2Tm1kksOG7dva822YgRgRbiWeOAduWRYLIv92SgBJjprtJf9NgvN5laIoo82eKa1asClXvzYbLll6oiZHuf93hjc87oZtRtlh7j8liBkUicPE7OVYa6n0ujSWn35EGY1W866/6FIbiiZu8Y4cqA47A9+Oo8F6ONrO6Gc9uJk4j4j7ZI+OWYX7UTirLzyexjJAMlqYML2RpJkCxQ52CWtRdwt7CaIulUUZXt7eDAdu/pnSZ655bH86m3YbG4k+vI0F/1L9Qx0R4ggqjneH13JkK5W54/+gKrzeaG+hzXnStDL97oodHS6quCXyKLJ/e6hHiWzS1BW7eGEiHPpQdCmkUBWgYBgUJ82qGHojGOIXumbo9qNCBr33qtNv53ygpNefrfo4gWzWllBK6NXzNknRwl8k5Z2FSc65+rlzUJr7BweplrDakuVQLCVRH7M0VQyEhr1Qxu+gDAwjYkZwM65obG1fR3fFUh3diLTcOZCtlxhYGNvKnkfONFKCGAomvXubi5pTvlRkfli/t82T56IOKCL94KE+oKw1t1BJFC5vh3VDJ4rHQfXUjYWkYzrNqKrFRvykaEORWtd93m+9LNxs+PBnzCxKg/V6oI/qkWBuzrrFr0bqaHZMLmtL6kV2bpJpjOT9OesQKcDf3XTCypH36kwQKTv0Wau1Xd47USzfELRoX6hS+LbdvEJqmqKBlYAdw9pwwtVYfeh+F4YC7UXncTjaUo11xRGWugF535vBNveUk02c0UgKElariQc3KMMMS9AEiMg+I/g7Q39KwJlQf4ctxfUNgl65M2IJA9gk705AgUWLK2qSFw+UZtvzmLF414blT/1Ty8TERcdqvr/dIynQy0sF3CppUt0T+cjlvtVA7XPav74+WDLd3EbTThgy9nc0/jiFhvTFiljs2Cpk5EJ3mzFVWkCBcP88HOSyAuMEPKC74cETLZJk7ET/d+2Rb
 FIxPwytT
 RYZsZy12NZUQedjPk30ROVNIMAwKCihLLXGLf05gvJogN2ZFRZn07/9AZraxAqJ1aSuFDezSx1D3Fj6TPLS+wdDIjNZP0oIsrUuIbOYqbSFV8OUU0CRQtVzETh9gjIbnxNLvuouLhb1KszbdijMl0OUuJ2TCYM67x7Cr73onvXkrwoejB3Ijs7pSklo8Eq7FeSR7TIeTH2MVslyi6sDrS/idURpiPsb7wX1an0y+REErnJcc7JBCbY6ocrwW9Yke8ae5inkT/QmCTapjwndaTYSwYkrqCAYrDZUWD53BJ6eTcTOn3pFEMqKW7mEROesg2vvEVtHBvBDoQ+p/qyoVCr5Ce/0Nu1mGsQ2Hs0tlQ2eb1eyMK+QZYIDo7AhtS+XbN6oTzjG8zf7VNHicuJh7LjQ7zY6zgUGqRlBrdbg9nhFHzXfIbWIeNfl7qEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:39:43AM +0100, David Hildenbrand (Arm) wrote:
>From: Chris Mason <mason@kernel.org>
>
>A PMD migration entry can refer to a device-private folio.
>zap_huge_pmd_folio() checks the folio type instead of the entry type,
>so it treats such a migration entry as a device-private entry.
>
>Installing the migration entry already removed the reverse mapping and
>dropped the mapping reference. Zapping it must not repeat those
>operations. Concurrent MADV_DONTNEED during migration back to system
>memory can trigger this.
>
>Check the PMD entry type using pmd_is_device_private_entry().
>
>Fix generated by an LLM and sent by Chris Mason in private.
>
>Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>[ david: simplify description ]
>Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

