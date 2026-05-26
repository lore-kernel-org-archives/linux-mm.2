Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B28CCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69AEF6B00B7; Tue, 26 May 2026 08:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672C46B00B9; Tue, 26 May 2026 08:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589B86B00BC; Tue, 26 May 2026 08:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 480616B00B7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:28:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD9C21A03CA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:28:44 +0000 (UTC)
X-FDA: 84809499768.10.732E6D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 33857C0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:28:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5Q1bxM7;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779798523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pNMoyF5/bJ0hX7HF4a6tMHceOt/pOJRDxfQDjzOKtM=;
	b=KGheZXRBVVrK7i12ENK7bbJfQH9BAuoLmS58K27j3Qn8Ed968MManpmZp9s1RdgELOuvo6
	Mpb86sjTcnwrmtslrlp4guH4jZ0X7mH1SK/3uWPmd/JAYyQeZwvBOt7uuLw6loFTmdpgSK
	A2L0ibLVEi2Tz7uSL9k/XSQ7bBSyeWk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5Q1bxM7;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779798523; a=rsa-sha256;
	cv=none;
	b=ZqLpefeq3X1ER3HWfIao+O6/485IN2HtXnYMCquCqTpmdqSZoFKrAKBoJ2ErOznRUIa+WR
	z7jBVCxnVDJqJFTctDXz0DfHt0FN8AuywWulW3wZz9ZhMsvhKIGxr5kcGCWRPm0fGnkxmk
	GqlVM8vX4RYcj5cN/a9bpoLNSF4zhro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC65C60018;
	Tue, 26 May 2026 12:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF291F000E9;
	Tue, 26 May 2026 12:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779798522;
	bh=1pNMoyF5/bJ0hX7HF4a6tMHceOt/pOJRDxfQDjzOKtM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b5Q1bxM74cJOhabEHVGq4pWyKcjYmRTP7mmNADIHx0fTRg4NHF/YblZMrCnJ8yeC3
	 3/Bk0eWHBPe44aUQMk5dgH3eOd5AIK/GeCw8SWerOLOm7+qSKjegfwjU30j/EMK2l5
	 nQcL0WR9GLSh7DUZDmyiT+X47cm0/D5jEkGfMDdow7EMFOclkNirlm6mW0mellhFkK
	 EkvaPf059y+2iG0jldYW3aJR55+PWzBU1qH8R1oILqcjZkgzGR8xBcb4lnEXkl5VQV
	 1yRE0dhLJfrF+GlmLq6wRJIDu4dzT8ZQ1oKjfvs411N7Uie1Vg73Mi2zzjaZbBZwDn
	 HZXoMltrRSWkA==
Message-ID: <62fd5642-495e-48a9-bd9c-7227f4ecda41@kernel.org>
Date: Tue, 26 May 2026 14:28:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] mm: shmem: refactor thpsize_shmem_enabled_show()
 with helper arrays
To: ranxiaokai627@163.com, ljs@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
Cc: leitao@debian.org, ziy@nvidia.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ran.xiaokai@zte.com.cn
References: <20260525102700.68707-1-ranxiaokai627@163.com>
 <20260525102700.68707-3-ranxiaokai627@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260525102700.68707-3-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bh9s6mjfdjofx4ahdg8b64ppfcyes684
X-Rspamd-Queue-Id: 33857C0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779798523-829274
X-HE-Meta: U2FsdGVkX19dZxD/khTpcmXYEVuuAsXhGHPzEpISY0E4oqrWnEbwc1zOgoApwolc1eKjOhQGS2iilg0iFw4wMq039m/WMNgcJzxe9zQVfVUEuFCcBNqoFEKC5krpBzS8o99kF1dPAt3yZKVsHf7pxQiy2fj9bIyES7P0W6z4gXbTATMVqsNZY8cMWfvPwz2Fa+m8RzKHRQoNFTK1ZJZJDlkwB4qhHjzW4TSttlbhJB3rQnLkw+XsbFncPh7RWJOXfbgLyALVzgHPgC6bdOiF9XZNpiXzxBxw/yzfUSW0UPEHNHQ45yhh37xajQKRfT8Mddt4qR33rAYVUhtoVWQ4VCwvfKVmje8izCsm1YpZjszYSUOMtl3Ltxb20F7fZ0PGtOo/Yge05sGM43jYwB8s3vcQQgG/3mgnWnnHvn8DEhzNpjV14sNHz9px+Ck1JwvnwtgjzxNkxrEUpjlCa8sccf7/VxCLNCRaoIbE5r82Ns/I0imU5WXn2v309Ml2v/EDbX2IhAF5ck/AabSQmGCwDs9A0kbiZaBhxyG5ChYz3K0IY2f0+t3rTiWj364B57dO3EyPTtk4aU4YtDAxS4NLqwIkf91c53WpFqVlyjUGr41oZUzszzBpklkXUik8+gzi0hTWDNGbTgCX4PFsP/zhnoDUBwASHNACzs0uNDz9ppOKIFWtDcROpFxubTHEq6LCDbbFv80aqKcda8x5Skkrfv1IJpJl+cxGWHfF8I4OTwNDrfcts3a7DiEnK7gmFTT+m4feX8CGTQTrNt8TsiDMU7699Uld2xyv9hScdAMcXPBeJIzwWZkbFqwdYNlPXPTxqwyRcjMcVPwQMJ5nZadrV0LEExML7Mg8didJrU3+hPq3KEi0XughT5rSajqWoepBzkZhl20+Rm0dXETTYKAjEsWqbRDOichjhIJxG4Ytbi4B1PfOUvJUDD4Gv93DWHkfbDgehJsl+d/zlzJj0j4
 YzBklZx3
 QcYaUmt/ZKNByMHH6w8ic5k0sfAcRVESpecQPP0pjB3AtSTOj7HSp2ksR3kAbutCHvzafZ8aM0pLcngqQOkCG5dqV2fgNJqO/+DKhQideURnfiEwAqZH3jBpg4UuenasVjrrNCCrf70IRfuYihu/6QRkAMvhNyY7d03om2sZmm2ARLCO/tlkqjmWV2QVC2elxs9CA35kvU6lzFILwffRQetZIwpsUzID1Vhv2EpQXyPLLixUlV1omNzjYgjwDkRZxYzNhd9Vo1fO7kvNKbvoqlhkQRcuZdsPZb+sHx8WCEfhjAJ8LBuYQki3eDQQ3Zulnb2isNnoLG9H6m3nMdEhFljvJsOKzGV10l9Wucs7FtSqgoZWSsA7QDrjNRoyaaW5dPSvR0Lm0Gpd64LlG1OZQ/YrAc6yGx3xsb0g2xQurgiTC8XHQAhB7nv1UbcBnjRGgcLv8+TeHgOrkYis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 12:27, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in thpsize_shmem_enabled_show() with a loop over
> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
> 
> This makes thpsize_shmem_enabled_show() consistent with
> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> ---

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

