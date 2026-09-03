Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E94C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083376B009F; Thu,  3 Sep 2026 04:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034186B00A1; Thu,  3 Sep 2026 04:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65336B00A2; Thu,  3 Sep 2026 04:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B723C6B009F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:46:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 903A5801B3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:45:58 +0000 (UTC)
X-FDA: 85171818396.13.EAA23CD
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id BC732120009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:45:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cW0GuWmU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788425156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIa1KcxtKlzePvmdnnhCHyjrKBpT+nlLmPKgX7ZVzsY=;
	b=a55dPUi9OOeUa1uk3ftjCSG+o6VCFKltVpaV4qd1g3xpjEC6M6A66KjzUUwdjhDDhZfScq
	+4f+NNSnU5xQCJa8k1lAbqI3P1nGhpc/I6BvZTkowdk6VF4FDxmZOkTdJ2FMurlkMb2DWH
	7X1X7zduADmpNIfcRW+lwq4rqbhkLUM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cW0GuWmU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788425156;
	b=FmMkU9IzR42oEDezvkWRCNtaRX+Ny9wPPrKJrqI9RuO5OXcVNGyuwCHHkCYj1besPVGpr4
	bh8Efaq+vzRNisYenCVJkcTtlQ1MS+1TgqU5usSiOkBg3igRcE6qpz1BwlXZATgSRNWT6u
	E4aPgx4cGD4MQ3Zq9OSknWoajFTx5nw=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84830c774a0so2330403b3a.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 01:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788425155; x=1789029955; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RIa1KcxtKlzePvmdnnhCHyjrKBpT+nlLmPKgX7ZVzsY=;
        b=cW0GuWmUL+kHtE7Jr6iFX6udzwayY+ah/e8Zt0Ll1lyg6kwzhJDZk7A2M/q79p5TA+
         FfknWfwzCqCx/kCJ6fuN+vd40FlBcjEw5EBkBO8VQsWN5HBgmlEpH9NppdP7TQAcY7/D
         xt6uL4qlQSho4EOmIyzzsGWN6ttVPjClgKQbBfWe0ShYKnM5DvVxwDERmschK2MjSkSm
         eH/gB49QjgYtGEWVQtlVcxNdI0bCOD7+eUwcqzn0OizDce/xXDO5d+ie9sLel2wl8dEV
         5VIf5pIcNzZRRWk2e6z1Go+B/mqGZ58R+BO1HYVTbCdfCAuv+2Qhyi+bQFQvAjHXNlxL
         5QKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788425155; x=1789029955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RIa1KcxtKlzePvmdnnhCHyjrKBpT+nlLmPKgX7ZVzsY=;
        b=J8SL7Zok7D8EqoZUBm1TaIRSOU9fpTBUjO+x9LcNZD+VVgD9BOpfB72ihZ46pV7DTT
         hEDT72CjYdwdFLCeeH5XIlNLqp/LrTitiZtgSfeaHoRvsEo8I81jQC/ax7tbnjLpGajG
         7Ag7QfVLjoM3NOxOs3zpt1bfH0RVD/Z8/Nz31R9olvDg0oQRyBdTV//3XzpIFuDxt17f
         RyLR6O7cIckBLr99/WwvMmLx6GzMQsvISS9Ps1lkKk1nKsNr7u5dTsAra46F5APLbJ8r
         O43iV9CjKlVP4TfYd9jgHJoS+S7wz2mPegbK4dTtNo3kNFFbavcAuILbENkGabbdtZt3
         6LXg==
X-Forwarded-Encrypted: i=1; AKwUvBzS9uAuBTH8zG4NhDRWVrpVOggEPOQWwKnTT/oiu0GVDi0sstvLzpvpQVs6l3K1BjFnxn8w790b+w==@kvack.org
X-Gm-Message-State: AFuF++mqB6SbOTYZymGZiy7M3D7M31vdSFz3/0ZoXkQEzGC+W2qeM+ss
	4emXWx2CP+XuL4XN0LG5Yt8EjtiPAJFci8Hej4q+O1GJZj9y6jKPrcd8
X-Gm-Gg: AYBFou3SgRsGDmIhRoi5aXdT1oK0H0E+y+uQaiQBUtKS4brUe5SrQL9iDqY3JghjRaT
	b6LGl6btLnPqLa1nePXtUobKJibzCgPi/F07Ogp7wd3e/6okfvC3NbwYcwypUQxpPaEVAU8bf3b
	EXnd58KgfmCjhQJu6dfRyaXjEo8/Mh6ZkUc+N7kM91xssF/RWOKyWatV+/5QKc/8+lblQdnZwtv
	dZAVgqTOtWAzNDxSDSmtGolrop+fz7Ccg/nHNsbP4BbQXeB5uB1wxFK6edn3eiDJt4JVRmf/0Xq
	GCd4nkV58lQQLkRsO2O05BnyBjQ6pKfscax+J/zwawsSveEhGTYrFeScZyHR8YIutvE+wh1VKwP
	bEseLctA+LW20HKUnXR1f3gs0fKdVMH6korJJiNZVEErgHNF1nDtRbYNDNcmEg+tgllK6YsSDDK
	gPchR8maoB1LdcfGSFf2ClmrBVXtQoZ6OHD80LdyNBX/laiEcTLPr7S0cZIqg=
X-Received: by 2002:a05:6a00:3696:b0:845:e8b5:8c49 with SMTP id d2e1a72fcca58-85ed24e33ebmr16410228b3a.10.1788425154963;
        Thu, 03 Sep 2026 01:45:54 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2e82sm2494935b3a.3.2026.09.03.01.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 01:45:54 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 3/4] mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Thu,  3 Sep 2026 16:45:45 +0800
Message-ID: <20260903084547.960584-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902002725.108635-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mswgkjk65xcrbutukaf5h7eb34j555j1
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BC732120009
X-Rspam-User: 
X-HE-Tag: 1788425156-282544
X-HE-Meta: U2FsdGVkX1/0/+uwdKM475d0U1Dw/GQn0Qjae+YLPODKDa/tUxtQNLu2thEQYWteJx085JYN3GhLGurVnq/UUauELBxQs6/XoRZu3p0+REY4uSDoMYowqccRmubyf+lNQbi0d4FNIfkc4XKiOpSV/Y342c19lDkyg4MqvDVE1vdC7LLAIuc42z1YysCx6tTMHTrFOt8Bb9q//ZiO56yo77t8MC34PJcgF/Q3VUMKvSk3oqML3FHdwLl0SomNmwN/1lZ/AAc4POnTxt61/md0FHfJ5mgogzPXvaLe1eGWO6fEh12NIgaW0oVf/iYoioLeRbxWpuYWMkU4sEP31Rb46B49AFRo2fu2uqYL1zY60CRhC3/HbodhkT7AUGHtxgH+ivL8UmWwJYxWFTV3ncbMnpzFT2L1FBJJLjpxelXmBUwef811KnwnJPwe5pIdMRn0aMyoVS6N6ySx7Q0OyGSlGJNwNmO8KnQN1P9RxRC0I82rhb4oCzkhtp3e3dU2LBH4RGniD9zYvmkX7GFNaNHyvjbUW91g1AixN68rvrcnZpDHjWfPK6ubJKp11q3rTW3zbVQB3EgC2P8+Oi/XD8sUT7iAzAPv5RGJSnkd0NxyAwIX36mkb6IJF/vlD1N0lML5dBz19+hOt+WRjNAFToIabC9BmVHKpdSOyizRbQ0I2DfhO4bZX9EuwkjEG5hdNFEbXGcRV9H0pTH08GVGh9IhQBydRaQyIWLub58SzrWXPL+jDcqiYPc71t6NVxY/r0pGBY7e6UlUL28DySN7v23RrECUBTmtv5KGb7OmQqm5ZsmhTDFAert6i2wszUvZKHA/eiTza9nh+Bfi5QJ8nbO9jTpdJwaU8CfEjwuuWf4wBHkOyAJ4p0gM2v9uCtpTXnf+XOhlZt1gMVA1AZRoaQPgMPG48GvM7wvM1GmMNhdaisC5CrM5bZ0wAeBzkRGA05bvi5ug7J65d3R3sFuEdBB
 6Fpjs/Mj
 pOtm4uZMLUUP2tN1WX2dL0Gm2l7UZzn3LZ77QEsr/arPWILlhg8Mh43fBeC1NI8nA20upVYdW93jYWicdZAwqRkfBFL6bTo29ww1AWgfdj0VSMYVsG+gwS/3luYH5mxGlEtwP6qa6iHCPQuVUg//Nn9G8ENSdTtpBTnpbl/BBr9x1GivIKvb8L6G8TRlHTHJRODukgcqjBGaPlrjEpz/O4B0c7aF6rdGxQ0PfKF4g4ulax+8s1k8DjJttJlOw/b+WitLLialvEVRp20GPUMpiwKvMgG3UY+ezJIvGqa5aUfcIvNYFR+5HUVCZ3R8/ibpVJoQJ6bUgKudOcCi7aCf0dvHHHvdMTk6/lNO/0Z2lzIXbWRQODVVFVixhozDeZpOUs6I/8mwdQIX15WZjehk3fHmbN6uEMceC1MpHltner646P+xEB5Zjt5Mx7b8eGinXS8NdBNTYQAAm5Pmu3GzlMq5rJKKvlRsQgSawj76B/y8b90+911wKLRZzvFliyyqDNBqEAKUdIv8DTtw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 17:27:22 -0700 SJ Park <sj@kernel.org> wrote:

> damos_commit_quota_goal_union() is not updating the ->nid union field
> when the goal metric is DAMOS_QUITA_NODE_ELIGIBLE_MEM_BP.  Hence, if a
> DAMOS quota goal of the type is online committed in a way that it will
> reuse other quota goal's memory space, the new goal will work with a
> garbage nid value.  As a result, the DAMOS scheme can show unexpected
> aggressiveness.  Do the update.
> 
> The user impact is not catastrophic.  No leak or crash happens.  Doing
> the quota goal online commit that can reproduce the issue is expected to
> be not common.  This issue was not found by real users but the AI
> review.  That said, the issue can reliably be reproduced.
> 
> This issue was discovered [1] by Sashiko.
> 
> [1] https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org

Hi SJ,

The fix is consistent with the other node-based quota metrics. I also 
checked that damos_get_node_eligible_mem_bp() directly uses goal->nid 
when calculating the current value.

One minor typo: the [1] has an extra k (kkernel should be kernel).

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

> 
> Fixes: 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
> Cc: <stable@vger.kernel.org> # 7.2.x
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 20748b0a71026..53c3f97e3f126 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1143,6 +1143,9 @@ static void damos_commit_quota_goal_union(
>  		dst->nid = src->nid;
>  		dst->memcg_id = src->memcg_id;
>  		break;
> +	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> +		dst->nid = src->nid;
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

