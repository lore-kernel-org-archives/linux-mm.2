Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E43CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4715B6B008A; Wed, 14 Oct 2026 11:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422886B0092; Wed, 14 Oct 2026 11:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338676B009B; Wed, 14 Oct 2026 11:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00C1B6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:22:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FB4E1A05A5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:22:49 +0000 (UTC)
X-FDA: 85321599258.27.C776374
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id ABB51140008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:22:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JF2RXRnO;
	spf=pass (imf09.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791991367;
	b=eQOpkcWfw9xfupMiir2JGph3glB5BWeZccKIccrBYnqJXRMJUzN4q9jlAFitvFEwsBUsvf
	rQERSrm6S5Bt/qjGzAhQ3zv0vF4R4GebRtfKLfjNQ69614kYQ5IebBPBzhIR2sNI7V9V7f
	reOVxkxvKnS2k+VneJWSSTW2kaxd9Ko=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JF2RXRnO;
	spf=pass (imf09.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791991367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4/KILe9h6AG65fvMrS3TzrPnhmDDErK68zn/OTZ/DY=;
	b=CPD02XWowH8uaD/JGm8yhgfoFuKWOT1wDJsV9J2VRU+BGR/uNjmZnE+F7VzBP58gV2fKLw
	6rleVNmS64wfvbwEGt+X2E1VqjGhzVBjIUQMjr+YrP/eSFkTmpV7/dH9jb9gmVJKdHlgkw
	+j5kbCiI/5DgITwSXouM0BmFCxbRsqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE10D42E58;
	Wed, 14 Oct 2026 15:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2F31F000C4;
	Wed, 14 Oct 2026 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791991366;
	bh=z4/KILe9h6AG65fvMrS3TzrPnhmDDErK68zn/OTZ/DY=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=JF2RXRnOGOF9KlVthYBoCYRl108o9cSB4waUMUnVVRyDfmlN72nuxyg3aLcSU6tLs
	 JGcq48E8drHDplsNvn9c2uns7JAb15bDbCGcRY5huhnxMsIkf84tY5YwBp2oLDXwQJ
	 g2zrxmxSTF5CbvXzr4C0CJ57g4SiFPOsaeBwf54MYCpn4d8SYfbSymoEC29hrtTo9s
	 upAIzSb1wZWm0W8pau7PJjA6iRmIvpEAaoCkM8x44UMEqqKe+gWhaaMB/ZSJSWuPQK
	 9xs9gQO9VQYA9vEgFiIKQ3Z8Lew7pyKzCnt/b9ZNiqK6SjyY8F2dtZf3VEAFycnl6t
	 oQp58CjlyzjKg==
Date: Wed, 14 Oct 2026 17:21:41 +0200 (CEST)
From: Imre Kaloz <kaloz@kernel.org>
To: Harry Yoo <harry@kernel.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, Jann Horn <jannh@google.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in
 kmem_cache_destroy()
In-Reply-To: <as96u-sh8BbjXW24@thinkstation>
Message-ID: <d1579925-2067-5a7d-8f30-fd56ccf89c26@kernel.org>
References: <20260930195110.13296-1-kaloz@kernel.org> <ar5pESlkEMqNsgxv@thinkstation> <aef97b97-0bd7-d720-7f59-8c0078747370@kernel.org> <as4QhUscRVtBzYpm@thinkstation> <481e9a16-cd30-d463-14ee-b5602bcd5a21@kernel.org> <as4q2WlR7mLhMBpG@thinkstation>
 <e4184209-75ee-929d-0103-ca15d5886000@kernel.org> <as96u-sh8BbjXW24@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Stat-Signature: 6aqeyjyur4ebpejtzf8p71zzgngngd5u
X-Rspamd-Queue-Id: ABB51140008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791991367-9254
X-HE-Meta: U2FsdGVkX1/L5ZRp1ulhOOog1fdIYdGt7CAg2kErYESLXj7NQMICRZDSF8JyAMQ7Iu+YC0MFwEhsRbTY1HdFUA/Y5IEM27dY5VpKEr11hn6KRtspDeeRQHUZdMaOO6W3AkVH6v6pFoebSdVkFtZLWRQD//vpAclbTsbyW3fQDW85WzkPy5n+JAs9cwemKW02evGQVb8aBlbA6saxrhYZjFi+NuLcbr1dkYexbdC3fd2rewSz69nTJTpzOLkCgUSv4Fq+cEnAN68arH9jHE1I5+jF/SyAw54U8GySc/4euC1qm+HuU3VNn0s2Jx1aM08ZQfdEg89pDwV0zNnHZMB02MPWum7N66g7CHcs7w/HiHMjQTakc1L3M4YTDlQyM20V52mEz2RBrC2U+Vt9AARIa3h2raRtKaQLg3lkOLS/Io8wGqEYrYGZyKrzVUTJSmBSk28BCFm3JHrD3QXC3cywVo5ZPjCZSHLSclGsT9ZMKXd1XGp1ZjUfSdo+cFoyFgyW3jhKlNJPMp/uNecrlA05XocM9lt4mzSK+HvzCDNWWHWNoTYcDzYiRSNoXtvemPBsozGE3uWy2hyqUIV9zd3ICeBYkd0cF2yFmptUDEAjkTKOR+XLfUGY+gGlSHFK4PB1XJyNrtQbynVwvc0es3vNnA24EGmVDyos/2G0E8lWGq5YG7B1kqsGchOfGGFkCZWTTPSmnMoIqMd3n9CE46Ttxr29c7++3ETid5EPgyd6eDAYPP2Yt1Y9Jehtlsrf5uC4hGa1fwEJecCfdxOOxUiiXh5uxJzXSbJCvBC02IgAHnouuOch0rkZnlwYGCr80LyEUfrSf5QgtUsOSsnXwwXKBqRdkPO83nHSE57ZAo5vmS5BnEBpeJMO2eZ/5a76eZBZ5ROMgKsxAOR7UbxRYxigeLUYaXoPWBEwEqG5HzzBhOG22qTPgjwx/R0Nb7FtiUrrEM7/sVhSdTRJda6ItWJ
 esupFT7c
 CjdyZz1gA6JxlDO/QeniSSgOBvxGT6yMiUOdudf5/jy0nVFAM+wx1qxv9uZs/RvynpIKICd5sUOy/uBqkbAPjfPZLQ7glTRmH2goWNezC/m0OfIUOdvSFAm6GjmjBDMAX3IVn+bh1s0RdSH0kbA9EuMjW1cXcazyz8pJO9gnXYhbSUNnN1UG4CbleGBe8/K0lY1C1HT60oq/gwLM6EkqaSYCZo4LwNnmMw1YzfcSB59vzPMZv9PJmig8QVAtLhXw2lS2QTIqxRpHyrSzGnk4JvVf7o4AQXPKXbxfHdkXwUHm4Nde8c6X19PB7QZWv5Q6sc0COUVt9gpdJBpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Wed, 14 Oct 2026, Harry Yoo wrote:

<snip>

>> So it takes both. The read that hurts is the one at release time,
>> after rcu_barrier(); fixing only the double read keeps it, and so
>> does moving only the unlink check under the mutex. Reading once
>> right after the unlock didn't trigger it, but that is still racy,
>> just a much smaller window.
>
> Thanks for verifying that.
>
>> For stable, as far as I can tell the release-side read has been
>> outside slab_mutex since d50d82faa0c9 ("slub: fix failure when we
>> delete and create a slab cache") in v4.18
>
> For SLAB_TYPESAFE_BY_RCU caches, yes.
> and others since 0495e337b703.
>
> I think Fixes: d50d82faa0c9 should be fine.
>
>> , so that would cover
>> 5.10.y. The patch doesn't apply before 6.12, so the older branches
>> need their own backports.
>
> Ack.
> Are you willing to backport it to -stable kernels as well?
>
> And could you please post v2 with updated Fixes: and the
> commit message ;)
>
> Thanks for fixing this!

Sure thing. v2 is out:
https://lore.kernel.org/all/20261014150844.8536-1-kaloz@kernel.org/

I'll send the backports for 6.6, 6.1, 5.15 and 5.10 once it's in
mainline; 6.12 and later should take it as is.


Best,
Imre

