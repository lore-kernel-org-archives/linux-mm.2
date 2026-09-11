Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED33C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2829F6B009E; Fri, 11 Sep 2026 11:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233EB6B009F; Fri, 11 Sep 2026 11:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14ABF6B00A0; Fri, 11 Sep 2026 11:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEB8F6B009E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:00:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 229C01C00A9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:00:14 +0000 (UTC)
X-FDA: 85201791948.19.4F16264
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5B164A0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:00:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dy8e5PD7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789138812;
	b=0TWPPiebNyGdn7ZjSBOy37iPTTm4lValwEE7sQhPGmMaeSrT/iBrC9BHRGfkJXwu6IWJxk
	kMXTiAyCdqdmZ/njgEJl+CbIL5S851tOTGh0SgjtDobO9D69owUjVTA/lEYbpFofwxK5iG
	j4a1j08ltlQ2sSbtf+qdidFYSFwFgRQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dy8e5PD7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789138812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwI1Hg5YAjW2rDMwPwYrAQxSLiZRPOJVWVCH8JKII60=;
	b=kImk7PcowwiFCIopxalNZ9XpUO4dzkdaoqNLrpbbMAN3i2p9B7vuFkClaLpmJb0PUpIeVr
	ibY282PmzeyDzK1xWFFDU1Ou22tMqxpHUjR3LO8pkgsesNqZicmGPUPJakwbIZU+Y+mrRN
	T5FXm/7J6mY/R9m4+9916LBuGYQNzSk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8348240091;
	Fri, 11 Sep 2026 15:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534911F000FF;
	Fri, 11 Sep 2026 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138811;
	bh=IwI1Hg5YAjW2rDMwPwYrAQxSLiZRPOJVWVCH8JKII60=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dy8e5PD7jr0IjrU9SvA6lmP88wpLBTpJ2VgJbE4UZ9E4t+WK3QtJFI8AwZbcp/bxY
	 QejuWzp1CfkQjKuJs18bQZcU7L5oyMShHWg9cToHK2Fu0Tl8pcGCdzrqAph6KODNkv
	 tMHevqRILk8QVJo8pnotb/wn45smu2oYd3L/yiiZTup/gCKM5yJViu1yQFSDodGNO/
	 jGKg8tRWxEAlZSGwCekSOUizy3bYW7Xka1+MUzP7YWbuU+/s6CNC8i135PgghyABAK
	 M2mr6Qj6Z5e5J3w18aae2AJr5c8tYUJY9VY31ARrLQOTrJsXwEtyci1BZayipkvXUN
	 nSr07x6yYKupA==
Message-ID: <0e419abb-71ce-4b97-b189-da86a4891920@kernel.org>
Date: Fri, 11 Sep 2026 17:00:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kselftest: mm: remove exclusion of building soft-dirty
 test in arm64
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org
References: <20260911125028.1268274-1-yeoreum.yun@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911125028.1268274-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B164A0008
X-Stat-Signature: 68upqyr6xpowa4jsrhmyf17g5s83gcu7
X-HE-Tag: 1789138812-625190
X-HE-Meta: U2FsdGVkX1+K516GWUoT0FJGOxKuKGYNAchzVk9T9tNiacmgXYFQ8aY5fbL0euZhNhq08cijRkHzrURDALKn8XEJTUAb4SJMQFDkm7PyyKeeH70E+ZYDoaM06TuuD2bEcDbL+rrKvxyTu+FoyuoDOH3I7m5gSElE3n2t/0wM8sP4QpWQllBZF0Bcp5nLxQhjtC1fyDFjim+GWT2+7xXEt+tLHVq6rOGZ+V4/486/RDK5QTnvDLvIvU8TCIzHu6epaSOmblxDStcm5aKPd26v18T5KtUfC6NWEDCYdzrODcjnkS9djyFARewU6bmPSZhOJV/igTjzCNl4m9gHKn+bN9Th4skyk1NjkywOl/v/ortsFxnBLWSVp8ZKi4Hccxg8fa3Q8RLSpfppuf/iwKd/eOWflArV5WTWsGmAWzYgBgAI/n3cm2JuIJ8PcyWJoU+Xh6mgFoaz0YpevWfyBgfYaWxXeFHvlMHn8Xe3fnIWf5Z9ic9DJiJ+tBABeRsfx/TVXKGrBhPmhmGHrPD9CYUnCtC2favtw6NGBiyQ02p1MZwSRJUULWQmnaSzlD2TnVwU8g3OdDJhw876X1OjsEZ9IJscCZ4l6avn9HjMEnbG6SdhX64RppD0fMWSTHg+KJs8Y7jTktTpoORjQJaY/6juIsvZSX/+6NKgau8sDSAaUlJmcUEQgIm+AxyLm143MyKF/Xg9IT9+dL7hqT+qIDdL1pLCS0pMXESmki4OiMZjiaE9SzZh8cOtW3fLZbYCZmzE1bgl3CqVFo/R65sMPykWCvfQfRBi111xgxZt7duvjsc/kr0zXwN7FOgdjyGUD+BhiShcjzXIa5ExW+V4ezWtBCAFvtADq3f+odkmupmDqpPeXYLK6sICZXVgUmyDvQNg/Gvcr1sK2c5+Kofa8hSPvT0/U0YxzoscfmW+8aPsxRzuQfeNC+g8p2ukCXK98amNUeaz4lxz4xum0DtiTpc
 yg7ry42W
 veauHDRdccYJFASup4GeDVhhIwjSe7+r+o27cPH6Uv1rujeCp7E5Ai+suJ3xpVyeYgSD/69BMEHpiN/VPGf7eTZEXjJnXPvnQZCYMhihXU9bT+03wPomiayvzDj8VPcu+NavCbMRJXIJc7mNyfAKQ9l1NOYDYMvdy4ZEgZrWO02cPsU4AuyczGCxNfbWsRQoLov5JYVa21ix9I/Cw4lew6bRqKNeCSpU1XDjglHeKKB/ifHk6ujaHMgcM7E80NrqqN65YU7wlhI8/wK6IlDdn1RiEvmwDjk2562KS7g2JIekrk3ZOQLTYHYsnW62B6FVWZlqnTs0C25/6S6N1K9/BS++RrI5j1m8gCIfWVigr6QUAlhdQY6IQ/EPCtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 14:50, Yeoreum Yun wrote:
> Since commit 0389c305ef56 (“selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled”),
> the soft-dirty test is skipped when soft-dirty is not supported.
> 
> There is therefore no reason to exclude the test from being built on
> arm64. Remove the arm64-specific exclusion.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/Makefile | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 2d5366196e30..d3e9bd67904a 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -104,10 +104,7 @@ TEST_GEN_FILES += guard-regions
>  TEST_GEN_FILES += merge
>  TEST_GEN_FILES += rmap
>  TEST_GEN_FILES += folio_split_race_test
> -
> -ifneq ($(ARCH),arm64)
>  TEST_GEN_FILES += soft-dirty
> -endif
>  
>  ifeq ($(ARCH),x86_64)
>  CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)

Does that mean we can also the following?

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384ee..33963535616b2 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -390,10 +390,7 @@ then
        CATEGORY="pkey" run_test ./protection_keys_64
 fi

-if [ -x ./soft-dirty ]
-then
-       CATEGORY="soft_dirty" run_test ./soft-dirty
-fi
+CATEGORY="soft_dirty" run_test ./soft-dirty

 CATEGORY="pagemap" run_test ./pagemap_ioctl

-- 
Cheers,

David

