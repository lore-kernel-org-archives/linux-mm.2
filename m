Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB21FE63F08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 22:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479AA6B008A; Sun, 15 Feb 2026 17:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD466B008C; Sun, 15 Feb 2026 17:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DFFF6B0092; Sun, 15 Feb 2026 17:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9A2C6B008A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 17:48:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7816E1B4EEE
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 22:48:56 +0000 (UTC)
X-FDA: 84448182672.13.54976C9
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 74F71140004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 22:48:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dG2f3zrI;
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771195734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aB7V1WHeYzB7KogdF1kJespp6q092hH6CqwnHTfTF00=;
	b=2U7Nwf6VZpPpvsCKGLZfQJr2VSHkDOk+fwm30TmVJRDnoKrqVW/qoJPMBw6dCznxLtkZXK
	oDKP0/u2f5KM0WkdlfB3fnEhgZcc21Gx8YxaRa5yydziFh9llQ67OeYOFdH6xALh93QMzD
	UqgYy6SWDSC/3pc2rAse+Tv/kUScPUI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dG2f3zrI;
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771195734; a=rsa-sha256;
	cv=pass;
	b=sa0W1q18LJVMVq/j/K3v4xPnCq6eX78Rooor+te2Iq5qe4LPkKXlK5i040tjUmQK/bnbdC
	HSVp6SeDAHBDCsl+p28xqmrYMJyKmCuo7DBfPOP31cXvXg6atxZSG766lOHgsLqRJSYzbM
	pVmXgMLTE4TUEIfrtPX7RA816JIXRak=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5673fd077b4so1168746e0c.0
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 14:48:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771195733; cv=none;
        d=google.com; s=arc-20240605;
        b=crv7eu1w9b1/3nfPggeFrlm0lh7lxSBCv86rB0erfjUVQIFsG2kQ8QMrzlewhrDv1+
         2puh6SdYesGbwOBC3cDVoBADwHz4jiBH8zFlIs4LStILNhulnv/rnlRKbm6/f2cpCL2f
         ng1zc4yhcJb+kPkjQ/dnjQ7FqRjYH/HBIVPS+iKpgEnHyF5do2MCCP3fex8qkxuZxSze
         lVDxuSdEkg5ZPTlBbTXfFb3jVAv6QJz6e7UDtEGyXzVCEVC29KCflFSpT4IqeIP2nfSP
         HtJiT8srOoE3XSON5WNnOL7ETEYZuBBzibTlFfZFAVEVDvQScmnoNNGfXF32iKl5pYFn
         NEKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=aB7V1WHeYzB7KogdF1kJespp6q092hH6CqwnHTfTF00=;
        fh=+EwCZ72Q+CgRN5RBJZrj3/W0LmqeKH6BlKX/g+niQ5I=;
        b=Y0ELNNGUx8AL7XkaQ41ag+J8LBrX13AMIOzGSPdmVZobch4VewTbQnD42IT4DkQrxn
         UToz3TQBAeM5qC+8fg+8EAXIKtDLWCap0lWVBzJNJzbS5vc8P4QQkA5LLYypbqowWQQ6
         ZY31m7vE/fuAQ73tDiwrWSkzEEiXithCsgDI6FVIRz6aRi5qLJh+1Bdw63JlLHgJC0VF
         iWu8SpLSmo1V5GHmfSGo9G62pCPedssoUUAOA3FsXbLafxdedXqr7PIf/mZqXF/kFwS7
         bChCK4BwGcxgstzxXr3+lH3fWsZBnlLRJyNEERaXhjli/b5ESVukd6CcNKj7sFoh9GgS
         vyaw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771195733; x=1771800533; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=aB7V1WHeYzB7KogdF1kJespp6q092hH6CqwnHTfTF00=;
        b=dG2f3zrIcYC0ulgMXTuSsTIZkVUdMHoFmmFBiHpA0L5thl83aPLEYTxiX+OP3ck2WC
         zcV+ycm7gCBz+8tgA5pYbZLKSOtJ8bERIwmFjylQSF4eemZ93OrfnGQPST+/PyMVcWP9
         nw9IyzV8gNgKpj2YUxSqoF+0DxpG3XhyoUXZ5yHxedXlheGld31EqQ1D/87tr8jhSBA/
         u8iUTtQh3g9t36+GBaRN5FviY0ru02nGYTNg53mPJoFL6eq5szN0wIAFqo5O9zncBRlq
         PKASnA4clJYhA/fEVGq8IC360gYemAW1TQ/ViSNfIDOnNY34+gJMBBClM8UvR/X+mSkD
         g/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771195733; x=1771800533;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aB7V1WHeYzB7KogdF1kJespp6q092hH6CqwnHTfTF00=;
        b=v6jv/36jjk5+d8Qyb2vV+OT5kEZaRIV11N3RVc0YV2UJOrel810AOfuuhMYw/VuW9L
         kuqgrSbfAg14pPV2RtIb0oQ9mtloQssSa8JVohiYS18DJXKQ83lzR6DLfMgrNiF14lgl
         Mv//tkTAOLvmig++5WQz8DedxidNjjOgcFVHeLBVa/iXMryfptsr/LlZagZ1KsdRe2/L
         UfyX5urXVd2fTKr44dJvTZ2iK+r1nGAP/+ti9rV+KaaC9uPfuW3+lnnQ+VKmHtJDVBOP
         1xWOXOFGz70G+7SrTX3uw6Fq8uiMam/DqMyI3vQbZfRrzane3R/Dpq2Mh8kt9DTEgnEs
         QocA==
X-Forwarded-Encrypted: i=1; AJvYcCXMNPdPnKDJSvNOJPScYnKAmNgdAG/MgU6lrFqDX0uouQ1WLRmBuHFIQ6qqm8jXvsSo30kA9KnF9g==@kvack.org
X-Gm-Message-State: AOJu0YykI1ZB1JXzltxrrKJ/AhegBjwBbdGKN6mtfgs1iP+yhIMOA9kA
	hYEOdJdcwxlWaJY+E9CyeGpXvBTYt/803hlM3EOK+vXR510QDmApkWjlwVCwWRDdBGfpNtNMlgU
	uU64UDZHWjvn2qnyDBZl5+kIVIwgmm5dmEb55E33p
X-Gm-Gg: AZuq6aK4VYgM6oJX/3QlefS+rPT51M2P8/gXfG+KwH84QPYsyIi/qzWGjnpfwvLkltG
	M7D/p4AWL1OXVwL3V4kSeZPMvyf+SdOxaihrAHkXP4O0C5cafdRS5jgny8tBf7hys93OmWWQKto
	zHLg0aGCyZJqwf6pR22cMq7zOu13w5YQXnxrewLKkU17SfgN6mVfM8mg7JpZtIStita3tFc9CDc
	iI+/fdR3XCDX/h86Ryqtx3NbA8n+Vby12yK6YX3CDINV8tWionW6G+K9qBoZuRZUafDmN396Rep
	2VVgE9Yyu65Bv+dCMIzPvkcQuYO8kTByFcpfulI+8w==
X-Received: by 2002:a05:6122:d92:b0:563:7d93:b135 with SMTP id
 71dfb90a1353d-56768179fb7mr2621169e0c.2.1771195732879; Sun, 15 Feb 2026
 14:48:52 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 15 Feb 2026 14:48:51 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 15 Feb 2026 14:48:51 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <b398d163-7b58-402b-a37d-9562d658a62d@linux.dev>
References: <20260214001535.435626-1-kartikey406@gmail.com> <b398d163-7b58-402b-a37d-9562d658a62d@linux.dev>
MIME-Version: 1.0
Date: Sun, 15 Feb 2026 14:48:51 -0800
X-Gm-Features: AaiRm52UXXicsi141L_UNf5JmMFNKNoMBVCTGWwMUSkJ1ZSHoalesk6JUL2jVjU
Message-ID: <CAEvNRgGLAnZkfPZt32-wyCaefu-tvG9WcX3zq1Xe7fsTabZqmA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
To: Lance Yang <lance.yang@linux.dev>, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	linux-mm@kvack.org, npache@redhat.com, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, ryan.roberts@arm.com, 
	stable@vger.kernel.org, ziy@nvidia.com, dev.jain@arm.com, i@maskray.me, 
	baohua@kernel.org, shy828301@gmail.com, akpm@linux-foundation.org, 
	david@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: euxxpii1wu3xou9jdjxxggjjkh18egyk
X-Rspam-User: 
X-Rspamd-Queue-Id: 74F71140004
X-HE-Tag: 1771195734-209346
X-HE-Meta: U2FsdGVkX1/fvrCetLMQCu9EUTrVKeF0DA8de0aTDFuuZSIrptchYJv63XfrEIzn+beoRmbLI1oZvvHqdXngOwdrbjx+2AHYcMDrWL69z/mjGQXnc0otq8k+xIfCfGIp/INm4cNCzZjsLEHs8XHGM7QSxu29TxsYbGyJBvnmZLS/lScgjD5oLLhDuEAYAc3lSnDQCnEILxULS63VDyLSERLyUXZPvUN9p+/cOvp82E1wfKxqHGpH1hv7bBjaZnphhRVr0kLSQwMAtx46wgSd0sr2OjPxDQ7XDMGMAENds+YuSuw92D5ta0s1VL+cfmEhk7nesWck1iJArRjN05mRcY5+slVu+NZVr5fYHwrunf2OEXWc7WpD8zCF6mjwkduDYSD0Ts93U7bLRzkyFLdeMcuJeVUF1o9ZfXCBp1KnsAV0t1giGjrToL9JtvYlZMZ/HZhxkbCTZkhteHVj1VfJ2cGCAwKuXU+Z/N8sA8vGail2hKyxKM/NMdaYlVu61Cfsve4h0fh5KiI84dGxpwzXaJ1ywtTq1keDT6VAl6zgJPoVQIWpUTOPfwQVlDwwdGSNlZR6JGHhqDi73xbTZ3vd+UYwEs4vYC7vMdljEtBK1xXUKWVw1SPhHolwHCFDCAaZmewGt0MQtNH/CbYzN2rPCqAr3U3h6KiKcUw/vTu6+lIadE3EyhEOcN3n2aMDDmGUZSIgTfThFD9NsT2gnrlnxM7dbJ8pxn3Kvl170O8rK8oIl6QJva2YLgXen0WKG1LnVEB8+b6V6MuwGuudUFP+jOKh2gH9DnA5vFhLlb+LAyqu6DrUya/SAsxyYoCZd0rmgyO4Vz/0rGzb95XhS7Fz6dW/ziBlUuBLsZUwkJyi544uW1t0iM0qy9V9JN9A2aYTI4FoXKtih0smkxT89m4lzICoxPmYopnTkkdK+lqcjeEIg6FtAZHBW6wr1YIFbgp/xv3j7hviudVsjrrY95c
 S2Q3tWCe
 LvIPcOwsZW5bcnLzHrDvkZTfz2HDLOe06Z/1VJIG6rKjYJSJoQ3zbhGpDafF6OX5DOEw4zwWWqKX9sBP4smzf31mmP6igsVGtc3rpn2PEEk1dPHX8lmOLiD57LEMkB640A7RcaYf3E0MG7FkiLocJJWjb1RCQZ/9dC9WcAv55bXYghBVs8WPk4Cq0O97IIro35+eiBbIme+EwD6Y35/wGtJFujw09S3tHTpJH3xwMjUBhUiZIlr4hS7pzCMkTFD68QN1DjMDEQIPM5Vb0TV2SKh73DjV+8ZpuAEsmcWkWGjTn8dZH1GkWTX+vS9D+bTpUYR50CiAwn+CjHq8PXlgOjuT0gI54CZ2TMqSekKXm1Y3x0UJjYPnoPy/Q2hQjwNXoP7pC7A0H/asEc+GY1N9KkgGO/gAGmQuQsLzZHLtkeshmYhuosN1DtmENp6McN174wJhEzAW2Rkk2a3HhwHPpbZmSrdyfnWFVBpkw8ChAuivaJhPpbHPkk//m6eZT2Do8UnrVYT0VcGTb98UAjffhwvStZ1RoHIkJSQaDcDolzL65rD1aH6wzsqhISw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lance Yang <lance.yang@linux.dev> writes:

> On 2026/2/14 08:15, Deepanshu Kartikey wrote:
>> file_thp_enabled() incorrectly allows THP for files on anonymous inodes
>> (e.g. guest_memfd and secretmem). These files are created via
>> alloc_file_pseudo(), which does not call get_write_access() and leaves
>> inode->i_writecount at 0. Combined with S_ISREG(inode->i_mode) being
>> true, they appear as read-only regular files when
>> CONFIG_READ_ONLY_THP_FOR_FS is enabled, making them eligible for THP
>> collapse.
>>
>> Anonymous inodes can never pass the inode_is_open_for_write() check
>> since their i_writecount is never incremented through the normal VFS
>> open path. The right thing to do is to exclude them from THP eligibility
>> altogether, since CONFIG_READ_ONLY_THP_FOR_FS was designed for real
>> filesystem files (e.g. shared libraries), not for pseudo-filesystem
>> inodes.
>>
>> For guest_memfd, this allows khugepaged and MADV_COLLAPSE to create
>> large folios in the page cache via the collapse path, but the
>> guest_memfd fault handler does not support large folios. This triggers
>> WARN_ON_ONCE(folio_test_large(folio)) in kvm_gmem_fault_user_mapping().
>>
>> For secretmem, collapse_file() tries to copy page contents through the
>> direct map, but secretmem pages are removed from the direct map. This
>> can result in a kernel crash:
>
> Good catch, thanks!
>
> For secretmem, file_thp_enabled() can incorrectly return true
> (i_writecount=0, S_ISREG=1), so the mapping becomes eligible for file
> THP collapse ...
>
> However, if any folio is dirty, collapse bails out early with
> SCAN_PAGE_DIRTY_OR_WRITEBACK, as secretmem doesn't support normal
> writeback, IIUC.
>

Yup! In the reproducers [1] I had to try to avoid setting the dirty flag
on the pages.

[1] https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com

>>
>>      BUG: unable to handle page fault for address: ffff88810284d000
>>      RIP: 0010:memcpy_orig+0x16/0x130
>>      Call Trace:
>>       collapse_file
>>       hpage_collapse_scan_file
>>       madvise_collapse
>>
>> Secretmem is not affected by the crash on upstream as the memory failure
>> recovery handles the failed copy gracefully, but it still triggers
>> confusing false memory failure reports:
>>
>>      Memory failure: 0x106d96f: recovery action for clean unevictable
>>      LRU page: Recovered
>
> Right. On my setup, that would hit SCAN_COPY_MC in
> hpage_collapse_scan_file()
> rather than a hard crash.
>

Deepanshu, were you able to trigger a hard crash on some earlier kernel?
I only saw this false memory failure log.

>>
>> Check IS_ANON_FILE(inode) in file_thp_enabled() to deny THP for all
>> anonymous inode files.
>>
>> Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
>> Link: https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com
>> Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
>> Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
>> Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
>> ---
>
> Confirmed that file_thp_enabled() is working as expected now with this fix.
>
> Tested-by: Lance Yang <lance.yang@linux.dev>
>
>
> Cheers,
> Lance

