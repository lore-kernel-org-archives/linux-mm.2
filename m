Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C4AC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2588E002C; Mon, 11 Aug 2025 05:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25888E000A; Mon, 11 Aug 2025 05:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A137E8E002C; Mon, 11 Aug 2025 05:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90AA68E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:44:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 680DCC0714
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:44:31 +0000 (UTC)
X-FDA: 83763991542.13.7FDDECC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7AEB580004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:44:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PEK8J9K1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWAq+VNH88+5aD3C80O8tNZjd996k0N5ELPJ0iNyg+I=;
	b=wIAzplISgp8MPtHG8Ak7/nFmyCcH7VWuEBXIuimdOIG1DV4QZvvOpMLDTUpKtU4bX1YI58
	cMSuF5W0v8bJax8igPzSPZ2N4oOgipGj9ympO4Neaord4K8xAraxdRUJPVuOd5dE0Mhuih
	U29ZmnTUFRXE9dGnzT0E6upxfMa5qFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905469; a=rsa-sha256;
	cv=none;
	b=eWzBMmPRAIkWchJHjDZMw4Nk40qb2wo7YkHdzhBLsa9k2UB644VBoNgYsXoSnlFw2w7E1R
	VArXrk1e2Kg+MHbG8dU5YeKqDkVITf11N/iRY2OvDNCoMJjA0tlMzZhpABvGPOQ2veU/Yc
	zALdo2gReTPO/oYjnEknWSOXdH4mykM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PEK8J9K1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754905468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aWAq+VNH88+5aD3C80O8tNZjd996k0N5ELPJ0iNyg+I=;
	b=PEK8J9K1ieH1m5OG/WPM6tjkslgcyslgnDzTUiiF59j85Yx6vcBwow9WLDx1fabZVjqe+n
	Q/jcLdxANnsGprEK9ykKjsHY2KXwZeR2e+/dqXtyg2FRvHWWVazg6O0eLpS/lzAMStukmu
	0fuS7XhA+n4K9IEmBza6PcTDvhWqUWg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-kNXTe3OnPpetNzzlStmxMQ-1; Mon,
 11 Aug 2025 05:44:25 -0400
X-MC-Unique: kNXTe3OnPpetNzzlStmxMQ-1
X-Mimecast-MFC-AGG-ID: kNXTe3OnPpetNzzlStmxMQ_1754905462
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A061195608F;
	Mon, 11 Aug 2025 09:44:20 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.234])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 173C519560AD;
	Mon, 11 Aug 2025 09:44:06 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 11 Aug 2025 11:43:08 +0200 (CEST)
Date: Mon, 11 Aug 2025 11:42:53 +0200
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
Subject: Re: [RFC PATCH v1 6/9] freezer: Set default freeze priority for
 zombie tasks
Message-ID: <20250811094252.GC11928@redhat.com>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250807121418.139765-7-zhangzihuan@kylinos.cn>
 <20250808142948.GA21685@redhat.com>
 <393a4509-9b05-45b8-8496-699ace9a5438@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <393a4509-9b05-45b8-8496-699ace9a5438@kylinos.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 1ws9sih8u4z9zdy1sftpkyjmmt8n5x15
X-Rspamd-Queue-Id: 7AEB580004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754905469-87167
X-HE-Meta: U2FsdGVkX18tVXYMJy1znhOhXyU7RC/ql23Rfy3moD9ejqZEPwV4QtpFQ46lfT0fxGVxuBlpE8cA4l2yoPu/srCjayFp0aVUrf4DubfeFhrq/UrBxkdhKTOj/Sc/Oy3rrxkbk5GUIJ9L50QYr7GBpy5zI1S/o+m4bz3PpV3Ou/CpyRlw5GZlGmVCiJtFgogdOuXLr4WHzsJtabYBTPfiGPcv8expMA9+19uPC0FIcxvv0M0fagAuVllV1QSEZT060fO/ra+bL9prFXxAubUpNifZCtD6bQoGkvrwzKorHet27JXJ6rSLtRSX8Evh3ui9gGyRVS1HZTUDo95Nc/f62WblD25iKxXmVsoHNEtIKPGjXTxq8/I4t/zK8Wp4y1X0bu13rgl1WFJ0dOMBdWFMKU30s9drOZ3VH9uFcek4rYOheZiCjMgR+zr5CQPx8demtrUMcVAWk8PUfDGKI1eGl89kj0rYus0vokcN3na065ZOPRoNl8V4PcfOy44eyfoX6fjNpC/y56cRYFXmAq4e3rn9RXdDnt/gidGA8YX8ecIc37OeQdqNQDBZQPpNZ3fmg2IbQisibj2/btGdinNLGyOcu+cHzosRqfvuXDamYVJLjuLhLvvEj0N9A962hZIjBwBjR2WoVu8YQoet8HZhWnzU54e524R83Iu1kSTPdkF8Z7yb/TmIZtOVddFDzSksLqdE4tWPlFVvFcZUKbX88CqpJP8ElNCT/fe5kBCYJvYNa0IWmt1uISx4dEjjPSZSa5QczwIgPf+czSijd2cGCA2JNPGW+qbcX7LYcahYfjAmunBZfiw6F/dcUCmmf0BH2Y/J0Pb+AoS+K+aIsDkFtFuUV2XtMHCB4ImHJRcGi/1o14XVZDlZuI6IVaH6mg3E31355ZZKvt0TIomIb6xhTcYUMAESb3PvWs3sj218Li2vGKAFqz+rs/O0aahUUcKW7fyt+4SGo+YA9wC2LaY
 1nFTAjTV
 yGQxQE7DamKFBjR/dilM/ze3skcIi5vfRDHV6TfAlCul/5et/iuMO1+LhNZv5kdeGSZWTFDrdYgBQcI+tWwZzxwx3Wk31Fe5UHJJjRCWI6P/SsKaTjEsNsdGq503dkrmZec0pppYjrLm1BBRyAwVkxckX/1akLFnDvEmazn0gLR2jcA/J6+EeGWzFsIdQ7ra394FpmdItgJShL2EunpRIAYcAP9yise0KqFn5yU64/ISAD/W00Nsp0ACp3ep/cP96cupjKgvq2Shz4dfGsDG0YED7kulUrg62yBFpuX8vHuxKJL/BrmwESCm501KrkaYKK5PGD+dJD9TPL02qkKsTtYMxYtqUzNLrfNInqWl1FMR+pU7G2etc7T/H7cYrAnOmjZ3HRfRZF+BEXLgudURRlp3vqCum5aVNUJ5bQffJHlWzFkA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/11, Zihuan Zhang wrote:
> 
> 在 2025/8/8 22:29, Oleg Nesterov 写道:
> >On 08/07, Zihuan Zhang wrote:
> >>@@ -6980,6 +6981,7 @@ void __noreturn do_task_dead(void)
> >>  	current->flags |= PF_NOFREEZE;
> >>
> >>  	__schedule(SM_NONE);
> >>+	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
> >>  	BUG();
> >But this change has no effect?
> >
> >Firstly, this last __schedule() should not return, note the BUG() we have.
> >
> >Secondly, this zombie is already PF_NOFREEZE, freeze_task() will return
> >false anyway.
> Sorry, but in our tests with a large number of zombie tasks, returning early
> reduced the overhead. Even though freeze_task() would return false for
> PF_NOFREEZE, skipping the extra path still saved time in our suspend/freezer

https://lore.kernel.org/all/20250707084214.GD1613200@noisy.programming.kicks-ass.net/

Anyway the patch makes no sense in its current form, see my note
about __schedule() above.

Oleg.


