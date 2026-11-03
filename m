Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C28F606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZlVsRUzz
Received: by kanga.kvack.org (Postfix)
	id 63C206B00EF; Tue,  3 Nov 2026 10:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613AE6B05B4; Tue,  3 Nov 2026 10:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550D36B05B8; Tue,  3 Nov 2026 10:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 347346B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:35:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC99916043F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:35:48 +0000 (UTC)
X-FDA: 85394207976.06.61F9F44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5EC7220005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:35:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlVsRUzz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793720147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6wyycITGM5Nn6DuWAdjmdZN88p+e9N8YZxCzAqrnCY=;
	b=jWM9BSHD3hwroxtrceFtr5P55egKDjVgciA5Or1sFlB3MBooB2sxy97TvU6oVFqiSjluKz
	U19+a77otei3UsKXaMWkMmLl3MD8r/zPjRXB8AKEXlOgBtjlzEQIJe75ggsAQX7AsahkMJ
	gQt7IFFKAwf2cNzprDygzO5Izk3hTto=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlVsRUzz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793720147;
	b=KggAhn1RZGGO0VXpuP3hStkZDixOIpRmLIVr461JpeA7vYIkX++UI3495TeKF9U8eRDsi/
	tiFc1MIVekHbOSuv7lcNX3UPu3pEZDQoGR7LB/5E+3XLmJlOv2XhOCzYpjrMvdfdkujeiC
	oCTt5+is7+KF+NjnuR3i+QxsjYTgCvI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1F5D609F0;
	Tue,  3 Nov 2026 15:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C771F00919;
	Tue,  3 Nov 2026 15:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793720146;
	bh=t6wyycITGM5Nn6DuWAdjmdZN88p+e9N8YZxCzAqrnCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZlVsRUzzXc7EhIVSSpAnEcekuGlj9t5O2vlBUWsfHUu3XCRlARdmuZjj9KUBDFt8C
	 4D9qpQB10CES9LdTJ0f/T3kOm0jh3WlscidBhQWW5At79k3YmpNBPPRDbanvom15dO
	 Sg03W2POIYjbFNdXUBdp920OCQPnA3dIveJQ68MdkGEZ1ptII4Ze5MBY7ztAEbaeZg
	 ZqHje8q4OAPZ8g4IDtlm1s8C+d1XaKio9YNLVLoyAVDYiJhBxkQYoM31fSZn7QS3pa
	 ygnd4/m45Sb8T+ILFW3t9XfFQ2yADvtQ45d9BYrzHGHFOGcB4jR0mwvH5TF35eoWmq
	 6/EUy3FR67Yxg==
Date: Tue, 03 Nov 2026 05:35:45 -1000
Message-ID: <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, ziy@nvidia.com, joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave controls
In-Reply-To: <20261103122816.48037-1-lizhe.67@bytedance.com>
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5EC7220005
X-Stat-Signature: 1ihjq4zzmyxsiypa6ydtod6ad8kn7m4z
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793720148-56458
X-HE-Meta: U2FsdGVkX1+NJhkIkVY91IsiZhrIVaOv9WyyVIJPAlU8NIPjeEp0P8WiSJvAgu2LDRIkcH0cKQpCBvRFRjZdY1lI4igRwJebjS+FqyjxXf6UzGQHCmB9XguShT4kiMEf3G8efKjmHd/JiXjL2aeD8YhohU+AWLkr/s0ikMh1vIPyncAzwdcK/j5FW0cEK4R+hq9BJTjdM4k5SudA4lCe+1tHGetmA66jWhup+7B48PZKgWYqOredy1mcR5CSfvV8RO/+LukPfgsKR8nMNKZuedGxGP8L0yosKooV5Lb+vy1qWeGqVhZMbkPRfUOgCvJR1vdkBznif/nhY/3ZRxjAaaQnymxs0v5q9SJR/dwVUPLoZ7R5cN1UVt5gE9aRel+EkFs7T8pgWYkGXz5mDC6VzYYrxLFnw5HcRFLrF6W+ufWyPNnljuZGUJKNAYW9xUEKHtue4GcWtjVxOCjCi5w2IjBlSczkYx1mfH51iEUddOu//GTvp9xT1cTSMo21X/3qhh7KkL2kYIi1L5FxstGFhc3Q7AuCb8N4jummBC5zuYk6IXdW7i7t/pLAbiXuq2hN7imD5s1G0JYXbeiXctUKuRQJp3duZ8FBegEKEaDK22NhoACfh58sgtChSg/Swi+Ldrcffxfc2CfA5CzmfOPML9mghO7LT/i5hvTmMAoVKOKq+7uAwq/Cc1ARUsFkbC3oV6JqgOn3Rv111t+RLZRNERgWvmBKe/Za2dsrJW/ivr0d3xEju/v/XO4JwJSgaGxXl7xVPnLWihBeqONFnIqPOSCpq8ZbtoSxMaxq6gi/Hjwjfz+Tb975hXuTuBBwkG0ASAI4e0qz6NuKPi4/oRClCaYb7RxiC735/G1SNQGN9ClrowRWHPjug1ysShlu9QAznZo6u8yuvYp1gHbTz/LhfQXcMDVit4iD1sDfOP8DotGFWw56vDaYCDigmbmUTyOTMZ/fGs8G1FtcbfvprFG
 uJI+Quiq
 aSeVPIzPNru+ybYBqUZT+8lnQ2LLztRHcEFEZ7waWKX+tvnRHIE43uwlkdTluIduraI5Q3P35puWw2vAlG5NlKP7SJRZJKCZYgHai+819/0epVEBhHONiuCU8ygplPlpkS80Q32xOj7KAj81kfn8LNyJLx/lwNH2g02AyaPng2PdA8E47qDKIkd2V9NVeifbqDl+pZaB8uiHLTARLuxmNywsyLNfmkmqtmAQgHF/Gs66m9vQ6J5BGTEoOgVHXD/GREzy67jSEL6dY1R8ND1ovisR15bNZD/5D5738/oaNAkW/agalZREHLlJ9CQEoprzuMp0Ph09ka7HESo8bkuagx/mhcaWC5BwLK/2C0vnTjY5pQMAfwz6JpwJEyLr0ORQ/GlntD50gA8HuqOVqut8RyHPtzObRKbaEhVJG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Zhe.

On Tue, Nov 03, 2026 at 08:28:13PM +0800, Li Zhe wrote:
> MPOL_WEIGHTED_INTERLEAVE currently has one system-wide weight table,
> configured through sysfs or auto-derived from node bandwidth. This series
> adds an optional BPF control plane that lets privileged BPF syscall
> programs install manual weighted-interleave overrides for individual
> cgroups.
...

I don't think this has much to do with cgroups. Weighted interleave is
already a per-thread/per-VMA policy chosen through set_mempolicy() and
mbind(), and the weights are parameters of that policy. I think this
should be tied to the memory policy instead. This is different from
the per-cgroup NUMA balancing kfuncs. NUMA balancing has no per-task
opt-in and acts on memory with no task context.

Gregory Price's mempolicy2 series already proposed set_mempolicy2() and
mbind2() with task-local weights:

  https://lore.kernel.org/all/20240103224209.2541-1-gregory.price@memverge.com/

Thanks.

--
tejun

