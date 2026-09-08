Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08C9C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A1D6B0098; Tue,  8 Sep 2026 02:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12246B009B; Tue,  8 Sep 2026 02:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00F76B00C1; Tue,  8 Sep 2026 02:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B357C6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:43:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F184403E3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:43:18 +0000 (UTC)
X-FDA: 85189653276.06.3D0E1E1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10943C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:43:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fB2QLWpl;
	spf=pass (imf22.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YW1GKuJRhHZmwuIL2WlsvAjfLcvMatnxv0NMJQFIHUY=;
	b=jVT4BcLVVjTPK/w2Q44sjtpJgMZVfvGmQbZxFcaTj//K8NPoKkhFo4j+CoxKyARnhU6YCC
	SHahHn3m8yLJ1hXhu6Jo0m+Sv4ROV0D0xdbB4MhCM5zt4uHqfSnopPv4NmlAk6+GK9sLir
	0is0tPLD/nw6JTIqCuODm/k4Fu8Pzh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849796;
	b=FtLnt0LKqvRQ3Bk/9Qk1xDiQSYpaGQYpClySoFAEW8jNUq99nJtDVByJPes/nu18NaV2UB
	eKUr3rP9WHotT3rAu48OhGWLyBxj/VshHBr80UVdHbpvPwBUZmDGc6xjFUPA+I0pxZO1s4
	/NEjm4ElcpE+mDD4Rhz7UQDW4PxkHv0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fB2QLWpl;
	spf=pass (imf22.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788849795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YW1GKuJRhHZmwuIL2WlsvAjfLcvMatnxv0NMJQFIHUY=;
	b=fB2QLWplubuGKLvm6nSpHWksR0ol0QEx5dCRXATrUhBG62ZBlsfyVYd5vnnYj8DMFn3Tsd
	WTTI+8Lo0NE6n/TAxdymXYTD2xdQJXJtj7A2jGzgqpi1jnnB0WZN/Rb5R+XHsSsly+BA/a
	8FmojXP8+wnfEMo3YTMP4dpSjV+QmoA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-Fpsq7oyZPKmtqFblls1pKA-1; Tue,
 08 Sep 2026 02:43:10 -0400
X-MC-Unique: Fpsq7oyZPKmtqFblls1pKA-1
X-Mimecast-MFC-AGG-ID: Fpsq7oyZPKmtqFblls1pKA_1788849785
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E975E1955BF2;
	Tue,  8 Sep 2026 06:43:02 +0000 (UTC)
Received: from fedora (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 59C205B1;
	Tue,  8 Sep 2026 06:42:46 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  8 Sep 2026 08:43:02 +0200 (CEST)
Date: Tue, 8 Sep 2026 08:42:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, david@kernel.org,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, gnoack3000@gmail.com,
	ljs@kernel.org, sj@kernel.org, rientjes@google.com,
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, tony.luck@intel.com,
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
	babu.moger@amd.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap-uZcmqAr03Xqax@redhat.com>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260907081334.1152889-6-ye.liu@linux.dev>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yd5ZYyBmKc3dfokdY7kKQawTiWpLyj7Yhdl6PxnH1PE_1788849785
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: naiehz5yiqusikchupzdpsppm9zy63bz
X-Rspamd-Queue-Id: 10943C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788849795-595922
X-HE-Meta: U2FsdGVkX1+OBdVp23kQ9P/x6EQAGdkbPm438GfOxro91kBrRNxGPpSOwNZm+/lWY23K0vqkgC45WNM4CopmRRDq2XkTKA3Nyw5EYy3KwVzXEBd9MrBHCKpqt3tC2Y/USdx1H6/fNulMNO0sN+mI9/amit2mP6EuLevKJVUyp1AYktP+CBs8YgB2M7Dx6wyWOndg6tvdST5aoB/0/Jo5DkBmGOTf6wjyLGdyZrj0silZUDlxnxxnDgViQdVKIFu0NBbCUFx3qYXjtyA5R0vQnzTSFzngB8cYxRCAJM5HfqoEgJNWo+EoXrKfZjTJ3vRKg1GA9Y3raQ8wkiiZTNcVxXc/Szms1sISGcvocVFuSi3RseZfbidJUjuUdD8YpFBZXV+LDeO9/ppWxaTBS2NtzsI7zgYcimoSg/BlpqyPMWZZU3kg3sI+vqvZu3kbW1/ICAfsLq5CqZjVF2NmM9ka45CsUmlvoLFrHcsRCiUbyXV5DsZURaORMIdNRH0hIL6lwsj1gFihcuBmlfwnrHUDLQa2zqkWNpyAJd3g4vgjyviWxzKIvaYDmXcAKt6NwWg2XG7LmKfAxK2bdv2ysNK3cUaOeim9fWQ9q3FbTpmhIbiImfILtOkNLQdb88OxFxvOWunJS8HF/8STD7hGXm8QUEaMlDOvlzsreBh4ZfEDnd1MUeF6Cus7Bo1+UZlSahn2Ia1E9oY2wA5JcCLZhqyEy09riZX3wtvcTFuCMZN5PGBeRbDguyBHiNY+OMUuf8Zb39aisPjGFDWBt6z5/aFFbDcZOoCXJml1YHI3oDE5qbeOSIEW+pJ+pA/llStBscXbF9mhsSub0lBviDYQu6XosQ723FXQEe6F3wAXKj20Lcsl8A+n8LSOA907/d99pFqAuhH5LaBK6McV+kGXvlrCfk2h2q8bq4g1c8IvHJlQWmoTF8UsyruIdMWVIlx2TPqp+yeuAfLslbkcCv7qwr/
 LggMsJ99
 4Y+3bnDLke7p6VFFuI8uG82DlmBlDpSm82Z4ICYhqSMWog0EKChVFf4YEkXNL7loBk5uVQhU+Sm1Pq0DPRKHhTF8OxCX2tIQy4Q9JrfI+2WBNJxltQW4gxTn5f4PRRNzSG1BfIG0LfSP+Lp7fMTHAoYZTsmsBXuv8CO7syT27JTHeoTlK755Yg+lpxzTl+ZD7cYflk39JyFbWxy3EjPg6bHXH8dDQB6/hHji5+nvVmC1xmywATJPsLtyuwvVsb+DCelw5el7WxS6rWbnxt44p9KnfijX/H09V+Qhjh/wEhgY0KlYMDc0Lqv7233+tTD0SkHnpzLxbscU0R/LWvdMCpTzdTNOW33Lb3cJCnRJDnH/oOw6nf1fTbU3n/c7PCcuHPM6QWcQqPTaMPmAaD0geGwVVrFwheGr8TLkW7vzd9m7RcyutVP/FJZGYcVrl7cgkFBTVRuXr/GJF3i49RvKsTJ5NyuefaRV8x19OY88CJzRTOfbY9FxM+/r7aVSgakJjzh2zbycYWQjyAZaAOaCaGPUXBOZj/oXx+2pidS4IXu18ZdV5FOXNWEwMA5Wb35C7Ko+lkgFmMDpczTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/07, Ye Liu wrote:
>
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
> pairs combined with for_each_process(), for_each_thread() and
> for_each_process_thread() loops across kernel/ with the
> for_each_*_rculock() macros, which scope the RCU read lock to the
> loop body via scoped_guard(rcu).
>
> No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>   - Rename stale 'unlock:' label to 'out:' in hung_task.c (Günther Noack)
>  kernel/cpu.c             |  4 +---
>  kernel/freezer.c         |  4 +---
>  kernel/hung_task.c       | 11 ++++-------
>  kernel/locking/lockdep.c |  4 +---
>  kernel/rcu/update.c      |  4 +---
>  kernel/sched/core.c      |  3 +--
>  kernel/sched/debug.c     |  4 +---
>  kernel/trace/fgraph.c    |  8 ++------
>  kernel/unwind/deferred.c |  3 +--

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


