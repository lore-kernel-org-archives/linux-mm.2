Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87549C5DF67
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 09:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB6C6B0668; Fri, 14 Aug 2026 05:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76ABA6B0669; Fri, 14 Aug 2026 05:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E2B6B066A; Fri, 14 Aug 2026 05:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 385366B0668
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:24:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A31B112019C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:24:07 +0000 (UTC)
X-FDA: 85099338534.08.4BF3D5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E16511C0005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:24:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2N409Mu;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786699446;
	b=aAmzvFW4qOfxBvY1s+3VmNyhsBdPVQkQt75iBT3CGKZYJA3lquvcoP+lDXPtPA++hXCgNw
	p7jfN91WsS3mSyBrn6FlnIvUwUVjUGWaH2+ip/EKmWCfrtfNuNsWkd+4yO0dIayZFBg8qb
	dp1enFJ4u/JSPJjKj/q7PWjqF4TYklw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2N409Mu;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786699446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BDNiSD/TGPAFah4GBukgWpyeTa1R6d2YpvQnMgrjbU=;
	b=55nnPLEL8OSbhDwZRE42JAXxJM+tKc5x0e8pp4lMEY34pqJIJgh1Ht5U8DTZ6c1qCyivhz
	4xjqQiFgeYAqVqnyAwbXc/mxuHKMBB9gRcrus/k4TLElhXdhd9tyAvxpY6nNmMb/O+p3Ze
	j37UYkEKOGnFUnHX+SfehNyrZS1gLu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C71D4411D7;
	Fri, 14 Aug 2026 09:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A751F000E9;
	Fri, 14 Aug 2026 09:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699444;
	bh=7BDNiSD/TGPAFah4GBukgWpyeTa1R6d2YpvQnMgrjbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d2N409MuBnGGenXQIVTUhLYQy/xgOMSTJOVXxi9ZVjJ93EqI18/99Ynmo8/ZKzoUK
	 hsU2f7sHDzJDqz23pQND4q5eUFP4xOc5wHLR4JtOjEMIjt7yU+L42ln5V22elUkK5h
	 NhMaVB0Q+VtlV/t0hp3aZDk/OVtUcaooh9kDUP6wNcplIzQggyjJNuJDOsp2wKG1Wg
	 q9CPiXCGqhAcX4caBqin5H8rmwYz1HQuJPTsdlnI0pt/t1BVNT6fQjv1VjY3LpdHe/
	 n3V7nv21MsfuDy6elMFCQ1ja2ia9nGW0FWUNrdyZt6Ru6BTTlWvi6H5bCfl/HKDmU9
	 cnWkXsSOPyDpA==
Date: Fri, 14 Aug 2026 10:23:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v5 00/16] mm/rmap: index MAP_PRIVATE file-backed folios
 by anonymous pgoff
Message-ID: <an7eSrKUHUqPpVGv@lucifer>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
 <20260813115346.2aaad419a351341a4f5f3ae0@linux-foundation.org>
 <an7SkamROquJ7If0@lucifer>
 <an7dekaY7IMMrzID@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an7dekaY7IMMrzID@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E16511C0005
X-Stat-Signature: assjr4k6bnouis1c1jdun4zy3kron9xz
X-HE-Tag: 1786699445-280984
X-HE-Meta: U2FsdGVkX193tEUQOhbs6VlTwaZ3PeYI3ZmRbPwg0FouQRWAFiM8Z73vleanGtb9a0O0NTwLfXBWQgsjzb85S4sNOrZU/rvY6fBuVplmWhNs6/5NDt+f5s5vm1T0DucwXPHbt7psnKJsHwrL/UyZ86352EYCgOlewHzktQbTkCv04zWDrRuYCCvAMOFgKUm/VJ8QkDTIKRT2Avyuhke6/4cQdGKkfWf4fzeob8YDkw+VM9RScNZkB98ZmRdGL+frn1uxmkV625rKnAKh1RdprlmjQ4o5vev1TvzRIv7ucMYADtxOR536lS+zM+8N1y2MySHCoW/ExzDo42/3gx7WUdgIJPD5fSsCEYW2iZ4C/ImjP+KFxwWC6FyGOefMyYeX9uokC0X9nQaJSLDbAt0MBpuiAVsZU6dmTlm4f4lJRMjUf0h6sswh1Bz2+xaYBZ1tQyK9pCdz4k68+c7vmyn1oIDb6ZWr9GYw13XiWN9w3UhtHfeuRiPrRdiuDDSVtz27jKsQY2kOLvz5G6qthbbGF1cZT/6krIRwSMRAxg5lDEPxRSVrvqpQLQqiOdHE44xeYKwHHUjfTue7L4QZz/OrzOtT1bZ2Fuzpe9Jf/H3TwhF15p5ySdZc2OFatkaSM9zNhDWy2EDjD3OxCN50EZuuzXNts4zXZL7z3CKEBdpNAUu1pR4JHbuT6C8kVsTOVhlR+cx9AEIsxJOySpaDntj6IwZWWTgOFQVGUFET5uWvc2mmQrwmSfkkZykm4we8NpepaIbUptag0vvmASzzqGIHgEgWXwTqHb9tQcMgBddBCdE/HMJgA6O/hns1jHRwIoLnc3p/IkpwYuBkmlScl7YFAzYqnelMYgn1PJWpMGNkXugXaqD2vr9mzUbWfhxcDFFf9X3Th37i91mTsWhE0uRJeLwxIq+sfn1dg75n0tM1cKkvhSmhN6VYIgm0fTLB/7eoLOKe0Rw+fMMG22pKvpc
 BB5H6f2D
 k+lLOnwCttpRQKR1Itn20AloLZHUTqzHNtyIyovAMX5HtM8wVryyEI9AgXNkfQbFPMoDx1QRzwO6iIgFr8+ltLbquueJExahleujoNT999bC4pBqV4kj+yiY7DVh47dbFoo9UNBtV+LJJ7KagkXXcIdFFi7u8kz+BK5eb1fkz9cVhaqk/kuW0wFuD0DP/DiqLFCSb77QvwdP9OIMJ5yZbpA/AmfaSPQ9P4kGh4Nkn0DYH6bpVOswWgin10RnqQ76XTxz8z21t1/i/L3BcuBmJ/b7Va5aMJHxkNmveLsbul96EyNE3F40eTzz8fbmQr9NfJb8lHAq5DVt6hfAEVV2MdAtZ4osgp43z0gsSOmgdaKkNpYVSBBueSyGCOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 12:18:50PM +0300, Mike Rapoport wrote:
> On Fri, Aug 14, 2026 at 10:01:19AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Aug 13, 2026 at 11:53:46AM -0700, Andrew Morton wrote:
> > > You'll be mortified to hear that Sashiko wasn't able to find anything
> > > to which to apply this.
> >
> > :))
> >
> > Well, when it's right it's useful, when it's wrong or suggesting unrelated
> > what-nots it's less useful :>)
> >
> > I do locally put things through claude + Chris Mason's prompts a lot, I
> > don't always invoke local sashiko as it's very slow and token-heavy or has
> > been so far, but am planning to do that more also in future.
> >
> > >
> > > Sashiko can be guided with a base-commit: tag but I'm not sure how to
> > > tell it what tree/branch to try, or even if that's necessary.  Perhaps
> > > someone can figure this out sometime.
> >
> > b4 gives a base commit, but I think because the trees are rebased it ends
> > up being the incorrect one.
>
> It's not only that the tree is rebased, but also that mm-unstable carries
> the previous version of the patches.

Yeah that's part of the issue, I can't rebase on mm-unstable as a result
obviously.

Is hard to know what is sensible to rebase on - if I rebase on base of my old
version of the series in mm-unstable that'll probably be a bogus commit at some
point due to other rebasing.

>
> > Not sure what the solution is!
> >
> > --
> > Cheers, Lorenzo
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

