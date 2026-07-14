Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66530C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597CD6B00A3; Tue, 14 Jul 2026 09:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56FDE6B00A6; Tue, 14 Jul 2026 09:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A596B00A9; Tue, 14 Jul 2026 09:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BAA06B00A3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:26:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A2091202CC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:26:11 +0000 (UTC)
X-FDA: 84987455742.29.2C6A2E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A8E601A0010
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:26:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z1XhDKT8;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784035569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mQLTZWwP6nMInX5WTcyghl8Fqock2YYXubpJfFkSWk=;
	b=7eHvPC27GnIr0K4K0CScisXedmI/eKs88QS2GyebwGWSldFJPRoZffZ3umi50aymXKX9zP
	+KN1pjwyAuSPsw+5gPA3JWKYAWQUm0aQYc1SnHstZXESvt8dEZ4S9oJnM17slhaFfhYb2F
	1RH8IkqNB6Xf6jwBj89opIC29K9aB1I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z1XhDKT8;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784035569;
	b=GmGUKcz3zLcXLyzfAjiq2SgOmpGZkkv7wyqgiIPlqNZ4UfXhErgiY+kKen5kJSlgfotYCn
	8d6vkGL7NCmBelZWdFTvO1VnY8E9vLP0/1JB/xlX8SUU3y9yYU5hVxSUl4JzXkmH5QXLbQ
	rhVYoAp9Bk053dxbaRCA8dSD7bpe95U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31962601ED;
	Tue, 14 Jul 2026 13:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE421F000E9;
	Tue, 14 Jul 2026 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784035568;
	bh=1mQLTZWwP6nMInX5WTcyghl8Fqock2YYXubpJfFkSWk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z1XhDKT87qBocQzpl60CD0aLeOnDf9acs+kQMWgukwr8tQ0psN4Bkv6tAD11itR9P
	 iuLieA+4AEN/80Vk/BS3Z8C3vtQ630UrLaXEGohYcbTZUtAix0v3dwTj51vxwmX19G
	 +9SGVmB/sy8yHokphiwWVGs1i/FEUScb1DinJVIMzjuqw/P0mqMz2y1qSW7q2BRUcg
	 OHmwgZaSkTfXFbQbVu13v1QPY+pgY0hPZ+BAm2Zr2dhOdgywpvqbckr0vRa/oQpePc
	 ws3/1jY8x+I3HwyCmdk+HQ81UJljfD8VltMEmKq8h7RSrezPEyOVNjqnqN850mf/+G
	 sTcrXidnvmh/w==
Message-ID: <5344474e-1584-48af-97f9-4a6a97057e9e@kernel.org>
Date: Tue, 14 Jul 2026 15:26:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/mm_slot.h: add comments for
 mm_slot_lookup/insert
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, chengming.zhou@linux.dev,
 qi.zheng@linux.dev, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, wang.yaxin@zte.com.cn
References: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8E601A0010
X-Stat-Signature: swmifdkzu1br89eprwkuabw9gsoo37x4
X-HE-Tag: 1784035569-413475
X-HE-Meta: U2FsdGVkX19vwQqdZ5GzeJic9WvCqirX843FlAOzOevyV1iNpDJj+GOLqKQskv/LsKd9qVz6c1JpJMuiT5XvHY2Dkd8y9Atx/mpWvD65QXyE7konknyY8kIzVVAlrRblEe+hNtusuatoz8uY84qiOC+jWXxV3ykHFIdIeiLFfSnVj8p1mBuEYBNh6vBd9RUuhH9L0UApTQ/ySb424e39fWCbzFPLDPxuJfrGV69SOPDGlfIk5bV2YVFoojd/wHsUyzJcz/XsE+YE0lXDUF4URkPdHJdJ3G/E40kuCwbzsTcTG5u457LJygiIsB5HYZTie2xRs7QF2Ke2cM+pzXSgIucYMNDQLHDjLFRrwPzwZYFytoB9wtyRBSxhhVtZ443mI/REU2hk1C7Q8FOsnS4acJvbgjv9+3tHwfd6K5e7cIFcWF+oaDfTzq6A34SXeQxW0S9VlnYcbLeg4D2deV53b/cgA+iwEs15fXZjNy9VJwYcIfnvc/lFqX8s7fTAuCINxM2uR0qIc79DVUO8rtRUXZh+j3vqk7s/iuZw0wxdUz0lqzmj3lj24PEWrrFJCMo7Ldke2AfFYZ/oJehnFNdwgwpT92M8/iEtBAE5oMpfoe3dDmOVd1HZLQPPoWhmM7JFwmNeivj52tU5zMImq9mq5GCqP/w2VAUgItsNDCFFLJs5JVtrZ/z7Lml63pHbcRjwaxqP4rsfsb1/gxLby+xL7Rh0Xc0fhqoqpRyjm4iQdBT2P4dcOrlgaqTBtUlnvEZNxDGnE6Cj9E8r6ZTcxl1PBpVrU8wYwX2PXndhICHObvEpFOcCg8V3iZ/M8evD75PAWQg2IzlKAcFPeSI8O/AZ1h7hhwbjintHrh6mSoKhzCYFU8VrwNMsr4oYPuH1wjgIl3OCzvAoO+q+AdrtpLIoHZPqDTRnY42Nj/GkzHaHpZffRvL12waa1qcCDHhweC9ZVHLzbjGnH5OWsiJ79hC
 OXd0S0GW
 SC5kTBKtZJBMp/agpM3sq/BuvdTGSvYFkAarA/yirmjhv+vyF6Nc5bYiRWySEzBDcS97oZ9D5s0gMWnv7ysC9FOXPn5r+N9oEXbkxCTBrXfs1xxJ56GCuOx6Wv1Wbgq0q9CItD5B6mxaid8ESUYRFFpuZVEvhCqERfojYetJCJt0rZlFLa8RPRjbEh5mW+PXf03/s5TYrnH+QnmgToaD2WICjP89wKha+dx6BZrSGBV8P4Hs6IVgYX1gh6a5QdWgM6NZAH+J5xMneaI7EjpetAvrNaCgyQqOHcEmtexei9ivxwZO918hn4SEb+qcD7S8ubec1niXiIdJ9jO1lODkJ3qPypIAalmwAwLNQhPteCZavs6xds/wl2QW2kzbe1kjrNfKxzzCjDUX+RCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 03:28, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> mm_slot_lookup() and mm_slot_insert() are the only helpers in
> this header that are implemented as macros rather than static inline
> functions. This may look inconsistent without explanation.
> 
> Explain they must be macros because hash_for_each_possible()
> needs the table as an array (for sizeof), not a pointer.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

