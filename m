Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFB4E7E0AF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6576B0088; Mon,  9 Feb 2026 05:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2737E6B0089; Mon,  9 Feb 2026 05:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F6C6B008C; Mon,  9 Feb 2026 05:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 049346B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:01:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1F68BADB2
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:01:53 +0000 (UTC)
X-FDA: 84424476906.14.A17A782
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1C328140003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:01:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o+6YwqIR;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770631312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnanSNvsOGVda3/oY42ThE+rhpyr5W9/VuGNiunT2e4=;
	b=G0HL3eIcH+BJFm0+B4aVqJb1UzuxSepLdI1ATQ8oq8l2/MChXet8UQeP0yl/2xg+5oxfgX
	P1UrttDPhykG6vxRdwkt8w7akBMYQxKXfUVvTuLnZvm3ARlNz6hJDJFhZodorooODHeInC
	+4UE3qo/vQ1aegdnZOxJiu4IkzDgFp8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o+6YwqIR;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770631312; a=rsa-sha256;
	cv=none;
	b=uoUtTU6OGaHXOSZ9GBowzcUUFKyAIzKuRmxOB4rcOilgtripsOACc8O0gNV/6N4BOV1o6g
	tSmZPyklcX8XY1a+BhBPJqvBAF/cLahQlRY6TgfW1QYYAsAGo3MCjaeUis4+uTx4GLG/v7
	OfHjPpLDI7sB+q66xaXNFX3qIu7sPWM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75911600BB;
	Mon,  9 Feb 2026 10:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A224C16AAE;
	Mon,  9 Feb 2026 10:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770631311;
	bh=92L8oTerNxwiJBJ5Y3oAL/m4tt7fM/2hqtMOf+F3OJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o+6YwqIRuDuLv6T1THpzWj7KbUUhI80bMEwjLWEnt4MeA0T3GoYf4LrmvLWPRfSc/
	 ma4xN/OAPLI/NITdSi/llXZixpAsOzPjVeJN4dkrkcJ8v/l9sMTyfM1aj7LHzjewcg
	 eLFoYFL2Qt6ME8GwyuN3KY6dkKku1V+wzU6rX/vNvWhe7E2tYwefvIGnXIhVv3B2tf
	 IpTbVfd/REBG1R67Z7gc5FG/w4b4Q0vevyv0iy5N+LbkgQHjtfaKFgeIEcdwPDLjju
	 mbTHu1oG2NO9Smyuatqg+fteB/Y0RLOBGXHA/O1YoZWkC17ChxOvAtGK4VSrVkhWEx
	 eYaSGZCb2C6Gg==
Message-ID: <2f1bc7e6-a981-4467-89ef-609080436286@kernel.org>
Date: Mon, 9 Feb 2026 11:01:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: cma: Fix stub for cma_skip_dt_default_reserved_mem()
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Mark Brown <broonie@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Rob Herring (Arm)" <robh@kernel.org>,
 Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
 <CGME20260209081154eucas1p2ce1f3c7bd5cae843fd60355314c8d4ce@eucas1p2.samsung.com>
 <4fc5e312-b56a-4664-9722-81163ecef515@kernel.org>
 <67426771-7df6-4544-a77c-97f44ee08d99@samsung.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <67426771-7df6-4544-a77c-97f44ee08d99@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: neok7rsxs7t1kk8jcga6a4tbi1p18yhx
X-Rspamd-Queue-Id: 1C328140003
X-Rspam-User: 
X-HE-Tag: 1770631311-820879
X-HE-Meta: U2FsdGVkX19t3FXbpgXOZ8IuKa3yLPvrALp77SnFu/tQO4psBI1VTguMjbUmBw91q5Eqd44zz6QwyKooqCEteWrVPX1Yi0AWVcYp7qraWqJKivNcvTij4w3E0jRbuoKEk1dCFDV9N7a88YX6C93IVR6BspLWx/gFBt1PiGHWZkN4+jkzrKZrB11w/sTpz6+pLwkyNwoCTf8PIW5/iJIxdwta4gqScpOkL0XokO1CeGxWcxY3rLfmBcXeS0QodsSts1AzltROGSKcgsikVopLO4Hqo4DfAQGMFUJxV/rPu9RxLu0toRDWgyzvTXj8z5MurCTHHsSCwe3KhDzwG3uho60/EwuZZt8UQaRG2g5xa6KTbQwojh2yxI6OW/7gFUducrLK4/hqlidHeDcwx9zRa7VsNQwz4WOxzKTe70LPW2e9g3rwbAxOeN++DbhLIUkRTpmD7qFOzzVNoq/9QnK3geREgjX5RcEYKdNi4CB9Qc75rQvseHTbi1l28dSlxdwrugnEs460+K543avdlQ1jtRWkMW8jSrnEi4g9uLHlZLeEcLSjke4rPn7y08VJ+1a2/itrfL4Vq6n03M0uDT3n5fZO1FH9DCFYs3/UzYcMtHhYColyyFlCJuTuPqQsdv/WJZoxlOjjJxTMd+EbQ0ILpJ4Ftl4XO0e4JdRtKkuQ8qgKjz1kHYj6Pg9cEYPOCkwFK7fa177UDCuwmAlR5s4v2K2D6JktA+3QCrsmPxqdTKJXXrqYsbB4rGy3dJ5xtqhoj7uTgD1shMiOqdHqB0W2ZF+TjaOdASOiS4Cw7FQ/Smto++W+bhsddUg3k3k+nR1DS3XoMdDEcMrQJcEClVpvnJ7hogeIZU50v7xmxxHcLzQeHPxQSgw4J4cH7SRtQfvRsM3lENDqu50WCpPgvBf/4I8nAbbRbSYmEmZfze8HGQ1mxa3F4vY/gQpk7hZuMuz/qrWu3Sgkm9w9zCpl4wm
 lFb/bcSS
 Vup55jMD/KPYIRqB28WwwejY9eBjknNosPHr+HbpGHN9oxBqO2Y8Om9AZ0g5keAYx7zRlsjUSvvF8SRpvrxmu5Sw3N9K8FgD8y1rquSAWmXybiurpwNeRvtg0EN07/Rrw7sXWOaCW1LreqqwQ7btUZXRw6EzKL7exdOSss0aTw9ZRCjdozvVDL0oi2ZCuwoZPOWRq64AfzCUtLTroOjEya1Jni+QY5wGMUIgMn6fMDoNhgdAehpo4/lGAwIF3YNPTtL6+Zk7EWZ5MObKM1ryGrh5OoeuZQCqnclk5+0miCA/EFi5hplLif3DFBQAQu/feNlpbtrbWDFm7jkpMameWFT+EYyaKBxrJAwKZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 10:59, Marek Szyprowski wrote:
> On 09.02.2026 09:11, David Hildenbrand (Arm) wrote:
>> On 1/28/26 17:28, Mark Brown wrote:
>>> The stub for cma_skip_dt_default_reserved_mem() is not inlined so
>>> triggers build warnings:
>>>
>>> In file included from /tmp/next/build/fs/proc/meminfo.c:18:
>>> /tmp/next/build/include/linux/cma.h:68:13: warning:
>>> 'cma_skip_dt_default_reserved_mem' defined but not used
>>> [-Wunused-function]
>>>      68 | static bool cma_skip_dt_default_reserved_mem(void)
>>>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>
>>> which are fatal with -Werror.
>>>
>>> Fixes: 26332ae848f08 ("of: reserved_mem: Allow reserved_mem framework
>>> detect "cma=" kernel param")
>>> Signed-off-by: Mark Brown <broonie@kernel.org>
>>
>> $ git show 26332ae848f08
>> fatal: ambiguous argument '26332ae848f08': unknown revision or path
>> not in the working tree.
>>
>> This is not upstream or against an mm tree. Against which tree is it?
> 
> The fix for this issue has been squashed into commit 0fd17e598333 ("of:
> reserved_mem: Allow reserved_mem framework detect "cma=" kernel param")
> and merged to v6.19-rc8, so the above fix is not longer needed.

Ah, that's just what I wanted to ask: can this be squashed :)

Thanks!

-- 
Cheers,

David

