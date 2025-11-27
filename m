Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4FC1D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 23:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC446B0027; Thu, 27 Nov 2025 18:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93BA6B002C; Thu, 27 Nov 2025 18:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9486B002D; Thu, 27 Nov 2025 18:36:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B86BA6B0027
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:36:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BFD2C02E9
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:36:49 +0000 (UTC)
X-FDA: 84157999338.05.06CB15E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 280154000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:36:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q3dhaBrY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WMf0YdHG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="J8O60E8/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NMupcRbn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764286607; a=rsa-sha256;
	cv=none;
	b=JUS/UTZGfQZ/AnNXfLarutKuc/71MDmzatJPJXwzM2lLapF9GEFY+Jwzm8mYZkGA/Fzzov
	RpwjvM3jaWngPYtnwP/rp5I9rnkuHOyTGhKvV3i31rOb94EGPB8r4dB0+5sdIHtMpiMZCz
	tVXmeNhbe4PKz7K8nVcdh3y2k0GWEgk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q3dhaBrY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WMf0YdHG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="J8O60E8/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NMupcRbn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764286607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wSQDXIqh9OVz4pGakQfvy/4iJYn/YQqDAmAqSfiXVOM=;
	b=RQ1gTD0QrQpv1V4Tje83RKGZw9dWvc2M4GORRFQeIJsWEDVd6OjZl2INerhOjD6TjK/E8W
	7MTNF31oRGVSrEkt7Ya1oPZoDGQH0pmVi21Yf2q9dNbOpHK2ttXcZgRmu+rFVh0EhYo8ny
	/qRsCoc2VH0/VbL99QYk//JfyM54FQM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D5BDF5BD07;
	Thu, 27 Nov 2025 23:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wSQDXIqh9OVz4pGakQfvy/4iJYn/YQqDAmAqSfiXVOM=;
	b=Q3dhaBrY69YQefYdLldfgAKhjkmGZ/6Yl2OUU5UT4OdJ9i4dH71Drz/atF6fG+pJXR7k7b
	QVcCPHC2nxmBcHgzi8APxFAkeFwDdZbOXuZD836r3enAwso/w9PU3JRWYbLa57yM5C1SF/
	EW4sdRWem+GI6+WwsgwfWFNx82JSD6g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286604;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wSQDXIqh9OVz4pGakQfvy/4iJYn/YQqDAmAqSfiXVOM=;
	b=WMf0YdHGmcscI59YS1mHkPvtzW6mT/anJnr8YIb5UvRctUJ/3Uze/OeCQi7Ib/358RqRGe
	so+dhcU2lvnpK0AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wSQDXIqh9OVz4pGakQfvy/4iJYn/YQqDAmAqSfiXVOM=;
	b=J8O60E8/jt/AU6ulL8BaoTiEfAgmwWWjpzmWtR99meSLDIZk3C0Txk8J3hfhtpjztKkQ32
	/ch4Tz63HbVt7UqL/XtQZ8zo0POVKlaSgQQYeW/aUud9EbDTe+g8v7CQDMsNgex0WzgM4r
	TyhOaFRQ581FKK8bLY/LODaDWExYS7E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wSQDXIqh9OVz4pGakQfvy/4iJYn/YQqDAmAqSfiXVOM=;
	b=NMupcRbnkA3I49Q3T13JTL68MxJ47UcX7F/Tz6U5LlRcIzQ7I2MUGO1PibULbpABwUYIJm
	aI/NmV5mWKXNk7CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 838673EA63;
	Thu, 27 Nov 2025 23:36:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qLQ6GYrgKGkIGQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 27 Nov 2025 23:36:42 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-mm@kvack.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	Mateusz Guzik <mjguzik@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for single-threaded tasks
Date: Thu, 27 Nov 2025 18:36:27 -0500
Message-ID: <20251127233635.4170047-1-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 280154000A
X-Stat-Signature: jx4x4pdmy5um13u45xhaidi7dgmxkqxz
X-Rspam-User: 
X-HE-Tag: 1764286606-362738
X-HE-Meta: U2FsdGVkX1/4rePX78bwmMDeNGRD1OW7/7ZRr0lR5yGXkqtaylSG6cCPMVXSDxeiaOdqN+S0h0FXWwvFUDj4fuEQLrA3lHUKa+7siKk5g6STxejWHe60QLT3fgQJuNBUdOiNENdh6n51rNZE08KFEyblLtRkb9biDRJBuX7xFlEnSmcVUw2tWNkf2S3qdzg6cuCTLhPmYrSahcX/Y1TOhgC+hgu4zqQbY21MTvlIqkU7mOi0rj8A+h8ZJFOOOK4l9KArrRo4J44dNGhP8UNziWujr5UafdtryHPfBwlP8xp4918xDxxs54JJ6PvVCzNgADGTO4xb9XyWg5f2ZroG31woGjkVEjulpJJb0bV2dJaMLW4vhpZt1Gqg3Pg3iOxypALU6o1k9QnSRnZmo29a6/oVMAC9BFS8lTysOzV2uMlnVUvVmxjJfwMD+543Bs1b+g0dznxvHxcFVUMzwo3H8CPW5cCTDlqSCbHtC9TBYhtL25uUlLuTCshXcVSNepmKQpd9eTAZ49WF+LWbMldOXofZcf0/3tgxq7whibPbMFQcy1MlenStdaNM2cgpB2HaPGopJ9dZSvvMVcJWVVMWZ4ko5feaabwnFLX24BfUftjVIlepLLLTeWOyMrDypsYvOatfyuBH7maOR+RTJ/h8qqNqPh7r0KSxJgsfzuVw8cLH+48IPCAEPVzLRCCkgdU5d8A30tu85nt4fNL9qetJmp4Y2rwBafMyj3YS8wzx1FqDNv/K4B0bI2U3uhQmN668cP4o0hxj1qdrx6M+rKrE6/1juEDBDNGvTvzdNLwViClhu2iR9hD1PSvAfhG5t/+3Tmae7+9C0tnerDYK88e/IFY9zXn67OZQY/asBxOdgSyr/wNQhlLc2mlvry9kqXzvKxPctTg7W4X9ZVDLK1rHHisbgVTA9kXBMfssT/SLr0lBOpynVSmey+cZjQuHdenh1UVzCziEAnu4rzqbVG0
 9F2HXmzs
 B4ndD5kT/78PWGBGIZRz1dxy1aKPBFC6ZHc3YnPp43G0ikXnPyNaEW/juzu4sXnUouGL/wh5N1yPBjPNjwQRUJXBk4zEE3wSI4ZC50bkISAq9AG0k7g4T/x5PFSYTAJjMe9N0mWmaMGTw+VtEBVum49omapM4WmeAAWrdRptGbMk0zMJwGsmOKbNqW6Td7LHd+QXChBrYRvQqPnQ5GT9cIepQx8jUwOzul5nvtMQwo5JeYKiUKTn/4DDHr/AjvyTX8ziPhFKJsNMczeYQE8YSSqeGwaoHZIEODG5BQ2fUuXWDMmWIlnZo/AScqrTukjWB2Uc+bP6g9BdTLpTVxmHNI1d1LlDOBT59bKx8mMhAbiUBO3mMb1+qUYuojQRSAj3LEGgmroh9fzpCqNeEoMGhi81QCYy3cmJWS3FL8uRGcdjYrrExaxtRlmZoO6MaZGKUbBCSyDjT8eAzSfslSDtD1PHQpFP9tN/cKcVHSCyA50odoIbIy3M1UpjjySKIHxSZo8qJ3NrDy1USXVcRQbut1u9y1AZFs9cKRpfZJWK0+sXsBJiirFGGizqv2gNq60pGtDcPk5XhkFNAbB7yHu0lXPhHYOIfKRyE6sPa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cost of the pcpu memory allocation is non-negligible for systems
with many cpus, and it is quite visible when forking a new task, as
reported in a few occasions.  In particular, Jan Kara reported the
commit introducing per-cpu counters for rss_stat caused a 10% regression
of system time for gitsource in his system [1].  In that same occasion,
Jan suggested we special-cased the single-threaded case: since we know
there won't be frequent remote updates of rss_stats for single-threaded
applications, we could special case it with a local counter for most
updates, and an atomic counter for the infrequent remote updates.  This
patchset implements this idea.

It exposes a dual-mode counter that starts as a simple counter, cheap to
initialize on single-threaded tasks, that can be upgraded inflight to a
fully-fledged per cpu counter later.  Patch 3 then modifies the rss_stat
counters to use that structure, forcing the upgrade as soon as a second
task sharing the mm_struct is spawned.  By delaying the initialization
cost until the MM is shared, we cover single-threaded applications
fairly cheaply, while not penalizing applications that spawn multiple
threads.  On a 256c system, where the pcpu allocation of the rss_stats
is quite noticeable, this has reduced the wall-clock time between 6%
15% (depending on the number of cores) of an artificial fork-intensive
microbenchmark (calling /bin/true in a loop).  In a more realistic
benchmark, it showed an improvement of 1.5% on kernbench elapsed time.

More performance data, including profilings is available in the patch
modifying the rss_stat counters.

While this patch exposes a single users of this API, this should be
useful in more cases.  This is why I made it into a proper API.  In
addition, considering the recent efforts in this area, such as
hierarchical per-cpu counters which are orthogonal to this work because
they improve multi-threaded workloads, abstracting this with a new API
could help the merging of both works.

Finally, this is a RFC because it is an early work. in particular, I'd
be interested in more benchmarks suggestions, and I'd like feedback
whether this new interface should be implemented inside percpu_counters
as lazy counters or as a completely separated interface.

Thanks,

[1] https://lore.kernel.org/all/20230608111408.s2minsenlcjow7q3@quack3

---

Cc: linux-kernel@vger.kernel.org
Cc: jack@suse.cz
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>

Gabriel Krisman Bertazi (4):
  lib/percpu_counter: Split out a helper to insert into hotplug list
  lib: Support lazy initialization of per-cpu counters
  mm: Avoid percpu MM counters on single-threaded tasks
  mm: Split a slow path for updating mm counters

 arch/s390/mm/gmap_helpers.c         |   4 +-
 arch/s390/mm/pgtable.c              |   4 +-
 fs/exec.c                           |   2 +-
 include/linux/lazy_percpu_counter.h | 145 ++++++++++++++++++++++++++++
 include/linux/mm.h                  |  26 ++---
 include/linux/mm_types.h            |   4 +-
 include/linux/percpu_counter.h      |   5 +-
 include/trace/events/kmem.h         |   4 +-
 kernel/events/uprobes.c             |   2 +-
 kernel/fork.c                       |  14 ++-
 lib/percpu_counter.c                |  68 ++++++++++---
 mm/filemap.c                        |   2 +-
 mm/huge_memory.c                    |  22 ++---
 mm/khugepaged.c                     |   6 +-
 mm/ksm.c                            |   2 +-
 mm/madvise.c                        |   2 +-
 mm/memory.c                         |  20 ++--
 mm/migrate.c                        |   2 +-
 mm/migrate_device.c                 |   2 +-
 mm/rmap.c                           |  16 +--
 mm/swapfile.c                       |   6 +-
 mm/userfaultfd.c                    |   2 +-
 22 files changed, 276 insertions(+), 84 deletions(-)
 create mode 100644 include/linux/lazy_percpu_counter.h

-- 
2.51.0


