Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03434FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D1F6B0093; Wed, 29 Apr 2026 10:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E576B0096; Wed, 29 Apr 2026 10:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343F56B0098; Wed, 29 Apr 2026 10:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2337D6B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:40:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95EA61A00C5
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:40:39 +0000 (UTC)
X-FDA: 84711854598.26.EA561E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 97DFC80014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:40:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PT7fNisg;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yg3P905DJmrWPLF6teCd9QYZP+fuDXdtPsB663myHXU=;
	b=Ffn7gdBk58V11c2EbFAaaaFrjIDDvyt+y1WyPzgE/Mx44Msx0UkW6a5DFeC6c0lif/klcC
	lpOszioGMqk54bS9kGEtch1T3u7q5uGH13ssKFBdlvbGfp6BCTVfY0SjMQwXY8L8mSTbK8
	Km0tIE/ZjyTBenoichDrDcm1kJ0G3r4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473637; a=rsa-sha256;
	cv=none;
	b=i171FNyfrVMZU2doDiDmjhdQoHqf2wRfMY1C9kr+4BvIZjeWVAEwZXxE10LjAyderpJgac
	6v663jF8/lxXBUfmh5r+db/MEw3joxdiXUL5o6jdm/VJZ79arsskIbAHfswYojXgxfT3i4
	7mON21CG9E77QLrnuIFUqZZm8kSWhjc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PT7fNisg;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69B4E40A1A;
	Wed, 29 Apr 2026 14:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D200EC19425;
	Wed, 29 Apr 2026 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777473636;
	bh=TpGwJcYj+6XBZyxmMOS7BWdtqilX7jFLEjuPIRCbrWU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PT7fNisghbGkV2E0eOjvhLTYToAx/YhsPNvuhceXEyQempy0KPL+oBWgiyzyG3TCL
	 fjEEfBzUuUE4t8kD1wlr0ja8C01RcYkezsMXpzCrXn7AyUbgC2JNVN79uMn5io/FlP
	 W8cdM0g6U+uAemBKJPbCn9459uuyR2O0s3M88pdax/OdSD0OLxGgbcq1uUwImG7jB9
	 OEoZaRCkjmeVWAbxRSYIdZfMeduljQimmPqVr+cFwbkYy76wTojEqbtH9tJsYkgGdT
	 khgTQEFm6RBO30SVMi21RgXD/yPmskpHUrM/ClP0eTC4mnEuogpZbb/D8nHgio9hRS
	 lhmBT5uPgIxqA==
Message-ID: <aee7e8ca-f579-47a1-8778-6a25ab92ff1b@kernel.org>
Date: Wed, 29 Apr 2026 16:40:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: return -EAGAIN for SCAN_PAGE_HAS_PRIVATE
 in MADV_COLLAPSE
To: Dev Jain <dev.jain@arm.com>, Vineet Agarwal
 <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org, ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev
References: <20260429140434.439456-1-agarwal.vineet2006@gmail.com>
 <70b44146-4549-479f-8d31-b40a8e747c60@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <70b44146-4549-479f-8d31-b40a8e747c60@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97DFC80014
X-Rspam-User: 
X-Stat-Signature: cqnipdjwwjzhiyjpj3y9383posbs4sif
X-HE-Tag: 1777473637-689712
X-HE-Meta: U2FsdGVkX1+6KhboTXpsD56Vm3NLziJVjuqDVVUoHL0Z6dxrfgfEEa47GcFEznPIW0njprA1zu1Z4YcgNFgFieA/goK7NDk8ZHeBUwfMvn9Hb8Q7Nlf4bos+WoULfdW3qGsZ7+trEZW9zrzk0EDjrrT3BJDf9MvfM+MpWWjCy70UkrEWm8epS3vK256cdp/t/DYp/iRwk4n2E9ZkTTX9UvjFCNbSMwfZ9s1ZXAeAfCXHpNjkgDrsZeDytV9FktjLCrB7NaLLiDYZEwFDtBrAELG3in0s58KuwDChJL2yEVAtxHfdVO6ZXPxxx1UgOSWTDkIN+1zWNMEeZLJnFBjgo9IgmSqh5nqBQIgNy6+2uO/l31JssDWfC69xBwWA9wdpwA+ohEXH4PtTnlPqpzLqzIYzh8ctLLegBDDi11duOlc9I+Ucv5Q/VQfcN0dWkp7mEpDi6RP9ihC2FBoFdypq+IGurgmovum22kYiFXJXs2wBjMULDK7mQ/7Ati9rpyPTG0KdRU57PZ79rOL23mWgpb8q5hJb2Fd4H4pBB2iYXtMfDgJKtVHnxsXwyoHJTljyBWqxUon2SaSAZcvShJgD5rLAZGKe1r82PmsX4Q+Npb8UqanJqj1tA0X1h0oX35MyFvy0nPzCBqUjYM7zjz4Jxz4aDkPHUcXHsr3DJi7nXRVhrrWeFpCBfUIL4yGulJAsllFUaOmWBB4yMUUtjgirCKPgtAoGNGYK7NByGsfA7pWab34P93YdutaEq0XPXSl0vYEjLtOgbqX4e53uQkV2NJZucwPt8+DW5F0JfAyjhs+RO5MkBXGBZ966y5wdQurvUfdB2UGe/WLcEuID+ObWm2W4n4kt3Iq/9kfLoszgPW+5gc4JDyw1LBcIkKHfPAxeZZbP2vWo/AYdcg6L+sGfJoSEmc0BVkVsUjehytlT2ZpurqC1pB9ZQTGXZxohBoS/RbktJusRlDt8IIc3Q/m
 Vv1iZPBn
 AWSu3qhVB1YtLY5UehNbV0wD83Nhp6cZnF+BfNJh3ne+e/saKKSKxv50llqHuL6ERjaQ6nRRKk6cGOh/DioMThLBItNtO4T8m4moS2hn4G2GaF79obDiXAGHMYJ8BgJ0c6s5Z/Bw62vcFQbQtQT5yxwK7hJHah00WOSWtp9jAsuBCZ7hQpaQahcIadsBzcYsiUjFrjzk3ONxAyTFc3+2sh8Vcs3BwSBhj46QrG0qhC1zSdE3hJrzwUbOJehJJdy1fwAz1fy8+z/Kj4/dsphrKXroT8UYcQuFnxLH+LAJWWFtUcZWSIp2N6yrHnMIUl79+KzlF7inK02DmecoWCyyueFbmVhVE6nvI3Xwn6AYiA1sP3F/9Y+O0gTpjohojq7GFHCcuamRHg/PH/vj2FSFlBaoHFp7gyv4+gc+AOdP5QqCndGDmjtP4/05jWc16bRLZPy9mGja1eyESyMWIrhLGHBPZxPtWwCcmqZj2MNM3IUdLRt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 16:20, Dev Jain wrote:
> 
> 
> On 29/04/26 7:34 pm, Vineet Agarwal wrote:
>> MADV_COLLAPSE uses errno values to provide actionable feedback to
>> userspace. Temporary resource constraints are mapped to -EAGAIN so the
>> caller may retry, while intrinsic failures of the specified range are
>> mapped to -EINVAL.
>>
>> collapse_file() returns SCAN_PAGE_HAS_PRIVATE when
>> filemap_release_folio() fails while isolating file-backed folios for
>> collapse. This currently falls through the default case in
>> madvise_collapse_errno() and is reported to userspace as -EINVAL.
>>
>> However, filemap_release_folio() failure commonly reflects temporary
>> folio state rather than a permanently uncollapsible range.
>>
>> For example, ext4 returns false when a folio still has dirty
>> journalled data, btrfs returns false for dirty or writeback folios
>> before extent state release, and NFS may return false while reclaiming
>> filesystem-private folio state.
>>
>> In such cases, retrying MADV_COLLAPSE after writeback, reclaim or
>> journal progress may succeed. This matches the existing -EAGAIN
>> handling for SCAN_PAGE_DIRTY_OR_WRITEBACK and other transient collapse
>> failures more closely than -EINVAL.
>>
>> Therefore, map SCAN_PAGE_HAS_PRIVATE to -EAGAIN so userspace receives
>> retryable feedback for this temporary failure path.
>>
>> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
>> ---
>>  mm/khugepaged.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b8452dbdb043..58f55115d7d8 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2808,6 +2808,7 @@ static int madvise_collapse_errno(enum scan_result r)
>>  	case SCAN_PAGE_LRU:
>>  	case SCAN_DEL_PAGE_LRU:
>>  	case SCAN_PAGE_FILLED:
>> +	case SCAN_PAGE_HAS_PRIVATE:
>>  	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
>>  		return -EAGAIN;
>>  	/*
> 
> https://lore.kernel.org/all/4ab54ae0-2607-443d-8698-788d8e951bdd@arm.com/
> 
> I had mentioned at that time, other error codes may fit the -EAGAIN
> (or something else) definition as well, for example, probably SCAN_TRUNCATED.

In folio_split(), we such events as a mixture of EAGAIN and EBUSY.
filemap_release_folio() errors are, for example, handles as EBUSY.

So in that regard, using EAGAIN here (as we don't use EBUSY) makes sense for
SCAN_PAGE_HAS_PRIVATE.

-- 
Cheers,

David

