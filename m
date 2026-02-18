Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC2AE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BA06B0088; Wed, 18 Feb 2026 04:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A493D6B0089; Wed, 18 Feb 2026 04:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9214A6B008A; Wed, 18 Feb 2026 04:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8356B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:15:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26AB38A5D8
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:15:25 +0000 (UTC)
X-FDA: 84457019010.27.13C998A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 621372000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:15:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J2k6dAhE;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771406123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlEKQdLcPNsrtrlxQraEq6Uv9QXrOOoHS9QKBpjBkn4=;
	b=gbWAApeYT+Ap9BfJg+qpVakkQ00W4V7W5723BHJZPHp9CynNDDZv8N+j6MxM6GxkYOC6Z0
	WmpDRgNkdn/5P9MbFxmg5AE/4i57Elm4Vd8Q9UeHc0O0r++8fpAB1Hppf4Hk7moCSBzgmV
	oHNoZ8XUSYNs96kxK9ifUtUij7ZsseE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J2k6dAhE;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771406123; a=rsa-sha256;
	cv=none;
	b=RgVbt+/7dQqdS479Ukgu3kco0qA6dGthzyOFZoKnuSmdQgCj8bFg6pW13FzIoUizwZKMqT
	aaiIJ+Z0bJjywTyio5K75OAzzuTKkQYkUJsApkvStSZTQkC6yy2b7hx83Bmhdf/TOEo5+a
	DqQMAZgigkMLwN/ysbNZwK1V/zE1TYw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D8D56013F;
	Wed, 18 Feb 2026 09:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161D4C19421;
	Wed, 18 Feb 2026 09:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771406122;
	bh=facfh3Fnqd0pqqYAih484vRudCiY9z5cjTo3bywqak0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J2k6dAhERQMegIXafbmog4+yaSYLVdbQ3XnAiFP4bTsUoWTf3JvD2HEjMLMAc3Vg5
	 mnW+p+xrbT3Ew0S+ATK3csCYE+oxe7B+SMFTkmbue4OI8DB8GkrrdlcvjiDDKn9xyJ
	 lHPxxGW6MKcYQ9Qht2ZWUWb+2eGZ/bqpQ3m59YUjNEwAli7YbFVxuvvOnvV9LhjKBh
	 aA1J1TtFHfkE4e3fnCwrzuQKf8FUxubMRb1c9KFKRdhFsA+eG42rfNcBLSOV8BGX1u
	 tlykWL4EWyrz207wMgTmcZXcbtQX4EgDSiRrewzzDC3N2WugbEqMvMRAfnoC4JV2yF
	 k/CSo5QbcQVNw==
Message-ID: <3a5179bf-fecb-498c-be3a-6a4635f3eb1a@kernel.org>
Date: Wed, 18 Feb 2026 10:15:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: Dev Jain <dev.jain@arm.com>, Matthew Wilcox <willy@infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com,
 catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
 <bc47b56f-46be-442e-bbe8-11f489bca1fd@arm.com>
 <ea08cc51-5890-48cd-825b-82ae031e8bd8@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ea08cc51-5890-48cd-825b-82ae031e8bd8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 621372000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 81nrj8hewwwkr4y6456fgzws61ts4kxw
X-HE-Tag: 1771406123-89656
X-HE-Meta: U2FsdGVkX1++5cS4I0V17UPAJ/o7E+QbcWX8LXmdoRctguIPn/u/1Qi5RzzQzRxtOwxbQ1WW9Um0bQsZTuZIrD7cW1xam0y3w0fJmheyorrZT305xNeK/DomEiMz1wWBWpKN2sxO9korZ1/SqEazbqzT9HlSxBQ0xURqD8Etv+8bZIzDxWHsqbNeFdu6tOI2AnVfuZliPcPDZVM3BeZJG5vF7UL6IbmUPo50068TSDGN9iSZAM9bS+Gc7N1w474GXiJ89Y1rf6Q2sSPSWNEx13lMaEA9qXudjfMvxUJrFV7g/BZHuRlFZ6jOYVnZ0/dwmGgk97GbvXD8v9ffdxPKcfvSKeS+SD9TG5Wwx8krohOIlBgYxNpbWqgk7WZUpVdCuE5SHtN/c+3lYAs5RYexDIWq7bcBZXF1mqXHWLjXM/K+DgPXLOErMwLgeEh8hWtnhLOu6Gr1eNh9TQCj45CqWYvAu68C4IGBoD9/KemVjM5seJedkFpAroz3J7SuEJ5R/4VY9mpSK1W736vEhVpSdHTZA/cqbibdtRQrkLonetFUlXTZTzhnGb2Dyi18DFBU0e3o/cfcQXEWWLe9NyDolkq+PfHonvln7575vviG2oNQyR6OOrkAsKwWRWWRVVvdYOKvRIv+oUaK46PWSN+jf1qUdlKxjcqEZ9VpUMgcwWPuQol0gzUKIaQTULgwRv2gF9IoC9Yhsq+GEvXJDj/0UqmGtVUqJBupUwZalO9IfucK7NXd8+J/q9pSO5E18knpRSQTzXz+ddgGcvmWCAiBTFxyITlcK+ao9NoHkT7274/vMX0dFG9hMF2PblnHUgKljRacDCiWQAspzKjcRfkUKLxacJX35xzSMtUEgCxT71LQ+o77J4GrmYUo/h9p9V0KV+qwQJUM/TEFVgsbE/piJYMzpJaZi+Ds8Whx4IIljzlnGx/VgVo0eJ7xtOuB3cnc7l5FKqxstr3be/Suj8H
 FHEIshkM
 7eXaXfz2Uhhj66QWAiQZgNJTPJF58INuIvfp0DTzsoolBU0Xnrg0pmzGQR15PJ1Gq0805jfdIiwAVRb32fOjszdI7IiMudEJ0m6K6FVessjsgGrAsXMtYejeLOmfPCYQ9zJRC20eQ2I01ncnnvpZBRY/gnWtyWCnrWjAL7LPXGEVuBk34i3V5fsR8Ky6LjwpXWvNmGVxEeZu1j5Om6ml8xknKki9cKeJ9UmaejJlA5Lz+WkrRX2yEfiiS/TlSOIoKFa+2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 09:58, Dev Jain wrote:
> 
> On 18/02/26 2:09 pm, Dev Jain wrote:
>> On 17/02/26 8:52 pm, Matthew Wilcox wrote:
>>> Please don't use the term "enlighten".  Tht's used to describe something
>>> something or other with hypervisors.  Come up with a new term or use one
>>> that already exists.
>> Sure.
>>
>>> That's going to be messy.  I don't have a good idea for solving this
>>> problem, but the page cache really isn't set up to change minimum folio
>>> order while the inode is in use.
>> Holding mapping->invalidate_lock, bumping mapping->min_folio_order and
>> dropping-rereading the range suffers from a race - filemap_fault operating
>> on some other partially populated 64K range will observe in filemap_get_folio
>> that nothing is in the pagecache. Then, it will read the updated min_order
>> in __filemap_get_folio, then use filemap_add_folio to add a 64K folio, but since
>> the 64K range is partially populated, we get stuck in an infinite loop due to -EEXIST.
>>
>> So I figured that deleting the entire pagecache is simpler. We will also bail
>> out early in __filemap_add_folio if the folio order asked by the caller to
>> create is less than mapping_min_folio_order. Eventually the caller is going
>> to read the correct min order. This algorithm avoids the race above, however...
>>
>> my assumption here was that we are synchronized on mapping->invalidate_lock.
>> The kerneldoc above read_cache_folio() and some other comments convinced me
>> of that, but I just checked with a VM_WARN_ON(!is_rwsem_locked()) in
>> __filemap_add_folio and this doesn't seem to be the case for all code paths...
>> If the algorithm sounds reasonable, I wonder what is the correct synchronization
>> mechanism here.
> 
> I may have been vague here... to avoid the race I described above, we must
> ensure that after all folios have been dropped from pagecache, and min order
> is bumped up, no other code path remembers the old order and partially
> populates a 64K range. For this we need synchronization.

And I don't think you can reliably do that when other processes might be 
using the files concurrently.

It's best to start like Ryan suggested: lifting min_order on these 
systems for now and leaving dynamically switching the min order as 
future work.

-- 
Cheers,

David

