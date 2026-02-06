Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691DAEB28FA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2CA86B0089; Fri,  6 Feb 2026 04:41:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D009C6B00A3; Fri,  6 Feb 2026 04:41:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17406B00A6; Fri,  6 Feb 2026 04:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE58A6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:41:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 589ECC15B8
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:41:55 +0000 (UTC)
X-FDA: 84413540190.26.F21496A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7ECDB80006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:41:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RUCfLDqu;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldGTQnCdP93ZKMLJ0WVYjVKXTxQNI2LiwEL3XwjMBkY=;
	b=XRAsqCCl5aWX8hZp5ZA2nciuJz8uXoQlNfS+yNPHBH/trlyRcpW/iDPJ5bKMjvdy32BG05
	5JUYVM1PL5fGhZKJnPysbWA0hAyFk9HpuYwSafRcxEX2VaP3Tm6pBA8xtK0bf8RbPyPB4c
	ZDW5oC7Z7swx1cC+ytTO3gR/vMbpQuk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RUCfLDqu;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770370913; a=rsa-sha256;
	cv=none;
	b=l3yXFeHshPyuqniqIcnpipl4LWQly9NUgQi2kp5Z81kOCaEYohDocA97ShDEOwrjA8mw7Q
	tqaCwgiUF/JUI7OZD/HSyYyLlDQguTcDIb0fsDVDsqORdkyY11IRlfGx0dLn2tvKC4mHEO
	N1241J3n+Vt1M/EUetAsjZgafOIV6+c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8211143F58;
	Fri,  6 Feb 2026 09:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6227EC116C6;
	Fri,  6 Feb 2026 09:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770370912;
	bh=83rnD8t3DNJ6QPw39Ew9UXjnTNb13axZkWJb6v64MTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RUCfLDqu4SJx8/KJLBbnt2bOOruTXTFBRj3zfNkkKbLB/6TbEbz0Zv7LmeTW5kEb3
	 Ndti+ks1LLtKOQ5cKLBEoSYmrf26R1l/Uieb9s4ACUmCYAxAaOt6RElMgtu/NSy0hQ
	 ty0IXApx24A3cS3dVj8/zxAYlnOkfwlb+8O3YqzK3kuc9QEJAeZJOMpnxjfjzfpGxG
	 ZS+aq70CmWJNi8hzlzLfgMW/SPn0Yf5MY92b5kkon/PPpe4z6LDqZq1ydO0FYbYQsR
	 vVER/vc/M3/bb1+mj8BjP6ZAph5B33SqPo6eA7qvylTuEdkb0Pk1HbEic1QMOi1sPu
	 GivGlnw+Zi3bw==
Message-ID: <f417576d-ab79-44f5-99a1-3f672b490bf2@kernel.org>
Date: Fri, 6 Feb 2026 10:41:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 12/17] mm: Drop fake head checks
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-13-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-13-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tagzna5d1r7y498w3apn451brfirgnq3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7ECDB80006
X-HE-Tag: 1770370913-466761
X-HE-Meta: U2FsdGVkX18+qKT+a7R15UUDRt5qOWyRQE0aseizWcehrZKeFUcPljY2JI11TrwpJhstUJTvPmhLwGDUbIJ3WCDDX1Mmp8HcZEsDuqOIVcau2oNGAspuYn/kWAywT6mCh6wq2jUsEiWDZvQdtDwinpKZcxM9WGqFFneW7Ij1dCKN9QZwWHyfX7fDUPl9E200j/V5g0dOK4WEvDdd2477H90vuN+oWAw27rU6Otv+p5/9iszpSGbz/zBigCASrZUi0ma+oEDbMsYbAOIToCrcHeYHOYsa8qTZCShHfwrSpin8Xqb/k6+dZ4a7RWxZicYGG5QVHUYtgMBS2ThwES/qKwhKejOzpzh1xaT/0At6rCTdMwMtEuU+G42phoU10mlHw6p+Bk1AFF4VLljVtQxoC1Qw1lS4c/Cgl7gVnW0+rD13BndGkIYINcw5PEtSn8s4rCxyPEmr3o/S5GG0dkFYSJKSz/cIDYG+AsXBLJ24/uh8QvnBYNrUtY/LQ8IlgMG0Ff/nTFevpypZCXMyQoCDZzBgwPIyDxQ7gFZNKh/BGgUyiwPt3CHH53qDpkCm7k5v+y9gpZCjsTp75EjhKKJOly39Ch+PhR5v/NtV1p6vA3336kcMynY9OjmjZ4LMnTGRpE5bXGLknilvL0kzIToIe2DOR/c6tQFbRHXvfsROkM37amfpRy4o80njZKwYWfl1TPsiQh8J/gLZKro6yKDavhZY1hZL7k5r0x52qXbWusXjzSVBCxRrrurpUz//9s9e5qXVzdnyKkw+IatdRm9lKHs4OrhMQSMpIYyv6A3TYPa+XtXGE640QODNn6HdPMYws/izNullkHpL0qqYrs9PdV67/xhdx/rTPRpxSpS/vafGuqkHplK5CXOJFFDnlJA2xxKk17aw3DPOdR4QYiu5y2X9z04lSvDZybv0Sd10zRwZ1R00GypH5gHDGC6Smve/qFtTrQ6WVq6AP0fWRew
 rFI8rIAz
 tfKq5REKmghw73ujs7ghmcdpMG9SwLpq2CfkHuE/A5JyzRGmcqemctwDR3GpomUiR/X0oMgN3hZYnwywiZLf+YT2/0cJ6tBcXKy4XSgtXhh8lw9qCy/3e2EjCwC/NaulzXdFn2mTpsXHOxCEo6bBFgLOHhM2wuVvNiMUequbvIjmaE7CR3vM3ZU8OhvCVB6QKDSY07w7a2CLUMJ0jjfuoUd5oNIpQ/nYIo8Hx2XKHMDbDuqoM5/zpK86vePuHx6FN9PfVLtRZMBofutsGAYvpDTsU3mlsYfireRIQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> With fake head pages eliminated in the previous commit, remove the
> supporting infrastructure:
> 
>    - page_fixed_fake_head(): no longer needed to detect fake heads;
>    - page_is_fake_head(): no longer needed;
>    - page_count_writable(): no longer needed for RCU protection;
>    - RCU read_lock in page_ref_add_unless(): no longer needed;
> 
> This substantially simplifies compound_head() and page_ref_add_unless(),
> removing both branches and RCU overhead from these hot paths.

Can you say a bit words more why RCU was required and is now no longer 
needed?

IIRC, it's because we now no longer reuse the real head page (page 0) 
for a tail, and there could have been a race where we could have 
attempted to write to that page0 while already mapped (r/o) to page1.

Also good to mention that the corresponding RCU sync will be removed 
separately in a following commit.

Nothing jumped at me and it's a great simplification for core-mm.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

