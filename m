Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE3CFCE06A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE61F6B0092; Thu, 26 Feb 2026 07:46:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93D26B0093; Thu, 26 Feb 2026 07:46:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975836B0095; Thu, 26 Feb 2026 07:46:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84C516B0092
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:46:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 215895CAEF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:46:42 +0000 (UTC)
X-FDA: 84486581844.30.D88773F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1ACCB14000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:46:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h+0GHvO6;
	spf=pass (imf26.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772110000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REu4C5gEnD9lCrQ0u+aojk+enYm0J/YBvFh4w0Tt6ow=;
	b=fYtEElmlPxUwKb5xVWk7mAEmtNQYabyeX1NZyu8dO8bGHOjvw2DxMhFR8YilEUm/r3JjGA
	lfn2xjsyxnS5HVdDcYEpQxLlsy6U2sFf9aSi5UW2lBCSuUAuTw6EkTV61JyfuUYbiyTJGR
	JgyMso+1tRUqhNfReeE0DsxC6ZWXg+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772110000; a=rsa-sha256;
	cv=none;
	b=n9LzOIKSrhOwwDrVU0L/hCH4FSlDA+3qY0ScZ/rOx3ebf4xPd8vPNO/ENyOPQNtwRIanYw
	tXRFQVZaIPaJXQW0OZmNq83OzADotIvp6ARcXh1HMbBrXH98CSAWnVe+7u4TOgCaSp33R+
	IlFIfXIz+NwrU21HPxZxS0myI6btyIg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h+0GHvO6;
	spf=pass (imf26.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772109999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=REu4C5gEnD9lCrQ0u+aojk+enYm0J/YBvFh4w0Tt6ow=;
	b=h+0GHvO6zzeVQTeTCyXfTePu2xR8ZxAbLsjHxYBHFg6u3eA7+gBguY8zd0N47wcSRJt5sA
	uUq++jcn3dOXzC76b6OG+3Xv5F9yUlLGlEPaRMToZDbynT7q8AfN4MGui10iGnWJY35pqW
	1nuXGwOSd8tq3G6y3J62AmZBbvNybYs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-575-KHvnGr7SPuCRykxddpXmIg-1; Thu,
 26 Feb 2026 07:46:35 -0500
X-MC-Unique: KHvnGr7SPuCRykxddpXmIg-1
X-Mimecast-MFC-AGG-ID: KHvnGr7SPuCRykxddpXmIg_1772109992
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D73DF19560A3;
	Thu, 26 Feb 2026 12:46:31 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5E75419560B8;
	Thu, 26 Feb 2026 12:46:25 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 26 Feb 2026 13:46:31 +0100 (CET)
Date: Thu, 26 Feb 2026 13:46:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrei Vagin <avagin@gmail.com>
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
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/4] pid: check init is created first after idr alloc
Message-ID: <aaBAn-r7A65f2ubP@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
 <CANaxB-znXjfh5s9ro127TGONsu6PieuaJ1vB3PMVFeV4Eo8pkQ@mail.gmail.com>
 <aZ67mwBEbRtdaWp2@redhat.com>
MIME-Version: 1.0
In-Reply-To: <aZ67mwBEbRtdaWp2@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: OXAkNuHGL0dE4ZEsc2x_MF5ysoF6T3azb8LBCjflLIQ_1772109992
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Stat-Signature: 7ujsg4z9cgji8uyeb6u19nek4mmdjcaf
X-Rspamd-Queue-Id: 1ACCB14000E
X-Rspam-User: 
X-HE-Tag: 1772109999-932505
X-HE-Meta: U2FsdGVkX19AZaYPGgEoLxugC9Hl6Umo62eV0Xwhj5yOL9uzQzoOeFpQJHrn6PbAz+1P3IW8bh5IkQ/y+sX37zrxE0eq/zH71N6uFbey282sikP3N0SxmtzxiaXho7MuioErbNWx/HwuXjrL69Y0qb15lYgIhbt84l1PxNsKOh/vA2LDgoyWfUus5hUMP2/0mMu14QY8GdXEW6h1DF6ve+7gmf62HUOKm0ZNp+hg1Bex5DbFsklyYXKNLezxE9B4dck+iElXpF+0bdG/Qz3sqMRFm4mRL8iwndc69F+KX2fjtlfhL4JJxCf5lkg+RWlLx4wZRCjIE+vG4L2eTqm7fWYeRTLDoOkH889PXahz7jXmKhSkK7w9gZbAoaaWluJaIruR/7mAmp2HuCqOLHNBF7Iuw8ENYdtkZyoYEcpNWzSbOFkhTTZTGcTpfIZIamKmXw0HI1VH4g/GbfkEW0U/feBWuGc5t1/j86Dmaja7zFH6scZ6feTJ7iKFcOB+tH81kLW9rIblNQFt2S4OKfsMTXIyhOqRBzPlucrq5khJPe2+61XshC97Uv+JZSqoMqS/DXIIny+kAj4pMgo3Y3iFH+46+MlvzFTDAZ2Fkg7zo0W00GwmNi6E2EZQdXCtZeM+jg9Q1jzvLwW0bk6hirDRlQbA2G95tvjGDdM1Bmo1/DKiOQ38T5qW/QlzCkvb8CxScUzh3sYNW6xN4Cvfa63nNTIT40NX99Z4QJCWzpu11opm7HmnI18KMFcFuzsABHIawIc3wLGVBjt+vZTADi4BatYLOgf38LjDqoXh2GPcVcyeUWCkyoMvZkPTd31L0nmppWmRMbVDqEVmPx3v48dNdb4StXTERDjKYJaUX1MP6oWuPneE5QZl5aWYkUBoNzOdPW3DmpaKMoZSF5HRhwdbbEfFleKciYRU0DVj+P7w9otbsm7xww1aWtLm0obqAsueVHUVsX9/6a15v50N7am
 JVHzIaPB
 5o3QOPCJmFx8Ch1FAN+IN+HF9VaSTNDKEMBIDXeDUQEJOt5Sr2b3P69PRmyaM9QC9REKVx4NPAgCW1aPcOMpOCtYVlDcJJZnG8DUDUnfSXvYp8SQtldAteTQBZT+MxLZWm3aPFRMrS8W08dcvXVm/jbb/f4LHHaGINNUUpmCFEgffq3rwWiXBB4UsS62/EhNoBaEGwOZYHJbEnRT9af7eG5hzM6K/3i2yFn147RsS466A+bbc+NJD1iy3L/s7fsrgEVJ/vxgIUmVUPvGctc+TZ6GJQSZzrSGj7wYnbxo0q9Gj5HubDuvdiIJ2zpfGxf1Y4pXljOE62NmZhcjfF/zIRw+uum2AINbH/VGn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/25, Oleg Nesterov wrote:
>
> On 02/24, Andrei Vagin wrote:
> >
> > This isn't directly related to this patch, but why do we check
> > "ns->pid_allocated & PIDNS_ADDING" after allocating all pids?  Wouldn't
> > it be more reasonable to do that right after taking the pidmap_lock?
>
> Perhaps, but alloc_pid() can drop pidmap_lock and retry, so we will
> need to re-check PIDNS_ADDING.

Now that I look at this code again... Why do we bother to check
"pid_allocated & PIDNS_ADDING" at all? copy_process() does

	/* Don't start children in a dying pid namespace */
	if (unlikely(!(ns_of_pid(pid)->pid_allocated & PIDNS_ADDING))) {
		retval = -ENOMEM;
		goto bad_fork_core_free;
	}

I am going to send the patch which removes this check from alloc_pid...
Need to recheck.

Oleg.


