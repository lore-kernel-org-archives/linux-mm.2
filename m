Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987BACD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FCB96B0088; Mon, 22 Jun 2026 09:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ADC16B008C; Mon, 22 Jun 2026 09:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3786B0092; Mon, 22 Jun 2026 09:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF9826B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:05:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E8931C0C54
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:05:29 +0000 (UTC)
X-FDA: 84907569978.30.DA74BB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A711740014
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:05:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cMY1FrLz;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782133527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1873G05ErtieljTAjknolTYLp1nP5on/cJgnqOtADc=;
	b=7w5zCvujQ7Fm4QQzvdBPasnlkqPp4kpCpWf1m5yAXNdXhOZgoZeVLgAyUgjszpJWjZUlua
	phq8F3avgYkTZmyCdGCGvcQN8dHZi4nE2k6rnKKUou+Jreu3nEfyPuBS2hLx6o73+CX5sy
	BQaVK0WdXf23T7G13PR4us1mSzxM8KU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782133527;
	b=eiYWrrmSvT2J7z0mt3s6Hv3+jo5b3WgHI15AGIC8xteJVCw9MfMSzTB6Ri9XDRiYxyffPv
	FCiSB6cACXhDYx3ReUfXNoE4asJshcfRejlMYD7Zmngn9gwGjyAFYSzj9ZtBvYoyEcP4NR
	LFtn6RShRMVMwblqdaVEOjItQcgLC6s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cMY1FrLz;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9586444404;
	Mon, 22 Jun 2026 13:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5324E1F00A3A;
	Mon, 22 Jun 2026 13:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782133526;
	bh=v1873G05ErtieljTAjknolTYLp1nP5on/cJgnqOtADc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cMY1FrLzFrM7ZR5e8zF2y0QbnlGoXq/XvqyrtrzKgrV7t6W7TVqu+tCkJ5xl4olXQ
	 IMsQaRk87J2tt64F8GIAUZT5yDz6mchMXPgJgTpkNHjiVSEk1Yl5wy7AzodOuR2u5Q
	 nXqykqd8DjXbnbFQN4ez4Cy/GZEE8Zp7JXFY7jwy9TycipjIIbKaymtCVpQpK48dth
	 shy0oW0PiEeuU3ISBnap/fU4lySKQncLTjKyVhZiW+4faB4s4bmbJmGGNmLDIwSWGc
	 y/DYJXwSttcRJa7sejEEOcyqtuuiovHK+7VxN8OWHZd5nZR1HZ9KBzsMOaavYjyi4E
	 jQ+Lurdxq92ZA==
Date: Mon, 22 Jun 2026 14:05:15 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 12/13] mm: Move __alloc_pages() to mm/internal.h
Message-ID: <ajky-U6rWpzY_Hsw@lucifer>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-12-31f31367d420@google.com>
 <41e92bab-6882-401a-8de9-154adbdcfb36@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41e92bab-6882-401a-8de9-154adbdcfb36@kernel.org>
X-Stat-Signature: eoyryzowawa5f1mgpwuxdm1x5apo4gj7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A711740014
X-HE-Tag: 1782133527-397575
X-HE-Meta: U2FsdGVkX18P3JaULVRtxC5BaJ9ntU7dbednwHpBW7Ed0M3GRJjMqSO59SCuTYb82Fer5jRV+NDN1Q+doYx7fGWV8pi0y9GII3v5V7cA/c7Ccad89sajGO7/n0X1XHg4BDjnxgDRgs/A/YnC4P0TkIHAPXcpNIhys6/UJ2JHp453v1RGllE+XP4b9mkz3vZG0X5E0BrpzUiDpehQMwekwGLLfX9GPGgtWDlOjKQ4GzgqSVKumtB1kVoj4Vw141dOfMSLRH9NmDNISyf5HaKVUaQpCwPmFqJaTwDhXHd+R2mhFAjj9RGcQowIW/n3JSginLcTpk1Miv6kkrynTG2UKxloUdbG0HDFmNGiipjUgPZSowJqpMMPbaV+gEFvOayiBeiLlFii22QZMVDL4Qf9QzMU9XK13VvCT/M8eQrJCieZqC0EHnF7JTVbrvecJTWkve0QWDPBH5A7DG8+3EHkvgKani6y5dvEiriT9Nqex1fiFMp00ZWFL0Q9eN6SqBosw9QxfYt6SLpEqg3CD5YTT3ZaDsI2j0YH2Y4NrvS1vI1c1SEYHe8g04zahPyXQTlWuzdX3rdlPOc11ShFxApM8xxT42EFb1ZysOp/1R04Vq2el0Mh+CLEwmtbkfN37xvUk/8HL//oa9ZUGy9XvtSTYjYzUg/D6ElsfOmS3vKgjdBqeETzGNWZTZdXQSXlkyCT+vl5p6raIcqadKjFZ5ADyInynqEdjy7JA8HDkSD/BdVrQ1Mhx/MeADoWkmM2mKBJvrJrpQZmgIqpUA4Sxir85WcFywAGbNZvu7DP5kqJ+fG+TaAAvse+hi8/QTgXdCUhHfOhC163av2zHi6P/U0MxbVqIcA1V6/zJvkrSi24Zve5TMSz3fQN2LqMTdBkIYWPaeH7n4Tg3RWKGagzn9cIVz3IkL4Bz6iTBuFXHs8DgJEkaMJCWeBwymxbAe8BSb3ixP+ArDeyOcMHCoZHISj
 N+AWmGEp
 dMOcgK4XxPc4fD5kCVyQlYF86XjUj1srjSOJIpks8rhHjadd2m1SiIZnimplJ4u4f97ejc9dlij7RMVSF9VYfU9gSb4IDDUfOF9OBafbCdB3984z9tbPdcXyKtAKVw27tcxphVStKB6nNDalBfRC75OhKrDiGrhSybbCqiQnSq0/uB+7dsdTOr08iCniwJFHRv7/8lipE6t35yYI5UBfnMUrgKBKNZOnQRWyg4jdh2wLAz8Xh9NY1tWTJqV6kqBb5Y891lUWbtWYhoqieNIIBnNF/kTKgqzjqjG52uGHUP+XhrmNgSaOv/YyZDb7F6o9loQT63TB5tsfGc0sG0DBPrQvyP2aOINUUt7ouiU72LIqejFoz73yy1eU/qxeZ4+OkzMMj+sEygLAjaMgBrRIdU3JE7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 02:24:36PM +0200, David Hildenbrand (Arm) wrote:
> On 6/22/26 12:01, Brendan Jackman wrote:
> > It's no longer used outside of mm/.
> >
> > Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
> > this also means moving the definition of alloc_pages_node_noprof into
> > the .c file.
> >
> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
> > ---
> >  Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
> >  Documentation/admin-guide/mm/transhuge.rst      |  2 +-
> >  include/linux/gfp.h                             | 16 +---------------
> >  mm/internal.h                                   |  4 ++++
> >  mm/page_alloc.c                                 | 11 +++++++++++
> >  5 files changed, 18 insertions(+), 17 deletions(-)
>
> Do we want some mm/page_alloc.h , to start splitting up mm/internal.h

Yes please!

>
> --
> Cheers,
>
> David

