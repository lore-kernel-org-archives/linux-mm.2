Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E68CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7A26B0006; Thu,  4 Sep 2025 19:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF606B0007; Thu,  4 Sep 2025 19:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC956B0008; Thu,  4 Sep 2025 19:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AEC426B0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:46:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B56D14045C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:46:40 +0000 (UTC)
X-FDA: 83853204960.19.A4AF088
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62FF914000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:46:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X5wfDxtI;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757029598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqKck8IQZ46DJR+L/eLjx5QE/TgVdwPRfFBH26lKqMc=;
	b=ndjQNuLJypIMXijy759FnpWARnviusAzRODhHOalcRPePzbUCYFRH9+DKjM00eh4zi7LFq
	O2IrwhZ8VpO0I4Ffs3EsiVym8TkWoQ+vFuUxGqhxAX3Pp9aeLco3Z7rEwSF2X/GBY7vXAA
	++hlUvVbqjXzp1BtKwwiZmvGYbeuGSk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X5wfDxtI;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757029598; a=rsa-sha256;
	cv=none;
	b=dYIjoAACaDHRsZnyxaluwHrHIRQGAk+e63KoatyUxBqcEK29qxs+j+XGbZRCabYjJjdEga
	FwdGRMpU84VO1N+NOFQoQxVw+sfaDpgwN3L7Nr9ynbpYROT/QttMyYaw6U+7SWCSpKoxXJ
	V6DG/HyGOV5JY8MMlWTfz2Bu6lk7qNQ=
Date: Thu, 4 Sep 2025 16:46:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757029595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqKck8IQZ46DJR+L/eLjx5QE/TgVdwPRfFBH26lKqMc=;
	b=X5wfDxtIPe8XZ/0otmvcEduLlN05p6d+h7kq7MPzhgDXrQDzKZ/Zo1iYJeOnYir4OZY8kM
	ldZWNSAgetrt8ig0GX954UkxcdtONpQERHHgqH1Qz3vWLi69NLSnaP1POE8A6NarLbQ2E6
	+ZuGL0XjaJrGinUNYBPSCU+Y0DPSMQM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Stanislav Fort <stanislav.fort@aisle.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, stable@vger.kernel.org, 
	Stanislav Fort <disclosure@aisle.com>
Subject: Re: [PATCH] mm/memcg: v1: account event registrations and drop
 world-writable cgroup.event_control
Message-ID: <sa4mytppu6dfpquytx6jwdvak7bkyruztnr27vibbzhux2rjsl@pnrxdi5ecua3>
References: <20250904181248.5527-1-disclosure@aisle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904181248.5527-1-disclosure@aisle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 62FF914000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: m73m5dsygtzg576ahhunwqnmbhg7f3ad
X-HE-Tag: 1757029598-780939
X-HE-Meta: U2FsdGVkX1/0O6bTUXlUmPq6PGLpX5NLsVqp9S9Lvn6Qtb5WMDDSbX+uZDoP62sSp8fITxxRFOPETUKl/C9P/qrjx4Z70piDzyjAsr+k3eY1Ru+komtXnrmSO8bQolbbjKLNwnQZwdhfvmcvf+UZuAV4uaWCQZKbW5NzQzGnIDDVwZOxfy5BzqOkRYWw98YcjBcTQTDbfE5AF3cEnn9x3W0NN3K4ZVHJlb9xwPLWbBTBReEOcxa8wpn3f2M0m25yua6r/C408WwG9Y2TVyi920BNUNUCD2h+VT+yfhc2XhIqQVwhNZxY/jnBcduEgX7fuhoU08fUn+VhPqaG9Ati6bObfiWfBPVSGTcPmSLmo8bey8X4FjcII+JWXOi/6FSS87are/pbVs1jIzLJx+HvKyJO2x6VqnQqHt19g6GpDmjPTOVtV0OykU3wAuiw5wot/7Xi+ndeXAfCCQDU/eXCe9Vauc3Q4ddYepAGd+JMOHk1BmhzVWGO64/ikPMGBH+4bW2+ZAVZEPpBKURPfsVXyMdwR4XfRP5U9dMM8q7fOvpOcbfGOykq8JFD0CsBDzsjcXZgw2PQPi4uRVQFx3JJzrrCzYISQRel5nxOak/uwy3XyZRjg1+jsI58QPHPcw4jE0GuV/34PaaDWZYbouo6r1W8ulP2Tpguc/tpcoIF02r1EwgQdhzYQcj5LgNxsIYzaGFafWrZNAyu2wORXKKVbViZJyo0AGHer/c5D96inj8rrC/1OhJ9rXlARzEnMFrITfsXDppHkcyl/15OtGW/PZR3fPceCXulGO+ouE88a0lmRArHa1u0dIYZFqnF51HDmp6eOpV28//nyYLDQFpMcYTYFLXU3ef5P2BfehxYFpT2OPzGuN3+TFCQj9GcY2BK2jCUQy90vunDuPoggiWCjR5nxGLuJZvuxBu8QB856VldsD5ERohqJlj+eGCVHINWUh0zEQQqCasIZhyTUy3
 53gmJKU5
 0ZJjequCT9AQBbposEUUNyFrB1KgG26TlHDG8ObydtUUhexqg64m9fK6Y1QGlDJ2IivLNkoocp38yvXjO3pKKM5HE1tO3YG4wIqRuIo+k4jFzrOvu+tTsm7zgKR31sxMRRG/RdzqAOFpcKK2FD6wGOQHsMtAGRQXqGPKkzs5zt1ITwDkaAKnceD2OwPgSdS1kt13cM5pyGtLKo8u9aFURSAQQ5emzGnjWTdxA5f51o9/LfWwb1MyzEL0FW4upQnDb8365lPQxeQuDBGFZsB7J99xwjOSysbxd+NNeJ6SuAUDD6gsQuXuloSDa+T7ArRCgDwPYfIxzJvu6jQFyUjVW0zkDvXY5gm9nooJ6qv1QEWOGE1PidJfcfZullz86RpqKTpJmIMChSIvi3ytwuU+J0av7/1SWGggQgUzu7MeoGSE5Wkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 09:12:48PM +0300, Stanislav Fort wrote:
> In cgroup v1, the legacy cgroup.event_control file is world-writable and allows unprivileged users to register unbounded events and thresholds. Each registration allocates kernel memory without capping or memcg charging, which can be abused to exhaust kernel memory in affected configurations.
> 
> Make the following minimal changes:
> - Account allocations with __GFP_ACCOUNT in event and threshold registration.
> - Remove CFTYPE_WORLD_WRITABLE from cgroup.event_control to make it owner-writable.
> 
> This does not affect cgroup v2. Allocations are still subject to kmem accounting being enabled, but this reduces unbounded global growth.
> 
> Reported-by: Stanislav Fort <disclosure@aisle.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislav Fort <disclosure@aisle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

