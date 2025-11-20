Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB01CF64AB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B06F6B00BB; Thu, 20 Nov 2025 04:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387A16B00BC; Thu, 20 Nov 2025 04:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E106B00BE; Thu, 20 Nov 2025 04:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12DF56B00BB
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:56:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C457FC07B9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:56:09 +0000 (UTC)
X-FDA: 84130529658.10.E20395B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 945B7C0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:56:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763632568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJxhGPvS7Q5n6YTgfPNf48tD8CEv5gs8FHe0jGhiYtA=;
	b=WAirGf/1BdQRMCKu2udYSn3kU76flzXkjMVA7rR9k1oPBxA9zaNcAcaMj7cpQV/xf3H/74
	CSPihojNvEBjKSTLYXEogC9Pu+50/gh1HSt0YjABwIutOaK3mOApTiGfxyIYEiZZZPmkGS
	duWqhF111vSXmS60lTOcwb6FOyo4vcY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763632568; a=rsa-sha256;
	cv=none;
	b=IUbp4hRgbFFYfLlGSPdc4SG5HBkIjkjt9r1ov+jz+ajFBNBI09kBCReO3dsX/jOqKz70dM
	IQ3uHNdF9YXftsNZ5RG+AElueduMRqpxuttrrqLF2BpOdgbYQewRZu3Be6RYdBq5+G2xsV
	Bh4UE34HZquA9hBrsaP6Nfc6H56TwYc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C746A339;
	Thu, 20 Nov 2025 01:55:58 -0800 (PST)
Received: from [10.164.18.59] (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE2F13F740;
	Thu, 20 Nov 2025 01:55:58 -0800 (PST)
Message-ID: <7696ef91-89c0-427d-951b-56dbb33b4dd6@arm.com>
Date: Thu, 20 Nov 2025 15:25:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] mm/khugepaged: map dirty/writeback pages failures
 to EAGAIN
To: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-10-shivankg@amd.com>
 <6c1d6b80-d290-4110-9a49-53e7404136bc@arm.com>
 <33476cb4-318b-49db-9cc1-a354eca9e883@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <33476cb4-318b-49db-9cc1-a354eca9e883@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 945B7C0011
X-Stat-Signature: w7iwdnggw49yqogmqz7i3tg3o41i55jr
X-Rspam-User: 
X-HE-Tag: 1763632567-800391
X-HE-Meta: U2FsdGVkX18eHr+4LJEV6/78z42cpfvcURc5qu/h9qwW+44zkTG/fXAwIhp7fE9p2ocv8VrqeeQW5BFkofaO0NmsajmJTlhUhyG0y+Cli46Y2FErN/x8bsJCfoD5/kZELsaC2JP2Ki9bEPNNSnHf9gEP2ILUnqVSgZ552Fp8ijWG7XtDspdcSW7FCXrsSJuxmZjouUMPcamXu3+DMydVmeqW4BLMKCwoeokza5TtvbhEGXOnPECbx5FJMtisE2UKFV8whKbGcKKSP17FmLo8XPN1OxaWbOL9kXicUSH5ISJwCdnk3DQ7n/9LIeSeg1zhVOx3Pt7R2lIgHRhOPiUdkwuQ3WjelhgHe3bqHpK9cge5qGiYTlQAe1yrDpd++FFHlGbaArDzp0xT95T7Sy5LNozx2QAyUe4mTKz7yav3I8cuCSXvIJu9OmnKeB8Jeyfw9uawMEp3LT50cN8f4b5NsPfHydG6mgY6WRwJPv0luyfBuJnc8gsIZZ982KsIZlbx2R/lGtqXgbRuWVWeOxmWtcojO/0f3YW4tJZ/x4D9QgwDUHUSLLFKiixHwqvI7DEXxUbuj5rnSGhKYAfQ4WHwTCJyxq7XdoFnS2vv6LkskHhQ+AOI7fg3IUfVLIQtQykfSVJj1z2uE7HWksUN7t0oZbZKDp9rhZGZjPIooefzPYfljd0rFwzSzhbjAcGLm8miYSB27g8s8YXe7y239zoe0zWAWIsWA3nSmwJbgeTb2WILxW+VRQ/DvNW0qZg8CxBKFjQaTU+BVZNS7M1jL5L4GaI0Dz1xgH5uMk5NpWwYv8c1T1jbQ4pnnFtY0tqLQ+l1hfntxslyhkWA01wpDf/NwNgi4aIQhmLocCgRQxiqqxveb96P6/CVKbdvN/+zJrRshlxBtaOkTpUWN/epekG5hvimSS0eRulBVe3lJJwztQSufIlFflA1PVRk/aGaMe7KJZp+YbQ6gwMoplFICFu
 5ZIoNeeR
 vHgv1BzCryzWpbJqJon/PKcraLVTLzwIC6DHrfXh7P1ibEuEno3jEQIO167eOKs+wXhHFEvmZ2A6hdv47BFdqAsW+s5oACckMR81sVgblsT8ADgCgP/iRa40vEolpm8p6uoWNWzrhGI5RuhSVLOAfhgDqzECOqwVaNwK/mDFxcZExgcTlyOEs82U/c6ASO1qqP8xofUne+xwawmVdIOGcblk5K/oSd7rqnQGu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20/11/25 1:47 pm, Garg, Shivank wrote:
>
> On 11/20/2025 1:33 PM, Dev Jain wrote:
>> On 20/11/25 12:20 pm, Shivank Garg wrote:
>> SCAN_PAGE_NOT_CLEAN is confusing - NOT_CLEAN literally means dirty, so why not SCAN_PAGE_DIRTY?
>> Or SCAN_PAGE_DIRTY_OR_UNDER_WRITEBACK? Since folio_test_writeback() is true as a result of
>> the folio being dirty, maybe just SCAN_PAGE_DIRTY can do.
>>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>
> Thanks for the review.
>
> I chose not to use SCAN_PAGE_DIRTY because dirty and writeback have different meanings[1]:
>
>      Dirty: Memory that is waiting to be written back to disk
> Writeback: Memory that is actively being written back to disk
>
> [1] https://www.kernel.org/doc/Documentation/filesystems/proc.txt
>
> IIUC, a page under writeback is no longer dirty, so using SCAN_PAGE_DIRTY would be misleading
> for pages in the writeback state.
>
> I considered SCAN_PAGE_DIRTY_OR_WRITEBACK initially but felt it was too long.
>
> SCAN_PAGE_NOT_CLEAN covers both states that indicate the page is not in a clean/stable
> state suitable for collapse.
>
> [1] https://www.kernel.org/doc/Documentation/filesystems/proc.txt

Alright, makes sense.

>
> Thanks,
> Shivank

