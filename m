Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7600FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0456B009D; Tue, 14 Jul 2026 05:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B79B6B009E; Tue, 14 Jul 2026 05:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A78A6B009F; Tue, 14 Jul 2026 05:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AAE26B009D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:46:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1F54A0352
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:46:48 +0000 (UTC)
X-FDA: 84986902896.12.C166CF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3967160003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:46:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wx5oJE4R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784022407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1UQ1who+MzGJnhRAGQnZjnEvcZY391rlmuNIJbBr8I=;
	b=4zDeu1a5SEXBsxrEdMP3MqLmiGLA0oQcoj0/rHeYa8Zf0nyfNtWtX7d87W/zxW5cWE2r3i
	HnhNB/qYjWQ2fB7CAIFsPJubvc+KXIJRedAd8F6UvzOVhHBDB/n7WtnsyFyQvFuLgPg6Sm
	W/5tKtcLBmspgnVKDszIEbnQsVHVw7Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wx5oJE4R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784022407;
	b=bkKQPH66vnnacraqIwAmCwejRUv0jF+zJmMrA3BSSfJ6IjfCDxfm1aCkhcWeNBtL7BioF6
	5bNVPt+WLHfDYoNdXx/deEZ0Cg4aJzik0Rs6/tk4CKdxaZ2SIXHq/V002LJGB7inE5O1qa
	iGw14Ay2j2unz+n1B+KIdGHsC27AjUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EE36601EC;
	Tue, 14 Jul 2026 09:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4AE1F000E9;
	Tue, 14 Jul 2026 09:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784022406;
	bh=E1UQ1who+MzGJnhRAGQnZjnEvcZY391rlmuNIJbBr8I=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Wx5oJE4RDEO4dpFV0phT403AjtH8RYoSYzbGWynEUfagmkrDOBkIbSFsS+x53Ry+Z
	 5EyDiYSdAlSv9M9WXQCsigWqSLQqxT60I3cGYCq+cTtojdHF9mL5k6OUmcHi9JboFn
	 GEb5fgFiZIjw/cz5FWDvHJte2fMyl2uab32nxlFj2pXeb84lc9s0I0zXS6z3d6SXXl
	 VP1FX7yrz+0z7UUMLnhbYRTPjdYSiE/+1upFXAxeEEBWrK+9mI+jbnZLn34Nu0FyLx
	 lh9kNwEY/9P0B8kcjQOWOs0RkuOPBOwgdAthkIV9aVwNzhJUf3oauqhZB02agLe1es
	 olERYlqWI2iYw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH mm-hotfixes v2 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
In-Reply-To: <alUUfGnM_vbhOTVK@thinkstation>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-1-ad134cc3a12a@kernel.org>
 <alUUfGnM_vbhOTVK@thinkstation>
Date: Tue, 14 Jul 2026 10:46:30 +0100
Message-Id: <178402239024.69739.1681992582238824793.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1415; i=ljs@kernel.org;
 h=from:subject:message-id; bh=a7VMRw+J+v8nzO2qena+1Qa+1xYq9bL9avRWJ8DcXDM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLCWMtnZOXOu+4kNGHDhr83f+jpc3x//2kdX9irTVzJ1
 lqvT5qXd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi7TMZ/heEXvVdbXTATHn5
 Vw8+tT+vdm+4V+LvWbF054M3B9t/T21gZPjK4SQ4J9OKY9Nhx39/5+0WvP0neuI64/CWJqVTqp8
 mmzEBAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F3967160003
X-Stat-Signature: oaodiugub41sq3fa1d39iugkeidntr5r
X-Rspam-User: 
X-HE-Tag: 1784022406-275266
X-HE-Meta: U2FsdGVkX19YRjPPkX6QCPWmll02QxygUUR+XN5HRGm2qUOHE5DPDFYdl9a/rT813nEzDz3Nqp35LLgpXdKIk5wKqn9j6AVdHMoQ6hw6LlXjYQRmnDIGRPNA1tZhEcp0emlV1C7SPytT6+U29Qu+kQ9pLUYJKkC6oBGRZQ1P6dqQ/TOM8Ud3ObU5zPcZ+TMjwmqeB8nt8B4HwUkbuU3hV9grx+Mhg9Ntt5aCi4VX5CeEQiYEoR8fVbtktWZ8Z4XCYUFI4RmEsyrcmwPN6/alnyya+CWjiqizzZdwIvrLALeGKKHEwCOO80hQ+aoeM3jubDzNGdfagUG72stGVDAA1fxmp8drdNLiILYeJIR8Z5jb0lcnNyLYCrrTNDiXWYRwlbg+ueVx3PlqEz0EqBvdcgCSAIzpJPs3V6x3auHNmbYlcTC2chlqwGnFFCKjhCb+KvCCzCYc91u6wqEol28/1Z4RyOI/kS3HJaQwVSM51ZbQ5JFqWJYlhuP4HYNWVvWODs9ppx49zQrLFJwZR0d9kOAV54GtAXmsuRGalxm0T8y/RqxqSDAX9wIL00/Wdreml0LfwHs/iohaZ4j0P/QtcIZ35jG/Mb66SsOdn0nDTfXSl5B9KV8BLn00xugbhysRYiubgtWTIB9NVuGdajQ8VGRi2NfydfLob5WE+zienhCzJJKtoewmkfjV5V+a16kx36+G0LXfL4bLSbMfgOM/JhzfpNixfESLuKhispcEoPyCpp2KmPpshzZz5T2ihBSM7sIVjjREH9e/QB0C5Rb335zKfQp78F3HV61XZY/ZfKEmvlq+GBKZb65Wk3qLEE2DNMKfnEwFTu9dHAKGt7ur44XJVIini1MttNxm94y1SxM2uyIHKqzT1VdeFOfLFQ/mw/Cam7U+ghlUGe5kc5iGg4C/IFH9ruqFOB6BHJMHabrDBJj4ae2g+gg3UwW/Alfb4etQkryQDoOSkR8FWDR
 LCPnKBdY
 KVxwMdONEPj4dB3kPRaYmV9PjOlZoCW0maWIjcIod3tMM6F/FINFayOpb6bVlzyFEDW9HJp/OI28zki+ALWX58vBJWHWUww2wsB8uwS4rPz1myltkh3OsD2kY+8G7MIo5S5K32pO+dNZejXfplKlQlgrK8SIPMSh2vYJ+6hS1L1LzQiMRF0G1PM0HXWNaPooTYvi70jiTlJj6eS0eYCdY43TzJxtVGALBwq4qcRouPCb5i0hHu/nAxWmUT3oewfZYh/66PgqxEKOqqj9M9oUih3KQdsJkmJ9T98Q41VqNi/OdyTNcIVRJI/gzPeqB2jedyB4bK+8FHemk167KHZT+BHkAlpJGgpAy27heB4Z9vJyMn4ptXEjptMA3oBa6q7m48pze4rptKTeepTfsMv+UZmyRZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-13 17:42 +0100, Kiryl Shutsemau wrote:
> On Sun, Jul 12, 2026 at 11:42:24AM +0100, Lorenzo Stoakes wrote:
> > Currently there is a nasty race between ptdump and vmap when attempting to
> > map a huge P4D, PMD or PUD entry.
>
> <... skip 145 lines of commit message :P >
>
> The code looks good to me, but I think the commit message needs some
> love. It is long, and the pieces of the story are scattered: the race
> itself only shows up around the middle, after several paragraphs of
> ptdump background (including the arm32 and EFI notes that the text
> itself says are not relevant to the bug), and the one genuinely subtle
> part -- why the read lock is sufficient -- is not spelled out at all.
>
> Something along these lines would be much easier to follow:
>
> 1. The race, up front. Diagram, if we you feel like it;
> 2. The fix, and why the read lock is enough;
> 3. Why a trylock;
> 4. The arm64 wrinkle and the temporary ifdeffery patch 4 removes;
> 5. Secondary changes (guard class, walk_page_range_debug() assert);
> 6. History, if you feel like it.
>
> Point 2 is the one I care about most -- the same reasoning would also
> help in the comment in vmap_try_huge_pmd(), where "Therefore, acquire
> the mmap read lock" is doing a lot of unexplained work.
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov
>


Yeah that's fair, I will reword!

Cheers, Lorenzo


