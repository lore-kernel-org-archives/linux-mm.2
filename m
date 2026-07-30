Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 448FAC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C446B0093; Thu, 30 Jul 2026 05:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD886B0095; Thu, 30 Jul 2026 05:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6C76B0096; Thu, 30 Jul 2026 05:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD8C46B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:01:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 307191C12A3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:01:23 +0000 (UTC)
X-FDA: 85044849246.17.F6153B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 777EE14000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:01:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cMAAyTQe;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CepvrJSCofuW+Rbn27Rzxe0iX7nFeJvfMACrLN8SBXg=;
	b=WjE74YcEnAor2wb97yd40cTe8YF8+t/Olri28Vkp3SCvWWbaVo9F696mePlqMYdXreKFWD
	cMZq4WJibd7n2r6od/uU7cfhYSQQ2atsg7/q28Z3t8BhvrdDzi0oJvcIJ2uVOk+Ag+iJJk
	1FFu7nCV9o3sqaDCpgB1bThQpMzOoPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402081;
	b=3csCxzqpMw9LnbeEO4ILqxnczQ3H++e4pBnmIHSOQJID7twahk4gUtGQf9pTWG8cxSa02i
	BwF5EUpDZTqHtVTf1Jj1/9Wru4JpavDyAfvTyLc10MoZZ8apPO1pQLsaGaiE5FLaR6bmah
	8lKh0HVWelsScuVLa7w54DEK6ZjsH8U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cMAAyTQe;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBEF660120;
	Thu, 30 Jul 2026 09:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16F51F00A3A;
	Thu, 30 Jul 2026 09:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785402080;
	bh=CepvrJSCofuW+Rbn27Rzxe0iX7nFeJvfMACrLN8SBXg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cMAAyTQeOGqrx75vLFrjVKl+Q6ZyYvMe3VzKiXO3gT454huGwem31nWyXRv/q9dlS
	 E3hQqIi3kmO60/5toa+zlCHUuM+g8Wqeu3nhCRRJ+Sf0qZx2N3FkcFXK6YLhYRpLQr
	 t/KYFLKt7fKulDxc4uMA3avGCvf+riDMcZSldx4g+Drk+cDrNxW3LqOsYnI8qChyzL
	 7VHsgrGNTwXbiZ3BhGlFN+vSFe+V/f8AsAU+/6IPpBHgp5VswFdaspZ9ChgObfb20X
	 +Kdl7lpr/DuwRf+dyPvrYDM1Pns9x4LuCF0BroserOpfZgvlmji+6LlA5kagPgRpPY
	 2550ObpT+Lr8A==
Message-ID: <47b147f2-8c10-4ae4-8023-94839f1110a8@kernel.org>
Date: Thu, 30 Jul 2026 11:01:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] mm/slab: introduce kfree_rcu_nolock() and improve
 slub_kunit coverage
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
 <5342124c-4847-4e93-92a4-f3512928c4d1@kernel.org>
 <f97853e9-3021-4f20-81d3-4bb710ca444a@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <f97853e9-3021-4f20-81d3-4bb710ca444a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hfc459jw4my34onzw1kx6nbp7cy3gnr5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 777EE14000F
X-HE-Tag: 1785402081-920473
X-HE-Meta: U2FsdGVkX1/nia1z/TU0Aoi3SQI51NVqimyU+CF0zMYDVJqzoLXGPD35QanmzzJsemqJj/P28rtlSMOGLfqgm8SGTPl+gQKFOz5z7VSH6LeO50SqK6649ux45lp8vggch9P4BOj8YzjMN/FFGN1Jun4AivWKquIQW/MwvzDAA3Ym28lRTdEH/6X1l7aW8tEKZZALd9slUQKasKyvIiKmdOf9G3OqvcNEIWliLcJWPF5DoqkLQSLTvGbgWJkHxbiRSjHz/8xiJFY1kvNKOHKE9apojdsMJ/xyXnPhnKNlV203COwv16mm3EFLwu4OyHFxtxxJJJqtaOTCstCzqQflpDOO/3pqhQXEj3mBNNAxwQCn70HxP5lrCAUuSGP/sVRHJ4mu5NI8zV5uvqnDuAcJcrfG4Uiio0cqYDzHDP3xFtkvjbw2BXEFvEyu45xfSgYMzgI/Rd5VZ0uHdnZf4vKRLjVF6KWEieMB03AgF3ZLs2i/IunGv6Iis/MxjVknyKAMz4i7x4n4rJ2wQcFwjqEQCgOCJP0nD29tIbhEQqYuWWZUV4+7skiQ3ni5vTbyUYmZi1eqLRVePAAKOA4DsFNTnFipnFgXUBEFs8NLG+H4A/f5EEosntI+AGiHgBQdauzf8yfMv+A+OxXXZP+3+j2uRhiSbAcZQ0EWsGI+Nh6ZiENDc9f9lzP2DZ1T551m9VGHJtGuODDNzYSwfM7JO3w6gIhuvsF94FLXr3nTE9Lh9GKIN/WE+BR7rWD6f8WWDnWPka56JKK7QIYVvlUi/qG1kQFo79eD4fiben2jxXifgeTDlDbkEuQGfM3h1KV+7GlkbL0nDNK0qeHoJO1CGWNYhExYgwYZA4GSGF6I8h3DGahMIxHHKDBKbbL3HdlrM7+Psb+CAjBv1I1HA1vCcOvJX78S/GPVMfn0Mg1aYaIGWmlemRphL5kwD6vmc6KNHuknNl/PEPhAmT0w7l7P+Wp
 tt9n5ko9
 kV+h6U5gKRkRebHHeewDUNAYIqZq18JRmzQ9kjSyBVp6Vnj9JhW6j9ZAdXs2Eh8w/JAwINHbArmUMGAp78qHqnPMFHM1Xu7OAp+U9C2Y11aWrEXpuw2+/B9h/a5LKjUETPQZyYK5TiMtGECAZDrvXDmwqGI8zCj55cOybU056ChNW39DO4udt44vXLtjUktJvxtJo3hB/ROoaNqmYi7WT4dzwolnrH72nesdhxPh4J3jz52PujVPTh3zUOYUAcwDRuwVcXsXb/Kuq+RjxrEYH71olEHgf99Qt/r/9yYBem9o+LMvLbGRMJZ4Q/Jr6oWmPmVxqlygmcoFhA7qQ4MNkisb+XbNfNIKiJ9PEYUIy5rGTciw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 05:08, Harry Yoo wrote:
> 
> 
> On 7/29/26 11:14 PM, Vlastimil Babka (SUSE) wrote:
>> On 7/29/26 10:20, Harry Yoo (Oracle) wrote:
>> 
>> ...
>> 
>>> 8:  8e69c83a1e52 ! 8:  aeaf2ab60046 slub_kunit: extend the test for kfree_rcu_nolock()
>>>     @@ lib/tests/slub_kunit.c: struct test_nolock_context {
>>>      -			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
>>>      +			gfp_t gfp = (i & 1) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
>>>       
>>>     - 			objects[j] = kmalloc_obj(*objects[j], gfp);
>>>     +-			objects[j] = kmalloc(64, gfp);
>>>     ++			objects[j] = kmalloc_obj(*objects[j], gfp);
>>>       			if (!objects[j]) {
>>>     + 				j--;
>>>     + 				while (j >= 0)
>>>      @@ lib/tests/slub_kunit.c: static void test_kmalloc_kfree(void)
>>>       			}
>>>       		}
>>>
>>> Link: https://lore.kernel.org/linux-mm/20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org [1]
>>> Link: https://lore.kernel.org/linux-mm/6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org  [2]
>>> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>>> Link: https://lore.kernel.org/linux-mm/872bd673-3d45-4111-8a41-31185db3ece5@kernel.org
>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>>> Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org [1]
>>> Link: https://lore.kernel.org/linux-mm/40591888-3a87-433e-b3d2-cda1cab543be@kernel.org [2]
>>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> 
>> Wonder what produced this weird block of assorted trailers? "b4 prep
>> --compare-to vX" never did that for me?
> 
> Interesting. I checked it again with `b4 prep --compare-to v4`, but the
> command didn't produce this. Looking at the cover letter
> `b4 prep --edit-cover` It's not even there.
> 
> Probably it was produced during b4 send --no-sign? hmm...

Hmm let's see if it ever happens again.

>>> ---
>>> Harry Yoo (Oracle) (8):
>>>       mm/slab, slub_kunit: register kprobe to trigger _nolock APIs
>>>       mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
>>>       mm/slab: use call_rcu() in unknown context if irqs are enabled
>>>       mm/slab: extend deferred free mechanism to handle rcu sheaves
>>>       mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
>>>       mm/slab: introduce struct kvfree_rcu_head for kvfree_rcu batching
>>>       mm/slab: introduce kfree_rcu_nolock()
>>>       slub_kunit: extend the test for kfree_rcu_nolock()
>>>
>>>  include/linux/rcupdate.h   |  32 ++++++-
>>>  include/linux/slab.h       |  16 +---
>>>  include/linux/types.h      |   8 ++
>>>  include/trace/events/rcu.h |   2 +-
>>>  lib/tests/slub_kunit.c     | 190 ++++++++++++++++++++++++++++-----------
>>>  mm/slab.h                  |  52 ++++++++++-
>>>  mm/slab_common.c           |  81 +++++++++++++----
>>>  mm/slub.c                  | 220 ++++++++++++++++++++++++++++-----------------
>>>  8 files changed, 433 insertions(+), 168 deletions(-)
>> 
>> Applied to slab/for-7.3/kfree_rcu_nolock and merged go slab/for-next, thanks!
> 
> Thanks a lot!
> 
>> Used slab/for-next-fixes as a base for a better topic branch indepdencence.
> 
> Ah, I see. thanks.
> 
> So slab/for-next is not a good base unless it depends too much on
> existing commits on the branch?
> 
> And usually it's better to use the base (slab/for-next-fixes,
> in this case) of slab/for-next as a base?

Yeah. Hopefully we'll figure out some documented guidelines for this in the
upcoming mm-next meetings.

>>> ---
>>> base-commit: ffc64805cebac330b2a60b2f1f144fcc35b8ab46
>>> change-id: 20260615-kfree_rcu_nolock-e5502555992f
>>>
>>> Best regards,
> 


