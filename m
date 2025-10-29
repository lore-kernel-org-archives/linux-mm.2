Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2399ACCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 05:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506D58E0033; Wed, 29 Oct 2025 01:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF968E0015; Wed, 29 Oct 2025 01:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B7F8E0033; Wed, 29 Oct 2025 01:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5A38E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:11:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB6F449D45
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 05:11:04 +0000 (UTC)
X-FDA: 84049977648.17.AEDA39D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id F116B40002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 05:11:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=E4trfwDo;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761714663; a=rsa-sha256;
	cv=none;
	b=ziAQA+kkMIq36WT1xoxJuPTcGzn1GS05J7RUUPTf642omdoQvYrbfnxZoKOvTfce16JXnh
	blqScfZ7Tl+pnDaBD3quAEvzBAqapDKJKZwt5od7G6+iapexlJv6/HLPy1j7L/f1ONC9mY
	C9dWSEpuABuyeh5nQk87hpKDGfpO6wU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=E4trfwDo;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761714663;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BYNoVmF3YbRiY0Hi/9O43xTzLl3/EW8MXOY/56GuA0=;
	b=ibkzpx5M7+Th3xE0mxu8NF2Ax0VlUMyG+hyV8Io2uLfrUhLQ0clUPKWHMZ7usl8RkqLUCV
	ZGxHwjFpkCzem2CgpwHqkKxf55RkTdOBH9DtSPlYjiALL3nnplR91LntRN5EsoYzSH3uKA
	6GGXfB9a9HHVpOJBZ7qEF+DMgKRDHuA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/BYNoVmF3YbRiY0Hi/9O43xTzLl3/EW8MXOY/56GuA0=; b=E4trfwDo1S01UKwsa2CrgAOcSE
	ptoeCiFK8So4wlImp/8pjz/VBvtXHnB8B5MDyRYvg1yqGLdg6Tf92LaQjfNi1cdedAP3agZ1WbcNp
	Toh2ZJ7N4fK8LWTgaEb9En4+6sGHZB9iL6nmh7258KhX1IkLOZPj8HC/XgwqzmmEtafzypODzG5bt
	fwomHrB116rASJMqP4x4UdJNY2tD4SGar04GPmSHSEnVu+68QC/yQYWY/mzF2frEWxOl8gDK0uEy9
	OVrO/Ud3CraTGrePIC97bq2rxP3pXsm5U9cT7uuVndAVbke/jLFpn9/5dW08qyUL1FvIPrqIxPapE
	7bfmXpZQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDySS-00000000Yic-41sk;
	Wed, 29 Oct 2025 05:10:53 +0000
Date: Wed, 29 Oct 2025 05:10:52 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 06/50] primitives for maintaining persisitency
Message-ID: <20251029051052.GR2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-7-viro@zeniv.linux.org.uk>
 <6d69842d102a496a9729924358c0267f00b170f3.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d69842d102a496a9729924358c0267f00b170f3.camel@HansenPartnership.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F116B40002
X-Stat-Signature: 3rkuszbinc9kxnxrwkmfuzjqqwypwdn6
X-HE-Tag: 1761714662-690060
X-HE-Meta: U2FsdGVkX19jtMeDYhAujn9PoQyZavUyGOWyijrAC/w05hOYjGObbvuKLpitxc63xBlOYRx5MHS/pPNhll2jdjmNvopISAupvH4W8rkfoNyIciuEG2ryAYtDkYisfnVm+OzB4jWvsUHZ3IBgSafR/Bxvhubfe2PX1mqvWjGfvooAG8tbahQyzC6CHHLiO/TGirPmFuP7Xko2uM/uN/OZz5xLmnXPxF/qKyUEvPm4Vx04BRpmTD8miJ1s9KnfPAsYgBLsTGeyqgr2PsYQX7oDlTDsstG4rz2Nsu3fwBaPJt81pcPIYn4yomViPBwjpLoUeviBGLPQbEDmIp3kqxi4cBIoLjbZr9DCaqmT2jCW4Kj3RyOU+aWCSK07lGouqCPB6H12yq4N1z8C8BV4pfEkgNBeZzKHHcaavjDrqBY1o3LjK4+sMlR7fuVg1hTTknecpmJghVDlwy46Z1LnIesaRicFHeklE615dv/iKflv28ZGAlR3kKmxH+Mbnt1d6+4+y2b9Fam59AHG37xkWD8zdDXIpklbIY1LsR56Vi1m/wqbGshoXO682htaJcQvPhOvjbrxkDtQ9XaKX5UZMkTwTkrFgIcyhPAJC0sMufobFvmcECq+LAzmNxJ2ZjXkca8H+uK16tGS1qvLHZ0pUepvqXNJy5UWjr4q7PypNYCCGa3b14/vAp4BF+QSNdeW2+ySpVlPuOotm7bG1v3ol6oT8CG9vpKiDgRcwPTHVLbQH+rylz3r7V9Hh5DFZAf1T2RhElkp2yRaH+wMvhB6pHPwRDxo5EXauC3bIygDKaQhU1bFPiREY1zX+crWPzc3r3Z9T8Q3D6vYAooXJNzfl3DrvTpnp1utrwj1qNpOQ5e0i85Jfj0EOtNpU3UzbqgUn6LPO4y8533oG++/TIqlJybrNsT8ViHzP/F+NWZb4obqiolO9S/RWFsXLEYCZSBIyBWJnMScBXyAvmEFU5Maqd1
 KePDgkxy
 /LInq9JnMAlhcQ0h+Xe8rujqgpWnVhuZZx1/nQ+YP+R9LBx8veOFHCAHTtNlUai2PsE+Zc90PxjM0Lh173tdVLTF17HK8jR/M95WsMY3J3o0ClEVGs9gMnkKpqmwWFuL6Rs2SE48BKqHhr4iSrxUojxQlhKCDAz142xBaRqpYffkLXC5V/FTZtdxq5X9YNFuHuYzjbXQqpkxMEpy14tv95qkHZxXrhr/PnTLipOUCjMJGuzYadcZyS2Z9gdZsaJedKkfPSyw7OR5dSx3+XS4fbvegd9kqwncr4Sql7EZ2FfCAfYU9kCRDLsahVr6ftJeG66yyg4W4f8HMX6LDynUvD+0MLKv6YLznea2/Wew18fXhcAgX773HjnifucjJolIKX4iYwYnRc0u+74Np6LbjZkf4RWHkNpn+L9svjAelXH1gjqC1J8Mo5J+BaWn4X7D5kXWO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 08:38:00AM -0400, James Bottomley wrote:
> On Tue, 2025-10-28 at 00:45 +0000, Al Viro wrote:
> [...]
> > +void d_make_discardable(struct dentry *dentry)
> > +{
> > +	spin_lock(&dentry->d_lock);
> > +	dentry->d_flags &= ~DCACHE_PERSISTENT;
> > +	dentry->d_lockref.count--;
> > +	rcu_read_lock();
> > +	finish_dput(dentry);
> > +}
> > +EXPORT_SYMBOL(d_make_discardable);
> 
> I was going to ask why you don't have a WARN_ON if the dentry is not
> persistent here.  Fortunately I read the next patch which gives the
> explanation and saw that you do do this in patch 50.  For those of us
> who have a very linear way of reading and responding to patches, it
> would have been helpful to put a comment at the top saying something
> like persistency will be checked when all callers are converted, which
> you can replace in patch 50.

Point...  How about
void d_make_discardable(struct dentry *dentry)
{
	spin_lock(&dentry->d_lock);
	/*
	 * By the end of the series we'll add 
	 * WARN_ON(!(dentry->d_flags & DCACHE_PERSISTENT);
	 * here, but while object removal is done by a few common helpers,
	 * object creation tends to be open-coded (if nothing else, new inode
	 * needs to be set up), so adding a warning from the very beginning 
	 * would make for much messier patch series.  
	 */
	dentry->d_flags &= ~DCACHE_PERSISTENT;
	dentry->d_lockref.count--;
	rcu_read_lock();  
	finish_dput(dentry);
}

at that point of the series, with comment replaced with WARN_ON() in
#50?

