Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39072F9D0CA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321816B0088; Tue, 14 Apr 2026 08:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9376B008A; Tue, 14 Apr 2026 08:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F5C6B0092; Tue, 14 Apr 2026 08:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 130266B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:17:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A28BB1A056C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:17:40 +0000 (UTC)
X-FDA: 84657062280.18.6F6C5E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC5ECC000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:17:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MsjpU+x1;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MsjpU+x1;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776169058; a=rsa-sha256;
	cv=none;
	b=nC2JIqpwglARsDovd3Es0HgoJAZVvQeqWahLKc3Jgj2H9YKN5Tf6aKPJaIbCzPg/BumrnA
	S+p8BvAbS1GngPshpC1qNINI/kBMmar7obJnpSBVmNtB4Qp006kWHLPElRM1SUtGSnPsdQ
	149EIH2FooVpMm83GIDvwxB6sHM8i/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776169058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GrSdEF+JqZFoj7agI/H7KkVJBrY/vQ9XnnPksvwoWxU=;
	b=pZBuEBbjmgY1EFGnxTEIMNsu6X90l6ZTFKIeFjCU7oXCDPub3riFr5kScJhDq2jsQO9LE8
	qzbBgw3D4EV7eY9M8FNXzOMqwQo4SOpvTxvCcT/WiVWd1lEwWWGnNHziPn5RUs5irZyKZV
	NRJjH8hXVUaV9cV80bj+3y8bVZUIywc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E39A43720;
	Tue, 14 Apr 2026 12:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B12C19425;
	Tue, 14 Apr 2026 12:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776169057;
	bh=oC6Dg87jkmwO4/6ynndKIVQo/FD4gcqiu6meUZwGQv8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MsjpU+x1PFgbJdR0CpqaWmfljI0WBVQGF+x8L1knWKizXH5VsJie2EoNxxMEpuUyt
	 Xp4mjJfpXDq9FP/zLKxEW7ZFgTCjn7QMdayaBbx75OZLkDKAE14BLmOnnAuPLGGtzD
	 84MDeLOxxmPt1xmhoOJm/ztGarQH7eF4n8n53Amanzjy19DNCwlkMjL1kg72vWtE3I
	 Wp1A7NHFOw2pGwLuaOvTYgSpLoLOZaXeKXUApoiZP/PpmBfp8WT/WhiLzK0HeE9Ec7
	 HPqT2aNqvNVuD81j1jnxVZc9A0aBJcVn8W3AcV7IT9pL2lhwPxuk25iIgjeYfqO1eq
	 KdceBkjARWs1Q==
Message-ID: <90d0abf6-fec4-439e-a7b3-756e3cdcba6b@kernel.org>
Date: Tue, 14 Apr 2026 14:17:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/sparse: Remove sparse buffer pre-allocation
 mechanism
To: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260410092419.2446420-1-songmuchun@bytedance.com>
 <abf05960-87e7-4f2d-9a10-d6ec419eb2f6@kernel.org>
 <ad4u64rfWAy19kup@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ad4u64rfWAy19kup@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC5ECC000B
X-Stat-Signature: aujccwum7ewczih3uns1edrfamh58114
X-Rspam-User: 
X-HE-Tag: 1776169058-488488
X-HE-Meta: U2FsdGVkX19FnnZB1WWx+lEKYicTL/x0yBd0IZG8gewZdo/qTt+WbOJYl6tl7+L49WqqyTBGI9lRxDbS256YSVmPxfXQsIMYEWfOU2wnPJTui6GvD7Nw850Y8ZbkgJD9+C/dhF62QrhYpFRFjcoKcyrWAWqVkjhRsFCYMVexapzJzg11iR4m64AoBV2EOEWbrtxrBIeSYBnflaf2EiOlRhHy2eJGoNgfJKGKjJ0gjfJLvda4nEvTRKaPfpJEtuPjN9JDsYRo5EAQxnSZguA0Mu0A98PDADLCp/IfnavgzJlZo0iYypCoWhpqFaX8tnwhKLYNgWTvXSu1l1CIuyI30F+JoPsisTQ88AcD8xHCb8wjLkSdEV1WDex9Lk3NQJKB66Thx59bXcaOqH0E+g7BcM8S1kXCJQo8hKCV5795mWi/MdqM7VyfvRahUe5r7wlTMpN8icPsbjIkis45+RxjLnS04TZ8h6CHsAAnKpZsr8S/tXi9hVGf7wAE9mc/TZ4Sx1ZDNj0TzU3frmHNU7SSRoiYNyTabT8AhjtMZO0lhJXhJRWysxVKSYYPSqZkk81VBkXBJ7mnnAWLdNkdP6eFNzgxPWsWa9AwvdD/hiCaMaspdEE9S+9ioglKRMFoJTg723qAG9coKcdrat2u+3a+Qu84jt1eC9e0RIHlgKluyiR/5GeijRpEPp6OFWnl6aZdctFhdJuwnEplBBePH2Y8aMK/aXkBiuAwxyUVgTgshSm29m36Pkzhp3s6zzcrtBqCbXxARfOwAkIs94vTZuzFhoQ+m5TVdjv4AIjItOOWX7Nq4jSizP7DaN+OAV5ILr/Pi/sEhA9lbTSEjDRej78kN3Hg5m3ymi65oedWV8uhR95M7oyZyPB7IkhfyqGyZJaCX+g7OpJamfxkwTU5PJBJBroTVbX1GPWOSbWvTq5nZEw2mbFgFNf0jazq+aR9arEsKWhedX46qdZ06aMcabk
 eE1S/HXj
 IQWBV6Mk/31mfil3dQaLQw5+yF/Xzyjae2wx/0e9R+0uzwnSKtcSMOcxpbU7EYEysDbqka+ya7kl6SZxoqprTP+REJXG/NI8uh7/KjT3FPov7hpbbitnhkdB1bkG29IGakV1a7koccKzb0qyATbdo2IijMO9EIoIqN+5jJpcays4+25GMJGSsdCsQmETRSJhdFA/OaOtqb43byOBQZ3dcdRRtD9lzw54toZeySkcrLMYErvTAgPCK7ASrUe2W5gjVdf3O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 14:11, Mike Rapoport wrote:
> On Mon, Apr 13, 2026 at 09:02:43PM +0200, David Hildenbrand (Arm) wrote:
>>> -
>>> -void * __meminit sparse_buffer_alloc(unsigned long size)
>>> -{
>>> -	void *ptr = NULL;
>>> -
>>> -	if (sparsemap_buf) {
>>> -		ptr = (void *) roundup((unsigned long)sparsemap_buf, size);
>>> -		if (ptr + size > sparsemap_buf_end)
>>> -			ptr = NULL;
>>> -		else {
>>> -			/* Free redundant aligned space */
>>> -			if ((unsigned long)(ptr - sparsemap_buf) > 0)
>>> -				sparse_buffer_free((unsigned long)(ptr - sparsemap_buf));
>>> -			sparsemap_buf = ptr + size;
>>
>> This code implied, that we would usually get contiguous memory sections
>> (on the same node) to have contiguous PFNs in the SPARSE !VMEMMAP case.
>> That will no longer be the case (reliably).
>>
>> The code must be prepared to handle that, so I guess that is fine. And
>> we don't care that much about SPARSE !VMEMMAP.
> 
> I've started to hunt them down ;-P 

Nice :)

-- 
Cheers,

David

