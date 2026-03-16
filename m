Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D29F53D6D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06C16B0302; Mon, 16 Mar 2026 12:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7F26B0310; Mon, 16 Mar 2026 12:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3756B030E; Mon, 16 Mar 2026 12:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1896B030E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:23:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FDF08B310
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:23:24 +0000 (UTC)
X-FDA: 84552446328.01.A8A33F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8885FA0002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:23:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gd49k6HM;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773678202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ONIq2JqDxScjKx0oh4NouhcRwXFOR5vYwpzid0v2DE=;
	b=kxyYWmld6+UuRLVOfDZBEncB7iFvicAOLU3gyd8KXS46UU/so/fdw0ZNwCHWPcbV3mhkQx
	2XZftWNsDTdjjPeR5tj1NeJ2BERWj37mKfbTGRNj0K38Cmiawr8AyUQxyvU1t1SamaG+cv
	QQHr+x/NgVrFIc07mgTGJxnt5PSeNOM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gd49k6HM;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773678202; a=rsa-sha256;
	cv=none;
	b=wciYtOIujLyUg6EyYtwU9fie105lokU0Wc8Nh+LXMlEjW7Lz3xT1slP4B8XBg9Ern0JBpe
	8S8y/Ela1rfTqdIoIphCIxGmLRYaDhUfPiaI/l53zFOodIR2gg7N9rYL0mKxyrU6vZJxWL
	CY/+53h/F269+WNv4R1QCNYUvAfbTM8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E531660123;
	Mon, 16 Mar 2026 16:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BECEC19425;
	Mon, 16 Mar 2026 16:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773678201;
	bh=asNjBO76Amhl5nYiIDEn+MotDNaDx0SGtaf4hEltfT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gd49k6HM86HJOavNiYPbzwo4gVsgs2BU12luvHrMFjjNLPoEdN4VrwtaGEvbYPNNS
	 mY7JgPf8AleDXMyDWW7MZmU9dNtY1LrQ96+gACmj1foWn+Ilo/qHNT+UNO0w27AN1i
	 d+pJ1x7r1tmFsVBYGDDU6nBC83htBoG5zpsK3vU349J2SYn56M6puR8VXu0hUY0wLu
	 cVoF91ZyTJEaBuibZr48VTVBjX5HD+bd8ttJb+1B5lEcXXNQKISLPAi3hkmzXba9wK
	 vNMbB5hKG+Rt5vtBXhQKYlYYdkVfebwPXWkLTrE8Y9v3s4a/k7E5EI51OcPxnOFfLG
	 jAtePRbYx+ilw==
Message-ID: <6ada27e1-8f85-4b85-8c25-bc9207b2624d@kernel.org>
Date: Mon, 16 Mar 2026 17:23:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/2] Fix storing in XArray check_split tests
To: Ackerley Tng <ackerleytng@google.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: michael.roth@amd.com, dev.jain@arm.com, vannapurve@google.com,
 Zi Yan <ziy@nvidia.com>
References: <cover.1771831836.git.ackerleytng@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1771831836.git.ackerleytng@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8885FA0002
X-Stat-Signature: 57qwgdz1iqwd8unc78o5ikp37xshroxk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773678202-31590
X-HE-Meta: U2FsdGVkX18A7Q1SdcfJpMS7u6WxHXfiDrmxCfFrS4t9W++5kzCYN2Cuj7bu9JniQR5xGeAC/HcNI226c9d0UcGzMgec0qvOMQ03inXkjpkxQD7U4L1W2yfHndjPIE345VeEXpOYWebG2pFC6liA5m6Be4IbJcDQBhGbHkE6qLXMo6r18uScquuKOG5E/w6NIDB9joZ/YtDUs7V0cYzDpweU9+/rZI7Pmaba/odDAG8r2wnuQCuScwygCEytl49GLW/p8Hi7Os70wxSS3xKyivZ431zkSvwvoIxuHfmEIVl4mcg2f0b1RPLdlaaDHyTkgdx888gUvKLdvD2i/qDoYhU/Vjvz2EVyNANScJGujAE17q5jJ7bijobuNEQu+Mv+gubYVsD3JRZqELzaRDaTlK5p32jTVohV+zWqgBb86W52d/GAElth2Yq+yPFn13TDvDwuqfLdzNAOXYr+txnVXLbuMi/CT/7j9p6i3fEec3eZ9GU6DEi9//tstsBTz0Xde/HMtxrD6BBNbcucyviwAuh1OHfX9MQ/ogCsLCbZc9fJqfhbcACOdAhkDyjXGYF1RiElXrmod9qAoJjyshhO2m9cMjH96gwqog0085OMgt3AAZ+VsydMV5a8k5VlJVmgeJ7pnLftFmkWdKqkPevGUR02KRi9V7PR8l+TBo3QYxo+vV8rGYiGzlZS+cOfdiUXy8lV/ETECqGsJPBfDEq3XLum5b8kdDJbePtfV+MvA7QeQDIZJU5/Zxa7XLSctTwx2eM0R5Jbv2U8KGIct4XHdJfgY5VQMCb+hiwb/GKwTS7/nXu+++Kjb+Yfxy8RCRbVXooj8QpFpEYlu12ygP2TyE7oXrVwoBL5lkcTBq30F8ul095p9yLIivRBC7la1I9ICU9Bdt82irzQketCUztkC85FlL6ERZ9A6qyth6e/N40MG7t3coXt15CUbRBQzcFZ/kd85ilp3qo8e4GQajf
 1NQN1pzQ
 50fde3/kaN9RiBVv1LWh25g5/Tstle93dZcTHxAq9rkknqKOgNbipPKmEdJSMPxxflXsCNoetoDoMyq8zdB1AuoKAZA/0pKH6D2FIIIzWo+Cw0QhTli3oxsBmwwlEnSVd9EJs9il+0FSXU3JpUlo2TRpsIpOfA59Y5XmoLOC9Va2uWwcuqkivd6/VKP2bCrSNSsIHVnCZNcC+hcRKSuCB5snz+MxXRHwVqFWBgs9R6oVlACRFDlt0ZBtdTwjzB8ZcUTMwVey+7mwmKQhsKDGzAj9+LJl3rcP5lasP9e4pPzjbS/6Sm8s6iBGhyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 08:34, Ackerley Tng wrote:
> Hi,
> 
> I hit an assertion while making some modifications to
> lib/test_xarray.c [1] and I believe this is the fix.
> 
> In check_split, the tests split the XArray node and then store values
> after the split to verify that splitting worked. While storing and
> retrieval works as expected, the node's metadata, specifically
> node->nr_values, is not updated correctly.
> 
> This led to the assertion being hit in [1], since the storing process
> did not increment node->nr_values sufficiently, while the erasing
> process assumed the fully-incremented node->nr_values state.
> 
> Would like to check my understanding on these:
> 
> 1. In the multi-index xarray world, is node->nr_values definitely the
>    total number of values *and siblings* in the node?
> 
> 2. IIUC xas_store() has significantly different behavior when entry is
>    NULL vs non-NULL: when entry is NULL, xas_store() does not make
>    assumptions on the number of siblings and erases all the way till
>    the next non-sibling entry. This sounds fair to me, but it's also
>    kind of surprising that it is differently handled when entry is
>    non-NULL, where xas_store() respects xas->xa_sibs.
> 
> 3. If xas_store() is dependent on its caller to set up xas correctly
>    (also sounds fair), then there are places where xas_store() is
>    used, like replace_page_cache_folio() or
>    migrate_huge_page_move_mapping(), where xas is set up assuming 0
>    order pages. Are those buggy?

Zi, do you have any familiarity with that code and could help?

Thanks!

-- 
Cheers,

David

