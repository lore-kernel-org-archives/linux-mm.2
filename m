Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5533F1091908
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A7E6B0551; Thu, 19 Mar 2026 14:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CB2A6B055B; Thu, 19 Mar 2026 14:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA3A6B0560; Thu, 19 Mar 2026 14:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A85F6B0551
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:15:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E9C98C1D6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:15:27 +0000 (UTC)
X-FDA: 84563615094.04.3E78B51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B8D040006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:15:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaPGo3Ex;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKXcb9KIfZdVdbTQax0K3U84o2RGNNNw5DXPu+c0f90=;
	b=g6G+0zvQomJTMpZ/zrw5xG4FTFQOP8pjCjbh88UB9Qz5KMUtfk4+faz+XBOkjSi9j1qGkd
	oYB80w4vLovaPsXL91VDJuqlyY2pOPASQ+IJGRN4erw/N6pHKv1kVs5Nys3GFrazCOPGwb
	qfrvcjITAEg79BN0CAsUzFSih+nFNbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944125; a=rsa-sha256;
	cv=none;
	b=kB4U2YYDx8Me3MhFC4ZzoVVuGdsBZZkiveD8s8lJEi0EToS/QVIGe4JYtVURAYtVItWSXJ
	ZXB5rvWX1pmPklKezI5IgzGk8DijeUkuQqb7Z37JOffZ1LgIbm/67juXcs+e5dHU9ejOle
	OstLAKOL0i0VTLIgSChDS5nIHzHqevM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaPGo3Ex;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 046A143B8B;
	Thu, 19 Mar 2026 18:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FB8C19424;
	Thu, 19 Mar 2026 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944123;
	bh=5DhJroPho5HkyxwhM6V6zbgBvmoqML8NktMl6KS/Elc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iaPGo3ExscR6X7srKmPzvgCbo6Wpln64H40NZbIw1mmdGUiO7xBzZelVKxrAP8hpi
	 2vVOf6WBMtsAozeBlYtBYs8hdJNPqG0YZEA107tQQg9MKlLMutTpHravhxjMDcowXf
	 tA/iFu8TjynZBG1HTrAFSqnzJN3Y7KRutMGsveHzIp74T0E/87sgOKXgNZLUoD5Qi4
	 HPDcXpdPqOzEx7CNngfzW9FfuJzso80Brjn9rmXrL0tNOxBz73IAhGO8ChAqMSUSyr
	 ZT7pmmQXVCL/A7n46BTPQvTC5IGpsZff4s+AaNRLL9q4IET8x86CS71Zzk954mQz7r
	 u2kNtJEBsIsLw==
Message-ID: <feaf8a33-c716-418a-af32-aae4f1949a4b@kernel.org>
Date: Thu, 19 Mar 2026 19:15:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
To: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-1-42270124966f@kernel.org>
 <abwVK8nLpSLVcT5G@gourry-fedora-PF4VCD3F>
 <e166588e-036c-4fa3-81fc-d7aca9f02c29@kernel.org>
 <1559C268-444B-4A64-A0B8-21B2FE49A5E2@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1559C268-444B-4A64-A0B8-21B2FE49A5E2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fdhhdxsynbg4wpr9zc53ae9jr4nt6xef
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B8D040006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773944124-766772
X-HE-Meta: U2FsdGVkX18LGAV1YpMGwwUOeshMXTJeUquVZotPNHTra9Te9hrd1dJ/Mnx2KQLfC6uFfFIhU3gbCmhpJWnCtQYiXYajgQBJG0y9vkAU1ktfBs8yGmimK+OyeNDDKGjzsd8qVzs507ZtB6/ODq7gQ38bhAuaS0VZW2/htFI8dA+jy4rLY7Qbi2Fg7dERHmcT3hm1C+HyTHPPSoNx5y6wvbHVRxi1snkaKQoegO51z6TWCjFxeI/Z4mhVBuabKlK94+amKh/iLCOFqAdZ/3ii4rkjcKqrCvPRtePMGfl5l+uxeVFKH/h7plcJi5/IuWosEhKVKjG9sP35MexxMdYJEyC5X+PBwMxk6Ccy7ln2xnoRVwXPRT63rhL5OPVmiN3wg5+4TywAHrT5U3nxgUmuanSp0jzfISVFmRZNqbwc72Hc7YcFfKy1Mh6fwqu1EJSwV+k5vTmGPkjg8TkIgh6E05DRYrL3c5MOXILuPHhIPh0osBThMZedwPpxDP057Tv5Z75ktoGVzczZ004Kh1oYpVgqk6Pit0wYk8Es20udA0f80mzrYQF0Oy63QRsNkoRBgiTiyBhEZFVmxhipJ8NOv2MprIpL8UTBKJFcwh9Ovbxht/jqKTxZPAtZi/m6dD/0k6QrMcTWWOuljZpmbATipe5vgbsf1szfKt6Go7ly/JexdLvtMlUevmanjqBttG85IEdM3Lmi8b7LigXuaOieHD49aHXGKyHC4KnXMFULYsBJR1wQGSCadDLxCkHLHcNSt28s3AgTh7Lwqze2gkbx8rTvYPdOinLFz9ISifVmnSlz5NLL/hT9EZgsUlQGEveLsuNa0dR+NrHzhZdULY33uVOyZ0j2sn8AA51IzST10AAu6MvztTtcemUEAWJwIHc0iPox4VjTJpqtQ/sfo2vHH8T6eVKihIWx22iSWHcnGzOHhmpPz/yKmWPH/69I+dY0FmHIaqWMCGzW5A4kyZ5
 JdNiZ4CO
 paal52AwQOaQZd5TrB10VZ0kXl/avuXuiOSmsQBpOT942KiqMW2xDdUHkK5t2kA2PYgZjKyKKHW01xN956havyJPIwJsCIPDmIpaqcsJr7ziz8znu65s5II5yZOXAdeFVkOAgao/I0bvzHgK6EfqegYJgCTojG0eMaXZMabN4nw5a/4pexQtZE1VMfGzjN25JMzNyun6iuv4xAgvbsT/uq//uA/PilaH2LQV0v0DQ5NZIG2sJNLHhR5qd/ja6jSDk7/aReKqdQGn57oGW0fq4Hmruzq6F0auMfWB475Qvm6cjCGX+fbFFw7nd9Pn7rR8ynrm60E+ryharI/0oHH+2hBUXyd7eHcMEwzk968xlQUw+wqRTApg23CWtOax2ffZzdIfl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:12, Zi Yan wrote:
> On 19 Mar 2026, at 14:08, David Hildenbrand (Arm) wrote:
> 
>> On 3/19/26 16:24, Gregory Price wrote:
>>>
>>> HOTREMOVE has long been a thorn in my side, I appreciate you cleaning
>>> this up.
>>
>> On a long cardrive today I was wondering: do we still need a separate
>> MEMORY_HOTREMOVE
> 
> You mean merge HOTREMOVE into HOTPLUG?

Yes, only have a single config.

> I wondered the same. Is there
> a reason to only have HOTPLUG without HOTREMOVE?
In the past some architectures (e.g., s390x) did not support HOTREMOVE.
Then it made sense. I'm not sure if someone would want to build a kernel
with HOTPLUG but not have the bit of overhead for unplug+migration.

So I would guess nothing major speaks against it.

-- 
Cheers,

David

