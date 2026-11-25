Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DAB606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cBqN/ScR
Received: by kanga.kvack.org (Postfix)
	id 12AD46B0A09; Wed, 25 Nov 2026 08:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066646B0A0B; Wed, 25 Nov 2026 08:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97F16B0A0C; Wed, 25 Nov 2026 08:08:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3EEB6B0A09
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:08:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53676C0819
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:08:02 +0000 (UTC)
X-FDA: 85473669204.21.403647D
Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	by imf06.hostedemail.com (Postfix) with ESMTP id C5799180012
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:07:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cBqN/ScR";
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.30 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795612080;
	b=LqAlpyje/ItLgJVQK8dys99v3dWlRFrRAHPc7BfIXk7D0Oyx74Ldh2Ha7x2wt59t9CEIuc
	C5Vys39+x2D+aA8+CbtXRyVIt951ybLsbH2+lcpRqm9tm7D3roICb2/oGKvtsYrfEIr5Yz
	8MwLlSTd2BzpUPv0vAbbY7l18HEoYW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795612080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0DEdpN3ojeKgoLctDTUtNsR/rNFWVH2tWR5Eb+4pvc=;
	b=GlP0SW93qgBNJk0MwXRpcpRqJH05R5LHqxlpbawnZY1uBC8HU7A1VAb5x78R0KewI4RcoJ
	upqjBOsKGFfJdvyCK3QYYgT4VCbvZt4NAIpDz8ouXs2fOCRrH1LxEA8pALVAI7dmMHm+rY
	C+oX9s6XW73+cvBWs5aj6225AhkZIhs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cBqN/ScR";
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.30 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KavEao8O84ypd9lQF6n7cjGolI9drRYJL3+xCTQEsiw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795612077; v=1; x=1796216877;
 b=cBqN/ScRkVwyzquPAkuANMSGbAus36I+6jwrY2z5grU4XCfAHE+gM0MOs+gBKh8S6VChz4Oh
 rXAqN0H2gDKkbMXrnzyuP+gWVsuiQCzOMwdm+D2vik+Y9wa4+7fDUFWn+EUb6uiecTuOES6VNs8
 WqK9m7fEG2AP+vgHPrUl+LoM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b2a14b8d26fc06d9;
	Wed, 25 Nov 2026 13:07:57 +0000
X-Mizu-Trace-ID: b2a14b8d26fc06d9
X-Migadu-Flow: FLOW_OUT
Message-ID: <c76bc990-e5e8-4058-ad80-3a766a162b0c@linux.dev>
Date: Wed, 25 Nov 2026 21:07:45 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/16] mm/mglru: Make swappiness=1 file reclaim more
 aggressive
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev,
 kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 zhuhui@kylinos.cn, sidchintamaneni@gmail.com
References: <20261114200803.23129-1-baohua@kernel.org>
 <20261114200803.23129-16-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-16-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C5799180012
X-Stat-Signature: 61ain4mfqusxkdmhm3jdfk5z1qfc4xbq
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795612078-380003
X-HE-Meta: U2FsdGVkX19sp1nwMvxNvGG3PKbN4NjvO+Sw7A8HWtFOvq35tc4WTvqxBXH97z5fBnVLXZflVK9UGQ2gPKOZXyCgfpLvTGMLr+XbyYWV8lMw/YSCY/kQjfE31dQz7jSerAfRNP/PCfsgwf4tm3Me1TxmBzXofUyo5R0Ks0UOBCy2FSu8iKxGEX+grNq3fCqSedOR6a5PxoZkqE/+XZMjDZtWOtEzEI9R6klIZsE9x2jXX59vnWPmS39RpkV6DJYlwzkKGD1kTSaMjISuLFyLsOegwD10FB83HStIddz5IN211fgLKX/gUk/GI7ixfX6g3WRlYggSQSPoJLTZZ0rFgJcrz7AUIAVmEOwDNvic0BYM8BmBFSF5SQEaNl+UXeaAa07h+8+FFzTdbzlIHATyQ3INuQhfMc9kzNIN18fMagqh6QfnyAPzlhaNsGG9ZMST7OHUvj7GAIY/bshm8qmWTRGwkfGn7usKujtdhzIZSEnbNsGMEPB6dalN5cN0wzHZ63LfLLNH/IB7jbG1siAhh7VUP9arx4LKzl9MoejRADekzowEfT70DIUjwH+/fBcQRVTuaEpdbnzqgCBgEzYpOiF3eGRvi7xGnQhngt3tKpXFC6nO19J9gpSmGfkwL6egIYFiwouHD8Wmm2luVuiS2d0H+nj1IDlA31zs9wvVE4NMibBt9Y3kUlUAEUg23z6yIL0hZ8QAZLapv+FuWPfmHRsi3f7smpSX7Bftgu1yF8IchMVhfIGP+2tbIASwpgcW1DLJWYSB4PGey8exavBPfy2J638BCxh8t1RRenTVvu3EPyxiBeT/SlTejsh4SohsrnYj2dxQ5QOhZaqbIEBNbvX+53FAcRJtLypNjveExHbR7WfEqM/NUy3CF43vsp2i0M+zkxJIKNQYi+h7gXcSq8kd24L+lqw2wUCKJ3XTFTK4jAlptzPICsKTuQf6zkegPoa5sZ5rlj9NGLlPcJo
 6FIPmE6g
 deC4J8ZhHMM4Cu+0n+z4GFACgT+6OUYfiPxgfgYgR582x5nSNvYBVpxKNbsLtbP7E/HhfXgXmdM/PU+tiWjQpoYZbXOCH2LBbKfD66DJTfieEVvuMFqeclv8RzY06TtW0Fy8BBX/yv0u52ZBLihPkeDar08y6U7O395oeu1VNsX6I25i/KoItBmEGRd16bV6n573FyAzdik7hV683OgePx1NG/kjZwpkfYHiyLEesionPqJZ9VQVuSYDQm7tl9IluVRKZOPJqgKU3G4MzcVJaeG4VDnGNglNWdQykNFAJRDIlRImue53mObZphPlCBc8BXx13SRj3yY1wd3wbEHB48m/RZgESFx1E+/C0TCbUPgRR1BCw1dRmA30Z0PpZoDs3Q4igytBuQ5jSTFhQVB06Q11ZnE7DCRCjPmOekQZkv0l6FyTeBWoR1hXRKpbN6rLML1WQSgK59298+PZibCRyv/WV/+LVHrGlfxuWE7MbH54ApaMAJI1EjyS15sUKMaDMLz5V19SvTe9fKTezngXpLlaAF66favkybAc+R/qJtYg5i9SnXXYpy5pPM7R7lNUM7gP6CKPLSfWvhF2AfIee7GIcgxQL0BBeRhi7YkEfX0CXe8CWD7S81bo9bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:08 AM, Barry Song (Xiaomi) wrote:
> In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1
> favors file reclaim. Swappiness=0 allows only file reclaim, while
> swappiness=201 allows only anon reclaim. Thus, swappiness=1 and
> swappiness=200 are counterparts for file and anon reclaim,
> respectively.
> 
> Before this patchset, get_type_to_scan() always returned
> LRU_GEN_ANON for swappiness=200 and LRU_GEN_FILE for swappiness=1.
> 
> For swappiness=200, file_factor is set to 0 at higher reclaim
> priorities. Similarly, for swappiness=1, anon_factor is set to 0
> at higher reclaim priorities. This makes the two settings behave
> similarly, although the thresholds differ slightly based on
> testing.
> 
> This allows file pages to be reclaimed more aggressively and
> benefits workloads that prioritize file reclaim by using
> swappiness=1.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index abefd91f5b95..a9b97d23838b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4955,7 +4955,11 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
>   	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
>   	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
>   
> -	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
> +	if (swappiness == MIN_SWAPPINESS + 1)
> +		anon_factor = sc->priority <= AGING_PRIORITY ?
> +			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
> +	else
> +		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
>   	if (swappiness == MAX_SWAPPINESS)
>   		file_factor = sc->priority < AGING_PRIORITY ?
>   			      refault_rate[LRU_GEN_ANON] * file_weight : 0;

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


