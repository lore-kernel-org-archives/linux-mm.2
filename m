Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240AFCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2C86B0005; Mon, 18 May 2026 15:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C856B0088; Mon, 18 May 2026 15:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F42A6B008C; Mon, 18 May 2026 15:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 484C36B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:36:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E58D590CEE
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:36:40 +0000 (UTC)
X-FDA: 84781547760.26.1FD7988
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E94DC000E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:36:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHUbWISf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779132999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=hHbHTVnE4ktDLm9HxxCvL45A+droRm6zPjtVnAi6u3A=;
	b=1CFFOtCfw+wM+WdpIIhWMWmFNxYqn2YCVqVa8HTQ9/13SCuffXAYu4d6ykxcCMrBKa5P/q
	lGnLnLqWDJHEE+pdqOuVAukWs1p5MKDJxU9Id2C4FglpAXuIRYAH9yHqL7WOCp65aAlC9m
	eKMC/s0mOFOYWuL5xggPmRwO31v/zE0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779132999; a=rsa-sha256;
	cv=none;
	b=srl5i8dcfYLxD3OPzEQNENlW2jhBqBbM93BZ5JcleMycZgRWt3YzQ65p4kILeRLeaQTtqg
	kM+Axlpk8dahtnTLKrwfRyYSCpxymF6ipC7Eym9dH9FXliRSVDqGGemZbIxZa5SvwwPer9
	GSf/NmVksJgUXzyHaCoYXpFQv0F90TE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHUbWISf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E863344256;
	Mon, 18 May 2026 19:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D39DC2BCC9;
	Mon, 18 May 2026 19:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132997;
	bh=Wi4BvHbnLogHwDnFAOY65k7rUtfMvJIPCaPQGLK8bGM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nHUbWISfDDPMmeTskxlUgDj20zlZf5ueVVBgVCkkys/td237mdFYzqbo+3e2bKrP7
	 +I6JaY27VuRSK6VaJc0oAH6tC29ivAtndPbkgjI9eV967MvzipLcFuj5JLNgXhh+mW
	 CZ9C1ihR87awMWUbC6RDLrjiDLt5NPSmseTMxVMXVSTL7K32VAn/RxvxamnBkoqy17
	 a7XZvINC1MAYhvNAVPTkjob5f58PPVKUsCR+hZxb628znZfT5lp1eAXkpEt657oTLn
	 gkhWX7RSTVep0I5Ayg9VVCl2sTYfMQeM69J2pVwjQPO24a8jxhS+YAw96uwf09snN5
	 AwY37XiJh6aKA==
Date: Mon, 18 May 2026 09:36:36 -1000
Message-ID: <64f59b64664f769661a8b8cd587c85f8@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Qing Ming <a0yami@mailbox.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutný <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Hao Luo <haoluo@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/rstat: validate cpu before
 css_rstat_cpu() access
In-Reply-To: <20260516070849.106141-1-a0yami@mailbox.org>
References: <20260515122952.59209-1-a0yami@mailbox.org>
 <20260516070849.106141-1-a0yami@mailbox.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E94DC000E
X-Rspamd-Server: rspam04
X-Stat-Signature: pnxs51pw57aseierbbxcq55o5w1jzbqj
X-HE-Tag: 1779132999-892653
X-HE-Meta: U2FsdGVkX1+Qr4ItY+k0J1QCmEkOORmbYJI/f6T0f0Ir3u/zrg1VgrYfYPZ5k1EWNsMDbdcFvROINlR28jfY0tnsUKQitppa763oHR5ZthAoBYeusMeorLQKtz/j7xTly2sT4e+ZWv81gwKaxXS5Io+/QkAf4xTNOvnFXKK7/+Nzk/runlk7yjAWn8NoxvpMZQfn1YxoxokEEGxult04sCUF+XqDVmABMzilreNla8MvU8XYEPOQ1/plcESrK8si7+PruzrcEoICMIrhRgHvpYvve2SaeMRYo5J5nJlyo3DgZiLw2sWQrJoZqHGnrnBA9YwgCIeY1lqaJT1D6Xp1rFqfgK4AQKneM9On+uEGn3ONtfS8C4eviUpKRwSLM3RotQq5V3qqBCtC8mkSFP8GTHvi8GqXLAD3Q1MHLoRyNAUArHNyDK2SOp+19kDaJ66zEyOTpTHV5xZfM2eLdz79n7N9tN815NvKbQBrnDoiQ1nGDVzHaJUTsLNipkeh1o1XOLTGphdpGWZZtbUM18M4PfuybX5lI7KEZZS38oTj4kaXWY1p7fQM1nANMDyOOzTU0fDrui7tNfE6YP0i3Xwyt41N5jgi/p/tf0Jjr0IoQ9lXH/HSwqCfSyG4lgK8MPcLwK+stoWl0lOso6OdX+MLJgKjAlZkvJ2I0GpFyqhlpVffW0pnWwmLXAOr8vsMwXnJ+hSS4QWbHIuKrwCRfFP8LN8fpfmVjg+D2sWxJM5v03yzyFybNsy8sngdzd4z4b+056ag8UWi82+e9i24E5Nwk+TyaeSlmbAoIW3fbXoMVzHoLLXuATy+/Cb2LOouUVXmw5LpvvOqotYNx6ABiiMLgBwngR8/BpRO2UIxDqwd000decZ4IoT9YXxUv7L5GuDhgGvT0AxSCHATnR5iFi/O3Uw/Q6qNRp+TeaEWU8vc2VIm2QzP6F9HxiRK98NwVVro4lK7KNQd8gOYctVBLC8
 BvSQ4KLW
 us+DMCCSr33mutEOAvtwyjg1uzbhiKUCJJJ75+1iSBmA3WCOwwiM5KUfd7TpPOljsutYU1VylxDhDA4tI92O+k6eaPeFl/zj1SlKDxCD1YMz17qz6/sISn9IQJp5s2Z/Gfuj+CrA97JY6/sbVyM8oyFEaJKzD2+pj6h1EDp+z21oXnqFi6v87poAagwhdek2steXb8LVEbBxmdghGUe3k21vSgDQC+svTC/F6Xr8cvA2ZEMtztSi6XLGEezFIXg+P/904UWgDReXF18KS6moUED4u3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

> Qing Ming (1):
>   cgroup/rstat: validate cpu before css_rstat_cpu() access

Applied to cgroup/for-7.1-fixes.

In hindsight, we should have added a separate kfunc wrapper from the
start instead of tagging css_rstat_updated() with __bpf_kfunc directly,
which would have avoided the rename. Oh well, it is what it is.

Thanks.

--
tejun

