Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D62E7BDA9
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 12:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1024B6B0005; Mon, 16 Feb 2026 07:19:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0796B0088; Mon, 16 Feb 2026 07:19:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1196B0089; Mon, 16 Feb 2026 07:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D90E66B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:19:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BD3A8D189
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:19:58 +0000 (UTC)
X-FDA: 84450226476.04.1AC534D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9B772120005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:19:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gsm5+VCO;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771244396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6AEU+v0T8MvjqBnSx8bR+vM3oyOGX/TtVHCxXOCIP0=;
	b=lXfZ+lKYEiOrJwjgxZLWJp68mfRS0AqQFLLQgHiD5dZwogoO48xFu8wx61WQkyDNAwDR1X
	29Yzkm47dMiL2UC19umKaPVbkc5F3So0HAjNov4n1DtUA7+mXqZCRtQHyPrxSNUDmCcAgY
	cGMkLL0/Wk1383Jto99xDfYrYlyC3IE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gsm5+VCO;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771244396; a=rsa-sha256;
	cv=none;
	b=bPH79CMZWu3WsLwdi+PRX40JA+oPnp0zuFeZribJkLohcM/XEdSmClT5knCtmpGoNWPIAQ
	ggHXSJpLqpEMUWM1ezsJNf+9txnfaSUFubqca4DZ0znEkYBEUFIVDkX/D3XMq/2g6hydKr
	4KdJYYZjkFyMCNILupJjncvtbga3EfY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D79543DED;
	Mon, 16 Feb 2026 12:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02F7C116C6;
	Mon, 16 Feb 2026 12:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771244395;
	bh=8zgg3lww3h4FXpNYmWVoogp07XH/3lQ9RKFAHKyRcbA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gsm5+VCOWZGMFdm5BdJCcdrUKpgNO7MvNQ1AS4QqsOXn1HMEhgO8DwhacdnvLdafT
	 o9SLiU1D6pyKuSou7hx4coCGgTbsLMNwy2GE0CnH/eMjIHpFkF3K/dmfDbhsaZfx9n
	 UGU+pB/lAy+2KccOBQXLJB9mDzTGd1cJFga0UliV+bytqb3ilZ2ySBfnOFOaGWa7jd
	 VoG9VKyuJe+PbDfAXXa6TUUhGoPz5aiTb1OsyU4mpu8NiPFv1x9ZjdSmOEv1jo2J0B
	 Zqdjxole6N/FTHqD+6iafyBKRj0VBIwmiQrvwkXRyMNZ2h7hSnsXT/RjSmvGgddlYs
	 zkLXWnjuX61iw==
Message-ID: <8eee83b1-b59c-459d-a34c-63794ed68c03@kernel.org>
Date: Mon, 16 Feb 2026 13:19:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZMEvl7WUKyxmgIh@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B772120005
X-Stat-Signature: 4kst11wsw8dst5ezk8af89hxf8k5b1ab
X-Rspam-User: 
X-HE-Tag: 1771244396-170822
X-HE-Meta: U2FsdGVkX1/Pr1L9hJV2+ss4j7gQoWhvzLLUHKDAVHluAjEx093W4+npdJLvLKhD/qnPwBRugpKriebJykPUBzFEAcLa+iqNp4OKktBJf6KPNfuVj+YDEKGnZY2bDea2vn2bd8LjDnMocTNlZUw9BpU5QBSI2+5vp1u9QW6nxNTKW2xx0XOV1Fm+z1yB3YZ8NJtwha1tBMDUql6eUVYLmYFZksHq/WyVmwhBNO4m4Pp2JXnEKJkwGboKgJuy5pHVcAj/hXfIoW2SdKlnsLLTbUhqqvpjbhBsXounec/TWPinGwN97N+v6JLdrdpPegyivKkW7IaxBY0mldxuj+h2QV+C7yCoV5RZoI8lZxi4qWnyZVqKlENe42KUKOxLgaNrCser8SZJcXHNLZ1xU0j/BikFJzkquyRL7pzXEbIS/1pEsxoZpFlpotRPeYzIyupZUd7qiJgl3f4c3qrYzvzgVX9ZUVAbh1T3uar1IokcKWUayoR/CqKWN6jL/7BKIorlCmJfVdDKBj5Mejrmv5kzuLXlkyIxKXIohOptv9XRJ5CuH+noXq6L8pw+k0dYVS/33y/QwxTz6mptXyWGCZuwAOcgmjQxj6ebGlKPxroIy5sZfY1Ur3i7NTe9S3KFUY9/IxYAmRsqvw1Ngs4cEpuznrvPeBejMn/FrKdDh0jnA0iDyuusHYaJrrwjis8dSNWUOrPzFKAVW2E6/NiaPITpc/claZVuYQNAnmazcVHFQKLUot9SKr86iAZ7t/DFMdk9IOtVv6Adi54BsNeQepqrMbw12yBnGb079lqkOMLt51Pv4bA+xwy75YgcOkeoUkNAMtrz2tC/nhNdDhbZtRLtpoALL/+oamdqUshqdZx6E6cftZcDG9iM2qkdzwlVOb8cEhTcZ8DUa2plLHVh+gv7WDkBsHoqdLo3tcZd9+aQly9oRY6q4+nE3w8ibid2z2ZfSgK/LCweV6E7BoEf8ve
 No0gfK7x
 duhh4wpdeQp8LxARN+qDx68gtoSaD66PnxUie5UZkg/HfIUaoCVwUcRsWREh6tLtt5SgWKKRDV7z+pI70qX8CkEikZxhOQAyeREoaEC0Q92d7sWUoMF5TkYr8Uk4NZC0VqT9OF40Xr3xI8WUtgttnMMUUgz5d6QYyrz2C2hy61JEWN5tlfv0WBOutDukIezd1lsOnEtBACirfWhieHeqwUIXMhn89KK4or0zW9vVwJ9YaJijNAwpiwVt2kNS9AO9/xf+y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 12:58, Kiryl Shutsemau wrote:
> On Mon, Feb 16, 2026 at 12:45:13PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/16/26 12:34, Kiryl Shutsemau wrote:
>>>
>>> I expect it to slowdown /proc/pid/smaps read substantially. I don't
>>> think this line in smaps worth it.
>>>
>>
>> That's why it's enabled through a command line parameter.
> 
> One users want the stat and all users on the machine pay the price?
> That's a poor trade off.
> 

It's a debug mechanism as stated in the patch description.

Similar to CONFIG_DEBUG_VM slowing your machine down.

> In general, smaps scales poorly. It collects a lot of stats and most of
> them are ignored by user. We need something like statx(2) where user can
> declare what he is interested in, so kernel won't waste cycles.
> 
> Kernel cmdline parameter is the wrong place to declare what stats you
> want to see.

If you have a good idea, please shoot. I proposed using module parameter 
that
can get toggled more easily by the admin that debugs something.

It's a good question of someone would want to use this mechanism not 
just for debugging. Then, indeed, a more selective (per-process) toggle 
could be warranted. But likely the scanning would in any case be too 
expensive for any non-debug case.

So let's not over-engineer a debug mechanism if this is intended to stay 
a debug mechanism.

-- 
Cheers,

David

