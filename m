Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83FED61022
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 15:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB026B0005; Thu, 29 Jan 2026 10:19:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2FF6B0089; Thu, 29 Jan 2026 10:19:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B936B008A; Thu, 29 Jan 2026 10:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFB346B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:19:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 921AE1401CB
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 15:19:29 +0000 (UTC)
X-FDA: 84385360458.01.AF904DF
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C28B10000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 15:19:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BR3wjJrj;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769699968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIp7jKuWgekJy97efthM5741IP+QBaVVTDcUYnJ8gmc=;
	b=DPdJ/pbGoNA4ND5AF/ONC1KsZ2o701o5uN4tRUT2rY8qOMzYw3LZYARU7shjodyCcETIVy
	lbCyPXTGkauL8tay6Glogs8ucnDc0qif1WpWeyFGcJCkI6RDgP7diyr3aAXsJCVrsy8GfL
	1PyHOoKuGeCBUjpG6LJ2d/UUtI/g4TA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BR3wjJrj;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769699968; a=rsa-sha256;
	cv=none;
	b=uff0nsjDcgBjzUJikAZCVhTNBxPD0RRhk5SiiMmnCN94lm15Afo7qXN4rqrMH509Q0vhf8
	WcFrQJ8BFnPkBtxhFpxocJtC9F/NGx0i31Zsa+6+4rlz1YF7IYxKhW7KWINeA24TI2xEpM
	ufLug1hTq3KLRWwFvc2lqXZl9Pss2w4=
Date: Thu, 29 Jan 2026 23:18:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769699960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lIp7jKuWgekJy97efthM5741IP+QBaVVTDcUYnJ8gmc=;
	b=BR3wjJrjPKCxj1WTCO2atJ6c6xqeJZCHHAHnVxrrsNappdgMNM2Go+lK2KrNlOlVgs299P
	oZhPnGnOqwLwpBuoUG6n2Z0RWXCNsafIuazWIOwOqHD4ZqkYeLD13uMZvUk6bOafpPn9f0
	u3t212KDl63dQDbYx+n11Mhvf4k1u18=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Message-ID: <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C28B10000B
X-Stat-Signature: 38egiakn45ifw1i896ehhxzgc1knjd57
X-Rspam-User: 
X-HE-Tag: 1769699965-66589
X-HE-Meta: U2FsdGVkX1+s584N3qfLu2WwH9XXSgqWeUGqvwXLiY9pK3b4UmrVRpueRbooaDyb6OqvyrJTAjIjZGWDZB2MYdCp0AHQS1OHp4J3lmyIpkfJO/NVFjkNIqxHSDpY8CSODQfCjBzEJOLsXPGe6TNy25LGIb+Y7SeVdPBkVXpifgSyWD23ZBTzKJzqUc1H254TGLLzrYdKlAe3e9vkwP7cvVheDCA4mixxUF2irglGzXobgLCN2pfuU2cdi2b//js00asdtb9KRZzBJweU7yNCQUTPFeDvo12Nuao3IyLIF+jhvR1cADKod4VSbGmYxv1OoIDlgcJ9FvX7DEoeccAXdfz/YtJ3z+CCSxY0iXAK4W5ddj62Olmyu5g65xavXeJaL6Vke/6D1Ce6mzQqPPHzAmogT+rZSgP84bnJNp6Ns2XwNcVomjAc7nzB6kxrqT7ffeNg+PjfuqLkh3x7bHBhOHEfEauf7GWWbz++m+Hq7runThGCaXjPQ8IIsV47oOvyjpZh/KsuroX/TSdOP6tvfKh84eZyaFDsa4gRHBucmeGbrl9xVvdgQKy5aAiVRZvCQcy3oeZvuKvMNb+CR3vdS97LV/FfHA+wC/D3RzVHIbAunG/KaRYBWZQLjNal+lwrn3CmqkIkM5Ya884l5G/Mei4OGdE2IBxlgmo7fzWAipgN+ocQ5sn6S/qITn9qz1vi0RkKj4qI6Qg/zraR2l5jfzVb1Ogo/JD6k/3eSt76njGpptCipDOObV1X5+KLYWsM8KKL6xFNrEaSfLMAyvmZUy5iUJ5k3QPAuAF0iKW/16U0zz/1mftXZWcR/M770RRuzIf0G7yi848kBMpz1WPQ0oB6hjw1b9Rmj8wO/e0FDqRPzT/e/Q34L8tgbLgVsb+0YUKijBgVy27xJRvO50ru5o28A1k6MDk2Le91bbWMILJLef9h2QYcpMc46Larpt/PCwbyr0w8RPLc9AclUKz
 N4X+wYbd
 G3kBD1cJ4WQLNjmFW/H02lUWqcH+fmnQdcezboKKfdEVuLSX54EXcNYD6X00wNm/e0NXjkQMWA+ggk2+wCvoluckjhndhNQPNIRpFqQSeNr5gX1NgKDHLjEXOEVTkndGKzyPC/KcSyruQeaetAsh0l8AKUjZIBLXNABlqlwHW0v0lDcuirfQ7QgI4XOT8anlNnn03exG9bdwMbckTBOLibz02bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

I conducted a detailed performance evaluation of the each patch on my setup.

During my tests, I observed two points in the series where performance
regressions occurred:

    Patch 10: I noticed a ~16% regression in my environment. My hypothesis is
    that with this patch, the allocation fast path bypasses the percpu partial
    list, leading to increased contention on the node list.

    Patch 12: This patch seems to introduce an additional ~9.7% regression. I
    suspect this might be because the free path also loses buffering from the
    percpu partial list, further exacerbating node list contention.

These are the only two patches in the series where I observed noticeable
regressions. The rest of the patches did not show significant performance
changes in my tests.

I hope these test results are helpful.

-- 
Thanks,
Hao

