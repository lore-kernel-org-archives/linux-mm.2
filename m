Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A445AC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B248D6B0088; Thu, 27 Aug 2026 03:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD56E6B008A; Thu, 27 Aug 2026 03:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E4B6B008C; Thu, 27 Aug 2026 03:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9066B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:49:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0344BA3537
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:49:25 +0000 (UTC)
X-FDA: 85146274332.02.659092C
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2310E100002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:49:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=stX6ZJsE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787816964;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3S/MWtWQxmPsA3rkRg784EMwbcHhjCKBevLh/6T/ZE=;
	b=ZsbKGtcBl2tdknqqHB+3wMlnw3Bcx/id5VF9b6rC1Y6NJpFMgQnxo56GAlttA7vtZmaiur
	h+ZZhxFEK6NCKZWFMkqWA/iXgQuTHZIXpCMK+buP5k/Jfziogzhdw6IKUEXfzIrqmAFZuP
	6mefg9Qm0JHBYf9hOE5xuYy7RtjCgS0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=stX6ZJsE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787816964;
	b=zxkirurSisNBHcP/N4j3G6/Hs1rwsX/SI4GayAfhsbBmLEgZLUCxDz/mRHKZkSdUy06J84
	8YEWw0HzK2kF/sEjhiRsRB164+h1Zr2CpOLdMocOtVuSE2RNdTOtSRmV2L7Ayih+Jt3Vai
	zIGzXdSpfFN8pCRV8hcn3honTaOzPlk=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c20ce3c118aso151825666b.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787816963; x=1788421763; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i3S/MWtWQxmPsA3rkRg784EMwbcHhjCKBevLh/6T/ZE=;
        b=stX6ZJsEDWE3pMCdEWXlfqcD1lMqFB9Jqnvsq3Vr4EMBTsr9hv2vDdjtfcbP7CcM2A
         6QMSPDSZO90KV4sTrLEFaT7dgvwGUgfj9FCqOl5CC8mRiYwXbsyiYS6N0pJvmfpUNhNl
         5tT7Ba5oTTtgaA4WVVu/7fRCj44oO4WWcJ+sjbf+WoKoYgcCC4RYMLKJ8sYpjO28lCJX
         A1sl5wkKUpFXPjzvMgTJ/k3GeB+JJIsnMDxj029kAzwLeWoYhSVjuw4ZUsRYv54KcPKL
         fAe5E+q76G4iKBxP0++TGh0UM8ekabpfnx0WRPLzLUkdFBjt7wNkbwpUHOkgkoeUQvWc
         Ck5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787816963; x=1788421763;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=i3S/MWtWQxmPsA3rkRg784EMwbcHhjCKBevLh/6T/ZE=;
        b=IxpPV0Ywi1zYuhJEXxA0GAFf23cJS202XVzh1U9ML7dBb/yj6UIrsJHqd4/qeWqlI1
         RKY7SuAqhFP0+1A/2QS8Ja1G1XpRg3rTOtA+kN+62xakmlGs8mtZXw/y/fdmGpt2qmuZ
         5jE6TpWzqKR2fbk4YiWP3iZ+A7x0xpYpmYWUPasYQt5XZF80Z5h3GtuvyMUWWkJGXNGs
         Ux59anQxB0pSx7RBW+Uyr+C0Jcpv2AUg+ymvzDYtCcdrW3v6IMEqilHpeSbsnn0xLiHx
         oR4FLORTra7ehHuJJdAexx1ui/BIpTBAzdn/sDNiIF68YnhZ10yR2zhkDZFz+JGu/c6S
         21Ew==
X-Forwarded-Encrypted: i=1; AHgh+Rp3PRcpCd8L2HgFf4efWn/KjexEou7IR+xYjixjfbWfhaS6qOcjrU03BZhOWNdIIoU1JLDs9hnL8Q==@kvack.org
X-Gm-Message-State: AFuF++mx16Nb1JRBLc48OB4xnyhtK9jJW2tTWkTihNjaac2YHoVrvYA0
	iszyLcK2xxkhk2hzFAc1latLgjzkmkWn/hd820nCR1JB42WF55jeBmyL
X-Gm-Gg: AR+sD10BktmDYr7gxPDJxZz+xRBe0POBIg5o60GEr5tc4zuhRF1xyUiPuTzNKhSj8ii
	X99zxYkigX8vA5SnFGGhpLFpoAcfw2dYsNBkX1a6VZATE7+jEEcSNiHkFcC+Srtxqus366HTbw8
	7W5XlyM5tMat6Iu77QZ0YZuFRHxiKrp767nngkmPAohCgimw81ueUBdF1CVA49+B+/KieNfdJpA
	T/svugiT1+aCv3OtvnpqhzQn0VeyVSH6YQS3HHgEQ5Wjtnbc9WlfWEh7p3Bvzndd4en9Cc781b1
	9x0/qwdMjLCKg70HdCv56SMtfdKCINZshsXIUDjNdTl372LcqdajNHG2zfOF6RB0lluBCA+CzXX
	jZHU02FGqzD6KSQzdjRWSqa21vQCJ7JD3woDxA0gVx7b12MHL4dD7JpipT8lPPk6ujyaxKdLHG5
	Z7huGSKwAUN+93kd64bNojdZDkTxRStITycj9q7Bg2la2sQOaEpNum7ca4LYw=
X-Received: by 2002:a17:907:9447:b0:c1c:4c72:e6df with SMTP id a640c23a62f3a-c2535b81008mr338811666b.0.1787816962340;
        Thu, 27 Aug 2026 00:49:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a9ef996sm824805966b.62.2026.08.27.00.49.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Aug 2026 00:49:21 -0700 (PDT)
Date: Thu, 27 Aug 2026 07:49:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Baokun Li <libaokun1@huawei.com>
Subject: Re: [PATCH] mm: remove out-dated document of __GFP_NOFAIL
Message-ID: <20260827074921.mracnqv2m2cugasb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260827030548.16631-1-richard.weiyang@gmail.com>
 <cbc344a4-77b7-4282-9bdd-004822642ab5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbc344a4-77b7-4282-9bdd-004822642ab5@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2310E100002
X-Stat-Signature: dxczmabpfz7w1fwcy1kymqtjbt15h4ho
X-Rspam-User: 
X-HE-Tag: 1787816964-867116
X-HE-Meta: U2FsdGVkX1/CRX8MEqmFqiZLlJ+6aUPb20PZ7bj7zzzPrdMyfYCdHIO97tBVVhXo5oQ1KCXXq+IEfED8vjpvYrzqesn2QM/2/ststxgAkejzpSxCLh5iYtIATX0y7KUU9GCRCMN+2f8OhhIYXlTDGFUIcO//Aj2DRV7xH8E51lRtv6XPTVo/tAiFNPeLBHCCwWwlKGIvFdVt1xrhppvXFknMJl2n2A+VALxAPVxNYF2Hs6J+UdkgC60NEpqRalbET1AvwYuuj5gxTbre5qYzWuFD7F3QscFonYNQ9HwjKbacOWURJ91IOO/JX3EFK4mto55txW7N6MMW6a4ZVlK2svKRSkIjbAPKniTOz/W4aw9VQnoG6bAcvezy25KpZV/ziEbdfCUSQxQ8C4AkKJ0/DCPBqydv8rJBixE9raMFGsfRFqI7QFizjymTvN+lJzrmG0eRGC4rTm/hiyJQ+qtHUZ7FkxjyBWvWgXGOA6+UJPNreWD2Y2w1TjSGSKM/IFhTKWip04/VyQxSPi3XFOIldxgbY7DKtwVaIoiuTV9E2N4DOrOaIopBMY2QZhdSyl7RfeR4zQOFP/EwlwWTKA0Z4dOVfp3qzRwSx4h2dp5eV1pIUow56qsj++Aw6KPUxSCf05cXeHwxsUY/qGETGQ2O9CgPCVba5TUhtVQ6L2KlhNyF3DwDAYjKvGjxFjN848i0yzWDJ6AZWfGiYvEmua4MicGPCSSbSbq3afZt8tV6HfiH64bTe8LamyKOgXkkjYiTkB5fK414INwzFtGiqyAuhkfesF26KQJAKrkIXwn6sJ7nExbOogsl9amx8SSccC2ZtIim47wBKQgBB0Qu0hi7YRFoORuNrg3HpM7aremyQcuTMCPSXjGQMIRGNqmwJqkNDtTJoNEll83xwmzKMD3RWEZYYWTaQBlQZ3ZKnRPMIHnXcZVv/0A3vGMDHOo3/Oj5C71vW7ibyQ438JRVisB
 7gUbmW59
 9DnQK9YZORW3Zs2VOIcpI2PQpRlC8eynHe6/Hn5Zb7FFKyWH5jNBC+L5+nstCgs3IrYvUkcVe+T1ksSvuH/DDjAJmTLOiFOOYmqMqqE/fsz02fOitnk5Vh7p7y5ZOaKrGJej+8AegNy1eKecC6dMyX7kG/qgXlLGfvUO5Grst2HFc7F4v3fV3aBrmBhwKNxV7C68fqT5gh+smhH+A4sHZMD3KGttkbeNRQS9VqMlfY+CtECzwAZPwCrA5AXZlQ8xA1N3ter9shdhTGShZ9074cR5CyLhauP3/u43S33t7p/QX3sWF6/ghJavLQ9Ff1AmOR36U4rEpD09HMWXHuWZOuF7r5blPqSw3nWaD5RQRB+pTiyRdQYhZHzpaWh7EEF3W3LlB0MflghPdABzG0vadvFPRTyWKkylUXrXwOpMdqHD/gVrkxifdmACzdl/qFgjNNCVQpo23Zgv3uFZSZY9SA/uNo2txYM1dr2fR2Sk4+zXynND1KLwELuaEZGxl/8dNxTHyZY0elUfGrBiVNcfUceVEM0BfQXs8HSgCDTaJbmcR9i7KInrZF+UI2wzGPdbBK6oSE3nxgk/RQeOpAO8HtBqkipWNt/hiC03160Co3RdzczakvHoRCSiGElPNBufY9e+CQ0h0IDavT4tY/dcCulOdsCCtB1MM+GJtIB6nmZOAWY5gR9OYVeoLpxi8WQ7bGMfnvQC59M15T9BV6KF3ZsQ0B1SQ+XU5AsysaEXEMSNdkcnOadVkPdaVxLlEgBIrwtYrKdE/pkcv6pznk5j6UlfGeynYDESZjCwnAG6eym0f55qaCpILZMOQqkp9GNY3ornw/+a6EFgvtEJNR3yIH9hNlTqa1VNH/ACo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 09:35:26AM +0200, Vlastimil Babka (SUSE) wrote:
>On 8/27/26 5:05 AM, Wei Yang wrote:
>> Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
>> with __GFP_NOFAIL") remove a warning on allocating large folio with
>> __GFP_NOFAIL, which is adjusted by commit 903edea6c53f ("mm: warn about
>> illegal __GFP_NOFAIL usage in a more appropriate location and manner").
>
>"which is adjusted by commit" sounds as 903edea6c53f came later than
>ee040cbd6e48, but it's the opposite. Maybe say "which was placed there"?
>

Got it.

>> While in that commit, it also documented this behavior which is
>> out-dated now.
>> 
>> Adjust the document to align to current code, and adjust the comment
>> while at it.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Baokun Li <libaokun1@huawei.com>
>> ---
>>  include/linux/gfp_types.h | 2 --
>>  mm/page_alloc.c           | 2 +-
>>  2 files changed, 1 insertion(+), 3 deletions(-)
>> 
>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>> index 190191411009..24fde8eb73df 100644
>> --- a/include/linux/gfp_types.h
>> +++ b/include/linux/gfp_types.h
>> @@ -243,8 +243,6 @@ enum {
>>   * used only when there is no reasonable failure policy) but it is
>>   * definitely preferable to use the flag rather than opencode endless
>>   * loop around allocator.
>> - * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
>> - * not supported. Please consider using kvmalloc() instead.
>
>I'm not sure if we want to simply remove the lines, or rather say it's
>discouraged (instead of not supported) and still suggest kvmalloc() if
>possible.
>

Reasonable.

As mentioned in [1], kvmalloc() maybe not suitable for some cases, I would
suggest below change.

 * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
 * discouraged. Please consider using kvmalloc() instead if possible.

Or, you prefer only s/supported/discouraged/ ?

[1]: https://lore.kernel.org/all/aQTHMI3t5mNXp0M1@casper.infradead.org

>>   */
>>  #define __GFP_IO	((__force gfp_t)___GFP_IO)
>>  #define __GFP_FS	((__force gfp_t)___GFP_FS)
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index ab385bc252cc..146f7e0a9462 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  
>>  	if (unlikely(nofail)) {
>>  		/*
>> -		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>> +		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>>  		 * otherwise, we may result in lockup.
>>  		 */
>>  		WARN_ON_ONCE(!can_direct_reclaim);

-- 
Wei Yang
Help you, Help me

