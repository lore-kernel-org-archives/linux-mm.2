Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705BBC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 04:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A426B007B; Tue, 21 Jul 2026 00:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB6F6B008A; Tue, 21 Jul 2026 00:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401D26B008C; Tue, 21 Jul 2026 00:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A83B6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:29:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 947CCC0380
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:29:18 +0000 (UTC)
X-FDA: 85011504396.15.F46093D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf10.hostedemail.com (Postfix) with ESMTP id B72CDC0010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:29:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784608157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McKlMmXzSL0e7Lwk5MAf769t99eneneeTVdxoJRESeo=;
	b=DFcTaNkmXDTisgLn3a9HDzro3MDtfPvsX2dpViOaI2KUrvFwBlYWUhMFcZJNZwyDQfKXRY
	OTcPs9QrrgvBIsvDJa8KZSD78Q6cLV558DnATdcTutIs1e+rc9UM5YIOJ0TX2dpLMJMl5o
	nxyfwGU1YnkQkjtMGYASFbwRdazVoP8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784608157;
	b=XGywfDTIg5iQF2hVEy6HK6GActDERn20XrC/++e44isldE6WpJQL1k6VvR8J8al9tXnhg4
	58xFnBj8HZh5IGJ30RYEbnxbNmpK5xLXlDka7GIzvks7z+RoSpo8rlWOAcre2xBTeGsf18
	tPmC9thMRGMAVjAW6l/TbD2HpY6Aylg=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45AD068C4E; Tue, 21 Jul 2026 06:29:12 +0200 (CEST)
Date: Tue, 21 Jul 2026 06:29:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kairui Song <ryncsn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev,
	akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 7/7] mm/vmstat: add NRSWP{IN,OUT} counters
Message-ID: <20260721042912.GA6339@lst.de>
References: <20260706132206.935272-1-hch@lst.de> <20260706132206.935272-8-hch@lst.de> <aln4IQ0d1ASf50fz@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aln4IQ0d1ASf50fz@KASONG-MC4>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B72CDC0010
X-Stat-Signature: n9pqz5cts4suee9h1xo9hdwguszhxdt4
X-HE-Tag: 1784608156-362134
X-HE-Meta: U2FsdGVkX1/UMNqQ1F8Scvp/ZGKztp+n5mxOinYnjwT2f4KpbOMYwuBpmIJM6JKXrFPIQGVns/QYHNvkuG2ncKGksFjrwU3XgNt4x1uTkBkuh7+NaFQqrHHbFSjh+b0wIR7izQu7trl4MOmTAOKi9SsOdnR5JAEi/y9wX9cldVTeVtlfgC3gAz0SJNBAsvMukIUlYMMIUsll90MrcEym+ht/Ras+jHSUl2+ZrQ4d8eILM235k0Qvo2X72yeGvmY2UCjSnRq61UhVthko2OBDnGC8W9FhApFuxfI1cIb3IjnLA9RrWDxMmbZI3WZgMXj4X+tX4Dv+TGK1wlwNmcu+jTzbGmVEvggmg2WJ0kLHjwJufnt0TFcbRyHmSxRf1cjf+8OA+LyvCwxaQ5iibNZTipuLPYZ/jkCpTPLNcJTD8MdlVelJHhZh2An0ih/u1dShzC014jvEKqfMhWLU/GrlMpV+Rd2w6PquGitQzBKlOUTv6UkKBCCwGXOsYyCrhEznGfUCJUilP9noa8sGrRDsYNeIfxgYdNyZtviDHkThGM6Db7IRNC0ncmJbJtNg0e4R6DHZMWS/vCY2BxJxJCfDn3Q+3budd6hgaTLrWYV+dWX3bKrOQgsStoOCV2XCtl9hjLaxcBJ/uZLI5D9evCtwTwQxJMA3MQWmkAunVyqpTbdOySKUJKhRKYDOvOQV/3EMF0Ov7ewqnPW/FJeFoO3r/tu7LXzm5ebugFZPpjDdmabvuLOd0WRTP3yszGDdZwbpyggswC1bsbRFLmvIT4jKYl9PXYhS2kwEEdlbMCwCZlLl0brHkWzpblYf2EcghDpiFU0ND6sZOGXq7ZF2W4GZqIIldolnaCx2wBqaW70RFSp7lWsEJbALBRpTvew72M/a5C7IQIcg0QVM/XJgS5lYaZxnveASZcnZNhvZdPI2yWZhlmWscVboWvuFnJ4wx7XEEBS25eE8e9WUvwbw6yU
 k2KXSC6V
 mn4ZeO/8yBSAnrcQWxLUS9+J6mL3QnDm/77aUrTx0g8MraZzyt5RqZxd9958vINky2yuxMIdEFTy6p9mLZvAywSEP1g+lty9YkD/C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 05:43:24PM +0800, Kairui Song wrote:
> > +#ifdef CONFIG_SWAP
> > +	[I(NRSWPIN)]				= "nrswpin",
> > +	[I(NRSWPOUT)]				= "nrswpout",
> 
> A small nitpick here, all other counters start with "NR_" or "nr_", this
> is the only one that doesn't have the "_" here :-)

Most don't seem to have any NR/nr prefix.  But yes, those that
have the prefix combine it with an underscore.  I tried to stick
to the style of PSWPIN/PSWPOUT and pswpin/pswpout here. 

Happy to change it there is a general consensus that nr_ is the
better style.

