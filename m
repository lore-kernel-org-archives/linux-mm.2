Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96814CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 23:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875A16B0011; Thu, 11 Sep 2025 19:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826376B0012; Thu, 11 Sep 2025 19:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C756B0022; Thu, 11 Sep 2025 19:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF546B0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:56:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2F6C59BBA
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:56:06 +0000 (UTC)
X-FDA: 83878630332.18.7F3063B
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id D519D160005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:56:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=woUpxw0L;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757634965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1syGOpRMTLt/2HES4uKtyZYHkD0JGY65K8XvQf+2yI=;
	b=5ZbWeLNc3o3CuolBKYMwAHFSn2YYRaPwMSzI3gbVgKdeCQAF1wgwEXyVzPgOW9uXHLQD1l
	h4XK0veb0z3QqUfLkVLkialCV9KeGA1DmQD7VEJG+upGtBcs3fNs25WQlTLmpDOge2dK9i
	UECvBmK1qGTT2PnA15cLDZkLdvu54Qs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=woUpxw0L;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757634965; a=rsa-sha256;
	cv=none;
	b=arXZhao3H38/cX25uZHPqwTAamuF0imjROFX2sTfJTyiheLXJM3jKEmY729jht0RNM9xNF
	iZxgjpySSNX2qqGYU378TF8BdG2gDM2ZqV4dr87DGXvjQaqx63VmBBaclu7QlpESaMwrIk
	O4+XcwO+Clf3mdn976hQuTOofyieDRI=
Date: Thu, 11 Sep 2025 16:55:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757634962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H1syGOpRMTLt/2HES4uKtyZYHkD0JGY65K8XvQf+2yI=;
	b=woUpxw0Lvx2lNuiyEe9jO0AcBG5pByFcVWwU5B0QKOHtZDf9/l2FReWiI5Meepw10iTRjE
	C10QmKSidujzUGJsNRTPnzuwAkv6addj4INaQ1XCPEOxwtQtf6/DQlaA2DC+CXrxZxNprb
	UU8hf4URR+WvcsxU8T34PD0IQyboj+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, akpm@linux-foundation.org, 
	tglx@linutronix.de, liam.howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	surenb@google.com, lenb@kernel.org, rafael@kernel.org, pavel@kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v9 1/2] mm/oom_kill: Thaw the entire OOM victim process
Message-ID: <y7hdpmq6smlv2eztltwilmxcvalax63y66ttbckewa6mrk45yl@nu2kv3vtbsxv>
References: <20250910143726.19905-1-zhongjinji@honor.com>
 <20250910143726.19905-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910143726.19905-2-zhongjinji@honor.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D519D160005
X-Stat-Signature: igb3rdfosgayfnyngn5gdy4aqdaog4tt
X-HE-Tag: 1757634964-105297
X-HE-Meta: U2FsdGVkX1+wLNdyIipZ+hDxgEM9HRAp06TYOrfabx+hER5KlnpUqQylwS87ukSYWiQjhjpxjaim+HhUCV7QPaatiCd67A/2xyDyiWoGu7wzlSfEMk9URgRWdHB4dziwSV5p0gX1UTioHF1LTDWZlMsReecmS2IyqaxXwOPcIDlqSV511BxA0mQL8VwBLiZCgmB6NtRtLURG8/hLwsQujiHTjm7d7F/VZjbT7SURxgZgiT1H5Kc9dN9j+N4PixoMGsYoKYhysb5NKeF4ULYFC6fDfVbinYefhoBinUYl4zb5FjQm33cW5WjFXvueQAkTj6n4kFC8CjlSmZD+EbY624BZ8IPQzrIrsguHCMpCEO0Lbv8sa7f59NtihocdCYkaBemP+uFA+4Rw2di66eZzEF9lt9cfp8tT94hKrO3QRv1+3zB6eCVJY3fTqwXd8Z/SwqLsfR95V2XPfM0dKihaBR+Wyo5UIyb+T7DEn5lbaEEMPhTpXdzuVFjIkiqxb7g34Locq3GFJfHZBcGDmhwwBaGhwZNctJaVvEPWc5xSjqc2+T+Y8vN7gWH3q3t+uHg2gCZuceAeiIfJLu10r85UZEIz/wx8XUxvdNKsnorHzhetMwg+jANrI7fsk5vTwzFXgyPu7eIGrX8CVJH5crzklQTvverUeMJINAhEXn8o4k654+7Dy/GjWUHfajjz+vnoeorvnKkBLx89Fh84zqzp7LLGGncMWX1DaM9s9VryBXtWgUiRwy+cl2OXIZBl54p2W4eD4d/pkvSMiC74OsdsYH1aSQ1EKQskXw0I9yuxtra6DhxKuqyjwvFvM5XQ02med/0IoiY/soiEAoSjMBN+1l5aRvpvSNvFwGDXV+W/B6FRpnMtRlbXUNfzgwslUR7Qfx4KTQ14OET6fFp7bM+00PdJZqhW5gTEZnVLXS1EkVQiJSS4lxllamZ7CUM8GXTQ2tLQjYsKaAfHZONEbsR
 onyBTggg
 ayhkbPLpYCPvi1c6MnFLd3KBy9P0Lyx32CbqKO5d0snfAHamRF5FEX3rTnX71lXvVSO081Xukz+jHDr0jYEVJ7eZe7XuHsApsNgym2H+quRK8jrA/arZ0nEVYokaVSKl63e0eUbYahYauVRf8cx/ihvNpF2ysxBiDX0PuSJwga3HQw1SfpfZ0htjMqm3CsUpvhFCiB0K8n7txbkW/KDJOvOcOIggACM8GlTZsED0uCDczfpyJtjpyh6l+ccFvi7qTG4P5COzFngdW3G8TWrsxR3VUw1qLnR91CLzXyEJ/F55kLfRrb82vsTgi/ILtWyKodj0bz9/eUkikqxfjUk7Nip8zEsbYZwp6j8Y39FiE+qgNgNTHNedwZQ+mXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:37:25PM +0800, zhongjinji wrote:
> OOM killer is a mechanism that selects and kills processes when the system
> runs out of memory to reclaim resources and keep the system stable. But the
> oom victim cannot terminate on its own when it is frozen, even if the OOM
> victim task is thawed through __thaw_task(). This is because __thaw_task() can
> only thaw a single OOM victim thread, and cannot thaw the entire OOM victim
> process.
> 
> Also, freezing_slow_path() decides whether a task is an OOM victim by checking
> the task's TIF_MEMDIE flag. When a task is thawed, the freezer bypasses PM
> freezing and cgroup freezing states to thaw it. But TIF_MEMDIE is not a thread
> group shared flag, and only one thread is marked with TIF_MEMDIE. If other
> threads are thawed, they may still remain frozen due to PM freezing and cgroup
> freezing states.
> 
> To solve this, thaw_process() is introduced to thaw all threads of the victim,
> ensuring every thread in the victim process can be thawed. The freezer uses
> tsk_is_oom_victim() to determine whether a task is an OOM victim, because
> tsk->signal->oom_mm is data shared by all threads. This allows all victim threads
> to rely on it to be thawed.
> 
> This change will thaw the entire victim process when OOM occurs,
> ensuring that the oom victim can terminate on its own.
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

