Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97101CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 21:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF66A8E0011; Mon, 17 Nov 2025 16:11:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE5E8E0005; Mon, 17 Nov 2025 16:11:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A868E0011; Mon, 17 Nov 2025 16:11:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3DF58E0005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:11:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D6BFB7EA8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:11:45 +0000 (UTC)
X-FDA: 84121345770.02.6327442
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C108B40007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:11:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B7QLXXaH;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763413903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os4iqAgPdJRaPzcJTd2ywfGfbl3diO5bHaQFQg2eOXA=;
	b=RQHe7bJ8Ewh1JMUZvhiGTtcFME1N35cbUk9yaczYYrjGHa52XE7+R8numUzZ5ORpKWu5DK
	WEGPd0el/fZyaixoRCpkQOwjiRptkeZWuyt0GCK5RbjJknIwUfFLL5ELPRQutFc0biUslj
	S/hxJZspTkKyF3+mLh/h8K6zf9sKXAw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B7QLXXaH;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763413903; a=rsa-sha256;
	cv=none;
	b=PofuCxZ74m8ianfmBy/fTRVRSI1i0R30L0eczvcRFhlgVDi7nCSzETMm5JQvGkBS5F/B9j
	UDd8Vr0zrMQ4/EoqGgZlJdxKNqPIzCK8qMOEdkirs+0WtAQcLp186G1mVHZYQyovsmwQnL
	bAk6qESDgVhYZ7jaYpYEq4yIfJD9k0w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EDE2944491;
	Mon, 17 Nov 2025 21:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44A7C2BCB0;
	Mon, 17 Nov 2025 21:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763413901;
	bh=bie3kN86Jb07qh+6ZaiIlQYo+zkE09+CG7RupsGe1d0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B7QLXXaHf0sITCv4iAsxWlaf7s4zlfoviVYz/0zLfBC9hHK4TW5L+fRcWEH2flkZx
	 F8dUOHmtLf4SGQMlAX8YIg99ukJF8vz+tfpNCqDW8UAogvgq/g5brKADLQLJJMC0uO
	 IfGTLHUpNnVmfQNMRlWel9DQB0hWfJhAFG/jmDY854HSXjnOWCKUBdItbWhTrPh9N6
	 pd9o23MWct8ZxEnMv9y3CpZ7RpxlQq4v9AhEGbOYN56ObB6PyKQX9/7q4dhKY2NHK7
	 EkIQ9GGmutwSAt1xFi3zvMlFrSGw2eMb7eTS+KRyWzGWfLkfyExS0RRjfv1SNFFbAc
	 LmuWGRjhMeAkQ==
Date: Mon, 17 Nov 2025 23:11:14 +0200
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
Subject: Re: [PATCH v6 04/20] liveupdate: luo_session: add sessions support
Message-ID: <aRuPcjyNBZqlZuEm@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-5-pasha.tatashin@soleen.com>
 <aRoEduya5EO8Xc1b@kernel.org>
 <CA+CK2bC_z_6hgYu_qB7cBK2LrBSs8grjw7HCC+QrtUSrFuN5ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bC_z_6hgYu_qB7cBK2LrBSs8grjw7HCC+QrtUSrFuN5ZQ@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C108B40007
X-Stat-Signature: qc37u5kpew4oftmt3pd56z65oggy8rfe
X-Rspam-User: 
X-HE-Tag: 1763413903-6703
X-HE-Meta: U2FsdGVkX1/tke9jGRaIQ4mpe5nX8VdnoGdUMDrxbugfWYejlI2igPxB8LhtyC2InIbktOy7eQufW10wGIxntEc7h5z9rvVzih5FdAcHXURbYeoSUlM0X+HAod5Dwglnq7OUBsn97tC7osHommGb+Sr2x0onA0P8HZjFnlCMZcSqhkhmJG2Ft4iN8ye/W8XsSat5WveniEAvSYa7+BIqYs5gya+usVuqfrAyF9kBCjyilUW6F7LQkDDZLJQPXl6pkhPFn4ogLcd8CVHPi+Md6+BdDk8eIdv8l4BBkw0XGaX5MTjOta+XOe8sZbVDQl3gXITPUFGoatTBazYfEYf9cNoRSu8xVKMAXs4/WC82f3sDYk+O4C0pysRJ1aWf5yxOQtKyh74aqSgroiscBS2vl1b7lil5VhMXhODXd0UL2th5mBSdaKNIAI0FMcY+mLWA6pxXOuC7cwQHtlTuETHr/uIsbHdDoKJZuejpwjr7FQ9Qj1bbGhhYDKFJ/2+QHUMo1JNO5rsAg3D38juKiRvPoRZTzcQCANmLjhDxEk+0etoISa+04CFav87LK/TPsfsOzxBvF3cTTw3TkTmzJkRcBqDjEMJGjs0f9mFb0fl/UPa3uDW+8w9dMDxdE7kcYGkEn/ku96wk3ofogILZJ5BNeSkTxErNQRYPiFvIXOeCbKw6xqeZr9jYjXD5Be9yPGCFyt+CEIG096sgI0Ob5Njttn++Bt9Pf7USY8OX1CbrZ4uyugj8fRZh7VQdoNJb1JaWArpvtEi4GJIoHNlDvFk+ysLKq41/A8hNVJqO3v5Cnb7a6p7UqlyddVdS8PX7vgucFncptJNQPHCfGIjloMtCYmUEedghkkaJWSl5map1xhEivJsQZrriHRVb/QO49RmB+K3iNGkprEYMf4y8lx8tHQrx1cpjw86BQiHiql9KOI2BbKJ3xWDYbUktFwHldD/xwDMR9Pk6MeqWqZ+REVG
 5loxABsp
 /u66u6CgJfPPdmKa86PiT4dx4LKxStTHNvHBbge9TbBr5duS4cNxfnUU8IdMKoa5He6o52Z1x/W5QLW2E5WAgULrTwHo7J9ulHDwBxdjhp8+DkfbY6YzJlPPDhqhbWJsDTleuaHLpsv58VC9VQHzYEJc83+TQsPlVcsPGbUgWPkAP/7gXUyLkUfXm5s3xpFhOA8Lz3W0rQKlo9nUY1fdLxM8k5J3LckdW9RQ5YrsV/XWraMhEK6HX1MhZWdhfQcmNDe9uCpQ/9f4hIgNG+FjUJ59Fh9F2Klyi464EUZx+3pJRa5NFmYdxak4bk/Oh+SwrEf8g1FmGSaf+KsOHZk8ZKMxXvanU2fD5/xfzs9MVtV0AwqO9J9j2d3sJjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:09:28AM -0500, Pasha Tatashin wrote:
> 
> > > +     }
> > > +
> > > +     for (int i = 0; i < sh->header_ser->count; i++) {
> > > +             struct luo_session *session;
> > > +
> > > +             session = luo_session_alloc(sh->ser[i].name);
> > > +             if (IS_ERR(session)) {
> > > +                     pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
> > > +                             sh->ser[i].name, session);
> > > +                     return PTR_ERR(session);
> > > +             }
> >
> > The allocated sessions still need to be freed if an insert fails ;-)
> 
> No. We have failed to deserialize, so anyways the machine will need to
> be rebooted by the user in order to release the preserved resources.
> 
> This is something that Jason Gunthrope also mentioned regarding IOMMU:
> if something is not correct (i.e., if a session cannot finish for some
> reason), don't add complicated "undo" code that cleans up all
> resources. Instead, treat them as a memory leak and allow a reboot to
> perform the cleanup.
> 
> While in this particular patch the clean-up looks simple, later in the
> series we are adding file deserialization to each session to this
> function. So, the clean-up will look like this: we would have to free
> the resources for each session we deserialized, and also free the
> resources for files that were deserialized for those sessions, only to
> still boot into a "maintenance" mode where bunch of resources are not
> accessible from which the machine would have to be rebooted to get
> back to a normal state. This code will never be tested, and never be
> used, so let's use reboot to solve this problem, where devices are
> going to be properly reset, and memory is going to be properly freed.

A part of this explanation should be a comment in the code.

-- 
Sincerely yours,
Mike.

