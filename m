Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB962D0D170
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9BD6B0088; Wed,  7 Jan 2026 15:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CCA6B0093; Wed,  7 Jan 2026 15:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F8B6B0095; Wed,  7 Jan 2026 15:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12F306B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:32:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0B361B862
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:32:33 +0000 (UTC)
X-FDA: 84306315786.05.EFCF42B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B2A56A0015
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:32:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q41pSPQb;
	spf=pass (imf25.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767817951; a=rsa-sha256;
	cv=none;
	b=22UVODghxTgS50lo9K6e9gEKkVSwi+jktEDkyTLlnfuFNz8y+cCWQzyyCOhqqS74omVL4g
	wP7TzMZwQllq8KAU11JM7+4NXMP1PjdYC8wTt4us278xYLkS9oeg2KVwMD6R85YbMXNZXd
	6U8pZGCx3X8g9pazGm6OfRaP7+4d/lk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q41pSPQb;
	spf=pass (imf25.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767817951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Z/DC7J64s4KlGEnHSLqfo5LhZ9RyxEue8T0Qz9lgFU=;
	b=RIaaxhcwz6ktSFxYBRM0+aPyTShw0uZ0o7D99MEscFoCdB0jQ2oprXMo/8wyBzCpMRY3uh
	nJDO7j4L2ICPWnhFsEEgkvjOVxJVh2ba7cf+V0E+Sq5xnVz9JlBWwlhAqqUaCxopJmdqKw
	w8W380ol8teVuzYDWaXwcTPr+IfDoK0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767817951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:content-type:content-type;
	bh=6Z/DC7J64s4KlGEnHSLqfo5LhZ9RyxEue8T0Qz9lgFU=;
	b=Q41pSPQbWM6laWyPoYXpn/ZYEUXGpgrBriwlFpu3HWQgGdCzzPyQ0l73tbESbGXUugBqt2
	YKpC70t6JwuSnxND8gFVPRIOQORxm5uLg6pwkmS1PSyHPdXtoFts7tu5B+fyWWzCtM6q9T
	6dZTOt+uaW9hxVoULh57MYRigjXLu70=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-8zKjdq5iOC-JakvDRE8z5Q-1; Wed,
 07 Jan 2026 15:32:26 -0500
X-MC-Unique: 8zKjdq5iOC-JakvDRE8z5Q-1
X-Mimecast-MFC-AGG-ID: 8zKjdq5iOC-JakvDRE8z5Q_1767817945
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B33871956053;
	Wed,  7 Jan 2026 20:32:24 +0000 (UTC)
Received: from debian4.vm (unknown [10.44.33.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B7F6F1956048;
	Wed,  7 Jan 2026 20:32:20 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Wed, 07 Jan 2026 21:32:19 +0100
Message-ID: <20260107203113.690118053@debian4.vm>
User-Agent: quilt/0.68
Date: Wed, 07 Jan 2026 21:31:13 +0100
From: Mikulas Patocka <mpatocka@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
 David Hildenbrand <david@redhat.com>,
 amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org,
 Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>
Subject: [PATCH v4 0/2] Fix failures with signals and AMD OpenCL
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tGIfKVN3dNZRNIGJk-DryyiFPaWZocik_pt-VSXXrqg_1767817945
X-Mimecast-Originator: redhat.com
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: B2A56A0015
X-Rspam-User: 
X-Stat-Signature: z7uw97konrewutux37kd7jwj5zhkgcis
X-Rspamd-Server: rspam07
X-HE-Tag: 1767817951-452891
X-HE-Meta: U2FsdGVkX19ydJm94Yw7AG9YuRl1p0k6Mat4rXVie3g2sTNwh2VsT9wQxfpK8IMS/qqUGHB2xKk16cQVTrXfSyw0m1vVucSTL146xQw2MRkLMxIBCKaYeR2DVd+M+F/2RFVBNILsFZf+veA3zXvl4L5icXuwLzCAlMOaDCXUP/bHJsN7fpxlWuwyhq+F+5VL7iNsWyXxMej6poNmEc1mkIc5Zw626R008Xx6/9ynaRVKUaehVd3jmZW5WBQ+f1e62JwzpxucpcjeVuwV/cDULS9QI2bHhzO8x2ajBOsBAHrYcItea2y5H3ajzaOs3WngsUdulnajosrOf4ipz9l2HO2VccjZumE4CkCD+t3PD5/HEaWpRNhTkqOmKY0auXxsJah4P/UDdN3/5nuuRikSO07bP0SrF4IijDG0ldmhA1eXV0UmiWKmRbVqkN/KuHlKuzEHE9uAWR/pkaGmMAhdVjQDn2tKwULwtr7Bph7+0Akxr1Gn9QXlrN+pfHaQjPjAWzFsV1lfN6VZK2SDdyKlLuHpYJzgLAoEvrwTtmrKeP/4NwN72EWIEuFp/VTKgV7roD3SaTT828lTUcna6MnbvbHPUW/Ek+tcBXug0txIHHOYuEEmf2jtnQLo+MUMb5aTcbAg+4rzTEcbq1trwx1JKA0ZvTHmywbCF74HY9lQH2RmwpaC+MzwzQHVhbSAnl1qpNOBmDtRwgOWLscnAmeCLtTPGy6002JqWof5VlxEpvz/6zoxGpYgN4SdkEe0e8JwOnPi9AtBVTtC8ZV39m1kBfac6Ywul+zUHrXuCY0T6Ow0GpRCgjkZoyVRt7INBvjFIClEbtvBB4jIBrwWMD6zW3cR72C1aUSMNphSY+xjTJUHEx56kDzdLxhF9ECYVefh8bgHZ1suukNEka8929h7KIgUokCrPkP2aDibfcQkKsu9OXhzWnSxwMcp72D8Q0pdB2w3JkVjb1k+W69UuYE
 EeecpaEE
 P7PQI7+0OgXQA17ZSAwc+a5jNcqYWlSdYh6XxP2vVcpbPIVfZOO6DC79NRqvTyHZn2LAusEyUfHvngZYtG34KpsHJmt80WZAzSA85PBfRLRL7wiBvCxy6RSCfI9uMlAXTxdER1Ibbso1IqwaMPzF7YLYG9GwJqWbKyBaO2NjUo1Has2rUeG8BqSers4tOhvRuyt+Y3qOWV+coDZMe/OP52vXmWYG3J04KwIUD44tb5vbZ3FxagtqO4+Cez+8/eEB1BT7L1hxM7aeIO7XmlS1jjOVY0ssDaDTzDNMqik53f0/43tcjfvnLyw0OpxT4TTdyVjqDLr9OxYLLnJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch set fixes failures with AMD OpenCL and signals.

The first patch makes the kernel return -ERESTARTSYS instead of -EINTR,
so that the syscall is restarted if the signal has the SA_RESTART flag.

The second patch removes a spurious error message.

Mikulas


