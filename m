Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A4D606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hgvCHIek
Received: by kanga.kvack.org (Postfix)
	id BA6986B05B6; Wed, 18 Nov 2026 09:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E216B05B7; Wed, 18 Nov 2026 09:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABAE36B05B8; Wed, 18 Nov 2026 09:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7036B05B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:18:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1ACCFA077C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:18:47 +0000 (UTC)
X-FDA: 85448445894.23.DD15675
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7BEDB180002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:18:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hgvCHIek;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795011525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omjjlnQ1ZJ0MhBqkhPOBcLqOsv5nWuoArS+/Pbu32u4=;
	b=NmB60bYJyWsvZc8/ofSgxnLAYPQVtanZDD4x8FwOn/qnnvx47lHwMpmIlTX79qzQRUxqbR
	J2z7YoMFg2TA6zB9jCv7Rd1vGZ/ob95ZpBpUmpkvwyEhb55IwAzdqUSW6CS6T/t4OmklSw
	LpVLhvEh5i2EunAWLnO5k12T/uNuh4c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hgvCHIek;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795011525;
	b=yZSqVpOTzZjA3rwnpIgP++SdmWDSVDL7EMruZwUA+iKaeM4l5iVKnWgGWxNPK2PNRHUTgS
	h56d0v/gmrlaq2HAnvGu8napuJIRrDEtW5l3pYBOz+3+3rhmDH+PpJfMA3GaPKY5546MR2
	f7G87BvfUKoSrJ5ShFqS9CaXkyDSMLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 16FB462237;
	Wed, 18 Nov 2026 14:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 158801F000C7;
	Wed, 18 Nov 2026 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795011524;
	bh=omjjlnQ1ZJ0MhBqkhPOBcLqOsv5nWuoArS+/Pbu32u4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hgvCHIekeWMD5z9HUp1GpczxJH97zCvgETH/xhnJ1ZBZgU54WIlwdNVCZoVIMjwI3
	 b1qW6Yyr0er7e6X/pUrlbQqjyVNyy7gFVq7VyCqot1Lhaw815N8X/dieBgpgZTQM30
	 Qp05hEFjO2SZl+t+4BUKPw2jyBR/TkO+yGVB8dEI2YkP4j11YsGyui/HsrJs5U+W5j
	 C2693zwXc5m1ern5G23a5PK2m6IOOSafzy+UZ9Gp7W1jiSuGuaXGwFLJmcOVxFKdCk
	 7/ojQKABwBn5p1KdHyj1DtsuL6hQ3xlABpn+YsHYSB2Qz9XSI7h4XQ+LmVDkYDN3SV
	 Y7pzf7AQ0dlFg==
Date: Wed, 18 Nov 2026 16:18:40 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [RFC PATCH 03/13] rootns: Track init lifecycle via
 copy_process() and pid_namespace
Message-ID: <av2zwC5IrBXJo6QM@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-4-jarkko@kernel.org>
 <sashiko-outbox-220138@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-220138@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7BEDB180002
X-Stat-Signature: 1h3983e5t3c4wubhkj8cug7rh5mems5m
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795011525-401
X-HE-Meta: U2FsdGVkX18dW6C9DGm7xCSLTOPrcqhc8gnk8lbcD4EZpMZ1aPzVMTYe1WZA1Y+YIa/5fdgb9toe+d2rxf6W8vQaSwWMNgfN94fxrgsC+yzMLnfxKFMCwYgTFONHQA1h5PdpEXSxqY5iaPA3ZxFwyEfW0R5npN9o2I/klf8xmHUTysUy5OyApkD91rB5gWtLirz8GXfVBqWlhveJagzwOZnwP4tt4+PVOz54emwtE3dN0DNGeEkrsah8YYWUUBwvgFRzJc9ZTDd7N9SYkxnVBEQ/VnNdxSObrZriu5d/Q9lBA0vnpYQ//PkxsWAfts9/MMjQ4yX0y4SZlDfPGKGpZTaENdFoWNzmU8t+n02Kpa50TeXRg1fkacCLHmma47m8BbeSlUK7ob6b2Qfz5jppLZZJ3AA9S35n/PUZU/rqv+xuQeXFlqA7SQEZ2z1TRDgw3HcVWK/yk2LMi/KFPPxrgQluy597YWP9oPRJi0NZkHU34preYMQsPJ44XiBuCv/1YDJJpaseVaUhUhrXMHq6FF9qWJonJonnNjqoWeM3zEHqjnZGCxgZvvEiCJLqdrrgtNyDIQ33Q33G9irUoZIG+Ow491YqoFj4uXbL6qAAs8Mp6Rjbzaq1KyBRKcuS7LKOyORDDkI/N+dNQKFyj5WlNOsCtX1bXBVwFZ+VRE3RBFTsAkg+b0G18fOQb/VYBeoN/3JGQ/tg+N2wzyOTSApsZ8u6nJp5+ove88tlxeVhxyUMmwf141qnlcwPkLvWU8jCtoAWy1NAmuQ+oIlRbEs7QOPSqlP0Si5FSDLaTEJnHTIaeGSiefDMN7ns3ykMGPC6gMeDAhermJrJJlLyfUOUcy+ULhVfxT0WXDFra1+CNCxTaLwCRz4h+zV2zBOH5pdrLYiWDzrGz+cr6ysAEHBg35bMpiUNJlmDVjzfO49vWzMt6jRApBvjBhH8sfSmB5DlOn021nFl0nTQf3J5b+C
 CHEaBa9m
 OGVbZVMTDDD5oh+YeTLLoU1kByHeHnT5SLGX8J3u0CaSN1YwIe1u8LwsxgE0Nm0I/cjGG3khHJl3mHT77oQq+QNVp0YpKGogxAoOktBUc1Y6iMjQxhSUV9zgvA+1ji5bOXQ+qVpjHpO841Y2P4TU6h8IcZAebJj0juiOeJsvuWyBTuJYkpbYmXov53234UKwqPxDNdgjjDSgXagP1uaNPvEwwZKLlHoEMivawplScXbQFy5fjWWs+RRnRBSdp6bVOHX1eh8giTqLZjGgfhKrsKZsxyHjl1Mvqx/BVvHjy7PJB1LkRbHPUu5BJqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 05:09:42AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issues to consider:
> - [High] rootns: UAF and refcount imbalance in exit_rootns() via
>   unreferenced pid_ns->rootns
> - [High] rootns: unreferenced pid_ns->rootns pointer in exit_rootns()
>   causes UAF
> - [Medium] rootns: copy_rootns() publishes init_pid before
>   attach_pid(PIDTYPE_PID)
> - [Medium] rootns: missing is_child_reaper() and locked state checks in
>   copy_rootns()
> --

I'll address the Sashiko issues, reflecting them to v2.

No need to spend time and effort for review before v3.

Br, Jarko

