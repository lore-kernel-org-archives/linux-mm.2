Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F20CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889A66B0005; Tue, 26 May 2026 04:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861386B0088; Tue, 26 May 2026 04:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79DF36B008A; Tue, 26 May 2026 04:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68CBD6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:28:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F93D1A0301
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:28:42 +0000 (UTC)
X-FDA: 84808894884.06.D0EDF39
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id 84BCDC000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:28:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YPvff5e1;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=A8xG6QD3;
	spf=pass (imf22.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779784120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLZEus+tCL11fm5pjczjLroLeFvpHRb7wyyV18rDJdo=;
	b=J3/oHvDVHNEUHWyk+8sAamWLiO8v3qs7NLagGlV1d1ok3BqzwLZ0ga07YufXYHrSMNkoWh
	KIFyuGS4Azj42nlVFAYBEhmS4O8FIkh3tkNBXr3KjvX5YoEJKkAxBLdvMXu4FNOdrvTZhe
	vwRaclwUqVXo0zddvVAfq2Yq0NZOaIc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YPvff5e1;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=A8xG6QD3;
	spf=pass (imf22.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779784120; a=rsa-sha256;
	cv=none;
	b=SpGVMdbc6I2lVjOHf2Agg8g6/lX+6MrXmQgsn/jfUM83KQ+8Fo5OSRf2JpyKP8MDChkVhJ
	U3sARfY9AmAEqUQ59hFHKDdttYS/j/f7vTTRQfC17v7YdrfoaeQPlMkjv1ol/giNVKft+0
	AMjzjZlD1ygTRrBMkNDa/tcG6xekFpo=
Date: Tue, 26 May 2026 10:28:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779784118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OLZEus+tCL11fm5pjczjLroLeFvpHRb7wyyV18rDJdo=;
	b=YPvff5e1CqWDNw0LdhWd/NJTJdY0t3d+BO+fF9C7go3km0AU9OU0oKEgMSRpEDqSGQqkrm
	bQagXu8iCrP5ZdU4Ol53J9hhDddmjY0niil5EJOM3kmsZpMBieptHfpRyzGMw7Xz+z08Lz
	223fz+dRSYTKE7k9Qo7UNvkGMNP+qxz1ePFYd42kbXBdz8Ntw1aZ8xcBXnmbH923rvaMJ5
	H4DRMBgvRQ3rF4ii0r9LJk7VnTAtBptZAqFtfUXo54g9EwkBbfgk1BiOkwq2eYxi3sAAcp
	PZ56Rxfzs/vyMeOQMK8BJDyfhN9ANrhvryyU0z0IRPJcoicCQEk3qkdAb5y94w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779784118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OLZEus+tCL11fm5pjczjLroLeFvpHRb7wyyV18rDJdo=;
	b=A8xG6QD3U0AlvPv5eFmggfqrUJ1hYC5luFTi2p5IDfdF0a88uKbba8DStU3iPZZPv21xDb
	uQMSgpIcCxrIGuBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Michal Hocko <mhocko@suse.com>
Cc: Waiman Long <longman@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] gfp_types: Introduce a new GFP_ATOMIC_RT gfp flag
Message-ID: <20260526082836.9BOv1yCM@linutronix.de>
References: <20260520204628.933654-1-longman@redhat.com>
 <ahQLVgj8zV4xQRh9@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahQLVgj8zV4xQRh9@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84BCDC000E
X-Stat-Signature: m3ntrq5c4akfxi9s1zhf738d68wdsgb1
X-HE-Tag: 1779784120-824301
X-HE-Meta: U2FsdGVkX194aroLwQxYp7A4F/Zr2uUirXq+pdqmTlVlnq2izm3PL/AbX10OSnYddpXNI2LUQwfyxhxGeOfnWt6dWLea3U91tjDuQ4IPuyKEMI3lOD+lkKvzbx12BYs43/01dn2qZbhWFnbRCfVTgfphkVBLqf1+AX1EBU1ZZd5zUsIMe05SQtoDTlFUcUpk2aaXOL70EnNqVbDAkwZrArYB6sHLr0CGr8uk0ZjX8gXa0lTdJLUFNcKuXOxLKFlmF6Yg4xyZo4HN3644fjTfp0B+XkOc8lb+Wvm/L6Z9mG/hZwFyWlKdO/duGSbWU03oymX85408PvzPjdawXvYlAYxCu89mN2Vp4R5vN2jGY57+MN2ICyEagP4sd9PulsmNHjNmGpKDznywsSceFWfryOc7IF5ZLam+uRtWeF0OEYjL3qsK6vLWdYDuidhphijzV9jXWf2UxfWmN6HdcIfRVxy2eJ0SAzw0uhZxKxCmkIYtnxK4ac4BfqIY3UusZZAIfCVv+JtlHl3js8mM5bQPT3v3TII4jX7nN4lsM2EE8Ox4PHpURzb+Zbk3Uz5Cf5GqWCXfCAVfqSyA5mbwi1FyxmdYjaKW2jwU3yk3h5M+hP3GX997fWeb4rUkOK+Y43se5g2OD3OsmVZ0RyZiRHRMJE5RbHAUGWBCsnanIxMHELHYsW3/nTQHX6aekBAce3UaWha5tFvf1mmpKmB33ECpwDARWLiWonO7hoTjrKY/ke4DeyQzrivwjO+a5OrM5nbBff7lUnqoigqpfXoiSTwgpDPUqLJhBdl4N0XD2Lv/imlWgwK2zuiOn8po9meLhfduW0qIwew7sf2vCu1Z6W3LpOPgg4oiiCfUYzhnU5vb3OI9+fK9i3P3Yml4JBM+YOD0yqe3ijgDXhA9jTQT+lm+/LdJHpTQKB5oaelmQT7TderKqVKsZeYFwGvZvBu+L+moEwkNWGqBVYSCVEMlShK
 n2YTKjwe
 flZ7to0kYA8gkjWRucvsSLT9/kysxa8tpja3Bq/LDm4sBtwRhOKh2KdBs5uHzFLhAWZY3dxpYxoTh5wb4B41I+JJ/UEUwyH4sSihIkJgB5icGxXM+6TGsz+mvxF38gHOCZiq7cyMZlMgpZS9Mihu71kQbopMFMMOZOstyL5BNODJ/pp+sG5maJSXm98MD/H4FEeyrTWFAL/GH1AOiMjgTAw9Di2SqiXMV5kCHq3erzW7TIcBgHX2F8SAvWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-25 10:41:58 [+0200], Michal Hocko wrote:
> Before we go this way we need to really be clear we do want to support
> raw_spinlock (aka RT) contexts. This is a big commitment because it
> dictates internal allocator locking that would have potentially a much

This is only needed for 2/2 of this series and Marc didn't want it.

Sebastian

