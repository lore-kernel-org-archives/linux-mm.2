Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732DCCA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE146B0093; Mon, 28 Sep 2026 04:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457306B009F; Mon, 28 Sep 2026 04:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8376B00A0; Mon, 28 Sep 2026 04:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01A336B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:50:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 282DA14014D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:50:25 +0000 (UTC)
X-FDA: 85262549610.06.441FE38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5DDCA140003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:50:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iEK97vav;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xux5ZPoLqrz1mbftErEicTW9loRDj4oR9SfIqryQVFI=;
	b=pRFVtdqRDTp/f0mhlXeEe/mKP51DXzLg33yern9r2eDWYdU3V4GGx03+Avnmyk9wNEIJOQ
	FHA0vE5nik34K9NqAaJe0XUyqamWVbg+GSDM1rMPuIM8tvR7f3WMhPOjyhxLo+LdUzT+Wl
	WrWQEco8GyzAwiegsaAce//wtKYM8IQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iEK97vav;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585423;
	b=3+giGPp43MiLpxiGwQmP+AUyZGYSg+MzRjzzpRPXF/R031WSvbUSB8GGm98CQo0t//IHB0
	dSzbmupX1WgV53Lj9fSxU4EDLcYguJRbPhAOzrwTmQUYir7zvN/nXjvLQJrpTzlj3DqeCU
	zh3bOcyUr0VK2ql/Afx+wpr2Cfzqdjk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DE9A43C8E;
	Mon, 28 Sep 2026 08:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EE51F000FF;
	Mon, 28 Sep 2026 08:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585422;
	bh=Xux5ZPoLqrz1mbftErEicTW9loRDj4oR9SfIqryQVFI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iEK97vavCrO6FGamvL6w7E2I1MX2GZCebpDkO0cMSJDvo5xQ2vNNjADjci6TP8N29
	 b8f5WsNIuHiiAVePejbUiD2f14ejjCMal/GCUjIpIQcT74Gun81v7NHdK2Qm42IMCn
	 7yrkD2JQqZC3M8VbYDcqxuGS8IbhDUEdbAyK4k0BgbhaG1CS5D+9XqaUVVL7X0I6o7
	 fReqiFglUmaWiN2BlAbXClfp2HnuyMig/dz67ReP7rtvxpERkOiDkfJTJ/t/SPpeS1
	 7uKDXsEYc3REZnADw9w8J+97lG7Kzs/sY9a6AjOEiFY2bkpohtKyBzjjxopxg2+1jP
	 x6teGcrUOIaqg==
Message-ID: <9009312f-0ffb-4425-ab82-1eb7e52a4646@kernel.org>
Date: Mon, 28 Sep 2026 10:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/13] mm/sparse: remove SECTION_MARKED_PRESENT
To: Dave Young <ruirui.yang@linux.dev>
Cc: David Carlier <devnexen@gmail.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, brendan.jackman@linux.dev, dakr@kernel.org,
 driver-core@lists.linux.dev, gregkh@linuxfoundation.org, hannes@cmpxchg.org,
 jan.kiszka@siemens.com, kasong@tencent.com, kbingham@kernel.org,
 liam@infradead.org, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, osalvador@suse.de,
 qi.zheng@linux.dev, rafael@kernel.org, rppt@kernel.org,
 shakeel.butt@linux.dev, surenb@google.com, vbabka@kernel.org,
 weixugc@google.com, yuanchu@google.com, ziy@nvidia.com,
 devel@lists.crash-utility.osci.io, kexec@lists.infradead.org,
 Baoquan He <baoquan.he@linux.dev>
References: <20260921-b4-sparsemem_cleanups-v2-10-54d81d65e125@kernel.org>
 <20260927192013.144672-1-devnexen@gmail.com>
 <655c509e-318f-48bc-8183-2b1274dd05ac@kernel.org> <aroezLexo1WoeYI7@darkstar>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aroezLexo1WoeYI7@darkstar>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qstxqwthe31c6457xz9g3fx4wbpgb8fx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DDCA140003
X-HE-Tag: 1790585423-929042
X-HE-Meta: U2FsdGVkX19ZX6Iq7NcIeogZJa1fdKD0+2jnKb74W4mQfmvlYMgrBSUA8vzRufXmlDKpPKq8Hze8r+OUCRGP8nO5QOoapTDvkkQFrqvl12LGdiHUvfR5eJmYDKRFUoc1Vu1SXrfhistrmSrl/wVSXgFWC1hkcCp6j4+CdfRjdE7KQxPvCfLYOK352nuB2qrlf7d5b9tTw7Yw+7tKYOWn46Y1FMrxd+IG5ZpgYoyYZN66T5//PHjAy8bo0A4XxA8GC/urZq4jTPmpEL2PVklQZhyHXFR63ccdNMtH+2lBtro+w2L3/D2yyz6edW6Y7M8kU1UyLG1Nv5nh+3eseAtDyKQIMxWEGuxnM7eidewKzjVUaq9VLzbxuoLXDfnvAAejJVduVQRjbcVysCGiSPw+lkjPQQsFrw0b26F5BVhWpkygAAsdVAhXe8bimN3MbPU6WFhHcHq4n1STfS+m0fmCYx2n2wI/UMi3kAAAhJAAcx2QLiUQtVk7SvsDFsD45SPdCbHvnca1z/LEvBeK6Fp3OM+4ftPgFIENwpiaeDrodkt5ldpyg9bGWpsaq6Q0gh9Dw4iZwsAV8Q0NHm32qlTYeY05BqsQQLl8L0ttdlihvMEls2i+nT93jkQvukjgRTTo5zqZOCg2mUWkgp564LpLEPfg1razWRLZEOmrpg6ejTxihNk6r+ZVPewj5NDp1AzOxNXc8ejnY7KqI6AldBKRMCtMxLZBVGe0ype4bahODAMAhN+4fgz8yjabS7mpoMyR8SQ1Yzm+fEExu22PQGkRCoEEp59AmC9GSIptIlHYn5s7OrLtX2IjhFwbQtj9neGX6uGfySvRdTJ9ahfEOKSvoIHY0sMhLZqls93VJ9ee9baRujzqgocjGMUE2+Tz88n2+Rr+Tt12bDh7ff83CEs/o3q/G0OQavsWSCvDhvDzx6GDiwfBXGEHC/knPflW9syRFEJFLLVsvdExs3nHi+M
 E9inF2wn
 yGQGhHOk7+ZJHTZ3eU7Ci/uNhAa+e1yEHoBXuwWgsPc5vIDVkVcUdxLNZHg+on2XZpAEbFVPKUliqSMtU9CCjW+Zfpi19BRRowX+nJP5Ac6vxT/88xp1MX0YxnkLvKGN31gL4u8owR4lIQY9Pw87ldJRJqqeKKhjfkb+LKtcoL4pxqVsJCssTd0dXvErLc3qEOlip2ROqC2PbkZqpP0WvmUIuClDpFydTQGYR4zoGMUP2e5d6SczRkSRH4Qa891a1VbuW2njIrbsvaajoehacrRx0Ggx6POoiupRMtfo5Pz5TgWNszE7JSEbmB2x/p59HnrjvNPUXV61CjM95TysXmc7qKttmjANr+roG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 10:01, Dave Young wrote:
> Cced kexec list.
> 
> On Mon, Sep 28, 2026 at 09:28:08AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/27/26 21:20, David Carlier wrote:
>>>
>>> Hi David,
>>
>> Hi!
>>
>>>
>>> It seems dropping SECTION_MARKED_PRESENT_BIT shifts the other section flags down
>>> one bit. crash hardcodes SECTION_HAS_MEM_MAP as (1UL << 1) in
>>> pfn_to_map(), so it now tests SECTION_IS_ONLINE: offline and
>>> ZONE_DEVICE sections no longer resolve to a struct page. makedumpfile
>>> only checks bit 0 and is fine.
>>
>> Thanks. To be expected when relying on kernel internals.
>>
>> Which makes me wonder why makedumpfile
>> (https://github.com/makedumpfile/makedumpfile) not require any such information.
>>
>>>
>>> Keep bit 0 reserved, or export the bits via vmcoreinfo?
>> We could export it, or crash can simply detect the change based on the kernel
>> version. I remember the latter was done in makedumpfile in the past (although we
>> export it).
>>
>> I can send a separate patch to export it.
> 
> Thanks David.   Checking kernel internals via kernel version is not a good idea
> due to the downstream kernels.

Patch at:

https://lore.kernel.org/r/20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org

-- 
Cheers,

David

