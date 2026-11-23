Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD88606A326
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D7q7IMGQ
Received: by kanga.kvack.org (Postfix)
	id 8797F6B05B4; Mon, 23 Nov 2026 14:56:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851756B05B5; Mon, 23 Nov 2026 14:56:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767706B05B6; Mon, 23 Nov 2026 14:56:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 440676B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C120FA849D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:17 +0000 (UTC)
X-FDA: 85467440394.08.08AA5FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EA1144000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D7q7IMGQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463776;
	b=gj/ecRDX4EyJV9PFiFFroq9j9WoUBeaX4l5nB4qcnw/3IOaPWt2eVMMpvzW84HskNkvT/H
	Wi9PWKPBJsxvN9rFqfGbyd57ZLQrz85LW+Q53NQWckF+0xHs+JUKkUZL9NvTMW+/WCK8L3
	UNCYMAY+U781YuOEAaVbSLYhYb7hZU4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fPZouNWyRPtjSVooY1HcDFE0twswe2XGLeRLchhRkY=;
	b=kRqwNITK84aPGKk/xToWqyynSOP9qkKuFbA4bUk3pv3qTvgXb+njZLho2D+VqWnv0ystBC
	ZNIwetyB+uE6uUchaRaBo//MeI3y1oIeRpnqWRjNZEYVaOfr3CUum1mjE1p+1nB/gE2gwA
	b37F+2qeXOcIrv74/sRCD06yPmrW31A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D7q7IMGQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B6CC415C8;
	Mon, 23 Nov 2026 19:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AB61F000ED;
	Mon, 23 Nov 2026 19:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795463774;
	bh=5fPZouNWyRPtjSVooY1HcDFE0twswe2XGLeRLchhRkY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D7q7IMGQt3CYwAetZek4wMXY/TQ26qzkv6Th04DihOH0WuX/9WANLeMFlEBEhogMV
	 tCwNCZJXLmyLQDwypudsOxfzLDvbJwXUViYVvWaxiLPrHbPsykWi1l7X18WpPCZpdo
	 o7KS2QOyyPE+6j5cnDeBSZH+3nw/MtjlXkOLoN5kp+Mt55YaRcSeRcy4zVhISCVkBT
	 JSNYjTXO6WdCYZrCXFZ7hih9lDNU08erj6c0xvSYPIVu+YjnmbJQdGn2VZnVmtCck7
	 aAoVpnwqmCPlwUfUdx0CeLITPzNm4yh5/40KCPO5mIyEn0iRR6D9Qb37zcgMtS1d7Z
	 nsIJ1gcA8hibQ==
Message-ID: <29a4b6e8-2016-470c-88a2-a6cbfdf8404c@kernel.org>
Date: Mon, 23 Nov 2026 20:56:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/11] mm/cma: localize init_cma_pageblock() to cma.c
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-11-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261120100856.16929-11-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s9g84c34r5kfhn68y4b13nfi4hgpf9zg
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EA1144000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1795463775-293829
X-HE-Meta: U2FsdGVkX1+Osyp+YtZX9ts/CNc5glv2uL5rROvq6ghJiK6X1UV98l+gpPZDmGXl39v10BHN1e4QgBttD1LfEh9ym+4guXb7iU3NE1mD8Tjiq5XSUI0svPk0uCSRbR6d0JseZ1ZWEzsQzw2P38uRABwmsBZBEefEHi8h1gVn19OgWMLuCaiorv0/kxJXomR2ighrqJmErgukXcIFNTX8QGTISphvX0KEsc7y2KRj1B1ODV3k/ZBzp6ytizAAcqVIN1q+AVvb+dyasVf1/I1wXhhE4NesJfQUZLbryBCKRgBC3iVgJgo5k0t7C5IOqA0xXo/rCejuxcY/IVGJxtq1C+JnoyQY6jd8xnla5XjZ+UXdhL9Q4yyUqETl99aCCn/5esqZ//uM0h23Laul7Yca8TOPeCfz7d8DKLhvLItyXn03YBG4YUYGusHw7R4iBPNN2Z75nBk+ntICDlAqk0T7dqr+0QfymetRNykbJmdNrHABUSiUXGiwzRhBtXyuQY/3NiMDsvqdEQXrxDqDhovNSE15KR15tpooookqr5v84WqhS2meqiqxhj45/8tUb7EOIMSANHdP4+XJDLpF+osIvsUR1aCehSvk0GLF2Mtav63MM+AFJTXEJaP5pwk5E8p7GYmk6wdQlMBw6ZZxBKgyf4+YslqFpH1fCeUQtIJuie0uBqujKzwVZSKAcLDfGz29X4nadBwBRO/Zo39D8ZCPuESHATlhSSFOWku2zyGdG8TWEzkGsuFdQq9mXLbodrIaaIc2nEH0BW8WJDkh5ild6a9M/D8PUjULmvHYwywqO1HYgC/HsjCjzT9+A8ne+mzW9tbyfl4tRiNmajEFqZkZLhxNUNRwpFfiM8L4iId98vuRdeADvuoR4ZOOU1xFVrE28nEsqgX2KKvM5kunop52Xhm3LqejAyTH8uH/TwqtfONZFRvxPRQIm9fBC3tPNz2qCsvpQdHlG7IvcjWVqhX
 UzdEx9vX
 mmmIJdHHxWJneRYL60/bPA3PxsdQzH4mrMUxt7VWIUDXH7Puf9FhFhyc+9NK+eYhBlpSJqHtqBUgk0VLV0lRUHyyiG1H37rt92iWU2gcnRAWfPunPsLnhctQa6qg+bJa29YgoGL6PsyJ9N2cCy/YAMB6q1iegD/m2Sf8fjNqIU/R9JSEe0SR5Oghf1jzJElThGHTgHLkfGrMcr3KBEJDKgq8RyWp9FDmaVxvZoApha9D9vJhReueMqOno0P/1GQ/eUsV1kwBZe35h/J2sYdIt+Rq02ibC6euppp92kujxHnpEYuurZbq/hvrq9HPt3SMO04ExQtGHgd1SVu+L3B+iQMC97Nv5/wz9E3XtU5YEjMEvFSR9tiDlO9HrXblLP4IqGMV23CA0uPMoieSbsGLAQI3r21m2GtQWEv5EMc+Nwo8ZOuw9bVGP2ovQTihwfsoJP3inuFhfqxNivnQgQ+Ng+EBFnOyVvGN4diShWAeJElIVG/A+YIBUTpo74yXilXaCXCSP2YkZXPAIasZLiPXAD1JZqDIVI4BlUJNRV7dk4+ebGwhL5d36oAZ5kcYQxIsk+jS5KHvgeWBbDyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 11:08, Muchun Song wrote:
> Move init_cma_pageblock() from mm_init.c into cma.c so it lives
> alongside the CMA code that uses it.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

