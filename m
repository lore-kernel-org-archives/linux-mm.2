Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60AAEC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486836B00A3; Tue,  7 Jul 2026 11:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436A36B00A4; Tue,  7 Jul 2026 11:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3259B6B00A5; Tue,  7 Jul 2026 11:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07A3F6B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:27:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BD321C38D9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:27:16 +0000 (UTC)
X-FDA: 84962359272.20.FB5A693
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B83B740012
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:27:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYllJxfH;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GmH67d/sfkOObwvV5IKMNEhxK2zYsfcmBzKOIq1yB0=;
	b=XC2l9bxaFJTBZEIn4ZF03ydDaHt97X26+AiC6cDhIpiyyLhdZUVCE7caMw9c2bqWSDKuio
	bFoQzE6tM25hgjQDMoyKHR5RVowymY/4MdvmXrrJjpvLuEEPhdyh8p+16HWAuao1oB95wF
	Dn1vh6F8G75HHyzd0e7El0SXszq3aTg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYllJxfH;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438034;
	b=UQ5sFYJEVOU8rXDc4QcI0Et4cPu0+IX4TCy4/j03pxvPcM7xcyjyDA0kSK59nEgXBuT/3O
	QznvaquvdmAjmPwmY/wCZnhzUhCyvdq4srW9Z3Wnx2C7fyz7P1hfZtV5KaGlX4QoUPc9da
	y6wpEH6gVACe0eZAR7QXeIpDZxXXeKI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2338C60018;
	Tue,  7 Jul 2026 15:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDFA1F000E9;
	Tue,  7 Jul 2026 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783438033;
	bh=7GmH67d/sfkOObwvV5IKMNEhxK2zYsfcmBzKOIq1yB0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SYllJxfHs7eZz1MaPajeoLdMwj4h4cxN9rarb4qzX4V47OI91nckYN2vt4+757pfi
	 uyoBfj2Q9wEi9yKDiofgFX7HmYaasX+jWq4J2vhY049K1ljxXtl24CSq55sgbqmGLy
	 Pm5vVTzkRdrtYkl7tpLQ8ZqoJ/Xrc7JI3nMZgpEp1VWopVmcvMs3xMnHMGAHIJqgLC
	 UAE2dWtGOkYvJkZOE4/cnfH6JP/Y3VUJX7rND40cpJEJ3BtchnnImxGOTsh+CBKzJh
	 wL6aQJfK4KqsHbxkJ5OEQe881dsolghXB7MtPneyHBu44zzHvQkMH3J71EeJUaHya3
	 sdbqr7c2FKi4w==
Message-ID: <670931b2-7d9d-4e37-a410-a2e7d85cfdd4@kernel.org>
Date: Tue, 7 Jul 2026 17:27:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 1/4] mm/page_owner: add print_mode filter
Content-Language: en-US
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-2-zhen.ni@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260707115411.1714314-2-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bbn9tjaw1g356mteobhskuc33u8t3zas
X-Rspamd-Queue-Id: B83B740012
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783438034-382722
X-HE-Meta: U2FsdGVkX1/AiU+9JBj3FJ2VCfiaYkRLQZGStSUGn+Ho88xc3BXLezcZxHN8bFUWVddJfkGHamymmNwfTTwqZlHTRtuZwCZH/h2kENpDNJ2xyq9KDpfNq+MwfzD5qn+Dsb/0udFD+xt51+YWNfGQawwwNHnb6vawZfGrO5sHs43ZYMAoXDo+ITU01ZTaoxPomtkCvo/SU3h/s2FA4KX0eUI673WHxFm0ct+jQxeKVGQp/N1q+XPcA6UUzMzGptBmqNZyUYX7Xh4DizQTXtk3QiRT3ExBmDRvkL4/qiFKl4JOiL4baQBJSzei3cNpVt1qQ4uuABWxdPPCYzP2Fat/JVrw7Owwj0e8HMmJyKCC0jtmA295b3cQiBrCoXFmSb69+SB9ihHwRrFixdprg+5T3pncIktfqp9oX9fCJVfZDUcZ6uJxEssIkEp7mQehOm/YEd5LQmiK4EoDShc8znVxXp6AoQtegjRBzSkfN+CY8PZvfl97fi552+WtKmNaqtsmaLCflMvaiGkTquvypgRIsVOoWniztmBtoODmZ1/zbZDBrt/1pnbc3RpjwttzvbLB5DmrAxf9uFEI5h9thvS6bAjuT0Xc1d55DFTqxXOF4Pca/OSDIJSCjR8/byWh+wBiJxT2pBPzQ/+G44mbVcgIFVRd5e6BzTBvNvzgHteLHGXuaKU6xzX6AFgwRs9cr/Yhs3L3u1+cIdgslpfkD7781ZX+sT5sVLai7OhTAl3LIewbKcwuvIoWRtxAqlCwsXPnJnO7vYoAFPxsS5LB7pu3gNZQxPBnyWcT0r14JEk3EzNSpMROVn9SRkjtIDaD8u1kPEUDu40WV9recenKRXH3GWo3EIQx1pK/d45mUZDsd7P+uViuvxt4dItMO1ntfmG/bRTdDRI8KuhZQaah7hWNhZsiivRdaDs3ErFD2emCiTw69TdnCMphP3CQqtrSxPwB8asFgtusnw9LQqvEkS/
 IxbO8KrJ
 99UFAkq5fOUn5m4KcwUjzchGO5iQe5uJFG3w75QuIqFcjCtWI3mABF4LWM7FUa2E5B8S+nLZcczL5c749dZfIefY1DyUrqfaqixy36nF+FUXqCo3Hx5SGnBKnGPzooLeqCPnltToW87wLh4bivWxvyU+Y69GHgxsaquBCpXQLB5Q+CmBr4UIWTrEbWACk9XXg+q5s/GrIyUbKr2HmK8pln/sIPALEndhkKDB6pCizbPmNMByWpjGH86plEQ5jzCtmuEb6u3gcRb9gAp8Hj80Q3Z7xZ6eOKHUQ800p5IZgXNDR3UUTPnDTo0UfsDt/FvycCWl7pkTYVQWPgOhpGltvlyUrVGNkpVpeH/28
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 13:54, Zhen Ni wrote:
> Add a print_mode filter to page_owner that allows users to choose between
> printing stack traces, stack handles, or both, providing flexibility for
> different debugging and analysis scenarios.
> 
> The filter provides three modes via page_owner:
> - Writing "mode=stack" prints stack traces for each page (default)
> - Writing "mode=handle" prints only the handle number
> - Writing "mode=stack_handle" prints both stack traces and handles
> 
> The default stack mode maintains backward compatibility with existing
> usage, displaying complete stack traces for each page allocation.
> 
> The handle mode dramatically reduces log size and improves performance by
> showing only the handle number instead of the full stack trace. Testing
> shows handle mode reduces output size by ~66% (84MB vs 244MB) and
> improves read performance by ~4.4x compared to full stack output. The
> mapping from handles to actual stack traces can be obtained via the
> show_stacks_handles interface.
> 
> The stack_handle mode prints both stack traces and handles, making it
> easier to identify pages with the same allocation pattern by comparing
> handle numbers instead of comparing large stack traces.
> 
> Example usage:
>   # Using the page_owner_filter tool (recommended)
>   ./page_owner_filter -m stack          # Print only stack traces (default)
>   ./page_owner_filter -m handle         # Print only handles
>   ./page_owner_filter -m stack_handle   # Print both stack and handles
> 
> Sample output (handle mode):
>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>   pid 1, tgid 1 (systemd), ts 123456789 ns
>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>   Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>   handle: 17432583
>   ...
> 
> This implementation uses per-file-descriptor filter state stored in
> file->private_data, allowing each opener to have independent filter
> configuration.
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> Tested-by: Zi Yan <ziy@nvidia.com>

I think in general Tested-by" can't carry from previous version due to
(functional) changes. Andrew can remove it locally, or Zi can re-test :)

> Acked-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


