Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80DCF3C9AC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B076B0088; Tue, 24 Feb 2026 11:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23366B0089; Tue, 24 Feb 2026 11:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59456B008A; Tue, 24 Feb 2026 11:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C10396B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:10:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 619071601FA
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:10:14 +0000 (UTC)
X-FDA: 84479837148.05.71195EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 336EF1C0004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:10:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ei3nJ6mm;
	spf=pass (imf18.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771949412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oA1X4OjKB0GfvTlrIm3AnrrrJwuKWQdjYIEZey6owkk=;
	b=FaAkDJ0g2/M8T+4QoLX0yLZB6AWCR/lRyMbIoP+EbKz3xWA+Yf2px18xtOcF/bzVXFqlF8
	Pl2S8xb3TEHCAQivgWlE2j9/wCWjilTzU+ab4FKIoPQiI+L79JOvERzN/6IwvqhYMoThw4
	fBJ+Bqt7nWoIP7e18NUK/JU75hmQQ/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771949412; a=rsa-sha256;
	cv=none;
	b=lnPibuueWwE7b4svb2H+vWKYe8+7GJV0yfMnoDVuBaMyx0oQlYNFVCQzzjMhOJDylFI43p
	Uz1xmZ+R3ZLlKASanXGDLL8V1wwrSrJBNN2/32BaDOCxdnfQ6zdc3HpgGuA7jK4IhIQAMA
	wDhYg88o/upFG7Zga4QJiwHRK5j9Kdc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ei3nJ6mm;
	spf=pass (imf18.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771949411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oA1X4OjKB0GfvTlrIm3AnrrrJwuKWQdjYIEZey6owkk=;
	b=Ei3nJ6mm9ikokeJpo4Ab2k3jjmD4nE4HR+YzOoQEgsg/XniDi02tI5gcPjbF2dnfmabfyn
	+8aiZQyRORyCDcWyDEl2M5tyWWAsPpHrKYAWw/bFbQ04cv7u+F02GWFq9lXxphkVoIS6Q+
	lNW5L5rlolwon7KJKyY+4NJmPBG+m6g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-NxIo-czBMU2UDEDhw7H02g-1; Tue,
 24 Feb 2026 11:10:08 -0500
X-MC-Unique: NxIo-czBMU2UDEDhw7H02g-1
X-Mimecast-MFC-AGG-ID: NxIo-czBMU2UDEDhw7H02g_1771949405
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB74C1800464;
	Tue, 24 Feb 2026 16:10:04 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E12E21800361;
	Tue, 24 Feb 2026 16:09:57 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 24 Feb 2026 17:10:04 +0100 (CET)
Date: Tue, 24 Feb 2026 17:09:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrei Vagin <avagin@google.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] pid_namespace: allow opening pid_for_children
 before init was created
Message-ID: <aZ3NVMEpeWKOxFkC@redhat.com>
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
 <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
 <CAEWA0a63QxMRqCwpCUqb5iKih31LY-2zX+--SkMGcP-Y19PqpQ@mail.gmail.com>
 <4de06792-d8ea-4f2e-848d-0dfccdb64253@virtuozzo.com>
 <CAEWA0a61jLQxULDMXLcpZn2M-cJXxzSMyCS8C4y=YkFfHAEYng@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEWA0a61jLQxULDMXLcpZn2M-cJXxzSMyCS8C4y=YkFfHAEYng@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: bR7rUqfenO6qX177hmm0kc3X0Llj3gwSD6ptsrrIngA_1771949405
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 336EF1C0004
X-Stat-Signature: 9qkh9jogbiu1pqb7kdhy31bxw4iewtrr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771949412-407124
X-HE-Meta: U2FsdGVkX18bTUMhTwVJ1cOYL2jXU4uogCj7+lG+1cPSWncgo+uzYd6536MybdpVtXyXxJI5y2nAdPlrQAtP99NsqNOL7umhtuPpna88GKVk1zzCqVaXzj7spqsetIaaCv/rkhdCUCiI5f1zKcQ7nUH51cIiENmVUbL1nIDT8M3m4/keihdkcP70zID8x/E/hJi3PjThD4YLAG7dqvxDh8H2n6ohVXik8cFNykFzoha5rcQcyx7dkc98Wv6tJZRM6KUp28jvYZlEnvoQiAN/+wLZMps8ldPj7BKPRYK/xEnDLfJQ2P+pbKrvY6o94Bp9Sxy36GMOOY+3zbeMTnFayS2KBG4HCC5LSMuJBc7dx0zU/ee9ttb+HSP4Q4XpbKj06xH0Ovs6RbakMgW/bYjgMtUI4ZpCX7bKbrGmfKdaLSMnMD+kyizwWefdch9yr4I3twbq42b32DLlNNJ+oIiWvuvJBfTeOs2gBlf8v8sFS17X75S47FB9EDwOSjjDUKCyRKI52G6mcqtqil47JHSmTFpvycsksrNFm4eD1teWAzuNFfT9UZh+RdLZubqEjPS0q5+GeEvDCskzSrw8cQNBRkPOH+jsvQbdVHR/OD7zDGLyaD9FIvMZoAMI08+cmPTSRvhBeFjTIN+1mqCplwyGZ+G7fA4xN6Na4+BPNERbynV3OFQY4GB6fvZrNjPCFPNJ+BFdVl90hJfJ2FwIpbVBEym3wfM0xVP3h7CofKN1z3us8ekEC7MtXwWpIUFITGKBEI9xM2PMO4110IiG7ATX47+vAHcgbc58O1Npyf/GWCg11i3lWoLn+zHWS36VkZxE0kGHgabQaUzSJFw3OxS3KPOb/ns9l+Ei620cDrfcjVjF4zS5OftiEJkjRxTYAZMLGDuqwZSrGroar4dWd6KTwwyF/qPBeuCQ7fgSYX/v1aGR9Gr/HknvX3hjohETKn1lx7Ir4xGQixSSquiPW4t
 +SyeHh/3
 4bbE8uG843G9vnUIRjL9agMEXoD6bzIOAPmMfAGU8HWU7st2T1EBtxxsR3nQnRZo3jMxnCULGPhW1jypRzOF7h5UaA/S977KTLYdqmKx9EwZADyCPC6oCewlRQig6ZXdglbB2xr5RpKloesjsuU7Mij+MmcMaCAyc8DQfPA9axFr8vkRx/mLXKcms6kEY1eSXUPslaLsz0IuZrpi24YF/99b8nwl5EX9fNSwlrjgm8FlucfevOCubw2xdr8XU1cHmoF3GWKSx93BI2eCdGxt2vT0zK/L17iLyD7Jbo5hlY2A+Y772hOuEl2mqPEylf0wRDflRFNXtjBz3KH6sk2N7wFUuxiHQoyAVGDPR2uxjq2l9ZIm8yoxlt49T4xqUT2t+JwX6ifRxUNh12lO5MDI7legVOni9RForYuX1Iz/GV2Q0qwo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/24, Andrei Vagin wrote:
>
> On Tue, Feb 24, 2026 at 5:38 AM Pavel Tikhomirov
> >
> > This check here is more for the concurrent alloc_pid() case. When one process
> > in alloc_pid() successfully allocated the pid and than, for instance, hit the
> > pidfs_add_pid() error and is going to free_pid(), but the pid 1 is remains yet
> > allocated from idr and the cursor is on 2 at the moment. At the same time the
> > concurrent process may get to alloc_pid(), and will see cursor on 2, it should
> > not be able to create a process as this process will get pid 2 and will be
> > created before init.
> >
> > And in general (non concurrent case) it makes sense to only allow allocating 1,
> > for the first process.
>
> In this case, there is likely a race condition. Two alloc_pid() calls
> can run concurrently,
> where idr_get_cursor() returns 0 in both instances.

This code runs with pidmap_lock held.

But,

> I think this
> check needs to
> be moved after idr_alloc_cyclic() to verify the actual value that was allocated.

Agreed, see other emails in this thread.

Oleg.


