Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD89CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 20:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6128E0048; Fri, 10 Oct 2025 16:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856BB8E000A; Fri, 10 Oct 2025 16:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746438E0048; Fri, 10 Oct 2025 16:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63DB58E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:20:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5D4214047C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:20:41 +0000 (UTC)
X-FDA: 83983322682.14.7575DC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38C6AA000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:20:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ndUXUFIr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760127640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44S4HUU/AQh1f5II8gvjr0MywuiUNWIQ+934btjm1wQ=;
	b=r9X7DfZ62wPcMintrEUk05yBOc5aDLJJCFmjmrWby8T//T/FZDxqmp57JLBcqR1n9MXyFO
	1IdLUDFZFDHFwwdfZ33cc+LGQGHZ7zVWGVNqam1+b+sapP7K6IqRgQ4NSFWRoHD80EqF5b
	6kRp27mI6MEFVmIWesOJsqm7tpNQXUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760127640; a=rsa-sha256;
	cv=none;
	b=k9sbI6bmE2nuB/jdJIpNO7sHryLfJQog+fDc+i1kn9Zg42R2KMxrF3fmCqkU84qDdvwq51
	KtwtOoitY1XbYqkSX2RFTgkgAQqpjvX+Cb1NDI1n2TVvvKMJoqQ2Q1Wk8ixVboLfLB0cvV
	4A+Bqm889QIZNOo/myFrWTaoDpHvbqg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ndUXUFIr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 043CA417F3;
	Fri, 10 Oct 2025 20:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9D9C4CEF1;
	Fri, 10 Oct 2025 20:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760127638;
	bh=uVkz8lpHC9sRqbxmG0cbQgUT9iFYMlmYAvK7Zotg0qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndUXUFIrDC4sy+YuQodWLx1NncOMGEi6Ntd5aZvhTNWsNDQaAPxewqEYUeMV09/Ku
	 YRH+TZg8HA/2chtSyilVNZpHT53rdKAfleUV94QOMXIEa1o7By8QktAbfxOWx1ZG1R
	 1CTZEMay805+PBoPLgXOWOYA/u+H3OlmWCsx0hBKE/k/Rl5azUvLVWTqEGJ9yjLEH8
	 JpDxQFed9N0KEiiENMtfEs6WsTKSXkPagVoYOJt8bd0Wpb/p+2q5Gmu/5ihNvknD95
	 cupul+zpPbCfBdnZwS073t/xfaGc4MlUbco+Dlzb/PQzGJGOXBLwKhOeJHXCB7L9XM
	 1AFubXAW7f21w==
From: SeongJae Park <sj@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	alexandru.elisei@arm.com,
	peterx@redhat.com,
	rppt@kernel.org,
	mhocko@suse.com,
	corbet@lwn.net,
	axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	hch@infradead.org,
	jack@suse.cz,
	willy@infradead.org,
	m.szyprowski@samsung.com,
	robin.murphy@arm.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	minchan@kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH 6/8] add cleancache documentation
Date: Fri, 10 Oct 2025 13:20:34 -0700
Message-Id: <20251010202034.58002-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251010011951.2136980-7-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: gkeanw1oecfnrakcka4ge7ew6hu3ibmf
X-Rspam-User: 
X-Rspamd-Queue-Id: 38C6AA000A
X-HE-Tag: 1760127639-352437
X-HE-Meta: U2FsdGVkX19LZrpRZk95+zRNcbpSB2tOTe7+Zszfpa9W217RusFVpe1+zTS19msKkMfmoPennvUU0dsznvB9nixtvjMUq1ugPXrd67F37wJ1x3UVXv0iDahMK35wv398ojUmQsTY+GoFCmONY/8e9euNc+nowvPjpedqC2DQCw3uHvm3iGMc2w2EpWQgdS/FgTCKmpIdvY25k8//aMkzduz41Ro8tofWN+EOPpsSFklUt3/wE9vhVo5gfipdqHnifqI4o5SejTncy5yvg1rlgnJK9fnOd0qYA4alfFaGuDRTBMXHhQF2Ua/mo9GGSno6ENUYZ/iFYiLWFPartL35yrorOCnDHyRiCYPmesNdnUAlDa8rIJZArI5dNO+enn0u9Urj1Z2APStqkmafLLQNfyNHIvPpjexjY6nowoFN0Ep6QkJ85X7lK4EbtjrSVwPOm5lJLBvR5bVwa6SWPLwT6yddBUiCGaT7XLHCU0zlWfsXGOZpclltjVTKJ2znDtUCaEDmvEA7AfVa5vylk9gFcDrsy03Sx6K7gQd85EJcWHu+yzlJE6jfUnoZbz2IAjGJ2tqd9XlaNNdwBr/UNg3rZpjlsFZ+7HgFgAsYuYsV3QRfgvcyp60joilNZFMRCTAB3Dhm7m/q40KiDvZ8ga+tYAFNE2L3Hb7lwEBk/Nj0oTP/uCc42w+7N3sY21hXT0p+gDOaPXo9WdbyDT2uyBrXGLh8LCwTgUTsbWNqOpJC3VP/A3V30URmpbLdcc8TlGnVaeFKJoEd8PO0dSGWSFX51CZQ2TqBdkFH+i6ExRC5P++yL5REv6J+rDKf7oId8PBAKWQ6cbKqaNOmjnLW5oSId7hH8Ro8J/7Qji3Uu2Jf8U7SoUabc0qkV5JkPqPPoMkrR13fJeCNAkYiLDG7hMAndNYfyYO5IhfT3fqwbJ0Guh1pxWNoe5m6+fwEVVvZptf42T7T6r9vS19oi1Qac69
 NOOYNrRv
 ohngze7U+7GsZTm2oqOnGFtzQdtwyUNNury7E/B2z9bZXUNxpcag68ig3nyDmFzEhneyWJH5T3WqSlcwySNtZ0QpU2J/EAg4fnKrnx6OBRShOLkbVF03M1r3UYOl/6Xx8+Mc1F5QIrJsSdzgDJ1CKgQ9+Mamh0n7hrS/Kd3a5+AlR6RdcryW9YoV2VWkzUSwuvyC1nqFV/VYUx7IJ53Mp3e+GIAdNdweNN/AI4NzdxF503fvAYmBvXnZrGrXKrJkhLKJZJK3KrGr4LyVwVm+j66vqmMUJCPa26+Pd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Suren,

On Thu,  9 Oct 2025 18:19:49 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Document cleancache, it's APIs and sysfs interface.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  Documentation/mm/cleancache.rst | 112 ++++++++++++++++++++++++++++++++
>  MAINTAINERS                     |   1 +

I think this great document is better to be linked on mm/index.rst.

Also, would it make sense to split the sysfs interface part and put under
Documentation/admin-guide/mm/ ?

>  2 files changed, 113 insertions(+)
>  create mode 100644 Documentation/mm/cleancache.rst
> 
> diff --git a/Documentation/mm/cleancache.rst b/Documentation/mm/cleancache.rst
> new file mode 100644
> index 000000000000..deaf7de51829
> --- /dev/null
> +++ b/Documentation/mm/cleancache.rst
> @@ -0,0 +1,112 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==========
> +Cleancache
> +==========
> +
> +Motivation
> +==========
> +
> +Cleancache is a feature to utilize unused reserved memory for extending
> +page cache.
> +
> +Cleancache can be thought of as a folio-granularity victim cache for clean
> +file-backed pages that the kernel's pageframe replacement algorithm (PFRA)
> +would like to keep around, but can't since there isn't enough memory. So
> +when the PFRA "evicts" a folio, it stores the data contained in the folio
> +into cleancache memory which is not directly accessible or addressable by
> +the kernel (transcendent memory) and is of unknown and possibly
> +time-varying size.

IMHO, "(transcendent memory)" better to be dropped, as it has removed by commit
814bbf49dcd0 ("xen: remove tmem driver").

> +
> +Later, when a filesystem wishes to access a folio in a file on disk, it
> +first checks cleancache to see if it already contains required data; if it
> +does, the folio data is copied into the kernel and a disk access is
> +avoided.
> +
> +The memory cleancache uses is donated by other system components, which
> +reserve memory not directly addressable by the kernel. By donating this
> +memory to cleancache, the memory owner enables its utilization while it
> +is not used. Memory donation is done using cleancache backend API and any
> +donated memory can be taken back at any time by its donor without no delay

"without delay" or "with no delay" ?

> +and with guarantees success. Since cleancache uses this memory only to
> +store clean file-backed data, it can be dropped at any time and therefore
> +the donor's request to take back the memory can be always satisfied.
> +
> +Implementation Overview
> +=======================
> +
> +Cleancache "backend" (donor that provides transcendent memory), registers

Again, "transcendent memory" part seems better to be dropped.

> +itself with cleancache "frontend" and received a unique pool_id which it
> +can use in all later API calls to identify the pool of folios it donates.
> +Once registered, backend can call cleancache_backend_put_folio() or
> +cleancache_backend_put_folios() to donate memory to cleancache. Note that
> +cleancache currently supports only 0-order folios and will not accept
> +larger-order ones. Once the backend needs that memory back, it can get it
> +by calling cleancache_backend_get_folio(). Only the original backend can
> +take the folio it donated from the cleancache.
> +
> +Kernel uses cleancache by first calling cleancache_add_fs() to register
> +each file system and then using a combination of cleancache_store_folio(),
> +cleancache_restore_folio(), cleancache_invalidate_{folio|inode} to store,
> +restore and invalidate folio content.
> +cleancache_{start|end}_inode_walk() are used to walk over folios inside
> +an inode and cleancache_restore_from_inode() is used to restore folios
> +during such walks.
> +
> +From kernel's point of view folios which are copied into cleancache have
> +an indefinite lifetime which is completely unknowable by the kernel and so
> +may or may not still be in cleancache at any later time. Thus, as its name
> +implies, cleancache is not suitable for dirty folios. Cleancache has
> +complete discretion over what folios to preserve and what folios to discard
> +and when.
> +
> +Cleancache Performance Metrics
> +==============================
> +
> +If CONFIG_CLEANCACHE_SYSFS is enabled, monitoring of cleancache performance
> +can be done via sysfs in the `/sys/kernel/mm/cleancache` directory.
> +The effectiveness of cleancache can be measured (across all filesystems)
> +with provided stats.
> +Global stats are published directly under `/sys/kernel/mm/cleancache` and
> +include:

``/sys/kernel/mm/cleancache`` ?

> +
> +``stored``
> +	number of successful cleancache folio stores.
> +
> +``skipped``
> +	number of folios skipped during cleancache store operation.
> +
> +``restored``
> +	number of successful cleancache folio restore operations.
> +
> +``missed``
> +	number of failed cleancache folio restore operations.
> +
> +``reclaimed``
> +	number of folios reclaimed from the cleancache due to insufficient
> +	memory.
> +
> +``recalled``
> +	number of times cleancache folio content was discarded as a result
> +	of the cleancache backend taking the folio back.
> +
> +``invalidated``
> +	number of times cleancache folio content was discarded as a result
> +	of invalidation.
> +
> +``cached``
> +	number of folios currently cached in the cleancache.
> +
> +Per-pool stats are published under `/sys/kernel/mm/cleancache/<pool name>`

``/sys/kernel/mm/cleancache/<pool name>`` ?

> +where "pool name" is the name pool was registered under. These stats
> +include:
> +
> +``size``
> +	number of folios donated to this pool.
> +
> +``cached``
> +	number of folios currently cached in the pool.
> +
> +``recalled``
> +	number of times cleancache folio content was discarded as a result
> +	of the cleancache backend taking the folio back from the pool.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1c97227e7ffa..441e68c94177 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6053,6 +6053,7 @@ CLEANCACHE
>  M:	Suren Baghdasaryan <surenb@google.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	Documentation/mm/cleancache.rst
>  F:	include/linux/cleancache.h
>  F:	mm/cleancache.c
>  F:	mm/cleancache_sysfs.c
> -- 
> 2.51.0.740.g6adb054d12-goog


Thanks,
SJ

