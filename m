Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45FECD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 20:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07ACB6B0005; Fri, 15 May 2026 16:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0046E6B008A; Fri, 15 May 2026 16:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E996B008C; Fri, 15 May 2026 16:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD7486B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:16:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64B20A023D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:16:08 +0000 (UTC)
X-FDA: 84770760816.21.42F7F7D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6BF7212000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:16:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a61yxdoL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778876166; a=rsa-sha256;
	cv=none;
	b=EnZtBJFJlqIM4imBOgUB7zpu8YUjQWxWpEdVx3BZZeKJu777en4AtMKaPFeLwy3tI/X3Hx
	LDmxK82y9A6cFxSZUz8O/ohUDDuaCYrZnetyh8rrmpkTPsJ+QOxREym9x8iYrBJO/oIrf3
	U23pgp8iaqIdmXUAh9W6pDytDBOZJ0I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a61yxdoL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778876166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvDbho/ycMJrj4/etDVpBHhuznbtd+KBBl2aXO2hAg8=;
	b=vIaAGPCHmUbRnfNjyxexjnnTAHKfS+LaE/xBUDHbUfhGPPAZx/vfQkZwOwygcT/gMLPzPQ
	8gircCymDGseh7U5/Bd23cqrcx0fWCyhSPzia2cCy/0gBE4+URG62IIdEXt53DU9YhFKlO
	jLqJjMLRfUGpMV5PfjvkS3MnqRhfWY4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778876165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VvDbho/ycMJrj4/etDVpBHhuznbtd+KBBl2aXO2hAg8=;
	b=a61yxdoLxDQVbuAt0e9LI4qq7fSNSba1xR0agJDBxUd0ELINImnemuhteO3mxtqvs7fjnU
	F0tCf2a9oJMFdwh/62PhWTsNrD/TcD0J9B6j9nx60jjmgE6b8lS9W40q6boh0+kIrK+t9S
	Yr9VyT8KgxI8CLTOYyFD3O0gW+bAoDk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-342-3gJze-F2PlKucRHeD5WMxQ-1; Fri,
 15 May 2026 16:16:02 -0400
X-MC-Unique: 3gJze-F2PlKucRHeD5WMxQ-1
X-Mimecast-MFC-AGG-ID: 3gJze-F2PlKucRHeD5WMxQ_1778876160
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6E9E19560B4;
	Fri, 15 May 2026 20:15:59 +0000 (UTC)
Received: from fedora (unknown [10.44.32.66])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3D3C930001A2;
	Fri, 15 May 2026 20:15:54 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 15 May 2026 22:15:59 +0200 (CEST)
Date: Fri, 15 May 2026 22:15:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <agd--WZpeTq2iKFW@redhat.com>
References: <20260511214226.937793-1-minchan@kernel.org>
 <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
MIME-Version: 1.0
In-Reply-To: <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: p68G0LBdh4IeNDQMkw-4FmUmGAY3LARTGPJlkFubANg_1778876160
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 5o4w86fuyf3bb6phru3orwnetdnncps9
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BF7212000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1778876166-5759
X-HE-Meta: U2FsdGVkX19J5o5xaMmf5+h95iXmIEjjDnjpHqapVaCYpKsgXpGsz+CfREGh7MLpsFmkzSf9pJGL/oOhd5mwnpeMosOOJ03tuJ8rwaVW6w3NseY0Qh3hKitM1tuex2AqDcywPWM5jjN+gl6I1opSx+Qki8SbSkWE9YyRBqScZqmdBweDsQ5o4QeaPK9eNCJL/oUPGQmNv5qTaEbOSonuCelYvrudz+8OuFpl8LovR0NLQOE+9OMYckHIOkyWgSgwqbhGhgocA7vXUBSgv/QmeJu7LMb6ta3og5X/Hgf30vxR+muZRmDCvgdR+0krvG4qZVXi8BJPpNMzvkB+jP9NiMJfJvKaThb4eVWS5cziUC3ouxVGQ5O7gQ4MG1kSxwqgolerLrZZuQtonVA3L1MxswMOEPT1Wg2YbYrOqOlrEaEWjNP98HuIYc8MxdqCD660KGPswbjWl3mwAAlUkq/iuWeayzcZUGRJ+5eD+opp3s/QJz6TgYq9lcvD9uvzbSCL90HX2+O6YKS+0fI/atdN8Hm25sW4NU2BdYanq/DMtO1Ji2eKAUwYnNjwoM6XIjIFBkAn1wW4fvoLrSTp9Tv4AyAjKgLBRxffqyRYb6cvkkDbdciISb+oYaRPY2XrWhD+xMEotxaQbUBdKaj52TSSVUqm7wgv75qioTiW5LiV/Ny8Qi3jbpsz4sCh+i3lkmz0rGnxW6HO4uGDOBt3jPuxrqQDUAIWsf0tYJxBbFwX43lRJTobUNA4fA8JGxPCPGogmj2PzkMupQO9/BK5lS6r7zqxlOwrLaDXm8UN0itLR3ugNsz6MrIK+X0TmdD9g89D52VX7Z4R79zihM+GC0BsATD4N0rL91MupbzgOSMXDfmUUDOMGB8yRyLdfKOHNnVvSyLjiIuvBANeI43cK3nxV0XHV3ubtU/QwHNskpsXwjRN/U6NkFQkXGu5foT4/+EfJ8+9+WFTZe1Rk4D6m/n
 z1uoXcjb
 LVLzCuuISTiwf4QRMLuuhEroH4QZEVCOKFqed1IkXqOrl7bZrGwSuuUShkE1wo/ohKgSfivUuc9+7/oFxUlIZfqN6txiYo6XBeVKPqL+IgFETK4nLSXddaSFWT1XBwz6d55tR7rovgJ7LPxmcTEXfFbFjnJlzExdMWTqCKRS6ntxlhgPZ/MjtpZRE/RqzwHo0esnCuzkAU1qpLnr62yxg+8x5YzLcYHdUINUqwC+9aGLrodk2a0uxx8ZEzKPsJaA9yTAeFjFWrIgEaLJ8cvx/VxGthYUnLKOgpnheMa6EWDCSPQ6KJ+OZ2OxG9u8aVwDz9Sqz3nWXx1LVQyE1A0UWf95maOjyDFuyAgPqhUnkUdzNgPX8rHFKrUBTtwXqVQq2qI8CMK0Fglxou6TcD3j1+VK+P7Vapl8foJk8Hzrmye8y+8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In fact I don't even understand the motivation...

On 05/15, Christian Brauner wrote:
>
> On Mon, May 11, 2026 at 02:42:26PM -0700, Minchan Kim wrote:
> > leaving the actual address space teardown (exit_mmap) to be deferred until
> > the mm's reference count drops to zero. In the field (e.g., Android),
> > arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
> > remote VM accesses) frequently delay this teardown indefinitely,

Sure, get_task_cmdline() can delay mmput(). But indefinitely ?

Perhaps the changelog could be more clear? I don't see how any remote VM access
can pin mm->mm_users "indefinitely". Even if, say, a lot of threads read
/proc/<pid>/cmdline in an endless loop in parallel...

I must have missed something.

Oleg.


