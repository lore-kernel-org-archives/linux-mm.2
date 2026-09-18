Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C005C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7186B008A; Fri, 18 Sep 2026 06:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87AB6B008C; Fri, 18 Sep 2026 06:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977EA6B0098; Fri, 18 Sep 2026 06:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDB56B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:28:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEF431A0581
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:57 +0000 (UTC)
X-FDA: 85226509914.02.A4A5ED2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5127020002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kVN2iJOx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789727336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaQy4DHOEvSSGCoiivtyuq63dL3zsfByVWaSOQyZ5SY=;
	b=V61zypRJMytrCEKjD3Q9F1ji+RdXt1HB1hRNM4AOrd5l1binfN9+NUW/Qb5uSds5l0vUg4
	wc5r4F6yBqzDaMnHZOCnLjGK0vQQnz24QfAAJGuA+Niqs8JkQIISMuN5lEChtWuFiQ4Xz3
	DS8ArcJV1Xj1WVirdNUqUTGNpiVh/4k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789727336;
	b=do9myC5rGxn0SE31vKhHeHEG14CJe3GlaPAesxX80UKIPX0J+iL5xXh9gV2ILECXrEk/QG
	/a5OYF3X2C+yII4RLEVC9pV8+HoftoFRwKGFbChK4RuxldCWyUFTLvzoTwiosI7YlF2k08
	AK6vVfeLfkEKmxF3Q0Tryao1LPN1qNs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kVN2iJOx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8980F41A25;
	Fri, 18 Sep 2026 10:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4961F000FF;
	Fri, 18 Sep 2026 10:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727335;
	bh=vaQy4DHOEvSSGCoiivtyuq63dL3zsfByVWaSOQyZ5SY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=kVN2iJOxME0ArWA0m2KaCIhGbR2tof6TagwNQkGM6xUIPfzAqIc2ng14oIs4Kvmha
	 kBLZRQaS6nuqf1BO+ngRdhok+hp2Z+pB4q5M2utrvXenq2UfTN8uYyvCl3RRsL7QGX
	 y5EmdBPEBIpP+cyncEvQGw1h9DQy+kKOTuJbTkhf1zn25bP1cJOK6sOpWx5Q7fbWYP
	 c+uWvewAi3w5WxExbECu3ErP6sGpqbOjyGEBZaWUFFcse1xX7di7MAlXnYmaDi2KRs
	 VXTFTuy89ARbOnA8XN0st0Ndh80FmeKZHQfyceaPFtqKuLrij7O0uhgscIbgv5kMDc
	 /C2nJpnLo2a8Q==
Content-Type: multipart/mixed; boundary="===============5432951590939359719=="
MIME-Version: 1.0
Message-Id: <cbc55fa2453eb1d899a7c594f68dd48bac28253e2cc977d828f8143303848158@mail.kernel.org>
In-Reply-To: <20260918091058.297740-2-tasos.papagiannnis@gmail.com>
References: <20260918091058.297740-2-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v8 1/5] mm: Add copy_remote_mm_str()
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,david@kernel.org,akpm@linux-foundation.org,andrii@kernel.org,ast@kernel.org,brauner@kernel.org,daniel@iogearbox.net,eddyz87@gmail.com,kpsingh@kernel.org,ljs@kernel.org,matt@bobrowski.net,memxor@gmail.com,song@kernel.org,sun.jian.kdev@gmail.com,utilityemal77@gmail.com,viro@zeniv.linux.org.uk,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 18 Sep 2026 10:28:54 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5127020002
X-Stat-Signature: nno1a4eqm5iykykkwdbcpejs7tsk4smd
X-HE-Tag: 1789727336-397811
X-HE-Meta: U2FsdGVkX1/Sj6e8mNhEVdxOyTBbSV8z4RHtViJbnV2cqoe2aJb4vEWyrhtBLN74hPOhM/gvEAlQr+3zyLnErYc+kLAXK/QwQPT+0XG+yrXfNteWTzxsidm38wKnC9B1uGCNdh6QmD8HlJnOwJnbCZtxE1YQe7TsihleUf+iRkXJ8iw/FRe2e3aIPe/x98s+MzW6FipdeJl/cNdcamcYQnnIhz8iP4BZJFpsnCpZd3mWGu8B1T9afhm69F02JnNhUdBHUxA8b8FpPBe78bWQpFNdON4603Ixr7tmpn0zVcCYyBVLck5+iCslFi0cUk3bxfUVY1SoCIYA8thVHtTdciIcvp3xnFsKvj37N7QJbV2kD7Cq13ANUHj9osRqoSNe6+HvlAcUd0waKzl0pfQ+Z2VjUBILPPHqZC3g9ULGNbPAUxGcwvsvLOAOs7H5o6OUuCs2OGxLPNrlLlGvSPhosWrm+lgNpgvrH9qxf7LI8eP2r/pi2Nt87muBehpTiJ68EDGS/7XM76FUH6CGzYVTeDlaaRX5o2KvOtqWXypHgoLVhCtRnYwRvG5M87CeJL7wBvhS7hUBMx4I0YUDptXpudIy5aQO28lo0dWZ4Rfiruzm2tf0fgA9Y2hcMqtleQDUQ/W3xJOdn1KTbSn4kqGnH8KMmor48QKVI99HvwDovzsnOWSrWaqzDhAEzaW3HNMSVRegoph6jkhIv6wFYw9ec9tSLffnIW70G16WJek73oCB5fnpko28yHilAUszc6IZ7b+mBntdWioOBP64EYVfJdSzY9/WluraluKoTmPI6EBhdJa0m0Y6fagPSDvnn4ePavjJPRuylewX0Czcu/N5DihNzLwuMIIcuTW6GmcgKQSkHSyH4p1BogsbjcyEOaOt/0zolqNz8ehNkvVQftf8tOLDVyYryjmrO+jn4uAF74hWz1Sasfc2V3569DVWHkv/iwVlVWR+SNGpLkzCz6G
 gU5c3tyW
 xs9dSXMy2HSYaET9PzReQ2CmSRFBI9h7GHvHic0kl//i8AW62uoEKFBdStbTBPLVpQ8pHrp6GQurKMEDmQkbXDRvO54bH+Gn0nRwB3APe+Bnbn/rc8vYOxiUuhP7yUGF+fcL0OophxlKoEXdjusWnZi78KjDNVC+soqyMiHphRMNhZ9Q9K135m8fT9r0QNlLg9YzDeisieTBdtCbpoS83XGdxgcuqnkfV94+Iapbt3EwtEiE9xEmuxTUmul+JZMc5TlQ8E6oUW46dxW3g15142udBoVlYE2rm6Ba6Zx4J+HmcSpol80qu3ZOuAxzT/RGeujHsG6TUjzsO9YnRX0yDxJPF/TSrqL5FNkC9QwvpEPfw0l2yiNCTP0FjBwt3BUxzGwmjPjDC8z4/qcYApFB0VZnvZ5WvKZ6id4HeZSIwM2nPzdOOFTF3dvswSqcz7gWnKJbAAFLNR5sDtPT8HEZVgNXtyOaUTzhr9x1t3wuOKVPvuFy6s1aoSu3dBsLjcSSJxHa6xIsOh5ms5Jp8B5Q5VaB8KjMN7lTYmRA3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5432951590939359719==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23e..63f40e615754d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h

[ ... ]

> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c94..557b293813557 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -25,6 +25,9 @@
>  struct folio_batch;
>  struct hstate;
>
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			 void *buf, int len, unsigned int gup_flags);
> +

__copy_remote_mm_str() goes from 'static' to an mm-wide helper, but its
'len >= 1' precondition is left undocumented and is now enforced in a
different translation unit from the implementations.

Both implementations begin by writing to the buffer unconditionally,
before any length check:

mm/memory.c:__copy_remote_mm_str() {
    void *old_buf = buf;
    int err = 0;

    if (mmap_read_lock_killable(mm))
	    return -EINTR;

    *(char *)buf = '\0';
    ...
}

mm/nommu.c:__copy_remote_mm_str() {
    unsigned long addr_end;
    struct vm_area_struct *vma;
    int ret = 0;

    if (mmap_read_lock_killable(mm))
	    return -EINTR;

    *(char *)buf = '\0';
    ...
}

Neither ever tests 'len == 0'. The guard lives only in the two wrappers,
in a third file (mm/util.c), so calling __copy_remote_mm_str() with
len == 0 writes one byte past the end of a zero-length buffer.

Before the patch this was structurally impossible: __copy_remote_vm_str()
was 'static' in mm/memory.c and mm/nommu.c and its single caller was the
copy_remote_vm_str() immediately below it in the same file, so the guard
and the unguarded write could not drift apart. Now any file in mm/ that
includes internal.h can call it, and the declaration carries no comment
about the contract.

Should either the 'len must be >= 1' requirement be documented at the
mm/internal.h declaration, or should the 'if (unlikely(len == 0))
return 0;' test be moved into __copy_remote_mm_str() so the guard sits
with the write it protects?


> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3de..fc6933d7e9d36 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c

[ ... ]

> diff --git a/mm/nommu.c b/mm/nommu.c
> index 498e01ee40b05..9a810c35e7e90 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1741,13 +1741,12 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>  }
>  EXPORT_SYMBOL_GPL(access_process_vm);
>
> -#ifdef CONFIG_BPF_SYSCALL
>  /*
>   * Copy a string from another process's address space as given in mm.
>   * If there is any error return -EFAULT.
>   */
> -static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
> -				void *buf, int len)
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			 void *buf, int len, unsigned int gup_flags)
>  {

The NOMMU implementation gains an 'unsigned int gup_flags' parameter that
it never references, and at the same time the patch deletes the only
documentation that said so.

The pre-patch NOMMU kernel-doc read:

 * @gup_flags:  flags modifying lookup behaviour (unused)

The replacement is a single shared kernel-doc in mm/util.c, compiled for
both MMU and NOMMU:

mm/util.c:copy_remote_mm_str():
 * @gup_flags:  flags modifying lookup behaviour

mm/util.c:copy_remote_vm_str():
 * @gup_flags:  flags modifying lookup behaviour

The '(unused)' caveat is gone from both blocks.

The full NOMMU body makes no use of the argument - it goes from
find_vma()/check_add_overflow() to 'ret = strscpy(buf, (char *)addr, len)'
with no reference to gup_flags.

Should the kernel-doc in mm/util.c note that the flags are ignored on
!CONFIG_MMU, or should the '(unused)' comment be restored somewhere in
the NOMMU code itself?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35330379263
--===============5432951590939359719==--

