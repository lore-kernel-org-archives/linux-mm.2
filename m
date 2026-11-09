Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2277606A332
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gzaCyMM1
Received: by kanga.kvack.org (Postfix)
	id EA5666B05C2; Mon,  9 Nov 2026 12:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2FC26B05C3; Mon,  9 Nov 2026 12:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EB66B05C4; Mon,  9 Nov 2026 12:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A47326B05C2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:44:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F98B1A04A2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:44:40 +0000 (UTC)
X-FDA: 85416305520.24.46B3DE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 443941C0009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:44:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gzaCyMM1;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794246278;
	b=1NwnlYhUHlW8MfWUZqA9GZq6Rz6rPpn8yDHykmvghdIoxsbSD6RJ5Y5CWh/Jo3ubGNuOza
	f9FBsmM3lI3DeL5SDXz/aSF4EXWNwTh6fFvXteAUcNV3+YeVmV0VcUHdJaJWeUoypOO/5q
	CwEYH0K4zMOLIKUWq/vtTpzCMPDoDgw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gzaCyMM1;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794246278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EpjN/DsBpVyfyR8n/gQ0lrO4LV9kbgQU5k49WPSPeE=;
	b=RoGa6rRg/6E3FQ7+u5So1yXS8NDa8+zXfUPURNWX/StgCb5smWWBKBJ2jy+cFlDXSV3MDH
	ckbz+TPWBY9g3kKSqbbvCEE4Gv/q8fGWVmAx8SS2oCHA+sZivoKblQwXZkMoQ2yG9Lw2yE
	h0TGa5a0x1p9s+TX+gXmxyJjv6dy2sU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A29806347D;
	Mon,  9 Nov 2026 17:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2301F0089F;
	Mon,  9 Nov 2026 17:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246277;
	bh=+EpjN/DsBpVyfyR8n/gQ0lrO4LV9kbgQU5k49WPSPeE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gzaCyMM1cJrjP8mVfAdfm9Tk0MNbUwWsCzu5aBYFwIXvHqXzHyjNWYvmsk0qAwsED
	 GA9iUPuLXd53UNdhLXbucDDSJCBnpyT4AdCqpMXhvrVqGpYP2eidMHAWz42rUr0Xzx
	 9ZMkq6R2Q8unfhnRO7BxhFf1Z4gUeAYDiBZoVcbY=
Date: Mon, 9 Nov 2026 09:44:34 -0800
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
Message-Id: <20261109094434.d23a227a869e76455ddff3b1@linux-foundation.org>
In-Reply-To: <93fef824-9f60-4940-9ee6-80c9c8e3f945@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
	<d0ea7929-7c12-4245-ba3f-6dd5c0269e6b@kernel.org>
	<au3r0-geuwtRYPiC@gremlin>
	<1c0b1368-a381-4b25-bba9-7a4f8e92b764@kernel.org>
	<au-DXpEi4wHwsz0r@gremlin>
	<93fef824-9f60-4940-9ee6-80c9c8e3f945@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 443941C0009
X-Stat-Signature: qdpp8nyhts88omzsipd3p81udqoeyddd
X-Rspam-User: 
X-HE-Tag: 1794246278-277538
X-HE-Meta: U2FsdGVkX19VcJS2GVGKEwo4TJe2svV/7tT5B63rW2jdHEdBTITCNZCx+LLqPqn2+Aw/MYMz2SX570oKj4eq/aakwUl2L0IhTDOzjz2/qNQ9Gza2aMcO00n89puLYFVz1YUZZgLPPyGGYNrDWhDtnOj+n7TsWqPpsRD8bvy2F9AQXbYnLBlHIVh6hBNA0DMPfSOmlI7OradhSVMkrG0GPnz/u4aCl7xTDedMRkAOKLqn/V+kScfi0xcHoVtk0/VR3XkamZlJ5lHRHvSIOHqJJPWJ1BJvYCA9ErHRb5AODfyfQei7RnwcFKIMO7iWQ5DV1YVQJ0QSAIIhUe7sx2VMRTetUihB7zoBBgb+jjDCucrd7GKUlyqYx3aIRMYfHdu9z2qVrbjhG3ybbHbDClzeC7nIFaep/R+r+URx3AID7HOPANcgC+KcjKEFt3KlNBse0qB0dTxj4nuDWdsuwh1M0UEN7BvkuwNoHeKCcrQ2qaD0u/zjKMinZUZ6oCX1NKaDf412jY0TaldkdlnQhQqaHVCJRGs3e6o65v1QNDFRio6QxZOUKQ6ROEMMVVw23AFv9J8DEQJ0PMVuA7zeWaxAsnKv9ue80wlYHMMdmOdi4CqW3BfcV+R50c5T1A8M+x3IEzP+xjmS0uG/v84gGt0vgyLZISH4PWYltBxVo7vpc4VVrURwAxWfuFoJWwiWWY+MgJZt+MX3bp2qydU2RgnwwmhdWtxbKTt2DvtbsmPuQ/t4mQLhFYO/5F7N2sKvzO0FvobJLoRgFA/gHamSyRu8AKkSQ6T0GgkIftt/HnvQR1fNjEXKYlsF2wSQl6KpWhyft3ZMVgNtkFpTiU40juHyP4OkQnb37v+sqBAOOjCShtGpe5V1fWaRHQk38CnJoA8iOnMQJtqo/PZHr+h+uu5fWUO6Cid+15LjZuVryfO7W40bWTRPoRwcDE3lXt5g5UvgaZg8dTjmDTaF85ROM8a
 IbQhlyR+
 d75FXA1B3nXkFYIaIVMLeY3acxShU1eo3sow1sGhyNubS/rIL4WH11euh8VAmBiUzwAR6YVeqLwl2CTW94AsIOwTof/xnt7ILBSRcyhxE6hdQaP1blHSuoIwQjLlmY9s8dQRBNeUJYZ3T1bGedEFlO8TcsdRu8DiOE0LPoghjXfDsUS5TawwfvZDchUp9LEoviVlDXNyrJDqR/CGB56C4zE0kWhqmubjikcPcVtG5fJjqpf5k0jQOAljrm7jdbBqMKKcrDg/YKH12IM3ms40DqmpU/XhYG0miXNqCN/kTJLURR/y8YJX8lFK3NgbvtZJ32kM4DMrnDQTidLfP3PFsQsKVTTZc8q8jybpIAfwewskF7zK5aclWpmpOIMg2SN/xa8JbidNPZSE0gLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 14:40:48 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 11/7/26 21:09, Lorenzo Stoakes (ARM) wrote:
> > I think we're slightly talking across purposes, so to be clear - I am totally
> > fine with you taking any of this through your tree or whatever works for you and
> > Andrew to avoid merge pain :)
> > 
> > I was just talking more generally about how to merge series that touch a lot of
> > subsystems and maintainers-who-may-never-reply, etc.
> > 
> > These are the edge cases that make things... fun :)
> > 
> > Anyway, I guess easiest resolution here is for you to take the bits that belong
> > to your trees and Andrew takes the bits that belong elsewhere?
> 
> Yes, that's what I did now, applying #1,#3,#4,#5,#6

Cool.

I'll remove the whole series from mm.git immediately for
collision-avoidance reasons - let's sort things out later.

I'll get better/more accurate about this soon - I need to set up
infrastructure to fetch everyone else's trees, do test merges and
figure out what should be removed/fixed in mm.git.  I might just base
mm.git on everyone-else and always route its stuff ->david.  I need to
spend a bit of time on this and discuss with the mm-next peeps.


