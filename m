Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D02DDEA4FAD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1254E6B0088; Mon, 23 Feb 2026 06:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2E26B0089; Mon, 23 Feb 2026 06:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17B26B008A; Mon, 23 Feb 2026 06:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFC3F6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:12:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 902598C746
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:12:53 +0000 (UTC)
X-FDA: 84475459026.11.76D685F
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id B3C761A000C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:12:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gBSD+9av;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of chris.bainbridge@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=chris.bainbridge@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771845171; a=rsa-sha256;
	cv=none;
	b=YabGCBp6+RcegGFgYZQfX08d0ELpdSe4fsfuYLIz9y+qEj5+53zAkBW5g9hB0a9LEfEYqN
	gT1naUaohZuwyuAk/jCrDKRUqdeTDa8icq+XfsC9lE/wy4eQmszuSiTkhT9UpcvrfSkLtg
	bptjff/7GwoHk5zRr/z+0iFeHIIO6E8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gBSD+9av;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of chris.bainbridge@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=chris.bainbridge@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771845171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6n+oxOREuT+ZoDytgRh/Y9obuCsnXSbm2faHqHT5nEs=;
	b=x9ggxQ4ARiv6zuCpOOeoDgKG+2E0/me4o7L8duvxw15kNG8hkbNX/S/tQnfeXaMEUfgicX
	59UOYIxVWoEDK9HUT+Anr7uFZG4MUsZXidkQG2gzqUNc0k+HrqxVuJ8uwjUF7EdbGpW8G7
	QrlWG0nuzh/slGJ1hUCw5ILdJrrCKMQ=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-436309f1ad7so3098876f8f.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771845170; x=1772449970; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6n+oxOREuT+ZoDytgRh/Y9obuCsnXSbm2faHqHT5nEs=;
        b=gBSD+9avkf3AhIUUkRftx/fpbhqLqbWVmBgK8vTUHmCRWwWh5ygqdtj6u5i2u89loC
         NzKE3wh9FtkD9AvVya35mKu+nxovh81LWm6RmIa7kuSn8Py2Bg9NU7qMJAzDCiHEmT32
         pzqzFBj3t/Z1/Um020BXrtpJhm1HnooPrblXH1wv3fc1GvUFuk9ETiWnHO5sLapsvDlc
         o5YpoGa4MOLSYjVjCh6S6Y86n09ISNMI3W0XnJOLHWoUeEPCVknD4MIdJd5OFLM216gA
         Xxx18lGtjrt+opXd6BTQR59zUGIx0p2Oiz4YcVQtQUmcxKuIsmYfM7HAiEdgRKpghWbC
         2Iew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771845170; x=1772449970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6n+oxOREuT+ZoDytgRh/Y9obuCsnXSbm2faHqHT5nEs=;
        b=SBaMoJMyotnVjcBgk9aUZu3rI6/2oGQKnV+nSy5vqdxgaLgRkawr3YHDSW9qYOnoXy
         pCK99BnxmE1KjHr97AzUoZBCIYjrT+hDo8EWufswX0HRVdC+8GHowe51h2b/ptmP2UBO
         iW8daJX7oUgn0W6thtaRDokLfvQUPAArKz9ypvGM3MDJinmznuRSVLaSahvV8odsTg7B
         C9oSBSWavMCXmgQrMcZ8RkAM8t0xu6R1NTX9Wq06Wos26jGu5fjWoYpQwiGoevOVX/Au
         7cxExH3YwJw+SPa0MTrm6JRGsLB2IGm1VaoEAYn6pe9WC0faHOkgQsJHZ0aGr38OchWv
         oYjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgRu8hPBpNUEq3kdQ44FlbSy4sdNQrKYZ1QfiLwuTHZmZc4jrcgWCijwqGNNKDgMfDt/Ge75FBkw==@kvack.org
X-Gm-Message-State: AOJu0Yzjh1+f7K3uhTZwFf1YAP5Dp+ihS3dO1JDpG3LZXFbhjks2JdbG
	xxVZGc1tXs9WJJCT7VpfXmwLh95Fq0h7Gt68jBBn2ZvwYRAfWmjHVSea
X-Gm-Gg: AZuq6aKVo4hHuIlPIXdWegYYz1+tVyLM/cKmsC/wO4qwGxFnaeqeyx2YU3n39PwKvyg
	BqRkKCuM18XKPq/+WJ1MWoRKE+H+Rr81qqYw+fCkdbudxXw0KxPBQ1G+Gy5Zxrfi5/2lnUzq/fR
	ylG2unj4ZTsH6isD1A7j+XebfbIAWPQSU4bi6c9Gg+A8P/yxih+/q7BdEfgEoD/JmdOLE36rMvz
	/iWCarrbEoB4Kxyl/PvNwWuBPeJ/qsvxk+LGMSz6DlsQkYNLNbTXnnAgabqyFmwkxzDfxCnEHmv
	QlGVmZct8H5WOsR0thswz2c3jX68gpz/mqO5zNFNbfNQDStAie2G/7VUepUAEDrxVEQa70LSqEy
	31SZt/SX7my+/05KaqZhuz9qMPkymTvcUShHFugqzGPvy11tuAA9xl2HDX8pwhnoWFr85YumHNy
	lTn790N2JB+U2RjD63DJBYRTaO9gBMm+4=
X-Received: by 2002:a05:600c:8b71:b0:480:1dc6:2686 with SMTP id 5b1f17b1804b1-483a95c63ddmr134839155e9.13.1771845169900;
        Mon, 23 Feb 2026 03:12:49 -0800 (PST)
Received: from debian.local ([90.243.35.46])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31ff4d7sm271733245e9.15.2026.02.23.03.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 03:12:49 -0800 (PST)
Date: Mon, 23 Feb 2026 11:12:47 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, surenb@google.com, hao.li@linux.dev, leitao@debian.org,
	Liam.Howlett@oracle.com, zhao1.liu@intel.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-btrfs@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [REGRESSION] kswapd0: page allocation failure (bisected to
 "slab: add sheaves to most caches")
Message-ID: <aZw2LyOjxMc-c3dl@debian.local>
References: <aZt2-oS9lkmwT7Ch@debian.local>
 <aZwSreGj9-HHdD-j@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZwSreGj9-HHdD-j@hyeyoo>
X-Stat-Signature: ofzuyzyfdk7tfj5ixyqxu98ax5mgfhqr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3C761A000C
X-HE-Tag: 1771845171-220795
X-HE-Meta: U2FsdGVkX19KG1SNf2oasLLt4e7Cky5uG3mqofVxHOJzUi4gjLE3Bx/Hy9U1KWZCh06iHjwy58nQjz3BqllUcoaW5VTfo0KHrSHdXVlK0QZOdzyVNkDmLKDeaKHCwLi8djxPAbJKiLTfVN4BiDwj081rkUfvof6UYxc6AwHM8uYSBs1nzWbu1SPep/HZJ17+K0+5QF749lZIcRii0sFmhjlWnS9H8monwT2wwWZCt0ai3/XQ6BV0wnEznhBrMw6EMayvLsFqqCYC91Tnm3i+zEX+hxk/p8fddteXxcIpMZ+b2pekz7jyl1X4Ij/Vc7FcNIRrFTcANnhE682OqI9aRTuBVsEtu3x3TYNc8kOsMF7mPU2jS3xUDOQGzW4A810RphED+oB3q/gEO6Mva92mcB+qKzW41pmyBeLP4Uc4U52IjorQi5C39K+GKos0tO7iUw21zfCCwXHapev9SOdvCVQkeOXOPpPU0mmXuXnHwlMv+n6yOP/Ai3QpGJVeBKRZJX+Mk2g9eTI5fcD/gTRDthDHL73ia2l8ibisohB9PbTeYAzDU70u/7xmSquiZ746L4lrnW+1JxIboFEimt9xZyUqQVltNcw4ppEMlK9ENj+/+DvhFcjgPyrbaTVrxRIXGiJKK61qRsDIZXxGYAK2hrAlv6Xd1c3e9HDH9yRjlJLxpUN48LW426cNZwrPxjqfvXd4Zw5K39m5c4c82bGLwnBAM8RYfF96N2Zp8ocUW5Aad1TCOIYVSoya8n6KkAkAfvUvCuu1mwi0hjB+tHAyoKFscM6PFaqJPkmM56qfDCKFxIR4kTP9neZLJKb2DEJ71kwnoE5y3v27YUS+EUaRn4Wm298VHefyuK+nM1eO2U7jOAFA/JOvM2FKc2YJYHdVfkq36BLKKQDtw2NAHvf1OUSasr/3NEM162SOlSDdTagFPNbiCad2Q6teGJOzUBO10+qViiHdjDZcQXTr1Kb
 /SCjyO5h
 7hr/bMv/A/HgDW77cTS2an7ut/sX9EEg7xetUF+t4jCodRKeooXQ+XQNKIjVQ4l23i4KQPtRCp7wTuPjp6srvY1dJplBpN37j70GidWe+FVpePwuacuajBapCx6VZyLlBgVCkJfVnStPLY0utgmu9pjBOszC0G2jlEkWcV5GNWE87j8cwMHFXoBb1t9z29SNyFZ7cEz/dKznIoOjQlBYGXgs8+vJoPlHhKYB9efHkstGuklDUYwDgO86XYv3HsYMLXP3UR4uJkoG/vrALsuk1POlhjMKksBzmNJspzrewdjpfRGYgkplvidVAIkUF+DEoLdOhf7LEhQPU4jglTSUPmRNzravBbANC077Ovk1OtRwF2+wzmcwB7y/hTXaNZu1HtE1r2BhOehzGSC8AYy8xJJ66+G7Y10sYiPr+/pqqRcVlBQo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 05:41:17PM +0900, Harry Yoo wrote:
> On Sun, Feb 22, 2026 at 09:36:58PM +0000, Chris Bainbridge wrote:
> > Hi,
> > 
> > The latest mainline kernel (v6.19-11831-ga95f71ad3e2e) has page
> > allocation failures when doing things like compiling a kernel. I can
> > also reproduce this with a stress test like
> > `stress-ng --vm 2 --vm-bytes 110% --verify -v`
> 
> Hi, thanks for the report!
> 
> > [  104.032925] kswapd0: page allocation failure: order:0, mode:0xc0c40(GFP_NOFS|__GFP_COMP|__GFP_NOMEMALLOC), nodemask=(null),cpuset=/,mems_allowed=0
> > [  104.033307] CPU: 4 UID: 0 PID: 156 Comm: kswapd0 Not tainted 6.19.0-rc5-00027-g40fd0acc45d0 #435 PREEMPT(voluntary) 
> > [  104.033312] Hardware name: HP HP Pavilion Aero Laptop 13-be0xxx/8916, BIOS F.17 12/18/2024
> > [  104.033314] Call Trace:
> > [  104.033316]  <TASK>
> > [  104.033319]  dump_stack_lvl+0x6a/0x90
> > [  104.033328]  warn_alloc.cold+0x95/0x1af
> > [  104.033334]  ? zone_watermark_ok+0x80/0x80
> > [  104.033350]  __alloc_frozen_pages_noprof+0xec3/0x2470
> > [  104.033353]  ? __lock_acquire+0x489/0x2600
> > [  104.033359]  ? stack_access_ok+0x1c0/0x1c0
> > [  104.033367]  ? warn_alloc+0x1d0/0x1d0
> > [  104.033371]  ? __lock_acquire+0x489/0x2600
> > [  104.033375]  ? _raw_spin_unlock_irqrestore+0x48/0x60
> > [  104.033379]  ? _raw_spin_unlock_irqrestore+0x48/0x60
> > [  104.033382]  ? lockdep_hardirqs_on+0x78/0x100
> > [  104.033394]  allocate_slab+0x2b7/0x510
> > [  104.033399]  refill_objects+0x25d/0x380
> > [  104.033407]  __pcs_replace_empty_main+0x193/0x5f0
> > [  104.033412]  kmem_cache_alloc_noprof+0x5b6/0x6f0
> > [  104.033415]  ? alloc_extent_state+0x1b/0x210 [btrfs]
> > [  104.033479]  alloc_extent_state+0x1b/0x210 [btrfs]
> > [  104.033527]  btrfs_clear_extent_bit_changeset+0x2be/0x9c0 [btrfs]
> 
> Hmm while bisect points out the first bad commit is
> commit e47c897a2949 ("slab: add sheaves to most caches"),
> 
> I think the caller is supposed to specify __GFP_NOWARN if it doesn't
> care about allocation failure?
> 
> btrfs_clear_extent_bit_changeset() says:
> >         if (!prealloc) {
> >                 /*
> >                  * Don't care for allocation failure here because we might end
> >                  * up not needing the pre-allocated extent state at all, which
> >                  * is the case if we only have in the tree extent states that 
> >                  * cover our input range and don't cover too any other range.
> >                  * If we end up needing a new extent state we allocate it later.
> >                  */
> >                 prealloc = alloc_extent_state(mask);
> >         }
> 
> Oh wait, I see what's going on. bisection pointed out the commit
> because slab tries to refill sheaves with __GFP_NOMEMALLOC (and then
> falls back to slowpath if it fails).
> 
> Since failing to refill sheaves doesn't mean the allocation will fail,
> it should specify __GFP_NOWARN with __GFP_NOMEMALLOC as long as there's
> fallback method.
> 
> But for __prefill_sheaf_pfmemalloc(), it should specify __GPF_NOWARN on
> the first attempt only when gfp_pfmemalloc_allowed() returns true.

Is this fix sufficient to do the right thing? I tested it, and it does
appear to prevent logging of the allocation failures for my test case.

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index d0dd50f7d279..d2e1083848e8 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -641,7 +641,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 		 * cover our input range and don't cover too any other range.
 		 * If we end up needing a new extent state we allocate it later.
 		 */
-		prealloc = alloc_extent_state(mask);
+		prealloc = alloc_extent_state(mask | __GFP_NOWARN);
 	}
 
 	spin_lock(&tree->lock);

