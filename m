Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3CACCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17BA58E008E; Tue, 14 Oct 2025 00:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1541A8E0005; Tue, 14 Oct 2025 00:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0919C8E008E; Tue, 14 Oct 2025 00:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA91A8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:53:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EB16140706
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:53:31 +0000 (UTC)
X-FDA: 83995501422.01.42F8021
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id BED8840004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:53:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760417610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOeLdvm2NKqje+280ndbvU+m4oWlm7TWv6r2vUoI3S0=;
	b=LSF+BLETBrzUuB+LY9ewv3k+YNbo89jk/8iI1Fa0Fg5phJVaGLKLW7ashEFpIBrdGkCw4F
	fA1b96K7eIyQ6yakAwMuOYROWtQQfqZhZYiMDpLJDpBlSMx1moNoHYYiVMAPU6Wp3hXF6Y
	Fb8Wlo330wey0i7//k+E5E2i4JhD7xg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760417610; a=rsa-sha256;
	cv=none;
	b=sihzKJWZ7hA1yEH8ZO7VNIFFRUS0QNg669wwbBeweIekTyFEzhDdQDkbNXCuFsVGeFNG06
	uW6LooKdlV5cGxzvymwPEiW/SzMX0EazDdzWWwp//b1EG6kJ8EP+d9FyShwPDO5wpZxnfS
	MMDJwg+uIJZVjvPwmYHYO6Wf9wado/s=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E5B4F227AAA; Tue, 14 Oct 2025 06:53:25 +0200 (CEST)
Date: Tue, 14 Oct 2025 06:53:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
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
	Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/10] mm: remove __filemap_fdatawrite
Message-ID: <20251014045325.GD30978@lst.de>
References: <20251013025808.4111128-1-hch@lst.de> <20251013025808.4111128-8-hch@lst.de> <t4y7xtgfnzfpfupnb7on33n6qzrfxfphsm2hqsa5rx4liqvvbc@wwj7ckhyilpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t4y7xtgfnzfpfupnb7on33n6qzrfxfphsm2hqsa5rx4liqvvbc@wwj7ckhyilpo>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BED8840004
X-Stat-Signature: mno41pjxwrmnxuxud4oxjrne9b1qsuxq
X-Rspam-User: 
X-HE-Tag: 1760417609-304616
X-HE-Meta: U2FsdGVkX1/WpKr+L/5yXlhjhjq6+aLqVRE6IQ5wjTKswYDCYPt+nPlYWoM9hnKbfPguysxPR5Hi+9oPA9H7wZSmfSqwuLOeVVlE7dPN355Jv4KLGJHHRKtcytmmEKf/tuOXmE4h0oLQa5BeULQ7cM7WShd9MAUHuQ9cLmtXeqH6lC60k7uqOLbr8Dbqxd/9PWkSpdy2vZj3b+jZ+CFg17QARp4BQOiQdwtAjo7qFNkniN0K02wT2oap4nW5wi5EdHJTy8bkdE+pepetLnaidjJufjXl67MwIMcxhpAmMqqgSMnefQoTEDvr2ua6u4IhuL4R+SzUQyVX0N3SNF12TwDtWjcziREAiKMCDWyl4DE96CF8HLCdBMQlUhcMVbrdrcQUSH+pQvt6U3532NTvqdx0n639GwprjNFP9rTN6nDN3kYLjLWhJ3/+FJbhONG/8LGMX8jIVlKiMtqk3X5BVKJqtN+mtffpdZVgIkwj1ooBQcYD0HmKHuW81gRZVwQtCuHri/5ok6Kz+Rmpx273+/3KDhO4DAN8MHU/ROao+WJ9xnGBU1aWyq+ekzNEDd6xNJcBhpcff4fUMKRIjoJcmctX0er0CCTfqxKYMoO2FdG6GjQkaY5mxprsl0nj1LglBZwAMxaoIQR+a5bJUrjYdcGcOApOlO51tPYVW6W4N7j5lHfiUZ8xZWJzwDm8lk4g6vt/EcLBOq/wmUPci37OXULi9CPZyROoMiiUeiCMdNDTZ3xqEG4vIydSNxTNmb9BOqhQUfPkRS/pMaYhyBf2IQpNUJ+Os0fSs+pq0XhkkVypjutCKxRcmpNwiESZH4G7xzTIp0awydGRkT8yWaSXLdF0O7nOSHcNMTOGBcqLYDDy3Wzm1RQGjAM9DpPX6tgcaRdXtSnVUo7vp7S1N8tswpU0koTzW8Zr8m/tlbWRPYlrOJ0JbYdS3lpLUlpg4wi8jJgQgPgj4IWj7Jy2m0f
 K4ZPLt90
 1H4eY7TGpU66xcPLyqoh19uwoRxnKT9gxazEuaJKRmiB94HITrnvojdzMXGN2pTg64f0X+d5qUtnziRI1DKT86jT/5vVGeYolhrizCCGhe1xO1vgkGz+mUip0MsPIOpzZJ5z84QgEKFkqTPQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 01:59:21PM +0200, Jan Kara wrote:
> > -	return __filemap_fdatawrite(mapping, WB_SYNC_NONE);
> > +	return filemap_fdatawrite_range_kick(mapping, 0, LLONG_MAX);
> >  }
> >  EXPORT_SYMBOL(filemap_flush);
> 
> filemap_fdatawrite_range_kick() doesn't exist at this point in the series.

It does exist even in the current upstream kernel.
filemap_fdatawrite_kick doesn't exist yet.


