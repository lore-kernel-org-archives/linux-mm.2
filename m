Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10E1606A326
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dU6Qomvo
Received: by kanga.kvack.org (Postfix)
	id A9F386B05C2; Wed, 11 Nov 2026 19:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A765F6B05C3; Wed, 11 Nov 2026 19:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 965EF6B05C5; Wed, 11 Nov 2026 19:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4896B05C2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:31:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1308B8046B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:34 +0000 (UTC)
X-FDA: 85424588508.08.AA0C52A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 798DFC0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dU6Qomvo;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QsDcs9BukL2agpXizeKuZOTHpSFdpbs8oTRRuetMCI=;
	b=itH1M6y9xaNpLQbpojKwt4Rl6aoVq1ImlhOO5FSkCwWKiFK1ugqKrd0Nh4cAiFGnp4vP0c
	bgMDeYB5sHOLfM5xr63W8aSBfTDTFk01migDn+fQ0Ivr45/qzFJMTwJm/x0xkbXnxa/YZQ
	ckUO+4yrCrcDQREAl+dk8PGSGzbd7Hk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794443492;
	b=mTHRY/DMu4p5RntdFLsOTHzHhSmaX95kQpYIzn3gQCTe43HiXO0zbh8UvZTMhuzsh6RMUw
	Y8qjxgue5DN+bCNmcgT8/pQGYGgIdxvP9QWexhxWjRcybZlsRHFaTOsG6LUSLZ5AUDzhY+
	xCimNpT1ogYmKQxx+es+0T8tVmlhO98=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dU6Qomvo;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C20C440C4C;
	Thu, 12 Nov 2026 00:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF94E1F00A06;
	Thu, 12 Nov 2026 00:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443491;
	bh=9QsDcs9BukL2agpXizeKuZOTHpSFdpbs8oTRRuetMCI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dU6QomvoRuz71qdgtA3fqLSG2EJ9ncBowqwUeNlG4AuYl65gUTUTL0RCNX/lmKNYx
	 e4Ltxu4XICbO6T9AZdmlzAPY/jnUoY6PfwjPzEPQ7J1dNrc0MlCuas5dDjRIthP7WP
	 SsNfcpaJ61U+HNO9ZosDiOom6XrL2v7LxgKJ+z0jd3irr2AVwBAxjoDoDMsQDoLbFX
	 2Fc8F+43IMYlXFayO3QTAspotMUYzJDbw1X1Hzu++l9jHye5VJBl4gaDCeBRo++LMR
	 sqWLgOWKkM9nc/BgQi/rCTD/2VJR4bP9uH+wxpgx74rDUIG1Yu3mdJLKjcWSNfYSJj
	 S++NLWFF7lqYg==
Message-ID: <sashiko-outbox-209949@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 17/19] selftests/liveupdate: Test the targets of
 retrieved tmpfs files
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261111002358.1842967-18-dmatlack@google.com>
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-18-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:30 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9p5c8tm1ks9cymbricypw5ocbsku6dtt
X-Rspamd-Queue-Id: 798DFC0006
X-Rspam-User: 
X-HE-Tag: 1794443492-736288
X-HE-Meta: U2FsdGVkX1+5osGXSwsh2xeKtipXohoUThT1NzPj2hSX1Eg/tA8iyjc/s+xBv04H4w+6zmaQNl9+AP49ST+pI443AMSi8zK4mFDZt0OiX4xXbJiTbDIYJN6SZ10Lksfq6RcAc3DvLr4aI9Sj8EmANQb+DJsEKaJ8l+EvYBz2jxQ3kJ05DM9up0tjGcLGgt1zED2dKHtsbLDpLi3tzoKZAp7xzG6iwgAv2RwZwJEAYsB9t+v6DpUSRbo19yZrH/wmrw1m6qLO/Xa9H4mXUGryB6m6rzacsa5vXBbGwJ19GrS2m1uQwsolSc84vPNc7UDqJm6DHs5QDQgSvJebKzI1EFVvuLMS/XBJNHDIb3A+HsoDFrgDEUyIj/XH9QfhIJkO6kO7vpyEFZnYNrBQbWVR24Hp51HcxhF3Cb02oPlqte+7DUoPLbKrK9qmsKPWkIYHRHFPnsHax8HNr9ONFKQO3Zftyh396ldvxnXLSIfaMwVwNxKT3UfKX9RYwucdT/DZfZebBttSCA9F+WiaeW8/pb78DF/iVE0pEJf5Dks3J0SqofiH83JWTN2/EKRq+U1MpTLsq82hUouzzvbN+BfZc00udmOsmwyunoqCLMHaVPSi05w5WeIGpUqW6mrqIJsWkmRh6I+qj4odr0rru0rZKBrSNgjo3s5inSF1ONXcJOLTvr7LRcaIMxb4EY7lgBQLPpUt6VHBXrPyeuUM/fCMk34jdoHaQC4PeKgKeaYgKvv/VatIb0VzUh9yxofevNuw5Pch+KqWz7A59Vz2JRCsQwo3NnXWKC/DDE/7baf+aFlHabit4MolpKG2Ow+o9jzGaofyMo8s+9y1XjiioNRV7etUznH9QgctjqGqGurV63dldZ+TM7p/b1uKD6QWszN8KQVCf+PUKQdOPvC26idNrnPyuL6Da4OPCf8KnY9UFNKP+btNitaLG6/vFHtxadEuN4KQe/3xq5+tFZ8n0qC
 ns7yt/1Z
 V0FmqPvrC05fh5DxLxLXyeLeIT90NpR5v4Yjz7MxdeFnSEpnCsDNgAfbwYBxG45wLJiSO2tFrlS9HZNISjkXwZkt8H5Swdqel+1kzDXiItoVznfB4QTXNAvAswTPO7QG0/BkuKTfVDUWye3YhuStcyyEPPL3n70azV98Ys6IqH+dZEyquc7gbzJzEkuzM0XsFjxecehtcIirWDZ59GpytO1oU5BaBP7ubhovvMUeqS+50sJNcEnWWQ9vvYU7wigzEprooOURSWZ4MTE9YLKrPJY0v9q+xCqw1icTTGAkD1+IMcBJSBAlAUAV3rU1tC+xOTxq1MA7EJgT0745EFH+0+K4LoQbJiewu0DaEGha1jf3msb1kXWC/DUYXHIJW11iduzRzYjL74zR6OcY3PK1oD/fbLWdWQBzHN3D660lygAjRQ1mj8tBQ2xPvlyJpqA6RsQEHpA/gH/MJ+DFLEOxcDdhLqMsiGg9T3oS9DJ5edC4bCXPpZ6r1+arbkWTZkAiYa8EsasRoCrFi/ymojrcnRXAf4+K1XZuLangJrNML2fcVgeAPBbITcAkXCmCPil12zDYxABrSErXErCvGElHJS/011g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests/liveupdate: fd leak in start_exe() if second pipe2()
  fails
--

commit 98f191f06f9c7f70ee35d49607af5263f3c0db2b
Author: David Matlack <dmatlack@google.com>

selftests/liveupdate: Test the targets of retrieved tmpfs files

This commit adds test cases to luo_tmpfs verifying the requirements on the
target file into which a preserved tmpfs file is retrieved, including open
modes, file emptiness, filesystem type, immutability, unprivileged access,
and running binaries.

> diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testi=
ng/selftests/liveupdate/luo_tmpfs.c
> index 91a607752ee28..2d6dd8f0e138a 100644
> --- a/tools/testing/selftests/liveupdate/luo_tmpfs.c
> +++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c

[ ... ]

> +static int start_exe(const char *path, pid_t *pid)
> +{
> +	char *const argv[] =3D { (char *)path, EXEC_ARG, NULL };
> +	char *const envp[] =3D { NULL };
> +	unsigned char err =3D EIO;
> +	int in[2], out[2], status;
> +
> +	if (pipe2(in, O_CLOEXEC) || pipe2(out, O_CLOEXEC))
> +		return -errno;

[Severity: Low]
Does start_exe() leak in[0] and in[1] if pipe2(in, O_CLOEXEC) succeeds and
pipe2(out, O_CLOEXEC) fails?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111002358.1842=
967-1-dmatlack@google.com?part=3D17

