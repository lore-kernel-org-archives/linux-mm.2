Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E89111227A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DD16B0088; Wed,  1 Apr 2026 23:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E896B0089; Wed,  1 Apr 2026 23:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE416B008C; Wed,  1 Apr 2026 23:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD6C26B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:37:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8850F8B653
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:37:02 +0000 (UTC)
X-FDA: 84612204684.02.85DC64A
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9F10E1C000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:37:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Rdrc7/V3";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775101021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZXLx++acdRu8DhYwcXdDHVnQSYFW5gNE6CjD6mZNEg=;
	b=tMkxls+cnvOMPM9tckRQUSio9RnV8fhife91yYBUt+8qv8oRkVdub4A4GL9nrFFKONIZHs
	I5InWXrIgs4oGPb1hAU7skcP0XET5rGZja3MisfKyPmUTjSPTKYOrGTNeCl4HLBxWPWqBw
	AlSPYU8G0upOGo9ETweSsxpUWPjYr8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775101021; a=rsa-sha256;
	cv=none;
	b=Eo+x56TcRPfObIqDK52M08mpgy+344ts8l9AnWsIMhAd97YAhD1BKgfDgrGEr/bHMbYeFM
	WJ4f+SyvkilNjmyjXnRIiKTOjVw1Gn5QMCFU53QeM39a0lCUgUZ2sIkI6cM07O/e/xwuXJ
	dyu7wXplRgZ45zWl52Cbn5QkHEL7CiQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Rdrc7/V3";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <fde3e132-0d4c-4f07-8668-09811574adf6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775101018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZXLx++acdRu8DhYwcXdDHVnQSYFW5gNE6CjD6mZNEg=;
	b=Rdrc7/V3J+g4G1hURcA5Rg95YbY0ikwaqnfhQNX2QctZiT0N3cDnkq7PpgSO/xGMDkSRJG
	fSe9cqix0AR8oioa4p3gXDf0KAwzNszKbwrAROrWDhgUYUEkqHckloPm/shNd8O5dLreu/
	dCFlB494z+E61qRfin3ezUdlWcp8kVU=
Date: Thu, 2 Apr 2026 11:36:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3] mm: remove '!root_reclaim' checking in
 should_abort_scan()
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>,
 "T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>,
 steve.kang@unisoc.com
References: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9F10E1C000A
X-Stat-Signature: e8zebsg6iuecjii3r7qfbuqhcq4fch6h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775101020-841761
X-HE-Meta: U2FsdGVkX18XQQ7IQ7bIc0tHA9hJnUnP7MSLUov7M6/qDHQQUs6pjIB6aiperiDjm1+xgwFe0rd07whkapgzN6YCWP8HRPKxN5AlRPWTfCpgDpKad7x3GSRFs/g0fAX/6Db6Q+Y9I3U/7hlCzdfxp1fGmw7tj+bAGgtDsAzprAfW/UaoczdqIdfnaZXH/lb96LVM7ok39y+89ITLXrQHhC20kgbx/0bqSWKj9urv5ATN7Ve5CsyalJuxQGYWYFa1yqPMANB14HWJOBD7vC6j9MEg94RLMGM3UZoEvt2ZUF8oLVvwTMQJqIYm8G6eY4Ly2QrmbmtifKFXFQXljapQM57dDLuRyjp0eqXXQ8sGYaxK78CgOLAM9fznBw7V5kPjWQ8+wZlBItWIb1i13un47fs/C5D1eoR85f3oLybPG7gRXHXH2kpL4JnCUBFs4vRbGOWfCWlVGkbrtl9+v27Ym0wNufrX9Vl3yyWetConJIHJFkpgkF9JLJPphCq0jTvKTYLrcbesVgxTyxclyUQvCIntVYPhpqLQrY7CaW8+P1mtRUDs5JzMwmb7V6VROc7f+FTu9dFI5gHTJaZ3n8YAMAE/JJZ32Scp+brS59/4K+HHx91NG43XT9ZWSYgVZXZ9oaHCF4AoZ1jBd83qu23iIru3nI4WBkOXR52xyVGjB7ix18Bmmj1BT/qohCw69wezBI8gfqJsSuDcGWktCpbQwsvFddkIzCcW66L+CYTJEGAJfkOrZ1na+0M72m7LE5IsiZdcTtGJcTMkXohnCWLjbZVUCD5nwu06TntD3j6rQDAZ8IP1SZa0WYcKr4U9w+gGgxRMJj2+b9P4TVT9UUUWvqJ3J2sb1CZ9tDtAayJQtE9c0YEJ8vopJ0xDWlSZB51wb/Kjd0rGc1v7BBS6F2mgnCwCbmNsnUsclQqxvlGhkOdss/cRIbSfhFW85Y7SQAnv0QviODa0L56WfYsweqC
 irBSkSRa
 YBG1bVkoJ1fssiFM/cmUZzRmDIVdfC/6KgKtkZX0rTWAFq3DpKwhAvkd+ohZ0oXEHjPwfZ8S59fke47JCq+G0C11sOlIlcPfnpW96fISml4b3GzvoUXoXGN1XoAQNgEUaCkOHO+bzrlD0qqdX/KQ+p3oqBke0O2Y7fVFVWqr4VMyi1I9/nnkl0Pfn9PBv631Ho0TMzD91M0YHiOS64y2Fr+g6T5J77V+WvHtprT2cXwJOpt4Cb55YnGy+wxmRb0m1pu+DMckfq2pr3ewF6kw+dGGrhNnu+A/yyKr+3WEwZCSbaNTdDUyaz5p6EwfIx2+cTVpIodujeCZLCwGgBOhMm9z1aOG7dlB/SENzRtLYzYskb1UKzNntFqMCn7NInuSd39WO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/18/26 9:15 AM, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> Android systems usually use memory.reclaim interface to implement user
> space memory management which expects that the requested reclaim target
> and actually reclaimed amount memory are not diverging by too much. With
> the current MGRLU implementation there is, however, no bail out when the
> reclaim target is reached and this could lead to an excessive reclaim
> that scales with the reclaim hierarchy size.For example, we can get a
> nr_reclaimed=394/nr_to_reclaim=32 proactive reclaim under a common 1-N
> cgroup hierarchy.
> This defect arised from the goal of keeping fairness among memcgs that
> is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> !root_reclaim(sc) check was there for reclaim fairness, which was
> necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> incremental cgroup iteration") because the fairness depended on
> attempted proportional reclaim from every memcg under the target
> memcg. However after commit 'b82b530740b9' there is no longer a need
> to visit every memcg to ensure fairness. Let's have try_to_shrink_lruvec
> bail out when the nr_reclaimed achieved.
> 
> Suggested-by: T.J.Mercier <tjmercier@google.com>
> Reviewed-by: T.J.Mercier <tjmercier@google.com>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
> Patchv2,v3: update commit message
> ---
> ---
>   mm/vmscan.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..10f1e7d716ca 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>   	int i;
>   	enum zone_watermarks mark;
>   
> -	/* don't abort memcg reclaim to ensure fairness */
> -	if (!root_reclaim(sc))
> -		return false;
> -
>   	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
>   		return true;
>   

Make sense.

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!




