Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 531EECD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 21:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0946B0098; Thu, 21 May 2026 17:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6ED46B0099; Thu, 21 May 2026 17:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87426B009B; Thu, 21 May 2026 17:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9983F6B0098
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:12:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 397DB40436
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:12:37 +0000 (UTC)
X-FDA: 84792675954.26.6A2D22D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F4181C0016
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:12:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d0RsQynw;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779397955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwEt4mIDZBAaZP8xdG8j5xHhMPLfzuZ5i194Vs+Abws=;
	b=VaozzNmilBmTWruqVCsXxdFx6k0W+i+SNVm7HWuGQPwWWQ7fsKsLeJJ4f4ZK2DDvF6bnvm
	Gv5Gkl6/Z+5xscXPW2DZ6RfTD4RxoHSogtrfxyrOqw8u7rVvVkPtjjZu1N1XpUbdcBDwrk
	oeexgD8lR6kkCC5C2EYwH+20zZ5S6J0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779397955; a=rsa-sha256;
	cv=none;
	b=VIN/qaJVTzcxed5dvS6365jS1dqXYzyFR22LtB+InIB+47O8goP7lXHd2bi7OPIQbxuZ5B
	DhnFMJJtGj/D6KWfBZAbRk/p9qzS1rSipLB+OuRStrYsaJ/pNfUeBmkF9q4liOVuyZzee7
	XhFS87U5nNmmKrPMc6KACIL5FbAVz08=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d0RsQynw;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBA8D60098;
	Thu, 21 May 2026 21:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77D81F000E9;
	Thu, 21 May 2026 21:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779397954;
	bh=QwEt4mIDZBAaZP8xdG8j5xHhMPLfzuZ5i194Vs+Abws=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d0RsQynw3/k79yoqJV7pG+aioLaMxrs7vXrCZ3WDlCiNXJ52DAvm13Ud7jzo8A+zI
	 tpkMUW+MUbjSsBZki8CL6Ukn06SCGGA0LEeE9JySxY53H2oSMimvg6hP7a9PMfVsxa
	 jvaLJr/81d6Dp2hM2MtNl76oSORWcdgHoQTLL5nM=
Date: Thu, 21 May 2026 14:12:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Leon Romanovsky
 <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Mark Brown
 <broonie@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/4] selftests/mm: separate GUP microbenchmarking
 from functional testing
Message-Id: <20260521141233.40045d34c91193e2e45e6f1e@linux-foundation.org>
In-Reply-To: <20260521111801.173019-1-sarthak.sharma@arm.com>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F4181C0016
X-Stat-Signature: yfjjrycs66dcewnrfk4744rbagd3zfti
X-Rspam-User: 
X-HE-Tag: 1779397955-321560
X-HE-Meta: U2FsdGVkX19wbHgampPZ4YfSVV49uq3lxtLakbZnwV+IZT2XqWSR/YQWmCkLDSve223hWFW7+MTaYT0eMh3+6wjJSxfoeX9JQda1SfdojCLklhHpbZ3lkXM6Eqwdy8ybSyNt5DLPCykDtLu9ewozkLjSVATHHSTRqzyyfDvk+86va1ttxxH5guRkkvwPGqg/mVLwVlUIaztGu1kwghQREo+59+XoloAIDFIFqbdBVp/BbPt8uZlbjfCSkZlN1Ev+A7DY/TXqd0OFObOvmLVPmzT1rf5vLEiAGi1HSx5CrRHOfRvwZvsSqz3S37Pig2xmPfCeAtqRQhOlSdoMyKn5dmw8wVnO+0MXbc9rZDaED4mK67XzPbWFnY6p0iZpmHRND8NRXDI+HcUv7iomKzd84+oyW9DO0Hl3KAE3mX3v045210cPI/TfpJJDr9es8CE7MhdL+eao4b2RmezKyL1ZPO5f2XKxRp0FPLr+TCwwBqCLp+bcGNoyvXnI4hmP4Gpis0hzBHG/R/fdXcvTmUYxRNvjZwrXLlBXvPJbThGiAFpDyOiZO+qaMnyDz9HV3fHMcngMMGY+8cG+v1ktjsiD/OCq962TKtbvQVxdpvXTkVOq+46frWne2Ng87hHj4OnMs+/1ao9vRxjMg/uROS5nAUoy9eZuTaAUDyq/EVV1He2liLoen/09ZUmp+eWFmT0nr2gEGeDwYH+gB2Sshwqbacn/p92U979PNszB4p2YfHmXnR+wzKTRE+rRO7Zti14Iz4puZyBseZ4Hq92vwuumPIEQZvBDPKpIRftUz6JoEQpdnLULtFy7fjFnOXkk9uEMeWVi2NRdFYtlV8s3lwHUlJIbjzwW8L7QNnkguJ3o9Io0FT9n31HgOtfkMNq4EHCmrFkRnwY1RioInKBhbqemKSlHEKUovFhpJe4fsQopyYOP+gwbyVsSs+8PaV4Zw9CvhrhLxSeFKyrb3QsAWkg
 h21ysKf8
 FWFdg5jxv8/HUAHw6Zc2IYxhXBSvZ2Ai7UB7QANPCsTQVbBZRnSkzQSmxWYDDLYWYosumaSfDZulOzqy/61EPkE09vWQuE7GUOp3C8woSFc+KBPoU1NLopPU7kLRVuBJtVP6RQrAgOw9YLXWLZdL01If6zdqv78BqjcELCZLVuH0AV6Oo0Q/K0iT8/odE1sxM8q2C1ZWPxDSNT8uEGEjH21gZvYyuwK7uMrSOp6jW9iH34jWuwuztSTCcSE8hVPEVHynJtXDnxLxyavUdSSxc5pxT4SP2OU1nJEBCkKoWgxGD4F15ZDy9c7P2P3lqxe+b0uUyS7UdbS88PovsBv2NMnLa+GmvO0WTlCQati+nQM/SMCnYOMbXvTtvLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 16:47:57 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> gup_test.c currently serves two distinct purposes: microbenchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
> functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
> DUMP_USER_PAGES_TEST). Mixing these in a single binary means functional
> tests cannot be run or reported individually and run_vmtests.sh must
> invoke the binary multiple times with different flag combinations to
> cover all configurations.
> 
> This patch series separates the two concerns: tools/mm/gup_bench for
> benchmarking and tools/testing/selftests/mm/gup_test for functional
> testing. To avoid duplicating HugeTLB and related file helpers, the
> series first moves the common helper code to tools/lib/mm/ so it can be
> shared by both selftests and tools/mm.
> 
> ...
>

Thanks.

> These patches apply on top of mm/mm-new.
> 
> Changes in v3:
> - Address v2 feedback from Sashiko

Sashiko has thoughts on v3:
	https://sashiko.dev/#/patchset/20260521111801.173019-1-sarthak.sharma@arm.com

Probably that's incorrect/ignored material which also appeared against
the v2 series.  But sometimes it finds new things so please scan the
output.

I'll hold off on this series for now, shall see what reviewers have to
say.


