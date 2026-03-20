Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A3E108B8E6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8BC6B0005; Fri, 20 Mar 2026 06:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC03A6B0088; Fri, 20 Mar 2026 06:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6896B0089; Fri, 20 Mar 2026 06:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD88B6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:22:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72B1C140170
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:22:48 +0000 (UTC)
X-FDA: 84566052816.25.FBDC718
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 972DBA0012
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:22:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CWXAPWUY;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774002166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PV5qdD9E+uRoBx3ssHFQYCXekzAQ0g2mMVMZHi923c0=;
	b=IcD9qG24gStQb1ev6MpSbc4VUYgfkdgA9UJ4dr6HOrQUPWrfXjIH0Pk7l+G1YUh6g4F2ep
	6wqMKFVLXt0X9edYdqTPIbiGahmx2Wfp/9Gmx9wxovInGbPibTuLaAkN1hv37e0JNwqHGg
	bfOTJr3M9rJ97/T+LTBno5ymTQutQRE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CWXAPWUY;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774002166; a=rsa-sha256;
	cv=none;
	b=CT+BCU+JXCtZfWCOyr3PHxoeStP90mc/KhKaDSB9Q40pJGFZBq0f6kW55Kfv4mm8orp9nH
	qp0u2bmDxo+Hz7TD49bE9h2XguEKZXvo2ZFuDPuZxtpw9pvY8EJ8r7paI2N5flpV+J0Pw0
	7h2j6+k7KN2Y0UYbp96DSut5xcsqZ3w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3AD460126;
	Fri, 20 Mar 2026 10:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59259C4CEF7;
	Fri, 20 Mar 2026 10:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774002165;
	bh=crNa30WH4adRpeaTFKjIhAXtUysMpVMJeaQ135RfaN4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CWXAPWUYtfC1veUXTP+S6ZO+Qn2ZeZ3xwRX4yxEmtFmBEVZ91iybaPEAQARnwWtC3
	 XU8w9K3dDsRSGFAAkR0KJw3I6goKG9OVLvwv+e/J4jQQ4JgAUScHXPXAbf0lLePKdW
	 aI5Dr5FHDID6+IsjMy2ptzkzEdU/7/CtCWbEApbPa2axoC/wC6sCt3o44IwVMbqInI
	 NvJlo+Q5Fj5dWcQ+5sa6kVJWYksMco07bnNDctLL7g6wO8QflTgscjGLrLk4wOPaK0
	 sILY/S/bTY5qfD64kxVuThZa0UJ18s9RDl5L/1BrMVfjFaK1y0bppa4tfN3NfxUWgq
	 vXcScTYGphUOg==
Message-ID: <86390177-3c84-4bc2-ae19-8a7ec82fd910@kernel.org>
Date: Fri, 20 Mar 2026 11:22:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Jinjiang Tu <tujinjiang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, baohua@kernel.org, ryan.roberts@arm.com,
 linux-mm@kvack.org, wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
 <20260319155101.f7a62c04a7bcfc838b63824c@linux-foundation.org>
 <d9d50263-a69f-4a16-b409-caeec93c423a@huawei.com>
 <37a204f2-796d-4d15-b21b-09fd4a9e77c2@kernel.org>
 <f6e30243-8253-444d-9665-9dfa33eda9ce@huawei.com>
 <b5e99cd2-d49c-4653-8d0e-4ccf35b4a288@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b5e99cd2-d49c-4653-8d0e-4ccf35b4a288@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 972DBA0012
X-Rspamd-Server: rspam07
X-Stat-Signature: dhg88rdf1r1cfef8h7jfh8jtagq9bj35
X-Rspam-User: 
X-HE-Tag: 1774002166-611781
X-HE-Meta: U2FsdGVkX18wxTEnXdEx7IkaHj60y4X2tppeWFmsduGLduznJjLnZbKhrqOFhHj1U+q1J3yRYDWeSKNXxbQeCQXCnw2hduKrSCP9xulGP9qJMGk2RfgkoNCgiG1UjaMeDPhF2sF91CqBMDmiYvwALnbgPopcN52V7PUYOH/imfFDv1DfDX19BbbBNRDTmPcvqSfUPup+z6laFkvglLn1La3PSk5VoUQ8b4np/KQ6ii2nAkGx89Peg/a7C/+JOtUNTreGg57x+vngRfRYptXvWZAgqcB5SolmAVhZ/iU5D0XPuVK0KjS9jhu3ckZOKC/dYmeDnbTg/7YiYQD91MMWtOZ0P0/qNreaUrbX5ZEGyI0wmD2bH9XEimCXXgmIIcPkHVplXLIIp5NDWYmf+yg/Fg7w6zcCPZEqlaQT68vxe9De0oOWHEcCUAgtcQ/ajD7pi7x4fnlvhCPFK4HSAUs0HCh6cBaMMnKZdnFSidoNjvraAb3zbRNt1FTwwJEtSdwfyaFQoUQ4Wmhx7z7R6NIfqUw9mNlg+fNu6kHxH7DHCYDd8m4PsQoN/XX9Xlg4mB6iDsOfFLVvnnRIH6b+2WK7Yzw12kP58zrYhW7C5E1DYWsj6OA4gKo5V/4nBaDlyyqXTFcJInzPYKS31GWhlfsTbt5xH6b+JBOeS6kOwHchg/4hNlwib88nb+9cAhRFefa3evB+b9wI8owyNA1PdxPnwAJ/kaSLAoBquosjcJc865AzisHCvlst9tV6/1M26FxY07zw3DbPwknpCGaKOvLkQyyxhc8nl6KEWO/TXsg0ZvyVGE4OIIR58paCIj8xpPFddk8lx2f3Q4RDgs3Og3G6Bq4wWkyapkrrVb2Bkg9NVyCEqjpRTBzYfka+9cF6kARdW4y2UMkwJkJ4DxAe4jW4BRUef7V4P9f9rGGhToHZVpo2ygZ7WfzqRr59OnOvhVwspKm3Xkl0Eo+uEHLx71a
 OwVIUH/9
 bZyB43afERMeLNNuISy79KfYXJsqPKnwBKOn/4GE6W6mhLHVVyPVNUDsSnTQwwH5HVnNRaGNfWvLAYzZhAR/GDydSI3P41ADBzf9H+CGe23oHOqyfY0qkQUG/coQt7l9D2XW5GMTW3sRg3vDVf1uLU8M/Zcq5/6DR0etNVKN1uFwgFbuxvIl4whfjMZNjnsLuCJ1Wly3DXCYBDWCMZX7kFOyq9eW0WgCwQiyg3/pMASKEq5zpsAK7xjwZp8AaCiWz6N3oKTW+JvgCUsHJ8JM0fst8Qrzl9ej3iV+UO4V+CQBZpKiJytu4DsKWO7xIPFcKFKmiM9bKcH+QtuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 10:57, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 20, 2026 at 04:56:57PM +0800, Jinjiang Tu wrote:
>>
>> 在 2026/3/20 16:10, David Hildenbrand (Arm) 写道:
>>> But the impact is bigger, right, when callers rely on folio_test_anon() etc?
>>
>> Yes, the impact is unpredictable if CONFIG_DEBUG_VM isn't enabled.
>>
>> But for stable kernel before v6.19.9, this is a BUG_ON
>>
>>
>>
> 
> I think important to note that the asserts are asserting consistency, and not
> having consistency is a lot worse than a failed assert :)

Exactly.

-- 
Cheers,

David

