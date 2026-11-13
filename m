Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3097606A897
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Xs+ZTY1a
Received: by kanga.kvack.org (Postfix)
	id CE95A6B0649; Thu, 12 Nov 2026 21:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0C66B064B; Thu, 12 Nov 2026 21:51:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6406B064D; Thu, 12 Nov 2026 21:51:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 983866B0649
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:51:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CFD41401AD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:51:01 +0000 (UTC)
X-FDA: 85428568722.10.D55CC81
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id D559B40002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:50:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Xs+ZTY1a;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794538259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVe5HwVBkXjfHvoljda/mJvecIfGagV1bTDZ+w25zss=;
	b=MP7eT7InaeReZhse3LJPMNKIRs8oH/UhSoEpFwbPQxhj6cIc76T25A8pKvIuiC6047EIL6
	TGgjKWugSyqXRMeUJ1dnXiEwwjAyH3yW+CquPJVbVpm+FDuWS/LicvJowX/eZMw0A7AwXt
	UJnLCVZ1Rk9Z1ObYtnRQu1WglhphZhw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Xs+ZTY1a;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794538259;
	b=QV0ePXTHsWGP0ZHA9kfwPvk0LVLHrlGZhBtNwel+JvDD/mHpQ6ygsAJ3q5/SEkJodohIL4
	kSEAlORKXn1TB+HjkiVAIGFQ7Ci/zYT+TSTG42xOwt6Y2DUjgkbeF3kWMMN6HKzv5ZGvSh
	ah/n6uUXhWSOSyW28/6RlayBkSQ1Vs4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794538254; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mVe5HwVBkXjfHvoljda/mJvecIfGagV1bTDZ+w25zss=;
	b=Xs+ZTY1ahj0evqtHOE96xHkAO6aKM/5WA+sUTn7c/vRE4Y3Kp9PKA+u90Gzf94kRueeP0W5Tp+YkFkaar7I4GDazTz8yrZI4ckOQaBMnTF6ggXPOcj7ez20m1lAP0LHAdzHR9SvxOl+PX7D0RbqwXwHQLEFAqu36vHG5sJSIBDg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XEdfmiI_1794538251;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEdfmiI_1794538251 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 10:50:52 +0800
Message-ID: <a72af87a-0f10-4717-9d50-2d3480c32caf@linux.alibaba.com>
Date: Fri, 13 Nov 2026 10:50:51 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mglru: yield the lru_lock earlier in
 fill/drain_evictable()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20261113020132.274013-1-hui.zhu@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261113020132.274013-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: shbudxh54495pxbnxjeb8hpmm5samqm8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D559B40002
X-HE-Tag: 1794538257-891824
X-HE-Meta: U2FsdGVkX187GLdkf+Bw/mHfZUNf87OzhweOpEiZwU+1DNwyzO4RILZ56tVC+DYFqOoRxr4F7OiSePrjxAG7+jfgQop5GRRVIq+6B+zRHaIdIU6EijEDsrEwqeTgBXrXsoplcCd26jCoRwyuFdMA8+OnuwVrekWZL9Tun62JVm56tcyPHfDU/GRJt87qkxqohWW1H4yTqRgoqjclLHuK654+EqDVvkcSSxKvncDAlpb2ktLLbT5mH1yL5DSnQVQAxEzK0qp/x4chNH9mQSvwmEvaJLxPczoWKOVygVssN94bwAYQvHE0M3vAJ2D6YyDv/tWFsg7aBeMc3UpSVTL+lfMg+lXIOVCq0YjSa7dIbU8yoPJpb8FBLxUsfp/XRVzCxaXfE/DWFl62sj81plySPEiDnss0lZH8g+SHsW+c7KvUY7/7Y8UI/AhVoet6aLhHjImX9wHR9sK6QPCRHSx6q2pUT/zrqsFrX27Jh+3u5EJfWfMI57glgmqH0hyQ8fy8r9BJ2BIkYlRFJDHxwrTqLs1R5NEYUR2CzUnkOum3VCiwjtm24ikUszkoPwZZV+KgGSIq1PHiadN1Z5QCQQABC5I8cLpuy4Muy+/mXxNaN51SyQUIudNi6DI8+nNW5eSrX77pJurz4CjlexRvvelN9SBoS1kCsB3DresqvGjZ66Ngz3JAJQhs3rLNMVSecsazZ19O35rkM1TnQMFu91XH8UlP/hsmgPhYa4jgdEfnjgGuCV9W49gReGTKWtP6cfZYoBlU0IjtiR16v9F9+R8omrhP3T1z5vEdm35rc+1LlXzboSgMkxVxMfVzn19wiA7SDrbVM0Sag2Yoo5KE7L94ad1rURLvO/RlF5KK9z6cfMOhb/UruhV3S/1z0hxn8Lmy8LA571QRC8aMCxaaKoIskPRAQND6Agr/PvOczrd0ZP3r/X8DtERU4WgbuIMX2igsBimlKFWSUMnm2semfpi
 I/kHxLyR
 BJ+jn01BnV23tZhxd15nfLLSWBsjMJNHgXwC8tGLHO3lE1Ye4xFRAra+DPZywqQKty1xFotvAIxAkZylgEfp9wxQJbIDs7qBgOSU1ieTibs4SlI8w9tVXgq+kfKcOpHU65UroGidJV8ByOkq8e7k/1p0C5L3leQC6K3DXexB20imaiUtVNHUCxQmp/wpvCa4eVSf8ZnNb5eKlbJB2g1uCdTFaoW13KVSzPmXfpXbXKvSqJHfgl7fEfe2gbxmbBDb7p6JpwPJuo/Fh0/Z/HYfO4eovUoNldTowpqkCs+FU0BK0aDfNfQJ2FEcx7p5NUB4Usl3N0xUAnBYpOwDe7TQt9zOc9PG0Q5FgYvtSeaVaJpQL/JRcyEhuckOw8RooVoFtEkNgn+f9+K5VxP/MRizKNj94fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/26 10:01 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> lru_gen_change_state() migrates folios in batches of up to
> MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> keeps local interrupts off for up to about a millisecond, and CPUs
> contending for the same lru_lock spin with interrupts disabled for
> that long.
> 
> The caller already reschedules between batches, but a batch itself
> only ends after 4096 folios.  Stop it early when a resched is
> pending, or when the lock has waiters and the current hold has moved
> at least MIN_LRU_BATCH folios; the caller restarts where it left off.
> TIF_NEED_RESCHED can still be set with interrupts off: a remote
> resched_curr() sets it directly in the target's thread_info.  The
> minimum batch avoids lock bouncing under sustained contention, while
> a waiter now waits ~15us instead of ~1ms.
> 
> This follows lru_gen_look_around() in this file, security/keys/gc.c
> and jbd2_log_do_checkpoint(), and commit 6e9be217a3ce ("mm/mglru:
> use a smaller batch for reclaim").
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changlog:
> v2:
> Also yield on lock contention after a minimum batch (Kairui Song).
> 
>   mm/vmscan.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a1af9b92349..c1231925159f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5533,7 +5533,10 @@ static bool fill_evictable(struct lruvec *lruvec)
>   			success = lru_gen_add_folio(lruvec, folio, !active);
>   			VM_WARN_ON_ONCE(!success);
>   
> -			if (!--remaining)
> +			/* stop early to shorten the irq-off section */
> +			if (!--remaining || need_resched() ||
> +			    (MAX_LRU_BATCH - remaining >= MIN_LRU_BATCH &&
> +			     spin_is_contended(&lruvec->lru_lock)))
>   				return false;

IIUC, Kairui's point[1] is to just drop the 'MAX_LRU_BATCH - remaining 
 >= MIN_LRU_BATCH' condition, no?

if (!--remaining || need_resched() || spin_is_contended(&lruvec->lru_lock))

[1] 
https://lore.kernel.org/all/CAMgjq7CUMuNSdCXZ7_kDdo9+0BFvPNHuO=mq=ct_Q5YUyyckvQ@mail.gmail.com/

