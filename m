Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C8FEC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370976B027F; Tue,  1 Sep 2026 11:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320B16B0280; Tue,  1 Sep 2026 11:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2117E6B0281; Tue,  1 Sep 2026 11:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01296B027F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:54:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D10A1C2101
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:54:59 +0000 (UTC)
X-FDA: 85165641918.05.B456A6C
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8008B2000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:54:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMQPDVPJ0tCxO93gmrhVyeG5Oa0anovLBVYtrsBizkA=;
	b=Iulw+r1Wgny1sC8fg5WAfaY0ef2l+PLIy18dqHNu9Ny6FvpfRZm0440Sv3LCe4ZedTye4R
	NXya+qWhiTWyLnqhXZviqCQaYV7Cz5eOExJRQ8eLHEJNE34tKdcCA2L3c+IAD8g3TyUdG+
	/WcTgXFAv58c9b6eUrwx40gKAh44TPU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278097;
	b=zgJHGid3IeDUuvAB58wz2AujO40cW3ogrRzIR/Eh72r71WH3Fvs1pZTtChClIEqIVyOWoN
	xBxRizCNUexGg4IMBjw1h0mLjZJrj9slQUc1cYtDD6YvBWNEmuMRxHiXUzqtUvibrIMDe8
	Sqju/cQwaOfNznKW5ScdCjr4MdcgKbI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	none
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C29301A0469;
	Tue,  1 Sep 2026 15:54:52 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 8E80930;
	Tue,  1 Sep 2026 15:54:43 +0000 (UTC)
Date: Tue, 1 Sep 2026 11:55:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Muchun
 Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico
 Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song
 <kasong@tencent.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Jan Kara <jack@suse.cz>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>, Shuah Khan
 <skhan@linuxfoundation.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/14] mm/page-flags: remove PG_private
Message-ID: <20260901115542.35cf337f@gandalf.local.home>
In-Reply-To: <20260831-remove-pg_private-v2-14-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
	<20260831-remove-pg_private-v2-14-3668159cd9e8@nvidia.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/zWbvIDz+3Hi5z7GDK/fNqzAPKpw/khW4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=PMQPDVPJ0tCxO93gmrhVyeG5Oa0anovLBVYtrsBizkA=; b=tGc4Z9sCnIntcGcWtJ1kOvYe5256jqS1DsWodW2sqCKQLdl8Y8nHkKMI+/bZHJCQztdMhcSkJj8YVjXCQshVK+Dgc2EYzxp1kQ+nPt/MKxXAHxYAr/fN2B+/kb850ZrxY0100q3DUUBwY4s7EFwq4xvvaRIiE/XmnNIq0jxhRxw=
X-HE-Meta: U2FsdGVkX1+zDlnR6QN6MUglWJjwZx5iCWUM+krVLXlc2zuUtd2IG2DLx1JPwqlTPq6HywJagZIVfhFWq44D2aDRr8CqPASzgDg55B72H7mSnF5ikilDHz6BwtU39295NFtcyv6lgavetSPz7y1L0g1K1zuV3ydBJ2a0X+t/9iTl4lf+jI9pSLCyfw2TQI05jjgMqbeUDhSMlamHBWoJCJ9h/PNz2A75JPoGpqGqH4tC/s8xhJUmsTXFGe6/YTY1Ki/+liODnEmp1JpspQt4nrByo2d4u2HwgRpO1hcQFU+FSiTYj5enzhApbGNiHUuTn+pvjGsLrpU3m7+D/3dcDhPAQVDdzRzZ
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag-Orig: 1788278083-807407
X-Rspamd-Queue-Id: 8008B2000E
X-Stat-Signature: b6ytfgjtokst1jc1aabs95dwf5ejwe1f
X-HE-Tag: 1788278097-781547
X-HE-Meta: U2FsdGVkX183UU1mOmYIYZGP9ySgXXv9or+7nkjIKg3vwhu/F2LaT3rfSIkyrfyczuWmq/wM7PmdeY/yEHL771U9lBOWdJR2Srq/kBVbIC3xug83HhOEdMJo/C7eDeeyPCgS8b9i9wYROEh8uCIOK60iXN/xlHm2L83mUyQwZD05/b82pbk6BC1mVPIonhD8rOi9tq3qqQ4ipob3TSqeKn5+U3oMWje1gaBaurwuAy5S3OblUqFbeVmjfZS/Tlo10ByPc9jL1YdRVjG9wCJmupwc+r+ayib7JOQXF0ln/0+JGrGYleEHLWCwwmFaDJFi0z4C1BHsAFCF7EgMWTaXbCmKVXQl1hKplv7Dvkka0qf07UaGarNKJF4zC9BBwTyYweBugclET03L4U0VkEoVydg9X14Fkpf1Hx6DK1uEaYxiK1+7/iz61I9Jc++QvfW+vyllknXrX9YHWxzKDVmEy8SWfIFf7g4oQt2Xr15nwdyDeN3qBq2C73t5GkURx92fziZUGh/tNhHTzMZ+WQ9C8u0e4lm4hNaEk8HjeXcZxjprEjUx3IC1CJtxa0fPCIM04oH06OCHvihIu5AOBS/IAcdHyNk8NGrkWq2rZGUYbwHCOSQGxWGYvRv4/y8JoRNdC0LazsHB3APlviYaHBZ2W0EDQp/PaspeULs+8pce+/KEaYFInqU58L1bpL6sNZvGVikA+IYQz4sxTXjJ84tF8bJ/6OnUJRC5FMnbJLUzUk9M1dLCy9eDqtOE7sFf87c3YTlnWea7md2XLh9BfS63SQSqU4zrJdPOTDDUJhRDED9EvL1rdwk6lN2YoIGIXtr+F1rsOoirSEaQWhOjlAeN9bb4K+CNr/RS5bJTq4TD0jTvtg7kV7LoZ2tZ7WEPiox2dE2Fljuvw3Z+XypTgtwU5mzYLomYbmfzY9tgnS7c8DPc3QSOy4bmuT3AYPLUMR5sLvIBLowI0z/o+kZpkmg
 3+LhQu2M
 sfG9GYF6SgO/UDdFxUdZKFhR5QQfwQZQMJub5Z3NzSCtZET3qt2+2/AlWQMlzFGRGYloxB0HUR7A2qSCwp1f7rXOtfl6uNBsxOZaLDtvvxCaph9xx+MSpcY7mbdMvtaxIgD1o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 15:25:37 -0400
Zi Yan <ziy@nvidia.com> wrote:

> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index 935893e5ea53b..caf090cd6f85e 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -144,7 +144,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
>  	DEF_PAGEFLAG_NAME(owner_2),					\
>  	DEF_PAGEFLAG_NAME(arch_1),					\
>  	DEF_PAGEFLAG_NAME(reserved),					\
> -	DEF_PAGEFLAG_NAME(private),					\
> +	{ 1UL << __PG_folio, "folio" },					\
>  	DEF_PAGEFLAG_NAME(private_2),					\
>  	DEF_PAGEFLAG_NAME(writeback),					\
>  	DEF_PAGEFLAG_NAME(head),					\

Hmm, just for consistency sake, can we create a:

 #define __DEF_PAGEFLAG_NAME(_name) { 1UL <<  __PG_##_name, __stringify(_name) }

Which is similar to:

 #define DEF_PAGEFLAG_NAME(_name) { 1UL <<  PG_##_name, __stringify(_name) }

But adds the "__" to the name. Then the above would look like:

	DEF_PAGEFLAG_NAME(reserved),					\
	__DEF_PAGEFLAG_NAME(folio),					\
	DEF_PAGEFLAG_NAME(private_2),					\
	DEF_PAGEFLAG_NAME(writeback),					\

Where the __DEF_PAGEFLAG_NAME() with the "__" still stands out, but the
code looks better than open coding it in the middle and making one wonder
why it was open coded. (It took me a bit to noticed the "__" difference.)

-- Steve

