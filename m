Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22259CD342C
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 01:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35216B0088; Wed,  6 May 2026 21:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7116B008A; Wed,  6 May 2026 21:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB456B008C; Wed,  6 May 2026 21:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE8926B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 21:35:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A15DC175F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 01:35:17 +0000 (UTC)
X-FDA: 84738905874.06.C080551
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6A51080008
	for <linux-mm@kvack.org>; Thu,  7 May 2026 01:35:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HvjC/57b";
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778117715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wY0mzcaTGiiFuNK8a62ZhVMC5cd8Ogf+3DEEAZHn+QA=;
	b=zIswaLVjcELc/BS/WZpsXX0NIyayVAgL0rcIXGSTo9iMYHL3Lehy6SFjZ00c21G2FEF16z
	41AYAU/69Glo7OQsvZIJkLNOZ5lxrnDWc4MEAMe3LeMzigyOA7ai3yDysFKPhh//eF65a1
	HH3tZsCYWaGQBVBbqwyYG/KArDl7VFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778117715; a=rsa-sha256;
	cv=none;
	b=LyP1T+LWv3uYRL7q2gGpr+AhXw4xeNEmiuF2FV8v3FiAJdNtPX/WXeXZrg62EdRlur36PY
	CDMGnHmqMzQZwHWQ0KfrwoUP5+Y+IXG09Qgml5iBxMOK/H5/JhVGkLUxhFVjidf54neQqI
	Fl2tGjacOaFv/9eFSn9fnaGSO+QiTiE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HvjC/57b";
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 7 May 2026 09:35:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778117713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wY0mzcaTGiiFuNK8a62ZhVMC5cd8Ogf+3DEEAZHn+QA=;
	b=HvjC/57b8pIjHuY32Uny+e034WGVCl19yb/F8WgFs7jqAXIV6+DlxoOjeyR92J4b6CihWk
	MtqwI6ZxMTNOkkKI5RItFr9UvHSnoWQuZ72mfPcUT+1F6MXOhC3L7VslG4M8Rp4f6bFGQ4
	Wb4bdm085vYOr+/8A+6l+HXuMuLlIRI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Zijiang Huang <huangzjsmile@gmail.com>, akpm@linux-foundation.org,
	chrisl@kernel.org
Cc: albinwyang@tencent.com, bhe@redhat.com, flyingpeng@tencent.com,
	kasong@tencent.com, kerayhuang@tencent.com, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/swap: Add cond_resched() in
 swap_reclaim_full_clusters to prevent softlockup
Message-ID: <afvsRn508PgNHpr9@MiWiFi-R3L-srv>
References: <afQTXPLbNrB3NOqe@MiWiFi-R3L-srv>
 <20260506130919.2298807-1-kerayhuang@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506130919.2298807-1-kerayhuang@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A51080008
X-Rspam-User: 
X-Stat-Signature: atg7wfck7rpoqcuwumhp913px1psw6zy
X-HE-Tag: 1778117715-218696
X-HE-Meta: U2FsdGVkX1+SkmigIX0R2TTxmSBFV7GETpDPK9jUAsE+j6FTkIPrI96WgZuLBaS2Cn3+j13F8R9leDPlMKsepHNqE43mIRzqO3zP10O46TpE1zVE8hyM3rd4dZDaEH2Kda2XclX+v/0SIeycdIlzhBHXg3gE/DZfQ0QOTqYdWgpckH6xaYNPDdcHviOkVy/W57CyVI9qRGVnUmsBAh2KtNYOvvghhlEzFjMX4dK3frPdTYR4YXMLFrShCmPe9EIBrgw0tIUhbYlszT1Hft7FOFyNSFHLM1R9WcNstd2/e4iKfX808h9qzOYT6H+23NKKNgl+xD8LIjXuVaA/9sMEsdyv6U0b6AbLUWoUo/oNqBxrTHbWualRjHNlQjYUta3VzO0w+3AEiXxxzjg6Xw/cByKUjA5Q95ZWaidIB+3kpY8PEXdfY+/Tq7Amw9kGsnB1G3gFFWhlIPE0KEFMc7CkygvuUZYNU2fvCCwfENaS2G6mY0Rg3IJLgcNWYjLo8uZI0R1uCkaiwcgub+0g8NEyyyc10b/VcWANP3TStQH25wvoohGylA7WKUw17VTZIX8adO0CrySxfBMHegivUiVriqRbz4Adedjbe38QX/9H+p4juULkrDoNZwenoagrVOk13nZDFC58PF4Pq5g5lMXhonE+C+TPati7GA1FpzctGuFw2f+EpyfcqfN8U21dhj7px8q/3OmEacz6prO0ueuy28kFvZbcNrY4llg063SrDpw65FPeZoHjrhNC5wepzxW0RqgY5ACsz/2eBPi71LoMjd2hQ3o3Zz3NF5fLFqCpzDlso3LnzfUpMNDLPJMYGEQeKr/OL7qXABnEh7vnmNiEyxL41Wr5R9Edow6wVBrzCL0vC9jAFVpVjGw0zOlYyd5ESujS99K6ZdVz1upLdwuG2X7FMBfDjk0aQRnk94pU7MxU6SUAo0T4NeXyNUzPjg1sZuNtGp8r6UuKS5FcMpO
 tMdp3VvX
 bKBkF9M5gpUysVsI5Qj/a8tiJOd8rdgar2f8NaEz/Zn2Dlbg5RGjaPIBIIPngw508f17zIRmaT1jx3LOCs0s8FJ/bIouwcudkr9JNbYb9Od18VVqamyuC8yijVszViirGx6k+B187Wdq/i/hu/q6m/ZctWpzZGj7E41P21ZGqyiMmm4VaAG/Kd0qihCuqdKB45/CZ/cH26q7RKesRCakiENY/7KiI6xJUbKSvyfb8ZcPuElgMQN1pUCiw4xtTl59kVmSAWkIaTIrXi4CWrkQFsSQI5+Igi+UdEKZp/fUvVVwRXMgzlJogjkmWPvpNYaARwz4LjzJdBqLNJWFXN6eMLz2btKU86o4cqybD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/06/26 at 09:09pm, Zijiang Huang wrote:
> We hit a real softlockup in an internal stress test environment.
> The workload was LTP memory/swap stress on a large arm64 machine,
> with 320 CPUs, about 1TB memory and an 8.6GB swap device.
> The system was under heavy load and the swap device had a large
> number of full clusters. The softlockup was triggered during
> a stress test after about 3 days.
> 
> So, add periodic cond_resched() calls during large full_clusters
> reclaim operations to prevent softlockup issues.
> 
> Detailed call trace as follow:
> 
> PID: 3817773  TASK: ffff0883bb28b780  CPU: 48   COMMAND: "kworker/48:7"
>    #0 [ffff800080183d10] __crash_kexec at ffffa4c1361e5de4
>    #1 [ffff800080183d90] panic at ffffa4c1360d5e9c
>    #2 [ffff800080183e20] watchdog_timer_fn at ffffa4c136231fa8
>    ...
>   #16 [ffff8000c4ad3cb0] swap_cache_del_folio at ffffa4c1363e1614
>   #17 [ffff8000c4ad3ce0] __try_to_reclaim_swap at ffffa4c1363e4bfc
>   #18 [ffff8000c4ad3d40] swap_reclaim_full_clusters at ffffa4c1363e5474
>   #19 [ffff8000c4ad3da0] swap_reclaim_work at ffffa4c1363e550c
>   #20 [ffff8000c4ad3dc0] process_one_work at ffffa4c136102edc
>   #21 [ffff8000c4ad3e10] worker_thread at ffffa4c136103398
>   #22 [ffff8000c4ad3e70] kthread at ffffa4c13610d95c
> 
> Fixes: 5168a68eb78f ("mm, swap: avoid over reclaim of full clusters")
> Signed-off-by: Zijiang Huang <kerayhuang@tencent.com>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: albinwyang <albinwyang@tencent.com>
> ---
>  mm/swapfile.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..74a1e324449d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1054,6 +1054,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
>  		swap_cluster_unlock(ci);
>  		if (to_scan <= 0)
>  			break;
> +		cond_resched();
>  	}
>  }

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>


