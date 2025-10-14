Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A430CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C028C8E005D; Tue, 14 Oct 2025 00:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB29B8E0005; Tue, 14 Oct 2025 00:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC86D8E005D; Tue, 14 Oct 2025 00:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9786D8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:52:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49C1AC0713
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:52:44 +0000 (UTC)
X-FDA: 83995499448.01.913A45E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9509F14000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:52:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760417562; a=rsa-sha256;
	cv=none;
	b=3MIIxs29v9hvGGFWgffuS1BCc9tTeKs0hE6n+/qESSUviPruq51UQibdEdlz8xyUmi8Qd7
	4AJ8PUqw7VlSjifMIhMfMUlqeBHYFUvzCFqKfKGfERaWu3A5Zx/UCAM0yPN2fngqkivyI2
	fOWxkgeDt9g8Kd+hK9PF1R0jxHMaWi0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760417562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYNi7v4oqUnqFZQMbrx9Av9oqoG2jtUSAlAjctVk0VI=;
	b=tfqf6rJkye1u+WdjJQ+CMUoYcq/Mlaqcb7eWOjBZQbR5gL0DkGCXcTc7fSA2M3uYbJ+EOi
	bCcfUS/mYgqvvt20z63Q/FSQ9SzB2HrBv262RKa1EBoMfSNp6vAcGZ2Gc0UTNtU4JQfUz7
	0GqH78sDfQCnMJOxgSHbIabwQlssD2o=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1B7E3227AA8; Tue, 14 Oct 2025 06:52:36 +0200 (CEST)
Date: Tue, 14 Oct 2025 06:52:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 07/10] mm: remove __filemap_fdatawrite
Message-ID: <20251014045236.GC30978@lst.de>
References: <20251013025808.4111128-1-hch@lst.de> <20251013025808.4111128-8-hch@lst.de> <4e508d42-9cd4-481a-904f-535b1de0b765@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e508d42-9cd4-481a-904f-535b1de0b765@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: 14s7qaraxuk8r6qwxwt35pixwqmyhoyg
X-Rspamd-Queue-Id: 9509F14000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760417562-906846
X-HE-Meta: U2FsdGVkX1+sYaQFS5ok/pXjnpYXBnyAgN4CDbp0Fv5MWcaskS6dXC+coTl/6ju8oD4SDKk4myeIrjQtTJOU2UGQXnIAM2+aD9lZt/6Nx/t5+xCbuDfuvlpnxnR35CNlFmN+1/E0yxwGMm30JBKspStwVWepAZCmEpEyCo2CJ5QNmhuM73QReJE9mrJfQ+DFU1M/ru2qqnY79Ci4TYQ8b/mFe+DaCbKpyh97jYQ8mE/cfSqSlI6hir/6vjq81i6gKESc6+SgyksAdRJ0p31/qiq/0JyAszvn0vUDshmgc0KWJfXqvVO+jpvmt1sI5P0unNqfwqVJsQC0vFjuR++FDiNwFJMWmUAFdBsoCzOXuMGYiZqNI+3CSB9YkvyML1DkiY7Bnm0WI7HB45IZAczBMrHrR1l9l19AUZEO5kpFr4CgEjnGbhKNqpVodil2QJFHTR7fEpgk/lkY1Dv8eNo/SN2EbBVGJhRICo4wnqsZngZMKtBwgXd8gANrpaeKQYNOTQCld5SL7kcFNnMpHOd6RzS1U0iyvi+7Fb396y23MnGdyjngDckJpaLYCofmMTaPoyFjm+qNnxNsQIjjKYSdpMpBb6l38jXMpp3Ku8aMuEc/HTwEKI4rYxB8iy3YJQd4N+MeIYoTUEDDapS8LvIH5E8kpzeo37P3K2n/1eIwzRlcC6u+ISz2crsLwf+14gXDzh/T0zCOItne5jyNtI1zeWbJtxZRhcQzhigbUK3uUHx2zWxRo7nyXMisiJ1TtAIM3zc62F8yltH9JGeOsoEcwD6dxQtfiTLfxRVgmghuPJGzcL8yV9mlqSVfuXNQ8iG00XGNimSqjBEd3IVnOzWw35agoRuM4AsheAX4JlTaXY12yJbRSleJ0pnY9CW9F23b6DFVcdpQnjfK1rMd+kLljot4VKc2F41V9e1knCh636moy3YC2ZOBlPs4WAkrwctwtBa++GuduoaTYXeGa6a
 gHHOenPn
 sVG1BxviptXEEuLIXQpltqzK99IdvJRJHxk55QG4gfasGZHs8PaMc0p4fJE422Bx4R+7QwioVf+EYo+80woRXyRF+DniD9xtM5SPXrjUm5vY2Ja1iVWPNs5fp82j2aLvAXRYm9Cst/FgpXqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 05:02:50PM +0900, Damien Le Moal wrote:
> >  int filemap_fdatawrite(struct address_space *mapping)
> >  {
> > -	return __filemap_fdatawrite(mapping, WB_SYNC_ALL);
> > +	return filemap_fdatawrite_range(mapping, 0, LONG_MAX);
> 
> This should be LLONG_MAX, no ?

Yes, fixed.


