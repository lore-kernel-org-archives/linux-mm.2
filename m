Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E925606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BpDzTjQn
Received: by kanga.kvack.org (Postfix)
	id C54656B00EF; Sun, 22 Nov 2026 22:55:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C051B6B05B2; Sun, 22 Nov 2026 22:55:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C7B6B05B7; Sun, 22 Nov 2026 22:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7449A6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:55:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F063C1C4044
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:55:41 +0000 (UTC)
X-FDA: 85465019682.11.749BEDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4B68440004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:55:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpDzTjQn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795406140;
	b=lA/pCVeXQJgBJm7s2aRvDCptfM1hll+NzqBsejDEHqTvCEO+aqC6hOYO0dhvRi80kNZacr
	w+8zObm7TwLTwUzxyhUMQIQ0ItcmMEcU4zYa8GKIfI3hS1bgXfPzhtA9L5nbp8A3TyMXOa
	tXN2egkbN0TG3JT/213Gj+xt7WhOKjM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406140;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDC7GSL0dchLiVXwsqrj76NMRK83jS7U69Gwx11vmZE=;
	b=rZIFl43ovOCQLIZOiiBSd/IB0tX9HGpBxs/p/J+8C1Vds8PyZi3LlQXRq5SWgo3kUbOeDT
	8mceMdImcM+91vCggMZfPvSvLyCEbSRvSB3FXgAPNtQ7D7bwwbFNVpRhTMPnA6AqXooKMM
	itMuHRnH/ACMadAcaNIAXk63cFyglj4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpDzTjQn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 194D141413;
	Mon, 23 Nov 2026 03:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1001F000C0;
	Mon, 23 Nov 2026 03:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406139;
	bh=mDC7GSL0dchLiVXwsqrj76NMRK83jS7U69Gwx11vmZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BpDzTjQnbQWequB7HY5NLNfdfq4NmRyIkQIYV+2IuL8nLxWNMXJ32e2FlAmYOJz9K
	 7QmyF3Ct/C3iHPeLOr7m5Wb7CyGZpzhOVfX2pCxMKf0pfIZ+Fr0RoDCoiGhohSOoAw
	 4oU4FRj+qJ9CE9UTNfBjlE8vB3LbE1Lu2+2rMNmfK6i/4P2REAByqauZO7B9LS4q5u
	 D61kASmEONOzMQNDb0KTjz4z7nmJC3/DfRTkR6QxFOId/elUZhDsDA9W/hI4R4+0KN
	 tImW0R9jRZ+OxFvclAzi/fkKqtafR8r4lwwAPJBznjCaF7/rYEgBYKsxomD/zZqkqy
	 pcPr1gEkfy1kA==
Message-ID: <sashiko-outbox-228621@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] zram: keep the hot statistics per CPU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Nhat Pham" <nphamcs@gmail.com>, "Yosry Ahmed" <yosry@kernel.org>, "Hongfeng
 Chen" <hongfengchen@xiaomi.com>, "Brian Geffon" <bgeffon@google.com>, "Minchan
 Kim" <minchan@kernel.org>, linux-mm@kvack.org
In-Reply-To: <8f0ec29c0e4230d10db088d29f79bba17c3ee6f0.1795403342.git.senozhatsky@chromium.org>
References: <5666c1c8c04998784c81fc8fe751e35aa40af578.1795403342.git.senozhatsky@chromium.org>
 <8f0ec29c0e4230d10db088d29f79bba17c3ee6f0.1795403342.git.senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 03:55:38 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B68440004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ko3jifx7ripz8xy3ormfrtmoe5cim45w
X-Rspam-User:
X-HE-Tag: 1795406140-720502
X-HE-Meta: U2FsdGVkX19ZA+kJhml7NauOsQVBfFR1v7pfAmgHVKs9eGade9lud3cXNfTlz8kpaNN0Ymj9DmcB7TUMD86/5SvmafqqrPpjNUoNfeDgSf5GuOFIHkxeI34lEweTX2b/Eu4kWNq2Q8eOIZa2+ZPnwoVsvrez18Lnav5sRi/cps8Z529UUMU+yPTkanDzgSzAZksQ3VJqhJRcVc5IaozeB8AD3hf5Tw7ilIHxujNfKQlLhfhXUoIbMzXGj7iLUEyaShGhZBDrrUYBzWQBcJeVEjKe41cCMGWIFJuxKnp7wxGVParX9bMlWpAl/LA8UU3btEnHAPOiNFWAcaDKYqY2tYVh/B/cG1JUVgkVObEMDxk4QssZKhTVsWjHmU/fXnZYwPcrJ01EKQaf0YuK3ZMoma2Ga1pVxFjy1bj8U+FKddYe4Uzt270SCN3qG5ub0OmIpKRhP7LRNVZHznXjdG63L+eOas7NJ0u6RZOYBrOK6PB0gQg/6wEtrU5SzKNty7Eks5YzAuYsL4BNVaiMbSRhnNCgDNyKQGa5kMIdcheQMZDILDCR80ADJkV8OJHc1hA6JytYtif7JGR+ycu8MIroh01vohhYP1w11OTmWdZWHC4cF2P8hCDAz3zwrISWmyQ5KyhUuVPET4oPpNTEVS/uIx9NWy+/3YksNaLZTwQ5o0QtLM8UkWwjd8yYr5yEz7c5yT0wGWxRSd6x7ts7W+VhGLnRlVhvQUgxpFb2k5eTrrV+pdXujOar8/RiqFMOs2RK4zjOLDAX2hk61VB1YWg3D+cLrFfDJT8/6FDID4kLhiC+K4yqg2W/ujDMlrloz3MbYZTuj4spDkjrqMrig3mJSXtSmLRBRKoaQUpMSWi4GwaS80sM5ppRzFUrs2jGocI/TdrjXdaoGytwIEk2VKta7Nn9Njg2ul7+EZpoxkauJC1kwsVNmqylXAJ8MPrJnC1TcYgNC58XTgiez85PjpO
 pS+esfC5
 yv4Duj3/pJYFC4gb5Sbho+aW6bVjMCdWRPms5iyAdP4xRs/W5ccOHA5lPVDJL5xY2f4KuNC92sFgfHyK9xA7qvIm72WUPgKDr1unP1Zr3FJ9OgVhAUCa5qtxWeF1YRVr7X8IowrfdAaObtUvnNK3rW0LropOoILRBQi5QpQ73SvczhqzaL5o2MR//1+/5vDK2EkwDD6RJ8HquhZGehix0dyQzlwIwhCd3aHFpVerYgTj93Uqdg0VXwBKZBICmRlQbmDlzK3je+GYc5sdZE5vnJxZBe1OpWdl4dkdwVnyHHDsazfMdSOm5+Rrqz1RI4cK3BmleduX0me8HNDQMJND1yjUZRzByoCVz+g+B72QgCVP+GDftBA91sOfM2XC7ph1aTT+akweDDFZhaHS1LvrmH+qpya/9JhD5uSBiz07A6hcaGE+zimqKaBrXE7xPr6x89VrHeAhR79nLtNPMle6ZlX8jMNrZfQVHq+DpncUfso77CtQRzMgGr0a8wIw32H3DfYktX7mbYs+jhVmt+njpdItOua02DAXcKD6XzdH1R1Q6op/L0fXt/h5ttGbUuyaFThsaVtw/h3LxMsvUCsCgxHs77lEReRX/Aa9x3/WlXNwzHoGyEteXRrAWikTEbmRd3wmHCMJx12v+YsCZTjmqfTMpVNScm8gszpzaicr//I02bID7h8IFfL4F9BNj8EK/cwwm2gsSSV48Jm64wNpY/WGmPEe9M598aB3bTIzkEfBApShpJZN98h1f9dpwazvmapVznm73klUIQAJ9mpbsqT3Av8Q9qsyO3OFn9i1fe7wsosa/eB7FRav0RfRcs7n1sH7WYcvd1WPKu6q5Q+Us+fqQdcGZWXLVFlxquKnGvJFlF3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] zram: unbounded retry loop in zram_stat_read() when stat sum
  is negative
--

commit 2681914a77de11b7b626f04e6fc339b3a441683c
Author: Sergey Senozhatsky <senozhatsky@chromium.org>

zram: keep the hot statistics per CPU

This commit moves six hot zram statistics counters from shared atomic64_t
fields to per-CPU local64_t counters to reduce cacheline bouncing during
concurrent page stores and frees.

Link: https://lore.kernel.org/20261017031542.3504947-1-hongfengchen@xiaomi.=
com

> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 4f479d9051426..df7fbb844b888 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -101,6 +101,47 @@ static void slot_unlock(struct zram *zram, unsigned =
long index)
>  	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK_BIT, lock);
>  }
> =20
> +static void zram_stat_add(struct zram *zram, enum zram_pcpu_stat item,
> +			  s64 amount)
> +{
> +	struct zram_pcpu_stats *stats =3D get_cpu_ptr(zram->pcpu_stats);
> +
> +	local64_add(amount, &stats->stat[item]);
> +	put_cpu_ptr(zram->pcpu_stats);
> +}
> +
> +static void zram_stat_sub(struct zram *zram, enum zram_pcpu_stat item,
> +			  s64 amount)
> +{
> +	struct zram_pcpu_stats *stats =3D get_cpu_ptr(zram->pcpu_stats);
> +
> +	local64_sub(amount, &stats->stat[item]);
> +	put_cpu_ptr(zram->pcpu_stats);
> +}
> +
> +static u64 zram_stat_read(struct zram *zram, enum zram_pcpu_stat item)
> +{
> +	struct zram_pcpu_stats *stats;
> +	s64 sum;
> +	int cpu;
> +
> +	/*
> +	 * Other CPUs keep updating while the values are added up: a page
> +	 * stored on a CPU already summed and freed on one not yet summed
> +	 * can make the sum negative.  Sum them up again then.
> +	 */
> +	for (;;) {
> +		sum =3D 0;
> +		for_each_possible_cpu(cpu) {
> +			stats =3D per_cpu_ptr(zram->pcpu_stats, cpu);
> +			sum +=3D local64_read(&stats->stat[item]);
> +		}
> +		if (sum >=3D 0)
> +			return sum;
> +		cond_resched();
> +	}
> +}

[Severity: Medium]
Can zram_stat_read() spin indefinitely (or livelock under a real-time
reader) when a writer is preempted between slot_unlock() and
zram_stat_add()?

zram_write_page(), write_same_filled_page(), and
write_incompressible_page() populate the slot and call slot_unlock()
before calling zram_stat_add(), whereas slot_free() calls zram_stat_sub()
under slot_lock():

CPU0                              CPU1
zram_write_page()
  slot_lock(zram, index)
  zs_store(...)
  set_slot_size(zram, index, len)
  slot_unlock(zram, index)
  <preempted>
                                  zram_slot_free_notify()
                                    slot_trylock(zram, index)
                                    slot_free(zram, index)
                                      zram_stat_sub(..., 1)
                                    slot_unlock(zram, index)
                                  mm_stat_show()
                                    zram_stat_read()
                                      sum < 0  <-- loops until CPU0 runs

While the writer on CPU0 remains preempted, the true sum across all CPUs
is negative, not just a transient artifact of racing with the summation
loop.  Any reader in mm_stat_show() will busy-loop across all possible
CPUs with zram->dev_lock held until the writer runs, and a higher-priority
SCHED_FIFO reader on the same CPU as the preempted writer will never yield
via cond_resched(), livelocking the CPU.

Clamping negative sums to 0 in a single pass (like
percpu_counter_sum_positive()) and moving zram_stat_add() before
slot_unlock() would avoid the unbounded loop.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/5666c1c8c04998784c8=
1fc8fe751e35aa40af578.1795403342.git.senozhatsky@chromium.org?part=3D2

