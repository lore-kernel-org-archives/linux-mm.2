Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E707FEA4FB4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291606B0088; Mon, 23 Feb 2026 07:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E976B0089; Mon, 23 Feb 2026 07:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141E16B008A; Mon, 23 Feb 2026 07:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F38BE6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:13:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71108B50FD
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:13:22 +0000 (UTC)
X-FDA: 84475611444.28.C277050
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B282180016
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:13:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KtTqWE5d;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771848800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3vZHOqBOJ38Wgi36sClM04EJW5ffo5Qu4rlkP5Uc3c=;
	b=s7TTkjEyiMgt69DnlskCIjSyJm7q/g1crIH1/L22zp8xPIsjuDKS23YfN3rw012eZN2/il
	yVT+rUEd/ZrQx0WqkdPWfujmj3wTGMTMR6jI4s5ifpYdn65WctQGxjvoklu/OW3Hj9lh27
	D6/nn03SOyxc0zGW6y82EYXFPMULHD8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KtTqWE5d;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771848800; a=rsa-sha256;
	cv=none;
	b=jzWGea+6yvagXhv+MRsn9pGLMM3nfdFmB0EYAycStjjjWaEayE9pMv0jhm1tGdGefrApJE
	na5fFmEddCEOEFec48iy8zbcxfVQDiUgDbgj6RBuQ8DpUssV7qAh3VsVWJWNj5zHSHWk7a
	RAru3HeByiUdWsGd9ODbRxCUMUr00yw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B48D435BC;
	Mon, 23 Feb 2026 12:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E94DC19424;
	Mon, 23 Feb 2026 12:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771848799;
	bh=oNuEDnFMo14V4sgwK5Ij+zwpbNPaHLPS58OsUoBe754=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KtTqWE5dYnAKYm1Lzxcfk5B3SJEF2jpuy7dXe44+UUXXVmswqzuxUybUR4b18V0PE
	 iMMSo6bdz6JL9jCDC3VtDzNkd79KuE893ALD5dXsZby5fMDNzZPrz5WC40YHThssx8
	 aXR/GE4MqagmYqxWOQowsMdXtxYKAFPYHVxgYPCvfrAMUgMpMpn94S+7weovfYNAsq
	 2TTRtYQe7wLjMONEBfaEsmB+ARZAsRRneTjQ2lNDMD34Igp12uQzCH57MmaUWXydDS
	 RGXJYtx8/ECXVruWFyBFXPg8CkSgWT+F2glsw9fUXP4L+/XOSUvqaGXysUsLpPnanT
	 FemHaUl4Ap/6w==
Date: Mon, 23 Feb 2026 13:13:13 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 09/14] xattr: move user limits for xattrs to generic infra
Message-ID: <20260223-gewollt-tropenhelm-fbcdfb6b5a17@brauner>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-9-c2efa4f74cb7@kernel.org>
 <20260221000326.GB11076@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260221000326.GB11076@frogsfrogsfrogs>
X-Stat-Signature: 7w3dcseeaoigaqz586pujksdushct59b
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: B282180016
X-HE-Tag: 1771848800-138484
X-HE-Meta: U2FsdGVkX18M+m/yTN3M0TQ4IcUEtVk6uM6WIDNuO2h+UBZVLb4s3O6W0J1IwvTYEm1cNZ3tY1bFbZDnLumwQgew4JBLgHFu8y0zZN+9+A4SCdF97mXCG6B6iIsLB/FR2VYc2JteJejvOy2+2cTOIeVmL3a49FH+xGInvUJRx13KGOuU2ZtDkNuhaxbtau0g8gB1VXlgP6A36UGxXlASrQK0K3AABb9+7zLwCm4/jxdgvbKWei/aTf20bP50Tm1o6dJeVF205qg9+nj+VKN5e807ILZON89nK0PROoEJaPMlRk8Lt/upXFL0KA4hkeRTlMlcuFdceJPGhGgJXmDJgGBDaVVCLcPTU5PL2KePbg7PD/DVKsBjTIRslmduSBH4dmF+sa5z7QtKcYPs/C+XViWieTDx4u7LFpBxuE5YOF1DzFz/q4BuSonEsa40vHq97ar40BkJiQo8ZivvzfLs/ZjwgFHH2/QLpMMf+j4DL9KpHi96gCwDYKXZgXcPLPVTBgnyUotkNg18e13Y+AV0PHa4TI/oN4SkfgLM7wsW9YAQ5Hz38jkodXo8fiRkuEZafWgDfOBhIA2ZRmuPALoWzj0W44IDYjfsZosRI71P3YIIl4+81wnh7k2pSkrlCwmGZ2PJeV5DqNUbuFp7PYwBAy3fS3cDTPd7HpEAcCWAGhHYKpNbjGm7bPAYonBXPusagAfWtmaRgWO0RxmdD0/JsyDfT71Z6epv1CrIFW4CbYCejyels4/xVrswbe6A6yzhMldDT0iJWyUPEeLwgTFsVS0/yu2iG8axuQD83PxEensEZgopUTOLq+Dn+PacQOB8LCspPXIlxWavsbznF3BAeIffE3gmIdKcTLAish6hl6ZT7ro5mruoJkjBD76D7X2kXc86d/cWX2Ulgn5AD7vWt7hwUQxONMZq/WZdRPE98KBEVQjqi/rzNKXcMVjeImhnL4P1fa1S22PGX5Pf6pK
 Aj+iZCN6
 3WYLSkQ2bdQezMlnSxEJPRzYs/JsW7flb8upZ3uaGZAM29oQ76v41nvdcMvjJI5WbeCrOZqhh9E0Ue9Ja2N0pIRV/eel7CB8LNFglnPn4gQYnyfPX/c/ub9QQFblc2zMg/PgmV5IDYXLeppdelQ9dCLQZT2BfLyHWdp7VhmdDwsOT9osB5ZBlsDhUEIzOA1ughcgi91slkSC8RNRMlkn9y38KQUd29Da/sm1r1bRa46bbXf7zJPlnqTn3MJJ0cMuk9eYvZ9FqUKSO3JMNChbajglkm2RWCx3M5LUg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 04:03:26PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 16, 2026 at 02:32:05PM +0100, Christian Brauner wrote:
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > ---
> >  fs/kernfs/inode.c           | 75 ++-------------------------------------------
> >  fs/kernfs/kernfs-internal.h |  3 +-
> >  fs/xattr.c                  | 65 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/kernfs.h      |  2 --
> >  include/linux/xattr.h       | 18 +++++++++++
> >  5 files changed, 87 insertions(+), 76 deletions(-)
> > 
> 
> I know you're just moving code around and that looks ok, but:
> 
> > diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> > index b5a5f32fdfd1..d8f57f0af5e4 100644
> > --- a/include/linux/kernfs.h
> > +++ b/include/linux/kernfs.h
> > @@ -99,8 +99,6 @@ enum kernfs_node_type {
> >  
> >  #define KERNFS_TYPE_MASK		0x000f
> >  #define KERNFS_FLAG_MASK		~KERNFS_TYPE_MASK
> > -#define KERNFS_MAX_USER_XATTRS		128
> > -#define KERNFS_USER_XATTR_SIZE_LIMIT	(128 << 10)
> 
> I guess this means you can't have more than 128 xattrs total, and
> sum(values) must be less than 128k?  The fixed limit is a little odd,
> but it's all pinned kernel memory, right?

Yeah, it's all pinned kernel memory.

> (IOWs, you haven't done anything wild ala xfile.c to make it possible to
> swap that out to disk?)

First time I've seen that. Very creative. But no, I've not done that.
cgroupfs has been fine with a fixed limit for a long time no so for now
it's fine to assume sockfs will be as well.

