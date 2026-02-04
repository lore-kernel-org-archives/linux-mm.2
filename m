Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1994E9D417
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 17:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27A46B00A5; Wed,  4 Feb 2026 12:05:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF456B00A6; Wed,  4 Feb 2026 12:05:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE2E6B00A7; Wed,  4 Feb 2026 12:05:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC8536B00A5
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:05:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 865F013A2AD
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:05:29 +0000 (UTC)
X-FDA: 84407400378.24.C9C2AB3
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63B1AC0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:05:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="XSvW+/Tm";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf28.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770224727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJ3l4j3asswhM7XjwUVXUk5e7OhriV8G+Oiht6GM9xY=;
	b=AWvY1sXNj4yBz3f0DZIUgw9RUCYxn2azAMabIMaEHX3fQvTLuqQF2csCAgpmNa5UnA2RPj
	4GvVhYPqgVZEI+nF8osjPJT80kimcPGFblVPuQ3hKk4MSfYx4Zt1DWIAolds4vv2I/09uq
	YDtRHxA8m3/AgkKxHQRWc/8AHffHvzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770224727; a=rsa-sha256;
	cv=none;
	b=EwgSJl0UDq2kq5ciutzFy1i18a9zKAtvxSlmVQFNomKzLXW5I0a2ujl9TBET7zuCc1yQGW
	aUiFCq/moV2emAKUxHWMj4D3PRLjTpGVkvaiwE4Zg9w0xU+/+cMvaZq+rgeGZDvPKRDLlr
	+ttfz9jxjtlKlZt4w95JJkyYbglIbcw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="XSvW+/Tm";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf28.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
Received: from macsyma.thunk.org (pool-173-48-119-77.bstnma.fios.verizon.net [173.48.119.77])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 614H5BIR023448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 4 Feb 2026 12:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1770224714; bh=FJ3l4j3asswhM7XjwUVXUk5e7OhriV8G+Oiht6GM9xY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=XSvW+/TmM5z/lRQHdkTU5AkYvflunoywwW4VEjZ7mOj2d6jBDXJyaPqZviQG1xUD5
	 ALqW4v85qBHo2o1ncEHVqA5uTz6WDkJ/7yIfm1oE4HpgajkRn7UkHDoZWE9mEpUCzK
	 7IwsBd+t2EUJUORqF2lWOBSqWs6lT8Wl53Npn5M/WC4q1yRR5EfmcGcS9zBa722dN4
	 ZQQN4mF5lynJecNEvw4Pi8HGXN58BaH0fQVBlQ9/aawjZGzzt577rE3WIi6tHt6fGI
	 kI9R79SK2uXBq9MvH4cyFhBt1Ul8fHUxn8qttJEyVM6V1CbButT2iWP6g2vIjdp06z
	 sA2qZlsJvKQkw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 6119A5738D5B; Wed,  4 Feb 2026 12:04:11 -0500 (EST)
Date: Wed, 4 Feb 2026 12:04:11 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Christian Brauner <brauner@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Orphan filesystems after mount namespace destruction and tmpfs
 "leak"
Message-ID: <20260204170411.GC31420@macsyma.lan>
References: <aYDjHJstnz2V-ZZg@thinkstation>
 <20260203-bestanden-ballhaus-941e4c365701@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203-bestanden-ballhaus-941e4c365701@brauner>
X-Rspamd-Queue-Id: 63B1AC0004
X-Stat-Signature: p8az3dtgpsjq6drjpo6qo7foyr7qnxc9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770224727-281035
X-HE-Meta: U2FsdGVkX1/OpXurqXIwuu7MuTx3SF5zhCJDWE9kOhPI/MAt35GgK3hUJlEvwBVY0T5MFRDe0MFf68ckpogN7uvJw6pSOMr1yiAMPqLwusloSOJxCZIV/SUFOdHvDYH4Oh/Ug78M6bluOmJVifn2ApA/t5xiPMq8ZO/LwWrYBHO7DtbrkJCF359y/OqSSMeQQwmS8Yh72LQlrfmDWs1/uK1E/Yr7GeEqAH4AC3KIIxHISLWnfW6aezOcyfgeQgIn4diwA4mKoPvzJOkLrCxN6uOLfetVMx3BRX70ZVo72FuflX8/WORvdX0cIc32fFEbH6b+a75wi9A2srPJVijeUohYs2oxC/mX+416wk7OgxdmHZo1REZVUPRdUZToF2PcnL4EiZ7RdS++n/pszOu9FdUxLff+aw0aU6zgQT7x3rYB2Nbd5IdEj7TUrdWno8uYCxLiA582ttuD1/JgiDGeDr+XKyq0hyfx7hBQd+NI1Umr7QoMQZe1Oj1O2RsTKGK/0rRuklkhv6fIf5z0pjbvqNMPeVRlRMc3kKchLszRsCn3MgIMt1vECRHRUxloVTR/HyU4AVn1ruoXmsyXO+4+ZXWlAjuQzlYFGWiKoQA+5yXFUpdrYTvwb65II0lDoIHx1Er8UaWNUwpFCzNWjcaTu5xMo5sR0uwaFpjozHzttpdSF9hmSbUcty7bArAfgyDuxw2TFoIWV3txNVYtEQGG3/1nPYHtphGrT4AFzt3SQjHXA+sg3PLJ1pQNwND5Yb1FoR5mN1iNn/KfWAprxlLK3aUVpcXyD+hx9G5eyLhVma0icQXmzv4OJR30bjI4tPvVu3wOZ+XdjxeAOOhwhBW77YWvtizgivo3aSd2PGV1UHIOjeDLg7BCETqHevKfasUNcoASVykhn5OX1cT9Jf2QcA3zmkACHCOZFJ46eTQc61MKEmyAnsFpBi5HYCyO8IdqnL6iXCh5kgN619H4yuP
 1KyADVkP
 4D/zZOhfhKhYN9Yvrww6vdfdwSMRPFCgkCb5FbaMPDtEItRvE8dcRdyiXmHvX0idEMYPJDlSAu+uhslmXT9Nmx67N8dmFMbbPeA2wdx44djM6FK6jdQfJ91E5+vMmb/tPEnLgo2myTTN2IcPTmI1x9TKuQcz9PfbC2SG2lCpWW3F9Y1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 03:58:52PM +0100, Christian Brauner wrote:
> I don't believe we need to do anything here unless you want some tmpfs
> specific black magic where you can issue a shutdown ioctl on tmpfs that
> magically frees memory. And I'd still expect that this would fsck
> userspace over that doesn't expect this behavior.

I think if we were going to do anything like this, adding support to
FS_IOC_SHUTDOWN to tmpfs is the only way we could go.  Yeah, it will
fsck over userspace that's not expecting it, but normally, if you're
tearing down a file system, whether it's a read-only iSCSI device that
provides a software package that needs to go away because the iSCSI
target has gone away, or zapping a tmpfs file system, killing the
userspace which depends on it with extreme perjudice *is* actually the
right thing.  We use FS_IOC_SHUTDWN on an ext4 file system that is
being served via iSCSI, and when that happens, killing the container
and the userspace processes running in it as quickly as possble
without harming other containers is the goal.

It might make fsck over userspace, granted, but so does "kill -9".  :-)

   	      	   		   	    	   - Ted

