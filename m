Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D1260A2604
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DIrrzKib
Received: by kanga.kvack.org (Postfix)
	id 4757F6B05B1; Tue, 10 Nov 2026 12:44:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C1C6B05B6; Tue, 10 Nov 2026 12:44:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389166B05B7; Tue, 10 Nov 2026 12:44:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3856B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:44:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C2AFA8648
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:44:16 +0000 (UTC)
X-FDA: 85419933312.13.991C08C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EF86D140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:44:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DIrrzKib;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794332655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fulrg35l8yGwvpvq8cPY9YnUHn/OJvxhodbRy0q5+gI=;
	b=nB1xqCgWfPNGT1BvsAXDoMcj2XcBN0oQkIMQbmwFQDaF5uHHFADtHg6lU1ipFE0UKg795J
	RMMctPMvWEp4WvT/8k5w1aiP/XDmqv04tIGGvaargmG5h0m5Bnivtx56sotuyv/M/kyVFH
	yruEcVRwIvnYJ1gjFLHIfJZ4o7b15+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794332655;
	b=xgaRk+retmidhGsOWkVLsdl3laptpXMv+9rW42LFI1qNq3FfxW11+yhw+3KEY2/TO4SOE1
	Jzg1XDxnjY8KkvKYXfUGM0lPnSHoDgKzJEf9V6lOMnjT7mKCqWDNAUSCTz1vBNK+g5Exnz
	1biCqTE9ucNY1vSxRTskzTRje0UBPDE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DIrrzKib;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26AF543802;
	Tue, 10 Nov 2026 17:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B35D1F0089F;
	Tue, 10 Nov 2026 17:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794332654;
	bh=Fulrg35l8yGwvpvq8cPY9YnUHn/OJvxhodbRy0q5+gI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=DIrrzKibIe7LMcyHZ/CBt/f3kkB050KIX7QvR3SdZ/cydQJymBTzfBKZobEaAU9FS
	 AQPpwd69AgUgqddeKluymH1MgZworh5C2kzPXb6ipLMj/S8C8n11LY31oO8mmXtFk8
	 mh9nvu5cYFu2ZpOei+19puwSA8Lg7RWpYU/MqCIGxMwgs/XYzlxP5SYfd5ULfBsH0p
	 ctMi4gIX0c6ZTJPwKz/6fT4a9RnBFgdnOz0HtRmxlhqxOJwyPgWMmUf9I+6B4RF2o5
	 7R/d3E4EMW1XJeNCFKrx0V8ozF9R+YgZkiLrad7/FCRWMAbMLWn8ioq+EhBII0BH5n
	 oZ5+J1fIzQxHA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  Samiullah Khawaja
 <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/memfd_luo: keep memfd frozen until finish
In-Reply-To: <179373810485.663454.3013535045194073890.b4-review@b4> (Pasha
	Tatashin's message of "Tue, 03 Nov 2026 15:35:04 -0500")
References: <20261103181916.2462825-1-pratyush@kernel.org>
	<20261103181916.2462825-3-pratyush@kernel.org>
	<179373810485.663454.3013535045194073890.b4-review@b4>
Date: Tue, 10 Nov 2026 18:44:11 +0100
Message-ID: <2vxzo6bwh990.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: egm5mirgi46cg9b9zhuop4ncsad35t9x
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF86D140009
X-HE-Tag: 1794332654-712295
X-HE-Meta: U2FsdGVkX1/LWiU7RsLKcQ/tXnRyfCQs6ZEYd/Iace5e+Krhrnx6AUvh1UhnGsp6MatsRNMrn2ha0Lf4pPFjLS75npv/BCRQiDJ8J4thBf2D2ygw+y6rvyHfDXaMjTvrZCv97WGPQq2E7TLrXMIldKUcbrAgHZbB5dsIUPW0LgYGCNZcI9+3Pg1J3IJde8C4026Py+SF4lp+RT9L01J3r5reIo1BjfhufPwpUBvC2Tzxy/u5uqf/ik2KGEpSGGt/YaSjGzeGR8YU054LYVGq7dj1aqL4xwmPmrozMRm0xc305d28h7dDAMNgLQ5TqlCT4vXseuztEzFUC7d0/jtH5pGH8uJoppYPZ1l6Y0GHXyAoLpWOaPsUFg5csosaR095UGUYT9LBITA+flj1HGeqaEX1676FqfQ7AoD50MJ2/Fp4FPXe2be+OgY2NM4Y8StX/MJPeC7LjjrM2euUFhSgX5yA/0I5eLCsU1uAtCNLGP54rb62IXo6yC1KjEc6jopYrlO712V+BVwwOAENdHYnNmSZG9L88TQDZJz8v2dW2uMWxmtb3DBcwRrmqgFGwCal4y5FFwkFSIpslkEuzSFntJdX70wa9s06pTAoOS98/DabRaj4DZwKy5yzvJX9SFlFHE5/a4/V3dvQj0r6rqpnL1QGkyGYsZIZ+X543UZoug8SjCkaL3qL7oW7vWxVJAuhfr1itjIGELzEp4JyKGUssGCj8M+w0APYsFAplZPrQp3EThKKCiaX5n96rfRiPXl6D72QA8h7gg+z006y6E5n08MW5cFzKkhOhoxJx/j/dxErTrApe2Vc/SU4CsO7HmLMH3CM1BBFkuQ8xSl8GoWNcgfG88s0FY8jU9FuvHrqk5MzShLYfPVkGSY2in8WBIzi0bv5kW79Djylpjqf4HTg2xi+GS6LAt01vLReR5CNHMKB3wIlckOX7YBAahXkjayrHE0I9KWCkmGh4m1rCub
 f2AQjmrB
 j0hwHrbYikk5tohVt5wE71f3XPwDlEub4Vtw4KoYRGcrZxGzRsauEKDr9e6Ut0CKQcBSzXMEECDSOzlNuZktJLD/wRU2i85rdq3tQOhHMePlkb+/WkZtfPyJKwceEFPjadtE1T7jS7yh902dwqeVmM1kq7UrFa/0qVMD+LcJW7NHpA2Eb+nJ7iwkyJOTlAJ0Lj8VWw5JvXBABtA3MJV5MvYei16fmHQJjFqQMxy5MJ1b2W8/6un5X1VMtBavzpl9uNQRaLLzJqc7kmcFyadgAaz8QalYY5EwxPhlEuUCbqO3e0NGqPjqz41bc8rIuvN5RQUl0iiMleQ4fHxTsxH3I6XnHO/i1MtrmaYeUVslGiw80S1WbLO3IsfeaUqqCj88s64ck4ugImxi0xO2dE5xt0kZC6YE8RqwulPI3/W1bN+bWvvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, Pasha Tatashin wrote:

>> After a memfd is retrieved, it immediately goes back into "normal"
>> operation. The file comes back unfrozen, and its pages can migrate, it
>> can be truncated, and so on. If the memfd is depended on by something,
>> like iommufd, that can open a window for folios to move around before
>> the consumer can re-establish its references.
>> 
>> Finish is the conceptual point when a retrieved file can start to behave
>> as "normal". So take an extra reference on the folios and freeze the
>> memfd on retrieve until finish.
>> 
>> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> Link: https://patch.msgid.link/20261103181916.2462825-3-pratyush@kernel.org
>>
>> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> index 6b68220275eb..5abb9c0956af 100644
>> --- a/mm/memfd_luo.c
>> +++ b/mm/memfd_luo.c
>> @@ -55,6 +55,14 @@
>>   *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
>>   *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
>>   *
>> + * Restrictions
>> + * ============
>> + *
>> + * While a memfd is preserved, and after it is retrieved until the session is
>> + * finished, its size can't be changed and holes can't be punched in it.
>> + * Operations that would do so (``ftruncate()``, ``fallocate()``, writes past
>> + * the end of the file) fail.
>> + *
>>   * Non-Preserved Properties
>>   * ========================
>>   *
>> @@ -383,33 +391,56 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
>>  	}
>>  }
>>  
>> +/* Drop the references retrieve() holds on the folios added to the file. */
>> +static void
>> +memfd_luo_put_retrieved_folios(const struct memfd_luo_folio_ser *folios_ser,
>> +			       u64 nr_folios)
>> +{
>> +	for (u64 i = 0; i < nr_folios; i++) {
>> +		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
>> +
>> +		if (pfolio->pfn)
>> +			folio_put(pfn_folio(pfolio->pfn));
>> +	}
>> +}
>> +
>>  static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>>  {
>>  	struct memfd_luo_folio_ser *folios_ser;
>>  	struct memfd_luo_ser *ser;
>>  
>> -	/*
>> -	 * If retrieve was successful, nothing to do. If it failed, retrieve()
>> -	 * already cleaned up everything it could. So nothing to do there
>> -	 * either. Only need to clean up when retrieve was not called.
>> -	 */
>> -	if (args->retrieve_status)
>> +	/* If retrieve failed, it already cleaned up everything it could. */
>> +	if (args->retrieve_status < 0)
>>  		return;
>>  
>>  	ser = phys_to_virt(args->serialized_data);
>>  	if (!ser)
>>  		return;
>>  
>> -	if (ser->nr_folios) {
>> -		folios_ser = kho_restore_vmalloc(&ser->folios);
>> -		if (!folios_ser)
>> -			goto out;
>> +	if (args->retrieve_status > 0) {
>> +		/*
>> +		 * Retrieve was successful, release the folios and unfreeze the
>> +		 * file so it can be used normally.
>> +		 */
>> +		struct inode *inode = file_inode(args->file);
>> +
>> +		folios_ser = args->private_data;
>> +
>> +		inode_lock(inode);
>> +		memfd_luo_put_retrieved_folios(folios_ser, ser->nr_folios);
>> +		shmem_freeze(inode, false);
>> +		inode_unlock(inode);
>>  
>> -		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
>>  		vfree(folios_ser);
>> +	} else if (args->retrieve_status == 0 && ser->nr_folios) {
>> +		/* Retrieve was not called, discard the preserved folios. */
>> +		folios_ser = kho_restore_vmalloc(&ser->folios);
>> +		if (folios_ser) {
>> +			memfd_luo_discard_folios(folios_ser, ser->nr_folios);
>> +			vfree(folios_ser);
>> +		}
>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 
>
> Side note (pre-existing, not an issue with this patch):
>
> Initially, I wondered whether we should disallow auto-finishing an 
> unretrieved memfd, in case a preserved device still had this memory 
> mapped for DMA. However, if we reach this point, can_finish() has 
> already passed for every other FD in this session, which means any 
> possibly dependent FDs (e.g. iommufd/vfio) have already determined that 
> this FD was not needed to be retrieved for their states.

I think that is still a problem in a different path.
memfd_luo_retrieve_folios() frees all the folios on error. I think it
should hold them until finish(), which would give IOMMU or other
dependents a chance to block the finish.

But yeah, that would be a separate patch.

-- 
Regards,
Pratyush Yadav

