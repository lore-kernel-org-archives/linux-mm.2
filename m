Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9434CC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4C16B009B; Fri,  8 Aug 2025 10:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75E06B009C; Fri,  8 Aug 2025 10:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C64276B009D; Fri,  8 Aug 2025 10:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B22B76B009B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:55:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5627F13611D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:55:30 +0000 (UTC)
X-FDA: 83753888820.09.9400152
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3F54C40007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:55:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I4JNKxdn;
	spf=pass (imf04.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754664928; a=rsa-sha256;
	cv=none;
	b=cSLmdFIss/2O9oKIIohbPZptif/49I7TbmlUYPy2f1S/QNh075mDH2cVG9WehvwNQtrKSh
	eodFeL7L84dWl8bHzklhfr8A8IVO1pv2l+vsgjAvFHkR2q2acc4PVsuhHIegsK6mVFGxkn
	eWyP+RPmZ4OEqBAfFQkWZ19I10Tw2AQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I4JNKxdn;
	spf=pass (imf04.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754664928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkM3QF49wtdLwhGqe2QpWy/vLyG4tuPu0m+0oSeMzXc=;
	b=XmhMryW3z29YuahUUcPX74hfCrJb34xfWxyAosaxfenPG2ZEs2+KvcQzxN3leT/4WbyJgF
	3Wdp9QzTmQDyDK+v4JzFk26qMqFKipXKm8RUDIw9oVY+2D48l6AMrsXnnVLftHbLxN0D7I
	1sDZegUctk98ljvN38VmoTH1OlP6rqc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754664927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gkM3QF49wtdLwhGqe2QpWy/vLyG4tuPu0m+0oSeMzXc=;
	b=I4JNKxdn6tEWGb+8+LUeSSiuKaUsCIK9Q/PNWaPLcnoJ/IJac4jrCMKeoQvRe/C2bDPZO+
	5HBI5Yxp1s2LQ3KetWYIsvfs2Ee0UCCHWDIntdu7pZaE7vRYSem8J0MYKMlel5/8I2nce/
	X5/wTaLBFUpMZeaSfH1jtlkr0L+YJj0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-M8qeCOvAPA6mb-zvy_eSGw-1; Fri,
 08 Aug 2025 10:55:23 -0400
X-MC-Unique: M8qeCOvAPA6mb-zvy_eSGw-1
X-Mimecast-MFC-AGG-ID: M8qeCOvAPA6mb-zvy_eSGw_1754664919
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2EE8D1800280;
	Fri,  8 Aug 2025 14:55:17 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 36BCD180047F;
	Fri,  8 Aug 2025 14:55:02 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri,  8 Aug 2025 16:54:05 +0200 (CEST)
Date: Fri, 8 Aug 2025 16:53:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zihuan Zhang <zhangzihuan@kylinos.cn>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>, xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 7/9] freezer: raise freeze priority of tasks
 failed to freeze last time
Message-ID: <20250808145349.GC21685@redhat.com>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250807121418.139765-8-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807121418.139765-8-zhangzihuan@kylinos.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F54C40007
X-Stat-Signature: rjtey3xq77ox37cr41yc1hdojrfisynq
X-HE-Tag: 1754664928-75838
X-HE-Meta: U2FsdGVkX1+dyZSDUN1z4G4r0GkJ5KH5kgG13Jf9DouaHEzeEeQYFdnr3NRZYw6Jr53T5aDha+NnegMJUaZ4whHODf+A2xt+fMQBXQF9NyKXjnvhaMuseDRH+RAAyFnR92/+jQaGQV6PYQEh0o/NWvsIc5OGQdcCXAD6ELhBa+zFZzgTyEf6GXsWo9h1FeUFAIRKy9OWqc9N+gCxogdF0tamSAS926ov2spivcKzgLdhXpwZHpt9zR4B17sNoY6BAdRysmfKbrjgRrVxvsOodsqd2wnrOJLaEc4zpQatXF0ZbnNOBG7Ik+srfIAdbl9R+Ik1CwPaBfOoYqMLLTfc9uc3mcfWtqYIRh+6/b7SMwU+AQL3UuSeU4P4kPkhIBX71PjU8xO73Fqn3Eb2rZg29+LloU/Vo0lFAET7rzS6DTgQs51Ktxn861PmX+0wM2XohSvyZ4dlUnr0a25p2K0qFHD1vmhGjitaRYjyLTwFespApbUeOSjfHMB+9GKqqYEQm0DamIE4ycgqTbYyDCvuAzb1jB4a8sdqPchIMQTnh37YrdHRK1BSMuMtn54HR+cbHpwBSJ2EigxSS0+zezWCrc9UaMqVH+/wGshySK0lELUEXtuDsz9QZ/5xtGG5ACQweqridxxNkuu29zMrkQUsSubvsP6KsCmw5ydYqiPamTZ3bUi8Eb17kM3p7KNPQRPLkVHJDy3yrNMvoTkreCYg7IXKAbpNEJH+nKgHWVCytS74XtZMpiBdmtITrsYjhyOeWKvm/GkqNsy8BWBYGUYs1GmHLkAAjpgs3ZOwbzsL9tZ3bZO2VMX/aPnHROrzNmXyBoAdGeWcFyWU+9ofj1GZDjN8TCenOilvksiUffHPh481MAXxSE2KhysnwQncqINlpFjakdeIbHMOvaODUK61Ox8lW3Q2P9D/vW2hNEAy0dP1ucV7or2gxOH6Ko3fC9akCA636qoo66WKWfgIsnz
 UidVqd3t
 sR+XQ2xZMq8y+eCM57WMe4klz/HBT1ln+lTfkMn8T4Xr7vYKpbbFdyht8zj4tjHCGxjHaQ0ihMAkmDNRvKLdHnInV0VtXls5VHbJ0cI3HhNiT/RYJZrMGcaIcrwzvFuf8t3JN7Tq+8HDNTYXhxSp2mif9zgdcnsY7381g/FJM034BS2oh8J10CWr0JRx880YFggi3rQiIGp/CYePgVIj7r6l8U0K9Ia6FA1PnTdIIFS6xWRKsXaoa51fue3RQ79cxbHtws6VP/pB+uFKy14lW1xwdcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07, Zihuan Zhang wrote:
>
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -111,8 +111,10 @@ static int try_to_freeze_tasks(bool user_only)
>  		if (!wakeup || pm_debug_messages_on) {
>  			read_lock(&tasklist_lock);
>  			for_each_process_thread(g, p) {
> -				if (p != current && freezing(p) && !frozen(p))
> +				if (p != current && freezing(p) && !frozen(p)) {
> +					freeze_set_default_priority(p, FREEZE_PRIORITY_HIGH);
>  					sched_show_task(p);
> +				}

IMO, this change should go into 3/9 to make the intent more clear.

Other than that, I leave this series to maintainers and other reviewers.
Personally, I am skeptical.

Oleg.


