Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9748CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 21:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE5E8E000A; Wed, 27 Aug 2025 17:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E8E8E0001; Wed, 27 Aug 2025 17:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D6A8E000A; Wed, 27 Aug 2025 17:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80DD38E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:15:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 439E416088B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:15:31 +0000 (UTC)
X-FDA: 83823793662.06.6AEA1BA
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf02.hostedemail.com (Postfix) with ESMTP id 32D7380009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:15:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HM+MoNbM;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756329329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rcc5U5sbYk7C+fJouaFaLhZUqm8inNlgZ+ZSLJCNPX4=;
	b=OhCFBSIev3WwB3KoHWpcv2G/0DxBlrmR+qCXmBKbGTYrioBnoGoma5EK/oPNryQgZ+ycIP
	3IEZ/KsrAiYlxH3tBwjcwXq2A9dX74BpGwTA2PZ7o3VVMe/jkagG6Lb3mGJzkLRvBFZYTZ
	1qANtI7K85AAfCukkXecYoMYjsRCO7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756329329; a=rsa-sha256;
	cv=none;
	b=EVrznAWiLEE9uLWN/XgFQli4IqXvugDcgd2PyLRUMFZ0ToZSCfH/+DEK+ntM1LTrrn8noy
	ns5ShB8Eo19N69HuLV8RYrU0XxlGFFebruj92ZWgaxoDCHZi8Uu5lKb9oVPbZmGEunaxYY
	Ma5BZBaXqhAkcXRSXd28G6uuX53emfM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HM+MoNbM;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 27 Aug 2025 14:15:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756329326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rcc5U5sbYk7C+fJouaFaLhZUqm8inNlgZ+ZSLJCNPX4=;
	b=HM+MoNbMsASGnf9PdqLIBZiLT7S/fvLPSA+4c+b2WmnR90L0kJ3APowlgO5+qbgAzEU6Lq
	UiCQbQHsZyBvPNuf1ozbITBcpLgxRV4AThg5lumSZk/ANCftpc5c7/iITOteh9CZQh0sMv
	fnZBlC+Cy8vru9NSp39gtom8KRaS2/M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Yueyang Pan <pyyjason@gmail.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <5o52rxp4ujglel53cs6ii2royaczuywuejyn7kbij6jknuglmf@frk4omt5ak7d>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <CAJuCfpHyXWwrKkFmmbHTGtG9L-JK2eCt03ku9364i4v6SJKFbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHyXWwrKkFmmbHTGtG9L-JK2eCt03ku9364i4v6SJKFbA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32D7380009
X-Stat-Signature: 9wgn7hj44p9zha7nh5x9tgkq7zymg61d
X-HE-Tag: 1756329328-54833
X-HE-Meta: U2FsdGVkX1+mjEZmonj/okwBU00dtz1ON7DdnHl5t3jmVmBC/dZhccmr4XTbNceWaA7y+uHz0y92WFjucNVLCmHgYHiCePWF5QZXKov/h6PKFYkGx3x0GRjSjJUfvkXwkeMFMJ8pzBdvhwYYZl9ytBz6vgxA0Fdhredm9o0AziiMft1AWOzPRa7LYE0WcXZAWEI+ugMp9KmUV6R9nqkqzFSxeseoot3tH8Z4y6HUjnKevsiV8eYbNYRBA2dJAxtbhO/zLzptnxLKN0n0R3zAq3OD64L0s07cNyZg1iFZvkOFbFBqaMZBa3oAzTDMW/+2gw4wuME/KYoflnORMD6KeemnCnV4ZxYutaaZfqEODh+VS6ay/9WCKPKF9/O+soeJAY4Y3gP37+p/SHq0NbCDPgCo7h4wVpGM/V463AJeVl7aqtMLyIFBz3hgBFlXf0xao5GwFXKwYmAlvhtRCVwiM7aLb/FC5r1k63PMfDEZUCvCuerwT0tBfnKgGX7KtrByeseoOvs/sa6R2beJBP1U2cpVnCOUgXj0dmUAegIn3nKM1w7iPG+Yd26ZPW9Y0JQO7No5IvDaMXFtBqiLst8Rkwip1l65jCmYBgl9Nvs9RRT6f7GkTZPXMobFbOFGgAvhz8xmeCoTapcnkSoaz90D+5Qrt7QXmSBYcCzJHG+UKLk3Ltp+z8XlLftUqJhv9W0IyCKZXokj+JlaKS3tu2msZS7sXj9yHhgC7m1/NuECjxg9SDM3QtU2/GouYS240pdjP5rHgaodiM/R7029FUNgNdcAS0nq5LmOvlOJ0okKjWohyAoXvhy0sdQvoHheh9DeFSV0IjDJjInbGilKLwjZY93mxdvvob07TN+KzNURmPxgiNQpdcNg6WTfvjHsD29bwkEMkBlIO3vFPbKamyNA/ySzfoNdQEa1rNAbK7Cw1zKprDyt4Z7AfavE1IEStwuqKmG64tvFmUv7faGMytw
 jDTOC9fl
 bayw4rUi66iYkX+1tZS8NTRXi1G6plUFhgY3YugCFqq7uC+yXznF4WOlHknUSA1iqVYZvcwYbDLySmKIGwja+NMhWK148rQgtfG+IVw+bCq+bLNBnQxtoJumZm5+WBdty+EXi9P0GK6p3N6ToSLHUkhjQPNrh/HwBxmlERl4XS7xtmTlZQD8nQu9JoBRJSFn9/NUgnIEVG7QBTFz1Yk3oy8fCDQg7A/qV4PC26qCkrx63uIO+A+fSJI+MrhuZbzCfoX1yQIx2I068F74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 07:32:17PM -0700, Suren Baghdasaryan wrote:
> On Thu, Aug 21, 2025 at 12:53 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > > Right now in the oom_kill_process if the oom is because of the cgroup
> > > > > limit, we won't get memory allocation infomation. In some cases, we
> > > > > can have a large cgroup workload running which dominates the machine.
> > > > > The reason using cgroup is to leave some resource for system. When this
> > > > > cgroup is killed, we would also like to have some memory allocation
> > > > > information for the whole server as well. This is reason behind this
> > > > > mini change. Is it an acceptable thing to do? Will it be too much
> > > > > information for people? I am happy with any suggestions!
> > > >
> > > > For a single patch, it is better to have all the context in the patch
> > > > and there is no need for cover letter.
> > >
> > > Thanks for your suggestion Shakeel! I will change this in the next version.
> > >
> > > >
> > > > What exact information you want on the memcg oom that will be helpful
> > > > for the users in general? You mentioned memory allocation information,
> > > > can you please elaborate a bit more.
> > > >
> > >
> > > As in my reply to Suren, I was thinking the system-wide memory usage info
> > > provided by show_free_pages and memory allocation profiling info can help
> > > us debug cgoom by comparing them with historical data. What is your take on
> > > this?
> > >
> >
> > I am not really sure about show_free_areas(). More specifically how the
> > historical data diff will be useful for a memcg oom. If you have a
> > concrete example, please give one. For memory allocation profiling, is
> > it possible to filter for the given memcg? Do we save memcg information
> > in the memory allocation profiling?
> 
> Actually I was thinking about making memory profiling memcg-aware but
> it would be quite costly both from memory and performance points of
> view. Currently we have a per-cpu counter for each allocation in the
> kernel codebase. To make it work for each memcg we would have to add
> memcg dimension to the counters, so each counter becomes per-cpu plus
> per-memcg. I'll be thinking about possible optimizations since many of
> these counters will stay at 0 but any such optimization would come at
> a performance cost, which we tried to keep at the absolute minimum.
> 
> I'm CC'ing Sourav and Pasha since they were also interested in making
> memory allocation profiling memcg-aware. Would Meta folks (Usama,
> Shakeel, Johannes) be interested in such enhancement as well? Would it
> be preferable to have such accounting for a specific memcg which we
> pre-select (less memory and performance overhead) or we need that for
> all memcgs as a generic feature? We have some options here but I want
> to understand what would be sufficient and add as little overhead as
> possible.

Thanks Suren, yes, as already mentioned by Usama, Meta will be
interested in memcg aware allocation profiling. I would say start simple
and as little overhead as possible. More functionality can be added
later when the need arises. Maybe the first useful addition is just
adding how many allocations for a specific allocation site are memcg
charged.


