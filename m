Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8116CCD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B5D6B0005; Thu, 11 Jun 2026 05:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C86D6B0088; Thu, 11 Jun 2026 05:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7136B008C; Thu, 11 Jun 2026 05:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47BCA6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:10:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CEFD6A0502
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:10:10 +0000 (UTC)
X-FDA: 84867060180.05.71E3703
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 352DF100015
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:10:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPtzfzGE;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781169009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfIkCcdblNK9CftEwDsBO/uWm7/F942mXwD6xGSPOQ8=;
	b=QG0zazetx46gkGy9kNMQ+X3fUtlm2+hFGYz7I0CrQOrah7NRQV7y+ZZQBcWrm6dbBuIxpj
	wLI3X1pvsASDME1vRbgRcYBHXMxTMxN1WDWEN8OSKN/9vz/joH8sKVtmFwdPJzdYAWSgAz
	eAqvhFLjQI6eCoR6OS39XAJaVw++QHA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781169009;
	b=RUHspfmTmYSegOYzOqpGJeG450K/sBgzP3kdE2BrZ8x2IOCRV8N50CbJOLUrFgwrVnpwt/
	N2wZuVkOhtSU55QXz/kuKHfkpCakxvokqw/K7+Fqj3Q+uo/ypNje70SB041CtSZnF+gQcv
	9fEeEWuhZ3H/unFrI9qzxapikb4d8ik=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPtzfzGE;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49568423CF;
	Thu, 11 Jun 2026 09:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91A51F00898;
	Thu, 11 Jun 2026 09:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781169008;
	bh=RfIkCcdblNK9CftEwDsBO/uWm7/F942mXwD6xGSPOQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fPtzfzGEJFYZ4r9C5JW6EWJJCF584zY5w6oMBp8rYhkTyeCSNXVG8Au+IV1+dNDdd
	 OjTWGscPWvBqdZ2tNbDWg6h50AIHpzelD59trF8BEIcIwr4MI/4QXCMCKdGAoI94Mn
	 DugjFq5FMnmZqKZPntfDEJFgYqGK3JTCO0wYhoV4XfSAmCg3LoL4s0NCbSY87SXGdd
	 lIoNbEwaIZQdNTNTGkOHSesk6vni01mQ1c/DuaI8Tr2NMd3SDxgiZM0D7hfNAI8V41
	 N527kBZlZDF9Rbrm1FBVIptR07rwTfzgG4mPebsS1Q5UonPhpGxzx6OV+FU+aSKQfb
	 0xc5VjaRAgPkQ==
Date: Thu, 11 Jun 2026 12:09:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/17] replace __get_free_pages() call with kmalloc()
Message-ID: <aip7Y3UHmXsdX8OH@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <3FD8E1FD-6E18-46D9-AE93-00FA1A66C775@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3FD8E1FD-6E18-46D9-AE93-00FA1A66C775@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 352DF100015
X-Stat-Signature: w4ktic4dnksocz779suyk7ykt7y561f5
X-HE-Tag: 1781169009-849946
X-HE-Meta: U2FsdGVkX1/oCzjaDrj/IGnVA/nmjpMDmAm6HWEprg7ixgWUAhV0mbgFDwOEmT+Dh2pLIsNv8uAYb3tKmOgfL/Y3cH71ol7yIJ8VxKfiGzk0D5jbohgpp4PXWD/ybDJIoJtSyiK7WZDDGqdtM+T1HTiBK50VDOH1ynqFpj2pNJarvSfhSRwZWB2B3rlkCAU0NgxPEUYSMRgXYTN9iB+O1xj0U6TrOZtkv+IoRAuYGCb1k9KxKk0a0J9rp4MXuwlzAveb2wPIB+n1DbYuV9ZKBawX0tD+esJNadcOYpNTwHcfS4o/vALtw81Zuon6Pdgar0ja6ASUyEoN/KAM6VLKawQQqtYuQHXgy/JMo/wdAxywzYyGBVjxqTzVfuNnNKv/t4NI+rDFH9aFaM5C1EJWAELLFbW1RMbclTw72ibVpUQTOMIB9wB15OXnat9zzGd4Qa6OqB7BTGFuAIjizNp75VOj3m/fsEnGnew+JaFFmNKYZsVvhHaVsIzd0IA8WyPyD1BskeuTYq7Jd62w44tW29Z1Sb+onoKX6PWuu/jh4HJ/UquRxESnXEPmlsspeuoGkhxNEcwcP6m/PGmydPntFcsj/MTx+DEMjZ2/dGALDSIgySSW+vAzXDwtmHfPHahOH3OVQXLYms74yO4BXrSPP04UKWZMzFkuwzm7XhuaNHXFbsunYquXFHfWEuMKKvTvqOLenrjJqV9jFbHNJR+/unea2ie7V3blo0oD6NwcrnRhZbbN5K1jXFs5vbcbmzGuV/8Dvg4EvGfvpL4M6/DiexN2LP8rkozTfbBnul0WdUdi7pPjJ6Qys36i4tgYgfCh30z2xRwKXSiLJT7wITIeSNaiYImm+vnClucNBWST8SrfVRumniREvZqC4YTgM81DAV2/gb8Bw0t5Bf9b47IAO3pIegnxg6RLDA7uoiKKh9iUQtts2FkMOhH63dLKrWAFtfAjJGLT/4msb/AfrUL
 3L7tf7Im
 TCnuqpbxf7Mb+uyUtac1rqsTmH14Mmv2NaeX+Hb02FwGurjdJnp9tHUVru2H5eFdVHjiFiCHRuu2qhg/tr0nq1JhY13+WX9o3zTso1FfzFJLkjKdRJf5ucAkSaX/KwF+6pEb+qC2WE9TeHKD7erFN+7hU4uukK/8moHpUyFETlvd7ZGKMmAO0RchCbFqtHcQO/aidV0D+DXJTN1JP3HbJqLqvq0hl1rhroP3rxHzRJYBnANXBec9CMQTDbyNRy2nx2poPC6i+0fptpwLSYRnRSspQnzYUYWnZHb2JhCvStHbUOxYduQB8y7E/CzVO+KiQ1oavknHBV3VLN2imlm9WRgH7TdvNzpi2urj9+nPM/dDuiEWrvc+/9vGv5Oj34BrzYF3SL2Ww8hy2TbOxRDZp8zigQlvzQ3RQqPpxIQ2xz64IiAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 04:00:33PM -0400, Zi Yan wrote:
> On 23 May 2026, at 13:54, Mike Rapoport (Microsoft) wrote:
> 
> > This is a (small) part of larger work of replacing page allocator calls
> > with kmalloc.
> 
> Is the goal to get rid of __get_free_page(s)()?

Yes, eventually.

My initial intention a few month ago was to remove the ugly casts [1], but
then willy pointed out that Linus objected to something like this [2] and
it looks like more than a decade old technical debt.

Since there are more than 600 or those it will take a while to convert
suitable gfp calls to kmalloc.
Afterwards we can re-evaluate what APIs we want to provide for allocations
that must have actual pages.

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 

 
> Thanks.

-- 
Sincerely yours,
Mike.

