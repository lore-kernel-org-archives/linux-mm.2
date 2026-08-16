Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DFFC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961196B0363; Sun, 16 Aug 2026 18:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911A96B0364; Sun, 16 Aug 2026 18:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827AD6B0366; Sun, 16 Aug 2026 18:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0646B0363
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:20:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9D8DC05DD
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:20:38 +0000 (UTC)
X-FDA: 85108552956.06.8F2BC1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B47A120003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:20:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvJR8cFU;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786918836;
	b=hE39unNP5AWQbw2MZiOKlEOatDcm8cQhrnKXK4DEZ0zA3oRyNZ1jaXJ8gP8Gd334asjm8Y
	8hF4tYKiJKVkYwHwXGYj0KRXYW/gIxY+wTtzOAWkBEJLhyrwOVsjTU5YpSb6YEq8I+AY9R
	+yXCfi+kondt63vHSy8RcMW9FfR8mxs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvJR8cFU;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786918836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xUi81bvtSC3Z/ViPJCUb65EnnRJWWKtBwMmY39oQuc=;
	b=UgS0RrLMlnYjnEvU/1zBF5PLRSn9IVqWcsXDpk+AN9PADv4lBDJbQtP2O6xFxVM+Jd2uWj
	5VFVm8mEeN1ZjwvA5/kcsxH7XG1AawdN+kQlI2bScg7E2PgVa3SJEVR2ku2a28NFxI8EqH
	eVZK1fMc8TiSRq3WhzzZC9hxelIeH2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E349242B06
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86CC1F00A3D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786918835;
	bh=3xUi81bvtSC3Z/ViPJCUb65EnnRJWWKtBwMmY39oQuc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DvJR8cFU6B8kbdkONg9Joq4/UX3u5bC3nT3NPzJkd07NyOeFRzsEG3Zleo2WGK84X
	 ADK+RleD+XpxkXRWUz3wxi1mz9wO2liwzQz+iX/TRrFT/HLHFPaWBjezcGriJezP5I
	 XNEWb7hrEHcYRjTUP6gCJL+JFTJqoZ48ko9TjA3TsBwL8fz0x0TYFlkvqzWz1GQCun
	 MT/B/T88VxWBAmzd/M4KPvwLM6Sk0ViCzK3GqJEaj8Hlqt/Kte/k44FFKgjYsq90sy
	 m+0s+n0OQvJvMbz8iBkvwfs9TKrCl03j7I4PFf7v7CaHZPI9xl7QJrsRio1WElvSUG
	 Cb28jwJo8Jumg==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso15780206d6.3
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:20:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr3c7eDk6oYv7XYbQUqmJ25AsKkjUdmmjwrq5yFAP/OUq5/LqKvCk9RL6rE5fiCUcKu+LPmFoPmww==@kvack.org
X-Gm-Message-State: AOJu0YyxzBt9fDfQflOl3MjRHFuIAWk+mvnqnY2M0PPblRVKsfJkl++N
	DaeyQz2fo8K4Ja9I0MrSrj0xpN6Pj1NQ8kfymTOvfLNkkB3pASq9CBIqm2oAn9GAEslAYMhtWhj
	JgHbn1yc9WXy+2dmGhycepHrBvdAQegs=
X-Received: by 2002:a05:6214:4808:b0:907:c6bb:5ce4 with SMTP id
 6a1803df08f44-90a91ea5d42mr260324786d6.32.1786918835215; Sun, 16 Aug 2026
 15:20:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-v2-0-4a625ccabdae@debian.org> <20260813-swap-v2-2-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-2-4a625ccabdae@debian.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 17 Aug 2026 06:20:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wHxYvU2j8Jon6yv=7dGhwFEHzvFB+yYFhn_PFSseT2=w@mail.gmail.com>
X-Gm-Features: AcwNN1WqMSxHFh8ZE8N55wDlAF2Pa2NO_LIGyF637iJ2QkoXmYiRMTfMEyVh-Z4
Message-ID: <CAGsJ_4wHxYvU2j8Jon6yv=7dGhwFEHzvFB+yYFhn_PFSseT2=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm, swap: distinguish a malformed swap entry from
 a dying device
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
X-Rspamd-Queue-Id: B47A120003
X-Rspam-User: 
X-Stat-Signature: bwtrdh8bksyp4hd3m53krt46eet4x376
X-Rspamd-Server: rspam06
X-HE-Tag: 1786918836-646067
X-HE-Meta: U2FsdGVkX18DS7ws7Vjki3BeGmACusMUZXbthqgzgRB1wLA7kRaijmAOYHKolXSDlvkVOo6ENFlLB6R73iO/LvMUjU9yWK0l3LBAvOQo5r9eJHqysGB/v2NmhpNMEHd8M2aqfXR+fMaKWdbasMAXsgKiAUHEr+1dfBFh8w7NQMvtgwjvuoCROFEKppdYiOCVeP79oFqDqlJFWeDLQNxoyhLNZJc4Q2v1vGF1Q1tZrWUWuVuhDghlcl50ZhRV1j5EI+ZfF+pfySZdKMd28rwsW9M9f6tXUFsPNnXrKy0x6VdCBf8lk1JO/DUkOx3jpBEHztZGxqYpQ/xXJ8BvGni0Q8Ee6qszDwwTBB6UPzdIZLuy0jBw6E3r/9P23o2edr96MHIc49fT0W9kQmGqv6ox64askqyWS8RyGh5HShOn6ZICIqYovzelBx74RGuRjnU9dmNrrtWstWHoaYwejKP813EdFvqmS7SJFtW6WXsubhbZFstt4FvAtr7g3zagYVGy+pUMOp7okAUvbLrV3Vw5L2b/6JbufJv8RtJbqFh/WmSbucK4hC7nMWLrOFsa8/GYR/o5VqXGmLbDPMRiIgrAM2KrHucdEVaNpg5usro+BXG5je5h3GChEFzflbze5XxN3gSrbLZdzYd/EgrAV0S3pyv2+xd2BxbubUvYOr8tAYbcM07NQUAlH6CXEKXoQHRUrp/sLo9D3oEjyeHDUvreioUkiZ4jBRykMPA7S4bgrkOKCvKUAcVTMxQGQEmsktkAQ9OOeLj6P0pOHlbmecfPjxAbwaE+KBcvBtQ0fdsXPArP8BMowMShX8o0oiQg7kbUy4aD2knovQ5LKeOj/80G/d8rQxfH0PmAMyXPT3vQyGe99dm2086J2kZfPR968AWoY5E5LEZI5PEV0gDfqGk9r9TntFvsv1BNMaszQ5r/3z6XvXUyKPCMxT+dAgKqKPsckotj+cg8EbHvPnO3EwX
 gXDVoK5w
 AfxOPPAcuvX9hPGYixN9zVMrgW2h/FEi9UklIyhwYxblNV3VDrNGor5aT/BjCRXCG46luFiQY0zJYKmm9mj4XG54Z9o6QoEg9DFG7LFOm1UGWo1oV0lSuDDaem12PAMcpiItj73TNW8rmXBmrg9lcHUaGk6Yz+0A42ZXUYQsGOicLUTDMM3RKDb40cJw3dEZcPBIf6X9kn0aLTlSZrmTIwEKHcyBPUUmtgdDAa0YXJC1VWg9oMuVTojQZIr4dIbc3FCPL3aRBYPZ3OBn1AVAPgrKyyUbT2pwKynQo4WTm7wjvk7+uzTcHeegfgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 6:02=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> get_swap_device() returns NULL for two different things: an entry whose
> type names no swap device or whose offset is past the end of one, and a
> device that swapoff is taking away. The first never becomes valid, the
> second does, and callers cannot tell them apart.
>
> Return ERR_PTR(-EIO) for the two malformed cases and keep NULL for
> swapoff. copy_nonpresent_pte() already reports -EIO for the same
> corruption on the fork path.
>
> Callers bail out on failure either way, so switch them to
> IS_ERR_OR_NULL() and clear si where the cleanup path would otherwise
> put an ERR_PTR. No functional change.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
[...]

> @@ -1859,7 +1859,10 @@ void folio_put_swap(struct folio *folio, struct pa=
ge *page)
>   * Check whether swap entry is valid in the swap device.  If so,
>   * return pointer to swap_info_struct, and keep the swap entry valid
>   * via preventing the swap device from being swapoff, until
> - * put_swap_device() is called.  Otherwise return NULL.
> + * put_swap_device() is called.  Return NULL for an empty entry or a
> + * device that is going away, and ERR_PTR(-EIO) if the entry's type
> + * names no swap device or its offset is past the end of one. These EIOs
> + * are preceded by pr_err().
>   *
>   * Notice that swapoff or swapoff+swapon can still happen before the
>   * percpu_ref_tryget_live() in get_swap_device() or after the
> @@ -1900,12 +1903,13 @@ struct swap_info_struct *get_swap_device(swp_entr=
y_t entry)
>         return si;
>  bad_nofile:
>         pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val=
);
> +       return ERR_PTR(-EIO);
>  out:
>         return NULL;
>  put_out:
>         pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.v=
al);
>         percpu_ref_put(&si->users);
> -       return NULL;
> +       return ERR_PTR(-EIO);
>  }

Hi Breno,

Do you know why we=E2=80=99re seeing corrupted PTEs with `bad_nofile`?
Does this issue still exist in mainline?

Thanks
Barry

