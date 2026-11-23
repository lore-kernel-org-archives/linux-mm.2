Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B72606A334
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJvImX4Z
Received: by kanga.kvack.org (Postfix)
	id 6E0446B05B0; Mon, 23 Nov 2026 14:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7416B05B1; Mon, 23 Nov 2026 14:45:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6866B05B2; Mon, 23 Nov 2026 14:45:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 262A36B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:45:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95686C099F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:45:46 +0000 (UTC)
X-FDA: 85467413892.19.611F23D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BAD2CA000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:45:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJvImX4Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463144;
	b=ecZK3LdjmcvHaxWLJ+PYiKMJ6eZsfG0v8ad9jrGAtwryeWNU1uys/CeT8NDQUBpPZK1t5s
	oKl3et1Pz29ld85xJFnDREBsDluimgFgYgHVGTkuZbxIrN9n7gTbXEBqDhyubuVAYrm572
	U5IdMTtXJPMpEJIzF5CZXidcYBNGs/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pD6s92k761c1Ji+Edgu0dOlrKizCHM30TIfkHtFjL/4=;
	b=WddwOmYOst0fSMHFp3rKjzOPMNiNvVLc/E1AvxHrhWkMc9eN6SGwWbhcJ5ND7Q13OWFHWb
	zaItJ6Fdj/hU+aFHpqw0MFt2SCWm+OvkqD1suS39QUkENl+9OELeyvEvGM21Hrsberi3A6
	Hp1waoZh23JoR2vJ+e4PTAZQ+Mjabgw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJvImX4Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB25F41AD2;
	Mon, 23 Nov 2026 19:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820D21F000C6;
	Mon, 23 Nov 2026 19:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795463143;
	bh=pD6s92k761c1Ji+Edgu0dOlrKizCHM30TIfkHtFjL/4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kJvImX4Zp2Shrp12IX87KJgXNh6vruJzS2+IdBsJBQxCX+u4DeeB/9tWE+h7aB9fh
	 nfefktlwJ8uFLFmSBSfZZwW9AQjnjw3xWsf2+d+zwx2MNP/smC0cpGbFf/6+nExeFP
	 ADiRMC0uXVKynZrTDFhWDThDOuUoTGi4Bn5JNVFkotaTk32iAJkmit98MQCVrcDebL
	 hvUBydB5yLLvy+cVOtIJKQJLLMwDTxRrKD0OLm8+LMdWtpJKc8fAOgCYrI9grDDxAc
	 ZGbmn8pqhwoGtBpIMth/Bj5gBOnme1T2NjLuJTQlC38jMpOTUZG/Sffhvq492vFYoD
	 T7vGRinp3VvGg==
Message-ID: <89037847-8875-4d8b-a8f3-d77a59aaddea@kernel.org>
Date: Mon, 23 Nov 2026 20:45:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory_hotplug: don't offline a hwpoisoned page
 still in the page cache
To: Mani Tofigh <mt4022@columbia.edu>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 tz2294@columbia.edu, stable@vger.kernel.org
References: <20261105-memhp-hwpoison-pagecache-v2-1-029d35634d42@columbia.edu>
 <d4812513-6cfb-4865-8636-b83dd92c23a0@kernel.org>
 <2e11ba52-b5c6-463e-a5ea-c165ba935704@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2e11ba52-b5c6-463e-a5ea-c165ba935704@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xk1om3eske945jfqf9tx1dzkrsm6jxfy
X-Rspamd-Queue-Id: BAD2CA000F
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795463144-823386
X-HE-Meta: U2FsdGVkX1+V0O14Nj3iaGr5dD2OJN4kh3YM7kivOyKZbLY5Ymi25YB1++Ifu3kXFDCDaV8FTW60yIQcleOXiJyNVK/f9HgzwUKlO2suw7y0CBgDbTZCsy576QodyFXXhZpz/E6PRVXm3wY0qvkt7h1zueXu0Auz+dASWLnZBAZA5XFU+5KpdQGr+qbAAVmTg7wdKH6qkKUmR0rCGPbTl8JC+8yNOxCaM5J1aKkTxxSlOf6yrTDNayC6TP4l3Nns3cW/o942im4OSPMX40BJXRdjX+zhFAmBTkGV1DA8SJc7HvueOyU7gOcsLu8+GopHeK1EH5ccmz5TL36iXdIIwft4uBjNJL+LvEkBHFv82sMACgzU1nmVsz8c9bf4gNlEfntbHyeTfqtpcWcboavTZAZPcp3XdXQOadtiXt931MF6/TRSwk9q9jLBA80zdJFf39jfhBrTgaq5D2fvomz18D2xe0Bfz/cKGKXme6JiubZeE1lE/AnQCXAUkZ+FPSzcjl3v4JsbvvBIMrzqzPgreRSDIn1Eu+mcU1dbVdyIf/oLK1j+rU0pTX3knYizoTmBqdD8jLEfZ/zYPDSw9sDMK+V6/IsRtTR7iIkb9WE5sZvJs2Ox7mfGwLBV4Ym0sWqn31y0MYJm9n6CIXw3ntHemrs5mzPlbquHYk/9+9KYe+K5hTHsXxj1n/0BVgGJq3bKcviuTX2bOnagcJfHrHer8n7yMrJAUs2Sm+tOpx8c5zXMVA7jUVRzdQiIPB8/PRzX+AzUMbXRYIBakiIIGORd5WEqvX6JxOWKPq9yyK2BaZq9pzatC8q3bUDZdDdH8M3HRvBivGrNC0MTwqEGfXBfXg3FNxC7g/P0ofE0jGXYCOmeiAZ26p87CJTIiOTWxLz+46tDzaNY4GryU9YHMTNId/u4AO97V6sljfEwyP0FQggMfVbVuGPU8TP0AWrFOztHjzSaa3bCSrSivo0bwsf
 EPhPanPh
 VsAFVm917Y1gWJp+w5JCSmPAWAqVxlAsq1IF166kXCYIk5ovYqQt+fdhWOeOlnN1YtGShMwIuur7jMsNPlLtIY5jLxF1J5ZXtcPQj8RDhjIDeUaqjagSU3xJ0addndN134UmPKNmvNcc7zfn2vkIL+tKC5Xmyw+3yNSF9h/Uk2ERuQWtScc1od8DkPMvjxGPLA4yBIvRpR0aGChKpsYIl7ahDUl4d/KONQaFMYitargMOlKgFPGYoEPA0hOalPmqM3e5F2EE5K62kEffqlG4XtCv7rqZgIrutCJ/pihVbGqqKr7J4zPlySyzGr3os7kgzIj/gAiNNFrKjBS/TN1rBNhNoAUBPSwHKh6bsR1pdWaopWH9dQ7v1vOQrk1kbpB57LNgZu+mvPwA2sVCjKAKFL/iRhInPv//1WOEhuZneSGWYCtsB16iJ/+P78FdL//HtfrS9/13bn2BShckOmryBV1R4Dk2k9ZuKxqjuN/ZuUBdr4qGV5Bcs+8ukYus9brWDciWdODEtwNK3Gg8Evr6BKj0YWBD7q3Onh+ErB/6X63K1PvSkJbKY0470LIo8faFhKc33YRuarNED6rXF4H+0MGQmBQX1rLEalmgpei6N9+ruYuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 06:46, Mani Tofigh wrote:
> 
> 
> On 11/6/26 3:58 PM, David Hildenbrand (Arm) wrote:
>> I didn't understand why just checking for the refcount is not sufficient. Can
>> you elaborate once more (and please not send a new revision before the
>> discussion is over).
>>
>> Memory poisoning must grab a reference when setting the folio hwpoison. Any
>> other reference (pin, pagecache, swapcache, mapping) keeps it alive.
>>
>> Why can't we build on and?
> 
> 
> Right, but memory_failure() doesn't always hold that reference. It i)
> sets the flag before get_hwpoison_page() grabs it, which waits on
> pcp_batch_high_lock that offline_pages() holds, and ii) gives up with 
> the flag set and no reference when get_hwpoison_page() fails (e.g.,
> a pagecache folio briefly off the LRU). In both cases the pagecache
> holds the only reference, so offline can't tell it apart from a
> page memory_failure() already handled.
> 
> So I think if we move zone_pcp_disable() in memory_failure() before
> setting the flag and keep the reference when it gives up, offline could
> simply treat any poisoned page with refcount > 1 as busy. That'd cover
> pins too. What do you think?

We'll have to find a way to make that reliable. Everything else is just hacking
around it.

Why can we block concurrent offlining through get_online_mems/put_online_mems?
But I hate these functions.

Or alternatively (better?), have a memory notifier that block concurrent
memory_failure() by grabbing the mf_mutex when MEM_GOING_OFFLINE and releasing
it when MEM_CANCEL_OFFLINE/MEM_OFFLINE.

Needs some thought, but if the problem is that these two mechanisms don't
interact well concurrently, then we should make them mutually exclusive.

-- 
Cheers,

David

