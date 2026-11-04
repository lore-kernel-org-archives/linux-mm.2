Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B51606A333
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cwqHozyI
Received: by kanga.kvack.org (Postfix)
	id C6F716B05B2; Wed,  4 Nov 2026 08:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9A16B05B3; Wed,  4 Nov 2026 08:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99436B05B4; Wed,  4 Nov 2026 08:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0BC6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:37:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D27DC074C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:37:52 +0000 (UTC)
X-FDA: 85397539584.06.311BAF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BECD51C000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:37:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwqHozyI;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793799470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIRwlWq1POK80nPhJP4wZpDMtEESF+NRtsJgzdhVq2Q=;
	b=BQiYAiMej05BKJn2VlJlEl/SbTfwqqRwMmMfPe+Ik+xdZMqagoY0g8+UYskzlHr3clcHHP
	3F2RsWjgypH4ux/3DMpSyFpMKJbIEi22/O7zbqOZwe7sSUNMFxWORxo3r2mbdlmuPf4z9g
	ZLm+vjK2pCjadkegjzuRNgaNPX+TgOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793799470;
	b=jXw5Bo3Rpsfq53EdKw/IN2NzForFkhDerKOczF76AwfRzd/szus7QV0icplZ7OVEk9u+6q
	L6SuGHwH6vSspbE4BPHoqagktHra9DtFL+2ySMJi27snl/2/5iBxAZzkcy2WL4GXsaqZTu
	5ZdlFFeOYxSTjw4PAOPAU1kXip4MF+4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwqHozyI;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BBE460DEE;
	Wed,  4 Nov 2026 13:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9751F000C1;
	Wed,  4 Nov 2026 13:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793799470;
	bh=QIRwlWq1POK80nPhJP4wZpDMtEESF+NRtsJgzdhVq2Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cwqHozyI+ycDGjqocXr3v7WBJevddi1Lm+mvjsW4ZILeiZFcOYgijmp3MZGE4bA7w
	 mQzS3/yVPBzmu5AotQVz4CKV6CUpIpSE+gU0tDzS93Am231SM9Qgr0eUwqpaqunlhX
	 SA3Z5OfMOWVo7ICFutTgALLBphPSNbZjPFeZBqpCX5tGlrkLW7+zyyGEjl/jaGFNC/
	 ilywGHugTe77QeQUPBE0unTEsNcljWGsqcKgPv0sJ2gXZUkJDitaRDKL1S/u/Ckrge
	 r97Ci+PXClHHhoby5wgFqej4yypQ9CR0Iov1FgLSmPzVeJ5j8IniLSI0Km9XEZrXvn
	 YmI95RfThFacw==
Message-ID: <287698ab-76dc-4aee-8e6c-db1f5d18974c@kernel.org>
Date: Wed, 4 Nov 2026 14:37:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/rmap: use release ordering for small-folio
 mapcount removal
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Richard Cochran <richardcochran@gmail.com>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:PTP HARDWARE CLOCK SUPPORT:Keyword:(?:b|_)ptp(?:b|_)"
 <netdev@vger.kernel.org>
References: <20261104013139.1341582-1-bobby.prani@gmail.com>
 <750560f3-4c5a-44fe-b72a-0611be383f32@kernel.org>
 <CAJhHMCCu8ehOU37_4UpExNO3U8YPygjnht+2S+axkxTwY8bx2w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJhHMCCu8ehOU37_4UpExNO3U8YPygjnht+2S+axkxTwY8bx2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 5xjchkt61uf69mxui3uwuy5pm5x465wk
X-Rspamd-Queue-Id: BECD51C000B
X-Rspam-User: 
X-HE-Tag: 1793799470-137058
X-HE-Meta: U2FsdGVkX1/E+gcgzsVf3PHVdITIRQddu5P/3eGP5+stbqiM+GXYMu+fA7JmYDc9flufdaJt84d9fl6L0AvysgediPp81KQcRfPGEepK+Jq4Cf0KqqkzmvY/V5EgibTsXFZOix6ajMeQUrS8/wHYM23bAzfI+k+k59PmYAJiBlkh2k5bC3UjrwtG5qpRNNKkCoWZs51nCcKXFOrL1/tMYjvYhIuAdGanYUWwJ0cENC2n/B9GjRHT3D8fHK4/iww6Vjny54ZmCZ/pPVVUAhYKOnCPnbDx0/LhGc4nDSXu7TSJnB0jw6qATrPvdWze/cLyxzOivMtCMX88+cZEm1h6hfG+qY3XcnkTaFY3qCmCJL6jJX5i3njzdCtM+BodypBNZ1I2O5fUMq1yHZTG3Qsdi79/bzMLC0s53u/q/uTFzs7GKBGrPxvrwNNWyPklvzY0VhvyERQD24Gxo9bTcZyKzVvBRmcKSSI75gUKfpgNytXGcnfwrT/gsegEC4gDgTFv9icVc4MjGHFMAcsqtPUJbkToh/v22VZcfuXUdpqbNheoQsRmkZ5knoKPlNEjcpoSfgBNu0iN9N1+yL4cyPmK57Ua2jXUjriaHP1aBPFXCsaDRlkTxCpsjQF7DNH2nXR1/+lAdUst3maT0TwWn+SMm0HPKnoYT10mlXrwM62ElD05TpivxrrkS4D4NRYs91tDdgiUn1VXyOU3h4y5L12VCgm7aYYRBf5b3c1UQD8YsrTyDZyVTNp/Bk6vVbGHKjlPJ3D/elE3w54+juw0UYCbTtmpFEqqdhBXfyDzjtsTM0aFAHsYVCEa8VPCgRRSfLN5Ivn5WWD0Kk7/b8LK0gbZD/a+vox0fIqyik7NhcRyxq0mwYPyruHP8LyZEG8iofTiWD1YVszFD6AgLPlI3LKpb1vNj9hAjcuFzNxNJzuuCtLqlqXhmRBnMyJcCsEmEIyUrvNDXWtuKXyLXSD3TT0
 VQGwV/9C
 9Bm1ku2l4RJ4JhqWBHkGrsXCaVOKKxuGbJutlDEbZTr4ngE6tYN6a9Jd0rKqdNlDQONSIgyVLidxxL+OHJVfLlSWxWCO15k2+zY1gTnnPHl1Afg8WKOOrIWxW/fxQq5cBPwmuv53rIrM34P74akbo82lXafdQyHt72V1CANWdnEjzH72mfU6k1/HgHuDONtnR9aBGB163dRcXnzh2kpiVT0klVnDwBGMx1Wgs+Bsulvhfi3oAuzZEDnQ07NXwYqU9ZBU1IPKD/sBeZky/yJYUNU5UUEiA3XjaQqISq1w+Fne268EaY5rYNE3dEoalm/63HaNGXus//O4H8QQh1bj3s6t83014p+04h1AheGct5w1h2iZfySrZyYNF31xYVXDf2oNO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 10:46, Pranith Kumar wrote:
> Hi David,
> 
> Thank you for looking at the patch.
> 
> On Wed, Nov 4, 2026 at 1:16 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>>
>>> In an arm64 page map/unmap microbenchmark with 20,480 minor
>>> faults, simulated cycles fell by 1.54%.
>>
>> Thanks for the patch.
>>
>> While I see value, I am not convinced this is the right time for this
>> micro-optimization while we are busy with other things.
>>
>> This needs a better evaluation: 1.54% in a micro-benchmark without knowing the
>> stddev isn't particularly helpful.
>>
> 
> This result is from a deterministic simulation, hence no stddev.

Ah, I'd assume even a deterministic simulator would have some variance due to
preemption, TLB flushes etc.

But the bigger question is: which arm64 variant is simulated? I'd assume it
might vary heavily no?

-- 
Cheers,

David

