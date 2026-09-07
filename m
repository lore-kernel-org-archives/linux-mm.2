Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 034ADC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB566B009F; Mon,  7 Sep 2026 11:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CFB6B00A2; Mon,  7 Sep 2026 11:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5486B00A3; Mon,  7 Sep 2026 11:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC3306B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:28:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E178A01D2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:28:13 +0000 (UTC)
X-FDA: 85187347266.22.B3AD2F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id BCA1920003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:28:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZdmbe2s;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788794891;
	b=h1TdeGqHJ6OjSCSrU3hRAaY6xi11x1vkGcUxDXr1d7/O3ZMVocgHHQHEkOcOsPIMenhw4n
	j5ItAdKRCapdYID295UOEiCLCxWYcgP1x8Kxk/Aq8Se4aWVBKgqVnaPZfVyt3MRfIGNZEO
	FUP3pm63x97HAhLjZ2Odo58iKBsXDqg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788794891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mK+98jg5dsyflCRW6hzeWdXYj+TcG2jQV+y1BsFx2KU=;
	b=AGNnweNccZrMTyAbyukXPaumS2kmQmdjyBramxw9ZAxE2laufKPEY/LFvfCDUJrj207Qio
	ju5CT38IH52JQWh15mzuR32QZt5lkVzF9tssLww7Ak3EnVjs6BzK0/C+P6KSkJQKNDW3hM
	JybtCXxty7fSOun+02PRftkTzSwBfLE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZdmbe2s;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B5A060D87;
	Mon,  7 Sep 2026 15:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8286D1F00A3A;
	Mon,  7 Sep 2026 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788794890;
	bh=mK+98jg5dsyflCRW6hzeWdXYj+TcG2jQV+y1BsFx2KU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kZdmbe2sBK7NcmlkxFNm48D+xjmNl7z46UL/QAb6geywyDhI6XiYzRxG0YTUPacBB
	 oiF6MbRR5QldkE3rFwxN2ukKMilg/N8ceaWW4dygot3vp2d0fvU5kIyIPxjsctcf6R
	 kKUeNZ3lkJOQ3XkH1UFChklewhrIS8S7L81EaBS3Z0bqup4yM5hFeIEUhZEEGYXZFP
	 J+NLtmtVpgAuC5YO0iP9AB6vClWrdekVdoimyJG8TfpNqtNzafvIFhy3pR2wJrUOFB
	 92AAh6FXgfbbbBRwYy6rw3/nk24XygJ8rlO+3l6+e1y/wx5DAdnF3PXvXVtNCtjv5D
	 1CQ+31IH0razA==
Message-ID: <502b573e-592b-46e5-96e4-c089329e7aee@kernel.org>
Date: Mon, 7 Sep 2026 17:28:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: factor out node_is_memoryless()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, akpm@linux-foundation.org
References: <20260902195507.88655-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902195507.88655-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BCA1920003
X-Stat-Signature: 8iuum4fnamej1n1emee7zesaw8u6gncw
X-HE-Tag: 1788794891-28787
X-HE-Meta: U2FsdGVkX19KouQT6rAXSo9XjSUiA3qLo2fLo32HXOI4B+2jhyCypI9rOYkXWm0S3u4H0jfZ9ik9goH76e8vMDl84ONhwq7JK2eTbMdRkXGPKVQ0uvx8wv9g1XysPdSbeIK1MmBZaaiyjwqmz4p889mKf9BKLMnwaTN2AQUE4dpEd/B9PoA5o4D3NDQutphZS7Bk9fMe4oDoOJ/EMbqBLAedWSYtTGrddSqNt8V+pblF50aLAL5Slgo9nCBo8WN+G56L5HqhsMSFMqUHiXBsdomljl38Y/XbQYib+NmTiZN6643qBodyCv3eibRGLxxynGq6Ej+CyKcNj3jhKCeMLEq0rpl2R9EDaxo1oI89pUe0OvB3MqOdvCVZMSRJRSxhzM7X04QNFJqi8Uava42MOR1bbcuH/cr/fxktKSeIig1AQWA5KU07zGRuYH+mSLdU1dX3xFk/xX6G9gDI3Wkdq/Pff/+EPQYdQM7NS0loBWJ4cUfNKRQhglCxs0npCyqflLN2fDrlFo0FipQlXQiTYFi9g2je4pvrzdCK1cvm+11roXlEDURH2AD0Yx8OaCh8S96HGeDz+Pchsv1FI3190YAPZ6nSY2QYjAwNj76WwETegj3meOMOwb4T27aapExH08uxXVuWcvIqkpT1w/vtOzRHvTnr+bezBiKdaVxZy8u0ho02gxQrbtR7JD5110BOCBwE+rQCF4dwqLfNtGq2OP/kGUL7kieYKwAvXh8WjC8h89KIg6brNq5aOllGJvXCp4RU0XBLqNktl8WMCrxdstq9rHSLZHpw1suUZmhYdvGY2OPNKIN2GrTPxfcW8u/4HHwaIJ09rVUAVJuiUE0O4l2MPCu9nOZeVyicQSiQ8m+aw30gKoTWJrhRYW3XDNT4Fqk1NjT634BCBN5Rjx1xyw+m4jPPIMyEIL9mdgDe8QVUuah5GOr58yT7Wsw1u782Qof8weAq6c+1duBIL9T
 9GAoJ7xO
 SxVwbeR3SPY3429FSDzBlgXVQSEHkl7B+3usRpjUPvF1noif0TABrETb4GhjxhJpM3YmAmYcBrSlWypkQY4NIQ1VbU/PuGmNVVNi4RxNcGIPK5ZMyKx9o8B4IVor+nChiyGD1C8x3WRB55m/17bIqk7RCpyAPl8azF4Db5zGx3A4lQ/ijUR+JJ4AZDojxhGHZ5W8tUoXJVmrkzA2lrnCGMaLmUdYiHhvGXc9aHKXCI+fsmf17E+4aE/ku+giGGILpRcGVMkQ4SxnegYXltaACG+jnERPrNufayS7YEPHdi6+tjMdTu1RmwW686LlVrebx3rAi8Ufe+ZWoEbhc4Og+ivvE9k9mC6NL3KsCu43HKAj3l3pjRXvZiJ753gq72kSQ/GlR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 21:55, Gregory Price wrote:
> A memoryless node neither spans present pages (populated or ZONE_DEVICE)
> nor has an offline-but-added memory block still linked to it in sysfs.
> 
> try_offline_node() presently open-codes this memoryless check.
> 
> Pull that into a node_is_memoryless() helper and pull the existing
> check_no_memblock_for_node_cb() helper ahead of the add/online path
> so it's clearer what is happening here.
> 
> No functional change.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

