Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C901FCCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 10:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D77C8E0007; Mon,  6 Oct 2025 06:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE968E0002; Mon,  6 Oct 2025 06:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC098E0007; Mon,  6 Oct 2025 06:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5928E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:47:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D84B59788
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:47:58 +0000 (UTC)
X-FDA: 83967364236.26.AD5CFCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0B5CC0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:47:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DPLvp5HE;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759747677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zm0vWqUs81U6a1Z4cdxFOHbZrkAr8d9nd4NS4Zy9YhQ=;
	b=CkPfO096ENiS2vaGnifLUZLaVRQgdEGWsO7wuVmiFT35yPdrbTj4uRZFvPi2BxQs4/jgXm
	lKXUhfStoY1t+v/eV9PF3jGFS9S6BKTCFxx0h4PHhp7JKpUvtREKwGsZpozRUaDuiwmA/7
	oWSkY/e1F4FdLaTxMe6BG4TWF51Zwps=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DPLvp5HE;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759747677; a=rsa-sha256;
	cv=none;
	b=fPRLRoEHRt9nq0fDirUX5GVt1BIVYHOT+Zb+i+aCjgD3LLor8gNpMgonTdyUfFnl2D+m1E
	1QfiGMO5OeTA8CnuYRsUquhroFJfD7T1Dh3d3pNtD+FgmWCezOobHDaCQP5KnzzZEjWCed
	dN1rUZbsWFEOnFjWD+VnKVdKbZXu5LQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7922A4547A;
	Mon,  6 Oct 2025 10:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A475C4CEFF;
	Mon,  6 Oct 2025 10:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759747675;
	bh=zYprqry9t4ZevNtP8tEWITF5icbe5Cfg3GMohDrfass=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DPLvp5HEFax2cyv0F35o7qNcFd+V3uCO/GgsKz62gZdlgUFE/F/WiLCf22is7pW7g
	 88hQIm6ZXviepsQ+l3vftDMtMwloggKpUSVlPc+q/sz3RJsxRwzvCNyPo8E4U0jMTV
	 Cu3Bz7kD5S7I1KfQIIIQwHkFHysx5c/N+ywPYCYVHdi065jf9lyH4Yls/y0m1Zmb8+
	 Hg5ulviYrgWzJcs7Hj9PclKfTOobNM3EbsHlnSFx3Rv/b0y1ey0EfuqHvpetUrZYT8
	 Y7qPq+tjTDy+KOAI9umWSWK29pbW6gtUX307GD0bsZgGFxSg+JonW7wlsLQxjuMdta
	 kRMecoOh8XSjg==
Date: Mon, 6 Oct 2025 12:47:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: syzbot <syzbot+a9391462075ffb9f77c6@syzkaller.appspotmail.com>, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [fs?] [mm?] WARNING in path_noexec (2)
Message-ID: <20251006-wachsen-zusendung-6cc31055eb75@brauner>
References: <68dc3ade.a70a0220.10c4b.015b.GAE@google.com>
 <202509301457.30490A014C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202509301457.30490A014C@keescook>
X-Rspamd-Queue-Id: D0B5CC0002
X-Stat-Signature: k1jj9ogbh83oa7kfdiiuzdjw3hrodpf9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759747676-191359
X-HE-Meta: U2FsdGVkX18NPoWP+9EEQzPFBuP9YaPZgO2dmz8qE23ym+eXqxZGadvHZJqJ5zfJhASZy2LXdNwxCQ8NXe4KixOG0O/9xLmqBDJP9UMCDXJlQTaUvRugJ0ImEOFGsOILM+F8DxpZs0d0zStAePDqBiZkrY95U0hkA/1gLpPrIhQlr63NO4YZHg3PA8r+dsm/JeZtI8O83wg8u6873CgQBLbehuX8zzouBKo82Wq2KTTMgyC52sc2X+aERKLUMpDEoamocdP36Ilm/AaF2uE2Ni23c7GRldo00uz1UWRuBl0C121YhnjLjBis3+sregNESbZ2zmMacckrxG9wcbFLwUECdZshWpGj5lc/7VmAyXrcOIOYgdwRGO9i/qZcTf0A8TR2x+tw8LGvAo7T7GHKc7WUXNVotbas0wBXQWF/9y8j+Z0DKbWvpBQkhmkQqzDlBOeMRim0Rs0oq95pEMFgyzq0VFXVM1LJN9d9ScEcWGd0rQrSVUbVxQcp//cihCT6uyC/jGaGoOLA7GFyu0V0UEJv381cPh+I3EF3VnrEL3emOI8gDSAWFsHh7TePsa57a3X6B7I/RE1xNCDm/9vFDE0Rr1oyckaNtfcQDFIStx3kde3YKCUUoYewWJMBi4Vp8JFOUpXlP9oKhNeVKetFmU9bMd5/OwFZsIqx3Lwuw5iE7NS+PbYgQaUVrpom782hmTUGAcIcDcxFfzBycigZEf3YJxX7v/32EHfce2xpQrTFua37qbZOKljRFTJskQ2FMNvEBrZDf1j6LXA17zuBR6Nlzb3DNooM56UHbAJyNwpWtPTbMa8RJg4oBrk1K+sF0VJBJ+BVFdNJlNjBHDKTedLOeAn1b4DQTrkbBmKlA8SfdR/oMWYtKsfjWsrAgK2RPGuZD7UuW3DSNJ3flcVpn4x1KCOVFjTRINDOAVbd3Rc/Q7pFNAsmV//jyv2oRlBCOxvDDjYRe08v90vzD4A
 0A4XgfPF
 EyBfBbam4HsJQ27bUi98b5IcKSFSR8SqOIkd/WLHlbFb+e5JE7hpJHKBvUJ8gCR8UtrAXV1Q85ujYBBCROoFzR+uXvdgFaovh9Y/w/13LnXQ9rxK488kgoVZpL51xRjLBTvEZopxiHQ77Cbv7mZiqck4Aa2lSS9LGHuSk2tkx0E2sjIeyvdTsffVUSMuwM6Az+TxpRbdnwLIMsSyYKprUwo82VewMpQdGwxBVFcSFsXX/tk1P6FUt2bW2oX2+FgGksAZ5aVmJwKvppfSt+E0JCVz7iiE3JgYxbAhddEqR0HR1dbm6ykJSJidNfvNc9rDNi93QhpHgjbqz7Os4Hkamaql2AjseXcrAYwS9aO1r3qA0b8EnA+JvQk8B/J5SGLzNppiIyfbDPb2H4VPPp0aKGhQMKz7I2cYscrsHfIlMaOzIP+gmnMI8ZsdF34Q4d6JUZ9OOQPNdUKael5+iMzxVYh0EWHouagMmLg/eCR/5TObczgXkNQGRPciBNOUhtfYwQ7um3r4gUTsBqGw+ypiXTSc0XFkW04pe5jvTuAtgQAhcAhxG185N1zc+YlQq7599jmR+XZHg/YftOIMFXpVJ2cCFKZ2RCmWqwA2eWvZs9NNB60aVjz3r/O8aPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 03:04:22PM -0700, Kees Cook wrote:
> On Tue, Sep 30, 2025 at 01:17:34PM -0700, syzbot wrote:
> > Reported-by: syzbot+a9391462075ffb9f77c6@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 6000 at fs/exec.c:119 path_noexec+0x1af/0x200 fs/exec.c:118
> 
> Christian, this is:
> 
> bool path_noexec(const struct path *path)
> {
>         /* If it's an anonymous inode make sure that we catch any shenanigans. */
>         VFS_WARN_ON_ONCE(IS_ANON_FILE(d_inode(path->dentry)) &&
>                          !(path->mnt->mnt_sb->s_iflags & SB_I_NOEXEC));
>         return (path->mnt->mnt_flags & MNT_NOEXEC) ||
>                (path->mnt->mnt_sb->s_iflags & SB_I_NOEXEC);
> }
> 
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e5fd6f980000
> 
> I think is from the created fd_dma_buf. I expect this would fix it:
> 
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 2bcf9ceca997..6e2ab1a4560d 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -189,6 +189,8 @@ static int dma_buf_fs_init_context(struct fs_context *fc)
>  {
>  	struct pseudo_fs_context *ctx;
>  
> +	fc->s_iflags |= SB_I_NOEXEC;
> +	fc->s_iflags |= SB_I_NODEV;

Yeah, that seems like a good thing to do.
I'm quite happy that the VFS_WARN_ON_ONCE() in there is catching all
this!

Do you want to send a real patch I can pick up?

>  	ctx = init_pseudo(fc, DMA_BUF_MAGIC);
>  	if (!ctx)
>  		return -ENOMEM;
> 
> 
> Which reminds me, this still isn't landed either for secretmem:
> https://lore.kernel.org/all/20250707171735.GE1880847@ZenIV/

It should be in mainline as:
commit 98f99394a104cc80296da34a62d4e1ad04127013 ("secretmem: use SB_I_NOEXEC")

