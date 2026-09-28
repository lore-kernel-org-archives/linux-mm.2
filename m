Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDD8C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B269D6B0088; Mon, 28 Sep 2026 05:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7CF6B008A; Mon, 28 Sep 2026 05:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6506B008C; Mon, 28 Sep 2026 05:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F16D6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:25:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E47BA0156
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:25:49 +0000 (UTC)
X-FDA: 85262638818.16.0111705
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81896C0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:25:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9nCQsQr;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790587547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePovJIioM1ipgDKQDGN2uNP15cDFy1xw6rBFUlGkct0=;
	b=yrQseYc4+jiiEMQzEnetHIHcbD1s68RdJhwz3JoiM0EDQJBueD6BWfMkTcHjzJwsP1RyPF
	iPP2MocnTpjmEgpPJ2yKQcWEZnRcvtf+iYOKWYna8OnwHyHZZ3uYUrIPpt3sMp1LNmuGMu
	pjJ1L3QV/u6rXvJWzBcP0iPOh7Y8ZxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790587547;
	b=7M/kygXfHBlZ59t6P62Ob0QnH8t+BgpsN64K1jxcoG5u4xl7h1lA0QIYIrICMUIxmltB1m
	gH/7E2pKhLpDjmZf9IRtZ5arQ+TdPTfxV14nMWR1UFNKNkMalgs7RQfDlOb9sx6+5MUP/S
	C/ShZKrGTjclT4eOGkBme9X1SgQzTX4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9nCQsQr;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1D41416FF;
	Mon, 28 Sep 2026 09:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A241F000FF;
	Mon, 28 Sep 2026 09:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790587546;
	bh=ePovJIioM1ipgDKQDGN2uNP15cDFy1xw6rBFUlGkct0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I9nCQsQrodPBIAuw9DKd4DDPXJ5vehsGPkAbnRMf5Ny4yrlHb4MGfiGRAZZ42sOnp
	 AafWGSqmioUIOpB7XLP3tIhQisxsvdt6QH2i1yLWc9x64tp+ISvc1ZNclTCG2vAErT
	 SEeFM2Orn0WNnkLCkA5CdWqFKZKfxBERk6vTk5FtLEcQLZ0kGjxOF+Dz1COo8wxvui
	 HUsVbEOkMzixhxUk0GqAhEHb4yYm75QAypSb4f9KOcQLM8azd6UvcYuDoqP5nDsX3B
	 JnH2tsJobsv7pLHvZFzN1Dq6dzO3LwWa61AtPwK9htqbWogQEcNitdKxeK6SJbp667
	 h2WtW+sXUGd1g==
Message-ID: <67722705-d45b-4474-90dc-e2402d766688@kernel.org>
Date: Mon, 28 Sep 2026 11:25:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] selftests: kselftest: avoid cd - in runner
To: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
 liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org,
 luto@amacapital.net, brendan.jackman@linux.dev, liuhangbin@gmail.com,
 corbet@lwn.net, kees@kernel.org, ljs@kernel.org, broonie@kernel.org,
 mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org
Cc: geert@linux-m68k.org, daniel@thingy.jp
References: <20260926010819.604346-1-thehajime@gmail.com>
 <20260926010819.604346-2-thehajime@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260926010819.604346-2-thehajime@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5euc4zdmejpzd5sy99kmiyfgqn7idfek
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 81896C0004
X-HE-Tag: 1790587547-151766
X-HE-Meta: U2FsdGVkX1+/6ax7ptHGbQI+ki92kQLCGeHVeLAWSgv8n/71psnbrfedo0DXOTKwHhFpaXbZqm4BhJo/z/e0cNZs2jW/y3DBSK+YHGq2Wq2UDLhC7JRnI2Y9SJ0X37NB7iwy1Oag81fw/R18Jdmo5lHNkqWVlibkOHuTKdP7mRw3ncrTbHll5Kde3rt/nfyWtTo2Tp3KFWo8JzFq6CUphWx2mBf8jPCqLg/nSa2tXCcxVTYZGsCOcE+wnRG3Ie6uUHS473Pj1/C5ZblLZ22hfY1tNyJOBmePjGatGv6ESP+G9qCP6MZkxr9Ruu/2RLbxuLOa6g/sBoRvyVGtiO8ULGCRQaoz7PCZtEUxAbHTao1Psm+JBTyL1UQVQuW4gD1ECS4/KYU0wJj4aXM59fBQwxq3Lqw7gYMzYIDv9ZQh3D2QcVKtbrBQ5ZbGVgftJkyEoCni5yHdu7/WRs5VTzg/RFiawzwANH7bVXVrqV1ifP4k+3+3s2hakWG55N7yap3lFeoAR+mUVaHshrfIEn20RWW+m+APK9H054PBFQrqglEpXXZSq3aiQuYhv0QvBRyTwkL9SrHZwkZf4x4344Ew28y7sv250zRmTDiohImw3ylRaf/YEXVKbudeGwWqO0Ay5jmoX4NzLAHjX/q/udmKNToCOTJwF8e5NN7dbENeDGiXX8j5CriWZG7VgEDKzPwJjjHB+J7azpH15QJF8plSwHDzyaHqADx/fEwOd5T7Lo84DcZoyt+lFXP/UTcKg98dVXX1uFkOZ53zuSNRoRjuC4ZCvSpxKWKR6C+ac8REpOUTDSvx+s4GqIkgMUiBoLI8/c/4qUYm2Hmxbv2zS/mrS2soZ9XY6+9n8aJfTQu4KqNCTx7u8PsirYAT3f86OeOHRV37t3nnSaelfx1Fxb9h88iVpAJJN0BEiP8apg4R2D94pjVuWhhWtLRwp+xKxiZmRqFv52/Q8rmXw9TaGVf
 U5rS6NHe
 lh8kwGvbx5zKvbyqji3qAg+boESpqe72+yd/vDat1XdxTdpKUHmRuZ1V6GuvfcJRH2IITPh2xC0A84CD2a5ZSddX7JZgtPoUuxfgQfxziWRtEba2lnZd+M4BOS9YxT1ByNzty2ISD+FhHudgRho44nGFI0hTXHJPfBHk1JxOexEctUYdN6HpQJDoMDRi1svzDtQe+XwHijucz5/OO4RKASL4sSVqjnZkz4NWGvtfc1gRBnkrGSCeJKY09O8EjhU8gV6ELYswPi1tRLSnLhohY7kxhDbF4xMjgwgTs6XmwH43cNy4iyNJkNjvawPMoseFcTxhMnqZUchGfFlNWU0gLlrLCKtQ08UBmIGqDAgk8fKuow6F7gFPoC6xJ7uUQuydFCs8aLS7j8e/jljx+hdMAnl55DJq0dMJFkeVeem2xdyMMGtevYPgYmeh6q5CaS23mhz1IfBpuDm4nZgIhkzP93bDt2GNLpnSvABzdGcvEr3Myk8nSxjI3A4pMBAgTisGOmpHHafP8Bi6RsKoZRmvB/b5cxBIcmd8YzIqqJWulM5+ay1TGnaOQRfq2yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/26 03:08, Hajime Tazaki wrote:
> The kselftest runner currently uses `cd -` to restore its working
> directory after running a test.
> 
> This is not supported by the minimal BusyBox hush shell used by some
> NOMMU targets. Store the original directory explicitly and restore it
> with a quoted path instead.
> 
> This also avoids printing the directory change performed by `cd -` and
> handles paths containing whitespace correctly.
> 
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: "Ricardo B. Marliere" <rbm@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-mm@kvack.org
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

