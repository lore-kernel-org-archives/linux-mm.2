Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E464F606A322
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CRvn2SXI
Received: by kanga.kvack.org (Postfix)
	id 160A36B00EF; Sat, 31 Oct 2026 05:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1108D6B05B7; Sat, 31 Oct 2026 05:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1AF26B05B8; Sat, 31 Oct 2026 05:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8B1F6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:25:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C8121C4120
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:25:42 +0000 (UTC)
X-FDA: 85382388924.26.3B6D0FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A1F141C0009
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:25:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CRvn2SXI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793438740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUIuRPOIKD0RvmowTNJE+Km2XYhISf2R7WQ881mWgaQ=;
	b=I3IADY0KDNXCkBQQ8ZTF4ZknkfJ/6LO0BzvVdprxWRZ+ELvvmasFhNi47AxraFsEfDVk8O
	3cLVrwl4UILOkOZTzObIJYPElqttNtldnJffb4NltEsNAhvBV6TdWUoa6iexzDEFJiOXk7
	8K7wUyFoAlZG4xDR5vyBS2+arRYGkNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CRvn2SXI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793438740;
	b=Fj2qyLzPI4u+qWo7P9QumzONi/nEwF4rVE4/1ySNprTO8wDKWk9pO4vXhZ0JhDx3RXN/wA
	2ghYZ4ZEzU4P1TQUuGcd6JDZH2GKa9jzE4W0MB1dKbq1eaDf9c3YEtTIPbjsKjUB+fMlKZ
	ay+0NU+rnxYnmpjVcdPJbB2lvWkpJLM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4001E600D4;
	Sat, 31 Oct 2026 09:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6C11F000C1;
	Sat, 31 Oct 2026 09:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793438739;
	bh=qUIuRPOIKD0RvmowTNJE+Km2XYhISf2R7WQ881mWgaQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CRvn2SXI7LSAaQCvtHB1U9Xi2YoEfX4HM0CDV6J8UQRCqquTSLJknLqW7oudW7gKD
	 Mdt8B0pwfM/jLY0u79ns4uOjyJegOK+ksEa4ymTLnnYTrIAlRemnP6CWijBAhJX/5N
	 So2Qmb8x69nhpotqRWLV6lTiQGPaZl1I0QNUv8luk38OZKTaeJJBZjJdJ27vprgJlM
	 22UCsUpAgxHdtViyO5KQlEnEjMwUxTzo/CQveOd2mM/prwnCtT+mFFGqG927yi1Sp6
	 p05HtIdG5ALB+cqYAjmg8ZfmmsDxy0t461TrZGfsqL45/UWPO3JomEGnKiGfI3+Mi+
	 ezUr8wbVUi8jA==
Message-ID: <a4106ec5-7735-47d3-b94a-a80a17eaad7f@kernel.org>
Date: Sat, 31 Oct 2026 10:25:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] MAINTAINERS: sort entries in MM sections
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Matthew Brost <matthew.brost@intel.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-4-97278f8a5f54@kernel.org>
 <auWqPPYNQlwAOAnm@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auWqPPYNQlwAOAnm@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1F141C0009
X-Stat-Signature: rjprpergwsuhiucycf6ngzonzw6qjre7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793438740-821067
X-HE-Meta: U2FsdGVkX1/uv7NVjar+nhR3fO3QvQJjMurAQg2eOPGko2lv5EE9sKJFLhZhqjr+hhUj/YHOmSHeEG8wq0zmI0vgBTCv90uV6VtBK1oky7zP9LdevhGDaS4tPksIsH87xTLDyi0mn+tUdDVKND/vMee5kYXcaOerTRAb7UDAU9DlQqLiUL27F9UrHwZ9WRr8CpkwkRlQwNRSqV1yjdbzbE6PmzW2pJ7cSRV2wmmyX/Foc+AynH2eBm/ku7jKutiIAWkyxkKuoaqxGdEBrgkVXITAg1l2meOuEUzwHc9ZIN/+r/yBVibe4rRJehZ9AmNJNE/+klxrqE6BJK4D7O4fVi3cskJeeBzH1z4ceBqi51/CgQnbr8h3lBs2ymcVjM2I4tQrLetAkvPn2YAMsjQOcFr1CAxx5B8tVXn6X6Ydhga3O/6oIQQ+4NOii6MJY6Ze4lvyg/rzKI4FLNVAtQP5EuIuY5ZBXHFe8JJlFSgf54w+aIUkpR9J6Rj2BCsdEF71Xv8lCP4u7UWJmezrCN8HVzKGYNkT6Gp6hFfOXAmDqpnAvQXnLu8beWiUOZr5Qg9V+4OidG4CV5ZggERiJWeWZ8Uyi6kfcnVTkzdEukm3Fyllx/tco8jNN3nex1BbYghF+15MkdMCtXVtxV6PkdxnEzurytIIIgHzt7eT8N0DGdtRfxKB1rLoxdDF0JyWYBRWKwynIhgqtYjRrveZuwOzNvwgnBrxdYflgsAM8AQW14EG9oVXr4o0JkiMU5yB/ZKK30F0PDVBbRecJDBmRdkU1n0vXC5n019THZf2dwRRmmQ4eWgOGbifEepFg/sVEaSShKtlJhBJtFbQV40xHtmulDnrn8RFMnyOE2U57q6O0HCKMCFOChF8OtlgZq0fdLSpRyZV5IOUGwog/rLpG8xGv3Qe292TbAPjxJemnX4F5qjmQeVDsOmN6eu1Ipj98f/629f4m57amBixDYXVydy
 8/ytx7G+
 O5OiIW5zThBanKWITwVJAs4qFHhuBM1K/hXrFTAOPzkK86wrsQ2hQblD8in5YY8meuQUORJILcwjWH0MyrRkRxd6AIrQoEXsyWxpNQTyUSSWKXh9k/uUEaAqlemzEmGTq6QP/MUfwPs8Y98DTvQgZd/o+sR1BAeSYwNUPoO9D+c4GF+kY5sZt1OnIvZe8xk8NwZ63KOGifdCTuBx46EwIB+tmfgjt3oT0poaIbSgfOsEUFCZDLAVq10VF9DHzfMfteiBY78B3VZRMilDG71GZSn5VgZkvB5EQbKxyVg19b1Xw53nJybAnJd/mo16j2Fg+KCN3XxLHR0tqhbGHBovKpIY1Ycr4mn8wHVxa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 10:08, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 30, 2026 at 10:34:28PM +0100, David Hildenbrand (Arm) wrote:
>> We try to keep these entries sorted; let's sort the MM related ones.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Oh damn, checkpatch warns for this so I'm surprised these exist, maybe legacy
> stuff?

I think some of that was added recently, maybe people ignored checkpatch ... :)

Thanks!

-- 
Cheers,

David

