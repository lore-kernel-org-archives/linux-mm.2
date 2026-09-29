Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC865CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 06:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC7D6B0088; Tue, 29 Sep 2026 02:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DCC6B008A; Tue, 29 Sep 2026 02:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8450A6B008C; Tue, 29 Sep 2026 02:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6439E6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:14:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDAA6C03C6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:14:37 +0000 (UTC)
X-FDA: 85265785794.23.2BB8254
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3CEB12000C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:14:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtCB9cEm;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790662476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvT7coCYtTi/rreSiI1/Md2pHy3iQ/7/Pw+yC7sqgMM=;
	b=3XPvvEWnTGNF0OWKL4Nab4f6M2siRbAXri/ftnwS/KGLgKQQJuBcUr3iohypxKFw5uqSxk
	wr/lhoxanEjqosAiGMnu0PHcs1scRlRSsjIgUDZwDlxrKfcCWMD5vOa5fLTubLfGO65uFb
	PX6p8l2dFeeiUKqw0rzBEN6GRoe1eA0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtCB9cEm;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790662476;
	b=kqdo4qee0Ze5df9rH5cQlPn6A+B2888PeizSHPyHPKiNPoXh/ioFcfUTR37jQHwq/bHFlp
	F3qXmFi+jaO+HON1GjBbl6nd/U1u46s5Iq91Yc/j55udBhFKmY3a6fQQ18qOS7CF72ab+O
	HOEgmSjM8H0QUFjuy3iL64tNMb6IbUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D88660210;
	Tue, 29 Sep 2026 06:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0269B1F000FF;
	Tue, 29 Sep 2026 06:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790662475;
	bh=wvT7coCYtTi/rreSiI1/Md2pHy3iQ/7/Pw+yC7sqgMM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PtCB9cEmvE2iGpmWworBMziZrDDXvKwJMg5cSJ/XR02b+oa3AAojRW2tlN/etBjo0
	 BXc+b2ShlcJOZcJBr1cnmLps8U22hKL4t5i0uyL9g4C3SQZ8qYH2u+wva9Gnl8JREw
	 zGB4uApFyznPqWwQy0QVb2XwV9BWD/pK2ksV2A/zol/owkS+yBt67lL7iFs6nqz6jn
	 w6a638wDFfInk1RRzgeFRKh0lYYXjxlZhoBNYmIKLvX4pDYf13ZD5sTozt25JRMNr0
	 zTFUlPmWER3af80r6fDWqGwkAsjJY0Q/duQQJ2h/4nb+BMXro3JPbSOgEYK8/ssU5A
	 RIRUv5GhWs9eg==
Message-ID: <d474cd9e-02fc-4ee6-9ce4-2232a3a3924d@kernel.org>
Date: Tue, 29 Sep 2026 08:14:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>,
 syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
 <9efc7bc1-8d9d-49ac-b856-003e81558411@kernel.org>
 <20260924195826.70a87d6fb78d754bc73892cd@linux-foundation.org>
 <95e91b4a-ca16-49a3-9a1a-5b38afa6f08d@kernel.org> <arYnXJHW-Rh4eNzt@gremlin>
 <f78d2f52-1135-425c-a3e8-460a6e80e19b@kernel.org>
 <20260928172654.7030810755eefd2a1503a0ee@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260928172654.7030810755eefd2a1503a0ee@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3CEB12000C
X-Stat-Signature: btkxcy87ot43agduis68716f94b64nx5
X-Rspam-User: 
X-HE-Tag: 1790662476-535488
X-HE-Meta: U2FsdGVkX19o9NPlRrxDX6dGE0C7pKL+TJI/tWnNA76JwC+R84r+cT57QpoaYQLaiqHSXC4PB1XsTlPvEmLjubwZRu3d0omisC5F9tN+7DWPpI54OQm06jPEAp/XG+3tiqQWYIyFT16u2S4/GVZWZD9RyroE0k27icwOngobVCS1J8kOohnDXOJCNpgkWr+eCiNOill53CclDqJcM2PPOozJ9z7XSfsnt6sB3u63QZ2DmHTL54Mgfu3IizuWVCZaj+aoSfD8OsLNmmhXRKVdrooB1r2Kzri67QobMz68EbIFYYcimrd6a6+iorQGkPcxttkwFZSx5AHzMu4G8oXmTmRzXzeH4Zk0NGXs3sRe4h/YlDBKj3NHCfTmGyDOY25zSKP2Y780Lo0F9KBRvOMCDSd/oXaAqYLFWW6UJsMpTA/PAYapbZ1ZfxMOj6fMJUVwBNJdzUNH/D7cq/xWzp8A5YutA4GEPGH2bQ4kQYrCPLErA1aqI4vrHYN3UmlEvLI5tFXkakaE9YOsy/ohu9s3JZV8qmpVAkBaqxbVDPT9qZHLUh+ORLIhmI6KbycIv34Xe9cQh318yvWpccrs6wlHp7fKLb8RQc8kg+8Zd++IX+HS3ofXrPJ87wsFB8YVHUL/MzSR6RY4vDFSV/Fu1Ei5wTbr+KVaHL9m1mIW71etkjWMNTZS2OjzoxWK6HoHK2TKIkZeQGNGtZlq78oe+umViCjlg7UPYuYhdv6fK9EbGXlazaAbCITtM5CNhPU5aZQT+8VRQGoXrRNhUG/HxFi+297j0XJWGgMX9Ns+MCnrvzzyHJv3ig2EDW6sRaJiKjHvuzJt/8or0SyXQ2DzMkfBhtt3uJhVpmPqAWbXNV4iGsTAlhXhmYsTuxfIEX36QKqbWbWRbtKDess6Cobh/Jts+fcOmrEq11S2gwo5D5L6NGR/IBLV5Zauxbuw5YT43Ykgv+Oca5gSOqc14W7VLDx
 CCJgElfj
 Iet5Z+Ezddb3LhSVLwIBlpVNx0xfaokePPs16rOYdyTNYtzt62V6JB8ANgXDcEBZ4Kgqm1tscGzbwEtpFqrcGT2LOHcRc+NI08WOtmn4EaG/X2w0R3OelpGQEFau15vJd8rr6nF0I64WDUrqOrbb1B6K3cD0T2/oxDo6yxvfp8s1WM1t7u/FtfOLwl8ZUud/OLcVVjDeg8b0ileiveCcaZIwyvFtMt2ZLTqVwSRMZ9gkDnT7lMJtsjwwao7+y9xytgrErMezQ0gPePMIxpCeNEQ0dqIwEkVOH7/4gMqgZFAWoIVa45Q2QOcMrlpvG+vh7m4TOJqwsXu9EByJ0Gv9tmua7VBIxUgqXK8XNogEaaZF8h32jJd9epsBD9popyGKXW57fB4/R4OC+imiAJz6AAxNjR8xi1YppNjXNUkP7dO3vy29wETtGtAqTX/3oz/uW+fdshFLTgQUN1FLFhilJaAqC/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 02:26, Andrew Morton wrote:
> On Mon, 28 Sep 2026 13:59:47 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>>
>>>
>>>
>>> I would say this patch is the right fix for the moment to fix the assert, and we
>>> can chase up with other approaches afterwards.
>>
>> It will get backported, so we better be careful.
> 
> I don't think it'll get backported.  I hope not.
> 
> The Fixes: target of 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track
> MAP_PRIVATE file-backed anon folios") is new in v7.3-rc1, so this will
> go in as a hotfix against this -rc cycle only.

Ah, ok. I was assuming for a second that we can trigger some otherwise
unpleasant conditions with anon folios in non-cow mappings. If we're not aware
of any, it is indeed not relevant to backport.

-- 
Cheers,

David

