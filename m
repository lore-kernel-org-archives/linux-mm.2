Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9991C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC6A6B0088; Tue, 15 Sep 2026 12:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C656B008C; Tue, 15 Sep 2026 12:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233D46B0092; Tue, 15 Sep 2026 12:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16A06B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 554AD80484
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:14:53 +0000 (UTC)
X-FDA: 85216495266.09.77A1C6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 856DF140010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:14:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ldy5twGl;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789488891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15qk+8C0Iczf18J042lVpj2aSO6uHpfq4oCXi9RQCbM=;
	b=XlyihRoXAU8ZnJXwkx5C3Y9lIZK9eABLf/VZIOu9mA1smYS0+yaBHs9gqhKOnqdaCIN9nS
	dSZ2l6Qj8m70uBab6F8FVOekN0YAHpXorahHtOwY3+Gf0gPe1d9a0Yx/Ic4r1xqL4YWfdU
	RwM/xT7mn/nMkUrZgjXQ6j5Quhpb4fU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789488891;
	b=xi3AE8ZyF57sQnLhRY6Ny1Jct2kbtU/k37rrkAfgTwYGKSuWct8XhaQmrU3gjHL6m5j5wP
	pJOLqwef481afF1JsHbbvf1EUzzsEH95LEb164eONGBUBuxBqQTHvAFYKCejwSM7HQfcjq
	V9HvB+UwO69ySv8TSqU7O+ErDUTEyTM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ldy5twGl;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F00DD600C8;
	Tue, 15 Sep 2026 16:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631091F000FF;
	Tue, 15 Sep 2026 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789488890;
	bh=15qk+8C0Iczf18J042lVpj2aSO6uHpfq4oCXi9RQCbM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ldy5twGlOR9xH4uuXkoYP9bIiPX2T+sKR3cWe1J5OzGEFMnR77AJlu679i7xSuyYu
	 uyXo2YYn6rRILuozC2zDBtl+PR4VM0NHv8hgNBa9Hjs/F3uSyjfuRFmBgDnFJy7t0z
	 1m5XxSJU9TQW03PcfDScFi4v7o91pWJjqCLy/xrqdw0n8gAPtxiqYCo6PQkYJVPKlT
	 8HyxQh0WrniEK0PoinF0XpYszJjEWiwUSikgB/ST5d2amIK8nsiWo1cKZksQaMuIyJ
	 Z3nVJpGQrIybYFSIN9KBRf1AgajKRQe1ogSJa/+0rrOsEtI5evqjP6QF8ax7gloL3p
	 0tguKhHGPBlqg==
Message-ID: <876d579c-6aea-432d-976d-f5f9078b5bf7@kernel.org>
Date: Tue, 15 Sep 2026 18:14:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
To: Mike Rapoport <rppt@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
 <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
 <20260913111700.6de78b5834842f7dd3f12d07@linux-foundation.org>
 <aqbvFtlXd3Jdnfbm@gremlin> <00dcd8d2-67f3-4ecd-bd7f-06ba1f9c106a@kernel.org>
 <aqgnpAqG_OS7gTeX@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqgnpAqG_OS7gTeX@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rh68qze413ecrnkf7nwx4hsc4k9pqcnh
X-Rspamd-Queue-Id: 856DF140010
X-HE-Tag: 1789488891-101840
X-HE-Meta: U2FsdGVkX1+EXgaoQzTvpJxJmtjSfXlM9O0FOh5WqILfNhylTcokpxX2v+pweb9AzSQopt6pY5VOoF19FaFl1GhEOFRVkOy5RH0AnYFbbvC91//5ZBVp25v8XHbwuV0w0UxmMbnIIdl+d2OSyUIWtKHqYfxilq1RpUgJl7IbsY0QcoQ7yUqBtvlv5y7Kgb8joplHkQR5JhOwg0fvFNZ5FmmhsocbkZPeSnPVnN+5Jyz2xQPmPV9lbdtL07mOsSFM7YMtVTKEF4absoCMY/LEXm2LUgazvWe/4wKbyqLYBUZQsO3JNAQecExLCSLgtIwec4ay5SSTk1bB56/X/I+ownIG2Hq9xh/HTrRfVNMqLeLOlOZ5TMx8jSkkp6hiwSljzOdVFUThx4EO+LQqV/AVZ/XFdiJ3yPVgBTIK2PK8Se7UZWWeAGnOuUF7XFZuiKz5J5Anj6A9AiS0mq+gx3gbUxdlWollSTU6nW8r0MaWgDwObt6EnPXTEqP/6CaRkGS/Kur2p2l4X/f1NG47PN9tyouucjnMYnY8zZW8jjMp+pN4cE4G7bXpfAxpgvEgY9S9xbIqflMDeARKKJirrzX/AKhe2lOnFl9W6E6MtYqRRtBI59Trk8ljD2Wr/dy9u+T1/UHfm/E23270/QkrDAgrZE26tpBuyED+1+16hCMK9ixe/yn+r3B6LdKVQ3V/24mVada+CcotX5AU1qIrBPn+XGahFDxm6CZY/cAoPOzBMpCXGe87Hj1kQ+iYQEqG0cnW76LAnlmTzfp4IwaSZs7mmwVMicw5HWLF9zR10vWe7hpnUKwQglQeg0ew7LFplrf8hPGSmDFzvI2PlWmZwfz1+am6TDpgM+in0MWBu8WlBe8w5CXbcaZSr4UebimuS0j8umX9ALm/ClTchWlpGX0QIdydxTkg3F1c1PO9e9JY77ba5Mr2qZlRLKn0cW7jNpEj+nsgqt5Bf4/A3GEsz+e
 Yi+mxnX2
 6xxr5S/wr7gIYz4U5mv55cImq6/Fxe48ZvnAosMLskk8aFD9JzUuTvnRPzSpd4kA7FDrYPUaqsjFqJmcfYkuMqorJlJDfPqpLSHt4mlJzxRaUYCGUlzj+BfLm46CSaMucH2kzwoBkFP1YZ68C6LPWJSnmAZSBxL3TrqD/dV9SGwSdXQyqmfindq/DYWGDPwycE0cwR62DigwXhRuWBb36zVbJ/d77egQ3t+wJ907AzD1Sk7Ld9YCFm8rGx4dMPD3QZT2gj7l4SInGfVPEr9FrAeHFgi8Ism4KVPvrFLSm2MEpWW7wjpZ8Echlr1ObB/ssVOBAIH1dTsxMygwbrcfSzo8qG7SVlziTGnxoIyI2TmifieXZQx7RukqLIDxiaN1er6KwHqHn5ZbosxQy9B3KX09+OYHkAjC9Rwbphi0ZEaY4BcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 18:58, Mike Rapoport wrote:
> On Mon, Sep 14, 2026 at 04:19:11PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> See https://lore.kernel.org/linux-mm/aqbtfms0_2ULBIT7@gremlin/
>>>
>>> I am not really entirely happy with somebody who has sent a flurry of patches
>>> across disparate subsystems with no previous track record being in charge of a
>>> potentially backported fix.
>>>
>>> It's David's decision but I think this fix should be taken over by somebody
>>> else.
>>
>> IIUC, this patch might be responsible for random CI failures (Mike still
>> investigating).
> 
> Checkout of this commit in mm-unstable [ 1be399d378b78 ("khugepaged: hold
> invalidate_lock across collapse_file() readahead") as of a few hours back ]
> 'khugepaged all:file $XFS_DIR' fails once in 20 or so runs on my machine.
> 
> With this commit reverted, 400 iterations didn't fail.#

Okay, Andrew please drop it for now.

-- 
Cheers,

David

