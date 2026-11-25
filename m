Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9F6606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mO/43vME
Received: by kanga.kvack.org (Postfix)
	id D01BC6B09FB; Wed, 25 Nov 2026 08:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2546B0A00; Wed, 25 Nov 2026 08:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFA66B0A02; Wed, 25 Nov 2026 08:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED8C6B09FB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:00:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D11E140E9C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:00:48 +0000 (UTC)
X-FDA: 85473650976.25.6D99D4B
Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7B85140007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:00:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mO/43vME";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611646;
	b=RNv81qKF1QbWsiHqZzqQ/TiItnfnNVrRcZ5bwAIglBF1lsFA830IZDMdZbLK+O1SrjK98n
	S3lTeo0zR6ysbaddPcPeTp1eAbegSgG/teoeOo33P6lJOSF8R0nwJsMPIZ/Tsh3d8M+MJT
	Pdq0xGzv76lK0qUKwVm7lRNLOlMTN/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFy3WviaYP7EOH8706hEhHzhb+EluVzWS5SXIUBm5Ig=;
	b=2jpZSCQcRiqsQU3dUSws2mlJH5ahIoI7zbxjg/rqoQxWc2caZY7WuH8do8bkVPscFTVL33
	DQYiiFxSY151VXkLIV/M9VQWLeH7BGQX1/old27hbmQ5McX9Cbe6YNSnUgjkJDNdEULwud
	8npRC/UPrW6nGwjxWtKgN3qRwc8LCRo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mO/43vME";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=v0ANhT+rIRKj1GNWz5h+Zv0aeoPAdiTKhvM8PO5u0YA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795611644; v=1; x=1796216444;
 b=mO/43vMEyF6YTkV7gcdONEBCuLV4ZnrU30ekWn/DubRT1b/CZyAZngqmfTBoeQp1ulZyjxyO
 ixD2/CSy0L0SA8ypv5e+g9725mcVvON8l0cm7EshhMllHV2zMpl6WHeH2gmGPmxEBfXdLoWG9yd
 qIFsgXDS6r9pdvzU0HPbKWyg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0f1b50c62d71d176;
	Wed, 25 Nov 2026 13:00:40 +0000
X-Mizu-Trace-ID: 0f1b50c62d71d176
X-Migadu-Flow: FLOW_OUT
Message-ID: <3b42b905-ee4d-4c0d-a266-abf27bb10bf4@linux.dev>
Date: Wed, 25 Nov 2026 21:00:29 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/16] mm/mglru: Reduce LRU lock contention by
 shrinking folio batches in inc_min_seq
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
 <20261114200803.23129-14-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-14-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4iku98xw5o4bjhwm93it7d4fsg16zmsb
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: B7B85140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1795611645-591679
X-HE-Meta: U2FsdGVkX19q/XU7QGgTYgDO0TXJZO8YWH24j9PSq7e3jPV2+AQuD0HIcxxFUcwbizi85wvkRpKFbW6W3PK1S8TAa/CFM/93v47rYvxc7BwBmDcMlcdvsQTNq3dRWnq7BshDLfP4oVHS0LCwqj6J9N+/UZg8QtvHNwkPzXy/U4djkY9yEsXk/pYY/3YdTVIIb0VQ56w5UXSroffi9UGKXH4mtapAvP9MRzLAtSkNQQSHZePDxu28T9v1/hJwPSQ14FbJB0ukziVpn9VvEbK3PQlMUhGkp0sQp3ZfCyJlcV0i5CaCCBeYUfaXZND1kspvjwrHvHpDytnoVvmz57y0G+5JHYxhELz7Op0jAYUu6Sho5fAAH0izpVSECDD/Qa45b0oTIRwpMJV33Eok0xJsVfxyq9witiM/lljgnjTEFeQvfo8L3ZQnnY34Ey89uTK1CH2RzUYlkMgBv2CcWDz3lhoaEMVcYKeHi1xMNWt2K7UliprXSYH37TnuBm9FgGsQUpZgeIaEEHS/5w6IE5eG+ESe2ReZELGEd6xEIfNoKInqjgtqVufuei+A/ObONv9moVUJVoIAidsG7s4BiRZxzOZYXojOAXy8Ztr/8RE5luivatDZM09gI6TShaPv+2eXK8+eEsiHfBeqVFEf5exj02B+HZL6Hy+qZ/BvoGI/1jIW5OUD4lJePD6UI1Aph9RBrPjYY1vmfnUl/Hvv2Q9V7QDGvt/zelrOls64Bd3SvnBdVeKMlvg85bigok5ok7c0qzOWToWE+fdHWqzHHg2bc/blNiWzbs9vrS5eFQNXTjQCKS0bVrpYdX5OFc03jvTqk6l6U2afT0fR/y8SL+zVhiJdBhonQJV/jiZ4F/3h7qxZ/xS4JY3t2MmHVDpL8oHoS0bYqsKa9wx5EaP3YCUqS21cVoXpZkqDSj9fet/oESGnda12u0cJ/zpaGBNQKNO72ebglq/JQV0CUwRo9Kx
 wWvz7dIz
 JdYEbH76wdgzTZTU2WXfE6IAVsDw9JM/491qkbLBVjqg+OwnnoPmJ1kTA7tm4t+hTc+y0gqXnaMhzW+hd7QM2oqjm2Fo00ZuCRR30VbfJYQ31CshnLOTjbSZkFUGagDg1R74s4RDAnKWfMqe4KNDKEQ4/RBSGTcFfzlLv+ULU/zdqlKnEMrXMhlmQDMUNePKLQ1DR3a8W7XanhiHLH3iRWg1X3JONBQ7HTeYzcHPijPKU1PwUM1UGtKaCE5cnTIvKfUXJnRmk+7SApg4rvCItNzIJnfOeEO/Oy8j7yDO3lEkWuMtJuOG0nqrQBKFUGyUOq+eqiKjhmiPbtc2488Sr2L45shNCaE8ql0kJff5Ts/xM0j39i5cmjjFRK2degKpgZW4Tp4Z+Im7r2jWIEwB16LMCJ4jWwKMNbsHXvUjQELCNkba+ahlud8Ys+kPP+OaTIDdItRFfSxqXDkX5f+Mu/pW2XBnTq6s3O0mFqpIgEHtqwzb1OO5gbj6SGt7o6XeG/uEU03084rSYKUk/XDS/9Xzt2j/qR5iHLUiKmLiGSaZHWEdEotTrq+eTiuu2DlxG3MiFG50CACFlBmkHzoBp/vT+VK+FZZxv/6EGzJqWbaIqhRmB5CgLTePRI2VfkdOaZdAF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:08 AM, Barry Song (Xiaomi) wrote:
> Reduce the number of folios moved from the oldest generation to the
> second-oldest generation in each batch. This shortens the time the
> lruvec lock is held, allowing concurrent LRU operations to make
> progress and significantly reducing LRU lock contention.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c9e22a5cbb51..6cb905162cba 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3914,7 +3914,7 @@ static inline void flush_lru_batch(struct list_head *head, struct list_head **ba
>   static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   {
>   	int zone;
> -	int remaining = MAX_LRU_BATCH;
> +	int remaining = MIN_LRU_BATCH;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
>   	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


