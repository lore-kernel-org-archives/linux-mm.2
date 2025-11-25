Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD1F9D0EE14
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281F46B0006; Tue, 25 Nov 2025 13:51:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2322B6B000A; Tue, 25 Nov 2025 13:51:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1221B6B0099; Tue, 25 Nov 2025 13:51:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F27146B0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:51:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 973F2C03BD
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:51:52 +0000 (UTC)
X-FDA: 84150023664.24.5C56B5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 111C416000E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:51:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uWZDwEuk;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loZnNXQjgHsDM1cbYMNPqzT4eKyw5Lbs/TaDHM5/L7k=;
	b=ejVin3P1W96TKsOsXsvUsovwsqWu3te7nY4TUY6ew09tMSoD3376C4yg1JB1F5QttvJaN0
	KoInlh7u4Gu4p9ty+UyN3kre/RJKf4NHnHxJiM1plb5mpNW5pQ8qRDN2WJtW9ZcuAGjrMn
	Gfgm2/ByQQwQRDjBnCZxovpM1TspUq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096711; a=rsa-sha256;
	cv=none;
	b=dYWOjWauYpVUbvoMQ1J1MBEWtocdM8BnxRT1n2rtvuFMDzvPyErI1V9Va5vmDoBjmkt+8r
	M4u962ZZaC41JN68XjOgNdVLXz3Qdl+YHX/GnuoGZFXI7JyeWPi+AQbXI1yAzg10EQjgD3
	eoavF5WVQ6Tp5+wsGXyWOc+kkEnmi7A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uWZDwEuk;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60EC460131;
	Tue, 25 Nov 2025 18:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11841C4CEF1;
	Tue, 25 Nov 2025 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764096710;
	bh=emoR9CFUIW/AsJT0wVfK21WulXTNtgDxAUtPTxqwPMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uWZDwEuk2g/afzjQbkRlvylw6VEBejP7+MHtzpvgi1f9gQTmWcqukCgLI52/SxzFA
	 h9uKGWU/GOJeCm/wHg/ouAaLGcMbZn9DyeBJfgqyl1Vl6bYIyA5V3M3fs8o476eiZX
	 uHAbrDuhIDGUPh0Sc0NVNPVlYw+BIxtAX8V39yO0Gx6DWfMmLZUjrU2lQyvWhW/0Ix
	 d/U4nQS43RWpQA+6XUnKS6nuGX3v3Rf1mfMGDiX1h9Ksyktmju1PcYuxrRWHMdug9P
	 HeANy6ZuRfDNUPQF2M0bHPEEtuESSuhbkbkKyv8vMNMaOT9fPGfoTWN7JyaFkCjD4T
	 AfEYrzGeLwi0g==
Date: Tue, 25 Nov 2025 20:51:29 +0200
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
Subject: Re: [PATCH v8 01/18] liveupdate: luo_core: Live Update Orchestrato,
Message-ID: <aSX6sQqwwA6I2mxW@kernel.org>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
 <20251125165850.3389713-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125165850.3389713-2-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Stat-Signature: tgufxxoe1def3nuwax3aqreoj6m8kke9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 111C416000E
X-HE-Tag: 1764096710-825538
X-HE-Meta: U2FsdGVkX1+2ex7LZe/A08aHXY/ySNvgXN/5RFyYg0ugcQCdB7ILpsbur5PnH5xvzV0UDY6J+ra1Z3uQ4HZCbgPbSkkeApSWHPlfivliIY6ZimjQxOiM/X9PPjsuvhaBK7SjnZqItqZhprWGyoUagJElO/70sC7SAJFoKXn5aBof4V7Te11B2A4pNpXwnIwzm+Bnd55JzGWAv9LqEmpHO8wuIVwipBJg/PDnSRJcwHmSIOa/b8Zwhd9pwL/pmLPL6hH0QUr94dth92DNEIxgw9qClxK6vPj/kovHqs9CghPFPOwJmiwQxtzjnV7doCBMWz1G7yjT39XCBpZK06UJUNt3vcBndFS5iGgLSU1gnNtz0DtvdPkLRjYqIIFDuebUc88pYG7CQQ1pvIUacPKxRRCTrVWCjCe3CqHKdd2zuPF8p5FBnD59SNjnYRWcoCRWrbpPiQwbvwtP7VWJ5vdonwcRGlxOQsP8zzP4Sin+DAGm2kbayWPOvwLvXd5Lwa/WHqiNAbSOEm9WmRmiB7J3Zl8ApOLXqwKQ0ISEKbk7AKK/1tI8AbA+lfpzZY5+TDX+NWt+/we/itRleB9F0uFY9yG93uDv3EKXRXawx1rAcfYzoHckYabYAFLQoCY7GupXS5cQA92l/Z1wXQBlN7PQ7xJvBWmBcy5PlafTDc7EN5rFoNorBWi3ePu5MBA3ctYdvQA5DkOQpeq8Uan4ZZfie95nwd5NYAj+42McVd7yw8NcYE69jhQpv+mf4DZfWZvuJ49wjtPyjSD47v5N1/q+jreF8c95t86PEljx+QqXCAnhKCrdKtB7h5oSzbkxojFs5AYrcy1RqB+Mi1orqswh6bj2ydEdWcjvTpewUc1qNgG5RjRLzmCQrqe+HjmKM3sQtiu1Sa4snIvXo3e0ZXVJg6icmiBoGwaJgojc7qkxbH1yt3Y2/yiSsWwTizobMQVqdbasUqPJvKo+VmhGWbC
 i12jeNou
 ozrg1fj7mN8253EXm/VmgQG7Y2NIHD8Qgc0NkmXkHaiXdbiwWK5xHz85U7FnKxy9PJP6ceCKSE8dig8lSwAApyNDM1K7tpcX48q+uoENuYsvpSQVmBp5pLvUwA3x+vbZ+9RgJdwx/a7kRXJVeRSmVsTgsOw2BapgfNktiGHOchZrUhRWtTlWcA9/IV78xRkfTP3UfYDmSjKxaZYtCXs+CxGXe4QCOQpWyhB71qaLNcvMIYw2xmcdDvz5K79LHD2nM5kAkbzTQYkkLWjcUW9PKthhelNVA9UidH0V0cJ6xACQ61JDq6jd/EEgq6PBpnublyApRkDhWrTDUv+lIVKCgRHtmW4Qgjsst5lrC6CrJqur8jYC1zQsime/Eqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 11:58:31AM -0500, Pasha Tatashin wrote:
> Subject: [PATCH v8 01/18] liveupdate: luo_core: Live Update Orchestrato,

                                                              ^ Orchestrator

> Introduce LUO, a mechanism intended to facilitate kernel updates while
> keeping designated devices operational across the transition (e.g., via
> kexec). The primary use case is updating hypervisors with minimal
> disruption to running virtual machines. For userspace side of hypervisor
> update we have copyless migration. LUO is for updating the kernel.

-- 
Sincerely yours,
Mike.

