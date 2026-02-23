Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82540E98E10
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F04C6B008A; Mon, 23 Feb 2026 04:11:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69DE96B008C; Mon, 23 Feb 2026 04:11:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57FE26B0092; Mon, 23 Feb 2026 04:11:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 446326B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:11:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E76285B9B4
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:11:15 +0000 (UTC)
X-FDA: 84475152510.07.C99F4B4
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3960F1A000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:11:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AlTdMOtn;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771837874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DC3YEg3VT9TOzY2WonmsTGNTfL3zmdr5vQ17Y5LSPTM=;
	b=7a3AG3ofEusskxMQBbpRTl1VNPSbrR9ASoI6O5/e5dDSuTKHoyyk0rI7TD7RuDEmoPUb1+
	HLlboiCS8yWwe7cjDhVvYVrjZ3rJljy8l3kaBBzXb9dANJKbgYUwamAgCZV7nWxx5abf8O
	Nx0Db5IPoLzudUJ5clZ+kf5MU9c4L8Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AlTdMOtn;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771837874; a=rsa-sha256;
	cv=none;
	b=i7PRmUfnl2qLbisHJsUSW+rTrI0UsU35Cs4RFznHD8zCU0fR+x3zpwrxTlCd8eCuNp1kmL
	JURy16oFQ4GBBy6Io5QRDum/deAtwiFv5jdcJ8ZG3W7MCgLZkUlYov2MpkRnXcycRjLqZY
	6/Dsh0MZcAxWW6LOUI6pNtstsIA9Fsg=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-48372efa020so31630295e9.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 01:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771837873; x=1772442673; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DC3YEg3VT9TOzY2WonmsTGNTfL3zmdr5vQ17Y5LSPTM=;
        b=AlTdMOtnPtHJ1fIXfOaRNIzjKd+9jH1KrKDUXNpTFTJb1x/wV1JCDc8NjUX27Vk67z
         FMteaqx/ek6mgP9LpX9SdDc+teAFrHsz6KiLqz9pldMBcJy5LmbgTQRhqLmttZa04qbe
         Aypwc9vXQ1H6/OtU8uxlJCl38voJ7RLnS1fU+yE639CSP+fVeNv8Rnx40Dhi5qVlFjy/
         j++oGGWpWT4dyVH6caasAbF4DycwbDnEGc1HxEGkcKVmT8KEusk1kvks/D9WYoQ/s5Zv
         SviWk0OKSJT8SMb6/LRYfXasZg4HyEb7XIHqOQYtEfzXwJtO5MATMSvC9LWskB9vx5BV
         X2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771837873; x=1772442673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DC3YEg3VT9TOzY2WonmsTGNTfL3zmdr5vQ17Y5LSPTM=;
        b=ltuHOK/aN6vouq3kWpTR9bARPEX2FGeuEO33JKtrEI0mQavszq3DeIs7+JhRduW/ay
         5MAkU+5/rV0BASj9iM/fiKxLGTm8hdG8aCsN7nayAWBneKOfJNmf6vuoTJJT0+beaH3I
         /fjnr216UW3WZ8iIr5JfhFQHRBzRmC5ZcPSRVl4/ZFM1o8zksukC/3f5TH4OfCMQ079g
         44OrEs1eVY2BIIM2aCM1BxCXAhju29bBdHlc+0bhYtAlwi5SWap+gSir20XHAVoamC9I
         5jmed1FjBcQ992jryZNSU764qxGhL7pQHQNCedQ/tSs0wJBVXlWakMrfYrMBcdNEG1Kg
         /rtQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+kHFREJjvcT5FpISGTSEk0oR0NK6SrlrhkusmhJoo+Z+SP7R2z6/mKmd9vuQkdAyy5+/+c55sRA==@kvack.org
X-Gm-Message-State: AOJu0Yy/l30G5zEV3kc94P3RCjXqw+/VAe6odt2eOyjMFgnwiuChP6Y/
	4pY9LjqIz6a30bsSmVY7zl/Q11guytDrBWJzyzY5OxbxNKIY8xEjhDd0JhE9W8YtPF8=
X-Gm-Gg: AZuq6aKisRwhbJ+k3T+VQLmSGsBPo0POMPLVUlhiqhf1ZdFFq+iOMWqDcjJntbKlmUT
	4777wj+dABpSeGyr5dCERJDilnczQsydjjymWxRLHz19QnM+YpXKM90YDB1oeJQwI9OZV416YbE
	RTu/+M7Coq1XO6EMiCv7wQM+BzJLBd29X674Yt5B/gYWt2AnQfz/tZgidEoZX3oGMTh0aAu8faC
	6dacsQnyCbojWku5IuBwyoY6Fdwq+3jufIdDyZbwHXkKY5ghePSV83i+bj6yZxHINLN61LxCvGd
	E+tQjBandi+TIgzDUw89wwJ1PH76/Cm9D6aoSdZGaEZH+i4so6JtB1RmH2wcdaw+5eQ+CmE1/hd
	Fc416Y+CRYZmM5x17GvKhVTgMUAT+Zkwky/KJaXz4/Fn4MSl/4KuBgNZIvQflo+yCH2al0Vrx+T
	TVutDaIyTKJOQIVGrewDD6eEAeADnxktw=
X-Received: by 2002:a05:600c:699b:b0:480:6941:d38b with SMTP id 5b1f17b1804b1-483a963baf7mr117526035e9.30.1771837872861;
        Mon, 23 Feb 2026 01:11:12 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9cab38dsm159620255e9.9.2026.02.23.01.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 01:11:12 -0800 (PST)
Date: Mon, 23 Feb 2026 10:11:11 +0100
From: Michal Hocko <mhocko@suse.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZwZrw_LTilXsPd4@tiehlicka>
References: <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
 <aZibbYH7yrDZlnJh@tpad>
 <a1c11a09-da88-4edd-9571-0f792b59e9c3@suse.com>
 <aZivpwJnIGKdAMYE@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZivpwJnIGKdAMYE@tpad>
X-Stat-Signature: zssh168ywh9117antqnqcxiz4yr1a8is
X-Rspam-User: 
X-Rspamd-Queue-Id: 3960F1A000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771837873-417214
X-HE-Meta: U2FsdGVkX196yjtTI9UGAvSG0oIuBuxSH/tcG2KlAVg5f6MXCGVpBlVofqpUKWDctMpf+rH4MtbCrXDJmD7L3ktnCCC7vz1pIz06ljDBS+CTm43JxE8zeCfrqWIVil4IalGDz1eqS98YkViIaDUzF+sU59/nLZ3LkMoFCo9zTrI7HbpgSEEc+GKQO0/bsU+SP+5i6DL1LtBnEVTPf5hfz1o8CDGRAMaOEVbu2EImcSJJl0/XDS4g0Zx/QbQv38aHgZ42+RVZw0jv99Lucn1Zv8HV0lZgpWnysDur+OJlgBuW+X3suKGHDHWEuHg0yGwAJo6HAsYHv/dKfOyMXgtiR5kRKsYs+ZE2GV93KqcczcpuZGeRc80TXzbItUPzuBmFAWBcloE4+KJnoe+cu7LrwOxgDrbb3coSkK4CwDkhab3jdaIPoV2fkpp453QLgGEvLgTJgcZMkmL8rZ6igjn2SnXNoCzKkgWxHxbBImdwM056BfCWxVgO0sXcGhps3HJETd+IUCUukIpWzH2Jw14+vrKTBjQaKgzK7pMwwNX/tMz/YLEkOBlksU3T0DOYjzw+Vv3G90+6y7A0rRl8PF8ndzJGo0ih8xhtgm5MoQErSLFqQsqi3NSVxPuxngRzXkSWiQB1kMOi/DIOAkelnPtQZF8LlMXSqYZ+83Qc0Xu7On3ji44dWhK6gAPT6m04KzhmfvAu6sPkIA4v6mrVw8SpWCeTPzvvfIjRHHxBVKdHYKWQM/slpm7BEiafhJdBqLGmdM1JXgOeb+pCQIgUENKMP0ykfD5uHJQ098RSRoL50oFlH9zabVid4MnoMMm1pZjI0th+t7udGjqPbnthcnwD26pSLXaNI8q8fdSu0MGNneB9QmTRCK/D7Xb/ij8bSlMGuOvbSFEdY8osXEq5jbxs1utlO5+Es1FU/DS7kZtbsMGntRoB1ag11L6cDACudnSmlvu7xvhjydEfBCpKBLw
 3dW+nAjD
 W69g+H/esPs0tskoOKVdH62SStp7L4KmHp/u79h2jNRAi3zkhtpO8k9JwMPRcjm565gxZ6MwRxSeoh7qd4vxYiKHMhUfhH89jfukRxzBHWBrR7X1xLLOgg6xUtZIPUD2kcInSu1rnTXlK36s7qHFBZS2jLQDWdaHi5DFH6YLivxBc8ct7l2M18Hdyq8Rfr6m3QtmiKo4KnFegBt2gGhM85I3ZZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 20-02-26 16:01:59, Marcelo Tosatti wrote:
> On Fri, Feb 20, 2026 at 06:58:10PM +0100, Vlastimil Babka wrote:
[...]
> > >> So if we can assume that workloads on isolated cpus make syscalls only
> > >> rarely, and when they do they can tolerate them being slower, I think the
> > >> "avoid sheaves on isolated cpus" would be the best way here.
> > > 
> > > I am not sure its safe to assume that. Ask Gemini about isolcpus use
> > > cases and:
> > 
> > I don't think it's answering the question about syscalls. But didn't read
> > too closely given the nature of it.
> 
> People use isolcpus with all kinds of programs. 
> 
> > > For example, AF_XDP bypass uses system calls (and wants isolcpus):
> > > 
> > > https://www.quantvps.com/blog/kernel-bypass-in-hft?srsltid=AfmBOoryeSxuuZjzTJIC9O-Ag8x4gSwjs-V4Xukm2wQpGmwDJ6t4szuE
> > 
> > Didn't spot system calls mentioned TBH.
> 
> I don't see why you want to reduce performance of applications that 
> execute on isolcpus=, if you can avoid that.

If you can avoid that by making performance bad for everybody else then
then it seems safer to sacrifice those workloads that are much more
special - i.e. cpu isolation.
-- 
Michal Hocko
SUSE Labs

