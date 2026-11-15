Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E80B606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 12:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K/OCxnlp
Received: by kanga.kvack.org (Postfix)
	id 00BF66B00EF; Sun, 15 Nov 2026 07:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7F16B05B0; Sun, 15 Nov 2026 07:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78B46B05B1; Sun, 15 Nov 2026 07:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98ED26B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:41:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F002C1C40EE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:41:16 +0000 (UTC)
X-FDA: 85437313752.05.DB0510C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 556CA100006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:41:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K/OCxnlp";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794746475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXtroqdbZDSUMhOwEwsYTqFg91OmWZQCdis4JspG184=;
	b=wGW/viLPejsn22e+J9iMVmI24ioaVo09AI6YStizUmpnWRSGaotcChrlm8OGe9F3VMZyaV
	Qw1JDIqPpEN8Qfpzldgi00kjCOWMceAKm17GNIePIIL4PHCnWubnGfc7fEl/K2l5TDfaxf
	A9qec1ZWMIt6cxD3GufAWLnlR059TyI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794746475;
	b=32OiXkxpXY2mrm4qp4622TrVuBtrGSMvMBVgFqWZtH1YagKLmNgXdXFXI/ArwYQviYVf95
	kdFx6pHxMuYkbYzHsGHGfczR/vgFdLo5IEZNEhcdjWMiPHw3tDpZf3M/wL8WyYnumQHeTB
	GDVDCo9zWmspgG3Vr3Ln7NtX/tINlcY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K/OCxnlp";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA116618B1;
	Sun, 15 Nov 2026 12:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF911F000C4;
	Sun, 15 Nov 2026 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794746473;
	bh=NXtroqdbZDSUMhOwEwsYTqFg91OmWZQCdis4JspG184=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K/OCxnlpA7BjbTwl4rQMyhh/7Mi5ySWd2222bSJjRsGsi0Cy69Rf/KEYVHtPWDkJI
	 Pj2ZKHe3mbI8oauzlpf7zu+TwoC5I3XGaeE8JymmiRptIwSwJTpI+SdX/qR9wmHokE
	 tHxKiqIh1LSylq+IGXKkUSjmnZARLD1t/LpSjuANsVsdq2I7m/phddbYvH5lYzpdtQ
	 YDMxXusO7zfwtVGJMHEwpeY5xQWDVlxcefsZ8XthbdmH8x1Tp4btA4IleG8dhTjyto
	 BNhHHjmmoBdYbuFGy6jd4t+rWekKnCOGKVQfVlU2RNo3VJI6pmZ3jHPVVdKIauW6XU
	 8t9MbfxS74Img==
Date: Sun, 15 Nov 2026 12:41:02 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 13/13] percpu: queue the balance work on an unbound
 workqueue
Message-ID: <avmn3pzKWeKXCCZ7@gremlin>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org>
 <avjn4xuxUmtTfMWu@parvat>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avjn4xuxUmtTfMWu@parvat>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9e7mu8bxp9m7r6eoqa87qckyp4m1pg4o
X-Rspamd-Queue-Id: 556CA100006
X-Rspam-User: 
X-HE-Tag: 1794746475-887519
X-HE-Meta: U2FsdGVkX18D5ES/71A/PiGCQrRufOw7fgGHJ3M7WHh8uu4IFyOUMvEcv1Ge4pPGMV9tYRHQ1CKOTiV1AgdCIZ38dXfvJztYySEfyb8aB4KKQawy1qrEUQhUNAMgmFlJ8zyhsrdnGUh9yIHhzaaSE+jABFz4seKiMJLz006ak5/10Dys5XJ4isgSZsotX+YlIK6cfwdfep/U3B2pMFyd2TBF8DoX3xGWj8/Bk/x6xqEqEIubzRE/7MUqjgax+3Z/FvHPZntq9upFUFk696cZ3tU1eHrFlBKSrVvdIFSr3e5t5Kgh5Tz/1ybgpJsgyMU96pIIw3tUFUnL1PIAmC0d4Q5FLFexzr3AfFEbPK7epbBdA1Ggrcmn0in8NksFBEdkX3dgx+As7qC5IDVyBupOYCoDjI5nzieY6Xbpkq/XnrIdgIMjHcYKSKQepu0OBWxvURrsMX0LZ0g3W+RC7U5yFkgEVH/ikg001Sh0hoWECEoH/8BcJktt7XhOuX7IJf/CIBGyyUQUxnAjX9TYzU0PLkuz1mbDQOdSzhsBhjBGLornuzCUY/LUV8Txb7bWBS5Pfg19GPbhAG7l7vb2WILukuhl2jtivRRq1+ynYbj+B1viqxM+qpX541qf8JTVCUwR2d9mXacXFSuma4HGNUnT4ZL5rduKPXeH+nj4r9hJ7/oqLPUBnq29CRcACsUWJXTt8yEY3ixjaegi5ny+K5git120FopmbYw1N49GFxX+zmnn3WrnJLOHGBZ5qRKuUlSCSIOwHFUytaKouAZceoN+tUl4R/NceXOzQuIVpmzkcc/PK3XaMXsSpkIQN/k9UGU5Q3i+CUrhCcOi9sMEO315cWd1KhyIxZZz6YhaoDUGZNTSzcyn8L5PAnAX6gSJHzph8bcYEWM+bb41A8MKp/zjqK02VHZfuZ2rF6jsBw85UxRLIp20lZnffm45ibClvZW2M0fH7RKUGL82BjogUD3
 3uBzAC7r
 xBmCY27azBepQekw+hPE3v2bf182bKxSNxKH97AkMU+KiiHbomAAjJMWbik+KvaiLowzOzT7XJE++X3JqbZRmIQQwsJwwkCAFwV+tCPtg6QbfOEnudZqZT/v+7/cyt2zgB+T/wDwwKbBjCxqvjvB8qj5t7SghI3l8VZJG3sormnJ00khXbgeHUvlWcWhVa8rp2Tw7earJRi4EMMa8Gce1D6sxDRzy96rTeHfXVtDCNBm4Yn1C3pcdAeHFDJX+QqCBPVgVdd0vvtKjWC8vn0yH5LbXfOCO2YvK7Ak+ceEHvI4cN06hrzcFPoTpkG2wDvX793d3Gx9OBgvYqbrmVNyHhC2u439B8tHkQsAPhSYrLuTuoZgmjEp0sWBO5nM8BekJor4MDV+7WwX0g9S4gUokNi4I1FK0x8GeNpS3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 10:07:15AM +1100, Balbir Singh wrote:
> On Fri, Nov 13, 2026 at 09:45:31PM +0000, Lorenzo Stoakes (ARM) wrote:
> > From: Chris Mason <mason@kernel.org>
> >
> > A burst of small atomic per-CPU allocations can fail with -ENOMEM while the
> > machine has free memory and idle CPUs, as atomic per-CPU allocations are
> > only served from pages that are already populated, and those can be used up
> > before a worker gets to populate more.
> >
> > Consider:
> >
> >     caller on CPU 1                     kworker bound to CPU 1
> >     ===============                     ======================
> >     allocates 8 bytes, which leaves
> >     one empty page and 4088 bytes
> >       schedule_work()                   woken, waits for CPU 1
> >     allocates 8 bytes, 1023 times
> >     next allocation: "no space left"
> >     gives up CPU 1                      populates pages
> >
> > The allocator keeps a few empty populated pages in reserve, and the work
> > item pcpu_balance_work refills them.
> >
> > pcpu_alloc_noprof() queues the work item using schedule_work(), so only a
> > worker bound to the CPU of the caller can run the work item.
> >
> > The issue is that the caller keeps that CPU - a task keeps it for the rest
> > of its time slice, and a softirq keeps it until the softirq ends.
> >
> > In that time the caller can use up the reserve, resulting in an atomic
> > per-CPU allocation failing.
> >
> > Fix the issue by queueing the work item on an unbound workqueue so that
> > another CPU can populate pages while the caller keeps allocating.
> >
> > Gregory Price hammered atomic per-CPU allocations from one CPU with
> > preemption disabled for about a second, with and without this series:
> >
> >                            Before     After
> >     Successful allocs       1,188   131,072
> >     Failed allocs           4,097         0
> >     Balance worker runs         0       169
> >     Successful retries          0     4,096
> >
> > Fixes: 1a4d76076cda ("percpu: implement asynchronous chunk population")
> > Signed-off-by: Chris Mason <mason@kernel.org>
> > [ ljs: tweaked commit message, comment ]
> > Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> > Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/percpu.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index f87813e6ad73..39cba1710383 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -200,8 +200,9 @@ static bool pcpu_atomic_alloc_failed;
> >
> >  static void pcpu_schedule_balance_work(void)
> >  {
> > +	/* Unbound, so another CPU can populate pgs if caller keeps this one. */
> >  	if (pcpu_async_enabled)
> > -		schedule_work(&pcpu_balance_work);
> > +		queue_work(system_dfl_wq, &pcpu_balance_work);
> >  }
> >
>
> Can this run havoc on otherwise idle systems? Why not choose a workqueue

I don't think so - this doesn't change when or how often the work is
queued, just _where_ it can run and it only happens when the allocator dips
below the empty page low watermark, an atomic alloc fails or there's
something to reclaim.

Also unbound workqueues default to cache-local affinity, and obey the
unbound cpumask so stays off isolated cores. So that's actually rather an
improvement on happening to run on whichever core allocated :)


> with WQ_POWER_EFFICIENT, which becomes unbound when nohz_full is
> enabled? I guess it still leaves open the case when nohz_full is not
> enabled and we get a burst of atomic allocations?

Yeah exactly. We'd just end up not fixing the bug otherwise.

--
Cheers, Lorenzo

