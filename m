Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152DF10BA451
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1C86B009E; Fri, 27 Mar 2026 05:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8E46B009F; Fri, 27 Mar 2026 05:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFBF6B00A1; Fri, 27 Mar 2026 05:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BBBC6B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:00:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 132161B9702
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:00:18 +0000 (UTC)
X-FDA: 84591246516.01.B844D93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2283240012
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:00:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AFhjKN86;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774602016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olAzPwucm3SAy4DaHlfYR8Jj1YUwGWKk48KR0qx7hwE=;
	b=mAgnCReluw3SV3feo8nUOLIuIQij2G2x83dzrlhn+s6x0FHf2cZMdIEtGGCVykC9URAEBK
	WSyCJggv/7LfrOpNXIFZtypcjYi2N+ouGaT3RehwXRdmwuNRu9yvTPcwQxGbEAtsxe+jCZ
	mcGHcu3J6Qqr8W1MSa1mGxQtJRTUb7A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AFhjKN86;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774602016; a=rsa-sha256;
	cv=none;
	b=kj4RDiXvv8AxH5jHpO1MJHZCVdVuaZdIZGxxb5iAoWjCyxctFThr3abDp2smSYgA1t66s3
	mn1c1vnyc3hBot3Hr/HT94nrMrRDSA8EKpG8X18UbvOMNUyhIsBlK/xQCRRB0oIIjg2Jx4
	5ERSkIcaAFMdzhOTNpuiYxHtAUqglws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D61A402FA;
	Fri, 27 Mar 2026 09:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19459C19423;
	Fri, 27 Mar 2026 09:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774602015;
	bh=aVaFxUMR8z7yeXRipxfOkX0IUu+JUscjHV4aXgsjZf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AFhjKN86UqVA0ZIQ00LitH2pKhun2qded3gCDJsks2gbiUL5RyjoBlHC1JvQwZcz8
	 PiPuexeu50l0cZ4uIsxfkDWgP88i9FyIaa+H6dNJnfWK65sBGIahWpBtTqVZXDT4X9
	 Rk44Qn7UpoHxDjoLgIN58pBPaYe8TWLJwcr+p2ANUjCal92RuSAxirHAmSne7Dpzev
	 0mFvQaWN2pnYUtFhtcWHh082/Ia1OZQwR/hGqtkyH+Tdzx7ZKaaWj6heTI6+nrixW6
	 k9Ug4wG47CdG0m9KNQyJ457/aF1H5pwNAqexF4SbdnYuPUFbef0VBwHKyMytLZBhqa
	 RLibBURGBVaIA==
Message-ID: <60641971-e91c-459f-8d8a-ed6635eeebf7@kernel.org>
Date: Fri, 27 Mar 2026 10:00:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
 <bfd282b1-523d-4945-97a0-ec30fe1df577@linux.alibaba.com>
 <a0181a7c-d191-483d-bbc9-678bc355a984@lucifer.local>
 <aef474b9-5286-46f4-99d2-43d0b85f7176@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aef474b9-5286-46f4-99d2-43d0b85f7176@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2283240012
X-Stat-Signature: 66e6m1r5teade3748n395twtksu4q9zp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774602015-357190
X-HE-Meta: U2FsdGVkX19276BCnBqmwZzgokMTHonrnsBduk0E2Y9z//istyjWS3CzSEijZT12e/FphuLNa+VbzwKb438Sy0Yc39r+HDCmNr0eiNCCwjJ+6Td+Lq9JYBLNCLdT7VSzoNNeW3/qsIdDXwtJz8N0PJMgFYq47F9ZGqPLxH0tWxqWGBCHVim6sA9UdMJ49lbmgiQItrGgwhVuonuEv/U8KWDuTVkoZYPArR/ycMzg+YC+RTZB1k+rMGUBrnfN9xw3R3M+ya/xQ/ktM99aHf5+eFYDCOWGV/leP/6HBnXg/KTwqmsAto/nmenrlqwztHI4Umw0dgLEjrONC6GxWSCvJNSZqjoH9yCBCoZ5Uj7AFukCsXjRih4/KBjZKxnIE17cZMWE/0i1UOekdfZXwcIT+kwmzJ3UL3YTULCtoUqn1nWJMOiREyh97hKWdPo48BFrJIXwyE68/N1U4kc3N+1ApBFpUBVYryRwWjm8Fx6tgugJSwlYkuNwAEqTcNfQI11FErBK5V9EnYyHv9EPupLlMNG0w2uqaeylJBd09qbu+AOpv/AaBS4SXBycXgymR74OvUiIvOkvMSJl4qdNY+sX1zmURBAaud8We1BW9ClSbpZ6+gerXcCeiAjszTyXuLd3JWj98X+Lat8s77cVKdwx9lBNdCsO9Yr3HgCarsSfOUEd9WxOVvAZO7fycyiSUfybO2/FazTpxhjWq17CUd1I/psaMO411RnMY1alELVn4obngCAe1hVMmDu4oftbxa9LUh+ckto9hVMmxQQtwoGcO1J1x0Rm5Mf/ZsX4uK6B3ISnFCumnL27uewAG6nen3uu/KqtrodoiBFdyHRsIHvecOTeJBhLPin0WGO0dqo7Sgs1VGduezzmb9uruiRLaVWOwJaWCRU3z39SHeyVaDI3mNyqmtc44mDC5x1bR/Ig3EJLWo6Un7+ASVtXjXLN0miMQV6EabuyEB83grfhccQ
 FcrA1u44
 3KUhUoBKbHDSL1doew2gLjcAXgce1DUKmL+FAIxni5MwO0NLQWzbBiQhzfAntGkxLlurwLmvRN/bW6F89K7h2wYdO2egrUCFDinMeUMY4d91kAQgP2E4bU3niGkEQOY51I84r6R5b1k0lbOELbWMFBtpYFhxT8g+YN9mr5X61n6OgCncBIWWntpjvRbcqk5Eypz8LelRZzk+yzhtewzfNCvzIWU6W1w+4qwcKuLjZclEVUSwQdM/YFO1tXPVS0h/txwH9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> And there was ongoing feedback on this and the v5 series (at [1])?
> 
> Regarding the feedback on v5, I believe everything has been addressed.
> 
>> This doesn't really feel sane?
>>
>> And now I'm confused as to whether mm-stable patches can collect tags,
>> since
>> presumably this was in mm-stable at the point this respin was done?
>>
>> Maybe I'm missing something here but this doesn't feel like a sane
>> process?
> 
> Andrew, David, please correct me if I've missed anything. Also, please
> let me know if there's anything in the process that needs to be
> improved. Thanks.

We might have deferred that series a bit, not your fault.

The uffd change was indeed a fix. If we would have found the problem a
tiny bit later (while in stable), it would have been a standalone fixes
patch I assume.

The good thing is that all patches were reviewed+acked.

-- 
Cheers,

David

