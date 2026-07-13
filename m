Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33E8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35196B00C0; Mon, 13 Jul 2026 12:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4B86B00C2; Mon, 13 Jul 2026 12:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3976B00C3; Mon, 13 Jul 2026 12:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFBFA6B00C0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:41:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26A338C40C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:23:19 +0000 (UTC)
X-FDA: 84984122118.14.B277A27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 30125160006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:23:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQn3kgRg;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783956197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unZlIJs5Y9odtncVLNh9Z2E8Jg6xzfoUhhfnjk/rkUI=;
	b=XTYVCnXy7/L0WRvbYjttwqtAUATPYCOp2Vx0/MxlTS8TdgjZMUwkw7l3l4+NNzbvIwkEhi
	CcE4Sx0PT2v5oQn+oFcowErr8JK0/DOZXzhV1SXhEpZ/l0fHyVCtocJWV1gqgfC6BvGZAQ
	17uqQ1PxGLIKJPYPyTi6I9nuhEDWQRg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQn3kgRg;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783956197;
	b=b12+YAVV984Sfa8A5Tt/jSB87hK+IGsQyRJT+By95B9r887jyWryj2WHzdX+7G2JLsN/to
	GZ+kQv37i7eRurcUng/e+X7UvslDLIJTary9epPQ+95jCBo6ZL1Us6Vz4Raa4V7K4JByX8
	VlcDh6WfX8VmyiOAKAwtUZomVSuOZ7Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C10E9600D8;
	Mon, 13 Jul 2026 15:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDF21F000E9;
	Mon, 13 Jul 2026 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783956196;
	bh=unZlIJs5Y9odtncVLNh9Z2E8Jg6xzfoUhhfnjk/rkUI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CQn3kgRguFhfck98i6+Dv1U6jhBDl4va2+tfUt2bJrjDWYoA1+igvZzT0T0+Ymw+8
	 i+/DVcnk8uLHuQDd3tHqQxTJc2Qk8NhrIx9fuw6dleb/w7x0Kvscl4kkBxFTX6Qwyo
	 fM2kSHmMW/PkFAA/ztPsSC/HoVhi+//e/rJRRU50H5uTufU7F6FLqaNvhnNkvkXz6l
	 LYDIhomBB/jglq87O1inkw1SpYD6vIqU9alUxxu1TVpA1gK4h8FzRuvsIXaAghjrgC
	 CgCPV+34xVV0yn5DOXGZkYqhJ3p5CJRPcmcXlaQli4YUbLCIwzibBMxghHvvUk+yKm
	 pLgf24oDdra1g==
Message-ID: <f5156a69-8a85-41f0-b386-a9aa3e3fff2a@kernel.org>
Date: Mon, 13 Jul 2026 17:23:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/mm_slot.h: add a helper function mm_slot_remove
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, ljs@kernel.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, chengming.zhou@linux.dev,
 qi.zheng@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 wang.yaxin@zte.com.cn
References: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30125160006
X-Stat-Signature: hu9o9djmoex9ssokk9pp81kbn7xdq43w
X-HE-Tag: 1783956197-664436
X-HE-Meta: U2FsdGVkX1/2pxYN3FdaoelzbJmTxTu9hqVPbRYTB+fMB+trDD/l5lyg4rilWkX8rRFNlSZQKlYehLNOapXQIIKgP2e81UlO1ZrzUmM6+EONKeJp/uGnjQy3oX8HvhVSLSidLVPJRGu6JMy+J7UzueVUGUwxWyJ059xUuqVsWt7DeXRH+w+C4DOEv0B1lU2PdiGUO+RSfNH6efQqrh79vlrvksg0+KMnZK1Br8iBLQ32pd7IYmAuDj6CInbjJLDhasVgLtBD/eOs5hv4hvRAbM7aaVVB6NI4MM8ndbLva00RIVMA1SgJ+y3aEazmYd6h8dx3Xh4c4PagSsOv9IqozY48zVQZ1FesjFn6AOtJ0ARSNIvDelWEkI4PpG99QJg6+6AwPAsjx8IuOXXxYnSekw/SD73hVurt0tE61VlInbZSnDn0gJndWkFAOtkVSWNUYO72rG0t2xELgPf12LHXJXL0AgHj+Ax87HyMUyRux30ME7m0XseEjUmgc0aZojJtWffhmQtf6xk15n6178hD2+OHYOvsFkXQfqMP7H+411Qjb8LH4k06iLntM8+J5QH2W75a4YMF2dYqJpP0k/iV+fPFhAQkgcfq8Ix0YQ4zFAoaVc3+8kRkIl83i8vJErP+0YJ/jyHHlPif2HxGVNU0wqz0GB1w/jWRVoSBtfC+/2n37FYg9Ia0gncl+NtdxG5VOEflvYTCsrPtepk7rLDeiIVdgKq/IG7dqMUYlvsSQVZbr2JHKlD6FUz/yDLTZEmu9gvjTFff2nAm7fcC2r7jVwYkaTxMleNhehmv5zAySQJ8v/HNbChY9Cr8uy+14dculUb9iJoMwf2I3n2zkmsIeN1/JpzOQE/5CGSFD5JN3PlZo+LLpQNroYp2wMYIABBpN17sLD6ozXxlNiO0UKIeP7l3s/Fo0PjrVVd6zTHeobNl4LT9hHxFVliZxsoWo4/l8+vpZ15Ssovctxs1j9l
 Ub+QcAA9
 jR/x4unaMjtan5FJ5wv9tXrb645zloYeY0l/JVX8VjYzECaqICQeA97wdubh0H51YWgXD9xRSTH8vWudih0Y9KrBUhteMQnSUOK2Kx/IyW5ZewdHW66AS8rSygZSsHJYEkW8OJK5qjC79PLelIRT5ZKZadKRIprxr4+hK8kdfGdJ8gO+lW8CGv/YH3FhP2tG4svLmTN7TmdwYjk8TnGENrfx6QkmM11avZMo2pPOQ7AvcL5OKEC9WLJuL3FGJB1fFTZaNAXGi4QIM4Y4FMvDxG3Fn7vBXVV9MU5gdHRdqlnqVTDOzuzD4Ox9l58BDrPpH5ET5z33A2YRrGhASlR4BCRn0IyCcLHT09p0h3B1H3gkW2Qnxs3QALNBHIg0vf05itEIMgHVMgeM4xrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 08:37, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Both THP and KSM manage per-mm scanning slots using the mm_slot
> structure. The slot is kept in a hash table and a list, and removal from
> both containers requires the same two operations: hash_del() and
> list_del().
> 
> Introduce mm_slot_remove() to abstract the common hash_del() + list_del()
> sequence used in both khugepaged and KSM.
> 
> No functional change is intended.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

