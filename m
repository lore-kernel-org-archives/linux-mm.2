Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A9FF483E6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B79F96B0098; Mon, 23 Mar 2026 15:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B5E6B0099; Mon, 23 Mar 2026 15:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19D86B009D; Mon, 23 Mar 2026 15:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93A916B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:21:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 337238CE65
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:21:16 +0000 (UTC)
X-FDA: 84578296152.16.BE6A0DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53FE5180002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:21:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BHnDo3V1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774293674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vb3ms5vsxaSsQTht67MiVCsEEKAjN6/SNYTxDijfRHE=;
	b=CGTiMTNKLGFOnmTywbC0qFo54peSaQXAEoLM3ZeaAYNVWrPTPnw2oVqEMe//ZJ8xOsZ61i
	dtMGKhtPsGQVqjvZCQlLo/YaADFAwzI6KsxxgDo+QdQprKFDfMyyyU8KDphdV7LGEyhYgW
	aU0iv45VtOhZqOBS3o0FtWzbE8umtB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774293674; a=rsa-sha256;
	cv=none;
	b=M5mbCa7C1Wv09R036aHM8GuvUKljEMV/gtmVncwAfhaosScpgR99RU57o8e9AbpSGtIzOj
	3g7PUhs/puQZU5G+thx7PsgYQ1Jc4KevYeQvAw9hWV0QsDeGnTunbbTYwn1xsboSp+3xrS
	Z2VXFtj2iSUif9y67UzDKdnDE9a2MiU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BHnDo3V1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C2D31600AC;
	Mon, 23 Mar 2026 19:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B355C4CEF7;
	Mon, 23 Mar 2026 19:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774293673;
	bh=tdKdFKbM91ZHM5hoxdtYyB2IpV7KM8bm77NyUZQ3g+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BHnDo3V1pnM50r2hEN60NQabGFS/NixuoMcjZ3EQASKElML3Xn71XMMN5dCZnfe1j
	 0QfCtQ9InckIlWyqegThQG2whumBgXJZNX9SXNs4a4WsQy/Mcpio9/rNRBfL3R99V9
	 XJvjIiWTdwsRjnuuOejXnJn7xDeBE1N18yNJaJjBBT7sqmmzEM8jOXHewUAjb7vQrs
	 q2DUd/1j8qaVz8++eJ6yLnx2FchG57oxQvD3I6iNPx3rVm2DLaSBz7FlMTb2NRz+u9
	 bDvTVGot4BIZ7xqBhdkrPzP3CY96VVDKLwKeFazhmKSU7Co7viM/zlRCPnjxEt1xpl
	 TnYFEIxsEmqMQ==
Message-ID: <7095112e-465d-49bf-9cbd-98e6e6ad2aa0@kernel.org>
Date: Mon, 23 Mar 2026 20:21:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: rename PAGE_ migration flags to FOLIO_MF_
To: Matthew Wilcox <willy@infradead.org>
Cc: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260323141935.389232-3-shivankg@amd.com>
 <acFSTlF0epHIrA5v@casper.infradead.org>
 <a6f19c86-4c6a-48c8-9dc6-26f66bb6dd88@kernel.org>
 <acGNG1T-4UBdvgYB@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acGNG1T-4UBdvgYB@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 53FE5180002
X-Stat-Signature: sb14ezwy4gbqg1ufni1f7zoushk8p3ze
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774293674-424559
X-HE-Meta: U2FsdGVkX180hYLAkCNV0beToFtldIlwFL2gM6f/fy7OrRE4+dncghnbgZKgPblD+xcBWHsAUs2i8O0Bn+E+qet4t4p3QfbC8YmqQYV7WVw5Mmd6B0qIbrcMUBlUz5R+S+a78eZ9tXJ38VpKwFmLqBP1pqhyEucFL/mEoutZf101zMb0DlqziYUi6IGZlCFbBnxruPyInf2av2L+TDYToMtyjBU09hC+Vxf+C7hsnKYDq5M1ZP5DU1ud7IQN/3zgMMFoGHwObZp315lpfoOtD67QBmwDRKT5wjbu4FTKCl2p8FP24VCKEKy5c6sTvwpICMWPd3+h76WBUOyYLHarc/3JSXrdrSGmqecZYVTo4osLQ/nd0cUPn9kCPHI7l5hL33jRYVpPXzkTozWEFGmU75mv+E/5YtQA++ZZyw5HR/O/Gpllu2pAPG++b6EvSpf8/EFHKrw17I/EmmzVZjID8Nafs2nivdbsszds39Bt2c9hSUUwUGP1vOSLeE2cVXlTV0diCfSnoNX6KwLKy/KtMhK56zHgS2ZO8LZa7CxjVgh4K+sileQ6XRiQJCCnR2mCsJWWe6YhvVbuzzvla00mIJb8XMihzo4J+PecvaJEmMDVZPIId3E4LFvstVVohcHc4LnJ6yG95KzPSzulqhLKNRq84wMwVspQIWIrxLe+42ZWmhv1Z1Ui0h1oPl5yhButWVv9Rc01EXmfG25qgBuGbzwvFOKp/R7TUUveqZZaKLpE2cBbOb6xr6YyJDMl8oTYISmq0f6duPjktTV1N/LRhiNyGre/UsqRiaEe0dhgwMwX70UlplNMEwoNdjvl07bIiJr63gsya6HaKz4+GtwPWutwNnHq6XQoM8OtALyCmZEo71GM3x1vmHYXBiwEVZuLAEyDMiPaS/TREhOAIkXc6g3o2vn+zJFdd7FAAY/dZTniuAFBCuskJANWNiSR8kPME8JExH1MBmOw2cMfyRs
 7r3xx/Wg
 9D99V8BcXRn3duIAfRP7mAP/hz1OjcKg+P//+ic9i6lf8z5APTABcP+Wi1bHbshrk4N5RDqLakT62WvdAnrS3SxYjeRutwLmXvlMwRX2vN5wIZFW0UzJWhqj9yq4a7SAFHtr7U0Jwflm0Qyw4+S1WQ1GbysQefWR13SggIC/DOIkRzI/vKN8Jk/ueNMmz5skjJtNq9OrIazI8YKUAX8ZLqehd5tqj6c2mVm5ralADeXnmCE4wz/zPJXUm5xcK4JI8q2anBM+Nw9doHjFEkqEKCqMIEfQkRdO00qmPsmhfPF5kGXgFIF2EsBqX38IaxG8x5GrHLLNc1LQodbiwPalm0jOuZSE6JCbO4fwDcU0xuAbJYrDwvYOPnUF5mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 19:57, Matthew Wilcox wrote:
> On Mon, Mar 23, 2026 at 04:36:38PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/23/26 15:46, Matthew Wilcox wrote:
>>>
>>> I mean, this doesn't make sense any more.  PAGE_WAS_MLOCKED is a
>>> sentence that means something.  FOLIO_MF_WAS_MLOCKED doesn't ... unless
>>> you imagine Samuel L Jackson saying it ...
>>
>> :)
>>
>> PAGE_WAS_MLOCKED was suboptimal given that the names overlap with things
>> like PAGE_SHARED or even PAGE_IS_PRESENT.
> 
> PAGE_SHARED (and friends) are misnamed because really they're PTE flags,
> not page flags.  Then PAGE_IS_* form a namespace for pagemap, which I
> think is fine.  These are PAGE_WAS, so a distinct namespace already.
> 
>> So using some prefix to indicate that these flag belong logically
>> together makes sense. Even if it's not a beautiful sentence.
> 
> FOLIO_WAS_ seems like a fine namespace.  Especially since it's local to
> this file.

Right, given that it's local to the file that's ok.

-- 
Cheers,

David

