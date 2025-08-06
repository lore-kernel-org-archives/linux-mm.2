Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FF9C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 23:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5976B0093; Wed,  6 Aug 2025 19:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7862B6B0095; Wed,  6 Aug 2025 19:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2EF6B0096; Wed,  6 Aug 2025 19:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA6C6B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:19:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFB101A073B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:19:50 +0000 (UTC)
X-FDA: 83747902140.29.F05C479
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD8FC100004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:19:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="URXqgwx/";
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754522389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6QOt2ArdADNBAJU4PEVq2qG6ReKiOxj9ZcPXxOARXY=;
	b=w3Qx1R+vbSe6F+DdN6jlE+YfJgFbFE3bUIR7aREoQkjgbAeK8zcfXWXAe8iE+9gDILp3T4
	4ts7qoUUhpG9r+ZGaV0na17jJcdM2snFC55gvqtsEt8cIpVrrj4Z55V1N42Uuy2xzvqSla
	d6BwCmLAV+Z+KJj+DAfULpu8wHOedZE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="URXqgwx/";
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754522389; a=rsa-sha256;
	cv=none;
	b=TUjZNikpUo5dmQfkzlOlOuYTE1wd72I3ICpnM14nizwj1KACGfnRFbbfDuEKzMgNPtXZbU
	nqKWyJIe8jR7B1ifV/qxa/ZlUTOTpsGrGKMAgqejXvC9loWcV/rlgTNNsr1CpIT8rzLPuL
	zG6IIVzSIGKSGQ45S13uj8kewXJR6r0=
Date: Wed, 6 Aug 2025 16:19:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754522386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6QOt2ArdADNBAJU4PEVq2qG6ReKiOxj9ZcPXxOARXY=;
	b=URXqgwx/5/5PY0dFhng1uG+sZJJQasTsnvBd7kueJ4x1mVsoLJBPTHoiHL3CE3QP+2EDNy
	rz6hus8qYRjVDYdE2aK2zOLisVWd5HnP/a2cjtbnBFCtH4g0gWLnA6y8/f3TCJ+Dig1EK8
	zg1s7W+0Yn+gE5paA/pOoP3+jqwrbww=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, 
	hch@infradead.org, wqu@suse.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org
Subject: Re: [PATCH 0/3] filemap_add_folio_nocharge()
Message-ID: <mph4trybfnzki4aiq67suf2cki7cf6qpvqlojxs45hywgh2gfb@7qnhfp3y65mh>
References: <cover.1754438418.git.boris@bur.io>
 <aJNgC7f9RVr_rh47@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJNgC7f9RVr_rh47@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AD8FC100004
X-Rspamd-Server: rspam06
X-Stat-Signature: c6c91dry4w1ax3rk7xcicx6tjbro91gu
X-HE-Tag: 1754522388-402216
X-HE-Meta: U2FsdGVkX1+dHcO+YQ58C7XfIdEbbrlZdmNVCOTavezAmBxsCRXOaWbOd/4aXgDN2Mz+Fr3nJO5ghqj+g+jdEXkfWThv+C6Nq0sdgosY+Mav3uCWWMV3RFEMLkIuall3RLOYZAlq6XyYqxQTU8opn6wzjO2Rf3cRmPkEAcJG1GOVDNj3DVZhuwvpubpW98aP3pBKgCBVp+8hF0lcE2acpUHwvUCB6cyUM3zWSq33sbk96vhfxMaLzoTMp2xCLAT9VDiqNIN0rZ5BI2dGwavUDZRnQsJKnBlTO5AD//cOCSsPjKbOwBCK0lJisNsR5UAvRpB66zuIN4o5nI0kZg1cdQRsEviEKLd08w+Ey7PkbYhnSe+Wfkcg3cTHgv2t99QNkDop7ia49G8LWGKBZH62K3dHzGB8r/dZ/Kw3HcpZgVnmCJT1BztShRPtLpkWI7nvffgAE9b7kFGtrJ6UvgHuJXFOQD1fidRCihh//mjHcrxtxjZtlc/A7AGkOqVGhgzxMh2GysvMeaAbSdZhK4qHa7DqUgJL9mfo2qrrR7rol0z/8uvNenhmLX03CgHRVWykkWYrssKbsWNhWV3Kr5t6M9lluNx6PJfWf0vtwJ8D9bA0V3fimQSdMzyf2Xag8zSh5EyJHlCAZdopVphm0PraKxdXx9SfgZ4cAkmTSI2l3GTKca1gA/4P5w2y/gDE/MCoE42mmOAb8HRz1S9wBczPWumDnJmhFSQlzDKiWGelqf+K6J7VX63hUVBvKrWcgH9hOOJ3IlSB/e8jxYzpjl4ZkR3WUilU4us9JeVdZ2n2kfNtRH8cFpPH5/xeKGt1wP2dwe9MrTpG98XhO9ULz0xtmTr0iP7dBtf/inbCpC4tjPIV2aA/tJdfSr1phIyvfN84bkAGREzIuQekPZyvLvbI5rIKHXjKfD4kc8CBQg6UFtAj2NBMGLNj9NZMR/11+dWIUxdG92slZfb0bkUOMI3
 HSzMhH8b
 S9UCjLrgLhZOzjwjGlQZz7yXMaSRTD5oHAmdZv2j2TydQFLrOugaVol6gmYGLINsS9VNexm8fv7/CR/ivzq2OXjSEDOXlNFpn9krVtuqNC67IMmmBzq7MndKsQIsQM+SlpseMu08URoZBdQKeyqoRiRq1zYxKqkLu7FgFXIViDzn/F/+zFEdhJPRYB+sHE1N/zPY5VVRr84uJcRdQ4ZSBzVWAJhUJfUzRiYd3ny3cfMYHyvNTbU/7HMgTbwQhj5JTjgoftOjOr2lj6PtH8Z6+/7C+QyNQ5UGAmXnNcW9LmKv2ZuP8Ux0Jva2Ql6SSwGY9Jg46eXDGrhqtQis+f/+D26QT+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CCing memcg maintainers.

On Wed, Aug 06, 2025 at 03:00:43PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 05, 2025 at 05:11:46PM -0700, Boris Burkov wrote:
> > I would like to revisit Qu's proposal to not charge btrfs extent_buffer
> > allocations to the user's cgroup.
> > 
> > https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
> 
> I prefer Qu's suggestion to add a flag to the address_space.  This really
> is a property of the address_space, not a property of the call-site.
> 

I think Michal wanted call-site (explicit interface) for easy
searchability. I don't have a strong opinion either way. However I
wonder if having this information in address_space might be more useful.
At the moment, this series is using !folio_memcg(folio) to detect if the
folio has skipped memcg charging on the free path to decrement the stat.
Having information in address_space would be another way to extract that
information. I need to think more on this.

