Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8C2606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SnvndiBJ
Received: by kanga.kvack.org (Postfix)
	id 44E986B05B7; Thu,  5 Nov 2026 22:04:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4254C6B05B8; Thu,  5 Nov 2026 22:04:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BE36B05B9; Thu,  5 Nov 2026 22:04:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC7B16B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:04:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F36340CEA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:04:42 +0000 (UTC)
X-FDA: 85403201604.26.9EFE7AA
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B1271C0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:04:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SnvndiBJ;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793934280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PD61LryWpAKBHtS1n/1Sw/t0gup78Gp41jIY7RFBO5U=;
	b=3XyocddAXhjpPe3kkSqE1DIsqwYlXB11cPEjHw8vNlR1NLq7d3OkaxyzFqTusCHspMSBrM
	p/pu1ad57Sz98inD+SIKBh2U9eYOtyCBkXQlQhLQDcws6YxmNuKgKHUbpHrWOVtsrG7fN8
	KXw1QMQm1usl6fHBq2UpTAzWaBJpnUo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SnvndiBJ;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793934280;
	b=kKYljBeow7NbeAF8db3y15rtmwzPE7szbo7S5PhCW3cyFyJon1/dhdZMpzn2DCIDDFKjzY
	lJwlaVkJlp7p6yRMMRAlA6d0N91lZsdf2YMMwJNjwOmZ6rX//a6M9HjY/ohdE9i9dgqKuK
	YYLBdC6ZcboLBJqqzUqx5zZxP6gwLd4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793934276; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PD61LryWpAKBHtS1n/1Sw/t0gup78Gp41jIY7RFBO5U=;
	b=SnvndiBJRZvBOr6DBUrh2JEZf9exdUjKTEXhNLGO7OjNxoE36v6pHI5RgGzp5Jzthk+nllbVV8kBezeKz18UJ1r8G8/yB9mTJYLG7iFzZ92IwY/yHa8uEZ9qq86luFh0m4yIzHhGfcJ/I005gen0gSlGPGq46Cys1CrfVBOLxJ0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=88;SR=0;TI=SMTPD_---0XEA9E6e_1793934269;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEA9E6e_1793934269 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 11:04:32 +0800
Message-ID: <38869f97-7e81-40e0-acc8-fb30ddc22c14@linux.alibaba.com>
Date: Fri, 6 Nov 2026 11:04:28 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] mm/rmap: convert remaining VMA flag tests to use
 vma_flags_t
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
 <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: arjewkot9yw1xtb4o8uwmr5yfmt8gnko
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2B1271C0008
X-HE-Tag: 1793934278-400253
X-HE-Meta: U2FsdGVkX1/zxBZPWPJUL7569UXesDPzCkd3QOAqxdqDzGxAGPGyJaCy2LbHD85d3UqUgOaatQnpt5LLElgm8eSOVcWhvjilCQvfM39GwhDifW0QEy6EO8kLy1QJOEs729SYQTnMk7qkqbEHyumq5zkg1DX1Rvx+UmZFLmK9qWXbLVxMDKVbXi/rBETkB1BvVvc87697G4TfPhb2AEOqn8ERbI9a0+4psLGWHImZlBHnQ2QjjO6qCufB3RELV6KM63ZePv16b1Wi7PW9hZeDA30+iBuquB5E0AnJqCvVLP7YTxUEWgT3BqjvyRyX4KpnplSyVQT3uu0sFh89YkQXZn/TuXrY3789jYG0/ptrycLRLkR2Q8qCWxX85iZzz/61nCzbY82j6tCs7SIs+8vVFGH4O4nfJ+w7VRUQxiTSsqpSq1ZuZYaIZdPHC09Cw5nMPFB1Mh2EXV+Y6Ukc3D1+E66Sg6ru4/Glwt3hiPiBEpuJvHZ/MwvgluomSx68SEpWts3EXlwgYSeVqTwXhZR2fcopgFbE/uplP7hv2Ffi2LgAeWKZEWFnGkeARP2ClyB5IQbQri0T4FVfmCo92QE+ZBtRVraV0xraR6Ir79VgU8bVgC0DTyIyTMMgTjJ4cBUZqpeii3/thB2B2Z4JFnyqmIK2U5XCU0IvBvmPTzdujnSozmMAteeLFzpWFJlHs2qTKpkPVq3AWl32jJJDjJzB9Pe/W+dlIYmbPg57yuGfxzhmPbQLFv9nRlVgs/CN5xDYoV1wghAyKR8AJGaMXD5XUMd976PbT44qRZZSqDvS6eMmJCUbvOWHdu/v2GTI/xI1s8Oh12U5ppnhbe8cM3RSRdHmUedKL0Nq6w5Ro6g897jfgeSfGbMn452N9C1VwOkRrjzQDA6wYnQmwalRIF35ZNScdAr3t4cSLnG00RcuzaYyrORLIEwFwrx1Irk5FabzZVZPy9/R2376Lsnjd4H
 haV4D0HE
 q28arTV2eogFVAePHxiew1/MjtBiVB/Jrf4v9XPAvS5N/6OtRw08gh3kV5j6En1a+rI1KUUgT6i+hu05TczC5OQp50Ih2/wZAlOaWU2oWMZg0RP8KFjA+2idPSiic9Urdugu4uw+2WVoFE8A36dAwK/Fb1uY0IP5O+u3c23yDiDm+4VEUgq5XHOHB9DZ9zlQS6MIREIus9DPdmQif1LOv3bitviYZHmpkxjh0rE7nye1B3x8pj2pfxxsCv2VV0hwvYBYnztZCXQW2CWQqX48JrfnP3EqPlufWDhvNJ6xVGztKsOE17tM5KecJygsfro4bzU6G3Inr75pyAB8QWqD9bL0LdGgpTEw8GjlkZAItfntiqnUEaE/2o2R6Imib3WSVAIu0OJYkV1UMlcu+hTwB4ZDmLVxabGvQZBqJqaXc+j+rwVtM29IeUNluraAPb3IiNKSftuzLvrYVzipytzr4FNeYXA9HOyKwSPZH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 5:30 AM, Lorenzo Stoakes (ARM) wrote:
> Replace the remaining uses of the legacy vm_flags_t flags in the rmap logic
> with vma_flags_t values.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

