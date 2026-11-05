Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44837606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 02:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=G2aJXLUF
Received: by kanga.kvack.org (Postfix)
	id 1FEAA6B05B0; Wed,  4 Nov 2026 21:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5D76B05B3; Wed,  4 Nov 2026 21:20:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5C66B05B4; Wed,  4 Nov 2026 21:20:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3FFD6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:20:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C8E21208BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:20:24 +0000 (UTC)
X-FDA: 85399461168.14.92E64B7
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf06.hostedemail.com (Postfix) with ESMTP id F36C2180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:20:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=G2aJXLUF;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793845221;
	b=h3RO4Sjv++Qtub6qEs2L5vDPfE+FRV3IGIydk6T2+4jTATEFsC5Zs5bptDo/Ii8F2SRq3l
	SkFbhIDUW/JlNotwNe7iLBzOP+Nxp978UTO2C60PZ43VN749u3dOzq28oHGtmZjbt5DnLI
	11H0bJ/lLELUhirk5MihVp9B438UKmE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=G2aJXLUF;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793845221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXVr8YhrKV9VcyijQjizzwZyWuJ1oTxmJiKYv/ulIec=;
	b=X8HkpNawBXqfCIhCl0ZdXxydairIdb2i9Qak8KysjzNrWCiu7lBwYVZExIVP12MpyXKWtv
	UPTYM4SwlqAly2qXgEN1gcXigRWYh9rWG6qU5d3LX4LCf7mqvawH0BI0vNyWk1CUiQ4tkN
	3q9UGIjfv3VH+qOeBcYcd4iIXN0nuWs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QXVr8YhrKV9VcyijQjizzwZyWuJ1oTxmJiKYv/ulIec=;
	b=G2aJXLUF5S0BrDAXyM02zD5jsRtUpHg+yrWNK0+biluxAozaa5+RsVZDl9lntB2rZ7SZ6d7F+
	nsr8haXbtymLbFSi9NlX//LllLRTuenIYtgOBZ/onSvDI1QpKsVahubkP76vkgs7CcuyoNdHU65
	eUez7muOL1YeHouX2J8iZhc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jKmHJ0F8vz12LHX;
	Thu,  5 Nov 2026 10:20:12 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id C04E74057D;
	Thu,  5 Nov 2026 10:20:10 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 5 Nov 2026 10:20:07 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH] mm: split out memory-failure declarations from internal.h
To: Breno Leitao <leitao@debian.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Xu Xin <xu.xin@linux.dev>, Chengming Zhou
	<chengming.zhou@linux.dev>, Oscar Salvador <osalvador@suse.de>, Johannes
 Weiner <hannes@cmpxchg.org>, Brendan Jackman <brendan.jackman@linux.dev>, Zi
 Yan <ziy@nvidia.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
	<harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang
	<lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
	<baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
Message-ID: <b74ed30f-3c01-b41e-1963-d37d40078191@huawei.com>
Date: Thu, 5 Nov 2026 10:20:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F36C2180002
X-Stat-Signature: icfor36z4bjj6ap3gif5kqg4hguwnun5
X-Rspam-User: 
X-HE-Tag: 1793845219-34913
X-HE-Meta: U2FsdGVkX1+w7Iq3Hp8qhtScbq5+8y1i+1hmRvprvWgJMnqWF23N3bID3o6U3+j4Nt4wFDtF/VuD9p30ZDBmi+UaxGD6WymG+xODuOa42hYUCmFkfNZt5fHHtUww4XuL5+jkQqnnU+w0Xqmvc9Soap0YYq8hZFMyHUpiSmZvf1kBilVcDszBG/woDKWB/QWmpadvqsYekVPRuMlvH60L63yw8pic5Y/ZUGyXTg1fcW56LLg3+9zq5eiodQaqUBHriEBMz0w19dQhF8tE3wB+S6JlfALSj/UT0T62EP7AY4ZT0qTYeQW435hXrFJtkf5av5O7Qf1YMizOGliULGZI2s/3WEzezns8zIxSp1/dkDCHG67JFhyiDbXUgHgCcU3ivtgH4LJkqquK+GQUfwBTClwpyUvBhK57S9Ww+01LRoRr9saHpaCyuoAMNHNFQv11DK1SoXAOYY/VoN6PgM7qAU1ykZmmGg4eA1qp49tS3t7dhTmfv7Y3uuoamlwhhdbzMzDkIlaM1VHbOWnQKs/Vm8bDTmt60CejlpCoPQTbXt+mU4VctsuIYipmu3IuJ2/gfDKybumoGHjsthPJGhYFLMv7lFn01FCOjDNUWqpzUIk6+EWByBatN4vV3iNuM9Yi7QJXxYdgIt/EtpQNsUSO49OycX/RKFNekGVmXBkst0wMnOgzzPEaxgVOuAD7Ah78R7wg7VXsJJ0skSfld/pIYhxcCONke6QiccfI3TePsk/H6EyUMrXf5wmoqPcH+AiU0ELqg3gtAy2Csxqd0VlNqNhv44d3AZRHRlubd+DWPfExosn/CjITHGy9NlpRnxhiJ2aedO3/RBwu7yS2Z7aEK6iLWfAJJ7QRi4fhcNsh9e+/1YUfJamb92fXvmQgaP52L1ZFYNOf/RoNcXpZezPjV/iV8W2v7R2WEqGHMFNBqOep07IqwDiN8DoCnyipxVCVxbFDaKZGn4OYS+DeGuh
 9x4jcF3y
 8avXl482GNxZOqmEmRl+tB5BJ7Pc21TRQS6n/mG6Rt2u8Q1sr7QfU8XO5szrtgG2h8f8VsXVN8J69/LlhA+0yBzjfzGIiB37yx8VgszJ4KzrTEDtOz8T7Riu9U3AuhSPe/BX5tGDyU+lForo7HO0k75bifTxi8naSzCNjlq+0tamIfZwPLaLC67EzFFqann6wmHMt4aiJNL2Xl8kGs6RR8RO4jA0tOj+tfFW1Q8qAfJaKHleIZgmx4YhWkZXOE7UA6dDYDPtcO58j7RIL+nZrAK/DqawjlGi9qWqLBV5FsNt5e2E+QjBFTlS8hRHDM2AvO6mul7NHMZi5vblOo0v1pq7WMebrfTj9AmiafD7l2oCUsyoPoNbRG1QE8zdMtVU6fL6w3eg1LF7+q4JN/NvRKdqq/pCnMlOcKlbfVu+BexCKSao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/5 0:45, Breno Leitao wrote:
> mm/internal.h carries the memory failure declarations, but only seven
> of the 81 .c files that include it use them.
> 
> Move memory failure declarations to a new mm/memory-failure.h and
> include that from those seven files that need them.
> 
> Move the block as is, including take_page_off_buddy(),
> put_page_back_buddy() and page_mapped_in_vma(): they live in
> page_alloc.c and page_vma_mapped.c, but are built only for
> CONFIG_MEMORY_FAILURE and called only from memory-failure.c.
> 
> Keep the declarations private to mm/.
> 
> No functional change.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/aumt-4kfGGtoXuh-@kernel.org/
> Signed-off-by: Breno Leitao <leitao@debian.org>

LGTM. Thanks for your patch.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

