Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B99C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 06:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B171D6B0088; Sun, 30 Aug 2026 02:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC80B6B008A; Sun, 30 Aug 2026 02:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DCAE6B008C; Sun, 30 Aug 2026 02:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 708236B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:14:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEB641A025F
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:14:10 +0000 (UTC)
X-FDA: 85156920660.26.D5D1A13
Received: from mta1.migadu.com (out-224.mta1.migadu.com [95.215.58.224])
	by imf31.hostedemail.com (Postfix) with ESMTP id D20CF20004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:14:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Nt/LW7yi";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788070449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPVlpUwNnmVuz/bwrXxvOijQgxItWN8DgnoJyzaf124=;
	b=6wKDVFZJPAF4NdSLrpDG6/vZchRk2wZ9P+5ENb1fow+lxH7i4TnXkwLHx7t8VdaPEW+mtQ
	6jg5Xox4itxvOvIpcvDXvrTmlSuuosLflC0RRQ78B1vUyLYdr/SOngwHVeParxOcjwedjr
	QsKxlRMKmbi56KiNbhPzX1VByrPiGyA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Nt/LW7yi";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788070449;
	b=FpDuCdJQcOdoB10oBayK+wLzxWVLVExuMA5qsnpLG5G9rOfUQ9pf7sUag7jWZE7HNus5Mi
	6VyIQ9H8zV3ImldSaWfTTx6AkXAzWzsvDjAg/hfGhLVL6nVgGut4OztLwdk85K8Qct70np
	T9BSedvrbmehnH5bHAwAPYZ1ORYENzc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D7M512+Zt8aa+kANyYA+pnUSN+4DV9TAbeCp6TmwXhg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788070445; v=1; x=1788675245;
 b=Nt/LW7yizHsELbgkwRbvDM9n5wrHzZrEI+IwfYiUlZJ8zbQzRBXlIfD4VP8Gq0kEMfLRTo1i
 TAFGnKOyPTqbdKznSfBUd616qPxzsXWy05/V5o6QSOXdT1NdJxEkrhAHVDpfLszfnYNtPXo5K/P
 PLj02ZV9omjhtohjXpXwEQOE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8d5b453b29db44de;
	Sun, 30 Aug 2026 06:14:05 +0000
X-Mizu-Trace-ID: 8d5b453b29db44de
X-Migadu-Flow: FLOW_OUT
Message-ID: <d326d37b-4060-4dde-a544-ba71387ea3e3@linux.dev>
Date: Sun, 30 Aug 2026 14:13:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] mm/mglru: exclude folios promoted by aging from
 protected in inc_min_seq()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 lianux.mm@gmail.com
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, lyugaofei@xiaomi.com, mhocko@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, stevensd@chromium.org,
 wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
 zhangbo56@xiaomi.com, Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <20260827234704.63163-1-baohua@kernel.org>
 <20260827234704.63163-5-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260827234704.63163-5-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cdndpn4pk8wgbwwho39bek7tyjkfcy7u
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D20CF20004
X-Rspam-User: 
X-HE-Tag: 1788070448-174197
X-HE-Meta: U2FsdGVkX19uYiUe0/clQ36clnYBgJi7qJ2RYgZTZHDtvTlmOwDFV1KNaa0JOR2s7jDA+FqTGMxpiKYgidLBGxIW3yTcYvE04LzOvqe1PwKUugkFVsQXgnc5r8KSKvt2VXxmoD1HSnbxrOyDbh5r6Zzznn2Dug5/zLAWlLUt7tNZWgxIJqmcfM5PIzF3JGlEierr61bRTbejP1KQnlCbggFLDWDe7eSuja403PlLYPbQw9jzZYag9PMu0PvUHRfPM0jvoX1csOKhFteRCSjTTirloNxc5wlR7kw5MQuRfWKvpFGnJ+OWUsIh5/0RIXph+1Wm9kfuSpKxVCQiQ7u//9QkUmhTJFMFJBC+RfneQIIh9cYogjWk4g3hgF0Zc5V/4AbrSuM7RSdY20CDrnW/3xtzTD766lvDE7xejRt98GdOs2el7zAwPX7lFjy0jvk7GQXfVKXLeNOIETGwd4/6EVN+Q9+cLb+5UIPyEkZwURJVzGdlgmuOkLB8R0GhV6EaUR7QOT0Cy2yYDREjnkM39tqTLEsFrEdk59WLMdRL+cZQJ3dnArfKeFFPuA7pOHgu9kgo4VTVlOCCvg1TlaUaILDsyHoSiuAOxDDuzWvmr4SMXvLC8TtIeJKiKxUSvSmq1V6wjfyCWEOpFRXzUgJq6zIr9uRvSUREBYqNMo83R93/3HWgFP0gGCz7ir3HjhLf93Crx3LOZ5BHfN7iqhjKc5rgNlM1uQKuD62/F8k60eUxzEkQj0viaQ/ArXVi5ZezxRSUIhCnkS2qViMMxD77W5UrRLc8POdWchkS1AAs/m8VkVfJtx2AsQ3/kDl0GjUYL1MImxNuUk7E0vZVL/tzeGcr3E3Q86FaWSrSCM7FliMVDBhUqFDcXPYOkV/PaC5/uFHp2hZSYaYEiZJYI/Jrr0Gc/oQCSxZHRqcjDdUENOW6pDk/c24EBQgM8+xg39cTxsfhgnpvCAFG8RqtB2p
 PoZeBKQF
 bE5RxQQKt+3H6uhFWsMi1Z2DF2bgZXJXgcNU50VCtugE113AdSRuxDGga6D8JQhBoEz4eGFu6CVcaV1uMPoa8YvdUvQXoy5ALODcLaJlbEor0e2EWM/let6IqjIE/CEhSVxBviGkm0Fh45yoniZ7Jh/RaiPrk8QPqiJz8Tq0NGy6MaRhTAon+RlD1Yd5GtqX659ATw/membfMc98BJ4wmWjgRn348YF38AaknARANUrNXxR9m8MdVYXnYFwf1ypfYhiyZQC723/CCnSlfGgU2Y+8qALUTR9zkOBWLfKb4ODo02G7UgivkTbryXwjaOonqmJAsqs1USmnZkjHmHMvM74nNoQBLwVYPCU5w3ys6xR5a0w6CfdP8dfy19RaQMNPMXS1I/hmOplTc7qVNcxx3+mxSAHI0IE1XqG3VmYO+Yvox8Xyz5GYBc6yf2wpOIRn/hvRK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/28/2026 7:47 AM, Barry Song (Xiaomi) wrote:
> Some folios may have been promoted during aging, so don't count them
> as protected, similar to sort_folio().
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>   mm/vmscan.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b10d1703d907..2b33d3f44682 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3952,17 +3952,17 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   			if (gen_increased) {
>   				delta += nr_pages;
>   				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> +
> +				/* don't count the workingset being lazily promoted */
> +				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
> +					int tier = lru_tier_from_refs(refs, workingset);
> +
> +					WRITE_ONCE(lrugen->protected[hist][type][tier],
> +						   lrugen->protected[hist][type][tier] + nr_pages);
> +				}
>   			} else {
>   				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
>   			}
> -			/* don't count the workingset being lazily promoted */
> -			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
> -				int tier = lru_tier_from_refs(refs, workingset);
> -
> -				WRITE_ONCE(lrugen->protected[hist][type][tier],
> -					   lrugen->protected[hist][type][tier] + nr_pages);
> -			}
> -
>   			if (!--remaining)
>   				break;
>   		}

Reviewd-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong


