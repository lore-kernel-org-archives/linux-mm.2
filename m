Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70685CA9EBD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 03:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82AAE6B008A; Sun, 11 Oct 2026 23:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA726B008C; Sun, 11 Oct 2026 23:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0D16B0092; Sun, 11 Oct 2026 23:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 502136B008A
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 23:06:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1CDCC0908
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:06:14 +0000 (UTC)
X-FDA: 85312485468.10.E3E7D96
Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	by imf28.hostedemail.com (Postfix) with ESMTP id 94ADCC0003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:06:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A1fBpdhy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.165 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791774373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1OMfZIbu9LckXw/Ho/PazH+AwbOuqA6sxTVPfh+TTk=;
	b=Z7EFlq7JsvQo9fXYpHRNqDLD7W6bMdwHqD3YixpqZIdZVSbzc+rVHPSvPPKrA+AWS68TdG
	4TmPyLfYt1wfeQaHDdN3kOh/8LjnnGAtJ5qYmQUeArZQohBwies1EeSC7XUU0Vixc6xWrL
	C25mfSHvpKdFCTXIVkfKdSl+1ZRHBac=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A1fBpdhy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.165 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791774373;
	b=mTj8WHwMKH0Ff8lUyUqHb93V6ny7Bg4YiGhqJnd2xJ1LTyjLNWGLazJo9QnYSWyGAexQhn
	fHX9ctSUarX1Pl7R3WxkyUPUa4Q7UOvBFsn+3AigJmuJQPGIZZwf7ISSMZs/vqZ/Db3teU
	Gv/Cvtc9TwcShI8bWznjeKwPajMQKqE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZqahB6iGbcSAawApacCpm+EpH54wUNgYNo/E9F0GBaU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791774366; v=1; x=1792379166;
 b=A1fBpdhyodD5ZOjJG0Uc3TeSP+ncgokW2bZygbQZvM4i5frfBal7a6NTZMA4pYmcTAmR7B6G
 PWp439SvcjpUTGWYZcz1WvgTCDJkljX2R8eFfDpwjmZpew07YkLm+NffGO01RQbYxwkI6V/HLC+
 c+v1HBKPjCEpmBk3iVyg9a5Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 5dbb87babb859b87;
	Mon, 12 Oct 2026 03:06:06 +0000
X-Mizu-Trace-ID: 5dbb87babb859b87
X-Migadu-Flow: FLOW_OUT
Message-ID: <4f0e115f-0826-4139-a6a2-30e4520f33bc@linux.dev>
Date: Mon, 12 Oct 2026 11:06:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] memblock: Remove unused exact nid allocation API
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Priyanshu Kumar <priyanshukumarpu@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260919135327.74089-1-kaitao.cheng@linux.dev>
 <179023613121.508753.1739135911194499722.b4-review@b4>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <179023613121.508753.1739135911194499722.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j8d6s9j71uxtpqtzh5irkc6ezcij5ipq
X-Rspam-User: 
X-Rspamd-Queue-Id: 94ADCC0003
X-Rspamd-Server: rspam08
X-HE-Tag: 1791774369-614850
X-HE-Meta: U2FsdGVkX19lrk3eW7skMJ+UAbh0EJKFPwiBLt9u7qsxKYmxOE80BPo7XvrcLjCQgfp1CmCUblNXjVhYGrlJYS8T9RkYEdhPuTvmM9jZGS4rGUE7EM7gSMp81pE6nB4aG639WN+bl7qHzWcLFt93Phg6dtVT3ilF41PVLVoAr4XRLIny1xx3bSipSVrldC1qvmLCkaHSzhJ2fss3b+igqHHoV+kt/XFtjJpcdwWTNF0EWFSx7Gva8YsYBFCn5qdZuxF6uIzOdB3PG5FGjGATlNyG5HgcQWEv/9fU3iHjoQqZxouqPU3etxi30JBzOjUuZcnECxg32ts4JR+paszh8mKyX5RTRltTScgO+WxhqUI90qZiKZI05NTGH+yPtBpqHKjk94/YFdSO9UbSeJ9wfUKQiuOyWTiofVykJEiNsIqKCaf+aa4E/lVO1hNItto5gOumQipXsP/LrFgweL+oqAN+2WX/fqXc5rhI0q37Yc/SRcv5ZCLPi80zMJ2hcBLRaiFny9323kuZY49Z6pk0tPGY/Did2H7ZtTRpbvJnAC6zHt5kFxTOAXXkzL902d19PXoWs0m+p5jyBhbLFm9tBuPGcFiDfnt4GkSdh9jmime1WNh+3n95AU2FCmMBJ3kXPfN3VWqrZIYBL1v76AZAkYWgqpiC1ljSOJCAKjHjiAfofGL4+kaOYMRFiaF16KeBRdd9rS8aAgWcB0H6Ha1/oDMfrJj1ZyuQDqBTfvm0w7OmeWQAj+AQX6ifIQ7+Wd7uFBrZNcuUmAYWBykS16tQAGO5eOBMwVavJtq6OB9Y4NfxmHUtwzRNzI9anfd3cZNWe9JNt71Xdrq/NbwzRy51eKFfCueKwGZMIf/bcn+/FCmla5xjO/wEnhzNvJISOzFUp7iVKxe/KyxQIkT6dnJKYl27AaF5gTrxRIgDb26zULVqt0IPX6vcJe5cvr1w5hzK1l0VNYLnWsmZsub6nrp
 j/ZlVnuQ
 Xg+K3p9J91jdLohS9E9zbHtgS6bbJ0DL5HBNDNMOdNXbGNH3GDmPRHWfI6JHS4hrTd+8aSUCCuYgcrF2TmnPZfEtNsAfxgEvNn6gQ3LLBW+VSX24n5FSVV/1X+/tPjs0jtCtbfOhpQDWBo447duUk7D2h04ue/xr2Mtxd8pNFuwfPv7Q+8OlZcUwwHI4MaSwhj7pbDgXyZajxD8zuFYyz5zbJwcpH2Ou+eB+bi8j0EyIzYhCLsZxDOaFGBUqcYrMX1IyAFTItRAPLVJExfHqKx6ScV7iEOJSsFAT1+cTgaDIv0yEr/I6pD/S6BcaLUJm9jBU+vv9Xeo1muXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/24 15:48, Mike Rapoport 写道:
> Hi,
> 
>> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
>> mechanism") removed the only memmap_alloc() caller that requested an
>> allocation from an exact NUMA node. All remaining callers allow fallback
>> to other nodes, leaving the exact_nid argument unused.
> 
> Overall this looks good to me. There's is an issue though that mentioning 
> commit in mm-unstable in the changelog does not really work because the
> commit sha may change.

Commit ffe55393137c was already merged into Linus's tree on June 19,
via a552c81ff4a1, so its SHA is stable.

> Andrew, how do you suggest to deal with it?
> 

-- 
Thanks
Kaitao Cheng


