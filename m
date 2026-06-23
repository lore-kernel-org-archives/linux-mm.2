Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C52CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3926B0092; Tue, 23 Jun 2026 13:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E626B0093; Tue, 23 Jun 2026 13:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC686B0095; Tue, 23 Jun 2026 13:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C17696B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:36:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB97C8F9E5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:29:06 +0000 (UTC)
X-FDA: 84911863092.30.4C591D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 25B2F160011
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:29:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+A9Dyhi;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782235745;
	b=Aac0AqiSsMr9WGYf4V7WBMoG4n5G32hrFu9dkGAvXYDonQEgAK7yD2SMV4HOYkXggRyjhe
	QKRPrf4r/NkVMNlYp7rJOnPhuSns237fCerOWluSN8iyS0aSTLm/IZr4ZNjado0DuIULx6
	kfoUMBVt/zfyJkvwBMZ6XUZqJMkNqzE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782235745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wy+blSt5xdCwchobAX7ZrvH2NCFjXYGm/UFwJUwBnm4=;
	b=Q+/fpwnHyDfFADdUhqNwGd8ufwDZzkZ+vDVLS52zDA/0iVg2F2cf7NWDOI+YAqkMdSVEnl
	TPCiG8y1knkFE3R7hlrdInSctSb00AmMo3ZDtwiXiIAME0Cl/9CshLg+ojUg3UmgoAjqbi
	s2VrqxyUkyKSgIVc3fb+q7GPQARMhWo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+A9Dyhi;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 892CB60210;
	Tue, 23 Jun 2026 17:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ACC1F000E9;
	Tue, 23 Jun 2026 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782235744;
	bh=Wy+blSt5xdCwchobAX7ZrvH2NCFjXYGm/UFwJUwBnm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d+A9DyhiU0QEnMXLzKvsOFJugbfK+126pc5tl7z3mzF0WWFMGZCMZWr/JbfzVoi91
	 W4H+61ZYt6tKEUOgEWsQL8Sa41B1snb3BmYBIPp0xB5oOmyHOd28tFSptLQG3s6D8y
	 tDp6x9dj9FtSIrJsCujVxSvKwnTOwMFNlamej3AVOmJz9MLKWiwJAc7Y5xzOrIz20w
	 7i8lria7zrQccSkIL8TusUdr7xy2p3Y1iAxKklrDvSN8GBqzMdUz9UO5CBqXP2o/JX
	 hYXj+0TyrRzPXdnUiXxVXKWEax5CCeYrruxSK1fLEbZH+x3CTd9+NsgezxqerWlD3G
	 piWILdNijvcnA==
Date: Tue, 23 Jun 2026 18:28:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 11/13] alloc_tag: Move to mm/
Message-ID: <ajrA4wiAKTdiraEO@lucifer>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-11-31f31367d420@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622-alloc-trylock-v2-11-31f31367d420@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 25B2F160011
X-Stat-Signature: ry5uuo8twdhcrtqnuckpdnaksp8jfofc
X-HE-Tag: 1782235744-734230
X-HE-Meta: U2FsdGVkX18zUgXjxNGqhi9iRA2EgKH628KDDXs3yV+0Fh0gvHyxXG9oeEXWc52Jy/ODhyxt9y6tRacvz0E4BT09A7rpCRqlFqO2v5s38zuOhlHkNux0gChZhY3A9lJEGydynaNzuDBdaLYOnNLJBPwaGfxwqQrqK3Xx9FJENimiyzRp3Jw/awm1Q41jxMNFMr2KCbTVJ2ZKOH48UDlKBx+cSzfEKwEfxthEvGeA77SlaqtzWTzG3ttPN35BQK9Jq7tV+3EbyBd3XaAaaPV27V37PM+/Ap9GpQN7bcfGsWFB7ElSgUEk5DR11JCdD35ebK0SLSCmSEztcrRg1dhXadFD99LPKASfwjNdluWE9gq6aHQ/AobF5A1uIZ7QjIMYitIWGqTpWoBCtYaBBaYpiRNCEL1AoXe9hO4k664sPbiG9Hh5tGxmzOQwWDA/xRpIKBnsIPawkPxnAlmrQHnQpp13kJZIjCQFhtybV+pgR7u4HSAkOKE/l67MxbnC/mhO3xuoOHpQFM1Q3wTFarjEAoXJuGnP4SsuLhRV20HruiRK+JRAvEkJok8s9k8BmZWXim/3FGhWLBl+rsxa9d53mSO4ySx/S+CKkrhlV6Z4WZQCTEJ84j5o6CZAzYzW3zEDU39HMZ1e1uYloE/Q1B+iwVNQKz+fw6MYu6smha25Y3Ec5XAsJkp9xCywC85AX8lpMOD5t8oa0kubuIh8EeMsn3UUfToj4tNuMBabPpXrlZguVZv1WcApSw8kXpVHOmkgcsre7Wt3DnsDbITUKO3G9qeMlUYOdKu4AlfSzfQpyO+rhuATNR/MlG+nVDT6pYaSDWKi7mt09dV3nO2S4WXPyQ49ugzPAZHBhPmLQ2bpEgqWyjGpmLbV1skUkgg27Pcz4bloR7/0dT81gJaH/CrAlHNA19VMHQmwGUp0EQeshCedACJ1ojbL8a+SQT3BK53KVTtSjQY7+QIc/it7X1l
 4vs9PpIZ
 48rVtv4RoYrQUFTYxiN91c3nXkw9htOnv/e2Btbi74ytWnMiBRRnEophUzVRf+Z96TeIKSLhnWnSaEdclXwskZyPib3GyJfmhktFL/uohHqopcpsQI+C7l0brPylEwrfNkuXLg9f2cD8TIE/rlAHqhKfTtNXy2wcNV8nU81Va4/M1qCAwYf4nragLLOuFbWGdkFalAUJBYvjO/U9S1lc3h05vbUWpkqf8622jxYPMXkNh7foZodgXwyvPtx+Bluc9Eu9g7gLIXGE92LsBsJH9UVY2HZ1K9cxrw2VY2ujfi71rm3b6D9HWm+9n1L3DTbKPaXN7tG1ZnvKIdXBdeZGcmuJ7i/EsVXZFog2OSdX/xQxT9BYatcCgsLbeKrIaXbNMyuL26g8Pc6KWbH546X8EW9Ud1JavIoPOZq7bB7CBtox6HxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 10:01:38AM +0000, Brendan Jackman wrote:
> This is logically mm code. Moving to mm/ allows access to mm/internal.h
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Sorry to be a pain, but I feel that this change should be dealt with separately
perhaps as a pre-requisite to this series.

Thanks, Lorenzo

> ---
>  MAINTAINERS             | 2 +-
>  lib/Makefile            | 1 -
>  mm/Makefile             | 1 +
>  {lib => mm}/alloc_tag.c | 0
>  4 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 65bd4328fe056..5d426b79b8fe7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16713,7 +16713,7 @@ S:	Maintained
>  F:	Documentation/mm/allocation-profiling.rst
>  F:	include/linux/alloc_tag.h
>  F:	include/linux/pgalloc_tag.h
> -F:	lib/alloc_tag.c
> +F:	mm/alloc_tag.c
>
>  MEMORY CONTROLLER DRIVERS
>  M:	Krzysztof Kozlowski <krzk@kernel.org>
> diff --git a/lib/Makefile b/lib/Makefile
> index f33a24bf1c19a..44f6538533a97 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -197,7 +197,6 @@ obj-$(CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT) += \
>  obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
>
>  obj-$(CONFIG_CODE_TAGGING) += codetag.o
> -obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
>
>  lib-$(CONFIG_GENERIC_BUG) += bug.o
>
> diff --git a/mm/Makefile b/mm/Makefile
> index eff9f9e7e061c..4fc713867b9bd 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
>  obj-$(CONFIG_EXECMEM) += execmem.o
>  obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> +obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
> diff --git a/lib/alloc_tag.c b/mm/alloc_tag.c
> similarity index 100%
> rename from lib/alloc_tag.c
> rename to mm/alloc_tag.c
>
> --
> 2.54.0
>

