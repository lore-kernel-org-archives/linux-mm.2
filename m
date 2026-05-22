Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E0BCD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 00:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C8A6B0096; Thu, 21 May 2026 20:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CFC6B0099; Thu, 21 May 2026 20:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32816B0096; Thu, 21 May 2026 20:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFA1E6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:49:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68D501A093A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:49:54 +0000 (UTC)
X-FDA: 84793223508.13.DD90F4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B431E4000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:49:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=srdsM9bI;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779410992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WatfylbvkDV16JVW54t5ye7mqGpFdFgMUbBLkckIhZA=;
	b=IeuVZp7huPEdwuQ//Fbxp3BxjCCzYTXG4hbz3ET802Dhl0Hdal8UuZb4Tl/9N28BA9sYKJ
	8666E8X9Y41XlVuj6mAb/mHeiAnOFLLAOtMLd/2gNguuCAx1eS2VzFGYv6mxl6Oh9SopCp
	vnkjbXyqHyLdB32xY3R37lMLHLhuHKM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=srdsM9bI;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779410992; a=rsa-sha256;
	cv=none;
	b=gqZMia9a0FgehNS4jgnfmxsdmMbh92/OwnTN+sWhRniX01Rzr7ydsMSSmNk9WjEZ0U0r+P
	wEm0Q/CLhyoEwq+rN+UwpwTjzteJQAKX3UvHWUYmEHiGdLqt7YQ9Ziohh8ZwoGyRbFJ69Q
	7VpiUFwKAKvyIdEkKZua0NoyHwMz4RI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DBE360136;
	Fri, 22 May 2026 00:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3A11F00A3D;
	Fri, 22 May 2026 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410991;
	bh=WatfylbvkDV16JVW54t5ye7mqGpFdFgMUbBLkckIhZA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=srdsM9bIlN5tAruNPcPsu+oBY9hYfTznm+nyaoqIGACzwGFETHF3It+luHH+BfQK/
	 NO0MtYqZ2cag00gBYx8O/OuQdF0r/txQv3Yq1TNqft8h6ETAXI6g3bsPaQhKRHnhIh
	 b5jWrktauzYR/8bKAe+clWxSS59Yt+6876ycc88s=
Date: Thu, 21 May 2026 17:49:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, david@kernel.org, ljs@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: close fd on write error
Message-Id: <20260521174951.d16f76cc39cca19bb5d6ee70@linux-foundation.org>
In-Reply-To: <20260520093824.eannlavh64fpxyrz@master>
References: <20260520020336.28914-1-richard.weiyang@gmail.com>
	<20518530-12e3-4731-9b4a-54cc950239e2@arm.com>
	<20260520093824.eannlavh64fpxyrz@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B431E4000B
X-Rspam-User: 
X-Stat-Signature: bepiimi4dki3sug3b4uk6tawzts16t66
X-HE-Tag: 1779410992-484136
X-HE-Meta: U2FsdGVkX1/w5H0OfmrLEOLs9rOlJVIdozm82z1+urmZQj02dRopdFUtriR0ZO3j0lljRrKeG10bgZzBvjVd2+dQslKBlXzWBYfHeLpwJsY9JhX2/z7uhY7VeMB8LnEfFmivuxAtt+MSsSxPkyxu8Ie0UM/2gXYY4Vl8gFVzD0bt/suwVQ1s554Q8ylPktREgiIpPE/V14nehVA3iPvP0KOUmrr9aMjPIJQ2YwibMXqsu8VP3Ecu9ELXkcegzRz917xCfWALdoQ8uI0ze79VBn1EowiDX1nv24rVgUORC9Oaty9nn/hqaQTEsvLRaulkC4xt51dijlYxYolyITnoPe3wyYmbqZGTEJVYDdjJ6b2jAEKWxbcOXOCp6/m6YTpTkx+ORLhKwFEOWw4IcHXo/GoGFhLsroO/w8Ip9e4J8HjfKY/UVlz8+0+m8kbkVYil5cMKkqWfh+Efr08N7NxiKQiiMSa+YwiuXWzMOMyxO/CXB4nWfRCaOv4wxTsh5Io2hTaI4t9xBYnP8p+4SszSy7RFCTBsqJa6uRc+E/Gt3S643BRht42qQnk7DdwwbWMNi0Ze2VnaIF2qiymZeZnXC2MlVzgWIKYGylk9TA1k+eMQJQ6gct9/vXM5Ze8ytkIF10x9xBMMI6JWTVFS2N/IAUKsgBUf3GTRTaUCHfR++bLwIRnhv1JOtk7Gg3Ox0jJaFJgEz24bXzWygoEFismvjlk2a47tAB61ZHJbUbVuCFLvPreKgR8TpekE0CEshQVaO6TVg553nkxZfGEWJTpdcbBLNCSyjcYlEpd4LUcjXWTumhRJoVb2Km31wGU0Lshn/m1ZlwIme44tqmICknFv35t1kjSHj93rp5oh46ICCtICM/Q9MVOmY9xcnBdbexMjnnx+fF3rt8Tko1s2X5g3ype1j6oZI+NGbzHNR9/hZmbD/NNw/Hp1fjckfSs7QU2cQAeAoNa1NKV3TR5GFwg
 y1oKGWfn
 eUymRAuf185It4bIWWSjrmCl5ggnBPr+gIrMN6MHcu7cSNXk26nAlpHm8LTw/pKonJSy2RXtxp0OpUMXn/WPSNjqoolZ6UDt83oM9iJPvaAdAbVqJr6ZPmB/mbyWDuaMOuI0M0o2yipjO9BfBt+s2mUk0D2JoeGRh76W2Fvn9n1ZQNFPwDaKdKS6v/hq2P8CrCFnLacWR8ILGLS68s/1sTIC+oRGzy5SsuhUWEL6h2Z4xxYCIJZ/B2klXKrTgKuCaXwHJcT6/1MKrlxF6J+UY/b1KNWFQsTdrJ3fUktIv/gID3dKuXFuQLr87kaT249nFpLMulpTToG8OCw3rGjzB20n11rR88/pE8w9mc3R7PrNI58dD/0CCUnRof7YabDrrO7prCXezUdfXeEGBg+/p/i2Eaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 09:38:24 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
> Subject: [PATCH] selftests/mm: close fd on write error
>

selftest/mm is a big place nowadays.  I'll rewrite this to
"selftests/mm/split_huge_page_test.c: ...".

> >I asked AI and it points to another problem:
> >
> >for (i = 0; i < nr_thps; i++) {
> >	if (is_backed_by_folio(page_area + i * pagesize, 0,
> >			       pagemap_fd, kpageflags_fd))
> >		continue;
> >	ksft_test_result_fail("THP %zu not split\n", i);
> >}
> >
> >ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
> >
> >"If one THP is not split, it prints FAIL, but then falls through and also prints PASS.
> >
> >It should probably jump to out after the failure".
> >

https://sashiko.dev/#/patchset/20260520020336.28914-1-richard.weiyang@gmail.com
doesn't say this?


> Thanks for AI.
> 
> It looks we should "goto out" after ksft_test_result_fail().

I'll assume that's a separate patch.

