Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA42CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600EC6B0005; Wed, 17 Jun 2026 09:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2116B0088; Wed, 17 Jun 2026 09:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FB16B008C; Wed, 17 Jun 2026 09:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18E4E6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:13:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83195166115
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:13:49 +0000 (UTC)
X-FDA: 84889446978.09.1C146CA
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8036FC0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:13:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o05m+a4N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781702027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etk5TEpxc/Cbokv32elfaJQtcuFnx/QCHFl6IdRsRsE=;
	b=GzJio8ZfveDBZw8mZCK/qC/CgzGS1D7bz5qJ+PzL2mbTtPj8tIOsOk+9SEGakL0EKvRrV7
	Dj8jxJg+W61I/nArbeppwyBxj2CmjlVrJd7BPB5lu65UM6Yabkyjf8ITusjaMrZQKqIeRR
	GC2dCTL5PoMV+7SZoxVtywZ4JoS1DOU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o05m+a4N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781702027;
	b=z1fE9QwweX9wzlRfUgpW4R5fePisTHyfV3yqOsa5mb/NH7HiS9wZCUE/2Jp8o/UC/Ozvhj
	i0PnDLr1fpSQHQ1Pk9KR7O30UKEZDXM8OYisDGCYlwIm9O++V4Xw+yvv66voPF630y6nZW
	ljib4Xvymoi9NVhCTGuQGRRv/d9u55k=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-137335bc3caso7137491c88.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:13:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781702026; cv=none;
        d=google.com; s=arc-20240605;
        b=ZkXbVkdthEiZHhmX8xqhtGhldTU6T4sMtZd6DPukakdhqNt8oaf/pCL9hrMbi1YyGW
         O6g/tuzuumv/CTkG3T0GfxEZgzhN5pq3Pp0l6Xh9A4u9RtXiOoShw8tA0pXQzWdyym4N
         z5tlrSaN5GmGtmGbwcMrfWAvix0CzkCxfXx0dI1S6U+kTf9kRm9b7rIhF9UlPTcPA2Wh
         SplL1mk7sSV2c5mSmY8F0+zK6oI9lmt0sxmLRxMZ9T44ZGutS5Du3qj0W1hpRp7LUBAN
         H9c/NgtPPNbSSA0N877UdLrRMeNwuxRHwV42vDNiRyhLdU4Djme7WBcEPH8qruIWLWcu
         oYew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=etk5TEpxc/Cbokv32elfaJQtcuFnx/QCHFl6IdRsRsE=;
        fh=7C4o8zDG0IbfvtkoDqUmC94HGk/CkmEmfbe0buefLrI=;
        b=YwhkCdjHRFdbl1vDMZicZke5ZuQN1DH1qeeqyeNH1jVyLo3MAhUB/CGWJp/rdqsZNi
         fjCwgdDNR1Q90DtI22kjj1u61tfY93HzFwXD2Gr3nFtzWQyxgOezQ+zN4vMU6bArTEym
         OHC+d6dU23ILiOIqp4nr6evbZtiwkUdbiardQm7fa/Yfrtw1Kgw7ZX6CG65PvUHodE0S
         xWNbnOC3k5viRDEfYwHkfIEg55bhtVnXG/BGqocXioSTEHATGNDJph9+rHkNS2iGdGNp
         dQDTVgVz3rlVQWJ5rPrIn1mPeFvyria5GBQCl2/QvC+mw/V3g7aiTUgQtOV530wiC/Uv
         aHrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781702026; x=1782306826; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=etk5TEpxc/Cbokv32elfaJQtcuFnx/QCHFl6IdRsRsE=;
        b=o05m+a4NF3yejlx7wxlPPw2mnzmPUpuNVRf1lRCPjpb9rGD3jkgiByqbaonijy4W4o
         w+PsaC7jPdDmDhRZm5jVCJ7aVwWHZ2rR9OchaRuEuWnGGgbQDU9nQ0fiObVTWz/h+vYm
         zfZqTJ0b4S7gQeiwg/H5C4DUIDDSiT101KoV5vQFASs+BmrSN2c8bL+VzjVfpnheIgdY
         t2E2pK9IAAj0IbRpYMp7ZTofyVKjjgzy+3e3lrz6dR9h7DeKB1RKVs/0/uIh34pVS19I
         V0XP2cJUUqg7tkr3Z5/AaaHaBjA2hV4J8JZLP8f6mXvyUAFY/8jho8lJC/K/J+qke3mE
         8WeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702026; x=1782306826;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=etk5TEpxc/Cbokv32elfaJQtcuFnx/QCHFl6IdRsRsE=;
        b=B7i1+aFngRmgYkBv1lgfJTD03CzO3fp2VsuOHjEGg6Xjvvvs0iIV9iH3ImJ6UWKuVY
         kdqVVsLpt4B7MUenaKKvHilHkMC1252peTQrTadgdWM/1YEqYOAkNBNjGIv7aW5PK7rt
         AWQIt+2RUdc/QQ3dMeIxWX2xg6CWRD7HeVa6TCHMWoeWK0D4/ukXulbndA2FUjy5fcF3
         CJvJa7ye2RZ/TknrlCC7gsNZi6+YgAcxv8/Wz6Wex/XgltT/7zdXy5UKTEBPa7my0ivY
         pLkLXSNVp+++O06pWjvT0juGXMXJBLwe0txtV4Kib57GSFQLKjkiH7Rr5Xit2zLjPtaP
         CmTA==
X-Forwarded-Encrypted: i=1; AFNElJ+LZ/gbk2P32Fsickk9pwQ+itGNC5Yixkrg3vIdvJ6+FKkzt7qdtu5fuvpgy6wfDJ58yXvx3Rrq5A==@kvack.org
X-Gm-Message-State: AOJu0YwXgZtR4VHUfH2jRas3YR/m54w/U1JSwEAR4aH3WOMr8qjadAcA
	lsvMN4t1PeDgVz0ZJ1QwEHzGu4vlXz8Gmrrx+hGqdrdn7mPbm9HTynlXA1/kN3/me2t0/kLTBEY
	KYkk0z7sQN/Y8OPaTNQlQfl8UYC90hO0ky1Dhqgto
X-Gm-Gg: Acq92OFgc2xZixnjaAa5sU6LdrsX7KxqQMuMvn2opyRbKp5bWMufy52ppg3Vrtj765l
	eMVu4S67n1rL2fSFAo4II86sW65z1/z0rY8578z+ulCkkXtDzO5Igm5WBi2Pk4zYitBTgA8yU2g
	LcTatqMGCkW6TqGtkyBjjUcZQTW0ZLwqRCT1YljlJVpXbthYOGFpa8u2QYTOD+kvCtvINkWjv3q
	/yO6bxzDK8Im+m0QKuqw9xx5UsUY0+FRUQfOkKYapNOlsVmkOqyzCfLGKwOB7vYe+m066mlVhnD
	7oOe9dTSIM1YloIoGMQrByxYWOh2
X-Received: by 2002:a05:7022:524:b0:137:fad9:3a30 with SMTP id
 a92af1059eb24-1398f696441mr1495391c88.19.1781702024655; Wed, 17 Jun 2026
 06:13:44 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Jun 2026 06:13:43 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Jun 2026 06:13:43 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-1-a5bc7db5a9b2@google.com>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-1-a5bc7db5a9b2@google.com>
MIME-Version: 1.0
Date: Wed, 17 Jun 2026 06:13:43 -0700
X-Gm-Features: AVVi8Cfnc-0tXLPGbgF8GaHxdvGvxKqOIRy-XHFGP0uROl7Q0KGVLFb3jhqBNAo
Message-ID: <CAEvNRgGmX9oboHx=GGdWGJYebptyr0qdCsVFgSNQ5miUt4tFEw@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] mm: memory_failure: Clarify the MF_DELAYED definition
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, vannapurve@google.com, 
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com, 
	dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: a56qx8wzasp6cr34q7nzsnuxj9azhcmy
X-Rspamd-Queue-Id: 8036FC0003
X-HE-Tag: 1781702027-771650
X-HE-Meta: U2FsdGVkX1/NDU/4eZOVuHDQiwozcF60enL1AsrgB9W7N875Y6JWwoUCgKTyanAB8FZR+VuO2H2sgUw6AIPGYT4cpHjzWsvL/KnKcesddyYhIGHUpYLhxo4tJUg460pv4yothFNNaYg7aIh7eE8BZL82opJW5AyGyapWEhZSe8FyTfJ80dbsD7brMlaurEjlNwQjqD23ETFwVA3ifKnENTtx7BA5ErLFaI0LjjzCiQ7SSZU1J/cSZfDdOMLG+22tdyI9eq2/xBpYpowu5uHb6h1jnATnSUlL9ujLuJcbpXfw/hGy9jqes01UWHCVDwq350gwozPR/21kqKfIEPzS6Q/+qjgyr8TE1NjMfWx/k82trj2uzM0QHxNfl2kqSFgEdvQGoeDSCThCcwFUIlGy03MJkItr5viISRc7TgvF48OjGXruCVOYthA6F/OvIHpM64iCk30SaPZq96LKYb8jFSMRRDJWVHBJ7HAvvwPt7IkwbT3j8Tiel6QCnTBVTJ62HnyDpns8s5fPiVwlFK1l3I1zOBLDiSlaL/HZVdMm2iMFwR934e3T6HcxkyB6QPHJuSRaAo7PdJCei8CST/nEF9fp0ivLMKpHXTc07Thj7lYs8MHUSmOy8J3KRUQN5Bag2bQhEOqxsZ7Gd7pDsgspcNJ/MU/GLjRY2p2nPHYfIc3Yclp6ZXFlL7l7UF/PqLs2oDB+/mtDvrCPfnM/M31Y+QUJAmURgt10hM8xQM/7ql6AhneB+vOByAEcv+pzGSgLzuyBcvyeYMSyegg+r05tjPCFyIqdSnldpVwK10kvSE3L8L/PmD7SWxrBFqDWL/A41GXGk2waeKibEY84gyPDBnhm1pU2jcK1vqry1Ku/rwM7+UB8T3eG4y4hEWWj+3f+ovLSlG5FqqtL69zQBT5p0fhG3GbV7J51x0mz+NWp6SNyx/6yWEJ8yiN8I82+B82wJVTd9pE4NNeHcsGhT45
 RnmhnJ72
 d1VV2bjFEqJgixH+sEOgf0mcQKImUBwynWJ8DErsqV4ehOF6p+uB+Yjas72TRl982GDaWUJ0ybNBXpi8rdjaXX4a82Ox1tkRo+/M2LiNGJragUkfixGl79meMYBa3KY6TOZrvE9O0fDFpNtLi1i+IAxbTJHzv+Z89XZl3H7mzQTwuSfpfyVyAYAGjgFE4huiM357R5wwt5lSMf1gg4IdkpiLSPbcdP9gxrT8IHYKJjg1x1iiQWM4CpoQ+9RYH55EgG/GPyAJiVBbM2wqL6Ry43X5Or8jGzV4/8G6C65s5ht6VmjwR0fU3JGwM6ERzOw1mJj/IXJr3A7TQdDiZH/tWF4cbZH1wMBOVJbcgMcvlGbi57h5yVpq9Nbuzplq8OYnSffvlvhuE6vmpKyUwwP7DTjAkByR9boPwPZPRZl+QFMLOaxG4hR7it/7u1DpV6zANKsD2n5Vxx1BIJX1DMoYLzPClHl1t53oyFrN5hmE69xd7RnCQ2q6cUlqgEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lisa Wang <wyihan@google.com> writes:

>
> [...snip...]
>
> - * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
> - * The page is unmapped, and is removed from the LRU or file mapping.
> - * An attempt to access the page again will trigger page fault and the
> - * PF handler will kill the process.
> + * MF_DELAYED - The m-f() handler marks the page as PG_hwpoison'ed.
> + * It means the page was unmapped and partially isolated (e.g. removed from
> + * file mapping or the LRU) but full cleanup is deferred (e.g. the metadata
> + * for the memory, as in struct page/folio, is still referenced). Any
> + * further access to the page will result in the process being killed.
>
> [...snip...]
>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

