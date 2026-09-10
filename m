Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25CFDC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7F36B009B; Thu, 10 Sep 2026 07:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3325F6B009D; Thu, 10 Sep 2026 07:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221916B009E; Thu, 10 Sep 2026 07:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00CC96B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:27:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DF7B8046B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:27:52 +0000 (UTC)
X-FDA: 85197627984.17.A6777C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC3D118000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:27:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b/MmH0Mb";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATDlBATG1qEL2oWhkdQFJlTR9e+n96ueHFzNCgfx3PU=;
	b=U48TAN2RFv4todKIXOZx4u4jUVesH/pI4QxRkr4fb1WY7TmSEJyIVRXC7iAQzrQcmDTHNd
	y/ooizBGvkOOYc5x6c0WiMlfQHpVSkxFVtJ9mvuihbQGDwBvWv20A9VGv3azdJ5ixxSnmR
	CVReg+Dz8dJiLHCHfxTdGBheWlP2uS8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039670;
	b=CNjxTPKojaFLP+uP06qZRCA1gvCYThxnOiBAYs69YCqq0Jez+w3DFkLUpLPzQbO/uasnWs
	BIVGI8+C0sh1UK2lFRNcj3MbkmVHTzLpF8gl7EFDA36jBV2wpEFefCIMHWxNx4kGIYlFjr
	CWgQa77xAoeN9TJ9vaIjTYIwv46+a2g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b/MmH0Mb";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8C1743776;
	Thu, 10 Sep 2026 11:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF021F000FF;
	Thu, 10 Sep 2026 11:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039669;
	bh=ATDlBATG1qEL2oWhkdQFJlTR9e+n96ueHFzNCgfx3PU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b/MmH0MbS25rKr8FTMt/hbaSS68FmUzkhr+sCScLLsyImKAUhysNWMPucCukCC5Jk
	 cWq5OVGGT6FQfksq5gE4dhDWdtqqzriOVkWgx3f2BaevosGny6AvcLQx/ssfzjeldx
	 IYTkDsG0DWbH/cVfi65/GY8gsW8/Y7n16DIBBPUnxHiFsi13NIVkHZvKlcYcypjxE/
	 xuqkbi1AhYHjzO/F5O8I29C+DY/cbV4NVaCnUk/SNv/+9maSzj2vqbRHAlIXr6OW4I
	 +A52JWTSClb+kGQW8NE85KuqfCJj0KkVSPJpfpp99MdauqxeSp2qT+GUpRiXkUOwGl
	 rnKX1Vy4Z6WUQ==
Message-ID: <3aad90e1-5081-4f8d-803e-e9f593ce581d@kernel.org>
Date: Thu, 10 Sep 2026 13:27:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-2-822b810458bc@arm.com>
 <956df69d-8c0a-420f-889e-7df2842605dc@kernel.org>
 <aqKMVUDvN8bBpwVS@e129823.arm.com>
 <1968ed37-3836-44df-a266-9a37219c2f6f@kernel.org>
 <aqKTkkK0wnm6cqpX@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKTkkK0wnm6cqpX@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r5ed8jpasc8xjh14j7hshwy381q77591
X-Rspam-User: 
X-Rspamd-Queue-Id: BC3D118000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1789039670-380988
X-HE-Meta: U2FsdGVkX19ZsLPNWLCll73XVg/aryxLoxie8z+ZLM2YzXScXDp0Z3aQgjfxAWpWBueEmoMoXOubyLET/RFl1nVd20N11P6rDPh1ljGJmeHOxO2QktBYiJSxGvjkzgN08iYykwfif3qA+XxB30EvnAqJsEpxrsPeSGTyooIjpXMjUZEcXrsUQGvd/OvJsOgCLPEXk0PxpwpaLR+gduN+sEL0epyoAZqg1bkUOT4UGhQnhnEwSdhEMIr+xhG/jo8XZ7hzEzAH7vO1DWaX5dhA8pJo8Ob/3EzVyOxObBnJOz+7/3oSHBny1zavy8N4qGs/i1R+vYCmjWNvLQrYmRIAVPdUTGMDAj1YSLk1jRCHqhR0cBGAp/jAjx21UZKifrdmBmUlp5xxzB1qr4inJDBom/erFFTe9wMZp7Rd/RdOaXjD3vrI2qADMFPZLwwCDsS3+bsMW8S3QbrM36dR94fF8fDdUPS0Rzx2Bb2zvjNShv+RHsC1TgOQCQ3irPjqtP3SzC7uXKcp5v8rPOkSP0zr6K9E1Nb/41hG791gcgoKnHMPvPTV7QIP/Fhv9pKo+OATixOJFu4GFBaJIfl0C4TqVFC1SZVYj/o8p4Atd2Csu1alGAibyEs1lNfkhCzklRrYeW8xWQMn1P7pUj7LtmDzggI3VebYDP6vtKK4TNF2pPC+aooh/+dDGomxtr9mV48kavITUU13lq46nFbC9fwPP4WBQ9n2RhEf9v+RiNB1N/NezenfMlhEqFiBUYz+4UT7yYlGaBNtzoDJNcl0zS0FZ4gwX1U31y/JsFkZdMof8Mtbvv6YrQbVt/v3vlEcPCEslTHgTxUhfUpf5/+HWs0u+elPXHVEFOdEK5lZj8Sy9L02uFBDVpRvEaxSnqlHCtTmQMNhRDKmB677Ac/oNQg7v0YYXrYu1I/V17hJ5QQHjPCyyy66FYIxAFWEEeL+62tH4zPCr2xZxC8rHGbZzI+
 W657Eeu9
 0I3oF+CGu/0OknZLVsogWfbBG9B12dCotl/UKN55+MVi1+7+FU+QJL6K6+Y4e9m0ZfpL8XdYA+2As1Fo/8oDL4kvCPhJjJHRBk+ifKS48UVp+Dg1uH00Ecp7uOoVSuGsczaSqsJJb1/dQZdtDszFJQF2ld8VbQyP0/ROF/832JPD4obVq+H+chtEITpmOo93pxT+vLeWYNwrDJEI+FWdTDBAphAG32p9v3h0yr0xD85Vx7fb5XcFLG/TC/v6CGM7DT1OpcztwhJU9BAP7Ao4pTWW58FIXTgiiLZgNw150PWlnpKtc/lBtCksdrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 13:25, Yeoreum Yun wrote:
>> On 9/10/26 12:54, Yeoreum Yun wrote:
>>>
>>> Agree. but there seems the case where discern whethr the mapping is
>>> with regular file or shmem like tmpfs -- khugepaged test where using
>>> __shmem_ops. So I think it would be better to keep this as-is.
>>
>> Let's not add or maintain unnecessary complexity.
>>
>> hmem_check_huge can really just become check_huge_file.
>>
>> Even file_check_huge can just be simplified.
>>
>> There must be a pretty good reason why we'd want to keep this.
> 
> Okay. then I'll change the check_huge_shmem() to check_huge_file()
> with the separate patch.

You'll likely have to make both behave the same under the hood first to then
remove check_huge_shmem().

-- 
Cheers,

David

