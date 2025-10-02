Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9CB9CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A4F8E000A; Thu,  2 Oct 2025 07:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB858E0002; Thu,  2 Oct 2025 07:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C018E000A; Thu,  2 Oct 2025 07:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCC338E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:40:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CC9D59139
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:40:02 +0000 (UTC)
X-FDA: 83952980244.04.7B31DB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B4E6340007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:40:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TW1/86Ro";
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759405200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqM4M+MGYM63wBzkJdjM+deX6L3r76MLEIOrwOOOwJs=;
	b=rxw12z6P+DEKq6TqRzs3mrKcugYgAaDtGUF8fZUTCx5+qRHnClSldrc87eW4VXWHMuH055
	lgoUdleYchnbU0l3Fb2yjjJ/pSvwthr3DHIjLI3Ia3+IKEdINc5f+JDCcFG+2Cs9CScPNU
	9/6GfQLqSugPJqZnxdN0iyhPRZa5ZRw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TW1/86Ro";
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759405200; a=rsa-sha256;
	cv=none;
	b=TX85S7yQmUkbLcTeGte8mrEqu8qg545HwXzvoRZ6u0tm+YHq1dFyNEXfI93kYrDJnZBakX
	/74FJllSMQy7mZhW77HJ3RqjySI+/GCgtrZBPeIcmXwNCSavb7s9f5tSDEiLzTpG02aEjF
	3Jes5fx+Zqj3atQuShnBaQ3668SO05s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57A0F45A0A;
	Thu,  2 Oct 2025 11:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB65CC4CEF4;
	Thu,  2 Oct 2025 11:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759405199;
	bh=AqM4M+MGYM63wBzkJdjM+deX6L3r76MLEIOrwOOOwJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TW1/86RoVUn8qaQrgHMvsQvcXg86d9INUtwu3WmMM1sNr7Nnhsdu5LGDe4wj5Nmcd
	 h3ahbC+1P18XctdTn5Su30qTYLkv7UarZVkeP70mkiGhbyiaB4Tf6m6FHeWhLlYVJv
	 LhShOrKMSXkpVSMXLKYov1x2dryfuR3xlR/mL6dZWVfYhX3Zictu/5mKj4LvKtKxkm
	 Ma7bsVvTVvu3F16nnUTBVa3mDEJ/xjXtgVjwBY+8URYSBCdEXXcChHc80acWuzep8i
	 mXGvMQLTMLWWC7+zGhRkCVamXaRa0GZJHQuGz3SNFpxw4WC4iKaqKbkQ2SmMMevhe3
	 M2PF47W5eCD9A==
Date: Thu, 2 Oct 2025 12:39:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
	amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
	minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
	sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	kevin.brodsky@arm.com, dwmw@amazon.co.uk, shakeel.butt@linux.dev,
	ast@kernel.org, ziy@nvidia.com, yuzhao@google.com,
	baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
	joel.granados@kernel.org, richard.weiyang@gmail.com,
	geert+renesas@glider.be, tim.c.chen@linux.intel.com,
	linux@treblig.org, alexander.shishkin@linux.intel.com,
	lillian@star-ark.net, chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 09/47] arm64, dept: add support
 CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64
Message-ID: <a7f41101-d80a-4cee-ada5-9c591321b1d7@sirena.org.uk>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-10-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KmVT2ZbmJlsEn2vS"
Content-Disposition: inline
In-Reply-To: <20251002081247.51255-10-byungchul@sk.com>
X-Cookie: idleness, n.:
X-Rspamd-Queue-Id: B4E6340007
X-Rspamd-Server: rspam05
X-Stat-Signature: re9aw18ux48jbw9ncwnqy8utqa3rdk6j
X-Rspam-User: 
X-HE-Tag: 1759405200-267075
X-HE-Meta: U2FsdGVkX19kYftr5wbeBgQ4adccmKceI5GIWtkCOlg6+VZE2odz6bqPdHAavr4AeiQsbmYEkNBJPakPBm2ySkVMdoE4k0u4dKdBYjbnAbfZUzqjVrVWecH+AC1AocZbu8SdJlCegsDliU0m5Z9pYuQiKmS/+z3FuQSXpGweh9+3XykLk9/LoPRr216HrJF+E8GZAane0YxNtE9mzrzTVq7yQWMjVGYxGtm0hIS/PyYYIIjNi8FdE6GNmzuklXxK2z2pT/fb28G9jOk0Lx3Eq9MekZCQWC5ynJjj9NovQFUsEW7ep98hiR/XwHPtYT+FgsaUmekMoZhbQBO9dTPWll/B8Gg/y3KXPoEN0RYIcy8+MzBGbPUU6YEcQDWyX+gslfITlFsU9SbUXSxkLOcgzZYF0VXjUutVuQ3DTUsZpy9A94kW1eQYcEoX71ota9xcNaEkMG5Y99iwO0VjocyPD/1Fc+mWVwgGptk1qDVTOXlOpcy52OytcTqeiYVpovwSHeF4NTbcCU+lVdL/eLV2rDQI0+UMM1uj3xw3GX+9yCsa+sr0Rxpk0gXV8wa8G0rOb1u5DAKg1c5PDKdTJAWoSSbSee9ffGhF0LBf5xFwHvrsLwlJqt9TzX7a9t5vmEwbpqhRUDUJMUo5Ou7XQP/oxIMtidO5efJeNip6+vfZpUbZbJR8ymzTylKb3akibfAYAM52NLwrCBzmVW1Y1E/DuXrL6JjMMxcJYZtl4IpPvh17OlzlQ6G320LSV2q/9GuJRR64jOJ7nCM5XmJt4oDJ8piknLbmy5j+ESNgj16wYEJpd+c+bPS3NJxcJrwnJGWF2enNPcF75aXd6CuLtBAzkxdW2h+Y7VPjAID80kgGMwhhGfTxL9r7XtVs0RQCe1Yt1jj3UoI0jzbg/7xSaWfaZ3izGPFILFr7mTT/kB/l6YSE+K2zuIQhZLsFLokpS8twLiLyX+dbJqGRZCdna+V
 RelTmtY7
 joAMWGXy6DRlLhzz9TVkBGIAkH4duRoRV19OgKlm4alBn7Buwz/qND3jZBdJdk9f4zMK7DuYhltZXo9mBuBCPdAFPTJ3sBgGA1/2bGtwI5Cq1NzxT12U0cytey+C9tEqA7Z9TSxfgLUxN3UPm3Ec+JMWZduUw8pOQJzIMl9WrJ98PE/L4RU6hAaQljMmk2hd9KLW2z3DRQ8HeLaodHhDZNm6jtvyX5bd7OrTx2YeQFLShVqT+A+imtM1PwG6Sh0gDrtYDhQGHIhH1jX9BJuzL0EmN/wPHGAfbASiKnNL37F+tCNA0mhXfJuEPsc70GGa80ygg1pPC0xcLyMPRJj2ConMfL8nN2AuZMkCa9P4xNLseYEQn2WvfbfeUb6PdSgxgE9kVAKjbe8pDunhjMdN07/ZJGadI+VCJGe8gyAcIY6/rVcH/8iTu0z0hW3RzgmtdZBtQHVB6jTIC7NwK18W+OBJX57lIfTFUikpFds6JFnHUCfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--KmVT2ZbmJlsEn2vS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2025 at 05:12:09PM +0900, Byungchul Park wrote:
> dept needs to notice every entrance from user to kernel mode to treat
> every kernel context independently when tracking wait-event dependencies.
> Roughly, system call and user oriented fault are the cases.
>=20
> Make dept aware of the entrances of arm64 and add support
> CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64.

The description of what needs to be tracked probably needs some
tightening up here, it's not clear to me for example why exceptions for
mops or the vector extensions aren't included here, or what the
distinction is with error faults like BTI or GCS not being tracked?

--KmVT2ZbmJlsEn2vS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjeZHIACgkQJNaLcl1U
h9C/NQf6AxgZ6UzPOMzfmL9NSrLltWX75xfq7wx8SUKs1A6RFEWCR/s8jeaJZeCx
834KNHe3AuR4JVKLLGCZS/c26uVb8ee5itMM53Hv9CN8sQFUNuw/xdO1WCQVmZOI
pHaKeDBxXVnmeBO3uxS+3ITFDSNIPz6DOUAhqdFLhC6EhioGurq1dr8EtQu0aL3A
CqG9/M48cKPZRG7a1vLkqKbg8o15SYytfgXtl1kBey51IR89HXUZA4xdNc1CP0Sf
t2jQUg9ne/qxFnWt0CZEL+07IEC/enVs8gcO+mSpVX1r8yRDs496wZ29z7TjDaXB
8wuHMVCoKqwssyLsusjOjgef5XgKoQ==
=Ipx4
-----END PGP SIGNATURE-----

--KmVT2ZbmJlsEn2vS--

