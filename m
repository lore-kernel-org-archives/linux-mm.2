Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6888CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A9C6B0005; Wed,  6 May 2026 05:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232816B0088; Wed,  6 May 2026 05:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F516B008A; Wed,  6 May 2026 05:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 097BC6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:02:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B454314074A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:02:21 +0000 (UTC)
X-FDA: 84736403682.01.C371AF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E7E8A20014
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:02:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ABhWe+Qw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778058139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WF0iZnEHF7bRzksospKqX4MVtccF/VV/c4eBSjx3nVI=;
	b=MsV7Wyq2P2MBP0dD4LjIgEcCcixsQKc5iyG+mgTOIsWL7K+4OFajdxDnXiDjwi62JgWM3n
	SJsSU6EX7Au25FiRloHRE9P732klhjpqPJH4KefOLbn1pjxWM4iPST3es5qLNgr+7TFWZx
	Hsed/BgV8XVYiCUojdX8eUIlzsh8zoY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778058139; a=rsa-sha256;
	cv=none;
	b=QSEZp2L+8VGwbkXuO+erEjUf3OJG9/KYSonJpmYQxOfjPZbKILWy4c4OExSZaPWSlREiEs
	fUP192nWY5Vbq8hxQLrFzqaWZj/T5UgOsM8h9VsH4gu370C90/Mc/J9wAqa367aFE00KmO
	if/Ymu7MJ+liD1aJmbSX4AXfPvsTkNY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ABhWe+Qw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 39C0D6012B;
	Wed,  6 May 2026 09:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD0CC2BCB8;
	Wed,  6 May 2026 09:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778058138;
	bh=Dw1Rx65D0dR6RpuF0bMJRvsHapDYA7j30OtceP9WKRw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ABhWe+QwA67krx3H/v590dbcsj5PBVLTlwoY0yXUoyaqgls7sm04Nwgez/PjANGwP
	 PYXTmAK7Zpq3mBwp8CyfojZpy3MaCzzj7Ns2FgAG20xvV3cmOgiaXkmEsAacN453RZ
	 bAmpQBhMrbqDrHtwI+TCQM9q/t4FD+0frYzc5bZMs32mtLukkvpx/oMNHLklNdl9Bf
	 MK9FaPpsgF2UkklRsBX3pCTko1oMciKUBTcm5Dy8TbbEv1jsWr/LqZhM4bPjprEp8L
	 GqU17E36DJOGZnB0Vyt29zolICucxdoifruY2DLwXGlYF/yZtWbVn2Fd1mdm6dudrU
	 7wkkypPZOFt6w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Cris Jacob Maamor <crisjacobmaamor@gmail.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] liveupdate: validate restored LUO metadata
In-Reply-To: <afT_xHDuFwAUSR0X@plex> (Pasha Tatashin's message of "Fri, 1 May
	2026 19:34:25 +0000")
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
	<20260501173053.73116-1-crisjacobmaamor@gmail.com> <afT_xHDuFwAUSR0X@plex>
Date: Wed, 06 May 2026 11:02:15 +0200
Message-ID: <2vxzse84zzag.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7E8A20014
X-Stat-Signature: u5qejui1kmwmfdxrs6c48xn1ued3qo3i
X-Rspam-User: 
X-HE-Tag: 1778058139-549175
X-HE-Meta: U2FsdGVkX19dIyv0cyR3H2JJASdwe50zqj6A3+sdmISDarLVkMuEo+pN+MTk3NQczpm4TwFbzYyfoeBxjYL+28DuNSy23bNbdHfkoYe/Jy+QGQyVXL9MFZ6TYOVyFpTS9fkD3fDTQuQ65B7ptyxTu8nsLmHPIGFXRxN8quZ/WOPmSP82VmFupIGP1rn8/A4wTFzjqhFr4N78TlK1Nv5OzFaZdj166vxsLwb8jUWF3ykBTCeH/Vq5G3FlUBpud7exYqeZSDwNsutEZBuWLjPE7uQjMDGbDsNw+DeyA8L+HsKLmFxG8l2q4n1GnDey46qvHqh24t3qu8Yzwnj9iQ7rtZPcLNnqN6LAxz/wVLfI6cY/DeiMOYGfU03j2TBeszGNxHgso5PVbMK8DszxfQstLJ+osZxbHusyuGIobNNfKsUtV+NOdqnxqm1/z08mvgZr60Uz+6oXLAaoXySi/WV00vgOcM2QzZ266gKy3JjL4HbUnOEKQKTf96TcR7pYB8ndyfn71zGJbVxiGurkcWnyCL5uXvY+HBYHqxLjZRiC/n2kU4QnHXmmHRd3e6WU7BIr8fzX8ZLCKl7dEcTR+sp55twV8GjYNytr3GKIDD5+JwAsSsayIojv/q6Ajo07zt0cxg1XyqA5pLO4NMiBT40BrXZmPfjICDOULQHy864gNwtB9d0SgNYoe/9BfMcZF4OSZOLysEEhyqePOggR+rUpWoiSBmKjGJn/zRxhIb4FrcTYEvT7WUAnahD9Yj5CX4yQwCcDkY0Hbj/Nj58gh1O6GiPp18q1BsFB6txMgzwVuc7wCBIqXbpfYyMAI9+0EbjrBorVPmeXxh9Jvtg+lt7dlRG3DNyQf1BJrFJRFfB9j7mpDiH3iobWYkcWL9Kh6WAudvRqYOjdquLIrS5kxYuk+Y2qv7i1+kODuHW4uYOzkaQnlrqbmmjDPU8/5wTbkCK8us+AU1N9gnrALnEe16R
 PT0Ph65J
 bH9Zoy2tBQa4xbRpHIHAdmjb/+sww9NTabseoRwExBIjVVJ0NJ8/1LnCFCgn4nruGOjUcreRWNeFdgo0SZaNTECZ7BBs0mHh0//r3Z74MXfytaAbZdEljcAqgc4aBx/TYqZNa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Fri, May 01 2026, Pasha Tatashin wrote:

> On 05-02 01:30, Cris Jacob Maamor wrote:
>> LUO restores metadata from KHO/FDT during liveupdate. The restored
>> metadata contains physical addresses and count fields used to access and
>> walk preserved session, file set, and FLB arrays.
>> 
>> This series adds a non-consuming KHO preserved-range check and uses it
>> before phys_to_virt() on restored metadata addresses. It also rejects
>> restored counts above LUO_SESSION_MAX, LUO_FILE_MAX, and LUO_FLB_MAX
>> before traversal.
>> 
>> As far as I can tell, this is root/admin-only; I do not have evidence
>> that a normal unprivileged user can trigger it directly.
>> 
>> Changes since v1:
>> - Dropped RFC marking.
>> - Added changelog text to each patch.
>> - No code changes.
>> 
>> Cris Jacob Maamor (5):
>>   kexec: handover: add helper to check preserved page ranges
>>   liveupdate: validate LUO FDT physical address before mapping
>>   liveupdate: validate restored LUO session metadata
>>   liveupdate: validate restored LUO file set metadata
>>   liveupdate: validate restored LUO FLB metadata
>
> I have replied separately in the security report to clarify that this is 
> not a bug. The behavior follows the ABI specification exactly: we use 
> the PA addresses and ranges provided by the KHO FDT tree.
>
> NAK

I really do think we should do a restore-only variant for the
kho_alloc_preserve() family of allocators and use it everywhere. It
would prevent problems in the future. Not because the previous kernel is
malicious, but because we might have bugs and the KHO page magic sanity
check acts as a defense in depth.

For example, I am currently looking at a LUO bug where LUO does not
track if a session is outgoing or incoming. So you can do a retrieve()
or finish() on an outgoing session. A lot of nastiness is saved because
of the page magic check. Things like kho_restore_vmalloc() or
kho_restore_folio() fail early and loudly.

If we want to squeeze out more performance later down the line we can
move it behind a debug config, but having this usage pattern of always
restoring before using is going to be a lot more sane than just using
physical addresses willy nilly.

The approach this series takes with kho_is_preserved() is the wrong
design. But a kho_restore() or something similar (maybe we can find a
better name?) is really where we should be going.

-- 
Regards,
Pratyush Yadav

