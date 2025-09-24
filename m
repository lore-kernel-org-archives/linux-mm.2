Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B71CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 22:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32018E000A; Wed, 24 Sep 2025 18:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09A88E0006; Wed, 24 Sep 2025 18:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947738E000A; Wed, 24 Sep 2025 18:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83EEE8E0006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:04:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45FC657266
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:04:00 +0000 (UTC)
X-FDA: 83925522240.18.B173531
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 83774140011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:03:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wWHHWRR6;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758751438; a=rsa-sha256;
	cv=none;
	b=IUNs6ecr1GlMbWJDoJmvaGxRdhLx3TKWKvZLZRyUKDQoXXmeJdooSfI8l5chrCeajsSelI
	sQtsMCllgSBm6Zq+QHBvj1QCo7tE+TDXomTx3Nt6kwUG3wI9XVNuipVSUvt8d4KboJDe7H
	Ro0TPyyU8f7J0SQHreK0sgdqq5x0pSI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wWHHWRR6;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758751438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaZsU2SD/2rhDhtj+/3AtiB69JHRYoUblH2g3jIqjaI=;
	b=b5OoAsKjeBfp2IcOC4k0RaEbg18x53W5STI70sUBn0Eta+Cn4D34Afxr5yLAdcAddzBxso
	rlXwrJueiAyW1PeS1CCfV1nc0s5LvSWRAlXXdlkDw9HQJyne3YsWFA9Q9gwvZJZn0YYMfk
	K7E+qLc+9NaGXWctV9PQb3et+oOkhlk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3815B405D0;
	Wed, 24 Sep 2025 22:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3629C4CEE7;
	Wed, 24 Sep 2025 22:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758751437;
	bh=Po68jlJ5jxf9gdoRfMqExCkfPpVz32k0UdZwV4jaUsE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wWHHWRR6BAv7T+ScMUh6xz537wVjq0obA0sORIYPMOSxmM51ixlGWdY4fGrIR4MPK
	 U3yX+TwYb1psFV0glBvNOy4vNdPiDARzFX+FUPTpW2b0G6oueyBSNMPeI+Lv9cner6
	 ebTBi4Z/uyPniXBpUfYr+LMhSwk7cv7m4TnSlAuY=
Date: Wed, 24 Sep 2025 15:03:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: craftfever@tutamail.com
Cc: bugzilla-daemon@kernel.org, linux-mm@kvack.org, David Hildenbrand
 <david@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
 <chengming.zhou@linux.dev>
Subject: Re: [Bug 220599] New: KSM performance degradation after Linux 6.16
 update
Message-Id: <20250924150356.3d615a8a4481b817f2794848@linux-foundation.org>
In-Reply-To: <bug-220599-27@https.bugzilla.kernel.org/>
References: <bug-220599-27@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 83774140011
X-Stat-Signature: ooamsdeb64og3j6tgoapad17yg6437oi
X-Rspam-User: 
X-HE-Tag: 1758751438-361068
X-HE-Meta: U2FsdGVkX1+HCj2ragDCT25vqE1Ux68QK15ddikiY7Givs1IL9LhCg+TiXMyE/Gs/SJgzgmedqZt1xPMhkSWpg8DWmQBMxNPbHEzrx45VJgVqSmRqeXUyppjpq0HxQTAAbZojkhXprLC+tCqnj7krkI5GfZME5cK9eqzygnK9D5Kx+XrKY3LazZ5rB0eqJf1qd6hHdtLniCAifNm+1zg/xcW1Xq8lKg1pxdU+bG9mTFBpt3LSSwktTtE7PU5YhTgPYqCcNMR2mE6UxvgdXSXgLYtqgUHu9yU/mHW+huKxjwV0hQIKmB9s5eyeboHW1CYrQaSDKcO0Lr2CPGIntwTPjI3InBFpu0haBv3SE9Ok1S4QYJX5VpaJ8lO/n6hl8PkV8faEy8zhAo+loBZ+f+dRSUSqDyKnUS4u0tM8ukNnUbLWH2BNFZm86QdomXOWqugcg2lQui+UHDwfvNIO98IF/0OnvolRL49zafVekenT7iGS/swcQV4rhbJmuz0KqcsxQboOvCLjtrnaUoWR7K7gaKFcJkR6ctkcrHbrI2IhvexhNoKLcQiQBh/qMWJ4KT5x6nIyZeD3ejkrZtxEetsMj7O0k8rIkpuPlTZx31948OeAUjTM32TnHes/+kZAFvMFkN4LyNJEqgXue+yb52l8u7GY4qUOPKeaGw25nWXaRXpnZccoFSX+q9WZgtpYH7dRDsT6n9uvg0/PCCliB2OBPzEyLfk3xWv4e89oef3BU0ALa3+iIrDe/x+5qLk5Zc1xuAv17tySp7K+kbPfK+KPMiDfqP6eg5NhxOGVGFpKabQSVX5rrnjUc/AgAO5n30lpQFSREHxOyUvW5KWq/MsMZOD2hA4SY39LYWsJhSQ32Zkk9KIvkYT/CuL9UEPLdxx4H2O+m7aFn0+9UpVCgTlPXhzTlcgkw/b5v658OMZfmaz9WlFrHdUsAyOtHaVagAf0N8whWkyxKflDWTA+cv
 pc/UyL49
 NXlZZNeOQUOLO0szeFjQ0Ny2VwbfUx2vEdGabXb5iPmLY0/paoUbpfskNJ5reBayFiTTfk0msWINFFmQwPLghjGVdIs1rgs4yoKjhgOEaxSlp7PyiC55t4JfJyOsVnpMkKt/5SaMF0aP/zjPErWVw7OkMsuPPcrPGduf+VITPQFdKZCNRS+4yFt/e36RimI3xtRXiAhpOqTBMCcFPs6YYvvng72dXlb/q4zdwfqFi/t0kbTIt2w/TJSZDAVS7yXla4QPlbzsts0Mi6Yq2aDPntaa8ZrBJnxh8lq51fkOFuw5yB1Kn+0EMKnldKK5toXJRBEViRjaJn+aQtXTlsjNrkES5PLpXbYJh/h33KhE0kuf8E5sY5STN56JCnUCW4qZFkSkwtfqAskkI61g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 24 Sep 2025 09:36:44 +0000 bugzilla-daemon@kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=220599

There are more details at the above link.

>             Bug ID: 220599
>            Summary: KSM performance degradation after Linux 6.16 update
>            Product: Memory Management
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: Other
>           Assignee: akpm@linux-foundation.org
>           Reporter: craftfever@tutamail.com
>         Regression: No
> 
> After updating to Linux 6.16, I'm expecting freezing, particularly with
> Chromium applications, when usind KSM with MemoryKSM setting. ksmd kernel
> thread spikes to 100% cpu usage, with console and chromium apps freeze, which
> not the case with linux<=6.15.x. I believe this happens, 'cause chromium-based
> apps using V8 sandbox with huge virtual memory size, but, again, it's alright
> on linux 6.15 or earlier. With Linux 6.16 it's a nightmare.

Thanks.

Please prefer to report issues via email - we don't use the bugzilla
thing and I rather wish it didn't exist.


