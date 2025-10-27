Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D49CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 12:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB39680048; Mon, 27 Oct 2025 08:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CB28000A; Mon, 27 Oct 2025 08:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C901180048; Mon, 27 Oct 2025 08:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABDBA8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:29:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B7321DEDD0
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:29:32 +0000 (UTC)
X-FDA: 84043824984.01.62DEC92
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id C13BDC0013
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:29:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GjzL7CDj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761568170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxqhGs+kErj9QojSUYfqhMME1C+HzYz58U9mBz2oLoo=;
	b=nSEdfciQV1TtAB+GEQv8uuK5dYeYAixkCsOmkjS0G2m0LlBdiaYyl6ZIuDVqzCK3ntYdAL
	skxOo1UlSNByUuCQy6SxU0sT8zYPmIwOHmMTJNVElyhRATHUN7r8tlvk1Tni/iS4ztdXcb
	oE27vxe+/wDhhV2cGGeKcTrZ1GdIbLg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761568170; a=rsa-sha256;
	cv=none;
	b=Jx1Qs7SPEhsIcCKv8OXu7Bsf0VnVU5uuba8fi3TJWkygFV5TxCjIQA560axKZAT2RrZVoO
	hIalXBoFnax7AI7PJL2bl39j3bTWbg/GXnPCqswt4yqSugzRLxlzywbgPTY9hI7MIeT2KL
	3m9CZ9vK6MXCOODMRaL67GxQ3u5yRiM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GjzL7CDj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761568168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MxqhGs+kErj9QojSUYfqhMME1C+HzYz58U9mBz2oLoo=;
	b=GjzL7CDj0S0BLc5W69u1/FuWZP+xXmM0qsQ+oWjgr07ChdsV2F/b3jTNxuBUL6QHHgCelZ
	VLDaz/WWXZURQtMj2RN7LzIXgDso00pMrUat2qCbJ5oxy6Fs0IuzdP7yXHugMpLoCclouv
	QKCKBey16vgVRZWgmpx9u/rIram8z1E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-McXqkLYfNbWTS02Zur1vDg-1; Mon, 27 Oct 2025 08:29:26 -0400
X-MC-Unique: McXqkLYfNbWTS02Zur1vDg-1
X-Mimecast-MFC-AGG-ID: McXqkLYfNbWTS02Zur1vDg_1761568166
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47496b3c1dcso33871415e9.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761568165; x=1762172965;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MxqhGs+kErj9QojSUYfqhMME1C+HzYz58U9mBz2oLoo=;
        b=xSxbTBGlKbRnIxRp+lHFs+NkINkleuqfvE+jKeS2qzhmMChQWqhBvTacn1CWb4Y8kP
         a8i2tMQH7vD3+w+1ODaia47Op/FTJnRwEf8XbacQ6UxewiQoxMTMc2AD29pnCegwlLMB
         hnA4q5cv6qIH7IyCrqDiDgO6n3fCR4VgdDY6T6lByWEA8poYkVLBHxW6bNunnlX0uHzj
         w8ydIycx2arOGGTen7VBkNLZYpXoNoOcwgGZEelBcKDKLDNbURb/sNZ56cWKCVbRWqwI
         cBTv1su6+M51lfghWYiaKrA1EXlc+RloFV5GH0fB48zPXJp3xjJsvp4uxrs1cPRPvKx9
         rcfQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+S+GX4wX/SYdQKWP+rlXmfU7IoaybVQofGJsl+Gp7IUg2sbl5hm0Kp6MQjgfTze1S/4a9uOb3Cw==@kvack.org
X-Gm-Message-State: AOJu0Yw1FDbhcV5naeoQzsrDK93VF+mffC6wqcus3z1vn/8ifMUi9XeY
	TYpYVeAygh3Ofxlt2SSgbUx5XRkOpJ7ehKx6VtgzU3pADfPEkUAJNhvy+XMo8Q+kZ7+FeeAEt5a
	e7B5+tJUq+SppwqqPvYT5pCZINR8hTuiUe74JOjFibiVvBIOuyvid
X-Gm-Gg: ASbGncvV7SNHySavIsi9TwcvBega6pMCIgcjPNp1KkPv13T2aeeyHjTRltopO5wxAVL
	nO34Xdj82QDhuck4epPSoIRUqNdu8sgYoJ5Enaw0HrkFRwqnhO06IFDsTvBQKU09cuwzYTL9eZM
	QOIkWaKx8fyZkMKRGnJ7ZuHPomyJmn4gkLByxLy53qBeTI0AfluIfNgGii3xwGuy14AdMqOPi6A
	wnsn2iNePgnV3HN2Mc6QEXD0YFkwo9G7UMep6uY2BrA1/d3h4IuqzxJ0Py8B9LwFbiOLTNB+v/6
	loDbICGR0GmgeoaqAWY/j9eIbEwzVMI4WAQy5E6vfl2vudSCNEyR1qnufhm3zRVvXs0+tn1WPj/
	d4aAtSng8JN9ESb0NjAbmWRXwlPKXWvloWgM9XqYNrrYV4FcOBnhz3BmrMJSIUqrgBi8q7TPkon
	4g0byvobmnuz4is8TxegtOqivrG8M=
X-Received: by 2002:a05:600c:6814:b0:46d:b665:1d95 with SMTP id 5b1f17b1804b1-475d2ed2703mr122459295e9.32.1761568165617;
        Mon, 27 Oct 2025 05:29:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERhDOSgpdu7IOhGUhd5vG2oGfH+FtLLHQ8h3X53cAF/bER/zOT53Nw9I8J5TYzsbcubMUbyA==
X-Received: by 2002:a05:600c:6814:b0:46d:b665:1d95 with SMTP id 5b1f17b1804b1-475d2ed2703mr122458775e9.32.1761568165180;
        Mon, 27 Oct 2025 05:29:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952db99asm14109118f8f.32.2025.10.27.05.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 05:29:24 -0700 (PDT)
Message-ID: <6c9bd0c6-0968-41ac-b0b4-53c881748cfb@redhat.com>
Date: Mon, 27 Oct 2025 13:29:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
To: Demi Marie Obenour <demiobenour@gmail.com>,
 David Woodhouse <dwmw2@infradead.org>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-12-kevin.brodsky@arm.com>
 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
 <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
 <3ff4aaeb-61ce-4b72-ba90-1b66374b1b95@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3ff4aaeb-61ce-4b72-ba90-1b66374b1b95@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1mdhcM5o9y0-b3p7cuB9hRQUEUvejV_3gQ0GyAljXpY_1761568166
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: oobutosrdhb3zojj1e4xurg3z1z1iufw
X-Rspam-User: 
X-Rspamd-Queue-Id: C13BDC0013
X-HE-Tag: 1761568168-306041
X-HE-Meta: U2FsdGVkX1/kqCrM24W9DDWNnPecZYm8K2t4km3qsGERnx10m49a7ouADLzwUDD5+QmWo6D2tMzCoEuJZKaiv+cuZyNG0vATbc5TszCvqOJFoWLEC+YBI8js45hZggYniTo3b+lH+gSAk76VqtWqu1uU0ofF1qy7D4X8mJoEjIOcNLQfbLf1rwS0KGa4ZHInSfZ/jF2k5wy/zjRp0+LKhGScpJesBYTel8s83bKaHrJmE2KfIRxtu6D0rz/MmofXx9mQEi8TUxbzhH+yjSpdUF0Lt2xVcf+J2NBheDEUCIxIGK2HnpgCz6f70VZOJ869xjWM02PWIDIGCkdNKL+3LBBXEUL8AoRVH5QzfNFASeBtEkmgOD8eOgqdXtp0AVw7WwQ29A4JV3VRJr7cDq0k25d+qnqK7lGeSaNEgNM2hy67mSmnMcuLfPb8BUY6UB90ewiLDmWD5WMukkNn1htxhlSduco+qwnh6Ab9xA7HhxpWDPxgg48aAruNBAj0aHOQnGfKsA03vU21vZwRE6cKQJGXvgNXmceWNWraIhqmaLo1RzQxz+y/0rfRF6AMx+Bln0+18wv1fXZpuLsksE3YOgZWG0CNJHArutHaCdYDE8fc51oKp95OKURzFkMc3DUAWQiVur+6T903EUk8J2LusEmxKUnLQypjpOmyZ/yDkIX1tN+u7oNriF7bwjJ1AaPGUwsKo1e7Z/a7JpMByDVzNViBTAldCYODrZhrcJKlKG3nip4z4hOAeDrt75g9F+jguvr3uE4zx0ZGa5aFwcRtE/BnadcpFLjU9gFSdw0TopYWJrOtAw68yyy5FR298YIUY0hA5STC+xbqdeXH+mr8dCtEcqRVEblNBFa2DQGjpO/r2WYmxkRLll2jxT0IbaR2vHcDdrsO9Zy46vum79cwc6XCSXK3VudAoOYVxB8NPtoLbyJADmTBZXNJLo99e86XuQUX9H4UWsNi8DgKOjx
 9lxQabx3
 5uVmw+24QqegQtAeMHY1bvhPSHDQGsMXcNLLTmWlMLRe5hoW5vL3BZZpMZOXuNACM3u7dBysAg+UaHgQdgEgCTNHmGpugL4G4bYY+NGABgmd7RROGAd9yui8ZDxjXMdod8Q4J95cd8rI9k4iZ5fAgqOydTiB5/t5au/DS/tsDONTnBYe8cqqeXKAhth5BnfrrIRnwC0991xR5BKHf6j6b+zA+6j7NggLUB+38B/9cKvfXN8oCo/Djvca/+PbIZzs/+EbXCCyvvN2q705ZnpxHHWJtpOMKQGcpzviezjTSzHF4CDIYJ3HuIZwiVUI91+hIhqM+ouPY5Kl0/4NX1ZdYzObgIqdts+amYtkIsGhLoDkqt58S8p6UHwmZKBhyryfwXw/QKGXi3+3658Czm+17Zzt9QOXggAgzZIDhJdoK7xZ/WBn3gd1uQO1Cu2eK3x5orp4vNhgyj3UgY8Q0iiAcr1CcuL6nKIk12rAfW1gMOPXDl+WZIZqTaNeh7IivO/dNOfP3hOGLcKefbTiGG9HCrpM86N9Ae7g3lPO/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.10.25 00:52, Demi Marie Obenour wrote:
> On 10/24/25 10:51, David Hildenbrand wrote:
>> On 24.10.25 16:47, David Woodhouse wrote:
>>> On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
>>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>>> We currently set a TIF flag when scheduling out a task that is in
>>>>> lazy MMU mode, in order to restore it when the task is scheduled
>>>>> again.
>>>>>
>>>>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>>>>> mode in task_struct::lazy_mmu_state. We can therefore check that
>>>>> state when switching to the new task, instead of using a separate
>>>>> TIF flag.
>>>>>
>>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>>> ---
>>>>
>>>>
>>>> Looks ok to me, but I hope we get some confirmation from x86 / xen
>>>> folks.
>>>
>>>
>>> I know tglx has shouted at me in the past for precisely this reminder,
>>> but you know you can test Xen guests under QEMU/KVM now and don't need
>>> to actually run Xen? Has this been boot tested?
>>
>> And after that, boot-testing sparc as well? :D
>>
>> If it's easy, why not. But other people should not suffer for all the
>> XEN hacks we keep dragging along.
> 
> Which hacks?  Serious question.  Is this just for Xen PV or is HVM
> also affected?

In the context of this series, XEN_LAZY_MMU.

Your question regarding PV/HVM emphasizes my point: how is a submitter 
supposed to know which XEN combinations to test (and how to test them), 
to not confidentially break something here.

We really need guidance+help from the XEN folks here.

-- 
Cheers

David / dhildenb


