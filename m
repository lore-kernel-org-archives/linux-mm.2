Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C76CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467726B03B5; Mon,  1 Jun 2026 10:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F346B03B7; Mon,  1 Jun 2026 10:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356836B03B8; Mon,  1 Jun 2026 10:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23D1B6B03B5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:06:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C88E1C25E4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:06:27 +0000 (UTC)
X-FDA: 84831518814.03.4F6C84C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 065C81C000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:06:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nire0FXl;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780322786; a=rsa-sha256;
	cv=none;
	b=it7kvgZTYhT1o+7YW0ZFec6x+pGbGXw35LwUMixJMXoa0aVEz0W8S09G9r1zo0JfG27/PW
	xD5hrcFeiulSMB7cR81ytaDWtKOPj5qopldVIKVuU9COB/H34ywPG0IHWQkHalnxGwbgrr
	1AedRkdepBzygLZ0kjX/aio+58RJBjA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nire0FXl;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780322786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VECLDAnNXBn3TMxzCh3wlXNOOx2Q/MMjAm1p5f8BDnE=;
	b=uLZxliN085FGbrnC3R3vThWC9CuoC1Y4gtPZ457r9QCLSp/U5yZt5+KxOpSP8f4N1eIP17
	LOxu5/bOj5hDeiIeuj2D4N9E+SnTTaurzfnihAUhWn3EEr6yHBr9ILs8OC0LnjXJ0nFOF3
	ypdKTZ4XNtv1wGSgb5W8DicdB8VB2rQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B8FA601E7;
	Mon,  1 Jun 2026 14:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A6C1F00893;
	Mon,  1 Jun 2026 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780322785;
	bh=VECLDAnNXBn3TMxzCh3wlXNOOx2Q/MMjAm1p5f8BDnE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nire0FXluWDmsRssQ1pShJsTT/vILKjWSC3nj+JCpJN2hxcS0RI1pa5JnAsXln/5+
	 msJouifi8yb8PCPXcOrBfA4nP51A+lxV6IRA+r8is9tpS7wVMj7RTaPUTYWVrVorYM
	 UVD/dBuPb/3OOV65ln09oMLdR6tna5SzeszdIBPQBET6t9YlUZC5jEPLuZzVQOQibT
	 oURpCMAfZXaB3G69L+Sl6ypcyN4/etIsp+/eo6ZpPIjOo0Fxrt7y9qXTVLKux4li0S
	 NKvhssCoOwTMT8W6BvXyc0RltYQtcTTPZrJbxjuPOUY2wBucI078hGSW6Hycfqey2W
	 m/3EqxNp1teig==
Message-ID: <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>
Date: Mon, 1 Jun 2026 16:06:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 bpf-next 3/4] bpf,slab: Add slub-backed allocator for
 bpf_arena
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, vbabka@suse.cz, harry.yoo@oracle.com, david@kernel.org,
 tj@kernel.org, roman.gushchin@linux.dev, peterz@infradead.org,
 linux-mm@kvack.org
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
 <20260530011345.99342-4-alexei.starovoitov@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260530011345.99342-4-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 065C81C000D
X-Rspamd-Server: rspam03
X-Stat-Signature: ak8ku9mef9kk859h43h5zgnsj1n43jpm
X-HE-Tag: 1780322785-176127
X-HE-Meta: U2FsdGVkX19mc/+VVz4WYY1+C4YzuJyvosIldl8Ur1TKhtPl3lGDJbMuDJ96Q8VwtfuELqeJrzBJcAVwKDuLEX2tvR5PVC00e1qdzGNVDCNBmP1RuHgxn+h0AArLJ94jx7Ad3a8UkKCiNkRkcgHNIA0p9mOCaz/sj+W6DgUXMvb9mDsqfSIbG4XEzYXb7lT3lH2C3Cn+KkcZMEN1LU1NspG3ohHPKNeyS6/9sfVMCfhrZb2ZbRPSxbEntVk//sIIDfL5YfSbIYt+j6eSMOpbPb0BpZHDDq0FCxy4hpArI8lX/Fpsy3cWXFZwwTEPFf0n2OnnbY7rv0WgahfmxsZOiAvZDimH1wT9CTV0hbPaWOZ8DkqI4KWLLXC8sShOseS1NsCvlEXDer3f2rX1ewNx6NvlDh3S2QGP1b87BgAIpQMAtSoKv7E5pE05YkJhnXkZLSXPthH+FMpv8JetuofKBkA+N2bFN4444HEgcFNG7t4RRPYrU50b50S9Qx3k+Hj9e0z4oiArutAQLxJX8nyWieDjTBhjUPRNqGQ6rfG/PEcfWPCgUqp80EaxAMVXEMwfTPvNqzcDrddixWEF/hZYFKf38/m581/eMbE/WHKnFnw783m/EaIVTwMILYYs7W54azgQmGgK2TyONUnSz7u2LH/GKDko3UtPKN4OGnqyYOguLH428p1cTlipw2nXFuzVu+fiC0wRAiNO72Oi3a0VDzIfQQ/hnmjlufBb/8KjaaWzHg9Al9FJSqxn/wkZKfKv4+a/+Ip+4wyXwDyiRWgWQc0V41zNoMj1cxtLqR71u47cFkdQSDJXI3WJ3yHGWYeGA5i3i3giI17+NdcJRsaUPxiVwooU53SirJuvL1FWGD5cjoRJmUJ+z8hgXhwvh4fV4pihGw93Y9ord6UYhHQTIvpRZ4zI/I4wqTVDFuQcC8wnxpKt9M9ftxF9CAyc8N2wW/4uQpQ1nTu8TUj1fN6
 8sduDT8V
 rRtjZ60tA5wcqD0rxcBGZoVo8DT8uzNf2VYbqVc+41LlgzPVwIN8FH8L30kBPrY+mc1Ekk0rq2lwIiJoUP3ujmIGHGi5zfWJiN0SteAgIsa6sxiV5lKgVSILzRTXMdHUok1AZRxNiU4B675JNQRm1cY03fPtO+utA8JSHhAFiyi+HyuowT5hwGavCq/7DxudfOr0ZB1i6NY/ICiZxDlXocGNBR5MbnnhBG2MdNkpUTuyFPegCIrUzv1fut7Uc/5DO4JDPC+fnLRFvE/auJwk/m7xwQ/Te6g0B2W+CRuRE3vyemXSZ/lVe46335BTAOqsTk7LYsc5pZr8XR4UCVKX2EV3Mugq4UvLD3FMbssieZUNvlUeK5N8r2Ffgsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/26 03:13, Alexei Starovoitov wrote:
> slub side:
> 
>   - get_freepointer() clamps the decoded pointer to the same slab
>     page via (object & ~slab_mask) | (decoded & slab_mask), NULL
>     preserved. Worst case under BPF corruption: chain aliases within
>     one arena page.

Can't say I'm happy about this part. We potentially let BPF programs corrupt
the metadata and hope we catch any issue that would become fatal?

And IIRC from the LSF/MM discussion it's not just cases where the verifier
would hypotethically have a bug, as the potentially UAF accesses are not
validated by the verifier at all, hence the different address space and
32bit arena size trick, right?

I'm far from sure the masking is enough to contain all the bad things that
can happen as a result of a corrupted freelist. Even the hardened version
wouldn't help much I think, if a malicious program can both read and write,
it doesn't have to know the secret seed to craft valid freepointers.

The "freelist is outside of the arena" approach we discussed made more sense
to me, even if there's memory overhead. I don't think it has to be 16 bytes
per object, could be just 8.

