Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A78F3D1BDD4
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 20:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6CE36B0028; Wed,  3 Dec 2025 15:14:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44DF6B0029; Wed,  3 Dec 2025 15:14:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81AC6B002A; Wed,  3 Dec 2025 15:14:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B61FF6B0028
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:14:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 581085B25A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:14:55 +0000 (UTC)
X-FDA: 84179263350.21.C1647F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9D3ED120014
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:14:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J7/fiz9Z";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764792893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTtqi3U4Yd0UtxxsPx0vo+qDJdoSXaCVMV097gi/UT8=;
	b=SncgYp+mymcGsJQUUwtNQfRwrWFVSnpZAnQbn9Za+T262I6Qt+tFQVGLBnPMGEXk9Z9hRv
	HGaBVOl4AdbA6lrrRzLteSwS82pjocmogEQTMG8+8FAxQKJfbEIZgsiJ6edCqfajEDvsvC
	sFkk0zrxFAA8mzoQcIq76FmI0Uq880s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764792893; a=rsa-sha256;
	cv=none;
	b=ru05KamWDCpWexqo4JOTVfm74xG0cG3pHM9swPGNIsPTCC50HpxMwKIe8/CQ1aw/4xHbNm
	4RuGjQZPrsw0t7azng8LvcM2/RDNVAQVOt+FFCngIgsYwH4fnVKXfgCLEhmLJNI9DDYRd9
	u2P+iWdXDTeJbF737hCtg0VDLPoJBt0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J7/fiz9Z";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0382960125;
	Wed,  3 Dec 2025 20:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE524C4CEF5;
	Wed,  3 Dec 2025 20:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764792892;
	bh=ht+vh6+16UuYep6rtIc4a8JSt43bJeCIlAY9XU94BFI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J7/fiz9ZbIVzEhO5rTaQLWb1YLUXwZm8iuwrVBWsiVJO091ky6wPDHIDmf3vhDhSe
	 7nltTdMnjK3vfRWGEf69s+AO+6teNjsFIXRvRXsV0r2RynJbKuidFHFHcX1mInP5i2
	 NClqLjj2TViWfJQPnOpmYAp3MQBiZBiMUZlADmG3F8JUYWZysF0I3OZefLaG2V593e
	 gKUoQhQ4oMDJ4QEx0jC0A/2a5Khx52uJGOT68ZK16ImcGsAtoxj0z28oQAH7fvp3fF
	 kblhubcsJQPGoMRy5QYBz20KqMoAyP93OUKeVSYKXDLP9AYrtGf9T31sP4nDx59/cS
	 7BlmKSVZ1Z9Kw==
Message-ID: <f6b159c1-e07c-489e-ab9b-4d77551877f0@kernel.org>
Date: Wed, 3 Dec 2025 21:14:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
To: Gregory Price <gourry@gourry.net>
Cc: Frank van der Linden <fvdl@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 kernel-team@meta.com, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, kas@kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 muchun.song@linux.dev, osalvador@suse.de, x86@kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>, David Rientjes <rientjes@google.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
 <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
 <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
 <aTCZEcJqcgGv8Zir@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aTCZEcJqcgGv8Zir@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D3ED120014
X-Stat-Signature: uo86o9ppno4p5hsyondd8fxjwcbumkie
X-Rspam-User: 
X-HE-Tag: 1764792893-543089
X-HE-Meta: U2FsdGVkX1/XzKVmZvVQvf6mFDBApaYOGmL4TxwvUD4K1pCJ4bWyguVWJvlr5Fv8hJEqdCh1HCZj/PrPyMIiJh1njQJFkPn0rk2Ht9tB+g6acYkuaq1jM76ViDPcZsB79RSuW0wxTsaf6ovqSB5hvXWBm/4CybAq7j8FvwqQgJGyl/Q6TuHFnwPP8DcFv2KXH31DCnZVdTep23pLpb6B8hIEXi6/CVbU/t41UFzAKEmST7oGujpfXypiEruE8SrA3iZk17myD8y/NVnQK3vfSil3tE9j2IarLqszrLSRDnpBRb093k4s8pph1kEsE7IGnZrq1NYTNeGyoob+kRpX7Vo31COxA21N5+Y4wVDjP6JLTpLYzcSBV8o9al6x6YOa98qin4dJA+b56203jKPCgYLi8dwk2k7yEkBNBtcfThzFmbCqXqJSQDp4ypxmL9KdtnLiqQh5JyN777R2rkLCCfkDNrEwK/jRhwIK1fJCKAZCdE25wdvm/KAm8uGpBPwofNm7nLClFGRLb6bMP+Das/A+DdTOkRYwcSGUuIIT58+irsVNTH5TlyM9UFRisqX5SMn2gT6aeGkB8qgSVpUFIDDusylduX68JvPpz2v2fZ2hOyOwKeBojm+Zxw2QxdWyHBJhZ5bz/763HdBwVWDqUT5BDZTjIfluKCGyAv4ZqeQyu9mqppfvORxBQMvC1tM/dsARZ9H+ZVRhGKgyAYmgg+tTbttK0RErVqmrsnY8rIW4V9adXbTtBL6Xm+QyxJgGmo8tDwEzWTwF+Bg+t9KLDbGcSzDLiCZcJqpP5rpvcdUMfPIHCsRBf0xWX0aZ9O4NVvUOOO6fmtRQHB/Xhf4ILnvh0aIkTLawZQknC3+YPLuTZhw0TRu/++YV8t/EQxDBQY+Sq3DNUH3oRSexSSYqCHPMUOLYtmMQrd4WkheuF7jZqL2S/sPbMGJwoNnAl+hrVW/X6aRZ+7GK5XrBOrR
 9jpQd4Ez
 RKMdzrzXDXRb5smWPXI5UzWM8MkGr7qtIqGmKY4A8wLwOfclWUfyEe5RzTJXQH2e9anLzQhFGNyYywkPpKM9Lbwfg5a/kkQ2bDyZiuFm11RcnY6iQNKowtPrAwjmtd0aIfVqJ91DPTDpxDtmUttL/OWrA7mF0yD9LVDm0JCATawBp5LL5NUe9rgQEeRmxm+n0m6aLXSqgHaISpPEY1oNG76oIl+Oc8hy2glWnLKP870uddVFp4X7l6R4/RLQikUN45DCDQPijpCnN7pvH6jyLzxNkyAfh82FKR401L5w8uF3InvK3TP+iybxRJjU5n+byDlbgS79y6udlD7zxwwtJqrLImHhwzE89K4AeHbHOHEIhNwATt+wI7MzTVaKQ3PgQJ245QLn320gY/3YGwopBt5FXtHMsr9xNqOjVYHRqsziHqfecJOI1Chmmkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 21:09, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 08:43:29PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/3/25 19:01, Frank van der Linden wrote:
>>>
>>> The PageHuge() check seems a bit out of place there, if you just
>>> removed it altogether you'd get the same results, right? The isolation
>>> code will deal with it. But sure, it does potentially avoid doing some
>>> unnecessary work.
>>
>> commit 4d73ba5fa710fe7d432e0b271e6fecd252aef66e
>> Author: Mel Gorman <mgorman@techsingularity.net>
>> Date:   Fri Apr 14 15:14:29 2023 +0100
>>
>>      mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
>>      A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
>>      taking an excessive amount of time for large amounts of memory.  Further
>>      testing allocating huge pages that the cost is linear i.e.  if allocating
>>      1G pages in batches of 10 then the time to allocate nr_hugepages from
>>      10->20->30->etc increases linearly even though 10 pages are allocated at
>>      each step.  Profiles indicated that much of the time is spent checking the
>>      validity within already existing huge pages and then attempting a
>>      migration that fails after isolating the range, draining pages and a whole
>>      lot of other useless work.
>>      Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
>>      pfn_range_valid_contig") removed two checks, one which ignored huge pages
>>      for contiguous allocations as huge pages can sometimes migrate.  While
>>      there may be value on migrating a 2M page to satisfy a 1G allocation, it's
>>      potentially expensive if the 1G allocation fails and it's pointless to try
>>      moving a 1G page for a new 1G allocation or scan the tail pages for valid
>>      PFNs.
>>      Reintroduce the PageHuge check and assume any contiguous region with
>>      hugetlbfs pages is unsuitable for a new 1G allocation.
>>
> 
> Worth noting that because this check really only applies to gigantic
> page *reservation* (not faulting), this isn't necessarily incurred in a
> time critical path.  So, maybe i'm biased here, the reliability increase
> feels like a win even if the operation can take a very long time under
> memory pressure scenarios (which seems like an outliar anyway).

Not sure I understand correctly. I think the fix from Mel was the right 
thing to do.

It does not make sense to try migrating a 1GB page when allocating a 1GB 
page. Ever.

-- 
Cheers

David

