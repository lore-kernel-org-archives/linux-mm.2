Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D447EEA84E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07FC6B0005; Thu, 12 Feb 2026 16:53:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5926B0089; Thu, 12 Feb 2026 16:53:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96F76B008A; Thu, 12 Feb 2026 16:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 990926B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:53:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4120F1602E6
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:53:26 +0000 (UTC)
X-FDA: 84437156412.22.7C4E222
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1C3D280008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:53:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VDhdKsNv;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770933204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PQbQqJJLCbQmlIGol0AzmR2YgJKABa97ASi4IkwW84=;
	b=l9OvgkTYpgSpC8uAmRB4e3H0P9DaLmJMkjILjJbKhJtmnBH7NyTBpZn7I0ueMwW5hM1G3U
	d5gMpvs1wX+vTuSr9sBrhXW66ErElKY2W4xu2UtiQxOd5xyuIwY2MLfyo1tSvpUosdq8wh
	hc/59jYK8RVNBGYYUh+MBME6NxJTfa4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VDhdKsNv;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770933204; a=rsa-sha256;
	cv=none;
	b=ZT9Fv6olDWAhENAkGRO6MbRbn8OOnwObKZRk5SG1vfYGCLv8aXwqJPXPDCMsiKfgFl12eC
	lUCtBO+3pyIUmIG/uG5txE+6N6FBjYjEo/4PjVhT1acEzwiYF1tAgyCDFzPw07ZrogcGGm
	4WzMEGkJzoEvPQms3pfq+VNUFW3vKhE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0PQbQqJJLCbQmlIGol0AzmR2YgJKABa97ASi4IkwW84=; b=VDhdKsNv3wZfuk9wH/G9eJDteK
	U97oeP3qtKqEpqurSt5LBiTGaq46ErIGtWzlk0dlbZduXDtQQZoLbayAR+h6Uvql6fsmxcU3nSpon
	cyvkIFtIPD7slmHwuZkAEIjjQybOweqvRsVI+iVoRJ96qgK/0GkkacoOUsRhM8qCV8to1B+86Mld4
	cKDtekIaXwImU/6IsfgxbV/W+3zejStMP3AJaVk60jBoMZR/pMv4cD29ntTSJUWAnK35srnBbipA4
	oN+xVLObBTzU243+Bc1Id4qK7g03whOT+QkxkV8vBiV8heCUGsUiXWm6UBLSHzY51+M4CXPYHdBbi
	tqUv1tOQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqecc-0000000ElyL-0zCy;
	Thu, 12 Feb 2026 21:53:14 +0000
Date: Thu, 12 Feb 2026 21:53:14 +0000
From: Matthew Wilcox <willy@infradead.org>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	mhocko@suse.com, rppt@kernel.org, muchun.song@linux.dev,
	zhengqi.arch@bytedance.com, rakie.kim@sk.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
	virtualization@lists.linux.dev, vbabka@suse.cz, weixugc@google.com,
	xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
	yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH 0/2] improve per-node allocation and reclaim visibility
Message-ID: <aY5Lys3bPh0O_pDJ@casper.infradead.org>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <aY1dusLPzP2AHP6f@casper.infradead.org>
 <3bf72620-88ac-4c56-b3ec-0fcfa53c14c8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bf72620-88ac-4c56-b3ec-0fcfa53c14c8@gmail.com>
X-Stat-Signature: 6xq8usak4td4p5ibz7c1twqhjtoq61ba
X-Rspamd-Queue-Id: 1C3D280008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770933203-221391
X-HE-Meta: U2FsdGVkX18LDkgYexDYiPVuJvVmhZBOzDq9/yOWAr/IuZjsQNWcsqD+0Bhn5Mp5x4Gxz5P9dz/4U6HPSqzjSWHtBr3350DmBcy+KOYupm9P7guNDNdenxI362bjYmMBYIc6udo7MneCrVZEDG5IVK1ITKRPrhjpoJEkVQ4Q455CzMbeY1NaB/Nwdsozw/lJwMnOaP1C2Tut4lP7tau8WzFw11LeglvdwoEudPDMtPxAajrrTTFTYRQHOhijQeb6t5JP02KISClW9a7ZqM42vBF3OuylFX7V57jtXcj1O9Wsw9z9JoDT10LsOSgivUgK2DC0tVcXEVoQdQMJK4zGvNEZeCI3LMfQ/MlznFeadf4tZc1y9ZD41pvwvW3HWdSby5fWQwd1/hZzvVZqw0D7OmW2CNVqm+58nf0LffqhGuBjuZTSMboPoVmTYqoejDD6OLQ0yJRnOZzjt3q+hKUhBgtiTsGnkYnOXdre3gf+nopFpkuC2QzJz76EH6/UehJvIj0o2V1JgsXTWPHm+1OFsMqvQDmA4PnBVrVm1vxnTBc9hlvWZk01QWjwSgvOKbnYX0NWE//a4WRzY5Bl+4aDboCfVXzQUAk8P88JMzBewMo4LvP51y3oOPhCmemI2EH9Avq/KCJRNOcycrk/SiPmR6Xr1lsS9Ojxq407+LnvBPOJYdjcPPtJ99w1qqKfGdl4WFj/mGT3aQqWIwRSED7fCJVOj3iB96Cq8uHq1EV+RXzJyjSbWi8TX8b3BmJMkI2QBq5iuyooSsNqiq3cGfvFuSvsjR9DXUCqKUezuwrn7AArEhtwdqlT9VwY7dVzr8fD5QKI2DkySBMs3ux+w60fqzck5Bc3kJX1+cggaNRxNZP9xttr6jDblAe/Otc9PH3HbQhqUugfGcn2OG/XnI45qhDOsTjbbKMYIn6rMFqK5Tjly3hTSI1oXJLzX1JTvsucoBH/MmSPBL2rCH1UjO3
 vohXkMbb
 en9sNYkmaGZLhLt5Ob5AKh3KIUECI9MnbqHdoDWg7JeunkqdxsfK1ZIpiew/yL+H/KGvC8zNjQAvqw/OnBPAJjGLpynI+vHwljM5vccvIYohFjkpQBKR1qhTm6z/bQurzDYWJiiMuFHWx6YLBEAjWTfgs76uEydJEYiuvw13ZIQSHCqa8g98mtZvh+a4qDBu0zuP9/uZuA5qxpbZ6qX6GAROHb+W112PrhzahddoxQPKjUGLwrQJXh2RVjhXcNFg9FXlADW5MBTLhsqpJV5FMIANnpR1YHoyTyKnsDsOxe+Xu9YfwHuBkyCQ5zYqc0Tc8/4/Hmydw5Gtz1i+Jo/J8FZ+AfF9mtlcUTLgCx67Ridte89agJ/+Hp2rbJRrUitkRYbneht3YDxtdVpr9ys5NsOr6nYK8mZb20Avvo2ZWZ4I3Mq0Gvrhz0H8HTVHmaWDRtx1X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 01:22:09PM -0800, JP Kobryn wrote:
> On 2/11/26 8:57 PM, Matthew Wilcox wrote:
> > On Wed, Feb 11, 2026 at 08:51:07PM -0800, JP Kobryn wrote:
> > > We sometimes find ourselves in situations where reclaim kicks in, yet there
> > 
> > who is we?  you haven't indicated any affiliation in your tags.
> 
> Meta. Is there a preferred way of indicating this?

Documentation/process/submitting-patches.rst:

From Line
^^^^^^^^^

The ``from`` line must be the very first line in the message body,
and has the form:

        From: Patch Author <author@example.com>

The ``from`` line specifies who will be credited as the author of the
patch in the permanent changelog.  If the ``from`` line is missing,
then the ``From:`` line from the email header will be used to determine
the patch author in the changelog.

The author may indicate their affiliation or the sponsor of the work
by adding the name of an organization to the ``from`` and ``SoB`` lines,
e.g.:

        From: Patch Author (Company) <author@example.com>


I do this with ~/.gitconfig

[user]
        name = Matthew Wilcox (Oracle)
        email = willy@infradead.org

and it goes into the From and Signed-off-by lines correctly when
generating patches.

