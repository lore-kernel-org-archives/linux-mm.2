Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E450CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75EC78E000A; Fri,  7 Nov 2025 17:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7366C8E0006; Fri,  7 Nov 2025 17:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6745A8E000A; Fri,  7 Nov 2025 17:33:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 56F088E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:33:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA83E59CCB
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:33:16 +0000 (UTC)
X-FDA: 84085263192.25.3C41D7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 36619C000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:33:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YX2Wftip;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762554795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlY/pQ2DGyA9fVbJxQmYVoUk//J2XtsNsm2qG/TztrE=;
	b=Le001GxH6f8f9qDRkuPRcggvQ12TTqi2s6VitqnHgsH2jJDCnwmSOFao9l+dU0ljEdreNL
	lkv2VoWNuM5b+lBz1xiJZ6r14fmWySj9vCYqR84rsWCUydPhxlRtrRmzpdGnI0313QPHb5
	/8aqKqHRF0Tv4dhw8+AGjyPn8+U/l2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762554795; a=rsa-sha256;
	cv=none;
	b=3y8JqFl8Ls9GQCeovg8eLkgYHOLnoYN6OKkGIq5pTzArRMCUIAjQ8DOVL126m4co0mmsb5
	i6YinCT3DSV41jGgB2FtYvvuSZWi5hnGvXWB8k4ZLTKylrxA6OybR9yGQckby/JhyvAtAT
	KW5WCgBvDLXNAAIj8v635+RPQoTyEWg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YX2Wftip;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D34BD42DB5;
	Fri,  7 Nov 2025 22:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC1AC4CEF5;
	Fri,  7 Nov 2025 22:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762554793;
	bh=SlUrA7PHAByXuiTRoXiw9pd9DfkErd4nWd0LXTq5RY8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YX2WftipaPbxqcpTquNs45NU5AN1BWNQl9yUg/cF4YK9K3ROdJnvC/0MQyOO6g7/0
	 3Y1CpERaFP/A7LCKnMyDJNsXV2m/f3z9lz5emsapoZUDF63qv5irOs+sj4/qtv9GjQ
	 fRgHfAFTqDjTYq3YqmqDEID5JHJgx2b+Tx5S4yzg=
Date: Fri, 7 Nov 2025 14:33:10 -0800
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
 anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
 linux@weissschuh.net, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org,
 cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
 brauner@kernel.org, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, ajayachandra@nvidia.com,
 jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com,
 hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 00/22] Live Update Orchestrator
Message-Id: <20251107143310.8b03e72c8f9998ff4c02a0d0@linux-foundation.org>
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ayt6j3q5tj51k46s9mo1wbyhunfshw4y
X-Rspam-User: 
X-Rspamd-Queue-Id: 36619C000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762554795-356788
X-HE-Meta: U2FsdGVkX19gfkEQEjCWIE8K0HlsZ5BBEXhMHovcskJHzsN2t/z/POgeBT/7OYsrbmHuqI0T9fWjLjVdgCUW4jIn+QqmiYWJSmFQhh7Ya7WPeh+gDh9f7I9VxxlUY29tMSjWpukBJozmVpS9m4rFfyAPmWquJmLMk/eDVafHa966Rq+XDyb86Xbs76/KQUVz5RgRJ84ijRrekc/yeVyd23+jynJCM8q8aBSh1j71QomB93rog4l4s7/Nts7vpkJvXbKvkl3BYcgLjqFbeFwkS4hPodJt0sBXEVrvZO4Zr1NXDMkFaJ4h6Uj5u8Y4FAs6L4v2lUYYH+iVU2xORqRLZVvIm38DXSe1MVy7iNbBQS+HgiHRGvt7udV9/gWId4hxUSlUZhI2wAj+Hhxokn8nVXIeqpqGI/0vHF2LvbwdVVm5WyqZDA0uPhEBLIkCXi68CuR8ugKfD9DQlKkRFVS3Go6k2fecZQLs+VU1Q0c7/TW4eWcEMLrYgCT5QtE3IcElyKgw67Fl92CXR74dkxfAzhu64ehRFqF8M6YseD+O4iyNIvd1i0++ZC1usMrM7CLWE3sLbvICd6Y6BEoBgbfCXJGLyfCykVjgsGRi1nvr4FN581DkZxa03wvQ8pB90CLLNYjrPtRdGZru3on7RVe0IjJXbMzLMCEE349wqEw5pxs0BM6tpx+Nz5Fwy6Th6OO40VgikXIZ8sOAu48Kdqd97ipkzZtTh2uQbFwYRE5ym5okLkT3Miiy8of2jdxcTECkEXwZf92ljCVPKmndACSpAdYB2Q572whQlaSPK8A1JiQtmicWwkw0q5VVsc9o2lpCxF3f/YHWda08RYeakODEWWNTwkEvwwMqaIz8eOe2N87WCeoKPaP16jfbJy6fRW+beMcjMLXhHLo2pTf2dMcsnzTucotV02sEKGBa3aNCopP+s9HrLuN7bA8xWa3pHgYyRbfspasjEX8p/YyZyVN
 cu4/uE/4
 8JnAuQR23rT4voYYAGuW4uqdsUdBCjcScPWIzrAveUJtYQB/Xtbw6q8+i81ZCwT/kxJVGHQbdc0Et3rAzzBR5ykyGIz+GERMdhX6B5sPMOnmW6eGIY5TNhJtupfGkStxGkDRi0hr0mtitoUHA3kKePt8c+imbLPALwUB94U4p4b+RFlD00SuG3jzYR8BkMn+Y611wjyqi0/fCnogrY1ZnZcElGd6A1tyTuo5yfQ3G9pTDgPHaDiI/5I7nsDGYSlK8hf+9aQ0gPJKmMkpfd2pykZoMwcP4l41woB3DlVkrC0NQoPdiCEOiYBa5t0/iADGOjtCkCUOcfXwPMsKSq11qOo/h/QFyqgBmU8kST4nV65aXqiv1kgX66r9LJLstCseZU5La
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Nov 2025 16:02:58 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> This series introduces the Live Update Orchestrator, a kernel subsystem
> designed to facilitate live kernel updates using a kexec-based reboot.

I added this to mm.git's mm-nonmm-stable branch for some linux-next
exposure.  The usual Cc's were suppressed because there would have been
so many of them.

