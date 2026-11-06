Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEEE606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMed2u12
Received: by kanga.kvack.org (Postfix)
	id 81AC26B05B5; Thu,  5 Nov 2026 20:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBCE6B05B7; Thu,  5 Nov 2026 20:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3C06B05B8; Thu,  5 Nov 2026 20:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4287B6B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:01:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C299E40CE0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:01:14 +0000 (UTC)
X-FDA: 85402890468.16.AC0F2CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 25996A0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:01:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMed2u12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793926873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fy6mIR6EGyX3GNnS9djVNVrLOtUG60iOXxWGxnZZW30=;
	b=koxW2KExK7mo54Symrzw21IyVzgmjGv/yHZH6pOS0gRe3uZDFEwIxHJ55OK0YZ5aJRL1Uz
	ASYgt8T/UEpjV0E5RFulf2ZtZHFxzePK+Tz7LuGBNukDGY+OB2qGdB7IrY5zp6DcqQ8di4
	yiTnnugWADYWFqmitimXszR10gtmGAs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793926873;
	b=K9E8niPh3u11eaOG/5BYpX/tLjNsCHyhMC1OmygT4lk2SjWL5yWbr2hslpR01jMNbqqPdE
	5U4G5m5EdtVyvMOCZBRwP2vU+ltII3CD1npTCG+X1SeZydB0VeydXqMlk9Ud0WZ9EdqoF6
	oNWAPq2pJChu5Wac+cFQ/ZAPU/AROjQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMed2u12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A37736020F;
	Fri,  6 Nov 2026 01:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8841F0089F;
	Fri,  6 Nov 2026 01:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793926871;
	bh=Fy6mIR6EGyX3GNnS9djVNVrLOtUG60iOXxWGxnZZW30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMed2u127+wL/B/NdfIXyeoxB6u5xmOokzrftZzRxfrzI6qQeKPWKSpVsgX0qJ51K
	 hx2TLIa43xHxqsfLVPrxRVay6PdfrX7mVbGwOXR+GprD2T0ugi0eemDwVQYtftIEAO
	 AqnH5rLl+mfNwIoidLDPL9fz9NteNzXOPqZFmF/+nB0H5OL81nSlzxUQlOqsF6xT+0
	 5QY5GeM2meFlG1UUnXQC/vfBg4rzbC7YhVChXxU6K5rZJtXN1G4Idsj+btrhdV4YuU
	 XQ1ILjd6bCfk2EaJ5OXQ4ZcSqefqhddDJ2l/ZedoICv4cZPOsUrxDdXC7gYP8ju6iJ
	 4EZOWwEnjp8wA==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Leon Romanovsky <leon@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	David Rientjes <rientjes@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	John Johansen <john.johansen@canonical.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	=?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	selinux@vger.kernel.org
Subject: Re: [PATCH 08/13] mm: convert miscellaneous VMA flag tests to use vma_flags_t
Date: Thu,  5 Nov 2026 17:01:00 -0800
Message-ID: <20261106010101.95918-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105-late-2026-vma-flags-v1-8-0d3cd15ab75f@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hudtezwkjne5uwkqzdicitomjopzeufg
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25996A0004
X-HE-Tag: 1793926872-833118
X-HE-Meta: U2FsdGVkX1/68+SkHn6hkxhPoP1Y7GZ0DpTzwjZrn4b++n5fKgeK4iIPnKwL9ZjeOqNCPpQK6yahOdIOSDXBjzKuLvkzBCQL8LHngCmGjWemjHJFYjNWDdrenAceEcQxngdj2aXA8cONnZYSMzdTmDgPIbZuSo7FinBjOvhTuv+/1GbETizNGzGHgQbxTxkOFzmKr8B+kUAkSSyYMrGo/ZO+m7W21Lnzx3/X1dYQ7V0JTG3PUI8b27s+Vj6M2Qo55d279dCfSNKfCXZtZNXnK5FKo5p7yyDKKEJbPjhv5PQjxFYxRDnjPuWCxdOvfq3NihcQjVhSLzPVdIf5BIyHqP0X6xGfkVedQSo7+PGJmCpIEocfaVHyh0Fo4GgWH8oHMh6HMqIK+1VNitFedxTroYhERSBOlV+SR7kqQHg0sVsIuwuQO3ER8Ihj3iMCUG01iX2m0zlbwFC64tquvYq9YlyQNFs2i8GWdNai2kP9UKs2/6mIDipXMqz42yuON2oZOTVgZG+Tjpy3jYr5cGGUf7YmK8zlSfdov0aOSreVyBTrrB5vW3mSS58743H2WMF1M/SFDelcsDIALpDyTphcsJB1NDd/il3QIHE/b4dYGdQYSB1gjahwmm+9BLrJ5BDlEvoQZ8huS8fjR3QIA87dHsWw4X931blw1iTzI2XLZyUstOUnCyygn6w5slUol64zbCqCgQ33A/64CW2d2P1wZ0xpv5hTxqdC22C4xQt6nrHuvjDBtHrrgcitJadVQS+h9is2VJowaYNkakVhvtZiH1H283GmyEPOj4JHBsaiMo3qeUq7J4TxSRDRptQJ8FkBi35uSqcuRgY9EX+iIp1sxcGc6l7YxGRayFW30UAaCp2PkdIaerAC1o0hFNyZfYJNrS+LGzA7vyxgOBdQWDDF7mMUgbI9VkoXtiSN4mfzIDakDPJFUlhBt5t+WIasIVaRwo0BZXkapDEjtJbquBO
 9/bWbqOL
 f3tKdY8dMkhmJ6crmrTn55KlJ/Ai1vxQH+fywuwbbjN7Ptx006TeC1AULBSSQr5HW3HG6HK1h+p3uQ7vQRMVP+l1qRMgOkucmUFipvKUUz7kEgxjWz+n17JlSt6aFsITr9ri36+hmxcyhiDo9GEQaEp4QfD8cjOz3D3YevJ1VcfbLvANnZcOfaw86kxmRVi1f1GGkuXDCGiQdlHBueWkaQkuojtC1ps0xapU7mZVimbH33mJ3E7TbsSATRAbQoHoFyohg6T7P7CJqP6ROOWG/D7jGDy21PPRG6zk5rYsVgxnMJQjuhi4L1pjO+it73UcyMEJ9PWbv5+jl3eeCYeeuAOW01Im9Sz/49kmv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 21:30:59 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
> remaining straightforward VMA flag tests scattered throughout core mm, HMM
> (and its test module), DAMON and the OOM reaper.
> 
> No functional change intended.

Thank you for this nice cleanup!

> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[...]
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -240,7 +240,7 @@ static void damon_va_walk_page_range(struct mm_struct *mm, unsigned long start,
>  		goto lock_mmap;
>  	}
>  
> -	if (!(vma->vm_flags & VM_PFNMAP)) {
> +	if (!vma_test(vma, VMA_PFNMAP_BIT)) {
>  		ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
>  		walk_page_range_vma(vma, start, end, ops, private);
>  	}

For DAMON part,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

