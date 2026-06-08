Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D074FCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6D06B0092; Mon,  8 Jun 2026 11:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A8326B0093; Mon,  8 Jun 2026 11:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8D06B0095; Mon,  8 Jun 2026 11:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFA7C6B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:32:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92F1F161DE7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:32:43 +0000 (UTC)
X-FDA: 84857137806.07.61ED9A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B000E4000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:32:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQKjTyjt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780932761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qvu8thbHGVnGEQFJKSoN8xx56QE9AS4rvv8hnTC8lBA=;
	b=0kq8FSdqaiO/fX0tScUmD66jrV9LfQyl2r0gNTf6tZnuHxK/ZW0EecZaMiHtpMv/oH+xTl
	O8A9KWC0sBjgcr5/XMVY9Ib8f7rfzZ8Opp8WSdPJpdU/9VIlk+CL9Ds3BEG7S4SKf1ivoJ
	7FEuHFPB435aRwSU3jvzZeuS8VLTeek=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQKjTyjt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780932761;
	b=QKHE8JJ9QgxCF5Pth6Ukl1le+ZeLzqjCKNuJYNYVPBTxUwHVzQyk+XmCMTtS2+zLCN1NEo
	Ax9RUMa/Bv9y4B6PE4TH28toFt7jB/9HfR6+Pa2nMFE5d0/XEOqg3wpx7U9g8tYKlFkdqA
	ZPn85O00FcGRuS5Az0enBy19v29ZcBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D4D9405C9;
	Mon,  8 Jun 2026 15:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD9E1F00898;
	Mon,  8 Jun 2026 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780932760;
	bh=qvu8thbHGVnGEQFJKSoN8xx56QE9AS4rvv8hnTC8lBA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IQKjTyjt/3SqU66gwRGZEye2VKGw9MQKZJ0h/Nzx0R8d9wDa9rvj0oRqoN9h1mGts
	 OdKiAhu/pA8qkYoopmH90z6ofhCZmeflsVszVjLgu0FyddamnkEpnHc1Qtmiqa8Qmt
	 CQhhT1q4cyKD1huBqWdZPqCZb6N+Wdpctxj62ay/AeFt+I0DKAgCfUK/PDx7SLg60s
	 sDN/UmfOkm9BNNa+gC0cq6AwSnOsP5XUsywOla9mza0BtrRj87b3bKLotoyFfRlhzT
	 66tyjeUIT+1tvOjbYrXodedMB2jOKyph0zGk0CPguPAbo3B8FKbV8EUxzdOxSSmzEG
	 UdjOXYQk1CKbA==
Message-ID: <13f428df-7922-4870-85bc-90039453f247@kernel.org>
Date: Mon, 8 Jun 2026 17:32:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260606015729.1837935-1-surenb@google.com>
 <20260606015729.1837935-2-surenb@google.com> <aiPWD6xZLg6g4DTO@lucifer>
 <CAJuCfpH74gRmgm2tgwB7SHzL9DrU3Yc4LyS8XLa0tR7fJqaw_A@mail.gmail.com>
 <aiZ5qFTc6XDMsqB9@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiZ5qFTc6XDMsqB9@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B000E4000F
X-Stat-Signature: rdtzjtsooids983biborngfiae8d96oz
X-Rspam-User: 
X-HE-Tag: 1780932761-217216
X-HE-Meta: U2FsdGVkX1+sy5vYAV8XUN71VJoIyRT5st4pDERnd5uoeAyu3nolNNZ85sQtDA2si4s08Cq5ypg4MkTzW+Y+6L3zK/bkutoUwKguBTNTgzlrGf0iLqjsYyE90f9GtOKdOtPbMBE7FaSeo1cuD5BkwSWK7aOq3edqiuIyUqaAz2lWAgr0jlUvueUK9QvNOIoval+FiFXEYMuJnBZeIKAGPVYW9NB8rtHboCIZHYQeRe6m6Dg7E0proQZnReUYQiquyEU44GY6VAMZPM8pQWSq0KVS9c7SvCFotgkFjhO1p/4TIZDJH64HLReVUQxYW0uq5vXKogTYMwHNhT48mKTms8EUkArIKxkS2CQ6Y13kLl/7tEGSMvMxHLJkkVRPDG70ldVXvy0pR52TF48IE4pFZNJMfmiDoeXEBXp+HoWAC/1ZDY0UvMf17iPUvdT2/M/kf4nknomtxI4/IyRyJlXTjGXskzg6rXIyzNJmeF5D6JmhyLj8VqM9kgZMzwqZZlh1xrPd+YowUoDT5FL3XlzJAYj++SgFWJzItIpKqSbNH+ztTGZiRf6kDsuB2m4/A/3GBQoP1gZi+jdpTDp+hqe2MkiWdZukGDf7gPQHkKpcjR6C+gRjeXkJU4Pza8Y+/AOEpyzLJV5ARA28ImmylveJr10odmpzvJa8WlBdJPqsX/YIPyU074QEBskj/nVpeQUI9v++1fzdMx49PEH8suS3gK1ZF22rN1VC16+nVGu0CpEww+JKoGhfmSHu+E5KvjqoKs716V3EOpg5wBsg8BP+1M0EGB9EPbCDTNtWpONpAFChZU8Jc07O2EwJ9DffDY4gzpWVVozh5b2SCkL/knsNiOX20GwAXYFAA5gsVcENk3+gNA1K2hX3m4GuJoth5vDFxelL3j5EehxBfdyshwEHYSC82Hldp4tZ2yOUQJm5LS0ptBkQidMDyXKqQqM4NPRKmKvB36pvmj6Ui9ZX9Hj
 BA4XYc8h
 Qr5Ow7fgG5Z2jD2PIZercTQ1hzc63E501k19ASaz4aSOv3tN2q/ef/XmemibG8AZvX1nZqXpGFXY7c1zIRNzWoV+5pVJCnAf3E2QVIKKUkpaQYz/Qw++4IweS11V7K6h8akW1Gte9i7WfDwIBl47caBdIUSbZDW8SmyBCEHgTUvlAWbB4SMvsJWiym16YM9L3udikjHr+WR357GoUQqBtYm/tfyGiOidbkW9veOBYR+tgx8RKEoGZcFKi9Tw8wER5GzVBn8pwBUQykUFMNO41q85OCRKmene66Dh7WboXoCEDlKVJbyBO9imvXmHe8zB3o3UB0LZXJdD6zPto+hjX/eFImoZNDnPvH4/K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 10:14, Lorenzo Stoakes wrote:
> On Sun, Jun 07, 2026 at 12:45:23PM -0700, Suren Baghdasaryan wrote:
>> On Sat, Jun 6, 2026 at 1:12 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
>>>
>>> (Will review separately)
>>>
>>> Sorry to be a pain :) and I know it's a petty thing, but even for a 2 patch
>>> series it's easier to handle if sent with patches in-reply-to a cover
>>> letter :>) also makes it easier to track overall updates in cover letter
>>> changelog.
>>
>> Yeah but the first patch is a simple cleanup of about 10 lines, and
>> writing a cover-letter for a single patch seemed excessive. Andrew
>> would have folded it in with this patch anyway, I think.
> 
> Makes sense, sorry to nag but I want to be consistent in nagging everybody
> the same :P no matter how well I know them or otherwise ;)

I mean, it always looks like there is something missing in my inbox (e.g.,
people CCing on patches but not on the cover letter). So then I dig for a
missing cover letter and find ... nothing.

-- 
Cheers,

David

