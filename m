Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E2DCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 15:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4170F8E014E; Tue, 12 Aug 2025 11:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF1B8E00B0; Tue, 12 Aug 2025 11:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CA18E014E; Tue, 12 Aug 2025 11:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 211B78E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:10:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2CBEB891E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:10:29 +0000 (UTC)
X-FDA: 83768441778.23.5853A98
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D530E80009
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:10:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ibJ2W7Fb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755011428; a=rsa-sha256;
	cv=none;
	b=1p+m0OMoPrR9bPbP389nEhSOWY4pm40ykWq5N5VuuqyZjDWfuLWOh+LUbMwMQR221e9uoD
	a6S1yHJ4D8Q4AGcC+kaH+80hpqBuaqgPFhL/AahX9hjqd8ZD4pIMmZPgA6pRWAV/aROn6X
	KIMKahBjzxDPDK6+9m1C3tPG9W/0/uQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ibJ2W7Fb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755011428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PrBFm9KN1k8udVr7PX4kpGMG0V0UIL0fa5o6pxCVKL0=;
	b=cvBBD9QzrXD+mZIYz2XCgNJpuL9jW5ttsGcQP8Ua8OSyz7XYpimuwU2EyrH8HKGdyzJbg0
	laZ6ePeiqM0pTQDkg54WIo1bm2CG0u9Jks5VQyG7ZfxGrl6m1SRiPv9Vb5u7K9PQwo/bif
	29LXJzzMsXvcIUGQK5VOQz0slNdMTro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755011427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrBFm9KN1k8udVr7PX4kpGMG0V0UIL0fa5o6pxCVKL0=;
	b=ibJ2W7FbpGyemRF7hY0ZQ/aquSGiAmMyIYXQZz3WErkuPOjHGFHbV/DzMPoRbk2+QRTAcG
	aaEr9K4LKLgWkg2VqACDoxYZvuGd3pOk9tx28q9I/NhbJdIn+3t7LNuq49bJ/8XOGObyzM
	ADYWyb7tnhKVK1HpATnbQfvdV+8vRG8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-SghTwAjnNS-be_4HqIcxxA-1; Tue,
 12 Aug 2025 11:10:22 -0400
X-MC-Unique: SghTwAjnNS-be_4HqIcxxA-1
X-Mimecast-MFC-AGG-ID: SghTwAjnNS-be_4HqIcxxA_1755011419
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0E1D1808966;
	Tue, 12 Aug 2025 15:10:11 +0000 (UTC)
Received: from localhost (unknown [10.72.112.156])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E3871800290;
	Tue, 12 Aug 2025 15:10:09 +0000 (UTC)
Date: Tue, 12 Aug 2025 23:10:04 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	sj@kernel.org, lorenzo.stoakes@oracle.com, elver@google.com,
	snovitoll@gmail.com
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aJtZTLPtHUfUsiuQ@MiWiFi-R3L-srv>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: rxegibb46477kkdad9beanhwqswtwhdx
X-Rspam-User: 
X-Rspamd-Queue-Id: D530E80009
X-Rspamd-Server: rspam02
X-HE-Tag: 1755011427-459151
X-HE-Meta: U2FsdGVkX1+We1YppyAClgLHzZmDA/q8b7XwmasK5G+royF32Nb1Lim9CfZO2uskH72ePodEqLRkJ5L0pVHH6VofRzLEU9C3+rnbmm5b/xaVfuRCPRdh4exRnJT2mu6XmU3wWssBtbRcRthurufE9eiXmmAGpEethhO1ueFAnFqytl/uCf0XDLR+OvoDXcruphN7scO2YYJnWi6sXrjKQhcMz0lYN84swxMe3kWmdrsX4xLZ4rJfohxjYxnehpeInhbsSVJlQkC9gFI9Bg7jQqZxe/55MIDw7r54FhKeO6DB+tvHicbTxWEn7J3pwBAEZMAKy+2cV8lQ3IBG8Xu7iPPYOPWFF/VjyqCZ/N71qVl4JQQKT6bNmhphhhj/nvYghtkp9OmSblfguARpY/P4EbGdrVQ96e9tZeXyG2Ousy/L/UjLxqx0gcoNJDiOYYeuUVrm5VJzk5cMOh+UbrdHhmHFSrOqT0Qga4Ij0VBlHm0Vb+ZVH2h10N6MR+HODq5Kgy97Uwphvo90XaxQbfKjBKPXG2Ru00AaWWfUXF9FKeAnVAWoTa3/1QpmQKwoWyiCE0JHq1UPcvN3HOBKwo6h4P66WoSOcnzDp54+zi8M9eS3x7rwj1ROFJdQs1VKraqmWbEZiR9d/ecUGcckFRw2szcuWgxUlJGwLA3ckCV9kJ5+K8TgaPxtISmvXnhn5DipWb/o5UuFBHiL1MGgK286JxUEVWXyu4YN1JAJYn1We6x5P8rMOplvftrFzHumFUeifmm87AMAWA0WJ41pwUK+xHjO9cjwsPivRIkAaeJ3ChRIYuHLzfD+ccf/MgK/1Cy3ukhIZxPpUlQCAMt7mW6SdhwaKGSY1E6xaVdzvHcGVoAVwNqPiuFx7j5LoeMKaj0W9q2Yzow+XbF1OCVyG7JkRlSN+m05PeXVMxmDAFWRV/UGqxwyuc0eJnHHfXPhmA+5a+vnuTsKk9uIU/TYjYf
 XziYiKb/
 Z+JRw01SYTYJr3vdjqyRhEtSIVBth1UtWTIQarCl8AzP5V9M2/R0EhyQwC2ykAUJ32CEdEISm0CpFzo2ZL6f8NRDwRueHxRWnl8x94eqCtNjAsAQSEnYMBVF8h361ORPUOOMYhQEyj40sWywQf3gBmc8mGmX+7Jk9OhyoLNj0hAlV2O7d1pvK5HYgyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/12/25 at 08:49pm, Baoquan He wrote:
> Currently only hw_tags mode of kasan can be enabled or disabled with
> kernel parameter kasan=on|off for built kernel. For kasan generic and
> sw_tags mode, there's no way to disable them once kernel is built.
> This is not convenient sometime, e.g in system kdump is configured.
> When the 1st kernel has KASAN enabled and crash triggered to switch to
> kdump kernel, the generic or sw_tags mode will cost much extra memory
> for kasan shadow while in fact it's meaningless to have kasan in kdump
> kernel.
> 
> So this patchset moves the kasan=on|off out of hw_tags scope and into
> common code to make it visible in generic and sw_tags mode too. Then we
> can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> kasan.
> 
> Changelog:
> ====
> v1->v2:
> - Add __ro_after_init for __ro_after_init, and remove redundant blank
                            ~~~~~~~~~~~~~ s/__ro_after_init/kasan_arg_disabled/
                            Sorry for typo here.
>   lines in mm/kasan/common.c. Thanks to Marco.


