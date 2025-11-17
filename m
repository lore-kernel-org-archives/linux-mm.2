Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5B1CD4F3E
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 02:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D7E8E003B; Sun, 16 Nov 2025 21:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DA58E0002; Sun, 16 Nov 2025 21:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5778E003B; Sun, 16 Nov 2025 21:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 674788E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 21:54:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1598FBD536
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:54:12 +0000 (UTC)
X-FDA: 84118579944.10.05CFA78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 53F634000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:54:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bQLyaVBd;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763348050; a=rsa-sha256;
	cv=none;
	b=msqfWmkfcTaP7EIXcjR2Krq+4+VQOXPewsaKJFUVjAi3ZE1ACseoKn9ePckJ2ZEaI808e0
	iWW7LyqVhQygxAzjOO7yl34G4kPFUrW+p5NAOOncCvgMJ8IXvKvNXzLykV1I7BySIrGt2w
	ifkWpdpZ3Y0dAlpV1bDvu76mTTfd1bA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bQLyaVBd;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763348050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4L1uaIyYsdghZvIwpIv4GRabqfCF62SfE+4yz5AG+U=;
	b=e+aT+olhAxbIrA+j4gA50rOYZyEu4YhEZq2/9xbKJBlC3gBuajIiafuGfnM6caROdBhtSt
	/iHiCD8LYgFbkishBdVYIoUWqcRTeB0SVFJD7InTGp7bJdXmw6lUyCKvGXUUPOFsvdR9g1
	4bdkxKdsl4lpOgMWY51ifzkm/mEz8pY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16FFD444CC;
	Mon, 17 Nov 2025 02:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54D8C116D0;
	Mon, 17 Nov 2025 02:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763348048;
	bh=gT/Jws3TUOkv78ezuhBECn5hn2F6V7xxYmqRwPANJYE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bQLyaVBdbyyM0oXtWKIvXOqoUHpgxlgK76A/wKmfxsmbwJ8Q8MJDoTghEtIMGocF8
	 Evr+ry6/+JjQBdutYhbOJrfavqGhrLBedJ7368KUCce+O982gvu3WJH3U9itu8l0qj
	 ayUgSBpevbPlBYCVx+7S9qMk6srbxSOGxd+WdmWA=
Date: Sun, 16 Nov 2025 18:54:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
 rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
 rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
 kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
 masahiroy@kernel.org, tj@kernel.org, yoann.congal@smile.fr,
 mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
 axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
 vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com,
 david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org,
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
 linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, ajayachandra@nvidia.com,
 jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com,
 hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 01/20] liveupdate: luo_core: luo_ioctl: Live Update
 Orchestrator
Message-Id: <20251116185406.0fb85a3c52c16c91af1a0c80@linux-foundation.org>
In-Reply-To: <20251115233409.768044-2-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
	<20251115233409.768044-2-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53F634000D
X-Stat-Signature: y4785xhn6cjdzh6qg8by4wmain7r1hk1
X-Rspam-User: 
X-HE-Tag: 1763348050-682287
X-HE-Meta: U2FsdGVkX18KjQMFXMJ7oRbfBMhKDDd4wi4yCl9OqFnTP4XNt8CoMEXsVcsyI/g6FptC/a9BtJr5jGJrVXQIY3zv9GQhbXeemcScrY8sDZC7UBaG97ZW8KMaHv0hW1FLsKdHaRtEhVZaaPMt7c9mwGDlKv4RIbHrACH+JImYGnpqPN/CxAB41Dp4SMcnBacWfQ9a0KsC+sh9u83kM8cRW6mdC/lMSgjCuuHsr0RDfOfCN8BNWUDLeelpRc7GzcELeeBI2I9cULUdDEz3cYQgwUtkFvIE3UaaJN0W95crrF4GhDzvbDUHWMBIzusu77SzlC8x3/aXfl8QVviHpkB5j/OrHQVicQ1ozk66hKKazZ2uWuHZ2BGLuuIzgAu7w/VvScmJO8r7BCvGn051uBc00JzkZcuyJioMVaaLAJwOxvxWgQeXqwbcDMWuPlaltVghH6p4Y7h1C5OUZY/5Nux4FI2BoZLrGbR9U1kiQOV7dZYnqg9kiwKAJmE+GkcHox23+SWijIH97jVtwCIb63aZTZyMbZnFzAI0UjWp94l+EtDCbxB3r8fwfr/EV+mtElo+JhfS/8EZR8MymBj2c8VvrUispWaWHPHytpdKBkBxVoDQ6TKC1EJzvcdFKGLKU+ygBsrq77ACcX7CYXUbpLhPgoGcJv3IN0o8FeKONUxQO1sdpFSuqXu+mFuVjldkTAEGRvuS3A1rZGhT2SiDyOMkZUD0cqYMSLLXJcWoenteFOOxqIM+DrW9xPgkghlR7j0ZrYp88HXlbbiuY/29+XGkwEm6jY4L+zt1uAqrc0WcnB4ZgTI5Fa7XTNwMfz+r9T5I/S9ZUcTdi0y8vkpLzV4WKZiPBurYABfaPtRBdii3nBFQrv8FbfYbpmQT9mbERnkk/w6vk+6LFYITHkLgg4SoBEnEl59rhwH/IPXZbdb25oYhDDt+sQCKPyLB9vFAcZ+2aRRT42iFtNzlhpLuQ0C
 stQgMAxj
 9k+TMiugGjQg9IA5z8rT63b+RjS4orVCdgbOBeUeuDjOvRtf89BoyIxhQb84EA88eRjGc/RgSX+l8NutZWRa6kRBEH/HUBRC5Psahtx7/40lWqCPP9YNTMQiQGVTmgYgm0rqIlsY4aadAiVdCWlhhZaCOkGbih89aOdmOQm1YnICEMyh1WDPnUIfYxD+N2qqDfvnnTJJJXvkRxPZ/AuxAr2Ty0Hn55ty7ulnzF4td8vuvd+7JPOPmPBHk31LdbzvK/l//3MrWkf0XKKLBhOzRqbnO9FCRS/BDDs1JVjIxz9t9OGchAhwU4fd2SJCBBnnkjne6geACOKwltWPrHr7FwHa00orlOYZxwbppOJqUIwaztTeP6oQcwpdWupqCqmSog/dtkwmWDg9jbu35K3rrDGzpIXU1bz/KH/E/hbcsGxXzMPKh2lNkFMOxayn0LcthJM2WAVnODElSY7ZZEzLCkg0GTccCAlDJufSV4dCGI2l0X1qZi41+PURtUmtzVyKsziQM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 15 Nov 2025 18:33:47 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> Introduce LUO, a mechanism intended to facilitate kernel updates while
> keeping designated devices operational across the transition (e.g., via
> kexec). 

Thanks, I updated mm.git's mm-unstable branch to this version.  I
expect at least one more version as a result of feedback for this v6.

I wasn't able to reproduce Stephen's build error
(https://lkml.kernel.org/r/20251117093614.1490d048@canb.auug.org.au)
with this series.


