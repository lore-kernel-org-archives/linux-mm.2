Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E97C61DD6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 00:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6CB6B008A; Sat, 29 Aug 2026 20:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6C56B008C; Sat, 29 Aug 2026 20:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCFB6B0092; Sat, 29 Aug 2026 20:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 289946B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:42:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93F6816020C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:42:53 +0000 (UTC)
X-FDA: 85156085826.29.14349A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id ECE4C4000A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:42:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zxNO408o;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788050572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maR1l87kHhHusUVm0LI9qVbcTjv61h6QEJDc+PMNXcY=;
	b=I3gh9AAA4z6n00Eq9E+qh2OnOjwlWhRHfJdjBSilaGGWS4QDPwg1oZRZUCjT06dUVJHjvV
	gtpDVE5Cc8jOnPB1F+zDfBxYlDzS7h+MNj3RVUebbZy7btK5XWJDLi79w/ZxnOdMYh3AKt
	lSt7kYrnmMoeGO/ItkHLep0zAccHjrU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zxNO408o;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788050572;
	b=H1PaoP8wGVReS84zUZLWZilgaKDEXJjVqXnU7N373KTYCINtPkFLzbpqMEzyiDC0R3J2fJ
	8F4Zn94E5xgtq6pzfUG5Ixnnqtp5Kf55gkIh6R5QyiRc2SyFqovqO/0hFiaxmlyRfTc57N
	PZdrm4qDuXiIOCDFznhzDr6ockBl2+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60DF9600AE;
	Sun, 30 Aug 2026 00:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A761F000E9;
	Sun, 30 Aug 2026 00:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788050571;
	bh=maR1l87kHhHusUVm0LI9qVbcTjv61h6QEJDc+PMNXcY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zxNO408oaOfEa8+UlW7umi3SreTJuVDWLj6UFBsCNWwGdbpZhuSRvgyyldQeQ+0Rb
	 6TeRd8ozQpqOQE+nnwCwpTvODnmhRnJ2IWuc3U99L0+C3Yhh/OSlgetDVrDGnSpVPg
	 U/GW3MPU1iMX8N392ZtuwFT9JX5Yfu6XP73VTNmU=
Date: Sat, 29 Aug 2026 17:42:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu
 <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed
 <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] mm, swap: don't spin on a bad swap entry
Message-Id: <20260829174249.d723a5f0c29b9eee8d59826b@linux-foundation.org>
In-Reply-To: <20260818-swap-v3-0-d3fa52598a59@debian.org>
References: <20260818-swap-v3-0-d3fa52598a59@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ioas8icx38et766z14zemfrcxdzkexuq
X-Rspamd-Queue-Id: ECE4C4000A
X-HE-Tag: 1788050571-826008
X-HE-Meta: U2FsdGVkX1/z1DQCIaT3ExsI5XKS/6VGnoizoKolAsGLEsNZoDL2n3F8SPa+FDOVCdpYnCOASThGnBPbIvff/S0emR9PE0bmP9WQvvx5QoTtQUwBC+o4rhUJPXrC/afkM2G1hY5uGrQRvJJxM6o0pF0j77jZxEOfjC7PXDt+jqOtcFaJAeDhdlwC8PWVIPFkt105SC2X3ydnSszWOYM889dhBC9b5gtvOvM/Kv2aNb9iYFQQCLXmCmsxBLJ9WevIV5aWdg0D7iwd+kGaJC32PRr9itA9DEtBSdx1iumVfBDrtVhsNK4bIMC1sJDNK+hDGqO/srKeC/88nfbmfSKXul+KHb6D2EysPgbBCiZfmjp+FA+JdfzbpgHYGDq68x7fuqM0/a+zmcZ6RC+MCObMbkqPDgWasOoAwGjRHIGYarlcVHDEWVWWBG9+m8G1CAynS6ats1She+iPiiWfRawppmpRU6daK/o6H3+s/wOHtSMO99aJTy3HmJhgLLfYSXEghfnHt4P7nNG0UPahyBETb+wQcEC925ImI22DJ2ltIm5kle5lYqP6A1RK0Cc82Z0HHTK1EHBTI7MJe1U8VThsiDgqEqL/ePNRy6+scsgdGcKMM2tSGlp+tXuC2Na+m9ekyXlzC8zNOn3lr0YMjTG3C2Ui5nJ5X+bnIvrn+xaCAEhJV0DAP2wp8qS8cdt0RMHoaAa4QUQtpgzU47B8HER6YgEIv56UMgADym6PSL1py7lVgqW6a5yIq5ibG9PYVBx5ojgr2SRBsvgQyPE3TK6OBevJACwTZV3Wk4R85eXIjFmEHj7hubVxbl9l6Et/wDlkdCVi4axhRaLJDPH0ixDXECdTLaOeckxtmyTGZee3I7vh15Aru3uLe3Uv9aLhGZFxxt3U4DXgACnMDpTRTZKIFZcPXids7jP3EvMKGcBwOtK5PfquE4Ps9TFoyObCp9Uu8H1KzqkHJSFNzsmIcW3
 bUosjVlB
 /zkhDPak8tf0RWxXDrUFEB8YUl48YOda4dwqYPj59Xr68tRA/ewxBRtJRioO70PPMy6DdMGPiXrJ+XiliHjTM3ITWgjXSBC9fLadRcuc1PIZEapdKy7bH4spqiAOWBRqMUrKRVT7fb7eaGLIA7ieflExJHCZWQ/JtNZnj+bQn0vpN0cXmUK/3SKy0rg6yuNjo7DmKZy3NrXru0+87e6WFGIs059wgkq03tQXX/sQlz2kA4qqA1/0oERgxrvoD+UVIpAdIrQGFBmBfsmM2T5zhiA0ahyGcbzfGd82Btx6qpdrSVdIo489Wuq1luJtNXFXisKmom0GJzbWjyt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 03:06:22 -0700 Breno Leitao <leitao@debian.org> wrote:

> I've seen some machines at Meta fleet that show the following type of
> problem:
> 
> 1) It gets some weird warning:
> 
>   BUG: Bad page map in process khugepaged  pte:f000eef300000017 pmd:00000067
>   addr:00007f57c0a01000 vm_flags:20200073 anon_vma:ffff88829af7c340 mapping:0000000000000000 index:7f57c0a01
> 
> The corruption is most likely the collapse/PT_RECLAIM race fixed by
> commit 366a4532d96f ("mm: fix the race between collapse and PT_RECLAIM
> under per-vma lock"). But this series is not about this one.
> 
> 2) Then the fault never makes progress. do_swap_page() returns 0 when
>    get_swap_device() fails, so the fault is retried, reads the same
>    entry and faults again. Nothing in the round trip changes the PTE,
>    and the same line comes out on every pass:
> 
>   get_swap_device: Bad swap offset entry 3ffffffc043c5
> 
> Patch 1 makes get_swap_device() return ERR_PTR(-EIO) for a malformed
> entry, keeping NULL for a device swapoff is taking away, and converts
> the callers. No functional change expected.
> 
> Patch 2 uses that to return VM_FAULT_SIGBUS instead of retrying.
> 
> The rate limiting patch that used to open this series was split out and
> posted on its own as a backportable hotfix [1], per Andrew's request. It
> should land first: patch 1 here touches the lines next to it in
> get_swap_device(). This patch will probably conflict with [1], but the
> merge should be trivial, given the only change in [1] is the
> addition of the __ratelimited() suffix. 
> 
> 	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> 

Thanks.  The patches have bitrotted a little - get_swap_device() was an
easy fixup but please double-check that I didn't miss anything.

Or perhaps just refresh-retest-resend if there's any doubt.


> The rate limiting patch that used to open this series was split out and
> posted on its own as a backportable hotfix [1], per Andrew's request. It
> should land first: patch 1 here touches the lines next to it in
> get_swap_device(). This patch will probably conflict with [1], but the
> merge should be trivial, given the only change in [1] is the
> addition of the __ratelimited() suffix. 
> 
> 	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> 		pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);

oh, you already said that.

As usual when inspecting our error-path code, Sashiko said "you all suck":

	https://sashiko.dev/#/patchset/20260818-swap-v3-0-d3fa52598a59@debian.org

These things do seem on-topic for the changes you're proposing here, so
please take a look?

