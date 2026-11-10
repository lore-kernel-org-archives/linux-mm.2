Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3FD60A261C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Np4xGLuk
Received: by kanga.kvack.org (Postfix)
	id 07D626B05BA; Tue, 10 Nov 2026 09:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EF06B05BB; Tue, 10 Nov 2026 09:16:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85D26B05BC; Tue, 10 Nov 2026 09:16:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C08E96B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C21701C42FF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:16:08 +0000 (UTC)
X-FDA: 85419408816.25.A2A4B04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 85ED280012
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:16:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Np4xGLuk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320166;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyNlH7az0j2QxN5pdhx5F0SpCWUntmYX6z4qXU2TiuM=;
	b=RQypEydAjarsz7SJ3PkXQXwIhjD1j8LrF/N92929sgqnOi6cCGSXtdmxg6rhb9vvH+NJdV
	86JCv26Btvm4pBoM6vJKEy3ulvNa3apFV9IRN03htuiZFR1GFtR+TASz7ONkMrZqWZj0hJ
	VuweYaxL4KmrVafrdCp7QTpplhUNw9w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Np4xGLuk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320166;
	b=ziusFWkHTdJvziKzZZkWF1gEK/P0xCek6EthauZT7vfS+tGFmg0MW8q/0Ux4e5PKvIdVx9
	mRE1GBuBR5rxFQxx36gR4lVgkk3QSX4snp06SmPsd8fc4yC9+lXgXxgDDliaRUUDkSIoxp
	9v2YTBIGvnKoCiAeJTxXwvnsm52b4qo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5B3C4013D;
	Tue, 10 Nov 2026 14:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109401F008A2;
	Tue, 10 Nov 2026 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794320165;
	bh=RyNlH7az0j2QxN5pdhx5F0SpCWUntmYX6z4qXU2TiuM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Np4xGLukYEJ1q0DNE/gd8EVNa7b8fN9TAaxdNhmHeBVjZrYoFK7ct7ynAfUah2bvk
	 s0HB8kFcXtXhIYgVKimKeeZyxwEaFeELbdrhP1lQveog31O/++jnW4MEoNlcWPWokB
	 YhDEQHjI713RbyUtJLxDaEGVzZmq6HuGztTYFSDR46X/sg6SxOkXG0tJYCimtLI10L
	 E5otu+5GwcTRE4m6YTMuRXZoFZw/Q3sj/P4KUsX+A24FGlxLHjfgKiSgdLqZ2OgmYA
	 S+YsHzmlUTZpQE+c2kk21p5aDDnyK1WgSVH1xF6GWfl+AadjuZL3qkpgxHsKjCJSD8
	 U2232BLgE1XFQ==
Message-ID: <sashiko-outbox-207182@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.18.y] Revert "mm/page_owner: fix memory leak in
 page_owner_stack_fops->release()"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hamid Nassiby" <hamid.nassiby@nokia.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Sasha Levin" <sashal@kernel.org>, "Ran
 Xiaokai" <ran.xiaokai@zte.com.cn>, ranxiaokai627@163.com, "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil
 Babka" <vbabka@suse.cz>, "Michal Hocko" <mhocko@suse.com>, "Oscar Salvador" <osalvador@suse.de>, "Mauricio
 Faria de Oliveira" <mfo@igalia.com>, linux-mm@kvack.org
In-Reply-To: <20261109141527.2880867-1-hamid.nassiby@nokia.com>
References: <20261109141527.2880867-1-hamid.nassiby@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 14:16:04 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 85ED280012
X-Stat-Signature: yft3o8pakbikh7wrj6pw1usr5px53mot
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794320166-913570
X-HE-Meta: U2FsdGVkX1/S9yOjH8eAMS6FwOlNjK29XT0suVF7yQU7eB/RenQWoam9JlXnfiGTcWGg1etew0/yfwwuTL6lJcdHcb19hVgGWr997J9FGSf8xpO5mtvaGNSzFgEbyOhaB+VY42v2zrIo0eJbqvDZPAA58yWR2sPqTZMMhAnycjUOE/qB5axVMYqd+rsrKBw+5ii7bS5y6pb92JtB3Deu+iUbcWkqVUI5mItl1lbNTZHMl24C1g/c96oeajQGG34Gh4fmV98DhJKUqriNE6U11/tR72BI6v/i6gz+oiQgjEvYKSYHpLpvS8FHkUVqQ5gvi6gv3VrSpX91aE4tZdQMEwtxLAWBL3/dyiht/KbXIn5F1B8q2cxvGGu0SvwD0wvl8HsRsbRnUZAvUqjc/SANpbdsWgIkh6RcBy2IdQhCMEO+6LehJV8fmkNSpdMNDzjVZe44BM20ZNGMQ/NwQHWv/FxJxpcMq20w+4KEpvaqlKoY0YzaD8i1xmFn2Q4lIFHoMqxgU1Mr9wGoeLzwf/LuKGagF3eDLbSE0nNW07TppimLHXq7rs8dU0/WigFQf3rHdLVCfJ9Y4kIF/RyOYTy9HdrM38au/v8juoxdaj0d2dppl66qtg17xJ1q1I0XhQ9k7ZJ8VPjCWYy3g+7IBjwpju27nmhVDToTW2NlGQz2P1xTerbTFYnQ6I/GjCWNbf56O6VpSgB4j/bNT7YwVEnOCKd7RxqVSGR+sCYbs5x9f/aSfsUYCZFMY077/XcHgyvhpAeoA/zyDkk+5dMyik1Z1esxcgThnM+Ctj62uxkX5zmLAlXuTNZrmEFGb/g4YTYN8HP6PJ4B5PFZLeCInw8O4J4pyZiDrwuMbIeRPtXsAvg9MCfguhPoag9R/NGC5v2QGAXB+Lg7yMt7gTTLPSKZTrg4Y1Ew5kOZrXX98jO9URNYKMcFZzHl6P5qY84p3UGDU4luues4aTI49bZHoo9
 wYkWXiHY
 E4NQnNP2ZqYDrQkVF8xzpbm2EqvVgmXGVKYl2vmkLrJFw3SWKPEi6MbuSXz4TKIbPNrYwWrstD4z9xo1ap4B9d8hQXIVIJqktj5yFXgSAfIrL579kw8CroCUVCGTOwfRDEM1ib5/U/UpjL8zLhyoHqmjdKaO3KtnT6NVMsa0Cv+e7A1pa1PW+uN1rtTFcR0OzCwNS5/3vC1XHUXS/N5u3xOj7hy/zOiYzF3fFt6PD9vT20k1GouPrZDrLglGVUmd3EqaJ4R26RyqbJQAg8qfHGAHL72lSuHX45UrigVrhm0pn/5nEmuzdlo4I2wbQp+qzUtNcejYeavYOG56gasmFLR2Rs5qrQ1AFqMtGBUMYj1YnnlKj/yf7Lu5uWVxyYA/FaZHRzGZyJxAEH8Yxvg+ie2kqzzKOZju4XQ5TzJ8m5xAy9fGdP6tihxDK/Ii4HR1hfAJkxbRJMbbaP+ThByDDBPgw9jFTkKCMTnPGHCUzsmaVlLF27838RjOdOOekh/zvYUyhp4VQqicO8XqCbp+LCSeSNsYa3ulAC2G9e99iCDNk0nQ4GXduXyxRxv751hp18EKWsTFaOnN8zpQLqEApk2ZkcHwreNCx1MGRgaNQfZ0KWF6Qbecp3rNk2a+C52dbO+tPBbQ8B22upKfyqSlVzEuOdMMTKgnwDJ/PIDBKdV/zmYkPFCz2rVJ5SP9yAAFWylDPL+zGOCf+xwH2ztmarFvMPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/page_owner: missing Fixes trailer for commit 05a8edf607be
--

commit 9eb622d1a73d326e41d0bbcc302c141ec9c886ab
Author: Hamid Nassiby <hamid.nassiby@nokia.com>

> Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release(=
)"
>
> This reverts commit 05a8edf607be826738dfc620a17d9d98e8976762, which is
> commit a76a5ae2c6c6 upstream.
>
> The upstream change is only correct on top of commit 156c0c5d1463
> ("mm/page_owner: introduce struct stack_print_ctx"), which first appeared
> in v6.19. That commit makes page_owner_stack_open() allocate a struct
> stack_print_ctx through seq_open_private() and moves the stack_list
> cursor into it, so ->release() must free it with seq_release_private().
> 6.18 does not have that commit: page_owner_stack_open() passes a size of 0
> to seq_open_private(), so there is nothing to leak, and
> stack_start()/stack_next() store the current struct stack node directly
> in m->private.
>
> The upstream commit was backported because it is tagged for stable and
> carries a Fixes tag for 765973a09803 ("mm,page_owner: display all stacks
> and their count"), but the leak it fixes only exists since 156c0c5d1463.
>
> seq_release_private() kfree()s m->private. Closing show_stacks before
> EOF therefore frees a struct stack node that is still linked in
> stack_list, and the next reader of show_stacks walks into freed memory.
> On v6.18.60 (x86_64 QEMU, KASAN, page_owner=3Don), a single 4 KiB read()
> and close() followed by a full read gives:
>
>   BUG: KASAN: slab-use-after-free in stack_print+0x165/0x170
>   Read of size 8 at addr ff110000062adfc0 by task init/1
>   ...
>   Allocated by task 1:
>    __kasan_kmalloc+0x7f/0x90
>    __set_page_owner+0x4a5/0x720
>   ...
>   Freed by task 1:
>    kfree+0xf8/0x460
>    seq_release_private+0x58/0x110
>    full_proxy_release+0xa1/0x130
>    __fput+0x35c/0xac0
>    __x64_sys_close+0x79/0xd0
>   ...
>   The buggy address belongs to the object at ff110000062adfc0
>    which belongs to the cache kmalloc-16 of size 16
>
> Without KASAN, the same bug panics arm64 hardware running a
> 6.12.108-based kernel ("head -12 show_stacks; cat show_stacks").
>
> With this revert applied, the QEMU reproducer completes 20
> partial-read/full-read cycles without a KASAN report. mm/page_owner.c is
> unchanged between v6.18.60 and v6.18.62.
>
> Backporting 156c0c5d1463 instead is not proposed: it prepares for the
> new show_handles and show_stacks_handles debugfs files rather than
> fixing anything, so reverting the backport is the minimal change for
> stable.
>
> Link: https://lore.kernel.org/stable/20260106170556.173097317@linuxfounda=
tion.org/
> Signed-off-by: Hamid Nassiby <hamid.nassiby@nokia.com>

[Severity: Low]
Should this revert include a Fixes tag for the backported commit that
introduced the slab-use-after-free:

  Fixes: 05a8edf607be ("mm/page_owner: fix memory leak in page_owner_stack_=
fops->release()")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109141527.2880=
867-1-hamid.nassiby@nokia.com?part=3D1

