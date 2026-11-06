Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A9D606D824
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=polyxeno.com header.i=@polyxeno.com header.a=rsa-sha256 header.s=fm3 header.b=Gw3R3hvo;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ka86i1/v
Received: by kanga.kvack.org (Postfix)
	id F36786B05B1; Fri,  6 Nov 2026 07:08:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E5C6B05B2; Fri,  6 Nov 2026 07:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFDD36B05B3; Fri,  6 Nov 2026 07:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA0586B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:08:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5135D140D19
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:08:53 +0000 (UTC)
X-FDA: 85404572946.07.13F26EB
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id DF131100009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:08:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=polyxeno.com header.s=fm3 header.b=Gw3R3hvo;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="k a86i1/";
	spf=pass (imf14.hostedemail.com: domain of gerg@polyxeno.com designates 202.12.124.147 as permitted sender) smtp.mailfrom=gerg@polyxeno.com;
	dmarc=pass (policy=none) header.from=polyxeno.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793966931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W54/xbpGmZGa8KjiOUi1NHwwL0wDet2bTgr3FtF8FU8=;
	b=WggycfEGoPpdg/3cOgNpzx7Al/e19f8EXrHiKJcoedtVAHwmDpWLflfLk8CksXHrI2OiVb
	eF770yd0eivR7U0jHFvDoOllAuaDNXMuluOTbgJ112143xPB9I6P42oGgYtq/zTVyjdkub
	K/jfvWoewRlU658RReU0LisPT8oEj3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793966931;
	b=42s9Qlh8DmO3WIncAS7pPUSLTmSA9Kor5O+C468tF19lVEoI8YJOjt9QC+maSQLi7clwWb
	nyekKuncZM+45S7cZc1FA3uJOE8KyAxUr86oNoqdXqrj2Z6U8VOq9g+iXXZAreZ0bgfR0q
	ZVEBUkqP0mpMEz+WE0EhY1BNXX6fD50=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=polyxeno.com header.s=fm3 header.b=Gw3R3hvo;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="k a86i1/";
	spf=pass (imf14.hostedemail.com: domain of gerg@polyxeno.com designates 202.12.124.147 as permitted sender) smtp.mailfrom=gerg@polyxeno.com;
	dmarc=pass (policy=none) header.from=polyxeno.com
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 198AC1D00071
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:08:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 06 Nov 2026 07:08:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=polyxeno.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1793966928;
	 x=1794053328; bh=W54/xbpGmZGa8KjiOUi1NHwwL0wDet2bTgr3FtF8FU8=; b=
	Gw3R3hvoDNctLuLtzfjmKNpSlMWoMQADqk5r4tZ+Ao9d0t+NfoGsS0JACpwRtl/M
	dDLG9YMzuMuy1vZ9CRP2yk7yb4qGpPTuv5sx1jSuXhSRuz87x0runTKnCHGUSr5m
	qUOwHW9d42v4yf8E3Bs7vFoh4Wci5uw4Yj2+udXr3aCydUJBBwXmd983Fqo7jmuF
	uWKtbDV+U0ovUQTfPSWmRAADKn1dXJSm/snnuASAAiOIgaQuvXJ1w+Qm7HNqnwm6
	h7x3VErBLyJV73zuFL5uGcMo55vFRIHqaAsESS23ugFhbpl9YPES9AkBwlrxUp4k
	dUd/y7ZU+O97dgt5bd61pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793966928; x=
	1794053328; bh=W54/xbpGmZGa8KjiOUi1NHwwL0wDet2bTgr3FtF8FU8=; b=k
	a86i1/vCxXzYkZGHAPAWrG+6K/zC49Q8NvdnU6aeVr0VdGaZ6KQJjOUkAJ/zXX/z
	h2kqS5cYKzKu9dqkWWTWIcDIDuiMVwc1el3a4KljCYpY60s7F6Rkti4f/f/KRhTI
	bOMxu+tMfXnRrcsPc3CTM7Cev4AH9XB0fQrv1eJJh7hGXQfe8YGccIowtA/LuspO
	r3EWZ9Uk/KgDPRoJUTWfA3l+dxK/2cIoER+WN9ScTPdxH5zPlNA5jmdMu6c+idDJ
	Io3//iRR22ODbPn26NM1QP5BCBIl9xEIe5zZ1CV5pIWDWf1oRUTcwGxw7ppmzQmh
	cFLSV/j8/3Zk2cHAZZDAg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=polyxeno.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793966928; d=polyxeno.com;
	mf=PGdlcmdAcG9seXhlbm8uY29tPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:ghU7bHvE2ya+D9AXJrlDslw2+7vK+ZwPsTU0OT8zOUALQFr
	V27SqASBJjYjdn4C93RD3qmxMtJ+TevHfj+nCzf83HaCflxQfoEGJdcBV7S+upkl
	sMsWZurn7BiMPlcFdIJZcCzKjnASE1L6/8RfiDB7tUNNf6MSSi4oI2pCZ83JlAcT
	vKpaRoHBJrUBt7PicS+VZrtz9HqNcQQZ9VssI4Kn1TQrH6PrBilkqWWfCzWORW27
	s6847mStfxyJPL51kYFRhAu6EvmLT19rHeH++aWe4WSBG+lYeVanhgME1rJxhg2L
	eZPe2BpPs4beTX3AUKCQH6M+9jzS0w5tk/HJA7Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:dqwlH5JiDOQVwm/0IH6ceSO+Axogg74CqwsRlelotDo=:0ychIidybPUlrdythwfHQK4JLYQJUfYjrKVosDQ6wSA=;
X-ME-Sender: <xms:T8PtaloJzIkEMdv3yJvXLjvtBr8pNLSL5G9O3w31O_gbX0E22OvUFA>
    <xme:T8PtavOm0P1Olpy_8BLuGLpIyn0ZNBvfMAqNJut4_NfdzB31BdC-7WjJ-boGKT1n2
    TMMwRk5RaGSxEANhth6NjGLR2R3if_7j7cXH7L5WYAzFaaN9XbBndhw>
X-ME-Received: <xmr:T8Ptah1yhEQjmOuQK7S9k7msJXgLQLg2UyHMga0Z2r1IBgoqqc7nFYUEaAMrta7zssy3QA>
X-ME-Proxy-Cause: dmFkZTFKgXbpKYmlPU9EkHfb52mvEGbcM3NmrqZDY3l74hBhbOb3a1PMZPdApMLRP4RuVf
    muLoFz8RdaqBUIjCA0h78xmpQBjLgZcmucDAI/I0MBr48zab5K+5wbaMxjuv53h76Nzhnp
    HyrMtPJg2Z7nFbf1IMb6l0NsYq9dDKgA84Obb4qN2KPrDwXKxsb3dbH97+/mcE/SN8wgp0
    UbZboCxUsj1Vy1ScAHJX720ZOtKl2S0/8XMlp+gSnGBzHWIyCsMUig3OgqpB9Cux+qFY23
    NyKrZEZF5cxgBWBjgkI7qJcVdsLxldE/es4CBx/azUQebaxVocolUqrJonM4NX5exqZWZS
    Z9W4cnQ2AtUXEoYQ3DNHsayibHp9X/87lB6c14torZecRqRpvqIAox3Q9ITlno8Zs1sZFH
    BkMBSz0FLvuGGFwR3Hte6CcL8xfeNma6jnZfxzFkzBaerbC3dlNvmHLGqp6ZnWVpMf5eIq
    HNC8/YQ7qKnf8CcFO67F13xfWddc7LXvNNojQUbN0avgnXdLTvM/TIXPlCpldcKOVCJIzT
    joKc87HHU7+AYbQHrNNYpNTvdID9d0qVtAmgnExP4KG2U3m+h0zHQQ79Ln3+/jp3quW2Yj
    3xIjI5u0HPt9LoMrrEbUCjr/oD7bRjEO3ajiaCWQ/ON0Lp7FmmeyxZc2zdjw
X-ME-Proxy: <xmx:T8PtatoDWjdw6hYH-ql792Ark4utskpVmDjxlNc_JoR-0c-m17Na1g>
    <xmx:T8PtarcHEx4Uyks1HVAZPyUDIni8sdX4MU-2vLWu0RPnw9Tff4kWiQ>
    <xmx:T8PtavvwQpU3eNB_gTni-hcLssEbUNwJupHKYnobY8ORupu8qkUeSA>
    <xmx:T8PtarU4YvmqwDVoXxxZjMWFGQQc5VhkHo-SnJDWsMrkJeWrSVlVMw>
    <xmx:UMPtasUSd-Nz9RBUclqJ1OaT1EYV2_2nC_m84szWf2V5OONLLByENJ1z>
Feedback-ID: i09fe4b60:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 07:08:42 -0500 (EST)
Message-ID: <e6ed4165-03fd-4204-b25a-bafc37c3930c@polyxeno.com>
Date: Fri, 6 Nov 2026 22:08:40 +1000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory: use pmdp_get_lockless() for the pmd read in
 do_fault_around()
To: Hui Zhu <hui.zhu@linux.dev>, "David Hildenbrand (Arm)"
 <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Geert Uytterhoeven <geert@linux-m68k.org>, Sam Creasey <sammy@sammy.net>
Cc: Hui Zhu <zhuhui@kylinos.cn>, stable+noautosel@kernel.org,
 linux-m68k@lists.linux-m68k.org
References: <20261104091050.117076-1-hui.zhu@linux.dev>
 <dec26f4a-138a-4cd7-b000-4bda7c61af82@kernel.org>
 <88a6bf17-2189-44a8-8255-50b7ee1d80f2@linux.dev>
Content-Language: en-US
From: Greg Ungerer <gerg@polyxeno.com>
In-Reply-To: <88a6bf17-2189-44a8-8255-50b7ee1d80f2@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c1kbssy3hnxnntcmhhmby6ow3fys7ycg
X-Rspamd-Queue-Id: DF131100009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793966930-872107
X-HE-Meta: U2FsdGVkX1+0n7pADkURK6/7TqyjpSUIP4TLMhVDABICsH8piQOSe1rebz+yZFoJ9qw/fY4CA4QEZuODO8ALlRZpTylVsPHPUMVjj0gRLmUP1JZyQQE4+NV+w7MT3nvPc4AVNnl5/JmiLo8aay1jC/m/eLfpBhOThBOX0j8PiSLuRey1oAmrd2ycPeKpST6ZwqvwNZnbLz1YfOAydBj0JMY/tzxZdSyR197VaXzg2u1jLs0lWZbnNm8VlgINZijUfDHcC4qKQ/r0cmk1WgzCOszeF6fRIliYZzrPDao6XXOMchRXHnKUehmS0+5f67cWJbBjDWYoWjYWHMRvAd/BAQFZiQ8Gyo244JlgR7+DL+e8KoGsJjPM8m1tTws3bX6t+kjKuHhIIJyyDJ4Qb3c3t4SCcCZqI9Z1DwJEhqMgrZXUljhyFYq+iwVwS3+oVZ4MnEWRSYEok3PdF4L2N6bEWeW43E+zFgn9y41GtCHdBE+pTzLyMNuNMu+CbhHqWrgWyMJYzT4z+5LuuHCG630fzCsEOu9r1V7J7cUP8Af+7N9ZlXxoInraD1NE32ukNkyF2gFD3qMmsHtNHQVk956rWVvVNNmOHlBnw0rpOCv428xNYmdByMtBdxTNNZ/g+sy9ndMMWFrtIgIkOpuBSG3Ly7uf6jvi1PHGpklCfjzIYcgEROF7aC7PWktuLjbbM+AIP5zYyi4onET6HurMxEOo+Ku9nXIZX/9KLPtNGMYqBr4Hvz+0jKlUqSWm15HIHK21l61Zsjvr9kzIVhdO0h6L6h61xmJLYTwuT3qjHJVlZNf+ZW3St4MecYaOzUs/uXffKXe8A/Fevln4x6Q+zZRmip6vovCcPimuq/7EnfgpWGBEQBS8ACUBn/4konnnhds7ReYrl9nP0cF/jpoArB+HuVhxoKO2Ng/yvkfYsmlIsUUrkLhIPvUUxdbvnHAys+zM6IdhXWb9havDyOFiaZy
 8gIOnWg2
 whRmJl5TULpQWw1NM0HJNGfBsyjNb1+ehxCux18Xn2zgUQEp2WXC/b7gX8JDjpebqr0pmC6E/vfHsIXKg0iSxS92Li0axd27MbCX+jCI2/+ofO0y4B5A1cXzMfty7fBQjXsv3vclrBfDMWCFecl2mCJ1+7w0vB4oM0kpNur0LCfyfIj3DbD9oEGdkBa2Cb/ROwH/rRb6NqFkU05KuTVteEhaszPXl4xz9cBuZaMMzl8RASIxyf0RW/yFWBA/uvdgzHpetrWNc7XwIwUCFPZQ7LFgQy0ZRfZDBGb/oJJnY0N3Uxmfzxh4+vHXdRZLHJQy4j5cVzVmod6qcuZD34R1dCfqTOGdTIjdRa2MM4EsApKiAUh6V8aMD/vIxyz/4vTm3W8J9PWKHhJa9r+UapNXtJQbGRficO/whfS4Z7shLbzzXSd/ZJIE3vmb0RovGvGjYOQFSj9hNBwBG3vplrb+g5B7lQmF2lx3tbKhWsnG9OrWh4z/aW3yKbaRXSOjgbryMtgIxzFzrHlPtiUU7ygbg+hEMIjXoIDqaXcDewpJxKVOCTVGezggytC9RdFEO9xof8obUnGiGbASw7HKsxQ+04f25IsgdBB4VRYysFyqSen+xo7bVwx8cD1AO2oe5CLkmOmaMHaCf4qYuX12GJVIIxpBwTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Hi Hui,

On 6/11/26 13:03, Hui Zhu wrote:
> 2026/11/5 20:00, David Hildenbrand (Arm) :
>> On 11/4/26 10:10, Hui Zhu wrote:
>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>
>>> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
>>> is in mainline:
>>>
>>>    write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>>>     native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>>>     pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>>>     pmd_install+0xe0/0x120 mm/memory.c:444
>>>     finish_fault+0x5bc/0xb00 mm/memory.c:5204
>>>     do_cow_fault mm/memory.c:5432 [inline]
>>>     do_fault+0x5d0/0x6e0 mm/memory.c:5526
>>>     handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>>>     __mm_populate+0x144/0x270 mm/gup.c:2207
>>>     __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
>>>
>>>    read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
>>>     do_fault_around mm/memory.c:5341 [inline]
>>>     do_read_fault+0x162/0x670 mm/memory.c:5381
>>>     do_fault+0x31a/0x6e0 mm/memory.c:5524
>>>     handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>>>     faultin_page_range+0x227/0x530 mm/gup.c:2156
>>>     __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479
>>>
>>>    value changed: 0x0000000000000000 -> 0x000000001386c067
>>>
>>> Both paths only hold mmap_lock for read, so do_fault_around() tests
>>> vmf->pmd while pmd_install() populates it under the pmd lock.  The race is
>>> benign: a stale pmd_none() only wastes the prealloc_pte, which do_fault()
>>> frees again, and a pmd seen as populated only makes ->map_pages() find no
>>> PTE and do_read_fault() fall back to __do_fault().
>>>
>>> The load still has to be lockless-safe.  The store side already is: on
>>> i386-PAE, pmd_install() publishes both halves of the pmd with a single
>>> cmpxchg8b.  The load side is not.  pmdp_get() is a plain READ_ONCE() over
>>> a pmd_t that is wider than a word there, so it becomes two 32-bit loads
>>> and can return the low half of one pmd together with the high half of
>>> another.  Use pmdp_get_lockless(), the accessor for pmd reads that do not
>>> hold the pmd lock: it re-reads until both halves come from the same pmd.
>>> It is also what __pte_offset_map() already uses on this very pmd a few
>>> instructions later.
>>>
>>> Only X86_32+X86_PAE and SH+X2TLB compile the retry loop, these being the
>>> GUP_GET_PXX_LOW_HIGH selectors that have more than two page table levels.
>>> mips32 with 64-bit physical addresses selects GUP_GET_PXX_LOW_HIGH too,
>>> but is 2-level and so falls back to pmdp_get().  On every other
>>> configuration, x86-64 included, pmdp_get_lockless() is pmdp_get(): the
>>> pmd is loaded in one go, the READ_ONCE() silences the report the same
>>> way, and there is no functional change.
>>>
>>> Fixes: 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
>>> Cc: stable+noautosel@kernel.org # KCSAN annotation only, no functional change
>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
>>> ---
>>> Changelog:
>>> v4:
>>> Commit message only, the diff is identical to v3.  Spell out the affected
>>> arches and add the lore links for v1-v3 (Lorenzo Stoakes).  Reword the
>>> cmpxchg8b sentence: the store is already atomic, it is the load that tears.
>>> Add the Fixes: tag (David Hildenbrand).
>>> v3:
>>> https://lore.kernel.org/all/20261103014749.96764-1-hui.zhu@linux.dev/
>>> Shorten the comment to one line (David Hildenbrand).
>>> v2:
>>> https://lore.kernel.org/all/20261102093120.92654-1-hui.zhu@linux.dev/
>>> Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).
>>> v1:
>>> https://lore.kernel.org/all/20261102031308.66177-1-hui.zhu@linux.dev/
>>>
>>>   mm/memory.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 0fb676dd2bd63..f25c2ce0ef153 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>>>       to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>>>                 pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>>>   -    if (pmd_none(*vmf->pmd)) {
>>> +    /* pmd_install() rechecks pmd_none() under the pmd lock. */
>>> +    if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
>>>           vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
>>>           if (!vmf->prealloc_pte)
>>>               return VM_FAULT_OOM;
>> Fun, this breaks some odd m68k configs because they do some legacy weird stuff with pmd_none().
>>
>> I'll throw in the following cleanup. CCing m68k maintainers: I would drag
>> this along with this fix here unless you disagree.
>>
>>  From e3c739933a04743e3923f6f39a603e93f2700304 Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> Date: Thu, 5 Nov 2026 12:49:38 +0100
>> Subject: [PATCH] m68k/mm: simplify
>>   pmd_none()/pmd_val()/pmd_present()/pmd_bad()
>>
>> pmd_t on m68k used to contain 16 words. Commit ef22d8abd876 ("m68k:
>> mm: Restructure Motorola MMU page-table layout") reduced Motorola PMDs
>> to one word; Sun3 and ColdFire use word-sized folded PMDs.
>>
>> Use direct member access in pmd_val() and replace the Sun3 and ColdFire
>> pointer-taking predicate wrappers with inline functions taking values.
>>
>> This allows us to write something like:
>>
>>    if (pmd_none(pmdp_get(pmdp)))
>>
>> While at it remove unused pmd_present2() and commented-out pmd_bad()
>> on sun3.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>   arch/m68k/include/asm/mcf_pgtable.h  | 20 +++++++++++++++-----
>>   arch/m68k/include/asm/page.h         |  2 +-
>>   arch/m68k/include/asm/sun3_pgtable.h | 23 +++++++++++++++--------
>>   3 files changed, 31 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/m68k/include/asm/mcf_pgtable.h b/arch/m68k/include/asm/mcf_pgtable.h
>> index f45a882238dbb..4efa8e3e1e98a 100644
>> --- a/arch/m68k/include/asm/mcf_pgtable.h
>> +++ b/arch/m68k/include/asm/mcf_pgtable.h
>> @@ -130,11 +130,21 @@ static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
>>     #define pte_page(pte)    virt_to_page(__pte_page(pte))
>>   -static inline int pmd_none2(pmd_t *pmd) { return !pmd_val(*pmd); }
>> -#define pmd_none(pmd) pmd_none2(&(pmd))
>> -static inline int pmd_bad2(pmd_t *pmd) { return 0; }
>> -#define pmd_bad(pmd) pmd_bad2(&(pmd))
>> -#define pmd_present(pmd) (!pmd_none2(&(pmd)))
>> +static inline int pmd_none(pmd_t pmd)
>> +{
>> +    return !pmd_val(pmd);
>> +}
>> +
>> +static inline int pmd_bad(pmd_t pmd)
>> +{
>> +    return 0;
>> +}
>> +
>> +static inline int pmd_present(pmd_t pmd)
>> +{
>> +    return !pmd_none(pmd);
>> +}
>> +
>>   static inline void pmd_clear(pmd_t *pmdp) { pmd_val(*pmdp) = 0; }
>>     diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
>> index d30f8b2f15927..09a2c020ec992 100644
>> --- a/arch/m68k/include/asm/page.h
>> +++ b/arch/m68k/include/asm/page.h
>> @@ -17,7 +17,7 @@
>>    */
>>   #if !defined(CONFIG_MMU) || CONFIG_PGTABLE_LEVELS == 3
>>   typedef struct { unsigned long pmd; } pmd_t;
>> -#define pmd_val(x)    ((&x)->pmd)
>> +#define pmd_val(x)    ((x).pmd)
>>   #define __pmd(x)    ((pmd_t) { (x) } )
>>   #endif
>>   diff --git a/arch/m68k/include/asm/sun3_pgtable.h b/arch/m68k/include/asm/sun3_pgtable.h
>> index 704442a391fd7..5867d24032655 100644
>> --- a/arch/m68k/include/asm/sun3_pgtable.h
>> +++ b/arch/m68k/include/asm/sun3_pgtable.h
>> @@ -109,14 +109,21 @@ static inline void pte_clear (struct mm_struct *mm, unsigned long addr, pte_t *p
>>   #define pmd_page(pmd)        virt_to_page((void *)pmd_page_vaddr(pmd))
>>     -static inline int pmd_none2 (pmd_t *pmd) { return !pmd_val (*pmd); }
>> -#define pmd_none(pmd) pmd_none2(&(pmd))
>> -//static inline int pmd_bad (pmd_t pmd) { return (pmd_val (pmd) & SUN3_PMD_MASK) != SUN3_PMD_MAGIC; }
>> -static inline int pmd_bad2 (pmd_t *pmd) { return 0; }
>> -#define pmd_bad(pmd) pmd_bad2(&(pmd))
>> -static inline int pmd_present2 (pmd_t *pmd) { return pmd_val (*pmd) & SUN3_PMD_VALID; }
>> -/* #define pmd_present(pmd) pmd_present2(&(pmd)) */
>> -#define pmd_present(pmd) (!pmd_none2(&(pmd)))
>> +static inline int pmd_none(pmd_t pmd)
>> +{
>> +    return !pmd_val(pmd);
>> +}
>> +
>> +static inline int pmd_bad(pmd_t pmd)
>> +{
>> +    return 0;
>> +}
>> +
>> +static inline int pmd_present(pmd_t pmd)
>> +{
>> +    return !pmd_none(pmd);
>> +}
>> +
>>   static inline void pmd_clear (pmd_t *pmdp) { pmd_val (*pmdp) = 0; }
>>     /*
> 
> Hi David,
> 
> Thanks for picking this up, and for the m68k cleanup!
> 
> Tested-by: Hui Zhu <zhuhui@kylinos.cn>
> 
> Tested with gcc-m68k-linux-gnu 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04), on
> three configs that between them cover all three m68k families:
> 
>   amiga_defconfig                    Motorola MMU, PGTABLE_LEVELS=3
>   sun3_defconfig                     SUN3,  PGTABLE_LEVELS=2
>   m5208evb_defconfig + CONFIG_MMU=y  ColdFire,  PGTABLE_LEVELS=2
> 
> Without your patch none of the three can build mm/memory.o, and each fails
> at a different site:
> 
>   arch/m68k/include/asm/page.h:20:27: error: lvalue required as unary '&' operand
>   arch/m68k/include/asm/sun3_pgtable.h:113:33: error: lvalue required as unary '&' operand
>   arch/m68k/include/asm/mcf_pgtable.h:134:33: error: lvalue required as unary '&' operand
> 
> With it, all three build a full vmlinux with zero warnings.
> 
> Two things that might save you some time:
> 
> - m68k looks like the only arch with this pattern. Grepping arch/ and
>   include/ for '(&x)->pmd' and '(&(pmd))' finds nothing outside arch/m68k/,
>   and pmd_none2()/pmd_bad2()/pmd_present2() only exist in mcf_pgtable.h and
>   sun3_pgtable.h. So your three hunks look complete to me.
> 
> - No m52xx/m54xx defconfig enables CONFIG_MMU, so the ColdFire path through
>   mcf_pgtable.h has no defconfig coverage at all; you have to flip it on by
>   hand (scripts/config -e MMU && make olddefconfig) to reach it. That is
>   probably how this went unnoticed for so long - my patch has been breaking
>   m68k since v1, because pmdp_get() returns by value just like
>   pmdp_get_lockless() does.

The m5475evb_defconfig is supposed to have MMU enabled:

     $ ARCH=m68k CROSS_COMPILE=m68k-linux-uclibc- make m5475evb_defconfig 
       HOSTCC  scripts/basic/fixdep
       [snip]
       HOSTLD  scripts/kconfig/conf
     #
     # configuration written to .config
     #
     $
     $ grep CONFIG_MMU .config
     CONFIG_MMU=y
     CONFIG_MMU_COLDFIRE=y
     CONFIG_MMU_GATHER_NO_RANGE=y
     CONFIG_MMU_GATHER_MERGE_VMAS=y
     CONFIG_MMU_LAZY_TLB_REFCOUNT=y

But something ends up disabling it when you compile.
I'll fix this.


> I also checked whether your patch changes code generation, by building the
> same tree with and without it and comparing every object with objdump -d
> (plain cmp is useless here, timestamps and link layout shift everything).
> Counting only objects whose disassembly actually differs:
> 
>   amiga      3733 objects, 0 changed
>   sun3       3553 objects, 3 changed: mm/memory.o, mm/pgtable-generic.o,
>                                       mm/vmalloc.o
>   m5208evb    716 objects, 1 changed: mm/pgtable-generic.o
> 
> amiga is the interesting one. It is the only config where pmd_val() itself
> changed, and it comes out bit-for-bit identical, which also says the build
> is reproducible enough for this comparison to mean anything. sun3 and
> ColdFire differ because pmd_none() stops taking the address of its
> argument, and the direction is an improvement. In mm/vmalloc.o on sun3 one
> function loses a forced spill:
> 
>   -  subql #4,%sp
>   -  movel %d0,%sp@(12)     /* spill the pmd value */
>   -  lea %sp@(12),%a1       /* &(pmd) */
>   -  moveal %a1@,%a0        /* read it back */
> 
> and turns into a 13 instruction function with no stack slot at all.
> Instruction counts are otherwise flat (sun3 mm/memory.o 7373 -> 7373,
> mm/vmalloc.o 5514 -> 5515), so it is not a size regression.
> 
> Dragging the cleanup along with the fix sounds right to me. It is a hard
> prerequisite, and sent on its own it would just look like a cleanup with no
> urgency. I assume it goes in ahead of 6ab55cfd in core-7.5.misc, so that
> linux-next never sees a broken m68k in between.
> 
> One red herring in case anyone else pokes at this: m5208evb with its stock
> defconfig (CONFIG_MMU not set) fails to build mm/memory.o for reasons that
> have nothing to do with any of this - implicit declarations of
> pte_is_uffd_wp_marker() and pmd_pgtable(), plus a parse error in
> include/linux/mm.h. Pre-existing, and it goes away once MMU is on.

You should not be able to set MMU=y if configured for the M5208.
It doesn't have an MMU. You want the 5475, 5485 or 54418 to test
valid MMU=y configurations.

Regards
Greg





