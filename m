Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A686CC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881186B009F; Thu, 27 Aug 2026 13:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8590F6B00A0; Thu, 27 Aug 2026 13:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771626B00A1; Thu, 27 Aug 2026 13:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46F016B009F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:50:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A71518015F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:50:32 +0000 (UTC)
X-FDA: 85147789104.01.D6E13BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0F46A4000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:50:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fWvmVk25;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787853031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LyDiwZ/dL1+I6iznOnKyyWmM8BHa0i9q//GZQBdPIM=;
	b=Cwk+mUNLq1v3ShWmfxaU1IJf7b4lmK6hhhrnE6cPBwiNcQbCIB4hbiAHHdEleaSFxgTj9h
	4qIynP/hXxxJ0AlqBLceGLsiTrwzuwKqRZeWXi6fgRH1A5kI7UBoaQ0/BiglFnR0WqwUZo
	0SMv4kY23XBgInDYqh6uCR/loF3abMc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fWvmVk25;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787853031;
	b=RFcqLU7ULvuaoGeI+33PqZy63UFKAUZaYOFI1ybjxwM2uxh4UcIisvYKKBIVqW4otwloOv
	Rj/iZ1cSwP/mTDpZkwf1kk4ePCK9UkBDFbLbmKChPhU8NMvyTyLS3LyN45sXg3QtjIc0r1
	KIUzET/imHrXNC/2FDGycgvkqYPlinI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3509843970;
	Thu, 27 Aug 2026 17:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8591F000E9;
	Thu, 27 Aug 2026 17:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787853030;
	bh=7LyDiwZ/dL1+I6iznOnKyyWmM8BHa0i9q//GZQBdPIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fWvmVk25vsFxN9BucJRSFoWwejL9SqfMeHC8Oec98TjRzyaTrrboulTp18D6s7ycy
	 aC0eGeeU2PLt5/xIixbsS3sD0/c3+Kb+2ZaU2LTISaQI8gAQfSm1MvpboK5rYWfI9H
	 6PSCj4k6dCl5xikrHD4ORtsB6uMnGgDIbFYDVpIVJBaOGwZmlx+FWhAVYug2v70zFk
	 L7Ap9c3ZYUxouOXvnuL+OAiZCpWqQhuzCPvGp3XXVxEVkaZmHorJzn/vH7Gsdax2l0
	 3tFZYqqYtX46EfMPk5MPImz67oTZs3qNqQL3aVsw0h+Jq8G23+9kAttqxGmyuyY/tW
	 7RC39dvm46rWA==
Date: Thu, 27 Aug 2026 18:50:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com>, 
	jannh@google.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pfalcato@suse.de, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in __split_vma
Message-ID: <apB40XmmVSp5pwme@gremlin>
References: <6a8ff666.27659fcc.2ceef7.000f.GAE@google.com>
 <20260827093322.f99541b28aad2a3c069ed155@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827093322.f99541b28aad2a3c069ed155@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F46A4000B
X-Stat-Signature: ng7uo7irkm4ziz7syrjq45k1ejgbuo9d
X-Rspam-User: 
X-HE-Tag: 1787853030-992622
X-HE-Meta: U2FsdGVkX197QszR15z0YGftmV/k1k6KYA4oxpQSx7M3KU3xqpRcldSIaK3jxVOVT/el+jSf5PKYn1wGTUZji1Tf7BGB4XG2UGFuHLQSjtnZtppvCMYuf2FSFHurrR1aW8wFjowUhgY4u89bKQYiDvCUCLYRMeu5kPUvm6RuZgW0QiKleuiQbmmGmPzQ7al7QR8K7O7IY1OTEvGVKI3UtbnrOhzA4CwaEB15ffz7UAYQIJsK/TzFt1uCyLhSdVyS2706UmdPcN9U+4YJwhqlESI4m4x9cK+lrb3LSSGCY28rPHa2RYzhj78lBlSK7QCL4C/SaOXM0npfhzpnyJ3fd5ketOJwGBNA/9q3NdCdjfDuF9vdTKcm+Tgf0VDQOiccL0DVDeyV8nW2/oR5/GeojCWxD8fYH9XGadGEp/ENmyGZP6AHbur447PELnGcH4tC9mB5oo2I1FOYFnDJEktTomZH8q9n25pNHWXXqJHhL3Vrtp583kb23qch+Mjh/60hB3lC3Fdx7yffWHpPsYRBYcGfPNMRwGUomQr3AfNXL+oafkGy2IhxOAm/QPEXh+EB772a0Ob7VtvlOBXQAAmA6CxipLVn41lDYupH1zMKSJQndpN2q31Zhb3jKFn/0HFeMRsB+3vJzxs9sjwmcH/TqW6xpVI4tSsJhLOK8Cy7m/qP3EW/QYWYGxtcMADxk6gkwNZdKoBS0HWyiwplGbeb9R7PauVTXi9L9lFuknfdi5Td2kiGm2UClwyoVjxTnJwkB2qAcBKz9uY2wGjoLHTZqEeSzRtvAesSSmjfHerczGhUpGHQlS1vioibGGj71RgNN2ei3EYM2YJTwT67OBzGDCJ1F2YsnaQbIVmsNvzpdViYSSawZDEi+oEmtmlJ519kZiOEYV9zrc6SPdbm08FFApxX/63HYP8oNXugk/ZCdniHSiH2/GreZjtTuY3BXXjwlzReAiCTkcT6AHS07Ha
 Ey9bUVMy
 cGQqh6PWsAbUp7A6oaf7latf8Y6FnIuA3VknANh9hPoTHBBvx+2OMX94EWAZNN0xZyoub1sHifEPJs1Dz8DZDGhU3LApKqcUngy55mlM+IprpaimWgT8ebTDRaDJgckFBwr3J8aE7ldYpigmcs9F4W3oEW0omuzEQlCYY8w4ozslJObcbcRRDPyWtFq6SDF5sqSx9P8LA+xMTZH5YSYmrTY9CI76PCICY1GSU0bCroihKBK9z90Vh1pV7uj3qIMmn7cRp5FN0g3viK6pIXjOo6E3v/yklyoy4ZnHNq2ynA0QWV8wN9LyZdGp8E4YOZTNa8SCBhfpHNucu3SbFySGBjDiH/9lZoWhsimzsh0t+OObzPamklvjtBbS7m+YpPjIdL6wBFB6o1BYzP5ZYk4oYXOYHHO0GU8P6CM8/eMoxcfg76s3tZbCnIpcAYxfLwRdNzpcw0aFOanbaiw1CJtuGDiLHgi6h120LPGEBNXmemX5Cz5TyJYphQeFnTAvoG5KYZFrXKH/gIwT//Cwcz/rx9G3V7cdtuKjZP4ewVHUKEEBkSjQAkhdIFrTQonW+U/3jGbNuoZwqRd5Jjo2tTCdOGhM/EpCcev0wXKwG+qaAbPfGH9Ziy2CC6rOPMT91cCgY6K3t45esgeh9RMZCwjr5m0GXKS+bi+VvqlSDzBZcH3zYX25ABhjgZE4vRGIQIWThmezJWO4GIkNMocfqkKP/xOfyUTkrmDlx3T0mndYFPHanGxq8NX9FnAHpTVN5bhTO6tYtnMBbd7C262GSdyqrsLalzHxDShYGikTGCHEzDghbVrgH4lsmpgf86ENK+gb1MkyjEZyKAQHKc1J08k19EhPHSHONlXkod9i4Fm0TZ4EIFesZ39IQlyy48efkVmmyBpP3p0xpx1kp9ew64Fdd3XRzoeLk1yL3kFUnDVcaZjzGF2OcDhu4Fy67ufBZH9ihyFcqI3lawjLJyTTka1XUibYZk/aU
 RGxIYyWx
 CyPMJk7BJ5FD289PFPti9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 09:33:22AM -0700, Andrew Morton wrote:
> On Thu, 27 Aug 2026 01:33:42 -0700 syzbot <syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1645f979580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
> > dashboard link: https://syzkaller.appspot.com/bug?extid=5c417b73ac02e0e352c4
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104a0d49580000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f35979580000
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/6e4100526b12/vmlinux-818bebeb.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/723c4783ee96/bzImage-818bebeb.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com
>
> Thanks.
>
> Hopefully fixed by the pending "mm/mremap: reset unfaulted VMA page
> offset for MREMAP_DONTUNMAP".
>
> https://lore.kernel.org/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org

Sorry, yeah, this looks to be the exact same thing, marked as dupe!

--
Cheers, Lorenzo

