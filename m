Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496B0C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1586B00BE; Tue,  8 Sep 2026 02:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662C86B00BF; Tue,  8 Sep 2026 02:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555046B00C0; Tue,  8 Sep 2026 02:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 356A76B00BE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:35:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFFF51C213B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:35:53 +0000 (UTC)
X-FDA: 85189634586.24.FCE4F95
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 883FF40006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:35:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aRfHG7fW;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcsRTcR7UvmGPi3UVltnJ8Mvdqg2EXaylPcDLJc0IKg=;
	b=LGLzejFBHFtJnyH6J7NnVtLWQ662kie2QyXeZLVFQ6MPvoLiwRgWZ/3Mxuvh5rx4uS0FWB
	JOTS/jSDdr5RScP04PKzNTtUxgv054FB+nv3MHgzhzB/GkLgpwLWw2/KZ/tjTKf9trYD/q
	im8Nw2lBh+ZKIqSGccoT/LgNecpkRgg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849351;
	b=sPItiMnlfxXZ/T78D9uJZVWjxLTqD5LCN+qidnwpT+lQ/vXKMKhmPVB0G8QsYctOnkmff5
	oU1RWNC42qRAacs/pav22y9MoYwiGTbfKyBMrXsjR8TeeCZOPPrwFlZ8WG3tq3rvte+20E
	/v34YY1z1A25eKVJ0CRzo0NMCjKlOB0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aRfHG7fW;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788849351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VcsRTcR7UvmGPi3UVltnJ8Mvdqg2EXaylPcDLJc0IKg=;
	b=aRfHG7fWzBd01n+ZTmreTAQEzQYToYsff+nsr36ByOO61dJyTZQUUl1VcMkChkqi7TBvDG
	w2Kb8yPTOBIMlNQ0C4pckLx2RGYFyf9i4QBzf7/ve7toNbhps07YVcRzMrkwCQrHAnyhv9
	m4TzscQNEkw+Y9PCGEFXGlezOxQ/ozo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-gPbOnE8kP2O-yRJR4n8BJA-1; Tue,
 08 Sep 2026 02:35:45 -0400
X-MC-Unique: gPbOnE8kP2O-yRJR4n8BJA-1
X-Mimecast-MFC-AGG-ID: gPbOnE8kP2O-yRJR4n8BJA_1788849340
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 904731977647;
	Tue,  8 Sep 2026 06:35:36 +0000 (UTC)
Received: from fedora (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A93311955F08;
	Tue,  8 Sep 2026 06:35:17 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  8 Sep 2026 08:35:36 +0200 (CEST)
Date: Tue, 8 Sep 2026 08:35:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Gregory Price <gourry@gourry.net>, Ye Liu <ye.liu@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
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
	mgorman@suse.de, vschneid@redhat.com, mark.rutland@arm.com,
	Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org, rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap-spMNyMvYFga5k@redhat.com>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
 <ap76-0-hN6CAcYXX@redhat.com>
 <ap8mgnpE7D4TTrno@gourry-fedora-PF4VCD3F>
 <ap8yoW37GY17pHYS@redhat.com>
 <e618ace1-6a8b-42c5-8a97-44b39dd1a7c7@amd.com>
MIME-Version: 1.0
In-Reply-To: <e618ace1-6a8b-42c5-8a97-44b39dd1a7c7@amd.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k0knV9sBER0BlBuHGwtfXiir6hBNPqxA-O-1gVzM4sk_1788849340
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 883FF40006
X-Stat-Signature: 69ma85xjq3gad9tzroje6y3bybpfa4gu
X-HE-Tag: 1788849351-535443
X-HE-Meta: U2FsdGVkX18zw29y+kStxYY/8/or8pLHdE0Qgsz9lvPisnxM89vAq8QkVc9JAAoN1MT/8fkbbCmbIYst40N8Y67uRF4NoyAmtgC2fSesMY1WDO9IL16Mpetyp9u6sjK4LDJ9h806AF8VkFc7y2K7qo4utLyFBXp/K+ioWyHeF1hg/cHpL8lUGHkbcS/vBFwcM7ve/n/Gepi9DKgI6XVgJgIF1/VWTDQcuyNVEAat9pN1xD0CXUaZxWGyL0az/tJuaJZtLbGTjr/9QUX1vrjjCBMT3PeWWhrEmghaeUKSJnHXZSe98ws9BOynux2y8LiyxT+nJiK+EiEHiSL+u6jBz0azV8NvE1aV90BBQ2kpNbkpfJhMhwWh0ND70wOIRG38a0Al8D42s7XCJLOfyLKPx+CcGAyI0OSqXf12slS7GOINptwUv2tY8ZRW5wGVRANb0sVD5gUq0jlTk06eZtcTfWi6yzNbZL3yO+E3i9IUnA/2Ysy0db5rgbYMF83FXdR42HgmWAPTLpLlDdeaZVzXaTOywJfCbfR3lvbI/+eoQB/q4G3zQQRGuCYkQIjZX0p0K5sk/DBS5xz90aAbZNlx9UCxAis3KjVgsP2tXZo2N+FgMy63Pd2QN+ULQFgqd+EEdFyNeMg50OhzK/u3gyto7l/fZe2C5OiJnsaZHNwzaOmfsYTJSDuYG3qHinDm55de7s517K8bftS7yrfxP3kfCykyVl8amuB3g6/t82oBGEmpciCt+D5UFBISsf/C3YgyvnSe/PP/ehIqI+oUjQYUFhJHYD0ENGaTyn9KaEn9Zo4yfDNjHPAFkyUQfJ0lb3bkO6uG8A+JGMO3mTQy085/50vNxAM30EsqkvwZFXMek+oQ2X01lZ3b3ZnOBWriH/eGOsPNdke6Fal8zdeYAwGuaTzbILcFdm4EanZp61tPqhRDWhk7vz+7sNxj3c1sfiSsY5mJ6kFbRWsF8h44syw
 5kS5YI4u
 sctrYP6hVUS/y0SVY4SZI5COGx1D1F0vLtz8UvTrcj75n42RYic+kolLYpUIwIVRm4Qr7OIS6aX7u4sjPL22z6+W4DhiudwR5prztsvDHQ+HPKXGr0+83yXaJUJNSCfUmHmkAcF0Nv2uh8wU7zxYEG/1M1kj7QA8muKNnvFPcy1dD9BUAj+7olAjWkhTCzXcmOlUJwxiiRJgrV8Q+z+stuM2Wx3eHt2M4/OG4qMH6moUqDMm4Z7o1FsIgJfzKGGoFHXbCTqAenkw93qnebDfLLh3Q+fEqa3/k2Bqnj7CW3lJXM+mrN8jMnYftUfg7X4EkWrd3OGkAJ2YNy2IknFSDvy5vIXgqkbkGTM2v8L9tsNnEm08bCxOdNZpwht3hIUX1+dXi98IelOpGiGpjFHrSQYnW/h26exfWBc/TOzBRXACPJ5mvcy8zmRmyn2ekBt3/1hWqQj1NbhHv509mdTLjYUdMuhj9XlA6k+OxAwS2rryJGEmmIYEiOywZk59MRqHf4haMx+KML/pOYFRE421YL633wj8G0fNCNKLT1+tmaiSnDuSoUd7vT+knNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/08, K Prateek Nayak wrote:
>
> On 9/8/2026 3:24 AM, Oleg Nesterov wrote:
> >> This might be my - admittedly shallow - understanding of scoped_guard,
> >> but does scoped guard handle goto correctly?
> >
> > Yes, it does,
> >
> >> and why it's generally discouraged to mix cleanup.h and goto.
> >
> > Hmm, why? I didn't know...
>
> Apparently older GCC would allow subtle bugs with cleanup + goto to slip
> by but clang has always caught those bugs and refused to compile so as
> long as clang builds are happy, things should be good.
>
> Here is an older explanation from Peter:
> https://lore.kernel.org/lkml/20260327154136.GL3739106@noisy.programming.kicks-ass.net/

Ah, but in this case the code is buggy, "goto unregister" jumps
into the scope of __free.

Anyway, I agree that mixing cleanup and goto can make the code
confusing or buggy, but this particular case still looks fine
to me...

Oleg.


