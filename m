Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B322DC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541326B0098; Fri,  8 Aug 2025 10:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518CB6B009A; Fri,  8 Aug 2025 10:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42E8A6B009B; Fri,  8 Aug 2025 10:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3078F6B0098
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:41:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D30E7115730
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:41:22 +0000 (UTC)
X-FDA: 83753853204.24.79979A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDB0D1A0010
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:41:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YN03PxWa;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754664081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVbXlbyZjsINekjOptSlbtwiYMjqyKFTkplWxm4uz+w=;
	b=H46b6QVAgolt+7JYv7sf0kq0LfBPXTJpBscJiU9Sq3b62eawhz9ppWWX+9I+ThrH7FpSGl
	rjXC/erYg7GWaN0DCC6xej2/2P2CtMt7JQzsuTp4p/DauJPzjdtiMjxvHXgeRo4j86/ckO
	+lPvMGH0WK1XCLSmHw0m0fXRVB+lpRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754664081; a=rsa-sha256;
	cv=none;
	b=QCKODPLD+JVK6PBVoodhXT86iUqP2L3PLEMDym5mAG2avA3lllv6yKBX5/sMiwzYbMa06U
	vpVcJDyot2dPTj98diEyHdJjn8Wpy3/fmkP/QcZQbYE/YkxDvVAdM+ZbghA5eTeGXu68hH
	MP7P33asha+nciOMPoBOkmCEnxTRNIo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YN03PxWa;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754664080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CVbXlbyZjsINekjOptSlbtwiYMjqyKFTkplWxm4uz+w=;
	b=YN03PxWaqR20UyndbxcveUnbRRRm5qXa0ohIr0KMO2gbel14Ha4FK1anyNxrRS87faHPFq
	4TAuo1XYxyHccXl0G59UjlQ834j05QiC/2dWWZTNHveSshM5OKRkNUBWPNKV6796tUgAfk
	zbNEQqH9rQpU7vG97hcNILHguFlSyso=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-raJ6zeyFMcWE-g_6SowfgQ-1; Fri,
 08 Aug 2025 10:41:17 -0400
X-MC-Unique: raJ6zeyFMcWE-g_6SowfgQ-1
X-Mimecast-MFC-AGG-ID: raJ6zeyFMcWE-g_6SowfgQ_1754664073
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CA0619560B5;
	Fri,  8 Aug 2025 14:41:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 8DD2A180029D;
	Fri,  8 Aug 2025 14:40:55 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri,  8 Aug 2025 16:39:59 +0200 (CEST)
Date: Fri, 8 Aug 2025 16:39:43 +0200
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
Subject: Re: [RFC PATCH v1 5/9] freezer: set default freeze priority for
 PF_SUSPEND_TASK processes
Message-ID: <20250808143943.GB21685@redhat.com>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250807121418.139765-6-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807121418.139765-6-zhangzihuan@kylinos.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: EDB0D1A0010
X-Stat-Signature: c7qcya71sau8h7j8mk66jmfanq5x8ufo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754664080-512380
X-HE-Meta: U2FsdGVkX19Mbq+D2R9u8dFr4FTiqnACi3ZjRmZD2qSwOuJ27GPYtcfsGVEU1cd+njcfTVED8fMw8XMTM5KJ0NDSjiar8NfvUxj2/fMFVrTV9RxC31+j+dEjOyObmJBEVGPB9hLZ+C/ebhRtEyVXmZ2/4yzunf/B2oKRkJ02Hp54xENIx0jQSa9QDEvyrHqlAv4XTFj/K9AxXmtZg0kKx3EF7Z1k2ByPAtGhpjB1NehnZtBa4UCnWrnfIipuop6IDvkoJcSuLCyxmWY4WMBrpinvcboKZRZ47GL8GLwRY/J2siLfVoOZokNdZXimniYIWiaBBOMUyWFIXSuJiJZOA1Nkj1IZ+VOVEXbnOA1sj8PBk5s0iXLZY6eI8lnCbhg4oVuL9ps6VgC9ThJ5rE/N0gd8Vve/FYPYMJuYsvZBlT/2fYkE/Y7nJDfhFKImNvjfKkuWy7OVUK+K8ax19R7+yHDIaAtZEiMoLq60LTJtgQELT9ca54yb5BLwK5WzsS7Loz+xLizpRRyEzMoNpm3O8AXb8n+H+A7sYOTjGa5uokioTxqBCYA9dmgAIsXgSVlriqTaqbyxqXOZhNdkQAOoK1UrTnUJm0uAM2973TlUhLyJPpOEDlD/UkGF0t3kzNK7rCq2KxV1Z1QAATwZs5RklYOa/kuH69W5TXSGRtHLxfOPiPDjAJhBydsljzXvgOWjh1dsGYXsFe9lTgFmMcebnWI8VMSELYSt7jrZMULWOaiV8LsF5rLtYzJKa1RUxGzD59mUUIkRcl44Zqwxnd4aF8P9QjHy6PFOvzHdn3jWACOCsndI4Su0M03Y2qzFoJrr51WZRvv0c1IwidJ8gMpBBTf5R47W1CZuoFyLPZ23NMAkgkohm7//tINKEjra3FvVry+Jt29AyHpJLO9nprrtjV8LplaYd74At/OjFsgLwPU4jOgzSx9W9zuXDztz5qTVYijSLPt43BrStujqKEY
 9CWsaVK8
 trE3UYyH/9dXEL2p+QPFd5pdsayf0PH+NaVNfy1rAJkFm91YkGHvoUIBqoeDDj8mzmdrn
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
> @@ -147,6 +147,7 @@ int freeze_processes(void)
>
>  	pm_wakeup_clear(0);
>  	pm_freezing = true;
> +	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);

But why?

Again, freeze_task() will return false anyway, this process is
PF_SUSPEND_TASK.

> @@ -218,6 +219,7 @@ void thaw_processes(void)
>  	WARN_ON(!(curr->flags & PF_SUSPEND_TASK));
>  	curr->flags &= ~PF_SUSPEND_TASK;
>
> +	freeze_set_default_priority(current, FREEZE_PRIORITY_NORMAL);
>  	usermodehelper_enable();

What if current->freeze_priority was changed via
/proc/pid/freeze_priority you add in 9/9 ?

Oleg.


