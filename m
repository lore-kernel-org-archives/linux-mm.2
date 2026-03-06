Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6554AF513ED
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 01:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929686B0005; Thu,  5 Mar 2026 20:35:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D71D6B0089; Thu,  5 Mar 2026 20:35:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E22B6B008A; Thu,  5 Mar 2026 20:35:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A02F6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:35:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1488713A6C6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:35:03 +0000 (UTC)
X-FDA: 84513919686.11.8B3D217
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6893E140007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:35:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rnAvm6H/";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772760901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ULI7cKyU7nnWxUomCevQkEMcH/zpmi9DZjTx1aBGmI=;
	b=200J+BfnoXBJ9KgSPsqP9l0iRFAcIQFyVZw/8OQqsDn3Egv4rs+rp4DvDZHtQFnkox7y7R
	s/f1Wdnyf16nRayb2E2rYOfLJd/KmGsCZHIeROpj716YkxMtDFMhDeXBjfsMHttYTY7xVA
	XNgQ/6tvuA597pU9uLtaJR9TlJH7llE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rnAvm6H/";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772760901; a=rsa-sha256;
	cv=none;
	b=JpAydCs/J9NUKe/k4fJQIdsywNpjeCHPixrZ9YSzaZVeRsyjBaltUPwjgFdr30chwoV5QG
	2hD2HyIUpOfXT8ch9KJY8jAccX8hU+OC2Eos29nwbourf7PVZY6xlWPR2+cY5onGevW1hY
	aNJgn8QczemXHeaj5RYDVGF7lCeMntY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6761F4380B;
	Fri,  6 Mar 2026 01:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6952C116C6;
	Fri,  6 Mar 2026 01:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772760900;
	bh=n7wt7hIpUgkpLh7qrcxUyR5cI+SSH/bMqKvGx1mkwaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnAvm6H/9/6nQ31YB8F3dc7VDZGZ5nT/rU/nIj9F1XGAoZcC29eiEWk3ZXprLatwK
	 +BMvmVA4CocRRnQtFkjxyahsXYCWz75T57OOQkTBY5xz6LlKm2OTgCm3UtcK6ks1fG
	 4N/h+T2foaHhxy58VSlDOxWlogJgVfkIC1CxSe7c55WNltuF2iO+ouFVqCRtVvNlDd
	 shZOq6GYUT2PKMLZ/AZP8RxCNaOPR7A7pm27TmbhbMmYYh6EJSI3tA0eleVziBiRLR
	 wetP+37/4k9r7N3mbAZgYw1YOrV9Lm5lfTMqLeCrqMt+AU60znV25dM5m7GrAGH3Ie
	 3PPW5rIi5X5tA==
From: SeongJae Park <sj@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add mm-related procfs files to MM sections
Date: Thu,  5 Mar 2026 17:34:52 -0800
Message-ID: <20260306013453.90906-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6893E140007
X-Rspamd-Server: rspam08
X-Stat-Signature: 6bd1btbfy7y8xstq6eu7wgn4t5wn9yi8
X-HE-Tag: 1772760901-514467
X-HE-Meta: U2FsdGVkX18BJuKtxcyd96mMNmW/xNJnQ516wFHEbzzZbz+x33SUi44PrpzKcdofe5elpgAfiFhUrp4gERk5yDrSqp+RWdlYsSsostKzcyXNPG++hBoSY6NWFDwToPzVbFSVkTGgezFdHApLDjZ9R6Yymu2Ox+p1pGEo5I6FLpsvluZmTm9hcvRm+E0J3eQSV3JhGV6ehtnJa9ufg5MBKvEdMWP6W/YXuYEK6dirLZGLp29p1SzVvlIJ8PaiY6Fz/+ObWVB2fW7quBFgzHODYEB5NO+pmqBqEQUduW6wgbXWf/+FdxucCPwDv6GW/qzRRF5pkAM+LWKm0XIzMfZ945clWk+371Yrf6J2lnxTAUcHh3aoh9iRg+DLVGFojjgfWPywrPoCnjV7aJ1w7A/Po2oa9oZ65oKAejci93YTA7CD7zmBJZDVEvi/QsZDoz848RTGbvrMHyWP8fkGdx+LXDY4oUOJWa8YHwEankbMpD6bFQ3zQ2/vWJyUTxj+xH1Tsmo532WZHiRuQyPuxAjWHseHehD+YkJQgRRCGqSIH4chMaRA+rMNbGx+MhBV97ynn0/kHy0z6eMGH0wTH/jNDskEpHWqQ7xVvXrBH6yVrbQcEMcYzvnUcLq3+YOUr5sK5vlCU8NhALPBhGlZaRSfsM15ns7cNMVealjYX0VlJcW5LVhzrm5l6Gi2nVdTitzpSQetJdeckLcm3oc0IJ4wIWjyuAau7JXqa7xgs1ZpYFFxaYHNDgZO3j6p4F14hB21ITDQKePTCajQ0UHdm/M8CufG6FSHsYG7LywSy4FiFEBs93P8ARVLP6XibY3BRCUVdPDD1c+yAwAreDOoZx3tQoTfKxOYvfiYUnMIOXmhBzwmqoU+NdiQ9GCXBFSmp03bfDnO9VHeSswB015dRxFJ12vn0aRLk7NJEhQp/qS60WrP+iSOn3KqjUHS4PLX94fuedhVEvNeQEWZImgk5rL
 bvh62VIT
 zRKvEFzTkuQqW80YqDMUhRxN9VyeZEAcVwHQV1otRpOV6kLF6ABYng2QeUivQLz6s/JIaSrF2L+q6eybYlNF/VUZjfPRRtCFe5YR4cMm6oIQxuBlDsehsarzF5cEjn4hcXER+xnzzxcTrZqGF2YEE7T0f61B0XPEcaX8FJyba9tp++f2/WNMlbo58HjV4s7L87IlvDa+Tvvp4POEVX1BtUr93q1Od4132ulCMI6W1j7iV9/IwIUWyTW1QXGxXWpyjZgZiuFQI2HmO45uE7GQ3O2RbF8OvXxX/BXGF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 05 Mar 2026 09:26:29 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Some procfs files are very much related to memory management so let's
> have MAINTAINERS reflect that.
> 
> Add fs/proc/meminfo.c to MEMORY MANAGEMENT - CORE.
> 
> Add fs/proc/task_[no]mmu.c to MEMORY MAPPING.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

I have a few trivial comments below.  Regardless of those,

Acked-by: SeongJae Park <sj@kernel.org>

> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3553554019e8..39987895bcfc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16683,6 +16683,7 @@ F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
>  F:	include/trace/events/zone_lock.h
> +F:	fs/proc/meminfo.c

Should we sort files alphabetically, and hence put this before 'include/...' ?

I see a few other MAINTAINERS sections including 'MEMORY MANGEMENT -
USERFAULTFD' are doing so.  I have no strong opinion, though.

>  F:	kernel/fork.c
>  F:	mm/Kconfig
>  F:	mm/debug.c
> @@ -16998,6 +16999,8 @@ S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/trace/events/mmap.h
> +F:	fs/proc/task_mmu.c
> +F:	fs/proc/task_nommu.c

Ditto.


Thanks,
SJ

[...]

