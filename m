Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A13E98FD2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090026B0005; Thu,  9 Apr 2026 05:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F5A6B0088; Thu,  9 Apr 2026 05:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7946B008A; Thu,  9 Apr 2026 05:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E2D7D6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:56:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E3D1140549
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:56:37 +0000 (UTC)
X-FDA: 84638562834.12.56911D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A562540008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:56:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWPzUry6;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775728595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgerVe2FKbJjP0qWK2fIuSO/aTpHMq8ArXdNealEqi0=;
	b=cXi9FBWUelwxtBGaM91/9xMX8uaOAXWRCWzbnmYznAZCQhGObgDYFnMzEIgFNV9mxPu8vU
	U7ENm5L15vd6ouRepXhXhv8ZLhQ/aGlRnAp4Y6XF944te77kJYOHC8YLYwaQayMwsbCn6q
	XprhK8STMSHA8rf/X66TRvosP6iQaJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775728595; a=rsa-sha256;
	cv=none;
	b=gSuCD1+mYuNRKzieol0Bj9iTktnP8UbSvf5GB7q/M1CqLM+/BnL1isiZ43MjNe+Opca/fI
	VCpcqrjcvMcMPAeFhwT2C6JXlnGeIMY9ocnpxvcc4CukB4fYSjLzwTdOulScZf3FGhAGP4
	lXFnjCoLaj5gi+bfTy6BekeSJIHkxNY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWPzUry6;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93C754434B;
	Thu,  9 Apr 2026 09:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46DAC4CEF7;
	Thu,  9 Apr 2026 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775728594;
	bh=wLiR1jmbGwhcGbTJEzKKbYyUIoLx7sO83hROGWXcB0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EWPzUry6dvaIBTs35SPrRGMlH0v437ArhurDjAwF9Tfeh+olQS/iG7smV3CFzG1v/
	 EOorHW7BDETnixYZbPIvqObBG0V+hIdrGJXwRca7FmuhpWTq7PA/nbNM791APw68VY
	 k/JyY5qaPgRoDU4Mi61P0ptK7Fe3R1QdxqhoP3aiewT4PK4L5dRqrgXO1Xec4O0w6E
	 qteJhYjcT/jUakHW0dYpBhoKkko+OBrMgheTRYyk96A0xrIPqnnQifLhhX1rkAibOt
	 wnBYkSikjVj9AUxTMCPNHwwOlb8AGkWN0nNNO1D6VvTIQDoYUTgf0+9ROneYCvFRiE
	 QSob1Q/X5Ga+g==
Message-ID: <63a3bd6f-c8cc-4e3c-a2b2-90163da066af@kernel.org>
Date: Thu, 9 Apr 2026 11:56:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn,
 michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
 <adTPQSb-qSSHviJN@lucifer> <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
 <addoN3ur7GtiKOFf@lucifer> <015c3268-9c95-4314-b28d-c5e33eb2fb86@kernel.org>
 <d659edad-863c-498b-b215-b9f98d15e0ce@kernel.org> <add2XbcdFpCaT5tK@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <add2XbcdFpCaT5tK@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: qbdkxh1p87atrekba3agi1b81ad3jcy5
X-Rspamd-Queue-Id: A562540008
X-Rspam-User: 
X-HE-Tag: 1775728595-634508
X-HE-Meta: U2FsdGVkX18CX1639m4cfNqFDt6HSuhfQwAVYdVrbq/nGVOPkGHZ1Vz/sVS2A+s2QVVCVKVVbzmNaLvXljxses8+zz4GPKc2MuI55oGJMO634JeecKWZ7YFFeZqFckptPNp/PXw4soljuLpWM3W522RTgnm5KQDB1k2DD6bFpoji2Pqe//H/LoEicC50qUgrJorWTfjq9is/OyxJwYdPorg3Ys5Ac8aki34QIWyzTKjyVNDirnZGCxA+6sePvN+UgMiGeQzdyqkfhEwC497aP5wkWQvUobtHGK5oeyf++xIs2e71DeNJ+tWS8ZfIUa0E1nuUo9eR/5BkNJXj5PFiTXnvb1qS9pO9XxyMkIeVy666Ti/d3TkBpwkh0tAGOa2W8eRlVxoC9xIGZWOuEya8E4Ik5/gLQfpU2KFWem/aIdVCCIKBfrpUYx2kY49Wz/9bp5CjW7nx++EwIBvxlfm1JhbNt7rhfay5dd5bUz644+ZWvDLXX3j6rPu+51nQIN8ZJVE0hbm8t9E9DeD2whskauKAfLFmVn9Z5yBJLH4/ia7Uww9I+RWabTnYDRqRl9SECXmYUWRYfVLAFruqL2kVYjalUkcZr+AjJ/F3Zoj5rp5SfJ3WTphO2FAxAWAZpEP15Lj/6SegFVF0ayOTmcz6NfHBGmA2jXZ9oxvI9yi72ksv+UdGwmRRPPE4twmRAq2BemLOoHohLIJPrAz8m+LuZ2KfYRMKDcngkNhu1ZLYOQSq5ncqTR33i3jCp0OaNBdAOey9e4DvbQcz6ci4wgvW+BDY5S8g1F3RZzpiqYdeQagTdTBUQ2da95DfhWg3tQ10pP5a7oSPIw1lAXvB08BD64igkfgnK6a7dSR3P1BXxBy9UHM8aVNwQ4kH7Ss5W2UWUvIDNyZz8en8oRn13cVD9mzuuJoEDvXiw2hqBDe2SFzku74Dw4sEbDDRMO5oZMOHP/8x3NGrjr2Egwrp+aa
 ZGm2I954
 JRPVXRORaqudHLRGlsfbi54pCSWCwYYwmOhqxCIohf7gmgubDZG2uEDY7MtaNpUYT5nAjQQT6d4j5KD4oUAF1zAwu7w3101ThYWK9F0gevt6zSeR3lhE3nZ24rP5mNR0KZ9YZUVAx/91y117JQISdI2lb1B/hecj/kqmKVpI2t1tXyrDhxM2K4EG4ANoS/ofjx7DZFsxMldYAcuiheLg7AlgSZJsyIjN6EbLO71ZWbNj5+Hs1lSnhLHLe6dqVV7RF3we+v6mzONkniEe36ThypELoyDlbtYPAKAYmJvY7XODecD9hpc1QBcrzpQtzK71sPJ5oBGJnbz4Rew4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 11:53, Lorenzo Stoakes wrote:
> On Thu, Apr 09, 2026 at 11:41:46AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/9/26 11:37, David Hildenbrand (Arm) wrote:
>>>
>>> Right, anon_vma_chain has. Dammit.
>>>
>>>
>>> That's what I said elsewhere and what I was trying to avoid here.
>>>
>>> It's 64bytes, and adding a new item will increase it to 96 bytes IIUC.
>>
>> As we're using a dedicate kmem cache it might "only" add 8 bytes, not
>> sure. Still an undesired increase given that we need that for each entry
>> in the stable/unstable tree.
> 
> Hm, random idea, but I wonder if we could cram a bit somewhere that
> indicates whether a remap has in fact taken place?

He, also what I raised elsewhere :)

We would have space for that in the rmap_item.

But see my other message, maybe we can indeed store the pgoff. Needs a
second thought.

-- 
Cheers,

David

