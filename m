Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235D3CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584EA6B0088; Mon, 11 May 2026 07:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5357B6B008A; Mon, 11 May 2026 07:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424626B0095; Mon, 11 May 2026 07:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F30A6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:16:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0009A05CD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:16:14 +0000 (UTC)
X-FDA: 84754885068.13.56C9AD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3C3918000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:16:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XxDLx8OQ;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778498173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nruSBVin2AnJ4xuEZsU7eASbiUQRmQz7coGwKMFwyGU=;
	b=Yo74hmZwvIMRldvfGU2OLB669oGGFoyf9YIVm9AxyMhD/VnCaYTYfIZVlbIzdpIk+OYshB
	JCT0lCspKG50ueJNe2W3Ri3LLDt6RQF+H/25Xa5yfxMX1qqxKDfnH2RXcFB3y8WOVcQXIm
	tvYVMpaqi249NYRR9l+qouXJ+whxGF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778498173; a=rsa-sha256;
	cv=none;
	b=1+t1qEmnF2tnbEFkGqeiNdUq6KnP6U3MENWQXGw9pg5Uwnougb5C5hRBFA0nLLmd+f6ynQ
	uWmY+iFv96hrXbTSJKfdYOlHeUkxZdrGOluVvXEe+ND3WSuSzkQbCdcpjnJoqrHvMfbHzy
	puc8Ga6LLgqBTWghJtdXMSfXsbfT/+I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XxDLx8OQ;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94F7560120;
	Mon, 11 May 2026 11:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53BEC2BCB0;
	Mon, 11 May 2026 11:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778498172;
	bh=Cgr7dbdvhm+vZKERk5dxhhhYWa222txnv0pTlKfbbPA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XxDLx8OQlTJzTWhzEJVMPQxzWbFEUDSCJSCegy80OPVoDTShXI2Tdm4lfz33ZL4PS
	 54OVbyNThxvluqIIA2UTAXbzddMOUCH20W5rJiX6TPY7tNr/+r3uBTk12Dp6STSbQ/
	 u4jk+TQanegSXftX5NC9CQary5YfBScG3s1SxsOyT475F4Wr1lWNik0F+ihmDe1Uaz
	 lDpdL6DKACihz3aVjsR9LGkpGy3KUxYsqG2M4/Yz5JSnokvXMst9UVLl8a2USUBon7
	 sTvOeve5KCd2HBslzPxND+MbXaIwXB9+4qnspcwDN96IMiZP9ie8EAi0qJoR/knnq9
	 FJHkv5gIEzJkg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  sourabhjain@linux.ibm.com,
  jbouron@amazon.com,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  bhe@redhat.com,  linux-kernel@vger.kernel.org,  dan.carpenter@linaro.org,
  rafael.j.wysocki@intel.com,  piliu@redhat.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  graf@amazon.com,
  changyuanl@google.com,  mario.limonciello@amd.com
Subject: Re: [PATCH v2 1/3] kho: skip KHO data for context-preserving kexec
In-Reply-To: <agGxkHPx7W7P5AUS@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 13:38:08 +0300")
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
	<20260506182039.2623553-6-pasha.tatashin@soleen.com>
	<agGxkHPx7W7P5AUS@kernel.org>
Date: Mon, 11 May 2026 13:16:08 +0200
Message-ID: <2vxzik8uci2v.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C3918000A
X-Rspam-User: 
X-Stat-Signature: 9b8de4e9nz1uwnsmy497dm6dbygd4r75
X-HE-Tag: 1778498173-520298
X-HE-Meta: U2FsdGVkX1+hb14p7tPdGqLpHj9ynywwT5XVlpRL2P1lTHV4rUn86191JLNUEfT9Xx2dM8YFV2dojy4mVLuttB1EdiYt5cGnyTBExNbD/28OqC9or77plHMzTp1zkTbqGUCGwWyM+YRMJL7wkE+QyPuDfjvxUWWpPLC77BkP3FaE8awMiJYom2KA7nDZbCF8Y5rX03WtBPKwIsha7T+H+B/m9W3Im6/KJloIYCuBMWAgjMMmphGy4x3CUY2oTxAxArgKEw1wUyEk73/ejYb/FUnaxrnpwstYuitAmWK5/lX3XO2PuaUStwZU7IYpbWtQx3mp/cI1111D6MS8xNt/YLiI4lqbpsD30IWcWGWUrzdwzkAVP8HGhpQ4vlAZYUwWdECtVUIbH6yiPe4Z8rCRMFAJMUKq4AEIXr7OuMI9TlfNJsHeCsMat+d3K2NDi7lR7WjB4NZc8c6k7jOL1jc7lia/ruNC4GDSfaKohfzU5e9Y6OEu5jFCjbs9wIsqEqjW0CDABx+CpnNmZQCjmi4JDWnGHw8JQdKWQm8sca0NCI9H9th/duZwYdYHcwYWTXNxUYcZUS2L8Nw5ZLuNaYxV2GgYLE4+03yuxDjG9+fXkvdcF2UNs0tqK8eKz2agsZSZP0mACquTyuPly4CyVR/vgm+6v3Ayl0GrolAHNoogI9Kn5wCsWsUrFkSbMKSgncwfjoE4GbJ+AIjALYjSwAhQQtyuqXRRBeqRt7rEniy1rzDdAgrDtqt8CL2MbqsmHdp0kfSdQKp64+/bkVc7b81BwWnXeE+yQ55Eo1/6CU4V0LG35Vcq4r4zNd83OF3yCtjcoTM7MJFMbL0mWaER0m8Cy1oMlDFeSq7tyTui8mQH6AVNWMVrk1fGBo3mvDp3pn7hcqupxRWfKiYXhAr50KMyR9Nfch9ljriZJ+tB2oXBRhLff5zeI+3NKHqvt7D6q5S/vkp2140ukkXq84ycymx
 iOdc5QBm
 m9AbW++Hpogw8X32QGIb8IDylukHtRtZ4u8yu9o11tqiAPFN/VMjYP42YIS0wy9WC9jXDsnxcpOnseGMpQe/nqSrU7OScCb1zZ2zCDYH1bLGS3738k6dct7YDQAunBWmNvkh6G+9ez+ZuSQKzbRF48oI8SGuTsiEwu6QPy7TEOO5qbbNMmMaNPmd8eFjGMVaikFZ41PvwN+CbkhA084Ihmf7SGKPV2V38GOCB9oslwVitmmStYsLnQZSAb0lurgoUft6FAhJXq1ShcfxR76C3vER6GmtTNQdv5yla
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, May 06, 2026 at 02:20:41PM -0400, Pasha Tatashin wrote:
>> A preserve_context kexec returns to the current kernel, which means the
>> 2nd kernel does not use KHO data (and their memory spaces don't
>> overlap). Passing KHO data to the 2nd kernel via setup_data or
>> devicetree is unnecessary.
>> 
>> Add a check in kho_fill_kimage() and return early if preserve_context is
>> set, to avoid passing KHO state during context-preserving kexecs.
>> 
>> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index 4fde8325c49f..2eec2a169c83 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -1702,7 +1702,8 @@ int kho_fill_kimage(struct kimage *image)
>>  	int err = 0;
>>  	struct kexec_buf scratch;
>>  
>> -	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
>> +	if (!kho_enable || image->type == KEXEC_TYPE_CRASH ||
>> +	    image->preserve_context)
>>  		return 0;
>
> Sashiko says it's unnecessary:
>
> https://sashiko.dev/#/patchset/20260506182039.2623553-5-pasha.tatashin@soleen.com
>
> I tend to agree :)

Hmm, good point. I take back my suggestion then.

-- 
Regards,
Pratyush Yadav

