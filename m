Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48197606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 05:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SzkNYgve
Received: by kanga.kvack.org (Postfix)
	id 51D5D6B05F6; Tue, 24 Nov 2026 00:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE1E6B05F7; Tue, 24 Nov 2026 00:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3E56B05F8; Tue, 24 Nov 2026 00:37:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 054EA6B05F6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:36:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C602160A5B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:36:58 +0000 (UTC)
X-FDA: 85468903716.30.825737F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B58F0C0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:36:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzkNYgve;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795498616;
	b=R/LTqjs4DdeDRYtDJsj5k+2Ct2d64WtKmLkZ9hG5Y4DEKfXK6RY98PxPZr717L1eCgXI8l
	w57Ywa+UfXCv2pSSVefv4oC6IhjYs0OoNdZ8C/ULTTD97ekBo89Zg1U88ZIUKnnAapyC2B
	HSoNZhi/dfQy7YI52sPBLqpS9RtWiek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795498616;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLgMypUB9viZ3Yv6x8XcAIXSZyB3rajlbb4pIMGV1JY=;
	b=g+WTH41Dw+BgHmsVAsBeG1rPF/TsxJjHu/jATYtESAyVYbYwMCW7KhyD7coAS1dENE6SUq
	6PxwEHOwqYYN6/HGKrLOduQottaULV+SAoYZbZrqpOxZjJkJXDZI995CGDMMwT7Lp+6IBx
	+8eZiTNsr0JuC3SIrQpMYHekP2BaI+0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzkNYgve;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6C8060E76;
	Tue, 24 Nov 2026 05:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2640D1F000CA;
	Tue, 24 Nov 2026 05:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795498615;
	bh=fLgMypUB9viZ3Yv6x8XcAIXSZyB3rajlbb4pIMGV1JY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SzkNYgve+jnfM/kb1OZWmZupC+fwonhj0oBR/l3z7lm2J1Cht9uksjVsdnF3Ob3JH
	 Qa8NVLXQafKkK2g+ofhBNog3Odm+BboRrYK+c8i4F9Je5STCV9yJCoEto2RSnbf1DD
	 h1iPUb2SDPkF7hupR5amsAMWrUWQ6CWBwneUKX6XgFg0L5goNXjJgfUQjAu8F6Xeyr
	 dvfT5kxn8YMjTbRWdBlrsvebddCQY0iRBa4o/3LBkX8xcgwfry9Im40OFJ1cJBL7vm
	 cpa7fRdHQcU8NtuL564p79pBy176/atqxBOTOts+fY4SkCX2/PvGuVMiraCdGmfnev
	 jG4Jpqo1EIe3g==
Message-ID: <sashiko-outbox-230559@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] zram: keep the hot statistics per CPU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Nhat Pham" <nphamcs@gmail.com>, "Yosry Ahmed" <yosry@kernel.org>, "Hongfeng
 Chen" <hongfengchen@xiaomi.com>, "Brian Geffon" <bgeffon@google.com>, "Minchan
 Kim" <minchan@kernel.org>, linux-mm@kvack.org
In-Reply-To: <cd96ecab2cfbb9a50a0b5141c09f9fda086780a0.1795412161.git.senozhatsky@chromium.org>
References: <a74aca7a3d27333972782b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org>
 <cd96ecab2cfbb9a50a0b5141c09f9fda086780a0.1795412161.git.senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 05:36:54 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B58F0C0003
X-Stat-Signature: ykq8h97uum3dx3ikxbwf8ajjokhdfjy4
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795498616-336406
X-HE-Meta: U2FsdGVkX1/MIvzpB1GpKoeHDBJleknbOuqDZJ1iULvr8H9hIA7ywcnBwnaX1/RTya33ELfMtL1L7XMtyFqf04tkKHDdkapWx6lQ6h78cFbkgvkBmiPdQsTrgAVMT+nsZ+fTXDeDemfSofLmF9n/DqZvGYnn6QXhsBHa1WwsjAYWdi6i4qlj/yFCGsvTUZu/AbyjOrhe9D4K2rIWnvUxC0Yl0SctV6jgSMMyRiyerBwlFFPTC8Rzji+Z5aAboHqslhcNkbQHU0vUzoODKNo3s4yci7rI4DBq+HxIU5gUIHQoV8f1EK7tAzQbdG9J0XVxioliqlohsFnVM30bmQNbkEpv1Fh0a4d0inFP6FZX8mFAvV/EGmIGfaxN7UzpHqXcMNs2S08kD6nmbAQlCI1aFWGL2xgV+7MpFAW+G7tYDYLKpMQz/O+DRO5aZwCzvkY2kpGPofi3YHXqwcPf4wwEwkOO3PRHoNz+PAVkU+7oITv6zyV5wbie0TF/dYE8apG5IaEiV44Du/Sdqmz0RP75ukGDoeAZqA2vXA40lD+4gapqh5oXZHQhBd74Up/tzKX0eQWbL9Cnn5P9jScgfASX2gtfKh6pwWsUCevR59hQ2GuidiwZaPRvM6pPTyhN3GrrLFPTMLuPcRz19lqlChwbMF6hyUzBZqy6FlP+l7YUyGRrN7YrwkVqjGsHFvP4qVzlUwydW/TVXM/qQ6D9WWerLZQdMQwATGSxVyfEI9aGVoIOdLOD7dTEcL3VjZ2ETi4cpBGKzt5XaKxnYYdTG7Oq0GAT3Wa8Q06EhoXho8gVo24oQU+IPSjzvmCMKzbvI/GSk0h29sPmyqPweRes5QxG4nknmAqDtHISEbbxyVELxw2K1VNd5yBTCW8Qng9Ng71K9Ua75bMU9XzR4vj1ojSvz8ioiDdnGltEXnjbJpIjrCwTsraIfaTmGy0ZFfTv1SnByjXTTizSq145duwsJo3
 25wh9mxt
 sEFLbalQ/HuvIMJiTGtME/4tNs9DHQh9EaBoRMvuoUjLG4xsHaDABRiEixHFLBUB+Gmik6AqhtDwg56FE3oBIYFmOsKyNZYz2/uVsXUc6hC2Yf38DK4FFrrg7v96nPZMp4GWuBEX9bR4rmvn9S66bnmq5GPf15TQgTlRlwXD2e1Z4GdB/SjhH56sQz8Cv8PfghUugR8mir61mxKeuHWanRFBLm+9jMaHgBZo6ug9qx0dOZwLwL7jwv1IKyLvDwnW7oP1PfOUN3Z1mjCIHq5hhuIe0PNASRgFiPZJ9VrCvJs9kf8U99QoCTRI6D4nIjVLODGBUxKIdLFUhRF0zp6KQRp5QZh/6+BbQccz5VaEmXCGZiB7wGAwWWMRVvrTk4hP03Y3zkxqXkf2jEubFyDu6A0XnjBD21j66fBX6L6Bg94M7zaQgr+yy5X00jt6gSo6itIJoi3gy8SWw1RaYoen/nptwdObQu/dAkirh0olxwHgRZS36u+3ogcq3OnmMTuKG+GIkL3uDcSWyQ4q6EDXcwKVG0niYS1c9NU5DWsf2CeVcu1fzNOefySsFE/FrVl8MxCNnORMwN98AuhZPpC9xIoAiC9JoZ31jL8XFv19eA7UEs8Pru+Jy1Fo/e6NwU6y5P8DhSAPW6O1/pqCoMD4/2WX0eQMHIQu10SbWEWPJ3hKaEzTHFjbcGOBlggmOt3Up6LnbX2iS4CW7vwga5Qu+yD3WG12t3NPm8dscTxWPdlTvtdby9Mm12t6pKbMTnsoBtheZQDmY3yvNHS1mSN0CRVbPd1wz3M3nYTFNg5XBeG6g86HT5RnlSK1rcjRY69pttCnZcnTBqQ86O5byY3+IaeUyyRholyEf9F/H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] zram: missing co-author Signed-off-by trailer for
  Co-developed-by
- [Medium] zram: unbounded retry loop in zram_stat_read() when slot is
  freed before add
--

commit 1e6f41c95000ee48e7db6e0bb20c176ae2d9349b
Author: Sergey Senozhatsky <senozhatsky@chromium.org>

> zram: keep the hot statistics per CPU
>
> When several processes free swapped out memory at the same time, e.g.
> on munmap() or exit, all CPUs update tpages_stored, compr_data_size,
> same_pages, huge_pages, huge_pages_since and notify_free stats, so
> the cachelines bounce a lot [1].  Keep the six counters per CPU
> instead, as local64_t updated with preemption disabled.
>
> munmap() test:
>                   before     after
>   4 x 256 MiB     18.69 ms   14.12 ms   (-24%)
>   8 x 128 MiB     14.82 ms   10.09 ms   (-32%)
>
> [1] https://lore.kernel.org/20261017031542.3504947-1-hongfengchen@xiaomi.=
com
>
> Suggested-by: Hongfeng Chen <hongfengchen@xiaomi.com>
> Co-developed-by: Hongfeng Chen <hongfengchen@xiaomi.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

[Severity: High]
Per Documentation/process/submitting-patches.rst, a Co-developed-by:
trailer must be immediately followed by a matching Signed-off-by:
trailer from that co-author (Hongfeng Chen <hongfengchen@xiaomi.com>).

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

[ ... ]

> @@ -2252,8 +2294,8 @@ static int write_same_filled_page(struct zram *zram=
, unsigned long fill,
>  	mark_slot_accessed(zram, index);
>  	slot_unlock(zram, index);
> =20
> -	atomic64_inc(&zram->stats.same_pages);
> -	atomic64_inc(&zram->stats.pages_stored);
> +	zram_stat_add(zram, ZRAM_STAT_SAME_PAGES, 1);
> +	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
> =20
>  	return 0;
>  }
> @@ -2283,10 +2325,10 @@ static int write_incompressible_page(struct zram =
*zram, struct page *page,
>  	mark_slot_accessed(zram, index);
>  	slot_unlock(zram, index);
> =20
> -	atomic64_add(PAGE_SIZE, &zram->stats.compr_data_size);
> -	atomic64_inc(&zram->stats.huge_pages);
> -	atomic64_inc(&zram->stats.huge_pages_since);
> -	atomic64_inc(&zram->stats.pages_stored);
> +	zram_stat_add(zram, ZRAM_STAT_COMPR_DATA_SIZE, PAGE_SIZE);
> +	zram_stat_add(zram, ZRAM_STAT_HUGE_PAGES, 1);
> +	zram_stat_add(zram, ZRAM_STAT_HUGE_PAGES_SINCE, 1);
> +	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
> =20
>  	return 0;
>  }
> @@ -2346,8 +2388,8 @@ static int zram_write_page(struct zram *zram, struc=
t page *page,
>  	slot_unlock(zram, index);
> =20
>  	/* Update stats */
> -	atomic64_inc(&zram->stats.pages_stored);
> -	atomic64_add(comp_len, &zram->stats.compr_data_size);
> +	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
> +	zram_stat_add(zram, ZRAM_STAT_COMPR_DATA_SIZE, comp_len);
> =20
>  	return ret;
>  }

[Severity: Medium]
Can zram_stat_read() spin in an unbounded loop when a slot is freed
before the writer calls zram_stat_add()?

write_same_filled_page(), write_incompressible_page() and
zram_write_page() publish the slot and call slot_unlock() before calling
zram_stat_add(), whereas slot_free() calls zram_stat_sub() while holding
slot_lock():

CPU0                                  CPU1
write_same_filled_page()
  set_slot_flag(..., ZRAM_SAME)
  slot_unlock(zram, index)
  <preempted>
                                      zram_slot_free_notify()
                                        slot_trylock(zram, index)
                                        slot_free(zram, index)
                                          zram_stat_sub(...,
                                            ZRAM_STAT_SAME_PAGES, 1)
                                        slot_unlock(zram, index)
                                      mm_stat_show()
                                        down_read(&zram->dev_lock)
                                        zram_stat_read(...,
                                          ZRAM_STAT_SAME_PAGES)
                                          /* sum is -1 across all CPUs */
                                          for (;;)  <-- spins until CPU0 ru=
ns
  zram_stat_add(...,
    ZRAM_STAT_SAME_PAGES, 1)

While the writer is preempted or throttled, the true sum across all CPUs
is negative, so mm_stat_show() spins in zram_stat_read() holding
zram->dev_lock; if a SCHED_FIFO task runs mm_stat_show() on the same CPU
as the preempted writer, cond_resched() never yields to the writer and
livelocks the CPU.

Updating the stats before slot_unlock() and clamping negative sums to 0
in zram_stat_read() (similar to percpu_counter_sum_positive()) would
avoid the unbounded loop.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/a74aca7a3d273339727=
82b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org?part=3D2

