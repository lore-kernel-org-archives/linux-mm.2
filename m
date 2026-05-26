Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C469CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 16:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DE86B00B2; Tue, 26 May 2026 12:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E726B00B6; Tue, 26 May 2026 12:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334496B00B8; Tue, 26 May 2026 12:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24AE56B00B2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:42:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5F591C12C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:42:45 +0000 (UTC)
X-FDA: 84810139890.19.B2AE32F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E83820017
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:42:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Py2YGmy8;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779813764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1TxQbHcJCgYm2L6KOKrWRkDSGiXwZPm8LbYus7RKfo=;
	b=iPu5uHBR5IU0ArXwWW614/p2uhk9YbF6fBDbRyYo1wZCNdPMmDDC6UXuPzK8/CPYMogI3v
	yWkOTM/txw36eMsGHATceRpkNWui2sYlrsi9QQmuB0sj8r3lAeH9Bg9OhXXjvUmFagDJ2Q
	0JCuW7EcD6yI+4mNtx1oP8s7tgiQW+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779813764; a=rsa-sha256;
	cv=none;
	b=1chiy6TYKSLTaxZC0Yq8XgWJQ8mT/oGrJN7rUDA0r1ac1lrEiBewhC+SsEDCv8agF7O4UP
	79/kjTxZVsc38xvdwSUI+G+AQdlQBOIgnaFyZjIay+VDTO2LleSjXmL2oqWoaw0Nd1sJTe
	t8/a3z2sKjpx97Ag2rIR2zC6hJMflK8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Py2YGmy8;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72086600AB;
	Tue, 26 May 2026 16:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BE31F00A3A;
	Tue, 26 May 2026 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779813763;
	bh=R1TxQbHcJCgYm2L6KOKrWRkDSGiXwZPm8LbYus7RKfo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Py2YGmy86wcxHPArJ9qMsjVuxLQJQJaJMhs9cSzGpNMwiNNwgCxtUxQxklvslS36l
	 hUjE4Z8g9PNKd51+Qs3Akk/ErBA8hRaMFYUDzD0mHpkxRrXf7LneDrNuEsmD0jz4oN
	 AUlrXYJgQFcOD/NgGDLxw4hRnF8AYEeTzzxKClKg=
Date: Tue, 26 May 2026 09:42:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>,
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Matthew Brost
 <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, Jann Horn
 <jannh@google.com>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: find_mm_struct: fix race between security
 checks and suid exec
Message-Id: <20260526094242.adf161e66ee7adbb445d81ee@linux-foundation.org>
In-Reply-To: <ahWxQ3JxdR5ff2qf@redhat.com>
References: <ahWxQ3JxdR5ff2qf@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: gh9syani7m8u6aqngu6ezpmrjt5b4ryh
X-Rspamd-Queue-Id: 0E83820017
X-Rspam-User: 
X-HE-Tag: 1779813763-610308
X-HE-Meta: U2FsdGVkX19eAKnVKGPB3ZpTNDuXHaoHA+dR+FCtbSaJ6PrORal6I5H8/0Ab4VYPK1DLKpzf7vm19BJU1w7hajuCTtBdS2TWWVaOWwB91Pl8hmixaPdAM9IUGu77r4qbvwqn4gRIfgFMvn8tHdkNFanrvbYTSXDFbqZwcI/2fX3iXHSLsWNuoWEJyZ+blLkK5KSGXjcSQ9hbsITXIxcd2m4/sNCQ23Dse60EMcBbd9B/PWOc3hlM1bSq0BxSCT0/S1EEwPR0Un2fMsN/TFE3efpcXHLG44ZfCon4OqAliuWxChRtZ9FouXG/N5bQWNxHobsogIQcSY58YmxPQzB0wSD/+HXI0nzpcLNmtsX6CYUI63sm9l7t2qPuQW5+KwSaa2Q/l9moHoEUOcO0daj19nlo3iAYpj9Bg2yw6JRtp9aP7NmbEYAiM7q4W+AUpyk6pWWcsPflDVZvxuUFx7l1VxwbHOqjmktEdvUfweS0ZLJLP4dS4HpPwbXl9+k5W/iqZjrdjxiAY+cGjVhq73JNSLjfQlwT1aenIPnAX22du53dWy5qBw2dBWxlpkQhQWwgzXkjhiJOl/s8YKnSk55bj9WVZS2y4oSf4dKoiVQ30TUEWKQWwXfnxmNbFO9tRjM1JwSsfKS/xxlLz84Wo5FyliTtF/McmSFVTgHlQ/n0NerPBDN34H+9loIxK9yZ30bqo8ctx+TZmSpXCnZfepeluK7vWuEuQvriLJVzscX5x6iNqMpm4rGf+phZrECmylUFZfc1bA5+imvKm7Ymnr/xkGAUmrBuPIeYigVkMBxRczyLBxASzsefbeUjjv8NHsVss93s5C5XljAE06jtURNmkVVU3fKFM1EgHubO5hYdhCbI20Rr/CtwGada602Nowo866W4TDEBiQnLs45lvX/a30/+nqnpPXWTQJm950OWIWB9uBuaRiWhs6ZTK+dnlfj9ApW5EDZN78qbXXxv7G3
 fPqTx8Pq
 U6kf4tb/zfglszPi4qHVzrv5q2C5kSWQeKJcTrWZNGeT5Bo6fHJTBIu0o/gDWKBTdWFcUCLUVUkg9YZDaBW3xv+MzvxvJlAI2yQbQ5WOUX2KRCsGYnmeV5EqAhdNYnT7HvdcJ6YFmeKGNf3bFDN4WwQpMRTlyXYqRDvLiujAq3Ti/sDPVjqYMsNYwE7ji6jy6Wv8EWGxB+YWZovuQiiYUjh/rzJjQpuh9lZxy0sAzdor1iARWtdq6bUhyCCzYaeJRmdYpHF2Y4AYHGDmDVHcOeTPuA9RMVil52aMkfgpkHQqwSThx8lJOjvKOQKQ5+CeOe5ZaKLGkHlNGr13T+3JT7docFrmaI60fq3FwVQapThCEsAGSuFVZRPpeH51yA6NGymPj4gXLBAuNtUbNnDiKPFpBzpBFTamOaRL+lr5sYmiAli6xO4nXpB5KiKZvp3/esnaauveIVkZCZZ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 16:42:11 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> The target task can execute a setuid binary between ptrace_may_access()
> and get_task_mm(). Protect this critical section with exec_update_lock.
> 
> I don't think cpuset_mems_allowed(task) should be called under
> exec_update_lock, but this patch just tries to add the minimal fix.
> 
> Perhaps we can later add a common helper which can be used by
> find_mm_struct() and kernel_migrate_pages().
> 

Thanks.  Sashiko thinks we should fix kernel_migrate_pages() also:
	https://sashiko.dev/#/patchset/ahWxQ3JxdR5ff2qf@redhat.com


