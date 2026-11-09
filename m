Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DCC0606D831
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WZ3uelB7
Received: by kanga.kvack.org (Postfix)
	id 49BD46B05B8; Mon,  9 Nov 2026 08:38:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CA86B05B9; Mon,  9 Nov 2026 08:38:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315636B05BA; Mon,  9 Nov 2026 08:38:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05CD56B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:38:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9926F1A065C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:38:30 +0000 (UTC)
X-FDA: 85415685180.19.5312B26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D032B40012
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:38:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WZ3uelB7;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794231508;
	b=V5ZilGGHkfqKDJbyPRuuNg5vuoOL07iATHg4X5BNQMmTSsTYlHaLTOMO3+9U70jWNe10kQ
	wR9HY4M2WiPuMjt790mcMXw623P2K2iqG1esVr058MfO+xbK/K+F26hcYG2VqcDYQLzKrN
	rnZv9nnHp77b80DU1f6v0CDtkgNjCBM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WZ3uelB7;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794231508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aS8gvtJwYJ7Jliq5wp81vVfiAvrLQxAzcweXbt+N94=;
	b=ev+Kop+04+OVQF/b38Yvc+pcHvgMBE0oWsNzyxOnP7P32NdCA6jEeBAZeubMEv9pA6MUJD
	gZhSbMxReS6ulW/A8Q4wbjtMVQoWg3wN7MD9lHaQULXZd9jc3CYkWkaYvtH0NvOWjarGQ0
	vBoXxaeKbxI5JlBfV6/5fI2DL6MDOhg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E8726330D;
	Mon,  9 Nov 2026 13:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3661F008A2;
	Mon,  9 Nov 2026 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794231508;
	bh=/aS8gvtJwYJ7Jliq5wp81vVfiAvrLQxAzcweXbt+N94=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=WZ3uelB7V+qK0/f1tZpZEt/+AhrXEVHNH/IgUZx+TRm7n3MQLHQLPQ9N9uPgezm+G
	 6CR78PhrpB7B7HTmcD58yh1KaFEEueIkKWp9lzg9L3qrn3/3A/JSf5tvTU33RB1T2p
	 9BJEtW+i0m95oWnqOfsuKz6oFH79+LBujn7wf25fouWcHQIuRjubqvVqpD2brV0QkZ
	 1O0RoWddr6aQgIZGm48Qbc9XX6dT87bDYsjGFKKjw1Hzjvt28SGiREqgWH8w1y643c
	 YEWvd0IgVQsOXBeC1oswZB907JFoJm5zYlsDd0cs1Lw4p/rjxdjPnrkUADHnvnOWbo
	 ujKPGy4Xfn9zA==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
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
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org
In-Reply-To: <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
Subject: Re: [PATCH 05/13] mm: convert THP VMA flag tests to use
 vma_flags_t
Message-Id: <179423148899.14386.17835309596553043809.b4-ty@b4>
Date: Mon, 09 Nov 2026 14:38:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D032B40012
X-Stat-Signature: 1u1cdk437xzqbaesiqpab3qkieopsusr
X-Rspam-User: 
X-HE-Tag: 1794231508-645913
X-HE-Meta: U2FsdGVkX19tHAoWQQW6HCqfnedw0Pdk1cWkSPHAXtLeAOLGi6PEKGMSN/g4VENemMnzS/Qqrv+6laW6WKHttMvnEYgdWKFzbh9l4nCEnMWtP9mnJFePVFX6aBi7PYRxxigNLEinE+iRyAdXK76hA4bnHlwbKZJYyQkk41NV5PorzH6opUYmjyY4e/pFUJTNC8TevXqagkT50d/PGnf2DP6PTq//RhvCBzsOz3sK7iESTx1W2OlzQ6Z5GcZi+ABL9q92/SSj6W80mPqZborva5HzGhM+Svwxk/hGwLiZ8ZzmWcNtywW1oPGVss7wzi3jy4yrIhzZNsfueXtwiBzIiM63WmFTmL/0Z3ZzJcIpcWzpqtMD2nENWtZAq+lCtdWt5zbGF7BIIN2JkYVlXMIziG9hAttFzk5EK9+wc9sPJKI3nw2cAzzu3SXmsn3S1A+5RHdO9LqCuLQCVcL+USVfdGv8/WhmG1LAbLytZ8dbwYvIZL9EN+8rjLlKQdd4lqlAzeHFDA9WJYtoNXvu+myAYUEUaW4meIJIQJ3pQ7ztMLZKDeDI2IRut5nmO4mBtID04/QjQ8K1iZ3UWyH6CweIw5f7G0u+et79qfDdr3Ip5cJsS4CJ3Sbc0xkTV66/ormmLMueYAdjOIu8cUVcuy0ecSPH45RTijoyAsxc3Nnr/58LQACUE0xbAnCcxtT8LISrGFmb799X9djdQM4CDniN9VWSa09GIoDivxUpTMPNr9e+MOjPzJq07suXXqtz9kpHmjmNrp+tFS8fPSOBYjXW8somUZiUlt+zKGBL1uT5fqKUUfYUtxUVsXIKZqT8k8oEuxD6Ea73m26XZnmb9FYguAhFwWEFNrGKMJWCn1kyCwnS6iMfxpdV46CJ/+YN7rk5KxmanqJ0iwWjiXACb52+WDMLc8VeAkaO5FnXVWi2wkJm9VISybs2ywdTX9nG1iOmuyOJc+Esl6mUXVBknHU
 skT3v6VP
 USlyh1r5jK6a9+ggqfdpZADWypj4MYwiNaVrMV2wqtiRTVHCbluJ1MXcOh8jfqobwvtl47rLBRXa8Np1fPrQ6pE+GTvhAzprefGkZXSB1DQ3ShA7bqGSHOPKbIzpFG5HEnJstmNB3SO4jCtjQmBTcCYtCFcYiKplNrc7DdnH76JJsmZlf0GUuMJURdhnnuXp8UsUe/eEwYUysxe16B21CEOPFtva7w46/gFEmvXfWaQD1egVZWVxDhfJKe8piuuGgK3sdM+JnMxY+SyVzSV3ci+BSdKNK7h/CiLT4cTa1Y1ciWG7mRUZbxS2jqtkn7lOCNmz+G6+NVH9lCUtN3Jqy5MukSL3D67GwkoHyLvpirARkpaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 21:30:56 +0000, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values where
> VMA flags are tested directly in the THP and khugepaged logic.
> 
> The thp_vma_allowable_orders() family of functions, hugepage_madvise() and
> khugepaged_enter_vma() continue to take legacy flags for the time being.
> 
> Also update BUG_ON()'s to VM_WARN_ON_ONCE() while here.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: thp-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[05/13] mm: convert THP VMA flag tests to use vma_flags_t
        https://git.kernel.org/mm/core/c/cb15e2fc

-- 
Cheers,

David


