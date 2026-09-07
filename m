Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6408BC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2FC6B009B; Mon,  7 Sep 2026 05:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9E66B009D; Mon,  7 Sep 2026 05:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407456B009E; Mon,  7 Sep 2026 05:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3A66B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:36:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80A03406A9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:35:59 +0000 (UTC)
X-FDA: 85186459638.14.EF76A6B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 50D9B120008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:35:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jv9i7mdD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788773757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1OruMYcQA77jLKl8fk/VE7hjZNXJ6hFvLeuBJHiyjQ=;
	b=tQxWSHpJ9+SNJEtcQicEva6B7zyqTUFGGOm6xe+cap5cCLHlJMgtXhWgq/a9UH+UfmeN8p
	odiQnlyOTcnYfMdVHGgK8WJ56kLgdPgFNdITX4andwSKLocY4+IIsreDyQFkH2K+q4aCWU
	WN4Xi1w22GS19WPTCzh5jfAmM8TgjxQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788773757;
	b=0sO8PbfY5KCCfcafDfHXW8dAHTIgEvAcMcsml3WwA+hsCMb6XIGkx8gtFrH1dUXRxTrmRj
	nH2ouLaaZGy/MtiRF+gcSrq/zM33JSMJT+X0McHHyr5h/eAcimeAV/Xm79Y9CsXj7YREfZ
	ofOhX29NrcxOUXeUXntuIS9CQuQf62A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jv9i7mdD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788773756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+1OruMYcQA77jLKl8fk/VE7hjZNXJ6hFvLeuBJHiyjQ=;
	b=Jv9i7mdD649mfE/9olGdP+jD0BCkOBZiBYjD7wlmBi4jjFH5Tggp8enVm3FF2ZZYBm86u4
	zMyDszNTqSGUjvAPufQwDJfHh+2BoKGTnzmpTsLxuutbwaT9zsncgjBEfQIFJGZtWolgNI
	Uffbz8m7Lhpva3miKTT1oXdyljV2+6E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-F22W0QtZO7WXHkUBv2Umag-1; Mon,
 07 Sep 2026 05:35:51 -0400
X-MC-Unique: F22W0QtZO7WXHkUBv2Umag-1
X-Mimecast-MFC-AGG-ID: F22W0QtZO7WXHkUBv2Umag_1788773746
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8DB2D19539B1;
	Mon,  7 Sep 2026 09:35:43 +0000 (UTC)
Received: from fedora (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id EA98D1955F11;
	Mon,  7 Sep 2026 09:35:22 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  7 Sep 2026 11:35:43 +0200 (CEST)
Date: Mon, 7 Sep 2026 11:35:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Marco Elver <elver@google.com>, Ye Liu <liuye@kylinos.cn>,
	Tejun Heo <tj@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Yi Tao <escape@linux.alibaba.com>, Michal Hocko <mhocko@suse.com>,
	paulmck@kernel.org, mingo@redhat.com, rostedt@goodmis.org,
	jpoimboe@kernel.org, mic@digikod.net, tglx@kernel.org,
	akpm@linux-foundation.org, david@kernel.org, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com,
	ljs@kernel.org, sj@kernel.org, rientjes@google.com,
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org,
	frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org,
	pmladek@suse.com, longman@redhat.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
	babu.moger@amd.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 1/8] sched: introduce for_each_process_rculock and
 for_each_thread_rculock
Message-ID: <ap6FWZ9FYjkFKoH_@redhat.com>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-2-ye.liu@linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260907081334.1152889-2-ye.liu@linux.dev>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ToHy1tTQg6w-3HuMgiDcpa-6UEgDn0MH99HKqw_A648_1788773746
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50D9B120008
X-Stat-Signature: 7bznpimisskw5csqz5ggdpdmnr9ejq9h
X-Rspam-User: 
X-HE-Tag: 1788773757-358907
X-HE-Meta: U2FsdGVkX19SzHstKYR6SlHCzIwnPA28CSE7uez62L0hNDQl708HWQOEMUwrr05mCmzSsnSoRgwR66U91hFKsPMKpKPBf641EsaiEohVkKUEsQWA2ppIOnMMl21vHwNU5OUdeKApR5zig1nSQJ2wL/2czRx41xkp5N73tm6hQ9/qKEs/LdtrMov39oIM1YX3wsb2lTYughUfRFQO8t69zwkxQyM4+TwmJ1+vI1viFhhEgjua6OUo41MV0HKchstWQlTBQnkCYmcO6FCSP8zOwO6LC2TJUpK7W6I0XhMzgCQzcANdR5Cm7jRr6swegJAZWgMm9zpdFDs4xS90tyR5qb9t0tBbZOZs37hWawEs3yAEvPw0embikYS3/KZZdf1NoxuWKvL/8UmmnvzXRx9yk4HO0eqR4QmLUUeB7FGCiT6BFH3g9bLzNzT0Gv8UpzjCUPKsEBMy9sq/X4qOYI5Oedt0JyXZSGyomSm4MnoC1/A3/wR4VOUsUxI+SqImV+JMlUEuMEXFN69V3LYpRNpTH9qlGpe8eSp26AiagDjERNIRL3vbJpHHOUvaySBtaP1vkQOdVKxzN+8/S+DwaJye/KcSCaJznt8a3p0P5rtfRZJPnKs50+3ztpEPIUsHC5aOjfBLqEILcOwRpWA5G7pGQJiDuM3HxusVjSC5fMMrPsweF87vj5fPaY31bToUuqRsQ8rKn5MCiYqos7t+UMQS1XbBrFwN/HY9KvX51gTTADOJ2Y+LpX8eg4/e9ScdFWlaq2n8XTT7Nj/BMYF3RXlG8LjnhSGh4wCsbU/BSQwmedxsWapEiJxxRTuekIlu+FSorkErQNuZSYhaFlCCO5ESisqb7E0dO2+3EIkF6XHdgKj+LjN7Sc4/ZU8FNVLIii7gqYQQA1E9k7yCZ00f5ilRIU6mho8CV3IvaGd15VwlBAIcymCegIgfDWEdXRJKEDK3x9zhviat3pe2PjcU1Ct
 18u3CJd+
 tK8YEoIhj3WoRg/rfMtGKorA2cigA4EgafAhWsPSMN8KBFiOUw9qjaO3G6qErsg1JMCdXUh0uyfoYZhE+Uds+7UV+xuAOzp6UoB89IPzk3MIQ2Esh/7Q9IUFJOqC4Y81ItqfimfTN3vx3UKtj0EDRoeBPAHxgCunf4Nw7yz0WiugPpRL3H4JU9Sdsuao37M2orr/DAANigYGT7aIcVZ7tBvD5jGXQodbVH8F6IBuAda+3idTuSbEL3+x4/eGN0rZ0BVDtMgMpug8V0uhQ9lMAsREiOzrjc2bcIanb4gBQcoPle7SpYGfBd5y8rVAHneY2nCU9PvVf+z5oDuebLy1lWWLPASju9UU3XlCzdGBVnnwUCnpp1qSAuw/MXXE1+xWz8Wb15srMUOJ3ULcM5Dg/eYS2eGmAQ2rDRfMSSNYGJ8rJwDruU63bwsyhne+q+zQZF8wBspBPVktDoc5rp5VMkoi2yV8WwvG0l6R8T0huUi41yOopENmo/s64SmWGXI60ChTvrVVh3FoYk89QXgF1cuvdlSiGO4yLeJesyje8VrjwmKdn9oEQy7vToA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/07, Ye Liu wrote:
>
> Introduce for_each_process_rculock(), for_each_thread_rculock() and
> for_each_process_thread_rculock() macros that acquire the RCU read
> lock before the iteration starts and release it when the loop is left,
> so that the RCU read-side critical section is scoped to the loop body
> instead of an externally managed rcu_read_lock()/rcu_read_unlock()
> pair.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks, I personally like the new _rculock suffix more ;)

I see the comments about indentation from Lorenzo, I am fine either way.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


