Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DA2E9B354
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040526B0095; Mon,  2 Mar 2026 05:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30276B0096; Mon,  2 Mar 2026 05:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E667B6B0098; Mon,  2 Mar 2026 05:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D700D6B0095
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:04:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D5D3140AF1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:04:54 +0000 (UTC)
X-FDA: 84500689308.06.F853A02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C0234C000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:04:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u0Q8e7CK;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772445892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cd3FT/8GNoyYeQYzJRjJBckMEJPQxCEhJOROHE6C1Gg=;
	b=2OIM/+YE3/SQcT54ehAnbYqi/9FNQBEFnXcaaNJuZF/HEcQ08IFJAV9yZHft2TSO/bs0Vq
	CswT+L7KdNYtoqevFLsd/Hc1+j2Wq0LpcH1JCtKqRGWufU4nw3AjEe4if+Pnb8ts73rt+s
	AtgzDqKdd4BLPKaxPtrmMj40A8+0/pA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772445892; a=rsa-sha256;
	cv=none;
	b=osW2GbZn3GUK8wL19lr9txizMYF5wzlrc/XNAQK2tFzBTn7lFw9PkNnMyL+n5ZmEGKdxoL
	KjbYV8edaoshZSb10/EKWI7BKIUdjCIoVd0J/m0pGF8hms/IALQiHxxnHM/Ofe/sTVVv/I
	Hj46XlD6Phk6Mo1oXvSAWkchYVHplDw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u0Q8e7CK;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 877D9444CE;
	Mon,  2 Mar 2026 10:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519B2C19425;
	Mon,  2 Mar 2026 10:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772445891;
	bh=YlrMc651ElVPFy+ALZ1qaxHylbkJUWPRrT+8qQNXZks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u0Q8e7CKsEn/a60JV002qxWB2l69VuYXorh6IfMmeBVHbfr5GrTDAAkcgOCUyQQWt
	 oZxFKSOZeZ2bTQRp7FCCx6FfA6ChKrC8lvdp7ByLF388fEO6/uheVmJkUk7B4xmuTN
	 PYPDJBVMJXs+8Rp0PT+LsbGeZdzu9MX0yEXBVNOgbRRz4I40ppNh8PFA85DxiVE86S
	 iJZabuTmozla4F7z/mpPfuOUIMgXRCH4QRnlqt5sWO6YgPR8NsD3FHd/F36dkSu9v8
	 D9vGpYM43c32kFImaEY8WpiWFlCs1p9HVefJqBYr2RUO3UkcBrOXQ6WBWV8NYAYGaf
	 QxovkfntqnONQ==
Date: Mon, 2 Mar 2026 11:04:45 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 05/14] pidfs: adapt to rhashtable-based simple_xattrs
Message-ID: <20260302-teilzeit-zuallererst-99c820d6a6f0@brauner>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-5-c2efa4f74cb7@kernel.org>
 <qxctwu77wp7gv4ua3hn6kg7r2vt57laomn3ebjisemzzaybagy@mvoo2wpvu2ux>
 <zfwhp3c4mtf4b7gw4qmxayfqrzf4h723s2vfjpfid62yfjz2zt@6ali24hx3ihp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <zfwhp3c4mtf4b7gw4qmxayfqrzf4h723s2vfjpfid62yfjz2zt@6ali24hx3ihp>
X-Rspam-User: 
X-Stat-Signature: ixauwtdf6znqgyrc3fyjgqoqn8qdchn1
X-Rspamd-Queue-Id: C0234C000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1772445892-238130
X-HE-Meta: U2FsdGVkX1+HIPDVLFffDFqj/LwbfH6lFFByAoHAyDp3lAeR0KS+4mFX/M1xlXH4LB77nMuiv8zANcGQBkJ55Ajo2ZDF7PhC/h4WIPmLhKC7MsohgDQnli0hpV083FOCnYJM7SsOq2qzQY6TnBeXPTtywp26+DUvBHWi+TD4Rg17SGFTV6+C1J6NeAvoJh8fecWgeuc8EaT9M0rsFg5SNMnS/X0uIzd6Qx93t338y0Qq6We19ZgwOS90WBfoOs/Klzg3eS08W3cQ772bPCLwXCeBYEAAP8Qyes8uUU2pz+HvYpJzHUyjTWJdIQ17FGMZM9Ku/y6V1ZD2g3Ku887XyyGh1NqZ+rpdS69kP4bRu1xAx8/BN1DUzO/kWeWDiTUzvv83gpN3YZlaXLKIT5rf4h4IKdovAT6eyQLjgR8qf9bflWCb7VGHc6YWIZTEs0W5rlqpY4Fub68/SRPC/QtIRE+PcKtu2ny+clo1SXiVDDMwv+XIh/P5d9cAIiIosxf/u7OoIW+jGHu1FdzNr4H68M6RGbVqkVC/CYi3nNKQraex+wkzgiO6i/X6zZpt/BoRTD3IrYKgsjcr5/+r18HSYwBQAfdrjJVzdji6rXXeqzR8mp2IwVCd3GYvfpRxY9oZv0RFT2EQeGAZfUD9oywPGAXiDMFzVj0STtl0XZhczfAb1v3CI2ILSbe99chHo/FhAAe52n+Br9POtcpGZikj0eDnmv2JhI5gjFWWTMLeeshoihq9xahSDCec0uoGmvH9Da2GAZxq3nZG/DonW43EDhrr8uCH1iR5iQo2A67zjOemPJiOd+BZQo4eXiuVp/zWyKg1wB4NmCsqrsSIqVSF2fdCtPWvSSXmwFBKYR7F3h4r2dr0OCpY95tPO3ov65DZ1lh5FUWJBUXOvMVgZd2m4xBdz+pFSQJFcYNuZgpO+Qf8XZZRjCbtQMpNlnEmfTbuaD9shKywjPykEFV/XGB
 i3tVyop1
 rb9fdPdYnPOGmDDB6DKYWZGrBzoKSjyORP6QPiZKh2GYQjGbLk50B5ph4kOGkEu6qMNr9bk+BMuOAWoXseQ7WtmQ2gjNMC8PpYXJhgaCCqAcV8elan0dvJ799ZulSmvUpVxfgHoR1jNo7vb0jtcOf7H4bFq07E5qNY/ALuD/gphp3MDa1YlwYhKXAJV+rHKmCI4u07zqCjAiCeeDAHSAK2mfjuV6MU4mtG+dYsuZAhapBBhXfuIxOJeiYX0gaPm07vuTjIUXKSz7pPB1JPj7wn/mBbK0k3AUdJCGRQZ7/IvhFH7NQNjknv2NKWCsr+a2pcwma24dsWlQ80aGpSYrW6VKdpUm/9WH7w41xuyntH8s2vL8L/rfoyPS8uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 04:16:04PM +0100, Jan Kara wrote:
> On Fri 27-02-26 16:09:15, Jan Kara wrote:
> > On Mon 16-02-26 14:32:01, Christian Brauner wrote:
> > > Adapt pidfs to use the rhashtable-based xattr path by switching from a
> > > dedicated slab cache to simple_xattrs_alloc().
> > > 
> > > Previously pidfs used a custom kmem_cache (pidfs_xattr_cachep) that
> > > allocated a struct containing an embedded simple_xattrs plus
> > > simple_xattrs_init(). Replace this with simple_xattrs_alloc() which
> > > combines kzalloc + rhashtable_init, and drop the dedicated slab cache
> > > entirely.
> > > 
> > > Use simple_xattr_free_rcu() for replaced xattr entries to allow
> > > concurrent RCU readers to finish.
> > > 
> > > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > 
> > One question below:
> > 
> > > +static LLIST_HEAD(pidfs_free_list);
> > > +
> > > +static void pidfs_free_attr_work(struct work_struct *work)
> > > +{
> > > +	struct pidfs_attr *attr, *next;
> > > +	struct llist_node *head;
> > > +
> > > +	head = llist_del_all(&pidfs_free_list);
> > > +	llist_for_each_entry_safe(attr, next, head, pidfs_llist) {
> > > +		struct simple_xattrs *xattrs = attr->xattrs;
> > > +
> > > +		if (xattrs) {
> > > +			simple_xattrs_free(xattrs, NULL);
> > > +			kfree(xattrs);
> > > +		}
> > > +		kfree(attr);
> > > +	}
> > > +}
> > > +
> > > +static DECLARE_WORK(pidfs_free_work, pidfs_free_attr_work);
> > > +
> > 
> > So you bother with postponing the freeing to a scheduled work because
> > put_pid() can be called from a context where acquiring rcu to iterate
> > rhashtable would not be possible? Frankly I have hard time imagining such
> > context (where previous rbtree code wouldn't have issues as well), in
> > particular because AFAIR rcu is safe to arbitrarily nest. What am I
> > missing?
> 
> Ah, I've now found out rhashtable_free_and_destroy() can sleep and that's
> likely the reason. OK. Feel free to add:

Yeah, it was a surprise to me too. :)

