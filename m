Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13A1CF9C73
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 17:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105CC6B0095; Thu, 20 Nov 2025 12:20:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE926B0096; Thu, 20 Nov 2025 12:20:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36456B0098; Thu, 20 Nov 2025 12:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E09D66B0095
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:20:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17311C026F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:20:49 +0000 (UTC)
X-FDA: 84131650218.21.30C5894
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 86130C0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:20:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sap5ecG9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763659247; a=rsa-sha256;
	cv=none;
	b=lXX7OoWH3kZEiaQXg+54ODzBwjODlNSfjB1Vxw+k5HFO4XopQklCL7Ll0ITFYKuDMDXFEb
	QHKGtc3NGfovikfwajYbNhVlEX9sx5MGs2vjKeajTJxIYMOtHiWRaY9bOF+lojnawmm4OT
	kLtHYQRMXtux2mYOmx+i0nVu9zAibi8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sap5ecG9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763659247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y23bOop1/MFxm87uTde0Jpn3gqLN2TJzKAK3shfeWSo=;
	b=Igz6Nwflt872OfYEzoqGxHqQmB00NQViLt+rUgKg1nRb9kdYLpacElGiW9fHvP2lmA3ZXO
	Gxdj5EsmGM/EGm6T4zzPY7p4aIk1qYdKdmCT28P7zxv0dQCqyQZgcftq/ayU0hf21RZ/6E
	052gNsNsB3o5o6qFtY+hkU7FFJDc0XM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC6E7601DE;
	Thu, 20 Nov 2025 17:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B32C4CEF1;
	Thu, 20 Nov 2025 17:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659246;
	bh=fD6KjoGzF7YWD+p5+muskUl3aspahvddrqQqiF5E0oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sap5ecG9LGJ8wpTAYDVKAIMrPJKlHSE68WffXz2yNvUZnXdIBn7l8lIGbnotMc9qc
	 4UvFnri9+3qxNKGHl1DKfj1kfzW8tWjCrq0Wav7skSZi671Y+Xf3BWLH2EFS6gHBXG
	 uUEEe+2Dwp3dW/x64f0jRgjdsbxlTY8DsC3kGsqTj3QqbdbduJse9G9Z7WSNL0FsbB
	 asf3PkIfJ9IBdOPz2qY0QGN/6cAH7zMJK4iiliG2tCWB3F2jLmuZ8MrGZSMjJPqcmJ
	 YC8Sp0VH+4R5da77Tmu8lT9QmYW4efCZoC+vDVYT9qDRZBb1/fTjzStTuXldlhqgnJ
	 gMvfzGioMt3RA==
Date: Thu, 20 Nov 2025 19:20:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 06/20] liveupdate: luo_file: implement file systems
 callbacks
Message-ID: <aR9N14KWaz6SdFcw@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-7-pasha.tatashin@soleen.com>
 <aRoU1DSgVmplHr3E@kernel.org>
 <CA+CK2bBFS754hdPfNAkMp_PqNpOB2nY02OkWbhRdoUiZ+ah=jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBFS754hdPfNAkMp_PqNpOB2nY02OkWbhRdoUiZ+ah=jw@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 86130C0006
X-Stat-Signature: xgeezq8z7zwnnx5yaoyk65txs61emqo5
X-Rspam-User: 
X-HE-Tag: 1763659247-113509
X-HE-Meta: U2FsdGVkX19oURwnIjsjuQKP/FsS1PT/MNcA9e3tSI+rwqVnQ/IEvHvfxDWbASN78SWRUiGuKqJlS7cfIuWJwydadnSI3K+FiB0GOAfErxPiJIljI0CVniY8kAlesGmld5Qw90Cl0XHx6NUc3dzw8tFDP5qo54yXHzgrfBIqVtldHjVu4f27alQqW/rdwnO3Fo43GvblXHgTYZd7BpZMWwp5v7CAgXrueUxG5eWvNkMlwtmAkbQnWk2tjBEtExO/eKlFQL6MP17qyfjEz1QUaFL1i8w3bwZ74MifrnALIF9lcEOnDGcTa++t43v7bqv0VaYnYllLZsorEZUtFhGDTLK/BoWcP6qJF7SxchuF5QRCZTyEVSLWudyIjo/G/pmxtyFcVp4f+zSr2NCMkPGKk8pzD4agGZU/vcabs1Ff76O2b/ZL4vWSi4JG4CHtHKi9it9oktu33UeOJwdqaS1qf1w9VN/b9mD87MzG8OS8Dyb5gDJmT+TQX9ogkGkPF1Cl3hSYU8M5p64fmEh4plT2kW/2cizA8wzS4UiINLoWoVVt/3wPs+qZmxrkE8T9xYhLpnHuOUeR7mopPddv0HrqkyPNGw8I38KNI09e3J0L6iBkrulqCAanI7bjAMgq0Lksa/Zs65mv1MX3wrpAdGJGCqOFdKuapbWBMnRI3ylobONzcgauIDFg3NLag54GIHWQZJEK0JXZeMEpYo0dCm7ak7oVYWU4hzBznIy9XEH4ApJm5wVeneXhM/aVfYRlEJngXNradBc4GQ210NGsQRCZKtt17gIWacCztvoTdsQUYMEAEYm8YjHvRCtt92dOfFlC6bJKbD/tGxdtKFVW8CM+5I9RwD20+8q5P7LaABckDiFvwljkthEKQfXyUqWDOiRPkWR3NJQ3Mx1h6qhaBIY8XFvRRrvyQ2Ir2JTAENG8Tz9z0hk8u/JLz25hsK70Pc+ZNNxyt80OVAQkeZihJu3
 EuDyL3DJ
 bXneGwcmRhqcwkTOj5GZ2oNz22M67IzuVC2FKK1wqikL3pABgW0i0B/3P4vi90uK1JQfebSl+bW/tI6hpeOQ/nWIS/zckVNCWO1/9rL6DKhV47yzVaM41SxSJAIaGvmG57xadTC2xpqhIfWc4vmddhnzaOw3YScvJFLtbeaa9CzRVh4hfWZcBzeqcPPcU5IgFxuQ+p+NGr4+g5wvOGrp/ZvQJKNoHr2TooK6xscEkEBFcaQ1t60ZHepp3IhMEvEuzhjAsbsZM6QInq8OLaauOWMOAgmf+8g+ks5z8czAZluJKXZlMUAaeYPdFmjoTBTUNuUqTgEY1PgadmlV05KId1LWi4+MPpsDAol0Cv1F5w1ujxlaYHoJQGdmKrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 12:50:56PM -0500, Pasha Tatashin wrote:
> > > +struct liveupdate_file_handler;
> > > +struct liveupdate_session;
> >
> > Why struct liveupdate_session is a part of public LUO API?
> 
> It is an obscure version of private "struct luo_session", in order to
> give subsystem access to:
> liveupdate_get_file_incoming(s, token, filep)
> liveupdate_get_token_outgoing(s, file, tokenp)
> 
> For example, if your FD depends on another FD within a session, you
> can check if another FD is already preserved via
> liveupdate_get_token_outgoing(), and during retrieval time you can
> retrieve the "struct file" for your dependency.
 
And it's essentially unused right now.

> > > +     }
> > > +
> > > +     return 0;
> > > +
> > > +exit_err:
> > > +     fput(file);
> > > +     luo_session_free_files_mem(session);
> >
> > The error handling in this function is a mess. Pasha, please, please, use
> > goto consistently.
> 
> How is this a mess? There is a single exit_err destination, no
> exception, no early returns except at the very top of the function
> where we do early returns before fget() which makes total sense.
> 
> Do you want to add a separate destination for
> luo_session_free_files_mem() ? But that is not necessary, in many
> places it is considered totally reasonable for free(NULL) to work
> correctly...

You have a mix of releasing resources with goto or inside if (err).
And while basic free() primitives like kfree() and vfree() work correctly
with NULL as a parameter, luo_session_free_files_mem() is already not a
basic primitive and it may grow with a time. It already has two conditions
that essentially prevent anything from freeing and this will grow with the
time.

So yes, I want a separate goto destination for freeing each resource and a
goto for 

	err = fh->ops->preserve(&args);
	if (err)

case.

> > > +             luo_file = kzalloc(sizeof(*luo_file), GFP_KERNEL);
> > > +             if (!luo_file)
> > > +                     return -ENOMEM;
> >
> > Shouldn't we free files allocated on the previous iterations?
> 
> No, for the same reason explained in luo_session.c :-)

A comment here as well please :)

> > > +int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
> > > +                              struct file **filep)
> > > +{
> >
> > Ditto.
> 
> These two functions are part of the public API allowing dependency
> tracking for vfio->iommu->memfd during preservation.

So like with FLB, until we get actual users for them they are dead code. 
And until it's clear how exactly dependency tracking for vfio->iommu->memfd
will work, we won't know if this API is useful at all or we'll need
something else in the end.

-- 
Sincerely yours,
Mike.

