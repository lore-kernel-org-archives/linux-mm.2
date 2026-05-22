Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9C6CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 03:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787476B0093; Thu, 21 May 2026 23:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739536B0095; Thu, 21 May 2026 23:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FC16B0096; Thu, 21 May 2026 23:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 526936B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:53:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3E1AC2DAF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:53:36 +0000 (UTC)
X-FDA: 84793686432.16.BF37831
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2C9B62000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:53:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fld1ypw9;
	spf=pass (imf03.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779422015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kB9u/fd5oqOyzn/d56rzTMKcyf+Gut0U9mtxblKihAQ=;
	b=wBTMCOMF8FSAzmfz7J5LbnktRamqiVbKPYjJUM410HfOE7H6Fec/RdusuqIEmEkmz5jh6V
	IQclJHGJByeknQt5iZgOS3sTVNbsvW6EY2oALGyZQoi+i6DHic8lM3VWyQA0weqtr2TrMt
	NcaitzXl+23p8vYkvXnwlTahAjlPew8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fld1ypw9;
	spf=pass (imf03.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779422015; a=rsa-sha256;
	cv=none;
	b=oG9cReDGUBfU9AzucYJKBLj+nUmMyfur3OPWxc0ONoa74ENUUO7Lp93cmKOdPqNuzBq7Jz
	PSDQLy7jVzEHv6YokQFCqcj+ixhESFgV8e0z2DlTQtPvWBiFN3/fjG/cHCRfowpYKjXEjw
	HkE7+KJdFfn/+GgOGluT9057SX1MAmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6502060136;
	Fri, 22 May 2026 03:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CA61F000E9;
	Fri, 22 May 2026 03:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779422014;
	bh=kB9u/fd5oqOyzn/d56rzTMKcyf+Gut0U9mtxblKihAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fld1ypw9APN84jvJm1OOVi3+ZHhpiCqzC8QK3ifg0qLQZgEH8RQwQdH9O+qgnCYrc
	 Sl4P80xhdmTewu6/ueUPwz49MOXYxB6UBItK5OTQ0jNrXM+RhuWFzcbq8/AWs+iJAF
	 sWwz/T9UUHbDSE6lBJmFzuV/C0rrwCCV/lVPg4G1C8T1NTPTVkDkijsvMe8RDW8nZA
	 LZLL7Urvwe4SUWrAFQbjev8VcLMOGCOX2SkHENYXY+5glXf5Ca4NrlNsci9Of0Z5lp
	 wuu95IWJCelZn/vv77Jo3iZBmgg6TAwqcTk9PAgwVxz35w1q73aBen2fJCrKohTcUa
	 sPyncu6PC/Yqw==
Date: Thu, 21 May 2026 22:53:31 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <20260522035331.GE5937@quark>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag_OVwPF49LSZ7rz@google.com>
X-Stat-Signature: 5aewp5tsa648orzmu33xtzp6tcm5z8xt
X-Rspamd-Queue-Id: 2C9B62000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779422015-602814
X-HE-Meta: U2FsdGVkX19tAAoycGP6jDglcHH+acusaRINO4qUbdvHqXgk7J5TfFBWxgbONyLunc2gGRcwlnmZrZPd5gECvyFdvVxATdRMC3F5jYUkyCA0ZVUjDsFCxCwmV5OiKThXwrQbEDvidct+gZdLt7JcRKVKNMVCKlLpWa9PVnGOFSXWW8xIHRZNJaG+dwg2htbC5cgz5YPa/MDALRD4ADObeotLu6aud9z4n+x3W0W863JfN2qXPsDqa3/eGGf6TVwMqioZd11eco3WbGP3YznNmfxpVV/QMEh+UQ4HePHQmz+qOi6n4osdHaGUJ8+syN8+VflNlzseuyQelFAYBw+MiadHNpViByWdBYZvYlpVriJMPIJbRmpyhQ6Nhp0jmli8PP8O1xcYvwLhuguF5+HQmlmSFnGKpKL+UkmYR01wfGLClKBekDEjGd74Zabt69F5lzJeNBzpnzgP09QRQ3FhOn3gVIfEXmZDELkHHuslJviLvS5NNF/W9HunN/TOFDVDC2sCngIpIit15ijdzKc1P/fzPR+ju9QqShkGrEJuoYUdKxzei3Q79yQFs+XWvRaMa1T16hxdxeOP2bpiDT39H1vc3nqaEcGeIC4suIcCa9PTlgD40D3Kdh1SKNEqoN0a5qosL2kFeyxxEHBP6htrFrgAfrbmz+2l23E52zH+WWjtp9WmqOPkbUVzPLIXojlNzeT5OYp7unFzHHw5+nhRZVtA5GNwnbBmD7p9pZXtJUL47uGeqKbJ1gxajbHjZ979sgoQyxRCsgwYZQIQq3FTq661j3zRN7SfPD0XOD3on1O7PmumWTVjw1Lu9gadStC81gL0k0amilpCGYIU3PVdfo0DdXBAq05LgrLJxmYRUYsH3LUPCED2fyfGiRXeL1/h5iTN3a1BaF9d6XbfZAXSyhJqRVBnM7QxgfjKsCgrJnCIPBfo7/TmXJnR+rpgf6BfeePnOrL40DpBz2VWfjC
 4gtqX2jP
 RMJDpynutKvzJ0pYjCN/IMnLYjZqD+rgiRceqzf/dluSmYJeu5Yb+o25LBYFh3EpAb0hObCBHW0EG5Z1kOqm/NJ0ZT15Z3EejKodkR+UedkvqiENJrELlH7cGg8ILOYVCUhHix8t3sFFtMUiBCxizCbPS577dCiUZdh0WdzA00claUxHDPUES073CcUI0K46sSLUe3jmx1RMgganZo1M7R4kIAxOTkO2KlcUIvtuOGZcfWEh5S63Vu/g/H1N0TPFPaov1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 03:32:39AM +0000, Jaegeuk Kim wrote:
> On 05/21, Theodore Tso wrote:
> > On Thu, May 21, 2026 at 01:51:08AM -0700, Christoph Hellwig wrote:
> > > > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > > > patch.  There's no justification for why f2fs is so special that it
> > > > needs this.  What the hell is going on?  You know this is not the way to
> > > > get code merged into Linux.
> > > 
> > > None of this got properly answers, and this broken interface now landed
> > > in linux-next. IT is offloading a user.* xattr which is free-form
> > > user data with semantics that are weird to say it very nicely.
> > > 
> > > All this was done against the advice in the mailing list discussion.
> > 
> > So let me get this straight.  This is a magic xattr interface which is
> > not even persisted in the file system, but instead sets a 32-bit
> > bitmask in the struct inode which disappears once the inode gets
> > flushed from the inode stack.  And it uses a generic xattr name,
> > "user.fadvise".
> > 
> > There's no way in *hell* any other file system is likely to adopt such
> > a broken interface, so why didn't you just use an ioctl to set this
> > magic f2fs-specific flag?
> 
> I went this route because Android heavily restricts ioctl() permissions
> and we needed broader access for this to work within the framework.

It's straightforward (2 lines I think) to update Android's SELinux
policy to allow an ioctl in all domains.  So that doesn't seem like a
reason to not use an ioctl.  In fact this is actually a reason *to* use
an ioctl, as it shows that ioctls can be allowed/denied independently as
needed, whereas xattrs just use the file write permission.

- Eric

