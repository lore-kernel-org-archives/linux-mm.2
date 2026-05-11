Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A2FCD484A
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156866B00C2; Mon, 11 May 2026 11:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E3A6B00CF; Mon, 11 May 2026 11:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0442C6B00D7; Mon, 11 May 2026 11:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E93EF6B00C2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:28:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 925268A477
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:28:30 +0000 (UTC)
X-FDA: 84755520780.06.FAEB651
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BDBFE4000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:28:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oXOo0Oa/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513308; a=rsa-sha256;
	cv=none;
	b=VCH3DHnSbzjAYSmZF3cHDw4bZXtW0TweUwliKtT7HSTmYLIbYIDiNYaXBog7M0wbmtAj0Z
	dAVdD0cdVudSxjeu4KZ2m1TLtmU4lQKWvqxEjEbruJ2Sv0H3X4t9bqFqdP7jMMvAF5U9/4
	ZPlxFubjSMxy7xGjXyAyJ9VvUjS0pF0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oXOo0Oa/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngyya0n7FUZHsfgtEEQKWhQTC+q9xGjKzkDrmPrT8L8=;
	b=bn1j0EtJjRIJj4hC0JBzYy2kC3Ifxa/FY9IXADgSafxSX3pW5pC2WfkUM96O/Lz0irWyoV
	MUqYogedPTieMmWdrSB30SP3UPf+jKrEvhUVtmEczC/94/aZ3tSSDoKjy+gaZwieWlI9HF
	PE/f8AzCJyZi/pZSl+MK0KAIJq59LEM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC3C24350C;
	Mon, 11 May 2026 15:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5852CC2BCB0;
	Mon, 11 May 2026 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778513307;
	bh=2aroQtYDtjSGspp1QH3bOqVOxqQk6yEJHUDxYLOzoEA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oXOo0Oa/mDKzCQVgJEAP5UCLHyjZd54DPuMXt8vBVcUe9kzBUspRII79uVAJc9soE
	 E6fG3W1TSy1flgxpY7DjLElBAbIjhK30EQDTBJIvasHnVPmg5FrMNLeBNijoji/jrZ
	 ZNZ6OHoK56HB8S4Q+xNUxOJbRPTtZZ5ErPm/GqT0RhaXHohoZM1PtL0i9d8GTiPE8c
	 WVQkF/MOtajWsLsOyO6B8vHwFIgaOqgek4aewgwM14UxcSRftJc5ymAtvNKc6HwSy1
	 V97Jg+P1/tipKP85wnDrCRiE2A9HruP6AobZInPBKNUFZJBsAOtRoUJufvHg2sqOM0
	 NtHI4BOYd0LBQ==
Message-ID: <79cf446a-f195-474b-8122-93a2c07cf8b5@kernel.org>
Date: Mon, 11 May 2026 17:28:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] s390/mm: use free_reserved_page() in
 vmem_free_pages()
To: Heiko Carstens <hca@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
 <20260511142157.9589E90-hca@linux.ibm.com>
 <9e313bd2-cc90-4b9f-9d6c-7dac8d9ec9db@kernel.org>
 <20260511152226.9589G9f-hca@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511152226.9589G9f-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7w41o1gxjs5y434c9tmb36p37i8mbba1
X-Rspam-User: 
X-Rspamd-Queue-Id: BDBFE4000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778513308-558590
X-HE-Meta: U2FsdGVkX1931jd+2OXrQn+4/8hZiZMHgHaPmYqtEkTmS1o6ODpS8WeBZSIHB5Viq/MX7KcrjB8aidyxNmDV0f9sKGhPW7W2zYwB8rk566MRLXu57UIqiHroo43CXHpADKcD7JqcXMgUNA4Qx0wqq17bjVX9FqfzzafDW0QJ7jCKXYtryi8NCmLLxnqzc0t0bx1RRA++H/lR2097vQZBJKNt+mjJ1UFHzQ+mHw5gmACVIOCug5LB6CJpc2Z9XQ10YOKDW3gnD9uhsraSsT/DUph6heE3MopS2RiSX2liYKGW40S0EwXSj/KO88pm7UyCbW89tTQlGdEE2//6AiuU+9ifNbxcJOr7s/kDl2CFJtKMRdMdJQqwoZn4r/K2y8t0UaXnY31CODt7q5XjyzhG5Pgr87NXizKGZvKGUNIR5yN761Xu7Rf6SqU4p3Zi0ZXxuCF/W43s/LNg+dmqtT/aS5LcQyTNj3Ic06kTm6TnQu58qyDXVIi3cddnvQXyfAQBSs92N4ebGrdaJspTeJgz0gmjHCkDiaoREVnAPFeAqW4/b58+/3f751bVZkZR0ILjTVOHd7LxLjVL8TwYsJY7+cGO4WBxRWdcM08pOk15ztu19/O23QkpD7JueGGzcJA9ADMFa7kNF+p4/wL4clFJAxYsJri1KU5HC7/80+uM+kP2iE+bsb1lJVkOIdgvCqahcGvEwRO9GomYZ689goOqnmdSUByyCNuyF7lw36agjxRx5XX+bUVbpjzybuf0U3O0ssvXGYJ/uma60fBrtCnQiK5PKesZw3H5p2D5Wp7hyWemEaUwABjDfg8/A5JswTJi8B4kIKeFqL5CiENb+Ylu94kLIYRJNgkxHLwBuvUwIlX695wJTdfdgt7DjPSJBGVCb6l/sbN62CddHMT7YC/8WKX93agInR2Cn08ZRA0YNQnmNCdtgVkyAedTLAPT9llM32Mjr+P9gknew98RU5n
 iIMc6Tbl
 0PBZRSJzp8/KcDr2mcULsoyvzh9H9AM2Bl14WJp0cwBm2URZ+IYepSzNz2MZRaDoND6/fISg8SKjLv5RfIyXu37O/oQQHTSgFM3vuTRIPZBwfO6uMI8p2bYZlgk5dbeqcSNS4Wcd6Z1yZoDwgcf6fYC57wsP0+jYfPsWpMtG/J5lMT0xZaxaynb2W1QnQjtvWJg5UzwDC5SqruBrDYrbe15pwSMzks2YXhM+sSQSvFpzQlFHfw6pc1bm8Qp4QnLE18PZPqR8wXIn+8S78kzz9ePWrpN0TzbgIOnzxHnIpK1MoNlTV3pPIhPxrvumvNhtPHl5guyFtulLKqUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 17:22, Heiko Carstens wrote:
> On Mon, May 11, 2026 at 04:24:16PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/11/26 16:21, Heiko Carstens wrote:
> ...
>>> What about the implicit call of kmemleak_free_part_phys() which gets
>>> removed with this?
>>
>> Thanks for taking a look!
>>
>> See patch #4:
>>
>> https://lore.kernel.org/r/20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org
> 
> Heh, right, you can't expect from me that I would read more than one
> patch of a series :)

:)

Let me add a hint that a recent patch changed that.

Thanks!

-- 
Cheers,

David

