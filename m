Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B68CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 02:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6636C8E0006; Tue, 23 Sep 2025 22:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B848E0001; Tue, 23 Sep 2025 22:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578C78E0006; Tue, 23 Sep 2025 22:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47B348E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:20:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB6E4C0397
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:20:09 +0000 (UTC)
X-FDA: 83922538938.20.6EC6904
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf07.hostedemail.com (Postfix) with ESMTP id 264EE40005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:20:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S+P74MdS;
	spf=pass (imf07.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758680408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtYamX9PaOFosODiXhH4M2cLp1DMRUmAKSkQRg2/kMc=;
	b=76bKB6fhhwlGHTTn8ypmq6khjN7z/V57hHwDNCSqJVKDL5vB6OwZXrvjVAECmPfp4G+3bj
	ICZ5M0pSMC9BQr6QXFsZ7VYEY21BtsmByn5+47gSUr+uXNZj4cKDkHPVm5T+f4gzuHYP4B
	hNV629K8kY7SuqPHyrC49JD4lPOK87c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758680408; a=rsa-sha256;
	cv=none;
	b=gcWlmAurcPAwVWhMCfRoAv3FN9l9OA+2moSthvgvjRZ+ToFsUslV/OMpBjx8+B5ebKL9T0
	54L9eo2Q5mdHD4vqJt/5GZFdPV5sOAWtDLVmqpKsTAfqlukSheBLZXXkWLneiPOM+2QINi
	3JKTHAykLriX68VmTvZ6VuBUuEEd+tU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S+P74MdS;
	spf=pass (imf07.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <99731e65-9092-48c2-ae65-bb8d6247664f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758680403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MtYamX9PaOFosODiXhH4M2cLp1DMRUmAKSkQRg2/kMc=;
	b=S+P74MdSSb9L710oxw0CKA8sKcBY7sIMA3tqnfXdaJS4tiVRc2H+nFTq5mO5VkKu1CZ3b4
	yR4mwyvzvYzuq2Ya2oyae1tgTU4uo3OYFyY0mEzsnABvleRlPWCcrUsiFGDg75ZUn0SRME
	s6iFttbv5sPrQ5h+XEqjuk0UX7ZeSSM=
Date: Wed, 24 Sep 2025 10:19:53 +0800
MIME-Version: 1.0
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20250924004854.29889-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5awtq1mooikepa9bpd9qqdgfo9cfzqo3
X-Rspamd-Queue-Id: 264EE40005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758680405-508005
X-HE-Meta: U2FsdGVkX18G1bpSNyt7ICtxapIUzg4IcSyjIiR6J9Y1IENY3kOp8frTPlOMDTFd2Flk/OGlRT0twXG4sjwKZkO9PujYu3HAYG8m+rx11yCMXOlpJLT+pr2lTpZnL1oEEdfdhnGWROC8CHNW/Tl58tPnmcrHjyof8B4oODVFmxIsqjJTH1b2mBB9bNh2muQxY0f+BOrVFV5VYmF5OPjo/5rQ/GVduzjKgopC43fssKFi/yTwd3KiFXsK8dLu/8uWlR7SFi62vKTc+Bkd+xXqD57DcJAbaWPqh7aW1kW2Ahsim5Fekgv9vFOUlv5qLNpBw+RbnVXq3t5YeCwYN+KDskeLdl/59e3HM/dUH1lY/YxL2d2lMlNJJ2kKQi/ShlU80shnGjgmVMbfzfV9WrCAJhgFI8V1yJDCQvkz1lVWiS0gavnuu76+ydMO9f6wHbmwa4Fx36buXe9enp25mKohOJGxNzNSMHjOKQPAy+MjcopCl3dIJ8RTONA6rnYN4RoFKcdfiCwL0/tN3SaZv3Rl0D7DyXq5AfGMl3nmQvX2Q8im7uBTsjj18wNzqB9IDHbjcWWc/dzAKOdSAzED89blTqHaQFz0lp76wiwIIztQLKpHQ4cWpv4WDueZslPgXEuv66P8JOh9H8mzCW0TQaUwDg8s4BGTfPgGYwOs0vYhLETm2dJ0H7FiQQ+DWfPwU9H/NK8+/1abIMrF46EE1XD9y0fl0fpJriukIcI0lVjhvTorFSxyrUbAHnUfFryGqgKBHqXhaD2PEnqxuoiEuT86F0opIjGwvWQB97TIdSigPRpq/lP8rujHsi1CoYE/k0IIDkBtxEeSJ3YA+jqekMwl4+3MBcdO43uMHljchA9bhuEkXWS6Ct0CPWJrN7RmYG8EgZPL+cOyGe+Lh1CoxDzLzXMXfkRWqV4kYZBuhtsu8impBXE3IaQ6oXLY8Q5T7hGN3zRD6VLnR4j1C4+iMGI
 D25bCsup
 VQXfVGOnnQwY5wxI2N2W/fzOnnDyhl4p4n64xe3uSOO5DqJTlcgFSR0eJ7qgGLkFHQu7jgWGdVFzdf5pOXV5b27fxAzT1TH5IHPh64sZrOhsebA+J01NrqK2WtEQYFT40lpJPmwX41qY4hFzJTtLZHuJiQ5Ms0FRmDWhFZq5Mo14jE8aYPaSxuQeZFKWQgzZDlCZKeNpGc8+oWHeYW/Qm2XhzJnZn3pyKDJV3eVCrBlj5SDrwjJRG3jMFMAFUzvm3xYyBYUrZLvZQW7hwV72ENCjvAccrkspUd78/jTNPtSJgsFyv4FP1KhXhnxkFummHuf5xadIC5akn+YvJmf48h3d67Hyb1M/V1QuYbSftue70Dv6SFKUiLuIHkQ3nfP9x3TA93wkZkoH/ZhkTMtmgO7j3CfVTWKQvtqwSaBCTcxGz0Pn8w3Gm4O69BSmD36Shvyi5QD+fORh0TyJ9PK9pjwM4iiHsRnXdSt1Y0Xa5x8/KpVnVifXC6JQ9iPK1yyuxofPve8nvq+6HJZMJOFy9VDxgLwi/wSZES3hquGeao+V/QSKFc3RjtNMDIr5lGL5vZSQ+oUU7LgLRevF8Gp+KFdU8SKlwaI7PFpy9UW++8zEd3vfno13uMg44ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/24 08:48, Wei Yang wrote:
> Patch series "mm_slot: fix the usage of mm_slot_entry", v2.
> 
> When using mm_slot in ksm, there is code like:
> 
>       slot = mm_slot_lookup(mm_slots_hash, mm);
>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>       if (mm_slot && ..) {
>       }
> 
> The mm_slot_entry() won't return a valid value if slot is NULL generally.
> But currently it works since slot is the first element of struct
> ksm_mm_slot.
> 
> To reduce the ambiguity and make it robust, access mm_slot_entry() when
> slot is !NULL.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks.

> 
> ---
> v3:
>    * fix uninitialized mm_slot
> ---
>   mm/ksm.c | 22 ++++++++++++----------
>   1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2dbe92e3dd52..c00a21800067 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
>   
>   void __ksm_exit(struct mm_struct *mm)
>   {
> -	struct ksm_mm_slot *mm_slot;
> +	struct ksm_mm_slot *mm_slot = NULL;
>   	struct mm_slot *slot;
>   	int easy_to_free = 0;
>   
> @@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
>   
>   	spin_lock(&ksm_mmlist_lock);
>   	slot = mm_slot_lookup(mm_slots_hash, mm);
> -	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
> -		if (!mm_slot->rmap_list) {
> -			hash_del(&slot->hash);
> -			list_del(&slot->mm_node);
> -			easy_to_free = 1;
> -		} else {
> -			list_move(&slot->mm_node,
> -				  &ksm_scan.mm_slot->slot.mm_node);
> +	if (slot) {
> +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> +		if (ksm_scan.mm_slot != mm_slot) {
> +			if (!mm_slot->rmap_list) {
> +				hash_del(&slot->hash);
> +				list_del(&slot->mm_node);
> +				easy_to_free = 1;
> +			} else {
> +				list_move(&slot->mm_node,
> +					  &ksm_scan.mm_slot->slot.mm_node);
> +			}
>   		}
>   	}
>   	spin_unlock(&ksm_mmlist_lock);

