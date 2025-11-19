Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE7FCF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09A36B0029; Wed, 19 Nov 2025 08:27:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA9A6B002B; Wed, 19 Nov 2025 08:27:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8A26B00D2; Wed, 19 Nov 2025 08:27:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8497C6B0029
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:27:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 356D4C047B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:27:16 +0000 (UTC)
X-FDA: 84127432872.02.421AD80
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id BADDB14000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:27:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="RMWOXnF/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9LYejATv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="RMWOXnF/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9LYejATv;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQ44aemiqJtq0zuhYxg46Kkv6bvog9XT2UPmBVw0jms=;
	b=aNVpHp5kS0zXorAW/9JMFLf+bJZ71WghjHlTcuP7OHlWkB6FN0EaCCZz5d9CHE17ingXCg
	L+w5fDeYUuWnl1U0xL0siNf+GXxmguUFshVxFwHYas4dQoWuIUUl7lBuZXtib1AkEL72pP
	Qh1Z4h/DNjes+7lK8rJ9QzXrOxhf978=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="RMWOXnF/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9LYejATv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="RMWOXnF/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9LYejATv;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558834; a=rsa-sha256;
	cv=none;
	b=3rz8A90cC2RValIZzxv/exJ3WT8eG7oISR6V58HvPIEFzYF8Ye4sLcXtDeaUd7o+M0UER6
	hmyngOFEm3+PCVlbkFS/M7ta96mYaLPCmmmguY9yDarjTZCKoIXEb138u/lRSo2WeJWP5S
	jZAbKnj8t2g2ivBC3i8G5kmij4xniaI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DF202122F;
	Wed, 19 Nov 2025 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763558832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pQ44aemiqJtq0zuhYxg46Kkv6bvog9XT2UPmBVw0jms=;
	b=RMWOXnF/ZNFkgMlOeBmixrq5P+Jky/xvy/zWvHNTcg2baoZYZUB4kLAyTLQHYQLNNUxnE9
	BYPR/O6m4Q5pHJm3SRZi7hEwLL7f2LHn7gfzSMpbSgiGgt3fXJYQH/arQ+gewvWAUt4kIa
	u71FSPx6juE+l1yS8fvxYJxBijv/A9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763558832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pQ44aemiqJtq0zuhYxg46Kkv6bvog9XT2UPmBVw0jms=;
	b=9LYejATvmFovj4posftKnmnywuSGp3r7VTCOjjB+7yjVLxPMUHMF6HNd8YUzKj7pHJxX5k
	EB4N0NtjKCDF2NDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763558832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pQ44aemiqJtq0zuhYxg46Kkv6bvog9XT2UPmBVw0jms=;
	b=RMWOXnF/ZNFkgMlOeBmixrq5P+Jky/xvy/zWvHNTcg2baoZYZUB4kLAyTLQHYQLNNUxnE9
	BYPR/O6m4Q5pHJm3SRZi7hEwLL7f2LHn7gfzSMpbSgiGgt3fXJYQH/arQ+gewvWAUt4kIa
	u71FSPx6juE+l1yS8fvxYJxBijv/A9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763558832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pQ44aemiqJtq0zuhYxg46Kkv6bvog9XT2UPmBVw0jms=;
	b=9LYejATvmFovj4posftKnmnywuSGp3r7VTCOjjB+7yjVLxPMUHMF6HNd8YUzKj7pHJxX5k
	EB4N0NtjKCDF2NDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B21B3EA62;
	Wed, 19 Nov 2025 13:27:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nnHREq7FHWl4NgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 19 Nov 2025 13:27:10 +0000
Date: Wed, 19 Nov 2025 13:27:08 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Mark Brown <broonie@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v3 3/8] mm: implement sticky VMA flags
Message-ID: <4dodae73i5ganur6llvbbxcojt4uailsxs6sr5w2jr4a7tzxkf@26rmrmcdjvlz>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
 <1ee529ff912f71b3460d0d21bc5b32ca89d63513.1762531708.git.lorenzo.stoakes@oracle.com>
 <25cb4b6a-035b-4193-a8db-685fc4c58507@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25cb4b6a-035b-4193-a8db-685fc4c58507@sirena.org.uk>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BADDB14000A
X-Stat-Signature: rtq9frw768zh81z4sstf3pdny8c6pxut
X-Rspam-User: 
X-HE-Tag: 1763558833-375092
X-HE-Meta: U2FsdGVkX1/vu59ory1WC6LlhWEQb6azOUPNcvyJ/kO3CDDwneeeIhl3s8l2zvjBwYige3tO/uNqRpo7kWUF0VghIiFbYv+tWXkl1YHPjumZDTAHISI/YRlYeVXo+hP/wsGza8Bcj1jqczWOGYgvBxo2E7sYIw7IvgVhNZhjcplel6biBYUlhS4xdrLEaufwZnzAEfdwb3wTV1yYAiJyIHx9sK44w406jCEXGIQ98Mr3l5YW6OX4jdna5vNd5+c2a0Vd/axYVTUSBFkaIBnJnyYeuMs9hOXCxr1lV4LJNuAZY6moXzPfZVmAqw1AD1h4XaovjNp88y/oZt0yM1qToEho0xZ2b5k3qWHWlcSSGt/UNkrijGg1RSVW686nZdDw8AMeS+0A+ly25UAJfPKawBoPR7xx/hpjxKVDSWKexI3oxZrTuOGJJ5xIe5dPCuvM3b5KVOr/sb8lIdPxfqmVbZNBVh+8IqyluoGFyXqxt+tD+ghLvPDFWhwh+L3IuhoBCD2KFd2uUSEjc2w1tnqtZKdFKCWmqUEsL23wK8gZJFzM+vQ60xn2wfq5lf4KNCvufyN/+gXWOA90AmZXsNX/e8jYxzF5zWxlgdzrMahFHQ+M3xbO68omYLKlRoyoUKbxlG0kQE9aS6Qb1mh+86STGzR92gnSDt2n6Zjw0tqB9JSHFZzpup9JEoQ+Qo7nFKd2ApuSgKx5DjWb2hyino/YtALUN/TQz87hVhROSk57dcu4cHL80C4Q3hJzRGPCFJOIUvo/mHFFg4SQ/FlSUkD3KiCHzmF0ScrVC2ceQcDg8wuUdF7eJf3Qk8ectfuBZRjv8XiANL9mPF5JTWgniFCxW1+0gIeN6s4pcJ137/7raPaclk9+wZnQ2JRXiB0XPCtFu1nNRWCgLDfMXeOOsCx9q6zTYU/s7EmA7nXSWuiIQrMS3V1j8ygVln/jVHhp8ZVjINFjiYIGJAdXkP9BtjZ
 gkBgvg1d
 yevihW4ivcl66kWqrnbbbmqRAo7+dWw+4YI0PVkCbRqRBRQIv43USLkR92n/gqtJiZ2H++LlLFA2RgYT3w3ziDy/oAAQmJNm13EtCbv/aNhq4fWCFb5ZNN8Fp/jAKVsesMPNsT7HrSQ8Jry6OiiuqgxoIsEvzNPhHv0qMemWy0LkUMfv4tW3f5IujH/kq0/3cbiRTjGAEV+9ST2eGdj211ph7SSYiMwqNPbvzPdbufSfsM+Nze3EwrC2R0Sz6Os9pdX0RWYJMI6jjO2aym01TkuuQWc5fps8mxdRvMaMNr64K3P4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 01:16:36PM +0000, Mark Brown wrote:
> On Fri, Nov 07, 2025 at 04:11:48PM +0000, Lorenzo Stoakes wrote:
> > It is useful to be able to designate that certain flags are 'sticky', that
> > is, if two VMAs are merged one with a flag of this nature and one without,
> > the merged VMA sets this flag.
> 
> I'm seeing regressions on multiple arm64 platforms in at least the LTP
> clone302 and madvise10 selftests, both of which have bisected to one of
> the fixups to this patch.  Especially given the other tests that also
> bisected to the same place I've not investigated further.  There's a
> number of other LTP tests that started failing today including relevant
> seeming ones munlockall01, mprotect04, madvise10, mprotect03 and
> futex_cmp_requeue01 but I don't have bisects to confirm they're the same
> thing.
>

Thanks for the reports!
 
> clone302:
> 
> tst_buffers.c:57: TINFO: Test is using guarded buffers
> tst_tmpdir.c:316: TINFO: Using /tmp/LTP_clorMwMMw as tmpdir (nfs filesystem)
> tst_test.c:1953: TINFO: LTP version: 20250530
> tst_test.c:1956: TINFO: Tested kernel: 6.18.0-rc6-next-20251119 #1 SMP PREEMPT @1763523415 aarch64

next-20251119 still has the v3 version of the patchset, which is Known Bad(tm)
after a couple of buggy fixups. v4 should hopefully work properly.

-- 
Pedro

