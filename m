Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F86AC2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 21:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C702A6B00A4; Sun,  4 Jan 2026 16:13:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48456B00A5; Sun,  4 Jan 2026 16:13:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71546B00A6; Sun,  4 Jan 2026 16:13:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7F16B00A4
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 16:13:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 218E41A16C9
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:13:07 +0000 (UTC)
X-FDA: 84295531614.18.EE9213F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3BA79A000B
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:13:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YMPRJflG;
	spf=pass (imf15.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767561185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgBgb313oQaNyn46BLjjQCZGKM9zlTYGWXVQQUu4odU=;
	b=kho0xX6KKq4pAwSaF+1gYmuKuMh/VGsS1sHSA23rN7/flUIOyFAySHkuAFxxyb5UZ0pWIR
	s+gt5pn7YLOUePDz5chcPN+qpnrbXE7vzAqtgwRIgm+QaYUpAMQKhlDjx1FYRZVCX067Ne
	NFbELn6D2aj5r8i/QsluXfsTS4mfxaU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YMPRJflG;
	spf=pass (imf15.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767561185; a=rsa-sha256;
	cv=none;
	b=iYWDv+Icvu+vZ/eHAeCgWIrNaHNW0YY5Bz67fQGehFeca6lu1IOPLBheiNjvQv+/Nxzs5i
	qgMKMrrGBlMe73WGA7kGkru9xRqHVCbulCrVVp506beYwJcdDVhD/ODgKAxk6db3EYiLIs
	1TvxMpIZiuCmsQWoFE9lcdUzEFURc1E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767561184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AgBgb313oQaNyn46BLjjQCZGKM9zlTYGWXVQQUu4odU=;
	b=YMPRJflGXNhI06skwoW/K5RYjpujLbqKIIcXjqBas84pULkQ4mR+SUT9tew5mEAf9UC+SD
	3XZfG64JgJ5UDgQUFF5Tz1vZSBV770FTtxvFy4V7ZZLrTCtKvbhpPk8WijR4ZkqeQ6OYxa
	th62jg5HXujeS1gqZp3cqpz4fhSVT4s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-iCFXWwhrN_q5gaWNTOzuZw-1; Sun,
 04 Jan 2026 16:13:01 -0500
X-MC-Unique: iCFXWwhrN_q5gaWNTOzuZw-1
X-Mimecast-MFC-AGG-ID: iCFXWwhrN_q5gaWNTOzuZw_1767561179
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8FA91956053;
	Sun,  4 Jan 2026 21:12:58 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B688180049F;
	Sun,  4 Jan 2026 21:12:55 +0000 (UTC)
Date: Sun, 4 Jan 2026 22:12:50 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
cc: Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
    Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
In-Reply-To: <0826eb09-216c-4d00-b4eb-ed1a2ba204bf@lucifer.local>
Message-ID: <4e45bbf5-29ce-7cd6-8b01-8fb1331ac758@redhat.com>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com> <0826eb09-216c-4d00-b4eb-ed1a2ba204bf@lucifer.local>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -nNJZIT13b2KAVhxuCm1VLsZlcBwEU-YUOq_bwX6S8M_1767561179
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Stat-Signature: gng5gkck6x46ioge4n4w8833mhmc3qys
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BA79A000B
X-HE-Tag: 1767561185-529259
X-HE-Meta: U2FsdGVkX18yt/IAKmgR5jn1ao7J+aaHZrwwSOIiAlY/la41KkUPbRn6CoZWLkl/+npNMHOa5jZh6V+5TPCzlk1G1G1nc1mVBnE6nBOOzMcANKGz9ZY+RmAe9Lfq2Uh5tFK9kMINc7kD4LpMTuw7slt05eeSaH9no/P+NpymsP69UJQ5gSSB3bCJ8/tWhgO7xmQ3c/i0bxrdsYZxpX8qjSSAhzCrFRBMzaT6PJwqyiK71STrIO5jlA3yC/yXkzoMA28OBqHHzr+9trImaaY59KIPuHOdrkQnKZSKOZopjoc3VWoJg7Cu39tF5+9OGbQ0POvap+fxUgRcr3yt+xIGYmaCTRMl9VuqsXxBs1Eqrj4acHJFXnhpTKrczWpQH97liUsBte+4M24RFTS7knCyiRoS4DosTWw6VeCF2e+lfumjPN4DeeD3E3VO+UMjQgyKYUp96OU5bqoz95odeRDH5Yig3Chr4iAZBJGzBIlwaW5S5S9zyl9pxmAgn6P5OOw5Ua0v1l244n7wgkUSSD74AeHH7MOXc3Zo1Yqz3IEPnrdkg/ohLfviiih+WsHLlRLlvqT2rohJn7q9qrnp1M1yzT1G6Q1VdtABtuezoZ8vfvxWh/I2ZJMwLxCgpAPUpZQuBvKa4WmTb2hAUCnaduj8f3XYiwSH2Zq3Te0CLM7P3KJYqI1Ht7CRbb4iJssgWvr37SjkhQcrCI0vRpXVFLVMIkWJwzrZTMA5L/yVY5H/ytLE8sPPppFTS18caYIHX5ZGwzY35UL2d8J0QwPIT1qhTZElkSiEgh9aWdDEpxIvx5W4a8LziwZXSMXpwEZSdml3ilS56SJbIXWPJLSSQxYmkjySwUivEB48vZDEcJ3hOYQKio2W5HcMxMAyT0v6qjfvvbwXGI9s96NT4IAwlr1GrvnwyY8blTfAudp1SLB8SuVju3GaGwMLTsNEmMjbXAlbYluiLbGqtGAEKkgVLq0
 QgPdQon9
 EXOnHoYBgfaw/8/0sjfGsi/fsmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, 2 Jan 2026, Lorenzo Stoakes wrote:

> +cc literally everyone you should have cc'd in mm :/
> 
> Hi Mikulas,
> 
> You really need to check MAINTAINERS, you've sent a patch that changes mm/vma.c
> without cc'ing a single maintainer or reviewer of that file. I just happened to
> notice this by chance, even lei seemed to mess up the file query for some
> reason.

I saw

MEMORY MANAGEMENT
M:      Andrew Morton <akpm@linux-foundation.org>
L:      linux-mm@kvack.org
S:      Maintained

in the MAINTAINERS file, so I sent the patch to Andrew and to 
linux-mm@kvack.org. I should have sent it also to people on the "MEMORY 
MANAGEMENT - CORE" section, but I missed it.

> I'm confused in general about this patch, you sent it on 7th Nov? And it's been
> ignored until now and then taken without review to the hotfixes queue?

I'm developing code that translates parallelizable loops written in the 
Ajla programming language (www.ajla-lang.cz) into OpenCL and runs them on 
the graphics card. Ajla sets up a periodic timer that sends a signal for 
scheduling purposes and this signal interferes with OpenCL, causing the 
-EINTR failures.

So far, I worked around this bug by blocking all signals around the 
functions clGetPlatformIDs and clGetDeviceIDs - but it would be better to 
fix it in the Linux kernel and remove the signal-blocking hacks.

Mikulas


