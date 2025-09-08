Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CDDCAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 19:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50428E0009; Mon,  8 Sep 2025 15:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A288A8E0001; Mon,  8 Sep 2025 15:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 965978E0009; Mon,  8 Sep 2025 15:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8644E8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:52:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20C1313A2D2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:52:06 +0000 (UTC)
X-FDA: 83867129052.06.9C776BD
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F6F1140008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:52:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 34zO_aAkbAJQGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=34zO_aAkbAJQGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757361124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=6E6CGk2tmAlq5+OVCzHjqNr7fmm4smeKYiarZdZ2kMw=;
	b=6OYFdCnA/fvPS3+idk0bdHRI2W7eikideJwaAK8Ewojx0enRDVQimYB7rXhOXV4XIgPR1j
	u+T0LwpwcP8417DprnBRSwwDNYR1UVgNkV6bCQ7h3+2bi+qqzMR43YMS/W0utIASEe2vmi
	IBMeVds9XYXLqrImfPrcxG6XbN+gkOo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 34zO_aAkbAJQGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=34zO_aAkbAJQGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757361124; a=rsa-sha256;
	cv=none;
	b=R3OTzg8d21W/9yxEzGZ4hd/FcunBL4+6AhXRQK+OPJwK2dflKySZfUNfz+A1flqgHtT35a
	fMpx9KboP9rT0YSCTwaHptor6bJxz8LcJdDD1va+xLl4/S+dxVuNecZLwwYpA1BgO3O77p
	KAq+/5C89/WF4h1L2ULLsdBEjoS2/lA=
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3f6f0058e9aso108938595ab.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 12:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757361123; x=1757965923;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6E6CGk2tmAlq5+OVCzHjqNr7fmm4smeKYiarZdZ2kMw=;
        b=vNix/wBnU9bsUA2ye46kLQ05ZqKS60bUco5APn/oRR+VncZ5IbLzeW9mHwQ4fZ4nMR
         hdrStPPYMZALGbIr5qYftfwvX9ji4RMOAa3zPtyh4xHVIg9r0nBBbqmBRPD72x2PRwxk
         IUrOgCIfU19yOq93bY5c95sUbAusjKjej+X7E2Ub+SesfqEmzXtLd/acd384d1HX7rGo
         7JqpPHszieA8PThusbPIUJt8IO61Tuz3e3oAUEhC+7Y42fjvkgMkMQbprIGAdlnvWerv
         WdQ19YG3BV3lnMxjZ78UyjtXQ+poJH/2gEQMnUYrdzot3aEC96SRmp5skNWUiwpZ/G80
         1Ffw==
X-Forwarded-Encrypted: i=1; AJvYcCXb+b7qEXduYmIVk0Lz5oy4BDg7xTH6CrPJ2074nnoksxpJk/OTh835sGpT4qLvySsAYq5GH5BZJw==@kvack.org
X-Gm-Message-State: AOJu0YzCKA+tgg+kWClBZb7Xwra6wl0hFHNm1SoZuUBq8w9QV2hanoLy
	XRnpoARBgMB9ASdel/0/BqyxkIyhJKg1Kz+bTVjLVX2cP5NVnBTYK1ZxcvWRWWF2sfSAeoU3XeX
	52E27a5AKC/BM1gZ8UUqYDsdaQ7Vz+x9MpMSa3f+9AniOv0fQ5C9y95icGOU=
X-Google-Smtp-Source: AGHT+IGXg7L5kD0uoY5KYmviwfxTBneLi5Cm1Bw2Zj7cRXNgGfxtx4v4PIo7McUtRBfK4wibi8nrfPuz44FeC2vNCprnp34kScX8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1985:b0:407:51a8:6b5c with SMTP id
 e9e14a558f8ab-40751a86cfemr66244445ab.32.1757361123448; Mon, 08 Sep 2025
 12:52:03 -0700 (PDT)
Date: Mon, 08 Sep 2025 12:52:03 -0700
In-Reply-To: <68bf244a.050a0220.192772.0883.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bf33e3.a70a0220.7a912.02c3.GAE@google.com>
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in ext4_init_orphan_info
From: syzbot <syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, akpm@linux-foundation.org, apopple@nvidia.com, 
	byungchul@sk.com, david@redhat.com, gourry@gourry.net, jack@suse.cz, 
	joshua.hahnjy@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, tytso@mit.edu, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5F6F1140008
X-Stat-Signature: 1bkhd41f6kk9p4u3c3caek6hcoxmubui
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757361124-200759
X-HE-Meta: U2FsdGVkX19+/3VlLtyFV9qt9WpApCw3Lw60bpi5dikwrHYNS8nDcduS23w3Kfkh3U9i8DmhIny+3NM/WK3ZDXrBEQtK6ci1dd8cp9F7PNxVNENlhpFp9xbEZlOSdBHADSW9MOZBCpafPoVDpjr/jTidBTVo2rOpB0icZALka+CcqO4i5UlsQF6x7xAdVMOzwoQ1paU61VpAeJ+BfZjf88/0p/ecTRWeTy9Sz14m6dJNq6EhLhRV17G97gCNTLS9MjRA9weu++kug0/6b7PhpFmUfsggt2SsU6EykTVUp8o081D8GWLRBkX86KZNKoGbmtBpEyd7/HBAUkuJbz07guposbRYmWlVL5YRfU1c6rXl7ldLPkJm4UMNmOig+KFnjB7rTbGTjv/1MEcq4IfijfmHXd0mSCUgvdkv6UBCSy5nJvJ3ZgLMVMCBxFXIZ1n6h/57az4TtwPttHwP70vpk9ivWTj9uvpUqHPTkzZWUyoF6iGBzi7E5QhAdAfEmb+3xr9pesyHKLJRSpbIx/Nae94cL3RByygSS+BLS01ufEWtmMAZju/X84FBzSWMa6Yv1+zvw6dW0m7ePNIs5NqKzgjXyT62xyDdBbWKUbceoWTncK1JUTyJVhnZCgBwf0tzi1aJvRzQsjC0fgTx8hbX+CRObwNI+JtkWZ65X8UQNWPG99W0B53yfRPU3mmSSfCLR2/F0nMt1qftdXhiteBwxcVxEi1gHv9LZIkVCZsxq0s31k3Q2MUMu83VVTTRe/Qfj6YedJ6c5raFrMg0AOJQmsxyBpQnJsulAczSg7lq7lCCTD3CDJNG5LgAriEJWKo2ubN77KzDAAhEaVNxK23jyKCB8kgfgtEYpP085YD8yKaaxCqOmI73ES8IR0kpCoJxgAbNODyxAF5sKrwAiPQpEWhyyKMd9ebitL+r7SUNBgddyqr5pls0LPF7yQFXcGjuW8ix+m5pViykIOPbRly
 RCZm3sFq
 zg5A8fK6WERs40GK6z+46R1gUCBspFHT6V87dNxYgFHXnkgHbyCV5q62gqK0q36rRru/94F59VeqEyz3r3PvrJMY3ft8GDSMpeHiokVnLApQ1qaDUiyhxHRHY9lMrdvAWVqcl/p+rnysvfLBNT1hFOBfHvzHlrYiUv5XggEHJFBC1RwbrD68uIFNJJUGcvtM6TCowpoXaCiaiZzLoGPCMpEE+nQpp7yJZBErUVFa0fu656Vd8XMAz4cvWwwnsJbtVzYfEcNJCCy6xt7QmRy9/ekL92wZm3TXk4k8cKxXrHGsSwRXzRbyjPloQ0K4/jNmSQ9ixXnGcAgmBOZUHREj+o4Cdr4mmP2t6YFssg/G6gh/y9Er1ACdCVyyOE4SFeIaxmVkkowi+thB5bFOPoUItbGg6qFkSXvLmHSR16/6p15GVd490MSZOxdz2HUhopbxJuHBM3s4fzUuFkLguAMRhj3JRl6vUVTBMlxBvoz5Hc53TXTQHYNWrQxxKk0XzHGsQsizXVIi/t1nwf2Hawz02tY/dJrU93MBea6vW7L/iGtjfxOx99s1l3t3GYfSyiGIQkGIFgkC0o/Xw9YWXJ4qJEVKF5b93B8AG9qlCZh/6ZwEnp+CXAFUt6iL3tMw/pS/aIrsjmbo+y0M19mlMGwbHXdsUzwi/TccfMshWuD+Rk5Mb0V7h5dRHGXk4EXKKdOgnzPa6OO77FrZUxCuoDnE5FGkVBW72AoJVB90f3tRbzj/dKFU37PudVD/5I/RuKUi+nK3zON/etmnRhvbC3YbBVEDToDn1rgHokzaX028mC/U83PzLIYlvKDZL27/cdLRFIyD7pDBrdNocLq2Al96WI+L6VIbXLGPExVvlQDvE2sjQqaJOlIM6d/fgR7/IdDAPs4AxwP2bV6IV95XDZH4+Ok1tRTgY0g8DBB4Voq8eN+1IzQm6fc8uOelPwtyFiFLhOm7o2v+DHMYNvL905YmRT/N+sAGK
 iTasr3iv
 ktbHlB6h5Hj9cPVsUi9/n7+/uD2pjf9akSpqexDDKovf02M5MnK7c1RXPmHLDgWcs/QoJuwgH8IgTrSueAqeVfba4H0cNLUu+wv3RdZK7cuCo6rFF7pGt9AvT0i04z4ULBDyClagcE2E/T27YpUlLNYYyrdX3sID
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has bisected this issue to:

commit 02f310fcf47fa9311d6ba2946a8d19e7d7d11f37
Author: Jan Kara <jack@suse.cz>
Date:   Mon Aug 16 09:57:06 2021 +0000

    ext4: Speedup ext4 orphan inode handling

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16645562580000
start commit:   76eeb9b8de98 Linux 6.17-rc5
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15645562580000
console output: https://syzkaller.appspot.com/x/log.txt?x=11645562580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=429771c55b615e85
dashboard link: https://syzkaller.appspot.com/bug?extid=0b92850d68d9b12934f5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168d2562580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15869562580000

Reported-by: syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com
Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

