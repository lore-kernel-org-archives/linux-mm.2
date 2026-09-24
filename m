Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA218C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099396B00A5; Thu, 24 Sep 2026 14:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0703C6B00A6; Thu, 24 Sep 2026 14:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8686B00A7; Thu, 24 Sep 2026 14:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC1826B00A5
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:50:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B0001604A3
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:50:39 +0000 (UTC)
X-FDA: 85249546998.07.5844102
Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75E9DC0008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:50:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJCCyO2F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275837;
	b=Hf2kIpsMdZV2LzXfMPZYb+eHT+2kpmJWJT/KL9qUjRQS1NPVnipZVPQomHz4aGpCZIPs3q
	dBsJq0jU5jtLI6Ykk/b29DxSXKBFSAuP4gYatc2+6/rH3iD2HoECu+lJ3klGSc066tqnqz
	Ww7aB0WpV8j4/KQrwIR6scoZ+jXOI/8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJCCyO2F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwO3fY8wiWeLu70HfX7+HYNTDjHJ8k0nCAXKE84dEZ0=;
	b=5YIHenk+tGFikldHDIEDmJb59260jjpqNjrKN1j4cbCXPGrHTNu0pp5izgsnFZdrOPPwDm
	8SzLxbCqxxc2b5XRclWYBY4omTUHF29ZwGLn3DEQ3ev0Crd61i8GFyBDGbrVUtqs6oZDle
	oZi2o3QTJU6itMkQaOnH0OCRkNq3I9k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wwO3fY8wiWeLu70HfX7+HYNTDjHJ8k0nCAXKE84dEZ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275836; v=1; x=1790880636;
 b=lJCCyO2FaalPN0PkwolHPxvv44Q23fPFcLTIU9qjZgx167d5q03NDdOhI4+AlMfbZTYA83MO
 o9VpV4tbAkI/FLHYkxrb0rn57gnLrGOGESVHUytz8Dy2RzOBhYwbLoE13NCWGx441jEkeeqZW/g
 +gqrkRzlFeNfGMHoFKaHmV40=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2b345eaae1d9b58d;
	Thu, 24 Sep 2026 18:50:35 +0000
X-Mizu-Trace-ID: 2b345eaae1d9b58d
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 11:50:34 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Peter Zijlstra <peterz@infradead.org>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Frederic Weisbecker <frederic@kernel.org>, Aaron Lu <ziqianlu@bytedance.com>, 
	Daniel Jordan <daniel.m.jordan@oracle.com>, Hao Lee <haolee.swjtu@gmail.com>, cgroups@vger.kernel.org, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <arVwmhAg1CSQAoX1@linux.dev>
References: <20260924184529.879516-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924184529.879516-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam06
X-Stat-Signature: icnger6kxitzirpuqtzye17g6kp1e8zi
X-Rspam-User: 
X-Rspamd-Queue-Id: 75E9DC0008
X-HE-Tag: 1790275837-772706
X-HE-Meta: U2FsdGVkX19wiQ4lweIpwydKfM8w0ntvyyZrnR2IqRncmlj4CTFY0toxu0MDfnn5o4VnSLJQiAgEN6MLKWZ/1izB5Jva0W7RMCFbzvoYKQDCsAgU7qtV3kzsoes5y6/uDVUri34Z5AlI4RfplmZN4JT4ho4l73R/73A/McN6QGWyDq63RepmD7M7rr90CtBPTM0OHpXY3qWU6vm/rFb8eWpmLMdAnyD3rMp/ovDXSRQtR4AaWYzC+4oeVDiX7P5y7jk2odApG08ZW4oe9Syw+53sJl7qkMOwrnpaeZHNqbOPL+R6iR0s6pTs9r12bpjy/+/oziC9VnQWsDROSWJmT8wloglDdReTooKsaIjYnW3fthT8eYwWT0Rv6zf6bvTPsAjjuGIdmkfbELbGyGsd4KQn4UZgm7Sjz+KNTSD9FE4oL7JPwtESlQOCe+hNUsG8UPZCcOg6zOTQSWZva9oerG7i4DTtw/TNuMzluD1wX+hkOAlYIWqUtrv0NKp13v2rPBN4AOh0jtXrf/bVZYjAhSuBSxJ3ssTWjK+LltJAvTdPU7rv3YNccAXKSOX5KWgd/QkQqqWeUT3E+p2x7RLqhFhghD1c9GSOr5AxnAGx9kXveNt6tpZY8qBGAJMUGS1h+Fc3hBeXoGIvB7a2rL64bogYWVkJZACxmOuG6aE/AQwoQnwmVluWib7evdBL/wALIKbk8/Id0m5rSm2SSk6r2EGYqOZ5fHwwCO6xTcqjvwKeJ1xHdw/3GcfuHxnu3GPT9flTS8sDChLrh7wFpsiH2bEZnHukPso00kxiTWmNzBtQJqMSaDpZb/2+rUSneBEvMZuvt6i7XA21Un+8tdYt3sMYM/kOMGpx7a9BaDMudcANDMg5XN/UcFUq5q0elTfGxo2dtQvT66tSPaNUUaWI4z5aUoXYlHaJxA3DIhJZQ+MWYVMx9KhqzKLn+h2vQsTeqEjYv/R2Myoc9KThsCj
 QSTdHzYR
 LgHeKBp2ZHrg6mksUBIADv6nr5X8PtFpI76quI9N2Oh1pssKPlviKWKiV+3I86OtfhmL5JoHfe7w+d1hXTvGrS/SjKqwevaRWB/X6VfruW8hWV026GYwPT1IeKXNNNzabvePnBcDs94h2tsXtYY3NR/0750xBfYjL/mohEzzx5JOwlUwTpsEe/Jqtz0Z6uzPpptlJWk1J1e/sQmmAfa/N+D7XWtYX2R42LxVCARIWLX7FXuT4sOkQuUCtkm7acft+EzgFW+wmQQQZ32erne2N2zE2EijMrm8AFIiftUVEJYAzpiHPvXm6oM37C6uVzxjSXPRA805jKvhK/nJ5Gm57yYMOV3xgSC02e6UBHLEbk4TNQLSwMxOwEB8g1SflKxiFSpSh4gy/oA6y0g1zP3kE4aQ5f/ofWbyTU8Q3qjSeX7bZRcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Somehow the git send-email got killed in between. Please ignore this.

The full RFC is at
https://lore.kernel.org/20260924184714.912181-1-shakeel.butt@linux.dev


