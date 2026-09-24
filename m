Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80596C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EFD6B0095; Thu, 24 Sep 2026 03:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F5B6B0099; Thu, 24 Sep 2026 03:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FBC6B009B; Thu, 24 Sep 2026 03:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59BC66B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:43:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1CEEC0254
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:43:33 +0000 (UTC)
X-FDA: 85247865906.30.D5F502E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1258040004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:43:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AlB+qeZN;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtXJp2qMLTHXjuQcFivmdU2iuZ3z+DX3EPTgz5CLUiI=;
	b=By+Zgy1vcZufaltj7j3q7F2qxJkWyO/6El/bBMkAtrOUXY4y+j1ZocyTHJUZ3VyRA57X5X
	XAJ8ZS+assr+JI2IwNTJiaiPE9hC//T0tdJTaALpNmd/V0EFPM8GeenW6S5mANaWUXjiDw
	Ltb0ns2b5XYYd1J8tQWT3IyaONI/2Vs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AlB+qeZN;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235812;
	b=psLcJABrRiCBhDo3dHnEOafSm6BYN+iSMpGUmXRwvjKaIihjVMLQ10QBpZilS6++5FbCMO
	gWcTWVqZ2cHoR9RD2wQhCtK6FX1UhfBXGNZ9U5ONovrcktRXmNn9KeHc00WF5Mcj95zcVi
	9BQqiS1gELDY2R0jvuBhi5tv0Fe3tXA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FE8E43937;
	Thu, 24 Sep 2026 07:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19691F00893;
	Thu, 24 Sep 2026 07:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235811;
	bh=AtXJp2qMLTHXjuQcFivmdU2iuZ3z+DX3EPTgz5CLUiI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AlB+qeZNZHPK30/8gFWOG2ELpRv71bcsx4PbxevhGUsDhAjHC6Apo2uW2LYMBUtdK
	 BjKNFW46FJXt8T+JBbFfuQHYM7KjIDDuo/13rBqpGYMpkoWvaLe2ZzaY+42DXiqRqk
	 e28ApY+my5E13wunSeViD1OqbZmCKPvgapGauc6NSSgBIo6jlUbf1Y5GhQPq5qYhzQ
	 kGH5ShTpvle+oKacVESNlRyL4UFvM8YG7NLRHT4rdRmkm3/mccali3Vj/Z/QOaX7nV
	 O2ugEz78dD7lCgFMwJFlpZAAV5wv3OqbXerP8SlEze2Wc+frI4+NWbppKudzi2lJLT
	 rJU/6+v0+tlKA==
Message-ID: <0a0a07f8-8ac9-4d75-b4c6-c403865f0be9@kernel.org>
Date: Thu, 24 Sep 2026 09:43:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
To: Lance Yang <lance.yang@linux.dev>, ljs@kernel.org,
 akpm@linux-foundation.org
Cc: harry@kernel.org, jannh@google.com, liam@infradead.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, riel@surriel.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
References: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
 <20260924065458.49698-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924065458.49698-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wfkds9759b4taxxwrtmmsfhu818jb6dm
X-Rspamd-Queue-Id: 1258040004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790235811-829629
X-HE-Meta: U2FsdGVkX199n1fM39jzdYuoG2s9+dhPZz1dGCyJjm/3X1cOkyQ7mFH8x5GnPuC78eqhtASw7hvoA32gAmPIUQOobJ28OknLmxxECECNaao30CHZZGyVE6NLCPNNs8FIphmL975AboPX9/CC6dx8oxRhNETY0sRnDNYSczRTA38tjKyXMDv8UKuGE6fP1Lh1hfr5OIVfqUmMVxO6RCTLATlztYEcJuxEQCmJXPo06w6R+lLMGJPwf0Vu30u+F/4Z2DC9XwCtzEK5V83LQRM9nN+wxNeiomdqUaBHbBt/lY13DFKwhxzjRr22QL2pBrfzCX/qmnltaLdCYj1MxLxLwqdd/fmhnezZfj7D63lFw+bveZFJWlkEzczec52PEZJ7uvitCkfP1BTQgAnO63r59Q0vbvaHtMWWasComa9qA070VtADUWkJnUdSlqKuAs4AE/8ufFWA1nvbiRr5eTay8MOQ8zfOXEo3yA4ZVcv3s3uiygkA8xY1kDIs9jTnj50Xohn8CyI2bThkkW1RxrWBMFA1ogLGVnv4asLTJsjV6COHucZCMP7NJ4O7qMo0+J5kTDAiQe8pGu5MUh9XTBo3/dWvMAOfvsgtTO/31xnhiuvswrJv57n7FCGOO1AnB0c/4DZqKSeWGES2qWgW8xcYfdbElJCRacMIqHJFY7xuimwx4fnP8w3v8jlJkOulvMHae17HWnmM3nXEjLW6JgbHnGFYKPvWNSuA1zZYiJfdLdZRyb+gZpTgmZGurps0u2E+aHymfDrM+rtRCYHJwGoCu7pniNGW64X3r3Y8YIjs4yU75xX4I7eDYuOUzQs3E8WKAAF/WpVsJV8vLnPN9VT2KTHF/MBMGSdjjuIqh8bHBAFp3h2OwrO5K/syKfHoceQFDiLP8k3+wNcK6GHOH0kChoxd8w+PR1kVzPHQbwRU8F//xbnWC6ahRzc5sbidVXP+lIkY/z0UTRoNE1O6P2q
 mNBTIfMM
 6p2WYQ2Id7JgLj3VPMUg/U2ftHtv/oUhdGc8lBZzmgyI4Ee5OpTS9281UH/RYdQZpLXw3pZz4h2h/N0LgmQp5m9wQezaETG87yFJHXjvvPPPc5DWBsAPPA4tTEDJlpJZ60SXOl/PJAkrBOA4mRnxz+RpqaPF7xmrpzD50JA4UvOKUNASzUnDahDNdQgzfio/DV0EcLJBZGlt5ZzZC4EEjCoZny2G6sDRWPaCmK52g48s/MWdGu9SjwrEY2owhV2J/W1ePxDcUfid05Mksa8ImNqG01WmWDTXf7YeM+lU2Li3nRrHsz9lyJSDj7JcidgD8nyGBLyA0RLC4H4EyLQzHPtqmD1B+sMFJ7Nq7O1vxS0xyzSOw+eKPyaJV0YOGX0F1ZWwY2KFH2fIOdIo0YiiTgckF8Qy7yb8bay+C/YWYOVVw8QhVwq1jfZiCcllI04JwhxFj+oZis1B/gyY4U/N+S8kekpUP9RnbNlRzfca45ZwnhTWriUgX3W27F2LI8r9HHlXHh3XMM5fDpnl35cqdorXNaR9QPiO3aeo2oVQ7a6Kz73/73Ivn0sGKfJ7n4KYJH47C3XcS840KPJetRCJ3lg5c6LFJxslsmBGpouDBc1fG7xQWAnMrFqvMlGhX3lcaVFl4dYMIo9yHMOzNwm4B4Db89c9ZMl7BXXugwBc+5pV6AFHtn8rid7esF+DZHDMAiw29HNfccgKYp8RnDWe54IsBeje0gOTGZ7Ei
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 08:54, Lance Yang wrote:
> 
> On Wed, Sep 23, 2026 at 10:00:37PM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>> userspace arch: arm64
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000
> 
> Looking at the repro, emm ... the repro maps an O_RDONLY /dev/zero fd with

Does this trigger upstream or only after Lorenzo's rework (not upstream yet IIRC)

46827ac1ab221 mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
db7438ea23180 mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
54e8e096ea86b mm: implement file_is_dev_zero() to uniquely identify /dev/zero
fb24843cfd9eb mm: move drivers/char/mem.c to mm/char-mem.c

I assume it triggers upstream. Does it also trigger with lorenzo's changes?

> MAP_SHARED | PROT_READ. do_mmap() clears VM_SHARED and VM_MAYWRITE, so

Clearing VM_MAYWRITE for a private mapping is odd. Can you point me at the code
that clears both things?

I assume we still have the file pointer, and as the file is read-only we remove
VM_MAYWRITE. But why are we removing MAP_SHARED? (where?)

> mmap_zero_prepare() marks the VMA anonymous. MADV_COLLAPSE then allocates
> a new folio and adds an anon rmap, hitting the warning in
> linear_anon_page_index().
> 
> Can an anonymous VMA without VM_MAYWRITE legitimately have an anon rmap?

It's not a COW mapping (by definition) so we don't expect anonymous folios in there.

-- 
Cheers,

David

