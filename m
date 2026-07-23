Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22403C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 16:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036496B007B; Thu, 23 Jul 2026 12:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E106B0088; Thu, 23 Jul 2026 12:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40C46B008C; Thu, 23 Jul 2026 12:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B21846B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:38:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46402C05A9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:38:29 +0000 (UTC)
X-FDA: 85020599538.07.81DD4EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 77C5C140004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:38:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeMVKs5X;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784824707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUO8C4g2gaArh4Y4Dlt29OXXWCzGAsxU5Y8v+yOgtp0=;
	b=TnLxuhLwBa4EJy5IYddSRniQA1QC3pnAK1uCbJmvRWdmn2FwIpTnzZ6NZLN9RCzEHIOR6+
	0p9W69giAfgYQBC5kPNeuMv3CAIfHddGWIOIFPnPUceNKf9C8zz+5qMsPwu/Wd0T1l0UFc
	RK2mS7x9twYe/EyAjGr0IP7KxXXz2Rs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeMVKs5X;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784824707;
	b=wjzVD7qQHg/wJ3+pMT5oIfbJgQHs4jrpxjkvbfd2nBAbj2hXJVVAF8tfexSEPyrpUJbFc7
	KFyv14PKEKyBsWaJ04PSVwiY2z63z3UnZVl3QYVkJa/MDjSd9G32mkA9igy3JZ82Rzevb+
	e7QM3C7i+TfjvZ7bdmmWhOP4icGba7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2FCA60A58;
	Thu, 23 Jul 2026 16:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155ED1F000E9;
	Thu, 23 Jul 2026 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784824706;
	bh=CUO8C4g2gaArh4Y4Dlt29OXXWCzGAsxU5Y8v+yOgtp0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CeMVKs5XYRbmdHnZWBRbIOqlnBLNOn4YY2wMWAwayfNfMto7y/YliPtgQRBpZUmTT
	 vr19Tp4i8Wn8VkHl+4XE9zaPN4O1GKjEX2pMXsObb21kIktQoVMW4AxauYM7mFqsqy
	 m9Vfa5aIPEAoUj2XLgE811bhN1BpHteetKbAGL5fm88oTXU8xJ0uJTDJgsw5Cdqvvv
	 3kfPW67BOYQdcVgtsWd02pt9jPfjCc1B1jL3Qe4VFfPdK2ERG3xSGp2d2kucltgaZ4
	 tsbkuGb4ZFTZOHIRVYEoFAE0PsnhkIQB2+/JG5y2b3OGNsB5jMcgjpaLsNqzciGxke
	 LIL16JRMH+F/Q==
Message-ID: <716f73c1-41cc-48a5-b0e1-a47403a30da1@kernel.org>
Date: Thu, 23 Jul 2026 18:38:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm: opaque hardware page-table entry handles
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
 Ryan Roberts <ryan.roberts@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>, linux-s390@vger.kernel.org
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <31d36023-d728-4eee-90f8-158c7066f565@kernel.org>
 <e22407d8-4509-4a53-9ba4-491b9d5c5ef7@arm.com>
 <4bfeb697-9c1f-4316-96bb-9bfd66f959df@kernel.org>
 <6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com>
 <20260721124057.2820903Adf-agordeev@linux.ibm.com>
 <3c21586c-0ffe-4ebc-97f1-803e8acfc5c1@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3c21586c-0ffe-4ebc-97f1-803e8acfc5c1@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 77C5C140004
X-Rspamd-Server: rspam01
X-Stat-Signature: hwsb7391igsk7995do7kfpjwxdxnbzm4
X-HE-Tag: 1784824707-613156
X-HE-Meta: U2FsdGVkX1+Tx9OB65dpd8NXeII3fmkT0URiSXjXyw/KYaQeSwiFR5tP+nRnNlpmYu5WMzYJceN8LD3V3/MKtt6MAiPmXPxKEqy7kEBVhgHlCfYMSBe3J/omb02Qti5+Xj93YxQAveuOAGVHb/IPgP9kNRliXImmmdnoG/r7l1OOb2puv2FJIX63AT7Hpq4UENpq4gjPdMHy9pr5HF9mBAN5/0aHpLQ1fHl+TXRPp4wVDh6INDeE2KNFXuSCL/ewniII8FM5i6hZzR0Z2gj+w6sDvrNymov3C/4iFguWx0k7jr5Ncz9GyTEmwP9dxlN91qzHj3NBETgPRinSQQuFcVzPPCzF6BD2YubjgiEl78Ja9KSQYpcNJpwvBfXT3lDvgn2MDOxMGrFQ60H3PlLK493ucm94xuF6GilKMQHgLVz0DK7qtmxfLBvVhzF938AEFPMX8Dqx94DRBeG/FZ2sSoTquVaBZErEy3/Gb88eZpcG6TrxYE0bB8Rpg4l1hXj9SynCJX9rXdPNHLI0dJWCVL8yCfHCB68zQYwmmgTyXWUTqXbU+8rsLkO2Fmoct0GhTPrbn4XNP0NCShu5ssPKpcE+KIOILi+v+iD7rteViLFSuN2u+Zjohh7F/g9pQRmp8jQ87hWVe8SWrLfOxeC8faEW9vly7NbVMmbsaZdHv350nC/urraMdxtQA+/GsXDa977x0W1gaBlX6UQvB7904kHbqfDz3IzC2vWOsHC89hE6bg/5wVf7Di6yvD0wJFhdVCoeVcv37XArizvLhWSjdbejhDkQPRAOoErm0hrXu6O8pa5AjXQygmoYXpT0C+aLRt2zMevVnYmf7kI7Yj4shuogQf4ZCvzWuHmZCupMx1Yz/Ki8uDFa7Mfpn1XQhYElF/mwNTJ5sL5Z4x/DyBlxRvgI5omh9OyoZT5iLyMmQaJUN4i/iOXEnTGhtkMHjonEC+Lr3K4A/7ht3OcUoLl
 71Q3gkf1
 P5OLy9MjIi1INmtMkm8IekKAwXzRGs/uQ3YzGxjo0fjtak9TneT8Eeihi+O8EMZCB2TbX332Bm2wdvUeN4/1QOxDmX7VbA5e44rMao2D9P1aBrb1AKcbiA/tSR6TJAuAwlpF5IeVT+qChizA8sH0uBhx5zUd0EkQmYe+jzP1MecG0Z9VVcZ7xslC73dxWKB601C1q74T1Pi2mPyd+aipHihcWlXec0GYyDWOUhoPM63EK0PhGc0DYPwdEfNQJDrCX24Qu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> So after the conversion, it doesn't makes sense to keep STRICT_MM_TYPECHECKS
> around. Please correct me if I'm wrong.
> 
> This brings another thing in my mind that in ideal world we would just
> turn STRICT_MM_TYPECHECKS on for all arches all the time. But the problem
> with it is that STRICT_MM_TYPECHECKS defines pte_t which will stay double
> meaning still. So we want sort of STRICT_MM_TYPECHECKS with different name
> and separate stack and hardware types.

I think STRICT_MM_TYPECHECKS is also to avoid catching when passing a pte_t into
a function that consumes a pmd_t, and vice versa.

STRICT_MM_TYPECHECKS makes the compiler generate worse code today, which is why
we don't enable it always.

> 
>>
>> We would like to keep it, and I guess some other architectures too.
> David had summarized it well. We'll convert generic code to use hw_p*_t
> types which would be typedef to p*_t for those architectures which don't
> care about. But if an architecture wants to interpret these types
> differently or want to make sure the type is enforced and not directly
> dereferenced, they need to convert the arch code a well. But it can be
> done slowly.

I think what Alexander meant is: they want to keep STRICT_MM_TYPECHECKS (or
something that achieves something similar :) ). So as long as that keeps on
working, all good :)

-- 
Cheers,

David

