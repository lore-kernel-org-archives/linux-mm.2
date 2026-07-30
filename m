Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC5EC54FCD
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 03:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6781D6B008C; Wed, 29 Jul 2026 23:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628D76B0092; Wed, 29 Jul 2026 23:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3676B0093; Wed, 29 Jul 2026 23:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 220416B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:08:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC62D40569
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:08:53 +0000 (UTC)
X-FDA: 85043960946.11.52AD178
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0EB10C0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:08:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fkb51iDq;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785380932;
	b=q1Qm9RKjT3AY2cp/gLq2TfWkhGqIIViUb222EuKn+PIPMR5ZtduPCyRHbpR/NyGC546sEg
	RkNVsqqHSriHroMfRm/jpDGMU9/2LTBPTqe7a0r/FEyO/QpYPF6pAoDC2exDMBMcAKZnmW
	Z/cVQN5L1j5bTSEQdvtB/1bx/i+5Ooc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fkb51iDq;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785380932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFYplbxEhQ00hEvZ5hng6YDKKuCP2Lh5XB9nlXgKZ7o=;
	b=4npw/km8G5CcJzvioTqO/ARzjDwkXsC94oHV8qM4qL+P6yQgxnYwGYhYsr1zEyx/XsyP3Y
	ANgFJ9/gSJPjm9gOq9YfCF0khcmAFEX6sp/H26em49AokrCxozTHelavGSmo3GMF+I8Oxl
	o24u7eDmhFh3sKcK/Lzao5QxuJsp55g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 857D8600AA;
	Thu, 30 Jul 2026 03:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B9F1F000E9;
	Thu, 30 Jul 2026 03:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785380931;
	bh=JFYplbxEhQ00hEvZ5hng6YDKKuCP2Lh5XB9nlXgKZ7o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fkb51iDqkqLHhVoJ5kwF3219gubEw0+gbN9PTrmEy6rMkapWH7oDh37pFO+af77/p
	 kahJV9sx2eIC5HeZEEK5a4hik06jV5Zj94qDu1RFbxTuppTEsUCTMQco42MDHgMdnn
	 4B5D1ck16rJRGRY8IfDwuJwucgu6QHd0hpvL1J3gEXQ1MmVC7ufOXWqkqyu1ph7nZ8
	 tjhCBvGb8Ow0Zy8k5pqlD5tmdBpqIjJZX4uOT8jHL61KSaS3rYAcz1sDDv1N14ff0T
	 85D3zm7H5b/fEVJBzh3I8jE7+3KKEuFiUGgOScu24FS2KR4fTV0BwKMeqOlHT0qAM7
	 tD7nZxZ/SveFA==
Message-ID: <f97853e9-3021-4f20-81d3-4bb710ca444a@kernel.org>
Date: Thu, 30 Jul 2026 12:08:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] mm/slab: introduce kfree_rcu_nolock() and improve
 slub_kunit coverage
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
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
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <5342124c-4847-4e93-92a4-f3512928c4d1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0EB10C0003
X-Stat-Signature: jg7hren8uy73kcwqz431t74hoqr3s5nf
X-Rspam-User: 
X-HE-Tag: 1785380931-372835
X-HE-Meta: U2FsdGVkX1/RrazmceKamszqCA6BZd2FD8/pQyUkldAjDSGhx3RK5GlZXEspHHhg84CP1GckGhbPGrM3m7DQlJUnc1y+57998vYfNw/BCU8wtJlt8Pevkyq1dAcysc4s6WzHjrfwrmG94856WxWDJjo491/HeR6bvgTK4oyjVpiuKE66xVcDLwXtm4Z3OZZdxZ1CZji9Y6UGDgZgdD7FKgQUQRslkhVqlOzCAF1DXyonoaM1ibrNolutMXAArGbkHiBVUxyPs4YqsNOiDOsA5zwtp125LV+gC6SkSlIFk7N55rwva5pXjMk8pd5MvVj05yC5Zdm+TkijN9e5KWpRoc17d7nuR+5pqV/lcDK/YFcDBrar2VuWArN9RX36LLg7ugsJzGcegdIDuF/66yMIXoFnsWyoAhOovExeQp69fWuc0NEzkVKkdWQ1I9F+LfrzVqjch583SGOLWP8DnLqp3jmJiDY+rgppcJyiHL/91njFGsu34mma881lZSW8JV3+esZNLEKkOnzuwP1DW65d6/l+LO095JX1PCqUjjfW1fgdghgbWW2UzPI/24oOpoRd3V3Za/wgAukLftPX2YNlYIJsT/gBdF11TZffLtm4uQyxZ4VGGkvcTkKTFXu+QU9s1HxuA/gV7SGd2jK1l5Ix+59MO9bBQTbDmpzcbzXqbKwQ7TX+ds92qrLORFzCguwNLAPkzlQa/W/IMr85ske8xWJ2y8+F89w3ah9snJ/kkIPIch4qCHQQp9XvQ/F5zHFeD8x4AiOoAFnZZwbYAga33hbH6KW6B1lvkc295dPubBy4PN9Zwk9piFOxY/1o1P8sE87pJ5cXTuroVnuCd0FeWkUDjx7ABNwQnd7+4ya/6UTnfIonIXOGxG0VszaDdNN2EsfgyZJhpDdeVgqVOx3BMVaZFcepZDO4SSB8IVgQQTZPYq9qYmUxTdf6OW5Wh/ehQpTBRjTWPGbwcnTBb0Y
 mdbijGOO
 ciIm8XERD3Yxb0EA8v2uB82ok+9dJyL3RBU+tTWZdh6FXhqN1+A+UfnWfdeACO489lBsrEavd5921/Zx7PMon7dajzafPmVSGeuG5TtYj0ILVQd9IYuEtKQgTl6lei2s/CvPdG76l9mvfsN2mXL61WyYAQAHH4/NGtwRNZ1LTyYI0tlNlwojbVeuAAQXs0NPGX60s2Wpq+XkJhcW6BZ1WaxftRuFFKHqRCwdj+YvIYrECHNkn8vP1PwVejUOF5a2jY9QkeYOaaS8fpudQ1zxjDDn2WX823E8AreDJ14+JkYoS8N+4ce7oDiecAM9Nkw1N/jnP0e0wogQn2qhgk9m0npXnFjjDr4Qe7O/dtMA5WLsn6IY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/29/26 11:14 PM, Vlastimil Babka (SUSE) wrote:
> On 7/29/26 10:20, Harry Yoo (Oracle) wrote:
> 
> ...
> 
>> 8:  8e69c83a1e52 ! 8:  aeaf2ab60046 slub_kunit: extend the test for kfree_rcu_nolock()
>>     @@ lib/tests/slub_kunit.c: struct test_nolock_context {
>>      -			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
>>      +			gfp_t gfp = (i & 1) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
>>       
>>     - 			objects[j] = kmalloc_obj(*objects[j], gfp);
>>     +-			objects[j] = kmalloc(64, gfp);
>>     ++			objects[j] = kmalloc_obj(*objects[j], gfp);
>>       			if (!objects[j]) {
>>     + 				j--;
>>     + 				while (j >= 0)
>>      @@ lib/tests/slub_kunit.c: static void test_kmalloc_kfree(void)
>>       			}
>>       		}
>>
>> Link: https://lore.kernel.org/linux-mm/20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org [1]
>> Link: https://lore.kernel.org/linux-mm/6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org  [2]
>> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> Link: https://lore.kernel.org/linux-mm/872bd673-3d45-4111-8a41-31185db3ece5@kernel.org
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org [1]
>> Link: https://lore.kernel.org/linux-mm/40591888-3a87-433e-b3d2-cda1cab543be@kernel.org [2]
>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Wonder what produced this weird block of assorted trailers? "b4 prep
> --compare-to vX" never did that for me?

Interesting. I checked it again with `b4 prep --compare-to v4`, but the
command didn't produce this. Looking at the cover letter
`b4 prep --edit-cover` It's not even there.

Probably it was produced during b4 send --no-sign? hmm...

>> ---
>> Harry Yoo (Oracle) (8):
>>       mm/slab, slub_kunit: register kprobe to trigger _nolock APIs
>>       mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
>>       mm/slab: use call_rcu() in unknown context if irqs are enabled
>>       mm/slab: extend deferred free mechanism to handle rcu sheaves
>>       mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
>>       mm/slab: introduce struct kvfree_rcu_head for kvfree_rcu batching
>>       mm/slab: introduce kfree_rcu_nolock()
>>       slub_kunit: extend the test for kfree_rcu_nolock()
>>
>>  include/linux/rcupdate.h   |  32 ++++++-
>>  include/linux/slab.h       |  16 +---
>>  include/linux/types.h      |   8 ++
>>  include/trace/events/rcu.h |   2 +-
>>  lib/tests/slub_kunit.c     | 190 ++++++++++++++++++++++++++++-----------
>>  mm/slab.h                  |  52 ++++++++++-
>>  mm/slab_common.c           |  81 +++++++++++++----
>>  mm/slub.c                  | 220 ++++++++++++++++++++++++++++-----------------
>>  8 files changed, 433 insertions(+), 168 deletions(-)
> 
> Applied to slab/for-7.3/kfree_rcu_nolock and merged go slab/for-next, thanks!

Thanks a lot!

> Used slab/for-next-fixes as a base for a better topic branch indepdencence.

Ah, I see. thanks.

So slab/for-next is not a good base unless it depends too much on
existing commits on the branch?

And usually it's better to use the base (slab/for-next-fixes,
in this case) of slab/for-next as a base?

>> ---
>> base-commit: ffc64805cebac330b2a60b2f1f144fcc35b8ab46
>> change-id: 20260615-kfree_rcu_nolock-e5502555992f
>>
>> Best regards,

-- 
Cheers,
Harry / Hyeonggon

