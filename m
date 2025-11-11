Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52722CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3558E001D; Tue, 11 Nov 2025 14:18:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A938E001A; Tue, 11 Nov 2025 14:18:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D72D8E001D; Tue, 11 Nov 2025 14:18:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7F38E001A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:18:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2258712C532
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:18:05 +0000 (UTC)
X-FDA: 84099286530.11.84DBEB0
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F7EF180009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:18:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kT23GwCJ;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762888683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFnKHaytVNV0OfjfOFrWCarKwTG+bMnNvrU4GEFWYBk=;
	b=HjPb89Rf6+HhBf2ogMHB6vQT4PLZIqBmG4N5QOmGb9zTCfJ3ZAxT76Hr8v4WzlGQo2H1pt
	zuwVBehdrzdG+uPMuLcuVy/V5eQrrvyAQ+b2hYhkN8bCC+UxAhTVxkzGJaOqJEnW8MFHMt
	cM6bZANjJP4aXiUhLG84/sR4HB17h4U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762888683; a=rsa-sha256;
	cv=none;
	b=LOH3cOozrWRYpsxnzII93/OD86tYsXz8SMI6BbUGGTBRpc+ufLth9xzI7nt1ue0qhtFelh
	wqw2obQWEJo5yxGVaQvVke4MMijmeet+uZ20Cifoyr8LCt7PpKaUsrtXG62eor6YTME8d9
	zwbJ9LsKtetiLQ0OcA7FSCu2X19eRiQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kT23GwCJ;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762888681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qFnKHaytVNV0OfjfOFrWCarKwTG+bMnNvrU4GEFWYBk=;
	b=kT23GwCJTLtrgw+qw/LIT9f52tM66JsOOW1Xkg2v5t3ySioBIioZdiYVLTj8+aJfRHcm2Z
	2DCDxwlfjfLs2W8TxB7i+dgf1S2QeNBp5CtJlXPMqP+rgLszGmOnZtV7N0h2bDPsGvUG/s
	knjm/jRQNK6WJUyutK/XnFRE4BctAjQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrii
 Nakryiko <andrii@kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,  bpf@vger.kernel.org,
  Martin KaFai Lau <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,
  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 14/23] mm: allow specifying custom oom constraint for
 BPF triggers
In-Reply-To: <aRGw6sSyoJiyXb8i@tiehlicka> (Michal Hocko's message of "Mon, 10
	Nov 2025 10:31:22 +0100")
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
	<20251027232206.473085-4-roman.gushchin@linux.dev>
	<aRGw6sSyoJiyXb8i@tiehlicka>
Date: Tue, 11 Nov 2025 11:17:48 -0800
Message-ID: <871pm4peeb.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rn7i9nxywgdco5hz8sppbftgbt695yd4
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F7EF180009
X-Rspamd-Server: rspam01
X-HE-Tag: 1762888682-486693
X-HE-Meta: U2FsdGVkX19DmmRoaaVf86C/trh+H9s3YJxjL7Vd78zY78JEsRfrDEXel5OJgnI1xnRPUUB1cbq+A7zuDk5degEQhdfkAQkLAsU0mLIlNJQ9eo8daMVXrcXLQP0H/RHkT1cbRHFHuTzio3wrQ0bH9PWBakWOCvZSEjzTKAfMDUHQhpiy0RYjPRIs5rHXpV0ae/bx2eDaS6NeZ3UHFzBGnub81dd2Fcb436UhKJQWxHennITfid+S6M2QjSL8XchvhhjnfO2qUGtSIrJG80XNJInhRDtUwQylyzVECuX6S9yo4Q/XCKLdWK3XczJYw+D20C1zcVBanxN7rOXd0dsVdM80yZRv8+2h/XIsEJP7cIXZrdUkSqSLcbc7CT1dpaIPAR9opvR9jIc6RcJbQ5SmBXfpQsLnbSlLWxHHMzGAegzaIQiGnaCxCQNHg/gaGPUPGpiGNw+uRp8/e9DjG/iMz03+Y8y8jug1NAQmmlTDlDLmLQN+TTjySBDCohZgkNHnUqtNiUfHWOX6O3Vuoen1bl6YowFy9HJc8raVdakvc1BWcXz4e16irU+1BJqtVDVAN9uNmQq9h+iDSI1qpwj0L+7odas2L3PlH8q53Pte0r0Y2YVnF2ndmHqX05nEkk2LfsZ3VfHwBlVDszG10BEHfm/msdWjIdYCTRQMkZvf8mGsSYzAVCQCLo1A1H2fhm8ye6g65hvOn4Xuj+F9caTlZJrV8UgOnoHGzi9G9Tfk4hE5thOsdSyWqiYMvfe4lX2Tu8Gfrvsgtosn7H3QAEr1vLAQYt5os+vNnXHE47AsgVlQobzvxNRYEpvFYX0DUCNHmzYYWwSYDpv+0GNzV5YWLslDFUJ+oFOALNu1rl720OxSvozO5GzG7BnC+HPQK9D9CyvVTrOOTdZJ/ucYvRUt/67Vda+pKmPTa54RR/RezJ86Q2iG7/wvVXTIPqAhW0QVISTA7M1TM2X4hciPRmw
 xD1lHy6O
 S6buRj/GDCGAzczmFciDZp9N7EmcYJ7LA/e/8qbPev/eABRaHN+tertN+TEcb8lyu3Fd+NQCcLE6cF6j9GtzFVs727veMKZPvBAtGMj12KUHB4mUoWdyQgRz8fH/kR1oj0AGUicak7QXn2j6V/OC8E3QypnNld1eFn0+UgWdPvCXosGmBZM6sUtD6ZaVneMfsy/O4Xyqb99bj8rIC6CCOlKMu5R+PS7R0WPW0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 27-10-25 16:21:57, Roman Gushchin wrote:
>> Currently there is a hard-coded list of possible oom constraints:
>> NONE, CPUSET, MEMORY_POLICY & MEMCG. Add a new one: CONSTRAINT_BPF.
>> Also, add an ability to specify a custom constraint name
>> when calling bpf_out_of_memory(). If an empty string is passed
>> as an argument, CONSTRAINT_BPF is displayed.
>
> Constrain is meant to define the scope of the oom handler but to me it
> seems like you want to specify the oom handler and (ab)using scope for
> that. In other words it still makes sense to distinguesh memcg, global,
> mempolicy wide OOMs with global vs. bpf handler, right?

I use the word "constraint" as the "reason" why an OOM was declared (in
other words which constraint was violated). And memcg vs global define
the scope. Right now the only way to trigger a memcg oom is to exceed
the memory.max limit. But with bpf oom there will others, e.g. exceed a
certain PSI threshold. So you can have different constraints violated
within the same scope.

