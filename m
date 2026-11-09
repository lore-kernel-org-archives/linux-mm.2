Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1303D606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=moJaaXVs
Received: by kanga.kvack.org (Postfix)
	id D68016B00EF; Mon,  9 Nov 2026 08:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1576B05B0; Mon,  9 Nov 2026 08:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92126B05B1; Mon,  9 Nov 2026 08:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8862C6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:31:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A5E01C4026
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:31:14 +0000 (UTC)
X-FDA: 85415666868.26.0693977
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C1C894000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:31:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=moJaaXVs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794231072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZb1ecY9gAspjaczVb/ho/JkduHza/gfWZak6QZzsog=;
	b=8G0CQvOiTQhNePlec+RQiw35zwGDFtSxp0xHS87oOyVv+rWEv3oycKw9oA857VEub4QXa3
	fFnrga4GtJEgVXdmcYGB5WEqVtqKy7tx0VAc6FWY3DzRrpe2sHB1jv6xy6fT7XbCNvUcUa
	jXfxhsyOa3IFgtxu9VW0g061IG57m20=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=moJaaXVs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794231072;
	b=wVqnSgV4PLS/+pkOyjpzc3krSj15MP2H7InxfZfMPw0MrmfLhV294QzdHOm9C0lc7MwSN5
	qRvGEuLaXkuICfsYdYEK9OuVkur5yz/mzDog2WAOi2UXO2sfS6ujCBomOHlw0YLglP8vLe
	o5yEIiLqGxtP5INLKFA8nYablOVbsxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5C5F40244;
	Mon,  9 Nov 2026 13:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A331F0089F;
	Mon,  9 Nov 2026 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794231071;
	bh=HZb1ecY9gAspjaczVb/ho/JkduHza/gfWZak6QZzsog=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=moJaaXVsjzU7SL4CI8JBlVbPKjmyaTD3NHAgdTnwk/M1L60N+Lk5weuwkobiTd93C
	 8s5kF6qwjOZc6FI/CH+6n9ves3n9Dt3ncPHme7MMz8CrOWrXu7GVA3alW12QVQxfFC
	 dYdxN3at+z/1sifp3qbo3ReksK4F/0ytjastLvz2FzQpT5Hf4HIrH6DUDcYCRbwUm+
	 dEj416YDQH6bI4b6I/NGuMzR1qG7vWeEqkoYkCakzFXeyTPSKb1bte6mOADwhhJ34m
	 oj57425c6Psc1SXo2+31xoM4HAfQoI0isPU+xPj1eF0X/18EEWq+95be4Si8H/sog8
	 62xe9bzzf6Bpg==
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
In-Reply-To: <20261105-late-2026-vma-flags-v1-6-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-6-0d3cd15ab75f@kernel.org>
Subject: Re: [PATCH 06/13] mm/ksm: convert VMA flag tests to use
 vma_flags_t
Message-Id: <179423105176.12172.13163434370832642610.b4-ty@b4>
Date: Mon, 09 Nov 2026 14:30:51 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C1C894000B
X-Stat-Signature: 9m3rd9gt9mgrgaejfuww1nrr8hnhxkda
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794231072-674604
X-HE-Meta: U2FsdGVkX1/BV2pBfG7XCleOND6NHRhfHktqpzGY6MG0zI3wEEMGFk8KWe2KeC/iyF0AnhNbvX5GKq7fUe6Sq5VggVqXsItbpseKtDsUqEy1psHhvOzVSFnoXyMKggpWsITMb981n+jvRtD5SsrZVTFXf+RbPvlRh/BN4PAa0NR+ISMW26yqhnZokS6VZBDYuew88qKJf7LmFXkPuKP1BbLi2PL1PnDsdZOmie/iU1DaINJcyAQP8LDJWowpiYISDs5SdosTFjLq7GKiC417OQ58KHJR0ajkxuSSp4iBTLNRZoQOIu3J/SqKOYAhbZN2LMDf/mfkYopB4Wz0x4PF1e7W2MlD9XMRiK2qoz0Zmu7s0oER0+FAK/5gkLkLbXE3KoUHCLkT62lWBaKHhaJP/uuWCXhjxcIeXTRVjkm/fVR1py9C2IFlnJepG7PTddHrClwbbRewi01/TXP1ddqwGYLBBwu0S7z/ABFm+ORNAIbQdRLaMJfw6zD7VDF1vqQRkkJnuzJDjstdTlqrOg+kxVo0ROijWXG8TXNwjWHZxjRqnmeRlueQ5UcmVPjpjS8Oqp/GOA2+t3Vkr0HvEzTZDdO4cayf20+i/MY3H+/GyNNDz26ai/ug0UscT4prXSLKnt08Z/rqtZZhXM22YJ+wS0UmwFfnhZmygvpNocMuDR3ocLehi/V5rJbiIgcr8rSZkV4HegpIDe6Co27BLMg+7bgRcgwMn8IhHKJr3r7fuBTcrnewHBxI+lPo63DFf1lLFiJ40vkcdnfLR1NOYwycVdE/+GqOD/grk3hbI7NwA8OefBk1Z3mE0/2QYMbiedv4C/2tSKLcXpXIk9jPg/VNsj8X+AYrpSiAxjIj0NqdK60CCMltu6ge+EImHIDBKZ3gn3iIGr3wRkzQiO75b4HJgC+O5I7eLgiw3edRPQMKhvegrSJOJICda0igo7CwIAQldoRMpld6ojojS4FhSay
 PChG4LvK
 F73hV06sABtWuRAd9F0fP/HSYawZLdh4y1Ai6gwb4A92PiMsf6NHa2dWbh6f2Fg+NQ+goSeiZ+Az3eL6airOInuQ9HtMxIGsAAOvmoBBPWPsrD7921iUmaRMGdcta4aPKQBWkwejEQ8LpYW57UjKPt42lJ5qKISNPhMapKQNREhzLYVBTIJCpEAcp9EbMt6aBNtpDXkGwYEMXsucbQlUJXrmUi5JtPfmPRq7V56OfTJW6/i/VFCM6Nmp3DZmym6cDzzGacMXgBLqOXae0BqnrdKn8Bf0qv2cJzseLDPNfE89CokJphdbxW0aG7PJUmKS8ihB5fnSFJT4yWsAb8lXZOjAm/XMlSlHJAZwFf+MX4cCQFw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 21:30:57 +0000, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values where
> KSM tests VMA flags directly.
> 
> The ksm_madvise() interface continues to take legacy flags for the time
> being.
> 
> No functional change intended.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: ksm-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[06/13] mm/ksm: convert VMA flag tests to use vma_flags_t
        https://git.kernel.org/mm/core/c/4ec4530e

-- 
Cheers,

David


