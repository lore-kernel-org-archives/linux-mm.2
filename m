Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA6FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D516B0099; Tue, 14 Jul 2026 09:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60AD26B00A2; Tue, 14 Jul 2026 09:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6BE6B00A3; Tue, 14 Jul 2026 09:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0C76B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:05:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BF83403B4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:05:53 +0000 (UTC)
X-FDA: 84987404586.12.348D737
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F921100006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:05:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIvkcNKG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784034351;
	b=FLOBQN8zKnO+oFsrnAex+9s5YNsYluPVg4WhIGOe0rIxSXt2XfOK1pMUnTtnUmOHGM84r9
	GR8PryogJ1IPoCDXbhx1P0L5fFZhjgVnjxfprCuByZMjSvrOX9XDVrIvI3Zu7kMvdG2Id3
	2IK3GGoMw+5wwK7WrPajCUzN1ZCQPVc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIvkcNKG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784034351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5H03+CpfRIUyjXLbOlyOr5XkjFBA2v9Q+EuJBH0CT8=;
	b=mWIe7B1SA+QBNJSx1ysD6eo5RpJaJBv1jHh7mbS6b/w9pznSznypnKW5gaiM/bYxotcwCk
	dJWhU2wyYw6c/zQYsQic4/bucW2vWa8St1/RHSVBLHkT1uVxsoK0eUjFbM2xcu77WXu0Ox
	lwhqGVABv5qNPV5SmuVBHrF9RsGkCis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C68A36136B;
	Tue, 14 Jul 2026 13:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6C31F000E9;
	Tue, 14 Jul 2026 13:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784034350;
	bh=s5H03+CpfRIUyjXLbOlyOr5XkjFBA2v9Q+EuJBH0CT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gIvkcNKGPYOQyg0OoD2EcOKk6jp3QCaEszxn/eNJkK3mNudKcg/pidi834G2XiUhf
	 LqcEJL5Rslc+z1j38FLMnR7WMUHvHlpnnie3RSHtwiXdylxDT24D/IDesR+4SrwZlc
	 oKwwNKJp+/E0LX71X5TdNHw7sogC18f8/N1mXjWrrYNRqwmlsOTKIVELQW7HCWPO0k
	 BB7IuhXe8LPagBA5crVQEsT5n1EAu9ASwq3xtpSwRb8qLOpRjjj2LM45l3wjX0zuiS
	 pwg4tg2Yx7bamy9RkUEGbMcP4cea4OvI78w5EA0IDIMSxRknaOkIguhF1b9Tfse9pO
	 TayF4gJAajBIg==
Message-ID: <9e0db1c2-06ca-4dba-8fb1-552fab91cb02@kernel.org>
Date: Tue, 14 Jul 2026 15:05:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] mm/page_owner: add MR_NEVER to enum migrate_reason
 and use it for last_migrate_reason
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-3-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260714015117.78351-3-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5F921100006
X-Rspam-User: 
X-Stat-Signature: 4rqksn8neao4aummj99h8qpzhx8pbco5
X-Rspamd-Server: rspam03
X-HE-Tag: 1784034351-908488
X-HE-Meta: U2FsdGVkX18jqRLTP3KGDit1fI45bfc6qbt86jeMNs8/yMqkfSm5iuTRcHn9ppFs34F0XxQOuXd0DqfppQtLLYm1OmDrc4dn+NKW9BzO5ykl3BBNKQZj2Da1r1CbL2nsAYWqI9mR3TMLqMxYYTMB3B7wfeGb7qTftA6jbPmVBlwn1I0p+k9VxdYIwseolIC2afTSpC4YO7Cscrd5p+W3brU87nw3/1Vx2Qtjw30xnBD2AXkjDpHDJswZ3NEUve4S1XrZAxVwJ+oO8P3/PCNunjjYwdaCXwBB+UdCrHgTTBs1Bul+dzFE/IBQIhCv13Ar3Xkk+AxXoTTjwsdpwPL6TnQGV5nPTxMeAUpckzR4ut1l2NNzj9rbwhqf3OtNEw2SgTQbbygWoUD1wKCOymaIkrhLfUwKj4K/rySjVz7KxHKjQHLMyPLnmvYS49do0Fq77rQy1E1KbWr1kpQ8ytwcfx9Oa2tpGndUqNSL1r3MRnvm/8WLnhqsz70z1LjVydzNJDZmAJqu6+dQWKK+DEDi23Inr27SlUnndA1OEu8JhtT4pXShg16RmxHY6JXohfXnBEUHI6gccn7EXs4bJViv93QPNGVE27dlw8U1o8BboSKHKPhhTSIFPsGWIkHMdtWjoul4rNT2v4pzAcpUfTLcbvVgzPmS6YcpqFZZfyAEVDMHxAsu2B+L3nNCEbEwN39AAOUvdJQhgEP11rHPndbqWNmwHyAOxpR6liB5pUwpiPb/Slx/3qeZDfYWpMFTyLdnRQaaGBZWA0dAw+mn0DqcCp613kqtBE6TED6SiC1/FwrlrTsyN8VzM0EVSiO2/UWoki7s7NZZ3O1wwpKGIiPukzM2leIx+qV0JMHJQsELFnKZDSWQ6RFufU/9VNv2/lH79i0HhfN8wZ7CdGsB4oHAg7jSGSeTtrF5kmX3HzUCgVoMDqawzZQZfbr8NqEH4qUKUM6eG/FzC+ZowYHcKLS
 cXoHrx2Y
 livi9KvyuAULCH1N31MkY3V9ZB3IiAy8jjX06QM9S24pZQDRb41ppOQH/+7IND5BGErkKUy+DdRVN4yyzU48Ug6aYyI5UcmUn1DCrnhaxnJwFPNoiGok9vtMhmFU1G2Ibu9GyxBBXHJgolBZjokprAtnzVJpMZCBCOfBU2KPzl0SBMC+c3g4mQ1UMT0ts0DIAK6WW1HZgkBlzuO9cFHcqhoHlrUir3yZ2hOTJ8jrXznaDcoHoxwuXnKMlXD0618hbweFZ8TusWTZ3epjq+ClWyXtbsrG/cm9hxMBxnLuwam2/0ezvcBjbj4+V2Udq8QntIy2FBROnpoy8+nsh0Gz2NqnF9bTJHPnH49iNSkAFebnc9L/HwD/SBu4kUb/d1+v+fHhb2L2BmNmUp64oPEXJTlS90l4jUZExNosns8ehnJxglgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 03:51, Ye Liu wrote:
> The last_migrate_reason field uses -1 as a sentinel value to mean "no
> migration has happened".  Replace the four bare -1 occurrences by
> adding a proper MR_NEVER member to enum migrate_reason, defining a
> corresponding "never_migrated" string in the MIGRATE_REASON trace
> macro, and updating the GDB page_owner script to use MR_NEVER instead
> of the hardcoded -1 so that lx-dump-page-owner does not incorrectly
> report unmigrated pages as migrated.
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  include/linux/migrate_mode.h    | 1 +
>  include/trace/events/migrate.h  | 3 ++-
>  mm/page_owner.c                 | 8 ++++----
>  scripts/gdb/linux/page_owner.py | 4 +++-
>  4 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
> index 265c4328b36a..05102d4d2490 100644
> --- a/include/linux/migrate_mode.h
> +++ b/include/linux/migrate_mode.h
> @@ -25,6 +25,7 @@ enum migrate_reason {
>  	MR_LONGTERM_PIN,
>  	MR_DEMOTION,
>  	MR_DAMON,
> +	MR_NEVER,		/* page has never been migrated */

Shouldn't this be more like

"MR_NONE" ?

As "never" is not really a "reason" ?

-- 
Cheers,

David

