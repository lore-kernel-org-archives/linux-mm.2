Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17656FD9E2A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7839E6B0273; Thu, 26 Feb 2026 19:53:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706E86B028C; Thu, 26 Feb 2026 19:53:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605E26B028D; Thu, 26 Feb 2026 19:53:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46D486B0273
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:53:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00EF08B7E1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:53:42 +0000 (UTC)
X-FDA: 84488413884.26.2AD82E0
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38AC81C0002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:53:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772153621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQEAFjDOLFJL/ZXyFgYeYizgd7pTYOQhy6REedJX5Zg=;
	b=uF8/lP9cjkSj0PBx0JzFvDMfJcfLUOWBcBIydRtqmmnlmk9O8uB82wlyrqziZ0HZd/vzwX
	fIeAZG90Zdrq2BnVwDHpSoBBg8wGydL0vn+IlFpbsBPDZHQKuEfzW+xeSl1JVAKFlMIvri
	b8d/YhcYhSH147nLrcdL+5wrxkI8iak=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772153621; a=rsa-sha256;
	cv=none;
	b=5BfkqVHpo5kjDo4uFEp/zR/iSchre9pXV0uBsoyIIyQ/ZxocG/Q7ST2HB5zwp3hiBrXHIT
	3cGPDDEP/KYjyQjM5MP8GhM6ndm0n9/VCl4pKzt4tHUsURPwEFMbQOSHxQa6CB5kcKEQvv
	CLS5WGiqCF8DO8QLtFW3+C8pila+pe0=
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20A57C1AE8;
	Fri, 27 Feb 2026 00:53:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 8D64A20029;
	Fri, 27 Feb 2026 00:53:32 +0000 (UTC)
Date: Thu, 26 Feb 2026 19:53:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: SeongJae Park <sj@kernel.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador
 <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 1/5] mm: introduce zone lock wrappers
Message-ID: <20260226195355.611ec7f3@gandalf.local.home>
In-Reply-To: <20260227003856.83271-1-sj@kernel.org>
References: <5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772129168.git.d@ilvokhin.com>
	<20260227003856.83271-1-sj@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/LiC0YloSSM44sJymQ/qyPpNpQ64AKLbM=
X-HE-Meta: U2FsdGVkX185+mqfSVIc5V+IJg7SmsD8GX4C+AsrLlqGF+GiNx5rp1FR/ah3UYg0ySZaaCC0lC3y4ZOj3GwZRvNDd+jiQ+voXh7q637prwfNUghpmjrfcHBWXH6pj6Zt7HFY086MjXDaLq1BJi+TnWMBNHvNvRTA9iVOHt8dQv0WkMKuXibT3ArN/tDWSD2XbgpIFNTuvbTxOSkHHvRTcd1M1eAaFfIZkTnOnpay0V5xotmMG540AfPniTrLHh5j267JzPYt69h1lEqRPTCS1/ZVFW+450aGnIu92ayUHLLi6Ptre+idC7HVL6gk/4lcHKe1coJSNmTZb815erS9aFI+OZAhIfA9
X-Rspam-User: 
X-HE-Tag-Orig: 1772153612-227748
X-Rspamd-Queue-Id: 38AC81C0002
X-Rspamd-Server: rspam01
X-Stat-Signature: 4rcuqccydro44xctc4uea89ja1nje9yz
X-HE-Tag: 1772153621-72922
X-HE-Meta: U2FsdGVkX1+2uqL1Sw8JDP3BVICfjAkKFbjKuiLfUQrL0yWjBRV6q55lpV2b3s34cAZvUU5e5TkfoJu5eQ+7rINe8Nyak4YS5jYEPoVUoO+ir2LDIh/QNd8f4pz1BJ/WbNwKMV2CXEohjgzRtXQVnb55sLnUHL/F3eqY9vzLFCAqbfwPtyRk1OQmVwm5Dc7FLKn8AS3lggxp8BP948NVATJ6LbZl6oTZWAuDqSSDwmH2aKgSaOkoJm2aWkHmzgz7edGcliP1fENC0cdCKhjSdLEgYBmGp2eqq5fRP+5VjQjyziJBt2rNqeRfeOuCUF/86GGsNkT74RQYno3sPtVmqG+NIxBckXRyGCGLoj6Bo9Wd3mQALDtrSmLDaldxU/WDVdR1xqeYk5c2Kh6XhZUGI1RYZ38d1UnjLL1EjJCuAmvAJreAEqc02Fbq0CrsG09RT+lAeUOzLC27f+wtoZO3Y5qS71iy4KEq3939LMb71Okqum49jb17wzUDri5Rb9fJ4db6W9IT/8rZ3rF1cI1VMYL02A63Yjg+7KKTKxSKq6j74gIclsLKuVNlekpaYchEqE5VoVmq3Px0swNS/lB+qR8lJsIof7DHmkNEKk7lmEWDgM7j6Y7Fac0B/yJv/DOEJemgFjMKkFNTiwM21ITHRjFzABaNHzkjF4iHNOOPNhjktbRiCKPo6NEWl2U4Mw+h4jrdWcmyd4UgqDoHPFR9MLX7PetK3qBLuBEY/opgKqkfUVTuNWvHeG4isoPAem8MKgI4aPZi/E2rxGWLSJYVuQfHGd8Wee66m0VrGCo1hxFqhFqsvOZB3xqXbwtBH9vMJt48/EIlmcOL+d8+M7b5aK5IRZgb/Nq+icqeWiy8Q+DljdF79052w7Hn7UqjykigUIzwq/qvmLIiK15munr7RH0U2ty3ZaFRuI7/4pNyEf0ogWBNUngk7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 16:38:55 -0800
SeongJae Park <sj@kernel.org> wrote:

> checkpatch.pl complains as below.  Should be ok to ignore, but, may better to
> kindly make it silence?
> 
>     WARNING: Single statement macros should not use a do {} while (0) loop

Hmm, why is this an issue?

>     #116: FILE: include/linux/zone_lock.h:13:
>     +#define zone_lock_irqsave(zone, flags)                         \
>     +do {                                                           \
>     +       spin_lock_irqsave(&(zone)->lock, flags);                \
>     +} while (0)
> 

I know this is checkpatch and not you complaining about it, but I really
think it's a useless complaint. I can see it better as a do { } while (0)
because it is creating a "function" like feature but can't be inline due to
flags.

This is one of the reasons I still never use checkpatch.pl :-(

-- Steve

