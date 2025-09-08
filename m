Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCEF5CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065638E0010; Mon,  8 Sep 2025 13:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31578E0001; Mon,  8 Sep 2025 13:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1FE78E0010; Mon,  8 Sep 2025 13:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDE468E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:49:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3984B7426
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:49:14 +0000 (UTC)
X-FDA: 83866819428.27.0C8766E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id D6442A0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:49:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UuLquz8a;
	spf=pass (imf25.hostedemail.com: domain of kent.overstreet@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757353753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQg8gEFZWs/W0elemBVUBKG6Hh3kGDxreEQh4an/F3A=;
	b=T+T3yBqnoVbBNldtb+WyQ8u4VS+0xXgP3JdUdOp+cFC2z/1vpSc9pQp6DroKXhB9b3fYJb
	eZwdkfG9/zGTtlzRxuvqmLAHZhDFXy4OjBPjvaf5hf1PiBcGH6bJCoIWJKfgbX81DUN7Fj
	8vLKLb/L/fk3W+JCEWl41sqTO4US4w0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UuLquz8a;
	spf=pass (imf25.hostedemail.com: domain of kent.overstreet@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757353753; a=rsa-sha256;
	cv=none;
	b=LUGAJQ5z+WhwckiKAzpu2vYkXPZTZJjgaVv+kNLdRLOxMpij5E5Y1/1k/icu0KHggwCPm2
	m9m8NdII3KREE/ZHVtnyqsbsnpX98TQ3L0YaOPPoLKxpLIFHz+IMonnRducQIADBqcZRxd
	8Hax52KCjHEqVxfO8xmdxNq92daBZy0=
Date: Mon, 8 Sep 2025 13:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757353750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQg8gEFZWs/W0elemBVUBKG6Hh3kGDxreEQh4an/F3A=;
	b=UuLquz8aTIdheUlo1oy+JJbjcaPc4x0UA0/t5TkXgduokBYwTu1dZqeQH6phSKTNEop3QL
	eHVJia0mS2WEPE8MBGFFczFzSPjwljkxlfXQsqKh9hpgZ7Ot8MfRkgGMltaganW0QJGPvO
	sh7B4O+5owx3zgj1B+yoNYDxqrKbkLc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Yueyang Pan <pyyjason@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sourav Panda <souravpanda@google.com>, 
	Pasha Tatashin <tatashin@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <uoyjzkybkqd3wkvauofmorv72gnjisoq3owvijsezpt3wbrazz@at562ngtvszd>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com>
 <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
 <aLFKHGe2loD657fu@tiehlicka>
 <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
 <CAJuCfpFynEuwBSu28UiRDjWrayN-raX4Nqqh283MwRoJLi8bMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFynEuwBSu28UiRDjWrayN-raX4Nqqh283MwRoJLi8bMQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D6442A0006
X-Stat-Signature: dyeswzzq6benjzxugc5byf1igc91351r
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757353752-87377
X-HE-Meta: U2FsdGVkX18HcXtTNUtZETZwEMvTi4jD7xxAgVm4IxWlgx80v9JsVC2y588vuQej1LMUNt4YUOxqBpaPG5ctYh+FOniZ8sHi9r+UdAewpL1i9wgbBzEOBKkVE7GMyajGwexpz4VpnXcgcp60185I1nBFgvRIp275h7SifVBheWSWJdpl8V35m73KJcbCwzKNEe8iBkmvqZn3WHyhiFe3rNujLR40Lu2eCEyc23SJgiWYzw6LD/kLYiBeK6kJwuzRZ6MEbyDvlzJA+vrOAxeCPqfAqklNfT04cm2NQPTogoP1Zp9aOaTZVhGd4gzvhJ7Ttz4E56dnabNlbn9ARmZul+2CFie80opQACjhUlsMxrDL9ktWdraYfIQdzz4QVpH5/836dInBk569GiBzcBMWuhWmE5RpMg/PAEjth8x4h5V8fpygPtLkxMBn83lnMiZikb3zqt/6nYmkRL481spoRTYSb33sYHAvxXtkxMFF9SN2vd19fDVf9k3kDaJ0MxRAy03xSaUEKVIH9Sci1oH0HMdrtUZspgG6fF60ttAQrV6W/SE1xdK91IvsPV5jEpqschV4cVwiX2N0Zr57nxLsyHiJqB7e/HuZDGFNDkRe0P8jHDcy40obkHT/vZ7Srb0w/q7bgGE8lnYJdH9sHIMBF2YYqhoDBM2EduL67jn13mZ2+s0C2tumqfYTMFj1zF467zSN595G3pq2tCwBdLm6eGx7RBgcB/trQkNfg3unHgCxrF4lZghJfTHGYlddc3KDpZRJ/l1r2IWgoeHUmLP2wAYXgk5BD+sXaev0vaZi5Jy4Kuw1GtYPOismKL7JHBgpvZSY0PHmCTOWbhrDe1fs2AQzxjI9ntrhP1NntGpD2baIIJAA7KNxjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 10:47:06AM -0700, Suren Baghdasaryan wrote:
> On Mon, Sep 8, 2025 at 10:34 AM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > I think that got the memcg people looking at ways to make the accounting
> > cheaper, but I'm not sure if anything landed from that.
> 
> Yes, Roman landed a series of changes reducing the memcg accounting overhead.

Do you know offhand how big that was?

