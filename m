Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72BECCD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 10:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16B96B0005; Wed, 27 May 2026 06:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1046B008A; Wed, 27 May 2026 06:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90486B008C; Wed, 27 May 2026 06:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98FD46B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:02:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22FC5C1FA7
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:02:58 +0000 (UTC)
X-FDA: 84812761236.05.B1A076C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 220A3C0009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:02:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y6qAQx8K;
	spf=pass (imf22.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779876176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2adFsX7jkGvB/QFfboMITsC3la9SVEZJatB42Ng8nM=;
	b=Ttevh8oDtOqDAMeRNXvA1fRrm0Mk+jPdpi2St6ZWOxSncs/ejKhTBNxdd1eX4fOS44ZEnJ
	WvjPuwrR3nIXmIL0psxOwOdMfS9Rs0erNRqc5R9NjWfb2Lk1wFArA4rWZ+qXDfuRk1bKZH
	KZ6Xt45XtTTKApxLMIr49tf1HLcbs3g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y6qAQx8K;
	spf=pass (imf22.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779876176; a=rsa-sha256;
	cv=none;
	b=nFRZfArwFPaPBPnmE7D51DGYMfbCZnzb1ZmJ6mY4PZVnqm6DfPh7lHPvYaNa0FB+8LF8jU
	hOjk+R6JulAAA2Mapa5R2ekoHlqYVLUXgGWChXAuUpzg9qKdzhGOY9M2pw+FHC6RN3GfRh
	8E0Snv/gW301dacQbNHAVqmgevq4UHo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779876175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z2adFsX7jkGvB/QFfboMITsC3la9SVEZJatB42Ng8nM=;
	b=Y6qAQx8KH5bXoMFekW8UGYHbcQ70ECiYAH3xmalapaPcUMImnWA7ARsS5X8L2R+ieRBDVN
	1YU29lmXn6wDo7tY30OFiYIDcZnkTkW2EkpIb9uwKAvCLchmhyYFqV0R5iJk1lnnMXbGQr
	PcI9RzdjfSgs+B7KAmVFM6zlQi1+yx0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-a13UjwWEPkWaDF_NMBgG6Q-1; Wed,
 27 May 2026 06:02:53 -0400
X-MC-Unique: a13UjwWEPkWaDF_NMBgG6Q-1
X-Mimecast-MFC-AGG-ID: a13UjwWEPkWaDF_NMBgG6Q_1779876171
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D06A180056E;
	Wed, 27 May 2026 10:02:51 +0000 (UTC)
Received: from fedora (unknown [10.44.33.166])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B34F230001BB;
	Wed, 27 May 2026 10:02:45 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 27 May 2026 12:02:50 +0200 (CEST)
Date: Wed, 27 May 2026 12:02:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: find_mm_struct: fix race between security
 checks and suid exec
Message-ID: <ahbBQ7LOzaOYYHzd@redhat.com>
References: <ahWxQ3JxdR5ff2qf@redhat.com>
 <20260526132423.bb6a37e0ca145e0150a0356e@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260526132423.bb6a37e0ca145e0150a0356e@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: ZG-SgDfIjud6VV2rRWAgW4FOGq4FG2uSdU28sIJt6f8_1779876171
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: bjdwaqmhss8j6m9djun8niyqxx5knip8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 220A3C0009
X-HE-Tag: 1779876175-658697
X-HE-Meta: U2FsdGVkX19L/o4CxOIAE/64D5zK6E3ubnw0AFJ/Bsi/CEf60MKKx99uKcVZbPh7mZaxmrIVPif62wpe4eNFWwGsbyJeLJh9T9wcw6wTq/sBsaE7PoNDF8AqkjmjnOEEisjl+J9hHhjp3SnGYUaOEkBpCW/g9yRlfYBIHmz9twBMhmplu0+6+w8Lkp0OqYLZfQ0mQYPO0bQr3A4Ljv2n8k4qfuQY5A47TuR0got7sQXim9nX2+9PSHPbFnmC6fF5SEKT3bFB/6r0ogb8Lk19dtw+4rgnfv0pubnu6topOrDhHYTWUPKG1yqcDZCofD2gxeJcdcZmo8CnyivGrN0N6nhAruxJyBhJTWzaYtvjL9/6V8jaterQRjQM77CjVxmFhipngNny5kFsKJx77IIKwLU9wJ+yycFrYStupVFUdp7f60oeB94XASxKUNSg0u3pj0tFl2TSvPoxj2E09ZlrnVT4+FjyKmXNxoCYU6+LKbGAko9EvsMGfD8pwUldda3GKEs+qhLQbFYfCwyMPSDkOTbDoVT2amyHxEIqrYfcyhqBjJ+1SwMcTdyjy4yggOafT0DyHNKKoHEdb/jrcGtxm76/RBJCcfZbRBf4TLnBwmcUM5/r+bxaUa9ClUPy2W2yTuWB+LRM/mZJZ1OCWartbj6b1E42xZjOba6JaT+dthet0CY0rFOYbTN6AX/Yjqz7y3bnYAjBnOBmmqQHHEWKOdHlbkrhXCeHQjGjUleg2w0ZdB/dn4x43IAbUCHY4m5awzK+biIyN0o2zfUqaVb2EHeNfV4Fw5oYrhzylTod6kRro1syc4Mal02Cc9lVmzBt2bmeFi3pRJLYRN5EUeb2esKdj09JjGZaiZ3IEieKLAlYfbzntIHfXLWIzv5xLt2c3rTSpNJFJOgxzb2tXBlMc153d5OnpeC92L6pHc09A7Yq/I94Jba0zV5ioF0lopMigRZPTcLLwDEWEII9SQy
 /bwZlLwD
 DB7ZqUPTwyl1wxFH4zWQ/FX0jA1T5KRM6oDgtvRmjov0G19HZJuEu8Ty6hMzR9fvgxlJquOehBGeL2u9bNqK79sz7TlbWD5fUrgi5SsL+rD4xa2CsmyTaVI4lSEbWbD8U0cvi3HXkhoszfvxsNwiZ0DYv2Ylw0rzUHS8IXc/RqU5Dl4Tni7HFtbfNSWwofueO4GS5Tuj241scGPY2DdmhdwFu3/YkRWQmf0RJ++DN5a3c7nw5HWnCOAEF2OXiE04ouog/Z+CwduDFXjL1iDdRiB9G99P5QnBhxCBEPJPOB9hzB+QHG7BIJv5ReCdRIrVLjrU3uRW4fe6uxGmjHyosK/BUvsZ23tfs1S8j0+dHeJpEoyAU892utmb24X+qQhULjUEHTAK9UGcjjf2ZkaNFofdsUudGnbmSQkuRER+S5iB0m3lSbiKwZeWCYzUFRYce5FoJ4wp/hzFsgsA8lT9W77Dc0mRNW9vfk0GeHsmapvdehJDMVVfwzKqAHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Andrew Morton wrote:
>
> On Tue, 26 May 2026 16:42:11 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > The target task can execute a setuid binary between ptrace_may_access()
> > and get_task_mm(). Protect this critical section with exec_update_lock.
> >
> > I don't think cpuset_mems_allowed(task) should be called under
> > exec_update_lock, but this patch just tries to add the minimal fix.
> >
> > Perhaps we can later add a common helper which can be used by
> > find_mm_struct() and kernel_migrate_pages().
> >
>
> Do you think we should backport this into earlier kernels?

Probably not... The race is very unlikely and iiuc the impact is not
serious...

Up to maintainers.

Oleg.


