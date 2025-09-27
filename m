Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FA8CAC5B9
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 08:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8E28E0002; Sat, 27 Sep 2025 04:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A128E0001; Sat, 27 Sep 2025 04:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570608E0002; Sat, 27 Sep 2025 04:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9D58E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:39:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 691C587C0D
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 08:39:45 +0000 (UTC)
X-FDA: 83934381930.26.0095584
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9EE9120008
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 08:39:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=softfail (imf03.hostedemail.com: 148.251.105.195 is neither permitted nor denied by domain of MUsamaAnjum@gmail.com) smtp.mailfrom=MUsamaAnjum@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758962383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c5s8x0GYSnUxucbbyo+te/YNnYHBCr00xLGa1nguQKg=;
	b=REzhHw4rgIQf1KfCsRsiu0ZEs7y9uI93vggwn5MLQ8HNYc3HUBnWgzh1o+9zNsxvCNYEOf
	AYmS9K0/DnrlSHeqxKmzbQA4Q9yYYV+lRgvhT8/BtFl+w/o2wagRi7vrfpiV0e64J/vnIv
	1n6USY18NgpzJjGhOqZym0d4xPYliqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758962383; a=rsa-sha256;
	cv=none;
	b=Xt5b2/39+laR9+m8oObsx4cAHAKypTn55/yjRYSQQjBRFlJc80bE7L0PT0p+mRMjWaOQAr
	e381lKQA7yV2T2bI5Q99fTBZFB/uNgNFUJjHkImEv38/KcjNUn5vmxvcb3BF0Mz60c94TX
	Kg9L/H1Ed/2j0N90WkcRBv8XfmNFg/U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=softfail (imf03.hostedemail.com: 148.251.105.195 is neither permitted nor denied by domain of MUsamaAnjum@gmail.com) smtp.mailfrom=MUsamaAnjum@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
Received: from [192.168.100.175] (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 68F4917E00B0;
	Sat, 27 Sep 2025 10:39:37 +0200 (CEST)
Message-ID: <f82d2bac-9e8d-4baa-af50-a4f6ed3e0c13@gmail.com>
Date: Sat, 27 Sep 2025 13:39:36 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 1/2] mm/ksm: don't call mm_slot_entry() when the slot
 is NULL
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-2-richard.weiyang@gmail.com>
Content-Language: en-US
From: Muhammad Usama Anjum <MUsamaAnjum@gmail.com>
In-Reply-To: <20250927004539.19308-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9EE9120008
X-Stat-Signature: r5yowwcpd9p3rxq7zdho7b1q7syur8pi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758962383-741377
X-HE-Meta: U2FsdGVkX1+rh/2uMDCMn4AXJaACxDjP0RcKLhSjtR8uJd+5+X0b2rsLO0Vc6Q7DUsN3ghtaNEIcHL7F/OKwuOvR21IAqJSwdmIV0lhQ8WhspZlYo/MAlIjhKXYYTMgdb6uIefG3++Q1R3e8FQTQ/yYn37NdbZx9J2P6WwQrN9D00gwWzM8X38rYt6xemaqTMku+7DPS8WaF1kXHJ85/7tMrKNhs/PTxl+7dw49i3YhtGfThnFuzVBMlqSB3kqpZqGZIjNjQIGjwYimqPjjStQgqPYs0aNdlun48NABMTd80B0Q8dD/zi0Q2YF38RHCYjRNEyjeYo8AG3rYlGhllWyT1sDmJ+hx58cbgs9iP3aDfZOER96OkSudCnhIF/yHim/qynaMANQ5nxqvopzWcsSNs+8WtM2JtLfZmdOqONIsNdQmb/G+PzKVC/c0RruJY9DmZIOl4rhJ8zhtJAmIZARqeG6Uk+DENrUYSNROXdgOgDuKDyu6zxIGRvLnZrH3uOV6mjnfOGD1rdxMLqa5NmDfZ4unrUFtMzIqmvIreWCTZtRz+fRbQZeItD4UB4YG6GYFqLhZUAuCMyLmn4WDfdMdb+hyog/ETDrCj+pgM2xQecN4dt5pwP7bwDH7Wq1ocmKyatLoklGqIA7sa6j126ZsOljz9E7IzIZ4l4Tmar0FiwoB9MSc+MqtEm+06b3m3BLUUjRTZR/cF5ZTBMaUnWx+0HWWZms9xDjTUkJSXbbJ38CooUws4yZmpBEul2/H7Hx+ADDk6riC/H2wUkIHbRfNfzi7A6/Kks0Tj0nNC54dwihpghkjIcy0EnadHQ+Qur/L2lkmrfoBMUPCb013E9+BtUfVsyx320oOyOGNtF7PUdDEALpD0D6iYMrcnUeP4J4alVi+GuR9kUvEOdsl+IrpBdry3w84PjZKxBUxcNg2dXF/0xG4+XYZ8LgsFWcwodETNKzzl1OpDWEPAqvF
 LqsePKgK
 2HtCwomcoLjFB0KcbdbsvY3KXzFaxUPj+gu7nAgnelpRxji8bg4AXXPC7XL8q/0k9vscdOu+zmVFRicjEv2lHbuYr4ymEGvQx8G5MVo+H71EKHL5JNa4P5ObUz4DtzkP+2826C8d886cQK8M5A19V2YnudXC8X3tVmdynfT8JY8O9Ky8q2NTTqQwpi08aG57S1Tr9bYTLmE9ExL/NbCB+N05GCiWstY3hUb7P33csQ27OepGou772o9KvmIkiAILv+JqROgvWlQ2cD+6IMbtmAbJN7aKH/EK4sYTwke1K8gYFZt87Ld73ozAAScl1wdsGXXbrsFaxInm7jsGGZIBBlz8E0sA4/3hsu3cCwPR++dtLfy5cpsXQVDyChr7Wfv16/8LfSniOF2+m9sqR6CSYI/WiO1d9gJ6u+r/V0v30RlPhylC+9K5SVyopYY+FvS25HxEyLbnho3CEGR4lWolzrya1hWlpliMeyyJL/J9unj6aQEyTYJb8MvvyeOYTX22ad98111ju92aqujAzxj9OYiYjugxICbIiCKvZCPdWbiCydYk4eMej39KaOf69E4nlcP/Ztf8ndbYeCkdeKf7HG9p+e/5PejtdYXN4hE7+J3S5beoPj7IBeX1Cjwh9OWZJXJeUkWRKiR1mJrU5DaSYqTy4IYcQ0Rchz5aVfpVYAW4elIyqs0h7zPm+cT2o9kR6MEh8djwhMcuQvtrjL9fbB11vL3i2d81qx8rgRlp9ho50Sgscj7SUT8eJwGr9Y3osrTcmi+TQjNd3rvY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/25 5:45 AM, Wei Yang wrote:
> When using mm_slot in ksm, there is code like:
> 
>      slot = mm_slot_lookup(mm_slots_hash, mm);
>      mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>      if (mm_slot && ..) {
>      }
> 
> The mm_slot_entry() won't return a valid value if slot is NULL generally.
> But currently it works since slot is the first element of struct
> ksm_mm_slot.
> 
> To reduce the ambiguity and make it robust, only call mm_slot_entry()
> when we have a valid slot.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

> 
> ---
> v3:
>   * adjust subject and changelog based on David's comment
>   * use invert style for coding suggested by Kiryl
>   * drop RB and Ack-by
> v2:
>   * fix uninitialized mm_slot
> ---
>  mm/ksm.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2dbe92e3dd52..7bc726b50b2f 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
>  
>  void __ksm_exit(struct mm_struct *mm)
>  {
> -	struct ksm_mm_slot *mm_slot;
> +	struct ksm_mm_slot *mm_slot = NULL;
>  	struct mm_slot *slot;
>  	int easy_to_free = 0;
>  
> @@ -2936,17 +2936,20 @@ void __ksm_exit(struct mm_struct *mm)
>  
>  	spin_lock(&ksm_mmlist_lock);
>  	slot = mm_slot_lookup(mm_slots_hash, mm);
> +	if (!slot)
> +		goto unlock;
>  	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
> -		if (!mm_slot->rmap_list) {
> -			hash_del(&slot->hash);
> -			list_del(&slot->mm_node);
> -			easy_to_free = 1;
> -		} else {
> -			list_move(&slot->mm_node,
> -				  &ksm_scan.mm_slot->slot.mm_node);
> -		}
> +	if (ksm_scan.mm_slot == mm_slot)
> +		goto unlock;
> +	if (!mm_slot->rmap_list) {
> +		hash_del(&slot->hash);
> +		list_del(&slot->mm_node);
> +		easy_to_free = 1;
> +	} else {
> +		list_move(&slot->mm_node,
> +			  &ksm_scan.mm_slot->slot.mm_node);
>  	}
> +unlock:
>  	spin_unlock(&ksm_mmlist_lock);
>  
>  	if (easy_to_free) {


