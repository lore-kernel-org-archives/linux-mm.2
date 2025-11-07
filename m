Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EF0CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA8B8E0005; Thu,  6 Nov 2025 21:49:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1D08E0002; Thu,  6 Nov 2025 21:49:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FFB38E0005; Thu,  6 Nov 2025 21:49:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7278C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:49:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED63A13A92E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:49:08 +0000 (UTC)
X-FDA: 84082279176.04.E53B007
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2B58140004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:49:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AbFoeJjC;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762483747;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLze4zH1FqOa83VIJO3H028jGydkDjzGfG38iSG2nOE=;
	b=aRYWFJxQE+KC5UCNuhCP0slTsJVqZLs2fRhCSSFrTSqBGXoH8hXICgbUNg0/CctK2aGR/S
	JfWB2LiCZNiDD5ptYMOfKb0YVw/J1aRPva2eq3XiW7Q6jBBcNtrNkBmF+aWNRMJ4X3YTfq
	KpFv8u1gPojkiTHvoRyXHmSo4tDIszI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AbFoeJjC;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762483747; a=rsa-sha256;
	cv=none;
	b=1Ds8pB/i9MXJ8+Qyp1EhLbwFQAEu4FgueU/jZqogt1jyeIE/kBUXnUR+fhHX9bCX025ywq
	Unu4Z6dsZQzA7hjYTQs7Qs6wP5giFGlgowx7nxbXDXP4aaxH3LCbm8JLH1/VlQx5zREZIG
	boFLDEkhJjpAaE49xMp7ZlIMG7zpyNQ=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so536035a12.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 18:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762483745; x=1763088545; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLze4zH1FqOa83VIJO3H028jGydkDjzGfG38iSG2nOE=;
        b=AbFoeJjCb8semI6NOMWlOiAJRlqEU1E8gROujnXapKxrRvNMIoXYayUIPmJH/6DcKC
         ebdjI32NVcxywUAhrXcKNET9gDd3swmgnKysH44UQ48qxeSOMya+rsKnsoE9V+IOL6Uk
         I93aAx6SbXp+l/vjep7NjGQuSym13AdixKpgsFuVOzqkz+0xkw7SIS4NYfrMOJmXnW29
         ly5cFsSO+pB7I1xlAeQZsYtKnG55rneflPyesIz8wj+iwHIDtcGOVgb3cQtG3p4FtRDd
         HnbitqZ8jqgmraY4ghmqOi3yI4m037+2es/+zwM2y44Rcx6zFH4rCi2Oq9zUYXrFoyTB
         sE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762483745; x=1763088545;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lLze4zH1FqOa83VIJO3H028jGydkDjzGfG38iSG2nOE=;
        b=wWK/8UPojnciX47ioCAE00tXZt/vRc5UkwnziCK02PqIM9uYZQxJS2DN9rSpP9e/Qz
         DYA4Gt7UaZJo1FNHG3a8zhdTecbl6daJXPlj3KXWmz5rkbFT7+XhrJX4tPZxxbD6wbFt
         MkdVjSovnOmf7BJd7x18/Gz/pVCVxso+ue8W68wenqfWxiQ57yVnkbmOBR92eN/eUtui
         W08D9vzsxPmIpMkiu12oDEc2U8yMPLYugPpiRr117P2rYwiZtNTDy6ofrC4iczOak7xX
         TQ9lIe9nfJRmN1XUIom4D7XelAgSF6sszPvv4ZU/lYthp/MRUSV2QNIFUafJjFFn5WBo
         RUOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQKDrUE9aI7Uw5UxBaPNxZJLIVidbeEnxCP4HnsOj3ZAmob7Ddl7ZEbY1biY4LHdlZFg36aAsU2g==@kvack.org
X-Gm-Message-State: AOJu0YxZAufRLcquDKyaFbroYXtZWTGOUTjJWpoLN2Yjhhh+b0kVpxf4
	ADcMrjQUqDF1NQQ6RGKeN6yr3/5ArA+p4UDzFsSP7eu4h2TuupKsiKEB
X-Gm-Gg: ASbGnctGIzfdvAskw3/4svWnmeVmKtAYPEszfbWGeXrfP25fl8vlRyR5CQLur6bYXY4
	rqFGOSV5kxX2lS2ucqO5/MtqdGXmtQkXdnwQAieE+wKY9OOfWhHTR3ei/SuCAKzPUAudJqQ9ZcH
	r7LJ/d3SyzhiTz/mPYAzZRHB5nh3RdYbKbEz6RW1+rSrEi3TTw3GHOg9mJmRNVgEkFdAf46TrOd
	54aWUsxNHekKicSP/fpyDlvT5PVEQSgQjbqW8R3FquSRABInECVKPIuqiI2JwprudcySFtqmINn
	oKZp1PO11kNVGMT0qwomXW7gUbF7EtU2aC1tdM/qU2qw0Ud1OeKwqqHBF/PXnruv+dmUyfwhGzR
	XZRz+04iINN9Le17thN6kg/e+SeT+FdicYhE1kwJMfcWhMTnJURvzZ1N9Y0nW+884uNw3A9SvBK
	M=
X-Google-Smtp-Source: AGHT+IFXBEOh5UDOPeIFvOGlGdRRwQ1uiLh+096R6yivw9krnv8AP7LAQe/VTQD+QEgvN0a28ZsCmw==
X-Received: by 2002:a05:6402:210f:b0:640:9d56:50a7 with SMTP id 4fb4d7f45d1cf-6413f070524mr1457781a12.9.1762483745187;
        Thu, 06 Nov 2025 18:49:05 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f862cbesm3102203a12.31.2025.11.06.18.49.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Nov 2025 18:49:04 -0800 (PST)
Date: Fri, 7 Nov 2025 02:49:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251107024902.6qu5h6rsmwktzutm@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <0D94CF57-A9C9-4C01-A9E5-CE47AE3F10EB@nvidia.com>
 <20251107011721.ez6pile62o3vmjz3@master>
 <136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2B58140004
X-Stat-Signature: 648b7wwo366ujqywn1ucxmjctn9y1sdf
X-Rspam-User: 
X-HE-Tag: 1762483746-15070
X-HE-Meta: U2FsdGVkX189EnRV5Has4srh00KlJk9u4dWaz1FUXcRv7Yb/3y1xPOkccvILlHCwT7Q6sgnlTfztU6p7zD8UmFx4Zm50GXBC8IIEi2to/mS+t76N4yGJvGnjDT4gHFs9IUH08/RwF/dENqbdq3HxivVXFfx/256tIDWFCXbfBNkz6Y+aSO7vHU8Iiqyctsr/ZXmC/1RTIcMjPSAVJb7Ywm1jWC7iGG4qjokv8GeSr8FIEuQu/JZ2vIQLCJzOoLYCRROyADyex8wJ/7ScebrymBZkLroaZTSX/r9LRBwBr53miu/l9wNx6yTU83W6RvhvMP7NdC82WZaVZq/nHzMXevB6xKSG3iQ0gIPtJKoARD6UFKRurIRZjhtKwYSBa8u/2toF6dJacLoA/vwTZ4WSSnGh48akW15sVcCIgzYdzA/+8lEuFaBQD/KoMjInI/BH2fTdvy19RVwUu82MQco8b2tCcG1+va1vcEr/ejdCgmUQmLH7N4EQE8unQncKFeuO3c6BEHIwoRHTuGBZTP1UHZzqJEp2W3tpiLpPfZb56Eq7OaIz8Oke2Qi1hQO8D/JggT/47LrRter9+jzGzhWPhzd0BvgfxvhnlJbolU5wzC9nNTebX8PocYcqJl5GOJqshqZOq+x7cqFMd9AZOop9RxXKqdEcyPo3+YjrdAuousafLXpgxDNPg+HW+mH/ADn0fTJr72ATx1csJQJAvL9yY/4WVEoyHFvIcmo2j7D3SacI0etb5HZDxr+dvdETXEO+bJxbI7KQz8fkcuMMNn5V2wjB8nGaM1jpMsrLNE9azwF3x0xQ7PN1/eN1mE7KfYqWX2WyTqP9tyG7pWo58bPLsw80C2GBrf4jxkk3tz+WWWRs599vFz3j4ER0w5DsvvhX6Aes1kEfSgX6E8F7OBFJcwEkDOFjXz//WD43/ti+LZwvuDcZ8j/f6dB8kZWqxObv/2Xzftd0Scbz3JoUt8q
 R1FNrBDB
 N73agtGeSKC8KhJGB12OsCUy36+uqhuL2tHSYmPCju+kL+Xm4x0+XPAD+egOLy90HUwa7bVDvPc5+XCFz167R2Uo/GIccIVjH4oVhy1ffnZPHXv45EoNWwmFgqJnvN8Azz6hzU6ysU9Y+Hh091JfJkemG0JcbRq4bx12zgxKvBXB8N2t1iRVm9BpCRMR1LYyjLX4FXGJh59SIt7Z7MixQEgCbr4pyChIJV3XafL7pyoRbJ/Aq8vVrsprxf38n1xLaDJppBlVYuZyiWMF0YiM0Fww/7dcd3+++0L9O0U4+aLi1YuuawRL9BhyykAfwRdwqN/7rl2vIJO5khIevNxjunAowHPtPHMkUCeb7exzREsWEGqE6s2XxSuwpmZnL1Dg+I3ae9LVPmNG2O5QURAMxcu+xrXrH9nMqPJdbSJIoFHYnsmprcGm9DtIwArb6CX5apHANMMFAhw//4rl/KexX9gFN/BngtnrgHlQSzoBf/jBdQNITwXD5UhHo54YH43svy4fvqLKNrg/QBxsyZtx2b5Ux5oowFGO57C+LJkgkfE4pMEBtnnInoT1Rokc7TcIOmZpEfiVTFhHjpoUnBzOcrX3ZEMqXYw5kzsZJvU3DIfdN3/zliPwqyJtPYRN/i5mOmLlAt4RSQNcT+7JxWoJ3MDnqMt00EtIrmmRkaVzn6xFmQCTiUzvy2WZV/LV+rxcF9IAtRvKEITkr9D9MOvsBHr/rMUp2fDpPDEDPni83U7o2saUwx9ZjUKnZ08VEDkhhU7ZxI8jYF0phQyeexocTg1BHglZrAVe4ZYzQof/l48XjkvjNq13czppCFIzYCutU92jA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 09:07:22PM -0500, Zi Yan wrote:
>On 6 Nov 2025, at 20:17, Wei Yang wrote:
>
>> On Thu, Nov 06, 2025 at 07:46:14PM -0500, Zi Yan wrote:
>>> On 5 Nov 2025, at 22:41, Wei Yang wrote:
>>>
>>>> The functions uniform_split_supported() and
>>>> non_uniform_split_supported() share significantly similar logic.
>>>>
>>>> The only functional difference is that uniform_split_supported()
>>>> includes an additional check on the requested @new_order.
>>>>
>>>> The reason for this check comes from the following two aspects:
>>>>
>>>>   * some file system or swap cache just supports order-0 folio
>>>>   * the behavioral difference between uniform/non-uniform split
>>>>
>>>> The behavioral difference between uniform split and non-uniform:
>>>>
>>>>   * uniform split splits folio directly to @new_order
>>>>   * non-uniform split creates after-split folios with orders from
>>>>     folio_order(folio) - 1 to new_order.
>>>>
>>>> This means for non-uniform split or !new_order split we should check the
>>>> file system and swap cache respectively.
>>>>
>>>> This commit unifies the logic and merge the two functions into a single
>>>> combined helper, removing redundant code and simplifying the split
>>>> support checking mechanism.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>
>>>> ---
>>>> v3:
>>>>   * adjust to use split_type
>>>>   * rebase on Zi Yan fix lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
>>>> v2:
>>>>   * remove need_check
>>>>   * update comment
>>>>   * add more explanation in change log
>>>> ---
>>>>  include/linux/huge_mm.h |  8 ++---
>>>>  mm/huge_memory.c        | 71 +++++++++++++++++------------------------
>>>>  2 files changed, 33 insertions(+), 46 deletions(-)
>>>>
>>> LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>
>>
>> Hi, Zi
>>
>> I am thinking whether it is proper to move the check (new_order < min_order)
>> from __folio_split() to folio_split_supported(). So that we could bail out
>> early if file system couldn't split to new_order.
>>
>> Not sure you like it or not.
>
>It sounds reasonable. My only concern is that that might add another
>indentation to the else branch in folio_split_supported().
>
>You can send a patch, so we can see how it looks.
>

Here is what come up my mind.

If !CONFIG_READ_ONLY_THP_FOR_FS, we directly compare new_order and min_order.

If CONFIG_READ_ONLY_THP_FOR_FS, one thing I am not sure is for the khugepaged
collapsed THP. If its min_order is 0, it looks we can cover it with following
check.

Look forward your insight.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dee416b3f6ed..ef05f246df73 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3704,8 +3704,8 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 		if (new_order == 1)
 			return false;
 	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
+		unsigned int min_order = mapping_min_folio_order(folio->mapping);
+		if (new_order < min_order) {
 			/*
 			 * We can always split a folio down to a single page
 			 * (new_order == 0) uniformly.
@@ -3827,7 +3827,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		}
 		mapping = NULL;
 	} else {
-		unsigned int min_order;
 		gfp_t gfp;
 
 		mapping = folio->mapping;
@@ -3843,12 +3842,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			goto out;
 		}
 
-		min_order = mapping_min_folio_order(folio->mapping);
-		if (new_order < min_order) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
 							GFP_RECLAIM_MASK);
 
-- 
Wei Yang
Help you, Help me

