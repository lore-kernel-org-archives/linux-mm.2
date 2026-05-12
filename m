Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470F1CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01B56B0088; Tue, 12 May 2026 10:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB39F6B008C; Tue, 12 May 2026 10:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFEF6B0093; Tue, 12 May 2026 10:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92EBC6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:09:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57A071204EA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:09:10 +0000 (UTC)
X-FDA: 84758949660.03.99AA073
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 670F6C000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:09:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VkZe/WFS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778594948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiNvetKVqJBLAfDVDwx6SRce5PAVNg3vvNyEVG9o/Iw=;
	b=0zXnf7Phb5a6Lxfwp7rc2XJuCQE8jHmIzME3msinEfbZ59rfXwgum3bRjqaXAcb0suUWUL
	CcROPjX2U68LX8Xf4CU4WBx++3WMpqPy99L/q+ww1h+k9uyd8uNOqVGkgmYxDopTrHUlQl
	Od+7varjfLlTVfVRiVz9Jv85EyJCiwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778594948; a=rsa-sha256;
	cv=none;
	b=0hvT+eOfLoZYvJGQxxLh8pmnah2bOeNbxIpIv9IBEUAxewhV3mwEAkkV3/IFlTGDnHAw7R
	uVWtajud+IZWYOgpOcrNtkf4flvP26vGmXEauBfG7380Vz+r9xm1u4b7GaLEj+pZFfkj3G
	96lT7boLAZIVPPm4txATIouuGXLrFjk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VkZe/WFS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76FF241937;
	Tue, 12 May 2026 14:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F79C2BCB0;
	Tue, 12 May 2026 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778594947;
	bh=M6X22T2O9RgYZBI/BkEj/v2QLQi0oYq5BYAoCkvxfuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkZe/WFSuj2qphIdEos+JKuocohvTsGiCAtNapnNm/aM0jFSc777+gDrDZV553DQ2
	 fIJjRYQVKFnKJ1Q5TEhtK6aysXdSRNU3OxXhGA9omEu+KbBRKX6fYeg7q3hgnEnGBq
	 gR4Dcf+YG/86EYn6GCQ6lxpFKjbMfxCo5fmq7QH4vn3x1TiD/7OiIIRNChkQCuAlNq
	 UEIhpfMVmUNy7yHfY8B8TO7bg8XA9hOh7gudXJCGxWgQT5DqpgL2GW/MPqB70+nRL5
	 miwmpdKHWHQJGVQ4ZMw0gTSdm9vX+iWdID4XuYTpDC6I0ybKFcvKZ+xY/xdiX3JioH
	 0ibk0HktNvOYQ==
From: SeongJae Park <sj@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	sunnanyong@huawei.com
Subject: Re: [PATCH] mm/damon/vaddr: attempt per-vma lock during page table walk
Date: Tue, 12 May 2026 07:08:52 -0700
Message-ID: <20260512140854.111278-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <618380f2-ea7b-4855-9dc5-d655dc30d5a7@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 670F6C000E
X-Rspamd-Server: rspam04
X-Stat-Signature: tb9ygogsuqwmpd7h1d9igq5nnes6rerk
X-HE-Tag: 1778594948-558973
X-HE-Meta: U2FsdGVkX1/CdupChh/GluOhOhXn0cuHXTEQyGVPKQLkkg0KBThXy4zeJJW8IPNnM4tVkwGAOyC5b+S7feqtuTLd9jui3ICG4t+fkiPuJRLbu3IyPC2loKorjwg/yIg+TEqdMPRFQf1edHpnxmpbGmuiWZLPX05Eo59K7S0Q1JfBMXX6J5om/YH5CE8MRljFGVnRRYfMqeneA4oph8Rt8jyY2tjjv0x7TDoM/FSNdovjhMsAh36NgGz4YdPIwHMu9FtKNFKUcWBP8eib9ENVb9/o9Fm4fgLPDe1TdUwhaV6FQgV8Ms5meHalclkjTr6q8Dpel7mAl35b3ibgR7X8uuHiTJ9lUtJo6qM6I5l1UTJUH7l/TTInAEwZnyAqm7LsSTqSNVso0gKgVlqUINH8X7verZySvPYphsh163eqpLTkh/6mGXGw7zzKoj4uQbvIWHikDzNSSWHw3jHJ9f0TOU5uq2ZGOEA8wRd8mN8Ga1S3sWWrQfrZx4xeypGXbWFCw61cwKdHi2KpZmxYV3V5zUQeEslNiLB8DXfFfWk57F0aooJPb78v48QRyF4GXqSU2L8A06FcOc7bCVEPE4TJl7Fk42kEgzWXPlOF3K62kScLxzn4hsx4gJO+Y0hkbEvF66PcscmerCEYXnBHwSMBx48aryGx0yBgZJXT8tQWBE+FzhgG6GJ7mfI8iLJmbLPId6qLDFZw+iFV9w8AnDjKPyMs2lBtkgbmydbyzdmQcuYGuU4mmAsVnBTTzk/poGf8yMyWORWhV34SFY7IPipUx3raoKW99g9osZNrlwFA8TsdVvGHgN9EAtFbsVoG//4QVv2f1657zl+dZoTPrn9cmtMcBVkrThRWpPM0bIQG2a2sAddbYbQ4EJAEZ/P2IKJlNb6nkX+Rnq4Mn+kOEmGL+X/27vHA07NULInKWTTRdXLwLeMBKbS9ZM6pT4p4Tjn8NbYZ3ciEq1S6K5UUWuT
 vJ5lsW8X
 P650aeMiG9cmPJCFSsKq83u0vEBJW1dkWIJ9SAt/P0l/6Zf7NhIHtrJV+Zn0XpwrxIEqFDCJvu6ZC+6UPiWiLBgglWlWBweARkyRI5PXoLLcbCZnQuEtYYLooH90adgegQwj/qYX7WsI8mt4hA2XNzWfUm+D1J8s0/Ax6s0xf5Th9aP1QCsjQmVjmQFYUC3edTIPBM6DZtdi9Jv0QzSLl/dBi4xfC54CsmdXvhpR+8Jbp0yT6w1wd59kP9GDY1ll0DaqZaOgWrmHGmOw9a7jaf9Nkox14NGHlrGArIAv4IcHuJo12TMZyBgvh6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 21:59:26 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> 
> 
> On 5/12/2026 9:31 AM, SeongJae Park wrote:
> > On Mon, 11 May 2026 21:25:46 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> > 
> >> Currently, DAMON virtual address operations use mmap_read_lock
> >> during page table walks, which can cause unnecessary contention
> >> under high concurrency.
> >>
> >> Introduce damon_va_walk_page_range() to first attempt acquiring a
> >> per-vma lock. If the VMA is found and the range is fully contained
> >> within it, the page table walk proceeds with the per-vma lock
> >> instead of mmap_read_lock.
> >>
> >> This optimization is particularly effective for damon_va_young()
> >> and damon_va_mkold(), which are frequently called and typically
> >> operate within a single VMA.
> > 
> > Makes sense.  Do you have some measurements?
> 
> In fact, I do not have performance-related tests.
> 
> > 
> >>
> >> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> > 
> > Looks good to me.  Nonetheless, because I'm not familiar with per-vma locking,
> > I'd like to wait for Sashiko review.
> > 
> 
> Sashiko review reports a issue about handling VMAs with the VM_PFNMAP
> flag inconsistently[1]，

For other readers who may want to read the Sashiko review and might want to
commeent, it is also available [1] at lore.

> We indeed do not need to handle the vma of
> VM_PFNMAP for damon, so a quick fix is as follows,
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index eed2ae132a58..d27147603564 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -251,8 +251,11 @@ static void damon_va_walk_page_range(struct 
> mm_struct *mm, unsigned long start,
>                  goto lock_mmap;
>          }
> 
> -       ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
> -       walk_page_range_vma(vma, start, end, ops, private);
> +       if (!(vma->vm_flags & VM_PFNMAP)) {
> +               ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
> +               walk_page_range_vma(vma, start, end, ops, private);
> +       }
> +
>          vma_end_read(vma);
>          return;
> 
> Any more comments?

Looks good to me, thank you!  Could you send v2 with this change?

> 
> Thanks.
> 
> [1] 
> https://sashiko.dev/#/patchset/20260511132546.1973270-1-wangkefeng.wang@huawei.com?part=1

[1] https://lore.kernel.org/20260512052628.83798C2BCC7@smtp.kernel.org


Thanks,
SJ

[...]

