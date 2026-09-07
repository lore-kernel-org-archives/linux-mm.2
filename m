Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4E8C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 22:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513786B008A; Mon,  7 Sep 2026 18:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3DD6B008C; Mon,  7 Sep 2026 18:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BCB6B0092; Mon,  7 Sep 2026 18:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 055936B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:44:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7530380306
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:44:53 +0000 (UTC)
X-FDA: 85188447666.11.DD804C6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3205314000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:44:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ifU0TlLO;
	spf=pass (imf23.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788821091;
	b=6Y94XDlPxXdhVCBelKEWl0Yk7YRjhFLDidZYOa/hhG/5s6VaLv8klGrw9zOfIEcA5a6scS
	XzUYdr+EFcDccX2mXZ+easuti8dGnXlZX3ZorEu+eDb2ei+L3MsNFNcKapKFc3SHI3qBXI
	FS8xcLnNP6JeSi3JsHbNR/JXdMy6huo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ifU0TlLO;
	spf=pass (imf23.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788821091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1TxJUQX49cLbWEB/ivNKBx96Wq16OEvm5/00tKxapE=;
	b=oo0uc6Co1Am6AVk0tMOLqXhWMRSAjL1txT1J8Ir7cJfojZNhtVkH/EdJIFgdmeCy9FL08E
	jnbJ0I1Fl/OTslbdohE/S1c34vbqYM3D7G0ghSqQv4cpd8dK9lfLOjmWDcdY5lCJmmrcEP
	SpVSgW2/La3OIl2Hiy/F/cgJ/Caflcg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788821090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b1TxJUQX49cLbWEB/ivNKBx96Wq16OEvm5/00tKxapE=;
	b=ifU0TlLONe3nud6ubW1riENqD3s+uP06N6CTzhHhqniAg2/IdibJRwPRBpImVZ+qWRJz9M
	gbz9VOODDFwSEH71yaJKzUqTdHD2PtIoEH6JI8uG9WEsZPPsPh6fkLWxEhb/DB7bEori2c
	xcxMjALo/qiuKqiwdzx0WA7LVKeVDAc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-504-lxKgW3M6Pd6dwqHDQiJn-Q-1; Mon,
 07 Sep 2026 18:44:45 -0400
X-MC-Unique: lxKgW3M6Pd6dwqHDQiJn-Q-1
X-Mimecast-MFC-AGG-ID: lxKgW3M6Pd6dwqHDQiJn-Q_1788821080
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6495D1802658;
	Mon,  7 Sep 2026 22:44:38 +0000 (UTC)
Received: from fedora (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D48F11956042;
	Mon,  7 Sep 2026 22:44:20 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  8 Sep 2026 00:44:37 +0200 (CEST)
Date: Tue, 8 Sep 2026 00:44:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: Ye Liu <ye.liu@linux.dev>, Thomas Gleixner <tglx@kernel.org>,
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
Message-ID: <ap8-QwC3JLDCQdcL@redhat.com>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
 <ap76-0-hN6CAcYXX@redhat.com>
 <ap8mgnpE7D4TTrno@gourry-fedora-PF4VCD3F>
 <ap8yoW37GY17pHYS@redhat.com>
 <ap83lNf0bUXX4ZS8@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <ap83lNf0bUXX4ZS8@gourry-fedora-PF4VCD3F>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XaVMjlmPQhUCS6hwi9YtypCzFbeKj9gKOU9qsPkhzD8_1788821080
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: 1jeyzhzgz1o3a8dduxnqhqraahnbcp6h
X-Rspamd-Queue-Id: 3205314000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788821091-763645
X-HE-Meta: U2FsdGVkX19TDMpGpdzxXN2NsA5j3SjQ/rTZ1/tCNkqimzKZ2DNGsnn4ci8kPPnHVWtDButrRzSad8lDdWHud5dspYNCdiOtyUhutGqPKsYKjj68c8Rdi49Wjx0tLzhvOkrXf9wECzCX0u0Xofi8iyNyAzgkyX1oqQYaCjzi16vAoyyXJeK5ZndyhTSEILx6lqFqXi3B73MC2JTdTxAd47MO4kewo93h9qEswoNIbnvnlDYd9n/zZOrIzVBaecaD+5I0MN2A9d7GD0RUrB+4DPUqbIUG3v8X8VytfXoaHX+J0Y3ZOvFGJGFrqnXhyg0dTNM5MeVBWwVfCQX2W2TT1hBLn6/Ay6Tee6LGMjXpGfFTW90qWTi1cIH08atFR0Pf8pBuKtQTnAvFqvPOzwKFRlUC/kmVIZxUIBWZqSAug1PueB9FHyVc0yscVMZuBzASiDcGKZX1x18NvdX5/DrD5Sufe1PFickudYrs03KrWKbdrnMH+nIjF8knIIR+3kFydO97VVW70pLIKk/ylM/oQHIfQyyl3FJh9PhyaBIFsYfDAHuGORuxXVXcUycfDg0mBacWX4L6FY81jQW04ctoeB23nX7mbdh/nCRgRLYwSD0a3K5cK+++yEQtRH4+QMfeTbvnGJjyGUygh2YT9xVvBPhl1jHmb15YX1fsDPxCkhAZmZouyD56Zy0Y7+knebtwBIJCvRvODr2J4nmww3/oQ2ag2OF3oEtZC99GTsIDA4Ii2B9vxO3XVhRp21QCZj5KHK3NOPGdJiLnbtrhOJ2kkqEVIvcfbs7ZzXZWH/yyTYKFLKS6xsDZ5bWxNkBWAf1yeBgck2iszGgtkphT9Z2sGom35xAIbqMWRxQMUV7xkDswsL+8LZqApo/+qOpULV8zXUv0az9qNoNcrrpXKKtL0RuafUCUTyyVwq9G0fNaC0pGE8aYUyScUBZGZt/Na0XYCawD/Rxm1KcnnHB5+la
 F8qdCBID
 y/gH4/z92Kpb8hz5GGOHTxEYYbvTd9X9dolXOG5+6Lw2A/MQB2wr0rPW3GiYqyfGuwfhv6npvWtEzySTPZ9DxWt6fYQBMlq38dLdey/Nvtw+ye9bXUxsx6EsJI2bDMB0XP0R0ZnDj/iUkQKbh3iWB426i/DSUgrQT/WIwybTOX/0N/bmIjbdBjM4u1PSVbVSnfHt+ljQ9US6qwYb3pAgB8gxs6aMqcjvDZH61GGGPPAuyDbcdXOwHFnkEQ2cI3ZTRD3JbnNTYJfBi+zkckBJF6DHhLw0r6AYqXl5AhEXdR8I+UknOVql+KlTpKeLWPLPEtVlCDqeuVWosTUMmrTPG8pOjmLsJJqgdZys4YlR9XugU0ao/+ES+3pnokrw91n+dGK9414ps9HSGCf4ppUjE0ZuYtohkj8OeSuIG87rVhEFB2plREOhtWlsouCCXGp+QDqbW3q2ld/6RqhrZ55p3yJzOoewOUGY5jt/2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/07, Gregory Price wrote:
>
> On Mon, Sep 07, 2026 at 11:54:41PM +0200, Oleg Nesterov wrote:
> > >
> > > This might be my - admittedly shallow - understanding of scoped_guard,
> > > but does scoped guard handle goto correctly?
> >
> > Yes, it does,
> >
> > > and why it's generally discouraged to mix cleanup.h and goto.
> >
> > Hmm, why? I didn't know...
> >
>
> one of the reasons to use cleanup.h it is to eliminate the "goto
> for exit cleanup" mechanism in the first place (says so in the first
> paragraph of cleanup.h).
>
> Later in the header is explicit says don't mix:
>
>  * Lastly, given that the benefit of cleanup helpers is removal of
>  * "goto", and that the "goto" statement can jump between scopes, the
>  * expectation is that usage of "goto" and cleanup helpers is never
>  * mixed in the same function. I.e. for a given routine, convert all
>  * resources that need a "goto" cleanup to scope-based cleanup, or
>  * convert none of them.
>
> This particular patch only does a partial conversion - so it's a
> bit of an anti-pattern.

Ah, thanks, now I see what you meant.

Perhaps in this sense this particular change is "anti-pattern", even
if "goto out" jumps out of the scope...

To me the code looks better with this change, but of course this is
subjective.

Oleg.


