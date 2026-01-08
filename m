Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39474D1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 19:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B666B0098; Thu,  8 Jan 2026 14:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9346B0099; Thu,  8 Jan 2026 14:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB656B009B; Thu,  8 Jan 2026 14:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68F226B0098
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:00:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43F301AAB5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:00:05 +0000 (UTC)
X-FDA: 84309711570.09.311FA88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8DA0816000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:00:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nW2I81WM;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767898803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yr8W9yJzKWK9eVupWJ18BgZmMNvrUclH3k6TgslUNdA=;
	b=LXS/OkmROWHcMLSk+vfBxr/sqsed45Vwd+W3RFf5UI6n26xKp2d0lxr5EdAqX63UEE+ACY
	gkpXZnD1DA/zJKcsreBnyT7UVg5Fg3/GnrLNemAL5KpQHxCSfVppyq7F/lpekfD2bL6fCx
	hJlfWbHwsmK2zIrl7XzcQf3sN1qxxqc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nW2I81WM;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767898803; a=rsa-sha256;
	cv=none;
	b=A/tHGK8gJZ0DGiIFk0ecUTdcsdtojfTjfzo+nc2IpZu9EW06IM03NpjhllQKkNOa9Mj1Ig
	z5SrQmjoXJa5z72B9Tx/CCKnbIFS7eAKqOLqxd4KcDiE2svmj4d5kbEZEluFTudxtFgW4e
	YoMIXCVETj3WlDz46ILTQcA6UdC7Hts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B3ADF60130;
	Thu,  8 Jan 2026 19:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10FDC116C6;
	Thu,  8 Jan 2026 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767898802;
	bh=xkljrQctX/mDR/GQ0S6dpucNB4l1Deu7SRu2NiGbgrk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nW2I81WM9wUmLIIPFZa19mVDuK9NRqwfQSn5RUb20kkn+FwyrfyZcAgthN5+smrmJ
	 G5iKUuWaRNvWROYo096Pu3T5sid8zoIavJGJxbYMU+OdkncGLo9nNttqoGp6BpYjFJ
	 tYTgy2lorSD1O7g6oAGXBYqSHUKuWFUj9MFHR70g=
Date: Thu, 8 Jan 2026 11:00:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, bingjiao@google.com, David Rientjes
 <rientjes@google.com>
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-Id: <20260108110000.dc6e3be63e8b9f401c8c429b@linux-foundation.org>
In-Reply-To: <20260108101535.50696-4-akinobu.mita@gmail.com>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
	<20260108101535.50696-4-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8DA0816000B
X-Stat-Signature: 4wkougdhp7q519b7urmfcskoeuhu84pu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767898803-358266
X-HE-Meta: U2FsdGVkX180TiAZkW4xXXqOwMTta74RBzbBP2Ww0gUu0W1Ao3BVxEIIPauLOryZiI16wtkHgUPASF3vsuJNZsE/y9D3y3qZyBfoBNL1cS8o3FcgGYRcLhPB6BAZBl8sZBh5FVa7oGnEmLTWV2LSwrGliJ7ceU3aN2+i9fai53HpFqcTyd1tpd31l/IylVj9dxwx7OeKfDhlNOks3jeiUkMFRbJspUD/iEOqe/3AvqpMtp6cqVX/EXSYzacBDgajT7Np7Wzvz/BJJ8CJTRFJI67xiBDLPJwN96b0FnluviAcAmqgUHF07wZnRi+5GIuR0TR568p+34RUJlCRSJYQ3Uz5zWjbCO16gpg4jcyC80Leoii4zhSygwPyrS5+UrTiCVM86HFyk6IIlcPKmeIXzchyjlA0TsrjphWTOqRpIG5X/1dcY9KaK6X6OtJC/kBu/tUPnqMZUyOg7wT9kS9vQ4O20p7nVNff+j/97ohmgHjKauiPL8+kDsj1BUR3gdv7PbgeHcmdcLrTBBUee4rFsPLWlIP+nT9vtDF1JsBNtbbFhhBORTkcuLOOqX2ISVFrUSkk8PFLjOW4AZSpRGpfpUMk7ZsVaHduvd1APWLhPbfEiuEnMa7IjVdwh9kyqRaPrw6565pS0a0Q2s91U04rV7BA2E3q1YbjLD0Rz2Nc2e2NfqAiNQI5ZsyVFpoLIz4oUZRpRyP4KwKJ4nhWF2M1eqRwSQDo8/DHtZraiwXbZBhGQ87kzcVExqjeydr5569q5cLDWE/cR13iq7imNRxrDtbk+HQJTCem6HO55YEk4NSKGbvU+mkdaXzVbX/qF6URDLuBeZfqb50hH4Wps5N/ex/fzN2f8EyER4diOpKiAgk++vMXk6N6mT89o2LdnSGG9XOcWvPGVRJjuJXRXcYGCTKISlQDMEWmi6wpU2Bg0t/Gc3KyXe+pENTBnoWr9NAxaVMCZ/01Yiz0FbVChuV
 9b7rEBUh
 gH8zDzxoUuU2Shw/LZgGWlVTg3hrzxTm4vXktlcsw/X1YkbXTUIxYLp6IDg4gn+t+iBQL23TQt8jhvM0D0FMMizoTy2GQkwIIecb/ZC1bKMnX3dblazzRvyEwBSdbceax2JFos5GwVCm5vhTH/Cdpmgw1BH9Rr77N0KA12hPxNM4dD59swaYalqXrrVELhqJ30Nj0uNq/9kHKJwFvrSQpz/xQMCMaGjvwCm9wA8LNNbhVyN90UqK0qa/Uv1MmHw8ar/Gtz81cQbQwJXM2oQOaKG41Xo0mPDHDPtYVnaOYLkg5P1kjD6BCA7eo5nHYu2TZDP/pBXx4t3YPDk1z28bwipQV/w404+EDVmOyYGTZeA0rPVEg0hRNFnP9Lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  8 Jan 2026 19:15:35 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> On systems with multiple memory-tiers consisting of DRAM and CXL memory,
> the OOM killer is not invoked properly.
> 
> Here's the command to reproduce:
> 
> $ sudo swapoff -a
> $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
>     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> 
> The memory usage is the number of workers specified with the --memrate
> option multiplied by the buffer size specified with the --memrate-bytes
> option, so please adjust it so that it exceeds the total size of the
> installed DRAM and CXL memory.
> 
> If swap is disabled, you can usually expect the OOM killer to terminate
> the stress-ng process when memory usage approaches the installed memory
> size.
> 
> However, if multiple memory-tiers exist (multiple
> /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist) and
> /sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will not be
> invoked and the system will become inoperable, regardless of whether MGLRU
> is enabled or not.
> 
> This issue can be reproduced using NUMA emulation even on systems with
> only DRAM.  You can create two-fake memory-tiers by booting a single-node
> system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
> parameters.
> 
> The reason for this issue is that memory allocations do not directly
> trigger the oom-killer, assuming that if the target node has an underlying
> memory tier, it can always be reclaimed by demotion.
> 
> So this change avoids this issue by not attempting to demote if the
> underlying node has less free memory than the minimum watermark, and the
> oom-killer will be triggered directly from memory allocations.
> 

Thanks.

An oom-killer fix which doesn't touch mm/oom-kill.c Hopefully
David/Shakeel/Michal can take a look.

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -358,7 +358,21 @@ static bool can_demote(int nid, struct scan_control *sc,
>  
>  	/* Filter out nodes that are not in cgroup's mems_allowed. */
>  	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
> -	return !nodes_empty(allowed_mask);
> +	if (nodes_empty(allowed_mask))
> +		return false;
> +
> +	for_each_node_mask(nid, allowed_mask) {
> +		int z;
> +		struct zone *zone;
> +		struct pglist_data *pgdat = NODE_DATA(nid);
> +
> +		for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
> +			if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
> +						ZONE_MOVABLE, 0))
> +				return true;
> +		}
> +	}
> +	return false;
>  }

It would be nice to have a code comment in here to explain to readers
why we're doing this.

