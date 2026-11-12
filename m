Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7469606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 21:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=spicebrains-com.20260707.gappssmtp.com header.i=@spicebrains-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XIeYufcU
Received: by kanga.kvack.org (Postfix)
	id 057D16B05E9; Thu, 12 Nov 2026 16:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008DE6B05EA; Thu, 12 Nov 2026 16:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E614E6B05EC; Thu, 12 Nov 2026 16:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4BE6B05E9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:30:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5097C1418F0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:30:02 +0000 (UTC)
X-FDA: 85427759844.26.A70B96A
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 590E01C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:30:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=spicebrains-com.20260707.gappssmtp.com header.s=20260707 header.b=XIeYufcU;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of master@spicebrains.com has no SPF policy when checking 209.85.167.182) smtp.mailfrom=master@spicebrains.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794519000;
	b=iNy9RrJ5tZ8hWkPNXGcNX6uYIv91GsK641WNL7TRNrilkMEZT8jPYzDzRCcni2E9Eryuh3
	fQRUWcw/+/DDKLD5BMcwQ2qm5dYrXxclBm4fsULwUNKF4xNhK7aaVka+T0HG8nh2WSrUsr
	D87Cm486fwZwXUWuWS3D8su9wZcBNyg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794519000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqRwfiYliDxxA78RCG3u2d8E1XEz8kdl0WNG2OT7+cQ=;
	b=1bZ8aWCbmPp/EbOqWhf4jMu0MQRL/2131RDsgAFlAgcvh7ZHo6DG7cvZ9g9AG4/doDuKBc
	+WDIR/FAqG1VBmxur8xev9mhL4jJ0ffCudgkCzMC1VIhAPV2yA8ScfcL9psetfBx9yIZrQ
	hchp6uePMV+j6VPPjJGaY/YQ5GVMDSY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=spicebrains-com.20260707.gappssmtp.com header.s=20260707 header.b=XIeYufcU;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of master@spicebrains.com has no SPF policy when checking 209.85.167.182) smtp.mailfrom=master@spicebrains.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4a451915d8aso261500b6e.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:30:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794518999; cv=none;
        d=google.com; s=arc-20260327;
        b=bZl70UdRfGhwJVbYrUJaYv1Zf8VSDgkKYLvj29btVy3AYqS5vzonSiZjntKPxU2FeU
         eiiEKLRWn3kT2z9IJDV8Z8wTsokdHVydzM6lvDJv066KB3l4UJK3GCEzuMZLDz5TqJLt
         Zzh4/z7bNQ7CfP6c5y76eiJ6iGQ5p3DO99au4apdv62FsSNzRIiPQeiVaJarjfNDQEkX
         Kb6o6Lupl/Kps2WutuWkLU/XG7AVVBvrRiWRgCS2opBRNrvvH7tMwAXmZ7ZoZjFD9Wb6
         eY7f+i3j+75peznMZITwbb0W9qmw3/gYMZocKMTPhSgc+bwCHvubzEFxCqeEh75GSJjz
         NYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QqRwfiYliDxxA78RCG3u2d8E1XEz8kdl0WNG2OT7+cQ=;
        fh=tiZAAAtjMuuaLvyJMfgqHDex4NVwrldMhQcyJMJeqQ4=;
        b=EgY0hUxH/JHP0xWZakTSQU1HjpyK48MUKG8P3x7jx9FVvKIfamoQ0oK5BObHgTvHeB
         ewbvtQlOnCCqd7df3bW3bBdINFa18XxnQ9c+govKNtBTuyMNuTQuEaGrodjSj9luvH3D
         tcKzRG4TZ7EBn1MGWCssxnkRQ/2UKSVbSVDHfSNvngqx6J0Wa/4peMvwj0Rq6sR8/bYo
         Q2j6w9Ie2XFWhkTslarURHW0tkoXUn+CNeybLfVZ7UwwJGtBD2WZBb6bUtRh9I++LWAx
         FjojAtGuEKxDji9KG4U72dNjmhotU5ERxlZ1IftHOkMwsWbv0Qi8a1TUDpvKhTkWHbof
         6EKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=spicebrains-com.20260707.gappssmtp.com; s=20260707; t=1794518999; x=1795123799; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QqRwfiYliDxxA78RCG3u2d8E1XEz8kdl0WNG2OT7+cQ=;
        b=XIeYufcU8mTl9JCn9wHiVhVO0kchR+eoprYG/HM+FKIDFWgySrCqCaLyVGdvUfVRMY
         zD1IP7pCPQoWDypIbABYTOtxjKRM6BClTE3rnOINzpBqEeIvwG/OHPb0xpdFOfSbJPqx
         mVLnHMT5Y8cFwdMMJ7llyhaxWHWQbspHHExD36oLSB3kwzMgPB1A/PxE32rB3OGEZyqw
         EKqomek0a/8Mo1zieRtohLGSnvnbDKZiYmD1f0ztGO87SBUtyHc0rStSzpwvg58nCuqo
         Z4KWrly0M/BF6/hrjkEZHJhlKyI1fXJIDvg5t+H1oGLn1UpeSgUSixYotBwyI4HNqBYn
         Fs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794518999; x=1795123799;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QqRwfiYliDxxA78RCG3u2d8E1XEz8kdl0WNG2OT7+cQ=;
        b=x/f0FVu7FF573eo3guthXLoPl9aXtF8uoF2VtK4vYQ1S4mMT+A/c+rwwQyAv7QzZKq
         nEppKgH/e+rlyLaIdjsiYr9fTseoeilr3w1VAr5gXfiV0EEy0+0VQElVGzUtvULRs1Mb
         vjjrNOGW159rAosjfKjJoff/l7rKW+ToJYgg4+L5ocqcyZkIy77X/Rbrf4a8rLY7+V36
         GheFQmP9qQP4Nz8xYbsEwY/PmQ/gp96r8GWSDvNMYm8512teRhp1TGTbIgpEihQvGKL2
         rlVgO3bU2LAyryvTP1dp+tnPYj4VV/WRBl4o/V7Q7a95NRwWXWJOidENn1PKsOFQUAGO
         xkPA==
X-Gm-Message-State: APuU4Z/D4Dc7ZCHsteyNynwQ2sn4EIqJxgPOoT+rpjl538kS1pZyRsJh
	UJoMAi4ybJK3zcN5q3YUQQRpR2FAM0m2FcIvZQAWO/4nl0lwwYbFpmP6TgWl4W+RJTMNaEdYZsk
	j5A4VfvdNtCSPOJ/Tq28iF0OBQtbMR5L3+KZcOB+phw==
X-Gm-Gg: AYBFou32ekurQUI1sUlRGipBmIfZE2lwY1HHxha8elVXZT0TtpfszOrh24Aa1ZwugYc
	uhhI4pebslLB3GM0nobvm9UCT2VoW8WCOf8j+QV0vKwLxt9pjB1En37i4rrFYfskLwXeysovzZn
	3LV64iiz5jXg/OOn14V/bONS2QTaxkSOkWG6lwpPe2nDqNU4K80jDz2rPvvwNA9gOmikh7D8FSr
	+XRz7UB3tyIyWHsykb7znq5lnpgNrudJ/+cdfPs2Uet2eAJOFpUM/1Q1Y/sE7/srBA9JtceWy1H
	39BKWOxEuCqhs/HEtxGWJIWM2K7fIRefuKNc8V9ToOrdGjydwJu8VjWg0eMOIljhaXC+dsf/XaV
	LiwRuMZ/mMBRrE54pPd2u5K6i/sq3stvu6/h2csw=
X-Received: by 2002:a05:6808:1494:b0:55c:856:8216 with SMTP id
 5614622812f47-56e64ce3f54mr462309b6e.37.1794518999227; Thu, 12 Nov 2026
 13:29:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAPy+2=yCzFKxPgzgKw7uCfwpd0BqWk_Mf+DSBY=ydTr_pdHr9g@mail.gmail.com>
 <fc81dd0f-4bc7-4064-97de-3b1af8c529b7@linux.dev>
In-Reply-To: <fc81dd0f-4bc7-4064-97de-3b1af8c529b7@linux.dev>
From: Konstantin Yagola <master@spicebrains.com>
Date: Thu, 12 Nov 2026 23:29:48 +0200
X-Gm-Features: AclHuK_asXhVDQKUit4vjoEY-G7m1l3yW4ErGDI9FFBzleNM7_lgCj7iBaNfmMQ
Message-ID: <CAPy+2=wLaLiPhWeF+WVFG==+oiDJx0AHhHTQN7OaEL6_xQ6gLw@mail.gmail.com>
Subject: Re: [BUG] alloc_tag: GPF in __pgalloc_tag_sub() during hibernation
 snapshot, page tag ref points into .orc_unwind_ip
To: Hao Ge <hao.ge@linux.dev>
Cc: linux-mm@kvack.org, "Rafael J. Wysocki" <rafael@kernel.org>, linux-pm@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 590E01C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: ybiuawcmmmpreztfw66xa798qzryncpz
X-Rspam-User:
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794519000-373260
X-HE-Meta: U2FsdGVkX19NEMJoPNIPE9j56JZtVd71nca2f/inBdD98VFnHPnnLnjM9CUIAVjR1Biq8enER1fXiMdndoc9EyJtks/Cur8F+x1AOv9Cs7EaPf7ZSIA37EjhoWVrfXpPwoiJfBZCnWGjpFqghSCqVyabQs2gg2OTDI8QLwlrPGbCGObERrB+skzjalZJeQHnX+pf6XsBwMCiH3HQ3NDc4xIqN72Pkbe1e0yjYGVRq/fXRjSFGNNi01mnIBetbX8lrcdXDeenuTyB2IffjhnkjK/hWzJYBLycv06lXvD2JmHdwp9HljIbG/cuTU1cjxV/M6txpeWiJ58mDeLAEeAEOy02hXGXZW8qVBUvtwWflCvyodUayMwTOVZwqEuXk9dtdcGWXgJBzuas6Dl8AEhcVk3Svxkz1BUCernFxZuUmZ4ccOT29oovYSp15IR2qGMxs9MfdRO73txzvDJqtzvmI65xOOiZg0XMzHqvL2hTQuROjyjC9SwYH3cWHAAoSwSD6H5JDX+8vwmPEytdFoUFLeGP5QvICU/qWJVMLMXERJrQNsiw/gZCipuEAjT/2TCKznvvO+S3GuCvEas9d2koAqjvoZGWuPJ2ap7dL5i/9QYGvJuz2cPWjTfdG77RLuBWitRvpBFLhMxVr5coQGtIhGsDGrfS8N1Av3LrHjGLrZzacg3bczJC8qKs+m/UBB+Q+IO8lv4v1BKm9Ntx7ouwQZQegnmEbuxWtVvrmxO96f0+DuJLU/GM+2CzuJS23YJtn9AcimOXaNIDkeWjyB09z+vCR65ssdTkmRNCyBfIKtvXIO+7ckaZ3ilXLc3O9TWj1kEvMIn44CLichvGu/E/TPI5G8RchHGpHfReqXH4UtbXXdat6ds+LAeV3qai+7NUCafyxVbV95wFzyQ3eqt7w0K1oIP87JQBm1bY8UsujCJwNWNfxlr8Yy1T6hg15Y20JOzmXzQJw0vdOu2lsxc
 xQ1pGETs
 5xoFpvKClkLxOd/korCkry/6hrJ+PvE0tI1h4dBAh1Cq3FZl4jnHEB2ZZ+1UtTDXSU8Nr9OQf+pWOTYlF8+u80y9orVSOMCAbjII5iQxHfa20/mWnFYHvo8fHDejuwHfw1eNgM2ZF7rrnqIV7Ntf3cyhLt03iVgH58/NWT0v2Q1yF38UehA3fRy9l3Ag+wg4c61sWPLZDi6cEB/wNCvXB/0GZ3YPTahboKCjcwM4sD+cXmzZHBoqYsrhFPoejcBzy6LWlXu3lP/LduxX/3AO6+LrSodSLZ67TlWj3gDv85htW+4PmRg5CkdBO1JYaL7qPrjDd1441cdoblmQaXVjOr6ri3nhj0NUb2S9BCOfztx8N82Rf7Nyu+mZ2jdSIc8vG5TFT0TRl2zGPaYU7NQNQgct+wgNgYd5JfyuQNiOxHUHh2OGwhmDE0WKUtpsGe8kYJ6ynSOfhMFICieBae1wbrhU6O0qGNaPewo25ptkYLFJ1CBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hao,

thanks a lot for looking into this.

vmlinux: the crashing kernel is a NixOS build and is bit-for-bit
reproducible. With Nix installed:

    nix build github:NixOS/nixpkgs/08d3a97586f6b6343b3b5e799980773629432610#linuxPackages_latest.kernel.dev

./result-dev/vmlinux is the exact file (with debug_info,
BuildID 8ceb20655c1e3f720b1b317dd5153cfe47001db2). It is prebuilt in
cache.nixos.org, so it downloads (~256 MB) instead of compiling. If you
don't use Nix, tell me and I'll upload the file somewhere.

Config and dmesg: I'm sending you a tarball off-list (too big for the
lists): the kernel .config, the full kernel log of both crash boots up
to "hibernation entry", and the assembled pstore records. MAC addresses
and USB serial numbers are redacted, nothing else is changed.

Other clues:

1. A correction to my first mail: the 2026-11-07 boot had four
   successful hibernate/resume cycles, not two (pstore only kept the
   last ones). It crashed on the fifth hibernation. The 2026-11-09 boot
   crashed on the second. No crash has ever happened on the first
   hibernation of a boot.

2. The overwritten entry is not random. In both boots it is a valid,
   KASLR-relocated kernel pointer to the same image offset
   (0xffffffff835ac1f0 after subtracting the offset, inside
   .orc_unwind_ip). Whatever writes it seems to write a real kernel
   address, the same one twice.

   With debug_info the registers read as follows (faulting line
   include/linux/alloc_tag.h:222, inlined into mm/page_alloc.c:1288):
     RBX = address of the ref slot in page_ext:
           ffff8f220292fbc0 (11-09), ffff8c3003325680 (11-07)
     RDX = the stored codetag pointer (the bad value above)
     RCX = [RDX+0x20], i.e. ORC table bytes read as tag->counters
     RAX = -4096, so an order-0 page was being freed.
   I don't have a memory image, so I can't tell whether neighbouring
   slots around RBX were overwritten too.

3. A suspect from the tainted side: the proprietary nvidia driver
   (595.112.07) takes part in every hibernation with
   NVreg_PreserveVideoMemoryAllocations=1. nvidia-hibernate.service saves
   VRAM before the snapshot (about 770 MB written, 2.3 GB peak memory).
   I can't rule it out as the writer.

4. Every S4 resume logs "spd5118 ...: PM: failed to restore async:
   error -6". Probably unrelated, but it happens on every resume.

5. Since booting with sysctl.vm.mem_profiling=never there were three
   hibernate cycles in one boot without a crash. Given point 1 that is
   weak evidence.

The crash is rare (once a week or less), so I can't reproduce it on
demand. But I'm happy to run a debug kernel or extra options (for
example MEM_ALLOC_PROFILING_DEBUG or page_owner) for a few weeks of
normal use, if that helps.

Thanks, KY.

