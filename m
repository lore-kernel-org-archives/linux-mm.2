Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B33C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 14:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8481F6B0098; Sat, 18 Jul 2026 10:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F92F6B0099; Sat, 18 Jul 2026 10:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7266B009D; Sat, 18 Jul 2026 10:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE1D6B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:25:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A37B212047F
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:25:44 +0000 (UTC)
X-FDA: 85002121008.29.76E3D40
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id C24EEC0005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:25:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FTzzrsIv;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of liavalb@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=liavalb@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784384742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HE6cDLPDtoywbshgMgoeTqxrh5vT9sngC3+TU5gPeBc=;
	b=eGph3BF46W4v5v2CXhKxF38kgNXdA6+JC8Rg5FmkkvbB6dcRj4XCqlLu3TjeOzOY6/ef3b
	UFEqtLuR1/nQiIE5m9mdS+XxRBc3u4soScytB7Gjsz6h1bkKbZE8ZxNpTI8tbA6ALUKsiM
	H3VmlI5DmJh9Cv///q4BFn9uzaYM/xo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FTzzrsIv;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of liavalb@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=liavalb@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784384742;
	b=VVKW3TEixvD2OV9OARndm3Ty6UE5kiGo1uKpFH6y8a0jsEqz46ba4GLfZl8LmcwIn/JBMi
	tZBEQeKtyuWU+VNaE8AZq/YEgaEz5OIDZ5mGNfl77Kk7lgJIUu03pf33xtB6WIt5klUv/j
	mHqbXmf6cbSNxbxGx70SDkE4mi40w7k=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8eeb4508f29so89809246d6.0
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 07:25:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784384742; cv=none;
        d=google.com; s=arc-20260327;
        b=K/FnLiOcR0hHIJKTV6Slbz5f4/HHXwFFYenVY0ekZbBXpePTwlcmDn0Cs0DfWmVCVX
         c/XYO4djaYWbM5rI6/41GcQoLeu3yv/Dt8+0RAc9azOubnm7GmVkEJG6FfS137ezTIvv
         7GDkyJ0A2yXSm0pL+lFrFiyZ48PP5rsErMnbVVzbFYYCaaGNkwtT104hB3j+9RILfH4k
         zqYHp74WcJ1s1fLa5xWY7NjjAb9omKZAaQZBgogek1dr74hfaJ/gDhFuzTkzMqObZEb7
         Xjr+U+1yJhnynQYBpfZ0+BcUI4amt3fYuMH1jsoIc1UW6ywDCGew1onOpCfpFw2yfIpW
         2HXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HE6cDLPDtoywbshgMgoeTqxrh5vT9sngC3+TU5gPeBc=;
        fh=wxOVKkXZe3xOWAqVB+JMA+cPOuraD8Kp/lcT1OmBbHY=;
        b=sHL1orpqC/zXCEDnRx02KGle7efnRN2AaALTXIGCWkN0K0VEkSf5CH6UkoTX/GydTf
         P4DpDhEMJ2sSy3a97zUtKotWG1lZZExv0oKN15hwbAHAPMN+lzchny3UDM4904t8uHHC
         YeRAhk4F1IQCC3AWmt2Fg04wDvV9GIIVP7GPWL4YhLPw9VCTT6FuObE9KwJ7SCZxVK0k
         C6+UNmvRj7FIq3gWcfGSlPGPk4x/ZCVsZHukh3pANWfFQQGwSbFmTKRPvLjJw8pHlxDB
         nUA2bCEOyDLxNew99mLBJlVXP+SE3kQh8WOQubvaO9pkMjFvjUeE7mF/Mstd4hrW9+vV
         hu7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784384742; x=1784989542; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HE6cDLPDtoywbshgMgoeTqxrh5vT9sngC3+TU5gPeBc=;
        b=FTzzrsIvBOLtsTwdXRzgIZFXxGd3fh8vwZPjTynoNe4AgJTSFOn3+UshsxwXoLb33J
         QBgfcmc+R/lt4/dWcY4fjrMS06SnYllTb997iIKEXYv2D0pwEjRsz9XTZPXbJ61x/D18
         ehyowVX6SYrlTdZ9Tx/DocjvkhTT+BcaNF/9ZVyDVVGNCTLXUgkXncFXJCSash5B7wkU
         KmCLq28Q7b5votBjZ7YCOPSeMaxaS+E/tMmLkQywAnFnTyV48KJIBJ/0jXTUdjGUWz8f
         Oh5I/b7T8HZ0R9zFm8rWJ8847KWYA/N+HjrHLfTljO1JYMxs+Cs6smkwWmCjqczFl/up
         C/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784384742; x=1784989542;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HE6cDLPDtoywbshgMgoeTqxrh5vT9sngC3+TU5gPeBc=;
        b=kIu7I58x0dD370ytFgpxE6q9b1hANvJAitI1whDQXjGoqfGU0Mqe6dXwAeJNCgaB0L
         m1iKrrDmh2v5+AgXmq2q7m1kH1UcmczFigaIEE/XMJ58nlupJIsvw/43Ym9X448tQ7Pq
         RoEkic9RHYlm/9dG2y8TM0KA5zCjpSikcfQmScDnrorlTkxZyCxONBhPWExptNkEGO1j
         pgPXvjPPtLEWG+oNmJ1hJ3kJtjB24pztnzJsDw/zessxU3UUs3jgdenAWKqdRSu4bVoo
         0Nbva6bV5qb8A3Cs0caerTuTHVB2lR9ccMedJC5Ef+0+Qm2pk7b57eMAkk2T8iHPScLY
         s6Pw==
X-Forwarded-Encrypted: i=1; AHgh+RqNj0DM9LwbbjHwV6ivCMF2U+P/Z7PjgGL60w3abGfZmbZzLnaQn07PJTdZScZ5rBsH1kqtyvqs4w==@kvack.org
X-Gm-Message-State: AOJu0YwnLv341TjoYnCzto62SlwGt6GETGtFRACOUrHcngAf+arP2/Fx
	zK6sIcYESGpJ1cIOau270Ve+wG0gbYpdayn9ZyqGZl7u8KuMtSwIuKgR/F9GRSpMLSFCxI8v0sJ
	7QIUakwZrL78akDwvrBDxRR7opNrp73I=
X-Gm-Gg: AfdE7cljFHZylIhHsuy30H9+IyfsVH8MBgkw2WNB46KFmqBsryP6B6DSI89fTZN51qS
	XIsAindhzCSNsZgpMviCnAriqiAJUv1KusiGZmHqGA5tPQ3SUkFc82C6o4MxyYcnG8FoDYyA70Q
	cQVlOwngeI2ngybiVcB6XDgvvZ14o68y10zfXVQwCICbP92FwIxzIh36ZlpYXL05ueSSIkT6gN2
	kJ2eJro+itR4H4EssHXb7GGeWdVsAAyAXSu8Yx2e4hoorLhd8O9s3VteIIV5hr0Qrqu97+mpa7v
	ixk/dhFmfbILS3gCxLSW
X-Received: by 2002:a05:6214:f2f:b0:8ff:60cd:8174 with SMTP id
 6a1803df08f44-9077854e393mr73119406d6.60.1784384741839; Sat, 18 Jul 2026
 07:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260718123417.16339-1-liavalb@gmail.com> <20260718123417.16339-2-liavalb@gmail.com>
 <aluILz8j8BL3CA7-@lucifer>
In-Reply-To: <aluILz8j8BL3CA7-@lucifer>
From: Liav Albani <liavalb@gmail.com>
Date: Sat, 18 Jul 2026 17:25:30 +0300
X-Gm-Features: AUfX_my17CBv40Ub52HYV7TQ3aC84egMtWtAvd4vK3GQz-2NMS27Dn7Fwu6P40o
Message-ID: <CAA6J81_zxah8dRObOC=xruEL-WyN0Jpk2k0FfGKS99e9WQkLsw@mail.gmail.com>
Subject: Re: [PATCH] mm/vma: fix imbalanced file reference count, properly
 abort mmap_prepare
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000ae184b0656e372d2"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C24EEC0005
X-Stat-Signature: r9db8f7qtmjqg6x5hmm1fh9xc6kdoh9n
X-Rspam-User: 
X-HE-Tag: 1784384742-73748
X-HE-Meta: U2FsdGVkX1980KbzNud4p1T8huN83O2zOUbSo+uYn4ozP8Byyy41olmDucxSN69XSsMDLE5VeQyyBgv81jE8F5d1cPOLPFaEYThYpbngk6Ozec+v+2MPXj5WRLyIB45BYt04Y3D3nGS/KveG2sCyhSUe+hDX6cpRGdXCgubgrwKekjDofSfXd+B8YrSPAnmXG54WjUxU2W9IobDi6xH3UO3NnViIzf5PmP4pqeq+4yxvVtIp549xIxEX3G0JUW0yTGgB5lgiI37dXdGg2QMkfH140L25lELI9NtM5Gzbk+w3/QdXAu4yr21yp5++jiaxikIQQyc/h+Q8M60G8xTJ2s7M0BgL3E8Bn2ZZAuzW/hSFxoRnk6y8Sjq9tHk9ui9ZskFZVzqS/qKXOJt+hz3jLPHubRx/fON+Ph0VpDudx1mDT+xSdOtedq+428QQJLLRfyTv2wLmoHqbYOSisDt9qNJDn9Pr70pJlUrBX1wUHw/Wm2fay5lTME5QBt9KRdSROWklYpMacalv3cGqF32yxcjxnAJidMNfedbjMG6dOhwfJitL8FftYrTHLI9ohXhO+lQwZLJkPAIXC4Gg4Mqkn2pdSjtntdkAXT+e8dIMt6ZA7ErwDr3JfnOcLq0TsFAEgvch28hfru1vWC+MGFQ+lS7ucZkIy5Glp9SEK++Pgk1UQ4SFpeutkaF1ey9zm0VAsnKUauOgfc/TMZT485ij8IkSUbD1r85VPr8Y2AjLYSSAKVdVOissP4eZ6bvwrBmc1rg+Nkfozy4BFbupCnwnQ+lZlQaMaAZ05WzPWT/j/4+NXmfAVs/TPwbZ/5sZBZpaOb79IEexYYQGurxSwxe5x3LIbbyS5IzPujkC/kgq98ZC7YVJX9ZJAz9g7B3DAZ4CbB8AyKh7PBmEQNDy2dc1BL3JA1wwnu6wSP9ed1zX48vHw1U6+mvF2ILfvoYmmCcdKcE/g+6Y4tgvyn6JPBg
 GYCFtpp+
 P13zMtuJQln0gQnVyZdAScFXwtyBRYSyNymHDflPwUTbcvcuTeXSPeKFOwZ21GlftbVtut9oqYY37IyFVsHmDW7gXZwmw0uZP0KN64V7DbBhp3/Bb1s/oL749F6ZHSkwe/PEJ7GzR1mSgrgbJe0pFkZjp1hFywCQ7PZFqCrYG3EFvGaUvSgo3SoCBXmMTOWbLAA2OmSpdsatYTgP/gYo1xT92f369MAgNS92uwnXjKqnYPk1XcDPpzTj40En9MfSrAsZry36fda9ZNbcCccsKpyrKRq0bbVwnCZIrkGnUmil2TeCtr4kkqQHHa49CKt9RDjWfC+e8UE8QTWqCLcsrT6OKRRLAR8IN6mTq+eopAiyDLFeMIYRiLklOK6tWjmagqmjJssVBJHdsJcU230rNlhYVvmeYSN+46U9ah5KXkynfIMuuCGHbbtm7LY2iAZ49hpAcQId6S4FVq0szVBuqgMk8oBNCiTNCgTIxPiit+LO7DLg2U7bQlfdenNotIh6ojTEQoVDcsuk4ojoSxRsmQS+LTYFA4+fOU17N+9k0quvn8vyimCgPrX00/Icr/oUUnfJIWnyV7vYL6NAuSg0aLL1r+ueL4vePE2wV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000ae184b0656e372d2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi and thanks for your reply (both of you)!

I see that mmap_prepare essentially creates a shmem_file on each mmap call
for /dev/zero, so it's like donating a ref, right?
I will try that because it looks good to me :)

There is the second part to this patch and I was about to ask if we
actually want to do the abort_munmap path when aborting because of failed
mmap_prepare
and it seems like Lorenzo already gave the answer to this :)

I will let you all know about the results and see if it works fine.

Again thanks for your help and time!
Liav


=E2=80=AB=D7=91=D7=AA=D7=90=D7=A8=D7=99=D7=9A =D7=A9=D7=91=D7=AA, 18 =D7=91=
=D7=99=D7=95=D7=9C=D7=99 2026 =D7=91-17:18 =D7=9E=D7=90=D7=AA =E2=80=AALore=
nzo Stoakes (ARM)=E2=80=AC=E2=80=8F <=E2=80=AA
ljs@kernel.org=E2=80=AC=E2=80=8F>:=E2=80=AC

> Thanks for the patch but as per the 0/1 this is not correct - the issue i=
s
> that
> your mmap_prepare hook doesn't get the file.
>
> (Also in general, we don't add cover letters for single patches, only for
> series
> with >1 patch :)
>
> On Sat, Jul 18, 2026 at 03:34:17PM +0300, Liav Albani wrote:
> > Under the new `vm_area_desc` struct, a driver may change the vm_file
> > to provide a different backing VM file.
> >
> > In such case, it became apparent during testing of this capability, tha=
t
> > a remove_vma() may drop a refcount on a VM file that we didn't call
> > get_file() upon.
>
> As above.
>
> >
> > In addition to that, calling vms_abort_munmap_vmas when we didn't do
> > actual work is wrong, because mmap_prepare hook is about preparing the
> > mmap state and not performing any actual mapping (yet).
>
> Not the case - __mmap_setup() unmaps any existing mappings in the area
> being mapped into (they are taken out of the maple tree and put into a
> detached state then added to the temporary map->mt_detach tree), and
> vms_abort_munmap_vmas() will put them back.
>
> The vms data structure is set up in int_vma_munmap(), then
> vms_gather_munmap_vmas() populates both map->vms and map->mas_detach.
>
> If nothing was unmapped map->vms->nr_pages =3D=3D 0, and
> vms_abort_munmap_vmas() is a noop.
>
> >
> > A kernel stack (before of this patch) could look like this:
> >
> > imbalanced put on file reference count
> > WARNING: fs/file.c:36 at __file_ref_put_badval.isra.0+0x3f/0x60, CPU#1:
> test_proxy_mmap/116
> > Modules linked in: ufedm(OE) virtio_net net_failover failover nandsim
> nand nandcore bch mtd
> > CPU: 1 UID: 0 PID: 116 Comm: test_proxy_mmap Tainted: G           OE
>    7.2.0-rc3-gaf5e34a41cd6 #1 PREEMPT(full)
> bdadc55b51524b311c430c1536a97e7071150fd3
> > Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
> 1.17.0-2-2 04/01/2014
> > RIP: 0010:__file_ref_put_badval.isra.0+0x3f/0x60
> > Code: 85 f6 78 05 c3 cc cc cc cc 48 b8 00 00 00 00 00 00 00 a0 48 89 07
> c3 cc cc cc cc 48 83 ec 08 48 89 3c 24 48 8d 3d 61 bc 30 02 <67> 48 0f b9
> 3a 48 ba 00 00 00 00 00 00 00 e0 48 8b 04 24 48 89 10
> > RSP: 0018:ffffc900006bbae8 EFLAGS: 00010296
> > RAX: bfffffffffffffff RBX: ffff88810409a180 RCX: 0000000038748000
> > RDX: ffff888100a44480 RSI: dfffffffffffffff RDI: ffffffff83b12730
> > RBP: ffffc900006bbbf8 R08: 0000000000000000 R09: 00007f8b49f8f000
> > R10: ffffc900006bbba0 R11: ffff88810409a208 R12: ffffc900006bbba0
> > R13: 00007f8b4a179000 R14: ffff888102222440 R15: 0000000000015040
> > FS:  0000000038726400(0000) GS:ffff8881b77d1000(0000)
> knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000038728618 CR3: 0000000104a1c006 CR4: 0000000000370ef0
> > Call Trace:
> >  <TASK>
> >  __file_ref_put+0x30/0x40
> >  fput+0x4f/0x80
> >  remove_vma+0x42/0x60
> >  vms_complete_munmap_vmas+0x179/0x230
> >  do_vmi_align_munmap+0x225/0x2a0
> >  do_vmi_munmap+0xe6/0x1c0
> >  __vm_munmap+0x113/0x200
> >  __x64_sys_munmap+0x1b/0x30
> >  do_syscall_64+0xaa/0x660
> >  ? ksys_mmap_pgoff+0x168/0x200
> >  ? do_syscall_64+0xaa/0x660
> >  ? vfs_write+0x281/0x560
> >  ? ksys_write+0x7b/0x110
> >  ? do_syscall_64+0xaa/0x660
> >  ? do_syscall_64+0x5f/0x660
> >  ? clear_bhb_loop+0x30/0x80
> >  ? clear_bhb_loop+0x30/0x80
> >  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > RIP: 0033:0x440bcb
> >
> > Signed-off-by: Liav Albani <liavalb@gmail.com>
> > ---
> >  include/linux/mm_types.h |  1 +
> >  mm/vma.c                 | 24 +++++++++++++-----------
> >  2 files changed, 14 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index b18c2b2e7d2c..5db0894e6064 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -981,6 +981,7 @@ struct vm_area_struct {
> >       unsigned long vm_pgoff;         /* Offset (within vm_file) in
> PAGE_SIZE
> >                                          units */
> >       struct file * vm_file;          /* File we map to (can be NULL). =
*/
> > +     bool vm_file_doesnt_need_put; /* Do fput only if we did
> get_file... */
>
> We definitely wouldn't add a field like this in the VMA type :) VMA field=
s
> are in very short supply and the data structure is very sensitive on size
> (it scales to a lot on many systems with many threads).
>
> In general it feels like this is to pass things down to remove_vma(), but
> that's an indicator really that you need to put it somehwere else.
>
> >       void * vm_private_data;         /* was vm_pte (shared mem) */
> >
> >  #ifdef CONFIG_SWAP
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 9eea2850818a..0c2e71fc09be 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -467,7 +467,7 @@ void remove_vma(struct vm_area_struct *vma)
> >  {
> >       might_sleep();
> >       vma_close(vma);
> > -     if (vma->vm_file)
> > +     if (vma->vm_file && !vma->vm_file_doesnt_need_put)
> >               fput(vma->vm_file);
> >       mpol_put(vma_policy(vma));
> >       vm_area_free(vma);
> > @@ -2487,6 +2487,7 @@ static int __mmap_new_file_vma(struct mmap_state
> *map,
> >       int error;
> >
> >       vma->vm_file =3D map->file;
> > +     vma->vm_file_doesnt_need_put =3D map->file_doesnt_need_get;
> >       if (!map->file_doesnt_need_get)
> >               get_file(map->file);
> >
> > @@ -2497,7 +2498,14 @@ static int __mmap_new_file_vma(struct mmap_state
> *map,
> >       if (error) {
> >               UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
> >                           map->prev, map->next);
> > -             fput(vma->vm_file);
> > +
> > +             /*
> > +              * We set vma->vm_file to map->file, so if we didn't
> increase
> > +              * the refcount, don't decrease it in this path.
> > +              */
> > +             if (!map->file_doesnt_need_get)
> > +                     fput(vma->vm_file);
> > +
>
> But this just means the file is unpinned in general and you really want i=
ts
> lifetime to be at least that of the mapping :>)
>
> >               vma->vm_file =3D NULL;
> >
> >               vma_iter_set(vmi, vma->vm_end);
> > @@ -2757,7 +2765,7 @@ static unsigned long __mmap_region(struct file
> *file, unsigned long addr,
> >       if (!error && have_mmap_prepare)
> >               error =3D call_mmap_prepare(&map, &desc);
> >       if (error)
> > -             goto abort_munmap;
> > +             goto abort_mmap_prepare;
>
> Yeah, as above, this is incorrect.
>
> >
> >       if (map.check_ksm_early)
> >               update_ksm_flags(&map);
> > @@ -2795,15 +2803,9 @@ static unsigned long __mmap_region(struct file
> *file, unsigned long addr,
> >  unacct_error:
> >       if (map.charged)
> >               vm_unacct_memory(map.charged);
> > -abort_munmap:
> > -     /*
> > -      * This indicates that .mmap_prepare has set a new file, differin=
g
> from
> > -      * desc->vm_file. But since we're aborting the operation, only th=
e
> > -      * original file will be cleaned up. Ensure we clean up both.
> > -      */
> > -     if (map.file_doesnt_need_get)
> > -             fput(map.file);
> > +
> >       vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> > +abort_mmap_prepare:
> >       return error;
> >  }
> >
> > --
> > 2.55.0
> >
>
> In general I can see you're a genuine kernel enthusiast so I don't want t=
o
> dissuade you :)
>
> This code is fiddly in general so it's _entirely_ understandable you had
> some misapprehensions about it.
>
> Hopefully the feedback helps and you are able to continue implementing
> your feature, do let me know if you're able to do what you need with your
> driver (mmap_prepare is in live development and I'm gradually adding more
> actions to suit actual driver usage).
>
> It's actually nice to see something human rather than LLM for some early
> contributions :)
>
> Cheers, Lorenzo
>

--000000000000ae184b0656e372d2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"rtl"><div dir=3D"ltr">Hi and thanks for your reply (both of you=
)!<br><br></div><div dir=3D"ltr">I see that mmap_prepare essentially create=
s a shmem_file on each mmap call for /dev/zero, so it&#39;s like donating a=
 ref, right?<br></div><div dir=3D"ltr">I will try that because it looks goo=
d to me :)<br><br>There
 is the second part to this patch and I was about to ask if we actually=20
want to do the abort_munmap path when aborting because of failed mmap_prepa=
re<br></div><div dir=3D"ltr">and it seems like=C2=A0Lorenzo already gave th=
e answer to this :)<br><br></div><div dir=3D"ltr">I will let you all know a=
bout the results and see if it works fine.<br><br></div><div dir=3D"ltr">Ag=
ain thanks for your help and time!</div><div dir=3D"ltr">Liav</div><br></di=
v><br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"rtl" cla=
ss=3D"gmail_attr">=E2=80=AB=D7=91=D7=AA=D7=90=D7=A8=D7=99=D7=9A =D7=A9=D7=
=91=D7=AA, 18 =D7=91=D7=99=D7=95=D7=9C=D7=99 2026 =D7=91-17:18 =D7=9E=D7=90=
=D7=AA =E2=80=AALorenzo Stoakes (ARM)=E2=80=AC=E2=80=8F &lt;=E2=80=AA<a hre=
f=3D"mailto:ljs@kernel.org">ljs@kernel.org</a>=E2=80=AC=E2=80=8F&gt;:=E2=80=
=AC<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Thanks for t=
he patch but as per the 0/1 this is not correct - the issue is that<br>
your mmap_prepare hook doesn&#39;t get the file.<br>
<br>
(Also in general, we don&#39;t add cover letters for single patches, only f=
or series<br>
with &gt;1 patch :)<br>
<br>
On Sat, Jul 18, 2026 at 03:34:17PM +0300, Liav Albani wrote:<br>
&gt; Under the new `vm_area_desc` struct, a driver may change the vm_file<b=
r>
&gt; to provide a different backing VM file.<br>
&gt;<br>
&gt; In such case, it became apparent during testing of this capability, th=
at<br>
&gt; a remove_vma() may drop a refcount on a VM file that we didn&#39;t cal=
l<br>
&gt; get_file() upon.<br>
<br>
As above.<br>
<br>
&gt;<br>
&gt; In addition to that, calling vms_abort_munmap_vmas when we didn&#39;t =
do<br>
&gt; actual work is wrong, because mmap_prepare hook is about preparing the=
<br>
&gt; mmap state and not performing any actual mapping (yet).<br>
<br>
Not the case - __mmap_setup() unmaps any existing mappings in the area<br>
being mapped into (they are taken out of the maple tree and put into a<br>
detached state then added to the temporary map-&gt;mt_detach tree), and<br>
vms_abort_munmap_vmas() will put them back.<br>
<br>
The vms data structure is set up in int_vma_munmap(), then<br>
vms_gather_munmap_vmas() populates both map-&gt;vms and map-&gt;mas_detach.=
<br>
<br>
If nothing was unmapped map-&gt;vms-&gt;nr_pages =3D=3D 0, and<br>
vms_abort_munmap_vmas() is a noop.<br>
<br>
&gt;<br>
&gt; A kernel stack (before of this patch) could look like this:<br>
&gt;<br>
&gt; imbalanced put on file reference count<br>
&gt; WARNING: fs/file.c:36 at __file_ref_put_badval.isra.0+0x3f/0x60, CPU#1=
: test_proxy_mmap/116<br>
&gt; Modules linked in: ufedm(OE) virtio_net net_failover failover nandsim =
nand nandcore bch mtd<br>
&gt; CPU: 1 UID: 0 PID: 116 Comm: test_proxy_mmap Tainted: G=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0OE=C2=A0 =C2=A0 =C2=A0 =C2=A07.2.0-rc3-gaf5e34a4=
1cd6 #1 PREEMPT(full)=C2=A0 bdadc55b51524b311c430c1536a97e7071150fd3<br>
&gt; Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE<br>
&gt; Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux=
 1.17.0-2-2 04/01/2014<br>
&gt; RIP: 0010:__file_ref_put_badval.isra.0+0x3f/0x60<br>
&gt; Code: 85 f6 78 05 c3 cc cc cc cc 48 b8 00 00 00 00 00 00 00 a0 48 89 0=
7 c3 cc cc cc cc 48 83 ec 08 48 89 3c 24 48 8d 3d 61 bc 30 02 &lt;67&gt; 48=
 0f b9 3a 48 ba 00 00 00 00 00 00 00 e0 48 8b 04 24 48 89 10<br>
&gt; RSP: 0018:ffffc900006bbae8 EFLAGS: 00010296<br>
&gt; RAX: bfffffffffffffff RBX: ffff88810409a180 RCX: 0000000038748000<br>
&gt; RDX: ffff888100a44480 RSI: dfffffffffffffff RDI: ffffffff83b12730<br>
&gt; RBP: ffffc900006bbbf8 R08: 0000000000000000 R09: 00007f8b49f8f000<br>
&gt; R10: ffffc900006bbba0 R11: ffff88810409a208 R12: ffffc900006bbba0<br>
&gt; R13: 00007f8b4a179000 R14: ffff888102222440 R15: 0000000000015040<br>
&gt; FS:=C2=A0 0000000038726400(0000) GS:ffff8881b77d1000(0000) knlGS:00000=
00000000000<br>
&gt; CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033<br>
&gt; CR2: 0000000038728618 CR3: 0000000104a1c006 CR4: 0000000000370ef0<br>
&gt; Call Trace:<br>
&gt;=C2=A0 &lt;TASK&gt;<br>
&gt;=C2=A0 __file_ref_put+0x30/0x40<br>
&gt;=C2=A0 fput+0x4f/0x80<br>
&gt;=C2=A0 remove_vma+0x42/0x60<br>
&gt;=C2=A0 vms_complete_munmap_vmas+0x179/0x230<br>
&gt;=C2=A0 do_vmi_align_munmap+0x225/0x2a0<br>
&gt;=C2=A0 do_vmi_munmap+0xe6/0x1c0<br>
&gt;=C2=A0 __vm_munmap+0x113/0x200<br>
&gt;=C2=A0 __x64_sys_munmap+0x1b/0x30<br>
&gt;=C2=A0 do_syscall_64+0xaa/0x660<br>
&gt;=C2=A0 ? ksys_mmap_pgoff+0x168/0x200<br>
&gt;=C2=A0 ? do_syscall_64+0xaa/0x660<br>
&gt;=C2=A0 ? vfs_write+0x281/0x560<br>
&gt;=C2=A0 ? ksys_write+0x7b/0x110<br>
&gt;=C2=A0 ? do_syscall_64+0xaa/0x660<br>
&gt;=C2=A0 ? do_syscall_64+0x5f/0x660<br>
&gt;=C2=A0 ? clear_bhb_loop+0x30/0x80<br>
&gt;=C2=A0 ? clear_bhb_loop+0x30/0x80<br>
&gt;=C2=A0 entry_SYSCALL_64_after_hwframe+0x76/0x7e<br>
&gt; RIP: 0033:0x440bcb<br>
&gt;<br>
&gt; Signed-off-by: Liav Albani &lt;<a href=3D"mailto:liavalb@gmail.com" ta=
rget=3D"_blank">liavalb@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 include/linux/mm_types.h |=C2=A0 1 +<br>
&gt;=C2=A0 mm/vma.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0| 24 +++++++++++++-----------<br>
&gt;=C2=A0 2 files changed, 14 insertions(+), 11 deletions(-)<br>
&gt;<br>
&gt; diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h<br>
&gt; index b18c2b2e7d2c..5db0894e6064 100644<br>
&gt; --- a/include/linux/mm_types.h<br>
&gt; +++ b/include/linux/mm_types.h<br>
&gt; @@ -981,6 +981,7 @@ struct vm_area_struct {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long vm_pgoff;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/* Offset (within vm_file) in PAGE_SIZE<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 units */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct file * vm_file;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 /* File we map to (can be NULL). */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool vm_file_doesnt_need_put; /* Do fput only if =
we did get_file... */<br>
<br>
We definitely wouldn&#39;t add a field like this in the VMA type :) VMA fie=
lds<br>
are in very short supply and the data structure is very sensitive on size<b=
r>
(it scales to a lot on many systems with many threads).<br>
<br>
In general it feels like this is to pass things down to remove_vma(), but<b=
r>
that&#39;s an indicator really that you need to put it somehwere else.<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0void * vm_private_data;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/* was vm_pte (shared mem) */<br>
&gt;<br>
&gt;=C2=A0 #ifdef CONFIG_SWAP<br>
&gt; diff --git a/mm/vma.c b/mm/vma.c<br>
&gt; index 9eea2850818a..0c2e71fc09be 100644<br>
&gt; --- a/mm/vma.c<br>
&gt; +++ b/mm/vma.c<br>
&gt; @@ -467,7 +467,7 @@ void remove_vma(struct vm_area_struct *vma)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0might_sleep();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0vma_close(vma);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (vma-&gt;vm_file)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (vma-&gt;vm_file &amp;&amp; !vma-&gt;vm_file_d=
oesnt_need_put)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fput(vma-&gt;vm_=
file);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0mpol_put(vma_policy(vma));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0vm_area_free(vma);<br>
&gt; @@ -2487,6 +2487,7 @@ static int __mmap_new_file_vma(struct mmap_state=
 *map,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int error;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0vma-&gt;vm_file =3D map-&gt;file;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0vma-&gt;vm_file_doesnt_need_put =3D map-&gt;file_=
doesnt_need_get;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!map-&gt;file_doesnt_need_get)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0get_file(map-&gt=
;file);<br>
&gt;<br>
&gt; @@ -2497,7 +2498,14 @@ static int __mmap_new_file_vma(struct mmap_stat=
e *map,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (error) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UNMAP_STATE(unma=
p, vmi, vma, vma-&gt;vm_start, vma-&gt;vm_end,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0map-&gt;prev, map-&gt;next);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fput(vma-&gt;vm_file)=
;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * We set vma-&gt;vm_=
file to map-&gt;file, so if we didn&#39;t increase<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * the refcount, don&=
#39;t decrease it in this path.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!map-&gt;file_doe=
snt_need_get)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0fput(vma-&gt;vm_file);<br>
&gt; +<br>
<br>
But this just means the file is unpinned in general and you really want its=
<br>
lifetime to be at least that of the mapping :&gt;)<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vma-&gt;vm_file =
=3D NULL;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vma_iter_set(vmi=
, vma-&gt;vm_end);<br>
&gt; @@ -2757,7 +2765,7 @@ static unsigned long __mmap_region(struct file *=
file, unsigned long addr,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!error &amp;&amp; have_mmap_prepare)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error =3D call_m=
map_prepare(&amp;map, &amp;desc);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (error)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto abort_munmap;<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto abort_mmap_prepa=
re;<br>
<br>
Yeah, as above, this is incorrect.<br>
<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (map.check_ksm_early)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0update_ksm_flags=
(&amp;map);<br>
&gt; @@ -2795,15 +2803,9 @@ static unsigned long __mmap_region(struct file =
*file, unsigned long addr,<br>
&gt;=C2=A0 unacct_error:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (map.charged)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vm_unacct_memory=
(map.charged);<br>
&gt; -abort_munmap:<br>
&gt; -=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * This indicates that .mmap_prepare has set a ne=
w file, differing from<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * desc-&gt;vm_file. But since we&#39;re aborting=
 the operation, only the<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * original file will be cleaned up. Ensure we cl=
ean up both.<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (map.file_doesnt_need_get)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fput(map.file);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0vms_abort_munmap_vmas(&amp;map.vms, &amp;map=
.mas_detach);<br>
&gt; +abort_mmap_prepare:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return error;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; --<br>
&gt; 2.55.0<br>
&gt;<br>
<br>
In general I can see you&#39;re a genuine kernel enthusiast so I don&#39;t =
want to<br>
dissuade you :)<br>
<br>
This code is fiddly in general so it&#39;s _entirely_ understandable you ha=
d<br>
some misapprehensions about it.<br>
<br>
Hopefully the feedback helps and you are able to continue implementing<br>
your feature, do let me know if you&#39;re able to do what you need with yo=
ur<br>
driver (mmap_prepare is in live development and I&#39;m gradually adding mo=
re<br>
actions to suit actual driver usage).<br>
<br>
It&#39;s actually nice to see something human rather than LLM for some earl=
y<br>
contributions :)<br>
<br>
Cheers, Lorenzo<br>
</blockquote></div>

--000000000000ae184b0656e372d2--

