Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A762ECD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188076B0005; Mon, 11 May 2026 12:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F626B00AE; Mon, 11 May 2026 12:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074E66B00B0; Mon, 11 May 2026 12:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F01CA6B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:28:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B08491601FF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:28:27 +0000 (UTC)
X-FDA: 84755671854.10.768BD2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C9C9C4000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:28:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o7FW2XxX;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISXCqu7Dapk2X/iDVs449kzp7kPa/3NYbJqZeg9B4PI=;
	b=BT417j7hp02RX4sPgWC7p9TNY7rTjceuKKzncowoVpVbb7pBfF5TaqpDmCK9M6eaJxx/Da
	5R8JE0pEKmVgbb9nzh4m+v2HC300CD+Cf+PBHND2DoFq5Bs2FyI1mji/eeP0NiKL6TqxgM
	H0QF0oVHAda1sLUG4mYJaGxsKkUdJsY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o7FW2XxX;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516906; a=rsa-sha256;
	cv=none;
	b=GoLNAx7zRS5IhCkVNjh5O1CAXLQIZc3zE58g8xV/Rk6hmpEemINIZqMe9FwakAnBnhYbeM
	UmtZjtAgUf29/UAOpyGlDcay0Gc62zXsktVDWSCiJOCiZKu1hWhGzASFRnSbkGbdiGQohK
	qm1QXClXEEtOW1gmHvx1AYsyRfWai9k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABD3D439CD;
	Mon, 11 May 2026 16:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D586C2BCB0;
	Mon, 11 May 2026 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516904;
	bh=u5JXHEfkMPoZSqSacIx/XE1J9UzNOfNs7ZcjLVjNd/w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=o7FW2XxXRBGQ8nfAo9dFMeDzenLwFr5eECqJwnbVmgMyiw5p8jdDRLdXgOrXzTjJj
	 7x6AbZ9eMVptgkc4wbEdnNy/O+Iv3N7nTo8ftFOhKFmXVdl95Wbn3dETbq4sPA5LIx
	 kPTVdQK0EgSHXiqD1o2sgdnc7GhQna80NaZglPCQ+hvuHHKx9E101fHPbvR3a2KzmB
	 Ju6MC6ubbO+lT+62igLLYQ8cEYJXv+G1AOlo4Y4Y5Jn1PgtUBfotQPCc00nKWfaYty
	 0KV46X6QjdM1qQaKlR7TE13d3puNKJkj/veUh76++YNF/iHFIRlNStUuARkvttHjwR
	 imhnJT0gJCRdA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] kho: store incoming radix tree in kho_in
In-Reply-To: <agHA2imH5hdMSlId@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 14:43:22 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-3-pratyush@kernel.org>
	<agHA2imH5hdMSlId@kernel.org>
Date: Mon, 11 May 2026 18:28:21 +0200
Message-ID: <2vxz4ikddi6y.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9C9C4000D
X-Rspam-User: 
X-Stat-Signature: oc19unu7n9kaun9e4cumt7h53t3rp5f6
X-HE-Tag: 1778516905-448598
X-HE-Meta: U2FsdGVkX1/Bca3/OUBeL3lnyT7/bG25BNWer5gn8qhjCBBmKdw8YoxMUQ5Xg9plsUgPa2gg1NVT4tvyu7k3jGhFqq2TlFyVIFoLfvrY9VlzSapULJx580i4a/vOGZ3x5u/tSfnMitHMKLCqZMAvkXItedlTSdVXmFxr2cpugNP6pgmoete+lTTQuT66i4ZtnCRQ/BhT/0XID1vRkWBMbcHF1yGCXu59MvrzQqZj4ifS2F5K0PDMO1HUOcI7DXStA2LaXixIRdLyM+vhAd/M1rJNvHE8UBBTzlSDxFXAWVMs2p43n7+GCoRqNNcyAjZAITP1klZMO244fRbR7mGtrdJxvIkjgDZn3wfPv9R8PvG57JqgcAALQ0f8fCipJxdrmDLjzJL9Hmwrz8yBcT4Sk3FKqraHbJwj3zMG5yu3KUKf+U7oEShwYjn2qQIUJMSWseyD93lJnpyk/0laqkDTmXU1KGmsuOn5bCI3x/VKHDW2ghEVJiNqbpxDjqC7AXAwU3556+ldZx+jbRnfGHP+qa6jO3G8/LIqpGVlBNC8uyKdOGAlXM/6+Arr1VETDqn7qEwKrLSIeDyWKj8jY9SlprkjcWld+4dEFNFSrKkVVzSaS/mF7Lg2dWE1MBmNTruOyS1v2bGn1Ll9fvF63+z0LqY4jYsCJh6kE3QvzTRHsCUqbOU1lGfm17PeMlSmzQsabryYwcMJg+zE3EEXj6XT+8k1cW59rQPH/RRePyKxlJgEZSlu3+LSEY/i8oXBc2InW6JvNRttlkAPxTfRwBEhGSzz++k0TnCvz7RcS7/uDQ4q4e0Q91y+HAqaSmxzZGcSoRxUtZUSwSd+kdJ+DJrw7v+SHEGQqr5AZNd+dn1Lg042NvqZkghQs1q2ayTy5dhtOiNoAdKY4XgZHAD7z8Ufl1Cfw/aGDp0hcswT0Ybwl6hWp+NAK4L63f6uJTerLdYm5gSKEf/CXcc8CTwGXf+
 bwAnV2lR
 f0ovfbcgjuhPykjAWWqGltCa2Izhga08S7GurmcI03Dq2d1HpNJ9ysDUX+pFHahCaECDM+LAGjOsiqg7nuz9g6BKWKk4jpgxDKOr5KCuc4LCjSrW81YiSN6MlQZrz4oDMrz+4jlYZHeGpOc9x7X7fZUn/glgF+V+pC/BYIuH+lBvfiXL4zgcOWnF+khBMJSAm9El7LgTDZwDK++D14aUl971UscLD4uv0t7zRWS++VFQHDRbyhM3Seq87tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, Apr 29, 2026 at 03:39:04PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> This allows other functions to also use the radix tree. While at it,
>> also use kho_get_mem_map_phys() instead of duplicating the code to get
>> the radix tree root from the FDT.
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 27 ++++++++-------------------
>>  1 file changed, 8 insertions(+), 19 deletions(-)
>> 
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index ba568d34c5b4..5758dc6fab5d 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -1294,6 +1294,7 @@ struct kho_in {
>>  	char previous_release[__NEW_UTS_LEN + 1];
>>  	u32 kexec_count;
>>  	struct kho_debugfs dbg;
>> +	struct kho_radix_tree radix_tree;
>>  };
>>  
>>  static struct kho_in kho_in = {
>> @@ -1373,24 +1374,10 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
>>  
>>  static int __init kho_mem_retrieve(const void *fdt)
>>  {
>> -	struct kho_radix_tree tree;
>> -	const phys_addr_t *mem;
>> -	int len;
>> -
>> -	/* Retrieve the KHO radix tree from passed-in FDT. */
>> -	mem = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
>> -
>> -	if (!mem || len != sizeof(*mem)) {
>> -		pr_err("failed to get preserved KHO memory tree\n");
>> -		return -ENOENT;
>> -	}
>> -
>> -	if (!*mem)
>> -		return -EINVAL;
>> -
>> -	tree.root = phys_to_virt(*mem);
>> -	mutex_init(&tree.lock);
>> -	return kho_radix_walk_tree(&tree, kho_preserved_memory_reserve);
>> +	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
>
> Do we really want to remove an explicit check for 0 and get a WARN() in
> kho_radix_walk_tree()?

If mem_map_phys is 0 then kho_populate() never sets kho_in.scratch_phys
and thus kho_mem_retrieve() never gets called. So here it will never be
0, and if it is, a WARN() is certainly warranted.

Perhaps I should add a comment since this isn't so obvious?

>
>> +	mutex_init(&kho_in.radix_tree.lock);
>> +	return kho_radix_walk_tree(&kho_in.radix_tree,
>> +				   kho_preserved_memory_reserve);
>>  }
>>  
>>  static __init int kho_out_fdt_setup(void)
>> @@ -1597,8 +1584,10 @@ void __init kho_memory_init(void)
>>  	if (kho_in.scratch_phys) {
>>  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
>>  
>> -		if (kho_mem_retrieve(kho_get_fdt()))
>> +		if (kho_mem_retrieve(kho_get_fdt())) {
>>  			kho_in.fdt_phys = 0;
>> +			kho_in.radix_tree.root = NULL;
>
> I'd make kho_mem_retrieve() void and put these there.

Sure, will do.

>
>> +		}
>>  	} else {
>>  		kho_reserve_scratch();
>>  	}
>> -- 
>> 2.54.0.545.g6539524ca2-goog
>> 

-- 
Regards,
Pratyush Yadav

