Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE923CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 16:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00456B0095; Wed, 30 Sep 2026 12:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8626B0096; Wed, 30 Sep 2026 12:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6C26B0098; Wed, 30 Sep 2026 12:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81EA36B0095
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:08:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04F6C140141
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:08:24 +0000 (UTC)
X-FDA: 85270910970.13.67D8AF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2F316C0003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:08:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z2OcQAIn;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790784503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuzAGY9JU2TzWKCdqwnCbEkDta67ZDfQaAdONcbKDkQ=;
	b=2RN4wMKlD3fMO/84l7mPbd7InmnRbDCshNb7w32V6qMMqmRy8qUwN9adBYkOpf5jt6fZDC
	Yzz1k0zhtO3shBr4hHJsp3LYZsyqX+T2wGCFVbXVMeeVZmhhTLpSmb9jHpelASIG0LGXh9
	kR3FO3kNr+G7RZREqE3rgRPPhmK+bTQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z2OcQAIn;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790784503;
	b=GibwkPuLxCDT+2Y45Tv7oQbYuPAWKoJ9aTMZTIi19JSGuwEOsR9Hv+NTqW9nQoMMHK/WuW
	bC186C2fEDZLFwaUcOn+8Sl3QtO7ADqNzcjdFNV7IROMwMFNRuzre04PuYJi4AHZ7JWGSG
	OFPDGfo/jrCPFkE6FVqEn1zE7NG71pk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56D2442DE5;
	Wed, 30 Sep 2026 16:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0A41F0089A;
	Wed, 30 Sep 2026 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790784502;
	bh=QuzAGY9JU2TzWKCdqwnCbEkDta67ZDfQaAdONcbKDkQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z2OcQAInw6YVpFm11qjcE42yrMRDHKoLMu5hgNTQctR/Kqw+5MsvjhUO3Rh1XyDlc
	 prwiuFvOojy76mIf/TtBhwZ/1qCWXIsluMi9NkM7eSyVP0OYH74X3STay9xrYAluic
	 ErmzGc4x9CWXeTXFuIVZlnYZRGiOGDKMnK6dLkg+n0kYhmfCvye4bVwX80tICHYJ+J
	 /A1OzCodYGQROIcXSG/vBrG0p1MFCpJNr7Ffmb0GCzgRXNsGyd8T4r+jNBr0gKkGIR
	 0Wl/ri1nmiwHKTJ8lWVG0m0u/UWPXcsGt34MOHKm8XiYzaXKXG2ELGfAX6oJjXZcoX
	 5v3WM6ZDICb9A==
Message-ID: <091706d4-96cf-4dbd-8f9f-97ebd3f8d81b@kernel.org>
Date: Wed, 30 Sep 2026 18:08:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: =?UTF-8?B?67CV7YOc7ISgL+y7tO2TqO2EsMK3QUntlZnrtoA=?= <ts930@dgu.ac.kr>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
 <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org> <art6x0XpWcT2aUyy@gremlin>
 <CAFPGN2jPGhcWVqa3k16RWMaMR3TwKyhFbYYF4D3L6L85T8E96g@mail.gmail.com>
 <7d120555-0c31-474f-893b-e5ee3466ead4@kernel.org> <arz82IHw4MqGTb6l@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arz82IHw4MqGTb6l@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F316C0003
X-Stat-Signature: e4k4opboi894ebp8p1dfo3t8b89wz9ew
X-Rspam-User: 
X-HE-Tag: 1790784503-388759
X-HE-Meta: U2FsdGVkX19pocKP6fDPkehllfF+OLvvE7FaA1IbB64di79oN3++b0f2njiMBiRSRAOtjDcy0+RRsCGuSGqlLB8b2M7JlxciuzEgzOpfJlsV2lNKwu1K1fYPMHk4BTgYBi1mNmeYZV/bcDIlACNIAnGjMT7naF4Q18Pk+F28RSrYck+Laz1pFV8dLSLCVNkO+pAsawVDl5P8by6l9dCn8l6gj4CfU74/tKv8ZBywrJ+WlRxg1HElN1Czf7zd2hILSRqwP1GvoRKeO2+ZUuBw/EsbERM3yw1aHkv0Bd75Ap9StmiszqPjtfkztqnPCdzobbEhZCbS/6sMTxZcMw5d7DnSaPbT60NfI9Tre9I9ylzZj+m6ALG9Q47x8McE9BVFJyKhjjS8uQiwNTD2EEBoMwkdWEFZyLJllzxsvWCDKrbZLyR8EBQophQZs9Rns4n+lA6D0WQ7mLpNo7h7CZGbUCUKxjg5FAMvm+aHcfmTmkky+YAiersMypboayBgzHIob7XiCuX1jEB3E2dBXFsi1FPva9wRi/yXxv2g7NQ8iD3HrhOgJK3Y4jMjBeofwDijGZj0fZdzwXpXYYMgrZle+rPKNJ6vQc/Yc/VSJaCQwfvsd3uuxdXBqlME6SdLvm6EclEU5PB2/ZCe7/jg4XZlHHFw2wwOq+P6VwN0gQL70h3Pjb6y9nsEM4YjqoyRxr9wZs8qYtAeMD6HSr7TrYswOTyeQtmfcUl46ZeBKxSi3Edkq5yVoAIt0zPC32/ClzQJN6WSOPvxq8EagL4+78guwcMQkZfllDn0FEQG0gXlwz7WFtQ8mw3rimoObmwaQIzHIEtO0j/2LX74mwKsq8Y4nOPErURfp2qsn9Pogyw2YrpRvqI59xgqr2/tQPvXi1S0Zr8+StRilQ/J1zksVA+XnqN63EyAZ1quJkDo6qVDFpoaPHCmUwtMQGrCa0BdKpgRzmDn1Tsk9006RXhHBU8
 COQmZ3Hx
 GArqa3lR6p4HIXoZlp2n2KnNZzrFtsPYcxsgv4qMOIAaZrFH7Q+pv1KIPG7nkqgLlDYTB22UPk3a6sT1mpcnTcyhzgxCJefiBNq/+Na/3ELt/3e/OHZzHqOihHuQwgjcWamoo0Cw3sc0OMNC9lcCwMwFIvCjbj9rqlTGu5Sp5Wq5z31sQH/eKbiGNO4NWF2gEOn+GlMgeZy/M8mYow2jCJgHPx7GcaB83dbzLlBkk7DHPxx/g91twj/E2tfLjRlOgb2QU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> So is this patch doing more harm than good?
> 
> As above, I think the submitter has decided to drop this patch?

Sure, but I still got CI noise because the patch was apparently not even
properly tested?

So I really want people that send "fixes" to test stuff first.

-- 
Cheers,

David

