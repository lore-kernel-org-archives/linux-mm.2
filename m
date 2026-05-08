Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0656CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 19:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129FD6B026A; Fri,  8 May 2026 15:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBE36B026B; Fri,  8 May 2026 15:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C056B026C; Fri,  8 May 2026 15:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0AAD6B026A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:43:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81A3C12028C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:43:34 +0000 (UTC)
X-FDA: 84745277148.25.EC72A10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8F9EC1C0005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:43:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onbU9bup;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778269412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxLLnCceCFE6Hxzbu5sT7SwbuF7E9kumfjKevNg+p5E=;
	b=34XO6jStZGOBB2H39wTIXG5h3STSmddwjzp9cdlR5u1qsFt2QIa9BfJOiTq82/9S/KYUgw
	mqKRvEiZWj5/5Ms3tz0NI3u2FdNTq2WydM8QzJuTLKF9LNRb7UZCpn2KqeV5b6vhdzENu0
	uXaIMIAoqQVg8gIJeIgy5XJsMQGfg8w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onbU9bup;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778269412; a=rsa-sha256;
	cv=none;
	b=ccweFepP3+jM9T+7K6eTV1FZp0Rjc/KMFMDvok9xjJylpgv4AKIPf+FUyk3zktY0bgdv9L
	M3zLRhrTJzilVx0f0KVWn/cAVp2uz754aTca1Z7MkSbE9Egig6BtjRQMrLANAr5Za7ccRW
	/v7Na/zfbGLMUwxhfbg0Z1KBWmNps/8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59A7144417;
	Fri,  8 May 2026 19:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2381EC2BCB0;
	Fri,  8 May 2026 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778269411;
	bh=5IF7JI+6OisTTE6pJfDw6BJFcJCa7+vh0uEInLOxcVU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=onbU9bup6KlPEwg2Um5ab6qt0uW5y0+HPsiFUUJsRvThzNBb8bnMSdyoNezqdpxsI
	 GdPzZLjS5F7MiJfRm0UsSmHkqoDrghEPjuDwJWIXTC9JBafflYe9HDgi4D67PNnMNr
	 UtZSzjrQPj0vdfTTkeXfvq8vJN4aAIb1UnABzPson7WGVFj0VTBH87rvCuCxJ+M3yg
	 rehqRHr+3O8uuOwjjqgHqPRrHA86hEWKwb7vP1UoOzJfsFyw3wS98va5Yc6sRg/Z9t
	 n56pRD4X9BEQGm53AkxnJD66xlBjS3B3IPCuqHLk70O6tsnzEA9/eb1LZms5qYBsCp
	 0Femi7BcuoSKg==
Message-ID: <37454322-3442-4510-b339-bd968cb9ddc1@kernel.org>
Date: Fri, 8 May 2026 21:43:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-4-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429152924.727124-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F9EC1C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: 3t6zbmwhxci45cfumqhm8qxo46jgesur
X-HE-Tag: 1778269412-307792
X-HE-Meta: U2FsdGVkX1+YmHZz1VGUa3HMSgNM+s1CJwWGtXVtvNJ1SVrAwcIHm1Zhi5etCC9FjpdoD4mwtIOLj4J2j8ve6CsHHtVKYT3PyofFp40XS3R0q/0tySOxWrSHDQaJw094jDoXRgedNbrW2xqR++1cPWxolXI1USvPD2/r3MW0Hz7kOwL23QNl+Gxv01GU64KTCBuxx/Q7zDvaEYpnMmZLJ5XPyDzyuAVLSwKJV5ql1ncm8abp7o6Ess39ateLjcPlu3WaJZXy2GUoKDtn42h3p0xV19qwQSzYzJ19XMnUazrfLNWZSP2ykejIdhrYXh8nCNBmVHdn69v9doqwJS25q4saf/pwIBTGjISTYvbNvzSsRmSaibW1dchwTBZHseCSnJJMECh3cpZYHdth2pkZNA430oWlByumgfNfTXTKwzZC8C7cj/r1ApHzsHOGu4Ll6B1lfx7yT0heHzRMF6yuJyoVvfgu0lkQRSjNFB/NFN2G1+82E/cNAthoFPIbIrUwBpxZNvxX4jHF9+r7G22G4PN0fOTxO824j0xn58bL0c4hmXO010dlDixP04rdy6/1PcfyiOI/CIucGv8vTrdFJFgD7WYqlfNM5ryQg9LkeEQwllCPJchXjxm6ilfGksrd+NLJdHXBgn9PqAv4whAh20BJmkvU2uNDi+A9HdF+/IrG3yfVxzyjadaAMzVl1akWqaiaaAstxm/6jIk79xtbJ0q0A+55I8LYGKF3o62hH6N1XvNxgQRtGyP8iaDHZiDSnYZIcjgyBI9lT1Mospamt/B/q6ePlV50dFmApSjIrURD90KPsrHBnsuhmrMFtRB5N4Y2FewbD6bFzR5AbnDZYbci68qteY2jXKVe5WUAuGoYRwKNFeorl1egfCbKLwkDvl6U9p89jyeSZTctYx8qs3jtVyaaYbc0rT2im6febcNHVYAXoGxCQpnmu6UB9pZdKXDm8QXXZ1YpYBJlIWD
 wRJRKyQR
 VZgS48MZpqdJFoYDxoOOxZMDD2hcT/V43lpJ5rQWy/nqTgdXWp56KK4RapGYlrr1ZurWdD9hkIJbeF42zzx8XC9O9TKPLN7d5qgy6oeGGwNgozMK0kwLEl8Jxii4MW1r6wT09HC7MOybs2hVcjfUFmUfcxiUQP2MkD7kKY3snHaXRBCzD6YWxejDhjlzWZhgtWTvqcAVY36nY7OkdzqiIpFSVmhGjzfFrr33rez2XuCubSjiJblfripMJMATBRIhQUeEDijS+r3rjRzskg0nP5d6q5pV2k/DI5uzOcSSggSqw+ZUBMA9CUEIZW8fTSiDanSUx4TNzSl+2CH42dIhD7stqmoS+SFE2HY+8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 17:29, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD folio is supported. Keep the inode open-for-write
> check, since even if collapse_file() now makes sure all to-be-collapsed
> folios are clean and the created PMD file THP can be handled by FSes
> properly, the filemap_flush() could perform undesirable write back.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

