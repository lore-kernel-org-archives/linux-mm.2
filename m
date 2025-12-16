Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BAC6D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907B66B0005; Tue, 16 Dec 2025 03:01:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5286B0093; Tue, 16 Dec 2025 03:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B45F6B0095; Tue, 16 Dec 2025 03:01:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65ACC6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23C76160528
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:45 +0000 (UTC)
X-FDA: 84224590170.06.598E1B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C8BE71A0016
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWZCY4TQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872103; a=rsa-sha256;
	cv=none;
	b=SHA7vN10ZO6L2aryBwK0s1S6oLE0kHWjL18x+XaGA3BfIpxezeM81EhiI0XxvQGldZROl+
	J1ETffX/eSCgoZb0v2z5Z0z4NokfiSyVo8ANaRJixjw6DVY9BoPcF/j3z1a9cXzwPtv+DA
	8sDw9SIc0hua+Jf9BjGiBIg5SaUghOU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWZCY4TQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rxGaZB5SFBcuHFam7l39Swmr17iB5g/PJOaY8gqTPqU=;
	b=dRjptgxFXOmYMWtScgQO8Qc0GIn7X/SQ5qN7u+9pPi0i5hNe3/1Y7s1odfCY5fDV+0hYX0
	2XPFDqCSJa/TQN3r/4/9V+Wwqd21asGhDN8OZ0LUHZcUt8xbywXmcfRtLEwUffUgGN7KkP
	8jT783yQeVL00AzjeD7YynnTqi9mdlA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 361B960144;
	Tue, 16 Dec 2025 08:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B35C4CEF1;
	Tue, 16 Dec 2025 08:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872102;
	bh=qBAnD+Vuikt86PoF0RLrT+1nqQxfYAOJ8cjFF9lggmw=;
	h=From:To:Cc:Subject:Date:From;
	b=UWZCY4TQay0i5+f+wObSpeovHyzE1AdyiiPhBbA+OBybOaKJBOffvzeD1Qmc3CuXx
	 /Nv7hIPp3glvMnqXL9ielgEGo9SuGCCd1M0wxcC6XXco9prMW4wgSEMMfG1VH0Z/nR
	 l7dzXAvU0vbkYoZIJZFM7altOH0pGtMStIhHjDNaa6IWTSGgVyym3WEzGnJMSqha8a
	 Hj1DGkXIemcaxBNGUAZt5SIMwvGsXAyDIDKGJS3+E6nwglFWQFy5wI+Vgrm/UfFrMq
	 dlmUcGU8xj0NcwPCoW6GUZF9l/i6dNITXiplFFAsbLYjolGR5tRN+lupGAuGuwz1vR
	 jeyDiyXvJ/6pA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH 00/12] mm/damon: introduce {,max_}nr_snapshots and tracepoint for damos stats
Date: Tue, 16 Dec 2025 00:01:13 -0800
Message-ID: <20251216080128.42991-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8BE71A0016
X-Stat-Signature: ddya747czwnuopx3n486n3wtm6im76qw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765872103-475372
X-HE-Meta: U2FsdGVkX1/4vucca8NIR1G3L+5KY2trDuAm5vzEFYaXxnr7Nug6ovtCkuWl2DGJ8qM1Xp/FnQ7zwTUM0K8b5zQLcaqpKV07ZTr2/UoaWhGQOu5HZXBOH0L4dXBxrg1ah1rfhUYVyEsP1fQ4UDFbLCXs7jTtdzlH2R2hGUWDDEIWDbzy5DDy4gA2yYSKjKcrK448kvI5m+Fcy7MM7pVoeypgEmO1c3I3x6Hc5mFdwq1ixm/semL2n5bvtPqWb8lI5hd/7naj82Vw2DZioFsQmr4dDCO+81QzPcC6vCfRUXeZYEUiz3l+hPTZi0MljKRup5EN+1pEuFzlnrG6t6QH0zgP/hapgQNcNoVSoPLOvF5kGk9/oFkhK5ggbsNZoTIaKVAZ5qL513ShHOEjur5WzsJIad892xT+WPAyy6ukaZj1wg6/D4lsZuJMMC4p6OlLhbA6W0oYSuNzZqNjWUVdbYX4gc4TWevp0BZrCEo6yL/VZf5oy9oi0was4iWJo2WLRIjqa1Ufor+JWG8G4A9TBTp5RWsdXB+Wty/1d+5khSWsjNzm4rOrdJorY1Z8R/YXD9wc7zuKVkyS4f9CZeXi764Ah8tm2Ugx+4i4+G31XkMgtOqL3sSIadpRg9vLdxdwXipLc/Z4AEN0uI7Efs6yGfrbHg+QRm9PgBY43I3wC+4kLuXzyeouc3FhzD8IjWK1Yq2rFh3k/afWiALAaEhttJ609Lg5xGp0jDjmdrMdi/V8eeqtBzN1A9/8UwWCcCeXt0mdcN1S1Da5azVTOAXWV0pcvi8yImWREWa8wFxKaYZDZNPNACC3GL9Ej85p5c03wKRQa5opZJNNqalqgyOBqF0tdSlw9hyh1Pi+grwV1Em0ZkYmwJnpyK710frymKlvNvUlxxy9Igse7jbhb54du22H5F8cCfTLL4EsAld4rAlBOJM6KFXcys5KFbk616G4Qg0gcssgfcw2oTaMTOC
 brGRdylZ
 RddYq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce three changes for improving DAMOS stat's provided information,
deterministic control, and reading usability.

DAMOS provides stats that are important for understanding its behavior.
It lacks information about how many DAMON-generated monitoring output
snapshots it has worked on.  Add a new stat, nr_snapshots, to show the
information.

Users can control DAMOS schemes in multiple ways.  Using the online
parameters commit feature, they can install and uninstall DAMOS schemes
whenever they want while keeping DAMON runs.  DAMOS quotas and
watermarks can be used for manually or automatically turning on/off or
adjusting the aggressiveness of the scheme.  DAMOS filters can be used
for applying the scheme to specific memory entities based on their types
and locations.  Some users want their DAMOS scheme to be applied to only
specific number of DAMON snapshots, for more deterministic control.  One
example use case is tracepoint based snapshot reading.  Add a new knob,
max_nr_snapshots, to support this.  If the nr_snapshots parameter
becomes same to or greater than the value of this parameter, the scheme
is deactivated.

Users can read DAMOS stats via DAMON's sysfs interface.  For deep level
investigations on environments having advanced tools like perf and
bpftrace, exposing the stats via a tracepoint can be useful.  Implement
a new tracepoint, namely damon:damos_stat_after_apply_interval.

First five patches (patches 1-5) of this series implement the new stat,
nr_snapshots, on the core layer (patch 1), expose on DAMON sysfs user
interface (patch 2), and update documents (patches 3-5).

Following six patches (patches 6-11) are for the new stat based DAMOS
deactivation (max_nr_snapshots).  The first one (patch 6) of this group
updates a kernel-doc comment before making further changes.  Then an
implementation of it on the core layer (patch 7), an introduction of a
new DAMON sysfs interface file for users of the feature (patch 8), and
three updates of the documents (patches 9-11) follow.

The final one (patch 12) introduces the new tracepoint that exposes the
DAMOS stat values for each scheme apply interval.

Revision History
----------------

Changes from RFC
(https://lore.kernel.org/20251123184329.85287-1-sj@kernel.org)
- Check damos_stat tracepoint enablement inside the trace function.
- Update ABI document's 'Date:' fields.
- Slightly change series subject.

SeongJae Park (12):
  mm/damon/core: introduce nr_snapshots damos stat
  mm/damon/sysfs-schemes: introduce nr_snapshots damos stat file
  Docs/mm/damon/design: update for nr_snapshots damos stat
  Docs/admin-guide/mm/damon/usage: update for nr_snapshots damos stat
  Docs/ABI/damon: update for nr_snapshots damos stat
  mm/damon: update damos kerneldoc for stat field
  mm/damon/core: implement max_nr_snapshots
  mm/damon/sysfs-schemes: implement max_nr_snapshots file
  Docs/mm/damon/design: update for max_nr_snapshots
  Docs/admin-guide/mm/damon/usage: update for max_nr_snapshots
  Docs/ABI/damon: update for max_nr_snapshots
  mm/damon/core: add trace point for damos stat per apply interval

 .../ABI/testing/sysfs-kernel-mm-damon         | 13 ++++++
 Documentation/admin-guide/mm/damon/usage.rst  | 11 ++---
 Documentation/mm/damon/design.rst             |  7 +++
 include/linux/damon.h                         | 12 ++++--
 include/trace/events/damon.h                  | 41 ++++++++++++++++++
 mm/damon/core.c                               | 39 +++++++++++++++--
 mm/damon/sysfs-schemes.c                      | 43 +++++++++++++++++++
 7 files changed, 155 insertions(+), 11 deletions(-)


base-commit: 37164b8fc049b9a72b3f0fa9bf3241e8852931a9
-- 
2.47.3

