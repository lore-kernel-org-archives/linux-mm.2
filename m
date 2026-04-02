Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE02CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC156B008A; Thu,  2 Apr 2026 03:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C8F6B008C; Thu,  2 Apr 2026 03:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582E86B0096; Thu,  2 Apr 2026 03:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 450906B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:18:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F8FB140512
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:18:46 +0000 (UTC)
X-FDA: 84612763452.30.8C8177A
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24842100009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:18:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VGjRp0rR;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775114324; a=rsa-sha256;
	cv=none;
	b=mXdnR8y5dfu10GznzYZGBW3Hkv2m22AsQfhLTJA2vto1W3x4LdhYa4kpHn9eunAcQWWyq1
	3pBW/iyMNnOZg6bk8F+l679+TaZnYmGAVUVF4rVBqPVDP3e9o6kHmrnTRjbH7tq0xLiLfI
	5klr9JnrI9AdQRXggYRRvqDseX+oCLE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775114324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWib1ACAapu7QdNLT3bwEyAd7Y6usbD3msQPPdpg6bg=;
	b=wXUvmzhrdF7v3n5nhb1RiiRZeT6Gh9RaEQz2Cw6oKveDUjh1BA+z2XJyMNgLNBvMUQzEPD
	u11GQhybm9C4oKmgYHt+SEhf2rFtrt1EB5zk/KFVwxdIUnBOsHnCxGiuxWSGZzxqs48Ztn
	PbV0/zKJ6Kh0i5+J38lgUWomV0OjFIY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VGjRp0rR;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43cfde3c3f3so511702f8f.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 00:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775114322; x=1775719122; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yWib1ACAapu7QdNLT3bwEyAd7Y6usbD3msQPPdpg6bg=;
        b=VGjRp0rRs3npkWHxoP6efcUP5Opa+S0DfRK0GJHmtkZClNOHBICxZkq3YnmcBPqQ/u
         0rRIDFzlxaksHlt8psJyOTM3BkSuE35dwJOJMHysAjy/DQNQfEaut6l4WVjb9CccqAD3
         m2VWYlQ52RrbLfeKlnu6kfHNWCmGQd5A+0N8ZzWFUqRNK9cQDbYXTnD3kzWfUE1S5gw9
         YJQ8pHwTEU2thYOf34BxfWBIJJGEt74tdfsoHv7NIRP6z0e/dHUGItC5WEGrypLjWfHK
         3hfKGzNpzSw/AkNwiULMXW2OAuYlwNlvwhhLoxzOKdGR5IB/Cwjvpj0umZ22Rx6nZ44z
         dawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775114322; x=1775719122;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yWib1ACAapu7QdNLT3bwEyAd7Y6usbD3msQPPdpg6bg=;
        b=hqmdXvjwWFqprBDflINMzPZ2hmTsD8v2oo62zYgy6lHowoWFLX72S0IyorBBl2r4Pw
         xxMQwvqasiYUybbfmTAwYsWE99mLUJ4+gCQR+fznWFO8SugooGHox02DbAwjYcDjgEGT
         TXnLtBIv1PCEWqlnNLbr0qeNPIXnhza9iCVaH7xlSwqGFuGvRpjKqhEZCJt8F2vCfODq
         60eZJxS0GsbC9YLP5jz48eKJ77wNZnOJ7AJ0hwWRrW+AhZBYU7nKRZ4W/roPiwvxZgBr
         tDXcf/aci6dz5HUVKu11mJEteiYiMhK32lDftD5lcYWHEghkCDX7DagsW32gLprNnbWV
         bRSA==
X-Forwarded-Encrypted: i=1; AJvYcCUA0WZu4O+aXl2vN9yX0KKFbHFagTxUnPjTBfU/QAbUskX/aJMrDTdH3JBpdGEgrI9VDALbOkGRhA==@kvack.org
X-Gm-Message-State: AOJu0YxNg5+dBVqzx5dlyxsnQMVd8UlZajELNu0RUDtnIZWQIzlwhbHj
	6mrKGHn431gzLcw8qyJw67hV+p9HFZPW7Nu2SX9oHZJ2op65RPG6Tx8r84s1h5WwPPE=
X-Gm-Gg: ATEYQzwMuHir5IkJxeKvguNCicWugxZvkBGMYxGspsR1EP2zwcrNlb7NHot0Nj9/Mlo
	OI76k2bbJqa7eGdyTtpVnYnH7nt+gI/wE5wWygyY8WnKcGV5wyRfD9U2X6wRiGTQ3StIkOINiZJ
	sHsu0cfA8TuMDo/+emmAfm21GSc/Gb4x+51b9tyTEXdfWkWtN18qm0TbkokBWOHWEUHqEC8nu12
	kXMgSv9nuoZDr7QmqtxwoCygwJJ31LrYcfoOZfoPUxCRW2ZzdQTxze5tZ8Mr5f/yqFhSPL8kDl3
	q8VU23lhHMdzLFR1t1fAmKTTKU4k8zUlkEzkdkOPFsp9RxmDFcFzUJ5Fv9ZMOqatvBprk6JGV2q
	tYbwKeFSX8JZi9JdM8mvbXmLFB3TfKPh70erQqsztkZ7xJ1/TRyTNw+DViJ23Wi2mkF7GzDf1uJ
	tTg8xWY2FTSoiQVbQEN8lUFY4vzF0EoJzn+Q==
X-Received: by 2002:a05:6000:2285:b0:43b:5192:894b with SMTP id ffacd0b85a97d-43d150bd2bcmr12479245f8f.23.1775114322340;
        Thu, 02 Apr 2026 00:18:42 -0700 (PDT)
Received: from localhost (109-81-86-77.rct.o2.cz. [109.81.86.77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e2a6f1esm5937267f8f.2.2026.04.02.00.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 00:18:41 -0700 (PDT)
Date: Thu, 2 Apr 2026 09:18:40 +0200
From: Michal Hocko <mhocko@suse.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac4YUMl575AuSDaf@tiehlicka>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24842100009
X-Stat-Signature: mhp1iife1i7w4yijtj9jikrfk3zd3xsy
X-HE-Tag: 1775114323-37297
X-HE-Meta: U2FsdGVkX19cqPs/+6yaq0vutSTfEPCi9AJJRzOfrtHYT8NZnV7TeFhsfFVQi7ZqLICMyIZR29at5NeeyhVjUx1h8XEH+b6txociyORqiBOlneuVuSH+oI7LMEHJe1W53avX6M73/Q9pC70R29V+ywtpG40y1b2yxoLXx7e5v4SXzYe3OxAi2SU8EoUI5bgQEEpK8YTluH6UNGM+qoitRe81sNQ7UYi5Ij57dQzTEK36lmo1EERwiszSh2iXD6SRrTMcZAQ/eFAhBKhFTBCsO3kGjqPB10y3T/clkw6CtMGp9Jaae0SLeYntDZVZAL/eMLg4Ug+z7BUD/P9NQuem3PvEZkGweewS0TFVvNHliUf/ZmlDc9enSPlEY9R7MGkWt2XNxTUXiaiHf6Jyb2XGDxKvFE96fwsTGrBHdHrDLYkKXKZ/qMb5kYN/4DzZ6MXUVcNkX9xzplkh6MV/V9SPA4ryGTIi2rXppPaTr5itn3LcmnTmN9SwJUuvhLnDLhBsfkJRG5apetSLSuAwQHqoARvSI8BtJB9PUYLDY0jsl3xjVh6Q6caw6Qvqc6bMnDzqRA3bi94d3Sy6NEqqqc1eYjAxn6bRQ+uMtt8VGGmdHDao22YinCwPD8aET3lQ+XJEtbkKoUHE4ZHzw9aD0hGp/QUO5lHsMTjaAhx8x8oFPrW/8dCeKfOk44tU+8jHLITizmKkEzfHRCwbMoasL/Uufy0iy1da3w3iEHa7VOWVEPvP+ppKSnoWcmIO4z6AbnV40v3HqARSkV6aM2D0te6InkUo6vez2MX9RKbO7ho1ixofxz/palJsimhPB+Q/GwxaHIVXb1kbP2tTPBRXpESW8bd4T9jUwq24+XCWNG299bZYWilxwa+ZHmHoIgDokUgEN80WFAMX/wEIXS2+DIioutGZhvA8IgokXd07xerj6LW9dJOLrZKCxmfHBp4b7R6jnJTcBbI2715YEb+iV9k
 fiP24zB7
 e0j/xsU1ZSUZZIXElT2KkNK7FKRHrIo8x7b0VjjMtm0+D/7bhOQ6JAziXTaPuFJC1jYJWstxI4vAkq8AE+u+OdczpcU6g8puUzUIBLyMxrExB5I5v4yEbyATyb6iWQzEngFoEIDxMZ9Gsirjk/fE4p867+x96EDWFE1GBWwIXarieqrB3MWmtki531MrcVDigrIQq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 01-04-26 06:57:50, Breno Leitao wrote:
> vmstat_update uses round_jiffies_relative() when re-queuing itself,
> which aligns all CPUs' timers to the same second boundary.  When many
> CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
> free_pcppages_bulk() simultaneously, serializing on zone->lock and
> hitting contention.
> 
> Introduce vmstat_spread_delay() which distributes each CPU's
> vmstat_update evenly across the stat interval instead of aligning them.
> 
> This does not increase the number of timer interrupts — each CPU still
> fires once per interval. The timers are simply staggered rather than
> aligned. Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
> wake idle CPUs regardless of scheduling; the spread only affects CPUs
> that are already active
> 
> `perf lock contention` shows 7.5x reduction in zone->lock contention
> (872 -> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64
> system under memory pressure.
> 
> Tested on a 72-CPU aarch64 system using stress-ng --vm to generate
> memory allocation bursts.  Lock contention was measured with:
> 
>   perf lock contention -a -b -S free_pcppages_bulk
> 
> Results with KASAN enabled:
> 
>   free_pcppages_bulk contention (KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      872 |      117 |
>   | Total wait   | 199.43ms | 80.76ms  |
>   | Max wait     |   4.19ms | 35.76ms  |
>   +--------------+----------+----------+
> 
> Results without KASAN:
> 
>   free_pcppages_bulk contention (no KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      240 |      133 |
>   | Total wait   |  34.01ms | 24.61ms  |
>   | Max wait     |   965us  |  1.35ms  |
>   +--------------+----------+----------+
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Makes sense
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  mm/vmstat.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 2370c6fb1fcd..2e94bd765606 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2032,6 +2032,29 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
>  }
>  #endif /* CONFIG_PROC_FS */
>  
> +/*
> + * Return a per-cpu delay that spreads vmstat_update work across the stat
> + * interval.  Without this, round_jiffies_relative() aligns every CPU's
> + * timer to the same second boundary, causing a thundering-herd on
> + * zone->lock when multiple CPUs drain PCP pages simultaneously via
> + * decay_pcp_high() -> free_pcppages_bulk().
> + */
> +static unsigned long vmstat_spread_delay(void)
> +{
> +	unsigned long interval = sysctl_stat_interval;
> +	unsigned int nr_cpus = num_online_cpus();
> +
> +	if (nr_cpus <= 1)
> +		return round_jiffies_relative(interval);
> +
> +	/*
> +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
> +	 * use round_jiffies_relative() here -- it would snap every CPU
> +	 * back to the same second boundary, defeating the spread.
> +	 */
> +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
> +}
> +
>  static void vmstat_update(struct work_struct *w)
>  {
>  	if (refresh_cpu_vm_stats(true)) {
> @@ -2042,7 +2065,7 @@ static void vmstat_update(struct work_struct *w)
>  		 */
>  		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
>  				this_cpu_ptr(&vmstat_work),
> -				round_jiffies_relative(sysctl_stat_interval));
> +				vmstat_spread_delay());
>  	}
>  }
>  
> 
> ---
> base-commit: cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
> change-id: 20260401-vmstat-048e0feaf344
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 

-- 
Michal Hocko
SUSE Labs

