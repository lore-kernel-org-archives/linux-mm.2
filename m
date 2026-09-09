Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 940E9C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 03:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B184B6B0098; Tue,  8 Sep 2026 23:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8476B0099; Tue,  8 Sep 2026 23:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A050E6B009B; Tue,  8 Sep 2026 23:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 860736B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:02:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17919A0867
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:02:45 +0000 (UTC)
X-FDA: 85192726290.25.2D22459
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 78B971C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:02:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788922962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xQC+PgI8Y5//qvtK1W6gj74UDgLgWDjILX+LO/GHtjs=;
	b=aRIl5FXHQDNq+nwamCCiCIuCyQkCfoqfZXwbq0VByytRBu1J7oln7kFmdIJClp4wYgvYgF
	W3i9OAeW1D1Z8MiFVjQsKECBNOv+mZfR73UDjgAUatUhUpRogiHritSKLL8twO3t6hoohU
	b+f++BIQSiAY1SByJ+DoHcakPdDrwCk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788922962;
	b=cHKOi69LNkARn91zfoY9oOWU0zHRzvhQPKNw9tmK2pzSQ80UB6GO+JfsfCHspK6oNGbTM4
	2rSxiTFLlSW1Vzcqnd+wIyqqqDG9iuWJq9zZYJj8T4TGP5yz95AwxCA9epDyrllwAVB9o/
	M5gc/TcOJpjzG+tktHlMstOS2/gpxSw=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hflwX34ncz5B100;
	Wed, 09 Sep 2026 11:02:36 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 68932RtR001931;
	Wed, 9 Sep 2026 11:02:27 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 9 Sep 2026 11:02:28 +0800 (CST)
X-Zmail-TransId: 2af96aa0cc44b03-7eb1b
X-Mailer: Zmail v1.0
Message-ID: <20260909110228828hKTCgUeuZkOujOBaVtUcL@zte.com.cn>
In-Reply-To: <20260909023507.1408925-1-xialonglong2025@163.com>
References: 20260909023507.1408925-1-xialonglong2025@163.com
Date: Wed, 9 Sep 2026 11:02:28 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xialonglong2025@163.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <linux-mm@kvack.org>,
        <chengming.zhou@linux.dev>, <linux-kernel@vger.kernel.org>,
        <xialonglong@kylinos.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzFdIG1tL2tzbTogdHJ5bG9jayB0aGUgbW1hcCBsb2NrIGluIHRoZSB1bnN0YWJsZSB0cmVlIHdhbGs=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 68932RtR001931
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 09 Sep 2026 11:02:36 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA0CC4C.000/4hflwX34ncz5B100
X-Rspam-User: 
X-Stat-Signature: obdiq3y1ou3yxs7b6c8jjqdgdqy13pr5
X-Rspamd-Queue-Id: 78B971C0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1788922961-808705
X-HE-Meta: U2FsdGVkX1//92axjYfrymo1e57EqkEXTy9d0HERvulb2/GmmCNbRiHxjCxaZ4B6ZKB5AeQSmMj5EGyJ/TMmERaQsnzsDUzNptopxkeTeI89AS+Fxwq9THdKQwOsr3MK5r8trMb5MweK4TYUvgaqzCFENZHUPnqMQa8fGoBy6Yia7p0JuREUydpEDYi6cphjzGjw+R2QOuhkgdK7BOcit5uzN38q9HgeUd7RRdRGVti9B241M7HUaS2mls4iqmuhcrP3OMGYIthfH50sCX0sToVFUhRud4aYnG3WGbcluI24HdrE9RB5exVFxEMNEjt/TvaL9+pdUEiYHa7KxIb0V2UKrcU5R6AFSz+tm7n3OOhGPVoqBQ6wd3t7qiRzQOV/bhAMzsh97LK4+LAOux0bcJp8tj7fbO1vjypDlKdVoF9FmLacKoPh0VYEBEinHksnUqBLQZkhmUhhtDqozwau0raQx+Y/enZGK8w0oMWF/0r0X3e/iqP/jkeEgUxzHa/CyeLRw7uAUqb5q4a/jtWEyHfzpMhcHAKQfa1WJ9Z7Fnix0NzQcapiTlcdFuYeifQZDgCfth1cUQybgB2R3gNPbiTm8v1SVaNXIw799aRzOPUhFMtYEsUaVSVjrMY1MPatuCwkXMVuFR5MB7JZrYo1tU0kuf90kE5L17ZadQORcm+Pg+a1bZ/Jh8WBwKYxBrWzncxzaTdhAC08gJyEqEbccSGeoz56DzaEd/N6jWZtXxoTj2Xs1wpz3lsK8BSrbP9HkwmhEHONT3/5YldIwyqIlpT1cHsKLFaaJn6+EzUtHCA6enUJYar6tvTujmOobgAAq4Fzau8njL2vaHW18pJEyLcsYu55mIr6aU54z5eE87AZgR0KKYolbb++PllVewhfRmkdfnnQ09bgK9YxvX9nlNUGON0PezbTaWcBFzhvyKYQw8AvOrUGb+x05Adq6qrO4fOET/2IXmIZK19xwPd
 EyDugs+K
 Ldjeofd8v/mq4jsWHZZNbFqcCR4LK3hYCuy6eDPlBzz3Xn9uItlBbSLEU3Wz6+OW8Me5gibplV7EAOLohr2/Fk0dPNqBBk00FyhJo6T9PiTPe6nsuJwApHZr4CrygdVRjeTsEMxZJgRYzjjGvNp2spf5g9SgJsc7dc7rR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> Every node that unstable_tree_search_insert() descends through is
> revalidated by get_mergeable_page(), which takes the mmap_read_lock
> of the mm the node's rmap_item belongs to. These are taken while
> ksmd holds ksm_thread_mutex, so a single mm whose mmap lock is
> being written to - a process busily mmap'ing or munmap'ing -
> stalls the whole scanner, for every KSM user on the system.
> 
> Use mmap_read_trylock() instead. The trade-off is that pages of a
> contended mm may need more full scans to merge; in return, ksmd
> latency no longer depends on unrelated mmap activity of the
> scanned processes.
> 
> Testing, on a 4 vCPU QEMU x86_64 guest with ksmd at
> pages_to_scan=100000 and sleep_millisecs=0, 5 runs per kernel
> (median reported; baseline is the parent commit):
> 
> 1. A contender process registers a 64 MiB MADV_MERGEABLE area of
>    unique pages and runs two threads looping mmap/munmap of
>    256 MiB, so its mmap lock is held for writing much of the
>    time.
> 2. Once that churn is running, a quiet victim process registers
>    32 MiB of 2048 unique pages duplicated 4 times.
> 3. Sample /sys/kernel/mm/ksm counters and ksmd's /proc stats
>    every 0.5 s for ~2 min of churn, then stop the churn and
>    sample until the victim finishes merging.  The same phases
>    run without the churn as an uncontended control.
> 
> Results (median of 5 runs):
> 
> - contended ksmd scan rate: 11,473 -> 58,397 pages/s (5.1x)
> - contended victim merge time: 10.4 s -> 1.7 s; the contended
> - contended ksmd CPU per scanned page: 13.4 us -> 3.5 us
> - ksmd time in uninterruptible sleep under churn: 78% -> 57%;
> - uncontended (control): merge time 0.65s vs 0.62s, scan rate
>   259K vs 247K pages/s and ksmd CPU 3.9 vs 4.0 us per page,
>   unchanged within ~5%.

Sorry, I'm not fully convinced by this approach. The performance numbers
indeed show improvements with trylock, but I'm not sure they translate
into real user benefit. Users typically care about how many pages KSM
actually merges and how much memory is saved, not just how fast ksmd scans.

> 
> Assisted-by: Zcode:GLM-5.3
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/ksm.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 49d48d1e0998..3cfb09a926ff 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -820,7 +820,14 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
>  	struct folio_walk fw;
>  	struct folio *folio;
>  
> -	mmap_read_lock(mm);
> +	/*
> +	 * We trylock because we don't want ksmd to wait for an mm that is
> +	 * busy changing its memory layout: we prefer to skip this page and
> +	 * let the next full scan retry it, like the folio trylock in
> +	 * try_to_merge_one_page().
> +	 */
> +	if (!mmap_read_trylock(mm))
> +		return NULL;
>  	vma = find_mergeable_vma(mm, addr);
>  	if (!vma)
>  		goto out;
> -- 
> 2.43.0
Sorry, NACK

Also, this change feels a bit too blunt to me. In scenarios with even mild
contention (far less than the heavy churn in your test), ksmd could end up repeatedly
failing to acquire the mmap lock and thus fail to merge any pages for a long time.
That could hurt KSM's effectiveness for ordinary workloads, not just the contended ones.

Besides, there are lots of mmap_read_lock in one page's searcing and merging of ksmd, such
as try_to_merge_with_zero_page, try_to_merge_with_ksm_page and so on...

I'd prefer a less aggressive solution that avoids stalling ksmd without starving page
merging entirely. Maybe considering it together with smart scan? Need to see other
suggestions from other maintainers like David.

Thanks,
Xu Xin

