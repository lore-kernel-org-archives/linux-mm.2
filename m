Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD87C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168636B0093; Mon, 20 Jul 2026 04:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118E06B0095; Mon, 20 Jul 2026 04:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008486B0096; Mon, 20 Jul 2026 04:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C23B96B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:19:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3727A140710
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:19:40 +0000 (UTC)
X-FDA: 85008456120.23.37A2120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5DDCFC0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:19:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4VTE8Pe;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784535578;
	b=mFTnRaW7VOcSfF/qEzD40xb6KoBW7fjZBxqj9kzf0eBxFRHr4VT7PuNothxW6dSd7pA3iF
	f94gsmsfa/xUCLWzQOqkYl3/wLYSwPr1ozciUAdciFMYlHhDcPFlkfCJBxzBFZhx8uQKBI
	uFxTjSdqZy/xHHfyj321AL0JgBW5PSI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4VTE8Pe;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784535578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoLP2PZBCzAZupYKucsii29TCW5clhqLZ4XvqzViVp8=;
	b=nN5lYCBwVF+vA5wMzbqfkTjr94H84FyyDuR2SJQncB5InC9rnkeSHiY6EHuGzgD8Dl2KHH
	jtpRg1qG6aZRurvKhOvdlgB/B550UD04tGLUsU30dUfnOi3YggsN0+JIZJ37tOVvf4UqHj
	OZT5v+IE0rm6sDDLpjDJIvvrVNs862k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A27DE40094;
	Mon, 20 Jul 2026 08:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3111F000E9;
	Mon, 20 Jul 2026 08:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784535577;
	bh=XoLP2PZBCzAZupYKucsii29TCW5clhqLZ4XvqzViVp8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W4VTE8Pe0SecS49y2UoUsvXPgg8Apy8j7hYJprta8JQISXWw1wGg/nSCpZo9AfgFu
	 P5dLobdxuhZLrcELeSENNVudW5fJKoEGzwDvWEGQ0A3dQluX2oogGFsB44zQkLWMvT
	 4cyyjWR4jE2d3ZMAnRDtXMesQg5dTSm2R/qFfhFNuu5LM6cxEmWWOqzndeoTfJ3Tsk
	 UhOXqz1qPblD36O/CPFHntasMEV9+l0gETU+5zO+096BxJ4Ao0RBZJXD3Kvysb3bN9
	 Aidn4MOyQWe/95EFwIHZaJkC7tl0c69i+k6+Yb3I/3mZai3c1UXCyOADY0XfDVSfxs
	 KRC5vwGZJd5Eg==
Message-ID: <6067cd33-42fa-4d34-983f-c2b0874e0f68@kernel.org>
Date: Mon, 20 Jul 2026 09:19:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/memory: move pte_install_uffd_wp_if_needed()
 into memory.c
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org
Cc: kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, riel@surriel.com, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260720065508.2695106-1-dev.jain@arm.com>
 <20260720065508.2695106-2-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260720065508.2695106-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5DDCFC0007
X-Stat-Signature: 847167isx6k6y6n47amfmu9yr8pf6y4r
X-HE-Tag: 1784535578-931332
X-HE-Meta: U2FsdGVkX1+gieW+od/cDfRc2qNQYzceA7A18mz2T/hTFGEBOkt6NFHJGQQX4Q/td5JfyRbpLjZ4Ijzco5nglLVWA2H5hgDp+YJ+Tf1ebiwLyuPuHmaRyA2IH5Ywgsn0UGN18ODhxDujslqMsc+V/Gq7Iauwl4EBEj4Fvz93qawAmYRmvjpXPd8rH4CFY8/Dstb5R6d+JPAlgjeRFSmI8FrgIGuk75Wt4/De1gwSzQIT5ba5VojejsutWsCgY9fv9XLB4m6rdGx4kk67xsquomSFgfnnMz0cDN6DN1GGH3BQr5chHWSTX7k1sQvRJUje4CJo5Af+dFSQYPRXS7U2gJnWz0RHKYI+hZZxjkVnRaklwsZx07sVzdwFv5bMdaKnjUxQGqb3NVeBngNSIase6+y9ny4SJ4XzR/JBbGUKLs/RKGeCOcp9Mv2xypPhYyGULNixOi1erq1G89A+kTGYbrUJ8E7RKsV0jhnJFYDy6Zo5Emlke7Y2TryHHsnVIpbHpl51qoiC5g7FClsCOwBFuKsNbBlik/GTUWIGp5rqWkneOhSYNxHeFJWX1oRkq2kwCHGAiirHwyQ0ehtf0pMUYfIMLH1JBzwnfCnQL9oczRaTNKmYsEqHqdYFKp4b0pwGyllQg3Nug9g30oEkhTt7Q7AF5zTCjuiuerXBLWIljPCDUUeFT0CNFrHmq+sAsiWRFn844WDjPyUyHLhCCQYxtOukgAwS+IH5vRg0BLhkQH7lf6m1GcVS8aZrWIkR4a0S3bad97mS+oSTXpaGC1+N9ZUaHmh/u8ONjqX9xS1WzL/v5cpQ9NHb/muwVETpS7mdaajd4px3tcenNh5BiboRTOmIXU8D3kecqh1URvqEAhJSuS+k5erXbodVE6+lM5XvBuxhsiXEg7zjuTa5H3lDD670hrYGSJMGoJ0M1XFFW2zuavpJE9BsvAM9dVp0E7nZPwAeUo91U5Cz+NEzcMf
 +tqy30/1
 O/zxeX5f94hWxcbxIV7xaS2kWE2ZFL/MYfuab3lpKsqVXt+r8jk7p1nEEVJpG0VDMtMDnkrAToHoR5iL0NhVTMLYgIDRwo/dHxdo6G/5ILJzVzaz+6k//NlWbLAj96/QwG/rMx4C66TdRZbkzn77q2G298DrBynwzZi521s8NmH4Mkzzh2wmunx//I8eYU9Nzgp2IDMBNPSjanFFyZSSQG7wQaLpdedzUgR2pW4EN2IE60LNSgGH5Uxr6Tu4sieSsN3QKl6AnphDpe+elTJf+9fyNnyw12hv3nxwbr31X1IMoj3pbcpih9ilteOgsVgmZ0LFEXyb/sIUfjJ5edVYvZI7/+5CKgjbxwMHh96Z1uF0I/BV4MbMH2agLc5omYInTawRlSV4VWMeTdrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 07:55, Dev Jain wrote:
> pte_install_uffd_wp_if_needed() has grown too large for mm_inline.h.
> Move it to memory.c.
> 
> This helper is only used inside mm/, so declare it in mm/internal.h
> instead of a public header.
> 
> While at it, convert the comment to kerneldoc and rename the local
> arguments from pte/pteval to ptep/pte so the pointer and PTE value are
> easier to distinguish.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

