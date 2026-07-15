Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6466AC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505FB6B00E5; Wed, 15 Jul 2026 09:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD416B00E7; Wed, 15 Jul 2026 09:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFBB6B00E8; Wed, 15 Jul 2026 09:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED606B00E5
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:49:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DADD160183
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:31:15 +0000 (UTC)
X-FDA: 84990946110.24.04BEEB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7AD9C40011
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:31:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALPc5rU4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784118673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CA/gvPPeHGWFx0KXCJPnqrnkMq9p15aLakAKFtTXRw=;
	b=ZEkxW8O7YIPchmsDnriVmmdN8TBse+iYBhFQ9dEbxKGodcdyL+Nmjhr7jdvT5vgZybDekS
	L48QUuj9Ubq768PTCQXKKoowNtQe6wpVv8coZlBkm1Dm9DRbgKtYvdvzQQWGLJTGt5a3xn
	auYyQ1LIkKak54QBrEehaCPXvLYpBIE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALPc5rU4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784118673;
	b=ck61wgivQIA/VOGd93GWpYBs0GvtKdSAjMcipuFcrXBauM6tJDTOqy3H2ylCrIZYhcygDs
	QVNjPoiTNwpeuBdv9VbxUhJDeNmTtmL3EECSFykRGvGGe/xylfpVzWojWYdwH5w9NETYas
	KxNyQnQQ9oERcGIb1zPeK/OUiZ1IcwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76C916001A;
	Wed, 15 Jul 2026 12:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614E01F000E9;
	Wed, 15 Jul 2026 12:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784118671;
	bh=+CA/gvPPeHGWFx0KXCJPnqrnkMq9p15aLakAKFtTXRw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ALPc5rU4iA2uCm6/0MW48v2YQLtEUCunTv6hjH04sGEcZbW4ILuLcldAnLH49GdGx
	 Ukl8vT8VBqwbOs9iVLEQsda+8QnAQeIznt5pXea+Dw8kG8y/MhV2LN0tDO7vDSHdl/
	 cGgDRpVS0oq2W6YPfRhjrVPkIesZB4AR7yp76daWhBukoYdR2ZPA/dlwem0IJM9i4y
	 ildAHIWAOCVCJtprNMgB1Y9mlGZ/QGBaLrIyWbaW8PxOsUeEexqybKXnIl+j7qFC4y
	 H/22OJ3WA1zuOJpj+N26B1baUgoVFaQs9Btvv5CBOuWlDP9GxKfpyzcoiEHesrPsyb
	 WPlDLSoSPM+JQ==
Message-ID: <7e7f20de-c43d-40f7-82d3-8d05ceb3656b@kernel.org>
Date: Wed, 15 Jul 2026 14:31:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
To: Mike Rapoport <rppt@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
 <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev> <akpBWmnujSnj1ZEE@kernel.org>
 <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
 <DJZ3TQV3GPDO.6AN321FGTTX@linux.dev> <aldv8U-lzCn0SCBL@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aldv8U-lzCn0SCBL@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7AD9C40011
X-Stat-Signature: 961dox156adqsu3pyoec4uskkbxr4kax
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784118673-930782
X-HE-Meta: U2FsdGVkX19Cqc4H6fYTs52YjuoOVBF2Ezi9XeeaFFtw/NY/otPq0iq9Yfwqg5WMM2n2nRlyDYF19ULZ+5u98/h5Fdsh1S52ZViJx2b2/6GpOgHjlECk3CawrrcpBZYCztUgVNbfg6mfJMfu+PxZumPjWpsq0Hlfm2UdnA23Na/yc669XgOJtCR2eP7tn7IWerNz0Iy59gwDcswcs6E0sjfh1bITh/7scs6BOQfSgIfiVzkVrFsnjPl9TRbUIncRDV3d8ZIU4l4bLtq6N5vePmK6ZV+cJsbUAbf/qqSjUvGpuOlSrmFamgPMEN4r5IyVYLP/5tTTi/riZoJJMOVqIzf48nCGg73Zw9SZBOVnWxqtuaMZYsu1EVV71lw8io93zLppwEhNWYOIAbaOt2q7BoEqsYy/xV0eB6r4S78NnBNEKqhkGYnRSS5OXCt9HVebRgNmPbrHpye81ip/LRvwbxhq5zZEGV11M3j40L6EgSa2CMuDOF9elpIr9p0+LW+F3TTEyDylf9/XJNh6qiUEP9XUTYn/4HkZJ6Nkli/SmwJBBWezRmeyYx3uQU6ekhY414f3srQpPhBA7JsZeGk4v/ThgDiINhPr6g3gxPGNkXG1RYCS8+4Sp7BGvC/jJdZ6H6AdECu+LFM1LgEaV+t3erDFnBiD5jleElgbjEN6jI98R2361oADvlHbGg2wkql+fm3yZfR4decto8Im3wbQYZ4oGY017uTvnCh9OzX/thH9bfO08l/YpverRvYFWAQXd+RXlQGmil0e6Tkmyf3XsNPmQVGvKUerLQc0iS9nTTiwAjb5YNhNOz7IUNSEUg8/0Rukd9WNsng8jKnPhDOZhm1Oze+0iKqvJQkUcfBQO1lvmIOXzh73EEa3eC17NBsoHxWICIm6RtSV+RDiQ7m27JAG2pjXpL4RD3aTERGOQjmKO+q1dktuKor0/Je1N8XgcbPyU90FFcG8gw4YuKa
 SsMmVQDg
 m3gmmCiM3t4QrLLRms6z7ta3ll+xWqQk4caloph5FR8VsZd+xoyO3Rzj5OE5f0jtqA/RUMbRve2OTJCZBiaBkNfpXsi3rKyygO+9KCMQMDw+8CnsZc6K5HH+LzefxKgn/3CpDykCbOSextxhNjqLAz2mzC2onMbK3tY+K8nDZXZ/EVCLRJXDX7k0zp0blY6QRmdUsPA8Ejc/eqNZhBey6seyVw912NrKRj8wqA/F8Y78Hkan3G4uDSOnEtDuhcCGl/FU5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 13:33, Mike Rapoport wrote:
> On Wed, Jul 15, 2026 at 11:22:33AM +0000, Brendan Jackman wrote:
>> On Mon Jul 6, 2026 at 8:42 AM UTC, David Hildenbrand (Arm) wrote:
>>>
>>> Right.
>>>
>>>
>>> We could even limit it to 64BIT ;)
>>
>> I fear this in limbo, we have quite a wide range of opinions from "fix
>> the broken configuration" all the way to "disable secretmem completely on
>> 32bit". I'm not passionately committed to any one answer but I do think
>> we need to pick something.
>>
>> Mike's position seems to be roughly "in the middle" of the spectrum, and
> 
> Right :)
> Supporting 32-bit without HIGHMEM is easy, so I don't think we should limit
> it to 64BIT at this point.

You mean

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 4877c262cb1f6..d29865075b6ea 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -202,7 +202,7 @@ static struct file *secretmem_file_create(unsigned long flags)
        if (IS_ERR(file))
                goto err_free_inode;

-       mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+       mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
        mapping_set_unevictable(inode->i_mapping);

        inode->i_op = &secretmem_iops;


then?

-- 
Cheers,

David

