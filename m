Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E002C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599806B0093; Fri, 11 Sep 2026 08:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A666B0095; Fri, 11 Sep 2026 08:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487506B0096; Fri, 11 Sep 2026 08:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24F806B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:58:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BF951201EF
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:58:24 +0000 (UTC)
X-FDA: 85201484928.01.F8977F5
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id B1F2914000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:58:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789131502;
	b=hQbmTTDREo3DQ7tGUTAYEEYQrZtx/gJuB1a285Nk9+cqzYR59nrw4YDZtLvnAbw7kPfxxJ
	/mv4cELknMj1TfgN/nfd+IID77vTXoctEqCzQnT4CwPg/3qvi6+p8Yf56j/2Rd5PGohcCS
	6vlRWIew5YnZjX04WgNC/TfTtXKkQts=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789131502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaQYdknTmueyDeiPHskDcTArMbJldar1uQP+OR5ILiM=;
	b=OwHfM0okjnZ2npx08djpz+IrPAPfj4DU6uxBeZlcMKdqQE64YMC2nj8I9lED68a9KaascC
	L1Jl6P+XlNV5/F/Fc5751ObGf5Q5lhoZwGhbSL5yoJSqxBsaRiAlYz/TG4IYupQ7En8Rzd
	FfEAiQRks8Q2nec46f5FdHq4MCpKyiU=
Received: from omf02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B13EA023A;
	Fri, 11 Sep 2026 12:58:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 411FB80012;
	Fri, 11 Sep 2026 12:57:57 +0000 (UTC)
Date: Fri, 11 Sep 2026 08:59:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Ye Liu <liuye@kylinos.cn>,
 Michal Hocko <mhocko@suse.com>, SJ Park <sj@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Oleg Nesterov <oleg@redhat.com>, peterz@infradead.org,
 paulmck@kernel.org, mingo@redhat.com, jpoimboe@kernel.org, mic@digikod.net,
 tglx@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, rafael@kernel.org,
 gnoack3000@gmail.com, gourry@gourry.net, rientjes@google.com,
 shakeel.butt@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 will@kernel.org, boqun@kernel.org, frederic@kernel.org,
 neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org,
 urezki@gmail.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
 lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com,
 mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
 babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 11/15] tracing/fgraph: convert process/thread
 iterator to for_each_process_thread_rculock
Message-ID: <20260911085918.30c87ab3@gandalf.local.home>
In-Reply-To: <20260911075800.491472-12-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
	<20260911075800.491472-12-ye.liu@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX184cgL4CPzpG6wyU7gqy6pHH3IT2rF9ets=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=UaQYdknTmueyDeiPHskDcTArMbJldar1uQP+OR5ILiM=; b=0JqVOVv+9L81lkGml08i9mMS8B782yjgSSh0J7qB8NJfLJbXU0fLz9weZAM4fQ5Ra9CUavRTBo+PCH73WKm//G+wNOzwNoyxnF2a7JXOtbmdL7tZR3SzwRbbk7iw2rNQVN3kwRcItAAPl3JNid1xBW4naEquTGk2Qi05wOwcUrA=
X-HE-Meta: U2FsdGVkX18IEJ34TJ0+KfkZrrzHJ2dGti8SCtUwJBxnBs7A77nAwjwyHWgBGGkRmcWxfRbbgYYDx9+//1mp9vVOjUQbCfr8JwoUfq6qObLo5XckYsaDveVKT4KVuSxa43lMppAHrfkQ6q66hua38QSWiGZ4pR4WLuiB/fRlv95rgRSwCTUef6/9xZIREFm6zARLWSxhMwm/+USXJ5Odeo33wnQhHtMWXVBSR1fuAOuRDXqRFn/VmuEmY4R93qX7JzsgtbqMZNWtX+CwTgbkKXii7THG1FmHcDAGAFH4eWA8QubRpp9x6o0Bf0fFFGOxvfWU4KGfGsEN23tdH4CEfp8DdKmJ89MyETXiouFLfhLA9mjoesG1uJ4spkJ5GIdarVsiaR7bvBIJXGMAkAiEBCCCpjOlciuLokm1pcCBCZvkrE1QZjTT39frBEzytesHCZdU724fPrc5uye0+xI5ILZJA4Ngv6OQ1x3Efp0PWJo=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B1F2914000A
X-Stat-Signature: n6a6yg87erzr1tr8kadm4kbym8uws4c7
X-HE-Tag-Orig: 1789131477-955751
X-HE-Tag: 1789131502-809749
X-HE-Meta: U2FsdGVkX1+gXh3FNCndjEqWSsFhbCl9LDJF7xkq9JW7VQZGuFz10ST+t+ZY/3RpVHJ2BgHP/lDOAQWwUbNGcXFLkljqJVAB/OrMECwoYNDuVNkUl58LCXpsUk/ZgiOZ2DJLErEGCfBDonN/IcJya7V3D/vkd05GLVbyUvbrV3F/4u0X4o3ZIl41YbOlz+mjSQWDpscE+qZnMnHWYab22LLWNzup0iuoEQpbQDG+gjagEF0CTIoJ/3xdds5NqJDGR9H+4BT+CJ91/Vq6Hs1LisRzGd1L6mbkZQPOpPoqzfV/BKyr50Md3dooZE6Gh0VLp0rV3Gk7oBgoimhuxH6Y5I9+sGr/TOkjB2SEKEwU0aR1lVP6gZaQIsBjCw9vesIHv6qLl3rTfNfmSE+Czt0lO6TKZkQd6ThAv97MlpYYOpjkC8TKQ+sD/MyQjn97MQEnoVEOZ5zuGUuqtWEU4Ph9Q9E0S8vzQvo4YNn0XOcVDjzoVuN/2jkcjyzZkcW5lk3JujbRQYh4a4cIWV0Rq7xjqbVHrwUG8j7r/snghfqi2inuy8Z47yPDqRJWcPhj6GuI3z00WBtGTVvA/pUq69F61X/kZtyoefjLdKTdzfatIjXsvTDeqoqbnAbJ1Cd7eTARiVHqfldv6BxuQbdDDvIEVV0h1IohBvZDYnt3dTFbhLiSqoABpwv3/nyxln/u7h0XiK9Vfe/pTTg6WtVzmqmKpFEedLBNB63cklbAy4UsRNUuDTcs35VCNkeehnhKOG8PfL/jhmdaXxoodOwaaYJAzaOhVsacJ/9eM69d49aemfFyWiMRaU5FeBA6sUPfWK/H/umfhMyfykm6T27uWkdtFrSbF52IsNU3Eg4EwG11gcf6XC8Uhzd4ZJA3BqolbyhoF1K4CNMlQ81DSP+EEcIA1WA/UwrCB62N0Z+Ci8FKjIJDyWIKLYzrvPLYkSCPvSyYIFQkx+tgnXYM10RB9bl
 6e33VUpa
 0ZdPdKh70zuN1BWgmHU2vjZArE5ox7o5cswZQFMHM5TC/4qLQk1Jn62Zm9XBDmZE36c7aKzEOSgTmt+ToNjttTJaQIgu11vLTBXTth8FVHCAh26qtugmkhH/Tr+0s8jsKGAGDZ0OrIGdD0KjBXESBsf6490AGzk9XXUwSKmRWhtPSdfgJ/WwcESzm5lkDqdQVROOAyexvtTSOkF4lHwtDYZiIJg25pmE2ELJV90ehb1uLzvMymI0T06YXetDPk6S26XWaN5sTW1A2IIV95nVbZWWqIMG2cBt1r6Ox87eAC/GbFeoiWX0lFULUapSQuuADCfTlmm2HzrKIk+c+tetAL3G+Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 15:57:56 +0800
Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process_thread() loop in kernel/trace/fgraph.c with
> for_each_process_thread_rculock(), which scopes the RCU read lock
> to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

