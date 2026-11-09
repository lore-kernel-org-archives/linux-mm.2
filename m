Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F25606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MiXLiEgg
Received: by kanga.kvack.org (Postfix)
	id 728186B05B1; Mon,  9 Nov 2026 08:31:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9016B05B2; Mon,  9 Nov 2026 08:31:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579666B05B3; Mon,  9 Nov 2026 08:31:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D80D6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:31:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85682806B6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:31:51 +0000 (UTC)
X-FDA: 85415668422.03.B1F12C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D907B180006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:31:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiXLiEgg;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794231110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9hDzei4f8OCxDxAWxM/wfgiQG7uywFP6rebfNmExOI=;
	b=ZND/Lr2/Pw6WXL/x2gMywT2mWAaWNlH0P9CG48iYyaTU+bj7kkQ0ir1+Fudt6UExE41wvg
	GFmL091y1nUptgPJggEqHkwItH9YpE5Y0ubaCS/1SwzB0jOLqZq0lcbnvXB1FWyhvResYU
	9NqtOHJiC9hAWesMD9V9DNaOkaFe87g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794231110;
	b=MZxbG4lD4DH68ZNri8UbLcNuDsAShOIgorE2EqUGI1Ved9JMtiYnHVQCxVhNmpF7lNPIPs
	GXsZwlGAiZ9bbOxUhmxQqCcy3XkGfoZEGagSTBKqjKHhiAATyJDBubKmjrR43rr2BQ1sKf
	9AqNfyoFvf4FHJV52sJV6/Yj5DMDASE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiXLiEgg;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4542A61EAC;
	Mon,  9 Nov 2026 13:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499B61F008A6;
	Mon,  9 Nov 2026 13:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794231109;
	bh=J9hDzei4f8OCxDxAWxM/wfgiQG7uywFP6rebfNmExOI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MiXLiEgghPUOGcvs6oBh8SjxhDpzDdm93oOC7wBp36PR4aRXZCBfzyY8pYVK+mF5W
	 8Q1p1lSm/UfhTrZdh6nrBdWOERBoks35DD2LxW590LnMDt2k7UxuDNsGDKqj+6pSGG
	 V93BEmYQm4xmxz4+w4TbH8CQGQebjNz0kr3y+62G6v2bCkBCV0VBIf2igcw7/cl2hI
	 A46TImS9+vIqeS0SJlbcC4U2jxvS3ZTyJf5U3b6v2h/YDHF2UNXOTAH6+UC+m2pNgW
	 gRr32oeePKKCSsaIMonl4S5iW6F5oWe240wU2Gf3B2Tg75fhs3AKIuHdLyYcGXAokl
	 a7GivVblgSh8w==
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
In-Reply-To: <20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org>
Subject: Re: [PATCH 04/13] mm/migrate: convert VMA flag tests to use
 vma_flags_t
Message-Id: <179423108696.12416.1867664320008779953.b4-ty@b4>
Date: Mon, 09 Nov 2026 14:31:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 55ujbd77c63bii8xxb57g1yotofn6u87
X-Rspamd-Queue-Id: D907B180006
X-Rspam-User: 
X-HE-Tag: 1794231109-315363
X-HE-Meta: U2FsdGVkX19bI0fopAOlBeD+OabnZWzdQNn6jXn0CAOiApeNjFFKdQeF8bzOn4HXssPk9yWYKLDrBdTxmZolpjH9VtWh7XNtjnmUlrn0x1rkBmo0XwUckGhBZdcwiy4eLrk2OvUjAj1XWU3/XSNJb4HqQ26RNcOdhWvFsEw5P84DeTXVCGn9/RXp/ZTLQUB6Bi5lsoiYqFFQzZqvmN7TSOPZ2Y3esMdsvnW9U4M4EaMUQdlrrL25qddDQFAdddm9Ex9G+v2jXc86Tqfo82XTw3Ug2gUtZ/hAva16oGCTVcDpUy4IW4yulwKJw1Ezl8NKazMwFhZ3NE2uB0HiIecBVC1pOYeeuSEeG4R2x9b5pJxpzso3dAJp4jXVNnENex/WA5W9zRixlYmq+mvU11TceEuV7y4byg6+/64tATxtaGSaYpq2UWFN+M9DhXvq9Zy6tcqwmlxHZmji1Vle315ikGOs1DGJ8pV2QfFGDZiNHuaxDU4w/n5U9KQcSGFh4lEvxg0ES8wHSsIDVBxP2FpuP82rUX6t9Ki4vAd09pQ4j5SXpVBxYCg6nT+ofZLtK+WNxgyBtkQ8/+eE8dtBFTbsGkWGXLLZnYM4eWsBW75vBJ7j/1SFEgso/F1fggrIwtTvPt1RrCsnml4r2h2kfI81MXThZU8cbU1zSlDDd+TaKcI/9zvCw924ITifSHefvTQzVJ8QuQG7RVkLmp9m33LNkzZDbmgNTV37G+54Gwz4O3IZJLBd0jkBOvEBkddyPoZAqo9Igz1V0gZord5rDAyCKpCbtunqF5wKTB8BgWIt6tyExFVvjJxmcZmYZ3RiauXCOXmzUn5QBp3Dh+uMMchbusQdun8bZq2dwfpYhdoj4vBwO9tMJmt8Ew+EZ2EuLVQWr5r++//98g51GSfK2Jj4JDSexfMMjYoHL1LIQp/Bxbbji7bzJYCEApTeM01cnhCWjF7R8Ntc5y1m7PkWexD
 zCc1wAbf
 AbvpUb/bKDzgOAGfS7A8VaD2kZ5/W28q+KH9P/j5o+UmVnrhaneAgr05fATeJhEHPwWwBm3lUb3gjnesu1UymkNo43iq+gIwlsbTaS0WAkZqWj0XLUesZoClJLGtkgZsRRVO4qkJpy1S9yQrubRin31+eev22ZKFhYeC4S4D0MHz2EOMSF40aHQ5WU4pVhZ9pbfmDLCxhtCyOfxb7PZbePAWdaUJ37f0afbXrGDoejzoALXHpGeDvlKSz3djfBxtQhzIvtHbG52R++F7x0AKi7b2Ej981LlmB/acBtIhNmUyE6k7SnkxRScVRztPg3Kz4wTl65NJznDSfy6GBcmnuTffC/eTv+T5wwlhyCELLyoKkgVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 21:30:55 +0000, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
> migration logic.
> 
> We retain the READ_ONCE() of vma->vm_flags in remove_migration_pte(), as
> there is no vma_flags_t equivalent, and arch_make_huge_pte() continues to
> take legacy flags for the time being.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[04/13] mm/migrate: convert VMA flag tests to use vma_flags_t
        https://git.kernel.org/mm/core/c/ec215c56

-- 
Cheers,

David


