Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C0D6C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4776B00AC; Wed,  1 Jul 2026 07:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC486B00AD; Wed,  1 Jul 2026 07:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23DE6B00AE; Wed,  1 Jul 2026 07:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD39E6B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:08:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38B17C1922
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:08:26 +0000 (UTC)
X-FDA: 84939934212.16.3A7A9DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5C35E1C0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:08:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmV2H54Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782904104;
	b=ta3T1IDH6r1nssGR7S3p3zZcOVTn/vDXAKt+g7mc+7CXcrm12nCWkvgNR15baD+1UCRbyV
	/o3VCmgBDEuqo6tOBDl0DnshJjDOfLOXS5lCHK3EPNIe3hZ/VwEXBBSxFj85EsPqCH3g2j
	f+gDfa65CcFHeWgVRjiUv0GyD+0iPhU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782904104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25hllQ81FJ8oyoNh16ieVwck6f+ese8UGksMu6pmaKY=;
	b=flg3N8EulZHBXB7PNSmfUe5Ay6koqmmurO3PXTJVIfP8qN3AUJZFP/2e4uPfe6pXxLw2HU
	ZD1fG9C0oDoOYjg4kAJJbOvnpi56V1wNFBmLJM9I+ccJKoL56uxZurxggStBI0+mE1MJpk
	pnfUFwU4RMNSQpxz+89mDTxFbvlRF10=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmV2H54Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B585417D3;
	Wed,  1 Jul 2026 11:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F3A1F00A3A;
	Wed,  1 Jul 2026 11:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782904103;
	bh=25hllQ81FJ8oyoNh16ieVwck6f+ese8UGksMu6pmaKY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UmV2H54Z56ebtF4+V+F6t1iMxLQGSEOGPxOrV68q4Yjla9IsHu3zTo913JCwmx4U/
	 F0kHCIIHRlB2p5gR9hJ5Pn6DnC+ii6GdFxjW5T7dWOcCqS8/osiyd/cSgVj/EreCwN
	 A/Ev6MNZhGkgArrBTn5hdYFUISsBGa1RDDB0HvmN7xnoJ6tnZT+XS/eSbhwoqBP6tS
	 Z5/qyTUr1+DRX4UT/UN7lMyY8hB43UFRzNzCBzxijCSg4CtOHwXwaborFGr0KVBKrB
	 IIxEf86C2VSpxlRWyJzis7vlyIOGlxSffWnncODDyFCJY8j+vG52M9ScucDZQn7JUU
	 +l36cBhQL7xXg==
Message-ID: <f7ae2a47-730e-4665-85d9-07a7a40e1b39@kernel.org>
Date: Wed, 1 Jul 2026 13:08:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
To: Lance Yang <lance.yang@linux.dev>, ziy@nvidia.com
Cc: vbabka@kernel.org, akpm@linux-foundation.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, rppt@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <98cf3340-1a2f-4d50-8410-6e9d6d3a5308@kernel.org>
 <20260701110151.77453-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701110151.77453-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C35E1C0002
X-Stat-Signature: k346xk69rftnti5a7fgwd4x45r4ehisx
X-HE-Tag: 1782904104-163648
X-HE-Meta: U2FsdGVkX1+o8qk9jGHHIAyPcWXwOov1dXXXZohFypKRbMUVVw7JWpGZnjs/PVcaWKpkvEDZa34wRoJTa13GuBfXs4JrHIiaTWycuubGNuvM7kINLHx41QhO9dtsDOqe/ja3bIFRg/FyfLXb4QsD3LE2CsuipLSwEJ55L7Jf9FXzFdHa76NFsXw1cKrNcVONUBPsWMHXWk7Vszq38f7mOGgD3qHw3mgPrSqI08ONgmlF/5b5Z10jYqVsWsO3gnIwJKq+7+kfJ7A+M0PjwqIm1Pc51T3WYJCWBbo3d46oc4dfwGsfJg1VwM9oJD51xounnkFVupv6BxXZ8iYG96FVqSZVufXTUt9U//HpoNO6u7TrF1S/lCev3qzpVcf2JMfXWNJs3p1LtDRM8hdPhU3jmuVTbNh1qZppXZhE/uFnDnsPQ0prpq2f3sqA0di4iJYz7m03EThiQ1c1FYTlL3I0y/mfGxF+U4PxPEGY5JHM2PveeUieAYCZg17YcXDbNJJh7gMDMCP2+v+R/rJFy3rd/0W6+RkB+j+lSsDfBHVnG76gU9zSHEcR9FB2B36fO7R5dhYhDQrEeEkQwJKcGPeA8keCNIV21KlvwkIvTT2JkFDPXbo7pP31XpQ8S692Ch/bJV16LE5enllZTHaDrl9aOarhm94pteKUA9o5ggsuFfrgWaqiE2SN19oBw3Z6IYV6ADuhJBm5lnLtVv7xflolOZZ4iANg3CxsKK1WctgGnbhdg4X9gB/wdrXCqFuwZTgAUrSHxLSaHQM48VXFa5YI3C8JbwGR0lemO0V9KEqMunXF/71uC1yTA3zdM4dAXToJEKJMoXORFGVLVe9AqbS2j+mCtpAU8t8bLtlTAaMk74IaVjsVgwiQ67Zp/6udpxzc4AG1qoLmOrmu22ywYK3zQ+53CD0/ECfeel1Mx0R6JU9zR2BD6ozpqNRTZEwxQYVCDJKoP9VErFRvPe6zzn1
 kUU6rueA
 2fYUwPVsXo3zM46CfeUNwJ1cAJBGjmI7emmeui9KBg/9KVQyqKlWquGWrbS7XDuqXSccVqg5XpUyNf+tNtGaqYGV8AktIUjCnMAWn+82y9Ak5WGdwc8WCm80R6motKXULQdwe6suqLnXdBREKMbDWkgUtawJelLDwD0EPB+jnP2CjUUZ7LAKX9hndppCgDEujMHj92NxUdbjN6AiuVS8HUSnzhZUEbMTVQYth6JekIEACRYRUEqjqr5sVQkFLgNimnflgAluRNGR04LxsVDghsLwW998CgfSzCeOrskl+a0YSO1Jx9EOed8NzQjlFQiAHbgOJ5DKf/qxNA6+fMbiOTaPYMOJEHlvb7tXD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 13:01, Lance Yang wrote:
> 
> On Wed, Jul 01, 2026 at 10:56:47AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/29/26 16:39, Vlastimil Babka (SUSE) wrote:
>>
>> s/add/readd/
>>
>>
>> You can link to the discussion where we clarified that this was not intentional.
> 
> Probably this one?
> 
> https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/

Indeed, thanks for digging it out.

-- 
Cheers,

David

