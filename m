Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51323CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 19:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC548E0002; Mon,  8 Sep 2025 15:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CF48E0001; Mon,  8 Sep 2025 15:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B488E0002; Mon,  8 Sep 2025 15:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7193D8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:08:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1586F855C4
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:08:10 +0000 (UTC)
X-FDA: 83867018340.02.4DF9850
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4740B80003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:08:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F83k32kO;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757358488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGp9LNECER4PONZr9C/fe03oMsJEOgr+safV7HEdOq8=;
	b=C1KhUGVQocCQB6zhMMuwlv7W9Sxw5mYrTr/K6+EApFry0ZAW6sQlujp+MZxgalnJMKnG4j
	uHtJiSTpCYRDI1pOdgyX5vDOBDL9z+XWpVyjZQTUQg+rb37/4whrpPJ/sQ6pzeB6SVh/P/
	onxhAL/0cDGhxe2i4AfUAEnEBDwhrWA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F83k32kO;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757358488; a=rsa-sha256;
	cv=none;
	b=vchZwWNLIT2+y+/lvO6ZP3/WrwFWSK/PacW/xg6gUd0B351dGeHE54DFyfNdJwxGDD9H4W
	ydbQIT1ohrtoGya13RAiFxqXNYS6kqBuX05GpoGayn9DpAWgosCb/zaPeZLv3cg8ab5b+j
	7y48nfSQdS5l0sKzTNTuaPWf7/Z6MqE=
Date: Mon, 8 Sep 2025 12:07:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757358483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QGp9LNECER4PONZr9C/fe03oMsJEOgr+safV7HEdOq8=;
	b=F83k32kO1p358K6H++eGircDmUq+XCZC/aspVKfnFaMPaxp8/t0SQcFIkN/dOImro4LmKB
	zaJDIlMFITlhwcR5N09VvQvIZI2Kf39xcTmnxRzBw1+81IsdJ7bSptr8GUi4zzeQBHH3F5
	KjlsBkB4qS+4o2IpWTm3uIGTlTSje+Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Yueyang Pan <pyyjason@gmail.com>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sourav Panda <souravpanda@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <cca3gvk5gco6i2vbjvtarmi77imgj5y64kqb7bebcrbjagdwca@4p6zq4iaiqr6>
References: <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com>
 <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
 <aLFKHGe2loD657fu@tiehlicka>
 <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
 <CAJuCfpFynEuwBSu28UiRDjWrayN-raX4Nqqh283MwRoJLi8bMQ@mail.gmail.com>
 <uoyjzkybkqd3wkvauofmorv72gnjisoq3owvijsezpt3wbrazz@at562ngtvszd>
 <CAJuCfpG17E_yoZeqEDrN0PFn8UBKqiGT28KDwEDmBm6byFje-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG17E_yoZeqEDrN0PFn8UBKqiGT28KDwEDmBm6byFje-Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: znfc67tr95jdhjqeoizf84u64773db3i
X-Rspam-User: 
X-Rspamd-Queue-Id: 4740B80003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757358486-925061
X-HE-Meta: U2FsdGVkX194NWKidTFZfHZnMqZQ/6fBXan9pLGjnrI50cYzdUsHsWRNDoFi3UQb0VQxKgGbp5/ngWPG44CagrilqUqub433ONjLuKW/6LasWtyxMbEL7HNLGlftmyjIZpiNxFBz5THVeXxg1o23Un6DMdlfNDVUn2iAUHLP26KpYXN4KGQcfNgiBTZvf5LHkRRmyN91tBsD7dk4sr9UcRmqJi/j44qXhxt213kcMmxaIEFiZORLI+gJmMNB3mScg3J+mVR/J1OJZ3AhvlwCSjKMGVuz2Pr/RDyeIJOdovlUYM3jh5rkdt247fSwFOdsRA0QLW/MQr9aabkaelvrxURB+KApGQOWEELK8WpZQvWUxA4YMbAYdamNxAg+SZVBgXGw3Ti921x6Ije/+8l01ZVKRqojFqMy0qCEFiWPs4J01QIyfcaLCbKIKuPrttepHsNDydmcHdEWwkAz767yI4OWNhDzl7b/gv1V4r78vDCypqp6wqO5ZlvHSGlhDajXYleYk9+ho3WfhxJYtGpRMQSEqtAaRf+M/SsXCf/oXqO+Nhdzow8lLbuBpncQwNvEiLRqTW9tBMtrJ8LuetKa0uRDhatvruVc2TqDXJ7CSWS8mE7hIq5CQztgKk+UVP9SEzITGCu7nRjc/bGGAoC7yCoMye5HVWyM4vgbAva2eSXEq4C+LdfV2eFl3Wsc+sPtQRIJ+wtVHfsX1uV7CLOheoCDUJFT+1CFclGiQAy2YsUTJ5RgZzL33hsrKNkGKiYPnlduGoOXekIqd1WUuLVVFd5j+eng2wWkJ762B2OXSPq/Zu6NDm6aeMBWYVI7vT7Y3fmhG2zcak42PKLbZfA5Lg6bypzqze8nAx5IUJISWLVxRKpozWIdeSSa9O7kWYKeFXXFVQCVu0DiIP02dJeeN9JbRjIHGuuZoCwNjJ8niBPibfuHD2VpD/eUBo33pAhI+wubURMfkaubIEK2qJQ
 a8wBHYo9
 k3c6Gzcdtks5tL+L9ljFyPoXZqhNG2M8m1GLVxlW/Wuz8aqGdVUWsF/qfnj8JmE7Ffaojc3n2j5D5MpUWy7Oybgymo5VFhJsAMrNash4R4gT+QThMBAQdUZxEfAYTUY48uCAo792NDWDybkcOfkz3bcrwU7Bl75y9co/H6BxO0Gthot0Y3aij3gccGoxBHj3Jxp54ZatoprtIjQkvBqjLWY7xJEPOnK7bJ714A5GygP+oWU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 10:51:30AM -0700, Suren Baghdasaryan wrote:
> On Mon, Sep 8, 2025 at 10:49 AM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Mon, Sep 08, 2025 at 10:47:06AM -0700, Suren Baghdasaryan wrote:
> > > On Mon, Sep 8, 2025 at 10:34 AM Kent Overstreet
> > > <kent.overstreet@linux.dev> wrote:
> > > >
> > > > I think that got the memcg people looking at ways to make the accounting
> > > > cheaper, but I'm not sure if anything landed from that.
> > >
> > > Yes, Roman landed a series of changes reducing the memcg accounting overhead.
> >
> > Do you know offhand how big that was?
> 
> I'll need to dig it up but it was still much higher than memory profiling.

What benchmark/workload was used to compare memcg accounting and memory
profiling?

