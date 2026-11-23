Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D762560A5BE6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=F6dpwv40
Received: by kanga.kvack.org (Postfix)
	id EC8866B05B2; Mon, 23 Nov 2026 03:07:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E529E6B05B3; Mon, 23 Nov 2026 03:07:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2A56B05B4; Mon, 23 Nov 2026 03:07:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A353C6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:07:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1144BC0832
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:07:01 +0000 (UTC)
X-FDA: 85465653042.09.A7A4930
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D00214000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:06:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=F6dpwv40;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795421219;
	b=3WkAzfKEMDQKZw+UHkXw3d1pbsZeUdNtru+SJoi9GO9XP6EVfwOllGUvJhLqLT3Mba23if
	330NHZDwt0y0g39klVgTDOgeu+XoOq6/McQUFycsOocKXuvH+2DeEVM8ar2vrnQAF7k0Dl
	Nb21Wm9Xag18ja5VxFKHkTtGX9XtKvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795421219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GdWbto/GYuZDXyTvm+7T3nEGrjgUlN0uIoNMYNUd3jo=;
	b=C1591kI6KQkqghzHt8/uHtms1C7DlDIBeKFZe6FNYrf0fRbZQGJ7CSt/p6nvnKzymrvo1y
	4L6RphS4/0n8CBGKQNxUlY+2r3xmlrOo24dyR+T3OOclZcW5yEjYfPuW/jWAnId3x6kv44
	GB4d6zI0U2m2s3cT4DkpFB7ef7dyQy0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=F6dpwv40;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9496577d4c4so367300785a.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795421218; x=1796026018; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GdWbto/GYuZDXyTvm+7T3nEGrjgUlN0uIoNMYNUd3jo=;
        b=F6dpwv40f3LrgmOykJknsjxl+XmMW+3fhtassYJ+lHLmL7lWvWnf4gsLDxYA1dmJVS
         Z0dJY2nyJH6T9r/72Adu4QxAYYYvmSLDiWiQMAw5DehxzuhZCWduETgFMbT8LzDtRBI5
         5oH9JfUFjXPxSkWrvg3udUUTuol2QIXx2ZMr5PzlcMkkUYAJboKGLHnFEYqfh8LJH7af
         n3M0ht3fHr0YzuAO9rJBIiXyYDEmh5YQv9LhEKUgUG+3To7D1oPsA8RKNbFDVA2STtcA
         BxGQDyp7RcnKgZsIC+3qR0jVpB6DyBqO8uu5bhld3mulPDPI62CHNFKNftG1ObnSh00A
         r/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795421218; x=1796026018;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GdWbto/GYuZDXyTvm+7T3nEGrjgUlN0uIoNMYNUd3jo=;
        b=CtjmQfhgrE1SVSTc2VbVWLhauDtZQracilkY29zxONgjF7BB/jrZyN8SbsdHVXN0JH
         f8txwSxMPOPQefd8fSJsZQQL1gqmGmTQpiY65dprGe8r+2mRn4mXO0RJ917z/zBu/QWf
         zQY5ptzDxtkcoUGt/Xk7Fo9D75/GBG4uibsBJCKzv/wp5FVVGEZ6R6rMvYwpA9/Snz6M
         hk8IDpuGZLIZxNFVp5yVyC1kmNUYE3GZrt7XQu+ye3fSMf9BUVn8ro5HQPjBIbjCV99L
         rfo27+qe2Lw/ytXWcy7PjLGbFUVvlgl8SukyPUSdI2vKFUj13PQ0SGlh0Qbw5naEBm3v
         6NKg==
X-Forwarded-Encrypted: i=1; AL+hErEDGuZF6v12NYNLUZDJCSWRk3ucRf9RXQi3I/xYfBtVxyHV/E2iyAtJk/ofSm7iymUxr/C+Zkg0sg==@kvack.org
X-Gm-Message-State: APuU4Z9dlMI7cAc/mCLtMT4jtQApj5lUnnpMsJpGdQz6flnEoZy/Wh+k
	RHEsiHBuiBEOiqnYnxj7wBD9VhlJ1sD8F1OF0kw4XuiQH/z8+tVx2yNOY/jor1JH27s=
X-Gm-Gg: AZFdTZexfbkj0qT1PN7V7usAVej3T0uWXDd4jF+kCBRIkZXNJagABlK3Qgcjz7Uvdl+
	QDdHRpYLkGKkHbsftYwT3T2PWn6CtohmMDex7Vfoi3m9KfiSkGDKdd8KYDIXU5kzhokDXAOqB3w
	UT4tHTKKIqK4EqYaDQFGtgmxXNI0W86LhOMYCWAAzsjw3Ve6zut13sxE6GaQaI4tRbBrPfec7J4
	oGHPjD1NcpIy1rhemA5jnBh71iVKUuM/NlTHutdwhSkbJxVl3DSugrMP0dw8ahD6fkxCx4wcWpj
	39T2IGJRV+MeTgGoDyGGMoeAJ4HvGLAZVt1RTIi+H7iQ1PGxWDIu+BLWYgvkB7KvhFqbMzrPOg9
	bw7fRg6iPHQzTyi+NEkYddNWDbkpcp0Mx1NANa4ME82gOAljXgkeCdc+4pUB3dMgGxykm4RV5tO
	zemWPknTkXZof40IcSwNj6GYcBnswwgGbXrNS0iUVDyL0dIpzn5IU1a+mPmqCITdKhJLom7j48y
	GIDm32FumjM/GH2E/RyCeru2cbiWoUq/gTa9BOMbRjlJHGxilA2BXk6atmru3lF8BptkGV+Jq26
	0a7HjLmsRkbu+UlGdooq/ZAO7NlCVbTGWLTCjncxYasYZVdoyPtkcp0OZGnorl+bUEUiEVV8XRX
	eYflMw+nTgeTxOhMzRk0Kn22bCHMt
X-Received: by 2002:a05:620a:4481:b0:93f:2571:bb6d with SMTP id af79cd13be357-949bab32ff9mr1727268685a.39.1795421218145;
        Mon, 23 Nov 2026 00:06:58 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb349db3sm745619285a.7.2026.11.23.00.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 00:06:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/60] Private NUMA nodes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <awNavE8dAGr-amfQ@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <awMdeK8O-5mffg2m@yury>
 <179537469194.412063.13456998694958645706.b4-reply@b4>
 <awNavE8dAGr-amfQ@yury>
Date: Mon, 23 Nov 2026 03:06:55 -0500
Message-Id: <179542121527.412063.3452837736734095837.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: m46fzz68eaxai4syeg9mnct6o43qsoxf
X-Rspam-User:
X-Rspamd-Queue-Id: 1D00214000B
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795421218-331410
X-HE-Meta: U2FsdGVkX19xI/qkr3pj9bMhGO/lqoqRVk5eePLmdFjlFETU/RbSStIy5NfiQZ80BL/2wrWmDy32lKsUDyYenAxLHpEYQ3EtGbof69PQU0tMoRT0vbAJ9uW/45ugUQ/9F5rHGWYX11zrKs3KbY/Kp/ZQd++8dP+yYVp+qne1+CY3lckQOcyjxL6zr5qSkBNwsp9SjvXYOVFmsJGm1aVRL6oE7kLY9KVjUFuflskDNvcHGU1tOKofZNzHKBQaBmtSvPXEBbdETrP/SvbxSepcwLsoe6DJqU00Pc+0yQ5UYqvHbUVMl75C2a9f3ca4u48fi1RLaiqt7ty901smGR62Z4bLOA7Gy5xWNiMH0Jrb8bvulod9tJkEZbvzxgKZ3rybrDnbCxohzHnj2w04LzNUyp5GToROsDXdQ4Xk9o9icu63iQn9rlU+Zi0AfLDfLqFkrM5KDhF8/ZO5U5n2ZeoUf+zr2LwHPi5Ql1atJe6/8Qgf6cMSrwBgOnSWOiuaFiXUQPjxdNk6qRQk28swPL7oTR5P+LHuI9Ccr0iBwGyaNYNBPQfIBHo0lVydN+lX5UaLL3+O/vrHGq+RIhUiraJOTGb07BPO4pHqOSK5BLPNcssIFQzwxB7lhMBKuxQFhl06zbZdZdyn6oQmP6agPr3UPzPSxQlqrHUM+zw0yzDsAVC4VdlkhTcYvKullaeL4qok9PVkyV7UTZfojMvPdSZLxF8wOIs61Tesmk4fAZ8lMIiT/dB/or8qwuKEHYAwuIc0GXHt7UpvcFl7eNCsYZO9N7ZUAwwvDbZaVV7up3B87CzBNZoOtiQPrNfgsHxb0z8TJhF0MtH5BH+T6R8hbysVnqk2ou2WeScb9N77fy4hGDOGFkGcuM6vWm8L/rEAyMg6tqwzBIjVest64gDFQC5SfUfxeHP8XKlEnrKPGbaO7eIhklYCK/65aC3Qhkl5aFzeKyjiYTwGZ1nKDmHSYqf
 gnGR1kaa
 UXBPey4di9IrE9cKnaDbSuyY5Cw8d9XmN7pPaalC4LfcTOaQIrgT6LiEAcG2S2WMG0D3KGoys4z6/ICgJqOViYb6PssENb7VbY408HQrE+HppzJ2ZQZmV8zL35J+7Ys8ox3Zoc3NqpQ/bjPsr340vxyrrx5HpUzYE7Lk7Wwv1H3mMCE6LCxjLMFcFJDh4O5Eslh0ITIZPVzf8KUAqn3W0X9tQqQhdgMs32OwKHFJV57/wiA7uPwnrY2PksniS/qU7ttjB/nIskNEy2n8RkUkCwOg70azNqiyt9yuEHXAqhXtdiY8XWtfaeSB0benHm+xgV274cqVzipJmla35CayCla8YvDTW7QBXxOV9yuB9Is7X2OtwEacZSEo5nuVZal80ldHx7KWhiQ3ZPobBVs7lr5qi3DbeYwa1Fw6gB69zkpmJeQTj073Hx/LHAo3uUiwpK1HNivKEjvLn6HqUVQC7ocQdTrpv52TCb8TT4MUBbTthl/FSh0H4Wz6a6AFPYxmhQt0CxhEzFQph8LCI39FhyCrN/hYU1ZY1+Z7C5SSPCvl6/KaKRgIntlE5MOLmlA77R9KAcsqinpan1WfoSfSOM1b3jMeOrARnVZMsQtTp8gfon9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-22 16:12 -0500, Yury Norov wrote:
> On Sun, Nov 22, 2026 at 02:11:31PM -0500, Gregory Price (Meta) wrote:
> > On 2026-11-22 11:51 -0500, Yury Norov wrote:
> > > On Fri, Nov 20, 2026 at 01:08:51PM -0500, Gregory Price via B4 Relay wrote:
> > > > This is v6 of the Private NUMA node series. The series falls into four
> > > > parts, each building on the one before:
> > > > 
> > > >    1-18  mm: introduce N_MEMORY_COMMON
> > > 
> > > I walked through this part, mostly. It looks like you can substantially
> > > decrease the patch count if you keep N_MEMORY meaning unchanged, and
> > > add another type, like N_MEMORY_NOALLOC.
> > > 
> > 
> > I don't see how this would reduce the patch count substatially, you
> > still need to convert existing N_MEMORY users and need to differentiate
> > between general purpose memory nodes and private memory nodes.
> 
> Please check this quick attempt with my codex. The patch count is reduced
> to 52:
> 
> https://github.com/norov/linux/tree/private-nodes-v6-n-memory-folded
> 
... snip ...

Patch count is not what we want to be optimizing for here.

Your branch carries the same code (+3 lines net actually).

The patch reduction comes from squashing the per-subsystem conversions
into one 16-file commit.

It also broke get_mempolicy(MPOL_F_MEMS_ALLOWED) - it now returns
memoryless nodes even if the system doesn't have a private node.

> The more important thing is that N_MEMORY and the proposed N_MEMORY_NOALLOC
> is a disjoint, contrary to N_MEMORY and N_MEMORY_COMMON.

The proposal here is not novel - version 5 was also disjoint:
https://lore.kernel.org/linux-mm/20260720193431.3841992-5-gourry@gourry.net/

   N_MEMORY and N_MEMORY_PRIVATE are mutually exclusive states.

I moved away from that because it changes the definition of N_MEMORY.

The subset model is easy to understand

N_MEMORY               - a node has memory
 -> N_HIGH_MEMORY      - subset of N_MEMORY
 -> N_NORMAL_MEMORY    - subset of N_MEMORY
 -> N_MEMORY_COMMON    - subset of N_MEMORY
 -> N_MEMORY_PRIVATE   - subset of N_MEMORY
                         (COMMON and PRIVATE partition N_MEMORY)
 -> N_MEMORY_<FEATURE> - subset of N_MEMORY
                         all N_MEMORY_COMMON
			 some N_MEMORY_PRIVATE

It's additive. Users pick the set of nodes they want for their purpose
and don't have to cobble sets together or remember special helpers.
Users don't even need to know about private nodes most of the time
(mempolicy being the one major exception here).

In the disjoint model, N_MEMORY no longer means "has memory". Recovering
that set requires new helpers, and the meaning changes silently for
every in-tree and out-of-tree user. Anything that wanted "has memory"
quietly misses private nodes.

Either way you have to audit each N_MEMORY reference and decide whether
it wants that state or a feature variant (N_MEMORY_RECLAIM, COMPACTION).

The difference is how a missed site fails. In the joint model the
zonelist and the common-memory folio checks backstop allocation and
access, so a missed placement site costs some additional work.

In the disjoint model a missed site silently drops a node from stats
and accounting - or worse fails to allocate per-node meta data.

So no, I do not think we should go back to the disjoint model.

> > And N_MEMORY_NOALLOC is not a good name.
> 
> Sure, I'm not attached to any particular name. Although,
> N_MEMORY_COMMON nothing better to me. It answers the question
> 'what for this thing' even worse.
> 

happy to wordsmith the names here.

N_MEMORY_GENERAL? _DEFAULT?  _COMMON felt intuitive but I am happy
to rename it whatever.

-- 
~Gregory


