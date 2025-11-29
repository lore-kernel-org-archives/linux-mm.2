Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A891D116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 23:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144C46B0008; Sat, 29 Nov 2025 18:52:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5E06B000D; Sat, 29 Nov 2025 18:52:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B206B0010; Sat, 29 Nov 2025 18:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE95C6B0008
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 18:52:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 745448AD24
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 23:52:25 +0000 (UTC)
X-FDA: 84165296250.27.D2BEE87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8224C000A
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 23:52:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hSjXDZj+;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764460343; a=rsa-sha256;
	cv=none;
	b=ZgbL8wzfgZMzqcymPH4Oka/cW3I8z9Gos/KeEPijxKwf5rsdjWIO2AZ99PIq3pA+UTn2/7
	qfnyGYelmSI5TRIxYrc1GFAUt2wE6pYr5/VTCUt5P3VrIqVeqj5wNtAXSMRki06DYZo3GP
	2ZxJE5OOQoV/1uOb6ZV+puC563uon1o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hSjXDZj+;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764460343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfZckenhMuXD231Fz6v7PcFgjhOWMu6S8nbNrpeymNs=;
	b=8N98PRsl3jtHgKd65aXvhcQDxMCsoea1k1sIYK4urDXgi4r6yDi33JmStwgfzWRkBHAu6H
	g2BZdCy67GBTytldZH1g9qQA9PvKBG3YISmnVbwuU6XXzH7jSv2QFtlNz5qcGlspnZG+Fy
	qkRxTeYXNK9411ZWCizrvKPEvEEJd9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77827418AD;
	Sat, 29 Nov 2025 23:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235C0C4CEF7;
	Sat, 29 Nov 2025 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764460342;
	bh=qVPWlVjvpb0UuzT37RNPqMRwPxLGb10vEoArGeVrm+M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hSjXDZj+qlpkPD4xcMBERy+q8lNcf0KWi4bJNb6mni/AAdG5mh5nLiJ2C/ewkE8o4
	 IFVsba9646eWevC6hTF2UhItCD4lM74Ut2NwvSyLwsL7p+Bxoll9P5eCXyOi4t3nzI
	 VM5F58L16lzvNylU7SMsMaRTXNp5COWZdKpoSS0I=
Date: Sat, 29 Nov 2025 15:52:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>
Subject: Re: [linux-next:master 12118/12398]
 kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is never
 less than zero.
Message-Id: <20251129155221.d5f3c519747d8d492aa17462@linux-foundation.org>
In-Reply-To: <CA+CK2bBJmj3nK4QhAC5pr+5nS0vRv_5cOxAr_mohC+YreiZPcg@mail.gmail.com>
References: <202511280300.6pvBmXUS-lkp@intel.com>
	<CA+CK2bCmp4gjpyND2=Chdz-EfRAF20unYzO2dwQb+ZTEihgk3w@mail.gmail.com>
	<20251129120040.fb60e8a35d54d66c0bdbdf33@linux-foundation.org>
	<CA+CK2bBJmj3nK4QhAC5pr+5nS0vRv_5cOxAr_mohC+YreiZPcg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8224C000A
X-Stat-Signature: my6wnkgeqtk9gcb4t7uk4x8r5zxwkqcd
X-Rspam-User: 
X-HE-Tag: 1764460343-488463
X-HE-Meta: U2FsdGVkX19dksuL2MqYoqQ+aT4W+ZTILczuP4UtRVMCpHdMsUGHiH2rhXQsWyZc9C5sUmesTFp6N9TqkuxsV3TKR2+uQy4jtWEcfAGLJ9zW4SyCeb9dtkhCL8Wi3Y/GBN4WL/+CtHAw9jUQ0CF88d79XXAGZNY0p4DHQV9kZollCYKVuh79kG4dP3jyA1vo6fp9ONcV6mtkGTeySnMzoOr6TwonugEPCWz/ZvLvk2jNS8XSI6C9C/wGHlQLcMmsHSiMLi2nUIPTFzx9jNuTwtv3u0+46pdfWcBq4ufQNx3J04VV9ThEULXndMSb0t5JIiwXVaDoawPSYBdw8fQKP10PwnX/SPxFppDV11nqQbvsv4Nsb4jVaV7vziiDMgTZ70DhqGyUDkW4PcNmThZ02hoEX/csVGf9T85p03fMF57gyWTQxroD4iI8SqcZQ9V9WvwZtf35R+OKH8lD+r+HXZJygfZH8mDj090EQsxDGN8wQhL/vgoaQdfh9lFsGFPL1tebjUtlze0+2Xe7Qrwb359zISKW4qCCU1rqsOiULvZ4UPOPbkXu/79VUKcCOWe06cjDeuUFLbFxc2uQtwoVcaMTZZYHjMRPR2TTqdD6Q9yLlQzIJZzuYGy3mqv4V6Lua204sMwDmoL7oS0d3JPD1uiWDJIaLOBub/BozreIhjG2+FDSUeUafR2hJOagpiP8y4JPYg2X8T5LjLaH+TBlzc1gy8g+vdaoWQVqVmGy7C8g2y6Lddnx0Zumym85fLBzdWNLXrr3c0ceDWv/OND5okZEWiSLUXmVHm2Uj6o1tHCHB5Bvaq3TMtP1Ke+EeG6B9Ty/xFg+U4smbwQItDkIFSbY7/Fh2fWVAzZkraZv3/bl5ZzkvXmtpKD+C4RWCUOAu6AFSWIAnlZtZOXIyIpj0f2mXAjerATlfT4ZgQJ0So6BtNGIw8rjjb13VbVqQ0pIyvNqeMt+5BKhquvjE9r
 ixC7Pne0
 fuJHTvKmSNqj5yDLGqw28flAxRWAkc0wX7SXlGsZDxaIcvCT2hNvmAMWzm1LLfGxr0cvmadPQcgAteRmBHdq1SKtqeHcLsC5H5+VLbfOM9u8u/yCxXYxzUGdh8fiKovwXOf3xDc9QYa4o2yvHwIqLO2MdGGXo7VwtGSRAmvEA5rbU5iW8x/W6mTnhFXA+foNS00OQhnKAfROTfdYs6EPt3hx/s0L3gUh5ET+Je5w/mWfUnuudq8z5a5OObqJxtzLD2cGJZKg3IwOj+LPXW3q6A7QznO40N0CWuu7+I4dSVyfPeO7MbVIly1FRbvLGLZjiHOimntYWPWWKDwRmzKLnsun9xLrCMdFRoV8G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Nov 2025 15:20:51 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> > > >    393  static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> > > >    394  {
> > > >    395          const struct luo_ioctl_op *op;
> > > >    396          struct luo_ucmd ucmd = {};
> > > >    397          union ucmd_buffer buf;
> > > >    398          unsigned int nr;
> > > >    399          int err;
> > > >    400
> > > >    401          nr = _IOC_NR(cmd);
> > > >  > 402          if (nr < LIVEUPDATE_CMD_BASE ||
> > > >    403              (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
> > >
> > > This is a false positive. The logic is designed to work generically
> > > for any base, similar to how it is handled in session ioctl and
> > > iommufd ictl. The warning only triggers because LIVEUPDATE_CMD_BASE
> > > happens to be 0 in this specific case.
> >
> > This is a difficult situation.
> >
> > In some cases smatch has found a bug, in other cases it's just being
> > irritating.
> >
> > I think there is value in smatch occasionally finding bugs, and to
> > support that we should try to rearrange false positives so that smatch
> > doesn't report on those.
> >
> > Perhaps there's some way we can do that here, without uglifying things?
> 
> Yes, we can make "unsigned int nr;" signed: "int nr;", should be OK.
> Would you like me to send a fix patch with this change?

Sure, thanks.  It's a bit lame using an inappropriate type but the
world won't end if we do.

