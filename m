Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E1E9CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0D58E0015; Tue, 11 Nov 2025 14:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C72A8E0008; Tue, 11 Nov 2025 14:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705AA8E0015; Tue, 11 Nov 2025 14:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED088E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:03:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0907B1401E0
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:03:27 +0000 (UTC)
X-FDA: 84099249654.25.4335C4D
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 451EE40007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:03:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g0piEOi7;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DW8aN6cJL9dQFQJZZx/YDopoyiRzOsZu1J7Nkl1MZyE=;
	b=nAPn7AlRptDDewBtVWr/4I6UiGVFcUWT6nFv5nqxKgvKTs7cUyRIMtr2HSpOjyO3SjGnC3
	KvqwfWvTpjpRNJfOgACg9Q1rtTFBW7RVnaS6dwUhEkEMO5E2E6C0ji34b18BhvYesWFKIw
	m0LTv0Xg11ecvQA3d7sqQKAtZ/a/slo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g0piEOi7;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887805; a=rsa-sha256;
	cv=none;
	b=XBmazTekdZ79uv2pSeeh7QPoZzzy6AOe9Z9ImdOxCsWCi9qAxTkOmCCbAEOUY7c/1uxQPT
	MvISvORAZbeymMhGVbcxFg1Sb1zvnDypkEL4JJNcfXcTnoQvjx0EjjWuxZyVIOISIL8+5/
	//71gTbrk/Tqv+TLacg5q4EM0cBDHSU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762887803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DW8aN6cJL9dQFQJZZx/YDopoyiRzOsZu1J7Nkl1MZyE=;
	b=g0piEOi7PUNvhRsEedKkUKToKKhRiRVhkUdb3LpP8NXbecrf9b3s8VAaPeLvtQGogIZlsr
	hAeUk3T/QXj1j5qRVb71vKrkldRbCPpU2JzwWMajvTO3vnA5hBoeA80IFo29+LjL0ewnzv
	FtZ/b2SlKMv43H3BJwsRfu/Fu645uBU=
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
Subject: Re: [PATCH v2 23/23] bpf: selftests: PSI struct ops test
In-Reply-To: <aRG1AX0tQjAJU6lT@tiehlicka> (Michal Hocko's message of "Mon, 10
	Nov 2025 10:48:49 +0100")
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
	<20251027232206.473085-13-roman.gushchin@linux.dev>
	<aRG1AX0tQjAJU6lT@tiehlicka>
Date: Tue, 11 Nov 2025 11:03:16 -0800
Message-ID: <87bjl8qtmz.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 451EE40007
X-Stat-Signature: 8a8enegokpa9g5p1bic8ikd85e5xq3p1
X-Rspam-User: 
X-HE-Tag: 1762887805-511736
X-HE-Meta: U2FsdGVkX196bqZRjuGwuQZWF2urnB59qyezlfEWpKiYzc7GEc3GjsEgOhlICIqMMdSqoS4aOg48Dzi2Wc9cFrncwj0p4HqQl9e8VUDxUs6ZluO3EbQgCTKBSBaryUXNfGx6qSBxlB1XzqcqrqrpHegYRSk8SkjH+vR4dz5lqNF9ecuITLlYtgw2MiHjPkqr1fxarhIe2ZwoL/VEsK45RE+SNmnh13pAjxBTsDsyQ3EOtupT7oGJyy2R3qfHDTMAiZd5v7oUI2L7tmqudlwCnznfCW7MRBj8o+W6OKr/8++9uyFN5wXe0juyZzE95i7tqGBY0+TmYqP8lzx52v/ffKdLVaJ3PPXInNz9QCdmG9VE6aYpkAjnZXSs0MeAppMx0aOH0LD4SqM2iPbzeZ29SyDl/LvwGAlp36aCa8GBzznqkoaDfEu45LAewQUZaR0Mufm6pcGasptOwmo5FCJmKEm/5j26ks6pTQAq8AlTGe2Ct0wUudN8qkl1OsRtSrgMgwX1HAon+oxQbCjtHqiH+3IMNt0WK5bHlOczNKGemQUSgwdbtYj9L6GjO+wF+Bbrk2niuilaUhwwcIht+hMgjchT4l1wnh7esUxoVQATxgvafbgGK7TPXUBAvMyVihcu7sWlO1yu9EEx9ZgHNONwpvNEfGXaXgPm/MvH0DB8+Sopi4EhlnKlscDg0w9WwXl6ZgVOlbsmSd1ptvlZfqLgxUl2VdfR0ZLStAXe8Ljmp0lfYs/HnTFyjViBJlHFHtuaYcACEaMxm7jKtv+/tzNn9BuSC9wwSks5FhpO8h/uQ1CKGEXqVklHKAjw44t98Yw/VUqFVM4uBELS2iWRPSFn51eWnbkVBamSSxyP63kSM4eWyKiIeewfBjQNn94NqVWY1EFAzO+ZK5S8XCqeox+LQEtlxYbYXQ4QIKZ1wm/nF2f1jrF+s8DF3u7iKmsCG4KYP9LOC5QkfEPFt+bKj2y
 tTC2wAdA
 WeNOYaY1tfYQ8+Ue9GMV/g99IWK0PjEEjfnTYtxrYUwQY7viJF4qU98jqjf3MilEAx8OG2V2FvP3dLxBbDVTM+EvKsGlek07b2v1xNZ2v0gI3j8rh/lGyAnAh6KT+DvKu4oVT9eJk2uxL23QxQ/ACrC8xYWwFHm6aH8rrLMWyOfCfuYQ8xVBfkk23XgBzsxcRU5HLPcZ9N+yyGWPCo1EC2RQAdu9E2ZuBkKM7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 27-10-25 16:22:06, Roman Gushchin wrote:
>> Add a PSI struct ops test.
>> 
>> The test creates a cgroup with two child sub-cgroups, sets up
>> memory.high for one of those and puts there a memory hungry
>> process (initially frozen).
>> 
>> Then it creates 2 PSI triggers from within a init() BPF callback and
>> attaches them to these cgroups.  Then it deletes the first cgroup,
>> creates another one and runs the memory hungry task. From the cgroup
>> creation callback the test is creating another trigger.
>> 
>> The memory hungry task is creating a high memory pressure in one
>> memory cgroup, which triggers a PSI event. The PSI BPF handler
>> declares a memcg oom in the corresponding cgroup. Finally the checks
>> that both handle_cgroup_free() and handle_psi_event() handlers were
>> executed, the correct process was killed and oom counters were
>> updated.
>
> I might be just dense but what is behind that deleted cgroup
> (deleted_cgroup_id etc) dance?

It was a way to test the handle_cgroup_free() callback, which might
go away in the next version. If it's gonna stay, I'll add more comments
around.

Thanks

