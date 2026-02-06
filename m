Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8922EE208C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 11:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6CB6B0089; Fri,  6 Feb 2026 06:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE676B0092; Fri,  6 Feb 2026 06:10:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB2A6B0093; Fri,  6 Feb 2026 06:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE3936B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:10:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB488C1F13
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:10:34 +0000 (UTC)
X-FDA: 84413763588.15.A89548D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 03EA64000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:10:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g/1FWCl+";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770376233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xvl33vxqmEwnvsKH3lhYt/oIRmVNa4cqCguvLVeqlO8=;
	b=Oo1fpbO16OaptPypZNmCMbUobtkuvro/XCzZ9XdifpHCqlxLw8OnzySUBcoAE3ovX7pljh
	Dz+XFJR22NTidoIFSeYBsGWI6l8YzxfftUWcwH6C9KsZVUOrtP+3wk86dpkT35RxuTuKM6
	ShPaXT+0rwX7sHLxjmi18lo0+TTxJds=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g/1FWCl+";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770376233; a=rsa-sha256;
	cv=none;
	b=zWYm+ueZqDMN+rNiSAB3WbgSGqdZUQFoVV/A58whBHPsoUcmU0iFJ0b65RI0uvyVT22NGV
	LqHgYXvC9X04P4QqDHSYeJQ2Q+Y5Dr2BPaFFLks1G4vwSfSuHZ7g6KDfxd2XL58uAWcvBw
	af9aa85ESux20WwgGJ+gTeLXSClzTCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 675026001A;
	Fri,  6 Feb 2026 11:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E2DC116C6;
	Fri,  6 Feb 2026 11:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770376232;
	bh=AwzJI2r5voYQ3yTRpR0CJs4bIy3I9kzsm56liTWmL7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g/1FWCl+aQjVGihXo+9mcIp4fSXtBfjgdZBL8eQtl1Jyf2rlRcOG73XntlgW6obfx
	 ri2MhLRUwQaSuMfnP/py9poB5cgodbZXjaq3LVEW1Qb4mVV2RZ5clyH1ZwK1XnXPIL
	 xS0EH0TYTg6H+gMlFYX9mOIu2s680Lf4DVnfqcT02IhHrXal0q0JcQL7ndS3WTmxW3
	 VtreEvyXiDseN7siyow0vGHpQbiNEjXtGnZ+KJGe3ynYIGPIPV0XBnVKnkILkKXMet
	 ml2WQPiEQkhbK8rtLy/2wC37H8UMXd0MrDQF3mBQk2wdmqSQIW2mN4UmdeDBd/yyy8
	 gAsSAnEX72yOg==
Message-ID: <f9defde5-c525-430f-8ff0-d065eb4ae57d@kernel.org>
Date: Fri, 6 Feb 2026 12:10:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Dev Jain <dev.jain@arm.com>, Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
 <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
 <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org>
 <15ddd3fb-abff-4a95-9670-06622bd90e1d@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <15ddd3fb-abff-4a95-9670-06622bd90e1d@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j8j7q61cbjp57r54mnqsx44fcgf53647
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03EA64000E
X-HE-Tag: 1770376232-928911
X-HE-Meta: U2FsdGVkX1+lusbon6QUfubL/UUAWgER76JFfZIVRXrjJnR+bRVrN1uigX+55R0bwtAURF3vONiFxDoqYtrP931+IyL92jq4FRMMr/sQB2Y9GXi/m+9YA8pW0ZuPFS5S2h4pLB+6hF2LICHRat6Qj7OXbbmzi7MQIfNhPGTBE35RLheYtLMg5u5NSFEz+gYPF8756DmqSYFsquhHLN4UjDOaRCTpoglUW+g70j+C557G2ZycYqcWehJqx4CgZOtSHwhMxPpZWp8BDCNlK563r6N9OrTjabCMkLf6N+H1t+Qoyo5wMykShZdlmFbRuHcvXzjBb3k6v4nHk9tujcncWmMe9+bBaKBGaHjQgwsRXA3jfYHt0ZfY9yJVDvCIcxYhnteKs4sWGJYHaXv1jtpcB7FAHoVuWC53BAO28TGoYw0jFI5pDXv/y3nH9xtUY2pT4ULYRR687kdpJnk5lkJXDfdQgkgo6XtGdSqlPlzjnE0q32ertVTaUs91s7QL6tScKMKPo+LAxAx0h9/FWXmRANNBiRyfyx4NMfMPu41zGavlSPGJPfFXw2TPja1349bwXmNoXmakwm3eZw4nkWs0gO3emF3q/89XOWw1ygiH+V2E3/KVoKSKEFkakDYnti9mwZgPQ7GN3CaA2dwVztutun1mWS7JJMUtMsUD5PcdgL+2/oeuUNpTLqQH7tTaYN7TdObTVbwKJYH5TJdh9L7jl2cN46K+ifhgH6licJtfgiqr60ossl9ayML78G36E2uuIVUI4jb3r35CgDuMMA4kvuz51nXdspkZk/vRn98ZR/EwFRQQSqNE+TeP/TksauGYQjvSLilZTh+AH/fhFWJxWBxpJJyWNadkGhrKVJgznfBa8MCRyANFiuEPvgRE0Xp+JrMEI30yjfq3qCCizpybPhAb1FAYMi5OK39Gv/MrUbQ2loK2WQoU5Fjho7x2wMrds3peNgkw2cOQk7RLBKl
 cnv0l9U8
 TxU19RVjQOo0ZOeXvg5w+reneQMjs99adnQnCcs4QJSGXvFKFxWM52QaicW0pm96QRMsaagdVU33CAdjAHPa/hAtwN4NCici3DztRZte6ak5WU2SLS69G0HPCKBCTX0O9RDlECDFa4QN1LVkNYEWIB8569sv1ZogbCGCs2pQXuw5o8wPQ5mpRI+yc+S6IQTULB9kcObi9ZC0MieiAiCSWy2RYWUahtpuo/Jnsl/FXExL6bqjGLLxzFkouAREh+Raq1TI3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 11:00, Dev Jain wrote:
> 
> On 06/02/26 2:32 pm, David Hildenbrand (Arm) wrote:
>> On 2/5/26 15:25, Dev Jain wrote:
>>>
>>>
>>>
>>> I mean .... we don't, but the alternate is a one liner using max().
>>
>> I'm fine with the max(), but it still seems like adding complexity to
>> optimize something that is nowhere prove to really be a problem.
> 
> Agreed. Vernon, let us do the increment in the loop then.

I'm fine with the min(), so if you both think it's better, let's do that!

It makes it slightly harder to understand what's happening, but 
fortunately, if we mess up slightly nobody will really notice :)

-- 
Cheers,

David

