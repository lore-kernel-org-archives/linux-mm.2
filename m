Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D571FD2F35C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336006B0005; Tue, 13 Jan 2026 14:48:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D286B0089; Tue, 13 Jan 2026 14:48:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239E26B008A; Tue, 13 Jan 2026 14:48:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD556B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:48:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D29BA160286
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:48:41 +0000 (UTC)
X-FDA: 84327978042.14.A543780
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id 472D140009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:48:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Y7Irkn5S;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768333720; a=rsa-sha256;
	cv=none;
	b=qrs/1BpYj8VKVQQ2QOG1e2HBDRh3SEnTLT39I/krbizAlmV8N6Qh4FTgip4apsNsLbQ/wL
	hle/MskhSKx048QustpY5K3YUaSrcj+mtiA0k7x7qs8P/2BnKm5HvvwW7ndAWSplXMQXG8
	xN4Po+E7Ay0sA0Z1b7jL6i/xDBVIxSQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Y7Irkn5S;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768333720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FnQ6Xj9eoyZHqA1dE1GyFR6lhfMRam/O2mY67l2o+yY=;
	b=qInWemvDRb9f/3vfoND9c/v/I5aUpcswpTh7NMr9pE8hNEgFpfUcGyM9KozKYZ3Nbf6iym
	RW3zOOxfkNglf5DKP5K/QyGHl4ynI9b7u0HXQf4G89a8ytsy+TFRVWUrVBbYft2IsoAQOS
	VmChmd6KXC1ukhiEGXOrLFlN4l/scM4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768333719;
	bh=FnQ6Xj9eoyZHqA1dE1GyFR6lhfMRam/O2mY67l2o+yY=;
	h=From:To:Cc:Subject:Date:From;
	b=Y7Irkn5SAfMbS6XllRAOy38YzIKPePFRJxrmK5s/LlwoBiKjexTQsXLqkDvG4V/H9
	 XlrU7L6s6UHwIbnKcoEST9xs24ZMEBbAksgKDYxi6O+hcFqU1Gdzlj5y31k28IQHbX
	 LSTeK5oD4u4tz180kv1jIN6Nh7BtJKTqyx4GNmd6aYsvBQ9I42SFWhZCF3VuNgHKuo
	 eQCrVk3Yh3G0omKKLElaM87Jf/Kh9jNEXWiZG2vhooOzVy6tD5jYEWxhAQrNQDaJGd
	 C5qtL6gUYat8Id5+6CNaBnkKszN5bR+71dNi7CBQBa8h0rhL6/ImQHZc5m4VNK0LcF
	 hNSfuGwcinaKA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4drKYg2L7PzlTP;
	Tue, 13 Jan 2026 14:48:39 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v1 0/1] mm: Fix OOM killer and proc stats inaccuracy on large many-core systems
Date: Tue, 13 Jan 2026 14:47:33 -0500
Message-Id: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 41xegg94wtkyxyw53g48adsj7dg1134g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 472D140009
X-HE-Tag: 1768333720-503052
X-HE-Meta: U2FsdGVkX1+hBzGa/uBOyk5bpIoq1yFt8vwxDIDKkC9ovSm3PjnQND7FUXylkE1JeBZNDGva3t/e8g/QaK/ajWtTOJ4aSBEi5OhDe3UU3B2rjrvI+O+xKnJfP8VCIJpZjRBxo2XYNGtwOUh23N74GEdKO0eiQ4fIX1GJ7LrgIcsOfsrO1dGHuGILtklUOknPRedHf0WjD+iLEv2+BdBwBl3zJYM3THUAC6UkyZsIdxujB+kl4U8jjuARC9R43eut+Tix0EzV2vvpv04KSdn3Z8EkpXn3VTnA+dCkVTRakIpKwwd2Wab6U1U4YsEmZQ9UHkhS/XjEUYwu5twADKBgLV6jghOHlkb8MJuYH5hdqipNwCAs8lDOuxeDm5F6M/ndOxWr3TOhVUL8STg9vNQ5iDHlVdv875iEpIvnVM+ylhpQofnoVfO+eFtPjI4P18OV9pu4ygWyNzm0JiZrt7C1534jlGrsYfL1qbjOjYII3j1pNCvgEp49sWnoI2oB8xu/VBwun8NIvozfjQNUVd8APEQKN8B2cKD3WU2f1rbtMf+IeaVLSe3hroW0p9X9CBe8YRJ6KqCGSHoFYS+ZaoDFQS40N5Dy7iQWanY4jCye1q9OJoOTEXPBMjGr5ZVK1qsVWNAEtfZAXsBDPPpEhAZp/U22z0CQJJXKy+4bi63v0Y3869iJZo7Pht0ULoFpmr8LmbIoi/ehSPcoa75ecbpU1Sv/EPRdgkqbbrEVi4uFPxbW2QljkgiMghZrrA+KI0GtGHLnf72BX3hj3EUbgvm4WkpTrT7/6IGZG03G/uji4hLe6RhAnZ9K7SmdIirVvj4CoUi7pquBj9lRXsKfXWRUJwrsFRQA0uj9AnO2DaxPVyYy/lRj8YcPKehCZin5u6FV9gHgzMnTv/tPkKSBolPAEsQcPy95qPmSDN07XlTTGqWm672m8VYZI/Pmfaq+lO5KqUR3KdUnYTDYS+zc4rH
 eVYi5WaJ
 xQOMHZjLGfVHDV6glUhKmA+5Ehb+G2bHx53mnDl7KUBaFDgQRsjVII0lWiRMu9yrzGpsuCyRN8xNLkJ32ESyYJULbWVX77jDDhEE0TS7kEfNrAzGQh5u4TLDX6Ei78SOoxcpHIQMqVEQDi+zqSsLwhtGDfiJoEYe80HQwT564wQfKGUmdeEarHsNPEIiYnUt7sHU/9Mu4dz8cnudPLTGtoojwc6nVeQnCMLLpyeM1dIFIZ/pGtu0/B/zylFM9OdYTU2+4TLC5r0W8uCQ+P0LPe12VKhLEhYMuePKScFCn5oFtFB+0iqPoqiwG64fEza+6yNtbE+QJKS4CdhaataAzIC8d91aJSguNOW0OcpwkY+Lqr5032tdNF06cxPyNlnsRpTWyLRDmrt4RwdKeQuhL7MdKKdikm0Dn4FhJMbAV8fVAZMxe0x4srEr0GGiYIYUpB8mJSJinkl3NaMnShIz5v5fFjJhn4mcX8lucf3mpM1pVDZu5NdNlHybfnXoJWhyTaP/X/twum6hGHw2nTH2mWwv6zmxhUGV5pqKHDkJfN5UEKya4OqDB68d+1g8KSGS42nvM+S//Rp/OAZeVHVlVLCqRHwhvhqHW3SsW8uq7Se0EJ1L3qCqkRsALzXjY5e/U68gQ8VhYNuEHwlluBi1d5uJZL0yYt6MdRL7+xoKVViXmRUDH85jDwkx+wQIuO6vV2Yn01Yy7sVnc0lTb/fFfoh+tZuR2tCu5huxgya6l7gJ/LbYOLP1hYo1RrAW2nwAntfZ1w62X5i2mZRBiQ6ccEgGjh7lDVJgCHuOuDQixmZ2wGB9lBuGOaUSq+EC0W4bdI3zJ7OLbsCYfjjMRO0hsDVbisU5Pz5iGHoZGYfsYcGdle9E8ypdsiVIj2o1Q+6rVm+DiqQEMraJ0yFU126BJhFI1rzARGMe11u+IAGtj4Dq5NHxGZ8AvIWALxPPQz88/mLaj9mJTy+Gc64F9F7i5iYBdZAA/
 hMdca5pU
 RQTkNtMwOz0wRZERkOMSkfwbeFuw5FTLKAKRIUdVBEsEVZ/LN05h3ns99DhyIZieTGhFcxUWaJZW/tGIRJZWHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

This patch modifies the OOM killer and all proc RSS stats to use the
precise for-each-possible-cpu sum to fix the inaccuracy issues. This
approach was suggested by Michal Hocko as a straightforward fix for the
inaccuracy issue by using more precise (but slower) RSS stats sum.

With this, the hierarchical per-cpu counters become a simple
optimization rather than a bug fix. I will post a new version
of the HPCC soon which will be based on this patch.

Feedback is welcome!

Thanks,

Mathieu

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>

Mathieu Desnoyers (1):
  mm: Fix OOM killer and proc stats inaccuracy on large many-core
    systems

 fs/proc/task_mmu.c | 14 +++++++-------
 include/linux/mm.h |  5 -----
 2 files changed, 7 insertions(+), 12 deletions(-)

-- 
2.39.5

