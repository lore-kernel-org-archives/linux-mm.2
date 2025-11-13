Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4BBCD4F2F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 04:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E828E0005; Wed, 12 Nov 2025 23:40:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EECD8E0003; Wed, 12 Nov 2025 23:40:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B63C8E0005; Wed, 12 Nov 2025 23:40:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4424E8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:40:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF96B5B205
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:40:37 +0000 (UTC)
X-FDA: 84104332914.17.ADA6FF9
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id CB1E340002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:40:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GOJBbV5g;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763008835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDmPn0Nf9DwhMNzLqfPhzr9P36pEvch2Q8c/oMsgpUY=;
	b=GKalfVjL5pck4VA7fUUTI9H/MsKV/o9iSEzCKaPraCz2DgF/1sH03DfFqEXLOvIET6KW3c
	e55rYdRgKuwFfFZy77BGQMmn53QAfNNS8tnizIkuFxcBubwdGVUeFXCI8bIVHhPULVnIEs
	zqdq2krNjEs2DbrEAAl52PgiY7nDgfQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763008835; a=rsa-sha256;
	cv=none;
	b=FqrO6Jz1ONPXIdWcI6oUN15qz+30X4FcI3F+6n8aS7tXLvJXT16SsfylmIu8imFi8MqSzB
	TPlzWul9EEj1DXkTkyPCA/1ZYpQ1XE2hCBrPZeMl/6YbInGJSyPgmPk5dZ8AdWilhq9bks
	1SEY3qhQ6e76mxzQUMut/So/sboW1uw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GOJBbV5g;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-297f35be2ffso5422475ad.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763008834; x=1763613634; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FDmPn0Nf9DwhMNzLqfPhzr9P36pEvch2Q8c/oMsgpUY=;
        b=GOJBbV5gb7XB0ThKF8Onu+WZPDkb2yNeMw6U8m/jySJCIAFPnjFBiG/hIrDo9MbuUN
         EwThY08Vyky5RSHj1l1ZoCWsO5wgl3MXpiKgeekUFBS7j/5teEChlMnbAieCrjqJAMaU
         FHHyic5S4VzSYqHOUlLzgQQMC/wGVXGWeqxhwPjrNsruz2BqI7/RbUQ7EimhhLPflXHI
         zkbEjyVJzvp/+nXYkP7+2Bq/9knnaSgAOAhNMNOKgaYO+AoKjlJFr3dVgbueRF/Y5iNJ
         UYeqtSfnOKuT1gXkbhJgxCzmZst1aeHVceLn+vxEN3tS1PkVuUyAFLFF2DQSCfAdtrDK
         moWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763008834; x=1763613634;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDmPn0Nf9DwhMNzLqfPhzr9P36pEvch2Q8c/oMsgpUY=;
        b=TYbeCbucX4MIwkgSpRMpg36NlnczygwGjLg2QEtQehde6NXxcozuu3znmE0e2MkK+h
         b4U/xUmkN27vdATM5t2ZVnXJk2gNqObvVECsPRKshCvmqbOl83S+ahYa4SYmsPPdp/Vl
         WgxplMqR9oN+oyrlLDg1RKoeHgXcPry5cUy4m1z4YyCbaAMTIPPRa42apm+chXblMfye
         f/excCLnFMatKkShObObG4FvtETXPp2Rei7qvPjVICKmra350E0lUelzXYweIlvlu5rv
         HiXxfmIscXZo4JxoMc1UbxbNl4MBWCtxeYFCSJ6ljlZMgpAgCzzNH9NfpLeZZz+91qv4
         mbhw==
X-Forwarded-Encrypted: i=1; AJvYcCVSAbeT/iJgdQqjXRVPArqxSGCx5qptpSD69og3/pWlumHFiomUXHmfmWATwqD5r1dir2GDhEq4cg==@kvack.org
X-Gm-Message-State: AOJu0YwD4yhvb4b3Elxz96ni0EFLtTfwEeOqVCseG7zPRjXNqMOuTK5M
	V3OTSRct7T+yKnAbmBgCcC92raA+/nkfW5MsoAB8619SCKdNmNcJSUz2
X-Gm-Gg: ASbGncsTEApNNZobf8FV/7wF5tVBiI9GrmpeLk8VHiyNNf6a3py0v2TXvrSYH9g7/HP
	AP0XFU1Wawq//5DhB1uHVoJYDGFLRSJsQxThomWomPwBojWrho46EVGvb98ZsCaGo/iO++Li/pY
	ELkEdayn4/sqY5g1rIkMFwY5PfdnAXf/a82VD0HsjXUb39yFAUqtUJDw+Tw3CtlC+kWPgJF2G7r
	qPxAN1EzyC2uq/UPmi/4jtr+7zO9Pk6ybq0v57c8/+8vqY+5sxUxSo9w76pgqE2+REh7g0I5wGc
	g9wlgF9U8Dus4zWNMqlehNIz2MRmT1cssjRzatEI16u6/YUaGxRpxdn2+YABj4BmEl/q6UGqLTa
	/r0E6uR5N7hyxElE8JzFPfg9ns4DMjsiH0MNX4Hqf+WKNAxnWaimDQPem+gs6mzoH/n4t1hTSpo
	gwCf0ZnRh7VV+ZafJOuZW8UQ==
X-Google-Smtp-Source: AGHT+IF0ZSMjJ2Lc8kz3EXKwlmPjL5NLaFbg0SkOYJJftW8mAPB0mC+cHp/6QWluZgrL5V9rxEgvaA==
X-Received: by 2002:a17:902:e788:b0:297:e69d:86ac with SMTP id d9443c01a7336-2984edc8d1bmr74152995ad.39.1763008834480;
        Wed, 12 Nov 2025 20:40:34 -0800 (PST)
Received: from localhost ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0d68sm8683655ad.61.2025.11.12.20.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 20:40:33 -0800 (PST)
Date: Thu, 13 Nov 2025 12:40:30 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev,
	workflows@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/27] mm/ksw: Introduce KStackWatch debugging tool
Message-ID: <aRVhL91rSZXyZ83D@ndev>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
 <aRIh4pBs7KCDhQOp@casper.infradead.org>
 <aRLmGxKVvfl5N792@ndev>
 <aRTv0eHfX0j8vJOW@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRTv0eHfX0j8vJOW@casper.infradead.org>
X-Stat-Signature: 196r1x86ubcwporpator666haks4f1xc
X-Rspam-User: 
X-Rspamd-Queue-Id: CB1E340002
X-Rspamd-Server: rspam01
X-HE-Tag: 1763008835-679847
X-HE-Meta: U2FsdGVkX1/Gl29D5EirwBAmXoPXZ4MfR+BFqbJGvns8Tpy1NyZi8J1WjAYKFC87EUjvBlNEb08ZkJFBeEpo9isJJ8BHrI+r/aW9sF8jbb+qjXPut5Mk2ApagADHePKVxXs3Xjwlk3RckIZRJB84gkBpoML20mSQm7bBSvnfvVygXUo6artjTgvV/2DI2QZeFlDDsmK6LmftQQ0SBA2u5zIELqLjj9JAEjWEIejo9NHLOwfObp4t8+Wq0Phc98jiyyxyb3BnaVlXFsFFTZidNZmw2HXJAifb1y/kuyXY51J8zPRLfB2StyimBnmnFYNTh3nepvqzNqTwKHg+SiT87RLUNWt0CtBEebaXMzxuTOm5R9UFP1dCA8J7rfalNLieTuelGtsyKqgNZpHs4tkC2KNypNjG6eSI7a+BjL7akxMdNlBSrTyHEaASqKdItzlEsYHYkaF8YYlTXv0mVJ4AucKvPX22WC06kVzNoA0+nsrmU7MHloIcMY1sIFRd32qbiGJWKJNtRtvYzx6aFkSASuhBH+hPrDjYlaceZ2FzUkYh3TAJjeR01uj3+zNT735kVw2o9egZBPBFd6JIZOfZ4Wcs4gcy+eQRfk5OglNzQRt4WBJ+KbOmXr5ekksSIu5il7zQ+bQOn3v3O9dUVNYm/5z/5sEatHpRFeFrpyy11QoVWjd2elLWN+tcCzaUIwANCkTQ0591TNIMYk3a7lEELjfTFYJukSzUBVW1WBY5gndbwgiyQfpKsRMTxrcSSeZqu90Q4+KI0KJy8IuLtkuvbdmOLlcjrS6Bv/6XepR1Tgs9O9pToDtVIpqoQVOOy4u7N+4UY1Z8yfK38eQTCOR+NksgOD196XvgluL2LMMHlYd9mSeyPu+IrCx2V/pRbqjTB2t8tzN4csx+79R1J632G7c44FMtEqyUc0k4S7YFwRtPwfRm71eZaPipUFGj51YNdeW9vXvERHnianBKk8t
 RUMnO+fl
 xE0HuWwKjjS2aeRTtLo7qphQuEhEThNmn/hw0VPkgCNJ4ByLG3oXmmefth9OJIqKXKdi2UYUJJX99XnO6DebDjwaFknNz0aIbs9LEGfV+VtLhZix7o5HCa57bJJCorSuFx4uSLchbS6RpSk9kQSKkC656WBKaamCeRKGXCWeKasxilHW2co9wbeuHDFgHjnoepBDRAvtcamaATw3UmJa74Sl+z1oovYYnqQuLLOJBRBtXjdi6UmQDAavou9seWMoIUnSdhOyJfuF9Yk3GjdelwYs8EBz/SofUvmxEkxlCf267Dc2umu8Wezca5fZ2Y1Gqa5ZfKl4Y15V4saUtzmHJS5vbGAsum9DzF3tfCZeXMLpN2tfcyt3Q9sZ/VPyj+x1jpy/16xvRvl5w2wgR87vocLJPMnfgmjPMml1hns5uPRspGUEhKqAm+Uw4tUm0uCYY5i048Q6Z108zyrNjldpEx/IO2oX1IEt6jJKoOTMnNMzqiyjxNM65ijzT872G7ks92XG3laW26bh2/YOMv87DGxqycQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 08:36:33PM +0000, Matthew Wilcox wrote:
> [dropping all the individual email addresses; leaving only the
> mailing lists]
> 
> On Wed, Nov 12, 2025 at 10:14:29AM +0800, Jinchao Wang wrote:
> > On Mon, Nov 10, 2025 at 05:33:22PM +0000, Matthew Wilcox wrote:
> > > On Tue, Nov 11, 2025 at 12:35:55AM +0800, Jinchao Wang wrote:
> > > > Earlier this year, I debugged a stack corruption panic that revealed the
> > > > limitations of existing debugging tools. The bug persisted for 739 days
> > > > before being fixed (CVE-2025-22036), and my reproduction scenario
> > > > differed from the CVE report—highlighting how unpredictably these bugs
> > > > manifest.
> > > 
> > > Well, this demonstrates the dangers of keeping this problem siloed
> > > within your own exfat group.  The fix made in 1bb7ff4204b6 is wrong!
> > > It was fixed properly in 7375f22495e7 which lists its Fixes: as
> > > Linux-2.6.12-rc2, but that's simply the beginning of git history.
> > > It's actually been there since v2.4.6.4 where it's documented as simply:
> > > 
> > >       - some subtle fs/buffer.c race conditions (Andrew Morton, me)
> > > 
> > > As far as I can tell the changes made in 1bb7ff4204b6 should be
> > > reverted.
> > 
> > Thank you for the correction and the detailed history. I wasn't aware this
> > dated back to v2.4.6.4. I'm not part of the exfat group; I simply
> > encountered a bug that 1bb7ff4204b6 happened to resolve in my scenario.
> > The timeline actually illustrates the exact problem KStackWatch addresses:
> > a bug introduced in 2001, partially addressed in 2025, then properly fixed
> > months later. The 24-year gap suggests these silent stack corruptions are
> > extremely difficult to locate.
> 
> I think that's a misdiagnosis caused by not understanding the limited
> circumstances in which the problem occurs.  To hit this problem, you
> have to have a buffer_head allocated on the stack.  That doesn't happen
> in many places:
> 
> fs/buffer.c:    struct buffer_head tmp = {
> fs/direct-io.c: struct buffer_head map_bh = { 0, };
> fs/ext2/super.c:        struct buffer_head tmp_bh;
> fs/ext2/super.c:        struct buffer_head tmp_bh;
> fs/ext4/mballoc-test.c: struct buffer_head bitmap_bh;
> fs/ext4/mballoc-test.c: struct buffer_head gd_bh;
> fs/gfs2/bmap.c: struct buffer_head bh;
> fs/gfs2/bmap.c: struct buffer_head bh;
> fs/isofs/inode.c:       struct buffer_head dummy;
> fs/jfs/super.c: struct buffer_head tmp_bh;
> fs/jfs/super.c: struct buffer_head tmp_bh;
> fs/mpage.c:     struct buffer_head map_bh;
> fs/mpage.c:     struct buffer_head map_bh;
> 
> It's far more common for buffer_heads to be allocated from slab and
> attached to folios.  The other necessary condition to hit this problem
> is that get_block() has to actually read the data from disk.  That's
> not normal either!  Most filesystems just fill in the metadata about
> the block and defer the actual read to when the data is wanted.  That's
> the high-performance way to do it.
> 
> So our opportunity to catch this bug was highly limited by the fact that
> we just don't run the codepaths that would allow it to trigger.
> 
> > > > Initially, I enabled KASAN, but the bug did not reproduce. Reviewing the
> > > > code in __blk_flush_plug(), I found it difficult to trace all logic
> > > > paths due to indirect function calls through function pointers.
> > > 
> > > So why is the solution here not simply to fix KASAN instead of this
> > > giant patch series?
> > 
> > KASAN caught 7375f22495e7 because put_bh() accessed bh->b_count after
> > wait_on_buffer() of another thread returned—the stack was invalid.
> > In 1bb7ff4204b6 and my case, corruption occurred before the victim
> > function of another thread returned. The stack remained valid to KASAN,
> > so no warning triggered. This is timing-dependent, not a KASAN deficiency.
> 
> I agree that it's a narrow race window, but nevertheless KASAN did catch
> it with ntfs and not with exfat.  The KASAN documentation states that
> it can catch this kind of bug:
> 
> Generic KASAN supports finding bugs in all of slab, page_alloc, vmap, vmalloc,
> stack, and global memory.
> 
> Software Tag-Based KASAN supports slab, page_alloc, vmalloc, and stack memory.
> 
> Hardware Tag-Based KASAN supports slab, page_alloc, and non-executable vmalloc
> memory.
> 
> (hm, were you using hwkasan instead of swkasan, and that's why you
> couldn't see it?)
> 
You're right that these conditions are narrow. However, when these bugs
hit, they're severe and extremely difficult to debug. This year alone,
this specific buffer_head bug was hit at least twice: 1bb7ff4204b6 and my
case. Over 24 years, others likely encountered it but lacked tools to
pinpoint the root cause.

I used software KASAN for the exfat case, but the bug didn't reproduce,
likely due to timing changes from the overhead. More fundamentally, the
corruption was in-bounds within active stack frames, which KASAN cannot
detect by design.

Beyond buffer_head, I encountered another stack corruption bug in network
drivers this year. Without KStackWatch, I had to manually instrument the
code to locate where corruption occurred.

These issues may be more common than they appear. Given Linux's massive
user base combined with the kernel's huge codebase and the large volume of
driver code, both in-tree and out-of-tree, even narrow conditions will be
hit.

Since posting earlier versions, several developers have contacted me about
using KStackWatch for their own issues. KStackWatch fills a gap: it can
pinpoint in-bounds stack corruption with much lower overhead than KASAN.

