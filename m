Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A89C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 18:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681E86B009C; Sat,  9 Aug 2025 14:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6320E6B009D; Sat,  9 Aug 2025 14:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5481F6B009E; Sat,  9 Aug 2025 14:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 459146B009C
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 14:32:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D2841601A4
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 18:32:26 +0000 (UTC)
X-FDA: 83758064292.03.F3ABD42
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5C240A000D
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 18:32:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFbFXvxg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754764344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUhNlqQ6VnKeXh2Xn+h8lfDf+kthAcMWidGMDbgJaF8=;
	b=U5SLdV1wLsrZ2S5w9fN0VCnK2cVaWiIa5JY8lkR7m3Rc61nSYriQuzkbqHjc+fOoeDFQ6z
	LBqYJBsU0DGI/GnSRtUQxGnG/Nut8hd1QU936H2jNL05L6aGEiwm+L3EbEMS4AWg9rQokt
	FLouc2O0gQGozlLgd6SwCS3hFglzrFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754764344; a=rsa-sha256;
	cv=none;
	b=o9LpXbZMVaBTpWzLMK7S5Z91ys4y5pv9hcgoGulLGNs+yVcEhOXt4KbsXHX6atL4hDdEJG
	c6HJqwWnjEuL97CvQ3NJLPw+B2kfGYlJmOIsDPlhYXUmePSatwpG7Kdggk79vj7Gn02H9m
	zPIgcFLaQSbCFg4eDxCV2p9CNJDMdLU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFbFXvxg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 8E75EA55BCF;
	Sat,  9 Aug 2025 18:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131AEC4CEE7;
	Sat,  9 Aug 2025 18:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754764343;
	bh=17cj85UdavT53nLzrHXasrniy7Ghl4dWzlwAnf7kfeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mFbFXvxgend+sAk55A+p+MqT4U8ca8v3hHJ97OFvQLrSJgmlQALZjnhzjfsQ1O4GE
	 o5sIHr483/YCoKeFiqMn/koKEog2V97LFzZNs9o8SpRoy7iNkwJHNbUWddlqEU6SVD
	 kploU/2KbwgkDpUH0IH9f7BbcYUVNZqVlRA4ZIgXW+sdaga7/QnlaL105oDPYVDGGq
	 w8j9kbLwkwwLr0H0kzzejWGIzpbvVN/KFnib5LPZjwdo6d3snArbJrG5EEq6GeJtn/
	 DBoFCLHStQ7pD1LCDoBfMK/Al/4wF1dk50oLG2BhApEXkKIeyfRqdWajeWWn3OnoIA
	 qSVy7PMU3WfcA==
Date: Sat, 9 Aug 2025 08:32:22 -1000
From: Tejun Heo <tj@kernel.org>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	David Ahern <dsahern@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <aJeUNqwzRuc8N08y@slm.duckdns.org>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
X-Rspamd-Queue-Id: 5C240A000D
X-Stat-Signature: rdpxghxkkcxnx3apbq4fgj4w8uxake4a
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754764344-581701
X-HE-Meta: U2FsdGVkX1+55VDa5B4f/QDENpUNKsbOu9WbuZsvuaGDKpNBRxHxPxEbdA1j690yGIy557DoO2vdx3IIYWsMnPtyo/9KpLico97fv5ihwBkNpywmhNdfZPFIKza94mnT+oFdNEG0Rd2nE0QI+oXDVHMXpsGTDIPT18GigVfvKGrfzf3Cn4QKmLieOCVj7DHk/aXEfIEPLiJ0yGiDcvPydXGJfdRR2QTezlZo2SotBILHh7MpRJnDV1J0cAGTyLrOY13ydVgVan7c7ceuWl0N0J25Yg3Kfa9svHrUI63bwy2gKqviBzoIdXxqIXVhOx4aNCTQPij1S0vcHnO3fRO3UXyVhcuI8Uomy0N2aA2/P5ncUGhocQlUAJ54tNUg93RTSI1F/oEHcjfMNiM79g+zEFkC3QvU0PfLIitoe2oADIxUvsNmocdpYns2QntxSbZfRxRFvF/gx1PHj5RCWjsUQI1xul4G3+GF0wzffWwaxdrZD5tx9LtsMDAq41Mw1y/hAOED0zqdQwhPOT3dScF4BhRWrOrpcYqnBGMbR6dRYSLtGHlBV+aNZSjYvt5WxX8kwEzi0kjxboYKulO15fnH4UyQdTBwsFZPlOl0tRBinNu/RZU3nPUxxFhF+y02e4cqfK9LEF1Zd+k0U+au0rzlK4ndeYVaS6bWaAcO0xstDfFAjcas/raR8P6NcMpdphiNzyC5GDj4Gq8Xz31NKjKyOGdBKBJ7Pr5MWAyKaKDEqCXp4gvhQuz8D3SrJtohSiRoKlq08VoJYuZsNMHqXIs7hH2wMbRH9eFG6OEsZ0DcQ1NGTQoOaqv3caWGZO34Y3ESD+VlNGmxheusKMeyavP0pT50QMdlGjuJ1jsHCMqFRDQpsmbKTNIgS5owlfWvA6Nj4f/mMWdOL0ea9z3kOI5w2cxXD5KQ1QeoNBN/X96z/hFaYGu8oN+ndj1FKiDb3hmkven4MXBl2LIihVx08hC
 x6rPlqn6
 7eZSiDtGPZiaWhthFeyI1XbgK8TBP5kzn0DUMIOrT8CC/KEYKfjKP05u61JZrMNQRFbvdI1y8G5J0I4DOBdcb1ZYe61V9aNV0qGpJAW8cz9B88mY+YPGAl/d/2NS2OuLPnWU0Pmwo15PcYwQyv8bboS0xqa1VNxPnnti2He4sup20ENgClMNzFBBUMHj1+S5VXz72h5xam8pqfCXgzdqwnf+SwSIqLWK1rQdqyDl3sbz7mIwBt7v1a8stoqa69CjJm+bxdMd6EQKF7Qw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Aug 05, 2025 at 08:44:29AM +0200, Daniel Sedlak wrote:
> This patch exposes a new file for each cgroup in sysfs which signals
> the cgroup socket memory pressure. The file is accessible in
> the following path.
> 
>   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> 
> The output value is a cumulative sum of microseconds spent
> under pressure for that particular cgroup.

I'm not sure the pressure name fits the best when the content is the
duration. Note that in the memory.pressure file, the main content is
time-averaged percentages which are the "pressure" numbers. Can this be an
entry in memory.stat which signifies that it's a duration? net_throttle_us
or something like that?

Also, as Shakeel already pointed out, this would need to be accumulated
hierarchically. The tricky thing is determining how the accumulation should
work. Hierarchical summing up is simple and we can use the usual rstat
propagation; however, that would deviate from how pressure durations are
propagated for .pressure metrics, where each cgroup tracks all / some
contention states in its descendants. For simplicity's sake and if the
number ends up in memory.stat, I think simple summing up should be fine as
long as it's so noted in the documentation. Note that this semantical
difference would be another reason to avoid the "pressure" name.

Thanks.

-- 
tejun

