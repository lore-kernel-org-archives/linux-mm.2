Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA8ACA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 20:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7418E0192; Tue, 12 Aug 2025 16:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190E58E0151; Tue, 12 Aug 2025 16:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4FA8E0192; Tue, 12 Aug 2025 16:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EACB68E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:13:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F3731A01AF
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:13:32 +0000 (UTC)
X-FDA: 83769205464.12.A87F450
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id BE4AF20003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:13:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZk5s4qd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755029610; a=rsa-sha256;
	cv=none;
	b=UbU1KPdeBl72Cfi9vLQ6iKzPOZO7qG5flZFB938GfvOOw7mU+acjwGuxqASq7mmOKFHPtL
	Rg+TrOJ3JnQtnKfJ6oVMugW4RzCesoG3VKZzVr4DRyRFbw9bAf3vz+bQ/nvgUJWp6sKifG
	DcRETkhvISC3ZCe/7/9UoyQq55knsuY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZk5s4qd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755029610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yp7X0r++DmuQ8lJAATuCSuGbLBdI9PUcD+fxof48LXQ=;
	b=YMlwDyxdt1Hw9oK+fJbnZ5cHRZLnSGejV0HAxH0YMehb451D2mlju3XwodyFtNXijMXgpI
	JzSqC5gj7Z7R/eGYhYLkRXW683UUKYz1bIqVdnFvugUDk4+QVWMpjtI0fomyYfSsa5kARd
	khs7A+kVJMvCUp4whfMGy70p5w1YUpY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 9B7515C5B72;
	Tue, 12 Aug 2025 20:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD26C4CEF0;
	Tue, 12 Aug 2025 20:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755029609;
	bh=67thnts7t0DLgkZq/Ii6wBw0jrSFJtM5mUMWCYrbVS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZk5s4qdbM6pcT8YroWmQOKRLwIIFGieYYi0v9aoNi2ICJDuc3wg8bhKf+s6pvQNd
	 c+i3MR/y/FAagcjMfROfPVLTOsoG3YlP79F/PpCEZGyFDsyuBtQtypuh96jit6toX0
	 v+aQUOZ71f1sVS4LLJKLKq+8hdeGPjE2mpVgs/FuY2KZSzhX/6T7dzeh6CvpLmMDoF
	 weuTiAVwv1mVOxNZA1KKoDpEA1hk0wwazemaioBJiDYkvkx74pTiTr9+YupNxQLK8F
	 rz5RHVzbW4bBYKxh5nyMODvXXmIYvJS3DB65gwqyMSJvM3wUZw/6uqpQTB/gIvOiXG
	 Gs3FPiwr7oo7A==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Date: Tue, 12 Aug 2025 13:13:26 -0700
Message-Id: <20250812201326.60843-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: BE4AF20003
X-Stat-Signature: 3emej8uh6tr7udemy55dfgkxgce54xff
X-HE-Tag: 1755029610-2172
X-HE-Meta: U2FsdGVkX1/Rrd6bo4frsVXFJSxQupqbiGGLWiWjRV1e6IScZ2r9Jju6+5I5oh8Dq+MxIpeMRW0OD2HNczhosn2E9H4+BaaMuI7tGbJv/+ZxNnumU3fT4AcB8i8N8siuOB0o4+5yTMSGxo3PpGhjBAUyPJ0PA8z1lTxuAa3ax+XPDGWkrvCR8YkUnZ6Mt8hTPJ7ZOKFWU4ybgDpY9sdLjQHvvfAdMd/SeecVYUTX7rhHysEYPrtIPiqYOYDPeFVMaU0igyiBBMaDrDwW43fYhlV+SAe4siKvfomnZxtAxMgNLqPgh0adI7ATKhKUZRDzk8Nq0ZAaOXHq1UxsoAchaTKRrozPlW1QPhg+qo197divw72qn1QlPcLiL9jvfFlZVmloy3vsb32uJZQ9g4+j4yZZwgy/mHRjq0cOgmyogbelVXOcyX7p0THm/bD1KAMN5UM1OiT0oooGoiec++RQ40UzHTsgu5vLSeSueV9EhIew3/iswzhKJyBdXMdcYfme7lovnBD8jXeJ3aYynyX/eMSVBxY2nW2OJpJKe1OwtIz13GU9NJtLNLgQCKzOLFtD3AVU1pz36buhya0WYC1D6ptBEEahJidnrfE3n5jXyP8tiliVflp0/pYqRtaov6zXvhf1ekfzywtk/kHj39bSbFyCaRXsy07AgAGjw42h7DLZCCR8fYoUL12mcmDRp5QGUxolk9gKFcfGooCkkBn/ABiOIWLuippceiNsnQZtpx5JBrTzRJlAUtT6ue7xAx5Kwfde1sBNB3ta4Vo3or08vdwwF6P5Ozi8VYND9aF8Sv917PNV6PCVvg7Q9DhsVZmGhwpwefRA81EUOSgeKRsP+n7xDb5z7D/71kq3/hqiFrlqOWPt6f7RKcb3IeRFL7Cu/PVgXnRPHToo68g7qvX9GrmsP2FBYsrUwG64YewzmT3piM5cXH2h2k+ky27P43y02qcQAyvgOOsgwVZ/THG
 J+udKwEr
 EXTnF99AA9PM1qaoHYJrZFsILGbiUh4rk8TUhFJmTW87DJ3VePXmQzCNQvPAx3AEYqDIiGGtYeI9kMTOzOdMm6hv4+ePvtoD6BimPKR2unmUliR9rw3FfdVmF+7GUMFC2qVdlcY1uP60h+xh0lEPEqab2UHInRAi1wm27nEKctPrX6eNMljm/MkofJWqNBhD0yn9fwtsbhAC2pfAYhU3mkzYnraPZUFRKiS8EvM2pxJlCIXlKhlOwBpaQwz9LW/4K9A+eZV3xV9sS246xogXM2zavFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 16:44:09 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> We are currently in the bizarre situation where we are constrained on the
> number of flags we can set in an mm_struct based on whether this is a
> 32-bit or 64-bit kernel.
> 
> This is because mm->flags is an unsigned long field, which is 32-bits on a
> 32-bit system and 64-bits on a 64-bit system.
> 
> In order to keep things functional across both architectures, we do not
> permit mm flag bits to be set above flag 31 (i.e. the 32nd bit).
> 
> This is a silly situation, especially given how profligate we are in
> storing metadata in mm_struct, so let's convert mm->flags into a bitmap and
> allow ourselves as many bits as we like.

I like this conversion.

[...]
> 
> In order to execute this change, we introduce a new opaque type -
> mm_flags_t - which wraps a bitmap.

I have no strong opinion here, but I think coding-style.rst[1] has one?  To
quote,

    Please don't use things like ``vps_t``.
    It's a **mistake** to use typedef for structures and pointers. 

checkpatch.pl also complains similarly.

Again, I have no strong opinion, but I think adding a clarification about why
we use typedef despite of the documented recommendation here might be nice?

[...]
> For mm->flags initialisation on fork, we adjust the logic to ensure all
> bits are cleared correctly, and then adjust the existing intialisation

Nit.  s/intialisation/initialisation/ ?

[...]

[1] https://docs.kernel.org/process/coding-style.html#typedefs


Thanks,
SJ

