Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4E1606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbS5o8Rc
Received: by kanga.kvack.org (Postfix)
	id 1AC7B6B05B2; Fri,  6 Nov 2026 09:35:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1543E6B05B4; Fri,  6 Nov 2026 09:35:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CEA6B05B5; Fri,  6 Nov 2026 09:35:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE8B26B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:35:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 771DFA8D69
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:35:27 +0000 (UTC)
X-FDA: 85404942294.10.D6AFBA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id AAFBCC000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:35:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbS5o8Rc;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793975725;
	b=49Dz0twV6cphl9NU5czZmasQM9YuAwPKOot8nq98IScWHJeZkVe3snltDpifZzUGrhSdzq
	wYSpaICzHJ7FklAs3b8uUWJn5NSXX4KAJV2YnR4o7yD40rS4+z8b9NNu3BQWpgUSVktLHI
	jOPeS2ojiRxED6gWhsftyeg18wSqwdQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbS5o8Rc;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793975725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVYlhG5zwe3KP2A+EnIMjZEgzahfx4Lny8jKmNJoSns=;
	b=K1ZBOmqEAczTYX9oLHzLgprZI0wANaqgu2sKHGpfPnZ3ppY+QCSGrLFXUo+yO6MauNTSwr
	EkAHeFJYhlD3UMLIxbZP4zr+X3n1iiYUqFTQPnuAdxxMyQTGmsYjES5JVycagujw6s+ErV
	lS+kXie2ZE1lFx7ncriQlsIy/cS95uE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98063601BF;
	Fri,  6 Nov 2026 14:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EB91F0089F;
	Fri,  6 Nov 2026 14:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975724;
	bh=dVYlhG5zwe3KP2A+EnIMjZEgzahfx4Lny8jKmNJoSns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bbS5o8RcEMSXv+wnNKUX2QlPsL3eYMot1atUWBvd2g07t7FbPNdIHI1p7vV5CR6HS
	 zbmWeQpU8ByWX50kTNamEbcSnT1e9HT/c07ylE8QiRp83ZcVf6gJ31FJWS6N7JFrsl
	 Tooqt0/DM80yb1TjjXEcDHgflkxA/vYfmpwGfidJdjHWpIwpCOUGXUJOALdqb9Nusd
	 ddqgc4AoOIYX5vLfBxknD9yLoCszK3cdeF/SOm9uZ57yEFqqQdWnI12Oig0UXv2i4K
	 GuwrCZVcwoRPVBCv4Igxf7uv7q3Ynp3EgEYA3o1Yf5hsmd1qeZqB3nt09CPz5H9und
	 9eQ13pQ/tn2DA==
Message-ID: <d0ea7929-7c12-4245-ba3f-6dd5c0269e6b@kernel.org>
Date: Fri, 6 Nov 2026 15:35:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] mm: continue vma_flags_t conversion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AAFBCC000A
X-Stat-Signature: bqj7wr64jp3kokagewf9fa61rdg9atzf
X-Rspam-User: 
X-HE-Tag: 1793975725-902735
X-HE-Meta: U2FsdGVkX1+z0fAyJKnxAel73NdcckE9aSB+IFEmTXWUyHQJno+IrcsZAgenvuWTbc2Jcix1v2PWKj+RyAqqDP7G+K+GD44BrG5GKmiyVyaypIfSrK8raI2t+rLqpP3+TUos8WQXkyyw5mIaQR9LB5AkmJXe9VCxo5s4JDY3E2xl4o2ahcPxZp3KBKTPW/5bIJSrR4BknAWntAydDmOHEKX+nLAKGCeA7K3HLndKrjpnsiiUA1/GA8rosSA6TFIx4P4or3+pyy4x8rkgoALnG7OJDpS3hrMZjD7uKy991ZStDp1iBdcilN9lHw3GRM+H9W0TJZQ8swoKnB4KDwPpCmJVGXuMi7kOrh3Ykk3MVURRgCiTmEljjToptsBgaubGTedYT9buO66+tSEHhmJ0Dnr8jpM6EMUar4PpGrheg2sBAkooxWJ+uRPPFIJ55GhAxY/j3NV4wo7E9GKU40tx+gjnt3xs604ceVwjInCE74MyWDzf/jCnYDQktrTdEEQu+UdxV+MkYFI5FnrWXNhPoK7ZqYFARCgTfbDuVVlWVzNt3uz+7ZS2tQ/PK8tNt0br0kL0TFtwFE7TQej7vLTBs0RkURf6qqOqLojpQZKg7hKMDGoaG9wvzCGjYad06rSiqLBNhKWHioPiWQFqE0oASdrAIQZiQpOPySqI7OtKbuZr69/3Jok8wVsi1ZbUW0r3wlXwVqbCD3JTx0UPhlsdClzlQpP1MBgsHTz42XnEPX1/BTVfblM7Ap3Mnt1CIQS9/BEibN1Z1Q172ARsuXgkpMxids+IfQeVy1QME0nhyHgxqJifhRiVQRNJkIAAHXV6Q9vt/g1OtJR/iiXMHDIXK1XtDkIYpLxNY99+kD/nqpK429mqdfBUwhEA9BjyaBlUuhtsbQdvGZP1K925+Xp1kT5TWzVoLHOK7TnYpZuba32ZyIHbvQ6VKn8OqhvIQ++6xdQOkBCSunMeKTdbvM2
 Ly0vi3Ag
 xs+cSWF28QDi/uXfCKc7ZDWAyloL4JnPUrMO0x7XxmfoPmGdQj/iyn6wyEcAlAJBI3gcuY4YKUywfJkhSKbe+X1Ecm+NhG8Rs4pOu98EiO889NNr11ogaxRBwT4DlU/4AAuldcwfyhLErcOT4g09L+9V4KcvS20rcM2ZUS7j2CTmRgnna5NrCpU3AjAcV/EyASb7or23Pu9eSsFR8lhw8IbgqNTlxT5dHzmhvDqClnLh2PD9LvXVYTWLkNm9s9/+vLfXViK1RX2VFLnAsQRKdC6BvjEjcfXGkkqKHkmkPpXErlyb5owANf803RBw4jKq8kJgyTiG1Gz1/g2tvfYRJ3z8I3qwJeOBCVtcvywk5ye1gABugYgRdiWTBWwgiDyYodRBywaKvRz8p2ygx8ybMNlAWsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 22:30, Lorenzo Stoakes (ARM) wrote:
> Continue the conversion of legacy vm_flags_t flags to the new vma_flags_t
> bitmap type.
> 
> Do some more core mm conversion (we really should be the first to
> completely move to the new scheme :), but also update some mm-adjacent and
> otherwise straightforward cases - /proc/$pid/maps and friends, the coredump
> VMA dump size logic, uprobes, perf and LSM mmap/mprotect hooks.
> 
> This series only makes strictly mechanical changes to keep things gentle
> during this very busy cycle.
> 
> No functional change intended.
> 
> Build tested on x86-64 (allmodconfig, each patch individually), i386,
> arm64, riscv nommu and ppc64le.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (13):
>       mm/gup: convert GUP code to use vma_flags_t
>       mm/filemap: convert fault and readahead logic to use vma_flags_t
>       mm/rmap: convert remaining VMA flag tests to use vma_flags_t
>       mm/migrate: convert VMA flag tests to use vma_flags_t
>       mm: convert THP VMA flag tests to use vma_flags_t
>       mm/ksm: convert VMA flag tests to use vma_flags_t
>       mm/madvise: convert madvise_vma_behavior() to use vma_flags_t
>       mm: convert miscellaneous VMA flag tests to use vma_flags_t
>       fs/proc/task_mmu: convert VMA flag tests to use vma_flags_t
>       fs/coredump: convert vma_dump_size() to use vma_flags_t
>       uprobes: convert VMA flag tests to use vma_flags_t
>       perf: convert VMA flag tests to use vma_flags_t
>       security: convert VMA flag tests to use vma_flags_t
> 

I agree that this should be picked separately. For example, I will pick
everything that falls into my realm to reduce conflicts.

Ideally, patches really only touch one component.

[PATCH 07/13] mm/madvise: convert madvise_vma_behavior() to use vma_flags_t

is all over the place :)

-- 
Cheers,

David

