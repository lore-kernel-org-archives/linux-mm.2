Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FBDCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 19:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F926B026C; Fri,  8 May 2026 15:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DFD46B026D; Fri,  8 May 2026 15:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8106B026E; Fri,  8 May 2026 15:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 764236B026C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:46:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34D98160293
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:46:39 +0000 (UTC)
X-FDA: 84745284918.27.FC950E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5FFBD100007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:46:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKpHqYe6;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778269597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUHx6XWiJDK/4zI+K0SPGUIcKRjvREeFp55/SI7Vc5E=;
	b=YxPloX3eDzgU6yBsm8AK20YMIe3+iJXg89voibLLe+SO66kihUge/qv4L6jo/PUP32SHXs
	DJWK5BHTXQbXnwTdE1KP8inmZMNsmqqUKqqBJ3lZm+QDKnhwef8VrkcZ+7JYKR3FuG2M1r
	zE4uWgFwPbv/f46Iw+bZOfG2buyIp1g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKpHqYe6;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778269597; a=rsa-sha256;
	cv=none;
	b=ZpVKSY+JndVkZZZkPeogGpLnurjQhQgc731ip9L+crgORlTQY+Cc6xAtSeKn2Z2kCBPRUc
	Nk1R7mPBBDSFdLInfdQPteFK6FfJfyxbEq3jyUB67vTjoq1cCuDpXDHX19lcbpX4lO9YVf
	YnJF4PdfCQNQvWLoHvaR0i95yxqyr1Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61FC043C3D;
	Fri,  8 May 2026 19:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61453C2BCB0;
	Fri,  8 May 2026 19:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778269596;
	bh=AP/csasG3IScJjNYEs9Zv3ujE4WcsOcNE0SmpbZPdLM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lKpHqYe6W6R33mkJXDELMsu8RFuNO/sq0dNtC6h6Oo3PMtolQzTeVnDvuJ/ls9YVp
	 jrIifreEhlQVOmiOW4+2DhNgbUGNFwK/cvswq/U6ohIRJJLUz2q0cqXVxOgrXEN42h
	 2LV5subwM88Xo4CTeflKVNFAJLoIHWnh7NKCdY8WMv0uY4X4O2jPQPj4QX07ok/kEu
	 iETRNeKL07RjtIrLtdYn1uBZ4infisG+uZRCD481wenJ+kkYoSosOXN6Ui7KVjDLMr
	 ybZBejtIi4cgs9Cemy5bxVMNSa/qtFy6mvZDpZC0asH11nmf2ITFxnREKt9TArJ2sh
	 iGAAawYhsj6/g==
Message-ID: <58947d4e-abb5-4d2d-a668-2ac76ce59382@kernel.org>
Date: Fri, 8 May 2026 21:46:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/14] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
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
 <20260429153538.727855-5-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429153538.727855-5-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fb3ryec1i7o4ciacbdf8xycdehfqh6n5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5FFBD100007
X-Rspam-User: 
X-HE-Tag: 1778269597-747733
X-HE-Meta: U2FsdGVkX18eEA9qQawD4ufEmq1UEeEkFi/VnVK0QkfiaG3SUx00ZHYI3cpwquQPt6fCHYdETXhtMVhVI8HSfwmu3B8HcuR4Xh1HyglN+hT+poQ2anCZ0Ro++WofYyvT4qIZncJrOhqpdxJNo8I/SFlcn3zlnZopo6yKU29x3e/IxI/QEAYMPPqX133eK11kY+V8fLaB14rozMKJlWf6kmpQByx/IFS1gLrM79kU5trGVyElEH3cFuYxQ2h5gNIc5gAiOULn/p/JpctfhO19h5KWvgDXYdp/h0YKPWZRwsXLWIzQEYRAXIM7oY85fHGqFh1S9ajYrAKFJEuTcD1F0PhSbU+UAALWp3iHm7erYFJuv/foWIqbwCIrEMJi9pj1c/nZ3/cWL3X5QYJB9rUw8IW9/yKk5mVAyRJ5lyJDLlCQ9feE33FUiAp20jIR6PtTJrLNcjQc4Z7SqsJMSzV+h4W8+jNIkFEr0eCJMxq5NEHd7YwBdkFw46aEAJqu5yZY5wXDe01O+bnRfZaX+rz1wzUaLeDh+OPWPZBAymZbdSKd3O4oazy+SSN51czRcKFqRBJU8pZmWT5WewQpb2crc+4TKSRvG8pMAX6L2KF3PuN9cHxmnCcFb2bN+cjH8R8H2iZkp3UShI7TLaCcbK3zv94thgMgOFiyILedm1DbuJFSWfqAhXqSu+8y0MroitdT70K9tDQK0iJv2VAjg4uru+hcp1GxuobiiQfg0yJ+vx0tUHnYi1E2xyDX/AcVm9TuEzGTzq1DMawaia3YGv5edZ/nl7ly8BkWxXOr473OiRZa3eRc+4h6OM3ZuFnXcp0eeiVzkn+71IQ3UXFDXA29S6e/ZESYwJjqooDA2iNINIrrx5YmacAUUBB95BgJe51pEujXGMaWqR26Sgj/s9n0EtLmjTRyzYi8UoeKcu3XTDVP3VFP/y7mKWeQXdX1XFg6L3cE7u6FuETWzTHsPKg
 pINqfjt3
 sKCClx90aGFGYPd5XbU8IP1QFwafsKhaavAI462+Ma0/a0shrYztSlAMsNWq2YTiWK8o5pS5jkMGPMYTZmENsTzpDEsXTPYqY8M1gsUzgwe/vYiSCXr9K0QFS0QTX4fu/6LrmmPyexk/0gGtgNb1T8C/MAjkeawJEbTUBKzlRX3pasg2VUjjoXqjsgIOFJU6W1RS+TOrbEnjcPN2Qu2SYT3FydhSlp41kB6sHsLUP8jH4KFP+ocMHqQEuQcMftQyESkhnZy5vcwjIPiOEALRkwTYd4LE2yZYEkE0dqnwhV7wAh1qGCAoz+wPBBs8BaOHTOr0tTvSI5w+wfKAZGHkSMtCsTfZ7AtHGy3Om
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 17:35, Zi Yan wrote:
> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
> not. folio_split() can be used on a FS with large folio support without
> worrying about getting a THP on a FS without large folio support.
> 
> When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
> appear in a FS without large folio support after khugepaged or
> madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
> such a PMD large pagecache folio is split and if the FS does not support
> large folio, it needs to be split to order-0 ones and could not be split
> non uniformly to ones with various orders. try_folio_split_to_order() was
> added to handle this situation by checking folio_check_splittable(...,
> SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
> READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
> READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
> with FSes supporting large folio, this function is no longer needed and all
> large pagecache folios can be split non uniformly.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

