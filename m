Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8251076368
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 05:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B5A6B008A; Wed,  1 Apr 2026 01:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E26C6B0092; Wed,  1 Apr 2026 01:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F84D6B0095; Wed,  1 Apr 2026 01:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E27B6B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:02:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7A87160464
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:02:02 +0000 (UTC)
X-FDA: 84608790084.10.4F75B99
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id BF5F440016
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:02:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JmwYAz/V";
	spf=pass (imf07.hostedemail.com: domain of lenohou@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775019720; a=rsa-sha256;
	cv=none;
	b=AVTfBrVZHg+RF7x38efm0AfqJzcfZZjWYgf67IfR3LtFOIGGg21Uoz7CNxuXafycBs0VGM
	dDQisU8waiJfKXAOuKn3jkE9S+gvRghz/MP7YX2k6AYuyF8gsTDmxypqbFiGAErdc4+mT1
	p2RbsRJ323jf/EgUyqhpvHNZKQ8LOrE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775019720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOpyS9/oME1LQxC/LMAj1sLy32p3fU6TvzMpmXikFow=;
	b=JLe7WTnJu6OqbcvTetWmqbzM8BM/lVdFC73fjBd1NZ7ZiBz86dyp15MH5grd0ky3xAM7IT
	hoy/XtGC46qtmOtw16ZIxB/m/CU26+TfjXkGEzq9kqxPKWuGhKNkFk3hcSqPla1ADIRNgZ
	1xi18AY5QjtFdPloBDYWgvpXL/FBHuM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JmwYAz/V";
	spf=pass (imf07.hostedemail.com: domain of lenohou@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c736261ee8dso2312504a12.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775019719; x=1775624519; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OOpyS9/oME1LQxC/LMAj1sLy32p3fU6TvzMpmXikFow=;
        b=JmwYAz/VAkmLRbJ6N6QKOzzReosBZeAYj3dujYhn5JrpSiYcFB3LDorS5eYtqgqEku
         bQgfXq+rc3uMiiYbxJp9JglEsrrChdWGOI+ZSoWEsA7PpWYgkouKJEGj5IybaGASLYk7
         QrUesu4Ywow1+qGMYU2a3j1x7Az3gI1yxYY9loXOkpVQD8b7KZDOBVcFjw6pAncuAyhw
         n0VbS0dv8SrF6SixdFgt2Eg0+AHE9uDxfyQ1VrMUjCsyLBBJb1C9qgzdORvsJDhWLIDN
         /E8LQ0af+f5Oa4jnbl/fbuVmekG0R5hGYpHK5/L47b+dkYEhFT7qPImGzXmjENpA7Puj
         a11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775019719; x=1775624519;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OOpyS9/oME1LQxC/LMAj1sLy32p3fU6TvzMpmXikFow=;
        b=Ji9amEepm05oRJ2l7C6fjfqbhGw5qeXk0GEaV2dMpOxaYAA3nUisDjEcoMRB9zUVn1
         gkbL4eSOL56zJhUmHutHpIGjy2MumckTxdrBrFmjRdyZQlIhEVkVCFpCPcuuxNtXaaYo
         VX02oZuVWoJ7eXHsf0qK2hQap/ROhbqUmx13OUcNJQMAL0LfGS81iI6RtrLR41nd/mZP
         gG6HnHqGfci+b8mnCLBaMuKP71OV31YkLrwCgKYZr7JPqs2rz4lE6rQsm4j/ygECiMkg
         NtzGRGofpH1dEzk7XV7I2ZTOrdK/2zyVzF7YRH0CCQx9qz+0YO8JU3o5T0ngai8kJYMu
         0sBg==
X-Forwarded-Encrypted: i=1; AJvYcCXwqfxVkq2r/QIuDaD0SxtDdW1Sywus4iIKUv+yzjsvz16MS8J+/rdfvXBm1sB7+fCENCEZ8ULf8A==@kvack.org
X-Gm-Message-State: AOJu0Yw6LrdLENnp2zYM1+GnfSs7GhpTNWvfzQDMPpWJJb+W4foY9H1S
	Wq3fPBQvrULAf1UjNo3oJeYlqPB5+AD+olVOJmvMi4mezqOjLHfuCJES
X-Gm-Gg: ATEYQzxu75CFg5/3CH4SRs86oSEIKC06P7DxyVXMyBgNIg8dgFarg3Cin0893PuIgGf
	4YJUmqY+U/P1fD//ZZE0GBtYL52xgBFShOxX7XAm50KLGrRAqbREuCWQEVvjK9GduCCBGx0L1My
	zGeOr5Crg9ERnAE76GOmJVhmGoUz0fKn3KAkBj5xZgdhGMy9nJQ9w5JWAvNbgY9MO0KiHeQYIfN
	0uYJSTP0u5vIPGXGtUPqAfCGxf30W1cOxls7dEF61xFsWCHhIgXYPo4Gr5JpVs+KSX2Ab9mx7tD
	OYbALwecp+szHDM7TE6Z1rnZL+oJoxUnrw2JRXlQRBCg8/l6pgIO3w62V7lmdMgMWuxvwgOK01K
	15gQyc+w2AtkmPaHp6wM6NH7wEUNuXhReVTaf+2osjiL6oefCG2kBLfGrs4AFk/W/eCFwbi6BvL
	jtmzDcqz/WURAocnYya8mfozyrL7lgQaOtE2M42GBk6oPB5FZwQWLWEaM8ABkIrdreKm1pqJ/3H
	L5zREL76bnRZJBMFftLQ0wgsCgTrZoz+2QdhvgT18ia
X-Received: by 2002:a05:6a20:72a3:b0:39c:4c23:a175 with SMTP id adf61e73a8af0-39ef77161eemr1966646637.45.1775019718967;
        Tue, 31 Mar 2026 22:01:58 -0700 (PDT)
Received: from ?IPV6:2408:840d:2000:afa:a06d:889c:87b5:c739? ([2408:840d:2000:afa:a06d:889c:87b5:c739])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76b5b9f153sm3797650a12.18.2026.03.31.22.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 22:01:58 -0700 (PDT)
Message-ID: <aa3423c8-d4f1-4a22-9098-bcfb5760551c@gmail.com>
Date: Wed, 1 Apr 2026 13:01:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] mm/vmscan: unify writeback reclaim statistic and
 throttling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Yafang Shao
 <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
Content-Language: en-US
From: Leno Hou <lenohou@gmail.com>
In-Reply-To: <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF5F440016
X-Stat-Signature: b5gm5uws9kex7mks4mqiziuz8j1wahxh
X-HE-Tag: 1775019720-213427
X-HE-Meta: U2FsdGVkX18COCKKbgJuwyUSkVDsHWQah47H3jSgZ76KK6NisubAuXUwJN5tVta3ODEftz2x3PzWctLEqSmoHcoCaASyKNZmNS6TBzSc545kDqxGBeTvJuDCNqjd6XqjsjW8hGyOvVoz0gtuEJxT5EhPcfAoZb40mqT/PPQzk+h28tXMkSwRI+JiaBg3ACRXlb3Jz4k6/HXPpBgCIb8VA/lUqt5ynqssYWWx73oXdOhTNKZfb17wwzo8P6ObEtBDpAyFjINB4aCJJ4iNXTzSlUT86M0hZNd6oUHS5L7/4pqNifSMwat6RQq3MrNAGD4uQNBHvwpxqQZ/KyBS2E50T0wg1Dw/wbTNMg58cyzE4gKPVBtPObGYVm/blDZeUveQwBle2a9PiKsBYsPNnWqZJu5hp8ZgyHB6ZgdcBn9RU35tRlo/q09jAuHigLDuCa4lbO1aZPrmlM/cOhfSO0J9M1meYz+1QvnWSvyMoN5f+pJwdPK1iJUGRhuEsXIBn9vHRc6b5sM5lnCq3hOcLiErJpSgjbCQlSBxXcjJfXuV/FJxrRIRffwz55SOjE+Kw4Uo5bfY74q47Ae6riSs9zfZLXpVjpCcXjDWpVcTqvE4qN7gfmOSozhPrs0G9s2dgSci/pToz/wxYHau+J5KExT3Y4wRS1hg9453Vgi/Sy3R7kxL0nR7LTp4Vn2lMPVNCRJRmSuXz2OWT0/sAB/0yN4GcNnSBYPLCp6oJkMZgw76LoOspHn+8kvfL3ranXfIGURUbbkcljl5ee+2D0AQ091ZFbxH7WnA7U19P1fNT+/wwYmD0jZFsnegGkxj/HP1WYgUFlNSgGotntl4Sk215Cx9+qoVagcp5spD4hwgjyQbeWynk2+jDMpfI3XuOicFZAaWC0+r+zv4EQBG2AtzFArD67zSeGIMr0sTmq/5NPyBmTriLi1E/cumVH0EsIkBFdzzd9b973jisAKF/+u0etN
 cyNvh6A0
 fdbJYcOXwKUqQb664GkflLuoNbIRJWaiNeS9T64ZFVfeO0YcDNkYBMWVqjj4AwqaB7Lr8CZFddbQvILVQhIylQ2XapOcpaHoYoBkGuFogzEvPT9UpU8DN+a3iWYIJKSuVu0UygOTXFkq/Py9eNSvuPgc0eI3Xk/a36i6iQ1co3+sTjWBU+UErBb+ErnqM089EQ6UMhsmUMNgQ49Nd01XyIT+xVA06dQtt9ADZ1idIhvMwhqGgeF3L15+YG5XHtKdm9JSyK0hNKfdBmr/5XMMsQzZrLoBWyii7mRVGsE6xD2eqwU7q0+oKw67c7NgkvxXKkJRRgp1dOHwhek73VqFZqXUO2KsZrIE4+nlIYCBAaWQK0oszc5cLPf9xqsNDd2m7nWn0OxIgwdYeV+1VLASgr45fVlejeEEhQVY094pe+53SwddBgkRtHrXpPJI2P2LrR46lJ4NPvk3I8T6KV6n+2Eql8m8MyXSma6XqShBNPv/DC4MIpGe38mMiX2Mh5RAB1e75w4q3padXGV/oBOiYmZfxb/gefklATiUg9IcbwJUtTmdJEey1AUcsOqxeQRHPQt0ftYUYNq7p3cg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Currently MGLRU and non-MGLRU handle the reclaim statistic and
> writeback handling very differently, especially throttling.
> Basically MGLRU just ignored the throttling part.
> 
> Let's just unify this part, use a helper to deduplicate the code
> so both setups will share the same behavior. Also remove the
> folio_clear_reclaim in isolate_folio which was actively invalidating
> the congestion control. PG_reclaim is now handled by shrink_folio_list,
> keeping it in isolate_folio is not helpful.
> 
> Test using following reproducer using bash:
> 
>    echo "Setup a slow device using dm delay"
>    dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
>    LOOP=$(losetup --show -f /var/tmp/backing)
>    mkfs.ext4 -q $LOOP
>    echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
>        dmsetup create slow_dev
>    mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
> 
>    echo "Start writeback pressure"
>    sync && echo 3 > /proc/sys/vm/drop_caches
>    mkdir /sys/fs/cgroup/test_wb
>    echo 128M > /sys/fs/cgroup/test_wb/memory.max
>    (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
>        dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)
> 
>    echo "Clean up"
>    echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
>    dmsetup resume slow_dev
>    umount -l /mnt/slow && sync
>    dmsetup remove slow_dev
> 

Hi Kairui,

I have tested this patch series on both stable v6.1.163 and 7.0.0-rc5
regarding the writeback throttling issue you described on arm64 platform.


Test Results:
1. Kernel 6.1.163: I was unable to reproduce the OOM issue with the 
provided test script. This is expected as the MGLRU writeback handling 
might behave differently or the issue is less prominent in this specific 
stable branch.

2. Kernel 7.0.0-rc5: I successfully reproduced the OOM issue using your 
bash script. The dd process gets OOM killed shortly after starting the 
writeback pressure.

Verification:
After applying your patch, I re-ran the test on 7.0-rc5:
1. The congestion control/throttling is now working as expected.
2. The OOM issue is resolved, and the dd process completes successfully 
without being killed.


Tested-by: Leno Hou <lenohou@gmail.com>

> Before this commit, `dd` will get OOM killed immediately if
> MGLRU is enabled. Classic LRU is fine.
> 
> After this commit, congestion control is now effective and no more
> spin on LRU or premature OOM.
> 
> Stress test on other workloads also looking good.
> 
> Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/vmscan.c | 93 +++++++++++++++++++++++++++----------------------------------
>   1 file changed, 41 insertions(+), 52 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1783da54ada1..83c8fdf8fdc4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1942,6 +1942,44 @@ static int current_may_throttle(void)
>   	return !(current->flags & PF_LOCAL_THROTTLE);
>   }
>   
> +static void handle_reclaim_writeback(unsigned long nr_taken,
> +				     struct pglist_data *pgdat,
> +				     struct scan_control *sc,
> +				     struct reclaim_stat *stat)
> +{
> +	/*
> +	 * If dirty folios are scanned that are not queued for IO, it
> +	 * implies that flushers are not doing their job. This can
> +	 * happen when memory pressure pushes dirty folios to the end of
> +	 * the LRU before the dirty limits are breached and the dirty
> +	 * data has expired. It can also happen when the proportion of
> +	 * dirty folios grows not through writes but through memory
> +	 * pressure reclaiming all the clean cache. And in some cases,
> +	 * the flushers simply cannot keep up with the allocation
> +	 * rate. Nudge the flusher threads in case they are asleep.
> +	 */
> +	if (stat->nr_unqueued_dirty == nr_taken && nr_taken) {
> +		wakeup_flusher_threads(WB_REASON_VMSCAN);
> +		/*
> +		 * For cgroupv1 dirty throttling is achieved by waking up
> +		 * the kernel flusher here and later waiting on folios
> +		 * which are in writeback to finish (see shrink_folio_list()).
> +		 *
> +		 * Flusher may not be able to issue writeback quickly
> +		 * enough for cgroupv1 writeback throttling to work
> +		 * on a large system.
> +		 */
> +		if (!writeback_throttling_sane(sc))
> +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> +	}
> +
> +	sc->nr.dirty += stat->nr_dirty;
> +	sc->nr.congested += stat->nr_congested;
> +	sc->nr.writeback += stat->nr_writeback;
> +	sc->nr.immediate += stat->nr_immediate;
> +	sc->nr.taken += nr_taken;
> +}
> +
>   /*
>    * shrink_inactive_list() is a helper for shrink_node().  It returns the number
>    * of reclaimed pages
> @@ -2005,39 +2043,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>   	lruvec_lock_irq(lruvec);
>   	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>   					nr_scanned - nr_reclaimed);
> -
> -	/*
> -	 * If dirty folios are scanned that are not queued for IO, it
> -	 * implies that flushers are not doing their job. This can
> -	 * happen when memory pressure pushes dirty folios to the end of
> -	 * the LRU before the dirty limits are breached and the dirty
> -	 * data has expired. It can also happen when the proportion of
> -	 * dirty folios grows not through writes but through memory
> -	 * pressure reclaiming all the clean cache. And in some cases,
> -	 * the flushers simply cannot keep up with the allocation
> -	 * rate. Nudge the flusher threads in case they are asleep.
> -	 */
> -	if (stat.nr_unqueued_dirty == nr_taken) {
> -		wakeup_flusher_threads(WB_REASON_VMSCAN);
> -		/*
> -		 * For cgroupv1 dirty throttling is achieved by waking up
> -		 * the kernel flusher here and later waiting on folios
> -		 * which are in writeback to finish (see shrink_folio_list()).
> -		 *
> -		 * Flusher may not be able to issue writeback quickly
> -		 * enough for cgroupv1 writeback throttling to work
> -		 * on a large system.
> -		 */
> -		if (!writeback_throttling_sane(sc))
> -			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> -	}
> -
> -	sc->nr.dirty += stat.nr_dirty;
> -	sc->nr.congested += stat.nr_congested;
> -	sc->nr.writeback += stat.nr_writeback;
> -	sc->nr.immediate += stat.nr_immediate;
> -	sc->nr.taken += nr_taken;
> -
> +	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
>   	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>   			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
>   	return nr_reclaimed;
> @@ -4651,9 +4657,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>   	if (!folio_test_referenced(folio))
>   		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
>   
> -	/* for shrink_folio_list() */
> -	folio_clear_reclaim(folio);
> -
>   	success = lru_gen_del_folio(lruvec, folio, true);
>   	VM_WARN_ON_ONCE_FOLIO(!success, folio);
>   
> @@ -4833,26 +4836,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   retry:
>   	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
>   	sc->nr_reclaimed += reclaimed;
> +	handle_reclaim_writeback(isolated, pgdat, sc, &stat);
>   	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>   			type_scanned, reclaimed, &stat, sc->priority,
>   			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>   
> -	/*
> -	 * If too many file cache in the coldest generation can't be evicted
> -	 * due to being dirty, wake up the flusher.
> -	 */
> -	if (stat.nr_unqueued_dirty == isolated) {
> -		wakeup_flusher_threads(WB_REASON_VMSCAN);
> -
> -		/*
> -		 * For cgroupv1 dirty throttling is achieved by waking up
> -		 * the kernel flusher here and later waiting on folios
> -		 * which are in writeback to finish (see shrink_folio_list()).
> -		 */
> -		if (!writeback_throttling_sane(sc))
> -			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> -	}
> -
>   	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
>   		DEFINE_MIN_SEQ(lruvec);
>   
> @@ -4895,6 +4883,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   
>   	if (!list_empty(&list)) {
>   		skip_retry = true;
> +		isolated = 0;
>   		goto retry;
>   	}
>   
> 


--
Best regards,
Leno Hou


