Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42827CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFBB8E000C; Thu,  6 Nov 2025 06:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D73A8E0002; Thu,  6 Nov 2025 06:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9142E8E000C; Thu,  6 Nov 2025 06:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1F18E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:16:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38D24BAA54
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:16:45 +0000 (UTC)
X-FDA: 84079929570.27.EF1E251
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 811F940006
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:16:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pNIBL3u3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762427803; a=rsa-sha256;
	cv=none;
	b=rgPwkV84GgfYzBarLxqkDMeoJ9b+lMrbkoulJU34WSoUWleJI4xOdWLRrMjD+wnG39zWJP
	ozLQnGzT8/LBdav8AdX9QudCKVcnawxvkv2kY+d/HyOG+O90ypZ+RgZSiuOUKeCI0fxRF8
	vKYuzGk1TZ+hngbyipGA2H+HCzlke2E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pNIBL3u3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762427803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYL6bTy/ecPgaOTOs3i4z4cw8FCbLrme7ss1MGpsPFA=;
	b=LymE6j9hLCTPPsFnfLsq0BSnILVBjyZDWyXPBXF5feNZNHLqF+q54tz3yibjPJljzQUfCx
	TupYqU3YrO9x/cCp0iZ/NbcFpa0IZI8j9pmal8DXsTj7MDj9bRHHk52t9xUQfL/tCV8hMX
	YM8aByMmf/dWDTanhlRu0nYl8VX8vq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB1B460232;
	Thu,  6 Nov 2025 11:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B1CC16AAE;
	Thu,  6 Nov 2025 11:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762427802;
	bh=8cnDbTxQTbM8lcfQEMN460D5ylwQe2K609JbpAnX38A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pNIBL3u3EEjtdJUOBEkKSw9pgKm1DKIuwuAhXAGF61uu+g4vxWTiopAz9au9bPyWZ
	 LlR+oCdBEexup/EKygNsFNvjID3HblLXFXz78unMmeM1MgpW8/aUaThhNIPaKH+nGV
	 pCShx9dzuS3c5sBJSN96D0tIqukdM1KSl0W5hPXxK3mmyTME5zyPkF4hCSm+Oo4Of0
	 UTeOlr1FN6o1H1EHaKrocMZ6B43YU1Wp0RzrsqMmuc5CDNgSkcec6XFODO7gfTvKbY
	 GV6YgI4/vUNODAb8KG3Fxn2iGlUve6/sR4awUWbOesU7y/xNrw/EyuUwBbo+Cj/0Bj
	 SigsL9PrJwEHQ==
Message-ID: <0bc6a1ba-4f4f-4b04-b66c-b5d217faefab@kernel.org>
Date: Thu, 6 Nov 2025 12:16:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/ksm: fix flag-dropping behavior in ksm_madvise
To: Vlastimil Babka <vbabka@suse.cz>, Jakub Acs <acsjakub@amazon.de>,
 linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Jann Horn <jannh@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 peterx@redhat.com, axelrasmussen@google.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20251001090353.57523-1-acsjakub@amazon.de>
 <20251001090353.57523-2-acsjakub@amazon.de>
 <13c7242e-3a40-469b-9e99-8a65a21449bb@suse.cz>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <13c7242e-3a40-469b-9e99-8a65a21449bb@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 811F940006
X-Stat-Signature: mpi6nemnftsh36u97d1ogk63rtmeroa4
X-Rspam-User: 
X-HE-Tag: 1762427803-923378
X-HE-Meta: U2FsdGVkX19BJQpRW0HyYy7NU1wbN+VQo0mQIpA6lDXEeZm9MrUszYkB23p8lwYhiliUJ74VkrNT2R/23iFqiyI5JkRHhPfLR0re9/CGET5th6NwV0x2u9YPUXwglsqqsT+a9d/oA16i/22TSca7kQ8kFJegTSPUfGHUxZXyKNnh8RgXiExIJRl49VHpoJX+VraGLIF4ECFq+9LkU/PhSQRSDROFrriao8WLQfoKj87Y12t5dkaGM+JBP+V4lPfWcH6EmneA9kiTFIArln+CVE6CINOAB4CAIuX4oxcuSldN2Qg9z6ZmYf7fPVw5w/7JgRED7cWtr3Dui7+FpsQ9lvBbSyrPGdBl1uX07uO/NxhXNj/PQ9myCYc0ExLHOcV/8pnSSau9/9OHAYZNPuS4pYomE+RMtLs6KenKyQFvKi7RVFE04lJb0Dx6Do5Aa+p2hAFMRd5dO6BQPuz+rRZd/oQ1x4JDL9rBty2gNqK1vZmJe2xARv0+zEhcp0rk5OBkCt0CXis/C7eDXyOZeYEGLQ852odIATwi8P3Cli7gtVSLUHPzPRd/rnS1UVk8pwtqbTAmE7ZBwn6spUeVKmav8KiJmTOSvUJYSsuORtCXqkGInTx6LrwxONyr69ASNBDV/0+ps314b4zeG6OCd6+lgFiT0C/gkdtrM3bF8UVcsKYrmRbVBPxIF9vyrkO0QM9rfy6Mq80HFA2rPp9ZfuOdD/HazDenUA742coTsq+oBIOS5xUX/hJ6rpc889Fq7hCN67P/2gWRlOggKNDZkzjK7Dau4ocZt+wPDuXmdQqfHv7Ci4ZD+L857vmveoUEi160i+V9fmnB2qUuMshtEOlSM2SX6B1o5nG+DdlIdVmP04AX9ML7RYNklgYkhghs3Uph1EMgQKQkBd05GB7WWlKRSHnxNW8uMMXfWSls1rJ21pgGfQQOOohRXueuS18po6ryjLGbZVoe/KbEZHMtf1D
 1Nq4hAeq
 AyZ4+0YU1HqvgAb+hg0vmq0JnE7l189TprNYR180s43hcgxy1R8e5F/luNg37GcZSnhYtyX0kMCQp1xhsngWBTdh1HhVCdIS5PGH5aumb/3sMH5rhl3FCY73SQchK2ZTzGqFk/Z07yN1ARQ9gP+/8BEPhl2HfP1lD5ljjIeK71pPexqAWOoPOlUMhOtJ2LheG78nRl2CHpEflrH1tDaBvYBvXV+UVwjEiIimDp1sSR2HepgoBcrbfWidqZi0MXq98ffMPEQ7+AmGzlCuonldc3yxW7jQHq96wbzceJm2MZ12/a4SUpRtFevWu7nbECyzVrR3toNvVrY1eTxxE7FEhadTJ8ZuT06naPEOf4YR2XQqfvDNcTpHNDplXdGDpyJD5Hqlskg8xSqVmSh2DtlqJGfeV1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 11:39, Vlastimil Babka wrote:
> On 10/1/25 11:03, Jakub Acs wrote:
>> syzkaller discovered the following crash: (kernel BUG)
>>
>> [   44.607039] ------------[ cut here ]------------
>> [   44.607422] kernel BUG at mm/userfaultfd.c:2067!
>> [   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
>> [   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
>> [   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
>> [   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
>>
>> <snip other registers, drop unreliable trace>
>>
>> [   44.617726] Call Trace:
>> [   44.617926]  <TASK>
>> [   44.619284]  userfaultfd_release+0xef/0x1b0
>> [   44.620976]  __fput+0x3f9/0xb60
>> [   44.621240]  fput_close_sync+0x110/0x210
>> [   44.622222]  __x64_sys_close+0x8f/0x120
>> [   44.622530]  do_syscall_64+0x5b/0x2f0
>> [   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> [   44.623244] RIP: 0033:0x7f365bb3f227
>>
>> Kernel panics because it detects UFFD inconsistency during
>> userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
>> to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
>>
>> The inconsistency is caused in ksm_madvise(): when user calls madvise()
>> with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
>> mode, it accidentally clears all flags stored in the upper 32 bits of
>> vma->vm_flags.
>>
>> Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
>> and int are 32-bit wide. This setup causes the following mishap during
>> the &= ~VM_MERGEABLE assignment.
>>
>> VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
>> After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
>> promoted to unsigned long before the & operation. This promotion fills
>> upper 32 bits with leading 0s, as we're doing unsigned conversion (and
>> even for a signed conversion, this wouldn't help as the leading bit is
>> 0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
>> instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
>> the upper 32-bits of its value.
>>
>> Fix it by changing `VM_MERGEABLE` constant to unsigned long, using the
>> BIT() macro.
>>
>> Note: other VM_* flags are not affected:
>> This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
>> all constants of type int and after ~ operation, they end up with
>> leading 1 and are thus converted to unsigned long with leading 1s.
>>
>> Note 2:
>> After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
>> no longer a kernel BUG, but a WARNING at the same place:
>>
>> [   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
>>
>> but the root-cause (flag-drop) remains the same.
>>
>> Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")
> 
> Late to the party, but it seems to me the correct Fixes: should be
> f8af4da3b4c1 ("ksm: the mm interface to ksm")
> which introduced the flag and the buggy clearing code, no?
> 
> Commit 7677f7fd8be76 is just one that notices it, right? But there are other
> flags in >32 bit area, including pkeys etc. Sounds rather dangerous if they
> can be cleared using a madvise.
> 
> So we can't amend the Fixes: now but maybe could advise stable to backport
> for even older versions than based on 7677f7fd8be76 ?

Yes, I agree.

-- 
Cheers

David

