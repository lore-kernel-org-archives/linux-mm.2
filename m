Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CCEFCC9A6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA13F6B0088; Tue, 10 Mar 2026 04:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E6B6B0089; Tue, 10 Mar 2026 04:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05A86B008A; Tue, 10 Mar 2026 04:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A12326B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:18:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43BF91A0493
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:18:05 +0000 (UTC)
X-FDA: 84529450530.05.2A45267
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8B0B6180004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:18:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bEW94uy6;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773130683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfneoM7Og7kM6BvdMqPkuYM24IIUWvBPxRDPiFJovPg=;
	b=rEAgWP8TuLPYtw3hoAqVM+PtpOc6I5OZn4kkf0KAaep3jcTviJlrFjGphBiqExfRhSyJ2a
	JdRT5xzfxXjmoPyL6WhsxWwAd65OzX7GV/isBOHGbxkALTPwFOJYEqnX33lFN/NwI1u36i
	S41FLqKTxtmNxUJ6egDUhHx2Jd6wmB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773130683; a=rsa-sha256;
	cv=none;
	b=eNu5T44tWdO/sXwEIFpBT00IgcALmStdf74wWj1yVoLX2/bK3DkxxjKEyoUM3qJ5oES41h
	GBjWvj+MXxp2/QO3uMSHI7FrdsDVyIPOudcPkV4TWMv3O6737D98QtOZYAPU/ZycrwutTw
	tWzI/i/o8Zv3PiIXuXijAXBZMbp2TKI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bEW94uy6;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE708600B0;
	Tue, 10 Mar 2026 08:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF1BC2BC86;
	Tue, 10 Mar 2026 08:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773130682;
	bh=+NMHN7Qnaa23e/sD39duSp70hQOc+bvgzAJ1NV5gGgw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bEW94uy60EpA9Ru8lqDh5UOzDaIQlgGRMV8+NwznuGo65Q9z9BhnfiBGlJIaC8f8+
	 KStR0JdtTGHifsHppa6ZjoGsOIzsq2ZbJG1fZPZCe6Dl+oazZZ6odf1vu0EX31YGMB
	 5AP+wQ/f1Pajb33PbNbH2y6Q8ZT7G51D47VjkmVszHHhfgsibjQnFPBlFa3wTXkQK0
	 OMgqpYegwDzSsmLtZTJaFKiPUL3yfa8U/EVqDlp/4c9QMuxsVFLIvRQtXZu5tJIrjg
	 SAFgTnUHbUNeZS95KQ3cNoPAZy2cWkNSWAUfGg976omsBoDVw8XDO9LEk+XNJSPszH
	 5KBEp+CJU7hTA==
Message-ID: <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
Date: Tue, 10 Mar 2026 09:17:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B0B6180004
X-Stat-Signature: ycatco3fd989fzq65r9g5hhw6y7eweu6
X-HE-Tag: 1773130683-746378
X-HE-Meta: U2FsdGVkX1++YocSRIq9yq8pigGjcmGGGkZTu2s4ALWwDWiCGPgPubHuyIMFY0pD0w6Ving0qv/gGDZxPtUuw8pkq2V2uVK2gFfb64vKLyEQQzUPW7IkFAwHj5hLwTaO+mn/R0u18c70L5WwDkWacOeG5ra6q7C/QxKJ8Z/by+VL1yd0iwBGRWKDvn/XSYSBL4Gu7hsqbqclImhrTjCQHZKqOwRvPQQ9ztq/TbSzRpEkPL4+FYkCYrnZmim70h9/uwaBduIUeqatoSwwK4cij6Qtolxpz7FUYzfbpZRXwt8bIlABnemWxBvs+5BtQB/eODUR7kAbfTcuBPTMvDD38Y/EpxKcf9lBv8dJGd5sw596yBDDgGLsnLkoFkkXd78GfRW8GPdjX7HNijD15HRr327Sv6tKYoaZNAZBTRNauxZ/kfYjtoQxDRbLSv0pz1/vHlwnnCmi8SRfxSuNMA75jSpP3cnNsegCU9RrEPUuVQKBMjluWjza61tS71bzYPo6/KrR7sGIW6MITRHcUVE2ftiJrHmgpyiNon47FIoQ9JAMAnHZ4+n7klXI4sPifBc05lKQ8UYdNgLKeY/c3P4+Sw8kwhyH0hs1E7+tHwtos0+sn77UE5zp6M0UF3qRk80tdYjnH3khTAOrx93MkpJCJg6ItBc/fbnbnQ53EZnVCiy91kiBo64tiRl/RnT4wmcDedwgje5/ZHs2KiU/cnlvKHy/QutoX8exXk4pJyvn7el5OAJwvvbieVe043sI/6UHK42H4jYQOlorHmkVDzl9wB47UWS7QumQsnM3UF/LfXct6412zw+dHf8Gc5UBTwG9KBpbiseBEutZYWAub5/m5zDNnul0b5e5NTxP6u3zGF6MdOnCIplvW0SfQ/2eGakb2vxM9cYgC4DDJjyQYuwSHi3qWJCkyt6bp5/b+cOVHfH1k5oXKEsuskcmm3e5xKe06oOtrA+jE84tHOJPexO
 mReEJkvO
 W+V18Qjjl3u09qB+x0j7R7HOHc5f/YgEZSWXGAgejWj7WrlChvCKpfPjPxCpl3RkGA4SFcZ90XVDfMAmd99T/VXJDFrlp6ExOtMbUXLVQGnf94GtavXSeOmhgtYhOKU3mJbxfXGw4EuiZAwKMjvGucHR8rLkv94EEbQfx8CF9GyLP9WodYzNkLAvEpdWtBjHiogWKAqKJR1zBXE6wBKbqQkdiemxIJrtcIDRjaJqwH7fZIC/lp6YTlZrYMF+3TRl1HjCdPlmqDyZ3NKaoDKkMNiN9+Y0iclIyzfxxTk6ykc9suyfOcmJGe/hukA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 02:37, Baolin Wang wrote:
> 
> 
> On 3/7/26 4:02 PM, Barry Song wrote:
>> On Sat, Mar 7, 2026 at 10:22 AM Baolin Wang
>> <baolin.wang@linux.alibaba.com> wrote:
>>>
>>>
>>>
>>>
>>> Thanks.
>>>
>>>
>>> Yes. In addition, this will involve many architectures’ implementations
>>> and their differing TLB flush mechanisms, so it’s difficult to make a
>>> reasonable per-architecture measurement. If any architecture has a more
>>> efficient flush method, I’d prefer to implement an architecture‑specific
>>> clear_flush_young_ptes().
>>
>> Right! Since TLBI is usually quite expensive, I wonder if a generic
>> implementation for architectures lacking clear_flush_young_ptes()
>> might benefit from something like the below (just a very rough idea):
>>
>> int clear_flush_young_ptes(struct vm_area_struct *vma,
>>                  unsigned long addr, pte_t *ptep, unsigned int nr)
>> {
>>          unsigned long curr_addr = addr;
>>          int young = 0;
>>
>>          while (nr--) {
>>                  young |= ptep_test_and_clear_young(vma, curr_addr,
>> ptep);
>>                  ptep++;
>>                  curr_addr += PAGE_SIZE;
>>          }
>>
>>          if (young)
>>                  flush_tlb_range(vma, addr, curr_addr);
>>          return young;
>> }
> 
> I understand your point. I’m concerned that I can’t test this patch on
> every architecture to validate the benefits. Anyway, let me try this on
> my X86 machine first.

In any case, please make that a follow-up patch :)

-- 
Cheers,

David

