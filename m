Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B22E6CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664B36B008C; Tue, 29 Sep 2026 01:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615CD6B0092; Tue, 29 Sep 2026 01:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52AD96B0093; Tue, 29 Sep 2026 01:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E14F6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:08:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BB3DA69DD
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:08:05 +0000 (UTC)
X-FDA: 85265618130.18.271599A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6325E1A0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:08:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Vt8Wl6v9;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790658483;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ql48WTI1DDC42vkQ5aONYMMkjcdFwpalboLPZ35vz1E=;
	b=jGcN74mlb5S+YR6UHdIWAs2mEXdcH0HIuD6ekovaS5ZioHbIs0upk+/49MN29W9lMse0EP
	yeBL+hGlxgVkj76wdgI0+1QxLK04IJik80urgZicuQMWgauD09AvEPeLw7oFlGTKzOmf1R
	fKDC2rLs3M2vaR2nP6L6QZ/s89DMCs0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790658483;
	b=zRaw9uX514u+ZIJYsNXa8OF3hGibzaOpqqCVgDyR/9kPC6ek7vJ17CCzDA0v6i9RszlEHa
	G3dAANmarYXclduj8GgTzr06FW5sgtD3VDqyTWGGw4nMq9z/hL5ziDjED6AvasaVaVS7V7
	A3qWqmRFXu1RmImh7RaiZriJyX8SMp0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Vt8Wl6v9;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ql48WTI1DDC42vkQ5aONYMMkjcdFwpalboLPZ35vz1E=; b=Vt8Wl6v9GXqlPdcfnYCxm8QiYp
	IjYDbFvkRSA9EwCbUBHheJvuYZdpImQ8ElWTyxGfzBNWSOW2pO6W+4J4Y1tks26kT+/1ZOyOUbTV2
	LxknNqO7/ieWoGqNfhU/6OiIm+u03J7GX8QRDAzb//I2WHU4oI0/7on5fhJYoFcx/TY3YdWmGFgOj
	4/WzgK4OYYFLnJJZ1H6/D8CD8OvFCYz5m/CT5EO8CcQq6t3LkWaAWZ3HXS+H7Eiz8dY3BcMEfr7b2
	xJxllWNFBc/BuTHZelPBr7MOyE8q5XDulXQDCXIxkADODbw48afqLDdAfkvjLTsbKv4uPDjyQv6ee
	sAjeP0QA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xBQ43-00000002j2z-3GyS;
	Tue, 29 Sep 2026 05:07:40 +0000
Date: Tue, 29 Sep 2026 06:07:39 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org, codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu, linux-mm@kvack.org, ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] configfs: remove d_add() calls before
 configfs_attach_group()
Message-ID: <20260929050739.GB3909609@ZenIV>
References: <20260929034158.1455429-1-neilb@ownmail.net>
 <20260929034158.1455429-5-neilb@ownmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929034158.1455429-5-neilb@ownmail.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6325E1A0006
X-Stat-Signature: 5fhoom8wzxm8zcur56xufo5td9fh5q3n
X-Rspam-User: 
X-HE-Tag: 1790658483-301095
X-HE-Meta: U2FsdGVkX1/RvFO0CqKiRM8QEJPp/MCoLniKPeY4ioh5poDT7E8uIv6dKvOMh7X0RQ0/V2p7EUuI8r710sl5v5fSi4d3d0JQ5NbzSvoie2H3GXrglP6NtiXEzkFjcO9Rttx5TPeBc7poqHF9WXpAlFM3Kv04bHjOeKg8l1FTlJL4uYmR658HHGZk/kpcYc3DBvmFu7EVgFDaq5hiWb4EA7Cpver5LN5frST9ASiOgmX6kZkw5VNt7g76nQH3Wgz1EobUC73tNHKP/wu+HQ8N/0AkOegoLDzn4cRC8CT/sWp/R66U08HBgGYM2sj6u1fqf3g/XuzVFAl1UNrQEG2q0sqKBgLFxhhhELjwIUjw1qgOoNn5+DgQb0KoG1DV+3OAFCSBzKgznO6Hre+OFysUqAQn+S6Y0+rsCS1s19pGticEUZ8zOuEc2pg3Gt8utfVFrBAuZXmhpYQEE9NPEIHm92Q8BXZnCRsyJ4CENQgTKn2lv0o5cpSj7mA+wTdvnITtqHEPdYFGL76TPQlECG7u1y2fkskkynD5AP9VPuJVm/vQi5yRbOBPmiXNmWJtHJ6l4rHf2hkis1ZAwmln5GsGlQByjcHXhwNqZlo4s8bDLcNysjR/5c+CIEFSpbdBqf1wRhOlYONxF5fhB/TZYwJRBSzMQTvFj0VWSFryIncaKsGtmcqVZa1bJyZTOLgMLBbe4K0ziLh2MKvVzR8MEFBS52N2RjaMojrrKFqhwNNepbLjpo9qftuqy/sTqSSXn54hQNUjEm2ijYgsya7Ay175GHhYhamrtOdSSDBEpbt9vmq+v7/hADFtZRw70U4mY/QVyt1DDydrxSEvI6yyWHNECEPfYyquWS/RBjkWQlGE8llFU5P2Jp35c33UaDCcW07FUNte94BW7IUqmuoiEqCqIorCClo+ZKcbN384I1SgL/sUgvQMb/0Q8NvvFPyalf+Ul/P0mktL+a8rJL/divL
 IdzZCQDy
 la7xtZNpO9TCS+tuM48YW/y1ebwurb7+GAWePt1JRllAkgoiL47shTEsNVGmqvCUMZZacfrc9F0m1sgncWhsAkJ50+/DnFV2uMlsiULl+cSjxGNid7S6mzYlhiCJBAvnSH1yLN6MDXv+A6pHGSvWqAh3PtFBaR438CxghICSTu04twHb9GVX1/GqKPoL3t5k7So9eJIopBydhcnMsPSFpFFhPv8rC4otCmDRJJioJmPqdAvXwJ+4jgCYfr0o9idZRrLmU6YVWbevFo65J0NUm9E9jH51b4Z405ILIsPdVfGD73zize3JIT4Ji0QZXRTxTAscgcYFh3LYVLljblJHsCXe8BmHEotXQwcFgNAompcmxwzFjpjW2rH2RQCZFwNNQocZPvoUZacALxp60J1Akbl+9E1krQKrfwfb6+o7ExS1Y33jiaLBccjo+r7SgjTQwk+C5hrMY/AtlqMB17zorHq1IH/Ds6IpSdVWVDG646lY2SXb033cW/l/8f6wWReuvhG+GFUNkf99E4pPXurP36f4TvGR/s8KinJxrouLL6755yyTR7nRCF6P3Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 01:36:04PM +1000, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> These d_add() calls cannot be necessary.  The inode given is NULL so all
> they do is attach the dentry to the hash table.
> 
> If configfs_attach_group() fails, then d_drop() is called so the dentry
> will be detached.
> If configfs_attach_group() succeeds, then
>  configfs_attach_group -> configfs_attach_item ->configfs_create_dir
> must have succeeded, so d_instantiate() will have been called and the
> dentry hashed there.

Neither in mainline, nor in -next...

d_add() _is_ wrong there, but this is not the right solution.  What
we really ought to do is build the subtree first, then either dissolve
it (without any pathname resolution having ever seen it) or move it
in place once we are sure that everything worked.

