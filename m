Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4638DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2796B6B008C; Mon,  6 Jul 2026 12:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202DA6B00A0; Mon,  6 Jul 2026 12:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB136B00A1; Mon,  6 Jul 2026 12:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D96CA6B008C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:23:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66F7D1C6F19
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:23:52 +0000 (UTC)
X-FDA: 84958873104.25.326EEFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C877380005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:23:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBIeOIrQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783355030;
	b=2IZIp2oOuIcGL70gq2zRsRbc+0rXxAumgIIcIqxU104ARI0T2I8SGgVH+T2m1DmkvF7jEg
	OLOA+jmzfdSoDjSrtoULxjtEJi1lz/hPG22HURhffhSNAjpwSCpnL4WUHHg+nfwEcg6Z85
	T7RvT4vQ/SoEW5TP5d//moRqQY/FqFQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBIeOIrQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783355030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wHt8+HkNGnM0KxjsEMNSxKDUZE1xV28kMigSgeCFxA=;
	b=DDT2q2OYSc1bXfdOFaYipcYasLKcjiar9dcxVHURR9iKIIYzPU+0HTFEQdcPf+ZMVgF0Mi
	AOqf5LEgEXLXP2YOClefH0KtWZdErQ2E0F0nFIKfjEG3dVJClS1Z83Jix4hg9gVLkpcizp
	EkU3QOZAN4klnFd8KSJzBjWe52MrxJM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47D8660098;
	Mon,  6 Jul 2026 16:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4EB1F000E9;
	Mon,  6 Jul 2026 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783355030;
	bh=7wHt8+HkNGnM0KxjsEMNSxKDUZE1xV28kMigSgeCFxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mBIeOIrQabVsxIUz+QOTSD9LBsdjsg87Mq8zSzYyUz4LPP7CDEzQ/vXsHMoLDtrgf
	 dEZt5lYkdRunGlUtVvX95Jdocdjo34KBqgi4ZxbDX/a03zrCfiitxcWoSJOgYkZ92V
	 z2ZlbKtgb8Yho0Vgdg8LygVvEPOOybAj/HOCNsHkO0ruI4Vzs+jcxnZWNvy8klXH+u
	 xq327ySGBvoJo4kBrfXUCEsTViLRrJzFefIhUhtjWcLX3SBKMin8qwtSYeR7qVn2F1
	 pJUdUUmIhUpgmGX42UzmCLbQCclvOhhX5PvmoGVaqj1KFDM7Dahd7c+/BShR/kPSba
	 iAQ4vh4KfzR9w==
Date: Mon, 6 Jul 2026 19:23:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <akvWipFuwLt41wOM@kernel.org>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <akjS7kiGjVwWaWEz@kernel.org>
 <akvSzb0mRSS5aCg_@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akvSzb0mRSS5aCg_@gmail.com>
X-Rspamd-Queue-Id: C877380005
X-Rspam-User: 
X-Stat-Signature: xfcbac9xhbaijronag5mecwbyzz9aqy9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783355030-895511
X-HE-Meta: U2FsdGVkX18T8zKNC+goz8tmbUHr98NHGWSYVkCoYZhSIILQ5JgdBbhWJQV07AAqZ7dXFROxG1eLNnwKF9awUkuTPIuk77R2P7QSXZ3Oqj63eQOcJTubcK/4pCpMh+Yg9rVJQw/2WQ/eguOXa7FJMEttimEc3yj13252nSbwL1uaqiThNEso6+anGUigJC7jwXM37zO6XyXSy8IAkaD/HE818x0s1RMMa0WOp3uk3iQj8gY7naNUkOhmCLMMAWZrvUJbZqVH22L9v/WBGwwfWaKExAypS3PqGLcb+2VxTIm0s4NtHaChI8V3l3ptRSAknHUFeP0V/t7rPnVKbKhdpCR5bLFwPQFZo5JCX63Vbb8TxU1SJlvYWgTt4GXRifCFdcXBswIaA9Id2R76F8j3QmaoD5x5/WBHuuE9Uozz1rAIufAufeeZmvbKirWFBdaPR7+98pHB7AY1mEbfmxCXGk7Sya1t1Vukz+t8CYCupGqbZymKp5eHepmJhxSKVyfyEuaKtODpy6koX/NLBjTom8Ai0EviimR46WMzJM4eLuzfCfk8tf/ONBrj8ZoC4tPyWurVfhcnHUw1f+GOOtxVZjohUP98VSNpsFPwZvVZsmxaS+lGG44xphSCyaBHp4/N/xZzmB39S5O30lN2Td511N/p6XkDO6qmlDPErETS0QfyiDzYG3i4wRZdPRie7WtzD9G/RCrX1q/n9xA9Fl6oEHWFZoC5fgecwylY8a6+1GC0OZJc8deDJC/4pYbeBqF00d9vN39erOkDzOa0B41PmWD7rNPT2mYr5iunoLV6/TW8L/FeI0E7Ltw9HmY7Va5Q9OO3w1Lf3O5pVuucyptANDzf6goaZwlA2b0JNYc8svq9ZXi5o5YyFM3t1in1W1o3S10AU1xvGaa2PxHKJrlqG8Fgq5fXVTY5kSoRUUfFJ9esD7lVYCtjtexRksD9A0HjgvGV9Tsvg/ecCB40Ruc
 6L6j2tzM
 A5Ql2H1NuhqlxXQ6XLOgKrMxng+FjHblPYnjNC4tetixykmS4q53cfraHe6YuCP+cdgarQXdS1lEoBIS1cmQ77sOcJ9F+jLm+0fYwZozd0w/6mizD4Sx2J59JkWrNBDVVOREgIMNDpTIJFKPqN+VjQhHL6MAToDEXWcOKArd6MaZA55VjwZQITlZLXh0dDKd1qmU+/c5qNvsKtkIJA7Px48qsmaVhCGpDprNcnINBkDiJPGElM+dTAWIaQJG3jHzYeXwehp8P3k46Q7i9gSzxZVeGK1wvXDpUCWa1VoJREBC2jjg9NAeM10kpqVhZqwlI78kTEZdPxVjE4mE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 09:14:22AM -0700, Breno Leitao wrote:
> Hello Mike,
> 
> On Sat, Jul 04, 2026 at 12:31:26PM +0300, Mike Rapoport wrote:
> > On Tue, Jun 30, 2026 at 05:46:09AM -0700, Breno Leitao wrote:
> 
> > I'm looking at these awk scripts and od encodings and I wonder if wasn't it
> > simpler to write the test in C.
> > 
> > We have a bunch of helpers in tools/testing/selftests/mm/vm_utils.h for
> > accessing /proc files and there is already /proc/iomem parser in
> > tools/testing/selftests/mm/pfnmap.c that also could be lifter to vm_util
> 
> I'm fine with either approach.
> 
> My main concern is keeping the selftest decoupled from the feature
> itself, so that review of the test doesn't block the feature from
> landing. Would that work for you?

Sure.
 
> Thanks
> --breno

-- 
Sincerely yours,
Mike.

