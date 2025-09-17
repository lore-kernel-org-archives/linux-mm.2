Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E6ACAC59F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9158E008F; Wed, 17 Sep 2025 19:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779048E006B; Wed, 17 Sep 2025 19:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61AA78E008F; Wed, 17 Sep 2025 19:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF4E8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:40:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1462E16011E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:40:44 +0000 (UTC)
X-FDA: 83900364408.28.D5FEA61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4736740008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:40:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oT0iDBy6;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758152442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7w63V+BQXdGEu4rxaSSpml3UPhp5JwwPtwi6aurZIc=;
	b=S5GKqWyvlGpt7DC5NVJm3RAKTnvpiEK53gltEf2eoh1++gz4YiGzxukHluG3l3PXwFlNg7
	DQWxPAo+V2Nf/jkI1Z80x8Eb3St3nf7II51HxInus3VeDIxFGK9+6+dvAf6DnOvJFGWlw1
	O161RwmVz0lbd4GxU6eIPFa+3S+OM4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758152442; a=rsa-sha256;
	cv=none;
	b=3kuJ9cdlbBFJVCMGD8DTSH3sl0d7yusUTfFEyj0GJO37jXk0Yv82cLv4hBydeCliEDXJkX
	rT4gcS97mGSWLBcV5DPJwQ3yQ6ADYPoFcGL6wcgRAz75TQHLJWJL4jXmzIQrhmqkbFNTN0
	DE2PsuwKNXLqt2MPt2MdHrbmdrb5Yt8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oT0iDBy6;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1D6D40ABA;
	Wed, 17 Sep 2025 23:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10344C4CEE7;
	Wed, 17 Sep 2025 23:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758152440;
	bh=Qc2UYbWx7EeejKtW1EO2f6MFaxFiWH2vxkYJ9Q39XB0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oT0iDBy6r5P/R1iNfHqc4gbQ24AicRfxW687can2dx00oXBYiW32GIfMyrCUjS4sY
	 AhPIs0yj8xztgdayC01mhko3n5q1C/gqdo+1hq2uWauxo0aMOYkPi/725vvn3Y7koE
	 ZjPTSlKSinGcrnTHT9eQkwDMaaHzzw66RsnTWviw=
Date: Wed, 17 Sep 2025 16:40:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 "David S . Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Dave Hansen <dave.hansen@linux.intel.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Kees Cook <kees@kernel.org>, David Hildenbrand
 <david@redhat.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
 <chengming.zhou@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, David Rientjes <rientjes@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, Masami
 Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel
 Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, Mateusz Guzik
 <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 02/10] mm: convert core mm to mm_flags_*() accessors
Message-Id: <20250917164037.21c669dfcbd7b0b49067a49a@linux-foundation.org>
In-Reply-To: <3b7f0faf-4dbc-4d67-8a71-752fbcdf0906@lucifer.local>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
	<1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
	<3b7f0faf-4dbc-4d67-8a71-752fbcdf0906@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4736740008
X-Stat-Signature: 6y78tn4wzmra6ze7s4zwpj4y9wnc57qi
X-Rspam-User: 
X-HE-Tag: 1758152442-25715
X-HE-Meta: U2FsdGVkX1+tVDzO+LI5y2aSUJYn6RQfDMy5BLzc6JJohw8clrmscFcmmFvwOIHepI+XRgs0SJtdzhxYeyE5mlfICM37M83mCRWdY7cF5uX4oG38DH2tAQCNdy/B05BDAbZ/Gyz8OUO9C8RnEx7fgCuScr1t0tbQIrDIhEhvmonvMtOs0/GRXBVDeQbzmQeayoIDwnBGVD2fhU758GCbcKig8dHA0tuesS3Z1Vw8lVcC1NFA8ZnNjoJ6UsaVCXKytJDmKwAO0zyRkNXguJ35nkxDfN8c9igzPCZ91AHDQ1J/5K2EXZTXyFzpx7tS07ic45f2GIz71OyYSB/DJKGtUTWRtmiMJrFiA1K6uv8RNIP5MnhCVMAM5rwjCQ3D2NHXTgF2H0bnSk9X5/OnJ8myAsi1gCBhljtBwxz9uIcWNU7MxQJWDFYvHIfpDXbg+siaWf4I2G/btEDrFk/Y2JOfz5myUz+QpkbXKuVjXoEBqYyhPPe9tHF+obifz0FwtTwe2utKPWNQnbQE9ulx6zroc/gGAYBfTXCCRHkUoUITzmsoe4RfLIEBNi9ykxG/bNP06G2gCghue0a6n7ytIEl66iRPgItFhBnaDNAocZnXB+cotQKJaLSWPVDlze/oJGiAHC2FP0o4+/8Ii+jZRuH3XDMcbOFQpG3Mx17zQeTObgcfbxB2VWnnSGVaw30FLrM6dPA6aXEBtlbrmVLyCORPVkodCeSxWVowpJXrNeXG0TkMmMo0usbWAX/cQEgzD72mY1IFKxmwwKR6UbWhmPzD2EYrHbryzcI0Kj+ZEI445P54h9xzWB6PU+/zTka3jPwptCMf114vn3Fw+nE2jU+8vNnjkjZ/qneW4AYN5Qlx4YU2gaoEahou4g2qRDSB0MwceGmc89CCKtIVSEmyFIbE9P89N9g3Fy6oU+yoHPyOj1vKFHOgwyS1kQD7ZpxU1XRcJ+JwtTZxXf93KGdTVC0
 Patx7h9h
 6RUFUzyPFG66/ct/BTNqTUhAqx3Y5FNbhk0olsoTizjedFaRDAHzYuSYXI24tBmfxHSDVtqyq2VXWlqxIdSOhcTyyFJ82mh5C+o7N3X+l98n1MdsuzbbZhITTWvK6Wnc1v+MKvRwr2Bm98jaROw7x2m9VFYaO4zLiO/N2xmCxhaS4yVXFGFS8JXbvguAINtf3Om9p3PoQ89OdMiHelTEyQjDHvPz58pHdzCH+Gve0BQMQgWVmsRwwWdn/TaDCXFK2lpgx41Lox9oa1n77sqFd3rVuYhS48VhwMrTxpJGSxcR4Jp5ZjFyxeQylKrVV8E55404oCdZp7Y8xSxVilxCpziVZUbK8bJ2aZxM0AUdN7UOwkq4vffqPMTBzNk1ImVv3mU9sj6iE8rMK03t6BBuJGIQ3xYJQE1qKA//eNXflDpG6bDJJm6Ad+XSOHxT2oJbLT2q+DK8rJltisPU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 06:16:37 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Hi Andrew,
> 
> Please apply the below fixpatch to account for an accidentally inverted check.
> 
> Thanks, Lorenzo

The fixee is now in mm-stable so I turned this into a standalone thing.

(hate having to do it this way!  A place where git requirements simply
don't match the workflow)


From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/oom_kill.c: fix inverted check
Date: Wed, 17 Sep 2025 06:16:37 +0100

Fix an incorrect logic conversion in process_mrelease().

Link: https://lkml.kernel.org/r/3b7f0faf-4dbc-4d67-8a71-752fbcdf0906@lucifer.local
Fixes: 12e423ba4eae ("mm: convert core mm to mm_flags_*() accessors")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Chris Mason <clm@meta.com>
  Closes: https://lkml.kernel.org/r/c2e28e27-d84b-4671-8784-de5fe0d14f41@lucifer.local
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom_killc-fix-inverted-check
+++ a/mm/oom_kill.c
@@ -1257,7 +1257,7 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	 * Check MMF_OOM_SKIP again under mmap_read_lock protection to ensure
 	 * possible change in exit_mmap is seen
 	 */
-	if (mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
+	if (!mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
 		ret = -EAGAIN;
 	mmap_read_unlock(mm);
 
_



