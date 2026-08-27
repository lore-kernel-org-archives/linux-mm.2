Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8239C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6A36B008C; Wed, 26 Aug 2026 23:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86BB6B0092; Wed, 26 Aug 2026 23:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C986B0095; Wed, 26 Aug 2026 23:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9960B6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:39:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16B4C802EF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:39:18 +0000 (UTC)
X-FDA: 85145643996.12.BEBAEC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4BD84100003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:39:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2Q2eBr4f;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787801956;
	b=YbdarlXuJnVsuBnDrYHFN2XWpQEu6W7Xt1fKl+c4LA8Yi3ZyI4iV2fiVMjeAJYm2eXYXHi
	pQs28s/kGTCpfHh+0jFL7LyzURmytUjjEfMw1wZUut3bjVnakBfssYFbp5FBm3fb4Ho6tT
	5BArSxoqTLyBOsZ8BEvCFWa8xQd4z0Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2Q2eBr4f;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787801956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXsP2YwUZlHzTTtZN5E9nJJQjf2x64DhwUQoXN0R/+A=;
	b=OUJDNIZtWkzLBznpoPZ7FCkTTFhEAYZWfe3pWlo6LhcQIsamURjWDn5KeIoLFQv7jGPe5a
	Um0MoCef6oFYptnC9rCVp4IOxY8jd4GBg3ijL0+6gz+nMcHviHPmWFUuvv7VJF1JtSO5BR
	55Iw4g0biXD1D09S3evRPVSnXyROOzE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9BF1600DC;
	Thu, 27 Aug 2026 03:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317DA1F00A3A;
	Thu, 27 Aug 2026 03:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787801955;
	bh=AXsP2YwUZlHzTTtZN5E9nJJQjf2x64DhwUQoXN0R/+A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2Q2eBr4fQrLW0DYCTT7cshE8D6sM9epklZxbZJsNyxlYyEn2eF1Xx0ZkmoXf2yKvg
	 lJR20JEiX0WjMQZwS0azL1NoaaX/icyB10J99MzOjxQmXDwUrQcnxSQEwQO/u3euhL
	 7iZqmAkJAWcuuYDlyUrMX6C6TvsWSfTkRplTdEVM=
Date: Wed, 26 Aug 2026 20:39:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] alloc_tag: fix a leak and a deadlock around
 shutdown_mem_profiling()
Message-Id: <20260826203914.347c42aa00081ee9e0eb858a@linux-foundation.org>
In-Reply-To: <20260817062726.106511-1-hao.ge@linux.dev>
References: <20260817062726.106511-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4BD84100003
X-Stat-Signature: td7wzq75m195t3cbox4wqzuuxcdacq3s
X-HE-Tag: 1787801956-86956
X-HE-Meta: U2FsdGVkX1/PqpHllgyvfoLOTTNJx0NsV4ZqnZ+IT0dGExDBce3wN2Htv/66hKnnlqXlffHk18XMd3jnooTmJpHR2RFR1NJZUCaRfhk+lgbWMGvrxwmcmkPN1aKTTvDCpAb/JnEEKIO78tiX4apW/2lvRli3ZhaS+KPtQEvgxJLne56XJR+kC6ZvvKC/B3B2r4A+KU4PT7jGPkhlZeTbDu8etzhjpnTG+uApMP4D3bFXeIWK7oRULE9vz30IHREFisViG7VZJCrJMc0+HzpYIrQyeCC4u/YZB39cegM4at4kYdEEpUhoS8Kg089k4wGtc4HL9wirhWjDAyLlkAHIpM7uK6FeKRYGB6WLLdM3QQL7NP3QRnsux8cwlaSYtiHrTy79gerB8aYesSjjY/p0RKLmKpTUt0Pm0naL/T6Kq+5nb7KaaGF9dZMiJ4EG2ce8nBnHriQI/oOmKQMY/UYdW67F1jJ1expzopwFHGqRv7B/6RunMvPtNlAfOo6efmPnERUpSySHbXJc5OT3CGPJLIprXhT2zEFAsnK5IZgL2BdMgtoGQFrMreQyE+3vbJeGhVMgpfQ28hDDiXYzyCeaEatrmDhahohrj6I24mcLenIEz6nyYsYGhTiBA4xG+1fO7XXydNSbPjn+b20t14RNwaSTeUmWCb1iOmwXWIAUAO3IU+4QtbP7YGs/ELma7qobycMAihS+o7B/ECLAQcfheW1OGJcdqngUzDyGhqw0GiXy0zfekl3PJT8qAeU1ok7SftNlw7lrg4gPPgWwx8tNTK6y/nTWhAY4OTetwl/4WpGl72vp6vaee3lUvDpOfoQMhekBQvB3DD0dBxR1gFCV1EHBDBwpyDBpdiXsXpaciZODjgEbxtcMlI61V8eMGRPwah2p8Bb3B95oIJ8o+470HSGd4I4Zyrxcv4u0WioH3aEe6HtsuwbM4pBo+oq9UJg8z8D6I0UHvyDQQeDpUB4
 etE6XNHJ
 RKXs3Xjw6Le6synR8M1LTLHZasQf7uvY+nt2TlLmnaj8RJYhUFm2/2dRfxSgn2SUc9+4bFFa1+eERxuphnJosM0Kwo54+dNxiaJo0HS4UPDEZ5UsItlzpOHoIylCkpUevJhy6nr70+raYqodb8lpaS23sO1S6alwotA83EavrGVe+rqP9EpZreOMZFm/LbJp/exOYzmXk35UAtbXPL5Bhj6AYtDXhjR11XCvig+EssFyaKi0TYaNCmOAjEBIUAS6XX4NE0RbpzqS6nZGIlflxW7o6soOnKTSC9ByhAly7+NtLQkDqJq0QLpVtfy48XJsTcLYSP4SlbIokYTHl7OmC+or2ISyue4vQzsF3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 14:27:24 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> Two fixes for issues reported by sashiko:
> 
>   1. percpu counter leak on modules loaded after profiling is disabled.
>   2. AB-BA deadlock between module load and /proc/allocinfo readers.
> 

Thanks.  AI review asked two questions.  One pertinent to your
alterations and one pertinent to Suren ;)

	https://sashiko.dev/#/patchset/20260817062726.106511-1-hao.ge@linux.dev

I'll queue the patchset for 7.3-rc1, with a note-to-self.

