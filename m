Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E95606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i2PmmhXt
Received: by kanga.kvack.org (Postfix)
	id CD6956B05B0; Sat, 14 Nov 2026 12:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE7D6B05B3; Sat, 14 Nov 2026 12:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBA46B05B4; Sat, 14 Nov 2026 12:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4566B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:51:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 362E4A7F82
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:51:11 +0000 (UTC)
X-FDA: 85434465942.18.ADEA370
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 91155120004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:51:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2PmmhXt;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794678669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31CSDRSd9baKd2bGsu5D8xrY334D4K/9sxfZ6xr0ASE=;
	b=0rYere7gvTa9EQyhY39NM2nGJhVXEVgeNypHBNUZC+VOjsHZI5BbgTunS/NsPME8LW6RTG
	lMfU9jvw9k3ObecOl+UgFoZSYlq2srphJhv8FBAm/EX1ZUrzEJD1d0IfS+OCeLsgcwLDPc
	7TqJYdbwmwYhXNTPaUEtjsl36mSA56g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794678669;
	b=8dQURp2Vi+cqeJq02efxC+cPfAXgvvhWgj1yggYP1g6n3DoTu7pLAk+d09LN5PES6NsRJH
	Wl33DqDKkWh7JgSYta0ymYLcwTs6imVMKkcl42ot1vkrIwYJ9UEd4O0XACFY1f5seuIYmZ
	twAq9FxwhtZyTrXqCdrOsqBVQbQLijA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2PmmhXt;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B42E34347F;
	Sat, 14 Nov 2026 17:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679C41F000C4;
	Sat, 14 Nov 2026 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794678668;
	bh=31CSDRSd9baKd2bGsu5D8xrY334D4K/9sxfZ6xr0ASE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i2PmmhXtLZqgFobKfTDiwgEfdPGeKoNV3+kRwSM+k0mMbWoeKq+G3ubuPoOjWR8Jo
	 IHC+qZpEUbJrqpZroF9IfOY1kPquXjJ6GTLoDB3uTz3jWA6/dV5DuPMAJ13f+QdFhz
	 MnFPPbXZNTj1ZN6C6bnEU9A8hMyHrfSKGP0oEyX/rSkTqjIw0srx9mrLhvDeaJBmjc
	 gbDCGxJmVqee/dgUJg7jz1rSFNarqyLL4U/WOlAzUJVpdor3XqSjshZs/5H3SDkIsT
	 wvQotMzDJxv6piPJjdT8fGu0WQ3a3qz4xplA/QaNB6Nk22d+q0/8RjxCZIKzJyh7bT
	 NBnsWycSJ5dsw==
Date: Sat, 14 Nov 2026 17:51:02 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate: fix softlockup in do_pages_move() with
 huge page arrays
Message-ID: <avifKRgR0Q4WPUNR@gremlin>
References: <20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn>
X-Stat-Signature: nn8jbjyu3feqokc4dg1kqgcj565rrjjd
X-Rspamd-Queue-Id: 91155120004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794678669-819961
X-HE-Meta: U2FsdGVkX1/wTHYH8AH5Gu1nddgws2tAZyKgImpCNOo3jZgKuEV2uTJwS7EtEEmWUSL1mgxa6S6fjswU9UnwHw++bzz+EnZEhf6Qq30LJPQ06bYZAXi215Z7aKSz75LGR9MEWlHdGkJfgjQljcJit42S7poGHe+hzJycXW/e7cT1Ox1fOWiXNQSPRjhG0YcTw1rRZcLJM0CR4Mwt6BhbCUkqePDVXLta/f3+Te3UbUICzLoTBJoICTHbl1CcE1i+1K2fkozTv1QWeunhgwBc8857mRr20AtinyZKjWb8sBEt0Et6G8nHrzKjimewZSmhIGXQKmLFQEaJaqcFBRYA83gs74OOqL2zIHh/pguk05m1ZGnoSnhLQHPqz07pV+dkUYIdjMrfef2fwk4Ds3JrqVYtQBjVRFQOvCR44+rsHts/Z4QR6Kmt6TRiBVxI3z7OmdFYH22wnIRf+bjJYDcJQoShnXlkt+cuEYEVXbvbCInlh/3jp+mEuI8pmyZ+7OqhOwVJ2n1NNdwP+PIeXYgiFiSZTq4ZzxvpyvrqdXcGjeet+zDg12jICVNs2jaXX34Npcdx6oHCiogbsXrCL4hBpOI5s0MLBe/H4IobuOx7V1Z/9g77n8gWzsE3y1eDLgPdhvw5ZfF5dgGAOL9cGbH9PN5VHo4fwwBGN534fOKU0YVJS9Y8OnacWP+xXwlqEjHs0ngb1O4/E4mma2dwtCBMakik8YH+9m9ANgmvkxTv4g/w6dG9hdeyH3V9k7O/O0fQIQb7zTWxjRdnCraunFzxF//AWWdXJB3SFFlO3VAsKxiTENnKxSj/gcAVY12l1ju1NdcA0vgNuL0wR52A3gVoILtG8cpbltUUGGVnoNcSdO95IsA+1sfsfTnxGnl9XAA5huoovuBkHEw3idauWrjeKVJy/uXpqe6tBElqFBpmoDlnHWdswuhjpp/qayV7mC7adREVdflqwWSjr0CG4qq
 LGunXv1d
 bCBQHqBJhm6jp+AV/tqY6hVsbwa5hPaZ3iJ2LpX4wVgPJLhkBE4zio2qoDSBYx1TMqn0JSSce2doV2ZHfRiy0H72H9Kan/KXiaiHe0d4VfWVbScNtuUqkADg5PkWI7nSLI83XUu/MnSiy2ZjQV5IWF3rZawbm8+5BTzZELwa94Srshe3dejcix5PHXTS86eJQaPrOFm2w8plwTmh6rQNzd3PldlIG5OmrP1w9d5qPvrZnQ1T1z8L2KuFBCwC3gUt3HPFjbWF1RYZU/oju2NYMtUw45vXhWXcW0Uwrd02wGPG4o1pWE/DoJlGFq95dbnFO4I2c1satI/EBKIMknnYC1/gb4n9An+Kj/v9Ah3HhDb8jqf2p9alhsx3cLZTCxrWtYm7TuT3ZxLMEgyYXClkbRhIue2k9ZHxiHerXNiXWATnHZX82d/DSvLOyMuUvJFqO0j/xo18v4y4V8lU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 02:28:31PM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/migrate: fix softlockup in do_pages_move() with huge page arrays
>
> do_pages_move() walks the array one page at a time.  An entry naming the
> node its page is already on is never queued, so the loop runs without a
> voluntary preemption point on a non-preemptible kernel; the existing
> cond_resched() calls in the migration code are only reached after a
> folio has been queued.  nr_pages comes straight from the syscall.
>
> A 6.6.60 x86_64 kernel with CONFIG_PREEMPT_NONE=y and CONFIG_NUMA=y
> reproduces this under QEMU TCG: 50 million entries pointing at a page
> already on the target node keep the CPU in do_pages_move() for 42.9 s and
> trip the softlockup watchdog; with this patch the same call completes in
> 44.3 s without a softlockup.
>
> Add cond_resched() so that long calls yield periodically.
> do_pages_stat() had the same problem; it was fixed by 8e934ab44389.  In
> current mainline only alpha, hexagon and classic m68k can select
> PREEMPT_NONE and they cannot enable CONFIG_NUMA, so this mainly targets
> pre-v7.0 stable kernels.
>
> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

NAK.

This person('s script) sent 300 mails in under four weeks spanning: ata,
scsi, target, ufs, nvme/nvmet, ubifs, ublk, zloop, dm, md, mmc, virtio-blk,
mfd, gpio, pwm, spi, PCI, ASoC, ACPI, net, vfs mount, block partitions, and
now mm.

Those patches that I've looked at have actually both been wrong and both
useless.

And absolutely not to this person/script doing backports, thanks.

> ---
> Changes in v2:
>   - describe the reproduction and the code path, as requested by David
>     Hildenbrand; no code change
>   - correct the do_pages_stat() reference (fixed by 8e934ab44389)
> Link: https://lore.kernel.org/all/20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn/
>
>  mm/migrate.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 875079464930..3122ecb85270 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2372,6 +2372,8 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  		const void __user *p;
>  		int node;
>
> +		cond_resched();
> +
>  		err = -EFAULT;
>  		if (in_compat_syscall()) {
>  			compat_uptr_t cp;
>

--
Cheers, Lorenzo

