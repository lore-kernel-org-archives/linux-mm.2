Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1EDCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 16:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BCCB9000AD; Wed, 13 Aug 2025 12:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D78900088; Wed, 13 Aug 2025 12:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30EFA9000AD; Wed, 13 Aug 2025 12:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18942900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:24:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90ACE58DB3
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:24:50 +0000 (UTC)
X-FDA: 83772257940.10.571DB3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE9AF40006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:24:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NowuzJLv;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755102289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ntpsda4EGycyiP3WgWJ5U2Zn4afzuVItLgDlY0baPT4=;
	b=FxX7qTYht2d5+h8kG0wn+PfVZ9B7qwuW6VdYsWJ/FEt4aLgcm2+Xl+ePPenQc+NN/8abk7
	fNiwMqQHOxSKbzyQPTRd7wEWUn2ic5QiWSZMF8nE5NujAVCsYfEitUHKRKdr3Di8YoHn9Z
	b/LbKjp1AEnF6EsMKh72Pzbv26yLQrw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NowuzJLv;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755102289; a=rsa-sha256;
	cv=none;
	b=XkSe6phxS4Enu7dtsprEaePA/sCe8n/ATvBOCzHqiHa7Xd/DFM0CWcJehXjobTIVJopmTB
	PWWkO32dwlQCO4GrxBz2Q6xxwpN4+Tg4vVdfTIxwBZIpj8AhntvkPIe/i9mXElvLlze6iQ
	EXKk775G5Og5+ylNFlUqKufE3aXlclg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56FAA41A7E;
	Wed, 13 Aug 2025 16:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AF3C4CEEB;
	Wed, 13 Aug 2025 16:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755102287;
	bh=K1Qnz6FeiAMe891bHx38SnseQkGtn7jJpOFA1e7ci+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NowuzJLvoDcytU2mnlkUjH9a3VkVMtm7ue/1JeEievbLShowGrZYKS4ljQgIc4Tvt
	 3+vYZnNOWzD9UQ8pSH9fEmYwxPiiGspKJ3H0P32SvVzl8AqitUBhqFYwGCZ45kSKAJ
	 87/gu7vuZjna5FtZYWWUpp9S1G/8o7Ty64t0lObmjPlPr2MXYLPDtH4Sc4eAU6xND8
	 ThhzDQ4hSAh1VB48U+GqBbKfJNoQAGi7b1yhwF4mFVAalvl713Ll6uzzSrl8gdzvsB
	 qxd/OanAUdPmrliRUlwzqp8QiFiC+SAvfzE7ZdQVKX6a28IsBlnq34Yk6UcqsLFVxB
	 8m4KWJEM4NWXw==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 00/10] mm: make mm->flags a bitmap and 64-bit on all arches
Date: Wed, 13 Aug 2025 09:24:45 -0700
Message-Id: <20250813162445.5456-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <af5492d4-f8dc-4270-a4c6-73d76f098942@lucifer.local>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE9AF40006
X-Stat-Signature: hm63e57oe4yyoudynmzu4zdpho89ortx
X-Rspam-User: 
X-HE-Tag: 1755102288-289612
X-HE-Meta: U2FsdGVkX18N9PkRjU6ovaKkdaKhx1MHaf4iSgFD+H8T/2HZ476AMOE8oKtGba9dRKo2lRAk5+/i/go4t7V6k+hNOVXkvJW2AysoCPaZONKc9Ioi6VyqShwk2BMWorBlhsoBczowK8uxkkFjaItLq7Q30BXjkeEaocbZr7cN6m0I0awpkEFsiSCY+pQ96woNXmiExDexIKdHewgN50+x/31jgiVv/Nd+7qUZvyeNgC3R2aZ1q0kOUDL/feSK9gm9z4XxVzI0plIZMefP+4APsMebRUo4eKj95jaUXYs1BAKrsxlwoGd1IReE+Hpsy46wOoLyYNjdJkRhUjr2ilZ5GeT0YcfCjUis5SimypxdwQQ9Y0EeXe1hY9X3Q/amz2jb5DDLoUBdRbgrxr3KB1036sAem+wP0xY40ufReheVvX3OnjPpBdVnparJ/2x3PfBUu6CjZfgmSxHIBa0TNO0/l017/QPdx5y5ZEoMvpLNb5ZpgQEIshBvuH3G2pXPbHD+cVjzIEXul44aiBaXfTptflTso2fWGgU2slF1yFCnBVZlqf/8mFV6DJI5pklMcpbEhBrE9TC3OSXsaEXxmJbV0ITocQLItyVJQe0J25hGmOjcVnVo85Cwm5aRs2qzYZ+AGEPFvvXniMZhtovOvEV+neY+ZNHBDGhv6qG6U33IThgBheNZb9mQgo3i5E0tZBPH8idfUC1jt50f31/SKK/zeuYF1P+ImAmk9P/IRBDe+AbL+TBD3230OuRM0TG0cMrrsVwsAt5cVYAyIi7PxWMMaEwR6aPXpj1r/WrcKMkXBYmPtNwiRWhWjMzPU1y+n7Smg4fYg3AtIRKj3//eeW2t2C6pjFgmO+gU/cVlh2NNDV/srC2e4H46TI+d+C7Sq+U5qJd+i7dhfFsx3CnIFyaQwJgBHpyqwJExnoDKkUjEhQTssSUbkApZXYGPF6QrhFCOyz2jD3t+F/6OqzepRE2
 fXpZdqeY
 VoGxrlE9UkIux/nkZnNkM8506OD6fa5a0nArR0F9Xc6gFciPWzTyDbT5eLSgElsqgpA6Y541SnJYY2lHoNtDsvkRZtc2JlyTlYtrzzKFTdTI4Us8ZLHywRNiMa3e7qkF0H4ErFRmnrV5qcy57J/YAhtKBp8wkBjS2OABTlnDE3Hx56M+sHL1Ohmpxr2K1P9RggOIuuBuXAmOJFZ96AxoYFTWds/D0bVH4d3WiUajRzxKDtPQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 05:18:31 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Tue, Aug 12, 2025 at 01:13:26PM -0700, SeongJae Park wrote:
> > On Tue, 12 Aug 2025 16:44:09 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
[...]
> > > In order to execute this change, we introduce a new opaque type -
> > > mm_flags_t - which wraps a bitmap.
> >
> > I have no strong opinion here, but I think coding-style.rst[1] has one?  To
> > quote,
> >
> >     Please don't use things like ``vps_t``.
> >     It's a **mistake** to use typedef for structures and pointers.
> 
> You stopped reading the relevant section in [1] :) Keep going and you see:
> 
> 	Lots of people think that typedefs help readability. Not so. They
> 	are useful only for: totally opaque objects (where the typedef is
> 	actively used to hide what the object is).  Example: pte_t
> 	etc. opaque objects that you can only access using the proper
> 	accessor functions.
> 
> So this is what this is.
> 
> The point is that it's opaque, that is you aren't supposed to know about or
> care about what's inside, you use the accessors.
> 
> This means we can extend the size of this thing as we like, and can enforce
> atomicity through the accessors.
> 
> We further highlight the opaqueness through the use of the __private.
> 
> >
> > checkpatch.pl also complains similarly.
> >
> > Again, I have no strong opinion, but I think adding a clarification about why
> > we use typedef despite of the documented recommendation here might be nice?
> 
> I already gave one, I clearly indicate it's opaque.

You're completely right and I agree all the points.  Thank you for kindly
enlightening me :)


Thanks,
SJ

[...]

