Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 105E2FED2F8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7656B0088; Thu, 12 Mar 2026 05:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37BCB6B0089; Thu, 12 Mar 2026 05:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CA56B008A; Thu, 12 Mar 2026 05:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 120686B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:50:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8733C140A04
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:50:43 +0000 (UTC)
X-FDA: 84536941566.12.824BFAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 998EE180002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:50:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rRekdSnS;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773309041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Skk4EFHMOSs0K0KxgGinsiUUNun/syCCHbEfmiaLG2I=;
	b=wUKMGxGmzIU5TshhXmBedftBlLNxBDvOwpPe1EduPAAfWVXGQn9z6Aw7hjVImZmCNEB0Wf
	X208/8Prq6h9j8QOGsiuqrAgwp1GJtZjiPifUUPT0nKUwYle0y7QdemwqvCsUzH8z9H82P
	ZHHIU+eo/A+qAXAyxEPIIoFZI0Lz/Ak=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rRekdSnS;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773309041; a=rsa-sha256;
	cv=none;
	b=mngWg/6pFo6zSBUR+gGJ4FkoSYm04ty6rv80e7OXxWh39LnRh0hPveHA7uL3CBKsvxKeCh
	0gYL8y42MkO+qLc9VO1qve/eFTszFKu/vUIvPWv5Uz5Gax5fM9TALbUnMGSLoG1dv5HWCO
	XH/1mnItcwaKhegIp8C1CrO7hQBLw94=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ABB84383B;
	Thu, 12 Mar 2026 09:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4260C4CEF7;
	Thu, 12 Mar 2026 09:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773309040;
	bh=nTB9+tdpIn38fFxp+E1+Kq8q+k49zWwh7dHCmIwZ6qE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rRekdSnS5BsxfizH/i+yr3fub8k03xEibZh3qgF5SVf5+VLb1cyTNuuQ0mYIJPhKq
	 xbQp1x9Gso8dpJgLLZNHCpipKjhB0m8Q2snS1Q9FeWy9QmExbO+sTrHvNYbOf30LD5
	 VKRQtHbgYFzxzZNazSy+9oHw1aEbWSb6kfdSUZvxh1RtuSp1id3MebioK1qPx00yFc
	 G2ERGiGqpeBc1RtsKVgbNjKpaG5AQbakKp2nKfoVhDmtq/Ss39hfmopYJAk1KUck3Y
	 /sz16ZoaJAd5cwm9qvKtyE4tftvkXHdpDWpMpQj9rVzAhOCmWrQFis99nainEtzrvb
	 OwDFAjGFOYBEA==
Message-ID: <ff66b090-600a-4c05-9afe-b807c31f24b9@kernel.org>
Date: Thu, 12 Mar 2026 10:50:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3] mm/vmpressure: scale window size based on machine
 memory
To: Benjamin Lee McQueen <mcq@disroot.org>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <beab70d3-470d-46ad-a890-76fabe49272e@lucifer.local>
 <20260305043038.2176-1-mcq@disroot.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260305043038.2176-1-mcq@disroot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 998EE180002
X-Rspamd-Server: rspam07
X-Stat-Signature: 4z87hu4xe1guxqd3dwm8ou1gsf3wmapw
X-Rspam-User: 
X-HE-Tag: 1773309041-658684
X-HE-Meta: U2FsdGVkX18+l2h3/oH8J6fU1e4BRTz7obB9RXysVS/Io6goyzs1bxdl0lWyb2QxwZQpvAo9cD0b/e/rHW435dDL8Oq6bb+rRVKVPbDu2/Gynj7MSwnYb8OQfRjkkr6AAfCoqgDOJrq+1YyohDJTetEu1VvEfKuKZXee6Et53qER8+5U2xlxYYifSt195V0eOEYzSTA+batxr786mqzOdh4D7AqJ9Pd6UgeXgU/oCmVfIP7RyE+otVE5Ub+lL39xun0EcJKXzLzfQU9C4cRSLKiEBDOdwBTW/Lq3V7KkTVNEAO0KZto6lBuwtGbJM3K1lV2PXQ5G4cvwFFmXnu5bYWJDadEjsiHJT2oafrmXPdMcxzkJCwXDWaK5P0Jp8HzlRgRw923pXB+XgKgd5GxTJIKGHR1JHOrInKb3CY7ttDi99srQRcMgylHBRMvvJhS1nKwHN+rTi1bp2WuPHiFw5taksGm8MCMpu7Wm3blBbMhrDQCGloW6WpEZF75+zRALXM1LZI2wSBJ3K8YlNfscTEdUi+Am6XqnJ4/yGPkPARoYB2hgoqZbfL7Gw0J0Y0AouAR3IkO4QHfHiBjBRK/JEaVQ6pOID544rT/KvHFuCiOX7cgWYvXfSsWvdj+8JPn4ucOYHibC2QwiPUatK22hdrAat210/vzH9d4l4AdBnhQJ+5ftxQ+jnpUcivWw42/4YGzVOkNG8ZK0rrgp3mgLEOGZNSms79J+B1A+RWJyuEiI1WYUMYnFsFapQrwM37z0wkt/3LCITv5L/ykZGklytPQbuiWb0NzYaa4rxe0H64TggWj4sU3I5JZT13CKRFuCtTqU6aGlz5VyTjkBJoHqfxplSOdAt3JezIGiBTE6jZPm2jNdeHJySNbtRpupLvw3COM9Z85gUtQtFet/1pMaqk5Vpa8utFAMaLhecVxVl1MsFy16AK4Y6l0wJIULL7so298zGw5eH2QgtTzwi1d
 8CNMKS/p
 b0IJz3lAMvdXPOkTzcc4wJ6NhSOZz4Eq/KA+VFYaA5NzlRXiroR/pP+gVtIUXYcf9NpbGCfcTabkUuPoHrS69Nhmks5lo5KxiTwKe3gcP2pjc8mc1e3OU4U6I/Q89QQ/GJ+lqNXVfuLkdRD4niGU+NJBiYzkiffn0aoXhDGFrkVWQOVrwOy+Kkb7/jdzjfgw8SV936N4hrHDzzrXA/J6CSPPE2d6iuxZZqOX+a0gpYdJrJP6jcNzQpFmyCTKmKIVMgQo7L5mlcGdWlyVBvCAu+k7pAKDFJXdoGq7/RdFlYBmbPJO26OeF0MlXj7MBHHDm/R/J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 05:30, Benjamin Lee McQueen wrote:
> the vmpressure window size has been fixed at 512 pages
> (SWAP_CLUSTER_MAX * 16), ever since the file's inception. a TODO in
> the file notes that the vmpressure window size should be scaled
> similarly to vmstat's scaling, via machine size.
> 
> the problem with fixed window size on large memory systems:
> 
> the window fills after 512 pages (SWAP_CLUSTER_MAX * 16) of scanned
> pages. on a 256GB system that is 0.00076% of total memory. the
> reclaimer works in chunks of 32 pages (SWAP_CLUSTER_MAX), so the
> window fills up after 16 reclaim cycles. here, a single (or more)
> bad reclaim cycle which reports false info has a considerable effect
> on the scanned/reclaim ratio, producing an incorrect reading.
> 
> a larger window however, is *potentially* prone to some additional
> notification latency, as more pages must be scanned before the ratio
> is calculated.
> 
> this is what we consider a false positive; a notification that
> doesn't correctly represent the current sustained memory pressure.
> 
> as for issues with why false positives are bad: applications or even
> maybe the system listening for these notifications are woken up
> unnecessarily and may perform actions that aren't supposed to happen,
> instead of being in coherence with the actual sustained memory
> pressure.
> 
> i did some testing, as well.
> 
> the testing was performed on ONLY a 9GB VM and nothing else.
> window sizes corresponding to larger machine memory were set manually
> via a debugfs knob, so my testing may have been corrupted as i only
> had 9GB on the VM, and this doesn't correctly test on larger systems,
> but it is the best i am able to do.
> 
> vmpressure_calc_level() was instrumented with a tracepoint emitting
> the raw pressure value. a controlled workload (2200MB allocation into
> a 2000MB cgroup with 500MB swap cap) was run at each window size.
> 1000 pressure samples were collected per run with 50 sample warmup
> discarded, repeated 5 times per window size.
> 
> the key metrics are stddev and cv% (coefficient of variation; stddev
> divided by mean pressure, expressed as a percentage). cv% is
> load-independent so it is a better measurement than stddev alone. a
> high cv% means the pressure signal is noisy relative to its own
> average; essentially the readings are unpredictable and unreliable.
> a low cv% means the signal is stable and trustworthy.
> 
> do take the data with a grain of salt, as i probably didn't test
> efficiently. this patch still needs to be tested on larger memory
> systems on real workloads. but if you think there is a better way
> for me or others to test this PLEASE REACH OUT!
> 
>   Window  RAM Equiv  avg stddev  avg cv%
>   512     stock      45.86       91.24%
>   1024    4GB        34.62       69.28%
>   1792    8GB         4.03        7.97%
>   2304    32GB        9.90       18.53%
>   2560    64GB        9.95       18.59%
>   3072    256GB      11.49       20.99%
> 
> the results show an improvement in quality as window size increases.
> stock at 512 pages shows a cv% of 91.24%, meaning the noise in the
> pressure signal is nearly as large as the signal itself; the readings
> are essentially unpredictable. at the 8GB equivalent window (1792
> pages) cv% drops to 7.97%, an 11x improvement in signal stability.
> 
> the data is consistent across 25 independent runs per window size
> (5 sweeps of 5 runs each). stddev and cv% barely move between
> sweeps, which gives me confidence the measurement is real and not
> an artifact of system state.
> 
> stddev increases slightly beyond the 8GB equivalent window, from
> 3.82 at win=1792 up to 11.49 at win=3072. this is expected and
> may also be an artifact of testing on a 9GB machine rather than
> real large-memory hardware. even at the 256GB equivalent window
> cv% is 20.99%; still a 4x improvement over stock's 91.24%.
> 
> since i only have a 9GB VM, i'm setting the window size manually
> to simulate larger machines, but the actual reclaim behavior of a
> 9GB system doesn't match what a real 256GB machine would do. on a
> real large-memory machine the reclaimer has proportionally more
> work to do and the window would fill with more representative data.
> this is another reason why testing on real large-memory hardware
> is needed.
> 
> the formula itself isn't like vmstat's threshold calculation, and
> uses total machine memory size (RAM), because reclaim costs grow
> with RAM, not CPU size or any other variables about the system.
> the formula's floor clause also ensures the existing 512 page
> window on smaller systems (512MB), and only affects larger systems.
> 
> if there are any other questions, i can try to answer them.
> 
> IF YOU CAN TEST OR COME UP WITH BETTER METHODS PLEASE REACH OUT!
> 
> Signed-off-by: Benjamin Lee McQueen <mcq@disroot.org>
> ---
>  mm/vmpressure.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index 3fbb86996c4d..0154df4d754e 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/cgroup.h>
> +#include <linux/debugfs.h>
>  #include <linux/fs.h>
>  #include <linux/log2.h>
>  #include <linux/sched.h>
> @@ -29,14 +30,19 @@
>   * sizes can cause lot of false positives, but too big window size will
>   * delay the notifications.
>   *
> - * As the vmscan reclaimer logic works with chunks which are multiple of
> - * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
> - *
> - * TODO: Make the window size depend on machine size, as we do for vmstat
> - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
> + * As of now, we use a logarithmic scale to scale the window based on
> + * machine RAM size.
>   */
> -static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
> +static unsigned long vmpressure_win;
> +
> +static int __init vmpressure_win_init(void)
> +{
> +	unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
>  
> +	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL, (unsigned long)fls64(mem) * 8UL);
> +	return 0;
> +}
> +core_initcall(vmpressure_win_init);
>  /*
>   * These thresholds are used when we account memory pressure through
>   * scanned/reclaimed ratio. The current values were chosen empirically. In

How does this interact with memory hotplug adding a lot of memory. Just
imagine you have a 4G VM and hotplug 128GB or more.

Would we want to get notified and adjust the vmpressure_win dynamically?

-- 
Cheers,

David

