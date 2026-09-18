Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA33EC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 19:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6656B008C; Fri, 18 Sep 2026 15:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57456B0093; Fri, 18 Sep 2026 15:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D9C6B0095; Fri, 18 Sep 2026 15:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3326B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:50:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33B03A624D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:50:59 +0000 (UTC)
X-FDA: 85227926238.02.2E70362
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 526D014000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:50:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t6x4ghAH;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789761057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oK9evgZZNkEjZWEHUtv6caDlyb48jPUVEPSBClyBGM0=;
	b=aYPMA9ZCWxne6hI8fVtu1/YMMyPs/IWNakKBwh/nPP33bDWQoNc60visL6bwq7HkPgWvsG
	dpkC7tD461vR96E46UvI00aPxLdtiYfOqc6O1ME47OJKTD8K1tYwtptF2F9pysjOgmBZH2
	TlYMv1gYy21P0viN5aLpEPzIKj76ZZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789761057;
	b=5aQrVitrlCg9hTpejMCMImWY8uaJjIF0pncf1v7ubZKxZAxAdCO8JwJdwCTV55lH7tPPrQ
	EhfH8CT/qmTyQOikuExQE99UVS3RRxqgz2EapgE3564hkKQpX5yKxtsRco4EE073rwGxuJ
	HPAKUOwlZhF9Xf2rxkNSw1BqZzBxXaQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t6x4ghAH;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6DCC4323D;
	Fri, 18 Sep 2026 19:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A521F000FF;
	Fri, 18 Sep 2026 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789761055;
	bh=oK9evgZZNkEjZWEHUtv6caDlyb48jPUVEPSBClyBGM0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t6x4ghAHbv1VQgBHnN35Y+v+6gqPbE3L6Oh7kMmnGTgCMMB4pAn0U1Lhso5WvJBoR
	 7GbAJGyG1fjkTcbZyD18iQn+XdKkW1L3338hN+7gJ/4Hmc+U3ghxTOooh7a+NRbMXt
	 OSxfaanc6e+ZMBl8vAr7031V/wto/32CRB9nR4kA=
Date: Fri, 18 Sep 2026 12:50:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 0/6] selftests/mm: separate GUP microbenchmarking
 from functional testing
Message-Id: <20260918125054.f22d85a4def29dba081fd07e@linux-foundation.org>
In-Reply-To: <20260918112234.195857-1-sarthak.sharma@arm.com>
References: <20260918112234.195857-1-sarthak.sharma@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 526D014000A
X-Stat-Signature: c39b1gypqcriwc6ty3g1erbwzab4mmxr
X-HE-Tag: 1789761057-426357
X-HE-Meta: U2FsdGVkX18aHSRJ7g7+cFAq9DJoy+tXCfikXu6UxW6jgujUNHszbUHhT7UKzAK3WroNWHQw6Eop+2FLe1L66GJtubrS3MjAeAdOG1LEbsUFqpLOGZQXXf5IfzczLYDgYrGBcMMfFtZIZ71NAiGZeNCzR3iMApPRvE7MZegUK+yylwpoe2vv6bWprM0SBrk8RMCTlrRahkJh7rW7QtRrVj4jg9lclTj3EdvoixvaKx+d9SN5fkRElI3Hjk3oMl7tomSUY+QY4Zm/ZbdwHh1xGE7Hm1BncjcvYfQMymffjs9cakA1A2ttmppYTZM2UdFYF9wpITK7nuY+oZUobFxcbc3VwU1hGwgdk3JDMpzjLCzT/Sh257cu0qNSv2V8ykr241ZAFaAwxqfTV0fcJn4+oqHCwOqYpder/4gqzipcr3j++gje9N7lNBR4DwKgcg4LMyVgyGJXn+zB1KZ6pMZRdzi9J63mT2Mi9BXlqI2k8NX4IBud+DRnk08I2aEHNEvqV6Rw8GPYyYynJ8D6+CFJ3wTRyBN5/iwd9/c4EnPQIETpvXuIrUZYX/tje8rk5gGSt2WA8F5jBKa5jYM/7Tzp18qWBqnlZEpqUKEgOavVKv9JIkbLynYCf6XyoUdFkXI+XW0grxLHc/KTBwTkaO14hbf2tvHWudlrc97DfVJBD8Ek+kVLQIe1RHfYmZvC7pZEoK3tLNufPLwiaJbVGGPX29XKvgAtjmMtYaJw9LyyMu5vseJidMgRJ/lY4Y7cruLVzRMMkpKXm/pCzJjgpP+bKVXdFkq2BZD6aL8guhfbpZ++KR7rF6KsPVjfTm59PQFV5e7OwRk8zBXJce0XqRHK0aUAKF/O7NbTjVA/u2CjDNs9GqKf5C9jsgDAFcdu2zdtL40iJZdScsRehgpifdrAKjga/Bko/+FAhXqMesk8mFr9eglzFn/hgFO+SL9yTU9nhc12Q0nh6Lew9RY2Ol4
 MdqeplvK
 79jnhA+w3MP3nQs2h2yLiNTG46XzENl/+INHfBe1fLMd8NAyu/U4DHbmAwegmB7+8/fqTuyQ40oPLuR3UHDF1G59kUrS3aHtKd5hhu3JzsWYiJluig4vwZLfNyNWB2hh2zv3Pkra1Ht6JXKx/wpetsd7Qy+KEoIV4OVPtBUbIuPnCCZR0zNElt4LNHjih08xE/+aZCYufw5Fmd0E3F3J3MkvlaYyHxo5kCD3YGbWEamNgkvFAe8o5Vp1e1Ves4DAGSe7fEYSAkwt1GjvxGobOCUN25gm5mGvrBrtXKLhfXWWkJFAPhz21J7TMhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 16:52:28 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> gup_test.c currently serves two separate purposes: benchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK and PIN_LONGTERM_BENCHMARK) and
> functional testing (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST). Keeping both in one program makes the functional
> tests harder to run and report individually, while run_vmtests.sh has to
> invoke the program repeatedly with different options.
> 
> Separate these roles into tools/mm/gup_bench for benchmarking and
> tools/testing/selftests/mm/gup for functional testing. Move the shared
> file and hugepage helpers to tools/lib/mm/ so both programs can use them
> without duplicating the implementation.

Thanks, all queued up.  Including [1/6]'s read_num() fix.

