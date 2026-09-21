Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3763C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA72E6B0092; Mon, 21 Sep 2026 15:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58036B0093; Mon, 21 Sep 2026 15:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46A26B0095; Mon, 21 Sep 2026 15:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 885FF6B0092
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:58:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4D79C02C8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:58:57 +0000 (UTC)
X-FDA: 85238832714.05.9FB921D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id AF785160004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:58:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hWLqMgmz;
	spf=pass (imf08.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020736;
	b=EoNPJifsE5AdoyiXZGawG674foJ9HLMszOYQl48ClJuxIrvVk33iFGXIjLau9vamhU+RBv
	VxPbfTs/rLLwNxeMDMrTZqhG/TkLbgMfgU4X4Q/1Oy/CSXWsWRouAmuvKdGgeyRUIElXwJ
	iRhVRnXkKVHRsg4YB2VRQffgkDQToAk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hWLqMgmz;
	spf=pass (imf08.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PQp78DBLyCecA5Hv0HqsD2IBBaq/qhrBbKSaa4Pw6A=;
	b=8dXsWb4QIEeAx4TaukmAEtf6VgOb7FOS88JLzGH+O6jqZfv5jYaofrTP7HLGoXvFEkieHJ
	g9mbAGZHu2lKzWGynOnMZKR4Iyl0kFHIArfgfsxZaCu2By2ndpyfesmeC8kzmkL8OpMfCh
	hxW4DbCVJqWaMRFY+FUKesdgWq55xBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790020735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7PQp78DBLyCecA5Hv0HqsD2IBBaq/qhrBbKSaa4Pw6A=;
	b=hWLqMgmzE1/DGCZNhrcohIzavF3ktqHxHaPGkmTxd+GZPSLaw0GGx2ow1p5YksiNB2Ab67
	xNUXcFwpD6ujKiZd7e+GwSk8uDlyFnyaYxW0sLCXLkmKQHfTojRO5LtwYKrFVgKqxxwzY7
	XgyGVO84fKHUn1WIuqraTYEENgJATbY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-ffI7HLfbO9WJQDXQmxn8XQ-1; Mon,
 21 Sep 2026 15:58:53 -0400
X-MC-Unique: ffI7HLfbO9WJQDXQmxn8XQ-1
X-Mimecast-MFC-AGG-ID: ffI7HLfbO9WJQDXQmxn8XQ_1790020728
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9871C19352EA;
	Mon, 21 Sep 2026 19:58:45 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B445F180036E;
	Mon, 21 Sep 2026 19:58:26 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 21:58:45 +0200 (CEST)
Date: Mon, 21 Sep 2026 21:58:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>, SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>, Lorenzo Stoakes <ljs@kernel.org>,
	peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com,
	rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net,
	tglx@kernel.org, david@kernel.org, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org, rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, rientjes@google.com,
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
	babu.moger@amd.com
Subject: Re: [PATCH v4 02/15] mm/oom_kill: convert process/thread iterators
 to for_each_*_rculock
Message-ID: <arGMYSL8lEZqhRnW@redhat.com>
References: <20260921092101.89285-1-ye.liu@linux.dev>
 <20260921092101.89285-3-ye.liu@linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260921092101.89285-3-ye.liu@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FEIWrZALs0rK76JUu0f98P2-fEhoDWMcECpiMpCdWPs_1790020728
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF785160004
X-Rspam-User: 
X-Stat-Signature: e9ywrioyg3emureremafpof5fs8gdeeu
X-HE-Tag: 1790020735-407673
X-HE-Meta: U2FsdGVkX19ndOC8dQWdCQK8ZC2e9cx8UISRw5TYZReHz4iL4MC0D853ZFvN8mCW1Nm+22JssItZgj5jESrCG98wJBhDY7A7qPKxUWlBSsqDxpzVUNcaznhkHM55lKNAUnP2IwvKRoGroZ6n+Zuq7S4bidRDgvumKg2EEtZN+6OFWLPF7lDhcCSR6URRM5HgEogtcv25Hzjvf3HnxV3aembAqNHmPUUD9FAWXKs+g6SsboTVyTk8RupcBVHLcSyhS9Xlw8S65vcPv7hknXN7/HO55L4Lc91MV46wQWyjL31Em8F3EMwfBygt3A3qtlwqTZMSrRNNXF4bAYQwHPYgerylpkF0y8qbXeXq23PXPHVSFMa+j6WSnFOSBj+L/uNnxbSve9mgJYT4HlBhU1FEZvKFiNpKdHNWuUHJ3/k9cTLyt7l/tAq7WOeKG2z80MkYxCb7lvY11PQmALRGUB8s9Og6+mQwfqNyrUlaCsStstomjDhDyotlRck85fM+u5gp0kuPLLnRdeW73ESW1QYkvlkv/cunAMfXcM4I1Mv0lKMh6WTCuJPdnmQWomKG8hudsU4PJArVQGT9fh89VefIhnQi/LvwaHM5TGxAjZ0ZK8abixypSrSWqC7Ly1e9u5FT6Kw1LC1tqtRUCsJIaaa3MRMs2k03y5/ng9H+DEbx9Utcw3tCmzvDmvBHTepEvz0Pr0RQxc8X9TSnoyHsm3lCFfIPj+bcaw6wq+nfuN2K4bKAea5Ju6688n4XolFnuabizWqndiFC88xvgk3+FNeiEqheQkE3F4XjIJp9ZFDutCTw2BAYMq9QU4t8EcLrZ7UdjKtOe60KQiNgXSik5AeGXjd12ggrEV7l2FcaE5TMyOpwFlletvqEOyqa4RHnu6ukZT0qgm4d7DEhmKUx7OQvBSwoXNhCUUhmpsx5k6J0XOyhxkDiTSvrVTj3hVN/YYUTk6yryNAkmj+VtY8ulp1
 ZyGzz9E0
 OnYf/YuKSwiV6vBWy8SCx3vicmh+++mwrlxR6WfnUU2Yl3XrZyW8gHJAKvLXzCOAStnpKWM/HhTDBcPGTAkqgxvf28nES9+YgHjb6EBNPkt4jbxMFnVjtMjVA7u90Z2VnhjXd5+tvW4dMp7zd7JkWr0mfeYDh3gsc68NEXqZRiz3+kJiptWRsGMRh2kpeJ6de08Ns54ldKptZ1mX90PXcWfQwKcdMrouf8eeuFFE1y8VWGFQqLpqTxtvBhMSlE4W1D35MJ0l1Cf6MatgpL6JOfcG8V7tJYWLPJky0q3IB08BfTuORBxMvceonGyWVIZ2SpGaXysTN4N2UWZiJBNVez3KqTeq5+WdB75JzVQNkVGQSzO8ON28We7JRVv254YEWKONn9by2wV6MnofoLUQ1uYGaAQbPTSH/+hGSTw5W3NeMeL4ri9GkMws3cj19zIcNzSolrMTVg1LGHlpBTdJCM26z4BIJ99t0oN3PC98u9GtKFeO4EOZKgzPlsassGXjl5VhYV3kr4WdvTtkvmSmnwNoK0Jk4NOtuYbojPbUG5IoHyjYp109mEe6cN3nxsjV93F2Mbca0rrC+NYEMVGVe99koV+tq1JrSy06Midgrb6G8AZdfdPyg3J31CPtvU8p94arR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Ye Liu wrote:
>
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs wrapping
> for_each_process()/for_each_thread() loops with for_each_process_rculock()
> and for_each_thread_rculock(), which scope the RCU read lock to the
> loop body via scoped_guard(rcu).
>
> No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/oom_kill.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


