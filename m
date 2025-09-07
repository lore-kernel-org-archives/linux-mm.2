Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8C2CAC581
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 13:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D8E6B0007; Sun,  7 Sep 2025 09:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A74E6B0008; Sun,  7 Sep 2025 09:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196226B000C; Sun,  7 Sep 2025 09:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2A4C6B0007
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 09:10:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BD54C07C3
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 13:10:09 +0000 (UTC)
X-FDA: 83862487338.11.D07F30D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id ACDA1180016
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 13:10:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Dph8UJdu;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757250607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCf/09hbO3/u9NIARQ4ZWX+4z9C2FHl4gqp8E/FB2K4=;
	b=NQkV9A5s5dnUKWK6jm0GNKs/7lHok37As5qvd85PcUIm56zaNCIIHZAZ4GDb5J0IcKoA24
	3Q7U6fb/WjbZ9hfaUavjucaqzITKFmfxF3IGKC+BryNPTp74eZVyJZ/1hSTE5jwZYzf9oo
	SY0THn/LhLSMmJHzA0zPhjkHUehw8zg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Dph8UJdu;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757250607; a=rsa-sha256;
	cv=none;
	b=SrOhiwAd+d03Q6mYO1jFPYJssTiPAowdMEBEMhIDFw8BgrPhWsdzq7BstJiU46VWimMZrx
	0ZnjcBJyx//fCjMYo9jJF0QWOtabjK8rMEkURFDa5HPxYbZaKEHxqKVAUKhK8rLqMhCdRR
	XwqlJRXQ7Houdn908zBKVzS5c6a6gUA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ED7441A48;
	Sun,  7 Sep 2025 13:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E05C4CEF0;
	Sun,  7 Sep 2025 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757250606;
	bh=hzoFaHAIdZp2haJZbagmxAgkiZGTROGPUGuinQ8WjrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dph8UJduGjbCAOusaVKDWVM0Nbup/WEtW2XPVYZyxABS6fnmFsoMr73WpsXRlussQ
	 HxY2rKJit6AUd3+Osf46yikDJKhoOHijn52a49QXH1e9jJEph4b5+zVKg0QsAfKqPL
	 RHEp+t/rxhvcm/EDfDvWIWH0yMtLyIW/lra9m5iQ=
Date: Sun, 7 Sep 2025 15:10:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Guerrero <ajgja@amazon.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
	vdavydov.dev@gmail.com, akpm@linux-foundation.org,
	shakeelb@google.com, guro@fb.com, gunnarku@amazon.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: fix memcg accounting during cpu hotplug
Message-ID: <2025090735-glade-paralegal-cdd1@gregkh>
References: <20250906032108.30539-1-ajgja@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250906032108.30539-1-ajgja@amazon.com>
X-Stat-Signature: hzgpwpjk1ot45i8mzt3ohofrnroaimhp
X-Rspam-User: 
X-Rspamd-Queue-Id: ACDA1180016
X-Rspamd-Server: rspam05
X-HE-Tag: 1757250607-210732
X-HE-Meta: U2FsdGVkX1+ifzHvfeaDlg1LpPxiOeQgttaFb/0uUor02DH3wIoxAVflYwhKgMQTLAcJX01bsSZ8Ahfu/1OLEA2kgiuBu962gPkgGX2BTWqGG54qkfw83LN04GRwA+KYdoWXl1UXbufvYRrXGtFDPb1amh87gRwIuEfEegIQhEyOYRt5c0bJk4V9zAVm3hbjGHMcaCf8bCdRLBxVVwI66GJoLuQizNdbYj0GulAWQy8rb1TYL26EpASzAjMhWB4Fjx3tpJt4NAuyDrvJBd8az+qK7wvCG3fg+Lka4VNUtXbKr1qQBaEbb/Al8q/B8OeuKxCfBHGbJNzi5MYMqTQSZZWB+NBA3kiM5WOnsocsCFU1iDQimxCW2txnaS7OVkF/drLygfdqhyooU8tzBmuCE7gnUopPbp62QUsIXU8n+LeJPIYNtVzzeXzRxXLsIlHrCIpQULT3mAdWGYRoyFQQnwm4Phlq84sdoPARG9wolNgsx4QRWP0mk1N5BGr7psP4/605kBUVoymi/+hKstn8NSxoO2YewpngexlYkjIvT/M0MKPuav+KdBvfF72TYP02petDXUDKhOuwCWmlWM9AoJ3Lxd8YjggOkgE8OM7GS7LYtadEo6TfgSmu3xl2ZuIEdOSWJaExGyTuWh97KkWtc6Llu7FJUGac/Y9JJ8EPvWmI7/yZ42EBsV6dDZ3TGZj/T7nm+sNMjCLMULOuAxoDGwv18H4H0U4OEnbZK4R83ZomwBAt8ipwH9atB+f6bEUDk2VXjOYX3/h6eqQqgEdNW8w0w+ZxaXzFhscp9SQCB9l2YL8I7QEaU6hJExnNNQF0qnNezReV7MbMUopmB8hxpI4oDUTk2AQGPLZj4CFx6vpzWlfNtpc8ZqeoFu8jPh5ATv4dd8MAxzaKskyDrr3Y1KRBmanI1SsWV3VMca3SFuZeJniDv6DtuokqVIN/+NjPW8CxGbl2zETEWj9Rj9r
 HKUxj8MO
 EnhZsgW2g4Oh/H/WbwmdoIOZaG3l/9XQ0Fz0KLMmUzWgxNvI5Y3rX4Op2ccqTsU0gl00ONxwvlr9TFYrBWsaOVCzXsXkE9j9t/zjEvnWsJzG87cRWzfAktvEnXZVleHkQKTt2RyfNMN1Jf0uMLi4ndPQb1sRwyX+XnX2luhnRMmD3eQMznqWqQ97naf9b8jYof/bQ6dou1KKNWxvDJ49Be5/f62/infdLsiMO0hoS6VyVeQN6tI1iiv/p6pm8rIU7czArMU/+mBFvg1cY3JhF6bNE0jHy90ytsoL6CpCTGP3jVUQdcJwoKHGJr9FFdsdpTD5Fu/Ascbu9i2HNrNVVW5HUOjLkVkBOZx/7ahOAs//RXi5BVO7QFYVhmP0wIyDUy9s/Ht2/j48uZBOtk6vavX3JFYR2b5rBjNBW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 06, 2025 at 03:21:08AM +0000, Andrew Guerrero wrote:
> A filesystem writeback performance issue was discovered by repeatedly
> running CPU hotplug operations while a process in a cgroup with memory
> and io controllers enabled wrote to an ext4 file in a loop.
> 
> When a CPU is offlined, the memcg_hotplug_cpu_dead() callback function
> flushes per-cpu vmstats counters. However, instead of applying a per-cpu
> counter once to each cgroup in the heirarchy, the per-cpu counter is
> applied repeatedly just to the nested cgroup. Under certain conditions,
> the per-cpu NR_FILE_DIRTY counter is routinely positive during hotplug
> events and the dirty file count artifically inflates. Once the dirty
> file count grows past the dirty_freerun_ceiling(), balance_dirty_pages()
> starts a backgroup writeback each time a file page is marked dirty
> within the nested cgroup.
> 
> This change fixes memcg_hotplug_cpu_dead() so that the per-cpu vmstats
> and vmevents counters are applied once to each cgroup in the heirarchy,
> similar to __mod_memcg_state() and __count_memcg_events().
> 
> Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty")
> Signed-off-by: Andrew Guerrero <ajgja@amazon.com>
> Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
> ---
> Hey all,
> 
> This patch is intended for the 5.10 longterm release branch. It will not apply
> cleanly to mainline and is inadvertantly fixed by a larger series of changes in 
> later release branches:
> a3d4c05a4474 ("mm: memcontrol: fix cpuhotplug statistics flushing").

Why can't we take those instead?

> In 5.15, the counter flushing code is completely removed. This may be another
> viable option here too, though it's a larger change.

If it's not needed anymore, why not just remove it with the upstream
commits as well?

thanks,

greg k-h

