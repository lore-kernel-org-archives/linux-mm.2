Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF56606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AH2kkJao
Received: by kanga.kvack.org (Postfix)
	id 3DB8F6B05B8; Thu,  5 Nov 2026 22:05:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2A36B05B9; Thu,  5 Nov 2026 22:05:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC756B05BA; Thu,  5 Nov 2026 22:05:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03F016B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:05:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80D59160AB0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:05:48 +0000 (UTC)
X-FDA: 85403204376.24.51DF2C6
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id D9BB9C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:05:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AH2kkJao;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793934346;
	b=Oe6ATY24M3U31eQzMvubGcS4K0m8B0uouG3VrhXf2yG4zb9uYCg4+Y3dmpKH5DmxjLH/OD
	cR6Jq4j6Jd6WHOEckR0eQuGASbXc+xYuTTcbgk9l34bg+qU0biHz+cUaRzALmGiB18/1YU
	6Y238voWumLk8Um8v8sEZI4auKyjGRY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AH2kkJao;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793934346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Aof237vDO4qMTTpfPlwofHadKxllvqKaM/oePbLGkw=;
	b=N3Dq7qBA3WGZvpUx0v/DQ89XioTRpSojeHQW4f31uHkHkyPz3rMix8nXVsxb/5he4mkTEO
	2lyvAzX5kxzpzNWBjkbnrhmk0il1LIADzOYv0O+MBINlGaUgXKrhguC0BVvNKfJUezf3VC
	vr5pKyc37vOP8xkhdAfH7Q7bnXy+UHM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793934342; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7Aof237vDO4qMTTpfPlwofHadKxllvqKaM/oePbLGkw=;
	b=AH2kkJaotGhIDo4RYG9oDBUXGVlCAWbS3rpUEMd2mM8eWEDOFt+UbF2bfDE4EG4e1FDGhkA1dqLkYDZzxPHQBiVyxkvrN2MltvBiRxSZaA8YJvs51UGsWnHvOcQMhJ9UuUG4nd8wltji2YKrIpNJPF/u/MR7lUAV1e7/yJDC4sQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=88;SR=0;TI=SMTPD_---0XEA9EV0_1793934336;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEA9EV0_1793934336 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 11:05:39 +0800
Message-ID: <4bc884a1-a04d-4ccd-8934-2095beb08251@linux.alibaba.com>
Date: Fri, 6 Nov 2026 11:05:36 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] mm/migrate: convert VMA flag tests to use
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
 <20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cjcexck34pt6grk7k3r5ejjfgzugnx4m
X-Rspamd-Queue-Id: D9BB9C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793934345-537129
X-HE-Meta: U2FsdGVkX1+v9GaZq/ABZVu2ZjqE+aFWrIEHOzXuCCn2HsjYvjpONpQlSKpY8NUpK1lMzLBG2vR/irFegFzX3eFJdC/RoZV+wazxCSPl3EBZQwzuTEbwBDkkw7I911c1u/uy/IjyJUh9nB3aVRMTrJVxf4MbHU0Wkl7l2zKVKyfnvFBeeq/onlCX/8OjeAkajdrkZWYypHGuq61dTgYvmwRpJSsvrMMPzH8JLrpzPU4o6QKAAgrP0lmCqnr2jtAI3LodvbAfPfJ32ojYuEm3TRrbZ/13IBSPKPV585JXaBWTEAC0pnnLVnlczCe/TIiJf13nSevB9x2dWSms+f6K921ZB6kzarBX+d8rJpvlEZjO+wKcpE5Laz+On/0eQxsr+6pRx6ZqI//jDPunFs3WW6uMB4D7g+UdYlQ37aUH6OiwBY5+cQ8QvrozkF+h3sCrJsAysSm59RXQx/tt+G3pkY8m2OR7cztiwiDpv1cW08YnCWyRc7zJ0qB4h9Z2NHgeiT9apcdKKR0VEoXdZH+A8LU9pWqo8m2HzHOaZDszTg5QeOIjHSRmsLEbokpgSni4B9HKusS1dt80UG6OtsB/gZ0U2DjzfLFOZthLzTxpQ5VPhUdH/EsSFwWh+zxLil9uG13NAxJBqXexqtD9dmovcGs2DsvlftawqCTrkn3p2ktRUlsNWZ9MivXEJ14QjlUt3sJLjk338V/F+In6WAAZ6EzG6/88UnwpY3H4hlMHxQtR4f16/U+W218uzm2TG+VyIdgqcWtfiSwoxTCJehUq1KPwbGhM0H022pZPNM56qQeSebSWfVqgn5qnn+N63PF4HXRGPvD40Lz3S628DBwgYDh0kFxcsz3L4X7szZsgb233dKRB8jTfzIqi6gxJHQ4OB85Rg5TVEJuCrNHJtowZiDGc0mZkOyTj5ui1v553pHGfSFRUbeWgH5izBFjCdbY0YMr9mEZuPJ4JTSGlRy2
 CF9vrG5h
 dZGl5qi1akSNE9QaH0rmVdQsimA2hwWp1Ed27sHZQ36twPfMRY391KsyZjsm61kscnQO6UnCt8Xb++LFWXQegd71dJDgO8YvJ7/Iz7H+F3Spq4F9spnvxkXyYY0Me6QwtShzZ8veM93/XEkvVwCNb+YAEy0LDunDQ7gtY0EhHTTBiUVN6++ABq/L2i025e0JeUdxyRQ/egUdkZZZ3SbbqCkhV/sWIrl7QTbylKgWIEZQ4AUALovxoQvJM+EqGldv5sn6sWP4qeHn9MeYg8EjM7Jzf+Qcv8IofH0SFBYcVF6b/lH54NIR+/7Y6/zv2q1UUciB2SFD+0bQR5kKKuIvyUNn+jBnqreGQQKxdWECRgok75XUVS70+dRGzlsPfvbfog2frwUxp1neR/2FAdHcrnxfFCubeEBsrS6UuoKrCVqZwto9F0Uu8NjxF1y/xHGGV0RIR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 5:30 AM, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
> migration logic.
> 
> We retain the READ_ONCE() of vma->vm_flags in remove_migration_pte(), as
> there is no vma_flags_t equivalent, and arch_make_huge_pte() continues to
> take legacy flags for the time being.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

