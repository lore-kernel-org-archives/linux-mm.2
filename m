Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 800E4CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1A416B008C; Fri,  1 May 2026 14:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA47A6B0092; Fri,  1 May 2026 14:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BC36B0093; Fri,  1 May 2026 14:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2D206B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:33:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43A501C04DE
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:33:13 +0000 (UTC)
X-FDA: 84719698266.03.C1C063F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 34A76C000C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:33:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I1hEcnPJ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777660391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTwFcpDT1gw6QapvP0CmlUDyVJSqRgXbW5280v/Zt+M=;
	b=gO0sOAmom+6sP9uw3osn151BDIrlP0giTIxrFT0ZQ/bM3zc4+rfwbFxsaW5sG/LsNiTNz3
	SRWzdG+rnLT4+v27fKSD0hrbF4EWLmA2+g5HuxTxva7fti3q2Bjj4XASxFqSSSuiB+iRL9
	QRH/ULX+MVqhfY/VtLfvvW0XwAvHsck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777660391; a=rsa-sha256;
	cv=none;
	b=Ov+tixsXSFe5dx1hccF/l0LFi2xJlbBM8LQ99keRtkdLOqFYomImBisY6NXwe1StAaOTwo
	DgePDXVc4d18H7HEIVvCcuhCWHunX18Z1hgQEIw0kpusoPd+3/YiPwcMgwD/SoKDJwYzyw
	A9yPDif2VZuPC8qLn7fBqhGihIC5AQU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I1hEcnPJ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1711940645;
	Fri,  1 May 2026 18:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5BAC2BCB4;
	Fri,  1 May 2026 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777660390;
	bh=3HJJjz0ErBEtCfCaJe+eUDFWBsjaHQV3cSioVL4tTho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I1hEcnPJviCPxnVe67YIQsM2XxcSEaOnMoDxNdta/dVw5Isd+xUtwj+JgAX8sddv2
	 jxHtwC8tqaXbqengfmTHh2FDFyAWkjsLGrjNQ+3/9eLIfKjYERcuth4yzdz5EH5gUd
	 G5AmRNGjNtE7O7Ax7BKcThBmabHD040FFmhz+fS1XvHuYHs4xhz288wFu6CUTBg2Wh
	 9nEPkVKcJF3Mv3xbTFGC+qSyM/BxyU8KKOsRKYK/DFGz/kD/p9I6mQo9S4o9zUBQHV
	 gnuYQwxq1pTQJpDzBnrZ0UWcHJjFnYWSVej+4coObMtLqk0lpB8EBKRWpqVirgPu6t
	 bI+LBqNmW8Ylw==
Message-ID: <c2ecd0c6-fbb8-41f4-a7fb-2b1f15d1fa12@kernel.org>
Date: Fri, 1 May 2026 20:33:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260430113512.115938-1-rppt@kernel.org>
 <d5f17a01-4504-4a7b-b58d-c183cedc37f1@kernel.org>
 <b31e1b5e-511b-4213-a8f8-d9721959d709@kernel.org>
 <afNtnXnU4J6syETa@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afNtnXnU4J6syETa@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 34A76C000C
X-Stat-Signature: qe47eo55g6wkad9tix1nuhjirdrt8q3w
X-Rspam-User: 
X-HE-Tag: 1777660390-880828
X-HE-Meta: U2FsdGVkX199t3UiB93DOUhq9jKfjovUJLtxt7pCvcCY2O8liEDiZ1kmMIMDUMOeziWbdHzvGP1oUh0+3znmTdclZQL0p2NvmrGInNShOrP6Mt5Z676mlEOVKi1jQkrOQhnIJfCSd2dR8I+Yt/uQUAYp6Iimqo1qWcuHR63Fyy3H+ZBdNuqc9URlSDDzReSxiy0ZdiZjBacg7vrrq5F//gWXk359xHITaaDAJO/dbrC0GgpBPuYTBGgFtX3d8yVZxSA8Bsg98Y7jyo9HS2YscOPoZMNVMOaE6Z+0tdiTRRBeew1YY0fRoffLpSbSFpbqPOxoBt7H4IR8aRkqm0RZxZ47IF3dK5tFxKtmCscu3x+BQTsPufSVeliSQKakCJLzvkR6oFnTJgmURx8SAytJcTtL1NkwaXILQ88JmLXpvKbjktm7EvalUtIoJBANtsDf80k6trcNqExODTXrZgLqdVG0Jt3qC12Ui9PRfsdqUykQd9vqYE9ASQLvtd+Lh4Amb6VjQx3zHBs0lTuNlljw87pj60TfG6q/N71Ed6zGMWLATKHQkRqZ8744cL63CvEQBxAqvC18hR6Umzh11d+7hIlhv5KKISzFUbgq294M/8PyKMvfOvW8JJRucWNFWCs67HhS7SrX+ZrNE+5q/ZlXkH/+16yonUkG282cEvEMAIDg2vndZaRvTavDfTHNgqgrJH3ALkH8/6LgzYYDQH1swNnsivN4hw2hNf5mNzyfcMUL3lqYm7uE8C8ZZ/vHGKDdt4qhqRUlz0RXQ7HS+J2kQ2VdHT0yEiUOZPZJeoDuGuR77ID9XvwyCQ83eveR3pZVLVKj/YBp6zLKshWq6Puo0unHUH43kg3l2m9RYLOiyYLwhdHEwPD+/YI0Lsw0UlELcKQNNMCvo4W6LhHT4f/VGDjTUBz7246upAhvhmtcVN23dAzrhBmK8uqvkbV3+C+d0VepyjskJWANFzDmBca
 0elQe/PB
 HEz0RjY+bUkDkcEWeHhYKDoLi5HTAy/CYYSvLAdHev8x7PYK2nLtw3FJenQhAeby5N3usRFASF7BmttJP0x+XK09evg2NbZKjJGuRSXKbLfF/0le//wGnLiz7JVu/xKT3Pcm/TCXp9d5b4Bf1dHIOzaN/2roSpoIwB5nG9Dl8ck9ejitw1pgpoUMvakflc0fW2xmoHF24ySrpATdxYsBU29HhC1P7X1Wp6zKxejUtzY3oHINIfUicVz3dmn5RNd8ZTCN1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 16:56, Mike Rapoport wrote:
> On Thu, Apr 30, 2026 at 04:23:08PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/30/26 13:38, David Hildenbrand (Arm) wrote:
>>>
>>> Yeah, makes sense to me!
>>>
>>
>> Thinking about this, is it reasonable that the kconfig stuff stays in fs/ ?
> 
> But it's in mm already.

$ grep HUGETLB fs/Kconfig
config ARCH_SUPPORTS_HUGETLBFS
menuconfig HUGETLBFS
        depends on ARCH_SUPPORTS_HUGETLBFS
if HUGETLBFS
config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
        depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
endif # HUGETLBFS
config HUGETLB_PAGE
        def_bool HUGETLBFS
config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
        def_bool HUGETLB_PAGE
        depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
        select SPARSEMEM_VMEMMAP_PREINIT if ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
config HUGETLB_PMD_PAGE_TABLE_SHARING
        def_bool HUGETLB_PAGE


-- 
Cheers,

David

