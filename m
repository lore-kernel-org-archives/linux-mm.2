Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46AEA107760C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7739D6B02FB; Wed, 18 Mar 2026 15:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7247E6B02FC; Wed, 18 Mar 2026 15:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613AC6B02FD; Wed, 18 Mar 2026 15:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3866B02FB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:54:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15FE31401AC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:54:24 +0000 (UTC)
X-FDA: 84560235648.21.268002B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2444F40009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:54:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S3sbZ6gt;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773863662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCNTvTlPvMR0QJ3lGwxGT7rhzdf7d1F4mJuoWNTiU4o=;
	b=dvGWJsBd1XfPQP04tN8H9yZgmXUzWdglbEnGM2c9emwnTSlo4nfX7LlY5EpkuQe0lljznb
	mjwf9LpgwlJCnlMMtUy8TXnFtuqCd6+2203uFQDwlblZclPQhkEiMtHvenKWrXmUGErisr
	+uvg/613Gp6sFeUX7L8UaTneUcm5UWA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S3sbZ6gt;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773863662; a=rsa-sha256;
	cv=none;
	b=4sv2wbn6iKVDWYR7qroiJArSVhKxf19IgXkpLERgVHAFQqjQtoWcQfYXKnL3Jb9zaefVsd
	A3aBxVA5FeZH9jxP6OePUJlLTUf0X1YTyrmDYHzDVFCrGxUQeM53LS7Su1hG7Rr4plZwU+
	NPh+Afs3VIhQKgp+IHb6Xdisp2SrrG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30F2341B4B;
	Wed, 18 Mar 2026 19:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683A1C19421;
	Wed, 18 Mar 2026 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773863661;
	bh=DT4Mz3DDj6htEL5Nqp9As8IHUzKVQU11FGOLp/K2lLE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S3sbZ6gt+QC3WiK0flaGgVm2aI/g9vr4JWIJnUOEuPd/PzVKkIwdBccp4zCEabn9z
	 d857X7vNhbVjsGlONjgzgqfq6pb0Ttz6H8GXCT7WHv9PoDSJawLj52Rh1uzI9ner8B
	 0ihqd8CXClCSC5/+lWY4620vo2exok9pE3LaFvu0L02p3I+gPN8wZpZY4ye5uw2w4V
	 dj8IF2dPRytV134HtW44mn2y97MOfpt69yZA4h+fDjeVEoe5oPUa+SgdBq+zo4diqg
	 c6WrHKAfRaQI0swTxuewkUljlOkgemWai8Sb2v6or9HgLvFs1BPDhpNFVDZm1353Co
	 xMvNdkQply8JA==
Message-ID: <0fb0664d-8483-46a4-8249-1cc1cb55a979@kernel.org>
Date: Wed, 18 Mar 2026 20:54:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] mm: memory hot(un)plug and SPARSEMEM cleanups
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260317165652.99114-1-david@kernel.org>
 <20260318125148.b137df94f3c3398cf453e6c1@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260318125148.b137df94f3c3398cf453e6c1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: soyrezwqi8sogs8cnasmba4mwu6hmu36
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2444F40009
X-HE-Tag: 1773863661-41694
X-HE-Meta: U2FsdGVkX18BqvrCZuF6TV+EmjQmNGfU1jLcd49eYcosJ+YWB+uGNT4nf9tOGLo1hImIdhmHIiXsL+CBEDQxVPFIc30YHz14ny8o2ondSVkK+VdebjVmOU+3TIqzeUZWoK84TIHArZHXw0Me4YsiRnbKY1yxcPInoc41b4f2WvnVOupTByTqzxAYLwlE5S85aiW1YjeR1M21IsbLO1hVhXQ5SXPf/3unFI0RnewpE1SYQdKmKszX2C8X7DXmZPiJY5nyHi8cWMiUAbVH941RZ3wj79qXI63C3XT+4uvJR690XwEWAR2u+N7qUS3z/3tltQxU+7h7ufjlbmOnzCuTwfRE6qzkZbTI56Wp+D4GkPbgoLtI/mzh2z7vDigTyahfITyldzTn0G8GDpxSoU1EBvuzZ3q901qDf19xotX60Xk3slxphTgrV0JV/bTrRU2zMDB2LnwPp6mLrbZomjxCGkT6+riHrrC7ONIcj9/LIyDI4fz1MX+Iw9xn8/3PBznYTq/VOpKL4/UGEcZZOCtEEfeHdY8ZsL5wOfmhJ6BS69qWbZMHj/EiVnUpBoiv/4ANgMzE8nQ9W499XZudr4IWBY8Gv5ClAcEH/0A/DEFuBW64viKyovoWSbZGVq/bFNYxoWvutpNx+OQe76zchW5SNMlfAiksYClqUHDBvaxFFBJwnROyNc6qz3zZvmJrfdYZHiLwJVsFeCpUpA69jfJy3QEGbVXAISi7b70PGYg9d9qn39yHtwlaa5uE/aeNuXGAEf8q7iX15o4qhrQCqVkPeIzwXxpSymLWEWRPKIw9elgjhU1piYywnTZ/4E0GOuw/f/cqRoTP2Wj3QSmBCa7naBFbpKoRnz0tiEoY6mAjnvkd4G5uDzO5XiTIzaUUQ7qMJgWXvZK3LyMVkwWlcSi0EbbTYczzCmWalp1g4nY46QcVCvrqACl4yLacjNFaCt0/xnL3kYyin3+zv5HR+jx
 9THqED+H
 3YsASp4Oh+iGupIZShclhRls4z+5W4zR/raDe7PwIK3trRPt0z3jq/9+VA6wwmg3fVqUVvnHB3ITUymgj0rK/7LRQMRKeqizPygcpdkeLlIT292wBI86JNy8f0cnS8eAM3mFc7X7oXn06whGUymwX/ZPqCXXmibhzFW+7oSddNJNeMKRYbGUM+S/FNDpDAQQw7OJGdQpoWoLVOnUxKi1sKhcTEcUKpNJlhulAG18mJJia3F9iBW6GkPKr64T1GmpRlOsg86c0pa+lMBPFrr9zkkP62Q5tobGRYiKHKQolycETXoDzMAfnxN4IpHvazi6mco/5otG629LiYS2z/ZKD6SW5uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 20:51, Andrew Morton wrote:
> On Tue, 17 Mar 2026 17:56:38 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> Some cleanups around memory hot(un)plug and SPARSEMEM. In essence,
>> we can limit CONFIG_MEMORY_HOTPLUG to CONFIG_SPARSEMEM_VMEMMAP,
>> remove some dead code, and move all the hotplug bits over to
>> mm/sparse-vmemmap.c.
>>
>> Some further/related cleanups around other unnecessary code
>> (memory hole handling and complicated usemap allocation).
>>
>> I have some further sparse.c cleanups lying around, and I'm planning
>> on getting rid of bootmem_info.c entirely.
> 
> Added to mm-new, thanks.
> 
> Sashiko said a few things, as I expect you've seen:
> https://sashiko.dev/#/patchset/20260317165652.99114-1-david%40kernel.org

Yes. I'll respin later this week (only small nits and taking care of the
existing weirdness in scan_movable_pages() in a less ugly way).

-- 
Cheers,

David

