Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A18C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1A38E000B; Wed,  6 Aug 2025 12:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7824D8E0003; Wed,  6 Aug 2025 12:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698E78E000B; Wed,  6 Aug 2025 12:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8918E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:20:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E58A681B45
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:20:31 +0000 (UTC)
X-FDA: 83746845462.19.EFFABBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 425B3C0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:20:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jDUMjS94;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754497230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pV7nQC4Wd2HBM+qenTuYikvzGoaPz/u8MVaXDGiHG4=;
	b=VMtAu9A3ma/DOwndQ8A8e1wn0y5uEpeSo7/wjKz0DXRVPR404fuEOHh18Dojg9qUnCibg7
	BxCNDyLm4nMzeEGqDOgPQCmmnWLV4GmTJ9PsNjRp6y0LxAVIbmOkrhhLl29BUM7D9PySR1
	/gVXmdD7WOyQ7xPYCIz9T8bB90VcImA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754497230; a=rsa-sha256;
	cv=none;
	b=VD6/oUWebP8BBmYp0PPJhxH7aUXKW0v5QeyTfQVR1Psvv8j81OxrbFLtDoN4Kv0ua8VRGh
	gm0vsHeB2S8IGQGiJhJ12v4ibR6/9I7W76U+Uhu1cy2VHJkCxBRGd0oLJC7iggNVIxfWg2
	mck4eQWUt+oa7IvtuGef9VdhQmyixtE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jDUMjS94;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5C8D4352A;
	Wed,  6 Aug 2025 16:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CC0C4CEE7;
	Wed,  6 Aug 2025 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754497228;
	bh=YzNUeRz+7NioewNCFAm3H45FqF6Pb+PeV+gi/hYZbgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDUMjS94sgJQAZ5W00DgCyGrAW6+Trt3W/gI1nOMamwgPl56P6wr8/GVQ1HFmmZjH
	 6/LQJm5zFpFitXGcP64l/kDbGqCyCSIbTdHXJJz0FA6rwLO1OhMpTVBjWd26RbU1Qa
	 20wai22oS/gPJVFvG89ocT6IJ0oI05qIrHKdXFnYqaZOF5QRTaJkWdRZ5hj1fa89hp
	 u5Wz+zXci6GN9FOdsLo/Qh5CN3RzSoQbUJ69nL82LVeJvGpzQCVq/M1Rs1RsA8+bfM
	 L/V1FCago4T+cQ7LdEkoCb3ZvWVNk9Kms5F/YItBmwN2rwQlHcB0yKEZgN3e3B1rty
	 wJ6bribMzvyPA==
From: SeongJae Park <sj@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	david@redhat.com,
	vbabka@suse.cz,
	peterx@redhat.com,
	jannh@google.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	paulmck@kernel.org,
	shuah@kernel.org,
	adobriyan@gmail.com,
	brauner@kernel.org,
	josef@toxicpanda.com,
	yebin10@huawei.com,
	linux@weissschuh.net,
	willy@infradead.org,
	osalvador@suse.de,
	andrii@kernel.org,
	ryan.roberts@arm.com,
	christophe.leroy@csgroup.eu,
	tjmercier@google.com,
	kaleshsingh@google.com,
	aha310510@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/3] fs/proc/task_mmu: factor out proc_maps_private fields used by PROCMAP_QUERY
Date: Wed,  6 Aug 2025 09:20:25 -0700
Message-Id: <20250806162025.82266-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250806155905.824388-3-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 425B3C0002
X-Stat-Signature: ym4qsrwjff5jiy4s5ihmkxj7jmjkfcsa
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754497230-942143
X-HE-Meta: U2FsdGVkX1+1I7mV6n2XYeNEoBWdc7yAWgbZBBi+dGldHHu+cL56O1fOQ1xsA68DiZMgmXD8iOXxe4kVeVL1xlQC4VNfBHXIK9kec/kMZqX0zA4lY5Y+b0h9KrKegzjFMisws7Xwu5dVkvOuCoygOx1HrvPm7p8Il1rp0j3ltzRdjT3veN//5IOW2spzUb1wAULKIs2UMhH6DKfsrAxxsYWc6eG5ig0XtbPGW5eiBbbEA4tRGK9oamN9vPzQhusHZCyQU8NBMxGt7m74F7ZU8KlQYh8dJYL5P9ALNrGkZGCpEm62mTdpTSqLoNEiWLpCDo0Qo6KiEOg3rYSTdasa9JBJHSbNPsnDP6MxJv61Xd+veYYs4dEbXA+zqMHhEIBY3olrR9pfIIElzf5V8+XrT03QbBagxSct9WgWbKkO8ig3PYQZG7uwZY5NlQ2Tld/ZCfz7d+RITbVBI5XhHcQcUBrM6BDlhIUh2KW4CnW57q+9Ib0CEojJzq1GJk2eAMn3T8xokKRC+970PNHbHXlnoZUaM2Tbtz5la7/0bklDcfhVtJbTVOOU2DH3T5gpDRL4hRSfPITlirS+NlC/wrS+wXIDK6lSaDqGJELm7eiQ+H+5lHKpo1W9Rj2R7q09NAXZ06IkpRp7BxP9P154gdGScjGUJdBVdf6DnocuISdqqBndBJ81PT6/w+af2g2Ia/NpEjagErwIezlonypHxKDn2bPtkhNcew8ZAhGRvy6JFPOb7dhn62IMdzawOa4RNokgHem9jaPGES6IVtnwNKMDrYfA7JXtyIJKzNolEZVSHdtSIyKxE60qJhtjCjR7sjVSi4fur+iaGhmASkswtz7FONXHQK3aEBJvjpxOtGJbIiYPxDEtxBPtz+o/9O6bbNTO22gW8njgVtCXFVOUWYgFOZEVbAGM6MyOviaYJ2+I8gQsKyvXGtJAZm1yH0fm6AWH2cyHg1hfP2h48fIgu4L
 XBdlgeYF
 XMef2jmA7jl8eiDzp+KuoXpyAkqh+50jguXEmxV6XkJBlbUKzfseUlUi+pOyw6DIxXI3t0LgWFu6IeZYJonhiiHP0tly0HDVbJO1tlfotaHDMcFfzgHFhNSIxKXdh2KVatrYDOKWZ3Ane0RNYX0cD9LAsSCE0F6c+T3MpltxDjFG6VpakPFuw0FR5C1uI9n6L+9iXbW0ZRT+xexeL8PR7yypdETyCwEmeieTYF4BsXtHbiAKirGjYSqMV6i2LLtidGswQsUltVTiW6FQiBU3VqSujKYSf1oMoJw363nWKXHJvkdHv5scK58m9Cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 Aug 2025 08:59:03 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Refactor struct proc_maps_private so that the fields used by PROCMAP_QUERY
> ioctl are moved into a separate structure. In the next patch this allows
> ioctl to reuse some of the functions used for reading /proc/pid/maps
> without using file->private_data. This prevents concurrent modification
> of file->private_data members by ioctl and /proc/pid/maps readers.
> 
> The change is pure code refactoring and has no functional changes.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

