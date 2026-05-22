Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5ED6CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CDE6B0093; Thu, 21 May 2026 22:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E49C6B0095; Thu, 21 May 2026 22:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121E96B0096; Thu, 21 May 2026 22:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F26766B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:11:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F8AD1A09A0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:11:38 +0000 (UTC)
X-FDA: 84793429476.22.FA7A8A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE1BA100006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:11:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="If/9CTWc";
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779415897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BUw2h9dAN7gi3R1f6+m5jsrtghP6ZvVS/z2xMuCu2U=;
	b=w+6uH4xYD8GyqIYqTwdl+iGyNmPlKUEia7aYA2fHnv50PrgLkA6fDML/UWbY/JwtxFJFhU
	py/c8YtJWSah3pkq3Rc2C416/tnItJrg25UVXyjq5nYFq8qeffCqSbPngC8PGSg2Yb1CmX
	fECTeNdLhdiAXuEq2MSZayCLF4ja7C4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="If/9CTWc";
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779415897; a=rsa-sha256;
	cv=none;
	b=wLRNqEbuvhztmLbVu18ibSnFUeMi6quBPlkZpOeXziIvwQS00XVOvXoaW6QXRtTVdNAuYA
	e7JTF/X8aYkxvjz87aWlOc7z9wx/f55L1pZwEXxGSQe65gobX3lPYQvG/A4WVVWK3hlNCq
	N55FA4kAfsMEVZMvHpiAPsk5M5PytZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7165D60172;
	Fri, 22 May 2026 02:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926871F000E9;
	Fri, 22 May 2026 02:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779415896;
	bh=8BUw2h9dAN7gi3R1f6+m5jsrtghP6ZvVS/z2xMuCu2U=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=If/9CTWc6wp2QwMOwbvnJwdbAQXmcMuemFE7qADYU6H97FDR9tuBZLPH+O6ku1Ac2
	 1l+sM/yDlFFwAVLn2BQDRE6AB+rDjBRGsK6NVh0l0vUuiJcKSqYAjz7IaaP7bFB9kA
	 6NLPMEjMKpCfL8iSrDAk0wFRc+mBWfcNu6g36UzvHwzDx2/7gevCfSg4pJN9RYVuXu
	 0iZggc5RbaSiCTvVMAuGDhfSb5u0PiOeA7y2EWLC3QUWzVKUAJr+eQN/Ej5+8Wjuih
	 yAyhhY6AVIL7+L0wPJ0MkE53exWlZWAFJM8b1rl/6vYQDP0Ilg999PW7osKeBVP1DK
	 OGkEaP1/V8U6Q==
Message-ID: <00fbccec-07fd-459f-9b2e-23e293790883@kernel.org>
Date: Fri, 22 May 2026 11:11:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: fix probable issue of dentries registration
 under /sys/kernel/slab
From: Harry Yoo <harry@kernel.org>
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
 <08d70e06-f392-4c36-8396-735ac70ef82c@kernel.org>
Content-Language: en-US
In-Reply-To: <08d70e06-f392-4c36-8396-735ac70ef82c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: akpiq1pun4b471stj1m887qutq41s5gs
X-Rspamd-Queue-Id: EE1BA100006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779415896-856477
X-HE-Meta: U2FsdGVkX1/3GmkZw8f2PHKxKWi1agrFFdk42ddxY8HFyTZNaW2WrYZnKGGa8RqsfyLbts9i0Tw4yZV58d6Y4C+YC5MbvzCmOD/gIeErmA7vsLv364UbGrn9Ufkfo/Dbr8BdibSR2Qwk5hFymZcwDfvBzjD8NsWx1LJsnAnW05M/2TnzeuxVfls6KixGpyN9QV9Zg48fmZm/tdZpbmX+3jJpBs7CZXI69sTM9TZH/M7Zz22hh0miYbTJilLPjIiahQHv0WPjPVcF9FWP8MgFgYTFABiTNQhjQUdrQjtyxX3eMJRVCq4Lby5T7f21yawZKKOE4TZpLwEiIYl9oPWb5ZQhJ7Ww9WKH0lKjQ/gydl1Mz0zQBFsPMmdKLd0FjvyoSbObvRQ0uzYBeX97H0cqZ9DO52HVZBHjjbl1Am6wj0qHyIzP/j736ztl3pccMQWZgm2l/fZp+qyurztIQJyOnhGXnSXpCHcS3L4oAcuWTMLM1lvS0mMotTK8/jJY7w2wa/0Jpgt3VYGoG4N4I0myl88XT3OyEynRcf88OFE6fmGisTBc53Jd15IUTHftQC9fYIZQKtx2qoP6N/h/8wXkGPQ3AtYOiMhs1TMHa4LtJN/2W8XYEs9DMausruVecXpDCZn/zGZPH45vPC1Hcsz0ofYW5OIe8Syeq0MeuOojXJxQjOKcKAsN/9RbkHOSS2xzWoT4PHoGxAYfq31ShSGvxmQnzfCMO7GyKXusFjvJ/Qhn4Gv27qmEJslTNX2CbLxZy0MySHnANz0bXaJdjigyQpPlRzcHFwaomQxIyGpeBdQg5qQxcuNq7rJsXe2ZUmBFu8bxuxRNzszjnjo0UwZjLKwA5Rkv2PXZ6+QJdzXg02Ye22Msm9So14mR3FlEqJIVAGGxGBHJugmEZQy1pPE4us1UB8c+VVlGI288lkiHnn/b2goDtz7IOit6dH7XtjttUtPLcQl7YkP4Ad2O23z
 lfwhoail
 7VXGE0+ndLDppCk3BrjVQWx/BQQvP6RXaap8Sqa5t5JzPz1AAFq8OuVQ5ozLxpr8yVfqQK3uBgjrosG2kbF6NB6h1vHgBZif2ted9PLn1p14qSrC2lGTdg4+Lo6UgEFijkf4+heuyLs2wk6aGkyaV7EO0Nii854TUxMSadQ+CRsTWDmSVz3cPT90N70MxBW1YRJHXsdUHt/Ixbg13RQClkaq/a1y0ISI7N8Y2MW5T3fnZg5oJJj3Eb7ee9ONLhdO1aZBYYUXC6lQ+hkgSJR4vJZTWuuE27J1N4vUptlOks6q8vNIbvpH+R61RZlSGfAuKtQzGLTAWto1ZTKE+tqCMHiUbCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/26 10:31 AM, Harry Yoo wrote:
> 
> 
> On 5/21/26 8:24 PM, Vladimir Zapolskiy wrote:
>> Harry,
>>
>> On 5/20/26 06:42, Harry Yoo wrote:
>>>
>>>
>>> On 5/20/26 10:10 AM, Vladimir Zapolskiy wrote:
>>>> L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however 
>>>> these
>>>> names are blindly used as symlinks to slab cache objects registered 
>>>> under
>>>> /sys/kernel/slab. This kind of symlink creation is successful, but its
>>>> dentry is obviously broken, as well it breaks the access to the list of
>>>> /sys/kernel/slab dentries.
>>>
>>> Oops. I just loaded l2tp_ip module and it indeed broke it.
>>>
>>> $ ls
>>> ls: reading directory '.': Input/output error
>>> :0000136/                        kmalloc-rnd-01-16/   kmalloc-rnd-15-32/
>>> :0000192/                        kmalloc-rnd-02-512/  memdup_user-32/
>>> :0000560/                        kmalloc-rnd-06-192/  memdup_user-4k/
>>> :0000768/                        kmalloc-rnd-06-512/  pde_opener@
>>> :a-0000168/                      kmalloc-rnd-07-4k/   pidfs_xattr_cache@
>>> :A-0000184/                      kmalloc-rnd-11-8/    RAWv6/
>>> audit_buffer@                    kmalloc-rnd-11-96/   rpc_inode_cache/
>>> configfs_dir_cache@              kmalloc-rnd-12-4k/   task_delay_info@
>>> ecryptfs_global_auth_tok_cache@  kmalloc-rnd-13-128/  TCPv6/
>>> fscache_cookie_jar@              kmalloc-rnd-14-96/
>>> io_kiocb/                        kmalloc-rnd-15-2k/
>>>
>>>> Likely L2TP protocol renames cannot be done, since the defined protocol
>>>> names are exposed over /proc/net/protocols for years, but the symlink
>>>> names can be renamed, because they are yet to be properly created, and
>>>> this should be eventually done by this change.
>>>>
>>>> The problem manifests itself, if CONFIG_L2TP_IP build symbol is 
>>>> selected.
>>>>
>>>> Fixes: 81819f0fc8285 ("SLUB core")
>>>> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>>>> ---
>>>
>>> There is also a debugfs feature that would cause a similar issue.
>>
>> thank you for review, I've just sent v2 fixing __kmem_cache_create_args()
>> side. As for debugfs I haven't reproduced any similar issue, please give
>> me a clue here, also likely any non-slab changes should be done 
>> separately.
> 
> Ah, nevermind! I totally misread the patch.
> I thought it only addresses the symlink name.
Oh wait, no. I did not misread v1.

I meant debugfs_slab_add() creates a directory under 
/sys/kernel/debug/slab/ based on s->name, so sysfs is not only thing 
that's broken :)

So I think we should either reject '/' in s->name or replace it with 
another character, or let sysfs/kernfs handle it (as replied on v2)

-- 
Cheers,
Harry / Hyeonggon


