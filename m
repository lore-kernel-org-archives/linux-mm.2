Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E0E0CF2561
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 22:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C786B0088; Tue, 18 Nov 2025 17:07:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBFD6B0099; Tue, 18 Nov 2025 17:07:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB276B009D; Tue, 18 Nov 2025 17:07:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58C526B0088
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:07:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07EDB139F33
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:07:05 +0000 (UTC)
X-FDA: 84125114010.12.AB4DCF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5725180004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:07:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XZpIN2JH;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763503623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHskufQ4t3Ccveggkdt2pHiLdFMUb4h/36hkm3yxCkk=;
	b=1Re6C5cmg0O12V6ed+/IzyJ8Qq0J+fCwg75fWAXzU4cCTZM3akCk6ev8vsMVT3XC3UAjCF
	ArigJFNso/Yl5A6ZBRBbU4Tvx+gpCPesNKOk7DOU2b/H5buTlE9wDH4b1wIuq9aMTqsrir
	VROLqDRlhtf/kQ9ok3oOWuaf5apLJh0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XZpIN2JH;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763503623; a=rsa-sha256;
	cv=none;
	b=FdkP2/0Q5wuXfEp5xUte2TcmKJLwiAFN89E6c1au5HwiiKsZLOrtoIOeiimH4EP01DJg36
	3BbBRXjYDDPdyX53AEAPpFJHhSSRDTTTQxF3qNLvwSjoWtGeN6gqEJieQjet4SxV2IJhwb
	QXh0vuET7c4ye1qKd9KvowVHrBzbsFQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8990460120;
	Tue, 18 Nov 2025 22:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AEDC2BCAF;
	Tue, 18 Nov 2025 22:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763503622;
	bh=mPT12zDM8nDxmR3TVyLZH3WE/O8EZY7VNnGrswBABCs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XZpIN2JH/9ymk1OmPJE03A8BlBhL+2OnuRV5NKgYQ39BP7YJ9J4ZKOxQOhK27lEGD
	 KZtxNh717JE9vnRW3X/TMPWtyZAUhi7sVTW/qU1bthkT/JKQJqCHvCGVJPn9fYiULf
	 8b+0TqPBHz3i+0f0BmSjKhdsdQ2UcK8FdwZJdwUk=
Date: Tue, 18 Nov 2025 14:06:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-Id: <20251118140658.9078de6aab719b2308996387@linux-foundation.org>
In-Reply-To: <2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
	<20251106034155.21398-3-richard.weiyang@gmail.com>
	<20251117012239.lqm33uu4vl4y5zqc@master>
	<337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
	<20251118033339.7rukw7vvjvlbj5jb@master>
	<51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
	<20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
	<2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5725180004
X-Stat-Signature: h53q78cog76e9emuq96x3osgfmiqngwr
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763503623-587314
X-HE-Meta: U2FsdGVkX18NxJglp9waqarQiQ3waTlzM19/md3LJnePLHTwT55v7tDYmbJ7S58uYorrTOH/Gnj7Mi8I4APc9sRLT+jfucfHn3ytt5oyyK6bpUOEc9Ti4jO8kw5vvguCXao7dawNvx9bAv8WJXqig5yACRy8f7eEyKyV6WqvuINOXh8bzMEIqD939UeTPuq3vIRq2EmzxZmSbGZH/UEotyvAtarZuE8CD8ZV+eG5AazM0o/0/RTJowCzR2TI3f0UI4JmzOYOpu3sMBcMJ8s3Tt9+4kr7VVLngKxjcgyEkEGBO2IqONWIRAEqzDuJ6ZJI24DLVe9qvAOuWf/1goMu+ag8vfATrk7AEiLItIL3Qjkazojl5SEr0kiyNJI8bdjBTtYF42jP8vvE7tGmcE0p2XdF06bTNKgrIymmssasmgX0Zf5jv4//Ft8QN7IifVT6IgNq0E7r3taUEMi/Y/74T8MZ8EeRHuwPIob8G04A2+Td86tfUajDVhQze4bpJsHsUTFJgawA4qljG3zV4Y4wP5SZz4IZH2bND91DHnDLM6xDshq0mi8rzQqLepQL8mDdh2gFeqzWaaWGxAGSVlLHhEGRyMoPp8uiBs4B2OixggQTc7LUjJRcBUUbmGt0RWSYubJdP54uKw9+Ho24/xiY5WkSBE+/lfFYorlhEQt6AcH4FgDS22Env68M7BUrFWKGxMc3T0a2THEvffAzYPX52/gFozB8/QM0a+YxPX0hA01NkbWmtlp22iRbL5eyHzZWYwo87ggVkRc3rD2VjpysvHSdBVOKnhUriVzpQ3Sm61t2anjjF1EJ8NStPAZ5CYV4oEBXIPDLzulaWEZw+znAGwICb8NPL8eNCYxZw+Rtcc040cn3BSy5eyf1t600ejCSG7IvfOKPWG84vhsMn6DghyhM+Ka3LSBe08tG7D2QqC7ryZnEO+oaDV9mab6It4rNXEGu6Xja5ubbVfohCHh
 9GqcHYqf
 QAyiUdqA4O0OaZoVwYvBpHlzFGQszuE3Oj3FkXGEeSZ57zppVH4CFZRkGwJNMsQlcwNvl1xpgSwdKeh8v2HEKIpfSb1AoaqKmJM23jB3FXu1B6QFN1zdxxhXPFnjJdSkaPJQgXs+rFLbciKJ8GGxB6E3PTyvwnCkGWff4i7lxOVhrznKbgW0oqiT/rC50Q572f76OafIu1exnqki4Pp+ofJsDYnk3PR2j8K47ovPwdBSPKJdCSYJ5AXdJwzXaX93ZisYJ/GjJvhkFNzUuf/BAJl2jH7H1b36sOThqDfE1do8cKSZHbyJaoYtrzJw2zRR7/HXnvuM2JDOACKypg5k3a0vHxkPT/9snT3mGOAwLkvonC5r0oDna+4/kYgRTQtwMJocRNKFoyVZxEmpJhMvVab6HUwW9Jy9oREUf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 13:55:15 -0500 Zi Yan <ziy@nvidia.com> wrote:

> >>> And do we need cc stable?
> >>
> >> Yes, please.
> >
> > I added:
> >
> > Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> > Cc: <stable@vger.kernel.org>
> 
> Hi Andrew,
> 
> This patch does not fix the NULL dereferencing issue yet. Wei is going to
> 1. send a patch to fix the bug on top of mm-stable,
> 2. resend this patchset on top of the fix in 1.
> 
> This might be easier for back porting the fix. Maybe you can drop this series
> for now.
> 
> Wei, do you agree?

Dropping this series messes up later patches.  I could of course redo
things but would prefer a fixed up version of this patchset asap, please.

