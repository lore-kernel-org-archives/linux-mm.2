Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB50C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4084E6B008A; Tue, 21 Jul 2026 03:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9756B008C; Tue, 21 Jul 2026 03:41:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B646B0092; Tue, 21 Jul 2026 03:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA12F6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:41:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCF58A0446
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:41:42 +0000 (UTC)
X-FDA: 85011989244.28.1A662CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D806C0006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:41:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OeQHhVhP;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784619701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RDa7GxGPcZxw1iR56r9UobJy+ITg20eg0gqvz46Dbg=;
	b=hoHq2vrVVSnbBpY78ue5WoGWO6gDI8lvD+Q2+jYPZityPjqJjc3+9OiC2N+bHcE++mLa0f
	4Ikx2RmQm59RWARMIMjneC4NuWLamXlwaUfJRURITTjFVusWDYrSRmFttxNFVcbV6gub4V
	7CIseIJWVVqYcq/DyjtOogQxLlvq1dw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OeQHhVhP;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784619701;
	b=xK1DIk+QrIvm7ViKh08qHmRIXlDKQkvM/M6hUfihjhlg5sPriedY9Z3Uj41Sjzl6oyY5Id
	iVY6pEIZm/tkOFw0SZCWaTIQ4qdXH3Z1iEGNb6eV4Ua7Uda04cPffkEvtLVXjEr9UcFWlD
	qZeAFFpqrkwsRL2COKgr+tKw9vuyVhE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 802AE60A95;
	Tue, 21 Jul 2026 07:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207C21F000E9;
	Tue, 21 Jul 2026 07:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784619700;
	bh=6RDa7GxGPcZxw1iR56r9UobJy+ITg20eg0gqvz46Dbg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=OeQHhVhPSAjaAr6m2sK2/xPUH3iA6gDakIWCLn6DfD8uPGUuAAHHQES9SBQnCmgW9
	 kAMbhpLa+nJlipJ84DQQREh7ENV8cz02VRQOnOUWrNdaBkHOBxXtENoqS8Iw7H9YOC
	 5atWYHmSLpCeFKKEpDbLPo6HVvAlzS2I7W9Rp6kFwe2mF1VgDWJKZenpvYVeSxZLq0
	 syaofVJHX1MQpfRQvaIuuRS1HiXTKvIED9Jh3oFQ7ZKaDZoT2/MskaScLflm5UegVt
	 nFX4UmAUw3R2VaJ7xEqgwtT6OyNwFJxuaMeG2T3XrWuSG1smdD83UPkKiD/oBoqadn
	 PC0fhjjQuY/8Q==
Message-ID: <234c56b7-4036-4d03-8d8d-6298d16c3a77@kernel.org>
Date: Tue, 21 Jul 2026 09:41:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
 <01ea11f8-65b4-4941-adf7-423c3f000292@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <01ea11f8-65b4-4941-adf7-423c3f000292@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D806C0006
X-Rspam-User: 
X-Stat-Signature: 7fdfr51bs6rrdk7pfu6wtg6jik459txg
X-Rspamd-Server: rspam04
X-HE-Tag: 1784619700-856607
X-HE-Meta: U2FsdGVkX18e+wo1mYTBb48bK6qV/D3J0Q463lyQLe2XSdLymvrvMivDYYQfYHW+wisvQLVrrgxE9w84ysoeasnHXIsrccE1yApCifKyxKBCynEBMLqxaE8w87aGBtMeR3Gz++YgARLmgaWDW0PVinQJqR5+SALw5Yu0iHyXFxas+LTkmrDa/mJ6kgsRk2P0xmV1/5yNSeD9txeVEb3dFwtJuYrcDB7Bmvv47DndyjsfKuATd7p9b2+pCV7oTDQ3Rkkz8ljY9QyyvndBpeE1w4H9Y0iMvr/TxIakrAHhRwys9A05XlOtz2tQkDX9qXUUIZ0bu3xY6Aewi7Kne6hzbOdFxKofOM2SiAeccNDNZK1HGZjG65O1bzQWvTFMRW/sk0Imm/WxyYGYHTYOixHBx6wmdUe+qRYg5TlVQVUZEnACG9lglntvV80/IwH2Ug1o5fJiHSxA+oakWWgsONR41Ju2+Mzwdk3naYhygS5mXPJew19BHzNmGfHTDr9xlPtieK50uBZtMyYM10425fWAMd8QMGe0C+hN3eHDX7LAM1f4IIqWG3yQEeczf9FiNa1bubErrFopYr6UM6nuodSg1W1xGlLMpJNEaePNewYEPR2wKbb+7PXufeLN7KYm96a+kxp07iFZuPClWwMs77webAbN8dH2TIwWKTmmHleMFVsCtjK8q34KKivO2QQjrw6p5hBC7e59N4y/AqbnfYc+3vhNNevNwhrOdsxgC03QFbJEWfupSRrg4iv7RFHto2jLILAIBAqJhWJws8vI3oqGsj4nRXyv/A/V+RZC6yg7M9xounRdmpvBPnLZkInuMC6sbQ8sljZDT/da0hMb5JXQYDf5huSwLWDjjD0laL3GbGuELpTVTiVxoeLMGuSvRXdbJO70t+nga1JHPXpZCCvdWo6xqU8DwJXUH9gUE39BZMBPhidqeII76kkEjBsxvjbMIWXFZ6/RshHK1Un/C4P
 MoIL1bir
 mRzcEfDKSJ5gSgsBoNaCkEE1XqdagMc7t3BEul3h8PqAgdQNiTVDmwpvQl+ayh8lIC/dpc6c1EngK608zD0QRWaMq85Ntn6tO5tq+iQntwPj4DNkQJCtz0O6JKTqFdOfAF/LGFw4i64h94u61Zs47nU0FGczLYQB7r+JnPe6Aa4CZ0co0P9Pat1wWJxLA4D3Yvk89v85rrhK8aToZ7GOCeEYjMBSypkVBNti6diXVqtR75KoZgZCof/RzzP7YHsU5R7B74q8XDob42I55wZ2/YVaQkOEQvfmBDXQ6UkNwuaRj1FLUsgFfLRo8kkxBrRBikcGe9B62LcMILbcjg3ezgL8WB0GZvsW/+mvP98NPrfhxo1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 09:34, Vlastimil Babka (SUSE) wrote:
> On 7/21/26 02:45, hu.shengming@zte.com.cn wrote:
>> From: Shengming Hu <hu.shengming@zte.com.cn>
>> 
>> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
>> placing it in the barn. Without an explicit restriction, this refill may
>> draw objects from pfmemalloc slabs and consume emergency reserves.
>> 
>> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
>> non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
>> because this refill is a best-effort attempt and failure is acceptable.
>> If the refill fails, flush and free the sheaf instead.
>> 
>> Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocations")
> 
> Wonder if 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with
> sheaves") is a better match. Until that commit we just didn't care, and it
> seems like this is a case that commit missed?

Added to slab/for-next with changed Fixes: per above, but can adjust it
further if it was wrong. Thanks!

>> Cc: stable@vger.kernel.org
>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
>> ---
>> Changes in v3:
>> - Replace “normal memory” with the more precise “non-pfmemalloc slabs”,
>>   and add Fixes: and Cc: stable@vger.kernel.org, as suggested by Harry.
>> - Link to v2: https://lore.kernel.org/all/20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn/
>> 
>> Changes in v2:
>> - Add __GFP_NOWARN as suggested by Hao.
>> - Link to v1: https://lore.kernel.org/all/20260719113701797vZ3R8NxiqYt8dEfeUxtON@zte.com.cn/
>> 
>> ---
>>  mm/slub.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 53b4976d3831..357b7522c817 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>>  	 * simply flush and free it.
>>  	 */
>>  	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
>> -	    refill_sheaf(s, sheaf, gfp)) {
>> +	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
>>  		sheaf_flush_unused(s, sheaf);
>>  		free_empty_sheaf(s, sheaf);
>>  		return;
> 


