Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7221AC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC118E0026; Mon, 11 Aug 2025 05:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4768E000A; Mon, 11 Aug 2025 05:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C048E0026; Mon, 11 Aug 2025 05:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2C818E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:33:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA7D1137CED
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:33:56 +0000 (UTC)
X-FDA: 83763964872.06.C056A83
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id B45DA1A0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:33:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KYnPvZKu;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754904835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HiJMfJlrRsamODe6gnkp4xuGLE6+B0lz0Dbma9PtWd8=;
	b=aL3EErRksyM+UoI9KwgMpgGAXeAyWBl/2OLX/PvFDTCPsD+e/2x2kzANoAMU0yzmocSksl
	XKtIGavQjRidwUZx3Du+KVU+ly/C3IQWD+zjH+gt88ccN/TetdznfxiebLIYxoDdp0SsBK
	GLcQpZVUL2F+Ecfs9PQQIzpcG/tKOi0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KYnPvZKu;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754904835; a=rsa-sha256;
	cv=none;
	b=B9HhFV7dOH3TvsxgRCnd34iSlYo7szbSbrDJJTFnkS1L/M5Q+UXHk330WSSo5UOxsJmEMb
	y4FeVFPL28xiVL7CcBJPOZXQ5fJbW81zyYbmoMG99sJj6a06LI576StSy9FSFU7rUweKpV
	dhGTdXs6mqUs6YcVFBdNPr63H8694e4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754904834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HiJMfJlrRsamODe6gnkp4xuGLE6+B0lz0Dbma9PtWd8=;
	b=KYnPvZKuyfnjne5F9uCsPrsuKj4y3OfTVkqGUTVfywJGyU3Tqm3PLsIA9LhhCGSa5BmRPM
	6VzKtE4hBxao92n9l6/fDMwNA08evA2ZRqKytFDv+VfjDaxqF0R6dNc1qjcmeuwO7h9zta
	+a71n0tIVb/+K4UQfvVmtIWiir2Vr4Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-1rGCXW-fMce3E-ZR8gb95A-1; Mon,
 11 Aug 2025 05:33:50 -0400
X-MC-Unique: 1rGCXW-fMce3E-ZR8gb95A-1
X-Mimecast-MFC-AGG-ID: 1rGCXW-fMce3E-ZR8gb95A_1754904826
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE1DE1800352;
	Mon, 11 Aug 2025 09:33:43 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.234])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 9F6FA19560AD;
	Mon, 11 Aug 2025 09:33:29 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 11 Aug 2025 11:32:31 +0200 (CEST)
Date: Mon, 11 Aug 2025 11:32:16 +0200
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
Message-ID: <20250811093216.GB11928@redhat.com>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250807121418.139765-6-zhangzihuan@kylinos.cn>
 <20250808143943.GB21685@redhat.com>
 <0754e3e3-9c47-47d5-81d9-4574e5b413bc@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0754e3e3-9c47-47d5-81d9-4574e5b413bc@kylinos.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: B45DA1A0003
X-Rspamd-Server: rspam06
X-Stat-Signature: sooqudb85w65nhw5enot5xinc7bfdm48
X-HE-Tag: 1754904834-549713
X-HE-Meta: U2FsdGVkX1/DWA6sYrpvxy0shOgDXvFcPRh+2di40G4WVarm3gRLwJqVwL0JOLiCt/6721lCco/XfHKBPKFgtZSj7VQWeIi1RC8EWOC0FMgm1NfF1pDqASO0FlPUQPNhr/qr3HI/uKeCFUmy3F8KBdwNjWgec8STbN9Edjb6dSPfc3KWRAOv6Gox5BhHQzH7ZFlrKk1XMVSDfHJmt7ioR+Nsdxs6QC7sJwa9AIJJ5r6quJrkum4snrDEtnBC0mXuDLVHWL7FTIe04xWRIxK4Jg8r8z23k4NzSuKiSKFyqYWxvDtCZ2u9aL8WCv2HLq4riquCDUEDni0itqc6R0+oN1vQTdyT6ZrFYra4FHUiJeaC9h/xiZ2clV+AqiVFVMCg/X/lve/HejWikUjlB18ug8Ad6+QfbLfytD+N2+RovREoJJj53t6is+Be7OE9SsGJrmnokUMis/TFtt3Or6J4TxLP7DLdNcl8AlSaW6c6/ElVgDseqHHcqcfduiKq+/uRoq6n3lc4/jWbbnHhthXlrkFhKJ95tbJfRpNz4a9wUfGsk4jaAf2cZ619umV8CA7u+1FEEvOsyffYnNeg2xK7QRy4bA1tl7EiEPzJd9g7jqj0vsd4h4Op5dQQ+UQIQErdbPvMKkIILzI5vqPZQzHN1ThhUJ/Bd6bsw+D2GfFkHGi/ruERsOWS8yg3Bftt31KU018U/uDEg9uIqVAY0I9qDSdaRNYWl4PWdAtHhNMRZUY+ZerOVKg+GeKJ/7MNohHgmAb7GM9NvSWBJRVgDgBmEKfof4P2WDsoC3Amo2CRhV0Sl0gT+E7zhMWnsSA5bVlslhJ/drVoHkgAcvo9qFT2/gPZ/5mdQzX95ld6gqA56DBf5Rvtd5FJz0MF4AaES8MrWOzQ6eLmI5jnmCcXXtrC98BKPMft2BvJUEeLovenhZO52KR0642LNA5vhvlUFLjY+9117de0P6W4EWj6lfh
 X7S6gTVN
 +EAXp4OoII7e0OPaCgZNAcGbtMRcAjiRmCnXVTwmInVwh0Ixe79T74tacxwyLL2qulV3O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/11, Zihuan Zhang wrote:
> 
> 在 2025/8/8 22:39, Oleg Nesterov 写道:
> >On 08/07, Zihuan Zhang wrote:
> >>--- a/kernel/power/process.c
> >>+++ b/kernel/power/process.c
> >>@@ -147,6 +147,7 @@ int freeze_processes(void)
> >>
> >>  	pm_wakeup_clear(0);
> >>  	pm_freezing = true;
> >>+	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
> >But why?
> >
> >Again, freeze_task() will return false anyway, this process is
> >PF_SUSPEND_TASK.
>
> I  think there is resaon put it here. For example, systemd-sleep is a
> user-space process that executes the suspend flow.
>
>  If we don’t set its freeze priority explicitly, our current code may end up
> with this user process being the last one that cannot freeze.

How so? sorry I don't follow.

Oleg.


