Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E4C606C80F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJWgbDpU
Received: by kanga.kvack.org (Postfix)
	id 580E86B00EF; Tue,  3 Nov 2026 09:58:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531F56B05CF; Tue,  3 Nov 2026 09:58:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449546B05D0; Tue,  3 Nov 2026 09:58:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 230366B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:58:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F1DF14043D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:58:52 +0000 (UTC)
X-FDA: 85394114904.06.670325A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0C5E01C0009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:58:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJWgbDpU;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCgjyvSgpq9HtRRmA5g/wITiwT9NMwWO0tA0AqWHdOo=;
	b=nKqMXg9wliojg0VsGxveBLQpiL1Nsp55ADGjvGMzvcfndNXsZgobKg5HLes3WkPs/dXzu/
	X2N/xhsubWYZhOB0s3NuXeX80mCxSHJNB2H+sofbBXVvwN403RoVX8G7KsWkEfcXqeO0Qg
	ZtpRpnERi5Ro9yeOSQ05iRU+oLvlmWM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717931;
	b=CSgzusP+jrSfprsGfgQ3MzEXVT3pLUxUQQHAghOXM0MSSJFRQFpyhCqd/kj5SzVc3fI0LT
	xYGLDJdD9A9uW5JWvDLtZoR+73QauTvLOFtJy98NffGqbyu10PACmiKobftxoqwF4TaJ1j
	KSc7PI33YnQYMd4HEWlzjJSNJaMC87Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJWgbDpU;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5726041410;
	Tue,  3 Nov 2026 14:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1377B1F0157F;
	Tue,  3 Nov 2026 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717930;
	bh=nCgjyvSgpq9HtRRmA5g/wITiwT9NMwWO0tA0AqWHdOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NJWgbDpULl5/IfF/A2iaAsdMvrqVRCq1dRCxgSslUT4SCbCQxEk+R0ZYD8o4BUD8d
	 GZdaUnBFknNdr9beo7nm/L/i78tSSC1a8wnFsu0sj/aGcr94UX30N4xKSMxMzM3Hmv
	 pb0CgMUzBef6Uu0HsSCrtZcj8HN9zZDdRika3LgaAiUlbZtyvncqColrWhRsY8JeMs
	 VxOdoIiWkmrGXSDk5u0NIFBEsMYeOOiJD8EUnsqtjsl2VPuxcajKtoO+r7KSIaIa4b
	 e5Q/JQ0CnebzbKZtsTKJKD1m2FPpPKkT4J2P9TYZ4ZY8EqcTSkoCqVT9nLGXlwk9fp
	 mg/y0vj9QVZqw==
Date: Tue, 3 Nov 2026 04:58:49 -1000
From: Tejun Heo <tj@kernel.org>
To: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 6/6] cgroup/cpuset: Don't make a forking task wait for
 memory migration
Message-ID: <aun2qV-Jaupz0koB@slm.duckdns.org>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-7-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103075940.110308-7-matthew.ruffell@canonical.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C5E01C0009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: scd4ic94cc6ksggcouzqijrmpcdp1m3b
X-Rspam-User: 
X-HE-Tag: 1793717930-202399
X-HE-Meta: U2FsdGVkX18bzEV5Ed667u2HXr9pwPXyym04HzxQ35svZweLbOewEt15dpDlVObvq+BLhxVZun2Fez8X537oK1DWvF4XtzUT6zmV6legEwJ0qwnZboteSrtH6kGDPoWpNGKoSfyI94ExmxVVEcdhN1i+bS4nF5CrvWOTIwIEDqy31ru0LwSrRSN2DEipjRlvON4CP1+UjxXH504uqxyccBAI9RgrqIXmiKQgRMn4ZI2BNYlbphWOgF0TLtCj0tIw6pMqNfycr5IPVXHQwwuPfGqUXTQqiQBw9s+8gPU8jRX7zmOKnwuwPrPzU45KeHsegQbIub4Mw/62D+y1zRREc8TcAZ5TluoI9KcqwCy1HlqjQJmPM8H0ZjTyLoQ606WrX8rYhy8c9bX4/Isyy7M5kFoZ86cVvo9ACjF7kv2Se6lTyRr3DU3dZdkuL7xQhFHcvOexqHjCdYkridYEGG+W181k7aCXd/dIWuXaKepzMRh9LjNlE/krTA+39kPVWGF1rdkglK9FN0BFbQUSThGAVT18JoUnmlKjCROy8TnU96MpXAs1OlZdPvNHvBA//R3rMn+6iu+nAxTCUTuFX7znVmMLlJGSZXVhFRLaImreKNjZwgjndn3sNESz9xGxJnEZEUbimg8MILRU1qOLFDYr35g7xfcWD+bK5qrxa20eFJyQgB1sYXmt/cMHfvhZ0DHy5x1VeWoWamSYjQHjLuYRdYp1quNUi8tC+gcgEpq5O27F5yABtGkBUw4AFx9+EiCFpFUE+xJ90NVLg90claLXFJQypWWeOOvciNOWIDDxksAMLT6G2EvFHozxaDpOfhxJEMqLnVpinEyh2MLXgunahSKYY7PC1OsD3Ahz1l4usGp+xI+D8sYy+a2a6ulnyOKSehiOPOhtOJxnt1NS+qEiDTwLDBqsB17JOI7xeiF61cKorsZb9MyUD0PRq6fi1ALg+BqtRmnxjxcFurc64yJ
 eYg1xBx5
 m8TAaKRLCzDCunJCi6FM3/QOhrTZVihdIGjDPQZOS83Cyg2550PnCW/uQUaPeH+Axl8xfZGeWqhlPMFlKpGfOVt7IUO4WkpiFjD/ZSDTbxuLDUF+R4rrkVUdqSSgJUDxV80gzmc07jB02UAkaXspY9hkL5Pn28OIc8z6NE4UTxOk4qQRd2e5dqS+h3Kneo+oidLhFE44Ye3rooU8nbvLE51FE2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

On Tue, Nov 03, 2026 at 08:59:40PM +1300, Matthew Ruffell wrote:
...
>  - task_work_queued is set whenever is_memory_migrate(cs) is true, which
>    on cgroup v2 is always, even when cpuset_migrate_mm() queued nothing
>    because the nodemasks were equal. The parent then flushes
>    cpuset_migrate_mm_wq for no reason of its own.
> 
>  - cpuset_migrate_mm_wq is a single ordered workqueue, so the flush waits
>    for every migration queued by anyone, not just this fork's. systemd
>    forks services with CLONE_INTO_CGROUP, and as soon as one slice carries
>    a cpuset setting every top-level slice has a cpuset of its own, so PID 1
>    blocks in flush_workqueue() on every service start for as long as some
>    unrelated cpuset.mems migration takes. On the AWS systems of
>    LP: #2165410 that is minutes, during which logind cannot create
>    sessions and SSH logins fail.

The end result looks fine to me but can you please separate the two changes
into separate patches? The two changes can't interact with each other, so
the patch as a whole looks puzzling.

Thanks.

-- 
tejun

