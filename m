Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37032CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5836B007B; Mon, 11 Aug 2025 05:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65C66B0089; Mon, 11 Aug 2025 05:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54B26B008C; Mon, 11 Aug 2025 05:48:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A312B6B007B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:48:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56166BB25D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:48:34 +0000 (UTC)
X-FDA: 83764001748.16.DA67812
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 352A9140002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:48:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WEW3i2Ng;
	spf=pass (imf09.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kICfAp24qHgM+A4GcAjqf86phj/suI1wu/9/TRfKonI=;
	b=1HqJpgwNWsX6Q5z5XnOltHrSBB8jmrm/8u0uXX0cVhHnIQHir1z8deVQ7tW87PyRQn4ULF
	60JGeXv22BokU9DUdSv2Wm3tBp8ryWLA/qO53JEXooqseJg76BRYXMQiXaZNXyrVV4WjAe
	ljkno9Pu6grUHbbzw/L9qVkDg26LgCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905712; a=rsa-sha256;
	cv=none;
	b=SeIFu+pdTDYNI/QvNHrfF1Rfzn8NsaR/+MtddhPTj88r1b/JB+rAl5Vt4C4PCdvYffmEWp
	XIt/sKkBEDJYqFoe9nwMNunkM0swmWCOKseiO7EnC4pAkL9V8KD8h3mzmYG4Mj3EeH4YFL
	XyIxRKKBnZZrV/YRE1QfIywlbrBnzWE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WEW3i2Ng;
	spf=pass (imf09.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754905711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kICfAp24qHgM+A4GcAjqf86phj/suI1wu/9/TRfKonI=;
	b=WEW3i2NgU8S3SHbowVfxc911w/aSbg0aEvA1qynB38yDLtI4Yn5JwqZZ5Jzm7dpjTFb2+7
	m4GZxQ92qwub8vvvwxm/g1KGJeYHAthnfC2+5QDtLyQRgMQmkMJdalTvURMjODDISjhnZM
	JQ4e3QmSZupttrp2UdQLYEZ4w84YP6k=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-kvLj1JhNMtOyQe4g1LJ22A-1; Mon,
 11 Aug 2025 05:48:28 -0400
X-MC-Unique: kvLj1JhNMtOyQe4g1LJ22A-1
X-Mimecast-MFC-AGG-ID: kvLj1JhNMtOyQe4g1LJ22A_1754905704
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C16A0195608E;
	Mon, 11 Aug 2025 09:48:21 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.234])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 24DE11955F16;
	Mon, 11 Aug 2025 09:48:05 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 11 Aug 2025 11:47:09 +0200 (CEST)
Date: Mon, 11 Aug 2025 11:46:52 +0200
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
Message-ID: <20250811094651.GD11928@redhat.com>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250807121418.139765-6-zhangzihuan@kylinos.cn>
 <20250808143943.GB21685@redhat.com>
 <0754e3e3-9c47-47d5-81d9-4574e5b413bc@kylinos.cn>
 <20250811093216.GB11928@redhat.com>
 <428beb0d-2484-4816-86c3-01e91bd7715a@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <428beb0d-2484-4816-86c3-01e91bd7715a@kylinos.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 352A9140002
X-Stat-Signature: bwy578jw6t4s6fkkjejdmc1itr8sfdtf
X-Rspam-User: 
X-HE-Tag: 1754905712-473064
X-HE-Meta: U2FsdGVkX19NR318jIF8Oc2cjbAqsRcAVZfIBeSAKIuQVwbeR8OfXiqipFc85AinwyBH8UMeqMUezuiy9U6EW1Nq2LbJ4rDwolpWQ5yV5sW4SEz97wYZFyVgRBnoEXpdCHR2f/lMEFhf77Z0u0oxovcmTWP72dygnP4Q7hVi7xynZz0DcGJFx+OIghv+8D3KyIh2+DnVCwS2Y8TDFRJWA3PMuCAigvioCkqFpbQ1yVdoXBYmUXc0oolJPtOo18dJw1TKoeGfjc+H7ccv6MzVL4thbM2dc1vLVEdK+IWp0xzqUF0HCIesnYR6QbPXR4WSX/Vqqh9GYPW4dKmoPQUbknyHGi9VmIHNA4/yIbTuHnX220JQybLt2vGWJBa3qXKRC5DrSg8Z4dkblSlB/F7WbQCWKKwtQWNFZs9SmIL/j2iR79o4lnYaLnBwLtDdXOXOOsEuW5QIs0TYa+L93lTcxiWektSQxKOXrwohYZc1K7ptEo9DZi2mI/8C3GEBI5KoGSzyxbDw40SjcJFfzpwEmfx6xVvMfOtqL5GzysGHc4WLatZsqVJOrMrzZScJ5YAD6fAOrqh5x+a91NSQgzU4SvHYKW5Lasa/3uzfbZL8VpzKbWABsdsdD6ZakdnAAsXthaO4wN/o2HoTLXtsYDlH/8pZuDW6hha97aeFqyMZtJwFp8IJBXSTOterlunm20JUgsW6PT3bZc8Wt54ecNx7DrnudLULzlG8IK88koKA2XQsDhjpNFVOyNzjw8qYWLLrt+Vq3/KCdngfG48y5Wv7Z2HmZZHP0TmAyivjM7OHdMrlI5qzsFIIcwkSjqlXx/FnK3C66YPwa93Kkx5MxRTbQXdGOERe1HN55AdlqbWodmwRNu1rSu2jZmhS4JwS6N3E6YiNdyBWYpMIyuPLA1Kdg47pGmyQLZZmH7w+LaZWDe6/HNaX5JfbMvIDQ0+PbvcPt3uBAJOdWgr9LTcW+19
 zTwM5EBz
 +c/QBl65HtnUjrOJZdCX6a1X1BPd98UORn8jbSMVGNXYPSp2zPoY5bJlHnGh0hzxd8hF81WfDzXpssLOxYavBIEhMBnI5pUOoFTtmq1lga1ojy38kdZj80YJ9tK4eMP3HoxgE6Z4ylAGaQwcJNIgwWTDYXoc+nemlTRAdIeRCmGgnLpX7MhzkqhOwBKVKEhZ2RzSY2EmNdnFKml9VtjN3OcUQm+ERVSytzedY1O5I4bxDpu9zpPaqj3Hs/Dz8wLCvPafKCrPwvLwozJoHcZ/vmOESRe72U5If/AchLUysDDwF5sJO8LoJujqrEA9POQXzTJ9kB2QybZd1jBYi/lzF2yz4GuFw6z7zOLcvQRQkdq15jyw21r/TpYPa2Edzu0ozZjJymdzh4ArkmfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/11, Zihuan Zhang wrote:
> 
> 在 2025/8/11 17:32, Oleg Nesterov 写道:
> >On 08/11, Zihuan Zhang wrote:
> >>在 2025/8/8 22:39, Oleg Nesterov 写道:
> >>>On 08/07, Zihuan Zhang wrote:
> >>>>--- a/kernel/power/process.c
> >>>>+++ b/kernel/power/process.c
> >>>>@@ -147,6 +147,7 @@ int freeze_processes(void)
> >>>>
> >>>>  	pm_wakeup_clear(0);
> >>>>  	pm_freezing = true;
> >>>>+	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
> >>>But why?
> >>>
> >>>Again, freeze_task() will return false anyway, this process is
> >>>PF_SUSPEND_TASK.
> >>I  think there is resaon put it here. For example, systemd-sleep is a
> >>user-space process that executes the suspend flow.
> >>
> >>  If we don’t set its freeze priority explicitly, our current code may end up
> >>with this user process being the last one that cannot freeze.
> >How so? sorry I don't follow.
>
> The problem is in this part:
>
> +            if (user_only && !(p->flags & PF_KTHREAD) && round <
> p->freeze_priority)
> +                continue;
>
> PF_SUSPEND_TASK is a user process, so it meets the “needs freezing”
> condition and todo gets incremented.
            ^^^^^^^^^^^^^^^^^^^^^^^^^

No.
	if (p == current || !freeze_task(p))
		continue;

	todo++;

Again, again, freeze_task(p) returns false.

> But it actually doesn’t need to freeze,
> so resulting in an infinite loop

I don't think so.

Oleg.


