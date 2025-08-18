Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5922CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 14:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87AD26B00E3; Mon, 18 Aug 2025 10:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B666B00E4; Mon, 18 Aug 2025 10:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71ABD6B00E6; Mon, 18 Aug 2025 10:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0316B00E3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:00:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C29D55BD2C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:00:30 +0000 (UTC)
X-FDA: 83790038220.18.803636A
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E881180005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:00:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HbTa/QFh";
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755525628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSDAQQs/eDf6jzs9vn0KXaA6FT+dFTM2VMLiI+QImw0=;
	b=TonHKjYsDhOmY3X+Q+WzShEgnvLcyohQjtU0V2aNJlCaeQNGn+O9RzT7n5erVQE3pO8daj
	4mshLV6nG00eG0EboRTh8vfF2gBBYmgZhZktY4bEEQlMP0/hpbU6mjXoxkt9YZK7daF9C3
	xniuUz5urb1eoP49MrF0zqCmErzkJJE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HbTa/QFh";
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755525628; a=rsa-sha256;
	cv=none;
	b=NLRIxBRlqgdUWfJnEr8v8pnjZF6+gEu0EP5pjw+g3zJYGfL1W1GmcWO6cApI/YgtWnotdU
	uQ8jQv6xTevHPwSiqaqSjtBMvaKftlppWfU8f6Mcbut3iGKA/nQSh+eqHRCBEAxmiMdMbe
	3DzqDmXds6/NV3IYbqGv/u+1lF1SW0s=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b9ba300cb9so2626207f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525627; x=1756130427; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VSDAQQs/eDf6jzs9vn0KXaA6FT+dFTM2VMLiI+QImw0=;
        b=HbTa/QFhnjFvWyWzbHMtLV17h3JS015VDnpCj/npNwIk/5HIuebNBWmsrivUM/Gtha
         18um66cq/61GFkDLuEdK78Wn3jOZBz+WiQsyyMcmrgFAdDEAaU4SVd79m5ss/RzA3jne
         QUixrUeO+5XvvnIzhGbDj71GNjkILUVR81LC3V9NcLRnjL4H25cJB7JR0Vjum1QhVxcj
         pXdmU7j0OLZSHZJzN8ze1ylljfh7sZPl35jJXrIjDGYZIQ/OuOmt0vgS08yrGAKq/6d+
         5CY/7PBuHau+DFzibze98jXd6/YdhJfE1qTnOHI7b7En1DI6LL/ztqM+6Klcc3RqV3Rr
         99cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525627; x=1756130427;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VSDAQQs/eDf6jzs9vn0KXaA6FT+dFTM2VMLiI+QImw0=;
        b=qs9IXzeZwAkuqUQ5QzAiTJB6HLBPsoEdyVBygejNaT/sKE1KF28KjjlA1etogAfZqe
         5m0BoIeleqZMnFF175wARSeL2Xg9wf34aZq4ZcGTKnDY5+6ieSQQXo2PnPQuGJreLQvC
         t9Oy6YqC1XufBDgUmiRcUBoDgiiEg26rg1wCoa+PGWHUxg6y+tK8/8M8YIzxjpto8cdy
         GNA7q1kbqwl4GEUk8/GxPE8a+xIYIa0kFQQpZwJfK+GCRODohmBTEsn5TsB01YwNfIA1
         ULhNCJKOFa06xjn3tC5TivmCYshQxDgPqPGMgKXQm1nq0L/dQCpHjK9u+VIfhMDE9CyD
         2rew==
X-Forwarded-Encrypted: i=1; AJvYcCUQ9VPV59PMCHNyi9g0zpNWElGnwzhw/pEn9+CCgTBKMd5Q3+odnLr7Cknqu2yeCLY6BibXOtjGBQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5loYfP3JUQFTywrNLIK9Rdun42OOvuhs/h6CYP8W1IWOXjhOg
	5cyQM7ew4nhVZ1Am5t3xxAQzQb3GLFx927I6sPe3pbGRqf/q6ZAXjZlv
X-Gm-Gg: ASbGncsi+oaaEn5udWu5I4QY6K+itSGVFZX0At1cn2w+fsJtcpgZ0W2eew0MBuys9Z7
	oBiw5O/bA4B7IwhER3P8QMh17EiKJuLIU2U2iOUo1oCxYA9qFH6UVd8cCsZXm6AHvxLZ8q2NdoP
	cTX95cmi4xDnbc9BU2wqKiSQ1QQCYcKa5pU/lwDv2LhEkM/YVs2B1VNesEmLeYPR77vgKN3Vv29
	ppru7EnXoGdKAR+eEza2GreVuOLKO1jBg5FE57Vhd/hbTSojLalsmZt3DpRLAaAeQj1QeLXM3AN
	7+pCb/JCPQiCWM7hD96DBiie9gkV/wstF43dDuXC3UJqsCPDDWWhw/kJYOxVwAIsLkiV6yIiDUl
	BtF/B1HwOWWqDbnSEEhQQSCZEj3acLe2/zGYnDEbaiaFuFkkGACG3XNcdPQ2b/5s8AnF3vCU=
X-Google-Smtp-Source: AGHT+IGpI3MhtsraG8DZwmW1iNOMsdxlcvio/Sd6lXrtm9sglVY2G8/vJ1OgPmieTDzeNJ3ez4BAyQ==
X-Received: by 2002:a05:6000:2287:b0:3b8:d25e:f480 with SMTP id ffacd0b85a97d-3bb4d619c81mr10195865f8f.29.1755525626644;
        Mon, 18 Aug 2025 07:00:26 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::5:7223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bc5e232534sm10617816f8f.24.2025.08.18.07.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 07:00:25 -0700 (PDT)
Message-ID: <8e1ed2ae-bc2b-4ffc-81cd-61ad6878ad0d@gmail.com>
Date: Mon, 18 Aug 2025 15:00:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 mm-new 5/5] selftest/bpf: add selftest for BPF
 based THP order seletection
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com
Cc: bpf@vger.kernel.org, linux-mm@kvack.org
References: <20250818055510.968-1-laoar.shao@gmail.com>
 <20250818055510.968-6-laoar.shao@gmail.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250818055510.968-6-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E881180005
X-Rspam-User: 
X-Stat-Signature: ccbq1zuupgfkwoek8ogzszyw4jnqnpki
X-Rspamd-Server: rspam09
X-HE-Tag: 1755525628-293042
X-HE-Meta: U2FsdGVkX18UGcKJjFfw1Z1ffDSBpDbQlvxFW+WZNsEXJlfK+t7bIcRbrDi/P0VJeaJPFIQxxMdexX1pXY79+ifIScBVGhJHphmnNo9ageIVBo+eRjlMg96pGIsFEcFtnSWI3RScru5mWmvY2GPPQIBQO0k5beypFBcmyX4jgau4BSf1VBvPrxeeETP+nupl3Lm5wUees6FuB+rT/tP1BvOy0RL6qPs3AhmOLimPSfLOFMhMuyHO0xo1TLPxN2Lpb3j83I9Pm9MaRcl0DWSGCcZNBizsohsYtaTUd6LuDftdrkwokZtV7je0cd7STqh/05ZlGzXWvm9mSagLV95p5Ln3WQewyEZe8LODldBC7Ig/xQXctuyaOptKa20UvQ6Fs7OoZP61QV6IlSiUoEF16l6rasDOZGqISNdZU9yf4yxXsv0fLeFTJc5iOmo77kHA104ootFRg4wEoLwC5Ehh9v2i8rzXiqRzd8kT5uCHvR7AO56xGnAebWkqAbCMSVcqAomgRjyvZeNJ/wAye3X7zwYNR3hYUG7Cl88xb8BU0prlxj6mpkwUkvR3eNyuAsmO3TiIkrVC6ZOe5ZNFUFwUM7XOll/zPFRrvY7wGq1++G7OreFfbVTuL4jQE+wIoI2AmWurlkgL3CtOpYSrAUcfnx2fWoLBgvc4SuRJEATVtWh7DIXOw+NXsErnvMg6rN0+GWzz9Tk9GhOtR6fxMXxx94BMMt/5JEyoy+jkDjb3R5YBzSvSwbUsCOuJp9Rlmpk0iWGh/aC3O3bqSmiNq3tF0epvSrWzX5FHYjOJFGJfYTPRwIRwbsoKZ31OrSG6IOcmyMtpmpUIiu3s8gzKCYY6Uxz17Nc1vjvwmGCwd3SEuowIJVDmm7sxOwfog3PG8jg9xY1IoqAOWNRjoVeYrZiq6YT90Ylhjpt6I+TTLRLqOC79mfey7CxUk1j2VYCPhh06eRIZ9vofWwT5oqFc4uG
 dg3/bo/9
 sWIGO8OXToTqca7IXvGBnUGTNhWx6O/mujsyVh1NJumqAXTwrjLiGqLfxQkUWGaC0wH5TKlMlICnvScpIErEzEn7OOGvR99sG4roRLlSvf6bDng3lOfgNWbxsHsc56KezOpVaskYrWcNzfKBSbabEgnDW/SOAcoaUB8Sn4hmPn30GZTvNQP5YVCFRQ6PyfUPFhOX4G+4VZuWbTkEGwsVAVc1flad1p4/chT8nh/+joYYziiORogPHhcS4HQSV3jOqBz9kJgpwErQcQlpaAFuxBe41+gwrUfHBhcF7S+dIGCtj6St+PBjtm3KbnQHW9uxwuuvToaTzn463Qjs2Wj08jqggwsmftqguT2Vp4Ygtn23QFCSQjafeQ6qtaBEac942kt58WRaOgqenFrytgdjBg0XGUp9DfrbwFmUanlNuyARYXUBFBKJBINwx8jnkpHz1HflZcK/qF6p8/FHYajZezUssRfHbyQUpa/EfN+/TLtzelsXjac+HVsmnVsQGqt/g8MCIeO29QuCPy5o/6j9TXonfesxQH61zdvbbZH0B2yMaKQJre0C7o9z+kpdbhBiS23OQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/08/2025 06:55, Yafang Shao wrote:
> This self-test verifies that PMD-mapped THP allocation is restricted in
> page faults for tasks within a specific cgroup, while still permitting
> THP allocation via khugepaged.
> 
> Since THP allocation depends on various factors (e.g., system memory
> pressure), using the actual allocated THP size for validation is
> unreliable. Instead, we check the return value of get_suggested_order(),
> which indicates whether the system intends to allocate a THP, regardless of
> whether the allocation ultimately succeeds.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  tools/testing/selftests/bpf/config            |   3 +
>  .../selftests/bpf/prog_tests/thp_adjust.c     | 224 ++++++++++++++++++
>  .../selftests/bpf/progs/test_thp_adjust.c     |  76 ++++++
>  .../bpf/progs/test_thp_adjust_failure.c       |  25 ++
>  4 files changed, 328 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c
> 

I think would be good to add selftests to make sure the bpf programs are working
after fork/exec as intended.



