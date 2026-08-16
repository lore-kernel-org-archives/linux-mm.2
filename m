Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC80C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286D76B0848; Sun, 16 Aug 2026 18:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237436B0849; Sun, 16 Aug 2026 18:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E1B6B084A; Sun, 16 Aug 2026 18:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D65596B0848
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:22:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 641BA1A0630
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:22:57 +0000 (UTC)
X-FDA: 85108558794.29.D27AD3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6DD691C0002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:22:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d06lQOs1;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786918975;
	b=JavON7gNy+WQ/S91/8arUGskzw4qzqxQjSFa7q6IyYh+tIomHarzjCScVXSfc9Q/NwmN5k
	hL8/MUZ0eLIN/anMFJrSGjCh9AlsGAiHWxgTyncRh0+CnEBhbF/zkmszWnU8OWaiHIFLcr
	x612zG76bhemaK3oH3CsGusxREGXPkg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d06lQOs1;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786918975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqaYeTQTC5ytugbqg4tUsIJYjOhw3cwTuTSITG0PXk0=;
	b=g6oQkFXwWIT45LwQTf++C+ZWX7WYwZfSsUsxhfQeyk+LttTl8r+0LwipwQdJlwgjhgCSaw
	r0GtGWLLG3edWQi+NnP1+LPOlqp6OgDfCXdt+Y2xHKMsn9LVDkWzPiBeqLEeOJa6nZ8t7q
	w+qrtcy7HTObPs/6L8W4K9rhoAfT/U8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93C4244035
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7084C1F00ACF
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786918974;
	bh=VqaYeTQTC5ytugbqg4tUsIJYjOhw3cwTuTSITG0PXk0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=d06lQOs1NWQVxTdKBIcxPe8MidOs8aFjdJLrR6zHqPdHwtcPBMOyUUDfQilkvXYDP
	 KM+siIEqi7/mtuIUJIxrRJTPZ3xDy7XaFhTqNjg0rylSg+dD36sL5OQA8FdWl21nhx
	 zvoENgLjk28q+oQ/rDZvJ6IQYoRtCxkl04BtbkPgYa9WXDJDgFFJPVJlV6ukgotgb1
	 Xh2Nwvz39YaYL0JauHufl64Bju4O/vk7TUZMwJqjGVHlVcfvvUxsQLJ5de2J8QVZrx
	 iId6UNz3nPK/0CYjFYJWLQT21c2Z3FPWsxrLGdgZ+q//hPw4SBnw2yRlJNMlhcbvrx
	 eUnbnbpqrzVVA==
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c04bf4711so28344481cf.2
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:22:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrtIE7exyxoFT645xPW6r6lOipV7FqWjgLnA58BgccDZG/Wt9uDk6J1eAtP0kIauyatXFgL7knr8Q==@kvack.org
X-Gm-Message-State: AOJu0YwsWq2hfR/Ntp5Kl+buEhseSBwluDDFl42UedlwJheu1Sq5DWxM
	n2ugOXiiu3POnHIa0CVdr1zgrmswO8ynSyA9aGKuMJCOAhflLOGFZkiVZhaq+L+NYC5o74vgFmo
	mtJEXzWb3JJF4BHlpTRYvXwXuw6yuGlw=
X-Received: by 2002:a05:622a:e155:10b0:52d:911b:1d86 with SMTP id
 d75a77b69052e-52d911b229dmr114912631cf.2.1786918973839; Sun, 16 Aug 2026
 15:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-v2-0-4a625ccabdae@debian.org> <20260813-swap-v2-3-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-3-4a625ccabdae@debian.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 17 Aug 2026 06:22:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y7kQmZpfPQo8n5wRD2syHRj21XPvi6+OjVm_cXbfDLQQ@mail.gmail.com>
X-Gm-Features: AcwNN1VDrUaEv3FHZUzlTFA0cHHZli2D2klQDeH7JQXZWmziZeYdlI2K-jYv3oU
Message-ID: <CAGsJ_4y7kQmZpfPQo8n5wRD2syHRj21XPvi6+OjVm_cXbfDLQQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: fail the fault on a malformed swap entry
 instead of retrying it
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DD691C0002
X-Stat-Signature: oofyzf9qtogo1af1hd4o4ftmg88dbkm9
X-HE-Tag: 1786918975-478711
X-HE-Meta: U2FsdGVkX1+drJOj38QzOXP74uYC1zsn9K5OCvsSX9/jXR7UPaefS8tYCAuyBbdtCCzVcLwOKcyGy5Bi8tkWpF2AJjFsrzgL58Ffo2J0zNwGXIjkWLF6j3NjuBXaCtYrdf3nRGMIswHlG+84OVahbeNUIdZwlzJsqiggDfll6FSwJuhv0oC0YhSCuhTGTTnMy2oRCqfs2z5P/HVxNUnllcSz5ZLe2nWAyf8FyXdJBhZksfRZ/8f9vewcBPx4YGleRbdpKrx8qXT4DEuHZ+Hftet3SVj8E2P101bGQEqWUj11kaR2PffS8k+AxCjKpI5MMpFIbMnOypJN29eoI2mBxXQ2nGCpAVW2pb+qhBYRrZ6flw1NCXJaz8br3cgbri3bPLlrQm2zZ2EoxgliSv6B5VnqwnZRlT581+DZTH69rqE23QQcLz/Vz6CpGp5y8O+eJh0TtaYOt+mOxeUcLGT0Mlr3JTjVSkzjmD0w1SxdXwi3n0pq0B92IEwei2mjjV0a2KcJiajjXR1Y2KmoZ/spK7fAer8RgG0VyT6un0QhgXe5zRsdYpWGfW5ByORMZuxvJ6YP+yHDeBff4i792DBjc7yIRkpjkLYAtawMPOhlq4waOwVUChnZA4stbHf8w9HByyadZ4hXAxeW19Q8CRqpDykcvpvTeOueTbJQC4dVKVt1bAMDAoaxsnRGhK39mP0YiwvYnAXL6yCNMSLUXqy8v6a73H48Tkc1q6+yNaYTUBTx09S3/P6JeuCU2DSaTAbnrVya/OpsyQz6tosSzZCyE0X+RkBDJoi71kLpd2WhzhsTZWMuBK6ptkI2ha8WDJptrwDMK8NUgkMyDc9DcftYNxac0F5Ckh+gKM48POFTDC4mvRQV26OCq3UrGrNftzgAjhQDWjMiJuLtGD9o42LMe9zltRF5ekdliu1E+CKdzCltOI6f3e5qjLNxSQlXlCnmE123Nq2y4GZa/tmKanR
 WRLmUC4l
 Ubn4R7yUq1nsWg50BpqaVhqkZnu3uK6/U6ALMppOfWFVEQSymItGd/hj3VCErjkSwhJhhI8hcfNh0lqTpt3PCUvQUh0d84RbJ7rYVSDfUgjuPNemcLhTknROGjyfAbdyYdqVJP/ylfuqLrZz3EOCLYNJxGrEAMXevbrLf3t/s56AlXO3G5xcIDJK+7hg9DyzvF4CnvivVlEOyZdK6DFseUiuiI5vMDWaA8A2h8k8v1OLAmCzZJWyZrlXVupYhypkOdz/6cdU5QTbS9gz4sNuzfxqedgdj8XVT+pryGjXOo6Rvn8CH531DzWolcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 6:02=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> do_swap_page() returns 0 when get_swap_device() fails, which the fault
> handler reads as "handled". For an entry that can never become valid
> the retry takes the same fault again, so the thread spins forever,
> retrying on the same fault.
>
> Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
> called at get_swap_device()).
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 7201e848129a7..fa2b3d2ad3202 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         /* Prevent swapoff from happening to us, and reject a bad entry. =
*/
>         si =3D get_swap_device(entry);
>         if (IS_ERR_OR_NULL(si)) {
> +               /* A malformed entry never becomes valid, so don't retry =
it. */
> +               if (IS_ERR(si))
> +                       ret =3D VM_FAULT_SIGBUS;


Hi Breno,

Since you now return VM_FAULT_SIGBUS, the page fault should no
longer retry repeatedly. Do we still need patch 1/3, which adds the
rate-limited printk?

Best Regards
Barry

