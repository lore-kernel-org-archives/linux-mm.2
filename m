Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDD4C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9F26B0092; Wed,  9 Sep 2026 14:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B126B0093; Wed,  9 Sep 2026 14:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A536B0095; Wed,  9 Sep 2026 14:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 276AB6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:18:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6612CA0309
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:18:11 +0000 (UTC)
X-FDA: 85195033182.17.630C5BF
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8894F18000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:18:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hdjrczZf;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788977889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kQrjWDVP8VToFUSa5vLPEZUGkwzjIEup3NeNcSxnh0=;
	b=wlje+vbyi8pIHHQd9t9kCDl3eA6JhVAqjS9tr8I5k27OXblkx6yK31GYp30H850M86daEZ
	HAqOJm9PKXc12bXblOQW9VV3JgLhlTY5noKn1NPTutNZs1NNi1ENZPhD+8xpQQww2PfMsw
	z1wQjON7ENPeRPC1ghAB04+KFyKWgh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788977889;
	b=tO0vLz/J992MiJcoFH75AYEWB96t5aVBzRRP5EfZdHztmoLFG3SK/gGU6O77Of9OObQNJJ
	hKLPTMbhD5y/fe9XQZdOls0h7z0iq+8AV8AS6+S6tjGtlAuVs+qQowjGuJIULyWJ6cIkvt
	wrZ2KM5GqwiTL47/7hWCyo7jkbl8ioU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hdjrczZf;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=a5KoTsru4QeX3ourrXoG/HiW8Ls4AkpUlsNfQy7SGEw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788977884; v=1; x=1789582684;
 b=hdjrczZfkw2I5j0slrseLFrL0HLbRNdtQMFQrsNdzs1bYi1PYj8Tjts37DA6V9VJp7HsbDBE
 gqTGEV5KgS4kurpr3VBG0GruXhEvKyTmyOTlL/SjpO7Lybk0tvVNiNmK9wY329ZL5cjWMmleOqu
 7L1Y0TMcv1+gqiBUoDXBAtLc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7a7c3fb00e682847;
	Wed, 09 Sep 2026 18:17:54 +0000
X-Mizu-Trace-ID: 7a7c3fb00e682847
X-Migadu-Flow: FLOW_OUT
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Jan Kara <jack@suse.cz>,  Tejun Heo <tj@kernel.org>,
  Dennis Zhou <dennis@kernel.org>,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  bpf@vger.kernel.org,  stable@vger.kernel.org
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
In-Reply-To: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
	(Josef Bacik's message of "Wed, 09 Sep 2026 18:01:07 +0000")
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
User-Agent: mu4e 1.12.15; emacs 30.2
Date: Wed, 09 Sep 2026 18:17:45 +0000
Message-ID: <7ia4ik4ep9va.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8894F18000C
X-Stat-Signature: dxa5uf9cumr67pkoqrbk9bm1acixa15h
X-Rspam-User: 
X-HE-Tag: 1788977887-405378
X-HE-Meta: U2FsdGVkX1/y/5KRphk9kq0qQ6/Q3TpHrj8DVXHMe5ezW1W1ojturVc4leIf8ZmIb/9qcMDrMRQv1dxXDRDgQRpWBi6jSEUG2TIN06FnzSpkyfnXCyNYKu+M9ehOK+dKnwa4fNtFItvLTLDIRssabsiv0M6wDOOaFkp+jx0BAdpEDhR1WddJc9QoycW1Y9NEvs4WWAb23AmmDmWQQlY9ZbvU+bMJO2emodYZWk0/bqFq3UMrG8hzAm5rlPMeGvbOPwlY/0KAlDDNqz98jyl0GEMoVvg/4F6Sw82+qjMiaCr0kiCJP/p/UTK39m03Yl4rcHkvuWBaJAGSvrNQbqN1eZjyNXvIKUqHOax6f6sKgwKJfCDPZYWfWqN9OmD1dVQ9gAxtNePtiL6gN/Zm8uKhuu4F+vlgDMe4ZrXIhh3hA44VDh7zuTqInXRT99M/2kBrAHzrgR7eR4vtEA7GC45MIs9lNsKdoFNiUaOzHgTkb1jDs3wspi4K/4Ll5uTktpL3FgFROBFuLjzTrgyYxLkG7obXCConYqET+qXd01/hYU7PMTLnpAn5UeKpoMURxAakGBMtRyVZTfGKh65foLAKQQ8AyPrSz2PmAMBoq4vvUi/cp1BrwTHzAv+0E48yrUwBG3+YARcoE//K3G+DFykgkaI1g2anTbxmllh1cdJHDn/PEciqREBKCll5fEgJNlzPdZ6WoB0yD7euUXjT0t1Zn6U/8VVF04U3REZZTmZojfus7Rpw7Vw4l3oNMtYIr+dPlnT8fnKE6N02hMzFcoCwx+X4du8c2H2NFaVQQwsO1AByJaGTUXzV/DNDbECRG5s0jbvhwUCg0HTg+t/JpIRSUbJ6fu7VdLnW0R/0NFX2AXiprj8Gv1Ynz7L84u1zfK/WxJ8QkS1y1NoL0LRItVavYV40SPo49Rr9FqRgmEKX7e2VLHMe86shP4gt5/Tq6p91GR39TYsWh6UGUxcWU6V
 m6grww9W
 pIogpMgqYcmJIKg6n5e1yCTTlHnE7lIlSBAd2IMgOBZPSi00X6tIlTcY6fu8pmSvxRKYzOXhL2EoF7klVC6WY5yJl8a3wnX0pIPKdDnp9a+DUmR2uoeeYg6t0Q+FfEch4tDBPINw4hAL8IbG8hzP1eIoY1kZeNyf01VkzI5iK+WcEPXeIHvEDmqqoPTOm3uNgznKAS6BQT4T5cloMDmFJna1itTaLdwSGW4Dj9K3yu9jXSxd/v7r5qICe8VV1nMR0A5D5vv+V7bRpuJePbgnbksP49A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Josef Bacik <josef@toxicpanda.com> writes:

> cleanup_offline_cgwbs_workfn() drains a dying cgwb by calling
> cleanup_offline_cgwb() until it returns false, with a cond_resched()
> between passes.  On a CONFIG_PREEMPTION kernel that cond_resched() does
> nothing: _cond_resched() is a plain "return 0", and under
> PREEMPT_DYNAMIC the full and lazy modes disable it.  Since commit
> 7dadeaa6e851 ("sched: Further restrict the preemption modes") those are
> the only two models on the architectures with PREEMPT_LAZY support,
> arm64 and x86 among them, so the drain loop never reports a Tasks-RCU
> quiescent state.
>
> A worker draining a cgwb with millions of attached inodes runs for
> minutes.  On a 6.18 arm64 host in lazy mode the cgwb worker drained one
> dying cgroup's writeback domain for over 11 minutes.  A BPF program
> unlink (bpf_trampoline_unlink_prog -> bpf_trampoline_update ->
> unregister_ftrace_direct -> ftrace_shutdown -> synchronize_rcu_tasks())
> waited on that grace period while holding the trampoline mutex, 42
> tasks queued behind it in D state, and the hung task detector fired at
> 614 s and panicked the host.  Any BPF or ftrace detach during a long
> drain inherits the drain's length.
>
> Fix this by calling cond_resched_tasks_rcu_qs() so we do not stall out
> anybody who calls sycnrhonize_rcu_tasks().  We put this in a do { } while
> loop because if we have many small cgroups cleanup_offline_cgwb() will
> return false and we will never call cond_resched_tasks_rcu_qs(), creating
> the same problem.
>
> Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  mm/backing-dev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index cecbcf9060a6..18e999053bae 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -910,8 +910,9 @@ static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
>  			continue;
>  
>  		spin_unlock_irq(&cgwb_lock);
> -		while (cleanup_offline_cgwb(wb))
> -			cond_resched();
> +		do {
> +			cond_resched_tasks_rcu_qs();
> +		} while (cleanup_offline_cgwb(wb));

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

