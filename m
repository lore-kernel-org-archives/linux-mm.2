Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2892FF588E1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 15:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6393B6B0005; Mon, 20 Apr 2026 11:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA0D6B0088; Mon, 20 Apr 2026 11:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527716B0089; Mon, 20 Apr 2026 11:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4298D6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:05:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D00AEE56A0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:05:35 +0000 (UTC)
X-FDA: 84679258230.05.91D9665
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A05F7A0014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:05:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3U3twt5;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776697534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZDajwN8h+CL1MQszF1BlglSh2vpB8Y3M8aLlxS+8+8=;
	b=tZg90KbWtDJdjiKxftxMMMTrxv98QhYARwGRZTrZ48dp/RkxGCbC/AzblnzK3gsMbQXJzO
	izwiWJQfmM+Nv54JwQNealBQR03FhJ1dv+K2K6ZQdVM+CCTnBbRUfTUWiO8p6Ro88QlB48
	Q4dZPyTer3lIDZM/edLvMwvaquZf40k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776697534; a=rsa-sha256;
	cv=none;
	b=hJHDYH3Nf29EGbUb4NG2bFj+SUNCfjETS+dL2hcR12X9V6gOEeGBAhek81B580eXmhQZYp
	MhH2mV7S3aMjW55fHUSE8SKgazEG8j5oXRhmSfludPJkKmwxV3T7nJrEIYgkPwVH0yfqL1
	uRUt5gZkNKOgwZ6ksD1RcnyhM1feUAA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3U3twt5;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3680D40E56;
	Mon, 20 Apr 2026 15:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE406C19425;
	Mon, 20 Apr 2026 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776697532;
	bh=9bLC3fbNgVoVZV+KFNSikVGR7fHetTFRztZOfON4clk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q3U3twt5iJWmmw2MWXIcVTyCgRT4dp3vXi2ud2ujX6nxbgeWsfyYTgInJSedCkuN1
	 fHAjs5kf3LUKgwzgxoxgAhKIew9frlQ+AwERh1twDt3eIezYZ3ynJel3S/btyNmsCw
	 Gaw1V4Fk/smkK8FgNHASbXOZIDxVbxe6rHS4I7S6CYfRHstyee+q4spnvhnTavJRY9
	 /m5v9hrkwwnficPNXIPFvCP1mbQTvC1ju6Ub3dvm2YUFz9SDn0ahJvqUzSmebGLfnJ
	 /4JrnngWFfqW7H57T9jmRDxg6Us21z5pQHVuze1QRow57pNRcdBdZPglZEAEMRXjV2
	 UoduwH/7E4bRA==
Date: Mon, 20 Apr 2026 17:05:23 +0200
From: Christian Brauner <brauner@kernel.org>
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <20260420-zunehmen-eishalle-3a5084c66375@brauner>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com>
 <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
 <CAMw=ZnR0uVrHUNzNGu5BtZuSKDJAYmZGUX-HzSw7c4VnoeQgiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMw=ZnR0uVrHUNzNGu5BtZuSKDJAYmZGUX-HzSw7c4VnoeQgiA@mail.gmail.com>
X-Stat-Signature: 4a7g8qpnb1jfcffkwb4g16p1z3ocqs5g
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A05F7A0014
X-Rspam-User: 
X-HE-Tag: 1776697533-833031
X-HE-Meta: U2FsdGVkX1/Ck36+PuUWefMoFEs7X7Zt9UfcU8wNij3ScSZyAXEEu3E3qozrF7+gFe3kw3lWOzU54mOlnSe3+7Qb8hifapo2iYKfPWExaPyRkOUXzNMD22Phywx6fg3ZQPW9yAeUgcIPhp0xv52OYkQ5O16Whl2xMBCKAuMol82keYCX9PCrfrthzVkYUNfvHsufVbUhuCKGsYWacgymKJSajYoQ6/x2F6yYH9rF3IDgNG7OqKlsRAlqz23jKVB3MWc1p0zqAmuLWVLxsPlImY3wanPOm4XEwGUvC69Wx6+0tqXoiXhClSYBqHI8fOu3Ei8yEKprDZZ5h6UOpsVWqtLfq8H1JggCbfS2fWNKpH4Mnp9sg2zmDbPne9qGmpkYjiBL7hvZ58/IExl8A/0fa1VDPP0g8Bbz0PKSfdbeQiMzkNbqxnAobbBkl5Au3pOVNXOYG5u1urU4woeo3MaWyv/FsGMUqXKvh+Yome6uA0ntaA0hLqa4TY86SONxd0KbivUL3GbStaCObYoYxYA+DewZS7Qb1o0zpFBS23dEZnvs9YkGTr3LdJnq4d5uSSr4wIs+yJKYrDGV+szLWOKcxZGyfJXoV+k3cFmG7IWqDiF3sNTHLwGpKHsiOnpJ3oLKV49w9RIRjpLjbi8q4cW8FRzZWZeGGeafd9OFNCDMza+vUQqLSDxkFIgCJQtBIVeW+3kzbwfnQVBeuPRHL47UMEEn7axAo32xjtZMXplW4Pw62N9xtCPuWIm3UzQ5hAqzyPlw1wMQWXkwTODLbh4NLOiCwQbKntgWyuFP/yZLbM0KXUJL5aGpKXN6DDpjvvNsCInxudi1FvbHoXSyqyibRYp35f+aziVspuUluCKIedAzXyXQivwZ0tky6cdUT9COoCkxbonwop6CvfdABGR99KRc17LeRZQw9PoBObRuFOUPr5ey0wzAvRepgRGkDGQ619UysbiVNQuLTuLYiH+
 HBmdO0Tc
 vnPVy+IVMPjRPNrPJy+BxDZ8NXRHR4QS3ahbXbM8ByyeRUeDTDPzyybBQTqvxHN4IMqsQCfAniowSj/25c7VnOVBPSKCWrgGFVTFNk0cNGNjWPIqtFh2YgpZ15/XxwlCvv05yspDFeb9GTd1PMQI2IfMfZAA3Bqho9DA3jUQI2OigEO9qv7m09a1lUmMzlIhLEveGIdov+Aaf/skwkIplERa/JNBLz+buS6DZBvw1bD+ZpSZFPxrla531SRKWrGGI9pOAkY/e6wnWUW8HlfcOCetxfbk7LV1KlLs2BGLe4yz0QhjgN8ItlvkHaS1CeE0zpNEsUCfimevmBOZfsZK6QOw5Ln5fnBa42+F6vSN5DcKUfcBPuCDbjFxmAqTOWaCEKGcgIJvgx1rPjvDB62nY3qh1ZbCT2l9yB6MxUvGwxNA6PpINDbgNIhGg+WIctVYJrwF1qDZKYVjVqKs9QmQWyEMsKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:22:03PM +0100, Luca Boccassi wrote:
> On Mon, 20 Apr 2026 at 13:26, Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Sat, Apr 18, 2026 at 05:28:20PM +0100, luca.boccassi@gmail.com wrote:
> > > +}
> > > +
> > > +static const struct dentry_operations luo_session_dentry_operations = {
> > > +     .d_dname        = luo_session_dname,
> > > +};
> > > +
> > > +static int luo_session_init_fs_context(struct fs_context *fc)
> > > +{
> > > +     struct pseudo_fs_context *ctx;
> > > +
> > > +     ctx = init_pseudo(fc, LUO_SESSION_MAGIC);
> >
> > I'd just call that LUO_FS_MAGIC.
> 
> It's specific for the session fd, so I'd rather keep it as-is. Pasha
> what do you think?
> 
> > > +     return 0;
> > > +}
> > > +
> > > +static struct file_system_type luo_session_fs_type = {
> > > +     .name = "luo_session",
> > > +     .init_fs_context = luo_session_init_fs_context,
> > > +     .kill_sb = kill_anon_super,
> > > +};
> > > +
> > >  /* Create a "struct file" for session */
> > >  static int luo_session_getfile(struct luo_session *session, struct file **filep)
> >
> > Luo is going full anti-pattern here. This whole return via a function
> > argument completely messes up the later codepths. We don't do manual
> > get_unused_fd_flags() flags and then file in new code, and then fail
> > in-between:
> 
> This is getting a bit too complex for me and it's all existing stuff,
> so I'll leave it for Pasha and the other maintainers to look at later,
> they are CC'ed
> 
> > >  {
> > > -     char name_buf[128];
> > > +     char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH + 1];
> > >       struct file *file;
> > >
> > >       lockdep_assert_held(&session->mutex);
> > > -     snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
> > > -     file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
> > > -     if (IS_ERR(file))
> > > +
> > > +     ihold(luo_session_inode);
> >
> > Right, you're now sharing the same inode among all luo sessions. So
> > you've gained the ability to recognize luo inodes via fstatfs() but you
> > still can't compare two luo session file descriptors for equality using
> > stat() which is a major win and if you're doing this work anyway, let's
> > just go the extra step.
> 
> I'm not aware of any use case for this, it wasn't even discussed, so
> I'll leave this out for now, if the need comes up it can certainly be
> revisited later. A singleton is nice as it saves some resources.

I've almost written the code for you in my first reply and it's also a
literal 1:1 templated copy from what I already did pidfs as well.

Let's do things right from the start and not taky nasty shortcuts to fix
one minor urge without having any foresight at all. If you want to have
an actual tiny filesystem to identify an inode type do it properly and
add the semantics to allocate separate inodes and get all the goodies at
once and make it possible to maintain this properly.

You will need this for so many other reasons than inode comparison such
as lsm integration which definitely want to end up managing this. None
of this works with a single inode. This is not difficult.

And this cop-out would never fly in systemd. I'm regularly sent through
15 review rounds to implement 5 different approaches to the same
problem. So are you. Please take the code I've given you and simply copy
and paste it over what you already did and solve this correctly once and
for all instead of hacking up a filesystem for a single inode so you can
define an inode type.

