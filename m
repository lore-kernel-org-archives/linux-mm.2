Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5CA606A336
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KzZzxUcO
Received: by kanga.kvack.org (Postfix)
	id 83C636B05B5; Mon,  9 Nov 2026 08:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC7A6B05B7; Mon,  9 Nov 2026 08:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBA36B05B8; Mon,  9 Nov 2026 08:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32CA96B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:32:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16D7E4067F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:32:55 +0000 (UTC)
X-FDA: 85415671110.11.A7903E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5B70D20005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:32:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KzZzxUcO;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794231173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kO+9xP9gHYxqDwN0M/HD3ySNAPtZoVrTYpd1QO/0hs=;
	b=8EaOpbbwImPaFija52V06vTxlxidiueJ3z7E4BiEaahPmvUlpk9DcIZ6ni9yRasX3Ygz0e
	sVAs3rrp7KKNQq4JRzETQlymcf2mBW2gAxLhYfYPpGDc8rSqGg5Ckjs+hzvKu4eRxHy7ll
	YjC+2CW9mJWUnRTVg3jVRcI5jYX0H4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794231173;
	b=uFweBxs29pB3eXsgx1jU+3xsSaGopUshJ8FlVveqUuhdgtfzkPrPlGXvHW5HbAgikKYUxN
	r69xWLfkyw7PfI3Ju5FQCLmMB7GkcNOcRduSBVuLjpBbYCe7R/KkKTZYoU4LErILZ9QFmX
	2JC16gZVVuyXo6vmA/DkkXle5jYfWCI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KzZzxUcO;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA00B4510C;
	Mon,  9 Nov 2026 13:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8BE1F008A1;
	Mon,  9 Nov 2026 13:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794231171;
	bh=3kO+9xP9gHYxqDwN0M/HD3ySNAPtZoVrTYpd1QO/0hs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KzZzxUcOxN+LUkJJbvaaWtgAg0Lr5n0Lq5msXujrfpHexbax+Q7MphMNrKT297nty
	 Lgqf43fqFL3IaxYW4qsLltL1rfN+n7EKzp+quYJhHXOJf9EdP3tkJIZ/07lfxJ6QR5
	 yMVW+5CfIRJchjav43ecF7/gIb/nUAMMMClY+lUKqmcbumcULnahrlJ2fMGe2TfNut
	 CHcmFQaVPR97bHK/+Cf5PmZH+zHZWDepmd9kLxjjIuwDPYFFh46dEB0JJjZoWaLWmp
	 3wVNxLys3qIdpG7dFxhjM07JWa3keQ6UCUpgwUbcazbFW8Qlf/49Zl3gWA1Y5pPR7k
	 iNtqEsvwq1ZEg==
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
In-Reply-To: <20261105-late-2026-vma-flags-v1-1-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-1-0d3cd15ab75f@kernel.org>
Subject: Re: [PATCH 01/13] mm/gup: convert GUP code to use vma_flags_t
Message-Id: <179423115134.12726.17304494910149332848.b4-ty@b4>
Date: Mon, 09 Nov 2026 14:32:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5B70D20005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: 4zmux5pdp5a4ddihgajhpthcpe3hs3jj
X-Rspam-User: 
X-HE-Tag: 1794231173-791691
X-HE-Meta: U2FsdGVkX1/4LAbOJRHUvGzMxuPxp+elrJNWaatp4iARh+I44IjjwJ0e28NZ4Dk9G6FhWawkxLIfmPqmuwWRA6WMiJbJDZzGhVwDrWy8bEcznoWAew0/n52BWRm2R++QEVH9GJuI5Bfh/MU4Xs3AWEbCO0VATSkfy0lSd3oE46/KQeiiGo/qv7XFPLtQ3Fe8Hj70pUimOQKbmvO3bFWhD7lKcUv39Z49DHkkhioh8EldWw8SFekZSyXRlahTak3sbhllX1tDr1HN3J/TwIHFcX87cAl3ANOaPE7gbuM71UVUR6uxrXk0H2mfp2dWYJQqXjYEREXIEKttSA3tz/0r1gbx1APQvlbO5xX1diRj7VSQ2x9NbTPdcLO/u8fI8Lx2KGFjuZXX0vNf3RsYiL8Cp0SHyEWZ5JYoNfi2AMB6KtAwsstTp0csATIkNqV4WRraZcPMAsLsJ4vsYHycoyDeH3SqKL/LwC3UiSsGnrtaTeTZQHPmUTEcPvo9O1hBvqUmsUH+zbg5PJmda1TswiiOBIzOjQswdT45o3eH2YSDBODPxQq6RQCrhN/t5q00mnUPmrFtz/QmMbqgZSvwiSD0Pqq7Ghem419lpS02S/zhuJ1dpfR1vvBaPKABb+8p3MUTuO4eUKJS04JG19Fys8gxy9gJ7iv5Q/ZVhljlrAGYBZQCkug+AYRNMLriHcQI6zEeRKlN0j4FHkWgnBE0Cxugh6W3A2/pW0gbMhTjLDQvgqh+9bbnWa/Hk4t6eWTKkQ36r+wHNGH5n3mMHiicQNdS/vNIDA9sAV8onEyr9yq4Arko1AxhF0Q6IqMPLOAWHTWwlb1K+47b0IFyssXmPYrBpFpZmEP9xcsceh8EeuEUmGjqlJkuNpz8OpmxPQdkRVsCHbH04oEuw282Tkjv/9Zs1Mrwk7Ggagf/ZSte0yjQCcH1NgmAnscJZTE6DVjxKyCA4svXXFs+1hN71ovhLDA
 S+eUmZzr
 N40tiQzmmSpMlpPxufgmGbOywqssOAjs91eP8adi1mvxxSd222m9r0zu49pkKuczWgTt3ZXOGLr42oKaIlhaTJl/g+5lmE2BqPXwwK5oWqsJc1YfDxCvLa4c/y4vlj+Qasvg3zy+xByChW81puvYQ6IHZx7NdNh8TghfM4s0XBP69/tUxoD/2nmHBYdmB66r9eRkLQAd3P8/uhN0IoeaKa8/+xiV2TPMj7Y7zMe96Lm7Mxgz8tAOAqW7f4v2HKyk1UuLS+Fa9UWBp1Gg+paESGmw4aoGpST52yfgDyrPkuPqSlvtRLiHApMmoz8OJHsIglQ/94j+AYXXyZjeCsu+XcjJXDOKL0/8C5B1Y2uq8LXGz9SY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 21:30:52 +0000, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values
> throughout the GUP logic, both for the MMU and nommu variants.
> 
> No functional change intended.

Applied, thanks!

tree: mm/core.git
branch: gup-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[01/13] mm/gup: convert GUP code to use vma_flags_t
        https://git.kernel.org/mm/core/c/87127ea3

-- 
Cheers,

David


