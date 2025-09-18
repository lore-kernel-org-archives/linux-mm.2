Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE717CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 04:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1089D8E00AA; Thu, 18 Sep 2025 00:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF1F8E0093; Thu, 18 Sep 2025 00:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F115A8E00AA; Thu, 18 Sep 2025 00:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC8008E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:32:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76A1B1407A2
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:32:07 +0000 (UTC)
X-FDA: 83901098694.18.FFCB73F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7D5FC0003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:32:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=B6lohcSO;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758169925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfCOzq37KBAmy3PY+6m63BgYT+OI2dyI6tznslA4gvM=;
	b=zEyO6Xopb4hxT5ReKM/UnO+dBDgy0K1XC1M14Y/EmQpsHDxEDLF1jfHjV6hTKw5evG02dY
	HTY+fxpeAH0eDi70BNXGm+BgObJEu7A50Ew2BwdlkQdNLo+b6s81d+vKCQ3rqWJytKJesf
	20xmLgzly1g1ptAKtluo27Q7FYd5JrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758169925; a=rsa-sha256;
	cv=none;
	b=LyyfGunpzcegzGzOxGtMmgWL7MutIJ3llw1LVbS7vZ0W74Vl/jiEAp9PcI2FF0DmR9RhnP
	qJ6eUqf8Bp/Qb1KastMr93pBA4Tz76jPHqnhaU/ZW8wxq33Vnxpgkvxke4Ejujz3Z/JLl9
	z81nKxM0BQMEA77PgcpjHHttUHID9D4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=B6lohcSO;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C95FC60010;
	Thu, 18 Sep 2025 04:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189B1C4CEE7;
	Thu, 18 Sep 2025 04:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758169924;
	bh=M77ITASNVzLLImCdqoS3b49c0JcaD23WggnJUmr1UUg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B6lohcSOCMTKlBrW1kViDlx/4iBrxvDkdpxJzeManoz5hs8g8HnWP4LQGtnJdnxw5
	 ViWvBezOBvA+jOg0rlNypchR0dgnfxFNznwUzfn8Q0OP5AwSv2L3bd5Qr0Bv0ArcZT
	 F3n9J+ca3mzSUsQzOGzcfdFw05zfzSeLs9/ByuC8=
Date: Wed, 17 Sep 2025 21:32:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
 tj@kernel.org, muchun.song@linux.dev, venkat88@linux.ibm.com,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu
 <mhiramat@kernel.org>
Subject: Re: [External] Re: [PATCH v6] memcg: Don't wait writeback
 completion when release memcg.
Message-Id: <20250917213203.4608d54da45a5b8bc80c2004@linux-foundation.org>
In-Reply-To: <CAHSKhtdPGuMW0jRRgARGt+ZdnC02v9O11=ofsgRmnZny3c5aaw@mail.gmail.com>
References: <20250917212959.355656-1-sunjunchao@bytedance.com>
	<20250917152155.5a8ddb3e4ff813289ea0b4c9@linux-foundation.org>
	<CAHSKhtdt9n-K6KGXTwofpRPo-pH0-YoKFLtEe3Z4CszmNL0rCg@mail.gmail.com>
	<20250917202606.4fac2c6852abc5ba8894f8ee@linux-foundation.org>
	<CAHSKhtdPGuMW0jRRgARGt+ZdnC02v9O11=ofsgRmnZny3c5aaw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D7D5FC0003
X-Stat-Signature: 13g9uw4uktxno3octayykhwiz7w4jhut
X-Rspam-User: 
X-HE-Tag: 1758169925-992143
X-HE-Meta: U2FsdGVkX19tGcgZXBW7CzLjcto63K2JvXf9bplgRVoN75cpEghEuaXa0Y3scvjIx2gVCLY2/UWANnj4tzhHv8h6jzVlHCO41GdOjhi5Cd/1L6AJ+hstGxv/rBx4lp4kuC+8DRmv34FA4X+ba7zeg07bgn6iiXRh583E2IeN7DQDUcfilIgaBikNsk4SSyrmFR/DQnXd2ebv5fS75EhehpFc1AFXysFRva2ViqC215R7lRY5gRX6m9k18yvTf+SjxXb+T8+SXPvs7JreVTsTPuEiwxdf4P//zlGBhse06oFEAOMDPZhTLcQYgH/ACZGpW6jc/Uc1ehoK5qeSp61dGsLVmaq7vb4xBQ8p4Qtm3AwEIltgPrbTujh5jUu49yb9Yi8Cy9dP7R4/BfwZhubb9wUpX4XYViLdlvQibQpZUt2Tdg0d+TocNKfeWQiVbPTGjf9EYu7uXYfo03GtyXDGMom0yJtPo4KObPs97jjDvoe4en0Vl7azHRJEoVz/eRs97/hBBVAvosSlj8+E5OKPflOzXV8HvH4uVJRO6FOkoY3/A7vRQi0lf6wo89j3tTyVTTQrvMJRj0vld+Dm65HU88UFp5wo9miY+pinU3BdOFNhzfKOQJo8NuUB/YrCrn/0E5xwsQhgnD9RNRM6AkHs0CQBFrpFMOmWf1WBQrUNYNhtaSPtZ7Fh7d/0F84q0VGQbSSu93l8K3zOzYuNXhxgdVq0bd/kAOc3YHvM2lSH/9qznarfjKKPMhKe+HETuJ1860MQu1Q6sICKOBIUvKSnlftGKAKBFanPGeDJXkONDgA99Q6aj5n9j/anmxVENZ3/kHXfcRITE14Gw1mXbYYNeOehqXO4fNA4yHcenbK8mZb9upHJwFqDKYTi1QbEQGQh++WF9tAD0VM97dk8S3LTFG9cDAIeBXt7wEcpxUfJeGaHdSMJemOZ5ywrOXjMHznu4GPsCp6MDBLVx1MmgSh
 1MjAAOQI
 1gP0GnLKoZt8EjGpmlQ2Ex2W+n14jBjmInYRiFnC4KlBbItIWhLm9AB1xHmfiGWexFyaQh04v4WOK82Zdoyug+glEjNh37oBljFSfeyS8UU6KidqTYOCYOWxKQVrjkgmQiJUcgKTHBJMNT6kFszAuzUZOYS/DlLBwPFo880ie6x3pYZymyNIPUxpICtmQtOehG3gDI17SeTUyeV6iBb7rgEiZagLwUItyU6SO9qSl18q1TaSc0bPUFzysBcbIGEaL50ZLqJvy8tVGc/L2DoexaKdyxzrYVsvHivx8G7Uraowb/f0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 12:22:35 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> > Seems the intent here is mainly to prevent the warning.  If that
> > warning wasn't coming out, would we bother making these changes?  If
> > no, just kill the warning.
> 
> Got it. Seems like there's no more impact other than the pesky warning.
> BTW, I'm also seeing many hung task warnings when the mount/umount
> syscall is waiting for the s_umount semaphore—while s_umount is held
> by the writeback code path. I think the hung task is also undesirable,
> right? Since AFAICS there's also no more impact instead of the pesky
> warnings.

Sure.  Writeback is famous for potentially taking vast amounts of time
and that's perfectly reasonable and expected - lots of dirty data takes
lots of time to write out.  There is no misbehavior in this and warning
the operator about it is just silly.  If there is no action either they
or we can take to prevent the warning then just squash the warning.



