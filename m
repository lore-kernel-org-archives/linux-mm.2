Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD554D1D87B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 06:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A836B0023; Thu,  4 Dec 2025 01:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CF36B0026; Thu,  4 Dec 2025 01:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54166B0027; Thu,  4 Dec 2025 01:54:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D37986B0023
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:54:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3680AC08C3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:54:15 +0000 (UTC)
X-FDA: 84180874470.10.AB3B53A
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0B136100008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:54:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SADPPVIe;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764831253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFoVMIVhgIIxPNZ4zkeUCbud6dwogH4VwdPLXp1GrzU=;
	b=iGdichOeDgvlMllkLxH1hNHkztro5cPEK9CfGDxj8nnNvVRrXPpsUryBJis1ScFFImLQ5q
	OJBYLukKSARIkDLyuTGuZaiq2mBUEEPY2gs+jcyp1J3oA3ujLTe0ANUnjs3L92BTdj9Pbr
	fqvHktTmwfjAuPIF8sSghVafri73aGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764831253; a=rsa-sha256;
	cv=none;
	b=4nrp9tDkryDe5UwlaKtvdx+ujgBQT4IlRM+oh2Rezy90/AyyrA/Riu8IAfhEspulVA2MUg
	gAckoepFVlte06P0ZMPavUwirG8kRRe+cRJnFRH8n/N/akuRK26RcpwlB64SDPHB4Y2NEK
	cI/jusXORH6AjGMZDh6UDNPwn/kOLXo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SADPPVIe;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c20c2b82-cb43-4ecb-b48a-c19b8dbf5c3b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764831250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFoVMIVhgIIxPNZ4zkeUCbud6dwogH4VwdPLXp1GrzU=;
	b=SADPPVIePzv0Ee5PfeaBSq3VtAbpWjbIpKl8jabC5a3qqjXFLo12bef844hS+SeIomC5Mt
	9IzRLVCwAE+q0zXGn3Uv6sK8R01F/InIzR8xext9zmIoFgzKSlpZSGDRcgMs3V/Nqzdz20
	bvQHk81ffhC57S91A82jS+sudPokp2Y=
Date: Thu, 4 Dec 2025 14:53:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH V3 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song
 <baohua@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Branden Moore <Branden.Moore@amd.com>
References: <20251201185604.210634-6-shivankg@amd.com>
 <20251201185604.210634-10-shivankg@amd.com>
 <a8cf9fd2-4521-4068-b436-9a251a6eb15b@linux.dev>
 <26e51398-02e1-4ca7-80f0-0cd76a966188@amd.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <26e51398-02e1-4ca7-80f0-0cd76a966188@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B136100008
X-Stat-Signature: cgjds8yec3t1o8w6btqk3oafuxcwj7id
X-HE-Tag: 1764831252-129458
X-HE-Meta: U2FsdGVkX18LPaiziiYWSHQHOqW9p6U3KddIIHetYOFlDlC6U6WKzdqAaOuhWBkPfkXLk6imnXdRMS6F4gaCvsSC6h3apYQtYJDwj5R5ouP/0SRwsj/02CiUqHxYI3YWi2FhmR2TrlNY8w0uZ7JSIM6F8LABNmG5thGG01ySF/o2a7Ke70yB9O/n74zoLD2/uSGTznkU/Ij3E60Ao86vXLP6erdzkk3cpNqHaK/ksr0QPy4p8bcZOeJf+aTEfT1H1zBDoFzDZTnw/abaLE0zGYOWbacaDS4uUQmUZ4EfCdLBx4wdFLm42+QCcg8/vvdLnppjSn4w5zwCd9faC7V/5H8JICG74N7iYx7r9g9yOQu0KLYWcbShQvBjGzuh1BECrgWq9q1ElMZjfWHWTZQNs+B/xMDsS9BNOmgCrUOu7rxsKIjQB1uq21zZYYnL4/GOFZOM7x/Zbc0EHzT2q2LyyZH4b5RtgPO45cdAsb040d+Q93x8bs5JvWhiIJ40DWXsvd58aFtfmFI6A2H5qqXsDtPXquVumoj893Gd4gcJ8+KHH5zTIgEzbsYHO/FHtrB+LGTBxjwsKITIqePHA5CA+DRxeztvkp0pD1xMnciYXpEdjCUD5MDyoZS3dtEPjmUrVJOevrQPE9rNYbc76ZjVqHb6wnSwGSpTZZwdF1TcIQRu4qweS1DlSbuQFSbsShKtnGQVnS0ypy+h3ENFUtI9/EN7+g4l6odnyZ9OxFcdd3x+ySSlnOSv5AwU+B5Z6ahuDrFX2JSc5CClkCmcjlJcTq5RGBU/m0ABjKsHbYeL8GmQrzeW2YvIzm7XZpVhjGUDWaNUEIgnxDlCSLJrOpO0SfnG/rjToigdImY88T19imegZNSx1uTwdl+hgWLlPBlr2iP6i2FYYzpDOC7cB/2JbAyU3BfdlB9BV0mtScfWavg3nbMUmwI8a3jDiclD7I1LqfeGw5Pp4hR//k8GtpM
 OeDduA5o
 6hSe180/9K4aAJVxC0nYJbeg2OH/xHIQmL/cve0p9oIokNlZaaX2Mzna0YR3eYBHqP9pAuDEZrOCjBYnyDzayY37sVgbYoCc9TZP/dIPE6xExhuiUzeyx6z6tnG00pNe/Y0ypzEQefHP69u4qqemwLQGXtF3tVBX5g45fHxFqS4h28mn4XUcK2tthiyxyZUmRGwGy3xkgs7SVLN/wceqQGUHJL9Ba4R5+zKKJLxhuaB6VCPa2AlchU5/AoLI72IJ7o4mI6z9zbmRj4tF8qt2IvcU0NW5m6yDxOmy9puxyrvor4cyqxCsJ3i89SUEklYXtKx2VLrrspgX9bjOUE+W+oLJ/pjfdL+enBIqfAWKvA//JHLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/4 02:25, Garg, Shivank wrote:
> 
> 
> On 12/2/2025 10:20 AM, Lance Yang wrote:
>>
>>
>> On 2025/12/2 02:56, Shivank Garg wrote:
>>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>>> text sections), the pages may still be dirty from recent writes.
>>> collapse_file() will trigger async writeback and fail with
>>> SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).
>>>
>>> MADV_COLLAPSE is a synchronous operation where userspace expects
>>> immediate results. If the collapse fails due to dirty pages, perform
>>> synchronous writeback on the specific range and retry once.
>>>
>>> This avoids spurious failures for freshly written executables while
>>> avoiding unnecessary synchronous I/O for mappings that are already clean.
>>>
>>> Reported-by: Branden Moore <Branden.Moore@amd.com>
>>> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
>>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>    mm/khugepaged.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 41 insertions(+)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 219dfa2e523c..7a12e9ef30b4 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -22,6 +22,7 @@
>>>    #include <linux/dax.h>
>>>    #include <linux/ksm.h>
>>>    #include <linux/pgalloc.h>
>>> +#include <linux/backing-dev.h>
>>>      #include <asm/tlb.h>
>>>    #include "internal.h"
>>> @@ -2787,9 +2788,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>        hend = end & HPAGE_PMD_MASK;
>>>          for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>> +        bool retried = false;
>>>            int result = SCAN_FAIL;
>>>              if (!mmap_locked) {
>>> +retry:
>>>                cond_resched();
>>>                mmap_read_lock(mm);
>>>                mmap_locked = true;
>>> @@ -2819,6 +2822,44 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>            if (!mmap_locked)
>>>                *lock_dropped = true;
>>>    +        /*
>>> +         * If the file-backed VMA has dirty pages, the scan triggers
>>> +         * async writeback and returns SCAN_PAGE_DIRTY_OR_WRITEBACK.
>>> +         * Since MADV_COLLAPSE is sync, we force sync writeback and
>>> +         * retry once.
>>> +         */
>>> +        if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !retried) {
>>> +            /*
>>> +             * File scan drops the lock. We must re-acquire it to
>>> +             * safely inspect the VMA and hold the file reference.
>>> +             */
>>> +            if (!mmap_locked) {
>>> +                cond_resched();
>>> +                mmap_read_lock(mm);
>>> +                mmap_locked = true;
>>> +                result = hugepage_vma_revalidate(mm, addr, false, &vma, cc);
>>> +                if (result != SCAN_SUCCEED)
>>> +                    goto handle_result;
>>> +            }
>>> +
>>> +            if (!vma_is_anonymous(vma) && vma->vm_file &&
>>> +                mapping_can_writeback(vma->vm_file->f_mapping)) {
>>> +                struct file *file = get_file(vma->vm_file);
>>> +                pgoff_t pgoff = linear_page_index(vma, addr);
>>> +                loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>>> +                loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>>> +
>>> +                mmap_read_unlock(mm);
>>> +                mmap_locked = false;
>>> +                *lock_dropped = true;
>>> +                filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>>> +                fput(file);
>>> +                retried = true;
>>> +                goto retry;
>>> +            }
>>> +        }
>>> +
>>> +
>>
>> Nit: spurious blank line.
> 
> Ah, I completely missed this. I’ll fix it in the next version.
> Hope the rest of the patch looks reasonable. Thanks for the review.

Apart from that nit, nothing else jumped out at me :)

Confirmed that the spurious EINVAL is gone, and it works as expected ;p

Tested-by: Lance Yang <lance.yang@linux.dev>

[...]

Cheers,
Lance

