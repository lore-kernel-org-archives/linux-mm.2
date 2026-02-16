Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDCCBE63F2F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 06:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22BA6B0005; Mon, 16 Feb 2026 01:47:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA1B6B0088; Mon, 16 Feb 2026 01:47:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26B76B0089; Mon, 16 Feb 2026 01:47:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACFE56B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 01:47:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46D5D160CBD
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:47:21 +0000 (UTC)
X-FDA: 84449388282.25.FC7F0F3
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 57BB34000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:47:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pR2ja0U9;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771224439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gf2jwk1RVqzQzmvAhQgxYmUaIaH7H8vlbZYE4E+t8HE=;
	b=ulbssx4GiDIB/CcKQbY1Rv2EK35HETB6NTHhYvkZg+IWMbcpHUZfovfUvQSICEYapiENfr
	OL3ZZQ5FeC8vwNpbcoqIS/uLAsxqOEX5pk5L5raC8Z49OYyYLFf5JaeRbppHUOlSwO5Kuu
	3zejCzexKFnkgrL6ZtnInngRcLwpVDA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pR2ja0U9;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771224439; a=rsa-sha256;
	cv=pass;
	b=gBxl0xUutpWybS0megdzhVd2k8DiDuzQd0Vlds6yBGCQKwfJdR8fZmErk1+cWyl4VSFIuU
	pI4CXPu4luqezdriVOVGxK/3zRUF0RMOTLw0+3Z6SDPLl8QDC6+K/5lb3NpSW5c0f4Wq7v
	4U2/oVMITcDGwmgv4FB3EXJQaiKFrzQ=
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-948aec218a2so625199241.0
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 22:47:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771224438; cv=none;
        d=google.com; s=arc-20240605;
        b=If86FgpkncDEPuFocK1vCuUthXdKX2Uur0TqP5cYEo9zS7Fh7Ap/gv7vDLhFG0Zbs6
         1QNkkikCm2y9f2MgY1KpfBGSJCYlVkNQU+2XWptyCcLGKocoBLdKcjgJgcHT1PuXnJzk
         yi49hg8+I7sHCThOpWfFmXg2AjXpMiTJsE5Yv0yE0o3f4k9EviCHPmxOtvav8W57YQ3m
         NL92yrzeI2g4kuZRUNUuGPUJ45ZOKdjvFEFmFKM97Fo7SLtd2J3hmqWg8ZvKVIfSfzRk
         LqRnDuduGfaQNlTAKWvw86SgQcp61A0+LkYwbDnU323XLKkMK2DmFdlGUL3Hisao0rj7
         iHpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=gf2jwk1RVqzQzmvAhQgxYmUaIaH7H8vlbZYE4E+t8HE=;
        fh=/3JVvVfRBCn5p4R9KfR11UUe+bEVNckqN8d1CsV4dAs=;
        b=KQuwEQpxjiLRMlIvV0jtlEmTfpsfxtyuhsfOV12/2QD6jALD4yIjF6F40z+sSIzezT
         /Vw6xuPb+CRXG7VGZfJIUZMuPH1wNVKGIIJLMG1mPjrLW8A2HdOC0EnVqUXB2mFsy31a
         iYvapYfGJJOf8tf4RxfjwguoRe34CotYqGB9f82pa33dD+WoJG5adNr26esoAq0AImxo
         dMv5i1rAALuXYdNk1IiHR55zYi3itmiiAYptYwOUe3o4Z5Qm5N///nuPzFqlK8/xj9nT
         8VPgH+LLKX8lXjZwZQaWgaRV/ka325qX/q7clweyZSX5jDZrcIRwj5JfF7ClXOc019v/
         K8Rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771224438; x=1771829238; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=gf2jwk1RVqzQzmvAhQgxYmUaIaH7H8vlbZYE4E+t8HE=;
        b=pR2ja0U9WtffR3cC/vrtiOUXSwPGNjOpZKpZ1Onybtlddz/HVyDFmn0M53MUWwDDEZ
         h6dYbJARrRb/OnbDszBgX+1hTtZxcZkZ1rAxVFlsEBZ2dUBId5EUya8UGDaKAKK28Bp+
         4+GDNOQsTk9Vcp7/oc0sYEABhU3RWtFRBlF38+hM8aKeYBf8cYpyc+LAv9hSg5e89KUG
         bKyTNOi9b4s8/kWn0Mh6Gy1zKO2KQEjtClKh4gzEu6M4GhAtvkvus7rdl+24zagv+vGv
         pmwQcDbk8Hpl3tt4PtHD6pBFgKIXzDKIqXuscgGFf034SJSoDZyiNVWLEF5o+xPvJnHu
         K3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771224438; x=1771829238;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gf2jwk1RVqzQzmvAhQgxYmUaIaH7H8vlbZYE4E+t8HE=;
        b=Rj6Orjh0Qf2Ufuicdjbz3leq4PqCZHOfs2/oY4U2n6WcRpwpjsadyF3pc1OvQsLyHo
         4sTV5TM17Wz4aOxod4moE7AIsar5C76EoD+gC6gKs/+knHEnmOSjOWEYDh4LDkun920B
         kGdJRJeM8D+HNyVyMRU5DO0Of4tBenZw34zHBqm07W5sKgiKBV28gvw2mZP4+mxVDgQF
         pTTd2dUWX3vBqnsqXOys/7LmT2JfymDAtQ4Y0s8EXsnVjh3O95avuRM7XlUhbCL74/Kc
         XAecPCnpx5S6fNxwuRt10MJaOtVqg9ycK7MzXc0kZMi4M4ITU6HEbYoTkFBL1pZ3WH+S
         pdtg==
X-Gm-Message-State: AOJu0Yzg27x5eR9v3lICmYPAiuQL0s8eBdOpvF0XcHu9rUO2Gs/pWcxA
	emvsxMsrCbgarP4+ODamUMAK0rEe8fIyrmem042+2G1KlEGwV+UbPmEpJC41gR0lIUK//9jnl3g
	PRSNXwynb16RUypr2BcSzR4uWzRvXefD0Eim7sifC
X-Gm-Gg: AZuq6aIicBCLPPJznOCgoz/uWoJEphN2gc+qTuSZsr5DqFzuDbjB1LLgil8wBlQl4zH
	O+wOsCGNQ8eSuuLS107CHpWYgL1iQDhq9xbsFMuJAWMqjhn+Z/KKY27iNwB07id+nfZkG10qqey
	OvbYUa9HrgGXweEbB8sa8NqNYKqyF3bgwSj/adDrI6J0vvaBl29Nsl8i9cBosrac7dXHZyPR9sA
	cWNyFYQMD7zHSSsNDODtlkddfAkgx5sd1yxVaoIlApXWPKtpX84k3zvB7apZEK8zIPAzxTaogiz
	qMuCt1U11+dl5qjKBwib2dT9YGY1IvYBL6+zwRPm8A==
X-Received: by 2002:a05:6102:3f41:b0:5f5:7791:c2cb with SMTP id
 ada2fe7eead31-5fe1b02b8d5mr3315567137.41.1771224437883; Sun, 15 Feb 2026
 22:47:17 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 15 Feb 2026 22:47:17 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 15 Feb 2026 22:47:17 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260214001535.435626-1-kartikey406@gmail.com>
References: <20260214001535.435626-1-kartikey406@gmail.com>
MIME-Version: 1.0
Date: Sun, 15 Feb 2026 22:47:17 -0800
X-Gm-Features: AaiRm52DUXynYKBSitVD7cd8pczBxhWkZgpMdc34qfLZh8F1_KvF_BSdCWVeDL4
Message-ID: <CAEvNRgE+BuLzJbF=yBvCn9D8PLsWcgq1F+KwP2QotTqC8YLo-g@mail.gmail.com>
Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, i@maskray.me, 
	shy828301@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 57BB34000A
X-Stat-Signature: 3np4si949cgs5whnx1zqepsnwyz6u1nd
X-Rspam-User: 
X-HE-Tag: 1771224439-708382
X-HE-Meta: U2FsdGVkX19DoEFzDxnY5quh0voW4I2uuiKxJRVY9IQ4mS4Bprrm+GhB63xoa/LsHjIP3sFkXwSTFO+A+oH0BKkY0stHat9XWP5cqP/3Et7tzf9gnq356tg3mrMIjCYu5UcDOS+zZ4EsvfJv3T0Zd4PW2wDbcISLSkkkEy9XjZwsZfwwyGrIENHisNp9boZUhcdBzfdA2m2ChlYLqiRAkK7KvkJ5xaLGZmHNhzYM1fDIQph4yGYNo/potvXapN4/fnMTUMsb3hWztJXAqTZnUhBjpD3v0QYw0CcjVw9tuC+5zWJUzQ6xyZdDqdS/ek1XwVp39o2F/NeWcwnddjVf9XeqtplYWHQkoT4wJ7ChFCA9BGL4ZcBp620kXpzqJN7AWuQbttivq64hcFlTfc6gWk0ObTpVCCblf8WZDebj3BIP4mruCydr8TJgO+eEK3Q/Zlq3WOhG0nDh/aTr+IuXrauyU8dc7UCzPwWMhK0fVJrIi6TrrUIxsdr0Q9AM6nNDduad5QJWRgIrT6vLmSNbrvg5iWZ89UYwJPunCthq8O9jZZag8L46tH7McIOnVZ8p0FZltWtinvSgryLnGt29mYHfH+1Q/hGz6lh+dDo9efv4Fn8V7m/rSR7ZwVreU6Paec1nkn56JhIACDkDHEwMYKq614UcAjWMZ1MMFTv9XdwSYRR7f8SzFgGNxEflIFahIol/Pz3oS8baPOcXBLiCoPKt6ptj2yqe86R+IhOxw1V50sbvqb6Sj/wPTXURyyuVcw2oF2SuGmyg20DSPJxD1b3r4cmweQaIZ8F0VXWSV73dknOXW32DVmr8S5syuiQqZOElgKKpA5ROM9Lh4FeUZ6k38VeiEniiclsU01fdhk+01Yo3are3il1RX2PWnlEAuuVJlpm+fYixvALTkxThqyfwQnzqjSYFvO2QCI55XcgKWmNMRbgvD5C1xjlpN23RnZZWOMR/gIJI89xlLM1
 vUneczkf
 60S4d5DGcYyujmVlVthH1iHH3kzYszqB/5KrsBa4Kn9IhNDMs1hZJsycHGuW1m3oymF/hcc6pEonUbKnT27uHOxXp0FhqbHY8ltaa66dt3ZwJLG3jIzF/wJfrUKfDvzLf6g0RQU/89e+gVQuhg+grItCMiaka6kY7mehXRU3/vlePukIgjmiQYCzT0HMcLuiVHpNQ67jue5JfjNLjXlE3Vk6t/T7qwZ+h6VXxSnqRjsOIicbCfavq5YNdYmpATXtBZZ7ncxNg7aGZ/m9uMEZAXLKbkk2v73L5NeWdnkgZqd9/SfteCpzbWYxRmZ+DWuPwaM2XtB7bLvJpRwsJWHK2lELu8RGI5P40/SvHcUSsH2hZPy4F3MuAg0adoqxsZZTMr/YgDOUR+Wcpr2M+bwJrLQNn0jTWz3D2dHUzD2QarYwoFe7T4hYKJOyMfiloPg4lA7tn2blWh56hj2bci/xpQJk9JzTtX/aC7zrFvE/zXkCiyluBV4r996KpwtN963crahuq7fTJ7TjpM+fMGlz2zzRAFn9+ZX/cdn9BfvHqb8Nertc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deepanshu Kartikey <kartikey406@gmail.com> writes:

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

I couldn't reproduce this crash, I could only reproduce the false memory
failure report below.

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
> Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
> Link: https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com
> Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
> Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
> Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> ---
> v2:
>   - Use IS_ANON_FILE(inode) to deny THP for all anonymous inode files
>     instead of checking for specific subsystems (David Hildenbrand)
>   - Updated Fixes tag to 7fbb5e188248 which removed the VM_EXEC
>     requirement that accidentally protected secretmem
>   - Expanded commit message with implications for both guest_memfd
>     and secretmem
> ---
>  mm/huge_memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..d3beddd8cc30 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -94,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>
>  	inode = file_inode(vma->vm_file);
>
> +	if (IS_ANON_FILE(inode))
> +		return false;
> +

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>  }
>
> --
> 2.43.0

