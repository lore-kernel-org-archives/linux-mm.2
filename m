Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F4BEE63F14
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 20:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C6B6B0092; Sun, 15 Feb 2026 15:29:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7A06B00A9; Sun, 15 Feb 2026 15:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D3B6B00AB; Sun, 15 Feb 2026 15:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 307646B0092
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 15:29:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5096F1B4F29
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:29:46 +0000 (UTC)
X-FDA: 84447831972.01.1557298
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F6E480004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:29:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="UzEOkK3/";
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771187384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpCYDdCiDeg+luhgldp27Z2qAd8kF5mmiEZcYj/iMpI=;
	b=F/lth0H+sAb90Jsi70JD8M0B1e0B6nPJX3nPri7PjxGlvtQwgexEvtV+v1oJUB9s0UaM2a
	57BBBCCKiWg0ALYjZ/Wmm0OxpaSBcprtlj4qXqpwjkd/JCRJmw4qdlJH+TJW/cb1OpOFPu
	eYtc56x2bFRfW9TCvvb858tX6bMMFWM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="UzEOkK3/";
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771187384; a=rsa-sha256;
	cv=pass;
	b=WArUwKEwgBIxstTwER5UVk/TdAwKfs532CTNes4MbXR8mKE9keYte7DPwrwQLZZ18drWd8
	YWCUi21kpGiKsFigvhOLqoTq5zCgqUpNLM9WCqaK1JIDYB5PI/QpI8oGXqsQTplWLGeY/7
	Q03JmeM0ce47Fi7yuAjsqgEgBX8XmPQ=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cb40030be5so277342185a.3
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 12:29:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771187383; cv=none;
        d=google.com; s=arc-20240605;
        b=LL00XvB7ulCLG6LzWSSPu6xcbpS3F6FYf97tzB31UcH2VYRA2wlQWCFReo/zQaKuW+
         0VUAoGitM4zVfc7aqOs+oNptkcXEDU9rs88Qh0P/hjOm9QLprud1xjYutR3hJVZfQaoi
         UhmMXpgfRs1OAGkvzUbkGeqY792vrBr48M+itzu57rA3MDj3WloDHJCfa0eKgacHCdw6
         Vm4FEQCPGdAfpgR++DVFClieMMhlQe5n1bY2qZ4JT3yD6fsa5d3za2fVkuEiUIYA/ERU
         3JqYYi1JD5CLAFlpDTmLxRbUv6D1mfpmXs3QPF1D5lmTW7E+IFQc4toEuiz8diABXN9d
         aaIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZpCYDdCiDeg+luhgldp27Z2qAd8kF5mmiEZcYj/iMpI=;
        fh=naoEtIkhygEly7ljUM4s3SJE75D/O+6Mi/a7ixhmMvs=;
        b=Qx94GMvSfGh7E/DfZf5JkmDfYEao1yyr7o1QuiyrYVPT2svQGXDfIrT7ZLVyxExpYw
         4OiyfY+P6YoU0hdEkVM0iWkbUt4tkOYhHmR9jI4fUYG42Ndr50oBN9asTFe8hVwerqgV
         igLcPidxAegg7xyT2rMP46If1LSxVlEh4XZtLYjqs9VDrodu7Pe55ObxOyGIAXBr7AeN
         4lpHzwlYZ/LBD1uLgj9VOtu9WTOHDCAxRLHSGUte20OPYVgtQhniXuD369CVD/NkiGYN
         7wUkXB2DFeWj+NDgVA4Gbn/6knXxXzSMzOhIgdQax4eR3hMmv7PVDsp+dA4GXYGITXNp
         Gs7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771187383; x=1771792183; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZpCYDdCiDeg+luhgldp27Z2qAd8kF5mmiEZcYj/iMpI=;
        b=UzEOkK3/iTDSerMHEGi69XTTy5i7Tr9fN3zx8VFPO5lZCTE9eP4tat63bLS6QiFiEQ
         3VRAj7fnGGSim3uVrhaUr/L1Pw7N2w0mno4xyhnbr7NvRGHUye9snp0fWwegG6AOmbui
         dIA6yIMy6nXzoh4qVBuTQEW9T98VlHL+ipCqkCgF8jHuVNksXhXGgx2ZR6G5TE5T0juo
         eY3xTOVSa9gpeUjpI/eoIWzG35uuBFqy3mbY2KguCYCDyLe4SO37Olg9z6hfDUdHD+bg
         FjXwjdaM9AXHatod7Mln3AhZovuPs3L37R7i7fwN0eZvP+Fb8OPw+5HgyEsKzHA3Sd2t
         kLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771187383; x=1771792183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZpCYDdCiDeg+luhgldp27Z2qAd8kF5mmiEZcYj/iMpI=;
        b=clZ7KglHRJDtP5OCI/T+A+jQNG4KWD/ftly///Azv+lw/5kEkvbMGYF+7o48VAmRp6
         SMFWogXUGCvAlSKNJgzRdizW/cykWMOkKTPPFxpHDBE/lVxKGE6jjPrdliWAE9y6scLP
         vNAAT1Y0GJqVpfiAsUySWF7HNQBEUj/Ma24MNJcVFCQN1zOvnPCLdB12TyBAy7AkXUHX
         GpSLCJxmWX2Ad+8xKDqulKcBvQ3OMDIEE2577iW/z85ibFkheDYoD8Qw4Ab6lTN3+qQr
         gwe0jqLPB+/gVqCzcQDCzIIplwW4/FJzrtDcPWUIxhXJGArQEfGFthKdA6S4/Oya0iDF
         YL8A==
X-Forwarded-Encrypted: i=1; AJvYcCUTioh/+8rN0Xmqc9b29PBuUILtl5iHJ8DXJc7v0PuI55lKyZ8+sCcbV0+9D12lWZcI5aAyVczeRw==@kvack.org
X-Gm-Message-State: AOJu0YxREkweDEjT5CBP48KYs7ql4QdmFTsBJX5H8zCBhdTbZ2t7Plfq
	8vkHFhbmGxSP+eNB2d7Nb0Y/gNB7gQ0jGiaOI0kxIQ/dxlySh3tcNBPlT3zGUFppEGfmU2uFXOH
	muOVTigzKJacTRSGcgqP8TPAA29B4/4E=
X-Gm-Gg: AZuq6aI4YhzDOrLNbe/JXlQ535E3P7N8pQgYspDNTR7EBnY6WPVmFv/5rbi7ZrrcOY/
	M/7ZqULfQ9x+7nAgZN7RKpo17Ep+AjrTHUEtUjZbXhHPx9XH6r+jJeJoAAERJVKZ3phMStXw+HU
	E9OTEllm6MYm01wdvFTWT3cyxZHI5Qx3ORDeXln1F4ykrMPWhQ1UveIPBqQQHrrHv85LUN1DM84
	KkqT9eWubgr4BCujTMVYtmoSo7B7aGrpZ6XGUvzav3ivTWTsD692RR/HLT3PU9SfMWZ5P3hbDNU
	wBG5QQ==
X-Received: by 2002:a05:620a:2942:b0:8ca:2cf9:819b with SMTP id
 af79cd13be357-8cb422696a6mr1011942885a.30.1771187383348; Sun, 15 Feb 2026
 12:29:43 -0800 (PST)
MIME-Version: 1.0
References: <20260214001535.435626-1-kartikey406@gmail.com>
In-Reply-To: <20260214001535.435626-1-kartikey406@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 16 Feb 2026 04:29:32 +0800
X-Gm-Features: AaiRm50syQHB3kctGnJnEjyiXqT8j1X7hIANEB9brrbUxqOPyK3vC3uGRbBzxPE
Message-ID: <CAGsJ_4xZd9QCjcJo+j-iWox+O61+MJKui54pqek072LdSnh26w@mail.gmail.com>
Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, i@maskray.me, shy828301@gmail.com, 
	ackerleytng@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F6E480004
X-Stat-Signature: cbohjifyygw5iwbckuuoosr65zizomt8
X-Rspam-User: 
X-HE-Tag: 1771187384-517890
X-HE-Meta: U2FsdGVkX19E0DZ8OfAI32pBG8LVrzi0IfEHUe23mwfunOM0rk1Je55fmH1NANETzaURVeKslobSB7R2ujk2Wj15HPV1lxit4tzON6RNDrTIl7D5q63shYhcTQakpfccpsYmQ5xy4Qbg6d4c2Dc+oo9pwOqBlVDnPuH9t8J2oRhnwVEaZv+Z/liC/Xf6PEd/uVCZJ+wrDLkeIcMjopn09KfqYJtL/7w/q25gyVJl4130KHtul/n22XypdFGuCwdN+NdDCawxT+Hsf8hFPhw4TjZUEAVWSHf9dxIIUDz+AIiFD0Man1e+kme6Jg0zc4RKGjKX7anm5iy9OOPeP996rXasSOqy+OajpPz+lSZkTSd573Fd9UABKhzoF/WvbOBbDKsV+EDWFUL6z1KHZdlINlwAwAYrp8Y6DQo0uBzHGYXOB12IYBGL2nZJ5R2k193x3frgAeS7xL4688VSxi9iS2DM2BYpMMaPnJcPBCbpHrKu8NwBABTLf7EXj/emZFfwop5PtA5rrwkY1pAID7ZKjAhfWKorKG9QtVgAJORftKvB4y9f1B4Ryz9cO7660PnVue4YiX7iagmAghk3QvrAQd+43rkJZ3TmAwv+IdInaL5VHzJbmiZgT+ZuTBTqQnMGy4TO7Q8G3SzGK+xiicMOdZg0SsTUxnf6/nDQAzCVW7EShiwt6phS2rTh8aHYlY2faQHlcgs5AYZ9VlOLiJ/7S9FQz/65rgVPYCvJEH3sSYZHLXujX86YQnMnWEc6+0D19n0A2WiLtbCAoMoKD603bftNPphVHXaDH2M0B+DoxaDUZWQeN79LPiG3Hz7l04Z6O47rvvgwezwtLlE9e2dkP0Lf0ZCDSP90RC0U8yA3G3HAryWyPO34dlEyqg6Wk+ZMurRJ8MSKaxiJuieb7nq4Cgu9ehd9t4BGeI2hQrodJ7FBxPHv+egNM4i8lAFkih8gsd8co/5WW5ZDkL0V0ZV
 pop2ccbK
 nPI8G8+vAImdyDOKnDQDLFzaVupxSzeZmQxRHdIhQ8QH2LCQ/4qKGYZ3pHDCHRVjKp+yFzcrNfauZY3jn5eoypqMKZz9HHmbNeTH6o5KH+ZOMw4Si7iRYOiHk2rgVUeOpRoe5M/LGh7fYIXXB3nSP9CW0mdTEEcL8/kBnm3Aml4jkSd9c/5ecTIdgg4QHccikZ+tWXrNtPR0aAkBPeLxoI+zD4edZbvmRtQOvntfFpo+uNsVp1VJn9ldNIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 14, 2026 at 8:15=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> file_thp_enabled() incorrectly allows THP for files on anonymous inodes
> (e.g. guest_memfd and secretmem). These files are created via
> alloc_file_pseudo(), which does not call get_write_access() and leaves
> inode->i_writecount at 0. Combined with S_ISREG(inode->i_mode) being
> true, they appear as read-only regular files when
> CONFIG_READ_ONLY_THP_FOR_FS is enabled, making them eligible for THP
> collapse.
>
> Anonymous inodes can never pass the inode_is_open_for_write() check
> since their i_writecount is never incremented through the normal VFS
> open path. The right thing to do is to exclude them from THP eligibility
> altogether, since CONFIG_READ_ONLY_THP_FOR_FS was designed for real
> filesystem files (e.g. shared libraries), not for pseudo-filesystem
> inodes.
>
> For guest_memfd, this allows khugepaged and MADV_COLLAPSE to create
> large folios in the page cache via the collapse path, but the
> guest_memfd fault handler does not support large folios. This triggers
> WARN_ON_ONCE(folio_test_large(folio)) in kvm_gmem_fault_user_mapping().
>
> For secretmem, collapse_file() tries to copy page contents through the
> direct map, but secretmem pages are removed from the direct map. This
> can result in a kernel crash:
>
>     BUG: unable to handle page fault for address: ffff88810284d000
>     RIP: 0010:memcpy_orig+0x16/0x130
>     Call Trace:
>      collapse_file
>      hpage_collapse_scan_file
>      madvise_collapse
>
> Secretmem is not affected by the crash on upstream as the memory failure
> recovery handles the failed copy gracefully, but it still triggers
> confusing false memory failure reports:
>
>     Memory failure: 0x106d96f: recovery action for clean unevictable
>     LRU page: Recovered
>
> Check IS_ANON_FILE(inode) in file_thp_enabled() to deny THP for all
> anonymous inode files.
>
> Link: https://syzkaller.appspot.com/bug?extid=3D33a04338019ac7e43a44
> Link: https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=3DU6rs=
6S7iP0gkR9enr7HoGtA@mail.gmail.com
> Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D33a04338019ac7e43a44
> Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility"=
)
> Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

