Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49DB7606A332
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=alzL5p/E
Received: by kanga.kvack.org (Postfix)
	id 4ED836B05C8; Mon,  9 Nov 2026 12:50:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C52F6B05C9; Mon,  9 Nov 2026 12:50:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D056B05CA; Mon,  9 Nov 2026 12:50:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0416B05C8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:50:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5886A82FD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:50:38 +0000 (UTC)
X-FDA: 85416320556.20.10F6748
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5D701C000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:50:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="alzL5p/E";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794246637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Y+apbv0moZAbIC2JZwKUuLxptoIhomU3mV95VqD+l4=;
	b=qHmTTfeXi1QfAe/aZY9E8SmFXJpToA2+WTR9XKM+mrS5dZzx1JPSEGX+ssJKFpRJY00aq2
	RdHt2VP7uXLjMOQP6ahX8Tyyj7k5PwmfM/uuTsSTjK0RAQe0OXc7gdxFRubZVaKLEOSWSx
	J4wnH2Qg/ZN7z+cCo3+LqNh9F+aKOV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794246637;
	b=YF9aEXIzss+PEUGuV3K+XvSy3ButjsWkG7zFNn9QcFmey8tUYt84RlAq0bogDe7sA0Squd
	9evARMuO0AvFYSAKeeTntD2qBMsuJSYRHYOKjnpD0qWdQctKVXFEeSx+HL4tiwfFp8epF3
	Uvy+JlTBsWSnhaX0TdAfZ2pbyQdHRAo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="alzL5p/E";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47F5D60A95;
	Mon,  9 Nov 2026 17:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BE51F0089F;
	Mon,  9 Nov 2026 17:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246636;
	bh=4Y+apbv0moZAbIC2JZwKUuLxptoIhomU3mV95VqD+l4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=alzL5p/E5TFjU0f4S3NCoMGJBvZNjLceDHvjdf7oUnrtQutT9d/lual9TYbQaYsV8
	 BIDjLsHSLUcOK6q2LAzWt3YlvV/WiGiPoNNU3sNfH3m3TbLCyeOWWakP21fgtRFZY7
	 MuUKvUaoZ86WAElRGG65TDNBtS7Dp15/zVMHHz1w=
Date: Mon, 9 Nov 2026 09:50:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo
 <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang
 <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul
 Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
 <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Xu Xin
 <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Leon Romanovsky
 <leon@kernel.org>, SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
 David Rientjes <rientjes@google.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, John Johansen
 <john.johansen@canonical.com>, Georgia Garcia
 <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, James
 Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg
 <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Ondrej =?UTF-8?Q?Mosn=C3=A1=C4=8Dek?=
 <omosnacek@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, damon@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 00/13] mm: continue vma_flags_t conversion
Message-Id: <20261109095033.ed2b0334c862ca832389ea7d@linux-foundation.org>
In-Reply-To: <ab4be2bc-8959-4c09-a120-37e216279dae@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
	<d0ea7929-7c12-4245-ba3f-6dd5c0269e6b@kernel.org>
	<au3r0-geuwtRYPiC@gremlin>
	<1c0b1368-a381-4b25-bba9-7a4f8e92b764@kernel.org>
	<au-DXpEi4wHwsz0r@gremlin>
	<93fef824-9f60-4940-9ee6-80c9c8e3f945@kernel.org>
	<20261109094434.d23a227a869e76455ddff3b1@linux-foundation.org>
	<ab4be2bc-8959-4c09-a120-37e216279dae@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oqura8ar5ozu8npanh7uz7qpcb9nnc1a
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D5D701C000E
X-HE-Tag: 1794246636-247130
X-HE-Meta: U2FsdGVkX1/oE/LjSwbwshwmF3DVjD6XCMB/kdWU479DLSn5+G2D59IRsSb489gGVpM8ySkY/uxnYueXpacd7yBPSpnI5Z3s16yaaRkKcOsI27yYelCU0flyotdMN70SISAbhZf62vMKFb8WUZ4GaBaIq/DO+yZ5Za42Hyf3bATZZiw+fjDNuDyoG2W9mYTg/cdu8Bw6tKNgmU/6n+nW6CkftHueZTK/RCNqQiK2orgW0Bu2jd6r3grUJJk7nttafH1hzVKIfILVZwpDnzmOcCyipZ0TgD1/mGZOkwuhRKl2k8CBhlj+qdGay7eMtviY5F0o2bwYdeWpT+hxWnrRI0jnRJSSBzlqc1BvxZFN+A2nypKgp+JjNu+HnPUAxg1ZZAdW0JAs22razotbCk+WQl5ov1db9r37iU2KJ4OTt2POKEpzJAiVPBPsOT1XxYAXmfiJkvK7ejC7nPDMblx2+gUelB6x/pfKEiAbhJgrpO9JNoBJlJfE+YkWCH0ZSlBR2waRJlhK/ybL17nxdlSaYSGFnq0qMcdfURxAKFf2qbtnkTlgdUZK7ukX7tFLr68KWdgaDH9thgnOdtOZRx+cY8845vPSyhPREAXGzKgC41pi80O2jb2rmsGIEURouX/XKgjjlOqFb07YnwTGEkZqxCH+PUbK/VFN/vGvoh5k7q9xKMPcE48AYwo45VIB+Ts6GSl9s/AlNOIj7uleVg3Y6rQGMc8vViLKk7tzRPvyNDvG7X89CrYgI6WtMXyV+0ZQyvaqkRaJqcfYPoMw5T80K0XaKvCeHzAUTpuF01PG8Uxee8Szu+N9YjlhzT6b2UbNROjWmpGHxiq534MSkC/ZKy5dJh1GrVztgTuNEVrDQYXaE0GpUPknhXYdRnubvhvbCuSnsgI9tiNSXFaSUwAGeojI/CUArbJdJSD9/r2Wx2k4FHvX+QCAGSw8I6QzMLzP6bnXiogk9mnvEL6eM9B
 NKzuNL6l
 0hxCZQz9ptTVux4RFZ822SO432/mTm8ykxQ3OCVEtOZAH81smNiTx7IYJ2ynx1GgO8kSjnljThuIS4hPOTGOwKrAa2BwQuHCWhPEmRTcrH3yCMGYTWh/QAOrnnJwsjmK5TKLWOsYiDurSfltHMux5G3Ycc5RmQh29YwYHh6zG3+9R/K2K6e8PJo+fAr4RVv0dp659hJR2ZBLrvL3OJZWmoT5JOoH6VadjbvZ9KmUWXdanNjS6drUKBkm72HxPothV2jtUqB5Y2BQNigF6+W7GvE6T5TpXpiFSpYfOtaDQa0+9TG5Eo+EGQehqnWOncb2wDjka6///KyZDw3G2LrLVcNYBub+7m7vxN228or2lb/Kz4dAAH3stk+T8nQF6+Z6hjiQuuw09kyvOYpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 18:48:07 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 11/9/26 18:44, Andrew Morton wrote:
> > On Mon, 9 Nov 2026 14:40:48 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > 
> >> On 11/7/26 21:09, Lorenzo Stoakes (ARM) wrote:
> >>> I think we're slightly talking across purposes, so to be clear - I am totally
> >>> fine with you taking any of this through your tree or whatever works for you and
> >>> Andrew to avoid merge pain :)
> >>>
> >>> I was just talking more generally about how to merge series that touch a lot of
> >>> subsystems and maintainers-who-may-never-reply, etc.
> >>>
> >>> These are the edge cases that make things... fun :)
> >>>
> >>> Anyway, I guess easiest resolution here is for you to take the bits that belong
> >>> to your trees and Andrew takes the bits that belong elsewhere?
> >>
> >> Yes, that's what I did now, applying #1,#3,#4,#5,#6
> > 
> > Cool.
> > 
> > I'll remove the whole series from mm.git immediately for
> > collision-avoidance reasons - let's sort things out later.
> 
> The mm-next merge today still worked (minor conflict on #7 due to one
> unnecessary ksm.c hunk I commented on), so you could have likely just kept all
> but the above patches.

OK, I'll take a look at re-adding things...

> > 
> > I'll get better/more accurate about this soon - I need to set up
> > infrastructure to fetch everyone else's trees, do test merges and
> > figure out what should be removed/fixed in mm.git.  I might just base
> > mm.git on everyone-else and always route its stuff ->david.  I need to
> > spend a bit of time on this and discuss with the mm-next peeps.
> 
> Ack!

...once this is in place!

