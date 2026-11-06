Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB26606A33C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KAWBuUlx
Received: by kanga.kvack.org (Postfix)
	id 2A67B6B05B0; Thu,  5 Nov 2026 22:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284416B05B5; Thu,  5 Nov 2026 22:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193E46B05BC; Thu,  5 Nov 2026 22:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B93A06B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:07:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B979808C4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:07:14 +0000 (UTC)
X-FDA: 85403207988.07.87F9A5E
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC5DF180007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:07:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KAWBuUlx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793934432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXgX6YT79AGr1K7ShQq3fwkxtbfvOW0IMluVrnbsxsc=;
	b=fuBw/PWe6LtBymWj+lW8pT9Dd+z08JN4p1IfKRcp6KscGIEqXnt86El5Cuyfe4CIq0ng3s
	LP+pdnj+o7TFWS1Y1ZBJT4yjecveBrAkzDo0KHVDOdLgPvxiNRIkgkZPj1toIAwMKnU09Y
	YJB6XCadOmq6kzY38S6rqqkkgala2/k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KAWBuUlx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793934432;
	b=aUSFM9NdKlHh0gkDQjPAkFgAFl2WJnwIbLgDHWaQQeS+yx8yAPoL78Kki6BpklIJcVMDe3
	JkdyBfewJRvCxysYeZDzFYzfp1gfJ4W8PcLzTxUIZ9oF2ot5pcWJ5RFkdyLcalxEKOVxZo
	hqrqvXQFyOK2YD+8X0Yt2gIzR8e1FI4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793934429; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oXgX6YT79AGr1K7ShQq3fwkxtbfvOW0IMluVrnbsxsc=;
	b=KAWBuUlxzpfbTJJQjPuLahCoAqm/WHy9rWUpNeO1w3ZJlvvmHlAIbV3jQEJ9gXyKK96TKNaFw1CKYsFoyE6MA0ituZP1LFkKjwgZXKEl2254eZIqTLSezWUa5W4AmplYxOarvbCmbquaMZBvYM0waKOnjABKbzZKScmOMHdXSRE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=88;SR=0;TI=SMTPD_---0XEA9F.D_1793934422;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEA9F.D_1793934422 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 11:07:04 +0800
Message-ID: <6c954456-44b2-414d-9905-ff4116bf4f48@linux.alibaba.com>
Date: Fri, 6 Nov 2026 11:07:02 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/13] mm: convert THP VMA flag tests to use vma_flags_t
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>,
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
 David Rientjes <rientjes@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, John Johansen
 <john.johansen@canonical.com>, Georgia Garcia
 <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, damon@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC5DF180007
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: edbbieiqzx4phyknpuox9eupsy6uuwwo
X-HE-Tag: 1793934431-515223
X-HE-Meta: U2FsdGVkX184EMMBYirU+TbYtjgbLjYq61nJXipuNPA8JsVkMUeNJWmn5mz84wYwtmhceBkFHZIWYN+eDhrP58KF4hCih30e6aOK/ojzuUnkvpwSl8ar9veQF312hKlVI+hUtTkJ8s2Pih2ZnqkvDOPOes794JE83iVVBfKJlDmnycSIEsr72/vtELRRRfeWVtSSg2OjC99atbT2ahMcZNvxVCIMtiobzkZPTI7E82UDPpp0er8O/byqWkYIGTTaArlk8UIzTGdrm9QL73Gm9dz5AYAhytVTCjw7xyZrJdiM0tgSuEJkH/GhsNXHiCThnVNut3yls96TgbOseCPRJd5dWDc2rwWaN/7yOchrRo5jO3/39Pkp/pkD13PEu3Sl0LZHruv4zadakGrbdVtustE7gn8SVyycU95tV88UObYbdnC7NEKE6zGq0Iw+XkOQ1rTc/YCNrttofkdkmdII/hnGUHo9f3dsO0VgmuK+ZmdTt+fEc41aw5/jdkAhiat264inK27VsR+dYBaoDGo9mITYozZK8OLmVtdBi/W4lYFu5ALXS9nba+ZYTwrBy//jTKTl57QeLYoJe6IpzAfnS/pCiEjDNCBwJ0xFmkYRzSArlxKkSRmWsp0kqTaZ8OjX3Um6Iqgo8LBcv8CKPk/tgZUGtPnHSNY7Hn5iqU/9G7fY3cyH0pvmDxt6+HB9HEX+lTfdat2B+mLUbrgQlQVE5fJKLxusqx+6q7fWcY0MCt0Zvp+49XC9ge5tl44MMm851+dAYb6vMU1bnWfhLloxHhEO+VHzd1mTxS5W7eyeGTtAxMz5CB8vJfEB7ovllrXTLLqSTNct8zsvUz4cVxZ8cr4DtBARGMCTHaZ3v3aR24Ya9JIm7+XOLpjhL/jQQRhHk/Z2YAZT5CCsg7VFKYaUQvdGuZI/lnzCIHs5Too8RXLsbp2IkG972MuUCWtJZshEG6JpCfPCwe8LwlMAZms
 5kMNIp16
 j9YZIJt+qm1pU1mARdYBr7yA3KId5svE8VL7ScYzgG8ulGA/IwPbn49BRYDmy8tN5bfZLTd4Rv72YASlim4nSIbtqVZvhJMPpAvUMOt344R8079g9hZDFlx3FdwkjnJwtirhC0m6od59w1y3gAwdmttFjQumWkGTuXB1Un9hS2SxSaNYKjNIZzPgyO8HeWtoDXQEGJWyTCRE1eriWkpMZISYqiaurJRk0kZAdQ/LBVYulcMW6+ZmGzuoLqmnCdnUoe75+6Jr8o5N4LeiRwdl4LxcDVF9hTEJgqbnyRpfCXtQI/7bOLNR0TFITbNSB44jNfs/RQ9yQOU93InuYasohA2UowRxW29p0LTNy+AgjyUAHMmWFOWil/4X8oOH4NZDOraOtsUv1hzLZWVFFA64avHrpczYoLcvpUkBO/iFyUAH7cW75YQVKFag2mTD7CjYJfuew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 5:30 AM, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values where
> VMA flags are tested directly in the THP and khugepaged logic.
> 
> The thp_vma_allowable_orders() family of functions, hugepage_madvise() and
> khugepaged_enter_vma() continue to take legacy flags for the time being.
> 
> Also update BUG_ON()'s to VM_WARN_ON_ONCE() while here.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

