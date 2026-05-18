Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A417CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F246B6B0093; Mon, 18 May 2026 05:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB406B0098; Mon, 18 May 2026 05:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C9C6B0095; Mon, 18 May 2026 05:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD2496B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:50:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2483E4092F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:52 +0000 (UTC)
X-FDA: 84780071544.06.73C6FBA
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id 33EA1100007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DLPO4Hsr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=8zp6C0gF;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WT4Vm66KOVZA0RJFOAYxcv97dwxUA3fg020L2O5ssYs=;
	b=hNcZmK6uqY6kdOljtEWs9hHq8Pvp7LOFUjpTVs6ovQsJrVmQPUp2Cq0JpmKPFzoMrrmg+d
	e1q4d112w6PyyEFSIn+AoPCuqWEGytO18sVHmmsXje4dfB+MM1bE8I6ISXrbJKYBSlcn8j
	fWpxJhrsMdavFeZ6QRAKgA+WRKfxoMM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DLPO4Hsr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=8zp6C0gF;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097850; a=rsa-sha256;
	cv=none;
	b=rVWARc9HftHeUlYZKhMkIj1sfbNMizaoJ+qwr/WAl7sYt0Cns+2CMNSrKX+1kS6LJOo9x0
	JFsmvB18jJYmAeOa5CvvXurWt7nM3n8tLiQRfd9DlPBqfRCCGA8vzhfIUu8EFZtQ6myTaW
	IGFrHygoXDN4jP1OrnrE142y7o7tC3A=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779097848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WT4Vm66KOVZA0RJFOAYxcv97dwxUA3fg020L2O5ssYs=;
	b=DLPO4HsraKrv0CNLdYLCbcXFua4ZvZ+bgAgNB+fzdu2euU0wMVDczxB+PYVOyDdv7h4a+V
	eFjwwkxC38gTKAv95wjIbir4RNitUNyIjgUqf23DsOXGvUixPLfDJn9gg8K8SU8u4A0c85
	HpHEfBAKp5Ocuu+UOnffGZIpXVumujJJ1zuO7PE+4X72WzTLjhTEUnTcgN7tISKCwNEvUQ
	KEy6VmDNmYM+lAPJ4O+u6lQeUn2SV1VUHih29JBZ7CjAoX5Fm3h4FpbcSKcMWtKKWrllXT
	g8dCYr3aykcKOhVmooqWx4yTWvhINMkH0bFO5kEuA7mwZ1CGvX7CadDNfhmUwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779097848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WT4Vm66KOVZA0RJFOAYxcv97dwxUA3fg020L2O5ssYs=;
	b=8zp6C0gFfT2+D1S3juoWOO/FMEv0GYmtBjXb+ValBp4F1Qfj/xkTe2/+l/r2gAx3N2siK+
	UfTvlz9KUQSw/SBA==
Subject: [PATCH v3 0/6] vdso/datastore: Allow prefaulting by mlockall()
Date: Mon, 18 May 2026 11:49:38 +0200
Message-Id: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13OTQ7CIBCG4asY1mJgKP1x5T2MC2jBTqxgoJKap
 neX1oVJl++XzJOZSTQBTSTnw0yCSRjRuxzieCBtr9zdUOxyE2AgWQWcpi56+hx8+1DDQIuSay0
 EMKk5yTevYCxOm3e95e4xjj58Nj7xdf1JNYedlDhlFGzRaFW1tubNZUD3HoN3OJ06Q1YtwV9o2
 P6XBFkoaytVaZkQhdwLy7J8Aac0vl/wAAAA
X-Change-ID: 20250721-vdso-mlockall-461bb33205b1
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779097846; l=1806;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=0zXHqSeNUIBIVrYc7bD9J1+5HtgWSthRguzPQhf5gAQ=;
 b=l3Dr4NlNLgiqNc5YpVdG1q2JycHDC0fvdJHxa5UVnK2S7voNV37yAdTPOkPzgsMBJyWieL327
 D7CWUdPdl/lB2ROSIRf81cbcnxYpKT+i6hNSMeXy+UHruHEmESAuN4E
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33EA1100007
X-Stat-Signature: 784tq1fksnuyncjubsnfn3sy8auhk6u5
X-HE-Tag: 1779097849-220190
X-HE-Meta: U2FsdGVkX1+lDmIwyV3xKvyh9JgSKO5i2SDdvHCeMYYgrWW/IAKvhPLGj4s01nkmKs69NiFmBPFGo+tqflm17R0fOOYMga3u7gyH52Wu+73qr4GDVKySjs0pswje8d0tzCtPSB7eKDStqcxgw+9yWnGUKnrEY8VRjpkItV7NscQlyR1ZcjsEDQ7hLIYvHSSaEqAXTT0lNhjxvXb2zK3OMZfYDh8HQBV8hWa8NcZWxqfxrsVhpTiZ5tawHkgEb+HkhIP7Vqp2jAUVkj0YNi7k/bVKlsUr35bNs5v1xtD3gFUEJw8OvwOLdYLe6iu3Ea01wHgX8UEiBIvr1b/qyc4OpJ2vtWIk+6FBU+4j0uVqA8FoOUdlkzNDTpGUojiHO6gEAgBRaX50JfRguCCfXTFOfA2zHFPXwtKruV8TFRFUEpdy/+j2/gTF4PPFnw7ciXapZrlTvuM75ayZvMbhl9ZsOqE+jUbEcOAtTNaAyqqDheNn7lP19hkG+GM7mYMlBrPbExck60V9eFDy18CjHy3aj0V3Wg4pKksUn4OWkbLWXxJmo55EHAy6mV2d+ghuf0AsFK7XM2YC9SvD8q6Gvj0adDZbIOFbE78lj13rkoeQT9F7awEEND0ZIcIDXOi4WRaFhxXKrufKHingjyy1hccCU+VR43LbYAsladJdR0gUjRqPGhwCAf+3YZ4077GkeRHSpMSsWcBLnCe1ytz6mKXjC0rKtm5gZGj4YXcn3VA9nO45MP+/UfvYcgQ13FIsDZ3nNeHcVAlfhdOr2Xvk/JLdEquvnNvKVJS57lPTYpjT4n9xeFHXIuHyAxENVhFauMenvSTDhZnys9TtTKMmyye+Gv6k7rfXXGx77Q33OEjS4e+GEfz3gK2w0pupEOvtPSzHz3/Vm/yJDRdo/SlQbBfkXdQqP04adg5srR7aPdLUGkztRoX9M4+HqeHKs6SmLsVyExt5vbCIi8LBAWC/wez
 SxxgRv7r
 jUfnGKw0bmakSO+VDBcbiDrRa04Z25FEZCog0IVaurtxwYyAq1CLKb1VDj6y/t2P3IRvTz42GVfdQkYHzUTO6LMwYhNokBDl1/VQNkNfBnEY+5Ch4HcshWOxOfMMG84p2WEOAhyddAdg9gX3BjSxw0JZJydzAIoYpONtsL5jfmZPZCW3NH8MOcKsTdEF6BbkcVUEkCnS4s7ZzMaea4ddmG+oNSecJDq0sjD0TyoZM6Ns1jMzmvOjRg6h8N0xqP0EuAjPvhQsCVItQt5vYIt/MmKWu+mChomFfLPmWDyPheS51EerEpBaQTW+sQX00U52wOnZQC7LmfksHwSkjY1geIBnnP0KsZs9uzQD/rCvHdKTXFKBl7b+4CRat2YWUuc5sEPIi3jxRg8vTCNR3a5ANxoNvqYdKHhdyZR5NRP3XmcXZuC9oBnOW+8Ml7zPoeS1Sxwwyc5EArZUqZjq9NHjT0lO4sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While mlockall() is meant to lock page *memory*, effectively it will
also create and lock the corresponding page table entries.
Latency-sensitive applications expect not to experience any pagefaults
after calling mlockall(). However mlockall() ignores VM_IO mappings,
which is used by the generic vDSO datastore.
While the fault handler itself is very fast, going through the full
pagefault exception handling is much slower, on the order of 20us in a
test machine.

Since the memory behind the datastore mappings is always present and
accessible it is not necessary to use VM_IO for them.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Changes in v3:
- Rebase on v7.1-rc1
- Stop using zero page, which can not be mapped in this way
- Link to v2: https://lore.kernel.org/r/20250901-vdso-mlockall-v2-0-68f5a6f03345@linutronix.de

Changes in v2:
- Stop using nth_page() which is being removed
- Link to v1: https://lore.kernel.org/r/20250812-vdso-mlockall-v1-0-2f49ba7cf819@linutronix.de

---
Thomas Weißschuh (6):
      vdso/datastore: Rename data pages variable
      vdso/datastore: Map pages in terms of the faults pgoff
      vdso/datastore: Map zeroed pages for unavailable data
      vdso/datastore: Explicitly prevent remote access to timens vvar page
      vdso/datastore: Allow prefaulting by mlockall()
      vdso/datastore: Simplify the mapping logic for VDSO_TIME_PAGE_OFFSET

 kernel/time/namespace_vdso.c |  7 ++---
 lib/vdso/datastore.c         | 65 ++++++++++++++++++++------------------------
 2 files changed, 32 insertions(+), 40 deletions(-)
---
base-commit: b0f603a5e7c076c7e424b5a621022b3bec16225b
change-id: 20250721-vdso-mlockall-461bb33205b1

Best regards,
--  
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


