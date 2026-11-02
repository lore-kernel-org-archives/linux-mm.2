Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CAB606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X4SIFBEx
Received: by kanga.kvack.org (Postfix)
	id DF7256B05B8; Mon,  2 Nov 2026 04:11:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE6C6B05B9; Mon,  2 Nov 2026 04:11:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4766B05BA; Mon,  2 Nov 2026 04:11:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABB536B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:11:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BDD2A0C34
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:11:08 +0000 (UTC)
X-FDA: 85389609816.20.47D7755
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D4D9E4000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:11:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X4SIFBEx;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793610666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5RkqP2tY/U34SmqxIrtmZ8h9C95VS8eUS3H2JGyIcc=;
	b=NXvZEyukNiMHM6qbgSmBTWY5UVLJAUH9Gprn/EAN5bkoflbuelw7xhx6r3GSE/Osdi21kY
	Ah0hG7Y0M9uRtso9zijkZ+ugZl/UctIc6NWtzYQ3rOtEtO8ZAyirXE1kj9TcPFyZGsAiTH
	z0+Kn6UoGCDgzJwQYZasnfDbnJ0159A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793610666;
	b=7n5tv52yVmt4+scUDzFL1rE3NvlXVhcGGCVgP8v6vTChaHErHiy3LH3yYAemKXJOXup0r8
	xcyatD2Sv5CZJZVSZmMK/XLccMazg+1DKfbdosUm7JNGwcBLOgHFawwI3hTY0gVNYTZZlF
	ksMvkXFjclZWWjy3HcxqVxDCBOX2B54=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X4SIFBEx;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21F88417A5;
	Mon,  2 Nov 2026 09:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B221F000C1;
	Mon,  2 Nov 2026 09:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610666;
	bh=D5RkqP2tY/U34SmqxIrtmZ8h9C95VS8eUS3H2JGyIcc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X4SIFBEx0PSNmylZuL+3YdIyiZli5R/xegiTYNYEIN2tDTbZEQEiopQkKOjGCJCoI
	 GHb0fgaDRJbfVeeIaVcbqr0yotGy/O1omVb7TM70lmfzREiDUf26bzQUzRZ/vKTSUD
	 IdCQkyXGVYzqbgSGMRFqn1LDUdajA6N6TThscDq+R6xLXFNrSBMDp3f9HdrwUmGV8p
	 1j1WnUfsiDHFLjEhIx9keqVwzBbRfOZMzBKBtceQWjdNX7yrAFjKfyaXiQgQT7mXNL
	 LZul7GydUiVIn7ELkV6ENFNfGY8oO98MbQqB9Y8y1Twh7Cx+oTy/zHbEDrJL/7YwHG
	 g5uLDONS4fNXA==
Message-ID: <5d79db66-2195-4f8d-a721-e1756bc6ead0@kernel.org>
Date: Mon, 2 Nov 2026 10:11:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: release isolated freepages on compound
 range mismatch
To: Zhenghui Hao <zhenghui.hao@qq.com>, akpm@linux-foundation.org
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <tencent_869149E9C4305627F0ED654860AC4DDBC309@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_869149E9C4305627F0ED654860AC4DDBC309@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4D9E4000D
X-Stat-Signature: y7hihbkwfb7q4a8qrq6tj8ekwgejag51
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793610666-82471
X-HE-Meta: U2FsdGVkX1/4nX0GdmFN8r4CpEGzXRHzgRbzQ0eslXkM7wwV/ZalikkTTb0xENp5cSzKfRoEn/dYPxq4b0gZgQ4zFgOh1r5Mxy3WfUFEo0B3ivFGfTQzAwS2LbhmM+GmspsPO8i4mXnemf5LFdVTQiv9DRrEKDNy0jxPdoF71+jXFuslaIfbBYCQq+vz25pBUZ0Emx03ko7ZErgREn0ZT8cdUCK4CLbSpQJH4eWCFvVA4ppcE3n93R3dF2HXDNx6Z2D9zxckO9oHo/l9qxr6iHDo0FcnDBQjrGKm7pKdKJyvSwixfkHFCht0TfiOYn+mj5K4zMbJUGNlcjhlDGRb5Zk/Fgpjk4QBODdx5DrA0jeAJ8wUBmM9XBJqrnaE5zExhFNEXHtkPNTwbZbQ1TrcryXtMY4rv1lNxUmmuw3BJKCiSe9CYcdVaeqKgj7tf9yM8YAPTs+L8EHnybTlsiN9SZxSxCR8/Qp6u4x3Ys39Ae3JZyM2419b0nrVJrS8H8fhUuXvLwodQuW6qzsX5WfCPBgGOrEb4cOpa5mZBqPdsVSihguXWvWklQ1zX8ccWs4KvtKlEEoBxiX7gSuVLgzl9RjgexxPYlQZIKip5Fq9LfYuus4ZFPAy8K/OUVXl19a7tE9s5MaNfFoOb7fB4dYszFF5lfS6LYFvy9qzhQqpqCB568WFTCDXzo9Hl4/Mg/J1btbRtsON/tP+yQGCbudnIs1G6EgxcUbtLCdfc/qtoQlfwpMvEyPwHrpGKB4BhS/SD3z2o8LJrViiGp3ag3X02xB70csvlhxcGZnm7CqFDQXH3MaN4OIK13ccKtdymlCGullA39mUmPLjUvmWC4mvBDckKwzxE0qC01+8FxMVqbKYQLtWoIInYhtQaYVB+2BFxpscRsdcpg4DFAJjH04QDHJhmgo4KAyU5T1b+xd0Z5ZLnAf32SFZbB1Bvj5jz+dolrpmzpIJrj/DVuqOEzt
 6An1+0lh
 XPOVPH/q4yPNeBGsaRQltSiOQqXIXkOoGZGCGQBmEvywievCxSv7pEo0JxA0zS0+wFb5X6SBKQtq8+d/t9T/fK3jGhcSs45NiJkO21KdYq2o/mwE4EwdlXP8mlqYonklfXNzb/PJXRscCFRS4AgBrzP49tUh91nQsMo70Pn4xA/lsu3I2nGKM9L61olAj0RFmE2vcFSYaO+uef+fnzFyIqBrCfa1vrklpPFRSnOezRrb+iUneDmPWLbWzcWNBBIIJsCDChhutl6ZUmRCEtJlfJeAitrV0F5z65pFZY9mCnGIYFbZ45F3BAPONHqpCWjE5LkKd8xntB05fOR5E2UuXCaG9A92VlVtcOy7W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 10:06, Zhenghui Hao wrote:
> alloc_contig_frozen_range_noprof() isolates [outer_start, outer_end)
> before checking whether a __GFP_COMP request exactly matches the
> allocated range.  If it does not, the function returns -EINVAL without
> releasing cc.freepages, leaking the isolated pages.
> 
> Call release_free_list() before returning -EINVAL, while the pageblock
> is still isolated, matching the cleanup already used when
> isolate_freepages_range() fails.
> 
> Use WARN_ONCE() as well: the condition is reachable through the exported
> API, and repeated invalid calls should not flood dmesg.
> 
> Tested with an order-9 free pageblock and a one-page __GFP_COMP
> subrange:
>   before: free_buddy=0, leaked=512/512
>   after:  free_buddy=1, leaked=0/512

How did you reproduce this? Using a hacky kernel module?

> 
> Fixes: e98337d11bbdf ("mm/contig_alloc: support __GFP_COMP")

I thought we discussed this in the past: if you are able to trigger the WARN
something is messed up already.


And indeed, same patch already here, SMH

https://lore.kernel.org/linux-mm/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com/

-- 
Cheers,

David

