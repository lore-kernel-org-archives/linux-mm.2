Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B21CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B723E6B0098; Thu, 21 May 2026 21:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48AC6B009B; Thu, 21 May 2026 21:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A864D6B009D; Thu, 21 May 2026 21:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 973B86B0098
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:31:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 406C41208FE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:31:17 +0000 (UTC)
X-FDA: 84793327794.09.ED960C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7BC41C0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:31:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=miF+CQii;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779413475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ax6hrPRWaIAx043nNXcVSuaLaRixG7DNWXgd+IZuS8U=;
	b=z7Q0C+O7FNeYYCLfmAtH1myaiVE6haG6Sjx2c+/qhEJs+tm1tF9OaOJc7r4cx4V27cr3Jn
	X0kE2/fZYwWa5GVgozFU/Z61qCYTAMuX/y1986c5ol9PgK+snITCQwPhoXWeQOXLTJihqU
	drSU5CxlA9Y3AWK/yrO06EYP5TkUtUM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=miF+CQii;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779413475; a=rsa-sha256;
	cv=none;
	b=VWNgv1oSIL2AOJSEfzsGBqm1434jsKx3ghP6YCs5AEdRo6mN+b+LdXTbMGjWL5W710JG1W
	Uq56NadVTIWd1ug2VvWy+faxEW0V9XMJ7jMMb1TcQUZjzSssH/PSZa6tjkE+C/p+TodT6g
	JjtGslnqykowm2D4/eRRwOiXiYPl50M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F42F43583;
	Fri, 22 May 2026 01:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C05A1F000E9;
	Fri, 22 May 2026 01:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779413474;
	bh=ax6hrPRWaIAx043nNXcVSuaLaRixG7DNWXgd+IZuS8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=miF+CQii5izoKY5gao0oxo3bG6XVwvi7AZHsl3IuLUjX5I5PFvmFgYrQGBxrW0oX2
	 uNugW8Ymo568ftnNzss5OrO9QXCdFPZZFDu19wAOVbKXjBimeYKT10RJys/VQbq9wC
	 mZv0IxDg9h1AbGnL1F8GQssoRWZXoekLZUwYWdOevcnbabfLKyVAWASiKyWiEcqJPf
	 nvpBShONSfxd/fE5DsRNPoSYCkOXJLv1+hULoZmEdt6GnzPQlPdd4IK6zUYc3fVCLs
	 EuOGOBx+O2M2InWCSS1KYdBeoBsC/OT4zxn+J6v0OsMEuy6eBWIEKRL/mZzIpOe5DF
	 sqVPSGq22XeoQ==
Message-ID: <08d70e06-f392-4c36-8396-735ac70ef82c@kernel.org>
Date: Fri, 22 May 2026 10:31:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: fix probable issue of dentries registration
 under /sys/kernel/slab
To: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, Hao Li <hao.li@linux.dev>
Cc: David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hugh Dickins <hugh@veritas.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 driver-core@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>
References: <20260520011019.1707010-1-vladimir.zapolskiy@linaro.org>
 <8a80496b-1568-4a0b-a878-836c27d19ad5@kernel.org>
 <e63e9232-6802-4501-a76b-a0cb93c77d5c@linaro.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <e63e9232-6802-4501-a76b-a0cb93c77d5c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wwu5ark9iiaqb6y5amjstonbkustrdh1
X-Rspamd-Queue-Id: 7BC41C0005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779413475-562897
X-HE-Meta: U2FsdGVkX19/sJIrNT7aeszfOv4oscHdY9Zjl5tlp9ufGdUKT6TGcELdBkRVj7S2E+DiQNPYYOjvKjQzQdNL/DsBn6f4Dw+kdr2+KPrTuQk+02TuDMbntydB9DQZB6JjSX77PI8A8rjesvBV1iTPGypY65c2tmbmemFf30mpKZYUB/YGMBkA11Oy5wUFkIz5gCSjkT+FpvpoAawiDTsyGKXJ0wa5vP692ppU9GKeBt6ynq2D51oPSF25vqTYn9tcEXaC0hpQoWZZoAcMONlZnwJuudI7UOVSfe5B69C47eUwwwALpOIBetQiLRzB/pVA9wcOJS92wnVLSfj0uLcKXOXzL3LWZkWEL4N0tTLnl/INYMaYOMTfHALAPye0B9ovESef3ZY4UJLeXScQnenMaZs/xy6UK/it05Y6NgPYfQHO267a1K0D4lTDZem40NYlk88Itc0Ip56kXn7Y5LaiQnl7Yl9RA059aEjtXuDr7W/bywQnutjf/4zi6casAwl6C/1ymzKIE3CQYNm/S1bzqbjN7YMQ/qQQGyXpkmxPKe/eHIbshqfT2pIfDzSoSZBWN4mYrGvlozWP8GFBqmvdhKAPoSamKJ4+YXo7WJzJ05JKIHT+xMHm9F58me0M48DHQQbCBDu3/GBFQbLtAqWevfodIxCg6EkWpHBO0kyk5QrSfYptXcqnG+7RWvQKWmJAtIv5B4vicUeBUGnUNwIX5GMYuGCTg1Tecg6sNl4M2s6o/+slEXwWdyqMJ7RHcZ4AXJ0rYKQPW/nZljC9FLy7Yc+D7bzGOQgtMdGj9d90DEGn2VwqAQK9B4Wh2UkfbgpPYoGObgmuzEnzHiTUFz2n1oKpLWQjblSApxAHzN2QRwzMNC6L6o8a8pnIBTK+6fYF3lgw5MD1m+xiwuRjqhSijAQzuumQ9BbcySFpoowzBR1+kpo8a6gOo7i9IyquoSvwonZLtf9vPiYosG0YhPY
 cb3HQDva
 Pd+hiz8QK/Flegb1UB1OCRIZAW5E/wuqjav04+ofDBR0VlMc9bj/uqY1Vdvu37JB0KO3L4OrhWHrKK5dhD7ii4JtnfPAfBuP5s8YyTmIQvNvFYaTrGK8PxpU+vmL6U1/gjJCShwdASEZnXaaY5Mn8AuWLfvs1jH4Zp/lBxJLvvP72qWjUuHGn4KuOYy7qFuIfm6ntj/isYlMQmyUGdws3+re2Ha/PMcKEIbGR+QM04d4mYFnxKawqAIRT41vZr4BXSHnz41uUP3B3D1a4HG9GjJC0/ugtZxAyeTKdHGKX/kHHleTlSEy+WbTmSnMKWChCz0H1PELAXmaGsM7zVdVJci80bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/21/26 8:24 PM, Vladimir Zapolskiy wrote:
> Harry,
> 
> On 5/20/26 06:42, Harry Yoo wrote:
>>
>>
>> On 5/20/26 10:10 AM, Vladimir Zapolskiy wrote:
>>> L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however 
>>> these
>>> names are blindly used as symlinks to slab cache objects registered 
>>> under
>>> /sys/kernel/slab. This kind of symlink creation is successful, but its
>>> dentry is obviously broken, as well it breaks the access to the list of
>>> /sys/kernel/slab dentries.
>>
>> Oops. I just loaded l2tp_ip module and it indeed broke it.
>>
>> $ ls
>> ls: reading directory '.': Input/output error
>> :0000136/                        kmalloc-rnd-01-16/   kmalloc-rnd-15-32/
>> :0000192/                        kmalloc-rnd-02-512/  memdup_user-32/
>> :0000560/                        kmalloc-rnd-06-192/  memdup_user-4k/
>> :0000768/                        kmalloc-rnd-06-512/  pde_opener@
>> :a-0000168/                      kmalloc-rnd-07-4k/   pidfs_xattr_cache@
>> :A-0000184/                      kmalloc-rnd-11-8/    RAWv6/
>> audit_buffer@                    kmalloc-rnd-11-96/   rpc_inode_cache/
>> configfs_dir_cache@              kmalloc-rnd-12-4k/   task_delay_info@
>> ecryptfs_global_auth_tok_cache@  kmalloc-rnd-13-128/  TCPv6/
>> fscache_cookie_jar@              kmalloc-rnd-14-96/
>> io_kiocb/                        kmalloc-rnd-15-2k/
>>
>>> Likely L2TP protocol renames cannot be done, since the defined protocol
>>> names are exposed over /proc/net/protocols for years, but the symlink
>>> names can be renamed, because they are yet to be properly created, and
>>> this should be eventually done by this change.
>>>
>>> The problem manifests itself, if CONFIG_L2TP_IP build symbol is 
>>> selected.
>>>
>>> Fixes: 81819f0fc8285 ("SLUB core")
>>> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>>> ---
>>
>> There is also a debugfs feature that would cause a similar issue.
> 
> thank you for review, I've just sent v2 fixing __kmem_cache_create_args()
> side. As for debugfs I haven't reproduced any similar issue, please give
> me a clue here, also likely any non-slab changes should be done separately.

Ah, nevermind! I totally misread the patch.
I thought it only addresses the symlink name.

>> Can we replace '/' in the cache name, without renaming the protocol name?
>>
> 
> I believe that's exactly how it's done, the protocol name is left 
> unchanged.

Yeah, now I see :)

-- 
Cheers,
Harry / Hyeonggon


