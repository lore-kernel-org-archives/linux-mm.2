Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1BDFFEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F726B00ED; Fri, 27 Feb 2026 15:19:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14ED6B00EE; Fri, 27 Feb 2026 15:19:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9066B00EF; Fri, 27 Feb 2026 15:19:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C98D66B00ED
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:19:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AB46BBF2E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:19:44 +0000 (UTC)
X-FDA: 84491352288.19.AE9A3A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A103E80004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:19:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZ+5OHFJ;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cB7r3je3I9qqgoj63zBS4hQjelMbqlHkSTYbrbCMeI0=;
	b=470Z1tlNSE830U3fEY8G+pDpAd6Uxzouyz7h1y6CZeuIjnxk7ej+n5RFj56Obouq5hSi5H
	RWj3LINFoxBUw2cYDJqC4Pn/HielZFZ/cB6Z4Bif3zzwI+spEndo3OR9Kht4b1UsPqGczK
	gW5NUMLdWGxnReMswURDeb3eyxnpnGY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZ+5OHFJ;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223582; a=rsa-sha256;
	cv=none;
	b=HOHkaTSUPlg3R5dzlvL4epAZpas8VuEajO+hKSJlZQV3UcMND7OdXVj6li2bG0fvyIWb/6
	JNOshRlkij37e4t3QUISvH9Aa4yVIlRScEkqBGu38hySW+RlcEe5wPcCo/mKjEwB0gJEBR
	QsIWLHwBj46pgcImh7XaIDvBHKqSUdY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D698442A8;
	Fri, 27 Feb 2026 20:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CA6C2BC86;
	Fri, 27 Feb 2026 20:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223581;
	bh=5fNPUXE9oJb6B1Ux6lQSkqsmnxeecDugz+nW9DMgWIU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UZ+5OHFJw8pCNgSDIal04w300OTtvf75IVcavv+h2cRgEeIRGcSos5vNdhdzqX5LF
	 2uC8P9Dc397mmwlw6XLnK7jOW5GNq1KKVHJSUI2+Q1K3NZKcz+LZEsZLnszIbAoLdr
	 wlEDznrUJFclAhccN9P5aPvuR/DM/DagXD5/jEhUfRTl0v3beb81Appkd1s9xQ/hL/
	 6Px0l0A4bEfg3BEBmNCYvx0KsZLeulh6ADHN4nJIDjezI675/UGkD7AaaE5dGlboHa
	 +K2NsAnHcUmOUqVh+7Dylwppu5/lV1HtJ5+obaqVL9a09DrfdpyOxdNBziQwLboSu5
	 cUelPX5cSNmVg==
Message-ID: <65bc73f4-e07c-4ead-9eda-b142e691e110@kernel.org>
Date: Fri, 27 Feb 2026 21:19:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Pankaj Raghav
 <p.raghav@samsung.com>, Suren Baghdasaryan <surenb@google.com>,
 Mike Rapoport <rppt@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Michal Hocko <mhocko@suse.com>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 mcgrof@kernel.org, gost.dev@samsung.com, kernel@pankajraghav.com,
 tytso@mit.edu
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <aaEsOu0hgCUznzl3@casper.infradead.org>
 <8ca84535-861c-4ab0-a46b-5dfe319ac8ac@kernel.org>
 <aaG2GkICML-St3B4@casper.infradead.org>
 <653e34d4-6356-4f9e-8298-40b4e237f761@kernel.org>
 <4A89F75A-325B-4FFC-AAB6-07C206844B02@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4A89F75A-325B-4FFC-AAB6-07C206844B02@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A103E80004
X-Rspamd-Server: rspam08
X-Stat-Signature: jmkf6ypj6nt1j6xb15bktkg7skmremk6
X-HE-Tag: 1772223582-932598
X-HE-Meta: U2FsdGVkX1+jmROqknIRHeJkxZ3Qg49oVWBBBpBSwHlB6iP8j0scEWuMUZueSwXl7Koi0km7YrKSpGcDG0ffmYtZqVAxtWSNGICSEMQGdIak36UtUvaOud9TibRmPErCUJ0eY3UsrsnC73lDMope7MpD+qALJxrjZ1r+S1Ngvayia/aC5qsFzubbIXNED3DquGBJOwFuTJRhOgj3vzXHZTAutCd6XlAyA25cyzvxWMqFkhOddXrbTQnItaL+JZMNnyH8bGoqQGqJYLTGg0DkknyXZFUAkIh0V9HeyBwxUGhIEom18BEPnJ/Q/MLAfVZ0pQcmAdQ5twFfOMORDIougPxexkR0kCvCE1B/MNAHbNxCl4/13YBzIdoUZQX2eBUEca5gTvFTgmZhnJ5lEHJBPEHaqRGgbc+D87tbzCv/aucMRrLigxGJnRn8c137kWGLNGsQLRdYgKIqV9Im37Mfycn4bcz8XRBZA9K6x7+8A1myzcqFvD8/JHZS6c4oBMEKwc/rWcR8O8zcKmwy8iMtCRSvSPfHPVgQyD1Op00OK17tkBUCZbbv/yOH1VPYgIBKVxu9mNMn4gI6jdXOA5iK3yrKkYqOixOhEZXlcxIXW2xI2Q/FUCWHgkfE4a83E6zOo5FWrAawQuYaROzfK2cqmr//aR+ia8BKjJZ6lQnmg+pekhUxKfj5S/xjomw72Mt8lp2sLL74ZbLVKbfVmbn/Iw/6WqnV8gZH/GxuciU9v7+3mIz7mjFXOR0C2ztKYRJYczOY6WKNVLlVcdVGB0hdUQvTmE4W/RyIa7/OrIamnLtAJey/y8y07eMxCyCjsMtgO7hB7MQtmgEkAIP2PtlvmoqCfvpV2jDVfAtdiedxtVnrOanOjCn1gI+BWvUDzpGhwArckTkYmBFoDXdefIr3dEB8dm+vumkUrhp6IFI8Uf01CEjUMu6RG3LZlZwqbIdXq3G5Fg+kPktmU1T02br
 ksR2PVVI
 XFwp+hqAxcwPNVZn4xd0KT7CsStilvKmYJWD3/WakwBLiklrqmszY/ff9at/2ihbl+zovcF4Yw46T0oaYOUSMihACHz07lthJIz2AW0v6tRIGRRetBbQ9wq4ppgpy3ET9vGo85oV5mVDEKjLDai0M/T/YYUQWCaDEaiKjHpycdjRK+JWmV5UBPxCPdroLUVceRfqptnFl5pgNMviTD3icblEs0gfHMz4VMSgIUp+FnZv+mPyD9JzBMCssf+XPKgQmxt1p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 21:16, Zi Yan wrote:
> On 27 Feb 2026, at 15:10, David Hildenbrand (Arm) wrote:
> 
>> On 2/27/26 16:19, Matthew Wilcox wrote:
>>>
>>> In the Ottawa interpretation, that's true, but I'd prefer not to revisit
>>> this code when transitioning to the New York interpretation.  This is
>>> the NOMMU code after all, and the less time we spend on it, the better.
>>>
>>>
>>> Depending on your point of view, either everything is mapped on nommu,
>>> or nothing is mapped ;-)  In any case, the folio is freshly-allocated
>>> and locked, so there's no chance anybody has mapped it yet.
>>>
>>>
>>> Well, it is, but it's also exactly what we need to do -- frees folios
>>> which are now entirely beyond i_size.  And it's code that's also used on
>>> MMU systems, and the more code that's shared, the better.
>>>
>>>
>>> Right, we could do that.  But that's more code and special code in the
>>> nommu codebase.
>>
>> I guess I'd have to see the frankenstein folio_split() to judge if it is
>> really better :)
>>
>> If it's really just about skipping the unmap+remap the end result would
>> indeed be nice.
> 
> Without unmap+remap, that is just __folio_freeze_and_split_unmapped()? ;)

I'm rather wondering what else we find when we try actually using it :)

-- 
Cheers,

David

