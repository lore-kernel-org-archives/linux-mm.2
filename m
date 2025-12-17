Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D11D65C43
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6206B008A; Wed, 17 Dec 2025 07:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4116B008C; Wed, 17 Dec 2025 07:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ACFA6B0092; Wed, 17 Dec 2025 07:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 183196B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:55:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 977F1140AA5
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:55:50 +0000 (UTC)
X-FDA: 84228960060.23.7736374
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 268F840009
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:55:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uxwtsLIO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IiEo+OmL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uxwtsLIO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IiEo+OmL;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765976148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4arLgLyyhNXwodcIP94lI9F5JTrR8TRXcuQJUxnRcKQ=;
	b=1URffsRUgBflFvBDkhiOVyCpT0/6/N0asAKqViTlIPL3mGLyXjjX6khn12pxjq9R/2Vhnz
	175leZVb8eQf16T9COMqdrKnj9857+ZHKIqJJlarSHmIX/JV3PyNjjAA35OFO+rID3hlAU
	RhoNyjLo3i2pFTqOBesq70SWEozr7d8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uxwtsLIO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IiEo+OmL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uxwtsLIO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IiEo+OmL;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765976148; a=rsa-sha256;
	cv=none;
	b=xRljekD6pmXiqnWMc9I/6aOkpm0L1qMslsiKNUR12AP9llBkbhnmDwzcGs2S1t+naWjlIA
	d+e46aWEKY8ebfe0xBMHK0woM/rw5i7vUt9uLbLmyRO7MfgzbulTpEBxwLgU5V7nNwFmj9
	13T+yTQEEBJg96jUhrhi+jpd1DTysrA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6E18C5BCF8;
	Wed, 17 Dec 2025 12:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765976146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4arLgLyyhNXwodcIP94lI9F5JTrR8TRXcuQJUxnRcKQ=;
	b=uxwtsLIOfz7+HXrJxVeuuOq01z9d9e/dsNknxRx7k1n+jQ3Jg+IWlO8jH2CzOdsR2ozGmY
	g+FLLB6dboWj3JWpHl0dT0tfw1OY27VJStXMOWgAidgGm4bNmU0Pw7u3o51aofYi4+SVQR
	Wjb73IgW1BGUA5TPK/f77HZER1s+1ag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765976146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4arLgLyyhNXwodcIP94lI9F5JTrR8TRXcuQJUxnRcKQ=;
	b=IiEo+OmLWr7PYKnjVaYOSZ2QhiJ3u7FuFf/6svO1osZ/uxMPcdBn+pNgjBahWiiYhDGnM/
	ZWob8gsw+zqG00Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765976146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4arLgLyyhNXwodcIP94lI9F5JTrR8TRXcuQJUxnRcKQ=;
	b=uxwtsLIOfz7+HXrJxVeuuOq01z9d9e/dsNknxRx7k1n+jQ3Jg+IWlO8jH2CzOdsR2ozGmY
	g+FLLB6dboWj3JWpHl0dT0tfw1OY27VJStXMOWgAidgGm4bNmU0Pw7u3o51aofYi4+SVQR
	Wjb73IgW1BGUA5TPK/f77HZER1s+1ag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765976146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4arLgLyyhNXwodcIP94lI9F5JTrR8TRXcuQJUxnRcKQ=;
	b=IiEo+OmLWr7PYKnjVaYOSZ2QhiJ3u7FuFf/6svO1osZ/uxMPcdBn+pNgjBahWiiYhDGnM/
	ZWob8gsw+zqG00Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D7D73EA63;
	Wed, 17 Dec 2025 12:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qROsDlKoQmklMwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Dec 2025 12:55:46 +0000
Message-ID: <01d780a3-16ef-4f87-b57d-00d50afa4bed@suse.cz>
Date: Wed, 17 Dec 2025 13:55:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmscan: don't demote if there is not enough free
 memory in the lower memory tier
Content-Language: en-US
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com
References: <20251208094028.214949-1-akinobu.mita@gmail.com>
 <20251208094028.214949-3-akinobu.mita@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251208094028.214949-3-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5c3pnh7g4zx5fo618xyca6tkzbuugtb6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 268F840009
X-HE-Tag: 1765976147-987495
X-HE-Meta: U2FsdGVkX1/K7gUvMNjQh+Z+virdrH9oYjperIkav4PPrNktXUssPo7Yzf5JvMvU12i0FN4RdpwoEV407cV0O0J0Xxb1AIUJ/aqCGy+HwPo0d8iAUiNwJhM7Dr2k32iu2mbL9w53VSv+yJZ2pdDsPkCyGUQ0UI76bCEFOPpkmAcCiNVmac2CcMo+R6R12594fSoYDw0RpuQ31Qv2FfLIsSIDu/Q6oXqtON7binyflHqp5HZUMiyRnkgFSva+UAHcjRvAmNa4oU65Btf0DLrZ9aypTsSwDicBUbvWRFtL7StD5Y7ZlBJyP72RN17php8FFyKFLrFqsOAxf6X0CNNuOMRY8ARFPQLhklSEwNdubaJpn8lrvGXhY+U+Tru1AopthLNDLO2WKX49RkUdxl8OsOAcee6sbCpgQrkmoN1PHIxPohxMyMq5x2yK7sq5J64Zj5Bk5OfwNLwyLmu0PrclgZ0K5HE9f9lA8zYRUvHASp3jErJag0FdiAuflZYydsgtKjBQsXgV0uZFMVVUV36vqh8fEVs70P0U+sp3ko9EqLWUgeRbUmEAy4CvH+t0IZxN2WhsEvjRwTr1ZBjEs5c4/VjP6X59/HlWeBgO+lhyGPWVRl9nT5+2T22ylsCI4EiFTaHcBChg5Cv6JdGNeAhESS7wVXe/D/yJ+BMNCH/ooAISl0in/77lsSDkdO1Svt+UlBjsKJwuTAcvT7Gw8x93vorykBZeGz+iiDMc4PCiVq4nGEABzBDkhd+bxNzIw+1wzpXboxe0FtpWyIOfn2vcGORtXYCTGFgHdcVPQK4t5XreklD2uCqn9/6lPpBIHvkHWGdftrNcpJ1cZB9EJBwBrlTspUXmfOW9VBCSikSorreVGr5jEgBO1gYul+zcq5lDNq6HWrhKMSbdML930dP49XWdfttGoapDJr4bS4kzolPKOfJZyBp/vW5axC43QFzMY3q2wBVlwS97o9FqWSR
 fuNEKx+o
 AmQhHMkcTZiQEQEtCGAoba4kA9GPYdJMFsdAbeN6hbeonRbo3CW6SSUoNco8izRrdpYePckNlMQ5sW+5nbE9rPsl0xf34lewCYpOsF15J4ZK4lESKgrcxSRMhkLSvoXQ9d9t0FvwGeL7tGefpgcYQ9jKaYKkf5Ev4wx04b0FM0KrgyFAb9sZnQRwRK61HersKLUeihLAkT7XThWwmTXZuVL48NS1T7ANhidFIaG2Ga2o0JiwbkCY+cajvDRmBdoh4kldq8/r9E2UvlF+bZ4hSK4Qqzt7xItIvpqjPbfOTjKwevvVzFeonMGNyTM20ORB9VVZoHJmaZDlthxboiquPwguE4YTVH0WBmyevRzb84FkKExARXh17ailwmrkbp0/oLyDP59Z7QVFRi6hMV2XNtH7tvYT9VNCsoD0A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/8/25 10:40, Akinobu Mita wrote:
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
> /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist),
> and /sys/kernel/mm/numa/demotion_enabled is true and
> /sys/kernel/mm/lru_gen/min_ttl_ms is 0, the OOM killer will not be invoked

Does this mean only mglru has the problem, or !mglru too?
Also is min_ttl_ms = 0 a sensible setting? What happens without it?
If !mglru doesn't have this problem, how does the fix affect it?

> and the system will become inoperable.
> 
> This issue can be reproduced using NUMA emulation even on systems with
> only DRAM.  You can create two-fake memory-tiers by booting a single-node
> system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
> parameters.
> 
> The reason for this issue is that if the target node for allocation has
> an underlying memory tier, it is always assumed that it can be reclaimed
> via demotion.
> 
> So this change avoids this issue by not attempting to demote if the
> demoting node has less free memory than the minimum watermark.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  mm/vmscan.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fddd168a9737..f4748f258294 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -356,7 +356,20 @@ static bool can_demote(int nid, struct scan_control *sc,
>  		return false;
>  
>  	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
> -	return mem_cgroup_node_allowed(memcg, demotion_nid);
> +	if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
> +		int z;
> +		struct zone *zone;
> +		struct pglist_data *pgdat = NODE_DATA(demotion_nid);
> +		unsigned int highest_zoneidx = sc ? sc->reclaim_idx : MAX_NR_ZONES - 1;
> +		int order = sc ? sc->order : 0;
> +
> +		for_each_managed_zone_pgdat(zone, pgdat, z, highest_zoneidx) {
> +			if (zone_watermark_ok(zone, order, min_wmark_pages(zone),
> +						highest_zoneidx, 0))
> +				return true;
> +		}
> +	}
> +	return false;
>  }
>  
>  static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,


