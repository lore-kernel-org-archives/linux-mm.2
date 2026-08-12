Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7765C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCABF6B00CC; Wed, 12 Aug 2026 04:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B628F6B00CD; Wed, 12 Aug 2026 04:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2326B00CE; Wed, 12 Aug 2026 04:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8057D6B00CC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:39:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB4D2120345
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:39:15 +0000 (UTC)
X-FDA: 85091967870.29.E4CA17B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0CCC2A0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:39:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MsaETShT;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786523954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkut8W6a7GS81CX+/TuyP2Zn6pMmw7lKPghhlR/MKpM=;
	b=gHvei8mhXDwSVORemAn6h4icWvU68rsLa/Pu/AP3jnxHgFXrcUOPCfn20dpu+jrCXGxTwy
	PCpXKBvBmoZkxR73CxHkvgi5/hOK9pOFQpIh7LbkKPiZpgviQGkngnW0lw+ymtnN+OO6wp
	2vd1ORwQfMrs7xwgDLcHQ8jLQpQ3sJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786523954;
	b=ghdidC49en96If4XwqshhCVBvQGVTL2CbA3pU++DradRr2oBvXYPf4fx2kmLR9KOP43Yu6
	vfzMdm+Zp/T12KXc/NM26s2ugRhzQLarBAqAV+fMn8qscUhmG5eT+Qyohnh3tk8Ne1uNwE
	6xG18HQgodxNL4SOMMycznz7lSKSgCM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MsaETShT;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F0321596;
	Wed, 12 Aug 2026 01:39:09 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5A9F3F86F;
	Wed, 12 Aug 2026 01:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786523953; bh=JpTcVyoA8oYbiqkWi/Wud7zkoSe0bDVKYAKa9IRJ5SY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MsaETShT/3KkE1CiAfvTprgrDPb/6GingNr4Q0sP5vJZQPYaLO9tWymZLMaA8k4Ld
	 cEbj2tTnEeL9Dp2oAMySwbSHkHvcJ9uPG6StJaXzaLafd4mDxAk36mwa2BfxY4M7jf
	 AZy8MsmE+vJMbjy7xvlzbbmuf8oi/Xw61LyLEGyE=
Date: Wed, 12 Aug 2026 09:39:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, paulmck@kernel.org,
	puranjay@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <anwxLa94aV5IZWPc@arm.com>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
X-Rspam-User: 
X-Stat-Signature: fgdmpxmhqwfzqj1fuu4ndy6bz5tgqne3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CCC2A0002
X-HE-Tag: 1786523953-708481
X-HE-Meta: U2FsdGVkX189CzzZZxNbOdMhoqGgpNaToECLnoZOfjzkcqpNqcXyJKjpH6r06wBZjhB7eaZSMAqZffwAWpQOADuW4KdXXLIfXH930beTGehc9V0dds27aIgvWKU/oAL/XylWoV9Z7WIGo45slgU+BzDw4By62lWyFMxXm3xcqfDVtHXZMVQOAUVdCjw6QWvT77OSkeL8ENF5pA8t99JM92wbyL5cXoHvziyyai0qDK4q8965KBXSyIpNz0ELPebjlXuLi+ulDrfJzUNpq7kco+pJ+O9cIoAoyUcJbLGaWyUMBj+QfwIQC5RouBD+stXFU5LFFeiFGY93wtRvkRK6Pqfwkub4z5YlMPatm7G/ivlcGU9lT43DA7o92/XqYs4S3s30PYVsPijww7JfAly4/yqOonuIwK6OyywWu4KItgcMyY35jMYtMCNcdK/6lRfP0OzrpAyPtVBw0yGxMRHCnIC9B4QTg0gQMp3XdqtPhPYIRXJw3wZK9gQPmYT0mJ3pWdN3GilxElkMR3fGwiI9glqEHJA95C2JrqMJosCl6PwLiHn8Ls52UBmLd+gSFX+S34H1gZ2SGP0MJmDaoxpo+oKAp4YccKF95M7ukzdVQCacSrSzVN5H6AvIzSHnQtbMBbghvlwY4qw/Bq5bSjwjBC6eXTLYIzJ1mJ7WpDfYqJvQbTzKAnoaofTeOyg8uUdweBeNedtRYFIwtrWx4EWcHuIZli+YzAgkF3lfzXUDBmyKBZVmAd+ZsUJUWa4pEek10ssl49s7hM5lNEUGWXW9Qt2cZYtYL2iV3oQDB1Z2zdQODfbUlUL+ZI4iXqYz0b23aSwgUkUK9Z6oTcI/Nj4jBaq6sTCyiwtGk6/05ZxAXsuvpwXnFUPmOpIU058CRE7mHq2chHz7PI7O0mdp+xF7IOD1FctCjc0PSf4dNxj9FfU8kGrMlB3Dj1drkrcbvkVCqjVQ3rfMJqIau3ebkFE
 3EN6Yfh9
 /HQQmd2LQV1XCWuN+v56zW6Lqv/KQO7xDFOm8S6uZikZUNZY91bapwHjFLkDBesed9DjzaY/gFVUfhydVHvswxWFl5/we7kAMg736+S8XUuDw+jILcHqAbrjvLqMhNu728O/XqQZRX2Gcgk4W7Pkmouk7bhdA2msm/9dtFj5tC6IZNEWU0c1IC/DNJ6cO1LAB8ZZGbrPLYmtY71cjDG4yhjDhFhENy5wVdTgQPYpNu9aYNMRIMD9qBK5yfL85/piQEs9F/ck+/oqHMLLNlGPN2VrnWRohlB/78tINlCCNlu3o5y17QrsEjaelyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 06:23:45AM -0700, Breno Leitao wrote:
> kmemleak_scan() can run for ages on large debug kernels. It was
> causing some soft-lockups which I got fixed with commit
> 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> stacks") with our beloved cond_resched().
> 
> I've got the fix above deployed in the Meta fleet, and now I am seeing:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
>      scan_block
>      scan_gray_list
>      kmemleak_scan
> 
> and, worse, blocks the callers waiting on that grace period. Here a BPF
> struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> call_rcu_tasks), is stuck long enough to also trip the hung task check:
> 
>   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
>      __wait_rcu_gp
>      bpf_struct_ops_map_free
> 
> Then I've learned that cond_resched() is not an RCU-tasks quiescent
> state, so, we need to use stronger primitives.
> 
> Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> reports an RCU-tasks quiescent state as it proceeds.
> 
> Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> quiescent state for task rcu").
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

In case Andrew still need a tag:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

