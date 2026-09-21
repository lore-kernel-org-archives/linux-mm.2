Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1653C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B63DA6B00DB; Mon, 21 Sep 2026 06:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEDEE6B00DF; Mon, 21 Sep 2026 06:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDEA6B00E1; Mon, 21 Sep 2026 06:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76FB16B00DB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:54:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE40E120125
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:54:34 +0000 (UTC)
X-FDA: 85237460868.14.B671847
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A41AA0009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:54:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R5ODJA0g;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rjti9mDz9Knd7equnQAAic7A7rHFx56gyrCpEIe4Ags=;
	b=Mn6g/ou0tDZ0fNgKqoLNcKPSvyOsfNRrhn0dv41XGNB/02b0tQKv1zVp/d+p8RcARxBxua
	CgcIoeGtw/ePptUTw+L3vDmYwpO+el0Ik7kYLtCU7OXv2oDRTfsmLJWdvc7cCjJVw7aY0G
	X6IULdAzNzhEtCLmEXQv9WOVcjpTc3U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R5ODJA0g;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988073;
	b=xSXSOxB96dSUUVXNtisZ6hbbH/eIRx+14YSNbUBKkBQpitavGBEGwidfR4xYuZ3XAp11xR
	X6lMPYq5yB68qc/imm2J4Vh+HlFvgHY0u9D5GaMCamELbHcXFYxLWVjW+mU3TCTFKhzBaR
	3yPSxj9Kh1lQMSjs8YRNCHYtvVrB88s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E9D141FEA;
	Mon, 21 Sep 2026 10:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE461F000FF;
	Mon, 21 Sep 2026 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789988072;
	bh=Rjti9mDz9Knd7equnQAAic7A7rHFx56gyrCpEIe4Ags=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5ODJA0gSYeGpPQO16SPXSwTOZ8tih3UjpLvQQDcsnZDQz0jAUM4saHZmFTyuAfHr
	 vly+FL7XP8n2A54LqdJyLVsIx9WzJuTO0YLEK0YAbcM5AGvGQrTt6BZ/h851aJfqRN
	 CUKSZGZMDZlJRaG46SDcvG/7ERr48jcVDq8PzSa0WUsDy3OLzpSPGpzp3gVIw9t5Gm
	 0xtDRYUjSidbnio8BODSultPs4kBweoUhKKW1zhLz5eL+LI80h69YdkdRUaFgmNP27
	 tmuKmAlLDZv6BPSkkq2obwcJo1SuUOqpSq27Y7QX21+hblbBi1/y66+jlWKqX0E/N4
	 1Ngql7XGRJ6yA==
Date: Mon, 21 Sep 2026 13:54:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] x86/mm/pat: use pr_warn() for early W^X warnings
Message-ID: <arEM4HMrY7BC2ykN@kernel.org>
References: <20260913-fixes-verify-rwx-v3-1-5e1d6a08bd02@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913-fixes-verify-rwx-v3-1-5e1d6a08bd02@kernel.org>
X-Rspam-User: 
X-Stat-Signature: nss1gzzt4arfpyhrie15f59yqbe1ryxd
X-Rspamd-Queue-Id: 3A41AA0009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789988073-504757
X-HE-Meta: U2FsdGVkX1+X4MlXkbBNJp56gvAQ80Xp6vEkoFYuXckMThJ1mbLTnHEM7OJz4NycDsTFWiyGM5ICjFlK0EJIhonVc4Nva09GTzq9awN8ScK8+7mXOzhID75NpM1xksq0hbcUu7jGNCwzEABjwLv4OY/PAEq1GSqppOJ5el9APj7uazvgSiZPU7EV5TlK02ISTN4QPRR3lkHB7wA7TnEhyU6JXXa91DjHNY8kAPsG9qkHrSo+4WfvUswBUhRcLlIpAQiZV3vKJbaieL0h1d3FJ5+11wnzHx/cCpklR2dzMvSDQB5W+tT9W/qKqg5GFWkJAhmnvy/xB7LbdyZUWt3kylWaGl7c+OOiw+PpOszYmOc50PoFkZPLu07dj5Armh3FR7ihqDuOexCP66B7KQi8gTgHO6rfATg1Jkhb8Uatcci1dA5st3/QPHtNGa4QVESKAzBYKSWUQSoecyxKPGCuDC4FGOfhR+rtgSPIkeTsYa+UrEeLbJTUhYyhDOS5wx66Xr/ACUSVC9mqjO5qoAT9BokKmdRa7u5Rp93PdVcXSssktL157NeviaSXzp17T6wEn9UldfCgdlPN5QrcWo4SeNR1mjIdV7mrrCF0Mh+kxTTzMOCSuJ79sWVWG5xIPsjNQ2Dz3DmGkpIFoWdQ5cscha6rHSrJ/9eCwHWH6tIrF6giD4DJvYLRoKzxueebelekhP8MEtezLl02ZfJXFnZh42JP1oRyBlU0ovz4g0jk3INz2nRqzj8YnuP+EQ0LvLnzH9vz7CnpFQU8GyxyevIBqANd3zz0enlGoCXKjEmY5TjNbGLH70iIzoziF0c8CE41ksL1ZqFe0rjmiqJXzpApGMRtupkCk6i4lFJwIb4loykc4H3t8PbKIZLM3g/KetmQC6HSniV4YvkCUHJgtdjQrJjlmxyl51lDBnAzpaLB//au72zIt3obkb7mpEYP1JvnPiu59Gef+3o3pXn7AYD
 ZoFW+H/Q
 dBbzwUiI3kZfTkRksYz6GfyKu7BiOjdVWSo5EM4hX/f8SyFJNJq0gc1pfm8ri2/iJbH8IO+KUw7GFZTqTZ9MYGbumw7PFyUVHmciFNiXl6/JUhmmKaCAxUrqUcp5jasACxzlgbWWlZ6L29aQjVliW5rbbDAW4urSWafFffi1H0UMjAiI2QcQVz6vyPtiexUacNcuDsMx/AXGCaqpIpzze3axtrie+JAx+uynzZN7nDh8cyL0yDCtXgA/Eekqcwtl5jO7RDk+F7RlI23mrpkNEFUo0kBNETr1bk7CMwCextk/pIZ9v4XtDb0Ib1xZjuiH7QhOihYN4GLXQuVTrIscEQ1Pji0DKf+jTFzlgDCYr2p07e9wo62XLfWWVuRLEzECV665gF7Zy7nROYw2ilboOe712YcSfrJcMcQ/0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gentle ping.

On Sun, Sep 13, 2026 at 10:37:27AM +0300, Mike Rapoport (Microsoft) wrote:
> Nathan Chancellor reports the following warning:
> 
>   CPA detected W^X violation: 8000000000000123 -> 0000000000000123 range: 0xffffffffc0400000 - 0xffffffffc0400fff PFN 100e00
>   WARNING: arch/x86/mm/pat/set_memory.c:722 at __change_page_attr_set_clr+0xde7/0x1290, CPU#0: swapper/0/0
>   Modules linked in:
>   CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.3.0-rc1-debug-00006-g453e78594434 #1 PREEMPT(full)  2950d432dd3910251071a66f3134fe0875432786
>   Hardware name: ASUS System Product Name/PRIME Z590M-PLUS, BIOS 1801 12/26/2022
>   RIP: 0010:__change_page_attr_set_clr+0xdff/0x1290
>   Code: 80 7c 24 42 00 0f 85 3a 04 00 00 48 8d 3d 19 8d 79 02 49 89 d9 4c 89 e1 4c 89 d2 4c 89 f6 4d 8d 84 24 ff 0f 00 00 4c 89 14 24 <67> 48 0f b9 3a 4c 8b 14 24 48 8b 0d 81 44 bf 01 41 f6 c2 01
>   RSP: 0000:ffffffff87003c60 EFLAGS: 00010246
>   RAX: 0000000000000002 RBX: 0000000000100e00 RCX: ffffffffc0400000
>   RDX: 0000000000000123 RSI: 8000000000000123 RDI: ffffffff872e50c0
>   RBP: 8000000100e00123 R08: ffffffffc0400fff R09: 0000000000100e00
>   R10: 0000000000000123 R11: 0000000000000001 R12: ffffffffc0400000
>   R13: 0000000100e00123 R14: 8000000000000123 R15: ffffffff87003d58
>   FS:  0000000000000000(0000) GS:ffff8ad1777a7000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: ffff8ad0a4201000 CR3: 00000007e3022001 CR4: 0000000000770ef0
>   PKRU: 55555554
>   Call Trace:
>    <TASK>
>    ? _vm_unmap_aliases+0x219/0x280
>    change_page_attr_set_clr+0x161/0x250
>    ? events_sysfs_show+0x5d/0x80
>    set_memory_x+0x39/0x50
>    apply_retpolines+0x656/0x6d0
>    ? events_sysfs_show+0x5d/0x80
>    ? events_sysfs_show+0x6c/0x80
>    ? events_sysfs_show+0x62/0x80
>    alternative_instructions+0x3c/0xd0
>    arch_cpu_finalize_init+0x130/0x190
>    start_kernel+0x97d/0xa10
>    x86_64_start_reservations+0x24/0x30
>    x86_64_start_kernel+0xda/0xe0
>    common_startup_64+0x13e/0x151
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
> 
> The warning appears because commit 038176c21617f ("x86/mm/pat: fix
> effective RW computation in lookup_address_in_pgd_attr()") fixed the
> effective RW checked by verify_rwx() and it exposed that pages used for ITS
> trampolines temporarily have RWX permissions.
> 
> The permissions are updated in its_fini_core() after all the ITS
> trampolines are generated, but since verify_rwx() detects invalid
> transitions, it warns when its_alloc() makes RW memory executable.
> 
> At the time of alternatives patching the entire kernel text is mapped
> RWX, so the warning is bogus anyway.
> 
> Since the verification of the entire page table with debug_checkwx() has to
> be enabled explicitly in the kernel configuration, retain the warning even
> if it's bogus, but make it scream less loudly: use pr_warn_once() rather
> than WARN_ONCE().
> 
> The warning can be removed once debug_checkwx() becomes unconditional for
> configurations with CONFIG_STRICT_KERNEL_RWX set.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Closes: https://lore.kernel.org/all/20260905044253.GA3816371@ax162
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
> ---
> v3 changes:
> * fix stupid copy-paste error
> 
> v2: https://patch.msgid.link/20260911-fixes-verify-rwx-v2-1-e2cde39b6693@kernel.org
> * Use pr_warn_once() for early violations instad if skipping them entirely
> 
> v1: https://lore.kernel.org/all/20260908092730.4002628-1-rppt@kernel.org/
> ---
>  arch/x86/mm/pat/set_memory.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index b3060000da8d1..a799f539287e2 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -697,6 +697,21 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
>  		return new;
>  
>  	end = start + npg * PAGE_SIZE - 1;
> +
> +	/*
> +	 * If the kernel text is still RWX, gently complain, this could be a
> +	 * false positive.
> +	 * Once debug_checkwx() becomes mandatory for CONFIG_STRICT_KERNEL_RWX,
> +	 * the warning can be removed completely.
> +	 */
> +	if (!kernel_set_to_readonly) {
> +		pr_warn_once("CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
> +		  (unsigned long long)pgprot_val(old),
> +		  (unsigned long long)pgprot_val(new),
> +		  start, end, pfn);
> +		return new;
> +	}
> +
>  	WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
>  		  (unsigned long long)pgprot_val(old),
>  		  (unsigned long long)pgprot_val(new),
> 
> ---
> base-commit: ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482
> change-id: 20260910-fixes-verify-rwx-044841b76a38
> 
> --
> Sincerely yours,
> Mike.
> 

-- 
Sincerely yours,
Mike.

